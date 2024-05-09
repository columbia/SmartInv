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
300 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
301 
302 pragma solidity ^0.8.0;
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
324      */
325     function isContract(address account) internal view returns (bool) {
326         // This method relies on extcodesize, which returns 0 for contracts in
327         // construction, since the code is only stored at the end of the
328         // constructor execution.
329 
330         uint256 size;
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 
337     /**
338      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
339      * `recipient`, forwarding all available gas and reverting on errors.
340      *
341      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
342      * of certain opcodes, possibly making contracts go over the 2300 gas limit
343      * imposed by `transfer`, making them unable to receive funds via
344      * `transfer`. {sendValue} removes this limitation.
345      *
346      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
347      *
348      * IMPORTANT: because control is transferred to `recipient`, care must be
349      * taken to not create reentrancy vulnerabilities. Consider using
350      * {ReentrancyGuard} or the
351      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
352      */
353     function sendValue(address payable recipient, uint256 amount) internal {
354         require(address(this).balance >= amount, "Address: insufficient balance");
355 
356         (bool success, ) = recipient.call{value: amount}("");
357         require(success, "Address: unable to send value, recipient may have reverted");
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain `call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
379         return functionCall(target, data, "Address: low-level call failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
384      * `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCall(
389         address target,
390         bytes memory data,
391         string memory errorMessage
392     ) internal returns (bytes memory) {
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
407     function functionCallWithValue(
408         address target,
409         bytes memory data,
410         uint256 value
411     ) internal returns (bytes memory) {
412         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
413     }
414 
415     /**
416      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
417      * with `errorMessage` as a fallback revert reason when `target` reverts.
418      *
419      * _Available since v3.1._
420      */
421     function functionCallWithValue(
422         address target,
423         bytes memory data,
424         uint256 value,
425         string memory errorMessage
426     ) internal returns (bytes memory) {
427         require(address(this).balance >= value, "Address: insufficient balance for call");
428         require(isContract(target), "Address: call to non-contract");
429 
430         (bool success, bytes memory returndata) = target.call{value: value}(data);
431         return verifyCallResult(success, returndata, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but performing a static call.
437      *
438      * _Available since v3.3._
439      */
440     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
441         return functionStaticCall(target, data, "Address: low-level static call failed");
442     }
443 
444     /**
445      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
446      * but performing a static call.
447      *
448      * _Available since v3.3._
449      */
450     function functionStaticCall(
451         address target,
452         bytes memory data,
453         string memory errorMessage
454     ) internal view returns (bytes memory) {
455         require(isContract(target), "Address: static call to non-contract");
456 
457         (bool success, bytes memory returndata) = target.staticcall(data);
458         return verifyCallResult(success, returndata, errorMessage);
459     }
460 
461     /**
462      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
463      * but performing a delegate call.
464      *
465      * _Available since v3.4._
466      */
467     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
468         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
469     }
470 
471     /**
472      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
473      * but performing a delegate call.
474      *
475      * _Available since v3.4._
476      */
477     function functionDelegateCall(
478         address target,
479         bytes memory data,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         require(isContract(target), "Address: delegate call to non-contract");
483 
484         (bool success, bytes memory returndata) = target.delegatecall(data);
485         return verifyCallResult(success, returndata, errorMessage);
486     }
487 
488     /**
489      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
490      * revert reason using the provided one.
491      *
492      * _Available since v4.3._
493      */
494     function verifyCallResult(
495         bool success,
496         bytes memory returndata,
497         string memory errorMessage
498     ) internal pure returns (bytes memory) {
499         if (success) {
500             return returndata;
501         } else {
502             // Look for revert reason and bubble it up if present
503             if (returndata.length > 0) {
504                 // The easiest way to bubble the revert reason is using memory via assembly
505 
506                 assembly {
507                     let returndata_size := mload(returndata)
508                     revert(add(32, returndata), returndata_size)
509                 }
510             } else {
511                 revert(errorMessage);
512             }
513         }
514     }
515 }
516 
517 // File: @openzeppelin/contracts/utils/Context.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Provides information about the current execution context, including the
526  * sender of the transaction and its data. While these are generally available
527  * via msg.sender and msg.data, they should not be accessed in such a direct
528  * manner, since when dealing with meta-transactions the account sending and
529  * paying for execution may not be the actual sender (as far as an application
530  * is concerned).
531  *
532  * This contract is only required for intermediate, library-like contracts.
533  */
534 abstract contract Context {
535     function _msgSender() internal view virtual returns (address) {
536         return msg.sender;
537     }
538 
539     function _msgData() internal view virtual returns (bytes calldata) {
540         return msg.data;
541     }
542 }
543 
544 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
545 
546 
547 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
548 
549 pragma solidity ^0.8.0;
550 
551 /**
552  * @dev Interface of the ERC20 standard as defined in the EIP.
553  */
554 interface IERC20 {
555     /**
556      * @dev Returns the amount of tokens in existence.
557      */
558     function totalSupply() external view returns (uint256);
559 
560     /**
561      * @dev Returns the amount of tokens owned by `account`.
562      */
563     function balanceOf(address account) external view returns (uint256);
564 
565     /**
566      * @dev Moves `amount` tokens from the caller's account to `recipient`.
567      *
568      * Returns a boolean value indicating whether the operation succeeded.
569      *
570      * Emits a {Transfer} event.
571      */
572     function transfer(address recipient, uint256 amount) external returns (bool);
573 
574     /**
575      * @dev Returns the remaining number of tokens that `spender` will be
576      * allowed to spend on behalf of `owner` through {transferFrom}. This is
577      * zero by default.
578      *
579      * This value changes when {approve} or {transferFrom} are called.
580      */
581     function allowance(address owner, address spender) external view returns (uint256);
582 
583     /**
584      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
585      *
586      * Returns a boolean value indicating whether the operation succeeded.
587      *
588      * IMPORTANT: Beware that changing an allowance with this method brings the risk
589      * that someone may use both the old and the new allowance by unfortunate
590      * transaction ordering. One possible solution to mitigate this race
591      * condition is to first reduce the spender's allowance to 0 and set the
592      * desired value afterwards:
593      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
594      *
595      * Emits an {Approval} event.
596      */
597     function approve(address spender, uint256 amount) external returns (bool);
598 
599     /**
600      * @dev Moves `amount` tokens from `sender` to `recipient` using the
601      * allowance mechanism. `amount` is then deducted from the caller's
602      * allowance.
603      *
604      * Returns a boolean value indicating whether the operation succeeded.
605      *
606      * Emits a {Transfer} event.
607      */
608     function transferFrom(
609         address sender,
610         address recipient,
611         uint256 amount
612     ) external returns (bool);
613 
614     /**
615      * @dev Emitted when `value` tokens are moved from one account (`from`) to
616      * another (`to`).
617      *
618      * Note that `value` may be zero.
619      */
620     event Transfer(address indexed from, address indexed to, uint256 value);
621 
622     /**
623      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
624      * a call to {approve}. `value` is the new allowance.
625      */
626     event Approval(address indexed owner, address indexed spender, uint256 value);
627 }
628 
629 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
630 
631 
632 // OpenZeppelin Contracts v4.4.1 (token/ERC20/utils/SafeERC20.sol)
633 
634 pragma solidity ^0.8.0;
635 
636 
637 
638 /**
639  * @title SafeERC20
640  * @dev Wrappers around ERC20 operations that throw on failure (when the token
641  * contract returns false). Tokens that return no value (and instead revert or
642  * throw on failure) are also supported, non-reverting calls are assumed to be
643  * successful.
644  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
645  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
646  */
647 library SafeERC20 {
648     using Address for address;
649 
650     function safeTransfer(
651         IERC20 token,
652         address to,
653         uint256 value
654     ) internal {
655         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
656     }
657 
658     function safeTransferFrom(
659         IERC20 token,
660         address from,
661         address to,
662         uint256 value
663     ) internal {
664         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
665     }
666 
667     /**
668      * @dev Deprecated. This function has issues similar to the ones found in
669      * {IERC20-approve}, and its usage is discouraged.
670      *
671      * Whenever possible, use {safeIncreaseAllowance} and
672      * {safeDecreaseAllowance} instead.
673      */
674     function safeApprove(
675         IERC20 token,
676         address spender,
677         uint256 value
678     ) internal {
679         // safeApprove should only be called when setting an initial allowance,
680         // or when resetting it to zero. To increase and decrease it, use
681         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
682         require(
683             (value == 0) || (token.allowance(address(this), spender) == 0),
684             "SafeERC20: approve from non-zero to non-zero allowance"
685         );
686         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
687     }
688 
689     function safeIncreaseAllowance(
690         IERC20 token,
691         address spender,
692         uint256 value
693     ) internal {
694         uint256 newAllowance = token.allowance(address(this), spender) + value;
695         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
696     }
697 
698     function safeDecreaseAllowance(
699         IERC20 token,
700         address spender,
701         uint256 value
702     ) internal {
703         unchecked {
704             uint256 oldAllowance = token.allowance(address(this), spender);
705             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
706             uint256 newAllowance = oldAllowance - value;
707             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
708         }
709     }
710 
711     /**
712      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
713      * on the return value: the return value is optional (but if data is returned, it must not be false).
714      * @param token The token targeted by the call.
715      * @param data The call data (encoded using abi.encode or one of its variants).
716      */
717     function _callOptionalReturn(IERC20 token, bytes memory data) private {
718         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
719         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
720         // the target address contains contract code and also asserts for success in the low-level call.
721 
722         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
723         if (returndata.length > 0) {
724             // Return data is optional
725             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
726         }
727     }
728 }
729 
730 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 
738 /**
739  * @dev Interface for the optional metadata functions from the ERC20 standard.
740  *
741  * _Available since v4.1._
742  */
743 interface IERC20Metadata is IERC20 {
744     /**
745      * @dev Returns the name of the token.
746      */
747     function name() external view returns (string memory);
748 
749     /**
750      * @dev Returns the symbol of the token.
751      */
752     function symbol() external view returns (string memory);
753 
754     /**
755      * @dev Returns the decimals places of the token.
756      */
757     function decimals() external view returns (uint8);
758 }
759 
760 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 
769 
770 /**
771  * @dev Implementation of the {IERC20} interface.
772  *
773  * This implementation is agnostic to the way tokens are created. This means
774  * that a supply mechanism has to be added in a derived contract using {_mint}.
775  * For a generic mechanism see {ERC20PresetMinterPauser}.
776  *
777  * TIP: For a detailed writeup see our guide
778  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
779  * to implement supply mechanisms].
780  *
781  * We have followed general OpenZeppelin Contracts guidelines: functions revert
782  * instead returning `false` on failure. This behavior is nonetheless
783  * conventional and does not conflict with the expectations of ERC20
784  * applications.
785  *
786  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
787  * This allows applications to reconstruct the allowance for all accounts just
788  * by listening to said events. Other implementations of the EIP may not emit
789  * these events, as it isn't required by the specification.
790  *
791  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
792  * functions have been added to mitigate the well-known issues around setting
793  * allowances. See {IERC20-approve}.
794  */
795 contract ERC20 is Context, IERC20, IERC20Metadata {
796     mapping(address => uint256) private _balances;
797 
798     mapping(address => mapping(address => uint256)) private _allowances;
799 
800     uint256 private _totalSupply;
801 
802     string private _name;
803     string private _symbol;
804 
805     /**
806      * @dev Sets the values for {name} and {symbol}.
807      *
808      * The default value of {decimals} is 18. To select a different value for
809      * {decimals} you should overload it.
810      *
811      * All two of these values are immutable: they can only be set once during
812      * construction.
813      */
814     constructor(string memory name_, string memory symbol_) {
815         _name = name_;
816         _symbol = symbol_;
817     }
818 
819     /**
820      * @dev Returns the name of the token.
821      */
822     function name() public view virtual override returns (string memory) {
823         return _name;
824     }
825 
826     /**
827      * @dev Returns the symbol of the token, usually a shorter version of the
828      * name.
829      */
830     function symbol() public view virtual override returns (string memory) {
831         return _symbol;
832     }
833 
834     /**
835      * @dev Returns the number of decimals used to get its user representation.
836      * For example, if `decimals` equals `2`, a balance of `505` tokens should
837      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
838      *
839      * Tokens usually opt for a value of 18, imitating the relationship between
840      * Ether and Wei. This is the value {ERC20} uses, unless this function is
841      * overridden;
842      *
843      * NOTE: This information is only used for _display_ purposes: it in
844      * no way affects any of the arithmetic of the contract, including
845      * {IERC20-balanceOf} and {IERC20-transfer}.
846      */
847     function decimals() public view virtual override returns (uint8) {
848         return 18;
849     }
850 
851     /**
852      * @dev See {IERC20-totalSupply}.
853      */
854     function totalSupply() public view virtual override returns (uint256) {
855         return _totalSupply;
856     }
857 
858     /**
859      * @dev See {IERC20-balanceOf}.
860      */
861     function balanceOf(address account) public view virtual override returns (uint256) {
862         return _balances[account];
863     }
864 
865     /**
866      * @dev See {IERC20-transfer}.
867      *
868      * Requirements:
869      *
870      * - `recipient` cannot be the zero address.
871      * - the caller must have a balance of at least `amount`.
872      */
873     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
874         _transfer(_msgSender(), recipient, amount);
875         return true;
876     }
877 
878     /**
879      * @dev See {IERC20-allowance}.
880      */
881     function allowance(address owner, address spender) public view virtual override returns (uint256) {
882         return _allowances[owner][spender];
883     }
884 
885     /**
886      * @dev See {IERC20-approve}.
887      *
888      * Requirements:
889      *
890      * - `spender` cannot be the zero address.
891      */
892     function approve(address spender, uint256 amount) public virtual override returns (bool) {
893         _approve(_msgSender(), spender, amount);
894         return true;
895     }
896 
897     /**
898      * @dev See {IERC20-transferFrom}.
899      *
900      * Emits an {Approval} event indicating the updated allowance. This is not
901      * required by the EIP. See the note at the beginning of {ERC20}.
902      *
903      * Requirements:
904      *
905      * - `sender` and `recipient` cannot be the zero address.
906      * - `sender` must have a balance of at least `amount`.
907      * - the caller must have allowance for ``sender``'s tokens of at least
908      * `amount`.
909      */
910     function transferFrom(
911         address sender,
912         address recipient,
913         uint256 amount
914     ) public virtual override returns (bool) {
915         _transfer(sender, recipient, amount);
916 
917         uint256 currentAllowance = _allowances[sender][_msgSender()];
918         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
919         unchecked {
920             _approve(sender, _msgSender(), currentAllowance - amount);
921         }
922 
923         return true;
924     }
925 
926     /**
927      * @dev Atomically increases the allowance granted to `spender` by the caller.
928      *
929      * This is an alternative to {approve} that can be used as a mitigation for
930      * problems described in {IERC20-approve}.
931      *
932      * Emits an {Approval} event indicating the updated allowance.
933      *
934      * Requirements:
935      *
936      * - `spender` cannot be the zero address.
937      */
938     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
939         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
940         return true;
941     }
942 
943     /**
944      * @dev Atomically decreases the allowance granted to `spender` by the caller.
945      *
946      * This is an alternative to {approve} that can be used as a mitigation for
947      * problems described in {IERC20-approve}.
948      *
949      * Emits an {Approval} event indicating the updated allowance.
950      *
951      * Requirements:
952      *
953      * - `spender` cannot be the zero address.
954      * - `spender` must have allowance for the caller of at least
955      * `subtractedValue`.
956      */
957     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
958         uint256 currentAllowance = _allowances[_msgSender()][spender];
959         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
960         unchecked {
961             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
962         }
963 
964         return true;
965     }
966 
967     /**
968      * @dev Moves `amount` of tokens from `sender` to `recipient`.
969      *
970      * This internal function is equivalent to {transfer}, and can be used to
971      * e.g. implement automatic token fees, slashing mechanisms, etc.
972      *
973      * Emits a {Transfer} event.
974      *
975      * Requirements:
976      *
977      * - `sender` cannot be the zero address.
978      * - `recipient` cannot be the zero address.
979      * - `sender` must have a balance of at least `amount`.
980      */
981     function _transfer(
982         address sender,
983         address recipient,
984         uint256 amount
985     ) internal virtual {
986         require(sender != address(0), "ERC20: transfer from the zero address");
987         require(recipient != address(0), "ERC20: transfer to the zero address");
988 
989         _beforeTokenTransfer(sender, recipient, amount);
990 
991         uint256 senderBalance = _balances[sender];
992         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
993         unchecked {
994             _balances[sender] = senderBalance - amount;
995         }
996         _balances[recipient] += amount;
997 
998         emit Transfer(sender, recipient, amount);
999 
1000         _afterTokenTransfer(sender, recipient, amount);
1001     }
1002 
1003     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1004      * the total supply.
1005      *
1006      * Emits a {Transfer} event with `from` set to the zero address.
1007      *
1008      * Requirements:
1009      *
1010      * - `account` cannot be the zero address.
1011      */
1012     function _mint(address account, uint256 amount) internal virtual {
1013         require(account != address(0), "ERC20: mint to the zero address");
1014 
1015         _beforeTokenTransfer(address(0), account, amount);
1016 
1017         _totalSupply += amount;
1018         _balances[account] += amount;
1019         emit Transfer(address(0), account, amount);
1020 
1021         _afterTokenTransfer(address(0), account, amount);
1022     }
1023 
1024     /**
1025      * @dev Destroys `amount` tokens from `account`, reducing the
1026      * total supply.
1027      *
1028      * Emits a {Transfer} event with `to` set to the zero address.
1029      *
1030      * Requirements:
1031      *
1032      * - `account` cannot be the zero address.
1033      * - `account` must have at least `amount` tokens.
1034      */
1035     function _burn(address account, uint256 amount) internal virtual {
1036         require(account != address(0), "ERC20: burn from the zero address");
1037 
1038         _beforeTokenTransfer(account, address(0), amount);
1039 
1040         uint256 accountBalance = _balances[account];
1041         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1042         unchecked {
1043             _balances[account] = accountBalance - amount;
1044         }
1045         _totalSupply -= amount;
1046 
1047         emit Transfer(account, address(0), amount);
1048 
1049         _afterTokenTransfer(account, address(0), amount);
1050     }
1051 
1052     /**
1053      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1054      *
1055      * This internal function is equivalent to `approve`, and can be used to
1056      * e.g. set automatic allowances for certain subsystems, etc.
1057      *
1058      * Emits an {Approval} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `owner` cannot be the zero address.
1063      * - `spender` cannot be the zero address.
1064      */
1065     function _approve(
1066         address owner,
1067         address spender,
1068         uint256 amount
1069     ) internal virtual {
1070         require(owner != address(0), "ERC20: approve from the zero address");
1071         require(spender != address(0), "ERC20: approve to the zero address");
1072 
1073         _allowances[owner][spender] = amount;
1074         emit Approval(owner, spender, amount);
1075     }
1076 
1077     /**
1078      * @dev Hook that is called before any transfer of tokens. This includes
1079      * minting and burning.
1080      *
1081      * Calling conditions:
1082      *
1083      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1084      * will be transferred to `to`.
1085      * - when `from` is zero, `amount` tokens will be minted for `to`.
1086      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1087      * - `from` and `to` are never both zero.
1088      *
1089      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1090      */
1091     function _beforeTokenTransfer(
1092         address from,
1093         address to,
1094         uint256 amount
1095     ) internal virtual {}
1096 
1097     /**
1098      * @dev Hook that is called after any transfer of tokens. This includes
1099      * minting and burning.
1100      *
1101      * Calling conditions:
1102      *
1103      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1104      * has been transferred to `to`.
1105      * - when `from` is zero, `amount` tokens have been minted for `to`.
1106      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1107      * - `from` and `to` are never both zero.
1108      *
1109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1110      */
1111     function _afterTokenTransfer(
1112         address from,
1113         address to,
1114         uint256 amount
1115     ) internal virtual {}
1116 }
1117 
1118 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1119 
1120 
1121 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
1122 
1123 pragma solidity ^0.8.0;
1124 
1125 
1126 
1127 /**
1128  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1129  * tokens and those that they have an allowance for, in a way that can be
1130  * recognized off-chain (via event analysis).
1131  */
1132 abstract contract ERC20Burnable is Context, ERC20 {
1133     /**
1134      * @dev Destroys `amount` tokens from the caller.
1135      *
1136      * See {ERC20-_burn}.
1137      */
1138     function burn(uint256 amount) public virtual {
1139         _burn(_msgSender(), amount);
1140     }
1141 
1142     /**
1143      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1144      * allowance.
1145      *
1146      * See {ERC20-_burn} and {ERC20-allowance}.
1147      *
1148      * Requirements:
1149      *
1150      * - the caller must have allowance for ``accounts``'s tokens of at least
1151      * `amount`.
1152      */
1153     function burnFrom(address account, uint256 amount) public virtual {
1154         uint256 currentAllowance = allowance(account, _msgSender());
1155         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1156         unchecked {
1157             _approve(account, _msgSender(), currentAllowance - amount);
1158         }
1159         _burn(account, amount);
1160     }
1161 }
1162 
1163 // File: contracts/PerpetualPool.sol
1164 
1165 //SPDX-License-Identifier: UNLICENSED
1166 pragma solidity ^0.8.2;
1167 
1168 
1169 
1170 
1171 
1172 
1173 
1174 
1175 contract HedronToken {
1176   function approve(address spender, uint256 amount) external returns (bool) {}
1177   function transfer(address recipient, uint256 amount) external returns (bool) {}
1178   function mintNative(uint256 stakeIndex, uint40 stakeId) external returns (uint256) {}
1179   function claimNative(uint256 stakeIndex, uint40 stakeId) external returns (uint256) {}
1180   function currentDay() external view returns (uint256) {}
1181 }
1182 
1183 contract HEXToken {
1184   function currentDay() external view returns (uint256){}
1185   function stakeStart(uint256 newStakedHearts, uint256 newStakedDays) external {}
1186   function approve(address spender, uint256 amount) external returns (bool) {}
1187   function transfer(address recipient, uint256 amount) public returns (bool) {}
1188   function stakeEnd(uint256 stakeIndex, uint40 stakeIdParam) public {}
1189   function stakeCount(address stakerAddr) external view returns (uint256) {}
1190 }
1191 /*
1192  /$$      /$$                     /$$                                         /$$$$$$$$ /$$$$$$$$  /$$$$$$  /$$      /$$
1193 | $$$    /$$$                    |__/                                        |__  $$__/| $$_____/ /$$__  $$| $$$    /$$$
1194 | $$$$  /$$$$  /$$$$$$  /$$   /$$ /$$ /$$$$$$/$$$$  /$$   /$$  /$$$$$$$         | $$   | $$      | $$  \ $$| $$$$  /$$$$
1195 | $$ $$/$$ $$ |____  $$|  $$ /$$/| $$| $$_  $$_  $$| $$  | $$ /$$_____/         | $$   | $$$$$   | $$$$$$$$| $$ $$/$$ $$
1196 | $$  $$$| $$  /$$$$$$$ \  $$$$/ | $$| $$ \ $$ \ $$| $$  | $$|  $$$$$$          | $$   | $$__/   | $$__  $$| $$  $$$| $$
1197 | $$\  $ | $$ /$$__  $$  >$$  $$ | $$| $$ | $$ | $$| $$  | $$ \____  $$         | $$   | $$      | $$  | $$| $$\  $ | $$
1198 | $$ \/  | $$|  $$$$$$$ /$$/\  $$| $$| $$ | $$ | $$|  $$$$$$/ /$$$$$$$/         | $$   | $$$$$$$$| $$  | $$| $$ \/  | $$
1199 |__/     |__/ \_______/|__/  \__/|__/|__/ |__/ |__/ \______/ |_______/          |__/   |________/|__/  |__/|__/     |__/
1200                                                                                                                         
1201                                                                                                                         
1202                                                                                                                         
1203                            /$$         /$$     /$$                                                                      
1204                           | $$        | $$    | $$                                                                      
1205   /$$$$$$  /$$$$$$$   /$$$$$$$       /$$$$$$  | $$$$$$$   /$$$$$$                                                       
1206  |____  $$| $$__  $$ /$$__  $$      |_  $$_/  | $$__  $$ /$$__  $$                                                      
1207   /$$$$$$$| $$  \ $$| $$  | $$        | $$    | $$  \ $$| $$$$$$$$                                                      
1208  /$$__  $$| $$  | $$| $$  | $$        | $$ /$$| $$  | $$| $$_____/                                                      
1209 |  $$$$$$$| $$  | $$|  $$$$$$$        |  $$$$/| $$  | $$|  $$$$$$$                                                      
1210  \_______/|__/  |__/ \_______/         \___/  |__/  |__/ \_______/                                                      
1211                                                                                                                         
1212                                                                                                                         
1213                                                                                                                         
1214  /$$$$$$$                                           /$$                         /$$                                     
1215 | $$__  $$                                         | $$                        | $$                                     
1216 | $$  \ $$ /$$$$$$   /$$$$$$   /$$$$$$   /$$$$$$  /$$$$$$   /$$   /$$  /$$$$$$ | $$  /$$$$$$$                           
1217 | $$$$$$$//$$__  $$ /$$__  $$ /$$__  $$ /$$__  $$|_  $$_/  | $$  | $$ |____  $$| $$ /$$_____/                           
1218 | $$____/| $$$$$$$$| $$  \__/| $$  \ $$| $$$$$$$$  | $$    | $$  | $$  /$$$$$$$| $$|  $$$$$$                            
1219 | $$     | $$_____/| $$      | $$  | $$| $$_____/  | $$ /$$| $$  | $$ /$$__  $$| $$ \____  $$                           
1220 | $$     |  $$$$$$$| $$      | $$$$$$$/|  $$$$$$$  |  $$$$/|  $$$$$$/|  $$$$$$$| $$ /$$$$$$$/                           
1221 |__/      \_______/|__/      | $$____/  \_______/   \___/   \______/  \_______/|__/|_______/                            
1222                              | $$                                                                                       
1223                              | $$                                                                                       
1224                              |__/                                                                                      
1225 
1226 
1227 // Anyone may choose to mint 1 Perpetual Pool Token per HEX pledged to the Perpetual Pool Contract during the minting phase.
1228 // Pool Tokens are a standard ERC20 token, only minted upon HEX deposit and burnt upon HEX redemption with no pre-mine.
1229 // Pool Token holders may choose to burn their Pool Tokens to redeem HEX principal and yield pro-rata from the Pool Token Contract Address during the reload phase.
1230 // The Perpetual Pools start with an initial minting phase, followed by a stake phase. Then once the HEX stake has ended they enter a reload phase where HEX may be redeemed with Pool Tokens or Pool Tokens may be minted with HEX - all at the same redemption rate.
1231 // Then after the reload phase ends another Stake Phase begins and the cycle repeats forever.
1232 
1233 
1234 // PHASES:        |----- Minting Phase ----|------ Stake Phase -----...-----|---- Reload Phase ----->|----- Stake Phase ------|----> REPEAT FOREVER
1235 // WHAT HAPPENS?  |       Mint and redeem  |    No Minting or Redeeming     |   Mint and redeem      | No Minting or Redeeming|---->
1236 // FUNCTIONS USED:| pledgeHEX(),redeemHEX()|      mintHedron()              | pledgeHEX(),redeemHEX()|      mintHedron().     |
1237 // TRANSITION FUNCTION:       stakeStart() ^                  endStakeHex() ^           stakeStart() ^          endStakeHex() ^ 
1238 
1239 // The Pool Contracts send half of it's Bigger Pays Better Bonus HEX Yield and all of the HDRN the stake accumulated to the Maximus TEAM Contract as a thank you for deploying the pools and an incentive to grow the stake pooling economy.
1240 
1241 
1242 
1243 THE PERPETUAL POOLS CONTRACTS, SUPPORTING WEBSITES, AND ALL OTHER INTERFACES (THE SOFTWARE) IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
1244 LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
1245 
1246 BY INTERACTING WITH THE SOFTWARE YOU ARE ASSERTING THAT YOU BEAR ALL THE RISKS ASSOCIATED WITH DOING SO. AN INFINITE NUMBER OF UNPREDICTABLE THINGS MAY GO WRONG WHICH COULD POTENTIALLY RESULT IN CRITICAL FAILURE AND FINANCIAL LOSS. BY INTERACTING WITH THE SOFTWARE YOU ARE ASSERTING THAT YOU AGREE THERE IS NO RECOURSE AVAILABLE AND YOU WILL NOT SEEK IT.
1247 
1248 INTERACTING WITH THE SOFTWARE SHALL NOT BE CONSIDERED AN INVESTMENT OR A COMMON ENTERPRISE. INSTEAD, INTERACTING WITH THE SOFTWARE IS EQUIVALENT TO CARPOOLING WITH FRIENDS TO SAVE ON GAS AND EXPERIENCE THE BENEFITS OF THE H.O.V. LANE. 
1249 
1250 YOU SHALL HAVE NO EXPECTATION OF PROFIT OR ANY TYPE OF GAIN FROM THE WORK OF OTHER PEOPLE.
1251 
1252 */
1253 
1254 
1255 contract PerpetualPool is ERC20, ERC20Burnable, ReentrancyGuard {
1256     // all days are measured in terms of the HEX contract day number
1257     uint256 public RELOAD_PHASE_DURATION; // How many days are between each stake
1258     uint256 public RELOAD_PHASE_START; // the day when the current reload phase starts, is updated as each stake ends
1259     uint256 public RELOAD_PHASE_END; // the day when the current reload phase ends, is updated as each stake ends
1260     uint256 public STAKE_START_DAY; // the day when the current stake starts, is updated as each stake starts
1261     uint256 public STAKE_END_DAY; // the day when the current stake ends, is updated as each stake starts
1262     uint256 public STAKE_LENGTH; // length of the stake
1263     uint256 public HEX_REDEMPTION_RATE; // Number of HEX units redeemable per Perpetual Pool Token and the number of HEX required to mint a new Perpetual Pool Token after a stake ends
1264     bool public STAKE_IS_ACTIVE; // Used to keep track of whether or not the HEX stake is active. Is TRUE during stake phases and FALSE during reload ohases
1265     address public END_STAKER; // Address who paid the gas to end the stake
1266     address public TEAM_CONTRACT_ADDRESS;
1267     uint256 public CURRENT_STAKE_PRINCIPAL; // Principal of current stake, updated whenever a stake starts and reset to zero when a stake ends.
1268     uint256 public CURRENT_PERIOD; // even numbers are Reload Period, odd numbers are staking periods.
1269 
1270     
1271     constructor(uint256 initial_mint_duration, uint256 stake_duration, uint256 reload_duration,address team_address, string memory name, string memory ticker) ERC20(name, ticker) ReentrancyGuard() {
1272         RELOAD_PHASE_DURATION=reload_duration;
1273         uint256 start_day=hex_token.currentDay();
1274         RELOAD_PHASE_START = start_day;
1275         RELOAD_PHASE_END = start_day+initial_mint_duration; // The initial RELOAD PHASE may be set to be different than the ongoing reload phases.
1276         STAKE_LENGTH=stake_duration; 
1277         STAKE_IS_ACTIVE=false;
1278         TEAM_CONTRACT_ADDRESS=team_address;
1279         HEX_REDEMPTION_RATE=100000000; // HEX and MINI are 1:1 convertible during first minting/redemption phase. Then this will scale based on treasury value.
1280         CURRENT_STAKE_PRINCIPAL=0;
1281         CURRENT_PERIOD=0;
1282     }
1283     
1284     address POOL_ADDRESS =address(this);
1285     address constant HEX_ADDRESS = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39; // "2b, 5 9 1e? that is the question..."
1286     address constant HEDRON_ADDRESS=0x3819f64f282bf135d62168C1e513280dAF905e06; 
1287 
1288     IERC20 hex_contract = IERC20(HEX_ADDRESS);
1289     IERC20 hedron_contract=IERC20(HEDRON_ADDRESS);
1290     HEXToken hex_token = HEXToken(HEX_ADDRESS);
1291     HedronToken hedron_token = HedronToken(HEDRON_ADDRESS);
1292     
1293     /**
1294     * @dev View number of decimal places the Pool Token is divisible to. Manually overwritten from default 18 to 8 to match that of HEX. 1 Pool Token = 10^8 mini
1295     */
1296     function decimals() public view virtual override returns (uint8) {return 8;}
1297 
1298     /**
1299     * @dev Returns the current Period. Even numbers are Reload Phases, Odd numbers are staking phases."
1300     * @return Current Period
1301     */
1302     function getCurrentPeriod() external view returns (uint256){
1303         return CURRENT_PERIOD;
1304     }
1305     // @dev Returns the current day from the hex contract.
1306     function getHexDay() external view returns (uint256){
1307         uint256 day = hex_token.currentDay();
1308         return day;
1309     }
1310 
1311      /**
1312     * @dev Returns the address of the person who ends stake. May be used by external gas pooling contracts. If stake has not been ended yet will return 0x000...000"
1313     * @return end_staker_address This person should be honored and celebrated as a hero.
1314     */
1315     function getEndStaker() external view returns (address end_staker_address) {return END_STAKER;}
1316 
1317     // Pool Token Issuance and Redemption Functions
1318     /**
1319      * @dev Mints Pool Token.
1320      * @param amount of Pool Tokens to mint, measured in minis
1321      */
1322     function mint(uint256 amount) private {
1323         _mint(msg.sender, amount);
1324     }
1325      /**
1326      * @dev Ensures that Pool Token Minting Phase is ongoing and that the user has allowed the Perpetual Pool Contract address to spend the amount of HEX the user intends to pledge to The Perpetual Pool. Then sends the designated HEX from the user to the Perpetual Pool Contract address and mints 1 Pool Token per HEX pledged.
1327      * @param amount of HEX user chose to pledge, measured in hearts
1328      */
1329     function pledgeHEX(uint256 amount) nonReentrant external {
1330         require(STAKE_IS_ACTIVE==false, "Minting may only be done if a stake is not active");
1331         require(hex_token.currentDay()<=RELOAD_PHASE_END, "Minting Phase is Done");
1332         require(hex_contract.allowance(msg.sender, POOL_ADDRESS)>=amount, "Please approve contract address as allowed spender in the hex contract.");
1333         address from = msg.sender;
1334         hex_contract.transferFrom(from, POOL_ADDRESS, amount);
1335         uint256 mintable_amount = (10**8)*amount/HEX_REDEMPTION_RATE;
1336         mint(mintable_amount);
1337     }
1338      /**
1339      * @dev Ensures that it is currently a redemption period (before stake starts or after stake ends) and that the user has at least the number of Pool Tokens they entered. Then it calculates how much hex may be redeemed, burns the Pool Token, and transfers them the hex.
1340      * @param amount number of Pool Tokens that the user is redeeming, measured in mini
1341      */
1342     function redeemHEX(uint256 amount) nonReentrant external {
1343         require(STAKE_IS_ACTIVE==false, "Redemption can not happen while stake is active");
1344         uint256 your_balance = balanceOf(msg.sender);
1345         require(your_balance>=amount, "You do not have that much of the Pool Token.");
1346         uint256 raw_redeemable_amount = amount*HEX_REDEMPTION_RATE;
1347         uint256 redeemable_amount = raw_redeemable_amount/(10**8); //scaled back down to handle integer rounding
1348         burn(amount);
1349         hex_token.transfer(msg.sender, redeemable_amount);
1350         
1351     }
1352     //Staking Functions
1353     // Anyone may run these functions during the allowed time, so long as they pay the gas.
1354     // While nothing is forcing you to, gracious Perpetual Pool members will tip the sender some ETH for paying gas to end your stake.
1355 
1356     /**
1357      * @dev Ensures that the stake has not started yet and that the minting phase is over. Then it stakes all the hex in the contract and schedules the STAKE_END_DAY.
1358      * @notice This will trigger the start of the HEX stake. If you run this, you will pay the gas on behalf of the contract and you should not expect reimbursement.
1359      
1360      */
1361     function stakeHEX() nonReentrant external {
1362         require(STAKE_IS_ACTIVE==false, "Stake has already started.");
1363         uint256 current_day = hex_token.currentDay();
1364         require(current_day>RELOAD_PHASE_END, "Minting Phase is still ongoing - see RELOAD_PHASE_END day.");
1365         uint256 amount = hex_contract.balanceOf(address(this));
1366         _stakeHEX(amount);
1367         CURRENT_STAKE_PRINCIPAL=amount;
1368         STAKE_START_DAY=current_day;
1369         STAKE_END_DAY=current_day+STAKE_LENGTH;
1370         STAKE_IS_ACTIVE=true;
1371         CURRENT_PERIOD = CURRENT_PERIOD+1;
1372     }
1373     function _stakeHEX(uint256 amount) private  {
1374         hex_token.stakeStart(amount,STAKE_LENGTH);
1375         }
1376     
1377     function _endStakeHEX(uint256 stakeIndex,uint40 stakeIdParam ) private  {
1378         hex_token.stakeEnd(stakeIndex, stakeIdParam);
1379         }
1380     /**
1381      * @dev Ensures that the stake is fully complete and that it has not already been ended. Then it ends the hex stake and updates the redemption rate.
1382      * @notice This will trigger the ending of the HEX stake and calculate the new redemption rate. This may be very expensive. If you run this, you will pay the gas on behalf of the contract and you should not expect reimbursement.
1383      * @param stakeIndex index of stake found in stakeLists[contract_address] in hex contract.
1384      * @param stakeIdParam stake identifier found in stakeLists[contract_address] in hex contract.
1385      */
1386     function endStakeHEX(uint256 stakeIndex,uint40 stakeIdParam ) nonReentrant external {
1387         require(hex_token.currentDay()>STAKE_END_DAY, "Stake is not complete yet.");
1388         require(STAKE_IS_ACTIVE==true, "Stake must be active.");
1389         _endStakeHEX(stakeIndex, stakeIdParam);
1390         uint256 hex_balance = hex_contract.balanceOf(address(this));
1391         uint256 bpb_bonus_sharing_amount = get_bonus_sharing_amount(CURRENT_STAKE_PRINCIPAL, hex_balance,STAKE_LENGTH);
1392         hex_token.transfer(TEAM_CONTRACT_ADDRESS, bpb_bonus_sharing_amount);
1393         hedron_token.transfer(TEAM_CONTRACT_ADDRESS,hedron_contract.balanceOf(address(this)));
1394         uint256 total_supply = IERC20(address(this)).totalSupply();
1395         HEX_REDEMPTION_RATE  = calculate_redemption_rate(hex_contract.balanceOf(address(this)), total_supply);
1396         END_STAKER=msg.sender;
1397         CURRENT_STAKE_PRINCIPAL=0;
1398         STAKE_IS_ACTIVE=false;
1399         RELOAD_PHASE_START=hex_token.currentDay();
1400         RELOAD_PHASE_END=RELOAD_PHASE_START+RELOAD_PHASE_DURATION;
1401         CURRENT_PERIOD = CURRENT_PERIOD+1;
1402          
1403         
1404     }
1405 
1406     //@dev This calculates the amount of HEX to send to the Maximus TEAM Contract. See HEX Staking Bonuses for Details about BPB and LPB Bonuses
1407     function get_bonus_sharing_amount(uint256 principal,uint256 end_value, uint256 stake_length) private pure returns(uint256) {
1408         
1409         
1410         uint256 bpb_effective_hex;
1411         
1412         uint256 bpb_threshold = 150000000*(10**8);
1413         if (principal>bpb_threshold) {
1414             bpb_effective_hex = principal/10;
1415         }
1416         else {
1417             uint256 scaled_bpb_multiplier = (((10**8)*(principal))/(10*bpb_threshold));
1418             bpb_effective_hex = principal * (scaled_bpb_multiplier)/(10**8);
1419         }   
1420         uint256 lpb_effective_hex;
1421         uint256 scaled_lpb_multiplier;
1422         uint256 lpb_threshold = 3650;
1423         if (stake_length>lpb_threshold) {
1424             scaled_lpb_multiplier = 2*(10**8);
1425         }
1426         else {
1427             scaled_lpb_multiplier = 2*((10**8)*(stake_length))/lpb_threshold;
1428             
1429         }   
1430         lpb_effective_hex = principal * (scaled_lpb_multiplier)/(10**8);
1431         uint256 scalar = 10**8;
1432         uint256 earnings = end_value-principal;
1433         uint256 bpb_makeup_scaled = (scalar * bpb_effective_hex)/(bpb_effective_hex+principal+lpb_effective_hex);
1434         uint256 bpb_earnings_scaled = earnings *bpb_makeup_scaled;
1435         uint256 bpb_earnings = bpb_earnings_scaled/scalar;
1436         return bpb_earnings/2;
1437 
1438     }
1439     /**
1440      * @dev Calculates the pro-rata redemption rate of any coin per Pool Token. Scales value by 10^8 to handle integer rounding.
1441      * @param treasury_balance The balance of coins in contract address (either HEX or HEDRON)
1442      * @param token_supply total Pool Token supply
1443      * @return redemption_rate Number of units redeemable per 10^8 decimal units of Pool Tokens. Is scaled back down by 10^8 on redemption transaction.
1444      */
1445     function calculate_redemption_rate(uint treasury_balance, uint token_supply) private pure returns (uint redemption_rate) {
1446         uint256 scalar = 10**8;
1447         uint256 scaled = (treasury_balance * scalar) / token_supply; // scale value to calculate redemption amount per Pool Token and then divide by same scalar after multiplication
1448         return scaled;
1449     }
1450     
1451     /**
1452      * @dev Public function which calls the private function which is used for minting available HDRN accumulated by the contract stake. 
1453      * @notice This will trigger the minting of the mintable Hedron earned by the stake. If you run this, you will pay the gas on behalf of the contract and you should not expect reimbursement. If check to make sure this has not been run yet already or the transaction will fail.
1454      * @param stakeIndex index of stake found in stakeLists[contract_address] in hex contract.
1455      * @param stakeId stake identifier found in stakeLists[contract_address] in hex contract.
1456      */
1457   function mintHedron(uint256 stakeIndex,uint40 stakeId ) external  {
1458       _mintHedron(stakeIndex, stakeId);
1459         }
1460    /**
1461      * @dev Private function used for minting available HDRN accumulated by the contract stake.
1462      * @param stakeIndex index of stake found in stakeLists[contract_address] in hex contract.
1463      * @param stakeId stake identifier found in stakeLists[contract_address] in hex contract.
1464      */
1465   function _mintHedron(uint256 stakeIndex,uint40 stakeId ) private  {
1466         hedron_token.mintNative(stakeIndex, stakeId);
1467         }
1468 }