1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
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
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev String operations.
359  */
360 library Strings {
361     bytes16 private constant _SYMBOLS = "0123456789abcdef";
362     uint8 private constant _ADDRESS_LENGTH = 20;
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
366      */
367     function toString(uint256 value) internal pure returns (string memory) {
368         unchecked {
369             uint256 length = Math.log10(value) + 1;
370             string memory buffer = new string(length);
371             uint256 ptr;
372             /// @solidity memory-safe-assembly
373             assembly {
374                 ptr := add(buffer, add(32, length))
375             }
376             while (true) {
377                 ptr--;
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
381                 }
382                 value /= 10;
383                 if (value == 0) break;
384             }
385             return buffer;
386         }
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
391      */
392     function toHexString(uint256 value) internal pure returns (string memory) {
393         unchecked {
394             return toHexString(value, Math.log256(value) + 1);
395         }
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
415      */
416     function toHexString(address addr) internal pure returns (string memory) {
417         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Address.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
425 
426 pragma solidity ^0.8.1;
427 
428 /**
429  * @dev Collection of functions related to the address type
430  */
431 library Address {
432     /**
433      * @dev Returns true if `account` is a contract.
434      *
435      * [IMPORTANT]
436      * ====
437      * It is unsafe to assume that an address for which this function returns
438      * false is an externally-owned account (EOA) and not a contract.
439      *
440      * Among others, `isContract` will return false for the following
441      * types of addresses:
442      *
443      *  - an externally-owned account
444      *  - a contract in construction
445      *  - an address where a contract will be created
446      *  - an address where a contract lived, but was destroyed
447      * ====
448      *
449      * [IMPORTANT]
450      * ====
451      * You shouldn't rely on `isContract` to protect against flash loan attacks!
452      *
453      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
454      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
455      * constructor.
456      * ====
457      */
458     function isContract(address account) internal view returns (bool) {
459         // This method relies on extcodesize/address.code.length, which returns 0
460         // for contracts in construction, since the code is only stored at the end
461         // of the constructor execution.
462 
463         return account.code.length > 0;
464     }
465 
466     /**
467      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
468      * `recipient`, forwarding all available gas and reverting on errors.
469      *
470      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
471      * of certain opcodes, possibly making contracts go over the 2300 gas limit
472      * imposed by `transfer`, making them unable to receive funds via
473      * `transfer`. {sendValue} removes this limitation.
474      *
475      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
476      *
477      * IMPORTANT: because control is transferred to `recipient`, care must be
478      * taken to not create reentrancy vulnerabilities. Consider using
479      * {ReentrancyGuard} or the
480      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
481      */
482     function sendValue(address payable recipient, uint256 amount) internal {
483         require(address(this).balance >= amount, "Address: insufficient balance");
484 
485         (bool success, ) = recipient.call{value: amount}("");
486         require(success, "Address: unable to send value, recipient may have reverted");
487     }
488 
489     /**
490      * @dev Performs a Solidity function call using a low level `call`. A
491      * plain `call` is an unsafe replacement for a function call: use this
492      * function instead.
493      *
494      * If `target` reverts with a revert reason, it is bubbled up by this
495      * function (like regular Solidity function calls).
496      *
497      * Returns the raw returned data. To convert to the expected return value,
498      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
499      *
500      * Requirements:
501      *
502      * - `target` must be a contract.
503      * - calling `target` with `data` must not revert.
504      *
505      * _Available since v3.1._
506      */
507     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
508         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
509     }
510 
511     /**
512      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
513      * `errorMessage` as a fallback revert reason when `target` reverts.
514      *
515      * _Available since v3.1._
516      */
517     function functionCall(
518         address target,
519         bytes memory data,
520         string memory errorMessage
521     ) internal returns (bytes memory) {
522         return functionCallWithValue(target, data, 0, errorMessage);
523     }
524 
525     /**
526      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
527      * but also transferring `value` wei to `target`.
528      *
529      * Requirements:
530      *
531      * - the calling contract must have an ETH balance of at least `value`.
532      * - the called Solidity function must be `payable`.
533      *
534      * _Available since v3.1._
535      */
536     function functionCallWithValue(
537         address target,
538         bytes memory data,
539         uint256 value
540     ) internal returns (bytes memory) {
541         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
542     }
543 
544     /**
545      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
546      * with `errorMessage` as a fallback revert reason when `target` reverts.
547      *
548      * _Available since v3.1._
549      */
550     function functionCallWithValue(
551         address target,
552         bytes memory data,
553         uint256 value,
554         string memory errorMessage
555     ) internal returns (bytes memory) {
556         require(address(this).balance >= value, "Address: insufficient balance for call");
557         (bool success, bytes memory returndata) = target.call{value: value}(data);
558         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
559     }
560 
561     /**
562      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
563      * but performing a static call.
564      *
565      * _Available since v3.3._
566      */
567     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
568         return functionStaticCall(target, data, "Address: low-level static call failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
573      * but performing a static call.
574      *
575      * _Available since v3.3._
576      */
577     function functionStaticCall(
578         address target,
579         bytes memory data,
580         string memory errorMessage
581     ) internal view returns (bytes memory) {
582         (bool success, bytes memory returndata) = target.staticcall(data);
583         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
584     }
585 
586     /**
587      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
588      * but performing a delegate call.
589      *
590      * _Available since v3.4._
591      */
592     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
593         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
594     }
595 
596     /**
597      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
598      * but performing a delegate call.
599      *
600      * _Available since v3.4._
601      */
602     function functionDelegateCall(
603         address target,
604         bytes memory data,
605         string memory errorMessage
606     ) internal returns (bytes memory) {
607         (bool success, bytes memory returndata) = target.delegatecall(data);
608         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
609     }
610 
611     /**
612      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
613      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
614      *
615      * _Available since v4.8._
616      */
617     function verifyCallResultFromTarget(
618         address target,
619         bool success,
620         bytes memory returndata,
621         string memory errorMessage
622     ) internal view returns (bytes memory) {
623         if (success) {
624             if (returndata.length == 0) {
625                 // only check isContract if the call was successful and the return data is empty
626                 // otherwise we already know that it was a contract
627                 require(isContract(target), "Address: call to non-contract");
628             }
629             return returndata;
630         } else {
631             _revert(returndata, errorMessage);
632         }
633     }
634 
635     /**
636      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
637      * revert reason or using the provided one.
638      *
639      * _Available since v4.3._
640      */
641     function verifyCallResult(
642         bool success,
643         bytes memory returndata,
644         string memory errorMessage
645     ) internal pure returns (bytes memory) {
646         if (success) {
647             return returndata;
648         } else {
649             _revert(returndata, errorMessage);
650         }
651     }
652 
653     function _revert(bytes memory returndata, string memory errorMessage) private pure {
654         // Look for revert reason and bubble it up if present
655         if (returndata.length > 0) {
656             // The easiest way to bubble the revert reason is using memory via assembly
657             /// @solidity memory-safe-assembly
658             assembly {
659                 let returndata_size := mload(returndata)
660                 revert(add(32, returndata), returndata_size)
661             }
662         } else {
663             revert(errorMessage);
664         }
665     }
666 }
667 
668 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
669 
670 
671 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @title ERC721 token receiver interface
677  * @dev Interface for any contract that wants to support safeTransfers
678  * from ERC721 asset contracts.
679  */
680 interface IERC721Receiver {
681     /**
682      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
683      * by `operator` from `from`, this function is called.
684      *
685      * It must return its Solidity selector to confirm the token transfer.
686      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
687      *
688      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
689      */
690     function onERC721Received(
691         address operator,
692         address from,
693         uint256 tokenId,
694         bytes calldata data
695     ) external returns (bytes4);
696 }
697 
698 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
699 
700 
701 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
702 
703 pragma solidity ^0.8.0;
704 
705 /**
706  * @dev Interface of the ERC165 standard, as defined in the
707  * https://eips.ethereum.org/EIPS/eip-165[EIP].
708  *
709  * Implementers can declare support of contract interfaces, which can then be
710  * queried by others ({ERC165Checker}).
711  *
712  * For an implementation, see {ERC165}.
713  */
714 interface IERC165 {
715     /**
716      * @dev Returns true if this contract implements the interface defined by
717      * `interfaceId`. See the corresponding
718      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
719      * to learn more about how these ids are created.
720      *
721      * This function call must use less than 30 000 gas.
722      */
723     function supportsInterface(bytes4 interfaceId) external view returns (bool);
724 }
725 
726 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
727 
728 
729 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
730 
731 pragma solidity ^0.8.0;
732 
733 
734 /**
735  * @dev Implementation of the {IERC165} interface.
736  *
737  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
738  * for the additional interface id that will be supported. For example:
739  *
740  * ```solidity
741  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
742  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
743  * }
744  * ```
745  *
746  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
747  */
748 abstract contract ERC165 is IERC165 {
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753         return interfaceId == type(IERC165).interfaceId;
754     }
755 }
756 
757 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
758 
759 
760 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
761 
762 pragma solidity ^0.8.0;
763 
764 
765 /**
766  * @dev Required interface of an ERC721 compliant contract.
767  */
768 interface IERC721 is IERC165 {
769     /**
770      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
771      */
772     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
773 
774     /**
775      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
776      */
777     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
778 
779     /**
780      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
781      */
782     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
783 
784     /**
785      * @dev Returns the number of tokens in ``owner``'s account.
786      */
787     function balanceOf(address owner) external view returns (uint256 balance);
788 
789     /**
790      * @dev Returns the owner of the `tokenId` token.
791      *
792      * Requirements:
793      *
794      * - `tokenId` must exist.
795      */
796     function ownerOf(uint256 tokenId) external view returns (address owner);
797 
798     /**
799      * @dev Safely transfers `tokenId` token from `from` to `to`.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must exist and be owned by `from`.
806      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
807      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
808      *
809      * Emits a {Transfer} event.
810      */
811     function safeTransferFrom(
812         address from,
813         address to,
814         uint256 tokenId,
815         bytes calldata data
816     ) external;
817 
818     /**
819      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
820      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
821      *
822      * Requirements:
823      *
824      * - `from` cannot be the zero address.
825      * - `to` cannot be the zero address.
826      * - `tokenId` token must exist and be owned by `from`.
827      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
828      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
829      *
830      * Emits a {Transfer} event.
831      */
832     function safeTransferFrom(
833         address from,
834         address to,
835         uint256 tokenId
836     ) external;
837 
838     /**
839      * @dev Transfers `tokenId` token from `from` to `to`.
840      *
841      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
842      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
843      * understand this adds an external call which potentially creates a reentrancy vulnerability.
844      *
845      * Requirements:
846      *
847      * - `from` cannot be the zero address.
848      * - `to` cannot be the zero address.
849      * - `tokenId` token must be owned by `from`.
850      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
851      *
852      * Emits a {Transfer} event.
853      */
854     function transferFrom(
855         address from,
856         address to,
857         uint256 tokenId
858     ) external;
859 
860     /**
861      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
862      * The approval is cleared when the token is transferred.
863      *
864      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
865      *
866      * Requirements:
867      *
868      * - The caller must own the token or be an approved operator.
869      * - `tokenId` must exist.
870      *
871      * Emits an {Approval} event.
872      */
873     function approve(address to, uint256 tokenId) external;
874 
875     /**
876      * @dev Approve or remove `operator` as an operator for the caller.
877      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
878      *
879      * Requirements:
880      *
881      * - The `operator` cannot be the caller.
882      *
883      * Emits an {ApprovalForAll} event.
884      */
885     function setApprovalForAll(address operator, bool _approved) external;
886 
887     /**
888      * @dev Returns the account approved for `tokenId` token.
889      *
890      * Requirements:
891      *
892      * - `tokenId` must exist.
893      */
894     function getApproved(uint256 tokenId) external view returns (address operator);
895 
896     /**
897      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
898      *
899      * See {setApprovalForAll}
900      */
901     function isApprovedForAll(address owner, address operator) external view returns (bool);
902 }
903 
904 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
905 
906 
907 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
914  * @dev See https://eips.ethereum.org/EIPS/eip-721
915  */
916 interface IERC721Metadata is IERC721 {
917     /**
918      * @dev Returns the token collection name.
919      */
920     function name() external view returns (string memory);
921 
922     /**
923      * @dev Returns the token collection symbol.
924      */
925     function symbol() external view returns (string memory);
926 
927     /**
928      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
929      */
930     function tokenURI(uint256 tokenId) external view returns (string memory);
931 }
932 
933 // File: @openzeppelin/contracts/utils/Context.sol
934 
935 
936 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
937 
938 pragma solidity ^0.8.0;
939 
940 /**
941  * @dev Provides information about the current execution context, including the
942  * sender of the transaction and its data. While these are generally available
943  * via msg.sender and msg.data, they should not be accessed in such a direct
944  * manner, since when dealing with meta-transactions the account sending and
945  * paying for execution may not be the actual sender (as far as an application
946  * is concerned).
947  *
948  * This contract is only required for intermediate, library-like contracts.
949  */
950 abstract contract Context {
951     function _msgSender() internal view virtual returns (address) {
952         return msg.sender;
953     }
954 
955     function _msgData() internal view virtual returns (bytes calldata) {
956         return msg.data;
957     }
958 }
959 
960 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
961 
962 
963 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 
968 
969 
970 
971 
972 
973 
974 /**
975  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
976  * the Metadata extension, but not including the Enumerable extension, which is available separately as
977  * {ERC721Enumerable}.
978  */
979 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
980     using Address for address;
981     using Strings for uint256;
982 
983     // Token name
984     string private _name;
985 
986     // Token symbol
987     string private _symbol;
988 
989     // Mapping from token ID to owner address
990     mapping(uint256 => address) private _owners;
991 
992     // Mapping owner address to token count
993     mapping(address => uint256) private _balances;
994 
995     // Mapping from token ID to approved address
996     mapping(uint256 => address) private _tokenApprovals;
997 
998     // Mapping from owner to operator approvals
999     mapping(address => mapping(address => bool)) private _operatorApprovals;
1000 
1001     /**
1002      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1003      */
1004     constructor(string memory name_, string memory symbol_) {
1005         _name = name_;
1006         _symbol = symbol_;
1007     }
1008 
1009     /**
1010      * @dev See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1013         return
1014             interfaceId == type(IERC721).interfaceId ||
1015             interfaceId == type(IERC721Metadata).interfaceId ||
1016             super.supportsInterface(interfaceId);
1017     }
1018 
1019     /**
1020      * @dev See {IERC721-balanceOf}.
1021      */
1022     function balanceOf(address owner) public view virtual override returns (uint256) {
1023         require(owner != address(0), "ERC721: address zero is not a valid owner");
1024         return _balances[owner];
1025     }
1026 
1027     /**
1028      * @dev See {IERC721-ownerOf}.
1029      */
1030     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1031         address owner = _ownerOf(tokenId);
1032         require(owner != address(0), "ERC721: invalid token ID");
1033         return owner;
1034     }
1035 
1036     /**
1037      * @dev See {IERC721Metadata-name}.
1038      */
1039     function name() public view virtual override returns (string memory) {
1040         return _name;
1041     }
1042 
1043     /**
1044      * @dev See {IERC721Metadata-symbol}.
1045      */
1046     function symbol() public view virtual override returns (string memory) {
1047         return _symbol;
1048     }
1049 
1050     /**
1051      * @dev See {IERC721Metadata-tokenURI}.
1052      */
1053     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1054         _requireMinted(tokenId);
1055 
1056         string memory baseURI = _baseURI();
1057         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1058     }
1059 
1060     /**
1061      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1062      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1063      * by default, can be overridden in child contracts.
1064      */
1065     function _baseURI() internal view virtual returns (string memory) {
1066         return "";
1067     }
1068 
1069     /**
1070      * @dev See {IERC721-approve}.
1071      */
1072     function approve(address to, uint256 tokenId) public virtual override {
1073         address owner = ERC721.ownerOf(tokenId);
1074         require(to != owner, "ERC721: approval to current owner");
1075 
1076         require(
1077             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1078             "ERC721: approve caller is not token owner or approved for all"
1079         );
1080 
1081         _approve(to, tokenId);
1082     }
1083 
1084     /**
1085      * @dev See {IERC721-getApproved}.
1086      */
1087     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1088         _requireMinted(tokenId);
1089 
1090         return _tokenApprovals[tokenId];
1091     }
1092 
1093     /**
1094      * @dev See {IERC721-setApprovalForAll}.
1095      */
1096     function setApprovalForAll(address operator, bool approved) public virtual override {
1097         _setApprovalForAll(_msgSender(), operator, approved);
1098     }
1099 
1100     /**
1101      * @dev See {IERC721-isApprovedForAll}.
1102      */
1103     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1104         return _operatorApprovals[owner][operator];
1105     }
1106 
1107     /**
1108      * @dev See {IERC721-transferFrom}.
1109      */
1110     function transferFrom(
1111         address from,
1112         address to,
1113         uint256 tokenId
1114     ) public virtual override {
1115         //solhint-disable-next-line max-line-length
1116         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1117 
1118         _transfer(from, to, tokenId);
1119     }
1120 
1121     /**
1122      * @dev See {IERC721-safeTransferFrom}.
1123      */
1124     function safeTransferFrom(
1125         address from,
1126         address to,
1127         uint256 tokenId
1128     ) public virtual override {
1129         safeTransferFrom(from, to, tokenId, "");
1130     }
1131 
1132     /**
1133      * @dev See {IERC721-safeTransferFrom}.
1134      */
1135     function safeTransferFrom(
1136         address from,
1137         address to,
1138         uint256 tokenId,
1139         bytes memory data
1140     ) public virtual override {
1141         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1142         _safeTransfer(from, to, tokenId, data);
1143     }
1144 
1145     /**
1146      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1147      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1148      *
1149      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1150      *
1151      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1152      * implement alternative mechanisms to perform token transfer, such as signature-based.
1153      *
1154      * Requirements:
1155      *
1156      * - `from` cannot be the zero address.
1157      * - `to` cannot be the zero address.
1158      * - `tokenId` token must exist and be owned by `from`.
1159      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1160      *
1161      * Emits a {Transfer} event.
1162      */
1163     function _safeTransfer(
1164         address from,
1165         address to,
1166         uint256 tokenId,
1167         bytes memory data
1168     ) internal virtual {
1169         _transfer(from, to, tokenId);
1170         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1171     }
1172 
1173     /**
1174      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1175      */
1176     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1177         return _owners[tokenId];
1178     }
1179 
1180     /**
1181      * @dev Returns whether `tokenId` exists.
1182      *
1183      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1184      *
1185      * Tokens start existing when they are minted (`_mint`),
1186      * and stop existing when they are burned (`_burn`).
1187      */
1188     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1189         return _ownerOf(tokenId) != address(0);
1190     }
1191 
1192     /**
1193      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      */
1199     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1200         address owner = ERC721.ownerOf(tokenId);
1201         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1202     }
1203 
1204     /**
1205      * @dev Safely mints `tokenId` and transfers it to `to`.
1206      *
1207      * Requirements:
1208      *
1209      * - `tokenId` must not exist.
1210      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1211      *
1212      * Emits a {Transfer} event.
1213      */
1214     function _safeMint(address to, uint256 tokenId) internal virtual {
1215         _safeMint(to, tokenId, "");
1216     }
1217 
1218     /**
1219      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1220      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1221      */
1222     function _safeMint(
1223         address to,
1224         uint256 tokenId,
1225         bytes memory data
1226     ) internal virtual {
1227         _mint(to, tokenId);
1228         require(
1229             _checkOnERC721Received(address(0), to, tokenId, data),
1230             "ERC721: transfer to non ERC721Receiver implementer"
1231         );
1232     }
1233 
1234     /**
1235      * @dev Mints `tokenId` and transfers it to `to`.
1236      *
1237      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1238      *
1239      * Requirements:
1240      *
1241      * - `tokenId` must not exist.
1242      * - `to` cannot be the zero address.
1243      *
1244      * Emits a {Transfer} event.
1245      */
1246     function _mint(address to, uint256 tokenId) internal virtual {
1247         require(to != address(0), "ERC721: mint to the zero address");
1248         require(!_exists(tokenId), "ERC721: token already minted");
1249 
1250         _beforeTokenTransfer(address(0), to, tokenId, 1);
1251 
1252         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1253         require(!_exists(tokenId), "ERC721: token already minted");
1254 
1255         unchecked {
1256             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1257             // Given that tokens are minted one by one, it is impossible in practice that
1258             // this ever happens. Might change if we allow batch minting.
1259             // The ERC fails to describe this case.
1260             _balances[to] += 1;
1261         }
1262 
1263         _owners[tokenId] = to;
1264 
1265         emit Transfer(address(0), to, tokenId);
1266 
1267         _afterTokenTransfer(address(0), to, tokenId, 1);
1268     }
1269 
1270     /**
1271      * @dev Destroys `tokenId`.
1272      * The approval is cleared when the token is burned.
1273      * This is an internal function that does not check if the sender is authorized to operate on the token.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      *
1279      * Emits a {Transfer} event.
1280      */
1281     function _burn(uint256 tokenId) internal virtual {
1282         address owner = ERC721.ownerOf(tokenId);
1283 
1284         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1285 
1286         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1287         owner = ERC721.ownerOf(tokenId);
1288 
1289         // Clear approvals
1290         delete _tokenApprovals[tokenId];
1291 
1292         unchecked {
1293             // Cannot overflow, as that would require more tokens to be burned/transferred
1294             // out than the owner initially received through minting and transferring in.
1295             _balances[owner] -= 1;
1296         }
1297         delete _owners[tokenId];
1298 
1299         emit Transfer(owner, address(0), tokenId);
1300 
1301         _afterTokenTransfer(owner, address(0), tokenId, 1);
1302     }
1303 
1304     /**
1305      * @dev Transfers `tokenId` from `from` to `to`.
1306      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1307      *
1308      * Requirements:
1309      *
1310      * - `to` cannot be the zero address.
1311      * - `tokenId` token must be owned by `from`.
1312      *
1313      * Emits a {Transfer} event.
1314      */
1315     function _transfer(
1316         address from,
1317         address to,
1318         uint256 tokenId
1319     ) internal virtual {
1320         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1321         require(to != address(0), "ERC721: transfer to the zero address");
1322 
1323         _beforeTokenTransfer(from, to, tokenId, 1);
1324 
1325         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1326         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1327 
1328         // Clear approvals from the previous owner
1329         delete _tokenApprovals[tokenId];
1330 
1331         unchecked {
1332             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1333             // `from`'s balance is the number of token held, which is at least one before the current
1334             // transfer.
1335             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1336             // all 2**256 token ids to be minted, which in practice is impossible.
1337             _balances[from] -= 1;
1338             _balances[to] += 1;
1339         }
1340         _owners[tokenId] = to;
1341 
1342         emit Transfer(from, to, tokenId);
1343 
1344         _afterTokenTransfer(from, to, tokenId, 1);
1345     }
1346 
1347     /**
1348      * @dev Approve `to` to operate on `tokenId`
1349      *
1350      * Emits an {Approval} event.
1351      */
1352     function _approve(address to, uint256 tokenId) internal virtual {
1353         _tokenApprovals[tokenId] = to;
1354         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1355     }
1356 
1357     /**
1358      * @dev Approve `operator` to operate on all of `owner` tokens
1359      *
1360      * Emits an {ApprovalForAll} event.
1361      */
1362     function _setApprovalForAll(
1363         address owner,
1364         address operator,
1365         bool approved
1366     ) internal virtual {
1367         require(owner != operator, "ERC721: approve to caller");
1368         _operatorApprovals[owner][operator] = approved;
1369         emit ApprovalForAll(owner, operator, approved);
1370     }
1371 
1372     /**
1373      * @dev Reverts if the `tokenId` has not been minted yet.
1374      */
1375     function _requireMinted(uint256 tokenId) internal view virtual {
1376         require(_exists(tokenId), "ERC721: invalid token ID");
1377     }
1378 
1379     /**
1380      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1381      * The call is not executed if the target address is not a contract.
1382      *
1383      * @param from address representing the previous owner of the given token ID
1384      * @param to target address that will receive the tokens
1385      * @param tokenId uint256 ID of the token to be transferred
1386      * @param data bytes optional data to send along with the call
1387      * @return bool whether the call correctly returned the expected magic value
1388      */
1389     function _checkOnERC721Received(
1390         address from,
1391         address to,
1392         uint256 tokenId,
1393         bytes memory data
1394     ) private returns (bool) {
1395         if (to.isContract()) {
1396             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1397                 return retval == IERC721Receiver.onERC721Received.selector;
1398             } catch (bytes memory reason) {
1399                 if (reason.length == 0) {
1400                     revert("ERC721: transfer to non ERC721Receiver implementer");
1401                 } else {
1402                     /// @solidity memory-safe-assembly
1403                     assembly {
1404                         revert(add(32, reason), mload(reason))
1405                     }
1406                 }
1407             }
1408         } else {
1409             return true;
1410         }
1411     }
1412 
1413     /**
1414      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1415      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1416      *
1417      * Calling conditions:
1418      *
1419      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1420      * - When `from` is zero, the tokens will be minted for `to`.
1421      * - When `to` is zero, ``from``'s tokens will be burned.
1422      * - `from` and `to` are never both zero.
1423      * - `batchSize` is non-zero.
1424      *
1425      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1426      */
1427     function _beforeTokenTransfer(
1428         address from,
1429         address to,
1430         uint256, /* firstTokenId */
1431         uint256 batchSize
1432     ) internal virtual {
1433         if (batchSize > 1) {
1434             if (from != address(0)) {
1435                 _balances[from] -= batchSize;
1436             }
1437             if (to != address(0)) {
1438                 _balances[to] += batchSize;
1439             }
1440         }
1441     }
1442 
1443     /**
1444      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1445      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1446      *
1447      * Calling conditions:
1448      *
1449      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1450      * - When `from` is zero, the tokens were minted for `to`.
1451      * - When `to` is zero, ``from``'s tokens were burned.
1452      * - `from` and `to` are never both zero.
1453      * - `batchSize` is non-zero.
1454      *
1455      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1456      */
1457     function _afterTokenTransfer(
1458         address from,
1459         address to,
1460         uint256 firstTokenId,
1461         uint256 batchSize
1462     ) internal virtual {}
1463 }
1464 
1465 // File: @openzeppelin/contracts/access/Ownable.sol
1466 
1467 
1468 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1469 
1470 pragma solidity ^0.8.0;
1471 
1472 
1473 /**
1474  * @dev Contract module which provides a basic access control mechanism, where
1475  * there is an account (an owner) that can be granted exclusive access to
1476  * specific functions.
1477  *
1478  * By default, the owner account will be the one that deploys the contract. This
1479  * can later be changed with {transferOwnership}.
1480  *
1481  * This module is used through inheritance. It will make available the modifier
1482  * `onlyOwner`, which can be applied to your functions to restrict their use to
1483  * the owner.
1484  */
1485 abstract contract Ownable is Context {
1486     address private _owner;
1487 
1488     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1489 
1490     /**
1491      * @dev Initializes the contract setting the deployer as the initial owner.
1492      */
1493     constructor() {
1494         _transferOwnership(_msgSender());
1495     }
1496 
1497     /**
1498      * @dev Throws if called by any account other than the owner.
1499      */
1500     modifier onlyOwner() {
1501         _checkOwner();
1502         _;
1503     }
1504 
1505     /**
1506      * @dev Returns the address of the current owner.
1507      */
1508     function owner() public view virtual returns (address) {
1509         return _owner;
1510     }
1511 
1512     /**
1513      * @dev Throws if the sender is not the owner.
1514      */
1515     function _checkOwner() internal view virtual {
1516         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1517     }
1518 
1519     /**
1520      * @dev Leaves the contract without owner. It will not be possible to call
1521      * `onlyOwner` functions anymore. Can only be called by the current owner.
1522      *
1523      * NOTE: Renouncing ownership will leave the contract without an owner,
1524      * thereby removing any functionality that is only available to the owner.
1525      */
1526     function renounceOwnership() public virtual onlyOwner {
1527         _transferOwnership(address(0));
1528     }
1529 
1530     /**
1531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1532      * Can only be called by the current owner.
1533      */
1534     function transferOwnership(address newOwner) public virtual onlyOwner {
1535         require(newOwner != address(0), "Ownable: new owner is the zero address");
1536         _transferOwnership(newOwner);
1537     }
1538 
1539     /**
1540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1541      * Internal function without access restriction.
1542      */
1543     function _transferOwnership(address newOwner) internal virtual {
1544         address oldOwner = _owner;
1545         _owner = newOwner;
1546         emit OwnershipTransferred(oldOwner, newOwner);
1547     }
1548 }
1549 
1550 // File: contracts/satiama222.sol
1551 
1552 
1553 
1554 pragma solidity ^0.8.9;
1555 
1556 
1557 
1558 
1559 contract NFT is ERC721, Ownable {
1560     using Strings for uint256;
1561 
1562     uint public constant MAX_TOKENS = 333;
1563     uint private constant TOKENS_RESERVED = 1;
1564     uint public price = 1000000000000000;
1565     uint256 public constant MAX_MINT_PER_TX = 10;   
1566 
1567     bool public isSaleActive;
1568     uint256 public totalSupply;
1569     mapping(address => uint256) private mintedPerWallet;
1570 
1571     string public baseUri;
1572     string public baseExtension = ".json";
1573 
1574     constructor() ERC721("Neon Downtown #1", "STCT001") {
1575         baseUri = "ipfs://bafybeibw4geqbd4kqb23gpltz5qdmr3cj7zhg6xvkmdscsl4w6lwqixsfq/";
1576         for(uint256 i = 1; i <= TOKENS_RESERVED; ++i) {
1577             _safeMint(msg.sender, i);
1578         }
1579         totalSupply = TOKENS_RESERVED;
1580     }
1581 
1582     // Public Functions
1583     function mint(uint256 _numTokens) external payable {
1584         require(isSaleActive, "The sale is paused.");
1585         require(_numTokens <= MAX_MINT_PER_TX, "You cannot mint that many in one transaction.");
1586         require(mintedPerWallet[msg.sender] + _numTokens <= MAX_MINT_PER_TX, "You cannot mint that many total.");
1587         uint256 curTotalSupply = totalSupply;
1588         require(curTotalSupply + _numTokens <= MAX_TOKENS, "Exceeds total supply.");
1589         require(_numTokens * price <= msg.value, "Insufficient funds.");
1590 
1591         for(uint256 i = 1; i <= _numTokens; ++i) {
1592             _safeMint(msg.sender, curTotalSupply + i);
1593         }
1594         mintedPerWallet[msg.sender] += _numTokens;
1595         totalSupply += _numTokens;
1596     }
1597 
1598     // Owner-only functions
1599     function flipSaleState() external onlyOwner {
1600         isSaleActive = !isSaleActive;
1601     }
1602 
1603     function setBaseUri(string memory _baseUri) external onlyOwner {
1604         baseUri = _baseUri;
1605     }
1606 
1607     function setPrice(uint256 _price) external onlyOwner {
1608         price = _price;
1609     }
1610 
1611     function withdrawAll() external payable onlyOwner {
1612         uint256 balance = address(this).balance;
1613         uint256 balanceOne = balance * 100 / 100;
1614         ( bool transferOne, ) = payable(0x7534C9eF0C8AA2c5A42548Ca5A18FEE6A089e36e).call{value: balanceOne}("");
1615         require(transferOne , "Transfer failed.");
1616     }
1617 
1618     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1619         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1620  
1621         string memory currentBaseURI = _baseURI();
1622         return bytes(currentBaseURI).length > 0
1623             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1624             : "";
1625     }
1626  
1627     function _baseURI() internal view virtual override returns (string memory) {
1628         return baseUri;
1629     }
1630 }