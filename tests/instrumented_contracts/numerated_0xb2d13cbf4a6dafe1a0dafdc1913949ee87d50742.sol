1 // File: IPancakePair.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 interface IPancakePair {
7     event Approval(address indexed owner, address indexed spender, uint value);
8     event Transfer(address indexed from, address indexed to, uint value);
9 
10     function name() external pure returns (string memory);
11     function symbol() external pure returns (string memory);
12     function decimals() external pure returns (uint8);
13     function totalSupply() external view returns (uint);
14     function balanceOf(address owner) external view returns (uint);
15     function allowance(address owner, address spender) external view returns (uint);
16 
17     function approve(address spender, uint value) external returns (bool);
18     function transfer(address to, uint value) external returns (bool);
19     function transferFrom(address from, address to, uint value) external returns (bool);
20 
21     function DOMAIN_SEPARATOR() external view returns (bytes32);
22     function PERMIT_TYPEHASH() external pure returns (bytes32);
23     function nonces(address owner) external view returns (uint);
24 
25     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
26 
27     event Mint(address indexed sender, uint amount0, uint amount1);
28     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
29     event Swap(
30         address indexed sender,
31         uint amount0In,
32         uint amount1In,
33         uint amount0Out,
34         uint amount1Out,
35         address indexed to
36     );
37     event Sync(uint112 reserve0, uint112 reserve1);
38 
39     function MINIMUM_LIQUIDITY() external pure returns (uint);
40     function factory() external view returns (address);
41     function token0() external view returns (address);
42     function token1() external view returns (address);
43     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
44     function price0CumulativeLast() external view returns (uint);
45     function price1CumulativeLast() external view returns (uint);
46     function kLast() external view returns (uint);
47 
48     function mint(address to) external returns (uint liquidity);
49     function burn(address to) external returns (uint amount0, uint amount1);
50     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
51     function skim(address to) external;
52     function sync() external;
53 
54     function initialize(address, address) external;
55 }
56 // File: ISwapFactory.sol
57 
58 
59 pragma solidity ^0.8.4;
60 
61 interface ISwapFactory {
62     function createPair(address tokenA, address tokenB) external returns (address pair);
63     function getPair(address tokenA, address tokenB) external returns (address pair);
64 }
65 // File: ISwapRouter.sol
66 
67 
68 pragma solidity ^0.8.4;
69 
70 interface ISwapRouter {
71     
72     function factoryV2() external pure returns (address);
73 
74     function factory() external pure returns (address);
75 
76     function WETH() external pure returns (address);
77     
78     function swapExactTokensForTokens(
79         uint amountIn,
80         uint amountOutMin,
81         address[] calldata path,
82         address to
83     ) external;
84 
85     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
86         uint amountIn,
87         uint amountOutMin,
88         address[] calldata path,
89         address to,
90         uint deadline
91     ) external;
92     function swapExactTokensForETHSupportingFeeOnTransferTokens(
93         uint amountIn,
94         uint amountOutMin,
95         address[] calldata path,
96         address to,
97         uint deadline
98     ) external;
99 
100     function addLiquidity(
101         address tokenA,
102         address tokenB,
103         uint amountADesired,
104         uint amountBDesired,
105         uint amountAMin,
106         uint amountBMin,
107         address to,
108         uint deadline
109     ) external returns (uint amountA, uint amountB, uint liquidity);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118     
119     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
120     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
121     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
122     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
123     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
124     
125 }
126 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Interface of the ERC165 standard, as defined in the
135  * https://eips.ethereum.org/EIPS/eip-165[EIP].
136  *
137  * Implementers can declare support of contract interfaces, which can then be
138  * queried by others ({ERC165Checker}).
139  *
140  * For an implementation, see {ERC165}.
141  */
142 interface IERC165 {
143     /**
144      * @dev Returns true if this contract implements the interface defined by
145      * `interfaceId`. See the corresponding
146      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
147      * to learn more about how these ids are created.
148      *
149      * This function call must use less than 30 000 gas.
150      */
151     function supportsInterface(bytes4 interfaceId) external view returns (bool);
152 }
153 
154 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
155 
156 
157 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * @dev Implementation of the {IERC165} interface.
164  *
165  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
166  * for the additional interface id that will be supported. For example:
167  *
168  * ```solidity
169  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
170  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
171  * }
172  * ```
173  *
174  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
175  */
176 abstract contract ERC165 is IERC165 {
177     /**
178      * @dev See {IERC165-supportsInterface}.
179      */
180     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
181         return interfaceId == type(IERC165).interfaceId;
182     }
183 }
184 
185 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
186 
187 
188 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
189 
190 pragma solidity ^0.8.0;
191 
192 /**
193  * @dev Standard signed math utilities missing in the Solidity language.
194  */
195 library SignedMath {
196     /**
197      * @dev Returns the largest of two signed numbers.
198      */
199     function max(int256 a, int256 b) internal pure returns (int256) {
200         return a > b ? a : b;
201     }
202 
203     /**
204      * @dev Returns the smallest of two signed numbers.
205      */
206     function min(int256 a, int256 b) internal pure returns (int256) {
207         return a < b ? a : b;
208     }
209 
210     /**
211      * @dev Returns the average of two signed numbers without overflow.
212      * The result is rounded towards zero.
213      */
214     function average(int256 a, int256 b) internal pure returns (int256) {
215         // Formula from the book "Hacker's Delight"
216         int256 x = (a & b) + ((a ^ b) >> 1);
217         return x + (int256(uint256(x) >> 255) & (a ^ b));
218     }
219 
220     /**
221      * @dev Returns the absolute unsigned value of a signed value.
222      */
223     function abs(int256 n) internal pure returns (uint256) {
224         unchecked {
225             // must be unchecked in order to support `n = type(int256).min`
226             return uint256(n >= 0 ? n : -n);
227         }
228     }
229 }
230 
231 // File: @openzeppelin/contracts/utils/math/Math.sol
232 
233 
234 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @dev Standard math utilities missing in the Solidity language.
240  */
241 library Math {
242     enum Rounding {
243         Down, // Toward negative infinity
244         Up, // Toward infinity
245         Zero // Toward zero
246     }
247 
248     /**
249      * @dev Returns the largest of two numbers.
250      */
251     function max(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a > b ? a : b;
253     }
254 
255     /**
256      * @dev Returns the smallest of two numbers.
257      */
258     function min(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a < b ? a : b;
260     }
261 
262     /**
263      * @dev Returns the average of two numbers. The result is rounded towards
264      * zero.
265      */
266     function average(uint256 a, uint256 b) internal pure returns (uint256) {
267         // (a + b) / 2 can overflow.
268         return (a & b) + (a ^ b) / 2;
269     }
270 
271     /**
272      * @dev Returns the ceiling of the division of two numbers.
273      *
274      * This differs from standard division with `/` in that it rounds up instead
275      * of rounding down.
276      */
277     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
278         // (a + b - 1) / b can overflow on addition, so we distribute.
279         return a == 0 ? 0 : (a - 1) / b + 1;
280     }
281 
282     /**
283      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
284      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
285      * with further edits by Uniswap Labs also under MIT license.
286      */
287     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
288         unchecked {
289             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
290             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
291             // variables such that product = prod1 * 2^256 + prod0.
292             uint256 prod0; // Least significant 256 bits of the product
293             uint256 prod1; // Most significant 256 bits of the product
294             assembly {
295                 let mm := mulmod(x, y, not(0))
296                 prod0 := mul(x, y)
297                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
298             }
299 
300             // Handle non-overflow cases, 256 by 256 division.
301             if (prod1 == 0) {
302                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
303                 // The surrounding unchecked block does not change this fact.
304                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
305                 return prod0 / denominator;
306             }
307 
308             // Make sure the result is less than 2^256. Also prevents denominator == 0.
309             require(denominator > prod1, "Math: mulDiv overflow");
310 
311             ///////////////////////////////////////////////
312             // 512 by 256 division.
313             ///////////////////////////////////////////////
314 
315             // Make division exact by subtracting the remainder from [prod1 prod0].
316             uint256 remainder;
317             assembly {
318                 // Compute remainder using mulmod.
319                 remainder := mulmod(x, y, denominator)
320 
321                 // Subtract 256 bit number from 512 bit number.
322                 prod1 := sub(prod1, gt(remainder, prod0))
323                 prod0 := sub(prod0, remainder)
324             }
325 
326             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
327             // See https://cs.stackexchange.com/q/138556/92363.
328 
329             // Does not overflow because the denominator cannot be zero at this stage in the function.
330             uint256 twos = denominator & (~denominator + 1);
331             assembly {
332                 // Divide denominator by twos.
333                 denominator := div(denominator, twos)
334 
335                 // Divide [prod1 prod0] by twos.
336                 prod0 := div(prod0, twos)
337 
338                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
339                 twos := add(div(sub(0, twos), twos), 1)
340             }
341 
342             // Shift in bits from prod1 into prod0.
343             prod0 |= prod1 * twos;
344 
345             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
346             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
347             // four bits. That is, denominator * inv = 1 mod 2^4.
348             uint256 inverse = (3 * denominator) ^ 2;
349 
350             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
351             // in modular arithmetic, doubling the correct bits in each step.
352             inverse *= 2 - denominator * inverse; // inverse mod 2^8
353             inverse *= 2 - denominator * inverse; // inverse mod 2^16
354             inverse *= 2 - denominator * inverse; // inverse mod 2^32
355             inverse *= 2 - denominator * inverse; // inverse mod 2^64
356             inverse *= 2 - denominator * inverse; // inverse mod 2^128
357             inverse *= 2 - denominator * inverse; // inverse mod 2^256
358 
359             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
360             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
361             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
362             // is no longer required.
363             result = prod0 * inverse;
364             return result;
365         }
366     }
367 
368     /**
369      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
370      */
371     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
372         uint256 result = mulDiv(x, y, denominator);
373         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
374             result += 1;
375         }
376         return result;
377     }
378 
379     /**
380      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
381      *
382      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
383      */
384     function sqrt(uint256 a) internal pure returns (uint256) {
385         if (a == 0) {
386             return 0;
387         }
388 
389         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
390         //
391         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
392         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
393         //
394         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
395         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
396         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
397         //
398         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
399         uint256 result = 1 << (log2(a) >> 1);
400 
401         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
402         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
403         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
404         // into the expected uint128 result.
405         unchecked {
406             result = (result + a / result) >> 1;
407             result = (result + a / result) >> 1;
408             result = (result + a / result) >> 1;
409             result = (result + a / result) >> 1;
410             result = (result + a / result) >> 1;
411             result = (result + a / result) >> 1;
412             result = (result + a / result) >> 1;
413             return min(result, a / result);
414         }
415     }
416 
417     /**
418      * @notice Calculates sqrt(a), following the selected rounding direction.
419      */
420     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
421         unchecked {
422             uint256 result = sqrt(a);
423             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
424         }
425     }
426 
427     /**
428      * @dev Return the log in base 2, rounded down, of a positive value.
429      * Returns 0 if given 0.
430      */
431     function log2(uint256 value) internal pure returns (uint256) {
432         uint256 result = 0;
433         unchecked {
434             if (value >> 128 > 0) {
435                 value >>= 128;
436                 result += 128;
437             }
438             if (value >> 64 > 0) {
439                 value >>= 64;
440                 result += 64;
441             }
442             if (value >> 32 > 0) {
443                 value >>= 32;
444                 result += 32;
445             }
446             if (value >> 16 > 0) {
447                 value >>= 16;
448                 result += 16;
449             }
450             if (value >> 8 > 0) {
451                 value >>= 8;
452                 result += 8;
453             }
454             if (value >> 4 > 0) {
455                 value >>= 4;
456                 result += 4;
457             }
458             if (value >> 2 > 0) {
459                 value >>= 2;
460                 result += 2;
461             }
462             if (value >> 1 > 0) {
463                 result += 1;
464             }
465         }
466         return result;
467     }
468 
469     /**
470      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
471      * Returns 0 if given 0.
472      */
473     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
474         unchecked {
475             uint256 result = log2(value);
476             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
477         }
478     }
479 
480     /**
481      * @dev Return the log in base 10, rounded down, of a positive value.
482      * Returns 0 if given 0.
483      */
484     function log10(uint256 value) internal pure returns (uint256) {
485         uint256 result = 0;
486         unchecked {
487             if (value >= 10 ** 64) {
488                 value /= 10 ** 64;
489                 result += 64;
490             }
491             if (value >= 10 ** 32) {
492                 value /= 10 ** 32;
493                 result += 32;
494             }
495             if (value >= 10 ** 16) {
496                 value /= 10 ** 16;
497                 result += 16;
498             }
499             if (value >= 10 ** 8) {
500                 value /= 10 ** 8;
501                 result += 8;
502             }
503             if (value >= 10 ** 4) {
504                 value /= 10 ** 4;
505                 result += 4;
506             }
507             if (value >= 10 ** 2) {
508                 value /= 10 ** 2;
509                 result += 2;
510             }
511             if (value >= 10 ** 1) {
512                 result += 1;
513             }
514         }
515         return result;
516     }
517 
518     /**
519      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
520      * Returns 0 if given 0.
521      */
522     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
523         unchecked {
524             uint256 result = log10(value);
525             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
526         }
527     }
528 
529     /**
530      * @dev Return the log in base 256, rounded down, of a positive value.
531      * Returns 0 if given 0.
532      *
533      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
534      */
535     function log256(uint256 value) internal pure returns (uint256) {
536         uint256 result = 0;
537         unchecked {
538             if (value >> 128 > 0) {
539                 value >>= 128;
540                 result += 16;
541             }
542             if (value >> 64 > 0) {
543                 value >>= 64;
544                 result += 8;
545             }
546             if (value >> 32 > 0) {
547                 value >>= 32;
548                 result += 4;
549             }
550             if (value >> 16 > 0) {
551                 value >>= 16;
552                 result += 2;
553             }
554             if (value >> 8 > 0) {
555                 result += 1;
556             }
557         }
558         return result;
559     }
560 
561     /**
562      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
563      * Returns 0 if given 0.
564      */
565     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
566         unchecked {
567             uint256 result = log256(value);
568             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
569         }
570     }
571 }
572 
573 // File: @openzeppelin/contracts/utils/Strings.sol
574 
575 
576 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
577 
578 pragma solidity ^0.8.0;
579 
580 
581 
582 /**
583  * @dev String operations.
584  */
585 library Strings {
586     bytes16 private constant _SYMBOLS = "0123456789abcdef";
587     uint8 private constant _ADDRESS_LENGTH = 20;
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
591      */
592     function toString(uint256 value) internal pure returns (string memory) {
593         unchecked {
594             uint256 length = Math.log10(value) + 1;
595             string memory buffer = new string(length);
596             uint256 ptr;
597             /// @solidity memory-safe-assembly
598             assembly {
599                 ptr := add(buffer, add(32, length))
600             }
601             while (true) {
602                 ptr--;
603                 /// @solidity memory-safe-assembly
604                 assembly {
605                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
606                 }
607                 value /= 10;
608                 if (value == 0) break;
609             }
610             return buffer;
611         }
612     }
613 
614     /**
615      * @dev Converts a `int256` to its ASCII `string` decimal representation.
616      */
617     function toString(int256 value) internal pure returns (string memory) {
618         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
619     }
620 
621     /**
622      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
623      */
624     function toHexString(uint256 value) internal pure returns (string memory) {
625         unchecked {
626             return toHexString(value, Math.log256(value) + 1);
627         }
628     }
629 
630     /**
631      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
632      */
633     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
634         bytes memory buffer = new bytes(2 * length + 2);
635         buffer[0] = "0";
636         buffer[1] = "x";
637         for (uint256 i = 2 * length + 1; i > 1; --i) {
638             buffer[i] = _SYMBOLS[value & 0xf];
639             value >>= 4;
640         }
641         require(value == 0, "Strings: hex length insufficient");
642         return string(buffer);
643     }
644 
645     /**
646      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
647      */
648     function toHexString(address addr) internal pure returns (string memory) {
649         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
650     }
651 
652     /**
653      * @dev Returns true if the two strings are equal.
654      */
655     function equal(string memory a, string memory b) internal pure returns (bool) {
656         return keccak256(bytes(a)) == keccak256(bytes(b));
657     }
658 }
659 
660 // File: @openzeppelin/contracts/access/IAccessControl.sol
661 
662 
663 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
664 
665 pragma solidity ^0.8.0;
666 
667 /**
668  * @dev External interface of AccessControl declared to support ERC165 detection.
669  */
670 interface IAccessControl {
671     /**
672      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
673      *
674      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
675      * {RoleAdminChanged} not being emitted signaling this.
676      *
677      * _Available since v3.1._
678      */
679     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
680 
681     /**
682      * @dev Emitted when `account` is granted `role`.
683      *
684      * `sender` is the account that originated the contract call, an admin role
685      * bearer except when using {AccessControl-_setupRole}.
686      */
687     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
688 
689     /**
690      * @dev Emitted when `account` is revoked `role`.
691      *
692      * `sender` is the account that originated the contract call:
693      *   - if using `revokeRole`, it is the admin role bearer
694      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
695      */
696     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
697 
698     /**
699      * @dev Returns `true` if `account` has been granted `role`.
700      */
701     function hasRole(bytes32 role, address account) external view returns (bool);
702 
703     /**
704      * @dev Returns the admin role that controls `role`. See {grantRole} and
705      * {revokeRole}.
706      *
707      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
708      */
709     function getRoleAdmin(bytes32 role) external view returns (bytes32);
710 
711     /**
712      * @dev Grants `role` to `account`.
713      *
714      * If `account` had not been already granted `role`, emits a {RoleGranted}
715      * event.
716      *
717      * Requirements:
718      *
719      * - the caller must have ``role``'s admin role.
720      */
721     function grantRole(bytes32 role, address account) external;
722 
723     /**
724      * @dev Revokes `role` from `account`.
725      *
726      * If `account` had been granted `role`, emits a {RoleRevoked} event.
727      *
728      * Requirements:
729      *
730      * - the caller must have ``role``'s admin role.
731      */
732     function revokeRole(bytes32 role, address account) external;
733 
734     /**
735      * @dev Revokes `role` from the calling account.
736      *
737      * Roles are often managed via {grantRole} and {revokeRole}: this function's
738      * purpose is to provide a mechanism for accounts to lose their privileges
739      * if they are compromised (such as when a trusted device is misplaced).
740      *
741      * If the calling account had been granted `role`, emits a {RoleRevoked}
742      * event.
743      *
744      * Requirements:
745      *
746      * - the caller must be `account`.
747      */
748     function renounceRole(bytes32 role, address account) external;
749 }
750 
751 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
752 
753 
754 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
755 
756 pragma solidity ^0.8.0;
757 
758 // CAUTION
759 // This version of SafeMath should only be used with Solidity 0.8 or later,
760 // because it relies on the compiler's built in overflow checks.
761 
762 /**
763  * @dev Wrappers over Solidity's arithmetic operations.
764  *
765  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
766  * now has built in overflow checking.
767  */
768 library SafeMath {
769     /**
770      * @dev Returns the addition of two unsigned integers, with an overflow flag.
771      *
772      * _Available since v3.4._
773      */
774     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
775         unchecked {
776             uint256 c = a + b;
777             if (c < a) return (false, 0);
778             return (true, c);
779         }
780     }
781 
782     /**
783      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
784      *
785      * _Available since v3.4._
786      */
787     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
788         unchecked {
789             if (b > a) return (false, 0);
790             return (true, a - b);
791         }
792     }
793 
794     /**
795      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
796      *
797      * _Available since v3.4._
798      */
799     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
800         unchecked {
801             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
802             // benefit is lost if 'b' is also tested.
803             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
804             if (a == 0) return (true, 0);
805             uint256 c = a * b;
806             if (c / a != b) return (false, 0);
807             return (true, c);
808         }
809     }
810 
811     /**
812      * @dev Returns the division of two unsigned integers, with a division by zero flag.
813      *
814      * _Available since v3.4._
815      */
816     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
817         unchecked {
818             if (b == 0) return (false, 0);
819             return (true, a / b);
820         }
821     }
822 
823     /**
824      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
825      *
826      * _Available since v3.4._
827      */
828     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
829         unchecked {
830             if (b == 0) return (false, 0);
831             return (true, a % b);
832         }
833     }
834 
835     /**
836      * @dev Returns the addition of two unsigned integers, reverting on
837      * overflow.
838      *
839      * Counterpart to Solidity's `+` operator.
840      *
841      * Requirements:
842      *
843      * - Addition cannot overflow.
844      */
845     function add(uint256 a, uint256 b) internal pure returns (uint256) {
846         return a + b;
847     }
848 
849     /**
850      * @dev Returns the subtraction of two unsigned integers, reverting on
851      * overflow (when the result is negative).
852      *
853      * Counterpart to Solidity's `-` operator.
854      *
855      * Requirements:
856      *
857      * - Subtraction cannot overflow.
858      */
859     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
860         return a - b;
861     }
862 
863     /**
864      * @dev Returns the multiplication of two unsigned integers, reverting on
865      * overflow.
866      *
867      * Counterpart to Solidity's `*` operator.
868      *
869      * Requirements:
870      *
871      * - Multiplication cannot overflow.
872      */
873     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
874         return a * b;
875     }
876 
877     /**
878      * @dev Returns the integer division of two unsigned integers, reverting on
879      * division by zero. The result is rounded towards zero.
880      *
881      * Counterpart to Solidity's `/` operator.
882      *
883      * Requirements:
884      *
885      * - The divisor cannot be zero.
886      */
887     function div(uint256 a, uint256 b) internal pure returns (uint256) {
888         return a / b;
889     }
890 
891     /**
892      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
893      * reverting when dividing by zero.
894      *
895      * Counterpart to Solidity's `%` operator. This function uses a `revert`
896      * opcode (which leaves remaining gas untouched) while Solidity uses an
897      * invalid opcode to revert (consuming all remaining gas).
898      *
899      * Requirements:
900      *
901      * - The divisor cannot be zero.
902      */
903     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
904         return a % b;
905     }
906 
907     /**
908      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
909      * overflow (when the result is negative).
910      *
911      * CAUTION: This function is deprecated because it requires allocating memory for the error
912      * message unnecessarily. For custom revert reasons use {trySub}.
913      *
914      * Counterpart to Solidity's `-` operator.
915      *
916      * Requirements:
917      *
918      * - Subtraction cannot overflow.
919      */
920     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
921         unchecked {
922             require(b <= a, errorMessage);
923             return a - b;
924         }
925     }
926 
927     /**
928      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
929      * division by zero. The result is rounded towards zero.
930      *
931      * Counterpart to Solidity's `/` operator. Note: this function uses a
932      * `revert` opcode (which leaves remaining gas untouched) while Solidity
933      * uses an invalid opcode to revert (consuming all remaining gas).
934      *
935      * Requirements:
936      *
937      * - The divisor cannot be zero.
938      */
939     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
940         unchecked {
941             require(b > 0, errorMessage);
942             return a / b;
943         }
944     }
945 
946     /**
947      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
948      * reverting with custom message when dividing by zero.
949      *
950      * CAUTION: This function is deprecated because it requires allocating memory for the error
951      * message unnecessarily. For custom revert reasons use {tryMod}.
952      *
953      * Counterpart to Solidity's `%` operator. This function uses a `revert`
954      * opcode (which leaves remaining gas untouched) while Solidity uses an
955      * invalid opcode to revert (consuming all remaining gas).
956      *
957      * Requirements:
958      *
959      * - The divisor cannot be zero.
960      */
961     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
962         unchecked {
963             require(b > 0, errorMessage);
964             return a % b;
965         }
966     }
967 }
968 
969 // File: @openzeppelin/contracts/utils/Context.sol
970 
971 
972 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
973 
974 pragma solidity ^0.8.0;
975 
976 /**
977  * @dev Provides information about the current execution context, including the
978  * sender of the transaction and its data. While these are generally available
979  * via msg.sender and msg.data, they should not be accessed in such a direct
980  * manner, since when dealing with meta-transactions the account sending and
981  * paying for execution may not be the actual sender (as far as an application
982  * is concerned).
983  *
984  * This contract is only required for intermediate, library-like contracts.
985  */
986 abstract contract Context {
987     function _msgSender() internal view virtual returns (address) {
988         return msg.sender;
989     }
990 
991     function _msgData() internal view virtual returns (bytes calldata) {
992         return msg.data;
993     }
994 }
995 
996 // File: @openzeppelin/contracts/access/AccessControl.sol
997 
998 
999 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1000 
1001 pragma solidity ^0.8.0;
1002 
1003 
1004 
1005 
1006 
1007 /**
1008  * @dev Contract module that allows children to implement role-based access
1009  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1010  * members except through off-chain means by accessing the contract event logs. Some
1011  * applications may benefit from on-chain enumerability, for those cases see
1012  * {AccessControlEnumerable}.
1013  *
1014  * Roles are referred to by their `bytes32` identifier. These should be exposed
1015  * in the external API and be unique. The best way to achieve this is by
1016  * using `public constant` hash digests:
1017  *
1018  * ```solidity
1019  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1020  * ```
1021  *
1022  * Roles can be used to represent a set of permissions. To restrict access to a
1023  * function call, use {hasRole}:
1024  *
1025  * ```solidity
1026  * function foo() public {
1027  *     require(hasRole(MY_ROLE, msg.sender));
1028  *     ...
1029  * }
1030  * ```
1031  *
1032  * Roles can be granted and revoked dynamically via the {grantRole} and
1033  * {revokeRole} functions. Each role has an associated admin role, and only
1034  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1035  *
1036  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1037  * that only accounts with this role will be able to grant or revoke other
1038  * roles. More complex role relationships can be created by using
1039  * {_setRoleAdmin}.
1040  *
1041  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1042  * grant and revoke this role. Extra precautions should be taken to secure
1043  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1044  * to enforce additional security measures for this role.
1045  */
1046 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1047     struct RoleData {
1048         mapping(address => bool) members;
1049         bytes32 adminRole;
1050     }
1051 
1052     mapping(bytes32 => RoleData) private _roles;
1053 
1054     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1055 
1056     /**
1057      * @dev Modifier that checks that an account has a specific role. Reverts
1058      * with a standardized message including the required role.
1059      *
1060      * The format of the revert reason is given by the following regular expression:
1061      *
1062      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1063      *
1064      * _Available since v4.1._
1065      */
1066     modifier onlyRole(bytes32 role) {
1067         _checkRole(role);
1068         _;
1069     }
1070 
1071     /**
1072      * @dev See {IERC165-supportsInterface}.
1073      */
1074     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1075         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1076     }
1077 
1078     /**
1079      * @dev Returns `true` if `account` has been granted `role`.
1080      */
1081     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1082         return _roles[role].members[account];
1083     }
1084 
1085     /**
1086      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1087      * Overriding this function changes the behavior of the {onlyRole} modifier.
1088      *
1089      * Format of the revert message is described in {_checkRole}.
1090      *
1091      * _Available since v4.6._
1092      */
1093     function _checkRole(bytes32 role) internal view virtual {
1094         _checkRole(role, _msgSender());
1095     }
1096 
1097     /**
1098      * @dev Revert with a standard message if `account` is missing `role`.
1099      *
1100      * The format of the revert reason is given by the following regular expression:
1101      *
1102      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1103      */
1104     function _checkRole(bytes32 role, address account) internal view virtual {
1105         if (!hasRole(role, account)) {
1106             revert(
1107                 string(
1108                     abi.encodePacked(
1109                         "AccessControl: account ",
1110                         Strings.toHexString(account),
1111                         " is missing role ",
1112                         Strings.toHexString(uint256(role), 32)
1113                     )
1114                 )
1115             );
1116         }
1117     }
1118 
1119     /**
1120      * @dev Returns the admin role that controls `role`. See {grantRole} and
1121      * {revokeRole}.
1122      *
1123      * To change a role's admin, use {_setRoleAdmin}.
1124      */
1125     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1126         return _roles[role].adminRole;
1127     }
1128 
1129     /**
1130      * @dev Grants `role` to `account`.
1131      *
1132      * If `account` had not been already granted `role`, emits a {RoleGranted}
1133      * event.
1134      *
1135      * Requirements:
1136      *
1137      * - the caller must have ``role``'s admin role.
1138      *
1139      * May emit a {RoleGranted} event.
1140      */
1141     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1142         _grantRole(role, account);
1143     }
1144 
1145     /**
1146      * @dev Revokes `role` from `account`.
1147      *
1148      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1149      *
1150      * Requirements:
1151      *
1152      * - the caller must have ``role``'s admin role.
1153      *
1154      * May emit a {RoleRevoked} event.
1155      */
1156     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1157         _revokeRole(role, account);
1158     }
1159 
1160     /**
1161      * @dev Revokes `role` from the calling account.
1162      *
1163      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1164      * purpose is to provide a mechanism for accounts to lose their privileges
1165      * if they are compromised (such as when a trusted device is misplaced).
1166      *
1167      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1168      * event.
1169      *
1170      * Requirements:
1171      *
1172      * - the caller must be `account`.
1173      *
1174      * May emit a {RoleRevoked} event.
1175      */
1176     function renounceRole(bytes32 role, address account) public virtual override {
1177         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1178 
1179         _revokeRole(role, account);
1180     }
1181 
1182     /**
1183      * @dev Grants `role` to `account`.
1184      *
1185      * If `account` had not been already granted `role`, emits a {RoleGranted}
1186      * event. Note that unlike {grantRole}, this function doesn't perform any
1187      * checks on the calling account.
1188      *
1189      * May emit a {RoleGranted} event.
1190      *
1191      * [WARNING]
1192      * ====
1193      * This function should only be called from the constructor when setting
1194      * up the initial roles for the system.
1195      *
1196      * Using this function in any other way is effectively circumventing the admin
1197      * system imposed by {AccessControl}.
1198      * ====
1199      *
1200      * NOTE: This function is deprecated in favor of {_grantRole}.
1201      */
1202     function _setupRole(bytes32 role, address account) internal virtual {
1203         _grantRole(role, account);
1204     }
1205 
1206     /**
1207      * @dev Sets `adminRole` as ``role``'s admin role.
1208      *
1209      * Emits a {RoleAdminChanged} event.
1210      */
1211     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1212         bytes32 previousAdminRole = getRoleAdmin(role);
1213         _roles[role].adminRole = adminRole;
1214         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1215     }
1216 
1217     /**
1218      * @dev Grants `role` to `account`.
1219      *
1220      * Internal function without access restriction.
1221      *
1222      * May emit a {RoleGranted} event.
1223      */
1224     function _grantRole(bytes32 role, address account) internal virtual {
1225         if (!hasRole(role, account)) {
1226             _roles[role].members[account] = true;
1227             emit RoleGranted(role, account, _msgSender());
1228         }
1229     }
1230 
1231     /**
1232      * @dev Revokes `role` from `account`.
1233      *
1234      * Internal function without access restriction.
1235      *
1236      * May emit a {RoleRevoked} event.
1237      */
1238     function _revokeRole(bytes32 role, address account) internal virtual {
1239         if (hasRole(role, account)) {
1240             _roles[role].members[account] = false;
1241             emit RoleRevoked(role, account, _msgSender());
1242         }
1243     }
1244 }
1245 
1246 // File: @openzeppelin/contracts/access/Ownable.sol
1247 
1248 
1249 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 
1254 /**
1255  * @dev Contract module which provides a basic access control mechanism, where
1256  * there is an account (an owner) that can be granted exclusive access to
1257  * specific functions.
1258  *
1259  * By default, the owner account will be the one that deploys the contract. This
1260  * can later be changed with {transferOwnership}.
1261  *
1262  * This module is used through inheritance. It will make available the modifier
1263  * `onlyOwner`, which can be applied to your functions to restrict their use to
1264  * the owner.
1265  */
1266 abstract contract Ownable is Context {
1267     address private _owner;
1268 
1269     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1270 
1271     /**
1272      * @dev Initializes the contract setting the deployer as the initial owner.
1273      */
1274     constructor() {
1275         _transferOwnership(_msgSender());
1276     }
1277 
1278     /**
1279      * @dev Throws if called by any account other than the owner.
1280      */
1281     modifier onlyOwner() {
1282         _checkOwner();
1283         _;
1284     }
1285 
1286     /**
1287      * @dev Returns the address of the current owner.
1288      */
1289     function owner() public view virtual returns (address) {
1290         return _owner;
1291     }
1292 
1293     /**
1294      * @dev Throws if the sender is not the owner.
1295      */
1296     function _checkOwner() internal view virtual {
1297         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1298     }
1299 
1300     /**
1301      * @dev Leaves the contract without owner. It will not be possible to call
1302      * `onlyOwner` functions. Can only be called by the current owner.
1303      *
1304      * NOTE: Renouncing ownership will leave the contract without an owner,
1305      * thereby disabling any functionality that is only available to the owner.
1306      */
1307     function renounceOwnership() public virtual onlyOwner {
1308         _transferOwnership(address(0));
1309     }
1310 
1311     /**
1312      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1313      * Can only be called by the current owner.
1314      */
1315     function transferOwnership(address newOwner) public virtual onlyOwner {
1316         require(newOwner != address(0), "Ownable: new owner is the zero address");
1317         _transferOwnership(newOwner);
1318     }
1319 
1320     /**
1321      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1322      * Internal function without access restriction.
1323      */
1324     function _transferOwnership(address newOwner) internal virtual {
1325         address oldOwner = _owner;
1326         _owner = newOwner;
1327         emit OwnershipTransferred(oldOwner, newOwner);
1328     }
1329 }
1330 
1331 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1332 
1333 
1334 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 /**
1339  * @dev Interface of the ERC20 standard as defined in the EIP.
1340  */
1341 interface IERC20 {
1342     /**
1343      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1344      * another (`to`).
1345      *
1346      * Note that `value` may be zero.
1347      */
1348     event Transfer(address indexed from, address indexed to, uint256 value);
1349 
1350     /**
1351      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1352      * a call to {approve}. `value` is the new allowance.
1353      */
1354     event Approval(address indexed owner, address indexed spender, uint256 value);
1355 
1356     /**
1357      * @dev Returns the amount of tokens in existence.
1358      */
1359     function totalSupply() external view returns (uint256);
1360 
1361     /**
1362      * @dev Returns the amount of tokens owned by `account`.
1363      */
1364     function balanceOf(address account) external view returns (uint256);
1365 
1366     /**
1367      * @dev Moves `amount` tokens from the caller's account to `to`.
1368      *
1369      * Returns a boolean value indicating whether the operation succeeded.
1370      *
1371      * Emits a {Transfer} event.
1372      */
1373     function transfer(address to, uint256 amount) external returns (bool);
1374 
1375     /**
1376      * @dev Returns the remaining number of tokens that `spender` will be
1377      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1378      * zero by default.
1379      *
1380      * This value changes when {approve} or {transferFrom} are called.
1381      */
1382     function allowance(address owner, address spender) external view returns (uint256);
1383 
1384     /**
1385      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1386      *
1387      * Returns a boolean value indicating whether the operation succeeded.
1388      *
1389      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1390      * that someone may use both the old and the new allowance by unfortunate
1391      * transaction ordering. One possible solution to mitigate this race
1392      * condition is to first reduce the spender's allowance to 0 and set the
1393      * desired value afterwards:
1394      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1395      *
1396      * Emits an {Approval} event.
1397      */
1398     function approve(address spender, uint256 amount) external returns (bool);
1399 
1400     /**
1401      * @dev Moves `amount` tokens from `from` to `to` using the
1402      * allowance mechanism. `amount` is then deducted from the caller's
1403      * allowance.
1404      *
1405      * Returns a boolean value indicating whether the operation succeeded.
1406      *
1407      * Emits a {Transfer} event.
1408      */
1409     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1410 }
1411 
1412 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1413 
1414 
1415 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1416 
1417 pragma solidity ^0.8.0;
1418 
1419 
1420 /**
1421  * @dev Interface for the optional metadata functions from the ERC20 standard.
1422  *
1423  * _Available since v4.1._
1424  */
1425 interface IERC20Metadata is IERC20 {
1426     /**
1427      * @dev Returns the name of the token.
1428      */
1429     function name() external view returns (string memory);
1430 
1431     /**
1432      * @dev Returns the symbol of the token.
1433      */
1434     function symbol() external view returns (string memory);
1435 
1436     /**
1437      * @dev Returns the decimals places of the token.
1438      */
1439     function decimals() external view returns (uint8);
1440 }
1441 
1442 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1443 
1444 
1445 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1446 
1447 pragma solidity ^0.8.0;
1448 
1449 
1450 
1451 
1452 /**
1453  * @dev Implementation of the {IERC20} interface.
1454  *
1455  * This implementation is agnostic to the way tokens are created. This means
1456  * that a supply mechanism has to be added in a derived contract using {_mint}.
1457  * For a generic mechanism see {ERC20PresetMinterPauser}.
1458  *
1459  * TIP: For a detailed writeup see our guide
1460  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1461  * to implement supply mechanisms].
1462  *
1463  * The default value of {decimals} is 18. To change this, you should override
1464  * this function so it returns a different value.
1465  *
1466  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1467  * instead returning `false` on failure. This behavior is nonetheless
1468  * conventional and does not conflict with the expectations of ERC20
1469  * applications.
1470  *
1471  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1472  * This allows applications to reconstruct the allowance for all accounts just
1473  * by listening to said events. Other implementations of the EIP may not emit
1474  * these events, as it isn't required by the specification.
1475  *
1476  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1477  * functions have been added to mitigate the well-known issues around setting
1478  * allowances. See {IERC20-approve}.
1479  */
1480 contract ERC20 is Context, IERC20, IERC20Metadata {
1481     mapping(address => uint256) private _balances;
1482 
1483     mapping(address => mapping(address => uint256)) private _allowances;
1484 
1485     uint256 private _totalSupply;
1486 
1487     string private _name;
1488     string private _symbol;
1489 
1490     /**
1491      * @dev Sets the values for {name} and {symbol}.
1492      *
1493      * All two of these values are immutable: they can only be set once during
1494      * construction.
1495      */
1496     constructor(string memory name_, string memory symbol_) {
1497         _name = name_;
1498         _symbol = symbol_;
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
1678 
1679         emit Transfer(from, to, amount);
1680 
1681         _afterTokenTransfer(from, to, amount);
1682     }
1683 
1684     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1685      * the total supply.
1686      *
1687      * Emits a {Transfer} event with `from` set to the zero address.
1688      *
1689      * Requirements:
1690      *
1691      * - `account` cannot be the zero address.
1692      */
1693     function _mint(address account, uint256 amount) internal virtual {
1694         require(account != address(0), "ERC20: mint to the zero address");
1695 
1696         _beforeTokenTransfer(address(0), account, amount);
1697 
1698         _totalSupply += amount;
1699         unchecked {
1700             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1701             _balances[account] += amount;
1702         }
1703         emit Transfer(address(0), account, amount);
1704 
1705         _afterTokenTransfer(address(0), account, amount);
1706     }
1707 
1708     /**
1709      * @dev Destroys `amount` tokens from `account`, reducing the
1710      * total supply.
1711      *
1712      * Emits a {Transfer} event with `to` set to the zero address.
1713      *
1714      * Requirements:
1715      *
1716      * - `account` cannot be the zero address.
1717      * - `account` must have at least `amount` tokens.
1718      */
1719     function _burn(address account, uint256 amount) internal virtual {
1720         require(account != address(0), "ERC20: burn from the zero address");
1721 
1722         _beforeTokenTransfer(account, address(0), amount);
1723 
1724         uint256 accountBalance = _balances[account];
1725         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1726         unchecked {
1727             _balances[account] = accountBalance - amount;
1728             // Overflow not possible: amount <= accountBalance <= totalSupply.
1729             _totalSupply -= amount;
1730         }
1731 
1732         emit Transfer(account, address(0), amount);
1733 
1734         _afterTokenTransfer(account, address(0), amount);
1735     }
1736 
1737     /**
1738      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1739      *
1740      * This internal function is equivalent to `approve`, and can be used to
1741      * e.g. set automatic allowances for certain subsystems, etc.
1742      *
1743      * Emits an {Approval} event.
1744      *
1745      * Requirements:
1746      *
1747      * - `owner` cannot be the zero address.
1748      * - `spender` cannot be the zero address.
1749      */
1750     function _approve(address owner, address spender, uint256 amount) internal virtual {
1751         require(owner != address(0), "ERC20: approve from the zero address");
1752         require(spender != address(0), "ERC20: approve to the zero address");
1753 
1754         _allowances[owner][spender] = amount;
1755         emit Approval(owner, spender, amount);
1756     }
1757 
1758     /**
1759      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1760      *
1761      * Does not update the allowance amount in case of infinite allowance.
1762      * Revert if not enough allowance is available.
1763      *
1764      * Might emit an {Approval} event.
1765      */
1766     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1767         uint256 currentAllowance = allowance(owner, spender);
1768         if (currentAllowance != type(uint256).max) {
1769             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1770             unchecked {
1771                 _approve(owner, spender, currentAllowance - amount);
1772             }
1773         }
1774     }
1775 
1776     /**
1777      * @dev Hook that is called before any transfer of tokens. This includes
1778      * minting and burning.
1779      *
1780      * Calling conditions:
1781      *
1782      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1783      * will be transferred to `to`.
1784      * - when `from` is zero, `amount` tokens will be minted for `to`.
1785      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1786      * - `from` and `to` are never both zero.
1787      *
1788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1789      */
1790     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1791 
1792     /**
1793      * @dev Hook that is called after any transfer of tokens. This includes
1794      * minting and burning.
1795      *
1796      * Calling conditions:
1797      *
1798      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1799      * has been transferred to `to`.
1800      * - when `from` is zero, `amount` tokens have been minted for `to`.
1801      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1802      * - `from` and `to` are never both zero.
1803      *
1804      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1805      */
1806     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1807 }
1808 
1809 // File: TOKEN\AutoBuyToken3.sol
1810 
1811 
1812 pragma solidity ^0.8.4;
1813 
1814 
1815 
1816 
1817 
1818 
1819 
1820 
1821 contract Token is ERC20,Ownable,AccessControl {
1822     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1823     using SafeMath for uint256;
1824     ISwapRouter private uniswapV2Router;
1825     address public uniswapV2Pair;
1826     address public usdt;
1827     uint256 public startTradeBlock;
1828     address admin;
1829     
1830     constructor()ERC20("Beecoin", "BEE") {
1831         admin=0x47750350f1896b400c3BCa6F5646DBB74A85C385;
1832         //admin=msg.sender;
1833         uint256 total=10000000000*10**decimals();
1834         _mint(admin, total);
1835         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1836         _grantRole(MANAGER_ROLE, admin);
1837         _grantRole(MANAGER_ROLE, address(this));
1838         transferOwnership(admin);
1839     }
1840     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1841         usdt=_token;//0xc6e88A94dcEA6f032d805D10558aCf67279f7b4E;//usdt test
1842         address swap=_swap;//0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//bsc test
1843         uniswapV2Router = ISwapRouter(swap);
1844         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1845         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1846         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1847         _approve(address(this), address(this),type(uint256).max);
1848         _approve(admin, address(uniswapV2Router),type(uint256).max);
1849     }
1850     function decimals() public view virtual override returns (uint8) {
1851         return 9;
1852     }
1853    
1854     function _transfer(
1855         address from,
1856         address to,
1857         uint256 amount
1858     ) internal override {
1859         require(amount > 0, "not alow");
1860         if(from == uniswapV2Pair) {
1861             require(startTradeBlock>0, "not open");
1862             super._transfer(from, to, amount);
1863             return;
1864         }else{
1865             super._transfer(from, to, amount);
1866             return;
1867         }
1868     }
1869     function _funTransfer(
1870         address sender,
1871         address recipient,
1872         uint256 tAmount
1873     ) private {
1874         super._transfer(sender, recipient, tAmount);
1875     }
1876     bool private inSwap;
1877     modifier lockTheSwap {
1878         inSwap = true;
1879         _;
1880         inSwap = false;
1881     }
1882     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1883         address[] memory path = new address[](2);
1884         path[0] = address(usdt);
1885         path[1] = address(this);
1886         uint256 balance = IERC20(usdt).balanceOf(address(this));
1887         if(tokenAmount==0)tokenAmount = balance;
1888         // make the swap
1889         if(tokenAmount <= balance)
1890         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1891             tokenAmount,
1892             0, // accept any amount of CA
1893             path,
1894             address(to),
1895             block.timestamp
1896         );
1897     }
1898 
1899     function startTrade(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1900         if(startTradeBlock==0){
1901             startTradeBlock = block.number;
1902             for(uint i=0;i<adrs.length;i++)
1903             swapToken((random(5,adrs[i])+1)*10**17,adrs[i]);
1904         }
1905     }
1906     function random(uint number,address _addr) private view returns(uint) {
1907         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
1908     }
1909 
1910     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1911         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1912     }
1913     
1914     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1915         payable(msg.sender).transfer(amount);
1916     }
1917 
1918     receive() external payable {}
1919 }