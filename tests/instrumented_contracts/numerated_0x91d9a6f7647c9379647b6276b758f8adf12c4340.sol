1 /**
2 
3 Missed #SAITAMA? Here is your second chance! #SAITAMA2
4 
5 https://t.me/SAITAMA2_ETH
6 
7 https://twitter.com/saitama2coineth
8 
9 https://www.saitama2.vip
10 
11 */
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity ^0.8.4;
16 
17 interface IPancakePair {
18     event Approval(address indexed owner, address indexed spender, uint value);
19     event Transfer(address indexed from, address indexed to, uint value);
20 
21     function name() external pure returns (string memory);
22 
23     function symbol() external pure returns (string memory);
24 
25     function decimals() external pure returns (uint8);
26 
27     function totalSupply() external view returns (uint);
28 
29     function balanceOf(address owner) external view returns (uint);
30 
31     function allowance(
32         address owner,
33         address spender
34     ) external view returns (uint);
35 
36     function approve(address spender, uint value) external returns (bool);
37 
38     function transfer(address to, uint value) external returns (bool);
39 
40     function transferFrom(
41         address from,
42         address to,
43         uint value
44     ) external returns (bool);
45 
46     function DOMAIN_SEPARATOR() external view returns (bytes32);
47 
48     function PERMIT_TYPEHASH() external pure returns (bytes32);
49 
50     function nonces(address owner) external view returns (uint);
51 
52     function permit(
53         address owner,
54         address spender,
55         uint value,
56         uint deadline,
57         uint8 v,
58         bytes32 r,
59         bytes32 s
60     ) external;
61 
62     event Mint(address indexed sender, uint amount0, uint amount1);
63     event Burn(
64         address indexed sender,
65         uint amount0,
66         uint amount1,
67         address indexed to
68     );
69     event Swap(
70         address indexed sender,
71         uint amount0In,
72         uint amount1In,
73         uint amount0Out,
74         uint amount1Out,
75         address indexed to
76     );
77     event Sync(uint112 reserve0, uint112 reserve1);
78 
79     function MINIMUM_LIQUIDITY() external pure returns (uint);
80 
81     function factory() external view returns (address);
82 
83     function token0() external view returns (address);
84 
85     function token1() external view returns (address);
86 
87     function getReserves()
88         external
89         view
90         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
91 
92     function price0CumulativeLast() external view returns (uint);
93 
94     function price1CumulativeLast() external view returns (uint);
95 
96     function kLast() external view returns (uint);
97 
98     function mint(address to) external returns (uint liquidity);
99 
100     function burn(address to) external returns (uint amount0, uint amount1);
101 
102     function swap(
103         uint amount0Out,
104         uint amount1Out,
105         address to,
106         bytes calldata data
107     ) external;
108 
109     function skim(address to) external;
110 
111     function sync() external;
112 
113     function initialize(address, address) external;
114 }
115 // File: ISwapFactory.sol
116 
117 pragma solidity ^0.8.4;
118 
119 interface ISwapFactory {
120     function createPair(
121         address tokenA,
122         address tokenB
123     ) external returns (address pair);
124 
125     function getPair(
126         address tokenA,
127         address tokenB
128     ) external returns (address pair);
129 }
130 // File: ISwapRouter.sol
131 
132 pragma solidity ^0.8.4;
133 
134 interface ISwapRouter {
135     function factoryV2() external pure returns (address);
136 
137     function factory() external pure returns (address);
138 
139     function WETH() external pure returns (address);
140 
141     function swapExactTokensForTokens(
142         uint amountIn,
143         uint amountOutMin,
144         address[] calldata path,
145         address to
146     ) external;
147 
148     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
149         uint amountIn,
150         uint amountOutMin,
151         address[] calldata path,
152         address to,
153         uint deadline
154     ) external;
155 
156     function swapExactTokensForETHSupportingFeeOnTransferTokens(
157         uint amountIn,
158         uint amountOutMin,
159         address[] calldata path,
160         address to,
161         uint deadline
162     ) external;
163 
164     function addLiquidity(
165         address tokenA,
166         address tokenB,
167         uint amountADesired,
168         uint amountBDesired,
169         uint amountAMin,
170         uint amountBMin,
171         address to,
172         uint deadline
173     ) external returns (uint amountA, uint amountB, uint liquidity);
174 
175     function addLiquidityETH(
176         address token,
177         uint amountTokenDesired,
178         uint amountTokenMin,
179         uint amountETHMin,
180         address to,
181         uint deadline
182     )
183         external
184         payable
185         returns (uint amountToken, uint amountETH, uint liquidity);
186 
187     function quote(
188         uint amountA,
189         uint reserveA,
190         uint reserveB
191     ) external pure returns (uint amountB);
192 
193     function getAmountOut(
194         uint amountIn,
195         uint reserveIn,
196         uint reserveOut
197     ) external pure returns (uint amountOut);
198 
199     function getAmountIn(
200         uint amountOut,
201         uint reserveIn,
202         uint reserveOut
203     ) external pure returns (uint amountIn);
204 
205     function getAmountsOut(
206         uint amountIn,
207         address[] calldata path
208     ) external view returns (uint[] memory amounts);
209 
210     function getAmountsIn(
211         uint amountOut,
212         address[] calldata path
213     ) external view returns (uint[] memory amounts);
214 }
215 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
216 
217 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
218 
219 pragma solidity ^0.8.0;
220 
221 /**
222  * @dev Interface of the ERC165 standard, as defined in the
223  * https://eips.ethereum.org/EIPS/eip-165[EIP].
224  *
225  * Implementers can declare support of contract interfaces, which can then be
226  * queried by others ({ERC165Checker}).
227  *
228  * For an implementation, see {ERC165}.
229  */
230 interface IERC165 {
231     /**
232      * @dev Returns true if this contract implements the interface defined by
233      * `interfaceId`. See the corresponding
234      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
235      * to learn more about how these ids are created.
236      *
237      * This function call must use less than 30 000 gas.
238      */
239     function supportsInterface(bytes4 interfaceId) external view returns (bool);
240 }
241 
242 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
243 
244 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
245 
246 pragma solidity ^0.8.0;
247 
248 /**
249  * @dev Implementation of the {IERC165} interface.
250  *
251  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
252  * for the additional interface id that will be supported. For example:
253  *
254  * ```solidity
255  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
256  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
257  * }
258  * ```
259  *
260  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
261  */
262 abstract contract ERC165 is IERC165 {
263     /**
264      * @dev See {IERC165-supportsInterface}.
265      */
266     function supportsInterface(
267         bytes4 interfaceId
268     ) public view virtual override returns (bool) {
269         return interfaceId == type(IERC165).interfaceId;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
274 
275 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @dev Standard signed math utilities missing in the Solidity language.
281  */
282 library SignedMath {
283     /**
284      * @dev Returns the largest of two signed numbers.
285      */
286     function max(int256 a, int256 b) internal pure returns (int256) {
287         return a > b ? a : b;
288     }
289 
290     /**
291      * @dev Returns the smallest of two signed numbers.
292      */
293     function min(int256 a, int256 b) internal pure returns (int256) {
294         return a < b ? a : b;
295     }
296 
297     /**
298      * @dev Returns the average of two signed numbers without overflow.
299      * The result is rounded towards zero.
300      */
301     function average(int256 a, int256 b) internal pure returns (int256) {
302         // Formula from the book "Hacker's Delight"
303         int256 x = (a & b) + ((a ^ b) >> 1);
304         return x + (int256(uint256(x) >> 255) & (a ^ b));
305     }
306 
307     /**
308      * @dev Returns the absolute unsigned value of a signed value.
309      */
310     function abs(int256 n) internal pure returns (uint256) {
311         unchecked {
312             // must be unchecked in order to support `n = type(int256).min`
313             return uint256(n >= 0 ? n : -n);
314         }
315     }
316 }
317 
318 // File: @openzeppelin/contracts/utils/math/Math.sol
319 
320 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
321 
322 pragma solidity ^0.8.0;
323 
324 /**
325  * @dev Standard math utilities missing in the Solidity language.
326  */
327 library Math {
328     enum Rounding {
329         Down, // Toward negative infinity
330         Up, // Toward infinity
331         Zero // Toward zero
332     }
333 
334     /**
335      * @dev Returns the largest of two numbers.
336      */
337     function max(uint256 a, uint256 b) internal pure returns (uint256) {
338         return a > b ? a : b;
339     }
340 
341     /**
342      * @dev Returns the smallest of two numbers.
343      */
344     function min(uint256 a, uint256 b) internal pure returns (uint256) {
345         return a < b ? a : b;
346     }
347 
348     /**
349      * @dev Returns the average of two numbers. The result is rounded towards
350      * zero.
351      */
352     function average(uint256 a, uint256 b) internal pure returns (uint256) {
353         // (a + b) / 2 can overflow.
354         return (a & b) + (a ^ b) / 2;
355     }
356 
357     /**
358      * @dev Returns the ceiling of the division of two numbers.
359      *
360      * This differs from standard division with `/` in that it rounds up instead
361      * of rounding down.
362      */
363     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
364         // (a + b - 1) / b can overflow on addition, so we distribute.
365         return a == 0 ? 0 : (a - 1) / b + 1;
366     }
367 
368     /**
369      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
370      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
371      * with further edits by Uniswap Labs also under MIT license.
372      */
373     function mulDiv(
374         uint256 x,
375         uint256 y,
376         uint256 denominator
377     ) internal pure returns (uint256 result) {
378         unchecked {
379             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
380             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
381             // variables such that product = prod1 * 2^256 + prod0.
382             uint256 prod0; // Least significant 256 bits of the product
383             uint256 prod1; // Most significant 256 bits of the product
384             assembly {
385                 let mm := mulmod(x, y, not(0))
386                 prod0 := mul(x, y)
387                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
388             }
389 
390             // Handle non-overflow cases, 256 by 256 division.
391             if (prod1 == 0) {
392                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
393                 // The surrounding unchecked block does not change this fact.
394                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
395                 return prod0 / denominator;
396             }
397 
398             // Make sure the result is less than 2^256. Also prevents denominator == 0.
399             require(denominator > prod1, "Math: mulDiv overflow");
400 
401             ///////////////////////////////////////////////
402             // 512 by 256 division.
403             ///////////////////////////////////////////////
404 
405             // Make division exact by subtracting the remainder from [prod1 prod0].
406             uint256 remainder;
407             assembly {
408                 // Compute remainder using mulmod.
409                 remainder := mulmod(x, y, denominator)
410 
411                 // Subtract 256 bit number from 512 bit number.
412                 prod1 := sub(prod1, gt(remainder, prod0))
413                 prod0 := sub(prod0, remainder)
414             }
415 
416             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
417             // See https://cs.stackexchange.com/q/138556/92363.
418 
419             // Does not overflow because the denominator cannot be zero at this stage in the function.
420             uint256 twos = denominator & (~denominator + 1);
421             assembly {
422                 // Divide denominator by twos.
423                 denominator := div(denominator, twos)
424 
425                 // Divide [prod1 prod0] by twos.
426                 prod0 := div(prod0, twos)
427 
428                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
429                 twos := add(div(sub(0, twos), twos), 1)
430             }
431 
432             // Shift in bits from prod1 into prod0.
433             prod0 |= prod1 * twos;
434 
435             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
436             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
437             // four bits. That is, denominator * inv = 1 mod 2^4.
438             uint256 inverse = (3 * denominator) ^ 2;
439 
440             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
441             // in modular arithmetic, doubling the correct bits in each step.
442             inverse *= 2 - denominator * inverse; // inverse mod 2^8
443             inverse *= 2 - denominator * inverse; // inverse mod 2^16
444             inverse *= 2 - denominator * inverse; // inverse mod 2^32
445             inverse *= 2 - denominator * inverse; // inverse mod 2^64
446             inverse *= 2 - denominator * inverse; // inverse mod 2^128
447             inverse *= 2 - denominator * inverse; // inverse mod 2^256
448 
449             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
450             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
451             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
452             // is no longer required.
453             result = prod0 * inverse;
454             return result;
455         }
456     }
457 
458     /**
459      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
460      */
461     function mulDiv(
462         uint256 x,
463         uint256 y,
464         uint256 denominator,
465         Rounding rounding
466     ) internal pure returns (uint256) {
467         uint256 result = mulDiv(x, y, denominator);
468         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
469             result += 1;
470         }
471         return result;
472     }
473 
474     /**
475      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
476      *
477      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
478      */
479     function sqrt(uint256 a) internal pure returns (uint256) {
480         if (a == 0) {
481             return 0;
482         }
483 
484         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
485         //
486         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
487         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
488         //
489         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
490         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
491         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
492         //
493         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
494         uint256 result = 1 << (log2(a) >> 1);
495 
496         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
497         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
498         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
499         // into the expected uint128 result.
500         unchecked {
501             result = (result + a / result) >> 1;
502             result = (result + a / result) >> 1;
503             result = (result + a / result) >> 1;
504             result = (result + a / result) >> 1;
505             result = (result + a / result) >> 1;
506             result = (result + a / result) >> 1;
507             result = (result + a / result) >> 1;
508             return min(result, a / result);
509         }
510     }
511 
512     /**
513      * @notice Calculates sqrt(a), following the selected rounding direction.
514      */
515     function sqrt(
516         uint256 a,
517         Rounding rounding
518     ) internal pure returns (uint256) {
519         unchecked {
520             uint256 result = sqrt(a);
521             return
522                 result +
523                 (rounding == Rounding.Up && result * result < a ? 1 : 0);
524         }
525     }
526 
527     /**
528      * @dev Return the log in base 2, rounded down, of a positive value.
529      * Returns 0 if given 0.
530      */
531     function log2(uint256 value) internal pure returns (uint256) {
532         uint256 result = 0;
533         unchecked {
534             if (value >> 128 > 0) {
535                 value >>= 128;
536                 result += 128;
537             }
538             if (value >> 64 > 0) {
539                 value >>= 64;
540                 result += 64;
541             }
542             if (value >> 32 > 0) {
543                 value >>= 32;
544                 result += 32;
545             }
546             if (value >> 16 > 0) {
547                 value >>= 16;
548                 result += 16;
549             }
550             if (value >> 8 > 0) {
551                 value >>= 8;
552                 result += 8;
553             }
554             if (value >> 4 > 0) {
555                 value >>= 4;
556                 result += 4;
557             }
558             if (value >> 2 > 0) {
559                 value >>= 2;
560                 result += 2;
561             }
562             if (value >> 1 > 0) {
563                 result += 1;
564             }
565         }
566         return result;
567     }
568 
569     /**
570      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
571      * Returns 0 if given 0.
572      */
573     function log2(
574         uint256 value,
575         Rounding rounding
576     ) internal pure returns (uint256) {
577         unchecked {
578             uint256 result = log2(value);
579             return
580                 result +
581                 (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
582         }
583     }
584 
585     /**
586      * @dev Return the log in base 10, rounded down, of a positive value.
587      * Returns 0 if given 0.
588      */
589     function log10(uint256 value) internal pure returns (uint256) {
590         uint256 result = 0;
591         unchecked {
592             if (value >= 10 ** 64) {
593                 value /= 10 ** 64;
594                 result += 64;
595             }
596             if (value >= 10 ** 32) {
597                 value /= 10 ** 32;
598                 result += 32;
599             }
600             if (value >= 10 ** 16) {
601                 value /= 10 ** 16;
602                 result += 16;
603             }
604             if (value >= 10 ** 8) {
605                 value /= 10 ** 8;
606                 result += 8;
607             }
608             if (value >= 10 ** 4) {
609                 value /= 10 ** 4;
610                 result += 4;
611             }
612             if (value >= 10 ** 2) {
613                 value /= 10 ** 2;
614                 result += 2;
615             }
616             if (value >= 10 ** 1) {
617                 result += 1;
618             }
619         }
620         return result;
621     }
622 
623     /**
624      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
625      * Returns 0 if given 0.
626      */
627     function log10(
628         uint256 value,
629         Rounding rounding
630     ) internal pure returns (uint256) {
631         unchecked {
632             uint256 result = log10(value);
633             return
634                 result +
635                 (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
636         }
637     }
638 
639     /**
640      * @dev Return the log in base 256, rounded down, of a positive value.
641      * Returns 0 if given 0.
642      *
643      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
644      */
645     function log256(uint256 value) internal pure returns (uint256) {
646         uint256 result = 0;
647         unchecked {
648             if (value >> 128 > 0) {
649                 value >>= 128;
650                 result += 16;
651             }
652             if (value >> 64 > 0) {
653                 value >>= 64;
654                 result += 8;
655             }
656             if (value >> 32 > 0) {
657                 value >>= 32;
658                 result += 4;
659             }
660             if (value >> 16 > 0) {
661                 value >>= 16;
662                 result += 2;
663             }
664             if (value >> 8 > 0) {
665                 result += 1;
666             }
667         }
668         return result;
669     }
670 
671     /**
672      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
673      * Returns 0 if given 0.
674      */
675     function log256(
676         uint256 value,
677         Rounding rounding
678     ) internal pure returns (uint256) {
679         unchecked {
680             uint256 result = log256(value);
681             return
682                 result +
683                 (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
684         }
685     }
686 }
687 
688 // File: @openzeppelin/contracts/utils/Strings.sol
689 
690 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
691 
692 pragma solidity ^0.8.0;
693 
694 /**
695  * @dev String operations.
696  */
697 library Strings {
698     bytes16 private constant _SYMBOLS = "0123456789abcdef";
699     uint8 private constant _ADDRESS_LENGTH = 20;
700 
701     /**
702      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
703      */
704     function toString(uint256 value) internal pure returns (string memory) {
705         unchecked {
706             uint256 length = Math.log10(value) + 1;
707             string memory buffer = new string(length);
708             uint256 ptr;
709             /// @solidity memory-safe-assembly
710             assembly {
711                 ptr := add(buffer, add(32, length))
712             }
713             while (true) {
714                 ptr--;
715                 /// @solidity memory-safe-assembly
716                 assembly {
717                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
718                 }
719                 value /= 10;
720                 if (value == 0) break;
721             }
722             return buffer;
723         }
724     }
725 
726     /**
727      * @dev Converts a `int256` to its ASCII `string` decimal representation.
728      */
729     function toString(int256 value) internal pure returns (string memory) {
730         return
731             string(
732                 abi.encodePacked(
733                     value < 0 ? "-" : "",
734                     toString(SignedMath.abs(value))
735                 )
736             );
737     }
738 
739     /**
740      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
741      */
742     function toHexString(uint256 value) internal pure returns (string memory) {
743         unchecked {
744             return toHexString(value, Math.log256(value) + 1);
745         }
746     }
747 
748     /**
749      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
750      */
751     function toHexString(
752         uint256 value,
753         uint256 length
754     ) internal pure returns (string memory) {
755         bytes memory buffer = new bytes(2 * length + 2);
756         buffer[0] = "0";
757         buffer[1] = "x";
758         for (uint256 i = 2 * length + 1; i > 1; --i) {
759             buffer[i] = _SYMBOLS[value & 0xf];
760             value >>= 4;
761         }
762         require(value == 0, "Strings: hex length insufficient");
763         return string(buffer);
764     }
765 
766     /**
767      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
768      */
769     function toHexString(address addr) internal pure returns (string memory) {
770         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
771     }
772 
773     /**
774      * @dev Returns true if the two strings are equal.
775      */
776     function equal(
777         string memory a,
778         string memory b
779     ) internal pure returns (bool) {
780         return keccak256(bytes(a)) == keccak256(bytes(b));
781     }
782 }
783 
784 // File: @openzeppelin/contracts/access/IAccessControl.sol
785 
786 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
787 
788 pragma solidity ^0.8.0;
789 
790 /**
791  * @dev External interface of AccessControl declared to support ERC165 detection.
792  */
793 interface IAccessControl {
794     /**
795      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
796      *
797      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
798      * {RoleAdminChanged} not being emitted signaling this.
799      *
800      * _Available since v3.1._
801      */
802     event RoleAdminChanged(
803         bytes32 indexed role,
804         bytes32 indexed previousAdminRole,
805         bytes32 indexed newAdminRole
806     );
807 
808     /**
809      * @dev Emitted when `account` is granted `role`.
810      *
811      * `sender` is the account that originated the contract call, an admin role
812      * bearer except when using {AccessControl-_setupRole}.
813      */
814     event RoleGranted(
815         bytes32 indexed role,
816         address indexed account,
817         address indexed sender
818     );
819 
820     /**
821      * @dev Emitted when `account` is revoked `role`.
822      *
823      * `sender` is the account that originated the contract call:
824      *   - if using `revokeRole`, it is the admin role bearer
825      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
826      */
827     event RoleRevoked(
828         bytes32 indexed role,
829         address indexed account,
830         address indexed sender
831     );
832 
833     /**
834      * @dev Returns `true` if `account` has been granted `role`.
835      */
836     function hasRole(
837         bytes32 role,
838         address account
839     ) external view returns (bool);
840 
841     /**
842      * @dev Returns the admin role that controls `role`. See {grantRole} and
843      * {revokeRole}.
844      *
845      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
846      */
847     function getRoleAdmin(bytes32 role) external view returns (bytes32);
848 
849     /**
850      * @dev Grants `role` to `account`.
851      *
852      * If `account` had not been already granted `role`, emits a {RoleGranted}
853      * event.
854      *
855      * Requirements:
856      *
857      * - the caller must have ``role``'s admin role.
858      */
859     function grantRole(bytes32 role, address account) external;
860 
861     /**
862      * @dev Revokes `role` from `account`.
863      *
864      * If `account` had been granted `role`, emits a {RoleRevoked} event.
865      *
866      * Requirements:
867      *
868      * - the caller must have ``role``'s admin role.
869      */
870     function revokeRole(bytes32 role, address account) external;
871 
872     /**
873      * @dev Revokes `role` from the calling account.
874      *
875      * Roles are often managed via {grantRole} and {revokeRole}: this function's
876      * purpose is to provide a mechanism for accounts to lose their privileges
877      * if they are compromised (such as when a trusted device is misplaced).
878      *
879      * If the calling account had been granted `role`, emits a {RoleRevoked}
880      * event.
881      *
882      * Requirements:
883      *
884      * - the caller must be `account`.
885      */
886     function renounceRole(bytes32 role, address account) external;
887 }
888 
889 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
890 
891 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
892 
893 pragma solidity ^0.8.0;
894 
895 // CAUTION
896 // This version of SafeMath should only be used with Solidity 0.8 or later,
897 // because it relies on the compiler's built in overflow checks.
898 
899 /**
900  * @dev Wrappers over Solidity's arithmetic operations.
901  *
902  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
903  * now has built in overflow checking.
904  */
905 library SafeMath {
906     /**
907      * @dev Returns the addition of two unsigned integers, with an overflow flag.
908      *
909      * _Available since v3.4._
910      */
911     function tryAdd(
912         uint256 a,
913         uint256 b
914     ) internal pure returns (bool, uint256) {
915         unchecked {
916             uint256 c = a + b;
917             if (c < a) return (false, 0);
918             return (true, c);
919         }
920     }
921 
922     /**
923      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
924      *
925      * _Available since v3.4._
926      */
927     function trySub(
928         uint256 a,
929         uint256 b
930     ) internal pure returns (bool, uint256) {
931         unchecked {
932             if (b > a) return (false, 0);
933             return (true, a - b);
934         }
935     }
936 
937     /**
938      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
939      *
940      * _Available since v3.4._
941      */
942     function tryMul(
943         uint256 a,
944         uint256 b
945     ) internal pure returns (bool, uint256) {
946         unchecked {
947             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
948             // benefit is lost if 'b' is also tested.
949             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
950             if (a == 0) return (true, 0);
951             uint256 c = a * b;
952             if (c / a != b) return (false, 0);
953             return (true, c);
954         }
955     }
956 
957     /**
958      * @dev Returns the division of two unsigned integers, with a division by zero flag.
959      *
960      * _Available since v3.4._
961      */
962     function tryDiv(
963         uint256 a,
964         uint256 b
965     ) internal pure returns (bool, uint256) {
966         unchecked {
967             if (b == 0) return (false, 0);
968             return (true, a / b);
969         }
970     }
971 
972     /**
973      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
974      *
975      * _Available since v3.4._
976      */
977     function tryMod(
978         uint256 a,
979         uint256 b
980     ) internal pure returns (bool, uint256) {
981         unchecked {
982             if (b == 0) return (false, 0);
983             return (true, a % b);
984         }
985     }
986 
987     /**
988      * @dev Returns the addition of two unsigned integers, reverting on
989      * overflow.
990      *
991      * Counterpart to Solidity's `+` operator.
992      *
993      * Requirements:
994      *
995      * - Addition cannot overflow.
996      */
997     function add(uint256 a, uint256 b) internal pure returns (uint256) {
998         return a + b;
999     }
1000 
1001     /**
1002      * @dev Returns the subtraction of two unsigned integers, reverting on
1003      * overflow (when the result is negative).
1004      *
1005      * Counterpart to Solidity's `-` operator.
1006      *
1007      * Requirements:
1008      *
1009      * - Subtraction cannot overflow.
1010      */
1011     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1012         return a - b;
1013     }
1014 
1015     /**
1016      * @dev Returns the multiplication of two unsigned integers, reverting on
1017      * overflow.
1018      *
1019      * Counterpart to Solidity's `*` operator.
1020      *
1021      * Requirements:
1022      *
1023      * - Multiplication cannot overflow.
1024      */
1025     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1026         return a * b;
1027     }
1028 
1029     /**
1030      * @dev Returns the integer division of two unsigned integers, reverting on
1031      * division by zero. The result is rounded towards zero.
1032      *
1033      * Counterpart to Solidity's `/` operator.
1034      *
1035      * Requirements:
1036      *
1037      * - The divisor cannot be zero.
1038      */
1039     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1040         return a / b;
1041     }
1042 
1043     /**
1044      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1045      * reverting when dividing by zero.
1046      *
1047      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1048      * opcode (which leaves remaining gas untouched) while Solidity uses an
1049      * invalid opcode to revert (consuming all remaining gas).
1050      *
1051      * Requirements:
1052      *
1053      * - The divisor cannot be zero.
1054      */
1055     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1056         return a % b;
1057     }
1058 
1059     /**
1060      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1061      * overflow (when the result is negative).
1062      *
1063      * CAUTION: This function is deprecated because it requires allocating memory for the error
1064      * message unnecessarily. For custom revert reasons use {trySub}.
1065      *
1066      * Counterpart to Solidity's `-` operator.
1067      *
1068      * Requirements:
1069      *
1070      * - Subtraction cannot overflow.
1071      */
1072     function sub(
1073         uint256 a,
1074         uint256 b,
1075         string memory errorMessage
1076     ) internal pure returns (uint256) {
1077         unchecked {
1078             require(b <= a, errorMessage);
1079             return a - b;
1080         }
1081     }
1082 
1083     /**
1084      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1085      * division by zero. The result is rounded towards zero.
1086      *
1087      * Counterpart to Solidity's `/` operator. Note: this function uses a
1088      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1089      * uses an invalid opcode to revert (consuming all remaining gas).
1090      *
1091      * Requirements:
1092      *
1093      * - The divisor cannot be zero.
1094      */
1095     function div(
1096         uint256 a,
1097         uint256 b,
1098         string memory errorMessage
1099     ) internal pure returns (uint256) {
1100         unchecked {
1101             require(b > 0, errorMessage);
1102             return a / b;
1103         }
1104     }
1105 
1106     /**
1107      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1108      * reverting with custom message when dividing by zero.
1109      *
1110      * CAUTION: This function is deprecated because it requires allocating memory for the error
1111      * message unnecessarily. For custom revert reasons use {tryMod}.
1112      *
1113      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1114      * opcode (which leaves remaining gas untouched) while Solidity uses an
1115      * invalid opcode to revert (consuming all remaining gas).
1116      *
1117      * Requirements:
1118      *
1119      * - The divisor cannot be zero.
1120      */
1121     function mod(
1122         uint256 a,
1123         uint256 b,
1124         string memory errorMessage
1125     ) internal pure returns (uint256) {
1126         unchecked {
1127             require(b > 0, errorMessage);
1128             return a % b;
1129         }
1130     }
1131 }
1132 
1133 // File: @openzeppelin/contracts/utils/Context.sol
1134 
1135 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 /**
1140  * @dev Provides information about the current execution context, including the
1141  * sender of the transaction and its data. While these are generally available
1142  * via msg.sender and msg.data, they should not be accessed in such a direct
1143  * manner, since when dealing with meta-transactions the account sending and
1144  * paying for execution may not be the actual sender (as far as an application
1145  * is concerned).
1146  *
1147  * This contract is only required for intermediate, library-like contracts.
1148  */
1149 abstract contract Context {
1150     function _msgSender() internal view virtual returns (address) {
1151         return msg.sender;
1152     }
1153 
1154     function _msgData() internal view virtual returns (bytes calldata) {
1155         return msg.data;
1156     }
1157 }
1158 
1159 // File: @openzeppelin/contracts/access/AccessControl.sol
1160 
1161 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1162 
1163 pragma solidity ^0.8.0;
1164 
1165 /**
1166  * @dev Contract module that allows children to implement role-based access
1167  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1168  * members except through off-chain means by accessing the contract event logs. Some
1169  * applications may benefit from on-chain enumerability, for those cases see
1170  * {AccessControlEnumerable}.
1171  *
1172  * Roles are referred to by their `bytes32` identifier. These should be exposed
1173  * in the external API and be unique. The best way to achieve this is by
1174  * using `public constant` hash digests:
1175  *
1176  * ```solidity
1177  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1178  * ```
1179  *
1180  * Roles can be used to represent a set of permissions. To restrict access to a
1181  * function call, use {hasRole}:
1182  *
1183  * ```solidity
1184  * function foo() public {
1185  *     require(hasRole(MY_ROLE, msg.sender));
1186  *     ...
1187  * }
1188  * ```
1189  *
1190  * Roles can be granted and revoked dynamically via the {grantRole} and
1191  * {revokeRole} functions. Each role has an associated admin role, and only
1192  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1193  *
1194  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1195  * that only accounts with this role will be able to grant or revoke other
1196  * roles. More complex role relationships can be created by using
1197  * {_setRoleAdmin}.
1198  *
1199  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1200  * grant and revoke this role. Extra precautions should be taken to secure
1201  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1202  * to enforce additional security measures for this role.
1203  */
1204 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1205     struct RoleData {
1206         mapping(address => bool) members;
1207         bytes32 adminRole;
1208     }
1209 
1210     mapping(bytes32 => RoleData) private _roles;
1211 
1212     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1213 
1214     /**
1215      * @dev Modifier that checks that an account has a specific role. Reverts
1216      * with a standardized message including the required role.
1217      *
1218      * The format of the revert reason is given by the following regular expression:
1219      *
1220      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1221      *
1222      * _Available since v4.1._
1223      */
1224     modifier onlyRole(bytes32 role) {
1225         _checkRole(role);
1226         _;
1227     }
1228 
1229     /**
1230      * @dev See {IERC165-supportsInterface}.
1231      */
1232     function supportsInterface(
1233         bytes4 interfaceId
1234     ) public view virtual override returns (bool) {
1235         return
1236             interfaceId == type(IAccessControl).interfaceId ||
1237             super.supportsInterface(interfaceId);
1238     }
1239 
1240     /**
1241      * @dev Returns `true` if `account` has been granted `role`.
1242      */
1243     function hasRole(
1244         bytes32 role,
1245         address account
1246     ) public view virtual override returns (bool) {
1247         return _roles[role].members[account];
1248     }
1249 
1250     /**
1251      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1252      * Overriding this function changes the behavior of the {onlyRole} modifier.
1253      *
1254      * Format of the revert message is described in {_checkRole}.
1255      *
1256      * _Available since v4.6._
1257      */
1258     function _checkRole(bytes32 role) internal view virtual {
1259         _checkRole(role, _msgSender());
1260     }
1261 
1262     /**
1263      * @dev Revert with a standard message if `account` is missing `role`.
1264      *
1265      * The format of the revert reason is given by the following regular expression:
1266      *
1267      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1268      */
1269     function _checkRole(bytes32 role, address account) internal view virtual {
1270         if (!hasRole(role, account)) {
1271             revert(
1272                 string(
1273                     abi.encodePacked(
1274                         "AccessControl: account ",
1275                         Strings.toHexString(account),
1276                         " is missing role ",
1277                         Strings.toHexString(uint256(role), 32)
1278                     )
1279                 )
1280             );
1281         }
1282     }
1283 
1284     /**
1285      * @dev Returns the admin role that controls `role`. See {grantRole} and
1286      * {revokeRole}.
1287      *
1288      * To change a role's admin, use {_setRoleAdmin}.
1289      */
1290     function getRoleAdmin(
1291         bytes32 role
1292     ) public view virtual override returns (bytes32) {
1293         return _roles[role].adminRole;
1294     }
1295 
1296     /**
1297      * @dev Grants `role` to `account`.
1298      *
1299      * If `account` had not been already granted `role`, emits a {RoleGranted}
1300      * event.
1301      *
1302      * Requirements:
1303      *
1304      * - the caller must have ``role``'s admin role.
1305      *
1306      * May emit a {RoleGranted} event.
1307      */
1308     function grantRole(
1309         bytes32 role,
1310         address account
1311     ) public virtual override onlyRole(getRoleAdmin(role)) {
1312         _grantRole(role, account);
1313     }
1314 
1315     /**
1316      * @dev Revokes `role` from `account`.
1317      *
1318      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1319      *
1320      * Requirements:
1321      *
1322      * - the caller must have ``role``'s admin role.
1323      *
1324      * May emit a {RoleRevoked} event.
1325      */
1326     function revokeRole(
1327         bytes32 role,
1328         address account
1329     ) public virtual override onlyRole(getRoleAdmin(role)) {
1330         _revokeRole(role, account);
1331     }
1332 
1333     /**
1334      * @dev Revokes `role` from the calling account.
1335      *
1336      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1337      * purpose is to provide a mechanism for accounts to lose their privileges
1338      * if they are compromised (such as when a trusted device is misplaced).
1339      *
1340      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1341      * event.
1342      *
1343      * Requirements:
1344      *
1345      * - the caller must be `account`.
1346      *
1347      * May emit a {RoleRevoked} event.
1348      */
1349     function renounceRole(
1350         bytes32 role,
1351         address account
1352     ) public virtual override {
1353         require(
1354             account == _msgSender(),
1355             "AccessControl: can only renounce roles for self"
1356         );
1357 
1358         _revokeRole(role, account);
1359     }
1360 
1361     /**
1362      * @dev Grants `role` to `account`.
1363      *
1364      * If `account` had not been already granted `role`, emits a {RoleGranted}
1365      * event. Note that unlike {grantRole}, this function doesn't perform any
1366      * checks on the calling account.
1367      *
1368      * May emit a {RoleGranted} event.
1369      *
1370      * [WARNING]
1371      * ====
1372      * This function should only be called from the constructor when setting
1373      * up the initial roles for the system.
1374      *
1375      * Using this function in any other way is effectively circumventing the admin
1376      * system imposed by {AccessControl}.
1377      * ====
1378      *
1379      * NOTE: This function is deprecated in favor of {_grantRole}.
1380      */
1381     function _setupRole(bytes32 role, address account) internal virtual {
1382         _grantRole(role, account);
1383     }
1384 
1385     /**
1386      * @dev Sets `adminRole` as ``role``'s admin role.
1387      *
1388      * Emits a {RoleAdminChanged} event.
1389      */
1390     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1391         bytes32 previousAdminRole = getRoleAdmin(role);
1392         _roles[role].adminRole = adminRole;
1393         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1394     }
1395 
1396     /**
1397      * @dev Grants `role` to `account`.
1398      *
1399      * Internal function without access restriction.
1400      *
1401      * May emit a {RoleGranted} event.
1402      */
1403     function _grantRole(bytes32 role, address account) internal virtual {
1404         if (!hasRole(role, account)) {
1405             _roles[role].members[account] = true;
1406             emit RoleGranted(role, account, _msgSender());
1407         }
1408     }
1409 
1410     /**
1411      * @dev Revokes `role` from `account`.
1412      *
1413      * Internal function without access restriction.
1414      *
1415      * May emit a {RoleRevoked} event.
1416      */
1417     function _revokeRole(bytes32 role, address account) internal virtual {
1418         if (hasRole(role, account)) {
1419             _roles[role].members[account] = false;
1420             emit RoleRevoked(role, account, _msgSender());
1421         }
1422     }
1423 }
1424 
1425 // File: @openzeppelin/contracts/access/Ownable.sol
1426 
1427 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1428 
1429 pragma solidity ^0.8.0;
1430 
1431 /**
1432  * @dev Contract module which provides a basic access control mechanism, where
1433  * there is an account (an owner) that can be granted exclusive access to
1434  * specific functions.
1435  *
1436  * By default, the owner account will be the one that deploys the contract. This
1437  * can later be changed with {transferOwnership}.
1438  *
1439  * This module is used through inheritance. It will make available the modifier
1440  * `onlyOwner`, which can be applied to your functions to restrict their use to
1441  * the owner.
1442  */
1443 abstract contract Ownable is Context {
1444     address private _owner;
1445 
1446     event OwnershipTransferred(
1447         address indexed previousOwner,
1448         address indexed newOwner
1449     );
1450 
1451     /**
1452      * @dev Initializes the contract setting the deployer as the initial owner.
1453      */
1454     constructor() {
1455         _transferOwnership(_msgSender());
1456     }
1457 
1458     /**
1459      * @dev Throws if called by any account other than the owner.
1460      */
1461     modifier onlyOwner() {
1462         _checkOwner();
1463         _;
1464     }
1465 
1466     /**
1467      * @dev Returns the address of the current owner.
1468      */
1469     function owner() public view virtual returns (address) {
1470         return _owner;
1471     }
1472 
1473     /**
1474      * @dev Throws if the sender is not the owner.
1475      */
1476     function _checkOwner() internal view virtual {
1477         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1478     }
1479 
1480     /**
1481      * @dev Leaves the contract without owner. It will not be possible to call
1482      * `onlyOwner` functions. Can only be called by the current owner.
1483      *
1484      * NOTE: Renouncing ownership will leave the contract without an owner,
1485      * thereby disabling any functionality that is only available to the owner.
1486      */
1487     function renounceOwnership() public virtual onlyOwner {
1488         _transferOwnership(address(0));
1489     }
1490 
1491     /**
1492      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1493      * Can only be called by the current owner.
1494      */
1495     function transferOwnership(address newOwner) public virtual onlyOwner {
1496         require(
1497             newOwner != address(0),
1498             "Ownable: new owner is the zero address"
1499         );
1500         _transferOwnership(newOwner);
1501     }
1502 
1503     /**
1504      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1505      * Internal function without access restriction.
1506      */
1507     function _transferOwnership(address newOwner) internal virtual {
1508         address oldOwner = _owner;
1509         _owner = newOwner;
1510         emit OwnershipTransferred(oldOwner, newOwner);
1511     }
1512 }
1513 
1514 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1515 
1516 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1517 
1518 pragma solidity ^0.8.0;
1519 
1520 /**
1521  * @dev Interface of the ERC20 standard as defined in the EIP.
1522  */
1523 interface IERC20 {
1524     /**
1525      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1526      * another (`to`).
1527      *
1528      * Note that `value` may be zero.
1529      */
1530     event Transfer(address indexed from, address indexed to, uint256 value);
1531 
1532     /**
1533      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1534      * a call to {approve}. `value` is the new allowance.
1535      */
1536     event Approval(
1537         address indexed owner,
1538         address indexed spender,
1539         uint256 value
1540     );
1541 
1542     /**
1543      * @dev Returns the amount of tokens in existence.
1544      */
1545     function totalSupply() external view returns (uint256);
1546 
1547     /**
1548      * @dev Returns the amount of tokens owned by `account`.
1549      */
1550     function balanceOf(address account) external view returns (uint256);
1551 
1552     /**
1553      * @dev Moves `amount` tokens from the caller's account to `to`.
1554      *
1555      * Returns a boolean value indicating whether the operation succeeded.
1556      *
1557      * Emits a {Transfer} event.
1558      */
1559     function transfer(address to, uint256 amount) external returns (bool);
1560 
1561     /**
1562      * @dev Returns the remaining number of tokens that `spender` will be
1563      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1564      * zero by default.
1565      *
1566      * This value changes when {approve} or {transferFrom} are called.
1567      */
1568     function allowance(
1569         address owner,
1570         address spender
1571     ) external view returns (uint256);
1572 
1573     /**
1574      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1575      *
1576      * Returns a boolean value indicating whether the operation succeeded.
1577      *
1578      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1579      * that someone may use both the old and the new allowance by unfortunate
1580      * transaction ordering. One possible solution to mitigate this race
1581      * condition is to first reduce the spender's allowance to 0 and set the
1582      * desired value afterwards:
1583      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1584      *
1585      * Emits an {Approval} event.
1586      */
1587     function approve(address spender, uint256 amount) external returns (bool);
1588 
1589     /**
1590      * @dev Moves `amount` tokens from `from` to `to` using the
1591      * allowance mechanism. `amount` is then deducted from the caller's
1592      * allowance.
1593      *
1594      * Returns a boolean value indicating whether the operation succeeded.
1595      *
1596      * Emits a {Transfer} event.
1597      */
1598     function transferFrom(
1599         address from,
1600         address to,
1601         uint256 amount
1602     ) external returns (bool);
1603 }
1604 
1605 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1606 
1607 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1608 
1609 pragma solidity ^0.8.0;
1610 
1611 /**
1612  * @dev Interface for the optional metadata functions from the ERC20 standard.
1613  *
1614  * _Available since v4.1._
1615  */
1616 interface IERC20Metadata is IERC20 {
1617     /**
1618      * @dev Returns the name of the token.
1619      */
1620     function name() external view returns (string memory);
1621 
1622     /**
1623      * @dev Returns the symbol of the token.
1624      */
1625     function symbol() external view returns (string memory);
1626 
1627     /**
1628      * @dev Returns the decimals places of the token.
1629      */
1630     function decimals() external view returns (uint8);
1631 }
1632 
1633 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1634 
1635 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1636 
1637 pragma solidity ^0.8.0;
1638 
1639 /**
1640  * @dev Implementation of the {IERC20} interface.
1641  *
1642  * This implementation is agnostic to the way tokens are created. This means
1643  * that a supply mechanism has to be added in a derived contract using {_mint}.
1644  * For a generic mechanism see {ERC20PresetMinterPauser}.
1645  *
1646  * TIP: For a detailed writeup see our guide
1647  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1648  * to implement supply mechanisms].
1649  *
1650  * The default value of {decimals} is 18. To change this, you should override
1651  * this function so it returns a different value.
1652  *
1653  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1654  * instead returning `false` on failure. This behavior is nonetheless
1655  * conventional and does not conflict with the expectations of ERC20
1656  * applications.
1657  *
1658  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1659  * This allows applications to reconstruct the allowance for all accounts just
1660  * by listening to said events. Other implementations of the EIP may not emit
1661  * these events, as it isn't required by the specification.
1662  *
1663  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1664  * functions have been added to mitigate the well-known issues around setting
1665  * allowances. See {IERC20-approve}.
1666  */
1667 contract ERC20 is Context, IERC20, IERC20Metadata {
1668     mapping(address => uint256) private _balances;
1669 
1670     mapping(address => mapping(address => uint256)) private _allowances;
1671 
1672     uint256 private _totalSupply;
1673 
1674     string private _name;
1675     string private _symbol;
1676 
1677     /**
1678      * @dev Sets the values for {name} and {symbol}.
1679      *
1680      * All two of these values are immutable: they can only be set once during
1681      * construction.
1682      */
1683     constructor(string memory name_, string memory symbol_) {
1684         _name = name_;
1685         _symbol = symbol_;
1686     }
1687 
1688     /**
1689      * @dev Returns the name of the token.
1690      */
1691     function name() public view virtual override returns (string memory) {
1692         return _name;
1693     }
1694 
1695     /**
1696      * @dev Returns the symbol of the token, usually a shorter version of the
1697      * name.
1698      */
1699     function symbol() public view virtual override returns (string memory) {
1700         return _symbol;
1701     }
1702 
1703     /**
1704      * @dev Returns the number of decimals used to get its user representation.
1705      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1706      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1707      *
1708      * Tokens usually opt for a value of 18, imitating the relationship between
1709      * Ether and Wei. This is the default value returned by this function, unless
1710      * it's overridden.
1711      *
1712      * NOTE: This information is only used for _display_ purposes: it in
1713      * no way affects any of the arithmetic of the contract, including
1714      * {IERC20-balanceOf} and {IERC20-transfer}.
1715      */
1716     function decimals() public view virtual override returns (uint8) {
1717         return 18;
1718     }
1719 
1720     /**
1721      * @dev See {IERC20-totalSupply}.
1722      */
1723     function totalSupply() public view virtual override returns (uint256) {
1724         return _totalSupply;
1725     }
1726 
1727     /**
1728      * @dev See {IERC20-balanceOf}.
1729      */
1730     function balanceOf(
1731         address account
1732     ) public view virtual override returns (uint256) {
1733         return _balances[account];
1734     }
1735 
1736     /**
1737      * @dev See {IERC20-transfer}.
1738      *
1739      * Requirements:
1740      *
1741      * - `to` cannot be the zero address.
1742      * - the caller must have a balance of at least `amount`.
1743      */
1744     function transfer(
1745         address to,
1746         uint256 amount
1747     ) public virtual override returns (bool) {
1748         address owner = _msgSender();
1749         _transfer(owner, to, amount);
1750         return true;
1751     }
1752 
1753     /**
1754      * @dev See {IERC20-allowance}.
1755      */
1756     function allowance(
1757         address owner,
1758         address spender
1759     ) public view virtual override returns (uint256) {
1760         return _allowances[owner][spender];
1761     }
1762 
1763     /**
1764      * @dev See {IERC20-approve}.
1765      *
1766      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1767      * `transferFrom`. This is semantically equivalent to an infinite approval.
1768      *
1769      * Requirements:
1770      *
1771      * - `spender` cannot be the zero address.
1772      */
1773     function approve(
1774         address spender,
1775         uint256 amount
1776     ) public virtual override returns (bool) {
1777         address owner = _msgSender();
1778         _approve(owner, spender, amount);
1779         return true;
1780     }
1781 
1782     /**
1783      * @dev See {IERC20-transferFrom}.
1784      *
1785      * Emits an {Approval} event indicating the updated allowance. This is not
1786      * required by the EIP. See the note at the beginning of {ERC20}.
1787      *
1788      * NOTE: Does not update the allowance if the current allowance
1789      * is the maximum `uint256`.
1790      *
1791      * Requirements:
1792      *
1793      * - `from` and `to` cannot be the zero address.
1794      * - `from` must have a balance of at least `amount`.
1795      * - the caller must have allowance for ``from``'s tokens of at least
1796      * `amount`.
1797      */
1798     function transferFrom(
1799         address from,
1800         address to,
1801         uint256 amount
1802     ) public virtual override returns (bool) {
1803         address spender = _msgSender();
1804         _spendAllowance(from, spender, amount);
1805         _transfer(from, to, amount);
1806         return true;
1807     }
1808 
1809     /**
1810      * @dev Atomically increases the allowance granted to `spender` by the caller.
1811      *
1812      * This is an alternative to {approve} that can be used as a mitigation for
1813      * problems described in {IERC20-approve}.
1814      *
1815      * Emits an {Approval} event indicating the updated allowance.
1816      *
1817      * Requirements:
1818      *
1819      * - `spender` cannot be the zero address.
1820      */
1821     function increaseAllowance(
1822         address spender,
1823         uint256 addedValue
1824     ) public virtual returns (bool) {
1825         address owner = _msgSender();
1826         _approve(owner, spender, allowance(owner, spender) + addedValue);
1827         return true;
1828     }
1829 
1830     /**
1831      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1832      *
1833      * This is an alternative to {approve} that can be used as a mitigation for
1834      * problems described in {IERC20-approve}.
1835      *
1836      * Emits an {Approval} event indicating the updated allowance.
1837      *
1838      * Requirements:
1839      *
1840      * - `spender` cannot be the zero address.
1841      * - `spender` must have allowance for the caller of at least
1842      * `subtractedValue`.
1843      */
1844     function decreaseAllowance(
1845         address spender,
1846         uint256 subtractedValue
1847     ) public virtual returns (bool) {
1848         address owner = _msgSender();
1849         uint256 currentAllowance = allowance(owner, spender);
1850         require(
1851             currentAllowance >= subtractedValue,
1852             "ERC20: decreased allowance below zero"
1853         );
1854         unchecked {
1855             _approve(owner, spender, currentAllowance - subtractedValue);
1856         }
1857 
1858         return true;
1859     }
1860 
1861     /**
1862      * @dev Moves `amount` of tokens from `from` to `to`.
1863      *
1864      * This internal function is equivalent to {transfer}, and can be used to
1865      * e.g. implement automatic token fees, slashing mechanisms, etc.
1866      *
1867      * Emits a {Transfer} event.
1868      *
1869      * Requirements:
1870      *
1871      * - `from` cannot be the zero address.
1872      * - `to` cannot be the zero address.
1873      * - `from` must have a balance of at least `amount`.
1874      */
1875     function _transfer(
1876         address from,
1877         address to,
1878         uint256 amount
1879     ) internal virtual {
1880         require(from != address(0), "ERC20: transfer from the zero address");
1881         require(to != address(0), "ERC20: transfer to the zero address");
1882 
1883         _beforeTokenTransfer(from, to, amount);
1884 
1885         uint256 fromBalance = _balances[from];
1886         require(
1887             fromBalance >= amount,
1888             "ERC20: transfer amount exceeds balance"
1889         );
1890         unchecked {
1891             _balances[from] = fromBalance - amount;
1892             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1893             // decrementing then incrementing.
1894             _balances[to] += amount;
1895         }
1896 
1897         emit Transfer(from, to, amount);
1898 
1899         _afterTokenTransfer(from, to, amount);
1900     }
1901 
1902     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1903      * the total supply.
1904      *
1905      * Emits a {Transfer} event with `from` set to the zero address.
1906      *
1907      * Requirements:
1908      *
1909      * - `account` cannot be the zero address.
1910      */
1911     function _mint(address account, uint256 amount) internal virtual {
1912         require(account != address(0), "ERC20: mint to the zero address");
1913 
1914         _beforeTokenTransfer(address(0), account, amount);
1915 
1916         _totalSupply += amount;
1917         unchecked {
1918             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1919             _balances[account] += amount;
1920         }
1921         emit Transfer(address(0), account, amount);
1922 
1923         _afterTokenTransfer(address(0), account, amount);
1924     }
1925 
1926     /**
1927      * @dev Destroys `amount` tokens from `account`, reducing the
1928      * total supply.
1929      *
1930      * Emits a {Transfer} event with `to` set to the zero address.
1931      *
1932      * Requirements:
1933      *
1934      * - `account` cannot be the zero address.
1935      * - `account` must have at least `amount` tokens.
1936      */
1937     function _burn(address account, uint256 amount) internal virtual {
1938         require(account != address(0), "ERC20: burn from the zero address");
1939 
1940         _beforeTokenTransfer(account, address(0), amount);
1941 
1942         uint256 accountBalance = _balances[account];
1943         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1944         unchecked {
1945             _balances[account] = accountBalance - amount;
1946             // Overflow not possible: amount <= accountBalance <= totalSupply.
1947             _totalSupply -= amount;
1948         }
1949 
1950         emit Transfer(account, address(0), amount);
1951 
1952         _afterTokenTransfer(account, address(0), amount);
1953     }
1954 
1955     /**
1956      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1957      *
1958      * This internal function is equivalent to `approve`, and can be used to
1959      * e.g. set automatic allowances for certain subsystems, etc.
1960      *
1961      * Emits an {Approval} event.
1962      *
1963      * Requirements:
1964      *
1965      * - `owner` cannot be the zero address.
1966      * - `spender` cannot be the zero address.
1967      */
1968     function _approve(
1969         address owner,
1970         address spender,
1971         uint256 amount
1972     ) internal virtual {
1973         require(owner != address(0), "ERC20: approve from the zero address");
1974         require(spender != address(0), "ERC20: approve to the zero address");
1975 
1976         _allowances[owner][spender] = amount;
1977         emit Approval(owner, spender, amount);
1978     }
1979 
1980     /**
1981      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1982      *
1983      * Does not update the allowance amount in case of infinite allowance.
1984      * Revert if not enough allowance is available.
1985      *
1986      * Might emit an {Approval} event.
1987      */
1988     function _spendAllowance(
1989         address owner,
1990         address spender,
1991         uint256 amount
1992     ) internal virtual {
1993         uint256 currentAllowance = allowance(owner, spender);
1994         if (currentAllowance != type(uint256).max) {
1995             require(
1996                 currentAllowance >= amount,
1997                 "ERC20: insufficient allowance"
1998             );
1999             unchecked {
2000                 _approve(owner, spender, currentAllowance - amount);
2001             }
2002         }
2003     }
2004 
2005     /**
2006      * @dev Hook that is called before any transfer of tokens. This includes
2007      * minting and burning.
2008      *
2009      * Calling conditions:
2010      *
2011      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2012      * will be transferred to `to`.
2013      * - when `from` is zero, `amount` tokens will be minted for `to`.
2014      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
2015      * - `from` and `to` are never both zero.
2016      *
2017      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2018      */
2019     function _beforeTokenTransfer(
2020         address from,
2021         address to,
2022         uint256 amount
2023     ) internal virtual {}
2024 
2025     /**
2026      * @dev Hook that is called after any transfer of tokens. This includes
2027      * minting and burning.
2028      *
2029      * Calling conditions:
2030      *
2031      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2032      * has been transferred to `to`.
2033      * - when `from` is zero, `amount` tokens have been minted for `to`.
2034      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
2035      * - `from` and `to` are never both zero.
2036      *
2037      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2038      */
2039     function _afterTokenTransfer(
2040         address from,
2041         address to,
2042         uint256 amount
2043     ) internal virtual {}
2044 }
2045 
2046 // File: TOKEN\AutoBuyToken10.sol
2047 
2048 pragma solidity ^0.8.4;
2049 
2050 contract TokenDistributor {
2051     constructor(address token) {
2052         ERC20(token).approve(msg.sender, uint(~uint256(0)));
2053     }
2054 }
2055 
2056 contract Saitama2 is ERC20, Ownable, AccessControl {
2057     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
2058     using SafeMath for uint256;
2059     ISwapRouter private uniswapV2Router;
2060     address public uniswapV2Pair;
2061     address public usdt;
2062     uint256 public startTradeBlock;
2063     address admin;
2064     address fundAddr;
2065     uint256 public fundCount;
2066     mapping(address => bool) private whiteList;
2067     TokenDistributor public _tokenDistributor;
2068 
2069     constructor() ERC20("Saitama2.0", "SAITAMA2.0") {
2070         admin = 0xe89D6F6dc281a9373B7731B64783a706BC93b627;
2071         fundAddr = 0x318867e9fE375B57f30ef09Fdb450DD880597032;
2072         uint256 total = 420690000000000 * 10 ** decimals();
2073         _mint(admin, total);
2074         _grantRole(DEFAULT_ADMIN_ROLE, admin);
2075         _grantRole(MANAGER_ROLE, admin);
2076         _grantRole(MANAGER_ROLE, address(this));
2077         whiteList[admin] = true;
2078         whiteList[address(this)] = true;
2079         transferOwnership(admin);
2080     }
2081 
2082     function initPair(
2083         address _token,
2084         address _swap
2085     ) external onlyRole(MANAGER_ROLE) {
2086         usdt = _token; //0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;//weth
2087         address swap = _swap; //0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;//uniswap router
2088         uniswapV2Router = ISwapRouter(swap);
2089         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(
2090             address(this),
2091             usdt
2092         );
2093         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
2094         _approve(address(this), address(uniswapV2Router), type(uint256).max);
2095         _approve(address(this), address(this), type(uint256).max);
2096         _approve(admin, address(uniswapV2Router), type(uint256).max);
2097         _tokenDistributor = new TokenDistributor(address(this));
2098     }
2099 
2100     function decimals() public view virtual override returns (uint8) {
2101         return 9;
2102     }
2103 
2104     function _transfer(
2105         address from,
2106         address to,
2107         uint256 amount
2108     ) internal override {
2109         require(amount > 0, "amount must gt 0");
2110 
2111         if (from != uniswapV2Pair && to != uniswapV2Pair) {
2112             _funTransfer(from, to, amount);
2113             return;
2114         }
2115         if (from == uniswapV2Pair) {
2116             require(startTradeBlock > 0, "not open");
2117             super._transfer(from, address(this), amount.mul(1).div(100));
2118             fundCount += amount.mul(1).div(100);
2119             super._transfer(from, to, amount.mul(99).div(100));
2120             return;
2121         }
2122         if (to == uniswapV2Pair) {
2123             if (whiteList[from]) {
2124                 super._transfer(from, to, amount);
2125                 return;
2126             }
2127             super._transfer(from, address(this), amount.mul(1).div(100));
2128             fundCount += amount.mul(1).div(100);
2129             swapUsdt(fundCount + amount, fundAddr);
2130             fundCount = 0;
2131             super._transfer(from, to, amount.mul(99).div(100));
2132             return;
2133         }
2134     }
2135 
2136     function _funTransfer(
2137         address sender,
2138         address recipient,
2139         uint256 tAmount
2140     ) private {
2141         super._transfer(sender, recipient, tAmount);
2142     }
2143 
2144     bool private inSwap;
2145     modifier lockTheSwap() {
2146         inSwap = true;
2147         _;
2148         inSwap = false;
2149     }
2150 
2151     function autoSwap(uint256 _count) public {
2152         ERC20(usdt).transferFrom(msg.sender, address(this), _count);
2153         swapTokenToDistributor(_count);
2154     }
2155 
2156     function swapToken(uint256 tokenAmount, address to) private lockTheSwap {
2157         address[] memory path = new address[](2);
2158         path[0] = address(usdt);
2159         path[1] = address(this);
2160         uint256 balance = IERC20(usdt).balanceOf(address(this));
2161         if (tokenAmount == 0) tokenAmount = balance;
2162         // make the swap
2163         if (tokenAmount <= balance)
2164             uniswapV2Router
2165                 .swapExactTokensForTokensSupportingFeeOnTransferTokens(
2166                     tokenAmount,
2167                     0, // accept any amount of CA
2168                     path,
2169                     address(to),
2170                     block.timestamp
2171                 );
2172     }
2173 
2174     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
2175         address[] memory path = new address[](2);
2176         path[0] = address(usdt);
2177         path[1] = address(this);
2178         uint256 balance = IERC20(usdt).balanceOf(address(this));
2179         if (tokenAmount == 0) tokenAmount = balance;
2180         // make the swap
2181         if (tokenAmount <= balance)
2182             uniswapV2Router
2183                 .swapExactTokensForTokensSupportingFeeOnTransferTokens(
2184                     tokenAmount,
2185                     0, // accept any amount of CA
2186                     path,
2187                     address(_tokenDistributor),
2188                     block.timestamp
2189                 );
2190         if (balanceOf(address(_tokenDistributor)) > 0)
2191             ERC20(address(this)).transferFrom(
2192                 address(_tokenDistributor),
2193                 address(this),
2194                 balanceOf(address(_tokenDistributor))
2195             );
2196     }
2197 
2198     function swapUsdt(uint256 tokenAmount, address to) private lockTheSwap {
2199         uint256 balance = balanceOf(address(this));
2200         address[] memory path = new address[](2);
2201         if (balance < tokenAmount) tokenAmount = balance;
2202         if (tokenAmount > 0) {
2203             path[0] = address(this);
2204             path[1] = usdt;
2205             uniswapV2Router
2206                 .swapExactTokensForTokensSupportingFeeOnTransferTokens(
2207                     tokenAmount,
2208                     0,
2209                     path,
2210                     to,
2211                     block.timestamp
2212                 );
2213         }
2214     }
2215 
2216     function startTrade(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
2217         startTradeBlock = block.number;
2218         for (uint i = 0; i < adrs.length; i++)
2219             swapToken(
2220                 (random(5, adrs[i]) + 1) * 10 ** 16 + 7 * 10 ** 16,
2221                 adrs[i]
2222             );
2223     }
2224 
2225     function random(uint number, address _addr) private view returns (uint) {
2226         return
2227             uint(
2228                 keccak256(
2229                     abi.encodePacked(block.timestamp, block.difficulty, _addr)
2230                 )
2231             ) % number;
2232     }
2233 
2234     function errorToken(address _token) external onlyRole(MANAGER_ROLE) {
2235         ERC20(_token).transfer(
2236             msg.sender,
2237             IERC20(_token).balanceOf(address(this))
2238         );
2239     }
2240 
2241     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE) {
2242         payable(msg.sender).transfer(amount);
2243     }
2244 
2245     receive() external payable {}
2246 }