1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     /**
14      * @dev Returns the largest of two numbers.
15      */
16     function max(uint256 a, uint256 b) internal pure returns (uint256) {
17         return a >= b ? a : b;
18     }
19 
20     /**
21      * @dev Returns the smallest of two numbers.
22      */
23     function min(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a < b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the average of two numbers. The result is rounded towards
29      * zero.
30      */
31     function average(uint256 a, uint256 b) internal pure returns (uint256) {
32         // (a + b) / 2 can overflow, so we distribute
33         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
34     }
35 }
36 
37 
38 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
39 
40 pragma solidity >=0.6.0 <0.8.0;
41 
42 /**
43  * @dev Contract module that helps prevent reentrant calls to a function.
44  *
45  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
46  * available, which can be applied to functions to make sure there are no nested
47  * (reentrant) calls to them.
48  *
49  * Note that because there is a single `nonReentrant` guard, functions marked as
50  * `nonReentrant` may not call one another. This can be worked around by making
51  * those functions `private`, and then adding `external` `nonReentrant` entry
52  * points to them.
53  *
54  * TIP: If you would like to learn more about reentrancy and alternative ways
55  * to protect against it, check out our blog post
56  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
57  */
58 abstract contract ReentrancyGuard {
59     // Booleans are more expensive than uint256 or any type that takes up a full
60     // word because each write operation emits an extra SLOAD to first read the
61     // slot's contents, replace the bits taken up by the boolean, and then write
62     // back. This is the compiler's defense against contract upgrades and
63     // pointer aliasing, and it cannot be disabled.
64 
65     // The values being non-zero value makes deployment a bit more expensive,
66     // but in exchange the refund on every call to nonReentrant will be lower in
67     // amount. Since refunds are capped to a percentage of the total
68     // transaction's gas, it is best to keep them low in cases like this one, to
69     // increase the likelihood of the full refund coming into effect.
70     uint256 private constant _NOT_ENTERED = 1;
71     uint256 private constant _ENTERED = 2;
72 
73     uint256 private _status;
74 
75     constructor () internal {
76         _status = _NOT_ENTERED;
77     }
78 
79     /**
80      * @dev Prevents a contract from calling itself, directly or indirectly.
81      * Calling a `nonReentrant` function from another `nonReentrant`
82      * function is not supported. It is possible to prevent this from happening
83      * by making the `nonReentrant` function external, and make it call a
84      * `private` function that does the actual work.
85      */
86     modifier nonReentrant() {
87         // On the first call to nonReentrant, _notEntered will be true
88         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
89 
90         // Any calls to nonReentrant after this point will fail
91         _status = _ENTERED;
92 
93         _;
94 
95         // By storing the original value once again, a refund is triggered (see
96         // https://eips.ethereum.org/EIPS/eip-2200)
97         _status = _NOT_ENTERED;
98     }
99 }
100 
101 
102 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
103 
104 pragma solidity >=0.6.2 <0.8.0;
105 
106 /**
107  * @dev Collection of functions related to the address type
108  */
109 library Address {
110     /**
111      * @dev Returns true if `account` is a contract.
112      *
113      * [IMPORTANT]
114      * ====
115      * It is unsafe to assume that an address for which this function returns
116      * false is an externally-owned account (EOA) and not a contract.
117      *
118      * Among others, `isContract` will return false for the following
119      * types of addresses:
120      *
121      *  - an externally-owned account
122      *  - a contract in construction
123      *  - an address where a contract will be created
124      *  - an address where a contract lived, but was destroyed
125      * ====
126      */
127     function isContract(address account) internal view returns (bool) {
128         // This method relies on extcodesize, which returns 0 for contracts in
129         // construction, since the code is only stored at the end of the
130         // constructor execution.
131 
132         uint256 size;
133         // solhint-disable-next-line no-inline-assembly
134         assembly { size := extcodesize(account) }
135         return size > 0;
136     }
137 
138     /**
139      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
140      * `recipient`, forwarding all available gas and reverting on errors.
141      *
142      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
143      * of certain opcodes, possibly making contracts go over the 2300 gas limit
144      * imposed by `transfer`, making them unable to receive funds via
145      * `transfer`. {sendValue} removes this limitation.
146      *
147      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
148      *
149      * IMPORTANT: because control is transferred to `recipient`, care must be
150      * taken to not create reentrancy vulnerabilities. Consider using
151      * {ReentrancyGuard} or the
152      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
153      */
154     function sendValue(address payable recipient, uint256 amount) internal {
155         require(address(this).balance >= amount, "Address: insufficient balance");
156 
157         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
158         (bool success, ) = recipient.call{ value: amount }("");
159         require(success, "Address: unable to send value, recipient may have reverted");
160     }
161 
162     /**
163      * @dev Performs a Solidity function call using a low level `call`. A
164      * plain`call` is an unsafe replacement for a function call: use this
165      * function instead.
166      *
167      * If `target` reverts with a revert reason, it is bubbled up by this
168      * function (like regular Solidity function calls).
169      *
170      * Returns the raw returned data. To convert to the expected return value,
171      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
172      *
173      * Requirements:
174      *
175      * - `target` must be a contract.
176      * - calling `target` with `data` must not revert.
177      *
178      * _Available since v3.1._
179      */
180     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
181       return functionCall(target, data, "Address: low-level call failed");
182     }
183 
184     /**
185      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
186      * `errorMessage` as a fallback revert reason when `target` reverts.
187      *
188      * _Available since v3.1._
189      */
190     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
191         return functionCallWithValue(target, data, 0, errorMessage);
192     }
193 
194     /**
195      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
196      * but also transferring `value` wei to `target`.
197      *
198      * Requirements:
199      *
200      * - the calling contract must have an ETH balance of at least `value`.
201      * - the called Solidity function must be `payable`.
202      *
203      * _Available since v3.1._
204      */
205     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
206         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
207     }
208 
209     /**
210      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
211      * with `errorMessage` as a fallback revert reason when `target` reverts.
212      *
213      * _Available since v3.1._
214      */
215     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
216         require(address(this).balance >= value, "Address: insufficient balance for call");
217         require(isContract(target), "Address: call to non-contract");
218 
219         // solhint-disable-next-line avoid-low-level-calls
220         (bool success, bytes memory returndata) = target.call{ value: value }(data);
221         return _verifyCallResult(success, returndata, errorMessage);
222     }
223 
224     /**
225      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
226      * but performing a static call.
227      *
228      * _Available since v3.3._
229      */
230     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
231         return functionStaticCall(target, data, "Address: low-level static call failed");
232     }
233 
234     /**
235      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
236      * but performing a static call.
237      *
238      * _Available since v3.3._
239      */
240     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
241         require(isContract(target), "Address: static call to non-contract");
242 
243         // solhint-disable-next-line avoid-low-level-calls
244         (bool success, bytes memory returndata) = target.staticcall(data);
245         return _verifyCallResult(success, returndata, errorMessage);
246     }
247 
248     /**
249      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
250      * but performing a delegate call.
251      *
252      * _Available since v3.4._
253      */
254     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
255         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
256     }
257 
258     /**
259      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
260      * but performing a delegate call.
261      *
262      * _Available since v3.4._
263      */
264     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
265         require(isContract(target), "Address: delegate call to non-contract");
266 
267         // solhint-disable-next-line avoid-low-level-calls
268         (bool success, bytes memory returndata) = target.delegatecall(data);
269         return _verifyCallResult(success, returndata, errorMessage);
270     }
271 
272     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
273         if (success) {
274             return returndata;
275         } else {
276             // Look for revert reason and bubble it up if present
277             if (returndata.length > 0) {
278                 // The easiest way to bubble the revert reason is using memory via assembly
279 
280                 // solhint-disable-next-line no-inline-assembly
281                 assembly {
282                     let returndata_size := mload(returndata)
283                     revert(add(32, returndata), returndata_size)
284                 }
285             } else {
286                 revert(errorMessage);
287             }
288         }
289     }
290 }
291 
292 
293 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
294 
295 pragma solidity >=0.6.0 <0.8.0;
296 
297 /**
298  * @dev Interface of the ERC20 standard as defined in the EIP.
299  */
300 interface IERC20 {
301     /**
302      * @dev Returns the amount of tokens in existence.
303      */
304     function totalSupply() external view returns (uint256);
305 
306     /**
307      * @dev Returns the amount of tokens owned by `account`.
308      */
309     function balanceOf(address account) external view returns (uint256);
310 
311     /**
312      * @dev Moves `amount` tokens from the caller's account to `recipient`.
313      *
314      * Returns a boolean value indicating whether the operation succeeded.
315      *
316      * Emits a {Transfer} event.
317      */
318     function transfer(address recipient, uint256 amount) external returns (bool);
319 
320     /**
321      * @dev Returns the remaining number of tokens that `spender` will be
322      * allowed to spend on behalf of `owner` through {transferFrom}. This is
323      * zero by default.
324      *
325      * This value changes when {approve} or {transferFrom} are called.
326      */
327     function allowance(address owner, address spender) external view returns (uint256);
328 
329     /**
330      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
331      *
332      * Returns a boolean value indicating whether the operation succeeded.
333      *
334      * IMPORTANT: Beware that changing an allowance with this method brings the risk
335      * that someone may use both the old and the new allowance by unfortunate
336      * transaction ordering. One possible solution to mitigate this race
337      * condition is to first reduce the spender's allowance to 0 and set the
338      * desired value afterwards:
339      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
340      *
341      * Emits an {Approval} event.
342      */
343     function approve(address spender, uint256 amount) external returns (bool);
344 
345     /**
346      * @dev Moves `amount` tokens from `sender` to `recipient` using the
347      * allowance mechanism. `amount` is then deducted from the caller's
348      * allowance.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
358      * another (`to`).
359      *
360      * Note that `value` may be zero.
361      */
362     event Transfer(address indexed from, address indexed to, uint256 value);
363 
364     /**
365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
366      * a call to {approve}. `value` is the new allowance.
367      */
368     event Approval(address indexed owner, address indexed spender, uint256 value);
369 }
370 
371 
372 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
373 
374 pragma solidity >=0.6.0 <0.8.0;
375 
376 /**
377  * @dev Wrappers over Solidity's arithmetic operations with added overflow
378  * checks.
379  *
380  * Arithmetic operations in Solidity wrap on overflow. This can easily result
381  * in bugs, because programmers usually assume that an overflow raises an
382  * error, which is the standard behavior in high level programming languages.
383  * `SafeMath` restores this intuition by reverting the transaction when an
384  * operation overflows.
385  *
386  * Using this library instead of the unchecked operations eliminates an entire
387  * class of bugs, so it's recommended to use it always.
388  */
389 library SafeMath {
390     /**
391      * @dev Returns the addition of two unsigned integers, with an overflow flag.
392      *
393      * _Available since v3.4._
394      */
395     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
396         uint256 c = a + b;
397         if (c < a) return (false, 0);
398         return (true, c);
399     }
400 
401     /**
402      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
403      *
404      * _Available since v3.4._
405      */
406     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
407         if (b > a) return (false, 0);
408         return (true, a - b);
409     }
410 
411     /**
412      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
413      *
414      * _Available since v3.4._
415      */
416     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
417         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
418         // benefit is lost if 'b' is also tested.
419         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
420         if (a == 0) return (true, 0);
421         uint256 c = a * b;
422         if (c / a != b) return (false, 0);
423         return (true, c);
424     }
425 
426     /**
427      * @dev Returns the division of two unsigned integers, with a division by zero flag.
428      *
429      * _Available since v3.4._
430      */
431     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
432         if (b == 0) return (false, 0);
433         return (true, a / b);
434     }
435 
436     /**
437      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
438      *
439      * _Available since v3.4._
440      */
441     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
442         if (b == 0) return (false, 0);
443         return (true, a % b);
444     }
445 
446     /**
447      * @dev Returns the addition of two unsigned integers, reverting on
448      * overflow.
449      *
450      * Counterpart to Solidity's `+` operator.
451      *
452      * Requirements:
453      *
454      * - Addition cannot overflow.
455      */
456     function add(uint256 a, uint256 b) internal pure returns (uint256) {
457         uint256 c = a + b;
458         require(c >= a, "SafeMath: addition overflow");
459         return c;
460     }
461 
462     /**
463      * @dev Returns the subtraction of two unsigned integers, reverting on
464      * overflow (when the result is negative).
465      *
466      * Counterpart to Solidity's `-` operator.
467      *
468      * Requirements:
469      *
470      * - Subtraction cannot overflow.
471      */
472     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b <= a, "SafeMath: subtraction overflow");
474         return a - b;
475     }
476 
477     /**
478      * @dev Returns the multiplication of two unsigned integers, reverting on
479      * overflow.
480      *
481      * Counterpart to Solidity's `*` operator.
482      *
483      * Requirements:
484      *
485      * - Multiplication cannot overflow.
486      */
487     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
488         if (a == 0) return 0;
489         uint256 c = a * b;
490         require(c / a == b, "SafeMath: multiplication overflow");
491         return c;
492     }
493 
494     /**
495      * @dev Returns the integer division of two unsigned integers, reverting on
496      * division by zero. The result is rounded towards zero.
497      *
498      * Counterpart to Solidity's `/` operator. Note: this function uses a
499      * `revert` opcode (which leaves remaining gas untouched) while Solidity
500      * uses an invalid opcode to revert (consuming all remaining gas).
501      *
502      * Requirements:
503      *
504      * - The divisor cannot be zero.
505      */
506     function div(uint256 a, uint256 b) internal pure returns (uint256) {
507         require(b > 0, "SafeMath: division by zero");
508         return a / b;
509     }
510 
511     /**
512      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
513      * reverting when dividing by zero.
514      *
515      * Counterpart to Solidity's `%` operator. This function uses a `revert`
516      * opcode (which leaves remaining gas untouched) while Solidity uses an
517      * invalid opcode to revert (consuming all remaining gas).
518      *
519      * Requirements:
520      *
521      * - The divisor cannot be zero.
522      */
523     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
524         require(b > 0, "SafeMath: modulo by zero");
525         return a % b;
526     }
527 
528     /**
529      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
530      * overflow (when the result is negative).
531      *
532      * CAUTION: This function is deprecated because it requires allocating memory for the error
533      * message unnecessarily. For custom revert reasons use {trySub}.
534      *
535      * Counterpart to Solidity's `-` operator.
536      *
537      * Requirements:
538      *
539      * - Subtraction cannot overflow.
540      */
541     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
542         require(b <= a, errorMessage);
543         return a - b;
544     }
545 
546     /**
547      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
548      * division by zero. The result is rounded towards zero.
549      *
550      * CAUTION: This function is deprecated because it requires allocating memory for the error
551      * message unnecessarily. For custom revert reasons use {tryDiv}.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         return a / b;
564     }
565 
566     /**
567      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
568      * reverting with custom message when dividing by zero.
569      *
570      * CAUTION: This function is deprecated because it requires allocating memory for the error
571      * message unnecessarily. For custom revert reasons use {tryMod}.
572      *
573      * Counterpart to Solidity's `%` operator. This function uses a `revert`
574      * opcode (which leaves remaining gas untouched) while Solidity uses an
575      * invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
582         require(b > 0, errorMessage);
583         return a % b;
584     }
585 }
586 
587 
588 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
589 
590 pragma solidity >=0.6.0 <0.8.0;
591 
592 
593 
594 /**
595  * @title SafeERC20
596  * @dev Wrappers around ERC20 operations that throw on failure (when the token
597  * contract returns false). Tokens that return no value (and instead revert or
598  * throw on failure) are also supported, non-reverting calls are assumed to be
599  * successful.
600  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
601  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
602  */
603 library SafeERC20 {
604     using SafeMath for uint256;
605     using Address for address;
606 
607     function safeTransfer(IERC20 token, address to, uint256 value) internal {
608         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
609     }
610 
611     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
612         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
613     }
614 
615     /**
616      * @dev Deprecated. This function has issues similar to the ones found in
617      * {IERC20-approve}, and its usage is discouraged.
618      *
619      * Whenever possible, use {safeIncreaseAllowance} and
620      * {safeDecreaseAllowance} instead.
621      */
622     function safeApprove(IERC20 token, address spender, uint256 value) internal {
623         // safeApprove should only be called when setting an initial allowance,
624         // or when resetting it to zero. To increase and decrease it, use
625         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
626         // solhint-disable-next-line max-line-length
627         require((value == 0) || (token.allowance(address(this), spender) == 0),
628             "SafeERC20: approve from non-zero to non-zero allowance"
629         );
630         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
631     }
632 
633     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
634         uint256 newAllowance = token.allowance(address(this), spender).add(value);
635         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
636     }
637 
638     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
639         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
640         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
641     }
642 
643     /**
644      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
645      * on the return value: the return value is optional (but if data is returned, it must not be false).
646      * @param token The token targeted by the call.
647      * @param data The call data (encoded using abi.encode or one of its variants).
648      */
649     function _callOptionalReturn(IERC20 token, bytes memory data) private {
650         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
651         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
652         // the target address contains contract code and also asserts for success in the low-level call.
653 
654         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
655         if (returndata.length > 0) { // Return data is optional
656             // solhint-disable-next-line max-line-length
657             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
658         }
659     }
660 }
661 
662 
663 // File contracts/libraries/FixedPointMath.sol
664 
665 pragma solidity ^0.6.12;
666 
667 library FixedPointMath {
668   uint256 public constant DECIMALS = 18;
669   uint256 public constant SCALAR = 10**DECIMALS;
670 
671   struct uq192x64 {
672     uint256 x;
673   }
674 
675   function fromU256(uint256 value) internal pure returns (uq192x64 memory) {
676     uint256 x;
677     require(value == 0 || (x = value * SCALAR) / SCALAR == value);
678     return uq192x64(x);
679   }
680 
681   function maximumValue() internal pure returns (uq192x64 memory) {
682     return uq192x64(uint256(-1));
683   }
684 
685   function add(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
686     uint256 x;
687     require((x = self.x + value.x) >= self.x);
688     return uq192x64(x);
689   }
690 
691   function add(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
692     return add(self, fromU256(value));
693   }
694 
695   function sub(uq192x64 memory self, uq192x64 memory value) internal pure returns (uq192x64 memory) {
696     uint256 x;
697     require((x = self.x - value.x) <= self.x);
698     return uq192x64(x);
699   }
700 
701   function sub(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
702     return sub(self, fromU256(value));
703   }
704 
705   function mul(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
706     uint256 x;
707     require(value == 0 || (x = self.x * value) / value == self.x);
708     return uq192x64(x);
709   }
710 
711   function div(uq192x64 memory self, uint256 value) internal pure returns (uq192x64 memory) {
712     require(value != 0);
713     return uq192x64(self.x / value);
714   }
715 
716   function cmp(uq192x64 memory self, uq192x64 memory value) internal pure returns (int256) {
717     if (self.x < value.x) {
718       return -1;
719     }
720 
721     if (self.x > value.x) {
722       return 1;
723     }
724 
725     return 0;
726   }
727 
728   function decode(uq192x64 memory self) internal pure returns (uint256) {
729     return self.x / SCALAR;
730   }
731 }
732 
733 
734 // File contracts/interfaces/IDetailedERC20.sol
735 
736 pragma solidity ^0.6.12;
737 
738 interface IDetailedERC20 is IERC20 {
739   function name() external returns (string memory);
740   function symbol() external returns (string memory);
741   function decimals() external returns (uint8);
742 }
743 
744 
745 // File hardhat/console.sol@v2.1.1
746 
747 pragma solidity >= 0.4.22 <0.9.0;
748 
749 library console {
750 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
751 
752 	function _sendLogPayload(bytes memory payload) private view {
753 		uint256 payloadLength = payload.length;
754 		address consoleAddress = CONSOLE_ADDRESS;
755 		assembly {
756 			let payloadStart := add(payload, 32)
757 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
758 		}
759 	}
760 
761 	function log() internal view {
762 		_sendLogPayload(abi.encodeWithSignature("log()"));
763 	}
764 
765 	function logInt(int p0) internal view {
766 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
767 	}
768 
769 	function logUint(uint p0) internal view {
770 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
771 	}
772 
773 	function logString(string memory p0) internal view {
774 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
775 	}
776 
777 	function logBool(bool p0) internal view {
778 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
779 	}
780 
781 	function logAddress(address p0) internal view {
782 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
783 	}
784 
785 	function logBytes(bytes memory p0) internal view {
786 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
787 	}
788 
789 	function logBytes1(bytes1 p0) internal view {
790 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
791 	}
792 
793 	function logBytes2(bytes2 p0) internal view {
794 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
795 	}
796 
797 	function logBytes3(bytes3 p0) internal view {
798 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
799 	}
800 
801 	function logBytes4(bytes4 p0) internal view {
802 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
803 	}
804 
805 	function logBytes5(bytes5 p0) internal view {
806 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
807 	}
808 
809 	function logBytes6(bytes6 p0) internal view {
810 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
811 	}
812 
813 	function logBytes7(bytes7 p0) internal view {
814 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
815 	}
816 
817 	function logBytes8(bytes8 p0) internal view {
818 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
819 	}
820 
821 	function logBytes9(bytes9 p0) internal view {
822 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
823 	}
824 
825 	function logBytes10(bytes10 p0) internal view {
826 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
827 	}
828 
829 	function logBytes11(bytes11 p0) internal view {
830 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
831 	}
832 
833 	function logBytes12(bytes12 p0) internal view {
834 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
835 	}
836 
837 	function logBytes13(bytes13 p0) internal view {
838 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
839 	}
840 
841 	function logBytes14(bytes14 p0) internal view {
842 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
843 	}
844 
845 	function logBytes15(bytes15 p0) internal view {
846 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
847 	}
848 
849 	function logBytes16(bytes16 p0) internal view {
850 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
851 	}
852 
853 	function logBytes17(bytes17 p0) internal view {
854 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
855 	}
856 
857 	function logBytes18(bytes18 p0) internal view {
858 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
859 	}
860 
861 	function logBytes19(bytes19 p0) internal view {
862 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
863 	}
864 
865 	function logBytes20(bytes20 p0) internal view {
866 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
867 	}
868 
869 	function logBytes21(bytes21 p0) internal view {
870 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
871 	}
872 
873 	function logBytes22(bytes22 p0) internal view {
874 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
875 	}
876 
877 	function logBytes23(bytes23 p0) internal view {
878 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
879 	}
880 
881 	function logBytes24(bytes24 p0) internal view {
882 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
883 	}
884 
885 	function logBytes25(bytes25 p0) internal view {
886 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
887 	}
888 
889 	function logBytes26(bytes26 p0) internal view {
890 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
891 	}
892 
893 	function logBytes27(bytes27 p0) internal view {
894 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
895 	}
896 
897 	function logBytes28(bytes28 p0) internal view {
898 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
899 	}
900 
901 	function logBytes29(bytes29 p0) internal view {
902 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
903 	}
904 
905 	function logBytes30(bytes30 p0) internal view {
906 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
907 	}
908 
909 	function logBytes31(bytes31 p0) internal view {
910 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
911 	}
912 
913 	function logBytes32(bytes32 p0) internal view {
914 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
915 	}
916 
917 	function log(uint p0) internal view {
918 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
919 	}
920 
921 	function log(string memory p0) internal view {
922 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
923 	}
924 
925 	function log(bool p0) internal view {
926 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
927 	}
928 
929 	function log(address p0) internal view {
930 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
931 	}
932 
933 	function log(uint p0, uint p1) internal view {
934 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
935 	}
936 
937 	function log(uint p0, string memory p1) internal view {
938 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
939 	}
940 
941 	function log(uint p0, bool p1) internal view {
942 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
943 	}
944 
945 	function log(uint p0, address p1) internal view {
946 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
947 	}
948 
949 	function log(string memory p0, uint p1) internal view {
950 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
951 	}
952 
953 	function log(string memory p0, string memory p1) internal view {
954 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
955 	}
956 
957 	function log(string memory p0, bool p1) internal view {
958 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
959 	}
960 
961 	function log(string memory p0, address p1) internal view {
962 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
963 	}
964 
965 	function log(bool p0, uint p1) internal view {
966 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
967 	}
968 
969 	function log(bool p0, string memory p1) internal view {
970 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
971 	}
972 
973 	function log(bool p0, bool p1) internal view {
974 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
975 	}
976 
977 	function log(bool p0, address p1) internal view {
978 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
979 	}
980 
981 	function log(address p0, uint p1) internal view {
982 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
983 	}
984 
985 	function log(address p0, string memory p1) internal view {
986 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
987 	}
988 
989 	function log(address p0, bool p1) internal view {
990 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
991 	}
992 
993 	function log(address p0, address p1) internal view {
994 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
995 	}
996 
997 	function log(uint p0, uint p1, uint p2) internal view {
998 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
999 	}
1000 
1001 	function log(uint p0, uint p1, string memory p2) internal view {
1002 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
1003 	}
1004 
1005 	function log(uint p0, uint p1, bool p2) internal view {
1006 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
1007 	}
1008 
1009 	function log(uint p0, uint p1, address p2) internal view {
1010 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
1011 	}
1012 
1013 	function log(uint p0, string memory p1, uint p2) internal view {
1014 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
1015 	}
1016 
1017 	function log(uint p0, string memory p1, string memory p2) internal view {
1018 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
1019 	}
1020 
1021 	function log(uint p0, string memory p1, bool p2) internal view {
1022 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
1023 	}
1024 
1025 	function log(uint p0, string memory p1, address p2) internal view {
1026 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
1027 	}
1028 
1029 	function log(uint p0, bool p1, uint p2) internal view {
1030 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
1031 	}
1032 
1033 	function log(uint p0, bool p1, string memory p2) internal view {
1034 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
1035 	}
1036 
1037 	function log(uint p0, bool p1, bool p2) internal view {
1038 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
1039 	}
1040 
1041 	function log(uint p0, bool p1, address p2) internal view {
1042 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1043 	}
1044 
1045 	function log(uint p0, address p1, uint p2) internal view {
1046 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1047 	}
1048 
1049 	function log(uint p0, address p1, string memory p2) internal view {
1050 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1051 	}
1052 
1053 	function log(uint p0, address p1, bool p2) internal view {
1054 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1055 	}
1056 
1057 	function log(uint p0, address p1, address p2) internal view {
1058 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1059 	}
1060 
1061 	function log(string memory p0, uint p1, uint p2) internal view {
1062 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1063 	}
1064 
1065 	function log(string memory p0, uint p1, string memory p2) internal view {
1066 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1067 	}
1068 
1069 	function log(string memory p0, uint p1, bool p2) internal view {
1070 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1071 	}
1072 
1073 	function log(string memory p0, uint p1, address p2) internal view {
1074 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1075 	}
1076 
1077 	function log(string memory p0, string memory p1, uint p2) internal view {
1078 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1079 	}
1080 
1081 	function log(string memory p0, string memory p1, string memory p2) internal view {
1082 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1083 	}
1084 
1085 	function log(string memory p0, string memory p1, bool p2) internal view {
1086 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1087 	}
1088 
1089 	function log(string memory p0, string memory p1, address p2) internal view {
1090 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1091 	}
1092 
1093 	function log(string memory p0, bool p1, uint p2) internal view {
1094 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1095 	}
1096 
1097 	function log(string memory p0, bool p1, string memory p2) internal view {
1098 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1099 	}
1100 
1101 	function log(string memory p0, bool p1, bool p2) internal view {
1102 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1103 	}
1104 
1105 	function log(string memory p0, bool p1, address p2) internal view {
1106 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1107 	}
1108 
1109 	function log(string memory p0, address p1, uint p2) internal view {
1110 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1111 	}
1112 
1113 	function log(string memory p0, address p1, string memory p2) internal view {
1114 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1115 	}
1116 
1117 	function log(string memory p0, address p1, bool p2) internal view {
1118 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1119 	}
1120 
1121 	function log(string memory p0, address p1, address p2) internal view {
1122 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1123 	}
1124 
1125 	function log(bool p0, uint p1, uint p2) internal view {
1126 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1127 	}
1128 
1129 	function log(bool p0, uint p1, string memory p2) internal view {
1130 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1131 	}
1132 
1133 	function log(bool p0, uint p1, bool p2) internal view {
1134 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1135 	}
1136 
1137 	function log(bool p0, uint p1, address p2) internal view {
1138 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1139 	}
1140 
1141 	function log(bool p0, string memory p1, uint p2) internal view {
1142 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1143 	}
1144 
1145 	function log(bool p0, string memory p1, string memory p2) internal view {
1146 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1147 	}
1148 
1149 	function log(bool p0, string memory p1, bool p2) internal view {
1150 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1151 	}
1152 
1153 	function log(bool p0, string memory p1, address p2) internal view {
1154 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1155 	}
1156 
1157 	function log(bool p0, bool p1, uint p2) internal view {
1158 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1159 	}
1160 
1161 	function log(bool p0, bool p1, string memory p2) internal view {
1162 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1163 	}
1164 
1165 	function log(bool p0, bool p1, bool p2) internal view {
1166 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1167 	}
1168 
1169 	function log(bool p0, bool p1, address p2) internal view {
1170 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1171 	}
1172 
1173 	function log(bool p0, address p1, uint p2) internal view {
1174 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1175 	}
1176 
1177 	function log(bool p0, address p1, string memory p2) internal view {
1178 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1179 	}
1180 
1181 	function log(bool p0, address p1, bool p2) internal view {
1182 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1183 	}
1184 
1185 	function log(bool p0, address p1, address p2) internal view {
1186 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1187 	}
1188 
1189 	function log(address p0, uint p1, uint p2) internal view {
1190 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1191 	}
1192 
1193 	function log(address p0, uint p1, string memory p2) internal view {
1194 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1195 	}
1196 
1197 	function log(address p0, uint p1, bool p2) internal view {
1198 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1199 	}
1200 
1201 	function log(address p0, uint p1, address p2) internal view {
1202 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1203 	}
1204 
1205 	function log(address p0, string memory p1, uint p2) internal view {
1206 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1207 	}
1208 
1209 	function log(address p0, string memory p1, string memory p2) internal view {
1210 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1211 	}
1212 
1213 	function log(address p0, string memory p1, bool p2) internal view {
1214 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1215 	}
1216 
1217 	function log(address p0, string memory p1, address p2) internal view {
1218 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1219 	}
1220 
1221 	function log(address p0, bool p1, uint p2) internal view {
1222 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1223 	}
1224 
1225 	function log(address p0, bool p1, string memory p2) internal view {
1226 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1227 	}
1228 
1229 	function log(address p0, bool p1, bool p2) internal view {
1230 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1231 	}
1232 
1233 	function log(address p0, bool p1, address p2) internal view {
1234 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1235 	}
1236 
1237 	function log(address p0, address p1, uint p2) internal view {
1238 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1239 	}
1240 
1241 	function log(address p0, address p1, string memory p2) internal view {
1242 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1243 	}
1244 
1245 	function log(address p0, address p1, bool p2) internal view {
1246 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1247 	}
1248 
1249 	function log(address p0, address p1, address p2) internal view {
1250 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1251 	}
1252 
1253 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1254 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1255 	}
1256 
1257 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1258 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1259 	}
1260 
1261 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1262 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1263 	}
1264 
1265 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1266 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1267 	}
1268 
1269 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1270 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1271 	}
1272 
1273 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1274 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1275 	}
1276 
1277 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1278 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1279 	}
1280 
1281 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1282 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1283 	}
1284 
1285 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1286 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1287 	}
1288 
1289 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1290 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1291 	}
1292 
1293 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1294 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1295 	}
1296 
1297 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1298 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1299 	}
1300 
1301 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1302 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1303 	}
1304 
1305 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1306 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1307 	}
1308 
1309 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1310 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1311 	}
1312 
1313 	function log(uint p0, uint p1, address p2, address p3) internal view {
1314 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1315 	}
1316 
1317 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1318 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1319 	}
1320 
1321 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1322 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1323 	}
1324 
1325 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1326 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1327 	}
1328 
1329 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1330 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1331 	}
1332 
1333 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1334 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1335 	}
1336 
1337 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1338 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1339 	}
1340 
1341 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1342 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1343 	}
1344 
1345 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1346 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1347 	}
1348 
1349 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1350 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1351 	}
1352 
1353 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1354 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1355 	}
1356 
1357 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1358 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1359 	}
1360 
1361 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1362 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1363 	}
1364 
1365 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1366 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1367 	}
1368 
1369 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1370 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1371 	}
1372 
1373 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1374 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1375 	}
1376 
1377 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1378 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1379 	}
1380 
1381 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1382 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1383 	}
1384 
1385 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1386 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1387 	}
1388 
1389 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1390 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1391 	}
1392 
1393 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1394 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1395 	}
1396 
1397 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1398 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1399 	}
1400 
1401 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1402 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1403 	}
1404 
1405 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1406 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1407 	}
1408 
1409 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1410 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1411 	}
1412 
1413 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1414 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1415 	}
1416 
1417 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1418 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1419 	}
1420 
1421 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1422 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1423 	}
1424 
1425 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1426 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1427 	}
1428 
1429 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1430 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1431 	}
1432 
1433 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1434 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1435 	}
1436 
1437 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1438 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1439 	}
1440 
1441 	function log(uint p0, bool p1, address p2, address p3) internal view {
1442 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1443 	}
1444 
1445 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1446 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1447 	}
1448 
1449 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1450 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1451 	}
1452 
1453 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1454 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1455 	}
1456 
1457 	function log(uint p0, address p1, uint p2, address p3) internal view {
1458 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1459 	}
1460 
1461 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1462 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1463 	}
1464 
1465 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1466 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1467 	}
1468 
1469 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1470 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1471 	}
1472 
1473 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1474 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1475 	}
1476 
1477 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1478 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1479 	}
1480 
1481 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1482 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1483 	}
1484 
1485 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1486 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1487 	}
1488 
1489 	function log(uint p0, address p1, bool p2, address p3) internal view {
1490 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1491 	}
1492 
1493 	function log(uint p0, address p1, address p2, uint p3) internal view {
1494 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1495 	}
1496 
1497 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1498 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1499 	}
1500 
1501 	function log(uint p0, address p1, address p2, bool p3) internal view {
1502 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1503 	}
1504 
1505 	function log(uint p0, address p1, address p2, address p3) internal view {
1506 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1507 	}
1508 
1509 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1510 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1511 	}
1512 
1513 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1514 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1515 	}
1516 
1517 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1518 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1519 	}
1520 
1521 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1522 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1523 	}
1524 
1525 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1526 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1527 	}
1528 
1529 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1530 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1531 	}
1532 
1533 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1534 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1535 	}
1536 
1537 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1538 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1539 	}
1540 
1541 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1542 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1543 	}
1544 
1545 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1546 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1547 	}
1548 
1549 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1550 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1551 	}
1552 
1553 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1554 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1555 	}
1556 
1557 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1558 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1559 	}
1560 
1561 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1562 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1563 	}
1564 
1565 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1566 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1567 	}
1568 
1569 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1570 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1571 	}
1572 
1573 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1574 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1575 	}
1576 
1577 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1578 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1579 	}
1580 
1581 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1582 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1583 	}
1584 
1585 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1586 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1587 	}
1588 
1589 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1590 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1591 	}
1592 
1593 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1594 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1595 	}
1596 
1597 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1598 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1599 	}
1600 
1601 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1602 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1603 	}
1604 
1605 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1606 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1607 	}
1608 
1609 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1610 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1611 	}
1612 
1613 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1614 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1615 	}
1616 
1617 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1618 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1619 	}
1620 
1621 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1622 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1623 	}
1624 
1625 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1626 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1627 	}
1628 
1629 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1630 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1631 	}
1632 
1633 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1634 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1635 	}
1636 
1637 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1638 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1639 	}
1640 
1641 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1642 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1643 	}
1644 
1645 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1646 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1647 	}
1648 
1649 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1650 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1651 	}
1652 
1653 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1654 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1655 	}
1656 
1657 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1658 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1659 	}
1660 
1661 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1662 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1663 	}
1664 
1665 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1666 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1667 	}
1668 
1669 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1670 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1671 	}
1672 
1673 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1674 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1675 	}
1676 
1677 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1678 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1679 	}
1680 
1681 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1682 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1683 	}
1684 
1685 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1686 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1687 	}
1688 
1689 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1690 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1691 	}
1692 
1693 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1694 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1695 	}
1696 
1697 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1698 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1699 	}
1700 
1701 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1702 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1703 	}
1704 
1705 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1706 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1707 	}
1708 
1709 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1710 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1711 	}
1712 
1713 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1714 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1715 	}
1716 
1717 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1718 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1719 	}
1720 
1721 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1722 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1723 	}
1724 
1725 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1726 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1727 	}
1728 
1729 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1730 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1731 	}
1732 
1733 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1734 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1735 	}
1736 
1737 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1738 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1739 	}
1740 
1741 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1742 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1743 	}
1744 
1745 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1746 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1747 	}
1748 
1749 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1750 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1751 	}
1752 
1753 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1754 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1755 	}
1756 
1757 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1758 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1759 	}
1760 
1761 	function log(string memory p0, address p1, address p2, address p3) internal view {
1762 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1763 	}
1764 
1765 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1766 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1767 	}
1768 
1769 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1770 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1771 	}
1772 
1773 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1774 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1775 	}
1776 
1777 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1778 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1779 	}
1780 
1781 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1782 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1783 	}
1784 
1785 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1786 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1787 	}
1788 
1789 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1790 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1791 	}
1792 
1793 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1794 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1795 	}
1796 
1797 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1798 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1799 	}
1800 
1801 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1802 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1803 	}
1804 
1805 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1806 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1807 	}
1808 
1809 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1810 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1811 	}
1812 
1813 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1814 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1815 	}
1816 
1817 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1818 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1819 	}
1820 
1821 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1822 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1823 	}
1824 
1825 	function log(bool p0, uint p1, address p2, address p3) internal view {
1826 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1827 	}
1828 
1829 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1830 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1831 	}
1832 
1833 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1834 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1835 	}
1836 
1837 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1838 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1839 	}
1840 
1841 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1842 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1843 	}
1844 
1845 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1846 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1847 	}
1848 
1849 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1850 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1851 	}
1852 
1853 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1854 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1855 	}
1856 
1857 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1858 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1859 	}
1860 
1861 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1862 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1863 	}
1864 
1865 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1866 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1867 	}
1868 
1869 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1870 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1871 	}
1872 
1873 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1874 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1875 	}
1876 
1877 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1878 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1879 	}
1880 
1881 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1882 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1883 	}
1884 
1885 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1886 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1887 	}
1888 
1889 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1890 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1891 	}
1892 
1893 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1894 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1895 	}
1896 
1897 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1898 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1899 	}
1900 
1901 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1902 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1903 	}
1904 
1905 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1906 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1907 	}
1908 
1909 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1910 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1911 	}
1912 
1913 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1914 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1915 	}
1916 
1917 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1918 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1919 	}
1920 
1921 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1922 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1923 	}
1924 
1925 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1926 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1927 	}
1928 
1929 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1930 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1931 	}
1932 
1933 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1934 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1935 	}
1936 
1937 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1938 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1939 	}
1940 
1941 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1942 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1943 	}
1944 
1945 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1946 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1947 	}
1948 
1949 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1950 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1951 	}
1952 
1953 	function log(bool p0, bool p1, address p2, address p3) internal view {
1954 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1955 	}
1956 
1957 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1958 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1959 	}
1960 
1961 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1962 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1963 	}
1964 
1965 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1966 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1967 	}
1968 
1969 	function log(bool p0, address p1, uint p2, address p3) internal view {
1970 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1971 	}
1972 
1973 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1974 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1975 	}
1976 
1977 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1978 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1979 	}
1980 
1981 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1982 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1983 	}
1984 
1985 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1986 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1987 	}
1988 
1989 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1990 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1991 	}
1992 
1993 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1994 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1995 	}
1996 
1997 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1998 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1999 	}
2000 
2001 	function log(bool p0, address p1, bool p2, address p3) internal view {
2002 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
2003 	}
2004 
2005 	function log(bool p0, address p1, address p2, uint p3) internal view {
2006 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
2007 	}
2008 
2009 	function log(bool p0, address p1, address p2, string memory p3) internal view {
2010 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
2011 	}
2012 
2013 	function log(bool p0, address p1, address p2, bool p3) internal view {
2014 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
2015 	}
2016 
2017 	function log(bool p0, address p1, address p2, address p3) internal view {
2018 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
2019 	}
2020 
2021 	function log(address p0, uint p1, uint p2, uint p3) internal view {
2022 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
2023 	}
2024 
2025 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
2026 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
2027 	}
2028 
2029 	function log(address p0, uint p1, uint p2, bool p3) internal view {
2030 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
2031 	}
2032 
2033 	function log(address p0, uint p1, uint p2, address p3) internal view {
2034 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
2035 	}
2036 
2037 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
2038 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
2039 	}
2040 
2041 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2042 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2043 	}
2044 
2045 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2046 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2047 	}
2048 
2049 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2050 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2051 	}
2052 
2053 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2054 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2055 	}
2056 
2057 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2058 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2059 	}
2060 
2061 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2062 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2063 	}
2064 
2065 	function log(address p0, uint p1, bool p2, address p3) internal view {
2066 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2067 	}
2068 
2069 	function log(address p0, uint p1, address p2, uint p3) internal view {
2070 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2071 	}
2072 
2073 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2074 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2075 	}
2076 
2077 	function log(address p0, uint p1, address p2, bool p3) internal view {
2078 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2079 	}
2080 
2081 	function log(address p0, uint p1, address p2, address p3) internal view {
2082 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2083 	}
2084 
2085 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2086 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2087 	}
2088 
2089 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2090 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2091 	}
2092 
2093 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2094 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2095 	}
2096 
2097 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2098 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2099 	}
2100 
2101 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2102 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2103 	}
2104 
2105 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2106 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2107 	}
2108 
2109 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2110 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2111 	}
2112 
2113 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2114 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2115 	}
2116 
2117 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2118 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2119 	}
2120 
2121 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2122 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2123 	}
2124 
2125 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2126 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2127 	}
2128 
2129 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2130 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2131 	}
2132 
2133 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2134 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2135 	}
2136 
2137 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2138 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2139 	}
2140 
2141 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2142 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2143 	}
2144 
2145 	function log(address p0, string memory p1, address p2, address p3) internal view {
2146 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2147 	}
2148 
2149 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2150 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2151 	}
2152 
2153 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2154 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2155 	}
2156 
2157 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2158 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2159 	}
2160 
2161 	function log(address p0, bool p1, uint p2, address p3) internal view {
2162 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2163 	}
2164 
2165 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2166 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2167 	}
2168 
2169 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2170 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2171 	}
2172 
2173 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2174 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2175 	}
2176 
2177 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2178 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2179 	}
2180 
2181 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2182 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2183 	}
2184 
2185 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2186 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2187 	}
2188 
2189 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2190 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2191 	}
2192 
2193 	function log(address p0, bool p1, bool p2, address p3) internal view {
2194 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2195 	}
2196 
2197 	function log(address p0, bool p1, address p2, uint p3) internal view {
2198 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2199 	}
2200 
2201 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2202 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2203 	}
2204 
2205 	function log(address p0, bool p1, address p2, bool p3) internal view {
2206 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2207 	}
2208 
2209 	function log(address p0, bool p1, address p2, address p3) internal view {
2210 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2211 	}
2212 
2213 	function log(address p0, address p1, uint p2, uint p3) internal view {
2214 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2215 	}
2216 
2217 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2218 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2219 	}
2220 
2221 	function log(address p0, address p1, uint p2, bool p3) internal view {
2222 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2223 	}
2224 
2225 	function log(address p0, address p1, uint p2, address p3) internal view {
2226 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2227 	}
2228 
2229 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2230 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2231 	}
2232 
2233 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2234 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2235 	}
2236 
2237 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2238 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2239 	}
2240 
2241 	function log(address p0, address p1, string memory p2, address p3) internal view {
2242 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2243 	}
2244 
2245 	function log(address p0, address p1, bool p2, uint p3) internal view {
2246 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2247 	}
2248 
2249 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2250 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2251 	}
2252 
2253 	function log(address p0, address p1, bool p2, bool p3) internal view {
2254 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2255 	}
2256 
2257 	function log(address p0, address p1, bool p2, address p3) internal view {
2258 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2259 	}
2260 
2261 	function log(address p0, address p1, address p2, uint p3) internal view {
2262 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2263 	}
2264 
2265 	function log(address p0, address p1, address p2, string memory p3) internal view {
2266 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2267 	}
2268 
2269 	function log(address p0, address p1, address p2, bool p3) internal view {
2270 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2271 	}
2272 
2273 	function log(address p0, address p1, address p2, address p3) internal view {
2274 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2275 	}
2276 
2277 }
2278 
2279 
2280 // File contracts/libraries/alchemist/CDP.sol
2281 
2282 pragma solidity ^0.6.12;
2283 
2284 
2285 
2286 
2287 
2288 /// @title CDP
2289 ///
2290 /// @dev A library which provides the CDP data struct and associated functions.
2291 library CDP {
2292   using CDP for Data;
2293   using FixedPointMath for FixedPointMath.uq192x64;
2294   using SafeERC20 for IDetailedERC20;
2295   using SafeMath for uint256;
2296 
2297   struct Context {
2298     FixedPointMath.uq192x64 collateralizationLimit;
2299     FixedPointMath.uq192x64 accumulatedYieldWeight;
2300   }
2301 
2302   struct Data {
2303     uint256 totalDeposited;
2304     uint256 totalDebt;
2305     uint256 totalCredit;
2306     uint256 lastDeposit;
2307     FixedPointMath.uq192x64 lastAccumulatedYieldWeight;
2308   }
2309 
2310   function update(Data storage _self, Context storage _ctx) internal {
2311     uint256 _earnedYield = _self.getEarnedYield(_ctx);
2312     if (_earnedYield > _self.totalDebt) {
2313       uint256 _currentTotalDebt = _self.totalDebt;
2314       _self.totalDebt = 0;
2315       _self.totalCredit = _earnedYield.sub(_currentTotalDebt);
2316     } else {
2317       _self.totalDebt = _self.totalDebt.sub(_earnedYield);
2318     }
2319     _self.lastAccumulatedYieldWeight = _ctx.accumulatedYieldWeight;
2320   }
2321 
2322   /// @dev Assures that the CDP is healthy.
2323   ///
2324   /// This function will revert if the CDP is unhealthy.
2325   function checkHealth(Data storage _self, Context storage _ctx, string memory _msg) internal view {
2326     require(_self.isHealthy(_ctx), _msg);
2327   }
2328 
2329   /// @dev Gets if the CDP is considered healthy.
2330   ///
2331   /// A CDP is healthy if its collateralization ratio is greater than the global collateralization limit.
2332   ///
2333   /// @return if the CDP is healthy.
2334   function isHealthy(Data storage _self, Context storage _ctx) internal view returns (bool) {
2335     return _ctx.collateralizationLimit.cmp(_self.getCollateralizationRatio(_ctx)) <= 0;
2336   }
2337 
2338   function getUpdatedTotalDebt(Data storage _self, Context storage _ctx) internal view returns (uint256) {
2339     uint256 _unclaimedYield = _self.getEarnedYield(_ctx);
2340     if (_unclaimedYield == 0) {
2341       return _self.totalDebt;
2342     }
2343 
2344     uint256 _currentTotalDebt = _self.totalDebt;
2345     if (_unclaimedYield >= _currentTotalDebt) {
2346       return 0;
2347     }
2348 
2349     return _currentTotalDebt - _unclaimedYield;
2350   }
2351 
2352   function getUpdatedTotalCredit(Data storage _self, Context storage _ctx) internal view returns (uint256) {
2353     uint256 _unclaimedYield = _self.getEarnedYield(_ctx);
2354     if (_unclaimedYield == 0) {
2355       return _self.totalCredit;
2356     }
2357 
2358     uint256 _currentTotalDebt = _self.totalDebt;
2359     if (_unclaimedYield <= _currentTotalDebt) {
2360       return 0;
2361     }
2362 
2363     return _self.totalCredit + (_unclaimedYield - _currentTotalDebt);
2364   }
2365 
2366   /// @dev Gets the amount of yield that a CDP has earned since the last time it was updated.
2367   ///
2368   /// @param _self the CDP to query.
2369   /// @param _ctx  the CDP context.
2370   ///
2371   /// @return the amount of earned yield.
2372   function getEarnedYield(Data storage _self, Context storage _ctx) internal view returns (uint256) {
2373     FixedPointMath.uq192x64 memory _currentAccumulatedYieldWeight = _ctx.accumulatedYieldWeight;
2374     FixedPointMath.uq192x64 memory _lastAccumulatedYieldWeight = _self.lastAccumulatedYieldWeight;
2375 
2376     if (_currentAccumulatedYieldWeight.cmp(_lastAccumulatedYieldWeight) == 0) {
2377       return 0;
2378     }
2379 
2380     return _currentAccumulatedYieldWeight
2381       .sub(_lastAccumulatedYieldWeight)
2382       .mul(_self.totalDeposited)
2383       .decode();
2384   }
2385 
2386   /// @dev Gets a CDPs collateralization ratio.
2387   ///
2388   /// The collateralization ratio is defined as the ratio of collateral to debt. If the CDP has zero debt then this
2389   /// will return the maximum value of a fixed point integer.
2390   ///
2391   /// This function will use the updated total debt so an update before calling this function is not required.
2392   ///
2393   /// @param _self the CDP to query.
2394   ///
2395   /// @return a fixed point integer representing the collateralization ratio.
2396   function getCollateralizationRatio(Data storage _self, Context storage _ctx)
2397     internal view
2398     returns (FixedPointMath.uq192x64 memory)
2399   {
2400     uint256 _totalDebt = _self.getUpdatedTotalDebt(_ctx);
2401     if (_totalDebt == 0) {
2402       return FixedPointMath.maximumValue();
2403     }
2404     return FixedPointMath.fromU256(_self.totalDeposited).div(_totalDebt);
2405   }
2406 }
2407 
2408 
2409 // File contracts/interfaces/ITransmuter.sol
2410 
2411 pragma solidity ^0.6.12;
2412 
2413 interface ITransmuter  {
2414   function distribute (address origin, uint256 amount) external;
2415 }
2416 
2417 
2418 // File contracts/interfaces/IMintableERC20.sol
2419 
2420 pragma solidity ^0.6.12;
2421 
2422 interface IMintableERC20 is IDetailedERC20{
2423   function mint(address _recipient, uint256 _amount) external;
2424   function burnFrom(address account, uint256 amount) external;
2425   function lowerHasMinted(uint256 amount)external;
2426 }
2427 
2428 
2429 // File contracts/interfaces/IChainlink.sol
2430 
2431 pragma solidity ^0.6.12;
2432 
2433 interface IChainlink {
2434   function latestAnswer() external view returns (int256);
2435 }
2436 
2437 
2438 // File contracts/interfaces/IVaultAdapter.sol
2439 
2440 pragma solidity ^0.6.12;
2441 
2442 /// Interface for all Vault Adapter implementations.
2443 interface IVaultAdapter {
2444 
2445   /// @dev Gets the token that the adapter accepts.
2446   function token() external view returns (IDetailedERC20);
2447 
2448   /// @dev The total value of the assets deposited into the vault.
2449   function totalValue() external view returns (uint256);
2450 
2451   /// @dev Deposits funds into the vault.
2452   ///
2453   /// @param _amount  the amount of funds to deposit.
2454   function deposit(uint256 _amount) external;
2455 
2456   /// @dev Attempts to withdraw funds from the wrapped vault.
2457   ///
2458   /// The amount withdrawn to the recipient may be less than the amount requested.
2459   ///
2460   /// @param _recipient the recipient of the funds.
2461   /// @param _amount    the amount of funds to withdraw.
2462   function withdraw(address _recipient, uint256 _amount) external;
2463 }
2464 
2465 
2466 // File contracts/libraries/alchemist/Vault.sol
2467 
2468 pragma solidity ^0.6.12;
2469 
2470 //import "hardhat/console.sol";
2471 
2472 
2473 
2474 
2475 
2476 
2477 /// @title Pool
2478 ///
2479 /// @dev A library which provides the Vault data struct and associated functions.
2480 library Vault {
2481   using Vault for Data;
2482   using Vault for List;
2483   using SafeERC20 for IDetailedERC20;
2484   using SafeMath for uint256;
2485 
2486   struct Data {
2487     IVaultAdapter adapter;
2488     uint256 totalDeposited;
2489   }
2490 
2491   struct List {
2492     Data[] elements;
2493   }
2494 
2495   /// @dev Gets the total amount of assets deposited in the vault.
2496   ///
2497   /// @return the total assets.
2498   function totalValue(Data storage _self) internal view returns (uint256) {
2499     return _self.adapter.totalValue();
2500   }
2501 
2502   /// @dev Gets the token that the vault accepts.
2503   ///
2504   /// @return the accepted token.
2505   function token(Data storage _self) internal view returns (IDetailedERC20) {
2506     return IDetailedERC20(_self.adapter.token());
2507   }
2508 
2509   /// @dev Deposits funds from the caller into the vault.
2510   ///
2511   /// @param _amount the amount of funds to deposit.
2512   function deposit(Data storage _self, uint256 _amount) internal returns (uint256) {
2513     // Push the token that the vault accepts onto the stack to save gas.
2514     IDetailedERC20 _token = _self.token();
2515 
2516     _token.safeTransfer(address(_self.adapter), _amount);
2517     _self.adapter.deposit(_amount);
2518     _self.totalDeposited = _self.totalDeposited.add(_amount);
2519 
2520     return _amount;
2521   }
2522 
2523   /// @dev Deposits the entire token balance of the caller into the vault.
2524   function depositAll(Data storage _self) internal returns (uint256) {
2525     IDetailedERC20 _token = _self.token();
2526     return _self.deposit(_token.balanceOf(address(this)));
2527   }
2528 
2529   /// @dev Withdraw deposited funds from the vault.
2530   ///
2531   /// @param _recipient the account to withdraw the tokens to.
2532   /// @param _amount    the amount of tokens to withdraw.
2533   function withdraw(Data storage _self, address _recipient, uint256 _amount) internal returns (uint256, uint256) {
2534     (uint256 _withdrawnAmount, uint256 _decreasedValue) = _self.directWithdraw(_recipient, _amount);
2535     _self.totalDeposited = _self.totalDeposited.sub(_decreasedValue);
2536     return (_withdrawnAmount, _decreasedValue);
2537   }
2538 
2539   /// @dev Directly withdraw deposited funds from the vault.
2540   ///
2541   /// @param _recipient the account to withdraw the tokens to.
2542   /// @param _amount    the amount of tokens to withdraw.
2543   function directWithdraw(Data storage _self, address _recipient, uint256 _amount) internal returns (uint256, uint256) {
2544     IDetailedERC20 _token = _self.token();
2545 
2546     uint256 _startingBalance = _token.balanceOf(_recipient);
2547     uint256 _startingTotalValue = _self.totalValue();
2548 
2549     _self.adapter.withdraw(_recipient, _amount);
2550 
2551     uint256 _endingBalance = _token.balanceOf(_recipient);
2552     uint256 _withdrawnAmount = _endingBalance.sub(_startingBalance);
2553 
2554     uint256 _endingTotalValue = _self.totalValue();
2555     uint256 _decreasedValue = _startingTotalValue.sub(_endingTotalValue);
2556 
2557     return (_withdrawnAmount, _decreasedValue);
2558   }
2559 
2560   /// @dev Withdraw all the deposited funds from the vault.
2561   ///
2562   /// @param _recipient the account to withdraw the tokens to.
2563   function withdrawAll(Data storage _self, address _recipient) internal returns (uint256, uint256) {
2564     return _self.withdraw(_recipient, _self.totalDeposited);
2565   }
2566 
2567   /// @dev Harvests yield from the vault.
2568   ///
2569   /// @param _recipient the account to withdraw the harvested yield to.
2570   function harvest(Data storage _self, address _recipient) internal returns (uint256, uint256) {
2571     if (_self.totalValue() <= _self.totalDeposited) {
2572       return (0, 0);
2573     }
2574     uint256 _withdrawAmount = _self.totalValue().sub(_self.totalDeposited);
2575     return _self.directWithdraw(_recipient, _withdrawAmount);
2576   }
2577 
2578   /// @dev Adds a element to the list.
2579   ///
2580   /// @param _element the element to add.
2581   function push(List storage _self, Data memory _element) internal {
2582     _self.elements.push(_element);
2583   }
2584 
2585   /// @dev Gets a element from the list.
2586   ///
2587   /// @param _index the index in the list.
2588   ///
2589   /// @return the element at the specified index.
2590   function get(List storage _self, uint256 _index) internal view returns (Data storage) {
2591     return _self.elements[_index];
2592   }
2593 
2594   /// @dev Gets the last element in the list.
2595   ///
2596   /// This function will revert if there are no elements in the list.
2597   ///
2598   /// @return the last element in the list.
2599   function last(List storage _self) internal view returns (Data storage) {
2600     return _self.elements[_self.lastIndex()];
2601   }
2602 
2603   /// @dev Gets the index of the last element in the list.
2604   ///
2605   /// This function will revert if there are no elements in the list.
2606   ///
2607   /// @return the index of the last element.
2608   function lastIndex(List storage _self) internal view returns (uint256) {
2609     uint256 _length = _self.length();
2610     return _length.sub(1, "Vault.List: empty");
2611   }
2612 
2613   /// @dev Gets the number of elements in the list.
2614   ///
2615   /// @return the number of elements.
2616   function length(List storage _self) internal view returns (uint256) {
2617     return _self.elements.length;
2618   }
2619 }
2620 
2621 
2622 // File contracts/Alchemist.sol
2623 
2624 pragma solidity ^0.6.12;
2625 pragma experimental ABIEncoderV2;
2626 
2627 //import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
2628 
2629 
2630 
2631 
2632 
2633 
2634 
2635 
2636 
2637 
2638 
2639 // ERC20,removing ERC20 from the alchemist
2640 //    ___    __        __                _               ___                              __         _
2641 //   / _ |  / / ____  / /  ___   __ _   (_) __ __       / _ \  ____ ___   ___ ___   ___  / /_  ___  (_)
2642 //  / __ | / / / __/ / _ \/ -_) /  ' \ / /  \ \ /      / ___/ / __// -_) (_-</ -_) / _ \/ __/ (_-< _
2643 // /_/ |_|/_/  \__/ /_//_/\__/ /_/_/_//_/  /_\_\      /_/    /_/   \__/ /___/\__/ /_//_/\__/ /___/(_)
2644 //
2645 //      ___       __        ______  __    __   _______ .___  ___.  __       _______..___________.
2646 //     /   \     |  |      /      ||  |  |  | |   ____||   \/   | |  |     /       ||           |
2647 //    /  ^  \    |  |     |  ,----'|  |__|  | |  |__   |  \  /  | |  |    |   (----``---|  |----`
2648 //   /  /_\  \   |  |     |  |     |   __   | |   __|  |  |\/|  | |  |     \   \        |  |
2649 //  /  _____  \  |  `----.|  `----.|  |  |  | |  |____ |  |  |  | |  | .----)   |       |  |
2650 // /__/     \__\ |_______| \______||__|  |__| |_______||__|  |__| |__| |_______/        |__|
2651 
2652 contract Alchemist is  ReentrancyGuard {
2653   using CDP for CDP.Data;
2654   using FixedPointMath for FixedPointMath.uq192x64;
2655   using Vault for Vault.Data;
2656   using Vault for Vault.List;
2657   using SafeERC20 for IMintableERC20;
2658   using SafeMath for uint256;
2659   using Address for address;
2660 
2661   address public constant ZERO_ADDRESS = address(0);
2662 
2663   /// @dev Resolution for all fixed point numeric parameters which represent percents. The resolution allows for a
2664   /// granularity of 0.01% increments.
2665   uint256 public constant PERCENT_RESOLUTION = 10000;
2666 
2667   /// @dev The minimum value that the collateralization limit can be set to by the governance. This is a safety rail
2668   /// to prevent the collateralization from being set to a value which breaks the system.
2669   ///
2670   /// This value is equal to 100%.
2671   ///
2672   /// IMPORTANT: This constant is a raw FixedPointMath.uq192x64 value and assumes a resolution of 64 bits. If the
2673   ///            resolution for the FixedPointMath library changes this constant must change as well.
2674   uint256 public constant MINIMUM_COLLATERALIZATION_LIMIT = 1000000000000000000;
2675 
2676   /// @dev The maximum value that the collateralization limit can be set to by the governance. This is a safety rail
2677   /// to prevent the collateralization from being set to a value which breaks the system.
2678   ///
2679   /// This value is equal to 400%.
2680   ///
2681   /// IMPORTANT: This constant is a raw FixedPointMath.uq192x64 value and assumes a resolution of 64 bits. If the
2682   ///            resolution for the FixedPointMath library changes this constant must change as well.
2683   uint256 public constant MAXIMUM_COLLATERALIZATION_LIMIT = 4000000000000000000;
2684 
2685   event GovernanceUpdated(
2686     address governance
2687   );
2688 
2689   event PendingGovernanceUpdated(
2690     address pendingGovernance
2691   );
2692 
2693   event SentinelUpdated(
2694     address sentinel
2695   );
2696 
2697   event TransmuterUpdated(
2698     address transmuter
2699   );
2700 
2701   event RewardsUpdated(
2702     address treasury
2703   );
2704 
2705   event HarvestFeeUpdated(
2706     uint256 fee
2707   );
2708 
2709   event CollateralizationLimitUpdated(
2710     uint256 limit
2711   );
2712 
2713   event EmergencyExitUpdated(
2714     bool status
2715   );
2716 
2717   event ActiveVaultUpdated(
2718     IVaultAdapter indexed adapter
2719   );
2720 
2721   event FundsHarvested(
2722     uint256 withdrawnAmount,
2723     uint256 decreasedValue
2724   );
2725 
2726   event FundsRecalled(
2727     uint256 indexed vaultId,
2728     uint256 withdrawnAmount,
2729     uint256 decreasedValue
2730   );
2731 
2732   event FundsFlushed(
2733     uint256 amount
2734   );
2735 
2736   event TokensDeposited(
2737     address indexed account,
2738     uint256 amount
2739   );
2740 
2741   event TokensWithdrawn(
2742     address indexed account,
2743     uint256 requestedAmount,
2744     uint256 withdrawnAmount,
2745     uint256 decreasedValue
2746   );
2747 
2748   event TokensRepaid(
2749     address indexed account,
2750     uint256 parentAmount,
2751     uint256 childAmount
2752   );
2753 
2754   event TokensLiquidated(
2755     address indexed account,
2756     uint256 requestedAmount,
2757     uint256 withdrawnAmount,
2758     uint256 decreasedValue
2759   );
2760 
2761   /// @dev The token that this contract is using as the parent asset.
2762   IMintableERC20 public token;
2763 
2764    /// @dev The token that this contract is using as the child asset.
2765   IMintableERC20 public xtoken;
2766 
2767   /// @dev The address of the account which currently has administrative capabilities over this contract.
2768   address public governance;
2769 
2770   /// @dev The address of the pending governance.
2771   address public pendingGovernance;
2772 
2773   /// @dev The address of the account which can initiate an emergency withdraw of funds in a vault.
2774   address public sentinel;
2775 
2776   /// @dev The address of the contract which will transmute synthetic tokens back into native tokens.
2777   address public transmuter;
2778 
2779   /// @dev The address of the contract which will receive fees.
2780   address public rewards;
2781 
2782   /// @dev The percent of each profitable harvest that will go to the rewards contract.
2783   uint256 public harvestFee;
2784 
2785   /// @dev The total amount the native token deposited into the system that is owned by external users.
2786   uint256 public totalDeposited;
2787 
2788   /// @dev when movemetns are bigger than this number flush is activated.
2789   uint256 public flushActivator;
2790 
2791   /// @dev A flag indicating if the contract has been initialized yet.
2792   bool public initialized;
2793 
2794   /// @dev A flag indicating if deposits and flushes should be halted and if all parties should be able to recall
2795   /// from the active vault.
2796   bool public emergencyExit;
2797 
2798   /// @dev The context shared between the CDPs.
2799   CDP.Context private _ctx;
2800 
2801   /// @dev A mapping of all of the user CDPs. If a user wishes to have multiple CDPs they will have to either
2802   /// create a new address or set up a proxy contract that interfaces with this contract.
2803   mapping(address => CDP.Data) private _cdps;
2804 
2805   /// @dev A list of all of the vaults. The last element of the list is the vault that is currently being used for
2806   /// deposits and withdraws. Vaults before the last element are considered inactive and are expected to be cleared.
2807   Vault.List private _vaults;
2808 
2809   /// @dev The address of the link oracle.
2810   address public _linkGasOracle;
2811 
2812   /// @dev The minimum returned amount needed to be on peg according to the oracle.
2813   uint256 public pegMinimum;
2814 
2815   constructor(
2816     IMintableERC20 _token,
2817     IMintableERC20 _xtoken,
2818     address _governance,
2819     address _sentinel
2820   )
2821     public
2822     /*ERC20(
2823       string(abi.encodePacked("Alchemic ", _token.name())),
2824       string(abi.encodePacked("al", _token.symbol()))
2825     )*/
2826   {
2827     require(_governance != ZERO_ADDRESS, "Alchemist: governance address cannot be 0x0.");
2828     require(_sentinel != ZERO_ADDRESS, "Alchemist: sentinel address cannot be 0x0.");
2829 
2830     token = _token;
2831     xtoken = _xtoken;
2832     governance = _governance;
2833     sentinel = _sentinel;
2834     flushActivator = 100000 ether;// change for non 18 digit tokens
2835 
2836     //_setupDecimals(_token.decimals());
2837     uint256 COLL_LIMIT = MINIMUM_COLLATERALIZATION_LIMIT.mul(2);
2838     _ctx.collateralizationLimit = FixedPointMath.uq192x64(COLL_LIMIT);
2839     _ctx.accumulatedYieldWeight = FixedPointMath.uq192x64(0);
2840   }
2841 
2842   /// @dev Sets the pending governance.
2843   ///
2844   /// This function reverts if the new pending governance is the zero address or the caller is not the current
2845   /// governance. This is to prevent the contract governance being set to the zero address which would deadlock
2846   /// privileged contract functionality.
2847   ///
2848   /// @param _pendingGovernance the new pending governance.
2849   function setPendingGovernance(address _pendingGovernance) external onlyGov {
2850     require(_pendingGovernance != ZERO_ADDRESS, "Alchemist: governance address cannot be 0x0.");
2851 
2852     pendingGovernance = _pendingGovernance;
2853 
2854     emit PendingGovernanceUpdated(_pendingGovernance);
2855   }
2856 
2857   /// @dev Accepts the role as governance.
2858   ///
2859   /// This function reverts if the caller is not the new pending governance.
2860   function acceptGovernance() external  {
2861     require(msg.sender == pendingGovernance,"sender is not pendingGovernance");
2862     address _pendingGovernance = pendingGovernance;
2863     governance = _pendingGovernance;
2864 
2865     emit GovernanceUpdated(_pendingGovernance);
2866   }
2867 
2868   function setSentinel(address _sentinel) external onlyGov {
2869 
2870     require(_sentinel != ZERO_ADDRESS, "Alchemist: sentinel address cannot be 0x0.");
2871 
2872     sentinel = _sentinel;
2873 
2874     emit SentinelUpdated(_sentinel);
2875   }
2876 
2877   /// @dev Sets the transmuter.
2878   ///
2879   /// This function reverts if the new transmuter is the zero address or the caller is not the current governance.
2880   ///
2881   /// @param _transmuter the new transmuter.
2882   function setTransmuter(address _transmuter) external onlyGov {
2883 
2884     // Check that the transmuter address is not the zero address. Setting the transmuter to the zero address would break
2885     // transfers to the address because of `safeTransfer` checks.
2886     require(_transmuter != ZERO_ADDRESS, "Alchemist: transmuter address cannot be 0x0.");
2887 
2888     transmuter = _transmuter;
2889 
2890     emit TransmuterUpdated(_transmuter);
2891   }
2892   /// @dev Sets the flushActivator.
2893   ///
2894   /// @param _flushActivator the new flushActivator.
2895   function setFlushActivator(uint256 _flushActivator) external onlyGov {
2896     flushActivator = _flushActivator;
2897 
2898   }
2899 
2900   /// @dev Sets the rewards contract.
2901   ///
2902   /// This function reverts if the new rewards contract is the zero address or the caller is not the current governance.
2903   ///
2904   /// @param _rewards the new rewards contract.
2905   function setRewards(address _rewards) external onlyGov {
2906 
2907     // Check that the rewards address is not the zero address. Setting the rewards to the zero address would break
2908     // transfers to the address because of `safeTransfer` checks.
2909     require(_rewards != ZERO_ADDRESS, "Alchemist: rewards address cannot be 0x0.");
2910 
2911     rewards = _rewards;
2912 
2913     emit RewardsUpdated(_rewards);
2914   }
2915 
2916   /// @dev Sets the harvest fee.
2917   ///
2918   /// This function reverts if the caller is not the current governance.
2919   ///
2920   /// @param _harvestFee the new harvest fee.
2921   function setHarvestFee(uint256 _harvestFee) external onlyGov {
2922 
2923     // Check that the harvest fee is within the acceptable range. Setting the harvest fee greater than 100% could
2924     // potentially break internal logic when calculating the harvest fee.
2925     require(_harvestFee <= PERCENT_RESOLUTION, "Alchemist: harvest fee above maximum.");
2926 
2927     harvestFee = _harvestFee;
2928 
2929     emit HarvestFeeUpdated(_harvestFee);
2930   }
2931 
2932   /// @dev Sets the collateralization limit.
2933   ///
2934   /// This function reverts if the caller is not the current governance or if the collateralization limit is outside
2935   /// of the accepted bounds.
2936   ///
2937   /// @param _limit the new collateralization limit.
2938   function setCollateralizationLimit(uint256 _limit) external onlyGov {
2939 
2940     require(_limit >= MINIMUM_COLLATERALIZATION_LIMIT, "Alchemist: collateralization limit below minimum.");
2941     require(_limit <= MAXIMUM_COLLATERALIZATION_LIMIT, "Alchemist: collateralization limit above maximum.");
2942 
2943     _ctx.collateralizationLimit = FixedPointMath.uq192x64(_limit);
2944 
2945     emit CollateralizationLimitUpdated(_limit);
2946   }
2947   /// @dev Set oracle.
2948   function setOracleAddress(address Oracle, uint256 peg) external onlyGov {
2949     _linkGasOracle = Oracle;
2950     pegMinimum = peg;
2951   }
2952   /// @dev Sets if the contract should enter emergency exit mode.
2953   ///
2954   /// @param _emergencyExit if the contract should enter emergency exit mode.
2955   function setEmergencyExit(bool _emergencyExit) external {
2956     require(msg.sender == governance || msg.sender == sentinel, "");
2957 
2958     emergencyExit = _emergencyExit;
2959 
2960     emit EmergencyExitUpdated(_emergencyExit);
2961   }
2962 
2963   /// @dev Gets the collateralization limit.
2964   ///
2965   /// The collateralization limit is the minimum ratio of collateral to debt that is allowed by the system.
2966   ///
2967   /// @return the collateralization limit.
2968   function collateralizationLimit() external view returns (FixedPointMath.uq192x64 memory) {
2969     return _ctx.collateralizationLimit;
2970   }
2971 
2972   /// @dev Initializes the contract.
2973   ///
2974   /// This function checks that the transmuter and rewards have been set and sets up the active vault.
2975   ///
2976   /// @param _adapter the vault adapter of the active vault.
2977   function initialize(IVaultAdapter _adapter) external onlyGov {
2978 
2979     require(!initialized, "Alchemist: already initialized");
2980 
2981     require(transmuter != ZERO_ADDRESS, "Alchemist: cannot initialize transmuter address to 0x0");
2982     require(rewards != ZERO_ADDRESS, "Alchemist: cannot initialize rewards address to 0x0");
2983 
2984     _updateActiveVault(_adapter);
2985 
2986     initialized = true;
2987   }
2988 
2989   /// @dev Migrates the system to a new vault.
2990   ///
2991   /// This function reverts if the vault adapter is the zero address, if the token that the vault adapter accepts
2992   /// is not the token that this contract defines as the parent asset, or if the contract has not yet been initialized.
2993   ///
2994   /// @param _adapter the adapter for the vault the system will migrate to.
2995   function migrate(IVaultAdapter _adapter) external expectInitialized onlyGov {
2996 
2997     _updateActiveVault(_adapter);
2998   }
2999 
3000   /// @dev Harvests yield from a vault.
3001   ///
3002   /// @param _vaultId the identifier of the vault to harvest from.
3003   ///
3004   /// @return the amount of funds that were harvested from the vault.
3005   function harvest(uint256 _vaultId) external expectInitialized returns (uint256, uint256) {
3006 
3007     Vault.Data storage _vault = _vaults.get(_vaultId);
3008 
3009     (uint256 _harvestedAmount, uint256 _decreasedValue) = _vault.harvest(address(this));
3010 
3011     if (_harvestedAmount > 0) {
3012       uint256 _feeAmount = _harvestedAmount.mul(harvestFee).div(PERCENT_RESOLUTION);
3013       uint256 _distributeAmount = _harvestedAmount.sub(_feeAmount);
3014 
3015       FixedPointMath.uq192x64 memory _weight = FixedPointMath.fromU256(_distributeAmount).div(totalDeposited);
3016       _ctx.accumulatedYieldWeight = _ctx.accumulatedYieldWeight.add(_weight);
3017 
3018       if (_feeAmount > 0) {
3019         token.safeTransfer(rewards, _feeAmount);
3020       }
3021 
3022       if (_distributeAmount > 0) {
3023         _distributeToTransmuter(_distributeAmount);
3024 
3025         // token.safeTransfer(transmuter, _distributeAmount); previous version call
3026       }
3027     }
3028 
3029     emit FundsHarvested(_harvestedAmount, _decreasedValue);
3030 
3031     return (_harvestedAmount, _decreasedValue);
3032   }
3033 
3034   /// @dev Recalls an amount of deposited funds from a vault to this contract.
3035   ///
3036   /// @param _vaultId the identifier of the recall funds from.
3037   ///
3038   /// @return the amount of funds that were recalled from the vault to this contract and the decreased vault value.
3039   function recall(uint256 _vaultId, uint256 _amount) external nonReentrant expectInitialized returns (uint256, uint256) {
3040 
3041     return _recallFunds(_vaultId, _amount);
3042   }
3043 
3044   /// @dev Recalls all the deposited funds from a vault to this contract.
3045   ///
3046   /// @param _vaultId the identifier of the recall funds from.
3047   ///
3048   /// @return the amount of funds that were recalled from the vault to this contract and the decreased vault value.
3049   function recallAll(uint256 _vaultId) external nonReentrant expectInitialized returns (uint256, uint256) {
3050     Vault.Data storage _vault = _vaults.get(_vaultId);
3051     return _recallFunds(_vaultId, _vault.totalDeposited);
3052   }
3053 
3054   /// @dev Flushes buffered tokens to the active vault.
3055   ///
3056   /// This function reverts if an emergency exit is active. This is in place to prevent the potential loss of
3057   /// additional funds.
3058   ///
3059   /// @return the amount of tokens flushed to the active vault.
3060   function flush() external nonReentrant expectInitialized returns (uint256) {
3061 
3062     // Prevent flushing to the active vault when an emergency exit is enabled to prevent potential loss of funds if
3063     // the active vault is poisoned for any reason.
3064     require(!emergencyExit, "emergency pause enabled");
3065 
3066     return flushActiveVault();
3067   }
3068 
3069   /// @dev Internal function to flush buffered tokens to the active vault.
3070   ///
3071   /// This function reverts if an emergency exit is active. This is in place to prevent the potential loss of
3072   /// additional funds.
3073   ///
3074   /// @return the amount of tokens flushed to the active vault.
3075   function flushActiveVault() internal returns (uint256) {
3076 
3077     Vault.Data storage _activeVault = _vaults.last();
3078     uint256 _depositedAmount = _activeVault.depositAll();
3079 
3080     emit FundsFlushed(_depositedAmount);
3081 
3082     return _depositedAmount;
3083   }
3084 
3085   /// @dev Deposits collateral into a CDP.
3086   ///
3087   /// This function reverts if an emergency exit is active. This is in place to prevent the potential loss of
3088   /// additional funds.
3089   ///
3090   /// @param _amount the amount of collateral to deposit.
3091   function deposit(uint256 _amount) external nonReentrant noContractAllowed expectInitialized {
3092 
3093     require(!emergencyExit, "emergency pause enabled");
3094 
3095     CDP.Data storage _cdp = _cdps[msg.sender];
3096     _cdp.update(_ctx);
3097 
3098     token.safeTransferFrom(msg.sender, address(this), _amount);
3099     if(_amount >= flushActivator) {
3100       flushActiveVault();
3101     }
3102     totalDeposited = totalDeposited.add(_amount);
3103 
3104     _cdp.totalDeposited = _cdp.totalDeposited.add(_amount);
3105     _cdp.lastDeposit = block.number;
3106 
3107     emit TokensDeposited(msg.sender, _amount);
3108   }
3109 
3110   /// @dev Attempts to withdraw part of a CDP's collateral.
3111   ///
3112   /// This function reverts if a deposit into the CDP was made in the same block. This is to prevent flash loan attacks
3113   /// on other internal or external systems.
3114   ///
3115   /// @param _amount the amount of collateral to withdraw.
3116   function withdraw(uint256 _amount) external nonReentrant noContractAllowed expectInitialized returns (uint256, uint256) {
3117 
3118     CDP.Data storage _cdp = _cdps[msg.sender];
3119     require(block.number > _cdp.lastDeposit, "");
3120 
3121     _cdp.update(_ctx);
3122 
3123     (uint256 _withdrawnAmount, uint256 _decreasedValue) = _withdrawFundsTo(msg.sender, _amount);
3124 
3125     _cdp.totalDeposited = _cdp.totalDeposited.sub(_decreasedValue, "Exceeds withdrawable amount");
3126     _cdp.checkHealth(_ctx, "Action blocked: unhealthy collateralization ratio");
3127     if(_amount >= flushActivator) {
3128       flushActiveVault();
3129     }
3130     emit TokensWithdrawn(msg.sender, _amount, _withdrawnAmount, _decreasedValue);
3131 
3132     return (_withdrawnAmount, _decreasedValue);
3133   }
3134 
3135   /// @dev Repays debt with the native and or synthetic token.
3136   ///
3137   /// An approval is required to transfer native tokens to the transmuter.
3138   function repay(uint256 _parentAmount, uint256 _childAmount) external nonReentrant noContractAllowed onLinkCheck expectInitialized {
3139 
3140     CDP.Data storage _cdp = _cdps[msg.sender];
3141     _cdp.update(_ctx);
3142 
3143     if (_parentAmount > 0) {
3144       token.safeTransferFrom(msg.sender, address(this), _parentAmount);
3145       _distributeToTransmuter(_parentAmount);
3146     }
3147 
3148     if (_childAmount > 0) {
3149       xtoken.burnFrom(msg.sender, _childAmount);
3150       //lower debt cause burn
3151       xtoken.lowerHasMinted(_childAmount);
3152     }
3153 
3154     uint256 _totalAmount = _parentAmount.add(_childAmount);
3155     _cdp.totalDebt = _cdp.totalDebt.sub(_totalAmount, "");
3156 
3157     emit TokensRepaid(msg.sender, _parentAmount, _childAmount);
3158   }
3159 
3160   /// @dev Attempts to liquidate part of a CDP's collateral to pay back its debt.
3161   ///
3162   /// @param _amount the amount of collateral to attempt to liquidate.
3163   function liquidate(uint256 _amount) external nonReentrant noContractAllowed onLinkCheck expectInitialized returns (uint256, uint256) {
3164     CDP.Data storage _cdp = _cdps[msg.sender];
3165     _cdp.update(_ctx);
3166 
3167     // don't attempt to liquidate more than is possible
3168     if(_amount > _cdp.totalDebt){
3169       _amount = _cdp.totalDebt;
3170     }
3171     (uint256 _withdrawnAmount, uint256 _decreasedValue) = _withdrawFundsTo(address(this), _amount);
3172     //changed to new transmuter compatibillity
3173     _distributeToTransmuter(_withdrawnAmount);
3174 
3175     _cdp.totalDeposited = _cdp.totalDeposited.sub(_decreasedValue, "");
3176     _cdp.totalDebt = _cdp.totalDebt.sub(_withdrawnAmount, "");
3177     emit TokensLiquidated(msg.sender, _amount, _withdrawnAmount, _decreasedValue);
3178 
3179     return (_withdrawnAmount, _decreasedValue);
3180   }
3181 
3182   /// @dev Mints synthetic tokens by either claiming credit or increasing the debt.
3183   ///
3184   /// Claiming credit will take priority over increasing the debt.
3185   ///
3186   /// This function reverts if the debt is increased and the CDP health check fails.
3187   ///
3188   /// @param _amount the amount of alchemic tokens to borrow.
3189   function mint(uint256 _amount) external nonReentrant noContractAllowed onLinkCheck expectInitialized {
3190 
3191     CDP.Data storage _cdp = _cdps[msg.sender];
3192     _cdp.update(_ctx);
3193 
3194     uint256 _totalCredit = _cdp.totalCredit;
3195 
3196     if (_totalCredit < _amount) {
3197       uint256 _remainingAmount = _amount.sub(_totalCredit);
3198       _cdp.totalDebt = _cdp.totalDebt.add(_remainingAmount);
3199       _cdp.totalCredit = 0;
3200 
3201       _cdp.checkHealth(_ctx, "Alchemist: Loan-to-value ratio breached");
3202     } else {
3203       _cdp.totalCredit = _totalCredit.sub(_amount);
3204     }
3205 
3206     xtoken.mint(msg.sender, _amount);
3207     if(_amount >= flushActivator) {
3208       flushActiveVault();
3209     }
3210   }
3211 
3212   /// @dev Gets the number of vaults in the vault list.
3213   ///
3214   /// @return the vault count.
3215   function vaultCount() external view returns (uint256) {
3216     return _vaults.length();
3217   }
3218 
3219   /// @dev Get the adapter of a vault.
3220   ///
3221   /// @param _vaultId the identifier of the vault.
3222   ///
3223   /// @return the vault adapter.
3224   function getVaultAdapter(uint256 _vaultId) external view returns (IVaultAdapter) {
3225     Vault.Data storage _vault = _vaults.get(_vaultId);
3226     return _vault.adapter;
3227   }
3228 
3229   /// @dev Get the total amount of the parent asset that has been deposited into a vault.
3230   ///
3231   /// @param _vaultId the identifier of the vault.
3232   ///
3233   /// @return the total amount of deposited tokens.
3234   function getVaultTotalDeposited(uint256 _vaultId) external view returns (uint256) {
3235     Vault.Data storage _vault = _vaults.get(_vaultId);
3236     return _vault.totalDeposited;
3237   }
3238 
3239   /// @dev Get the total amount of collateral deposited into a CDP.
3240   ///
3241   /// @param _account the user account of the CDP to query.
3242   ///
3243   /// @return the deposited amount of tokens.
3244   function getCdpTotalDeposited(address _account) external view returns (uint256) {
3245     CDP.Data storage _cdp = _cdps[_account];
3246     return _cdp.totalDeposited;
3247   }
3248 
3249   /// @dev Get the total amount of alchemic tokens borrowed from a CDP.
3250   ///
3251   /// @param _account the user account of the CDP to query.
3252   ///
3253   /// @return the borrowed amount of tokens.
3254   function getCdpTotalDebt(address _account) external view returns (uint256) {
3255     CDP.Data storage _cdp = _cdps[_account];
3256     return _cdp.getUpdatedTotalDebt(_ctx);
3257   }
3258 
3259   /// @dev Get the total amount of credit that a CDP has.
3260   ///
3261   /// @param _account the user account of the CDP to query.
3262   ///
3263   /// @return the amount of credit.
3264   function getCdpTotalCredit(address _account) external view returns (uint256) {
3265     CDP.Data storage _cdp = _cdps[_account];
3266     return _cdp.getUpdatedTotalCredit(_ctx);
3267   }
3268 
3269   /// @dev Gets the last recorded block of when a user made a deposit into their CDP.
3270   ///
3271   /// @param _account the user account of the CDP to query.
3272   ///
3273   /// @return the block number of the last deposit.
3274   function getCdpLastDeposit(address _account) external view returns (uint256) {
3275     CDP.Data storage _cdp = _cdps[_account];
3276     return _cdp.lastDeposit;
3277   }
3278   /// @dev sends tokens to the transmuter
3279   ///
3280   /// benefit of great nation of transmuter
3281   function _distributeToTransmuter(uint256 amount) internal {
3282         token.approve(transmuter,amount);
3283         ITransmuter(transmuter).distribute(address(this),amount);
3284         // lower debt cause of 'burn'
3285         xtoken.lowerHasMinted(amount);
3286   }
3287   /// @dev Checks that parent token is on peg.
3288   ///
3289   /// This is used over a modifier limit of pegged interactions.
3290   modifier onLinkCheck() {
3291     if(pegMinimum > 0 ){
3292       uint256 oracleAnswer = uint256(IChainlink(_linkGasOracle).latestAnswer());
3293       require(oracleAnswer > pegMinimum, "off peg limitation");
3294     }
3295     _;
3296   }
3297   /// @dev Checks that caller is not a eoa.
3298   ///
3299   /// This is used to prevent contracts from interacting.
3300   modifier noContractAllowed() {
3301     require(!address(msg.sender).isContract() && msg.sender == tx.origin, "Sorry we do not accept contract!");
3302     _;
3303   }
3304   /// @dev Checks that the contract is in an initialized state.
3305   ///
3306   /// This is used over a modifier to reduce the size of the contract
3307   modifier expectInitialized() {
3308     require(initialized, "Alchemist: not initialized.");
3309     _;
3310   }
3311 
3312   /// @dev Checks that the current message sender or caller is a specific address.
3313   ///
3314   /// @param _expectedCaller the expected caller.
3315   function _expectCaller(address _expectedCaller) internal {
3316     require(msg.sender == _expectedCaller, "");
3317   }
3318 
3319   /// @dev Checks that the current message sender or caller is the governance address.
3320   ///
3321   ///
3322   modifier onlyGov() {
3323     require(msg.sender == governance, "Alchemist: only governance.");
3324     _;
3325   }
3326   /// @dev Updates the active vault.
3327   ///
3328   /// This function reverts if the vault adapter is the zero address, if the token that the vault adapter accepts
3329   /// is not the token that this contract defines as the parent asset, or if the contract has not yet been initialized.
3330   ///
3331   /// @param _adapter the adapter for the new active vault.
3332   function _updateActiveVault(IVaultAdapter _adapter) internal {
3333     require(_adapter != IVaultAdapter(ZERO_ADDRESS), "Alchemist: active vault address cannot be 0x0.");
3334     require(_adapter.token() == token, "Alchemist: token mismatch.");
3335 
3336     _vaults.push(Vault.Data({
3337       adapter: _adapter,
3338       totalDeposited: 0
3339     }));
3340 
3341     emit ActiveVaultUpdated(_adapter);
3342   }
3343 
3344   /// @dev Recalls an amount of funds from a vault to this contract.
3345   ///
3346   /// @param _vaultId the identifier of the recall funds from.
3347   /// @param _amount  the amount of funds to recall from the vault.
3348   ///
3349   /// @return the amount of funds that were recalled from the vault to this contract and the decreased vault value.
3350   function _recallFunds(uint256 _vaultId, uint256 _amount) internal returns (uint256, uint256) {
3351     require(emergencyExit || msg.sender == governance || _vaultId != _vaults.lastIndex(), "Alchemist: not an emergency, not governance, and user does not have permission to recall funds from active vault");
3352 
3353     Vault.Data storage _vault = _vaults.get(_vaultId);
3354     (uint256 _withdrawnAmount, uint256 _decreasedValue) = _vault.withdraw(address(this), _amount);
3355 
3356     emit FundsRecalled(_vaultId, _withdrawnAmount, _decreasedValue);
3357 
3358     return (_withdrawnAmount, _decreasedValue);
3359   }
3360 
3361   /// @dev Attempts to withdraw funds from the active vault to the recipient.
3362   ///
3363   /// Funds will be first withdrawn from this contracts balance and then from the active vault. This function
3364   /// is different from `recallFunds` in that it reduces the total amount of deposited tokens by the decreased
3365   /// value of the vault.
3366   ///
3367   /// @param _recipient the account to withdraw the funds to.
3368   /// @param _amount    the amount of funds to withdraw.
3369   function _withdrawFundsTo(address _recipient, uint256 _amount) internal returns (uint256, uint256) {
3370     // Pull the funds from the buffer.
3371     uint256 _bufferedAmount = Math.min(_amount, token.balanceOf(address(this)));
3372 
3373     if (_recipient != address(this)) {
3374       token.safeTransfer(_recipient, _bufferedAmount);
3375     }
3376 
3377     uint256 _totalWithdrawn = _bufferedAmount;
3378     uint256 _totalDecreasedValue = _bufferedAmount;
3379 
3380     uint256 _remainingAmount = _amount.sub(_bufferedAmount);
3381 
3382     // Pull the remaining funds from the active vault.
3383     if (_remainingAmount > 0) {
3384       Vault.Data storage _activeVault = _vaults.last();
3385       (uint256 _withdrawAmount, uint256 _decreasedValue) = _activeVault.withdraw(
3386         _recipient,
3387         _remainingAmount
3388       );
3389 
3390       _totalWithdrawn = _totalWithdrawn.add(_withdrawAmount);
3391       _totalDecreasedValue = _totalDecreasedValue.add(_decreasedValue);
3392     }
3393 
3394     totalDeposited = totalDeposited.sub(_totalDecreasedValue);
3395 
3396     return (_totalWithdrawn, _totalDecreasedValue);
3397   }
3398 }