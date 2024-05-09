1 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
2 
3 pragma solidity >=0.6.2;
4 
5 interface IUniswapV2Router01 {
6     function factory() external pure returns (address);
7     function WETH() external pure returns (address);
8 
9     function addLiquidity(
10         address tokenA,
11         address tokenB,
12         uint amountADesired,
13         uint amountBDesired,
14         uint amountAMin,
15         uint amountBMin,
16         address to,
17         uint deadline
18     ) external returns (uint amountA, uint amountB, uint liquidity);
19     function addLiquidityETH(
20         address token,
21         uint amountTokenDesired,
22         uint amountTokenMin,
23         uint amountETHMin,
24         address to,
25         uint deadline
26     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
27     function removeLiquidity(
28         address tokenA,
29         address tokenB,
30         uint liquidity,
31         uint amountAMin,
32         uint amountBMin,
33         address to,
34         uint deadline
35     ) external returns (uint amountA, uint amountB);
36     function removeLiquidityETH(
37         address token,
38         uint liquidity,
39         uint amountTokenMin,
40         uint amountETHMin,
41         address to,
42         uint deadline
43     ) external returns (uint amountToken, uint amountETH);
44     function removeLiquidityWithPermit(
45         address tokenA,
46         address tokenB,
47         uint liquidity,
48         uint amountAMin,
49         uint amountBMin,
50         address to,
51         uint deadline,
52         bool approveMax, uint8 v, bytes32 r, bytes32 s
53     ) external returns (uint amountA, uint amountB);
54     function removeLiquidityETHWithPermit(
55         address token,
56         uint liquidity,
57         uint amountTokenMin,
58         uint amountETHMin,
59         address to,
60         uint deadline,
61         bool approveMax, uint8 v, bytes32 r, bytes32 s
62     ) external returns (uint amountToken, uint amountETH);
63     function swapExactTokensForTokens(
64         uint amountIn,
65         uint amountOutMin,
66         address[] calldata path,
67         address to,
68         uint deadline
69     ) external returns (uint[] memory amounts);
70     function swapTokensForExactTokens(
71         uint amountOut,
72         uint amountInMax,
73         address[] calldata path,
74         address to,
75         uint deadline
76     ) external returns (uint[] memory amounts);
77     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
78         external
79         payable
80         returns (uint[] memory amounts);
81     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
82         external
83         returns (uint[] memory amounts);
84     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
85         external
86         returns (uint[] memory amounts);
87     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
88         external
89         payable
90         returns (uint[] memory amounts);
91 
92     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
93     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
94     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
95     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
96     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
97 }
98 
99 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol
100 
101 pragma solidity >=0.6.2;
102 
103 
104 interface IUniswapV2Router02 is IUniswapV2Router01 {
105     function removeLiquidityETHSupportingFeeOnTransferTokens(
106         address token,
107         uint liquidity,
108         uint amountTokenMin,
109         uint amountETHMin,
110         address to,
111         uint deadline
112     ) external returns (uint amountETH);
113     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
114         address token,
115         uint liquidity,
116         uint amountTokenMin,
117         uint amountETHMin,
118         address to,
119         uint deadline,
120         bool approveMax, uint8 v, bytes32 r, bytes32 s
121     ) external returns (uint amountETH);
122 
123     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function swapExactETHForTokensSupportingFeeOnTransferTokens(
131         uint amountOutMin,
132         address[] calldata path,
133         address to,
134         uint deadline
135     ) external payable;
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint amountIn,
138         uint amountOutMin,
139         address[] calldata path,
140         address to,
141         uint deadline
142     ) external;
143 }
144 
145 // File: @uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol
146 
147 pragma solidity >=0.5.0;
148 
149 interface IUniswapV2Factory {
150     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
151 
152     function feeTo() external view returns (address);
153     function feeToSetter() external view returns (address);
154 
155     function getPair(address tokenA, address tokenB) external view returns (address pair);
156     function allPairs(uint) external view returns (address pair);
157     function allPairsLength() external view returns (uint);
158 
159     function createPair(address tokenA, address tokenB) external returns (address pair);
160 
161     function setFeeTo(address) external;
162     function setFeeToSetter(address) external;
163 }
164 
165 // File: @openzeppelin/contracts/utils/Counters.sol
166 
167 
168 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
169 
170 pragma solidity ^0.8.0;
171 
172 /**
173  * @title Counters
174  * @author Matt Condon (@shrugs)
175  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
176  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
177  *
178  * Include with `using Counters for Counters.Counter;`
179  */
180 library Counters {
181     struct Counter {
182         // This variable should never be directly accessed by users of the library: interactions must be restricted to
183         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
184         // this feature: see https://github.com/ethereum/solidity/issues/4637
185         uint256 _value; // default: 0
186     }
187 
188     function current(Counter storage counter) internal view returns (uint256) {
189         return counter._value;
190     }
191 
192     function increment(Counter storage counter) internal {
193         unchecked {
194             counter._value += 1;
195         }
196     }
197 
198     function decrement(Counter storage counter) internal {
199         uint256 value = counter._value;
200         require(value > 0, "Counter: decrement overflow");
201         unchecked {
202             counter._value = value - 1;
203         }
204     }
205 
206     function reset(Counter storage counter) internal {
207         counter._value = 0;
208     }
209 }
210 
211 // File: @openzeppelin/contracts/interfaces/IERC5267.sol
212 
213 
214 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC5267.sol)
215 
216 pragma solidity ^0.8.0;
217 
218 interface IERC5267 {
219     /**
220      * @dev MAY be emitted to signal that the domain could have changed.
221      */
222     event EIP712DomainChanged();
223 
224     /**
225      * @dev returns the fields and values that describe the domain separator used by this contract for EIP-712
226      * signature.
227      */
228     function eip712Domain()
229         external
230         view
231         returns (
232             bytes1 fields,
233             string memory name,
234             string memory version,
235             uint256 chainId,
236             address verifyingContract,
237             bytes32 salt,
238             uint256[] memory extensions
239         );
240 }
241 
242 // File: @openzeppelin/contracts/utils/StorageSlot.sol
243 
244 
245 // OpenZeppelin Contracts (last updated v4.9.0) (utils/StorageSlot.sol)
246 // This file was procedurally generated from scripts/generate/templates/StorageSlot.js.
247 
248 pragma solidity ^0.8.0;
249 
250 /**
251  * @dev Library for reading and writing primitive types to specific storage slots.
252  *
253  * Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
254  * This library helps with reading and writing to such slots without the need for inline assembly.
255  *
256  * The functions in this library return Slot structs that contain a `value` member that can be used to read or write.
257  *
258  * Example usage to set ERC1967 implementation slot:
259  * ```solidity
260  * contract ERC1967 {
261  *     bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;
262  *
263  *     function _getImplementation() internal view returns (address) {
264  *         return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
265  *     }
266  *
267  *     function _setImplementation(address newImplementation) internal {
268  *         require(Address.isContract(newImplementation), "ERC1967: new implementation is not a contract");
269  *         StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = newImplementation;
270  *     }
271  * }
272  * ```
273  *
274  * _Available since v4.1 for `address`, `bool`, `bytes32`, `uint256`._
275  * _Available since v4.9 for `string`, `bytes`._
276  */
277 library StorageSlot {
278     struct AddressSlot {
279         address value;
280     }
281 
282     struct BooleanSlot {
283         bool value;
284     }
285 
286     struct Bytes32Slot {
287         bytes32 value;
288     }
289 
290     struct Uint256Slot {
291         uint256 value;
292     }
293 
294     struct StringSlot {
295         string value;
296     }
297 
298     struct BytesSlot {
299         bytes value;
300     }
301 
302     /**
303      * @dev Returns an `AddressSlot` with member `value` located at `slot`.
304      */
305     function getAddressSlot(bytes32 slot) internal pure returns (AddressSlot storage r) {
306         /// @solidity memory-safe-assembly
307         assembly {
308             r.slot := slot
309         }
310     }
311 
312     /**
313      * @dev Returns an `BooleanSlot` with member `value` located at `slot`.
314      */
315     function getBooleanSlot(bytes32 slot) internal pure returns (BooleanSlot storage r) {
316         /// @solidity memory-safe-assembly
317         assembly {
318             r.slot := slot
319         }
320     }
321 
322     /**
323      * @dev Returns an `Bytes32Slot` with member `value` located at `slot`.
324      */
325     function getBytes32Slot(bytes32 slot) internal pure returns (Bytes32Slot storage r) {
326         /// @solidity memory-safe-assembly
327         assembly {
328             r.slot := slot
329         }
330     }
331 
332     /**
333      * @dev Returns an `Uint256Slot` with member `value` located at `slot`.
334      */
335     function getUint256Slot(bytes32 slot) internal pure returns (Uint256Slot storage r) {
336         /// @solidity memory-safe-assembly
337         assembly {
338             r.slot := slot
339         }
340     }
341 
342     /**
343      * @dev Returns an `StringSlot` with member `value` located at `slot`.
344      */
345     function getStringSlot(bytes32 slot) internal pure returns (StringSlot storage r) {
346         /// @solidity memory-safe-assembly
347         assembly {
348             r.slot := slot
349         }
350     }
351 
352     /**
353      * @dev Returns an `StringSlot` representation of the string storage pointer `store`.
354      */
355     function getStringSlot(string storage store) internal pure returns (StringSlot storage r) {
356         /// @solidity memory-safe-assembly
357         assembly {
358             r.slot := store.slot
359         }
360     }
361 
362     /**
363      * @dev Returns an `BytesSlot` with member `value` located at `slot`.
364      */
365     function getBytesSlot(bytes32 slot) internal pure returns (BytesSlot storage r) {
366         /// @solidity memory-safe-assembly
367         assembly {
368             r.slot := slot
369         }
370     }
371 
372     /**
373      * @dev Returns an `BytesSlot` representation of the bytes storage pointer `store`.
374      */
375     function getBytesSlot(bytes storage store) internal pure returns (BytesSlot storage r) {
376         /// @solidity memory-safe-assembly
377         assembly {
378             r.slot := store.slot
379         }
380     }
381 }
382 
383 // File: @openzeppelin/contracts/utils/ShortStrings.sol
384 
385 
386 // OpenZeppelin Contracts (last updated v4.9.0) (utils/ShortStrings.sol)
387 
388 pragma solidity ^0.8.8;
389 
390 
391 // | string  | 0xAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA   |
392 // | length  | 0x                                                              BB |
393 type ShortString is bytes32;
394 
395 /**
396  * @dev This library provides functions to convert short memory strings
397  * into a `ShortString` type that can be used as an immutable variable.
398  *
399  * Strings of arbitrary length can be optimized using this library if
400  * they are short enough (up to 31 bytes) by packing them with their
401  * length (1 byte) in a single EVM word (32 bytes). Additionally, a
402  * fallback mechanism can be used for every other case.
403  *
404  * Usage example:
405  *
406  * ```solidity
407  * contract Named {
408  *     using ShortStrings for *;
409  *
410  *     ShortString private immutable _name;
411  *     string private _nameFallback;
412  *
413  *     constructor(string memory contractName) {
414  *         _name = contractName.toShortStringWithFallback(_nameFallback);
415  *     }
416  *
417  *     function name() external view returns (string memory) {
418  *         return _name.toStringWithFallback(_nameFallback);
419  *     }
420  * }
421  * ```
422  */
423 library ShortStrings {
424     // Used as an identifier for strings longer than 31 bytes.
425     bytes32 private constant _FALLBACK_SENTINEL = 0x00000000000000000000000000000000000000000000000000000000000000FF;
426 
427     error StringTooLong(string str);
428     error InvalidShortString();
429 
430     /**
431      * @dev Encode a string of at most 31 chars into a `ShortString`.
432      *
433      * This will trigger a `StringTooLong` error is the input string is too long.
434      */
435     function toShortString(string memory str) internal pure returns (ShortString) {
436         bytes memory bstr = bytes(str);
437         if (bstr.length > 31) {
438             revert StringTooLong(str);
439         }
440         return ShortString.wrap(bytes32(uint256(bytes32(bstr)) | bstr.length));
441     }
442 
443     /**
444      * @dev Decode a `ShortString` back to a "normal" string.
445      */
446     function toString(ShortString sstr) internal pure returns (string memory) {
447         uint256 len = byteLength(sstr);
448         // using `new string(len)` would work locally but is not memory safe.
449         string memory str = new string(32);
450         /// @solidity memory-safe-assembly
451         assembly {
452             mstore(str, len)
453             mstore(add(str, 0x20), sstr)
454         }
455         return str;
456     }
457 
458     /**
459      * @dev Return the length of a `ShortString`.
460      */
461     function byteLength(ShortString sstr) internal pure returns (uint256) {
462         uint256 result = uint256(ShortString.unwrap(sstr)) & 0xFF;
463         if (result > 31) {
464             revert InvalidShortString();
465         }
466         return result;
467     }
468 
469     /**
470      * @dev Encode a string into a `ShortString`, or write it to storage if it is too long.
471      */
472     function toShortStringWithFallback(string memory value, string storage store) internal returns (ShortString) {
473         if (bytes(value).length < 32) {
474             return toShortString(value);
475         } else {
476             StorageSlot.getStringSlot(store).value = value;
477             return ShortString.wrap(_FALLBACK_SENTINEL);
478         }
479     }
480 
481     /**
482      * @dev Decode a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
483      */
484     function toStringWithFallback(ShortString value, string storage store) internal pure returns (string memory) {
485         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
486             return toString(value);
487         } else {
488             return store;
489         }
490     }
491 
492     /**
493      * @dev Return the length of a string that was encoded to `ShortString` or written to storage using {setWithFallback}.
494      *
495      * WARNING: This will return the "byte length" of the string. This may not reflect the actual length in terms of
496      * actual characters as the UTF-8 encoding of a single character can span over multiple bytes.
497      */
498     function byteLengthWithFallback(ShortString value, string storage store) internal view returns (uint256) {
499         if (ShortString.unwrap(value) != _FALLBACK_SENTINEL) {
500             return byteLength(value);
501         } else {
502             return bytes(store).length;
503         }
504     }
505 }
506 
507 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
508 
509 
510 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
511 
512 pragma solidity ^0.8.0;
513 
514 /**
515  * @dev Standard signed math utilities missing in the Solidity language.
516  */
517 library SignedMath {
518     /**
519      * @dev Returns the largest of two signed numbers.
520      */
521     function max(int256 a, int256 b) internal pure returns (int256) {
522         return a > b ? a : b;
523     }
524 
525     /**
526      * @dev Returns the smallest of two signed numbers.
527      */
528     function min(int256 a, int256 b) internal pure returns (int256) {
529         return a < b ? a : b;
530     }
531 
532     /**
533      * @dev Returns the average of two signed numbers without overflow.
534      * The result is rounded towards zero.
535      */
536     function average(int256 a, int256 b) internal pure returns (int256) {
537         // Formula from the book "Hacker's Delight"
538         int256 x = (a & b) + ((a ^ b) >> 1);
539         return x + (int256(uint256(x) >> 255) & (a ^ b));
540     }
541 
542     /**
543      * @dev Returns the absolute unsigned value of a signed value.
544      */
545     function abs(int256 n) internal pure returns (uint256) {
546         unchecked {
547             // must be unchecked in order to support `n = type(int256).min`
548             return uint256(n >= 0 ? n : -n);
549         }
550     }
551 }
552 
553 // File: @openzeppelin/contracts/utils/math/Math.sol
554 
555 
556 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
557 
558 pragma solidity ^0.8.0;
559 
560 /**
561  * @dev Standard math utilities missing in the Solidity language.
562  */
563 library Math {
564     enum Rounding {
565         Down, // Toward negative infinity
566         Up, // Toward infinity
567         Zero // Toward zero
568     }
569 
570     /**
571      * @dev Returns the largest of two numbers.
572      */
573     function max(uint256 a, uint256 b) internal pure returns (uint256) {
574         return a > b ? a : b;
575     }
576 
577     /**
578      * @dev Returns the smallest of two numbers.
579      */
580     function min(uint256 a, uint256 b) internal pure returns (uint256) {
581         return a < b ? a : b;
582     }
583 
584     /**
585      * @dev Returns the average of two numbers. The result is rounded towards
586      * zero.
587      */
588     function average(uint256 a, uint256 b) internal pure returns (uint256) {
589         // (a + b) / 2 can overflow.
590         return (a & b) + (a ^ b) / 2;
591     }
592 
593     /**
594      * @dev Returns the ceiling of the division of two numbers.
595      *
596      * This differs from standard division with `/` in that it rounds up instead
597      * of rounding down.
598      */
599     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
600         // (a + b - 1) / b can overflow on addition, so we distribute.
601         return a == 0 ? 0 : (a - 1) / b + 1;
602     }
603 
604     /**
605      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
606      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
607      * with further edits by Uniswap Labs also under MIT license.
608      */
609     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
610         unchecked {
611             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
612             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
613             // variables such that product = prod1 * 2^256 + prod0.
614             uint256 prod0; // Least significant 256 bits of the product
615             uint256 prod1; // Most significant 256 bits of the product
616             assembly {
617                 let mm := mulmod(x, y, not(0))
618                 prod0 := mul(x, y)
619                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
620             }
621 
622             // Handle non-overflow cases, 256 by 256 division.
623             if (prod1 == 0) {
624                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
625                 // The surrounding unchecked block does not change this fact.
626                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
627                 return prod0 / denominator;
628             }
629 
630             // Make sure the result is less than 2^256. Also prevents denominator == 0.
631             require(denominator > prod1, "Math: mulDiv overflow");
632 
633             ///////////////////////////////////////////////
634             // 512 by 256 division.
635             ///////////////////////////////////////////////
636 
637             // Make division exact by subtracting the remainder from [prod1 prod0].
638             uint256 remainder;
639             assembly {
640                 // Compute remainder using mulmod.
641                 remainder := mulmod(x, y, denominator)
642 
643                 // Subtract 256 bit number from 512 bit number.
644                 prod1 := sub(prod1, gt(remainder, prod0))
645                 prod0 := sub(prod0, remainder)
646             }
647 
648             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
649             // See https://cs.stackexchange.com/q/138556/92363.
650 
651             // Does not overflow because the denominator cannot be zero at this stage in the function.
652             uint256 twos = denominator & (~denominator + 1);
653             assembly {
654                 // Divide denominator by twos.
655                 denominator := div(denominator, twos)
656 
657                 // Divide [prod1 prod0] by twos.
658                 prod0 := div(prod0, twos)
659 
660                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
661                 twos := add(div(sub(0, twos), twos), 1)
662             }
663 
664             // Shift in bits from prod1 into prod0.
665             prod0 |= prod1 * twos;
666 
667             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
668             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
669             // four bits. That is, denominator * inv = 1 mod 2^4.
670             uint256 inverse = (3 * denominator) ^ 2;
671 
672             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
673             // in modular arithmetic, doubling the correct bits in each step.
674             inverse *= 2 - denominator * inverse; // inverse mod 2^8
675             inverse *= 2 - denominator * inverse; // inverse mod 2^16
676             inverse *= 2 - denominator * inverse; // inverse mod 2^32
677             inverse *= 2 - denominator * inverse; // inverse mod 2^64
678             inverse *= 2 - denominator * inverse; // inverse mod 2^128
679             inverse *= 2 - denominator * inverse; // inverse mod 2^256
680 
681             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
682             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
683             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
684             // is no longer required.
685             result = prod0 * inverse;
686             return result;
687         }
688     }
689 
690     /**
691      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
692      */
693     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
694         uint256 result = mulDiv(x, y, denominator);
695         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
696             result += 1;
697         }
698         return result;
699     }
700 
701     /**
702      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
703      *
704      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
705      */
706     function sqrt(uint256 a) internal pure returns (uint256) {
707         if (a == 0) {
708             return 0;
709         }
710 
711         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
712         //
713         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
714         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
715         //
716         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
717         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
718         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
719         //
720         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
721         uint256 result = 1 << (log2(a) >> 1);
722 
723         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
724         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
725         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
726         // into the expected uint128 result.
727         unchecked {
728             result = (result + a / result) >> 1;
729             result = (result + a / result) >> 1;
730             result = (result + a / result) >> 1;
731             result = (result + a / result) >> 1;
732             result = (result + a / result) >> 1;
733             result = (result + a / result) >> 1;
734             result = (result + a / result) >> 1;
735             return min(result, a / result);
736         }
737     }
738 
739     /**
740      * @notice Calculates sqrt(a), following the selected rounding direction.
741      */
742     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
743         unchecked {
744             uint256 result = sqrt(a);
745             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
746         }
747     }
748 
749     /**
750      * @dev Return the log in base 2, rounded down, of a positive value.
751      * Returns 0 if given 0.
752      */
753     function log2(uint256 value) internal pure returns (uint256) {
754         uint256 result = 0;
755         unchecked {
756             if (value >> 128 > 0) {
757                 value >>= 128;
758                 result += 128;
759             }
760             if (value >> 64 > 0) {
761                 value >>= 64;
762                 result += 64;
763             }
764             if (value >> 32 > 0) {
765                 value >>= 32;
766                 result += 32;
767             }
768             if (value >> 16 > 0) {
769                 value >>= 16;
770                 result += 16;
771             }
772             if (value >> 8 > 0) {
773                 value >>= 8;
774                 result += 8;
775             }
776             if (value >> 4 > 0) {
777                 value >>= 4;
778                 result += 4;
779             }
780             if (value >> 2 > 0) {
781                 value >>= 2;
782                 result += 2;
783             }
784             if (value >> 1 > 0) {
785                 result += 1;
786             }
787         }
788         return result;
789     }
790 
791     /**
792      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
793      * Returns 0 if given 0.
794      */
795     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
796         unchecked {
797             uint256 result = log2(value);
798             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
799         }
800     }
801 
802     /**
803      * @dev Return the log in base 10, rounded down, of a positive value.
804      * Returns 0 if given 0.
805      */
806     function log10(uint256 value) internal pure returns (uint256) {
807         uint256 result = 0;
808         unchecked {
809             if (value >= 10 ** 64) {
810                 value /= 10 ** 64;
811                 result += 64;
812             }
813             if (value >= 10 ** 32) {
814                 value /= 10 ** 32;
815                 result += 32;
816             }
817             if (value >= 10 ** 16) {
818                 value /= 10 ** 16;
819                 result += 16;
820             }
821             if (value >= 10 ** 8) {
822                 value /= 10 ** 8;
823                 result += 8;
824             }
825             if (value >= 10 ** 4) {
826                 value /= 10 ** 4;
827                 result += 4;
828             }
829             if (value >= 10 ** 2) {
830                 value /= 10 ** 2;
831                 result += 2;
832             }
833             if (value >= 10 ** 1) {
834                 result += 1;
835             }
836         }
837         return result;
838     }
839 
840     /**
841      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
842      * Returns 0 if given 0.
843      */
844     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
845         unchecked {
846             uint256 result = log10(value);
847             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
848         }
849     }
850 
851     /**
852      * @dev Return the log in base 256, rounded down, of a positive value.
853      * Returns 0 if given 0.
854      *
855      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
856      */
857     function log256(uint256 value) internal pure returns (uint256) {
858         uint256 result = 0;
859         unchecked {
860             if (value >> 128 > 0) {
861                 value >>= 128;
862                 result += 16;
863             }
864             if (value >> 64 > 0) {
865                 value >>= 64;
866                 result += 8;
867             }
868             if (value >> 32 > 0) {
869                 value >>= 32;
870                 result += 4;
871             }
872             if (value >> 16 > 0) {
873                 value >>= 16;
874                 result += 2;
875             }
876             if (value >> 8 > 0) {
877                 result += 1;
878             }
879         }
880         return result;
881     }
882 
883     /**
884      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
885      * Returns 0 if given 0.
886      */
887     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
888         unchecked {
889             uint256 result = log256(value);
890             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
891         }
892     }
893 }
894 
895 // File: @openzeppelin/contracts/utils/Strings.sol
896 
897 
898 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 
904 /**
905  * @dev String operations.
906  */
907 library Strings {
908     bytes16 private constant _SYMBOLS = "0123456789abcdef";
909     uint8 private constant _ADDRESS_LENGTH = 20;
910 
911     /**
912      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
913      */
914     function toString(uint256 value) internal pure returns (string memory) {
915         unchecked {
916             uint256 length = Math.log10(value) + 1;
917             string memory buffer = new string(length);
918             uint256 ptr;
919             /// @solidity memory-safe-assembly
920             assembly {
921                 ptr := add(buffer, add(32, length))
922             }
923             while (true) {
924                 ptr--;
925                 /// @solidity memory-safe-assembly
926                 assembly {
927                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
928                 }
929                 value /= 10;
930                 if (value == 0) break;
931             }
932             return buffer;
933         }
934     }
935 
936     /**
937      * @dev Converts a `int256` to its ASCII `string` decimal representation.
938      */
939     function toString(int256 value) internal pure returns (string memory) {
940         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
941     }
942 
943     /**
944      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
945      */
946     function toHexString(uint256 value) internal pure returns (string memory) {
947         unchecked {
948             return toHexString(value, Math.log256(value) + 1);
949         }
950     }
951 
952     /**
953      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
954      */
955     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
956         bytes memory buffer = new bytes(2 * length + 2);
957         buffer[0] = "0";
958         buffer[1] = "x";
959         for (uint256 i = 2 * length + 1; i > 1; --i) {
960             buffer[i] = _SYMBOLS[value & 0xf];
961             value >>= 4;
962         }
963         require(value == 0, "Strings: hex length insufficient");
964         return string(buffer);
965     }
966 
967     /**
968      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
969      */
970     function toHexString(address addr) internal pure returns (string memory) {
971         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
972     }
973 
974     /**
975      * @dev Returns true if the two strings are equal.
976      */
977     function equal(string memory a, string memory b) internal pure returns (bool) {
978         return keccak256(bytes(a)) == keccak256(bytes(b));
979     }
980 }
981 
982 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
983 
984 
985 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/ECDSA.sol)
986 
987 pragma solidity ^0.8.0;
988 
989 
990 /**
991  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
992  *
993  * These functions can be used to verify that a message was signed by the holder
994  * of the private keys of a given address.
995  */
996 library ECDSA {
997     enum RecoverError {
998         NoError,
999         InvalidSignature,
1000         InvalidSignatureLength,
1001         InvalidSignatureS,
1002         InvalidSignatureV // Deprecated in v4.8
1003     }
1004 
1005     function _throwError(RecoverError error) private pure {
1006         if (error == RecoverError.NoError) {
1007             return; // no error: do nothing
1008         } else if (error == RecoverError.InvalidSignature) {
1009             revert("ECDSA: invalid signature");
1010         } else if (error == RecoverError.InvalidSignatureLength) {
1011             revert("ECDSA: invalid signature length");
1012         } else if (error == RecoverError.InvalidSignatureS) {
1013             revert("ECDSA: invalid signature 's' value");
1014         }
1015     }
1016 
1017     /**
1018      * @dev Returns the address that signed a hashed message (`hash`) with
1019      * `signature` or error string. This address can then be used for verification purposes.
1020      *
1021      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1022      * this function rejects them by requiring the `s` value to be in the lower
1023      * half order, and the `v` value to be either 27 or 28.
1024      *
1025      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1026      * verification to be secure: it is possible to craft signatures that
1027      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1028      * this is by receiving a hash of the original message (which may otherwise
1029      * be too long), and then calling {toEthSignedMessageHash} on it.
1030      *
1031      * Documentation for signature generation:
1032      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1033      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1034      *
1035      * _Available since v4.3._
1036      */
1037     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1038         if (signature.length == 65) {
1039             bytes32 r;
1040             bytes32 s;
1041             uint8 v;
1042             // ecrecover takes the signature parameters, and the only way to get them
1043             // currently is to use assembly.
1044             /// @solidity memory-safe-assembly
1045             assembly {
1046                 r := mload(add(signature, 0x20))
1047                 s := mload(add(signature, 0x40))
1048                 v := byte(0, mload(add(signature, 0x60)))
1049             }
1050             return tryRecover(hash, v, r, s);
1051         } else {
1052             return (address(0), RecoverError.InvalidSignatureLength);
1053         }
1054     }
1055 
1056     /**
1057      * @dev Returns the address that signed a hashed message (`hash`) with
1058      * `signature`. This address can then be used for verification purposes.
1059      *
1060      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1061      * this function rejects them by requiring the `s` value to be in the lower
1062      * half order, and the `v` value to be either 27 or 28.
1063      *
1064      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1065      * verification to be secure: it is possible to craft signatures that
1066      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1067      * this is by receiving a hash of the original message (which may otherwise
1068      * be too long), and then calling {toEthSignedMessageHash} on it.
1069      */
1070     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1071         (address recovered, RecoverError error) = tryRecover(hash, signature);
1072         _throwError(error);
1073         return recovered;
1074     }
1075 
1076     /**
1077      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1078      *
1079      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1080      *
1081      * _Available since v4.3._
1082      */
1083     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
1084         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
1085         uint8 v = uint8((uint256(vs) >> 255) + 27);
1086         return tryRecover(hash, v, r, s);
1087     }
1088 
1089     /**
1090      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1091      *
1092      * _Available since v4.2._
1093      */
1094     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
1095         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1096         _throwError(error);
1097         return recovered;
1098     }
1099 
1100     /**
1101      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1102      * `r` and `s` signature fields separately.
1103      *
1104      * _Available since v4.3._
1105      */
1106     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
1107         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1108         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1109         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1110         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1111         //
1112         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1113         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1114         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1115         // these malleable signatures as well.
1116         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1117             return (address(0), RecoverError.InvalidSignatureS);
1118         }
1119 
1120         // If the signature is valid (and not malleable), return the signer address
1121         address signer = ecrecover(hash, v, r, s);
1122         if (signer == address(0)) {
1123             return (address(0), RecoverError.InvalidSignature);
1124         }
1125 
1126         return (signer, RecoverError.NoError);
1127     }
1128 
1129     /**
1130      * @dev Overload of {ECDSA-recover} that receives the `v`,
1131      * `r` and `s` signature fields separately.
1132      */
1133     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
1134         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1135         _throwError(error);
1136         return recovered;
1137     }
1138 
1139     /**
1140      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1141      * produces hash corresponding to the one signed with the
1142      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1143      * JSON-RPC method as part of EIP-191.
1144      *
1145      * See {recover}.
1146      */
1147     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
1148         // 32 is the length in bytes of hash,
1149         // enforced by the type signature above
1150         /// @solidity memory-safe-assembly
1151         assembly {
1152             mstore(0x00, "\x19Ethereum Signed Message:\n32")
1153             mstore(0x1c, hash)
1154             message := keccak256(0x00, 0x3c)
1155         }
1156     }
1157 
1158     /**
1159      * @dev Returns an Ethereum Signed Message, created from `s`. This
1160      * produces hash corresponding to the one signed with the
1161      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1162      * JSON-RPC method as part of EIP-191.
1163      *
1164      * See {recover}.
1165      */
1166     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1167         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1168     }
1169 
1170     /**
1171      * @dev Returns an Ethereum Signed Typed Data, created from a
1172      * `domainSeparator` and a `structHash`. This produces hash corresponding
1173      * to the one signed with the
1174      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1175      * JSON-RPC method as part of EIP-712.
1176      *
1177      * See {recover}.
1178      */
1179     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
1180         /// @solidity memory-safe-assembly
1181         assembly {
1182             let ptr := mload(0x40)
1183             mstore(ptr, "\x19\x01")
1184             mstore(add(ptr, 0x02), domainSeparator)
1185             mstore(add(ptr, 0x22), structHash)
1186             data := keccak256(ptr, 0x42)
1187         }
1188     }
1189 
1190     /**
1191      * @dev Returns an Ethereum Signed Data with intended validator, created from a
1192      * `validator` and `data` according to the version 0 of EIP-191.
1193      *
1194      * See {recover}.
1195      */
1196     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
1197         return keccak256(abi.encodePacked("\x19\x00", validator, data));
1198     }
1199 }
1200 
1201 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
1202 
1203 
1204 // OpenZeppelin Contracts (last updated v4.9.0) (utils/cryptography/EIP712.sol)
1205 
1206 pragma solidity ^0.8.8;
1207 
1208 
1209 
1210 
1211 /**
1212  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1213  *
1214  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1215  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1216  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1217  *
1218  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1219  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1220  * ({_hashTypedDataV4}).
1221  *
1222  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1223  * the chain id to protect against replay attacks on an eventual fork of the chain.
1224  *
1225  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1226  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1227  *
1228  * NOTE: In the upgradeable version of this contract, the cached values will correspond to the address, and the domain
1229  * separator of the implementation contract. This will cause the `_domainSeparatorV4` function to always rebuild the
1230  * separator from the immutable values, which is cheaper than accessing a cached version in cold storage.
1231  *
1232  * _Available since v3.4._
1233  *
1234  * @custom:oz-upgrades-unsafe-allow state-variable-immutable state-variable-assignment
1235  */
1236 abstract contract EIP712 is IERC5267 {
1237     using ShortStrings for *;
1238 
1239     bytes32 private constant _TYPE_HASH =
1240         keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
1241 
1242     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1243     // invalidate the cached domain separator if the chain id changes.
1244     bytes32 private immutable _cachedDomainSeparator;
1245     uint256 private immutable _cachedChainId;
1246     address private immutable _cachedThis;
1247 
1248     bytes32 private immutable _hashedName;
1249     bytes32 private immutable _hashedVersion;
1250 
1251     ShortString private immutable _name;
1252     ShortString private immutable _version;
1253     string private _nameFallback;
1254     string private _versionFallback;
1255 
1256     /**
1257      * @dev Initializes the domain separator and parameter caches.
1258      *
1259      * The meaning of `name` and `version` is specified in
1260      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1261      *
1262      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1263      * - `version`: the current major version of the signing domain.
1264      *
1265      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1266      * contract upgrade].
1267      */
1268     constructor(string memory name, string memory version) {
1269         _name = name.toShortStringWithFallback(_nameFallback);
1270         _version = version.toShortStringWithFallback(_versionFallback);
1271         _hashedName = keccak256(bytes(name));
1272         _hashedVersion = keccak256(bytes(version));
1273 
1274         _cachedChainId = block.chainid;
1275         _cachedDomainSeparator = _buildDomainSeparator();
1276         _cachedThis = address(this);
1277     }
1278 
1279     /**
1280      * @dev Returns the domain separator for the current chain.
1281      */
1282     function _domainSeparatorV4() internal view returns (bytes32) {
1283         if (address(this) == _cachedThis && block.chainid == _cachedChainId) {
1284             return _cachedDomainSeparator;
1285         } else {
1286             return _buildDomainSeparator();
1287         }
1288     }
1289 
1290     function _buildDomainSeparator() private view returns (bytes32) {
1291         return keccak256(abi.encode(_TYPE_HASH, _hashedName, _hashedVersion, block.chainid, address(this)));
1292     }
1293 
1294     /**
1295      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1296      * function returns the hash of the fully encoded EIP712 message for this domain.
1297      *
1298      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1299      *
1300      * ```solidity
1301      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1302      *     keccak256("Mail(address to,string contents)"),
1303      *     mailTo,
1304      *     keccak256(bytes(mailContents))
1305      * )));
1306      * address signer = ECDSA.recover(digest, signature);
1307      * ```
1308      */
1309     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1310         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1311     }
1312 
1313     /**
1314      * @dev See {EIP-5267}.
1315      *
1316      * _Available since v4.9._
1317      */
1318     function eip712Domain()
1319         public
1320         view
1321         virtual
1322         override
1323         returns (
1324             bytes1 fields,
1325             string memory name,
1326             string memory version,
1327             uint256 chainId,
1328             address verifyingContract,
1329             bytes32 salt,
1330             uint256[] memory extensions
1331         )
1332     {
1333         return (
1334             hex"0f", // 01111
1335             _name.toStringWithFallback(_nameFallback),
1336             _version.toStringWithFallback(_versionFallback),
1337             block.chainid,
1338             address(this),
1339             bytes32(0),
1340             new uint256[](0)
1341         );
1342     }
1343 }
1344 
1345 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1346 
1347 
1348 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1349 
1350 pragma solidity ^0.8.0;
1351 
1352 /**
1353  * @dev Interface of the ERC20 standard as defined in the EIP.
1354  */
1355 interface IERC20 {
1356     /**
1357      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1358      * another (`to`).
1359      *
1360      * Note that `value` may be zero.
1361      */
1362     event Transfer(address indexed from, address indexed to, uint256 value);
1363 
1364     /**
1365      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1366      * a call to {approve}. `value` is the new allowance.
1367      */
1368     event Approval(address indexed owner, address indexed spender, uint256 value);
1369 
1370     /**
1371      * @dev Returns the amount of tokens in existence.
1372      */
1373     function totalSupply() external view returns (uint256);
1374 
1375     /**
1376      * @dev Returns the amount of tokens owned by `account`.
1377      */
1378     function balanceOf(address account) external view returns (uint256);
1379 
1380     /**
1381      * @dev Moves `amount` tokens from the caller's account to `to`.
1382      *
1383      * Returns a boolean value indicating whether the operation succeeded.
1384      *
1385      * Emits a {Transfer} event.
1386      */
1387     function transfer(address to, uint256 amount) external returns (bool);
1388 
1389     /**
1390      * @dev Returns the remaining number of tokens that `spender` will be
1391      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1392      * zero by default.
1393      *
1394      * This value changes when {approve} or {transferFrom} are called.
1395      */
1396     function allowance(address owner, address spender) external view returns (uint256);
1397 
1398     /**
1399      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1400      *
1401      * Returns a boolean value indicating whether the operation succeeded.
1402      *
1403      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1404      * that someone may use both the old and the new allowance by unfortunate
1405      * transaction ordering. One possible solution to mitigate this race
1406      * condition is to first reduce the spender's allowance to 0 and set the
1407      * desired value afterwards:
1408      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1409      *
1410      * Emits an {Approval} event.
1411      */
1412     function approve(address spender, uint256 amount) external returns (bool);
1413 
1414     /**
1415      * @dev Moves `amount` tokens from `from` to `to` using the
1416      * allowance mechanism. `amount` is then deducted from the caller's
1417      * allowance.
1418      *
1419      * Returns a boolean value indicating whether the operation succeeded.
1420      *
1421      * Emits a {Transfer} event.
1422      */
1423     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1424 }
1425 
1426 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1427 
1428 
1429 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1430 
1431 pragma solidity ^0.8.0;
1432 
1433 
1434 /**
1435  * @dev Interface for the optional metadata functions from the ERC20 standard.
1436  *
1437  * _Available since v4.1._
1438  */
1439 interface IERC20Metadata is IERC20 {
1440     /**
1441      * @dev Returns the name of the token.
1442      */
1443     function name() external view returns (string memory);
1444 
1445     /**
1446      * @dev Returns the symbol of the token.
1447      */
1448     function symbol() external view returns (string memory);
1449 
1450     /**
1451      * @dev Returns the decimals places of the token.
1452      */
1453     function decimals() external view returns (uint8);
1454 }
1455 
1456 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Permit.sol
1457 
1458 
1459 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/IERC20Permit.sol)
1460 
1461 pragma solidity ^0.8.0;
1462 
1463 /**
1464  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1465  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1466  *
1467  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1468  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1469  * need to send a transaction, and thus is not required to hold Ether at all.
1470  */
1471 interface IERC20Permit {
1472     /**
1473      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1474      * given ``owner``'s signed approval.
1475      *
1476      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1477      * ordering also apply here.
1478      *
1479      * Emits an {Approval} event.
1480      *
1481      * Requirements:
1482      *
1483      * - `spender` cannot be the zero address.
1484      * - `deadline` must be a timestamp in the future.
1485      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1486      * over the EIP712-formatted function arguments.
1487      * - the signature must use ``owner``'s current nonce (see {nonces}).
1488      *
1489      * For more information on the signature format, see the
1490      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1491      * section].
1492      */
1493     function permit(
1494         address owner,
1495         address spender,
1496         uint256 value,
1497         uint256 deadline,
1498         uint8 v,
1499         bytes32 r,
1500         bytes32 s
1501     ) external;
1502 
1503     /**
1504      * @dev Returns the current nonce for `owner`. This value must be
1505      * included whenever a signature is generated for {permit}.
1506      *
1507      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1508      * prevents a signature from being used multiple times.
1509      */
1510     function nonces(address owner) external view returns (uint256);
1511 
1512     /**
1513      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1514      */
1515     // solhint-disable-next-line func-name-mixedcase
1516     function DOMAIN_SEPARATOR() external view returns (bytes32);
1517 }
1518 
1519 // File: @openzeppelin/contracts/utils/Context.sol
1520 
1521 
1522 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1523 
1524 pragma solidity ^0.8.0;
1525 
1526 /**
1527  * @dev Provides information about the current execution context, including the
1528  * sender of the transaction and its data. While these are generally available
1529  * via msg.sender and msg.data, they should not be accessed in such a direct
1530  * manner, since when dealing with meta-transactions the account sending and
1531  * paying for execution may not be the actual sender (as far as an application
1532  * is concerned).
1533  *
1534  * This contract is only required for intermediate, library-like contracts.
1535  */
1536 abstract contract Context {
1537     function _msgSender() internal view virtual returns (address) {
1538         return msg.sender;
1539     }
1540 
1541     function _msgData() internal view virtual returns (bytes calldata) {
1542         return msg.data;
1543     }
1544 }
1545 
1546 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1547 
1548 
1549 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1550 
1551 pragma solidity ^0.8.0;
1552 
1553 
1554 
1555 
1556 /**
1557  * @dev Implementation of the {IERC20} interface.
1558  *
1559  * This implementation is agnostic to the way tokens are created. This means
1560  * that a supply mechanism has to be added in a derived contract using {_mint}.
1561  * For a generic mechanism see {ERC20PresetMinterPauser}.
1562  *
1563  * TIP: For a detailed writeup see our guide
1564  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1565  * to implement supply mechanisms].
1566  *
1567  * The default value of {decimals} is 18. To change this, you should override
1568  * this function so it returns a different value.
1569  *
1570  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1571  * instead returning `false` on failure. This behavior is nonetheless
1572  * conventional and does not conflict with the expectations of ERC20
1573  * applications.
1574  *
1575  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1576  * This allows applications to reconstruct the allowance for all accounts just
1577  * by listening to said events. Other implementations of the EIP may not emit
1578  * these events, as it isn't required by the specification.
1579  *
1580  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1581  * functions have been added to mitigate the well-known issues around setting
1582  * allowances. See {IERC20-approve}.
1583  */
1584 contract ERC20 is Context, IERC20, IERC20Metadata {
1585     mapping(address => uint256) private _balances;
1586 
1587     mapping(address => mapping(address => uint256)) private _allowances;
1588 
1589     uint256 private _totalSupply;
1590 
1591     string private _name;
1592     string private _symbol;
1593 
1594     /**
1595      * @dev Sets the values for {name} and {symbol}.
1596      *
1597      * All two of these values are immutable: they can only be set once during
1598      * construction.
1599      */
1600     constructor(string memory name_, string memory symbol_) {
1601         _name = name_;
1602         _symbol = symbol_;
1603     }
1604 
1605     /**
1606      * @dev Returns the name of the token.
1607      */
1608     function name() public view virtual override returns (string memory) {
1609         return _name;
1610     }
1611 
1612     /**
1613      * @dev Returns the symbol of the token, usually a shorter version of the
1614      * name.
1615      */
1616     function symbol() public view virtual override returns (string memory) {
1617         return _symbol;
1618     }
1619 
1620     /**
1621      * @dev Returns the number of decimals used to get its user representation.
1622      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1623      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1624      *
1625      * Tokens usually opt for a value of 18, imitating the relationship between
1626      * Ether and Wei. This is the default value returned by this function, unless
1627      * it's overridden.
1628      *
1629      * NOTE: This information is only used for _display_ purposes: it in
1630      * no way affects any of the arithmetic of the contract, including
1631      * {IERC20-balanceOf} and {IERC20-transfer}.
1632      */
1633     function decimals() public view virtual override returns (uint8) {
1634         return 18;
1635     }
1636 
1637     /**
1638      * @dev See {IERC20-totalSupply}.
1639      */
1640     function totalSupply() public view virtual override returns (uint256) {
1641         return _totalSupply;
1642     }
1643 
1644     /**
1645      * @dev See {IERC20-balanceOf}.
1646      */
1647     function balanceOf(address account) public view virtual override returns (uint256) {
1648         return _balances[account];
1649     }
1650 
1651     /**
1652      * @dev See {IERC20-transfer}.
1653      *
1654      * Requirements:
1655      *
1656      * - `to` cannot be the zero address.
1657      * - the caller must have a balance of at least `amount`.
1658      */
1659     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1660         address owner = _msgSender();
1661         _transfer(owner, to, amount);
1662         return true;
1663     }
1664 
1665     /**
1666      * @dev See {IERC20-allowance}.
1667      */
1668     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1669         return _allowances[owner][spender];
1670     }
1671 
1672     /**
1673      * @dev See {IERC20-approve}.
1674      *
1675      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1676      * `transferFrom`. This is semantically equivalent to an infinite approval.
1677      *
1678      * Requirements:
1679      *
1680      * - `spender` cannot be the zero address.
1681      */
1682     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1683         address owner = _msgSender();
1684         _approve(owner, spender, amount);
1685         return true;
1686     }
1687 
1688     /**
1689      * @dev See {IERC20-transferFrom}.
1690      *
1691      * Emits an {Approval} event indicating the updated allowance. This is not
1692      * required by the EIP. See the note at the beginning of {ERC20}.
1693      *
1694      * NOTE: Does not update the allowance if the current allowance
1695      * is the maximum `uint256`.
1696      *
1697      * Requirements:
1698      *
1699      * - `from` and `to` cannot be the zero address.
1700      * - `from` must have a balance of at least `amount`.
1701      * - the caller must have allowance for ``from``'s tokens of at least
1702      * `amount`.
1703      */
1704     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1705         address spender = _msgSender();
1706         _spendAllowance(from, spender, amount);
1707         _transfer(from, to, amount);
1708         return true;
1709     }
1710 
1711     /**
1712      * @dev Atomically increases the allowance granted to `spender` by the caller.
1713      *
1714      * This is an alternative to {approve} that can be used as a mitigation for
1715      * problems described in {IERC20-approve}.
1716      *
1717      * Emits an {Approval} event indicating the updated allowance.
1718      *
1719      * Requirements:
1720      *
1721      * - `spender` cannot be the zero address.
1722      */
1723     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1724         address owner = _msgSender();
1725         _approve(owner, spender, allowance(owner, spender) + addedValue);
1726         return true;
1727     }
1728 
1729     /**
1730      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1731      *
1732      * This is an alternative to {approve} that can be used as a mitigation for
1733      * problems described in {IERC20-approve}.
1734      *
1735      * Emits an {Approval} event indicating the updated allowance.
1736      *
1737      * Requirements:
1738      *
1739      * - `spender` cannot be the zero address.
1740      * - `spender` must have allowance for the caller of at least
1741      * `subtractedValue`.
1742      */
1743     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1744         address owner = _msgSender();
1745         uint256 currentAllowance = allowance(owner, spender);
1746         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1747         unchecked {
1748             _approve(owner, spender, currentAllowance - subtractedValue);
1749         }
1750 
1751         return true;
1752     }
1753 
1754     /**
1755      * @dev Moves `amount` of tokens from `from` to `to`.
1756      *
1757      * This internal function is equivalent to {transfer}, and can be used to
1758      * e.g. implement automatic token fees, slashing mechanisms, etc.
1759      *
1760      * Emits a {Transfer} event.
1761      *
1762      * Requirements:
1763      *
1764      * - `from` cannot be the zero address.
1765      * - `to` cannot be the zero address.
1766      * - `from` must have a balance of at least `amount`.
1767      */
1768     function _transfer(address from, address to, uint256 amount) internal virtual {
1769         require(from != address(0), "ERC20: transfer from the zero address");
1770         require(to != address(0), "ERC20: transfer to the zero address");
1771 
1772         _beforeTokenTransfer(from, to, amount);
1773 
1774         uint256 fromBalance = _balances[from];
1775         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1776         unchecked {
1777             _balances[from] = fromBalance - amount;
1778             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1779             // decrementing then incrementing.
1780             _balances[to] += amount;
1781         }
1782 
1783         emit Transfer(from, to, amount);
1784 
1785         _afterTokenTransfer(from, to, amount);
1786     }
1787 
1788     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1789      * the total supply.
1790      *
1791      * Emits a {Transfer} event with `from` set to the zero address.
1792      *
1793      * Requirements:
1794      *
1795      * - `account` cannot be the zero address.
1796      */
1797     function _mint(address account, uint256 amount) internal virtual {
1798         require(account != address(0), "ERC20: mint to the zero address");
1799 
1800         _beforeTokenTransfer(address(0), account, amount);
1801 
1802         _totalSupply += amount;
1803         unchecked {
1804             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1805             _balances[account] += amount;
1806         }
1807         emit Transfer(address(0), account, amount);
1808 
1809         _afterTokenTransfer(address(0), account, amount);
1810     }
1811 
1812     /**
1813      * @dev Destroys `amount` tokens from `account`, reducing the
1814      * total supply.
1815      *
1816      * Emits a {Transfer} event with `to` set to the zero address.
1817      *
1818      * Requirements:
1819      *
1820      * - `account` cannot be the zero address.
1821      * - `account` must have at least `amount` tokens.
1822      */
1823     function _burn(address account, uint256 amount) internal virtual {
1824         require(account != address(0), "ERC20: burn from the zero address");
1825 
1826         _beforeTokenTransfer(account, address(0), amount);
1827 
1828         uint256 accountBalance = _balances[account];
1829         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1830         unchecked {
1831             _balances[account] = accountBalance - amount;
1832             // Overflow not possible: amount <= accountBalance <= totalSupply.
1833             _totalSupply -= amount;
1834         }
1835 
1836         emit Transfer(account, address(0), amount);
1837 
1838         _afterTokenTransfer(account, address(0), amount);
1839     }
1840 
1841     /**
1842      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1843      *
1844      * This internal function is equivalent to `approve`, and can be used to
1845      * e.g. set automatic allowances for certain subsystems, etc.
1846      *
1847      * Emits an {Approval} event.
1848      *
1849      * Requirements:
1850      *
1851      * - `owner` cannot be the zero address.
1852      * - `spender` cannot be the zero address.
1853      */
1854     function _approve(address owner, address spender, uint256 amount) internal virtual {
1855         require(owner != address(0), "ERC20: approve from the zero address");
1856         require(spender != address(0), "ERC20: approve to the zero address");
1857 
1858         _allowances[owner][spender] = amount;
1859         emit Approval(owner, spender, amount);
1860     }
1861 
1862     /**
1863      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1864      *
1865      * Does not update the allowance amount in case of infinite allowance.
1866      * Revert if not enough allowance is available.
1867      *
1868      * Might emit an {Approval} event.
1869      */
1870     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1871         uint256 currentAllowance = allowance(owner, spender);
1872         if (currentAllowance != type(uint256).max) {
1873             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1874             unchecked {
1875                 _approve(owner, spender, currentAllowance - amount);
1876             }
1877         }
1878     }
1879 
1880     /**
1881      * @dev Hook that is called before any transfer of tokens. This includes
1882      * minting and burning.
1883      *
1884      * Calling conditions:
1885      *
1886      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1887      * will be transferred to `to`.
1888      * - when `from` is zero, `amount` tokens will be minted for `to`.
1889      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1890      * - `from` and `to` are never both zero.
1891      *
1892      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1893      */
1894     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1895 
1896     /**
1897      * @dev Hook that is called after any transfer of tokens. This includes
1898      * minting and burning.
1899      *
1900      * Calling conditions:
1901      *
1902      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1903      * has been transferred to `to`.
1904      * - when `from` is zero, `amount` tokens have been minted for `to`.
1905      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1906      * - `from` and `to` are never both zero.
1907      *
1908      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1909      */
1910     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1911 }
1912 
1913 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol
1914 
1915 
1916 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/extensions/ERC20Permit.sol)
1917 
1918 pragma solidity ^0.8.0;
1919 
1920 
1921 
1922 
1923 
1924 
1925 /**
1926  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1927  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1928  *
1929  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1930  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1931  * need to send a transaction, and thus is not required to hold Ether at all.
1932  *
1933  * _Available since v3.4._
1934  */
1935 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1936     using Counters for Counters.Counter;
1937 
1938     mapping(address => Counters.Counter) private _nonces;
1939 
1940     // solhint-disable-next-line var-name-mixedcase
1941     bytes32 private constant _PERMIT_TYPEHASH =
1942         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1943     /**
1944      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1945      * However, to ensure consistency with the upgradeable transpiler, we will continue
1946      * to reserve a slot.
1947      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1948      */
1949     // solhint-disable-next-line var-name-mixedcase
1950     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1951 
1952     /**
1953      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1954      *
1955      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1956      */
1957     constructor(string memory name) EIP712(name, "1") {}
1958 
1959     /**
1960      * @dev See {IERC20Permit-permit}.
1961      */
1962     function permit(
1963         address owner,
1964         address spender,
1965         uint256 value,
1966         uint256 deadline,
1967         uint8 v,
1968         bytes32 r,
1969         bytes32 s
1970     ) public virtual override {
1971         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1972 
1973         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1974 
1975         bytes32 hash = _hashTypedDataV4(structHash);
1976 
1977         address signer = ECDSA.recover(hash, v, r, s);
1978         require(signer == owner, "ERC20Permit: invalid signature");
1979 
1980         _approve(owner, spender, value);
1981     }
1982 
1983     /**
1984      * @dev See {IERC20Permit-nonces}.
1985      */
1986     function nonces(address owner) public view virtual override returns (uint256) {
1987         return _nonces[owner].current();
1988     }
1989 
1990     /**
1991      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1992      */
1993     // solhint-disable-next-line func-name-mixedcase
1994     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1995         return _domainSeparatorV4();
1996     }
1997 
1998     /**
1999      * @dev "Consume a nonce": return the current value and increment.
2000      *
2001      * _Available since v4.1._
2002      */
2003     function _useNonce(address owner) internal virtual returns (uint256 current) {
2004         Counters.Counter storage nonce = _nonces[owner];
2005         current = nonce.current();
2006         nonce.increment();
2007     }
2008 }
2009 
2010 // File: @openzeppelin/contracts/access/Ownable.sol
2011 
2012 
2013 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
2014 
2015 pragma solidity ^0.8.0;
2016 
2017 
2018 /**
2019  * @dev Contract module which provides a basic access control mechanism, where
2020  * there is an account (an owner) that can be granted exclusive access to
2021  * specific functions.
2022  *
2023  * By default, the owner account will be the one that deploys the contract. This
2024  * can later be changed with {transferOwnership}.
2025  *
2026  * This module is used through inheritance. It will make available the modifier
2027  * `onlyOwner`, which can be applied to your functions to restrict their use to
2028  * the owner.
2029  */
2030 abstract contract Ownable is Context {
2031     address private _owner;
2032 
2033     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2034 
2035     /**
2036      * @dev Initializes the contract setting the deployer as the initial owner.
2037      */
2038     constructor() {
2039         _transferOwnership(_msgSender());
2040     }
2041 
2042     /**
2043      * @dev Throws if called by any account other than the owner.
2044      */
2045     modifier onlyOwner() {
2046         _checkOwner();
2047         _;
2048     }
2049 
2050     /**
2051      * @dev Returns the address of the current owner.
2052      */
2053     function owner() public view virtual returns (address) {
2054         return _owner;
2055     }
2056 
2057     /**
2058      * @dev Throws if the sender is not the owner.
2059      */
2060     function _checkOwner() internal view virtual {
2061         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2062     }
2063 
2064     /**
2065      * @dev Leaves the contract without owner. It will not be possible to call
2066      * `onlyOwner` functions. Can only be called by the current owner.
2067      *
2068      * NOTE: Renouncing ownership will leave the contract without an owner,
2069      * thereby disabling any functionality that is only available to the owner.
2070      */
2071     function renounceOwnership() public virtual onlyOwner {
2072         _transferOwnership(address(0));
2073     }
2074 
2075     /**
2076      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2077      * Can only be called by the current owner.
2078      */
2079     function transferOwnership(address newOwner) public virtual onlyOwner {
2080         require(newOwner != address(0), "Ownable: new owner is the zero address");
2081         _transferOwnership(newOwner);
2082     }
2083 
2084     /**
2085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2086      * Internal function without access restriction.
2087      */
2088     function _transferOwnership(address newOwner) internal virtual {
2089         address oldOwner = _owner;
2090         _owner = newOwner;
2091         emit OwnershipTransferred(oldOwner, newOwner);
2092     }
2093 }
2094 
2095 // File: mikecoinfinal/Final.sol
2096 
2097 
2098 pragma solidity 0.8.20;
2099 
2100 
2101 
2102 
2103 
2104 contract Mike is ERC20Permit, Ownable {
2105     uint256 constant NAUGHTY_TIMEOUT = 7200; // blocks
2106     address public immutable UNISWAP_V2_PAIR;
2107 
2108     mapping(address => uint256) public mikesNaughtyList;
2109 
2110     uint256 public maxWalletAmount;
2111     uint256 public deadblockExpiration;
2112 
2113     bool public limitsEnabled;
2114     bool public tradingActive;
2115 
2116     mapping(address => bool) private _exclusionList;
2117 
2118     constructor() ERC20Permit("Mike") ERC20("Mike", "MIKE") {
2119         _updateExclusionList(msg.sender, true);
2120         _mint(msg.sender, 10_000_000_000 ether);
2121 
2122         UNISWAP_V2_PAIR = IUniswapV2Factory(
2123             0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
2124         ).createPair(address(this), 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
2125     }
2126 
2127     function _transfer(
2128         address from,
2129         address to,
2130         uint256 amount
2131     ) internal override {
2132         require(amount > 0, "amount must be greater than 0");
2133 
2134         if (!tradingActive) {
2135             require(
2136                 isExcluded(from) || isExcluded(to),
2137                 "transfers are not yet active"
2138             );
2139         }
2140 
2141         if (isNaughty(from)) {
2142             require(
2143                 block.number > mikesNaughtyList[from],
2144                 "MikesNFT has timed you out! Boop!"
2145             );
2146         }
2147 
2148         if (limitsEnabled) {
2149             if (from == UNISWAP_V2_PAIR && !isExcluded(to)) {
2150                 if (block.number < deadblockExpiration) {
2151                     mikesNaughtyList[to] = block.number + NAUGHTY_TIMEOUT;
2152                 }
2153             } else if (to == UNISWAP_V2_PAIR && !isExcluded(from)) {
2154                 if (block.number < deadblockExpiration) {
2155                     mikesNaughtyList[from] = block.number + NAUGHTY_TIMEOUT;
2156                 }
2157             }
2158 
2159             if (
2160                 to != UNISWAP_V2_PAIR &&
2161                 !isExcluded(to) &&
2162                 !isExcluded(from) &&
2163                 maxWalletAmount > 0
2164             ) {
2165                 require(
2166                     balanceOf(to) + amount <= maxWalletAmount,
2167                     "amount exceeds wallet limit"
2168                 );
2169             }
2170         }
2171 
2172         super._transfer(from, to, amount);
2173     }
2174 
2175     function updateTradingStatus(uint256 deadBlocks) external onlyOwner {
2176         updateLimitsEnabled(true);
2177 
2178         tradingActive = true;
2179 
2180         if (deadblockExpiration == 0) {
2181             deadblockExpiration = block.number + deadBlocks;
2182         }
2183     }
2184 
2185     function updateExclusionList(
2186         address[] calldata addresses,
2187         bool value
2188     ) public onlyOwner {
2189         for (uint256 i; i < addresses.length; ) {
2190             _updateExclusionList(addresses[i], value);
2191             unchecked {
2192                 i++;
2193             }
2194         }
2195     }
2196 
2197     function _updateExclusionList(address account, bool value) private {
2198         _exclusionList[account] = value;
2199     }
2200 
2201     function isExcluded(address account) public view returns (bool) {
2202         return _exclusionList[account];
2203     }
2204 
2205     function updateMikesNaughtyList(
2206         address[] calldata addresses,
2207         uint256 blockNumber
2208     ) external onlyOwner {
2209         for (uint256 i; i < addresses.length; ) {
2210             mikesNaughtyList[addresses[i]] = blockNumber;
2211             unchecked {
2212                 i++;
2213             }
2214         }
2215     }
2216 
2217     function isNaughty(address account) public view returns (bool) {
2218         return !isExcluded(account) && mikesNaughtyList[account] > 0;
2219     }
2220 
2221     function updateMaxWalletAmount(uint256 newAmount) external onlyOwner {
2222         maxWalletAmount = newAmount;
2223     }
2224 
2225     function updateLimitsEnabled(bool enabled) public onlyOwner {
2226         limitsEnabled = enabled;
2227     }
2228 }