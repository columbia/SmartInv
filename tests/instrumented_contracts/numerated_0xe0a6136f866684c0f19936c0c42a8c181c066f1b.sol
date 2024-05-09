1 // File: @openzeppelin/contracts@4.9.0/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts@4.9.0/interfaces/IERC5267.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC5267.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 interface IERC5267 {
55     /**
56      * @dev MAY be emitted to signal that the domain could have changed.
57      */
58     event EIP712DomainChanged();
59 
60     /**
61      * @dev returns the fields and values that describe the domain separator used by this contract for EIP-712
62      * signature.
63      */
64     function eip712Domain()
65         external
66         view
67         returns (
68             bytes1 fields,
69             string memory name,
70             string memory version,
71             uint256 chainId,
72             address verifyingContract,
73             bytes32 salt,
74             uint256[] memory extensions
75         );
76 }
77 
78 // File: @openzeppelin/contracts@4.9.0/utils/StorageSlot.sol
79 
80 
81 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
82 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
83 
84 pragma solidity ^0.8.0;
85 
86 /**
87  * @dev Library for reading and writing primitive types to specific storage slots.
88  *
89  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
90  * This library helps with reading and writing to such slots without the need for inline assembly.
91  *
92  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
93  *
94  * Example usage to set ERC1967 implementation slot:
95  * ```solidity
96  * contract ERC1967 {
97  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
98  *
99  *     function _getImplementation() internal view returns (address) {
100  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
101  *     }
102  *
103  *     function _setImplementation(address newImplementation) internal {
104  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
105  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
106  *     }
107  * }
108  * ```
109  *
110  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
111  * _Available since v4.9 for `string`, `bytes`._
112  */
113 library StorageSlot {
114     struct AddressSlot {
115         address value;
116     }
117 
118     struct BooleanSlot {
119         bool value;
120     }
121 
122     struct Bytes32Slot {
123         bytes32 value;
124     }
125 
126     struct Uint256Slot {
127         uint256 value;
128     }
129 
130     struct StringSlot {
131         string value;
132     }
133 
134     struct BytesSlot {
135         bytes value;
136     }
137 
138     /**
139      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
140      */
141     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
142         /// @solidity memory-safe-assembly
143         assembly {
144             r.slot := slot
145         }
146     }
147 
148     /**
149      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
150      */
151     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
152         /// @solidity memory-safe-assembly
153         assembly {
154             r.slot := slot
155         }
156     }
157 
158     /**
159      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
160      */
161     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
162         /// @solidity memory-safe-assembly
163         assembly {
164             r.slot := slot
165         }
166     }
167 
168     /**
169      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
170      */
171     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
172         /// @solidity memory-safe-assembly
173         assembly {
174             r.slot := slot
175         }
176     }
177 
178     /**
179      * @dev Returns an `StringSlot` with member `value` located at `slot`.
180      */
181     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
182         /// @solidity memory-safe-assembly
183         assembly {
184             r.slot := slot
185         }
186     }
187 
188     /**
189      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
190      */
191     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
192         /// @solidity memory-safe-assembly
193         assembly {
194             r.slot := store.slot
195         }
196     }
197 
198     /**
199      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
200      */
201     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
202         /// @solidity memory-safe-assembly
203         assembly {
204             r.slot := slot
205         }
206     }
207 
208     /**
209      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
210      */
211     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
212         /// @solidity memory-safe-assembly
213         assembly {
214             r.slot := store.slot
215         }
216     }
217 }
218 
219 // File: @openzeppelin/contracts@4.9.0/utils/ShortStrings.sol
220 
221 
222 // OpenZeppelin Contracts (last updated v4.9.0) (utils/ShortStrings.sol)
223 
224 pragma solidity ^0.8.8;
225 
226 
227 // | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
228 // | length  | 0x                                                              BB |
229 type ShortString is bytes32;
230 
231 /**
232  * @dev This library provides functions to convert short memory strings
233  * into a `ShortString` type that can be used as an immutable variable.
234  *
235  * Strings of arbitrary length can be optimized using this library if
236  * they are short enough (up to 31 bytes) by packing them with their
237  * length (1 byte) in a single EVM word (32 bytes). Additionally, a
238  * fallback mechanism can be used for every other case.
239  *
240  * Usage example:
241  *
242  * ```solidity
243  * contract Named {
244  *     using ShortStrings for *;
245  *
246  *     ShortString private immutable _name;
247  *     string private _nameFallback;
248  *
249  *     constructor(string memory contractName) {
250  *         _name = contractName.toShortStringWithFallback(_nameFallback);
251  *     }
252  *
253  *     function name() external view returns (string memory) {
254  *         return _name.toStringWithFallback(_nameFallback);
255  *     }
256  * }
257  * ```
258  */
259 library ShortStrings {
260     // Used as an identifier for strings longer than 31 bytes.
261     bytes32 private constant _FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;
262 
263     error StringTooLong(string str);
264     error InvalidShortString();
265 
266     /**
267      * @dev Encode a string of at most 31 chars into a `ShortString`.
268      *
269      * This will trigger a `StringTooLong` error is the input string is too long.
270      */
271     function toShortString(string memory str) internal pure returns (ShortString) {
272         bytes memory bstr = bytes(str);
273         if (bstr.length > 31) {
274             revert StringTooLong(str);
275         }
276         return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
277     }
278 
279     /**
280      * @dev Decode a `ShortString` back to a "normal" string.
281      */
282     function toString(ShortString sstr) internal pure returns (string memory) {
283         uint256 len = byteLength(sstr);
284         // using `new string(len)` would work locally but is not memory safe.
285         string memory str = new string(32);
286         /// @solidity memory-safe-assembly
287         assembly {
288             mstore(str, len)
289             mstore(add(str, 0x20), sstr)
290         }
291         return str;
292     }
293 
294     /**
295      * @dev Return the length of a `ShortString`.
296      */
297     function byteLength(ShortString sstr) internal pure returns (uint256) {
298         uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;
299         if (result > 31) {
300             revert InvalidShortString();
301         }
302         return result;
303     }
304 
305     /**
306      * @dev Encode a string into a `ShortString`, or write it to storage if it is too long.
307      */
308     function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {
309         if (bytes(value).length < 32) {
310             return toShortString(value);
311         } else {
312             StorageSlot.getStringSlot(store).value = value;
313             return ShortString.wrap(_FALLBACK_SENTINEL);
314         }
315     }
316 
317     /**
318      * @dev Decode a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
319      */
320     function toStringWithFallback(ShortString value, string storage store) internal pure returns (string memory) {
321         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
322             return toString(value);
323         } else {
324             return store;
325         }
326     }
327 
328     /**
329      * @dev Return the length of a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
330      *
331      * WARNING: This will return the "byte length" of the string. This may not reflect the actual length in terms of
332      * actual characters as the UTF-8 encoding of a single character can span over multiple bytes.
333      */
334     function byteLengthWithFallback(ShortString value, string storage store) internal view returns (uint256) {
335         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
336             return byteLength(value);
337         } else {
338             return bytes(store).length;
339         }
340     }
341 }
342 
343 // File: @openzeppelin/contracts@4.9.0/utils/math/SignedMath.sol
344 
345 
346 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev Standard signed math utilities missing in the Solidity language.
352  */
353 library SignedMath {
354     /**
355      * @dev Returns the largest of two signed numbers.
356      */
357     function max(int256 a, int256 b) internal pure returns (int256) {
358         return a > b ? a : b;
359     }
360 
361     /**
362      * @dev Returns the smallest of two signed numbers.
363      */
364     function min(int256 a, int256 b) internal pure returns (int256) {
365         return a < b ? a : b;
366     }
367 
368     /**
369      * @dev Returns the average of two signed numbers without overflow.
370      * The result is rounded towards zero.
371      */
372     function average(int256 a, int256 b) internal pure returns (int256) {
373         // Formula from the book "Hacker's Delight"
374         int256 x = (a & b) + ((a ^ b) >> 1);
375         return x + (int256(uint256(x) >> 255) & (a ^ b));
376     }
377 
378     /**
379      * @dev Returns the absolute unsigned value of a signed value.
380      */
381     function abs(int256 n) internal pure returns (uint256) {
382         unchecked {
383             // must be unchecked in order to support `n = type(int256).min`
384             return uint256(n >= 0 ? n : -n);
385         }
386     }
387 }
388 
389 // File: @openzeppelin/contracts@4.9.0/utils/math/Math.sol
390 
391 
392 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
393 
394 pragma solidity ^0.8.0;
395 
396 /**
397  * @dev Standard math utilities missing in the Solidity language.
398  */
399 library Math {
400     enum Rounding {
401         Down, // Toward negative infinity
402         Up, // Toward infinity
403         Zero // Toward zero
404     }
405 
406     /**
407      * @dev Returns the largest of two numbers.
408      */
409     function max(uint256 a, uint256 b) internal pure returns (uint256) {
410         return a > b ? a : b;
411     }
412 
413     /**
414      * @dev Returns the smallest of two numbers.
415      */
416     function min(uint256 a, uint256 b) internal pure returns (uint256) {
417         return a < b ? a : b;
418     }
419 
420     /**
421      * @dev Returns the average of two numbers. The result is rounded towards
422      * zero.
423      */
424     function average(uint256 a, uint256 b) internal pure returns (uint256) {
425         // (a + b) / 2 can overflow.
426         return (a & b) + (a ^ b) / 2;
427     }
428 
429     /**
430      * @dev Returns the ceiling of the division of two numbers.
431      *
432      * This differs from standard division with `/` in that it rounds up instead
433      * of rounding down.
434      */
435     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
436         // (a + b - 1) / b can overflow on addition, so we distribute.
437         return a == 0 ? 0 : (a - 1) / b + 1;
438     }
439 
440     /**
441      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
442      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
443      * with further edits by Uniswap Labs also under MIT license.
444      */
445     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
446         unchecked {
447             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
448             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
449             // variables such that product = prod1 * 2^256 + prod0.
450             uint256 prod0; // Least significant 256 bits of the product
451             uint256 prod1; // Most significant 256 bits of the product
452             assembly {
453                 let mm := mulmod(x, y, not(0))
454                 prod0 := mul(x, y)
455                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
456             }
457 
458             // Handle non-overflow cases, 256 by 256 division.
459             if (prod1 == 0) {
460                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
461                 // The surrounding unchecked block does not change this fact.
462                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
463                 return prod0 / denominator;
464             }
465 
466             // Make sure the result is less than 2^256. Also prevents denominator == 0.
467             require(denominator > prod1, "Math: mulDiv overflow");
468 
469             ///////////////////////////////////////////////
470             // 512 by 256 division.
471             ///////////////////////////////////////////////
472 
473             // Make division exact by subtracting the remainder from [prod1 prod0].
474             uint256 remainder;
475             assembly {
476                 // Compute remainder using mulmod.
477                 remainder := mulmod(x, y, denominator)
478 
479                 // Subtract 256 bit number from 512 bit number.
480                 prod1 := sub(prod1, gt(remainder, prod0))
481                 prod0 := sub(prod0, remainder)
482             }
483 
484             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
485             // See https://cs.stackexchange.com/q/138556/92363.
486 
487             // Does not overflow because the denominator cannot be zero at this stage in the function.
488             uint256 twos = denominator & (~denominator + 1);
489             assembly {
490                 // Divide denominator by twos.
491                 denominator := div(denominator, twos)
492 
493                 // Divide [prod1 prod0] by twos.
494                 prod0 := div(prod0, twos)
495 
496                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
497                 twos := add(div(sub(0, twos), twos), 1)
498             }
499 
500             // Shift in bits from prod1 into prod0.
501             prod0 |= prod1 * twos;
502 
503             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
504             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
505             // four bits. That is, denominator * inv = 1 mod 2^4.
506             uint256 inverse = (3 * denominator) ^ 2;
507 
508             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
509             // in modular arithmetic, doubling the correct bits in each step.
510             inverse *= 2 - denominator * inverse; // inverse mod 2^8
511             inverse *= 2 - denominator * inverse; // inverse mod 2^16
512             inverse *= 2 - denominator * inverse; // inverse mod 2^32
513             inverse *= 2 - denominator * inverse; // inverse mod 2^64
514             inverse *= 2 - denominator * inverse; // inverse mod 2^128
515             inverse *= 2 - denominator * inverse; // inverse mod 2^256
516 
517             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
518             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
519             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
520             // is no longer required.
521             result = prod0 * inverse;
522             return result;
523         }
524     }
525 
526     /**
527      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
528      */
529     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
530         uint256 result = mulDiv(x, y, denominator);
531         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
532             result += 1;
533         }
534         return result;
535     }
536 
537     /**
538      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
539      *
540      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
541      */
542     function sqrt(uint256 a) internal pure returns (uint256) {
543         if (a == 0) {
544             return 0;
545         }
546 
547         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
548         //
549         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
550         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
551         //
552         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
553         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
554         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
555         //
556         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
557         uint256 result = 1 << (log2(a) >> 1);
558 
559         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
560         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
561         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
562         // into the expected uint128 result.
563         unchecked {
564             result = (result + a / result) >> 1;
565             result = (result + a / result) >> 1;
566             result = (result + a / result) >> 1;
567             result = (result + a / result) >> 1;
568             result = (result + a / result) >> 1;
569             result = (result + a / result) >> 1;
570             result = (result + a / result) >> 1;
571             return min(result, a / result);
572         }
573     }
574 
575     /**
576      * @notice Calculates sqrt(a), following the selected rounding direction.
577      */
578     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
579         unchecked {
580             uint256 result = sqrt(a);
581             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
582         }
583     }
584 
585     /**
586      * @dev Return the log in base 2, rounded down, of a positive value.
587      * Returns 0 if given 0.
588      */
589     function log2(uint256 value) internal pure returns (uint256) {
590         uint256 result = 0;
591         unchecked {
592             if (value >> 128 > 0) {
593                 value >>= 128;
594                 result += 128;
595             }
596             if (value >> 64 > 0) {
597                 value >>= 64;
598                 result += 64;
599             }
600             if (value >> 32 > 0) {
601                 value >>= 32;
602                 result += 32;
603             }
604             if (value >> 16 > 0) {
605                 value >>= 16;
606                 result += 16;
607             }
608             if (value >> 8 > 0) {
609                 value >>= 8;
610                 result += 8;
611             }
612             if (value >> 4 > 0) {
613                 value >>= 4;
614                 result += 4;
615             }
616             if (value >> 2 > 0) {
617                 value >>= 2;
618                 result += 2;
619             }
620             if (value >> 1 > 0) {
621                 result += 1;
622             }
623         }
624         return result;
625     }
626 
627     /**
628      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
629      * Returns 0 if given 0.
630      */
631     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
632         unchecked {
633             uint256 result = log2(value);
634             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
635         }
636     }
637 
638     /**
639      * @dev Return the log in base 10, rounded down, of a positive value.
640      * Returns 0 if given 0.
641      */
642     function log10(uint256 value) internal pure returns (uint256) {
643         uint256 result = 0;
644         unchecked {
645             if (value >= 10 ** 64) {
646                 value /= 10 ** 64;
647                 result += 64;
648             }
649             if (value >= 10 ** 32) {
650                 value /= 10 ** 32;
651                 result += 32;
652             }
653             if (value >= 10 ** 16) {
654                 value /= 10 ** 16;
655                 result += 16;
656             }
657             if (value >= 10 ** 8) {
658                 value /= 10 ** 8;
659                 result += 8;
660             }
661             if (value >= 10 ** 4) {
662                 value /= 10 ** 4;
663                 result += 4;
664             }
665             if (value >= 10 ** 2) {
666                 value /= 10 ** 2;
667                 result += 2;
668             }
669             if (value >= 10 ** 1) {
670                 result += 1;
671             }
672         }
673         return result;
674     }
675 
676     /**
677      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
678      * Returns 0 if given 0.
679      */
680     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
681         unchecked {
682             uint256 result = log10(value);
683             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
684         }
685     }
686 
687     /**
688      * @dev Return the log in base 256, rounded down, of a positive value.
689      * Returns 0 if given 0.
690      *
691      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
692      */
693     function log256(uint256 value) internal pure returns (uint256) {
694         uint256 result = 0;
695         unchecked {
696             if (value >> 128 > 0) {
697                 value >>= 128;
698                 result += 16;
699             }
700             if (value >> 64 > 0) {
701                 value >>= 64;
702                 result += 8;
703             }
704             if (value >> 32 > 0) {
705                 value >>= 32;
706                 result += 4;
707             }
708             if (value >> 16 > 0) {
709                 value >>= 16;
710                 result += 2;
711             }
712             if (value >> 8 > 0) {
713                 result += 1;
714             }
715         }
716         return result;
717     }
718 
719     /**
720      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
721      * Returns 0 if given 0.
722      */
723     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
724         unchecked {
725             uint256 result = log256(value);
726             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
727         }
728     }
729 }
730 
731 // File: @openzeppelin/contracts@4.9.0/utils/Strings.sol
732 
733 
734 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 
739 
740 /**
741  * @dev String operations.
742  */
743 library Strings {
744     bytes16 private constant _SYMBOLS = "0123456789abcdef";
745     uint8 private constant _ADDRESS_LENGTH = 20;
746 
747     /**
748      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
749      */
750     function toString(uint256 value) internal pure returns (string memory) {
751         unchecked {
752             uint256 length = Math.log10(value) + 1;
753             string memory buffer = new string(length);
754             uint256 ptr;
755             /// @solidity memory-safe-assembly
756             assembly {
757                 ptr := add(buffer, add(32, length))
758             }
759             while (true) {
760                 ptr--;
761                 /// @solidity memory-safe-assembly
762                 assembly {
763                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
764                 }
765                 value /= 10;
766                 if (value == 0) break;
767             }
768             return buffer;
769         }
770     }
771 
772     /**
773      * @dev Converts a `int256` to its ASCII `string` decimal representation.
774      */
775     function toString(int256 value) internal pure returns (string memory) {
776         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
777     }
778 
779     /**
780      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
781      */
782     function toHexString(uint256 value) internal pure returns (string memory) {
783         unchecked {
784             return toHexString(value, Math.log256(value) + 1);
785         }
786     }
787 
788     /**
789      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
790      */
791     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
792         bytes memory buffer = new bytes(2 * length + 2);
793         buffer[0] = "0";
794         buffer[1] = "x";
795         for (uint256 i = 2 * length + 1; i > 1; --i) {
796             buffer[i] = _SYMBOLS[value & 0xf];
797             value >>= 4;
798         }
799         require(value == 0, "Strings: hex length insufficient");
800         return string(buffer);
801     }
802 
803     /**
804      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
805      */
806     function toHexString(address addr) internal pure returns (string memory) {
807         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
808     }
809 
810     /**
811      * @dev Returns true if the two strings are equal.
812      */
813     function equal(string memory a, string memory b) internal pure returns (bool) {
814         return keccak256(bytes(a)) == keccak256(bytes(b));
815     }
816 }
817 
818 // File: @openzeppelin/contracts@4.9.0/utils/cryptography/ECDSA.sol
819 
820 
821 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)
822 
823 pragma solidity ^0.8.0;
824 
825 
826 /**
827  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
828  *
829  * These functions can be used to verify that a message was signed by the holder
830  * of the private keys of a given address.
831  */
832 library ECDSA {
833     enum RecoverError {
834         NoError,
835         InvalidSignature,
836         InvalidSignatureLength,
837         InvalidSignatureS,
838         InvalidSignatureV // Deprecated in v4.8
839     }
840 
841     function _throwError(RecoverError error) private pure {
842         if (error == RecoverError.NoError) {
843             return; // no error: do nothing
844         } else if (error == RecoverError.InvalidSignature) {
845             revert("ECDSA: invalid signature");
846         } else if (error == RecoverError.InvalidSignatureLength) {
847             revert("ECDSA: invalid signature length");
848         } else if (error == RecoverError.InvalidSignatureS) {
849             revert("ECDSA: invalid signature 's' value");
850         }
851     }
852 
853     /**
854      * @dev Returns the address that signed a hashed message (`hash`) with
855      * `signature` or error string. This address can then be used for verification purposes.
856      *
857      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
858      * this function rejects them by requiring the `s` value to be in the lower
859      * half order, and the `v` value to be either 27 or 28.
860      *
861      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
862      * verification to be secure: it is possible to craft signatures that
863      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
864      * this is by receiving a hash of the original message (which may otherwise
865      * be too long), and then calling {toEthSignedMessageHash} on it.
866      *
867      * Documentation for signature generation:
868      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
869      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
870      *
871      * _Available since v4.3._
872      */
873     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
874         if (signature.length == 65) {
875             bytes32 r;
876             bytes32 s;
877             uint8 v;
878             // ecrecover takes the signature parameters, and the only way to get them
879             // currently is to use assembly.
880             /// @solidity memory-safe-assembly
881             assembly {
882                 r := mload(add(signature, 0x20))
883                 s := mload(add(signature, 0x40))
884                 v := byte(0, mload(add(signature, 0x60)))
885             }
886             return tryRecover(hash, v, r, s);
887         } else {
888             return (address(0), RecoverError.InvalidSignatureLength);
889         }
890     }
891 
892     /**
893      * @dev Returns the address that signed a hashed message (`hash`) with
894      * `signature`. This address can then be used for verification purposes.
895      *
896      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
897      * this function rejects them by requiring the `s` value to be in the lower
898      * half order, and the `v` value to be either 27 or 28.
899      *
900      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
901      * verification to be secure: it is possible to craft signatures that
902      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
903      * this is by receiving a hash of the original message (which may otherwise
904      * be too long), and then calling {toEthSignedMessageHash} on it.
905      */
906     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
907         (address recovered, RecoverError error) = tryRecover(hash, signature);
908         _throwError(error);
909         return recovered;
910     }
911 
912     /**
913      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
914      *
915      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
916      *
917      * _Available since v4.3._
918      */
919     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
920         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
921         uint8 v = uint8((uint256(vs) >> 255) + 27);
922         return tryRecover(hash, v, r, s);
923     }
924 
925     /**
926      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
927      *
928      * _Available since v4.2._
929      */
930     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
931         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
932         _throwError(error);
933         return recovered;
934     }
935 
936     /**
937      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
938      * `r` and `s` signature fields separately.
939      *
940      * _Available since v4.3._
941      */
942     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
943         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
944         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
945         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
946         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
947         //
948         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
949         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
950         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
951         // these malleable signatures as well.
952         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
953             return (address(0), RecoverError.InvalidSignatureS);
954         }
955 
956         // If the signature is valid (and not malleable), return the signer address
957         address signer = ecrecover(hash, v, r, s);
958         if (signer == address(0)) {
959             return (address(0), RecoverError.InvalidSignature);
960         }
961 
962         return (signer, RecoverError.NoError);
963     }
964 
965     /**
966      * @dev Overload of {ECDSA-recover} that receives the `v`,
967      * `r` and `s` signature fields separately.
968      */
969     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
970         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
971         _throwError(error);
972         return recovered;
973     }
974 
975     /**
976      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
977      * produces hash corresponding to the one signed with the
978      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
979      * JSON-RPC method as part of EIP-191.
980      *
981      * See {recover}.
982      */
983     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
984         // 32 is the length in bytes of hash,
985         // enforced by the type signature above
986         /// @solidity memory-safe-assembly
987         assembly {
988             mstore(0x00, "\x19Ethereum Signed Message:\n32")
989             mstore(0x1c, hash)
990             message := keccak256(0x00, 0x3c)
991         }
992     }
993 
994     /**
995      * @dev Returns an Ethereum Signed Message, created from `s`. This
996      * produces hash corresponding to the one signed with the
997      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
998      * JSON-RPC method as part of EIP-191.
999      *
1000      * See {recover}.
1001      */
1002     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1003         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1004     }
1005 
1006     /**
1007      * @dev Returns an Ethereum Signed Typed Data, created from a
1008      * `domainSeparator` and a `structHash`. This produces hash corresponding
1009      * to the one signed with the
1010      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1011      * JSON-RPC method as part of EIP-712.
1012      *
1013      * See {recover}.
1014      */
1015     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
1016         /// @solidity memory-safe-assembly
1017         assembly {
1018             let ptr := mload(0x40)
1019             mstore(ptr, "\x19\x01")
1020             mstore(add(ptr, 0x02), domainSeparator)
1021             mstore(add(ptr, 0x22), structHash)
1022             data := keccak256(ptr, 0x42)
1023         }
1024     }
1025 
1026     /**
1027      * @dev Returns an Ethereum Signed Data with intended validator, created from a
1028      * `validator` and `data` according to the version 0 of EIP-191.
1029      *
1030      * See {recover}.
1031      */
1032     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
1033         return keccak256(abi.encodePacked("\x19\x00", validator, data));
1034     }
1035 }
1036 
1037 // File: @openzeppelin/contracts@4.9.0/utils/cryptography/EIP712.sol
1038 
1039 
1040 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol)
1041 
1042 pragma solidity ^0.8.8;
1043 
1044 
1045 
1046 
1047 /**
1048  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1049  *
1050  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1051  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1052  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1053  *
1054  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1055  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1056  * ({_hashTypedDataV4}).
1057  *
1058  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1059  * the chain id to protect against replay attacks on an eventual fork of the chain.
1060  *
1061  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1062  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1063  *
1064  * NOTE: In the upgradeable version of this contract, the cached values will correspond to the address, and the domain
1065  * separator of the implementation contract. This will cause the `_domainSeparatorV4` function to always rebuild the
1066  * separator from the immutable values, which is cheaper than accessing a cached version in cold storage.
1067  *
1068  * _Available since v3.4._
1069  *
1070  * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
1071  */
1072 abstract contract EIP712 is IERC5267 {
1073     using ShortStrings for *;
1074 
1075     bytes32 private constant _TYPE_HASH =
1076         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1077 
1078     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1079     // invalidate the cached domain separator if the chain id changes.
1080     bytes32 private immutable _cachedDomainSeparator;
1081     uint256 private immutable _cachedChainId;
1082     address private immutable _cachedThis;
1083 
1084     bytes32 private immutable _hashedName;
1085     bytes32 private immutable _hashedVersion;
1086 
1087     ShortString private immutable _name;
1088     ShortString private immutable _version;
1089     string private _nameFallback;
1090     string private _versionFallback;
1091 
1092     /**
1093      * @dev Initializes the domain separator and parameter caches.
1094      *
1095      * The meaning of `name` and `version` is specified in
1096      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1097      *
1098      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1099      * - `version`: the current major version of the signing domain.
1100      *
1101      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1102      * contract upgrade].
1103      */
1104     constructor(string memory name, string memory version) {
1105         _name = name.toShortStringWithFallback(_nameFallback);
1106         _version = version.toShortStringWithFallback(_versionFallback);
1107         _hashedName = keccak256(bytes(name));
1108         _hashedVersion = keccak256(bytes(version));
1109 
1110         _cachedChainId = block.chainid;
1111         _cachedDomainSeparator = _buildDomainSeparator();
1112         _cachedThis = address(this);
1113     }
1114 
1115     /**
1116      * @dev Returns the domain separator for the current chain.
1117      */
1118     function _domainSeparatorV4() internal view returns (bytes32) {
1119         if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
1120             return _cachedDomainSeparator;
1121         } else {
1122             return _buildDomainSeparator();
1123         }
1124     }
1125 
1126     function _buildDomainSeparator() private view returns (bytes32) {
1127         return keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
1128     }
1129 
1130     /**
1131      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1132      * function returns the hash of the fully encoded EIP712 message for this domain.
1133      *
1134      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1135      *
1136      * ```solidity
1137      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1138      *     keccak256("Mail(address to,string contents)"),
1139      *     mailTo,
1140      *     keccak256(bytes(mailContents))
1141      * )));
1142      * address signer = ECDSA.recover(digest, signature);
1143      * ```
1144      */
1145     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1146         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1147     }
1148 
1149     /**
1150      * @dev See {EIP-5267}.
1151      *
1152      * _Available since v4.9._
1153      */
1154     function eip712Domain()
1155         public
1156         view
1157         virtual
1158         override
1159         returns (
1160             bytes1 fields,
1161             string memory name,
1162             string memory version,
1163             uint256 chainId,
1164             address verifyingContract,
1165             bytes32 salt,
1166             uint256[] memory extensions
1167         )
1168     {
1169         return (
1170             hex"0f", // 01111
1171             _name.toStringWithFallback(_nameFallback),
1172             _version.toStringWithFallback(_versionFallback),
1173             block.chainid,
1174             address(this),
1175             bytes32(0),
1176             new uint256[](0)
1177         );
1178     }
1179 }
1180 
1181 // File: @openzeppelin/contracts@4.9.0/token/ERC20/extensions/IERC20Permit.sol
1182 
1183 
1184 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 /**
1189  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1190  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1191  *
1192  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1193  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1194  * need to send a transaction, and thus is not required to hold Ether at all.
1195  */
1196 interface IERC20Permit {
1197     /**
1198      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1199      * given ``owner``'s signed approval.
1200      *
1201      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1202      * ordering also apply here.
1203      *
1204      * Emits an {Approval} event.
1205      *
1206      * Requirements:
1207      *
1208      * - `spender` cannot be the zero address.
1209      * - `deadline` must be a timestamp in the future.
1210      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1211      * over the EIP712-formatted function arguments.
1212      * - the signature must use ``owner``'s current nonce (see {nonces}).
1213      *
1214      * For more information on the signature format, see the
1215      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1216      * section].
1217      */
1218     function permit(
1219         address owner,
1220         address spender,
1221         uint256 value,
1222         uint256 deadline,
1223         uint8 v,
1224         bytes32 r,
1225         bytes32 s
1226     ) external;
1227 
1228     /**
1229      * @dev Returns the current nonce for `owner`. This value must be
1230      * included whenever a signature is generated for {permit}.
1231      *
1232      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1233      * prevents a signature from being used multiple times.
1234      */
1235     function nonces(address owner) external view returns (uint256);
1236 
1237     /**
1238      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1239      */
1240     // solhint-disable-next-line func-name-mixedcase
1241     function DOMAIN_SEPARATOR() external view returns (bytes32);
1242 }
1243 
1244 // File: @openzeppelin/contracts@4.9.0/utils/Context.sol
1245 
1246 
1247 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1248 
1249 pragma solidity ^0.8.0;
1250 
1251 /**
1252  * @dev Provides information about the current execution context, including the
1253  * sender of the transaction and its data. While these are generally available
1254  * via msg.sender and msg.data, they should not be accessed in such a direct
1255  * manner, since when dealing with meta-transactions the account sending and
1256  * paying for execution may not be the actual sender (as far as an application
1257  * is concerned).
1258  *
1259  * This contract is only required for intermediate, library-like contracts.
1260  */
1261 abstract contract Context {
1262     function _msgSender() internal view virtual returns (address) {
1263         return msg.sender;
1264     }
1265 
1266     function _msgData() internal view virtual returns (bytes calldata) {
1267         return msg.data;
1268     }
1269 }
1270 
1271 // File: @openzeppelin/contracts@4.9.0/access/Ownable.sol
1272 
1273 
1274 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1275 
1276 pragma solidity ^0.8.0;
1277 
1278 
1279 /**
1280  * @dev Contract module which provides a basic access control mechanism, where
1281  * there is an account (an owner) that can be granted exclusive access to
1282  * specific functions.
1283  *
1284  * By default, the owner account will be the one that deploys the contract. This
1285  * can later be changed with {transferOwnership}.
1286  *
1287  * This module is used through inheritance. It will make available the modifier
1288  * `onlyOwner`, which can be applied to your functions to restrict their use to
1289  * the owner.
1290  */
1291 abstract contract Ownable is Context {
1292     address private _owner;
1293 
1294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1295 
1296     /**
1297      * @dev Initializes the contract setting the deployer as the initial owner.
1298      */
1299     constructor() {
1300         _transferOwnership(_msgSender());
1301     }
1302 
1303     /**
1304      * @dev Throws if called by any account other than the owner.
1305      */
1306     modifier onlyOwner() {
1307         _checkOwner();
1308         _;
1309     }
1310 
1311     /**
1312      * @dev Returns the address of the current owner.
1313      */
1314     function owner() public view virtual returns (address) {
1315         return _owner;
1316     }
1317 
1318     /**
1319      * @dev Throws if the sender is not the owner.
1320      */
1321     function _checkOwner() internal view virtual {
1322         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1323     }
1324 
1325     /**
1326      * @dev Leaves the contract without owner. It will not be possible to call
1327      * `onlyOwner` functions. Can only be called by the current owner.
1328      *
1329      * NOTE: Renouncing ownership will leave the contract without an owner,
1330      * thereby disabling any functionality that is only available to the owner.
1331      */
1332     function renounceOwnership() public virtual onlyOwner {
1333         _transferOwnership(address(0));
1334     }
1335 
1336     /**
1337      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1338      * Can only be called by the current owner.
1339      */
1340     function transferOwnership(address newOwner) public virtual onlyOwner {
1341         require(newOwner != address(0), "Ownable: new owner is the zero address");
1342         _transferOwnership(newOwner);
1343     }
1344 
1345     /**
1346      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1347      * Internal function without access restriction.
1348      */
1349     function _transferOwnership(address newOwner) internal virtual {
1350         address oldOwner = _owner;
1351         _owner = newOwner;
1352         emit OwnershipTransferred(oldOwner, newOwner);
1353     }
1354 }
1355 
1356 // File: @openzeppelin/contracts@4.9.0/security/Pausable.sol
1357 
1358 
1359 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1360 
1361 pragma solidity ^0.8.0;
1362 
1363 
1364 /**
1365  * @dev Contract module which allows children to implement an emergency stop
1366  * mechanism that can be triggered by an authorized account.
1367  *
1368  * This module is used through inheritance. It will make available the
1369  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1370  * the functions of your contract. Note that they will not be pausable by
1371  * simply including this module, only once the modifiers are put in place.
1372  */
1373 abstract contract Pausable is Context {
1374     /**
1375      * @dev Emitted when the pause is triggered by `account`.
1376      */
1377     event Paused(address account);
1378 
1379     /**
1380      * @dev Emitted when the pause is lifted by `account`.
1381      */
1382     event Unpaused(address account);
1383 
1384     bool private _paused;
1385 
1386     /**
1387      * @dev Initializes the contract in unpaused state.
1388      */
1389     constructor() {
1390         _paused = false;
1391     }
1392 
1393     /**
1394      * @dev Modifier to make a function callable only when the contract is not paused.
1395      *
1396      * Requirements:
1397      *
1398      * - The contract must not be paused.
1399      */
1400     modifier whenNotPaused() {
1401         _requireNotPaused();
1402         _;
1403     }
1404 
1405     /**
1406      * @dev Modifier to make a function callable only when the contract is paused.
1407      *
1408      * Requirements:
1409      *
1410      * - The contract must be paused.
1411      */
1412     modifier whenPaused() {
1413         _requirePaused();
1414         _;
1415     }
1416 
1417     /**
1418      * @dev Returns true if the contract is paused, and false otherwise.
1419      */
1420     function paused() public view virtual returns (bool) {
1421         return _paused;
1422     }
1423 
1424     /**
1425      * @dev Throws if the contract is paused.
1426      */
1427     function _requireNotPaused() internal view virtual {
1428         require(!paused(), "Pausable: paused");
1429     }
1430 
1431     /**
1432      * @dev Throws if the contract is not paused.
1433      */
1434     function _requirePaused() internal view virtual {
1435         require(paused(), "Pausable: not paused");
1436     }
1437 
1438     /**
1439      * @dev Triggers stopped state.
1440      *
1441      * Requirements:
1442      *
1443      * - The contract must not be paused.
1444      */
1445     function _pause() internal virtual whenNotPaused {
1446         _paused = true;
1447         emit Paused(_msgSender());
1448     }
1449 
1450     /**
1451      * @dev Returns to normal state.
1452      *
1453      * Requirements:
1454      *
1455      * - The contract must be paused.
1456      */
1457     function _unpause() internal virtual whenPaused {
1458         _paused = false;
1459         emit Unpaused(_msgSender());
1460     }
1461 }
1462 
1463 // File: @openzeppelin/contracts@4.9.0/token/ERC20/IERC20.sol
1464 
1465 
1466 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1467 
1468 pragma solidity ^0.8.0;
1469 
1470 /**
1471  * @dev Interface of the ERC20 standard as defined in the EIP.
1472  */
1473 interface IERC20 {
1474     /**
1475      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1476      * another (`to`).
1477      *
1478      * Note that `value` may be zero.
1479      */
1480     event Transfer(address indexed from, address indexed to, uint256 value);
1481 
1482     /**
1483      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1484      * a call to {approve}. `value` is the new allowance.
1485      */
1486     event Approval(address indexed owner, address indexed spender, uint256 value);
1487 
1488     /**
1489      * @dev Returns the amount of tokens in existence.
1490      */
1491     function totalSupply() external view returns (uint256);
1492 
1493     /**
1494      * @dev Returns the amount of tokens owned by `account`.
1495      */
1496     function balanceOf(address account) external view returns (uint256);
1497 
1498     /**
1499      * @dev Moves `amount` tokens from the caller's account to `to`.
1500      *
1501      * Returns a boolean value indicating whether the operation succeeded.
1502      *
1503      * Emits a {Transfer} event.
1504      */
1505     function transfer(address to, uint256 amount) external returns (bool);
1506 
1507     /**
1508      * @dev Returns the remaining number of tokens that `spender` will be
1509      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1510      * zero by default.
1511      *
1512      * This value changes when {approve} or {transferFrom} are called.
1513      */
1514     function allowance(address owner, address spender) external view returns (uint256);
1515 
1516     /**
1517      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1518      *
1519      * Returns a boolean value indicating whether the operation succeeded.
1520      *
1521      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1522      * that someone may use both the old and the new allowance by unfortunate
1523      * transaction ordering. One possible solution to mitigate this race
1524      * condition is to first reduce the spender's allowance to 0 and set the
1525      * desired value afterwards:
1526      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1527      *
1528      * Emits an {Approval} event.
1529      */
1530     function approve(address spender, uint256 amount) external returns (bool);
1531 
1532     /**
1533      * @dev Moves `amount` tokens from `from` to `to` using the
1534      * allowance mechanism. `amount` is then deducted from the caller's
1535      * allowance.
1536      *
1537      * Returns a boolean value indicating whether the operation succeeded.
1538      *
1539      * Emits a {Transfer} event.
1540      */
1541     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1542 }
1543 
1544 // File: @openzeppelin/contracts@4.9.0/token/ERC20/extensions/IERC20Metadata.sol
1545 
1546 
1547 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1548 
1549 pragma solidity ^0.8.0;
1550 
1551 
1552 /**
1553  * @dev Interface for the optional metadata functions from the ERC20 standard.
1554  *
1555  * _Available since v4.1._
1556  */
1557 interface IERC20Metadata is IERC20 {
1558     /**
1559      * @dev Returns the name of the token.
1560      */
1561     function name() external view returns (string memory);
1562 
1563     /**
1564      * @dev Returns the symbol of the token.
1565      */
1566     function symbol() external view returns (string memory);
1567 
1568     /**
1569      * @dev Returns the decimals places of the token.
1570      */
1571     function decimals() external view returns (uint8);
1572 }
1573 
1574 // File: @openzeppelin/contracts@4.9.0/token/ERC20/ERC20.sol
1575 
1576 
1577 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1578 
1579 pragma solidity ^0.8.0;
1580 
1581 
1582 
1583 
1584 /**
1585  * @dev Implementation of the {IERC20} interface.
1586  *
1587  * This implementation is agnostic to the way tokens are created. This means
1588  * that a supply mechanism has to be added in a derived contract using {_mint}.
1589  * For a generic mechanism see {ERC20PresetMinterPauser}.
1590  *
1591  * TIP: For a detailed writeup see our guide
1592  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1593  * to implement supply mechanisms].
1594  *
1595  * The default value of {decimals} is 18. To change this, you should override
1596  * this function so it returns a different value.
1597  *
1598  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1599  * instead returning `false` on failure. This behavior is nonetheless
1600  * conventional and does not conflict with the expectations of ERC20
1601  * applications.
1602  *
1603  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1604  * This allows applications to reconstruct the allowance for all accounts just
1605  * by listening to said events. Other implementations of the EIP may not emit
1606  * these events, as it isn't required by the specification.
1607  *
1608  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1609  * functions have been added to mitigate the well-known issues around setting
1610  * allowances. See {IERC20-approve}.
1611  */
1612 contract ERC20 is Context, IERC20, IERC20Metadata {
1613     mapping(address => uint256) private _balances;
1614 
1615     mapping(address => mapping(address => uint256)) private _allowances;
1616 
1617     uint256 private _totalSupply;
1618 
1619     string private _name;
1620     string private _symbol;
1621 
1622     /**
1623      * @dev Sets the values for {name} and {symbol}.
1624      *
1625      * All two of these values are immutable: they can only be set once during
1626      * construction.
1627      */
1628     constructor(string memory name_, string memory symbol_) {
1629         _name = name_;
1630         _symbol = symbol_;
1631     }
1632 
1633     /**
1634      * @dev Returns the name of the token.
1635      */
1636     function name() public view virtual override returns (string memory) {
1637         return _name;
1638     }
1639 
1640     /**
1641      * @dev Returns the symbol of the token, usually a shorter version of the
1642      * name.
1643      */
1644     function symbol() public view virtual override returns (string memory) {
1645         return _symbol;
1646     }
1647 
1648     /**
1649      * @dev Returns the number of decimals used to get its user representation.
1650      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1651      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1652      *
1653      * Tokens usually opt for a value of 18, imitating the relationship between
1654      * Ether and Wei. This is the default value returned by this function, unless
1655      * it's overridden.
1656      *
1657      * NOTE: This information is only used for _display_ purposes: it in
1658      * no way affects any of the arithmetic of the contract, including
1659      * {IERC20-balanceOf} and {IERC20-transfer}.
1660      */
1661     function decimals() public view virtual override returns (uint8) {
1662         return 18;
1663     }
1664 
1665     /**
1666      * @dev See {IERC20-totalSupply}.
1667      */
1668     function totalSupply() public view virtual override returns (uint256) {
1669         return _totalSupply;
1670     }
1671 
1672     /**
1673      * @dev See {IERC20-balanceOf}.
1674      */
1675     function balanceOf(address account) public view virtual override returns (uint256) {
1676         return _balances[account];
1677     }
1678 
1679     /**
1680      * @dev See {IERC20-transfer}.
1681      *
1682      * Requirements:
1683      *
1684      * - `to` cannot be the zero address.
1685      * - the caller must have a balance of at least `amount`.
1686      */
1687     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1688         address owner = _msgSender();
1689         _transfer(owner, to, amount);
1690         return true;
1691     }
1692 
1693     /**
1694      * @dev See {IERC20-allowance}.
1695      */
1696     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1697         return _allowances[owner][spender];
1698     }
1699 
1700     /**
1701      * @dev See {IERC20-approve}.
1702      *
1703      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1704      * `transferFrom`. This is semantically equivalent to an infinite approval.
1705      *
1706      * Requirements:
1707      *
1708      * - `spender` cannot be the zero address.
1709      */
1710     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1711         address owner = _msgSender();
1712         _approve(owner, spender, amount);
1713         return true;
1714     }
1715 
1716     /**
1717      * @dev See {IERC20-transferFrom}.
1718      *
1719      * Emits an {Approval} event indicating the updated allowance. This is not
1720      * required by the EIP. See the note at the beginning of {ERC20}.
1721      *
1722      * NOTE: Does not update the allowance if the current allowance
1723      * is the maximum `uint256`.
1724      *
1725      * Requirements:
1726      *
1727      * - `from` and `to` cannot be the zero address.
1728      * - `from` must have a balance of at least `amount`.
1729      * - the caller must have allowance for ``from``'s tokens of at least
1730      * `amount`.
1731      */
1732     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1733         address spender = _msgSender();
1734         _spendAllowance(from, spender, amount);
1735         _transfer(from, to, amount);
1736         return true;
1737     }
1738 
1739     /**
1740      * @dev Atomically increases the allowance granted to `spender` by the caller.
1741      *
1742      * This is an alternative to {approve} that can be used as a mitigation for
1743      * problems described in {IERC20-approve}.
1744      *
1745      * Emits an {Approval} event indicating the updated allowance.
1746      *
1747      * Requirements:
1748      *
1749      * - `spender` cannot be the zero address.
1750      */
1751     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1752         address owner = _msgSender();
1753         _approve(owner, spender, allowance(owner, spender) + addedValue);
1754         return true;
1755     }
1756 
1757     /**
1758      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1759      *
1760      * This is an alternative to {approve} that can be used as a mitigation for
1761      * problems described in {IERC20-approve}.
1762      *
1763      * Emits an {Approval} event indicating the updated allowance.
1764      *
1765      * Requirements:
1766      *
1767      * - `spender` cannot be the zero address.
1768      * - `spender` must have allowance for the caller of at least
1769      * `subtractedValue`.
1770      */
1771     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1772         address owner = _msgSender();
1773         uint256 currentAllowance = allowance(owner, spender);
1774         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1775         unchecked {
1776             _approve(owner, spender, currentAllowance - subtractedValue);
1777         }
1778 
1779         return true;
1780     }
1781 
1782     /**
1783      * @dev Moves `amount` of tokens from `from` to `to`.
1784      *
1785      * This internal function is equivalent to {transfer}, and can be used to
1786      * e.g. implement automatic token fees, slashing mechanisms, etc.
1787      *
1788      * Emits a {Transfer} event.
1789      *
1790      * Requirements:
1791      *
1792      * - `from` cannot be the zero address.
1793      * - `to` cannot be the zero address.
1794      * - `from` must have a balance of at least `amount`.
1795      */
1796     function _transfer(address from, address to, uint256 amount) internal virtual {
1797         require(from != address(0), "ERC20: transfer from the zero address");
1798         require(to != address(0), "ERC20: transfer to the zero address");
1799 
1800         _beforeTokenTransfer(from, to, amount);
1801 
1802         uint256 fromBalance = _balances[from];
1803         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1804         unchecked {
1805             _balances[from] = fromBalance - amount;
1806             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1807             // decrementing then incrementing.
1808             _balances[to] += amount;
1809         }
1810 
1811         emit Transfer(from, to, amount);
1812 
1813         _afterTokenTransfer(from, to, amount);
1814     }
1815 
1816     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1817      * the total supply.
1818      *
1819      * Emits a {Transfer} event with `from` set to the zero address.
1820      *
1821      * Requirements:
1822      *
1823      * - `account` cannot be the zero address.
1824      */
1825     function _mint(address account, uint256 amount) internal virtual {
1826         require(account != address(0), "ERC20: mint to the zero address");
1827 
1828         _beforeTokenTransfer(address(0), account, amount);
1829 
1830         _totalSupply += amount;
1831         unchecked {
1832             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1833             _balances[account] += amount;
1834         }
1835         emit Transfer(address(0), account, amount);
1836 
1837         _afterTokenTransfer(address(0), account, amount);
1838     }
1839 
1840     /**
1841      * @dev Destroys `amount` tokens from `account`, reducing the
1842      * total supply.
1843      *
1844      * Emits a {Transfer} event with `to` set to the zero address.
1845      *
1846      * Requirements:
1847      *
1848      * - `account` cannot be the zero address.
1849      * - `account` must have at least `amount` tokens.
1850      */
1851     function _burn(address account, uint256 amount) internal virtual {
1852         require(account != address(0), "ERC20: burn from the zero address");
1853 
1854         _beforeTokenTransfer(account, address(0), amount);
1855 
1856         uint256 accountBalance = _balances[account];
1857         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1858         unchecked {
1859             _balances[account] = accountBalance - amount;
1860             // Overflow not possible: amount <= accountBalance <= totalSupply.
1861             _totalSupply -= amount;
1862         }
1863 
1864         emit Transfer(account, address(0), amount);
1865 
1866         _afterTokenTransfer(account, address(0), amount);
1867     }
1868 
1869     /**
1870      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1871      *
1872      * This internal function is equivalent to `approve`, and can be used to
1873      * e.g. set automatic allowances for certain subsystems, etc.
1874      *
1875      * Emits an {Approval} event.
1876      *
1877      * Requirements:
1878      *
1879      * - `owner` cannot be the zero address.
1880      * - `spender` cannot be the zero address.
1881      */
1882     function _approve(address owner, address spender, uint256 amount) internal virtual {
1883         require(owner != address(0), "ERC20: approve from the zero address");
1884         require(spender != address(0), "ERC20: approve to the zero address");
1885 
1886         _allowances[owner][spender] = amount;
1887         emit Approval(owner, spender, amount);
1888     }
1889 
1890     /**
1891      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1892      *
1893      * Does not update the allowance amount in case of infinite allowance.
1894      * Revert if not enough allowance is available.
1895      *
1896      * Might emit an {Approval} event.
1897      */
1898     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1899         uint256 currentAllowance = allowance(owner, spender);
1900         if (currentAllowance != type(uint256).max) {
1901             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1902             unchecked {
1903                 _approve(owner, spender, currentAllowance - amount);
1904             }
1905         }
1906     }
1907 
1908     /**
1909      * @dev Hook that is called before any transfer of tokens. This includes
1910      * minting and burning.
1911      *
1912      * Calling conditions:
1913      *
1914      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1915      * will be transferred to `to`.
1916      * - when `from` is zero, `amount` tokens will be minted for `to`.
1917      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1918      * - `from` and `to` are never both zero.
1919      *
1920      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1921      */
1922     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1923 
1924     /**
1925      * @dev Hook that is called after any transfer of tokens. This includes
1926      * minting and burning.
1927      *
1928      * Calling conditions:
1929      *
1930      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1931      * has been transferred to `to`.
1932      * - when `from` is zero, `amount` tokens have been minted for `to`.
1933      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1934      * - `from` and `to` are never both zero.
1935      *
1936      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1937      */
1938     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1939 }
1940 
1941 // File: @openzeppelin/contracts@4.9.0/token/ERC20/extensions/ERC20Permit.sol
1942 
1943 
1944 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/ERC20Permit.sol)
1945 
1946 pragma solidity ^0.8.0;
1947 
1948 
1949 
1950 
1951 
1952 
1953 /**
1954  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1955  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1956  *
1957  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1958  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1959  * need to send a transaction, and thus is not required to hold Ether at all.
1960  *
1961  * _Available since v3.4._
1962  */
1963 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1964     using Counters for Counters.Counter;
1965 
1966     mapping(address => Counters.Counter) private _nonces;
1967 
1968     // solhint-disable-next-line var-name-mixedcase
1969     bytes32 private constant _PERMIT_TYPEHASH =
1970         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1971     /**
1972      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1973      * However, to ensure consistency with the upgradeable transpiler, we will continue
1974      * to reserve a slot.
1975      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1976      */
1977     // solhint-disable-next-line var-name-mixedcase
1978     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1979 
1980     /**
1981      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1982      *
1983      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1984      */
1985     constructor(string memory name) EIP712(name, "1") {}
1986 
1987     /**
1988      * @dev See {IERC20Permit-permit}.
1989      */
1990     function permit(
1991         address owner,
1992         address spender,
1993         uint256 value,
1994         uint256 deadline,
1995         uint8 v,
1996         bytes32 r,
1997         bytes32 s
1998     ) public virtual override {
1999         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
2000 
2001         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
2002 
2003         bytes32 hash = _hashTypedDataV4(structHash);
2004 
2005         address signer = ECDSA.recover(hash, v, r, s);
2006         require(signer == owner, "ERC20Permit: invalid signature");
2007 
2008         _approve(owner, spender, value);
2009     }
2010 
2011     /**
2012      * @dev See {IERC20Permit-nonces}.
2013      */
2014     function nonces(address owner) public view virtual override returns (uint256) {
2015         return _nonces[owner].current();
2016     }
2017 
2018     /**
2019      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
2020      */
2021     // solhint-disable-next-line func-name-mixedcase
2022     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
2023         return _domainSeparatorV4();
2024     }
2025 
2026     /**
2027      * @dev "Consume a nonce": return the current value and increment.
2028      *
2029      * _Available since v4.1._
2030      */
2031     function _useNonce(address owner) internal virtual returns (uint256 current) {
2032         Counters.Counter storage nonce = _nonces[owner];
2033         current = nonce.current();
2034         nonce.increment();
2035     }
2036 }
2037 
2038 // File: @openzeppelin/contracts@4.9.0/token/ERC20/extensions/draft-ERC20Permit.sol
2039 
2040 
2041 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
2042 
2043 pragma solidity ^0.8.0;
2044 
2045 // EIP-2612 is Final as of 2022-11-01. This file is deprecated.
2046 
2047 
2048 // File: @openzeppelin/contracts@4.9.0/token/ERC20/extensions/ERC20Burnable.sol
2049 
2050 
2051 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
2052 
2053 pragma solidity ^0.8.0;
2054 
2055 
2056 
2057 /**
2058  * @dev Extension of {ERC20} that allows token holders to destroy both their own
2059  * tokens and those that they have an allowance for, in a way that can be
2060  * recognized off-chain (via event analysis).
2061  */
2062 abstract contract ERC20Burnable is Context, ERC20 {
2063     /**
2064      * @dev Destroys `amount` tokens from the caller.
2065      *
2066      * See {ERC20-_burn}.
2067      */
2068     function burn(uint256 amount) public virtual {
2069         _burn(_msgSender(), amount);
2070     }
2071 
2072     /**
2073      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
2074      * allowance.
2075      *
2076      * See {ERC20-_burn} and {ERC20-allowance}.
2077      *
2078      * Requirements:
2079      *
2080      * - the caller must have allowance for ``accounts``'s tokens of at least
2081      * `amount`.
2082      */
2083     function burnFrom(address account, uint256 amount) public virtual {
2084         _spendAllowance(account, _msgSender(), amount);
2085         _burn(account, amount);
2086     }
2087 }
2088 
2089 // File: contract-0b4d7ed2ec.sol
2090 
2091 
2092 pragma solidity ^0.8.9;
2093 
2094 
2095 
2096 
2097 
2098 
2099 /// @custom:security-contact official@tidalflats.studio
2100 contract Tidalflats is ERC20, ERC20Burnable, Pausable, Ownable, ERC20Permit {
2101     constructor() ERC20("Tidalflats", "TIDE") ERC20Permit("Tidalflats") {}
2102 
2103     function pause() public onlyOwner {
2104         _pause();
2105     }
2106 
2107     function unpause() public onlyOwner {
2108         _unpause();
2109     }
2110 
2111     function mint(address to, uint256 amount) public onlyOwner {
2112         _mint(to, amount);
2113     }
2114 
2115     function _beforeTokenTransfer(address from, address to, uint256 amount)
2116         internal
2117         whenNotPaused
2118         override
2119     {
2120         super._beforeTokenTransfer(from, to, amount);
2121     }
2122 }