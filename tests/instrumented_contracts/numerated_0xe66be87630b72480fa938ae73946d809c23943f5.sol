1 // SPDX-License-Identifier: MIT
2 // File: contracts/TESTIES.sol
3 
4 
5 
6 
7 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
8 
9 
10 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
11 
12 pragma solidity ^0.8.0;
13 
14 /**
15  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
16  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
17  *
18  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
19  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
20  * need to send a transaction, and thus is not required to hold Ether at all.
21  */
22 interface IERC20Permit {
23     /**
24      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
25      * given ``owner``'s signed approval.
26      *
27      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
28      * ordering also apply here.
29      *
30      * Emits an {Approval} event.
31      *
32      * Requirements:
33      *
34      * - `spender` cannot be the zero address.
35      * - `deadline` must be a timestamp in the future.
36      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
37      * over the EIP712-formatted function arguments.
38      * - the signature must use ``owner``'s current nonce (see {nonces}).
39      *
40      * For more information on the signature format, see the
41      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
42      * section].
43      */
44     function permit(
45         address owner,
46         address spender,
47         uint256 value,
48         uint256 deadline,
49         uint8 v,
50         bytes32 r,
51         bytes32 s
52     ) external;
53 
54     /**
55      * @dev Returns the current nonce for `owner`. This value must be
56      * included whenever a signature is generated for {permit}.
57      *
58      * Every successful call to {permit} increases ``owner``'s nonce by one. This
59      * prevents a signature from being used multiple times.
60      */
61     function nonces(address owner) external view returns (uint256);
62 
63     /**
64      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
65      */
66     // solhint-disable-next-line func-name-mixedcase
67     function DOMAIN_SEPARATOR() external view returns (bytes32);
68 }
69 
70 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
71 
72 
73 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
74 
75 pragma solidity ^0.8.0;
76 
77 /**
78  * @dev Interface of the ERC20 standard as defined in the EIP.
79  */
80 interface IERC20 {
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 
95     /**
96      * @dev Returns the amount of tokens in existence.
97      */
98     function totalSupply() external view returns (uint256);
99 
100     /**
101      * @dev Returns the amount of tokens owned by `account`.
102      */
103     function balanceOf(address account) external view returns (uint256);
104 
105     /**
106      * @dev Moves `amount` tokens from the caller's account to `to`.
107      *
108      * Returns a boolean value indicating whether the operation succeeded.
109      *
110      * Emits a {Transfer} event.
111      */
112     function transfer(address to, uint256 amount) external returns (bool);
113 
114     /**
115      * @dev Returns the remaining number of tokens that `spender` will be
116      * allowed to spend on behalf of `owner` through {transferFrom}. This is
117      * zero by default.
118      *
119      * This value changes when {approve} or {transferFrom} are called.
120      */
121     function allowance(address owner, address spender) external view returns (uint256);
122 
123     /**
124      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * IMPORTANT: Beware that changing an allowance with this method brings the risk
129      * that someone may use both the old and the new allowance by unfortunate
130      * transaction ordering. One possible solution to mitigate this race
131      * condition is to first reduce the spender's allowance to 0 and set the
132      * desired value afterwards:
133      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
134      *
135      * Emits an {Approval} event.
136      */
137     function approve(address spender, uint256 amount) external returns (bool);
138 
139     /**
140      * @dev Moves `amount` tokens from `from` to `to` using the
141      * allowance mechanism. `amount` is then deducted from the caller's
142      * allowance.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transferFrom(
149         address from,
150         address to,
151         uint256 amount
152     ) external returns (bool);
153 }
154 
155 // File: @openzeppelin/contracts/utils/Address.sol
156 
157 
158 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
159 
160 pragma solidity ^0.8.1;
161 
162 /**
163  * @dev Collection of functions related to the address type
164  */
165 library Address {
166     /**
167      * @dev Returns true if `account` is a contract.
168      *
169      * [IMPORTANT]
170      * ====
171      * It is unsafe to assume that an address for which this function returns
172      * false is an externally-owned account (EOA) and not a contract.
173      *
174      * Among others, `isContract` will return false for the following
175      * types of addresses:
176      *
177      *  - an externally-owned account
178      *  - a contract in construction
179      *  - an address where a contract will be created
180      *  - an address where a contract lived, but was destroyed
181      * ====
182      *
183      * [IMPORTANT]
184      * ====
185      * You shouldn't rely on `isContract` to protect against flash loan attacks!
186      *
187      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
188      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
189      * constructor.
190      * ====
191      */
192     function isContract(address account) internal view returns (bool) {
193         // This method relies on extcodesize/address.code.length, which returns 0
194         // for contracts in construction, since the code is only stored at the end
195         // of the constructor execution.
196 
197         return account.code.length > 0;
198     }
199 
200     /**
201      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
202      * `recipient`, forwarding all available gas and reverting on errors.
203      *
204      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
205      * of certain opcodes, possibly making contracts go over the 2300 gas limit
206      * imposed by `transfer`, making them unable to receive funds via
207      * `transfer`. {sendValue} removes this limitation.
208      *
209      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
210      *
211      * IMPORTANT: because control is transferred to `recipient`, care must be
212      * taken to not create reentrancy vulnerabilities. Consider using
213      * {ReentrancyGuard} or the
214      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
215      */
216     function sendValue(address payable recipient, uint256 amount) internal {
217         require(address(this).balance >= amount, "Address: insufficient balance");
218 
219         (bool success, ) = recipient.call{value: amount}("");
220         require(success, "Address: unable to send value, recipient may have reverted");
221     }
222 
223     /**
224      * @dev Performs a Solidity function call using a low level `call`. A
225      * plain `call` is an unsafe replacement for a function call: use this
226      * function instead.
227      *
228      * If `target` reverts with a revert reason, it is bubbled up by this
229      * function (like regular Solidity function calls).
230      *
231      * Returns the raw returned data. To convert to the expected return value,
232      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
233      *
234      * Requirements:
235      *
236      * - `target` must be a contract.
237      * - calling `target` with `data` must not revert.
238      *
239      * _Available since v3.1._
240      */
241     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
242         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
247      * `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(
252         address target,
253         bytes memory data,
254         string memory errorMessage
255     ) internal returns (bytes memory) {
256         return functionCallWithValue(target, data, 0, errorMessage);
257     }
258 
259     /**
260      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
261      * but also transferring `value` wei to `target`.
262      *
263      * Requirements:
264      *
265      * - the calling contract must have an ETH balance of at least `value`.
266      * - the called Solidity function must be `payable`.
267      *
268      * _Available since v3.1._
269      */
270     function functionCallWithValue(
271         address target,
272         bytes memory data,
273         uint256 value
274     ) internal returns (bytes memory) {
275         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
276     }
277 
278     /**
279      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
280      * with `errorMessage` as a fallback revert reason when `target` reverts.
281      *
282      * _Available since v3.1._
283      */
284     function functionCallWithValue(
285         address target,
286         bytes memory data,
287         uint256 value,
288         string memory errorMessage
289     ) internal returns (bytes memory) {
290         require(address(this).balance >= value, "Address: insufficient balance for call");
291         (bool success, bytes memory returndata) = target.call{value: value}(data);
292         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
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
316         (bool success, bytes memory returndata) = target.staticcall(data);
317         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
318     }
319 
320     /**
321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
322      * but performing a delegate call.
323      *
324      * _Available since v3.4._
325      */
326     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
327         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
332      * but performing a delegate call.
333      *
334      * _Available since v3.4._
335      */
336     function functionDelegateCall(
337         address target,
338         bytes memory data,
339         string memory errorMessage
340     ) internal returns (bytes memory) {
341         (bool success, bytes memory returndata) = target.delegatecall(data);
342         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
343     }
344 
345     /**
346      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
347      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
348      *
349      * _Available since v4.8._
350      */
351     function verifyCallResultFromTarget(
352         address target,
353         bool success,
354         bytes memory returndata,
355         string memory errorMessage
356     ) internal view returns (bytes memory) {
357         if (success) {
358             if (returndata.length == 0) {
359                 // only check isContract if the call was successful and the return data is empty
360                 // otherwise we already know that it was a contract
361                 require(isContract(target), "Address: call to non-contract");
362             }
363             return returndata;
364         } else {
365             _revert(returndata, errorMessage);
366         }
367     }
368 
369     /**
370      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
371      * revert reason or using the provided one.
372      *
373      * _Available since v4.3._
374      */
375     function verifyCallResult(
376         bool success,
377         bytes memory returndata,
378         string memory errorMessage
379     ) internal pure returns (bytes memory) {
380         if (success) {
381             return returndata;
382         } else {
383             _revert(returndata, errorMessage);
384         }
385     }
386 
387     function _revert(bytes memory returndata, string memory errorMessage) private pure {
388         // Look for revert reason and bubble it up if present
389         if (returndata.length > 0) {
390             // The easiest way to bubble the revert reason is using memory via assembly
391             /// @solidity memory-safe-assembly
392             assembly {
393                 let returndata_size := mload(returndata)
394                 revert(add(32, returndata), returndata_size)
395             }
396         } else {
397             revert(errorMessage);
398         }
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
403 
404 
405 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 
410 
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure (when the token
415  * contract returns false). Tokens that return no value (and instead revert or
416  * throw on failure) are also supported, non-reverting calls are assumed to be
417  * successful.
418  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
419  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
420  */
421 library SafeERC20 {
422     using Address for address;
423 
424     function safeTransfer(
425         IERC20 token,
426         address to,
427         uint256 value
428     ) internal {
429         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
430     }
431 
432     function safeTransferFrom(
433         IERC20 token,
434         address from,
435         address to,
436         uint256 value
437     ) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
439     }
440 
441     /**
442      * @dev Deprecated. This function has issues similar to the ones found in
443      * {IERC20-approve}, and its usage is discouraged.
444      *
445      * Whenever possible, use {safeIncreaseAllowance} and
446      * {safeDecreaseAllowance} instead.
447      */
448     function safeApprove(
449         IERC20 token,
450         address spender,
451         uint256 value
452     ) internal {
453         // safeApprove should only be called when setting an initial allowance,
454         // or when resetting it to zero. To increase and decrease it, use
455         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
456         require(
457             (value == 0) || (token.allowance(address(this), spender) == 0),
458             "SafeERC20: approve from non-zero to non-zero allowance"
459         );
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
461     }
462 
463     function safeIncreaseAllowance(
464         IERC20 token,
465         address spender,
466         uint256 value
467     ) internal {
468         uint256 newAllowance = token.allowance(address(this), spender) + value;
469         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
470     }
471 
472     function safeDecreaseAllowance(
473         IERC20 token,
474         address spender,
475         uint256 value
476     ) internal {
477         unchecked {
478             uint256 oldAllowance = token.allowance(address(this), spender);
479             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
480             uint256 newAllowance = oldAllowance - value;
481             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
482         }
483     }
484 
485     function safePermit(
486         IERC20Permit token,
487         address owner,
488         address spender,
489         uint256 value,
490         uint256 deadline,
491         uint8 v,
492         bytes32 r,
493         bytes32 s
494     ) internal {
495         uint256 nonceBefore = token.nonces(owner);
496         token.permit(owner, spender, value, deadline, v, r, s);
497         uint256 nonceAfter = token.nonces(owner);
498         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
499     }
500 
501     /**
502      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
503      * on the return value: the return value is optional (but if data is returned, it must not be false).
504      * @param token The token targeted by the call.
505      * @param data The call data (encoded using abi.encode or one of its variants).
506      */
507     function _callOptionalReturn(IERC20 token, bytes memory data) private {
508         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
509         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
510         // the target address contains contract code and also asserts for success in the low-level call.
511 
512         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
513         if (returndata.length > 0) {
514             // Return data is optional
515             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
516         }
517     }
518 }
519 
520 // File: @openzeppelin/contracts/utils/math/Math.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 /**
528  * @dev Standard math utilities missing in the Solidity language.
529  */
530 library Math {
531     enum Rounding {
532         Down, // Toward negative infinity
533         Up, // Toward infinity
534         Zero // Toward zero
535     }
536 
537     /**
538      * @dev Returns the largest of two numbers.
539      */
540     function max(uint256 a, uint256 b) internal pure returns (uint256) {
541         return a > b ? a : b;
542     }
543 
544     /**
545      * @dev Returns the smallest of two numbers.
546      */
547     function min(uint256 a, uint256 b) internal pure returns (uint256) {
548         return a < b ? a : b;
549     }
550 
551     /**
552      * @dev Returns the average of two numbers. The result is rounded towards
553      * zero.
554      */
555     function average(uint256 a, uint256 b) internal pure returns (uint256) {
556         // (a + b) / 2 can overflow.
557         return (a & b) + (a ^ b) / 2;
558     }
559 
560     /**
561      * @dev Returns the ceiling of the division of two numbers.
562      *
563      * This differs from standard division with `/` in that it rounds up instead
564      * of rounding down.
565      */
566     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
567         // (a + b - 1) / b can overflow on addition, so we distribute.
568         return a == 0 ? 0 : (a - 1) / b + 1;
569     }
570 
571     /**
572      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
573      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
574      * with further edits by Uniswap Labs also under MIT license.
575      */
576     function mulDiv(
577         uint256 x,
578         uint256 y,
579         uint256 denominator
580     ) internal pure returns (uint256 result) {
581         unchecked {
582             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
583             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
584             // variables such that product = prod1 * 2^256 + prod0.
585             uint256 prod0; // Least significant 256 bits of the product
586             uint256 prod1; // Most significant 256 bits of the product
587             assembly {
588                 let mm := mulmod(x, y, not(0))
589                 prod0 := mul(x, y)
590                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
591             }
592 
593             // Handle non-overflow cases, 256 by 256 division.
594             if (prod1 == 0) {
595                 return prod0 / denominator;
596             }
597 
598             // Make sure the result is less than 2^256. Also prevents denominator == 0.
599             require(denominator > prod1);
600 
601             ///////////////////////////////////////////////
602             // 512 by 256 division.
603             ///////////////////////////////////////////////
604 
605             // Make division exact by subtracting the remainder from [prod1 prod0].
606             uint256 remainder;
607             assembly {
608                 // Compute remainder using mulmod.
609                 remainder := mulmod(x, y, denominator)
610 
611                 // Subtract 256 bit number from 512 bit number.
612                 prod1 := sub(prod1, gt(remainder, prod0))
613                 prod0 := sub(prod0, remainder)
614             }
615 
616             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
617             // See https://cs.stackexchange.com/q/138556/92363.
618 
619             // Does not overflow because the denominator cannot be zero at this stage in the function.
620             uint256 twos = denominator & (~denominator + 1);
621             assembly {
622                 // Divide denominator by twos.
623                 denominator := div(denominator, twos)
624 
625                 // Divide [prod1 prod0] by twos.
626                 prod0 := div(prod0, twos)
627 
628                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
629                 twos := add(div(sub(0, twos), twos), 1)
630             }
631 
632             // Shift in bits from prod1 into prod0.
633             prod0 |= prod1 * twos;
634 
635             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
636             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
637             // four bits. That is, denominator * inv = 1 mod 2^4.
638             uint256 inverse = (3 * denominator) ^ 2;
639 
640             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
641             // in modular arithmetic, doubling the correct bits in each step.
642             inverse *= 2 - denominator * inverse; // inverse mod 2^8
643             inverse *= 2 - denominator * inverse; // inverse mod 2^16
644             inverse *= 2 - denominator * inverse; // inverse mod 2^32
645             inverse *= 2 - denominator * inverse; // inverse mod 2^64
646             inverse *= 2 - denominator * inverse; // inverse mod 2^128
647             inverse *= 2 - denominator * inverse; // inverse mod 2^256
648 
649             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
650             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
651             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
652             // is no longer required.
653             result = prod0 * inverse;
654             return result;
655         }
656     }
657 
658     /**
659      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
660      */
661     function mulDiv(
662         uint256 x,
663         uint256 y,
664         uint256 denominator,
665         Rounding rounding
666     ) internal pure returns (uint256) {
667         uint256 result = mulDiv(x, y, denominator);
668         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
669             result += 1;
670         }
671         return result;
672     }
673 
674     /**
675      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
676      *
677      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
678      */
679     function sqrt(uint256 a) internal pure returns (uint256) {
680         if (a == 0) {
681             return 0;
682         }
683 
684         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
685         //
686         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
687         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
688         //
689         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
690         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
691         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
692         //
693         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
694         uint256 result = 1 << (log2(a) >> 1);
695 
696         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
697         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
698         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
699         // into the expected uint128 result.
700         unchecked {
701             result = (result + a / result) >> 1;
702             result = (result + a / result) >> 1;
703             result = (result + a / result) >> 1;
704             result = (result + a / result) >> 1;
705             result = (result + a / result) >> 1;
706             result = (result + a / result) >> 1;
707             result = (result + a / result) >> 1;
708             return min(result, a / result);
709         }
710     }
711 
712     /**
713      * @notice Calculates sqrt(a), following the selected rounding direction.
714      */
715     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
716         unchecked {
717             uint256 result = sqrt(a);
718             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
719         }
720     }
721 
722     /**
723      * @dev Return the log in base 2, rounded down, of a positive value.
724      * Returns 0 if given 0.
725      */
726     function log2(uint256 value) internal pure returns (uint256) {
727         uint256 result = 0;
728         unchecked {
729             if (value >> 128 > 0) {
730                 value >>= 128;
731                 result += 128;
732             }
733             if (value >> 64 > 0) {
734                 value >>= 64;
735                 result += 64;
736             }
737             if (value >> 32 > 0) {
738                 value >>= 32;
739                 result += 32;
740             }
741             if (value >> 16 > 0) {
742                 value >>= 16;
743                 result += 16;
744             }
745             if (value >> 8 > 0) {
746                 value >>= 8;
747                 result += 8;
748             }
749             if (value >> 4 > 0) {
750                 value >>= 4;
751                 result += 4;
752             }
753             if (value >> 2 > 0) {
754                 value >>= 2;
755                 result += 2;
756             }
757             if (value >> 1 > 0) {
758                 result += 1;
759             }
760         }
761         return result;
762     }
763 
764     /**
765      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
766      * Returns 0 if given 0.
767      */
768     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
769         unchecked {
770             uint256 result = log2(value);
771             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
772         }
773     }
774 
775     /**
776      * @dev Return the log in base 10, rounded down, of a positive value.
777      * Returns 0 if given 0.
778      */
779     function log10(uint256 value) internal pure returns (uint256) {
780         uint256 result = 0;
781         unchecked {
782             if (value >= 10**64) {
783                 value /= 10**64;
784                 result += 64;
785             }
786             if (value >= 10**32) {
787                 value /= 10**32;
788                 result += 32;
789             }
790             if (value >= 10**16) {
791                 value /= 10**16;
792                 result += 16;
793             }
794             if (value >= 10**8) {
795                 value /= 10**8;
796                 result += 8;
797             }
798             if (value >= 10**4) {
799                 value /= 10**4;
800                 result += 4;
801             }
802             if (value >= 10**2) {
803                 value /= 10**2;
804                 result += 2;
805             }
806             if (value >= 10**1) {
807                 result += 1;
808             }
809         }
810         return result;
811     }
812 
813     /**
814      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
815      * Returns 0 if given 0.
816      */
817     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
818         unchecked {
819             uint256 result = log10(value);
820             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
821         }
822     }
823 
824     /**
825      * @dev Return the log in base 256, rounded down, of a positive value.
826      * Returns 0 if given 0.
827      *
828      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
829      */
830     function log256(uint256 value) internal pure returns (uint256) {
831         uint256 result = 0;
832         unchecked {
833             if (value >> 128 > 0) {
834                 value >>= 128;
835                 result += 16;
836             }
837             if (value >> 64 > 0) {
838                 value >>= 64;
839                 result += 8;
840             }
841             if (value >> 32 > 0) {
842                 value >>= 32;
843                 result += 4;
844             }
845             if (value >> 16 > 0) {
846                 value >>= 16;
847                 result += 2;
848             }
849             if (value >> 8 > 0) {
850                 result += 1;
851             }
852         }
853         return result;
854     }
855 
856     /**
857      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
858      * Returns 0 if given 0.
859      */
860     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
861         unchecked {
862             uint256 result = log256(value);
863             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
864         }
865     }
866 }
867 
868 // File: @openzeppelin/contracts/utils/Strings.sol
869 
870 
871 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
872 
873 pragma solidity ^0.8.0;
874 
875 
876 /**
877  * @dev String operations.
878  */
879 library Strings {
880     bytes16 private constant _SYMBOLS = "0123456789abcdef";
881     uint8 private constant _ADDRESS_LENGTH = 20;
882 
883     /**
884      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
885      */
886     function toString(uint256 value) internal pure returns (string memory) {
887         unchecked {
888             uint256 length = Math.log10(value) + 1;
889             string memory buffer = new string(length);
890             uint256 ptr;
891             /// @solidity memory-safe-assembly
892             assembly {
893                 ptr := add(buffer, add(32, length))
894             }
895             while (true) {
896                 ptr--;
897                 /// @solidity memory-safe-assembly
898                 assembly {
899                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
900                 }
901                 value /= 10;
902                 if (value == 0) break;
903             }
904             return buffer;
905         }
906     }
907 
908     /**
909      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
910      */
911     function toHexString(uint256 value) internal pure returns (string memory) {
912         unchecked {
913             return toHexString(value, Math.log256(value) + 1);
914         }
915     }
916 
917     /**
918      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
919      */
920     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
921         bytes memory buffer = new bytes(2 * length + 2);
922         buffer[0] = "0";
923         buffer[1] = "x";
924         for (uint256 i = 2 * length + 1; i > 1; --i) {
925             buffer[i] = _SYMBOLS[value & 0xf];
926             value >>= 4;
927         }
928         require(value == 0, "Strings: hex length insufficient");
929         return string(buffer);
930     }
931 
932     /**
933      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
934      */
935     function toHexString(address addr) internal pure returns (string memory) {
936         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
937     }
938 }
939 
940 // File: operator-filter-registry/src/lib/Constants.sol
941 
942 
943 pragma solidity ^0.8.17;
944 
945 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
946 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
947 
948 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
949 
950 
951 pragma solidity ^0.8.13;
952 
953 interface IOperatorFilterRegistry {
954     /**
955      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
956      *         true if supplied registrant address is not registered.
957      */
958     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
959 
960     /**
961      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
962      */
963     function register(address registrant) external;
964 
965     /**
966      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
967      */
968     function registerAndSubscribe(address registrant, address subscription) external;
969 
970     /**
971      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
972      *         address without subscribing.
973      */
974     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
975 
976     /**
977      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
978      *         Note that this does not remove any filtered addresses or codeHashes.
979      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
980      */
981     function unregister(address addr) external;
982 
983     /**
984      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
985      */
986     function updateOperator(address registrant, address operator, bool filtered) external;
987 
988     /**
989      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
990      */
991     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
992 
993     /**
994      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
995      */
996     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
997 
998     /**
999      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1000      */
1001     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1002 
1003     /**
1004      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1005      *         subscription if present.
1006      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1007      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1008      *         used.
1009      */
1010     function subscribe(address registrant, address registrantToSubscribe) external;
1011 
1012     /**
1013      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1014      */
1015     function unsubscribe(address registrant, bool copyExistingEntries) external;
1016 
1017     /**
1018      * @notice Get the subscription address of a given registrant, if any.
1019      */
1020     function subscriptionOf(address addr) external returns (address registrant);
1021 
1022     /**
1023      * @notice Get the set of addresses subscribed to a given registrant.
1024      *         Note that order is not guaranteed as updates are made.
1025      */
1026     function subscribers(address registrant) external returns (address[] memory);
1027 
1028     /**
1029      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1030      *         Note that order is not guaranteed as updates are made.
1031      */
1032     function subscriberAt(address registrant, uint256 index) external returns (address);
1033 
1034     /**
1035      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1036      */
1037     function copyEntriesOf(address registrant, address registrantToCopy) external;
1038 
1039     /**
1040      * @notice Returns true if operator is filtered by a given address or its subscription.
1041      */
1042     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1043 
1044     /**
1045      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1046      */
1047     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1048 
1049     /**
1050      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1051      */
1052     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1053 
1054     /**
1055      * @notice Returns a list of filtered operators for a given address or its subscription.
1056      */
1057     function filteredOperators(address addr) external returns (address[] memory);
1058 
1059     /**
1060      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1061      *         Note that order is not guaranteed as updates are made.
1062      */
1063     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1064 
1065     /**
1066      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1067      *         its subscription.
1068      *         Note that order is not guaranteed as updates are made.
1069      */
1070     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1071 
1072     /**
1073      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1074      *         its subscription.
1075      *         Note that order is not guaranteed as updates are made.
1076      */
1077     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1078 
1079     /**
1080      * @notice Returns true if an address has registered
1081      */
1082     function isRegistered(address addr) external returns (bool);
1083 
1084     /**
1085      * @dev Convenience method to compute the code hash of an arbitrary contract
1086      */
1087     function codeHashOf(address addr) external returns (bytes32);
1088 }
1089 
1090 // File: operator-filter-registry/src/OperatorFilterer.sol
1091 
1092 
1093 pragma solidity ^0.8.13;
1094 
1095 
1096 /**
1097  * @title  OperatorFilterer
1098  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1099  *         registrant's entries in the OperatorFilterRegistry.
1100  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1101  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1102  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1103  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1104  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1105  *         will be locked to the options set during construction.
1106  */
1107 
1108 abstract contract OperatorFilterer {
1109     /// @dev Emitted when an operator is not allowed.
1110     error OperatorNotAllowed(address operator);
1111 
1112     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1113         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1114 
1115     /// @dev The constructor that is called when the contract is being deployed.
1116     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1117         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1118         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1119         // order for the modifier to filter addresses.
1120         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1121             if (subscribe) {
1122                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1123             } else {
1124                 if (subscriptionOrRegistrantToCopy != address(0)) {
1125                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1126                 } else {
1127                     OPERATOR_FILTER_REGISTRY.register(address(this));
1128                 }
1129             }
1130         }
1131     }
1132 
1133     /**
1134      * @dev A helper function to check if an operator is allowed.
1135      */
1136     modifier onlyAllowedOperator(address from) virtual {
1137         // Allow spending tokens from addresses with balance
1138         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1139         // from an EOA.
1140         if (from != msg.sender) {
1141             _checkFilterOperator(msg.sender);
1142         }
1143         _;
1144     }
1145 
1146     /**
1147      * @dev A helper function to check if an operator approval is allowed.
1148      */
1149     modifier onlyAllowedOperatorApproval(address operator) virtual {
1150         _checkFilterOperator(operator);
1151         _;
1152     }
1153 
1154     /**
1155      * @dev A helper function to check if an operator is allowed.
1156      */
1157     function _checkFilterOperator(address operator) internal view virtual {
1158         // Check registry code length to facilitate testing in environments without a deployed registry.
1159         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1160             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1161             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1162             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1163                 revert OperatorNotAllowed(operator);
1164             }
1165         }
1166     }
1167 }
1168 
1169 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
1170 
1171 
1172 pragma solidity ^0.8.13;
1173 
1174 
1175 /**
1176  * @title  DefaultOperatorFilterer
1177  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1178  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1179  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1180  *         will be locked to the options set during construction.
1181  */
1182 
1183 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1184     /// @dev The constructor that is called when the contract is being deployed.
1185     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1186 }
1187 
1188 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1189 
1190 
1191 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1192 
1193 pragma solidity ^0.8.0;
1194 
1195 /**
1196  * @dev Contract module that helps prevent reentrant calls to a function.
1197  *
1198  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1199  * available, which can be applied to functions to make sure there are no nested
1200  * (reentrant) calls to them.
1201  *
1202  * Note that because there is a single `nonReentrant` guard, functions marked as
1203  * `nonReentrant` may not call one another. This can be worked around by making
1204  * those functions `private`, and then adding `external` `nonReentrant` entry
1205  * points to them.
1206  *
1207  * TIP: If you would like to learn more about reentrancy and alternative ways
1208  * to protect against it, check out our blog post
1209  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1210  */
1211 abstract contract ReentrancyGuard {
1212     // Booleans are more expensive than uint256 or any type that takes up a full
1213     // word because each write operation emits an extra SLOAD to first read the
1214     // slot's contents, replace the bits taken up by the boolean, and then write
1215     // back. This is the compiler's defense against contract upgrades and
1216     // pointer aliasing, and it cannot be disabled.
1217 
1218     // The values being non-zero value makes deployment a bit more expensive,
1219     // but in exchange the refund on every call to nonReentrant will be lower in
1220     // amount. Since refunds are capped to a percentage of the total
1221     // transaction's gas, it is best to keep them low in cases like this one, to
1222     // increase the likelihood of the full refund coming into effect.
1223     uint256 private constant _NOT_ENTERED = 1;
1224     uint256 private constant _ENTERED = 2;
1225 
1226     uint256 private _status;
1227 
1228     constructor() {
1229         _status = _NOT_ENTERED;
1230     }
1231 
1232     /**
1233      * @dev Prevents a contract from calling itself, directly or indirectly.
1234      * Calling a `nonReentrant` function from another `nonReentrant`
1235      * function is not supported. It is possible to prevent this from happening
1236      * by making the `nonReentrant` function external, and making it call a
1237      * `private` function that does the actual work.
1238      */
1239     modifier nonReentrant() {
1240         _nonReentrantBefore();
1241         _;
1242         _nonReentrantAfter();
1243     }
1244 
1245     function _nonReentrantBefore() private {
1246         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1247         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1248 
1249         // Any calls to nonReentrant after this point will fail
1250         _status = _ENTERED;
1251     }
1252 
1253     function _nonReentrantAfter() private {
1254         // By storing the original value once again, a refund is triggered (see
1255         // https://eips.ethereum.org/EIPS/eip-2200)
1256         _status = _NOT_ENTERED;
1257     }
1258 }
1259 
1260 // File: @openzeppelin/contracts/utils/Context.sol
1261 
1262 
1263 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1264 
1265 pragma solidity ^0.8.0;
1266 
1267 /**
1268  * @dev Provides information about the current execution context, including the
1269  * sender of the transaction and its data. While these are generally available
1270  * via msg.sender and msg.data, they should not be accessed in such a direct
1271  * manner, since when dealing with meta-transactions the account sending and
1272  * paying for execution may not be the actual sender (as far as an application
1273  * is concerned).
1274  *
1275  * This contract is only required for intermediate, library-like contracts.
1276  */
1277 abstract contract Context {
1278     function _msgSender() internal view virtual returns (address) {
1279         return msg.sender;
1280     }
1281 
1282     function _msgData() internal view virtual returns (bytes calldata) {
1283         return msg.data;
1284     }
1285 }
1286 
1287 // File: @openzeppelin/contracts/access/Ownable.sol
1288 
1289 
1290 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1291 
1292 pragma solidity ^0.8.0;
1293 
1294 
1295 /**
1296  * @dev Contract module which provides a basic access control mechanism, where
1297  * there is an account (an owner) that can be granted exclusive access to
1298  * specific functions.
1299  *
1300  * By default, the owner account will be the one that deploys the contract. This
1301  * can later be changed with {transferOwnership}.
1302  *
1303  * This module is used through inheritance. It will make available the modifier
1304  * `onlyOwner`, which can be applied to your functions to restrict their use to
1305  * the owner.
1306  */
1307 abstract contract Ownable is Context {
1308     address private _owner;
1309 
1310     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1311 
1312     /**
1313      * @dev Initializes the contract setting the deployer as the initial owner.
1314      */
1315     constructor() {
1316         _transferOwnership(_msgSender());
1317     }
1318 
1319     /**
1320      * @dev Throws if called by any account other than the owner.
1321      */
1322     modifier onlyOwner() {
1323         _checkOwner();
1324         _;
1325     }
1326 
1327     /**
1328      * @dev Returns the address of the current owner.
1329      */
1330     function owner() public view virtual returns (address) {
1331         return _owner;
1332     }
1333 
1334     /**
1335      * @dev Throws if the sender is not the owner.
1336      */
1337     function _checkOwner() internal view virtual {
1338         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1339     }
1340 
1341     /**
1342      * @dev Leaves the contract without owner. It will not be possible to call
1343      * `onlyOwner` functions anymore. Can only be called by the current owner.
1344      *
1345      * NOTE: Renouncing ownership will leave the contract without an owner,
1346      * thereby removing any functionality that is only available to the owner.
1347      */
1348     function renounceOwnership() public virtual onlyOwner {
1349         _transferOwnership(address(0));
1350     }
1351 
1352     /**
1353      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1354      * Can only be called by the current owner.
1355      */
1356     function transferOwnership(address newOwner) public virtual onlyOwner {
1357         require(newOwner != address(0), "Ownable: new owner is the zero address");
1358         _transferOwnership(newOwner);
1359     }
1360 
1361     /**
1362      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1363      * Internal function without access restriction.
1364      */
1365     function _transferOwnership(address newOwner) internal virtual {
1366         address oldOwner = _owner;
1367         _owner = newOwner;
1368         emit OwnershipTransferred(oldOwner, newOwner);
1369     }
1370 }
1371 
1372 // File: erc721a/contracts/IERC721A.sol
1373 
1374 
1375 // ERC721A Contracts v4.2.3
1376 // Creator: Chiru Labs
1377 
1378 pragma solidity ^0.8.4;
1379 
1380 /**
1381  * @dev Interface of ERC721A.
1382  */
1383 interface IERC721A {
1384     /**
1385      * The caller must own the token or be an approved operator.
1386      */
1387     error ApprovalCallerNotOwnerNorApproved();
1388 
1389     /**
1390      * The token does not exist.
1391      */
1392     error ApprovalQueryForNonexistentToken();
1393 
1394     /**
1395      * Cannot query the balance for the zero address.
1396      */
1397     error BalanceQueryForZeroAddress();
1398 
1399     /**
1400      * Cannot mint to the zero address.
1401      */
1402     error MintToZeroAddress();
1403 
1404     /**
1405      * The quantity of tokens minted must be more than zero.
1406      */
1407     error MintZeroQuantity();
1408 
1409     /**
1410      * The token does not exist.
1411      */
1412     error OwnerQueryForNonexistentToken();
1413 
1414     /**
1415      * The caller must own the token or be an approved operator.
1416      */
1417     error TransferCallerNotOwnerNorApproved();
1418 
1419     /**
1420      * The token must be owned by `from`.
1421      */
1422     error TransferFromIncorrectOwner();
1423 
1424     /**
1425      * Cannot safely transfer to a contract that does not implement the
1426      * ERC721Receiver interface.
1427      */
1428     error TransferToNonERC721ReceiverImplementer();
1429 
1430     /**
1431      * Cannot transfer to the zero address.
1432      */
1433     error TransferToZeroAddress();
1434 
1435     /**
1436      * The token does not exist.
1437      */
1438     error URIQueryForNonexistentToken();
1439 
1440     /**
1441      * The `quantity` minted with ERC2309 exceeds the safety limit.
1442      */
1443     error MintERC2309QuantityExceedsLimit();
1444 
1445     /**
1446      * The `extraData` cannot be set on an unintialized ownership slot.
1447      */
1448     error OwnershipNotInitializedForExtraData();
1449 
1450     // =============================================================
1451     //                            STRUCTS
1452     // =============================================================
1453 
1454     struct TokenOwnership {
1455         // The address of the owner.
1456         address addr;
1457         // Stores the start time of ownership with minimal overhead for tokenomics.
1458         uint64 startTimestamp;
1459         // Whether the token has been burned.
1460         bool burned;
1461         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1462         uint24 extraData;
1463     }
1464 
1465     // =============================================================
1466     //                         TOKEN COUNTERS
1467     // =============================================================
1468 
1469     /**
1470      * @dev Returns the total number of tokens in existence.
1471      * Burned tokens will reduce the count.
1472      * To get the total number of tokens minted, please see {_totalMinted}.
1473      */
1474     function totalSupply() external view returns (uint256);
1475 
1476     // =============================================================
1477     //                            IERC165
1478     // =============================================================
1479 
1480     /**
1481      * @dev Returns true if this contract implements the interface defined by
1482      * `interfaceId`. See the corresponding
1483      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1484      * to learn more about how these ids are created.
1485      *
1486      * This function call must use less than 30000 gas.
1487      */
1488     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1489 
1490     // =============================================================
1491     //                            IERC721
1492     // =============================================================
1493 
1494     /**
1495      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1496      */
1497     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1498 
1499     /**
1500      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1501      */
1502     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1503 
1504     /**
1505      * @dev Emitted when `owner` enables or disables
1506      * (`approved`) `operator` to manage all of its assets.
1507      */
1508     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1509 
1510     /**
1511      * @dev Returns the number of tokens in `owner`'s account.
1512      */
1513     function balanceOf(address owner) external view returns (uint256 balance);
1514 
1515     /**
1516      * @dev Returns the owner of the `tokenId` token.
1517      *
1518      * Requirements:
1519      *
1520      * - `tokenId` must exist.
1521      */
1522     function ownerOf(uint256 tokenId) external view returns (address owner);
1523 
1524     /**
1525      * @dev Safely transfers `tokenId` token from `from` to `to`,
1526      * checking first that contract recipients are aware of the ERC721 protocol
1527      * to prevent tokens from being forever locked.
1528      *
1529      * Requirements:
1530      *
1531      * - `from` cannot be the zero address.
1532      * - `to` cannot be the zero address.
1533      * - `tokenId` token must exist and be owned by `from`.
1534      * - If the caller is not `from`, it must be have been allowed to move
1535      * this token by either {approve} or {setApprovalForAll}.
1536      * - If `to` refers to a smart contract, it must implement
1537      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1538      *
1539      * Emits a {Transfer} event.
1540      */
1541     function safeTransferFrom(
1542         address from,
1543         address to,
1544         uint256 tokenId,
1545         bytes calldata data
1546     ) external payable;
1547 
1548     /**
1549      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1550      */
1551     function safeTransferFrom(
1552         address from,
1553         address to,
1554         uint256 tokenId
1555     ) external payable;
1556 
1557     /**
1558      * @dev Transfers `tokenId` from `from` to `to`.
1559      *
1560      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1561      * whenever possible.
1562      *
1563      * Requirements:
1564      *
1565      * - `from` cannot be the zero address.
1566      * - `to` cannot be the zero address.
1567      * - `tokenId` token must be owned by `from`.
1568      * - If the caller is not `from`, it must be approved to move this token
1569      * by either {approve} or {setApprovalForAll}.
1570      *
1571      * Emits a {Transfer} event.
1572      */
1573     function transferFrom(
1574         address from,
1575         address to,
1576         uint256 tokenId
1577     ) external payable;
1578 
1579     /**
1580      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1581      * The approval is cleared when the token is transferred.
1582      *
1583      * Only a single account can be approved at a time, so approving the
1584      * zero address clears previous approvals.
1585      *
1586      * Requirements:
1587      *
1588      * - The caller must own the token or be an approved operator.
1589      * - `tokenId` must exist.
1590      *
1591      * Emits an {Approval} event.
1592      */
1593     function approve(address to, uint256 tokenId) external payable;
1594 
1595     /**
1596      * @dev Approve or remove `operator` as an operator for the caller.
1597      * Operators can call {transferFrom} or {safeTransferFrom}
1598      * for any token owned by the caller.
1599      *
1600      * Requirements:
1601      *
1602      * - The `operator` cannot be the caller.
1603      *
1604      * Emits an {ApprovalForAll} event.
1605      */
1606     function setApprovalForAll(address operator, bool _approved) external;
1607 
1608     /**
1609      * @dev Returns the account approved for `tokenId` token.
1610      *
1611      * Requirements:
1612      *
1613      * - `tokenId` must exist.
1614      */
1615     function getApproved(uint256 tokenId) external view returns (address operator);
1616 
1617     /**
1618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1619      *
1620      * See {setApprovalForAll}.
1621      */
1622     function isApprovedForAll(address owner, address operator) external view returns (bool);
1623 
1624     // =============================================================
1625     //                        IERC721Metadata
1626     // =============================================================
1627 
1628     /**
1629      * @dev Returns the token collection name.
1630      */
1631     function name() external view returns (string memory);
1632 
1633     /**
1634      * @dev Returns the token collection symbol.
1635      */
1636     function symbol() external view returns (string memory);
1637 
1638     /**
1639      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1640      */
1641     function tokenURI(uint256 tokenId) external view returns (string memory);
1642 
1643     // =============================================================
1644     //                           IERC2309
1645     // =============================================================
1646 
1647     /**
1648      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1649      * (inclusive) is transferred from `from` to `to`, as defined in the
1650      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1651      *
1652      * See {_mintERC2309} for more details.
1653      */
1654     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1655 }
1656 
1657 // File: erc721a/contracts/ERC721A.sol
1658 
1659 
1660 // ERC721A Contracts v4.2.3
1661 // Creator: Chiru Labs
1662 
1663 pragma solidity ^0.8.4;
1664 
1665 
1666 /**
1667  * @dev Interface of ERC721 token receiver.
1668  */
1669 interface ERC721A__IERC721Receiver {
1670     function onERC721Received(
1671         address operator,
1672         address from,
1673         uint256 tokenId,
1674         bytes calldata data
1675     ) external returns (bytes4);
1676 }
1677 
1678 /**
1679  * @title ERC721A
1680  *
1681  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1682  * Non-Fungible Token Standard, including the Metadata extension.
1683  * Optimized for lower gas during batch mints.
1684  *
1685  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1686  * starting from `_startTokenId()`.
1687  *
1688  * Assumptions:
1689  *
1690  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1691  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1692  */
1693 contract ERC721A is IERC721A {
1694     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1695     struct TokenApprovalRef {
1696         address value;
1697     }
1698 
1699     // =============================================================
1700     //                           CONSTANTS
1701     // =============================================================
1702 
1703     // Mask of an entry in packed address data.
1704     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1705 
1706     // The bit position of `numberMinted` in packed address data.
1707     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1708 
1709     // The bit position of `numberBurned` in packed address data.
1710     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1711 
1712     // The bit position of `aux` in packed address data.
1713     uint256 private constant _BITPOS_AUX = 192;
1714 
1715     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1716     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1717 
1718     // The bit position of `startTimestamp` in packed ownership.
1719     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1720 
1721     // The bit mask of the `burned` bit in packed ownership.
1722     uint256 private constant _BITMASK_BURNED = 1 << 224;
1723 
1724     // The bit position of the `nextInitialized` bit in packed ownership.
1725     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1726 
1727     // The bit mask of the `nextInitialized` bit in packed ownership.
1728     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1729 
1730     // The bit position of `extraData` in packed ownership.
1731     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1732 
1733     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1734     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1735 
1736     // The mask of the lower 160 bits for addresses.
1737     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1738 
1739     // The maximum `quantity` that can be minted with {_mintERC2309}.
1740     // This limit is to prevent overflows on the address data entries.
1741     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1742     // is required to cause an overflow, which is unrealistic.
1743     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1744 
1745     // The `Transfer` event signature is given by:
1746     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1747     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1748         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1749 
1750     // =============================================================
1751     //                            STORAGE
1752     // =============================================================
1753 
1754     // The next token ID to be minted.
1755     uint256 private _currentIndex;
1756 
1757     // The number of tokens burned.
1758     uint256 private _burnCounter;
1759 
1760     // Token name
1761     string private _name;
1762 
1763     // Token symbol
1764     string private _symbol;
1765 
1766     // Mapping from token ID to ownership details
1767     // An empty struct value does not necessarily mean the token is unowned.
1768     // See {_packedOwnershipOf} implementation for details.
1769     //
1770     // Bits Layout:
1771     // - [0..159]   `addr`
1772     // - [160..223] `startTimestamp`
1773     // - [224]      `burned`
1774     // - [225]      `nextInitialized`
1775     // - [232..255] `extraData`
1776     mapping(uint256 => uint256) private _packedOwnerships;
1777 
1778     // Mapping owner address to address data.
1779     //
1780     // Bits Layout:
1781     // - [0..63]    `balance`
1782     // - [64..127]  `numberMinted`
1783     // - [128..191] `numberBurned`
1784     // - [192..255] `aux`
1785     mapping(address => uint256) private _packedAddressData;
1786 
1787     // Mapping from token ID to approved address.
1788     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1789 
1790     // Mapping from owner to operator approvals
1791     mapping(address => mapping(address => bool)) private _operatorApprovals;
1792 
1793     // =============================================================
1794     //                          CONSTRUCTOR
1795     // =============================================================
1796 
1797     constructor(string memory name_, string memory symbol_) {
1798         _name = name_;
1799         _symbol = symbol_;
1800         _currentIndex = _startTokenId();
1801     }
1802 
1803     // =============================================================
1804     //                   TOKEN COUNTING OPERATIONS
1805     // =============================================================
1806 
1807     /**
1808      * @dev Returns the starting token ID.
1809      * To change the starting token ID, please override this function.
1810      */
1811     function _startTokenId() internal view virtual returns (uint256) {
1812         return 0;
1813     }
1814 
1815     /**
1816      * @dev Returns the next token ID to be minted.
1817      */
1818     function _nextTokenId() internal view virtual returns (uint256) {
1819         return _currentIndex;
1820     }
1821 
1822     /**
1823      * @dev Returns the total number of tokens in existence.
1824      * Burned tokens will reduce the count.
1825      * To get the total number of tokens minted, please see {_totalMinted}.
1826      */
1827     function totalSupply() public view virtual override returns (uint256) {
1828         // Counter underflow is impossible as _burnCounter cannot be incremented
1829         // more than `_currentIndex - _startTokenId()` times.
1830         unchecked {
1831             return _currentIndex - _burnCounter - _startTokenId();
1832         }
1833     }
1834 
1835     /**
1836      * @dev Returns the total amount of tokens minted in the contract.
1837      */
1838     function _totalMinted() internal view virtual returns (uint256) {
1839         // Counter underflow is impossible as `_currentIndex` does not decrement,
1840         // and it is initialized to `_startTokenId()`.
1841         unchecked {
1842             return _currentIndex - _startTokenId();
1843         }
1844     }
1845 
1846     /**
1847      * @dev Returns the total number of tokens burned.
1848      */
1849     function _totalBurned() internal view virtual returns (uint256) {
1850         return _burnCounter;
1851     }
1852 
1853     // =============================================================
1854     //                    ADDRESS DATA OPERATIONS
1855     // =============================================================
1856 
1857     /**
1858      * @dev Returns the number of tokens in `owner`'s account.
1859      */
1860     function balanceOf(address owner) public view virtual override returns (uint256) {
1861         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1862         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1863     }
1864 
1865     /**
1866      * Returns the number of tokens minted by `owner`.
1867      */
1868     function _numberMinted(address owner) internal view returns (uint256) {
1869         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1870     }
1871 
1872     /**
1873      * Returns the number of tokens burned by or on behalf of `owner`.
1874      */
1875     function _numberBurned(address owner) internal view returns (uint256) {
1876         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1877     }
1878 
1879     /**
1880      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1881      */
1882     function _getAux(address owner) internal view returns (uint64) {
1883         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1884     }
1885 
1886     /**
1887      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1888      * If there are multiple variables, please pack them into a uint64.
1889      */
1890     function _setAux(address owner, uint64 aux) internal virtual {
1891         uint256 packed = _packedAddressData[owner];
1892         uint256 auxCasted;
1893         // Cast `aux` with assembly to avoid redundant masking.
1894         assembly {
1895             auxCasted := aux
1896         }
1897         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1898         _packedAddressData[owner] = packed;
1899     }
1900 
1901     // =============================================================
1902     //                            IERC165
1903     // =============================================================
1904 
1905     /**
1906      * @dev Returns true if this contract implements the interface defined by
1907      * `interfaceId`. See the corresponding
1908      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1909      * to learn more about how these ids are created.
1910      *
1911      * This function call must use less than 30000 gas.
1912      */
1913     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1914         // The interface IDs are constants representing the first 4 bytes
1915         // of the XOR of all function selectors in the interface.
1916         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1917         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1918         return
1919             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1920             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1921             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1922     }
1923 
1924     // =============================================================
1925     //                        IERC721Metadata
1926     // =============================================================
1927 
1928     /**
1929      * @dev Returns the token collection name.
1930      */
1931     function name() public view virtual override returns (string memory) {
1932         return _name;
1933     }
1934 
1935     /**
1936      * @dev Returns the token collection symbol.
1937      */
1938     function symbol() public view virtual override returns (string memory) {
1939         return _symbol;
1940     }
1941 
1942     /**
1943      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1944      */
1945     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1946         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1947 
1948         string memory baseURI = _baseURI();
1949         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1950     }
1951 
1952     /**
1953      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1954      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1955      * by default, it can be overridden in child contracts.
1956      */
1957     function _baseURI() internal view virtual returns (string memory) {
1958         return '';
1959     }
1960 
1961     // =============================================================
1962     //                     OWNERSHIPS OPERATIONS
1963     // =============================================================
1964 
1965     /**
1966      * @dev Returns the owner of the `tokenId` token.
1967      *
1968      * Requirements:
1969      *
1970      * - `tokenId` must exist.
1971      */
1972     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1973         return address(uint160(_packedOwnershipOf(tokenId)));
1974     }
1975 
1976     /**
1977      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1978      * It gradually moves to O(1) as tokens get transferred around over time.
1979      */
1980     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1981         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1982     }
1983 
1984     /**
1985      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1986      */
1987     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1988         return _unpackedOwnership(_packedOwnerships[index]);
1989     }
1990 
1991     /**
1992      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1993      */
1994     function _initializeOwnershipAt(uint256 index) internal virtual {
1995         if (_packedOwnerships[index] == 0) {
1996             _packedOwnerships[index] = _packedOwnershipOf(index);
1997         }
1998     }
1999 
2000     /**
2001      * Returns the packed ownership data of `tokenId`.
2002      */
2003     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2004         uint256 curr = tokenId;
2005 
2006         unchecked {
2007             if (_startTokenId() <= curr)
2008                 if (curr < _currentIndex) {
2009                     uint256 packed = _packedOwnerships[curr];
2010                     // If not burned.
2011                     if (packed & _BITMASK_BURNED == 0) {
2012                         // Invariant:
2013                         // There will always be an initialized ownership slot
2014                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2015                         // before an unintialized ownership slot
2016                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2017                         // Hence, `curr` will not underflow.
2018                         //
2019                         // We can directly compare the packed value.
2020                         // If the address is zero, packed will be zero.
2021                         while (packed == 0) {
2022                             packed = _packedOwnerships[--curr];
2023                         }
2024                         return packed;
2025                     }
2026                 }
2027         }
2028         revert OwnerQueryForNonexistentToken();
2029     }
2030 
2031     /**
2032      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2033      */
2034     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2035         ownership.addr = address(uint160(packed));
2036         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2037         ownership.burned = packed & _BITMASK_BURNED != 0;
2038         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2039     }
2040 
2041     /**
2042      * @dev Packs ownership data into a single uint256.
2043      */
2044     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2045         assembly {
2046             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2047             owner := and(owner, _BITMASK_ADDRESS)
2048             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2049             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2050         }
2051     }
2052 
2053     /**
2054      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2055      */
2056     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2057         // For branchless setting of the `nextInitialized` flag.
2058         assembly {
2059             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2060             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2061         }
2062     }
2063 
2064     // =============================================================
2065     //                      APPROVAL OPERATIONS
2066     // =============================================================
2067 
2068     /**
2069      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2070      * The approval is cleared when the token is transferred.
2071      *
2072      * Only a single account can be approved at a time, so approving the
2073      * zero address clears previous approvals.
2074      *
2075      * Requirements:
2076      *
2077      * - The caller must own the token or be an approved operator.
2078      * - `tokenId` must exist.
2079      *
2080      * Emits an {Approval} event.
2081      */
2082     function approve(address to, uint256 tokenId) public payable virtual override {
2083         address owner = ownerOf(tokenId);
2084 
2085         if (_msgSenderERC721A() != owner)
2086             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2087                 revert ApprovalCallerNotOwnerNorApproved();
2088             }
2089 
2090         _tokenApprovals[tokenId].value = to;
2091         emit Approval(owner, to, tokenId);
2092     }
2093 
2094     /**
2095      * @dev Returns the account approved for `tokenId` token.
2096      *
2097      * Requirements:
2098      *
2099      * - `tokenId` must exist.
2100      */
2101     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2102         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2103 
2104         return _tokenApprovals[tokenId].value;
2105     }
2106 
2107     /**
2108      * @dev Approve or remove `operator` as an operator for the caller.
2109      * Operators can call {transferFrom} or {safeTransferFrom}
2110      * for any token owned by the caller.
2111      *
2112      * Requirements:
2113      *
2114      * - The `operator` cannot be the caller.
2115      *
2116      * Emits an {ApprovalForAll} event.
2117      */
2118     function setApprovalForAll(address operator, bool approved) public virtual override {
2119         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2120         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2121     }
2122 
2123     /**
2124      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2125      *
2126      * See {setApprovalForAll}.
2127      */
2128     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2129         return _operatorApprovals[owner][operator];
2130     }
2131 
2132     /**
2133      * @dev Returns whether `tokenId` exists.
2134      *
2135      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2136      *
2137      * Tokens start existing when they are minted. See {_mint}.
2138      */
2139     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2140         return
2141             _startTokenId() <= tokenId &&
2142             tokenId < _currentIndex && // If within bounds,
2143             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2144     }
2145 
2146     /**
2147      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2148      */
2149     function _isSenderApprovedOrOwner(
2150         address approvedAddress,
2151         address owner,
2152         address msgSender
2153     ) private pure returns (bool result) {
2154         assembly {
2155             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2156             owner := and(owner, _BITMASK_ADDRESS)
2157             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2158             msgSender := and(msgSender, _BITMASK_ADDRESS)
2159             // `msgSender == owner || msgSender == approvedAddress`.
2160             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2161         }
2162     }
2163 
2164     /**
2165      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2166      */
2167     function _getApprovedSlotAndAddress(uint256 tokenId)
2168         private
2169         view
2170         returns (uint256 approvedAddressSlot, address approvedAddress)
2171     {
2172         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2173         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2174         assembly {
2175             approvedAddressSlot := tokenApproval.slot
2176             approvedAddress := sload(approvedAddressSlot)
2177         }
2178     }
2179 
2180     // =============================================================
2181     //                      TRANSFER OPERATIONS
2182     // =============================================================
2183 
2184     /**
2185      * @dev Transfers `tokenId` from `from` to `to`.
2186      *
2187      * Requirements:
2188      *
2189      * - `from` cannot be the zero address.
2190      * - `to` cannot be the zero address.
2191      * - `tokenId` token must be owned by `from`.
2192      * - If the caller is not `from`, it must be approved to move this token
2193      * by either {approve} or {setApprovalForAll}.
2194      *
2195      * Emits a {Transfer} event.
2196      */
2197     function transferFrom(
2198         address from,
2199         address to,
2200         uint256 tokenId
2201     ) public payable virtual override {
2202         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2203 
2204         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2205 
2206         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2207 
2208         // The nested ifs save around 20+ gas over a compound boolean condition.
2209         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2210             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2211 
2212         if (to == address(0)) revert TransferToZeroAddress();
2213 
2214         _beforeTokenTransfers(from, to, tokenId, 1);
2215 
2216         // Clear approvals from the previous owner.
2217         assembly {
2218             if approvedAddress {
2219                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2220                 sstore(approvedAddressSlot, 0)
2221             }
2222         }
2223 
2224         // Underflow of the sender's balance is impossible because we check for
2225         // ownership above and the recipient's balance can't realistically overflow.
2226         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2227         unchecked {
2228             // We can directly increment and decrement the balances.
2229             --_packedAddressData[from]; // Updates: `balance -= 1`.
2230             ++_packedAddressData[to]; // Updates: `balance += 1`.
2231 
2232             // Updates:
2233             // - `address` to the next owner.
2234             // - `startTimestamp` to the timestamp of transfering.
2235             // - `burned` to `false`.
2236             // - `nextInitialized` to `true`.
2237             _packedOwnerships[tokenId] = _packOwnershipData(
2238                 to,
2239                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2240             );
2241 
2242             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2243             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2244                 uint256 nextTokenId = tokenId + 1;
2245                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2246                 if (_packedOwnerships[nextTokenId] == 0) {
2247                     // If the next slot is within bounds.
2248                     if (nextTokenId != _currentIndex) {
2249                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2250                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2251                     }
2252                 }
2253             }
2254         }
2255 
2256         emit Transfer(from, to, tokenId);
2257         _afterTokenTransfers(from, to, tokenId, 1);
2258     }
2259 
2260     /**
2261      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2262      */
2263     function safeTransferFrom(
2264         address from,
2265         address to,
2266         uint256 tokenId
2267     ) public payable virtual override {
2268         safeTransferFrom(from, to, tokenId, '');
2269     }
2270 
2271     /**
2272      * @dev Safely transfers `tokenId` token from `from` to `to`.
2273      *
2274      * Requirements:
2275      *
2276      * - `from` cannot be the zero address.
2277      * - `to` cannot be the zero address.
2278      * - `tokenId` token must exist and be owned by `from`.
2279      * - If the caller is not `from`, it must be approved to move this token
2280      * by either {approve} or {setApprovalForAll}.
2281      * - If `to` refers to a smart contract, it must implement
2282      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2283      *
2284      * Emits a {Transfer} event.
2285      */
2286     function safeTransferFrom(
2287         address from,
2288         address to,
2289         uint256 tokenId,
2290         bytes memory _data
2291     ) public payable virtual override {
2292         transferFrom(from, to, tokenId);
2293         if (to.code.length != 0)
2294             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2295                 revert TransferToNonERC721ReceiverImplementer();
2296             }
2297     }
2298 
2299     /**
2300      * @dev Hook that is called before a set of serially-ordered token IDs
2301      * are about to be transferred. This includes minting.
2302      * And also called before burning one token.
2303      *
2304      * `startTokenId` - the first token ID to be transferred.
2305      * `quantity` - the amount to be transferred.
2306      *
2307      * Calling conditions:
2308      *
2309      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2310      * transferred to `to`.
2311      * - When `from` is zero, `tokenId` will be minted for `to`.
2312      * - When `to` is zero, `tokenId` will be burned by `from`.
2313      * - `from` and `to` are never both zero.
2314      */
2315     function _beforeTokenTransfers(
2316         address from,
2317         address to,
2318         uint256 startTokenId,
2319         uint256 quantity
2320     ) internal virtual {}
2321 
2322     /**
2323      * @dev Hook that is called after a set of serially-ordered token IDs
2324      * have been transferred. This includes minting.
2325      * And also called after one token has been burned.
2326      *
2327      * `startTokenId` - the first token ID to be transferred.
2328      * `quantity` - the amount to be transferred.
2329      *
2330      * Calling conditions:
2331      *
2332      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2333      * transferred to `to`.
2334      * - When `from` is zero, `tokenId` has been minted for `to`.
2335      * - When `to` is zero, `tokenId` has been burned by `from`.
2336      * - `from` and `to` are never both zero.
2337      */
2338     function _afterTokenTransfers(
2339         address from,
2340         address to,
2341         uint256 startTokenId,
2342         uint256 quantity
2343     ) internal virtual {}
2344 
2345     /**
2346      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2347      *
2348      * `from` - Previous owner of the given token ID.
2349      * `to` - Target address that will receive the token.
2350      * `tokenId` - Token ID to be transferred.
2351      * `_data` - Optional data to send along with the call.
2352      *
2353      * Returns whether the call correctly returned the expected magic value.
2354      */
2355     function _checkContractOnERC721Received(
2356         address from,
2357         address to,
2358         uint256 tokenId,
2359         bytes memory _data
2360     ) private returns (bool) {
2361         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2362             bytes4 retval
2363         ) {
2364             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2365         } catch (bytes memory reason) {
2366             if (reason.length == 0) {
2367                 revert TransferToNonERC721ReceiverImplementer();
2368             } else {
2369                 assembly {
2370                     revert(add(32, reason), mload(reason))
2371                 }
2372             }
2373         }
2374     }
2375 
2376     // =============================================================
2377     //                        MINT OPERATIONS
2378     // =============================================================
2379 
2380     /**
2381      * @dev Mints `quantity` tokens and transfers them to `to`.
2382      *
2383      * Requirements:
2384      *
2385      * - `to` cannot be the zero address.
2386      * - `quantity` must be greater than 0.
2387      *
2388      * Emits a {Transfer} event for each mint.
2389      */
2390     function _mint(address to, uint256 quantity) internal virtual {
2391         uint256 startTokenId = _currentIndex;
2392         if (quantity == 0) revert MintZeroQuantity();
2393 
2394         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2395 
2396         // Overflows are incredibly unrealistic.
2397         // `balance` and `numberMinted` have a maximum limit of 2**64.
2398         // `tokenId` has a maximum limit of 2**256.
2399         unchecked {
2400             // Updates:
2401             // - `balance += quantity`.
2402             // - `numberMinted += quantity`.
2403             //
2404             // We can directly add to the `balance` and `numberMinted`.
2405             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2406 
2407             // Updates:
2408             // - `address` to the owner.
2409             // - `startTimestamp` to the timestamp of minting.
2410             // - `burned` to `false`.
2411             // - `nextInitialized` to `quantity == 1`.
2412             _packedOwnerships[startTokenId] = _packOwnershipData(
2413                 to,
2414                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2415             );
2416 
2417             uint256 toMasked;
2418             uint256 end = startTokenId + quantity;
2419 
2420             // Use assembly to loop and emit the `Transfer` event for gas savings.
2421             // The duplicated `log4` removes an extra check and reduces stack juggling.
2422             // The assembly, together with the surrounding Solidity code, have been
2423             // delicately arranged to nudge the compiler into producing optimized opcodes.
2424             assembly {
2425                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2426                 toMasked := and(to, _BITMASK_ADDRESS)
2427                 // Emit the `Transfer` event.
2428                 log4(
2429                     0, // Start of data (0, since no data).
2430                     0, // End of data (0, since no data).
2431                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2432                     0, // `address(0)`.
2433                     toMasked, // `to`.
2434                     startTokenId // `tokenId`.
2435                 )
2436 
2437                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2438                 // that overflows uint256 will make the loop run out of gas.
2439                 // The compiler will optimize the `iszero` away for performance.
2440                 for {
2441                     let tokenId := add(startTokenId, 1)
2442                 } iszero(eq(tokenId, end)) {
2443                     tokenId := add(tokenId, 1)
2444                 } {
2445                     // Emit the `Transfer` event. Similar to above.
2446                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2447                 }
2448             }
2449             if (toMasked == 0) revert MintToZeroAddress();
2450 
2451             _currentIndex = end;
2452         }
2453         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2454     }
2455 
2456     /**
2457      * @dev Mints `quantity` tokens and transfers them to `to`.
2458      *
2459      * This function is intended for efficient minting only during contract creation.
2460      *
2461      * It emits only one {ConsecutiveTransfer} as defined in
2462      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2463      * instead of a sequence of {Transfer} event(s).
2464      *
2465      * Calling this function outside of contract creation WILL make your contract
2466      * non-compliant with the ERC721 standard.
2467      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2468      * {ConsecutiveTransfer} event is only permissible during contract creation.
2469      *
2470      * Requirements:
2471      *
2472      * - `to` cannot be the zero address.
2473      * - `quantity` must be greater than 0.
2474      *
2475      * Emits a {ConsecutiveTransfer} event.
2476      */
2477     function _mintERC2309(address to, uint256 quantity) internal virtual {
2478         uint256 startTokenId = _currentIndex;
2479         if (to == address(0)) revert MintToZeroAddress();
2480         if (quantity == 0) revert MintZeroQuantity();
2481         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2482 
2483         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2484 
2485         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2486         unchecked {
2487             // Updates:
2488             // - `balance += quantity`.
2489             // - `numberMinted += quantity`.
2490             //
2491             // We can directly add to the `balance` and `numberMinted`.
2492             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2493 
2494             // Updates:
2495             // - `address` to the owner.
2496             // - `startTimestamp` to the timestamp of minting.
2497             // - `burned` to `false`.
2498             // - `nextInitialized` to `quantity == 1`.
2499             _packedOwnerships[startTokenId] = _packOwnershipData(
2500                 to,
2501                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2502             );
2503 
2504             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2505 
2506             _currentIndex = startTokenId + quantity;
2507         }
2508         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2509     }
2510 
2511     /**
2512      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2513      *
2514      * Requirements:
2515      *
2516      * - If `to` refers to a smart contract, it must implement
2517      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2518      * - `quantity` must be greater than 0.
2519      *
2520      * See {_mint}.
2521      *
2522      * Emits a {Transfer} event for each mint.
2523      */
2524     function _safeMint(
2525         address to,
2526         uint256 quantity,
2527         bytes memory _data
2528     ) internal virtual {
2529         _mint(to, quantity);
2530 
2531         unchecked {
2532             if (to.code.length != 0) {
2533                 uint256 end = _currentIndex;
2534                 uint256 index = end - quantity;
2535                 do {
2536                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2537                         revert TransferToNonERC721ReceiverImplementer();
2538                     }
2539                 } while (index < end);
2540                 // Reentrancy protection.
2541                 if (_currentIndex != end) revert();
2542             }
2543         }
2544     }
2545 
2546     /**
2547      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2548      */
2549     function _safeMint(address to, uint256 quantity) internal virtual {
2550         _safeMint(to, quantity, '');
2551     }
2552 
2553     // =============================================================
2554     //                        BURN OPERATIONS
2555     // =============================================================
2556 
2557     /**
2558      * @dev Equivalent to `_burn(tokenId, false)`.
2559      */
2560     function _burn(uint256 tokenId) internal virtual {
2561         _burn(tokenId, false);
2562     }
2563 
2564     /**
2565      * @dev Destroys `tokenId`.
2566      * The approval is cleared when the token is burned.
2567      *
2568      * Requirements:
2569      *
2570      * - `tokenId` must exist.
2571      *
2572      * Emits a {Transfer} event.
2573      */
2574     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2575         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2576 
2577         address from = address(uint160(prevOwnershipPacked));
2578 
2579         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2580 
2581         if (approvalCheck) {
2582             // The nested ifs save around 20+ gas over a compound boolean condition.
2583             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2584                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2585         }
2586 
2587         _beforeTokenTransfers(from, address(0), tokenId, 1);
2588 
2589         // Clear approvals from the previous owner.
2590         assembly {
2591             if approvedAddress {
2592                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2593                 sstore(approvedAddressSlot, 0)
2594             }
2595         }
2596 
2597         // Underflow of the sender's balance is impossible because we check for
2598         // ownership above and the recipient's balance can't realistically overflow.
2599         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2600         unchecked {
2601             // Updates:
2602             // - `balance -= 1`.
2603             // - `numberBurned += 1`.
2604             //
2605             // We can directly decrement the balance, and increment the number burned.
2606             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2607             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2608 
2609             // Updates:
2610             // - `address` to the last owner.
2611             // - `startTimestamp` to the timestamp of burning.
2612             // - `burned` to `true`.
2613             // - `nextInitialized` to `true`.
2614             _packedOwnerships[tokenId] = _packOwnershipData(
2615                 from,
2616                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2617             );
2618 
2619             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2620             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2621                 uint256 nextTokenId = tokenId + 1;
2622                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2623                 if (_packedOwnerships[nextTokenId] == 0) {
2624                     // If the next slot is within bounds.
2625                     if (nextTokenId != _currentIndex) {
2626                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2627                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2628                     }
2629                 }
2630             }
2631         }
2632 
2633         emit Transfer(from, address(0), tokenId);
2634         _afterTokenTransfers(from, address(0), tokenId, 1);
2635 
2636         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2637         unchecked {
2638             _burnCounter++;
2639         }
2640     }
2641 
2642     // =============================================================
2643     //                     EXTRA DATA OPERATIONS
2644     // =============================================================
2645 
2646     /**
2647      * @dev Directly sets the extra data for the ownership data `index`.
2648      */
2649     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2650         uint256 packed = _packedOwnerships[index];
2651         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2652         uint256 extraDataCasted;
2653         // Cast `extraData` with assembly to avoid redundant masking.
2654         assembly {
2655             extraDataCasted := extraData
2656         }
2657         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2658         _packedOwnerships[index] = packed;
2659     }
2660 
2661     /**
2662      * @dev Called during each token transfer to set the 24bit `extraData` field.
2663      * Intended to be overridden by the cosumer contract.
2664      *
2665      * `previousExtraData` - the value of `extraData` before transfer.
2666      *
2667      * Calling conditions:
2668      *
2669      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2670      * transferred to `to`.
2671      * - When `from` is zero, `tokenId` will be minted for `to`.
2672      * - When `to` is zero, `tokenId` will be burned by `from`.
2673      * - `from` and `to` are never both zero.
2674      */
2675     function _extraData(
2676         address from,
2677         address to,
2678         uint24 previousExtraData
2679     ) internal view virtual returns (uint24) {}
2680 
2681     /**
2682      * @dev Returns the next extra data for the packed ownership data.
2683      * The returned result is shifted into position.
2684      */
2685     function _nextExtraData(
2686         address from,
2687         address to,
2688         uint256 prevOwnershipPacked
2689     ) private view returns (uint256) {
2690         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2691         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2692     }
2693 
2694     // =============================================================
2695     //                       OTHER OPERATIONS
2696     // =============================================================
2697 
2698     /**
2699      * @dev Returns the message sender (defaults to `msg.sender`).
2700      *
2701      * If you are writing GSN compatible contracts, you need to override this function.
2702      */
2703     function _msgSenderERC721A() internal view virtual returns (address) {
2704         return msg.sender;
2705     }
2706 
2707     /**
2708      * @dev Converts a uint256 to its ASCII string decimal representation.
2709      */
2710     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2711         assembly {
2712             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2713             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2714             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2715             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2716             let m := add(mload(0x40), 0xa0)
2717             // Update the free memory pointer to allocate.
2718             mstore(0x40, m)
2719             // Assign the `str` to the end.
2720             str := sub(m, 0x20)
2721             // Zeroize the slot after the string.
2722             mstore(str, 0)
2723 
2724             // Cache the end of the memory to calculate the length later.
2725             let end := str
2726 
2727             // We write the string from rightmost digit to leftmost digit.
2728             // The following is essentially a do-while loop that also handles the zero case.
2729             // prettier-ignore
2730             for { let temp := value } 1 {} {
2731                 str := sub(str, 1)
2732                 // Write the character to the pointer.
2733                 // The ASCII index of the '0' character is 48.
2734                 mstore8(str, add(48, mod(temp, 10)))
2735                 // Keep dividing `temp` until zero.
2736                 temp := div(temp, 10)
2737                 // prettier-ignore
2738                 if iszero(temp) { break }
2739             }
2740 
2741             let length := sub(end, str)
2742             // Move the pointer 32 bytes leftwards to make room for the length.
2743             str := sub(str, 0x20)
2744             // Store the length.
2745             mstore(str, length)
2746         }
2747     }
2748 }
2749 
2750 // File: contracts/TESTIES-Main.sol
2751 
2752 pragma solidity >=0.8.12 <=0.8.18;
2753 
2754 contract TESTIES is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2755     
2756     using Strings for uint256;
2757 
2758     // STATE VARIABLES //
2759 
2760     /// @notice Funds withdrawal address.
2761     address payable public withdrawalAddress;
2762 
2763     /// @notice Boolean for enabling and disabling public minting.
2764     bool public publicMintingStatus;
2765 
2766     /// @notice Boolean for whether collection is revealed or not.
2767     bool public revealedStatus;
2768 
2769     /// @notice Mapping for number of NFTs minted by an address.
2770     mapping(address => uint256) public addressMinted;
2771 
2772     /// @notice Revealed metadata url prefix.
2773     string public metadataURLPrefix;
2774     
2775     /// @notice Revealed metadata url suffix.
2776     string public metadataURLSuffix = ".json";
2777 
2778     /// @notice Not revealed metadata url.
2779     string public notRevealedMetadataURL;
2780 
2781     /// @notice Max mint per wallet.
2782     uint256 public maxMintPerAddress = 10;
2783 
2784     /// @notice Collection max supply.
2785     uint256 public maxSupply = 10000;
2786 
2787     /// @notice Price of one NFT.
2788     uint256 public price = 0.0042 ether;
2789 
2790     /// @notice Free mint per wallet.
2791     uint256 public freeMintPerAddress = 2;
2792 
2793     constructor() ERC721A("TESTIES","TT") {}
2794 
2795     // PUBLIC FUNCTION, WRITE CONTRACT FUNCTION //
2796 
2797     /**
2798      * @notice Public payable function.
2799      * Function mints a specified amount of tokens to the caller's address.
2800      * Requires public minting status to be true.
2801      * Requires sufficient ETH to execute.
2802      * Enter the amount of tokens to be minted in the amount field.
2803      */
2804     function publicMint(uint256 amount) public payable {
2805        require(publicMintingStatus == true, "Public mint status false, requires to be true");
2806        require(Address.isContract(msg.sender) == false, "Caller is a contract");
2807        require(addressMinted[msg.sender] + amount <= maxMintPerAddress, "Request exceeds max mint per address");
2808        require(totalSupply() + amount <= maxSupply, "Request exceeds max supply");
2809        if (addressMinted[msg.sender] + amount <= freeMintPerAddress) {
2810           _safeMint(msg.sender, amount);
2811           addressMinted[msg.sender] += amount;
2812         }
2813         else if (addressMinted[msg.sender] + amount > freeMintPerAddress && addressMinted[msg.sender] + amount <= maxMintPerAddress) {
2814             require(msg.value >= price * ((addressMinted[msg.sender] + amount) - freeMintPerAddress), "Not enough funds");
2815             _safeMint(msg.sender, amount);
2816             addressMinted[msg.sender] += amount;
2817         }
2818     }
2819 
2820     // SMART CONTRACT OWNER ONLY FUNCTIONS, WRITE CONTRACT FUNCTIONS //
2821 
2822     /**
2823      * @notice Smart contract owner only function.
2824      * Function airdrops a specified amount of tokens to an array of addresses.
2825      * Enter the recepients in an array form like this [address1,address2,address3] in the recipients field and enter the amount of NFTs to be airdropped to each recipient in the amount field.
2826      */
2827     function airdrop(address[] calldata recipients, uint256 amount) public onlyOwner {
2828         require(totalSupply() + recipients.length * amount <= maxSupply, "Request exceeds max supply");
2829         for (uint256 i = 0; i < recipients.length; i++) {
2830             _safeMint(recipients[i], amount);
2831         }
2832     }
2833 
2834     /** 
2835      * @notice Smart contract owner only function.
2836      * Function can mint different quantities of NFTs in batches to the recipient.
2837      * Enter the recipient's address in the recipient field.
2838      * Enter the NFT quantity for each batch in an array form in the nftQuantityForEachBatch field.
2839      * For example if the nftQuantityForEachBatch array is like this [30,50,70] in total 150 NFTs would be minted in batches of 30, 50 and 70.
2840      */
2841     function mintInBatches(address recipient, uint256[] calldata nftQuantityForEachBatch) public onlyOwner {
2842         for (uint256 i = 0; i < nftQuantityForEachBatch.length; ++i) {   
2843             require(totalSupply() + nftQuantityForEachBatch[i] <= maxSupply, "request exceeds maxSupply");
2844             _safeMint(recipient, nftQuantityForEachBatch[i]);
2845         }
2846     }
2847 
2848     /**
2849      * @notice Smart contract owner only function.
2850      * Function sets the free mint per address amount.
2851      * Enter the new free mint per address in the freeMintAmount field.
2852      * The freeMintAmount must be less than or equal to the maxMintPerAddress.
2853      */
2854     function setFreeMintPerAddress(uint256 freeMintAmount) public onlyOwner {
2855         require(freeMintAmount <= maxMintPerAddress, "freeMintAmount must be less than or equal to the maxMintPerAddress");
2856         freeMintPerAddress = freeMintAmount;
2857     }  
2858 
2859     /**
2860      * @notice Smart contract owner only function.
2861      * Function sets the max mint per address amount.
2862      * Enter the new max mint per address in the maxMintAmount field.
2863      * The maxMintAmount must be less than or equal to the maxSupply.
2864      */
2865     function setMaxMintPerAddress(uint256 maxMintAmount) public onlyOwner {
2866         require(maxMintAmount <= maxSupply, "maxMintAmount must be less than or equal to the maxSupply");
2867         maxMintPerAddress = maxMintAmount;
2868     }
2869 
2870     /**
2871      * @notice Smart contract owner only function.
2872      * Function sets a new max supply of tokens which can be minted from the contract.
2873      * Enter the new max supply in the newMaxSupply field.
2874      * The newMaxSupply must be greater than or equal to the totalSupply.
2875      */
2876     function setMaxSupply(uint256 newMaxSupply) public onlyOwner {
2877         require(newMaxSupply >= totalSupply(), "newMaxSupply must be greater than or equal to the totalSupply");
2878         maxSupply = newMaxSupply;
2879     }
2880 
2881     /**
2882      * @notice Smart contract owner only function.
2883      * Function updates the metadata url prefix.
2884      * Enter the new metadata url prefix in the newMetadataURLPrefix field.
2885      */
2886     function setMetadataURLPrefix(string memory newMetadataURLPrefix) public onlyOwner {
2887         metadataURLPrefix = newMetadataURLPrefix;
2888     }
2889 
2890     /**
2891      * @notice Smart contract owner only function.
2892      * Function updates the metadata url suffix.
2893      * Enter the new metadata url suffix in the newMetadataURLSuffix field.
2894      */
2895     function setMetadataURLSuffix(string memory newMetadataURLSuffix) public onlyOwner {
2896         metadataURLSuffix = newMetadataURLSuffix;
2897     }
2898 
2899     /**
2900      * @notice Smart contract owner only function.
2901      * Function updates the not revealed metadata url.
2902      * Enter the new not revealed metadata url in the newNotRevealedMetadataURL field.
2903      */
2904     function setNotRevealedMetadataURL(string memory newNotRevealedMetadataURL) public onlyOwner {
2905         notRevealedMetadataURL = newNotRevealedMetadataURL;
2906     }
2907 
2908     /**
2909      * @notice Smart contract owner only function.
2910      * Function updates the price for minting a single NFT.
2911      * Enter the new price in the newPrice field, entered price must be in wei, check ether to wei conversion.
2912      */
2913     function setPrice(uint256 newPrice) public onlyOwner {
2914         price = newPrice;
2915     }
2916 
2917     /**
2918      * @notice Smart contract owner only function.
2919      * Function sets the public minting status.
2920      * Enter the word true in the status field to enable public minting.
2921      * Enter the word false in the status field to disable public minting.
2922      */
2923     function setPublicMintingStatus(bool status) public onlyOwner {
2924         publicMintingStatus = status;
2925     }
2926 
2927     /**
2928      * @notice Smart contract owner only function.
2929      * Function sets the revealed status for the collection.
2930      * Enter the word true in the status field to reveal the collection.
2931      * Enter the word false in the status field to hide or unreveal the collection.
2932      */
2933     function setRevealedStatus(bool status) public onlyOwner {
2934         revealedStatus = status;
2935     }
2936 
2937     /** 
2938      * @notice Smart contract owner only function.
2939      * Function sets the withdrawal address for the funds in the smart contract.
2940      * Enter the new withdrawal address in the newWithdrawalAddress field.
2941      * To withdraw to a payment splitter smart contract,
2942      * enter the payment splitter smart contract's contract address in the newWithdrawalAddress field. 
2943      */ 
2944     function setWithdrawalAddress(address newWithdrawalAddress) public onlyOwner {
2945         withdrawalAddress = payable(newWithdrawalAddress);
2946     }
2947 
2948     /**
2949      * @notice Smart contract owner only function.
2950      * Function withdraws the funds in the smart contract to the withdrawal address.
2951      * Enter the number 0 in the withdraw field to withdraw the funds successfully.
2952      */
2953     function withdraw() public payable onlyOwner nonReentrant {
2954         (bool success, ) = payable(withdrawalAddress).call{value: address(this).balance}("");
2955         require(success);
2956     }
2957 
2958     /**
2959      * @notice Smart contract owner only function.
2960      * Function withdraws the ERC20 token amount accumulated in the smart contract to the entered account address.
2961      * Enter the ERC20 token contract address in the token field, the address to which the accumulated ERC20 tokens would be transferred in the account field and the amount of accumulated ERC20 tokens to be transferred in the amount field.
2962      */
2963     function withdrawERC20(IERC20 token, address account, uint256 amount) public onlyOwner {
2964         SafeERC20.safeTransfer(token, account, amount);
2965     }
2966 
2967     // OVERRIDDEN PUBLIC WRITE CONTRACT FUNCTIONS: OpenSea's Royalty Filterer Implementation. //
2968 
2969     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2970         super.approve(operator, tokenId);
2971     }
2972 
2973     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2974         super.setApprovalForAll(operator, approved);
2975     }
2976 
2977     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2978         super.safeTransferFrom(from, to, tokenId);
2979     }
2980 
2981     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public payable override onlyAllowedOperator(from) {
2982         super.safeTransferFrom(from, to, tokenId, data);
2983     }
2984 
2985     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2986         super.transferFrom(from, to, tokenId);
2987     }
2988 
2989     // GETTER FUNCTIONS, READ CONTRACT FUNCTIONS //
2990 
2991     /**
2992      * @notice Function queries and returns all the NFT tokenIds owned by an address.
2993      * Enter the address in the owner field.
2994      * Click on query after filling out the field.
2995      */
2996     function walletOfOwner(address owner) public view returns (uint256[] memory ownedTokenIds) {
2997         ownedTokenIds = new uint256[](balanceOf(owner));
2998         uint256 currentTokenId = 1;
2999         uint256 currentTokenIndex = 0;
3000         while (currentTokenIndex < totalSupply() && currentTokenId <= totalSupply()) {
3001             if (_exists(currentTokenId) && ownerOf(currentTokenId) == owner) {
3002                ownedTokenIds[currentTokenIndex] = currentTokenId;
3003                currentTokenIndex++;
3004             }
3005             currentTokenId++;
3006         }
3007         return ownedTokenIds;
3008     }
3009 
3010     /**
3011      * @notice Function scans and returns all the NFT tokenIds owned by an address from startTokenId till stopTokenId.
3012      * startTokenId must be equal to or greater than zero and smaller than stopTokenId.
3013      * stopTokenId must be greater than startTokenId and smaller or equal to totalSupply.
3014      * Enter the tokenId from where the scan is to be started in the startTokenId field. 
3015      * Enter the tokenId till where the scan is to be done in the stopTokenId field.
3016      * For example, if startTokenId is 10 and stopTokenId is 80, the function will return all the NFT tokenIds owned by the address from tokenId 10 till tokenId 80.
3017      * Click on query after filling out all the fields.
3018      */
3019     function walletOfOwnerInRange(address owner, uint256 startTokenId, uint256 stopTokenId) public view returns (uint256[] memory ownedTokenIds) {
3020         require(startTokenId >= 0 && startTokenId < stopTokenId, "startTokenId must be equal to or greater than zero and smaller than stopTokenId");
3021         require(stopTokenId > startTokenId && stopTokenId <= totalSupply(), "stopTokenId must be greater than startTokenId and smaller or equal to totalSupply");
3022         ownedTokenIds = new uint256[](stopTokenId - startTokenId + 1);
3023         uint256 currentTokenId = startTokenId;
3024         uint256 currentTokenIndex = 0;
3025         while (currentTokenIndex < stopTokenId && currentTokenId <= stopTokenId) {
3026             if (_exists(currentTokenId) && ownerOf(currentTokenId) == owner) {
3027                 ownedTokenIds[currentTokenIndex] = currentTokenId;
3028                 currentTokenIndex++;
3029             }
3030             currentTokenId++;
3031         }
3032         assembly{mstore(ownedTokenIds, currentTokenIndex)}
3033         return ownedTokenIds;
3034     }
3035 
3036     // OVERRIDDEN GETTER FUNCTIONS, READ CONTRACT FUNCTIONS //
3037 
3038     /**
3039      * @notice Function queries and returns the URI for a NFT tokenId.
3040      * Enter the tokenId of the NFT in tokenId field.
3041      */
3042     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
3043         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
3044         if (revealedStatus == false) {
3045             return notRevealedMetadataURL;
3046         } 
3047         string memory currentBaseURI = _baseURI();
3048         return bytes(currentBaseURI).length > 0
3049         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), metadataURLSuffix))
3050         : "";
3051     }
3052 
3053     // INTERNAL FUNCTIONS //
3054 
3055     /// @notice Internal function which is called by the tokenURI function.
3056     function _baseURI() internal view virtual override returns (string memory) {
3057         return metadataURLPrefix;
3058     }
3059 
3060     /// @notice Internal function which ensures the first minted NFT has tokenId as 1.
3061     function _startTokenId() internal view virtual override returns (uint256) {
3062         return 1;
3063     }
3064 }