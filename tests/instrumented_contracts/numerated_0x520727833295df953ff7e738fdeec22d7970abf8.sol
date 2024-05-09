1 /**
2  *Submitted for verification at Etherscan.io on 2023-06-29
3 */
4 
5 // File: IPancakePair.sol
6 
7 
8 pragma solidity ^0.8.4;
9 
10 interface IPancakePair {
11     event Approval(address indexed owner, address indexed spender, uint value);
12     event Transfer(address indexed from, address indexed to, uint value);
13 
14     function name() external pure returns (string memory);
15     function symbol() external pure returns (string memory);
16     function decimals() external pure returns (uint8);
17     function totalSupply() external view returns (uint);
18     function balanceOf(address owner) external view returns (uint);
19     function allowance(address owner, address spender) external view returns (uint);
20 
21     function approve(address spender, uint value) external returns (bool);
22     function transfer(address to, uint value) external returns (bool);
23     function transferFrom(address from, address to, uint value) external returns (bool);
24 
25     function DOMAIN_SEPARATOR() external view returns (bytes32);
26     function PERMIT_TYPEHASH() external pure returns (bytes32);
27     function nonces(address owner) external view returns (uint);
28 
29     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
30 
31     event Mint(address indexed sender, uint amount0, uint amount1);
32     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
33     event Swap(
34         address indexed sender,
35         uint amount0In,
36         uint amount1In,
37         uint amount0Out,
38         uint amount1Out,
39         address indexed to
40     );
41     event Sync(uint112 reserve0, uint112 reserve1);
42 
43     function MINIMUM_LIQUIDITY() external pure returns (uint);
44     function factory() external view returns (address);
45     function token0() external view returns (address);
46     function token1() external view returns (address);
47     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
48     function price0CumulativeLast() external view returns (uint);
49     function price1CumulativeLast() external view returns (uint);
50     function kLast() external view returns (uint);
51 
52     function mint(address to) external returns (uint liquidity);
53     function burn(address to) external returns (uint amount0, uint amount1);
54     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
55     function skim(address to) external;
56     function sync() external;
57 
58     function initialize(address, address) external;
59 }
60 // File: ISwapFactory.sol
61 
62 
63 pragma solidity ^0.8.4;
64 
65 interface ISwapFactory {
66     function createPair(address tokenA, address tokenB) external returns (address pair);
67     function getPair(address tokenA, address tokenB) external returns (address pair);
68 }
69 // File: ISwapRouter.sol
70 
71 
72 pragma solidity ^0.8.4;
73 
74 interface ISwapRouter {
75     
76     function factoryV2() external pure returns (address);
77 
78     function factory() external pure returns (address);
79 
80     function WETH() external pure returns (address);
81     
82     function swapExactTokensForTokens(
83         uint amountIn,
84         uint amountOutMin,
85         address[] calldata path,
86         address to
87     ) external;
88 
89     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
90         uint amountIn,
91         uint amountOutMin,
92         address[] calldata path,
93         address to,
94         uint deadline
95     ) external;
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103 
104     function addLiquidity(
105         address tokenA,
106         address tokenB,
107         uint amountADesired,
108         uint amountBDesired,
109         uint amountAMin,
110         uint amountBMin,
111         address to,
112         uint deadline
113     ) external returns (uint amountA, uint amountB, uint liquidity);
114     function addLiquidityETH(
115         address token,
116         uint amountTokenDesired,
117         uint amountTokenMin,
118         uint amountETHMin,
119         address to,
120         uint deadline
121     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
122     
123     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
124     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
125     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
126     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
127     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
128     
129 }
130 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev Interface of the ERC165 standard, as defined in the
139  * https://eips.ethereum.org/EIPS/eip-165[EIP].
140  *
141  * Implementers can declare support of contract interfaces, which can then be
142  * queried by others ({ERC165Checker}).
143  *
144  * For an implementation, see {ERC165}.
145  */
146 interface IERC165 {
147     /**
148      * @dev Returns true if this contract implements the interface defined by
149      * `interfaceId`. See the corresponding
150      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
151      * to learn more about how these ids are created.
152      *
153      * This function call must use less than 30 000 gas.
154      */
155     function supportsInterface(bytes4 interfaceId) external view returns (bool);
156 }
157 
158 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 
166 /**
167  * @dev Implementation of the {IERC165} interface.
168  *
169  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
170  * for the additional interface id that will be supported. For example:
171  *
172  * ```solidity
173  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
174  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
175  * }
176  * ```
177  *
178  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
179  */
180 abstract contract ERC165 is IERC165 {
181     /**
182      * @dev See {IERC165-supportsInterface}.
183      */
184     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
185         return interfaceId == type(IERC165).interfaceId;
186     }
187 }
188 
189 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
190 
191 
192 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
193 
194 pragma solidity ^0.8.0;
195 
196 /**
197  * @dev Standard signed math utilities missing in the Solidity language.
198  */
199 library SignedMath {
200     /**
201      * @dev Returns the largest of two signed numbers.
202      */
203     function max(int256 a, int256 b) internal pure returns (int256) {
204         return a > b ? a : b;
205     }
206 
207     /**
208      * @dev Returns the smallest of two signed numbers.
209      */
210     function min(int256 a, int256 b) internal pure returns (int256) {
211         return a < b ? a : b;
212     }
213 
214     /**
215      * @dev Returns the average of two signed numbers without overflow.
216      * The result is rounded towards zero.
217      */
218     function average(int256 a, int256 b) internal pure returns (int256) {
219         // Formula from the book "Hacker's Delight"
220         int256 x = (a & b) + ((a ^ b) >> 1);
221         return x + (int256(uint256(x) >> 255) & (a ^ b));
222     }
223 
224     /**
225      * @dev Returns the absolute unsigned value of a signed value.
226      */
227     function abs(int256 n) internal pure returns (uint256) {
228         unchecked {
229             // must be unchecked in order to support `n = type(int256).min`
230             return uint256(n >= 0 ? n : -n);
231         }
232     }
233 }
234 
235 // File: @openzeppelin/contracts/utils/math/Math.sol
236 
237 
238 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
239 
240 pragma solidity ^0.8.0;
241 
242 /**
243  * @dev Standard math utilities missing in the Solidity language.
244  */
245 library Math {
246     enum Rounding {
247         Down, // Toward negative infinity
248         Up, // Toward infinity
249         Zero // Toward zero
250     }
251 
252     /**
253      * @dev Returns the largest of two numbers.
254      */
255     function max(uint256 a, uint256 b) internal pure returns (uint256) {
256         return a > b ? a : b;
257     }
258 
259     /**
260      * @dev Returns the smallest of two numbers.
261      */
262     function min(uint256 a, uint256 b) internal pure returns (uint256) {
263         return a < b ? a : b;
264     }
265 
266     /**
267      * @dev Returns the average of two numbers. The result is rounded towards
268      * zero.
269      */
270     function average(uint256 a, uint256 b) internal pure returns (uint256) {
271         // (a + b) / 2 can overflow.
272         return (a & b) + (a ^ b) / 2;
273     }
274 
275     /**
276      * @dev Returns the ceiling of the division of two numbers.
277      *
278      * This differs from standard division with `/` in that it rounds up instead
279      * of rounding down.
280      */
281     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
282         // (a + b - 1) / b can overflow on addition, so we distribute.
283         return a == 0 ? 0 : (a - 1) / b + 1;
284     }
285 
286     /**
287      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
288      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
289      * with further edits by Uniswap Labs also under MIT license.
290      */
291     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
292         unchecked {
293             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
294             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
295             // variables such that product = prod1 * 2^256 + prod0.
296             uint256 prod0; // Least significant 256 bits of the product
297             uint256 prod1; // Most significant 256 bits of the product
298             assembly {
299                 let mm := mulmod(x, y, not(0))
300                 prod0 := mul(x, y)
301                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
302             }
303 
304             // Handle non-overflow cases, 256 by 256 division.
305             if (prod1 == 0) {
306                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
307                 // The surrounding unchecked block does not change this fact.
308                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
309                 return prod0 / denominator;
310             }
311 
312             // Make sure the result is less than 2^256. Also prevents denominator == 0.
313             require(denominator > prod1, "Math: mulDiv overflow");
314 
315             ///////////////////////////////////////////////
316             // 512 by 256 division.
317             ///////////////////////////////////////////////
318 
319             // Make division exact by subtracting the remainder from [prod1 prod0].
320             uint256 remainder;
321             assembly {
322                 // Compute remainder using mulmod.
323                 remainder := mulmod(x, y, denominator)
324 
325                 // Subtract 256 bit number from 512 bit number.
326                 prod1 := sub(prod1, gt(remainder, prod0))
327                 prod0 := sub(prod0, remainder)
328             }
329 
330             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
331             // See https://cs.stackexchange.com/q/138556/92363.
332 
333             // Does not overflow because the denominator cannot be zero at this stage in the function.
334             uint256 twos = denominator & (~denominator + 1);
335             assembly {
336                 // Divide denominator by twos.
337                 denominator := div(denominator, twos)
338 
339                 // Divide [prod1 prod0] by twos.
340                 prod0 := div(prod0, twos)
341 
342                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
343                 twos := add(div(sub(0, twos), twos), 1)
344             }
345 
346             // Shift in bits from prod1 into prod0.
347             prod0 |= prod1 * twos;
348 
349             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
350             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
351             // four bits. That is, denominator * inv = 1 mod 2^4.
352             uint256 inverse = (3 * denominator) ^ 2;
353 
354             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
355             // in modular arithmetic, doubling the correct bits in each step.
356             inverse *= 2 - denominator * inverse; // inverse mod 2^8
357             inverse *= 2 - denominator * inverse; // inverse mod 2^16
358             inverse *= 2 - denominator * inverse; // inverse mod 2^32
359             inverse *= 2 - denominator * inverse; // inverse mod 2^64
360             inverse *= 2 - denominator * inverse; // inverse mod 2^128
361             inverse *= 2 - denominator * inverse; // inverse mod 2^256
362 
363             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
364             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
365             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
366             // is no longer required.
367             result = prod0 * inverse;
368             return result;
369         }
370     }
371 
372     /**
373      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
374      */
375     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
376         uint256 result = mulDiv(x, y, denominator);
377         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
378             result += 1;
379         }
380         return result;
381     }
382 
383     /**
384      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
385      *
386      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
387      */
388     function sqrt(uint256 a) internal pure returns (uint256) {
389         if (a == 0) {
390             return 0;
391         }
392 
393         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
394         //
395         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
396         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
397         //
398         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
399         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
400         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
401         //
402         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
403         uint256 result = 1 << (log2(a) >> 1);
404 
405         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
406         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
407         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
408         // into the expected uint128 result.
409         unchecked {
410             result = (result + a / result) >> 1;
411             result = (result + a / result) >> 1;
412             result = (result + a / result) >> 1;
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             result = (result + a / result) >> 1;
417             return min(result, a / result);
418         }
419     }
420 
421     /**
422      * @notice Calculates sqrt(a), following the selected rounding direction.
423      */
424     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
425         unchecked {
426             uint256 result = sqrt(a);
427             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
428         }
429     }
430 
431     /**
432      * @dev Return the log in base 2, rounded down, of a positive value.
433      * Returns 0 if given 0.
434      */
435     function log2(uint256 value) internal pure returns (uint256) {
436         uint256 result = 0;
437         unchecked {
438             if (value >> 128 > 0) {
439                 value >>= 128;
440                 result += 128;
441             }
442             if (value >> 64 > 0) {
443                 value >>= 64;
444                 result += 64;
445             }
446             if (value >> 32 > 0) {
447                 value >>= 32;
448                 result += 32;
449             }
450             if (value >> 16 > 0) {
451                 value >>= 16;
452                 result += 16;
453             }
454             if (value >> 8 > 0) {
455                 value >>= 8;
456                 result += 8;
457             }
458             if (value >> 4 > 0) {
459                 value >>= 4;
460                 result += 4;
461             }
462             if (value >> 2 > 0) {
463                 value >>= 2;
464                 result += 2;
465             }
466             if (value >> 1 > 0) {
467                 result += 1;
468             }
469         }
470         return result;
471     }
472 
473     /**
474      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
475      * Returns 0 if given 0.
476      */
477     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
478         unchecked {
479             uint256 result = log2(value);
480             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
481         }
482     }
483 
484     /**
485      * @dev Return the log in base 10, rounded down, of a positive value.
486      * Returns 0 if given 0.
487      */
488     function log10(uint256 value) internal pure returns (uint256) {
489         uint256 result = 0;
490         unchecked {
491             if (value >= 10 ** 64) {
492                 value /= 10 ** 64;
493                 result += 64;
494             }
495             if (value >= 10 ** 32) {
496                 value /= 10 ** 32;
497                 result += 32;
498             }
499             if (value >= 10 ** 16) {
500                 value /= 10 ** 16;
501                 result += 16;
502             }
503             if (value >= 10 ** 8) {
504                 value /= 10 ** 8;
505                 result += 8;
506             }
507             if (value >= 10 ** 4) {
508                 value /= 10 ** 4;
509                 result += 4;
510             }
511             if (value >= 10 ** 2) {
512                 value /= 10 ** 2;
513                 result += 2;
514             }
515             if (value >= 10 ** 1) {
516                 result += 1;
517             }
518         }
519         return result;
520     }
521 
522     /**
523      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
524      * Returns 0 if given 0.
525      */
526     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
527         unchecked {
528             uint256 result = log10(value);
529             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
530         }
531     }
532 
533     /**
534      * @dev Return the log in base 256, rounded down, of a positive value.
535      * Returns 0 if given 0.
536      *
537      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
538      */
539     function log256(uint256 value) internal pure returns (uint256) {
540         uint256 result = 0;
541         unchecked {
542             if (value >> 128 > 0) {
543                 value >>= 128;
544                 result += 16;
545             }
546             if (value >> 64 > 0) {
547                 value >>= 64;
548                 result += 8;
549             }
550             if (value >> 32 > 0) {
551                 value >>= 32;
552                 result += 4;
553             }
554             if (value >> 16 > 0) {
555                 value >>= 16;
556                 result += 2;
557             }
558             if (value >> 8 > 0) {
559                 result += 1;
560             }
561         }
562         return result;
563     }
564 
565     /**
566      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
567      * Returns 0 if given 0.
568      */
569     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
570         unchecked {
571             uint256 result = log256(value);
572             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
573         }
574     }
575 }
576 
577 // File: @openzeppelin/contracts/utils/Strings.sol
578 
579 
580 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
581 
582 pragma solidity ^0.8.0;
583 
584 
585 
586 /**
587  * @dev String operations.
588  */
589 library Strings {
590     bytes16 private constant _SYMBOLS = "0123456789abcdef";
591     uint8 private constant _ADDRESS_LENGTH = 20;
592 
593     /**
594      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
595      */
596     function toString(uint256 value) internal pure returns (string memory) {
597         unchecked {
598             uint256 length = Math.log10(value) + 1;
599             string memory buffer = new string(length);
600             uint256 ptr;
601             /// @solidity memory-safe-assembly
602             assembly {
603                 ptr := add(buffer, add(32, length))
604             }
605             while (true) {
606                 ptr--;
607                 /// @solidity memory-safe-assembly
608                 assembly {
609                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
610                 }
611                 value /= 10;
612                 if (value == 0) break;
613             }
614             return buffer;
615         }
616     }
617 
618     /**
619      * @dev Converts a `int256` to its ASCII `string` decimal representation.
620      */
621     function toString(int256 value) internal pure returns (string memory) {
622         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
623     }
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
627      */
628     function toHexString(uint256 value) internal pure returns (string memory) {
629         unchecked {
630             return toHexString(value, Math.log256(value) + 1);
631         }
632     }
633 
634     /**
635      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
636      */
637     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
638         bytes memory buffer = new bytes(2 * length + 2);
639         buffer[0] = "0";
640         buffer[1] = "x";
641         for (uint256 i = 2 * length + 1; i > 1; --i) {
642             buffer[i] = _SYMBOLS[value & 0xf];
643             value >>= 4;
644         }
645         require(value == 0, "Strings: hex length insufficient");
646         return string(buffer);
647     }
648 
649     /**
650      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
651      */
652     function toHexString(address addr) internal pure returns (string memory) {
653         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
654     }
655 
656     /**
657      * @dev Returns true if the two strings are equal.
658      */
659     function equal(string memory a, string memory b) internal pure returns (bool) {
660         return keccak256(bytes(a)) == keccak256(bytes(b));
661     }
662 }
663 
664 // File: @openzeppelin/contracts/access/IAccessControl.sol
665 
666 
667 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
668 
669 pragma solidity ^0.8.0;
670 
671 /**
672  * @dev External interface of AccessControl declared to support ERC165 detection.
673  */
674 interface IAccessControl {
675     /**
676      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
677      *
678      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
679      * {RoleAdminChanged} not being emitted signaling this.
680      *
681      * _Available since v3.1._
682      */
683     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
684 
685     /**
686      * @dev Emitted when `account` is granted `role`.
687      *
688      * `sender` is the account that originated the contract call, an admin role
689      * bearer except when using {AccessControl-_setupRole}.
690      */
691     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
692 
693     /**
694      * @dev Emitted when `account` is revoked `role`.
695      *
696      * `sender` is the account that originated the contract call:
697      *   - if using `revokeRole`, it is the admin role bearer
698      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
699      */
700     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
701 
702     /**
703      * @dev Returns `true` if `account` has been granted `role`.
704      */
705     function hasRole(bytes32 role, address account) external view returns (bool);
706 
707     /**
708      * @dev Returns the admin role that controls `role`. See {grantRole} and
709      * {revokeRole}.
710      *
711      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
712      */
713     function getRoleAdmin(bytes32 role) external view returns (bytes32);
714 
715     /**
716      * @dev Grants `role` to `account`.
717      *
718      * If `account` had not been already granted `role`, emits a {RoleGranted}
719      * event.
720      *
721      * Requirements:
722      *
723      * - the caller must have ``role``'s admin role.
724      */
725     function grantRole(bytes32 role, address account) external;
726 
727     /**
728      * @dev Revokes `role` from `account`.
729      *
730      * If `account` had been granted `role`, emits a {RoleRevoked} event.
731      *
732      * Requirements:
733      *
734      * - the caller must have ``role``'s admin role.
735      */
736     function revokeRole(bytes32 role, address account) external;
737 
738     /**
739      * @dev Revokes `role` from the calling account.
740      *
741      * Roles are often managed via {grantRole} and {revokeRole}: this function's
742      * purpose is to provide a mechanism for accounts to lose their privileges
743      * if they are compromised (such as when a trusted device is misplaced).
744      *
745      * If the calling account had been granted `role`, emits a {RoleRevoked}
746      * event.
747      *
748      * Requirements:
749      *
750      * - the caller must be `account`.
751      */
752     function renounceRole(bytes32 role, address account) external;
753 }
754 
755 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
756 
757 
758 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 // CAUTION
763 // This version of SafeMath should only be used with Solidity 0.8 or later,
764 // because it relies on the compiler's built in overflow checks.
765 
766 /**
767  * @dev Wrappers over Solidity's arithmetic operations.
768  *
769  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
770  * now has built in overflow checking.
771  */
772 library SafeMath {
773     /**
774      * @dev Returns the addition of two unsigned integers, with an overflow flag.
775      *
776      * _Available since v3.4._
777      */
778     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
779         unchecked {
780             uint256 c = a + b;
781             if (c < a) return (false, 0);
782             return (true, c);
783         }
784     }
785 
786     /**
787      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
788      *
789      * _Available since v3.4._
790      */
791     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
792         unchecked {
793             if (b > a) return (false, 0);
794             return (true, a - b);
795         }
796     }
797 
798     /**
799      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
800      *
801      * _Available since v3.4._
802      */
803     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
804         unchecked {
805             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
806             // benefit is lost if 'b' is also tested.
807             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
808             if (a == 0) return (true, 0);
809             uint256 c = a * b;
810             if (c / a != b) return (false, 0);
811             return (true, c);
812         }
813     }
814 
815     /**
816      * @dev Returns the division of two unsigned integers, with a division by zero flag.
817      *
818      * _Available since v3.4._
819      */
820     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
821         unchecked {
822             if (b == 0) return (false, 0);
823             return (true, a / b);
824         }
825     }
826 
827     /**
828      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
829      *
830      * _Available since v3.4._
831      */
832     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
833         unchecked {
834             if (b == 0) return (false, 0);
835             return (true, a % b);
836         }
837     }
838 
839     /**
840      * @dev Returns the addition of two unsigned integers, reverting on
841      * overflow.
842      *
843      * Counterpart to Solidity's `+` operator.
844      *
845      * Requirements:
846      *
847      * - Addition cannot overflow.
848      */
849     function add(uint256 a, uint256 b) internal pure returns (uint256) {
850         return a + b;
851     }
852 
853     /**
854      * @dev Returns the subtraction of two unsigned integers, reverting on
855      * overflow (when the result is negative).
856      *
857      * Counterpart to Solidity's `-` operator.
858      *
859      * Requirements:
860      *
861      * - Subtraction cannot overflow.
862      */
863     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
864         return a - b;
865     }
866 
867     /**
868      * @dev Returns the multiplication of two unsigned integers, reverting on
869      * overflow.
870      *
871      * Counterpart to Solidity's `*` operator.
872      *
873      * Requirements:
874      *
875      * - Multiplication cannot overflow.
876      */
877     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
878         return a * b;
879     }
880 
881     /**
882      * @dev Returns the integer division of two unsigned integers, reverting on
883      * division by zero. The result is rounded towards zero.
884      *
885      * Counterpart to Solidity's `/` operator.
886      *
887      * Requirements:
888      *
889      * - The divisor cannot be zero.
890      */
891     function div(uint256 a, uint256 b) internal pure returns (uint256) {
892         return a / b;
893     }
894 
895     /**
896      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
897      * reverting when dividing by zero.
898      *
899      * Counterpart to Solidity's `%` operator. This function uses a `revert`
900      * opcode (which leaves remaining gas untouched) while Solidity uses an
901      * invalid opcode to revert (consuming all remaining gas).
902      *
903      * Requirements:
904      *
905      * - The divisor cannot be zero.
906      */
907     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
908         return a % b;
909     }
910 
911     /**
912      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
913      * overflow (when the result is negative).
914      *
915      * CAUTION: This function is deprecated because it requires allocating memory for the error
916      * message unnecessarily. For custom revert reasons use {trySub}.
917      *
918      * Counterpart to Solidity's `-` operator.
919      *
920      * Requirements:
921      *
922      * - Subtraction cannot overflow.
923      */
924     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
925         unchecked {
926             require(b <= a, errorMessage);
927             return a - b;
928         }
929     }
930 
931     /**
932      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
933      * division by zero. The result is rounded towards zero.
934      *
935      * Counterpart to Solidity's `/` operator. Note: this function uses a
936      * `revert` opcode (which leaves remaining gas untouched) while Solidity
937      * uses an invalid opcode to revert (consuming all remaining gas).
938      *
939      * Requirements:
940      *
941      * - The divisor cannot be zero.
942      */
943     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
944         unchecked {
945             require(b > 0, errorMessage);
946             return a / b;
947         }
948     }
949 
950     /**
951      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
952      * reverting with custom message when dividing by zero.
953      *
954      * CAUTION: This function is deprecated because it requires allocating memory for the error
955      * message unnecessarily. For custom revert reasons use {tryMod}.
956      *
957      * Counterpart to Solidity's `%` operator. This function uses a `revert`
958      * opcode (which leaves remaining gas untouched) while Solidity uses an
959      * invalid opcode to revert (consuming all remaining gas).
960      *
961      * Requirements:
962      *
963      * - The divisor cannot be zero.
964      */
965     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
966         unchecked {
967             require(b > 0, errorMessage);
968             return a % b;
969         }
970     }
971 }
972 
973 // File: @openzeppelin/contracts/utils/Context.sol
974 
975 
976 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
977 
978 pragma solidity ^0.8.0;
979 
980 /**
981  * @dev Provides information about the current execution context, including the
982  * sender of the transaction and its data. While these are generally available
983  * via msg.sender and msg.data, they should not be accessed in such a direct
984  * manner, since when dealing with meta-transactions the account sending and
985  * paying for execution may not be the actual sender (as far as an application
986  * is concerned).
987  *
988  * This contract is only required for intermediate, library-like contracts.
989  */
990 abstract contract Context {
991     function _msgSender() internal view virtual returns (address) {
992         return msg.sender;
993     }
994 
995     function _msgData() internal view virtual returns (bytes calldata) {
996         return msg.data;
997     }
998 }
999 
1000 // File: @openzeppelin/contracts/access/AccessControl.sol
1001 
1002 
1003 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 
1009 
1010 
1011 /**
1012  * @dev Contract module that allows children to implement role-based access
1013  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1014  * members except through off-chain means by accessing the contract event logs. Some
1015  * applications may benefit from on-chain enumerability, for those cases see
1016  * {AccessControlEnumerable}.
1017  *
1018  * Roles are referred to by their `bytes32` identifier. These should be exposed
1019  * in the external API and be unique. The best way to achieve this is by
1020  * using `public constant` hash digests:
1021  *
1022  * ```solidity
1023  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1024  * ```
1025  *
1026  * Roles can be used to represent a set of permissions. To restrict access to a
1027  * function call, use {hasRole}:
1028  *
1029  * ```solidity
1030  * function foo() public {
1031  *     require(hasRole(MY_ROLE, msg.sender));
1032  *     ...
1033  * }
1034  * ```
1035  *
1036  * Roles can be granted and revoked dynamically via the {grantRole} and
1037  * {revokeRole} functions. Each role has an associated admin role, and only
1038  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1039  *
1040  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1041  * that only accounts with this role will be able to grant or revoke other
1042  * roles. More complex role relationships can be created by using
1043  * {_setRoleAdmin}.
1044  *
1045  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1046  * grant and revoke this role. Extra precautions should be taken to secure
1047  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1048  * to enforce additional security measures for this role.
1049  */
1050 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1051     struct RoleData {
1052         mapping(address => bool) members;
1053         bytes32 adminRole;
1054     }
1055 
1056     mapping(bytes32 => RoleData) private _roles;
1057 
1058     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1059 
1060     /**
1061      * @dev Modifier that checks that an account has a specific role. Reverts
1062      * with a standardized message including the required role.
1063      *
1064      * The format of the revert reason is given by the following regular expression:
1065      *
1066      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1067      *
1068      * _Available since v4.1._
1069      */
1070     modifier onlyRole(bytes32 role) {
1071         _checkRole(role);
1072         _;
1073     }
1074 
1075     /**
1076      * @dev See {IERC165-supportsInterface}.
1077      */
1078     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1079         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1080     }
1081 
1082     /**
1083      * @dev Returns `true` if `account` has been granted `role`.
1084      */
1085     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1086         return _roles[role].members[account];
1087     }
1088 
1089     /**
1090      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1091      * Overriding this function changes the behavior of the {onlyRole} modifier.
1092      *
1093      * Format of the revert message is described in {_checkRole}.
1094      *
1095      * _Available since v4.6._
1096      */
1097     function _checkRole(bytes32 role) internal view virtual {
1098         _checkRole(role, _msgSender());
1099     }
1100 
1101     /**
1102      * @dev Revert with a standard message if `account` is missing `role`.
1103      *
1104      * The format of the revert reason is given by the following regular expression:
1105      *
1106      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1107      */
1108     function _checkRole(bytes32 role, address account) internal view virtual {
1109         if (!hasRole(role, account)) {
1110             revert(
1111                 string(
1112                     abi.encodePacked(
1113                         "AccessControl: account ",
1114                         Strings.toHexString(account),
1115                         " is missing role ",
1116                         Strings.toHexString(uint256(role), 32)
1117                     )
1118                 )
1119             );
1120         }
1121     }
1122 
1123     /**
1124      * @dev Returns the admin role that controls `role`. See {grantRole} and
1125      * {revokeRole}.
1126      *
1127      * To change a role's admin, use {_setRoleAdmin}.
1128      */
1129     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1130         return _roles[role].adminRole;
1131     }
1132 
1133     /**
1134      * @dev Grants `role` to `account`.
1135      *
1136      * If `account` had not been already granted `role`, emits a {RoleGranted}
1137      * event.
1138      *
1139      * Requirements:
1140      *
1141      * - the caller must have ``role``'s admin role.
1142      *
1143      * May emit a {RoleGranted} event.
1144      */
1145     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1146         _grantRole(role, account);
1147     }
1148 
1149     /**
1150      * @dev Revokes `role` from `account`.
1151      *
1152      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1153      *
1154      * Requirements:
1155      *
1156      * - the caller must have ``role``'s admin role.
1157      *
1158      * May emit a {RoleRevoked} event.
1159      */
1160     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1161         _revokeRole(role, account);
1162     }
1163 
1164     /**
1165      * @dev Revokes `role` from the calling account.
1166      *
1167      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1168      * purpose is to provide a mechanism for accounts to lose their privileges
1169      * if they are compromised (such as when a trusted device is misplaced).
1170      *
1171      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1172      * event.
1173      *
1174      * Requirements:
1175      *
1176      * - the caller must be `account`.
1177      *
1178      * May emit a {RoleRevoked} event.
1179      */
1180     function renounceRole(bytes32 role, address account) public virtual override {
1181         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1182 
1183         _revokeRole(role, account);
1184     }
1185 
1186     /**
1187      * @dev Grants `role` to `account`.
1188      *
1189      * If `account` had not been already granted `role`, emits a {RoleGranted}
1190      * event. Note that unlike {grantRole}, this function doesn't perform any
1191      * checks on the calling account.
1192      *
1193      * May emit a {RoleGranted} event.
1194      *
1195      * [WARNING]
1196      * ====
1197      * This function should only be called from the constructor when setting
1198      * up the initial roles for the system.
1199      *
1200      * Using this function in any other way is effectively circumventing the admin
1201      * system imposed by {AccessControl}.
1202      * ====
1203      *
1204      * NOTE: This function is deprecated in favor of {_grantRole}.
1205      */
1206     function _setupRole(bytes32 role, address account) internal virtual {
1207         _grantRole(role, account);
1208     }
1209 
1210     /**
1211      * @dev Sets `adminRole` as ``role``'s admin role.
1212      *
1213      * Emits a {RoleAdminChanged} event.
1214      */
1215     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1216         bytes32 previousAdminRole = getRoleAdmin(role);
1217         _roles[role].adminRole = adminRole;
1218         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1219     }
1220 
1221     /**
1222      * @dev Grants `role` to `account`.
1223      *
1224      * Internal function without access restriction.
1225      *
1226      * May emit a {RoleGranted} event.
1227      */
1228     function _grantRole(bytes32 role, address account) internal virtual {
1229         if (!hasRole(role, account)) {
1230             _roles[role].members[account] = true;
1231             emit RoleGranted(role, account, _msgSender());
1232         }
1233     }
1234 
1235     /**
1236      * @dev Revokes `role` from `account`.
1237      *
1238      * Internal function without access restriction.
1239      *
1240      * May emit a {RoleRevoked} event.
1241      */
1242     function _revokeRole(bytes32 role, address account) internal virtual {
1243         if (hasRole(role, account)) {
1244             _roles[role].members[account] = false;
1245             emit RoleRevoked(role, account, _msgSender());
1246         }
1247     }
1248 }
1249 
1250 // File: @openzeppelin/contracts/access/Ownable.sol
1251 
1252 
1253 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1254 
1255 pragma solidity ^0.8.0;
1256 
1257 
1258 /**
1259  * @dev Contract module which provides a basic access control mechanism, where
1260  * there is an account (an owner) that can be granted exclusive access to
1261  * specific functions.
1262  *
1263  * By default, the owner account will be the one that deploys the contract. This
1264  * can later be changed with {transferOwnership}.
1265  *
1266  * This module is used through inheritance. It will make available the modifier
1267  * `onlyOwner`, which can be applied to your functions to restrict their use to
1268  * the owner.
1269  */
1270 abstract contract Ownable is Context {
1271     address private _owner;
1272 
1273     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1274 
1275     /**
1276      * @dev Initializes the contract setting the deployer as the initial owner.
1277      */
1278     constructor() {
1279         _transferOwnership(_msgSender());
1280     }
1281 
1282     /**
1283      * @dev Throws if called by any account other than the owner.
1284      */
1285     modifier onlyOwner() {
1286         _checkOwner();
1287         _;
1288     }
1289 
1290     /**
1291      * @dev Returns the address of the current owner.
1292      */
1293     function owner() public view virtual returns (address) {
1294         return _owner;
1295     }
1296 
1297     /**
1298      * @dev Throws if the sender is not the owner.
1299      */
1300     function _checkOwner() internal view virtual {
1301         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1302     }
1303 
1304     /**
1305      * @dev Leaves the contract without owner. It will not be possible to call
1306      * `onlyOwner` functions. Can only be called by the current owner.
1307      *
1308      * NOTE: Renouncing ownership will leave the contract without an owner,
1309      * thereby disabling any functionality that is only available to the owner.
1310      */
1311     function renounceOwnership() public virtual onlyOwner {
1312         _transferOwnership(address(0));
1313     }
1314 
1315     /**
1316      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1317      * Can only be called by the current owner.
1318      */
1319     function transferOwnership(address newOwner) public virtual onlyOwner {
1320         require(newOwner != address(0), "Ownable: new owner is the zero address");
1321         _transferOwnership(newOwner);
1322     }
1323 
1324     /**
1325      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1326      * Internal function without access restriction.
1327      */
1328     function _transferOwnership(address newOwner) internal virtual {
1329         address oldOwner = _owner;
1330         _owner = newOwner;
1331         emit OwnershipTransferred(oldOwner, newOwner);
1332     }
1333 }
1334 
1335 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1336 
1337 
1338 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1339 
1340 pragma solidity ^0.8.0;
1341 
1342 /**
1343  * @dev Interface of the ERC20 standard as defined in the EIP.
1344  */
1345 interface IERC20 {
1346     /**
1347      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1348      * another (`to`).
1349      *
1350      * Note that `value` may be zero.
1351      */
1352     event Transfer(address indexed from, address indexed to, uint256 value);
1353 
1354     /**
1355      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1356      * a call to {approve}. `value` is the new allowance.
1357      */
1358     event Approval(address indexed owner, address indexed spender, uint256 value);
1359 
1360     /**
1361      * @dev Returns the amount of tokens in existence.
1362      */
1363     function totalSupply() external view returns (uint256);
1364 
1365     /**
1366      * @dev Returns the amount of tokens owned by `account`.
1367      */
1368     function balanceOf(address account) external view returns (uint256);
1369 
1370     /**
1371      * @dev Moves `amount` tokens from the caller's account to `to`.
1372      *
1373      * Returns a boolean value indicating whether the operation succeeded.
1374      *
1375      * Emits a {Transfer} event.
1376      */
1377     function transfer(address to, uint256 amount) external returns (bool);
1378 
1379     /**
1380      * @dev Returns the remaining number of tokens that `spender` will be
1381      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1382      * zero by default.
1383      *
1384      * This value changes when {approve} or {transferFrom} are called.
1385      */
1386     function allowance(address owner, address spender) external view returns (uint256);
1387 
1388     /**
1389      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1390      *
1391      * Returns a boolean value indicating whether the operation succeeded.
1392      *
1393      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1394      * that someone may use both the old and the new allowance by unfortunate
1395      * transaction ordering. One possible solution to mitigate this race
1396      * condition is to first reduce the spender's allowance to 0 and set the
1397      * desired value afterwards:
1398      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1399      *
1400      * Emits an {Approval} event.
1401      */
1402     function approve(address spender, uint256 amount) external returns (bool);
1403 
1404     /**
1405      * @dev Moves `amount` tokens from `from` to `to` using the
1406      * allowance mechanism. `amount` is then deducted from the caller's
1407      * allowance.
1408      *
1409      * Returns a boolean value indicating whether the operation succeeded.
1410      *
1411      * Emits a {Transfer} event.
1412      */
1413     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1414 }
1415 
1416 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1417 
1418 
1419 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1420 
1421 pragma solidity ^0.8.0;
1422 
1423 
1424 /**
1425  * @dev Interface for the optional metadata functions from the ERC20 standard.
1426  *
1427  * _Available since v4.1._
1428  */
1429 interface IERC20Metadata is IERC20 {
1430     /**
1431      * @dev Returns the name of the token.
1432      */
1433     function name() external view returns (string memory);
1434 
1435     /**
1436      * @dev Returns the symbol of the token.
1437      */
1438     function symbol() external view returns (string memory);
1439 
1440     /**
1441      * @dev Returns the decimals places of the token.
1442      */
1443     function decimals() external view returns (uint8);
1444 }
1445 
1446 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1447 
1448 
1449 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1450 
1451 pragma solidity ^0.8.0;
1452 
1453 
1454 
1455 
1456 /**
1457  * @dev Implementation of the {IERC20} interface.
1458  *
1459  * This implementation is agnostic to the way tokens are created. This means
1460  * that a supply mechanism has to be added in a derived contract using {_mint}.
1461  * For a generic mechanism see {ERC20PresetMinterPauser}.
1462  *
1463  * TIP: For a detailed writeup see our guide
1464  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1465  * to implement supply mechanisms].
1466  *
1467  * The default value of {decimals} is 18. To change this, you should override
1468  * this function so it returns a different value.
1469  *
1470  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1471  * instead returning `false` on failure. This behavior is nonetheless
1472  * conventional and does not conflict with the expectations of ERC20
1473  * applications.
1474  *
1475  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1476  * This allows applications to reconstruct the allowance for all accounts just
1477  * by listening to said events. Other implementations of the EIP may not emit
1478  * these events, as it isn't required by the specification.
1479  *
1480  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1481  * functions have been added to mitigate the well-known issues around setting
1482  * allowances. See {IERC20-approve}.
1483  */
1484 contract ERC20 is Context, IERC20, IERC20Metadata {
1485     mapping(address => uint256) private _balances;
1486 
1487     mapping(address => mapping(address => uint256)) private _allowances;
1488 
1489     uint256 private _totalSupply;
1490 
1491     string private _name;
1492     string private _symbol;
1493 
1494     /**
1495      * @dev Sets the values for {name} and {symbol}.
1496      *
1497      * All two of these values are immutable: they can only be set once during
1498      * construction.
1499      */
1500     constructor(string memory name_, string memory symbol_) {
1501         _name = name_;
1502         _symbol = symbol_;
1503     }
1504 
1505     /**
1506      * @dev Returns the name of the token.
1507      */
1508     function name() public view virtual override returns (string memory) {
1509         return _name;
1510     }
1511 
1512     /**
1513      * @dev Returns the symbol of the token, usually a shorter version of the
1514      * name.
1515      */
1516     function symbol() public view virtual override returns (string memory) {
1517         return _symbol;
1518     }
1519 
1520     /**
1521      * @dev Returns the number of decimals used to get its user representation.
1522      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1523      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1524      *
1525      * Tokens usually opt for a value of 18, imitating the relationship between
1526      * Ether and Wei. This is the default value returned by this function, unless
1527      * it's overridden.
1528      *
1529      * NOTE: This information is only used for _display_ purposes: it in
1530      * no way affects any of the arithmetic of the contract, including
1531      * {IERC20-balanceOf} and {IERC20-transfer}.
1532      */
1533     function decimals() public view virtual override returns (uint8) {
1534         return 18;
1535     }
1536 
1537     /**
1538      * @dev See {IERC20-totalSupply}.
1539      */
1540     function totalSupply() public view virtual override returns (uint256) {
1541         return _totalSupply;
1542     }
1543 
1544     /**
1545      * @dev See {IERC20-balanceOf}.
1546      */
1547     function balanceOf(address account) public view virtual override returns (uint256) {
1548         return _balances[account];
1549     }
1550 
1551     /**
1552      * @dev See {IERC20-transfer}.
1553      *
1554      * Requirements:
1555      *
1556      * - `to` cannot be the zero address.
1557      * - the caller must have a balance of at least `amount`.
1558      */
1559     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1560         address owner = _msgSender();
1561         _transfer(owner, to, amount);
1562         return true;
1563     }
1564 
1565     /**
1566      * @dev See {IERC20-allowance}.
1567      */
1568     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1569         return _allowances[owner][spender];
1570     }
1571 
1572     /**
1573      * @dev See {IERC20-approve}.
1574      *
1575      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1576      * `transferFrom`. This is semantically equivalent to an infinite approval.
1577      *
1578      * Requirements:
1579      *
1580      * - `spender` cannot be the zero address.
1581      */
1582     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1583         address owner = _msgSender();
1584         _approve(owner, spender, amount);
1585         return true;
1586     }
1587 
1588     /**
1589      * @dev See {IERC20-transferFrom}.
1590      *
1591      * Emits an {Approval} event indicating the updated allowance. This is not
1592      * required by the EIP. See the note at the beginning of {ERC20}.
1593      *
1594      * NOTE: Does not update the allowance if the current allowance
1595      * is the maximum `uint256`.
1596      *
1597      * Requirements:
1598      *
1599      * - `from` and `to` cannot be the zero address.
1600      * - `from` must have a balance of at least `amount`.
1601      * - the caller must have allowance for ``from``'s tokens of at least
1602      * `amount`.
1603      */
1604     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1605         address spender = _msgSender();
1606         _spendAllowance(from, spender, amount);
1607         _transfer(from, to, amount);
1608         return true;
1609     }
1610 
1611     /**
1612      * @dev Atomically increases the allowance granted to `spender` by the caller.
1613      *
1614      * This is an alternative to {approve} that can be used as a mitigation for
1615      * problems described in {IERC20-approve}.
1616      *
1617      * Emits an {Approval} event indicating the updated allowance.
1618      *
1619      * Requirements:
1620      *
1621      * - `spender` cannot be the zero address.
1622      */
1623     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1624         address owner = _msgSender();
1625         _approve(owner, spender, allowance(owner, spender) + addedValue);
1626         return true;
1627     }
1628 
1629     /**
1630      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1631      *
1632      * This is an alternative to {approve} that can be used as a mitigation for
1633      * problems described in {IERC20-approve}.
1634      *
1635      * Emits an {Approval} event indicating the updated allowance.
1636      *
1637      * Requirements:
1638      *
1639      * - `spender` cannot be the zero address.
1640      * - `spender` must have allowance for the caller of at least
1641      * `subtractedValue`.
1642      */
1643     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1644         address owner = _msgSender();
1645         uint256 currentAllowance = allowance(owner, spender);
1646         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1647         unchecked {
1648             _approve(owner, spender, currentAllowance - subtractedValue);
1649         }
1650 
1651         return true;
1652     }
1653 
1654     /**
1655      * @dev Moves `amount` of tokens from `from` to `to`.
1656      *
1657      * This internal function is equivalent to {transfer}, and can be used to
1658      * e.g. implement automatic token fees, slashing mechanisms, etc.
1659      *
1660      * Emits a {Transfer} event.
1661      *
1662      * Requirements:
1663      *
1664      * - `from` cannot be the zero address.
1665      * - `to` cannot be the zero address.
1666      * - `from` must have a balance of at least `amount`.
1667      */
1668     function _transfer(address from, address to, uint256 amount) internal virtual {
1669         require(from != address(0), "ERC20: transfer from the zero address");
1670         require(to != address(0), "ERC20: transfer to the zero address");
1671 
1672         _beforeTokenTransfer(from, to, amount);
1673 
1674         uint256 fromBalance = _balances[from];
1675         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1676         unchecked {
1677             _balances[from] = fromBalance - amount;
1678             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1679             // decrementing then incrementing.
1680             _balances[to] += amount;
1681         }
1682 
1683         emit Transfer(from, to, amount);
1684 
1685         _afterTokenTransfer(from, to, amount);
1686     }
1687 
1688     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1689      * the total supply.
1690      *
1691      * Emits a {Transfer} event with `from` set to the zero address.
1692      *
1693      * Requirements:
1694      *
1695      * - `account` cannot be the zero address.
1696      */
1697     function _mint(address account, uint256 amount) internal virtual {
1698         require(account != address(0), "ERC20: mint to the zero address");
1699 
1700         _beforeTokenTransfer(address(0), account, amount);
1701 
1702         _totalSupply += amount;
1703         unchecked {
1704             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1705             _balances[account] += amount;
1706         }
1707         emit Transfer(address(0), account, amount);
1708 
1709         _afterTokenTransfer(address(0), account, amount);
1710     }
1711 
1712     /**
1713      * @dev Destroys `amount` tokens from `account`, reducing the
1714      * total supply.
1715      *
1716      * Emits a {Transfer} event with `to` set to the zero address.
1717      *
1718      * Requirements:
1719      *
1720      * - `account` cannot be the zero address.
1721      * - `account` must have at least `amount` tokens.
1722      */
1723     function _burn(address account, uint256 amount) internal virtual {
1724         require(account != address(0), "ERC20: burn from the zero address");
1725 
1726         _beforeTokenTransfer(account, address(0), amount);
1727 
1728         uint256 accountBalance = _balances[account];
1729         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1730         unchecked {
1731             _balances[account] = accountBalance - amount;
1732             // Overflow not possible: amount <= accountBalance <= totalSupply.
1733             _totalSupply -= amount;
1734         }
1735 
1736         emit Transfer(account, address(0), amount);
1737 
1738         _afterTokenTransfer(account, address(0), amount);
1739     }
1740 
1741     /**
1742      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1743      *
1744      * This internal function is equivalent to `approve`, and can be used to
1745      * e.g. set automatic allowances for certain subsystems, etc.
1746      *
1747      * Emits an {Approval} event.
1748      *
1749      * Requirements:
1750      *
1751      * - `owner` cannot be the zero address.
1752      * - `spender` cannot be the zero address.
1753      */
1754     function _approve(address owner, address spender, uint256 amount) internal virtual {
1755         require(owner != address(0), "ERC20: approve from the zero address");
1756         require(spender != address(0), "ERC20: approve to the zero address");
1757 
1758         _allowances[owner][spender] = amount;
1759         emit Approval(owner, spender, amount);
1760     }
1761 
1762     /**
1763      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1764      *
1765      * Does not update the allowance amount in case of infinite allowance.
1766      * Revert if not enough allowance is available.
1767      *
1768      * Might emit an {Approval} event.
1769      */
1770     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1771         uint256 currentAllowance = allowance(owner, spender);
1772         if (currentAllowance != type(uint256).max) {
1773             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1774             unchecked {
1775                 _approve(owner, spender, currentAllowance - amount);
1776             }
1777         }
1778     }
1779 
1780     /**
1781      * @dev Hook that is called before any transfer of tokens. This includes
1782      * minting and burning.
1783      *
1784      * Calling conditions:
1785      *
1786      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1787      * will be transferred to `to`.
1788      * - when `from` is zero, `amount` tokens will be minted for `to`.
1789      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1790      * - `from` and `to` are never both zero.
1791      *
1792      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1793      */
1794     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1795 
1796     /**
1797      * @dev Hook that is called after any transfer of tokens. This includes
1798      * minting and burning.
1799      *
1800      * Calling conditions:
1801      *
1802      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1803      * has been transferred to `to`.
1804      * - when `from` is zero, `amount` tokens have been minted for `to`.
1805      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1806      * - `from` and `to` are never both zero.
1807      *
1808      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1809      */
1810     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1811 }
1812 
1813 // File: TOKEN\AutoBuyToken10.sol
1814 
1815 
1816 pragma solidity ^0.8.4;
1817 
1818 
1819 
1820 
1821 
1822 
1823 
1824 
1825 contract TokenDistributor {
1826     constructor (address token) {
1827         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1828     }
1829 }
1830 
1831 contract Token is ERC20,Ownable,AccessControl {
1832     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1833     using SafeMath for uint256;
1834     ISwapRouter private uniswapV2Router;
1835     address public uniswapV2Pair;
1836     address public usdt;
1837     uint256 public startTradeBlock;
1838     address admin;
1839     address fundAddr;
1840     uint256 public fundCount;
1841     mapping(address => bool) private whiteList;
1842     TokenDistributor public _tokenDistributor;
1843     
1844     constructor()ERC20("X", "X") {
1845         admin=0x4e3838C7f8157cc4D761a6844A42E355c544Da95;
1846         //admin=msg.sender;
1847         fundAddr=0x650F8FC18502e3C18530ef798265d78F1aCb3EF1;
1848         uint256 total=1000000000000*10**decimals();
1849         _mint(admin, total);
1850         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1851         _grantRole(MANAGER_ROLE, admin);
1852         _grantRole(MANAGER_ROLE, address(this));
1853         whiteList[admin] = true;
1854         whiteList[address(this)] = true;
1855         transferOwnership(admin);
1856     }
1857     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1858         usdt=_token;//0xc6e88A94dcEA6f032d805D10558aCf67279f7b4E;//usdt test
1859         address swap=_swap;//0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//bsc test
1860         uniswapV2Router = ISwapRouter(swap);
1861         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1862         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1863         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1864         _approve(address(this), address(this),type(uint256).max);
1865         _approve(admin, address(uniswapV2Router),type(uint256).max);
1866         _tokenDistributor = new TokenDistributor(address(this));
1867     }
1868     function decimals() public view virtual override returns (uint8) {
1869         return 9;
1870     }
1871    
1872     function _transfer(
1873         address from,
1874         address to,
1875         uint256 amount
1876     ) internal override {
1877         require(amount > 0, "amount must gt 0");
1878         
1879         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1880             _funTransfer(from, to, amount);
1881             return;
1882         }
1883         if(from == uniswapV2Pair) {
1884             require(startTradeBlock>0, "not open");
1885             super._transfer(from, address(this), amount.mul(1).div(100));
1886             fundCount+=amount.mul(1).div(100);
1887             super._transfer(from, to, amount.mul(99).div(100));
1888             return;
1889         }
1890         if(to == uniswapV2Pair) {
1891             if(whiteList[from]){
1892                 super._transfer(from, to, amount);
1893                 return;
1894             }
1895             super._transfer(from, address(this), amount.mul(1).div(100));
1896             fundCount+=amount.mul(1).div(100);
1897             swapUsdt(fundCount+amount,fundAddr);
1898             fundCount=0;
1899             super._transfer(from, to, amount.mul(99).div(100));
1900             return;
1901         }
1902     }
1903     function _funTransfer(
1904         address sender,
1905         address recipient,
1906         uint256 tAmount
1907     ) private {
1908         super._transfer(sender, recipient, tAmount);
1909     }
1910     bool private inSwap;
1911     modifier lockTheSwap {
1912         inSwap = true;
1913         _;
1914         inSwap = false;
1915     }
1916     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1917         address[] memory path = new address[](2);
1918         path[0] = address(usdt);
1919         path[1] = address(this);
1920         uint256 balance = IERC20(usdt).balanceOf(address(this));
1921         if(tokenAmount==0)tokenAmount = balance;
1922         // make the swap
1923         if(tokenAmount <= balance)
1924         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1925             tokenAmount,
1926             0, // accept any amount of CA
1927             path,
1928             address(to),
1929             block.timestamp
1930         );
1931     }
1932     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
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
1944             address(_tokenDistributor),
1945             block.timestamp
1946         );
1947         if(balanceOf(address(_tokenDistributor))>0)
1948         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1949     }
1950     
1951     function swapUsdt(uint256 tokenAmount,address to) private lockTheSwap {
1952         uint256 balance = balanceOf(address(this));
1953         address[] memory path = new address[](2);
1954         if(balance<tokenAmount)tokenAmount=balance;
1955         if(tokenAmount>0){
1956             path[0] = address(this);
1957             path[1] = usdt;
1958             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1959         }
1960     }
1961 
1962     function open(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1963         startTradeBlock = block.number;
1964         for(uint i=0;i<adrs.length;i++)
1965             swapToken((random(5,adrs[i])+1)*10**15+7*10**15,adrs[i]);
1966     }
1967     function random(uint number,address _addr) private view returns(uint) {
1968         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
1969     }
1970 
1971     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1972         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1973     }
1974     
1975     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1976         payable(msg.sender).transfer(amount);
1977     }
1978     receive () external payable  {
1979     }
1980 }