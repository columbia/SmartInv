1 // File: supermarket/contracts/types/T.sol
2 
3 
4 
5 pragma solidity 0.8.8;
6 
7 interface IWLP {
8  function depositFromSuper() external payable;
9  function getMaxTVLExposed() external  view returns(uint256);
10  function SuperMarketPayoutNative(address from,address to,uint256 claimAmt,uint256 a,uint256 b) payable external;
11  function SuperMarketPayoutToken(address to,uint256 _amt) external;
12 }
13 
14 // interface AggregatorV3Interface {
15 
16 //   // getRoundData and latestRoundData should both raise "No data present"
17 //   // if they do not have data to report, instead of returning unset values
18 //   // which could be misinterpreted as actual reported values.
19 //   function getRoundData(
20 //     uint80 _roundId
21 //   )
22 //     external
23 //     view
24 //     returns (
25 //       uint80 roundId,
26 //       int256 answer,
27 //       uint256 startedAt,
28 //       uint256 updatedAt,
29 //       uint80 answeredInRound
30 //     );
31 
32 //   function latestRoundData()
33 //     external
34 //     view
35 //     returns (
36 //       uint80 roundId,
37 //       int256 answer,
38 //       uint256 startedAt,
39 //       uint256 updatedAt,
40 //       uint80 answeredInRound
41 //     );
42 
43 // }
44 
45     // struct Market{
46     //   uint256  minBetAmount;
47     //   uint256  maxBetAmount;
48     //   //uint256  treasuryAmount;
49     //   uint256  currentEpoch;
50     //   uint256 currentRpoch;
51     //   uint256  oracleLatestRoundId; 
52     //   uint256  oracleUpdateAllowance;
53     //   //uint256  maxTVLExposed;
54     //   uint256  bufferSeconds;
55     //   uint256  intervalSeconds;
56     //   bool     genesisLockOnce;
57     //   bool     genesisStartOnce;
58     //  //AggregatorV3Interface oracle;
59     //  // IWLP wLP;
60 
61     // }
62     struct Market{
63       uint256  minBetAmount;
64       uint256  maxBetAmount;
65     //  uint256  treasuryAmount;
66       uint256 genesisStartTime;
67       uint256  initEpoch;
68       uint256  lastEpoch;
69     //   uint256  oracleLatestRoundId; 
70     //   uint256  oracleUpdateAllowance;
71     //   uint256  maxTVLExposed;
72       uint256  bufferSeconds;
73       uint256  intervalSeconds;
74       bool     genesisLockOnce;
75       bool     genesisStartOnce;
76     //  AggregatorV3Interface oracle;
77     //  IWLP wLP;
78 
79     }
80 
81 
82     enum Position {
83         Bull,
84         Bear
85     }
86 
87     // struct Asset{
88     //   uint256  minBetAmount;
89     //   uint256  treasuryAmount;
90     //   uint256  currentEpoch;
91     //   uint256  oracleLatestRoundId; 
92     //   uint256  oracleUpdateAllowance;
93     // }
94 
95     struct Round {
96         uint256 market;
97         // uint256 startTimestamp;
98         // uint256 lockTimestamp;
99         // uint256 closeTimestamp;
100         //int256 lockPrice;
101         int256 closePrice;
102         //uint256 lockOracleId;
103         //uint256 closeOracleId;
104         uint256 totalAmount;
105         uint256 totalBorrowedAmount;
106         // uint256 bullAmount;
107         // uint256 bearAmount;
108         //uint256 rewardBaseCalAmount;
109         //uint256 rewardAmount;
110         uint256 initTVLExposed;
111         uint256 maxTVLExposed;
112         bool oracleCalled;
113     }
114 
115     struct BetInfo {
116         Position position;
117         uint256 amount;
118         uint256 borrowedAmount; //i.e Leverage = (amount+borrow)/amount;
119         //uint256 basePriceOfAsset;
120         int256 startPrice;
121         int256 lockPrice; //
122         uint256 lockOracleId;
123         //uint256 payoutAmount; //Expected payout.
124         bool claimed; // default false
125     }
126     struct UserRound{
127         uint256[] epochs;
128         uint256 lastClaimed;
129     }
130 // File: @openzeppelin/contracts/interfaces/IERC5267.sol
131 
132 
133 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC5267.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 interface IERC5267 {
138     /**
139      * @dev MAY be emitted to signal that the domain could have changed.
140      */
141     event EIP712DomainChanged();
142 
143     /**
144      * @dev returns the fields and values that describe the domain separator used by this contract for EIP-712
145      * signature.
146      */
147     function eip712Domain()
148         external
149         view
150         returns (
151             bytes1 fields,
152             string memory name,
153             string memory version,
154             uint256 chainId,
155             address verifyingContract,
156             bytes32 salt,
157             uint256[] memory extensions
158         );
159 }
160 
161 // File: @openzeppelin/contracts/utils/StorageSlot.sol
162 
163 
164 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
165 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
166 
167 pragma solidity ^0.8.0;
168 
169 /**
170  * @dev Library for reading and writing primitive types to specific storage slots.
171  *
172  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
173  * This library helps with reading and writing to such slots without the need for inline assembly.
174  *
175  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
176  *
177  * Example usage to set ERC1967 implementation slot:
178  * ```solidity
179  * contract ERC1967 {
180  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
181  *
182  *     function _getImplementation() internal view returns (address) {
183  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
184  *     }
185  *
186  *     function _setImplementation(address newImplementation) internal {
187  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
188  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
189  *     }
190  * }
191  * ```
192  *
193  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
194  * _Available since v4.9 for `string`, `bytes`._
195  */
196 library StorageSlot {
197     struct AddressSlot {
198         address value;
199     }
200 
201     struct BooleanSlot {
202         bool value;
203     }
204 
205     struct Bytes32Slot {
206         bytes32 value;
207     }
208 
209     struct Uint256Slot {
210         uint256 value;
211     }
212 
213     struct StringSlot {
214         string value;
215     }
216 
217     struct BytesSlot {
218         bytes value;
219     }
220 
221     /**
222      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
223      */
224     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
225         /// @solidity memory-safe-assembly
226         assembly {
227             r.slot := slot
228         }
229     }
230 
231     /**
232      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
233      */
234     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
235         /// @solidity memory-safe-assembly
236         assembly {
237             r.slot := slot
238         }
239     }
240 
241     /**
242      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
243      */
244     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
245         /// @solidity memory-safe-assembly
246         assembly {
247             r.slot := slot
248         }
249     }
250 
251     /**
252      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
253      */
254     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
255         /// @solidity memory-safe-assembly
256         assembly {
257             r.slot := slot
258         }
259     }
260 
261     /**
262      * @dev Returns an `StringSlot` with member `value` located at `slot`.
263      */
264     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
265         /// @solidity memory-safe-assembly
266         assembly {
267             r.slot := slot
268         }
269     }
270 
271     /**
272      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
273      */
274     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
275         /// @solidity memory-safe-assembly
276         assembly {
277             r.slot := store.slot
278         }
279     }
280 
281     /**
282      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
283      */
284     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
285         /// @solidity memory-safe-assembly
286         assembly {
287             r.slot := slot
288         }
289     }
290 
291     /**
292      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
293      */
294     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
295         /// @solidity memory-safe-assembly
296         assembly {
297             r.slot := store.slot
298         }
299     }
300 }
301 
302 // File: @openzeppelin/contracts/utils/ShortStrings.sol
303 
304 
305 // OpenZeppelin Contracts (last updated v4.9.0) (utils/ShortStrings.sol)
306 
307 pragma solidity ^0.8.8;
308 
309 
310 // | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
311 // | length  | 0x                                                              BB |
312 type ShortString is bytes32;
313 
314 /**
315  * @dev This library provides functions to convert short memory strings
316  * into a `ShortString` type that can be used as an immutable variable.
317  *
318  * Strings of arbitrary length can be optimized using this library if
319  * they are short enough (up to 31 bytes) by packing them with their
320  * length (1 byte) in a single EVM word (32 bytes). Additionally, a
321  * fallback mechanism can be used for every other case.
322  *
323  * Usage example:
324  *
325  * ```solidity
326  * contract Named {
327  *     using ShortStrings for *;
328  *
329  *     ShortString private immutable _name;
330  *     string private _nameFallback;
331  *
332  *     constructor(string memory contractName) {
333  *         _name = contractName.toShortStringWithFallback(_nameFallback);
334  *     }
335  *
336  *     function name() external view returns (string memory) {
337  *         return _name.toStringWithFallback(_nameFallback);
338  *     }
339  * }
340  * ```
341  */
342 library ShortStrings {
343     // Used as an identifier for strings longer than 31 bytes.
344     bytes32 private constant _FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;
345 
346     error StringTooLong(string str);
347     error InvalidShortString();
348 
349     /**
350      * @dev Encode a string of at most 31 chars into a `ShortString`.
351      *
352      * This will trigger a `StringTooLong` error is the input string is too long.
353      */
354     function toShortString(string memory str) internal pure returns (ShortString) {
355         bytes memory bstr = bytes(str);
356         if (bstr.length > 31) {
357             revert StringTooLong(str);
358         }
359         return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
360     }
361 
362     /**
363      * @dev Decode a `ShortString` back to a "normal" string.
364      */
365     function toString(ShortString sstr) internal pure returns (string memory) {
366         uint256 len = byteLength(sstr);
367         // using `new string(len)` would work locally but is not memory safe.
368         string memory str = new string(32);
369         /// @solidity memory-safe-assembly
370         assembly {
371             mstore(str, len)
372             mstore(add(str, 0x20), sstr)
373         }
374         return str;
375     }
376 
377     /**
378      * @dev Return the length of a `ShortString`.
379      */
380     function byteLength(ShortString sstr) internal pure returns (uint256) {
381         uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;
382         if (result > 31) {
383             revert InvalidShortString();
384         }
385         return result;
386     }
387 
388     /**
389      * @dev Encode a string into a `ShortString`, or write it to storage if it is too long.
390      */
391     function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {
392         if (bytes(value).length < 32) {
393             return toShortString(value);
394         } else {
395             StorageSlot.getStringSlot(store).value = value;
396             return ShortString.wrap(_FALLBACK_SENTINEL);
397         }
398     }
399 
400     /**
401      * @dev Decode a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
402      */
403     function toStringWithFallback(ShortString value, string storage store) internal pure returns (string memory) {
404         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
405             return toString(value);
406         } else {
407             return store;
408         }
409     }
410 
411     /**
412      * @dev Return the length of a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
413      *
414      * WARNING: This will return the "byte length" of the string. This may not reflect the actual length in terms of
415      * actual characters as the UTF-8 encoding of a single character can span over multiple bytes.
416      */
417     function byteLengthWithFallback(ShortString value, string storage store) internal view returns (uint256) {
418         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
419             return byteLength(value);
420         } else {
421             return bytes(store).length;
422         }
423     }
424 }
425 
426 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
427 
428 
429 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
430 
431 pragma solidity ^0.8.0;
432 
433 /**
434  * @dev Standard signed math utilities missing in the Solidity language.
435  */
436 library SignedMath {
437     /**
438      * @dev Returns the largest of two signed numbers.
439      */
440     function max(int256 a, int256 b) internal pure returns (int256) {
441         return a > b ? a : b;
442     }
443 
444     /**
445      * @dev Returns the smallest of two signed numbers.
446      */
447     function min(int256 a, int256 b) internal pure returns (int256) {
448         return a < b ? a : b;
449     }
450 
451     /**
452      * @dev Returns the average of two signed numbers without overflow.
453      * The result is rounded towards zero.
454      */
455     function average(int256 a, int256 b) internal pure returns (int256) {
456         // Formula from the book "Hacker's Delight"
457         int256 x = (a & b) + ((a ^ b) >> 1);
458         return x + (int256(uint256(x) >> 255) & (a ^ b));
459     }
460 
461     /**
462      * @dev Returns the absolute unsigned value of a signed value.
463      */
464     function abs(int256 n) internal pure returns (uint256) {
465         unchecked {
466             // must be unchecked in order to support `n = type(int256).min`
467             return uint256(n >= 0 ? n : -n);
468         }
469     }
470 }
471 
472 // File: @openzeppelin/contracts/utils/math/Math.sol
473 
474 
475 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Standard math utilities missing in the Solidity language.
481  */
482 library Math {
483     enum Rounding {
484         Down, // Toward negative infinity
485         Up, // Toward infinity
486         Zero // Toward zero
487     }
488 
489     /**
490      * @dev Returns the largest of two numbers.
491      */
492     function max(uint256 a, uint256 b) internal pure returns (uint256) {
493         return a > b ? a : b;
494     }
495 
496     /**
497      * @dev Returns the smallest of two numbers.
498      */
499     function min(uint256 a, uint256 b) internal pure returns (uint256) {
500         return a < b ? a : b;
501     }
502 
503     /**
504      * @dev Returns the average of two numbers. The result is rounded towards
505      * zero.
506      */
507     function average(uint256 a, uint256 b) internal pure returns (uint256) {
508         // (a + b) / 2 can overflow.
509         return (a & b) + (a ^ b) / 2;
510     }
511 
512     /**
513      * @dev Returns the ceiling of the division of two numbers.
514      *
515      * This differs from standard division with `/` in that it rounds up instead
516      * of rounding down.
517      */
518     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
519         // (a + b - 1) / b can overflow on addition, so we distribute.
520         return a == 0 ? 0 : (a - 1) / b + 1;
521     }
522 
523     /**
524      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
525      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
526      * with further edits by Uniswap Labs also under MIT license.
527      */
528     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
529         unchecked {
530             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
531             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
532             // variables such that product = prod1 * 2^256 + prod0.
533             uint256 prod0; // Least significant 256 bits of the product
534             uint256 prod1; // Most significant 256 bits of the product
535             assembly {
536                 let mm := mulmod(x, y, not(0))
537                 prod0 := mul(x, y)
538                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
539             }
540 
541             // Handle non-overflow cases, 256 by 256 division.
542             if (prod1 == 0) {
543                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
544                 // The surrounding unchecked block does not change this fact.
545                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
546                 return prod0 / denominator;
547             }
548 
549             // Make sure the result is less than 2^256. Also prevents denominator == 0.
550             require(denominator > prod1, "Math: mulDiv overflow");
551 
552             ///////////////////////////////////////////////
553             // 512 by 256 division.
554             ///////////////////////////////////////////////
555 
556             // Make division exact by subtracting the remainder from [prod1 prod0].
557             uint256 remainder;
558             assembly {
559                 // Compute remainder using mulmod.
560                 remainder := mulmod(x, y, denominator)
561 
562                 // Subtract 256 bit number from 512 bit number.
563                 prod1 := sub(prod1, gt(remainder, prod0))
564                 prod0 := sub(prod0, remainder)
565             }
566 
567             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
568             // See https://cs.stackexchange.com/q/138556/92363.
569 
570             // Does not overflow because the denominator cannot be zero at this stage in the function.
571             uint256 twos = denominator & (~denominator + 1);
572             assembly {
573                 // Divide denominator by twos.
574                 denominator := div(denominator, twos)
575 
576                 // Divide [prod1 prod0] by twos.
577                 prod0 := div(prod0, twos)
578 
579                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
580                 twos := add(div(sub(0, twos), twos), 1)
581             }
582 
583             // Shift in bits from prod1 into prod0.
584             prod0 |= prod1 * twos;
585 
586             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
587             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
588             // four bits. That is, denominator * inv = 1 mod 2^4.
589             uint256 inverse = (3 * denominator) ^ 2;
590 
591             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
592             // in modular arithmetic, doubling the correct bits in each step.
593             inverse *= 2 - denominator * inverse; // inverse mod 2^8
594             inverse *= 2 - denominator * inverse; // inverse mod 2^16
595             inverse *= 2 - denominator * inverse; // inverse mod 2^32
596             inverse *= 2 - denominator * inverse; // inverse mod 2^64
597             inverse *= 2 - denominator * inverse; // inverse mod 2^128
598             inverse *= 2 - denominator * inverse; // inverse mod 2^256
599 
600             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
601             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
602             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
603             // is no longer required.
604             result = prod0 * inverse;
605             return result;
606         }
607     }
608 
609     /**
610      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
611      */
612     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
613         uint256 result = mulDiv(x, y, denominator);
614         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
615             result += 1;
616         }
617         return result;
618     }
619 
620     /**
621      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
622      *
623      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
624      */
625     function sqrt(uint256 a) internal pure returns (uint256) {
626         if (a == 0) {
627             return 0;
628         }
629 
630         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
631         //
632         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
633         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
634         //
635         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
636         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
637         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
638         //
639         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
640         uint256 result = 1 << (log2(a) >> 1);
641 
642         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
643         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
644         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
645         // into the expected uint128 result.
646         unchecked {
647             result = (result + a / result) >> 1;
648             result = (result + a / result) >> 1;
649             result = (result + a / result) >> 1;
650             result = (result + a / result) >> 1;
651             result = (result + a / result) >> 1;
652             result = (result + a / result) >> 1;
653             result = (result + a / result) >> 1;
654             return min(result, a / result);
655         }
656     }
657 
658     /**
659      * @notice Calculates sqrt(a), following the selected rounding direction.
660      */
661     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
662         unchecked {
663             uint256 result = sqrt(a);
664             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
665         }
666     }
667 
668     /**
669      * @dev Return the log in base 2, rounded down, of a positive value.
670      * Returns 0 if given 0.
671      */
672     function log2(uint256 value) internal pure returns (uint256) {
673         uint256 result = 0;
674         unchecked {
675             if (value >> 128 > 0) {
676                 value >>= 128;
677                 result += 128;
678             }
679             if (value >> 64 > 0) {
680                 value >>= 64;
681                 result += 64;
682             }
683             if (value >> 32 > 0) {
684                 value >>= 32;
685                 result += 32;
686             }
687             if (value >> 16 > 0) {
688                 value >>= 16;
689                 result += 16;
690             }
691             if (value >> 8 > 0) {
692                 value >>= 8;
693                 result += 8;
694             }
695             if (value >> 4 > 0) {
696                 value >>= 4;
697                 result += 4;
698             }
699             if (value >> 2 > 0) {
700                 value >>= 2;
701                 result += 2;
702             }
703             if (value >> 1 > 0) {
704                 result += 1;
705             }
706         }
707         return result;
708     }
709 
710     /**
711      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
712      * Returns 0 if given 0.
713      */
714     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
715         unchecked {
716             uint256 result = log2(value);
717             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
718         }
719     }
720 
721     /**
722      * @dev Return the log in base 10, rounded down, of a positive value.
723      * Returns 0 if given 0.
724      */
725     function log10(uint256 value) internal pure returns (uint256) {
726         uint256 result = 0;
727         unchecked {
728             if (value >= 10 ** 64) {
729                 value /= 10 ** 64;
730                 result += 64;
731             }
732             if (value >= 10 ** 32) {
733                 value /= 10 ** 32;
734                 result += 32;
735             }
736             if (value >= 10 ** 16) {
737                 value /= 10 ** 16;
738                 result += 16;
739             }
740             if (value >= 10 ** 8) {
741                 value /= 10 ** 8;
742                 result += 8;
743             }
744             if (value >= 10 ** 4) {
745                 value /= 10 ** 4;
746                 result += 4;
747             }
748             if (value >= 10 ** 2) {
749                 value /= 10 ** 2;
750                 result += 2;
751             }
752             if (value >= 10 ** 1) {
753                 result += 1;
754             }
755         }
756         return result;
757     }
758 
759     /**
760      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
761      * Returns 0 if given 0.
762      */
763     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
764         unchecked {
765             uint256 result = log10(value);
766             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
767         }
768     }
769 
770     /**
771      * @dev Return the log in base 256, rounded down, of a positive value.
772      * Returns 0 if given 0.
773      *
774      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
775      */
776     function log256(uint256 value) internal pure returns (uint256) {
777         uint256 result = 0;
778         unchecked {
779             if (value >> 128 > 0) {
780                 value >>= 128;
781                 result += 16;
782             }
783             if (value >> 64 > 0) {
784                 value >>= 64;
785                 result += 8;
786             }
787             if (value >> 32 > 0) {
788                 value >>= 32;
789                 result += 4;
790             }
791             if (value >> 16 > 0) {
792                 value >>= 16;
793                 result += 2;
794             }
795             if (value >> 8 > 0) {
796                 result += 1;
797             }
798         }
799         return result;
800     }
801 
802     /**
803      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
804      * Returns 0 if given 0.
805      */
806     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
807         unchecked {
808             uint256 result = log256(value);
809             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
810         }
811     }
812 }
813 
814 // File: @openzeppelin/contracts/utils/Strings.sol
815 
816 
817 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 
822 
823 /**
824  * @dev String operations.
825  */
826 library Strings {
827     bytes16 private constant _SYMBOLS = "0123456789abcdef";
828     uint8 private constant _ADDRESS_LENGTH = 20;
829 
830     /**
831      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
832      */
833     function toString(uint256 value) internal pure returns (string memory) {
834         unchecked {
835             uint256 length = Math.log10(value) + 1;
836             string memory buffer = new string(length);
837             uint256 ptr;
838             /// @solidity memory-safe-assembly
839             assembly {
840                 ptr := add(buffer, add(32, length))
841             }
842             while (true) {
843                 ptr--;
844                 /// @solidity memory-safe-assembly
845                 assembly {
846                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
847                 }
848                 value /= 10;
849                 if (value == 0) break;
850             }
851             return buffer;
852         }
853     }
854 
855     /**
856      * @dev Converts a `int256` to its ASCII `string` decimal representation.
857      */
858     function toString(int256 value) internal pure returns (string memory) {
859         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
860     }
861 
862     /**
863      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
864      */
865     function toHexString(uint256 value) internal pure returns (string memory) {
866         unchecked {
867             return toHexString(value, Math.log256(value) + 1);
868         }
869     }
870 
871     /**
872      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
873      */
874     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
875         bytes memory buffer = new bytes(2 * length + 2);
876         buffer[0] = "0";
877         buffer[1] = "x";
878         for (uint256 i = 2 * length + 1; i > 1; --i) {
879             buffer[i] = _SYMBOLS[value & 0xf];
880             value >>= 4;
881         }
882         require(value == 0, "Strings: hex length insufficient");
883         return string(buffer);
884     }
885 
886     /**
887      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
888      */
889     function toHexString(address addr) internal pure returns (string memory) {
890         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
891     }
892 
893     /**
894      * @dev Returns true if the two strings are equal.
895      */
896     function equal(string memory a, string memory b) internal pure returns (bool) {
897         return keccak256(bytes(a)) == keccak256(bytes(b));
898     }
899 }
900 
901 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
902 
903 
904 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)
905 
906 pragma solidity ^0.8.0;
907 
908 
909 /**
910  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
911  *
912  * These functions can be used to verify that a message was signed by the holder
913  * of the private keys of a given address.
914  */
915 library ECDSA {
916     enum RecoverError {
917         NoError,
918         InvalidSignature,
919         InvalidSignatureLength,
920         InvalidSignatureS,
921         InvalidSignatureV // Deprecated in v4.8
922     }
923 
924     function _throwError(RecoverError error) private pure {
925         if (error == RecoverError.NoError) {
926             return; // no error: do nothing
927         } else if (error == RecoverError.InvalidSignature) {
928             revert("ECDSA: invalid signature");
929         } else if (error == RecoverError.InvalidSignatureLength) {
930             revert("ECDSA: invalid signature length");
931         } else if (error == RecoverError.InvalidSignatureS) {
932             revert("ECDSA: invalid signature 's' value");
933         }
934     }
935 
936     /**
937      * @dev Returns the address that signed a hashed message (`hash`) with
938      * `signature` or error string. This address can then be used for verification purposes.
939      *
940      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
941      * this function rejects them by requiring the `s` value to be in the lower
942      * half order, and the `v` value to be either 27 or 28.
943      *
944      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
945      * verification to be secure: it is possible to craft signatures that
946      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
947      * this is by receiving a hash of the original message (which may otherwise
948      * be too long), and then calling {toEthSignedMessageHash} on it.
949      *
950      * Documentation for signature generation:
951      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
952      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
953      *
954      * _Available since v4.3._
955      */
956     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
957         if (signature.length == 65) {
958             bytes32 r;
959             bytes32 s;
960             uint8 v;
961             // ecrecover takes the signature parameters, and the only way to get them
962             // currently is to use assembly.
963             /// @solidity memory-safe-assembly
964             assembly {
965                 r := mload(add(signature, 0x20))
966                 s := mload(add(signature, 0x40))
967                 v := byte(0, mload(add(signature, 0x60)))
968             }
969             return tryRecover(hash, v, r, s);
970         } else {
971             return (address(0), RecoverError.InvalidSignatureLength);
972         }
973     }
974 
975     /**
976      * @dev Returns the address that signed a hashed message (`hash`) with
977      * `signature`. This address can then be used for verification purposes.
978      *
979      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
980      * this function rejects them by requiring the `s` value to be in the lower
981      * half order, and the `v` value to be either 27 or 28.
982      *
983      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
984      * verification to be secure: it is possible to craft signatures that
985      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
986      * this is by receiving a hash of the original message (which may otherwise
987      * be too long), and then calling {toEthSignedMessageHash} on it.
988      */
989     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
990         (address recovered, RecoverError error) = tryRecover(hash, signature);
991         _throwError(error);
992         return recovered;
993     }
994 
995     /**
996      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
997      *
998      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
999      *
1000      * _Available since v4.3._
1001      */
1002     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
1003         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1004         uint8 v = uint8((uint256(vs) >> 255) + 27);
1005         return tryRecover(hash, v, r, s);
1006     }
1007 
1008     /**
1009      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1010      *
1011      * _Available since v4.2._
1012      */
1013     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
1014         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1015         _throwError(error);
1016         return recovered;
1017     }
1018 
1019     /**
1020      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1021      * `r` and `s` signature fields separately.
1022      *
1023      * _Available since v4.3._
1024      */
1025     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
1026         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1027         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1028         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1029         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1030         //
1031         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1032         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1033         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1034         // these malleable signatures as well.
1035         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1036             return (address(0), RecoverError.InvalidSignatureS);
1037         }
1038 
1039         // If the signature is valid (and not malleable), return the signer address
1040         address signer = ecrecover(hash, v, r, s);
1041         if (signer == address(0)) {
1042             return (address(0), RecoverError.InvalidSignature);
1043         }
1044 
1045         return (signer, RecoverError.NoError);
1046     }
1047 
1048     /**
1049      * @dev Overload of {ECDSA-recover} that receives the `v`,
1050      * `r` and `s` signature fields separately.
1051      */
1052     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1053         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1054         _throwError(error);
1055         return recovered;
1056     }
1057 
1058     /**
1059      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1060      * produces hash corresponding to the one signed with the
1061      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1062      * JSON-RPC method as part of EIP-191.
1063      *
1064      * See {recover}.
1065      */
1066     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
1067         // 32 is the length in bytes of hash,
1068         // enforced by the type signature above
1069         /// @solidity memory-safe-assembly
1070         assembly {
1071             mstore(0x00, "\x19Ethereum Signed Message:\n32")
1072             mstore(0x1c, hash)
1073             message := keccak256(0x00, 0x3c)
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns an Ethereum Signed Message, created from `s`. This
1079      * produces hash corresponding to the one signed with the
1080      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1081      * JSON-RPC method as part of EIP-191.
1082      *
1083      * See {recover}.
1084      */
1085     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1086         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1087     }
1088 
1089     /**
1090      * @dev Returns an Ethereum Signed Typed Data, created from a
1091      * `domainSeparator` and a `structHash`. This produces hash corresponding
1092      * to the one signed with the
1093      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1094      * JSON-RPC method as part of EIP-712.
1095      *
1096      * See {recover}.
1097      */
1098     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
1099         /// @solidity memory-safe-assembly
1100         assembly {
1101             let ptr := mload(0x40)
1102             mstore(ptr, "\x19\x01")
1103             mstore(add(ptr, 0x02), domainSeparator)
1104             mstore(add(ptr, 0x22), structHash)
1105             data := keccak256(ptr, 0x42)
1106         }
1107     }
1108 
1109     /**
1110      * @dev Returns an Ethereum Signed Data with intended validator, created from a
1111      * `validator` and `data` according to the version 0 of EIP-191.
1112      *
1113      * See {recover}.
1114      */
1115     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
1116         return keccak256(abi.encodePacked("\x19\x00", validator, data));
1117     }
1118 }
1119 
1120 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
1121 
1122 
1123 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol)
1124 
1125 pragma solidity ^0.8.8;
1126 
1127 
1128 
1129 
1130 /**
1131  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1132  *
1133  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1134  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1135  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1136  *
1137  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1138  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1139  * ({_hashTypedDataV4}).
1140  *
1141  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1142  * the chain id to protect against replay attacks on an eventual fork of the chain.
1143  *
1144  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1145  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1146  *
1147  * NOTE: In the upgradeable version of this contract, the cached values will correspond to the address, and the domain
1148  * separator of the implementation contract. This will cause the `_domainSeparatorV4` function to always rebuild the
1149  * separator from the immutable values, which is cheaper than accessing a cached version in cold storage.
1150  *
1151  * _Available since v3.4._
1152  *
1153  * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
1154  */
1155 abstract contract EIP712 is IERC5267 {
1156     using ShortStrings for *;
1157 
1158     bytes32 private constant _TYPE_HASH =
1159         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1160 
1161     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1162     // invalidate the cached domain separator if the chain id changes.
1163     bytes32 private immutable _cachedDomainSeparator;
1164     uint256 private immutable _cachedChainId;
1165     address private immutable _cachedThis;
1166 
1167     bytes32 private immutable _hashedName;
1168     bytes32 private immutable _hashedVersion;
1169 
1170     ShortString private immutable _name;
1171     ShortString private immutable _version;
1172     string private _nameFallback;
1173     string private _versionFallback;
1174 
1175     /**
1176      * @dev Initializes the domain separator and parameter caches.
1177      *
1178      * The meaning of `name` and `version` is specified in
1179      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1180      *
1181      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1182      * - `version`: the current major version of the signing domain.
1183      *
1184      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1185      * contract upgrade].
1186      */
1187     constructor(string memory name, string memory version) {
1188         _name = name.toShortStringWithFallback(_nameFallback);
1189         _version = version.toShortStringWithFallback(_versionFallback);
1190         _hashedName = keccak256(bytes(name));
1191         _hashedVersion = keccak256(bytes(version));
1192 
1193         _cachedChainId = block.chainid;
1194         _cachedDomainSeparator = _buildDomainSeparator();
1195         _cachedThis = address(this);
1196     }
1197 
1198     /**
1199      * @dev Returns the domain separator for the current chain.
1200      */
1201     function _domainSeparatorV4() internal view returns (bytes32) {
1202         if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
1203             return _cachedDomainSeparator;
1204         } else {
1205             return _buildDomainSeparator();
1206         }
1207     }
1208 
1209     function _buildDomainSeparator() private view returns (bytes32) {
1210         return keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
1211     }
1212 
1213     /**
1214      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1215      * function returns the hash of the fully encoded EIP712 message for this domain.
1216      *
1217      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1218      *
1219      * ```solidity
1220      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1221      *     keccak256("Mail(address to,string contents)"),
1222      *     mailTo,
1223      *     keccak256(bytes(mailContents))
1224      * )));
1225      * address signer = ECDSA.recover(digest, signature);
1226      * ```
1227      */
1228     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1229         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1230     }
1231 
1232     /**
1233      * @dev See {EIP-5267}.
1234      *
1235      * _Available since v4.9._
1236      */
1237     function eip712Domain()
1238         public
1239         view
1240         virtual
1241         override
1242         returns (
1243             bytes1 fields,
1244             string memory name,
1245             string memory version,
1246             uint256 chainId,
1247             address verifyingContract,
1248             bytes32 salt,
1249             uint256[] memory extensions
1250         )
1251     {
1252         return (
1253             hex"0f", // 01111
1254             _name.toStringWithFallback(_nameFallback),
1255             _version.toStringWithFallback(_versionFallback),
1256             block.chainid,
1257             address(this),
1258             bytes32(0),
1259             new uint256[](0)
1260         );
1261     }
1262 }
1263 
1264 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
1265 
1266 
1267 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/draft-EIP712.sol)
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 // EIP-712 is Final as of 2022-08-11. This file is deprecated.
1272 
1273 
1274 // File: supermarket/contracts/Lib/helper.sol
1275 
1276 
1277 pragma solidity ^0.8.7;
1278 
1279 /*
1280  * @dev Provides information about the current execution context, including the
1281  * sender of the transaction and its data. While these are generally available
1282  * via msg.sender and msg.data, they should not be accessed in such a direct
1283  * manner, since when dealing with meta-transactions the account sending and
1284  * paying for execution may not be the actual sender (as far as an application
1285  * is concerned).
1286  *
1287  * This contract is only required for intermediate, library-like contracts.
1288  */
1289 abstract contract Context {
1290     function _msgSender() internal view virtual returns (address) {
1291         return msg.sender;
1292     }
1293 
1294     function _msgData() internal view virtual returns (bytes calldata) {
1295         return msg.data;
1296     }
1297 }
1298 
1299 
1300 
1301 /**
1302  * @dev Contract module which provides a basic access control mechanism, where
1303  * there is an account (an owner) that can be granted exclusive access to
1304  * specific functions.
1305  *
1306  * By default, the owner account will be the one that deploys the contract. This
1307  * can later be changed with {transferOwnership}.
1308  *
1309  * This module is used through inheritance. It will make available the modifier
1310  * `onlyOwner`, which can be applied to your functions to restrict their use to
1311  * the owner.
1312  */
1313 abstract contract Ownable is Context {
1314     address private _owner;
1315 
1316     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1317 
1318     /**
1319      * @dev Initializes the contract setting the deployer as the initial owner.
1320      */
1321     constructor() {
1322         _setOwner(_msgSender());
1323     }
1324 
1325     /**
1326      * @dev Returns the address of the current owner.
1327      */
1328     function owner() public view virtual returns (address) {
1329         return _owner;
1330     }
1331 
1332     /**
1333      * @dev Throws if called by any account other than the owner.
1334      */
1335     modifier onlyOwner() {
1336         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1337         _;
1338     }
1339 
1340     /**
1341      * @dev Leaves the contract without owner. It will not be possible to call
1342      * `onlyOwner` functions anymore. Can only be called by the current owner.
1343      *
1344      * NOTE: Renouncing ownership will leave the contract without an owner,
1345      * thereby removing any functionality that is only available to the owner.
1346      */
1347     function renounceOwnership() public virtual onlyOwner {
1348         _setOwner(address(0));
1349     }
1350 
1351     /**
1352      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1353      * Can only be called by the current owner.
1354      */
1355     function transferOwnership(address newOwner) public virtual onlyOwner {
1356         require(newOwner != address(0), "Ownable: new owner is the zero address");
1357         _setOwner(newOwner);
1358     }
1359 
1360     function _setOwner(address newOwner) private {
1361         address oldOwner = _owner;
1362         _owner = newOwner;
1363         emit OwnershipTransferred(oldOwner, newOwner);
1364     }
1365 }
1366 
1367 
1368 
1369 /**
1370  * @dev Contract module which allows children to implement an emergency stop
1371  * mechanism that can be triggered by an authorized account.
1372  *
1373  * This module is used through inheritance. It will make available the
1374  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1375  * the functions of your contract. Note that they will not be pausable by
1376  * simply including this module, only once the modifiers are put in place.
1377  */
1378 abstract contract Pausable is Context {
1379     /**
1380      * @dev Emitted when the pause is triggered by `account`.
1381      */
1382     event Paused(address account,uint256 asset);
1383 
1384     /**
1385      * @dev Emitted when the pause is lifted by `account`.
1386      */
1387     event Unpaused(address account,uint256 asset);
1388 
1389     //bool private _paused;
1390     mapping(uint256 => bool) private _paused;
1391 
1392     /**
1393      * @dev Initializes the contract in unpaused state.
1394      */
1395     constructor() {
1396         //_paused[0] = false;
1397     }
1398 
1399     /**
1400      * @dev Returns true if the contract is paused, and false otherwise.
1401      */
1402     function paused(uint256 a) public view virtual returns (bool) {
1403         return _paused[a];
1404     }
1405 
1406     /**
1407      * @dev Modifier to make a function callable only when the contract is not paused.
1408      *
1409      * Requirements:
1410      *
1411      * - The contract must not be paused.
1412      */
1413     modifier whenNotPaused(uint256 a) {
1414         require(!paused(a), "Pausable: paused");
1415         _;
1416     }
1417 
1418     /**
1419      * @dev Modifier to make a function callable only when the contract is paused.
1420      *
1421      * Requirements:
1422      *
1423      * - The contract must be paused.
1424      */
1425     modifier whenPaused(uint256 a) {
1426         require(paused(a), "Pausable: not paused");
1427         _;
1428     }
1429 
1430     /**
1431      * @dev Triggers stopped state.
1432      *
1433      * Requirements:
1434      *
1435      * - The contract must not be paused.
1436      */
1437     function _pause(uint256 a) internal virtual whenNotPaused(a) {
1438         _paused[a] = true;
1439         emit Paused(_msgSender(),a);
1440     }
1441 
1442     /**
1443      * @dev Returns to normal state.
1444      *
1445      * Requirements:
1446      *
1447      * - The contract must be paused.
1448      */
1449     function _unpause(uint256 a) internal virtual whenPaused(a) {
1450         _paused[a] = false;
1451         emit Unpaused(_msgSender(),a);
1452     }
1453 }
1454 
1455 
1456 
1457 /**
1458  * @dev Contract module that helps prevent reentrant calls to a function.
1459  *
1460  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1461  * available, which can be applied to functions to make sure there are no nested
1462  * (reentrant) calls to them.
1463  *
1464  * Note that because there is a single `nonReentrant` guard, functions marked as
1465  * `nonReentrant` may not call one another. This can be worked around by making
1466  * those functions `private`, and then adding `external` `nonReentrant` entry
1467  * points to them.
1468  *
1469  * TIP: If you would like to learn more about reentrancy and alternative ways
1470  * to protect against it, check out our blog post
1471  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1472  */
1473 abstract contract ReentrancyGuard {
1474     // Booleans are more expensive than uint256 or any type that takes up a full
1475     // word because each write operation emits an extra SLOAD to first read the
1476     // slot's contents, replace the bits taken up by the boolean, and then write
1477     // back. This is the compiler's defense against contract upgrades and
1478     // pointer aliasing, and it cannot be disabled.
1479 
1480     // The values being non-zero value makes deployment a bit more expensive,
1481     // but in exchange the refund on every call to nonReentrant will be lower in
1482     // amount. Since refunds are capped to a percentage of the total
1483     // transaction's gas, it is best to keep them low in cases like this one, to
1484     // increase the likelihood of the full refund coming into effect.
1485     uint256 private constant _NOT_ENTERED = 1;
1486     uint256 private constant _ENTERED = 2;
1487 
1488     uint256 private _status;
1489 
1490     constructor() {
1491         _status = _NOT_ENTERED;
1492     }
1493 
1494     /**
1495      * @dev Prevents a contract from calling itself, directly or indirectly.
1496      * Calling a `nonReentrant` function from another `nonReentrant`
1497      * function is not supported. It is possible to prevent this from happening
1498      * by making the `nonReentrant` function external, and make it call a
1499      * `private` function that does the actual work.
1500      */
1501     modifier nonReentrant() {
1502         // On the first call to nonReentrant, _notEntered will be true
1503         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1504 
1505         // Any calls to nonReentrant after this point will fail
1506         _status = _ENTERED;
1507 
1508         _;
1509 
1510         // By storing the original value once again, a refund is triggered (see
1511         // https://eips.ethereum.org/EIPS/eip-2200)
1512         _status = _NOT_ENTERED;
1513     }
1514 }
1515 
1516 
1517 
1518 /**
1519  * @dev Interface of the ERC20 standard as defined in the EIP.
1520  */
1521 interface IERC20 {
1522     /**
1523      * @dev Returns the amount of tokens in existence.
1524      */
1525     function totalSupply() external view returns (uint256);
1526 
1527     /**
1528      * @dev Returns the amount of tokens owned by `account`.
1529      */
1530     function balanceOf(address account) external view returns (uint256);
1531 
1532     /**
1533      * @dev Moves `amount` tokens from the caller's account to `recipient`.
1534      *
1535      * Returns a boolean value indicating whether the operation succeeded.
1536      *
1537      * Emits a {Transfer} event.
1538      */
1539     function transfer(address recipient, uint256 amount) external returns (bool);
1540 
1541     /**
1542      * @dev Returns the remaining number of tokens that `spender` will be
1543      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1544      * zero by default.
1545      *
1546      * This value changes when {approve} or {transferFrom} are called.
1547      */
1548     function allowance(address owner, address spender) external view returns (uint256);
1549 
1550     /**
1551      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1552      *
1553      * Returns a boolean value indicating whether the operation succeeded.
1554      *
1555      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1556      * that someone may use both the old and the new allowance by unfortunate
1557      * transaction ordering. One possible solution to mitigate this race
1558      * condition is to first reduce the spender's allowance to 0 and set the
1559      * desired value afterwards:
1560      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1561      *
1562      * Emits an {Approval} event.
1563      */
1564     function approve(address spender, uint256 amount) external returns (bool);
1565 
1566     /**
1567      * @dev Moves `amount` tokens from `sender` to `recipient` using the
1568      * allowance mechanism. `amount` is then deducted from the caller's
1569      * allowance.
1570      *
1571      * Returns a boolean value indicating whether the operation succeeded.
1572      *
1573      * Emits a {Transfer} event.
1574      */
1575     function transferFrom(
1576         address sender,
1577         address recipient,
1578         uint256 amount
1579     ) external returns (bool);
1580 
1581     /**
1582      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1583      * another (`to`).
1584      *
1585      * Note that `value` may be zero.
1586      */
1587     event Transfer(address indexed from, address indexed to, uint256 value);
1588 
1589     /**
1590      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1591      * a call to {approve}. `value` is the new allowance.
1592      */
1593     event Approval(address indexed owner, address indexed spender, uint256 value);
1594 }
1595 
1596 
1597 
1598 /**
1599  * @dev Collection of functions related to the address type
1600  */
1601 library Address {
1602     /**
1603      * @dev Returns true if `account` is a contract.
1604      *
1605      * [IMPORTANT]
1606      * ====
1607      * It is unsafe to assume that an address for which this function returns
1608      * false is an externally-owned account (EOA) and not a contract.
1609      *
1610      * Among others, `isContract` will return false for the following
1611      * types of addresses:
1612      *
1613      *  - an externally-owned account
1614      *  - a contract in construction
1615      *  - an address where a contract will be created
1616      *  - an address where a contract lived, but was destroyed
1617      * ====
1618      */
1619     function isContract(address account) internal view returns (bool) {
1620         // This method relies on extcodesize, which returns 0 for contracts in
1621         // construction, since the code is only stored at the end of the
1622         // constructor execution.
1623 
1624         uint256 size;
1625         assembly {
1626             size := extcodesize(account)
1627         }
1628         return size > 0;
1629     }
1630 
1631     /**
1632      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1633      * `recipient`, forwarding all available gas and reverting on errors.
1634      *
1635      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1636      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1637      * imposed by `transfer`, making them unable to receive funds via
1638      * `transfer`. {sendValue} removes this limitation.
1639      *
1640      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1641      *
1642      * IMPORTANT: because control is transferred to `recipient`, care must be
1643      * taken to not create reentrancy vulnerabilities. Consider using
1644      * {ReentrancyGuard} or the
1645      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1646      */
1647     function sendValue(address payable recipient, uint256 amount) internal {
1648         require(address(this).balance >= amount, "Address: insufficient balance");
1649 
1650         (bool success, ) = recipient.call{value: amount}("");
1651         require(success, "Address: unable to send value, recipient may have reverted");
1652     }
1653 
1654     /**
1655      * @dev Performs a Solidity function call using a low level `call`. A
1656      * plain `call` is an unsafe replacement for a function call: use this
1657      * function instead.
1658      *
1659      * If `target` reverts with a revert reason, it is bubbled up by this
1660      * function (like regular Solidity function calls).
1661      *
1662      * Returns the raw returned data. To convert to the expected return value,
1663      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1664      *
1665      * Requirements:
1666      *
1667      * - `target` must be a contract.
1668      * - calling `target` with `data` must not revert.
1669      *
1670      * _Available since v3.1._
1671      */
1672     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1673         return functionCall(target, data, "Address: low-level call failed");
1674     }
1675 
1676     /**
1677      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1678      * `errorMessage` as a fallback revert reason when `target` reverts.
1679      *
1680      * _Available since v3.1._
1681      */
1682     function functionCall(
1683         address target,
1684         bytes memory data,
1685         string memory errorMessage
1686     ) internal returns (bytes memory) {
1687         return functionCallWithValue(target, data, 0, errorMessage);
1688     }
1689 
1690     /**
1691      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1692      * but also transferring `value` wei to `target`.
1693      *
1694      * Requirements:
1695      *
1696      * - the calling contract must have an ETH balance of at least `value`.
1697      * - the called Solidity function must be `payable`.
1698      *
1699      * _Available since v3.1._
1700      */
1701     function functionCallWithValue(
1702         address target,
1703         bytes memory data,
1704         uint256 value
1705     ) internal returns (bytes memory) {
1706         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1707     }
1708 
1709     /**
1710      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1711      * with `errorMessage` as a fallback revert reason when `target` reverts.
1712      *
1713      * _Available since v3.1._
1714      */
1715     function functionCallWithValue(
1716         address target,
1717         bytes memory data,
1718         uint256 value,
1719         string memory errorMessage
1720     ) internal returns (bytes memory) {
1721         require(address(this).balance >= value, "Address: insufficient balance for call");
1722         require(isContract(target), "Address: call to non-contract");
1723 
1724         (bool success, bytes memory returndata) = target.call{value: value}(data);
1725         return _verifyCallResult(success, returndata, errorMessage);
1726     }
1727 
1728     /**
1729      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1730      * but performing a static call.
1731      *
1732      * _Available since v3.3._
1733      */
1734     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1735         return functionStaticCall(target, data, "Address: low-level static call failed");
1736     }
1737 
1738     /**
1739      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1740      * but performing a static call.
1741      *
1742      * _Available since v3.3._
1743      */
1744     function functionStaticCall(
1745         address target,
1746         bytes memory data,
1747         string memory errorMessage
1748     ) internal view returns (bytes memory) {
1749         require(isContract(target), "Address: static call to non-contract");
1750 
1751         (bool success, bytes memory returndata) = target.staticcall(data);
1752         return _verifyCallResult(success, returndata, errorMessage);
1753     }
1754 
1755     /**
1756      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1757      * but performing a delegate call.
1758      *
1759      * _Available since v3.4._
1760      */
1761     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1762         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1763     }
1764 
1765     /**
1766      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1767      * but performing a delegate call.
1768      *
1769      * _Available since v3.4._
1770      */
1771     function functionDelegateCall(
1772         address target,
1773         bytes memory data,
1774         string memory errorMessage
1775     ) internal returns (bytes memory) {
1776         require(isContract(target), "Address: delegate call to non-contract");
1777 
1778         (bool success, bytes memory returndata) = target.delegatecall(data);
1779         return _verifyCallResult(success, returndata, errorMessage);
1780     }
1781 
1782     function _verifyCallResult(
1783         bool success,
1784         bytes memory returndata,
1785         string memory errorMessage
1786     ) private pure returns (bytes memory) {
1787         if (success) {
1788             return returndata;
1789         } else {
1790             // Look for revert reason and bubble it up if present
1791             if (returndata.length > 0) {
1792                 // The easiest way to bubble the revert reason is using memory via assembly
1793 
1794                 assembly {
1795                     let returndata_size := mload(returndata)
1796                     revert(add(32, returndata), returndata_size)
1797                 }
1798             } else {
1799                 revert(errorMessage);
1800             }
1801         }
1802     }
1803 }
1804 
1805 
1806 
1807 
1808 /**
1809  * @title SafeERC20
1810  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1811  * contract returns false). Tokens that return no value (and instead revert or
1812  * throw on failure) are also supported, non-reverting calls are assumed to be
1813  * successful.
1814  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1815  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1816  */
1817 library SafeERC20 {
1818     using Address for address;
1819 
1820     function safeTransfer(
1821         IERC20 token,
1822         address to,
1823         uint256 value
1824     ) internal {
1825         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1826     }
1827 
1828     function safeTransferFrom(
1829         IERC20 token,
1830         address from,
1831         address to,
1832         uint256 value
1833     ) internal {
1834         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1835     }
1836 
1837     /**
1838      * @dev Deprecated. This function has issues similar to the ones found in
1839      * {IERC20-approve}, and its usage is discouraged.
1840      *
1841      * Whenever possible, use {safeIncreaseAllowance} and
1842      * {safeDecreaseAllowance} instead.
1843      */
1844     function safeApprove(
1845         IERC20 token,
1846         address spender,
1847         uint256 value
1848     ) internal {
1849         // safeApprove should only be called when setting an initial allowance,
1850         // or when resetting it to zero. To increase and decrease it, use
1851         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1852         require(
1853             (value == 0) || (token.allowance(address(this), spender) == 0),
1854             "SafeERC20: approve from non-zero to non-zero allowance"
1855         );
1856         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1857     }
1858 
1859     function safeIncreaseAllowance(
1860         IERC20 token,
1861         address spender,
1862         uint256 value
1863     ) internal {
1864         uint256 newAllowance = token.allowance(address(this), spender) + value;
1865         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1866     }
1867 
1868     function safeDecreaseAllowance(
1869         IERC20 token,
1870         address spender,
1871         uint256 value
1872     ) internal {
1873         unchecked {
1874             uint256 oldAllowance = token.allowance(address(this), spender);
1875             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1876             uint256 newAllowance = oldAllowance - value;
1877             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1878         }
1879     }
1880 
1881     /**
1882      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1883      * on the return value: the return value is optional (but if data is returned, it must not be false).
1884      * @param token The token targeted by the call.
1885      * @param data The call data (encoded using abi.encode or one of its variants).
1886      */
1887     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1888         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1889         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1890         // the target address contains contract code and also asserts for success in the low-level call.
1891 
1892         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1893         if (returndata.length > 0) {
1894             // Return data is optional
1895             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1896         }
1897     }
1898 }
1899 // File: supermarket/contracts/SV5.sol
1900 
1901 
1902 
1903 pragma solidity ^0.8.7;
1904 
1905 
1906 
1907 
1908 
1909 contract SuperMarketV5  is Ownable, Pausable, ReentrancyGuard, EIP712 {
1910     using SafeERC20 for IERC20;
1911     
1912 
1913     bytes32 constant public ENTRY_CALL_HASH_TYPE = keccak256("validateEntry(uint256 epoch,uint256 lev,int256 currentPrice,int256 lockPrice,uint8 position,address addr)");
1914     bytes32 constant public CLAIM_CALL_HASH_TYPE = keccak256("validateClaim(uint256 asset,uint256 round,uint256 amt,uint256 cp,address addr)");    
1915     address private SuprMktSigner =0xD1B358dD0f0D7B17d78051e6F4ACAB1AA973BCb4;
1916 
1917     address private adminAddress; // address of the admin
1918 
1919 
1920     uint256 private treasuryFee=690; // treasury rate (e.g. 200 = 2%, 150 = 1.50%)
1921     uint256 private treasuryAmount; // treasury amount that was not claimed
1922     uint256 private constant MAX_LEV = 1000; //5x [10x]
1923 
1924     //mapping(address=>bool) public operatorAddress;
1925     mapping(uint256 => mapping(address => BetInfo)) public ledger;
1926     mapping(uint256 => Round) public rounds;
1927     mapping(address => UserRound) public userRounds;
1928     mapping(uint256 => uint256[]) public activeRounds;
1929 
1930     mapping(address => bool) private wlContract;
1931  
1932 
1933     mapping(uint256 => Market) public market;
1934 
1935     IWLP public wLP; //whale LP
1936 
1937     //uint256 public chain_id;
1938 
1939     // event BetBear(address indexed sender, uint256 indexed epoch, uint256 amount,int256 lockedprice);
1940     // event BetBull(address indexed sender, uint256 indexed epoch, uint256 amount,int256 lockedprice);
1941     event SuperBet(address indexed sender, uint256 indexed epoch,Position position, uint256 amount,uint256 borrow,int256 startPrice,int256 lockedprice,uint256 currentRoundId,uint256 initTVL);
1942     event Claim(address indexed sender, uint256 indexed epoch, uint256 amount);
1943     //event EndRound(uint256 indexed epoch, uint256 indexed roundId, int256 price,uint256 totalAmount,uint256 utilizedTVL);
1944     //event LockRound(uint256 indexed epoch);
1945 
1946     event NewAdminAddress(address admin);
1947     // event NewBufferAndIntervalSeconds(uint256 bufferSeconds, uint256 intervalSeconds);
1948     // event NewMinMaxBetAmount(uint256 indexed epoch, uint256 minBetAmount,uint256 maxBetAmount);
1949     event NewTreasuryFee(uint256 indexed epoch, uint256 treasuryFee);
1950     //event OperatorAddress(address operator,bool flag);
1951 
1952 
1953 
1954     //event StartRound(uint256 indexed epoch,uint256 maxTVLAvailable);
1955     //event TokenRecovery(address indexed token, uint256 amount);
1956     //event TreasuryClaim(uint256 amount);
1957     event Unpause(uint256 indexed epoch,uint256 asset);
1958 
1959     modifier onlyAdmin() {
1960         require(msg.sender == adminAddress,"AE:00");//NOT ADMIN
1961         _;
1962     }
1963 
1964 
1965 
1966 
1967     modifier notContract() {
1968         if(wlContract[msg.sender]) return;
1969         require(!Address.isContract(msg.sender), "AE:04");//NOT CONTRACT
1970         require(msg.sender == tx.origin, "AE:05");//ONLY USER NO PROXY CONTRACT
1971         _;
1972     }
1973 
1974     
1975 
1976      /**
1977      * @notice Constructor // param _oracleAddress: oracle address
1978      * @param _wlp: whalepool
1979 
1980      */
1981     constructor(
1982   
1983         address _wlp
1984     ) EIP712('SUPRMKT','1') 
1985     {     
1986        
1987         adminAddress = msg.sender;
1988 
1989         wLP = IWLP(_wlp);
1990 
1991         }
1992 
1993     /**
1994      * @notice Bet bull/bear position
1995      * @param epoch: serial epoch id for a market asset
1996      * @param asset: Market Asset 
1997      */
1998     function superBet(uint256 epoch,uint256 asset,uint256 currentRoundId, int256 currentPrice,uint256 borrowAmount,int256 lockPrice,Position bet,bytes memory signature) external payable whenNotPaused(asset) nonReentrant notContract {
1999         //(uint256 epoch)=_getRoundIDByAssetEpoch(asset,id);//_getRoundData(epoch);
2000  
2001         BetInfo storage betInfo = ledger[epoch][msg.sender];
2002         Round storage round = rounds[epoch];
2003         Market storage mark = market[asset];
2004         userRounds[msg.sender].epochs.push(epoch);
2005         activeRounds[asset].push(epoch);
2006         
2007         (uint256 idStimeLev,uint256 rpochLtimeAmt)=_getCurrentEpochs(asset,mark.genesisStartTime,mark.initEpoch,mark.intervalSeconds);
2008         mark.lastEpoch = idStimeLev;
2009         require(epoch == rpochLtimeAmt, "SBE:00");//"Bet is too early/late"
2010         (idStimeLev,rpochLtimeAmt,)= _getRoundPeriod(idStimeLev,mark.genesisStartTime,mark.initEpoch,mark.intervalSeconds);
2011         require(
2012             (block.timestamp > idStimeLev &&
2013             block.timestamp < rpochLtimeAmt) &&
2014             ((currentRoundId/10**9) > idStimeLev && (currentRoundId/10**9) < rpochLtimeAmt)
2015             ,"SBE:01" );//"Round not bettable"); _bettable replaced
2016         require(msg.value >= mark.minBetAmount && msg.value <= mark.maxBetAmount,"SBE:02");// "Bet amount must be btwn minBetAmount-maxBetamount");
2017         require(betInfo.amount == 0,"SBE:03");// "Can only bet once per round");
2018         require(
2019             currentPrice>0 && lockPrice >0,"ZE:ZeroError"
2020         );
2021         idStimeLev=(msg.value+borrowAmount)*100/msg.value;
2022         //Digest
2023         bytes32 d = _hashEntries(epoch,idStimeLev,currentPrice,lockPrice,bet,msg.sender);
2024 
2025         //verify
2026         require(_verify(d,signature)==SuprMktSigner,"SIGN:04");//"Invalid Signature!");
2027         if(round.totalAmount == 0){
2028         round.maxTVLExposed = wLP.getMaxTVLExposed();
2029         round.initTVLExposed = round.maxTVLExposed;
2030         }
2031         require(idStimeLev<=MAX_LEV && borrowAmount <= round.maxTVLExposed,"SBE:05");//"Leverage upto 5x and borrow below max Exposed ");
2032 
2033         // Update round data
2034         rpochLtimeAmt = msg.value;
2035 
2036         round.totalAmount = round.totalAmount + rpochLtimeAmt;
2037         round.totalBorrowedAmount = round.totalBorrowedAmount + borrowAmount;
2038 
2039         // Update user data
2040 
2041         betInfo.position = bet;
2042         betInfo.amount = rpochLtimeAmt;
2043         betInfo.startPrice=currentPrice;
2044         betInfo.lockOracleId = currentRoundId;
2045         betInfo.borrowedAmount = borrowAmount;
2046 
2047 
2048         //update utilised TVL
2049         round.maxTVLExposed= round.maxTVLExposed-borrowAmount;
2050     //     if(bet == Position.Bull){
2051     //     //lockPrice = currentPrice+lockPrice;
2052     //     round.bullAmount = round.bullAmount+rpochLtimeAmt;
2053     //    // emit BetBull(msg.sender, epoch, amount,lockPrice);
2054     //     }
2055     //     else{
2056     //     //lockPrice = currentPrice-lockPrice;
2057     //     round.bearAmount = round.bearAmount+rpochLtimeAmt;
2058     //     //emit BetBear(msg.sender, epoch, amount,lockPrice);
2059     //     }
2060         betInfo.lockPrice=lockPrice;
2061         //_safeTransferBNB(address(wLP), msg.value);//transfer funds back to whale pool
2062         wLP.depositFromSuper{value:msg.value}();
2063         emit SuperBet(msg.sender, epoch,betInfo.position, betInfo.amount,betInfo.borrowedAmount,betInfo.startPrice,betInfo.lockPrice, betInfo.lockOracleId,round.initTVLExposed);
2064         
2065     }
2066  
2067     /**
2068      * @notice Claim reward for an array of epochs
2069      * @param epoch: epoch value consisting asset and round id.
2070      */
2071     function claim(uint256 epoch, uint256 amt,uint256 cp,address claimer,bytes memory signature) payable external nonReentrant notContract {
2072         uint256 cAmt;//collective Amount
2073         uint256 fee; //Initializes totalfee
2074         Round storage round = rounds[epoch];
2075         BetInfo storage betInfo = ledger[epoch][claimer];
2076         //UserRound storage usr = userRounds[msg.sender];
2077         
2078         (uint256 rid, uint256 a) = _getRoundData(epoch);
2079         (,,uint256 v) = getRoundPeriod(a, rid);
2080         
2081         require(block.timestamp>v,"CE:00");
2082         require(betInfo.lockPrice >0 && !betInfo.claimed,"CE:01" );
2083         betInfo.claimed = true;
2084         if(!(round.oracleCalled) && int(cp)>0){
2085                 round.closePrice = int256(cp);
2086                 round.oracleCalled =true;
2087             }
2088         require(round.closePrice == int(cp),"CE:02");
2089         // require((e-s)<5 && s == usr.lastClaimed,"CE:01");
2090         // require((e-s)==cp.length && e>s,"CE:02");
2091     
2092         //Digest
2093 
2094         bytes32 d = _hashClaims(a,rid,amt,cp,claimer);
2095 
2096         //verify
2097         require(_verify(d,signature)==SuprMktSigner,"SIGN:04");//"Invalid Signature!");
2098 
2099 
2100             uint256 positionAmount;
2101             //uint256 feeCollected;
2102             v =0;
2103 
2104             // Round valid, claim rewards
2105             if((int256(cp) > betInfo.lockPrice && betInfo.position == Position.Bull) ||
2106             (int256(cp) < betInfo.lockPrice && betInfo.position == Position.Bear)){
2107                 positionAmount = betInfo.amount + betInfo.borrowedAmount;
2108                 v = (positionAmount*treasuryFee)/10000;
2109             }
2110             // require(claimable(epochs[i], msg.sender),"SCE:02");// "Not eligible for claim");
2111             //Round memory round = rounds[epochs[i]];
2112 
2113                // addedReward = (ledger[epochs[i]][msg.sender].amount * round.rewardAmount) / round.rewardBaseCalAmount;
2114             positionAmount = positionAmount-v;
2115 
2116             cAmt += positionAmount;
2117             fee += v;
2118            
2119 
2120         require(amt==cAmt,"CE:AMT");
2121         //usr.lastClaimed = e;
2122         //fee =(fee*420)/1000;// 6.9-4.2
2123         //amt = amt-fee;
2124         // if(amt >0){
2125         // wLP.SuperMarketPayoutNative(claimer, amt);
2126         // wLP.SuperMarketPayoutNative(owner(), fee);
2127         // //_distributeFee(fee);
2128 
2129         // }
2130         wLP.SuperMarketPayoutNative{value:0}(msg.sender,claimer,cAmt,betInfo.amount, betInfo.borrowedAmount);
2131         emit Claim(claimer, epoch, amt);
2132     }
2133     
2134     /**
2135      * @notice Start genesis round
2136      * @dev Callable by admin or operator
2137      */
2138     function genesisStartRound(uint256 asset,uint256 t,uint256 i,uint256 duration,uint256 maxBet) external whenNotPaused(asset) onlyAdmin {
2139         Market storage mark = market[asset];
2140         require(!mark.genesisStartOnce,"SGSE:00");// "Can only run genesisStartRound once");
2141         require(duration>0 && maxBet>0,"SGSE:01");
2142         mark.genesisStartTime = t;
2143         mark.initEpoch= i;
2144         market[asset].bufferSeconds=60; // number of seconds for valid execution of a prediction round
2145         market[asset].intervalSeconds=duration; // interval in seconds between two prediction rounds
2146         market[asset].minBetAmount =  maxBet/10;
2147         market[asset].maxBetAmount = maxBet;
2148         mark.genesisStartOnce = true;
2149     }
2150 
2151     /**
2152      * @notice called by the admin to pause, triggers stopped state
2153      * @dev Callable by admin or operator
2154      */
2155     function pause(uint256 asset) external whenNotPaused(asset) onlyAdmin {
2156     _pause(asset);
2157     // (uint256 cEpoch,)=currentEpoch(asset);
2158     //     emit Pause(cEpoch,asset);
2159     }
2160 
2161     /**
2162      * @notice Claim all rewards in treasury
2163      * @dev Callable by admin
2164      */
2165     // function claimTreasury() external nonReentrant onlyAdmin {
2166     //     uint256 currentTreasuryAmount = treasuryAmount;
2167     //     treasuryAmount = 0;
2168     //     //Team, Reserve, Whales, S Whales
2169     //     _safeTransferBNB(adminAddress, currentTreasuryAmount);
2170 
2171     //     emit TreasuryClaim(currentTreasuryAmount);
2172     // }
2173 
2174     /**
2175      * @notice called by the admin to unpause, returns to normal state
2176      * Reset genesis state. Once paused, the rounds would need to be kickstarted by genesis
2177      */
2178     function unpause(uint256 asset) external whenPaused(asset) onlyAdmin {
2179         market[asset].genesisStartOnce = false;
2180         market[asset].genesisLockOnce = false;
2181         _unpause(asset);
2182         // (uint256 cEpoch,)=currentEpoch(asset);
2183         // emit Unpause(cEpoch,asset);
2184     }
2185     /**
2186      * @notice Set Market Config and interval (in seconds)
2187      * @dev Callable by admin
2188      */
2189     function setMarketConfig(uint256 asset,uint256 _bufferSeconds, uint256 _intervalSeconds,
2190     uint256 _minBetAmount,uint256 _maxBetAmount,address _wlp)external whenPaused(asset) onlyAdmin{
2191         Market storage m = market[asset];
2192         //require(_bufferSeconds < _intervalSeconds, "bufferSeconds must be inferior to intervalSeconds");
2193         m.bufferSeconds = _bufferSeconds;
2194         m.intervalSeconds = _intervalSeconds;
2195         m.minBetAmount = _minBetAmount;
2196         m.maxBetAmount = _maxBetAmount;
2197         //market[asset].oracle = AggregatorV3Interface(_oracle);
2198         wLP = IWLP(_wlp); 
2199     }
2200 
2201 
2202     function setWlContract(address c,bool f) external onlyAdmin{
2203         require(c != address(0),"WLE:00");
2204         wlContract[c]=f;
2205     }
2206 
2207     function setMemeSigner (address signer,uint256 asset) external whenPaused(asset) onlyAdmin {
2208         SuprMktSigner = signer;
2209     }
2210     /**
2211      * @notice It allows the owner to recover tokens sent to the contract by mistake
2212      * @param _token: token address
2213      * @param _amount: token amount
2214      * @dev Callable by owner
2215      */
2216     function recoverToken(address _token, uint256 _amount) external onlyOwner {
2217         IERC20(_token).safeTransfer(address(msg.sender), _amount);
2218 
2219       //  emit TokenRecovery(_token, _amount);
2220     }
2221 
2222     /**
2223      * @notice Set admin address
2224      * @dev Callable by owner
2225      */
2226     function setAdmin(address _adminAddress) external onlyOwner {
2227         require(_adminAddress != address(0),"ZE:00"); //"Cannot be zero address");
2228         adminAddress = _adminAddress;
2229 
2230         emit NewAdminAddress(_adminAddress);
2231     }
2232 
2233     /**
2234      * @notice Returns round epochs and bet information for a user that has participated
2235      * @param user: user address
2236      * @param cursor: cursor
2237      * @param size: size
2238      */
2239     function getUserRounds(
2240         address user,
2241         uint256 cursor,
2242         uint256 size
2243     )
2244         external
2245         view
2246         returns (
2247             uint256[] memory,
2248             BetInfo[] memory,
2249             uint256
2250         )
2251     {
2252         uint256 length = size;
2253 
2254         if (length > userRounds[user].epochs.length - cursor) {
2255             length = userRounds[user].epochs.length - cursor;
2256         }
2257 
2258         uint256[] memory values = new uint256[](length);
2259         BetInfo[] memory betInfo = new BetInfo[](length);
2260 
2261         for (uint256 i = 0; i < length; i++) {
2262             values[i] = userRounds[user].epochs[cursor + i];
2263             betInfo[i] = ledger[values[i]][user];
2264         }
2265 
2266         return (values, betInfo, cursor + length);
2267     }
2268 
2269     /**
2270      * @notice Returns round epochs length
2271      * @param user: user address
2272      */
2273     function getUserRoundsLength(address user) external view returns (uint256) {
2274         return userRounds[user].epochs.length;
2275     }
2276     
2277     function currentEpoch(uint256 asset) public view returns(uint256,uint256){
2278          Market memory mark = market[asset];
2279        return  _getCurrentEpochs(asset,mark.genesisStartTime,mark.initEpoch,mark.intervalSeconds);
2280        
2281     }
2282     function getRoundPeriod(uint256 asset,uint256 id) public view returns(uint256 startTimestamp, uint256 lockTimestamp,uint256 closeTimestamp){
2283         Market memory mark = market[asset];
2284        return  _getRoundPeriod(id,mark.genesisStartTime,mark.initEpoch,mark.intervalSeconds);
2285     }
2286     function _getCurrentEpochs(uint256 asset,uint256 startTime,uint256 initEpoch,uint256 duration) internal view returns(uint256 epoch,uint256 rpoch){
2287         //1+(current_time-init_time)/duration
2288         require(startTime > 0 && initEpoch >0,"ZE:STINIT");
2289     //unchecked {
2290         epoch =  initEpoch+(block.timestamp-startTime)/duration;
2291         //require(z >= x, "Your custom message here");
2292     //}
2293        
2294         rpoch = _getRoundIDByAssetEpoch(asset,epoch);
2295 
2296     }
2297     function _getRoundPeriod(uint256 epoch,uint256 startTime,uint256 initEpoch,uint256 duration) internal pure returns(uint256 startTimestamp, uint256 lockTimestamp,uint256 closeTimestamp){
2298         require(startTime > 0 && initEpoch >0,"ZE:STINIT");
2299         startTimestamp = (epoch-initEpoch)*duration+startTime;
2300         lockTimestamp = startTimestamp + duration;//Betting Period Ends
2301         closeTimestamp = startTimestamp + (2 * duration);
2302     }
2303     function _getRoundData(uint256 id) public pure returns(uint256 ri,uint256 m){
2304         ri = (id>>64);
2305         m = id & uint256(0xFFFFFFFFFFFFFFFF);
2306    
2307     }
2308     function _getRoundIDByAssetEpoch(uint256 asset,uint epoch) public pure returns(uint256 roundId) {
2309         roundId = uint256((uint256(epoch) << 64) | asset);
2310     }
2311     function getCurrentTVLExposed() public view  returns(uint256){
2312         return wLP.getMaxTVLExposed();
2313     }
2314     /**
2315      * @notice Get the claimable stats of specific epoch and user account
2316      * @param epoch: epoch
2317      * @param user: user address
2318     //  */
2319     // function claimable(uint256 epoch, address user) public view returns (bool) {
2320     //     BetInfo memory betInfo = ledger[epoch][user];
2321     //     Round memory round = rounds[epoch];
2322     //     if (betInfo.lockPrice == round.closePrice) {
2323     //         return false;
2324     //     }
2325     //     return
2326     //         round.oracleCalled &&
2327     //         betInfo.amount != 0 &&
2328     //         !betInfo.claimed &&
2329     //         ((round.closePrice > betInfo.lockPrice && betInfo.position == Position.Bull) ||
2330     //         (round.closePrice < betInfo.lockPrice && betInfo.position == Position.Bear));
2331     // }
2332 
2333 
2334     /**
2335      * @notice Get the refundable stats of specific epoch and user account
2336      * @param epoch: epoch
2337      * @param user: user address
2338      */
2339     // function refundable(uint256 epoch, address user) public view returns (bool) {
2340     //     BetInfo memory betInfo = ledger[epoch][user];
2341     //     Round memory round = rounds[epoch];
2342     //     (,uint256 asset)= _getRoundData(epoch);
2343     //     return
2344     //         !round.oracleCalled &&
2345     //         !betInfo.claimed &&
2346     //         block.timestamp > round.closeTimestamp + market[asset].bufferSeconds &&
2347     //         betInfo.amount != 0;
2348     // }
2349 
2350     /**
2351      * @notice Calculate rewards for round
2352      * @param epoch: epoch
2353      *
2354     function _calculateRewards(uint256 epoch) internal {
2355         require(rounds[epoch].rewardBaseCalAmount == 0 && rounds[epoch].rewardAmount == 0, "Rewards calculated");
2356         Round storage round = rounds[epoch];
2357         uint256 rewardBaseCalAmount;
2358         uint256 treasuryAmt;
2359         uint256 rewardAmount;
2360 
2361         // Bull wins
2362         if (round.closePrice > round.lockPrice) {
2363             rewardBaseCalAmount = round.bullAmount;
2364             treasuryAmt = (round.totalAmount * treasuryFee) / 10000;
2365             rewardAmount = round.totalAmount - treasuryAmt;
2366         }
2367         // Bear wins
2368         else if (round.closePrice < round.lockPrice) {
2369             rewardBaseCalAmount = round.bearAmount;
2370             treasuryAmt = (round.totalAmount * treasuryFee) / 10000;
2371             rewardAmount = round.totalAmount - treasuryAmt;
2372         }
2373         // House wins
2374         else {
2375             rewardBaseCalAmount = 0;
2376             rewardAmount = 0;
2377             treasuryAmt = round.totalAmount;
2378         }
2379         round.rewardBaseCalAmount = rewardBaseCalAmount;
2380         round.rewardAmount = rewardAmount;
2381 
2382         // Add to treasury
2383         treasuryAmount += treasuryAmt;
2384 
2385         emit RewardsCalculated(epoch, rewardBaseCalAmount, rewardAmount, treasuryAmt);
2386     }
2387     */
2388 
2389     /**
2390      * @notice Transfer BNB in a safe way
2391      * @param to: address to transfer BNB to
2392      * @param value: BNB amount to transfer (in wei)
2393      */
2394     function _safeTransferBNB(address to, uint256 value) internal {
2395         (bool success, ) = to.call{value: value}("");
2396         require(success, "TE:00");//"TransferHelper: BNB_TRANSFER_FAILED");
2397     }
2398 
2399     // function _distributeFee(uint256 fee) internal {
2400     //     //TO_DO where to distribute fee.
2401     //     fee =(fee*4200)/10000;
2402     //     //_safeTransferBNB(owner(), fee);
2403     // }
2404 
2405     /**
2406      * @notice Start round
2407      * Previous round n-2 must end
2408      * @param epoch: epoch
2409      */
2410     // function _startRound(uint256 epoch,uint256 intervalSeconds) internal {
2411     //     Round storage round = rounds[epoch];
2412     //     round.startTimestamp = block.timestamp;
2413     //     round.lockTimestamp = block.timestamp + intervalSeconds;//Betting Period Ends
2414     //     round.closeTimestamp = block.timestamp + (2 * intervalSeconds);
2415     //     round.epoch = epoch;
2416     //     round.totalAmount = 0;
2417     //     (round.maxTVLExposed,) = wLP.getMaxTVLExposed();
2418 
2419     //     emit StartRound(epoch,round.maxTVLExposed);
2420     // }
2421 
2422     /**
2423      * @notice Determine if a round is valid for receiving bets
2424      * Round must have started and locked
2425      * Current timestamp must be within startTimestamp and closeTimestamp
2426      */
2427     // function _bettable(uint256 epoch) internal view returns (bool) {
2428     //     return
2429     //         rounds[epoch].startTimestamp != 0 &&
2430     //         rounds[epoch].lockTimestamp != 0 &&
2431     //         block.timestamp > rounds[epoch].startTimestamp &&
2432     //         block.timestamp < rounds[epoch].lockTimestamp;
2433     // }
2434 
2435     /**
2436      * @notice Get latest recorded price from oracle
2437      * If it falls below allowed buffer or has not updated, it would be invalid.
2438      */
2439     // function _getPriceFromOracle(uint256 oracleUpdateAllowance,uint256 oracleLatestRoundId,AggregatorV3Interface oracle) internal view returns (uint80, int256) {
2440     //     uint256 leastAllowedTimestamp = block.timestamp + oracleUpdateAllowance;
2441     //     (uint80 roundId, int256 price, , uint256 timestamp, ) = oracle.latestRoundData();
2442     //     require(timestamp <= leastAllowedTimestamp,"OE:00");// "Oracle update exceeded max timestamp allowance");
2443     //     require(
2444     //         uint256(roundId) > oracleLatestRoundId,"OE:01"
2445     //         //"Oracle update roundId must be larger than oracleLatestRoundId"
2446     //     );
2447     //     return (roundId, price);
2448     // }
2449     /**
2450      *
2451      *
2452      */
2453     function _hashEntries(uint256 epoch,uint256 lev,int256 currentPrice,int256 lockPrice,Position position,address _address) public view  returns(bytes32){
2454    
2455         return _hashTypedDataV4(keccak256(abi.encode(ENTRY_CALL_HASH_TYPE,epoch,lev,currentPrice,lockPrice,position,_address)));
2456     }
2457     function _hashClaims(uint256 asset,uint256 round,uint256 amt,uint256 cp,address _address) public view  returns(bytes32){
2458         
2459        // return _hashTypedDataV4(keccak256(abi.encode(CLAIM_CALL_HASH_TYPE,start,end,amt,keccak256(abi.encodePacked(cp)),_address)));
2460        return _hashTypedDataV4(keccak256(abi.encode(CLAIM_CALL_HASH_TYPE,asset,round,amt,cp,_address)));
2461     }
2462     function _verify(bytes32 digest, bytes memory signature) public pure  returns(address){
2463         return ECDSA.recover(digest,signature);
2464     }
2465 }