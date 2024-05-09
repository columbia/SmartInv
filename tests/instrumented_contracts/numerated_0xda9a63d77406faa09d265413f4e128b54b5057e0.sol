1 // File: @openzeppelin/contracts/math/Math.sol
2 
3 // SPDX-License-Identifier: MIT
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
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Wrappers over Solidity's arithmetic operations with added overflow
42  * checks.
43  *
44  * Arithmetic operations in Solidity wrap on overflow. This can easily result
45  * in bugs, because programmers usually assume that an overflow raises an
46  * error, which is the standard behavior in high level programming languages.
47  * `SafeMath` restores this intuition by reverting the transaction when an
48  * operation overflows.
49  *
50  * Using this library instead of the unchecked operations eliminates an entire
51  * class of bugs, so it's recommended to use it always.
52  */
53 library SafeMath {
54     /**
55      * @dev Returns the addition of two unsigned integers, with an overflow flag.
56      *
57      * _Available since v3.4._
58      */
59     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
60         uint256 c = a + b;
61         if (c < a) return (false, 0);
62         return (true, c);
63     }
64 
65     /**
66      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
67      *
68      * _Available since v3.4._
69      */
70     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b > a) return (false, 0);
72         return (true, a - b);
73     }
74 
75     /**
76      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) return (true, 0);
85         uint256 c = a * b;
86         if (c / a != b) return (false, 0);
87         return (true, c);
88     }
89 
90     /**
91      * @dev Returns the division of two unsigned integers, with a division by zero flag.
92      *
93      * _Available since v3.4._
94      */
95     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
96         if (b == 0) return (false, 0);
97         return (true, a / b);
98     }
99 
100     /**
101      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
102      *
103      * _Available since v3.4._
104      */
105     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
106         if (b == 0) return (false, 0);
107         return (true, a % b);
108     }
109 
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123         return c;
124     }
125 
126     /**
127      * @dev Returns the subtraction of two unsigned integers, reverting on
128      * overflow (when the result is negative).
129      *
130      * Counterpart to Solidity's `-` operator.
131      *
132      * Requirements:
133      *
134      * - Subtraction cannot overflow.
135      */
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         require(b <= a, "SafeMath: subtraction overflow");
138         return a - b;
139     }
140 
141     /**
142      * @dev Returns the multiplication of two unsigned integers, reverting on
143      * overflow.
144      *
145      * Counterpart to Solidity's `*` operator.
146      *
147      * Requirements:
148      *
149      * - Multiplication cannot overflow.
150      */
151     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
152         if (a == 0) return 0;
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers, reverting on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         require(b > 0, "SafeMath: division by zero");
172         return a / b;
173     }
174 
175     /**
176      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
177      * reverting when dividing by zero.
178      *
179      * Counterpart to Solidity's `%` operator. This function uses a `revert`
180      * opcode (which leaves remaining gas untouched) while Solidity uses an
181      * invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
188         require(b > 0, "SafeMath: modulo by zero");
189         return a % b;
190     }
191 
192     /**
193      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
194      * overflow (when the result is negative).
195      *
196      * CAUTION: This function is deprecated because it requires allocating memory for the error
197      * message unnecessarily. For custom revert reasons use {trySub}.
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b <= a, errorMessage);
207         return a - b;
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * CAUTION: This function is deprecated because it requires allocating memory for the error
215      * message unnecessarily. For custom revert reasons use {tryDiv}.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         return a / b;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * reverting with custom message when dividing by zero.
233      *
234      * CAUTION: This function is deprecated because it requires allocating memory for the error
235      * message unnecessarily. For custom revert reasons use {tryMod}.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
246         require(b > 0, errorMessage);
247         return a % b;
248     }
249 }
250 
251 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
252 
253 
254 pragma solidity >=0.6.0 <0.8.0;
255 
256 /**
257  * @dev Interface of the ERC20 standard as defined in the EIP.
258  */
259 interface IERC20 {
260     /**
261      * @dev Returns the amount of tokens in existence.
262      */
263     function totalSupply() external view returns (uint256);
264 
265     /**
266      * @dev Returns the amount of tokens owned by `account`.
267      */
268     function balanceOf(address account) external view returns (uint256);
269 
270     /**
271      * @dev Moves `amount` tokens from the caller's account to `recipient`.
272      *
273      * Returns a boolean value indicating whether the operation succeeded.
274      *
275      * Emits a {Transfer} event.
276      */
277     function transfer(address recipient, uint256 amount) external returns (bool);
278 
279     /**
280      * @dev Returns the remaining number of tokens that `spender` will be
281      * allowed to spend on behalf of `owner` through {transferFrom}. This is
282      * zero by default.
283      *
284      * This value changes when {approve} or {transferFrom} are called.
285      */
286     function allowance(address owner, address spender) external view returns (uint256);
287 
288     /**
289      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
290      *
291      * Returns a boolean value indicating whether the operation succeeded.
292      *
293      * IMPORTANT: Beware that changing an allowance with this method brings the risk
294      * that someone may use both the old and the new allowance by unfortunate
295      * transaction ordering. One possible solution to mitigate this race
296      * condition is to first reduce the spender's allowance to 0 and set the
297      * desired value afterwards:
298      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
299      *
300      * Emits an {Approval} event.
301      */
302     function approve(address spender, uint256 amount) external returns (bool);
303 
304     /**
305      * @dev Moves `amount` tokens from `sender` to `recipient` using the
306      * allowance mechanism. `amount` is then deducted from the caller's
307      * allowance.
308      *
309      * Returns a boolean value indicating whether the operation succeeded.
310      *
311      * Emits a {Transfer} event.
312      */
313     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Emitted when `value` tokens are moved from one account (`from`) to
317      * another (`to`).
318      *
319      * Note that `value` may be zero.
320      */
321     event Transfer(address indexed from, address indexed to, uint256 value);
322 
323     /**
324      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
325      * a call to {approve}. `value` is the new allowance.
326      */
327     event Approval(address indexed owner, address indexed spender, uint256 value);
328 }
329 
330 // File: @openzeppelin/contracts/utils/Address.sol
331 
332 
333 pragma solidity >=0.6.2 <0.8.0;
334 
335 /**
336  * @dev Collection of functions related to the address type
337  */
338 library Address {
339     /**
340      * @dev Returns true if `account` is a contract.
341      *
342      * [IMPORTANT]
343      * ====
344      * It is unsafe to assume that an address for which this function returns
345      * false is an externally-owned account (EOA) and not a contract.
346      *
347      * Among others, `isContract` will return false for the following
348      * types of addresses:
349      *
350      *  - an externally-owned account
351      *  - a contract in construction
352      *  - an address where a contract will be created
353      *  - an address where a contract lived, but was destroyed
354      * ====
355      */
356     function isContract(address account) internal view returns (bool) {
357         // This method relies on extcodesize, which returns 0 for contracts in
358         // construction, since the code is only stored at the end of the
359         // constructor execution.
360 
361         uint256 size;
362         // solhint-disable-next-line no-inline-assembly
363         assembly { size := extcodesize(account) }
364         return size > 0;
365     }
366 
367     /**
368      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
369      * `recipient`, forwarding all available gas and reverting on errors.
370      *
371      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
372      * of certain opcodes, possibly making contracts go over the 2300 gas limit
373      * imposed by `transfer`, making them unable to receive funds via
374      * `transfer`. {sendValue} removes this limitation.
375      *
376      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
377      *
378      * IMPORTANT: because control is transferred to `recipient`, care must be
379      * taken to not create reentrancy vulnerabilities. Consider using
380      * {ReentrancyGuard} or the
381      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
382      */
383     function sendValue(address payable recipient, uint256 amount) internal {
384         require(address(this).balance >= amount, "Address: insufficient balance");
385 
386         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
387         (bool success, ) = recipient.call{ value: amount }("");
388         require(success, "Address: unable to send value, recipient may have reverted");
389     }
390 
391     /**
392      * @dev Performs a Solidity function call using a low level `call`. A
393      * plain`call` is an unsafe replacement for a function call: use this
394      * function instead.
395      *
396      * If `target` reverts with a revert reason, it is bubbled up by this
397      * function (like regular Solidity function calls).
398      *
399      * Returns the raw returned data. To convert to the expected return value,
400      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
401      *
402      * Requirements:
403      *
404      * - `target` must be a contract.
405      * - calling `target` with `data` must not revert.
406      *
407      * _Available since v3.1._
408      */
409     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
410       return functionCall(target, data, "Address: low-level call failed");
411     }
412 
413     /**
414      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
415      * `errorMessage` as a fallback revert reason when `target` reverts.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
420         return functionCallWithValue(target, data, 0, errorMessage);
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
425      * but also transferring `value` wei to `target`.
426      *
427      * Requirements:
428      *
429      * - the calling contract must have an ETH balance of at least `value`.
430      * - the called Solidity function must be `payable`.
431      *
432      * _Available since v3.1._
433      */
434     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
435         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
436     }
437 
438     /**
439      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
440      * with `errorMessage` as a fallback revert reason when `target` reverts.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
445         require(address(this).balance >= value, "Address: insufficient balance for call");
446         require(isContract(target), "Address: call to non-contract");
447 
448         // solhint-disable-next-line avoid-low-level-calls
449         (bool success, bytes memory returndata) = target.call{ value: value }(data);
450         return _verifyCallResult(success, returndata, errorMessage);
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
455      * but performing a static call.
456      *
457      * _Available since v3.3._
458      */
459     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
460         return functionStaticCall(target, data, "Address: low-level static call failed");
461     }
462 
463     /**
464      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
465      * but performing a static call.
466      *
467      * _Available since v3.3._
468      */
469     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
470         require(isContract(target), "Address: static call to non-contract");
471 
472         // solhint-disable-next-line avoid-low-level-calls
473         (bool success, bytes memory returndata) = target.staticcall(data);
474         return _verifyCallResult(success, returndata, errorMessage);
475     }
476 
477     /**
478      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
479      * but performing a delegate call.
480      *
481      * _Available since v3.4._
482      */
483     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
484         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
489      * but performing a delegate call.
490      *
491      * _Available since v3.4._
492      */
493     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
494         require(isContract(target), "Address: delegate call to non-contract");
495 
496         // solhint-disable-next-line avoid-low-level-calls
497         (bool success, bytes memory returndata) = target.delegatecall(data);
498         return _verifyCallResult(success, returndata, errorMessage);
499     }
500 
501     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
502         if (success) {
503             return returndata;
504         } else {
505             // Look for revert reason and bubble it up if present
506             if (returndata.length > 0) {
507                 // The easiest way to bubble the revert reason is using memory via assembly
508 
509                 // solhint-disable-next-line no-inline-assembly
510                 assembly {
511                     let returndata_size := mload(returndata)
512                     revert(add(32, returndata), returndata_size)
513                 }
514             } else {
515                 revert(errorMessage);
516             }
517         }
518     }
519 }
520 
521 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
522 
523 
524 pragma solidity >=0.6.0 <0.8.0;
525 
526 
527 
528 
529 /**
530  * @title SafeERC20
531  * @dev Wrappers around ERC20 operations that throw on failure (when the token
532  * contract returns false). Tokens that return no value (and instead revert or
533  * throw on failure) are also supported, non-reverting calls are assumed to be
534  * successful.
535  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
536  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
537  */
538 library SafeERC20 {
539     using SafeMath for uint256;
540     using Address for address;
541 
542     function safeTransfer(IERC20 token, address to, uint256 value) internal {
543         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
544     }
545 
546     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
547         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
548     }
549 
550     /**
551      * @dev Deprecated. This function has issues similar to the ones found in
552      * {IERC20-approve}, and its usage is discouraged.
553      *
554      * Whenever possible, use {safeIncreaseAllowance} and
555      * {safeDecreaseAllowance} instead.
556      */
557     function safeApprove(IERC20 token, address spender, uint256 value) internal {
558         // safeApprove should only be called when setting an initial allowance,
559         // or when resetting it to zero. To increase and decrease it, use
560         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
561         // solhint-disable-next-line max-line-length
562         require((value == 0) || (token.allowance(address(this), spender) == 0),
563             "SafeERC20: approve from non-zero to non-zero allowance"
564         );
565         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
566     }
567 
568     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
569         uint256 newAllowance = token.allowance(address(this), spender).add(value);
570         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
571     }
572 
573     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
574         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
575         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
576     }
577 
578     /**
579      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
580      * on the return value: the return value is optional (but if data is returned, it must not be false).
581      * @param token The token targeted by the call.
582      * @param data The call data (encoded using abi.encode or one of its variants).
583      */
584     function _callOptionalReturn(IERC20 token, bytes memory data) private {
585         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
586         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
587         // the target address contains contract code and also asserts for success in the low-level call.
588 
589         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
590         if (returndata.length > 0) { // Return data is optional
591             // solhint-disable-next-line max-line-length
592             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
593         }
594     }
595 }
596 
597 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
598 
599 
600 pragma solidity >=0.6.0 <0.8.0;
601 
602 /**
603  * @dev Contract module that helps prevent reentrant calls to a function.
604  *
605  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
606  * available, which can be applied to functions to make sure there are no nested
607  * (reentrant) calls to them.
608  *
609  * Note that because there is a single `nonReentrant` guard, functions marked as
610  * `nonReentrant` may not call one another. This can be worked around by making
611  * those functions `private`, and then adding `external` `nonReentrant` entry
612  * points to them.
613  *
614  * TIP: If you would like to learn more about reentrancy and alternative ways
615  * to protect against it, check out our blog post
616  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
617  */
618 abstract contract ReentrancyGuard {
619     // Booleans are more expensive than uint256 or any type that takes up a full
620     // word because each write operation emits an extra SLOAD to first read the
621     // slot's contents, replace the bits taken up by the boolean, and then write
622     // back. This is the compiler's defense against contract upgrades and
623     // pointer aliasing, and it cannot be disabled.
624 
625     // The values being non-zero value makes deployment a bit more expensive,
626     // but in exchange the refund on every call to nonReentrant will be lower in
627     // amount. Since refunds are capped to a percentage of the total
628     // transaction's gas, it is best to keep them low in cases like this one, to
629     // increase the likelihood of the full refund coming into effect.
630     uint256 private constant _NOT_ENTERED = 1;
631     uint256 private constant _ENTERED = 2;
632 
633     uint256 private _status;
634 
635     constructor () internal {
636         _status = _NOT_ENTERED;
637     }
638 
639     /**
640      * @dev Prevents a contract from calling itself, directly or indirectly.
641      * Calling a `nonReentrant` function from another `nonReentrant`
642      * function is not supported. It is possible to prevent this from happening
643      * by making the `nonReentrant` function external, and make it call a
644      * `private` function that does the actual work.
645      */
646     modifier nonReentrant() {
647         // On the first call to nonReentrant, _notEntered will be true
648         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
649 
650         // Any calls to nonReentrant after this point will fail
651         _status = _ENTERED;
652 
653         _;
654 
655         // By storing the original value once again, a refund is triggered (see
656         // https://eips.ethereum.org/EIPS/eip-2200)
657         _status = _NOT_ENTERED;
658     }
659 }
660 
661 // File: contracts/interfaces/IStakingRewards.sol
662 
663 pragma solidity 0.7.5;
664 
665 
666 interface IStakingRewards {
667     // Mutative
668     function stake(uint256 amount) external;
669 
670     function withdraw(uint256 amount) external;
671 
672     function getReward() external;
673 
674     function exit() external;
675     // Views
676     function lastTimeRewardApplicable() external view returns (uint256);
677 
678     function rewardPerToken() external view returns (uint256);
679 
680     function earned(address account) external view returns (uint256);
681 
682     function getRewardForDuration() external view returns (uint256);
683 
684     function totalSupply() external view returns (uint256);
685 
686     function balanceOf(address account) external view returns (uint256);
687 
688 }
689 
690 // File: @openzeppelin/contracts/utils/Context.sol
691 
692 
693 pragma solidity >=0.6.0 <0.8.0;
694 
695 /*
696  * @dev Provides information about the current execution context, including the
697  * sender of the transaction and its data. While these are generally available
698  * via msg.sender and msg.data, they should not be accessed in such a direct
699  * manner, since when dealing with GSN meta-transactions the account sending and
700  * paying for execution may not be the actual sender (as far as an application
701  * is concerned).
702  *
703  * This contract is only required for intermediate, library-like contracts.
704  */
705 abstract contract Context {
706     function _msgSender() internal view virtual returns (address payable) {
707         return msg.sender;
708     }
709 
710     function _msgData() internal view virtual returns (bytes memory) {
711         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
712         return msg.data;
713     }
714 }
715 
716 // File: @openzeppelin/contracts/access/Ownable.sol
717 
718 
719 pragma solidity >=0.6.0 <0.8.0;
720 
721 /**
722  * @dev Contract module which provides a basic access control mechanism, where
723  * there is an account (an owner) that can be granted exclusive access to
724  * specific functions.
725  *
726  * By default, the owner account will be the one that deploys the contract. This
727  * can later be changed with {transferOwnership}.
728  *
729  * This module is used through inheritance. It will make available the modifier
730  * `onlyOwner`, which can be applied to your functions to restrict their use to
731  * the owner.
732  */
733 abstract contract Ownable is Context {
734     address private _owner;
735 
736     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
737 
738     /**
739      * @dev Initializes the contract setting the deployer as the initial owner.
740      */
741     constructor () internal {
742         address msgSender = _msgSender();
743         _owner = msgSender;
744         emit OwnershipTransferred(address(0), msgSender);
745     }
746 
747     /**
748      * @dev Returns the address of the current owner.
749      */
750     function owner() public view virtual returns (address) {
751         return _owner;
752     }
753 
754     /**
755      * @dev Throws if called by any account other than the owner.
756      */
757     modifier onlyOwner() {
758         require(owner() == _msgSender(), "Ownable: caller is not the owner");
759         _;
760     }
761 
762     /**
763      * @dev Leaves the contract without owner. It will not be possible to call
764      * `onlyOwner` functions anymore. Can only be called by the current owner.
765      *
766      * NOTE: Renouncing ownership will leave the contract without an owner,
767      * thereby removing any functionality that is only available to the owner.
768      */
769     function renounceOwnership() public virtual onlyOwner {
770         emit OwnershipTransferred(_owner, address(0));
771         _owner = address(0);
772     }
773 
774     /**
775      * @dev Transfers ownership of the contract to a new account (`newOwner`).
776      * Can only be called by the current owner.
777      */
778     function transferOwnership(address newOwner) public virtual onlyOwner {
779         require(newOwner != address(0), "Ownable: new owner is the zero address");
780         emit OwnershipTransferred(_owner, newOwner);
781         _owner = newOwner;
782     }
783 }
784 
785 // File: contracts/interfaces/Owned.sol
786 
787 pragma solidity 0.7.5;
788 
789 
790 abstract contract Owned is Ownable {
791     constructor(address _owner) {
792         transferOwnership(_owner);
793     }
794 }
795 
796 // File: contracts/interfaces/Pausable.sol
797 
798 pragma solidity 0.7.5;
799 
800 // Inheritance
801 
802 
803 
804 abstract contract Pausable is Owned {
805     bool public paused;
806 
807     constructor() {
808         // This contract is abstract, and thus cannot be instantiated directly
809         require(owner() != address(0), "Owner must be set");
810         // Paused will be false
811     }
812 
813     /**
814      * @notice Change the paused state of the contract
815      * @dev Only the contract owner may call this.
816      */
817     function setPaused(bool _paused) external onlyOwner {
818         // Ensure we're actually changing the state before we do anything
819         if (_paused == paused) {
820             return;
821         }
822 
823         // Set our paused state.
824         paused = _paused;
825 
826         // Let everyone know that our pause state has changed.
827         emit PauseChanged(paused);
828     }
829 
830     event PauseChanged(bool isPaused);
831 
832     modifier notPaused {
833         require(!paused, "This action cannot be performed while the contract is paused");
834         _;
835     }
836 }
837 
838 // File: contracts/interfaces/IBurnableToken.sol
839 
840 pragma solidity 0.7.5;
841 
842 interface IBurnableToken {
843     function burn(uint256 _amount) external;
844 }
845 
846 // File: contracts/interfaces/RewardsDistributionRecipient.sol
847 
848 pragma solidity 0.7.5;
849 
850 // Inheritance
851 
852 
853 
854 // https://docs.synthetix.io/contracts/RewardsDistributionRecipient
855 abstract contract RewardsDistributionRecipient is Owned {
856     address public rewardsDistribution;
857 
858     function notifyRewardAmount(uint256 reward) virtual external;
859 
860     modifier onlyRewardsDistribution() {
861         require(msg.sender == rewardsDistribution, "Caller is not RewardsDistribution contract");
862         _;
863     }
864 
865     function setRewardsDistribution(address _rewardsDistribution) external onlyOwner {
866         rewardsDistribution = _rewardsDistribution;
867     }
868 }
869 
870 // File: contracts/StakingRewards.sol
871 
872 pragma solidity 0.7.5;
873 
874 
875 
876 
877 
878 // Inheritance
879 
880 
881 
882 
883 
884 // based on synthetix
885 contract StakingRewards is IStakingRewards, RewardsDistributionRecipient, ReentrancyGuard, Pausable {
886     using SafeMath for uint256;
887     using SafeERC20 for IERC20;
888 
889     // ========== STATE VARIABLES ========== //
890 
891     IERC20 public rewardsToken;
892     IERC20 public stakingToken;
893     uint256 public periodFinish = 0;
894     uint256 public rewardRate = 0;
895     uint256 public rewardsDuration = 365 days;
896     uint256 public lastUpdateTime;
897     uint256 public rewardPerTokenStored;
898 
899     mapping(address => uint256) public userRewardPerTokenPaid;
900     mapping(address => uint256) public rewards;
901 
902     bool public stopped;
903 
904     uint256 private _totalSupply;
905     mapping(address => uint256) private _balances;
906 
907     // ========== CONSTRUCTOR ========== //
908 
909     constructor(
910         address _owner,
911         address _rewardsDistribution,
912         address _stakingToken,
913         address _rewardsToken
914     ) Owned(_owner) {
915         stakingToken = IERC20(_stakingToken);
916         rewardsToken = IERC20(_rewardsToken);
917         rewardsDistribution = _rewardsDistribution;
918     }
919 
920     // ========== VIEWS ========== //
921 
922     function totalSupply() override public view returns (uint256) {
923         return _totalSupply;
924     }
925 
926     function balanceOf(address account) override external view returns (uint256) {
927         return _balances[account];
928     }
929 
930     function lastTimeRewardApplicable() override public view returns (uint256) {
931         return Math.min(block.timestamp, periodFinish);
932     }
933 
934     function rewardPerToken() override public view returns (uint256) {
935         if (_totalSupply == 0) {
936             return rewardPerTokenStored;
937         }
938 
939         return rewardPerTokenStored.add(
940             lastTimeRewardApplicable().sub(lastUpdateTime).mul(rewardRate).mul(1e18).div(_totalSupply)
941         );
942     }
943 
944     function earned(address account) override virtual public view returns (uint256) {
945         return _balances[account]
946         .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
947         .div(1e18)
948         .add(rewards[account]);
949     }
950 
951     function getRewardForDuration() override external view returns (uint256) {
952         return rewardRate.mul(rewardsDuration);
953     }
954 
955     // ========== MUTATIVE FUNCTIONS ========== //
956 
957     function stake(uint256 amount) override external nonReentrant notPaused updateReward(msg.sender) {
958         require(periodFinish > 0, "Stake period not started yet");
959         require(amount > 0, "Cannot stake 0");
960 
961         _totalSupply = _totalSupply.add(amount);
962         _balances[msg.sender] = _balances[msg.sender].add(amount);
963 
964         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
965 
966         emit Staked(msg.sender, amount);
967     }
968 
969     function withdraw(uint256 amount) override public nonReentrant updateReward(msg.sender) {
970         require(amount > 0, "Cannot withdraw 0");
971         _totalSupply = _totalSupply.sub(amount);
972         _balances[msg.sender] = _balances[msg.sender].sub(amount);
973         stakingToken.safeTransfer(msg.sender, amount);
974 
975         emit Withdrawn(msg.sender, amount);
976     }
977 
978     function getReward() override public nonReentrant updateReward(msg.sender) {
979         uint256 reward = rewards[msg.sender];
980 
981         if (reward > 0) {
982             rewards[msg.sender] = 0;
983             rewardsToken.safeTransfer(msg.sender, reward);
984             emit RewardPaid(msg.sender, reward);
985         }
986     }
987 
988     function exit() override external {
989         withdraw(_balances[msg.sender]);
990         getReward();
991     }
992 
993     // ========== RESTRICTED FUNCTIONS ========== //
994 
995     function notifyRewardAmount(
996         uint256 _reward
997     ) override virtual external whenActive onlyRewardsDistribution updateReward(address(0)) {
998         if (block.timestamp >= periodFinish) {
999             rewardRate = _reward.div(rewardsDuration);
1000         } else {
1001             uint256 remaining = periodFinish.sub(block.timestamp);
1002             uint256 leftover = remaining.mul(rewardRate);
1003             rewardRate = _reward.add(leftover).div(rewardsDuration);
1004         }
1005 
1006         // Ensure the provided reward amount is not more than the balance in the contract.
1007         // This keeps the reward rate in the right range, preventing overflows due to
1008         // very high values of rewardRate in the earned and rewardsPerToken functions;
1009         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1010         uint256 balance = rewardsToken.balanceOf(address(this));
1011 
1012         require(rewardRate <= balance.div(rewardsDuration), "Provided reward too high");
1013 
1014         lastUpdateTime = block.timestamp;
1015         periodFinish = block.timestamp.add(rewardsDuration);
1016         emit RewardAdded(_reward);
1017     }
1018 
1019     function setRewardsDuration(uint256 _rewardsDuration) virtual external whenActive onlyOwner {
1020         require(_rewardsDuration > 0, "empty _rewardsDuration");
1021 
1022         require(
1023             block.timestamp > periodFinish,
1024             "Previous rewards period must be complete before changing the duration for the new period"
1025         );
1026 
1027         rewardsDuration = _rewardsDuration;
1028         emit RewardsDurationUpdated(rewardsDuration);
1029     }
1030 
1031     // when farming was started with 1y and 12tokens
1032     // and we want to finish after 4 months, we need to end up with situation
1033     // like we were starting with 4mo and 4 tokens.
1034     function finishFarming() external whenActive onlyOwner {
1035         require(block.timestamp < periodFinish, "can't stop if not started or already finished");
1036 
1037         stopped = true;
1038         uint256 tokensToBurn;
1039 
1040         if (_totalSupply == 0) {
1041             tokensToBurn = rewardsToken.balanceOf(address(this));
1042         } else {
1043             uint256 remaining = periodFinish.sub(block.timestamp);
1044             tokensToBurn = rewardRate.mul(remaining);
1045             rewardsDuration = rewardsDuration - remaining;
1046         }
1047 
1048         periodFinish = block.timestamp;
1049         IBurnableToken(address(rewardsToken)).burn(tokensToBurn);
1050 
1051         emit FarmingFinished(tokensToBurn);
1052     }
1053 
1054     // ========== MODIFIERS ========== //
1055 
1056     modifier whenActive() {
1057         require(!stopped, "farming is stopped");
1058         _;
1059     }
1060 
1061     modifier updateReward(address account) virtual {
1062         rewardPerTokenStored = rewardPerToken();
1063         lastUpdateTime = lastTimeRewardApplicable();
1064         if (account != address(0)) {
1065             rewards[account] = earned(account);
1066             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1067         }
1068         _;
1069     }
1070 
1071     // ========== EVENTS ========== //
1072 
1073     event RewardAdded(uint256 reward);
1074     event Staked(address indexed user, uint256 amount);
1075     event Withdrawn(address indexed user, uint256 amount);
1076     event RewardPaid(address indexed user, uint256 reward);
1077     event RewardsDurationUpdated(uint256 newDuration);
1078     event FarmingFinished(uint256 burnedTokens);
1079 }