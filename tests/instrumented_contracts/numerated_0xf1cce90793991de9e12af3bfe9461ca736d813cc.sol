1 // SPDX-License-Identifier: MIT
2 // https://piranha.finance/#/
3 // https://t.me/Piranhaerc
4 // https://twitter.com/Piranhaerc
5 // File: @openzeppelin/contracts/utils/math/Math.sol
6 
7 
8 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
9 
10 pragma solidity ^0.8.0;
11 
12 /**
13  * @dev Standard math utilities missing in the Solidity language.
14  */
15 library Math {
16     enum Rounding {
17         Down, // Toward negative infinity
18         Up, // Toward infinity
19         Zero // Toward zero
20     }
21 
22     /**
23      * @dev Returns the largest of two numbers.
24      */
25     function max(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a > b ? a : b;
27     }
28 
29     /**
30      * @dev Returns the smallest of two numbers.
31      */
32     function min(uint256 a, uint256 b) internal pure returns (uint256) {
33         return a < b ? a : b;
34     }
35 
36     /**
37      * @dev Returns the average of two numbers. The result is rounded towards
38      * zero.
39      */
40     function average(uint256 a, uint256 b) internal pure returns (uint256) {
41         // (a + b) / 2 can overflow.
42         return (a & b) + (a ^ b) / 2;
43     }
44 
45     /**
46      * @dev Returns the ceiling of the division of two numbers.
47      *
48      * This differs from standard division with `/` in that it rounds up instead
49      * of rounding down.
50      */
51     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
52         // (a + b - 1) / b can overflow on addition, so we distribute.
53         return a == 0 ? 0 : (a - 1) / b + 1;
54     }
55 
56     /**
57      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
58      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
59      * with further edits by Uniswap Labs also under MIT license.
60      */
61     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
77                 // The surrounding unchecked block does not change this fact.
78                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
79                 return prod0 / denominator;
80             }
81 
82             // Make sure the result is less than 2^256. Also prevents denominator == 0.
83             require(denominator > prod1, "Math: mulDiv overflow");
84 
85             ///////////////////////////////////////////////
86             // 512 by 256 division.
87             ///////////////////////////////////////////////
88 
89             // Make division exact by subtracting the remainder from [prod1 prod0].
90             uint256 remainder;
91             assembly {
92                 // Compute remainder using mulmod.
93                 remainder := mulmod(x, y, denominator)
94 
95                 // Subtract 256 bit number from 512 bit number.
96                 prod1 := sub(prod1, gt(remainder, prod0))
97                 prod0 := sub(prod0, remainder)
98             }
99 
100             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
101             // See https://cs.stackexchange.com/q/138556/92363.
102 
103             // Does not overflow because the denominator cannot be zero at this stage in the function.
104             uint256 twos = denominator & (~denominator + 1);
105             assembly {
106                 // Divide denominator by twos.
107                 denominator := div(denominator, twos)
108 
109                 // Divide [prod1 prod0] by twos.
110                 prod0 := div(prod0, twos)
111 
112                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
113                 twos := add(div(sub(0, twos), twos), 1)
114             }
115 
116             // Shift in bits from prod1 into prod0.
117             prod0 |= prod1 * twos;
118 
119             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
120             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
121             // four bits. That is, denominator * inv = 1 mod 2^4.
122             uint256 inverse = (3 * denominator) ^ 2;
123 
124             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
125             // in modular arithmetic, doubling the correct bits in each step.
126             inverse *= 2 - denominator * inverse; // inverse mod 2^8
127             inverse *= 2 - denominator * inverse; // inverse mod 2^16
128             inverse *= 2 - denominator * inverse; // inverse mod 2^32
129             inverse *= 2 - denominator * inverse; // inverse mod 2^64
130             inverse *= 2 - denominator * inverse; // inverse mod 2^128
131             inverse *= 2 - denominator * inverse; // inverse mod 2^256
132 
133             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
134             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
135             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
136             // is no longer required.
137             result = prod0 * inverse;
138             return result;
139         }
140     }
141 
142     /**
143      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
144      */
145     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
146         uint256 result = mulDiv(x, y, denominator);
147         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
148             result += 1;
149         }
150         return result;
151     }
152 
153     /**
154      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
155      *
156      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
157      */
158     function sqrt(uint256 a) internal pure returns (uint256) {
159         if (a == 0) {
160             return 0;
161         }
162 
163         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
164         //
165         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
166         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
167         //
168         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
169         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
170         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
171         //
172         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
173         uint256 result = 1 << (log2(a) >> 1);
174 
175         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
176         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
177         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
178         // into the expected uint128 result.
179         unchecked {
180             result = (result + a / result) >> 1;
181             result = (result + a / result) >> 1;
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             return min(result, a / result);
188         }
189     }
190 
191     /**
192      * @notice Calculates sqrt(a), following the selected rounding direction.
193      */
194     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
195         unchecked {
196             uint256 result = sqrt(a);
197             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
198         }
199     }
200 
201     /**
202      * @dev Return the log in base 2, rounded down, of a positive value.
203      * Returns 0 if given 0.
204      */
205     function log2(uint256 value) internal pure returns (uint256) {
206         uint256 result = 0;
207         unchecked {
208             if (value >> 128 > 0) {
209                 value >>= 128;
210                 result += 128;
211             }
212             if (value >> 64 > 0) {
213                 value >>= 64;
214                 result += 64;
215             }
216             if (value >> 32 > 0) {
217                 value >>= 32;
218                 result += 32;
219             }
220             if (value >> 16 > 0) {
221                 value >>= 16;
222                 result += 16;
223             }
224             if (value >> 8 > 0) {
225                 value >>= 8;
226                 result += 8;
227             }
228             if (value >> 4 > 0) {
229                 value >>= 4;
230                 result += 4;
231             }
232             if (value >> 2 > 0) {
233                 value >>= 2;
234                 result += 2;
235             }
236             if (value >> 1 > 0) {
237                 result += 1;
238             }
239         }
240         return result;
241     }
242 
243     /**
244      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
245      * Returns 0 if given 0.
246      */
247     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
248         unchecked {
249             uint256 result = log2(value);
250             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
251         }
252     }
253 
254     /**
255      * @dev Return the log in base 10, rounded down, of a positive value.
256      * Returns 0 if given 0.
257      */
258     function log10(uint256 value) internal pure returns (uint256) {
259         uint256 result = 0;
260         unchecked {
261             if (value >= 10 ** 64) {
262                 value /= 10 ** 64;
263                 result += 64;
264             }
265             if (value >= 10 ** 32) {
266                 value /= 10 ** 32;
267                 result += 32;
268             }
269             if (value >= 10 ** 16) {
270                 value /= 10 ** 16;
271                 result += 16;
272             }
273             if (value >= 10 ** 8) {
274                 value /= 10 ** 8;
275                 result += 8;
276             }
277             if (value >= 10 ** 4) {
278                 value /= 10 ** 4;
279                 result += 4;
280             }
281             if (value >= 10 ** 2) {
282                 value /= 10 ** 2;
283                 result += 2;
284             }
285             if (value >= 10 ** 1) {
286                 result += 1;
287             }
288         }
289         return result;
290     }
291 
292     /**
293      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
294      * Returns 0 if given 0.
295      */
296     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
297         unchecked {
298             uint256 result = log10(value);
299             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
300         }
301     }
302 
303     /**
304      * @dev Return the log in base 256, rounded down, of a positive value.
305      * Returns 0 if given 0.
306      *
307      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
308      */
309     function log256(uint256 value) internal pure returns (uint256) {
310         uint256 result = 0;
311         unchecked {
312             if (value >> 128 > 0) {
313                 value >>= 128;
314                 result += 16;
315             }
316             if (value >> 64 > 0) {
317                 value >>= 64;
318                 result += 8;
319             }
320             if (value >> 32 > 0) {
321                 value >>= 32;
322                 result += 4;
323             }
324             if (value >> 16 > 0) {
325                 value >>= 16;
326                 result += 2;
327             }
328             if (value >> 8 > 0) {
329                 result += 1;
330             }
331         }
332         return result;
333     }
334 
335     /**
336      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
337      * Returns 0 if given 0.
338      */
339     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
340         unchecked {
341             uint256 result = log256(value);
342             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
343         }
344     }
345 }
346 
347 // File: @openzeppelin/contracts/utils/Address.sol
348 
349 
350 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
351 
352 pragma solidity ^0.8.1;
353 
354 /**
355  * @dev Collection of functions related to the address type
356  */
357 library Address {
358     /**
359      * @dev Returns true if `account` is a contract.
360      *
361      * [IMPORTANT]
362      * ====
363      * It is unsafe to assume that an address for which this function returns
364      * false is an externally-owned account (EOA) and not a contract.
365      *
366      * Among others, `isContract` will return false for the following
367      * types of addresses:
368      *
369      *  - an externally-owned account
370      *  - a contract in construction
371      *  - an address where a contract will be created
372      *  - an address where a contract lived, but was destroyed
373      *
374      * Furthermore, `isContract` will also return true if the target contract within
375      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
376      * which only has an effect at the end of a transaction.
377      * ====
378      *
379      * [IMPORTANT]
380      * ====
381      * You shouldn't rely on `isContract` to protect against flash loan attacks!
382      *
383      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
384      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
385      * constructor.
386      * ====
387      */
388     function isContract(address account) internal view returns (bool) {
389         // This method relies on extcodesize/address.code.length, which returns 0
390         // for contracts in construction, since the code is only stored at the end
391         // of the constructor execution.
392 
393         return account.code.length > 0;
394     }
395 
396     /**
397      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
398      * `recipient`, forwarding all available gas and reverting on errors.
399      *
400      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
401      * of certain opcodes, possibly making contracts go over the 2300 gas limit
402      * imposed by `transfer`, making them unable to receive funds via
403      * `transfer`. {sendValue} removes this limitation.
404      *
405      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
406      *
407      * IMPORTANT: because control is transferred to `recipient`, care must be
408      * taken to not create reentrancy vulnerabilities. Consider using
409      * {ReentrancyGuard} or the
410      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
411      */
412     function sendValue(address payable recipient, uint256 amount) internal {
413         require(address(this).balance >= amount, "Address: insufficient balance");
414 
415         (bool success, ) = recipient.call{value: amount}("");
416         require(success, "Address: unable to send value, recipient may have reverted");
417     }
418 
419     /**
420      * @dev Performs a Solidity function call using a low level `call`. A
421      * plain `call` is an unsafe replacement for a function call: use this
422      * function instead.
423      *
424      * If `target` reverts with a revert reason, it is bubbled up by this
425      * function (like regular Solidity function calls).
426      *
427      * Returns the raw returned data. To convert to the expected return value,
428      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
429      *
430      * Requirements:
431      *
432      * - `target` must be a contract.
433      * - calling `target` with `data` must not revert.
434      *
435      * _Available since v3.1._
436      */
437     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
443      * `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCall(
448         address target,
449         bytes memory data,
450         string memory errorMessage
451     ) internal returns (bytes memory) {
452         return functionCallWithValue(target, data, 0, errorMessage);
453     }
454 
455     /**
456      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
457      * but also transferring `value` wei to `target`.
458      *
459      * Requirements:
460      *
461      * - the calling contract must have an ETH balance of at least `value`.
462      * - the called Solidity function must be `payable`.
463      *
464      * _Available since v3.1._
465      */
466     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
467         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
468     }
469 
470     /**
471      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
472      * with `errorMessage` as a fallback revert reason when `target` reverts.
473      *
474      * _Available since v3.1._
475      */
476     function functionCallWithValue(
477         address target,
478         bytes memory data,
479         uint256 value,
480         string memory errorMessage
481     ) internal returns (bytes memory) {
482         require(address(this).balance >= value, "Address: insufficient balance for call");
483         (bool success, bytes memory returndata) = target.call{value: value}(data);
484         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
485     }
486 
487     /**
488      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
489      * but performing a static call.
490      *
491      * _Available since v3.3._
492      */
493     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
494         return functionStaticCall(target, data, "Address: low-level static call failed");
495     }
496 
497     /**
498      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
499      * but performing a static call.
500      *
501      * _Available since v3.3._
502      */
503     function functionStaticCall(
504         address target,
505         bytes memory data,
506         string memory errorMessage
507     ) internal view returns (bytes memory) {
508         (bool success, bytes memory returndata) = target.staticcall(data);
509         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but performing a delegate call.
515      *
516      * _Available since v3.4._
517      */
518     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
519         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
520     }
521 
522     /**
523      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
524      * but performing a delegate call.
525      *
526      * _Available since v3.4._
527      */
528     function functionDelegateCall(
529         address target,
530         bytes memory data,
531         string memory errorMessage
532     ) internal returns (bytes memory) {
533         (bool success, bytes memory returndata) = target.delegatecall(data);
534         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
535     }
536 
537     /**
538      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
539      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
540      *
541      * _Available since v4.8._
542      */
543     function verifyCallResultFromTarget(
544         address target,
545         bool success,
546         bytes memory returndata,
547         string memory errorMessage
548     ) internal view returns (bytes memory) {
549         if (success) {
550             if (returndata.length == 0) {
551                 // only check isContract if the call was successful and the return data is empty
552                 // otherwise we already know that it was a contract
553                 require(isContract(target), "Address: call to non-contract");
554             }
555             return returndata;
556         } else {
557             _revert(returndata, errorMessage);
558         }
559     }
560 
561     /**
562      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
563      * revert reason or using the provided one.
564      *
565      * _Available since v4.3._
566      */
567     function verifyCallResult(
568         bool success,
569         bytes memory returndata,
570         string memory errorMessage
571     ) internal pure returns (bytes memory) {
572         if (success) {
573             return returndata;
574         } else {
575             _revert(returndata, errorMessage);
576         }
577     }
578 
579     function _revert(bytes memory returndata, string memory errorMessage) private pure {
580         // Look for revert reason and bubble it up if present
581         if (returndata.length > 0) {
582             // The easiest way to bubble the revert reason is using memory via assembly
583             /// @solidity memory-safe-assembly
584             assembly {
585                 let returndata_size := mload(returndata)
586                 revert(add(32, returndata), returndata_size)
587             }
588         } else {
589             revert(errorMessage);
590         }
591     }
592 }
593 
594 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
595 
596 
597 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
598 
599 pragma solidity ^0.8.0;
600 
601 // CAUTION
602 // This version of SafeMath should only be used with Solidity 0.8 or later,
603 // because it relies on the compiler's built in overflow checks.
604 
605 /**
606  * @dev Wrappers over Solidity's arithmetic operations.
607  *
608  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
609  * now has built in overflow checking.
610  */
611 library SafeMath {
612     /**
613      * @dev Returns the addition of two unsigned integers, with an overflow flag.
614      *
615      * _Available since v3.4._
616      */
617     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
618         unchecked {
619             uint256 c = a + b;
620             if (c < a) return (false, 0);
621             return (true, c);
622         }
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
627      *
628      * _Available since v3.4._
629      */
630     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
631         unchecked {
632             if (b > a) return (false, 0);
633             return (true, a - b);
634         }
635     }
636 
637     /**
638      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
639      *
640      * _Available since v3.4._
641      */
642     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
643         unchecked {
644             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
645             // benefit is lost if 'b' is also tested.
646             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
647             if (a == 0) return (true, 0);
648             uint256 c = a * b;
649             if (c / a != b) return (false, 0);
650             return (true, c);
651         }
652     }
653 
654     /**
655      * @dev Returns the division of two unsigned integers, with a division by zero flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
660         unchecked {
661             if (b == 0) return (false, 0);
662             return (true, a / b);
663         }
664     }
665 
666     /**
667      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
668      *
669      * _Available since v3.4._
670      */
671     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
672         unchecked {
673             if (b == 0) return (false, 0);
674             return (true, a % b);
675         }
676     }
677 
678     /**
679      * @dev Returns the addition of two unsigned integers, reverting on
680      * overflow.
681      *
682      * Counterpart to Solidity's `+` operator.
683      *
684      * Requirements:
685      *
686      * - Addition cannot overflow.
687      */
688     function add(uint256 a, uint256 b) internal pure returns (uint256) {
689         return a + b;
690     }
691 
692     /**
693      * @dev Returns the subtraction of two unsigned integers, reverting on
694      * overflow (when the result is negative).
695      *
696      * Counterpart to Solidity's `-` operator.
697      *
698      * Requirements:
699      *
700      * - Subtraction cannot overflow.
701      */
702     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a - b;
704     }
705 
706     /**
707      * @dev Returns the multiplication of two unsigned integers, reverting on
708      * overflow.
709      *
710      * Counterpart to Solidity's `*` operator.
711      *
712      * Requirements:
713      *
714      * - Multiplication cannot overflow.
715      */
716     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
717         return a * b;
718     }
719 
720     /**
721      * @dev Returns the integer division of two unsigned integers, reverting on
722      * division by zero. The result is rounded towards zero.
723      *
724      * Counterpart to Solidity's `/` operator.
725      *
726      * Requirements:
727      *
728      * - The divisor cannot be zero.
729      */
730     function div(uint256 a, uint256 b) internal pure returns (uint256) {
731         return a / b;
732     }
733 
734     /**
735      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
736      * reverting when dividing by zero.
737      *
738      * Counterpart to Solidity's `%` operator. This function uses a `revert`
739      * opcode (which leaves remaining gas untouched) while Solidity uses an
740      * invalid opcode to revert (consuming all remaining gas).
741      *
742      * Requirements:
743      *
744      * - The divisor cannot be zero.
745      */
746     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
747         return a % b;
748     }
749 
750     /**
751      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
752      * overflow (when the result is negative).
753      *
754      * CAUTION: This function is deprecated because it requires allocating memory for the error
755      * message unnecessarily. For custom revert reasons use {trySub}.
756      *
757      * Counterpart to Solidity's `-` operator.
758      *
759      * Requirements:
760      *
761      * - Subtraction cannot overflow.
762      */
763     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
764         unchecked {
765             require(b <= a, errorMessage);
766             return a - b;
767         }
768     }
769 
770     /**
771      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
772      * division by zero. The result is rounded towards zero.
773      *
774      * Counterpart to Solidity's `/` operator. Note: this function uses a
775      * `revert` opcode (which leaves remaining gas untouched) while Solidity
776      * uses an invalid opcode to revert (consuming all remaining gas).
777      *
778      * Requirements:
779      *
780      * - The divisor cannot be zero.
781      */
782     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
783         unchecked {
784             require(b > 0, errorMessage);
785             return a / b;
786         }
787     }
788 
789     /**
790      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
791      * reverting with custom message when dividing by zero.
792      *
793      * CAUTION: This function is deprecated because it requires allocating memory for the error
794      * message unnecessarily. For custom revert reasons use {tryMod}.
795      *
796      * Counterpart to Solidity's `%` operator. This function uses a `revert`
797      * opcode (which leaves remaining gas untouched) while Solidity uses an
798      * invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      *
802      * - The divisor cannot be zero.
803      */
804     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
805         unchecked {
806             require(b > 0, errorMessage);
807             return a % b;
808         }
809     }
810 }
811 
812 // File: @openzeppelin/contracts/utils/Context.sol
813 
814 
815 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
816 
817 pragma solidity ^0.8.0;
818 
819 /**
820  * @dev Provides information about the current execution context, including the
821  * sender of the transaction and its data. While these are generally available
822  * via msg.sender and msg.data, they should not be accessed in such a direct
823  * manner, since when dealing with meta-transactions the account sending and
824  * paying for execution may not be the actual sender (as far as an application
825  * is concerned).
826  *
827  * This contract is only required for intermediate, library-like contracts.
828  */
829 abstract contract Context {
830     function _msgSender() internal view virtual returns (address) {
831         return msg.sender;
832     }
833 
834     function _msgData() internal view virtual returns (bytes calldata) {
835         return msg.data;
836     }
837 }
838 
839 // File: @openzeppelin/contracts/access/Ownable.sol
840 
841 
842 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
843 
844 pragma solidity ^0.8.0;
845 
846 
847 /**
848  * @dev Contract module which provides a basic access control mechanism, where
849  * there is an account (an owner) that can be granted exclusive access to
850  * specific functions.
851  *
852  * By default, the owner account will be the one that deploys the contract. This
853  * can later be changed with {transferOwnership}.
854  *
855  * This module is used through inheritance. It will make available the modifier
856  * `onlyOwner`, which can be applied to your functions to restrict their use to
857  * the owner.
858  */
859 abstract contract Ownable is Context {
860     address private _owner;
861 
862     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
863 
864     /**
865      * @dev Initializes the contract setting the deployer as the initial owner.
866      */
867     constructor() {
868         _transferOwnership(_msgSender());
869     }
870 
871     /**
872      * @dev Throws if called by any account other than the owner.
873      */
874     modifier onlyOwner() {
875         _checkOwner();
876         _;
877     }
878 
879     /**
880      * @dev Returns the address of the current owner.
881      */
882     function owner() public view virtual returns (address) {
883         return _owner;
884     }
885 
886     /**
887      * @dev Throws if the sender is not the owner.
888      */
889     function _checkOwner() internal view virtual {
890         require(owner() == _msgSender(), "Ownable: caller is not the owner");
891     }
892 
893     /**
894      * @dev Leaves the contract without owner. It will not be possible to call
895      * `onlyOwner` functions. Can only be called by the current owner.
896      *
897      * NOTE: Renouncing ownership will leave the contract without an owner,
898      * thereby disabling any functionality that is only available to the owner.
899      */
900     function renounceOwnership() public virtual onlyOwner {
901         _transferOwnership(address(0));
902     }
903 
904     /**
905      * @dev Transfers ownership of the contract to a new account (`newOwner`).
906      * Can only be called by the current owner.
907      */
908     function transferOwnership(address newOwner) public virtual onlyOwner {
909         require(newOwner != address(0), "Ownable: new owner is the zero address");
910         _transferOwnership(newOwner);
911     }
912 
913     /**
914      * @dev Transfers ownership of the contract to a new account (`newOwner`).
915      * Internal function without access restriction.
916      */
917     function _transferOwnership(address newOwner) internal virtual {
918         address oldOwner = _owner;
919         _owner = newOwner;
920         emit OwnershipTransferred(oldOwner, newOwner);
921     }
922 }
923 
924 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
925 
926 
927 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
928 
929 pragma solidity ^0.8.0;
930 
931 /**
932  * @dev Interface of the ERC20 standard as defined in the EIP.
933  */
934 interface IERC20 {
935     /**
936      * @dev Emitted when `value` tokens are moved from one account (`from`) to
937      * another (`to`).
938      *
939      * Note that `value` may be zero.
940      */
941     event Transfer(address indexed from, address indexed to, uint256 value);
942 
943     /**
944      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
945      * a call to {approve}. `value` is the new allowance.
946      */
947     event Approval(address indexed owner, address indexed spender, uint256 value);
948 
949     /**
950      * @dev Returns the amount of tokens in existence.
951      */
952     function totalSupply() external view returns (uint256);
953 
954     /**
955      * @dev Returns the amount of tokens owned by `account`.
956      */
957     function balanceOf(address account) external view returns (uint256);
958 
959     /**
960      * @dev Moves `amount` tokens from the caller's account to `to`.
961      *
962      * Returns a boolean value indicating whether the operation succeeded.
963      *
964      * Emits a {Transfer} event.
965      */
966     function transfer(address to, uint256 amount) external returns (bool);
967 
968     /**
969      * @dev Returns the remaining number of tokens that `spender` will be
970      * allowed to spend on behalf of `owner` through {transferFrom}. This is
971      * zero by default.
972      *
973      * This value changes when {approve} or {transferFrom} are called.
974      */
975     function allowance(address owner, address spender) external view returns (uint256);
976 
977     /**
978      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
979      *
980      * Returns a boolean value indicating whether the operation succeeded.
981      *
982      * IMPORTANT: Beware that changing an allowance with this method brings the risk
983      * that someone may use both the old and the new allowance by unfortunate
984      * transaction ordering. One possible solution to mitigate this race
985      * condition is to first reduce the spender's allowance to 0 and set the
986      * desired value afterwards:
987      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
988      *
989      * Emits an {Approval} event.
990      */
991     function approve(address spender, uint256 amount) external returns (bool);
992 
993     /**
994      * @dev Moves `amount` tokens from `from` to `to` using the
995      * allowance mechanism. `amount` is then deducted from the caller's
996      * allowance.
997      *
998      * Returns a boolean value indicating whether the operation succeeded.
999      *
1000      * Emits a {Transfer} event.
1001      */
1002     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1003 }
1004 
1005 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 
1013 /**
1014  * @dev Interface for the optional metadata functions from the ERC20 standard.
1015  *
1016  * _Available since v4.1._
1017  */
1018 interface IERC20Metadata is IERC20 {
1019     /**
1020      * @dev Returns the name of the token.
1021      */
1022     function name() external view returns (string memory);
1023 
1024     /**
1025      * @dev Returns the symbol of the token.
1026      */
1027     function symbol() external view returns (string memory);
1028 
1029     /**
1030      * @dev Returns the decimals places of the token.
1031      */
1032     function decimals() external view returns (uint8);
1033 }
1034 
1035 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1036 
1037 
1038 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 
1043 
1044 
1045 /**
1046  * @dev Implementation of the {IERC20} interface.
1047  *
1048  * This implementation is agnostic to the way tokens are created. This means
1049  * that a supply mechanism has to be added in a derived contract using {_mint}.
1050  * For a generic mechanism see {ERC20PresetMinterPauser}.
1051  *
1052  * TIP: For a detailed writeup see our guide
1053  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1054  * to implement supply mechanisms].
1055  *
1056  * The default value of {decimals} is 18. To change this, you should override
1057  * this function so it returns a different value.
1058  *
1059  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1060  * instead returning `false` on failure. This behavior is nonetheless
1061  * conventional and does not conflict with the expectations of ERC20
1062  * applications.
1063  *
1064  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1065  * This allows applications to reconstruct the allowance for all accounts just
1066  * by listening to said events. Other implementations of the EIP may not emit
1067  * these events, as it isn't required by the specification.
1068  *
1069  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1070  * functions have been added to mitigate the well-known issues around setting
1071  * allowances. See {IERC20-approve}.
1072  */
1073 contract ERC20 is Context, IERC20, IERC20Metadata {
1074     mapping(address => uint256) private _balances;
1075 
1076     mapping(address => mapping(address => uint256)) private _allowances;
1077 
1078     uint256 private _totalSupply;
1079 
1080     string private _name;
1081     string private _symbol;
1082 
1083     /**
1084      * @dev Sets the values for {name} and {symbol}.
1085      *
1086      * All two of these values are immutable: they can only be set once during
1087      * construction.
1088      */
1089     constructor(string memory name_, string memory symbol_) {
1090         _name = name_;
1091         _symbol = symbol_;
1092     }
1093 
1094     /**
1095      * @dev Returns the name of the token.
1096      */
1097     function name() public view virtual override returns (string memory) {
1098         return _name;
1099     }
1100 
1101     /**
1102      * @dev Returns the symbol of the token, usually a shorter version of the
1103      * name.
1104      */
1105     function symbol() public view virtual override returns (string memory) {
1106         return _symbol;
1107     }
1108 
1109     /**
1110      * @dev Returns the number of decimals used to get its user representation.
1111      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1112      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1113      *
1114      * Tokens usually opt for a value of 18, imitating the relationship between
1115      * Ether and Wei. This is the default value returned by this function, unless
1116      * it's overridden.
1117      *
1118      * NOTE: This information is only used for _display_ purposes: it in
1119      * no way affects any of the arithmetic of the contract, including
1120      * {IERC20-balanceOf} and {IERC20-transfer}.
1121      */
1122     function decimals() public view virtual override returns (uint8) {
1123         return 18;
1124     }
1125 
1126     /**
1127      * @dev See {IERC20-totalSupply}.
1128      */
1129     function totalSupply() public view virtual override returns (uint256) {
1130         return _totalSupply;
1131     }
1132 
1133     /**
1134      * @dev See {IERC20-balanceOf}.
1135      */
1136     function balanceOf(address account) public view virtual override returns (uint256) {
1137         return _balances[account];
1138     }
1139 
1140     /**
1141      * @dev See {IERC20-transfer}.
1142      *
1143      * Requirements:
1144      *
1145      * - `to` cannot be the zero address.
1146      * - the caller must have a balance of at least `amount`.
1147      */
1148     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1149         address owner = _msgSender();
1150         _transfer(owner, to, amount);
1151         return true;
1152     }
1153 
1154     /**
1155      * @dev See {IERC20-allowance}.
1156      */
1157     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1158         return _allowances[owner][spender];
1159     }
1160 
1161     /**
1162      * @dev See {IERC20-approve}.
1163      *
1164      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1165      * `transferFrom`. This is semantically equivalent to an infinite approval.
1166      *
1167      * Requirements:
1168      *
1169      * - `spender` cannot be the zero address.
1170      */
1171     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1172         address owner = _msgSender();
1173         _approve(owner, spender, amount);
1174         return true;
1175     }
1176 
1177     /**
1178      * @dev See {IERC20-transferFrom}.
1179      *
1180      * Emits an {Approval} event indicating the updated allowance. This is not
1181      * required by the EIP. See the note at the beginning of {ERC20}.
1182      *
1183      * NOTE: Does not update the allowance if the current allowance
1184      * is the maximum `uint256`.
1185      *
1186      * Requirements:
1187      *
1188      * - `from` and `to` cannot be the zero address.
1189      * - `from` must have a balance of at least `amount`.
1190      * - the caller must have allowance for ``from``'s tokens of at least
1191      * `amount`.
1192      */
1193     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1194         address spender = _msgSender();
1195         _spendAllowance(from, spender, amount);
1196         _transfer(from, to, amount);
1197         return true;
1198     }
1199 
1200     /**
1201      * @dev Atomically increases the allowance granted to `spender` by the caller.
1202      *
1203      * This is an alternative to {approve} that can be used as a mitigation for
1204      * problems described in {IERC20-approve}.
1205      *
1206      * Emits an {Approval} event indicating the updated allowance.
1207      *
1208      * Requirements:
1209      *
1210      * - `spender` cannot be the zero address.
1211      */
1212     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1213         address owner = _msgSender();
1214         _approve(owner, spender, allowance(owner, spender) + addedValue);
1215         return true;
1216     }
1217 
1218     /**
1219      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1220      *
1221      * This is an alternative to {approve} that can be used as a mitigation for
1222      * problems described in {IERC20-approve}.
1223      *
1224      * Emits an {Approval} event indicating the updated allowance.
1225      *
1226      * Requirements:
1227      *
1228      * - `spender` cannot be the zero address.
1229      * - `spender` must have allowance for the caller of at least
1230      * `subtractedValue`.
1231      */
1232     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1233         address owner = _msgSender();
1234         uint256 currentAllowance = allowance(owner, spender);
1235         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1236         unchecked {
1237             _approve(owner, spender, currentAllowance - subtractedValue);
1238         }
1239 
1240         return true;
1241     }
1242 
1243     /**
1244      * @dev Moves `amount` of tokens from `from` to `to`.
1245      *
1246      * This internal function is equivalent to {transfer}, and can be used to
1247      * e.g. implement automatic token fees, slashing mechanisms, etc.
1248      *
1249      * Emits a {Transfer} event.
1250      *
1251      * Requirements:
1252      *
1253      * - `from` cannot be the zero address.
1254      * - `to` cannot be the zero address.
1255      * - `from` must have a balance of at least `amount`.
1256      */
1257     function _transfer(address from, address to, uint256 amount) internal virtual {
1258         require(from != address(0), "ERC20: transfer from the zero address");
1259         require(to != address(0), "ERC20: transfer to the zero address");
1260 
1261         _beforeTokenTransfer(from, to, amount);
1262 
1263         uint256 fromBalance = _balances[from];
1264         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1265         unchecked {
1266             _balances[from] = fromBalance - amount;
1267             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1268             // decrementing then incrementing.
1269             _balances[to] += amount;
1270         }
1271 
1272         emit Transfer(from, to, amount);
1273 
1274         _afterTokenTransfer(from, to, amount);
1275     }
1276 
1277     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1278      * the total supply.
1279      *
1280      * Emits a {Transfer} event with `from` set to the zero address.
1281      *
1282      * Requirements:
1283      *
1284      * - `account` cannot be the zero address.
1285      */
1286     function _mint(address account, uint256 amount) internal virtual {
1287         require(account != address(0), "ERC20: mint to the zero address");
1288 
1289         _beforeTokenTransfer(address(0), account, amount);
1290 
1291         _totalSupply += amount;
1292         unchecked {
1293             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1294             _balances[account] += amount;
1295         }
1296         emit Transfer(address(0), account, amount);
1297 
1298         _afterTokenTransfer(address(0), account, amount);
1299     }
1300 
1301     /**
1302      * @dev Destroys `amount` tokens from `account`, reducing the
1303      * total supply.
1304      *
1305      * Emits a {Transfer} event with `to` set to the zero address.
1306      *
1307      * Requirements:
1308      *
1309      * - `account` cannot be the zero address.
1310      * - `account` must have at least `amount` tokens.
1311      */
1312     function _burn(address account, uint256 amount) internal virtual {
1313         require(account != address(0), "ERC20: burn from the zero address");
1314 
1315         _beforeTokenTransfer(account, address(0), amount);
1316 
1317         uint256 accountBalance = _balances[account];
1318         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1319         unchecked {
1320             _balances[account] = accountBalance - amount;
1321             // Overflow not possible: amount <= accountBalance <= totalSupply.
1322             _totalSupply -= amount;
1323         }
1324 
1325         emit Transfer(account, address(0), amount);
1326 
1327         _afterTokenTransfer(account, address(0), amount);
1328     }
1329 
1330     /**
1331      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1332      *
1333      * This internal function is equivalent to `approve`, and can be used to
1334      * e.g. set automatic allowances for certain subsystems, etc.
1335      *
1336      * Emits an {Approval} event.
1337      *
1338      * Requirements:
1339      *
1340      * - `owner` cannot be the zero address.
1341      * - `spender` cannot be the zero address.
1342      */
1343     function _approve(address owner, address spender, uint256 amount) internal virtual {
1344         require(owner != address(0), "ERC20: approve from the zero address");
1345         require(spender != address(0), "ERC20: approve to the zero address");
1346 
1347         _allowances[owner][spender] = amount;
1348         emit Approval(owner, spender, amount);
1349     }
1350 
1351     /**
1352      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1353      *
1354      * Does not update the allowance amount in case of infinite allowance.
1355      * Revert if not enough allowance is available.
1356      *
1357      * Might emit an {Approval} event.
1358      */
1359     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1360         uint256 currentAllowance = allowance(owner, spender);
1361         if (currentAllowance != type(uint256).max) {
1362             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1363             unchecked {
1364                 _approve(owner, spender, currentAllowance - amount);
1365             }
1366         }
1367     }
1368 
1369     /**
1370      * @dev Hook that is called before any transfer of tokens. This includes
1371      * minting and burning.
1372      *
1373      * Calling conditions:
1374      *
1375      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1376      * will be transferred to `to`.
1377      * - when `from` is zero, `amount` tokens will be minted for `to`.
1378      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1379      * - `from` and `to` are never both zero.
1380      *
1381      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1382      */
1383     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1384 
1385     /**
1386      * @dev Hook that is called after any transfer of tokens. This includes
1387      * minting and burning.
1388      *
1389      * Calling conditions:
1390      *
1391      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1392      * has been transferred to `to`.
1393      * - when `from` is zero, `amount` tokens have been minted for `to`.
1394      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1395      * - `from` and `to` are never both zero.
1396      *
1397      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1398      */
1399     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1400 }
1401 
1402 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
1403 
1404 pragma solidity >=0.6.2;
1405 
1406 interface IUniswapV2Router01 {
1407     function factory() external pure returns (address);
1408     function WETH() external pure returns (address);
1409 
1410     function addLiquidity(
1411         address tokenA,
1412         address tokenB,
1413         uint amountADesired,
1414         uint amountBDesired,
1415         uint amountAMin,
1416         uint amountBMin,
1417         address to,
1418         uint deadline
1419     ) external returns (uint amountA, uint amountB, uint liquidity);
1420     function addLiquidityETH(
1421         address token,
1422         uint amountTokenDesired,
1423         uint amountTokenMin,
1424         uint amountETHMin,
1425         address to,
1426         uint deadline
1427     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1428     function removeLiquidity(
1429         address tokenA,
1430         address tokenB,
1431         uint liquidity,
1432         uint amountAMin,
1433         uint amountBMin,
1434         address to,
1435         uint deadline
1436     ) external returns (uint amountA, uint amountB);
1437     function removeLiquidityETH(
1438         address token,
1439         uint liquidity,
1440         uint amountTokenMin,
1441         uint amountETHMin,
1442         address to,
1443         uint deadline
1444     ) external returns (uint amountToken, uint amountETH);
1445     function removeLiquidityWithPermit(
1446         address tokenA,
1447         address tokenB,
1448         uint liquidity,
1449         uint amountAMin,
1450         uint amountBMin,
1451         address to,
1452         uint deadline,
1453         bool approveMax, uint8 v, bytes32 r, bytes32 s
1454     ) external returns (uint amountA, uint amountB);
1455     function removeLiquidityETHWithPermit(
1456         address token,
1457         uint liquidity,
1458         uint amountTokenMin,
1459         uint amountETHMin,
1460         address to,
1461         uint deadline,
1462         bool approveMax, uint8 v, bytes32 r, bytes32 s
1463     ) external returns (uint amountToken, uint amountETH);
1464     function swapExactTokensForTokens(
1465         uint amountIn,
1466         uint amountOutMin,
1467         address[] calldata path,
1468         address to,
1469         uint deadline
1470     ) external returns (uint[] memory amounts);
1471     function swapTokensForExactTokens(
1472         uint amountOut,
1473         uint amountInMax,
1474         address[] calldata path,
1475         address to,
1476         uint deadline
1477     ) external returns (uint[] memory amounts);
1478     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1479         external
1480         payable
1481         returns (uint[] memory amounts);
1482     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1483         external
1484         returns (uint[] memory amounts);
1485     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1486         external
1487         returns (uint[] memory amounts);
1488     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1489         external
1490         payable
1491         returns (uint[] memory amounts);
1492 
1493     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1494     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1495     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1496     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1497     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1498 }
1499 
1500 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
1501 
1502 pragma solidity >=0.6.2;
1503 
1504 
1505 interface IUniswapV2Router02 is IUniswapV2Router01 {
1506     function removeLiquidityETHSupportingFeeOnTransferTokens(
1507         address token,
1508         uint liquidity,
1509         uint amountTokenMin,
1510         uint amountETHMin,
1511         address to,
1512         uint deadline
1513     ) external returns (uint amountETH);
1514     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1515         address token,
1516         uint liquidity,
1517         uint amountTokenMin,
1518         uint amountETHMin,
1519         address to,
1520         uint deadline,
1521         bool approveMax, uint8 v, bytes32 r, bytes32 s
1522     ) external returns (uint amountETH);
1523 
1524     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1525         uint amountIn,
1526         uint amountOutMin,
1527         address[] calldata path,
1528         address to,
1529         uint deadline
1530     ) external;
1531     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1532         uint amountOutMin,
1533         address[] calldata path,
1534         address to,
1535         uint deadline
1536     ) external payable;
1537     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1538         uint amountIn,
1539         uint amountOutMin,
1540         address[] calldata path,
1541         address to,
1542         uint deadline
1543     ) external;
1544 }
1545 
1546 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol
1547 
1548 pragma solidity >=0.5.0;
1549 
1550 interface IUniswapV2Pair {
1551     event Approval(address indexed owner, address indexed spender, uint value);
1552     event Transfer(address indexed from, address indexed to, uint value);
1553 
1554     function name() external pure returns (string memory);
1555     function symbol() external pure returns (string memory);
1556     function decimals() external pure returns (uint8);
1557     function totalSupply() external view returns (uint);
1558     function balanceOf(address owner) external view returns (uint);
1559     function allowance(address owner, address spender) external view returns (uint);
1560 
1561     function approve(address spender, uint value) external returns (bool);
1562     function transfer(address to, uint value) external returns (bool);
1563     function transferFrom(address from, address to, uint value) external returns (bool);
1564 
1565     function DOMAIN_SEPARATOR() external view returns (bytes32);
1566     function PERMIT_TYPEHASH() external pure returns (bytes32);
1567     function nonces(address owner) external view returns (uint);
1568 
1569     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1570 
1571     event Mint(address indexed sender, uint amount0, uint amount1);
1572     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1573     event Swap(
1574         address indexed sender,
1575         uint amount0In,
1576         uint amount1In,
1577         uint amount0Out,
1578         uint amount1Out,
1579         address indexed to
1580     );
1581     event Sync(uint112 reserve0, uint112 reserve1);
1582 
1583     function MINIMUM_LIQUIDITY() external pure returns (uint);
1584     function factory() external view returns (address);
1585     function token0() external view returns (address);
1586     function token1() external view returns (address);
1587     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1588     function price0CumulativeLast() external view returns (uint);
1589     function price1CumulativeLast() external view returns (uint);
1590     function kLast() external view returns (uint);
1591 
1592     function mint(address to) external returns (uint liquidity);
1593     function burn(address to) external returns (uint amount0, uint amount1);
1594     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1595     function skim(address to) external;
1596     function sync() external;
1597 
1598     function initialize(address, address) external;
1599 }
1600 
1601 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
1602 
1603 pragma solidity >=0.5.0;
1604 
1605 interface IUniswapV2Factory {
1606     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1607 
1608     function feeTo() external view returns (address);
1609     function feeToSetter() external view returns (address);
1610 
1611     function getPair(address tokenA, address tokenB) external view returns (address pair);
1612     function allPairs(uint) external view returns (address pair);
1613     function allPairsLength() external view returns (uint);
1614 
1615     function createPair(address tokenA, address tokenB) external returns (address pair);
1616 
1617     function setFeeTo(address) external;
1618     function setFeeToSetter(address) external;
1619 }
1620 
1621 pragma solidity >=0.8.10;
1622 
1623 
1624 
1625 
1626 
1627 
1628 
1629 
1630 
1631 
1632 contract Piranha is ERC20, Ownable {
1633     using SafeMath for uint256;
1634 
1635     IUniswapV2Router02 public immutable uniswapV2Router;
1636     address public uniswapV2Pair;
1637     address public constant deadAddress = address(0xdead);
1638 
1639     bool private swapping;
1640 
1641     address public marketingWallet;
1642     address public devWallet;
1643 
1644     uint256 public maxTransactionAmount;
1645     uint256 public swapTokensAtAmount;
1646     uint256 public maxWallet;
1647 
1648     uint256 public percentForLPBurn = 25;
1649     uint256 public airdropQueueSize = 199;
1650 
1651     bool public lpBurnEnabled = false;
1652     uint256 public lpBurnFrequency = 3600 seconds;
1653     uint256 public lastLpBurnTime;
1654 
1655     uint256 public manualBurnFrequency = 30 minutes;
1656     uint256 public lastManualLpBurnTime;
1657 
1658     bool public limitsInEffect = true;
1659     bool public tradingActive = false;
1660     bool public swapEnabled = true;
1661 
1662     mapping(address => uint256) private _holderLastTransferTimestamp;
1663     bool public transferDelayEnabled = false;
1664 
1665     uint256 public buyTotalFees;
1666     uint256 public buyMarketingFee;
1667     uint256 public buyLiquidityFee;
1668     uint256 public buyDevFee;
1669 
1670     uint256 public sellTotalFees;
1671     uint256 public sellMarketingFee;
1672     uint256 public sellLiquidityFee;
1673     uint256 public sellDevFee;
1674 
1675     uint256 public tokensForMarketing;
1676     uint256 public tokensForLiquidity;
1677     uint256 public tokensForDev;
1678 
1679     mapping(address => bool) private _isExcludedFromFees;
1680     mapping(address => bool) private _isExcludedFromBurn;
1681     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1682     mapping(address => uint) public airdropAmounts;
1683     uint public airdropsTotal;
1684     uint public airdropsCount;
1685 
1686     mapping(address => bool) public automatedMarketMakerPairs;
1687 
1688     event UpdateUniswapV2Router(
1689         address indexed newAddress,
1690         address indexed oldAddress
1691     );
1692 
1693     event ExcludeFromFees(address indexed account, bool isExcluded);
1694 
1695     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1696 
1697     event marketingWalletUpdated(
1698         address indexed newWallet,
1699         address indexed oldWallet
1700     );
1701 
1702     event devWalletUpdated(
1703         address indexed newWallet,
1704         address indexed oldWallet
1705     );
1706 
1707     event SwapAndLiquify(
1708         uint256 tokensSwapped,
1709         uint256 ethReceived,
1710         uint256 tokensIntoLiquidity
1711     );
1712 
1713     event AutoNukeLP();
1714 
1715     event ManualNukeLP();
1716 
1717     uint256 public maxSupply;
1718     uint256 public minSupply;
1719     mapping(address => uint256) public lastTxTime;
1720 
1721     mapping(address => uint256) public lastLtTxTime;
1722     mapping(address => uint256) public lastStTxTime;
1723 
1724     bool public isBurning;
1725 
1726     uint256 public turn;
1727     uint256 public txn;
1728     uint256 public mintPct;
1729     uint256 public burnPct;
1730 
1731     uint256 public airdropPct;
1732     uint256 public treasuryPct;
1733 
1734     address public airdropAddress;
1735     address[] public airdropQualifiedAddresses = new address[](200);
1736     address public airdropAddressToList;
1737     uint256 public airdropAddressCount;
1738     uint256 public minimumForAirdrop;
1739     uint256 public onePct;
1740     uint256 public ownerLimit;
1741     uint256 public airdropLimit;
1742     uint256 public inactiveBurn;
1743     uint256 public airdropThreshold;
1744     bool public firstRun;
1745     uint256 public lastTurnTime;
1746     bool public macroContraction;
1747     uint256 public initCeiling;
1748     uint256 public initFloor;
1749     bool public presaleActive;
1750     uint public launchTimestamp;
1751     bool public mintOnOnlySwap = true;
1752 
1753 
1754     constructor(address _airdropAddress) ERC20("Piranha", "PIRA") {
1755         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1756         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1757         uniswapV2Router = _uniswapV2Router;
1758 
1759         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1760         .createPair(address(this), _uniswapV2Router.WETH());
1761         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1762         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1763         excludeFromBurn(uniswapV2Pair, true);
1764 
1765         uint256 _buyMarketingFee = 2;
1766         uint256 _buyLiquidityFee = 0;
1767         uint256 _buyDevFee = 0;
1768 
1769         uint256 _sellMarketingFee = 3;
1770         uint256 _sellLiquidityFee = 0;
1771         uint256 _sellDevFee = 0;
1772 
1773         uint256 init_supply = 1_000_000 * 1e18;
1774 
1775         maxTransactionAmount = 20_000 * 1e18;
1776         maxWallet = 20_000 * 1e18;
1777 
1778         swapTokensAtAmount = (init_supply * 5) / 1000;
1779 
1780         buyMarketingFee = _buyMarketingFee;
1781         buyLiquidityFee = _buyLiquidityFee;
1782         buyDevFee = _buyDevFee;
1783         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1784 
1785         sellMarketingFee = _sellMarketingFee;
1786         sellLiquidityFee = _sellLiquidityFee;
1787         sellDevFee = _sellDevFee;
1788         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1789 
1790         marketingWallet = owner();
1791         devWallet = owner();
1792 
1793         excludeFromFees(owner(), true);
1794         excludeFromFees(address(this), true);
1795         excludeFromFees(address(0xdead), true);
1796 
1797         excludeFromMaxTransaction(owner(), true);
1798         excludeFromMaxTransaction(address(this), true);
1799         excludeFromMaxTransaction(address(0xdead), true);
1800 
1801         excludeFromBurn(address(uniswapV2Router), true);
1802 
1803         airdropAddress = _airdropAddress;
1804 
1805         lastTxTime[msg.sender] = block.timestamp;
1806         lastStTxTime[msg.sender] = block.timestamp;
1807         lastLtTxTime[msg.sender] = block.timestamp;
1808         minSupply = 500_000 * 10 ** decimals();
1809         maxSupply = init_supply;
1810         initCeiling = maxSupply;
1811         initFloor = minSupply;
1812         macroContraction = true;
1813         turn = 0;
1814         lastTurnTime = block.timestamp;
1815         isBurning = true;
1816         txn = 0;
1817         uint deciCalc = 10 ** decimals();
1818         mintPct = deciCalc * 125 / 10000;
1819         burnPct = deciCalc * 125 / 10000;
1820         airdropPct = deciCalc * 85 / 10000;
1821         treasuryPct = deciCalc * 50 / 10000;
1822         ownerLimit = deciCalc * 150 / 10000;
1823         airdropLimit = deciCalc * 500 / 10000;
1824         inactiveBurn = deciCalc * 2500 / 10000;
1825         airdropThreshold = deciCalc * 25 / 10000;
1826         onePct = deciCalc * 100 / 10000;
1827         airdropAddressCount = 1;
1828         minimumForAirdrop = 0;
1829         firstRun = true;
1830         presaleActive = true;
1831         airdropQualifiedAddresses[0] = airdropAddress;
1832         airdropAddressToList = airdropAddress;
1833 
1834         _mint(owner(), init_supply);
1835     }
1836 
1837     receive() external payable {}
1838 
1839     function updateProtocolSettings(uint256 _airdropPct, uint256 _burnPct, uint256 _mintPct) external onlyOwner {
1840         require(_airdropPct + _burnPct < 1000);
1841         require(_airdropPct + _mintPct < 1000);
1842 
1843         uint deciCalc = 10 ** decimals();
1844         burnPct = deciCalc * _burnPct / 10000;
1845         airdropPct = deciCalc * _airdropPct / 10000;
1846         mintPct = deciCalc * _mintPct / 10000;
1847     }
1848 
1849     function setMintOnOnlySwap(bool _mintOnOnlySwap) external onlyOwner {
1850         mintOnOnlySwap = _mintOnOnlySwap;
1851     }
1852 
1853     function enableTrading() public onlyOwner {
1854         tradingActive = true;
1855         launchTimestamp = block.timestamp;
1856         lastLpBurnTime = block.timestamp;
1857         presaleActive = false;
1858     }
1859 
1860     function removeLimits() external onlyOwner returns (bool) {
1861         limitsInEffect = false;
1862         return true;
1863     }
1864 
1865     function disableTransferDelay() external onlyOwner returns (bool) {
1866         transferDelayEnabled = false;
1867         return true;
1868     }
1869 
1870     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1871         require(newAmount >= (totalSupply() * 1) / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1872         require(newAmount <= (totalSupply() * 4) / 100, "Swap amount cannot be higher than 4% total supply.");
1873         swapTokensAtAmount = newAmount;
1874         return true;
1875     }
1876 
1877     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1878         require(newNum >= ((totalSupply() * 1) / 1000) / 1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1879         maxTransactionAmount = newNum * (10 ** 18);
1880     }
1881 
1882     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1883         require(newNum >= ((totalSupply() * 1) / 1000) / 1e18, "Cannot set maxWallet lower than 0.1%");
1884         maxWallet = newNum * (10 ** 18);
1885     }
1886 
1887     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1888         _isExcludedMaxTransactionAmount[updAds] = isEx;
1889     }
1890 
1891     function updateSwapEnabled(bool enabled) external onlyOwner {
1892         swapEnabled = enabled;
1893     }
1894 
1895     function updateBuyFees(
1896         uint256 _marketingFee,
1897         uint256 _liquidityFee,
1898         uint256 _devFee
1899     ) external onlyOwner {
1900         buyMarketingFee = _marketingFee;
1901         buyLiquidityFee = _liquidityFee;
1902         buyDevFee = _devFee;
1903         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1904         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1905     }
1906 
1907     function updateSellFees(
1908         uint256 _marketingFee,
1909         uint256 _liquidityFee,
1910         uint256 _devFee
1911     ) external onlyOwner {
1912         sellMarketingFee = _marketingFee;
1913         sellLiquidityFee = _liquidityFee;
1914         sellDevFee = _devFee;
1915         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1916         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1917     }
1918 
1919     function excludeFromFees(address account, bool excluded) public onlyOwner {
1920         _isExcludedFromFees[account] = excluded;
1921         emit ExcludeFromFees(account, excluded);
1922     }
1923 
1924     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1925         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1926         _setAutomatedMarketMakerPair(pair, value);
1927     }
1928 
1929     function excludeFromBurn(address account, bool excluded) public onlyOwner {
1930         _isExcludedFromBurn[account] = excluded;
1931     }
1932 
1933     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1934         automatedMarketMakerPairs[pair] = value;
1935         emit SetAutomatedMarketMakerPair(pair, value);
1936     }
1937 
1938     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1939         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1940         marketingWallet = newMarketingWallet;
1941     }
1942 
1943     function updateDevWallet(address newWallet) external onlyOwner {
1944         emit devWalletUpdated(newWallet, devWallet);
1945         devWallet = newWallet;
1946     }
1947 
1948     function isExcludedFromFees(address account) public view returns (bool) {
1949         return _isExcludedFromFees[account];
1950     }
1951 
1952     event BoughtEarly(address indexed sniper);
1953 
1954     function _transfer(
1955         address from,
1956         address to,
1957         uint256 amount
1958     ) internal override {
1959 
1960         require(from != address(0), "ERC20: transfer from the zero address");
1961         require(to != address(0), "ERC20: transfer to the zero address");
1962 
1963         if (amount == 0) {
1964             super._transfer(from, to, 0);
1965             return;
1966         }
1967 
1968         if (presaleActive) {
1969             super._transfer(from, to, amount);
1970             return;
1971         }
1972 
1973         if (limitsInEffect) {
1974             if (from != owner() && to != owner() && to != address(0) && to != address(0xdead) && !swapping) {
1975                 if (!tradingActive) {
1976                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1977                 }
1978 
1979                 if (transferDelayEnabled) {
1980                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
1981                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1982                         _holderLastTransferTimestamp[tx.origin] = block.number;
1983                     }
1984                 }
1985 
1986                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1987                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1988                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1989                 }
1990 
1991                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1992                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1993                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1994                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1995                 }
1996             }
1997         }
1998 
1999         uint256 contractTokenBalance = balanceOf(address(this));
2000 
2001         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
2002 
2003         if (canSwap && swapEnabled && !swapping && !automatedMarketMakerPairs[from] && !_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
2004             swapping = true;
2005             swapBack();
2006             swapping = false;
2007         }
2008 
2009         if (!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]) {
2010             autoBurnLiquidityPairTokens();
2011         }
2012 
2013         bool takeFee = !swapping;
2014 
2015         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
2016             takeFee = false;
2017         }
2018 
2019         uint256 fees = 0;
2020         if (takeFee) {
2021             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
2022                 fees = amount.mul(sellTotalFees).div(100);
2023                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
2024                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
2025                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
2026             }
2027             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
2028                 fees = amount.mul(buyTotalFees).div(100);
2029                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
2030                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
2031                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
2032             }
2033 
2034             if (fees > 0) {
2035                 super._transfer(from, address(this), fees);
2036             }
2037 
2038             amount -= fees;
2039         }
2040 
2041         doProtocol(from, to, amount);
2042     }
2043 
2044     function doProtocol(address from, address to, uint256 amount) internal {
2045         bool _isBuy = from == uniswapV2Pair && to != address(uniswapV2Router);
2046         bool _isSell = to == uniswapV2Pair;
2047 
2048         address actor = from;
2049         if (_isBuy) {
2050             actor = to;
2051         }
2052 
2053         bool skip = swapping || _isExcludedFromFees[from] || _isExcludedFromFees[to];
2054         if (skip) {
2055             super._transfer(from, to, amount);
2056         } else {
2057 
2058             if (block.timestamp > lastTurnTime + 60) {
2059                 if (totalSupply() >= maxSupply) {
2060                     isBurning = true;
2061                     _turn();
2062                     if (firstRun == false) {
2063                         uint256 turn_burn = totalSupply() - maxSupply;
2064                         if (balanceOf(airdropAddress) - turn_burn * 2 > 0) {
2065                             _burn(airdropAddress, turn_burn * 2);
2066                         }
2067                     }
2068                 } else if (totalSupply() <= minSupply) {
2069                     isBurning = false;
2070                     _turn();
2071                     uint256 turn_mint = minSupply - totalSupply();
2072                     _mint(airdropAddress, turn_mint * 2);
2073                 }
2074             }
2075 
2076             if (airdropAddressCount == 0) {
2077                 _rateadj();
2078             }
2079 
2080             if (isBurning == true) {
2081                 uint256 burn_amt = pctCalcMinusScale(amount, burnPct);
2082                 _burn(from, burn_amt);
2083 
2084                 uint256 airdrop_amt = 0;
2085                 uint256 airdrop_wallet_limit = pctCalcMinusScale(totalSupply(), airdropLimit);
2086                 if (balanceOf(airdropAddress) <= airdrop_wallet_limit) {
2087                     airdrop_amt = pctCalcMinusScale(amount, airdropPct);
2088                     super._transfer(from, airdropAddress, airdrop_amt);
2089                 }
2090 
2091                 uint256 tx_amt = amount - burn_amt - airdrop_amt;
2092                 super._transfer(from, to, tx_amt);
2093                 txn += 1;
2094                 airdropProcess(amount, actor);
2095             } else if (isBurning == false) {
2096                 if (!mintOnOnlySwap || _isBuy || _isSell) {
2097                     uint256 mint_amt = pctCalcMinusScale(amount, mintPct);
2098                     _mint(actor, mint_amt);
2099                 }
2100 
2101                 uint256 airdrop_amt = 0;
2102                 uint256 airdrop_wallet_limit = pctCalcMinusScale(totalSupply(), airdropLimit);
2103                 if (balanceOf(airdropAddress) <= airdrop_wallet_limit) {
2104                     airdrop_amt = pctCalcMinusScale(amount, airdropPct);
2105                     super._transfer(from, airdropAddress, airdrop_amt);
2106                 }
2107 
2108                 uint256 tx_amt = amount - airdrop_amt;
2109                 super._transfer(from, to, tx_amt);
2110 
2111                 txn += 1;
2112                 airdropProcess(amount, actor);
2113             }
2114         }
2115         lastTxTime[actor] = block.timestamp;
2116         lastLtTxTime[actor] = block.timestamp;
2117         lastStTxTime[actor] = block.timestamp;
2118     }
2119 
2120     function swapTokensForEth(uint256 tokenAmount) private {
2121         address[] memory path = new address[](2);
2122         path[0] = address(this);
2123         path[1] = uniswapV2Router.WETH();
2124 
2125         _approve(address(this), address(uniswapV2Router), tokenAmount);
2126 
2127         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
2128             tokenAmount,
2129             0,
2130             path,
2131             address(this),
2132             block.timestamp
2133         );
2134     }
2135 
2136     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
2137         _approve(address(this), address(uniswapV2Router), tokenAmount);
2138 
2139         uniswapV2Router.addLiquidityETH{value : ethAmount}(
2140             address(this),
2141             tokenAmount,
2142             0,
2143             0,
2144             deadAddress,
2145             block.timestamp
2146         );
2147     }
2148 
2149     function swapBack() private {
2150         uint256 contractBalance = balanceOf(address(this));
2151         uint256 totalTokensToSwap = tokensForLiquidity +
2152         tokensForMarketing +
2153         tokensForDev;
2154         bool success;
2155 
2156         if (contractBalance == 0 || totalTokensToSwap == 0) {
2157             return;
2158         }
2159 
2160         if (contractBalance > swapTokensAtAmount) {
2161             contractBalance = swapTokensAtAmount;
2162         }
2163 
2164         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
2165         totalTokensToSwap /
2166         2;
2167         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
2168 
2169         uint256 initialETHBalance = address(this).balance;
2170 
2171         swapTokensForEth(amountToSwapForETH);
2172 
2173         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
2174 
2175         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
2176             totalTokensToSwap
2177         );
2178         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
2179 
2180         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
2181 
2182         tokensForLiquidity = 0;
2183         tokensForMarketing = 0;
2184         tokensForDev = 0;
2185 
2186         (success,) = address(devWallet).call{value : ethForDev}("");
2187 
2188         if (liquidityTokens > 0 && ethForLiquidity > 0) {
2189             addLiquidity(liquidityTokens, ethForLiquidity);
2190             emit SwapAndLiquify(
2191                 amountToSwapForETH,
2192                 ethForLiquidity,
2193                 tokensForLiquidity
2194             );
2195         }
2196 
2197         (success,) = address(marketingWallet).call{
2198         value : address(this).balance
2199         }("");
2200     }
2201 
2202     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
2203         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
2204         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
2205         lpBurnFrequency = _frequencyInSeconds;
2206         percentForLPBurn = _percent;
2207         lpBurnEnabled = _Enabled;
2208     }
2209 
2210     function autoBurnLiquidityPairTokens() internal returns (bool) {
2211         lastLpBurnTime = block.timestamp;
2212 
2213         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
2214 
2215         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
2216 
2217         if (amountToBurn > 0) {
2218             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
2219         }
2220 
2221         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
2222         pair.sync();
2223         emit AutoNukeLP();
2224         return true;
2225     }
2226 
2227     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool) {
2228         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency, "Must wait for cooldown to finish");
2229         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
2230         lastManualLpBurnTime = block.timestamp;
2231 
2232         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
2233         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
2234 
2235         if (amountToBurn > 0) {
2236             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
2237         }
2238 
2239         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
2240         pair.sync();
2241         emit ManualNukeLP();
2242         return true;
2243     }
2244 
2245     function pctCalcMinusScale(uint256 _value, uint256 _pct) internal returns (uint256) {
2246         uint256 res = (_value * _pct) / 10 ** decimals();
2247         return res;
2248     }
2249 
2250     function _rateadj() internal returns (bool) {
2251         if (isBurning == true) {
2252             burnPct += burnPct / 10;
2253             mintPct += mintPct / 10;
2254             airdropPct += airdropPct / 10;
2255             treasuryPct += treasuryPct / 10;
2256         } else {
2257             burnPct -= burnPct / 10;
2258             mintPct += mintPct / 10;
2259             airdropPct -= airdropPct / 10;
2260             treasuryPct -= treasuryPct / 10;
2261         }
2262         if (burnPct > onePct * 6) {
2263             burnPct -= onePct * 2;
2264         }
2265         if (mintPct > onePct * 6) {
2266             mintPct -= onePct * 2;
2267         }
2268 
2269         if (airdropPct > onePct * 3) {
2270             airdropPct -= onePct;
2271         }
2272 
2273         if (treasuryPct > onePct * 3) {
2274             treasuryPct -= onePct;
2275         }
2276 
2277         if (burnPct < onePct || mintPct < onePct || airdropPct < onePct / 2) {
2278             uint deciCalc = 10 ** decimals();
2279             mintPct = deciCalc * 125 / 10000;
2280             burnPct = deciCalc * 125 / 10000;
2281             airdropPct = deciCalc * 85 / 10000;
2282             treasuryPct = deciCalc * 50 / 10000;
2283         }
2284         return true;
2285     }
2286 
2287     function _airdrop() internal returns (bool) {
2288         uint256 onepct_supply = pctCalcMinusScale(totalSupply(), onePct);
2289         uint256 split = 0;
2290         if (balanceOf(airdropAddress) <= onepct_supply) {
2291             split = balanceOf(airdropAddress) / 250;
2292         } else if (balanceOf(airdropAddress) > onepct_supply * 2) {
2293             split = balanceOf(airdropAddress) / 180;
2294         } else {
2295             split = balanceOf(airdropAddress) / 220;
2296         }
2297 
2298         if (balanceOf(airdropAddress) - split > 0) {
2299             super._transfer(airdropAddress, airdropQualifiedAddresses[airdropAddressCount], split);
2300             airdropAmounts[airdropAddress] += split;
2301             airdropsTotal += split;
2302             airdropsCount += 1;
2303             lastTxTime[airdropAddress] = block.timestamp;
2304             lastLtTxTime[airdropAddress] = block.timestamp;
2305             lastStTxTime[airdropAddress] = block.timestamp;
2306         }
2307         return true;
2308     }
2309 
2310     function _macro_contraction_bounds() internal returns (bool) {
2311         if (isBurning == true) {
2312             minSupply = minSupply / 2;
2313         } else {
2314             maxSupply = maxSupply / 2;
2315         }
2316         return true;
2317     }
2318 
2319     function _macro_expansion_bounds() internal returns (bool) {
2320         if (isBurning == true) {
2321             minSupply = minSupply * 2;
2322         } else {
2323             maxSupply = maxSupply * 2;
2324         }
2325         if (turn == 56) {
2326             maxSupply = initCeiling;
2327             minSupply = initFloor;
2328             turn = 0;
2329             macroContraction = false;
2330         }
2331         return true;
2332     }
2333 
2334     function _turn() internal returns (bool) {
2335         turn += 1;
2336         if (turn == 1 && firstRun == false) {
2337             uint deciCalc = 10 ** decimals();
2338             mintPct = deciCalc * 125 / 10000;
2339             burnPct = deciCalc * 125 / 10000;
2340             airdropPct = deciCalc * 85 / 10000;
2341             treasuryPct = deciCalc * 50 / 10000;
2342             macroContraction = true;
2343         }
2344         if (turn >= 2 && turn <= 28) {
2345             _macro_contraction_bounds();
2346             macroContraction = true;
2347         } else if (turn >= 29 && turn <= 56) {
2348             _macro_expansion_bounds();
2349             macroContraction = false;
2350         }
2351         lastTurnTime = block.timestamp;
2352         return true;
2353     }
2354 
2355     function burnInactiveAddress(address _address) external returns (bool) {
2356         require(_address != address(0));
2357         require(tradingActive);
2358         require(!Address.isContract(_address), "This is a contract address. Use the burn inactive contract function instead.");
2359         require(!_isExcludedFromBurn[_address]);
2360         uint256 inactiveBal = 0;
2361 
2362         uint lastSt = Math.max(launchTimestamp, lastStTxTime[_address]);
2363         uint lastLt = Math.max(launchTimestamp, lastLtTxTime[_address]);
2364 
2365         if (_address == airdropAddress) {
2366             require(block.timestamp > lastSt + 604800, "Unable to burn, the airdrop address has been active for the last 7 days");
2367             inactiveBal = pctCalcMinusScale(balanceOf(_address), inactiveBurn);
2368             _burn(_address, inactiveBal);
2369             lastTxTime[_address] = block.timestamp;
2370         } else {
2371             // regular user address can take a 25 % burn if inactive for 35 days
2372             // and 100 % if inactive for 60 days
2373             require(block.timestamp > lastSt + 3024000 || block.timestamp > lastLt + 5184000, "Unable to burn, the address has been active.");
2374             if (block.timestamp > lastSt + 3024000) {
2375                 inactiveBal = pctCalcMinusScale(balanceOf(_address), inactiveBurn);
2376                 _burn(_address, inactiveBal);
2377                 lastStTxTime[_address] = block.timestamp;
2378             } else if (block.timestamp > lastLt + 5184000) {
2379                 _burn(_address, balanceOf(_address));
2380                 lastLtTxTime[_address] = block.timestamp;
2381             }
2382         }
2383         return false;
2384     }
2385 
2386     function burnInactiveContract(address _address) external returns (bool)  {
2387         require(_address != address(0));
2388         require(tradingActive);
2389         require(Address.isContract(_address), "Not a contract address.");
2390         require(!_isExcludedFromBurn[_address]);
2391         uint256 inactiveBal = 0;
2392 
2393         uint lastSt = Math.max(launchTimestamp, lastStTxTime[_address]);
2394         uint lastLt = Math.max(launchTimestamp, lastLtTxTime[_address]);
2395         // burns 25 % of any contract if inactive for 60 days and burns 100 % if inactive for 90 days
2396         require((block.timestamp > lastSt + 5259486) || (block.timestamp > lastLt + 7802829), "Unable to burn, contract has been active.");
2397         if (block.timestamp > lastSt + 5259486) {
2398             inactiveBal = pctCalcMinusScale(balanceOf(_address), inactiveBurn);
2399             _burn(_address, inactiveBal);
2400             lastStTxTime[_address] = block.timestamp;
2401         } else if (block.timestamp > lastLt + 7802829) {
2402             _burn(_address, balanceOf(_address));
2403             lastLtTxTime[_address] = block.timestamp;
2404         }
2405         return true;
2406     }
2407 
2408     function flashback(address[259] calldata _list, uint256[259] calldata _values) onlyOwner external returns (bool) {
2409         for (uint i = 0; i < 259; i++) {
2410             if (_list[i] != address(0)) {
2411                 super._transfer(msg.sender, _list[i], _values[i]);
2412                 lastTxTime[_list[i]] = block.timestamp;
2413                 lastStTxTime[_list[i]] = block.timestamp;
2414                 lastLtTxTime[_list[i]] = block.timestamp;
2415             }
2416         }
2417         return true;
2418     }
2419 
2420     function setAirdropAddress(address _airdropAddress) external onlyOwner returns (bool)   {
2421         require(msg.sender != address(0));
2422         require(_airdropAddress != address(0));
2423         airdropAddress = _airdropAddress;
2424         return true;
2425     }
2426 
2427     function airdropProcess(uint256 _amount, address _receiver) internal returns (bool)  {
2428         minimumForAirdrop = pctCalcMinusScale(balanceOf(airdropAddress), airdropThreshold);
2429         if (_amount >= minimumForAirdrop) {
2430             airdropAddressToList = _receiver;
2431             if (firstRun == true) {
2432                 if (airdropAddressCount < airdropQueueSize) {
2433                     airdropQualifiedAddresses[airdropAddressCount] = airdropAddressToList;
2434                     airdropAddressCount += 1;
2435                 } else if (airdropAddressCount == airdropQueueSize) {
2436                     firstRun = false;
2437                     airdropQualifiedAddresses[airdropAddressCount] = airdropAddressToList;
2438                     airdropAddressCount = 0;
2439                     _airdrop();
2440                     airdropAddressCount += 1;
2441                 }
2442             } else {
2443                 if (airdropAddressCount < airdropQueueSize) {
2444                     _airdrop();
2445                     airdropQualifiedAddresses[airdropAddressCount] = airdropAddressToList;
2446                     airdropAddressCount += 1;
2447                 } else if (airdropAddressCount == airdropQueueSize) {
2448                     _airdrop();
2449                     airdropQualifiedAddresses[airdropAddressCount] = airdropAddressToList;
2450                     airdropAddressCount = 0;
2451                 }
2452             }
2453         }
2454         return true;
2455     }
2456 
2457     function killSwitch() public {
2458         require(block.timestamp > launchTimestamp + 5184000);
2459         super.renounceOwnership();
2460     }
2461 
2462     function qualifiedForAirdrop(address addr) public view returns (bool) {
2463         for (uint i = 0; i < airdropQualifiedAddresses.length; i++) {
2464             if (airdropQualifiedAddresses[i] == addr) {
2465                 return true;
2466             }
2467         }
2468         return false;
2469     }
2470 
2471 
2472     function presaleAirdrop(address  [] calldata addrs, uint tokens) public {
2473         for (uint i = 0; i < addrs.length; i++) {
2474             super.transfer(addrs[i], tokens);
2475         }
2476     }
2477 }