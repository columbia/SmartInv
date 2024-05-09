1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
5 
6 
7 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
13  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
14  *
15  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
16  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
17  * need to send a transaction, and thus is not required to hold Ether at all.
18  */
19 interface IERC20Permit {
20     /**
21      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
22      * given ``owner``'s signed approval.
23      *
24      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
25      * ordering also apply here.
26      *
27      * Emits an {Approval} event.
28      *
29      * Requirements:
30      *
31      * - `spender` cannot be the zero address.
32      * - `deadline` must be a timestamp in the future.
33      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
34      * over the EIP712-formatted function arguments.
35      * - the signature must use ``owner``'s current nonce (see {nonces}).
36      *
37      * For more information on the signature format, see the
38      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
39      * section].
40      */
41     function permit(
42         address owner,
43         address spender,
44         uint256 value,
45         uint256 deadline,
46         uint8 v,
47         bytes32 r,
48         bytes32 s
49     ) external;
50 
51     /**
52      * @dev Returns the current nonce for `owner`. This value must be
53      * included whenever a signature is generated for {permit}.
54      *
55      * Every successful call to {permit} increases ``owner``'s nonce by one. This
56      * prevents a signature from being used multiple times.
57      */
58     function nonces(address owner) external view returns (uint256);
59 
60     /**
61      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
62      */
63     // solhint-disable-next-line func-name-mixedcase
64     function DOMAIN_SEPARATOR() external view returns (bytes32);
65 }
66 
67 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC20 standard as defined in the EIP.
76  */
77 interface IERC20 {
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 
92     /**
93      * @dev Returns the amount of tokens in existence.
94      */
95     function totalSupply() external view returns (uint256);
96 
97     /**
98      * @dev Returns the amount of tokens owned by `account`.
99      */
100     function balanceOf(address account) external view returns (uint256);
101 
102     /**
103      * @dev Moves `amount` tokens from the caller's account to `to`.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transfer(address to, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Returns the remaining number of tokens that `spender` will be
113      * allowed to spend on behalf of `owner` through {transferFrom}. This is
114      * zero by default.
115      *
116      * This value changes when {approve} or {transferFrom} are called.
117      */
118     function allowance(address owner, address spender) external view returns (uint256);
119 
120     /**
121      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * IMPORTANT: Beware that changing an allowance with this method brings the risk
126      * that someone may use both the old and the new allowance by unfortunate
127      * transaction ordering. One possible solution to mitigate this race
128      * condition is to first reduce the spender's allowance to 0 and set the
129      * desired value afterwards:
130      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
131      *
132      * Emits an {Approval} event.
133      */
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Moves `amount` tokens from `from` to `to` using the
138      * allowance mechanism. `amount` is then deducted from the caller's
139      * allowance.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transferFrom(
146         address from,
147         address to,
148         uint256 amount
149     ) external returns (bool);
150 }
151 
152 // File: @openzeppelin/contracts/utils/Address.sol
153 
154 
155 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
156 
157 pragma solidity ^0.8.1;
158 
159 /**
160  * @dev Collection of functions related to the address type
161  */
162 library Address {
163     /**
164      * @dev Returns true if `account` is a contract.
165      *
166      * [IMPORTANT]
167      * ====
168      * It is unsafe to assume that an address for which this function returns
169      * false is an externally-owned account (EOA) and not a contract.
170      *
171      * Among others, `isContract` will return false for the following
172      * types of addresses:
173      *
174      *  - an externally-owned account
175      *  - a contract in construction
176      *  - an address where a contract will be created
177      *  - an address where a contract lived, but was destroyed
178      * ====
179      *
180      * [IMPORTANT]
181      * ====
182      * You shouldn't rely on `isContract` to protect against flash loan attacks!
183      *
184      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
185      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
186      * constructor.
187      * ====
188      */
189     function isContract(address account) internal view returns (bool) {
190         // This method relies on extcodesize/address.code.length, which returns 0
191         // for contracts in construction, since the code is only stored at the end
192         // of the constructor execution.
193 
194         return account.code.length > 0;
195     }
196 
197     /**
198      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
199      * `recipient`, forwarding all available gas and reverting on errors.
200      *
201      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
202      * of certain opcodes, possibly making contracts go over the 2300 gas limit
203      * imposed by `transfer`, making them unable to receive funds via
204      * `transfer`. {sendValue} removes this limitation.
205      *
206      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
207      *
208      * IMPORTANT: because control is transferred to `recipient`, care must be
209      * taken to not create reentrancy vulnerabilities. Consider using
210      * {ReentrancyGuard} or the
211      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
212      */
213     function sendValue(address payable recipient, uint256 amount) internal {
214         require(address(this).balance >= amount, "Address: insufficient balance");
215 
216         (bool success, ) = recipient.call{value: amount}("");
217         require(success, "Address: unable to send value, recipient may have reverted");
218     }
219 
220     /**
221      * @dev Performs a Solidity function call using a low level `call`. A
222      * plain `call` is an unsafe replacement for a function call: use this
223      * function instead.
224      *
225      * If `target` reverts with a revert reason, it is bubbled up by this
226      * function (like regular Solidity function calls).
227      *
228      * Returns the raw returned data. To convert to the expected return value,
229      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
230      *
231      * Requirements:
232      *
233      * - `target` must be a contract.
234      * - calling `target` with `data` must not revert.
235      *
236      * _Available since v3.1._
237      */
238     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
239         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
244      * `errorMessage` as a fallback revert reason when `target` reverts.
245      *
246      * _Available since v3.1._
247      */
248     function functionCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal returns (bytes memory) {
253         return functionCallWithValue(target, data, 0, errorMessage);
254     }
255 
256     /**
257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
258      * but also transferring `value` wei to `target`.
259      *
260      * Requirements:
261      *
262      * - the calling contract must have an ETH balance of at least `value`.
263      * - the called Solidity function must be `payable`.
264      *
265      * _Available since v3.1._
266      */
267     function functionCallWithValue(
268         address target,
269         bytes memory data,
270         uint256 value
271     ) internal returns (bytes memory) {
272         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
273     }
274 
275     /**
276      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
277      * with `errorMessage` as a fallback revert reason when `target` reverts.
278      *
279      * _Available since v3.1._
280      */
281     function functionCallWithValue(
282         address target,
283         bytes memory data,
284         uint256 value,
285         string memory errorMessage
286     ) internal returns (bytes memory) {
287         require(address(this).balance >= value, "Address: insufficient balance for call");
288         (bool success, bytes memory returndata) = target.call{value: value}(data);
289         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
290     }
291 
292     /**
293      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
294      * but performing a static call.
295      *
296      * _Available since v3.3._
297      */
298     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
299         return functionStaticCall(target, data, "Address: low-level static call failed");
300     }
301 
302     /**
303      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
304      * but performing a static call.
305      *
306      * _Available since v3.3._
307      */
308     function functionStaticCall(
309         address target,
310         bytes memory data,
311         string memory errorMessage
312     ) internal view returns (bytes memory) {
313         (bool success, bytes memory returndata) = target.staticcall(data);
314         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
315     }
316 
317     /**
318      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
319      * but performing a delegate call.
320      *
321      * _Available since v3.4._
322      */
323     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
324         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
325     }
326 
327     /**
328      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
329      * but performing a delegate call.
330      *
331      * _Available since v3.4._
332      */
333     function functionDelegateCall(
334         address target,
335         bytes memory data,
336         string memory errorMessage
337     ) internal returns (bytes memory) {
338         (bool success, bytes memory returndata) = target.delegatecall(data);
339         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
340     }
341 
342     /**
343      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
344      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
345      *
346      * _Available since v4.8._
347      */
348     function verifyCallResultFromTarget(
349         address target,
350         bool success,
351         bytes memory returndata,
352         string memory errorMessage
353     ) internal view returns (bytes memory) {
354         if (success) {
355             if (returndata.length == 0) {
356                 // only check isContract if the call was successful and the return data is empty
357                 // otherwise we already know that it was a contract
358                 require(isContract(target), "Address: call to non-contract");
359             }
360             return returndata;
361         } else {
362             _revert(returndata, errorMessage);
363         }
364     }
365 
366     /**
367      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
368      * revert reason or using the provided one.
369      *
370      * _Available since v4.3._
371      */
372     function verifyCallResult(
373         bool success,
374         bytes memory returndata,
375         string memory errorMessage
376     ) internal pure returns (bytes memory) {
377         if (success) {
378             return returndata;
379         } else {
380             _revert(returndata, errorMessage);
381         }
382     }
383 
384     function _revert(bytes memory returndata, string memory errorMessage) private pure {
385         // Look for revert reason and bubble it up if present
386         if (returndata.length > 0) {
387             // The easiest way to bubble the revert reason is using memory via assembly
388             /// @solidity memory-safe-assembly
389             assembly {
390                 let returndata_size := mload(returndata)
391                 revert(add(32, returndata), returndata_size)
392             }
393         } else {
394             revert(errorMessage);
395         }
396     }
397 }
398 
399 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
400 
401 
402 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
403 
404 pragma solidity ^0.8.0;
405 
406 
407 
408 
409 /**
410  * @title SafeERC20
411  * @dev Wrappers around ERC20 operations that throw on failure (when the token
412  * contract returns false). Tokens that return no value (and instead revert or
413  * throw on failure) are also supported, non-reverting calls are assumed to be
414  * successful.
415  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419     using Address for address;
420 
421     function safeTransfer(
422         IERC20 token,
423         address to,
424         uint256 value
425     ) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
427     }
428 
429     function safeTransferFrom(
430         IERC20 token,
431         address from,
432         address to,
433         uint256 value
434     ) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
436     }
437 
438     /**
439      * @dev Deprecated. This function has issues similar to the ones found in
440      * {IERC20-approve}, and its usage is discouraged.
441      *
442      * Whenever possible, use {safeIncreaseAllowance} and
443      * {safeDecreaseAllowance} instead.
444      */
445     function safeApprove(
446         IERC20 token,
447         address spender,
448         uint256 value
449     ) internal {
450         // safeApprove should only be called when setting an initial allowance,
451         // or when resetting it to zero. To increase and decrease it, use
452         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
453         require(
454             (value == 0) || (token.allowance(address(this), spender) == 0),
455             "SafeERC20: approve from non-zero to non-zero allowance"
456         );
457         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
458     }
459 
460     function safeIncreaseAllowance(
461         IERC20 token,
462         address spender,
463         uint256 value
464     ) internal {
465         uint256 newAllowance = token.allowance(address(this), spender) + value;
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467     }
468 
469     function safeDecreaseAllowance(
470         IERC20 token,
471         address spender,
472         uint256 value
473     ) internal {
474         unchecked {
475             uint256 oldAllowance = token.allowance(address(this), spender);
476             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
477             uint256 newAllowance = oldAllowance - value;
478             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
479         }
480     }
481 
482     function safePermit(
483         IERC20Permit token,
484         address owner,
485         address spender,
486         uint256 value,
487         uint256 deadline,
488         uint8 v,
489         bytes32 r,
490         bytes32 s
491     ) internal {
492         uint256 nonceBefore = token.nonces(owner);
493         token.permit(owner, spender, value, deadline, v, r, s);
494         uint256 nonceAfter = token.nonces(owner);
495         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
496     }
497 
498     /**
499      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
500      * on the return value: the return value is optional (but if data is returned, it must not be false).
501      * @param token The token targeted by the call.
502      * @param data The call data (encoded using abi.encode or one of its variants).
503      */
504     function _callOptionalReturn(IERC20 token, bytes memory data) private {
505         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
506         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
507         // the target address contains contract code and also asserts for success in the low-level call.
508 
509         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
510         if (returndata.length > 0) {
511             // Return data is optional
512             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
513         }
514     }
515 }
516 
517 // File: @openzeppelin/contracts/utils/math/Math.sol
518 
519 
520 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 /**
525  * @dev Standard math utilities missing in the Solidity language.
526  */
527 library Math {
528     enum Rounding {
529         Down, // Toward negative infinity
530         Up, // Toward infinity
531         Zero // Toward zero
532     }
533 
534     /**
535      * @dev Returns the largest of two numbers.
536      */
537     function max(uint256 a, uint256 b) internal pure returns (uint256) {
538         return a > b ? a : b;
539     }
540 
541     /**
542      * @dev Returns the smallest of two numbers.
543      */
544     function min(uint256 a, uint256 b) internal pure returns (uint256) {
545         return a < b ? a : b;
546     }
547 
548     /**
549      * @dev Returns the average of two numbers. The result is rounded towards
550      * zero.
551      */
552     function average(uint256 a, uint256 b) internal pure returns (uint256) {
553         // (a + b) / 2 can overflow.
554         return (a & b) + (a ^ b) / 2;
555     }
556 
557     /**
558      * @dev Returns the ceiling of the division of two numbers.
559      *
560      * This differs from standard division with `/` in that it rounds up instead
561      * of rounding down.
562      */
563     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
564         // (a + b - 1) / b can overflow on addition, so we distribute.
565         return a == 0 ? 0 : (a - 1) / b + 1;
566     }
567 
568     /**
569      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
570      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
571      * with further edits by Uniswap Labs also under MIT license.
572      */
573     function mulDiv(
574         uint256 x,
575         uint256 y,
576         uint256 denominator
577     ) internal pure returns (uint256 result) {
578         unchecked {
579             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
580             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
581             // variables such that product = prod1 * 2^256 + prod0.
582             uint256 prod0; // Least significant 256 bits of the product
583             uint256 prod1; // Most significant 256 bits of the product
584             assembly {
585                 let mm := mulmod(x, y, not(0))
586                 prod0 := mul(x, y)
587                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
588             }
589 
590             // Handle non-overflow cases, 256 by 256 division.
591             if (prod1 == 0) {
592                 return prod0 / denominator;
593             }
594 
595             // Make sure the result is less than 2^256. Also prevents denominator == 0.
596             require(denominator > prod1);
597 
598             ///////////////////////////////////////////////
599             // 512 by 256 division.
600             ///////////////////////////////////////////////
601 
602             // Make division exact by subtracting the remainder from [prod1 prod0].
603             uint256 remainder;
604             assembly {
605                 // Compute remainder using mulmod.
606                 remainder := mulmod(x, y, denominator)
607 
608                 // Subtract 256 bit number from 512 bit number.
609                 prod1 := sub(prod1, gt(remainder, prod0))
610                 prod0 := sub(prod0, remainder)
611             }
612 
613             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
614             // See https://cs.stackexchange.com/q/138556/92363.
615 
616             // Does not overflow because the denominator cannot be zero at this stage in the function.
617             uint256 twos = denominator & (~denominator + 1);
618             assembly {
619                 // Divide denominator by twos.
620                 denominator := div(denominator, twos)
621 
622                 // Divide [prod1 prod0] by twos.
623                 prod0 := div(prod0, twos)
624 
625                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
626                 twos := add(div(sub(0, twos), twos), 1)
627             }
628 
629             // Shift in bits from prod1 into prod0.
630             prod0 |= prod1 * twos;
631 
632             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
633             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
634             // four bits. That is, denominator * inv = 1 mod 2^4.
635             uint256 inverse = (3 * denominator) ^ 2;
636 
637             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
638             // in modular arithmetic, doubling the correct bits in each step.
639             inverse *= 2 - denominator * inverse; // inverse mod 2^8
640             inverse *= 2 - denominator * inverse; // inverse mod 2^16
641             inverse *= 2 - denominator * inverse; // inverse mod 2^32
642             inverse *= 2 - denominator * inverse; // inverse mod 2^64
643             inverse *= 2 - denominator * inverse; // inverse mod 2^128
644             inverse *= 2 - denominator * inverse; // inverse mod 2^256
645 
646             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
647             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
648             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
649             // is no longer required.
650             result = prod0 * inverse;
651             return result;
652         }
653     }
654 
655     /**
656      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
657      */
658     function mulDiv(
659         uint256 x,
660         uint256 y,
661         uint256 denominator,
662         Rounding rounding
663     ) internal pure returns (uint256) {
664         uint256 result = mulDiv(x, y, denominator);
665         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
666             result += 1;
667         }
668         return result;
669     }
670 
671     /**
672      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
673      *
674      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
675      */
676     function sqrt(uint256 a) internal pure returns (uint256) {
677         if (a == 0) {
678             return 0;
679         }
680 
681         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
682         //
683         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
684         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
685         //
686         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
687         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
688         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
689         //
690         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
691         uint256 result = 1 << (log2(a) >> 1);
692 
693         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
694         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
695         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
696         // into the expected uint128 result.
697         unchecked {
698             result = (result + a / result) >> 1;
699             result = (result + a / result) >> 1;
700             result = (result + a / result) >> 1;
701             result = (result + a / result) >> 1;
702             result = (result + a / result) >> 1;
703             result = (result + a / result) >> 1;
704             result = (result + a / result) >> 1;
705             return min(result, a / result);
706         }
707     }
708 
709     /**
710      * @notice Calculates sqrt(a), following the selected rounding direction.
711      */
712     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
713         unchecked {
714             uint256 result = sqrt(a);
715             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
716         }
717     }
718 
719     /**
720      * @dev Return the log in base 2, rounded down, of a positive value.
721      * Returns 0 if given 0.
722      */
723     function log2(uint256 value) internal pure returns (uint256) {
724         uint256 result = 0;
725         unchecked {
726             if (value >> 128 > 0) {
727                 value >>= 128;
728                 result += 128;
729             }
730             if (value >> 64 > 0) {
731                 value >>= 64;
732                 result += 64;
733             }
734             if (value >> 32 > 0) {
735                 value >>= 32;
736                 result += 32;
737             }
738             if (value >> 16 > 0) {
739                 value >>= 16;
740                 result += 16;
741             }
742             if (value >> 8 > 0) {
743                 value >>= 8;
744                 result += 8;
745             }
746             if (value >> 4 > 0) {
747                 value >>= 4;
748                 result += 4;
749             }
750             if (value >> 2 > 0) {
751                 value >>= 2;
752                 result += 2;
753             }
754             if (value >> 1 > 0) {
755                 result += 1;
756             }
757         }
758         return result;
759     }
760 
761     /**
762      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
763      * Returns 0 if given 0.
764      */
765     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
766         unchecked {
767             uint256 result = log2(value);
768             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
769         }
770     }
771 
772     /**
773      * @dev Return the log in base 10, rounded down, of a positive value.
774      * Returns 0 if given 0.
775      */
776     function log10(uint256 value) internal pure returns (uint256) {
777         uint256 result = 0;
778         unchecked {
779             if (value >= 10**64) {
780                 value /= 10**64;
781                 result += 64;
782             }
783             if (value >= 10**32) {
784                 value /= 10**32;
785                 result += 32;
786             }
787             if (value >= 10**16) {
788                 value /= 10**16;
789                 result += 16;
790             }
791             if (value >= 10**8) {
792                 value /= 10**8;
793                 result += 8;
794             }
795             if (value >= 10**4) {
796                 value /= 10**4;
797                 result += 4;
798             }
799             if (value >= 10**2) {
800                 value /= 10**2;
801                 result += 2;
802             }
803             if (value >= 10**1) {
804                 result += 1;
805             }
806         }
807         return result;
808     }
809 
810     /**
811      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
812      * Returns 0 if given 0.
813      */
814     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
815         unchecked {
816             uint256 result = log10(value);
817             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
818         }
819     }
820 
821     /**
822      * @dev Return the log in base 256, rounded down, of a positive value.
823      * Returns 0 if given 0.
824      *
825      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
826      */
827     function log256(uint256 value) internal pure returns (uint256) {
828         uint256 result = 0;
829         unchecked {
830             if (value >> 128 > 0) {
831                 value >>= 128;
832                 result += 16;
833             }
834             if (value >> 64 > 0) {
835                 value >>= 64;
836                 result += 8;
837             }
838             if (value >> 32 > 0) {
839                 value >>= 32;
840                 result += 4;
841             }
842             if (value >> 16 > 0) {
843                 value >>= 16;
844                 result += 2;
845             }
846             if (value >> 8 > 0) {
847                 result += 1;
848             }
849         }
850         return result;
851     }
852 
853     /**
854      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
855      * Returns 0 if given 0.
856      */
857     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
858         unchecked {
859             uint256 result = log256(value);
860             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
861         }
862     }
863 }
864 
865 // File: @openzeppelin/contracts/utils/Strings.sol
866 
867 
868 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
869 
870 pragma solidity ^0.8.0;
871 
872 
873 /**
874  * @dev String operations.
875  */
876 library Strings {
877     bytes16 private constant _SYMBOLS = "0123456789abcdef";
878     uint8 private constant _ADDRESS_LENGTH = 20;
879 
880     /**
881      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
882      */
883     function toString(uint256 value) internal pure returns (string memory) {
884         unchecked {
885             uint256 length = Math.log10(value) + 1;
886             string memory buffer = new string(length);
887             uint256 ptr;
888             /// @solidity memory-safe-assembly
889             assembly {
890                 ptr := add(buffer, add(32, length))
891             }
892             while (true) {
893                 ptr--;
894                 /// @solidity memory-safe-assembly
895                 assembly {
896                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
897                 }
898                 value /= 10;
899                 if (value == 0) break;
900             }
901             return buffer;
902         }
903     }
904 
905     /**
906      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
907      */
908     function toHexString(uint256 value) internal pure returns (string memory) {
909         unchecked {
910             return toHexString(value, Math.log256(value) + 1);
911         }
912     }
913 
914     /**
915      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
916      */
917     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
918         bytes memory buffer = new bytes(2 * length + 2);
919         buffer[0] = "0";
920         buffer[1] = "x";
921         for (uint256 i = 2 * length + 1; i > 1; --i) {
922             buffer[i] = _SYMBOLS[value & 0xf];
923             value >>= 4;
924         }
925         require(value == 0, "Strings: hex length insufficient");
926         return string(buffer);
927     }
928 
929     /**
930      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
931      */
932     function toHexString(address addr) internal pure returns (string memory) {
933         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
934     }
935 }
936 
937 // File: operator-filter-registry/src/lib/Constants.sol
938 
939 
940 pragma solidity ^0.8.17;
941 
942 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
943 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
944 
945 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
946 
947 
948 pragma solidity ^0.8.13;
949 
950 interface IOperatorFilterRegistry {
951     /**
952      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
953      *         true if supplied registrant address is not registered.
954      */
955     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
956 
957     /**
958      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
959      */
960     function register(address registrant) external;
961 
962     /**
963      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
964      */
965     function registerAndSubscribe(address registrant, address subscription) external;
966 
967     /**
968      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
969      *         address without subscribing.
970      */
971     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
972 
973     /**
974      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
975      *         Note that this does not remove any filtered addresses or codeHashes.
976      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
977      */
978     function unregister(address addr) external;
979 
980     /**
981      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
982      */
983     function updateOperator(address registrant, address operator, bool filtered) external;
984 
985     /**
986      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
987      */
988     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
989 
990     /**
991      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
992      */
993     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
994 
995     /**
996      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
997      */
998     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
999 
1000     /**
1001      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1002      *         subscription if present.
1003      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1004      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1005      *         used.
1006      */
1007     function subscribe(address registrant, address registrantToSubscribe) external;
1008 
1009     /**
1010      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1011      */
1012     function unsubscribe(address registrant, bool copyExistingEntries) external;
1013 
1014     /**
1015      * @notice Get the subscription address of a given registrant, if any.
1016      */
1017     function subscriptionOf(address addr) external returns (address registrant);
1018 
1019     /**
1020      * @notice Get the set of addresses subscribed to a given registrant.
1021      *         Note that order is not guaranteed as updates are made.
1022      */
1023     function subscribers(address registrant) external returns (address[] memory);
1024 
1025     /**
1026      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1027      *         Note that order is not guaranteed as updates are made.
1028      */
1029     function subscriberAt(address registrant, uint256 index) external returns (address);
1030 
1031     /**
1032      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1033      */
1034     function copyEntriesOf(address registrant, address registrantToCopy) external;
1035 
1036     /**
1037      * @notice Returns true if operator is filtered by a given address or its subscription.
1038      */
1039     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1040 
1041     /**
1042      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1043      */
1044     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1045 
1046     /**
1047      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1048      */
1049     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1050 
1051     /**
1052      * @notice Returns a list of filtered operators for a given address or its subscription.
1053      */
1054     function filteredOperators(address addr) external returns (address[] memory);
1055 
1056     /**
1057      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1058      *         Note that order is not guaranteed as updates are made.
1059      */
1060     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1061 
1062     /**
1063      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1064      *         its subscription.
1065      *         Note that order is not guaranteed as updates are made.
1066      */
1067     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1068 
1069     /**
1070      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1071      *         its subscription.
1072      *         Note that order is not guaranteed as updates are made.
1073      */
1074     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1075 
1076     /**
1077      * @notice Returns true if an address has registered
1078      */
1079     function isRegistered(address addr) external returns (bool);
1080 
1081     /**
1082      * @dev Convenience method to compute the code hash of an arbitrary contract
1083      */
1084     function codeHashOf(address addr) external returns (bytes32);
1085 }
1086 
1087 // File: operator-filter-registry/src/OperatorFilterer.sol
1088 
1089 
1090 pragma solidity ^0.8.13;
1091 
1092 
1093 /**
1094  * @title  OperatorFilterer
1095  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1096  *         registrant's entries in the OperatorFilterRegistry.
1097  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1098  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1099  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1100  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1101  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1102  *         will be locked to the options set during construction.
1103  */
1104 
1105 abstract contract OperatorFilterer {
1106     /// @dev Emitted when an operator is not allowed.
1107     error OperatorNotAllowed(address operator);
1108 
1109     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1110         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1111 
1112     /// @dev The constructor that is called when the contract is being deployed.
1113     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1114         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1115         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1116         // order for the modifier to filter addresses.
1117         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1118             if (subscribe) {
1119                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1120             } else {
1121                 if (subscriptionOrRegistrantToCopy != address(0)) {
1122                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1123                 } else {
1124                     OPERATOR_FILTER_REGISTRY.register(address(this));
1125                 }
1126             }
1127         }
1128     }
1129 
1130     /**
1131      * @dev A helper function to check if an operator is allowed.
1132      */
1133     modifier onlyAllowedOperator(address from) virtual {
1134         // Allow spending tokens from addresses with balance
1135         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1136         // from an EOA.
1137         if (from != msg.sender) {
1138             _checkFilterOperator(msg.sender);
1139         }
1140         _;
1141     }
1142 
1143     /**
1144      * @dev A helper function to check if an operator approval is allowed.
1145      */
1146     modifier onlyAllowedOperatorApproval(address operator) virtual {
1147         _checkFilterOperator(operator);
1148         _;
1149     }
1150 
1151     /**
1152      * @dev A helper function to check if an operator is allowed.
1153      */
1154     function _checkFilterOperator(address operator) internal view virtual {
1155         // Check registry code length to facilitate testing in environments without a deployed registry.
1156         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1157             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1158             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1159             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1160                 revert OperatorNotAllowed(operator);
1161             }
1162         }
1163     }
1164 }
1165 
1166 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
1167 
1168 
1169 pragma solidity ^0.8.13;
1170 
1171 
1172 /**
1173  * @title  DefaultOperatorFilterer
1174  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1175  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1176  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1177  *         will be locked to the options set during construction.
1178  */
1179 
1180 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1181     /// @dev The constructor that is called when the contract is being deployed.
1182     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1183 }
1184 
1185 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1186 
1187 
1188 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1189 
1190 pragma solidity ^0.8.0;
1191 
1192 /**
1193  * @dev Contract module that helps prevent reentrant calls to a function.
1194  *
1195  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1196  * available, which can be applied to functions to make sure there are no nested
1197  * (reentrant) calls to them.
1198  *
1199  * Note that because there is a single `nonReentrant` guard, functions marked as
1200  * `nonReentrant` may not call one another. This can be worked around by making
1201  * those functions `private`, and then adding `external` `nonReentrant` entry
1202  * points to them.
1203  *
1204  * TIP: If you would like to learn more about reentrancy and alternative ways
1205  * to protect against it, check out our blog post
1206  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1207  */
1208 abstract contract ReentrancyGuard {
1209     // Booleans are more expensive than uint256 or any type that takes up a full
1210     // word because each write operation emits an extra SLOAD to first read the
1211     // slot's contents, replace the bits taken up by the boolean, and then write
1212     // back. This is the compiler's defense against contract upgrades and
1213     // pointer aliasing, and it cannot be disabled.
1214 
1215     // The values being non-zero value makes deployment a bit more expensive,
1216     // but in exchange the refund on every call to nonReentrant will be lower in
1217     // amount. Since refunds are capped to a percentage of the total
1218     // transaction's gas, it is best to keep them low in cases like this one, to
1219     // increase the likelihood of the full refund coming into effect.
1220     uint256 private constant _NOT_ENTERED = 1;
1221     uint256 private constant _ENTERED = 2;
1222 
1223     uint256 private _status;
1224 
1225     constructor() {
1226         _status = _NOT_ENTERED;
1227     }
1228 
1229     /**
1230      * @dev Prevents a contract from calling itself, directly or indirectly.
1231      * Calling a `nonReentrant` function from another `nonReentrant`
1232      * function is not supported. It is possible to prevent this from happening
1233      * by making the `nonReentrant` function external, and making it call a
1234      * `private` function that does the actual work.
1235      */
1236     modifier nonReentrant() {
1237         _nonReentrantBefore();
1238         _;
1239         _nonReentrantAfter();
1240     }
1241 
1242     function _nonReentrantBefore() private {
1243         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1244         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1245 
1246         // Any calls to nonReentrant after this point will fail
1247         _status = _ENTERED;
1248     }
1249 
1250     function _nonReentrantAfter() private {
1251         // By storing the original value once again, a refund is triggered (see
1252         // https://eips.ethereum.org/EIPS/eip-2200)
1253         _status = _NOT_ENTERED;
1254     }
1255 }
1256 
1257 // File: @openzeppelin/contracts/utils/Context.sol
1258 
1259 
1260 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1261 
1262 pragma solidity ^0.8.0;
1263 
1264 /**
1265  * @dev Provides information about the current execution context, including the
1266  * sender of the transaction and its data. While these are generally available
1267  * via msg.sender and msg.data, they should not be accessed in such a direct
1268  * manner, since when dealing with meta-transactions the account sending and
1269  * paying for execution may not be the actual sender (as far as an application
1270  * is concerned).
1271  *
1272  * This contract is only required for intermediate, library-like contracts.
1273  */
1274 abstract contract Context {
1275     function _msgSender() internal view virtual returns (address) {
1276         return msg.sender;
1277     }
1278 
1279     function _msgData() internal view virtual returns (bytes calldata) {
1280         return msg.data;
1281     }
1282 }
1283 
1284 // File: @openzeppelin/contracts/access/Ownable.sol
1285 
1286 
1287 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1288 
1289 pragma solidity ^0.8.0;
1290 
1291 
1292 /**
1293  * @dev Contract module which provides a basic access control mechanism, where
1294  * there is an account (an owner) that can be granted exclusive access to
1295  * specific functions.
1296  *
1297  * By default, the owner account will be the one that deploys the contract. This
1298  * can later be changed with {transferOwnership}.
1299  *
1300  * This module is used through inheritance. It will make available the modifier
1301  * `onlyOwner`, which can be applied to your functions to restrict their use to
1302  * the owner.
1303  */
1304 abstract contract Ownable is Context {
1305     address private _owner;
1306 
1307     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1308 
1309     /**
1310      * @dev Initializes the contract setting the deployer as the initial owner.
1311      */
1312     constructor() {
1313         _transferOwnership(_msgSender());
1314     }
1315 
1316     /**
1317      * @dev Throws if called by any account other than the owner.
1318      */
1319     modifier onlyOwner() {
1320         _checkOwner();
1321         _;
1322     }
1323 
1324     /**
1325      * @dev Returns the address of the current owner.
1326      */
1327     function owner() public view virtual returns (address) {
1328         return _owner;
1329     }
1330 
1331     /**
1332      * @dev Throws if the sender is not the owner.
1333      */
1334     function _checkOwner() internal view virtual {
1335         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1336     }
1337 
1338     /**
1339      * @dev Leaves the contract without owner. It will not be possible to call
1340      * `onlyOwner` functions anymore. Can only be called by the current owner.
1341      *
1342      * NOTE: Renouncing ownership will leave the contract without an owner,
1343      * thereby removing any functionality that is only available to the owner.
1344      */
1345     function renounceOwnership() public virtual onlyOwner {
1346         _transferOwnership(address(0));
1347     }
1348 
1349     /**
1350      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1351      * Can only be called by the current owner.
1352      */
1353     function transferOwnership(address newOwner) public virtual onlyOwner {
1354         require(newOwner != address(0), "Ownable: new owner is the zero address");
1355         _transferOwnership(newOwner);
1356     }
1357 
1358     /**
1359      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1360      * Internal function without access restriction.
1361      */
1362     function _transferOwnership(address newOwner) internal virtual {
1363         address oldOwner = _owner;
1364         _owner = newOwner;
1365         emit OwnershipTransferred(oldOwner, newOwner);
1366     }
1367 }
1368 
1369 // File: erc721a/contracts/IERC721A.sol
1370 
1371 
1372 // ERC721A Contracts v4.2.3
1373 // Creator: Chiru Labs
1374 
1375 pragma solidity ^0.8.4;
1376 
1377 /**
1378  * @dev Interface of ERC721A.
1379  */
1380 interface IERC721A {
1381     /**
1382      * The caller must own the token or be an approved operator.
1383      */
1384     error ApprovalCallerNotOwnerNorApproved();
1385 
1386     /**
1387      * The token does not exist.
1388      */
1389     error ApprovalQueryForNonexistentToken();
1390 
1391     /**
1392      * Cannot query the balance for the zero address.
1393      */
1394     error BalanceQueryForZeroAddress();
1395 
1396     /**
1397      * Cannot mint to the zero address.
1398      */
1399     error MintToZeroAddress();
1400 
1401     /**
1402      * The quantity of tokens minted must be more than zero.
1403      */
1404     error MintZeroQuantity();
1405 
1406     /**
1407      * The token does not exist.
1408      */
1409     error OwnerQueryForNonexistentToken();
1410 
1411     /**
1412      * The caller must own the token or be an approved operator.
1413      */
1414     error TransferCallerNotOwnerNorApproved();
1415 
1416     /**
1417      * The token must be owned by `from`.
1418      */
1419     error TransferFromIncorrectOwner();
1420 
1421     /**
1422      * Cannot safely transfer to a contract that does not implement the
1423      * ERC721Receiver interface.
1424      */
1425     error TransferToNonERC721ReceiverImplementer();
1426 
1427     /**
1428      * Cannot transfer to the zero address.
1429      */
1430     error TransferToZeroAddress();
1431 
1432     /**
1433      * The token does not exist.
1434      */
1435     error URIQueryForNonexistentToken();
1436 
1437     /**
1438      * The `quantity` minted with ERC2309 exceeds the safety limit.
1439      */
1440     error MintERC2309QuantityExceedsLimit();
1441 
1442     /**
1443      * The `extraData` cannot be set on an unintialized ownership slot.
1444      */
1445     error OwnershipNotInitializedForExtraData();
1446 
1447     // =============================================================
1448     //                            STRUCTS
1449     // =============================================================
1450 
1451     struct TokenOwnership {
1452         // The address of the owner.
1453         address addr;
1454         // Stores the start time of ownership with minimal overhead for tokenomics.
1455         uint64 startTimestamp;
1456         // Whether the token has been burned.
1457         bool burned;
1458         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1459         uint24 extraData;
1460     }
1461 
1462     // =============================================================
1463     //                         TOKEN COUNTERS
1464     // =============================================================
1465 
1466     /**
1467      * @dev Returns the total number of tokens in existence.
1468      * Burned tokens will reduce the count.
1469      * To get the total number of tokens minted, please see {_totalMinted}.
1470      */
1471     function totalSupply() external view returns (uint256);
1472 
1473     // =============================================================
1474     //                            IERC165
1475     // =============================================================
1476 
1477     /**
1478      * @dev Returns true if this contract implements the interface defined by
1479      * `interfaceId`. See the corresponding
1480      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1481      * to learn more about how these ids are created.
1482      *
1483      * This function call must use less than 30000 gas.
1484      */
1485     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1486 
1487     // =============================================================
1488     //                            IERC721
1489     // =============================================================
1490 
1491     /**
1492      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1493      */
1494     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1495 
1496     /**
1497      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1498      */
1499     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1500 
1501     /**
1502      * @dev Emitted when `owner` enables or disables
1503      * (`approved`) `operator` to manage all of its assets.
1504      */
1505     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1506 
1507     /**
1508      * @dev Returns the number of tokens in `owner`'s account.
1509      */
1510     function balanceOf(address owner) external view returns (uint256 balance);
1511 
1512     /**
1513      * @dev Returns the owner of the `tokenId` token.
1514      *
1515      * Requirements:
1516      *
1517      * - `tokenId` must exist.
1518      */
1519     function ownerOf(uint256 tokenId) external view returns (address owner);
1520 
1521     /**
1522      * @dev Safely transfers `tokenId` token from `from` to `to`,
1523      * checking first that contract recipients are aware of the ERC721 protocol
1524      * to prevent tokens from being forever locked.
1525      *
1526      * Requirements:
1527      *
1528      * - `from` cannot be the zero address.
1529      * - `to` cannot be the zero address.
1530      * - `tokenId` token must exist and be owned by `from`.
1531      * - If the caller is not `from`, it must be have been allowed to move
1532      * this token by either {approve} or {setApprovalForAll}.
1533      * - If `to` refers to a smart contract, it must implement
1534      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1535      *
1536      * Emits a {Transfer} event.
1537      */
1538     function safeTransferFrom(
1539         address from,
1540         address to,
1541         uint256 tokenId,
1542         bytes calldata data
1543     ) external payable;
1544 
1545     /**
1546      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1547      */
1548     function safeTransferFrom(
1549         address from,
1550         address to,
1551         uint256 tokenId
1552     ) external payable;
1553 
1554     /**
1555      * @dev Transfers `tokenId` from `from` to `to`.
1556      *
1557      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1558      * whenever possible.
1559      *
1560      * Requirements:
1561      *
1562      * - `from` cannot be the zero address.
1563      * - `to` cannot be the zero address.
1564      * - `tokenId` token must be owned by `from`.
1565      * - If the caller is not `from`, it must be approved to move this token
1566      * by either {approve} or {setApprovalForAll}.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function transferFrom(
1571         address from,
1572         address to,
1573         uint256 tokenId
1574     ) external payable;
1575 
1576     /**
1577      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1578      * The approval is cleared when the token is transferred.
1579      *
1580      * Only a single account can be approved at a time, so approving the
1581      * zero address clears previous approvals.
1582      *
1583      * Requirements:
1584      *
1585      * - The caller must own the token or be an approved operator.
1586      * - `tokenId` must exist.
1587      *
1588      * Emits an {Approval} event.
1589      */
1590     function approve(address to, uint256 tokenId) external payable;
1591 
1592     /**
1593      * @dev Approve or remove `operator` as an operator for the caller.
1594      * Operators can call {transferFrom} or {safeTransferFrom}
1595      * for any token owned by the caller.
1596      *
1597      * Requirements:
1598      *
1599      * - The `operator` cannot be the caller.
1600      *
1601      * Emits an {ApprovalForAll} event.
1602      */
1603     function setApprovalForAll(address operator, bool _approved) external;
1604 
1605     /**
1606      * @dev Returns the account approved for `tokenId` token.
1607      *
1608      * Requirements:
1609      *
1610      * - `tokenId` must exist.
1611      */
1612     function getApproved(uint256 tokenId) external view returns (address operator);
1613 
1614     /**
1615      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1616      *
1617      * See {setApprovalForAll}.
1618      */
1619     function isApprovedForAll(address owner, address operator) external view returns (bool);
1620 
1621     // =============================================================
1622     //                        IERC721Metadata
1623     // =============================================================
1624 
1625     /**
1626      * @dev Returns the token collection name.
1627      */
1628     function name() external view returns (string memory);
1629 
1630     /**
1631      * @dev Returns the token collection symbol.
1632      */
1633     function symbol() external view returns (string memory);
1634 
1635     /**
1636      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1637      */
1638     function tokenURI(uint256 tokenId) external view returns (string memory);
1639 
1640     // =============================================================
1641     //                           IERC2309
1642     // =============================================================
1643 
1644     /**
1645      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1646      * (inclusive) is transferred from `from` to `to`, as defined in the
1647      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1648      *
1649      * See {_mintERC2309} for more details.
1650      */
1651     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1652 }
1653 
1654 // File: erc721a/contracts/ERC721A.sol
1655 
1656 
1657 // ERC721A Contracts v4.2.3
1658 // Creator: Chiru Labs
1659 
1660 pragma solidity ^0.8.4;
1661 
1662 
1663 /**
1664  * @dev Interface of ERC721 token receiver.
1665  */
1666 interface ERC721A__IERC721Receiver {
1667     function onERC721Received(
1668         address operator,
1669         address from,
1670         uint256 tokenId,
1671         bytes calldata data
1672     ) external returns (bytes4);
1673 }
1674 
1675 /**
1676  * @title ERC721A
1677  *
1678  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1679  * Non-Fungible Token Standard, including the Metadata extension.
1680  * Optimized for lower gas during batch mints.
1681  *
1682  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1683  * starting from `_startTokenId()`.
1684  *
1685  * Assumptions:
1686  *
1687  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1688  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1689  */
1690 contract ERC721A is IERC721A {
1691     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1692     struct TokenApprovalRef {
1693         address value;
1694     }
1695 
1696     // =============================================================
1697     //                           CONSTANTS
1698     // =============================================================
1699 
1700     // Mask of an entry in packed address data.
1701     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1702 
1703     // The bit position of `numberMinted` in packed address data.
1704     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1705 
1706     // The bit position of `numberBurned` in packed address data.
1707     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1708 
1709     // The bit position of `aux` in packed address data.
1710     uint256 private constant _BITPOS_AUX = 192;
1711 
1712     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1713     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1714 
1715     // The bit position of `startTimestamp` in packed ownership.
1716     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1717 
1718     // The bit mask of the `burned` bit in packed ownership.
1719     uint256 private constant _BITMASK_BURNED = 1 << 224;
1720 
1721     // The bit position of the `nextInitialized` bit in packed ownership.
1722     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1723 
1724     // The bit mask of the `nextInitialized` bit in packed ownership.
1725     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1726 
1727     // The bit position of `extraData` in packed ownership.
1728     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1729 
1730     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1731     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1732 
1733     // The mask of the lower 160 bits for addresses.
1734     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1735 
1736     // The maximum `quantity` that can be minted with {_mintERC2309}.
1737     // This limit is to prevent overflows on the address data entries.
1738     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1739     // is required to cause an overflow, which is unrealistic.
1740     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1741 
1742     // The `Transfer` event signature is given by:
1743     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1744     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1745         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1746 
1747     // =============================================================
1748     //                            STORAGE
1749     // =============================================================
1750 
1751     // The next token ID to be minted.
1752     uint256 private _currentIndex;
1753 
1754     // The number of tokens burned.
1755     uint256 private _burnCounter;
1756 
1757     // Token name
1758     string private _name;
1759 
1760     // Token symbol
1761     string private _symbol;
1762 
1763     // Mapping from token ID to ownership details
1764     // An empty struct value does not necessarily mean the token is unowned.
1765     // See {_packedOwnershipOf} implementation for details.
1766     //
1767     // Bits Layout:
1768     // - [0..159]   `addr`
1769     // - [160..223] `startTimestamp`
1770     // - [224]      `burned`
1771     // - [225]      `nextInitialized`
1772     // - [232..255] `extraData`
1773     mapping(uint256 => uint256) private _packedOwnerships;
1774 
1775     // Mapping owner address to address data.
1776     //
1777     // Bits Layout:
1778     // - [0..63]    `balance`
1779     // - [64..127]  `numberMinted`
1780     // - [128..191] `numberBurned`
1781     // - [192..255] `aux`
1782     mapping(address => uint256) private _packedAddressData;
1783 
1784     // Mapping from token ID to approved address.
1785     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1786 
1787     // Mapping from owner to operator approvals
1788     mapping(address => mapping(address => bool)) private _operatorApprovals;
1789 
1790     // =============================================================
1791     //                          CONSTRUCTOR
1792     // =============================================================
1793 
1794     constructor(string memory name_, string memory symbol_) {
1795         _name = name_;
1796         _symbol = symbol_;
1797         _currentIndex = _startTokenId();
1798     }
1799 
1800     // =============================================================
1801     //                   TOKEN COUNTING OPERATIONS
1802     // =============================================================
1803 
1804     /**
1805      * @dev Returns the starting token ID.
1806      * To change the starting token ID, please override this function.
1807      */
1808     function _startTokenId() internal view virtual returns (uint256) {
1809         return 0;
1810     }
1811 
1812     /**
1813      * @dev Returns the next token ID to be minted.
1814      */
1815     function _nextTokenId() internal view virtual returns (uint256) {
1816         return _currentIndex;
1817     }
1818 
1819     /**
1820      * @dev Returns the total number of tokens in existence.
1821      * Burned tokens will reduce the count.
1822      * To get the total number of tokens minted, please see {_totalMinted}.
1823      */
1824     function totalSupply() public view virtual override returns (uint256) {
1825         // Counter underflow is impossible as _burnCounter cannot be incremented
1826         // more than `_currentIndex - _startTokenId()` times.
1827         unchecked {
1828             return _currentIndex - _burnCounter - _startTokenId();
1829         }
1830     }
1831 
1832     /**
1833      * @dev Returns the total amount of tokens minted in the contract.
1834      */
1835     function _totalMinted() internal view virtual returns (uint256) {
1836         // Counter underflow is impossible as `_currentIndex` does not decrement,
1837         // and it is initialized to `_startTokenId()`.
1838         unchecked {
1839             return _currentIndex - _startTokenId();
1840         }
1841     }
1842 
1843     /**
1844      * @dev Returns the total number of tokens burned.
1845      */
1846     function _totalBurned() internal view virtual returns (uint256) {
1847         return _burnCounter;
1848     }
1849 
1850     // =============================================================
1851     //                    ADDRESS DATA OPERATIONS
1852     // =============================================================
1853 
1854     /**
1855      * @dev Returns the number of tokens in `owner`'s account.
1856      */
1857     function balanceOf(address owner) public view virtual override returns (uint256) {
1858         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1859         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1860     }
1861 
1862     /**
1863      * Returns the number of tokens minted by `owner`.
1864      */
1865     function _numberMinted(address owner) internal view returns (uint256) {
1866         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1867     }
1868 
1869     /**
1870      * Returns the number of tokens burned by or on behalf of `owner`.
1871      */
1872     function _numberBurned(address owner) internal view returns (uint256) {
1873         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1874     }
1875 
1876     /**
1877      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1878      */
1879     function _getAux(address owner) internal view returns (uint64) {
1880         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1881     }
1882 
1883     /**
1884      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1885      * If there are multiple variables, please pack them into a uint64.
1886      */
1887     function _setAux(address owner, uint64 aux) internal virtual {
1888         uint256 packed = _packedAddressData[owner];
1889         uint256 auxCasted;
1890         // Cast `aux` with assembly to avoid redundant masking.
1891         assembly {
1892             auxCasted := aux
1893         }
1894         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1895         _packedAddressData[owner] = packed;
1896     }
1897 
1898     // =============================================================
1899     //                            IERC165
1900     // =============================================================
1901 
1902     /**
1903      * @dev Returns true if this contract implements the interface defined by
1904      * `interfaceId`. See the corresponding
1905      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1906      * to learn more about how these ids are created.
1907      *
1908      * This function call must use less than 30000 gas.
1909      */
1910     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1911         // The interface IDs are constants representing the first 4 bytes
1912         // of the XOR of all function selectors in the interface.
1913         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1914         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1915         return
1916             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1917             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1918             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1919     }
1920 
1921     // =============================================================
1922     //                        IERC721Metadata
1923     // =============================================================
1924 
1925     /**
1926      * @dev Returns the token collection name.
1927      */
1928     function name() public view virtual override returns (string memory) {
1929         return _name;
1930     }
1931 
1932     /**
1933      * @dev Returns the token collection symbol.
1934      */
1935     function symbol() public view virtual override returns (string memory) {
1936         return _symbol;
1937     }
1938 
1939     /**
1940      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1941      */
1942     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1943         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1944 
1945         string memory baseURI = _baseURI();
1946         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1947     }
1948 
1949     /**
1950      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1951      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1952      * by default, it can be overridden in child contracts.
1953      */
1954     function _baseURI() internal view virtual returns (string memory) {
1955         return '';
1956     }
1957 
1958     // =============================================================
1959     //                     OWNERSHIPS OPERATIONS
1960     // =============================================================
1961 
1962     /**
1963      * @dev Returns the owner of the `tokenId` token.
1964      *
1965      * Requirements:
1966      *
1967      * - `tokenId` must exist.
1968      */
1969     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1970         return address(uint160(_packedOwnershipOf(tokenId)));
1971     }
1972 
1973     /**
1974      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1975      * It gradually moves to O(1) as tokens get transferred around over time.
1976      */
1977     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1978         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1979     }
1980 
1981     /**
1982      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1983      */
1984     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1985         return _unpackedOwnership(_packedOwnerships[index]);
1986     }
1987 
1988     /**
1989      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1990      */
1991     function _initializeOwnershipAt(uint256 index) internal virtual {
1992         if (_packedOwnerships[index] == 0) {
1993             _packedOwnerships[index] = _packedOwnershipOf(index);
1994         }
1995     }
1996 
1997     /**
1998      * Returns the packed ownership data of `tokenId`.
1999      */
2000     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2001         uint256 curr = tokenId;
2002 
2003         unchecked {
2004             if (_startTokenId() <= curr)
2005                 if (curr < _currentIndex) {
2006                     uint256 packed = _packedOwnerships[curr];
2007                     // If not burned.
2008                     if (packed & _BITMASK_BURNED == 0) {
2009                         // Invariant:
2010                         // There will always be an initialized ownership slot
2011                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2012                         // before an unintialized ownership slot
2013                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2014                         // Hence, `curr` will not underflow.
2015                         //
2016                         // We can directly compare the packed value.
2017                         // If the address is zero, packed will be zero.
2018                         while (packed == 0) {
2019                             packed = _packedOwnerships[--curr];
2020                         }
2021                         return packed;
2022                     }
2023                 }
2024         }
2025         revert OwnerQueryForNonexistentToken();
2026     }
2027 
2028     /**
2029      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2030      */
2031     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2032         ownership.addr = address(uint160(packed));
2033         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2034         ownership.burned = packed & _BITMASK_BURNED != 0;
2035         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2036     }
2037 
2038     /**
2039      * @dev Packs ownership data into a single uint256.
2040      */
2041     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2042         assembly {
2043             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2044             owner := and(owner, _BITMASK_ADDRESS)
2045             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2046             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2047         }
2048     }
2049 
2050     /**
2051      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2052      */
2053     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2054         // For branchless setting of the `nextInitialized` flag.
2055         assembly {
2056             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2057             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2058         }
2059     }
2060 
2061     // =============================================================
2062     //                      APPROVAL OPERATIONS
2063     // =============================================================
2064 
2065     /**
2066      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2067      * The approval is cleared when the token is transferred.
2068      *
2069      * Only a single account can be approved at a time, so approving the
2070      * zero address clears previous approvals.
2071      *
2072      * Requirements:
2073      *
2074      * - The caller must own the token or be an approved operator.
2075      * - `tokenId` must exist.
2076      *
2077      * Emits an {Approval} event.
2078      */
2079     function approve(address to, uint256 tokenId) public payable virtual override {
2080         address owner = ownerOf(tokenId);
2081 
2082         if (_msgSenderERC721A() != owner)
2083             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2084                 revert ApprovalCallerNotOwnerNorApproved();
2085             }
2086 
2087         _tokenApprovals[tokenId].value = to;
2088         emit Approval(owner, to, tokenId);
2089     }
2090 
2091     /**
2092      * @dev Returns the account approved for `tokenId` token.
2093      *
2094      * Requirements:
2095      *
2096      * - `tokenId` must exist.
2097      */
2098     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2099         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2100 
2101         return _tokenApprovals[tokenId].value;
2102     }
2103 
2104     /**
2105      * @dev Approve or remove `operator` as an operator for the caller.
2106      * Operators can call {transferFrom} or {safeTransferFrom}
2107      * for any token owned by the caller.
2108      *
2109      * Requirements:
2110      *
2111      * - The `operator` cannot be the caller.
2112      *
2113      * Emits an {ApprovalForAll} event.
2114      */
2115     function setApprovalForAll(address operator, bool approved) public virtual override {
2116         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2117         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2118     }
2119 
2120     /**
2121      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2122      *
2123      * See {setApprovalForAll}.
2124      */
2125     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2126         return _operatorApprovals[owner][operator];
2127     }
2128 
2129     /**
2130      * @dev Returns whether `tokenId` exists.
2131      *
2132      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2133      *
2134      * Tokens start existing when they are minted. See {_mint}.
2135      */
2136     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2137         return
2138             _startTokenId() <= tokenId &&
2139             tokenId < _currentIndex && // If within bounds,
2140             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2141     }
2142 
2143     /**
2144      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2145      */
2146     function _isSenderApprovedOrOwner(
2147         address approvedAddress,
2148         address owner,
2149         address msgSender
2150     ) private pure returns (bool result) {
2151         assembly {
2152             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2153             owner := and(owner, _BITMASK_ADDRESS)
2154             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2155             msgSender := and(msgSender, _BITMASK_ADDRESS)
2156             // `msgSender == owner || msgSender == approvedAddress`.
2157             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2158         }
2159     }
2160 
2161     /**
2162      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2163      */
2164     function _getApprovedSlotAndAddress(uint256 tokenId)
2165         private
2166         view
2167         returns (uint256 approvedAddressSlot, address approvedAddress)
2168     {
2169         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2170         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2171         assembly {
2172             approvedAddressSlot := tokenApproval.slot
2173             approvedAddress := sload(approvedAddressSlot)
2174         }
2175     }
2176 
2177     // =============================================================
2178     //                      TRANSFER OPERATIONS
2179     // =============================================================
2180 
2181     /**
2182      * @dev Transfers `tokenId` from `from` to `to`.
2183      *
2184      * Requirements:
2185      *
2186      * - `from` cannot be the zero address.
2187      * - `to` cannot be the zero address.
2188      * - `tokenId` token must be owned by `from`.
2189      * - If the caller is not `from`, it must be approved to move this token
2190      * by either {approve} or {setApprovalForAll}.
2191      *
2192      * Emits a {Transfer} event.
2193      */
2194     function transferFrom(
2195         address from,
2196         address to,
2197         uint256 tokenId
2198     ) public payable virtual override {
2199         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2200 
2201         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2202 
2203         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2204 
2205         // The nested ifs save around 20+ gas over a compound boolean condition.
2206         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2207             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2208 
2209         if (to == address(0)) revert TransferToZeroAddress();
2210 
2211         _beforeTokenTransfers(from, to, tokenId, 1);
2212 
2213         // Clear approvals from the previous owner.
2214         assembly {
2215             if approvedAddress {
2216                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2217                 sstore(approvedAddressSlot, 0)
2218             }
2219         }
2220 
2221         // Underflow of the sender's balance is impossible because we check for
2222         // ownership above and the recipient's balance can't realistically overflow.
2223         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2224         unchecked {
2225             // We can directly increment and decrement the balances.
2226             --_packedAddressData[from]; // Updates: `balance -= 1`.
2227             ++_packedAddressData[to]; // Updates: `balance += 1`.
2228 
2229             // Updates:
2230             // - `address` to the next owner.
2231             // - `startTimestamp` to the timestamp of transfering.
2232             // - `burned` to `false`.
2233             // - `nextInitialized` to `true`.
2234             _packedOwnerships[tokenId] = _packOwnershipData(
2235                 to,
2236                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2237             );
2238 
2239             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2240             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2241                 uint256 nextTokenId = tokenId + 1;
2242                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2243                 if (_packedOwnerships[nextTokenId] == 0) {
2244                     // If the next slot is within bounds.
2245                     if (nextTokenId != _currentIndex) {
2246                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2247                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2248                     }
2249                 }
2250             }
2251         }
2252 
2253         emit Transfer(from, to, tokenId);
2254         _afterTokenTransfers(from, to, tokenId, 1);
2255     }
2256 
2257     /**
2258      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2259      */
2260     function safeTransferFrom(
2261         address from,
2262         address to,
2263         uint256 tokenId
2264     ) public payable virtual override {
2265         safeTransferFrom(from, to, tokenId, '');
2266     }
2267 
2268     /**
2269      * @dev Safely transfers `tokenId` token from `from` to `to`.
2270      *
2271      * Requirements:
2272      *
2273      * - `from` cannot be the zero address.
2274      * - `to` cannot be the zero address.
2275      * - `tokenId` token must exist and be owned by `from`.
2276      * - If the caller is not `from`, it must be approved to move this token
2277      * by either {approve} or {setApprovalForAll}.
2278      * - If `to` refers to a smart contract, it must implement
2279      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2280      *
2281      * Emits a {Transfer} event.
2282      */
2283     function safeTransferFrom(
2284         address from,
2285         address to,
2286         uint256 tokenId,
2287         bytes memory _data
2288     ) public payable virtual override {
2289         transferFrom(from, to, tokenId);
2290         if (to.code.length != 0)
2291             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2292                 revert TransferToNonERC721ReceiverImplementer();
2293             }
2294     }
2295 
2296     /**
2297      * @dev Hook that is called before a set of serially-ordered token IDs
2298      * are about to be transferred. This includes minting.
2299      * And also called before burning one token.
2300      *
2301      * `startTokenId` - the first token ID to be transferred.
2302      * `quantity` - the amount to be transferred.
2303      *
2304      * Calling conditions:
2305      *
2306      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2307      * transferred to `to`.
2308      * - When `from` is zero, `tokenId` will be minted for `to`.
2309      * - When `to` is zero, `tokenId` will be burned by `from`.
2310      * - `from` and `to` are never both zero.
2311      */
2312     function _beforeTokenTransfers(
2313         address from,
2314         address to,
2315         uint256 startTokenId,
2316         uint256 quantity
2317     ) internal virtual {}
2318 
2319     /**
2320      * @dev Hook that is called after a set of serially-ordered token IDs
2321      * have been transferred. This includes minting.
2322      * And also called after one token has been burned.
2323      *
2324      * `startTokenId` - the first token ID to be transferred.
2325      * `quantity` - the amount to be transferred.
2326      *
2327      * Calling conditions:
2328      *
2329      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2330      * transferred to `to`.
2331      * - When `from` is zero, `tokenId` has been minted for `to`.
2332      * - When `to` is zero, `tokenId` has been burned by `from`.
2333      * - `from` and `to` are never both zero.
2334      */
2335     function _afterTokenTransfers(
2336         address from,
2337         address to,
2338         uint256 startTokenId,
2339         uint256 quantity
2340     ) internal virtual {}
2341 
2342     /**
2343      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2344      *
2345      * `from` - Previous owner of the given token ID.
2346      * `to` - Target address that will receive the token.
2347      * `tokenId` - Token ID to be transferred.
2348      * `_data` - Optional data to send along with the call.
2349      *
2350      * Returns whether the call correctly returned the expected magic value.
2351      */
2352     function _checkContractOnERC721Received(
2353         address from,
2354         address to,
2355         uint256 tokenId,
2356         bytes memory _data
2357     ) private returns (bool) {
2358         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2359             bytes4 retval
2360         ) {
2361             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2362         } catch (bytes memory reason) {
2363             if (reason.length == 0) {
2364                 revert TransferToNonERC721ReceiverImplementer();
2365             } else {
2366                 assembly {
2367                     revert(add(32, reason), mload(reason))
2368                 }
2369             }
2370         }
2371     }
2372 
2373     // =============================================================
2374     //                        MINT OPERATIONS
2375     // =============================================================
2376 
2377     /**
2378      * @dev Mints `quantity` tokens and transfers them to `to`.
2379      *
2380      * Requirements:
2381      *
2382      * - `to` cannot be the zero address.
2383      * - `quantity` must be greater than 0.
2384      *
2385      * Emits a {Transfer} event for each mint.
2386      */
2387     function _mint(address to, uint256 quantity) internal virtual {
2388         uint256 startTokenId = _currentIndex;
2389         if (quantity == 0) revert MintZeroQuantity();
2390 
2391         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2392 
2393         // Overflows are incredibly unrealistic.
2394         // `balance` and `numberMinted` have a maximum limit of 2**64.
2395         // `tokenId` has a maximum limit of 2**256.
2396         unchecked {
2397             // Updates:
2398             // - `balance += quantity`.
2399             // - `numberMinted += quantity`.
2400             //
2401             // We can directly add to the `balance` and `numberMinted`.
2402             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2403 
2404             // Updates:
2405             // - `address` to the owner.
2406             // - `startTimestamp` to the timestamp of minting.
2407             // - `burned` to `false`.
2408             // - `nextInitialized` to `quantity == 1`.
2409             _packedOwnerships[startTokenId] = _packOwnershipData(
2410                 to,
2411                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2412             );
2413 
2414             uint256 toMasked;
2415             uint256 end = startTokenId + quantity;
2416 
2417             // Use assembly to loop and emit the `Transfer` event for gas savings.
2418             // The duplicated `log4` removes an extra check and reduces stack juggling.
2419             // The assembly, together with the surrounding Solidity code, have been
2420             // delicately arranged to nudge the compiler into producing optimized opcodes.
2421             assembly {
2422                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2423                 toMasked := and(to, _BITMASK_ADDRESS)
2424                 // Emit the `Transfer` event.
2425                 log4(
2426                     0, // Start of data (0, since no data).
2427                     0, // End of data (0, since no data).
2428                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2429                     0, // `address(0)`.
2430                     toMasked, // `to`.
2431                     startTokenId // `tokenId`.
2432                 )
2433 
2434                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2435                 // that overflows uint256 will make the loop run out of gas.
2436                 // The compiler will optimize the `iszero` away for performance.
2437                 for {
2438                     let tokenId := add(startTokenId, 1)
2439                 } iszero(eq(tokenId, end)) {
2440                     tokenId := add(tokenId, 1)
2441                 } {
2442                     // Emit the `Transfer` event. Similar to above.
2443                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2444                 }
2445             }
2446             if (toMasked == 0) revert MintToZeroAddress();
2447 
2448             _currentIndex = end;
2449         }
2450         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2451     }
2452 
2453     /**
2454      * @dev Mints `quantity` tokens and transfers them to `to`.
2455      *
2456      * This function is intended for efficient minting only during contract creation.
2457      *
2458      * It emits only one {ConsecutiveTransfer} as defined in
2459      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2460      * instead of a sequence of {Transfer} event(s).
2461      *
2462      * Calling this function outside of contract creation WILL make your contract
2463      * non-compliant with the ERC721 standard.
2464      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2465      * {ConsecutiveTransfer} event is only permissible during contract creation.
2466      *
2467      * Requirements:
2468      *
2469      * - `to` cannot be the zero address.
2470      * - `quantity` must be greater than 0.
2471      *
2472      * Emits a {ConsecutiveTransfer} event.
2473      */
2474     function _mintERC2309(address to, uint256 quantity) internal virtual {
2475         uint256 startTokenId = _currentIndex;
2476         if (to == address(0)) revert MintToZeroAddress();
2477         if (quantity == 0) revert MintZeroQuantity();
2478         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2479 
2480         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2481 
2482         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2483         unchecked {
2484             // Updates:
2485             // - `balance += quantity`.
2486             // - `numberMinted += quantity`.
2487             //
2488             // We can directly add to the `balance` and `numberMinted`.
2489             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2490 
2491             // Updates:
2492             // - `address` to the owner.
2493             // - `startTimestamp` to the timestamp of minting.
2494             // - `burned` to `false`.
2495             // - `nextInitialized` to `quantity == 1`.
2496             _packedOwnerships[startTokenId] = _packOwnershipData(
2497                 to,
2498                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2499             );
2500 
2501             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2502 
2503             _currentIndex = startTokenId + quantity;
2504         }
2505         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2506     }
2507 
2508     /**
2509      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2510      *
2511      * Requirements:
2512      *
2513      * - If `to` refers to a smart contract, it must implement
2514      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2515      * - `quantity` must be greater than 0.
2516      *
2517      * See {_mint}.
2518      *
2519      * Emits a {Transfer} event for each mint.
2520      */
2521     function _safeMint(
2522         address to,
2523         uint256 quantity,
2524         bytes memory _data
2525     ) internal virtual {
2526         _mint(to, quantity);
2527 
2528         unchecked {
2529             if (to.code.length != 0) {
2530                 uint256 end = _currentIndex;
2531                 uint256 index = end - quantity;
2532                 do {
2533                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2534                         revert TransferToNonERC721ReceiverImplementer();
2535                     }
2536                 } while (index < end);
2537                 // Reentrancy protection.
2538                 if (_currentIndex != end) revert();
2539             }
2540         }
2541     }
2542 
2543     /**
2544      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2545      */
2546     function _safeMint(address to, uint256 quantity) internal virtual {
2547         _safeMint(to, quantity, '');
2548     }
2549 
2550     // =============================================================
2551     //                        BURN OPERATIONS
2552     // =============================================================
2553 
2554     /**
2555      * @dev Equivalent to `_burn(tokenId, false)`.
2556      */
2557     function _burn(uint256 tokenId) internal virtual {
2558         _burn(tokenId, false);
2559     }
2560 
2561     /**
2562      * @dev Destroys `tokenId`.
2563      * The approval is cleared when the token is burned.
2564      *
2565      * Requirements:
2566      *
2567      * - `tokenId` must exist.
2568      *
2569      * Emits a {Transfer} event.
2570      */
2571     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2572         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2573 
2574         address from = address(uint160(prevOwnershipPacked));
2575 
2576         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2577 
2578         if (approvalCheck) {
2579             // The nested ifs save around 20+ gas over a compound boolean condition.
2580             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2581                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2582         }
2583 
2584         _beforeTokenTransfers(from, address(0), tokenId, 1);
2585 
2586         // Clear approvals from the previous owner.
2587         assembly {
2588             if approvedAddress {
2589                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2590                 sstore(approvedAddressSlot, 0)
2591             }
2592         }
2593 
2594         // Underflow of the sender's balance is impossible because we check for
2595         // ownership above and the recipient's balance can't realistically overflow.
2596         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2597         unchecked {
2598             // Updates:
2599             // - `balance -= 1`.
2600             // - `numberBurned += 1`.
2601             //
2602             // We can directly decrement the balance, and increment the number burned.
2603             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2604             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2605 
2606             // Updates:
2607             // - `address` to the last owner.
2608             // - `startTimestamp` to the timestamp of burning.
2609             // - `burned` to `true`.
2610             // - `nextInitialized` to `true`.
2611             _packedOwnerships[tokenId] = _packOwnershipData(
2612                 from,
2613                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2614             );
2615 
2616             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2617             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2618                 uint256 nextTokenId = tokenId + 1;
2619                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2620                 if (_packedOwnerships[nextTokenId] == 0) {
2621                     // If the next slot is within bounds.
2622                     if (nextTokenId != _currentIndex) {
2623                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2624                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2625                     }
2626                 }
2627             }
2628         }
2629 
2630         emit Transfer(from, address(0), tokenId);
2631         _afterTokenTransfers(from, address(0), tokenId, 1);
2632 
2633         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2634         unchecked {
2635             _burnCounter++;
2636         }
2637     }
2638 
2639     // =============================================================
2640     //                     EXTRA DATA OPERATIONS
2641     // =============================================================
2642 
2643     /**
2644      * @dev Directly sets the extra data for the ownership data `index`.
2645      */
2646     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2647         uint256 packed = _packedOwnerships[index];
2648         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2649         uint256 extraDataCasted;
2650         // Cast `extraData` with assembly to avoid redundant masking.
2651         assembly {
2652             extraDataCasted := extraData
2653         }
2654         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2655         _packedOwnerships[index] = packed;
2656     }
2657 
2658     /**
2659      * @dev Called during each token transfer to set the 24bit `extraData` field.
2660      * Intended to be overridden by the cosumer contract.
2661      *
2662      * `previousExtraData` - the value of `extraData` before transfer.
2663      *
2664      * Calling conditions:
2665      *
2666      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2667      * transferred to `to`.
2668      * - When `from` is zero, `tokenId` will be minted for `to`.
2669      * - When `to` is zero, `tokenId` will be burned by `from`.
2670      * - `from` and `to` are never both zero.
2671      */
2672     function _extraData(
2673         address from,
2674         address to,
2675         uint24 previousExtraData
2676     ) internal view virtual returns (uint24) {}
2677 
2678     /**
2679      * @dev Returns the next extra data for the packed ownership data.
2680      * The returned result is shifted into position.
2681      */
2682     function _nextExtraData(
2683         address from,
2684         address to,
2685         uint256 prevOwnershipPacked
2686     ) private view returns (uint256) {
2687         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2688         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2689     }
2690 
2691     // =============================================================
2692     //                       OTHER OPERATIONS
2693     // =============================================================
2694 
2695     /**
2696      * @dev Returns the message sender (defaults to `msg.sender`).
2697      *
2698      * If you are writing GSN compatible contracts, you need to override this function.
2699      */
2700     function _msgSenderERC721A() internal view virtual returns (address) {
2701         return msg.sender;
2702     }
2703 
2704     /**
2705      * @dev Converts a uint256 to its ASCII string decimal representation.
2706      */
2707     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2708         assembly {
2709             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2710             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2711             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2712             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2713             let m := add(mload(0x40), 0xa0)
2714             // Update the free memory pointer to allocate.
2715             mstore(0x40, m)
2716             // Assign the `str` to the end.
2717             str := sub(m, 0x20)
2718             // Zeroize the slot after the string.
2719             mstore(str, 0)
2720 
2721             // Cache the end of the memory to calculate the length later.
2722             let end := str
2723 
2724             // We write the string from rightmost digit to leftmost digit.
2725             // The following is essentially a do-while loop that also handles the zero case.
2726             // prettier-ignore
2727             for { let temp := value } 1 {} {
2728                 str := sub(str, 1)
2729                 // Write the character to the pointer.
2730                 // The ASCII index of the '0' character is 48.
2731                 mstore8(str, add(48, mod(temp, 10)))
2732                 // Keep dividing `temp` until zero.
2733                 temp := div(temp, 10)
2734                 // prettier-ignore
2735                 if iszero(temp) { break }
2736             }
2737 
2738             let length := sub(end, str)
2739             // Move the pointer 32 bytes leftwards to make room for the length.
2740             str := sub(str, 0x20)
2741             // Store the length.
2742             mstore(str, length)
2743         }
2744     }
2745 }
2746 
2747 // File: contracts/blurneko.sol
2748 
2749 pragma solidity >=0.8.12 <=0.8.18;
2750 
2751 contract blurneko is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2752 
2753 using Strings for uint256;
2754 
2755 // STATE VARIABLES //
2756 
2757 /// @notice Funds withdrawal address.
2758 address payable public withdrawalAddress;
2759 
2760 /// @notice Boolean for enabling and disabling public minting.
2761 bool public publicMintingStatus;
2762 
2763 /// @notice Boolean for whether collection is revealed or not.
2764 bool public revealedStatus;
2765 
2766 /// @notice Mapping for number of NFTs minted by an address.
2767 mapping(address => uint256) public addressMinted;
2768 
2769 /// @notice Revealed metadata url prefix.
2770 string public metadataURLPrefix;
2771 
2772 /// @notice Revealed metadata url suffix.
2773 string public metadataURLSuffix = ".json";
2774 
2775 /// @notice Not revealed metadata url.
2776 string public notRevealedMetadataURL;
2777 
2778 /// @notice Max mint per wallet.
2779 uint256 public maxMintPerAddress = 3;
2780 
2781 /// @notice Collection max supply.
2782 uint256 public maxSupply = 888;
2783 
2784 /// @notice Price of one NFT.
2785 uint256 public price = 0.005 ether;
2786 
2787 /// @notice Free mint per wallet.
2788 uint256 public freeMintPerAddress = 1;
2789 
2790 constructor() ERC721A("blur neko","BN") {}
2791 
2792     // PUBLIC FUNCTION, WRITE CONTRACT FUNCTION //
2793 
2794     /**
2795      * @notice Public payable function.
2796      * Function mints a specified amount of tokens to the caller's address.
2797      * Requires public minting status to be true.
2798      * Requires sufficient ETH to execute.
2799      * Enter the amount of tokens to be minted in the amount field.
2800      */
2801     function publicMint(uint256 amount) public payable {
2802        require(publicMintingStatus == true, "Public mint status false, requires to be true");
2803        require(Address.isContract(msg.sender) == false, "Caller is a contract");
2804        require(addressMinted[msg.sender] + amount <= maxMintPerAddress, "Request exceeds max mint per address");
2805        require(totalSupply() + amount <= maxSupply, "Request exceeds max supply");
2806        if (addressMinted[msg.sender] + amount <= freeMintPerAddress) {
2807           _safeMint(msg.sender, amount);
2808           addressMinted[msg.sender] += amount;
2809         }
2810         else if (addressMinted[msg.sender] + amount > freeMintPerAddress && addressMinted[msg.sender] + amount <= maxMintPerAddress) {
2811             require(msg.value >= price * ((addressMinted[msg.sender] + amount) - freeMintPerAddress), "Not enough funds");
2812             _safeMint(msg.sender, amount);
2813             addressMinted[msg.sender] += amount;
2814         }
2815     }
2816 
2817     // SMART CONTRACT OWNER ONLY FUNCTIONS, WRITE CONTRACT FUNCTIONS //
2818 
2819     /**
2820      * @notice Smart contract owner only function.
2821      * Function airdrops a specified amount of tokens to an array of addresses.
2822      * Enter the recepients in an array form like this [address1,address2,address3] in the recipients field and enter the amount of NFTs to be airdropped to each recipient in the amount field.
2823      */
2824     function airdrop(address[] calldata recipients, uint256 amount) public onlyOwner {
2825         require(totalSupply() + recipients.length * amount <= maxSupply, "Request exceeds max supply");
2826         for (uint256 i = 0; i < recipients.length; i++) {
2827             _safeMint(recipients[i], amount);
2828         }
2829     }
2830 
2831     /** 
2832      * @notice Smart contract owner only function.
2833      * Function can mint different quantities of NFTs in batches to the recipient.
2834      * Enter the recipient's address in the recipient field.
2835      * Enter the NFT quantity for each batch in an array form in the nftQuantityForEachBatch field.
2836      * For example if the nftQuantityForEachBatch array is like this [30,50,70] in total 150 NFTs would be minted in batches of 30, 50 and 70.
2837      */
2838     function mintInBatches(address recipient, uint256[] calldata nftQuantityForEachBatch) public onlyOwner {
2839         for (uint256 i = 0; i < nftQuantityForEachBatch.length; ++i) {   
2840             require(totalSupply() + nftQuantityForEachBatch[i] <= maxSupply, "request exceeds maxSupply");
2841             _safeMint(recipient, nftQuantityForEachBatch[i]);
2842         }
2843     }
2844 
2845     /**
2846      * @notice Smart contract owner only function.
2847      * Function sets the free mint per address amount.
2848      * Enter the new free mint per address in the freeMintAmount field.
2849      * The freeMintAmount must be less than or equal to the maxMintPerAddress.
2850      */
2851     function setFreeMintPerAddress(uint256 freeMintAmount) public onlyOwner {
2852         require(freeMintAmount <= maxMintPerAddress, "freeMintAmount must be less than or equal to the maxMintPerAddress");
2853         freeMintPerAddress = freeMintAmount;
2854     }  
2855 
2856     /**
2857      * @notice Smart contract owner only function.
2858      * Function sets the max mint per address amount.
2859      * Enter the new max mint per address in the maxMintAmount field.
2860      * The maxMintAmount must be less than or equal to the maxSupply.
2861      */
2862     function setMaxMintPerAddress(uint256 maxMintAmount) public onlyOwner {
2863         require(maxMintAmount <= maxSupply, "maxMintAmount must be less than or equal to the maxSupply");
2864         maxMintPerAddress = maxMintAmount;
2865     }
2866 
2867     /**
2868      * @notice Smart contract owner only function.
2869      * Function sets a new max supply of tokens which can be minted from the contract.
2870      * Enter the new max supply in the newMaxSupply field.
2871      * The newMaxSupply must be greater than or equal to the totalSupply.
2872      */
2873     function setMaxSupply(uint256 newMaxSupply) public onlyOwner {
2874         require(newMaxSupply >= totalSupply(), "newMaxSupply must be greater than or equal to the totalSupply");
2875         maxSupply = newMaxSupply;
2876     }
2877 
2878     /**
2879      * @notice Smart contract owner only function.
2880      * Function updates the metadata url prefix.
2881      * Enter the new metadata url prefix in the newMetadataURLPrefix field.
2882      */
2883     function setMetadataURLPrefix(string memory newMetadataURLPrefix) public onlyOwner {
2884         metadataURLPrefix = newMetadataURLPrefix;
2885     }
2886 
2887     /**
2888      * @notice Smart contract owner only function.
2889      * Function updates the metadata url suffix.
2890      * Enter the new metadata url suffix in the newMetadataURLSuffix field.
2891      */
2892     function setMetadataURLSuffix(string memory newMetadataURLSuffix) public onlyOwner {
2893         metadataURLSuffix = newMetadataURLSuffix;
2894     }
2895 
2896     /**
2897      * @notice Smart contract owner only function.
2898      * Function updates the not revealed metadata url.
2899      * Enter the new not revealed metadata url in the newNotRevealedMetadataURL field.
2900      */
2901     function setNotRevealedMetadataURL(string memory newNotRevealedMetadataURL) public onlyOwner {
2902         notRevealedMetadataURL = newNotRevealedMetadataURL;
2903     }
2904 
2905     /**
2906      * @notice Smart contract owner only function.
2907      * Function updates the price for minting a single NFT.
2908      * Enter the new price in the newPrice field, entered price must be in wei, check ether to wei conversion.
2909      */
2910     function setPrice(uint256 newPrice) public onlyOwner {
2911         price = newPrice;
2912     }
2913 
2914     /**
2915      * @notice Smart contract owner only function.
2916      * Function sets the public minting status.
2917      * Enter the word true in the status field to enable public minting.
2918      * Enter the word false in the status field to disable public minting.
2919      */
2920     function setPublicMintingStatus(bool status) public onlyOwner {
2921         publicMintingStatus = status;
2922     }
2923 
2924     /**
2925      * @notice Smart contract owner only function.
2926      * Function sets the revealed status for the collection.
2927      * Enter the word true in the status field to reveal the collection.
2928      * Enter the word false in the status field to hide or unreveal the collection.
2929      */
2930     function setRevealedStatus(bool status) public onlyOwner {
2931         revealedStatus = status;
2932     }
2933 
2934     /** 
2935      * @notice Smart contract owner only function.
2936      * Function sets the withdrawal address for the funds in the smart contract.
2937      * Enter the new withdrawal address in the newWithdrawalAddress field.
2938      * To withdraw to a payment splitter smart contract,
2939      * enter the payment splitter smart contract's contract address in the newWithdrawalAddress field. 
2940      */ 
2941     function setWithdrawalAddress(address newWithdrawalAddress) public onlyOwner {
2942         withdrawalAddress = payable(newWithdrawalAddress);
2943     }
2944 
2945     /**
2946      * @notice Smart contract owner only function.
2947      * Function withdraws the funds in the smart contract to the withdrawal address.
2948      * Enter the number 0 in the withdraw field to withdraw the funds successfully.
2949      */
2950     function withdraw() public payable onlyOwner nonReentrant {
2951         (bool success, ) = payable(withdrawalAddress).call{value: address(this).balance}("");
2952         require(success);
2953     }
2954 
2955     /**
2956      * @notice Smart contract owner only function.
2957      * Function withdraws the ERC20 token amount accumulated in the smart contract to the entered account address.
2958      * Enter the ERC20 token contract address in the token field, the address to which the accumulated ERC20 tokens would be transferred in the account field and the amount of accumulated ERC20 tokens to be transferred in the amount field.
2959      */
2960     function withdrawERC20(IERC20 token, address account, uint256 amount) public onlyOwner {
2961         SafeERC20.safeTransfer(token, account, amount);
2962     }
2963 
2964     // OVERRIDDEN PUBLIC WRITE CONTRACT FUNCTIONS: OpenSea's Royalty Filterer Implementation. //
2965 
2966     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2967         super.approve(operator, tokenId);
2968     }
2969 
2970     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2971         super.setApprovalForAll(operator, approved);
2972     }
2973 
2974     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2975         super.safeTransferFrom(from, to, tokenId);
2976     }
2977 
2978     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2979         super.safeTransferFrom(from, to, tokenId, data);
2980     }
2981 
2982     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2983         super.transferFrom(from, to, tokenId);
2984     }
2985 
2986     // GETTER FUNCTIONS, READ CONTRACT FUNCTIONS //
2987 
2988     /**
2989      * @notice Function queries and returns all the NFT tokenIds owned by an address.
2990      * Enter the address in the owner field.
2991      * Click on query after filling out the field.
2992      */
2993     function walletOfOwner(address owner) public view returns (uint256[] memory ownedTokenIds) {
2994         ownedTokenIds = new uint256[](balanceOf(owner));
2995         uint256 currentTokenId = 1;
2996         uint256 currentTokenIndex = 0;
2997         while (currentTokenIndex < totalSupply() && currentTokenId <= totalSupply()) {
2998             if (_exists(currentTokenId) && ownerOf(currentTokenId) == owner) {
2999                ownedTokenIds[currentTokenIndex] = currentTokenId;
3000                currentTokenIndex++;
3001             }
3002             currentTokenId++;
3003         }
3004         return ownedTokenIds;
3005     }
3006 
3007     /**
3008      * @notice Function scans and returns all the NFT tokenIds owned by an address from startTokenId till stopTokenId.
3009      * startTokenId must be equal to or greater than zero and smaller than stopTokenId.
3010      * stopTokenId must be greater than startTokenId and smaller or equal to totalSupply.
3011      * Enter the tokenId from where the scan is to be started in the startTokenId field. 
3012      * Enter the tokenId till where the scan is to be done in the stopTokenId field.
3013      * For example, if startTokenId is 10 and stopTokenId is 80, the function will return all the NFT tokenIds owned by the address from tokenId 10 till tokenId 80.
3014      * Click on query after filling out all the fields.
3015      */
3016     function walletOfOwnerInRange(address owner, uint256 startTokenId, uint256 stopTokenId) public view returns (uint256[] memory ownedTokenIds) {
3017         require(startTokenId >= 0 && startTokenId < stopTokenId, "startTokenId must be equal to or greater than zero and smaller than stopTokenId");
3018         require(stopTokenId > startTokenId && stopTokenId <= totalSupply(), "stopTokenId must be greater than startTokenId and smaller or equal to totalSupply");
3019         ownedTokenIds = new uint256[](stopTokenId - startTokenId + 1);
3020         uint256 currentTokenId = startTokenId;
3021         uint256 currentTokenIndex = 0;
3022         while (currentTokenIndex < stopTokenId && currentTokenId <= stopTokenId) {
3023             if (_exists(currentTokenId) && ownerOf(currentTokenId) == owner) {
3024                 ownedTokenIds[currentTokenIndex] = currentTokenId;
3025                 currentTokenIndex++;
3026             }
3027             currentTokenId++;
3028         }
3029         assembly{mstore(ownedTokenIds, currentTokenIndex)}
3030         return ownedTokenIds;
3031     }
3032 
3033     // OVERRIDDEN GETTER FUNCTIONS, READ CONTRACT FUNCTIONS //
3034 
3035     /**
3036      * @notice Function queries and returns the URI for a NFT tokenId.
3037      * Enter the tokenId of the NFT in tokenId field.
3038      */
3039     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3040         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3041         if (revealedStatus == false) {
3042             return notRevealedMetadataURL;
3043         } 
3044         string memory currentBaseURI = _baseURI();
3045         return bytes(currentBaseURI).length > 0
3046         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), metadataURLSuffix))
3047         : "";
3048     }
3049 
3050     // INTERNAL FUNCTIONS //
3051 
3052     /// @notice Internal function which is called by the tokenURI function.
3053     function _baseURI() internal view virtual override returns (string memory) {
3054         return metadataURLPrefix;
3055     }
3056 
3057     /// @notice Internal function which ensures the first minted NFT has tokenId as 1.
3058     function _startTokenId() internal view virtual override returns (uint256) {
3059         return 1;
3060     }
3061 }