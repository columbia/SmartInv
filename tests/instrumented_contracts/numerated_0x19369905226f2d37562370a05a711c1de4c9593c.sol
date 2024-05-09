1 // SPDX-License-Identifier: MIT
2 /*
3   ____  _   _ _     _     ___ _____ ____  
4  | __ )| | | | |   | |   |_ _| ____/ ___| 
5  |  _ \| | | | |   | |    | ||  _| \___ \ 
6  | |_) | |_| | |___| |___ | || |___ ___) |
7  |____/ \___/|_____|_____|___|_____|____/ 
8                                           
9           By Devko.dev#7286
10 */
11 // File: @openzeppelin/contracts/utils/Address.sol
12 
13 
14 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
15 
16 pragma solidity ^0.8.1;
17 
18 /**
19  * @dev Collection of functions related to the address type
20  */
21 library Address {
22     /**
23      * @dev Returns true if `account` is a contract.
24      *
25      * [IMPORTANT]
26      * ====
27      * It is unsafe to assume that an address for which this function returns
28      * false is an externally-owned account (EOA) and not a contract.
29      *
30      * Among others, `isContract` will return false for the following
31      * types of addresses:
32      *
33      *  - an externally-owned account
34      *  - a contract in construction
35      *  - an address where a contract will be created
36      *  - an address where a contract lived, but was destroyed
37      * ====
38      *
39      * [IMPORTANT]
40      * ====
41      * You shouldn't rely on `isContract` to protect against flash loan attacks!
42      *
43      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
44      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
45      * constructor.
46      * ====
47      */
48     function isContract(address account) internal view returns (bool) {
49         // This method relies on extcodesize/address.code.length, which returns 0
50         // for contracts in construction, since the code is only stored at the end
51         // of the constructor execution.
52 
53         return account.code.length > 0;
54     }
55 
56     /**
57      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
58      * `recipient`, forwarding all available gas and reverting on errors.
59      *
60      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
61      * of certain opcodes, possibly making contracts go over the 2300 gas limit
62      * imposed by `transfer`, making them unable to receive funds via
63      * `transfer`. {sendValue} removes this limitation.
64      *
65      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
66      *
67      * IMPORTANT: because control is transferred to `recipient`, care must be
68      * taken to not create reentrancy vulnerabilities. Consider using
69      * {ReentrancyGuard} or the
70      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
71      */
72     function sendValue(address payable recipient, uint256 amount) internal {
73         require(address(this).balance >= amount, "Address: insufficient balance");
74 
75         (bool success, ) = recipient.call{value: amount}("");
76         require(success, "Address: unable to send value, recipient may have reverted");
77     }
78 
79     /**
80      * @dev Performs a Solidity function call using a low level `call`. A
81      * plain `call` is an unsafe replacement for a function call: use this
82      * function instead.
83      *
84      * If `target` reverts with a revert reason, it is bubbled up by this
85      * function (like regular Solidity function calls).
86      *
87      * Returns the raw returned data. To convert to the expected return value,
88      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
89      *
90      * Requirements:
91      *
92      * - `target` must be a contract.
93      * - calling `target` with `data` must not revert.
94      *
95      * _Available since v3.1._
96      */
97     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
98         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
99     }
100 
101     /**
102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
103      * `errorMessage` as a fallback revert reason when `target` reverts.
104      *
105      * _Available since v3.1._
106      */
107     function functionCall(
108         address target,
109         bytes memory data,
110         string memory errorMessage
111     ) internal returns (bytes memory) {
112         return functionCallWithValue(target, data, 0, errorMessage);
113     }
114 
115     /**
116      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
117      * but also transferring `value` wei to `target`.
118      *
119      * Requirements:
120      *
121      * - the calling contract must have an ETH balance of at least `value`.
122      * - the called Solidity function must be `payable`.
123      *
124      * _Available since v3.1._
125      */
126     function functionCallWithValue(
127         address target,
128         bytes memory data,
129         uint256 value
130     ) internal returns (bytes memory) {
131         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
132     }
133 
134     /**
135      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
136      * with `errorMessage` as a fallback revert reason when `target` reverts.
137      *
138      * _Available since v3.1._
139      */
140     function functionCallWithValue(
141         address target,
142         bytes memory data,
143         uint256 value,
144         string memory errorMessage
145     ) internal returns (bytes memory) {
146         require(address(this).balance >= value, "Address: insufficient balance for call");
147         (bool success, bytes memory returndata) = target.call{value: value}(data);
148         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
149     }
150 
151     /**
152      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
153      * but performing a static call.
154      *
155      * _Available since v3.3._
156      */
157     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
158         return functionStaticCall(target, data, "Address: low-level static call failed");
159     }
160 
161     /**
162      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
163      * but performing a static call.
164      *
165      * _Available since v3.3._
166      */
167     function functionStaticCall(
168         address target,
169         bytes memory data,
170         string memory errorMessage
171     ) internal view returns (bytes memory) {
172         (bool success, bytes memory returndata) = target.staticcall(data);
173         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
174     }
175 
176     /**
177      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
178      * but performing a delegate call.
179      *
180      * _Available since v3.4._
181      */
182     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
183         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
184     }
185 
186     /**
187      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
188      * but performing a delegate call.
189      *
190      * _Available since v3.4._
191      */
192     function functionDelegateCall(
193         address target,
194         bytes memory data,
195         string memory errorMessage
196     ) internal returns (bytes memory) {
197         (bool success, bytes memory returndata) = target.delegatecall(data);
198         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
199     }
200 
201     /**
202      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
203      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
204      *
205      * _Available since v4.8._
206      */
207     function verifyCallResultFromTarget(
208         address target,
209         bool success,
210         bytes memory returndata,
211         string memory errorMessage
212     ) internal view returns (bytes memory) {
213         if (success) {
214             if (returndata.length == 0) {
215                 // only check isContract if the call was successful and the return data is empty
216                 // otherwise we already know that it was a contract
217                 require(isContract(target), "Address: call to non-contract");
218             }
219             return returndata;
220         } else {
221             _revert(returndata, errorMessage);
222         }
223     }
224 
225     /**
226      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
227      * revert reason or using the provided one.
228      *
229      * _Available since v4.3._
230      */
231     function verifyCallResult(
232         bool success,
233         bytes memory returndata,
234         string memory errorMessage
235     ) internal pure returns (bytes memory) {
236         if (success) {
237             return returndata;
238         } else {
239             _revert(returndata, errorMessage);
240         }
241     }
242 
243     function _revert(bytes memory returndata, string memory errorMessage) private pure {
244         // Look for revert reason and bubble it up if present
245         if (returndata.length > 0) {
246             // The easiest way to bubble the revert reason is using memory via assembly
247             /// @solidity memory-safe-assembly
248             assembly {
249                 let returndata_size := mload(returndata)
250                 revert(add(32, returndata), returndata_size)
251             }
252         } else {
253             revert(errorMessage);
254         }
255     }
256 }
257 
258 // File: @openzeppelin/contracts/utils/math/Math.sol
259 
260 
261 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
262 
263 pragma solidity ^0.8.0;
264 
265 /**
266  * @dev Standard math utilities missing in the Solidity language.
267  */
268 library Math {
269     enum Rounding {
270         Down, // Toward negative infinity
271         Up, // Toward infinity
272         Zero // Toward zero
273     }
274 
275     /**
276      * @dev Returns the largest of two numbers.
277      */
278     function max(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a > b ? a : b;
280     }
281 
282     /**
283      * @dev Returns the smallest of two numbers.
284      */
285     function min(uint256 a, uint256 b) internal pure returns (uint256) {
286         return a < b ? a : b;
287     }
288 
289     /**
290      * @dev Returns the average of two numbers. The result is rounded towards
291      * zero.
292      */
293     function average(uint256 a, uint256 b) internal pure returns (uint256) {
294         // (a + b) / 2 can overflow.
295         return (a & b) + (a ^ b) / 2;
296     }
297 
298     /**
299      * @dev Returns the ceiling of the division of two numbers.
300      *
301      * This differs from standard division with `/` in that it rounds up instead
302      * of rounding down.
303      */
304     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
305         // (a + b - 1) / b can overflow on addition, so we distribute.
306         return a == 0 ? 0 : (a - 1) / b + 1;
307     }
308 
309     /**
310      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
311      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
312      * with further edits by Uniswap Labs also under MIT license.
313      */
314     function mulDiv(
315         uint256 x,
316         uint256 y,
317         uint256 denominator
318     ) internal pure returns (uint256 result) {
319         unchecked {
320             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
321             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
322             // variables such that product = prod1 * 2^256 + prod0.
323             uint256 prod0; // Least significant 256 bits of the product
324             uint256 prod1; // Most significant 256 bits of the product
325             assembly {
326                 let mm := mulmod(x, y, not(0))
327                 prod0 := mul(x, y)
328                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
329             }
330 
331             // Handle non-overflow cases, 256 by 256 division.
332             if (prod1 == 0) {
333                 return prod0 / denominator;
334             }
335 
336             // Make sure the result is less than 2^256. Also prevents denominator == 0.
337             require(denominator > prod1);
338 
339             ///////////////////////////////////////////////
340             // 512 by 256 division.
341             ///////////////////////////////////////////////
342 
343             // Make division exact by subtracting the remainder from [prod1 prod0].
344             uint256 remainder;
345             assembly {
346                 // Compute remainder using mulmod.
347                 remainder := mulmod(x, y, denominator)
348 
349                 // Subtract 256 bit number from 512 bit number.
350                 prod1 := sub(prod1, gt(remainder, prod0))
351                 prod0 := sub(prod0, remainder)
352             }
353 
354             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
355             // See https://cs.stackexchange.com/q/138556/92363.
356 
357             // Does not overflow because the denominator cannot be zero at this stage in the function.
358             uint256 twos = denominator & (~denominator + 1);
359             assembly {
360                 // Divide denominator by twos.
361                 denominator := div(denominator, twos)
362 
363                 // Divide [prod1 prod0] by twos.
364                 prod0 := div(prod0, twos)
365 
366                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
367                 twos := add(div(sub(0, twos), twos), 1)
368             }
369 
370             // Shift in bits from prod1 into prod0.
371             prod0 |= prod1 * twos;
372 
373             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
374             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
375             // four bits. That is, denominator * inv = 1 mod 2^4.
376             uint256 inverse = (3 * denominator) ^ 2;
377 
378             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
379             // in modular arithmetic, doubling the correct bits in each step.
380             inverse *= 2 - denominator * inverse; // inverse mod 2^8
381             inverse *= 2 - denominator * inverse; // inverse mod 2^16
382             inverse *= 2 - denominator * inverse; // inverse mod 2^32
383             inverse *= 2 - denominator * inverse; // inverse mod 2^64
384             inverse *= 2 - denominator * inverse; // inverse mod 2^128
385             inverse *= 2 - denominator * inverse; // inverse mod 2^256
386 
387             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
388             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
389             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
390             // is no longer required.
391             result = prod0 * inverse;
392             return result;
393         }
394     }
395 
396     /**
397      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
398      */
399     function mulDiv(
400         uint256 x,
401         uint256 y,
402         uint256 denominator,
403         Rounding rounding
404     ) internal pure returns (uint256) {
405         uint256 result = mulDiv(x, y, denominator);
406         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
407             result += 1;
408         }
409         return result;
410     }
411 
412     /**
413      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
414      *
415      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
416      */
417     function sqrt(uint256 a) internal pure returns (uint256) {
418         if (a == 0) {
419             return 0;
420         }
421 
422         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
423         //
424         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
425         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
426         //
427         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
428         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
429         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
430         //
431         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
432         uint256 result = 1 << (log2(a) >> 1);
433 
434         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
435         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
436         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
437         // into the expected uint128 result.
438         unchecked {
439             result = (result + a / result) >> 1;
440             result = (result + a / result) >> 1;
441             result = (result + a / result) >> 1;
442             result = (result + a / result) >> 1;
443             result = (result + a / result) >> 1;
444             result = (result + a / result) >> 1;
445             result = (result + a / result) >> 1;
446             return min(result, a / result);
447         }
448     }
449 
450     /**
451      * @notice Calculates sqrt(a), following the selected rounding direction.
452      */
453     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
454         unchecked {
455             uint256 result = sqrt(a);
456             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
457         }
458     }
459 
460     /**
461      * @dev Return the log in base 2, rounded down, of a positive value.
462      * Returns 0 if given 0.
463      */
464     function log2(uint256 value) internal pure returns (uint256) {
465         uint256 result = 0;
466         unchecked {
467             if (value >> 128 > 0) {
468                 value >>= 128;
469                 result += 128;
470             }
471             if (value >> 64 > 0) {
472                 value >>= 64;
473                 result += 64;
474             }
475             if (value >> 32 > 0) {
476                 value >>= 32;
477                 result += 32;
478             }
479             if (value >> 16 > 0) {
480                 value >>= 16;
481                 result += 16;
482             }
483             if (value >> 8 > 0) {
484                 value >>= 8;
485                 result += 8;
486             }
487             if (value >> 4 > 0) {
488                 value >>= 4;
489                 result += 4;
490             }
491             if (value >> 2 > 0) {
492                 value >>= 2;
493                 result += 2;
494             }
495             if (value >> 1 > 0) {
496                 result += 1;
497             }
498         }
499         return result;
500     }
501 
502     /**
503      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
504      * Returns 0 if given 0.
505      */
506     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
507         unchecked {
508             uint256 result = log2(value);
509             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
510         }
511     }
512 
513     /**
514      * @dev Return the log in base 10, rounded down, of a positive value.
515      * Returns 0 if given 0.
516      */
517     function log10(uint256 value) internal pure returns (uint256) {
518         uint256 result = 0;
519         unchecked {
520             if (value >= 10**64) {
521                 value /= 10**64;
522                 result += 64;
523             }
524             if (value >= 10**32) {
525                 value /= 10**32;
526                 result += 32;
527             }
528             if (value >= 10**16) {
529                 value /= 10**16;
530                 result += 16;
531             }
532             if (value >= 10**8) {
533                 value /= 10**8;
534                 result += 8;
535             }
536             if (value >= 10**4) {
537                 value /= 10**4;
538                 result += 4;
539             }
540             if (value >= 10**2) {
541                 value /= 10**2;
542                 result += 2;
543             }
544             if (value >= 10**1) {
545                 result += 1;
546             }
547         }
548         return result;
549     }
550 
551     /**
552      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
553      * Returns 0 if given 0.
554      */
555     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
556         unchecked {
557             uint256 result = log10(value);
558             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
559         }
560     }
561 
562     /**
563      * @dev Return the log in base 256, rounded down, of a positive value.
564      * Returns 0 if given 0.
565      *
566      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
567      */
568     function log256(uint256 value) internal pure returns (uint256) {
569         uint256 result = 0;
570         unchecked {
571             if (value >> 128 > 0) {
572                 value >>= 128;
573                 result += 16;
574             }
575             if (value >> 64 > 0) {
576                 value >>= 64;
577                 result += 8;
578             }
579             if (value >> 32 > 0) {
580                 value >>= 32;
581                 result += 4;
582             }
583             if (value >> 16 > 0) {
584                 value >>= 16;
585                 result += 2;
586             }
587             if (value >> 8 > 0) {
588                 result += 1;
589             }
590         }
591         return result;
592     }
593 
594     /**
595      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
596      * Returns 0 if given 0.
597      */
598     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
599         unchecked {
600             uint256 result = log256(value);
601             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
602         }
603     }
604 }
605 
606 // File: @openzeppelin/contracts/utils/Strings.sol
607 
608 
609 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
610 
611 pragma solidity ^0.8.0;
612 
613 
614 /**
615  * @dev String operations.
616  */
617 library Strings {
618     bytes16 private constant _SYMBOLS = "0123456789abcdef";
619     uint8 private constant _ADDRESS_LENGTH = 20;
620 
621     /**
622      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
623      */
624     function toString(uint256 value) internal pure returns (string memory) {
625         unchecked {
626             uint256 length = Math.log10(value) + 1;
627             string memory buffer = new string(length);
628             uint256 ptr;
629             /// @solidity memory-safe-assembly
630             assembly {
631                 ptr := add(buffer, add(32, length))
632             }
633             while (true) {
634                 ptr--;
635                 /// @solidity memory-safe-assembly
636                 assembly {
637                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
638                 }
639                 value /= 10;
640                 if (value == 0) break;
641             }
642             return buffer;
643         }
644     }
645 
646     /**
647      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
648      */
649     function toHexString(uint256 value) internal pure returns (string memory) {
650         unchecked {
651             return toHexString(value, Math.log256(value) + 1);
652         }
653     }
654 
655     /**
656      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
657      */
658     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
659         bytes memory buffer = new bytes(2 * length + 2);
660         buffer[0] = "0";
661         buffer[1] = "x";
662         for (uint256 i = 2 * length + 1; i > 1; --i) {
663             buffer[i] = _SYMBOLS[value & 0xf];
664             value >>= 4;
665         }
666         require(value == 0, "Strings: hex length insufficient");
667         return string(buffer);
668     }
669 
670     /**
671      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
672      */
673     function toHexString(address addr) internal pure returns (string memory) {
674         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
675     }
676 }
677 
678 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
679 
680 
681 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
682 
683 pragma solidity ^0.8.0;
684 
685 
686 /**
687  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
688  *
689  * These functions can be used to verify that a message was signed by the holder
690  * of the private keys of a given address.
691  */
692 library ECDSA {
693     enum RecoverError {
694         NoError,
695         InvalidSignature,
696         InvalidSignatureLength,
697         InvalidSignatureS,
698         InvalidSignatureV // Deprecated in v4.8
699     }
700 
701     function _throwError(RecoverError error) private pure {
702         if (error == RecoverError.NoError) {
703             return; // no error: do nothing
704         } else if (error == RecoverError.InvalidSignature) {
705             revert("ECDSA: invalid signature");
706         } else if (error == RecoverError.InvalidSignatureLength) {
707             revert("ECDSA: invalid signature length");
708         } else if (error == RecoverError.InvalidSignatureS) {
709             revert("ECDSA: invalid signature 's' value");
710         }
711     }
712 
713     /**
714      * @dev Returns the address that signed a hashed message (`hash`) with
715      * `signature` or error string. This address can then be used for verification purposes.
716      *
717      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
718      * this function rejects them by requiring the `s` value to be in the lower
719      * half order, and the `v` value to be either 27 or 28.
720      *
721      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
722      * verification to be secure: it is possible to craft signatures that
723      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
724      * this is by receiving a hash of the original message (which may otherwise
725      * be too long), and then calling {toEthSignedMessageHash} on it.
726      *
727      * Documentation for signature generation:
728      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
729      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
730      *
731      * _Available since v4.3._
732      */
733     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
734         if (signature.length == 65) {
735             bytes32 r;
736             bytes32 s;
737             uint8 v;
738             // ecrecover takes the signature parameters, and the only way to get them
739             // currently is to use assembly.
740             /// @solidity memory-safe-assembly
741             assembly {
742                 r := mload(add(signature, 0x20))
743                 s := mload(add(signature, 0x40))
744                 v := byte(0, mload(add(signature, 0x60)))
745             }
746             return tryRecover(hash, v, r, s);
747         } else {
748             return (address(0), RecoverError.InvalidSignatureLength);
749         }
750     }
751 
752     /**
753      * @dev Returns the address that signed a hashed message (`hash`) with
754      * `signature`. This address can then be used for verification purposes.
755      *
756      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
757      * this function rejects them by requiring the `s` value to be in the lower
758      * half order, and the `v` value to be either 27 or 28.
759      *
760      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
761      * verification to be secure: it is possible to craft signatures that
762      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
763      * this is by receiving a hash of the original message (which may otherwise
764      * be too long), and then calling {toEthSignedMessageHash} on it.
765      */
766     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
767         (address recovered, RecoverError error) = tryRecover(hash, signature);
768         _throwError(error);
769         return recovered;
770     }
771 
772     /**
773      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
774      *
775      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
776      *
777      * _Available since v4.3._
778      */
779     function tryRecover(
780         bytes32 hash,
781         bytes32 r,
782         bytes32 vs
783     ) internal pure returns (address, RecoverError) {
784         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
785         uint8 v = uint8((uint256(vs) >> 255) + 27);
786         return tryRecover(hash, v, r, s);
787     }
788 
789     /**
790      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
791      *
792      * _Available since v4.2._
793      */
794     function recover(
795         bytes32 hash,
796         bytes32 r,
797         bytes32 vs
798     ) internal pure returns (address) {
799         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
800         _throwError(error);
801         return recovered;
802     }
803 
804     /**
805      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
806      * `r` and `s` signature fields separately.
807      *
808      * _Available since v4.3._
809      */
810     function tryRecover(
811         bytes32 hash,
812         uint8 v,
813         bytes32 r,
814         bytes32 s
815     ) internal pure returns (address, RecoverError) {
816         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
817         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
818         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
819         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
820         //
821         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
822         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
823         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
824         // these malleable signatures as well.
825         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
826             return (address(0), RecoverError.InvalidSignatureS);
827         }
828 
829         // If the signature is valid (and not malleable), return the signer address
830         address signer = ecrecover(hash, v, r, s);
831         if (signer == address(0)) {
832             return (address(0), RecoverError.InvalidSignature);
833         }
834 
835         return (signer, RecoverError.NoError);
836     }
837 
838     /**
839      * @dev Overload of {ECDSA-recover} that receives the `v`,
840      * `r` and `s` signature fields separately.
841      */
842     function recover(
843         bytes32 hash,
844         uint8 v,
845         bytes32 r,
846         bytes32 s
847     ) internal pure returns (address) {
848         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
849         _throwError(error);
850         return recovered;
851     }
852 
853     /**
854      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
855      * produces hash corresponding to the one signed with the
856      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
857      * JSON-RPC method as part of EIP-191.
858      *
859      * See {recover}.
860      */
861     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
862         // 32 is the length in bytes of hash,
863         // enforced by the type signature above
864         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
865     }
866 
867     /**
868      * @dev Returns an Ethereum Signed Message, created from `s`. This
869      * produces hash corresponding to the one signed with the
870      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
871      * JSON-RPC method as part of EIP-191.
872      *
873      * See {recover}.
874      */
875     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
876         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
877     }
878 
879     /**
880      * @dev Returns an Ethereum Signed Typed Data, created from a
881      * `domainSeparator` and a `structHash`. This produces hash corresponding
882      * to the one signed with the
883      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
884      * JSON-RPC method as part of EIP-712.
885      *
886      * See {recover}.
887      */
888     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
889         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
890     }
891 }
892 
893 // File: @openzeppelin/contracts/utils/Context.sol
894 
895 
896 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
897 
898 pragma solidity ^0.8.0;
899 
900 /**
901  * @dev Provides information about the current execution context, including the
902  * sender of the transaction and its data. While these are generally available
903  * via msg.sender and msg.data, they should not be accessed in such a direct
904  * manner, since when dealing with meta-transactions the account sending and
905  * paying for execution may not be the actual sender (as far as an application
906  * is concerned).
907  *
908  * This contract is only required for intermediate, library-like contracts.
909  */
910 abstract contract Context {
911     function _msgSender() internal view virtual returns (address) {
912         return msg.sender;
913     }
914 
915     function _msgData() internal view virtual returns (bytes calldata) {
916         return msg.data;
917     }
918 }
919 
920 // File: @openzeppelin/contracts/access/Ownable.sol
921 
922 
923 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @dev Contract module which provides a basic access control mechanism, where
930  * there is an account (an owner) that can be granted exclusive access to
931  * specific functions.
932  *
933  * By default, the owner account will be the one that deploys the contract. This
934  * can later be changed with {transferOwnership}.
935  *
936  * This module is used through inheritance. It will make available the modifier
937  * `onlyOwner`, which can be applied to your functions to restrict their use to
938  * the owner.
939  */
940 abstract contract Ownable is Context {
941     address private _owner;
942 
943     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
944 
945     /**
946      * @dev Initializes the contract setting the deployer as the initial owner.
947      */
948     constructor() {
949         _transferOwnership(_msgSender());
950     }
951 
952     /**
953      * @dev Throws if called by any account other than the owner.
954      */
955     modifier onlyOwner() {
956         _checkOwner();
957         _;
958     }
959 
960     /**
961      * @dev Returns the address of the current owner.
962      */
963     function owner() public view virtual returns (address) {
964         return _owner;
965     }
966 
967     /**
968      * @dev Throws if the sender is not the owner.
969      */
970     function _checkOwner() internal view virtual {
971         require(owner() == _msgSender(), "Ownable: caller is not the owner");
972     }
973 
974     /**
975      * @dev Leaves the contract without owner. It will not be possible to call
976      * `onlyOwner` functions anymore. Can only be called by the current owner.
977      *
978      * NOTE: Renouncing ownership will leave the contract without an owner,
979      * thereby removing any functionality that is only available to the owner.
980      */
981     function renounceOwnership() public virtual onlyOwner {
982         _transferOwnership(address(0));
983     }
984 
985     /**
986      * @dev Transfers ownership of the contract to a new account (`newOwner`).
987      * Can only be called by the current owner.
988      */
989     function transferOwnership(address newOwner) public virtual onlyOwner {
990         require(newOwner != address(0), "Ownable: new owner is the zero address");
991         _transferOwnership(newOwner);
992     }
993 
994     /**
995      * @dev Transfers ownership of the contract to a new account (`newOwner`).
996      * Internal function without access restriction.
997      */
998     function _transferOwnership(address newOwner) internal virtual {
999         address oldOwner = _owner;
1000         _owner = newOwner;
1001         emit OwnershipTransferred(oldOwner, newOwner);
1002     }
1003 }
1004 
1005 // File: operator-filter-registry/src/lib/Constants.sol
1006 
1007 
1008 pragma solidity ^0.8.17;
1009 
1010 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
1011 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1012 
1013 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
1014 
1015 
1016 pragma solidity ^0.8.13;
1017 
1018 interface IOperatorFilterRegistry {
1019     /**
1020      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
1021      *         true if supplied registrant address is not registered.
1022      */
1023     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1024 
1025     /**
1026      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
1027      */
1028     function register(address registrant) external;
1029 
1030     /**
1031      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
1032      */
1033     function registerAndSubscribe(address registrant, address subscription) external;
1034 
1035     /**
1036      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
1037      *         address without subscribing.
1038      */
1039     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1040 
1041     /**
1042      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
1043      *         Note that this does not remove any filtered addresses or codeHashes.
1044      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
1045      */
1046     function unregister(address addr) external;
1047 
1048     /**
1049      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
1050      */
1051     function updateOperator(address registrant, address operator, bool filtered) external;
1052 
1053     /**
1054      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
1055      */
1056     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1057 
1058     /**
1059      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
1060      */
1061     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1062 
1063     /**
1064      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
1065      */
1066     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1067 
1068     /**
1069      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
1070      *         subscription if present.
1071      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
1072      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
1073      *         used.
1074      */
1075     function subscribe(address registrant, address registrantToSubscribe) external;
1076 
1077     /**
1078      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
1079      */
1080     function unsubscribe(address registrant, bool copyExistingEntries) external;
1081 
1082     /**
1083      * @notice Get the subscription address of a given registrant, if any.
1084      */
1085     function subscriptionOf(address addr) external returns (address registrant);
1086 
1087     /**
1088      * @notice Get the set of addresses subscribed to a given registrant.
1089      *         Note that order is not guaranteed as updates are made.
1090      */
1091     function subscribers(address registrant) external returns (address[] memory);
1092 
1093     /**
1094      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
1095      *         Note that order is not guaranteed as updates are made.
1096      */
1097     function subscriberAt(address registrant, uint256 index) external returns (address);
1098 
1099     /**
1100      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
1101      */
1102     function copyEntriesOf(address registrant, address registrantToCopy) external;
1103 
1104     /**
1105      * @notice Returns true if operator is filtered by a given address or its subscription.
1106      */
1107     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1108 
1109     /**
1110      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
1111      */
1112     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1113 
1114     /**
1115      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
1116      */
1117     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1118 
1119     /**
1120      * @notice Returns a list of filtered operators for a given address or its subscription.
1121      */
1122     function filteredOperators(address addr) external returns (address[] memory);
1123 
1124     /**
1125      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
1126      *         Note that order is not guaranteed as updates are made.
1127      */
1128     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1129 
1130     /**
1131      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
1132      *         its subscription.
1133      *         Note that order is not guaranteed as updates are made.
1134      */
1135     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1136 
1137     /**
1138      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
1139      *         its subscription.
1140      *         Note that order is not guaranteed as updates are made.
1141      */
1142     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1143 
1144     /**
1145      * @notice Returns true if an address has registered
1146      */
1147     function isRegistered(address addr) external returns (bool);
1148 
1149     /**
1150      * @dev Convenience method to compute the code hash of an arbitrary contract
1151      */
1152     function codeHashOf(address addr) external returns (bytes32);
1153 }
1154 
1155 // File: operator-filter-registry/src/OperatorFilterer.sol
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
1233 
1234 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
1235 
1236 
1237 pragma solidity ^0.8.13;
1238 
1239 
1240 /**
1241  * @title  DefaultOperatorFilterer
1242  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1243  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
1244  *         administration methods on the contract itself to interact with the registry otherwise the subscription
1245  *         will be locked to the options set during construction.
1246  */
1247 
1248 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1249     /// @dev The constructor that is called when the contract is being deployed.
1250     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
1251 }
1252 
1253 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1254 
1255 
1256 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 /**
1261  * @dev Interface of the ERC165 standard, as defined in the
1262  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1263  *
1264  * Implementers can declare support of contract interfaces, which can then be
1265  * queried by others ({ERC165Checker}).
1266  *
1267  * For an implementation, see {ERC165}.
1268  */
1269 interface IERC165 {
1270     /**
1271      * @dev Returns true if this contract implements the interface defined by
1272      * `interfaceId`. See the corresponding
1273      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1274      * to learn more about how these ids are created.
1275      *
1276      * This function call must use less than 30 000 gas.
1277      */
1278     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1279 }
1280 
1281 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1282 
1283 
1284 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1285 
1286 pragma solidity ^0.8.0;
1287 
1288 
1289 /**
1290  * @dev Implementation of the {IERC165} interface.
1291  *
1292  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1293  * for the additional interface id that will be supported. For example:
1294  *
1295  * ```solidity
1296  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1297  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1298  * }
1299  * ```
1300  *
1301  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1302  */
1303 abstract contract ERC165 is IERC165 {
1304     /**
1305      * @dev See {IERC165-supportsInterface}.
1306      */
1307     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1308         return interfaceId == type(IERC165).interfaceId;
1309     }
1310 }
1311 
1312 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1313 
1314 
1315 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1316 
1317 pragma solidity ^0.8.0;
1318 
1319 
1320 /**
1321  * @dev Interface for the NFT Royalty Standard.
1322  *
1323  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1324  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1325  *
1326  * _Available since v4.5._
1327  */
1328 interface IERC2981 is IERC165 {
1329     /**
1330      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1331      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1332      */
1333     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1334         external
1335         view
1336         returns (address receiver, uint256 royaltyAmount);
1337 }
1338 
1339 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1340 
1341 
1342 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 
1347 
1348 /**
1349  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1350  *
1351  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1352  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1353  *
1354  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1355  * fee is specified in basis points by default.
1356  *
1357  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1358  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1359  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1360  *
1361  * _Available since v4.5._
1362  */
1363 abstract contract ERC2981 is IERC2981, ERC165 {
1364     struct RoyaltyInfo {
1365         address receiver;
1366         uint96 royaltyFraction;
1367     }
1368 
1369     RoyaltyInfo private _defaultRoyaltyInfo;
1370     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1371 
1372     /**
1373      * @dev See {IERC165-supportsInterface}.
1374      */
1375     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1376         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1377     }
1378 
1379     /**
1380      * @inheritdoc IERC2981
1381      */
1382     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1383         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1384 
1385         if (royalty.receiver == address(0)) {
1386             royalty = _defaultRoyaltyInfo;
1387         }
1388 
1389         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1390 
1391         return (royalty.receiver, royaltyAmount);
1392     }
1393 
1394     /**
1395      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1396      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1397      * override.
1398      */
1399     function _feeDenominator() internal pure virtual returns (uint96) {
1400         return 10000;
1401     }
1402 
1403     /**
1404      * @dev Sets the royalty information that all ids in this contract will default to.
1405      *
1406      * Requirements:
1407      *
1408      * - `receiver` cannot be the zero address.
1409      * - `feeNumerator` cannot be greater than the fee denominator.
1410      */
1411     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1412         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1413         require(receiver != address(0), "ERC2981: invalid receiver");
1414 
1415         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1416     }
1417 
1418     /**
1419      * @dev Removes default royalty information.
1420      */
1421     function _deleteDefaultRoyalty() internal virtual {
1422         delete _defaultRoyaltyInfo;
1423     }
1424 
1425     /**
1426      * @dev Sets the royalty information for a specific token id, overriding the global default.
1427      *
1428      * Requirements:
1429      *
1430      * - `receiver` cannot be the zero address.
1431      * - `feeNumerator` cannot be greater than the fee denominator.
1432      */
1433     function _setTokenRoyalty(
1434         uint256 tokenId,
1435         address receiver,
1436         uint96 feeNumerator
1437     ) internal virtual {
1438         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1439         require(receiver != address(0), "ERC2981: Invalid parameters");
1440 
1441         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1442     }
1443 
1444     /**
1445      * @dev Resets royalty information for the token id back to the global default.
1446      */
1447     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1448         delete _tokenRoyaltyInfo[tokenId];
1449     }
1450 }
1451 
1452 // File: erc721a/contracts/IERC721A.sol
1453 
1454 
1455 // ERC721A Contracts v4.2.3
1456 // Creator: Chiru Labs
1457 
1458 pragma solidity ^0.8.4;
1459 
1460 /**
1461  * @dev Interface of ERC721A.
1462  */
1463 interface IERC721A {
1464     /**
1465      * The caller must own the token or be an approved operator.
1466      */
1467     error ApprovalCallerNotOwnerNorApproved();
1468 
1469     /**
1470      * The token does not exist.
1471      */
1472     error ApprovalQueryForNonexistentToken();
1473 
1474     /**
1475      * Cannot query the balance for the zero address.
1476      */
1477     error BalanceQueryForZeroAddress();
1478 
1479     /**
1480      * Cannot mint to the zero address.
1481      */
1482     error MintToZeroAddress();
1483 
1484     /**
1485      * The quantity of tokens minted must be more than zero.
1486      */
1487     error MintZeroQuantity();
1488 
1489     /**
1490      * The token does not exist.
1491      */
1492     error OwnerQueryForNonexistentToken();
1493 
1494     /**
1495      * The caller must own the token or be an approved operator.
1496      */
1497     error TransferCallerNotOwnerNorApproved();
1498 
1499     /**
1500      * The token must be owned by `from`.
1501      */
1502     error TransferFromIncorrectOwner();
1503 
1504     /**
1505      * Cannot safely transfer to a contract that does not implement the
1506      * ERC721Receiver interface.
1507      */
1508     error TransferToNonERC721ReceiverImplementer();
1509 
1510     /**
1511      * Cannot transfer to the zero address.
1512      */
1513     error TransferToZeroAddress();
1514 
1515     /**
1516      * The token does not exist.
1517      */
1518     error URIQueryForNonexistentToken();
1519 
1520     /**
1521      * The `quantity` minted with ERC2309 exceeds the safety limit.
1522      */
1523     error MintERC2309QuantityExceedsLimit();
1524 
1525     /**
1526      * The `extraData` cannot be set on an unintialized ownership slot.
1527      */
1528     error OwnershipNotInitializedForExtraData();
1529 
1530     // =============================================================
1531     //                            STRUCTS
1532     // =============================================================
1533 
1534     struct TokenOwnership {
1535         // The address of the owner.
1536         address addr;
1537         // Stores the start time of ownership with minimal overhead for tokenomics.
1538         uint64 startTimestamp;
1539         // Whether the token has been burned.
1540         bool burned;
1541         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1542         uint24 extraData;
1543     }
1544 
1545     // =============================================================
1546     //                         TOKEN COUNTERS
1547     // =============================================================
1548 
1549     /**
1550      * @dev Returns the total number of tokens in existence.
1551      * Burned tokens will reduce the count.
1552      * To get the total number of tokens minted, please see {_totalMinted}.
1553      */
1554     function totalSupply() external view returns (uint256);
1555 
1556     // =============================================================
1557     //                            IERC165
1558     // =============================================================
1559 
1560     /**
1561      * @dev Returns true if this contract implements the interface defined by
1562      * `interfaceId`. See the corresponding
1563      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1564      * to learn more about how these ids are created.
1565      *
1566      * This function call must use less than 30000 gas.
1567      */
1568     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1569 
1570     // =============================================================
1571     //                            IERC721
1572     // =============================================================
1573 
1574     /**
1575      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1576      */
1577     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1578 
1579     /**
1580      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1581      */
1582     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1583 
1584     /**
1585      * @dev Emitted when `owner` enables or disables
1586      * (`approved`) `operator` to manage all of its assets.
1587      */
1588     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1589 
1590     /**
1591      * @dev Returns the number of tokens in `owner`'s account.
1592      */
1593     function balanceOf(address owner) external view returns (uint256 balance);
1594 
1595     /**
1596      * @dev Returns the owner of the `tokenId` token.
1597      *
1598      * Requirements:
1599      *
1600      * - `tokenId` must exist.
1601      */
1602     function ownerOf(uint256 tokenId) external view returns (address owner);
1603 
1604     /**
1605      * @dev Safely transfers `tokenId` token from `from` to `to`,
1606      * checking first that contract recipients are aware of the ERC721 protocol
1607      * to prevent tokens from being forever locked.
1608      *
1609      * Requirements:
1610      *
1611      * - `from` cannot be the zero address.
1612      * - `to` cannot be the zero address.
1613      * - `tokenId` token must exist and be owned by `from`.
1614      * - If the caller is not `from`, it must be have been allowed to move
1615      * this token by either {approve} or {setApprovalForAll}.
1616      * - If `to` refers to a smart contract, it must implement
1617      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1618      *
1619      * Emits a {Transfer} event.
1620      */
1621     function safeTransferFrom(
1622         address from,
1623         address to,
1624         uint256 tokenId,
1625         bytes calldata data
1626     ) external payable;
1627 
1628     /**
1629      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1630      */
1631     function safeTransferFrom(
1632         address from,
1633         address to,
1634         uint256 tokenId
1635     ) external payable;
1636 
1637     /**
1638      * @dev Transfers `tokenId` from `from` to `to`.
1639      *
1640      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1641      * whenever possible.
1642      *
1643      * Requirements:
1644      *
1645      * - `from` cannot be the zero address.
1646      * - `to` cannot be the zero address.
1647      * - `tokenId` token must be owned by `from`.
1648      * - If the caller is not `from`, it must be approved to move this token
1649      * by either {approve} or {setApprovalForAll}.
1650      *
1651      * Emits a {Transfer} event.
1652      */
1653     function transferFrom(
1654         address from,
1655         address to,
1656         uint256 tokenId
1657     ) external payable;
1658 
1659     /**
1660      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1661      * The approval is cleared when the token is transferred.
1662      *
1663      * Only a single account can be approved at a time, so approving the
1664      * zero address clears previous approvals.
1665      *
1666      * Requirements:
1667      *
1668      * - The caller must own the token or be an approved operator.
1669      * - `tokenId` must exist.
1670      *
1671      * Emits an {Approval} event.
1672      */
1673     function approve(address to, uint256 tokenId) external payable;
1674 
1675     /**
1676      * @dev Approve or remove `operator` as an operator for the caller.
1677      * Operators can call {transferFrom} or {safeTransferFrom}
1678      * for any token owned by the caller.
1679      *
1680      * Requirements:
1681      *
1682      * - The `operator` cannot be the caller.
1683      *
1684      * Emits an {ApprovalForAll} event.
1685      */
1686     function setApprovalForAll(address operator, bool _approved) external;
1687 
1688     /**
1689      * @dev Returns the account approved for `tokenId` token.
1690      *
1691      * Requirements:
1692      *
1693      * - `tokenId` must exist.
1694      */
1695     function getApproved(uint256 tokenId) external view returns (address operator);
1696 
1697     /**
1698      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1699      *
1700      * See {setApprovalForAll}.
1701      */
1702     function isApprovedForAll(address owner, address operator) external view returns (bool);
1703 
1704     // =============================================================
1705     //                        IERC721Metadata
1706     // =============================================================
1707 
1708     /**
1709      * @dev Returns the token collection name.
1710      */
1711     function name() external view returns (string memory);
1712 
1713     /**
1714      * @dev Returns the token collection symbol.
1715      */
1716     function symbol() external view returns (string memory);
1717 
1718     /**
1719      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1720      */
1721     function tokenURI(uint256 tokenId) external view returns (string memory);
1722 
1723     // =============================================================
1724     //                           IERC2309
1725     // =============================================================
1726 
1727     /**
1728      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1729      * (inclusive) is transferred from `from` to `to`, as defined in the
1730      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1731      *
1732      * See {_mintERC2309} for more details.
1733      */
1734     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1735 }
1736 
1737 // File: erc721a/contracts/ERC721A.sol
1738 
1739 
1740 // ERC721A Contracts v4.2.3
1741 // Creator: Chiru Labs
1742 
1743 pragma solidity ^0.8.4;
1744 
1745 
1746 /**
1747  * @dev Interface of ERC721 token receiver.
1748  */
1749 interface ERC721A__IERC721Receiver {
1750     function onERC721Received(
1751         address operator,
1752         address from,
1753         uint256 tokenId,
1754         bytes calldata data
1755     ) external returns (bytes4);
1756 }
1757 
1758 /**
1759  * @title ERC721A
1760  *
1761  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1762  * Non-Fungible Token Standard, including the Metadata extension.
1763  * Optimized for lower gas during batch mints.
1764  *
1765  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1766  * starting from `_startTokenId()`.
1767  *
1768  * Assumptions:
1769  *
1770  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1771  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1772  */
1773 contract ERC721A is IERC721A {
1774     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1775     struct TokenApprovalRef {
1776         address value;
1777     }
1778 
1779     // =============================================================
1780     //                           CONSTANTS
1781     // =============================================================
1782 
1783     // Mask of an entry in packed address data.
1784     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1785 
1786     // The bit position of `numberMinted` in packed address data.
1787     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1788 
1789     // The bit position of `numberBurned` in packed address data.
1790     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1791 
1792     // The bit position of `aux` in packed address data.
1793     uint256 private constant _BITPOS_AUX = 192;
1794 
1795     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1796     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1797 
1798     // The bit position of `startTimestamp` in packed ownership.
1799     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1800 
1801     // The bit mask of the `burned` bit in packed ownership.
1802     uint256 private constant _BITMASK_BURNED = 1 << 224;
1803 
1804     // The bit position of the `nextInitialized` bit in packed ownership.
1805     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1806 
1807     // The bit mask of the `nextInitialized` bit in packed ownership.
1808     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1809 
1810     // The bit position of `extraData` in packed ownership.
1811     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1812 
1813     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1814     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1815 
1816     // The mask of the lower 160 bits for addresses.
1817     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1818 
1819     // The maximum `quantity` that can be minted with {_mintERC2309}.
1820     // This limit is to prevent overflows on the address data entries.
1821     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1822     // is required to cause an overflow, which is unrealistic.
1823     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1824 
1825     // The `Transfer` event signature is given by:
1826     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1827     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1828         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1829 
1830     // =============================================================
1831     //                            STORAGE
1832     // =============================================================
1833 
1834     // The next token ID to be minted.
1835     uint256 private _currentIndex;
1836 
1837     // The number of tokens burned.
1838     uint256 private _burnCounter;
1839 
1840     // Token name
1841     string private _name;
1842 
1843     // Token symbol
1844     string private _symbol;
1845 
1846     // Mapping from token ID to ownership details
1847     // An empty struct value does not necessarily mean the token is unowned.
1848     // See {_packedOwnershipOf} implementation for details.
1849     //
1850     // Bits Layout:
1851     // - [0..159]   `addr`
1852     // - [160..223] `startTimestamp`
1853     // - [224]      `burned`
1854     // - [225]      `nextInitialized`
1855     // - [232..255] `extraData`
1856     mapping(uint256 => uint256) private _packedOwnerships;
1857 
1858     // Mapping owner address to address data.
1859     //
1860     // Bits Layout:
1861     // - [0..63]    `balance`
1862     // - [64..127]  `numberMinted`
1863     // - [128..191] `numberBurned`
1864     // - [192..255] `aux`
1865     mapping(address => uint256) private _packedAddressData;
1866 
1867     // Mapping from token ID to approved address.
1868     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1869 
1870     // Mapping from owner to operator approvals
1871     mapping(address => mapping(address => bool)) private _operatorApprovals;
1872 
1873     // =============================================================
1874     //                          CONSTRUCTOR
1875     // =============================================================
1876 
1877     constructor(string memory name_, string memory symbol_) {
1878         _name = name_;
1879         _symbol = symbol_;
1880         _currentIndex = _startTokenId();
1881     }
1882 
1883     // =============================================================
1884     //                   TOKEN COUNTING OPERATIONS
1885     // =============================================================
1886 
1887     /**
1888      * @dev Returns the starting token ID.
1889      * To change the starting token ID, please override this function.
1890      */
1891     function _startTokenId() internal view virtual returns (uint256) {
1892         return 0;
1893     }
1894 
1895     /**
1896      * @dev Returns the next token ID to be minted.
1897      */
1898     function _nextTokenId() internal view virtual returns (uint256) {
1899         return _currentIndex;
1900     }
1901 
1902     /**
1903      * @dev Returns the total number of tokens in existence.
1904      * Burned tokens will reduce the count.
1905      * To get the total number of tokens minted, please see {_totalMinted}.
1906      */
1907     function totalSupply() public view virtual override returns (uint256) {
1908         // Counter underflow is impossible as _burnCounter cannot be incremented
1909         // more than `_currentIndex - _startTokenId()` times.
1910         unchecked {
1911             return _currentIndex - _burnCounter - _startTokenId();
1912         }
1913     }
1914 
1915     /**
1916      * @dev Returns the total amount of tokens minted in the contract.
1917      */
1918     function _totalMinted() internal view virtual returns (uint256) {
1919         // Counter underflow is impossible as `_currentIndex` does not decrement,
1920         // and it is initialized to `_startTokenId()`.
1921         unchecked {
1922             return _currentIndex - _startTokenId();
1923         }
1924     }
1925 
1926     /**
1927      * @dev Returns the total number of tokens burned.
1928      */
1929     function _totalBurned() internal view virtual returns (uint256) {
1930         return _burnCounter;
1931     }
1932 
1933     // =============================================================
1934     //                    ADDRESS DATA OPERATIONS
1935     // =============================================================
1936 
1937     /**
1938      * @dev Returns the number of tokens in `owner`'s account.
1939      */
1940     function balanceOf(address owner) public view virtual override returns (uint256) {
1941         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1942         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1943     }
1944 
1945     /**
1946      * Returns the number of tokens minted by `owner`.
1947      */
1948     function _numberMinted(address owner) internal view returns (uint256) {
1949         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1950     }
1951 
1952     /**
1953      * Returns the number of tokens burned by or on behalf of `owner`.
1954      */
1955     function _numberBurned(address owner) internal view returns (uint256) {
1956         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1957     }
1958 
1959     /**
1960      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1961      */
1962     function _getAux(address owner) internal view returns (uint64) {
1963         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1964     }
1965 
1966     /**
1967      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1968      * If there are multiple variables, please pack them into a uint64.
1969      */
1970     function _setAux(address owner, uint64 aux) internal virtual {
1971         uint256 packed = _packedAddressData[owner];
1972         uint256 auxCasted;
1973         // Cast `aux` with assembly to avoid redundant masking.
1974         assembly {
1975             auxCasted := aux
1976         }
1977         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1978         _packedAddressData[owner] = packed;
1979     }
1980 
1981     // =============================================================
1982     //                            IERC165
1983     // =============================================================
1984 
1985     /**
1986      * @dev Returns true if this contract implements the interface defined by
1987      * `interfaceId`. See the corresponding
1988      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1989      * to learn more about how these ids are created.
1990      *
1991      * This function call must use less than 30000 gas.
1992      */
1993     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1994         // The interface IDs are constants representing the first 4 bytes
1995         // of the XOR of all function selectors in the interface.
1996         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1997         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1998         return
1999             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2000             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2001             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2002     }
2003 
2004     // =============================================================
2005     //                        IERC721Metadata
2006     // =============================================================
2007 
2008     /**
2009      * @dev Returns the token collection name.
2010      */
2011     function name() public view virtual override returns (string memory) {
2012         return _name;
2013     }
2014 
2015     /**
2016      * @dev Returns the token collection symbol.
2017      */
2018     function symbol() public view virtual override returns (string memory) {
2019         return _symbol;
2020     }
2021 
2022     /**
2023      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2024      */
2025     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2026         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2027 
2028         string memory baseURI = _baseURI();
2029         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2030     }
2031 
2032     /**
2033      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2034      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2035      * by default, it can be overridden in child contracts.
2036      */
2037     function _baseURI() internal view virtual returns (string memory) {
2038         return '';
2039     }
2040 
2041     // =============================================================
2042     //                     OWNERSHIPS OPERATIONS
2043     // =============================================================
2044 
2045     /**
2046      * @dev Returns the owner of the `tokenId` token.
2047      *
2048      * Requirements:
2049      *
2050      * - `tokenId` must exist.
2051      */
2052     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2053         return address(uint160(_packedOwnershipOf(tokenId)));
2054     }
2055 
2056     /**
2057      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2058      * It gradually moves to O(1) as tokens get transferred around over time.
2059      */
2060     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2061         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2062     }
2063 
2064     /**
2065      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2066      */
2067     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2068         return _unpackedOwnership(_packedOwnerships[index]);
2069     }
2070 
2071     /**
2072      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2073      */
2074     function _initializeOwnershipAt(uint256 index) internal virtual {
2075         if (_packedOwnerships[index] == 0) {
2076             _packedOwnerships[index] = _packedOwnershipOf(index);
2077         }
2078     }
2079 
2080     /**
2081      * Returns the packed ownership data of `tokenId`.
2082      */
2083     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2084         uint256 curr = tokenId;
2085 
2086         unchecked {
2087             if (_startTokenId() <= curr)
2088                 if (curr < _currentIndex) {
2089                     uint256 packed = _packedOwnerships[curr];
2090                     // If not burned.
2091                     if (packed & _BITMASK_BURNED == 0) {
2092                         // Invariant:
2093                         // There will always be an initialized ownership slot
2094                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2095                         // before an unintialized ownership slot
2096                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2097                         // Hence, `curr` will not underflow.
2098                         //
2099                         // We can directly compare the packed value.
2100                         // If the address is zero, packed will be zero.
2101                         while (packed == 0) {
2102                             packed = _packedOwnerships[--curr];
2103                         }
2104                         return packed;
2105                     }
2106                 }
2107         }
2108         revert OwnerQueryForNonexistentToken();
2109     }
2110 
2111     /**
2112      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2113      */
2114     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2115         ownership.addr = address(uint160(packed));
2116         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2117         ownership.burned = packed & _BITMASK_BURNED != 0;
2118         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2119     }
2120 
2121     /**
2122      * @dev Packs ownership data into a single uint256.
2123      */
2124     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2125         assembly {
2126             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2127             owner := and(owner, _BITMASK_ADDRESS)
2128             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2129             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2130         }
2131     }
2132 
2133     /**
2134      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2135      */
2136     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2137         // For branchless setting of the `nextInitialized` flag.
2138         assembly {
2139             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2140             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2141         }
2142     }
2143 
2144     // =============================================================
2145     //                      APPROVAL OPERATIONS
2146     // =============================================================
2147 
2148     /**
2149      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2150      * The approval is cleared when the token is transferred.
2151      *
2152      * Only a single account can be approved at a time, so approving the
2153      * zero address clears previous approvals.
2154      *
2155      * Requirements:
2156      *
2157      * - The caller must own the token or be an approved operator.
2158      * - `tokenId` must exist.
2159      *
2160      * Emits an {Approval} event.
2161      */
2162     function approve(address to, uint256 tokenId) public payable virtual override {
2163         address owner = ownerOf(tokenId);
2164 
2165         if (_msgSenderERC721A() != owner)
2166             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2167                 revert ApprovalCallerNotOwnerNorApproved();
2168             }
2169 
2170         _tokenApprovals[tokenId].value = to;
2171         emit Approval(owner, to, tokenId);
2172     }
2173 
2174     /**
2175      * @dev Returns the account approved for `tokenId` token.
2176      *
2177      * Requirements:
2178      *
2179      * - `tokenId` must exist.
2180      */
2181     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2182         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2183 
2184         return _tokenApprovals[tokenId].value;
2185     }
2186 
2187     /**
2188      * @dev Approve or remove `operator` as an operator for the caller.
2189      * Operators can call {transferFrom} or {safeTransferFrom}
2190      * for any token owned by the caller.
2191      *
2192      * Requirements:
2193      *
2194      * - The `operator` cannot be the caller.
2195      *
2196      * Emits an {ApprovalForAll} event.
2197      */
2198     function setApprovalForAll(address operator, bool approved) public virtual override {
2199         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2200         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2201     }
2202 
2203     /**
2204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2205      *
2206      * See {setApprovalForAll}.
2207      */
2208     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2209         return _operatorApprovals[owner][operator];
2210     }
2211 
2212     /**
2213      * @dev Returns whether `tokenId` exists.
2214      *
2215      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2216      *
2217      * Tokens start existing when they are minted. See {_mint}.
2218      */
2219     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2220         return
2221             _startTokenId() <= tokenId &&
2222             tokenId < _currentIndex && // If within bounds,
2223             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2224     }
2225 
2226     /**
2227      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2228      */
2229     function _isSenderApprovedOrOwner(
2230         address approvedAddress,
2231         address owner,
2232         address msgSender
2233     ) private pure returns (bool result) {
2234         assembly {
2235             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2236             owner := and(owner, _BITMASK_ADDRESS)
2237             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2238             msgSender := and(msgSender, _BITMASK_ADDRESS)
2239             // `msgSender == owner || msgSender == approvedAddress`.
2240             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2241         }
2242     }
2243 
2244     /**
2245      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2246      */
2247     function _getApprovedSlotAndAddress(uint256 tokenId)
2248         private
2249         view
2250         returns (uint256 approvedAddressSlot, address approvedAddress)
2251     {
2252         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2253         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2254         assembly {
2255             approvedAddressSlot := tokenApproval.slot
2256             approvedAddress := sload(approvedAddressSlot)
2257         }
2258     }
2259 
2260     // =============================================================
2261     //                      TRANSFER OPERATIONS
2262     // =============================================================
2263 
2264     /**
2265      * @dev Transfers `tokenId` from `from` to `to`.
2266      *
2267      * Requirements:
2268      *
2269      * - `from` cannot be the zero address.
2270      * - `to` cannot be the zero address.
2271      * - `tokenId` token must be owned by `from`.
2272      * - If the caller is not `from`, it must be approved to move this token
2273      * by either {approve} or {setApprovalForAll}.
2274      *
2275      * Emits a {Transfer} event.
2276      */
2277     function transferFrom(
2278         address from,
2279         address to,
2280         uint256 tokenId
2281     ) public payable virtual override {
2282         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2283 
2284         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2285 
2286         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2287 
2288         // The nested ifs save around 20+ gas over a compound boolean condition.
2289         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2290             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2291 
2292         if (to == address(0)) revert TransferToZeroAddress();
2293 
2294         _beforeTokenTransfers(from, to, tokenId, 1);
2295 
2296         // Clear approvals from the previous owner.
2297         assembly {
2298             if approvedAddress {
2299                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2300                 sstore(approvedAddressSlot, 0)
2301             }
2302         }
2303 
2304         // Underflow of the sender's balance is impossible because we check for
2305         // ownership above and the recipient's balance can't realistically overflow.
2306         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2307         unchecked {
2308             // We can directly increment and decrement the balances.
2309             --_packedAddressData[from]; // Updates: `balance -= 1`.
2310             ++_packedAddressData[to]; // Updates: `balance += 1`.
2311 
2312             // Updates:
2313             // - `address` to the next owner.
2314             // - `startTimestamp` to the timestamp of transfering.
2315             // - `burned` to `false`.
2316             // - `nextInitialized` to `true`.
2317             _packedOwnerships[tokenId] = _packOwnershipData(
2318                 to,
2319                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2320             );
2321 
2322             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2323             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2324                 uint256 nextTokenId = tokenId + 1;
2325                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2326                 if (_packedOwnerships[nextTokenId] == 0) {
2327                     // If the next slot is within bounds.
2328                     if (nextTokenId != _currentIndex) {
2329                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2330                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2331                     }
2332                 }
2333             }
2334         }
2335 
2336         emit Transfer(from, to, tokenId);
2337         _afterTokenTransfers(from, to, tokenId, 1);
2338     }
2339 
2340     /**
2341      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2342      */
2343     function safeTransferFrom(
2344         address from,
2345         address to,
2346         uint256 tokenId
2347     ) public payable virtual override {
2348         safeTransferFrom(from, to, tokenId, '');
2349     }
2350 
2351     /**
2352      * @dev Safely transfers `tokenId` token from `from` to `to`.
2353      *
2354      * Requirements:
2355      *
2356      * - `from` cannot be the zero address.
2357      * - `to` cannot be the zero address.
2358      * - `tokenId` token must exist and be owned by `from`.
2359      * - If the caller is not `from`, it must be approved to move this token
2360      * by either {approve} or {setApprovalForAll}.
2361      * - If `to` refers to a smart contract, it must implement
2362      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2363      *
2364      * Emits a {Transfer} event.
2365      */
2366     function safeTransferFrom(
2367         address from,
2368         address to,
2369         uint256 tokenId,
2370         bytes memory _data
2371     ) public payable virtual override {
2372         transferFrom(from, to, tokenId);
2373         if (to.code.length != 0)
2374             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2375                 revert TransferToNonERC721ReceiverImplementer();
2376             }
2377     }
2378 
2379     /**
2380      * @dev Hook that is called before a set of serially-ordered token IDs
2381      * are about to be transferred. This includes minting.
2382      * And also called before burning one token.
2383      *
2384      * `startTokenId` - the first token ID to be transferred.
2385      * `quantity` - the amount to be transferred.
2386      *
2387      * Calling conditions:
2388      *
2389      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2390      * transferred to `to`.
2391      * - When `from` is zero, `tokenId` will be minted for `to`.
2392      * - When `to` is zero, `tokenId` will be burned by `from`.
2393      * - `from` and `to` are never both zero.
2394      */
2395     function _beforeTokenTransfers(
2396         address from,
2397         address to,
2398         uint256 startTokenId,
2399         uint256 quantity
2400     ) internal virtual {}
2401 
2402     /**
2403      * @dev Hook that is called after a set of serially-ordered token IDs
2404      * have been transferred. This includes minting.
2405      * And also called after one token has been burned.
2406      *
2407      * `startTokenId` - the first token ID to be transferred.
2408      * `quantity` - the amount to be transferred.
2409      *
2410      * Calling conditions:
2411      *
2412      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2413      * transferred to `to`.
2414      * - When `from` is zero, `tokenId` has been minted for `to`.
2415      * - When `to` is zero, `tokenId` has been burned by `from`.
2416      * - `from` and `to` are never both zero.
2417      */
2418     function _afterTokenTransfers(
2419         address from,
2420         address to,
2421         uint256 startTokenId,
2422         uint256 quantity
2423     ) internal virtual {}
2424 
2425     /**
2426      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2427      *
2428      * `from` - Previous owner of the given token ID.
2429      * `to` - Target address that will receive the token.
2430      * `tokenId` - Token ID to be transferred.
2431      * `_data` - Optional data to send along with the call.
2432      *
2433      * Returns whether the call correctly returned the expected magic value.
2434      */
2435     function _checkContractOnERC721Received(
2436         address from,
2437         address to,
2438         uint256 tokenId,
2439         bytes memory _data
2440     ) private returns (bool) {
2441         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2442             bytes4 retval
2443         ) {
2444             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2445         } catch (bytes memory reason) {
2446             if (reason.length == 0) {
2447                 revert TransferToNonERC721ReceiverImplementer();
2448             } else {
2449                 assembly {
2450                     revert(add(32, reason), mload(reason))
2451                 }
2452             }
2453         }
2454     }
2455 
2456     // =============================================================
2457     //                        MINT OPERATIONS
2458     // =============================================================
2459 
2460     /**
2461      * @dev Mints `quantity` tokens and transfers them to `to`.
2462      *
2463      * Requirements:
2464      *
2465      * - `to` cannot be the zero address.
2466      * - `quantity` must be greater than 0.
2467      *
2468      * Emits a {Transfer} event for each mint.
2469      */
2470     function _mint(address to, uint256 quantity) internal virtual {
2471         uint256 startTokenId = _currentIndex;
2472         if (quantity == 0) revert MintZeroQuantity();
2473 
2474         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2475 
2476         // Overflows are incredibly unrealistic.
2477         // `balance` and `numberMinted` have a maximum limit of 2**64.
2478         // `tokenId` has a maximum limit of 2**256.
2479         unchecked {
2480             // Updates:
2481             // - `balance += quantity`.
2482             // - `numberMinted += quantity`.
2483             //
2484             // We can directly add to the `balance` and `numberMinted`.
2485             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2486 
2487             // Updates:
2488             // - `address` to the owner.
2489             // - `startTimestamp` to the timestamp of minting.
2490             // - `burned` to `false`.
2491             // - `nextInitialized` to `quantity == 1`.
2492             _packedOwnerships[startTokenId] = _packOwnershipData(
2493                 to,
2494                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2495             );
2496 
2497             uint256 toMasked;
2498             uint256 end = startTokenId + quantity;
2499 
2500             // Use assembly to loop and emit the `Transfer` event for gas savings.
2501             // The duplicated `log4` removes an extra check and reduces stack juggling.
2502             // The assembly, together with the surrounding Solidity code, have been
2503             // delicately arranged to nudge the compiler into producing optimized opcodes.
2504             assembly {
2505                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2506                 toMasked := and(to, _BITMASK_ADDRESS)
2507                 // Emit the `Transfer` event.
2508                 log4(
2509                     0, // Start of data (0, since no data).
2510                     0, // End of data (0, since no data).
2511                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2512                     0, // `address(0)`.
2513                     toMasked, // `to`.
2514                     startTokenId // `tokenId`.
2515                 )
2516 
2517                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2518                 // that overflows uint256 will make the loop run out of gas.
2519                 // The compiler will optimize the `iszero` away for performance.
2520                 for {
2521                     let tokenId := add(startTokenId, 1)
2522                 } iszero(eq(tokenId, end)) {
2523                     tokenId := add(tokenId, 1)
2524                 } {
2525                     // Emit the `Transfer` event. Similar to above.
2526                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2527                 }
2528             }
2529             if (toMasked == 0) revert MintToZeroAddress();
2530 
2531             _currentIndex = end;
2532         }
2533         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2534     }
2535 
2536     /**
2537      * @dev Mints `quantity` tokens and transfers them to `to`.
2538      *
2539      * This function is intended for efficient minting only during contract creation.
2540      *
2541      * It emits only one {ConsecutiveTransfer} as defined in
2542      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2543      * instead of a sequence of {Transfer} event(s).
2544      *
2545      * Calling this function outside of contract creation WILL make your contract
2546      * non-compliant with the ERC721 standard.
2547      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2548      * {ConsecutiveTransfer} event is only permissible during contract creation.
2549      *
2550      * Requirements:
2551      *
2552      * - `to` cannot be the zero address.
2553      * - `quantity` must be greater than 0.
2554      *
2555      * Emits a {ConsecutiveTransfer} event.
2556      */
2557     function _mintERC2309(address to, uint256 quantity) internal virtual {
2558         uint256 startTokenId = _currentIndex;
2559         if (to == address(0)) revert MintToZeroAddress();
2560         if (quantity == 0) revert MintZeroQuantity();
2561         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2562 
2563         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2564 
2565         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2566         unchecked {
2567             // Updates:
2568             // - `balance += quantity`.
2569             // - `numberMinted += quantity`.
2570             //
2571             // We can directly add to the `balance` and `numberMinted`.
2572             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2573 
2574             // Updates:
2575             // - `address` to the owner.
2576             // - `startTimestamp` to the timestamp of minting.
2577             // - `burned` to `false`.
2578             // - `nextInitialized` to `quantity == 1`.
2579             _packedOwnerships[startTokenId] = _packOwnershipData(
2580                 to,
2581                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2582             );
2583 
2584             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2585 
2586             _currentIndex = startTokenId + quantity;
2587         }
2588         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2589     }
2590 
2591     /**
2592      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2593      *
2594      * Requirements:
2595      *
2596      * - If `to` refers to a smart contract, it must implement
2597      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2598      * - `quantity` must be greater than 0.
2599      *
2600      * See {_mint}.
2601      *
2602      * Emits a {Transfer} event for each mint.
2603      */
2604     function _safeMint(
2605         address to,
2606         uint256 quantity,
2607         bytes memory _data
2608     ) internal virtual {
2609         _mint(to, quantity);
2610 
2611         unchecked {
2612             if (to.code.length != 0) {
2613                 uint256 end = _currentIndex;
2614                 uint256 index = end - quantity;
2615                 do {
2616                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2617                         revert TransferToNonERC721ReceiverImplementer();
2618                     }
2619                 } while (index < end);
2620                 // Reentrancy protection.
2621                 if (_currentIndex != end) revert();
2622             }
2623         }
2624     }
2625 
2626     /**
2627      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2628      */
2629     function _safeMint(address to, uint256 quantity) internal virtual {
2630         _safeMint(to, quantity, '');
2631     }
2632 
2633     // =============================================================
2634     //                        BURN OPERATIONS
2635     // =============================================================
2636 
2637     /**
2638      * @dev Equivalent to `_burn(tokenId, false)`.
2639      */
2640     function _burn(uint256 tokenId) internal virtual {
2641         _burn(tokenId, false);
2642     }
2643 
2644     /**
2645      * @dev Destroys `tokenId`.
2646      * The approval is cleared when the token is burned.
2647      *
2648      * Requirements:
2649      *
2650      * - `tokenId` must exist.
2651      *
2652      * Emits a {Transfer} event.
2653      */
2654     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2655         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2656 
2657         address from = address(uint160(prevOwnershipPacked));
2658 
2659         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2660 
2661         if (approvalCheck) {
2662             // The nested ifs save around 20+ gas over a compound boolean condition.
2663             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2664                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2665         }
2666 
2667         _beforeTokenTransfers(from, address(0), tokenId, 1);
2668 
2669         // Clear approvals from the previous owner.
2670         assembly {
2671             if approvedAddress {
2672                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2673                 sstore(approvedAddressSlot, 0)
2674             }
2675         }
2676 
2677         // Underflow of the sender's balance is impossible because we check for
2678         // ownership above and the recipient's balance can't realistically overflow.
2679         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2680         unchecked {
2681             // Updates:
2682             // - `balance -= 1`.
2683             // - `numberBurned += 1`.
2684             //
2685             // We can directly decrement the balance, and increment the number burned.
2686             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2687             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2688 
2689             // Updates:
2690             // - `address` to the last owner.
2691             // - `startTimestamp` to the timestamp of burning.
2692             // - `burned` to `true`.
2693             // - `nextInitialized` to `true`.
2694             _packedOwnerships[tokenId] = _packOwnershipData(
2695                 from,
2696                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2697             );
2698 
2699             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2700             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2701                 uint256 nextTokenId = tokenId + 1;
2702                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2703                 if (_packedOwnerships[nextTokenId] == 0) {
2704                     // If the next slot is within bounds.
2705                     if (nextTokenId != _currentIndex) {
2706                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2707                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2708                     }
2709                 }
2710             }
2711         }
2712 
2713         emit Transfer(from, address(0), tokenId);
2714         _afterTokenTransfers(from, address(0), tokenId, 1);
2715 
2716         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2717         unchecked {
2718             _burnCounter++;
2719         }
2720     }
2721 
2722     // =============================================================
2723     //                     EXTRA DATA OPERATIONS
2724     // =============================================================
2725 
2726     /**
2727      * @dev Directly sets the extra data for the ownership data `index`.
2728      */
2729     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2730         uint256 packed = _packedOwnerships[index];
2731         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2732         uint256 extraDataCasted;
2733         // Cast `extraData` with assembly to avoid redundant masking.
2734         assembly {
2735             extraDataCasted := extraData
2736         }
2737         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2738         _packedOwnerships[index] = packed;
2739     }
2740 
2741     /**
2742      * @dev Called during each token transfer to set the 24bit `extraData` field.
2743      * Intended to be overridden by the cosumer contract.
2744      *
2745      * `previousExtraData` - the value of `extraData` before transfer.
2746      *
2747      * Calling conditions:
2748      *
2749      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2750      * transferred to `to`.
2751      * - When `from` is zero, `tokenId` will be minted for `to`.
2752      * - When `to` is zero, `tokenId` will be burned by `from`.
2753      * - `from` and `to` are never both zero.
2754      */
2755     function _extraData(
2756         address from,
2757         address to,
2758         uint24 previousExtraData
2759     ) internal view virtual returns (uint24) {}
2760 
2761     /**
2762      * @dev Returns the next extra data for the packed ownership data.
2763      * The returned result is shifted into position.
2764      */
2765     function _nextExtraData(
2766         address from,
2767         address to,
2768         uint256 prevOwnershipPacked
2769     ) private view returns (uint256) {
2770         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2771         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2772     }
2773 
2774     // =============================================================
2775     //                       OTHER OPERATIONS
2776     // =============================================================
2777 
2778     /**
2779      * @dev Returns the message sender (defaults to `msg.sender`).
2780      *
2781      * If you are writing GSN compatible contracts, you need to override this function.
2782      */
2783     function _msgSenderERC721A() internal view virtual returns (address) {
2784         return msg.sender;
2785     }
2786 
2787     /**
2788      * @dev Converts a uint256 to its ASCII string decimal representation.
2789      */
2790     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2791         assembly {
2792             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2793             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2794             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2795             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2796             let m := add(mload(0x40), 0xa0)
2797             // Update the free memory pointer to allocate.
2798             mstore(0x40, m)
2799             // Assign the `str` to the end.
2800             str := sub(m, 0x20)
2801             // Zeroize the slot after the string.
2802             mstore(str, 0)
2803 
2804             // Cache the end of the memory to calculate the length later.
2805             let end := str
2806 
2807             // We write the string from rightmost digit to leftmost digit.
2808             // The following is essentially a do-while loop that also handles the zero case.
2809             // prettier-ignore
2810             for { let temp := value } 1 {} {
2811                 str := sub(str, 1)
2812                 // Write the character to the pointer.
2813                 // The ASCII index of the '0' character is 48.
2814                 mstore8(str, add(48, mod(temp, 10)))
2815                 // Keep dividing `temp` until zero.
2816                 temp := div(temp, 10)
2817                 // prettier-ignore
2818                 if iszero(temp) { break }
2819             }
2820 
2821             let length := sub(end, str)
2822             // Move the pointer 32 bytes leftwards to make room for the length.
2823             str := sub(str, 0x20)
2824             // Store the length.
2825             mstore(str, length)
2826         }
2827     }
2828 }
2829 
2830 // File: contract.sol
2831 
2832 
2833 pragma solidity ^0.8.18;
2834 
2835 contract BulliesGenesis is
2836     ERC721A("Bullies Genesis", "Bullies"),
2837     ERC2981,
2838     DefaultOperatorFilterer,
2839     Ownable
2840 {
2841     using Strings for uint256;
2842     using ECDSA for bytes32;
2843 
2844     uint256 public tokensMintedCounter;
2845     string private baseURI =
2846         "https://turquoise-left-fowl-953.mypinata.cloud/ipfs/QmSh6JUhd7vHjLcRebno4WsH85Wq8H2KQWVjymxgM1PnPb/";
2847     address private privateSigner = 0x04003eF479265d1f447097bD7833Ad66871e6cEF;
2848     bool private freezed = true;
2849     uint256 private maxSupply = 10000;
2850     uint256 private PUBLIC_PRICE = 0.06 ether;
2851     uint256 private EB_PRICE = 0.05 ether;
2852     uint256 private OG_PRICE = 0.06 ether;
2853     uint256 private WL_PRICE = 0.06 ether;
2854 
2855     uint256 private WALLET_MAX = 5;
2856 
2857     bool public PUBLIC_MINT_LIVE;
2858     bool public EB_MINT_LIVE;
2859     bool public OG_MINT_LIVE;
2860     bool public WL_MINT_LIVE;
2861 
2862     mapping(address => uint256) public EB_MINTERS;
2863     mapping(address => uint256) public OG_MINTERS;
2864     mapping(address => uint256) public WL_MINTERS;
2865 
2866     modifier notFrozen() {
2867         require(freezed == false, "FROZEN");
2868         _;
2869     }
2870 
2871     modifier notContract() {
2872         require(
2873             (!_isContract(msg.sender)) && (msg.sender == tx.origin),
2874             "NOT_ALLOWED"
2875         );
2876         _;
2877     }
2878 
2879     function _isContract(address addr) internal view returns (bool) {
2880         uint256 size;
2881         assembly {
2882             size := extcodesize(addr)
2883         }
2884         return size > 0;
2885     }
2886 
2887     function _startTokenId() internal view virtual override returns (uint256) {
2888         return 1;
2889     }
2890 
2891     function matchAddresSigner(
2892         bytes memory signature,
2893         string memory sigWord
2894     ) private view returns (bool) {
2895         bytes32 hash = keccak256(
2896             abi.encodePacked(
2897                 "\x19Ethereum Signed Message:\n32",
2898                 keccak256(abi.encodePacked(msg.sender, sigWord))
2899             )
2900         );
2901         return privateSigner == hash.recover(signature);
2902     }
2903 
2904     function mint(uint256 tokenQuantity) external payable notContract {
2905         require(PUBLIC_MINT_LIVE, "PUBLIC_MINT_CLOSED");
2906         require(
2907             tokensMintedCounter + tokenQuantity <= maxSupply,
2908             "EXCEED_SUPPLY"
2909         );
2910         require(PUBLIC_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2911         tokensMintedCounter += tokenQuantity;
2912         _mint(msg.sender, tokenQuantity);
2913     }
2914 
2915     function EB_MINT(
2916         uint256 tokenQuantity,
2917         bytes memory signature
2918     ) external payable notContract {
2919         require(EB_MINT_LIVE, "EB_MINT_CLOSED");
2920         require(
2921             tokensMintedCounter + tokenQuantity <= maxSupply,
2922             "EXCEED_SUPPLY"
2923         );
2924         require(
2925             matchAddresSigner(signature, "BULLIES-EB"),
2926             "INVALID_SIGNATURE"
2927         );
2928         require(
2929             EB_MINTERS[msg.sender] + tokenQuantity <= WALLET_MAX,
2930             "EXCEED_PER_WALLET"
2931         );
2932         require(EB_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2933 
2934         EB_MINTERS[msg.sender] = EB_MINTERS[msg.sender] + tokenQuantity;
2935         tokensMintedCounter += tokenQuantity;
2936         _mint(msg.sender, tokenQuantity);
2937     }
2938 
2939     function OG_MINT(
2940         uint256 tokenQuantity,
2941         bytes memory signature
2942     ) external payable notContract {
2943         require(OG_MINT_LIVE, "OG_MINT_CLOSED");
2944         require(
2945             tokensMintedCounter + tokenQuantity <= maxSupply,
2946             "EXCEED_SUPPLY"
2947         );
2948         require(
2949             matchAddresSigner(signature, "BULLIES-OG"),
2950             "INVALID_SIGNATURE"
2951         );
2952         require(
2953             OG_MINTERS[msg.sender] + tokenQuantity <= WALLET_MAX,
2954             "EXCEED_PER_WALLET"
2955         );
2956         require(OG_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2957 
2958         OG_MINTERS[msg.sender] = OG_MINTERS[msg.sender] + tokenQuantity;
2959         tokensMintedCounter += tokenQuantity;
2960         _mint(msg.sender, tokenQuantity);
2961     }
2962 
2963     function WL_MINT(
2964         uint256 tokenQuantity,
2965         bytes memory signature
2966     ) external payable notContract {
2967         require(WL_MINT_LIVE, "WL_MINT_CLOSED");
2968         require(
2969             tokensMintedCounter + tokenQuantity <= maxSupply,
2970             "EXCEED_SUPPLY"
2971         );
2972         require(
2973             matchAddresSigner(signature, "BULLIES-WL"),
2974             "INVALID_SIGNATURE"
2975         );
2976         require(
2977             WL_MINTERS[msg.sender] + tokenQuantity <= WALLET_MAX,
2978             "EXCEED_PER_WALLET"
2979         );
2980         require(WL_PRICE * tokenQuantity <= msg.value, "INSUFFICIENT_ETH");
2981 
2982         WL_MINTERS[msg.sender] = WL_MINTERS[msg.sender] + tokenQuantity;
2983         tokensMintedCounter += tokenQuantity;
2984         _mint(msg.sender, tokenQuantity);
2985     }
2986 
2987     function tokenURI(
2988         uint256 tokenId
2989     ) public view override(ERC721A) returns (string memory) {
2990         require(_exists(tokenId), "Cannot query non-existent token");
2991         return string(abi.encodePacked(baseURI, tokenId.toString()));
2992     }
2993 
2994     function _baseURI() internal view virtual override returns (string memory) {
2995         return baseURI;
2996     }
2997 
2998     function tokensOwnedBy(
2999         address owner
3000     ) external view returns (uint256[] memory) {
3001         uint256[] memory tokensList = new uint256[](balanceOf(owner));
3002         uint256 currentIndex;
3003         for (uint256 index = 1; index <= tokensMintedCounter; index++) {
3004             if (ownerOf(index) == owner) {
3005                 tokensList[currentIndex] = uint256(index);
3006                 currentIndex++;
3007             }
3008         }
3009         return tokensList;
3010     }
3011 
3012     function gift(address[] calldata receivers) external onlyOwner {
3013         require(
3014             tokensMintedCounter + receivers.length <= maxSupply,
3015             "EXCEED_SUPPLY"
3016         );
3017 
3018         tokensMintedCounter += receivers.length;
3019         for (uint i = 0; i < receivers.length; i++) {
3020             _mint(receivers[i], 1);
3021         }
3022     }
3023 
3024     function founderMint(uint256 tokenQuantity) external onlyOwner {
3025         require(
3026             tokensMintedCounter + tokenQuantity <= maxSupply,
3027             "EXCEED_SUPPLY"
3028         );
3029         tokensMintedCounter += tokenQuantity;
3030         _mint(msg.sender, tokenQuantity);
3031     }
3032 
3033     function togglePublicMint() external onlyOwner {
3034         PUBLIC_MINT_LIVE = !PUBLIC_MINT_LIVE;
3035     }
3036 
3037     function toggleEBMint() external onlyOwner {
3038         EB_MINT_LIVE = !EB_MINT_LIVE;
3039     }
3040 
3041     function toggleOGMint() external onlyOwner {
3042         OG_MINT_LIVE = !OG_MINT_LIVE;
3043     }
3044 
3045     function toggleWLMint() external onlyOwner {
3046         WL_MINT_LIVE = !WL_MINT_LIVE;
3047     }
3048 
3049     function setPublicPrice(uint256 newPrice) external onlyOwner {
3050         PUBLIC_PRICE = newPrice;
3051     }
3052 
3053     function setEBPrice(uint256 newPrice) external onlyOwner {
3054         EB_PRICE = newPrice;
3055     }
3056 
3057     function setOGPrice(uint256 newPrice) external onlyOwner {
3058         OG_PRICE = newPrice;
3059     }
3060 
3061     function setWLPrice(uint256 newPrice) external onlyOwner {
3062         WL_PRICE = newPrice;
3063     }
3064 
3065     function setWalletMax(uint256 newCount) external onlyOwner {
3066         WALLET_MAX = newCount;
3067     }
3068 
3069     function setSupplyMax(uint256 newCount) external onlyOwner {
3070         maxSupply = newCount;
3071     }
3072 
3073     function setSigner(address newAddress) external onlyOwner {
3074         privateSigner = newAddress;
3075     }
3076 
3077     function setBaseURI(string calldata newBaseURI) external onlyOwner {
3078         baseURI = newBaseURI;
3079     }
3080 
3081     function freeze() external onlyOwner {
3082         require(block.timestamp < 1680000000, "CANT_FREEZE");
3083         freezed = true;
3084     }
3085 
3086     function unfreeze() external onlyOwner {
3087         freezed = false;
3088     }
3089 
3090     function withdraw() external onlyOwner {
3091         uint256 currentBalance = address(this).balance;
3092         Address.sendValue(
3093             payable(0xF00151568E332F3476d80807eF2c2b99F9F777ad),
3094             (currentBalance * 125) / 1000
3095         );
3096         Address.sendValue(
3097             payable(0x4489b64a34AF33a3f06d82588FD312870ff15cea),
3098             (currentBalance * 125) / 1000
3099         );
3100         Address.sendValue(
3101             payable(0xc87408D57416EfdCd53b0ee905c74fd45B61e4Df),
3102             (currentBalance * 125) / 1000
3103         );
3104         Address.sendValue(
3105             payable(0xb49A027C51219ae4043E37eE45C71E1F2E3f8FBC),
3106             (currentBalance * 125) / 1000
3107         );
3108 
3109         Address.sendValue(
3110             payable(0x00000040f69B8E3382734491cBAA241B6a863AB3),
3111             (currentBalance * 70) / 1000
3112         );
3113 
3114         Address.sendValue(
3115             payable(0xaE1A33E8C8E0aB24f744D43f8e187Aca5B45b8D3),
3116             (currentBalance * 30) / 1000
3117         );
3118         Address.sendValue(
3119             payable(0xF4741D21C4D31dF6551733613415C8873ea958cF),
3120             address(this).balance
3121         );
3122     }
3123 
3124     receive() external payable {}
3125 
3126     function setApprovalForAll(
3127         address operator,
3128         bool approved
3129     ) public override notFrozen onlyAllowedOperatorApproval(operator) {
3130         super.setApprovalForAll(operator, approved);
3131     }
3132 
3133     function approve(
3134         address operator,
3135         uint256 tokenId
3136     ) public payable override notFrozen onlyAllowedOperatorApproval(operator) {
3137         super.approve(operator, tokenId);
3138     }
3139 
3140     function transferFrom(
3141         address from,
3142         address to,
3143         uint256 tokenId
3144     ) public payable override notFrozen onlyAllowedOperator(from) {
3145         super.transferFrom(from, to, tokenId);
3146     }
3147 
3148     function safeTransferFrom(
3149         address from,
3150         address to,
3151         uint256 tokenId
3152     ) public payable override notFrozen onlyAllowedOperator(from) {
3153         super.safeTransferFrom(from, to, tokenId);
3154     }
3155 
3156     function safeTransferFrom(
3157         address from,
3158         address to,
3159         uint256 tokenId,
3160         bytes memory data
3161     ) public payable override notFrozen onlyAllowedOperator(from) {
3162         super.safeTransferFrom(from, to, tokenId, data);
3163     }
3164 
3165     function supportsInterface(
3166         bytes4 interfaceId
3167     ) public view virtual override(ERC721A, ERC2981) returns (bool) {
3168         return super.supportsInterface(interfaceId);
3169     }
3170 }