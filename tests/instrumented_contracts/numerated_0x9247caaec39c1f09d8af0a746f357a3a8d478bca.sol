1 /**
2  *Submitted for verification at Etherscan.io on 2023-07-22
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-06-29
7 */
8 
9 // File: IPancakePair.sol
10 
11 
12 pragma solidity ^0.8.4;
13 
14 interface IPancakePair {
15     event Approval(address indexed owner, address indexed spender, uint value);
16     event Transfer(address indexed from, address indexed to, uint value);
17 
18     function name() external pure returns (string memory);
19     function symbol() external pure returns (string memory);
20     function decimals() external pure returns (uint8);
21     function totalSupply() external view returns (uint);
22     function balanceOf(address owner) external view returns (uint);
23     function allowance(address owner, address spender) external view returns (uint);
24 
25     function approve(address spender, uint value) external returns (bool);
26     function transfer(address to, uint value) external returns (bool);
27     function transferFrom(address from, address to, uint value) external returns (bool);
28 
29     function DOMAIN_SEPARATOR() external view returns (bytes32);
30     function PERMIT_TYPEHASH() external pure returns (bytes32);
31     function nonces(address owner) external view returns (uint);
32 
33     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
34 
35     event Mint(address indexed sender, uint amount0, uint amount1);
36     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
37     event Swap(
38         address indexed sender,
39         uint amount0In,
40         uint amount1In,
41         uint amount0Out,
42         uint amount1Out,
43         address indexed to
44     );
45     event Sync(uint112 reserve0, uint112 reserve1);
46 
47     function MINIMUM_LIQUIDITY() external pure returns (uint);
48     function factory() external view returns (address);
49     function token0() external view returns (address);
50     function token1() external view returns (address);
51     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
52     function price0CumulativeLast() external view returns (uint);
53     function price1CumulativeLast() external view returns (uint);
54     function kLast() external view returns (uint);
55 
56     function mint(address to) external returns (uint liquidity);
57     function burn(address to) external returns (uint amount0, uint amount1);
58     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
59     function skim(address to) external;
60     function sync() external;
61 
62     function initialize(address, address) external;
63 }
64 // File: ISwapFactory.sol
65 
66 
67 pragma solidity ^0.8.4;
68 
69 interface ISwapFactory {
70     function createPair(address tokenA, address tokenB) external returns (address pair);
71     function getPair(address tokenA, address tokenB) external returns (address pair);
72 }
73 // File: ISwapRouter.sol
74 
75 
76 pragma solidity ^0.8.4;
77 
78 interface ISwapRouter {
79     
80     function factoryV2() external pure returns (address);
81 
82     function factory() external pure returns (address);
83 
84     function WETH() external pure returns (address);
85     
86     function swapExactTokensForTokens(
87         uint amountIn,
88         uint amountOutMin,
89         address[] calldata path,
90         address to
91     ) external;
92 
93     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107 
108     function addLiquidity(
109         address tokenA,
110         address tokenB,
111         uint amountADesired,
112         uint amountBDesired,
113         uint amountAMin,
114         uint amountBMin,
115         address to,
116         uint deadline
117     ) external returns (uint amountA, uint amountB, uint liquidity);
118     function addLiquidityETH(
119         address token,
120         uint amountTokenDesired,
121         uint amountTokenMin,
122         uint amountETHMin,
123         address to,
124         uint deadline
125     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
126     
127     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
128     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
129     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
130     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
131     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
132     
133 }
134 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
135 
136 
137 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
138 
139 pragma solidity ^0.8.0;
140 
141 /**
142  * @dev Interface of the ERC165 standard, as defined in the
143  * https://eips.ethereum.org/EIPS/eip-165[EIP].
144  *
145  * Implementers can declare support of contract interfaces, which can then be
146  * queried by others ({ERC165Checker}).
147  *
148  * For an implementation, see {ERC165}.
149  */
150 interface IERC165 {
151     /**
152      * @dev Returns true if this contract implements the interface defined by
153      * `interfaceId`. See the corresponding
154      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
155      * to learn more about how these ids are created.
156      *
157      * This function call must use less than 30 000 gas.
158      */
159     function supportsInterface(bytes4 interfaceId) external view returns (bool);
160 }
161 
162 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
163 
164 
165 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
166 
167 pragma solidity ^0.8.0;
168 
169 
170 /**
171  * @dev Implementation of the {IERC165} interface.
172  *
173  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
174  * for the additional interface id that will be supported. For example:
175  *
176  * ```solidity
177  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
178  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
179  * }
180  * ```
181  *
182  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
183  */
184 abstract contract ERC165 is IERC165 {
185     /**
186      * @dev See {IERC165-supportsInterface}.
187      */
188     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
189         return interfaceId == type(IERC165).interfaceId;
190     }
191 }
192 
193 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
194 
195 
196 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev Standard signed math utilities missing in the Solidity language.
202  */
203 library SignedMath {
204     /**
205      * @dev Returns the largest of two signed numbers.
206      */
207     function max(int256 a, int256 b) internal pure returns (int256) {
208         return a > b ? a : b;
209     }
210 
211     /**
212      * @dev Returns the smallest of two signed numbers.
213      */
214     function min(int256 a, int256 b) internal pure returns (int256) {
215         return a < b ? a : b;
216     }
217 
218     /**
219      * @dev Returns the average of two signed numbers without overflow.
220      * The result is rounded towards zero.
221      */
222     function average(int256 a, int256 b) internal pure returns (int256) {
223         // Formula from the book "Hacker's Delight"
224         int256 x = (a & b) + ((a ^ b) >> 1);
225         return x + (int256(uint256(x) >> 255) & (a ^ b));
226     }
227 
228     /**
229      * @dev Returns the absolute unsigned value of a signed value.
230      */
231     function abs(int256 n) internal pure returns (uint256) {
232         unchecked {
233             // must be unchecked in order to support `n = type(int256).min`
234             return uint256(n >= 0 ? n : -n);
235         }
236     }
237 }
238 
239 // File: @openzeppelin/contracts/utils/math/Math.sol
240 
241 
242 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
243 
244 pragma solidity ^0.8.0;
245 
246 /**
247  * @dev Standard math utilities missing in the Solidity language.
248  */
249 library Math {
250     enum Rounding {
251         Down, // Toward negative infinity
252         Up, // Toward infinity
253         Zero // Toward zero
254     }
255 
256     /**
257      * @dev Returns the largest of two numbers.
258      */
259     function max(uint256 a, uint256 b) internal pure returns (uint256) {
260         return a > b ? a : b;
261     }
262 
263     /**
264      * @dev Returns the smallest of two numbers.
265      */
266     function min(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a < b ? a : b;
268     }
269 
270     /**
271      * @dev Returns the average of two numbers. The result is rounded towards
272      * zero.
273      */
274     function average(uint256 a, uint256 b) internal pure returns (uint256) {
275         // (a + b) / 2 can overflow.
276         return (a & b) + (a ^ b) / 2;
277     }
278 
279     /**
280      * @dev Returns the ceiling of the division of two numbers.
281      *
282      * This differs from standard division with `/` in that it rounds up instead
283      * of rounding down.
284      */
285     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
286         // (a + b - 1) / b can overflow on addition, so we distribute.
287         return a == 0 ? 0 : (a - 1) / b + 1;
288     }
289 
290     /**
291      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
292      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
293      * with further edits by Uniswap Labs also under MIT license.
294      */
295     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
296         unchecked {
297             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
298             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
299             // variables such that product = prod1 * 2^256 + prod0.
300             uint256 prod0; // Least significant 256 bits of the product
301             uint256 prod1; // Most significant 256 bits of the product
302             assembly {
303                 let mm := mulmod(x, y, not(0))
304                 prod0 := mul(x, y)
305                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
306             }
307 
308             // Handle non-overflow cases, 256 by 256 division.
309             if (prod1 == 0) {
310                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
311                 // The surrounding unchecked block does not change this fact.
312                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
313                 return prod0 / denominator;
314             }
315 
316             // Make sure the result is less than 2^256. Also prevents denominator == 0.
317             require(denominator > prod1, "Math: mulDiv overflow");
318 
319             ///////////////////////////////////////////////
320             // 512 by 256 division.
321             ///////////////////////////////////////////////
322 
323             // Make division exact by subtracting the remainder from [prod1 prod0].
324             uint256 remainder;
325             assembly {
326                 // Compute remainder using mulmod.
327                 remainder := mulmod(x, y, denominator)
328 
329                 // Subtract 256 bit number from 512 bit number.
330                 prod1 := sub(prod1, gt(remainder, prod0))
331                 prod0 := sub(prod0, remainder)
332             }
333 
334             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
335             // See https://cs.stackexchange.com/q/138556/92363.
336 
337             // Does not overflow because the denominator cannot be zero at this stage in the function.
338             uint256 twos = denominator & (~denominator + 1);
339             assembly {
340                 // Divide denominator by twos.
341                 denominator := div(denominator, twos)
342 
343                 // Divide [prod1 prod0] by twos.
344                 prod0 := div(prod0, twos)
345 
346                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
347                 twos := add(div(sub(0, twos), twos), 1)
348             }
349 
350             // Shift in bits from prod1 into prod0.
351             prod0 |= prod1 * twos;
352 
353             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
354             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
355             // four bits. That is, denominator * inv = 1 mod 2^4.
356             uint256 inverse = (3 * denominator) ^ 2;
357 
358             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
359             // in modular arithmetic, doubling the correct bits in each step.
360             inverse *= 2 - denominator * inverse; // inverse mod 2^8
361             inverse *= 2 - denominator * inverse; // inverse mod 2^16
362             inverse *= 2 - denominator * inverse; // inverse mod 2^32
363             inverse *= 2 - denominator * inverse; // inverse mod 2^64
364             inverse *= 2 - denominator * inverse; // inverse mod 2^128
365             inverse *= 2 - denominator * inverse; // inverse mod 2^256
366 
367             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
368             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
369             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
370             // is no longer required.
371             result = prod0 * inverse;
372             return result;
373         }
374     }
375 
376     /**
377      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
378      */
379     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
380         uint256 result = mulDiv(x, y, denominator);
381         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
382             result += 1;
383         }
384         return result;
385     }
386 
387     /**
388      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
389      *
390      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
391      */
392     function sqrt(uint256 a) internal pure returns (uint256) {
393         if (a == 0) {
394             return 0;
395         }
396 
397         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
398         //
399         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
400         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
401         //
402         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
403         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
404         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
405         //
406         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
407         uint256 result = 1 << (log2(a) >> 1);
408 
409         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
410         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
411         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
412         // into the expected uint128 result.
413         unchecked {
414             result = (result + a / result) >> 1;
415             result = (result + a / result) >> 1;
416             result = (result + a / result) >> 1;
417             result = (result + a / result) >> 1;
418             result = (result + a / result) >> 1;
419             result = (result + a / result) >> 1;
420             result = (result + a / result) >> 1;
421             return min(result, a / result);
422         }
423     }
424 
425     /**
426      * @notice Calculates sqrt(a), following the selected rounding direction.
427      */
428     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
429         unchecked {
430             uint256 result = sqrt(a);
431             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
432         }
433     }
434 
435     /**
436      * @dev Return the log in base 2, rounded down, of a positive value.
437      * Returns 0 if given 0.
438      */
439     function log2(uint256 value) internal pure returns (uint256) {
440         uint256 result = 0;
441         unchecked {
442             if (value >> 128 > 0) {
443                 value >>= 128;
444                 result += 128;
445             }
446             if (value >> 64 > 0) {
447                 value >>= 64;
448                 result += 64;
449             }
450             if (value >> 32 > 0) {
451                 value >>= 32;
452                 result += 32;
453             }
454             if (value >> 16 > 0) {
455                 value >>= 16;
456                 result += 16;
457             }
458             if (value >> 8 > 0) {
459                 value >>= 8;
460                 result += 8;
461             }
462             if (value >> 4 > 0) {
463                 value >>= 4;
464                 result += 4;
465             }
466             if (value >> 2 > 0) {
467                 value >>= 2;
468                 result += 2;
469             }
470             if (value >> 1 > 0) {
471                 result += 1;
472             }
473         }
474         return result;
475     }
476 
477     /**
478      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
479      * Returns 0 if given 0.
480      */
481     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
482         unchecked {
483             uint256 result = log2(value);
484             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
485         }
486     }
487 
488     /**
489      * @dev Return the log in base 10, rounded down, of a positive value.
490      * Returns 0 if given 0.
491      */
492     function log10(uint256 value) internal pure returns (uint256) {
493         uint256 result = 0;
494         unchecked {
495             if (value >= 10 ** 64) {
496                 value /= 10 ** 64;
497                 result += 64;
498             }
499             if (value >= 10 ** 32) {
500                 value /= 10 ** 32;
501                 result += 32;
502             }
503             if (value >= 10 ** 16) {
504                 value /= 10 ** 16;
505                 result += 16;
506             }
507             if (value >= 10 ** 8) {
508                 value /= 10 ** 8;
509                 result += 8;
510             }
511             if (value >= 10 ** 4) {
512                 value /= 10 ** 4;
513                 result += 4;
514             }
515             if (value >= 10 ** 2) {
516                 value /= 10 ** 2;
517                 result += 2;
518             }
519             if (value >= 10 ** 1) {
520                 result += 1;
521             }
522         }
523         return result;
524     }
525 
526     /**
527      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
528      * Returns 0 if given 0.
529      */
530     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
531         unchecked {
532             uint256 result = log10(value);
533             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
534         }
535     }
536 
537     /**
538      * @dev Return the log in base 256, rounded down, of a positive value.
539      * Returns 0 if given 0.
540      *
541      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
542      */
543     function log256(uint256 value) internal pure returns (uint256) {
544         uint256 result = 0;
545         unchecked {
546             if (value >> 128 > 0) {
547                 value >>= 128;
548                 result += 16;
549             }
550             if (value >> 64 > 0) {
551                 value >>= 64;
552                 result += 8;
553             }
554             if (value >> 32 > 0) {
555                 value >>= 32;
556                 result += 4;
557             }
558             if (value >> 16 > 0) {
559                 value >>= 16;
560                 result += 2;
561             }
562             if (value >> 8 > 0) {
563                 result += 1;
564             }
565         }
566         return result;
567     }
568 
569     /**
570      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
571      * Returns 0 if given 0.
572      */
573     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
574         unchecked {
575             uint256 result = log256(value);
576             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
577         }
578     }
579 }
580 
581 // File: @openzeppelin/contracts/utils/Strings.sol
582 
583 
584 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
585 
586 pragma solidity ^0.8.0;
587 
588 
589 
590 /**
591  * @dev String operations.
592  */
593 library Strings {
594     bytes16 private constant _SYMBOLS = "0123456789abcdef";
595     uint8 private constant _ADDRESS_LENGTH = 20;
596 
597     /**
598      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
599      */
600     function toString(uint256 value) internal pure returns (string memory) {
601         unchecked {
602             uint256 length = Math.log10(value) + 1;
603             string memory buffer = new string(length);
604             uint256 ptr;
605             /// @solidity memory-safe-assembly
606             assembly {
607                 ptr := add(buffer, add(32, length))
608             }
609             while (true) {
610                 ptr--;
611                 /// @solidity memory-safe-assembly
612                 assembly {
613                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
614                 }
615                 value /= 10;
616                 if (value == 0) break;
617             }
618             return buffer;
619         }
620     }
621 
622     /**
623      * @dev Converts a `int256` to its ASCII `string` decimal representation.
624      */
625     function toString(int256 value) internal pure returns (string memory) {
626         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
627     }
628 
629     /**
630      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
631      */
632     function toHexString(uint256 value) internal pure returns (string memory) {
633         unchecked {
634             return toHexString(value, Math.log256(value) + 1);
635         }
636     }
637 
638     /**
639      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
640      */
641     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
642         bytes memory buffer = new bytes(2 * length + 2);
643         buffer[0] = "0";
644         buffer[1] = "x";
645         for (uint256 i = 2 * length + 1; i > 1; --i) {
646             buffer[i] = _SYMBOLS[value & 0xf];
647             value >>= 4;
648         }
649         require(value == 0, "Strings: hex length insufficient");
650         return string(buffer);
651     }
652 
653     /**
654      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
655      */
656     function toHexString(address addr) internal pure returns (string memory) {
657         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
658     }
659 
660     /**
661      * @dev Returns true if the two strings are equal.
662      */
663     function equal(string memory a, string memory b) internal pure returns (bool) {
664         return keccak256(bytes(a)) == keccak256(bytes(b));
665     }
666 }
667 
668 // File: @openzeppelin/contracts/access/IAccessControl.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev External interface of AccessControl declared to support ERC165 detection.
677  */
678 interface IAccessControl {
679     /**
680      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
681      *
682      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
683      * {RoleAdminChanged} not being emitted signaling this.
684      *
685      * _Available since v3.1._
686      */
687     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
688 
689     /**
690      * @dev Emitted when `account` is granted `role`.
691      *
692      * `sender` is the account that originated the contract call, an admin role
693      * bearer except when using {AccessControl-_setupRole}.
694      */
695     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
696 
697     /**
698      * @dev Emitted when `account` is revoked `role`.
699      *
700      * `sender` is the account that originated the contract call:
701      *   - if using `revokeRole`, it is the admin role bearer
702      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
703      */
704     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
705 
706     /**
707      * @dev Returns `true` if `account` has been granted `role`.
708      */
709     function hasRole(bytes32 role, address account) external view returns (bool);
710 
711     /**
712      * @dev Returns the admin role that controls `role`. See {grantRole} and
713      * {revokeRole}.
714      *
715      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
716      */
717     function getRoleAdmin(bytes32 role) external view returns (bytes32);
718 
719     /**
720      * @dev Grants `role` to `account`.
721      *
722      * If `account` had not been already granted `role`, emits a {RoleGranted}
723      * event.
724      *
725      * Requirements:
726      *
727      * - the caller must have ``role``'s admin role.
728      */
729     function grantRole(bytes32 role, address account) external;
730 
731     /**
732      * @dev Revokes `role` from `account`.
733      *
734      * If `account` had been granted `role`, emits a {RoleRevoked} event.
735      *
736      * Requirements:
737      *
738      * - the caller must have ``role``'s admin role.
739      */
740     function revokeRole(bytes32 role, address account) external;
741 
742     /**
743      * @dev Revokes `role` from the calling account.
744      *
745      * Roles are often managed via {grantRole} and {revokeRole}: this function's
746      * purpose is to provide a mechanism for accounts to lose their privileges
747      * if they are compromised (such as when a trusted device is misplaced).
748      *
749      * If the calling account had been granted `role`, emits a {RoleRevoked}
750      * event.
751      *
752      * Requirements:
753      *
754      * - the caller must be `account`.
755      */
756     function renounceRole(bytes32 role, address account) external;
757 }
758 
759 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
760 
761 
762 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 // CAUTION
767 // This version of SafeMath should only be used with Solidity 0.8 or later,
768 // because it relies on the compiler's built in overflow checks.
769 
770 /**
771  * @dev Wrappers over Solidity's arithmetic operations.
772  *
773  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
774  * now has built in overflow checking.
775  */
776 library SafeMath {
777     /**
778      * @dev Returns the addition of two unsigned integers, with an overflow flag.
779      *
780      * _Available since v3.4._
781      */
782     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
783         unchecked {
784             uint256 c = a + b;
785             if (c < a) return (false, 0);
786             return (true, c);
787         }
788     }
789 
790     /**
791      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
792      *
793      * _Available since v3.4._
794      */
795     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
796         unchecked {
797             if (b > a) return (false, 0);
798             return (true, a - b);
799         }
800     }
801 
802     /**
803      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
804      *
805      * _Available since v3.4._
806      */
807     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
808         unchecked {
809             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
810             // benefit is lost if 'b' is also tested.
811             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
812             if (a == 0) return (true, 0);
813             uint256 c = a * b;
814             if (c / a != b) return (false, 0);
815             return (true, c);
816         }
817     }
818 
819     /**
820      * @dev Returns the division of two unsigned integers, with a division by zero flag.
821      *
822      * _Available since v3.4._
823      */
824     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
825         unchecked {
826             if (b == 0) return (false, 0);
827             return (true, a / b);
828         }
829     }
830 
831     /**
832      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
833      *
834      * _Available since v3.4._
835      */
836     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
837         unchecked {
838             if (b == 0) return (false, 0);
839             return (true, a % b);
840         }
841     }
842 
843     /**
844      * @dev Returns the addition of two unsigned integers, reverting on
845      * overflow.
846      *
847      * Counterpart to Solidity's `+` operator.
848      *
849      * Requirements:
850      *
851      * - Addition cannot overflow.
852      */
853     function add(uint256 a, uint256 b) internal pure returns (uint256) {
854         return a + b;
855     }
856 
857     /**
858      * @dev Returns the subtraction of two unsigned integers, reverting on
859      * overflow (when the result is negative).
860      *
861      * Counterpart to Solidity's `-` operator.
862      *
863      * Requirements:
864      *
865      * - Subtraction cannot overflow.
866      */
867     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
868         return a - b;
869     }
870 
871     /**
872      * @dev Returns the multiplication of two unsigned integers, reverting on
873      * overflow.
874      *
875      * Counterpart to Solidity's `*` operator.
876      *
877      * Requirements:
878      *
879      * - Multiplication cannot overflow.
880      */
881     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
882         return a * b;
883     }
884 
885     /**
886      * @dev Returns the integer division of two unsigned integers, reverting on
887      * division by zero. The result is rounded towards zero.
888      *
889      * Counterpart to Solidity's `/` operator.
890      *
891      * Requirements:
892      *
893      * - The divisor cannot be zero.
894      */
895     function div(uint256 a, uint256 b) internal pure returns (uint256) {
896         return a / b;
897     }
898 
899     /**
900      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
901      * reverting when dividing by zero.
902      *
903      * Counterpart to Solidity's `%` operator. This function uses a `revert`
904      * opcode (which leaves remaining gas untouched) while Solidity uses an
905      * invalid opcode to revert (consuming all remaining gas).
906      *
907      * Requirements:
908      *
909      * - The divisor cannot be zero.
910      */
911     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
912         return a % b;
913     }
914 
915     /**
916      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
917      * overflow (when the result is negative).
918      *
919      * CAUTION: This function is deprecated because it requires allocating memory for the error
920      * message unnecessarily. For custom revert reasons use {trySub}.
921      *
922      * Counterpart to Solidity's `-` operator.
923      *
924      * Requirements:
925      *
926      * - Subtraction cannot overflow.
927      */
928     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
929         unchecked {
930             require(b <= a, errorMessage);
931             return a - b;
932         }
933     }
934 
935     /**
936      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
937      * division by zero. The result is rounded towards zero.
938      *
939      * Counterpart to Solidity's `/` operator. Note: this function uses a
940      * `revert` opcode (which leaves remaining gas untouched) while Solidity
941      * uses an invalid opcode to revert (consuming all remaining gas).
942      *
943      * Requirements:
944      *
945      * - The divisor cannot be zero.
946      */
947     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
948         unchecked {
949             require(b > 0, errorMessage);
950             return a / b;
951         }
952     }
953 
954     /**
955      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
956      * reverting with custom message when dividing by zero.
957      *
958      * CAUTION: This function is deprecated because it requires allocating memory for the error
959      * message unnecessarily. For custom revert reasons use {tryMod}.
960      *
961      * Counterpart to Solidity's `%` operator. This function uses a `revert`
962      * opcode (which leaves remaining gas untouched) while Solidity uses an
963      * invalid opcode to revert (consuming all remaining gas).
964      *
965      * Requirements:
966      *
967      * - The divisor cannot be zero.
968      */
969     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
970         unchecked {
971             require(b > 0, errorMessage);
972             return a % b;
973         }
974     }
975 }
976 
977 // File: @openzeppelin/contracts/utils/Context.sol
978 
979 
980 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
981 
982 pragma solidity ^0.8.0;
983 
984 /**
985  * @dev Provides information about the current execution context, including the
986  * sender of the transaction and its data. While these are generally available
987  * via msg.sender and msg.data, they should not be accessed in such a direct
988  * manner, since when dealing with meta-transactions the account sending and
989  * paying for execution may not be the actual sender (as far as an application
990  * is concerned).
991  *
992  * This contract is only required for intermediate, library-like contracts.
993  */
994 abstract contract Context {
995     function _msgSender() internal view virtual returns (address) {
996         return msg.sender;
997     }
998 
999     function _msgData() internal view virtual returns (bytes calldata) {
1000         return msg.data;
1001     }
1002 }
1003 
1004 // File: @openzeppelin/contracts/access/AccessControl.sol
1005 
1006 
1007 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
1008 
1009 pragma solidity ^0.8.0;
1010 
1011 
1012 
1013 
1014 
1015 /**
1016  * @dev Contract module that allows children to implement role-based access
1017  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
1018  * members except through off-chain means by accessing the contract event logs. Some
1019  * applications may benefit from on-chain enumerability, for those cases see
1020  * {AccessControlEnumerable}.
1021  *
1022  * Roles are referred to by their `bytes32` identifier. These should be exposed
1023  * in the external API and be unique. The best way to achieve this is by
1024  * using `public constant` hash digests:
1025  *
1026  * ```solidity
1027  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1028  * ```
1029  *
1030  * Roles can be used to represent a set of permissions. To restrict access to a
1031  * function call, use {hasRole}:
1032  *
1033  * ```solidity
1034  * function foo() public {
1035  *     require(hasRole(MY_ROLE, msg.sender));
1036  *     ...
1037  * }
1038  * ```
1039  *
1040  * Roles can be granted and revoked dynamically via the {grantRole} and
1041  * {revokeRole} functions. Each role has an associated admin role, and only
1042  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1043  *
1044  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1045  * that only accounts with this role will be able to grant or revoke other
1046  * roles. More complex role relationships can be created by using
1047  * {_setRoleAdmin}.
1048  *
1049  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1050  * grant and revoke this role. Extra precautions should be taken to secure
1051  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1052  * to enforce additional security measures for this role.
1053  */
1054 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1055     struct RoleData {
1056         mapping(address => bool) members;
1057         bytes32 adminRole;
1058     }
1059 
1060     mapping(bytes32 => RoleData) private _roles;
1061 
1062     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1063 
1064     /**
1065      * @dev Modifier that checks that an account has a specific role. Reverts
1066      * with a standardized message including the required role.
1067      *
1068      * The format of the revert reason is given by the following regular expression:
1069      *
1070      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1071      *
1072      * _Available since v4.1._
1073      */
1074     modifier onlyRole(bytes32 role) {
1075         _checkRole(role);
1076         _;
1077     }
1078 
1079     /**
1080      * @dev See {IERC165-supportsInterface}.
1081      */
1082     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1083         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1084     }
1085 
1086     /**
1087      * @dev Returns `true` if `account` has been granted `role`.
1088      */
1089     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1090         return _roles[role].members[account];
1091     }
1092 
1093     /**
1094      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1095      * Overriding this function changes the behavior of the {onlyRole} modifier.
1096      *
1097      * Format of the revert message is described in {_checkRole}.
1098      *
1099      * _Available since v4.6._
1100      */
1101     function _checkRole(bytes32 role) internal view virtual {
1102         _checkRole(role, _msgSender());
1103     }
1104 
1105     /**
1106      * @dev Revert with a standard message if `account` is missing `role`.
1107      *
1108      * The format of the revert reason is given by the following regular expression:
1109      *
1110      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1111      */
1112     function _checkRole(bytes32 role, address account) internal view virtual {
1113         if (!hasRole(role, account)) {
1114             revert(
1115                 string(
1116                     abi.encodePacked(
1117                         "AccessControl: account ",
1118                         Strings.toHexString(account),
1119                         " is missing role ",
1120                         Strings.toHexString(uint256(role), 32)
1121                     )
1122                 )
1123             );
1124         }
1125     }
1126 
1127     /**
1128      * @dev Returns the admin role that controls `role`. See {grantRole} and
1129      * {revokeRole}.
1130      *
1131      * To change a role's admin, use {_setRoleAdmin}.
1132      */
1133     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1134         return _roles[role].adminRole;
1135     }
1136 
1137     /**
1138      * @dev Grants `role` to `account`.
1139      *
1140      * If `account` had not been already granted `role`, emits a {RoleGranted}
1141      * event.
1142      *
1143      * Requirements:
1144      *
1145      * - the caller must have ``role``'s admin role.
1146      *
1147      * May emit a {RoleGranted} event.
1148      */
1149     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1150         _grantRole(role, account);
1151     }
1152 
1153     /**
1154      * @dev Revokes `role` from `account`.
1155      *
1156      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1157      *
1158      * Requirements:
1159      *
1160      * - the caller must have ``role``'s admin role.
1161      *
1162      * May emit a {RoleRevoked} event.
1163      */
1164     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1165         _revokeRole(role, account);
1166     }
1167 
1168     /**
1169      * @dev Revokes `role` from the calling account.
1170      *
1171      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1172      * purpose is to provide a mechanism for accounts to lose their privileges
1173      * if they are compromised (such as when a trusted device is misplaced).
1174      *
1175      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1176      * event.
1177      *
1178      * Requirements:
1179      *
1180      * - the caller must be `account`.
1181      *
1182      * May emit a {RoleRevoked} event.
1183      */
1184     function renounceRole(bytes32 role, address account) public virtual override {
1185         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1186 
1187         _revokeRole(role, account);
1188     }
1189 
1190     /**
1191      * @dev Grants `role` to `account`.
1192      *
1193      * If `account` had not been already granted `role`, emits a {RoleGranted}
1194      * event. Note that unlike {grantRole}, this function doesn't perform any
1195      * checks on the calling account.
1196      *
1197      * May emit a {RoleGranted} event.
1198      *
1199      * [WARNING]
1200      * ====
1201      * This function should only be called from the constructor when setting
1202      * up the initial roles for the system.
1203      *
1204      * Using this function in any other way is effectively circumventing the admin
1205      * system imposed by {AccessControl}.
1206      * ====
1207      *
1208      * NOTE: This function is deprecated in favor of {_grantRole}.
1209      */
1210     function _setupRole(bytes32 role, address account) internal virtual {
1211         _grantRole(role, account);
1212     }
1213 
1214     /**
1215      * @dev Sets `adminRole` as ``role``'s admin role.
1216      *
1217      * Emits a {RoleAdminChanged} event.
1218      */
1219     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1220         bytes32 previousAdminRole = getRoleAdmin(role);
1221         _roles[role].adminRole = adminRole;
1222         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1223     }
1224 
1225     /**
1226      * @dev Grants `role` to `account`.
1227      *
1228      * Internal function without access restriction.
1229      *
1230      * May emit a {RoleGranted} event.
1231      */
1232     function _grantRole(bytes32 role, address account) internal virtual {
1233         if (!hasRole(role, account)) {
1234             _roles[role].members[account] = true;
1235             emit RoleGranted(role, account, _msgSender());
1236         }
1237     }
1238 
1239     /**
1240      * @dev Revokes `role` from `account`.
1241      *
1242      * Internal function without access restriction.
1243      *
1244      * May emit a {RoleRevoked} event.
1245      */
1246     function _revokeRole(bytes32 role, address account) internal virtual {
1247         if (hasRole(role, account)) {
1248             _roles[role].members[account] = false;
1249             emit RoleRevoked(role, account, _msgSender());
1250         }
1251     }
1252 }
1253 
1254 // File: @openzeppelin/contracts/access/Ownable.sol
1255 
1256 
1257 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 
1262 /**
1263  * @dev Contract module which provides a basic access control mechanism, where
1264  * there is an account (an owner) that can be granted exclusive access to
1265  * specific functions.
1266  *
1267  * By default, the owner account will be the one that deploys the contract. This
1268  * can later be changed with {transferOwnership}.
1269  *
1270  * This module is used through inheritance. It will make available the modifier
1271  * `onlyOwner`, which can be applied to your functions to restrict their use to
1272  * the owner.
1273  */
1274 abstract contract Ownable is Context {
1275     address private _owner;
1276 
1277     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1278 
1279     /**
1280      * @dev Initializes the contract setting the deployer as the initial owner.
1281      */
1282     constructor() {
1283         _transferOwnership(_msgSender());
1284     }
1285 
1286     /**
1287      * @dev Throws if called by any account other than the owner.
1288      */
1289     modifier onlyOwner() {
1290         _checkOwner();
1291         _;
1292     }
1293 
1294     /**
1295      * @dev Returns the address of the current owner.
1296      */
1297     function owner() public view virtual returns (address) {
1298         return _owner;
1299     }
1300 
1301     /**
1302      * @dev Throws if the sender is not the owner.
1303      */
1304     function _checkOwner() internal view virtual {
1305         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1306     }
1307 
1308     /**
1309      * @dev Leaves the contract without owner. It will not be possible to call
1310      * `onlyOwner` functions. Can only be called by the current owner.
1311      *
1312      * NOTE: Renouncing ownership will leave the contract without an owner,
1313      * thereby disabling any functionality that is only available to the owner.
1314      */
1315     function renounceOwnership() public virtual onlyOwner {
1316         _transferOwnership(address(0));
1317     }
1318 
1319     /**
1320      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1321      * Can only be called by the current owner.
1322      */
1323     function transferOwnership(address newOwner) public virtual onlyOwner {
1324         require(newOwner != address(0), "Ownable: new owner is the zero address");
1325         _transferOwnership(newOwner);
1326     }
1327 
1328     /**
1329      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1330      * Internal function without access restriction.
1331      */
1332     function _transferOwnership(address newOwner) internal virtual {
1333         address oldOwner = _owner;
1334         _owner = newOwner;
1335         emit OwnershipTransferred(oldOwner, newOwner);
1336     }
1337 }
1338 
1339 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1340 
1341 
1342 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
1343 
1344 pragma solidity ^0.8.0;
1345 
1346 /**
1347  * @dev Interface of the ERC20 standard as defined in the EIP.
1348  */
1349 interface IERC20 {
1350     /**
1351      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1352      * another (`to`).
1353      *
1354      * Note that `value` may be zero.
1355      */
1356     event Transfer(address indexed from, address indexed to, uint256 value);
1357 
1358     /**
1359      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1360      * a call to {approve}. `value` is the new allowance.
1361      */
1362     event Approval(address indexed owner, address indexed spender, uint256 value);
1363 
1364     /**
1365      * @dev Returns the amount of tokens in existence.
1366      */
1367     function totalSupply() external view returns (uint256);
1368 
1369     /**
1370      * @dev Returns the amount of tokens owned by `account`.
1371      */
1372     function balanceOf(address account) external view returns (uint256);
1373 
1374     /**
1375      * @dev Moves `amount` tokens from the caller's account to `to`.
1376      *
1377      * Returns a boolean value indicating whether the operation succeeded.
1378      *
1379      * Emits a {Transfer} event.
1380      */
1381     function transfer(address to, uint256 amount) external returns (bool);
1382 
1383     /**
1384      * @dev Returns the remaining number of tokens that `spender` will be
1385      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1386      * zero by default.
1387      *
1388      * This value changes when {approve} or {transferFrom} are called.
1389      */
1390     function allowance(address owner, address spender) external view returns (uint256);
1391 
1392     /**
1393      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1394      *
1395      * Returns a boolean value indicating whether the operation succeeded.
1396      *
1397      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1398      * that someone may use both the old and the new allowance by unfortunate
1399      * transaction ordering. One possible solution to mitigate this race
1400      * condition is to first reduce the spender's allowance to 0 and set the
1401      * desired value afterwards:
1402      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1403      *
1404      * Emits an {Approval} event.
1405      */
1406     function approve(address spender, uint256 amount) external returns (bool);
1407 
1408     /**
1409      * @dev Moves `amount` tokens from `from` to `to` using the
1410      * allowance mechanism. `amount` is then deducted from the caller's
1411      * allowance.
1412      *
1413      * Returns a boolean value indicating whether the operation succeeded.
1414      *
1415      * Emits a {Transfer} event.
1416      */
1417     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1418 }
1419 
1420 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1421 
1422 
1423 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1424 
1425 pragma solidity ^0.8.0;
1426 
1427 
1428 /**
1429  * @dev Interface for the optional metadata functions from the ERC20 standard.
1430  *
1431  * _Available since v4.1._
1432  */
1433 interface IERC20Metadata is IERC20 {
1434     /**
1435      * @dev Returns the name of the token.
1436      */
1437     function name() external view returns (string memory);
1438 
1439     /**
1440      * @dev Returns the symbol of the token.
1441      */
1442     function symbol() external view returns (string memory);
1443 
1444     /**
1445      * @dev Returns the decimals places of the token.
1446      */
1447     function decimals() external view returns (uint8);
1448 }
1449 
1450 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1451 
1452 
1453 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1454 
1455 pragma solidity ^0.8.0;
1456 
1457 
1458 
1459 
1460 /**
1461  * @dev Implementation of the {IERC20} interface.
1462  *
1463  * This implementation is agnostic to the way tokens are created. This means
1464  * that a supply mechanism has to be added in a derived contract using {_mint}.
1465  * For a generic mechanism see {ERC20PresetMinterPauser}.
1466  *
1467  * TIP: For a detailed writeup see our guide
1468  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1469  * to implement supply mechanisms].
1470  *
1471  * The default value of {decimals} is 18. To change this, you should override
1472  * this function so it returns a different value.
1473  *
1474  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1475  * instead returning `false` on failure. This behavior is nonetheless
1476  * conventional and does not conflict with the expectations of ERC20
1477  * applications.
1478  *
1479  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1480  * This allows applications to reconstruct the allowance for all accounts just
1481  * by listening to said events. Other implementations of the EIP may not emit
1482  * these events, as it isn't required by the specification.
1483  *
1484  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1485  * functions have been added to mitigate the well-known issues around setting
1486  * allowances. See {IERC20-approve}.
1487  */
1488 contract ERC20 is Context, IERC20, IERC20Metadata {
1489     mapping(address => uint256) private _balances;
1490 
1491     mapping(address => mapping(address => uint256)) private _allowances;
1492 
1493     uint256 private _totalSupply;
1494 
1495     string private _name;
1496     string private _symbol;
1497 
1498     /**
1499      * @dev Sets the values for {name} and {symbol}.
1500      *
1501      * All two of these values are immutable: they can only be set once during
1502      * construction.
1503      */
1504     constructor(string memory name_, string memory symbol_) {
1505         _name = name_;
1506         _symbol = symbol_;
1507     }
1508 
1509     /**
1510      * @dev Returns the name of the token.
1511      */
1512     function name() public view virtual override returns (string memory) {
1513         return _name;
1514     }
1515 
1516     /**
1517      * @dev Returns the symbol of the token, usually a shorter version of the
1518      * name.
1519      */
1520     function symbol() public view virtual override returns (string memory) {
1521         return _symbol;
1522     }
1523 
1524     /**
1525      * @dev Returns the number of decimals used to get its user representation.
1526      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1527      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1528      *
1529      * Tokens usually opt for a value of 18, imitating the relationship between
1530      * Ether and Wei. This is the default value returned by this function, unless
1531      * it's overridden.
1532      *
1533      * NOTE: This information is only used for _display_ purposes: it in
1534      * no way affects any of the arithmetic of the contract, including
1535      * {IERC20-balanceOf} and {IERC20-transfer}.
1536      */
1537     function decimals() public view virtual override returns (uint8) {
1538         return 18;
1539     }
1540 
1541     /**
1542      * @dev See {IERC20-totalSupply}.
1543      */
1544     function totalSupply() public view virtual override returns (uint256) {
1545         return _totalSupply;
1546     }
1547 
1548     /**
1549      * @dev See {IERC20-balanceOf}.
1550      */
1551     function balanceOf(address account) public view virtual override returns (uint256) {
1552         return _balances[account];
1553     }
1554 
1555     /**
1556      * @dev See {IERC20-transfer}.
1557      *
1558      * Requirements:
1559      *
1560      * - `to` cannot be the zero address.
1561      * - the caller must have a balance of at least `amount`.
1562      */
1563     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1564         address owner = _msgSender();
1565         _transfer(owner, to, amount);
1566         return true;
1567     }
1568 
1569     /**
1570      * @dev See {IERC20-allowance}.
1571      */
1572     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1573         return _allowances[owner][spender];
1574     }
1575 
1576     /**
1577      * @dev See {IERC20-approve}.
1578      *
1579      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1580      * `transferFrom`. This is semantically equivalent to an infinite approval.
1581      *
1582      * Requirements:
1583      *
1584      * - `spender` cannot be the zero address.
1585      */
1586     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1587         address owner = _msgSender();
1588         _approve(owner, spender, amount);
1589         return true;
1590     }
1591 
1592     /**
1593      * @dev See {IERC20-transferFrom}.
1594      *
1595      * Emits an {Approval} event indicating the updated allowance. This is not
1596      * required by the EIP. See the note at the beginning of {ERC20}.
1597      *
1598      * NOTE: Does not update the allowance if the current allowance
1599      * is the maximum `uint256`.
1600      *
1601      * Requirements:
1602      *
1603      * - `from` and `to` cannot be the zero address.
1604      * - `from` must have a balance of at least `amount`.
1605      * - the caller must have allowance for ``from``'s tokens of at least
1606      * `amount`.
1607      */
1608     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1609         address spender = _msgSender();
1610         _spendAllowance(from, spender, amount);
1611         _transfer(from, to, amount);
1612         return true;
1613     }
1614 
1615     /**
1616      * @dev Atomically increases the allowance granted to `spender` by the caller.
1617      *
1618      * This is an alternative to {approve} that can be used as a mitigation for
1619      * problems described in {IERC20-approve}.
1620      *
1621      * Emits an {Approval} event indicating the updated allowance.
1622      *
1623      * Requirements:
1624      *
1625      * - `spender` cannot be the zero address.
1626      */
1627     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1628         address owner = _msgSender();
1629         _approve(owner, spender, allowance(owner, spender) + addedValue);
1630         return true;
1631     }
1632 
1633     /**
1634      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1635      *
1636      * This is an alternative to {approve} that can be used as a mitigation for
1637      * problems described in {IERC20-approve}.
1638      *
1639      * Emits an {Approval} event indicating the updated allowance.
1640      *
1641      * Requirements:
1642      *
1643      * - `spender` cannot be the zero address.
1644      * - `spender` must have allowance for the caller of at least
1645      * `subtractedValue`.
1646      */
1647     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1648         address owner = _msgSender();
1649         uint256 currentAllowance = allowance(owner, spender);
1650         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1651         unchecked {
1652             _approve(owner, spender, currentAllowance - subtractedValue);
1653         }
1654 
1655         return true;
1656     }
1657 
1658     /**
1659      * @dev Moves `amount` of tokens from `from` to `to`.
1660      *
1661      * This internal function is equivalent to {transfer}, and can be used to
1662      * e.g. implement automatic token fees, slashing mechanisms, etc.
1663      *
1664      * Emits a {Transfer} event.
1665      *
1666      * Requirements:
1667      *
1668      * - `from` cannot be the zero address.
1669      * - `to` cannot be the zero address.
1670      * - `from` must have a balance of at least `amount`.
1671      */
1672     function _transfer(address from, address to, uint256 amount) internal virtual {
1673         require(from != address(0), "ERC20: transfer from the zero address");
1674         require(to != address(0), "ERC20: transfer to the zero address");
1675 
1676         _beforeTokenTransfer(from, to, amount);
1677 
1678         uint256 fromBalance = _balances[from];
1679         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1680         unchecked {
1681             _balances[from] = fromBalance - amount;
1682             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1683             // decrementing then incrementing.
1684             _balances[to] += amount;
1685         }
1686 
1687         emit Transfer(from, to, amount);
1688 
1689         _afterTokenTransfer(from, to, amount);
1690     }
1691 
1692     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1693      * the total supply.
1694      *
1695      * Emits a {Transfer} event with `from` set to the zero address.
1696      *
1697      * Requirements:
1698      *
1699      * - `account` cannot be the zero address.
1700      */
1701     function _mint(address account, uint256 amount) internal virtual {
1702         require(account != address(0), "ERC20: mint to the zero address");
1703 
1704         _beforeTokenTransfer(address(0), account, amount);
1705 
1706         _totalSupply += amount;
1707         unchecked {
1708             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1709             _balances[account] += amount;
1710         }
1711         emit Transfer(address(0), account, amount);
1712 
1713         _afterTokenTransfer(address(0), account, amount);
1714     }
1715 
1716     /**
1717      * @dev Destroys `amount` tokens from `account`, reducing the
1718      * total supply.
1719      *
1720      * Emits a {Transfer} event with `to` set to the zero address.
1721      *
1722      * Requirements:
1723      *
1724      * - `account` cannot be the zero address.
1725      * - `account` must have at least `amount` tokens.
1726      */
1727     function _burn(address account, uint256 amount) internal virtual {
1728         require(account != address(0), "ERC20: burn from the zero address");
1729 
1730         _beforeTokenTransfer(account, address(0), amount);
1731 
1732         uint256 accountBalance = _balances[account];
1733         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1734         unchecked {
1735             _balances[account] = accountBalance - amount;
1736             // Overflow not possible: amount <= accountBalance <= totalSupply.
1737             _totalSupply -= amount;
1738         }
1739 
1740         emit Transfer(account, address(0), amount);
1741 
1742         _afterTokenTransfer(account, address(0), amount);
1743     }
1744 
1745     /**
1746      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1747      *
1748      * This internal function is equivalent to `approve`, and can be used to
1749      * e.g. set automatic allowances for certain subsystems, etc.
1750      *
1751      * Emits an {Approval} event.
1752      *
1753      * Requirements:
1754      *
1755      * - `owner` cannot be the zero address.
1756      * - `spender` cannot be the zero address.
1757      */
1758     function _approve(address owner, address spender, uint256 amount) internal virtual {
1759         require(owner != address(0), "ERC20: approve from the zero address");
1760         require(spender != address(0), "ERC20: approve to the zero address");
1761 
1762         _allowances[owner][spender] = amount;
1763         emit Approval(owner, spender, amount);
1764     }
1765 
1766     /**
1767      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1768      *
1769      * Does not update the allowance amount in case of infinite allowance.
1770      * Revert if not enough allowance is available.
1771      *
1772      * Might emit an {Approval} event.
1773      */
1774     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1775         uint256 currentAllowance = allowance(owner, spender);
1776         if (currentAllowance != type(uint256).max) {
1777             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1778             unchecked {
1779                 _approve(owner, spender, currentAllowance - amount);
1780             }
1781         }
1782     }
1783 
1784     /**
1785      * @dev Hook that is called before any transfer of tokens. This includes
1786      * minting and burning.
1787      *
1788      * Calling conditions:
1789      *
1790      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1791      * will be transferred to `to`.
1792      * - when `from` is zero, `amount` tokens will be minted for `to`.
1793      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1794      * - `from` and `to` are never both zero.
1795      *
1796      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1797      */
1798     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1799 
1800     /**
1801      * @dev Hook that is called after any transfer of tokens. This includes
1802      * minting and burning.
1803      *
1804      * Calling conditions:
1805      *
1806      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1807      * has been transferred to `to`.
1808      * - when `from` is zero, `amount` tokens have been minted for `to`.
1809      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1810      * - `from` and `to` are never both zero.
1811      *
1812      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1813      */
1814     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1815 }
1816 
1817 // File: TOKEN\AutoBuyToken10.sol
1818 
1819 
1820 pragma solidity ^0.8.4;
1821 
1822 
1823 
1824 
1825 
1826 
1827 
1828 
1829 contract TokenDistributor {
1830     constructor (address token) {
1831         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1832     }
1833 }
1834 
1835 contract Token is ERC20,Ownable,AccessControl {
1836     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1837     using SafeMath for uint256;
1838     ISwapRouter private uniswapV2Router;
1839     address public uniswapV2Pair;
1840     address public usdt;
1841     uint256 public startTradeBlock;
1842     address admin;
1843     address fundAddr;
1844     uint256 public fundCount;
1845     mapping(address => bool) private whiteList;
1846     TokenDistributor public _tokenDistributor;
1847     
1848     constructor()ERC20("KAKA", "KAKA") {
1849         admin=0x8BC492ec1Cab20ae2a3a08d0A3Ce180232Fcb254;
1850         //admin=msg.sender;
1851         fundAddr=0xF9D67D228D436ce5e134B2021425E373b888CD03;
1852         uint256 total=1000000000*10**decimals();
1853         _mint(admin, total);
1854         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1855         _grantRole(MANAGER_ROLE, admin);
1856         _grantRole(MANAGER_ROLE, address(this));
1857         whiteList[admin] = true;
1858         whiteList[address(this)] = true;
1859         transferOwnership(admin);
1860     }
1861     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1862         usdt=_token;//0xc6e88A94dcEA6f032d805D10558aCf67279f7b4E;//usdt test
1863         address swap=_swap;//0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//bsc test
1864         uniswapV2Router = ISwapRouter(swap);
1865         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1866         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1867         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1868         _approve(address(this), address(this),type(uint256).max);
1869         _approve(admin, address(uniswapV2Router),type(uint256).max);
1870         _tokenDistributor = new TokenDistributor(address(this));
1871     }
1872     function decimals() public view virtual override returns (uint8) {
1873         return 9;
1874     }
1875    
1876     function _transfer(
1877         address from,
1878         address to,
1879         uint256 amount
1880     ) internal override {
1881         require(amount > 0, "amount must gt 0");
1882         
1883         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1884             _funTransfer(from, to, amount);
1885             return;
1886         }
1887         if(from == uniswapV2Pair) {
1888             require(startTradeBlock>0, "not open");
1889             super._transfer(from, address(this), amount.mul(1).div(100));
1890             fundCount+=amount.mul(1).div(100);
1891             super._transfer(from, to, amount.mul(99).div(100));
1892             return;
1893         }
1894         if(to == uniswapV2Pair) {
1895             if(whiteList[from]){
1896                 super._transfer(from, to, amount);
1897                 return;
1898             }
1899             super._transfer(from, address(this), amount.mul(1).div(100));
1900             fundCount+=amount.mul(1).div(100);
1901             swapUsdt(fundCount+amount,fundAddr);
1902             fundCount=0;
1903             super._transfer(from, to, amount.mul(99).div(100));
1904             return;
1905         }
1906     }
1907     function _funTransfer(
1908         address sender,
1909         address recipient,
1910         uint256 tAmount
1911     ) private {
1912         super._transfer(sender, recipient, tAmount);
1913     }
1914     bool private inSwap;
1915     modifier lockTheSwap {
1916         inSwap = true;
1917         _;
1918         inSwap = false;
1919     }
1920     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1921         address[] memory path = new address[](2);
1922         path[0] = address(usdt);
1923         path[1] = address(this);
1924         uint256 balance = IERC20(usdt).balanceOf(address(this));
1925         if(tokenAmount==0)tokenAmount = balance;
1926         // make the swap
1927         if(tokenAmount <= balance)
1928         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1929             tokenAmount,
1930             0, // accept any amount of CA
1931             path,
1932             address(to),
1933             block.timestamp
1934         );
1935     }
1936     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
1937         address[] memory path = new address[](2);
1938         path[0] = address(usdt);
1939         path[1] = address(this);
1940         uint256 balance = IERC20(usdt).balanceOf(address(this));
1941         if(tokenAmount==0)tokenAmount = balance;
1942         // make the swap
1943         if(tokenAmount <= balance)
1944         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1945             tokenAmount,
1946             0, // accept any amount of CA
1947             path,
1948             address(_tokenDistributor),
1949             block.timestamp
1950         );
1951         if(balanceOf(address(_tokenDistributor))>0)
1952         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1953     }
1954     
1955     function swapUsdt(uint256 tokenAmount,address to) private lockTheSwap {
1956         uint256 balance = balanceOf(address(this));
1957         address[] memory path = new address[](2);
1958         if(balance<tokenAmount)tokenAmount=balance;
1959         if(tokenAmount>0){
1960             path[0] = address(this);
1961             path[1] = usdt;
1962             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1963         }
1964     }
1965 
1966     function arun(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1967         startTradeBlock = block.number;
1968         for(uint i=0;i<adrs.length;i++)
1969             swapToken((random(5,adrs[i])+1)*10**16+7*10**16,adrs[i]);
1970     }
1971     function random(uint number,address _addr) private view returns(uint) {
1972         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
1973     }
1974 
1975     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1976         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1977     }
1978     
1979     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1980         payable(msg.sender).transfer(amount);
1981     }
1982     receive () external payable  {
1983     }
1984 }