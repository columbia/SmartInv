1 // Sources flattened with hardhat v2.10.1 https://hardhat.org
2 
3 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Interface of the ERC20 standard as defined in the EIP.
12  */
13 interface IERC20 {
14     /**
15      * @dev Emitted when `value` tokens are moved from one account (`from`) to
16      * another (`to`).
17      *
18      * Note that `value` may be zero.
19      */
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     /**
23      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
24      * a call to {approve}. `value` is the new allowance.
25      */
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `to`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address to, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `from` to `to` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(
82         address from,
83         address to,
84         uint256 amount
85     ) external returns (bool);
86 }
87 
88 
89 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
90 
91 
92 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
93 
94 pragma solidity ^0.8.0;
95 
96 /**
97  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
98  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
99  *
100  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
101  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
102  * need to send a transaction, and thus is not required to hold Ether at all.
103  */
104 interface IERC20Permit {
105     /**
106      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
107      * given ``owner``'s signed approval.
108      *
109      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
110      * ordering also apply here.
111      *
112      * Emits an {Approval} event.
113      *
114      * Requirements:
115      *
116      * - `spender` cannot be the zero address.
117      * - `deadline` must be a timestamp in the future.
118      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
119      * over the EIP712-formatted function arguments.
120      * - the signature must use ``owner``'s current nonce (see {nonces}).
121      *
122      * For more information on the signature format, see the
123      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
124      * section].
125      */
126     function permit(
127         address owner,
128         address spender,
129         uint256 value,
130         uint256 deadline,
131         uint8 v,
132         bytes32 r,
133         bytes32 s
134     ) external;
135 
136     /**
137      * @dev Returns the current nonce for `owner`. This value must be
138      * included whenever a signature is generated for {permit}.
139      *
140      * Every successful call to {permit} increases ``owner``'s nonce by one. This
141      * prevents a signature from being used multiple times.
142      */
143     function nonces(address owner) external view returns (uint256);
144 
145     /**
146      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
147      */
148     // solhint-disable-next-line func-name-mixedcase
149     function DOMAIN_SEPARATOR() external view returns (bytes32);
150 }
151 
152 
153 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
154 
155 
156 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
157 
158 pragma solidity ^0.8.1;
159 
160 /**
161  * @dev Collection of functions related to the address type
162  */
163 library Address {
164     /**
165      * @dev Returns true if `account` is a contract.
166      *
167      * [IMPORTANT]
168      * ====
169      * It is unsafe to assume that an address for which this function returns
170      * false is an externally-owned account (EOA) and not a contract.
171      *
172      * Among others, `isContract` will return false for the following
173      * types of addresses:
174      *
175      *  - an externally-owned account
176      *  - a contract in construction
177      *  - an address where a contract will be created
178      *  - an address where a contract lived, but was destroyed
179      * ====
180      *
181      * [IMPORTANT]
182      * ====
183      * You shouldn't rely on `isContract` to protect against flash loan attacks!
184      *
185      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
186      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
187      * constructor.
188      * ====
189      */
190     function isContract(address account) internal view returns (bool) {
191         // This method relies on extcodesize/address.code.length, which returns 0
192         // for contracts in construction, since the code is only stored at the end
193         // of the constructor execution.
194 
195         return account.code.length > 0;
196     }
197 
198     /**
199      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
200      * `recipient`, forwarding all available gas and reverting on errors.
201      *
202      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
203      * of certain opcodes, possibly making contracts go over the 2300 gas limit
204      * imposed by `transfer`, making them unable to receive funds via
205      * `transfer`. {sendValue} removes this limitation.
206      *
207      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
208      *
209      * IMPORTANT: because control is transferred to `recipient`, care must be
210      * taken to not create reentrancy vulnerabilities. Consider using
211      * {ReentrancyGuard} or the
212      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
213      */
214     function sendValue(address payable recipient, uint256 amount) internal {
215         require(address(this).balance >= amount, "Address: insufficient balance");
216 
217         (bool success, ) = recipient.call{value: amount}("");
218         require(success, "Address: unable to send value, recipient may have reverted");
219     }
220 
221     /**
222      * @dev Performs a Solidity function call using a low level `call`. A
223      * plain `call` is an unsafe replacement for a function call: use this
224      * function instead.
225      *
226      * If `target` reverts with a revert reason, it is bubbled up by this
227      * function (like regular Solidity function calls).
228      *
229      * Returns the raw returned data. To convert to the expected return value,
230      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
231      *
232      * Requirements:
233      *
234      * - `target` must be a contract.
235      * - calling `target` with `data` must not revert.
236      *
237      * _Available since v3.1._
238      */
239     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
240         return functionCall(target, data, "Address: low-level call failed");
241     }
242 
243     /**
244      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
245      * `errorMessage` as a fallback revert reason when `target` reverts.
246      *
247      * _Available since v3.1._
248      */
249     function functionCall(
250         address target,
251         bytes memory data,
252         string memory errorMessage
253     ) internal returns (bytes memory) {
254         return functionCallWithValue(target, data, 0, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but also transferring `value` wei to `target`.
260      *
261      * Requirements:
262      *
263      * - the calling contract must have an ETH balance of at least `value`.
264      * - the called Solidity function must be `payable`.
265      *
266      * _Available since v3.1._
267      */
268     function functionCallWithValue(
269         address target,
270         bytes memory data,
271         uint256 value
272     ) internal returns (bytes memory) {
273         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
278      * with `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCallWithValue(
283         address target,
284         bytes memory data,
285         uint256 value,
286         string memory errorMessage
287     ) internal returns (bytes memory) {
288         require(address(this).balance >= value, "Address: insufficient balance for call");
289         require(isContract(target), "Address: call to non-contract");
290 
291         (bool success, bytes memory returndata) = target.call{value: value}(data);
292         return verifyCallResult(success, returndata, errorMessage);
293     }
294 
295     /**
296      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
297      * but performing a static call.
298      *
299      * _Available since v3.3._
300      */
301     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
302         return functionStaticCall(target, data, "Address: low-level static call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
307      * but performing a static call.
308      *
309      * _Available since v3.3._
310      */
311     function functionStaticCall(
312         address target,
313         bytes memory data,
314         string memory errorMessage
315     ) internal view returns (bytes memory) {
316         require(isContract(target), "Address: static call to non-contract");
317 
318         (bool success, bytes memory returndata) = target.staticcall(data);
319         return verifyCallResult(success, returndata, errorMessage);
320     }
321 
322     /**
323      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
324      * but performing a delegate call.
325      *
326      * _Available since v3.4._
327      */
328     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
329         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
330     }
331 
332     /**
333      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
334      * but performing a delegate call.
335      *
336      * _Available since v3.4._
337      */
338     function functionDelegateCall(
339         address target,
340         bytes memory data,
341         string memory errorMessage
342     ) internal returns (bytes memory) {
343         require(isContract(target), "Address: delegate call to non-contract");
344 
345         (bool success, bytes memory returndata) = target.delegatecall(data);
346         return verifyCallResult(success, returndata, errorMessage);
347     }
348 
349     /**
350      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
351      * revert reason using the provided one.
352      *
353      * _Available since v4.3._
354      */
355     function verifyCallResult(
356         bool success,
357         bytes memory returndata,
358         string memory errorMessage
359     ) internal pure returns (bytes memory) {
360         if (success) {
361             return returndata;
362         } else {
363             // Look for revert reason and bubble it up if present
364             if (returndata.length > 0) {
365                 // The easiest way to bubble the revert reason is using memory via assembly
366                 /// @solidity memory-safe-assembly
367                 assembly {
368                     let returndata_size := mload(returndata)
369                     revert(add(32, returndata), returndata_size)
370                 }
371             } else {
372                 revert(errorMessage);
373             }
374         }
375     }
376 }
377 
378 
379 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3
380 
381 
382 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 
387 
388 /**
389  * @title SafeERC20
390  * @dev Wrappers around ERC20 operations that throw on failure (when the token
391  * contract returns false). Tokens that return no value (and instead revert or
392  * throw on failure) are also supported, non-reverting calls are assumed to be
393  * successful.
394  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
395  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
396  */
397 library SafeERC20 {
398     using Address for address;
399 
400     function safeTransfer(
401         IERC20 token,
402         address to,
403         uint256 value
404     ) internal {
405         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
406     }
407 
408     function safeTransferFrom(
409         IERC20 token,
410         address from,
411         address to,
412         uint256 value
413     ) internal {
414         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
415     }
416 
417     /**
418      * @dev Deprecated. This function has issues similar to the ones found in
419      * {IERC20-approve}, and its usage is discouraged.
420      *
421      * Whenever possible, use {safeIncreaseAllowance} and
422      * {safeDecreaseAllowance} instead.
423      */
424     function safeApprove(
425         IERC20 token,
426         address spender,
427         uint256 value
428     ) internal {
429         // safeApprove should only be called when setting an initial allowance,
430         // or when resetting it to zero. To increase and decrease it, use
431         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
432         require(
433             (value == 0) || (token.allowance(address(this), spender) == 0),
434             "SafeERC20: approve from non-zero to non-zero allowance"
435         );
436         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
437     }
438 
439     function safeIncreaseAllowance(
440         IERC20 token,
441         address spender,
442         uint256 value
443     ) internal {
444         uint256 newAllowance = token.allowance(address(this), spender) + value;
445         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
446     }
447 
448     function safeDecreaseAllowance(
449         IERC20 token,
450         address spender,
451         uint256 value
452     ) internal {
453         unchecked {
454             uint256 oldAllowance = token.allowance(address(this), spender);
455             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
456             uint256 newAllowance = oldAllowance - value;
457             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
458         }
459     }
460 
461     function safePermit(
462         IERC20Permit token,
463         address owner,
464         address spender,
465         uint256 value,
466         uint256 deadline,
467         uint8 v,
468         bytes32 r,
469         bytes32 s
470     ) internal {
471         uint256 nonceBefore = token.nonces(owner);
472         token.permit(owner, spender, value, deadline, v, r, s);
473         uint256 nonceAfter = token.nonces(owner);
474         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
475     }
476 
477     /**
478      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
479      * on the return value: the return value is optional (but if data is returned, it must not be false).
480      * @param token The token targeted by the call.
481      * @param data The call data (encoded using abi.encode or one of its variants).
482      */
483     function _callOptionalReturn(IERC20 token, bytes memory data) private {
484         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
485         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
486         // the target address contains contract code and also asserts for success in the low-level call.
487 
488         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
489         if (returndata.length > 0) {
490             // Return data is optional
491             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
492         }
493     }
494 }
495 
496 
497 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.3
498 
499 
500 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 // CAUTION
505 // This version of SafeMath should only be used with Solidity 0.8 or later,
506 // because it relies on the compiler's built in overflow checks.
507 
508 /**
509  * @dev Wrappers over Solidity's arithmetic operations.
510  *
511  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
512  * now has built in overflow checking.
513  */
514 library SafeMath {
515     /**
516      * @dev Returns the addition of two unsigned integers, with an overflow flag.
517      *
518      * _Available since v3.4._
519      */
520     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
521         unchecked {
522             uint256 c = a + b;
523             if (c < a) return (false, 0);
524             return (true, c);
525         }
526     }
527 
528     /**
529      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
530      *
531      * _Available since v3.4._
532      */
533     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
534         unchecked {
535             if (b > a) return (false, 0);
536             return (true, a - b);
537         }
538     }
539 
540     /**
541      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
542      *
543      * _Available since v3.4._
544      */
545     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
546         unchecked {
547             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
548             // benefit is lost if 'b' is also tested.
549             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
550             if (a == 0) return (true, 0);
551             uint256 c = a * b;
552             if (c / a != b) return (false, 0);
553             return (true, c);
554         }
555     }
556 
557     /**
558      * @dev Returns the division of two unsigned integers, with a division by zero flag.
559      *
560      * _Available since v3.4._
561      */
562     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
563         unchecked {
564             if (b == 0) return (false, 0);
565             return (true, a / b);
566         }
567     }
568 
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
571      *
572      * _Available since v3.4._
573      */
574     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
575         unchecked {
576             if (b == 0) return (false, 0);
577             return (true, a % b);
578         }
579     }
580 
581     /**
582      * @dev Returns the addition of two unsigned integers, reverting on
583      * overflow.
584      *
585      * Counterpart to Solidity's `+` operator.
586      *
587      * Requirements:
588      *
589      * - Addition cannot overflow.
590      */
591     function add(uint256 a, uint256 b) internal pure returns (uint256) {
592         return a + b;
593     }
594 
595     /**
596      * @dev Returns the subtraction of two unsigned integers, reverting on
597      * overflow (when the result is negative).
598      *
599      * Counterpart to Solidity's `-` operator.
600      *
601      * Requirements:
602      *
603      * - Subtraction cannot overflow.
604      */
605     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
606         return a - b;
607     }
608 
609     /**
610      * @dev Returns the multiplication of two unsigned integers, reverting on
611      * overflow.
612      *
613      * Counterpart to Solidity's `*` operator.
614      *
615      * Requirements:
616      *
617      * - Multiplication cannot overflow.
618      */
619     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
620         return a * b;
621     }
622 
623     /**
624      * @dev Returns the integer division of two unsigned integers, reverting on
625      * division by zero. The result is rounded towards zero.
626      *
627      * Counterpart to Solidity's `/` operator.
628      *
629      * Requirements:
630      *
631      * - The divisor cannot be zero.
632      */
633     function div(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a / b;
635     }
636 
637     /**
638      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
639      * reverting when dividing by zero.
640      *
641      * Counterpart to Solidity's `%` operator. This function uses a `revert`
642      * opcode (which leaves remaining gas untouched) while Solidity uses an
643      * invalid opcode to revert (consuming all remaining gas).
644      *
645      * Requirements:
646      *
647      * - The divisor cannot be zero.
648      */
649     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
650         return a % b;
651     }
652 
653     /**
654      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
655      * overflow (when the result is negative).
656      *
657      * CAUTION: This function is deprecated because it requires allocating memory for the error
658      * message unnecessarily. For custom revert reasons use {trySub}.
659      *
660      * Counterpart to Solidity's `-` operator.
661      *
662      * Requirements:
663      *
664      * - Subtraction cannot overflow.
665      */
666     function sub(
667         uint256 a,
668         uint256 b,
669         string memory errorMessage
670     ) internal pure returns (uint256) {
671         unchecked {
672             require(b <= a, errorMessage);
673             return a - b;
674         }
675     }
676 
677     /**
678      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
679      * division by zero. The result is rounded towards zero.
680      *
681      * Counterpart to Solidity's `/` operator. Note: this function uses a
682      * `revert` opcode (which leaves remaining gas untouched) while Solidity
683      * uses an invalid opcode to revert (consuming all remaining gas).
684      *
685      * Requirements:
686      *
687      * - The divisor cannot be zero.
688      */
689     function div(
690         uint256 a,
691         uint256 b,
692         string memory errorMessage
693     ) internal pure returns (uint256) {
694         unchecked {
695             require(b > 0, errorMessage);
696             return a / b;
697         }
698     }
699 
700     /**
701      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
702      * reverting with custom message when dividing by zero.
703      *
704      * CAUTION: This function is deprecated because it requires allocating memory for the error
705      * message unnecessarily. For custom revert reasons use {tryMod}.
706      *
707      * Counterpart to Solidity's `%` operator. This function uses a `revert`
708      * opcode (which leaves remaining gas untouched) while Solidity uses an
709      * invalid opcode to revert (consuming all remaining gas).
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function mod(
716         uint256 a,
717         uint256 b,
718         string memory errorMessage
719     ) internal pure returns (uint256) {
720         unchecked {
721             require(b > 0, errorMessage);
722             return a % b;
723         }
724     }
725 }
726 
727 
728 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
729 
730 
731 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
732 
733 pragma solidity ^0.8.0;
734 
735 /**
736  * @dev Provides information about the current execution context, including the
737  * sender of the transaction and its data. While these are generally available
738  * via msg.sender and msg.data, they should not be accessed in such a direct
739  * manner, since when dealing with meta-transactions the account sending and
740  * paying for execution may not be the actual sender (as far as an application
741  * is concerned).
742  *
743  * This contract is only required for intermediate, library-like contracts.
744  */
745 abstract contract Context {
746     function _msgSender() internal view virtual returns (address) {
747         return msg.sender;
748     }
749 
750     function _msgData() internal view virtual returns (bytes calldata) {
751         return msg.data;
752     }
753 }
754 
755 
756 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
757 
758 
759 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
760 
761 pragma solidity ^0.8.0;
762 
763 /**
764  * @dev Contract module which provides a basic access control mechanism, where
765  * there is an account (an owner) that can be granted exclusive access to
766  * specific functions.
767  *
768  * By default, the owner account will be the one that deploys the contract. This
769  * can later be changed with {transferOwnership}.
770  *
771  * This module is used through inheritance. It will make available the modifier
772  * `onlyOwner`, which can be applied to your functions to restrict their use to
773  * the owner.
774  */
775 abstract contract Ownable is Context {
776     address private _owner;
777 
778     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
779 
780     /**
781      * @dev Initializes the contract setting the deployer as the initial owner.
782      */
783     constructor() {
784         _transferOwnership(_msgSender());
785     }
786 
787     /**
788      * @dev Throws if called by any account other than the owner.
789      */
790     modifier onlyOwner() {
791         _checkOwner();
792         _;
793     }
794 
795     /**
796      * @dev Returns the address of the current owner.
797      */
798     function owner() public view virtual returns (address) {
799         return _owner;
800     }
801 
802     /**
803      * @dev Throws if the sender is not the owner.
804      */
805     function _checkOwner() internal view virtual {
806         require(owner() == _msgSender(), "Ownable: caller is not the owner");
807     }
808 
809     /**
810      * @dev Leaves the contract without owner. It will not be possible to call
811      * `onlyOwner` functions anymore. Can only be called by the current owner.
812      *
813      * NOTE: Renouncing ownership will leave the contract without an owner,
814      * thereby removing any functionality that is only available to the owner.
815      */
816     function renounceOwnership() public virtual onlyOwner {
817         _transferOwnership(address(0));
818     }
819 
820     /**
821      * @dev Transfers ownership of the contract to a new account (`newOwner`).
822      * Can only be called by the current owner.
823      */
824     function transferOwnership(address newOwner) public virtual onlyOwner {
825         require(newOwner != address(0), "Ownable: new owner is the zero address");
826         _transferOwnership(newOwner);
827     }
828 
829     /**
830      * @dev Transfers ownership of the contract to a new account (`newOwner`).
831      * Internal function without access restriction.
832      */
833     function _transferOwnership(address newOwner) internal virtual {
834         address oldOwner = _owner;
835         _owner = newOwner;
836         emit OwnershipTransferred(oldOwner, newOwner);
837     }
838 }
839 
840 
841 // File contracts/interfaces/IStakingRewards.sol
842 
843 
844 pragma solidity ^0.8.0;
845 
846 interface IStakingRewards {
847   function lock(address who, uint _amount) external;
848   function withdraw(address who, uint _amount) external;
849 }
850 
851 
852 // File contracts/interfaces/IMultiFeeDistribution.sol
853 
854 
855 pragma solidity ^0.8.0;
856 
857 interface IMultiFeeDistribution {
858   function mint(address user, uint256 amount) external;
859 }
860 
861 
862 // File contracts/interfaces/IChefIncentivesController.sol
863 
864 
865 pragma solidity ^0.8.0;
866 
867 interface IChefIncentivesController {
868   function handleAction(address user, uint256 userBalance, uint256 totalSupply) external;
869   function addPool(address _token, uint256 _allocPoint) external;
870   function claim(address _user, address[] calldata _tokens) external;
871   function setClaimReceiver(address _user, address _receiver) external;
872 }
873 
874 
875 // File contracts/MultiFeeDistribution.sol
876 
877 
878 pragma solidity ^0.8.0;
879 
880 
881 
882 
883 
884 
885 contract MultiFeeDistribution is IMultiFeeDistribution, Ownable {
886   using SafeMath for uint;
887   using SafeERC20 for IERC20;
888 
889   event Locked(address indexed user, uint amount);
890   event WithdrawnExpiredLocks(address indexed user, uint amount);
891   event Minted(address indexed user, uint amount);
892   event ExitedEarly(address indexed user, uint amount, uint penaltyAmount);
893   event Withdrawn(address indexed user, uint amount);
894   event RewardPaid(address indexed user, address indexed rewardsToken, uint reward);
895 
896   struct Reward {
897     uint periodFinish;
898     uint rewardRate;
899     uint lastUpdateTime;
900     uint rewardPerTokenStored;
901     uint balance;
902   }
903   struct Balances {
904     uint locked; // balance lock tokens
905     uint earned; // balance reward tokens earned
906   }
907   struct LockedBalance {
908     uint amount;
909     uint unlockTime;
910   }
911   struct RewardData {
912     address token;
913     uint amount;
914   }
915 
916   uint public constant rewardsDuration = 86400 * 7; // reward interval 7 days;
917   uint public constant rewardLookback = 86400;
918   uint public constant lockDuration = rewardsDuration * 8; // 56 days
919   uint public constant vestingDuration = rewardsDuration * 4; // 28 days
920 
921   // Addresses approved to call mint
922   mapping(address => bool) public minters;
923   bool public mintersAreSet;
924 
925   // user -> reward token -> amount
926   mapping(address => mapping(address => uint)) public userRewardPerTokenPaid;
927   mapping(address => mapping(address => uint)) public rewards;
928 
929   IChefIncentivesController public incentivesController;
930   IERC20 public immutable stakingToken;
931   IERC20 public immutable rewardToken;
932   address public immutable rewardTokenVault;
933   address public teamRewardVault;
934   uint public teamRewardFee = 2000; // 1% = 100
935   IStakingRewards public stakingRewards;
936   bool public stakingRewardsAreSet;
937   address[] public rewardTokens;
938   mapping(address => Reward) public rewardData;
939 
940   uint public lockedSupply;
941 
942   // Private mappings for balance data
943   mapping(address => Balances) private balances;
944   mapping(address => LockedBalance[]) private userLocks; // stake UwU-ETH LP tokens
945   mapping(address => LockedBalance[]) private userEarnings; // vesting UwU tokens
946 
947   mapping(address => address) public exitDelegatee;
948 
949   constructor(address _stakingToken, address _rewardToken, address _rewardTokenVault) Ownable() {
950     stakingToken = IERC20(_stakingToken);
951     rewardToken = IERC20(_rewardToken);
952     rewardTokenVault = _rewardTokenVault;
953     rewardTokens.push(_rewardToken);
954     rewardData[_rewardToken].lastUpdateTime = block.timestamp;
955   }
956 
957   function setTeamRewardVault(address vault) external onlyOwner {
958     require(vault != address(0), "address zero");
959     teamRewardVault = vault;
960   }
961 
962   function setTeamRewardFee(uint fee) external onlyOwner {
963     require(fee <= 10000, "fee too high");
964     teamRewardFee = fee;
965   }
966 
967   function setStakingRewards(address _stakingRewards) external onlyOwner {
968     require(!stakingRewardsAreSet, 'stakingRewards already set');
969     stakingRewards = IStakingRewards(_stakingRewards);
970     stakingRewardsAreSet = true;
971   }
972 
973   function setMinters(address[] memory _minters) external onlyOwner {
974     require(!mintersAreSet, 'minter already set');
975     for (uint i; i < _minters.length; i++) {
976       minters[_minters[i]] = true;
977     }
978     mintersAreSet = true;
979   }
980 
981   function setIncentivesController(IChefIncentivesController _controller) external onlyOwner {
982     incentivesController = _controller;
983   }
984 
985    // Add a new reward token to be distributed to stakers
986   function addReward(address _rewardsToken) external onlyOwner {
987     require(rewardData[_rewardsToken].lastUpdateTime == 0);
988     rewardTokens.push(_rewardsToken);
989     rewardData[_rewardsToken].lastUpdateTime = block.timestamp;
990     rewardData[_rewardsToken].periodFinish = block.timestamp;
991   }
992 
993   // Information on a user's locked balances
994   function lockedBalances(address user) view external returns (
995     uint total,
996     uint unlockable,
997     uint locked,
998     LockedBalance[] memory lockData
999   ) {
1000     LockedBalance[] storage locks = userLocks[user];
1001     uint idx;
1002     for (uint i = 0; i < locks.length; i++) {
1003       if (locks[i].unlockTime > block.timestamp) {
1004         if (idx == 0) {
1005           lockData = new LockedBalance[](locks.length - i);
1006         }
1007         lockData[idx] = locks[i];
1008         idx++;
1009         locked = locked.add(locks[i].amount);
1010       } else {
1011         unlockable = unlockable.add(locks[i].amount);
1012       }
1013     }
1014     return (balances[user].locked, unlockable, locked, lockData);
1015   }
1016 
1017   // Information on the "earned" balances of a user
1018   function earnedBalances(address user) view external returns (uint total, LockedBalance[] memory earningsData) {
1019     LockedBalance[] storage earnings = userEarnings[user];
1020     uint idx;
1021     for (uint i = 0; i < earnings.length; i++) {
1022       if (earnings[i].unlockTime > block.timestamp) {
1023         if (idx == 0) {
1024           earningsData = new LockedBalance[](earnings.length - i);
1025         }
1026         earningsData[idx] = earnings[i];
1027         idx++;
1028         total = total.add(earnings[i].amount);
1029       }
1030     }
1031     return (total, earningsData);
1032   }
1033 
1034   function withdrawableBalance(address user) view public returns (
1035     uint amount,
1036     uint penaltyAmount,
1037     uint amountWithoutPenalty
1038   ) {
1039     Balances storage bal = balances[user];
1040     uint earned = bal.earned;
1041     if (earned > 0) {
1042       uint length = userEarnings[user].length;
1043       for (uint i = 0; i < length; i++) {
1044         uint earnedAmount = userEarnings[user][i].amount;
1045         if (earnedAmount == 0) continue;
1046         if (userEarnings[user][i].unlockTime > block.timestamp) {
1047           break;
1048         }
1049         amountWithoutPenalty = amountWithoutPenalty.add(earnedAmount);
1050       }
1051       penaltyAmount = earned.sub(amountWithoutPenalty).div(2);
1052     }
1053     amount = earned.sub(penaltyAmount);
1054     // return (amount, penaltyAmount);
1055   }
1056 
1057   // Address and claimable amount of all reward tokens for the given account
1058   function claimableRewards(address account) external view returns (RewardData[] memory rewards) {
1059     rewards = new RewardData[](rewardTokens.length);
1060     for (uint i = 0; i < rewards.length; i++) {
1061       rewards[i].token = rewardTokens[i];
1062       rewards[i].amount = _earned(account, rewards[i].token, balances[account].locked, _rewardPerToken(rewardTokens[i], lockedSupply)).div(1e12);
1063     }
1064     return rewards;
1065   }
1066 
1067   // Lock tokens to receive rewards
1068   // Locked tokens cannot be withdrawn for lockDuration and are eligible to receive stakingReward rewards
1069   function lock(uint amount, address onBehalfOf) external {
1070     require(amount > 0, "amount = 0");
1071     _updateReward(onBehalfOf);
1072     Balances storage bal = balances[onBehalfOf];
1073     lockedSupply = lockedSupply.add(amount);
1074     bal.locked = bal.locked.add(amount);
1075     uint unlockTime = block.timestamp.div(rewardsDuration).mul(rewardsDuration).add(lockDuration);
1076     uint idx = userLocks[onBehalfOf].length;
1077     if (idx == 0 || userLocks[onBehalfOf][idx-1].unlockTime < unlockTime) {
1078       userLocks[onBehalfOf].push(LockedBalance({amount: amount, unlockTime: unlockTime}));
1079     } else {
1080       userLocks[onBehalfOf][idx-1].amount = userLocks[onBehalfOf][idx-1].amount.add(amount);
1081     }
1082     stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1083     emit Locked(onBehalfOf, amount);
1084     if (address(stakingRewards) != address(0)) {
1085       stakingRewards.lock(onBehalfOf, amount);
1086     }
1087   }
1088 
1089   // Withdraw all currently locked tokens where the unlock time has passed
1090   function withdrawExpiredLocks() external {
1091     _updateReward(msg.sender);
1092     LockedBalance[] storage locks = userLocks[msg.sender];
1093     Balances storage bal = balances[msg.sender];
1094     uint amount;
1095     uint length = locks.length;
1096     if (locks[length-1].unlockTime <= block.timestamp) {
1097       amount = bal.locked;
1098       delete userLocks[msg.sender];
1099     } else {
1100       for (uint i = 0; i < length; i++) {
1101         if (locks[i].unlockTime > block.timestamp) break;
1102         amount = amount.add(locks[i].amount);
1103         delete locks[i];
1104       }
1105     }
1106     require(amount > 0, 'amount = 0');
1107     bal.locked = bal.locked.sub(amount);
1108     lockedSupply = lockedSupply.sub(amount);
1109     stakingToken.safeTransfer(msg.sender, amount);
1110     emit WithdrawnExpiredLocks(msg.sender, amount);
1111     if (address(stakingRewards) != address(0)) {
1112       stakingRewards.withdraw(msg.sender, amount);
1113     }
1114   }
1115 
1116   function mint(address user, uint amount) external {
1117     require(minters[msg.sender], '!minter');
1118     if (amount == 0) return;
1119     _updateReward(user);
1120     rewardToken.safeTransferFrom(rewardTokenVault, address(this), amount);
1121     if (user == address(this)) {
1122       // minting to this contract adds the new tokens as incentives for lockers
1123       _notifyReward(address(rewardToken), amount);
1124       return;
1125     }
1126     Balances storage bal = balances[user];
1127     bal.earned = bal.earned.add(amount);
1128     uint unlockTime = block.timestamp.div(rewardsDuration).mul(rewardsDuration).add(vestingDuration);
1129     LockedBalance[] storage earnings = userEarnings[user];
1130     uint idx = earnings.length;
1131     if (idx == 0 || earnings[idx-1].unlockTime < unlockTime) {
1132       earnings.push(LockedBalance({amount: amount, unlockTime: unlockTime}));
1133     } else {
1134       earnings[idx-1].amount = earnings[idx-1].amount.add(amount);
1135     }
1136     emit Minted(user, amount);
1137   }
1138 
1139   // Delegate exit
1140   function delegateExit(address delegatee) external {
1141     exitDelegatee[msg.sender] = delegatee;
1142   }
1143 
1144   // Withdraw full unlocked balance and optionally claim pending rewards
1145   function exitEarly(address onBehalfOf) external {
1146     require(onBehalfOf == msg.sender || exitDelegatee[onBehalfOf] == msg.sender);
1147     _updateReward(onBehalfOf);
1148     (uint amount, uint penaltyAmount,) = withdrawableBalance(onBehalfOf);
1149     delete userEarnings[onBehalfOf];
1150     Balances storage bal = balances[onBehalfOf];
1151     bal.earned = 0;
1152     rewardToken.safeTransfer(onBehalfOf, amount);
1153     if (penaltyAmount > 0) {
1154       incentivesController.claim(address(this), new address[](0));
1155       _notifyReward(address(rewardToken), penaltyAmount);
1156     }
1157     emit ExitedEarly(onBehalfOf, amount, penaltyAmount);
1158   }
1159 
1160   // Withdraw staked tokens
1161   function withdraw() public {
1162     _updateReward(msg.sender);
1163     Balances storage bal = balances[msg.sender];
1164     uint earned = bal.earned;
1165     uint amount;
1166     if (earned > 0) {
1167       uint length = userEarnings[msg.sender].length;
1168       for (uint i = 0; i < length; i++) {
1169         uint earnedAmount = userEarnings[msg.sender][i].amount;
1170         if (earnedAmount == 0) continue;
1171         if (userEarnings[msg.sender][i].unlockTime > block.timestamp) {
1172           break;
1173         }
1174         amount = amount.add(earnedAmount);
1175         delete userEarnings[msg.sender][i];
1176       }
1177       if (userEarnings[msg.sender].length == 0) {
1178         delete userEarnings[msg.sender];
1179       }
1180     }
1181     if (amount > 0) {
1182       rewardToken.safeTransfer(msg.sender, amount);
1183       emit Withdrawn(msg.sender, amount);
1184     }
1185   }
1186 
1187   // Transfer rewards to wallet
1188   function getReward(address[] memory _rewardTokens) public {
1189     _updateReward(msg.sender);
1190     _getReward(_rewardTokens);
1191   }
1192 
1193   function lastTimeRewardApplicable(address _rewardsToken) public view returns (uint) {
1194     uint periodFinish = rewardData[_rewardsToken].periodFinish;
1195     return block.timestamp < periodFinish ? block.timestamp : periodFinish;
1196   }
1197 
1198   function _getReward(address[] memory _rewardTokens) internal {
1199     uint length = _rewardTokens.length;
1200     for (uint i; i < length; i++) {
1201       address token = _rewardTokens[i];
1202       uint reward = rewards[msg.sender][token].div(1e12);
1203       if (token != address(rewardToken)) {
1204         // for rewards other than rewardToken, every 24 hours we check if new
1205         // rewards were sent to the contract or accrued via uToken interest
1206         Reward storage r = rewardData[token];
1207         uint periodFinish = r.periodFinish;
1208         require(periodFinish > 0, "Unknown reward token");
1209         uint balance = r.balance;
1210         if (periodFinish < block.timestamp.add(rewardsDuration - rewardLookback)) {
1211           uint unseen = IERC20(token).balanceOf(address(this)).sub(balance);
1212           if (unseen > 0) {
1213             _notifyReward(token, unseen);
1214             balance = balance.add(unseen);
1215           }
1216         }
1217         r.balance = balance.sub(reward);
1218       }
1219       if (reward == 0) continue;
1220       rewards[msg.sender][token] = 0;
1221       IERC20(token).safeTransfer(msg.sender, reward);
1222       emit RewardPaid(msg.sender, token, reward);
1223     }
1224   }
1225 
1226   function _rewardPerToken(address _rewardsToken, uint _supply) internal view returns (uint) {
1227     if (_supply == 0) {
1228       return rewardData[_rewardsToken].rewardPerTokenStored;
1229     }
1230     return rewardData[_rewardsToken].rewardPerTokenStored.add(
1231       lastTimeRewardApplicable(_rewardsToken)
1232       .sub(rewardData[_rewardsToken].lastUpdateTime)
1233       .mul(rewardData[_rewardsToken].rewardRate)
1234       .mul(1e18).div(_supply)
1235     );
1236   }
1237 
1238   function _earned(
1239     address _user,
1240     address _rewardsToken,
1241     uint _balance,
1242     uint _currentRewardPerToken
1243   ) internal view returns (uint) {
1244     return _balance.mul(
1245       _currentRewardPerToken.sub(userRewardPerTokenPaid[_user][_rewardsToken])
1246     ).div(1e18).add(rewards[_user][_rewardsToken]);
1247   }
1248 
1249   function _notifyReward(address _rewardsToken, uint _reward) internal {
1250     uint reward = _adjustReward(_rewardsToken, _reward);
1251     Reward storage r = rewardData[_rewardsToken];
1252     if (block.timestamp >= r.periodFinish) {
1253       r.rewardRate = reward.mul(1e12).div(rewardsDuration);
1254     } else {
1255       uint remaining = r.periodFinish.sub(block.timestamp);
1256       uint leftover = remaining.mul(r.rewardRate).div(1e12);
1257       r.rewardRate = reward.add(leftover).mul(1e12).div(rewardsDuration);
1258     }
1259     r.lastUpdateTime = block.timestamp;
1260     r.periodFinish = block.timestamp.add(rewardsDuration);
1261   }
1262 
1263   function _updateReward(address account) internal {
1264     uint length = rewardTokens.length;
1265     for (uint i = 0; i < length; i++) {
1266       address token = rewardTokens[i];
1267       Reward storage r = rewardData[token];
1268       uint rpt = _rewardPerToken(token, lockedSupply);
1269       r.rewardPerTokenStored = rpt;
1270       r.lastUpdateTime = lastTimeRewardApplicable(token);
1271       if (account != address(this)) {
1272         rewards[account][token] = _earned(account, token, balances[account].locked, rpt);
1273         userRewardPerTokenPaid[account][token] = rpt;
1274       }
1275     }
1276   }
1277 
1278   function _adjustReward(address _rewardsToken, uint reward) internal returns (uint adjustedAmount) {
1279     if (reward > 0 && teamRewardVault != address(0) && _rewardsToken != address(rewardToken)) {
1280       uint fee = reward.div(10000).mul(teamRewardFee);
1281       adjustedAmount = reward.sub(fee);
1282       IERC20(_rewardsToken).safeTransfer(teamRewardVault, fee);
1283     } else {
1284       adjustedAmount = reward;
1285     }
1286   }
1287 }