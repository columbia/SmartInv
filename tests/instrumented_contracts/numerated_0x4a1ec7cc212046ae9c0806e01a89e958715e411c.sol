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
421 // File: @openzeppelin/contracts/utils/Context.sol
422 
423 
424 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev Provides information about the current execution context, including the
430  * sender of the transaction and its data. While these are generally available
431  * via msg.sender and msg.data, they should not be accessed in such a direct
432  * manner, since when dealing with meta-transactions the account sending and
433  * paying for execution may not be the actual sender (as far as an application
434  * is concerned).
435  *
436  * This contract is only required for intermediate, library-like contracts.
437  */
438 abstract contract Context {
439     function _msgSender() internal view virtual returns (address) {
440         return msg.sender;
441     }
442 
443     function _msgData() internal view virtual returns (bytes calldata) {
444         return msg.data;
445     }
446 }
447 
448 // File: @openzeppelin/contracts/utils/Address.sol
449 
450 
451 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
452 
453 pragma solidity ^0.8.1;
454 
455 /**
456  * @dev Collection of functions related to the address type
457  */
458 library Address {
459     /**
460      * @dev Returns true if `account` is a contract.
461      *
462      * [IMPORTANT]
463      * ====
464      * It is unsafe to assume that an address for which this function returns
465      * false is an externally-owned account (EOA) and not a contract.
466      *
467      * Among others, `isContract` will return false for the following
468      * types of addresses:
469      *
470      *  - an externally-owned account
471      *  - a contract in construction
472      *  - an address where a contract will be created
473      *  - an address where a contract lived, but was destroyed
474      * ====
475      *
476      * [IMPORTANT]
477      * ====
478      * You shouldn't rely on `isContract` to protect against flash loan attacks!
479      *
480      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
481      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
482      * constructor.
483      * ====
484      */
485     function isContract(address account) internal view returns (bool) {
486         // This method relies on extcodesize/address.code.length, which returns 0
487         // for contracts in construction, since the code is only stored at the end
488         // of the constructor execution.
489 
490         return account.code.length > 0;
491     }
492 
493     /**
494      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
495      * `recipient`, forwarding all available gas and reverting on errors.
496      *
497      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
498      * of certain opcodes, possibly making contracts go over the 2300 gas limit
499      * imposed by `transfer`, making them unable to receive funds via
500      * `transfer`. {sendValue} removes this limitation.
501      *
502      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
503      *
504      * IMPORTANT: because control is transferred to `recipient`, care must be
505      * taken to not create reentrancy vulnerabilities. Consider using
506      * {ReentrancyGuard} or the
507      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
508      */
509     function sendValue(address payable recipient, uint256 amount) internal {
510         require(address(this).balance >= amount, "Address: insufficient balance");
511 
512         (bool success, ) = recipient.call{value: amount}("");
513         require(success, "Address: unable to send value, recipient may have reverted");
514     }
515 
516     /**
517      * @dev Performs a Solidity function call using a low level `call`. A
518      * plain `call` is an unsafe replacement for a function call: use this
519      * function instead.
520      *
521      * If `target` reverts with a revert reason, it is bubbled up by this
522      * function (like regular Solidity function calls).
523      *
524      * Returns the raw returned data. To convert to the expected return value,
525      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
526      *
527      * Requirements:
528      *
529      * - `target` must be a contract.
530      * - calling `target` with `data` must not revert.
531      *
532      * _Available since v3.1._
533      */
534     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
535         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
540      * `errorMessage` as a fallback revert reason when `target` reverts.
541      *
542      * _Available since v3.1._
543      */
544     function functionCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         return functionCallWithValue(target, data, 0, errorMessage);
550     }
551 
552     /**
553      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
554      * but also transferring `value` wei to `target`.
555      *
556      * Requirements:
557      *
558      * - the calling contract must have an ETH balance of at least `value`.
559      * - the called Solidity function must be `payable`.
560      *
561      * _Available since v3.1._
562      */
563     function functionCallWithValue(
564         address target,
565         bytes memory data,
566         uint256 value
567     ) internal returns (bytes memory) {
568         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
569     }
570 
571     /**
572      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
573      * with `errorMessage` as a fallback revert reason when `target` reverts.
574      *
575      * _Available since v3.1._
576      */
577     function functionCallWithValue(
578         address target,
579         bytes memory data,
580         uint256 value,
581         string memory errorMessage
582     ) internal returns (bytes memory) {
583         require(address(this).balance >= value, "Address: insufficient balance for call");
584         (bool success, bytes memory returndata) = target.call{value: value}(data);
585         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
586     }
587 
588     /**
589      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
590      * but performing a static call.
591      *
592      * _Available since v3.3._
593      */
594     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
595         return functionStaticCall(target, data, "Address: low-level static call failed");
596     }
597 
598     /**
599      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
600      * but performing a static call.
601      *
602      * _Available since v3.3._
603      */
604     function functionStaticCall(
605         address target,
606         bytes memory data,
607         string memory errorMessage
608     ) internal view returns (bytes memory) {
609         (bool success, bytes memory returndata) = target.staticcall(data);
610         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
611     }
612 
613     /**
614      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
615      * but performing a delegate call.
616      *
617      * _Available since v3.4._
618      */
619     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
620         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
621     }
622 
623     /**
624      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
625      * but performing a delegate call.
626      *
627      * _Available since v3.4._
628      */
629     function functionDelegateCall(
630         address target,
631         bytes memory data,
632         string memory errorMessage
633     ) internal returns (bytes memory) {
634         (bool success, bytes memory returndata) = target.delegatecall(data);
635         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
636     }
637 
638     /**
639      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
640      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
641      *
642      * _Available since v4.8._
643      */
644     function verifyCallResultFromTarget(
645         address target,
646         bool success,
647         bytes memory returndata,
648         string memory errorMessage
649     ) internal view returns (bytes memory) {
650         if (success) {
651             if (returndata.length == 0) {
652                 // only check isContract if the call was successful and the return data is empty
653                 // otherwise we already know that it was a contract
654                 require(isContract(target), "Address: call to non-contract");
655             }
656             return returndata;
657         } else {
658             _revert(returndata, errorMessage);
659         }
660     }
661 
662     /**
663      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
664      * revert reason or using the provided one.
665      *
666      * _Available since v4.3._
667      */
668     function verifyCallResult(
669         bool success,
670         bytes memory returndata,
671         string memory errorMessage
672     ) internal pure returns (bytes memory) {
673         if (success) {
674             return returndata;
675         } else {
676             _revert(returndata, errorMessage);
677         }
678     }
679 
680     function _revert(bytes memory returndata, string memory errorMessage) private pure {
681         // Look for revert reason and bubble it up if present
682         if (returndata.length > 0) {
683             // The easiest way to bubble the revert reason is using memory via assembly
684             /// @solidity memory-safe-assembly
685             assembly {
686                 let returndata_size := mload(returndata)
687                 revert(add(32, returndata), returndata_size)
688             }
689         } else {
690             revert(errorMessage);
691         }
692     }
693 }
694 
695 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
696 
697 
698 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 /**
703  * @title ERC721 token receiver interface
704  * @dev Interface for any contract that wants to support safeTransfers
705  * from ERC721 asset contracts.
706  */
707 interface IERC721Receiver {
708     /**
709      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
710      * by `operator` from `from`, this function is called.
711      *
712      * It must return its Solidity selector to confirm the token transfer.
713      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
714      *
715      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
716      */
717     function onERC721Received(
718         address operator,
719         address from,
720         uint256 tokenId,
721         bytes calldata data
722     ) external returns (bytes4);
723 }
724 
725 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
726 
727 
728 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
729 
730 pragma solidity ^0.8.0;
731 
732 /**
733  * @dev Interface of the ERC165 standard, as defined in the
734  * https://eips.ethereum.org/EIPS/eip-165[EIP].
735  *
736  * Implementers can declare support of contract interfaces, which can then be
737  * queried by others ({ERC165Checker}).
738  *
739  * For an implementation, see {ERC165}.
740  */
741 interface IERC165 {
742     /**
743      * @dev Returns true if this contract implements the interface defined by
744      * `interfaceId`. See the corresponding
745      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
746      * to learn more about how these ids are created.
747      *
748      * This function call must use less than 30 000 gas.
749      */
750     function supportsInterface(bytes4 interfaceId) external view returns (bool);
751 }
752 
753 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
754 
755 
756 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
757 
758 pragma solidity ^0.8.0;
759 
760 
761 /**
762  * @dev Implementation of the {IERC165} interface.
763  *
764  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
765  * for the additional interface id that will be supported. For example:
766  *
767  * ```solidity
768  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
769  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
770  * }
771  * ```
772  *
773  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
774  */
775 abstract contract ERC165 is IERC165 {
776     /**
777      * @dev See {IERC165-supportsInterface}.
778      */
779     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
780         return interfaceId == type(IERC165).interfaceId;
781     }
782 }
783 
784 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
785 
786 
787 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
788 
789 pragma solidity ^0.8.0;
790 
791 
792 /**
793  * @dev Required interface of an ERC721 compliant contract.
794  */
795 interface IERC721 is IERC165 {
796     /**
797      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
798      */
799     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
800 
801     /**
802      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
803      */
804     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
805 
806     /**
807      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
808      */
809     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
810 
811     /**
812      * @dev Returns the number of tokens in ``owner``'s account.
813      */
814     function balanceOf(address owner) external view returns (uint256 balance);
815 
816     /**
817      * @dev Returns the owner of the `tokenId` token.
818      *
819      * Requirements:
820      *
821      * - `tokenId` must exist.
822      */
823     function ownerOf(uint256 tokenId) external view returns (address owner);
824 
825     /**
826      * @dev Safely transfers `tokenId` token from `from` to `to`.
827      *
828      * Requirements:
829      *
830      * - `from` cannot be the zero address.
831      * - `to` cannot be the zero address.
832      * - `tokenId` token must exist and be owned by `from`.
833      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
834      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
835      *
836      * Emits a {Transfer} event.
837      */
838     function safeTransferFrom(
839         address from,
840         address to,
841         uint256 tokenId,
842         bytes calldata data
843     ) external;
844 
845     /**
846      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
847      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
848      *
849      * Requirements:
850      *
851      * - `from` cannot be the zero address.
852      * - `to` cannot be the zero address.
853      * - `tokenId` token must exist and be owned by `from`.
854      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
855      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
856      *
857      * Emits a {Transfer} event.
858      */
859     function safeTransferFrom(
860         address from,
861         address to,
862         uint256 tokenId
863     ) external;
864 
865     /**
866      * @dev Transfers `tokenId` token from `from` to `to`.
867      *
868      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
869      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
870      * understand this adds an external call which potentially creates a reentrancy vulnerability.
871      *
872      * Requirements:
873      *
874      * - `from` cannot be the zero address.
875      * - `to` cannot be the zero address.
876      * - `tokenId` token must be owned by `from`.
877      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
878      *
879      * Emits a {Transfer} event.
880      */
881     function transferFrom(
882         address from,
883         address to,
884         uint256 tokenId
885     ) external;
886 
887     /**
888      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
889      * The approval is cleared when the token is transferred.
890      *
891      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
892      *
893      * Requirements:
894      *
895      * - The caller must own the token or be an approved operator.
896      * - `tokenId` must exist.
897      *
898      * Emits an {Approval} event.
899      */
900     function approve(address to, uint256 tokenId) external;
901 
902     /**
903      * @dev Approve or remove `operator` as an operator for the caller.
904      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
905      *
906      * Requirements:
907      *
908      * - The `operator` cannot be the caller.
909      *
910      * Emits an {ApprovalForAll} event.
911      */
912     function setApprovalForAll(address operator, bool _approved) external;
913 
914     /**
915      * @dev Returns the account approved for `tokenId` token.
916      *
917      * Requirements:
918      *
919      * - `tokenId` must exist.
920      */
921     function getApproved(uint256 tokenId) external view returns (address operator);
922 
923     /**
924      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
925      *
926      * See {setApprovalForAll}
927      */
928     function isApprovedForAll(address owner, address operator) external view returns (bool);
929 }
930 
931 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
932 
933 
934 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
935 
936 pragma solidity ^0.8.0;
937 
938 
939 /**
940  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
941  * @dev See https://eips.ethereum.org/EIPS/eip-721
942  */
943 interface IERC721Metadata is IERC721 {
944     /**
945      * @dev Returns the token collection name.
946      */
947     function name() external view returns (string memory);
948 
949     /**
950      * @dev Returns the token collection symbol.
951      */
952     function symbol() external view returns (string memory);
953 
954     /**
955      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
956      */
957     function tokenURI(uint256 tokenId) external view returns (string memory);
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
1465 // File: TERC721.sol
1466 
1467 pragma solidity ^0.8.0;
1468 
1469 
1470 
1471 contract PepePicasso is ERC721 {
1472     address public owner = msg.sender;
1473 
1474     uint256 public supply = 555;
1475     uint256 public price = 6900000000000000;
1476     string public base_uri = "https://pepe-picasso.s3.us-west-1.amazonaws.com/";
1477 
1478     uint256 latest_token_id = 0;
1479 
1480     modifier only_owner() {
1481         require(msg.sender == owner, "This function is restricted to the owner");
1482         _;
1483     }
1484 
1485     constructor() ERC721("Pepe Picasso", "PP") {
1486         owner = msg.sender;
1487     }
1488 
1489     function set_price(uint256 _price) external only_owner {
1490         price = _price;
1491     }
1492 
1493     function mint(address wallet, uint256 n_items) internal {
1494         require(latest_token_id + n_items <= supply, "Can't mint requested amount!");
1495         require(n_items * price >= msg.value, "Not enough eth supplied");
1496         for (uint256 i = 0; i < n_items; i++) {
1497             latest_token_id++;
1498             _mint(wallet, latest_token_id);
1499         }
1500     }
1501 
1502     function public_mint(uint256 n_items) external payable {
1503         require(msg.value >= price * n_items, "Not enough eth sent!");
1504         mint(msg.sender, n_items);
1505     }
1506 
1507     function admin_mint(address wallet, uint256 n_items) external only_owner {
1508         mint(wallet, n_items);
1509     }
1510 
1511     function _baseURI() internal view override returns (string memory) {
1512         return base_uri;
1513     }
1514 
1515     function set_base_uri(string memory new_uri) external only_owner {
1516         base_uri = new_uri;
1517     }
1518 
1519     function contractURI() public pure returns (string memory) {
1520         return "http://pepepicasso.com";
1521     }
1522 
1523     function withdraw(address payable wallet) public only_owner {
1524          uint256 amount = address(this).balance;
1525          wallet.transfer(amount);
1526          emit Transfer(address(this), wallet, amount);
1527      }
1528 }