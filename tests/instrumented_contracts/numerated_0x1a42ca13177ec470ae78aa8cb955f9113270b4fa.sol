1 // SPDX-License-Identifier: MIT LICENSE
2 
3 // File: @openzeppelin/contracts/utils/math/Math.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Standard math utilities missing in the Solidity language.
12  */
13 library Math {
14     enum Rounding {
15         Down, // Toward negative infinity
16         Up, // Toward infinity
17         Zero // Toward zero
18     }
19 
20     /**
21      * @dev Returns the largest of two numbers.
22      */
23     function max(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a > b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the smallest of two numbers.
29      */
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     /**
35      * @dev Returns the average of two numbers. The result is rounded towards
36      * zero.
37      */
38     function average(uint256 a, uint256 b) internal pure returns (uint256) {
39         // (a + b) / 2 can overflow.
40         return (a & b) + (a ^ b) / 2;
41     }
42 
43     /**
44      * @dev Returns the ceiling of the division of two numbers.
45      *
46      * This differs from standard division with `/` in that it rounds up instead
47      * of rounding down.
48      */
49     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b - 1) / b can overflow on addition, so we distribute.
51         return a == 0 ? 0 : (a - 1) / b + 1;
52     }
53 
54     /**
55      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
56      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
57      * with further edits by Uniswap Labs also under MIT license.
58      */
59     function mulDiv(
60         uint256 x,
61         uint256 y,
62         uint256 denominator
63     ) internal pure returns (uint256 result) {
64         unchecked {
65             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
66             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
67             // variables such that product = prod1 * 2^256 + prod0.
68             uint256 prod0; // Least significant 256 bits of the product
69             uint256 prod1; // Most significant 256 bits of the product
70             assembly {
71                 let mm := mulmod(x, y, not(0))
72                 prod0 := mul(x, y)
73                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
74             }
75 
76             // Handle non-overflow cases, 256 by 256 division.
77             if (prod1 == 0) {
78                 return prod0 / denominator;
79             }
80 
81             // Make sure the result is less than 2^256. Also prevents denominator == 0.
82             require(denominator > prod1);
83 
84             ///////////////////////////////////////////////
85             // 512 by 256 division.
86             ///////////////////////////////////////////////
87 
88             // Make division exact by subtracting the remainder from [prod1 prod0].
89             uint256 remainder;
90             assembly {
91                 // Compute remainder using mulmod.
92                 remainder := mulmod(x, y, denominator)
93 
94                 // Subtract 256 bit number from 512 bit number.
95                 prod1 := sub(prod1, gt(remainder, prod0))
96                 prod0 := sub(prod0, remainder)
97             }
98 
99             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
100             // See https://cs.stackexchange.com/q/138556/92363.
101 
102             // Does not overflow because the denominator cannot be zero at this stage in the function.
103             uint256 twos = denominator & (~denominator + 1);
104             assembly {
105                 // Divide denominator by twos.
106                 denominator := div(denominator, twos)
107 
108                 // Divide [prod1 prod0] by twos.
109                 prod0 := div(prod0, twos)
110 
111                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
112                 twos := add(div(sub(0, twos), twos), 1)
113             }
114 
115             // Shift in bits from prod1 into prod0.
116             prod0 |= prod1 * twos;
117 
118             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
119             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
120             // four bits. That is, denominator * inv = 1 mod 2^4.
121             uint256 inverse = (3 * denominator) ^ 2;
122 
123             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
124             // in modular arithmetic, doubling the correct bits in each step.
125             inverse *= 2 - denominator * inverse; // inverse mod 2^8
126             inverse *= 2 - denominator * inverse; // inverse mod 2^16
127             inverse *= 2 - denominator * inverse; // inverse mod 2^32
128             inverse *= 2 - denominator * inverse; // inverse mod 2^64
129             inverse *= 2 - denominator * inverse; // inverse mod 2^128
130             inverse *= 2 - denominator * inverse; // inverse mod 2^256
131 
132             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
133             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
134             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
135             // is no longer required.
136             result = prod0 * inverse;
137             return result;
138         }
139     }
140 
141     /**
142      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
143      */
144     function mulDiv(
145         uint256 x,
146         uint256 y,
147         uint256 denominator,
148         Rounding rounding
149     ) internal pure returns (uint256) {
150         uint256 result = mulDiv(x, y, denominator);
151         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
152             result += 1;
153         }
154         return result;
155     }
156 
157     /**
158      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
159      *
160      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
161      */
162     function sqrt(uint256 a) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
168         //
169         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
170         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
171         //
172         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
173         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
174         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
175         //
176         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
177         uint256 result = 1 << (log2(a) >> 1);
178 
179         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
180         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
181         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
182         // into the expected uint128 result.
183         unchecked {
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             result = (result + a / result) >> 1;
191             return min(result, a / result);
192         }
193     }
194 
195     /**
196      * @notice Calculates sqrt(a), following the selected rounding direction.
197      */
198     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
199         unchecked {
200             uint256 result = sqrt(a);
201             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
202         }
203     }
204 
205     /**
206      * @dev Return the log in base 2, rounded down, of a positive value.
207      * Returns 0 if given 0.
208      */
209     function log2(uint256 value) internal pure returns (uint256) {
210         uint256 result = 0;
211         unchecked {
212             if (value >> 128 > 0) {
213                 value >>= 128;
214                 result += 128;
215             }
216             if (value >> 64 > 0) {
217                 value >>= 64;
218                 result += 64;
219             }
220             if (value >> 32 > 0) {
221                 value >>= 32;
222                 result += 32;
223             }
224             if (value >> 16 > 0) {
225                 value >>= 16;
226                 result += 16;
227             }
228             if (value >> 8 > 0) {
229                 value >>= 8;
230                 result += 8;
231             }
232             if (value >> 4 > 0) {
233                 value >>= 4;
234                 result += 4;
235             }
236             if (value >> 2 > 0) {
237                 value >>= 2;
238                 result += 2;
239             }
240             if (value >> 1 > 0) {
241                 result += 1;
242             }
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
249      * Returns 0 if given 0.
250      */
251     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
252         unchecked {
253             uint256 result = log2(value);
254             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
255         }
256     }
257 
258     /**
259      * @dev Return the log in base 10, rounded down, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log10(uint256 value) internal pure returns (uint256) {
263         uint256 result = 0;
264         unchecked {
265             if (value >= 10**64) {
266                 value /= 10**64;
267                 result += 64;
268             }
269             if (value >= 10**32) {
270                 value /= 10**32;
271                 result += 32;
272             }
273             if (value >= 10**16) {
274                 value /= 10**16;
275                 result += 16;
276             }
277             if (value >= 10**8) {
278                 value /= 10**8;
279                 result += 8;
280             }
281             if (value >= 10**4) {
282                 value /= 10**4;
283                 result += 4;
284             }
285             if (value >= 10**2) {
286                 value /= 10**2;
287                 result += 2;
288             }
289             if (value >= 10**1) {
290                 result += 1;
291             }
292         }
293         return result;
294     }
295 
296     /**
297      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
301         unchecked {
302             uint256 result = log10(value);
303             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
304         }
305     }
306 
307     /**
308      * @dev Return the log in base 256, rounded down, of a positive value.
309      * Returns 0 if given 0.
310      *
311      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
312      */
313     function log256(uint256 value) internal pure returns (uint256) {
314         uint256 result = 0;
315         unchecked {
316             if (value >> 128 > 0) {
317                 value >>= 128;
318                 result += 16;
319             }
320             if (value >> 64 > 0) {
321                 value >>= 64;
322                 result += 8;
323             }
324             if (value >> 32 > 0) {
325                 value >>= 32;
326                 result += 4;
327             }
328             if (value >> 16 > 0) {
329                 value >>= 16;
330                 result += 2;
331             }
332             if (value >> 8 > 0) {
333                 result += 1;
334             }
335         }
336         return result;
337     }
338 
339     /**
340      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
344         unchecked {
345             uint256 result = log256(value);
346             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
347         }
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Strings.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev String operations.
361  */
362 library Strings {
363     bytes16 private constant _SYMBOLS = "0123456789abcdef";
364     uint8 private constant _ADDRESS_LENGTH = 20;
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
368      */
369     function toString(uint256 value) internal pure returns (string memory) {
370         unchecked {
371             uint256 length = Math.log10(value) + 1;
372             string memory buffer = new string(length);
373             uint256 ptr;
374             /// @solidity memory-safe-assembly
375             assembly {
376                 ptr := add(buffer, add(32, length))
377             }
378             while (true) {
379                 ptr--;
380                 /// @solidity memory-safe-assembly
381                 assembly {
382                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
383                 }
384                 value /= 10;
385                 if (value == 0) break;
386             }
387             return buffer;
388         }
389     }
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
393      */
394     function toHexString(uint256 value) internal pure returns (string memory) {
395         unchecked {
396             return toHexString(value, Math.log256(value) + 1);
397         }
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
402      */
403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
404         bytes memory buffer = new bytes(2 * length + 2);
405         buffer[0] = "0";
406         buffer[1] = "x";
407         for (uint256 i = 2 * length + 1; i > 1; --i) {
408             buffer[i] = _SYMBOLS[value & 0xf];
409             value >>= 4;
410         }
411         require(value == 0, "Strings: hex length insufficient");
412         return string(buffer);
413     }
414 
415     /**
416      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
417      */
418     function toHexString(address addr) internal pure returns (string memory) {
419         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/Address.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
427 
428 pragma solidity ^0.8.1;
429 
430 /**
431  * @dev Collection of functions related to the address type
432  */
433 library Address {
434     /**
435      * @dev Returns true if `account` is a contract.
436      *
437      * [IMPORTANT]
438      * ====
439      * It is unsafe to assume that an address for which this function returns
440      * false is an externally-owned account (EOA) and not a contract.
441      *
442      * Among others, `isContract` will return false for the following
443      * types of addresses:
444      *
445      *  - an externally-owned account
446      *  - a contract in construction
447      *  - an address where a contract will be created
448      *  - an address where a contract lived, but was destroyed
449      * ====
450      *
451      * [IMPORTANT]
452      * ====
453      * You shouldn't rely on `isContract` to protect against flash loan attacks!
454      *
455      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
456      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
457      * constructor.
458      * ====
459      */
460     function isContract(address account) internal view returns (bool) {
461         // This method relies on extcodesize/address.code.length, which returns 0
462         // for contracts in construction, since the code is only stored at the end
463         // of the constructor execution.
464 
465         return account.code.length > 0;
466     }
467 
468     /**
469      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
470      * `recipient`, forwarding all available gas and reverting on errors.
471      *
472      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
473      * of certain opcodes, possibly making contracts go over the 2300 gas limit
474      * imposed by `transfer`, making them unable to receive funds via
475      * `transfer`. {sendValue} removes this limitation.
476      *
477      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
478      *
479      * IMPORTANT: because control is transferred to `recipient`, care must be
480      * taken to not create reentrancy vulnerabilities. Consider using
481      * {ReentrancyGuard} or the
482      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
483      */
484     function sendValue(address payable recipient, uint256 amount) internal {
485         require(address(this).balance >= amount, "Address: insufficient balance");
486 
487         (bool success, ) = recipient.call{value: amount}("");
488         require(success, "Address: unable to send value, recipient may have reverted");
489     }
490 
491     /**
492      * @dev Performs a Solidity function call using a low level `call`. A
493      * plain `call` is an unsafe replacement for a function call: use this
494      * function instead.
495      *
496      * If `target` reverts with a revert reason, it is bubbled up by this
497      * function (like regular Solidity function calls).
498      *
499      * Returns the raw returned data. To convert to the expected return value,
500      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
501      *
502      * Requirements:
503      *
504      * - `target` must be a contract.
505      * - calling `target` with `data` must not revert.
506      *
507      * _Available since v3.1._
508      */
509     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
515      * `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCall(
520         address target,
521         bytes memory data,
522         string memory errorMessage
523     ) internal returns (bytes memory) {
524         return functionCallWithValue(target, data, 0, errorMessage);
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
529      * but also transferring `value` wei to `target`.
530      *
531      * Requirements:
532      *
533      * - the calling contract must have an ETH balance of at least `value`.
534      * - the called Solidity function must be `payable`.
535      *
536      * _Available since v3.1._
537      */
538     function functionCallWithValue(
539         address target,
540         bytes memory data,
541         uint256 value
542     ) internal returns (bytes memory) {
543         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
544     }
545 
546     /**
547      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
548      * with `errorMessage` as a fallback revert reason when `target` reverts.
549      *
550      * _Available since v3.1._
551      */
552     function functionCallWithValue(
553         address target,
554         bytes memory data,
555         uint256 value,
556         string memory errorMessage
557     ) internal returns (bytes memory) {
558         require(address(this).balance >= value, "Address: insufficient balance for call");
559         (bool success, bytes memory returndata) = target.call{value: value}(data);
560         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
561     }
562 
563     /**
564      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
565      * but performing a static call.
566      *
567      * _Available since v3.3._
568      */
569     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
570         return functionStaticCall(target, data, "Address: low-level static call failed");
571     }
572 
573     /**
574      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
575      * but performing a static call.
576      *
577      * _Available since v3.3._
578      */
579     function functionStaticCall(
580         address target,
581         bytes memory data,
582         string memory errorMessage
583     ) internal view returns (bytes memory) {
584         (bool success, bytes memory returndata) = target.staticcall(data);
585         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but performing a delegate call.
591      *
592      * _Available since v3.4._
593      */
594     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
595         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a delegate call.
601      *
602      * _Available since v3.4._
603      */
604     function functionDelegateCall(
605         address target,
606         bytes memory data,
607         string memory errorMessage
608     ) internal returns (bytes memory) {
609         (bool success, bytes memory returndata) = target.delegatecall(data);
610         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
615      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
616      *
617      * _Available since v4.8._
618      */
619     function verifyCallResultFromTarget(
620         address target,
621         bool success,
622         bytes memory returndata,
623         string memory errorMessage
624     ) internal view returns (bytes memory) {
625         if (success) {
626             if (returndata.length == 0) {
627                 // only check isContract if the call was successful and the return data is empty
628                 // otherwise we already know that it was a contract
629                 require(isContract(target), "Address: call to non-contract");
630             }
631             return returndata;
632         } else {
633             _revert(returndata, errorMessage);
634         }
635     }
636 
637     /**
638      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
639      * revert reason or using the provided one.
640      *
641      * _Available since v4.3._
642      */
643     function verifyCallResult(
644         bool success,
645         bytes memory returndata,
646         string memory errorMessage
647     ) internal pure returns (bytes memory) {
648         if (success) {
649             return returndata;
650         } else {
651             _revert(returndata, errorMessage);
652         }
653     }
654 
655     function _revert(bytes memory returndata, string memory errorMessage) private pure {
656         // Look for revert reason and bubble it up if present
657         if (returndata.length > 0) {
658             // The easiest way to bubble the revert reason is using memory via assembly
659             /// @solidity memory-safe-assembly
660             assembly {
661                 let returndata_size := mload(returndata)
662                 revert(add(32, returndata), returndata_size)
663             }
664         } else {
665             revert(errorMessage);
666         }
667     }
668 }
669 
670 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
671 
672 
673 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
674 
675 pragma solidity ^0.8.0;
676 
677 /**
678  * @dev Interface of the ERC165 standard, as defined in the
679  * https://eips.ethereum.org/EIPS/eip-165[EIP].
680  *
681  * Implementers can declare support of contract interfaces, which can then be
682  * queried by others ({ERC165Checker}).
683  *
684  * For an implementation, see {ERC165}.
685  */
686 interface IERC165 {
687     /**
688      * @dev Returns true if this contract implements the interface defined by
689      * `interfaceId`. See the corresponding
690      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
691      * to learn more about how these ids are created.
692      *
693      * This function call must use less than 30 000 gas.
694      */
695     function supportsInterface(bytes4 interfaceId) external view returns (bool);
696 }
697 
698 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 
706 /**
707  * @dev Implementation of the {IERC165} interface.
708  *
709  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
710  * for the additional interface id that will be supported. For example:
711  *
712  * ```solidity
713  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
714  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
715  * }
716  * ```
717  *
718  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
719  */
720 abstract contract ERC165 is IERC165 {
721     /**
722      * @dev See {IERC165-supportsInterface}.
723      */
724     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
725         return interfaceId == type(IERC165).interfaceId;
726     }
727 }
728 
729 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
730 
731 
732 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
733 
734 pragma solidity ^0.8.0;
735 
736 
737 /**
738  * @dev Required interface of an ERC721 compliant contract.
739  */
740 interface IERC721 is IERC165 {
741     /**
742      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
743      */
744     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
745 
746     /**
747      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
748      */
749     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
750 
751     /**
752      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
753      */
754     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
755 
756     /**
757      * @dev Returns the number of tokens in ``owner``'s account.
758      */
759     function balanceOf(address owner) external view returns (uint256 balance);
760 
761     /**
762      * @dev Returns the owner of the `tokenId` token.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function ownerOf(uint256 tokenId) external view returns (address owner);
769 
770     /**
771      * @dev Safely transfers `tokenId` token from `from` to `to`.
772      *
773      * Requirements:
774      *
775      * - `from` cannot be the zero address.
776      * - `to` cannot be the zero address.
777      * - `tokenId` token must exist and be owned by `from`.
778      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
779      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes calldata data
788     ) external;
789 
790     /**
791      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
792      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
793      *
794      * Requirements:
795      *
796      * - `from` cannot be the zero address.
797      * - `to` cannot be the zero address.
798      * - `tokenId` token must exist and be owned by `from`.
799      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
800      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
801      *
802      * Emits a {Transfer} event.
803      */
804     function safeTransferFrom(
805         address from,
806         address to,
807         uint256 tokenId
808     ) external;
809 
810     /**
811      * @dev Transfers `tokenId` token from `from` to `to`.
812      *
813      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
814      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
815      * understand this adds an external call which potentially creates a reentrancy vulnerability.
816      *
817      * Requirements:
818      *
819      * - `from` cannot be the zero address.
820      * - `to` cannot be the zero address.
821      * - `tokenId` token must be owned by `from`.
822      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
823      *
824      * Emits a {Transfer} event.
825      */
826     function transferFrom(
827         address from,
828         address to,
829         uint256 tokenId
830     ) external;
831 
832     /**
833      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
834      * The approval is cleared when the token is transferred.
835      *
836      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
837      *
838      * Requirements:
839      *
840      * - The caller must own the token or be an approved operator.
841      * - `tokenId` must exist.
842      *
843      * Emits an {Approval} event.
844      */
845     function approve(address to, uint256 tokenId) external;
846 
847     /**
848      * @dev Approve or remove `operator` as an operator for the caller.
849      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
850      *
851      * Requirements:
852      *
853      * - The `operator` cannot be the caller.
854      *
855      * Emits an {ApprovalForAll} event.
856      */
857     function setApprovalForAll(address operator, bool _approved) external;
858 
859     /**
860      * @dev Returns the account approved for `tokenId` token.
861      *
862      * Requirements:
863      *
864      * - `tokenId` must exist.
865      */
866     function getApproved(uint256 tokenId) external view returns (address operator);
867 
868     /**
869      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
870      *
871      * See {setApprovalForAll}
872      */
873     function isApprovedForAll(address owner, address operator) external view returns (bool);
874 }
875 
876 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
877 
878 
879 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 
884 /**
885  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
886  * @dev See https://eips.ethereum.org/EIPS/eip-721
887  */
888 interface IERC721Enumerable is IERC721 {
889     /**
890      * @dev Returns the total amount of tokens stored by the contract.
891      */
892     function totalSupply() external view returns (uint256);
893 
894     /**
895      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
896      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
897      */
898     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
899 
900     /**
901      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
902      * Use along with {totalSupply} to enumerate all tokens.
903      */
904     function tokenByIndex(uint256 index) external view returns (uint256);
905 }
906 
907 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
908 
909 
910 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
911 
912 pragma solidity ^0.8.0;
913 
914 
915 /**
916  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
917  * @dev See https://eips.ethereum.org/EIPS/eip-721
918  */
919 interface IERC721Metadata is IERC721 {
920     /**
921      * @dev Returns the token collection name.
922      */
923     function name() external view returns (string memory);
924 
925     /**
926      * @dev Returns the token collection symbol.
927      */
928     function symbol() external view returns (string memory);
929 
930     /**
931      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
932      */
933     function tokenURI(uint256 tokenId) external view returns (string memory);
934 }
935 
936 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
937 
938 
939 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
940 
941 pragma solidity ^0.8.0;
942 
943 /**
944  * @title ERC721 token receiver interface
945  * @dev Interface for any contract that wants to support safeTransfers
946  * from ERC721 asset contracts.
947  */
948 interface IERC721Receiver {
949     /**
950      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
951      * by `operator` from `from`, this function is called.
952      *
953      * It must return its Solidity selector to confirm the token transfer.
954      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
955      *
956      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
957      */
958     function onERC721Received(
959         address operator,
960         address from,
961         uint256 tokenId,
962         bytes calldata data
963     ) external returns (bytes4);
964 }
965 
966 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
967 
968 
969 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
970 
971 pragma solidity ^0.8.0;
972 
973 /**
974  * @dev Interface of the ERC20 standard as defined in the EIP.
975  */
976 interface IERC20 {
977     /**
978      * @dev Emitted when `value` tokens are moved from one account (`from`) to
979      * another (`to`).
980      *
981      * Note that `value` may be zero.
982      */
983     event Transfer(address indexed from, address indexed to, uint256 value);
984 
985     /**
986      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
987      * a call to {approve}. `value` is the new allowance.
988      */
989     event Approval(address indexed owner, address indexed spender, uint256 value);
990 
991     /**
992      * @dev Returns the amount of tokens in existence.
993      */
994     function totalSupply() external view returns (uint256);
995 
996     /**
997      * @dev Returns the amount of tokens owned by `account`.
998      */
999     function balanceOf(address account) external view returns (uint256);
1000 
1001     /**
1002      * @dev Moves `amount` tokens from the caller's account to `to`.
1003      *
1004      * Returns a boolean value indicating whether the operation succeeded.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function transfer(address to, uint256 amount) external returns (bool);
1009 
1010     /**
1011      * @dev Returns the remaining number of tokens that `spender` will be
1012      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1013      * zero by default.
1014      *
1015      * This value changes when {approve} or {transferFrom} are called.
1016      */
1017     function allowance(address owner, address spender) external view returns (uint256);
1018 
1019     /**
1020      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1021      *
1022      * Returns a boolean value indicating whether the operation succeeded.
1023      *
1024      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1025      * that someone may use both the old and the new allowance by unfortunate
1026      * transaction ordering. One possible solution to mitigate this race
1027      * condition is to first reduce the spender's allowance to 0 and set the
1028      * desired value afterwards:
1029      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1030      *
1031      * Emits an {Approval} event.
1032      */
1033     function approve(address spender, uint256 amount) external returns (bool);
1034 
1035     /**
1036      * @dev Moves `amount` tokens from `from` to `to` using the
1037      * allowance mechanism. `amount` is then deducted from the caller's
1038      * allowance.
1039      *
1040      * Returns a boolean value indicating whether the operation succeeded.
1041      *
1042      * Emits a {Transfer} event.
1043      */
1044     function transferFrom(
1045         address from,
1046         address to,
1047         uint256 amount
1048     ) external returns (bool);
1049 }
1050 
1051 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1052 
1053 
1054 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1055 
1056 pragma solidity ^0.8.0;
1057 
1058 
1059 /**
1060  * @dev Interface for the optional metadata functions from the ERC20 standard.
1061  *
1062  * _Available since v4.1._
1063  */
1064 interface IERC20Metadata is IERC20 {
1065     /**
1066      * @dev Returns the name of the token.
1067      */
1068     function name() external view returns (string memory);
1069 
1070     /**
1071      * @dev Returns the symbol of the token.
1072      */
1073     function symbol() external view returns (string memory);
1074 
1075     /**
1076      * @dev Returns the decimals places of the token.
1077      */
1078     function decimals() external view returns (uint8);
1079 }
1080 
1081 // File: @openzeppelin/contracts/utils/Context.sol
1082 
1083 
1084 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1085 
1086 pragma solidity ^0.8.0;
1087 
1088 /**
1089  * @dev Provides information about the current execution context, including the
1090  * sender of the transaction and its data. While these are generally available
1091  * via msg.sender and msg.data, they should not be accessed in such a direct
1092  * manner, since when dealing with meta-transactions the account sending and
1093  * paying for execution may not be the actual sender (as far as an application
1094  * is concerned).
1095  *
1096  * This contract is only required for intermediate, library-like contracts.
1097  */
1098 abstract contract Context {
1099     function _msgSender() internal view virtual returns (address) {
1100         return msg.sender;
1101     }
1102 
1103     function _msgData() internal view virtual returns (bytes calldata) {
1104         return msg.data;
1105     }
1106 }
1107 
1108 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1109 
1110 
1111 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1112 
1113 pragma solidity ^0.8.0;
1114 
1115 
1116 
1117 
1118 
1119 
1120 
1121 
1122 /**
1123  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1124  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1125  * {ERC721Enumerable}.
1126  */
1127 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1128     using Address for address;
1129     using Strings for uint256;
1130 
1131     // Token name
1132     string private _name;
1133 
1134     // Token symbol
1135     string private _symbol;
1136 
1137     // Mapping from token ID to owner address
1138     mapping(uint256 => address) private _owners;
1139 
1140     // Mapping owner address to token count
1141     mapping(address => uint256) private _balances;
1142 
1143     // Mapping from token ID to approved address
1144     mapping(uint256 => address) private _tokenApprovals;
1145 
1146     // Mapping from owner to operator approvals
1147     mapping(address => mapping(address => bool)) private _operatorApprovals;
1148 
1149     /**
1150      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1151      */
1152     constructor(string memory name_, string memory symbol_) {
1153         _name = name_;
1154         _symbol = symbol_;
1155     }
1156 
1157     /**
1158      * @dev See {IERC165-supportsInterface}.
1159      */
1160     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1161         return
1162             interfaceId == type(IERC721).interfaceId ||
1163             interfaceId == type(IERC721Metadata).interfaceId ||
1164             super.supportsInterface(interfaceId);
1165     }
1166 
1167     /**
1168      * @dev See {IERC721-balanceOf}.
1169      */
1170     function balanceOf(address owner) public view virtual override returns (uint256) {
1171         require(owner != address(0), "ERC721: address zero is not a valid owner");
1172         return _balances[owner];
1173     }
1174 
1175     /**
1176      * @dev See {IERC721-ownerOf}.
1177      */
1178     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1179         address owner = _ownerOf(tokenId);
1180         require(owner != address(0), "ERC721: invalid token ID");
1181         return owner;
1182     }
1183 
1184     /**
1185      * @dev See {IERC721Metadata-name}.
1186      */
1187     function name() public view virtual override returns (string memory) {
1188         return _name;
1189     }
1190 
1191     /**
1192      * @dev See {IERC721Metadata-symbol}.
1193      */
1194     function symbol() public view virtual override returns (string memory) {
1195         return _symbol;
1196     }
1197 
1198     /**
1199      * @dev See {IERC721Metadata-tokenURI}.
1200      */
1201     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1202         _requireMinted(tokenId);
1203 
1204         string memory baseURI = _baseURI();
1205         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1206     }
1207 
1208     /**
1209      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1210      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1211      * by default, can be overridden in child contracts.
1212      */
1213     function _baseURI() internal view virtual returns (string memory) {
1214         return "";
1215     }
1216 
1217     /**
1218      * @dev See {IERC721-approve}.
1219      */
1220     function approve(address to, uint256 tokenId) public virtual override {
1221         address owner = ERC721.ownerOf(tokenId);
1222         require(to != owner, "ERC721: approval to current owner");
1223 
1224         require(
1225             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1226             "ERC721: approve caller is not token owner or approved for all"
1227         );
1228 
1229         _approve(to, tokenId);
1230     }
1231 
1232     /**
1233      * @dev See {IERC721-getApproved}.
1234      */
1235     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1236         _requireMinted(tokenId);
1237 
1238         return _tokenApprovals[tokenId];
1239     }
1240 
1241     /**
1242      * @dev See {IERC721-setApprovalForAll}.
1243      */
1244     function setApprovalForAll(address operator, bool approved) public virtual override {
1245         _setApprovalForAll(_msgSender(), operator, approved);
1246     }
1247 
1248     /**
1249      * @dev See {IERC721-isApprovedForAll}.
1250      */
1251     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1252         return _operatorApprovals[owner][operator];
1253     }
1254 
1255     /**
1256      * @dev See {IERC721-transferFrom}.
1257      */
1258     function transferFrom(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) public virtual override {
1263         //solhint-disable-next-line max-line-length
1264         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1265 
1266         _transfer(from, to, tokenId);
1267     }
1268 
1269     /**
1270      * @dev See {IERC721-safeTransferFrom}.
1271      */
1272     function safeTransferFrom(
1273         address from,
1274         address to,
1275         uint256 tokenId
1276     ) public virtual override {
1277         safeTransferFrom(from, to, tokenId, "");
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-safeTransferFrom}.
1282      */
1283     function safeTransferFrom(
1284         address from,
1285         address to,
1286         uint256 tokenId,
1287         bytes memory data
1288     ) public virtual override {
1289         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1290         _safeTransfer(from, to, tokenId, data);
1291     }
1292 
1293     /**
1294      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1295      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1296      *
1297      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1298      *
1299      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1300      * implement alternative mechanisms to perform token transfer, such as signature-based.
1301      *
1302      * Requirements:
1303      *
1304      * - `from` cannot be the zero address.
1305      * - `to` cannot be the zero address.
1306      * - `tokenId` token must exist and be owned by `from`.
1307      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1308      *
1309      * Emits a {Transfer} event.
1310      */
1311     function _safeTransfer(
1312         address from,
1313         address to,
1314         uint256 tokenId,
1315         bytes memory data
1316     ) internal virtual {
1317         _transfer(from, to, tokenId);
1318         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1319     }
1320 
1321     /**
1322      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1323      */
1324     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1325         return _owners[tokenId];
1326     }
1327 
1328     /**
1329      * @dev Returns whether `tokenId` exists.
1330      *
1331      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1332      *
1333      * Tokens start existing when they are minted (`_mint`),
1334      * and stop existing when they are burned (`_burn`).
1335      */
1336     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1337         return _ownerOf(tokenId) != address(0);
1338     }
1339 
1340     /**
1341      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1342      *
1343      * Requirements:
1344      *
1345      * - `tokenId` must exist.
1346      */
1347     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1348         address owner = ERC721.ownerOf(tokenId);
1349         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1350     }
1351 
1352     /**
1353      * @dev Safely mints `tokenId` and transfers it to `to`.
1354      *
1355      * Requirements:
1356      *
1357      * - `tokenId` must not exist.
1358      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1359      *
1360      * Emits a {Transfer} event.
1361      */
1362     function _safeMint(address to, uint256 tokenId) internal virtual {
1363         _safeMint(to, tokenId, "");
1364     }
1365 
1366     /**
1367      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1368      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1369      */
1370     function _safeMint(
1371         address to,
1372         uint256 tokenId,
1373         bytes memory data
1374     ) internal virtual {
1375         _mint(to, tokenId);
1376         require(
1377             _checkOnERC721Received(address(0), to, tokenId, data),
1378             "ERC721: transfer to non ERC721Receiver implementer"
1379         );
1380     }
1381 
1382     /**
1383      * @dev Mints `tokenId` and transfers it to `to`.
1384      *
1385      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1386      *
1387      * Requirements:
1388      *
1389      * - `tokenId` must not exist.
1390      * - `to` cannot be the zero address.
1391      *
1392      * Emits a {Transfer} event.
1393      */
1394     function _mint(address to, uint256 tokenId) internal virtual {
1395         require(to != address(0), "ERC721: mint to the zero address");
1396         require(!_exists(tokenId), "ERC721: token already minted");
1397 
1398         _beforeTokenTransfer(address(0), to, tokenId, 1);
1399 
1400         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1401         require(!_exists(tokenId), "ERC721: token already minted");
1402 
1403         unchecked {
1404             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1405             // Given that tokens are minted one by one, it is impossible in practice that
1406             // this ever happens. Might change if we allow batch minting.
1407             // The ERC fails to describe this case.
1408             _balances[to] += 1;
1409         }
1410 
1411         _owners[tokenId] = to;
1412 
1413         emit Transfer(address(0), to, tokenId);
1414 
1415         _afterTokenTransfer(address(0), to, tokenId, 1);
1416     }
1417 
1418     /**
1419      * @dev Destroys `tokenId`.
1420      * The approval is cleared when the token is burned.
1421      * This is an internal function that does not check if the sender is authorized to operate on the token.
1422      *
1423      * Requirements:
1424      *
1425      * - `tokenId` must exist.
1426      *
1427      * Emits a {Transfer} event.
1428      */
1429     function _burn(uint256 tokenId) internal virtual {
1430         address owner = ERC721.ownerOf(tokenId);
1431 
1432         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1433 
1434         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1435         owner = ERC721.ownerOf(tokenId);
1436 
1437         // Clear approvals
1438         delete _tokenApprovals[tokenId];
1439 
1440         unchecked {
1441             // Cannot overflow, as that would require more tokens to be burned/transferred
1442             // out than the owner initially received through minting and transferring in.
1443             _balances[owner] -= 1;
1444         }
1445         delete _owners[tokenId];
1446 
1447         emit Transfer(owner, address(0), tokenId);
1448 
1449         _afterTokenTransfer(owner, address(0), tokenId, 1);
1450     }
1451 
1452     /**
1453      * @dev Transfers `tokenId` from `from` to `to`.
1454      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1455      *
1456      * Requirements:
1457      *
1458      * - `to` cannot be the zero address.
1459      * - `tokenId` token must be owned by `from`.
1460      *
1461      * Emits a {Transfer} event.
1462      */
1463     function _transfer(
1464         address from,
1465         address to,
1466         uint256 tokenId
1467     ) internal virtual {
1468         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1469         require(to != address(0), "ERC721: transfer to the zero address");
1470 
1471         _beforeTokenTransfer(from, to, tokenId, 1);
1472 
1473         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1474         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1475 
1476         // Clear approvals from the previous owner
1477         delete _tokenApprovals[tokenId];
1478 
1479         unchecked {
1480             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1481             // `from`'s balance is the number of token held, which is at least one before the current
1482             // transfer.
1483             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1484             // all 2**256 token ids to be minted, which in practice is impossible.
1485             _balances[from] -= 1;
1486             _balances[to] += 1;
1487         }
1488         _owners[tokenId] = to;
1489 
1490         emit Transfer(from, to, tokenId);
1491 
1492         _afterTokenTransfer(from, to, tokenId, 1);
1493     }
1494 
1495     /**
1496      * @dev Approve `to` to operate on `tokenId`
1497      *
1498      * Emits an {Approval} event.
1499      */
1500     function _approve(address to, uint256 tokenId) internal virtual {
1501         _tokenApprovals[tokenId] = to;
1502         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1503     }
1504 
1505     /**
1506      * @dev Approve `operator` to operate on all of `owner` tokens
1507      *
1508      * Emits an {ApprovalForAll} event.
1509      */
1510     function _setApprovalForAll(
1511         address owner,
1512         address operator,
1513         bool approved
1514     ) internal virtual {
1515         require(owner != operator, "ERC721: approve to caller");
1516         _operatorApprovals[owner][operator] = approved;
1517         emit ApprovalForAll(owner, operator, approved);
1518     }
1519 
1520     /**
1521      * @dev Reverts if the `tokenId` has not been minted yet.
1522      */
1523     function _requireMinted(uint256 tokenId) internal view virtual {
1524         require(_exists(tokenId), "ERC721: invalid token ID");
1525     }
1526 
1527     /**
1528      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1529      * The call is not executed if the target address is not a contract.
1530      *
1531      * @param from address representing the previous owner of the given token ID
1532      * @param to target address that will receive the tokens
1533      * @param tokenId uint256 ID of the token to be transferred
1534      * @param data bytes optional data to send along with the call
1535      * @return bool whether the call correctly returned the expected magic value
1536      */
1537     function _checkOnERC721Received(
1538         address from,
1539         address to,
1540         uint256 tokenId,
1541         bytes memory data
1542     ) private returns (bool) {
1543         if (to.isContract()) {
1544             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1545                 return retval == IERC721Receiver.onERC721Received.selector;
1546             } catch (bytes memory reason) {
1547                 if (reason.length == 0) {
1548                     revert("ERC721: transfer to non ERC721Receiver implementer");
1549                 } else {
1550                     /// @solidity memory-safe-assembly
1551                     assembly {
1552                         revert(add(32, reason), mload(reason))
1553                     }
1554                 }
1555             }
1556         } else {
1557             return true;
1558         }
1559     }
1560 
1561     /**
1562      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1563      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1564      *
1565      * Calling conditions:
1566      *
1567      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1568      * - When `from` is zero, the tokens will be minted for `to`.
1569      * - When `to` is zero, ``from``'s tokens will be burned.
1570      * - `from` and `to` are never both zero.
1571      * - `batchSize` is non-zero.
1572      *
1573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1574      */
1575     function _beforeTokenTransfer(
1576         address from,
1577         address to,
1578         uint256, /* firstTokenId */
1579         uint256 batchSize
1580     ) internal virtual {
1581         if (batchSize > 1) {
1582             if (from != address(0)) {
1583                 _balances[from] -= batchSize;
1584             }
1585             if (to != address(0)) {
1586                 _balances[to] += batchSize;
1587             }
1588         }
1589     }
1590 
1591     /**
1592      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1593      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1594      *
1595      * Calling conditions:
1596      *
1597      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1598      * - When `from` is zero, the tokens were minted for `to`.
1599      * - When `to` is zero, ``from``'s tokens were burned.
1600      * - `from` and `to` are never both zero.
1601      * - `batchSize` is non-zero.
1602      *
1603      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1604      */
1605     function _afterTokenTransfer(
1606         address from,
1607         address to,
1608         uint256 firstTokenId,
1609         uint256 batchSize
1610     ) internal virtual {}
1611 }
1612 
1613 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1614 
1615 
1616 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/extensions/ERC721Enumerable.sol)
1617 
1618 pragma solidity ^0.8.0;
1619 
1620 
1621 
1622 /**
1623  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1624  * enumerability of all the token ids in the contract as well as all token ids owned by each
1625  * account.
1626  */
1627 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1628     // Mapping from owner to list of owned token IDs
1629     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1630 
1631     // Mapping from token ID to index of the owner tokens list
1632     mapping(uint256 => uint256) private _ownedTokensIndex;
1633 
1634     // Array with all token ids, used for enumeration
1635     uint256[] private _allTokens;
1636 
1637     // Mapping from token id to position in the allTokens array
1638     mapping(uint256 => uint256) private _allTokensIndex;
1639 
1640     /**
1641      * @dev See {IERC165-supportsInterface}.
1642      */
1643     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1644         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1645     }
1646 
1647     /**
1648      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1649      */
1650     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1651         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1652         return _ownedTokens[owner][index];
1653     }
1654 
1655     /**
1656      * @dev See {IERC721Enumerable-totalSupply}.
1657      */
1658     function totalSupply() public view virtual override returns (uint256) {
1659         return _allTokens.length;
1660     }
1661 
1662     /**
1663      * @dev See {IERC721Enumerable-tokenByIndex}.
1664      */
1665     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1666         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1667         return _allTokens[index];
1668     }
1669 
1670     /**
1671      * @dev See {ERC721-_beforeTokenTransfer}.
1672      */
1673     function _beforeTokenTransfer(
1674         address from,
1675         address to,
1676         uint256 firstTokenId,
1677         uint256 batchSize
1678     ) internal virtual override {
1679         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
1680 
1681         if (batchSize > 1) {
1682             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
1683             revert("ERC721Enumerable: consecutive transfers not supported");
1684         }
1685 
1686         uint256 tokenId = firstTokenId;
1687 
1688         if (from == address(0)) {
1689             _addTokenToAllTokensEnumeration(tokenId);
1690         } else if (from != to) {
1691             _removeTokenFromOwnerEnumeration(from, tokenId);
1692         }
1693         if (to == address(0)) {
1694             _removeTokenFromAllTokensEnumeration(tokenId);
1695         } else if (to != from) {
1696             _addTokenToOwnerEnumeration(to, tokenId);
1697         }
1698     }
1699 
1700     /**
1701      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1702      * @param to address representing the new owner of the given token ID
1703      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1704      */
1705     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1706         uint256 length = ERC721.balanceOf(to);
1707         _ownedTokens[to][length] = tokenId;
1708         _ownedTokensIndex[tokenId] = length;
1709     }
1710 
1711     /**
1712      * @dev Private function to add a token to this extension's token tracking data structures.
1713      * @param tokenId uint256 ID of the token to be added to the tokens list
1714      */
1715     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1716         _allTokensIndex[tokenId] = _allTokens.length;
1717         _allTokens.push(tokenId);
1718     }
1719 
1720     /**
1721      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1722      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1723      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1724      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1725      * @param from address representing the previous owner of the given token ID
1726      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1727      */
1728     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1729         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1730         // then delete the last slot (swap and pop).
1731 
1732         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1733         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1734 
1735         // When the token to delete is the last token, the swap operation is unnecessary
1736         if (tokenIndex != lastTokenIndex) {
1737             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1738 
1739             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1740             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1741         }
1742 
1743         // This also deletes the contents at the last position of the array
1744         delete _ownedTokensIndex[tokenId];
1745         delete _ownedTokens[from][lastTokenIndex];
1746     }
1747 
1748     /**
1749      * @dev Private function to remove a token from this extension's token tracking data structures.
1750      * This has O(1) time complexity, but alters the order of the _allTokens array.
1751      * @param tokenId uint256 ID of the token to be removed from the tokens list
1752      */
1753     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1754         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1755         // then delete the last slot (swap and pop).
1756 
1757         uint256 lastTokenIndex = _allTokens.length - 1;
1758         uint256 tokenIndex = _allTokensIndex[tokenId];
1759 
1760         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1761         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1762         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1763         uint256 lastTokenId = _allTokens[lastTokenIndex];
1764 
1765         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1766         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1767 
1768         // This also deletes the contents at the last position of the array
1769         delete _allTokensIndex[tokenId];
1770         _allTokens.pop();
1771     }
1772 }
1773 
1774 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1775 
1776 
1777 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1778 
1779 pragma solidity ^0.8.0;
1780 
1781 
1782 
1783 
1784 /**
1785  * @dev Implementation of the {IERC20} interface.
1786  *
1787  * This implementation is agnostic to the way tokens are created. This means
1788  * that a supply mechanism has to be added in a derived contract using {_mint}.
1789  * For a generic mechanism see {ERC20PresetMinterPauser}.
1790  *
1791  * TIP: For a detailed writeup see our guide
1792  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1793  * to implement supply mechanisms].
1794  *
1795  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1796  * instead returning `false` on failure. This behavior is nonetheless
1797  * conventional and does not conflict with the expectations of ERC20
1798  * applications.
1799  *
1800  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1801  * This allows applications to reconstruct the allowance for all accounts just
1802  * by listening to said events. Other implementations of the EIP may not emit
1803  * these events, as it isn't required by the specification.
1804  *
1805  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1806  * functions have been added to mitigate the well-known issues around setting
1807  * allowances. See {IERC20-approve}.
1808  */
1809 contract ERC20 is Context, IERC20, IERC20Metadata {
1810     mapping(address => uint256) private _balances;
1811 
1812     mapping(address => mapping(address => uint256)) private _allowances;
1813 
1814     uint256 private _totalSupply;
1815 
1816     string private _name;
1817     string private _symbol;
1818 
1819     /**
1820      * @dev Sets the values for {name} and {symbol}.
1821      *
1822      * The default value of {decimals} is 18. To select a different value for
1823      * {decimals} you should overload it.
1824      *
1825      * All two of these values are immutable: they can only be set once during
1826      * construction.
1827      */
1828     constructor(string memory name_, string memory symbol_) {
1829         _name = name_;
1830         _symbol = symbol_;
1831     }
1832 
1833     /**
1834      * @dev Returns the name of the token.
1835      */
1836     function name() public view virtual override returns (string memory) {
1837         return _name;
1838     }
1839 
1840     /**
1841      * @dev Returns the symbol of the token, usually a shorter version of the
1842      * name.
1843      */
1844     function symbol() public view virtual override returns (string memory) {
1845         return _symbol;
1846     }
1847 
1848     /**
1849      * @dev Returns the number of decimals used to get its user representation.
1850      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1851      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1852      *
1853      * Tokens usually opt for a value of 18, imitating the relationship between
1854      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1855      * overridden;
1856      *
1857      * NOTE: This information is only used for _display_ purposes: it in
1858      * no way affects any of the arithmetic of the contract, including
1859      * {IERC20-balanceOf} and {IERC20-transfer}.
1860      */
1861     function decimals() public view virtual override returns (uint8) {
1862         return 18;
1863     }
1864 
1865     /**
1866      * @dev See {IERC20-totalSupply}.
1867      */
1868     function totalSupply() public view virtual override returns (uint256) {
1869         return _totalSupply;
1870     }
1871 
1872     /**
1873      * @dev See {IERC20-balanceOf}.
1874      */
1875     function balanceOf(address account) public view virtual override returns (uint256) {
1876         return _balances[account];
1877     }
1878 
1879     /**
1880      * @dev See {IERC20-transfer}.
1881      *
1882      * Requirements:
1883      *
1884      * - `to` cannot be the zero address.
1885      * - the caller must have a balance of at least `amount`.
1886      */
1887     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1888         address owner = _msgSender();
1889         _transfer(owner, to, amount);
1890         return true;
1891     }
1892 
1893     /**
1894      * @dev See {IERC20-allowance}.
1895      */
1896     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1897         return _allowances[owner][spender];
1898     }
1899 
1900     /**
1901      * @dev See {IERC20-approve}.
1902      *
1903      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1904      * `transferFrom`. This is semantically equivalent to an infinite approval.
1905      *
1906      * Requirements:
1907      *
1908      * - `spender` cannot be the zero address.
1909      */
1910     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1911         address owner = _msgSender();
1912         _approve(owner, spender, amount);
1913         return true;
1914     }
1915 
1916     /**
1917      * @dev See {IERC20-transferFrom}.
1918      *
1919      * Emits an {Approval} event indicating the updated allowance. This is not
1920      * required by the EIP. See the note at the beginning of {ERC20}.
1921      *
1922      * NOTE: Does not update the allowance if the current allowance
1923      * is the maximum `uint256`.
1924      *
1925      * Requirements:
1926      *
1927      * - `from` and `to` cannot be the zero address.
1928      * - `from` must have a balance of at least `amount`.
1929      * - the caller must have allowance for ``from``'s tokens of at least
1930      * `amount`.
1931      */
1932     function transferFrom(
1933         address from,
1934         address to,
1935         uint256 amount
1936     ) public virtual override returns (bool) {
1937         address spender = _msgSender();
1938         _spendAllowance(from, spender, amount);
1939         _transfer(from, to, amount);
1940         return true;
1941     }
1942 
1943     /**
1944      * @dev Atomically increases the allowance granted to `spender` by the caller.
1945      *
1946      * This is an alternative to {approve} that can be used as a mitigation for
1947      * problems described in {IERC20-approve}.
1948      *
1949      * Emits an {Approval} event indicating the updated allowance.
1950      *
1951      * Requirements:
1952      *
1953      * - `spender` cannot be the zero address.
1954      */
1955     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1956         address owner = _msgSender();
1957         _approve(owner, spender, allowance(owner, spender) + addedValue);
1958         return true;
1959     }
1960 
1961     /**
1962      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1963      *
1964      * This is an alternative to {approve} that can be used as a mitigation for
1965      * problems described in {IERC20-approve}.
1966      *
1967      * Emits an {Approval} event indicating the updated allowance.
1968      *
1969      * Requirements:
1970      *
1971      * - `spender` cannot be the zero address.
1972      * - `spender` must have allowance for the caller of at least
1973      * `subtractedValue`.
1974      */
1975     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1976         address owner = _msgSender();
1977         uint256 currentAllowance = allowance(owner, spender);
1978         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1979         unchecked {
1980             _approve(owner, spender, currentAllowance - subtractedValue);
1981         }
1982 
1983         return true;
1984     }
1985 
1986     /**
1987      * @dev Moves `amount` of tokens from `from` to `to`.
1988      *
1989      * This internal function is equivalent to {transfer}, and can be used to
1990      * e.g. implement automatic token fees, slashing mechanisms, etc.
1991      *
1992      * Emits a {Transfer} event.
1993      *
1994      * Requirements:
1995      *
1996      * - `from` cannot be the zero address.
1997      * - `to` cannot be the zero address.
1998      * - `from` must have a balance of at least `amount`.
1999      */
2000     function _transfer(
2001         address from,
2002         address to,
2003         uint256 amount
2004     ) internal virtual {
2005         require(from != address(0), "ERC20: transfer from the zero address");
2006         require(to != address(0), "ERC20: transfer to the zero address");
2007 
2008         _beforeTokenTransfer(from, to, amount);
2009 
2010         uint256 fromBalance = _balances[from];
2011         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
2012         unchecked {
2013             _balances[from] = fromBalance - amount;
2014             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
2015             // decrementing then incrementing.
2016             _balances[to] += amount;
2017         }
2018 
2019         emit Transfer(from, to, amount);
2020 
2021         _afterTokenTransfer(from, to, amount);
2022     }
2023 
2024     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
2025      * the total supply.
2026      *
2027      * Emits a {Transfer} event with `from` set to the zero address.
2028      *
2029      * Requirements:
2030      *
2031      * - `account` cannot be the zero address.
2032      */
2033     function _mint(address account, uint256 amount) internal virtual {
2034         require(account != address(0), "ERC20: mint to the zero address");
2035 
2036         _beforeTokenTransfer(address(0), account, amount);
2037 
2038         _totalSupply += amount;
2039         unchecked {
2040             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
2041             _balances[account] += amount;
2042         }
2043         emit Transfer(address(0), account, amount);
2044 
2045         _afterTokenTransfer(address(0), account, amount);
2046     }
2047 
2048     /**
2049      * @dev Destroys `amount` tokens from `account`, reducing the
2050      * total supply.
2051      *
2052      * Emits a {Transfer} event with `to` set to the zero address.
2053      *
2054      * Requirements:
2055      *
2056      * - `account` cannot be the zero address.
2057      * - `account` must have at least `amount` tokens.
2058      */
2059     function _burn(address account, uint256 amount) internal virtual {
2060         require(account != address(0), "ERC20: burn from the zero address");
2061 
2062         _beforeTokenTransfer(account, address(0), amount);
2063 
2064         uint256 accountBalance = _balances[account];
2065         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
2066         unchecked {
2067             _balances[account] = accountBalance - amount;
2068             // Overflow not possible: amount <= accountBalance <= totalSupply.
2069             _totalSupply -= amount;
2070         }
2071 
2072         emit Transfer(account, address(0), amount);
2073 
2074         _afterTokenTransfer(account, address(0), amount);
2075     }
2076 
2077     /**
2078      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
2079      *
2080      * This internal function is equivalent to `approve`, and can be used to
2081      * e.g. set automatic allowances for certain subsystems, etc.
2082      *
2083      * Emits an {Approval} event.
2084      *
2085      * Requirements:
2086      *
2087      * - `owner` cannot be the zero address.
2088      * - `spender` cannot be the zero address.
2089      */
2090     function _approve(
2091         address owner,
2092         address spender,
2093         uint256 amount
2094     ) internal virtual {
2095         require(owner != address(0), "ERC20: approve from the zero address");
2096         require(spender != address(0), "ERC20: approve to the zero address");
2097 
2098         _allowances[owner][spender] = amount;
2099         emit Approval(owner, spender, amount);
2100     }
2101 
2102     /**
2103      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
2104      *
2105      * Does not update the allowance amount in case of infinite allowance.
2106      * Revert if not enough allowance is available.
2107      *
2108      * Might emit an {Approval} event.
2109      */
2110     function _spendAllowance(
2111         address owner,
2112         address spender,
2113         uint256 amount
2114     ) internal virtual {
2115         uint256 currentAllowance = allowance(owner, spender);
2116         if (currentAllowance != type(uint256).max) {
2117             require(currentAllowance >= amount, "ERC20: insufficient allowance");
2118             unchecked {
2119                 _approve(owner, spender, currentAllowance - amount);
2120             }
2121         }
2122     }
2123 
2124     /**
2125      * @dev Hook that is called before any transfer of tokens. This includes
2126      * minting and burning.
2127      *
2128      * Calling conditions:
2129      *
2130      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2131      * will be transferred to `to`.
2132      * - when `from` is zero, `amount` tokens will be minted for `to`.
2133      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2134      * - `from` and `to` are never both zero.
2135      *
2136      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2137      */
2138     function _beforeTokenTransfer(
2139         address from,
2140         address to,
2141         uint256 amount
2142     ) internal virtual {}
2143 
2144     /**
2145      * @dev Hook that is called after any transfer of tokens. This includes
2146      * minting and burning.
2147      *
2148      * Calling conditions:
2149      *
2150      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2151      * has been transferred to `to`.
2152      * - when `from` is zero, `amount` tokens have been minted for `to`.
2153      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2154      * - `from` and `to` are never both zero.
2155      *
2156      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2157      */
2158     function _afterTokenTransfer(
2159         address from,
2160         address to,
2161         uint256 amount
2162     ) internal virtual {}
2163 }
2164 
2165 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
2166 
2167 
2168 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2169 
2170 pragma solidity ^0.8.0;
2171 
2172 
2173 
2174 /**
2175  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2176  * tokens and those that they have an allowance for, in a way that can be
2177  * recognized off-chain (via event analysis).
2178  */
2179 abstract contract ERC20Burnable is Context, ERC20 {
2180     /**
2181      * @dev Destroys `amount` tokens from the caller.
2182      *
2183      * See {ERC20-_burn}.
2184      */
2185     function burn(uint256 amount) public virtual {
2186         _burn(_msgSender(), amount);
2187     }
2188 
2189     /**
2190      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2191      * allowance.
2192      *
2193      * See {ERC20-_burn} and {ERC20-allowance}.
2194      *
2195      * Requirements:
2196      *
2197      * - the caller must have allowance for ``accounts``'s tokens of at least
2198      * `amount`.
2199      */
2200     function burnFrom(address account, uint256 amount) public virtual {
2201         _spendAllowance(account, _msgSender(), amount);
2202         _burn(account, amount);
2203     }
2204 }
2205 
2206 // File: @openzeppelin/contracts/access/Ownable.sol
2207 
2208 
2209 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2210 
2211 pragma solidity ^0.8.0;
2212 
2213 
2214 /**
2215  * @dev Contract module which provides a basic access control mechanism, where
2216  * there is an account (an owner) that can be granted exclusive access to
2217  * specific functions.
2218  *
2219  * By default, the owner account will be the one that deploys the contract. This
2220  * can later be changed with {transferOwnership}.
2221  *
2222  * This module is used through inheritance. It will make available the modifier
2223  * `onlyOwner`, which can be applied to your functions to restrict their use to
2224  * the owner.
2225  */
2226 abstract contract Ownable is Context {
2227     address private _owner;
2228 
2229     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2230 
2231     /**
2232      * @dev Initializes the contract setting the deployer as the initial owner.
2233      */
2234     constructor() {
2235         _transferOwnership(_msgSender());
2236     }
2237 
2238     /**
2239      * @dev Throws if called by any account other than the owner.
2240      */
2241     modifier onlyOwner() {
2242         _checkOwner();
2243         _;
2244     }
2245 
2246     /**
2247      * @dev Returns the address of the current owner.
2248      */
2249     function owner() public view virtual returns (address) {
2250         return _owner;
2251     }
2252 
2253     /**
2254      * @dev Throws if the sender is not the owner.
2255      */
2256     function _checkOwner() internal view virtual {
2257         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2258     }
2259 
2260     /**
2261      * @dev Leaves the contract without owner. It will not be possible to call
2262      * `onlyOwner` functions anymore. Can only be called by the current owner.
2263      *
2264      * NOTE: Renouncing ownership will leave the contract without an owner,
2265      * thereby removing any functionality that is only available to the owner.
2266      */
2267     function renounceOwnership() public virtual onlyOwner {
2268         _transferOwnership(address(0));
2269     }
2270 
2271     /**
2272      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2273      * Can only be called by the current owner.
2274      */
2275     function transferOwnership(address newOwner) public virtual onlyOwner {
2276         require(newOwner != address(0), "Ownable: new owner is the zero address");
2277         _transferOwnership(newOwner);
2278     }
2279 
2280     /**
2281      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2282      * Internal function without access restriction.
2283      */
2284     function _transferOwnership(address newOwner) internal virtual {
2285         address oldOwner = _owner;
2286         _owner = newOwner;
2287         emit OwnershipTransferred(oldOwner, newOwner);
2288     }
2289 }
2290 
2291 // File: https://github.com/net2devcrypto/n2dstaking/N2DRewards.sol
2292 
2293 
2294 
2295 
2296 /*
2297 
2298 Follow/Subscribe Youtube, Github, IM, Tiktok
2299 for more amazing content!!
2300 @Net2Dev
2301 ███╗░░██╗███████╗████████╗██████╗░██████╗░███████╗██╗░░░██╗
2302 ████╗░██║██╔════╝╚══██╔══╝╚════██╗██╔══██╗██╔════╝██║░░░██║
2303 ██╔██╗██║█████╗░░░░░██║░░░░░███╔═╝██║░░██║█████╗░░╚██╗░██╔╝
2304 ██║╚████║██╔══╝░░░░░██║░░░██╔══╝░░██║░░██║██╔══╝░░░╚████╔╝░
2305 ██║░╚███║███████╗░░░██║░░░███████╗██████╔╝███████╗░░╚██╔╝░░
2306 ╚═╝░░╚══╝╚══════╝░░░╚═╝░░░╚══════╝╚═════╝░╚══════╝░░░╚═╝░░░
2307 THIS CONTRACT IS AVAILABLE FOR EDUCATIONAL 
2308 PURPOSES ONLY. YOU ARE SOLELY REPONSIBLE 
2309 FOR ITS USE. I AM NOT RESPONSIBLE FOR ANY
2310 OTHER USE. THIS IS TRAINING/EDUCATIONAL
2311 MATERIAL. ONLY USE IT IF YOU AGREE TO THE
2312 TERMS SPECIFIED ABOVE.
2313 */
2314 
2315 pragma solidity 0.8.4;
2316 
2317 
2318 
2319 
2320 
2321 contract N2DRewards is ERC20, ERC20Burnable, Ownable {
2322 
2323   mapping(address => bool) controllers;
2324   
2325   constructor() ERC20("N2DRewards", "N2DR") { }
2326 
2327   function mint(address to, uint256 amount) external {
2328     require(controllers[msg.sender], "Only controllers can mint");
2329     _mint(to, amount);
2330   }
2331 
2332   function burnFrom(address account, uint256 amount) public override {
2333       if (controllers[msg.sender]) {
2334           _burn(account, amount);
2335       }
2336       else {
2337           super.burnFrom(account, amount);
2338       }
2339   }
2340 
2341   function addController(address controller) external onlyOwner {
2342     controllers[controller] = true;
2343   }
2344 
2345   function removeController(address controller) external onlyOwner {
2346     controllers[controller] = false;
2347   }
2348 }
2349 
2350 // File: contracts/Staking2.sol
2351 
2352 
2353 
2354 
2355 /*
2356 
2357 Follow/Subscribe Youtube,
2358 for more amazing content!!
2359 @BlockBotz
2360 THIS CONTRACT IS AVAILABLE FOR EDUCATIONAL 
2361 PURPOSES ONLY. YOU ARE SOLELY REPONSIBLE 
2362 FOR ITS USE. I AM NOT RESPONSIBLE FOR ANY
2363 OTHER USE. THIS IS TRAINING/EDUCATIONAL
2364 MATERIAL.
2365 */
2366 
2367 pragma solidity 0.8.4;
2368 
2369 
2370 
2371 
2372 contract NFTStaking is Ownable, IERC721Receiver {
2373 
2374   uint256 public totalStaked;
2375   
2376   // struct to store a stake's token, owner, and earning values
2377   struct Stake {
2378     uint24 tokenId;
2379     uint48 timestamp;
2380     address owner;
2381   }
2382 
2383   event NFTStaked(address owner, uint256 tokenId, uint256 value);
2384   event NFTUnstaked(address owner, uint256 tokenId, uint256 value);
2385   event Claimed(address owner, uint256 amount);
2386 
2387   // reference to the Block NFT contract
2388   ERC721Enumerable nft;
2389   N2DRewards token;
2390 
2391   // maps tokenId to stake
2392   mapping(uint256 => Stake) public vault; 
2393 
2394    constructor(ERC721Enumerable _nft, N2DRewards _token) { 
2395     nft = _nft;
2396     token = _token;
2397   }
2398 
2399   function stake(uint256[] calldata tokenIds) external {
2400     uint256 tokenId;
2401     totalStaked += tokenIds.length;
2402     for (uint i = 0; i < tokenIds.length; i++) {
2403       tokenId = tokenIds[i];
2404       require(nft.ownerOf(tokenId) == msg.sender, "not your token");
2405       require(vault[tokenId].tokenId == 0, 'already staked');
2406 
2407       nft.transferFrom(msg.sender, address(this), tokenId);
2408       emit NFTStaked(msg.sender, tokenId, block.timestamp);
2409 
2410       vault[tokenId] = Stake({
2411         owner: msg.sender,
2412         tokenId: uint24(tokenId),
2413         timestamp: uint48(block.timestamp)
2414       });
2415     }
2416   }
2417 
2418   function _unstakeMany(address account, uint256[] calldata tokenIds) internal {
2419     uint256 tokenId;
2420     totalStaked -= tokenIds.length;
2421     for (uint i = 0; i < tokenIds.length; i++) {
2422       tokenId = tokenIds[i];
2423       Stake memory staked = vault[tokenId];
2424       require(staked.owner == msg.sender, "not an owner");
2425 
2426       delete vault[tokenId];
2427       emit NFTUnstaked(account, tokenId, block.timestamp);
2428       nft.transferFrom(address(this), account, tokenId);
2429     }
2430   }
2431 
2432   function claim(uint256[] calldata tokenIds) external {
2433       _claim(msg.sender, tokenIds, false);
2434   }
2435 
2436   function claimForAddress(address account, uint256[] calldata tokenIds) external {
2437       _claim(account, tokenIds, false);
2438   }
2439 
2440   function unstake(uint256[] calldata tokenIds) external {
2441       _claim(msg.sender, tokenIds, true);
2442   }
2443 
2444 // @blockbotzclub - Follow me on Youtube , Tiktok, Instagram
2445 // TOKEN REWARDS CALCULATION
2446 // MAKE SURE YOU CHANGE THE VALUE ON BOTH CLAIM AND EARNINGINFO FUNCTIONS.
2447 // Find the following line and update accordingly based on how much you want 
2448 // to reward users with ERC-20 reward tokens.
2449 // I hope you get the idea based on the example.
2450 // rewardmath = 100 ether .... (This gives 3 token per day per NFT staked to the staker)
2451 
2452 
2453   function _claim(address account, uint256[] calldata tokenIds, bool _unstake) internal {
2454     uint256 tokenId;
2455     uint256 earned = 0;
2456     uint256 rewardmath = 0;
2457 
2458     for (uint i = 0; i < tokenIds.length; i++) {
2459       tokenId = tokenIds[i];
2460       Stake memory staked = vault[tokenId];
2461       require(staked.owner == account, "not an owner");
2462       uint256 stakedAt = staked.timestamp;
2463       rewardmath = 100 ether * (block.timestamp - stakedAt) / 86400 ;
2464       earned = rewardmath / 100;
2465       vault[tokenId] = Stake({
2466         owner: account,
2467         tokenId: uint24(tokenId),
2468         timestamp: uint48(block.timestamp)
2469       });
2470     }
2471     if (earned > 0) {
2472       token.mint(account, earned);
2473     }
2474     if (_unstake) {
2475       _unstakeMany(account, tokenIds);
2476     }
2477     emit Claimed(account, earned);
2478   }
2479 
2480   function earningInfo(address account, uint256[] calldata tokenIds) external view returns (uint256[1] memory info) {
2481      uint256 tokenId;
2482      uint256 earned = 0;
2483      uint256 rewardmath = 0;
2484 
2485     for (uint i = 0; i < tokenIds.length; i++) {
2486       tokenId = tokenIds[i];
2487       Stake memory staked = vault[tokenId];
2488       require(staked.owner == account, "not an owner");
2489       uint256 stakedAt = staked.timestamp;
2490       rewardmath = 100 ether * (block.timestamp - stakedAt) / 86400;
2491       earned = rewardmath / 100;
2492 
2493     }
2494     if (earned > 0) {
2495       return [earned];
2496     }
2497 }
2498 
2499   // should never be used inside of transaction because of gas fee
2500   function balanceOf(address account) public view returns (uint256) {
2501     uint256 balance = 0;
2502     uint256 supply = nft.totalSupply();
2503     for(uint i = 1; i <= supply; i++) {
2504       if (vault[i].owner == account) {
2505         balance += 1;
2506       }
2507     }
2508     return balance;
2509   }
2510 
2511   // should never be used inside of transaction because of gas fee
2512   function tokensOfOwner(address account) public view returns (uint256[] memory ownerTokens) {
2513 
2514     uint256 supply = nft.totalSupply();
2515     uint256[] memory tmp = new uint256[](supply);
2516 
2517     uint256 index = 0;
2518     for(uint tokenId = 1; tokenId <= supply; tokenId++) {
2519       if (vault[tokenId].owner == account) {
2520         tmp[index] = vault[tokenId].tokenId;
2521         index +=1;
2522       }
2523     }
2524 
2525     uint256[] memory tokens = new uint256[](index);
2526     for(uint i = 0; i < index; i++) {
2527       tokens[i] = tmp[i];
2528     }
2529 
2530     return tokens;
2531   }
2532 
2533   function onERC721Received(
2534         address,
2535         address from,
2536         uint256,
2537         bytes calldata
2538     ) external pure override returns (bytes4) {
2539       require(from == address(0x0), "Cannot send nfts to Vault directly");
2540       return IERC721Receiver.onERC721Received.selector;
2541     }
2542   
2543 }