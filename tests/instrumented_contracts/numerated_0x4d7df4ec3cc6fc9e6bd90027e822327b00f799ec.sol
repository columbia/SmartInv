1 /**
2 ._____. ._____. .___________________________________________________________. ._____. ._____.
3 | ._. | | ._. | | ._______________________________________________________. | | ._. | | ._. |
4 | !_| |_|_|_! | | !_______________________________________________________! | | !_| |_|_|_! |
5 !___| |_______! !___________________________________________________________! !___| |_______!
6 .___|_|_| |_______________________________________________________________________|_|_| |___.
7 | ._____| |___________________________________________________________________________| |_. |
8 | !_! | | |                                                                       | | ! !_! |
9 !_____! | |         _   _       _   _                   _                         | | !_____!
10 ._____. | |        | \ | | ___ | |_| | ____ _ _ __ ___ (_) __ _  ___  ___         | | ._____.
11 | ._. | | |        |  \| |/ _ \| __| |/ / _` | '_ ` _ \| |/ _` |/ _ \/ __|        | | | ._. |
12 | | | | | |        | |\  | (_) | |_|   < (_| | | | | | | | (_| | (_) \__ \        | | | | | |
13 | !_! | | |        |_| \_|\___/ \__|_|\_\__,_|_| |_| |_|_|\__, |\___/|___/        | | ! !_! |
14 !_____! | |                                               |___/                   | | !_____!
15 ._____. | |                                                                       | | ._____.
16 | ._. | | |                                                                       | | | ._. |
17 | !_| |_|_|_______________________________________________________________________| |_|_|_! |
18 !___| |___________________________________________________________________________| |_______!
19 .___|_|_| |___. .___________________________________________________________. .___|_|_| |___.
20 | ._____| |_. | | ._______________________________________________________. | | ._____| |_. |
21 | !_! | | !_! | | !_______________________________________________________! | | !_! | | !_! |
22 !_____! !_____! !___________________________________________________________! !_____! !_____!
23 */
24 
25 pragma solidity ^0.8.0;
26 
27 /**
28  * @dev Contract module that helps prevent reentrant calls to a function.
29  *
30  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
31  * available, which can be applied to functions to make sure there are no nested
32  * (reentrant) calls to them.
33  *
34  * Note that because there is a single `nonReentrant` guard, functions marked as
35  * `nonReentrant` may not call one another. This can be worked around by making
36  * those functions `private`, and then adding `external` `nonReentrant` entry
37  * points to them.
38  *
39  * TIP: If you would like to learn more about reentrancy and alternative ways
40  * to protect against it, check out our blog post
41  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
42  */
43 abstract contract ReentrancyGuard {
44     // Booleans are more expensive than uint256 or any type that takes up a full
45     // word because each write operation emits an extra SLOAD to first read the
46     // slot's contents, replace the bits taken up by the boolean, and then write
47     // back. This is the compiler's defense against contract upgrades and
48     // pointer aliasing, and it cannot be disabled.
49 
50     // The values being non-zero value makes deployment a bit more expensive,
51     // but in exchange the refund on every call to nonReentrant will be lower in
52     // amount. Since refunds are capped to a percentage of the total
53     // transaction's gas, it is best to keep them low in cases like this one, to
54     // increase the likelihood of the full refund coming into effect.
55     uint256 private constant _NOT_ENTERED = 1;
56     uint256 private constant _ENTERED = 2;
57 
58     uint256 private _status;
59 
60     constructor() {
61         _status = _NOT_ENTERED;
62     }
63 
64     /**
65      * @dev Prevents a contract from calling itself, directly or indirectly.
66      * Calling a `nonReentrant` function from another `nonReentrant`
67      * function is not supported. It is possible to prevent this from happening
68      * by making the `nonReentrant` function external, and making it call a
69      * `private` function that does the actual work.
70      */
71     modifier nonReentrant() {
72         _nonReentrantBefore();
73         _;
74         _nonReentrantAfter();
75     }
76 
77     function _nonReentrantBefore() private {
78         // On the first call to nonReentrant, _status will be _NOT_ENTERED
79         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
80 
81         // Any calls to nonReentrant after this point will fail
82         _status = _ENTERED;
83     }
84 
85     function _nonReentrantAfter() private {
86         // By storing the original value once again, a refund is triggered (see
87         // https://eips.ethereum.org/EIPS/eip-2200)
88         _status = _NOT_ENTERED;
89     }
90 }
91 
92 // File: @openzeppelin/contracts/utils/Address.sol
93 
94 
95 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
96 
97 pragma solidity ^0.8.1;
98 
99 /**
100  * @dev Collection of functions related to the address type
101  */
102 library Address {
103     /**
104      * @dev Returns true if `account` is a contract.
105      *
106      * [IMPORTANT]
107      * ====
108      * It is unsafe to assume that an address for which this function returns
109      * false is an externally-owned account (EOA) and not a contract.
110      *
111      * Among others, `isContract` will return false for the following
112      * types of addresses:
113      *
114      *  - an externally-owned account
115      *  - a contract in construction
116      *  - an address where a contract will be created
117      *  - an address where a contract lived, but was destroyed
118      * ====
119      *
120      * [IMPORTANT]
121      * ====
122      * You shouldn't rely on `isContract` to protect against flash loan attacks!
123      *
124      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
125      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
126      * constructor.
127      * ====
128      */
129     function isContract(address account) internal view returns (bool) {
130         // This method relies on extcodesize/address.code.length, which returns 0
131         // for contracts in construction, since the code is only stored at the end
132         // of the constructor execution.
133 
134         return account.code.length > 0;
135     }
136 
137     /**
138      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
139      * `recipient`, forwarding all available gas and reverting on errors.
140      *
141      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
142      * of certain opcodes, possibly making contracts go over the 2300 gas limit
143      * imposed by `transfer`, making them unable to receive funds via
144      * `transfer`. {sendValue} removes this limitation.
145      *
146      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
147      *
148      * IMPORTANT: because control is transferred to `recipient`, care must be
149      * taken to not create reentrancy vulnerabilities. Consider using
150      * {ReentrancyGuard} or the
151      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
152      */
153     function sendValue(address payable recipient, uint256 amount) internal {
154         require(address(this).balance >= amount, "Address: insufficient balance");
155 
156         (bool success, ) = recipient.call{value: amount}("");
157         require(success, "Address: unable to send value, recipient may have reverted");
158     }
159 
160     /**
161      * @dev Performs a Solidity function call using a low level `call`. A
162      * plain `call` is an unsafe replacement for a function call: use this
163      * function instead.
164      *
165      * If `target` reverts with a revert reason, it is bubbled up by this
166      * function (like regular Solidity function calls).
167      *
168      * Returns the raw returned data. To convert to the expected return value,
169      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
170      *
171      * Requirements:
172      *
173      * - `target` must be a contract.
174      * - calling `target` with `data` must not revert.
175      *
176      * _Available since v3.1._
177      */
178     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
179         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
180     }
181 
182     /**
183      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
184      * `errorMessage` as a fallback revert reason when `target` reverts.
185      *
186      * _Available since v3.1._
187      */
188     function functionCall(
189         address target,
190         bytes memory data,
191         string memory errorMessage
192     ) internal returns (bytes memory) {
193         return functionCallWithValue(target, data, 0, errorMessage);
194     }
195 
196     /**
197      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
198      * but also transferring `value` wei to `target`.
199      *
200      * Requirements:
201      *
202      * - the calling contract must have an ETH balance of at least `value`.
203      * - the called Solidity function must be `payable`.
204      *
205      * _Available since v3.1._
206      */
207     function functionCallWithValue(
208         address target,
209         bytes memory data,
210         uint256 value
211     ) internal returns (bytes memory) {
212         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
213     }
214 
215     /**
216      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
217      * with `errorMessage` as a fallback revert reason when `target` reverts.
218      *
219      * _Available since v3.1._
220      */
221     function functionCallWithValue(
222         address target,
223         bytes memory data,
224         uint256 value,
225         string memory errorMessage
226     ) internal returns (bytes memory) {
227         require(address(this).balance >= value, "Address: insufficient balance for call");
228         (bool success, bytes memory returndata) = target.call{value: value}(data);
229         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
230     }
231 
232     /**
233      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
234      * but performing a static call.
235      *
236      * _Available since v3.3._
237      */
238     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
239         return functionStaticCall(target, data, "Address: low-level static call failed");
240     }
241 
242     /**
243      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
244      * but performing a static call.
245      *
246      * _Available since v3.3._
247      */
248     function functionStaticCall(
249         address target,
250         bytes memory data,
251         string memory errorMessage
252     ) internal view returns (bytes memory) {
253         (bool success, bytes memory returndata) = target.staticcall(data);
254         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
255     }
256 
257     /**
258      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
259      * but performing a delegate call.
260      *
261      * _Available since v3.4._
262      */
263     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
264         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
265     }
266 
267     /**
268      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
269      * but performing a delegate call.
270      *
271      * _Available since v3.4._
272      */
273     function functionDelegateCall(
274         address target,
275         bytes memory data,
276         string memory errorMessage
277     ) internal returns (bytes memory) {
278         (bool success, bytes memory returndata) = target.delegatecall(data);
279         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
280     }
281 
282     /**
283      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
284      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
285      *
286      * _Available since v4.8._
287      */
288     function verifyCallResultFromTarget(
289         address target,
290         bool success,
291         bytes memory returndata,
292         string memory errorMessage
293     ) internal view returns (bytes memory) {
294         if (success) {
295             if (returndata.length == 0) {
296                 // only check isContract if the call was successful and the return data is empty
297                 // otherwise we already know that it was a contract
298                 require(isContract(target), "Address: call to non-contract");
299             }
300             return returndata;
301         } else {
302             _revert(returndata, errorMessage);
303         }
304     }
305 
306     /**
307      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
308      * revert reason or using the provided one.
309      *
310      * _Available since v4.3._
311      */
312     function verifyCallResult(
313         bool success,
314         bytes memory returndata,
315         string memory errorMessage
316     ) internal pure returns (bytes memory) {
317         if (success) {
318             return returndata;
319         } else {
320             _revert(returndata, errorMessage);
321         }
322     }
323 
324     function _revert(bytes memory returndata, string memory errorMessage) private pure {
325         // Look for revert reason and bubble it up if present
326         if (returndata.length > 0) {
327             // The easiest way to bubble the revert reason is using memory via assembly
328             /// @solidity memory-safe-assembly
329             assembly {
330                 let returndata_size := mload(returndata)
331                 revert(add(32, returndata), returndata_size)
332             }
333         } else {
334             revert(errorMessage);
335         }
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/math/Math.sol
340 
341 
342 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
343 
344 pragma solidity ^0.8.0;
345 
346 /**
347  * @dev Standard math utilities missing in the Solidity language.
348  */
349 library Math {
350     enum Rounding {
351         Down, // Toward negative infinity
352         Up, // Toward infinity
353         Zero // Toward zero
354     }
355 
356     /**
357      * @dev Returns the largest of two numbers.
358      */
359     function max(uint256 a, uint256 b) internal pure returns (uint256) {
360         return a > b ? a : b;
361     }
362 
363     /**
364      * @dev Returns the smallest of two numbers.
365      */
366     function min(uint256 a, uint256 b) internal pure returns (uint256) {
367         return a < b ? a : b;
368     }
369 
370     /**
371      * @dev Returns the average of two numbers. The result is rounded towards
372      * zero.
373      */
374     function average(uint256 a, uint256 b) internal pure returns (uint256) {
375         // (a + b) / 2 can overflow.
376         return (a & b) + (a ^ b) / 2;
377     }
378 
379     /**
380      * @dev Returns the ceiling of the division of two numbers.
381      *
382      * This differs from standard division with `/` in that it rounds up instead
383      * of rounding down.
384      */
385     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
386         // (a + b - 1) / b can overflow on addition, so we distribute.
387         return a == 0 ? 0 : (a - 1) / b + 1;
388     }
389 
390     /**
391      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
392      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
393      * with further edits by Uniswap Labs also under MIT license.
394      */
395     function mulDiv(
396         uint256 x,
397         uint256 y,
398         uint256 denominator
399     ) internal pure returns (uint256 result) {
400         unchecked {
401             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
402             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
403             // variables such that product = prod1 * 2^256 + prod0.
404             uint256 prod0; // Least significant 256 bits of the product
405             uint256 prod1; // Most significant 256 bits of the product
406             assembly {
407                 let mm := mulmod(x, y, not(0))
408                 prod0 := mul(x, y)
409                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
410             }
411 
412             // Handle non-overflow cases, 256 by 256 division.
413             if (prod1 == 0) {
414                 return prod0 / denominator;
415             }
416 
417             // Make sure the result is less than 2^256. Also prevents denominator == 0.
418             require(denominator > prod1);
419 
420             ///////////////////////////////////////////////
421             // 512 by 256 division.
422             ///////////////////////////////////////////////
423 
424             // Make division exact by subtracting the remainder from [prod1 prod0].
425             uint256 remainder;
426             assembly {
427                 // Compute remainder using mulmod.
428                 remainder := mulmod(x, y, denominator)
429 
430                 // Subtract 256 bit number from 512 bit number.
431                 prod1 := sub(prod1, gt(remainder, prod0))
432                 prod0 := sub(prod0, remainder)
433             }
434 
435             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
436             // See https://cs.stackexchange.com/q/138556/92363.
437 
438             // Does not overflow because the denominator cannot be zero at this stage in the function.
439             uint256 twos = denominator & (~denominator + 1);
440             assembly {
441                 // Divide denominator by twos.
442                 denominator := div(denominator, twos)
443 
444                 // Divide [prod1 prod0] by twos.
445                 prod0 := div(prod0, twos)
446 
447                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
448                 twos := add(div(sub(0, twos), twos), 1)
449             }
450 
451             // Shift in bits from prod1 into prod0.
452             prod0 |= prod1 * twos;
453 
454             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
455             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
456             // four bits. That is, denominator * inv = 1 mod 2^4.
457             uint256 inverse = (3 * denominator) ^ 2;
458 
459             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
460             // in modular arithmetic, doubling the correct bits in each step.
461             inverse *= 2 - denominator * inverse; // inverse mod 2^8
462             inverse *= 2 - denominator * inverse; // inverse mod 2^16
463             inverse *= 2 - denominator * inverse; // inverse mod 2^32
464             inverse *= 2 - denominator * inverse; // inverse mod 2^64
465             inverse *= 2 - denominator * inverse; // inverse mod 2^128
466             inverse *= 2 - denominator * inverse; // inverse mod 2^256
467 
468             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
469             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
470             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
471             // is no longer required.
472             result = prod0 * inverse;
473             return result;
474         }
475     }
476 
477     /**
478      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
479      */
480     function mulDiv(
481         uint256 x,
482         uint256 y,
483         uint256 denominator,
484         Rounding rounding
485     ) internal pure returns (uint256) {
486         uint256 result = mulDiv(x, y, denominator);
487         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
488             result += 1;
489         }
490         return result;
491     }
492 
493     /**
494      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
495      *
496      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
497      */
498     function sqrt(uint256 a) internal pure returns (uint256) {
499         if (a == 0) {
500             return 0;
501         }
502 
503         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
504         //
505         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
506         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
507         //
508         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
509         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
510         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
511         //
512         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
513         uint256 result = 1 << (log2(a) >> 1);
514 
515         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
516         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
517         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
518         // into the expected uint128 result.
519         unchecked {
520             result = (result + a / result) >> 1;
521             result = (result + a / result) >> 1;
522             result = (result + a / result) >> 1;
523             result = (result + a / result) >> 1;
524             result = (result + a / result) >> 1;
525             result = (result + a / result) >> 1;
526             result = (result + a / result) >> 1;
527             return min(result, a / result);
528         }
529     }
530 
531     /**
532      * @notice Calculates sqrt(a), following the selected rounding direction.
533      */
534     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
535         unchecked {
536             uint256 result = sqrt(a);
537             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
538         }
539     }
540 
541     /**
542      * @dev Return the log in base 2, rounded down, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log2(uint256 value) internal pure returns (uint256) {
546         uint256 result = 0;
547         unchecked {
548             if (value >> 128 > 0) {
549                 value >>= 128;
550                 result += 128;
551             }
552             if (value >> 64 > 0) {
553                 value >>= 64;
554                 result += 64;
555             }
556             if (value >> 32 > 0) {
557                 value >>= 32;
558                 result += 32;
559             }
560             if (value >> 16 > 0) {
561                 value >>= 16;
562                 result += 16;
563             }
564             if (value >> 8 > 0) {
565                 value >>= 8;
566                 result += 8;
567             }
568             if (value >> 4 > 0) {
569                 value >>= 4;
570                 result += 4;
571             }
572             if (value >> 2 > 0) {
573                 value >>= 2;
574                 result += 2;
575             }
576             if (value >> 1 > 0) {
577                 result += 1;
578             }
579         }
580         return result;
581     }
582 
583     /**
584      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
585      * Returns 0 if given 0.
586      */
587     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
588         unchecked {
589             uint256 result = log2(value);
590             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
591         }
592     }
593 
594     /**
595      * @dev Return the log in base 10, rounded down, of a positive value.
596      * Returns 0 if given 0.
597      */
598     function log10(uint256 value) internal pure returns (uint256) {
599         uint256 result = 0;
600         unchecked {
601             if (value >= 10**64) {
602                 value /= 10**64;
603                 result += 64;
604             }
605             if (value >= 10**32) {
606                 value /= 10**32;
607                 result += 32;
608             }
609             if (value >= 10**16) {
610                 value /= 10**16;
611                 result += 16;
612             }
613             if (value >= 10**8) {
614                 value /= 10**8;
615                 result += 8;
616             }
617             if (value >= 10**4) {
618                 value /= 10**4;
619                 result += 4;
620             }
621             if (value >= 10**2) {
622                 value /= 10**2;
623                 result += 2;
624             }
625             if (value >= 10**1) {
626                 result += 1;
627             }
628         }
629         return result;
630     }
631 
632     /**
633      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
634      * Returns 0 if given 0.
635      */
636     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
637         unchecked {
638             uint256 result = log10(value);
639             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
640         }
641     }
642 
643     /**
644      * @dev Return the log in base 256, rounded down, of a positive value.
645      * Returns 0 if given 0.
646      *
647      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
648      */
649     function log256(uint256 value) internal pure returns (uint256) {
650         uint256 result = 0;
651         unchecked {
652             if (value >> 128 > 0) {
653                 value >>= 128;
654                 result += 16;
655             }
656             if (value >> 64 > 0) {
657                 value >>= 64;
658                 result += 8;
659             }
660             if (value >> 32 > 0) {
661                 value >>= 32;
662                 result += 4;
663             }
664             if (value >> 16 > 0) {
665                 value >>= 16;
666                 result += 2;
667             }
668             if (value >> 8 > 0) {
669                 result += 1;
670             }
671         }
672         return result;
673     }
674 
675     /**
676      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
677      * Returns 0 if given 0.
678      */
679     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
680         unchecked {
681             uint256 result = log256(value);
682             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
683         }
684     }
685 }
686 
687 // File: @openzeppelin/contracts/utils/Strings.sol
688 
689 
690 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 
695 /**
696  * @dev String operations.
697  */
698 library Strings {
699     bytes16 private constant _SYMBOLS = "0123456789abcdef";
700     uint8 private constant _ADDRESS_LENGTH = 20;
701 
702     /**
703      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
704      */
705     function toString(uint256 value) internal pure returns (string memory) {
706         unchecked {
707             uint256 length = Math.log10(value) + 1;
708             string memory buffer = new string(length);
709             uint256 ptr;
710             /// @solidity memory-safe-assembly
711             assembly {
712                 ptr := add(buffer, add(32, length))
713             }
714             while (true) {
715                 ptr--;
716                 /// @solidity memory-safe-assembly
717                 assembly {
718                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
719                 }
720                 value /= 10;
721                 if (value == 0) break;
722             }
723             return buffer;
724         }
725     }
726 
727     /**
728      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
729      */
730     function toHexString(uint256 value) internal pure returns (string memory) {
731         unchecked {
732             return toHexString(value, Math.log256(value) + 1);
733         }
734     }
735 
736     /**
737      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
738      */
739     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
740         bytes memory buffer = new bytes(2 * length + 2);
741         buffer[0] = "0";
742         buffer[1] = "x";
743         for (uint256 i = 2 * length + 1; i > 1; --i) {
744             buffer[i] = _SYMBOLS[value & 0xf];
745             value >>= 4;
746         }
747         require(value == 0, "Strings: hex length insufficient");
748         return string(buffer);
749     }
750 
751     /**
752      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
753      */
754     function toHexString(address addr) internal pure returns (string memory) {
755         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
756     }
757 }
758 
759 // File: @openzeppelin/contracts/utils/Context.sol
760 
761 
762 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 /**
767  * @dev Provides information about the current execution context, including the
768  * sender of the transaction and its data. While these are generally available
769  * via msg.sender and msg.data, they should not be accessed in such a direct
770  * manner, since when dealing with meta-transactions the account sending and
771  * paying for execution may not be the actual sender (as far as an application
772  * is concerned).
773  *
774  * This contract is only required for intermediate, library-like contracts.
775  */
776 abstract contract Context {
777     function _msgSender() internal view virtual returns (address) {
778         return msg.sender;
779     }
780 
781     function _msgData() internal view virtual returns (bytes calldata) {
782         return msg.data;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/access/Ownable.sol
787 
788 
789 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Contract module which provides a basic access control mechanism, where
796  * there is an account (an owner) that can be granted exclusive access to
797  * specific functions.
798  *
799  * By default, the owner account will be the one that deploys the contract. This
800  * can later be changed with {transferOwnership}.
801  *
802  * This module is used through inheritance. It will make available the modifier
803  * `onlyOwner`, which can be applied to your functions to restrict their use to
804  * the owner.
805  */
806 abstract contract Ownable is Context {
807     address private _owner;
808 
809     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
810 
811     /**
812      * @dev Initializes the contract setting the deployer as the initial owner.
813      */
814     constructor() {
815         _transferOwnership(_msgSender());
816     }
817 
818     /**
819      * @dev Throws if called by any account other than the owner.
820      */
821     modifier onlyOwner() {
822         _checkOwner();
823         _;
824     }
825 
826     /**
827      * @dev Returns the address of the current owner.
828      */
829     function owner() public view virtual returns (address) {
830         return _owner;
831     }
832 
833     /**
834      * @dev Throws if the sender is not the owner.
835      */
836     function _checkOwner() internal view virtual {
837         require(owner() == _msgSender(), "Ownable: caller is not the owner");
838     }
839 
840     /**
841      * @dev Leaves the contract without owner. It will not be possible to call
842      * `onlyOwner` functions anymore. Can only be called by the current owner.
843      *
844      * NOTE: Renouncing ownership will leave the contract without an owner,
845      * thereby removing any functionality that is only available to the owner.
846      */
847     function renounceOwnership() public virtual onlyOwner {
848         _transferOwnership(address(0));
849     }
850 
851     /**
852      * @dev Transfers ownership of the contract to a new account (`newOwner`).
853      * Can only be called by the current owner.
854      */
855     function transferOwnership(address newOwner) public virtual onlyOwner {
856         require(newOwner != address(0), "Ownable: new owner is the zero address");
857         _transferOwnership(newOwner);
858     }
859 
860     /**
861      * @dev Transfers ownership of the contract to a new account (`newOwner`).
862      * Internal function without access restriction.
863      */
864     function _transferOwnership(address newOwner) internal virtual {
865         address oldOwner = _owner;
866         _owner = newOwner;
867         emit OwnershipTransferred(oldOwner, newOwner);
868     }
869 }
870 
871 // File: erc721a/contracts/IERC721A.sol
872 
873 
874 // ERC721A Contracts v4.2.3
875 // Creator: Chiru Labs
876 
877 pragma solidity ^0.8.4;
878 
879 /**
880  * @dev Interface of ERC721A.
881  */
882 interface IERC721A {
883     /**
884      * The caller must own the token or be an approved operator.
885      */
886     error ApprovalCallerNotOwnerNorApproved();
887 
888     /**
889      * The token does not exist.
890      */
891     error ApprovalQueryForNonexistentToken();
892 
893     /**
894      * Cannot query the balance for the zero address.
895      */
896     error BalanceQueryForZeroAddress();
897 
898     /**
899      * Cannot mint to the zero address.
900      */
901     error MintToZeroAddress();
902 
903     /**
904      * The quantity of tokens minted must be more than zero.
905      */
906     error MintZeroQuantity();
907 
908     /**
909      * The token does not exist.
910      */
911     error OwnerQueryForNonexistentToken();
912 
913     /**
914      * The caller must own the token or be an approved operator.
915      */
916     error TransferCallerNotOwnerNorApproved();
917 
918     /**
919      * The token must be owned by `from`.
920      */
921     error TransferFromIncorrectOwner();
922 
923     /**
924      * Cannot safely transfer to a contract that does not implement the
925      * ERC721Receiver interface.
926      */
927     error TransferToNonERC721ReceiverImplementer();
928 
929     /**
930      * Cannot transfer to the zero address.
931      */
932     error TransferToZeroAddress();
933 
934     /**
935      * The token does not exist.
936      */
937     error URIQueryForNonexistentToken();
938 
939     /**
940      * The `quantity` minted with ERC2309 exceeds the safety limit.
941      */
942     error MintERC2309QuantityExceedsLimit();
943 
944     /**
945      * The `extraData` cannot be set on an unintialized ownership slot.
946      */
947     error OwnershipNotInitializedForExtraData();
948 
949     // =============================================================
950     //                            STRUCTS
951     // =============================================================
952 
953     struct TokenOwnership {
954         // The address of the owner.
955         address addr;
956         // Stores the start time of ownership with minimal overhead for tokenomics.
957         uint64 startTimestamp;
958         // Whether the token has been burned.
959         bool burned;
960         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
961         uint24 extraData;
962     }
963 
964     // =============================================================
965     //                         TOKEN COUNTERS
966     // =============================================================
967 
968     /**
969      * @dev Returns the total number of tokens in existence.
970      * Burned tokens will reduce the count.
971      * To get the total number of tokens minted, please see {_totalMinted}.
972      */
973     function totalSupply() external view returns (uint256);
974 
975     // =============================================================
976     //                            IERC165
977     // =============================================================
978 
979     /**
980      * @dev Returns true if this contract implements the interface defined by
981      * `interfaceId`. See the corresponding
982      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
983      * to learn more about how these ids are created.
984      *
985      * This function call must use less than 30000 gas.
986      */
987     function supportsInterface(bytes4 interfaceId) external view returns (bool);
988 
989     // =============================================================
990     //                            IERC721
991     // =============================================================
992 
993     /**
994      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
995      */
996     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
997 
998     /**
999      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1000      */
1001     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1002 
1003     /**
1004      * @dev Emitted when `owner` enables or disables
1005      * (`approved`) `operator` to manage all of its assets.
1006      */
1007     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1008 
1009     /**
1010      * @dev Returns the number of tokens in `owner`'s account.
1011      */
1012     function balanceOf(address owner) external view returns (uint256 balance);
1013 
1014     /**
1015      * @dev Returns the owner of the `tokenId` token.
1016      *
1017      * Requirements:
1018      *
1019      * - `tokenId` must exist.
1020      */
1021     function ownerOf(uint256 tokenId) external view returns (address owner);
1022 
1023     /**
1024      * @dev Safely transfers `tokenId` token from `from` to `to`,
1025      * checking first that contract recipients are aware of the ERC721 protocol
1026      * to prevent tokens from being forever locked.
1027      *
1028      * Requirements:
1029      *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032      * - `tokenId` token must exist and be owned by `from`.
1033      * - If the caller is not `from`, it must be have been allowed to move
1034      * this token by either {approve} or {setApprovalForAll}.
1035      * - If `to` refers to a smart contract, it must implement
1036      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1037      *
1038      * Emits a {Transfer} event.
1039      */
1040     function safeTransferFrom(
1041         address from,
1042         address to,
1043         uint256 tokenId,
1044         bytes calldata data
1045     ) external payable;
1046 
1047     /**
1048      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1049      */
1050     function safeTransferFrom(
1051         address from,
1052         address to,
1053         uint256 tokenId
1054     ) external payable;
1055 
1056     /**
1057      * @dev Transfers `tokenId` from `from` to `to`.
1058      *
1059      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1060      * whenever possible.
1061      *
1062      * Requirements:
1063      *
1064      * - `from` cannot be the zero address.
1065      * - `to` cannot be the zero address.
1066      * - `tokenId` token must be owned by `from`.
1067      * - If the caller is not `from`, it must be approved to move this token
1068      * by either {approve} or {setApprovalForAll}.
1069      *
1070      * Emits a {Transfer} event.
1071      */
1072     function transferFrom(
1073         address from,
1074         address to,
1075         uint256 tokenId
1076     ) external payable;
1077 
1078     /**
1079      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1080      * The approval is cleared when the token is transferred.
1081      *
1082      * Only a single account can be approved at a time, so approving the
1083      * zero address clears previous approvals.
1084      *
1085      * Requirements:
1086      *
1087      * - The caller must own the token or be an approved operator.
1088      * - `tokenId` must exist.
1089      *
1090      * Emits an {Approval} event.
1091      */
1092     function approve(address to, uint256 tokenId) external payable;
1093 
1094     /**
1095      * @dev Approve or remove `operator` as an operator for the caller.
1096      * Operators can call {transferFrom} or {safeTransferFrom}
1097      * for any token owned by the caller.
1098      *
1099      * Requirements:
1100      *
1101      * - The `operator` cannot be the caller.
1102      *
1103      * Emits an {ApprovalForAll} event.
1104      */
1105     function setApprovalForAll(address operator, bool _approved) external;
1106 
1107     /**
1108      * @dev Returns the account approved for `tokenId` token.
1109      *
1110      * Requirements:
1111      *
1112      * - `tokenId` must exist.
1113      */
1114     function getApproved(uint256 tokenId) external view returns (address operator);
1115 
1116     /**
1117      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1118      *
1119      * See {setApprovalForAll}.
1120      */
1121     function isApprovedForAll(address owner, address operator) external view returns (bool);
1122 
1123     // =============================================================
1124     //                        IERC721Metadata
1125     // =============================================================
1126 
1127     /**
1128      * @dev Returns the token collection name.
1129      */
1130     function name() external view returns (string memory);
1131 
1132     /**
1133      * @dev Returns the token collection symbol.
1134      */
1135     function symbol() external view returns (string memory);
1136 
1137     /**
1138      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1139      */
1140     function tokenURI(uint256 tokenId) external view returns (string memory);
1141 
1142     // =============================================================
1143     //                           IERC2309
1144     // =============================================================
1145 
1146     /**
1147      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1148      * (inclusive) is transferred from `from` to `to`, as defined in the
1149      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1150      *
1151      * See {_mintERC2309} for more details.
1152      */
1153     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1154 }
1155 
1156 // File: erc721a/contracts/ERC721A.sol
1157 
1158 
1159 // ERC721A Contracts v4.2.3
1160 // Creator: Chiru Labs
1161 
1162 pragma solidity ^0.8.4;
1163 
1164 
1165 /**
1166  * @dev Interface of ERC721 token receiver.
1167  */
1168 interface ERC721A__IERC721Receiver {
1169     function onERC721Received(
1170         address operator,
1171         address from,
1172         uint256 tokenId,
1173         bytes calldata data
1174     ) external returns (bytes4);
1175 }
1176 
1177 /**
1178  * @title ERC721A
1179  *
1180  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1181  * Non-Fungible Token Standard, including the Metadata extension.
1182  * Optimized for lower gas during batch mints.
1183  *
1184  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1185  * starting from `_startTokenId()`.
1186  *
1187  * Assumptions:
1188  *
1189  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1190  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1191  */
1192 contract ERC721A is IERC721A {
1193     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1194     struct TokenApprovalRef {
1195         address value;
1196     }
1197 
1198     // =============================================================
1199     //                           CONSTANTS
1200     // =============================================================
1201 
1202     // Mask of an entry in packed address data.
1203     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1204 
1205     // The bit position of `numberMinted` in packed address data.
1206     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1207 
1208     // The bit position of `numberBurned` in packed address data.
1209     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1210 
1211     // The bit position of `aux` in packed address data.
1212     uint256 private constant _BITPOS_AUX = 192;
1213 
1214     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1215     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1216 
1217     // The bit position of `startTimestamp` in packed ownership.
1218     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1219 
1220     // The bit mask of the `burned` bit in packed ownership.
1221     uint256 private constant _BITMASK_BURNED = 1 << 224;
1222 
1223     // The bit position of the `nextInitialized` bit in packed ownership.
1224     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1225 
1226     // The bit mask of the `nextInitialized` bit in packed ownership.
1227     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1228 
1229     // The bit position of `extraData` in packed ownership.
1230     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1231 
1232     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1233     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1234 
1235     // The mask of the lower 160 bits for addresses.
1236     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1237 
1238     // The maximum `quantity` that can be minted with {_mintERC2309}.
1239     // This limit is to prevent overflows on the address data entries.
1240     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1241     // is required to cause an overflow, which is unrealistic.
1242     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1243 
1244     // The `Transfer` event signature is given by:
1245     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1246     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1247         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1248 
1249     // =============================================================
1250     //                            STORAGE
1251     // =============================================================
1252 
1253     // The next token ID to be minted.
1254     uint256 private _currentIndex;
1255 
1256     // The number of tokens burned.
1257     uint256 private _burnCounter;
1258 
1259     // Token name
1260     string private _name;
1261 
1262     // Token symbol
1263     string private _symbol;
1264 
1265     // Mapping from token ID to ownership details
1266     // An empty struct value does not necessarily mean the token is unowned.
1267     // See {_packedOwnershipOf} implementation for details.
1268     //
1269     // Bits Layout:
1270     // - [0..159]   `addr`
1271     // - [160..223] `startTimestamp`
1272     // - [224]      `burned`
1273     // - [225]      `nextInitialized`
1274     // - [232..255] `extraData`
1275     mapping(uint256 => uint256) private _packedOwnerships;
1276 
1277     // Mapping owner address to address data.
1278     //
1279     // Bits Layout:
1280     // - [0..63]    `balance`
1281     // - [64..127]  `numberMinted`
1282     // - [128..191] `numberBurned`
1283     // - [192..255] `aux`
1284     mapping(address => uint256) private _packedAddressData;
1285 
1286     // Mapping from token ID to approved address.
1287     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1288 
1289     // Mapping from owner to operator approvals
1290     mapping(address => mapping(address => bool)) private _operatorApprovals;
1291 
1292     // =============================================================
1293     //                          CONSTRUCTOR
1294     // =============================================================
1295 
1296     constructor(string memory name_, string memory symbol_) {
1297         _name = name_;
1298         _symbol = symbol_;
1299         _currentIndex = _startTokenId();
1300     }
1301 
1302     // =============================================================
1303     //                   TOKEN COUNTING OPERATIONS
1304     // =============================================================
1305 
1306     /**
1307      * @dev Returns the starting token ID.
1308      * To change the starting token ID, please override this function.
1309      */
1310     function _startTokenId() internal view virtual returns (uint256) {
1311         return 0;
1312     }
1313 
1314     /**
1315      * @dev Returns the next token ID to be minted.
1316      */
1317     function _nextTokenId() internal view virtual returns (uint256) {
1318         return _currentIndex;
1319     }
1320 
1321     /**
1322      * @dev Returns the total number of tokens in existence.
1323      * Burned tokens will reduce the count.
1324      * To get the total number of tokens minted, please see {_totalMinted}.
1325      */
1326     function totalSupply() public view virtual override returns (uint256) {
1327         // Counter underflow is impossible as _burnCounter cannot be incremented
1328         // more than `_currentIndex - _startTokenId()` times.
1329         unchecked {
1330             return _currentIndex - _burnCounter - _startTokenId();
1331         }
1332     }
1333 
1334     /**
1335      * @dev Returns the total amount of tokens minted in the contract.
1336      */
1337     function _totalMinted() internal view virtual returns (uint256) {
1338         // Counter underflow is impossible as `_currentIndex` does not decrement,
1339         // and it is initialized to `_startTokenId()`.
1340         unchecked {
1341             return _currentIndex - _startTokenId();
1342         }
1343     }
1344 
1345     /**
1346      * @dev Returns the total number of tokens burned.
1347      */
1348     function _totalBurned() internal view virtual returns (uint256) {
1349         return _burnCounter;
1350     }
1351 
1352     // =============================================================
1353     //                    ADDRESS DATA OPERATIONS
1354     // =============================================================
1355 
1356     /**
1357      * @dev Returns the number of tokens in `owner`'s account.
1358      */
1359     function balanceOf(address owner) public view virtual override returns (uint256) {
1360         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1361         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1362     }
1363 
1364     /**
1365      * Returns the number of tokens minted by `owner`.
1366      */
1367     function _numberMinted(address owner) internal view returns (uint256) {
1368         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1369     }
1370 
1371     /**
1372      * Returns the number of tokens burned by or on behalf of `owner`.
1373      */
1374     function _numberBurned(address owner) internal view returns (uint256) {
1375         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1376     }
1377 
1378     /**
1379      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1380      */
1381     function _getAux(address owner) internal view returns (uint64) {
1382         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1383     }
1384 
1385     /**
1386      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1387      * If there are multiple variables, please pack them into a uint64.
1388      */
1389     function _setAux(address owner, uint64 aux) internal virtual {
1390         uint256 packed = _packedAddressData[owner];
1391         uint256 auxCasted;
1392         // Cast `aux` with assembly to avoid redundant masking.
1393         assembly {
1394             auxCasted := aux
1395         }
1396         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1397         _packedAddressData[owner] = packed;
1398     }
1399 
1400     // =============================================================
1401     //                            IERC165
1402     // =============================================================
1403 
1404     /**
1405      * @dev Returns true if this contract implements the interface defined by
1406      * `interfaceId`. See the corresponding
1407      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1408      * to learn more about how these ids are created.
1409      *
1410      * This function call must use less than 30000 gas.
1411      */
1412     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1413         // The interface IDs are constants representing the first 4 bytes
1414         // of the XOR of all function selectors in the interface.
1415         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1416         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1417         return
1418             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1419             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1420             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1421     }
1422 
1423     // =============================================================
1424     //                        IERC721Metadata
1425     // =============================================================
1426 
1427     /**
1428      * @dev Returns the token collection name.
1429      */
1430     function name() public view virtual override returns (string memory) {
1431         return _name;
1432     }
1433 
1434     /**
1435      * @dev Returns the token collection symbol.
1436      */
1437     function symbol() public view virtual override returns (string memory) {
1438         return _symbol;
1439     }
1440 
1441     /**
1442      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1443      */
1444     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1445         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1446 
1447         string memory baseURI = _baseURI();
1448         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1449     }
1450 
1451     /**
1452      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1453      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1454      * by default, it can be overridden in child contracts.
1455      */
1456     function _baseURI() internal view virtual returns (string memory) {
1457         return '';
1458     }
1459 
1460     // =============================================================
1461     //                     OWNERSHIPS OPERATIONS
1462     // =============================================================
1463 
1464     /**
1465      * @dev Returns the owner of the `tokenId` token.
1466      *
1467      * Requirements:
1468      *
1469      * - `tokenId` must exist.
1470      */
1471     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1472         return address(uint160(_packedOwnershipOf(tokenId)));
1473     }
1474 
1475     /**
1476      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1477      * It gradually moves to O(1) as tokens get transferred around over time.
1478      */
1479     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1480         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1481     }
1482 
1483     /**
1484      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1485      */
1486     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1487         return _unpackedOwnership(_packedOwnerships[index]);
1488     }
1489 
1490     /**
1491      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1492      */
1493     function _initializeOwnershipAt(uint256 index) internal virtual {
1494         if (_packedOwnerships[index] == 0) {
1495             _packedOwnerships[index] = _packedOwnershipOf(index);
1496         }
1497     }
1498 
1499     /**
1500      * Returns the packed ownership data of `tokenId`.
1501      */
1502     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1503         uint256 curr = tokenId;
1504 
1505         unchecked {
1506             if (_startTokenId() <= curr)
1507                 if (curr < _currentIndex) {
1508                     uint256 packed = _packedOwnerships[curr];
1509                     // If not burned.
1510                     if (packed & _BITMASK_BURNED == 0) {
1511                         // Invariant:
1512                         // There will always be an initialized ownership slot
1513                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1514                         // before an unintialized ownership slot
1515                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1516                         // Hence, `curr` will not underflow.
1517                         //
1518                         // We can directly compare the packed value.
1519                         // If the address is zero, packed will be zero.
1520                         while (packed == 0) {
1521                             packed = _packedOwnerships[--curr];
1522                         }
1523                         return packed;
1524                     }
1525                 }
1526         }
1527         revert OwnerQueryForNonexistentToken();
1528     }
1529 
1530     /**
1531      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1532      */
1533     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1534         ownership.addr = address(uint160(packed));
1535         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1536         ownership.burned = packed & _BITMASK_BURNED != 0;
1537         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1538     }
1539 
1540     /**
1541      * @dev Packs ownership data into a single uint256.
1542      */
1543     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1544         assembly {
1545             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1546             owner := and(owner, _BITMASK_ADDRESS)
1547             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1548             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1549         }
1550     }
1551 
1552     /**
1553      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1554      */
1555     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1556         // For branchless setting of the `nextInitialized` flag.
1557         assembly {
1558             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1559             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1560         }
1561     }
1562 
1563     // =============================================================
1564     //                      APPROVAL OPERATIONS
1565     // =============================================================
1566 
1567     /**
1568      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1569      * The approval is cleared when the token is transferred.
1570      *
1571      * Only a single account can be approved at a time, so approving the
1572      * zero address clears previous approvals.
1573      *
1574      * Requirements:
1575      *
1576      * - The caller must own the token or be an approved operator.
1577      * - `tokenId` must exist.
1578      *
1579      * Emits an {Approval} event.
1580      */
1581     function approve(address to, uint256 tokenId) public payable virtual override {
1582         address owner = ownerOf(tokenId);
1583 
1584         if (_msgSenderERC721A() != owner)
1585             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1586                 revert ApprovalCallerNotOwnerNorApproved();
1587             }
1588 
1589         _tokenApprovals[tokenId].value = to;
1590         emit Approval(owner, to, tokenId);
1591     }
1592 
1593     /**
1594      * @dev Returns the account approved for `tokenId` token.
1595      *
1596      * Requirements:
1597      *
1598      * - `tokenId` must exist.
1599      */
1600     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1601         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1602 
1603         return _tokenApprovals[tokenId].value;
1604     }
1605 
1606     /**
1607      * @dev Approve or remove `operator` as an operator for the caller.
1608      * Operators can call {transferFrom} or {safeTransferFrom}
1609      * for any token owned by the caller.
1610      *
1611      * Requirements:
1612      *
1613      * - The `operator` cannot be the caller.
1614      *
1615      * Emits an {ApprovalForAll} event.
1616      */
1617     function setApprovalForAll(address operator, bool approved) public virtual override {
1618         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1619         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1620     }
1621 
1622     /**
1623      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1624      *
1625      * See {setApprovalForAll}.
1626      */
1627     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1628         return _operatorApprovals[owner][operator];
1629     }
1630 
1631     /**
1632      * @dev Returns whether `tokenId` exists.
1633      *
1634      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1635      *
1636      * Tokens start existing when they are minted. See {_mint}.
1637      */
1638     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1639         return
1640             _startTokenId() <= tokenId &&
1641             tokenId < _currentIndex && // If within bounds,
1642             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1643     }
1644 
1645     /**
1646      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1647      */
1648     function _isSenderApprovedOrOwner(
1649         address approvedAddress,
1650         address owner,
1651         address msgSender
1652     ) private pure returns (bool result) {
1653         assembly {
1654             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1655             owner := and(owner, _BITMASK_ADDRESS)
1656             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1657             msgSender := and(msgSender, _BITMASK_ADDRESS)
1658             // `msgSender == owner || msgSender == approvedAddress`.
1659             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1660         }
1661     }
1662 
1663     /**
1664      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1665      */
1666     function _getApprovedSlotAndAddress(uint256 tokenId)
1667         private
1668         view
1669         returns (uint256 approvedAddressSlot, address approvedAddress)
1670     {
1671         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1672         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1673         assembly {
1674             approvedAddressSlot := tokenApproval.slot
1675             approvedAddress := sload(approvedAddressSlot)
1676         }
1677     }
1678 
1679     // =============================================================
1680     //                      TRANSFER OPERATIONS
1681     // =============================================================
1682 
1683     /**
1684      * @dev Transfers `tokenId` from `from` to `to`.
1685      *
1686      * Requirements:
1687      *
1688      * - `from` cannot be the zero address.
1689      * - `to` cannot be the zero address.
1690      * - `tokenId` token must be owned by `from`.
1691      * - If the caller is not `from`, it must be approved to move this token
1692      * by either {approve} or {setApprovalForAll}.
1693      *
1694      * Emits a {Transfer} event.
1695      */
1696     function transferFrom(
1697         address from,
1698         address to,
1699         uint256 tokenId
1700     ) public payable virtual override {
1701         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1702 
1703         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1704 
1705         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1706 
1707         // The nested ifs save around 20+ gas over a compound boolean condition.
1708         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1709             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1710 
1711         if (to == address(0)) revert TransferToZeroAddress();
1712 
1713         _beforeTokenTransfers(from, to, tokenId, 1);
1714 
1715         // Clear approvals from the previous owner.
1716         assembly {
1717             if approvedAddress {
1718                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1719                 sstore(approvedAddressSlot, 0)
1720             }
1721         }
1722 
1723         // Underflow of the sender's balance is impossible because we check for
1724         // ownership above and the recipient's balance can't realistically overflow.
1725         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1726         unchecked {
1727             // We can directly increment and decrement the balances.
1728             --_packedAddressData[from]; // Updates: `balance -= 1`.
1729             ++_packedAddressData[to]; // Updates: `balance += 1`.
1730 
1731             // Updates:
1732             // - `address` to the next owner.
1733             // - `startTimestamp` to the timestamp of transfering.
1734             // - `burned` to `false`.
1735             // - `nextInitialized` to `true`.
1736             _packedOwnerships[tokenId] = _packOwnershipData(
1737                 to,
1738                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1739             );
1740 
1741             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1742             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1743                 uint256 nextTokenId = tokenId + 1;
1744                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1745                 if (_packedOwnerships[nextTokenId] == 0) {
1746                     // If the next slot is within bounds.
1747                     if (nextTokenId != _currentIndex) {
1748                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1749                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1750                     }
1751                 }
1752             }
1753         }
1754 
1755         emit Transfer(from, to, tokenId);
1756         _afterTokenTransfers(from, to, tokenId, 1);
1757     }
1758 
1759     /**
1760      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1761      */
1762     function safeTransferFrom(
1763         address from,
1764         address to,
1765         uint256 tokenId
1766     ) public payable virtual override {
1767         safeTransferFrom(from, to, tokenId, '');
1768     }
1769 
1770     /**
1771      * @dev Safely transfers `tokenId` token from `from` to `to`.
1772      *
1773      * Requirements:
1774      *
1775      * - `from` cannot be the zero address.
1776      * - `to` cannot be the zero address.
1777      * - `tokenId` token must exist and be owned by `from`.
1778      * - If the caller is not `from`, it must be approved to move this token
1779      * by either {approve} or {setApprovalForAll}.
1780      * - If `to` refers to a smart contract, it must implement
1781      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1782      *
1783      * Emits a {Transfer} event.
1784      */
1785     function safeTransferFrom(
1786         address from,
1787         address to,
1788         uint256 tokenId,
1789         bytes memory _data
1790     ) public payable virtual override {
1791         transferFrom(from, to, tokenId);
1792         if (to.code.length != 0)
1793             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1794                 revert TransferToNonERC721ReceiverImplementer();
1795             }
1796     }
1797 
1798     /**
1799      * @dev Hook that is called before a set of serially-ordered token IDs
1800      * are about to be transferred. This includes minting.
1801      * And also called before burning one token.
1802      *
1803      * `startTokenId` - the first token ID to be transferred.
1804      * `quantity` - the amount to be transferred.
1805      *
1806      * Calling conditions:
1807      *
1808      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1809      * transferred to `to`.
1810      * - When `from` is zero, `tokenId` will be minted for `to`.
1811      * - When `to` is zero, `tokenId` will be burned by `from`.
1812      * - `from` and `to` are never both zero.
1813      */
1814     function _beforeTokenTransfers(
1815         address from,
1816         address to,
1817         uint256 startTokenId,
1818         uint256 quantity
1819     ) internal virtual {}
1820 
1821     /**
1822      * @dev Hook that is called after a set of serially-ordered token IDs
1823      * have been transferred. This includes minting.
1824      * And also called after one token has been burned.
1825      *
1826      * `startTokenId` - the first token ID to be transferred.
1827      * `quantity` - the amount to be transferred.
1828      *
1829      * Calling conditions:
1830      *
1831      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1832      * transferred to `to`.
1833      * - When `from` is zero, `tokenId` has been minted for `to`.
1834      * - When `to` is zero, `tokenId` has been burned by `from`.
1835      * - `from` and `to` are never both zero.
1836      */
1837     function _afterTokenTransfers(
1838         address from,
1839         address to,
1840         uint256 startTokenId,
1841         uint256 quantity
1842     ) internal virtual {}
1843 
1844     /**
1845      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1846      *
1847      * `from` - Previous owner of the given token ID.
1848      * `to` - Target address that will receive the token.
1849      * `tokenId` - Token ID to be transferred.
1850      * `_data` - Optional data to send along with the call.
1851      *
1852      * Returns whether the call correctly returned the expected magic value.
1853      */
1854     function _checkContractOnERC721Received(
1855         address from,
1856         address to,
1857         uint256 tokenId,
1858         bytes memory _data
1859     ) private returns (bool) {
1860         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1861             bytes4 retval
1862         ) {
1863             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1864         } catch (bytes memory reason) {
1865             if (reason.length == 0) {
1866                 revert TransferToNonERC721ReceiverImplementer();
1867             } else {
1868                 assembly {
1869                     revert(add(32, reason), mload(reason))
1870                 }
1871             }
1872         }
1873     }
1874 
1875     // =============================================================
1876     //                        MINT OPERATIONS
1877     // =============================================================
1878 
1879     /**
1880      * @dev Mints `quantity` tokens and transfers them to `to`.
1881      *
1882      * Requirements:
1883      *
1884      * - `to` cannot be the zero address.
1885      * - `quantity` must be greater than 0.
1886      *
1887      * Emits a {Transfer} event for each mint.
1888      */
1889     function _mint(address to, uint256 quantity) internal virtual {
1890         uint256 startTokenId = _currentIndex;
1891         if (quantity == 0) revert MintZeroQuantity();
1892 
1893         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1894 
1895         // Overflows are incredibly unrealistic.
1896         // `balance` and `numberMinted` have a maximum limit of 2**64.
1897         // `tokenId` has a maximum limit of 2**256.
1898         unchecked {
1899             // Updates:
1900             // - `balance += quantity`.
1901             // - `numberMinted += quantity`.
1902             //
1903             // We can directly add to the `balance` and `numberMinted`.
1904             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1905 
1906             // Updates:
1907             // - `address` to the owner.
1908             // - `startTimestamp` to the timestamp of minting.
1909             // - `burned` to `false`.
1910             // - `nextInitialized` to `quantity == 1`.
1911             _packedOwnerships[startTokenId] = _packOwnershipData(
1912                 to,
1913                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1914             );
1915 
1916             uint256 toMasked;
1917             uint256 end = startTokenId + quantity;
1918 
1919             // Use assembly to loop and emit the `Transfer` event for gas savings.
1920             // The duplicated `log4` removes an extra check and reduces stack juggling.
1921             // The assembly, together with the surrounding Solidity code, have been
1922             // delicately arranged to nudge the compiler into producing optimized opcodes.
1923             assembly {
1924                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1925                 toMasked := and(to, _BITMASK_ADDRESS)
1926                 // Emit the `Transfer` event.
1927                 log4(
1928                     0, // Start of data (0, since no data).
1929                     0, // End of data (0, since no data).
1930                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1931                     0, // `address(0)`.
1932                     toMasked, // `to`.
1933                     startTokenId // `tokenId`.
1934                 )
1935 
1936                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1937                 // that overflows uint256 will make the loop run out of gas.
1938                 // The compiler will optimize the `iszero` away for performance.
1939                 for {
1940                     let tokenId := add(startTokenId, 1)
1941                 } iszero(eq(tokenId, end)) {
1942                     tokenId := add(tokenId, 1)
1943                 } {
1944                     // Emit the `Transfer` event. Similar to above.
1945                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1946                 }
1947             }
1948             if (toMasked == 0) revert MintToZeroAddress();
1949 
1950             _currentIndex = end;
1951         }
1952         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1953     }
1954 
1955     /**
1956      * @dev Mints `quantity` tokens and transfers them to `to`.
1957      *
1958      * This function is intended for efficient minting only during contract creation.
1959      *
1960      * It emits only one {ConsecutiveTransfer} as defined in
1961      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1962      * instead of a sequence of {Transfer} event(s).
1963      *
1964      * Calling this function outside of contract creation WILL make your contract
1965      * non-compliant with the ERC721 standard.
1966      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1967      * {ConsecutiveTransfer} event is only permissible during contract creation.
1968      *
1969      * Requirements:
1970      *
1971      * - `to` cannot be the zero address.
1972      * - `quantity` must be greater than 0.
1973      *
1974      * Emits a {ConsecutiveTransfer} event.
1975      */
1976     function _mintERC2309(address to, uint256 quantity) internal virtual {
1977         uint256 startTokenId = _currentIndex;
1978         if (to == address(0)) revert MintToZeroAddress();
1979         if (quantity == 0) revert MintZeroQuantity();
1980         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1981 
1982         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1983 
1984         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1985         unchecked {
1986             // Updates:
1987             // - `balance += quantity`.
1988             // - `numberMinted += quantity`.
1989             //
1990             // We can directly add to the `balance` and `numberMinted`.
1991             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1992 
1993             // Updates:
1994             // - `address` to the owner.
1995             // - `startTimestamp` to the timestamp of minting.
1996             // - `burned` to `false`.
1997             // - `nextInitialized` to `quantity == 1`.
1998             _packedOwnerships[startTokenId] = _packOwnershipData(
1999                 to,
2000                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2001             );
2002 
2003             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2004 
2005             _currentIndex = startTokenId + quantity;
2006         }
2007         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2008     }
2009 
2010     /**
2011      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2012      *
2013      * Requirements:
2014      *
2015      * - If `to` refers to a smart contract, it must implement
2016      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2017      * - `quantity` must be greater than 0.
2018      *
2019      * See {_mint}.
2020      *
2021      * Emits a {Transfer} event for each mint.
2022      */
2023     function _safeMint(
2024         address to,
2025         uint256 quantity,
2026         bytes memory _data
2027     ) internal virtual {
2028         _mint(to, quantity);
2029 
2030         unchecked {
2031             if (to.code.length != 0) {
2032                 uint256 end = _currentIndex;
2033                 uint256 index = end - quantity;
2034                 do {
2035                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2036                         revert TransferToNonERC721ReceiverImplementer();
2037                     }
2038                 } while (index < end);
2039                 // Reentrancy protection.
2040                 if (_currentIndex != end) revert();
2041             }
2042         }
2043     }
2044 
2045     /**
2046      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2047      */
2048     function _safeMint(address to, uint256 quantity) internal virtual {
2049         _safeMint(to, quantity, '');
2050     }
2051 
2052     // =============================================================
2053     //                        BURN OPERATIONS
2054     // =============================================================
2055 
2056     /**
2057      * @dev Equivalent to `_burn(tokenId, false)`.
2058      */
2059     function _burn(uint256 tokenId) internal virtual {
2060         _burn(tokenId, false);
2061     }
2062 
2063     /**
2064      * @dev Destroys `tokenId`.
2065      * The approval is cleared when the token is burned.
2066      *
2067      * Requirements:
2068      *
2069      * - `tokenId` must exist.
2070      *
2071      * Emits a {Transfer} event.
2072      */
2073     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2074         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2075 
2076         address from = address(uint160(prevOwnershipPacked));
2077 
2078         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2079 
2080         if (approvalCheck) {
2081             // The nested ifs save around 20+ gas over a compound boolean condition.
2082             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2083                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2084         }
2085 
2086         _beforeTokenTransfers(from, address(0), tokenId, 1);
2087 
2088         // Clear approvals from the previous owner.
2089         assembly {
2090             if approvedAddress {
2091                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2092                 sstore(approvedAddressSlot, 0)
2093             }
2094         }
2095 
2096         // Underflow of the sender's balance is impossible because we check for
2097         // ownership above and the recipient's balance can't realistically overflow.
2098         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2099         unchecked {
2100             // Updates:
2101             // - `balance -= 1`.
2102             // - `numberBurned += 1`.
2103             //
2104             // We can directly decrement the balance, and increment the number burned.
2105             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2106             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2107 
2108             // Updates:
2109             // - `address` to the last owner.
2110             // - `startTimestamp` to the timestamp of burning.
2111             // - `burned` to `true`.
2112             // - `nextInitialized` to `true`.
2113             _packedOwnerships[tokenId] = _packOwnershipData(
2114                 from,
2115                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2116             );
2117 
2118             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2119             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2120                 uint256 nextTokenId = tokenId + 1;
2121                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2122                 if (_packedOwnerships[nextTokenId] == 0) {
2123                     // If the next slot is within bounds.
2124                     if (nextTokenId != _currentIndex) {
2125                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2126                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2127                     }
2128                 }
2129             }
2130         }
2131 
2132         emit Transfer(from, address(0), tokenId);
2133         _afterTokenTransfers(from, address(0), tokenId, 1);
2134 
2135         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2136         unchecked {
2137             _burnCounter++;
2138         }
2139     }
2140 
2141     // =============================================================
2142     //                     EXTRA DATA OPERATIONS
2143     // =============================================================
2144 
2145     /**
2146      * @dev Directly sets the extra data for the ownership data `index`.
2147      */
2148     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2149         uint256 packed = _packedOwnerships[index];
2150         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2151         uint256 extraDataCasted;
2152         // Cast `extraData` with assembly to avoid redundant masking.
2153         assembly {
2154             extraDataCasted := extraData
2155         }
2156         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2157         _packedOwnerships[index] = packed;
2158     }
2159 
2160     /**
2161      * @dev Called during each token transfer to set the 24bit `extraData` field.
2162      * Intended to be overridden by the cosumer contract.
2163      *
2164      * `previousExtraData` - the value of `extraData` before transfer.
2165      *
2166      * Calling conditions:
2167      *
2168      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2169      * transferred to `to`.
2170      * - When `from` is zero, `tokenId` will be minted for `to`.
2171      * - When `to` is zero, `tokenId` will be burned by `from`.
2172      * - `from` and `to` are never both zero.
2173      */
2174     function _extraData(
2175         address from,
2176         address to,
2177         uint24 previousExtraData
2178     ) internal view virtual returns (uint24) {}
2179 
2180     /**
2181      * @dev Returns the next extra data for the packed ownership data.
2182      * The returned result is shifted into position.
2183      */
2184     function _nextExtraData(
2185         address from,
2186         address to,
2187         uint256 prevOwnershipPacked
2188     ) private view returns (uint256) {
2189         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2190         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2191     }
2192 
2193     // =============================================================
2194     //                       OTHER OPERATIONS
2195     // =============================================================
2196 
2197     /**
2198      * @dev Returns the message sender (defaults to `msg.sender`).
2199      *
2200      * If you are writing GSN compatible contracts, you need to override this function.
2201      */
2202     function _msgSenderERC721A() internal view virtual returns (address) {
2203         return msg.sender;
2204     }
2205 
2206     /**
2207      * @dev Converts a uint256 to its ASCII string decimal representation.
2208      */
2209     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2210         assembly {
2211             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2212             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2213             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2214             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2215             let m := add(mload(0x40), 0xa0)
2216             // Update the free memory pointer to allocate.
2217             mstore(0x40, m)
2218             // Assign the `str` to the end.
2219             str := sub(m, 0x20)
2220             // Zeroize the slot after the string.
2221             mstore(str, 0)
2222 
2223             // Cache the end of the memory to calculate the length later.
2224             let end := str
2225 
2226             // We write the string from rightmost digit to leftmost digit.
2227             // The following is essentially a do-while loop that also handles the zero case.
2228             // prettier-ignore
2229             for { let temp := value } 1 {} {
2230                 str := sub(str, 1)
2231                 // Write the character to the pointer.
2232                 // The ASCII index of the '0' character is 48.
2233                 mstore8(str, add(48, mod(temp, 10)))
2234                 // Keep dividing `temp` until zero.
2235                 temp := div(temp, 10)
2236                 // prettier-ignore
2237                 if iszero(temp) { break }
2238             }
2239 
2240             let length := sub(end, str)
2241             // Move the pointer 32 bytes leftwards to make room for the length.
2242             str := sub(str, 0x20)
2243             // Store the length.
2244             mstore(str, length)
2245         }
2246     }
2247 }
2248 
2249 // File: Notkamigos.sol
2250 
2251 
2252 pragma solidity >=0.8.9 <0.9.0;
2253 
2254 
2255 
2256 
2257 
2258 
2259 
2260 contract Notkamigos is ERC721A, Ownable, ReentrancyGuard {
2261     using Strings for uint256;
2262     
2263     bool public MintStart = false;
2264     bool public Metadata;
2265 
2266     uint256 public maxPerWallet = 10;
2267     uint256 public maxFree = 2;
2268     uint256 public maxSupply = 10000;
2269     uint256 public publicPrice = 0.002 ether;
2270     
2271     string public _baseURL = "ipfs://QmZkXu27mPMaibcXRxBd77Zd3HTzQ3hK9WW6uUisXeczbw/";
2272     string public prerevealURL = "";
2273 
2274     mapping(address => uint256) private _walletMintedCount;
2275 
2276     constructor() ERC721A("Notkamigos", "NOTKMGS") {}
2277 
2278     function mintedCount(address owner) external view returns (uint256) {
2279         return _walletMintedCount[owner];
2280     }
2281 
2282     function _baseURI() internal view override returns (string memory) {
2283         return _baseURL;
2284     }
2285 
2286     function _startTokenId() internal pure override returns (uint256) {
2287         return 1;
2288     }
2289 
2290     function contractURI() public pure returns (string memory) {
2291         return "";
2292     }
2293 
2294     function finalizeMetadata() external onlyOwner {
2295         Metadata = true;
2296     }
2297 
2298     function reveal(string memory url) external onlyOwner {
2299         require(!Metadata, "Metadata is finalized");
2300         _baseURL = url;
2301     }
2302 
2303     function withdraw(address payable to, uint256 amount) external onlyOwner nonReentrant {
2304     require(address(this).balance >= amount, "Insufficient balance");
2305     require(to != address(0), "Invalid address");
2306     (bool success, ) = to.call{value: amount}("");
2307     require(success, "Transfer failed");
2308 }
2309 
2310     function tokenURI(uint256 tokenId)
2311         public
2312         view
2313         override
2314         returns (string memory)
2315     {
2316         require(
2317             _exists(tokenId),
2318             "ERC721Metadata: URI query for nonexistent token"
2319         );
2320 
2321         return
2322             bytes(_baseURI()).length > 0
2323                 ? string(
2324                     abi.encodePacked(_baseURI(), tokenId.toString(), ".json")
2325                 )
2326                 : prerevealURL;
2327     }
2328 
2329     function setPublicPrice(uint256 _price) external onlyOwner {
2330         publicPrice = _price;
2331     }
2332 
2333     function MintStartStatus() external onlyOwner {
2334         MintStart = !MintStart;
2335     }
2336 
2337     function setMaxSupply(uint256 newMaxSupply) external onlyOwner {
2338         maxSupply = newMaxSupply;
2339     }
2340     function setFree(uint256 newFree) external onlyOwner {
2341         maxFree = newFree;
2342     }
2343     function mint(uint256 count) external payable {
2344         uint256 minted = _walletMintedCount[msg.sender];
2345         require(count > 0, "Must use at least one mint");
2346         require(minted < maxPerWallet, "Max Per wallet");
2347         uint256 payForCount = count;
2348         if (minted < maxFree) {if (maxFree - minted > count) {payForCount = 0;} 
2349         else {payForCount = count - (maxFree - minted);}}
2350         require(MintStart, "Mint has not started");
2351         require(_totalMinted() + count <= maxSupply, "Sold out");
2352         require(msg.value >= payForCount * publicPrice,"Ether value sent is not sufficient");
2353         _walletMintedCount[msg.sender] += count;
2354         _safeMint(msg.sender, count);
2355     }
2356     function devMint(address to, uint256 count) external onlyOwner {
2357         require(_totalMinted() + count <= maxSupply, "Sold out");
2358         _safeMint(to, count);
2359     }
2360 }