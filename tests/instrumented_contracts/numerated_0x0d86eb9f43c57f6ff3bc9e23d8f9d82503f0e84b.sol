1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 // CAUTION
75 // This version of SafeMath should only be used with Solidity 0.8 or later,
76 // because it relies on the compiler's built in overflow checks.
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations.
80  *
81  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
82  * now has built in overflow checking.
83  */
84 library SafeMath {
85     /**
86      * @dev Returns the addition of two unsigned integers, with an overflow flag.
87      *
88      * _Available since v3.4._
89      */
90     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
91         unchecked {
92             uint256 c = a + b;
93             if (c < a) return (false, 0);
94             return (true, c);
95         }
96     }
97 
98     /**
99      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
100      *
101      * _Available since v3.4._
102      */
103     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
104         unchecked {
105             if (b > a) return (false, 0);
106             return (true, a - b);
107         }
108     }
109 
110     /**
111      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
112      *
113      * _Available since v3.4._
114      */
115     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
116         unchecked {
117             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
118             // benefit is lost if 'b' is also tested.
119             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
120             if (a == 0) return (true, 0);
121             uint256 c = a * b;
122             if (c / a != b) return (false, 0);
123             return (true, c);
124         }
125     }
126 
127     /**
128      * @dev Returns the division of two unsigned integers, with a division by zero flag.
129      *
130      * _Available since v3.4._
131      */
132     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
133         unchecked {
134             if (b == 0) return (false, 0);
135             return (true, a / b);
136         }
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
141      *
142      * _Available since v3.4._
143      */
144     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         unchecked {
146             if (b == 0) return (false, 0);
147             return (true, a % b);
148         }
149     }
150 
151     /**
152      * @dev Returns the addition of two unsigned integers, reverting on
153      * overflow.
154      *
155      * Counterpart to Solidity's `+` operator.
156      *
157      * Requirements:
158      *
159      * - Addition cannot overflow.
160      */
161     function add(uint256 a, uint256 b) internal pure returns (uint256) {
162         return a + b;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         return a - b;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         return a * b;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers, reverting on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator.
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return a / b;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a % b;
221     }
222 
223     /**
224      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
225      * overflow (when the result is negative).
226      *
227      * CAUTION: This function is deprecated because it requires allocating memory for the error
228      * message unnecessarily. For custom revert reasons use {trySub}.
229      *
230      * Counterpart to Solidity's `-` operator.
231      *
232      * Requirements:
233      *
234      * - Subtraction cannot overflow.
235      */
236     function sub(
237         uint256 a,
238         uint256 b,
239         string memory errorMessage
240     ) internal pure returns (uint256) {
241         unchecked {
242             require(b <= a, errorMessage);
243             return a - b;
244         }
245     }
246 
247     /**
248      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
249      * division by zero. The result is rounded towards zero.
250      *
251      * Counterpart to Solidity's `/` operator. Note: this function uses a
252      * `revert` opcode (which leaves remaining gas untouched) while Solidity
253      * uses an invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function div(
260         uint256 a,
261         uint256 b,
262         string memory errorMessage
263     ) internal pure returns (uint256) {
264         unchecked {
265             require(b > 0, errorMessage);
266             return a / b;
267         }
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * reverting with custom message when dividing by zero.
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {tryMod}.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(
286         uint256 a,
287         uint256 b,
288         string memory errorMessage
289     ) internal pure returns (uint256) {
290         unchecked {
291             require(b > 0, errorMessage);
292             return a % b;
293         }
294     }
295 }
296 
297 // File: @openzeppelin/contracts/utils/Address.sol
298 
299 
300 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
301 
302 pragma solidity ^0.8.1;
303 
304 /**
305  * @dev Collection of functions related to the address type
306  */
307 library Address {
308     /**
309      * @dev Returns true if `account` is a contract.
310      *
311      * [IMPORTANT]
312      * ====
313      * It is unsafe to assume that an address for which this function returns
314      * false is an externally-owned account (EOA) and not a contract.
315      *
316      * Among others, `isContract` will return false for the following
317      * types of addresses:
318      *
319      *  - an externally-owned account
320      *  - a contract in construction
321      *  - an address where a contract will be created
322      *  - an address where a contract lived, but was destroyed
323      * ====
324      *
325      * [IMPORTANT]
326      * ====
327      * You shouldn't rely on `isContract` to protect against flash loan attacks!
328      *
329      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
330      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
331      * constructor.
332      * ====
333      */
334     function isContract(address account) internal view returns (bool) {
335         // This method relies on extcodesize/address.code.length, which returns 0
336         // for contracts in construction, since the code is only stored at the end
337         // of the constructor execution.
338 
339         return account.code.length > 0;
340     }
341 
342     /**
343      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
344      * `recipient`, forwarding all available gas and reverting on errors.
345      *
346      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
347      * of certain opcodes, possibly making contracts go over the 2300 gas limit
348      * imposed by `transfer`, making them unable to receive funds via
349      * `transfer`. {sendValue} removes this limitation.
350      *
351      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
352      *
353      * IMPORTANT: because control is transferred to `recipient`, care must be
354      * taken to not create reentrancy vulnerabilities. Consider using
355      * {ReentrancyGuard} or the
356      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
357      */
358     function sendValue(address payable recipient, uint256 amount) internal {
359         require(address(this).balance >= amount, "Address: insufficient balance");
360 
361         (bool success, ) = recipient.call{value: amount}("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 
365     /**
366      * @dev Performs a Solidity function call using a low level `call`. A
367      * plain `call` is an unsafe replacement for a function call: use this
368      * function instead.
369      *
370      * If `target` reverts with a revert reason, it is bubbled up by this
371      * function (like regular Solidity function calls).
372      *
373      * Returns the raw returned data. To convert to the expected return value,
374      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
375      *
376      * Requirements:
377      *
378      * - `target` must be a contract.
379      * - calling `target` with `data` must not revert.
380      *
381      * _Available since v3.1._
382      */
383     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
384         return functionCall(target, data, "Address: low-level call failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
389      * `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(
394         address target,
395         bytes memory data,
396         string memory errorMessage
397     ) internal returns (bytes memory) {
398         return functionCallWithValue(target, data, 0, errorMessage);
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
403      * but also transferring `value` wei to `target`.
404      *
405      * Requirements:
406      *
407      * - the calling contract must have an ETH balance of at least `value`.
408      * - the called Solidity function must be `payable`.
409      *
410      * _Available since v3.1._
411      */
412     function functionCallWithValue(
413         address target,
414         bytes memory data,
415         uint256 value
416     ) internal returns (bytes memory) {
417         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
418     }
419 
420     /**
421      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
422      * with `errorMessage` as a fallback revert reason when `target` reverts.
423      *
424      * _Available since v3.1._
425      */
426     function functionCallWithValue(
427         address target,
428         bytes memory data,
429         uint256 value,
430         string memory errorMessage
431     ) internal returns (bytes memory) {
432         require(address(this).balance >= value, "Address: insufficient balance for call");
433         require(isContract(target), "Address: call to non-contract");
434 
435         (bool success, bytes memory returndata) = target.call{value: value}(data);
436         return verifyCallResult(success, returndata, errorMessage);
437     }
438 
439     /**
440      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
441      * but performing a static call.
442      *
443      * _Available since v3.3._
444      */
445     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
446         return functionStaticCall(target, data, "Address: low-level static call failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
451      * but performing a static call.
452      *
453      * _Available since v3.3._
454      */
455     function functionStaticCall(
456         address target,
457         bytes memory data,
458         string memory errorMessage
459     ) internal view returns (bytes memory) {
460         require(isContract(target), "Address: static call to non-contract");
461 
462         (bool success, bytes memory returndata) = target.staticcall(data);
463         return verifyCallResult(success, returndata, errorMessage);
464     }
465 
466     /**
467      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
468      * but performing a delegate call.
469      *
470      * _Available since v3.4._
471      */
472     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
473         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
474     }
475 
476     /**
477      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
478      * but performing a delegate call.
479      *
480      * _Available since v3.4._
481      */
482     function functionDelegateCall(
483         address target,
484         bytes memory data,
485         string memory errorMessage
486     ) internal returns (bytes memory) {
487         require(isContract(target), "Address: delegate call to non-contract");
488 
489         (bool success, bytes memory returndata) = target.delegatecall(data);
490         return verifyCallResult(success, returndata, errorMessage);
491     }
492 
493     /**
494      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
495      * revert reason using the provided one.
496      *
497      * _Available since v4.3._
498      */
499     function verifyCallResult(
500         bool success,
501         bytes memory returndata,
502         string memory errorMessage
503     ) internal pure returns (bytes memory) {
504         if (success) {
505             return returndata;
506         } else {
507             // Look for revert reason and bubble it up if present
508             if (returndata.length > 0) {
509                 // The easiest way to bubble the revert reason is using memory via assembly
510 
511                 assembly {
512                     let returndata_size := mload(returndata)
513                     revert(add(32, returndata), returndata_size)
514                 }
515             } else {
516                 revert(errorMessage);
517             }
518         }
519     }
520 }
521 
522 // File: @openzeppelin/contracts/utils/Context.sol
523 
524 
525 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
526 
527 pragma solidity ^0.8.0;
528 
529 /**
530  * @dev Provides information about the current execution context, including the
531  * sender of the transaction and its data. While these are generally available
532  * via msg.sender and msg.data, they should not be accessed in such a direct
533  * manner, since when dealing with meta-transactions the account sending and
534  * paying for execution may not be the actual sender (as far as an application
535  * is concerned).
536  *
537  * This contract is only required for intermediate, library-like contracts.
538  */
539 abstract contract Context {
540     function _msgSender() internal view virtual returns (address) {
541         return msg.sender;
542     }
543 
544     function _msgData() internal view virtual returns (bytes calldata) {
545         return msg.data;
546     }
547 }
548 
549 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
550 
551 
552 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 /**
557  * @dev Interface of the ERC20 standard as defined in the EIP.
558  */
559 interface IERC20 {
560     /**
561      * @dev Returns the amount of tokens in existence.
562      */
563     function totalSupply() external view returns (uint256);
564 
565     /**
566      * @dev Returns the amount of tokens owned by `account`.
567      */
568     function balanceOf(address account) external view returns (uint256);
569 
570     /**
571      * @dev Moves `amount` tokens from the caller's account to `to`.
572      *
573      * Returns a boolean value indicating whether the operation succeeded.
574      *
575      * Emits a {Transfer} event.
576      */
577     function transfer(address to, uint256 amount) external returns (bool);
578 
579     /**
580      * @dev Returns the remaining number of tokens that `spender` will be
581      * allowed to spend on behalf of `owner` through {transferFrom}. This is
582      * zero by default.
583      *
584      * This value changes when {approve} or {transferFrom} are called.
585      */
586     function allowance(address owner, address spender) external view returns (uint256);
587 
588     /**
589      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
590      *
591      * Returns a boolean value indicating whether the operation succeeded.
592      *
593      * IMPORTANT: Beware that changing an allowance with this method brings the risk
594      * that someone may use both the old and the new allowance by unfortunate
595      * transaction ordering. One possible solution to mitigate this race
596      * condition is to first reduce the spender's allowance to 0 and set the
597      * desired value afterwards:
598      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
599      *
600      * Emits an {Approval} event.
601      */
602     function approve(address spender, uint256 amount) external returns (bool);
603 
604     /**
605      * @dev Moves `amount` tokens from `from` to `to` using the
606      * allowance mechanism. `amount` is then deducted from the caller's
607      * allowance.
608      *
609      * Returns a boolean value indicating whether the operation succeeded.
610      *
611      * Emits a {Transfer} event.
612      */
613     function transferFrom(
614         address from,
615         address to,
616         uint256 amount
617     ) external returns (bool);
618 
619     /**
620      * @dev Emitted when `value` tokens are moved from one account (`from`) to
621      * another (`to`).
622      *
623      * Note that `value` may be zero.
624      */
625     event Transfer(address indexed from, address indexed to, uint256 value);
626 
627     /**
628      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
629      * a call to {approve}. `value` is the new allowance.
630      */
631     event Approval(address indexed owner, address indexed spender, uint256 value);
632 }
633 
634 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
635 
636 
637 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 
643 /**
644  * @title SafeERC20
645  * @dev Wrappers around ERC20 operations that throw on failure (when the token
646  * contract returns false). Tokens that return no value (and instead revert or
647  * throw on failure) are also supported, non-reverting calls are assumed to be
648  * successful.
649  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
650  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
651  */
652 library SafeERC20 {
653     using Address for address;
654 
655     function safeTransfer(
656         IERC20 token,
657         address to,
658         uint256 value
659     ) internal {
660         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
661     }
662 
663     function safeTransferFrom(
664         IERC20 token,
665         address from,
666         address to,
667         uint256 value
668     ) internal {
669         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
670     }
671 
672     /**
673      * @dev Deprecated. This function has issues similar to the ones found in
674      * {IERC20-approve}, and its usage is discouraged.
675      *
676      * Whenever possible, use {safeIncreaseAllowance} and
677      * {safeDecreaseAllowance} instead.
678      */
679     function safeApprove(
680         IERC20 token,
681         address spender,
682         uint256 value
683     ) internal {
684         // safeApprove should only be called when setting an initial allowance,
685         // or when resetting it to zero. To increase and decrease it, use
686         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
687         require(
688             (value == 0) || (token.allowance(address(this), spender) == 0),
689             "SafeERC20: approve from non-zero to non-zero allowance"
690         );
691         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
692     }
693 
694     function safeIncreaseAllowance(
695         IERC20 token,
696         address spender,
697         uint256 value
698     ) internal {
699         uint256 newAllowance = token.allowance(address(this), spender) + value;
700         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
701     }
702 
703     function safeDecreaseAllowance(
704         IERC20 token,
705         address spender,
706         uint256 value
707     ) internal {
708         unchecked {
709             uint256 oldAllowance = token.allowance(address(this), spender);
710             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
711             uint256 newAllowance = oldAllowance - value;
712             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
713         }
714     }
715 
716     /**
717      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
718      * on the return value: the return value is optional (but if data is returned, it must not be false).
719      * @param token The token targeted by the call.
720      * @param data The call data (encoded using abi.encode or one of its variants).
721      */
722     function _callOptionalReturn(IERC20 token, bytes memory data) private {
723         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
724         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
725         // the target address contains contract code and also asserts for success in the low-level call.
726 
727         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
728         if (returndata.length > 0) {
729             // Return data is optional
730             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
731         }
732     }
733 }
734 
735 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
736 
737 
738 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Interface for the optional metadata functions from the ERC20 standard.
745  *
746  * _Available since v4.1._
747  */
748 interface IERC20Metadata is IERC20 {
749     /**
750      * @dev Returns the name of the token.
751      */
752     function name() external view returns (string memory);
753 
754     /**
755      * @dev Returns the symbol of the token.
756      */
757     function symbol() external view returns (string memory);
758 
759     /**
760      * @dev Returns the decimals places of the token.
761      */
762     function decimals() external view returns (uint8);
763 }
764 
765 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
766 
767 
768 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
769 
770 pragma solidity ^0.8.0;
771 
772 
773 
774 
775 /**
776  * @dev Implementation of the {IERC20} interface.
777  *
778  * This implementation is agnostic to the way tokens are created. This means
779  * that a supply mechanism has to be added in a derived contract using {_mint}.
780  * For a generic mechanism see {ERC20PresetMinterPauser}.
781  *
782  * TIP: For a detailed writeup see our guide
783  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
784  * to implement supply mechanisms].
785  *
786  * We have followed general OpenZeppelin Contracts guidelines: functions revert
787  * instead returning `false` on failure. This behavior is nonetheless
788  * conventional and does not conflict with the expectations of ERC20
789  * applications.
790  *
791  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
792  * This allows applications to reconstruct the allowance for all accounts just
793  * by listening to said events. Other implementations of the EIP may not emit
794  * these events, as it isn't required by the specification.
795  *
796  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
797  * functions have been added to mitigate the well-known issues around setting
798  * allowances. See {IERC20-approve}.
799  */
800 contract ERC20 is Context, IERC20, IERC20Metadata {
801     mapping(address => uint256) private _balances;
802 
803     mapping(address => mapping(address => uint256)) private _allowances;
804 
805     uint256 private _totalSupply;
806 
807     string private _name;
808     string private _symbol;
809 
810     /**
811      * @dev Sets the values for {name} and {symbol}.
812      *
813      * The default value of {decimals} is 18. To select a different value for
814      * {decimals} you should overload it.
815      *
816      * All two of these values are immutable: they can only be set once during
817      * construction.
818      */
819     constructor(string memory name_, string memory symbol_) {
820         _name = name_;
821         _symbol = symbol_;
822     }
823 
824     /**
825      * @dev Returns the name of the token.
826      */
827     function name() public view virtual override returns (string memory) {
828         return _name;
829     }
830 
831     /**
832      * @dev Returns the symbol of the token, usually a shorter version of the
833      * name.
834      */
835     function symbol() public view virtual override returns (string memory) {
836         return _symbol;
837     }
838 
839     /**
840      * @dev Returns the number of decimals used to get its user representation.
841      * For example, if `decimals` equals `2`, a balance of `505` tokens should
842      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
843      *
844      * Tokens usually opt for a value of 18, imitating the relationship between
845      * Ether and Wei. This is the value {ERC20} uses, unless this function is
846      * overridden;
847      *
848      * NOTE: This information is only used for _display_ purposes: it in
849      * no way affects any of the arithmetic of the contract, including
850      * {IERC20-balanceOf} and {IERC20-transfer}.
851      */
852     function decimals() public view virtual override returns (uint8) {
853         return 18;
854     }
855 
856     /**
857      * @dev See {IERC20-totalSupply}.
858      */
859     function totalSupply() public view virtual override returns (uint256) {
860         return _totalSupply;
861     }
862 
863     /**
864      * @dev See {IERC20-balanceOf}.
865      */
866     function balanceOf(address account) public view virtual override returns (uint256) {
867         return _balances[account];
868     }
869 
870     /**
871      * @dev See {IERC20-transfer}.
872      *
873      * Requirements:
874      *
875      * - `to` cannot be the zero address.
876      * - the caller must have a balance of at least `amount`.
877      */
878     function transfer(address to, uint256 amount) public virtual override returns (bool) {
879         address owner = _msgSender();
880         _transfer(owner, to, amount);
881         return true;
882     }
883 
884     /**
885      * @dev See {IERC20-allowance}.
886      */
887     function allowance(address owner, address spender) public view virtual override returns (uint256) {
888         return _allowances[owner][spender];
889     }
890 
891     /**
892      * @dev See {IERC20-approve}.
893      *
894      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
895      * `transferFrom`. This is semantically equivalent to an infinite approval.
896      *
897      * Requirements:
898      *
899      * - `spender` cannot be the zero address.
900      */
901     function approve(address spender, uint256 amount) public virtual override returns (bool) {
902         address owner = _msgSender();
903         _approve(owner, spender, amount);
904         return true;
905     }
906 
907     /**
908      * @dev See {IERC20-transferFrom}.
909      *
910      * Emits an {Approval} event indicating the updated allowance. This is not
911      * required by the EIP. See the note at the beginning of {ERC20}.
912      *
913      * NOTE: Does not update the allowance if the current allowance
914      * is the maximum `uint256`.
915      *
916      * Requirements:
917      *
918      * - `from` and `to` cannot be the zero address.
919      * - `from` must have a balance of at least `amount`.
920      * - the caller must have allowance for ``from``'s tokens of at least
921      * `amount`.
922      */
923     function transferFrom(
924         address from,
925         address to,
926         uint256 amount
927     ) public virtual override returns (bool) {
928         address spender = _msgSender();
929         _spendAllowance(from, spender, amount);
930         _transfer(from, to, amount);
931         return true;
932     }
933 
934     /**
935      * @dev Atomically increases the allowance granted to `spender` by the caller.
936      *
937      * This is an alternative to {approve} that can be used as a mitigation for
938      * problems described in {IERC20-approve}.
939      *
940      * Emits an {Approval} event indicating the updated allowance.
941      *
942      * Requirements:
943      *
944      * - `spender` cannot be the zero address.
945      */
946     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
947         address owner = _msgSender();
948         _approve(owner, spender, _allowances[owner][spender] + addedValue);
949         return true;
950     }
951 
952     /**
953      * @dev Atomically decreases the allowance granted to `spender` by the caller.
954      *
955      * This is an alternative to {approve} that can be used as a mitigation for
956      * problems described in {IERC20-approve}.
957      *
958      * Emits an {Approval} event indicating the updated allowance.
959      *
960      * Requirements:
961      *
962      * - `spender` cannot be the zero address.
963      * - `spender` must have allowance for the caller of at least
964      * `subtractedValue`.
965      */
966     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
967         address owner = _msgSender();
968         uint256 currentAllowance = _allowances[owner][spender];
969         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
970         unchecked {
971             _approve(owner, spender, currentAllowance - subtractedValue);
972         }
973 
974         return true;
975     }
976 
977     /**
978      * @dev Moves `amount` of tokens from `sender` to `recipient`.
979      *
980      * This internal function is equivalent to {transfer}, and can be used to
981      * e.g. implement automatic token fees, slashing mechanisms, etc.
982      *
983      * Emits a {Transfer} event.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `from` must have a balance of at least `amount`.
990      */
991     function _transfer(
992         address from,
993         address to,
994         uint256 amount
995     ) internal virtual {
996         require(from != address(0), "ERC20: transfer from the zero address");
997         require(to != address(0), "ERC20: transfer to the zero address");
998 
999         _beforeTokenTransfer(from, to, amount);
1000 
1001         uint256 fromBalance = _balances[from];
1002         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1003         unchecked {
1004             _balances[from] = fromBalance - amount;
1005         }
1006         _balances[to] += amount;
1007 
1008         emit Transfer(from, to, amount);
1009 
1010         _afterTokenTransfer(from, to, amount);
1011     }
1012 
1013     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1014      * the total supply.
1015      *
1016      * Emits a {Transfer} event with `from` set to the zero address.
1017      *
1018      * Requirements:
1019      *
1020      * - `account` cannot be the zero address.
1021      */
1022     function _mint(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: mint to the zero address");
1024 
1025         _beforeTokenTransfer(address(0), account, amount);
1026 
1027         _totalSupply += amount;
1028         _balances[account] += amount;
1029         emit Transfer(address(0), account, amount);
1030 
1031         _afterTokenTransfer(address(0), account, amount);
1032     }
1033 
1034     /**
1035      * @dev Destroys `amount` tokens from `account`, reducing the
1036      * total supply.
1037      *
1038      * Emits a {Transfer} event with `to` set to the zero address.
1039      *
1040      * Requirements:
1041      *
1042      * - `account` cannot be the zero address.
1043      * - `account` must have at least `amount` tokens.
1044      */
1045     function _burn(address account, uint256 amount) internal virtual {
1046         require(account != address(0), "ERC20: burn from the zero address");
1047 
1048         _beforeTokenTransfer(account, address(0), amount);
1049 
1050         uint256 accountBalance = _balances[account];
1051         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1052         unchecked {
1053             _balances[account] = accountBalance - amount;
1054         }
1055         _totalSupply -= amount;
1056 
1057         emit Transfer(account, address(0), amount);
1058 
1059         _afterTokenTransfer(account, address(0), amount);
1060     }
1061 
1062     /**
1063      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1064      *
1065      * This internal function is equivalent to `approve`, and can be used to
1066      * e.g. set automatic allowances for certain subsystems, etc.
1067      *
1068      * Emits an {Approval} event.
1069      *
1070      * Requirements:
1071      *
1072      * - `owner` cannot be the zero address.
1073      * - `spender` cannot be the zero address.
1074      */
1075     function _approve(
1076         address owner,
1077         address spender,
1078         uint256 amount
1079     ) internal virtual {
1080         require(owner != address(0), "ERC20: approve from the zero address");
1081         require(spender != address(0), "ERC20: approve to the zero address");
1082 
1083         _allowances[owner][spender] = amount;
1084         emit Approval(owner, spender, amount);
1085     }
1086 
1087     /**
1088      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
1089      *
1090      * Does not update the allowance amount in case of infinite allowance.
1091      * Revert if not enough allowance is available.
1092      *
1093      * Might emit an {Approval} event.
1094      */
1095     function _spendAllowance(
1096         address owner,
1097         address spender,
1098         uint256 amount
1099     ) internal virtual {
1100         uint256 currentAllowance = allowance(owner, spender);
1101         if (currentAllowance != type(uint256).max) {
1102             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1103             unchecked {
1104                 _approve(owner, spender, currentAllowance - amount);
1105             }
1106         }
1107     }
1108 
1109     /**
1110      * @dev Hook that is called before any transfer of tokens. This includes
1111      * minting and burning.
1112      *
1113      * Calling conditions:
1114      *
1115      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1116      * will be transferred to `to`.
1117      * - when `from` is zero, `amount` tokens will be minted for `to`.
1118      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1119      * - `from` and `to` are never both zero.
1120      *
1121      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1122      */
1123     function _beforeTokenTransfer(
1124         address from,
1125         address to,
1126         uint256 amount
1127     ) internal virtual {}
1128 
1129     /**
1130      * @dev Hook that is called after any transfer of tokens. This includes
1131      * minting and burning.
1132      *
1133      * Calling conditions:
1134      *
1135      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1136      * has been transferred to `to`.
1137      * - when `from` is zero, `amount` tokens have been minted for `to`.
1138      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1139      * - `from` and `to` are never both zero.
1140      *
1141      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1142      */
1143     function _afterTokenTransfer(
1144         address from,
1145         address to,
1146         uint256 amount
1147     ) internal virtual {}
1148 }
1149 
1150 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1151 
1152 
1153 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1154 
1155 pragma solidity ^0.8.0;
1156 
1157 
1158 
1159 /**
1160  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1161  * tokens and those that they have an allowance for, in a way that can be
1162  * recognized off-chain (via event analysis).
1163  */
1164 abstract contract ERC20Burnable is Context, ERC20 {
1165     /**
1166      * @dev Destroys `amount` tokens from the caller.
1167      *
1168      * See {ERC20-_burn}.
1169      */
1170     function burn(uint256 amount) public virtual {
1171         _burn(_msgSender(), amount);
1172     }
1173 
1174     /**
1175      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1176      * allowance.
1177      *
1178      * See {ERC20-_burn} and {ERC20-allowance}.
1179      *
1180      * Requirements:
1181      *
1182      * - the caller must have allowance for ``accounts``'s tokens of at least
1183      * `amount`.
1184      */
1185     function burnFrom(address account, uint256 amount) public virtual {
1186         _spendAllowance(account, _msgSender(), amount);
1187         _burn(account, amount);
1188     }
1189 }
1190 
1191 // File: contracts/maximus.sol
1192 
1193 //SPDX-License-Identifier: UNLICENSED
1194 pragma solidity ^0.8.2;
1195 
1196 
1197 
1198 
1199 
1200 
1201 contract HedronToken {
1202   function approve(address spender, uint256 amount) external returns (bool) {}
1203   function transfer(address recipient, uint256 amount) external returns (bool) {}
1204   function mintNative(uint256 stakeIndex, uint40 stakeId) external returns (uint256) {}
1205   function claimNative(uint256 stakeIndex, uint40 stakeId) external returns (uint256) {}
1206   function currentDay() external view returns (uint256) {}
1207 }
1208 
1209 contract HEXToken {
1210   function currentDay() external view returns (uint256){}
1211   function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external {}
1212   function approve(address spender, uint256 amount) external returns (bool) {}
1213   function transfer(address recipient, uint256 amount) public returns (bool) {}
1214   function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) public {}
1215   function stakeCount(address stakerAddr) external view returns (uint256) {}
1216 }
1217 /*
1218 ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
1219 ─██████──────────██████────██████████████────████████──████████────██████████────██████──────────██████────██████──██████────██████████████─
1220 ─██░░██████████████░░██────██░░░░░░░░░░██────██░░░░██──██░░░░██────██░░░░░░██────██░░██████████████░░██────██░░██──██░░██────██░░░░░░░░░░██─
1221 ─██░░░░░░░░░░░░░░░░░░██────██░░██████░░██────████░░██──██░░████────████░░████────██░░░░░░░░░░░░░░░░░░██────██░░██──██░░██────██░░██████████─
1222 ─██░░██████░░██████░░██────██░░██──██░░██──────██░░░░██░░░░██────────██░░██──────██░░██████░░██████░░██────██░░██──██░░██────██░░██─────────
1223 ─██░░██──██░░██──██░░██────██░░██████░░██──────████░░░░░░████────────██░░██──────██░░██──██░░██──██░░██────██░░██──██░░██────██░░██████████─
1224 ─██░░██──██░░██──██░░██────██░░░░░░░░░░██────────██░░░░░░██──────────██░░██──────██░░██──██░░██──██░░██────██░░██──██░░██────██░░░░░░░░░░██─
1225 ─██░░██──██████──██░░██────██░░██████░░██──────████░░░░░░████────────██░░██──────██░░██──██████──██░░██────██░░██──██░░██────██████████░░██─
1226 ─██░░██──────────██░░██────██░░██──██░░██──────██░░░░██░░░░██────────██░░██──────██░░██──────────██░░██────██░░██──██░░██────────────██░░██─
1227 ─██░░██──────────██░░██────██░░██──██░░██────████░░██──██░░████────████░░████────██░░██──────────██░░██────██░░██████░░██────██████████░░██─
1228 ─██░░██──────────██░░██────██░░██──██░░██────██░░░░██──██░░░░██────██░░░░░░██────██░░██──────────██░░██────██░░░░░░░░░░██────██░░░░░░░░░░██─
1229 ─██████──────────██████────██████──██████────████████──████████────██████████────██████──────────██████────██████████████────██████████████─
1230 ────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────
1231 
1232                                     █▀ ▀█▀ █▀█ █▀▀ █▄░█ █▀▀ ▀█▀ █░█   ▄▀█ █▄░█ █▀▄   █░█ █▀█ █▄░█ █▀█ █▀█
1233                                     ▄█ ░█░ █▀▄ ██▄ █░▀█ █▄█ ░█░ █▀█   █▀█ █░▀█ █▄▀   █▀█ █▄█ █░▀█ █▄█ █▀▄
1234 
1235 // Maximus is a contract for trustlessly pooling a single max length hex stake.
1236 // Anyone may choose to mint 1 MAXI per HEX deposited into the Maximus Contract Address during the minting phase.
1237 // Anyone may choose to pay for the gas to start and end the stake on behalf of the Maximus Contract.
1238 // Anyone may choose to pay for the gas to mint Hedron the stake earns on behalf of the Maximus Contract.
1239 // MAXI is a standard ERC20 token, only minted upon HEX deposit and burnt upon HEX redemption with no pre-mine or contract fee.
1240 // MAXI holders may choose to burn MAXI to redeem HEX principal and yield (Including HEDRON) pro-rata from the Maximus Contract Address during the redemption phase.
1241 //
1242 // |--- Minting Phase---|---------- 5555 Day Stake Phase ------------...-----|------ Redemption Phase ---------->
1243 
1244 
1245 THE MAXIMUS CONTRACT, SUPPORTING WEBSITES, AND ALL OTHER INTERFACES (THE SOFTWARE) IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
1246 LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
1247 
1248 BY INTERACTING WITH THE SOFTWARE YOU ARE ASSERTING THAT YOU BEAR ALL THE RISKS ASSOCIATED WITH DOING SO. AN INFINITE NUMBER OF UNPREDICTABLE THINGS MAY GO WRONG WHICH COULD POTENTIALLY RESULT IN CRITICAL FAILURE AND FINANCIAL LOSS. BY INTERACTING WITH THE SOFTWARE YOU ARE ASSERTING THAT YOU AGREE THERE IS NO RECOURSE AVAILABLE AND YOU WILL NOT SEEK IT.
1249 
1250 INTERACTING WITH THE SOFTWARE SHALL NOT BE CONSIDERED AN INVESTMENT OR A COMMON ENTERPRISE. INSTEAD, INTERACTING WITH THE SOFTWARE IS EQUIVALENT TO CARPOOLING WITH FRIENDS TO SAVE ON GAS AND EXPERIENCE THE BENEFITS OF THE H.O.V. LANE. 
1251 
1252 YOU SHALL HAVE NO EXPECTATION OF PROFIT OR ANY TYPE OF GAIN FROM THE WORK OF OTHER PEOPLE.
1253 
1254 */
1255 
1256 
1257 contract Maximus is ERC20, ERC20Burnable, ReentrancyGuard {
1258     // all days are measured in terms of the HEX contract day number
1259     uint256 MINTING_PHASE_START;
1260     uint256 MINTING_PHASE_END;
1261     uint256 STAKE_START_DAY;
1262     uint256 STAKE_END_DAY;
1263     uint256 STAKE_LENGTH;
1264     uint256 HEX_REDEMPTION_RATE; // Number of HEX units redeemable per MAXI
1265     uint256 HEDRON_REDEMPTION_RATE; // Number of HEDRON units redeemable per MAXI
1266     bool HAS_STAKE_STARTED;
1267     bool HAS_STAKE_ENDED;
1268     bool HAS_HEDRON_MINTED;
1269     address END_STAKER; 
1270     
1271     constructor(uint256 mint_duration, uint256 stake_duration) ERC20("Maximus", "MAXI") ReentrancyGuard() {
1272         uint256 start_day=hex_token.currentDay();
1273         MINTING_PHASE_START = start_day;
1274         MINTING_PHASE_END = start_day+mint_duration;
1275         STAKE_LENGTH=stake_duration; 
1276         HAS_STAKE_STARTED=false;
1277         HAS_STAKE_ENDED = false;
1278         HAS_HEDRON_MINTED=false;
1279         HEX_REDEMPTION_RATE=100000000; // HEX and MAXI are 1:1 convertible up until the stake is initiated
1280         HEDRON_REDEMPTION_RATE=0; //no hedron is redeemable until minting has occurred
1281         
1282         
1283     }
1284     
1285     /**
1286     * @dev View number of decimal places the MAXI token is divisible to. Manually overwritten from default 18 to 8 to match that of HEX. 1 MAXI = 10^8 mini
1287     */
1288     
1289     function decimals() public view virtual override returns (uint8) {
1290         return 8;
1291 	}
1292     address MAXI_ADDRESS =address(this);
1293     address constant HEX_ADDRESS = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39; // "2b, 5 9 1e? that is the question..."
1294     address constant HEDRON_ADDRESS=0x3819f64f282bf135d62168C1e513280dAF905e06; 
1295 
1296     IERC20 hex_contract = IERC20(HEX_ADDRESS);
1297     IERC20 hedron_contract=IERC20(HEDRON_ADDRESS);
1298     HEXToken hex_token = HEXToken(HEX_ADDRESS);
1299     HedronToken hedron_token = HedronToken(HEDRON_ADDRESS);
1300     // public function
1301     /**
1302     * @dev Returns the HEX Day that the Minting Phase started.
1303     * @return HEX Day that the Minting Phase started.
1304     */
1305     function getMintingPhaseStartDay() external view returns (uint256) {return MINTING_PHASE_START;}
1306     /**
1307     * @dev Returns the HEX Day that the Minting Phase ends.
1308     * @return HEX Day that the Minting Phase ends.
1309     */
1310     function getMintingPhaseEndDay() external view returns (uint256) {return MINTING_PHASE_END;}
1311     /**
1312     * @dev Returns the HEX Day that the Maximus HEX Stake started.
1313     * @return HEX Day that the Maximus HEX Stake started.
1314     */
1315     function getStakeStartDay() external view returns (uint256) {return STAKE_START_DAY;}
1316     /**
1317     * @dev Returns the HEX Day that the Maximus HEX Stake ends.
1318     * @return HEX Day that the Maximus HEX Stake ends.
1319     */
1320     function getStakeEndDay() external view returns (uint256) {return STAKE_END_DAY;}
1321     /**
1322     * @dev Returns the rate at which MAXI may be redeemed for HEX. "Number of HEX hearts per 1 MAXI redeemed."
1323     * @return Rate at which MAXI may be redeemed for HEX. "Number of HEX hearts per 1 MAXI redeemed."
1324     */
1325     function getHEXRedemptionRate() external view returns (uint256) {return HEX_REDEMPTION_RATE;}
1326     /**
1327     * @dev Returns the rate at which MAXI may be redeemed for HEDRON.
1328     * @return Rate at which MAXI may be redeemed for HDRN.
1329     */
1330     function getHedronRedemptionRate() external view returns (uint256) {return HEDRON_REDEMPTION_RATE;}
1331 
1332     /**
1333     * @dev Returns the current HEX day."
1334     * @return Current HEX Day
1335     */
1336     function getHexDay() external view returns (uint256){
1337         uint256 day = hex_token.currentDay();
1338         return day;
1339     }
1340      /**
1341     * @dev Returns the current HEDRON day."
1342     * @return day Current HEDRON Day
1343     */
1344     function getHedronDay() external view returns (uint day) {return hedron_token.currentDay();}
1345 
1346      /**
1347     * @dev Returns the address of the person who ends stake. May be used by external gas pooling contracts. If stake has not been ended yet will return 0x000...000"
1348     * @return end_staker_address This person should be honored and celebrated as a hero.
1349     */
1350     function getEndStaker() external view returns (address end_staker_address) {return END_STAKER;}
1351 
1352     // MAXI Issuance and Redemption Functions
1353     /**
1354      * @dev Mints MAXI.
1355      * @param amount of MAXI to mint, measured in minis
1356      */
1357     function mint(uint256 amount) private {
1358         _mint(msg.sender, amount);
1359     }
1360      /**
1361      * @dev Ensures that MAXI Minting Phase is ongoing and that the user has allowed the Maximus Contract address to spend the amount of HEX the user intends to pledge to Maximus. Then sends the designated HEX from the user to the Maximus Contract address and mints 1 MAXI per HEX pledged.
1362      * @param amount of HEX user chose to pledge, measured in hearts
1363      */
1364     function pledgeHEX(uint256 amount) nonReentrant external {
1365         require(hex_token.currentDay()<=MINTING_PHASE_END, "Minting Phase is Done");
1366         require(hex_contract.allowance(msg.sender, MAXI_ADDRESS)>=amount, "Please approve contract address as allowed spender in the hex contract.");
1367         address from = msg.sender;
1368         hex_contract.transferFrom(from, MAXI_ADDRESS, amount);
1369         mint(amount);
1370     }
1371      /**
1372      * @dev Ensures that it is currently a redemption period (before stake starts or after stake ends) and that the user has at least the number of maxi they entered. Then it calculates how much hex may be redeemed, burns the MAXI, and transfers them the hex.
1373      * @param amount_MAXI number of MAXI that the user is redeeming, measured in mini
1374      */
1375     function redeemHEX(uint256 amount_MAXI) nonReentrant external {
1376         require(HAS_STAKE_STARTED==false || HAS_STAKE_ENDED==true , "Redemption can only happen before stake starts or after stake ends.");
1377         uint256 yourMAXI = balanceOf(msg.sender);
1378         require(yourMAXI>=amount_MAXI, "You do not have that much MAXI.");
1379         uint256 raw_redeemable_amount = amount_MAXI*HEX_REDEMPTION_RATE;
1380         uint256 redeemable_amount = raw_redeemable_amount/100000000; //scaled back down to handle integer rounding
1381         burn(amount_MAXI);
1382         hex_token.transfer(msg.sender, redeemable_amount);
1383         if (HAS_HEDRON_MINTED==true) {
1384             uint256 raw_redeemable_hedron = amount_MAXI*HEDRON_REDEMPTION_RATE;
1385             uint256 redeemable_hedron = raw_redeemable_hedron/100000000; //scaled back down to handle integer rounding
1386             hedron_token.transfer(msg.sender, redeemable_hedron);
1387         }
1388     }
1389     //Staking Functions
1390     // Anyone may run these functions during the allowed time, so long as they pay the gas.
1391     // While nothing is forcing you to, gracious Maximus members will tip the sender some ETH for paying gas to end your stake.
1392 
1393     /**
1394      * @dev Ensures that the stake has not started yet and that the minting phase is over. Then it stakes all the hex in the contract and schedules the STAKE_END_DAY.
1395      * @notice This will trigger the start of the HEX stake. If you run this, you will pay the gas on behalf of the contract and you should not expect reimbursement.
1396      
1397      */
1398     function stakeHEX() nonReentrant external {
1399         require(HAS_STAKE_STARTED==false, "Stake has already been started.");
1400         uint256 current_day = hex_token.currentDay();
1401         require(current_day>MINTING_PHASE_END, "Minting Phase is still ongoing - see MINTING_PHASE_END day.");
1402         uint256 amount = hex_contract.balanceOf(address(this)); 
1403         _stakeHEX(amount);
1404         HAS_STAKE_STARTED=true;
1405         STAKE_START_DAY=current_day;
1406         STAKE_END_DAY=current_day+STAKE_LENGTH;
1407     }
1408     function _stakeHEX(uint256 amount) private  {
1409         hex_token.stakeStart(amount,STAKE_LENGTH);
1410         }
1411     
1412     function _endStakeHEX(uint256 stakeIndex,uint40 stakeIdParam ) private  {
1413         hex_token.stakeEnd(stakeIndex, stakeIdParam);
1414         }
1415     /**
1416      * @dev Ensures that the stake is fully complete and that it has not already been ended. Then it ends the hex stake and updates the redemption rate.
1417      * @notice This will trigger the ending of the HEX stake and calculate the new redemption rate. This may be very expensive. If you run this, you will pay the gas on behalf of the contract and you should not expect reimbursement.
1418      * @param stakeIndex index of stake found in stakeLists[contract_address] in hex contract.
1419      * @param stakeIdParam stake identifier found in stakeLists[contract_address] in hex contract.
1420      */
1421     function endStakeHEX(uint256 stakeIndex,uint40 stakeIdParam ) nonReentrant external {
1422         require(hex_token.currentDay()>STAKE_END_DAY, "Stake is not complete yet.");
1423         require(HAS_STAKE_STARTED==true && HAS_STAKE_ENDED==false, "Stake has already been started.");
1424         _endStakeHEX(stakeIndex, stakeIdParam);
1425         HAS_STAKE_ENDED=true;
1426         uint256 hex_balance = hex_contract.balanceOf(address(this));
1427         uint256 total_maxi_supply = IERC20(address(this)).totalSupply();
1428         HEX_REDEMPTION_RATE  = calculate_redemption_rate(hex_balance, total_maxi_supply);
1429         END_STAKER=msg.sender;
1430     }
1431     /**
1432      * @dev Calculates the pro-rata redemption rate of any coin per maxi. Scales value by 10^8 to handle integer rounding.
1433      * @param treasury_balance The balance of coins in the maximus contract address (either HEX or HEDRON)
1434      * @param maxi_supply total maxi supply
1435      * @return redemption_rate Number of units redeemable per 10^8 decimal units of MAXI. Is scaled back down by 10^8 on redemption transaction.
1436      */
1437     function calculate_redemption_rate(uint treasury_balance, uint maxi_supply) private view returns (uint redemption_rate) {
1438         uint256 scalar = 10**8;
1439         uint256 scaled = (treasury_balance * scalar) / maxi_supply; // scale value to calculate redemption amount per maxi and then divide by same scalar after multiplication
1440         return scaled;
1441     }
1442     
1443     /**
1444      * @dev Public function which calls the private function which is used for minting available HDRN accumulated by the contract stake. 
1445      * @notice This will trigger the minting of the mintable Hedron earned by the stake. If you run this, you will pay the gas on behalf of the contract and you should not expect reimbursement. If check to make sure this has not been run yet already or the transaction will fail.
1446      * @param stakeIndex index of stake found in stakeLists[contract_address] in hex contract.
1447      * @param stakeId stake identifier found in stakeLists[contract_address] in hex contract.
1448      */
1449   function mintHedron(uint256 stakeIndex,uint40 stakeId ) external  {
1450       _mintHedron(stakeIndex, stakeId);
1451         }
1452    /**
1453      * @dev Private function used for minting available HDRN accumulated by the contract stake and updating the HDRON redemption rate.
1454      * @param stakeIndex index of stake found in stakeLists[contract_address] in hex contract.
1455      * @param stakeId stake identifier found in stakeLists[contract_address] in hex contract.
1456      */
1457   function _mintHedron(uint256 stakeIndex,uint40 stakeId ) private  {
1458         hedron_token.mintNative(stakeIndex, stakeId);
1459         uint256 total_hedron= hedron_contract.balanceOf(address(this));
1460         uint256 total_maxi = IERC20(address(this)).totalSupply();
1461         
1462         HEDRON_REDEMPTION_RATE = calculate_redemption_rate(total_hedron, total_maxi);
1463         HAS_HEDRON_MINTED = true;
1464         }
1465 
1466 }