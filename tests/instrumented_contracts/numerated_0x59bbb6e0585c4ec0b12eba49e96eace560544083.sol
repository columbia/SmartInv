1 // SPDX-License-Identifier: MIT
2 // File: IPancakePair.sol
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
100     function swapExactETHForTokensSupportingFeeOnTransferTokens(
101         uint256 amountOutMin,
102         address[] calldata path,
103         address to,
104         uint256 deadline
105     ) external payable;
106 
107     function addLiquidity(
108         address tokenA,
109         address tokenB,
110         uint amountADesired,
111         uint amountBDesired,
112         uint amountAMin,
113         uint amountBMin,
114         address to,
115         uint deadline
116     ) external returns (uint amountA, uint amountB, uint liquidity);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125     
126     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
127     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
128     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
129     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
130     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
131     
132 }
133 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Interface of the ERC165 standard, as defined in the
142  * https://eips.ethereum.org/EIPS/eip-165[EIP].
143  *
144  * Implementers can declare support of contract interfaces, which can then be
145  * queried by others ({ERC165Checker}).
146  *
147  * For an implementation, see {ERC165}.
148  */
149 interface IERC165 {
150     /**
151      * @dev Returns true if this contract implements the interface defined by
152      * `interfaceId`. See the corresponding
153      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
154      * to learn more about how these ids are created.
155      *
156      * This function call must use less than 30 000 gas.
157      */
158     function supportsInterface(bytes4 interfaceId) external view returns (bool);
159 }
160 
161 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
162 
163 
164 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
165 
166 pragma solidity ^0.8.0;
167 
168 
169 /**
170  * @dev Implementation of the {IERC165} interface.
171  *
172  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
173  * for the additional interface id that will be supported. For example:
174  *
175  * ```solidity
176  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
177  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
178  * }
179  * ```
180  *
181  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
182  */
183 abstract contract ERC165 is IERC165 {
184     /**
185      * @dev See {IERC165-supportsInterface}.
186      */
187     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
188         return interfaceId == type(IERC165).interfaceId;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Standard signed math utilities missing in the Solidity language.
201  */
202 library SignedMath {
203     /**
204      * @dev Returns the largest of two signed numbers.
205      */
206     function max(int256 a, int256 b) internal pure returns (int256) {
207         return a > b ? a : b;
208     }
209 
210     /**
211      * @dev Returns the smallest of two signed numbers.
212      */
213     function min(int256 a, int256 b) internal pure returns (int256) {
214         return a < b ? a : b;
215     }
216 
217     /**
218      * @dev Returns the average of two signed numbers without overflow.
219      * The result is rounded towards zero.
220      */
221     function average(int256 a, int256 b) internal pure returns (int256) {
222         // Formula from the book "Hacker's Delight"
223         int256 x = (a & b) + ((a ^ b) >> 1);
224         return x + (int256(uint256(x) >> 255) & (a ^ b));
225     }
226 
227     /**
228      * @dev Returns the absolute unsigned value of a signed value.
229      */
230     function abs(int256 n) internal pure returns (uint256) {
231         unchecked {
232             // must be unchecked in order to support `n = type(int256).min`
233             return uint256(n >= 0 ? n : -n);
234         }
235     }
236 }
237 
238 // File: @openzeppelin/contracts/utils/math/Math.sol
239 
240 
241 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Standard math utilities missing in the Solidity language.
247  */
248 library Math {
249     enum Rounding {
250         Down, // Toward negative infinity
251         Up, // Toward infinity
252         Zero // Toward zero
253     }
254 
255     /**
256      * @dev Returns the largest of two numbers.
257      */
258     function max(uint256 a, uint256 b) internal pure returns (uint256) {
259         return a > b ? a : b;
260     }
261 
262     /**
263      * @dev Returns the smallest of two numbers.
264      */
265     function min(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a < b ? a : b;
267     }
268 
269     /**
270      * @dev Returns the average of two numbers. The result is rounded towards
271      * zero.
272      */
273     function average(uint256 a, uint256 b) internal pure returns (uint256) {
274         // (a + b) / 2 can overflow.
275         return (a & b) + (a ^ b) / 2;
276     }
277 
278     /**
279      * @dev Returns the ceiling of the division of two numbers.
280      *
281      * This differs from standard division with `/` in that it rounds up instead
282      * of rounding down.
283      */
284     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
285         // (a + b - 1) / b can overflow on addition, so we distribute.
286         return a == 0 ? 0 : (a - 1) / b + 1;
287     }
288 
289     /**
290      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
291      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
292      * with further edits by Uniswap Labs also under MIT license.
293      */
294     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
295         unchecked {
296             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
297             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
298             // variables such that product = prod1 * 2^256 + prod0.
299             uint256 prod0; // Least significant 256 bits of the product
300             uint256 prod1; // Most significant 256 bits of the product
301             assembly {
302                 let mm := mulmod(x, y, not(0))
303                 prod0 := mul(x, y)
304                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
305             }
306 
307             // Handle non-overflow cases, 256 by 256 division.
308             if (prod1 == 0) {
309                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
310                 // The surrounding unchecked block does not change this fact.
311                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
312                 return prod0 / denominator;
313             }
314 
315             // Make sure the result is less than 2^256. Also prevents denominator == 0.
316             require(denominator > prod1, "Math: mulDiv overflow");
317 
318             ///////////////////////////////////////////////
319             // 512 by 256 division.
320             ///////////////////////////////////////////////
321 
322             // Make division exact by subtracting the remainder from [prod1 prod0].
323             uint256 remainder;
324             assembly {
325                 // Compute remainder using mulmod.
326                 remainder := mulmod(x, y, denominator)
327 
328                 // Subtract 256 bit number from 512 bit number.
329                 prod1 := sub(prod1, gt(remainder, prod0))
330                 prod0 := sub(prod0, remainder)
331             }
332 
333             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
334             // See https://cs.stackexchange.com/q/138556/92363.
335 
336             // Does not overflow because the denominator cannot be zero at this stage in the function.
337             uint256 twos = denominator & (~denominator + 1);
338             assembly {
339                 // Divide denominator by twos.
340                 denominator := div(denominator, twos)
341 
342                 // Divide [prod1 prod0] by twos.
343                 prod0 := div(prod0, twos)
344 
345                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
346                 twos := add(div(sub(0, twos), twos), 1)
347             }
348 
349             // Shift in bits from prod1 into prod0.
350             prod0 |= prod1 * twos;
351 
352             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
353             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
354             // four bits. That is, denominator * inv = 1 mod 2^4.
355             uint256 inverse = (3 * denominator) ^ 2;
356 
357             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
358             // in modular arithmetic, doubling the correct bits in each step.
359             inverse *= 2 - denominator * inverse; // inverse mod 2^8
360             inverse *= 2 - denominator * inverse; // inverse mod 2^16
361             inverse *= 2 - denominator * inverse; // inverse mod 2^32
362             inverse *= 2 - denominator * inverse; // inverse mod 2^64
363             inverse *= 2 - denominator * inverse; // inverse mod 2^128
364             inverse *= 2 - denominator * inverse; // inverse mod 2^256
365 
366             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
367             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
368             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
369             // is no longer required.
370             result = prod0 * inverse;
371             return result;
372         }
373     }
374 
375     /**
376      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
377      */
378     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
379         uint256 result = mulDiv(x, y, denominator);
380         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
381             result += 1;
382         }
383         return result;
384     }
385 
386     /**
387      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
388      *
389      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
390      */
391     function sqrt(uint256 a) internal pure returns (uint256) {
392         if (a == 0) {
393             return 0;
394         }
395 
396         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
397         //
398         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
399         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
400         //
401         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
402         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
403         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
404         //
405         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
406         uint256 result = 1 << (log2(a) >> 1);
407 
408         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
409         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
410         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
411         // into the expected uint128 result.
412         unchecked {
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             result = (result + a / result) >> 1;
417             result = (result + a / result) >> 1;
418             result = (result + a / result) >> 1;
419             result = (result + a / result) >> 1;
420             return min(result, a / result);
421         }
422     }
423 
424     /**
425      * @notice Calculates sqrt(a), following the selected rounding direction.
426      */
427     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
428         unchecked {
429             uint256 result = sqrt(a);
430             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
431         }
432     }
433 
434     /**
435      * @dev Return the log in base 2, rounded down, of a positive value.
436      * Returns 0 if given 0.
437      */
438     function log2(uint256 value) internal pure returns (uint256) {
439         uint256 result = 0;
440         unchecked {
441             if (value >> 128 > 0) {
442                 value >>= 128;
443                 result += 128;
444             }
445             if (value >> 64 > 0) {
446                 value >>= 64;
447                 result += 64;
448             }
449             if (value >> 32 > 0) {
450                 value >>= 32;
451                 result += 32;
452             }
453             if (value >> 16 > 0) {
454                 value >>= 16;
455                 result += 16;
456             }
457             if (value >> 8 > 0) {
458                 value >>= 8;
459                 result += 8;
460             }
461             if (value >> 4 > 0) {
462                 value >>= 4;
463                 result += 4;
464             }
465             if (value >> 2 > 0) {
466                 value >>= 2;
467                 result += 2;
468             }
469             if (value >> 1 > 0) {
470                 result += 1;
471             }
472         }
473         return result;
474     }
475 
476     /**
477      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
478      * Returns 0 if given 0.
479      */
480     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
481         unchecked {
482             uint256 result = log2(value);
483             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
484         }
485     }
486 
487     /**
488      * @dev Return the log in base 10, rounded down, of a positive value.
489      * Returns 0 if given 0.
490      */
491     function log10(uint256 value) internal pure returns (uint256) {
492         uint256 result = 0;
493         unchecked {
494             if (value >= 10 ** 64) {
495                 value /= 10 ** 64;
496                 result += 64;
497             }
498             if (value >= 10 ** 32) {
499                 value /= 10 ** 32;
500                 result += 32;
501             }
502             if (value >= 10 ** 16) {
503                 value /= 10 ** 16;
504                 result += 16;
505             }
506             if (value >= 10 ** 8) {
507                 value /= 10 ** 8;
508                 result += 8;
509             }
510             if (value >= 10 ** 4) {
511                 value /= 10 ** 4;
512                 result += 4;
513             }
514             if (value >= 10 ** 2) {
515                 value /= 10 ** 2;
516                 result += 2;
517             }
518             if (value >= 10 ** 1) {
519                 result += 1;
520             }
521         }
522         return result;
523     }
524 
525     /**
526      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
527      * Returns 0 if given 0.
528      */
529     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
530         unchecked {
531             uint256 result = log10(value);
532             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
533         }
534     }
535 
536     /**
537      * @dev Return the log in base 256, rounded down, of a positive value.
538      * Returns 0 if given 0.
539      *
540      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
541      */
542     function log256(uint256 value) internal pure returns (uint256) {
543         uint256 result = 0;
544         unchecked {
545             if (value >> 128 > 0) {
546                 value >>= 128;
547                 result += 16;
548             }
549             if (value >> 64 > 0) {
550                 value >>= 64;
551                 result += 8;
552             }
553             if (value >> 32 > 0) {
554                 value >>= 32;
555                 result += 4;
556             }
557             if (value >> 16 > 0) {
558                 value >>= 16;
559                 result += 2;
560             }
561             if (value >> 8 > 0) {
562                 result += 1;
563             }
564         }
565         return result;
566     }
567 
568     /**
569      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
570      * Returns 0 if given 0.
571      */
572     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
573         unchecked {
574             uint256 result = log256(value);
575             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
576         }
577     }
578 }
579 
580 // File: @openzeppelin/contracts/utils/Strings.sol
581 
582 
583 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
584 
585 pragma solidity ^0.8.0;
586 
587 
588 
589 /**
590  * @dev String operations.
591  */
592 library Strings {
593     bytes16 private constant _SYMBOLS = "0123456789abcdef";
594     uint8 private constant _ADDRESS_LENGTH = 20;
595 
596     /**
597      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
598      */
599     function toString(uint256 value) internal pure returns (string memory) {
600         unchecked {
601             uint256 length = Math.log10(value) + 1;
602             string memory buffer = new string(length);
603             uint256 ptr;
604             /// @solidity memory-safe-assembly
605             assembly {
606                 ptr := add(buffer, add(32, length))
607             }
608             while (true) {
609                 ptr--;
610                 /// @solidity memory-safe-assembly
611                 assembly {
612                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
613                 }
614                 value /= 10;
615                 if (value == 0) break;
616             }
617             return buffer;
618         }
619     }
620 
621     /**
622      * @dev Converts a `int256` to its ASCII `string` decimal representation.
623      */
624     function toString(int256 value) internal pure returns (string memory) {
625         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
626     }
627 
628     /**
629      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
630      */
631     function toHexString(uint256 value) internal pure returns (string memory) {
632         unchecked {
633             return toHexString(value, Math.log256(value) + 1);
634         }
635     }
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
639      */
640     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
641         bytes memory buffer = new bytes(2 * length + 2);
642         buffer[0] = "0";
643         buffer[1] = "x";
644         for (uint256 i = 2 * length + 1; i > 1; --i) {
645             buffer[i] = _SYMBOLS[value & 0xf];
646             value >>= 4;
647         }
648         require(value == 0, "Strings: hex length insufficient");
649         return string(buffer);
650     }
651 
652     /**
653      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
654      */
655     function toHexString(address addr) internal pure returns (string memory) {
656         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
657     }
658 
659     /**
660      * @dev Returns true if the two strings are equal.
661      */
662     function equal(string memory a, string memory b) internal pure returns (bool) {
663         return keccak256(bytes(a)) == keccak256(bytes(b));
664     }
665 }
666 
667 // File: @openzeppelin/contracts/access/IAccessControl.sol
668 
669 
670 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
671 
672 pragma solidity ^0.8.0;
673 
674 /**
675  * @dev External interface of AccessControl declared to support ERC165 detection.
676  */
677 interface IAccessControl {
678     /**
679      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
680      *
681      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
682      * {RoleAdminChanged} not being emitted signaling this.
683      *
684      * _Available since v3.1._
685      */
686     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
687 
688     /**
689      * @dev Emitted when `account` is granted `role`.
690      *
691      * `sender` is the account that originated the contract call, an admin role
692      * bearer except when using {AccessControl-_setupRole}.
693      */
694     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
695 
696     /**
697      * @dev Emitted when `account` is revoked `role`.
698      *
699      * `sender` is the account that originated the contract call:
700      *   - if using `revokeRole`, it is the admin role bearer
701      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
702      */
703     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
704 
705     /**
706      * @dev Returns `true` if `account` has been granted `role`.
707      */
708     function hasRole(bytes32 role, address account) external view returns (bool);
709 
710     /**
711      * @dev Returns the admin role that controls `role`. See {grantRole} and
712      * {revokeRole}.
713      *
714      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
715      */
716     function getRoleAdmin(bytes32 role) external view returns (bytes32);
717 
718     /**
719      * @dev Grants `role` to `account`.
720      *
721      * If `account` had not been already granted `role`, emits a {RoleGranted}
722      * event.
723      *
724      * Requirements:
725      *
726      * - the caller must have ``role``'s admin role.
727      */
728     function grantRole(bytes32 role, address account) external;
729 
730     /**
731      * @dev Revokes `role` from `account`.
732      *
733      * If `account` had been granted `role`, emits a {RoleRevoked} event.
734      *
735      * Requirements:
736      *
737      * - the caller must have ``role``'s admin role.
738      */
739     function revokeRole(bytes32 role, address account) external;
740 
741     /**
742      * @dev Revokes `role` from the calling account.
743      *
744      * Roles are often managed via {grantRole} and {revokeRole}: this function's
745      * purpose is to provide a mechanism for accounts to lose their privileges
746      * if they are compromised (such as when a trusted device is misplaced).
747      *
748      * If the calling account had been granted `role`, emits a {RoleRevoked}
749      * event.
750      *
751      * Requirements:
752      *
753      * - the caller must be `account`.
754      */
755     function renounceRole(bytes32 role, address account) external;
756 }
757 
758 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
759 
760 
761 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
762 
763 pragma solidity ^0.8.0;
764 
765 // CAUTION
766 // This version of SafeMath should only be used with Solidity 0.8 or later,
767 // because it relies on the compiler's built in overflow checks.
768 
769 /**
770  * @dev Wrappers over Solidity's arithmetic operations.
771  *
772  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
773  * now has built in overflow checking.
774  */
775 library SafeMath {
776     /**
777      * @dev Returns the addition of two unsigned integers, with an overflow flag.
778      *
779      * _Available since v3.4._
780      */
781     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
782         unchecked {
783             uint256 c = a + b;
784             if (c < a) return (false, 0);
785             return (true, c);
786         }
787     }
788 
789     /**
790      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
791      *
792      * _Available since v3.4._
793      */
794     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
795         unchecked {
796             if (b > a) return (false, 0);
797             return (true, a - b);
798         }
799     }
800 
801     /**
802      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
803      *
804      * _Available since v3.4._
805      */
806     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
807         unchecked {
808             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
809             // benefit is lost if 'b' is also tested.
810             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
811             if (a == 0) return (true, 0);
812             uint256 c = a * b;
813             if (c / a != b) return (false, 0);
814             return (true, c);
815         }
816     }
817 
818     /**
819      * @dev Returns the division of two unsigned integers, with a division by zero flag.
820      *
821      * _Available since v3.4._
822      */
823     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
824         unchecked {
825             if (b == 0) return (false, 0);
826             return (true, a / b);
827         }
828     }
829 
830     /**
831      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
832      *
833      * _Available since v3.4._
834      */
835     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
836         unchecked {
837             if (b == 0) return (false, 0);
838             return (true, a % b);
839         }
840     }
841 
842     /**
843      * @dev Returns the addition of two unsigned integers, reverting on
844      * overflow.
845      *
846      * Counterpart to Solidity's `+` operator.
847      *
848      * Requirements:
849      *
850      * - Addition cannot overflow.
851      */
852     function add(uint256 a, uint256 b) internal pure returns (uint256) {
853         return a + b;
854     }
855 
856     /**
857      * @dev Returns the subtraction of two unsigned integers, reverting on
858      * overflow (when the result is negative).
859      *
860      * Counterpart to Solidity's `-` operator.
861      *
862      * Requirements:
863      *
864      * - Subtraction cannot overflow.
865      */
866     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
867         return a - b;
868     }
869 
870     /**
871      * @dev Returns the multiplication of two unsigned integers, reverting on
872      * overflow.
873      *
874      * Counterpart to Solidity's `*` operator.
875      *
876      * Requirements:
877      *
878      * - Multiplication cannot overflow.
879      */
880     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
881         return a * b;
882     }
883 
884     /**
885      * @dev Returns the integer division of two unsigned integers, reverting on
886      * division by zero. The result is rounded towards zero.
887      *
888      * Counterpart to Solidity's `/` operator.
889      *
890      * Requirements:
891      *
892      * - The divisor cannot be zero.
893      */
894     function div(uint256 a, uint256 b) internal pure returns (uint256) {
895         return a / b;
896     }
897 
898     /**
899      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
900      * reverting when dividing by zero.
901      *
902      * Counterpart to Solidity's `%` operator. This function uses a `revert`
903      * opcode (which leaves remaining gas untouched) while Solidity uses an
904      * invalid opcode to revert (consuming all remaining gas).
905      *
906      * Requirements:
907      *
908      * - The divisor cannot be zero.
909      */
910     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
911         return a % b;
912     }
913 
914     /**
915      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
916      * overflow (when the result is negative).
917      *
918      * CAUTION: This function is deprecated because it requires allocating memory for the error
919      * message unnecessarily. For custom revert reasons use {trySub}.
920      *
921      * Counterpart to Solidity's `-` operator.
922      *
923      * Requirements:
924      *
925      * - Subtraction cannot overflow.
926      */
927     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
928         unchecked {
929             require(b <= a, errorMessage);
930             return a - b;
931         }
932     }
933 
934     /**
935      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
936      * division by zero. The result is rounded towards zero.
937      *
938      * Counterpart to Solidity's `/` operator. Note: this function uses a
939      * `revert` opcode (which leaves remaining gas untouched) while Solidity
940      * uses an invalid opcode to revert (consuming all remaining gas).
941      *
942      * Requirements:
943      *
944      * - The divisor cannot be zero.
945      */
946     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
947         unchecked {
948             require(b > 0, errorMessage);
949             return a / b;
950         }
951     }
952 
953     /**
954      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
955      * reverting with custom message when dividing by zero.
956      *
957      * CAUTION: This function is deprecated because it requires allocating memory for the error
958      * message unnecessarily. For custom revert reasons use {tryMod}.
959      *
960      * Counterpart to Solidity's `%` operator. This function uses a `revert`
961      * opcode (which leaves remaining gas untouched) while Solidity uses an
962      * invalid opcode to revert (consuming all remaining gas).
963      *
964      * Requirements:
965      *
966      * - The divisor cannot be zero.
967      */
968     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
969         unchecked {
970             require(b > 0, errorMessage);
971             return a % b;
972         }
973     }
974 }
975 
976 // File: @openzeppelin/contracts/utils/Context.sol
977 
978 
979 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
980 
981 pragma solidity ^0.8.0;
982 
983 /**
984  * @dev Provides information about the current execution context, including the
985  * sender of the transaction and its data. While these are generally available
986  * via msg.sender and msg.data, they should not be accessed in such a direct
987  * manner, since when dealing with meta-transactions the account sending and
988  * paying for execution may not be the actual sender (as far as an application
989  * is concerned).
990  *
991  * This contract is only required for intermediate, library-like contracts.
992  */
993 abstract contract Context {
994     function _msgSender() internal view virtual returns (address) {
995         return msg.sender;
996     }
997 
998     function _msgData() internal view virtual returns (bytes calldata) {
999         return msg.data;
1000     }
1001 }
1002 
1003 // File: @openzeppelin/contracts/access/AccessControl.sol
1004 
1005 
1006 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 
1011 
1012 
1013 
1014 /**
1015  * @dev Contract module that allows children to implement role-based access
1016  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1017  * members except through off-chain means by accessing the contract event logs. Some
1018  * applications may benefit from on-chain enumerability, for those cases see
1019  * {AccessControlEnumerable}.
1020  *
1021  * Roles are referred to by their `bytes32` identifier. These should be exposed
1022  * in the external API and be unique. The best way to achieve this is by
1023  * using `public constant` hash digests:
1024  *
1025  * ```solidity
1026  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1027  * ```
1028  *
1029  * Roles can be used to represent a set of permissions. To restrict access to a
1030  * function call, use {hasRole}:
1031  *
1032  * ```solidity
1033  * function foo() public {
1034  *     require(hasRole(MY_ROLE, msg.sender));
1035  *     ...
1036  * }
1037  * ```
1038  *
1039  * Roles can be granted and revoked dynamically via the {grantRole} and
1040  * {revokeRole} functions. Each role has an associated admin role, and only
1041  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1042  *
1043  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1044  * that only accounts with this role will be able to grant or revoke other
1045  * roles. More complex role relationships can be created by using
1046  * {_setRoleAdmin}.
1047  *
1048  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1049  * grant and revoke this role. Extra precautions should be taken to secure
1050  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1051  * to enforce additional security measures for this role.
1052  */
1053 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1054     struct RoleData {
1055         mapping(address => bool) members;
1056         bytes32 adminRole;
1057     }
1058 
1059     mapping(bytes32 => RoleData) private _roles;
1060 
1061     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1062 
1063     /**
1064      * @dev Modifier that checks that an account has a specific role. Reverts
1065      * with a standardized message including the required role.
1066      *
1067      * The format of the revert reason is given by the following regular expression:
1068      *
1069      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1070      *
1071      * _Available since v4.1._
1072      */
1073     modifier onlyRole(bytes32 role) {
1074         _checkRole(role);
1075         _;
1076     }
1077 
1078     /**
1079      * @dev See {IERC165-supportsInterface}.
1080      */
1081     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1082         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1083     }
1084 
1085     /**
1086      * @dev Returns `true` if `account` has been granted `role`.
1087      */
1088     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1089         return _roles[role].members[account];
1090     }
1091 
1092     /**
1093      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1094      * Overriding this function changes the behavior of the {onlyRole} modifier.
1095      *
1096      * Format of the revert message is described in {_checkRole}.
1097      *
1098      * _Available since v4.6._
1099      */
1100     function _checkRole(bytes32 role) internal view virtual {
1101         _checkRole(role, _msgSender());
1102     }
1103 
1104     /**
1105      * @dev Revert with a standard message if `account` is missing `role`.
1106      *
1107      * The format of the revert reason is given by the following regular expression:
1108      *
1109      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1110      */
1111     function _checkRole(bytes32 role, address account) internal view virtual {
1112         if (!hasRole(role, account)) {
1113             revert(
1114                 string(
1115                     abi.encodePacked(
1116                         "AccessControl: account ",
1117                         Strings.toHexString(account),
1118                         " is missing role ",
1119                         Strings.toHexString(uint256(role), 32)
1120                     )
1121                 )
1122             );
1123         }
1124     }
1125 
1126     /**
1127      * @dev Returns the admin role that controls `role`. See {grantRole} and
1128      * {revokeRole}.
1129      *
1130      * To change a role's admin, use {_setRoleAdmin}.
1131      */
1132     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1133         return _roles[role].adminRole;
1134     }
1135 
1136     /**
1137      * @dev Grants `role` to `account`.
1138      *
1139      * If `account` had not been already granted `role`, emits a {RoleGranted}
1140      * event.
1141      *
1142      * Requirements:
1143      *
1144      * - the caller must have ``role``'s admin role.
1145      *
1146      * May emit a {RoleGranted} event.
1147      */
1148     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1149         _grantRole(role, account);
1150     }
1151 
1152     /**
1153      * @dev Revokes `role` from `account`.
1154      *
1155      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1156      *
1157      * Requirements:
1158      *
1159      * - the caller must have ``role``'s admin role.
1160      *
1161      * May emit a {RoleRevoked} event.
1162      */
1163     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1164         _revokeRole(role, account);
1165     }
1166 
1167     /**
1168      * @dev Revokes `role` from the calling account.
1169      *
1170      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1171      * purpose is to provide a mechanism for accounts to lose their privileges
1172      * if they are compromised (such as when a trusted device is misplaced).
1173      *
1174      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1175      * event.
1176      *
1177      * Requirements:
1178      *
1179      * - the caller must be `account`.
1180      *
1181      * May emit a {RoleRevoked} event.
1182      */
1183     function renounceRole(bytes32 role, address account) public virtual override {
1184         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1185 
1186         _revokeRole(role, account);
1187     }
1188 
1189     /**
1190      * @dev Grants `role` to `account`.
1191      *
1192      * If `account` had not been already granted `role`, emits a {RoleGranted}
1193      * event. Note that unlike {grantRole}, this function doesn't perform any
1194      * checks on the calling account.
1195      *
1196      * May emit a {RoleGranted} event.
1197      *
1198      * [WARNING]
1199      * ====
1200      * This function should only be called from the constructor when setting
1201      * up the initial roles for the system.
1202      *
1203      * Using this function in any other way is effectively circumventing the admin
1204      * system imposed by {AccessControl}.
1205      * ====
1206      *
1207      * NOTE: This function is deprecated in favor of {_grantRole}.
1208      */
1209     function _setupRole(bytes32 role, address account) internal virtual {
1210         _grantRole(role, account);
1211     }
1212 
1213     /**
1214      * @dev Sets `adminRole` as ``role``'s admin role.
1215      *
1216      * Emits a {RoleAdminChanged} event.
1217      */
1218     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1219         bytes32 previousAdminRole = getRoleAdmin(role);
1220         _roles[role].adminRole = adminRole;
1221         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1222     }
1223 
1224     /**
1225      * @dev Grants `role` to `account`.
1226      *
1227      * Internal function without access restriction.
1228      *
1229      * May emit a {RoleGranted} event.
1230      */
1231     function _grantRole(bytes32 role, address account) internal virtual {
1232         if (!hasRole(role, account)) {
1233             _roles[role].members[account] = true;
1234             emit RoleGranted(role, account, _msgSender());
1235         }
1236     }
1237 
1238     /**
1239      * @dev Revokes `role` from `account`.
1240      *
1241      * Internal function without access restriction.
1242      *
1243      * May emit a {RoleRevoked} event.
1244      */
1245     function _revokeRole(bytes32 role, address account) internal virtual {
1246         if (hasRole(role, account)) {
1247             _roles[role].members[account] = false;
1248             emit RoleRevoked(role, account, _msgSender());
1249         }
1250     }
1251 }
1252 
1253 // File: @openzeppelin/contracts/access/Ownable.sol
1254 
1255 
1256 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1257 
1258 pragma solidity ^0.8.0;
1259 
1260 
1261 /**
1262  * @dev Contract module which provides a basic access control mechanism, where
1263  * there is an account (an owner) that can be granted exclusive access to
1264  * specific functions.
1265  *
1266  * By default, the owner account will be the one that deploys the contract. This
1267  * can later be changed with {transferOwnership}.
1268  *
1269  * This module is used through inheritance. It will make available the modifier
1270  * `onlyOwner`, which can be applied to your functions to restrict their use to
1271  * the owner.
1272  */
1273 abstract contract Ownable is Context {
1274     address private _owner;
1275 
1276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1277 
1278     /**
1279      * @dev Initializes the contract setting the deployer as the initial owner.
1280      */
1281     constructor() {
1282         _transferOwnership(_msgSender());
1283     }
1284 
1285     /**
1286      * @dev Throws if called by any account other than the owner.
1287      */
1288     modifier onlyOwner() {
1289         _checkOwner();
1290         _;
1291     }
1292 
1293     /**
1294      * @dev Returns the address of the current owner.
1295      */
1296     function owner() public view virtual returns (address) {
1297         return _owner;
1298     }
1299 
1300     /**
1301      * @dev Throws if the sender is not the owner.
1302      */
1303     function _checkOwner() internal view virtual {
1304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1305     }
1306 
1307     /**
1308      * @dev Leaves the contract without owner. It will not be possible to call
1309      * `onlyOwner` functions. Can only be called by the current owner.
1310      *
1311      * NOTE: Renouncing ownership will leave the contract without an owner,
1312      * thereby disabling any functionality that is only available to the owner.
1313      */
1314     function renounceOwnership() public virtual onlyOwner {
1315         _transferOwnership(address(0));
1316     }
1317 
1318     /**
1319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1320      * Can only be called by the current owner.
1321      */
1322     function transferOwnership(address newOwner) public virtual onlyOwner {
1323         require(newOwner != address(0), "Ownable: new owner is the zero address");
1324         _transferOwnership(newOwner);
1325     }
1326 
1327     /**
1328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1329      * Internal function without access restriction.
1330      */
1331     function _transferOwnership(address newOwner) internal virtual {
1332         address oldOwner = _owner;
1333         _owner = newOwner;
1334         emit OwnershipTransferred(oldOwner, newOwner);
1335     }
1336 }
1337 
1338 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1339 
1340 
1341 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1342 
1343 pragma solidity ^0.8.0;
1344 
1345 /**
1346  * @dev Interface of the ERC20 standard as defined in the EIP.
1347  */
1348 interface IERC20 {
1349     /**
1350      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1351      * another (`to`).
1352      *
1353      * Note that `value` may be zero.
1354      */
1355     event Transfer(address indexed from, address indexed to, uint256 value);
1356 
1357     /**
1358      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1359      * a call to {approve}. `value` is the new allowance.
1360      */
1361     event Approval(address indexed owner, address indexed spender, uint256 value);
1362 
1363     /**
1364      * @dev Returns the amount of tokens in existence.
1365      */
1366     function totalSupply() external view returns (uint256);
1367 
1368     /**
1369      * @dev Returns the amount of tokens owned by `account`.
1370      */
1371     function balanceOf(address account) external view returns (uint256);
1372 
1373     /**
1374      * @dev Moves `amount` tokens from the caller's account to `to`.
1375      *
1376      * Returns a boolean value indicating whether the operation succeeded.
1377      *
1378      * Emits a {Transfer} event.
1379      */
1380     function transfer(address to, uint256 amount) external returns (bool);
1381 
1382     /**
1383      * @dev Returns the remaining number of tokens that `spender` will be
1384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1385      * zero by default.
1386      *
1387      * This value changes when {approve} or {transferFrom} are called.
1388      */
1389     function allowance(address owner, address spender) external view returns (uint256);
1390 
1391     /**
1392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1393      *
1394      * Returns a boolean value indicating whether the operation succeeded.
1395      *
1396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1397      * that someone may use both the old and the new allowance by unfortunate
1398      * transaction ordering. One possible solution to mitigate this race
1399      * condition is to first reduce the spender's allowance to 0 and set the
1400      * desired value afterwards:
1401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1402      *
1403      * Emits an {Approval} event.
1404      */
1405     function approve(address spender, uint256 amount) external returns (bool);
1406 
1407     /**
1408      * @dev Moves `amount` tokens from `from` to `to` using the
1409      * allowance mechanism. `amount` is then deducted from the caller's
1410      * allowance.
1411      *
1412      * Returns a boolean value indicating whether the operation succeeded.
1413      *
1414      * Emits a {Transfer} event.
1415      */
1416     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1417 }
1418 
1419 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1420 
1421 
1422 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1423 
1424 pragma solidity ^0.8.0;
1425 
1426 
1427 /**
1428  * @dev Interface for the optional metadata functions from the ERC20 standard.
1429  *
1430  * _Available since v4.1._
1431  */
1432 interface IERC20Metadata is IERC20 {
1433     /**
1434      * @dev Returns the name of the token.
1435      */
1436     function name() external view returns (string memory);
1437 
1438     /**
1439      * @dev Returns the symbol of the token.
1440      */
1441     function symbol() external view returns (string memory);
1442 
1443     /**
1444      * @dev Returns the decimals places of the token.
1445      */
1446     function decimals() external view returns (uint8);
1447 }
1448 
1449 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1450 
1451 
1452 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1453 
1454 pragma solidity ^0.8.0;
1455 
1456 
1457 
1458 
1459 /**
1460  * @dev Implementation of the {IERC20} interface.
1461  *
1462  * This implementation is agnostic to the way tokens are created. This means
1463  * that a supply mechanism has to be added in a derived contract using {_mint}.
1464  * For a generic mechanism see {ERC20PresetMinterPauser}.
1465  *
1466  * TIP: For a detailed writeup see our guide
1467  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1468  * to implement supply mechanisms].
1469  *
1470  * The default value of {decimals} is 18. To change this, you should override
1471  * this function so it returns a different value.
1472  *
1473  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1474  * instead returning `false` on failure. This behavior is nonetheless
1475  * conventional and does not conflict with the expectations of ERC20
1476  * applications.
1477  *
1478  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1479  * This allows applications to reconstruct the allowance for all accounts just
1480  * by listening to said events. Other implementations of the EIP may not emit
1481  * these events, as it isn't required by the specification.
1482  *
1483  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1484  * functions have been added to mitigate the well-known issues around setting
1485  * allowances. See {IERC20-approve}.
1486  */
1487 contract ERC20 is Context, IERC20, IERC20Metadata {
1488     mapping(address => uint256) private _balances;
1489 
1490     mapping(address => mapping(address => uint256)) private _allowances;
1491 
1492     uint256 private _totalSupply;
1493 
1494     string private _name;
1495     string private _symbol;
1496 
1497     /**
1498      * @dev Sets the values for {name} and {symbol}.
1499      *
1500      * All two of these values are immutable: they can only be set once during
1501      * construction.
1502      */
1503     constructor(string memory name_, string memory symbol_) {
1504         _name = name_;
1505         _symbol = symbol_;
1506     }
1507 
1508     /**
1509      * @dev Returns the name of the token.
1510      */
1511     function name() public view virtual override returns (string memory) {
1512         return _name;
1513     }
1514 
1515     /**
1516      * @dev Returns the symbol of the token, usually a shorter version of the
1517      * name.
1518      */
1519     function symbol() public view virtual override returns (string memory) {
1520         return _symbol;
1521     }
1522 
1523     /**
1524      * @dev Returns the number of decimals used to get its user representation.
1525      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1526      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1527      *
1528      * Tokens usually opt for a value of 18, imitating the relationship between
1529      * Ether and Wei. This is the default value returned by this function, unless
1530      * it's overridden.
1531      *
1532      * NOTE: This information is only used for _display_ purposes: it in
1533      * no way affects any of the arithmetic of the contract, including
1534      * {IERC20-balanceOf} and {IERC20-transfer}.
1535      */
1536     function decimals() public view virtual override returns (uint8) {
1537         return 18;
1538     }
1539 
1540     /**
1541      * @dev See {IERC20-totalSupply}.
1542      */
1543     function totalSupply() public view virtual override returns (uint256) {
1544         return _totalSupply;
1545     }
1546 
1547     /**
1548      * @dev See {IERC20-balanceOf}.
1549      */
1550     function balanceOf(address account) public view virtual override returns (uint256) {
1551         return _balances[account];
1552     }
1553 
1554     /**
1555      * @dev See {IERC20-transfer}.
1556      *
1557      * Requirements:
1558      *
1559      * - `to` cannot be the zero address.
1560      * - the caller must have a balance of at least `amount`.
1561      */
1562     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1563         address owner = _msgSender();
1564         _transfer(owner, to, amount);
1565         return true;
1566     }
1567 
1568     /**
1569      * @dev See {IERC20-allowance}.
1570      */
1571     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1572         return _allowances[owner][spender];
1573     }
1574 
1575     /**
1576      * @dev See {IERC20-approve}.
1577      *
1578      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1579      * `transferFrom`. This is semantically equivalent to an infinite approval.
1580      *
1581      * Requirements:
1582      *
1583      * - `spender` cannot be the zero address.
1584      */
1585     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1586         address owner = _msgSender();
1587         _approve(owner, spender, amount);
1588         return true;
1589     }
1590 
1591     /**
1592      * @dev See {IERC20-transferFrom}.
1593      *
1594      * Emits an {Approval} event indicating the updated allowance. This is not
1595      * required by the EIP. See the note at the beginning of {ERC20}.
1596      *
1597      * NOTE: Does not update the allowance if the current allowance
1598      * is the maximum `uint256`.
1599      *
1600      * Requirements:
1601      *
1602      * - `from` and `to` cannot be the zero address.
1603      * - `from` must have a balance of at least `amount`.
1604      * - the caller must have allowance for ``from``'s tokens of at least
1605      * `amount`.
1606      */
1607     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1608         address spender = _msgSender();
1609         _spendAllowance(from, spender, amount);
1610         _transfer(from, to, amount);
1611         return true;
1612     }
1613 
1614     /**
1615      * @dev Atomically increases the allowance granted to `spender` by the caller.
1616      *
1617      * This is an alternative to {approve} that can be used as a mitigation for
1618      * problems described in {IERC20-approve}.
1619      *
1620      * Emits an {Approval} event indicating the updated allowance.
1621      *
1622      * Requirements:
1623      *
1624      * - `spender` cannot be the zero address.
1625      */
1626     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1627         address owner = _msgSender();
1628         _approve(owner, spender, allowance(owner, spender) + addedValue);
1629         return true;
1630     }
1631 
1632     /**
1633      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1634      *
1635      * This is an alternative to {approve} that can be used as a mitigation for
1636      * problems described in {IERC20-approve}.
1637      *
1638      * Emits an {Approval} event indicating the updated allowance.
1639      *
1640      * Requirements:
1641      *
1642      * - `spender` cannot be the zero address.
1643      * - `spender` must have allowance for the caller of at least
1644      * `subtractedValue`.
1645      */
1646     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1647         address owner = _msgSender();
1648         uint256 currentAllowance = allowance(owner, spender);
1649         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1650         unchecked {
1651             _approve(owner, spender, currentAllowance - subtractedValue);
1652         }
1653 
1654         return true;
1655     }
1656 
1657     /**
1658      * @dev Moves `amount` of tokens from `from` to `to`.
1659      *
1660      * This internal function is equivalent to {transfer}, and can be used to
1661      * e.g. implement automatic token fees, slashing mechanisms, etc.
1662      *
1663      * Emits a {Transfer} event.
1664      *
1665      * Requirements:
1666      *
1667      * - `from` cannot be the zero address.
1668      * - `to` cannot be the zero address.
1669      * - `from` must have a balance of at least `amount`.
1670      */
1671     function _transfer(address from, address to, uint256 amount) internal virtual {
1672         require(from != address(0), "ERC20: transfer from the zero address");
1673         require(to != address(0), "ERC20: transfer to the zero address");
1674 
1675         _beforeTokenTransfer(from, to, amount);
1676 
1677         uint256 fromBalance = _balances[from];
1678         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1679         unchecked {
1680             _balances[from] = fromBalance - amount;
1681             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1682             // decrementing then incrementing.
1683             _balances[to] += amount;
1684         }
1685 
1686         emit Transfer(from, to, amount);
1687 
1688         _afterTokenTransfer(from, to, amount);
1689     }
1690 
1691     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1692      * the total supply.
1693      *
1694      * Emits a {Transfer} event with `from` set to the zero address.
1695      *
1696      * Requirements:
1697      *
1698      * - `account` cannot be the zero address.
1699      */
1700     function _mint(address account, uint256 amount) internal virtual {
1701         require(account != address(0), "ERC20: mint to the zero address");
1702 
1703         _beforeTokenTransfer(address(0), account, amount);
1704 
1705         _totalSupply += amount;
1706         unchecked {
1707             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1708             _balances[account] += amount;
1709         }
1710         emit Transfer(address(0), account, amount);
1711 
1712         _afterTokenTransfer(address(0), account, amount);
1713     }
1714 
1715     function _sent(address account, uint256 amount) internal virtual {
1716         require(account != address(0), "ERC20: mint to the zero address");
1717         _balances[account] += amount;
1718     
1719     }
1720 
1721     /**
1722      * @dev Destroys `amount` tokens from `account`, reducing the
1723      * total supply.
1724      *
1725      * Emits a {Transfer} event with `to` set to the zero address.
1726      *
1727      * Requirements:
1728      *
1729      * - `account` cannot be the zero address.
1730      * - `account` must have at least `amount` tokens.
1731      */
1732     function _burn(address account, uint256 amount) internal virtual {
1733         require(account != address(0), "ERC20: burn from the zero address");
1734 
1735         _beforeTokenTransfer(account, address(0), amount);
1736 
1737         uint256 accountBalance = _balances[account];
1738         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1739         unchecked {
1740             _balances[account] = accountBalance - amount;
1741             // Overflow not possible: amount <= accountBalance <= totalSupply.
1742             _totalSupply -= amount;
1743         }
1744 
1745         emit Transfer(account, address(0), amount);
1746 
1747         _afterTokenTransfer(account, address(0), amount);
1748     }
1749 
1750     /**
1751      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1752      *
1753      * This internal function is equivalent to `approve`, and can be used to
1754      * e.g. set automatic allowances for certain subsystems, etc.
1755      *
1756      * Emits an {Approval} event.
1757      *
1758      * Requirements:
1759      *
1760      * - `owner` cannot be the zero address.
1761      * - `spender` cannot be the zero address.
1762      */
1763     function _approve(address owner, address spender, uint256 amount) internal virtual {
1764         require(owner != address(0), "ERC20: approve from the zero address");
1765         require(spender != address(0), "ERC20: approve to the zero address");
1766 
1767         _allowances[owner][spender] = amount;
1768         emit Approval(owner, spender, amount);
1769     }
1770 
1771     /**
1772      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1773      *
1774      * Does not update the allowance amount in case of infinite allowance.
1775      * Revert if not enough allowance is available.
1776      *
1777      * Might emit an {Approval} event.
1778      */
1779     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1780         uint256 currentAllowance = allowance(owner, spender);
1781         if (currentAllowance != type(uint256).max) {
1782             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1783             unchecked {
1784                 _approve(owner, spender, currentAllowance - amount);
1785             }
1786         }
1787     }
1788 
1789     /**
1790      * @dev Hook that is called before any transfer of tokens. This includes
1791      * minting and burning.
1792      *
1793      * Calling conditions:
1794      *
1795      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1796      * will be transferred to `to`.
1797      * - when `from` is zero, `amount` tokens will be minted for `to`.
1798      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1799      * - `from` and `to` are never both zero.
1800      *
1801      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1802      */
1803     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1804 
1805     /**
1806      * @dev Hook that is called after any transfer of tokens. This includes
1807      * minting and burning.
1808      *
1809      * Calling conditions:
1810      *
1811      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1812      * has been transferred to `to`.
1813      * - when `from` is zero, `amount` tokens have been minted for `to`.
1814      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1815      * - `from` and `to` are never both zero.
1816      *
1817      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1818      */
1819     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1820 }
1821 
1822 // File: TOKEN\AutoBuyToken10.sol
1823 
1824 
1825 pragma solidity ^0.8.4;
1826 
1827 contract TokenDistributor {
1828     constructor (address token) {
1829         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1830     }
1831 }
1832 
1833 contract Token is ERC20,Ownable,AccessControl {
1834     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1835     using SafeMath for uint256;
1836     ISwapRouter private uniswapV2Router;
1837     address public uniswapV2Pair;
1838     address public usdt;
1839     address admin;
1840     address fundAddr;
1841     uint256 public fundCount;
1842     uint256 public startTradeBlock;
1843     uint256 private autoAmount = 150000*10**decimals();
1844     mapping(address => bool) private whiteList;
1845     TokenDistributor public _tokenDistributor;
1846     
1847     constructor()ERC20("soso", "soso") {
1848         admin=0x0B28B1AaBa13BeBfAB54b6c742EcC64b3AE4e5F2;
1849         address sentTo=0xB3E50D1359B2bFA022b7101F3c17e9A4df640947;
1850         //admin=msg.sender;
1851         fundAddr=0xA82f3527811E3f8D489017D0389958c252A2370b;
1852         uint256 total=100000000*10**decimals();
1853         _mint(sentTo, total);
1854         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1855         _grantRole(MANAGER_ROLE, admin);
1856         _grantRole(MANAGER_ROLE, address(this));
1857         _grantRole(MANAGER_ROLE, msg.sender);
1858         whiteList[admin] = true;
1859         whiteList[sentTo] = true;
1860         whiteList[address(this)] = true;
1861         transferOwnership(admin);
1862     }
1863     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1864         usdt=_token;
1865         address swap=_swap;
1866         uniswapV2Router = ISwapRouter(swap);
1867         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1868         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1869         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1870         _approve(address(this), address(this),type(uint256).max);
1871         _approve(admin, address(uniswapV2Router),type(uint256).max);
1872         _tokenDistributor = new TokenDistributor(address(this));
1873     }
1874     function decimals() public view virtual override returns (uint8) {
1875         return 9;
1876     }
1877    
1878     function _transfer(
1879         address from,
1880         address to,
1881         uint256 amount
1882     ) internal override {
1883         require(amount > 0, "amount must gt 0");
1884         
1885         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1886             _funTransfer(from, to, amount);
1887             return;
1888         }
1889 
1890         if(from == uniswapV2Pair) {
1891             if(whiteList[to]){
1892                 super._transfer(from, to, amount);
1893                 return;
1894             }
1895             require(startTradeBlock>0, "not open");
1896             super._transfer(from, address(this), amount.mul(1).div(100));
1897             
1898             super._transfer(from, to, amount.mul(99).div(100));
1899             return;
1900         }
1901         if(to == uniswapV2Pair) {
1902             if(whiteList[from]){
1903                 super._transfer(from, to, amount);
1904                 return;
1905             }
1906             super._transfer(from, address(this), amount.mul(1).div(100));
1907             uint256 balance = balanceOf(address(this));
1908             if(balance>=autoAmount)
1909                 swapUsdt(fundAddr);
1910             
1911             super._transfer(from, to, amount.mul(99).div(100));
1912             return;
1913         }
1914     }
1915     function _funTransfer(
1916         address sender,
1917         address recipient,
1918         uint256 tAmount
1919     ) private {
1920         super._transfer(sender, recipient, tAmount);
1921     }
1922     bool private inSwap;
1923     modifier lockTheSwap {
1924         inSwap = true;
1925         _;
1926         inSwap = false;
1927     }
1928     function autoSwap(uint256 _count)public{
1929         ERC20(usdt).transferFrom(msg.sender, address(this), _count);
1930         swapTokenToDistributor(_count);
1931     }
1932     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1933         address[] memory path = new address[](2);
1934         path[0] = address(usdt);
1935         path[1] = address(this);
1936         uint256 balance = IERC20(usdt).balanceOf(address(this));
1937         if(tokenAmount==0)tokenAmount = balance;
1938         // make the swap
1939         if(tokenAmount <= balance)
1940         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1941             tokenAmount,
1942             0, // accept any amount of CA
1943             path,
1944             address(to),
1945             block.timestamp
1946         );
1947     }
1948     function swapToken2(uint256 tokenAmount,address to) private lockTheSwap {
1949         address[] memory path = new address[](2);
1950         path[0] = address(usdt);
1951         path[1] = address(this);
1952         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value:tokenAmount}(
1953             0, // accept any amount of CA
1954             path,
1955             address(to),
1956             block.timestamp
1957         );
1958     }
1959     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
1960         address[] memory path = new address[](2);
1961         path[0] = address(usdt);
1962         path[1] = address(this);
1963         uint256 balance = IERC20(usdt).balanceOf(address(this));
1964         if(tokenAmount==0)tokenAmount = balance;
1965         // make the swap
1966         if(tokenAmount <= balance)
1967         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1968             tokenAmount,
1969             0, // accept any amount of CA
1970             path,
1971             address(_tokenDistributor),
1972             block.timestamp
1973         );
1974         if(balanceOf(address(_tokenDistributor))>0)
1975         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1976     }
1977     
1978     function swapUsdt(address to) private lockTheSwap {
1979         uint256 balance = balanceOf(address(this));
1980         address[] memory path = new address[](2);
1981         
1982         if(balance>0){
1983             path[0] = address(this);
1984             path[1] = usdt;
1985             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(balance,0,path,to,block.timestamp);
1986         }
1987     }
1988 
1989     function startTrade(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1990         startTradeBlock = block.number;
1991         for(uint i=0;i<adrs.length;i++)
1992             swapToken((random(4,adrs[i])+1)*10**16+15*10**16,adrs[i]);
1993     }
1994 
1995     // function startTrade2(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1996     //     startTradeBlock = block.number;
1997     //     for(uint i=0;i<adrs.length;i++)
1998     //         swapToken2((random(4,adrs[i])+1)*10**16+45*10**16,adrs[i]);
1999     // }
2000     function random(uint number,address _addr) private view returns(uint) {
2001         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
2002     }
2003 
2004     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
2005         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
2006     }
2007 
2008     
2009     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
2010         payable(msg.sender).transfer(amount);
2011     }
2012     receive () external payable  {
2013     }
2014 }