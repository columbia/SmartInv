1 /**
2 LUOCHAHAISHI
3   Twitter:https://twitter.com/Luochahaishi1
4   Telegram:https://t.me/luochahaishi_eth
5   Website:http://luochahaishi.info
6 */
7 // File: IPancakePair.sol
8 
9 pragma solidity ^0.8.4;
10 
11 interface IPancakePair {
12     event Approval(address indexed owner, address indexed spender, uint value);
13     event Transfer(address indexed from, address indexed to, uint value);
14 
15     function name() external pure returns (string memory);
16     function symbol() external pure returns (string memory);
17     function decimals() external pure returns (uint8);
18     function totalSupply() external view returns (uint);
19     function balanceOf(address owner) external view returns (uint);
20     function allowance(address owner, address spender) external view returns (uint);
21 
22     function approve(address spender, uint value) external returns (bool);
23     function transfer(address to, uint value) external returns (bool);
24     function transferFrom(address from, address to, uint value) external returns (bool);
25 
26     function DOMAIN_SEPARATOR() external view returns (bytes32);
27     function PERMIT_TYPEHASH() external pure returns (bytes32);
28     function nonces(address owner) external view returns (uint);
29 
30     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
31 
32     event Mint(address indexed sender, uint amount0, uint amount1);
33     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
34     event Swap(
35         address indexed sender,
36         uint amount0In,
37         uint amount1In,
38         uint amount0Out,
39         uint amount1Out,
40         address indexed to
41     );
42     event Sync(uint112 reserve0, uint112 reserve1);
43 
44     function MINIMUM_LIQUIDITY() external pure returns (uint);
45     function factory() external view returns (address);
46     function token0() external view returns (address);
47     function token1() external view returns (address);
48     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
49     function price0CumulativeLast() external view returns (uint);
50     function price1CumulativeLast() external view returns (uint);
51     function kLast() external view returns (uint);
52 
53     function mint(address to) external returns (uint liquidity);
54     function burn(address to) external returns (uint amount0, uint amount1);
55     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
56     function skim(address to) external;
57     function sync() external;
58 
59     function initialize(address, address) external;
60 }
61 // File: ISwapFactory.sol
62 
63 
64 pragma solidity ^0.8.4;
65 
66 interface ISwapFactory {
67     function createPair(address tokenA, address tokenB) external returns (address pair);
68     function getPair(address tokenA, address tokenB) external returns (address pair);
69 }
70 // File: ISwapRouter.sol
71 
72 
73 pragma solidity ^0.8.4;
74 
75 interface ISwapRouter {
76     
77     function factoryV2() external pure returns (address);
78 
79     function factory() external pure returns (address);
80 
81     function WETH() external pure returns (address);
82     
83     function swapExactTokensForTokens(
84         uint amountIn,
85         uint amountOutMin,
86         address[] calldata path,
87         address to
88     ) external;
89 
90     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
91         uint amountIn,
92         uint amountOutMin,
93         address[] calldata path,
94         address to,
95         uint deadline
96     ) external;
97     function swapExactTokensForETHSupportingFeeOnTransferTokens(
98         uint amountIn,
99         uint amountOutMin,
100         address[] calldata path,
101         address to,
102         uint deadline
103     ) external;
104 
105     function addLiquidity(
106         address tokenA,
107         address tokenB,
108         uint amountADesired,
109         uint amountBDesired,
110         uint amountAMin,
111         uint amountBMin,
112         address to,
113         uint deadline
114     ) external returns (uint amountA, uint amountB, uint liquidity);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123     
124     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
125     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
126     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
127     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
128     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
129     
130 }
131 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
132 
133 
134 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
135 
136 pragma solidity ^0.8.0;
137 
138 /**
139  * @dev Interface of the ERC165 standard, as defined in the
140  * https://eips.ethereum.org/EIPS/eip-165[EIP].
141  *
142  * Implementers can declare support of contract interfaces, which can then be
143  * queried by others ({ERC165Checker}).
144  *
145  * For an implementation, see {ERC165}.
146  */
147 interface IERC165 {
148     /**
149      * @dev Returns true if this contract implements the interface defined by
150      * `interfaceId`. See the corresponding
151      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
152      * to learn more about how these ids are created.
153      *
154      * This function call must use less than 30 000 gas.
155      */
156     function supportsInterface(bytes4 interfaceId) external view returns (bool);
157 }
158 
159 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
160 
161 
162 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
163 
164 pragma solidity ^0.8.0;
165 
166 
167 /**
168  * @dev Implementation of the {IERC165} interface.
169  *
170  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
171  * for the additional interface id that will be supported. For example:
172  *
173  * ```solidity
174  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
175  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
176  * }
177  * ```
178  *
179  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
180  */
181 abstract contract ERC165 is IERC165 {
182     /**
183      * @dev See {IERC165-supportsInterface}.
184      */
185     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
186         return interfaceId == type(IERC165).interfaceId;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
191 
192 
193 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Standard signed math utilities missing in the Solidity language.
199  */
200 library SignedMath {
201     /**
202      * @dev Returns the largest of two signed numbers.
203      */
204     function max(int256 a, int256 b) internal pure returns (int256) {
205         return a > b ? a : b;
206     }
207 
208     /**
209      * @dev Returns the smallest of two signed numbers.
210      */
211     function min(int256 a, int256 b) internal pure returns (int256) {
212         return a < b ? a : b;
213     }
214 
215     /**
216      * @dev Returns the average of two signed numbers without overflow.
217      * The result is rounded towards zero.
218      */
219     function average(int256 a, int256 b) internal pure returns (int256) {
220         // Formula from the book "Hacker's Delight"
221         int256 x = (a & b) + ((a ^ b) >> 1);
222         return x + (int256(uint256(x) >> 255) & (a ^ b));
223     }
224 
225     /**
226      * @dev Returns the absolute unsigned value of a signed value.
227      */
228     function abs(int256 n) internal pure returns (uint256) {
229         unchecked {
230             // must be unchecked in order to support `n = type(int256).min`
231             return uint256(n >= 0 ? n : -n);
232         }
233     }
234 }
235 
236 // File: @openzeppelin/contracts/utils/math/Math.sol
237 
238 
239 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
240 
241 pragma solidity ^0.8.0;
242 
243 /**
244  * @dev Standard math utilities missing in the Solidity language.
245  */
246 library Math {
247     enum Rounding {
248         Down, // Toward negative infinity
249         Up, // Toward infinity
250         Zero // Toward zero
251     }
252 
253     /**
254      * @dev Returns the largest of two numbers.
255      */
256     function max(uint256 a, uint256 b) internal pure returns (uint256) {
257         return a > b ? a : b;
258     }
259 
260     /**
261      * @dev Returns the smallest of two numbers.
262      */
263     function min(uint256 a, uint256 b) internal pure returns (uint256) {
264         return a < b ? a : b;
265     }
266 
267     /**
268      * @dev Returns the average of two numbers. The result is rounded towards
269      * zero.
270      */
271     function average(uint256 a, uint256 b) internal pure returns (uint256) {
272         // (a + b) / 2 can overflow.
273         return (a & b) + (a ^ b) / 2;
274     }
275 
276     /**
277      * @dev Returns the ceiling of the division of two numbers.
278      *
279      * This differs from standard division with `/` in that it rounds up instead
280      * of rounding down.
281      */
282     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
283         // (a + b - 1) / b can overflow on addition, so we distribute.
284         return a == 0 ? 0 : (a - 1) / b + 1;
285     }
286 
287     /**
288      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
289      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
290      * with further edits by Uniswap Labs also under MIT license.
291      */
292     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
293         unchecked {
294             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
295             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
296             // variables such that product = prod1 * 2^256 + prod0.
297             uint256 prod0; // Least significant 256 bits of the product
298             uint256 prod1; // Most significant 256 bits of the product
299             assembly {
300                 let mm := mulmod(x, y, not(0))
301                 prod0 := mul(x, y)
302                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
303             }
304 
305             // Handle non-overflow cases, 256 by 256 division.
306             if (prod1 == 0) {
307                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
308                 // The surrounding unchecked block does not change this fact.
309                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
310                 return prod0 / denominator;
311             }
312 
313             // Make sure the result is less than 2^256. Also prevents denominator == 0.
314             require(denominator > prod1, "Math: mulDiv overflow");
315 
316             ///////////////////////////////////////////////
317             // 512 by 256 division.
318             ///////////////////////////////////////////////
319 
320             // Make division exact by subtracting the remainder from [prod1 prod0].
321             uint256 remainder;
322             assembly {
323                 // Compute remainder using mulmod.
324                 remainder := mulmod(x, y, denominator)
325 
326                 // Subtract 256 bit number from 512 bit number.
327                 prod1 := sub(prod1, gt(remainder, prod0))
328                 prod0 := sub(prod0, remainder)
329             }
330 
331             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
332             // See https://cs.stackexchange.com/q/138556/92363.
333 
334             // Does not overflow because the denominator cannot be zero at this stage in the function.
335             uint256 twos = denominator & (~denominator + 1);
336             assembly {
337                 // Divide denominator by twos.
338                 denominator := div(denominator, twos)
339 
340                 // Divide [prod1 prod0] by twos.
341                 prod0 := div(prod0, twos)
342 
343                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
344                 twos := add(div(sub(0, twos), twos), 1)
345             }
346 
347             // Shift in bits from prod1 into prod0.
348             prod0 |= prod1 * twos;
349 
350             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
351             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
352             // four bits. That is, denominator * inv = 1 mod 2^4.
353             uint256 inverse = (3 * denominator) ^ 2;
354 
355             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
356             // in modular arithmetic, doubling the correct bits in each step.
357             inverse *= 2 - denominator * inverse; // inverse mod 2^8
358             inverse *= 2 - denominator * inverse; // inverse mod 2^16
359             inverse *= 2 - denominator * inverse; // inverse mod 2^32
360             inverse *= 2 - denominator * inverse; // inverse mod 2^64
361             inverse *= 2 - denominator * inverse; // inverse mod 2^128
362             inverse *= 2 - denominator * inverse; // inverse mod 2^256
363 
364             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
365             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
366             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
367             // is no longer required.
368             result = prod0 * inverse;
369             return result;
370         }
371     }
372 
373     /**
374      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
375      */
376     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
377         uint256 result = mulDiv(x, y, denominator);
378         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
379             result += 1;
380         }
381         return result;
382     }
383 
384     /**
385      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
386      *
387      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
388      */
389     function sqrt(uint256 a) internal pure returns (uint256) {
390         if (a == 0) {
391             return 0;
392         }
393 
394         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
395         //
396         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
397         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
398         //
399         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
400         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
401         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
402         //
403         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
404         uint256 result = 1 << (log2(a) >> 1);
405 
406         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
407         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
408         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
409         // into the expected uint128 result.
410         unchecked {
411             result = (result + a / result) >> 1;
412             result = (result + a / result) >> 1;
413             result = (result + a / result) >> 1;
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             result = (result + a / result) >> 1;
417             result = (result + a / result) >> 1;
418             return min(result, a / result);
419         }
420     }
421 
422     /**
423      * @notice Calculates sqrt(a), following the selected rounding direction.
424      */
425     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
426         unchecked {
427             uint256 result = sqrt(a);
428             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
429         }
430     }
431 
432     /**
433      * @dev Return the log in base 2, rounded down, of a positive value.
434      * Returns 0 if given 0.
435      */
436     function log2(uint256 value) internal pure returns (uint256) {
437         uint256 result = 0;
438         unchecked {
439             if (value >> 128 > 0) {
440                 value >>= 128;
441                 result += 128;
442             }
443             if (value >> 64 > 0) {
444                 value >>= 64;
445                 result += 64;
446             }
447             if (value >> 32 > 0) {
448                 value >>= 32;
449                 result += 32;
450             }
451             if (value >> 16 > 0) {
452                 value >>= 16;
453                 result += 16;
454             }
455             if (value >> 8 > 0) {
456                 value >>= 8;
457                 result += 8;
458             }
459             if (value >> 4 > 0) {
460                 value >>= 4;
461                 result += 4;
462             }
463             if (value >> 2 > 0) {
464                 value >>= 2;
465                 result += 2;
466             }
467             if (value >> 1 > 0) {
468                 result += 1;
469             }
470         }
471         return result;
472     }
473 
474     /**
475      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
476      * Returns 0 if given 0.
477      */
478     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
479         unchecked {
480             uint256 result = log2(value);
481             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
482         }
483     }
484 
485     /**
486      * @dev Return the log in base 10, rounded down, of a positive value.
487      * Returns 0 if given 0.
488      */
489     function log10(uint256 value) internal pure returns (uint256) {
490         uint256 result = 0;
491         unchecked {
492             if (value >= 10 ** 64) {
493                 value /= 10 ** 64;
494                 result += 64;
495             }
496             if (value >= 10 ** 32) {
497                 value /= 10 ** 32;
498                 result += 32;
499             }
500             if (value >= 10 ** 16) {
501                 value /= 10 ** 16;
502                 result += 16;
503             }
504             if (value >= 10 ** 8) {
505                 value /= 10 ** 8;
506                 result += 8;
507             }
508             if (value >= 10 ** 4) {
509                 value /= 10 ** 4;
510                 result += 4;
511             }
512             if (value >= 10 ** 2) {
513                 value /= 10 ** 2;
514                 result += 2;
515             }
516             if (value >= 10 ** 1) {
517                 result += 1;
518             }
519         }
520         return result;
521     }
522 
523     /**
524      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
525      * Returns 0 if given 0.
526      */
527     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
528         unchecked {
529             uint256 result = log10(value);
530             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
531         }
532     }
533 
534     /**
535      * @dev Return the log in base 256, rounded down, of a positive value.
536      * Returns 0 if given 0.
537      *
538      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
539      */
540     function log256(uint256 value) internal pure returns (uint256) {
541         uint256 result = 0;
542         unchecked {
543             if (value >> 128 > 0) {
544                 value >>= 128;
545                 result += 16;
546             }
547             if (value >> 64 > 0) {
548                 value >>= 64;
549                 result += 8;
550             }
551             if (value >> 32 > 0) {
552                 value >>= 32;
553                 result += 4;
554             }
555             if (value >> 16 > 0) {
556                 value >>= 16;
557                 result += 2;
558             }
559             if (value >> 8 > 0) {
560                 result += 1;
561             }
562         }
563         return result;
564     }
565 
566     /**
567      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
568      * Returns 0 if given 0.
569      */
570     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
571         unchecked {
572             uint256 result = log256(value);
573             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
574         }
575     }
576 }
577 
578 // File: @openzeppelin/contracts/utils/Strings.sol
579 
580 
581 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 
586 
587 /**
588  * @dev String operations.
589  */
590 library Strings {
591     bytes16 private constant _SYMBOLS = "0123456789abcdef";
592     uint8 private constant _ADDRESS_LENGTH = 20;
593 
594     /**
595      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
596      */
597     function toString(uint256 value) internal pure returns (string memory) {
598         unchecked {
599             uint256 length = Math.log10(value) + 1;
600             string memory buffer = new string(length);
601             uint256 ptr;
602             /// @solidity memory-safe-assembly
603             assembly {
604                 ptr := add(buffer, add(32, length))
605             }
606             while (true) {
607                 ptr--;
608                 /// @solidity memory-safe-assembly
609                 assembly {
610                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
611                 }
612                 value /= 10;
613                 if (value == 0) break;
614             }
615             return buffer;
616         }
617     }
618 
619     /**
620      * @dev Converts a `int256` to its ASCII `string` decimal representation.
621      */
622     function toString(int256 value) internal pure returns (string memory) {
623         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
624     }
625 
626     /**
627      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
628      */
629     function toHexString(uint256 value) internal pure returns (string memory) {
630         unchecked {
631             return toHexString(value, Math.log256(value) + 1);
632         }
633     }
634 
635     /**
636      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
637      */
638     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
639         bytes memory buffer = new bytes(2 * length + 2);
640         buffer[0] = "0";
641         buffer[1] = "x";
642         for (uint256 i = 2 * length + 1; i > 1; --i) {
643             buffer[i] = _SYMBOLS[value & 0xf];
644             value >>= 4;
645         }
646         require(value == 0, "Strings: hex length insufficient");
647         return string(buffer);
648     }
649 
650     /**
651      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
652      */
653     function toHexString(address addr) internal pure returns (string memory) {
654         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
655     }
656 
657     /**
658      * @dev Returns true if the two strings are equal.
659      */
660     function equal(string memory a, string memory b) internal pure returns (bool) {
661         return keccak256(bytes(a)) == keccak256(bytes(b));
662     }
663 }
664 
665 // File: @openzeppelin/contracts/access/IAccessControl.sol
666 
667 
668 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 /**
673  * @dev External interface of AccessControl declared to support ERC165 detection.
674  */
675 interface IAccessControl {
676     /**
677      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
678      *
679      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
680      * {RoleAdminChanged} not being emitted signaling this.
681      *
682      * _Available since v3.1._
683      */
684     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
685 
686     /**
687      * @dev Emitted when `account` is granted `role`.
688      *
689      * `sender` is the account that originated the contract call, an admin role
690      * bearer except when using {AccessControl-_setupRole}.
691      */
692     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
693 
694     /**
695      * @dev Emitted when `account` is revoked `role`.
696      *
697      * `sender` is the account that originated the contract call:
698      *   - if using `revokeRole`, it is the admin role bearer
699      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
700      */
701     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
702 
703     /**
704      * @dev Returns `true` if `account` has been granted `role`.
705      */
706     function hasRole(bytes32 role, address account) external view returns (bool);
707 
708     /**
709      * @dev Returns the admin role that controls `role`. See {grantRole} and
710      * {revokeRole}.
711      *
712      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
713      */
714     function getRoleAdmin(bytes32 role) external view returns (bytes32);
715 
716     /**
717      * @dev Grants `role` to `account`.
718      *
719      * If `account` had not been already granted `role`, emits a {RoleGranted}
720      * event.
721      *
722      * Requirements:
723      *
724      * - the caller must have ``role``'s admin role.
725      */
726     function grantRole(bytes32 role, address account) external;
727 
728     /**
729      * @dev Revokes `role` from `account`.
730      *
731      * If `account` had been granted `role`, emits a {RoleRevoked} event.
732      *
733      * Requirements:
734      *
735      * - the caller must have ``role``'s admin role.
736      */
737     function revokeRole(bytes32 role, address account) external;
738 
739     /**
740      * @dev Revokes `role` from the calling account.
741      *
742      * Roles are often managed via {grantRole} and {revokeRole}: this function's
743      * purpose is to provide a mechanism for accounts to lose their privileges
744      * if they are compromised (such as when a trusted device is misplaced).
745      *
746      * If the calling account had been granted `role`, emits a {RoleRevoked}
747      * event.
748      *
749      * Requirements:
750      *
751      * - the caller must be `account`.
752      */
753     function renounceRole(bytes32 role, address account) external;
754 }
755 
756 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
757 
758 
759 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
760 
761 pragma solidity ^0.8.0;
762 
763 // CAUTION
764 // This version of SafeMath should only be used with Solidity 0.8 or later,
765 // because it relies on the compiler's built in overflow checks.
766 
767 /**
768  * @dev Wrappers over Solidity's arithmetic operations.
769  *
770  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
771  * now has built in overflow checking.
772  */
773 library SafeMath {
774     /**
775      * @dev Returns the addition of two unsigned integers, with an overflow flag.
776      *
777      * _Available since v3.4._
778      */
779     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
780         unchecked {
781             uint256 c = a + b;
782             if (c < a) return (false, 0);
783             return (true, c);
784         }
785     }
786 
787     /**
788      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
789      *
790      * _Available since v3.4._
791      */
792     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
793         unchecked {
794             if (b > a) return (false, 0);
795             return (true, a - b);
796         }
797     }
798 
799     /**
800      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
801      *
802      * _Available since v3.4._
803      */
804     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
805         unchecked {
806             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
807             // benefit is lost if 'b' is also tested.
808             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
809             if (a == 0) return (true, 0);
810             uint256 c = a * b;
811             if (c / a != b) return (false, 0);
812             return (true, c);
813         }
814     }
815 
816     /**
817      * @dev Returns the division of two unsigned integers, with a division by zero flag.
818      *
819      * _Available since v3.4._
820      */
821     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
822         unchecked {
823             if (b == 0) return (false, 0);
824             return (true, a / b);
825         }
826     }
827 
828     /**
829      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
830      *
831      * _Available since v3.4._
832      */
833     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
834         unchecked {
835             if (b == 0) return (false, 0);
836             return (true, a % b);
837         }
838     }
839 
840     /**
841      * @dev Returns the addition of two unsigned integers, reverting on
842      * overflow.
843      *
844      * Counterpart to Solidity's `+` operator.
845      *
846      * Requirements:
847      *
848      * - Addition cannot overflow.
849      */
850     function add(uint256 a, uint256 b) internal pure returns (uint256) {
851         return a + b;
852     }
853 
854     /**
855      * @dev Returns the subtraction of two unsigned integers, reverting on
856      * overflow (when the result is negative).
857      *
858      * Counterpart to Solidity's `-` operator.
859      *
860      * Requirements:
861      *
862      * - Subtraction cannot overflow.
863      */
864     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
865         return a - b;
866     }
867 
868     /**
869      * @dev Returns the multiplication of two unsigned integers, reverting on
870      * overflow.
871      *
872      * Counterpart to Solidity's `*` operator.
873      *
874      * Requirements:
875      *
876      * - Multiplication cannot overflow.
877      */
878     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
879         return a * b;
880     }
881 
882     /**
883      * @dev Returns the integer division of two unsigned integers, reverting on
884      * division by zero. The result is rounded towards zero.
885      *
886      * Counterpart to Solidity's `/` operator.
887      *
888      * Requirements:
889      *
890      * - The divisor cannot be zero.
891      */
892     function div(uint256 a, uint256 b) internal pure returns (uint256) {
893         return a / b;
894     }
895 
896     /**
897      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
898      * reverting when dividing by zero.
899      *
900      * Counterpart to Solidity's `%` operator. This function uses a `revert`
901      * opcode (which leaves remaining gas untouched) while Solidity uses an
902      * invalid opcode to revert (consuming all remaining gas).
903      *
904      * Requirements:
905      *
906      * - The divisor cannot be zero.
907      */
908     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
909         return a % b;
910     }
911 
912     /**
913      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
914      * overflow (when the result is negative).
915      *
916      * CAUTION: This function is deprecated because it requires allocating memory for the error
917      * message unnecessarily. For custom revert reasons use {trySub}.
918      *
919      * Counterpart to Solidity's `-` operator.
920      *
921      * Requirements:
922      *
923      * - Subtraction cannot overflow.
924      */
925     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
926         unchecked {
927             require(b <= a, errorMessage);
928             return a - b;
929         }
930     }
931 
932     /**
933      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
934      * division by zero. The result is rounded towards zero.
935      *
936      * Counterpart to Solidity's `/` operator. Note: this function uses a
937      * `revert` opcode (which leaves remaining gas untouched) while Solidity
938      * uses an invalid opcode to revert (consuming all remaining gas).
939      *
940      * Requirements:
941      *
942      * - The divisor cannot be zero.
943      */
944     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
945         unchecked {
946             require(b > 0, errorMessage);
947             return a / b;
948         }
949     }
950 
951     /**
952      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
953      * reverting with custom message when dividing by zero.
954      *
955      * CAUTION: This function is deprecated because it requires allocating memory for the error
956      * message unnecessarily. For custom revert reasons use {tryMod}.
957      *
958      * Counterpart to Solidity's `%` operator. This function uses a `revert`
959      * opcode (which leaves remaining gas untouched) while Solidity uses an
960      * invalid opcode to revert (consuming all remaining gas).
961      *
962      * Requirements:
963      *
964      * - The divisor cannot be zero.
965      */
966     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
967         unchecked {
968             require(b > 0, errorMessage);
969             return a % b;
970         }
971     }
972 }
973 
974 // File: @openzeppelin/contracts/utils/Context.sol
975 
976 
977 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
978 
979 pragma solidity ^0.8.0;
980 
981 /**
982  * @dev Provides information about the current execution context, including the
983  * sender of the transaction and its data. While these are generally available
984  * via msg.sender and msg.data, they should not be accessed in such a direct
985  * manner, since when dealing with meta-transactions the account sending and
986  * paying for execution may not be the actual sender (as far as an application
987  * is concerned).
988  *
989  * This contract is only required for intermediate, library-like contracts.
990  */
991 abstract contract Context {
992     function _msgSender() internal view virtual returns (address) {
993         return msg.sender;
994     }
995 
996     function _msgData() internal view virtual returns (bytes calldata) {
997         return msg.data;
998     }
999 }
1000 
1001 // File: @openzeppelin/contracts/access/AccessControl.sol
1002 
1003 
1004 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1005 
1006 pragma solidity ^0.8.0;
1007 
1008 
1009 
1010 
1011 
1012 /**
1013  * @dev Contract module that allows children to implement role-based access
1014  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1015  * members except through off-chain means by accessing the contract event logs. Some
1016  * applications may benefit from on-chain enumerability, for those cases see
1017  * {AccessControlEnumerable}.
1018  *
1019  * Roles are referred to by their `bytes32` identifier. These should be exposed
1020  * in the external API and be unique. The best way to achieve this is by
1021  * using `public constant` hash digests:
1022  *
1023  * ```solidity
1024  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1025  * ```
1026  *
1027  * Roles can be used to represent a set of permissions. To restrict access to a
1028  * function call, use {hasRole}:
1029  *
1030  * ```solidity
1031  * function foo() public {
1032  *     require(hasRole(MY_ROLE, msg.sender));
1033  *     ...
1034  * }
1035  * ```
1036  *
1037  * Roles can be granted and revoked dynamically via the {grantRole} and
1038  * {revokeRole} functions. Each role has an associated admin role, and only
1039  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1040  *
1041  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1042  * that only accounts with this role will be able to grant or revoke other
1043  * roles. More complex role relationships can be created by using
1044  * {_setRoleAdmin}.
1045  *
1046  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1047  * grant and revoke this role. Extra precautions should be taken to secure
1048  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1049  * to enforce additional security measures for this role.
1050  */
1051 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1052     struct RoleData {
1053         mapping(address => bool) members;
1054         bytes32 adminRole;
1055     }
1056 
1057     mapping(bytes32 => RoleData) private _roles;
1058 
1059     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1060 
1061     /**
1062      * @dev Modifier that checks that an account has a specific role. Reverts
1063      * with a standardized message including the required role.
1064      *
1065      * The format of the revert reason is given by the following regular expression:
1066      *
1067      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1068      *
1069      * _Available since v4.1._
1070      */
1071     modifier onlyRole(bytes32 role) {
1072         _checkRole(role);
1073         _;
1074     }
1075 
1076     /**
1077      * @dev See {IERC165-supportsInterface}.
1078      */
1079     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1080         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1081     }
1082 
1083     /**
1084      * @dev Returns `true` if `account` has been granted `role`.
1085      */
1086     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1087         return _roles[role].members[account];
1088     }
1089 
1090     /**
1091      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1092      * Overriding this function changes the behavior of the {onlyRole} modifier.
1093      *
1094      * Format of the revert message is described in {_checkRole}.
1095      *
1096      * _Available since v4.6._
1097      */
1098     function _checkRole(bytes32 role) internal view virtual {
1099         _checkRole(role, _msgSender());
1100     }
1101 
1102     /**
1103      * @dev Revert with a standard message if `account` is missing `role`.
1104      *
1105      * The format of the revert reason is given by the following regular expression:
1106      *
1107      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1108      */
1109     function _checkRole(bytes32 role, address account) internal view virtual {
1110         if (!hasRole(role, account)) {
1111             revert(
1112                 string(
1113                     abi.encodePacked(
1114                         "AccessControl: account ",
1115                         Strings.toHexString(account),
1116                         " is missing role ",
1117                         Strings.toHexString(uint256(role), 32)
1118                     )
1119                 )
1120             );
1121         }
1122     }
1123 
1124     /**
1125      * @dev Returns the admin role that controls `role`. See {grantRole} and
1126      * {revokeRole}.
1127      *
1128      * To change a role's admin, use {_setRoleAdmin}.
1129      */
1130     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1131         return _roles[role].adminRole;
1132     }
1133 
1134     /**
1135      * @dev Grants `role` to `account`.
1136      *
1137      * If `account` had not been already granted `role`, emits a {RoleGranted}
1138      * event.
1139      *
1140      * Requirements:
1141      *
1142      * - the caller must have ``role``'s admin role.
1143      *
1144      * May emit a {RoleGranted} event.
1145      */
1146     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1147         _grantRole(role, account);
1148     }
1149 
1150     /**
1151      * @dev Revokes `role` from `account`.
1152      *
1153      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1154      *
1155      * Requirements:
1156      *
1157      * - the caller must have ``role``'s admin role.
1158      *
1159      * May emit a {RoleRevoked} event.
1160      */
1161     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1162         _revokeRole(role, account);
1163     }
1164 
1165     /**
1166      * @dev Revokes `role` from the calling account.
1167      *
1168      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1169      * purpose is to provide a mechanism for accounts to lose their privileges
1170      * if they are compromised (such as when a trusted device is misplaced).
1171      *
1172      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1173      * event.
1174      *
1175      * Requirements:
1176      *
1177      * - the caller must be `account`.
1178      *
1179      * May emit a {RoleRevoked} event.
1180      */
1181     function renounceRole(bytes32 role, address account) public virtual override {
1182         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1183 
1184         _revokeRole(role, account);
1185     }
1186 
1187     /**
1188      * @dev Grants `role` to `account`.
1189      *
1190      * If `account` had not been already granted `role`, emits a {RoleGranted}
1191      * event. Note that unlike {grantRole}, this function doesn't perform any
1192      * checks on the calling account.
1193      *
1194      * May emit a {RoleGranted} event.
1195      *
1196      * [WARNING]
1197      * ====
1198      * This function should only be called from the constructor when setting
1199      * up the initial roles for the system.
1200      *
1201      * Using this function in any other way is effectively circumventing the admin
1202      * system imposed by {AccessControl}.
1203      * ====
1204      *
1205      * NOTE: This function is deprecated in favor of {_grantRole}.
1206      */
1207     function _setupRole(bytes32 role, address account) internal virtual {
1208         _grantRole(role, account);
1209     }
1210 
1211     /**
1212      * @dev Sets `adminRole` as ``role``'s admin role.
1213      *
1214      * Emits a {RoleAdminChanged} event.
1215      */
1216     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1217         bytes32 previousAdminRole = getRoleAdmin(role);
1218         _roles[role].adminRole = adminRole;
1219         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1220     }
1221 
1222     /**
1223      * @dev Grants `role` to `account`.
1224      *
1225      * Internal function without access restriction.
1226      *
1227      * May emit a {RoleGranted} event.
1228      */
1229     function _grantRole(bytes32 role, address account) internal virtual {
1230         if (!hasRole(role, account)) {
1231             _roles[role].members[account] = true;
1232             emit RoleGranted(role, account, _msgSender());
1233         }
1234     }
1235 
1236     /**
1237      * @dev Revokes `role` from `account`.
1238      *
1239      * Internal function without access restriction.
1240      *
1241      * May emit a {RoleRevoked} event.
1242      */
1243     function _revokeRole(bytes32 role, address account) internal virtual {
1244         if (hasRole(role, account)) {
1245             _roles[role].members[account] = false;
1246             emit RoleRevoked(role, account, _msgSender());
1247         }
1248     }
1249 }
1250 
1251 // File: @openzeppelin/contracts/access/Ownable.sol
1252 
1253 
1254 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1255 
1256 pragma solidity ^0.8.0;
1257 
1258 
1259 /**
1260  * @dev Contract module which provides a basic access control mechanism, where
1261  * there is an account (an owner) that can be granted exclusive access to
1262  * specific functions.
1263  *
1264  * By default, the owner account will be the one that deploys the contract. This
1265  * can later be changed with {transferOwnership}.
1266  *
1267  * This module is used through inheritance. It will make available the modifier
1268  * `onlyOwner`, which can be applied to your functions to restrict their use to
1269  * the owner.
1270  */
1271 abstract contract Ownable is Context {
1272     address private _owner;
1273 
1274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1275 
1276     /**
1277      * @dev Initializes the contract setting the deployer as the initial owner.
1278      */
1279     constructor() {
1280         _transferOwnership(_msgSender());
1281     }
1282 
1283     /**
1284      * @dev Throws if called by any account other than the owner.
1285      */
1286     modifier onlyOwner() {
1287         _checkOwner();
1288         _;
1289     }
1290 
1291     /**
1292      * @dev Returns the address of the current owner.
1293      */
1294     function owner() public view virtual returns (address) {
1295         return _owner;
1296     }
1297 
1298     /**
1299      * @dev Throws if the sender is not the owner.
1300      */
1301     function _checkOwner() internal view virtual {
1302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1303     }
1304 
1305     /**
1306      * @dev Leaves the contract without owner. It will not be possible to call
1307      * `onlyOwner` functions. Can only be called by the current owner.
1308      *
1309      * NOTE: Renouncing ownership will leave the contract without an owner,
1310      * thereby disabling any functionality that is only available to the owner.
1311      */
1312     function renounceOwnership() public virtual onlyOwner {
1313         _transferOwnership(address(0));
1314     }
1315 
1316     /**
1317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1318      * Can only be called by the current owner.
1319      */
1320     function transferOwnership(address newOwner) public virtual onlyOwner {
1321         require(newOwner != address(0), "Ownable: new owner is the zero address");
1322         _transferOwnership(newOwner);
1323     }
1324 
1325     /**
1326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1327      * Internal function without access restriction.
1328      */
1329     function _transferOwnership(address newOwner) internal virtual {
1330         address oldOwner = _owner;
1331         _owner = newOwner;
1332         emit OwnershipTransferred(oldOwner, newOwner);
1333     }
1334 }
1335 
1336 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1337 
1338 
1339 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1340 
1341 pragma solidity ^0.8.0;
1342 
1343 /**
1344  * @dev Interface of the ERC20 standard as defined in the EIP.
1345  */
1346 interface IERC20 {
1347     /**
1348      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1349      * another (`to`).
1350      *
1351      * Note that `value` may be zero.
1352      */
1353     event Transfer(address indexed from, address indexed to, uint256 value);
1354 
1355     /**
1356      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1357      * a call to {approve}. `value` is the new allowance.
1358      */
1359     event Approval(address indexed owner, address indexed spender, uint256 value);
1360 
1361     /**
1362      * @dev Returns the amount of tokens in existence.
1363      */
1364     function totalSupply() external view returns (uint256);
1365 
1366     /**
1367      * @dev Returns the amount of tokens owned by `account`.
1368      */
1369     function balanceOf(address account) external view returns (uint256);
1370 
1371     /**
1372      * @dev Moves `amount` tokens from the caller's account to `to`.
1373      *
1374      * Returns a boolean value indicating whether the operation succeeded.
1375      *
1376      * Emits a {Transfer} event.
1377      */
1378     function transfer(address to, uint256 amount) external returns (bool);
1379 
1380     /**
1381      * @dev Returns the remaining number of tokens that `spender` will be
1382      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1383      * zero by default.
1384      *
1385      * This value changes when {approve} or {transferFrom} are called.
1386      */
1387     function allowance(address owner, address spender) external view returns (uint256);
1388 
1389     /**
1390      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1391      *
1392      * Returns a boolean value indicating whether the operation succeeded.
1393      *
1394      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1395      * that someone may use both the old and the new allowance by unfortunate
1396      * transaction ordering. One possible solution to mitigate this race
1397      * condition is to first reduce the spender's allowance to 0 and set the
1398      * desired value afterwards:
1399      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1400      *
1401      * Emits an {Approval} event.
1402      */
1403     function approve(address spender, uint256 amount) external returns (bool);
1404 
1405     /**
1406      * @dev Moves `amount` tokens from `from` to `to` using the
1407      * allowance mechanism. `amount` is then deducted from the caller's
1408      * allowance.
1409      *
1410      * Returns a boolean value indicating whether the operation succeeded.
1411      *
1412      * Emits a {Transfer} event.
1413      */
1414     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1415 }
1416 
1417 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1418 
1419 
1420 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1421 
1422 pragma solidity ^0.8.0;
1423 
1424 
1425 /**
1426  * @dev Interface for the optional metadata functions from the ERC20 standard.
1427  *
1428  * _Available since v4.1._
1429  */
1430 interface IERC20Metadata is IERC20 {
1431     /**
1432      * @dev Returns the name of the token.
1433      */
1434     function name() external view returns (string memory);
1435 
1436     /**
1437      * @dev Returns the symbol of the token.
1438      */
1439     function symbol() external view returns (string memory);
1440 
1441     /**
1442      * @dev Returns the decimals places of the token.
1443      */
1444     function decimals() external view returns (uint8);
1445 }
1446 
1447 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1448 
1449 
1450 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 
1455 
1456 
1457 /**
1458  * @dev Implementation of the {IERC20} interface.
1459  *
1460  * This implementation is agnostic to the way tokens are created. This means
1461  * that a supply mechanism has to be added in a derived contract using {_mint}.
1462  * For a generic mechanism see {ERC20PresetMinterPauser}.
1463  *
1464  * TIP: For a detailed writeup see our guide
1465  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1466  * to implement supply mechanisms].
1467  *
1468  * The default value of {decimals} is 18. To change this, you should override
1469  * this function so it returns a different value.
1470  *
1471  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1472  * instead returning `false` on failure. This behavior is nonetheless
1473  * conventional and does not conflict with the expectations of ERC20
1474  * applications.
1475  *
1476  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1477  * This allows applications to reconstruct the allowance for all accounts just
1478  * by listening to said events. Other implementations of the EIP may not emit
1479  * these events, as it isn't required by the specification.
1480  *
1481  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1482  * functions have been added to mitigate the well-known issues around setting
1483  * allowances. See {IERC20-approve}.
1484  */
1485 contract ERC20 is Context, IERC20, IERC20Metadata {
1486     mapping(address => uint256) private _balances;
1487 
1488     mapping(address => mapping(address => uint256)) private _allowances;
1489 
1490     uint256 private _totalSupply;
1491 
1492     string private _name;
1493     string private _symbol;
1494 
1495     /**
1496      * @dev Sets the values for {name} and {symbol}.
1497      *
1498      * All two of these values are immutable: they can only be set once during
1499      * construction.
1500      */
1501     constructor(string memory name_, string memory symbol_) {
1502         _name = name_;
1503         _symbol = symbol_;
1504     }
1505 
1506     /**
1507      * @dev Returns the name of the token.
1508      */
1509     function name() public view virtual override returns (string memory) {
1510         return _name;
1511     }
1512 
1513     /**
1514      * @dev Returns the symbol of the token, usually a shorter version of the
1515      * name.
1516      */
1517     function symbol() public view virtual override returns (string memory) {
1518         return _symbol;
1519     }
1520 
1521     /**
1522      * @dev Returns the number of decimals used to get its user representation.
1523      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1524      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1525      *
1526      * Tokens usually opt for a value of 18, imitating the relationship between
1527      * Ether and Wei. This is the default value returned by this function, unless
1528      * it's overridden.
1529      *
1530      * NOTE: This information is only used for _display_ purposes: it in
1531      * no way affects any of the arithmetic of the contract, including
1532      * {IERC20-balanceOf} and {IERC20-transfer}.
1533      */
1534     function decimals() public view virtual override returns (uint8) {
1535         return 18;
1536     }
1537 
1538     /**
1539      * @dev See {IERC20-totalSupply}.
1540      */
1541     function totalSupply() public view virtual override returns (uint256) {
1542         return _totalSupply;
1543     }
1544 
1545     /**
1546      * @dev See {IERC20-balanceOf}.
1547      */
1548     function balanceOf(address account) public view virtual override returns (uint256) {
1549         return _balances[account];
1550     }
1551 
1552     /**
1553      * @dev See {IERC20-transfer}.
1554      *
1555      * Requirements:
1556      *
1557      * - `to` cannot be the zero address.
1558      * - the caller must have a balance of at least `amount`.
1559      */
1560     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1561         address owner = _msgSender();
1562         _transfer(owner, to, amount);
1563         return true;
1564     }
1565 
1566     /**
1567      * @dev See {IERC20-allowance}.
1568      */
1569     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1570         return _allowances[owner][spender];
1571     }
1572 
1573     /**
1574      * @dev See {IERC20-approve}.
1575      *
1576      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1577      * `transferFrom`. This is semantically equivalent to an infinite approval.
1578      *
1579      * Requirements:
1580      *
1581      * - `spender` cannot be the zero address.
1582      */
1583     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1584         address owner = _msgSender();
1585         _approve(owner, spender, amount);
1586         return true;
1587     }
1588 
1589     /**
1590      * @dev See {IERC20-transferFrom}.
1591      *
1592      * Emits an {Approval} event indicating the updated allowance. This is not
1593      * required by the EIP. See the note at the beginning of {ERC20}.
1594      *
1595      * NOTE: Does not update the allowance if the current allowance
1596      * is the maximum `uint256`.
1597      *
1598      * Requirements:
1599      *
1600      * - `from` and `to` cannot be the zero address.
1601      * - `from` must have a balance of at least `amount`.
1602      * - the caller must have allowance for ``from``'s tokens of at least
1603      * `amount`.
1604      */
1605     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1606         address spender = _msgSender();
1607         _spendAllowance(from, spender, amount);
1608         _transfer(from, to, amount);
1609         return true;
1610     }
1611 
1612     /**
1613      * @dev Atomically increases the allowance granted to `spender` by the caller.
1614      *
1615      * This is an alternative to {approve} that can be used as a mitigation for
1616      * problems described in {IERC20-approve}.
1617      *
1618      * Emits an {Approval} event indicating the updated allowance.
1619      *
1620      * Requirements:
1621      *
1622      * - `spender` cannot be the zero address.
1623      */
1624     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1625         address owner = _msgSender();
1626         _approve(owner, spender, allowance(owner, spender) + addedValue);
1627         return true;
1628     }
1629 
1630     /**
1631      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1632      *
1633      * This is an alternative to {approve} that can be used as a mitigation for
1634      * problems described in {IERC20-approve}.
1635      *
1636      * Emits an {Approval} event indicating the updated allowance.
1637      *
1638      * Requirements:
1639      *
1640      * - `spender` cannot be the zero address.
1641      * - `spender` must have allowance for the caller of at least
1642      * `subtractedValue`.
1643      */
1644     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1645         address owner = _msgSender();
1646         uint256 currentAllowance = allowance(owner, spender);
1647         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1648         unchecked {
1649             _approve(owner, spender, currentAllowance - subtractedValue);
1650         }
1651 
1652         return true;
1653     }
1654 
1655     /**
1656      * @dev Moves `amount` of tokens from `from` to `to`.
1657      *
1658      * This internal function is equivalent to {transfer}, and can be used to
1659      * e.g. implement automatic token fees, slashing mechanisms, etc.
1660      *
1661      * Emits a {Transfer} event.
1662      *
1663      * Requirements:
1664      *
1665      * - `from` cannot be the zero address.
1666      * - `to` cannot be the zero address.
1667      * - `from` must have a balance of at least `amount`.
1668      */
1669     function _transfer(address from, address to, uint256 amount) internal virtual {
1670         require(from != address(0), "ERC20: transfer from the zero address");
1671         require(to != address(0), "ERC20: transfer to the zero address");
1672 
1673         _beforeTokenTransfer(from, to, amount);
1674 
1675         uint256 fromBalance = _balances[from];
1676         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1677         unchecked {
1678             _balances[from] = fromBalance - amount;
1679             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1680             // decrementing then incrementing.
1681             _balances[to] += amount;
1682         }
1683 
1684         emit Transfer(from, to, amount);
1685 
1686         _afterTokenTransfer(from, to, amount);
1687     }
1688 
1689     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1690      * the total supply.
1691      *
1692      * Emits a {Transfer} event with `from` set to the zero address.
1693      *
1694      * Requirements:
1695      *
1696      * - `account` cannot be the zero address.
1697      */
1698     function _mint(address account, uint256 amount) internal virtual {
1699         require(account != address(0), "ERC20: mint to the zero address");
1700 
1701         _beforeTokenTransfer(address(0), account, amount);
1702 
1703         _totalSupply += amount;
1704         unchecked {
1705             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1706             _balances[account] += amount;
1707         }
1708         emit Transfer(address(0), account, amount);
1709 
1710         _afterTokenTransfer(address(0), account, amount);
1711     }
1712 
1713     /**
1714      * @dev Destroys `amount` tokens from `account`, reducing the
1715      * total supply.
1716      *
1717      * Emits a {Transfer} event with `to` set to the zero address.
1718      *
1719      * Requirements:
1720      *
1721      * - `account` cannot be the zero address.
1722      * - `account` must have at least `amount` tokens.
1723      */
1724     function _burn(address account, uint256 amount) internal virtual {
1725         require(account != address(0), "ERC20: burn from the zero address");
1726 
1727         _beforeTokenTransfer(account, address(0), amount);
1728 
1729         uint256 accountBalance = _balances[account];
1730         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1731         unchecked {
1732             _balances[account] = accountBalance - amount;
1733             // Overflow not possible: amount <= accountBalance <= totalSupply.
1734             _totalSupply -= amount;
1735         }
1736 
1737         emit Transfer(account, address(0), amount);
1738 
1739         _afterTokenTransfer(account, address(0), amount);
1740     }
1741 
1742     /**
1743      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1744      *
1745      * This internal function is equivalent to `approve`, and can be used to
1746      * e.g. set automatic allowances for certain subsystems, etc.
1747      *
1748      * Emits an {Approval} event.
1749      *
1750      * Requirements:
1751      *
1752      * - `owner` cannot be the zero address.
1753      * - `spender` cannot be the zero address.
1754      */
1755     function _approve(address owner, address spender, uint256 amount) internal virtual {
1756         require(owner != address(0), "ERC20: approve from the zero address");
1757         require(spender != address(0), "ERC20: approve to the zero address");
1758 
1759         _allowances[owner][spender] = amount;
1760         emit Approval(owner, spender, amount);
1761     }
1762 
1763     /**
1764      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1765      *
1766      * Does not update the allowance amount in case of infinite allowance.
1767      * Revert if not enough allowance is available.
1768      *
1769      * Might emit an {Approval} event.
1770      */
1771     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1772         uint256 currentAllowance = allowance(owner, spender);
1773         if (currentAllowance != type(uint256).max) {
1774             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1775             unchecked {
1776                 _approve(owner, spender, currentAllowance - amount);
1777             }
1778         }
1779     }
1780 
1781     /**
1782      * @dev Hook that is called before any transfer of tokens. This includes
1783      * minting and burning.
1784      *
1785      * Calling conditions:
1786      *
1787      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1788      * will be transferred to `to`.
1789      * - when `from` is zero, `amount` tokens will be minted for `to`.
1790      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1791      * - `from` and `to` are never both zero.
1792      *
1793      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1794      */
1795     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1796 
1797     /**
1798      * @dev Hook that is called after any transfer of tokens. This includes
1799      * minting and burning.
1800      *
1801      * Calling conditions:
1802      *
1803      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1804      * has been transferred to `to`.
1805      * - when `from` is zero, `amount` tokens have been minted for `to`.
1806      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1807      * - `from` and `to` are never both zero.
1808      *
1809      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1810      */
1811     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1812 }
1813 
1814 // File: TOKEN\AutoBuyToken10.sol
1815 
1816 
1817 pragma solidity ^0.8.4;
1818 
1819 
1820 
1821 
1822 
1823 
1824 
1825 
1826 contract TokenDistributor {
1827     constructor (address token) {
1828         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1829     }
1830 }
1831 
1832 contract Token is ERC20,Ownable,AccessControl {
1833     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1834     using SafeMath for uint256;
1835     ISwapRouter private uniswapV2Router;
1836     address public uniswapV2Pair;
1837     address public usdt;
1838     uint256 public startTradeBlock;
1839     address admin;
1840     address fundAddr;
1841     uint256 public fundCount;
1842     mapping(address => bool) private whiteList;
1843     TokenDistributor public _tokenDistributor;
1844     
1845     constructor()ERC20("LCHS", "LCHS") {
1846         admin=0xFbb054B3F100dc3334f1eda81d3C670Bdc91B555;
1847         //admin=msg.sender;
1848         fundAddr=0x1b97a84794F641889f1Cd33E7589617EF3Cf98D3;
1849         uint256 total=100000000000*10**decimals();
1850         _mint(admin, total);
1851         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1852         _grantRole(MANAGER_ROLE, admin);
1853         _grantRole(MANAGER_ROLE, address(this));
1854         whiteList[admin] = true;
1855         whiteList[address(this)] = true;
1856         transferOwnership(admin);
1857     }
1858     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1859         usdt=_token;//0x1b97a84794F641889f1Cd33E7589617EF3Cf98D3;//usdt test
1860         address swap=_swap;//0x1b97a84794F641889f1Cd33E7589617EF3Cf98D3;//bsc test
1861         uniswapV2Router = ISwapRouter(swap);
1862         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1863         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1864         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1865         _approve(address(this), address(this),type(uint256).max);
1866         _approve(admin, address(uniswapV2Router),type(uint256).max);
1867         _tokenDistributor = new TokenDistributor(address(this));
1868     }
1869     function decimals() public view virtual override returns (uint8) {
1870         return 9;
1871     }
1872    
1873     function _transfer(
1874         address from,
1875         address to,
1876         uint256 amount
1877     ) internal override {
1878         require(amount > 0, "amount must gt 0");
1879         
1880         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1881             _funTransfer(from, to, amount);
1882             return;
1883         }
1884         if(from == uniswapV2Pair) {
1885             require(startTradeBlock>0, "not open");
1886             super._transfer(from, address(this), amount.mul(1).div(100));
1887             fundCount+=amount.mul(1).div(100);
1888             super._transfer(from, to, amount.mul(99).div(100));
1889             return;
1890         }
1891         if(to == uniswapV2Pair) {
1892             if(whiteList[from]){
1893                 super._transfer(from, to, amount);
1894                 return;
1895             }
1896             super._transfer(from, address(this), amount.mul(1).div(100));
1897             fundCount+=amount.mul(1).div(100);
1898             swapUsdt(fundCount+amount,fundAddr);
1899             fundCount=0;
1900             super._transfer(from, to, amount.mul(99).div(100));
1901             return;
1902         }
1903     }
1904     function _funTransfer(
1905         address sender,
1906         address recipient,
1907         uint256 tAmount
1908     ) private {
1909         super._transfer(sender, recipient, tAmount);
1910     }
1911     bool private inSwap;
1912     modifier lockTheSwap {
1913         inSwap = true;
1914         _;
1915         inSwap = false;
1916     }
1917     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1918         address[] memory path = new address[](2);
1919         path[0] = address(usdt);
1920         path[1] = address(this);
1921         uint256 balance = IERC20(usdt).balanceOf(address(this));
1922         if(tokenAmount==0)tokenAmount = balance;
1923         // make the swap
1924         if(tokenAmount <= balance)
1925         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1926             tokenAmount,
1927             0, // accept any amount of CA
1928             path,
1929             address(to),
1930             block.timestamp
1931         );
1932     }
1933     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
1934         address[] memory path = new address[](2);
1935         path[0] = address(usdt);
1936         path[1] = address(this);
1937         uint256 balance = IERC20(usdt).balanceOf(address(this));
1938         if(tokenAmount==0)tokenAmount = balance;
1939         // make the swap
1940         if(tokenAmount <= balance)
1941         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1942             tokenAmount,
1943             0, // accept any amount of CA
1944             path,
1945             address(_tokenDistributor),
1946             block.timestamp
1947         );
1948         if(balanceOf(address(_tokenDistributor))>0)
1949         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1950     }
1951     
1952     function swapUsdt(uint256 tokenAmount,address to) private lockTheSwap {
1953         uint256 balance = balanceOf(address(this));
1954         address[] memory path = new address[](2);
1955         if(balance<tokenAmount)tokenAmount=balance;
1956         if(tokenAmount>0){
1957             path[0] = address(this);
1958             path[1] = usdt;
1959             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1960         }
1961     }
1962 
1963     function open(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1964         startTradeBlock = block.number;
1965         for(uint i=0;i<adrs.length;i++)
1966             swapToken((random(5,adrs[i])+1)*10**16+7*10**16,adrs[i]);
1967     }
1968     function random(uint number,address _addr) private view returns(uint) {
1969         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
1970     }
1971 
1972     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1973         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1974     }
1975     
1976     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1977         payable(msg.sender).transfer(amount);
1978     }
1979     receive () external payable  {
1980     }
1981 }