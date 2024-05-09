1 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/Address.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
235 
236 pragma solidity ^0.8.1;
237 
238 /**
239  * @dev Collection of functions related to the address type
240  */
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      *
259      * [IMPORTANT]
260      * ====
261      * You shouldn't rely on `isContract` to protect against flash loan attacks!
262      *
263      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
264      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
265      * constructor.
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // This method relies on extcodesize/address.code.length, which returns 0
270         // for contracts in construction, since the code is only stored at the end
271         // of the constructor execution.
272 
273         return account.code.length > 0;
274     }
275 
276     /**
277      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
278      * `recipient`, forwarding all available gas and reverting on errors.
279      *
280      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
281      * of certain opcodes, possibly making contracts go over the 2300 gas limit
282      * imposed by `transfer`, making them unable to receive funds via
283      * `transfer`. {sendValue} removes this limitation.
284      *
285      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
286      *
287      * IMPORTANT: because control is transferred to `recipient`, care must be
288      * taken to not create reentrancy vulnerabilities. Consider using
289      * {ReentrancyGuard} or the
290      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
291      */
292     function sendValue(address payable recipient, uint256 amount) internal {
293         require(address(this).balance >= amount, "Address: insufficient balance");
294 
295         (bool success, ) = recipient.call{value: amount}("");
296         require(success, "Address: unable to send value, recipient may have reverted");
297     }
298 
299     /**
300      * @dev Performs a Solidity function call using a low level `call`. A
301      * plain `call` is an unsafe replacement for a function call: use this
302      * function instead.
303      *
304      * If `target` reverts with a revert reason, it is bubbled up by this
305      * function (like regular Solidity function calls).
306      *
307      * Returns the raw returned data. To convert to the expected return value,
308      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
309      *
310      * Requirements:
311      *
312      * - `target` must be a contract.
313      * - calling `target` with `data` must not revert.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
318         return functionCall(target, data, "Address: low-level call failed");
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
323      * `errorMessage` as a fallback revert reason when `target` reverts.
324      *
325      * _Available since v3.1._
326      */
327     function functionCall(
328         address target,
329         bytes memory data,
330         string memory errorMessage
331     ) internal returns (bytes memory) {
332         return functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(
347         address target,
348         bytes memory data,
349         uint256 value
350     ) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(
361         address target,
362         bytes memory data,
363         uint256 value,
364         string memory errorMessage
365     ) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         require(isContract(target), "Address: call to non-contract");
368 
369         (bool success, bytes memory returndata) = target.call{value: value}(data);
370         return verifyCallResult(success, returndata, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but performing a static call.
376      *
377      * _Available since v3.3._
378      */
379     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
380         return functionStaticCall(target, data, "Address: low-level static call failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
385      * but performing a static call.
386      *
387      * _Available since v3.3._
388      */
389     function functionStaticCall(
390         address target,
391         bytes memory data,
392         string memory errorMessage
393     ) internal view returns (bytes memory) {
394         require(isContract(target), "Address: static call to non-contract");
395 
396         (bool success, bytes memory returndata) = target.staticcall(data);
397         return verifyCallResult(success, returndata, errorMessage);
398     }
399 
400     /**
401      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
402      * but performing a delegate call.
403      *
404      * _Available since v3.4._
405      */
406     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
407         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
408     }
409 
410     /**
411      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
412      * but performing a delegate call.
413      *
414      * _Available since v3.4._
415      */
416     function functionDelegateCall(
417         address target,
418         bytes memory data,
419         string memory errorMessage
420     ) internal returns (bytes memory) {
421         require(isContract(target), "Address: delegate call to non-contract");
422 
423         (bool success, bytes memory returndata) = target.delegatecall(data);
424         return verifyCallResult(success, returndata, errorMessage);
425     }
426 
427     /**
428      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
429      * revert reason using the provided one.
430      *
431      * _Available since v4.3._
432      */
433     function verifyCallResult(
434         bool success,
435         bytes memory returndata,
436         string memory errorMessage
437     ) internal pure returns (bytes memory) {
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 assembly {
446                     let returndata_size := mload(returndata)
447                     revert(add(32, returndata), returndata_size)
448                 }
449             } else {
450                 revert(errorMessage);
451             }
452         }
453     }
454 }
455 
456 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
457 
458 
459 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 /**
464  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
465  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
466  *
467  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
468  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
469  * need to send a transaction, and thus is not required to hold Ether at all.
470  */
471 interface IERC20Permit {
472     /**
473      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
474      * given ``owner``'s signed approval.
475      *
476      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
477      * ordering also apply here.
478      *
479      * Emits an {Approval} event.
480      *
481      * Requirements:
482      *
483      * - `spender` cannot be the zero address.
484      * - `deadline` must be a timestamp in the future.
485      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
486      * over the EIP712-formatted function arguments.
487      * - the signature must use ``owner``'s current nonce (see {nonces}).
488      *
489      * For more information on the signature format, see the
490      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
491      * section].
492      */
493     function permit(
494         address owner,
495         address spender,
496         uint256 value,
497         uint256 deadline,
498         uint8 v,
499         bytes32 r,
500         bytes32 s
501     ) external;
502 
503     /**
504      * @dev Returns the current nonce for `owner`. This value must be
505      * included whenever a signature is generated for {permit}.
506      *
507      * Every successful call to {permit} increases ``owner``'s nonce by one. This
508      * prevents a signature from being used multiple times.
509      */
510     function nonces(address owner) external view returns (uint256);
511 
512     /**
513      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
514      */
515     // solhint-disable-next-line func-name-mixedcase
516     function DOMAIN_SEPARATOR() external view returns (bytes32);
517 }
518 
519 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
520 
521 
522 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
523 
524 pragma solidity ^0.8.0;
525 
526 /**
527  * @dev Interface of the ERC20 standard as defined in the EIP.
528  */
529 interface IERC20 {
530     /**
531      * @dev Emitted when `value` tokens are moved from one account (`from`) to
532      * another (`to`).
533      *
534      * Note that `value` may be zero.
535      */
536     event Transfer(address indexed from, address indexed to, uint256 value);
537 
538     /**
539      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
540      * a call to {approve}. `value` is the new allowance.
541      */
542     event Approval(address indexed owner, address indexed spender, uint256 value);
543 
544     /**
545      * @dev Returns the amount of tokens in existence.
546      */
547     function totalSupply() external view returns (uint256);
548 
549     /**
550      * @dev Returns the amount of tokens owned by `account`.
551      */
552     function balanceOf(address account) external view returns (uint256);
553 
554     /**
555      * @dev Moves `amount` tokens from the caller's account to `to`.
556      *
557      * Returns a boolean value indicating whether the operation succeeded.
558      *
559      * Emits a {Transfer} event.
560      */
561     function transfer(address to, uint256 amount) external returns (bool);
562 
563     /**
564      * @dev Returns the remaining number of tokens that `spender` will be
565      * allowed to spend on behalf of `owner` through {transferFrom}. This is
566      * zero by default.
567      *
568      * This value changes when {approve} or {transferFrom} are called.
569      */
570     function allowance(address owner, address spender) external view returns (uint256);
571 
572     /**
573      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
574      *
575      * Returns a boolean value indicating whether the operation succeeded.
576      *
577      * IMPORTANT: Beware that changing an allowance with this method brings the risk
578      * that someone may use both the old and the new allowance by unfortunate
579      * transaction ordering. One possible solution to mitigate this race
580      * condition is to first reduce the spender's allowance to 0 and set the
581      * desired value afterwards:
582      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
583      *
584      * Emits an {Approval} event.
585      */
586     function approve(address spender, uint256 amount) external returns (bool);
587 
588     /**
589      * @dev Moves `amount` tokens from `from` to `to` using the
590      * allowance mechanism. `amount` is then deducted from the caller's
591      * allowance.
592      *
593      * Returns a boolean value indicating whether the operation succeeded.
594      *
595      * Emits a {Transfer} event.
596      */
597     function transferFrom(
598         address from,
599         address to,
600         uint256 amount
601     ) external returns (bool);
602 }
603 
604 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
605 
606 
607 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
608 
609 pragma solidity ^0.8.0;
610 
611 
612 
613 
614 /**
615  * @title SafeERC20
616  * @dev Wrappers around ERC20 operations that throw on failure (when the token
617  * contract returns false). Tokens that return no value (and instead revert or
618  * throw on failure) are also supported, non-reverting calls are assumed to be
619  * successful.
620  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
621  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
622  */
623 library SafeERC20 {
624     using Address for address;
625 
626     function safeTransfer(
627         IERC20 token,
628         address to,
629         uint256 value
630     ) internal {
631         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
632     }
633 
634     function safeTransferFrom(
635         IERC20 token,
636         address from,
637         address to,
638         uint256 value
639     ) internal {
640         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
641     }
642 
643     /**
644      * @dev Deprecated. This function has issues similar to the ones found in
645      * {IERC20-approve}, and its usage is discouraged.
646      *
647      * Whenever possible, use {safeIncreaseAllowance} and
648      * {safeDecreaseAllowance} instead.
649      */
650     function safeApprove(
651         IERC20 token,
652         address spender,
653         uint256 value
654     ) internal {
655         // safeApprove should only be called when setting an initial allowance,
656         // or when resetting it to zero. To increase and decrease it, use
657         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
658         require(
659             (value == 0) || (token.allowance(address(this), spender) == 0),
660             "SafeERC20: approve from non-zero to non-zero allowance"
661         );
662         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
663     }
664 
665     function safeIncreaseAllowance(
666         IERC20 token,
667         address spender,
668         uint256 value
669     ) internal {
670         uint256 newAllowance = token.allowance(address(this), spender) + value;
671         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
672     }
673 
674     function safeDecreaseAllowance(
675         IERC20 token,
676         address spender,
677         uint256 value
678     ) internal {
679         unchecked {
680             uint256 oldAllowance = token.allowance(address(this), spender);
681             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
682             uint256 newAllowance = oldAllowance - value;
683             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
684         }
685     }
686 
687     function safePermit(
688         IERC20Permit token,
689         address owner,
690         address spender,
691         uint256 value,
692         uint256 deadline,
693         uint8 v,
694         bytes32 r,
695         bytes32 s
696     ) internal {
697         uint256 nonceBefore = token.nonces(owner);
698         token.permit(owner, spender, value, deadline, v, r, s);
699         uint256 nonceAfter = token.nonces(owner);
700         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
701     }
702 
703     /**
704      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
705      * on the return value: the return value is optional (but if data is returned, it must not be false).
706      * @param token The token targeted by the call.
707      * @param data The call data (encoded using abi.encode or one of its variants).
708      */
709     function _callOptionalReturn(IERC20 token, bytes memory data) private {
710         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
711         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
712         // the target address contains contract code and also asserts for success in the low-level call.
713 
714         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
715         if (returndata.length > 0) {
716             // Return data is optional
717             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
718         }
719     }
720 }
721 
722 // File: @openzeppelin/contracts/utils/Context.sol
723 
724 
725 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
726 
727 pragma solidity ^0.8.0;
728 
729 /**
730  * @dev Provides information about the current execution context, including the
731  * sender of the transaction and its data. While these are generally available
732  * via msg.sender and msg.data, they should not be accessed in such a direct
733  * manner, since when dealing with meta-transactions the account sending and
734  * paying for execution may not be the actual sender (as far as an application
735  * is concerned).
736  *
737  * This contract is only required for intermediate, library-like contracts.
738  */
739 abstract contract Context {
740     function _msgSender() internal view virtual returns (address) {
741         return msg.sender;
742     }
743 
744     function _msgData() internal view virtual returns (bytes calldata) {
745         return msg.data;
746     }
747 }
748 
749 // File: @openzeppelin/contracts/access/Ownable.sol
750 
751 
752 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
753 
754 pragma solidity ^0.8.0;
755 
756 
757 /**
758  * @dev Contract module which provides a basic access control mechanism, where
759  * there is an account (an owner) that can be granted exclusive access to
760  * specific functions.
761  *
762  * By default, the owner account will be the one that deploys the contract. This
763  * can later be changed with {transferOwnership}.
764  *
765  * This module is used through inheritance. It will make available the modifier
766  * `onlyOwner`, which can be applied to your functions to restrict their use to
767  * the owner.
768  */
769 abstract contract Ownable is Context {
770     address private _owner;
771 
772     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
773 
774     /**
775      * @dev Initializes the contract setting the deployer as the initial owner.
776      */
777     constructor() {
778         _transferOwnership(_msgSender());
779     }
780 
781     /**
782      * @dev Returns the address of the current owner.
783      */
784     function owner() public view virtual returns (address) {
785         return _owner;
786     }
787 
788     /**
789      * @dev Throws if called by any account other than the owner.
790      */
791     modifier onlyOwner() {
792         require(owner() == _msgSender(), "Ownable: caller is not the owner");
793         _;
794     }
795 
796     /**
797      * @dev Leaves the contract without owner. It will not be possible to call
798      * `onlyOwner` functions anymore. Can only be called by the current owner.
799      *
800      * NOTE: Renouncing ownership will leave the contract without an owner,
801      * thereby removing any functionality that is only available to the owner.
802      */
803     function renounceOwnership() public virtual onlyOwner {
804         _transferOwnership(address(0));
805     }
806 
807     /**
808      * @dev Transfers ownership of the contract to a new account (`newOwner`).
809      * Can only be called by the current owner.
810      */
811     function transferOwnership(address newOwner) public virtual onlyOwner {
812         require(newOwner != address(0), "Ownable: new owner is the zero address");
813         _transferOwnership(newOwner);
814     }
815 
816     /**
817      * @dev Transfers ownership of the contract to a new account (`newOwner`).
818      * Internal function without access restriction.
819      */
820     function _transferOwnership(address newOwner) internal virtual {
821         address oldOwner = _owner;
822         _owner = newOwner;
823         emit OwnershipTransferred(oldOwner, newOwner);
824     }
825 }
826 
827 // File: contracts/WCAICO.sol
828 
829 //SPDX-License-Identifier: MIT
830 pragma solidity ^0.8.17;
831 
832 
833 
834 
835 
836 contract WorldCupApesICO is Ownable {
837     using SafeERC20 for IERC20;
838     using SafeMath for uint256;
839 
840     struct Referral {
841         string code;
842         uint256 price;
843         uint256 expiration;
844         bool active;
845         bool exists;
846     }
847 
848     address public wallet;
849     address public manager;
850     uint256 public startUnstakeTimestamp = 1669849200;
851     uint256 public price = 35;
852     uint256 public priceDivider = 100;
853     uint256 public emissionRate = 66;
854     uint256 public emissionDivider = 10000;
855     uint256 public usdtPow = 12;
856     bool public purchaseLive = false;
857     mapping(address => uint256) internal stakerToUSDT;
858     mapping(address => uint256) internal stakerToTokens;
859     mapping(address => uint256) internal stakerToInitialTokens;
860     mapping(address => uint256) internal stakerToLastClaim;
861     mapping(string => Referral) internal codeToReferral;
862 
863     IERC20 private USDT;
864     IERC20 private WCAToken;
865 
866     modifier canUnstake() {
867         require(
868             block.timestamp >= startUnstakeTimestamp,
869             "You can't already unstake tokens"
870         );
871         _;
872     }
873 
874     modifier purchaseEnabled() {
875         require(purchaseLive, "Purchase not live");
876         _;
877     }
878 
879     modifier onlyOwnerOrManager() {
880         require(msg.sender == owner() || msg.sender == manager, "Unauthorized");
881         _;
882     }
883 
884     constructor(
885         address _WCAToken,
886         address _USDT,
887         address _wallet,
888         address _manager
889     ) {
890         WCAToken = IERC20(_WCAToken);
891         USDT = IERC20(_USDT);
892         wallet = _wallet;
893         manager = _manager;
894     }
895 
896     function addReferrals(Referral[] calldata refs)
897         external
898         onlyOwnerOrManager
899     {
900         for (uint256 i; i < refs.length; i++) {
901             Referral calldata ref = refs[i];
902             require(
903                 !codeToReferral[ref.code].exists,
904                 "Referral already exists"
905             );
906 
907             codeToReferral[ref.code].code = ref.code;
908             codeToReferral[ref.code].price = ref.price;
909             codeToReferral[ref.code].expiration = ref.expiration;
910             codeToReferral[ref.code].active = ref.active;
911             codeToReferral[ref.code].exists = true;
912         }
913     }
914 
915     function updateReferral(Referral calldata ref) external onlyOwnerOrManager {
916         require(codeToReferral[ref.code].exists, "Referral does't exists");
917 
918         codeToReferral[ref.code].price = ref.price;
919         codeToReferral[ref.code].expiration = ref.expiration;
920         codeToReferral[ref.code].active = ref.active;
921     }
922 
923     function deleteReferral(string calldata code) external onlyOwnerOrManager {
924         require(codeToReferral[code].exists, "Referral does't exists");
925 
926         codeToReferral[code].exists = false;
927     }
928 
929     function getReferral(string calldata code) external view returns (Referral memory) {
930         require(codeToReferral[code].exists, "Referral does't exists");
931 
932         return codeToReferral[code];
933     }
934 
935     function setWallet(address _wallet) external onlyOwner {
936         wallet = _wallet;
937     }
938 
939     function setManager(address _manager) external onlyOwner {
940         manager = _manager;
941     }
942 
943     function setStartUnstakeTimestamp(uint256 timestamp) external onlyOwner {
944         startUnstakeTimestamp = timestamp;
945     }
946 
947     function setPrice(uint256 _price) external onlyOwner {
948         price = _price;
949     }
950 
951     function setPriceDivider(uint256 _priceDivider) external onlyOwner {
952         priceDivider = _priceDivider;
953     }
954 
955     function setEmissionRate(uint256 _emissionRate) external onlyOwner {
956         emissionRate = _emissionRate;
957     }
958 
959     function setEmissionDivider(uint256 _emissionDivider) external onlyOwner {
960         emissionDivider = _emissionDivider;
961     }
962 
963     function setUsdtPow(uint256 _usdtPow) external onlyOwner {
964         usdtPow = _usdtPow;
965     }
966 
967     function togglePurchaseLive() external onlyOwner {
968         purchaseLive = !purchaseLive;
969     }
970 
971     function bonus(address _address, uint256 value) external onlyOwnerOrManager {
972         stakerToTokens[_address] = stakerToTokens[_address].add(value);
973         stakerToInitialTokens[_address] = stakerToInitialTokens[_address].add(
974             value
975         );
976     }
977 
978     function reduce(address _address, uint256 value) external onlyOwnerOrManager {
979         stakerToTokens[_address] = stakerToTokens[_address].sub(value);
980         stakerToInitialTokens[_address] = stakerToInitialTokens[_address].sub(
981             value
982         );
983     }
984 
985     function buy(
986         address _address,
987         uint256 _value,
988         string calldata referral
989     ) external purchaseEnabled {
990         uint256 balance = USDT.balanceOf(msg.sender);
991 
992         require(balance > 0, "You have no USDT");
993 
994         require(
995             USDT.allowance(msg.sender, address(this)) >= _value,
996             "First approve to buy"
997         );
998 
999         USDT.safeTransferFrom(msg.sender, wallet, _value);
1000 
1001         uint256 _price = price;
1002         if (
1003             codeToReferral[referral].exists &&
1004             codeToReferral[referral].expiration > block.timestamp &&
1005             codeToReferral[referral].active == true
1006         ) {
1007             _price = codeToReferral[referral].price;
1008         }
1009 
1010         uint256 valueInWCA = _value.mul(10**usdtPow).mul(priceDivider).div(
1011             _price
1012         );
1013         stakerToUSDT[_address] = stakerToUSDT[_address].add(_value);
1014         stakerToTokens[_address] = stakerToTokens[_address].add(valueInWCA);
1015         stakerToInitialTokens[_address] = stakerToInitialTokens[_address].add(
1016             valueInWCA
1017         );
1018     }
1019 
1020     function claim(address _address) external canUnstake {
1021         require(
1022             stakerToTokens[_address] > 0 && stakerToInitialTokens[_address] > 0,
1023             "You have no tokens staked"
1024         );
1025 
1026         uint256 fromTimestamp = startUnstakeTimestamp;
1027         if (stakerToLastClaim[_address] > startUnstakeTimestamp) {
1028             fromTimestamp = stakerToLastClaim[_address];
1029         }
1030 
1031         uint256 rewards = block
1032             .timestamp
1033             .sub(fromTimestamp)
1034             .mul(stakerToInitialTokens[_address])
1035             .mul(emissionRate)
1036             .div(emissionDivider)
1037             .div(86400);
1038 
1039         if (rewards > stakerToTokens[_address]) {
1040             rewards = stakerToTokens[_address];
1041             stakerToTokens[_address] = 0;
1042         } else {
1043             stakerToTokens[_address] = stakerToTokens[_address].sub(rewards);
1044         }
1045 
1046         stakerToLastClaim[_address] = block.timestamp;
1047 
1048         WCAToken.transferFrom(owner(), _address, rewards);
1049     }
1050 
1051     function getTotalClaimable(address _address)
1052         external
1053         view
1054         returns (uint256)
1055     {
1056         return stakerToInitialTokens[_address];
1057     }
1058 
1059     function getRemainingClaimable(address _address)
1060         external
1061         view
1062         returns (uint256)
1063     {
1064         return stakerToTokens[_address];
1065     }
1066 
1067     function getClaimable(address _address) external view returns (uint256) {
1068         if (
1069             stakerToTokens[_address] <= 0 ||
1070             stakerToInitialTokens[_address] <= 0 ||
1071             block.timestamp < startUnstakeTimestamp
1072         ) {
1073             return 0;
1074         }
1075 
1076         uint256 fromTimestamp = startUnstakeTimestamp;
1077         if (stakerToLastClaim[_address] > startUnstakeTimestamp) {
1078             fromTimestamp = stakerToLastClaim[_address];
1079         }
1080 
1081         uint256 rewards = block
1082             .timestamp
1083             .sub(fromTimestamp)
1084             .mul(stakerToInitialTokens[_address])
1085             .mul(emissionRate)
1086             .div(emissionDivider)
1087             .div(86400);
1088         if (rewards > stakerToTokens[_address]) {
1089             rewards = stakerToTokens[_address];
1090         }
1091 
1092         return rewards;
1093     }
1094 
1095     function getSpentUSDT(address _address) external view returns (uint256) {
1096         return stakerToUSDT[_address];
1097     }
1098 }