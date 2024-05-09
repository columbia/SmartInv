1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
28 // File: @openzeppelin/contracts/GSN/Context.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
35 
36 // SPDX-License-Identifier: MIT
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
114 // File: @openzeppelin/contracts/math/SafeMath.sol
115 
116 // SPDX-License-Identifier: MIT
117 
118 pragma solidity >=0.6.0 <0.8.0;
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, with an overflow flag.
136      *
137      * _Available since v3.4._
138      */
139     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
140         uint256 c = a + b;
141         if (c < a) return (false, 0);
142         return (true, c);
143     }
144 
145     /**
146      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         if (b > a) return (false, 0);
152         return (true, a - b);
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
157      *
158      * _Available since v3.4._
159      */
160     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
161         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
162         // benefit is lost if 'b' is also tested.
163         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
164         if (a == 0) return (true, 0);
165         uint256 c = a * b;
166         if (c / a != b) return (false, 0);
167         return (true, c);
168     }
169 
170     /**
171      * @dev Returns the division of two unsigned integers, with a division by zero flag.
172      *
173      * _Available since v3.4._
174      */
175     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
176         if (b == 0) return (false, 0);
177         return (true, a / b);
178     }
179 
180     /**
181      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
182      *
183      * _Available since v3.4._
184      */
185     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
186         if (b == 0) return (false, 0);
187         return (true, a % b);
188     }
189 
190     /**
191      * @dev Returns the addition of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `+` operator.
195      *
196      * Requirements:
197      *
198      * - Addition cannot overflow.
199      */
200     function add(uint256 a, uint256 b) internal pure returns (uint256) {
201         uint256 c = a + b;
202         require(c >= a, "SafeMath: addition overflow");
203         return c;
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, reverting on
208      * overflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      *
214      * - Subtraction cannot overflow.
215      */
216     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
217         require(b <= a, "SafeMath: subtraction overflow");
218         return a - b;
219     }
220 
221     /**
222      * @dev Returns the multiplication of two unsigned integers, reverting on
223      * overflow.
224      *
225      * Counterpart to Solidity's `*` operator.
226      *
227      * Requirements:
228      *
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         if (a == 0) return 0;
233         uint256 c = a * b;
234         require(c / a == b, "SafeMath: multiplication overflow");
235         return c;
236     }
237 
238     /**
239      * @dev Returns the integer division of two unsigned integers, reverting on
240      * division by zero. The result is rounded towards zero.
241      *
242      * Counterpart to Solidity's `/` operator. Note: this function uses a
243      * `revert` opcode (which leaves remaining gas untouched) while Solidity
244      * uses an invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         require(b > 0, "SafeMath: division by zero");
252         return a / b;
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * reverting when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
268         require(b > 0, "SafeMath: modulo by zero");
269         return a % b;
270     }
271 
272     /**
273      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
274      * overflow (when the result is negative).
275      *
276      * CAUTION: This function is deprecated because it requires allocating memory for the error
277      * message unnecessarily. For custom revert reasons use {trySub}.
278      *
279      * Counterpart to Solidity's `-` operator.
280      *
281      * Requirements:
282      *
283      * - Subtraction cannot overflow.
284      */
285     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b <= a, errorMessage);
287         return a - b;
288     }
289 
290     /**
291      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
292      * division by zero. The result is rounded towards zero.
293      *
294      * CAUTION: This function is deprecated because it requires allocating memory for the error
295      * message unnecessarily. For custom revert reasons use {tryDiv}.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b > 0, errorMessage);
307         return a / b;
308     }
309 
310     /**
311      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
312      * reverting with custom message when dividing by zero.
313      *
314      * CAUTION: This function is deprecated because it requires allocating memory for the error
315      * message unnecessarily. For custom revert reasons use {tryMod}.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
326         require(b > 0, errorMessage);
327         return a % b;
328     }
329 }
330 
331 // File: @openzeppelin/contracts/utils/Address.sol
332 
333 // SPDX-License-Identifier: MIT
334 
335 pragma solidity >=0.6.2 <0.8.0;
336 
337 /**
338  * @dev Collection of functions related to the address type
339  */
340 library Address {
341     /**
342      * @dev Returns true if `account` is a contract.
343      *
344      * [IMPORTANT]
345      * ====
346      * It is unsafe to assume that an address for which this function returns
347      * false is an externally-owned account (EOA) and not a contract.
348      *
349      * Among others, `isContract` will return false for the following
350      * types of addresses:
351      *
352      *  - an externally-owned account
353      *  - a contract in construction
354      *  - an address where a contract will be created
355      *  - an address where a contract lived, but was destroyed
356      * ====
357      */
358     function isContract(address account) internal view returns (bool) {
359         // This method relies on extcodesize, which returns 0 for contracts in
360         // construction, since the code is only stored at the end of the
361         // constructor execution.
362 
363         uint256 size;
364         // solhint-disable-next-line no-inline-assembly
365         assembly { size := extcodesize(account) }
366         return size > 0;
367     }
368 
369     /**
370      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
371      * `recipient`, forwarding all available gas and reverting on errors.
372      *
373      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
374      * of certain opcodes, possibly making contracts go over the 2300 gas limit
375      * imposed by `transfer`, making them unable to receive funds via
376      * `transfer`. {sendValue} removes this limitation.
377      *
378      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
379      *
380      * IMPORTANT: because control is transferred to `recipient`, care must be
381      * taken to not create reentrancy vulnerabilities. Consider using
382      * {ReentrancyGuard} or the
383      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
384      */
385     function sendValue(address payable recipient, uint256 amount) internal {
386         require(address(this).balance >= amount, "Address: insufficient balance");
387 
388         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
389         (bool success, ) = recipient.call{ value: amount }("");
390         require(success, "Address: unable to send value, recipient may have reverted");
391     }
392 
393     /**
394      * @dev Performs a Solidity function call using a low level `call`. A
395      * plain`call` is an unsafe replacement for a function call: use this
396      * function instead.
397      *
398      * If `target` reverts with a revert reason, it is bubbled up by this
399      * function (like regular Solidity function calls).
400      *
401      * Returns the raw returned data. To convert to the expected return value,
402      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
403      *
404      * Requirements:
405      *
406      * - `target` must be a contract.
407      * - calling `target` with `data` must not revert.
408      *
409      * _Available since v3.1._
410      */
411     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
412       return functionCall(target, data, "Address: low-level call failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
417      * `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
422         return functionCallWithValue(target, data, 0, errorMessage);
423     }
424 
425     /**
426      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
427      * but also transferring `value` wei to `target`.
428      *
429      * Requirements:
430      *
431      * - the calling contract must have an ETH balance of at least `value`.
432      * - the called Solidity function must be `payable`.
433      *
434      * _Available since v3.1._
435      */
436     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
437         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
438     }
439 
440     /**
441      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
442      * with `errorMessage` as a fallback revert reason when `target` reverts.
443      *
444      * _Available since v3.1._
445      */
446     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
447         require(address(this).balance >= value, "Address: insufficient balance for call");
448         require(isContract(target), "Address: call to non-contract");
449 
450         // solhint-disable-next-line avoid-low-level-calls
451         (bool success, bytes memory returndata) = target.call{ value: value }(data);
452         return _verifyCallResult(success, returndata, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but performing a static call.
458      *
459      * _Available since v3.3._
460      */
461     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
462         return functionStaticCall(target, data, "Address: low-level static call failed");
463     }
464 
465     /**
466      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
467      * but performing a static call.
468      *
469      * _Available since v3.3._
470      */
471     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
472         require(isContract(target), "Address: static call to non-contract");
473 
474         // solhint-disable-next-line avoid-low-level-calls
475         (bool success, bytes memory returndata) = target.staticcall(data);
476         return _verifyCallResult(success, returndata, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but performing a delegate call.
482      *
483      * _Available since v3.4._
484      */
485     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
486         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
487     }
488 
489     /**
490      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
491      * but performing a delegate call.
492      *
493      * _Available since v3.4._
494      */
495     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
496         require(isContract(target), "Address: delegate call to non-contract");
497 
498         // solhint-disable-next-line avoid-low-level-calls
499         (bool success, bytes memory returndata) = target.delegatecall(data);
500         return _verifyCallResult(success, returndata, errorMessage);
501     }
502 
503     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 // solhint-disable-next-line no-inline-assembly
512                 assembly {
513                     let returndata_size := mload(returndata)
514                     revert(add(32, returndata), returndata_size)
515                 }
516             } else {
517                 revert(errorMessage);
518             }
519         }
520     }
521 }
522 
523 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
524 
525 // SPDX-License-Identifier: MIT
526 
527 pragma solidity >=0.6.0 <0.8.0;
528 
529 /**
530  * @dev Contract module that helps prevent reentrant calls to a function.
531  *
532  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
533  * available, which can be applied to functions to make sure there are no nested
534  * (reentrant) calls to them.
535  *
536  * Note that because there is a single `nonReentrant` guard, functions marked as
537  * `nonReentrant` may not call one another. This can be worked around by making
538  * those functions `private`, and then adding `external` `nonReentrant` entry
539  * points to them.
540  *
541  * TIP: If you would like to learn more about reentrancy and alternative ways
542  * to protect against it, check out our blog post
543  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
544  */
545 abstract contract ReentrancyGuard {
546     // Booleans are more expensive than uint256 or any type that takes up a full
547     // word because each write operation emits an extra SLOAD to first read the
548     // slot's contents, replace the bits taken up by the boolean, and then write
549     // back. This is the compiler's defense against contract upgrades and
550     // pointer aliasing, and it cannot be disabled.
551 
552     // The values being non-zero value makes deployment a bit more expensive,
553     // but in exchange the refund on every call to nonReentrant will be lower in
554     // amount. Since refunds are capped to a percentage of the total
555     // transaction's gas, it is best to keep them low in cases like this one, to
556     // increase the likelihood of the full refund coming into effect.
557     uint256 private constant _NOT_ENTERED = 1;
558     uint256 private constant _ENTERED = 2;
559 
560     uint256 private _status;
561 
562     constructor () internal {
563         _status = _NOT_ENTERED;
564     }
565 
566     /**
567      * @dev Prevents a contract from calling itself, directly or indirectly.
568      * Calling a `nonReentrant` function from another `nonReentrant`
569      * function is not supported. It is possible to prevent this from happening
570      * by making the `nonReentrant` function external, and make it call a
571      * `private` function that does the actual work.
572      */
573     modifier nonReentrant() {
574         // On the first call to nonReentrant, _notEntered will be true
575         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
576 
577         // Any calls to nonReentrant after this point will fail
578         _status = _ENTERED;
579 
580         _;
581 
582         // By storing the original value once again, a refund is triggered (see
583         // https://eips.ethereum.org/EIPS/eip-2200)
584         _status = _NOT_ENTERED;
585     }
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
589 
590 // SPDX-License-Identifier: MIT
591 
592 pragma solidity >=0.6.0 <0.8.0;
593 
594 
595 
596 
597 /**
598  * @title SafeERC20
599  * @dev Wrappers around ERC20 operations that throw on failure (when the token
600  * contract returns false). Tokens that return no value (and instead revert or
601  * throw on failure) are also supported, non-reverting calls are assumed to be
602  * successful.
603  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
604  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
605  */
606 library SafeERC20 {
607     using SafeMath for uint256;
608     using Address for address;
609 
610     function safeTransfer(IERC20 token, address to, uint256 value) internal {
611         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
612     }
613 
614     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
615         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
616     }
617 
618     /**
619      * @dev Deprecated. This function has issues similar to the ones found in
620      * {IERC20-approve}, and its usage is discouraged.
621      *
622      * Whenever possible, use {safeIncreaseAllowance} and
623      * {safeDecreaseAllowance} instead.
624      */
625     function safeApprove(IERC20 token, address spender, uint256 value) internal {
626         // safeApprove should only be called when setting an initial allowance,
627         // or when resetting it to zero. To increase and decrease it, use
628         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
629         // solhint-disable-next-line max-line-length
630         require((value == 0) || (token.allowance(address(this), spender) == 0),
631             "SafeERC20: approve from non-zero to non-zero allowance"
632         );
633         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
634     }
635 
636     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
637         uint256 newAllowance = token.allowance(address(this), spender).add(value);
638         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
639     }
640 
641     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
642         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
643         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
644     }
645 
646     /**
647      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
648      * on the return value: the return value is optional (but if data is returned, it must not be false).
649      * @param token The token targeted by the call.
650      * @param data The call data (encoded using abi.encode or one of its variants).
651      */
652     function _callOptionalReturn(IERC20 token, bytes memory data) private {
653         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
654         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
655         // the target address contains contract code and also asserts for success in the low-level call.
656 
657         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
658         if (returndata.length > 0) { // Return data is optional
659             // solhint-disable-next-line max-line-length
660             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
661         }
662     }
663 }
664 
665 // File: @openzeppelin/contracts/access/Ownable.sol
666 
667 // SPDX-License-Identifier: MIT
668 
669 pragma solidity >=0.6.0 <0.8.0;
670 
671 /**
672  * @dev Contract module which provides a basic access control mechanism, where
673  * there is an account (an owner) that can be granted exclusive access to
674  * specific functions.
675  *
676  * By default, the owner account will be the one that deploys the contract. This
677  * can later be changed with {transferOwnership}.
678  *
679  * This module is used through inheritance. It will make available the modifier
680  * `onlyOwner`, which can be applied to your functions to restrict their use to
681  * the owner.
682  */
683 abstract contract Ownable is Context {
684     address private _owner;
685 
686     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
687 
688     /**
689      * @dev Initializes the contract setting the deployer as the initial owner.
690      */
691     constructor () internal {
692         address msgSender = _msgSender();
693         _owner = msgSender;
694         emit OwnershipTransferred(address(0), msgSender);
695     }
696 
697     /**
698      * @dev Returns the address of the current owner.
699      */
700     function owner() public view virtual returns (address) {
701         return _owner;
702     }
703 
704     /**
705      * @dev Throws if called by any account other than the owner.
706      */
707     modifier onlyOwner() {
708         require(owner() == _msgSender(), "Ownable: caller is not the owner");
709         _;
710     }
711 
712     /**
713      * @dev Leaves the contract without owner. It will not be possible to call
714      * `onlyOwner` functions anymore. Can only be called by the current owner.
715      *
716      * NOTE: Renouncing ownership will leave the contract without an owner,
717      * thereby removing any functionality that is only available to the owner.
718      */
719     function renounceOwnership() public virtual onlyOwner {
720         emit OwnershipTransferred(_owner, address(0));
721         _owner = address(0);
722     }
723 
724     /**
725      * @dev Transfers ownership of the contract to a new account (`newOwner`).
726      * Can only be called by the current owner.
727      */
728     function transferOwnership(address newOwner) public virtual onlyOwner {
729         require(newOwner != address(0), "Ownable: new owner is the zero address");
730         emit OwnershipTransferred(_owner, newOwner);
731         _owner = newOwner;
732     }
733 }
734 
735 // File: contracts/ClaimMining2.sol
736 
737 pragma solidity 0.6.6;
738 
739 
740 
741 
742 
743 
744 
745 
746 contract ClaimMining2 is Ownable, ReentrancyGuard {
747     using SafeMath for uint256;
748     using SafeERC20 for IERC20;
749 
750     // Info of each user.
751     struct UserInfo {
752         uint256 amount;     // How many LP tokens the user has provided.
753         uint256 rewardDebt; // Reward debt. See explanation below.
754         uint256 rewardToClaim; // when deposit or withdraw, update pending reward  to rewartToClaim.
755     }
756 
757     struct PoolInfo {
758         IERC20 lpToken;            // Address of   LP token.
759         uint256 allocPoint;         // How many allocation points assigned to this pool. mining token  distribute per block.
760         uint256 lastRewardBlock;    // Last block number that mining token distribution occurs.
761         uint256 accPerShare;        // Accumulated mining token per share, times 1e12. See below.
762     }
763 
764     IERC20 public miningToken; // The mining token TOKEN
765 
766     uint256 public phase1StartBlockNumber;
767     uint256 public phase1EndBlockNumber;
768     uint256 public phase2EndBlockNumber;
769     uint256 public phase1TokenPerBlock;
770     uint256 public phase2TokenPerBlock;
771 
772     PoolInfo[] public poolInfo; // Info of each pool.
773     mapping(uint256 => mapping(address => UserInfo)) private userInfo; // Info of each user that stakes LP tokens.
774     uint256 public totalAllocPoint = 0;  // Total allocation points. Must be the sum of all allocation points in all pools.
775 
776     event Claim(address indexed user, uint256 pid, uint256 amount);
777     event Deposit(address indexed user, uint256 pid, uint256 amount);
778     event Withdraw(address indexed user, uint256 pid, uint256 amount);
779     event EmergencyWithdraw(address indexed user, uint256 pid, uint256 amount);
780 
781 
782     constructor(address _mining_token, uint256 _mining_start_block) public {
783         miningToken = IERC20(_mining_token);
784         uint256 blockCountPerDay = 6600;
785         phase1StartBlockNumber = _mining_start_block;
786         phase1EndBlockNumber = phase1StartBlockNumber.add(blockCountPerDay.mul(28));
787         phase2EndBlockNumber = phase1EndBlockNumber.add(blockCountPerDay.mul(365));
788 
789         phase1TokenPerBlock = 55 * 1e17;
790         phase2TokenPerBlock = 13 * 1e17;
791     }
792 
793 
794     function getUserInfo(uint256 _pid, address _user) public view returns (
795         uint256 _amount, uint256 _rewardDebt, uint256 _rewardToClaim) {
796         require(_pid < poolInfo.length, "invalid _pid");
797         UserInfo memory info = userInfo[_pid][_user];
798         _amount = info.amount;
799         _rewardDebt = info.rewardDebt;
800         _rewardToClaim = info.rewardToClaim;
801     }
802 
803     function poolLength() external view returns (uint256) {
804         return poolInfo.length;
805     }
806 
807     // Add a new lp to the pool. Can only be called by the owner.
808     function add(uint256 _allocPoint, address _lpToken,  bool _withUpdate) public onlyOwner {
809         if (_withUpdate) {
810             massUpdatePools();
811         }
812         uint256 lastRewardBlock = block.number > phase1StartBlockNumber ? block.number : phase1StartBlockNumber;
813         totalAllocPoint = totalAllocPoint.add(_allocPoint);
814         poolInfo.push(
815             PoolInfo(
816             {
817             lpToken : IERC20(_lpToken),
818             allocPoint : _allocPoint,
819             lastRewardBlock : lastRewardBlock,
820             accPerShare : 0
821             })
822         );
823     }
824 
825     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
826         require(_pid < poolInfo.length, "invalid _pid");
827         if (_withUpdate) {
828             massUpdatePools();
829         }
830         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
831         poolInfo[_pid].allocPoint = _allocPoint;
832     }
833 
834     function getCurrentRewardsPerBlock() public view returns (uint256) {
835         return getMultiplier(block.number - 1, block.number);
836     }
837 
838     // Return reward  over the given _from to _to block. Suppose it doesn't span two adjacent mining block number
839     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
840         require(_to > _from, "_to should greater than  _from ");
841         if (_from < phase1StartBlockNumber && phase1StartBlockNumber < _to && _to < phase1EndBlockNumber) {
842             return _to.sub(phase1StartBlockNumber).mul(phase1TokenPerBlock);
843         }
844         if (phase1StartBlockNumber <= _from  && _to <= phase1EndBlockNumber) {
845             return _to.sub(_from).mul(phase1TokenPerBlock);
846         }
847 
848         if (phase1StartBlockNumber < _from  &&  _from < phase1EndBlockNumber && phase1EndBlockNumber <  _to && _to <= phase2EndBlockNumber) {
849             return phase1EndBlockNumber.sub(_from).mul(phase1TokenPerBlock).add(_to.sub(phase1EndBlockNumber).mul(phase2TokenPerBlock));
850         }
851 
852         if (phase1EndBlockNumber < _from  && _to <= phase2EndBlockNumber) {
853             return _to.sub(_from).mul(phase2TokenPerBlock);
854         }
855 
856         if (phase1EndBlockNumber < _from && _from < phase2EndBlockNumber && phase2EndBlockNumber < _to) {
857             return phase2EndBlockNumber.sub(_from).mul(phase2TokenPerBlock);
858         }
859         
860         return 0;
861     }
862 
863     function massUpdatePools() public {
864         uint256 length = poolInfo.length;
865         for (uint256 pid = 0; pid < length; ++pid) {
866             updatePool(pid);
867         }
868     }
869 
870     function updatePool(uint256 _pid) public {
871         require(_pid < poolInfo.length, "invalid _pid");
872         PoolInfo storage pool = poolInfo[_pid];
873         if (block.number <= pool.lastRewardBlock) {
874             return;
875         }
876         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
877         if (lpSupply == 0) {
878             pool.lastRewardBlock = block.number;
879             return;
880         }
881         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
882         uint256 reward = multiplier.mul(pool.allocPoint).div(totalAllocPoint);
883         pool.accPerShare = pool.accPerShare.add(reward.mul(1e12).div(lpSupply));
884         pool.lastRewardBlock = block.number;
885     }
886 
887     function getPendingAmount(uint256 _pid, address _user) public view returns (uint256) {
888         require(_pid < poolInfo.length, "invalid _pid");
889         PoolInfo storage pool = poolInfo[_pid];
890         UserInfo storage user = userInfo[_pid][_user];
891         uint256 accPerShare = pool.accPerShare;
892         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
893         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
894             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
895             uint256 reward = multiplier.mul(pool.allocPoint).div(totalAllocPoint);
896             accPerShare = accPerShare.add(reward.mul(1e12).div(lpSupply));
897         }
898         uint256 pending = user.amount.mul(accPerShare).div(1e12).sub(user.rewardDebt);
899         uint256 totalPendingAmount = user.rewardToClaim.add(pending);
900         return totalPendingAmount;
901     }
902 
903     function getAllPendingAmount(address _user) external view returns (uint256) {
904         uint256 length = poolInfo.length;
905         uint256 allAmount = 0;
906         for (uint256 pid = 0; pid < length; ++pid) {
907             allAmount = allAmount.add(getPendingAmount(pid, _user));
908         }
909         return allAmount;
910     }
911 
912     function claimAll() public {
913         uint256 length = poolInfo.length;
914         for (uint256 pid = 0; pid < length; ++pid) {
915             if (getPendingAmount(pid, msg.sender) > 0) {
916                 claim(pid);
917             }
918         }
919     }
920 
921     function claim(uint256 _pid) public {
922         require(_pid < poolInfo.length, "invalid _pid");
923         PoolInfo storage pool = poolInfo[_pid];
924         UserInfo storage user = userInfo[_pid][msg.sender];
925         updatePool(_pid);
926         if (user.amount > 0) {
927             uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
928             user.rewardToClaim = user.rewardToClaim.add(pending);
929         }
930         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
931         safeMiningTokenTransfer(msg.sender, user.rewardToClaim);
932         emit Claim(msg.sender, _pid, user.rewardToClaim);
933         user.rewardToClaim = 0;
934     }
935 
936     // Deposit LP tokens to Mining for token allocation.
937     function deposit(uint256 _pid, uint256 _amount) public nonReentrant  {
938         require(_pid < poolInfo.length, "invalid _pid");
939         PoolInfo storage pool = poolInfo[_pid];
940         UserInfo storage user = userInfo[_pid][msg.sender];
941 
942         updatePool(_pid);
943         if (user.amount > 0) {
944             uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
945             user.rewardToClaim = user.rewardToClaim.add(pending);
946         }
947         if (_amount > 0) {// for gas saving
948             pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
949             user.amount = user.amount.add(_amount);
950             emit Deposit(msg.sender, _pid, _amount);
951         }
952         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
953     }
954 
955     // Withdraw LP tokens from Mining.
956     function withdraw(uint256 _pid, uint256 _amount) public nonReentrant {
957         require(_pid < poolInfo.length, "invalid _pid");
958         PoolInfo storage pool = poolInfo[_pid];
959         UserInfo storage user = userInfo[_pid][msg.sender];
960         require(user.amount >= _amount, "withdraw: user.amount is not enough");
961         updatePool(_pid);
962         uint256 pending = user.amount.mul(pool.accPerShare).div(1e12).sub(user.rewardDebt);
963         user.rewardToClaim = user.rewardToClaim.add(pending);
964         user.amount = user.amount.sub(_amount);
965         user.rewardDebt = user.amount.mul(pool.accPerShare).div(1e12);
966         pool.lpToken.safeTransfer(address(msg.sender), _amount);
967         emit Withdraw(msg.sender, _pid, _amount);
968     }
969 
970     // Withdraw without caring about rewards. EMERGENCY ONLY.
971     function emergencyWithdraw(uint256 _pid) public nonReentrant {
972         require(_pid < poolInfo.length, "invalid _pid");
973         PoolInfo storage pool = poolInfo[_pid];
974         UserInfo storage user = userInfo[_pid][msg.sender];
975         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
976         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
977         user.amount = 0;
978         user.rewardDebt = 0;
979     }
980 
981     // Safe token transfer function, just in case if rounding error causes pool to not have enough mining token.
982     function safeMiningTokenTransfer(address _to, uint256 _amount) internal {
983         uint256 bal = miningToken.balanceOf(address(this));
984         require(bal >= _amount, "balance is not enough.");
985         miningToken.safeTransfer(_to, _amount);
986     }
987 
988 }