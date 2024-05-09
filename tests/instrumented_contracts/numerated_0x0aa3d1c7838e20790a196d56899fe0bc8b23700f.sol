1 // Sources flattened with hardhat v2.1.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.1
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
220 
221 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.1
222 
223 
224 
225 pragma solidity >=0.6.0 <0.8.0;
226 
227 /**
228  * @dev Interface of the ERC20 standard as defined in the EIP.
229  */
230 interface IERC20 {
231     /**
232      * @dev Returns the amount of tokens in existence.
233      */
234     function totalSupply() external view returns (uint256);
235 
236     /**
237      * @dev Returns the amount of tokens owned by `account`.
238      */
239     function balanceOf(address account) external view returns (uint256);
240 
241     /**
242      * @dev Moves `amount` tokens from the caller's account to `recipient`.
243      *
244      * Returns a boolean value indicating whether the operation succeeded.
245      *
246      * Emits a {Transfer} event.
247      */
248     function transfer(address recipient, uint256 amount) external returns (bool);
249 
250     /**
251      * @dev Returns the remaining number of tokens that `spender` will be
252      * allowed to spend on behalf of `owner` through {transferFrom}. This is
253      * zero by default.
254      *
255      * This value changes when {approve} or {transferFrom} are called.
256      */
257     function allowance(address owner, address spender) external view returns (uint256);
258 
259     /**
260      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
261      *
262      * Returns a boolean value indicating whether the operation succeeded.
263      *
264      * IMPORTANT: Beware that changing an allowance with this method brings the risk
265      * that someone may use both the old and the new allowance by unfortunate
266      * transaction ordering. One possible solution to mitigate this race
267      * condition is to first reduce the spender's allowance to 0 and set the
268      * desired value afterwards:
269      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
270      *
271      * Emits an {Approval} event.
272      */
273     function approve(address spender, uint256 amount) external returns (bool);
274 
275     /**
276      * @dev Moves `amount` tokens from `sender` to `recipient` using the
277      * allowance mechanism. `amount` is then deducted from the caller's
278      * allowance.
279      *
280      * Returns a boolean value indicating whether the operation succeeded.
281      *
282      * Emits a {Transfer} event.
283      */
284     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
285 
286     /**
287      * @dev Emitted when `value` tokens are moved from one account (`from`) to
288      * another (`to`).
289      *
290      * Note that `value` may be zero.
291      */
292     event Transfer(address indexed from, address indexed to, uint256 value);
293 
294     /**
295      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
296      * a call to {approve}. `value` is the new allowance.
297      */
298     event Approval(address indexed owner, address indexed spender, uint256 value);
299 }
300 
301 
302 // File @openzeppelin/contracts/utils/Address.sol@v3.4.1
303 
304 
305 
306 pragma solidity >=0.6.2 <0.8.0;
307 
308 /**
309  * @dev Collection of functions related to the address type
310  */
311 library Address {
312     /**
313      * @dev Returns true if `account` is a contract.
314      *
315      * [IMPORTANT]
316      * ====
317      * It is unsafe to assume that an address for which this function returns
318      * false is an externally-owned account (EOA) and not a contract.
319      *
320      * Among others, `isContract` will return false for the following
321      * types of addresses:
322      *
323      *  - an externally-owned account
324      *  - a contract in construction
325      *  - an address where a contract will be created
326      *  - an address where a contract lived, but was destroyed
327      * ====
328      */
329     function isContract(address account) internal view returns (bool) {
330         // This method relies on extcodesize, which returns 0 for contracts in
331         // construction, since the code is only stored at the end of the
332         // constructor execution.
333 
334         uint256 size;
335         // solhint-disable-next-line no-inline-assembly
336         assembly { size := extcodesize(account) }
337         return size > 0;
338     }
339 
340     /**
341      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
342      * `recipient`, forwarding all available gas and reverting on errors.
343      *
344      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
345      * of certain opcodes, possibly making contracts go over the 2300 gas limit
346      * imposed by `transfer`, making them unable to receive funds via
347      * `transfer`. {sendValue} removes this limitation.
348      *
349      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
350      *
351      * IMPORTANT: because control is transferred to `recipient`, care must be
352      * taken to not create reentrancy vulnerabilities. Consider using
353      * {ReentrancyGuard} or the
354      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
355      */
356     function sendValue(address payable recipient, uint256 amount) internal {
357         require(address(this).balance >= amount, "Address: insufficient balance");
358 
359         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
360         (bool success, ) = recipient.call{ value: amount }("");
361         require(success, "Address: unable to send value, recipient may have reverted");
362     }
363 
364     /**
365      * @dev Performs a Solidity function call using a low level `call`. A
366      * plain`call` is an unsafe replacement for a function call: use this
367      * function instead.
368      *
369      * If `target` reverts with a revert reason, it is bubbled up by this
370      * function (like regular Solidity function calls).
371      *
372      * Returns the raw returned data. To convert to the expected return value,
373      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
374      *
375      * Requirements:
376      *
377      * - `target` must be a contract.
378      * - calling `target` with `data` must not revert.
379      *
380      * _Available since v3.1._
381      */
382     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
383       return functionCall(target, data, "Address: low-level call failed");
384     }
385 
386     /**
387      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
388      * `errorMessage` as a fallback revert reason when `target` reverts.
389      *
390      * _Available since v3.1._
391      */
392     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, 0, errorMessage);
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
398      * but also transferring `value` wei to `target`.
399      *
400      * Requirements:
401      *
402      * - the calling contract must have an ETH balance of at least `value`.
403      * - the called Solidity function must be `payable`.
404      *
405      * _Available since v3.1._
406      */
407     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
408         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
413      * with `errorMessage` as a fallback revert reason when `target` reverts.
414      *
415      * _Available since v3.1._
416      */
417     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
418         require(address(this).balance >= value, "Address: insufficient balance for call");
419         require(isContract(target), "Address: call to non-contract");
420 
421         // solhint-disable-next-line avoid-low-level-calls
422         (bool success, bytes memory returndata) = target.call{ value: value }(data);
423         return _verifyCallResult(success, returndata, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but performing a static call.
429      *
430      * _Available since v3.3._
431      */
432     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
433         return functionStaticCall(target, data, "Address: low-level static call failed");
434     }
435 
436     /**
437      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
438      * but performing a static call.
439      *
440      * _Available since v3.3._
441      */
442     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
443         require(isContract(target), "Address: static call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.staticcall(data);
447         return _verifyCallResult(success, returndata, errorMessage);
448     }
449 
450     /**
451      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
452      * but performing a delegate call.
453      *
454      * _Available since v3.4._
455      */
456     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
457         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
458     }
459 
460     /**
461      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
462      * but performing a delegate call.
463      *
464      * _Available since v3.4._
465      */
466     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
467         require(isContract(target), "Address: delegate call to non-contract");
468 
469         // solhint-disable-next-line avoid-low-level-calls
470         (bool success, bytes memory returndata) = target.delegatecall(data);
471         return _verifyCallResult(success, returndata, errorMessage);
472     }
473 
474     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
475         if (success) {
476             return returndata;
477         } else {
478             // Look for revert reason and bubble it up if present
479             if (returndata.length > 0) {
480                 // The easiest way to bubble the revert reason is using memory via assembly
481 
482                 // solhint-disable-next-line no-inline-assembly
483                 assembly {
484                     let returndata_size := mload(returndata)
485                     revert(add(32, returndata), returndata_size)
486                 }
487             } else {
488                 revert(errorMessage);
489             }
490         }
491     }
492 }
493 
494 
495 // File @openzeppelin/contracts/token/ERC20/SafeERC20.sol@v3.4.1
496 
497 
498 
499 pragma solidity >=0.6.0 <0.8.0;
500 
501 
502 
503 /**
504  * @title SafeERC20
505  * @dev Wrappers around ERC20 operations that throw on failure (when the token
506  * contract returns false). Tokens that return no value (and instead revert or
507  * throw on failure) are also supported, non-reverting calls are assumed to be
508  * successful.
509  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
510  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
511  */
512 library SafeERC20 {
513     using SafeMath for uint256;
514     using Address for address;
515 
516     function safeTransfer(IERC20 token, address to, uint256 value) internal {
517         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
518     }
519 
520     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
521         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
522     }
523 
524     /**
525      * @dev Deprecated. This function has issues similar to the ones found in
526      * {IERC20-approve}, and its usage is discouraged.
527      *
528      * Whenever possible, use {safeIncreaseAllowance} and
529      * {safeDecreaseAllowance} instead.
530      */
531     function safeApprove(IERC20 token, address spender, uint256 value) internal {
532         // safeApprove should only be called when setting an initial allowance,
533         // or when resetting it to zero. To increase and decrease it, use
534         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
535         // solhint-disable-next-line max-line-length
536         require((value == 0) || (token.allowance(address(this), spender) == 0),
537             "SafeERC20: approve from non-zero to non-zero allowance"
538         );
539         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
540     }
541 
542     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
543         uint256 newAllowance = token.allowance(address(this), spender).add(value);
544         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
545     }
546 
547     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
548         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
549         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
550     }
551 
552     /**
553      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
554      * on the return value: the return value is optional (but if data is returned, it must not be false).
555      * @param token The token targeted by the call.
556      * @param data The call data (encoded using abi.encode or one of its variants).
557      */
558     function _callOptionalReturn(IERC20 token, bytes memory data) private {
559         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
560         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
561         // the target address contains contract code and also asserts for success in the low-level call.
562 
563         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
564         if (returndata.length > 0) { // Return data is optional
565             // solhint-disable-next-line max-line-length
566             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
567         }
568     }
569 }
570 
571 
572 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.1
573 
574 
575 
576 pragma solidity >=0.6.0 <0.8.0;
577 
578 /**
579  * @dev Contract module that helps prevent reentrant calls to a function.
580  *
581  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
582  * available, which can be applied to functions to make sure there are no nested
583  * (reentrant) calls to them.
584  *
585  * Note that because there is a single `nonReentrant` guard, functions marked as
586  * `nonReentrant` may not call one another. This can be worked around by making
587  * those functions `private`, and then adding `external` `nonReentrant` entry
588  * points to them.
589  *
590  * TIP: If you would like to learn more about reentrancy and alternative ways
591  * to protect against it, check out our blog post
592  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
593  */
594 abstract contract ReentrancyGuard {
595     // Booleans are more expensive than uint256 or any type that takes up a full
596     // word because each write operation emits an extra SLOAD to first read the
597     // slot's contents, replace the bits taken up by the boolean, and then write
598     // back. This is the compiler's defense against contract upgrades and
599     // pointer aliasing, and it cannot be disabled.
600 
601     // The values being non-zero value makes deployment a bit more expensive,
602     // but in exchange the refund on every call to nonReentrant will be lower in
603     // amount. Since refunds are capped to a percentage of the total
604     // transaction's gas, it is best to keep them low in cases like this one, to
605     // increase the likelihood of the full refund coming into effect.
606     uint256 private constant _NOT_ENTERED = 1;
607     uint256 private constant _ENTERED = 2;
608 
609     uint256 private _status;
610 
611     constructor () internal {
612         _status = _NOT_ENTERED;
613     }
614 
615     /**
616      * @dev Prevents a contract from calling itself, directly or indirectly.
617      * Calling a `nonReentrant` function from another `nonReentrant`
618      * function is not supported. It is possible to prevent this from happening
619      * by making the `nonReentrant` function external, and make it call a
620      * `private` function that does the actual work.
621      */
622     modifier nonReentrant() {
623         // On the first call to nonReentrant, _notEntered will be true
624         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
625 
626         // Any calls to nonReentrant after this point will fail
627         _status = _ENTERED;
628 
629         _;
630 
631         // By storing the original value once again, a refund is triggered (see
632         // https://eips.ethereum.org/EIPS/eip-2200)
633         _status = _NOT_ENTERED;
634     }
635 }
636 
637 
638 // File @openzeppelin/contracts/utils/Context.sol@v3.4.1
639 
640 
641 
642 pragma solidity >=0.6.0 <0.8.0;
643 
644 /*
645  * @dev Provides information about the current execution context, including the
646  * sender of the transaction and its data. While these are generally available
647  * via msg.sender and msg.data, they should not be accessed in such a direct
648  * manner, since when dealing with GSN meta-transactions the account sending and
649  * paying for execution may not be the actual sender (as far as an application
650  * is concerned).
651  *
652  * This contract is only required for intermediate, library-like contracts.
653  */
654 abstract contract Context {
655     function _msgSender() internal view virtual returns (address payable) {
656         return msg.sender;
657     }
658 
659     function _msgData() internal view virtual returns (bytes memory) {
660         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
661         return msg.data;
662     }
663 }
664 
665 
666 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.1
667 
668 
669 
670 pragma solidity >=0.6.0 <0.8.0;
671 
672 /**
673  * @dev Contract module which provides a basic access control mechanism, where
674  * there is an account (an owner) that can be granted exclusive access to
675  * specific functions.
676  *
677  * By default, the owner account will be the one that deploys the contract. This
678  * can later be changed with {transferOwnership}.
679  *
680  * This module is used through inheritance. It will make available the modifier
681  * `onlyOwner`, which can be applied to your functions to restrict their use to
682  * the owner.
683  */
684 abstract contract Ownable is Context {
685     address private _owner;
686 
687     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
688 
689     /**
690      * @dev Initializes the contract setting the deployer as the initial owner.
691      */
692     constructor () internal {
693         address msgSender = _msgSender();
694         _owner = msgSender;
695         emit OwnershipTransferred(address(0), msgSender);
696     }
697 
698     /**
699      * @dev Returns the address of the current owner.
700      */
701     function owner() public view virtual returns (address) {
702         return _owner;
703     }
704 
705     /**
706      * @dev Throws if called by any account other than the owner.
707      */
708     modifier onlyOwner() {
709         require(owner() == _msgSender(), "Ownable: caller is not the owner");
710         _;
711     }
712 
713     /**
714      * @dev Leaves the contract without owner. It will not be possible to call
715      * `onlyOwner` functions anymore. Can only be called by the current owner.
716      *
717      * NOTE: Renouncing ownership will leave the contract without an owner,
718      * thereby removing any functionality that is only available to the owner.
719      */
720     function renounceOwnership() public virtual onlyOwner {
721         emit OwnershipTransferred(_owner, address(0));
722         _owner = address(0);
723     }
724 
725     /**
726      * @dev Transfers ownership of the contract to a new account (`newOwner`).
727      * Can only be called by the current owner.
728      */
729     function transferOwnership(address newOwner) public virtual onlyOwner {
730         require(newOwner != address(0), "Ownable: new owner is the zero address");
731         emit OwnershipTransferred(_owner, newOwner);
732         _owner = newOwner;
733     }
734 }
735 
736 
737 // File contracts/v7/interfaces/IPoolAllowance.sol
738 
739 
740 pragma solidity 0.7.4;
741 
742 interface IPoolAllowance is IERC20 {
743     function mintAllowance(address _account, uint256 _amount) external;
744 
745     function burnAllowance(address _account, uint256 _amount) external;
746 }
747 
748 
749 // File contracts/v7/interfaces/IRewardsPool.sol
750 
751 
752 pragma solidity 0.7.4;
753 
754 interface IRewardsPool is IERC20 {
755     function updateReward(address _account) external;
756 
757     function withdraw() external;
758 
759     function depositReward(uint256 _reward) external;
760 }
761 
762 
763 // File contracts/v7/interfaces/IOwnersRewardsPool.sol
764 
765 
766 pragma solidity 0.7.4;
767 
768 interface IOwnersRewardsPool is IRewardsPool {
769     function withdraw(address _account) external;
770 }
771 
772 
773 // File contracts/v7/interfaces/IERC677.sol
774 
775 
776 pragma solidity 0.7.4;
777 
778 interface IERC677 is IERC20 {
779     function transferAndCall(address _to, uint256 _value, bytes calldata _data) external returns (bool success);
780 }
781 
782 
783 // File contracts/v7/PoolOwners.sol
784 
785 
786 pragma solidity 0.7.4;
787 
788 
789 
790 
791 
792 
793 
794 /**
795  * @title Pool Owners
796  * @dev Handles owners token staking, allowance token distribution, & owners rewards assets
797  */
798 contract PoolOwners is ReentrancyGuard, Ownable {
799     using SafeMath for uint256;
800     using SafeERC20 for IERC677;
801 
802     IERC677 public stakingToken;
803     uint256 public totalStaked;
804     mapping(address => uint256) private stakedBalances;
805 
806     uint16 public totalRewardTokens;
807     mapping(uint16 => address) public rewardTokens;
808     mapping(address => address) public rewardPools;
809     mapping(address => address) public allowanceTokens;
810     mapping(address => mapping(address => uint256)) private mintedAllowanceTokens;
811 
812     event Staked(address indexed user, uint256 amount);
813     event Withdrawn(address indexed user, uint256 amount);
814     event RewardsWithdrawn(address indexed user);
815     event AllowanceMinted(address indexed user);
816     event RewardTokenAdded(address indexed token, address allowanceToken, address rewardsPool);
817     event RewardTokenRemoved(address indexed token);
818 
819     constructor(address _stakingToken) {
820         stakingToken = IERC677(_stakingToken);
821     }
822 
823     modifier updateRewards(address _account) {
824         for (uint16 i = 0; i < totalRewardTokens; i++) {
825             IOwnersRewardsPool(rewardPools[rewardTokens[i]]).updateReward(_account);
826         }
827         _;
828     }
829 
830     /**
831      * @dev returns a user's staked balance
832      * @param _account user to return balance for
833      * @return user's staked balance
834      **/
835     function balanceOf(address _account) public view returns (uint256) {
836         return stakedBalances[_account];
837     }
838 
839     /**
840      * @dev returns how many allowance tokens have been minted for a user
841      * @param _allowanceToken allowance token to return minted amount for
842      * @param _account user to return minted amount for
843      * @return total allowance tokens a user has minted
844      **/
845     function mintedAllowance(address _allowanceToken, address _account) public view returns (uint256) {
846         return mintedAllowanceTokens[_allowanceToken][_account];
847     }
848 
849     /**
850      * @dev returns total amount staked
851      * @return total amount staked
852      **/
853     function totalSupply() public view returns (uint256) {
854         return totalStaked;
855     }
856 
857     /**
858      * @dev ERC677 implementation that proxies staking
859      * @param _sender of the token transfer
860      * @param _value of the token transfer
861      **/
862     function onTokenTransfer(address _sender, uint256 _value, bytes calldata) external nonReentrant {
863         require(msg.sender == address(stakingToken), "Sender must be staking token");
864         require(_value > 0, "Cannot stake 0");
865         _stake(_sender, _value);
866     }
867 
868     /**
869      * @dev stakes owners tokens & mints staking allowance tokens in return
870      * @param _amount amount to stake
871      **/
872     function stake(uint256 _amount) external nonReentrant {
873         require(_amount > 0, "Cannot stake 0");
874         stakingToken.safeTransferFrom(msg.sender, address(this), _amount);
875         _stake(msg.sender, _amount);
876     }
877 
878     /**
879      * @dev burns staking allowance tokens and withdraws staked owners tokens
880      * @param _amount amount to withdraw
881      **/
882     function withdraw(uint256 _amount) public nonReentrant updateRewards(msg.sender) {
883         require(_amount > 0, "Cannot withdraw 0");
884         stakedBalances[msg.sender] = stakedBalances[msg.sender].sub(_amount);
885         totalStaked -= _amount;
886         _burnAllowance(msg.sender);
887         stakingToken.safeTransfer(msg.sender, _amount);
888         emit Withdrawn(msg.sender, _amount);
889     }
890 
891     /**
892      * @dev withdraws user's earned rewards for a all assets
893      **/
894     function withdrawAllRewards() public nonReentrant {
895         for (uint16 i = 0; i < totalRewardTokens; i++) {
896             _withdrawReward(rewardTokens[i], msg.sender);
897         }
898         emit RewardsWithdrawn(msg.sender);
899     }
900 
901     /**
902      * @dev withdraws users earned rewards for all assets and withdraws their owners tokens
903      **/
904     function exit() external {
905         withdraw(balanceOf(msg.sender));
906         withdrawAllRewards();
907     }
908 
909     /**
910      * @dev mints a user's unclaimed allowance tokens (used if a new asset is added
911      * after a user has already staked)
912      **/
913     function mintAllowance() external nonReentrant {
914         _mintAllowance(msg.sender);
915         emit AllowanceMinted(msg.sender);
916     }
917 
918     /**
919      * @dev adds a new asset
920      * @param _token asset to add
921      * @param _allowanceToken asset pool allowance token to add
922      * @param _rewardPool asset reward pool to add
923      **/
924     function addRewardToken(
925         address _token,
926         address _allowanceToken,
927         address _rewardPool
928     ) external onlyOwner() {
929         require(rewardPools[_token] == address(0), "Reward token already exists");
930         rewardTokens[totalRewardTokens] = _token;
931         allowanceTokens[_token] = _allowanceToken;
932         rewardPools[_token] = _rewardPool;
933         totalRewardTokens++;
934         emit RewardTokenAdded(_token, _allowanceToken, _rewardPool);
935     }
936 
937     /**
938      * @dev removes an existing asset
939      * @param _index index of asset to remove
940      **/
941     function removeRewardToken(uint16 _index) external onlyOwner() {
942         require(_index < totalRewardTokens, "Reward token does not exist");
943         address token = rewardTokens[_index];
944         if (totalRewardTokens > 1) {
945             rewardTokens[_index] = rewardTokens[totalRewardTokens - 1];
946         }
947         delete rewardTokens[totalRewardTokens - 1];
948         delete allowanceTokens[token];
949         delete rewardPools[token];
950         totalRewardTokens--;
951         emit RewardTokenRemoved(token);
952     }
953 
954     /**
955      * @dev stakes owners tokens & mints staking allowance tokens in return
956      * @param _amount amount to stake
957      **/
958     function _stake(address _sender, uint256 _amount) private updateRewards(_sender) {
959         stakedBalances[_sender] = stakedBalances[_sender].add(_amount);
960         totalStaked += _amount;
961         _mintAllowance(_sender);
962         emit Staked(_sender, _amount);
963     }
964 
965     /**
966      * @dev withdraws rewards for a specific asset & account
967      * @param _token asset to withdraw
968      * @param _account user to withdraw for
969      **/
970     function _withdrawReward(address _token, address _account) private {
971         require(rewardPools[_token] != address(0), "Reward token does not exist");
972         IOwnersRewardsPool(rewardPools[_token]).withdraw(_account);
973     }
974 
975     /**
976      * @dev mints allowance tokens based on a user's staked balance
977      * @param _account user to mint tokens for
978      **/
979     function _mintAllowance(address _account) private {
980         uint256 stakedAmount = balanceOf(_account);
981         for (uint16 i = 0; i < totalRewardTokens; i++) {
982             address token = allowanceTokens[rewardTokens[i]];
983             uint256 minted = mintedAllowance(token, _account);
984             if (minted < stakedAmount) {
985                 IPoolAllowance(token).mintAllowance(_account, stakedAmount.sub(minted));
986                 mintedAllowanceTokens[token][_account] = stakedAmount;
987             }
988         }
989     }
990 
991     /**
992      * @dev burns allowance tokens based on a user's staked balance
993      * @param _account user to burn tokens for
994      **/
995     function _burnAllowance(address _account) private {
996         uint256 stakedAmount = balanceOf(_account);
997         for (uint16 i = 0; i < totalRewardTokens; i++) {
998             address token = allowanceTokens[rewardTokens[i]];
999             uint256 minted = mintedAllowance(token, _account);
1000             if (minted > stakedAmount) {
1001                 IPoolAllowance(token).burnAllowance(_account, minted.sub(stakedAmount));
1002                 mintedAllowanceTokens[token][_account] = stakedAmount;
1003             }
1004         }
1005     }
1006 }