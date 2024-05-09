1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File contracts/interfaces/IDetailedERC20.sol
85 pragma solidity ^0.6.12;
86 
87 interface IDetailedERC20 is IERC20 {
88   function name() external returns (string memory);
89   function symbol() external returns (string memory);
90   function decimals() external returns (uint8);
91 }
92 
93 
94 // File contracts/interfaces/IMintableERC20.sol
95 pragma solidity ^0.6.12;
96 
97 interface IMintableERC20 is IDetailedERC20{
98   function mint(address _recipient, uint256 _amount) external;
99   function burnFrom(address account, uint256 amount) external;
100   function lowerHasMinted(uint256 amount)external;
101 }
102 
103 
104 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
105 
106 
107 pragma solidity >=0.6.0 <0.8.0;
108 
109 /**
110  * @dev Contract module that helps prevent reentrant calls to a function.
111  *
112  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
113  * available, which can be applied to functions to make sure there are no nested
114  * (reentrant) calls to them.
115  *
116  * Note that because there is a single `nonReentrant` guard, functions marked as
117  * `nonReentrant` may not call one another. This can be worked around by making
118  * those functions `private`, and then adding `external` `nonReentrant` entry
119  * points to them.
120  *
121  * TIP: If you would like to learn more about reentrancy and alternative ways
122  * to protect against it, check out our blog post
123  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
124  */
125 abstract contract ReentrancyGuard {
126     // Booleans are more expensive than uint256 or any type that takes up a full
127     // word because each write operation emits an extra SLOAD to first read the
128     // slot's contents, replace the bits taken up by the boolean, and then write
129     // back. This is the compiler's defense against contract upgrades and
130     // pointer aliasing, and it cannot be disabled.
131 
132     // The values being non-zero value makes deployment a bit more expensive,
133     // but in exchange the refund on every call to nonReentrant will be lower in
134     // amount. Since refunds are capped to a percentage of the total
135     // transaction's gas, it is best to keep them low in cases like this one, to
136     // increase the likelihood of the full refund coming into effect.
137     uint256 private constant _NOT_ENTERED = 1;
138     uint256 private constant _ENTERED = 2;
139 
140     uint256 private _status;
141 
142     constructor () internal {
143         _status = _NOT_ENTERED;
144     }
145 
146     /**
147      * @dev Prevents a contract from calling itself, directly or indirectly.
148      * Calling a `nonReentrant` function from another `nonReentrant`
149      * function is not supported. It is possible to prevent this from happening
150      * by making the `nonReentrant` function external, and make it call a
151      * `private` function that does the actual work.
152      */
153     modifier nonReentrant() {
154         // On the first call to nonReentrant, _notEntered will be true
155         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
156 
157         // Any calls to nonReentrant after this point will fail
158         _status = _ENTERED;
159 
160         _;
161 
162         // By storing the original value once again, a refund is triggered (see
163         // https://eips.ethereum.org/EIPS/eip-2200)
164         _status = _NOT_ENTERED;
165     }
166 }
167 
168 
169 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
170 
171 pragma solidity >=0.6.0 <0.8.0;
172 
173 /**
174  * @dev Wrappers over Solidity's arithmetic operations with added overflow
175  * checks.
176  *
177  * Arithmetic operations in Solidity wrap on overflow. This can easily result
178  * in bugs, because programmers usually assume that an overflow raises an
179  * error, which is the standard behavior in high level programming languages.
180  * `SafeMath` restores this intuition by reverting the transaction when an
181  * operation overflows.
182  *
183  * Using this library instead of the unchecked operations eliminates an entire
184  * class of bugs, so it's recommended to use it always.
185  */
186 library SafeMath {
187     /**
188      * @dev Returns the addition of two unsigned integers, with an overflow flag.
189      *
190      * _Available since v3.4._
191      */
192     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
193         uint256 c = a + b;
194         if (c < a) return (false, 0);
195         return (true, c);
196     }
197 
198     /**
199      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
200      *
201      * _Available since v3.4._
202      */
203     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
204         if (b > a) return (false, 0);
205         return (true, a - b);
206     }
207 
208     /**
209      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
210      *
211      * _Available since v3.4._
212      */
213     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
214         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
215         // benefit is lost if 'b' is also tested.
216         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
217         if (a == 0) return (true, 0);
218         uint256 c = a * b;
219         if (c / a != b) return (false, 0);
220         return (true, c);
221     }
222 
223     /**
224      * @dev Returns the division of two unsigned integers, with a division by zero flag.
225      *
226      * _Available since v3.4._
227      */
228     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
229         if (b == 0) return (false, 0);
230         return (true, a / b);
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
235      *
236      * _Available since v3.4._
237      */
238     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
239         if (b == 0) return (false, 0);
240         return (true, a % b);
241     }
242 
243     /**
244      * @dev Returns the addition of two unsigned integers, reverting on
245      * overflow.
246      *
247      * Counterpart to Solidity's `+` operator.
248      *
249      * Requirements:
250      *
251      * - Addition cannot overflow.
252      */
253     function add(uint256 a, uint256 b) internal pure returns (uint256) {
254         uint256 c = a + b;
255         require(c >= a, "SafeMath: addition overflow");
256         return c;
257     }
258 
259     /**
260      * @dev Returns the subtraction of two unsigned integers, reverting on
261      * overflow (when the result is negative).
262      *
263      * Counterpart to Solidity's `-` operator.
264      *
265      * Requirements:
266      *
267      * - Subtraction cannot overflow.
268      */
269     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
270         require(b <= a, "SafeMath: subtraction overflow");
271         return a - b;
272     }
273 
274     /**
275      * @dev Returns the multiplication of two unsigned integers, reverting on
276      * overflow.
277      *
278      * Counterpart to Solidity's `*` operator.
279      *
280      * Requirements:
281      *
282      * - Multiplication cannot overflow.
283      */
284     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
285         if (a == 0) return 0;
286         uint256 c = a * b;
287         require(c / a == b, "SafeMath: multiplication overflow");
288         return c;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers, reverting on
293      * division by zero. The result is rounded towards zero.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b) internal pure returns (uint256) {
304         require(b > 0, "SafeMath: division by zero");
305         return a / b;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting when dividing by zero.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
321         require(b > 0, "SafeMath: modulo by zero");
322         return a % b;
323     }
324 
325     /**
326      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
327      * overflow (when the result is negative).
328      *
329      * CAUTION: This function is deprecated because it requires allocating memory for the error
330      * message unnecessarily. For custom revert reasons use {trySub}.
331      *
332      * Counterpart to Solidity's `-` operator.
333      *
334      * Requirements:
335      *
336      * - Subtraction cannot overflow.
337      */
338     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
339         require(b <= a, errorMessage);
340         return a - b;
341     }
342 
343     /**
344      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
345      * division by zero. The result is rounded towards zero.
346      *
347      * CAUTION: This function is deprecated because it requires allocating memory for the error
348      * message unnecessarily. For custom revert reasons use {tryDiv}.
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
360         return a / b;
361     }
362 
363     /**
364      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
365      * reverting with custom message when dividing by zero.
366      *
367      * CAUTION: This function is deprecated because it requires allocating memory for the error
368      * message unnecessarily. For custom revert reasons use {tryMod}.
369      *
370      * Counterpart to Solidity's `%` operator. This function uses a `revert`
371      * opcode (which leaves remaining gas untouched) while Solidity uses an
372      * invalid opcode to revert (consuming all remaining gas).
373      *
374      * Requirements:
375      *
376      * - The divisor cannot be zero.
377      */
378     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
379         require(b > 0, errorMessage);
380         return a % b;
381     }
382 }
383 
384 
385 // File @openzeppelin/contracts/math/Math.sol@v3.4.1
386 
387 pragma solidity >=0.6.0 <0.8.0;
388 
389 /**
390  * @dev Standard math utilities missing in the Solidity language.
391  */
392 library Math {
393     /**
394      * @dev Returns the largest of two numbers.
395      */
396     function max(uint256 a, uint256 b) internal pure returns (uint256) {
397         return a >= b ? a : b;
398     }
399 
400     /**
401      * @dev Returns the smallest of two numbers.
402      */
403     function min(uint256 a, uint256 b) internal pure returns (uint256) {
404         return a < b ? a : b;
405     }
406 
407     /**
408      * @dev Returns the average of two numbers. The result is rounded towards
409      * zero.
410      */
411     function average(uint256 a, uint256 b) internal pure returns (uint256) {
412         // (a + b) / 2 can overflow, so we distribute
413         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
414     }
415 }
416 
417 
418 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
419 
420 pragma solidity >=0.6.2 <0.8.0;
421 
422 /**
423  * @dev Collection of functions related to the address type
424  */
425 library Address {
426     /**
427      * @dev Returns true if `account` is a contract.
428      *
429      * [IMPORTANT]
430      * ====
431      * It is unsafe to assume that an address for which this function returns
432      * false is an externally-owned account (EOA) and not a contract.
433      *
434      * Among others, `isContract` will return false for the following
435      * types of addresses:
436      *
437      *  - an externally-owned account
438      *  - a contract in construction
439      *  - an address where a contract will be created
440      *  - an address where a contract lived, but was destroyed
441      * ====
442      */
443     function isContract(address account) internal view returns (bool) {
444         // This method relies on extcodesize, which returns 0 for contracts in
445         // construction, since the code is only stored at the end of the
446         // constructor execution.
447 
448         uint256 size;
449         // solhint-disable-next-line no-inline-assembly
450         assembly { size := extcodesize(account) }
451         return size > 0;
452     }
453 
454     /**
455      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
456      * `recipient`, forwarding all available gas and reverting on errors.
457      *
458      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
459      * of certain opcodes, possibly making contracts go over the 2300 gas limit
460      * imposed by `transfer`, making them unable to receive funds via
461      * `transfer`. {sendValue} removes this limitation.
462      *
463      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
464      *
465      * IMPORTANT: because control is transferred to `recipient`, care must be
466      * taken to not create reentrancy vulnerabilities. Consider using
467      * {ReentrancyGuard} or the
468      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
469      */
470     function sendValue(address payable recipient, uint256 amount) internal {
471         require(address(this).balance >= amount, "Address: insufficient balance");
472 
473         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
474         (bool success, ) = recipient.call{ value: amount }("");
475         require(success, "Address: unable to send value, recipient may have reverted");
476     }
477 
478     /**
479      * @dev Performs a Solidity function call using a low level `call`. A
480      * plain`call` is an unsafe replacement for a function call: use this
481      * function instead.
482      *
483      * If `target` reverts with a revert reason, it is bubbled up by this
484      * function (like regular Solidity function calls).
485      *
486      * Returns the raw returned data. To convert to the expected return value,
487      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
488      *
489      * Requirements:
490      *
491      * - `target` must be a contract.
492      * - calling `target` with `data` must not revert.
493      *
494      * _Available since v3.1._
495      */
496     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
497       return functionCall(target, data, "Address: low-level call failed");
498     }
499 
500     /**
501      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
502      * `errorMessage` as a fallback revert reason when `target` reverts.
503      *
504      * _Available since v3.1._
505      */
506     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
507         return functionCallWithValue(target, data, 0, errorMessage);
508     }
509 
510     /**
511      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
512      * but also transferring `value` wei to `target`.
513      *
514      * Requirements:
515      *
516      * - the calling contract must have an ETH balance of at least `value`.
517      * - the called Solidity function must be `payable`.
518      *
519      * _Available since v3.1._
520      */
521     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
527      * with `errorMessage` as a fallback revert reason when `target` reverts.
528      *
529      * _Available since v3.1._
530      */
531     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
532         require(address(this).balance >= value, "Address: insufficient balance for call");
533         require(isContract(target), "Address: call to non-contract");
534 
535         // solhint-disable-next-line avoid-low-level-calls
536         (bool success, bytes memory returndata) = target.call{ value: value }(data);
537         return _verifyCallResult(success, returndata, errorMessage);
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
547         return functionStaticCall(target, data, "Address: low-level static call failed");
548     }
549 
550     /**
551      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
552      * but performing a static call.
553      *
554      * _Available since v3.3._
555      */
556     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
557         require(isContract(target), "Address: static call to non-contract");
558 
559         // solhint-disable-next-line avoid-low-level-calls
560         (bool success, bytes memory returndata) = target.staticcall(data);
561         return _verifyCallResult(success, returndata, errorMessage);
562     }
563 
564     /**
565      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
566      * but performing a delegate call.
567      *
568      * _Available since v3.4._
569      */
570     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
571         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
572     }
573 
574     /**
575      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
576      * but performing a delegate call.
577      *
578      * _Available since v3.4._
579      */
580     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
581         require(isContract(target), "Address: delegate call to non-contract");
582 
583         // solhint-disable-next-line avoid-low-level-calls
584         (bool success, bytes memory returndata) = target.delegatecall(data);
585         return _verifyCallResult(success, returndata, errorMessage);
586     }
587 
588     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
589         if (success) {
590             return returndata;
591         } else {
592             // Look for revert reason and bubble it up if present
593             if (returndata.length > 0) {
594                 // The easiest way to bubble the revert reason is using memory via assembly
595 
596                 // solhint-disable-next-line no-inline-assembly
597                 assembly {
598                     let returndata_size := mload(returndata)
599                     revert(add(32, returndata), returndata_size)
600                 }
601             } else {
602                 revert(errorMessage);
603             }
604         }
605     }
606 }
607 
608 
609 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
610 
611 pragma solidity >=0.6.0 <0.8.0;
612 
613 
614 
615 /**
616  * @title SafeERC20
617  * @dev Wrappers around ERC20 operations that throw on failure (when the token
618  * contract returns false). Tokens that return no value (and instead revert or
619  * throw on failure) are also supported, non-reverting calls are assumed to be
620  * successful.
621  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
622  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
623  */
624 library SafeERC20 {
625     using SafeMath for uint256;
626     using Address for address;
627 
628     function safeTransfer(IERC20 token, address to, uint256 value) internal {
629         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
630     }
631 
632     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
633         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
634     }
635 
636     /**
637      * @dev Deprecated. This function has issues similar to the ones found in
638      * {IERC20-approve}, and its usage is discouraged.
639      *
640      * Whenever possible, use {safeIncreaseAllowance} and
641      * {safeDecreaseAllowance} instead.
642      */
643     function safeApprove(IERC20 token, address spender, uint256 value) internal {
644         // safeApprove should only be called when setting an initial allowance,
645         // or when resetting it to zero. To increase and decrease it, use
646         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
647         // solhint-disable-next-line max-line-length
648         require((value == 0) || (token.allowance(address(this), spender) == 0),
649             "SafeERC20: approve from non-zero to non-zero allowance"
650         );
651         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
652     }
653 
654     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
655         uint256 newAllowance = token.allowance(address(this), spender).add(value);
656         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
657     }
658 
659     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
660         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
661         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
662     }
663 
664     /**
665      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
666      * on the return value: the return value is optional (but if data is returned, it must not be false).
667      * @param token The token targeted by the call.
668      * @param data The call data (encoded using abi.encode or one of its variants).
669      */
670     function _callOptionalReturn(IERC20 token, bytes memory data) private {
671         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
672         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
673         // the target address contains contract code and also asserts for success in the low-level call.
674 
675         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
676         if (returndata.length > 0) { // Return data is optional
677             // solhint-disable-next-line max-line-length
678             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
679         }
680     }
681 }
682 
683 
684 // File contracts/interfaces/IRewardVesting.sol
685 pragma solidity ^0.6.12;
686 
687 interface IRewardVesting  {
688     function addEarning(address user, uint256 amount) external;
689     function userBalances(address user) external view returns (uint256 bal);
690 }
691 
692 
693 // File contracts/interfaces/IVotingEscrow.sol
694 
695 pragma solidity ^0.6.12;
696 
697 interface IVotingEscrow  {
698     function balanceOf(address account) external view returns (uint256);
699     function totalSupply() external view returns (uint256);
700 }
701 
702 
703 // File hardhat/console.sol@v2.1.1
704 
705 pragma solidity >= 0.4.22 <0.9.0;
706 
707 library console {
708 	address constant CONSOLE_ADDRESS = address(0x000000000000000000636F6e736F6c652e6c6f67);
709 
710 	function _sendLogPayload(bytes memory payload) private view {
711 		uint256 payloadLength = payload.length;
712 		address consoleAddress = CONSOLE_ADDRESS;
713 		assembly {
714 			let payloadStart := add(payload, 32)
715 			let r := staticcall(gas(), consoleAddress, payloadStart, payloadLength, 0, 0)
716 		}
717 	}
718 
719 	function log() internal view {
720 		_sendLogPayload(abi.encodeWithSignature("log()"));
721 	}
722 
723 	function logInt(int p0) internal view {
724 		_sendLogPayload(abi.encodeWithSignature("log(int)", p0));
725 	}
726 
727 	function logUint(uint p0) internal view {
728 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
729 	}
730 
731 	function logString(string memory p0) internal view {
732 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
733 	}
734 
735 	function logBool(bool p0) internal view {
736 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
737 	}
738 
739 	function logAddress(address p0) internal view {
740 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
741 	}
742 
743 	function logBytes(bytes memory p0) internal view {
744 		_sendLogPayload(abi.encodeWithSignature("log(bytes)", p0));
745 	}
746 
747 	function logBytes1(bytes1 p0) internal view {
748 		_sendLogPayload(abi.encodeWithSignature("log(bytes1)", p0));
749 	}
750 
751 	function logBytes2(bytes2 p0) internal view {
752 		_sendLogPayload(abi.encodeWithSignature("log(bytes2)", p0));
753 	}
754 
755 	function logBytes3(bytes3 p0) internal view {
756 		_sendLogPayload(abi.encodeWithSignature("log(bytes3)", p0));
757 	}
758 
759 	function logBytes4(bytes4 p0) internal view {
760 		_sendLogPayload(abi.encodeWithSignature("log(bytes4)", p0));
761 	}
762 
763 	function logBytes5(bytes5 p0) internal view {
764 		_sendLogPayload(abi.encodeWithSignature("log(bytes5)", p0));
765 	}
766 
767 	function logBytes6(bytes6 p0) internal view {
768 		_sendLogPayload(abi.encodeWithSignature("log(bytes6)", p0));
769 	}
770 
771 	function logBytes7(bytes7 p0) internal view {
772 		_sendLogPayload(abi.encodeWithSignature("log(bytes7)", p0));
773 	}
774 
775 	function logBytes8(bytes8 p0) internal view {
776 		_sendLogPayload(abi.encodeWithSignature("log(bytes8)", p0));
777 	}
778 
779 	function logBytes9(bytes9 p0) internal view {
780 		_sendLogPayload(abi.encodeWithSignature("log(bytes9)", p0));
781 	}
782 
783 	function logBytes10(bytes10 p0) internal view {
784 		_sendLogPayload(abi.encodeWithSignature("log(bytes10)", p0));
785 	}
786 
787 	function logBytes11(bytes11 p0) internal view {
788 		_sendLogPayload(abi.encodeWithSignature("log(bytes11)", p0));
789 	}
790 
791 	function logBytes12(bytes12 p0) internal view {
792 		_sendLogPayload(abi.encodeWithSignature("log(bytes12)", p0));
793 	}
794 
795 	function logBytes13(bytes13 p0) internal view {
796 		_sendLogPayload(abi.encodeWithSignature("log(bytes13)", p0));
797 	}
798 
799 	function logBytes14(bytes14 p0) internal view {
800 		_sendLogPayload(abi.encodeWithSignature("log(bytes14)", p0));
801 	}
802 
803 	function logBytes15(bytes15 p0) internal view {
804 		_sendLogPayload(abi.encodeWithSignature("log(bytes15)", p0));
805 	}
806 
807 	function logBytes16(bytes16 p0) internal view {
808 		_sendLogPayload(abi.encodeWithSignature("log(bytes16)", p0));
809 	}
810 
811 	function logBytes17(bytes17 p0) internal view {
812 		_sendLogPayload(abi.encodeWithSignature("log(bytes17)", p0));
813 	}
814 
815 	function logBytes18(bytes18 p0) internal view {
816 		_sendLogPayload(abi.encodeWithSignature("log(bytes18)", p0));
817 	}
818 
819 	function logBytes19(bytes19 p0) internal view {
820 		_sendLogPayload(abi.encodeWithSignature("log(bytes19)", p0));
821 	}
822 
823 	function logBytes20(bytes20 p0) internal view {
824 		_sendLogPayload(abi.encodeWithSignature("log(bytes20)", p0));
825 	}
826 
827 	function logBytes21(bytes21 p0) internal view {
828 		_sendLogPayload(abi.encodeWithSignature("log(bytes21)", p0));
829 	}
830 
831 	function logBytes22(bytes22 p0) internal view {
832 		_sendLogPayload(abi.encodeWithSignature("log(bytes22)", p0));
833 	}
834 
835 	function logBytes23(bytes23 p0) internal view {
836 		_sendLogPayload(abi.encodeWithSignature("log(bytes23)", p0));
837 	}
838 
839 	function logBytes24(bytes24 p0) internal view {
840 		_sendLogPayload(abi.encodeWithSignature("log(bytes24)", p0));
841 	}
842 
843 	function logBytes25(bytes25 p0) internal view {
844 		_sendLogPayload(abi.encodeWithSignature("log(bytes25)", p0));
845 	}
846 
847 	function logBytes26(bytes26 p0) internal view {
848 		_sendLogPayload(abi.encodeWithSignature("log(bytes26)", p0));
849 	}
850 
851 	function logBytes27(bytes27 p0) internal view {
852 		_sendLogPayload(abi.encodeWithSignature("log(bytes27)", p0));
853 	}
854 
855 	function logBytes28(bytes28 p0) internal view {
856 		_sendLogPayload(abi.encodeWithSignature("log(bytes28)", p0));
857 	}
858 
859 	function logBytes29(bytes29 p0) internal view {
860 		_sendLogPayload(abi.encodeWithSignature("log(bytes29)", p0));
861 	}
862 
863 	function logBytes30(bytes30 p0) internal view {
864 		_sendLogPayload(abi.encodeWithSignature("log(bytes30)", p0));
865 	}
866 
867 	function logBytes31(bytes31 p0) internal view {
868 		_sendLogPayload(abi.encodeWithSignature("log(bytes31)", p0));
869 	}
870 
871 	function logBytes32(bytes32 p0) internal view {
872 		_sendLogPayload(abi.encodeWithSignature("log(bytes32)", p0));
873 	}
874 
875 	function log(uint p0) internal view {
876 		_sendLogPayload(abi.encodeWithSignature("log(uint)", p0));
877 	}
878 
879 	function log(string memory p0) internal view {
880 		_sendLogPayload(abi.encodeWithSignature("log(string)", p0));
881 	}
882 
883 	function log(bool p0) internal view {
884 		_sendLogPayload(abi.encodeWithSignature("log(bool)", p0));
885 	}
886 
887 	function log(address p0) internal view {
888 		_sendLogPayload(abi.encodeWithSignature("log(address)", p0));
889 	}
890 
891 	function log(uint p0, uint p1) internal view {
892 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint)", p0, p1));
893 	}
894 
895 	function log(uint p0, string memory p1) internal view {
896 		_sendLogPayload(abi.encodeWithSignature("log(uint,string)", p0, p1));
897 	}
898 
899 	function log(uint p0, bool p1) internal view {
900 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool)", p0, p1));
901 	}
902 
903 	function log(uint p0, address p1) internal view {
904 		_sendLogPayload(abi.encodeWithSignature("log(uint,address)", p0, p1));
905 	}
906 
907 	function log(string memory p0, uint p1) internal view {
908 		_sendLogPayload(abi.encodeWithSignature("log(string,uint)", p0, p1));
909 	}
910 
911 	function log(string memory p0, string memory p1) internal view {
912 		_sendLogPayload(abi.encodeWithSignature("log(string,string)", p0, p1));
913 	}
914 
915 	function log(string memory p0, bool p1) internal view {
916 		_sendLogPayload(abi.encodeWithSignature("log(string,bool)", p0, p1));
917 	}
918 
919 	function log(string memory p0, address p1) internal view {
920 		_sendLogPayload(abi.encodeWithSignature("log(string,address)", p0, p1));
921 	}
922 
923 	function log(bool p0, uint p1) internal view {
924 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint)", p0, p1));
925 	}
926 
927 	function log(bool p0, string memory p1) internal view {
928 		_sendLogPayload(abi.encodeWithSignature("log(bool,string)", p0, p1));
929 	}
930 
931 	function log(bool p0, bool p1) internal view {
932 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool)", p0, p1));
933 	}
934 
935 	function log(bool p0, address p1) internal view {
936 		_sendLogPayload(abi.encodeWithSignature("log(bool,address)", p0, p1));
937 	}
938 
939 	function log(address p0, uint p1) internal view {
940 		_sendLogPayload(abi.encodeWithSignature("log(address,uint)", p0, p1));
941 	}
942 
943 	function log(address p0, string memory p1) internal view {
944 		_sendLogPayload(abi.encodeWithSignature("log(address,string)", p0, p1));
945 	}
946 
947 	function log(address p0, bool p1) internal view {
948 		_sendLogPayload(abi.encodeWithSignature("log(address,bool)", p0, p1));
949 	}
950 
951 	function log(address p0, address p1) internal view {
952 		_sendLogPayload(abi.encodeWithSignature("log(address,address)", p0, p1));
953 	}
954 
955 	function log(uint p0, uint p1, uint p2) internal view {
956 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint)", p0, p1, p2));
957 	}
958 
959 	function log(uint p0, uint p1, string memory p2) internal view {
960 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string)", p0, p1, p2));
961 	}
962 
963 	function log(uint p0, uint p1, bool p2) internal view {
964 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool)", p0, p1, p2));
965 	}
966 
967 	function log(uint p0, uint p1, address p2) internal view {
968 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address)", p0, p1, p2));
969 	}
970 
971 	function log(uint p0, string memory p1, uint p2) internal view {
972 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint)", p0, p1, p2));
973 	}
974 
975 	function log(uint p0, string memory p1, string memory p2) internal view {
976 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string)", p0, p1, p2));
977 	}
978 
979 	function log(uint p0, string memory p1, bool p2) internal view {
980 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool)", p0, p1, p2));
981 	}
982 
983 	function log(uint p0, string memory p1, address p2) internal view {
984 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address)", p0, p1, p2));
985 	}
986 
987 	function log(uint p0, bool p1, uint p2) internal view {
988 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint)", p0, p1, p2));
989 	}
990 
991 	function log(uint p0, bool p1, string memory p2) internal view {
992 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string)", p0, p1, p2));
993 	}
994 
995 	function log(uint p0, bool p1, bool p2) internal view {
996 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool)", p0, p1, p2));
997 	}
998 
999 	function log(uint p0, bool p1, address p2) internal view {
1000 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address)", p0, p1, p2));
1001 	}
1002 
1003 	function log(uint p0, address p1, uint p2) internal view {
1004 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint)", p0, p1, p2));
1005 	}
1006 
1007 	function log(uint p0, address p1, string memory p2) internal view {
1008 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string)", p0, p1, p2));
1009 	}
1010 
1011 	function log(uint p0, address p1, bool p2) internal view {
1012 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool)", p0, p1, p2));
1013 	}
1014 
1015 	function log(uint p0, address p1, address p2) internal view {
1016 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address)", p0, p1, p2));
1017 	}
1018 
1019 	function log(string memory p0, uint p1, uint p2) internal view {
1020 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint)", p0, p1, p2));
1021 	}
1022 
1023 	function log(string memory p0, uint p1, string memory p2) internal view {
1024 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string)", p0, p1, p2));
1025 	}
1026 
1027 	function log(string memory p0, uint p1, bool p2) internal view {
1028 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool)", p0, p1, p2));
1029 	}
1030 
1031 	function log(string memory p0, uint p1, address p2) internal view {
1032 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address)", p0, p1, p2));
1033 	}
1034 
1035 	function log(string memory p0, string memory p1, uint p2) internal view {
1036 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint)", p0, p1, p2));
1037 	}
1038 
1039 	function log(string memory p0, string memory p1, string memory p2) internal view {
1040 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string)", p0, p1, p2));
1041 	}
1042 
1043 	function log(string memory p0, string memory p1, bool p2) internal view {
1044 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool)", p0, p1, p2));
1045 	}
1046 
1047 	function log(string memory p0, string memory p1, address p2) internal view {
1048 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address)", p0, p1, p2));
1049 	}
1050 
1051 	function log(string memory p0, bool p1, uint p2) internal view {
1052 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint)", p0, p1, p2));
1053 	}
1054 
1055 	function log(string memory p0, bool p1, string memory p2) internal view {
1056 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string)", p0, p1, p2));
1057 	}
1058 
1059 	function log(string memory p0, bool p1, bool p2) internal view {
1060 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool)", p0, p1, p2));
1061 	}
1062 
1063 	function log(string memory p0, bool p1, address p2) internal view {
1064 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address)", p0, p1, p2));
1065 	}
1066 
1067 	function log(string memory p0, address p1, uint p2) internal view {
1068 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint)", p0, p1, p2));
1069 	}
1070 
1071 	function log(string memory p0, address p1, string memory p2) internal view {
1072 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string)", p0, p1, p2));
1073 	}
1074 
1075 	function log(string memory p0, address p1, bool p2) internal view {
1076 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool)", p0, p1, p2));
1077 	}
1078 
1079 	function log(string memory p0, address p1, address p2) internal view {
1080 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address)", p0, p1, p2));
1081 	}
1082 
1083 	function log(bool p0, uint p1, uint p2) internal view {
1084 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint)", p0, p1, p2));
1085 	}
1086 
1087 	function log(bool p0, uint p1, string memory p2) internal view {
1088 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string)", p0, p1, p2));
1089 	}
1090 
1091 	function log(bool p0, uint p1, bool p2) internal view {
1092 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool)", p0, p1, p2));
1093 	}
1094 
1095 	function log(bool p0, uint p1, address p2) internal view {
1096 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address)", p0, p1, p2));
1097 	}
1098 
1099 	function log(bool p0, string memory p1, uint p2) internal view {
1100 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint)", p0, p1, p2));
1101 	}
1102 
1103 	function log(bool p0, string memory p1, string memory p2) internal view {
1104 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string)", p0, p1, p2));
1105 	}
1106 
1107 	function log(bool p0, string memory p1, bool p2) internal view {
1108 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool)", p0, p1, p2));
1109 	}
1110 
1111 	function log(bool p0, string memory p1, address p2) internal view {
1112 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address)", p0, p1, p2));
1113 	}
1114 
1115 	function log(bool p0, bool p1, uint p2) internal view {
1116 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint)", p0, p1, p2));
1117 	}
1118 
1119 	function log(bool p0, bool p1, string memory p2) internal view {
1120 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string)", p0, p1, p2));
1121 	}
1122 
1123 	function log(bool p0, bool p1, bool p2) internal view {
1124 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool)", p0, p1, p2));
1125 	}
1126 
1127 	function log(bool p0, bool p1, address p2) internal view {
1128 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address)", p0, p1, p2));
1129 	}
1130 
1131 	function log(bool p0, address p1, uint p2) internal view {
1132 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint)", p0, p1, p2));
1133 	}
1134 
1135 	function log(bool p0, address p1, string memory p2) internal view {
1136 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string)", p0, p1, p2));
1137 	}
1138 
1139 	function log(bool p0, address p1, bool p2) internal view {
1140 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool)", p0, p1, p2));
1141 	}
1142 
1143 	function log(bool p0, address p1, address p2) internal view {
1144 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address)", p0, p1, p2));
1145 	}
1146 
1147 	function log(address p0, uint p1, uint p2) internal view {
1148 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint)", p0, p1, p2));
1149 	}
1150 
1151 	function log(address p0, uint p1, string memory p2) internal view {
1152 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string)", p0, p1, p2));
1153 	}
1154 
1155 	function log(address p0, uint p1, bool p2) internal view {
1156 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool)", p0, p1, p2));
1157 	}
1158 
1159 	function log(address p0, uint p1, address p2) internal view {
1160 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address)", p0, p1, p2));
1161 	}
1162 
1163 	function log(address p0, string memory p1, uint p2) internal view {
1164 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint)", p0, p1, p2));
1165 	}
1166 
1167 	function log(address p0, string memory p1, string memory p2) internal view {
1168 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string)", p0, p1, p2));
1169 	}
1170 
1171 	function log(address p0, string memory p1, bool p2) internal view {
1172 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool)", p0, p1, p2));
1173 	}
1174 
1175 	function log(address p0, string memory p1, address p2) internal view {
1176 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address)", p0, p1, p2));
1177 	}
1178 
1179 	function log(address p0, bool p1, uint p2) internal view {
1180 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint)", p0, p1, p2));
1181 	}
1182 
1183 	function log(address p0, bool p1, string memory p2) internal view {
1184 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string)", p0, p1, p2));
1185 	}
1186 
1187 	function log(address p0, bool p1, bool p2) internal view {
1188 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool)", p0, p1, p2));
1189 	}
1190 
1191 	function log(address p0, bool p1, address p2) internal view {
1192 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address)", p0, p1, p2));
1193 	}
1194 
1195 	function log(address p0, address p1, uint p2) internal view {
1196 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint)", p0, p1, p2));
1197 	}
1198 
1199 	function log(address p0, address p1, string memory p2) internal view {
1200 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string)", p0, p1, p2));
1201 	}
1202 
1203 	function log(address p0, address p1, bool p2) internal view {
1204 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool)", p0, p1, p2));
1205 	}
1206 
1207 	function log(address p0, address p1, address p2) internal view {
1208 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address)", p0, p1, p2));
1209 	}
1210 
1211 	function log(uint p0, uint p1, uint p2, uint p3) internal view {
1212 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,uint)", p0, p1, p2, p3));
1213 	}
1214 
1215 	function log(uint p0, uint p1, uint p2, string memory p3) internal view {
1216 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,string)", p0, p1, p2, p3));
1217 	}
1218 
1219 	function log(uint p0, uint p1, uint p2, bool p3) internal view {
1220 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,bool)", p0, p1, p2, p3));
1221 	}
1222 
1223 	function log(uint p0, uint p1, uint p2, address p3) internal view {
1224 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,uint,address)", p0, p1, p2, p3));
1225 	}
1226 
1227 	function log(uint p0, uint p1, string memory p2, uint p3) internal view {
1228 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,uint)", p0, p1, p2, p3));
1229 	}
1230 
1231 	function log(uint p0, uint p1, string memory p2, string memory p3) internal view {
1232 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,string)", p0, p1, p2, p3));
1233 	}
1234 
1235 	function log(uint p0, uint p1, string memory p2, bool p3) internal view {
1236 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,bool)", p0, p1, p2, p3));
1237 	}
1238 
1239 	function log(uint p0, uint p1, string memory p2, address p3) internal view {
1240 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,string,address)", p0, p1, p2, p3));
1241 	}
1242 
1243 	function log(uint p0, uint p1, bool p2, uint p3) internal view {
1244 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,uint)", p0, p1, p2, p3));
1245 	}
1246 
1247 	function log(uint p0, uint p1, bool p2, string memory p3) internal view {
1248 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,string)", p0, p1, p2, p3));
1249 	}
1250 
1251 	function log(uint p0, uint p1, bool p2, bool p3) internal view {
1252 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,bool)", p0, p1, p2, p3));
1253 	}
1254 
1255 	function log(uint p0, uint p1, bool p2, address p3) internal view {
1256 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,bool,address)", p0, p1, p2, p3));
1257 	}
1258 
1259 	function log(uint p0, uint p1, address p2, uint p3) internal view {
1260 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,uint)", p0, p1, p2, p3));
1261 	}
1262 
1263 	function log(uint p0, uint p1, address p2, string memory p3) internal view {
1264 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,string)", p0, p1, p2, p3));
1265 	}
1266 
1267 	function log(uint p0, uint p1, address p2, bool p3) internal view {
1268 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,bool)", p0, p1, p2, p3));
1269 	}
1270 
1271 	function log(uint p0, uint p1, address p2, address p3) internal view {
1272 		_sendLogPayload(abi.encodeWithSignature("log(uint,uint,address,address)", p0, p1, p2, p3));
1273 	}
1274 
1275 	function log(uint p0, string memory p1, uint p2, uint p3) internal view {
1276 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,uint)", p0, p1, p2, p3));
1277 	}
1278 
1279 	function log(uint p0, string memory p1, uint p2, string memory p3) internal view {
1280 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,string)", p0, p1, p2, p3));
1281 	}
1282 
1283 	function log(uint p0, string memory p1, uint p2, bool p3) internal view {
1284 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,bool)", p0, p1, p2, p3));
1285 	}
1286 
1287 	function log(uint p0, string memory p1, uint p2, address p3) internal view {
1288 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,uint,address)", p0, p1, p2, p3));
1289 	}
1290 
1291 	function log(uint p0, string memory p1, string memory p2, uint p3) internal view {
1292 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,uint)", p0, p1, p2, p3));
1293 	}
1294 
1295 	function log(uint p0, string memory p1, string memory p2, string memory p3) internal view {
1296 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,string)", p0, p1, p2, p3));
1297 	}
1298 
1299 	function log(uint p0, string memory p1, string memory p2, bool p3) internal view {
1300 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,bool)", p0, p1, p2, p3));
1301 	}
1302 
1303 	function log(uint p0, string memory p1, string memory p2, address p3) internal view {
1304 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,string,address)", p0, p1, p2, p3));
1305 	}
1306 
1307 	function log(uint p0, string memory p1, bool p2, uint p3) internal view {
1308 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,uint)", p0, p1, p2, p3));
1309 	}
1310 
1311 	function log(uint p0, string memory p1, bool p2, string memory p3) internal view {
1312 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,string)", p0, p1, p2, p3));
1313 	}
1314 
1315 	function log(uint p0, string memory p1, bool p2, bool p3) internal view {
1316 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,bool)", p0, p1, p2, p3));
1317 	}
1318 
1319 	function log(uint p0, string memory p1, bool p2, address p3) internal view {
1320 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,bool,address)", p0, p1, p2, p3));
1321 	}
1322 
1323 	function log(uint p0, string memory p1, address p2, uint p3) internal view {
1324 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,uint)", p0, p1, p2, p3));
1325 	}
1326 
1327 	function log(uint p0, string memory p1, address p2, string memory p3) internal view {
1328 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,string)", p0, p1, p2, p3));
1329 	}
1330 
1331 	function log(uint p0, string memory p1, address p2, bool p3) internal view {
1332 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,bool)", p0, p1, p2, p3));
1333 	}
1334 
1335 	function log(uint p0, string memory p1, address p2, address p3) internal view {
1336 		_sendLogPayload(abi.encodeWithSignature("log(uint,string,address,address)", p0, p1, p2, p3));
1337 	}
1338 
1339 	function log(uint p0, bool p1, uint p2, uint p3) internal view {
1340 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,uint)", p0, p1, p2, p3));
1341 	}
1342 
1343 	function log(uint p0, bool p1, uint p2, string memory p3) internal view {
1344 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,string)", p0, p1, p2, p3));
1345 	}
1346 
1347 	function log(uint p0, bool p1, uint p2, bool p3) internal view {
1348 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,bool)", p0, p1, p2, p3));
1349 	}
1350 
1351 	function log(uint p0, bool p1, uint p2, address p3) internal view {
1352 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,uint,address)", p0, p1, p2, p3));
1353 	}
1354 
1355 	function log(uint p0, bool p1, string memory p2, uint p3) internal view {
1356 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,uint)", p0, p1, p2, p3));
1357 	}
1358 
1359 	function log(uint p0, bool p1, string memory p2, string memory p3) internal view {
1360 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,string)", p0, p1, p2, p3));
1361 	}
1362 
1363 	function log(uint p0, bool p1, string memory p2, bool p3) internal view {
1364 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,bool)", p0, p1, p2, p3));
1365 	}
1366 
1367 	function log(uint p0, bool p1, string memory p2, address p3) internal view {
1368 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,string,address)", p0, p1, p2, p3));
1369 	}
1370 
1371 	function log(uint p0, bool p1, bool p2, uint p3) internal view {
1372 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,uint)", p0, p1, p2, p3));
1373 	}
1374 
1375 	function log(uint p0, bool p1, bool p2, string memory p3) internal view {
1376 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,string)", p0, p1, p2, p3));
1377 	}
1378 
1379 	function log(uint p0, bool p1, bool p2, bool p3) internal view {
1380 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,bool)", p0, p1, p2, p3));
1381 	}
1382 
1383 	function log(uint p0, bool p1, bool p2, address p3) internal view {
1384 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,bool,address)", p0, p1, p2, p3));
1385 	}
1386 
1387 	function log(uint p0, bool p1, address p2, uint p3) internal view {
1388 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,uint)", p0, p1, p2, p3));
1389 	}
1390 
1391 	function log(uint p0, bool p1, address p2, string memory p3) internal view {
1392 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,string)", p0, p1, p2, p3));
1393 	}
1394 
1395 	function log(uint p0, bool p1, address p2, bool p3) internal view {
1396 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,bool)", p0, p1, p2, p3));
1397 	}
1398 
1399 	function log(uint p0, bool p1, address p2, address p3) internal view {
1400 		_sendLogPayload(abi.encodeWithSignature("log(uint,bool,address,address)", p0, p1, p2, p3));
1401 	}
1402 
1403 	function log(uint p0, address p1, uint p2, uint p3) internal view {
1404 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,uint)", p0, p1, p2, p3));
1405 	}
1406 
1407 	function log(uint p0, address p1, uint p2, string memory p3) internal view {
1408 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,string)", p0, p1, p2, p3));
1409 	}
1410 
1411 	function log(uint p0, address p1, uint p2, bool p3) internal view {
1412 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,bool)", p0, p1, p2, p3));
1413 	}
1414 
1415 	function log(uint p0, address p1, uint p2, address p3) internal view {
1416 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,uint,address)", p0, p1, p2, p3));
1417 	}
1418 
1419 	function log(uint p0, address p1, string memory p2, uint p3) internal view {
1420 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,uint)", p0, p1, p2, p3));
1421 	}
1422 
1423 	function log(uint p0, address p1, string memory p2, string memory p3) internal view {
1424 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,string)", p0, p1, p2, p3));
1425 	}
1426 
1427 	function log(uint p0, address p1, string memory p2, bool p3) internal view {
1428 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,bool)", p0, p1, p2, p3));
1429 	}
1430 
1431 	function log(uint p0, address p1, string memory p2, address p3) internal view {
1432 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,string,address)", p0, p1, p2, p3));
1433 	}
1434 
1435 	function log(uint p0, address p1, bool p2, uint p3) internal view {
1436 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,uint)", p0, p1, p2, p3));
1437 	}
1438 
1439 	function log(uint p0, address p1, bool p2, string memory p3) internal view {
1440 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,string)", p0, p1, p2, p3));
1441 	}
1442 
1443 	function log(uint p0, address p1, bool p2, bool p3) internal view {
1444 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,bool)", p0, p1, p2, p3));
1445 	}
1446 
1447 	function log(uint p0, address p1, bool p2, address p3) internal view {
1448 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,bool,address)", p0, p1, p2, p3));
1449 	}
1450 
1451 	function log(uint p0, address p1, address p2, uint p3) internal view {
1452 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,uint)", p0, p1, p2, p3));
1453 	}
1454 
1455 	function log(uint p0, address p1, address p2, string memory p3) internal view {
1456 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,string)", p0, p1, p2, p3));
1457 	}
1458 
1459 	function log(uint p0, address p1, address p2, bool p3) internal view {
1460 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,bool)", p0, p1, p2, p3));
1461 	}
1462 
1463 	function log(uint p0, address p1, address p2, address p3) internal view {
1464 		_sendLogPayload(abi.encodeWithSignature("log(uint,address,address,address)", p0, p1, p2, p3));
1465 	}
1466 
1467 	function log(string memory p0, uint p1, uint p2, uint p3) internal view {
1468 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,uint)", p0, p1, p2, p3));
1469 	}
1470 
1471 	function log(string memory p0, uint p1, uint p2, string memory p3) internal view {
1472 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,string)", p0, p1, p2, p3));
1473 	}
1474 
1475 	function log(string memory p0, uint p1, uint p2, bool p3) internal view {
1476 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,bool)", p0, p1, p2, p3));
1477 	}
1478 
1479 	function log(string memory p0, uint p1, uint p2, address p3) internal view {
1480 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,uint,address)", p0, p1, p2, p3));
1481 	}
1482 
1483 	function log(string memory p0, uint p1, string memory p2, uint p3) internal view {
1484 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,uint)", p0, p1, p2, p3));
1485 	}
1486 
1487 	function log(string memory p0, uint p1, string memory p2, string memory p3) internal view {
1488 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,string)", p0, p1, p2, p3));
1489 	}
1490 
1491 	function log(string memory p0, uint p1, string memory p2, bool p3) internal view {
1492 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,bool)", p0, p1, p2, p3));
1493 	}
1494 
1495 	function log(string memory p0, uint p1, string memory p2, address p3) internal view {
1496 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,string,address)", p0, p1, p2, p3));
1497 	}
1498 
1499 	function log(string memory p0, uint p1, bool p2, uint p3) internal view {
1500 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,uint)", p0, p1, p2, p3));
1501 	}
1502 
1503 	function log(string memory p0, uint p1, bool p2, string memory p3) internal view {
1504 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,string)", p0, p1, p2, p3));
1505 	}
1506 
1507 	function log(string memory p0, uint p1, bool p2, bool p3) internal view {
1508 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,bool)", p0, p1, p2, p3));
1509 	}
1510 
1511 	function log(string memory p0, uint p1, bool p2, address p3) internal view {
1512 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,bool,address)", p0, p1, p2, p3));
1513 	}
1514 
1515 	function log(string memory p0, uint p1, address p2, uint p3) internal view {
1516 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,uint)", p0, p1, p2, p3));
1517 	}
1518 
1519 	function log(string memory p0, uint p1, address p2, string memory p3) internal view {
1520 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,string)", p0, p1, p2, p3));
1521 	}
1522 
1523 	function log(string memory p0, uint p1, address p2, bool p3) internal view {
1524 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,bool)", p0, p1, p2, p3));
1525 	}
1526 
1527 	function log(string memory p0, uint p1, address p2, address p3) internal view {
1528 		_sendLogPayload(abi.encodeWithSignature("log(string,uint,address,address)", p0, p1, p2, p3));
1529 	}
1530 
1531 	function log(string memory p0, string memory p1, uint p2, uint p3) internal view {
1532 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,uint)", p0, p1, p2, p3));
1533 	}
1534 
1535 	function log(string memory p0, string memory p1, uint p2, string memory p3) internal view {
1536 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,string)", p0, p1, p2, p3));
1537 	}
1538 
1539 	function log(string memory p0, string memory p1, uint p2, bool p3) internal view {
1540 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,bool)", p0, p1, p2, p3));
1541 	}
1542 
1543 	function log(string memory p0, string memory p1, uint p2, address p3) internal view {
1544 		_sendLogPayload(abi.encodeWithSignature("log(string,string,uint,address)", p0, p1, p2, p3));
1545 	}
1546 
1547 	function log(string memory p0, string memory p1, string memory p2, uint p3) internal view {
1548 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,uint)", p0, p1, p2, p3));
1549 	}
1550 
1551 	function log(string memory p0, string memory p1, string memory p2, string memory p3) internal view {
1552 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,string)", p0, p1, p2, p3));
1553 	}
1554 
1555 	function log(string memory p0, string memory p1, string memory p2, bool p3) internal view {
1556 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,bool)", p0, p1, p2, p3));
1557 	}
1558 
1559 	function log(string memory p0, string memory p1, string memory p2, address p3) internal view {
1560 		_sendLogPayload(abi.encodeWithSignature("log(string,string,string,address)", p0, p1, p2, p3));
1561 	}
1562 
1563 	function log(string memory p0, string memory p1, bool p2, uint p3) internal view {
1564 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,uint)", p0, p1, p2, p3));
1565 	}
1566 
1567 	function log(string memory p0, string memory p1, bool p2, string memory p3) internal view {
1568 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,string)", p0, p1, p2, p3));
1569 	}
1570 
1571 	function log(string memory p0, string memory p1, bool p2, bool p3) internal view {
1572 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,bool)", p0, p1, p2, p3));
1573 	}
1574 
1575 	function log(string memory p0, string memory p1, bool p2, address p3) internal view {
1576 		_sendLogPayload(abi.encodeWithSignature("log(string,string,bool,address)", p0, p1, p2, p3));
1577 	}
1578 
1579 	function log(string memory p0, string memory p1, address p2, uint p3) internal view {
1580 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,uint)", p0, p1, p2, p3));
1581 	}
1582 
1583 	function log(string memory p0, string memory p1, address p2, string memory p3) internal view {
1584 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,string)", p0, p1, p2, p3));
1585 	}
1586 
1587 	function log(string memory p0, string memory p1, address p2, bool p3) internal view {
1588 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,bool)", p0, p1, p2, p3));
1589 	}
1590 
1591 	function log(string memory p0, string memory p1, address p2, address p3) internal view {
1592 		_sendLogPayload(abi.encodeWithSignature("log(string,string,address,address)", p0, p1, p2, p3));
1593 	}
1594 
1595 	function log(string memory p0, bool p1, uint p2, uint p3) internal view {
1596 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,uint)", p0, p1, p2, p3));
1597 	}
1598 
1599 	function log(string memory p0, bool p1, uint p2, string memory p3) internal view {
1600 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,string)", p0, p1, p2, p3));
1601 	}
1602 
1603 	function log(string memory p0, bool p1, uint p2, bool p3) internal view {
1604 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,bool)", p0, p1, p2, p3));
1605 	}
1606 
1607 	function log(string memory p0, bool p1, uint p2, address p3) internal view {
1608 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,uint,address)", p0, p1, p2, p3));
1609 	}
1610 
1611 	function log(string memory p0, bool p1, string memory p2, uint p3) internal view {
1612 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,uint)", p0, p1, p2, p3));
1613 	}
1614 
1615 	function log(string memory p0, bool p1, string memory p2, string memory p3) internal view {
1616 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,string)", p0, p1, p2, p3));
1617 	}
1618 
1619 	function log(string memory p0, bool p1, string memory p2, bool p3) internal view {
1620 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,bool)", p0, p1, p2, p3));
1621 	}
1622 
1623 	function log(string memory p0, bool p1, string memory p2, address p3) internal view {
1624 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,string,address)", p0, p1, p2, p3));
1625 	}
1626 
1627 	function log(string memory p0, bool p1, bool p2, uint p3) internal view {
1628 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,uint)", p0, p1, p2, p3));
1629 	}
1630 
1631 	function log(string memory p0, bool p1, bool p2, string memory p3) internal view {
1632 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,string)", p0, p1, p2, p3));
1633 	}
1634 
1635 	function log(string memory p0, bool p1, bool p2, bool p3) internal view {
1636 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,bool)", p0, p1, p2, p3));
1637 	}
1638 
1639 	function log(string memory p0, bool p1, bool p2, address p3) internal view {
1640 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,bool,address)", p0, p1, p2, p3));
1641 	}
1642 
1643 	function log(string memory p0, bool p1, address p2, uint p3) internal view {
1644 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,uint)", p0, p1, p2, p3));
1645 	}
1646 
1647 	function log(string memory p0, bool p1, address p2, string memory p3) internal view {
1648 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,string)", p0, p1, p2, p3));
1649 	}
1650 
1651 	function log(string memory p0, bool p1, address p2, bool p3) internal view {
1652 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,bool)", p0, p1, p2, p3));
1653 	}
1654 
1655 	function log(string memory p0, bool p1, address p2, address p3) internal view {
1656 		_sendLogPayload(abi.encodeWithSignature("log(string,bool,address,address)", p0, p1, p2, p3));
1657 	}
1658 
1659 	function log(string memory p0, address p1, uint p2, uint p3) internal view {
1660 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,uint)", p0, p1, p2, p3));
1661 	}
1662 
1663 	function log(string memory p0, address p1, uint p2, string memory p3) internal view {
1664 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,string)", p0, p1, p2, p3));
1665 	}
1666 
1667 	function log(string memory p0, address p1, uint p2, bool p3) internal view {
1668 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,bool)", p0, p1, p2, p3));
1669 	}
1670 
1671 	function log(string memory p0, address p1, uint p2, address p3) internal view {
1672 		_sendLogPayload(abi.encodeWithSignature("log(string,address,uint,address)", p0, p1, p2, p3));
1673 	}
1674 
1675 	function log(string memory p0, address p1, string memory p2, uint p3) internal view {
1676 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,uint)", p0, p1, p2, p3));
1677 	}
1678 
1679 	function log(string memory p0, address p1, string memory p2, string memory p3) internal view {
1680 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,string)", p0, p1, p2, p3));
1681 	}
1682 
1683 	function log(string memory p0, address p1, string memory p2, bool p3) internal view {
1684 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,bool)", p0, p1, p2, p3));
1685 	}
1686 
1687 	function log(string memory p0, address p1, string memory p2, address p3) internal view {
1688 		_sendLogPayload(abi.encodeWithSignature("log(string,address,string,address)", p0, p1, p2, p3));
1689 	}
1690 
1691 	function log(string memory p0, address p1, bool p2, uint p3) internal view {
1692 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,uint)", p0, p1, p2, p3));
1693 	}
1694 
1695 	function log(string memory p0, address p1, bool p2, string memory p3) internal view {
1696 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,string)", p0, p1, p2, p3));
1697 	}
1698 
1699 	function log(string memory p0, address p1, bool p2, bool p3) internal view {
1700 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,bool)", p0, p1, p2, p3));
1701 	}
1702 
1703 	function log(string memory p0, address p1, bool p2, address p3) internal view {
1704 		_sendLogPayload(abi.encodeWithSignature("log(string,address,bool,address)", p0, p1, p2, p3));
1705 	}
1706 
1707 	function log(string memory p0, address p1, address p2, uint p3) internal view {
1708 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,uint)", p0, p1, p2, p3));
1709 	}
1710 
1711 	function log(string memory p0, address p1, address p2, string memory p3) internal view {
1712 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,string)", p0, p1, p2, p3));
1713 	}
1714 
1715 	function log(string memory p0, address p1, address p2, bool p3) internal view {
1716 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,bool)", p0, p1, p2, p3));
1717 	}
1718 
1719 	function log(string memory p0, address p1, address p2, address p3) internal view {
1720 		_sendLogPayload(abi.encodeWithSignature("log(string,address,address,address)", p0, p1, p2, p3));
1721 	}
1722 
1723 	function log(bool p0, uint p1, uint p2, uint p3) internal view {
1724 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,uint)", p0, p1, p2, p3));
1725 	}
1726 
1727 	function log(bool p0, uint p1, uint p2, string memory p3) internal view {
1728 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,string)", p0, p1, p2, p3));
1729 	}
1730 
1731 	function log(bool p0, uint p1, uint p2, bool p3) internal view {
1732 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,bool)", p0, p1, p2, p3));
1733 	}
1734 
1735 	function log(bool p0, uint p1, uint p2, address p3) internal view {
1736 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,uint,address)", p0, p1, p2, p3));
1737 	}
1738 
1739 	function log(bool p0, uint p1, string memory p2, uint p3) internal view {
1740 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,uint)", p0, p1, p2, p3));
1741 	}
1742 
1743 	function log(bool p0, uint p1, string memory p2, string memory p3) internal view {
1744 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,string)", p0, p1, p2, p3));
1745 	}
1746 
1747 	function log(bool p0, uint p1, string memory p2, bool p3) internal view {
1748 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,bool)", p0, p1, p2, p3));
1749 	}
1750 
1751 	function log(bool p0, uint p1, string memory p2, address p3) internal view {
1752 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,string,address)", p0, p1, p2, p3));
1753 	}
1754 
1755 	function log(bool p0, uint p1, bool p2, uint p3) internal view {
1756 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,uint)", p0, p1, p2, p3));
1757 	}
1758 
1759 	function log(bool p0, uint p1, bool p2, string memory p3) internal view {
1760 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,string)", p0, p1, p2, p3));
1761 	}
1762 
1763 	function log(bool p0, uint p1, bool p2, bool p3) internal view {
1764 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,bool)", p0, p1, p2, p3));
1765 	}
1766 
1767 	function log(bool p0, uint p1, bool p2, address p3) internal view {
1768 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,bool,address)", p0, p1, p2, p3));
1769 	}
1770 
1771 	function log(bool p0, uint p1, address p2, uint p3) internal view {
1772 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,uint)", p0, p1, p2, p3));
1773 	}
1774 
1775 	function log(bool p0, uint p1, address p2, string memory p3) internal view {
1776 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,string)", p0, p1, p2, p3));
1777 	}
1778 
1779 	function log(bool p0, uint p1, address p2, bool p3) internal view {
1780 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,bool)", p0, p1, p2, p3));
1781 	}
1782 
1783 	function log(bool p0, uint p1, address p2, address p3) internal view {
1784 		_sendLogPayload(abi.encodeWithSignature("log(bool,uint,address,address)", p0, p1, p2, p3));
1785 	}
1786 
1787 	function log(bool p0, string memory p1, uint p2, uint p3) internal view {
1788 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,uint)", p0, p1, p2, p3));
1789 	}
1790 
1791 	function log(bool p0, string memory p1, uint p2, string memory p3) internal view {
1792 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,string)", p0, p1, p2, p3));
1793 	}
1794 
1795 	function log(bool p0, string memory p1, uint p2, bool p3) internal view {
1796 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,bool)", p0, p1, p2, p3));
1797 	}
1798 
1799 	function log(bool p0, string memory p1, uint p2, address p3) internal view {
1800 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,uint,address)", p0, p1, p2, p3));
1801 	}
1802 
1803 	function log(bool p0, string memory p1, string memory p2, uint p3) internal view {
1804 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,uint)", p0, p1, p2, p3));
1805 	}
1806 
1807 	function log(bool p0, string memory p1, string memory p2, string memory p3) internal view {
1808 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,string)", p0, p1, p2, p3));
1809 	}
1810 
1811 	function log(bool p0, string memory p1, string memory p2, bool p3) internal view {
1812 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,bool)", p0, p1, p2, p3));
1813 	}
1814 
1815 	function log(bool p0, string memory p1, string memory p2, address p3) internal view {
1816 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,string,address)", p0, p1, p2, p3));
1817 	}
1818 
1819 	function log(bool p0, string memory p1, bool p2, uint p3) internal view {
1820 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,uint)", p0, p1, p2, p3));
1821 	}
1822 
1823 	function log(bool p0, string memory p1, bool p2, string memory p3) internal view {
1824 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,string)", p0, p1, p2, p3));
1825 	}
1826 
1827 	function log(bool p0, string memory p1, bool p2, bool p3) internal view {
1828 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,bool)", p0, p1, p2, p3));
1829 	}
1830 
1831 	function log(bool p0, string memory p1, bool p2, address p3) internal view {
1832 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,bool,address)", p0, p1, p2, p3));
1833 	}
1834 
1835 	function log(bool p0, string memory p1, address p2, uint p3) internal view {
1836 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,uint)", p0, p1, p2, p3));
1837 	}
1838 
1839 	function log(bool p0, string memory p1, address p2, string memory p3) internal view {
1840 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,string)", p0, p1, p2, p3));
1841 	}
1842 
1843 	function log(bool p0, string memory p1, address p2, bool p3) internal view {
1844 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,bool)", p0, p1, p2, p3));
1845 	}
1846 
1847 	function log(bool p0, string memory p1, address p2, address p3) internal view {
1848 		_sendLogPayload(abi.encodeWithSignature("log(bool,string,address,address)", p0, p1, p2, p3));
1849 	}
1850 
1851 	function log(bool p0, bool p1, uint p2, uint p3) internal view {
1852 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,uint)", p0, p1, p2, p3));
1853 	}
1854 
1855 	function log(bool p0, bool p1, uint p2, string memory p3) internal view {
1856 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,string)", p0, p1, p2, p3));
1857 	}
1858 
1859 	function log(bool p0, bool p1, uint p2, bool p3) internal view {
1860 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,bool)", p0, p1, p2, p3));
1861 	}
1862 
1863 	function log(bool p0, bool p1, uint p2, address p3) internal view {
1864 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,uint,address)", p0, p1, p2, p3));
1865 	}
1866 
1867 	function log(bool p0, bool p1, string memory p2, uint p3) internal view {
1868 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,uint)", p0, p1, p2, p3));
1869 	}
1870 
1871 	function log(bool p0, bool p1, string memory p2, string memory p3) internal view {
1872 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,string)", p0, p1, p2, p3));
1873 	}
1874 
1875 	function log(bool p0, bool p1, string memory p2, bool p3) internal view {
1876 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,bool)", p0, p1, p2, p3));
1877 	}
1878 
1879 	function log(bool p0, bool p1, string memory p2, address p3) internal view {
1880 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,string,address)", p0, p1, p2, p3));
1881 	}
1882 
1883 	function log(bool p0, bool p1, bool p2, uint p3) internal view {
1884 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,uint)", p0, p1, p2, p3));
1885 	}
1886 
1887 	function log(bool p0, bool p1, bool p2, string memory p3) internal view {
1888 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,string)", p0, p1, p2, p3));
1889 	}
1890 
1891 	function log(bool p0, bool p1, bool p2, bool p3) internal view {
1892 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,bool)", p0, p1, p2, p3));
1893 	}
1894 
1895 	function log(bool p0, bool p1, bool p2, address p3) internal view {
1896 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,bool,address)", p0, p1, p2, p3));
1897 	}
1898 
1899 	function log(bool p0, bool p1, address p2, uint p3) internal view {
1900 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,uint)", p0, p1, p2, p3));
1901 	}
1902 
1903 	function log(bool p0, bool p1, address p2, string memory p3) internal view {
1904 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,string)", p0, p1, p2, p3));
1905 	}
1906 
1907 	function log(bool p0, bool p1, address p2, bool p3) internal view {
1908 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,bool)", p0, p1, p2, p3));
1909 	}
1910 
1911 	function log(bool p0, bool p1, address p2, address p3) internal view {
1912 		_sendLogPayload(abi.encodeWithSignature("log(bool,bool,address,address)", p0, p1, p2, p3));
1913 	}
1914 
1915 	function log(bool p0, address p1, uint p2, uint p3) internal view {
1916 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,uint)", p0, p1, p2, p3));
1917 	}
1918 
1919 	function log(bool p0, address p1, uint p2, string memory p3) internal view {
1920 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,string)", p0, p1, p2, p3));
1921 	}
1922 
1923 	function log(bool p0, address p1, uint p2, bool p3) internal view {
1924 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,bool)", p0, p1, p2, p3));
1925 	}
1926 
1927 	function log(bool p0, address p1, uint p2, address p3) internal view {
1928 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,uint,address)", p0, p1, p2, p3));
1929 	}
1930 
1931 	function log(bool p0, address p1, string memory p2, uint p3) internal view {
1932 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,uint)", p0, p1, p2, p3));
1933 	}
1934 
1935 	function log(bool p0, address p1, string memory p2, string memory p3) internal view {
1936 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,string)", p0, p1, p2, p3));
1937 	}
1938 
1939 	function log(bool p0, address p1, string memory p2, bool p3) internal view {
1940 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,bool)", p0, p1, p2, p3));
1941 	}
1942 
1943 	function log(bool p0, address p1, string memory p2, address p3) internal view {
1944 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,string,address)", p0, p1, p2, p3));
1945 	}
1946 
1947 	function log(bool p0, address p1, bool p2, uint p3) internal view {
1948 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,uint)", p0, p1, p2, p3));
1949 	}
1950 
1951 	function log(bool p0, address p1, bool p2, string memory p3) internal view {
1952 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,string)", p0, p1, p2, p3));
1953 	}
1954 
1955 	function log(bool p0, address p1, bool p2, bool p3) internal view {
1956 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,bool)", p0, p1, p2, p3));
1957 	}
1958 
1959 	function log(bool p0, address p1, bool p2, address p3) internal view {
1960 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,bool,address)", p0, p1, p2, p3));
1961 	}
1962 
1963 	function log(bool p0, address p1, address p2, uint p3) internal view {
1964 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,uint)", p0, p1, p2, p3));
1965 	}
1966 
1967 	function log(bool p0, address p1, address p2, string memory p3) internal view {
1968 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,string)", p0, p1, p2, p3));
1969 	}
1970 
1971 	function log(bool p0, address p1, address p2, bool p3) internal view {
1972 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,bool)", p0, p1, p2, p3));
1973 	}
1974 
1975 	function log(bool p0, address p1, address p2, address p3) internal view {
1976 		_sendLogPayload(abi.encodeWithSignature("log(bool,address,address,address)", p0, p1, p2, p3));
1977 	}
1978 
1979 	function log(address p0, uint p1, uint p2, uint p3) internal view {
1980 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,uint)", p0, p1, p2, p3));
1981 	}
1982 
1983 	function log(address p0, uint p1, uint p2, string memory p3) internal view {
1984 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,string)", p0, p1, p2, p3));
1985 	}
1986 
1987 	function log(address p0, uint p1, uint p2, bool p3) internal view {
1988 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,bool)", p0, p1, p2, p3));
1989 	}
1990 
1991 	function log(address p0, uint p1, uint p2, address p3) internal view {
1992 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,uint,address)", p0, p1, p2, p3));
1993 	}
1994 
1995 	function log(address p0, uint p1, string memory p2, uint p3) internal view {
1996 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,uint)", p0, p1, p2, p3));
1997 	}
1998 
1999 	function log(address p0, uint p1, string memory p2, string memory p3) internal view {
2000 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,string)", p0, p1, p2, p3));
2001 	}
2002 
2003 	function log(address p0, uint p1, string memory p2, bool p3) internal view {
2004 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,bool)", p0, p1, p2, p3));
2005 	}
2006 
2007 	function log(address p0, uint p1, string memory p2, address p3) internal view {
2008 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,string,address)", p0, p1, p2, p3));
2009 	}
2010 
2011 	function log(address p0, uint p1, bool p2, uint p3) internal view {
2012 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,uint)", p0, p1, p2, p3));
2013 	}
2014 
2015 	function log(address p0, uint p1, bool p2, string memory p3) internal view {
2016 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,string)", p0, p1, p2, p3));
2017 	}
2018 
2019 	function log(address p0, uint p1, bool p2, bool p3) internal view {
2020 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,bool)", p0, p1, p2, p3));
2021 	}
2022 
2023 	function log(address p0, uint p1, bool p2, address p3) internal view {
2024 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,bool,address)", p0, p1, p2, p3));
2025 	}
2026 
2027 	function log(address p0, uint p1, address p2, uint p3) internal view {
2028 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,uint)", p0, p1, p2, p3));
2029 	}
2030 
2031 	function log(address p0, uint p1, address p2, string memory p3) internal view {
2032 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,string)", p0, p1, p2, p3));
2033 	}
2034 
2035 	function log(address p0, uint p1, address p2, bool p3) internal view {
2036 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,bool)", p0, p1, p2, p3));
2037 	}
2038 
2039 	function log(address p0, uint p1, address p2, address p3) internal view {
2040 		_sendLogPayload(abi.encodeWithSignature("log(address,uint,address,address)", p0, p1, p2, p3));
2041 	}
2042 
2043 	function log(address p0, string memory p1, uint p2, uint p3) internal view {
2044 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,uint)", p0, p1, p2, p3));
2045 	}
2046 
2047 	function log(address p0, string memory p1, uint p2, string memory p3) internal view {
2048 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,string)", p0, p1, p2, p3));
2049 	}
2050 
2051 	function log(address p0, string memory p1, uint p2, bool p3) internal view {
2052 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,bool)", p0, p1, p2, p3));
2053 	}
2054 
2055 	function log(address p0, string memory p1, uint p2, address p3) internal view {
2056 		_sendLogPayload(abi.encodeWithSignature("log(address,string,uint,address)", p0, p1, p2, p3));
2057 	}
2058 
2059 	function log(address p0, string memory p1, string memory p2, uint p3) internal view {
2060 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,uint)", p0, p1, p2, p3));
2061 	}
2062 
2063 	function log(address p0, string memory p1, string memory p2, string memory p3) internal view {
2064 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,string)", p0, p1, p2, p3));
2065 	}
2066 
2067 	function log(address p0, string memory p1, string memory p2, bool p3) internal view {
2068 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,bool)", p0, p1, p2, p3));
2069 	}
2070 
2071 	function log(address p0, string memory p1, string memory p2, address p3) internal view {
2072 		_sendLogPayload(abi.encodeWithSignature("log(address,string,string,address)", p0, p1, p2, p3));
2073 	}
2074 
2075 	function log(address p0, string memory p1, bool p2, uint p3) internal view {
2076 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,uint)", p0, p1, p2, p3));
2077 	}
2078 
2079 	function log(address p0, string memory p1, bool p2, string memory p3) internal view {
2080 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,string)", p0, p1, p2, p3));
2081 	}
2082 
2083 	function log(address p0, string memory p1, bool p2, bool p3) internal view {
2084 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,bool)", p0, p1, p2, p3));
2085 	}
2086 
2087 	function log(address p0, string memory p1, bool p2, address p3) internal view {
2088 		_sendLogPayload(abi.encodeWithSignature("log(address,string,bool,address)", p0, p1, p2, p3));
2089 	}
2090 
2091 	function log(address p0, string memory p1, address p2, uint p3) internal view {
2092 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,uint)", p0, p1, p2, p3));
2093 	}
2094 
2095 	function log(address p0, string memory p1, address p2, string memory p3) internal view {
2096 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,string)", p0, p1, p2, p3));
2097 	}
2098 
2099 	function log(address p0, string memory p1, address p2, bool p3) internal view {
2100 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,bool)", p0, p1, p2, p3));
2101 	}
2102 
2103 	function log(address p0, string memory p1, address p2, address p3) internal view {
2104 		_sendLogPayload(abi.encodeWithSignature("log(address,string,address,address)", p0, p1, p2, p3));
2105 	}
2106 
2107 	function log(address p0, bool p1, uint p2, uint p3) internal view {
2108 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,uint)", p0, p1, p2, p3));
2109 	}
2110 
2111 	function log(address p0, bool p1, uint p2, string memory p3) internal view {
2112 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,string)", p0, p1, p2, p3));
2113 	}
2114 
2115 	function log(address p0, bool p1, uint p2, bool p3) internal view {
2116 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,bool)", p0, p1, p2, p3));
2117 	}
2118 
2119 	function log(address p0, bool p1, uint p2, address p3) internal view {
2120 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,uint,address)", p0, p1, p2, p3));
2121 	}
2122 
2123 	function log(address p0, bool p1, string memory p2, uint p3) internal view {
2124 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,uint)", p0, p1, p2, p3));
2125 	}
2126 
2127 	function log(address p0, bool p1, string memory p2, string memory p3) internal view {
2128 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,string)", p0, p1, p2, p3));
2129 	}
2130 
2131 	function log(address p0, bool p1, string memory p2, bool p3) internal view {
2132 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,bool)", p0, p1, p2, p3));
2133 	}
2134 
2135 	function log(address p0, bool p1, string memory p2, address p3) internal view {
2136 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,string,address)", p0, p1, p2, p3));
2137 	}
2138 
2139 	function log(address p0, bool p1, bool p2, uint p3) internal view {
2140 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,uint)", p0, p1, p2, p3));
2141 	}
2142 
2143 	function log(address p0, bool p1, bool p2, string memory p3) internal view {
2144 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,string)", p0, p1, p2, p3));
2145 	}
2146 
2147 	function log(address p0, bool p1, bool p2, bool p3) internal view {
2148 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,bool)", p0, p1, p2, p3));
2149 	}
2150 
2151 	function log(address p0, bool p1, bool p2, address p3) internal view {
2152 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,bool,address)", p0, p1, p2, p3));
2153 	}
2154 
2155 	function log(address p0, bool p1, address p2, uint p3) internal view {
2156 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,uint)", p0, p1, p2, p3));
2157 	}
2158 
2159 	function log(address p0, bool p1, address p2, string memory p3) internal view {
2160 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,string)", p0, p1, p2, p3));
2161 	}
2162 
2163 	function log(address p0, bool p1, address p2, bool p3) internal view {
2164 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,bool)", p0, p1, p2, p3));
2165 	}
2166 
2167 	function log(address p0, bool p1, address p2, address p3) internal view {
2168 		_sendLogPayload(abi.encodeWithSignature("log(address,bool,address,address)", p0, p1, p2, p3));
2169 	}
2170 
2171 	function log(address p0, address p1, uint p2, uint p3) internal view {
2172 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,uint)", p0, p1, p2, p3));
2173 	}
2174 
2175 	function log(address p0, address p1, uint p2, string memory p3) internal view {
2176 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,string)", p0, p1, p2, p3));
2177 	}
2178 
2179 	function log(address p0, address p1, uint p2, bool p3) internal view {
2180 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,bool)", p0, p1, p2, p3));
2181 	}
2182 
2183 	function log(address p0, address p1, uint p2, address p3) internal view {
2184 		_sendLogPayload(abi.encodeWithSignature("log(address,address,uint,address)", p0, p1, p2, p3));
2185 	}
2186 
2187 	function log(address p0, address p1, string memory p2, uint p3) internal view {
2188 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,uint)", p0, p1, p2, p3));
2189 	}
2190 
2191 	function log(address p0, address p1, string memory p2, string memory p3) internal view {
2192 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,string)", p0, p1, p2, p3));
2193 	}
2194 
2195 	function log(address p0, address p1, string memory p2, bool p3) internal view {
2196 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,bool)", p0, p1, p2, p3));
2197 	}
2198 
2199 	function log(address p0, address p1, string memory p2, address p3) internal view {
2200 		_sendLogPayload(abi.encodeWithSignature("log(address,address,string,address)", p0, p1, p2, p3));
2201 	}
2202 
2203 	function log(address p0, address p1, bool p2, uint p3) internal view {
2204 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,uint)", p0, p1, p2, p3));
2205 	}
2206 
2207 	function log(address p0, address p1, bool p2, string memory p3) internal view {
2208 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,string)", p0, p1, p2, p3));
2209 	}
2210 
2211 	function log(address p0, address p1, bool p2, bool p3) internal view {
2212 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,bool)", p0, p1, p2, p3));
2213 	}
2214 
2215 	function log(address p0, address p1, bool p2, address p3) internal view {
2216 		_sendLogPayload(abi.encodeWithSignature("log(address,address,bool,address)", p0, p1, p2, p3));
2217 	}
2218 
2219 	function log(address p0, address p1, address p2, uint p3) internal view {
2220 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,uint)", p0, p1, p2, p3));
2221 	}
2222 
2223 	function log(address p0, address p1, address p2, string memory p3) internal view {
2224 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,string)", p0, p1, p2, p3));
2225 	}
2226 
2227 	function log(address p0, address p1, address p2, bool p3) internal view {
2228 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,bool)", p0, p1, p2, p3));
2229 	}
2230 
2231 	function log(address p0, address p1, address p2, address p3) internal view {
2232 		_sendLogPayload(abi.encodeWithSignature("log(address,address,address,address)", p0, p1, p2, p3));
2233 	}
2234 
2235 }
2236 
2237 
2238 // File contracts/StakingPoolsV4.sol
2239 
2240 contract StakingPoolsV4 is ReentrancyGuard {
2241     using SafeMath for uint256;
2242     using SafeERC20 for IERC20;
2243 
2244     // Info of each user.
2245     struct UserInfo {
2246         uint256 amount;     // How many LP tokens the user has provided.
2247         uint256 workingAmount; // actual amount * ve boost * lockup bonus
2248         uint256 rewardDebt; // Reward debt.
2249         uint256 power;
2250     }
2251 
2252     // Info of each pool.
2253     struct PoolInfo {
2254         IERC20 lpToken;           // Address of LP token contract.
2255         uint256 allocPoint;       // How many allocation points assigned to this pool.
2256         uint256 lastRewardBlock;   // Last block number that Wasabi distribution occurs.
2257         uint256 accRewardPerShare;  // Accumulated Wasabi per share, times 1e18. See below.
2258         uint256 workingSupply;    // Total supply of working amount
2259         uint256 totalDeposited;
2260         bool needVesting;
2261         uint256 earlyWithdrawFee; // divided by 10000
2262         uint256 withdrawLock; // in second
2263         bool veBoostEnabled;
2264 
2265         mapping (address => UserInfo) userInfo;
2266     }
2267 
2268     /// @dev A mapping of all of the user deposit time mapped first by pool and then by address.
2269     mapping(address => mapping(uint256 => uint256)) private _depositedAt;
2270 
2271     /// @dev A mapping of userIsKnown mapped first by pool and then by address.
2272     mapping(address => mapping(uint256 => bool)) public userIsKnown;
2273 
2274     /// @dev A mapping of userAddress mapped first by pool and then by nextUser.
2275     mapping(uint256 => mapping(uint256 => address)) public userList;
2276 
2277     /// @dev index record next user index mapped by pool
2278     mapping(uint256 => uint256) public nextUser;
2279 
2280     // The Wasabi TOKEN!
2281     IMintableERC20 public reward;
2282 
2283     /// @dev The address of reward vesting.
2284     IRewardVesting public rewardVesting;
2285 
2286     IVotingEscrow public veWasabi;
2287 
2288     uint256 public rewardRate;
2289 
2290     // Info of each pool.
2291     PoolInfo[] public poolInfo;
2292     // Total allocation points. Must be the sum of all allocation points in all pools.
2293     uint256 public totalAllocPoint = 0;
2294 
2295     bool public mintWasabi;
2296 
2297     uint256[] public feeLevel; // fixed length = 9 (unit without 10^18); [50,200,500,1000,2000,3500,6000,9000,11000]
2298     uint256[] public discountTable; // fixed length = 9; [9,19,28,40,50,60,70,80,90]
2299     uint256 public withdrawFee;
2300 
2301 
2302     uint256 private constant hundred = 100;
2303 
2304     /// @dev The address of the account which currently has administrative capabilities over this contract.
2305     address public governance;
2306 
2307     address public pendingGovernance;
2308 
2309     /// @dev The address of the account which can perform emergency activities
2310     address public sentinel;
2311 
2312     address public withdrawFeeCollector;
2313 
2314     bool public pause;
2315 
2316 
2317     event PoolCreated(
2318       uint256 indexed poolId,
2319       IERC20 indexed token
2320     );
2321 
2322     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
2323     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
2324     event Claim(address indexed user, uint256 indexed pid, uint256 amount);
2325     event WorkingAmountUpdate(
2326         address indexed user,
2327         uint256 indexed pid,
2328         uint256 newWorkingAmount,
2329         uint256 newWorkingSupply
2330     );
2331 
2332     event PendingGovernanceUpdated(
2333       address pendingGovernance
2334     );
2335 
2336     event GovernanceUpdated(
2337       address governance
2338     );
2339 
2340     event WithdrawFeeCollectorUpdated(
2341       address withdrawFeeCollector
2342     );
2343 
2344     event RewardVestingUpdated(
2345       IRewardVesting rewardVesting
2346     );
2347 
2348     event PauseUpdated(
2349       bool status
2350     );
2351 
2352     event SentinelUpdated(
2353       address sentinel
2354     );
2355 
2356     event RewardRateUpdated(
2357       uint256 rewardRate
2358     );
2359 
2360     // solium-disable-next-line
2361     constructor(address _governance, address _sentinel,address _withdrawFeeCollector) public {
2362       require(_governance != address(0), "StakingPoolsV4: governance address cannot be 0x0");
2363       require(_sentinel != address(0), "StakingPoolsV4: sentinel address cannot be 0x0");
2364       require(_withdrawFeeCollector != address(0), "StakingPoolsV4: withdrawFee collector address cannot be 0x0");
2365       governance = _governance;
2366       sentinel = _sentinel;
2367       withdrawFeeCollector = _withdrawFeeCollector;
2368       feeLevel = [50,200,500,1000,2000,3500,6000,9000,11000];
2369       discountTable = [10,20,30,40,50,60,72,81,91];
2370       withdrawFee = 20;
2371 
2372     }
2373 
2374     modifier onlyGovernance() {
2375       require(msg.sender == governance, "StakingPoolsV4: only governance");
2376       _;
2377     }
2378 
2379     ///@dev modifier add users to userlist. Users are indexed in order to keep track of
2380     modifier checkIfNewUser(uint256 pid) {
2381         if (!userIsKnown[msg.sender][pid]) {
2382             userList[nextUser[pid]][pid] = msg.sender;
2383             userIsKnown[msg.sender][pid] = true;
2384             nextUser[pid]++;
2385         }
2386         _;
2387     }
2388 
2389     function initialize(
2390         IMintableERC20 _rewardToken,
2391         IVotingEscrow _veWasabi,
2392         IRewardVesting _rewardVesting,
2393         bool _mintWasabi
2394     )
2395         external
2396         onlyGovernance
2397     {
2398         reward = _rewardToken;
2399         veWasabi = _veWasabi;
2400         rewardVesting = _rewardVesting;
2401         mintWasabi = _mintWasabi;
2402 
2403     }
2404 
2405     function setPendingGovernance(address _pendingGovernance) external onlyGovernance {
2406       require(_pendingGovernance != address(0), "StakingPoolsV4: pending governance address cannot be 0x0");
2407       pendingGovernance = _pendingGovernance;
2408 
2409       emit PendingGovernanceUpdated(_pendingGovernance);
2410     }
2411 
2412     function acceptGovernance() external {
2413       require(msg.sender == pendingGovernance, "StakingPoolsV4: only pending governance");
2414 
2415       address _pendingGovernance = pendingGovernance;
2416       governance = _pendingGovernance;
2417 
2418       emit GovernanceUpdated(_pendingGovernance);
2419     }
2420 
2421     function poolLength() external view returns (uint256) {
2422         return poolInfo.length;
2423     }
2424 
2425     // Add a new lp to the pool. Can only be called by the owner.
2426     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
2427     function add(
2428         uint256 _allocPoint,
2429         IERC20 _lpToken,
2430         bool _needVesting,
2431         uint256 _earlyWithdrawFee,
2432         uint256 _withdrawLock,
2433         bool _veBoostEnabled,
2434         bool _withUpdate
2435     )
2436         public
2437         onlyGovernance
2438     {
2439         if (_withUpdate) {
2440             massUpdatePools();
2441         }
2442 
2443         uint256 poolId = poolInfo.length;
2444         uint256 lastRewardBlock = block.number;
2445         totalAllocPoint = totalAllocPoint.add(_allocPoint);
2446         poolInfo.push(PoolInfo({
2447             lpToken: _lpToken,
2448             allocPoint: _allocPoint,
2449             lastRewardBlock: lastRewardBlock,
2450             accRewardPerShare: 0,
2451             workingSupply: 0,
2452             totalDeposited: 0,
2453             needVesting:_needVesting,
2454             earlyWithdrawFee:_earlyWithdrawFee,
2455             withdrawLock:_withdrawLock,
2456             veBoostEnabled:_veBoostEnabled
2457         }));
2458 
2459 
2460         emit PoolCreated(poolId, _lpToken);
2461     }
2462 
2463     // Update the given pool's SMTY allocation point. Can only be called by the owner.
2464     function set(
2465         uint256 _pid,
2466         uint256 _allocPoint,
2467         bool _withUpdate
2468     )
2469         public
2470         onlyGovernance
2471     {
2472         if (_withUpdate) {
2473             massUpdatePools();
2474         }
2475         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
2476         poolInfo[_pid].allocPoint = _allocPoint;
2477     }
2478 
2479     function setRewardRate(uint256 _rewardRate) external onlyGovernance {
2480       massUpdatePools();
2481 
2482       rewardRate = _rewardRate;
2483 
2484       emit RewardRateUpdated(_rewardRate);
2485     }
2486 
2487     // Return block rewards over the given _from (inclusive) to _to (inclusive) block.
2488     function getBlockReward(uint256 _from, uint256 _to) public view returns (uint256) {
2489         uint256 to = _to;
2490         uint256 from = _from;
2491 
2492         if (from > to) {
2493             return 0;
2494         }
2495 
2496 
2497         uint256 rewardPerBlock = rewardRate;
2498         uint256 totalRewards = (to.sub(from)).mul(rewardPerBlock);
2499 
2500         return totalRewards;
2501     }
2502 
2503     // View function to see pending SMTYs on frontend.
2504     function pendingReward(uint256 _pid, address _user) external view returns (uint256) {
2505         PoolInfo storage pool = poolInfo[_pid];
2506         UserInfo storage user = pool.userInfo[_user];
2507         uint256 accRewardPerShare = pool.accRewardPerShare;
2508         uint256 workingSupply = pool.workingSupply;
2509         if (block.number > pool.lastRewardBlock && workingSupply != 0) {
2510             uint256 wasabiReward = getBlockReward(pool.lastRewardBlock, block.number).mul(
2511                 pool.allocPoint).div(totalAllocPoint);
2512             accRewardPerShare = accRewardPerShare.add(wasabiReward.mul(1e18).div(workingSupply));
2513         }
2514         return user.workingAmount.mul(accRewardPerShare).div(1e18).sub(user.rewardDebt);
2515     }
2516 
2517     // View Accumulated Power
2518     function accumulatedPower(address _user, uint256 _pid) external view returns (uint256) {
2519         PoolInfo storage pool = poolInfo[_pid];
2520         UserInfo storage user = pool.userInfo[_user];
2521         uint256 accRewardPerShare = pool.accRewardPerShare;
2522         uint256 workingSupply = pool.workingSupply;
2523         if (block.number > pool.lastRewardBlock && workingSupply != 0) {
2524             uint256 wasabiReward = getBlockReward(pool.lastRewardBlock, block.number).mul(
2525                 pool.allocPoint).div(totalAllocPoint);
2526             accRewardPerShare = accRewardPerShare.add(wasabiReward.mul(1e18).div(workingSupply));
2527         }
2528         return user.power.add(user.workingAmount.mul(accRewardPerShare).div(1e18).sub(user.rewardDebt));
2529     }
2530 
2531     function getPoolUser(uint256 _poolId, uint256 _userIndex) external view returns (address) {
2532       return userList[_userIndex][_poolId];
2533     }
2534 
2535     // Update reward variables for all pools. Be careful of gas spending!
2536     function massUpdatePools() public {
2537         uint256 length = poolInfo.length;
2538         for (uint256 pid = 0; pid < length; ++pid) {
2539             updatePool(pid);
2540         }
2541     }
2542 
2543     // Update reward variables of the given pool to be up-to-date.
2544     function updatePool(uint256 _pid) public {
2545         _updatePool(_pid);
2546     }
2547 
2548     function _updatePool(uint256 _pid) internal {
2549         PoolInfo storage pool = poolInfo[_pid];
2550         if (block.number <= pool.lastRewardBlock) {
2551             return;
2552         }
2553         uint256 workingSupply = pool.workingSupply;
2554         if (workingSupply == 0) {
2555             pool.lastRewardBlock = block.number;
2556             return;
2557         }
2558         uint256 wasabiReward = getBlockReward(pool.lastRewardBlock, block.number).mul(
2559             pool.allocPoint).div(totalAllocPoint);
2560         if (mintWasabi) {
2561             reward.mint(address(this), wasabiReward);
2562         }
2563         pool.accRewardPerShare = pool.accRewardPerShare.add(wasabiReward.mul(1e18).div(workingSupply));
2564 
2565         pool.lastRewardBlock = block.number;
2566     }
2567 
2568     modifier claimReward(uint256 _pid, address _account) {
2569         require(!pause, "StakingPoolsV4: emergency pause enabled");
2570 
2571         PoolInfo storage pool = poolInfo[_pid];
2572         UserInfo storage user = pool.userInfo[_account];
2573         _updatePool(_pid);
2574 
2575         if (user.workingAmount > 0) {
2576           uint256 rewardPending = user.workingAmount.mul(pool.accRewardPerShare).div(1e18).sub(user.rewardDebt);
2577           if(pool.needVesting){
2578             reward.approve(address(rewardVesting),uint(-1));
2579             rewardVesting.addEarning(_account,rewardPending);
2580           } else {
2581             safeWasabiTransfer(_account, rewardPending);
2582           }
2583           user.power = user.power.add(rewardPending);
2584         }
2585 
2586         _; // amount/boost may be changed
2587 
2588         _updateWorkingAmount(_pid, _account);
2589         user.rewardDebt = user.workingAmount.mul(pool.accRewardPerShare).div(1e18);
2590     }
2591 
2592     function _updateWorkingAmount(
2593         uint256 _pid,
2594         address _account
2595     ) internal
2596     {
2597         PoolInfo storage pool = poolInfo[_pid];
2598         UserInfo storage user = pool.userInfo[_account];
2599 
2600         uint256 lim = user.amount.mul(4).div(10);
2601 
2602         uint256 votingBalance = veWasabi.balanceOf(_account);
2603         uint256 totalBalance = veWasabi.totalSupply();
2604 
2605         if (totalBalance != 0 && pool.veBoostEnabled) {
2606             uint256 lsupply = pool.totalDeposited;
2607             lim = lim.add(lsupply.mul(votingBalance).div(totalBalance).mul(6).div(10));
2608         }
2609 
2610         uint256 veAmount = Math.min(user.amount, lim);
2611 
2612         pool.workingSupply = pool.workingSupply.sub(user.workingAmount).add(veAmount);
2613         user.workingAmount = veAmount;
2614 
2615         emit WorkingAmountUpdate(_account, _pid, user.workingAmount, pool.workingSupply);
2616     }
2617 
2618     /*
2619      * Deposit without lock.
2620      */
2621     function deposit(uint256 _pid, uint256 _amount) external nonReentrant claimReward(_pid, msg.sender) checkIfNewUser(_pid) {
2622         PoolInfo storage pool = poolInfo[_pid];
2623         UserInfo storage user = pool.userInfo[msg.sender];
2624 
2625         if (_amount > 0) {
2626             _depositedAt[msg.sender][_pid] = block.timestamp;
2627             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
2628             user.amount = user.amount.add(_amount);
2629             pool.totalDeposited = pool.totalDeposited.add(_amount);
2630         }
2631 
2632         emit Deposit(msg.sender, _pid, _amount);
2633     }
2634 
2635 
2636     function setFeeLevel(uint256[] calldata _feeLevel) external onlyGovernance {
2637       require(_feeLevel.length == 9, "StakingPoolsV4: feeLevel length mismatch");
2638       feeLevel = _feeLevel;
2639     }
2640 
2641     function setDiscountTable(uint256[] calldata _discountTable) external onlyGovernance {
2642       require(_discountTable.length == 9, "StakingPoolsV4: discountTable length mismatch");
2643       discountTable = _discountTable;
2644     }
2645 
2646     function setWithdrawFee(uint256 _withdrawFee) external onlyGovernance {
2647       withdrawFee = _withdrawFee;
2648     }
2649 
2650     function withdraw(uint256 _pid, uint256 amount) external nonReentrant {
2651       _withdraw(_pid, amount);
2652     }
2653 
2654     function _withdraw(uint256 _pid, uint256 amount) internal claimReward(_pid, msg.sender) {
2655         PoolInfo storage pool = poolInfo[_pid];
2656         UserInfo storage user = pool.userInfo[msg.sender];
2657 
2658         require(amount <= user.amount, "StakingPoolsV4: withdraw too much");
2659 
2660         pool.totalDeposited = pool.totalDeposited.sub(amount);
2661         user.amount = user.amount - amount;
2662 
2663         uint256 withdrawPenalty = 0;
2664         uint256 finalizedAmount = amount;
2665         uint256 depositTimestamp = _depositedAt[msg.sender][_pid];
2666 
2667         if (depositTimestamp.add(pool.withdrawLock) > block.timestamp) {
2668           withdrawPenalty = amount.mul(pool.earlyWithdrawFee).div(10000);
2669 
2670           pool.lpToken.safeTransfer(withdrawFeeCollector, withdrawPenalty);
2671           finalizedAmount = finalizedAmount.sub(withdrawPenalty);
2672         } else {
2673           uint256 votingBalance = veWasabi.balanceOf(msg.sender);
2674           withdrawPenalty = amount.mul(withdrawFee).div(10000);
2675 
2676 
2677           for (uint256 i = 0; i < 9; ++i) {
2678             if(votingBalance >= (feeLevel[i]).mul(1 ether)){
2679               withdrawPenalty = amount.mul(withdrawFee).div(10000);
2680               withdrawPenalty = withdrawPenalty.mul(hundred.sub(discountTable[i])).div(hundred);
2681             }
2682           }
2683           pool.lpToken.safeTransfer(withdrawFeeCollector, withdrawPenalty);
2684           finalizedAmount = finalizedAmount.sub(withdrawPenalty);
2685         }
2686 
2687         pool.lpToken.safeTransfer(msg.sender, finalizedAmount);
2688 
2689         emit Withdraw(msg.sender, _pid, amount);
2690     }
2691 
2692     // solium-disable-next-line
2693     function claim(uint256 _pid) external nonReentrant claimReward(_pid, msg.sender) {
2694     }
2695 
2696     // Safe smty transfer function, just in case if rounding error causes pool to not have enough SMTYs.
2697     function safeWasabiTransfer(address _to, uint256 _amount) internal {
2698         if (_amount > 0) {
2699             uint256 wasabiBal = reward.balanceOf(address(this));
2700             if (_amount > wasabiBal) {
2701                 reward.transfer(_to, wasabiBal);
2702             } else {
2703                 reward.transfer(_to, _amount);
2704             }
2705         }
2706     }
2707 
2708     function getUserInfo(address _account, uint256 _poolId) public view returns(uint, uint, uint) {
2709         PoolInfo storage pool = poolInfo[_poolId];
2710         UserInfo storage user = pool.userInfo[_account];
2711 
2712         return (user.amount, user.workingAmount, user.rewardDebt);
2713     }
2714 
2715     function getDepositedAt(address _account, uint256 _poolId) external view returns (uint256) {
2716       return _depositedAt[_account][_poolId];
2717     }
2718 
2719     /// @dev Updates the reward vesting contract
2720     ///
2721     /// @param _rewardVesting the new reward vesting contract
2722     function setRewardVesting(IRewardVesting _rewardVesting) external {
2723       require(pause && (msg.sender == governance || msg.sender == sentinel), "StakingPoolsV4: not paused, or not governance or sentinel");
2724       rewardVesting = _rewardVesting;
2725       emit RewardVestingUpdated(_rewardVesting);
2726     }
2727 
2728     /// @dev Sets the address of the sentinel
2729     ///
2730     /// @param _sentinel address of the new sentinel
2731     function setSentinel(address _sentinel) external onlyGovernance {
2732         require(_sentinel != address(0), "StakingPoolsV4: sentinel address cannot be 0x0.");
2733         sentinel = _sentinel;
2734         emit SentinelUpdated(_sentinel);
2735     }
2736 
2737     /// @dev Sets if the contract should enter emergency pause mode.
2738     ///
2739     /// There are 2 main reasons to pause:
2740     ///     1. Need to shut down claims in case of any issues in the reward vesting contract
2741     ///     2. Need to migrate to a new reward vesting contract
2742     ///
2743     /// While this contract is paused, claim is disabled
2744     ///
2745     /// @param _pause if the contract should enter emergency pause mode.
2746     function setPause(bool _pause) external {
2747         require(msg.sender == governance || msg.sender == sentinel, "StakingPoolsV4: !(gov || sentinel)");
2748         pause = _pause;
2749         emit PauseUpdated(_pause);
2750     }
2751 
2752     function setWithdrawFeeCollector(address _newWithdrawFeeCollector) external onlyGovernance {
2753         require(_newWithdrawFeeCollector != address(0), "StakingPoolsV4: withdrawFeeCollector address cannot be 0x0.");
2754         withdrawFeeCollector = _newWithdrawFeeCollector;
2755         emit WithdrawFeeCollectorUpdated(_newWithdrawFeeCollector);
2756     }
2757 }