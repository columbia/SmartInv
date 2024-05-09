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
904 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
905 
906 
907 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
908 
909 pragma solidity ^0.8.0;
910 
911 
912 /**
913  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
914  * @dev See https://eips.ethereum.org/EIPS/eip-721
915  */
916 interface IERC721Enumerable is IERC721 {
917     /**
918      * @dev Returns the total amount of tokens stored by the contract.
919      */
920     function totalSupply() external view returns (uint256);
921 
922     /**
923      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
924      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
925      */
926     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
927 
928     /**
929      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
930      * Use along with {totalSupply} to enumerate all tokens.
931      */
932     function tokenByIndex(uint256 index) external view returns (uint256);
933 }
934 
935 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
936 
937 
938 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
939 
940 pragma solidity ^0.8.0;
941 
942 
943 /**
944  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
945  * @dev See https://eips.ethereum.org/EIPS/eip-721
946  */
947 interface IERC721Metadata is IERC721 {
948     /**
949      * @dev Returns the token collection name.
950      */
951     function name() external view returns (string memory);
952 
953     /**
954      * @dev Returns the token collection symbol.
955      */
956     function symbol() external view returns (string memory);
957 
958     /**
959      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
960      */
961     function tokenURI(uint256 tokenId) external view returns (string memory);
962 }
963 
964 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
965 
966 
967 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
968 
969 pragma solidity ^0.8.0;
970 
971 /**
972  * @dev Contract module that helps prevent reentrant calls to a function.
973  *
974  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
975  * available, which can be applied to functions to make sure there are no nested
976  * (reentrant) calls to them.
977  *
978  * Note that because there is a single `nonReentrant` guard, functions marked as
979  * `nonReentrant` may not call one another. This can be worked around by making
980  * those functions `private`, and then adding `external` `nonReentrant` entry
981  * points to them.
982  *
983  * TIP: If you would like to learn more about reentrancy and alternative ways
984  * to protect against it, check out our blog post
985  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
986  */
987 abstract contract ReentrancyGuard {
988     // Booleans are more expensive than uint256 or any type that takes up a full
989     // word because each write operation emits an extra SLOAD to first read the
990     // slot's contents, replace the bits taken up by the boolean, and then write
991     // back. This is the compiler's defense against contract upgrades and
992     // pointer aliasing, and it cannot be disabled.
993 
994     // The values being non-zero value makes deployment a bit more expensive,
995     // but in exchange the refund on every call to nonReentrant will be lower in
996     // amount. Since refunds are capped to a percentage of the total
997     // transaction's gas, it is best to keep them low in cases like this one, to
998     // increase the likelihood of the full refund coming into effect.
999     uint256 private constant _NOT_ENTERED = 1;
1000     uint256 private constant _ENTERED = 2;
1001 
1002     uint256 private _status;
1003 
1004     constructor() {
1005         _status = _NOT_ENTERED;
1006     }
1007 
1008     /**
1009      * @dev Prevents a contract from calling itself, directly or indirectly.
1010      * Calling a `nonReentrant` function from another `nonReentrant`
1011      * function is not supported. It is possible to prevent this from happening
1012      * by making the `nonReentrant` function external, and making it call a
1013      * `private` function that does the actual work.
1014      */
1015     modifier nonReentrant() {
1016         _nonReentrantBefore();
1017         _;
1018         _nonReentrantAfter();
1019     }
1020 
1021     function _nonReentrantBefore() private {
1022         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1023         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1024 
1025         // Any calls to nonReentrant after this point will fail
1026         _status = _ENTERED;
1027     }
1028 
1029     function _nonReentrantAfter() private {
1030         // By storing the original value once again, a refund is triggered (see
1031         // https://eips.ethereum.org/EIPS/eip-2200)
1032         _status = _NOT_ENTERED;
1033     }
1034 }
1035 
1036 // File: @openzeppelin/contracts/utils/Context.sol
1037 
1038 
1039 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1040 
1041 pragma solidity ^0.8.0;
1042 
1043 /**
1044  * @dev Provides information about the current execution context, including the
1045  * sender of the transaction and its data. While these are generally available
1046  * via msg.sender and msg.data, they should not be accessed in such a direct
1047  * manner, since when dealing with meta-transactions the account sending and
1048  * paying for execution may not be the actual sender (as far as an application
1049  * is concerned).
1050  *
1051  * This contract is only required for intermediate, library-like contracts.
1052  */
1053 abstract contract Context {
1054     function _msgSender() internal view virtual returns (address) {
1055         return msg.sender;
1056     }
1057 
1058     function _msgData() internal view virtual returns (bytes calldata) {
1059         return msg.data;
1060     }
1061 }
1062 
1063 // File: ERC721A.sol
1064 
1065 
1066 
1067 pragma solidity ^0.8.0;
1068 
1069 
1070 
1071 
1072 
1073 
1074 
1075 
1076 
1077 /**
1078  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1079  * the Metadata and Enumerable extension. Built to optimize for lower gas during batch mints.
1080  *
1081  * Assumes serials are sequentially minted starting at 0 (e.g. 0, 1, 2, 3..).
1082  *
1083  * Assumes the number of issuable tokens (collection size) is capped and fits in a uint128.
1084  *
1085  * Does not support burning tokens to address(0).
1086  */
1087 contract ERC721A is
1088   Context,
1089   ERC165,
1090   IERC721,
1091   IERC721Metadata,
1092   IERC721Enumerable
1093 {
1094   using Address for address;
1095   using Strings for uint256;
1096 
1097   struct TokenOwnership {
1098     address addr;
1099     uint64 startTimestamp;
1100   }
1101 
1102   struct AddressData {
1103     uint128 balance;
1104     uint128 numberMinted;
1105   }
1106 
1107   uint256 private currentIndex = 0;
1108 
1109   uint256 internal immutable collectionSize;
1110   uint256 internal immutable maxBatchSize;
1111 
1112   // Token name
1113   string private _name;
1114 
1115   // Token symbol
1116   string private _symbol;
1117 
1118   // Mapping from token ID to ownership details
1119   // An empty struct value does not necessarily mean the token is unowned. See ownershipOf implementation for details.
1120   mapping(uint256 => TokenOwnership) private _ownerships;
1121 
1122   // Mapping owner address to address data
1123   mapping(address => AddressData) private _addressData;
1124 
1125   // Mapping from token ID to approved address
1126   mapping(uint256 => address) private _tokenApprovals;
1127 
1128   // Mapping from owner to operator approvals
1129   mapping(address => mapping(address => bool)) private _operatorApprovals;
1130 
1131   /**
1132    * @dev
1133    * `maxBatchSize` refers to how much a minter can mint at a time.
1134    * `collectionSize_` refers to how many tokens are in the collection.
1135    */
1136   constructor(
1137     string memory name_,
1138     string memory symbol_,
1139     uint256 maxBatchSize_,
1140     uint256 collectionSize_
1141   ) {
1142     require(
1143       collectionSize_ > 0,
1144       "ERC721A: collection must have a nonzero supply"
1145     );
1146     require(maxBatchSize_ > 0, "ERC721A: max batch size must be nonzero");
1147     _name = name_;
1148     _symbol = symbol_;
1149     maxBatchSize = maxBatchSize_;
1150     collectionSize = collectionSize_;
1151   }
1152 
1153   /**
1154    * @dev See {IERC721Enumerable-totalSupply}.
1155    */
1156   function totalSupply() public view override returns (uint256) {
1157     return currentIndex;
1158   }
1159 
1160   /**
1161    * @dev See {IERC721Enumerable-tokenByIndex}.
1162    */
1163   function tokenByIndex(uint256 index) public view override returns (uint256) {
1164     require(index < totalSupply(), "ERC721A: global index out of bounds");
1165     return index;
1166   }
1167 
1168   /**
1169    * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1170    * This read function is O(collectionSize). If calling from a separate contract, be sure to test gas first.
1171    * It may also degrade with extremely large collection sizes (e.g >> 10000), test for your use case.
1172    */
1173   function tokenOfOwnerByIndex(address owner, uint256 index)
1174     public
1175     view
1176     override
1177     returns (uint256)
1178   {
1179     require(index < balanceOf(owner), "ERC721A: owner index out of bounds");
1180     uint256 numMintedSoFar = totalSupply();
1181     uint256 tokenIdsIdx = 0;
1182     address currOwnershipAddr = address(0);
1183     for (uint256 i = 0; i < numMintedSoFar; i++) {
1184       TokenOwnership memory ownership = _ownerships[i];
1185       if (ownership.addr != address(0)) {
1186         currOwnershipAddr = ownership.addr;
1187       }
1188       if (currOwnershipAddr == owner) {
1189         if (tokenIdsIdx == index) {
1190           return i;
1191         }
1192         tokenIdsIdx++;
1193       }
1194     }
1195     revert("ERC721A: unable to get token of owner by index");
1196   }
1197 
1198   /**
1199    * @dev See {IERC165-supportsInterface}.
1200    */
1201   function supportsInterface(bytes4 interfaceId)
1202     public
1203     view
1204     virtual
1205     override(ERC165, IERC165)
1206     returns (bool)
1207   {
1208     return
1209       interfaceId == type(IERC721).interfaceId ||
1210       interfaceId == type(IERC721Metadata).interfaceId ||
1211       interfaceId == type(IERC721Enumerable).interfaceId ||
1212       super.supportsInterface(interfaceId);
1213   }
1214 
1215   /**
1216    * @dev See {IERC721-balanceOf}.
1217    */
1218   function balanceOf(address owner) public view override returns (uint256) {
1219     require(owner != address(0), "ERC721A: balance query for the zero address");
1220     return uint256(_addressData[owner].balance);
1221   }
1222 
1223   function _numberMinted(address owner) internal view returns (uint256) {
1224     require(
1225       owner != address(0),
1226       "ERC721A: number minted query for the zero address"
1227     );
1228     return uint256(_addressData[owner].numberMinted);
1229   }
1230 
1231   function ownershipOf(uint256 tokenId)
1232     internal
1233     view
1234     returns (TokenOwnership memory)
1235   {
1236     require(_exists(tokenId), "ERC721A: owner query for nonexistent token");
1237 
1238     uint256 lowestTokenToCheck;
1239     if (tokenId >= maxBatchSize) {
1240       lowestTokenToCheck = tokenId - maxBatchSize + 1;
1241     }
1242 
1243     for (uint256 curr = tokenId; curr >= lowestTokenToCheck; curr--) {
1244       TokenOwnership memory ownership = _ownerships[curr];
1245       if (ownership.addr != address(0)) {
1246         return ownership;
1247       }
1248     }
1249 
1250     revert("ERC721A: unable to determine the owner of token");
1251   }
1252 
1253   /**
1254    * @dev See {IERC721-ownerOf}.
1255    */
1256   function ownerOf(uint256 tokenId) public view override returns (address) {
1257     return ownershipOf(tokenId).addr;
1258   }
1259 
1260   /**
1261    * @dev See {IERC721Metadata-name}.
1262    */
1263   function name() public view virtual override returns (string memory) {
1264     return _name;
1265   }
1266 
1267   /**
1268    * @dev See {IERC721Metadata-symbol}.
1269    */
1270   function symbol() public view virtual override returns (string memory) {
1271     return _symbol;
1272   }
1273 
1274   /**
1275    * @dev See {IERC721Metadata-tokenURI}.
1276    */
1277   function tokenURI(uint256 tokenId)
1278     public
1279     view
1280     virtual
1281     override
1282     returns (string memory)
1283   {
1284     require(
1285       _exists(tokenId),
1286       "ERC721Metadata: URI query for nonexistent token"
1287     );
1288 
1289     string memory baseURI = _baseURI();
1290     return
1291       bytes(baseURI).length > 0
1292         ? string(abi.encodePacked(baseURI, tokenId.toString()))
1293         : "";
1294   }
1295 
1296   /**
1297    * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1298    * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1299    * by default, can be overriden in child contracts.
1300    */
1301   function _baseURI() internal view virtual returns (string memory) {
1302     return "";
1303   }
1304 
1305   /**
1306    * @dev See {IERC721-approve}.
1307    */
1308   function approve(address to, uint256 tokenId) public override {
1309     address owner = ERC721A.ownerOf(tokenId);
1310     require(to != owner, "ERC721A: approval to current owner");
1311 
1312     require(
1313       _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1314       "ERC721A: approve caller is not owner nor approved for all"
1315     );
1316 
1317     _approve(to, tokenId, owner);
1318   }
1319 
1320   /**
1321    * @dev See {IERC721-getApproved}.
1322    */
1323   function getApproved(uint256 tokenId) public view override returns (address) {
1324     require(_exists(tokenId), "ERC721A: approved query for nonexistent token");
1325 
1326     return _tokenApprovals[tokenId];
1327   }
1328 
1329   /**
1330    * @dev See {IERC721-setApprovalForAll}.
1331    */
1332   function setApprovalForAll(address operator, bool approved) public override {
1333     require(operator != _msgSender(), "ERC721A: approve to caller");
1334 
1335     _operatorApprovals[_msgSender()][operator] = approved;
1336     emit ApprovalForAll(_msgSender(), operator, approved);
1337   }
1338 
1339   /**
1340    * @dev See {IERC721-isApprovedForAll}.
1341    */
1342   function isApprovedForAll(address owner, address operator)
1343     public
1344     view
1345     virtual
1346     override
1347     returns (bool)
1348   {
1349     return _operatorApprovals[owner][operator];
1350   }
1351 
1352   /**
1353    * @dev See {IERC721-transferFrom}.
1354    */
1355   function transferFrom(
1356     address from,
1357     address to,
1358     uint256 tokenId
1359   ) public override {
1360     _transfer(from, to, tokenId);
1361   }
1362 
1363   /**
1364    * @dev See {IERC721-safeTransferFrom}.
1365    */
1366   function safeTransferFrom(
1367     address from,
1368     address to,
1369     uint256 tokenId
1370   ) public override {
1371     safeTransferFrom(from, to, tokenId, "");
1372   }
1373 
1374   /**
1375    * @dev See {IERC721-safeTransferFrom}.
1376    */
1377   function safeTransferFrom(
1378     address from,
1379     address to,
1380     uint256 tokenId,
1381     bytes memory _data
1382   ) public override {
1383     _transfer(from, to, tokenId);
1384     require(
1385       _checkOnERC721Received(from, to, tokenId, _data),
1386       "ERC721A: transfer to non ERC721Receiver implementer"
1387     );
1388   }
1389 
1390   /**
1391    * @dev Returns whether `tokenId` exists.
1392    *
1393    * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1394    *
1395    * Tokens start existing when they are minted (`_mint`),
1396    */
1397   function _exists(uint256 tokenId) internal view returns (bool) {
1398     return tokenId < currentIndex;
1399   }
1400 
1401   function _safeMint(address to, uint256 quantity) internal {
1402     _safeMint(to, quantity, "");
1403   }
1404 
1405   /**
1406    * @dev Mints `quantity` tokens and transfers them to `to`.
1407    *
1408    * Requirements:
1409    *
1410    * - there must be `quantity` tokens remaining unminted in the total collection.
1411    * - `to` cannot be the zero address.
1412    * - `quantity` cannot be larger than the max batch size.
1413    *
1414    * Emits a {Transfer} event.
1415    */
1416   function _safeMint(
1417     address to,
1418     uint256 quantity,
1419     bytes memory _data
1420   ) internal {
1421     uint256 startTokenId = currentIndex;
1422     require(to != address(0), "ERC721A: mint to the zero address");
1423     // We know if the first token in the batch doesn't exist, the other ones don't as well, because of serial ordering.
1424     require(!_exists(startTokenId), "ERC721A: token already minted");
1425     require(quantity <= maxBatchSize, "ERC721A: quantity to mint too high");
1426 
1427     _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1428 
1429     AddressData memory addressData = _addressData[to];
1430     _addressData[to] = AddressData(
1431       addressData.balance + uint128(quantity),
1432       addressData.numberMinted + uint128(quantity)
1433     );
1434     _ownerships[startTokenId] = TokenOwnership(to, uint64(block.timestamp));
1435 
1436     uint256 updatedIndex = startTokenId;
1437 
1438     for (uint256 i = 0; i < quantity; i++) {
1439       emit Transfer(address(0), to, updatedIndex);
1440       require(
1441         _checkOnERC721Received(address(0), to, updatedIndex, _data),
1442         "ERC721A: transfer to non ERC721Receiver implementer"
1443       );
1444       updatedIndex++;
1445     }
1446 
1447     currentIndex = updatedIndex;
1448     _afterTokenTransfers(address(0), to, startTokenId, quantity);
1449   }
1450 
1451   /**
1452    * @dev Transfers `tokenId` from `from` to `to`.
1453    *
1454    * Requirements:
1455    *
1456    * - `to` cannot be the zero address.
1457    * - `tokenId` token must be owned by `from`.
1458    *
1459    * Emits a {Transfer} event.
1460    */
1461   function _transfer(
1462     address from,
1463     address to,
1464     uint256 tokenId
1465   ) private {
1466     TokenOwnership memory prevOwnership = ownershipOf(tokenId);
1467 
1468     bool isApprovedOrOwner = (_msgSender() == prevOwnership.addr ||
1469       getApproved(tokenId) == _msgSender() ||
1470       isApprovedForAll(prevOwnership.addr, _msgSender()));
1471 
1472     require(
1473       isApprovedOrOwner,
1474       "ERC721A: transfer caller is not owner nor approved"
1475     );
1476 
1477     require(
1478       prevOwnership.addr == from,
1479       "ERC721A: transfer from incorrect owner"
1480     );
1481     require(to != address(0), "ERC721A: transfer to the zero address");
1482 
1483     _beforeTokenTransfers(from, to, tokenId, 1);
1484 
1485     // Clear approvals from the previous owner
1486     _approve(address(0), tokenId, prevOwnership.addr);
1487 
1488     _addressData[from].balance -= 1;
1489     _addressData[to].balance += 1;
1490     _ownerships[tokenId] = TokenOwnership(to, uint64(block.timestamp));
1491 
1492     // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1493     // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1494     uint256 nextTokenId = tokenId + 1;
1495     if (_ownerships[nextTokenId].addr == address(0)) {
1496       if (_exists(nextTokenId)) {
1497         _ownerships[nextTokenId] = TokenOwnership(
1498           prevOwnership.addr,
1499           prevOwnership.startTimestamp
1500         );
1501       }
1502     }
1503 
1504     emit Transfer(from, to, tokenId);
1505     _afterTokenTransfers(from, to, tokenId, 1);
1506   }
1507 
1508   /**
1509    * @dev Approve `to` to operate on `tokenId`
1510    *
1511    * Emits a {Approval} event.
1512    */
1513   function _approve(
1514     address to,
1515     uint256 tokenId,
1516     address owner
1517   ) private {
1518     _tokenApprovals[tokenId] = to;
1519     emit Approval(owner, to, tokenId);
1520   }
1521 
1522   uint256 public nextOwnerToExplicitlySet = 0;
1523 
1524   /**
1525    * @dev Explicitly set `owners` to eliminate loops in future calls of ownerOf().
1526    */
1527   function _setOwnersExplicit(uint256 quantity) internal {
1528     uint256 oldNextOwnerToSet = nextOwnerToExplicitlySet;
1529     require(quantity > 0, "quantity must be nonzero");
1530     uint256 endIndex = oldNextOwnerToSet + quantity - 1;
1531     if (endIndex > collectionSize - 1) {
1532       endIndex = collectionSize - 1;
1533     }
1534     // We know if the last one in the group exists, all in the group exist, due to serial ordering.
1535     require(_exists(endIndex), "not enough minted yet for this cleanup");
1536     for (uint256 i = oldNextOwnerToSet; i <= endIndex; i++) {
1537       if (_ownerships[i].addr == address(0)) {
1538         TokenOwnership memory ownership = ownershipOf(i);
1539         _ownerships[i] = TokenOwnership(
1540           ownership.addr,
1541           ownership.startTimestamp
1542         );
1543       }
1544     }
1545     nextOwnerToExplicitlySet = endIndex + 1;
1546   }
1547 
1548   /**
1549    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1550    * The call is not executed if the target address is not a contract.
1551    *
1552    * @param from address representing the previous owner of the given token ID
1553    * @param to target address that will receive the tokens
1554    * @param tokenId uint256 ID of the token to be transferred
1555    * @param _data bytes optional data to send along with the call
1556    * @return bool whether the call correctly returned the expected magic value
1557    */
1558   function _checkOnERC721Received(
1559     address from,
1560     address to,
1561     uint256 tokenId,
1562     bytes memory _data
1563   ) private returns (bool) {
1564     if (to.isContract()) {
1565       try
1566         IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data)
1567       returns (bytes4 retval) {
1568         return retval == IERC721Receiver(to).onERC721Received.selector;
1569       } catch (bytes memory reason) {
1570         if (reason.length == 0) {
1571           revert("ERC721A: transfer to non ERC721Receiver implementer");
1572         } else {
1573           assembly {
1574             revert(add(32, reason), mload(reason))
1575           }
1576         }
1577       }
1578     } else {
1579       return true;
1580     }
1581   }
1582 
1583   /**
1584    * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1585    *
1586    * startTokenId - the first token id to be transferred
1587    * quantity - the amount to be transferred
1588    *
1589    * Calling conditions:
1590    *
1591    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1592    * transferred to `to`.
1593    * - When `from` is zero, `tokenId` will be minted for `to`.
1594    */
1595   function _beforeTokenTransfers(
1596     address from,
1597     address to,
1598     uint256 startTokenId,
1599     uint256 quantity
1600   ) internal virtual {}
1601 
1602   /**
1603    * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1604    * minting.
1605    *
1606    * startTokenId - the first token id to be transferred
1607    * quantity - the amount to be transferred
1608    *
1609    * Calling conditions:
1610    *
1611    * - when `from` and `to` are both non-zero.
1612    * - `from` and `to` are never both zero.
1613    */
1614   function _afterTokenTransfers(
1615     address from,
1616     address to,
1617     uint256 startTokenId,
1618     uint256 quantity
1619   ) internal virtual {}
1620 }
1621 // File: @openzeppelin/contracts/access/Ownable.sol
1622 
1623 
1624 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1625 
1626 pragma solidity ^0.8.0;
1627 
1628 
1629 /**
1630  * @dev Contract module which provides a basic access control mechanism, where
1631  * there is an account (an owner) that can be granted exclusive access to
1632  * specific functions.
1633  *
1634  * By default, the owner account will be the one that deploys the contract. This
1635  * can later be changed with {transferOwnership}.
1636  *
1637  * This module is used through inheritance. It will make available the modifier
1638  * `onlyOwner`, which can be applied to your functions to restrict their use to
1639  * the owner.
1640  */
1641 abstract contract Ownable is Context {
1642     address private _owner;
1643 
1644     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1645 
1646     /**
1647      * @dev Initializes the contract setting the deployer as the initial owner.
1648      */
1649     constructor() {
1650         _transferOwnership(_msgSender());
1651     }
1652 
1653     /**
1654      * @dev Throws if called by any account other than the owner.
1655      */
1656     modifier onlyOwner() {
1657         _checkOwner();
1658         _;
1659     }
1660 
1661     /**
1662      * @dev Returns the address of the current owner.
1663      */
1664     function owner() public view virtual returns (address) {
1665         return _owner;
1666     }
1667 
1668     /**
1669      * @dev Throws if the sender is not the owner.
1670      */
1671     function _checkOwner() internal view virtual {
1672         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1673     }
1674 
1675     /**
1676      * @dev Leaves the contract without owner. It will not be possible to call
1677      * `onlyOwner` functions anymore. Can only be called by the current owner.
1678      *
1679      * NOTE: Renouncing ownership will leave the contract without an owner,
1680      * thereby removing any functionality that is only available to the owner.
1681      */
1682     function renounceOwnership() public virtual onlyOwner {
1683         _transferOwnership(address(0));
1684     }
1685 
1686     /**
1687      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1688      * Can only be called by the current owner.
1689      */
1690     function transferOwnership(address newOwner) public virtual onlyOwner {
1691         require(newOwner != address(0), "Ownable: new owner is the zero address");
1692         _transferOwnership(newOwner);
1693     }
1694 
1695     /**
1696      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1697      * Internal function without access restriction.
1698      */
1699     function _transferOwnership(address newOwner) internal virtual {
1700         address oldOwner = _owner;
1701         _owner = newOwner;
1702         emit OwnershipTransferred(oldOwner, newOwner);
1703     }
1704 }
1705 
1706 // File: Lords.sol
1707 
1708 
1709 
1710 
1711 //                   ooooo          .oooooo.   ooooooooo.   oooooooooo.    .oooooo..o  
1712 //                   `888'         d8P'  `Y8b  `888   `Y88. `888'   `Y8b  d8P'    `Y8  
1713 //                    888         888      888  888   .d88'  888      888 Y88bo.       
1714 //                    888         888      888  888ooo88P'   888      888  `"Y8888o.   
1715 //                    888         888      888  888`88b.     888      888      `"Y88b  
1716 //                    888       o `88b    d88'  888  `88b.   888     d88' oo     .d8P  
1717 //                   o888ooooood8  `Y8bood8P'  o888o  o888o o888bood8P'   8""88888P'   
1718 //                                        .oooooo.   oooooooooooo
1719 //                                       d8P'  `Y8b  `888'     `8
1720 //                                      888      888  888        
1721 //                                      888      888  888oooo8   
1722 //                                      888      888  888    "   
1723 //                                      `88b    d88'  888        
1724 //                                       `Y8bood8P'  o888o     
1725 //         ooooo        oooooo   oooo   .oooooo.   oooooooooooo ooooo     ooo ooo        ooooo 
1726 //         `888'         `888.   .8'   d8P'  `Y8b  `888'     `8 `888'     `8' `88.       .888' 
1727 //          888           `888. .8'   888           888          888       8   888b     d'888  
1728 //          888            `888.8'    888           888oooo8     888       8   8 Y88. .P  888  
1729 //          888             `888'     888           888    "     888       8   8  `888'   888  
1730 //          888       o      888      `88b    ooo   888       o  `88.    .8'   8    Y     888  
1731 //         o888ooooood8     o888o      `Y8bood8P'  o888ooooood8    `YbodP'    o8o        o888o                                                                                                                           
1732 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1733 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(,,&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1734 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,*,,,,*@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1735 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,**,,,,,%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1736 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%*****,,**,,,,**,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1737 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@****,,,,,,**,,,,***,,,,,(@@@@@@@@@@@@@@@@@@@@@@@@@@@
1738 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*****,,,,,,,**,,,,,***,,,,,,%@@@@@@@@@@@@@@@@@@@@@@@@
1739 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&*******,,,,,,,**,,,,,,,**,,,,,,@@@@@@@@@@@@@@@@@@@@@@@
1740 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*,,******,,,,,,,,***,,,,,,**,,,,,#@@@@@@@@@@@@@@@@@@@@@@
1741 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*,,,,******&%,,,,,,,,**,,,,,,**,,,,#@@@@@@@@@@@@@@@@@@@@@@
1742 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,*****@@@@,,,,,,,,**,,,,,,*,,,,%@@@@@@@@@@@@@@@@@@@@@@
1743 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,***#@@@@@%,,,,,,,,**,,,,,**,,,@@@@@@@@@@@@@@@@@@@@@@@
1744 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,**&@@@@@@%,,,,,,,,,**,,,,,*,,,@@@@@@@@@@@@@@@@@@@@@@@
1745 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,*************,,,,,,,,**,,,,,*,,*@@@@@@@@@@@@@@@@@@@@@@@
1746 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,***,*******,****,,,,,,,,,*,,,,,*,,&@@@@@@@@@@@@@@@@@@@@@@@
1747 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*,,,,,,,,,,,,,*************,,,,,,,,,,*,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@
1748 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,*************,,,,,,,,,,,,,,,,,,#@@@@@@@@@@@@@@@@@@@@@@@@
1749 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,,,,******,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@
1750 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,@@@@@@@@@@@@@@@@@@@@@@@@@@
1751 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@,,,,,,,,,,,***,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,(@@@@@@@@@@@@@@@@@@@@@@@@@@@
1752 // @@@@@@@@@@@@@@@@@@@@@@@@@@@(,,,,,,,,,,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,*/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1753 // @@@@@@@@@@@@@@@@@@@@@@@@@&,,,,,,,,,,,*,,,,,,,,,,,,,,,,,,,,,,,,,,,,**%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1754 // @@@@@@@@@@@@@@@@@@@@@@@&,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1755 // @@@@@@@@@@@@@@@@@@@@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1756 // @@@@@@@@@@@@@@@@@@@@/,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,****#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1757 // @@@@@@@@@@@@@@@@@@@@@*,,,,,,,,,,,,,,,,,,,,,,,,,****#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1758 // @@@@@@@@@@@@@@@@@@@@@@@&,,,,,,,,,,,,,,,,,,,,,*(@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1759 // @@@@@@@@@@@@@@@@@@@@@@@@@@@#,,,,,,,,,,,,,,,*%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1760 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&/,,,,,,*/@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1761 // @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
1762 //              ___  ____        ______    ___     _            _  _  ___   _______ __   __ __   __ 
1763 //        /\   / _ \|  _ \ /\    \  ___)  / _ \  _| |_       /\| || || \ \ / /  ___|_ \ / _)  \ /  |
1764 //       /  \ | | | | |_) )  \    \ \    | | | |/     \     /  \ \| |/ |\ v /| |_    \ v / |   v   |
1765 //      / /\ \| | | |  __/ /\ \    > >   | | | ( (| |) )   / /\ \_   _/  > < |  _)    | |  | |\_/| |
1766 //     / /  \ \ |_| | | / /__\ \  / /__  | |_| |\_   _/   / /  \ \| |   / ^ \| |___   | |  | |   | |
1767 //    /_/    \_\___/|_|/________\/_____)  \___/   |_|    /_/    \_\_|  /_/ \_\_____)  |_|  |_|   |_|  
1768 
1769 
1770 pragma solidity ^0.8.0;
1771 
1772 
1773 
1774 
1775 contract Lords is Ownable, ERC721A, ReentrancyGuard {
1776   uint256 public immutable maxWalletCount;
1777   uint256 public immutable maxMintSize;
1778   uint256 public immutable amountForDevs;
1779   uint256 public immutable maxSupply;
1780   bool public publicSaleIsActive = false;
1781   bool public allowlistSaleIsActive = false;
1782   string private _baseTokenURI;
1783 
1784   struct SaleConfig {
1785     uint64 allowlistPrice;
1786     uint64 publicPrice;
1787   }
1788 
1789   SaleConfig public saleConfig;
1790 
1791   mapping(address => bool) public isClaimed;
1792 
1793   constructor( uint256 maxWalletCount_, uint256 maxMintSize_, uint256 collectionSize_, uint256 amountForDevs_ ) ERC721A("Lords", "LORDS", maxWalletCount_, collectionSize_) {
1794     maxWalletCount = maxWalletCount_;
1795     amountForDevs = amountForDevs_;
1796     maxMintSize = maxMintSize_;
1797     maxSupply = collectionSize_;
1798     require( amountForDevs_ <= collectionSize_, "larger collection size needed");
1799   }
1800 
1801   modifier callerIsUser() {
1802     require(tx.origin == msg.sender, "The caller is another contract");
1803     _;
1804   }
1805 
1806   function setSaleInfo( uint64 allowlistPriceWei, uint64 publicPriceWei ) external onlyOwner {
1807     saleConfig = SaleConfig(
1808       allowlistPriceWei,
1809       publicPriceWei
1810     );
1811   }
1812 
1813   function flipBothSaleStates() public onlyOwner {
1814     allowlistSaleIsActive = !allowlistSaleIsActive;
1815     publicSaleIsActive = !publicSaleIsActive;
1816   }
1817 
1818   function flipAllowlistSaleState() public onlyOwner {
1819     allowlistSaleIsActive = !allowlistSaleIsActive;
1820   }
1821 
1822   function flipPublicSaleState() public onlyOwner {
1823     publicSaleIsActive = !publicSaleIsActive;
1824   }
1825 
1826   // FOR DEUS
1827   function devMint(uint256 quantity) external onlyOwner {
1828     require(totalSupply() + quantity <= amountForDevs, "too many already minted before dev mint");
1829     require(quantity % maxMintSize == 0, "can only mint a multiple of the maxMintSize");
1830     uint256 numChunks = quantity / maxMintSize;
1831     for (uint256 i = 0; i < numChunks; i++) {
1832       _safeMint(msg.sender, maxMintSize);
1833     }
1834   }
1835 
1836   function allowlistMint() external payable callerIsUser {
1837     SaleConfig memory config = saleConfig;
1838     uint256 allowlistPrice = uint256(config.allowlistPrice);
1839     require(allowlistSaleIsActive, "allowlist sale is not live");
1840     require(!isClaimed[msg.sender], "allowlist spot already claimed");
1841     require(totalSupply() + 1 <= collectionSize, "reached max supply");
1842     require(numberMinted(msg.sender) + 1 <= maxWalletCount, "can not mint this many");
1843     require(msg.value >= allowlistPrice, "Ether value sent is below the mint price");
1844     isClaimed[msg.sender] = true;
1845     _safeMint(msg.sender, 1);
1846   }
1847 
1848   function publicSaleMint(uint256 quantity) external payable callerIsUser {
1849     SaleConfig memory config = saleConfig;
1850     uint256 publicPrice = uint256(config.publicPrice);
1851     require(publicSaleIsActive, "public sale is not live");
1852     require(totalSupply() + quantity <= collectionSize, "reached max supply");
1853     require(numberMinted(msg.sender) + quantity <= maxWalletCount, "can not mint this many");
1854     require(quantity <= maxMintSize, "can not mint this many");
1855     require(msg.value >= (publicPrice * quantity), "Ether value sent is below the mint price");
1856     _safeMint(msg.sender, quantity);
1857   }
1858 
1859   function _baseURI() internal view virtual override returns (string memory) {
1860     return _baseTokenURI;
1861   }
1862 
1863   function setBaseURI(string calldata baseURI) external onlyOwner {
1864     _baseTokenURI = baseURI;
1865   }
1866 
1867   function withdrawMoney() external onlyOwner nonReentrant {
1868     (bool success, ) = msg.sender.call{value: address(this).balance}("");
1869     require(success, "Transfer failed.");
1870   }
1871 
1872   function numberMinted(address owner) public view returns (uint256) {
1873     return _numberMinted(owner);
1874   }
1875 
1876   function getOwnershipData(uint256 tokenId) external view returns (TokenOwnership memory) {
1877     return ownershipOf(tokenId);
1878   }
1879 }