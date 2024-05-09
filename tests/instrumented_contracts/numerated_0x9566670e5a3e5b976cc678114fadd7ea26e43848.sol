1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Standard math utilities missing in the Solidity language.
11  */
12 library Math {
13     enum Rounding {
14         Down, // Toward negative infinity
15         Up, // Toward infinity
16         Zero // Toward zero
17     }
18 
19     /**
20      * @dev Returns the largest of two numbers.
21      */
22     function max(uint256 a, uint256 b) internal pure returns (uint256) {
23         return a > b ? a : b;
24     }
25 
26     /**
27      * @dev Returns the smallest of two numbers.
28      */
29     function min(uint256 a, uint256 b) internal pure returns (uint256) {
30         return a < b ? a : b;
31     }
32 
33     /**
34      * @dev Returns the average of two numbers. The result is rounded towards
35      * zero.
36      */
37     function average(uint256 a, uint256 b) internal pure returns (uint256) {
38         // (a + b) / 2 can overflow.
39         return (a & b) + (a ^ b) / 2;
40     }
41 
42     /**
43      * @dev Returns the ceiling of the division of two numbers.
44      *
45      * This differs from standard division with `/` in that it rounds up instead
46      * of rounding down.
47      */
48     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
49         // (a + b - 1) / b can overflow on addition, so we distribute.
50         return a == 0 ? 0 : (a - 1) / b + 1;
51     }
52 
53     /**
54      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
55      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
56      * with further edits by Uniswap Labs also under MIT license.
57      */
58     function mulDiv(
59         uint256 x,
60         uint256 y,
61         uint256 denominator
62     ) internal pure returns (uint256 result) {
63         unchecked {
64             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
65             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
66             // variables such that product = prod1 * 2^256 + prod0.
67             uint256 prod0; // Least significant 256 bits of the product
68             uint256 prod1; // Most significant 256 bits of the product
69             assembly {
70                 let mm := mulmod(x, y, not(0))
71                 prod0 := mul(x, y)
72                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
73             }
74 
75             // Handle non-overflow cases, 256 by 256 division.
76             if (prod1 == 0) {
77                 return prod0 / denominator;
78             }
79 
80             // Make sure the result is less than 2^256. Also prevents denominator == 0.
81             require(denominator > prod1);
82 
83             ///////////////////////////////////////////////
84             // 512 by 256 division.
85             ///////////////////////////////////////////////
86 
87             // Make division exact by subtracting the remainder from [prod1 prod0].
88             uint256 remainder;
89             assembly {
90                 // Compute remainder using mulmod.
91                 remainder := mulmod(x, y, denominator)
92 
93                 // Subtract 256 bit number from 512 bit number.
94                 prod1 := sub(prod1, gt(remainder, prod0))
95                 prod0 := sub(prod0, remainder)
96             }
97 
98             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
99             // See https://cs.stackexchange.com/q/138556/92363.
100 
101             // Does not overflow because the denominator cannot be zero at this stage in the function.
102             uint256 twos = denominator & (~denominator + 1);
103             assembly {
104                 // Divide denominator by twos.
105                 denominator := div(denominator, twos)
106 
107                 // Divide [prod1 prod0] by twos.
108                 prod0 := div(prod0, twos)
109 
110                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
111                 twos := add(div(sub(0, twos), twos), 1)
112             }
113 
114             // Shift in bits from prod1 into prod0.
115             prod0 |= prod1 * twos;
116 
117             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
118             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
119             // four bits. That is, denominator * inv = 1 mod 2^4.
120             uint256 inverse = (3 * denominator) ^ 2;
121 
122             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
123             // in modular arithmetic, doubling the correct bits in each step.
124             inverse *= 2 - denominator * inverse; // inverse mod 2^8
125             inverse *= 2 - denominator * inverse; // inverse mod 2^16
126             inverse *= 2 - denominator * inverse; // inverse mod 2^32
127             inverse *= 2 - denominator * inverse; // inverse mod 2^64
128             inverse *= 2 - denominator * inverse; // inverse mod 2^128
129             inverse *= 2 - denominator * inverse; // inverse mod 2^256
130 
131             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
132             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
133             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
134             // is no longer required.
135             result = prod0 * inverse;
136             return result;
137         }
138     }
139 
140     /**
141      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
142      */
143     function mulDiv(
144         uint256 x,
145         uint256 y,
146         uint256 denominator,
147         Rounding rounding
148     ) internal pure returns (uint256) {
149         uint256 result = mulDiv(x, y, denominator);
150         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
151             result += 1;
152         }
153         return result;
154     }
155 
156     /**
157      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
158      *
159      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
160      */
161     function sqrt(uint256 a) internal pure returns (uint256) {
162         if (a == 0) {
163             return 0;
164         }
165 
166         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
167         //
168         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
169         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
170         //
171         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
172         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
173         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
174         //
175         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
176         uint256 result = 1 << (log2(a) >> 1);
177 
178         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
179         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
180         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
181         // into the expected uint128 result.
182         unchecked {
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             return min(result, a / result);
191         }
192     }
193 
194     /**
195      * @notice Calculates sqrt(a), following the selected rounding direction.
196      */
197     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
198         unchecked {
199             uint256 result = sqrt(a);
200             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
201         }
202     }
203 
204     /**
205      * @dev Return the log in base 2, rounded down, of a positive value.
206      * Returns 0 if given 0.
207      */
208     function log2(uint256 value) internal pure returns (uint256) {
209         uint256 result = 0;
210         unchecked {
211             if (value >> 128 > 0) {
212                 value >>= 128;
213                 result += 128;
214             }
215             if (value >> 64 > 0) {
216                 value >>= 64;
217                 result += 64;
218             }
219             if (value >> 32 > 0) {
220                 value >>= 32;
221                 result += 32;
222             }
223             if (value >> 16 > 0) {
224                 value >>= 16;
225                 result += 16;
226             }
227             if (value >> 8 > 0) {
228                 value >>= 8;
229                 result += 8;
230             }
231             if (value >> 4 > 0) {
232                 value >>= 4;
233                 result += 4;
234             }
235             if (value >> 2 > 0) {
236                 value >>= 2;
237                 result += 2;
238             }
239             if (value >> 1 > 0) {
240                 result += 1;
241             }
242         }
243         return result;
244     }
245 
246     /**
247      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
248      * Returns 0 if given 0.
249      */
250     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
251         unchecked {
252             uint256 result = log2(value);
253             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
254         }
255     }
256 
257     /**
258      * @dev Return the log in base 10, rounded down, of a positive value.
259      * Returns 0 if given 0.
260      */
261     function log10(uint256 value) internal pure returns (uint256) {
262         uint256 result = 0;
263         unchecked {
264             if (value >= 10**64) {
265                 value /= 10**64;
266                 result += 64;
267             }
268             if (value >= 10**32) {
269                 value /= 10**32;
270                 result += 32;
271             }
272             if (value >= 10**16) {
273                 value /= 10**16;
274                 result += 16;
275             }
276             if (value >= 10**8) {
277                 value /= 10**8;
278                 result += 8;
279             }
280             if (value >= 10**4) {
281                 value /= 10**4;
282                 result += 4;
283             }
284             if (value >= 10**2) {
285                 value /= 10**2;
286                 result += 2;
287             }
288             if (value >= 10**1) {
289                 result += 1;
290             }
291         }
292         return result;
293     }
294 
295     /**
296      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
297      * Returns 0 if given 0.
298      */
299     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
300         unchecked {
301             uint256 result = log10(value);
302             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
303         }
304     }
305 
306     /**
307      * @dev Return the log in base 256, rounded down, of a positive value.
308      * Returns 0 if given 0.
309      *
310      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
311      */
312     function log256(uint256 value) internal pure returns (uint256) {
313         uint256 result = 0;
314         unchecked {
315             if (value >> 128 > 0) {
316                 value >>= 128;
317                 result += 16;
318             }
319             if (value >> 64 > 0) {
320                 value >>= 64;
321                 result += 8;
322             }
323             if (value >> 32 > 0) {
324                 value >>= 32;
325                 result += 4;
326             }
327             if (value >> 16 > 0) {
328                 value >>= 16;
329                 result += 2;
330             }
331             if (value >> 8 > 0) {
332                 result += 1;
333             }
334         }
335         return result;
336     }
337 
338     /**
339      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
340      * Returns 0 if given 0.
341      */
342     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
343         unchecked {
344             uint256 result = log256(value);
345             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
346         }
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/Strings.sol
351 
352 
353 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
354 
355 pragma solidity ^0.8.0;
356 
357 
358 /**
359  * @dev String operations.
360  */
361 library Strings {
362     bytes16 private constant _SYMBOLS = "0123456789abcdef";
363     uint8 private constant _ADDRESS_LENGTH = 20;
364 
365     /**
366      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
367      */
368     function toString(uint256 value) internal pure returns (string memory) {
369         unchecked {
370             uint256 length = Math.log10(value) + 1;
371             string memory buffer = new string(length);
372             uint256 ptr;
373             /// @solidity memory-safe-assembly
374             assembly {
375                 ptr := add(buffer, add(32, length))
376             }
377             while (true) {
378                 ptr--;
379                 /// @solidity memory-safe-assembly
380                 assembly {
381                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
382                 }
383                 value /= 10;
384                 if (value == 0) break;
385             }
386             return buffer;
387         }
388     }
389 
390     /**
391      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
392      */
393     function toHexString(uint256 value) internal pure returns (string memory) {
394         unchecked {
395             return toHexString(value, Math.log256(value) + 1);
396         }
397     }
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
401      */
402     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
403         bytes memory buffer = new bytes(2 * length + 2);
404         buffer[0] = "0";
405         buffer[1] = "x";
406         for (uint256 i = 2 * length + 1; i > 1; --i) {
407             buffer[i] = _SYMBOLS[value & 0xf];
408             value >>= 4;
409         }
410         require(value == 0, "Strings: hex length insufficient");
411         return string(buffer);
412     }
413 
414     /**
415      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
416      */
417     function toHexString(address addr) internal pure returns (string memory) {
418         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
419     }
420 }
421 
422 // File: @openzeppelin/contracts/utils/Address.sol
423 
424 
425 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
426 
427 pragma solidity ^0.8.1;
428 
429 /**
430  * @dev Collection of functions related to the address type
431  */
432 library Address {
433     /**
434      * @dev Returns true if `account` is a contract.
435      *
436      * [IMPORTANT]
437      * ====
438      * It is unsafe to assume that an address for which this function returns
439      * false is an externally-owned account (EOA) and not a contract.
440      *
441      * Among others, `isContract` will return false for the following
442      * types of addresses:
443      *
444      *  - an externally-owned account
445      *  - a contract in construction
446      *  - an address where a contract will be created
447      *  - an address where a contract lived, but was destroyed
448      * ====
449      *
450      * [IMPORTANT]
451      * ====
452      * You shouldn't rely on `isContract` to protect against flash loan attacks!
453      *
454      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
455      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
456      * constructor.
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies on extcodesize/address.code.length, which returns 0
461         // for contracts in construction, since the code is only stored at the end
462         // of the constructor execution.
463 
464         return account.code.length > 0;
465     }
466 
467     /**
468      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
469      * `recipient`, forwarding all available gas and reverting on errors.
470      *
471      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
472      * of certain opcodes, possibly making contracts go over the 2300 gas limit
473      * imposed by `transfer`, making them unable to receive funds via
474      * `transfer`. {sendValue} removes this limitation.
475      *
476      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
477      *
478      * IMPORTANT: because control is transferred to `recipient`, care must be
479      * taken to not create reentrancy vulnerabilities. Consider using
480      * {ReentrancyGuard} or the
481      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
482      */
483     function sendValue(address payable recipient, uint256 amount) internal {
484         require(address(this).balance >= amount, "Address: insufficient balance");
485 
486         (bool success, ) = recipient.call{value: amount}("");
487         require(success, "Address: unable to send value, recipient may have reverted");
488     }
489 
490     /**
491      * @dev Performs a Solidity function call using a low level `call`. A
492      * plain `call` is an unsafe replacement for a function call: use this
493      * function instead.
494      *
495      * If `target` reverts with a revert reason, it is bubbled up by this
496      * function (like regular Solidity function calls).
497      *
498      * Returns the raw returned data. To convert to the expected return value,
499      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
500      *
501      * Requirements:
502      *
503      * - `target` must be a contract.
504      * - calling `target` with `data` must not revert.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
509         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
514      * `errorMessage` as a fallback revert reason when `target` reverts.
515      *
516      * _Available since v3.1._
517      */
518     function functionCall(
519         address target,
520         bytes memory data,
521         string memory errorMessage
522     ) internal returns (bytes memory) {
523         return functionCallWithValue(target, data, 0, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but also transferring `value` wei to `target`.
529      *
530      * Requirements:
531      *
532      * - the calling contract must have an ETH balance of at least `value`.
533      * - the called Solidity function must be `payable`.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(
538         address target,
539         bytes memory data,
540         uint256 value
541     ) internal returns (bytes memory) {
542         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
543     }
544 
545     /**
546      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
547      * with `errorMessage` as a fallback revert reason when `target` reverts.
548      *
549      * _Available since v3.1._
550      */
551     function functionCallWithValue(
552         address target,
553         bytes memory data,
554         uint256 value,
555         string memory errorMessage
556     ) internal returns (bytes memory) {
557         require(address(this).balance >= value, "Address: insufficient balance for call");
558         (bool success, bytes memory returndata) = target.call{value: value}(data);
559         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
560     }
561 
562     /**
563      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
564      * but performing a static call.
565      *
566      * _Available since v3.3._
567      */
568     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
569         return functionStaticCall(target, data, "Address: low-level static call failed");
570     }
571 
572     /**
573      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
574      * but performing a static call.
575      *
576      * _Available since v3.3._
577      */
578     function functionStaticCall(
579         address target,
580         bytes memory data,
581         string memory errorMessage
582     ) internal view returns (bytes memory) {
583         (bool success, bytes memory returndata) = target.staticcall(data);
584         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
585     }
586 
587     /**
588      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
589      * but performing a delegate call.
590      *
591      * _Available since v3.4._
592      */
593     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
594         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
595     }
596 
597     /**
598      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
599      * but performing a delegate call.
600      *
601      * _Available since v3.4._
602      */
603     function functionDelegateCall(
604         address target,
605         bytes memory data,
606         string memory errorMessage
607     ) internal returns (bytes memory) {
608         (bool success, bytes memory returndata) = target.delegatecall(data);
609         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
610     }
611 
612     /**
613      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
614      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
615      *
616      * _Available since v4.8._
617      */
618     function verifyCallResultFromTarget(
619         address target,
620         bool success,
621         bytes memory returndata,
622         string memory errorMessage
623     ) internal view returns (bytes memory) {
624         if (success) {
625             if (returndata.length == 0) {
626                 // only check isContract if the call was successful and the return data is empty
627                 // otherwise we already know that it was a contract
628                 require(isContract(target), "Address: call to non-contract");
629             }
630             return returndata;
631         } else {
632             _revert(returndata, errorMessage);
633         }
634     }
635 
636     /**
637      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
638      * revert reason or using the provided one.
639      *
640      * _Available since v4.3._
641      */
642     function verifyCallResult(
643         bool success,
644         bytes memory returndata,
645         string memory errorMessage
646     ) internal pure returns (bytes memory) {
647         if (success) {
648             return returndata;
649         } else {
650             _revert(returndata, errorMessage);
651         }
652     }
653 
654     function _revert(bytes memory returndata, string memory errorMessage) private pure {
655         // Look for revert reason and bubble it up if present
656         if (returndata.length > 0) {
657             // The easiest way to bubble the revert reason is using memory via assembly
658             /// @solidity memory-safe-assembly
659             assembly {
660                 let returndata_size := mload(returndata)
661                 revert(add(32, returndata), returndata_size)
662             }
663         } else {
664             revert(errorMessage);
665         }
666     }
667 }
668 
669 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
670 
671 
672 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @title ERC721 token receiver interface
678  * @dev Interface for any contract that wants to support safeTransfers
679  * from ERC721 asset contracts.
680  */
681 interface IERC721Receiver {
682     /**
683      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
684      * by `operator` from `from`, this function is called.
685      *
686      * It must return its Solidity selector to confirm the token transfer.
687      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
688      *
689      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
690      */
691     function onERC721Received(
692         address operator,
693         address from,
694         uint256 tokenId,
695         bytes calldata data
696     ) external returns (bytes4);
697 }
698 
699 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
700 
701 
702 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
703 
704 pragma solidity ^0.8.0;
705 
706 /**
707  * @dev Interface of the ERC165 standard, as defined in the
708  * https://eips.ethereum.org/EIPS/eip-165[EIP].
709  *
710  * Implementers can declare support of contract interfaces, which can then be
711  * queried by others ({ERC165Checker}).
712  *
713  * For an implementation, see {ERC165}.
714  */
715 interface IERC165 {
716     /**
717      * @dev Returns true if this contract implements the interface defined by
718      * `interfaceId`. See the corresponding
719      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
720      * to learn more about how these ids are created.
721      *
722      * This function call must use less than 30 000 gas.
723      */
724     function supportsInterface(bytes4 interfaceId) external view returns (bool);
725 }
726 
727 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
728 
729 
730 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
731 
732 pragma solidity ^0.8.0;
733 
734 
735 /**
736  * @dev Implementation of the {IERC165} interface.
737  *
738  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
739  * for the additional interface id that will be supported. For example:
740  *
741  * ```solidity
742  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
743  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
744  * }
745  * ```
746  *
747  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
748  */
749 abstract contract ERC165 is IERC165 {
750     /**
751      * @dev See {IERC165-supportsInterface}.
752      */
753     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
754         return interfaceId == type(IERC165).interfaceId;
755     }
756 }
757 
758 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
759 
760 
761 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 
766 /**
767  * @dev Required interface of an ERC721 compliant contract.
768  */
769 interface IERC721 is IERC165 {
770     /**
771      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
772      */
773     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
774 
775     /**
776      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
777      */
778     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
779 
780     /**
781      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
782      */
783     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
784 
785     /**
786      * @dev Returns the number of tokens in ``owner``'s account.
787      */
788     function balanceOf(address owner) external view returns (uint256 balance);
789 
790     /**
791      * @dev Returns the owner of the `tokenId` token.
792      *
793      * Requirements:
794      *
795      * - `tokenId` must exist.
796      */
797     function ownerOf(uint256 tokenId) external view returns (address owner);
798 
799     /**
800      * @dev Safely transfers `tokenId` token from `from` to `to`.
801      *
802      * Requirements:
803      *
804      * - `from` cannot be the zero address.
805      * - `to` cannot be the zero address.
806      * - `tokenId` token must exist and be owned by `from`.
807      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
809      *
810      * Emits a {Transfer} event.
811      */
812     function safeTransferFrom(
813         address from,
814         address to,
815         uint256 tokenId,
816         bytes calldata data
817     ) external;
818 
819     /**
820      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
821      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
822      *
823      * Requirements:
824      *
825      * - `from` cannot be the zero address.
826      * - `to` cannot be the zero address.
827      * - `tokenId` token must exist and be owned by `from`.
828      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
829      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
830      *
831      * Emits a {Transfer} event.
832      */
833     function safeTransferFrom(
834         address from,
835         address to,
836         uint256 tokenId
837     ) external;
838 
839     /**
840      * @dev Transfers `tokenId` token from `from` to `to`.
841      *
842      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
843      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
844      * understand this adds an external call which potentially creates a reentrancy vulnerability.
845      *
846      * Requirements:
847      *
848      * - `from` cannot be the zero address.
849      * - `to` cannot be the zero address.
850      * - `tokenId` token must be owned by `from`.
851      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
852      *
853      * Emits a {Transfer} event.
854      */
855     function transferFrom(
856         address from,
857         address to,
858         uint256 tokenId
859     ) external;
860 
861     /**
862      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
863      * The approval is cleared when the token is transferred.
864      *
865      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
866      *
867      * Requirements:
868      *
869      * - The caller must own the token or be an approved operator.
870      * - `tokenId` must exist.
871      *
872      * Emits an {Approval} event.
873      */
874     function approve(address to, uint256 tokenId) external;
875 
876     /**
877      * @dev Approve or remove `operator` as an operator for the caller.
878      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
879      *
880      * Requirements:
881      *
882      * - The `operator` cannot be the caller.
883      *
884      * Emits an {ApprovalForAll} event.
885      */
886     function setApprovalForAll(address operator, bool _approved) external;
887 
888     /**
889      * @dev Returns the account approved for `tokenId` token.
890      *
891      * Requirements:
892      *
893      * - `tokenId` must exist.
894      */
895     function getApproved(uint256 tokenId) external view returns (address operator);
896 
897     /**
898      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
899      *
900      * See {setApprovalForAll}
901      */
902     function isApprovedForAll(address owner, address operator) external view returns (bool);
903 }
904 
905 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
906 
907 
908 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
909 
910 pragma solidity ^0.8.0;
911 
912 
913 /**
914  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
915  * @dev See https://eips.ethereum.org/EIPS/eip-721
916  */
917 interface IERC721Metadata is IERC721 {
918     /**
919      * @dev Returns the token collection name.
920      */
921     function name() external view returns (string memory);
922 
923     /**
924      * @dev Returns the token collection symbol.
925      */
926     function symbol() external view returns (string memory);
927 
928     /**
929      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
930      */
931     function tokenURI(uint256 tokenId) external view returns (string memory);
932 }
933 
934 // File: @openzeppelin/contracts/utils/Context.sol
935 
936 
937 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
938 
939 pragma solidity ^0.8.0;
940 
941 /**
942  * @dev Provides information about the current execution context, including the
943  * sender of the transaction and its data. While these are generally available
944  * via msg.sender and msg.data, they should not be accessed in such a direct
945  * manner, since when dealing with meta-transactions the account sending and
946  * paying for execution may not be the actual sender (as far as an application
947  * is concerned).
948  *
949  * This contract is only required for intermediate, library-like contracts.
950  */
951 abstract contract Context {
952     function _msgSender() internal view virtual returns (address) {
953         return msg.sender;
954     }
955 
956     function _msgData() internal view virtual returns (bytes calldata) {
957         return msg.data;
958     }
959 }
960 
961 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
962 
963 
964 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
965 
966 pragma solidity ^0.8.0;
967 
968 
969 
970 
971 
972 
973 
974 
975 /**
976  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
977  * the Metadata extension, but not including the Enumerable extension, which is available separately as
978  * {ERC721Enumerable}.
979  */
980 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
981     using Address for address;
982     using Strings for uint256;
983 
984     // Token name
985     string private _name;
986 
987     // Token symbol
988     string private _symbol;
989 
990     // Mapping from token ID to owner address
991     mapping(uint256 => address) private _owners;
992 
993     // Mapping owner address to token count
994     mapping(address => uint256) private _balances;
995 
996     // Mapping from token ID to approved address
997     mapping(uint256 => address) private _tokenApprovals;
998 
999     // Mapping from owner to operator approvals
1000     mapping(address => mapping(address => bool)) private _operatorApprovals;
1001 
1002     /**
1003      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1004      */
1005     constructor(string memory name_, string memory symbol_) {
1006         _name = name_;
1007         _symbol = symbol_;
1008     }
1009 
1010     /**
1011      * @dev See {IERC165-supportsInterface}.
1012      */
1013     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1014         return
1015             interfaceId == type(IERC721).interfaceId ||
1016             interfaceId == type(IERC721Metadata).interfaceId ||
1017             super.supportsInterface(interfaceId);
1018     }
1019 
1020     /**
1021      * @dev See {IERC721-balanceOf}.
1022      */
1023     function balanceOf(address owner) public view virtual override returns (uint256) {
1024         require(owner != address(0), "ERC721: address zero is not a valid owner");
1025         return _balances[owner];
1026     }
1027 
1028     /**
1029      * @dev See {IERC721-ownerOf}.
1030      */
1031     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1032         address owner = _ownerOf(tokenId);
1033         require(owner != address(0), "ERC721: invalid token ID");
1034         return owner;
1035     }
1036 
1037     /**
1038      * @dev See {IERC721Metadata-name}.
1039      */
1040     function name() public view virtual override returns (string memory) {
1041         return _name;
1042     }
1043 
1044     /**
1045      * @dev See {IERC721Metadata-symbol}.
1046      */
1047     function symbol() public view virtual override returns (string memory) {
1048         return _symbol;
1049     }
1050 
1051     /**
1052      * @dev See {IERC721Metadata-tokenURI}.
1053      */
1054     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1055         _requireMinted(tokenId);
1056 
1057         string memory baseURI = _baseURI();
1058         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1059     }
1060 
1061     /**
1062      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1063      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1064      * by default, can be overridden in child contracts.
1065      */
1066     function _baseURI() internal view virtual returns (string memory) {
1067         return "";
1068     }
1069 
1070     /**
1071      * @dev See {IERC721-approve}.
1072      */
1073     function approve(address to, uint256 tokenId) public virtual override {
1074         address owner = ERC721.ownerOf(tokenId);
1075         require(to != owner, "ERC721: approval to current owner");
1076 
1077         require(
1078             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1079             "ERC721: approve caller is not token owner or approved for all"
1080         );
1081 
1082         _approve(to, tokenId);
1083     }
1084 
1085     /**
1086      * @dev See {IERC721-getApproved}.
1087      */
1088     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1089         _requireMinted(tokenId);
1090 
1091         return _tokenApprovals[tokenId];
1092     }
1093 
1094     /**
1095      * @dev See {IERC721-setApprovalForAll}.
1096      */
1097     function setApprovalForAll(address operator, bool approved) public virtual override {
1098         _setApprovalForAll(_msgSender(), operator, approved);
1099     }
1100 
1101     /**
1102      * @dev See {IERC721-isApprovedForAll}.
1103      */
1104     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1105         return _operatorApprovals[owner][operator];
1106     }
1107 
1108     /**
1109      * @dev See {IERC721-transferFrom}.
1110      */
1111     function transferFrom(
1112         address from,
1113         address to,
1114         uint256 tokenId
1115     ) public virtual override {
1116         //solhint-disable-next-line max-line-length
1117         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1118 
1119         _transfer(from, to, tokenId);
1120     }
1121 
1122     /**
1123      * @dev See {IERC721-safeTransferFrom}.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId
1129     ) public virtual override {
1130         safeTransferFrom(from, to, tokenId, "");
1131     }
1132 
1133     /**
1134      * @dev See {IERC721-safeTransferFrom}.
1135      */
1136     function safeTransferFrom(
1137         address from,
1138         address to,
1139         uint256 tokenId,
1140         bytes memory data
1141     ) public virtual override {
1142         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1143         _safeTransfer(from, to, tokenId, data);
1144     }
1145 
1146     /**
1147      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1148      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1149      *
1150      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1151      *
1152      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1153      * implement alternative mechanisms to perform token transfer, such as signature-based.
1154      *
1155      * Requirements:
1156      *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must exist and be owned by `from`.
1160      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1161      *
1162      * Emits a {Transfer} event.
1163      */
1164     function _safeTransfer(
1165         address from,
1166         address to,
1167         uint256 tokenId,
1168         bytes memory data
1169     ) internal virtual {
1170         _transfer(from, to, tokenId);
1171         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1172     }
1173 
1174     /**
1175      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1176      */
1177     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1178         return _owners[tokenId];
1179     }
1180 
1181     /**
1182      * @dev Returns whether `tokenId` exists.
1183      *
1184      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1185      *
1186      * Tokens start existing when they are minted (`_mint`),
1187      * and stop existing when they are burned (`_burn`).
1188      */
1189     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1190         return _ownerOf(tokenId) != address(0);
1191     }
1192 
1193     /**
1194      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1195      *
1196      * Requirements:
1197      *
1198      * - `tokenId` must exist.
1199      */
1200     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1201         address owner = ERC721.ownerOf(tokenId);
1202         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1203     }
1204 
1205     /**
1206      * @dev Safely mints `tokenId` and transfers it to `to`.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must not exist.
1211      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1212      *
1213      * Emits a {Transfer} event.
1214      */
1215     function _safeMint(address to, uint256 tokenId) internal virtual {
1216         _safeMint(to, tokenId, "");
1217     }
1218 
1219     /**
1220      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1221      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1222      */
1223     function _safeMint(
1224         address to,
1225         uint256 tokenId,
1226         bytes memory data
1227     ) internal virtual {
1228         _mint(to, tokenId);
1229         require(
1230             _checkOnERC721Received(address(0), to, tokenId, data),
1231             "ERC721: transfer to non ERC721Receiver implementer"
1232         );
1233     }
1234 
1235     /**
1236      * @dev Mints `tokenId` and transfers it to `to`.
1237      *
1238      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1239      *
1240      * Requirements:
1241      *
1242      * - `tokenId` must not exist.
1243      * - `to` cannot be the zero address.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function _mint(address to, uint256 tokenId) internal virtual {
1248         require(to != address(0), "ERC721: mint to the zero address");
1249         require(!_exists(tokenId), "ERC721: token already minted");
1250 
1251         _beforeTokenTransfer(address(0), to, tokenId, 1);
1252 
1253         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1254         require(!_exists(tokenId), "ERC721: token already minted");
1255 
1256         unchecked {
1257             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1258             // Given that tokens are minted one by one, it is impossible in practice that
1259             // this ever happens. Might change if we allow batch minting.
1260             // The ERC fails to describe this case.
1261             _balances[to] += 1;
1262         }
1263 
1264         _owners[tokenId] = to;
1265 
1266         emit Transfer(address(0), to, tokenId);
1267 
1268         _afterTokenTransfer(address(0), to, tokenId, 1);
1269     }
1270 
1271     /**
1272      * @dev Destroys `tokenId`.
1273      * The approval is cleared when the token is burned.
1274      * This is an internal function that does not check if the sender is authorized to operate on the token.
1275      *
1276      * Requirements:
1277      *
1278      * - `tokenId` must exist.
1279      *
1280      * Emits a {Transfer} event.
1281      */
1282     function _burn(uint256 tokenId) internal virtual {
1283         address owner = ERC721.ownerOf(tokenId);
1284 
1285         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1286 
1287         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1288         owner = ERC721.ownerOf(tokenId);
1289 
1290         // Clear approvals
1291         delete _tokenApprovals[tokenId];
1292 
1293         unchecked {
1294             // Cannot overflow, as that would require more tokens to be burned/transferred
1295             // out than the owner initially received through minting and transferring in.
1296             _balances[owner] -= 1;
1297         }
1298         delete _owners[tokenId];
1299 
1300         emit Transfer(owner, address(0), tokenId);
1301 
1302         _afterTokenTransfer(owner, address(0), tokenId, 1);
1303     }
1304 
1305     /**
1306      * @dev Transfers `tokenId` from `from` to `to`.
1307      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1308      *
1309      * Requirements:
1310      *
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must be owned by `from`.
1313      *
1314      * Emits a {Transfer} event.
1315      */
1316     function _transfer(
1317         address from,
1318         address to,
1319         uint256 tokenId
1320     ) internal virtual {
1321         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1322         require(to != address(0), "ERC721: transfer to the zero address");
1323 
1324         _beforeTokenTransfer(from, to, tokenId, 1);
1325 
1326         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1327         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1328 
1329         // Clear approvals from the previous owner
1330         delete _tokenApprovals[tokenId];
1331 
1332         unchecked {
1333             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1334             // `from`'s balance is the number of token held, which is at least one before the current
1335             // transfer.
1336             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1337             // all 2**256 token ids to be minted, which in practice is impossible.
1338             _balances[from] -= 1;
1339             _balances[to] += 1;
1340         }
1341         _owners[tokenId] = to;
1342 
1343         emit Transfer(from, to, tokenId);
1344 
1345         _afterTokenTransfer(from, to, tokenId, 1);
1346     }
1347 
1348     /**
1349      * @dev Approve `to` to operate on `tokenId`
1350      *
1351      * Emits an {Approval} event.
1352      */
1353     function _approve(address to, uint256 tokenId) internal virtual {
1354         _tokenApprovals[tokenId] = to;
1355         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1356     }
1357 
1358     /**
1359      * @dev Approve `operator` to operate on all of `owner` tokens
1360      *
1361      * Emits an {ApprovalForAll} event.
1362      */
1363     function _setApprovalForAll(
1364         address owner,
1365         address operator,
1366         bool approved
1367     ) internal virtual {
1368         require(owner != operator, "ERC721: approve to caller");
1369         _operatorApprovals[owner][operator] = approved;
1370         emit ApprovalForAll(owner, operator, approved);
1371     }
1372 
1373     /**
1374      * @dev Reverts if the `tokenId` has not been minted yet.
1375      */
1376     function _requireMinted(uint256 tokenId) internal view virtual {
1377         require(_exists(tokenId), "ERC721: invalid token ID");
1378     }
1379 
1380     /**
1381      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1382      * The call is not executed if the target address is not a contract.
1383      *
1384      * @param from address representing the previous owner of the given token ID
1385      * @param to target address that will receive the tokens
1386      * @param tokenId uint256 ID of the token to be transferred
1387      * @param data bytes optional data to send along with the call
1388      * @return bool whether the call correctly returned the expected magic value
1389      */
1390     function _checkOnERC721Received(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory data
1395     ) private returns (bool) {
1396         if (to.isContract()) {
1397             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1398                 return retval == IERC721Receiver.onERC721Received.selector;
1399             } catch (bytes memory reason) {
1400                 if (reason.length == 0) {
1401                     revert("ERC721: transfer to non ERC721Receiver implementer");
1402                 } else {
1403                     /// @solidity memory-safe-assembly
1404                     assembly {
1405                         revert(add(32, reason), mload(reason))
1406                     }
1407                 }
1408             }
1409         } else {
1410             return true;
1411         }
1412     }
1413 
1414     /**
1415      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1416      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1417      *
1418      * Calling conditions:
1419      *
1420      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1421      * - When `from` is zero, the tokens will be minted for `to`.
1422      * - When `to` is zero, ``from``'s tokens will be burned.
1423      * - `from` and `to` are never both zero.
1424      * - `batchSize` is non-zero.
1425      *
1426      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1427      */
1428     function _beforeTokenTransfer(
1429         address from,
1430         address to,
1431         uint256 firstTokenId,
1432         uint256 batchSize
1433     ) internal virtual {}
1434 
1435     /**
1436      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1437      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1438      *
1439      * Calling conditions:
1440      *
1441      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1442      * - When `from` is zero, the tokens were minted for `to`.
1443      * - When `to` is zero, ``from``'s tokens were burned.
1444      * - `from` and `to` are never both zero.
1445      * - `batchSize` is non-zero.
1446      *
1447      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1448      */
1449     function _afterTokenTransfer(
1450         address from,
1451         address to,
1452         uint256 firstTokenId,
1453         uint256 batchSize
1454     ) internal virtual {}
1455 
1456     /**
1457      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1458      *
1459      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1460      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1461      * that `ownerOf(tokenId)` is `a`.
1462      */
1463     // solhint-disable-next-line func-name-mixedcase
1464     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1465         _balances[account] += amount;
1466     }
1467 }
1468 
1469 // File: @openzeppelin/contracts/access/Ownable.sol
1470 
1471 
1472 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1473 
1474 pragma solidity ^0.8.0;
1475 
1476 
1477 /**
1478  * @dev Contract module which provides a basic access control mechanism, where
1479  * there is an account (an owner) that can be granted exclusive access to
1480  * specific functions.
1481  *
1482  * By default, the owner account will be the one that deploys the contract. This
1483  * can later be changed with {transferOwnership}.
1484  *
1485  * This module is used through inheritance. It will make available the modifier
1486  * `onlyOwner`, which can be applied to your functions to restrict their use to
1487  * the owner.
1488  */
1489 abstract contract Ownable is Context {
1490     address private _owner;
1491 
1492     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1493 
1494     /**
1495      * @dev Initializes the contract setting the deployer as the initial owner.
1496      */
1497     constructor() {
1498         _transferOwnership(_msgSender());
1499     }
1500 
1501     /**
1502      * @dev Throws if called by any account other than the owner.
1503      */
1504     modifier onlyOwner() {
1505         _checkOwner();
1506         _;
1507     }
1508 
1509     /**
1510      * @dev Returns the address of the current owner.
1511      */
1512     function owner() public view virtual returns (address) {
1513         return _owner;
1514     }
1515 
1516     /**
1517      * @dev Throws if the sender is not the owner.
1518      */
1519     function _checkOwner() internal view virtual {
1520         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1521     }
1522 
1523     /**
1524      * @dev Leaves the contract without owner. It will not be possible to call
1525      * `onlyOwner` functions anymore. Can only be called by the current owner.
1526      *
1527      * NOTE: Renouncing ownership will leave the contract without an owner,
1528      * thereby removing any functionality that is only available to the owner.
1529      */
1530     function renounceOwnership() public virtual onlyOwner {
1531         _transferOwnership(address(0));
1532     }
1533 
1534     /**
1535      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1536      * Can only be called by the current owner.
1537      */
1538     function transferOwnership(address newOwner) public virtual onlyOwner {
1539         require(newOwner != address(0), "Ownable: new owner is the zero address");
1540         _transferOwnership(newOwner);
1541     }
1542 
1543     /**
1544      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1545      * Internal function without access restriction.
1546      */
1547     function _transferOwnership(address newOwner) internal virtual {
1548         address oldOwner = _owner;
1549         _owner = newOwner;
1550         emit OwnershipTransferred(oldOwner, newOwner);
1551     }
1552 }
1553 
1554 // File: SquidzNFT.sol
1555 
1556 
1557 
1558 pragma solidity ^0.8.9;
1559 
1560 
1561 
1562 contract SquidzophrenicsNFT is ERC721, Ownable {
1563     using Strings for uint256;
1564 
1565     uint public constant MAX_TOKENS = 1111;
1566     uint private constant TOKENS_RESERVED = 20;
1567     uint public price = 0;
1568 
1569     uint public royaltyPercentage = 5;
1570 
1571     uint256 public constant MAX_MINT_PER_TX = 3;
1572 
1573     bool public isSaleActive;
1574     uint256 public totalSupply;
1575     mapping(address => uint256) private mintedPerWallet;
1576 
1577     string public baseUri;
1578     string public baseExtension = ".json";
1579 
1580     constructor() ERC721("Squidzophrenics", "SQUID") {
1581         baseUri = "ipfs://bafybeibb7nblz5ae2ggf2bulz5fww7c2f2j4trf4vqchmzxmdjsxyy6azy/";
1582         for(uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
1583             _safeMint(msg.sender, i);
1584         }
1585 
1586         isSaleActive = false;
1587         totalSupply = TOKENS_RESERVED;
1588     }
1589 
1590     // Public Functions
1591     function mint(uint256 _numTokens) external payable {
1592         require(isSaleActive, "The sale is paused.");
1593         require(_numTokens <= MAX_MINT_PER_TX, "You cannot mint that many in one transaction.");
1594         require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "You cannot mint that many total.");
1595         uint256 curTotalSupply = totalSupply;
1596         require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds total supply.");
1597         require(_numTokens * price <= msg.value, "Insufficient funds.");
1598 
1599         for(uint256 i = 1; i <= _numTokens; ++i) {
1600             _safeMint(msg.sender, curTotalSupply + i);
1601         }
1602         mintedPerWallet[msg.sender] += _numTokens;
1603         totalSupply += _numTokens;
1604     }
1605 
1606     // Owner-only functions
1607     function flipSaleState() external onlyOwner {
1608         isSaleActive = !isSaleActive;
1609     }
1610 
1611     function setBaseUri(string memory _baseUri) external onlyOwner {
1612         baseUri = _baseUri;
1613     }
1614 
1615     function setPrice(uint256 _price) external onlyOwner {
1616         price = _price;
1617     }
1618 
1619     function withdraw() public payable onlyOwner {
1620         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
1621         require(os);
1622     }
1623 
1624     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1625         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1626  
1627         string memory currentBaseURI = _baseURI();
1628         return bytes(currentBaseURI).length > 0
1629             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1630             : "";
1631     }
1632 
1633     function setRoyaltyPercentage(uint _percentage) public onlyOwner {
1634         royaltyPercentage = _percentage;
1635     }
1636 
1637     function transferFrom(address _from, address _to, uint _tokenId) public override {
1638         uint salePrice = price;
1639         uint royaltyAmount = (salePrice * royaltyPercentage) / 100;
1640         payable(owner()).transfer(royaltyAmount);
1641         // transfer the NFT to the new owner
1642         require(ownerOf(_tokenId) == _from, "You do not own this NFT");
1643         _transfer(_from, _to, _tokenId);
1644     }
1645  
1646     function _baseURI() internal view virtual override returns (string memory) {
1647         return baseUri;
1648     }
1649 }