1 // Sources flattened with hardhat v2.10.1 https://hardhat.org
2 
3 // File contracts/interfaces/IMultiFeeDistribution.sol
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity ^0.8.0;
7 
8 interface IMultiFeeDistribution {
9   function mint(address user, uint256 amount) external;
10 }
11 
12 
13 // File contracts/interfaces/IOnwardIncentivesController.sol
14 
15 
16 pragma solidity ^0.8.0;
17 
18 interface IOnwardIncentivesController {
19   function handleAction(address _token, address _user, uint256 _balance, uint256 _totalSupply) external;
20 }
21 
22 
23 // File contracts/interfaces/IChefIncentivesController.sol
24 
25 
26 pragma solidity ^0.8.0;
27 
28 interface IChefIncentivesController {
29   function handleAction(address user, uint256 userBalance, uint256 totalSupply) external;
30   function addPool(address _token, uint256 _allocPoint) external;
31   function claim(address _user, address[] calldata _tokens) external;
32   function setClaimReceiver(address _user, address _receiver) external;
33 }
34 
35 
36 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3
37 
38 
39 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
40 
41 pragma solidity ^0.8.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Emitted when `value` tokens are moved from one account (`from`) to
49      * another (`to`).
50      *
51      * Note that `value` may be zero.
52      */
53     event Transfer(address indexed from, address indexed to, uint256 value);
54 
55     /**
56      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
57      * a call to {approve}. `value` is the new allowance.
58      */
59     event Approval(address indexed owner, address indexed spender, uint256 value);
60 
61     /**
62      * @dev Returns the amount of tokens in existence.
63      */
64     function totalSupply() external view returns (uint256);
65 
66     /**
67      * @dev Returns the amount of tokens owned by `account`.
68      */
69     function balanceOf(address account) external view returns (uint256);
70 
71     /**
72      * @dev Moves `amount` tokens from the caller's account to `to`.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transfer(address to, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Returns the remaining number of tokens that `spender` will be
82      * allowed to spend on behalf of `owner` through {transferFrom}. This is
83      * zero by default.
84      *
85      * This value changes when {approve} or {transferFrom} are called.
86      */
87     function allowance(address owner, address spender) external view returns (uint256);
88 
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * IMPORTANT: Beware that changing an allowance with this method brings the risk
95      * that someone may use both the old and the new allowance by unfortunate
96      * transaction ordering. One possible solution to mitigate this race
97      * condition is to first reduce the spender's allowance to 0 and set the
98      * desired value afterwards:
99      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
100      *
101      * Emits an {Approval} event.
102      */
103     function approve(address spender, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Moves `amount` tokens from `from` to `to` using the
107      * allowance mechanism. `amount` is then deducted from the caller's
108      * allowance.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transferFrom(
115         address from,
116         address to,
117         uint256 amount
118     ) external returns (bool);
119 }
120 
121 
122 // File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3
123 
124 
125 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
131  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
132  *
133  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
134  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
135  * need to send a transaction, and thus is not required to hold Ether at all.
136  */
137 interface IERC20Permit {
138     /**
139      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
140      * given ``owner``'s signed approval.
141      *
142      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
143      * ordering also apply here.
144      *
145      * Emits an {Approval} event.
146      *
147      * Requirements:
148      *
149      * - `spender` cannot be the zero address.
150      * - `deadline` must be a timestamp in the future.
151      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
152      * over the EIP712-formatted function arguments.
153      * - the signature must use ``owner``'s current nonce (see {nonces}).
154      *
155      * For more information on the signature format, see the
156      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
157      * section].
158      */
159     function permit(
160         address owner,
161         address spender,
162         uint256 value,
163         uint256 deadline,
164         uint8 v,
165         bytes32 r,
166         bytes32 s
167     ) external;
168 
169     /**
170      * @dev Returns the current nonce for `owner`. This value must be
171      * included whenever a signature is generated for {permit}.
172      *
173      * Every successful call to {permit} increases ``owner``'s nonce by one. This
174      * prevents a signature from being used multiple times.
175      */
176     function nonces(address owner) external view returns (uint256);
177 
178     /**
179      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
180      */
181     // solhint-disable-next-line func-name-mixedcase
182     function DOMAIN_SEPARATOR() external view returns (bytes32);
183 }
184 
185 
186 // File @openzeppelin/contracts/utils/Address.sol@v4.7.3
187 
188 
189 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
190 
191 pragma solidity ^0.8.1;
192 
193 /**
194  * @dev Collection of functions related to the address type
195  */
196 library Address {
197     /**
198      * @dev Returns true if `account` is a contract.
199      *
200      * [IMPORTANT]
201      * ====
202      * It is unsafe to assume that an address for which this function returns
203      * false is an externally-owned account (EOA) and not a contract.
204      *
205      * Among others, `isContract` will return false for the following
206      * types of addresses:
207      *
208      *  - an externally-owned account
209      *  - a contract in construction
210      *  - an address where a contract will be created
211      *  - an address where a contract lived, but was destroyed
212      * ====
213      *
214      * [IMPORTANT]
215      * ====
216      * You shouldn't rely on `isContract` to protect against flash loan attacks!
217      *
218      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
219      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
220      * constructor.
221      * ====
222      */
223     function isContract(address account) internal view returns (bool) {
224         // This method relies on extcodesize/address.code.length, which returns 0
225         // for contracts in construction, since the code is only stored at the end
226         // of the constructor execution.
227 
228         return account.code.length > 0;
229     }
230 
231     /**
232      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
233      * `recipient`, forwarding all available gas and reverting on errors.
234      *
235      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
236      * of certain opcodes, possibly making contracts go over the 2300 gas limit
237      * imposed by `transfer`, making them unable to receive funds via
238      * `transfer`. {sendValue} removes this limitation.
239      *
240      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
241      *
242      * IMPORTANT: because control is transferred to `recipient`, care must be
243      * taken to not create reentrancy vulnerabilities. Consider using
244      * {ReentrancyGuard} or the
245      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
246      */
247     function sendValue(address payable recipient, uint256 amount) internal {
248         require(address(this).balance >= amount, "Address: insufficient balance");
249 
250         (bool success, ) = recipient.call{value: amount}("");
251         require(success, "Address: unable to send value, recipient may have reverted");
252     }
253 
254     /**
255      * @dev Performs a Solidity function call using a low level `call`. A
256      * plain `call` is an unsafe replacement for a function call: use this
257      * function instead.
258      *
259      * If `target` reverts with a revert reason, it is bubbled up by this
260      * function (like regular Solidity function calls).
261      *
262      * Returns the raw returned data. To convert to the expected return value,
263      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
264      *
265      * Requirements:
266      *
267      * - `target` must be a contract.
268      * - calling `target` with `data` must not revert.
269      *
270      * _Available since v3.1._
271      */
272     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
273         return functionCall(target, data, "Address: low-level call failed");
274     }
275 
276     /**
277      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
278      * `errorMessage` as a fallback revert reason when `target` reverts.
279      *
280      * _Available since v3.1._
281      */
282     function functionCall(
283         address target,
284         bytes memory data,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         return functionCallWithValue(target, data, 0, errorMessage);
288     }
289 
290     /**
291      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
292      * but also transferring `value` wei to `target`.
293      *
294      * Requirements:
295      *
296      * - the calling contract must have an ETH balance of at least `value`.
297      * - the called Solidity function must be `payable`.
298      *
299      * _Available since v3.1._
300      */
301     function functionCallWithValue(
302         address target,
303         bytes memory data,
304         uint256 value
305     ) internal returns (bytes memory) {
306         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
311      * with `errorMessage` as a fallback revert reason when `target` reverts.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(
316         address target,
317         bytes memory data,
318         uint256 value,
319         string memory errorMessage
320     ) internal returns (bytes memory) {
321         require(address(this).balance >= value, "Address: insufficient balance for call");
322         require(isContract(target), "Address: call to non-contract");
323 
324         (bool success, bytes memory returndata) = target.call{value: value}(data);
325         return verifyCallResult(success, returndata, errorMessage);
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
330      * but performing a static call.
331      *
332      * _Available since v3.3._
333      */
334     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
335         return functionStaticCall(target, data, "Address: low-level static call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
340      * but performing a static call.
341      *
342      * _Available since v3.3._
343      */
344     function functionStaticCall(
345         address target,
346         bytes memory data,
347         string memory errorMessage
348     ) internal view returns (bytes memory) {
349         require(isContract(target), "Address: static call to non-contract");
350 
351         (bool success, bytes memory returndata) = target.staticcall(data);
352         return verifyCallResult(success, returndata, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but performing a delegate call.
358      *
359      * _Available since v3.4._
360      */
361     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
367      * but performing a delegate call.
368      *
369      * _Available since v3.4._
370      */
371     function functionDelegateCall(
372         address target,
373         bytes memory data,
374         string memory errorMessage
375     ) internal returns (bytes memory) {
376         require(isContract(target), "Address: delegate call to non-contract");
377 
378         (bool success, bytes memory returndata) = target.delegatecall(data);
379         return verifyCallResult(success, returndata, errorMessage);
380     }
381 
382     /**
383      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
384      * revert reason using the provided one.
385      *
386      * _Available since v4.3._
387      */
388     function verifyCallResult(
389         bool success,
390         bytes memory returndata,
391         string memory errorMessage
392     ) internal pure returns (bytes memory) {
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399                 /// @solidity memory-safe-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 
412 // File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3
413 
414 
415 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
416 
417 pragma solidity ^0.8.0;
418 
419 
420 
421 /**
422  * @title SafeERC20
423  * @dev Wrappers around ERC20 operations that throw on failure (when the token
424  * contract returns false). Tokens that return no value (and instead revert or
425  * throw on failure) are also supported, non-reverting calls are assumed to be
426  * successful.
427  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
428  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
429  */
430 library SafeERC20 {
431     using Address for address;
432 
433     function safeTransfer(
434         IERC20 token,
435         address to,
436         uint256 value
437     ) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
439     }
440 
441     function safeTransferFrom(
442         IERC20 token,
443         address from,
444         address to,
445         uint256 value
446     ) internal {
447         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
448     }
449 
450     /**
451      * @dev Deprecated. This function has issues similar to the ones found in
452      * {IERC20-approve}, and its usage is discouraged.
453      *
454      * Whenever possible, use {safeIncreaseAllowance} and
455      * {safeDecreaseAllowance} instead.
456      */
457     function safeApprove(
458         IERC20 token,
459         address spender,
460         uint256 value
461     ) internal {
462         // safeApprove should only be called when setting an initial allowance,
463         // or when resetting it to zero. To increase and decrease it, use
464         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
465         require(
466             (value == 0) || (token.allowance(address(this), spender) == 0),
467             "SafeERC20: approve from non-zero to non-zero allowance"
468         );
469         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
470     }
471 
472     function safeIncreaseAllowance(
473         IERC20 token,
474         address spender,
475         uint256 value
476     ) internal {
477         uint256 newAllowance = token.allowance(address(this), spender) + value;
478         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
479     }
480 
481     function safeDecreaseAllowance(
482         IERC20 token,
483         address spender,
484         uint256 value
485     ) internal {
486         unchecked {
487             uint256 oldAllowance = token.allowance(address(this), spender);
488             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
489             uint256 newAllowance = oldAllowance - value;
490             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
491         }
492     }
493 
494     function safePermit(
495         IERC20Permit token,
496         address owner,
497         address spender,
498         uint256 value,
499         uint256 deadline,
500         uint8 v,
501         bytes32 r,
502         bytes32 s
503     ) internal {
504         uint256 nonceBefore = token.nonces(owner);
505         token.permit(owner, spender, value, deadline, v, r, s);
506         uint256 nonceAfter = token.nonces(owner);
507         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
508     }
509 
510     /**
511      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
512      * on the return value: the return value is optional (but if data is returned, it must not be false).
513      * @param token The token targeted by the call.
514      * @param data The call data (encoded using abi.encode or one of its variants).
515      */
516     function _callOptionalReturn(IERC20 token, bytes memory data) private {
517         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
518         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
519         // the target address contains contract code and also asserts for success in the low-level call.
520 
521         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
522         if (returndata.length > 0) {
523             // Return data is optional
524             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
525         }
526     }
527 }
528 
529 
530 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.7.3
531 
532 
533 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 // CAUTION
538 // This version of SafeMath should only be used with Solidity 0.8 or later,
539 // because it relies on the compiler's built in overflow checks.
540 
541 /**
542  * @dev Wrappers over Solidity's arithmetic operations.
543  *
544  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
545  * now has built in overflow checking.
546  */
547 library SafeMath {
548     /**
549      * @dev Returns the addition of two unsigned integers, with an overflow flag.
550      *
551      * _Available since v3.4._
552      */
553     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
554         unchecked {
555             uint256 c = a + b;
556             if (c < a) return (false, 0);
557             return (true, c);
558         }
559     }
560 
561     /**
562      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
563      *
564      * _Available since v3.4._
565      */
566     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
567         unchecked {
568             if (b > a) return (false, 0);
569             return (true, a - b);
570         }
571     }
572 
573     /**
574      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
575      *
576      * _Available since v3.4._
577      */
578     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         unchecked {
580             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
581             // benefit is lost if 'b' is also tested.
582             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
583             if (a == 0) return (true, 0);
584             uint256 c = a * b;
585             if (c / a != b) return (false, 0);
586             return (true, c);
587         }
588     }
589 
590     /**
591      * @dev Returns the division of two unsigned integers, with a division by zero flag.
592      *
593      * _Available since v3.4._
594      */
595     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
596         unchecked {
597             if (b == 0) return (false, 0);
598             return (true, a / b);
599         }
600     }
601 
602     /**
603      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
604      *
605      * _Available since v3.4._
606      */
607     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
608         unchecked {
609             if (b == 0) return (false, 0);
610             return (true, a % b);
611         }
612     }
613 
614     /**
615      * @dev Returns the addition of two unsigned integers, reverting on
616      * overflow.
617      *
618      * Counterpart to Solidity's `+` operator.
619      *
620      * Requirements:
621      *
622      * - Addition cannot overflow.
623      */
624     function add(uint256 a, uint256 b) internal pure returns (uint256) {
625         return a + b;
626     }
627 
628     /**
629      * @dev Returns the subtraction of two unsigned integers, reverting on
630      * overflow (when the result is negative).
631      *
632      * Counterpart to Solidity's `-` operator.
633      *
634      * Requirements:
635      *
636      * - Subtraction cannot overflow.
637      */
638     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a - b;
640     }
641 
642     /**
643      * @dev Returns the multiplication of two unsigned integers, reverting on
644      * overflow.
645      *
646      * Counterpart to Solidity's `*` operator.
647      *
648      * Requirements:
649      *
650      * - Multiplication cannot overflow.
651      */
652     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a * b;
654     }
655 
656     /**
657      * @dev Returns the integer division of two unsigned integers, reverting on
658      * division by zero. The result is rounded towards zero.
659      *
660      * Counterpart to Solidity's `/` operator.
661      *
662      * Requirements:
663      *
664      * - The divisor cannot be zero.
665      */
666     function div(uint256 a, uint256 b) internal pure returns (uint256) {
667         return a / b;
668     }
669 
670     /**
671      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
672      * reverting when dividing by zero.
673      *
674      * Counterpart to Solidity's `%` operator. This function uses a `revert`
675      * opcode (which leaves remaining gas untouched) while Solidity uses an
676      * invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
683         return a % b;
684     }
685 
686     /**
687      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
688      * overflow (when the result is negative).
689      *
690      * CAUTION: This function is deprecated because it requires allocating memory for the error
691      * message unnecessarily. For custom revert reasons use {trySub}.
692      *
693      * Counterpart to Solidity's `-` operator.
694      *
695      * Requirements:
696      *
697      * - Subtraction cannot overflow.
698      */
699     function sub(
700         uint256 a,
701         uint256 b,
702         string memory errorMessage
703     ) internal pure returns (uint256) {
704         unchecked {
705             require(b <= a, errorMessage);
706             return a - b;
707         }
708     }
709 
710     /**
711      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
712      * division by zero. The result is rounded towards zero.
713      *
714      * Counterpart to Solidity's `/` operator. Note: this function uses a
715      * `revert` opcode (which leaves remaining gas untouched) while Solidity
716      * uses an invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function div(
723         uint256 a,
724         uint256 b,
725         string memory errorMessage
726     ) internal pure returns (uint256) {
727         unchecked {
728             require(b > 0, errorMessage);
729             return a / b;
730         }
731     }
732 
733     /**
734      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
735      * reverting with custom message when dividing by zero.
736      *
737      * CAUTION: This function is deprecated because it requires allocating memory for the error
738      * message unnecessarily. For custom revert reasons use {tryMod}.
739      *
740      * Counterpart to Solidity's `%` operator. This function uses a `revert`
741      * opcode (which leaves remaining gas untouched) while Solidity uses an
742      * invalid opcode to revert (consuming all remaining gas).
743      *
744      * Requirements:
745      *
746      * - The divisor cannot be zero.
747      */
748     function mod(
749         uint256 a,
750         uint256 b,
751         string memory errorMessage
752     ) internal pure returns (uint256) {
753         unchecked {
754             require(b > 0, errorMessage);
755             return a % b;
756         }
757     }
758 }
759 
760 
761 // File @openzeppelin/contracts/utils/Context.sol@v4.7.3
762 
763 
764 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
765 
766 pragma solidity ^0.8.0;
767 
768 /**
769  * @dev Provides information about the current execution context, including the
770  * sender of the transaction and its data. While these are generally available
771  * via msg.sender and msg.data, they should not be accessed in such a direct
772  * manner, since when dealing with meta-transactions the account sending and
773  * paying for execution may not be the actual sender (as far as an application
774  * is concerned).
775  *
776  * This contract is only required for intermediate, library-like contracts.
777  */
778 abstract contract Context {
779     function _msgSender() internal view virtual returns (address) {
780         return msg.sender;
781     }
782 
783     function _msgData() internal view virtual returns (bytes calldata) {
784         return msg.data;
785     }
786 }
787 
788 
789 // File @openzeppelin/contracts/access/Ownable.sol@v4.7.3
790 
791 
792 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
793 
794 pragma solidity ^0.8.0;
795 
796 /**
797  * @dev Contract module which provides a basic access control mechanism, where
798  * there is an account (an owner) that can be granted exclusive access to
799  * specific functions.
800  *
801  * By default, the owner account will be the one that deploys the contract. This
802  * can later be changed with {transferOwnership}.
803  *
804  * This module is used through inheritance. It will make available the modifier
805  * `onlyOwner`, which can be applied to your functions to restrict their use to
806  * the owner.
807  */
808 abstract contract Ownable is Context {
809     address private _owner;
810 
811     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
812 
813     /**
814      * @dev Initializes the contract setting the deployer as the initial owner.
815      */
816     constructor() {
817         _transferOwnership(_msgSender());
818     }
819 
820     /**
821      * @dev Throws if called by any account other than the owner.
822      */
823     modifier onlyOwner() {
824         _checkOwner();
825         _;
826     }
827 
828     /**
829      * @dev Returns the address of the current owner.
830      */
831     function owner() public view virtual returns (address) {
832         return _owner;
833     }
834 
835     /**
836      * @dev Throws if the sender is not the owner.
837      */
838     function _checkOwner() internal view virtual {
839         require(owner() == _msgSender(), "Ownable: caller is not the owner");
840     }
841 
842     /**
843      * @dev Leaves the contract without owner. It will not be possible to call
844      * `onlyOwner` functions anymore. Can only be called by the current owner.
845      *
846      * NOTE: Renouncing ownership will leave the contract without an owner,
847      * thereby removing any functionality that is only available to the owner.
848      */
849     function renounceOwnership() public virtual onlyOwner {
850         _transferOwnership(address(0));
851     }
852 
853     /**
854      * @dev Transfers ownership of the contract to a new account (`newOwner`).
855      * Can only be called by the current owner.
856      */
857     function transferOwnership(address newOwner) public virtual onlyOwner {
858         require(newOwner != address(0), "Ownable: new owner is the zero address");
859         _transferOwnership(newOwner);
860     }
861 
862     /**
863      * @dev Transfers ownership of the contract to a new account (`newOwner`).
864      * Internal function without access restriction.
865      */
866     function _transferOwnership(address newOwner) internal virtual {
867         address oldOwner = _owner;
868         _owner = newOwner;
869         emit OwnershipTransferred(oldOwner, newOwner);
870     }
871 }
872 
873 
874 // File contracts/ChefIncentivesController.sol
875 
876 
877 pragma solidity ^0.8.0;
878 
879 
880 
881 
882 
883 
884 contract ChefIncentivesController is Ownable {
885   using SafeMath for uint256;
886   using SafeERC20 for IERC20;
887 
888   // Info of each user.
889   struct UserInfo {
890     uint256 amount;
891     uint256 rewardDebt;
892   }
893   // Info of each pool.
894   struct PoolInfo {
895     uint256 totalSupply;
896     uint256 allocPoint; // How many allocation points assigned to this pool.
897     uint256 lastRewardTime; // Last second that reward distribution occurs.
898     uint256 accRewardPerShare; // Accumulated rewards per share, times 1e12. See below.
899     IOnwardIncentivesController onwardIncentives;
900   }
901   // Info about token emissions for a given time period.
902   struct EmissionPoint {
903     uint128 startTimeOffset;
904     uint128 rewardsPerSecond;
905   }
906 
907   address public poolConfigurator;
908 
909   IMultiFeeDistribution public rewardMinter;
910   uint256 public rewardsPerSecond;
911   uint256 public immutable maxMintableTokens;
912   uint256 public mintedTokens;
913 
914   // Info of each pool.
915   address[] public registeredTokens;
916   mapping(address => PoolInfo) public poolInfo;
917 
918   // Data about the future reward rates. emissionSchedule stored in reverse chronological order,
919   // whenever the number of blocks since the start block exceeds the next block offset a new
920   // reward rate is applied.
921   EmissionPoint[] public emissionSchedule;
922   // token => user => Info of each user that stakes LP tokens.
923   mapping(address => mapping(address => UserInfo)) public userInfo;
924   // user => base claimable balance
925   mapping(address => uint256) public userBaseClaimable;
926   // Total allocation poitns. Must be the sum of all allocation points in all pools.
927   uint256 public totalAllocPoint = 0;
928   // The block number when reward mining starts.
929   uint256 public startTime;
930 
931   // account earning rewards => receiver of rewards for this account
932   // if receiver is set to address(0), rewards are paid to the earner
933   // this is used to aid 3rd party contract integrations
934   mapping (address => address) public claimReceiver;
935 
936   event BalanceUpdated(
937     address indexed token,
938     address indexed user,
939     uint256 balance,
940     uint256 totalSupply
941   );
942 
943   constructor(
944     uint128[] memory _startTimeOffset,
945     uint128[] memory _rewardsPerSecond,
946     address _poolConfigurator,
947     IMultiFeeDistribution _rewardMinter,
948     uint256 _maxMintable
949   )
950     Ownable()
951   {
952     poolConfigurator = _poolConfigurator;
953     rewardMinter = _rewardMinter;
954     uint256 length = _startTimeOffset.length;
955     for (uint256 i = length; i > 0; i--) {
956       emissionSchedule.push(
957         EmissionPoint({
958           startTimeOffset: _startTimeOffset[i - 1],
959           rewardsPerSecond: _rewardsPerSecond[i - 1]
960         })
961       );
962     }
963     maxMintableTokens = _maxMintable;
964   }
965 
966   // Start the party
967   function start() public onlyOwner {
968     require(startTime == 0);
969     startTime = block.timestamp;
970   }
971 
972   // Add a new lp to the pool. Can only be called by the poolConfigurator.
973   function addPool(address _token, uint256 _allocPoint) external {
974     require(msg.sender == poolConfigurator);
975     require(poolInfo[_token].lastRewardTime == 0);
976     _updateEmissions();
977     totalAllocPoint = totalAllocPoint.add(_allocPoint);
978     registeredTokens.push(_token);
979     poolInfo[_token] = PoolInfo({
980       totalSupply: 0,
981       allocPoint: _allocPoint,
982       lastRewardTime: block.timestamp,
983       accRewardPerShare: 0,
984       onwardIncentives: IOnwardIncentivesController(address(0))
985     });
986   }
987 
988   // Update the given pool's allocation point. Can only be called by the owner.
989   function batchUpdateAllocPoint(
990     address[] calldata _tokens,
991     uint256[] calldata _allocPoints
992   ) public onlyOwner {
993     require(_tokens.length == _allocPoints.length);
994     _massUpdatePools();
995     uint256 _totalAllocPoint = totalAllocPoint;
996     for (uint256 i = 0; i < _tokens.length; i++) {
997       PoolInfo storage pool = poolInfo[_tokens[i]];
998       require(pool.lastRewardTime > 0);
999       _totalAllocPoint = _totalAllocPoint.sub(pool.allocPoint).add(_allocPoints[i]);
1000       pool.allocPoint = _allocPoints[i];
1001     }
1002     totalAllocPoint = _totalAllocPoint;
1003   }
1004 
1005   function setOnwardIncentives(
1006     address _token,
1007     IOnwardIncentivesController _incentives
1008   )
1009     external
1010     onlyOwner
1011   {
1012     require(poolInfo[_token].lastRewardTime != 0);
1013     poolInfo[_token].onwardIncentives = _incentives;
1014   }
1015 
1016   function setClaimReceiver(address _user, address _receiver) external {
1017     require(msg.sender == _user || msg.sender == owner());
1018     claimReceiver[_user] = _receiver;
1019   }
1020 
1021   function poolLength() external view returns (uint256) {
1022     return registeredTokens.length;
1023   }
1024 
1025   function claimableReward(address _user, address[] calldata _tokens)
1026     external
1027     view
1028     returns (uint256[] memory)
1029   {
1030     uint256[] memory claimable = new uint256[](_tokens.length);
1031     for (uint256 i = 0; i < _tokens.length; i++) {
1032       address token = _tokens[i];
1033       PoolInfo storage pool = poolInfo[token];
1034       UserInfo storage user = userInfo[token][_user];
1035       uint256 accRewardPerShare = pool.accRewardPerShare;
1036       uint256 lpSupply = pool.totalSupply;
1037       if (block.timestamp > pool.lastRewardTime && lpSupply != 0) {
1038         uint256 duration = block.timestamp.sub(pool.lastRewardTime);
1039         uint256 reward = duration.mul(rewardsPerSecond).mul(pool.allocPoint).div(totalAllocPoint);
1040         accRewardPerShare = accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
1041       }
1042       claimable[i] = user.amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
1043     }
1044     return claimable;
1045   }
1046 
1047   function _updateEmissions() internal {
1048     uint256 length = emissionSchedule.length;
1049     if (startTime > 0 && length > 0) {
1050       EmissionPoint memory e = emissionSchedule[length-1];
1051       if (block.timestamp.sub(startTime) > e.startTimeOffset) {
1052         _massUpdatePools();
1053         rewardsPerSecond = uint256(e.rewardsPerSecond);
1054         emissionSchedule.pop();
1055       }
1056     }
1057   }
1058 
1059   // Update reward variables for all pools
1060   function _massUpdatePools() internal {
1061     uint256 totalAP = totalAllocPoint;
1062     uint256 length = registeredTokens.length;
1063     for (uint256 i = 0; i < length; ++i) {
1064       _updatePool(poolInfo[registeredTokens[i]], totalAP);
1065     }
1066   }
1067 
1068   // Update reward variables of the given pool to be up-to-date.
1069   function _updatePool(PoolInfo storage pool, uint256 _totalAllocPoint) internal {
1070     if (block.timestamp <= pool.lastRewardTime) {
1071       return;
1072     }
1073     uint256 lpSupply = pool.totalSupply;
1074     if (lpSupply == 0) {
1075       pool.lastRewardTime = block.timestamp;
1076       return;
1077     }
1078     uint256 duration = block.timestamp.sub(pool.lastRewardTime);
1079     uint256 reward = duration.mul(rewardsPerSecond).mul(pool.allocPoint).div(_totalAllocPoint);
1080     pool.accRewardPerShare = pool.accRewardPerShare.add(reward.mul(1e12).div(lpSupply));
1081     pool.lastRewardTime = block.timestamp;
1082   }
1083 
1084   function _mint(address _user, uint256 _amount) internal {
1085     uint256 minted = mintedTokens;
1086     if (minted.add(_amount) > maxMintableTokens) {
1087       _amount = maxMintableTokens.sub(minted);
1088     }
1089     if (_amount > 0) {
1090       mintedTokens = minted.add(_amount);
1091       address receiver = claimReceiver[_user];
1092       if (receiver == address(0)) receiver = _user;
1093       rewardMinter.mint(receiver, _amount);
1094     }
1095   }
1096 
1097   function handleAction(address _user, uint256 _balance, uint256 _totalSupply) external {
1098     PoolInfo storage pool = poolInfo[msg.sender];
1099     require(pool.lastRewardTime > 0);
1100     _updateEmissions();
1101     _updatePool(pool, totalAllocPoint);
1102     UserInfo storage user = userInfo[msg.sender][_user];
1103     uint256 amount = user.amount;
1104     uint256 accRewardPerShare = pool.accRewardPerShare;
1105     if (amount > 0) {
1106       uint256 pending = amount.mul(accRewardPerShare).div(1e12).sub(user.rewardDebt);
1107       if (pending > 0) {
1108         userBaseClaimable[_user] = userBaseClaimable[_user].add(pending);
1109       }
1110     }
1111     user.amount = _balance;
1112     user.rewardDebt = _balance.mul(accRewardPerShare).div(1e12);
1113     pool.totalSupply = _totalSupply;
1114     if (pool.onwardIncentives != IOnwardIncentivesController(address(0))) {
1115       pool.onwardIncentives.handleAction(msg.sender, _user, _balance, _totalSupply);
1116     }
1117     emit BalanceUpdated(msg.sender, _user, _balance, _totalSupply);
1118   }
1119 
1120   // Claim pending rewards for one or more pools.
1121   // Rewards are not received directly, they are minted by the rewardMinter.
1122   function claim(address _user, address[] calldata _tokens) external {
1123     _updateEmissions();
1124     uint256 pending = userBaseClaimable[_user];
1125     userBaseClaimable[_user] = 0;
1126     uint256 _totalAllocPoint = totalAllocPoint;
1127     for (uint i = 0; i < _tokens.length; i++) {
1128       PoolInfo storage pool = poolInfo[_tokens[i]];
1129       require(pool.lastRewardTime > 0);
1130       _updatePool(pool, _totalAllocPoint);
1131       UserInfo storage user = userInfo[_tokens[i]][_user];
1132       uint256 rewardDebt = user.amount.mul(pool.accRewardPerShare).div(1e12);
1133       pending = pending.add(rewardDebt.sub(user.rewardDebt));
1134       user.rewardDebt = rewardDebt;
1135     }
1136     _mint(_user, pending);
1137   }
1138 }