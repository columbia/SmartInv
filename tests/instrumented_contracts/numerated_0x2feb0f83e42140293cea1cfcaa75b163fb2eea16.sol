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
421 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 // CAUTION
429 // This version of SafeMath should only be used with Solidity 0.8 or later,
430 // because it relies on the compiler's built in overflow checks.
431 
432 /**
433  * @dev Wrappers over Solidity's arithmetic operations.
434  *
435  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
436  * now has built in overflow checking.
437  */
438 library SafeMath {
439     /**
440      * @dev Returns the addition of two unsigned integers, with an overflow flag.
441      *
442      * _Available since v3.4._
443      */
444     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
445         unchecked {
446             uint256 c = a + b;
447             if (c < a) return (false, 0);
448             return (true, c);
449         }
450     }
451 
452     /**
453      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
454      *
455      * _Available since v3.4._
456      */
457     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
458         unchecked {
459             if (b > a) return (false, 0);
460             return (true, a - b);
461         }
462     }
463 
464     /**
465      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
466      *
467      * _Available since v3.4._
468      */
469     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
470         unchecked {
471             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
472             // benefit is lost if 'b' is also tested.
473             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
474             if (a == 0) return (true, 0);
475             uint256 c = a * b;
476             if (c / a != b) return (false, 0);
477             return (true, c);
478         }
479     }
480 
481     /**
482      * @dev Returns the division of two unsigned integers, with a division by zero flag.
483      *
484      * _Available since v3.4._
485      */
486     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
487         unchecked {
488             if (b == 0) return (false, 0);
489             return (true, a / b);
490         }
491     }
492 
493     /**
494      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
495      *
496      * _Available since v3.4._
497      */
498     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
499         unchecked {
500             if (b == 0) return (false, 0);
501             return (true, a % b);
502         }
503     }
504 
505     /**
506      * @dev Returns the addition of two unsigned integers, reverting on
507      * overflow.
508      *
509      * Counterpart to Solidity's `+` operator.
510      *
511      * Requirements:
512      *
513      * - Addition cannot overflow.
514      */
515     function add(uint256 a, uint256 b) internal pure returns (uint256) {
516         return a + b;
517     }
518 
519     /**
520      * @dev Returns the subtraction of two unsigned integers, reverting on
521      * overflow (when the result is negative).
522      *
523      * Counterpart to Solidity's `-` operator.
524      *
525      * Requirements:
526      *
527      * - Subtraction cannot overflow.
528      */
529     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
530         return a - b;
531     }
532 
533     /**
534      * @dev Returns the multiplication of two unsigned integers, reverting on
535      * overflow.
536      *
537      * Counterpart to Solidity's `*` operator.
538      *
539      * Requirements:
540      *
541      * - Multiplication cannot overflow.
542      */
543     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
544         return a * b;
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers, reverting on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator.
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function div(uint256 a, uint256 b) internal pure returns (uint256) {
558         return a / b;
559     }
560 
561     /**
562      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
563      * reverting when dividing by zero.
564      *
565      * Counterpart to Solidity's `%` operator. This function uses a `revert`
566      * opcode (which leaves remaining gas untouched) while Solidity uses an
567      * invalid opcode to revert (consuming all remaining gas).
568      *
569      * Requirements:
570      *
571      * - The divisor cannot be zero.
572      */
573     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
574         return a % b;
575     }
576 
577     /**
578      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
579      * overflow (when the result is negative).
580      *
581      * CAUTION: This function is deprecated because it requires allocating memory for the error
582      * message unnecessarily. For custom revert reasons use {trySub}.
583      *
584      * Counterpart to Solidity's `-` operator.
585      *
586      * Requirements:
587      *
588      * - Subtraction cannot overflow.
589      */
590     function sub(
591         uint256 a,
592         uint256 b,
593         string memory errorMessage
594     ) internal pure returns (uint256) {
595         unchecked {
596             require(b <= a, errorMessage);
597             return a - b;
598         }
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
603      * division by zero. The result is rounded towards zero.
604      *
605      * Counterpart to Solidity's `/` operator. Note: this function uses a
606      * `revert` opcode (which leaves remaining gas untouched) while Solidity
607      * uses an invalid opcode to revert (consuming all remaining gas).
608      *
609      * Requirements:
610      *
611      * - The divisor cannot be zero.
612      */
613     function div(
614         uint256 a,
615         uint256 b,
616         string memory errorMessage
617     ) internal pure returns (uint256) {
618         unchecked {
619             require(b > 0, errorMessage);
620             return a / b;
621         }
622     }
623 
624     /**
625      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
626      * reverting with custom message when dividing by zero.
627      *
628      * CAUTION: This function is deprecated because it requires allocating memory for the error
629      * message unnecessarily. For custom revert reasons use {tryMod}.
630      *
631      * Counterpart to Solidity's `%` operator. This function uses a `revert`
632      * opcode (which leaves remaining gas untouched) while Solidity uses an
633      * invalid opcode to revert (consuming all remaining gas).
634      *
635      * Requirements:
636      *
637      * - The divisor cannot be zero.
638      */
639     function mod(
640         uint256 a,
641         uint256 b,
642         string memory errorMessage
643     ) internal pure returns (uint256) {
644         unchecked {
645             require(b > 0, errorMessage);
646             return a % b;
647         }
648     }
649 }
650 
651 // File: operator-filter-registry/src/lib/Constants.sol
652 
653 
654 pragma solidity ^0.8.13;
655 
656 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
657 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
658 
659 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
660 
661 
662 pragma solidity ^0.8.13;
663 
664 interface IOperatorFilterRegistry {
665     /**
666      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
667      *         true if supplied registrant address is not registered.
668      */
669     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
670 
671     /**
672      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
673      */
674     function register(address registrant) external;
675 
676     /**
677      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
678      */
679     function registerAndSubscribe(address registrant, address subscription) external;
680 
681     /**
682      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
683      *         address without subscribing.
684      */
685     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
686 
687     /**
688      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
689      *         Note that this does not remove any filtered addresses or codeHashes.
690      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
691      */
692     function unregister(address addr) external;
693 
694     /**
695      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
696      */
697     function updateOperator(address registrant, address operator, bool filtered) external;
698 
699     /**
700      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
701      */
702     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
703 
704     /**
705      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
706      */
707     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
708 
709     /**
710      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
711      */
712     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
713 
714     /**
715      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
716      *         subscription if present.
717      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
718      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
719      *         used.
720      */
721     function subscribe(address registrant, address registrantToSubscribe) external;
722 
723     /**
724      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
725      */
726     function unsubscribe(address registrant, bool copyExistingEntries) external;
727 
728     /**
729      * @notice Get the subscription address of a given registrant, if any.
730      */
731     function subscriptionOf(address addr) external returns (address registrant);
732 
733     /**
734      * @notice Get the set of addresses subscribed to a given registrant.
735      *         Note that order is not guaranteed as updates are made.
736      */
737     function subscribers(address registrant) external returns (address[] memory);
738 
739     /**
740      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
741      *         Note that order is not guaranteed as updates are made.
742      */
743     function subscriberAt(address registrant, uint256 index) external returns (address);
744 
745     /**
746      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
747      */
748     function copyEntriesOf(address registrant, address registrantToCopy) external;
749 
750     /**
751      * @notice Returns true if operator is filtered by a given address or its subscription.
752      */
753     function isOperatorFiltered(address registrant, address operator) external returns (bool);
754 
755     /**
756      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
757      */
758     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
759 
760     /**
761      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
762      */
763     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
764 
765     /**
766      * @notice Returns a list of filtered operators for a given address or its subscription.
767      */
768     function filteredOperators(address addr) external returns (address[] memory);
769 
770     /**
771      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
772      *         Note that order is not guaranteed as updates are made.
773      */
774     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
775 
776     /**
777      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
778      *         its subscription.
779      *         Note that order is not guaranteed as updates are made.
780      */
781     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
782 
783     /**
784      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
785      *         its subscription.
786      *         Note that order is not guaranteed as updates are made.
787      */
788     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
789 
790     /**
791      * @notice Returns true if an address has registered
792      */
793     function isRegistered(address addr) external returns (bool);
794 
795     /**
796      * @dev Convenience method to compute the code hash of an arbitrary contract
797      */
798     function codeHashOf(address addr) external returns (bytes32);
799 }
800 
801 // File: operator-filter-registry/src/OperatorFilterer.sol
802 
803 
804 pragma solidity ^0.8.13;
805 
806 
807 /**
808  * @title  OperatorFilterer
809  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
810  *         registrant's entries in the OperatorFilterRegistry.
811  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
812  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
813  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
814  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
815  *         administration methods on the contract itself to interact with the registry otherwise the subscription
816  *         will be locked to the options set during construction.
817  */
818 
819 abstract contract OperatorFilterer {
820     /// @dev Emitted when an operator is not allowed.
821     error OperatorNotAllowed(address operator);
822 
823     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
824         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
825 
826     /// @dev The constructor that is called when the contract is being deployed.
827     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
828         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
829         // will not revert, but the contract will need to be registered with the registry once it is deployed in
830         // order for the modifier to filter addresses.
831         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
832             if (subscribe) {
833                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
834             } else {
835                 if (subscriptionOrRegistrantToCopy != address(0)) {
836                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
837                 } else {
838                     OPERATOR_FILTER_REGISTRY.register(address(this));
839                 }
840             }
841         }
842     }
843 
844     /**
845      * @dev A helper function to check if an operator is allowed.
846      */
847     modifier onlyAllowedOperator(address from) virtual {
848         // Allow spending tokens from addresses with balance
849         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
850         // from an EOA.
851         if (from != msg.sender) {
852             _checkFilterOperator(msg.sender);
853         }
854         _;
855     }
856 
857     /**
858      * @dev A helper function to check if an operator approval is allowed.
859      */
860     modifier onlyAllowedOperatorApproval(address operator) virtual {
861         _checkFilterOperator(operator);
862         _;
863     }
864 
865     /**
866      * @dev A helper function to check if an operator is allowed.
867      */
868     function _checkFilterOperator(address operator) internal view virtual {
869         // Check registry code length to facilitate testing in environments without a deployed registry.
870         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
871             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
872             // may specify their own OperatorFilterRegistry implementations, which may behave differently
873             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
874                 revert OperatorNotAllowed(operator);
875             }
876         }
877     }
878 }
879 
880 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
881 
882 
883 pragma solidity ^0.8.13;
884 
885 
886 /**
887  * @title  DefaultOperatorFilterer
888  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
889  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
890  *         administration methods on the contract itself to interact with the registry otherwise the subscription
891  *         will be locked to the options set during construction.
892  */
893 
894 abstract contract DefaultOperatorFilterer is OperatorFilterer {
895     /// @dev The constructor that is called when the contract is being deployed.
896     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
897 }
898 
899 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev Interface of the ERC165 standard, as defined in the
908  * https://eips.ethereum.org/EIPS/eip-165[EIP].
909  *
910  * Implementers can declare support of contract interfaces, which can then be
911  * queried by others ({ERC165Checker}).
912  *
913  * For an implementation, see {ERC165}.
914  */
915 interface IERC165 {
916     /**
917      * @dev Returns true if this contract implements the interface defined by
918      * `interfaceId`. See the corresponding
919      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
920      * to learn more about how these ids are created.
921      *
922      * This function call must use less than 30 000 gas.
923      */
924     function supportsInterface(bytes4 interfaceId) external view returns (bool);
925 }
926 
927 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
928 
929 
930 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @dev Interface for the NFT Royalty Standard.
937  *
938  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
939  * support for royalty payments across all NFT marketplaces and ecosystem participants.
940  *
941  * _Available since v4.5._
942  */
943 interface IERC2981 is IERC165 {
944     /**
945      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
946      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
947      */
948     function royaltyInfo(uint256 tokenId, uint256 salePrice)
949         external
950         view
951         returns (address receiver, uint256 royaltyAmount);
952 }
953 
954 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
955 
956 
957 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
958 
959 pragma solidity ^0.8.0;
960 
961 
962 /**
963  * @dev Required interface of an ERC721 compliant contract.
964  */
965 interface IERC721 is IERC165 {
966     /**
967      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
968      */
969     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
970 
971     /**
972      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
973      */
974     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
975 
976     /**
977      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
978      */
979     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
980 
981     /**
982      * @dev Returns the number of tokens in ``owner``'s account.
983      */
984     function balanceOf(address owner) external view returns (uint256 balance);
985 
986     /**
987      * @dev Returns the owner of the `tokenId` token.
988      *
989      * Requirements:
990      *
991      * - `tokenId` must exist.
992      */
993     function ownerOf(uint256 tokenId) external view returns (address owner);
994 
995     /**
996      * @dev Safely transfers `tokenId` token from `from` to `to`.
997      *
998      * Requirements:
999      *
1000      * - `from` cannot be the zero address.
1001      * - `to` cannot be the zero address.
1002      * - `tokenId` token must exist and be owned by `from`.
1003      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1004      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1005      *
1006      * Emits a {Transfer} event.
1007      */
1008     function safeTransferFrom(
1009         address from,
1010         address to,
1011         uint256 tokenId,
1012         bytes calldata data
1013     ) external;
1014 
1015     /**
1016      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1017      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1018      *
1019      * Requirements:
1020      *
1021      * - `from` cannot be the zero address.
1022      * - `to` cannot be the zero address.
1023      * - `tokenId` token must exist and be owned by `from`.
1024      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1025      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1026      *
1027      * Emits a {Transfer} event.
1028      */
1029     function safeTransferFrom(
1030         address from,
1031         address to,
1032         uint256 tokenId
1033     ) external;
1034 
1035     /**
1036      * @dev Transfers `tokenId` token from `from` to `to`.
1037      *
1038      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1039      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1040      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1041      *
1042      * Requirements:
1043      *
1044      * - `from` cannot be the zero address.
1045      * - `to` cannot be the zero address.
1046      * - `tokenId` token must be owned by `from`.
1047      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1048      *
1049      * Emits a {Transfer} event.
1050      */
1051     function transferFrom(
1052         address from,
1053         address to,
1054         uint256 tokenId
1055     ) external;
1056 
1057     /**
1058      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1059      * The approval is cleared when the token is transferred.
1060      *
1061      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1062      *
1063      * Requirements:
1064      *
1065      * - The caller must own the token or be an approved operator.
1066      * - `tokenId` must exist.
1067      *
1068      * Emits an {Approval} event.
1069      */
1070     function approve(address to, uint256 tokenId) external;
1071 
1072     /**
1073      * @dev Approve or remove `operator` as an operator for the caller.
1074      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1075      *
1076      * Requirements:
1077      *
1078      * - The `operator` cannot be the caller.
1079      *
1080      * Emits an {ApprovalForAll} event.
1081      */
1082     function setApprovalForAll(address operator, bool _approved) external;
1083 
1084     /**
1085      * @dev Returns the account approved for `tokenId` token.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      */
1091     function getApproved(uint256 tokenId) external view returns (address operator);
1092 
1093     /**
1094      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1095      *
1096      * See {setApprovalForAll}
1097      */
1098     function isApprovedForAll(address owner, address operator) external view returns (bool);
1099 }
1100 
1101 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
1102 
1103 
1104 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
1105 
1106 pragma solidity ^0.8.0;
1107 
1108 /**
1109  * @dev These functions deal with verification of Merkle Tree proofs.
1110  *
1111  * The tree and the proofs can be generated using our
1112  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
1113  * You will find a quickstart guide in the readme.
1114  *
1115  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
1116  * hashing, or use a hash function other than keccak256 for hashing leaves.
1117  * This is because the concatenation of a sorted pair of internal nodes in
1118  * the merkle tree could be reinterpreted as a leaf value.
1119  * OpenZeppelin's JavaScript library generates merkle trees that are safe
1120  * against this attack out of the box.
1121  */
1122 library MerkleProof {
1123     /**
1124      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
1125      * defined by `root`. For this, a `proof` must be provided, containing
1126      * sibling hashes on the branch from the leaf to the root of the tree. Each
1127      * pair of leaves and each pair of pre-images are assumed to be sorted.
1128      */
1129     function verify(
1130         bytes32[] memory proof,
1131         bytes32 root,
1132         bytes32 leaf
1133     ) internal pure returns (bool) {
1134         return processProof(proof, leaf) == root;
1135     }
1136 
1137     /**
1138      * @dev Calldata version of {verify}
1139      *
1140      * _Available since v4.7._
1141      */
1142     function verifyCalldata(
1143         bytes32[] calldata proof,
1144         bytes32 root,
1145         bytes32 leaf
1146     ) internal pure returns (bool) {
1147         return processProofCalldata(proof, leaf) == root;
1148     }
1149 
1150     /**
1151      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
1152      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
1153      * hash matches the root of the tree. When processing the proof, the pairs
1154      * of leafs & pre-images are assumed to be sorted.
1155      *
1156      * _Available since v4.4._
1157      */
1158     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
1159         bytes32 computedHash = leaf;
1160         for (uint256 i = 0; i < proof.length; i++) {
1161             computedHash = _hashPair(computedHash, proof[i]);
1162         }
1163         return computedHash;
1164     }
1165 
1166     /**
1167      * @dev Calldata version of {processProof}
1168      *
1169      * _Available since v4.7._
1170      */
1171     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
1172         bytes32 computedHash = leaf;
1173         for (uint256 i = 0; i < proof.length; i++) {
1174             computedHash = _hashPair(computedHash, proof[i]);
1175         }
1176         return computedHash;
1177     }
1178 
1179     /**
1180      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
1181      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
1182      *
1183      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1184      *
1185      * _Available since v4.7._
1186      */
1187     function multiProofVerify(
1188         bytes32[] memory proof,
1189         bool[] memory proofFlags,
1190         bytes32 root,
1191         bytes32[] memory leaves
1192     ) internal pure returns (bool) {
1193         return processMultiProof(proof, proofFlags, leaves) == root;
1194     }
1195 
1196     /**
1197      * @dev Calldata version of {multiProofVerify}
1198      *
1199      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1200      *
1201      * _Available since v4.7._
1202      */
1203     function multiProofVerifyCalldata(
1204         bytes32[] calldata proof,
1205         bool[] calldata proofFlags,
1206         bytes32 root,
1207         bytes32[] memory leaves
1208     ) internal pure returns (bool) {
1209         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
1210     }
1211 
1212     /**
1213      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
1214      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
1215      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
1216      * respectively.
1217      *
1218      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
1219      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
1220      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
1221      *
1222      * _Available since v4.7._
1223      */
1224     function processMultiProof(
1225         bytes32[] memory proof,
1226         bool[] memory proofFlags,
1227         bytes32[] memory leaves
1228     ) internal pure returns (bytes32 merkleRoot) {
1229         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1230         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1231         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1232         // the merkle tree.
1233         uint256 leavesLen = leaves.length;
1234         uint256 totalHashes = proofFlags.length;
1235 
1236         // Check proof validity.
1237         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1238 
1239         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1240         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1241         bytes32[] memory hashes = new bytes32[](totalHashes);
1242         uint256 leafPos = 0;
1243         uint256 hashPos = 0;
1244         uint256 proofPos = 0;
1245         // At each step, we compute the next hash using two values:
1246         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1247         //   get the next hash.
1248         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1249         //   `proof` array.
1250         for (uint256 i = 0; i < totalHashes; i++) {
1251             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1252             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1253             hashes[i] = _hashPair(a, b);
1254         }
1255 
1256         if (totalHashes > 0) {
1257             return hashes[totalHashes - 1];
1258         } else if (leavesLen > 0) {
1259             return leaves[0];
1260         } else {
1261             return proof[0];
1262         }
1263     }
1264 
1265     /**
1266      * @dev Calldata version of {processMultiProof}.
1267      *
1268      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
1269      *
1270      * _Available since v4.7._
1271      */
1272     function processMultiProofCalldata(
1273         bytes32[] calldata proof,
1274         bool[] calldata proofFlags,
1275         bytes32[] memory leaves
1276     ) internal pure returns (bytes32 merkleRoot) {
1277         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
1278         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
1279         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
1280         // the merkle tree.
1281         uint256 leavesLen = leaves.length;
1282         uint256 totalHashes = proofFlags.length;
1283 
1284         // Check proof validity.
1285         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
1286 
1287         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
1288         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
1289         bytes32[] memory hashes = new bytes32[](totalHashes);
1290         uint256 leafPos = 0;
1291         uint256 hashPos = 0;
1292         uint256 proofPos = 0;
1293         // At each step, we compute the next hash using two values:
1294         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
1295         //   get the next hash.
1296         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
1297         //   `proof` array.
1298         for (uint256 i = 0; i < totalHashes; i++) {
1299             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
1300             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
1301             hashes[i] = _hashPair(a, b);
1302         }
1303 
1304         if (totalHashes > 0) {
1305             return hashes[totalHashes - 1];
1306         } else if (leavesLen > 0) {
1307             return leaves[0];
1308         } else {
1309             return proof[0];
1310         }
1311     }
1312 
1313     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
1314         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
1315     }
1316 
1317     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
1318         /// @solidity memory-safe-assembly
1319         assembly {
1320             mstore(0x00, a)
1321             mstore(0x20, b)
1322             value := keccak256(0x00, 0x40)
1323         }
1324     }
1325 }
1326 
1327 // File: @openzeppelin/contracts/utils/Context.sol
1328 
1329 
1330 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1331 
1332 pragma solidity ^0.8.0;
1333 
1334 /**
1335  * @dev Provides information about the current execution context, including the
1336  * sender of the transaction and its data. While these are generally available
1337  * via msg.sender and msg.data, they should not be accessed in such a direct
1338  * manner, since when dealing with meta-transactions the account sending and
1339  * paying for execution may not be the actual sender (as far as an application
1340  * is concerned).
1341  *
1342  * This contract is only required for intermediate, library-like contracts.
1343  */
1344 abstract contract Context {
1345     function _msgSender() internal view virtual returns (address) {
1346         return msg.sender;
1347     }
1348 
1349     function _msgData() internal view virtual returns (bytes calldata) {
1350         return msg.data;
1351     }
1352 }
1353 
1354 // File: @openzeppelin/contracts/access/Ownable.sol
1355 
1356 
1357 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
1358 
1359 pragma solidity ^0.8.0;
1360 
1361 
1362 /**
1363  * @dev Contract module which provides a basic access control mechanism, where
1364  * there is an account (an owner) that can be granted exclusive access to
1365  * specific functions.
1366  *
1367  * By default, the owner account will be the one that deploys the contract. This
1368  * can later be changed with {transferOwnership}.
1369  *
1370  * This module is used through inheritance. It will make available the modifier
1371  * `onlyOwner`, which can be applied to your functions to restrict their use to
1372  * the owner.
1373  */
1374 abstract contract Ownable is Context {
1375     address private _owner;
1376 
1377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1378 
1379     /**
1380      * @dev Initializes the contract setting the deployer as the initial owner.
1381      */
1382     constructor() {
1383         _transferOwnership(_msgSender());
1384     }
1385 
1386     /**
1387      * @dev Throws if called by any account other than the owner.
1388      */
1389     modifier onlyOwner() {
1390         _checkOwner();
1391         _;
1392     }
1393 
1394     /**
1395      * @dev Returns the address of the current owner.
1396      */
1397     function owner() public view virtual returns (address) {
1398         return _owner;
1399     }
1400 
1401     /**
1402      * @dev Throws if the sender is not the owner.
1403      */
1404     function _checkOwner() internal view virtual {
1405         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1406     }
1407 
1408     /**
1409      * @dev Leaves the contract without owner. It will not be possible to call
1410      * `onlyOwner` functions anymore. Can only be called by the current owner.
1411      *
1412      * NOTE: Renouncing ownership will leave the contract without an owner,
1413      * thereby removing any functionality that is only available to the owner.
1414      */
1415     function renounceOwnership() public virtual onlyOwner {
1416         _transferOwnership(address(0));
1417     }
1418 
1419     /**
1420      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1421      * Can only be called by the current owner.
1422      */
1423     function transferOwnership(address newOwner) public virtual onlyOwner {
1424         require(newOwner != address(0), "Ownable: new owner is the zero address");
1425         _transferOwnership(newOwner);
1426     }
1427 
1428     /**
1429      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1430      * Internal function without access restriction.
1431      */
1432     function _transferOwnership(address newOwner) internal virtual {
1433         address oldOwner = _owner;
1434         _owner = newOwner;
1435         emit OwnershipTransferred(oldOwner, newOwner);
1436     }
1437 }
1438 
1439 // File: erc721a/contracts/IERC721A.sol
1440 
1441 
1442 // ERC721A Contracts v4.2.3
1443 // Creator: Chiru Labs
1444 
1445 pragma solidity ^0.8.4;
1446 
1447 /**
1448  * @dev Interface of ERC721A.
1449  */
1450 interface IERC721A {
1451     /**
1452      * The caller must own the token or be an approved operator.
1453      */
1454     error ApprovalCallerNotOwnerNorApproved();
1455 
1456     /**
1457      * The token does not exist.
1458      */
1459     error ApprovalQueryForNonexistentToken();
1460 
1461     /**
1462      * Cannot query the balance for the zero address.
1463      */
1464     error BalanceQueryForZeroAddress();
1465 
1466     /**
1467      * Cannot mint to the zero address.
1468      */
1469     error MintToZeroAddress();
1470 
1471     /**
1472      * The quantity of tokens minted must be more than zero.
1473      */
1474     error MintZeroQuantity();
1475 
1476     /**
1477      * The token does not exist.
1478      */
1479     error OwnerQueryForNonexistentToken();
1480 
1481     /**
1482      * The caller must own the token or be an approved operator.
1483      */
1484     error TransferCallerNotOwnerNorApproved();
1485 
1486     /**
1487      * The token must be owned by `from`.
1488      */
1489     error TransferFromIncorrectOwner();
1490 
1491     /**
1492      * Cannot safely transfer to a contract that does not implement the
1493      * ERC721Receiver interface.
1494      */
1495     error TransferToNonERC721ReceiverImplementer();
1496 
1497     /**
1498      * Cannot transfer to the zero address.
1499      */
1500     error TransferToZeroAddress();
1501 
1502     /**
1503      * The token does not exist.
1504      */
1505     error URIQueryForNonexistentToken();
1506 
1507     /**
1508      * The `quantity` minted with ERC2309 exceeds the safety limit.
1509      */
1510     error MintERC2309QuantityExceedsLimit();
1511 
1512     /**
1513      * The `extraData` cannot be set on an unintialized ownership slot.
1514      */
1515     error OwnershipNotInitializedForExtraData();
1516 
1517     // =============================================================
1518     //                            STRUCTS
1519     // =============================================================
1520 
1521     struct TokenOwnership {
1522         // The address of the owner.
1523         address addr;
1524         // Stores the start time of ownership with minimal overhead for tokenomics.
1525         uint64 startTimestamp;
1526         // Whether the token has been burned.
1527         bool burned;
1528         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1529         uint24 extraData;
1530     }
1531 
1532     // =============================================================
1533     //                         TOKEN COUNTERS
1534     // =============================================================
1535 
1536     /**
1537      * @dev Returns the total number of tokens in existence.
1538      * Burned tokens will reduce the count.
1539      * To get the total number of tokens minted, please see {_totalMinted}.
1540      */
1541     function totalSupply() external view returns (uint256);
1542 
1543     // =============================================================
1544     //                            IERC165
1545     // =============================================================
1546 
1547     /**
1548      * @dev Returns true if this contract implements the interface defined by
1549      * `interfaceId`. See the corresponding
1550      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1551      * to learn more about how these ids are created.
1552      *
1553      * This function call must use less than 30000 gas.
1554      */
1555     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1556 
1557     // =============================================================
1558     //                            IERC721
1559     // =============================================================
1560 
1561     /**
1562      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1563      */
1564     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1565 
1566     /**
1567      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1568      */
1569     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1570 
1571     /**
1572      * @dev Emitted when `owner` enables or disables
1573      * (`approved`) `operator` to manage all of its assets.
1574      */
1575     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1576 
1577     /**
1578      * @dev Returns the number of tokens in `owner`'s account.
1579      */
1580     function balanceOf(address owner) external view returns (uint256 balance);
1581 
1582     /**
1583      * @dev Returns the owner of the `tokenId` token.
1584      *
1585      * Requirements:
1586      *
1587      * - `tokenId` must exist.
1588      */
1589     function ownerOf(uint256 tokenId) external view returns (address owner);
1590 
1591     /**
1592      * @dev Safely transfers `tokenId` token from `from` to `to`,
1593      * checking first that contract recipients are aware of the ERC721 protocol
1594      * to prevent tokens from being forever locked.
1595      *
1596      * Requirements:
1597      *
1598      * - `from` cannot be the zero address.
1599      * - `to` cannot be the zero address.
1600      * - `tokenId` token must exist and be owned by `from`.
1601      * - If the caller is not `from`, it must be have been allowed to move
1602      * this token by either {approve} or {setApprovalForAll}.
1603      * - If `to` refers to a smart contract, it must implement
1604      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1605      *
1606      * Emits a {Transfer} event.
1607      */
1608     function safeTransferFrom(
1609         address from,
1610         address to,
1611         uint256 tokenId,
1612         bytes calldata data
1613     ) external payable;
1614 
1615     /**
1616      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1617      */
1618     function safeTransferFrom(
1619         address from,
1620         address to,
1621         uint256 tokenId
1622     ) external payable;
1623 
1624     /**
1625      * @dev Transfers `tokenId` from `from` to `to`.
1626      *
1627      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1628      * whenever possible.
1629      *
1630      * Requirements:
1631      *
1632      * - `from` cannot be the zero address.
1633      * - `to` cannot be the zero address.
1634      * - `tokenId` token must be owned by `from`.
1635      * - If the caller is not `from`, it must be approved to move this token
1636      * by either {approve} or {setApprovalForAll}.
1637      *
1638      * Emits a {Transfer} event.
1639      */
1640     function transferFrom(
1641         address from,
1642         address to,
1643         uint256 tokenId
1644     ) external payable;
1645 
1646     /**
1647      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1648      * The approval is cleared when the token is transferred.
1649      *
1650      * Only a single account can be approved at a time, so approving the
1651      * zero address clears previous approvals.
1652      *
1653      * Requirements:
1654      *
1655      * - The caller must own the token or be an approved operator.
1656      * - `tokenId` must exist.
1657      *
1658      * Emits an {Approval} event.
1659      */
1660     function approve(address to, uint256 tokenId) external payable;
1661 
1662     /**
1663      * @dev Approve or remove `operator` as an operator for the caller.
1664      * Operators can call {transferFrom} or {safeTransferFrom}
1665      * for any token owned by the caller.
1666      *
1667      * Requirements:
1668      *
1669      * - The `operator` cannot be the caller.
1670      *
1671      * Emits an {ApprovalForAll} event.
1672      */
1673     function setApprovalForAll(address operator, bool _approved) external;
1674 
1675     /**
1676      * @dev Returns the account approved for `tokenId` token.
1677      *
1678      * Requirements:
1679      *
1680      * - `tokenId` must exist.
1681      */
1682     function getApproved(uint256 tokenId) external view returns (address operator);
1683 
1684     /**
1685      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1686      *
1687      * See {setApprovalForAll}.
1688      */
1689     function isApprovedForAll(address owner, address operator) external view returns (bool);
1690 
1691     // =============================================================
1692     //                        IERC721Metadata
1693     // =============================================================
1694 
1695     /**
1696      * @dev Returns the token collection name.
1697      */
1698     function name() external view returns (string memory);
1699 
1700     /**
1701      * @dev Returns the token collection symbol.
1702      */
1703     function symbol() external view returns (string memory);
1704 
1705     /**
1706      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1707      */
1708     function tokenURI(uint256 tokenId) external view returns (string memory);
1709 
1710     // =============================================================
1711     //                           IERC2309
1712     // =============================================================
1713 
1714     /**
1715      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1716      * (inclusive) is transferred from `from` to `to`, as defined in the
1717      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1718      *
1719      * See {_mintERC2309} for more details.
1720      */
1721     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1722 }
1723 
1724 // File: erc721a/contracts/ERC721A.sol
1725 
1726 
1727 // ERC721A Contracts v4.2.3
1728 // Creator: Chiru Labs
1729 
1730 pragma solidity ^0.8.4;
1731 
1732 
1733 /**
1734  * @dev Interface of ERC721 token receiver.
1735  */
1736 interface ERC721A__IERC721Receiver {
1737     function onERC721Received(
1738         address operator,
1739         address from,
1740         uint256 tokenId,
1741         bytes calldata data
1742     ) external returns (bytes4);
1743 }
1744 
1745 /**
1746  * @title ERC721A
1747  *
1748  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1749  * Non-Fungible Token Standard, including the Metadata extension.
1750  * Optimized for lower gas during batch mints.
1751  *
1752  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1753  * starting from `_startTokenId()`.
1754  *
1755  * Assumptions:
1756  *
1757  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1758  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1759  */
1760 contract ERC721A is IERC721A {
1761     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1762     struct TokenApprovalRef {
1763         address value;
1764     }
1765 
1766     // =============================================================
1767     //                           CONSTANTS
1768     // =============================================================
1769 
1770     // Mask of an entry in packed address data.
1771     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1772 
1773     // The bit position of `numberMinted` in packed address data.
1774     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1775 
1776     // The bit position of `numberBurned` in packed address data.
1777     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1778 
1779     // The bit position of `aux` in packed address data.
1780     uint256 private constant _BITPOS_AUX = 192;
1781 
1782     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1783     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1784 
1785     // The bit position of `startTimestamp` in packed ownership.
1786     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1787 
1788     // The bit mask of the `burned` bit in packed ownership.
1789     uint256 private constant _BITMASK_BURNED = 1 << 224;
1790 
1791     // The bit position of the `nextInitialized` bit in packed ownership.
1792     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1793 
1794     // The bit mask of the `nextInitialized` bit in packed ownership.
1795     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1796 
1797     // The bit position of `extraData` in packed ownership.
1798     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1799 
1800     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1801     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1802 
1803     // The mask of the lower 160 bits for addresses.
1804     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1805 
1806     // The maximum `quantity` that can be minted with {_mintERC2309}.
1807     // This limit is to prevent overflows on the address data entries.
1808     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1809     // is required to cause an overflow, which is unrealistic.
1810     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1811 
1812     // The `Transfer` event signature is given by:
1813     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1814     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1815         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1816 
1817     // =============================================================
1818     //                            STORAGE
1819     // =============================================================
1820 
1821     // The next token ID to be minted.
1822     uint256 private _currentIndex;
1823 
1824     // The number of tokens burned.
1825     uint256 private _burnCounter;
1826 
1827     // Token name
1828     string private _name;
1829 
1830     // Token symbol
1831     string private _symbol;
1832 
1833     // Mapping from token ID to ownership details
1834     // An empty struct value does not necessarily mean the token is unowned.
1835     // See {_packedOwnershipOf} implementation for details.
1836     //
1837     // Bits Layout:
1838     // - [0..159]   `addr`
1839     // - [160..223] `startTimestamp`
1840     // - [224]      `burned`
1841     // - [225]      `nextInitialized`
1842     // - [232..255] `extraData`
1843     mapping(uint256 => uint256) private _packedOwnerships;
1844 
1845     // Mapping owner address to address data.
1846     //
1847     // Bits Layout:
1848     // - [0..63]    `balance`
1849     // - [64..127]  `numberMinted`
1850     // - [128..191] `numberBurned`
1851     // - [192..255] `aux`
1852     mapping(address => uint256) private _packedAddressData;
1853 
1854     // Mapping from token ID to approved address.
1855     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1856 
1857     // Mapping from owner to operator approvals
1858     mapping(address => mapping(address => bool)) private _operatorApprovals;
1859 
1860     // =============================================================
1861     //                          CONSTRUCTOR
1862     // =============================================================
1863 
1864     constructor(string memory name_, string memory symbol_) {
1865         _name = name_;
1866         _symbol = symbol_;
1867         _currentIndex = _startTokenId();
1868     }
1869 
1870     // =============================================================
1871     //                   TOKEN COUNTING OPERATIONS
1872     // =============================================================
1873 
1874     /**
1875      * @dev Returns the starting token ID.
1876      * To change the starting token ID, please override this function.
1877      */
1878     function _startTokenId() internal view virtual returns (uint256) {
1879         return 0;
1880     }
1881 
1882     /**
1883      * @dev Returns the next token ID to be minted.
1884      */
1885     function _nextTokenId() internal view virtual returns (uint256) {
1886         return _currentIndex;
1887     }
1888 
1889     /**
1890      * @dev Returns the total number of tokens in existence.
1891      * Burned tokens will reduce the count.
1892      * To get the total number of tokens minted, please see {_totalMinted}.
1893      */
1894     function totalSupply() public view virtual override returns (uint256) {
1895         // Counter underflow is impossible as _burnCounter cannot be incremented
1896         // more than `_currentIndex - _startTokenId()` times.
1897         unchecked {
1898             return _currentIndex - _burnCounter - _startTokenId();
1899         }
1900     }
1901 
1902     /**
1903      * @dev Returns the total amount of tokens minted in the contract.
1904      */
1905     function _totalMinted() internal view virtual returns (uint256) {
1906         // Counter underflow is impossible as `_currentIndex` does not decrement,
1907         // and it is initialized to `_startTokenId()`.
1908         unchecked {
1909             return _currentIndex - _startTokenId();
1910         }
1911     }
1912 
1913     /**
1914      * @dev Returns the total number of tokens burned.
1915      */
1916     function _totalBurned() internal view virtual returns (uint256) {
1917         return _burnCounter;
1918     }
1919 
1920     // =============================================================
1921     //                    ADDRESS DATA OPERATIONS
1922     // =============================================================
1923 
1924     /**
1925      * @dev Returns the number of tokens in `owner`'s account.
1926      */
1927     function balanceOf(address owner) public view virtual override returns (uint256) {
1928         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1929         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1930     }
1931 
1932     /**
1933      * Returns the number of tokens minted by `owner`.
1934      */
1935     function _numberMinted(address owner) internal view returns (uint256) {
1936         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1937     }
1938 
1939     /**
1940      * Returns the number of tokens burned by or on behalf of `owner`.
1941      */
1942     function _numberBurned(address owner) internal view returns (uint256) {
1943         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1944     }
1945 
1946     /**
1947      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1948      */
1949     function _getAux(address owner) internal view returns (uint64) {
1950         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1951     }
1952 
1953     /**
1954      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1955      * If there are multiple variables, please pack them into a uint64.
1956      */
1957     function _setAux(address owner, uint64 aux) internal virtual {
1958         uint256 packed = _packedAddressData[owner];
1959         uint256 auxCasted;
1960         // Cast `aux` with assembly to avoid redundant masking.
1961         assembly {
1962             auxCasted := aux
1963         }
1964         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1965         _packedAddressData[owner] = packed;
1966     }
1967 
1968     // =============================================================
1969     //                            IERC165
1970     // =============================================================
1971 
1972     /**
1973      * @dev Returns true if this contract implements the interface defined by
1974      * `interfaceId`. See the corresponding
1975      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1976      * to learn more about how these ids are created.
1977      *
1978      * This function call must use less than 30000 gas.
1979      */
1980     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1981         // The interface IDs are constants representing the first 4 bytes
1982         // of the XOR of all function selectors in the interface.
1983         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1984         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1985         return
1986             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1987             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1988             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1989     }
1990 
1991     // =============================================================
1992     //                        IERC721Metadata
1993     // =============================================================
1994 
1995     /**
1996      * @dev Returns the token collection name.
1997      */
1998     function name() public view virtual override returns (string memory) {
1999         return _name;
2000     }
2001 
2002     /**
2003      * @dev Returns the token collection symbol.
2004      */
2005     function symbol() public view virtual override returns (string memory) {
2006         return _symbol;
2007     }
2008 
2009     /**
2010      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2011      */
2012     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2013         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2014 
2015         string memory baseURI = _baseURI();
2016         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2017     }
2018 
2019     /**
2020      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2021      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2022      * by default, it can be overridden in child contracts.
2023      */
2024     function _baseURI() internal view virtual returns (string memory) {
2025         return '';
2026     }
2027 
2028     // =============================================================
2029     //                     OWNERSHIPS OPERATIONS
2030     // =============================================================
2031 
2032     /**
2033      * @dev Returns the owner of the `tokenId` token.
2034      *
2035      * Requirements:
2036      *
2037      * - `tokenId` must exist.
2038      */
2039     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2040         return address(uint160(_packedOwnershipOf(tokenId)));
2041     }
2042 
2043     /**
2044      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2045      * It gradually moves to O(1) as tokens get transferred around over time.
2046      */
2047     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2048         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2049     }
2050 
2051     /**
2052      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2053      */
2054     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2055         return _unpackedOwnership(_packedOwnerships[index]);
2056     }
2057 
2058     /**
2059      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2060      */
2061     function _initializeOwnershipAt(uint256 index) internal virtual {
2062         if (_packedOwnerships[index] == 0) {
2063             _packedOwnerships[index] = _packedOwnershipOf(index);
2064         }
2065     }
2066 
2067     /**
2068      * Returns the packed ownership data of `tokenId`.
2069      */
2070     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2071         uint256 curr = tokenId;
2072 
2073         unchecked {
2074             if (_startTokenId() <= curr)
2075                 if (curr < _currentIndex) {
2076                     uint256 packed = _packedOwnerships[curr];
2077                     // If not burned.
2078                     if (packed & _BITMASK_BURNED == 0) {
2079                         // Invariant:
2080                         // There will always be an initialized ownership slot
2081                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2082                         // before an unintialized ownership slot
2083                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2084                         // Hence, `curr` will not underflow.
2085                         //
2086                         // We can directly compare the packed value.
2087                         // If the address is zero, packed will be zero.
2088                         while (packed == 0) {
2089                             packed = _packedOwnerships[--curr];
2090                         }
2091                         return packed;
2092                     }
2093                 }
2094         }
2095         revert OwnerQueryForNonexistentToken();
2096     }
2097 
2098     /**
2099      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2100      */
2101     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2102         ownership.addr = address(uint160(packed));
2103         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2104         ownership.burned = packed & _BITMASK_BURNED != 0;
2105         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2106     }
2107 
2108     /**
2109      * @dev Packs ownership data into a single uint256.
2110      */
2111     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2112         assembly {
2113             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2114             owner := and(owner, _BITMASK_ADDRESS)
2115             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2116             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2117         }
2118     }
2119 
2120     /**
2121      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2122      */
2123     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2124         // For branchless setting of the `nextInitialized` flag.
2125         assembly {
2126             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2127             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2128         }
2129     }
2130 
2131     // =============================================================
2132     //                      APPROVAL OPERATIONS
2133     // =============================================================
2134 
2135     /**
2136      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2137      * The approval is cleared when the token is transferred.
2138      *
2139      * Only a single account can be approved at a time, so approving the
2140      * zero address clears previous approvals.
2141      *
2142      * Requirements:
2143      *
2144      * - The caller must own the token or be an approved operator.
2145      * - `tokenId` must exist.
2146      *
2147      * Emits an {Approval} event.
2148      */
2149     function approve(address to, uint256 tokenId) public payable virtual override {
2150         address owner = ownerOf(tokenId);
2151 
2152         if (_msgSenderERC721A() != owner)
2153             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2154                 revert ApprovalCallerNotOwnerNorApproved();
2155             }
2156 
2157         _tokenApprovals[tokenId].value = to;
2158         emit Approval(owner, to, tokenId);
2159     }
2160 
2161     /**
2162      * @dev Returns the account approved for `tokenId` token.
2163      *
2164      * Requirements:
2165      *
2166      * - `tokenId` must exist.
2167      */
2168     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2169         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2170 
2171         return _tokenApprovals[tokenId].value;
2172     }
2173 
2174     /**
2175      * @dev Approve or remove `operator` as an operator for the caller.
2176      * Operators can call {transferFrom} or {safeTransferFrom}
2177      * for any token owned by the caller.
2178      *
2179      * Requirements:
2180      *
2181      * - The `operator` cannot be the caller.
2182      *
2183      * Emits an {ApprovalForAll} event.
2184      */
2185     function setApprovalForAll(address operator, bool approved) public virtual override {
2186         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2187         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2188     }
2189 
2190     /**
2191      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2192      *
2193      * See {setApprovalForAll}.
2194      */
2195     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2196         return _operatorApprovals[owner][operator];
2197     }
2198 
2199     /**
2200      * @dev Returns whether `tokenId` exists.
2201      *
2202      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2203      *
2204      * Tokens start existing when they are minted. See {_mint}.
2205      */
2206     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2207         return
2208             _startTokenId() <= tokenId &&
2209             tokenId < _currentIndex && // If within bounds,
2210             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2211     }
2212 
2213     /**
2214      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2215      */
2216     function _isSenderApprovedOrOwner(
2217         address approvedAddress,
2218         address owner,
2219         address msgSender
2220     ) private pure returns (bool result) {
2221         assembly {
2222             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2223             owner := and(owner, _BITMASK_ADDRESS)
2224             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2225             msgSender := and(msgSender, _BITMASK_ADDRESS)
2226             // `msgSender == owner || msgSender == approvedAddress`.
2227             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2228         }
2229     }
2230 
2231     /**
2232      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2233      */
2234     function _getApprovedSlotAndAddress(uint256 tokenId)
2235         private
2236         view
2237         returns (uint256 approvedAddressSlot, address approvedAddress)
2238     {
2239         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2240         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2241         assembly {
2242             approvedAddressSlot := tokenApproval.slot
2243             approvedAddress := sload(approvedAddressSlot)
2244         }
2245     }
2246 
2247     // =============================================================
2248     //                      TRANSFER OPERATIONS
2249     // =============================================================
2250 
2251     /**
2252      * @dev Transfers `tokenId` from `from` to `to`.
2253      *
2254      * Requirements:
2255      *
2256      * - `from` cannot be the zero address.
2257      * - `to` cannot be the zero address.
2258      * - `tokenId` token must be owned by `from`.
2259      * - If the caller is not `from`, it must be approved to move this token
2260      * by either {approve} or {setApprovalForAll}.
2261      *
2262      * Emits a {Transfer} event.
2263      */
2264     function transferFrom(
2265         address from,
2266         address to,
2267         uint256 tokenId
2268     ) public payable virtual override {
2269         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2270 
2271         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2272 
2273         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2274 
2275         // The nested ifs save around 20+ gas over a compound boolean condition.
2276         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2277             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2278 
2279         if (to == address(0)) revert TransferToZeroAddress();
2280 
2281         _beforeTokenTransfers(from, to, tokenId, 1);
2282 
2283         // Clear approvals from the previous owner.
2284         assembly {
2285             if approvedAddress {
2286                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2287                 sstore(approvedAddressSlot, 0)
2288             }
2289         }
2290 
2291         // Underflow of the sender's balance is impossible because we check for
2292         // ownership above and the recipient's balance can't realistically overflow.
2293         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2294         unchecked {
2295             // We can directly increment and decrement the balances.
2296             --_packedAddressData[from]; // Updates: `balance -= 1`.
2297             ++_packedAddressData[to]; // Updates: `balance += 1`.
2298 
2299             // Updates:
2300             // - `address` to the next owner.
2301             // - `startTimestamp` to the timestamp of transfering.
2302             // - `burned` to `false`.
2303             // - `nextInitialized` to `true`.
2304             _packedOwnerships[tokenId] = _packOwnershipData(
2305                 to,
2306                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2307             );
2308 
2309             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2310             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2311                 uint256 nextTokenId = tokenId + 1;
2312                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2313                 if (_packedOwnerships[nextTokenId] == 0) {
2314                     // If the next slot is within bounds.
2315                     if (nextTokenId != _currentIndex) {
2316                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2317                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2318                     }
2319                 }
2320             }
2321         }
2322 
2323         emit Transfer(from, to, tokenId);
2324         _afterTokenTransfers(from, to, tokenId, 1);
2325     }
2326 
2327     /**
2328      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2329      */
2330     function safeTransferFrom(
2331         address from,
2332         address to,
2333         uint256 tokenId
2334     ) public payable virtual override {
2335         safeTransferFrom(from, to, tokenId, '');
2336     }
2337 
2338     /**
2339      * @dev Safely transfers `tokenId` token from `from` to `to`.
2340      *
2341      * Requirements:
2342      *
2343      * - `from` cannot be the zero address.
2344      * - `to` cannot be the zero address.
2345      * - `tokenId` token must exist and be owned by `from`.
2346      * - If the caller is not `from`, it must be approved to move this token
2347      * by either {approve} or {setApprovalForAll}.
2348      * - If `to` refers to a smart contract, it must implement
2349      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2350      *
2351      * Emits a {Transfer} event.
2352      */
2353     function safeTransferFrom(
2354         address from,
2355         address to,
2356         uint256 tokenId,
2357         bytes memory _data
2358     ) public payable virtual override {
2359         transferFrom(from, to, tokenId);
2360         if (to.code.length != 0)
2361             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2362                 revert TransferToNonERC721ReceiverImplementer();
2363             }
2364     }
2365 
2366     /**
2367      * @dev Hook that is called before a set of serially-ordered token IDs
2368      * are about to be transferred. This includes minting.
2369      * And also called before burning one token.
2370      *
2371      * `startTokenId` - the first token ID to be transferred.
2372      * `quantity` - the amount to be transferred.
2373      *
2374      * Calling conditions:
2375      *
2376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2377      * transferred to `to`.
2378      * - When `from` is zero, `tokenId` will be minted for `to`.
2379      * - When `to` is zero, `tokenId` will be burned by `from`.
2380      * - `from` and `to` are never both zero.
2381      */
2382     function _beforeTokenTransfers(
2383         address from,
2384         address to,
2385         uint256 startTokenId,
2386         uint256 quantity
2387     ) internal virtual {}
2388 
2389     /**
2390      * @dev Hook that is called after a set of serially-ordered token IDs
2391      * have been transferred. This includes minting.
2392      * And also called after one token has been burned.
2393      *
2394      * `startTokenId` - the first token ID to be transferred.
2395      * `quantity` - the amount to be transferred.
2396      *
2397      * Calling conditions:
2398      *
2399      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2400      * transferred to `to`.
2401      * - When `from` is zero, `tokenId` has been minted for `to`.
2402      * - When `to` is zero, `tokenId` has been burned by `from`.
2403      * - `from` and `to` are never both zero.
2404      */
2405     function _afterTokenTransfers(
2406         address from,
2407         address to,
2408         uint256 startTokenId,
2409         uint256 quantity
2410     ) internal virtual {}
2411 
2412     /**
2413      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2414      *
2415      * `from` - Previous owner of the given token ID.
2416      * `to` - Target address that will receive the token.
2417      * `tokenId` - Token ID to be transferred.
2418      * `_data` - Optional data to send along with the call.
2419      *
2420      * Returns whether the call correctly returned the expected magic value.
2421      */
2422     function _checkContractOnERC721Received(
2423         address from,
2424         address to,
2425         uint256 tokenId,
2426         bytes memory _data
2427     ) private returns (bool) {
2428         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2429             bytes4 retval
2430         ) {
2431             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2432         } catch (bytes memory reason) {
2433             if (reason.length == 0) {
2434                 revert TransferToNonERC721ReceiverImplementer();
2435             } else {
2436                 assembly {
2437                     revert(add(32, reason), mload(reason))
2438                 }
2439             }
2440         }
2441     }
2442 
2443     // =============================================================
2444     //                        MINT OPERATIONS
2445     // =============================================================
2446 
2447     /**
2448      * @dev Mints `quantity` tokens and transfers them to `to`.
2449      *
2450      * Requirements:
2451      *
2452      * - `to` cannot be the zero address.
2453      * - `quantity` must be greater than 0.
2454      *
2455      * Emits a {Transfer} event for each mint.
2456      */
2457     function _mint(address to, uint256 quantity) internal virtual {
2458         uint256 startTokenId = _currentIndex;
2459         if (quantity == 0) revert MintZeroQuantity();
2460 
2461         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2462 
2463         // Overflows are incredibly unrealistic.
2464         // `balance` and `numberMinted` have a maximum limit of 2**64.
2465         // `tokenId` has a maximum limit of 2**256.
2466         unchecked {
2467             // Updates:
2468             // - `balance += quantity`.
2469             // - `numberMinted += quantity`.
2470             //
2471             // We can directly add to the `balance` and `numberMinted`.
2472             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2473 
2474             // Updates:
2475             // - `address` to the owner.
2476             // - `startTimestamp` to the timestamp of minting.
2477             // - `burned` to `false`.
2478             // - `nextInitialized` to `quantity == 1`.
2479             _packedOwnerships[startTokenId] = _packOwnershipData(
2480                 to,
2481                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2482             );
2483 
2484             uint256 toMasked;
2485             uint256 end = startTokenId + quantity;
2486 
2487             // Use assembly to loop and emit the `Transfer` event for gas savings.
2488             // The duplicated `log4` removes an extra check and reduces stack juggling.
2489             // The assembly, together with the surrounding Solidity code, have been
2490             // delicately arranged to nudge the compiler into producing optimized opcodes.
2491             assembly {
2492                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2493                 toMasked := and(to, _BITMASK_ADDRESS)
2494                 // Emit the `Transfer` event.
2495                 log4(
2496                     0, // Start of data (0, since no data).
2497                     0, // End of data (0, since no data).
2498                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2499                     0, // `address(0)`.
2500                     toMasked, // `to`.
2501                     startTokenId // `tokenId`.
2502                 )
2503 
2504                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2505                 // that overflows uint256 will make the loop run out of gas.
2506                 // The compiler will optimize the `iszero` away for performance.
2507                 for {
2508                     let tokenId := add(startTokenId, 1)
2509                 } iszero(eq(tokenId, end)) {
2510                     tokenId := add(tokenId, 1)
2511                 } {
2512                     // Emit the `Transfer` event. Similar to above.
2513                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2514                 }
2515             }
2516             if (toMasked == 0) revert MintToZeroAddress();
2517 
2518             _currentIndex = end;
2519         }
2520         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2521     }
2522 
2523     /**
2524      * @dev Mints `quantity` tokens and transfers them to `to`.
2525      *
2526      * This function is intended for efficient minting only during contract creation.
2527      *
2528      * It emits only one {ConsecutiveTransfer} as defined in
2529      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2530      * instead of a sequence of {Transfer} event(s).
2531      *
2532      * Calling this function outside of contract creation WILL make your contract
2533      * non-compliant with the ERC721 standard.
2534      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2535      * {ConsecutiveTransfer} event is only permissible during contract creation.
2536      *
2537      * Requirements:
2538      *
2539      * - `to` cannot be the zero address.
2540      * - `quantity` must be greater than 0.
2541      *
2542      * Emits a {ConsecutiveTransfer} event.
2543      */
2544     function _mintERC2309(address to, uint256 quantity) internal virtual {
2545         uint256 startTokenId = _currentIndex;
2546         if (to == address(0)) revert MintToZeroAddress();
2547         if (quantity == 0) revert MintZeroQuantity();
2548         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2549 
2550         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2551 
2552         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2553         unchecked {
2554             // Updates:
2555             // - `balance += quantity`.
2556             // - `numberMinted += quantity`.
2557             //
2558             // We can directly add to the `balance` and `numberMinted`.
2559             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2560 
2561             // Updates:
2562             // - `address` to the owner.
2563             // - `startTimestamp` to the timestamp of minting.
2564             // - `burned` to `false`.
2565             // - `nextInitialized` to `quantity == 1`.
2566             _packedOwnerships[startTokenId] = _packOwnershipData(
2567                 to,
2568                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2569             );
2570 
2571             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2572 
2573             _currentIndex = startTokenId + quantity;
2574         }
2575         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2576     }
2577 
2578     /**
2579      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2580      *
2581      * Requirements:
2582      *
2583      * - If `to` refers to a smart contract, it must implement
2584      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2585      * - `quantity` must be greater than 0.
2586      *
2587      * See {_mint}.
2588      *
2589      * Emits a {Transfer} event for each mint.
2590      */
2591     function _safeMint(
2592         address to,
2593         uint256 quantity,
2594         bytes memory _data
2595     ) internal virtual {
2596         _mint(to, quantity);
2597 
2598         unchecked {
2599             if (to.code.length != 0) {
2600                 uint256 end = _currentIndex;
2601                 uint256 index = end - quantity;
2602                 do {
2603                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2604                         revert TransferToNonERC721ReceiverImplementer();
2605                     }
2606                 } while (index < end);
2607                 // Reentrancy protection.
2608                 if (_currentIndex != end) revert();
2609             }
2610         }
2611     }
2612 
2613     /**
2614      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2615      */
2616     function _safeMint(address to, uint256 quantity) internal virtual {
2617         _safeMint(to, quantity, '');
2618     }
2619 
2620     // =============================================================
2621     //                        BURN OPERATIONS
2622     // =============================================================
2623 
2624     /**
2625      * @dev Equivalent to `_burn(tokenId, false)`.
2626      */
2627     function _burn(uint256 tokenId) internal virtual {
2628         _burn(tokenId, false);
2629     }
2630 
2631     /**
2632      * @dev Destroys `tokenId`.
2633      * The approval is cleared when the token is burned.
2634      *
2635      * Requirements:
2636      *
2637      * - `tokenId` must exist.
2638      *
2639      * Emits a {Transfer} event.
2640      */
2641     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2642         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2643 
2644         address from = address(uint160(prevOwnershipPacked));
2645 
2646         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2647 
2648         if (approvalCheck) {
2649             // The nested ifs save around 20+ gas over a compound boolean condition.
2650             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2651                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2652         }
2653 
2654         _beforeTokenTransfers(from, address(0), tokenId, 1);
2655 
2656         // Clear approvals from the previous owner.
2657         assembly {
2658             if approvedAddress {
2659                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2660                 sstore(approvedAddressSlot, 0)
2661             }
2662         }
2663 
2664         // Underflow of the sender's balance is impossible because we check for
2665         // ownership above and the recipient's balance can't realistically overflow.
2666         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2667         unchecked {
2668             // Updates:
2669             // - `balance -= 1`.
2670             // - `numberBurned += 1`.
2671             //
2672             // We can directly decrement the balance, and increment the number burned.
2673             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2674             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2675 
2676             // Updates:
2677             // - `address` to the last owner.
2678             // - `startTimestamp` to the timestamp of burning.
2679             // - `burned` to `true`.
2680             // - `nextInitialized` to `true`.
2681             _packedOwnerships[tokenId] = _packOwnershipData(
2682                 from,
2683                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2684             );
2685 
2686             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2687             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2688                 uint256 nextTokenId = tokenId + 1;
2689                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2690                 if (_packedOwnerships[nextTokenId] == 0) {
2691                     // If the next slot is within bounds.
2692                     if (nextTokenId != _currentIndex) {
2693                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2694                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2695                     }
2696                 }
2697             }
2698         }
2699 
2700         emit Transfer(from, address(0), tokenId);
2701         _afterTokenTransfers(from, address(0), tokenId, 1);
2702 
2703         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2704         unchecked {
2705             _burnCounter++;
2706         }
2707     }
2708 
2709     // =============================================================
2710     //                     EXTRA DATA OPERATIONS
2711     // =============================================================
2712 
2713     /**
2714      * @dev Directly sets the extra data for the ownership data `index`.
2715      */
2716     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2717         uint256 packed = _packedOwnerships[index];
2718         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2719         uint256 extraDataCasted;
2720         // Cast `extraData` with assembly to avoid redundant masking.
2721         assembly {
2722             extraDataCasted := extraData
2723         }
2724         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2725         _packedOwnerships[index] = packed;
2726     }
2727 
2728     /**
2729      * @dev Called during each token transfer to set the 24bit `extraData` field.
2730      * Intended to be overridden by the cosumer contract.
2731      *
2732      * `previousExtraData` - the value of `extraData` before transfer.
2733      *
2734      * Calling conditions:
2735      *
2736      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2737      * transferred to `to`.
2738      * - When `from` is zero, `tokenId` will be minted for `to`.
2739      * - When `to` is zero, `tokenId` will be burned by `from`.
2740      * - `from` and `to` are never both zero.
2741      */
2742     function _extraData(
2743         address from,
2744         address to,
2745         uint24 previousExtraData
2746     ) internal view virtual returns (uint24) {}
2747 
2748     /**
2749      * @dev Returns the next extra data for the packed ownership data.
2750      * The returned result is shifted into position.
2751      */
2752     function _nextExtraData(
2753         address from,
2754         address to,
2755         uint256 prevOwnershipPacked
2756     ) private view returns (uint256) {
2757         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2758         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2759     }
2760 
2761     // =============================================================
2762     //                       OTHER OPERATIONS
2763     // =============================================================
2764 
2765     /**
2766      * @dev Returns the message sender (defaults to `msg.sender`).
2767      *
2768      * If you are writing GSN compatible contracts, you need to override this function.
2769      */
2770     function _msgSenderERC721A() internal view virtual returns (address) {
2771         return msg.sender;
2772     }
2773 
2774     /**
2775      * @dev Converts a uint256 to its ASCII string decimal representation.
2776      */
2777     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2778         assembly {
2779             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2780             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2781             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2782             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2783             let m := add(mload(0x40), 0xa0)
2784             // Update the free memory pointer to allocate.
2785             mstore(0x40, m)
2786             // Assign the `str` to the end.
2787             str := sub(m, 0x20)
2788             // Zeroize the slot after the string.
2789             mstore(str, 0)
2790 
2791             // Cache the end of the memory to calculate the length later.
2792             let end := str
2793 
2794             // We write the string from rightmost digit to leftmost digit.
2795             // The following is essentially a do-while loop that also handles the zero case.
2796             // prettier-ignore
2797             for { let temp := value } 1 {} {
2798                 str := sub(str, 1)
2799                 // Write the character to the pointer.
2800                 // The ASCII index of the '0' character is 48.
2801                 mstore8(str, add(48, mod(temp, 10)))
2802                 // Keep dividing `temp` until zero.
2803                 temp := div(temp, 10)
2804                 // prettier-ignore
2805                 if iszero(temp) { break }
2806             }
2807 
2808             let length := sub(end, str)
2809             // Move the pointer 32 bytes leftwards to make room for the length.
2810             str := sub(str, 0x20)
2811             // Store the length.
2812             mstore(str, length)
2813         }
2814     }
2815 }
2816 
2817 // File: contracts/oddboinft.sol
2818 
2819 
2820 pragma solidity ^0.8.17;
2821 
2822 
2823 
2824 
2825 
2826 
2827 
2828 
2829 
2830 contract oDDBOiNFT is ERC721A, IERC2981, Ownable, DefaultOperatorFilterer{
2831    using Strings for uint256;
2832 
2833    error TokenDoesNotExist(uint256 id);
2834 
2835    uint256 public MAX_SUPPLY = 999;
2836    uint256 public MAX_PUB_MINT = 5;
2837    uint256 public MAX_WL_MINT = 1;
2838    address public Royalty;
2839 
2840 
2841    string private baseTokenUri;
2842    string public  placeholderTokenUri;
2843 
2844    mapping(address => bool) public hasClaimed;
2845 
2846    bool public isRevealed;
2847    bool public publicSale;
2848    bool public whiteListSale;
2849    bool public pause;
2850 
2851    bytes32 private merkleRoot;
2852 
2853 
2854    mapping(address => uint256) public totalPublicMint;
2855    mapping(address => uint256) public totalWhitelistMint;
2856 
2857    constructor() ERC721A("oddBOi", "oddBOi"){}
2858 
2859    modifier callerIsUser() {
2860        require(tx.origin == msg.sender, "oddBOi :: Cannot be called by a contract");
2861        _;
2862    }
2863 
2864    function mint(uint256 _quantity) external callerIsUser {
2865        require(publicSale, "oddBOi :: Not Yet Active.");
2866        require((totalSupply() + _quantity) <= MAX_SUPPLY, "oddBOi :: PUBLIC SOLDOUT");
2867        require((totalPublicMint[msg.sender] + _quantity) <= MAX_PUB_MINT, "oddBOi :: Minting this many would put you over 5 in public mint!");
2868 
2869 
2870        totalPublicMint[msg.sender] += _quantity;
2871        _mint(msg.sender, _quantity);
2872    }
2873 
2874    function whitelistMint(bytes32[] memory _merkleProof, uint256 _quantity) external payable callerIsUser{
2875        require(whiteListSale, "oddBOi :: Minting is on Pause");
2876        require((totalSupply() + _quantity) <= MAX_SUPPLY, "oddBOi :: PUBLIC SOLDOUT");
2877        require((totalWhitelistMint[msg.sender] + _quantity) <= MAX_WL_MINT, "you can only mint 1 on WL");
2878 
2879 
2880        // //create leaf node
2881        bytes32 sender = keccak256(abi.encodePacked(msg.sender));
2882        require(MerkleProof.verify(_merkleProof, merkleRoot, sender), "oddBOi :: You are not whitelisted");
2883 
2884        totalWhitelistMint[msg.sender] += _quantity;
2885        _mint(msg.sender, _quantity);
2886    }
2887 
2888 
2889    function _baseURI() internal view virtual override returns (string memory) {
2890        return baseTokenUri;
2891    }
2892 
2893    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2894        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2895 
2896        uint256 trueId = tokenId + 1;
2897 
2898        if(!isRevealed){
2899            return placeholderTokenUri;
2900        }
2901       
2902        return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, trueId.toString(), ".json")) : "";
2903    }
2904 
2905    function teamMint(uint256 quantity) external onlyOwner{
2906        require((totalSupply() + quantity) <= MAX_SUPPLY, "oddBOi :: PUBLIC SOLDOUT");
2907        _safeMint(msg.sender, quantity);
2908    }
2909 
2910    function setTokenUri(string calldata _baseTokenUri) external onlyOwner{
2911        baseTokenUri = _baseTokenUri;
2912    }
2913 
2914    function setMaxSupply(uint256 _MAX_SUPPLY) external onlyOwner{
2915        MAX_SUPPLY = _MAX_SUPPLY;
2916    }
2917   
2918    function setPlaceHolderUri(string calldata _placeholderTokenUri) external onlyOwner{
2919        placeholderTokenUri = _placeholderTokenUri;
2920    }
2921 
2922     function RoyaltyReciever(address _Royalty)external onlyOwner{
2923        Royalty = _Royalty;
2924    }
2925 
2926    function toggleWhiteListSale() external onlyOwner{
2927        whiteListSale = !whiteListSale;
2928    }
2929 
2930    function togglePublicSale() external onlyOwner{
2931        publicSale = !publicSale;
2932    }
2933 
2934    function toggleReveal() external onlyOwner{
2935        isRevealed = !isRevealed;
2936    }
2937 
2938    function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
2939        merkleRoot = _merkleRoot;
2940    }
2941 
2942    function getMerkleRoot() external view returns (bytes32){
2943        return merkleRoot;
2944    }
2945 
2946 
2947    function withdraw() external onlyOwner{
2948        payable(msg.sender).transfer(address(this).balance);
2949    }
2950 
2951        /* ERC 2891 */
2952    function royaltyInfo(uint256 tokenId, uint256 salePrice)
2953        external
2954        view
2955        override
2956        returns (address receiver, uint256 royaltyAmount)
2957    {
2958        if (!_exists(tokenId)) {
2959            revert TokenDoesNotExist(tokenId);
2960        }
2961 
2962        return (address(Royalty), SafeMath.div(SafeMath.mul(salePrice, 5), 100));
2963    }
2964 
2965    function supportsInterface(bytes4 interfaceId) public view override(ERC721A, IERC165) returns (bool) {
2966        return _supportsInterface(interfaceId);
2967    }
2968 
2969    function _supportsInterface(bytes4 interfaceId) private view returns (bool) {
2970        return
2971            interfaceId == type(IERC721).interfaceId ||
2972            interfaceId == type(IERC2981).interfaceId ||
2973            interfaceId == type(Ownable).interfaceId ||
2974            super.supportsInterface(interfaceId);
2975    }
2976 
2977    //opensea registry
2978        function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2979        super.setApprovalForAll(operator, approved);
2980    }
2981 
2982    function approve(address operator, uint256 tokenId) public override payable onlyAllowedOperatorApproval(operator) {
2983        super.approve(operator, tokenId);
2984    }
2985 
2986    function transferFrom(address from, address to, uint256 tokenId) public override payable onlyAllowedOperator(from) {
2987        super.transferFrom(from, to, tokenId);
2988    }
2989 
2990    function safeTransferFrom(address from, address to, uint256 tokenId) public override payable onlyAllowedOperator(from) {
2991        super.safeTransferFrom(from, to, tokenId);
2992    }
2993 
2994    function safeTransferFrom (address from, address to, uint256 tokenId, bytes memory data)
2995        public payable
2996        override
2997        onlyAllowedOperator(from)
2998    {
2999        super.safeTransferFrom(from, to, tokenId, data);
3000    }
3001 }