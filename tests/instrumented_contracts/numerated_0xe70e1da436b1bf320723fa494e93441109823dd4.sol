1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity >=0.8.0 <0.9.0;
4 
5 /**
6  * @dev Standard math utilities missing in the Solidity language.
7  */
8 library Math {
9     enum Rounding {
10         Down, // Toward negative infinity
11         Up, // Toward infinity
12         Zero // Toward zero
13     }
14 
15     /**
16      * @dev Returns the largest of two numbers.
17      */
18     function max(uint256 a, uint256 b) internal pure returns (uint256) {
19         return a > b ? a : b;
20     }
21 
22     /**
23      * @dev Returns the smallest of two numbers.
24      */
25     function min(uint256 a, uint256 b) internal pure returns (uint256) {
26         return a < b ? a : b;
27     }
28 
29     /**
30      * @dev Returns the average of two numbers. The result is rounded towards
31      * zero.
32      */
33     function average(uint256 a, uint256 b) internal pure returns (uint256) {
34         // (a + b) / 2 can overflow.
35         return (a & b) + (a ^ b) / 2;
36     }
37 
38     /**
39      * @dev Returns the ceiling of the division of two numbers.
40      *
41      * This differs from standard division with `/` in that it rounds up instead
42      * of rounding down.
43      */
44     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
45         // (a + b - 1) / b can overflow on addition, so we distribute.
46         return a == 0 ? 0 : (a - 1) / b + 1;
47     }
48 
49     /**
50      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
51      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
52      * with further edits by Uniswap Labs also under MIT license.
53      */
54     function mulDiv(
55         uint256 x,
56         uint256 y,
57         uint256 denominator
58     ) internal pure returns (uint256 result) {
59         unchecked {
60             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
61             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
62             // variables such that product = prod1 * 2^256 + prod0.
63             uint256 prod0; // Least significant 256 bits of the product
64             uint256 prod1; // Most significant 256 bits of the product
65             assembly {
66                 let mm := mulmod(x, y, not(0))
67                 prod0 := mul(x, y)
68                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
69             }
70 
71             // Handle non-overflow cases, 256 by 256 division.
72             if (prod1 == 0) {
73                 return prod0 / denominator;
74             }
75 
76             // Make sure the result is less than 2^256. Also prevents denominator == 0.
77             require(denominator > prod1);
78 
79             ///////////////////////////////////////////////
80             // 512 by 256 division.
81             ///////////////////////////////////////////////
82 
83             // Make division exact by subtracting the remainder from [prod1 prod0].
84             uint256 remainder;
85             assembly {
86                 // Compute remainder using mulmod.
87                 remainder := mulmod(x, y, denominator)
88 
89                 // Subtract 256 bit number from 512 bit number.
90                 prod1 := sub(prod1, gt(remainder, prod0))
91                 prod0 := sub(prod0, remainder)
92             }
93 
94             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
95             // See https://cs.stackexchange.com/q/138556/92363.
96 
97             // Does not overflow because the denominator cannot be zero at this stage in the function.
98             uint256 twos = denominator & (~denominator + 1);
99             assembly {
100                 // Divide denominator by twos.
101                 denominator := div(denominator, twos)
102 
103                 // Divide [prod1 prod0] by twos.
104                 prod0 := div(prod0, twos)
105 
106                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
107                 twos := add(div(sub(0, twos), twos), 1)
108             }
109 
110             // Shift in bits from prod1 into prod0.
111             prod0 |= prod1 * twos;
112 
113             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
114             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
115             // four bits. That is, denominator * inv = 1 mod 2^4.
116             uint256 inverse = (3 * denominator) ^ 2;
117 
118             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
119             // in modular arithmetic, doubling the correct bits in each step.
120             inverse *= 2 - denominator * inverse; // inverse mod 2^8
121             inverse *= 2 - denominator * inverse; // inverse mod 2^16
122             inverse *= 2 - denominator * inverse; // inverse mod 2^32
123             inverse *= 2 - denominator * inverse; // inverse mod 2^64
124             inverse *= 2 - denominator * inverse; // inverse mod 2^128
125             inverse *= 2 - denominator * inverse; // inverse mod 2^256
126 
127             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
128             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
129             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
130             // is no longer required.
131             result = prod0 * inverse;
132             return result;
133         }
134     }
135 
136     /**
137      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
138      */
139     function mulDiv(
140         uint256 x,
141         uint256 y,
142         uint256 denominator,
143         Rounding rounding
144     ) internal pure returns (uint256) {
145         uint256 result = mulDiv(x, y, denominator);
146         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
147             result += 1;
148         }
149         return result;
150     }
151 
152     /**
153      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
154      *
155      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
156      */
157     function sqrt(uint256 a) internal pure returns (uint256) {
158         if (a == 0) {
159             return 0;
160         }
161 
162         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
163         //
164         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
165         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
166         //
167         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
168         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
169         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
170         //
171         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
172         uint256 result = 1 << (log2(a) >> 1);
173 
174         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
175         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
176         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
177         // into the expected uint128 result.
178         unchecked {
179             result = (result + a / result) >> 1;
180             result = (result + a / result) >> 1;
181             result = (result + a / result) >> 1;
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             return min(result, a / result);
187         }
188     }
189 
190     /**
191      * @notice Calculates sqrt(a), following the selected rounding direction.
192      */
193     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
194         unchecked {
195             uint256 result = sqrt(a);
196             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
197         }
198     }
199 
200     /**
201      * @dev Return the log in base 2, rounded down, of a positive value.
202      * Returns 0 if given 0.
203      */
204     function log2(uint256 value) internal pure returns (uint256) {
205         uint256 result = 0;
206         unchecked {
207             if (value >> 128 > 0) {
208                 value >>= 128;
209                 result += 128;
210             }
211             if (value >> 64 > 0) {
212                 value >>= 64;
213                 result += 64;
214             }
215             if (value >> 32 > 0) {
216                 value >>= 32;
217                 result += 32;
218             }
219             if (value >> 16 > 0) {
220                 value >>= 16;
221                 result += 16;
222             }
223             if (value >> 8 > 0) {
224                 value >>= 8;
225                 result += 8;
226             }
227             if (value >> 4 > 0) {
228                 value >>= 4;
229                 result += 4;
230             }
231             if (value >> 2 > 0) {
232                 value >>= 2;
233                 result += 2;
234             }
235             if (value >> 1 > 0) {
236                 result += 1;
237             }
238         }
239         return result;
240     }
241 
242     /**
243      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
244      * Returns 0 if given 0.
245      */
246     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
247         unchecked {
248             uint256 result = log2(value);
249             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
250         }
251     }
252 
253     /**
254      * @dev Return the log in base 10, rounded down, of a positive value.
255      * Returns 0 if given 0.
256      */
257     function log10(uint256 value) internal pure returns (uint256) {
258         uint256 result = 0;
259         unchecked {
260             if (value >= 10**64) {
261                 value /= 10**64;
262                 result += 64;
263             }
264             if (value >= 10**32) {
265                 value /= 10**32;
266                 result += 32;
267             }
268             if (value >= 10**16) {
269                 value /= 10**16;
270                 result += 16;
271             }
272             if (value >= 10**8) {
273                 value /= 10**8;
274                 result += 8;
275             }
276             if (value >= 10**4) {
277                 value /= 10**4;
278                 result += 4;
279             }
280             if (value >= 10**2) {
281                 value /= 10**2;
282                 result += 2;
283             }
284             if (value >= 10**1) {
285                 result += 1;
286             }
287         }
288         return result;
289     }
290 
291     /**
292      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
293      * Returns 0 if given 0.
294      */
295     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
296         unchecked {
297             uint256 result = log10(value);
298             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
299         }
300     }
301 
302     /**
303      * @dev Return the log in base 256, rounded down, of a positive value.
304      * Returns 0 if given 0.
305      *
306      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
307      */
308     function log256(uint256 value) internal pure returns (uint256) {
309         uint256 result = 0;
310         unchecked {
311             if (value >> 128 > 0) {
312                 value >>= 128;
313                 result += 16;
314             }
315             if (value >> 64 > 0) {
316                 value >>= 64;
317                 result += 8;
318             }
319             if (value >> 32 > 0) {
320                 value >>= 32;
321                 result += 4;
322             }
323             if (value >> 16 > 0) {
324                 value >>= 16;
325                 result += 2;
326             }
327             if (value >> 8 > 0) {
328                 result += 1;
329             }
330         }
331         return result;
332     }
333 
334     /**
335      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
336      * Returns 0 if given 0.
337      */
338     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
339         unchecked {
340             uint256 result = log256(value);
341             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
342         }
343     }
344 }
345 
346 
347 /**
348  * @title ERC721 token receiver interface
349  * @dev Interface for any contract that wants to support safeTransfers
350  * from ERC721 asset contracts.
351  */
352 interface IERC721Receiver {
353     /**
354      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
355      * by `operator` from `from`, this function is called.
356      *
357      * It must return its Solidity selector to confirm the token transfer.
358      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
359      *
360      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
361      */
362     function onERC721Received(
363         address operator,
364         address from,
365         uint256 tokenId,
366         bytes calldata data
367     ) external returns (bytes4);
368 }
369 
370 /**
371  * @dev Collection of functions related to the address type
372  */
373 library Address {
374     /**
375      * @dev Returns true if `account` is a contract.
376      *
377      * [IMPORTANT]
378      * ====
379      * It is unsafe to assume that an address for which this function returns
380      * false is an externally-owned account (EOA) and not a contract.
381      *
382      * Among others, `isContract` will return false for the following
383      * types of addresses:
384      *
385      *  - an externally-owned account
386      *  - a contract in construction
387      *  - an address where a contract will be created
388      *  - an address where a contract lived, but was destroyed
389      * ====
390      *
391      * [IMPORTANT]
392      * ====
393      * You shouldn't rely on `isContract` to protect against flash loan attacks!
394      *
395      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
396      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
397      * constructor.
398      * ====
399      */
400     function isContract(address account) internal view returns (bool) {
401         // This method relies on extcodesize/address.code.length, which returns 0
402         // for contracts in construction, since the code is only stored at the end
403         // of the constructor execution.
404 
405         return account.code.length > 0;
406     }
407 
408     /**
409      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
410      * `recipient`, forwarding all available gas and reverting on errors.
411      *
412      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
413      * of certain opcodes, possibly making contracts go over the 2300 gas limit
414      * imposed by `transfer`, making them unable to receive funds via
415      * `transfer`. {sendValue} removes this limitation.
416      *
417      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
418      *
419      * IMPORTANT: because control is transferred to `recipient`, care must be
420      * taken to not create reentrancy vulnerabilities. Consider using
421      * {ReentrancyGuard} or the
422      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
423      */
424     function sendValue(address payable recipient, uint256 amount) internal {
425         require(address(this).balance >= amount, "Address: insufficient balance");
426 
427         (bool success, ) = recipient.call{value: amount}("");
428         require(success, "Address: unable to send value, recipient may have reverted");
429     }
430 
431     /**
432      * @dev Performs a Solidity function call using a low level `call`. A
433      * plain `call` is an unsafe replacement for a function call: use this
434      * function instead.
435      *
436      * If `target` reverts with a revert reason, it is bubbled up by this
437      * function (like regular Solidity function calls).
438      *
439      * Returns the raw returned data. To convert to the expected return value,
440      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
441      *
442      * Requirements:
443      *
444      * - `target` must be a contract.
445      * - calling `target` with `data` must not revert.
446      *
447      * _Available since v3.1._
448      */
449     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
450         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
451     }
452 
453     /**
454      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
455      * `errorMessage` as a fallback revert reason when `target` reverts.
456      *
457      * _Available since v3.1._
458      */
459     function functionCall(
460         address target,
461         bytes memory data,
462         string memory errorMessage
463     ) internal returns (bytes memory) {
464         return functionCallWithValue(target, data, 0, errorMessage);
465     }
466 
467     /**
468      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
469      * but also transferring `value` wei to `target`.
470      *
471      * Requirements:
472      *
473      * - the calling contract must have an ETH balance of at least `value`.
474      * - the called Solidity function must be `payable`.
475      *
476      * _Available since v3.1._
477      */
478     function functionCallWithValue(
479         address target,
480         bytes memory data,
481         uint256 value
482     ) internal returns (bytes memory) {
483         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
484     }
485 
486     /**
487      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
488      * with `errorMessage` as a fallback revert reason when `target` reverts.
489      *
490      * _Available since v3.1._
491      */
492     function functionCallWithValue(
493         address target,
494         bytes memory data,
495         uint256 value,
496         string memory errorMessage
497     ) internal returns (bytes memory) {
498         require(address(this).balance >= value, "Address: insufficient balance for call");
499         (bool success, bytes memory returndata) = target.call{value: value}(data);
500         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but performing a static call.
506      *
507      * _Available since v3.3._
508      */
509     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
510         return functionStaticCall(target, data, "Address: low-level static call failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
515      * but performing a static call.
516      *
517      * _Available since v3.3._
518      */
519     function functionStaticCall(
520         address target,
521         bytes memory data,
522         string memory errorMessage
523     ) internal view returns (bytes memory) {
524         (bool success, bytes memory returndata) = target.staticcall(data);
525         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
526     }
527 
528     /**
529      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
530      * but performing a delegate call.
531      *
532      * _Available since v3.4._
533      */
534     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
535         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
536     }
537 
538     /**
539      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
540      * but performing a delegate call.
541      *
542      * _Available since v3.4._
543      */
544     function functionDelegateCall(
545         address target,
546         bytes memory data,
547         string memory errorMessage
548     ) internal returns (bytes memory) {
549         (bool success, bytes memory returndata) = target.delegatecall(data);
550         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
551     }
552 
553     /**
554      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
555      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
556      *
557      * _Available since v4.8._
558      */
559     function verifyCallResultFromTarget(
560         address target,
561         bool success,
562         bytes memory returndata,
563         string memory errorMessage
564     ) internal view returns (bytes memory) {
565         if (success) {
566             if (returndata.length == 0) {
567                 // only check isContract if the call was successful and the return data is empty
568                 // otherwise we already know that it was a contract
569                 require(isContract(target), "Address: call to non-contract");
570             }
571             return returndata;
572         } else {
573             _revert(returndata, errorMessage);
574         }
575     }
576 
577     /**
578      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
579      * revert reason or using the provided one.
580      *
581      * _Available since v4.3._
582      */
583     function verifyCallResult(
584         bool success,
585         bytes memory returndata,
586         string memory errorMessage
587     ) internal pure returns (bytes memory) {
588         if (success) {
589             return returndata;
590         } else {
591             _revert(returndata, errorMessage);
592         }
593     }
594 
595     function _revert(bytes memory returndata, string memory errorMessage) private pure {
596         // Look for revert reason and bubble it up if present
597         if (returndata.length > 0) {
598             // The easiest way to bubble the revert reason is using memory via assembly
599             /// @solidity memory-safe-assembly
600             assembly {
601                 let returndata_size := mload(returndata)
602                 revert(add(32, returndata), returndata_size)
603             }
604         } else {
605             revert(errorMessage);
606         }
607     }
608 }
609 
610 /**
611  * @dev String operations.
612  */
613 library Strings {
614     bytes16 private constant _SYMBOLS = "0123456789abcdef";
615     uint8 private constant _ADDRESS_LENGTH = 20;
616 
617     /**
618      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
619      */
620     function toString(uint256 value) internal pure returns (string memory) {
621         unchecked {
622             uint256 length = Math.log10(value) + 1;
623             string memory buffer = new string(length);
624             uint256 ptr;
625             /// @solidity memory-safe-assembly
626             assembly {
627                 ptr := add(buffer, add(32, length))
628             }
629             while (true) {
630                 ptr--;
631                 /// @solidity memory-safe-assembly
632                 assembly {
633                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
634                 }
635                 value /= 10;
636                 if (value == 0) break;
637             }
638             return buffer;
639         }
640     }
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
644      */
645     function toHexString(uint256 value) internal pure returns (string memory) {
646         unchecked {
647             return toHexString(value, Math.log256(value) + 1);
648         }
649     }
650 
651     /**
652      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
653      */
654     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
655         bytes memory buffer = new bytes(2 * length + 2);
656         buffer[0] = "0";
657         buffer[1] = "x";
658         for (uint256 i = 2 * length + 1; i > 1; --i) {
659             buffer[i] = _SYMBOLS[value & 0xf];
660             value >>= 4;
661         }
662         require(value == 0, "Strings: hex length insufficient");
663         return string(buffer);
664     }
665 
666     /**
667      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
668      */
669     function toHexString(address addr) internal pure returns (string memory) {
670         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
671     }
672 }
673 
674 /**
675  * @dev Interface of the ERC165 standard, as defined in the
676  * https://eips.ethereum.org/EIPS/eip-165[EIP].
677  *
678  * Implementers can declare support of contract interfaces, which can then be
679  * queried by others ({ERC165Checker}).
680  *
681  * For an implementation, see {ERC165}.
682  */
683 interface IERC165 {
684     /**
685      * @dev Returns true if this contract implements the interface defined by
686      * `interfaceId`. See the corresponding
687      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
688      * to learn more about how these ids are created.
689      *
690      * This function call must use less than 30 000 gas.
691      */
692     function supportsInterface(bytes4 interfaceId) external view returns (bool);
693 }
694 
695 interface IOperatorFilterRegistry {
696     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
697     function register(address registrant) external;
698     function registerAndSubscribe(address registrant, address subscription) external;
699     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
700     function unregister(address addr) external;
701     function updateOperator(address registrant, address operator, bool filtered) external;
702     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
703     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
704     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
705     function subscribe(address registrant, address registrantToSubscribe) external;
706     function unsubscribe(address registrant, bool copyExistingEntries) external;
707     function subscriptionOf(address addr) external returns (address registrant);
708     function subscribers(address registrant) external returns (address[] memory);
709     function subscriberAt(address registrant, uint256 index) external returns (address);
710     function copyEntriesOf(address registrant, address registrantToCopy) external;
711     function isOperatorFiltered(address registrant, address operator) external returns (bool);
712     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
713     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
714     function filteredOperators(address addr) external returns (address[] memory);
715     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
716     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
717     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
718     function isRegistered(address addr) external returns (bool);
719     function codeHashOf(address addr) external returns (bytes32);
720 }
721 
722 
723 /**
724  * @dev Provides information about the current execution context, including the
725  * sender of the transaction and its data. While these are generally available
726  * via msg.sender and msg.data, they should not be accessed in such a direct
727  * manner, since when dealing with meta-transactions the account sending and
728  * paying for execution may not be the actual sender (as far as an application
729  * is concerned).
730  *
731  * This contract is only required for intermediate, library-like contracts.
732  */
733 abstract contract Context {
734     function _msgSender() internal view virtual returns (address) {
735         return msg.sender;
736     }
737 
738     function _msgData() internal view virtual returns (bytes calldata) {
739         return msg.data;
740     }
741 }
742 
743 /**
744  * @dev Contract module which provides a basic access control mechanism, where
745  * there is an account (an owner) that can be granted exclusive access to
746  * specific functions.
747  *
748  * By default, the owner account will be the one that deploys the contract. This
749  * can later be changed with {transferOwnership}.
750  *
751  * This module is used through inheritance. It will make available the modifier
752  * `onlyOwner`, which can be applied to your functions to restrict their use to
753  * the owner.
754  */
755 abstract contract Ownable is Context {
756     address private _owner;
757 
758     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
759 
760     /**
761      * @dev Initializes the contract setting the deployer as the initial owner.
762      */
763     constructor() {
764         _transferOwnership(_msgSender());
765     }
766 
767     /**
768      * @dev Throws if called by any account other than the owner.
769      */
770     modifier onlyOwner() {
771         _checkOwner();
772         _;
773     }
774 
775     /**
776      * @dev Returns the address of the current owner.
777      */
778     function owner() public view virtual returns (address) {
779         return _owner;
780     }
781 
782     /**
783      * @dev Throws if the sender is not the owner.
784      */
785     function _checkOwner() internal view virtual {
786         require(owner() == _msgSender(), "Ownable: caller is not the owner");
787     }
788 
789     /**
790      * @dev Leaves the contract without owner. It will not be possible to call
791      * `onlyOwner` functions anymore. Can only be called by the current owner.
792      *
793      * NOTE: Renouncing ownership will leave the contract without an owner,
794      * thereby removing any functionality that is only available to the owner.
795      */
796     function renounceOwnership() public virtual onlyOwner {
797         _transferOwnership(address(0));
798     }
799 
800     /**
801      * @dev Transfers ownership of the contract to a new account (`newOwner`).
802      * Can only be called by the current owner.
803      */
804     function transferOwnership(address newOwner) public virtual onlyOwner {
805         require(newOwner != address(0), "Ownable: new owner is the zero address");
806         _transferOwnership(newOwner);
807     }
808 
809     /**
810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
811      * Internal function without access restriction.
812      */
813     function _transferOwnership(address newOwner) internal virtual {
814         address oldOwner = _owner;
815         _owner = newOwner;
816         emit OwnershipTransferred(oldOwner, newOwner);
817     }
818 }
819 
820 /**
821  * @dev Implementation of the {IERC165} interface.
822  *
823  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
824  * for the additional interface id that will be supported. For example:
825  *
826  * ```solidity
827  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
828  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
829  * }
830  * ```
831  *
832  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
833  */
834 abstract contract ERC165 is IERC165 {
835     /**
836      * @dev See {IERC165-supportsInterface}.
837      */
838     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
839         return interfaceId == type(IERC165).interfaceId;
840     }
841 }
842 
843 /**
844  * @dev Interface for the NFT Royalty Standard.
845  *
846  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
847  * support for royalty payments across all NFT marketplaces and ecosystem participants.
848  *
849  * _Available since v4.5._
850  */
851 interface IERC2981 is IERC165 {
852     /**
853      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
854      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
855      */
856     function royaltyInfo(uint256 tokenId, uint256 salePrice)
857         external
858         view
859         returns (address receiver, uint256 royaltyAmount);
860 }
861 /**
862  * @dev Interface of ERC721A.
863  */
864 interface IERC721A {
865     /**
866      * The caller must own the token or be an approved operator.
867      */
868     error ApprovalCallerNotOwnerNorApproved();
869 
870     /**
871      * The token does not exist.
872      */
873     error ApprovalQueryForNonexistentToken();
874 
875     /**
876      * Cannot query the balance for the zero address.
877      */
878     error BalanceQueryForZeroAddress();
879 
880     /**
881      * Cannot mint to the zero address.
882      */
883     error MintToZeroAddress();
884 
885     /**
886      * The quantity of tokens minted must be more than zero.
887      */
888     error MintZeroQuantity();
889 
890     /**
891      * The token does not exist.
892      */
893     error OwnerQueryForNonexistentToken();
894 
895     /**
896      * The caller must own the token or be an approved operator.
897      */
898     error TransferCallerNotOwnerNorApproved();
899 
900     /**
901      * The token must be owned by `from`.
902      */
903     error TransferFromIncorrectOwner();
904 
905     /**
906      * Cannot safely transfer to a contract that does not implement the
907      * ERC721Receiver interface.
908      */
909     error TransferToNonERC721ReceiverImplementer();
910 
911     /**
912      * Cannot transfer to the zero address.
913      */
914     error TransferToZeroAddress();
915 
916     /**
917      * The token does not exist.
918      */
919     error URIQueryForNonexistentToken();
920 
921     /**
922      * The `quantity` minted with ERC2309 exceeds the safety limit.
923      */
924     error MintERC2309QuantityExceedsLimit();
925 
926     /**
927      * The `extraData` cannot be set on an unintialized ownership slot.
928      */
929     error OwnershipNotInitializedForExtraData();
930 
931     // =============================================================
932     //                            STRUCTS
933     // =============================================================
934 
935     struct TokenOwnership {
936         // The address of the owner.
937         address addr;
938         // Stores the start time of ownership with minimal overhead for tokenomics.
939         uint64 startTimestamp;
940         // Whether the token has been burned.
941         bool burned;
942         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
943         uint24 extraData;
944     }
945 
946     // =============================================================
947     //                         TOKEN COUNTERS
948     // =============================================================
949 
950     /**
951      * @dev Returns the total number of tokens in existence.
952      * Burned tokens will reduce the count.
953      * To get the total number of tokens minted, please see {_totalMinted}.
954      */
955     function totalSupply() external view returns (uint256);
956 
957     // =============================================================
958     //                            IERC165
959     // =============================================================
960 
961     /**
962      * @dev Returns true if this contract implements the interface defined by
963      * `interfaceId`. See the corresponding
964      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
965      * to learn more about how these ids are created.
966      *
967      * This function call must use less than 30000 gas.
968      */
969     function supportsInterface(bytes4 interfaceId) external view returns (bool);
970 
971     // =============================================================
972     //                            IERC721
973     // =============================================================
974 
975     /**
976      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
977      */
978     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
979 
980     /**
981      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
982      */
983     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
984 
985     /**
986      * @dev Emitted when `owner` enables or disables
987      * (`approved`) `operator` to manage all of its assets.
988      */
989     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
990 
991     /**
992      * @dev Returns the number of tokens in `owner`'s account.
993      */
994     function balanceOf(address owner) external view returns (uint256 balance);
995 
996     /**
997      * @dev Returns the owner of the `tokenId` token.
998      *
999      * Requirements:
1000      *
1001      * - `tokenId` must exist.
1002      */
1003     function ownerOf(uint256 tokenId) external view returns (address owner);
1004 
1005     /**
1006      * @dev Safely transfers `tokenId` token from `from` to `to`,
1007      * checking first that contract recipients are aware of the ERC721 protocol
1008      * to prevent tokens from being forever locked.
1009      *
1010      * Requirements:
1011      *
1012      * - `from` cannot be the zero address.
1013      * - `to` cannot be the zero address.
1014      * - `tokenId` token must exist and be owned by `from`.
1015      * - If the caller is not `from`, it must be have been allowed to move
1016      * this token by either {approve} or {setApprovalForAll}.
1017      * - If `to` refers to a smart contract, it must implement
1018      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1019      *
1020      * Emits a {Transfer} event.
1021      */
1022     function safeTransferFrom(
1023         address from,
1024         address to,
1025         uint256 tokenId,
1026         bytes calldata data
1027     ) external payable;
1028 
1029     /**
1030      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1031      */
1032     function safeTransferFrom(
1033         address from,
1034         address to,
1035         uint256 tokenId
1036     ) external payable;
1037 
1038     /**
1039      * @dev Transfers `tokenId` from `from` to `to`.
1040      *
1041      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1042      * whenever possible.
1043      *
1044      * Requirements:
1045      *
1046      * - `from` cannot be the zero address.
1047      * - `to` cannot be the zero address.
1048      * - `tokenId` token must be owned by `from`.
1049      * - If the caller is not `from`, it must be approved to move this token
1050      * by either {approve} or {setApprovalForAll}.
1051      *
1052      * Emits a {Transfer} event.
1053      */
1054     function transferFrom(
1055         address from,
1056         address to,
1057         uint256 tokenId
1058     ) external payable;
1059 
1060     /**
1061      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1062      * The approval is cleared when the token is transferred.
1063      *
1064      * Only a single account can be approved at a time, so approving the
1065      * zero address clears previous approvals.
1066      *
1067      * Requirements:
1068      *
1069      * - The caller must own the token or be an approved operator.
1070      * - `tokenId` must exist.
1071      *
1072      * Emits an {Approval} event.
1073      */
1074     function approve(address to, uint256 tokenId) external payable;
1075 
1076     /**
1077      * @dev Approve or remove `operator` as an operator for the caller.
1078      * Operators can call {transferFrom} or {safeTransferFrom}
1079      * for any token owned by the caller.
1080      *
1081      * Requirements:
1082      *
1083      * - The `operator` cannot be the caller.
1084      *
1085      * Emits an {ApprovalForAll} event.
1086      */
1087     function setApprovalForAll(address operator, bool _approved) external;
1088 
1089     /**
1090      * @dev Returns the account approved for `tokenId` token.
1091      *
1092      * Requirements:
1093      *
1094      * - `tokenId` must exist.
1095      */
1096     function getApproved(uint256 tokenId) external view returns (address operator);
1097 
1098     /**
1099      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1100      *
1101      * See {setApprovalForAll}.
1102      */
1103     function isApprovedForAll(address owner, address operator) external view returns (bool);
1104 
1105     // =============================================================
1106     //                        IERC721Metadata
1107     // =============================================================
1108 
1109     /**
1110      * @dev Returns the token collection name.
1111      */
1112     function name() external view returns (string memory);
1113 
1114     /**
1115      * @dev Returns the token collection symbol.
1116      */
1117     function symbol() external view returns (string memory);
1118 
1119     /**
1120      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1121      */
1122     function tokenURI(uint256 tokenId) external view returns (string memory);
1123 
1124     // =============================================================
1125     //                           IERC2309
1126     // =============================================================
1127 
1128     /**
1129      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1130      * (inclusive) is transferred from `from` to `to`, as defined in the
1131      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1132      *
1133      * See {_mintERC2309} for more details.
1134      */
1135     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1136 }
1137 
1138 /**
1139  * @dev Interface of ERC721ABurnable.
1140  */
1141 interface IERC721ABurnable is IERC721A {
1142     /**
1143      * @dev Burns `tokenId`. See {ERC721A-_burn}.
1144      *
1145      * Requirements:
1146      *
1147      * - The caller must own `tokenId` or be an approved operator.
1148      */
1149     function burn(uint256 tokenId) external;
1150 }
1151 
1152 /**
1153  * @dev Interface of ERC721AQueryable.
1154  */
1155 interface IERC721AQueryable is IERC721A {
1156     /**
1157      * Invalid query range (`start` >= `stop`).
1158      */
1159     error InvalidQueryRange();
1160 
1161     /**
1162      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1163      *
1164      * If the `tokenId` is out of bounds:
1165      *
1166      * - `addr = address(0)`
1167      * - `startTimestamp = 0`
1168      * - `burned = false`
1169      * - `extraData = 0`
1170      *
1171      * If the `tokenId` is burned:
1172      *
1173      * - `addr = <Address of owner before token was burned>`
1174      * - `startTimestamp = <Timestamp when token was burned>`
1175      * - `burned = true`
1176      * - `extraData = <Extra data when token was burned>`
1177      *
1178      * Otherwise:
1179      *
1180      * - `addr = <Address of owner>`
1181      * - `startTimestamp = <Timestamp of start of ownership>`
1182      * - `burned = false`
1183      * - `extraData = <Extra data at start of ownership>`
1184      */
1185     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1186 
1187     /**
1188      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1189      * See {ERC721AQueryable-explicitOwnershipOf}
1190      */
1191     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1192 
1193     /**
1194      * @dev Returns an array of token IDs owned by `owner`,
1195      * in the range [`start`, `stop`)
1196      * (i.e. `start <= tokenId < stop`).
1197      *
1198      * This function allows for tokens to be queried if the collection
1199      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1200      *
1201      * Requirements:
1202      *
1203      * - `start < stop`
1204      */
1205     function tokensOfOwnerIn(
1206         address owner,
1207         uint256 start,
1208         uint256 stop
1209     ) external view returns (uint256[] memory);
1210 
1211     /**
1212      * @dev Returns an array of token IDs owned by `owner`.
1213      *
1214      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1215      * It is meant to be called off-chain.
1216      *
1217      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1218      * multiple smaller scans if the collection is large enough to cause
1219      * an out-of-gas error (10K collections should be fine).
1220      */
1221     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1222 }
1223 
1224 /**
1225  * @dev Required interface of an ERC721 compliant contract.
1226  */
1227 interface IERC721 is IERC165 {
1228     /**
1229      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1230      */
1231     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1232 
1233     /**
1234      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1235      */
1236     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1237 
1238     /**
1239      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1240      */
1241     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1242 
1243     /**
1244      * @dev Returns the number of tokens in ``owner``'s account.
1245      */
1246     function balanceOf(address owner) external view returns (uint256 balance);
1247 
1248     /**
1249      * @dev Returns the owner of the `tokenId` token.
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must exist.
1254      */
1255     function ownerOf(uint256 tokenId) external view returns (address owner);
1256 
1257     /**
1258      * @dev Safely transfers `tokenId` token from `from` to `to`.
1259      *
1260      * Requirements:
1261      *
1262      * - `from` cannot be the zero address.
1263      * - `to` cannot be the zero address.
1264      * - `tokenId` token must exist and be owned by `from`.
1265      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1266      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1267      *
1268      * Emits a {Transfer} event.
1269      */
1270     function safeTransferFrom(
1271         address from,
1272         address to,
1273         uint256 tokenId,
1274         bytes calldata data
1275     ) external;
1276 
1277     /**
1278      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1279      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1280      *
1281      * Requirements:
1282      *
1283      * - `from` cannot be the zero address.
1284      * - `to` cannot be the zero address.
1285      * - `tokenId` token must exist and be owned by `from`.
1286      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1287      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1288      *
1289      * Emits a {Transfer} event.
1290      */
1291     function safeTransferFrom(
1292         address from,
1293         address to,
1294         uint256 tokenId
1295     ) external;
1296 
1297     /**
1298      * @dev Transfers `tokenId` token from `from` to `to`.
1299      *
1300      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1301      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1302      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1303      *
1304      * Requirements:
1305      *
1306      * - `from` cannot be the zero address.
1307      * - `to` cannot be the zero address.
1308      * - `tokenId` token must be owned by `from`.
1309      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1310      *
1311      * Emits a {Transfer} event.
1312      */
1313     function transferFrom(
1314         address from,
1315         address to,
1316         uint256 tokenId
1317     ) external;
1318 
1319     /**
1320      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1321      * The approval is cleared when the token is transferred.
1322      *
1323      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1324      *
1325      * Requirements:
1326      *
1327      * - The caller must own the token or be an approved operator.
1328      * - `tokenId` must exist.
1329      *
1330      * Emits an {Approval} event.
1331      */
1332     function approve(address to, uint256 tokenId) external;
1333 
1334     /**
1335      * @dev Approve or remove `operator` as an operator for the caller.
1336      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1337      *
1338      * Requirements:
1339      *
1340      * - The `operator` cannot be the caller.
1341      *
1342      * Emits an {ApprovalForAll} event.
1343      */
1344     function setApprovalForAll(address operator, bool _approved) external;
1345 
1346     /**
1347      * @dev Returns the account approved for `tokenId` token.
1348      *
1349      * Requirements:
1350      *
1351      * - `tokenId` must exist.
1352      */
1353     function getApproved(uint256 tokenId) external view returns (address operator);
1354 
1355     /**
1356      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1357      *
1358      * See {setApprovalForAll}
1359      */
1360     function isApprovedForAll(address owner, address operator) external view returns (bool);
1361 }
1362 
1363 /**
1364  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1365  * @dev See https://eips.ethereum.org/EIPS/eip-721
1366  */
1367 interface IERC721Metadata is IERC721 {
1368     /**
1369      * @dev Returns the token collection name.
1370      */
1371     function name() external view returns (string memory);
1372 
1373     /**
1374      * @dev Returns the token collection symbol.
1375      */
1376     function symbol() external view returns (string memory);
1377 
1378     /**
1379      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1380      */
1381     function tokenURI(uint256 tokenId) external view returns (string memory);
1382 }
1383 
1384 /**
1385  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1386  * @dev See https://eips.ethereum.org/EIPS/eip-721
1387  */
1388 interface IERC721Enumerable is IERC721 {
1389     /**
1390      * @dev Returns the total amount of tokens stored by the contract.
1391      */
1392     function totalSupply() external view returns (uint256);
1393 
1394     /**
1395      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1396      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1397      */
1398     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1399 
1400     /**
1401      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1402      * Use along with {totalSupply} to enumerate all tokens.
1403      */
1404     function tokenByIndex(uint256 index) external view returns (uint256);
1405 }
1406 
1407 /**
1408  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1409  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1410  * {ERC721Enumerable}.
1411  */
1412 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1413     using Address for address;
1414     using Strings for uint256;
1415 
1416     // Token name
1417     string private _name;
1418 
1419     // Token symbol
1420     string private _symbol;
1421 
1422     // Mapping from token ID to owner address
1423     mapping(uint256 => address) private _owners;
1424 
1425     // Mapping owner address to token count
1426     mapping(address => uint256) private _balances;
1427 
1428     // Mapping from token ID to approved address
1429     mapping(uint256 => address) private _tokenApprovals;
1430 
1431     // Mapping from owner to operator approvals
1432     mapping(address => mapping(address => bool)) private _operatorApprovals;
1433 
1434     /**
1435      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1436      */
1437     constructor(string memory name_, string memory symbol_) {
1438         _name = name_;
1439         _symbol = symbol_;
1440     }
1441 
1442     /**
1443      * @dev See {IERC165-supportsInterface}.
1444      */
1445     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1446         return
1447             interfaceId == type(IERC721).interfaceId ||
1448             interfaceId == type(IERC721Metadata).interfaceId ||
1449             super.supportsInterface(interfaceId);
1450     }
1451 
1452     /**
1453      * @dev See {IERC721-balanceOf}.
1454      */
1455     function balanceOf(address owner) public view virtual override returns (uint256) {
1456         require(owner != address(0), "ERC721: address zero is not a valid owner");
1457         return _balances[owner];
1458     }
1459 
1460     /**
1461      * @dev See {IERC721-ownerOf}.
1462      */
1463     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1464         address owner = _ownerOf(tokenId);
1465         require(owner != address(0), "ERC721: invalid token ID");
1466         return owner;
1467     }
1468 
1469     /**
1470      * @dev See {IERC721Metadata-name}.
1471      */
1472     function name() public view virtual override returns (string memory) {
1473         return _name;
1474     }
1475 
1476     /**
1477      * @dev See {IERC721Metadata-symbol}.
1478      */
1479     function symbol() public view virtual override returns (string memory) {
1480         return _symbol;
1481     }
1482 
1483     /**
1484      * @dev See {IERC721Metadata-tokenURI}.
1485      */
1486     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1487         _requireMinted(tokenId);
1488 
1489         string memory baseURI = _baseURI();
1490         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1491     }
1492 
1493     /**
1494      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1495      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1496      * by default, can be overridden in child contracts.
1497      */
1498     function _baseURI() internal view virtual returns (string memory) {
1499         return "";
1500     }
1501 
1502     /**
1503      * @dev See {IERC721-approve}.
1504      */
1505     function approve(address to, uint256 tokenId) public virtual override {
1506         address owner = ERC721.ownerOf(tokenId);
1507         require(to != owner, "ERC721: approval to current owner");
1508 
1509         require(
1510             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1511             "ERC721: approve caller is not token owner or approved for all"
1512         );
1513 
1514         _approve(to, tokenId);
1515     }
1516 
1517     /**
1518      * @dev See {IERC721-getApproved}.
1519      */
1520     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1521         _requireMinted(tokenId);
1522 
1523         return _tokenApprovals[tokenId];
1524     }
1525 
1526     /**
1527      * @dev See {IERC721-setApprovalForAll}.
1528      */
1529     function setApprovalForAll(address operator, bool approved) public virtual override {
1530         _setApprovalForAll(_msgSender(), operator, approved);
1531     }
1532 
1533     /**
1534      * @dev See {IERC721-isApprovedForAll}.
1535      */
1536     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1537         return _operatorApprovals[owner][operator];
1538     }
1539 
1540     /**
1541      * @dev See {IERC721-transferFrom}.
1542      */
1543     function transferFrom(
1544         address from,
1545         address to,
1546         uint256 tokenId
1547     ) public virtual override {
1548         //solhint-disable-next-line max-line-length
1549         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1550 
1551         _transfer(from, to, tokenId);
1552     }
1553 
1554     /**
1555      * @dev See {IERC721-safeTransferFrom}.
1556      */
1557     function safeTransferFrom(
1558         address from,
1559         address to,
1560         uint256 tokenId
1561     ) public virtual override {
1562         safeTransferFrom(from, to, tokenId, "");
1563     }
1564 
1565     /**
1566      * @dev See {IERC721-safeTransferFrom}.
1567      */
1568     function safeTransferFrom(
1569         address from,
1570         address to,
1571         uint256 tokenId,
1572         bytes memory data
1573     ) public virtual override {
1574         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1575         _safeTransfer(from, to, tokenId, data);
1576     }
1577 
1578     /**
1579      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1580      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1581      *
1582      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1583      *
1584      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1585      * implement alternative mechanisms to perform token transfer, such as signature-based.
1586      *
1587      * Requirements:
1588      *
1589      * - `from` cannot be the zero address.
1590      * - `to` cannot be the zero address.
1591      * - `tokenId` token must exist and be owned by `from`.
1592      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1593      *
1594      * Emits a {Transfer} event.
1595      */
1596     function _safeTransfer(
1597         address from,
1598         address to,
1599         uint256 tokenId,
1600         bytes memory data
1601     ) internal virtual {
1602         _transfer(from, to, tokenId);
1603         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1604     }
1605 
1606     /**
1607      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1608      */
1609     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1610         return _owners[tokenId];
1611     }
1612 
1613     /**
1614      * @dev Returns whether `tokenId` exists.
1615      *
1616      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1617      *
1618      * Tokens start existing when they are minted (`_mint`),
1619      * and stop existing when they are burned (`_burn`).
1620      */
1621     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1622         return _ownerOf(tokenId) != address(0);
1623     }
1624 
1625     /**
1626      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1627      *
1628      * Requirements:
1629      *
1630      * - `tokenId` must exist.
1631      */
1632     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1633         address owner = ERC721.ownerOf(tokenId);
1634         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1635     }
1636 
1637     /**
1638      * @dev Safely mints `tokenId` and transfers it to `to`.
1639      *
1640      * Requirements:
1641      *
1642      * - `tokenId` must not exist.
1643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1644      *
1645      * Emits a {Transfer} event.
1646      */
1647     function _safeMint(address to, uint256 tokenId) internal virtual {
1648         _safeMint(to, tokenId, "");
1649     }
1650 
1651     /**
1652      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1653      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1654      */
1655     function _safeMint(
1656         address to,
1657         uint256 tokenId,
1658         bytes memory data
1659     ) internal virtual {
1660         _mint(to, tokenId);
1661         require(
1662             _checkOnERC721Received(address(0), to, tokenId, data),
1663             "ERC721: transfer to non ERC721Receiver implementer"
1664         );
1665     }
1666 
1667     /**
1668      * @dev Mints `tokenId` and transfers it to `to`.
1669      *
1670      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1671      *
1672      * Requirements:
1673      *
1674      * - `tokenId` must not exist.
1675      * - `to` cannot be the zero address.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _mint(address to, uint256 tokenId) internal virtual {
1680         require(to != address(0), "ERC721: mint to the zero address");
1681         require(!_exists(tokenId), "ERC721: token already minted");
1682 
1683         _beforeTokenTransfer(address(0), to, tokenId, 1);
1684 
1685         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1686         require(!_exists(tokenId), "ERC721: token already minted");
1687 
1688         unchecked {
1689             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1690             // Given that tokens are minted one by one, it is impossible in practice that
1691             // this ever happens. Might change if we allow batch minting.
1692             // The ERC fails to describe this case.
1693             _balances[to] += 1;
1694         }
1695 
1696         _owners[tokenId] = to;
1697 
1698         emit Transfer(address(0), to, tokenId);
1699 
1700         _afterTokenTransfer(address(0), to, tokenId, 1);
1701     }
1702 
1703     /**
1704      * @dev Destroys `tokenId`.
1705      * The approval is cleared when the token is burned.
1706      * This is an internal function that does not check if the sender is authorized to operate on the token.
1707      *
1708      * Requirements:
1709      *
1710      * - `tokenId` must exist.
1711      *
1712      * Emits a {Transfer} event.
1713      */
1714     function _burn(uint256 tokenId) internal virtual {
1715         address owner = ERC721.ownerOf(tokenId);
1716 
1717         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1718 
1719         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1720         owner = ERC721.ownerOf(tokenId);
1721 
1722         // Clear approvals
1723         delete _tokenApprovals[tokenId];
1724 
1725         unchecked {
1726             // Cannot overflow, as that would require more tokens to be burned/transferred
1727             // out than the owner initially received through minting and transferring in.
1728             _balances[owner] -= 1;
1729         }
1730         delete _owners[tokenId];
1731 
1732         emit Transfer(owner, address(0), tokenId);
1733 
1734         _afterTokenTransfer(owner, address(0), tokenId, 1);
1735     }
1736 
1737     /**
1738      * @dev Transfers `tokenId` from `from` to `to`.
1739      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1740      *
1741      * Requirements:
1742      *
1743      * - `to` cannot be the zero address.
1744      * - `tokenId` token must be owned by `from`.
1745      *
1746      * Emits a {Transfer} event.
1747      */
1748     function _transfer(
1749         address from,
1750         address to,
1751         uint256 tokenId
1752     ) internal virtual {
1753         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1754         require(to != address(0), "ERC721: transfer to the zero address");
1755 
1756         _beforeTokenTransfer(from, to, tokenId, 1);
1757 
1758         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1759         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1760 
1761         // Clear approvals from the previous owner
1762         delete _tokenApprovals[tokenId];
1763 
1764         unchecked {
1765             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1766             // `from`'s balance is the number of token held, which is at least one before the current
1767             // transfer.
1768             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1769             // all 2**256 token ids to be minted, which in practice is impossible.
1770             _balances[from] -= 1;
1771             _balances[to] += 1;
1772         }
1773         _owners[tokenId] = to;
1774 
1775         emit Transfer(from, to, tokenId);
1776 
1777         _afterTokenTransfer(from, to, tokenId, 1);
1778     }
1779 
1780     /**
1781      * @dev Approve `to` to operate on `tokenId`
1782      *
1783      * Emits an {Approval} event.
1784      */
1785     function _approve(address to, uint256 tokenId) internal virtual {
1786         _tokenApprovals[tokenId] = to;
1787         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1788     }
1789 
1790     /**
1791      * @dev Approve `operator` to operate on all of `owner` tokens
1792      *
1793      * Emits an {ApprovalForAll} event.
1794      */
1795     function _setApprovalForAll(
1796         address owner,
1797         address operator,
1798         bool approved
1799     ) internal virtual {
1800         require(owner != operator, "ERC721: approve to caller");
1801         _operatorApprovals[owner][operator] = approved;
1802         emit ApprovalForAll(owner, operator, approved);
1803     }
1804 
1805     /**
1806      * @dev Reverts if the `tokenId` has not been minted yet.
1807      */
1808     function _requireMinted(uint256 tokenId) internal view virtual {
1809         require(_exists(tokenId), "ERC721: invalid token ID");
1810     }
1811 
1812     /**
1813      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1814      * The call is not executed if the target address is not a contract.
1815      *
1816      * @param from address representing the previous owner of the given token ID
1817      * @param to target address that will receive the tokens
1818      * @param tokenId uint256 ID of the token to be transferred
1819      * @param data bytes optional data to send along with the call
1820      * @return bool whether the call correctly returned the expected magic value
1821      */
1822     function _checkOnERC721Received(
1823         address from,
1824         address to,
1825         uint256 tokenId,
1826         bytes memory data
1827     ) private returns (bool) {
1828         if (to.isContract()) {
1829             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1830                 return retval == IERC721Receiver.onERC721Received.selector;
1831             } catch (bytes memory reason) {
1832                 if (reason.length == 0) {
1833                     revert("ERC721: transfer to non ERC721Receiver implementer");
1834                 } else {
1835                     /// @solidity memory-safe-assembly
1836                     assembly {
1837                         revert(add(32, reason), mload(reason))
1838                     }
1839                 }
1840             }
1841         } else {
1842             return true;
1843         }
1844     }
1845 
1846     /**
1847      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1848      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1849      *
1850      * Calling conditions:
1851      *
1852      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1853      * - When `from` is zero, the tokens will be minted for `to`.
1854      * - When `to` is zero, ``from``'s tokens will be burned.
1855      * - `from` and `to` are never both zero.
1856      * - `batchSize` is non-zero.
1857      *
1858      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1859      */
1860     function _beforeTokenTransfer(
1861         address from,
1862         address to,
1863         uint256, /* firstTokenId */
1864         uint256 batchSize
1865     ) internal virtual {
1866         if (batchSize > 1) {
1867             if (from != address(0)) {
1868                 _balances[from] -= batchSize;
1869             }
1870             if (to != address(0)) {
1871                 _balances[to] += batchSize;
1872             }
1873         }
1874     }
1875 
1876     /**
1877      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1878      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1879      *
1880      * Calling conditions:
1881      *
1882      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1883      * - When `from` is zero, the tokens were minted for `to`.
1884      * - When `to` is zero, ``from``'s tokens were burned.
1885      * - `from` and `to` are never both zero.
1886      * - `batchSize` is non-zero.
1887      *
1888      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1889      */
1890     function _afterTokenTransfer(
1891         address from,
1892         address to,
1893         uint256 firstTokenId,
1894         uint256 batchSize
1895     ) internal virtual {}
1896 }
1897 
1898 /**
1899  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1900  *
1901  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1902  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1903  *
1904  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1905  * fee is specified in basis points by default.
1906  *
1907  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1908  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1909  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1910  *
1911  * _Available since v4.5._
1912  */
1913 abstract contract ERC2981 is IERC2981, ERC165 {
1914     struct RoyaltyInfo {
1915         address receiver;
1916         uint96 royaltyFraction;
1917     }
1918 
1919     RoyaltyInfo private _defaultRoyaltyInfo;
1920     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1921 
1922     /**
1923      * @dev See {IERC165-supportsInterface}.
1924      */
1925     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1926         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1927     }
1928 
1929     /**
1930      * @inheritdoc IERC2981
1931      */
1932     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
1933         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
1934 
1935         if (royalty.receiver == address(0)) {
1936             royalty = _defaultRoyaltyInfo;
1937         }
1938 
1939         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
1940 
1941         return (royalty.receiver, royaltyAmount);
1942     }
1943 
1944     /**
1945      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1946      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1947      * override.
1948      */
1949     function _feeDenominator() internal pure virtual returns (uint96) {
1950         return 10000;
1951     }
1952 
1953     /**
1954      * @dev Sets the royalty information that all ids in this contract will default to.
1955      *
1956      * Requirements:
1957      *
1958      * - `receiver` cannot be the zero address.
1959      * - `feeNumerator` cannot be greater than the fee denominator.
1960      */
1961     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1962         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1963         require(receiver != address(0), "ERC2981: invalid receiver");
1964 
1965         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1966     }
1967 
1968     /**
1969      * @dev Removes default royalty information.
1970      */
1971     function _deleteDefaultRoyalty() internal virtual {
1972         delete _defaultRoyaltyInfo;
1973     }
1974 
1975     /**
1976      * @dev Sets the royalty information for a specific token id, overriding the global default.
1977      *
1978      * Requirements:
1979      *
1980      * - `receiver` cannot be the zero address.
1981      * - `feeNumerator` cannot be greater than the fee denominator.
1982      */
1983     function _setTokenRoyalty(
1984         uint256 tokenId,
1985         address receiver,
1986         uint96 feeNumerator
1987     ) internal virtual {
1988         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1989         require(receiver != address(0), "ERC2981: Invalid parameters");
1990 
1991         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1992     }
1993 
1994     /**
1995      * @dev Resets royalty information for the token id back to the global default.
1996      */
1997     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1998         delete _tokenRoyaltyInfo[tokenId];
1999     }
2000 }
2001 
2002 /**
2003  * @dev Interface of ERC721 token receiver.
2004  */
2005 interface ERC721A__IERC721Receiver {
2006     function onERC721Received(
2007         address operator,
2008         address from,
2009         uint256 tokenId,
2010         bytes calldata data
2011     ) external returns (bytes4);
2012 }
2013 
2014 /**
2015  * @title ERC721A
2016  *
2017  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
2018  * Non-Fungible Token Standard, including the Metadata extension.
2019  * Optimized for lower gas during batch mints.
2020  *
2021  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
2022  * starting from `_startTokenId()`.
2023  *
2024  * Assumptions:
2025  *
2026  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
2027  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
2028  */
2029 contract ERC721A is IERC721A {
2030     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
2031     struct TokenApprovalRef {
2032         address value;
2033     }
2034 
2035     // =============================================================
2036     //                           CONSTANTS
2037     // =============================================================
2038 
2039     // Mask of an entry in packed address data.
2040     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
2041 
2042     // The bit position of `numberMinted` in packed address data.
2043     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
2044 
2045     // The bit position of `numberBurned` in packed address data.
2046     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
2047 
2048     // The bit position of `aux` in packed address data.
2049     uint256 private constant _BITPOS_AUX = 192;
2050 
2051     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2052     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2053 
2054     // The bit position of `startTimestamp` in packed ownership.
2055     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2056 
2057     // The bit mask of the `burned` bit in packed ownership.
2058     uint256 private constant _BITMASK_BURNED = 1 << 224;
2059 
2060     // The bit position of the `nextInitialized` bit in packed ownership.
2061     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2062 
2063     // The bit mask of the `nextInitialized` bit in packed ownership.
2064     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2065 
2066     // The bit position of `extraData` in packed ownership.
2067     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2068 
2069     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2070     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2071 
2072     // The mask of the lower 160 bits for addresses.
2073     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2074 
2075     // The maximum `quantity` that can be minted with {_mintERC2309}.
2076     // This limit is to prevent overflows on the address data entries.
2077     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2078     // is required to cause an overflow, which is unrealistic.
2079     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2080 
2081     // The `Transfer` event signature is given by:
2082     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2083     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2084         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2085 
2086     // =============================================================
2087     //                            STORAGE
2088     // =============================================================
2089 
2090     // The next token ID to be minted.
2091     uint256 private _currentIndex;
2092 
2093     // The number of tokens burned.
2094     uint256 private _burnCounter;
2095 
2096     // Token name
2097     string private _name;
2098 
2099     // Token symbol
2100     string private _symbol;
2101 
2102     // Mapping from token ID to ownership details
2103     // An empty struct value does not necessarily mean the token is unowned.
2104     // See {_packedOwnershipOf} implementation for details.
2105     //
2106     // Bits Layout:
2107     // - [0..159]   `addr`
2108     // - [160..223] `startTimestamp`
2109     // - [224]      `burned`
2110     // - [225]      `nextInitialized`
2111     // - [232..255] `extraData`
2112     mapping(uint256 => uint256) private _packedOwnerships;
2113 
2114     // Mapping owner address to address data.
2115     //
2116     // Bits Layout:
2117     // - [0..63]    `balance`
2118     // - [64..127]  `numberMinted`
2119     // - [128..191] `numberBurned`
2120     // - [192..255] `aux`
2121     mapping(address => uint256) private _packedAddressData;
2122 
2123     // Mapping from token ID to approved address.
2124     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2125 
2126     // Mapping from owner to operator approvals
2127     mapping(address => mapping(address => bool)) private _operatorApprovals;
2128 
2129     // =============================================================
2130     //                          CONSTRUCTOR
2131     // =============================================================
2132 
2133     constructor(string memory name_, string memory symbol_) {
2134         _name = name_;
2135         _symbol = symbol_;
2136         _currentIndex = _startTokenId();
2137     }
2138 
2139     // =============================================================
2140     //                   TOKEN COUNTING OPERATIONS
2141     // =============================================================
2142 
2143     /**
2144      * @dev Returns the starting token ID.
2145      * To change the starting token ID, please override this function.
2146      */
2147     function _startTokenId() internal view virtual returns (uint256) {
2148         return 0;
2149     }
2150 
2151     /**
2152      * @dev Returns the next token ID to be minted.
2153      */
2154     function _nextTokenId() internal view virtual returns (uint256) {
2155         return _currentIndex;
2156     }
2157 
2158     /**
2159      * @dev Returns the total number of tokens in existence.
2160      * Burned tokens will reduce the count.
2161      * To get the total number of tokens minted, please see {_totalMinted}.
2162      */
2163     function totalSupply() public view virtual override returns (uint256) {
2164         // Counter underflow is impossible as _burnCounter cannot be incremented
2165         // more than `_currentIndex - _startTokenId()` times.
2166         unchecked {
2167             return _currentIndex - _burnCounter - _startTokenId();
2168         }
2169     }
2170 
2171     /**
2172      * @dev Returns the total amount of tokens minted in the contract.
2173      */
2174     function _totalMinted() internal view virtual returns (uint256) {
2175         // Counter underflow is impossible as `_currentIndex` does not decrement,
2176         // and it is initialized to `_startTokenId()`.
2177         unchecked {
2178             return _currentIndex - _startTokenId();
2179         }
2180     }
2181 
2182     /**
2183      * @dev Returns the total number of tokens burned.
2184      */
2185     function _totalBurned() internal view virtual returns (uint256) {
2186         return _burnCounter;
2187     }
2188 
2189     // =============================================================
2190     //                    ADDRESS DATA OPERATIONS
2191     // =============================================================
2192 
2193     /**
2194      * @dev Returns the number of tokens in `owner`'s account.
2195      */
2196     function balanceOf(address owner) public view virtual override returns (uint256) {
2197         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2198         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2199     }
2200 
2201     /**
2202      * Returns the number of tokens minted by `owner`.
2203      */
2204     function _numberMinted(address owner) internal view returns (uint256) {
2205         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2206     }
2207 
2208     /**
2209      * Returns the number of tokens burned by or on behalf of `owner`.
2210      */
2211     function _numberBurned(address owner) internal view returns (uint256) {
2212         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2213     }
2214 
2215     /**
2216      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2217      */
2218     function _getAux(address owner) internal view returns (uint64) {
2219         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2220     }
2221 
2222     /**
2223      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2224      * If there are multiple variables, please pack them into a uint64.
2225      */
2226     function _setAux(address owner, uint64 aux) internal virtual {
2227         uint256 packed = _packedAddressData[owner];
2228         uint256 auxCasted;
2229         // Cast `aux` with assembly to avoid redundant masking.
2230         assembly {
2231             auxCasted := aux
2232         }
2233         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2234         _packedAddressData[owner] = packed;
2235     }
2236 
2237     // =============================================================
2238     //                            IERC165
2239     // =============================================================
2240 
2241     /**
2242      * @dev Returns true if this contract implements the interface defined by
2243      * `interfaceId`. See the corresponding
2244      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2245      * to learn more about how these ids are created.
2246      *
2247      * This function call must use less than 30000 gas.
2248      */
2249     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2250         // The interface IDs are constants representing the first 4 bytes
2251         // of the XOR of all function selectors in the interface.
2252         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2253         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2254         return
2255             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2256             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2257             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2258     }
2259 
2260     // =============================================================
2261     //                        IERC721Metadata
2262     // =============================================================
2263 
2264     /**
2265      * @dev Returns the token collection name.
2266      */
2267     function name() public view virtual override returns (string memory) {
2268         return _name;
2269     }
2270 
2271     /**
2272      * @dev Returns the token collection symbol.
2273      */
2274     function symbol() public view virtual override returns (string memory) {
2275         return _symbol;
2276     }
2277 
2278     /**
2279      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2280      */
2281     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2282         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2283 
2284         string memory baseURI = _baseURI();
2285         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2286     }
2287 
2288     /**
2289      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2290      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2291      * by default, it can be overridden in child contracts.
2292      */
2293     function _baseURI() internal view virtual returns (string memory) {
2294         return '';
2295     }
2296 
2297     // =============================================================
2298     //                     OWNERSHIPS OPERATIONS
2299     // =============================================================
2300 
2301     /**
2302      * @dev Returns the owner of the `tokenId` token.
2303      *
2304      * Requirements:
2305      *
2306      * - `tokenId` must exist.
2307      */
2308     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2309         return address(uint160(_packedOwnershipOf(tokenId)));
2310     }
2311 
2312     /**
2313      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2314      * It gradually moves to O(1) as tokens get transferred around over time.
2315      */
2316     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2317         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2318     }
2319 
2320     /**
2321      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2322      */
2323     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2324         return _unpackedOwnership(_packedOwnerships[index]);
2325     }
2326 
2327     /**
2328      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2329      */
2330     function _initializeOwnershipAt(uint256 index) internal virtual {
2331         if (_packedOwnerships[index] == 0) {
2332             _packedOwnerships[index] = _packedOwnershipOf(index);
2333         }
2334     }
2335 
2336     /**
2337      * Returns the packed ownership data of `tokenId`.
2338      */
2339     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2340         uint256 curr = tokenId;
2341 
2342         unchecked {
2343             if (_startTokenId() <= curr)
2344                 if (curr < _currentIndex) {
2345                     uint256 packed = _packedOwnerships[curr];
2346                     // If not burned.
2347                     if (packed & _BITMASK_BURNED == 0) {
2348                         // Invariant:
2349                         // There will always be an initialized ownership slot
2350                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2351                         // before an unintialized ownership slot
2352                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2353                         // Hence, `curr` will not underflow.
2354                         //
2355                         // We can directly compare the packed value.
2356                         // If the address is zero, packed will be zero.
2357                         while (packed == 0) {
2358                             packed = _packedOwnerships[--curr];
2359                         }
2360                         return packed;
2361                     }
2362                 }
2363         }
2364         revert OwnerQueryForNonexistentToken();
2365     }
2366 
2367     /**
2368      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2369      */
2370     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2371         ownership.addr = address(uint160(packed));
2372         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2373         ownership.burned = packed & _BITMASK_BURNED != 0;
2374         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2375     }
2376 
2377     /**
2378      * @dev Packs ownership data into a single uint256.
2379      */
2380     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2381         assembly {
2382             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2383             owner := and(owner, _BITMASK_ADDRESS)
2384             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2385             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2386         }
2387     }
2388 
2389     /**
2390      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2391      */
2392     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2393         // For branchless setting of the `nextInitialized` flag.
2394         assembly {
2395             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2396             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2397         }
2398     }
2399 
2400     // =============================================================
2401     //                      APPROVAL OPERATIONS
2402     // =============================================================
2403 
2404     /**
2405      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
2406      *
2407      * Requirements:
2408      *
2409      * - The caller must own the token or be an approved operator.
2410      */
2411     function approve(address to, uint256 tokenId) public payable virtual override {
2412         _approve(to, tokenId, true);
2413     }
2414 
2415     /**
2416      * @dev Returns the account approved for `tokenId` token.
2417      *
2418      * Requirements:
2419      *
2420      * - `tokenId` must exist.
2421      */
2422     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2423         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2424 
2425         return _tokenApprovals[tokenId].value;
2426     }
2427 
2428     /**
2429      * @dev Approve or remove `operator` as an operator for the caller.
2430      * Operators can call {transferFrom} or {safeTransferFrom}
2431      * for any token owned by the caller.
2432      *
2433      * Requirements:
2434      *
2435      * - The `operator` cannot be the caller.
2436      *
2437      * Emits an {ApprovalForAll} event.
2438      */
2439     function setApprovalForAll(address operator, bool approved) public virtual override {
2440         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2441         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2442     }
2443 
2444     /**
2445      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2446      *
2447      * See {setApprovalForAll}.
2448      */
2449     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2450         return _operatorApprovals[owner][operator];
2451     }
2452 
2453     /**
2454      * @dev Returns whether `tokenId` exists.
2455      *
2456      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2457      *
2458      * Tokens start existing when they are minted. See {_mint}.
2459      */
2460     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2461         return
2462             _startTokenId() <= tokenId &&
2463             tokenId < _currentIndex && // If within bounds,
2464             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2465     }
2466 
2467     /**
2468      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2469      */
2470     function _isSenderApprovedOrOwner(
2471         address approvedAddress,
2472         address owner,
2473         address msgSender
2474     ) private pure returns (bool result) {
2475         assembly {
2476             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2477             owner := and(owner, _BITMASK_ADDRESS)
2478             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2479             msgSender := and(msgSender, _BITMASK_ADDRESS)
2480             // `msgSender == owner || msgSender == approvedAddress`.
2481             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2482         }
2483     }
2484 
2485     /**
2486      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2487      */
2488     function _getApprovedSlotAndAddress(uint256 tokenId)
2489         private
2490         view
2491         returns (uint256 approvedAddressSlot, address approvedAddress)
2492     {
2493         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2494         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2495         assembly {
2496             approvedAddressSlot := tokenApproval.slot
2497             approvedAddress := sload(approvedAddressSlot)
2498         }
2499     }
2500 
2501     // =============================================================
2502     //                      TRANSFER OPERATIONS
2503     // =============================================================
2504 
2505     /**
2506      * @dev Transfers `tokenId` from `from` to `to`.
2507      *
2508      * Requirements:
2509      *
2510      * - `from` cannot be the zero address.
2511      * - `to` cannot be the zero address.
2512      * - `tokenId` token must be owned by `from`.
2513      * - If the caller is not `from`, it must be approved to move this token
2514      * by either {approve} or {setApprovalForAll}.
2515      *
2516      * Emits a {Transfer} event.
2517      */
2518     function transferFrom(
2519         address from,
2520         address to,
2521         uint256 tokenId
2522     ) public payable virtual override {
2523         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2524 
2525         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2526 
2527         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2528 
2529         // The nested ifs save around 20+ gas over a compound boolean condition.
2530         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2531             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2532 
2533         if (to == address(0)) revert TransferToZeroAddress();
2534 
2535         _beforeTokenTransfers(from, to, tokenId, 1);
2536 
2537         // Clear approvals from the previous owner.
2538         assembly {
2539             if approvedAddress {
2540                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2541                 sstore(approvedAddressSlot, 0)
2542             }
2543         }
2544 
2545         // Underflow of the sender's balance is impossible because we check for
2546         // ownership above and the recipient's balance can't realistically overflow.
2547         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2548         unchecked {
2549             // We can directly increment and decrement the balances.
2550             --_packedAddressData[from]; // Updates: `balance -= 1`.
2551             ++_packedAddressData[to]; // Updates: `balance += 1`.
2552 
2553             // Updates:
2554             // - `address` to the next owner.
2555             // - `startTimestamp` to the timestamp of transfering.
2556             // - `burned` to `false`.
2557             // - `nextInitialized` to `true`.
2558             _packedOwnerships[tokenId] = _packOwnershipData(
2559                 to,
2560                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2561             );
2562 
2563             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2564             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2565                 uint256 nextTokenId = tokenId + 1;
2566                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2567                 if (_packedOwnerships[nextTokenId] == 0) {
2568                     // If the next slot is within bounds.
2569                     if (nextTokenId != _currentIndex) {
2570                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2571                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2572                     }
2573                 }
2574             }
2575         }
2576 
2577         emit Transfer(from, to, tokenId);
2578         _afterTokenTransfers(from, to, tokenId, 1);
2579     }
2580 
2581     /**
2582      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2583      */
2584     function safeTransferFrom(
2585         address from,
2586         address to,
2587         uint256 tokenId
2588     ) public payable virtual override {
2589         safeTransferFrom(from, to, tokenId, '');
2590     }
2591 
2592     /**
2593      * @dev Safely transfers `tokenId` token from `from` to `to`.
2594      *
2595      * Requirements:
2596      *
2597      * - `from` cannot be the zero address.
2598      * - `to` cannot be the zero address.
2599      * - `tokenId` token must exist and be owned by `from`.
2600      * - If the caller is not `from`, it must be approved to move this token
2601      * by either {approve} or {setApprovalForAll}.
2602      * - If `to` refers to a smart contract, it must implement
2603      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2604      *
2605      * Emits a {Transfer} event.
2606      */
2607     function safeTransferFrom(
2608         address from,
2609         address to,
2610         uint256 tokenId,
2611         bytes memory _data
2612     ) public payable virtual override {
2613         transferFrom(from, to, tokenId);
2614         if (to.code.length != 0)
2615             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2616                 revert TransferToNonERC721ReceiverImplementer();
2617             }
2618     }
2619 
2620     /**
2621      * @dev Hook that is called before a set of serially-ordered token IDs
2622      * are about to be transferred. This includes minting.
2623      * And also called before burning one token.
2624      *
2625      * `startTokenId` - the first token ID to be transferred.
2626      * `quantity` - the amount to be transferred.
2627      *
2628      * Calling conditions:
2629      *
2630      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2631      * transferred to `to`.
2632      * - When `from` is zero, `tokenId` will be minted for `to`.
2633      * - When `to` is zero, `tokenId` will be burned by `from`.
2634      * - `from` and `to` are never both zero.
2635      */
2636     function _beforeTokenTransfers(
2637         address from,
2638         address to,
2639         uint256 startTokenId,
2640         uint256 quantity
2641     ) internal virtual {}
2642 
2643     /**
2644      * @dev Hook that is called after a set of serially-ordered token IDs
2645      * have been transferred. This includes minting.
2646      * And also called after one token has been burned.
2647      *
2648      * `startTokenId` - the first token ID to be transferred.
2649      * `quantity` - the amount to be transferred.
2650      *
2651      * Calling conditions:
2652      *
2653      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2654      * transferred to `to`.
2655      * - When `from` is zero, `tokenId` has been minted for `to`.
2656      * - When `to` is zero, `tokenId` has been burned by `from`.
2657      * - `from` and `to` are never both zero.
2658      */
2659     function _afterTokenTransfers(
2660         address from,
2661         address to,
2662         uint256 startTokenId,
2663         uint256 quantity
2664     ) internal virtual {}
2665 
2666     /**
2667      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2668      *
2669      * `from` - Previous owner of the given token ID.
2670      * `to` - Target address that will receive the token.
2671      * `tokenId` - Token ID to be transferred.
2672      * `_data` - Optional data to send along with the call.
2673      *
2674      * Returns whether the call correctly returned the expected magic value.
2675      */
2676     function _checkContractOnERC721Received(
2677         address from,
2678         address to,
2679         uint256 tokenId,
2680         bytes memory _data
2681     ) private returns (bool) {
2682         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2683             bytes4 retval
2684         ) {
2685             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2686         } catch (bytes memory reason) {
2687             if (reason.length == 0) {
2688                 revert TransferToNonERC721ReceiverImplementer();
2689             } else {
2690                 assembly {
2691                     revert(add(32, reason), mload(reason))
2692                 }
2693             }
2694         }
2695     }
2696 
2697     // =============================================================
2698     //                        MINT OPERATIONS
2699     // =============================================================
2700 
2701     /**
2702      * @dev Mints `quantity` tokens and transfers them to `to`.
2703      *
2704      * Requirements:
2705      *
2706      * - `to` cannot be the zero address.
2707      * - `quantity` must be greater than 0.
2708      *
2709      * Emits a {Transfer} event for each mint.
2710      */
2711     function _mint(address to, uint256 quantity) internal virtual {
2712         uint256 startTokenId = _currentIndex;
2713         if (quantity == 0) revert MintZeroQuantity();
2714 
2715         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2716 
2717         // Overflows are incredibly unrealistic.
2718         // `balance` and `numberMinted` have a maximum limit of 2**64.
2719         // `tokenId` has a maximum limit of 2**256.
2720         unchecked {
2721             // Updates:
2722             // - `balance += quantity`.
2723             // - `numberMinted += quantity`.
2724             //
2725             // We can directly add to the `balance` and `numberMinted`.
2726             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2727 
2728             // Updates:
2729             // - `address` to the owner.
2730             // - `startTimestamp` to the timestamp of minting.
2731             // - `burned` to `false`.
2732             // - `nextInitialized` to `quantity == 1`.
2733             _packedOwnerships[startTokenId] = _packOwnershipData(
2734                 to,
2735                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2736             );
2737 
2738             uint256 toMasked;
2739             uint256 end = startTokenId + quantity;
2740 
2741             // Use assembly to loop and emit the `Transfer` event for gas savings.
2742             // The duplicated `log4` removes an extra check and reduces stack juggling.
2743             // The assembly, together with the surrounding Solidity code, have been
2744             // delicately arranged to nudge the compiler into producing optimized opcodes.
2745             assembly {
2746                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2747                 toMasked := and(to, _BITMASK_ADDRESS)
2748                 // Emit the `Transfer` event.
2749                 log4(
2750                     0, // Start of data (0, since no data).
2751                     0, // End of data (0, since no data).
2752                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2753                     0, // `address(0)`.
2754                     toMasked, // `to`.
2755                     startTokenId // `tokenId`.
2756                 )
2757 
2758                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2759                 // that overflows uint256 will make the loop run out of gas.
2760                 // The compiler will optimize the `iszero` away for performance.
2761                 for {
2762                     let tokenId := add(startTokenId, 1)
2763                 } iszero(eq(tokenId, end)) {
2764                     tokenId := add(tokenId, 1)
2765                 } {
2766                     // Emit the `Transfer` event. Similar to above.
2767                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2768                 }
2769             }
2770             if (toMasked == 0) revert MintToZeroAddress();
2771 
2772             _currentIndex = end;
2773         }
2774         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2775     }
2776 
2777     /**
2778      * @dev Mints `quantity` tokens and transfers them to `to`.
2779      *
2780      * This function is intended for efficient minting only during contract creation.
2781      *
2782      * It emits only one {ConsecutiveTransfer} as defined in
2783      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2784      * instead of a sequence of {Transfer} event(s).
2785      *
2786      * Calling this function outside of contract creation WILL make your contract
2787      * non-compliant with the ERC721 standard.
2788      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2789      * {ConsecutiveTransfer} event is only permissible during contract creation.
2790      *
2791      * Requirements:
2792      *
2793      * - `to` cannot be the zero address.
2794      * - `quantity` must be greater than 0.
2795      *
2796      * Emits a {ConsecutiveTransfer} event.
2797      */
2798     function _mintERC2309(address to, uint256 quantity) internal virtual {
2799         uint256 startTokenId = _currentIndex;
2800         if (to == address(0)) revert MintToZeroAddress();
2801         if (quantity == 0) revert MintZeroQuantity();
2802         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2803 
2804         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2805 
2806         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2807         unchecked {
2808             // Updates:
2809             // - `balance += quantity`.
2810             // - `numberMinted += quantity`.
2811             //
2812             // We can directly add to the `balance` and `numberMinted`.
2813             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2814 
2815             // Updates:
2816             // - `address` to the owner.
2817             // - `startTimestamp` to the timestamp of minting.
2818             // - `burned` to `false`.
2819             // - `nextInitialized` to `quantity == 1`.
2820             _packedOwnerships[startTokenId] = _packOwnershipData(
2821                 to,
2822                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2823             );
2824 
2825             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2826 
2827             _currentIndex = startTokenId + quantity;
2828         }
2829         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2830     }
2831 
2832     /**
2833      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2834      *
2835      * Requirements:
2836      *
2837      * - If `to` refers to a smart contract, it must implement
2838      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2839      * - `quantity` must be greater than 0.
2840      *
2841      * See {_mint}.
2842      *
2843      * Emits a {Transfer} event for each mint.
2844      */
2845     function _safeMint(
2846         address to,
2847         uint256 quantity,
2848         bytes memory _data
2849     ) internal virtual {
2850         _mint(to, quantity);
2851 
2852         unchecked {
2853             if (to.code.length != 0) {
2854                 uint256 end = _currentIndex;
2855                 uint256 index = end - quantity;
2856                 do {
2857                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2858                         revert TransferToNonERC721ReceiverImplementer();
2859                     }
2860                 } while (index < end);
2861                 // Reentrancy protection.
2862                 if (_currentIndex != end) revert();
2863             }
2864         }
2865     }
2866 
2867     /**
2868      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2869      */
2870     function _safeMint(address to, uint256 quantity) internal virtual {
2871         _safeMint(to, quantity, '');
2872     }
2873 
2874     // =============================================================
2875     //                       APPROVAL OPERATIONS
2876     // =============================================================
2877 
2878 
2879     /**
2880      * @dev Equivalent to `_approve(to, tokenId, false)`.
2881      */
2882     function _approve(address to, uint256 tokenId) internal virtual {
2883         _approve(to, tokenId, false);
2884     }
2885 
2886     /**
2887      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2888      * The approval is cleared when the token is transferred.
2889      *
2890      * Only a single account can be approved at a time, so approving the
2891      * zero address clears previous approvals.
2892      *
2893      * Requirements:
2894      *
2895      * - `tokenId` must exist.
2896      *
2897      * Emits an {Approval} event.
2898      */
2899     function _approve(address to, uint256 tokenId, bool approvalCheck) internal virtual {
2900         address owner = ownerOf(tokenId);
2901 
2902         if (approvalCheck && _msgSenderERC721A() != owner)
2903             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2904                 revert ApprovalCallerNotOwnerNorApproved();
2905             }
2906 
2907         _tokenApprovals[tokenId].value = to;
2908         emit Approval(owner, to, tokenId);
2909     }
2910 
2911     // =============================================================
2912     //                        BURN OPERATIONS
2913     // =============================================================
2914 
2915     /**
2916      * @dev Equivalent to `_burn(tokenId, false)`.
2917      */
2918     function _burn(uint256 tokenId) internal virtual {
2919         _burn(tokenId, false);
2920     }
2921 
2922     /**
2923      * @dev Destroys `tokenId`.
2924      * The approval is cleared when the token is burned.
2925      *
2926      * Requirements:
2927      *
2928      * - `tokenId` must exist.
2929      *
2930      * Emits a {Transfer} event.
2931      */
2932     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2933         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2934 
2935         address from = address(uint160(prevOwnershipPacked));
2936 
2937         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2938 
2939         if (approvalCheck) {
2940             // The nested ifs save around 20+ gas over a compound boolean condition.
2941             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2942                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2943         }
2944 
2945         _beforeTokenTransfers(from, address(0), tokenId, 1);
2946 
2947         // Clear approvals from the previous owner.
2948         assembly {
2949             if approvedAddress {
2950                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2951                 sstore(approvedAddressSlot, 0)
2952             }
2953         }
2954 
2955         // Underflow of the sender's balance is impossible because we check for
2956         // ownership above and the recipient's balance can't realistically overflow.
2957         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2958         unchecked {
2959             // Updates:
2960             // - `balance -= 1`.
2961             // - `numberBurned += 1`.
2962             //
2963             // We can directly decrement the balance, and increment the number burned.
2964             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2965             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2966 
2967             // Updates:
2968             // - `address` to the last owner.
2969             // - `startTimestamp` to the timestamp of burning.
2970             // - `burned` to `true`.
2971             // - `nextInitialized` to `true`.
2972             _packedOwnerships[tokenId] = _packOwnershipData(
2973                 from,
2974                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2975             );
2976 
2977             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2978             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2979                 uint256 nextTokenId = tokenId + 1;
2980                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2981                 if (_packedOwnerships[nextTokenId] == 0) {
2982                     // If the next slot is within bounds.
2983                     if (nextTokenId != _currentIndex) {
2984                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2985                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2986                     }
2987                 }
2988             }
2989         }
2990 
2991         emit Transfer(from, address(0), tokenId);
2992         _afterTokenTransfers(from, address(0), tokenId, 1);
2993 
2994         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2995         unchecked {
2996             _burnCounter++;
2997         }
2998     }
2999 
3000     // =============================================================
3001     //                     EXTRA DATA OPERATIONS
3002     // =============================================================
3003 
3004     /**
3005      * @dev Directly sets the extra data for the ownership data `index`.
3006      */
3007     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
3008         uint256 packed = _packedOwnerships[index];
3009         if (packed == 0) revert OwnershipNotInitializedForExtraData();
3010         uint256 extraDataCasted;
3011         // Cast `extraData` with assembly to avoid redundant masking.
3012         assembly {
3013             extraDataCasted := extraData
3014         }
3015         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
3016         _packedOwnerships[index] = packed;
3017     }
3018 
3019     /**
3020      * @dev Called during each token transfer to set the 24bit `extraData` field.
3021      * Intended to be overridden by the cosumer contract.
3022      *
3023      * `previousExtraData` - the value of `extraData` before transfer.
3024      *
3025      * Calling conditions:
3026      *
3027      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
3028      * transferred to `to`.
3029      * - When `from` is zero, `tokenId` will be minted for `to`.
3030      * - When `to` is zero, `tokenId` will be burned by `from`.
3031      * - `from` and `to` are never both zero.
3032      */
3033     function _extraData(
3034         address from,
3035         address to,
3036         uint24 previousExtraData
3037     ) internal view virtual returns (uint24) {}
3038 
3039     /**
3040      * @dev Returns the next extra data for the packed ownership data.
3041      * The returned result is shifted into position.
3042      */
3043     function _nextExtraData(
3044         address from,
3045         address to,
3046         uint256 prevOwnershipPacked
3047     ) private view returns (uint256) {
3048         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3049         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3050     }
3051 
3052     // =============================================================
3053     //                       OTHER OPERATIONS
3054     // =============================================================
3055 
3056     /**
3057      * @dev Returns the message sender (defaults to `msg.sender`).
3058      *
3059      * If you are writing GSN compatible contracts, you need to override this function.
3060      */
3061     function _msgSenderERC721A() internal view virtual returns (address) {
3062         return msg.sender;
3063     }
3064 
3065     /**
3066      * @dev Converts a uint256 to its ASCII string decimal representation.
3067      */
3068     function _toString(uint256 value) internal pure virtual returns (string memory str) {
3069         assembly {
3070             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
3071             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
3072             // We will need 1 word for the trailing zeros padding, 1 word for the length,
3073             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
3074             let m := add(mload(0x40), 0xa0)
3075             // Update the free memory pointer to allocate.
3076             mstore(0x40, m)
3077             // Assign the `str` to the end.
3078             str := sub(m, 0x20)
3079             // Zeroize the slot after the string.
3080             mstore(str, 0)
3081 
3082             // Cache the end of the memory to calculate the length later.
3083             let end := str
3084 
3085             // We write the string from rightmost digit to leftmost digit.
3086             // The following is essentially a do-while loop that also handles the zero case.
3087             // prettier-ignore
3088             for { let temp := value } 1 {} {
3089                 str := sub(str, 1)
3090                 // Write the character to the pointer.
3091                 // The ASCII index of the '0' character is 48.
3092                 mstore8(str, add(48, mod(temp, 10)))
3093                 // Keep dividing `temp` until zero.
3094                 temp := div(temp, 10)
3095                 // prettier-ignore
3096                 if iszero(temp) { break }
3097             }
3098 
3099             let length := sub(end, str)
3100             // Move the pointer 32 bytes leftwards to make room for the length.
3101             str := sub(str, 0x20)
3102             // Store the length.
3103             mstore(str, length)
3104         }
3105     }
3106 }
3107 
3108 /**
3109  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
3110  * enumerability of all the token ids in the contract as well as all token ids owned by each
3111  * account.
3112  */
3113 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
3114     // Mapping from owner to list of owned token IDs
3115     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
3116 
3117     // Mapping from token ID to index of the owner tokens list
3118     mapping(uint256 => uint256) private _ownedTokensIndex;
3119 
3120     // Array with all token ids, used for enumeration
3121     uint256[] private _allTokens;
3122 
3123     // Mapping from token id to position in the allTokens array
3124     mapping(uint256 => uint256) private _allTokensIndex;
3125 
3126     /**
3127      * @dev See {IERC165-supportsInterface}.
3128      */
3129     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
3130         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
3131     }
3132 
3133     /**
3134      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
3135      */
3136     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
3137         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
3138         return _ownedTokens[owner][index];
3139     }
3140 
3141     /**
3142      * @dev See {IERC721Enumerable-totalSupply}.
3143      */
3144     function totalSupply() public view virtual override returns (uint256) {
3145         return _allTokens.length;
3146     }
3147 
3148     /**
3149      * @dev See {IERC721Enumerable-tokenByIndex}.
3150      */
3151     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
3152         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
3153         return _allTokens[index];
3154     }
3155 
3156     /**
3157      * @dev See {ERC721-_beforeTokenTransfer}.
3158      */
3159     function _beforeTokenTransfer(
3160         address from,
3161         address to,
3162         uint256 firstTokenId,
3163         uint256 batchSize
3164     ) internal virtual override {
3165         super._beforeTokenTransfer(from, to, firstTokenId, batchSize);
3166 
3167         if (batchSize > 1) {
3168             // Will only trigger during construction. Batch transferring (minting) is not available afterwards.
3169             revert("ERC721Enumerable: consecutive transfers not supported");
3170         }
3171 
3172         uint256 tokenId = firstTokenId;
3173 
3174         if (from == address(0)) {
3175             _addTokenToAllTokensEnumeration(tokenId);
3176         } else if (from != to) {
3177             _removeTokenFromOwnerEnumeration(from, tokenId);
3178         }
3179         if (to == address(0)) {
3180             _removeTokenFromAllTokensEnumeration(tokenId);
3181         } else if (to != from) {
3182             _addTokenToOwnerEnumeration(to, tokenId);
3183         }
3184     }
3185 
3186     /**
3187      * @dev Private function to add a token to this extension's ownership-tracking data structures.
3188      * @param to address representing the new owner of the given token ID
3189      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
3190      */
3191     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
3192         uint256 length = ERC721.balanceOf(to);
3193         _ownedTokens[to][length] = tokenId;
3194         _ownedTokensIndex[tokenId] = length;
3195     }
3196 
3197     /**
3198      * @dev Private function to add a token to this extension's token tracking data structures.
3199      * @param tokenId uint256 ID of the token to be added to the tokens list
3200      */
3201     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
3202         _allTokensIndex[tokenId] = _allTokens.length;
3203         _allTokens.push(tokenId);
3204     }
3205 
3206     /**
3207      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
3208      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
3209      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
3210      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
3211      * @param from address representing the previous owner of the given token ID
3212      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
3213      */
3214     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
3215         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
3216         // then delete the last slot (swap and pop).
3217 
3218         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
3219         uint256 tokenIndex = _ownedTokensIndex[tokenId];
3220 
3221         // When the token to delete is the last token, the swap operation is unnecessary
3222         if (tokenIndex != lastTokenIndex) {
3223             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
3224 
3225             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3226             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3227         }
3228 
3229         // This also deletes the contents at the last position of the array
3230         delete _ownedTokensIndex[tokenId];
3231         delete _ownedTokens[from][lastTokenIndex];
3232     }
3233 
3234     /**
3235      * @dev Private function to remove a token from this extension's token tracking data structures.
3236      * This has O(1) time complexity, but alters the order of the _allTokens array.
3237      * @param tokenId uint256 ID of the token to be removed from the tokens list
3238      */
3239     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
3240         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
3241         // then delete the last slot (swap and pop).
3242 
3243         uint256 lastTokenIndex = _allTokens.length - 1;
3244         uint256 tokenIndex = _allTokensIndex[tokenId];
3245 
3246         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
3247         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
3248         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
3249         uint256 lastTokenId = _allTokens[lastTokenIndex];
3250 
3251         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
3252         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
3253 
3254         // This also deletes the contents at the last position of the array
3255         delete _allTokensIndex[tokenId];
3256         _allTokens.pop();
3257     }
3258 }
3259 
3260 /**
3261  * @title ERC721AQueryable.
3262  *
3263  * @dev ERC721A subclass with convenience query functions.
3264  */
3265 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
3266     /**
3267      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
3268      *
3269      * If the `tokenId` is out of bounds:
3270      *
3271      * - `addr = address(0)`
3272      * - `startTimestamp = 0`
3273      * - `burned = false`
3274      * - `extraData = 0`
3275      *
3276      * If the `tokenId` is burned:
3277      *
3278      * - `addr = <Address of owner before token was burned>`
3279      * - `startTimestamp = <Timestamp when token was burned>`
3280      * - `burned = true`
3281      * - `extraData = <Extra data when token was burned>`
3282      *
3283      * Otherwise:
3284      *
3285      * - `addr = <Address of owner>`
3286      * - `startTimestamp = <Timestamp of start of ownership>`
3287      * - `burned = false`
3288      * - `extraData = <Extra data at start of ownership>`
3289      */
3290     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
3291         TokenOwnership memory ownership;
3292         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
3293             return ownership;
3294         }
3295         ownership = _ownershipAt(tokenId);
3296         if (ownership.burned) {
3297             return ownership;
3298         }
3299         return _ownershipOf(tokenId);
3300     }
3301 
3302     /**
3303      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
3304      * See {ERC721AQueryable-explicitOwnershipOf}
3305      */
3306     function explicitOwnershipsOf(uint256[] calldata tokenIds)
3307         external
3308         view
3309         virtual
3310         override
3311         returns (TokenOwnership[] memory)
3312     {
3313         unchecked {
3314             uint256 tokenIdsLength = tokenIds.length;
3315             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
3316             for (uint256 i; i != tokenIdsLength; ++i) {
3317                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
3318             }
3319             return ownerships;
3320         }
3321     }
3322 
3323     /**
3324      * @dev Returns an array of token IDs owned by `owner`,
3325      * in the range [`start`, `stop`)
3326      * (i.e. `start <= tokenId < stop`).
3327      *
3328      * This function allows for tokens to be queried if the collection
3329      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
3330      *
3331      * Requirements:
3332      *
3333      * - `start < stop`
3334      */
3335     function tokensOfOwnerIn(
3336         address owner,
3337         uint256 start,
3338         uint256 stop
3339     ) external view virtual override returns (uint256[] memory) {
3340         unchecked {
3341             if (start >= stop) revert InvalidQueryRange();
3342             uint256 tokenIdsIdx;
3343             uint256 stopLimit = _nextTokenId();
3344             // Set `start = max(start, _startTokenId())`.
3345             if (start < _startTokenId()) {
3346                 start = _startTokenId();
3347             }
3348             // Set `stop = min(stop, stopLimit)`.
3349             if (stop > stopLimit) {
3350                 stop = stopLimit;
3351             }
3352             uint256 tokenIdsMaxLength = balanceOf(owner);
3353             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
3354             // to cater for cases where `balanceOf(owner)` is too big.
3355             if (start < stop) {
3356                 uint256 rangeLength = stop - start;
3357                 if (rangeLength < tokenIdsMaxLength) {
3358                     tokenIdsMaxLength = rangeLength;
3359                 }
3360             } else {
3361                 tokenIdsMaxLength = 0;
3362             }
3363             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
3364             if (tokenIdsMaxLength == 0) {
3365                 return tokenIds;
3366             }
3367             // We need to call `explicitOwnershipOf(start)`,
3368             // because the slot at `start` may not be initialized.
3369             TokenOwnership memory ownership = explicitOwnershipOf(start);
3370             address currOwnershipAddr;
3371             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
3372             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
3373             if (!ownership.burned) {
3374                 currOwnershipAddr = ownership.addr;
3375             }
3376             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
3377                 ownership = _ownershipAt(i);
3378                 if (ownership.burned) {
3379                     continue;
3380                 }
3381                 if (ownership.addr != address(0)) {
3382                     currOwnershipAddr = ownership.addr;
3383                 }
3384                 if (currOwnershipAddr == owner) {
3385                     tokenIds[tokenIdsIdx++] = i;
3386                 }
3387             }
3388             // Downsize the array to fit.
3389             assembly {
3390                 mstore(tokenIds, tokenIdsIdx)
3391             }
3392             return tokenIds;
3393         }
3394     }
3395 
3396     /**
3397      * @dev Returns an array of token IDs owned by `owner`.
3398      *
3399      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
3400      * It is meant to be called off-chain.
3401      *
3402      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
3403      * multiple smaller scans if the collection is large enough to cause
3404      * an out-of-gas error (10K collections should be fine).
3405      */
3406     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
3407         unchecked {
3408             uint256 tokenIdsIdx;
3409             address currOwnershipAddr;
3410             uint256 tokenIdsLength = balanceOf(owner);
3411             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
3412             TokenOwnership memory ownership;
3413             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
3414                 ownership = _ownershipAt(i);
3415                 if (ownership.burned) {
3416                     continue;
3417                 }
3418                 if (ownership.addr != address(0)) {
3419                     currOwnershipAddr = ownership.addr;
3420                 }
3421                 if (currOwnershipAddr == owner) {
3422                     tokenIds[tokenIdsIdx++] = i;
3423                 }
3424             }
3425             return tokenIds;
3426         }
3427     }
3428 }
3429 
3430 /**
3431  * @title ERC721ABurnable.
3432  *
3433  * @dev ERC721A token that can be irreversibly burned (destroyed).
3434  */
3435 abstract contract ERC721ABurnable is ERC721A, IERC721ABurnable {
3436     /**
3437      * @dev Burns `tokenId`. See {ERC721A-_burn}.
3438      *
3439      * Requirements:
3440      *
3441      * - The caller must own `tokenId` or be an approved operator.
3442      */
3443     function burn(uint256 tokenId) public virtual override {
3444         _burn(tokenId, true);
3445     }
3446 }
3447 
3448 
3449 abstract contract OperatorFilterer {
3450     error OperatorNotAllowed(address operator);
3451 
3452     IOperatorFilterRegistry constant OPERATOR_FILTER_REGISTRY =
3453         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
3454 
3455     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
3456         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
3457         // will not revert, but the contract will need to be registered with the registry once it is deployed in
3458         // order for the modifier to filter addresses.
3459         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3460             if (subscribe) {
3461                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
3462             } else {
3463                 if (subscriptionOrRegistrantToCopy != address(0)) {
3464                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
3465                 } else {
3466                     OPERATOR_FILTER_REGISTRY.register(address(this));
3467                 }
3468             }
3469         }
3470     }
3471 
3472     modifier onlyAllowedOperator(address from) virtual {
3473         // Check registry code length to facilitate testing in environments without a deployed registry.
3474         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
3475             // Allow spending tokens from addresses with balance
3476             // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
3477             // from an EOA.
3478             if (from == msg.sender) {
3479                 _;
3480                 return;
3481             }
3482             if (
3483                 !(
3484                     OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), msg.sender)
3485                         && OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), from)
3486                 )
3487             ) {
3488                 revert OperatorNotAllowed(msg.sender);
3489             }
3490         }
3491         _;
3492     }
3493 }
3494 
3495 abstract contract DefaultOperatorFilterer is OperatorFilterer {
3496     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
3497 
3498     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
3499 }
3500 
3501 
3502 
3503 contract AICHATBOTS is ERC721A, ERC721ABurnable, ERC721AQueryable, Ownable, ERC2981, DefaultOperatorFilterer {
3504     using Strings for uint256;
3505 
3506     uint256 constant maxSupply = 1000;
3507     uint256 constant mintPrice = 0 ether;
3508     uint256 public maxPerAddress = 1;
3509     uint256 public maxPerTx = 1;
3510     string public baseURI;
3511     string public baseExtension = ".json";
3512     string public notRevealedUri;
3513     bool public revealed = true;
3514     bool public letsgolive = false;
3515     mapping(address => uint256) public flurAlphaHolders;
3516     uint public randNonce = 0;
3517 
3518     constructor() ERC721A("AI Chatbots", "AICHATBOTS") {
3519     }
3520 
3521     function goLive(bool _letsfngo) external onlyOwner {
3522         letsgolive = _letsfngo;
3523     }
3524 
3525     function setFlurAlphaHolders(address[] memory wallets, uint256[] memory amounts) external onlyOwner {
3526         for(uint256 i = 0; i < wallets.length; i++){
3527             flurAlphaHolders[wallets[i]] = amounts[i];
3528         }
3529     }
3530 
3531     function mint() external payable {
3532         require(letsgolive, "AIChatbots: Mint Not Active");
3533         require(flurAlphaHolders[msg.sender] > 0, "AIChatbots: You don't have any allocation");
3534         uint256 _quantity = flurAlphaHolders[msg.sender];
3535         require(_numberMinted(msg.sender) + _quantity <= flurAlphaHolders[msg.sender], "AIChatbots: Exceeds Max Per Wallet");
3536         _safeMint(msg.sender, _quantity);
3537     }
3538 
3539     function reserve(address _address, uint256 _quantity) external onlyOwner {
3540         require(totalSupply() + _quantity <= maxSupply, "AIChatbots: Mint Supply Exceeded");
3541         _safeMint(_address, _quantity);
3542     }
3543 
3544     function tokenURI(uint256 tokenId)
3545         public
3546         view
3547         virtual
3548         override(ERC721A, IERC721A)
3549         returns (string memory)
3550     {
3551         require(
3552         _exists(tokenId),
3553         "ERC721Metadata: URI query for nonexistent token"
3554         );
3555         
3556         if(revealed == false) {
3557             return notRevealedUri;
3558         }
3559 
3560         string memory currentBaseURI = _baseURI();
3561         return bytes(currentBaseURI).length > 0
3562             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
3563             : "";
3564     }
3565 
3566       function supportsInterface(
3567         bytes4 interfaceId
3568     )
3569         public
3570         view
3571         override(ERC721A, ERC2981, IERC721A)
3572         returns (bool) 
3573     {
3574         return
3575             ERC2981.supportsInterface(interfaceId)
3576             || ERC721A.supportsInterface(interfaceId);
3577     }
3578 
3579     function _startTokenId() internal view virtual override returns (uint256) {
3580         return 1;
3581     }
3582     
3583     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
3584         notRevealedUri = _notRevealedURI;
3585     }
3586 
3587     function setBaseURI(string memory _newBaseURI) public onlyOwner {
3588         baseURI = _newBaseURI;
3589     }
3590 
3591     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
3592         baseExtension = _newBaseExtension;
3593     }
3594 
3595     function _baseURI() internal view virtual override returns (string memory) {
3596         return baseURI;
3597     }
3598 
3599     function reveal() public onlyOwner {
3600         revealed = true;
3601     }
3602 
3603       function setDefaultRoyalty(
3604     address _receiver,
3605     uint96 _feeNumerator
3606   )
3607     external
3608     onlyOwner
3609   {
3610     _setDefaultRoyalty(_receiver, _feeNumerator);
3611   }
3612 
3613   function deleteDefaultRoyalty()
3614     external
3615     onlyOwner
3616   {
3617     _deleteDefaultRoyalty();
3618   }
3619 
3620   function setTokenRoyalty(
3621     uint256 _tokenId,
3622     address _receiver,
3623     uint96 _feeNumerator
3624   )
3625     external
3626     onlyOwner
3627   {
3628     _setTokenRoyalty(_tokenId, _receiver, _feeNumerator);
3629   }
3630 
3631   function resetTokenRoyalty(
3632     uint256 tokenId
3633   )
3634     external
3635     onlyOwner
3636   {
3637     _resetTokenRoyalty(tokenId);
3638   }
3639 
3640   /* ------------ OpenSea Overrides --------------*/
3641   function transferFrom(
3642     address _from,
3643     address _to,
3644     uint256 _tokenId
3645   )
3646     public
3647     payable
3648     override(ERC721A, IERC721A)  
3649     onlyAllowedOperator(_from)
3650   {
3651       super.transferFrom(_from, _to, _tokenId);
3652   }
3653 
3654   function safeTransferFrom(
3655     address _from,
3656     address _to,
3657     uint256 _tokenId
3658   ) 
3659     public
3660     payable
3661     override(ERC721A, IERC721A) 
3662     onlyAllowedOperator(_from)
3663   {
3664     super.safeTransferFrom(_from, _to, _tokenId);
3665   }
3666 
3667   function safeTransferFrom(
3668     address _from,
3669     address _to,
3670     uint256 _tokenId,
3671     bytes memory _data
3672   )
3673     public
3674     payable
3675     override(ERC721A, IERC721A) 
3676     onlyAllowedOperator(_from)
3677   {
3678     super.safeTransferFrom(_from, _to, _tokenId, _data);
3679   }
3680 
3681     function withdrawMoney() external onlyOwner {
3682         (bool success, ) = msg.sender.call{value: address(this).balance}("");
3683         require(success, "Withdraw failed.");
3684     }
3685 }