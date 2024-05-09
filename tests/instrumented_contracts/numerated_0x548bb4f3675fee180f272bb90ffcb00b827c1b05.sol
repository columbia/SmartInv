1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Address.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
6 
7 pragma solidity ^0.8.1;
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      *
30      * [IMPORTANT]
31      * ====
32      * You shouldn't rely on `isContract` to protect against flash loan attacks!
33      *
34      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
35      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
36      * constructor.
37      * ====
38      */
39     function isContract(address account) internal view returns (bool) {
40         // This method relies on extcodesize/address.code.length, which returns 0
41         // for contracts in construction, since the code is only stored at the end
42         // of the constructor execution.
43 
44         return account.code.length > 0;
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      */
63     function sendValue(address payable recipient, uint256 amount) internal {
64         require(address(this).balance >= amount, "Address: insufficient balance");
65 
66         (bool success, ) = recipient.call{value: amount}("");
67         require(success, "Address: unable to send value, recipient may have reverted");
68     }
69 
70     /**
71      * @dev Performs a Solidity function call using a low level `call`. A
72      * plain `call` is an unsafe replacement for a function call: use this
73      * function instead.
74      *
75      * If `target` reverts with a revert reason, it is bubbled up by this
76      * function (like regular Solidity function calls).
77      *
78      * Returns the raw returned data. To convert to the expected return value,
79      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
80      *
81      * Requirements:
82      *
83      * - `target` must be a contract.
84      * - calling `target` with `data` must not revert.
85      *
86      * _Available since v3.1._
87      */
88     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
89         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
90     }
91 
92     /**
93      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
94      * `errorMessage` as a fallback revert reason when `target` reverts.
95      *
96      * _Available since v3.1._
97      */
98     function functionCall(
99         address target,
100         bytes memory data,
101         string memory errorMessage
102     ) internal returns (bytes memory) {
103         return functionCallWithValue(target, data, 0, errorMessage);
104     }
105 
106     /**
107      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
108      * but also transferring `value` wei to `target`.
109      *
110      * Requirements:
111      *
112      * - the calling contract must have an ETH balance of at least `value`.
113      * - the called Solidity function must be `payable`.
114      *
115      * _Available since v3.1._
116      */
117     function functionCallWithValue(
118         address target,
119         bytes memory data,
120         uint256 value
121     ) internal returns (bytes memory) {
122         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
123     }
124 
125     /**
126      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
127      * with `errorMessage` as a fallback revert reason when `target` reverts.
128      *
129      * _Available since v3.1._
130      */
131     function functionCallWithValue(
132         address target,
133         bytes memory data,
134         uint256 value,
135         string memory errorMessage
136     ) internal returns (bytes memory) {
137         require(address(this).balance >= value, "Address: insufficient balance for call");
138         (bool success, bytes memory returndata) = target.call{value: value}(data);
139         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
140     }
141 
142     /**
143      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
144      * but performing a static call.
145      *
146      * _Available since v3.3._
147      */
148     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
149         return functionStaticCall(target, data, "Address: low-level static call failed");
150     }
151 
152     /**
153      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
154      * but performing a static call.
155      *
156      * _Available since v3.3._
157      */
158     function functionStaticCall(
159         address target,
160         bytes memory data,
161         string memory errorMessage
162     ) internal view returns (bytes memory) {
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(
184         address target,
185         bytes memory data,
186         string memory errorMessage
187     ) internal returns (bytes memory) {
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
194      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
195      *
196      * _Available since v4.8._
197      */
198     function verifyCallResultFromTarget(
199         address target,
200         bool success,
201         bytes memory returndata,
202         string memory errorMessage
203     ) internal view returns (bytes memory) {
204         if (success) {
205             if (returndata.length == 0) {
206                 // only check isContract if the call was successful and the return data is empty
207                 // otherwise we already know that it was a contract
208                 require(isContract(target), "Address: call to non-contract");
209             }
210             return returndata;
211         } else {
212             _revert(returndata, errorMessage);
213         }
214     }
215 
216     /**
217      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
218      * revert reason or using the provided one.
219      *
220      * _Available since v4.3._
221      */
222     function verifyCallResult(
223         bool success,
224         bytes memory returndata,
225         string memory errorMessage
226     ) internal pure returns (bytes memory) {
227         if (success) {
228             return returndata;
229         } else {
230             _revert(returndata, errorMessage);
231         }
232     }
233 
234     function _revert(bytes memory returndata, string memory errorMessage) private pure {
235         // Look for revert reason and bubble it up if present
236         if (returndata.length > 0) {
237             // The easiest way to bubble the revert reason is using memory via assembly
238             /// @solidity memory-safe-assembly
239             assembly {
240                 let returndata_size := mload(returndata)
241                 revert(add(32, returndata), returndata_size)
242             }
243         } else {
244             revert(errorMessage);
245         }
246     }
247 }
248 
249 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
250 
251 
252 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
258  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
259  *
260  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
261  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
262  * need to send a transaction, and thus is not required to hold Ether at all.
263  */
264 interface IERC20Permit {
265     /**
266      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
267      * given ``owner``'s signed approval.
268      *
269      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
270      * ordering also apply here.
271      *
272      * Emits an {Approval} event.
273      *
274      * Requirements:
275      *
276      * - `spender` cannot be the zero address.
277      * - `deadline` must be a timestamp in the future.
278      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
279      * over the EIP712-formatted function arguments.
280      * - the signature must use ``owner``'s current nonce (see {nonces}).
281      *
282      * For more information on the signature format, see the
283      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
284      * section].
285      */
286     function permit(
287         address owner,
288         address spender,
289         uint256 value,
290         uint256 deadline,
291         uint8 v,
292         bytes32 r,
293         bytes32 s
294     ) external;
295 
296     /**
297      * @dev Returns the current nonce for `owner`. This value must be
298      * included whenever a signature is generated for {permit}.
299      *
300      * Every successful call to {permit} increases ``owner``'s nonce by one. This
301      * prevents a signature from being used multiple times.
302      */
303     function nonces(address owner) external view returns (uint256);
304 
305     /**
306      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
307      */
308     // solhint-disable-next-line func-name-mixedcase
309     function DOMAIN_SEPARATOR() external view returns (bytes32);
310 }
311 
312 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
313 
314 
315 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
316 
317 pragma solidity ^0.8.0;
318 
319 /**
320  * @dev Interface of the ERC20 standard as defined in the EIP.
321  */
322 interface IERC20 {
323     /**
324      * @dev Emitted when `value` tokens are moved from one account (`from`) to
325      * another (`to`).
326      *
327      * Note that `value` may be zero.
328      */
329     event Transfer(address indexed from, address indexed to, uint256 value);
330 
331     /**
332      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
333      * a call to {approve}. `value` is the new allowance.
334      */
335     event Approval(address indexed owner, address indexed spender, uint256 value);
336 
337     /**
338      * @dev Returns the amount of tokens in existence.
339      */
340     function totalSupply() external view returns (uint256);
341 
342     /**
343      * @dev Returns the amount of tokens owned by `account`.
344      */
345     function balanceOf(address account) external view returns (uint256);
346 
347     /**
348      * @dev Moves `amount` tokens from the caller's account to `to`.
349      *
350      * Returns a boolean value indicating whether the operation succeeded.
351      *
352      * Emits a {Transfer} event.
353      */
354     function transfer(address to, uint256 amount) external returns (bool);
355 
356     /**
357      * @dev Returns the remaining number of tokens that `spender` will be
358      * allowed to spend on behalf of `owner` through {transferFrom}. This is
359      * zero by default.
360      *
361      * This value changes when {approve} or {transferFrom} are called.
362      */
363     function allowance(address owner, address spender) external view returns (uint256);
364 
365     /**
366      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
367      *
368      * Returns a boolean value indicating whether the operation succeeded.
369      *
370      * IMPORTANT: Beware that changing an allowance with this method brings the risk
371      * that someone may use both the old and the new allowance by unfortunate
372      * transaction ordering. One possible solution to mitigate this race
373      * condition is to first reduce the spender's allowance to 0 and set the
374      * desired value afterwards:
375      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
376      *
377      * Emits an {Approval} event.
378      */
379     function approve(address spender, uint256 amount) external returns (bool);
380 
381     /**
382      * @dev Moves `amount` tokens from `from` to `to` using the
383      * allowance mechanism. `amount` is then deducted from the caller's
384      * allowance.
385      *
386      * Returns a boolean value indicating whether the operation succeeded.
387      *
388      * Emits a {Transfer} event.
389      */
390     function transferFrom(
391         address from,
392         address to,
393         uint256 amount
394     ) external returns (bool);
395 }
396 
397 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using Address for address;
418 
419     function safeTransfer(
420         IERC20 token,
421         address to,
422         uint256 value
423     ) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
425     }
426 
427     function safeTransferFrom(
428         IERC20 token,
429         address from,
430         address to,
431         uint256 value
432     ) internal {
433         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
434     }
435 
436     /**
437      * @dev Deprecated. This function has issues similar to the ones found in
438      * {IERC20-approve}, and its usage is discouraged.
439      *
440      * Whenever possible, use {safeIncreaseAllowance} and
441      * {safeDecreaseAllowance} instead.
442      */
443     function safeApprove(
444         IERC20 token,
445         address spender,
446         uint256 value
447     ) internal {
448         // safeApprove should only be called when setting an initial allowance,
449         // or when resetting it to zero. To increase and decrease it, use
450         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
451         require(
452             (value == 0) || (token.allowance(address(this), spender) == 0),
453             "SafeERC20: approve from non-zero to non-zero allowance"
454         );
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
456     }
457 
458     function safeIncreaseAllowance(
459         IERC20 token,
460         address spender,
461         uint256 value
462     ) internal {
463         uint256 newAllowance = token.allowance(address(this), spender) + value;
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     function safeDecreaseAllowance(
468         IERC20 token,
469         address spender,
470         uint256 value
471     ) internal {
472         unchecked {
473             uint256 oldAllowance = token.allowance(address(this), spender);
474             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
475             uint256 newAllowance = oldAllowance - value;
476             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477         }
478     }
479 
480     function safePermit(
481         IERC20Permit token,
482         address owner,
483         address spender,
484         uint256 value,
485         uint256 deadline,
486         uint8 v,
487         bytes32 r,
488         bytes32 s
489     ) internal {
490         uint256 nonceBefore = token.nonces(owner);
491         token.permit(owner, spender, value, deadline, v, r, s);
492         uint256 nonceAfter = token.nonces(owner);
493         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
494     }
495 
496     /**
497      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
498      * on the return value: the return value is optional (but if data is returned, it must not be false).
499      * @param token The token targeted by the call.
500      * @param data The call data (encoded using abi.encode or one of its variants).
501      */
502     function _callOptionalReturn(IERC20 token, bytes memory data) private {
503         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
504         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
505         // the target address contains contract code and also asserts for success in the low-level call.
506 
507         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
508         if (returndata.length > 0) {
509             // Return data is optional
510             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
511         }
512     }
513 }
514 
515 // File: @openzeppelin/contracts/utils/math/Math.sol
516 
517 
518 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
519 
520 pragma solidity ^0.8.0;
521 
522 /**
523  * @dev Standard math utilities missing in the Solidity language.
524  */
525 library Math {
526     enum Rounding {
527         Down, // Toward negative infinity
528         Up, // Toward infinity
529         Zero // Toward zero
530     }
531 
532     /**
533      * @dev Returns the largest of two numbers.
534      */
535     function max(uint256 a, uint256 b) internal pure returns (uint256) {
536         return a > b ? a : b;
537     }
538 
539     /**
540      * @dev Returns the smallest of two numbers.
541      */
542     function min(uint256 a, uint256 b) internal pure returns (uint256) {
543         return a < b ? a : b;
544     }
545 
546     /**
547      * @dev Returns the average of two numbers. The result is rounded towards
548      * zero.
549      */
550     function average(uint256 a, uint256 b) internal pure returns (uint256) {
551         // (a + b) / 2 can overflow.
552         return (a & b) + (a ^ b) / 2;
553     }
554 
555     /**
556      * @dev Returns the ceiling of the division of two numbers.
557      *
558      * This differs from standard division with `/` in that it rounds up instead
559      * of rounding down.
560      */
561     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
562         // (a + b - 1) / b can overflow on addition, so we distribute.
563         return a == 0 ? 0 : (a - 1) / b + 1;
564     }
565 
566     /**
567      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
568      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
569      * with further edits by Uniswap Labs also under MIT license.
570      */
571     function mulDiv(
572         uint256 x,
573         uint256 y,
574         uint256 denominator
575     ) internal pure returns (uint256 result) {
576         unchecked {
577             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
578             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
579             // variables such that product = prod1 * 2^256 + prod0.
580             uint256 prod0; // Least significant 256 bits of the product
581             uint256 prod1; // Most significant 256 bits of the product
582             assembly {
583                 let mm := mulmod(x, y, not(0))
584                 prod0 := mul(x, y)
585                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
586             }
587 
588             // Handle non-overflow cases, 256 by 256 division.
589             if (prod1 == 0) {
590                 return prod0 / denominator;
591             }
592 
593             // Make sure the result is less than 2^256. Also prevents denominator == 0.
594             require(denominator > prod1);
595 
596             ///////////////////////////////////////////////
597             // 512 by 256 division.
598             ///////////////////////////////////////////////
599 
600             // Make division exact by subtracting the remainder from [prod1 prod0].
601             uint256 remainder;
602             assembly {
603                 // Compute remainder using mulmod.
604                 remainder := mulmod(x, y, denominator)
605 
606                 // Subtract 256 bit number from 512 bit number.
607                 prod1 := sub(prod1, gt(remainder, prod0))
608                 prod0 := sub(prod0, remainder)
609             }
610 
611             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
612             // See https://cs.stackexchange.com/q/138556/92363.
613 
614             // Does not overflow because the denominator cannot be zero at this stage in the function.
615             uint256 twos = denominator & (~denominator + 1);
616             assembly {
617                 // Divide denominator by twos.
618                 denominator := div(denominator, twos)
619 
620                 // Divide [prod1 prod0] by twos.
621                 prod0 := div(prod0, twos)
622 
623                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
624                 twos := add(div(sub(0, twos), twos), 1)
625             }
626 
627             // Shift in bits from prod1 into prod0.
628             prod0 |= prod1 * twos;
629 
630             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
631             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
632             // four bits. That is, denominator * inv = 1 mod 2^4.
633             uint256 inverse = (3 * denominator) ^ 2;
634 
635             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
636             // in modular arithmetic, doubling the correct bits in each step.
637             inverse *= 2 - denominator * inverse; // inverse mod 2^8
638             inverse *= 2 - denominator * inverse; // inverse mod 2^16
639             inverse *= 2 - denominator * inverse; // inverse mod 2^32
640             inverse *= 2 - denominator * inverse; // inverse mod 2^64
641             inverse *= 2 - denominator * inverse; // inverse mod 2^128
642             inverse *= 2 - denominator * inverse; // inverse mod 2^256
643 
644             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
645             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
646             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
647             // is no longer required.
648             result = prod0 * inverse;
649             return result;
650         }
651     }
652 
653     /**
654      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
655      */
656     function mulDiv(
657         uint256 x,
658         uint256 y,
659         uint256 denominator,
660         Rounding rounding
661     ) internal pure returns (uint256) {
662         uint256 result = mulDiv(x, y, denominator);
663         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
664             result += 1;
665         }
666         return result;
667     }
668 
669     /**
670      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
671      *
672      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
673      */
674     function sqrt(uint256 a) internal pure returns (uint256) {
675         if (a == 0) {
676             return 0;
677         }
678 
679         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
680         //
681         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
682         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
683         //
684         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
685         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
686         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
687         //
688         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
689         uint256 result = 1 << (log2(a) >> 1);
690 
691         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
692         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
693         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
694         // into the expected uint128 result.
695         unchecked {
696             result = (result + a / result) >> 1;
697             result = (result + a / result) >> 1;
698             result = (result + a / result) >> 1;
699             result = (result + a / result) >> 1;
700             result = (result + a / result) >> 1;
701             result = (result + a / result) >> 1;
702             result = (result + a / result) >> 1;
703             return min(result, a / result);
704         }
705     }
706 
707     /**
708      * @notice Calculates sqrt(a), following the selected rounding direction.
709      */
710     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
711         unchecked {
712             uint256 result = sqrt(a);
713             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
714         }
715     }
716 
717     /**
718      * @dev Return the log in base 2, rounded down, of a positive value.
719      * Returns 0 if given 0.
720      */
721     function log2(uint256 value) internal pure returns (uint256) {
722         uint256 result = 0;
723         unchecked {
724             if (value >> 128 > 0) {
725                 value >>= 128;
726                 result += 128;
727             }
728             if (value >> 64 > 0) {
729                 value >>= 64;
730                 result += 64;
731             }
732             if (value >> 32 > 0) {
733                 value >>= 32;
734                 result += 32;
735             }
736             if (value >> 16 > 0) {
737                 value >>= 16;
738                 result += 16;
739             }
740             if (value >> 8 > 0) {
741                 value >>= 8;
742                 result += 8;
743             }
744             if (value >> 4 > 0) {
745                 value >>= 4;
746                 result += 4;
747             }
748             if (value >> 2 > 0) {
749                 value >>= 2;
750                 result += 2;
751             }
752             if (value >> 1 > 0) {
753                 result += 1;
754             }
755         }
756         return result;
757     }
758 
759     /**
760      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
761      * Returns 0 if given 0.
762      */
763     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
764         unchecked {
765             uint256 result = log2(value);
766             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
767         }
768     }
769 
770     /**
771      * @dev Return the log in base 10, rounded down, of a positive value.
772      * Returns 0 if given 0.
773      */
774     function log10(uint256 value) internal pure returns (uint256) {
775         uint256 result = 0;
776         unchecked {
777             if (value >= 10**64) {
778                 value /= 10**64;
779                 result += 64;
780             }
781             if (value >= 10**32) {
782                 value /= 10**32;
783                 result += 32;
784             }
785             if (value >= 10**16) {
786                 value /= 10**16;
787                 result += 16;
788             }
789             if (value >= 10**8) {
790                 value /= 10**8;
791                 result += 8;
792             }
793             if (value >= 10**4) {
794                 value /= 10**4;
795                 result += 4;
796             }
797             if (value >= 10**2) {
798                 value /= 10**2;
799                 result += 2;
800             }
801             if (value >= 10**1) {
802                 result += 1;
803             }
804         }
805         return result;
806     }
807 
808     /**
809      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
810      * Returns 0 if given 0.
811      */
812     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
813         unchecked {
814             uint256 result = log10(value);
815             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
816         }
817     }
818 
819     /**
820      * @dev Return the log in base 256, rounded down, of a positive value.
821      * Returns 0 if given 0.
822      *
823      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
824      */
825     function log256(uint256 value) internal pure returns (uint256) {
826         uint256 result = 0;
827         unchecked {
828             if (value >> 128 > 0) {
829                 value >>= 128;
830                 result += 16;
831             }
832             if (value >> 64 > 0) {
833                 value >>= 64;
834                 result += 8;
835             }
836             if (value >> 32 > 0) {
837                 value >>= 32;
838                 result += 4;
839             }
840             if (value >> 16 > 0) {
841                 value >>= 16;
842                 result += 2;
843             }
844             if (value >> 8 > 0) {
845                 result += 1;
846             }
847         }
848         return result;
849     }
850 
851     /**
852      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
853      * Returns 0 if given 0.
854      */
855     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
856         unchecked {
857             uint256 result = log256(value);
858             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
859         }
860     }
861 }
862 
863 // File: @openzeppelin/contracts/utils/Strings.sol
864 
865 
866 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
867 
868 pragma solidity ^0.8.0;
869 
870 
871 /**
872  * @dev String operations.
873  */
874 library Strings {
875     bytes16 private constant _SYMBOLS = "0123456789abcdef";
876     uint8 private constant _ADDRESS_LENGTH = 20;
877 
878     /**
879      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
880      */
881     function toString(uint256 value) internal pure returns (string memory) {
882         unchecked {
883             uint256 length = Math.log10(value) + 1;
884             string memory buffer = new string(length);
885             uint256 ptr;
886             /// @solidity memory-safe-assembly
887             assembly {
888                 ptr := add(buffer, add(32, length))
889             }
890             while (true) {
891                 ptr--;
892                 /// @solidity memory-safe-assembly
893                 assembly {
894                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
895                 }
896                 value /= 10;
897                 if (value == 0) break;
898             }
899             return buffer;
900         }
901     }
902 
903     /**
904      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
905      */
906     function toHexString(uint256 value) internal pure returns (string memory) {
907         unchecked {
908             return toHexString(value, Math.log256(value) + 1);
909         }
910     }
911 
912     /**
913      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
914      */
915     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
916         bytes memory buffer = new bytes(2 * length + 2);
917         buffer[0] = "0";
918         buffer[1] = "x";
919         for (uint256 i = 2 * length + 1; i > 1; --i) {
920             buffer[i] = _SYMBOLS[value & 0xf];
921             value >>= 4;
922         }
923         require(value == 0, "Strings: hex length insufficient");
924         return string(buffer);
925     }
926 
927     /**
928      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
929      */
930     function toHexString(address addr) internal pure returns (string memory) {
931         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
932     }
933 }
934 
935 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
936 
937 
938 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 /**
943  * @dev Contract module that helps prevent reentrant calls to a function.
944  *
945  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
946  * available, which can be applied to functions to make sure there are no nested
947  * (reentrant) calls to them.
948  *
949  * Note that because there is a single `nonReentrant` guard, functions marked as
950  * `nonReentrant` may not call one another. This can be worked around by making
951  * those functions `private`, and then adding `external` `nonReentrant` entry
952  * points to them.
953  *
954  * TIP: If you would like to learn more about reentrancy and alternative ways
955  * to protect against it, check out our blog post
956  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
957  */
958 abstract contract ReentrancyGuard {
959     // Booleans are more expensive than uint256 or any type that takes up a full
960     // word because each write operation emits an extra SLOAD to first read the
961     // slot's contents, replace the bits taken up by the boolean, and then write
962     // back. This is the compiler's defense against contract upgrades and
963     // pointer aliasing, and it cannot be disabled.
964 
965     // The values being non-zero value makes deployment a bit more expensive,
966     // but in exchange the refund on every call to nonReentrant will be lower in
967     // amount. Since refunds are capped to a percentage of the total
968     // transaction's gas, it is best to keep them low in cases like this one, to
969     // increase the likelihood of the full refund coming into effect.
970     uint256 private constant _NOT_ENTERED = 1;
971     uint256 private constant _ENTERED = 2;
972 
973     uint256 private _status;
974 
975     constructor() {
976         _status = _NOT_ENTERED;
977     }
978 
979     /**
980      * @dev Prevents a contract from calling itself, directly or indirectly.
981      * Calling a `nonReentrant` function from another `nonReentrant`
982      * function is not supported. It is possible to prevent this from happening
983      * by making the `nonReentrant` function external, and making it call a
984      * `private` function that does the actual work.
985      */
986     modifier nonReentrant() {
987         _nonReentrantBefore();
988         _;
989         _nonReentrantAfter();
990     }
991 
992     function _nonReentrantBefore() private {
993         // On the first call to nonReentrant, _status will be _NOT_ENTERED
994         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
995 
996         // Any calls to nonReentrant after this point will fail
997         _status = _ENTERED;
998     }
999 
1000     function _nonReentrantAfter() private {
1001         // By storing the original value once again, a refund is triggered (see
1002         // https://eips.ethereum.org/EIPS/eip-2200)
1003         _status = _NOT_ENTERED;
1004     }
1005 }
1006 
1007 // File: contracts/lib/Constants.sol
1008 
1009 
1010 pragma solidity ^0.8.13;
1011 
1012 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1013 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1014 // File: contracts/IOperatorFilterRegistry.sol
1015 
1016 
1017 pragma solidity ^0.8.13;
1018 
1019 interface IOperatorFilterRegistry {
1020     /**
1021      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1022      *         true if supplied registrant address is not registered.
1023      */
1024     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1025 
1026     /**
1027      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1028      */
1029     function register(address registrant) external;
1030 
1031     /**
1032      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1033      */
1034     function registerAndSubscribe(address registrant, address subscription) external;
1035 
1036     /**
1037      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1038      *         address without subscribing.
1039      */
1040     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1041 
1042     /**
1043      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1044      *         Note that this does not remove any filtered addresses or codeHashes.
1045      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1046      */
1047     function unregister(address addr) external;
1048 
1049     /**
1050      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1051      */
1052     function updateOperator(address registrant, address operator, bool filtered) external;
1053 
1054     /**
1055      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1056      */
1057     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1058 
1059     /**
1060      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1061      */
1062     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1063 
1064     /**
1065      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1066      */
1067     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1068 
1069     /**
1070      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1071      *         subscription if present.
1072      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1073      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1074      *         used.
1075      */
1076     function subscribe(address registrant, address registrantToSubscribe) external;
1077 
1078     /**
1079      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1080      */
1081     function unsubscribe(address registrant, bool copyExistingEntries) external;
1082 
1083     /**
1084      * @notice Get the subscription address of a given registrant, if any.
1085      */
1086     function subscriptionOf(address addr) external returns (address registrant);
1087 
1088     /**
1089      * @notice Get the set of addresses subscribed to a given registrant.
1090      *         Note that order is not guaranteed as updates are made.
1091      */
1092     function subscribers(address registrant) external returns (address[] memory);
1093 
1094     /**
1095      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1096      *         Note that order is not guaranteed as updates are made.
1097      */
1098     function subscriberAt(address registrant, uint256 index) external returns (address);
1099 
1100     /**
1101      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1102      */
1103     function copyEntriesOf(address registrant, address registrantToCopy) external;
1104 
1105     /**
1106      * @notice Returns true if operator is filtered by a given address or its subscription.
1107      */
1108     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1109 
1110     /**
1111      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1112      */
1113     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1114 
1115     /**
1116      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1117      */
1118     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1119 
1120     /**
1121      * @notice Returns a list of filtered operators for a given address or its subscription.
1122      */
1123     function filteredOperators(address addr) external returns (address[] memory);
1124 
1125     /**
1126      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1127      *         Note that order is not guaranteed as updates are made.
1128      */
1129     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1130 
1131     /**
1132      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1133      *         its subscription.
1134      *         Note that order is not guaranteed as updates are made.
1135      */
1136     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1137 
1138     /**
1139      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1140      *         its subscription.
1141      *         Note that order is not guaranteed as updates are made.
1142      */
1143     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1144 
1145     /**
1146      * @notice Returns true if an address has registered
1147      */
1148     function isRegistered(address addr) external returns (bool);
1149 
1150     /**
1151      * @dev Convenience method to compute the code hash of an arbitrary contract
1152      */
1153     function codeHashOf(address addr) external returns (bytes32);
1154 }
1155 // File: contracts/OperatorFilterer.sol
1156 
1157 
1158 pragma solidity ^0.8.13;
1159 
1160 
1161 /**
1162  * @title  OperatorFilterer
1163  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1164  *         registrant's entries in the OperatorFilterRegistry.
1165  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1166  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1167  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1168  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
1169  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1170  *         will be locked to the options set during construction.
1171  */
1172 
1173 abstract contract OperatorFilterer {
1174     /// @dev Emitted when an operator is not allowed.
1175     error OperatorNotAllowed(address operator);
1176 
1177     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1178         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
1179 
1180     /// @dev The constructor that is called when the contract is being deployed.
1181     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1182         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1183         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1184         // order for the modifier to filter addresses.
1185         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1186             if (subscribe) {
1187                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1188             } else {
1189                 if (subscriptionOrRegistrantToCopy != address(0)) {
1190                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1191                 } else {
1192                     OPERATOR_FILTER_REGISTRY.register(address(this));
1193                 }
1194             }
1195         }
1196     }
1197 
1198     /**
1199      * @dev A helper function to check if an operator is allowed.
1200      */
1201     modifier onlyAllowedOperator(address from) virtual {
1202         // Allow spending tokens from addresses with balance
1203         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1204         // from an EOA.
1205         if (from != msg.sender) {
1206             _checkFilterOperator(msg.sender);
1207         }
1208         _;
1209     }
1210 
1211     /**
1212      * @dev A helper function to check if an operator approval is allowed.
1213      */
1214     modifier onlyAllowedOperatorApproval(address operator) virtual {
1215         _checkFilterOperator(operator);
1216         _;
1217     }
1218 
1219     /**
1220      * @dev A helper function to check if an operator is allowed.
1221      */
1222     function _checkFilterOperator(address operator) internal view virtual {
1223         // Check registry code length to facilitate testing in environments without a deployed registry.
1224         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1225             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
1226             // may specify their own OperatorFilterRegistry implementations, which may behave differently
1227             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1228                 revert OperatorNotAllowed(operator);
1229             }
1230         }
1231     }
1232 }
1233 // File: contracts/DefaultOperatorFilterer.sol
1234 
1235 
1236 pragma solidity ^0.8.13;
1237 
1238 
1239 /**
1240  * @title  DefaultOperatorFilterer
1241  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1242  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1243  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1244  *         will be locked to the options set during construction.
1245  */
1246 
1247 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1248     /// @dev The constructor that is called when the contract is being deployed.
1249     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1250 }
1251 // File: @openzeppelin/contracts/utils/Context.sol
1252 
1253 
1254 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 /**
1259  * @dev Provides information about the current execution context, including the
1260  * sender of the transaction and its data. While these are generally available
1261  * via msg.sender and msg.data, they should not be accessed in such a direct
1262  * manner, since when dealing with meta-transactions the account sending and
1263  * paying for execution may not be the actual sender (as far as an application
1264  * is concerned).
1265  *
1266  * This contract is only required for intermediate, library-like contracts.
1267  */
1268 abstract contract Context {
1269     function _msgSender() internal view virtual returns (address) {
1270         return msg.sender;
1271     }
1272 
1273     function _msgData() internal view virtual returns (bytes calldata) {
1274         return msg.data;
1275     }
1276 }
1277 
1278 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1279 
1280 
1281 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
1282 
1283 pragma solidity ^0.8.0;
1284 
1285 
1286 
1287 
1288 /**
1289  * @title PaymentSplitter
1290  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1291  * that the Ether will be split in this way, since it is handled transparently by the contract.
1292  *
1293  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1294  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1295  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
1296  * time of contract deployment and can't be updated thereafter.
1297  *
1298  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1299  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1300  * function.
1301  *
1302  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1303  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1304  * to run tests before sending real value to this contract.
1305  */
1306 contract PaymentSplitter is Context {
1307     event PayeeAdded(address account, uint256 shares);
1308     event PaymentReleased(address to, uint256 amount);
1309     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1310     event PaymentReceived(address from, uint256 amount);
1311 
1312     uint256 private _totalShares;
1313     uint256 private _totalReleased;
1314 
1315     mapping(address => uint256) private _shares;
1316     mapping(address => uint256) private _released;
1317     address[] private _payees;
1318 
1319     mapping(IERC20 => uint256) private _erc20TotalReleased;
1320     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1321 
1322     /**
1323      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1324      * the matching position in the `shares` array.
1325      *
1326      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1327      * duplicates in `payees`.
1328      */
1329     constructor(address[] memory payees, uint256[] memory shares_) payable {
1330         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1331         require(payees.length > 0, "PaymentSplitter: no payees");
1332 
1333         for (uint256 i = 0; i < payees.length; i++) {
1334             _addPayee(payees[i], shares_[i]);
1335         }
1336     }
1337 
1338     /**
1339      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1340      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1341      * reliability of the events, and not the actual splitting of Ether.
1342      *
1343      * To learn more about this see the Solidity documentation for
1344      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1345      * functions].
1346      */
1347     receive() external payable virtual {
1348         emit PaymentReceived(_msgSender(), msg.value);
1349     }
1350 
1351     /**
1352      * @dev Getter for the total shares held by payees.
1353      */
1354     function totalShares() public view returns (uint256) {
1355         return _totalShares;
1356     }
1357 
1358     /**
1359      * @dev Getter for the total amount of Ether already released.
1360      */
1361     function totalReleased() public view returns (uint256) {
1362         return _totalReleased;
1363     }
1364 
1365     /**
1366      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1367      * contract.
1368      */
1369     function totalReleased(IERC20 token) public view returns (uint256) {
1370         return _erc20TotalReleased[token];
1371     }
1372 
1373     /**
1374      * @dev Getter for the amount of shares held by an account.
1375      */
1376     function shares(address account) public view returns (uint256) {
1377         return _shares[account];
1378     }
1379 
1380     /**
1381      * @dev Getter for the amount of Ether already released to a payee.
1382      */
1383     function released(address account) public view returns (uint256) {
1384         return _released[account];
1385     }
1386 
1387     /**
1388      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1389      * IERC20 contract.
1390      */
1391     function released(IERC20 token, address account) public view returns (uint256) {
1392         return _erc20Released[token][account];
1393     }
1394 
1395     /**
1396      * @dev Getter for the address of the payee number `index`.
1397      */
1398     function payee(uint256 index) public view returns (address) {
1399         return _payees[index];
1400     }
1401 
1402     /**
1403      * @dev Getter for the amount of payee's releasable Ether.
1404      */
1405     function releasable(address account) public view returns (uint256) {
1406         uint256 totalReceived = address(this).balance + totalReleased();
1407         return _pendingPayment(account, totalReceived, released(account));
1408     }
1409 
1410     /**
1411      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1412      * IERC20 contract.
1413      */
1414     function releasable(IERC20 token, address account) public view returns (uint256) {
1415         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1416         return _pendingPayment(account, totalReceived, released(token, account));
1417     }
1418 
1419     /**
1420      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1421      * total shares and their previous withdrawals.
1422      */
1423     function release(address payable account) public virtual {
1424         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1425 
1426         uint256 payment = releasable(account);
1427 
1428         require(payment != 0, "PaymentSplitter: account is not due payment");
1429 
1430         // _totalReleased is the sum of all values in _released.
1431         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
1432         _totalReleased += payment;
1433         unchecked {
1434             _released[account] += payment;
1435         }
1436 
1437         Address.sendValue(account, payment);
1438         emit PaymentReleased(account, payment);
1439     }
1440 
1441     /**
1442      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1443      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1444      * contract.
1445      */
1446     function release(IERC20 token, address account) public virtual {
1447         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1448 
1449         uint256 payment = releasable(token, account);
1450 
1451         require(payment != 0, "PaymentSplitter: account is not due payment");
1452 
1453         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
1454         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
1455         // cannot overflow.
1456         _erc20TotalReleased[token] += payment;
1457         unchecked {
1458             _erc20Released[token][account] += payment;
1459         }
1460 
1461         SafeERC20.safeTransfer(token, account, payment);
1462         emit ERC20PaymentReleased(token, account, payment);
1463     }
1464 
1465     /**
1466      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1467      * already released amounts.
1468      */
1469     function _pendingPayment(
1470         address account,
1471         uint256 totalReceived,
1472         uint256 alreadyReleased
1473     ) private view returns (uint256) {
1474         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1475     }
1476 
1477     /**
1478      * @dev Add a new payee to the contract.
1479      * @param account The address of the payee to add.
1480      * @param shares_ The number of shares owned by the payee.
1481      */
1482     function _addPayee(address account, uint256 shares_) private {
1483         require(account != address(0), "PaymentSplitter: account is the zero address");
1484         require(shares_ > 0, "PaymentSplitter: shares are 0");
1485         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1486 
1487         _payees.push(account);
1488         _shares[account] = shares_;
1489         _totalShares = _totalShares + shares_;
1490         emit PayeeAdded(account, shares_);
1491     }
1492 }
1493 
1494 // File: @openzeppelin/contracts/access/Ownable.sol
1495 
1496 
1497 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1498 
1499 pragma solidity ^0.8.0;
1500 
1501 
1502 /**
1503  * @dev Contract module which provides a basic access control mechanism, where
1504  * there is an account (an owner) that can be granted exclusive access to
1505  * specific functions.
1506  *
1507  * By default, the owner account will be the one that deploys the contract. This
1508  * can later be changed with {transferOwnership}.
1509  *
1510  * This module is used through inheritance. It will make available the modifier
1511  * `onlyOwner`, which can be applied to your functions to restrict their use to
1512  * the owner.
1513  */
1514 abstract contract Ownable is Context {
1515     address private _owner;
1516 
1517     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1518 
1519     /**
1520      * @dev Initializes the contract setting the deployer as the initial owner.
1521      */
1522     constructor() {
1523         _transferOwnership(_msgSender());
1524     }
1525 
1526     /**
1527      * @dev Throws if called by any account other than the owner.
1528      */
1529     modifier onlyOwner() {
1530         _checkOwner();
1531         _;
1532     }
1533 
1534     /**
1535      * @dev Returns the address of the current owner.
1536      */
1537     function owner() public view virtual returns (address) {
1538         return _owner;
1539     }
1540 
1541     /**
1542      * @dev Throws if the sender is not the owner.
1543      */
1544     function _checkOwner() internal view virtual {
1545         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1546     }
1547 
1548     /**
1549      * @dev Leaves the contract without owner. It will not be possible to call
1550      * `onlyOwner` functions anymore. Can only be called by the current owner.
1551      *
1552      * NOTE: Renouncing ownership will leave the contract without an owner,
1553      * thereby removing any functionality that is only available to the owner.
1554      */
1555     function renounceOwnership() public virtual onlyOwner {
1556         _transferOwnership(address(0));
1557     }
1558 
1559     /**
1560      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1561      * Can only be called by the current owner.
1562      */
1563     function transferOwnership(address newOwner) public virtual onlyOwner {
1564         require(newOwner != address(0), "Ownable: new owner is the zero address");
1565         _transferOwnership(newOwner);
1566     }
1567 
1568     /**
1569      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1570      * Internal function without access restriction.
1571      */
1572     function _transferOwnership(address newOwner) internal virtual {
1573         address oldOwner = _owner;
1574         _owner = newOwner;
1575         emit OwnershipTransferred(oldOwner, newOwner);
1576     }
1577 }
1578 
1579 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1580 
1581 
1582 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1583 
1584 pragma solidity ^0.8.0;
1585 
1586 /**
1587  * @dev Interface of the ERC165 standard, as defined in the
1588  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1589  *
1590  * Implementers can declare support of contract interfaces, which can then be
1591  * queried by others ({ERC165Checker}).
1592  *
1593  * For an implementation, see {ERC165}.
1594  */
1595 interface IERC165 {
1596     /**
1597      * @dev Returns true if this contract implements the interface defined by
1598      * `interfaceId`. See the corresponding
1599      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1600      * to learn more about how these ids are created.
1601      *
1602      * This function call must use less than 30 000 gas.
1603      */
1604     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1605 }
1606 
1607 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1608 
1609 
1610 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1611 
1612 pragma solidity ^0.8.0;
1613 
1614 
1615 /**
1616  * @dev Implementation of the {IERC165} interface.
1617  *
1618  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1619  * for the additional interface id that will be supported. For example:
1620  *
1621  * ```solidity
1622  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1623  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1624  * }
1625  * ```
1626  *
1627  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1628  */
1629 abstract contract ERC165 is IERC165 {
1630     /**
1631      * @dev See {IERC165-supportsInterface}.
1632      */
1633     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1634         return interfaceId == type(IERC165).interfaceId;
1635     }
1636 }
1637 
1638 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1639 
1640 
1641 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1642 
1643 pragma solidity ^0.8.0;
1644 
1645 
1646 /**
1647  * @dev Interface for the NFT Royalty Standard.
1648  *
1649  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1650  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1651  *
1652  * _Available since v4.5._
1653  */
1654 interface IERC2981 is IERC165 {
1655     /**
1656      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1657      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1658      */
1659     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1660         external
1661         view
1662         returns (address receiver, uint256 royaltyAmount);
1663 }
1664 
1665 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1666 
1667 
1668 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1669 
1670 pragma solidity ^0.8.0;
1671 
1672 
1673 
1674 /**
1675  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1676  *
1677  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1678  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1679  *
1680  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1681  * fee is specified in basis points by default.
1682  *
1683  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1684  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1685  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1686  *
1687  * _Available since v4.5._
1688  */
1689 abstract contract ERC2981 is IERC2981, ERC165 {
1690     struct RoyaltyInfo {
1691         address receiver;
1692         uint96 royaltyFraction;
1693     }
1694 
1695     RoyaltyInfo private _defaultRoyaltyInfo;
1696     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1697 
1698     /**
1699      * @dev See {IERC165-supportsInterface}.
1700      */
1701     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1702         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1703     }
1704 
1705     /**
1706      * @inheritdoc IERC2981
1707      */
1708     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1709         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1710 
1711         if (royalty.receiver == address(0)) {
1712             royalty = _defaultRoyaltyInfo;
1713         }
1714 
1715         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1716 
1717         return (royalty.receiver, royaltyAmount);
1718     }
1719 
1720     /**
1721      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1722      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1723      * override.
1724      */
1725     function _feeDenominator() internal pure virtual returns (uint96) {
1726         return 10000;
1727     }
1728 
1729     /**
1730      * @dev Sets the royalty information that all ids in this contract will default to.
1731      *
1732      * Requirements:
1733      *
1734      * - `receiver` cannot be the zero address.
1735      * - `feeNumerator` cannot be greater than the fee denominator.
1736      */
1737     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1738         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1739         require(receiver != address(0), "ERC2981: invalid receiver");
1740 
1741         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1742     }
1743 
1744     /**
1745      * @dev Removes default royalty information.
1746      */
1747     function _deleteDefaultRoyalty() internal virtual {
1748         delete _defaultRoyaltyInfo;
1749     }
1750 
1751     /**
1752      * @dev Sets the royalty information for a specific token id, overriding the global default.
1753      *
1754      * Requirements:
1755      *
1756      * - `receiver` cannot be the zero address.
1757      * - `feeNumerator` cannot be greater than the fee denominator.
1758      */
1759     function _setTokenRoyalty(
1760         uint256 tokenId,
1761         address receiver,
1762         uint96 feeNumerator
1763     ) internal virtual {
1764         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1765         require(receiver != address(0), "ERC2981: Invalid parameters");
1766 
1767         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1768     }
1769 
1770     /**
1771      * @dev Resets royalty information for the token id back to the global default.
1772      */
1773     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1774         delete _tokenRoyaltyInfo[tokenId];
1775     }
1776 }
1777 
1778 // File: contracts/IERC721A.sol
1779 
1780 
1781 // ERC721A Contracts v4.2.3
1782 // Creator: Chiru Labs
1783 
1784 pragma solidity ^0.8.4;
1785 
1786 /**
1787  * @dev Interface of ERC721A.
1788  */
1789 interface IERC721A {
1790     /**
1791      * The caller must own the token or be an approved operator.
1792      */
1793     error ApprovalCallerNotOwnerNorApproved();
1794 
1795     /**
1796      * The token does not exist.
1797      */
1798     error ApprovalQueryForNonexistentToken();
1799 
1800     /**
1801      * Cannot query the balance for the zero address.
1802      */
1803     error BalanceQueryForZeroAddress();
1804 
1805     /**
1806      * Cannot mint to the zero address.
1807      */
1808     error MintToZeroAddress();
1809 
1810     /**
1811      * The quantity of tokens minted must be more than zero.
1812      */
1813     error MintZeroQuantity();
1814 
1815     /**
1816      * The token does not exist.
1817      */
1818     error OwnerQueryForNonexistentToken();
1819 
1820     /**
1821      * The caller must own the token or be an approved operator.
1822      */
1823     error TransferCallerNotOwnerNorApproved();
1824 
1825     /**
1826      * The token must be owned by `from`.
1827      */
1828     error TransferFromIncorrectOwner();
1829 
1830     /**
1831      * Cannot safely transfer to a contract that does not implement the
1832      * ERC721Receiver interface.
1833      */
1834     error TransferToNonERC721ReceiverImplementer();
1835 
1836     /**
1837      * Cannot transfer to the zero address.
1838      */
1839     error TransferToZeroAddress();
1840 
1841     /**
1842      * The token does not exist.
1843      */
1844     error URIQueryForNonexistentToken();
1845 
1846     /**
1847      * The `quantity` minted with ERC2309 exceeds the safety limit.
1848      */
1849     error MintERC2309QuantityExceedsLimit();
1850 
1851     /**
1852      * The `extraData` cannot be set on an unintialized ownership slot.
1853      */
1854     error OwnershipNotInitializedForExtraData();
1855 
1856     // =============================================================
1857     //                            STRUCTS
1858     // =============================================================
1859 
1860     struct TokenOwnership {
1861         // The address of the owner.
1862         address addr;
1863         // Stores the start time of ownership with minimal overhead for tokenomics.
1864         uint64 startTimestamp;
1865         // Whether the token has been burned.
1866         bool burned;
1867         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1868         uint24 extraData;
1869     }
1870 
1871     // =============================================================
1872     //                         TOKEN COUNTERS
1873     // =============================================================
1874 
1875     /**
1876      * @dev Returns the total number of tokens in existence.
1877      * Burned tokens will reduce the count.
1878      * To get the total number of tokens minted, please see {_totalMinted}.
1879      */
1880     function totalSupply() external view returns (uint256);
1881 
1882     // =============================================================
1883     //                            IERC165
1884     // =============================================================
1885 
1886     /**
1887      * @dev Returns true if this contract implements the interface defined by
1888      * `interfaceId`. See the corresponding
1889      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1890      * to learn more about how these ids are created.
1891      *
1892      * This function call must use less than 30000 gas.
1893      */
1894     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1895 
1896     // =============================================================
1897     //                            IERC721
1898     // =============================================================
1899 
1900     /**
1901      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1902      */
1903     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1904 
1905     /**
1906      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1907      */
1908     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1909 
1910     /**
1911      * @dev Emitted when `owner` enables or disables
1912      * (`approved`) `operator` to manage all of its assets.
1913      */
1914     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1915 
1916     /**
1917      * @dev Returns the number of tokens in `owner`'s account.
1918      */
1919     function balanceOf(address owner) external view returns (uint256 balance);
1920 
1921     /**
1922      * @dev Returns the owner of the `tokenId` token.
1923      *
1924      * Requirements:
1925      *
1926      * - `tokenId` must exist.
1927      */
1928     function ownerOf(uint256 tokenId) external view returns (address owner);
1929 
1930     /**
1931      * @dev Safely transfers `tokenId` token from `from` to `to`,
1932      * checking first that contract recipients are aware of the ERC721 protocol
1933      * to prevent tokens from being forever locked.
1934      *
1935      * Requirements:
1936      *
1937      * - `from` cannot be the zero address.
1938      * - `to` cannot be the zero address.
1939      * - `tokenId` token must exist and be owned by `from`.
1940      * - If the caller is not `from`, it must be have been allowed to move
1941      * this token by either {approve} or {setApprovalForAll}.
1942      * - If `to` refers to a smart contract, it must implement
1943      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1944      *
1945      * Emits a {Transfer} event.
1946      */
1947     function safeTransferFrom(
1948         address from,
1949         address to,
1950         uint256 tokenId,
1951         bytes calldata data
1952     ) external payable;
1953 
1954     /**
1955      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1956      */
1957     function safeTransferFrom(
1958         address from,
1959         address to,
1960         uint256 tokenId
1961     ) external payable;
1962 
1963     /**
1964      * @dev Transfers `tokenId` from `from` to `to`.
1965      *
1966      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1967      * whenever possible.
1968      *
1969      * Requirements:
1970      *
1971      * - `from` cannot be the zero address.
1972      * - `to` cannot be the zero address.
1973      * - `tokenId` token must be owned by `from`.
1974      * - If the caller is not `from`, it must be approved to move this token
1975      * by either {approve} or {setApprovalForAll}.
1976      *
1977      * Emits a {Transfer} event.
1978      */
1979     function transferFrom(
1980         address from,
1981         address to,
1982         uint256 tokenId
1983     ) external payable;
1984 
1985     /**
1986      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1987      * The approval is cleared when the token is transferred.
1988      *
1989      * Only a single account can be approved at a time, so approving the
1990      * zero address clears previous approvals.
1991      *
1992      * Requirements:
1993      *
1994      * - The caller must own the token or be an approved operator.
1995      * - `tokenId` must exist.
1996      *
1997      * Emits an {Approval} event.
1998      */
1999     function approve(address to, uint256 tokenId) external payable;
2000 
2001     /**
2002      * @dev Approve or remove `operator` as an operator for the caller.
2003      * Operators can call {transferFrom} or {safeTransferFrom}
2004      * for any token owned by the caller.
2005      *
2006      * Requirements:
2007      *
2008      * - The `operator` cannot be the caller.
2009      *
2010      * Emits an {ApprovalForAll} event.
2011      */
2012     function setApprovalForAll(address operator, bool _approved) external;
2013 
2014     /**
2015      * @dev Returns the account approved for `tokenId` token.
2016      *
2017      * Requirements:
2018      *
2019      * - `tokenId` must exist.
2020      */
2021     function getApproved(uint256 tokenId) external view returns (address operator);
2022 
2023     /**
2024      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2025      *
2026      * See {setApprovalForAll}.
2027      */
2028     function isApprovedForAll(address owner, address operator) external view returns (bool);
2029 
2030     // =============================================================
2031     //                        IERC721Metadata
2032     // =============================================================
2033 
2034     /**
2035      * @dev Returns the token collection name.
2036      */
2037     function name() external view returns (string memory);
2038 
2039     /**
2040      * @dev Returns the token collection symbol.
2041      */
2042     function symbol() external view returns (string memory);
2043 
2044     /**
2045      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2046      */
2047     function tokenURI(uint256 tokenId) external view returns (string memory);
2048 
2049     // =============================================================
2050     //                           IERC2309
2051     // =============================================================
2052 
2053     /**
2054      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
2055      * (inclusive) is transferred from `from` to `to`, as defined in the
2056      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
2057      *
2058      * See {_mintERC2309} for more details.
2059      */
2060     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
2061 }
2062 // File: contracts/ERC721A.sol
2063 
2064 
2065 // ERC721A Contracts v4.2.3
2066 // Creator: Chiru Labs
2067 
2068 pragma solidity ^0.8.4;
2069 
2070 
2071 /**
2072  * @dev Interface of ERC721 token receiver.
2073  */
2074 interface ERC721A__IERC721Receiver {
2075     function onERC721Received(
2076         address operator,
2077         address from,
2078         uint256 tokenId,
2079         bytes calldata data
2080     ) external returns (bytes4);
2081 }
2082 
2083 /**
2084  * @title ERC721A
2085  *
2086  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
2087  * Non-Fungible Token Standard, including the Metadata extension.
2088  * Optimized for lower gas during batch mints.
2089  *
2090  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
2091  * starting from `_startTokenId()`.
2092  *
2093  * Assumptions:
2094  *
2095  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2096  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
2097  */
2098 contract ERC721A is IERC721A {
2099     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
2100     struct TokenApprovalRef {
2101         address value;
2102     }
2103 
2104     // =============================================================
2105     //                           CONSTANTS
2106     // =============================================================
2107 
2108     // Mask of an entry in packed address data.
2109     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2110 
2111     // The bit position of `numberMinted` in packed address data.
2112     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
2113 
2114     // The bit position of `numberBurned` in packed address data.
2115     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
2116 
2117     // The bit position of `aux` in packed address data.
2118     uint256 private constant _BITPOS_AUX = 192;
2119 
2120     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2121     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2122 
2123     // The bit position of `startTimestamp` in packed ownership.
2124     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2125 
2126     // The bit mask of the `burned` bit in packed ownership.
2127     uint256 private constant _BITMASK_BURNED = 1 << 224;
2128 
2129     // The bit position of the `nextInitialized` bit in packed ownership.
2130     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2131 
2132     // The bit mask of the `nextInitialized` bit in packed ownership.
2133     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2134 
2135     // The bit position of `extraData` in packed ownership.
2136     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2137 
2138     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2139     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2140 
2141     // The mask of the lower 160 bits for addresses.
2142     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2143 
2144     // The maximum `quantity` that can be minted with {_mintERC2309}.
2145     // This limit is to prevent overflows on the address data entries.
2146     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2147     // is required to cause an overflow, which is unrealistic.
2148     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2149 
2150     // The `Transfer` event signature is given by:
2151     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2152     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2153         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2154 
2155     // =============================================================
2156     //                            STORAGE
2157     // =============================================================
2158 
2159     // The next token ID to be minted.
2160     uint256 private _currentIndex;
2161 
2162     // The number of tokens burned.
2163     uint256 private _burnCounter;
2164 
2165     // Token name
2166     string private _name;
2167 
2168     // Token symbol
2169     string private _symbol;
2170 
2171     // Mapping from token ID to ownership details
2172     // An empty struct value does not necessarily mean the token is unowned.
2173     // See {_packedOwnershipOf} implementation for details.
2174     //
2175     // Bits Layout:
2176     // - [0..159]   `addr`
2177     // - [160..223] `startTimestamp`
2178     // - [224]      `burned`
2179     // - [225]      `nextInitialized`
2180     // - [232..255] `extraData`
2181     mapping(uint256 => uint256) private _packedOwnerships;
2182 
2183     // Mapping owner address to address data.
2184     //
2185     // Bits Layout:
2186     // - [0..63]    `balance`
2187     // - [64..127]  `numberMinted`
2188     // - [128..191] `numberBurned`
2189     // - [192..255] `aux`
2190     mapping(address => uint256) private _packedAddressData;
2191 
2192     // Mapping from token ID to approved address.
2193     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2194 
2195     // Mapping from owner to operator approvals
2196     mapping(address => mapping(address => bool)) private _operatorApprovals;
2197 
2198     // =============================================================
2199     //                          CONSTRUCTOR
2200     // =============================================================
2201 
2202     constructor(string memory name_, string memory symbol_) {
2203         _name = name_;
2204         _symbol = symbol_;
2205         _currentIndex = _startTokenId();
2206     }
2207 
2208     // =============================================================
2209     //                   TOKEN COUNTING OPERATIONS
2210     // =============================================================
2211 
2212     /**
2213      * @dev Returns the starting token ID.
2214      * To change the starting token ID, please override this function.
2215      */
2216     function _startTokenId() internal view virtual returns (uint256) {
2217         return 0;
2218     }
2219 
2220     /**
2221      * @dev Returns the next token ID to be minted.
2222      */
2223     function _nextTokenId() internal view virtual returns (uint256) {
2224         return _currentIndex;
2225     }
2226 
2227     /**
2228      * @dev Returns the total number of tokens in existence.
2229      * Burned tokens will reduce the count.
2230      * To get the total number of tokens minted, please see {_totalMinted}.
2231      */
2232     function totalSupply() public view virtual override returns (uint256) {
2233         // Counter underflow is impossible as _burnCounter cannot be incremented
2234         // more than `_currentIndex - _startTokenId()` times.
2235         unchecked {
2236             return _currentIndex - _burnCounter - _startTokenId();
2237         }
2238     }
2239 
2240     /**
2241      * @dev Returns the total amount of tokens minted in the contract.
2242      */
2243     function _totalMinted() internal view virtual returns (uint256) {
2244         // Counter underflow is impossible as `_currentIndex` does not decrement,
2245         // and it is initialized to `_startTokenId()`.
2246         unchecked {
2247             return _currentIndex - _startTokenId();
2248         }
2249     }
2250 
2251     /**
2252      * @dev Returns the total number of tokens burned.
2253      */
2254     function _totalBurned() internal view virtual returns (uint256) {
2255         return _burnCounter;
2256     }
2257 
2258     // =============================================================
2259     //                    ADDRESS DATA OPERATIONS
2260     // =============================================================
2261 
2262     /**
2263      * @dev Returns the number of tokens in `owner`'s account.
2264      */
2265     function balanceOf(address owner) public view virtual override returns (uint256) {
2266         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
2267         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2268     }
2269 
2270     /**
2271      * Returns the number of tokens minted by `owner`.
2272      */
2273     function _numberMinted(address owner) internal view returns (uint256) {
2274         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2275     }
2276 
2277     /**
2278      * Returns the number of tokens burned by or on behalf of `owner`.
2279      */
2280     function _numberBurned(address owner) internal view returns (uint256) {
2281         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2282     }
2283 
2284     /**
2285      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2286      */
2287     function _getAux(address owner) internal view returns (uint64) {
2288         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2289     }
2290 
2291     /**
2292      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2293      * If there are multiple variables, please pack them into a uint64.
2294      */
2295     function _setAux(address owner, uint64 aux) internal virtual {
2296         uint256 packed = _packedAddressData[owner];
2297         uint256 auxCasted;
2298         // Cast `aux` with assembly to avoid redundant masking.
2299         assembly {
2300             auxCasted := aux
2301         }
2302         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2303         _packedAddressData[owner] = packed;
2304     }
2305 
2306     // =============================================================
2307     //                            IERC165
2308     // =============================================================
2309 
2310     /**
2311      * @dev Returns true if this contract implements the interface defined by
2312      * `interfaceId`. See the corresponding
2313      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2314      * to learn more about how these ids are created.
2315      *
2316      * This function call must use less than 30000 gas.
2317      */
2318     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2319         // The interface IDs are constants representing the first 4 bytes
2320         // of the XOR of all function selectors in the interface.
2321         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2322         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2323         return
2324             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2325             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2326             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2327     }
2328 
2329     // =============================================================
2330     //                        IERC721Metadata
2331     // =============================================================
2332 
2333     /**
2334      * @dev Returns the token collection name.
2335      */
2336     function name() public view virtual override returns (string memory) {
2337         return _name;
2338     }
2339 
2340     /**
2341      * @dev Returns the token collection symbol.
2342      */
2343     function symbol() public view virtual override returns (string memory) {
2344         return _symbol;
2345     }
2346 
2347     /**
2348      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2349      */
2350     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2351         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
2352 
2353         string memory baseURI = _baseURI();
2354         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2355     }
2356 
2357     /**
2358      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2359      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2360      * by default, it can be overridden in child contracts.
2361      */
2362     function _baseURI() internal view virtual returns (string memory) {
2363         return '';
2364     }
2365 
2366     // =============================================================
2367     //                     OWNERSHIPS OPERATIONS
2368     // =============================================================
2369 
2370     /**
2371      * @dev Returns the owner of the `tokenId` token.
2372      *
2373      * Requirements:
2374      *
2375      * - `tokenId` must exist.
2376      */
2377     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2378         return address(uint160(_packedOwnershipOf(tokenId)));
2379     }
2380 
2381     /**
2382      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2383      * It gradually moves to O(1) as tokens get transferred around over time.
2384      */
2385     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2386         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2387     }
2388 
2389     /**
2390      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2391      */
2392     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2393         return _unpackedOwnership(_packedOwnerships[index]);
2394     }
2395 
2396     /**
2397      * @dev Returns whether the ownership slot at `index` is initialized.
2398      * An uninitialized slot does not necessarily mean that the slot has no owner.
2399      */
2400     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
2401         return _packedOwnerships[index] != 0;
2402     }
2403 
2404     /**
2405      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2406      */
2407     function _initializeOwnershipAt(uint256 index) internal virtual {
2408         if (_packedOwnerships[index] == 0) {
2409             _packedOwnerships[index] = _packedOwnershipOf(index);
2410         }
2411     }
2412 
2413     /**
2414      * Returns the packed ownership data of `tokenId`.
2415      */
2416     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
2417         if (_startTokenId() <= tokenId) {
2418             packed = _packedOwnerships[tokenId];
2419             // If the data at the starting slot does not exist, start the scan.
2420             if (packed == 0) {
2421                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
2422                 // Invariant:
2423                 // There will always be an initialized ownership slot
2424                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2425                 // before an unintialized ownership slot
2426                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2427                 // Hence, `tokenId` will not underflow.
2428                 //
2429                 // We can directly compare the packed value.
2430                 // If the address is zero, packed will be zero.
2431                 for (;;) {
2432                     unchecked {
2433                         packed = _packedOwnerships[--tokenId];
2434                     }
2435                     if (packed == 0) continue;
2436                     if (packed & _BITMASK_BURNED == 0) return packed;
2437                     // Otherwise, the token is burned, and we must revert.
2438                     // This handles the case of batch burned tokens, where only the burned bit
2439                     // of the starting slot is set, and remaining slots are left uninitialized.
2440                     _revert(OwnerQueryForNonexistentToken.selector);
2441                 }
2442             }
2443             // Otherwise, the data exists and we can skip the scan.
2444             // This is possible because we have already achieved the target condition.
2445             // This saves 2143 gas on transfers of initialized tokens.
2446             // If the token is not burned, return `packed`. Otherwise, revert.
2447             if (packed & _BITMASK_BURNED == 0) return packed;
2448         }
2449         _revert(OwnerQueryForNonexistentToken.selector);
2450     }
2451 
2452     /**
2453      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2454      */
2455     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2456         ownership.addr = address(uint160(packed));
2457         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2458         ownership.burned = packed & _BITMASK_BURNED != 0;
2459         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2460     }
2461 
2462     /**
2463      * @dev Packs ownership data into a single uint256.
2464      */
2465     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2466         assembly {
2467             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2468             owner := and(owner, _BITMASK_ADDRESS)
2469             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2470             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2471         }
2472     }
2473 
2474     /**
2475      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2476      */
2477     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2478         // For branchless setting of the `nextInitialized` flag.
2479         assembly {
2480             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2481             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2482         }
2483     }
2484 
2485     // =============================================================
2486     //                      APPROVAL OPERATIONS
2487     // =============================================================
2488 
2489     /**
2490      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
2491      *
2492      * Requirements:
2493      *
2494      * - The caller must own the token or be an approved operator.
2495      */
2496     function approve(address to, uint256 tokenId) public payable virtual override {
2497         _approve(to, tokenId, true);
2498     }
2499 
2500     /**
2501      * @dev Returns the account approved for `tokenId` token.
2502      *
2503      * Requirements:
2504      *
2505      * - `tokenId` must exist.
2506      */
2507     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2508         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
2509 
2510         return _tokenApprovals[tokenId].value;
2511     }
2512 
2513     /**
2514      * @dev Approve or remove `operator` as an operator for the caller.
2515      * Operators can call {transferFrom} or {safeTransferFrom}
2516      * for any token owned by the caller.
2517      *
2518      * Requirements:
2519      *
2520      * - The `operator` cannot be the caller.
2521      *
2522      * Emits an {ApprovalForAll} event.
2523      */
2524     function setApprovalForAll(address operator, bool approved) public virtual override {
2525         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2526         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2527     }
2528 
2529     /**
2530      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2531      *
2532      * See {setApprovalForAll}.
2533      */
2534     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2535         return _operatorApprovals[owner][operator];
2536     }
2537 
2538     /**
2539      * @dev Returns whether `tokenId` exists.
2540      *
2541      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2542      *
2543      * Tokens start existing when they are minted. See {_mint}.
2544      */
2545     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
2546         if (_startTokenId() <= tokenId) {
2547             if (tokenId < _currentIndex) {
2548                 uint256 packed;
2549                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
2550                 result = packed & _BITMASK_BURNED == 0;
2551             }
2552         }
2553     }
2554 
2555     /**
2556      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2557      */
2558     function _isSenderApprovedOrOwner(
2559         address approvedAddress,
2560         address owner,
2561         address msgSender
2562     ) private pure returns (bool result) {
2563         assembly {
2564             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2565             owner := and(owner, _BITMASK_ADDRESS)
2566             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2567             msgSender := and(msgSender, _BITMASK_ADDRESS)
2568             // `msgSender == owner || msgSender == approvedAddress`.
2569             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2570         }
2571     }
2572 
2573     /**
2574      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2575      */
2576     function _getApprovedSlotAndAddress(uint256 tokenId)
2577         private
2578         view
2579         returns (uint256 approvedAddressSlot, address approvedAddress)
2580     {
2581         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2582         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2583         assembly {
2584             approvedAddressSlot := tokenApproval.slot
2585             approvedAddress := sload(approvedAddressSlot)
2586         }
2587     }
2588 
2589     // =============================================================
2590     //                      TRANSFER OPERATIONS
2591     // =============================================================
2592 
2593     /**
2594      * @dev Transfers `tokenId` from `from` to `to`.
2595      *
2596      * Requirements:
2597      *
2598      * - `from` cannot be the zero address.
2599      * - `to` cannot be the zero address.
2600      * - `tokenId` token must be owned by `from`.
2601      * - If the caller is not `from`, it must be approved to move this token
2602      * by either {approve} or {setApprovalForAll}.
2603      *
2604      * Emits a {Transfer} event.
2605      */
2606     function transferFrom(
2607         address from,
2608         address to,
2609         uint256 tokenId
2610     ) public payable virtual override {
2611         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2612 
2613         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
2614         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
2615 
2616         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
2617 
2618         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2619 
2620         // The nested ifs save around 20+ gas over a compound boolean condition.
2621         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2622             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2623 
2624         _beforeTokenTransfers(from, to, tokenId, 1);
2625 
2626         // Clear approvals from the previous owner.
2627         assembly {
2628             if approvedAddress {
2629                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2630                 sstore(approvedAddressSlot, 0)
2631             }
2632         }
2633 
2634         // Underflow of the sender's balance is impossible because we check for
2635         // ownership above and the recipient's balance can't realistically overflow.
2636         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2637         unchecked {
2638             // We can directly increment and decrement the balances.
2639             --_packedAddressData[from]; // Updates: `balance -= 1`.
2640             ++_packedAddressData[to]; // Updates: `balance += 1`.
2641 
2642             // Updates:
2643             // - `address` to the next owner.
2644             // - `startTimestamp` to the timestamp of transfering.
2645             // - `burned` to `false`.
2646             // - `nextInitialized` to `true`.
2647             _packedOwnerships[tokenId] = _packOwnershipData(
2648                 to,
2649                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2650             );
2651 
2652             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2653             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2654                 uint256 nextTokenId = tokenId + 1;
2655                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2656                 if (_packedOwnerships[nextTokenId] == 0) {
2657                     // If the next slot is within bounds.
2658                     if (nextTokenId != _currentIndex) {
2659                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2660                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2661                     }
2662                 }
2663             }
2664         }
2665 
2666         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2667         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2668         assembly {
2669             // Emit the `Transfer` event.
2670             log4(
2671                 0, // Start of data (0, since no data).
2672                 0, // End of data (0, since no data).
2673                 _TRANSFER_EVENT_SIGNATURE, // Signature.
2674                 from, // `from`.
2675                 toMasked, // `to`.
2676                 tokenId // `tokenId`.
2677             )
2678         }
2679         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
2680 
2681         _afterTokenTransfers(from, to, tokenId, 1);
2682     }
2683 
2684     /**
2685      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2686      */
2687     function safeTransferFrom(
2688         address from,
2689         address to,
2690         uint256 tokenId
2691     ) public payable virtual override {
2692         safeTransferFrom(from, to, tokenId, '');
2693     }
2694 
2695     /**
2696      * @dev Safely transfers `tokenId` token from `from` to `to`.
2697      *
2698      * Requirements:
2699      *
2700      * - `from` cannot be the zero address.
2701      * - `to` cannot be the zero address.
2702      * - `tokenId` token must exist and be owned by `from`.
2703      * - If the caller is not `from`, it must be approved to move this token
2704      * by either {approve} or {setApprovalForAll}.
2705      * - If `to` refers to a smart contract, it must implement
2706      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2707      *
2708      * Emits a {Transfer} event.
2709      */
2710     function safeTransferFrom(
2711         address from,
2712         address to,
2713         uint256 tokenId,
2714         bytes memory _data
2715     ) public payable virtual override {
2716         transferFrom(from, to, tokenId);
2717         if (to.code.length != 0)
2718             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2719                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2720             }
2721     }
2722 
2723     /**
2724      * @dev Hook that is called before a set of serially-ordered token IDs
2725      * are about to be transferred. This includes minting.
2726      * And also called before burning one token.
2727      *
2728      * `startTokenId` - the first token ID to be transferred.
2729      * `quantity` - the amount to be transferred.
2730      *
2731      * Calling conditions:
2732      *
2733      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2734      * transferred to `to`.
2735      * - When `from` is zero, `tokenId` will be minted for `to`.
2736      * - When `to` is zero, `tokenId` will be burned by `from`.
2737      * - `from` and `to` are never both zero.
2738      */
2739     function _beforeTokenTransfers(
2740         address from,
2741         address to,
2742         uint256 startTokenId,
2743         uint256 quantity
2744     ) internal virtual {}
2745 
2746     /**
2747      * @dev Hook that is called after a set of serially-ordered token IDs
2748      * have been transferred. This includes minting.
2749      * And also called after one token has been burned.
2750      *
2751      * `startTokenId` - the first token ID to be transferred.
2752      * `quantity` - the amount to be transferred.
2753      *
2754      * Calling conditions:
2755      *
2756      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2757      * transferred to `to`.
2758      * - When `from` is zero, `tokenId` has been minted for `to`.
2759      * - When `to` is zero, `tokenId` has been burned by `from`.
2760      * - `from` and `to` are never both zero.
2761      */
2762     function _afterTokenTransfers(
2763         address from,
2764         address to,
2765         uint256 startTokenId,
2766         uint256 quantity
2767     ) internal virtual {}
2768 
2769     /**
2770      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2771      *
2772      * `from` - Previous owner of the given token ID.
2773      * `to` - Target address that will receive the token.
2774      * `tokenId` - Token ID to be transferred.
2775      * `_data` - Optional data to send along with the call.
2776      *
2777      * Returns whether the call correctly returned the expected magic value.
2778      */
2779     function _checkContractOnERC721Received(
2780         address from,
2781         address to,
2782         uint256 tokenId,
2783         bytes memory _data
2784     ) private returns (bool) {
2785         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2786             bytes4 retval
2787         ) {
2788             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2789         } catch (bytes memory reason) {
2790             if (reason.length == 0) {
2791                 _revert(TransferToNonERC721ReceiverImplementer.selector);
2792             }
2793             assembly {
2794                 revert(add(32, reason), mload(reason))
2795             }
2796         }
2797     }
2798 
2799     // =============================================================
2800     //                        MINT OPERATIONS
2801     // =============================================================
2802 
2803     /**
2804      * @dev Mints `quantity` tokens and transfers them to `to`.
2805      *
2806      * Requirements:
2807      *
2808      * - `to` cannot be the zero address.
2809      * - `quantity` must be greater than 0.
2810      *
2811      * Emits a {Transfer} event for each mint.
2812      */
2813     function _mint(address to, uint256 quantity) internal virtual {
2814         uint256 startTokenId = _currentIndex;
2815         if (quantity == 0) _revert(MintZeroQuantity.selector);
2816 
2817         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2818 
2819         // Overflows are incredibly unrealistic.
2820         // `balance` and `numberMinted` have a maximum limit of 2**64.
2821         // `tokenId` has a maximum limit of 2**256.
2822         unchecked {
2823             // Updates:
2824             // - `address` to the owner.
2825             // - `startTimestamp` to the timestamp of minting.
2826             // - `burned` to `false`.
2827             // - `nextInitialized` to `quantity == 1`.
2828             _packedOwnerships[startTokenId] = _packOwnershipData(
2829                 to,
2830                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2831             );
2832 
2833             // Updates:
2834             // - `balance += quantity`.
2835             // - `numberMinted += quantity`.
2836             //
2837             // We can directly add to the `balance` and `numberMinted`.
2838             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2839 
2840             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2841             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
2842 
2843             if (toMasked == 0) _revert(MintToZeroAddress.selector);
2844 
2845             uint256 end = startTokenId + quantity;
2846             uint256 tokenId = startTokenId;
2847 
2848             do {
2849                 assembly {
2850                     // Emit the `Transfer` event.
2851                     log4(
2852                         0, // Start of data (0, since no data).
2853                         0, // End of data (0, since no data).
2854                         _TRANSFER_EVENT_SIGNATURE, // Signature.
2855                         0, // `address(0)`.
2856                         toMasked, // `to`.
2857                         tokenId // `tokenId`.
2858                     )
2859                 }
2860                 // The `!=` check ensures that large values of `quantity`
2861                 // that overflows uint256 will make the loop run out of gas.
2862             } while (++tokenId != end);
2863 
2864             _currentIndex = end;
2865         }
2866         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2867     }
2868 
2869     /**
2870      * @dev Mints `quantity` tokens and transfers them to `to`.
2871      *
2872      * This function is intended for efficient minting only during contract creation.
2873      *
2874      * It emits only one {ConsecutiveTransfer} as defined in
2875      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2876      * instead of a sequence of {Transfer} event(s).
2877      *
2878      * Calling this function outside of contract creation WILL make your contract
2879      * non-compliant with the ERC721 standard.
2880      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2881      * {ConsecutiveTransfer} event is only permissible during contract creation.
2882      *
2883      * Requirements:
2884      *
2885      * - `to` cannot be the zero address.
2886      * - `quantity` must be greater than 0.
2887      *
2888      * Emits a {ConsecutiveTransfer} event.
2889      */
2890     function _mintERC2309(address to, uint256 quantity) internal virtual {
2891         uint256 startTokenId = _currentIndex;
2892         if (to == address(0)) _revert(MintToZeroAddress.selector);
2893         if (quantity == 0) _revert(MintZeroQuantity.selector);
2894         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
2895 
2896         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2897 
2898         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2899         unchecked {
2900             // Updates:
2901             // - `balance += quantity`.
2902             // - `numberMinted += quantity`.
2903             //
2904             // We can directly add to the `balance` and `numberMinted`.
2905             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2906 
2907             // Updates:
2908             // - `address` to the owner.
2909             // - `startTimestamp` to the timestamp of minting.
2910             // - `burned` to `false`.
2911             // - `nextInitialized` to `quantity == 1`.
2912             _packedOwnerships[startTokenId] = _packOwnershipData(
2913                 to,
2914                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2915             );
2916 
2917             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2918 
2919             _currentIndex = startTokenId + quantity;
2920         }
2921         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2922     }
2923 
2924     /**
2925      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2926      *
2927      * Requirements:
2928      *
2929      * - If `to` refers to a smart contract, it must implement
2930      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2931      * - `quantity` must be greater than 0.
2932      *
2933      * See {_mint}.
2934      *
2935      * Emits a {Transfer} event for each mint.
2936      */
2937     function _safeMint(
2938         address to,
2939         uint256 quantity,
2940         bytes memory _data
2941     ) internal virtual {
2942         _mint(to, quantity);
2943 
2944         unchecked {
2945             if (to.code.length != 0) {
2946                 uint256 end = _currentIndex;
2947                 uint256 index = end - quantity;
2948                 do {
2949                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2950                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2951                     }
2952                 } while (index < end);
2953                 // Reentrancy protection.
2954                 if (_currentIndex != end) _revert(bytes4(0));
2955             }
2956         }
2957     }
2958 
2959     /**
2960      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2961      */
2962     function _safeMint(address to, uint256 quantity) internal virtual {
2963         _safeMint(to, quantity, '');
2964     }
2965 
2966     // =============================================================
2967     //                       APPROVAL OPERATIONS
2968     // =============================================================
2969 
2970     /**
2971      * @dev Equivalent to `_approve(to, tokenId, false)`.
2972      */
2973     function _approve(address to, uint256 tokenId) internal virtual {
2974         _approve(to, tokenId, false);
2975     }
2976 
2977     /**
2978      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2979      * The approval is cleared when the token is transferred.
2980      *
2981      * Only a single account can be approved at a time, so approving the
2982      * zero address clears previous approvals.
2983      *
2984      * Requirements:
2985      *
2986      * - `tokenId` must exist.
2987      *
2988      * Emits an {Approval} event.
2989      */
2990     function _approve(
2991         address to,
2992         uint256 tokenId,
2993         bool approvalCheck
2994     ) internal virtual {
2995         address owner = ownerOf(tokenId);
2996 
2997         if (approvalCheck && _msgSenderERC721A() != owner)
2998             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2999                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
3000             }
3001 
3002         _tokenApprovals[tokenId].value = to;
3003         emit Approval(owner, to, tokenId);
3004     }
3005 
3006     // =============================================================
3007     //                        BURN OPERATIONS
3008     // =============================================================
3009 
3010     /**
3011      * @dev Equivalent to `_burn(tokenId, false)`.
3012      */
3013     function _burn(uint256 tokenId) internal virtual {
3014         _burn(tokenId, false);
3015     }
3016 
3017     /**
3018      * @dev Destroys `tokenId`.
3019      * The approval is cleared when the token is burned.
3020      *
3021      * Requirements:
3022      *
3023      * - `tokenId` must exist.
3024      *
3025      * Emits a {Transfer} event.
3026      */
3027     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
3028         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
3029 
3030         address from = address(uint160(prevOwnershipPacked));
3031 
3032         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
3033 
3034         if (approvalCheck) {
3035             // The nested ifs save around 20+ gas over a compound boolean condition.
3036             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
3037                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
3038         }
3039 
3040         _beforeTokenTransfers(from, address(0), tokenId, 1);
3041 
3042         // Clear approvals from the previous owner.
3043         assembly {
3044             if approvedAddress {
3045                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
3046                 sstore(approvedAddressSlot, 0)
3047             }
3048         }
3049 
3050         // Underflow of the sender's balance is impossible because we check for
3051         // ownership above and the recipient's balance can't realistically overflow.
3052         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
3053         unchecked {
3054             // Updates:
3055             // - `balance -= 1`.
3056             // - `numberBurned += 1`.
3057             //
3058             // We can directly decrement the balance, and increment the number burned.
3059             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
3060             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
3061 
3062             // Updates:
3063             // - `address` to the last owner.
3064             // - `startTimestamp` to the timestamp of burning.
3065             // - `burned` to `true`.
3066             // - `nextInitialized` to `true`.
3067             _packedOwnerships[tokenId] = _packOwnershipData(
3068                 from,
3069                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
3070             );
3071 
3072             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
3073             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
3074                 uint256 nextTokenId = tokenId + 1;
3075                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
3076                 if (_packedOwnerships[nextTokenId] == 0) {
3077                     // If the next slot is within bounds.
3078                     if (nextTokenId != _currentIndex) {
3079                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
3080                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
3081                     }
3082                 }
3083             }
3084         }
3085 
3086         emit Transfer(from, address(0), tokenId);
3087         _afterTokenTransfers(from, address(0), tokenId, 1);
3088 
3089         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
3090         unchecked {
3091             _burnCounter++;
3092         }
3093     }
3094 
3095     // =============================================================
3096     //                     EXTRA DATA OPERATIONS
3097     // =============================================================
3098 
3099     /**
3100      * @dev Directly sets the extra data for the ownership data `index`.
3101      */
3102     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
3103         uint256 packed = _packedOwnerships[index];
3104         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
3105         uint256 extraDataCasted;
3106         // Cast `extraData` with assembly to avoid redundant masking.
3107         assembly {
3108             extraDataCasted := extraData
3109         }
3110         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
3111         _packedOwnerships[index] = packed;
3112     }
3113 
3114     /**
3115      * @dev Called during each token transfer to set the 24bit `extraData` field.
3116      * Intended to be overridden by the cosumer contract.
3117      *
3118      * `previousExtraData` - the value of `extraData` before transfer.
3119      *
3120      * Calling conditions:
3121      *
3122      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3123      * transferred to `to`.
3124      * - When `from` is zero, `tokenId` will be minted for `to`.
3125      * - When `to` is zero, `tokenId` will be burned by `from`.
3126      * - `from` and `to` are never both zero.
3127      */
3128     function _extraData(
3129         address from,
3130         address to,
3131         uint24 previousExtraData
3132     ) internal view virtual returns (uint24) {}
3133 
3134     /**
3135      * @dev Returns the next extra data for the packed ownership data.
3136      * The returned result is shifted into position.
3137      */
3138     function _nextExtraData(
3139         address from,
3140         address to,
3141         uint256 prevOwnershipPacked
3142     ) private view returns (uint256) {
3143         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3144         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3145     }
3146 
3147     // =============================================================
3148     //                       OTHER OPERATIONS
3149     // =============================================================
3150 
3151     /**
3152      * @dev Returns the message sender (defaults to `msg.sender`).
3153      *
3154      * If you are writing GSN compatible contracts, you need to override this function.
3155      */
3156     function _msgSenderERC721A() internal view virtual returns (address) {
3157         return msg.sender;
3158     }
3159 
3160     /**
3161      * @dev Converts a uint256 to its ASCII string decimal representation.
3162      */
3163     function _toString(uint256 value) internal pure virtual returns (string memory str) {
3164         assembly {
3165             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
3166             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
3167             // We will need 1 word for the trailing zeros padding, 1 word for the length,
3168             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
3169             let m := add(mload(0x40), 0xa0)
3170             // Update the free memory pointer to allocate.
3171             mstore(0x40, m)
3172             // Assign the `str` to the end.
3173             str := sub(m, 0x20)
3174             // Zeroize the slot after the string.
3175             mstore(str, 0)
3176 
3177             // Cache the end of the memory to calculate the length later.
3178             let end := str
3179 
3180             // We write the string from rightmost digit to leftmost digit.
3181             // The following is essentially a do-while loop that also handles the zero case.
3182             // prettier-ignore
3183             for { let temp := value } 1 {} {
3184                 str := sub(str, 1)
3185                 // Write the character to the pointer.
3186                 // The ASCII index of the '0' character is 48.
3187                 mstore8(str, add(48, mod(temp, 10)))
3188                 // Keep dividing `temp` until zero.
3189                 temp := div(temp, 10)
3190                 // prettier-ignore
3191                 if iszero(temp) { break }
3192             }
3193 
3194             let length := sub(end, str)
3195             // Move the pointer 32 bytes leftwards to make room for the length.
3196             str := sub(str, 0x20)
3197             // Store the length.
3198             mstore(str, length)
3199         }
3200     }
3201 
3202     /**
3203      * @dev For more efficient reverts.
3204      */
3205     function _revert(bytes4 errorSelector) internal pure {
3206         assembly {
3207             mstore(0x00, errorSelector)
3208             revert(0x00, 0x04)
3209         }
3210     }
3211 }
3212 // File: contracts/DeluxeGoatDimensions.sol
3213 
3214 
3215 pragma solidity ^0.8.11;
3216 
3217 
3218 
3219 
3220 
3221 
3222 
3223 
3224 contract DeluxeGoatDimensions is ERC721A, ERC2981, Ownable, DefaultOperatorFilterer, PaymentSplitter, ReentrancyGuard {
3225 
3226     uint256 public maxSupply = 8888;
3227     uint256 public limit = 30;
3228     uint256 public price = 0.017 ether;
3229     bool public mintEnabled;
3230     bool public claimEnabled;
3231     bool public revealed;
3232     string public hiddenURI;
3233     string public baseURI;
3234 
3235     mapping(address => uint256) mintedWallets;
3236     mapping(address => uint256) claimableWallets;
3237 
3238     address[] private addressList = [
3239         0xf31288B4B62f8F1580adc4420285c3d62c61e5Bf,
3240         0xf964d5F96542B35e5A253400E9B86F351cDEe842,
3241         0xEa4A49571C621237938fd4d047cD334B90221429,
3242         0x5c211ABd98b75a24FA25fB95fCa3beaad6F57329,
3243         0xfBE1367340Bb85F75131dD3071430F7e2Bb73FBB,
3244         0xA25434c366C45c1D490734eE4EA23e5915630044,
3245         0x178cb7c511B557e413f03e9A8A6fA7243d96c436,
3246         0xcFB3897bfcE32c20c291A360e83BBC0F2954FBd5,
3247         0x478e1661b273E65ffF5170314bE7adE0A0eD3289
3248     ];
3249     
3250     uint256[] private shareList = [
3251         100,
3252         60,
3253         30,
3254         25,
3255         25,
3256         10,
3257         10,
3258         590,
3259         150
3260     ];
3261 
3262     constructor(address payable _royaltyReceiver) ERC721A("DeluxeGoat: Dimensions", "DGD") PaymentSplitter(addressList, shareList) {
3263         setDefaultRoyalty(_royaltyReceiver, 690); // 6.9% default royalty
3264     }
3265 
3266     function mint(uint256 numberOfTokens) external payable nonReentrant {
3267         uint256 amount = numberOfTokens * price;
3268         require(mintEnabled, "Mint disabled");
3269         require(totalSupply() + numberOfTokens <= maxSupply, "We're sold out!");
3270         require(mintedWallets[msg.sender] + numberOfTokens <= limit, "Too many per wallet");
3271         require(msg.value >= amount, "Not enough Ether");
3272 
3273         mintedWallets[msg.sender] += numberOfTokens;
3274         _mint(msg.sender, numberOfTokens);
3275     }
3276 
3277     function claim() external nonReentrant {
3278         uint256 numberOfTokens = claimableWallets[msg.sender];
3279         require(claimEnabled, "Claim disabled");
3280         require(numberOfTokens > 0, "You don't have anything to claim");
3281 
3282         claimableWallets[msg.sender] = 0;
3283         _mint(msg.sender, numberOfTokens);
3284     }
3285 
3286     function teamMint(address to, uint256 numberOfTokens) external onlyOwner nonReentrant {
3287         require(totalSupply() + numberOfTokens <= maxSupply, "We're sold out!");
3288 
3289         _mint(to, numberOfTokens);
3290     }
3291 
3292     function addClaimableWallets(address[] calldata owner, uint256[] calldata amount) external onlyOwner {
3293         for (uint256 i = 0; i < owner.length; i++) {
3294             claimableWallets[owner[i]] = amount[i];
3295         }
3296     }
3297 
3298     function setMaxSupply(uint256 _maxSupply) external onlyOwner {
3299         maxSupply = _maxSupply;
3300     }
3301 
3302     function setLimit(uint256 _limit) external onlyOwner {
3303         limit = _limit;
3304     }
3305 
3306     function setPrice(uint256 _price) external onlyOwner {
3307         price = _price;
3308     }
3309 
3310     function toggleMinting() external onlyOwner {
3311         mintEnabled = !mintEnabled;
3312     }
3313 
3314     function toggleClaiming() external onlyOwner {
3315         claimEnabled = !claimEnabled;
3316     }
3317 
3318     function toggleRevealed() external onlyOwner {
3319         revealed = !revealed;
3320     }
3321 
3322     function setHiddenURI(string calldata hiddenURI_) external onlyOwner {
3323         hiddenURI = hiddenURI_;
3324     }
3325 
3326     function setBaseURI(string calldata baseURI_) external onlyOwner {
3327         baseURI = baseURI_;
3328     }
3329 
3330     function _baseURI() internal view virtual override returns (string memory) {
3331         return baseURI;
3332     }
3333 
3334     function tokenURI(uint256 tokenId) public view override returns (string memory) {
3335         require(_exists(tokenId), "Goat does not exist");
3336 
3337         if (revealed) {
3338             return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, Strings.toString(tokenId))) : "";
3339         }
3340 
3341         return hiddenURI;
3342     }
3343 
3344     function emergencyWithdraw() external onlyOwner nonReentrant {
3345         (bool success, ) = msg.sender.call{value: address(this).balance}("");
3346         require(success, "Withdraw eth failed!");
3347     }
3348 
3349     function getMintedAmount(address _address) public view returns (uint256) {
3350         return mintedWallets[_address];
3351     }
3352 
3353     function getClaimableAmount(address _address) public view returns (uint256) {
3354         return claimableWallets[_address];
3355     }
3356 
3357     // =========================================================================
3358     //                           Operator filtering
3359     // =========================================================================
3360 
3361     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3362         super.setApprovalForAll(operator, approved);
3363     }
3364 
3365     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
3366         super.approve(operator, tokenId);
3367     }
3368 
3369     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
3370         super.transferFrom(from, to, tokenId);
3371     }
3372 
3373     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
3374         super.safeTransferFrom(from, to, tokenId);
3375     }
3376 
3377     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3378         public
3379         payable
3380         override
3381         onlyAllowedOperator(from)
3382     {
3383         super.safeTransferFrom(from, to, tokenId, data);
3384     }
3385 
3386     // =========================================================================
3387     //                                 ERC2891
3388     // =========================================================================
3389 
3390     function setDefaultRoyalty(address receiver, uint96 feeNumerator) public onlyOwner {
3391         _setDefaultRoyalty(receiver, feeNumerator);
3392     }
3393 
3394     function deleteDefaultRoyalty() public onlyOwner {
3395         _deleteDefaultRoyalty();
3396     }
3397 
3398     // =========================================================================
3399     //                                  ERC165
3400     // =========================================================================
3401 
3402     function supportsInterface(bytes4 interfaceId) public view virtual override (ERC2981, ERC721A) returns (bool) {
3403         return super.supportsInterface(interfaceId);
3404     }
3405 }