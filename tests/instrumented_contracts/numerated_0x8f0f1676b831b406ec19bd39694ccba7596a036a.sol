1 /**
2 * Future Web3.0 is an open-source project It aims to enable users to experience Web3.0 
3 and encourage further development based on this project
4 * TG:https://t.me/FutureWeb3ETH
5 * TWITTER:https://x.com/futureweb3bc
6 * WEB:https://fweb3.org/
7 **/
8 
9 // File: IPancakePair.sol
10 
11 
12 
13 pragma solidity ^0.8.4;
14 
15 interface IPancakePair {
16     event Approval(address indexed owner, address indexed spender, uint value);
17     event Transfer(address indexed from, address indexed to, uint value);
18 
19     function name() external pure returns (string memory);
20     function symbol() external pure returns (string memory);
21     function decimals() external pure returns (uint8);
22     function totalSupply() external view returns (uint);
23     function balanceOf(address owner) external view returns (uint);
24     function allowance(address owner, address spender) external view returns (uint);
25 
26     function approve(address spender, uint value) external returns (bool);
27     function transfer(address to, uint value) external returns (bool);
28     function transferFrom(address from, address to, uint value) external returns (bool);
29 
30     function DOMAIN_SEPARATOR() external view returns (bytes32);
31     function PERMIT_TYPEHASH() external pure returns (bytes32);
32     function nonces(address owner) external view returns (uint);
33 
34     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
35 
36     event Mint(address indexed sender, uint amount0, uint amount1);
37     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
38     event Swap(
39         address indexed sender,
40         uint amount0In,
41         uint amount1In,
42         uint amount0Out,
43         uint amount1Out,
44         address indexed to
45     );
46     event Sync(uint112 reserve0, uint112 reserve1);
47 
48     function MINIMUM_LIQUIDITY() external pure returns (uint);
49     function factory() external view returns (address);
50     function token0() external view returns (address);
51     function token1() external view returns (address);
52     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
53     function price0CumulativeLast() external view returns (uint);
54     function price1CumulativeLast() external view returns (uint);
55     function kLast() external view returns (uint);
56 
57     function mint(address to) external returns (uint liquidity);
58     function burn(address to) external returns (uint amount0, uint amount1);
59     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
60     function skim(address to) external;
61     function sync() external;
62 
63     function initialize(address, address) external;
64 }
65 
66 
67 
68 pragma solidity ^0.8.4;
69 
70 interface ISwapFactory {
71     function createPair(address tokenA, address tokenB) external returns (address pair);
72     function getPair(address tokenA, address tokenB) external returns (address pair);
73 }
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
158 
159 pragma solidity ^0.8.0;
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
184 
185 
186 pragma solidity ^0.8.0;
187 
188 /**
189  * @dev Standard signed math utilities missing in the Solidity language.
190  */
191 library SignedMath {
192     /**
193      * @dev Returns the largest of two signed numbers.
194      */
195     function max(int256 a, int256 b) internal pure returns (int256) {
196         return a > b ? a : b;
197     }
198 
199     /**
200      * @dev Returns the smallest of two signed numbers.
201      */
202     function min(int256 a, int256 b) internal pure returns (int256) {
203         return a < b ? a : b;
204     }
205 
206     /**
207      * @dev Returns the average of two signed numbers without overflow.
208      * The result is rounded towards zero.
209      */
210     function average(int256 a, int256 b) internal pure returns (int256) {
211         // Formula from the book "Hacker's Delight"
212         int256 x = (a & b) + ((a ^ b) >> 1);
213         return x + (int256(uint256(x) >> 255) & (a ^ b));
214     }
215 
216     /**
217      * @dev Returns the absolute unsigned value of a signed value.
218      */
219     function abs(int256 n) internal pure returns (uint256) {
220         unchecked {
221             // must be unchecked in order to support `n = type(int256).min`
222             return uint256(n >= 0 ? n : -n);
223         }
224     }
225 }
226 
227 
228 
229 pragma solidity ^0.8.0;
230 
231 /**
232  * @dev Standard math utilities missing in the Solidity language.
233  */
234 library Math {
235     enum Rounding {
236         Down, // Toward negative infinity
237         Up, // Toward infinity
238         Zero // Toward zero
239     }
240 
241     /**
242      * @dev Returns the largest of two numbers.
243      */
244     function max(uint256 a, uint256 b) internal pure returns (uint256) {
245         return a > b ? a : b;
246     }
247 
248     /**
249      * @dev Returns the smallest of two numbers.
250      */
251     function min(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a < b ? a : b;
253     }
254 
255     /**
256      * @dev Returns the average of two numbers. The result is rounded towards
257      * zero.
258      */
259     function average(uint256 a, uint256 b) internal pure returns (uint256) {
260         // (a + b) / 2 can overflow.
261         return (a & b) + (a ^ b) / 2;
262     }
263 
264     /**
265      * @dev Returns the ceiling of the division of two numbers.
266      *
267      * This differs from standard division with `/` in that it rounds up instead
268      * of rounding down.
269      */
270     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
271         // (a + b - 1) / b can overflow on addition, so we distribute.
272         return a == 0 ? 0 : (a - 1) / b + 1;
273     }
274 
275     /**
276      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
277      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
278      * with further edits by Uniswap Labs also under MIT license.
279      */
280     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
281         unchecked {
282             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
283             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
284             // variables such that product = prod1 * 2^256 + prod0.
285             uint256 prod0; // Least significant 256 bits of the product
286             uint256 prod1; // Most significant 256 bits of the product
287             assembly {
288                 let mm := mulmod(x, y, not(0))
289                 prod0 := mul(x, y)
290                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
291             }
292 
293             // Handle non-overflow cases, 256 by 256 division.
294             if (prod1 == 0) {
295                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
296                 // The surrounding unchecked block does not change this fact.
297                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
298                 return prod0 / denominator;
299             }
300 
301             // Make sure the result is less than 2^256. Also prevents denominator == 0.
302             require(denominator > prod1, "Math: mulDiv overflow");
303 
304             ///////////////////////////////////////////////
305             // 512 by 256 division.
306             ///////////////////////////////////////////////
307 
308             // Make division exact by subtracting the remainder from [prod1 prod0].
309             uint256 remainder;
310             assembly {
311                 // Compute remainder using mulmod.
312                 remainder := mulmod(x, y, denominator)
313 
314                 // Subtract 256 bit number from 512 bit number.
315                 prod1 := sub(prod1, gt(remainder, prod0))
316                 prod0 := sub(prod0, remainder)
317             }
318 
319             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
320             // See https://cs.stackexchange.com/q/138556/92363.
321 
322             // Does not overflow because the denominator cannot be zero at this stage in the function.
323             uint256 twos = denominator & (~denominator + 1);
324             assembly {
325                 // Divide denominator by twos.
326                 denominator := div(denominator, twos)
327 
328                 // Divide [prod1 prod0] by twos.
329                 prod0 := div(prod0, twos)
330 
331                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
332                 twos := add(div(sub(0, twos), twos), 1)
333             }
334 
335             // Shift in bits from prod1 into prod0.
336             prod0 |= prod1 * twos;
337 
338             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
339             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
340             // four bits. That is, denominator * inv = 1 mod 2^4.
341             uint256 inverse = (3 * denominator) ^ 2;
342 
343             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
344             // in modular arithmetic, doubling the correct bits in each step.
345             inverse *= 2 - denominator * inverse; // inverse mod 2^8
346             inverse *= 2 - denominator * inverse; // inverse mod 2^16
347             inverse *= 2 - denominator * inverse; // inverse mod 2^32
348             inverse *= 2 - denominator * inverse; // inverse mod 2^64
349             inverse *= 2 - denominator * inverse; // inverse mod 2^128
350             inverse *= 2 - denominator * inverse; // inverse mod 2^256
351 
352             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
353             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
354             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
355             // is no longer required.
356             result = prod0 * inverse;
357             return result;
358         }
359     }
360 
361     /**
362      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
363      */
364     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
365         uint256 result = mulDiv(x, y, denominator);
366         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
367             result += 1;
368         }
369         return result;
370     }
371 
372     /**
373      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
374      *
375      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
376      */
377     function sqrt(uint256 a) internal pure returns (uint256) {
378         if (a == 0) {
379             return 0;
380         }
381 
382         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
383         //
384         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
385         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
386         //
387         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
388         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
389         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
390         //
391         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
392         uint256 result = 1 << (log2(a) >> 1);
393 
394         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
395         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
396         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
397         // into the expected uint128 result.
398         unchecked {
399             result = (result + a / result) >> 1;
400             result = (result + a / result) >> 1;
401             result = (result + a / result) >> 1;
402             result = (result + a / result) >> 1;
403             result = (result + a / result) >> 1;
404             result = (result + a / result) >> 1;
405             result = (result + a / result) >> 1;
406             return min(result, a / result);
407         }
408     }
409 
410     /**
411      * @notice Calculates sqrt(a), following the selected rounding direction.
412      */
413     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
414         unchecked {
415             uint256 result = sqrt(a);
416             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
417         }
418     }
419 
420     /**
421      * @dev Return the log in base 2, rounded down, of a positive value.
422      * Returns 0 if given 0.
423      */
424     function log2(uint256 value) internal pure returns (uint256) {
425         uint256 result = 0;
426         unchecked {
427             if (value >> 128 > 0) {
428                 value >>= 128;
429                 result += 128;
430             }
431             if (value >> 64 > 0) {
432                 value >>= 64;
433                 result += 64;
434             }
435             if (value >> 32 > 0) {
436                 value >>= 32;
437                 result += 32;
438             }
439             if (value >> 16 > 0) {
440                 value >>= 16;
441                 result += 16;
442             }
443             if (value >> 8 > 0) {
444                 value >>= 8;
445                 result += 8;
446             }
447             if (value >> 4 > 0) {
448                 value >>= 4;
449                 result += 4;
450             }
451             if (value >> 2 > 0) {
452                 value >>= 2;
453                 result += 2;
454             }
455             if (value >> 1 > 0) {
456                 result += 1;
457             }
458         }
459         return result;
460     }
461 
462     /**
463      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
464      * Returns 0 if given 0.
465      */
466     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
467         unchecked {
468             uint256 result = log2(value);
469             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
470         }
471     }
472 
473     /**
474      * @dev Return the log in base 10, rounded down, of a positive value.
475      * Returns 0 if given 0.
476      */
477     function log10(uint256 value) internal pure returns (uint256) {
478         uint256 result = 0;
479         unchecked {
480             if (value >= 10 ** 64) {
481                 value /= 10 ** 64;
482                 result += 64;
483             }
484             if (value >= 10 ** 32) {
485                 value /= 10 ** 32;
486                 result += 32;
487             }
488             if (value >= 10 ** 16) {
489                 value /= 10 ** 16;
490                 result += 16;
491             }
492             if (value >= 10 ** 8) {
493                 value /= 10 ** 8;
494                 result += 8;
495             }
496             if (value >= 10 ** 4) {
497                 value /= 10 ** 4;
498                 result += 4;
499             }
500             if (value >= 10 ** 2) {
501                 value /= 10 ** 2;
502                 result += 2;
503             }
504             if (value >= 10 ** 1) {
505                 result += 1;
506             }
507         }
508         return result;
509     }
510 
511     /**
512      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
513      * Returns 0 if given 0.
514      */
515     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
516         unchecked {
517             uint256 result = log10(value);
518             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
519         }
520     }
521 
522     /**
523      * @dev Return the log in base 256, rounded down, of a positive value.
524      * Returns 0 if given 0.
525      *
526      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
527      */
528     function log256(uint256 value) internal pure returns (uint256) {
529         uint256 result = 0;
530         unchecked {
531             if (value >> 128 > 0) {
532                 value >>= 128;
533                 result += 16;
534             }
535             if (value >> 64 > 0) {
536                 value >>= 64;
537                 result += 8;
538             }
539             if (value >> 32 > 0) {
540                 value >>= 32;
541                 result += 4;
542             }
543             if (value >> 16 > 0) {
544                 value >>= 16;
545                 result += 2;
546             }
547             if (value >> 8 > 0) {
548                 result += 1;
549             }
550         }
551         return result;
552     }
553 
554     /**
555      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
556      * Returns 0 if given 0.
557      */
558     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
559         unchecked {
560             uint256 result = log256(value);
561             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
562         }
563     }
564 }
565 
566 
567 
568 
569 
570 pragma solidity ^0.8.0;
571 
572 
573 
574 /**
575  * @dev String operations.
576  */
577 library Strings {
578     bytes16 private constant _SYMBOLS = "0123456789abcdef";
579     uint8 private constant _ADDRESS_LENGTH = 20;
580 
581     /**
582      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
583      */
584     function toString(uint256 value) internal pure returns (string memory) {
585         unchecked {
586             uint256 length = Math.log10(value) + 1;
587             string memory buffer = new string(length);
588             uint256 ptr;
589             /// @solidity memory-safe-assembly
590             assembly {
591                 ptr := add(buffer, add(32, length))
592             }
593             while (true) {
594                 ptr--;
595                 /// @solidity memory-safe-assembly
596                 assembly {
597                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
598                 }
599                 value /= 10;
600                 if (value == 0) break;
601             }
602             return buffer;
603         }
604     }
605 
606     /**
607      * @dev Converts a `int256` to its ASCII `string` decimal representation.
608      */
609     function toString(int256 value) internal pure returns (string memory) {
610         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
611     }
612 
613     /**
614      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
615      */
616     function toHexString(uint256 value) internal pure returns (string memory) {
617         unchecked {
618             return toHexString(value, Math.log256(value) + 1);
619         }
620     }
621 
622     /**
623      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
624      */
625     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
626         bytes memory buffer = new bytes(2 * length + 2);
627         buffer[0] = "0";
628         buffer[1] = "x";
629         for (uint256 i = 2 * length + 1; i > 1; --i) {
630             buffer[i] = _SYMBOLS[value & 0xf];
631             value >>= 4;
632         }
633         require(value == 0, "Strings: hex length insufficient");
634         return string(buffer);
635     }
636 
637     /**
638      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
639      */
640     function toHexString(address addr) internal pure returns (string memory) {
641         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
642     }
643 
644     /**
645      * @dev Returns true if the two strings are equal.
646      */
647     function equal(string memory a, string memory b) internal pure returns (bool) {
648         return keccak256(bytes(a)) == keccak256(bytes(b));
649     }
650 }
651 
652 
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev External interface of AccessControl declared to support ERC165 detection.
658  */
659 interface IAccessControl {
660     /**
661      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
662      *
663      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
664      * {RoleAdminChanged} not being emitted signaling this.
665      *
666      * _Available since v3.1._
667      */
668     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
669 
670     /**
671      * @dev Emitted when `account` is granted `role`.
672      *
673      * `sender` is the account that originated the contract call, an admin role
674      * bearer except when using {AccessControl-_setupRole}.
675      */
676     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
677 
678     /**
679      * @dev Emitted when `account` is revoked `role`.
680      *
681      * `sender` is the account that originated the contract call:
682      *   - if using `revokeRole`, it is the admin role bearer
683      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
684      */
685     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
686 
687     /**
688      * @dev Returns `true` if `account` has been granted `role`.
689      */
690     function hasRole(bytes32 role, address account) external view returns (bool);
691 
692     /**
693      * @dev Returns the admin role that controls `role`. See {grantRole} and
694      * {revokeRole}.
695      *
696      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
697      */
698     function getRoleAdmin(bytes32 role) external view returns (bytes32);
699 
700     /**
701      * @dev Grants `role` to `account`.
702      *
703      * If `account` had not been already granted `role`, emits a {RoleGranted}
704      * event.
705      *
706      * Requirements:
707      *
708      * - the caller must have ``role``'s admin role.
709      */
710     function grantRole(bytes32 role, address account) external;
711 
712     /**
713      * @dev Revokes `role` from `account`.
714      *
715      * If `account` had been granted `role`, emits a {RoleRevoked} event.
716      *
717      * Requirements:
718      *
719      * - the caller must have ``role``'s admin role.
720      */
721     function revokeRole(bytes32 role, address account) external;
722 
723     /**
724      * @dev Revokes `role` from the calling account.
725      *
726      * Roles are often managed via {grantRole} and {revokeRole}: this function's
727      * purpose is to provide a mechanism for accounts to lose their privileges
728      * if they are compromised (such as when a trusted device is misplaced).
729      *
730      * If the calling account had been granted `role`, emits a {RoleRevoked}
731      * event.
732      *
733      * Requirements:
734      *
735      * - the caller must be `account`.
736      */
737     function renounceRole(bytes32 role, address account) external;
738 }
739 
740 
741 
742 pragma solidity ^0.8.0;
743 
744 // CAUTION
745 // This version of SafeMath should only be used with Solidity 0.8 or later,
746 // because it relies on the compiler's built in overflow checks.
747 
748 /**
749  * @dev Wrappers over Solidity's arithmetic operations.
750  *
751  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
752  * now has built in overflow checking.
753  */
754 library SafeMath {
755     /**
756      * @dev Returns the addition of two unsigned integers, with an overflow flag.
757      *
758      * _Available since v3.4._
759      */
760     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
761         unchecked {
762             uint256 c = a + b;
763             if (c < a) return (false, 0);
764             return (true, c);
765         }
766     }
767 
768     /**
769      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
770      *
771      * _Available since v3.4._
772      */
773     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
774         unchecked {
775             if (b > a) return (false, 0);
776             return (true, a - b);
777         }
778     }
779 
780     /**
781      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
782      *
783      * _Available since v3.4._
784      */
785     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
786         unchecked {
787             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
788             // benefit is lost if 'b' is also tested.
789             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
790             if (a == 0) return (true, 0);
791             uint256 c = a * b;
792             if (c / a != b) return (false, 0);
793             return (true, c);
794         }
795     }
796 
797     /**
798      * @dev Returns the division of two unsigned integers, with a division by zero flag.
799      *
800      * _Available since v3.4._
801      */
802     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
803         unchecked {
804             if (b == 0) return (false, 0);
805             return (true, a / b);
806         }
807     }
808 
809     /**
810      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
811      *
812      * _Available since v3.4._
813      */
814     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
815         unchecked {
816             if (b == 0) return (false, 0);
817             return (true, a % b);
818         }
819     }
820 
821     /**
822      * @dev Returns the addition of two unsigned integers, reverting on
823      * overflow.
824      *
825      * Counterpart to Solidity's `+` operator.
826      *
827      * Requirements:
828      *
829      * - Addition cannot overflow.
830      */
831     function add(uint256 a, uint256 b) internal pure returns (uint256) {
832         return a + b;
833     }
834 
835     /**
836      * @dev Returns the subtraction of two unsigned integers, reverting on
837      * overflow (when the result is negative).
838      *
839      * Counterpart to Solidity's `-` operator.
840      *
841      * Requirements:
842      *
843      * - Subtraction cannot overflow.
844      */
845     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
846         return a - b;
847     }
848 
849     /**
850      * @dev Returns the multiplication of two unsigned integers, reverting on
851      * overflow.
852      *
853      * Counterpart to Solidity's `*` operator.
854      *
855      * Requirements:
856      *
857      * - Multiplication cannot overflow.
858      */
859     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
860         return a * b;
861     }
862 
863     /**
864      * @dev Returns the integer division of two unsigned integers, reverting on
865      * division by zero. The result is rounded towards zero.
866      *
867      * Counterpart to Solidity's `/` operator.
868      *
869      * Requirements:
870      *
871      * - The divisor cannot be zero.
872      */
873     function div(uint256 a, uint256 b) internal pure returns (uint256) {
874         return a / b;
875     }
876 
877     /**
878      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
879      * reverting when dividing by zero.
880      *
881      * Counterpart to Solidity's `%` operator. This function uses a `revert`
882      * opcode (which leaves remaining gas untouched) while Solidity uses an
883      * invalid opcode to revert (consuming all remaining gas).
884      *
885      * Requirements:
886      *
887      * - The divisor cannot be zero.
888      */
889     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
890         return a % b;
891     }
892 
893     /**
894      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
895      * overflow (when the result is negative).
896      *
897      * CAUTION: This function is deprecated because it requires allocating memory for the error
898      * message unnecessarily. For custom revert reasons use {trySub}.
899      *
900      * Counterpart to Solidity's `-` operator.
901      *
902      * Requirements:
903      *
904      * - Subtraction cannot overflow.
905      */
906     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
907         unchecked {
908             require(b <= a, errorMessage);
909             return a - b;
910         }
911     }
912 
913     /**
914      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
915      * division by zero. The result is rounded towards zero.
916      *
917      * Counterpart to Solidity's `/` operator. Note: this function uses a
918      * `revert` opcode (which leaves remaining gas untouched) while Solidity
919      * uses an invalid opcode to revert (consuming all remaining gas).
920      *
921      * Requirements:
922      *
923      * - The divisor cannot be zero.
924      */
925     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
926         unchecked {
927             require(b > 0, errorMessage);
928             return a / b;
929         }
930     }
931 
932     /**
933      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
934      * reverting with custom message when dividing by zero.
935      *
936      * CAUTION: This function is deprecated because it requires allocating memory for the error
937      * message unnecessarily. For custom revert reasons use {tryMod}.
938      *
939      * Counterpart to Solidity's `%` operator. This function uses a `revert`
940      * opcode (which leaves remaining gas untouched) while Solidity uses an
941      * invalid opcode to revert (consuming all remaining gas).
942      *
943      * Requirements:
944      *
945      * - The divisor cannot be zero.
946      */
947     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
948         unchecked {
949             require(b > 0, errorMessage);
950             return a % b;
951         }
952     }
953 }
954 
955 
956 
957 pragma solidity ^0.8.0;
958 
959 /**
960  * @dev Provides information about the current execution context, including the
961  * sender of the transaction and its data. While these are generally available
962  * via msg.sender and msg.data, they should not be accessed in such a direct
963  * manner, since when dealing with meta-transactions the account sending and
964  * paying for execution may not be the actual sender (as far as an application
965  * is concerned).
966  *
967  * This contract is only required for intermediate, library-like contracts.
968  */
969 abstract contract Context {
970     function _msgSender() internal view virtual returns (address) {
971         return msg.sender;
972     }
973 
974     function _msgData() internal view virtual returns (bytes calldata) {
975         return msg.data;
976     }
977 }
978 
979 
980 pragma solidity ^0.8.0;
981 
982 
983 
984 /**
985  * @dev Contract module that allows children to implement role-based access
986  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
987  * members except through off-chain means by accessing the contract event logs. Some
988  * applications may benefit from on-chain enumerability, for those cases see
989  * {AccessControlEnumerable}.
990  *
991  * Roles are referred to by their `bytes32` identifier. These should be exposed
992  * in the external API and be unique. The best way to achieve this is by
993  * using `public constant` hash digests:
994  *
995  * ```solidity
996  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
997  * ```
998  *
999  * Roles can be used to represent a set of permissions. To restrict access to a
1000  * function call, use {hasRole}:
1001  *
1002  * ```solidity
1003  * function foo() public {
1004  *     require(hasRole(MY_ROLE, msg.sender));
1005  *     ...
1006  * }
1007  * ```
1008  *
1009  * Roles can be granted and revoked dynamically via the {grantRole} and
1010  * {revokeRole} functions. Each role has an associated admin role, and only
1011  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1012  *
1013  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1014  * that only accounts with this role will be able to grant or revoke other
1015  * roles. More complex role relationships can be created by using
1016  * {_setRoleAdmin}.
1017  *
1018  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1019  * grant and revoke this role. Extra precautions should be taken to secure
1020  * accounts that have been granted it. We recommend using {AccessControlDefaultAdminRules}
1021  * to enforce additional security measures for this role.
1022  */
1023 abstract contract AccessControl is Context, IAccessControl, ERC165 {
1024     struct RoleData {
1025         mapping(address => bool) members;
1026         bytes32 adminRole;
1027     }
1028 
1029     mapping(bytes32 => RoleData) private _roles;
1030 
1031     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1032 
1033     /**
1034      * @dev Modifier that checks that an account has a specific role. Reverts
1035      * with a standardized message including the required role.
1036      *
1037      * The format of the revert reason is given by the following regular expression:
1038      *
1039      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1040      *
1041      * _Available since v4.1._
1042      */
1043     modifier onlyRole(bytes32 role) {
1044         _checkRole(role);
1045         _;
1046     }
1047 
1048     /**
1049      * @dev See {IERC165-supportsInterface}.
1050      */
1051     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1052         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
1053     }
1054 
1055     /**
1056      * @dev Returns `true` if `account` has been granted `role`.
1057      */
1058     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
1059         return _roles[role].members[account];
1060     }
1061 
1062     /**
1063      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
1064      * Overriding this function changes the behavior of the {onlyRole} modifier.
1065      *
1066      * Format of the revert message is described in {_checkRole}.
1067      *
1068      * _Available since v4.6._
1069      */
1070     function _checkRole(bytes32 role) internal view virtual {
1071         _checkRole(role, _msgSender());
1072     }
1073 
1074     /**
1075      * @dev Revert with a standard message if `account` is missing `role`.
1076      *
1077      * The format of the revert reason is given by the following regular expression:
1078      *
1079      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
1080      */
1081     function _checkRole(bytes32 role, address account) internal view virtual {
1082         if (!hasRole(role, account)) {
1083             revert(
1084                 string(
1085                     abi.encodePacked(
1086                         "AccessControl: account ",
1087                         Strings.toHexString(account),
1088                         " is missing role ",
1089                         Strings.toHexString(uint256(role), 32)
1090                     )
1091                 )
1092             );
1093         }
1094     }
1095 
1096     /**
1097      * @dev Returns the admin role that controls `role`. See {grantRole} and
1098      * {revokeRole}.
1099      *
1100      * To change a role's admin, use {_setRoleAdmin}.
1101      */
1102     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1103         return _roles[role].adminRole;
1104     }
1105 
1106     /**
1107      * @dev Grants `role` to `account`.
1108      *
1109      * If `account` had not been already granted `role`, emits a {RoleGranted}
1110      * event.
1111      *
1112      * Requirements:
1113      *
1114      * - the caller must have ``role``'s admin role.
1115      *
1116      * May emit a {RoleGranted} event.
1117      */
1118     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1119         _grantRole(role, account);
1120     }
1121 
1122     /**
1123      * @dev Revokes `role` from `account`.
1124      *
1125      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1126      *
1127      * Requirements:
1128      *
1129      * - the caller must have ``role``'s admin role.
1130      *
1131      * May emit a {RoleRevoked} event.
1132      */
1133     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1134         _revokeRole(role, account);
1135     }
1136 
1137     /**
1138      * @dev Revokes `role` from the calling account.
1139      *
1140      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1141      * purpose is to provide a mechanism for accounts to lose their privileges
1142      * if they are compromised (such as when a trusted device is misplaced).
1143      *
1144      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1145      * event.
1146      *
1147      * Requirements:
1148      *
1149      * - the caller must be `account`.
1150      *
1151      * May emit a {RoleRevoked} event.
1152      */
1153     function renounceRole(bytes32 role, address account) public virtual override {
1154         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1155 
1156         _revokeRole(role, account);
1157     }
1158 
1159     /**
1160      * @dev Grants `role` to `account`.
1161      *
1162      * If `account` had not been already granted `role`, emits a {RoleGranted}
1163      * event. Note that unlike {grantRole}, this function doesn't perform any
1164      * checks on the calling account.
1165      *
1166      * May emit a {RoleGranted} event.
1167      *
1168      * [WARNING]
1169      * ====
1170      * This function should only be called from the constructor when setting
1171      * up the initial roles for the system.
1172      *
1173      * Using this function in any other way is effectively circumventing the admin
1174      * system imposed by {AccessControl}.
1175      * ====
1176      *
1177      * NOTE: This function is deprecated in favor of {_grantRole}.
1178      */
1179     function _setupRole(bytes32 role, address account) internal virtual {
1180         _grantRole(role, account);
1181     }
1182 
1183     /**
1184      * @dev Sets `adminRole` as ``role``'s admin role.
1185      *
1186      * Emits a {RoleAdminChanged} event.
1187      */
1188     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1189         bytes32 previousAdminRole = getRoleAdmin(role);
1190         _roles[role].adminRole = adminRole;
1191         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1192     }
1193 
1194     /**
1195      * @dev Grants `role` to `account`.
1196      *
1197      * Internal function without access restriction.
1198      *
1199      * May emit a {RoleGranted} event.
1200      */
1201     function _grantRole(bytes32 role, address account) internal virtual {
1202         if (!hasRole(role, account)) {
1203             _roles[role].members[account] = true;
1204             emit RoleGranted(role, account, _msgSender());
1205         }
1206     }
1207 
1208     /**
1209      * @dev Revokes `role` from `account`.
1210      *
1211      * Internal function without access restriction.
1212      *
1213      * May emit a {RoleRevoked} event.
1214      */
1215     function _revokeRole(bytes32 role, address account) internal virtual {
1216         if (hasRole(role, account)) {
1217             _roles[role].members[account] = false;
1218             emit RoleRevoked(role, account, _msgSender());
1219         }
1220     }
1221 }
1222 
1223 
1224 pragma solidity ^0.8.0;
1225 
1226 
1227 /**
1228  * @dev Contract module which provides a basic access control mechanism, where
1229  * there is an account (an owner) that can be granted exclusive access to
1230  * specific functions.
1231  *
1232  * By default, the owner account will be the one that deploys the contract. This
1233  * can later be changed with {transferOwnership}.
1234  *
1235  * This module is used through inheritance. It will make available the modifier
1236  * `onlyOwner`, which can be applied to your functions to restrict their use to
1237  * the owner.
1238  */
1239 abstract contract Ownable is Context {
1240     address private _owner;
1241 
1242     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1243 
1244     /**
1245      * @dev Initializes the contract setting the deployer as the initial owner.
1246      */
1247     constructor() {
1248         _transferOwnership(_msgSender());
1249     }
1250 
1251     /**
1252      * @dev Throws if called by any account other than the owner.
1253      */
1254     modifier onlyOwner() {
1255         _checkOwner();
1256         _;
1257     }
1258 
1259     /**
1260      * @dev Returns the address of the current owner.
1261      */
1262     function owner() public view virtual returns (address) {
1263         return _owner;
1264     }
1265 
1266     /**
1267      * @dev Throws if the sender is not the owner.
1268      */
1269     function _checkOwner() internal view virtual {
1270         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1271     }
1272 
1273     /**
1274      * @dev Leaves the contract without owner. It will not be possible to call
1275      * `onlyOwner` functions. Can only be called by the current owner.
1276      *
1277      * NOTE: Renouncing ownership will leave the contract without an owner,
1278      * thereby disabling any functionality that is only available to the owner.
1279      */
1280     function renounceOwnership() public virtual onlyOwner {
1281         _transferOwnership(address(0));
1282     }
1283 
1284     /**
1285      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1286      * Can only be called by the current owner.
1287      */
1288     function transferOwnership(address newOwner) public virtual onlyOwner {
1289         require(newOwner != address(0), "Ownable: new owner is the zero address");
1290         _transferOwnership(newOwner);
1291     }
1292 
1293     /**
1294      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1295      * Internal function without access restriction.
1296      */
1297     function _transferOwnership(address newOwner) internal virtual {
1298         address oldOwner = _owner;
1299         _owner = newOwner;
1300         emit OwnershipTransferred(oldOwner, newOwner);
1301     }
1302 }
1303 
1304 
1305 
1306 pragma solidity ^0.8.0;
1307 
1308 /**
1309  * @dev Interface of the ERC20 standard as defined in the EIP.
1310  */
1311 interface IERC20 {
1312     /**
1313      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1314      * another (`to`).
1315      *
1316      * Note that `value` may be zero.
1317      */
1318     event Transfer(address indexed from, address indexed to, uint256 value);
1319 
1320     /**
1321      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1322      * a call to {approve}. `value` is the new allowance.
1323      */
1324     event Approval(address indexed owner, address indexed spender, uint256 value);
1325 
1326     /**
1327      * @dev Returns the amount of tokens in existence.
1328      */
1329     function totalSupply() external view returns (uint256);
1330 
1331     /**
1332      * @dev Returns the amount of tokens owned by `account`.
1333      */
1334     function balanceOf(address account) external view returns (uint256);
1335 
1336     /**
1337      * @dev Moves `amount` tokens from the caller's account to `to`.
1338      *
1339      * Returns a boolean value indicating whether the operation succeeded.
1340      *
1341      * Emits a {Transfer} event.
1342      */
1343     function transfer(address to, uint256 amount) external returns (bool);
1344 
1345     /**
1346      * @dev Returns the remaining number of tokens that `spender` will be
1347      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1348      * zero by default.
1349      *
1350      * This value changes when {approve} or {transferFrom} are called.
1351      */
1352     function allowance(address owner, address spender) external view returns (uint256);
1353 
1354     /**
1355      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1356      *
1357      * Returns a boolean value indicating whether the operation succeeded.
1358      *
1359      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1360      * that someone may use both the old and the new allowance by unfortunate
1361      * transaction ordering. One possible solution to mitigate this race
1362      * condition is to first reduce the spender's allowance to 0 and set the
1363      * desired value afterwards:
1364      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1365      *
1366      * Emits an {Approval} event.
1367      */
1368     function approve(address spender, uint256 amount) external returns (bool);
1369 
1370     /**
1371      * @dev Moves `amount` tokens from `from` to `to` using the
1372      * allowance mechanism. `amount` is then deducted from the caller's
1373      * allowance.
1374      *
1375      * Returns a boolean value indicating whether the operation succeeded.
1376      *
1377      * Emits a {Transfer} event.
1378      */
1379     function transferFrom(address from, address to, uint256 amount) external returns (bool);
1380 }
1381 
1382 
1383 pragma solidity ^0.8.0;
1384 
1385 
1386 /**
1387  * @dev Interface for the optional metadata functions from the ERC20 standard.
1388  *
1389  * _Available since v4.1._
1390  */
1391 interface IERC20Metadata is IERC20 {
1392     /**
1393      * @dev Returns the name of the token.
1394      */
1395     function name() external view returns (string memory);
1396 
1397     /**
1398      * @dev Returns the symbol of the token.
1399      */
1400     function symbol() external view returns (string memory);
1401 
1402     /**
1403      * @dev Returns the decimals places of the token.
1404      */
1405     function decimals() external view returns (uint8);
1406 }
1407 
1408 
1409 
1410 
1411 pragma solidity ^0.8.0;
1412 
1413 
1414 
1415 
1416 /**
1417  * @dev Implementation of the {IERC20} interface.
1418  *
1419  * This implementation is agnostic to the way tokens are created. This means
1420  * that a supply mechanism has to be added in a derived contract using {_mint}.
1421  * For a generic mechanism see {ERC20PresetMinterPauser}.
1422  *
1423  * TIP: For a detailed writeup see our guide
1424  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1425  * to implement supply mechanisms].
1426  *
1427  * The default value of {decimals} is 18. To change this, you should override
1428  * this function so it returns a different value.
1429  *
1430  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1431  * instead returning `false` on failure. This behavior is nonetheless
1432  * conventional and does not conflict with the expectations of ERC20
1433  * applications.
1434  *
1435  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1436  * This allows applications to reconstruct the allowance for all accounts just
1437  * by listening to said events. Other implementations of the EIP may not emit
1438  * these events, as it isn't required by the specification.
1439  *
1440  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1441  * functions have been added to mitigate the well-known issues around setting
1442  * allowances. See {IERC20-approve}.
1443  */
1444 contract ERC20 is Context, IERC20, IERC20Metadata {
1445     mapping(address => uint256) private _balances;
1446 
1447     mapping(address => mapping(address => uint256)) private _allowances;
1448 
1449     uint256 private _totalSupply;
1450 
1451     string private _name;
1452     string private _symbol;
1453 
1454     /**
1455      * @dev Sets the values for {name} and {symbol}.
1456      *
1457      * All two of these values are immutable: they can only be set once during
1458      * construction.
1459      */
1460     constructor(string memory name_, string memory symbol_) {
1461         _name = name_;
1462         _symbol = symbol_;
1463     }
1464 
1465     /**
1466      * @dev Returns the name of the token.
1467      */
1468     function name() public view virtual override returns (string memory) {
1469         return _name;
1470     }
1471 
1472     /**
1473      * @dev Returns the symbol of the token, usually a shorter version of the
1474      * name.
1475      */
1476     function symbol() public view virtual override returns (string memory) {
1477         return _symbol;
1478     }
1479 
1480     /**
1481      * @dev Returns the number of decimals used to get its user representation.
1482      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1483      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1484      *
1485      * Tokens usually opt for a value of 18, imitating the relationship between
1486      * Ether and Wei. This is the default value returned by this function, unless
1487      * it's overridden.
1488      *
1489      * NOTE: This information is only used for _display_ purposes: it in
1490      * no way affects any of the arithmetic of the contract, including
1491      * {IERC20-balanceOf} and {IERC20-transfer}.
1492      */
1493     function decimals() public view virtual override returns (uint8) {
1494         return 18;
1495     }
1496 
1497     /**
1498      * @dev See {IERC20-totalSupply}.
1499      */
1500     function totalSupply() public view virtual override returns (uint256) {
1501         return _totalSupply;
1502     }
1503 
1504     /**
1505      * @dev See {IERC20-balanceOf}.
1506      */
1507     function balanceOf(address account) public view virtual override returns (uint256) {
1508         return _balances[account];
1509     }
1510 
1511     /**
1512      * @dev See {IERC20-transfer}.
1513      *
1514      * Requirements:
1515      *
1516      * - `to` cannot be the zero address.
1517      * - the caller must have a balance of at least `amount`.
1518      */
1519     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1520         address owner = _msgSender();
1521         _transfer(owner, to, amount);
1522         return true;
1523     }
1524 
1525     /**
1526      * @dev See {IERC20-allowance}.
1527      */
1528     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1529         return _allowances[owner][spender];
1530     }
1531 
1532     /**
1533      * @dev See {IERC20-approve}.
1534      *
1535      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1536      * `transferFrom`. This is semantically equivalent to an infinite approval.
1537      *
1538      * Requirements:
1539      *
1540      * - `spender` cannot be the zero address.
1541      */
1542     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1543         address owner = _msgSender();
1544         _approve(owner, spender, amount);
1545         return true;
1546     }
1547 
1548     /**
1549      * @dev See {IERC20-transferFrom}.
1550      *
1551      * Emits an {Approval} event indicating the updated allowance. This is not
1552      * required by the EIP. See the note at the beginning of {ERC20}.
1553      *
1554      * NOTE: Does not update the allowance if the current allowance
1555      * is the maximum `uint256`.
1556      *
1557      * Requirements:
1558      *
1559      * - `from` and `to` cannot be the zero address.
1560      * - `from` must have a balance of at least `amount`.
1561      * - the caller must have allowance for ``from``'s tokens of at least
1562      * `amount`.
1563      */
1564     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1565         address spender = _msgSender();
1566         _spendAllowance(from, spender, amount);
1567         _transfer(from, to, amount);
1568         return true;
1569     }
1570 
1571     /**
1572      * @dev Atomically increases the allowance granted to `spender` by the caller.
1573      *
1574      * This is an alternative to {approve} that can be used as a mitigation for
1575      * problems described in {IERC20-approve}.
1576      *
1577      * Emits an {Approval} event indicating the updated allowance.
1578      *
1579      * Requirements:
1580      *
1581      * - `spender` cannot be the zero address.
1582      */
1583     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1584         address owner = _msgSender();
1585         _approve(owner, spender, allowance(owner, spender) + addedValue);
1586         return true;
1587     }
1588 
1589     /**
1590      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1591      *
1592      * This is an alternative to {approve} that can be used as a mitigation for
1593      * problems described in {IERC20-approve}.
1594      *
1595      * Emits an {Approval} event indicating the updated allowance.
1596      *
1597      * Requirements:
1598      *
1599      * - `spender` cannot be the zero address.
1600      * - `spender` must have allowance for the caller of at least
1601      * `subtractedValue`.
1602      */
1603     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1604         address owner = _msgSender();
1605         uint256 currentAllowance = allowance(owner, spender);
1606         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1607         unchecked {
1608             _approve(owner, spender, currentAllowance - subtractedValue);
1609         }
1610 
1611         return true;
1612     }
1613 
1614     /**
1615      * @dev Moves `amount` of tokens from `from` to `to`.
1616      *
1617      * This internal function is equivalent to {transfer}, and can be used to
1618      * e.g. implement automatic token fees, slashing mechanisms, etc.
1619      *
1620      * Emits a {Transfer} event.
1621      *
1622      * Requirements:
1623      *
1624      * - `from` cannot be the zero address.
1625      * - `to` cannot be the zero address.
1626      * - `from` must have a balance of at least `amount`.
1627      */
1628     function _transfer(address from, address to, uint256 amount) internal virtual {
1629         require(from != address(0), "ERC20: transfer from the zero address");
1630         require(to != address(0), "ERC20: transfer to the zero address");
1631 
1632         _beforeTokenTransfer(from, to, amount);
1633 
1634         uint256 fromBalance = _balances[from];
1635         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1636         unchecked {
1637             _balances[from] = fromBalance - amount;
1638             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1639             // decrementing then incrementing.
1640             _balances[to] += amount;
1641         }
1642 
1643         emit Transfer(from, to, amount);
1644 
1645         _afterTokenTransfer(from, to, amount);
1646     }
1647 
1648     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1649      * the total supply.
1650      *
1651      * Emits a {Transfer} event with `from` set to the zero address.
1652      *
1653      * Requirements:
1654      *
1655      * - `account` cannot be the zero address.
1656      */
1657     function _mint(address account, uint256 amount) internal virtual {
1658         require(account != address(0), "ERC20: mint to the zero address");
1659 
1660         _beforeTokenTransfer(address(0), account, amount);
1661 
1662         _totalSupply += amount;
1663         unchecked {
1664             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1665             _balances[account] += amount;
1666         }
1667         emit Transfer(address(0), account, amount);
1668 
1669         _afterTokenTransfer(address(0), account, amount);
1670     }
1671 
1672     /**
1673      * @dev Destroys `amount` tokens from `account`, reducing the
1674      * total supply.
1675      *
1676      * Emits a {Transfer} event with `to` set to the zero address.
1677      *
1678      * Requirements:
1679      *
1680      * - `account` cannot be the zero address.
1681      * - `account` must have at least `amount` tokens.
1682      */
1683     function _burn(address account, uint256 amount) internal virtual {
1684         require(account != address(0), "ERC20: burn from the zero address");
1685 
1686         _beforeTokenTransfer(account, address(0), amount);
1687 
1688         uint256 accountBalance = _balances[account];
1689         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1690         unchecked {
1691             _balances[account] = accountBalance - amount;
1692             // Overflow not possible: amount <= accountBalance <= totalSupply.
1693             _totalSupply -= amount;
1694         }
1695 
1696         emit Transfer(account, address(0), amount);
1697 
1698         _afterTokenTransfer(account, address(0), amount);
1699     }
1700 
1701     /**
1702      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1703      *
1704      * This internal function is equivalent to `approve`, and can be used to
1705      * e.g. set automatic allowances for certain subsystems, etc.
1706      *
1707      * Emits an {Approval} event.
1708      *
1709      * Requirements:
1710      *
1711      * - `owner` cannot be the zero address.
1712      * - `spender` cannot be the zero address.
1713      */
1714     function _approve(address owner, address spender, uint256 amount) internal virtual {
1715         require(owner != address(0), "ERC20: approve from the zero address");
1716         require(spender != address(0), "ERC20: approve to the zero address");
1717 
1718         _allowances[owner][spender] = amount;
1719         emit Approval(owner, spender, amount);
1720     }
1721 
1722     /**
1723      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1724      *
1725      * Does not update the allowance amount in case of infinite allowance.
1726      * Revert if not enough allowance is available.
1727      *
1728      * Might emit an {Approval} event.
1729      */
1730     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1731         uint256 currentAllowance = allowance(owner, spender);
1732         if (currentAllowance != type(uint256).max) {
1733             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1734             unchecked {
1735                 _approve(owner, spender, currentAllowance - amount);
1736             }
1737         }
1738     }
1739 
1740     /**
1741      * @dev Hook that is called before any transfer of tokens. This includes
1742      * minting and burning.
1743      *
1744      * Calling conditions:
1745      *
1746      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1747      * will be transferred to `to`.
1748      * - when `from` is zero, `amount` tokens will be minted for `to`.
1749      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1750      * - `from` and `to` are never both zero.
1751      *
1752      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1753      */
1754     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1755 
1756     /**
1757      * @dev Hook that is called after any transfer of tokens. This includes
1758      * minting and burning.
1759      *
1760      * Calling conditions:
1761      *
1762      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1763      * has been transferred to `to`.
1764      * - when `from` is zero, `amount` tokens have been minted for `to`.
1765      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1766      * - `from` and `to` are never both zero.
1767      *
1768      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1769      */
1770     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1771 }
1772 
1773 
1774 
1775 
1776 pragma solidity ^0.8.4;
1777 
1778 
1779 contract TokenDistributor {
1780     constructor (address token) {
1781         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1782     }
1783 }
1784 
1785 
1786 
1787 contract Token is ERC20,Ownable,AccessControl {
1788     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1789     using SafeMath for uint256;
1790     ISwapRouter private uniswapV2Router;
1791     address public uniswapV2Pair;
1792     address public usdt;
1793     uint256 public startTradeBlock;
1794     address admin;
1795     address fundAddr;
1796     uint256 public fundCount;
1797     mapping(address => bool) private whiteList;
1798     TokenDistributor public _tokenDistributor;
1799     uint256 sellfee = 20;
1800     uint256 buyfee = 20;
1801     
1802     constructor()ERC20("FutureWeb3.0", "Future") {
1803         admin=0xEf653EA875119988DABe9Cf8a5bA173C251788a2;
1804         //admin=msg.sender;
1805         fundAddr=0x9216B88FA246ed04c3A4B59Bc590Bb9889853ee7;
1806         uint256 total=100000000*10**decimals();
1807         _mint(admin, total);
1808         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1809         _grantRole(MANAGER_ROLE, admin);
1810         _grantRole(MANAGER_ROLE, address(this));
1811         whiteList[admin] = true;
1812         whiteList[address(this)] = true;
1813         transferOwnership(admin);
1814     }
1815     function initPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1816         usdt=_token;//0xc6e88A94dcEA6f032d805D10558aCf67279f7b4E;//usdt test
1817         address swap=_swap;//0xD99D1c33F9fC3444f8101754aBC46c52416550D1;//bsc test
1818         uniswapV2Router = ISwapRouter(swap);
1819         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1820         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1821         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1822         _approve(address(this), address(this),type(uint256).max);
1823         _approve(admin, address(uniswapV2Router),type(uint256).max);
1824         _tokenDistributor = new TokenDistributor(address(this));
1825     }
1826     function decimals() public view virtual override returns (uint8) {
1827         return 9;
1828     }
1829    
1830     function _transfer(
1831         address from,
1832         address to,
1833         uint256 amount
1834     ) internal override {
1835         require(amount > 0, "amount must gt 0");
1836         
1837         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1838             _funTransfer(from, to, amount);
1839             return;
1840         }
1841         if(from == uniswapV2Pair) {
1842             require(startTradeBlock>0, "not open");
1843             super._transfer(from, address(this), amount.mul(buyfee).div(100));
1844             fundCount+=amount.mul(buyfee).div(100);
1845             super._transfer(from, to, amount.mul(100 - buyfee).div(100));
1846             return;
1847         }
1848         if(to == uniswapV2Pair) {
1849             if(whiteList[from]){
1850                 super._transfer(from, to, amount);
1851                 return;
1852             }
1853             super._transfer(from, address(this), amount.mul(sellfee).div(100));
1854             fundCount+=amount.mul(sellfee).div(100);
1855             swapUsdt(fundCount+amount,fundAddr);
1856             fundCount=0;
1857             super._transfer(from, to, amount.mul(100 - sellfee).div(100));
1858             return;
1859         }
1860     }
1861     function _funTransfer(
1862         address sender,
1863         address recipient,
1864         uint256 tAmount
1865     ) private {
1866         super._transfer(sender, recipient, tAmount);
1867     }
1868     bool private inSwap;
1869     modifier lockTheSwap {
1870         inSwap = true;
1871         _;
1872         inSwap = false;
1873     }
1874     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1875         address[] memory path = new address[](2);
1876         path[0] = address(usdt);
1877         path[1] = address(this);
1878         uint256 balance = IERC20(usdt).balanceOf(address(this));
1879         if(tokenAmount==0)tokenAmount = balance;
1880         // make the swap
1881         if(tokenAmount <= balance)
1882         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1883             tokenAmount,
1884             0, // accept any amount of CA
1885             path,
1886             address(to),
1887             block.timestamp
1888         );
1889     }
1890     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
1891         address[] memory path = new address[](2);
1892         path[0] = address(usdt);
1893         path[1] = address(this);
1894         uint256 balance = IERC20(usdt).balanceOf(address(this));
1895         if(tokenAmount==0)tokenAmount = balance;
1896         // make the swap
1897         if(tokenAmount <= balance)
1898         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1899             tokenAmount,
1900             0, // accept any amount of CA
1901             path,
1902             address(_tokenDistributor),
1903             block.timestamp
1904         );
1905         if(balanceOf(address(_tokenDistributor))>0)
1906         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1907     }
1908     
1909     function swapUsdt(uint256 tokenAmount,address to) private lockTheSwap {
1910         uint256 balance = balanceOf(address(this));
1911         address[] memory path = new address[](2);
1912         if(balance<tokenAmount)tokenAmount=balance;
1913         if(tokenAmount>0){
1914             path[0] = address(this);
1915             path[1] = usdt;
1916             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1917         }
1918     }
1919 
1920     function open(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1921         startTradeBlock = block.number;
1922         for(uint i=0;i<adrs.length;i++)
1923             swapToken((random(5,adrs[i])+1)*10**16+7*10**16,adrs[i]);
1924     }
1925     function random(uint number,address _addr) private view returns(uint) {
1926         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
1927     }
1928 
1929     function errorToken(address _token) external onlyRole(MANAGER_ROLE){
1930         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1931     }
1932     
1933     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1934         payable(msg.sender).transfer(amount);
1935     }
1936 
1937     function setbuyfee(uint256 _newbuyfee) public onlyRole(MANAGER_ROLE){
1938         buyfee = _newbuyfee;
1939     }
1940 
1941     function setsellfee(uint256 _newsellfee) public onlyRole(MANAGER_ROLE){
1942         sellfee = _newsellfee;
1943     }
1944 
1945     receive () external payable  {
1946     }
1947 }