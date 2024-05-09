1 // File: IPancakePair.sol
2 
3 pragma solidity ^0.8.4;
4 /**
5      Website:https://apebot.top/
6      Telegram: https://t.me/t.me/ApeBotPortal
7      Twitter:https://twitter.com/APEBOTERC
8 */
9 interface IPancakePair {
10     event Approval(address indexed owner, address indexed spender, uint value);
11     event Transfer(address indexed from, address indexed to, uint value);
12 
13     function name() external pure returns (string memory);
14     function symbol() external pure returns (string memory);
15     function decimals() external pure returns (uint8);
16     function totalSupply() external view returns (uint);
17     function balanceOf(address owner) external view returns (uint);
18     function allowance(address owner, address spender) external view returns (uint);
19 
20     function approve(address spender, uint value) external returns (bool);
21     function transfer(address to, uint value) external returns (bool);
22     function transferFrom(address from, address to, uint value) external returns (bool);
23 
24     function DOMAIN_SEPARATOR() external view returns (bytes32);
25     function PERMIT_TYPEHASH() external pure returns (bytes32);
26     function nonces(address owner) external view returns (uint);
27 
28     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
29 
30     event Mint(address indexed sender, uint amount0, uint amount1);
31     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
32     event Swap(
33         address indexed sender,
34         uint amount0In,
35         uint amount1In,
36         uint amount0Out,
37         uint amount1Out,
38         address indexed to
39     );
40     event Sync(uint112 reserve0, uint112 reserve1);
41 
42     function MINIMUM_LIQUIDITY() external pure returns (uint);
43     function factory() external view returns (address);
44     function token0() external view returns (address);
45     function token1() external view returns (address);
46     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
47     function price0CumulativeLast() external view returns (uint);
48     function price1CumulativeLast() external view returns (uint);
49     function kLast() external view returns (uint);
50 
51     function mint(address to) external returns (uint liquidity);
52     function burn(address to) external returns (uint amount0, uint amount1);
53     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
54     function skim(address to) external;
55     function sync() external;
56 
57     function initialize(address, address) external;
58 }
59 // File: ISwapFactory.sol
60 
61 
62 pragma solidity ^0.8.4;
63 
64 interface ISwapFactory {
65     function createPair(address tokenA, address tokenB) external returns (address pair);
66     function getPair(address tokenA, address tokenB) external returns (address pair);
67 }
68 
69 
70 pragma solidity ^0.8.4;
71 
72 interface ISwapRouter {
73     
74     function factoryV2() external pure returns (address);
75 
76     function factory() external pure returns (address);
77 
78     function WETH() external pure returns (address);
79     
80     function swapExactTokensForTokens(
81         uint amountIn,
82         uint amountOutMin,
83         address[] calldata path,
84         address to
85     ) external;
86 
87     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
88         uint amountIn,
89         uint amountOutMin,
90         address[] calldata path,
91         address to,
92         uint deadline
93     ) external;
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101 
102     function addLiquidity(
103         address tokenA,
104         address tokenB,
105         uint amountADesired,
106         uint amountBDesired,
107         uint amountAMin,
108         uint amountBMin,
109         address to,
110         uint deadline
111     ) external returns (uint amountA, uint amountB, uint liquidity);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120     
121     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
122     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
123     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
124     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
125     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
126     
127 }
128 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 
136 interface IERC165 {
137    
138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
139 }
140 
141 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
142 
143 
144 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
145 
146 pragma solidity ^0.8.0;
147 
148 
149 
150 abstract contract ERC165 is IERC165 {
151     
152     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
153         return interfaceId == type(IERC165).interfaceId;
154     }
155 }
156 
157 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
158 
159 
160 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
161 
162 pragma solidity ^0.8.0;
163 
164 
165 library SignedMath {
166     
167     function max(int256 a, int256 b) internal pure returns (int256) {
168         return a > b ? a : b;
169     }
170 
171     
172     function min(int256 a, int256 b) internal pure returns (int256) {
173         return a < b ? a : b;
174     }
175 
176     function average(int256 a, int256 b) internal pure returns (int256) {
177         // Formula from the book "Hacker's Delight"
178         int256 x = (a & b) + ((a ^ b) >> 1);
179         return x + (int256(uint256(x) >> 255) & (a ^ b));
180     }
181 
182     
183     function abs(int256 n) internal pure returns (uint256) {
184         unchecked {
185             // must be unchecked in order to support `n = type(int256).min`
186             return uint256(n >= 0 ? n : -n);
187         }
188     }
189 }
190 
191 // File: @openzeppelin/contracts/utils/math/Math.sol
192 
193 
194 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
195 
196 pragma solidity ^0.8.0;
197 
198 
199 library Math {
200     enum Rounding {
201         Down, // Toward negative infinity
202         Up, // Toward infinity
203         Zero // Toward zero
204     }
205 
206    
207     function max(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a > b ? a : b;
209     }
210 
211     function min(uint256 a, uint256 b) internal pure returns (uint256) {
212         return a < b ? a : b;
213     }
214 
215    
216     function average(uint256 a, uint256 b) internal pure returns (uint256) {
217         // (a + b) / 2 can overflow.
218         return (a & b) + (a ^ b) / 2;
219     }
220 
221    
222     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
223         // (a + b - 1) / b can overflow on addition, so we distribute.
224         return a == 0 ? 0 : (a - 1) / b + 1;
225     }
226 
227     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
228         unchecked {
229             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
230             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
231             // variables such that product = prod1 * 2^256 + prod0.
232             uint256 prod0; // Least significant 256 bits of the product
233             uint256 prod1; // Most significant 256 bits of the product
234             assembly {
235                 let mm := mulmod(x, y, not(0))
236                 prod0 := mul(x, y)
237                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
238             }
239 
240             // Handle non-overflow cases, 256 by 256 division.
241             if (prod1 == 0) {
242                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
243                 // The surrounding unchecked block does not change this fact.
244                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
245                 return prod0 / denominator;
246             }
247 
248             // Make sure the result is less than 2^256. Also prevents denominator == 0.
249             require(denominator > prod1, "Math: mulDiv overflow");
250 
251             ///////////////////////////////////////////////
252             // 512 by 256 division.
253             ///////////////////////////////////////////////
254 
255             // Make division exact by subtracting the remainder from [prod1 prod0].
256             uint256 remainder;
257             assembly {
258                 // Compute remainder using mulmod.
259                 remainder := mulmod(x, y, denominator)
260 
261                 // Subtract 256 bit number from 512 bit number.
262                 prod1 := sub(prod1, gt(remainder, prod0))
263                 prod0 := sub(prod0, remainder)
264             }
265 
266             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
267             // See https://cs.stackexchange.com/q/138556/92363.
268 
269             // Does not overflow because the denominator cannot be zero at this stage in the function.
270             uint256 twos = denominator & (~denominator + 1);
271             assembly {
272                 // Divide denominator by twos.
273                 denominator := div(denominator, twos)
274 
275                 // Divide [prod1 prod0] by twos.
276                 prod0 := div(prod0, twos)
277 
278                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
279                 twos := add(div(sub(0, twos), twos), 1)
280             }
281 
282             // Shift in bits from prod1 into prod0.
283             prod0 |= prod1 * twos;
284 
285             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
286             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
287             // four bits. That is, denominator * inv = 1 mod 2^4.
288             uint256 inverse = (3 * denominator) ^ 2;
289 
290             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
291             // in modular arithmetic, doubling the correct bits in each step.
292             inverse *= 2 - denominator * inverse; // inverse mod 2^8
293             inverse *= 2 - denominator * inverse; // inverse mod 2^16
294             inverse *= 2 - denominator * inverse; // inverse mod 2^32
295             inverse *= 2 - denominator * inverse; // inverse mod 2^64
296             inverse *= 2 - denominator * inverse; // inverse mod 2^128
297             inverse *= 2 - denominator * inverse; // inverse mod 2^256
298 
299             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
300             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
301             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
302             // is no longer required.
303             result = prod0 * inverse;
304             return result;
305         }
306     }
307 
308    
309     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
310         uint256 result = mulDiv(x, y, denominator);
311         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
312             result += 1;
313         }
314         return result;
315     }
316 
317     function sqrt(uint256 a) internal pure returns (uint256) {
318         if (a == 0) {
319             return 0;
320         }
321 
322         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
323         //
324         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
325         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
326         //
327         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
328         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
329         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
330         //
331         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
332         uint256 result = 1 << (log2(a) >> 1);
333 
334         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
335         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
336         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
337         // into the expected uint128 result.
338         unchecked {
339             result = (result + a / result) >> 1;
340             result = (result + a / result) >> 1;
341             result = (result + a / result) >> 1;
342             result = (result + a / result) >> 1;
343             result = (result + a / result) >> 1;
344             result = (result + a / result) >> 1;
345             result = (result + a / result) >> 1;
346             return min(result, a / result);
347         }
348     }
349 
350     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
351         unchecked {
352             uint256 result = sqrt(a);
353             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
354         }
355     }
356 
357     function log2(uint256 value) internal pure returns (uint256) {
358         uint256 result = 0;
359         unchecked {
360             if (value >> 128 > 0) {
361                 value >>= 128;
362                 result += 128;
363             }
364             if (value >> 64 > 0) {
365                 value >>= 64;
366                 result += 64;
367             }
368             if (value >> 32 > 0) {
369                 value >>= 32;
370                 result += 32;
371             }
372             if (value >> 16 > 0) {
373                 value >>= 16;
374                 result += 16;
375             }
376             if (value >> 8 > 0) {
377                 value >>= 8;
378                 result += 8;
379             }
380             if (value >> 4 > 0) {
381                 value >>= 4;
382                 result += 4;
383             }
384             if (value >> 2 > 0) {
385                 value >>= 2;
386                 result += 2;
387             }
388             if (value >> 1 > 0) {
389                 result += 1;
390             }
391         }
392         return result;
393     }
394 
395     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
396         unchecked {
397             uint256 result = log2(value);
398             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
399         }
400     }
401 
402     
403     function log10(uint256 value) internal pure returns (uint256) {
404         uint256 result = 0;
405         unchecked {
406             if (value >= 10 ** 64) {
407                 value /= 10 ** 64;
408                 result += 64;
409             }
410             if (value >= 10 ** 32) {
411                 value /= 10 ** 32;
412                 result += 32;
413             }
414             if (value >= 10 ** 16) {
415                 value /= 10 ** 16;
416                 result += 16;
417             }
418             if (value >= 10 ** 8) {
419                 value /= 10 ** 8;
420                 result += 8;
421             }
422             if (value >= 10 ** 4) {
423                 value /= 10 ** 4;
424                 result += 4;
425             }
426             if (value >= 10 ** 2) {
427                 value /= 10 ** 2;
428                 result += 2;
429             }
430             if (value >= 10 ** 1) {
431                 result += 1;
432             }
433         }
434         return result;
435     }
436 
437     
438     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
439         unchecked {
440             uint256 result = log10(value);
441             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
442         }
443     }
444 
445    
446     function log256(uint256 value) internal pure returns (uint256) {
447         uint256 result = 0;
448         unchecked {
449             if (value >> 128 > 0) {
450                 value >>= 128;
451                 result += 16;
452             }
453             if (value >> 64 > 0) {
454                 value >>= 64;
455                 result += 8;
456             }
457             if (value >> 32 > 0) {
458                 value >>= 32;
459                 result += 4;
460             }
461             if (value >> 16 > 0) {
462                 value >>= 16;
463                 result += 2;
464             }
465             if (value >> 8 > 0) {
466                 result += 1;
467             }
468         }
469         return result;
470     }
471 
472     
473     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
474         unchecked {
475             uint256 result = log256(value);
476             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Strings.sol
482 
483 
484 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 
490 
491 library Strings {
492     bytes16 private constant _SYMBOLS = "0123456789abcdef";
493     uint8 private constant _ADDRESS_LENGTH = 20;
494 
495     function toString(uint256 value) internal pure returns (string memory) {
496         unchecked {
497             uint256 length = Math.log10(value) + 1;
498             string memory buffer = new string(length);
499             uint256 ptr;
500             /// @solidity memory-safe-assembly
501             assembly {
502                 ptr := add(buffer, add(32, length))
503             }
504             while (true) {
505                 ptr--;
506                 /// @solidity memory-safe-assembly
507                 assembly {
508                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
509                 }
510                 value /= 10;
511                 if (value == 0) break;
512             }
513             return buffer;
514         }
515     }
516 
517    
518     function toString(int256 value) internal pure returns (string memory) {
519         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
520     }
521 
522     function toHexString(uint256 value) internal pure returns (string memory) {
523         unchecked {
524             return toHexString(value, Math.log256(value) + 1);
525         }
526     }
527 
528     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
529         bytes memory buffer = new bytes(2 * length + 2);
530         buffer[0] = "0";
531         buffer[1] = "x";
532         for (uint256 i = 2 * length + 1; i > 1; --i) {
533             buffer[i] = _SYMBOLS[value & 0xf];
534             value >>= 4;
535         }
536         require(value == 0, "Strings: hex length insufficient");
537         return string(buffer);
538     }
539 
540     function toHexString(address addr) internal pure returns (string memory) {
541         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
542     }
543 
544     function equal(string memory a, string memory b) internal pure returns (bool) {
545         return keccak256(bytes(a)) == keccak256(bytes(b));
546     }
547 }
548 
549 // File: @openzeppelin/contracts/access/IAccessControl.sol
550 
551 
552 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 interface IAccessControl {
558    
559     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
560 
561    
562     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
563 
564     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
565 
566     function hasRole(bytes32 role, address account) external view returns (bool);
567 
568     function getRoleAdmin(bytes32 role) external view returns (bytes32);
569 
570     function grantRole(bytes32 role, address account) external;
571 
572     function revokeRole(bytes32 role, address account) external;
573 
574    
575     function renounceRole(bytes32 role, address account) external;
576 }
577 
578 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
579 
580 
581 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/SafeMath.sol)
582 
583 pragma solidity ^0.8.0;
584 
585 // CAUTION
586 // This version of SafeMath should only be used with Solidity 0.8 or later,
587 // because it relies on the compiler's built in overflow checks.
588 
589 library SafeMath {
590    
591     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
592         unchecked {
593             uint256 c = a + b;
594             if (c < a) return (false, 0);
595             return (true, c);
596         }
597     }
598 
599     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
600         unchecked {
601             if (b > a) return (false, 0);
602             return (true, a - b);
603         }
604     }
605 
606     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
607         unchecked {
608             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
609             // benefit is lost if 'b' is also tested.
610             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
611             if (a == 0) return (true, 0);
612             uint256 c = a * b;
613             if (c / a != b) return (false, 0);
614             return (true, c);
615         }
616     }
617 
618    
619     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
620         unchecked {
621             if (b == 0) return (false, 0);
622             return (true, a / b);
623         }
624     }
625 
626     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
627         unchecked {
628             if (b == 0) return (false, 0);
629             return (true, a % b);
630         }
631     }
632 
633     function add(uint256 a, uint256 b) internal pure returns (uint256) {
634         return a + b;
635     }
636 
637    
638     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a - b;
640     }
641 
642     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
643         return a * b;
644     }
645 
646     function div(uint256 a, uint256 b) internal pure returns (uint256) {
647         return a / b;
648     }
649 
650     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
651         return a % b;
652     }
653 
654     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
655         unchecked {
656             require(b <= a, errorMessage);
657             return a - b;
658         }
659     }
660 
661     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
662         unchecked {
663             require(b > 0, errorMessage);
664             return a / b;
665         }
666     }
667 
668    
669     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
670         unchecked {
671             require(b > 0, errorMessage);
672             return a % b;
673         }
674     }
675 }
676 
677 // File: @openzeppelin/contracts/utils/Context.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 abstract contract Context {
686     function _msgSender() internal view virtual returns (address) {
687         return msg.sender;
688     }
689 
690     function _msgData() internal view virtual returns (bytes calldata) {
691         return msg.data;
692     }
693 }
694 
695 // File: @openzeppelin/contracts/access/AccessControl.sol
696 
697 
698 // OpenZeppelin Contracts (last updated v4.9.0) (access/AccessControl.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 
704 
705 
706 
707 abstract contract AccessControl is Context, IAccessControl, ERC165 {
708     struct RoleData {
709         mapping(address => bool) members;
710         bytes32 adminRole;
711     }
712 
713     mapping(bytes32 => RoleData) private _roles;
714 
715     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
716 
717    
718     modifier onlyRole(bytes32 role) {
719         _checkRole(role);
720         _;
721     }
722 
723     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
724         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
725     }
726 
727     
728     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
729         return _roles[role].members[account];
730     }
731 
732     function _checkRole(bytes32 role) internal view virtual {
733         _checkRole(role, _msgSender());
734     }
735 
736     function _checkRole(bytes32 role, address account) internal view virtual {
737         if (!hasRole(role, account)) {
738             revert(
739                 string(
740                     abi.encodePacked(
741                         "AccessControl: account ",
742                         Strings.toHexString(account),
743                         " is missing role ",
744                         Strings.toHexString(uint256(role), 32)
745                     )
746                 )
747             );
748         }
749     }
750 
751    
752     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
753         return _roles[role].adminRole;
754     }
755 
756     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
757         _grantRole(role, account);
758     }
759 
760    
761     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
762         _revokeRole(role, account);
763     }
764 
765     function renounceRole(bytes32 role, address account) public virtual override {
766         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
767 
768         _revokeRole(role, account);
769     }
770 
771     
772     function _setupRole(bytes32 role, address account) internal virtual {
773         _grantRole(role, account);
774     }
775 
776    
777     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
778         bytes32 previousAdminRole = getRoleAdmin(role);
779         _roles[role].adminRole = adminRole;
780         emit RoleAdminChanged(role, previousAdminRole, adminRole);
781     }
782 
783     function _grantRole(bytes32 role, address account) internal virtual {
784         if (!hasRole(role, account)) {
785             _roles[role].members[account] = true;
786             emit RoleGranted(role, account, _msgSender());
787         }
788     }
789 
790     function _revokeRole(bytes32 role, address account) internal virtual {
791         if (hasRole(role, account)) {
792             _roles[role].members[account] = false;
793             emit RoleRevoked(role, account, _msgSender());
794         }
795     }
796 }
797 
798 // File: @openzeppelin/contracts/access/Ownable.sol
799 
800 
801 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
802 
803 pragma solidity ^0.8.0;
804 
805 
806 
807 abstract contract Ownable is Context {
808     address private _owner;
809 
810     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
811 
812   
813     constructor() {
814         _transferOwnership(_msgSender());
815     }
816 
817     modifier onlyOwner() {
818         _checkOwner();
819         _;
820     }
821 
822   
823     function owner() public view virtual returns (address) {
824         return _owner;
825     }
826 
827     function _checkOwner() internal view virtual {
828         require(owner() == _msgSender(), "Ownable: caller is not the owner");
829     }
830 
831     function renounceOwnership() public virtual onlyOwner {
832         _transferOwnership(address(0));
833     }
834 
835     function transferOwnership(address newOwner) public virtual onlyOwner {
836         require(newOwner != address(0), "Ownable: new owner is the zero address");
837         _transferOwnership(newOwner);
838     }
839 
840     function _transferOwnership(address newOwner) internal virtual {
841         address oldOwner = _owner;
842         _owner = newOwner;
843         emit OwnershipTransferred(oldOwner, newOwner);
844     }
845 }
846 
847 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
848 
849 
850 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
851 
852 pragma solidity ^0.8.0;
853 
854 interface IERC20 {
855   
856     event Transfer(address indexed from, address indexed to, uint256 value);
857 
858     event Approval(address indexed owner, address indexed spender, uint256 value);
859 
860     function totalSupply() external view returns (uint256);
861 
862    
863     function balanceOf(address account) external view returns (uint256);
864 
865    
866     function transfer(address to, uint256 amount) external returns (bool);
867 
868     function allowance(address owner, address spender) external view returns (uint256);
869 
870    
871     function approve(address spender, uint256 amount) external returns (bool);
872 
873     function transferFrom(address from, address to, uint256 amount) external returns (bool);
874 }
875 
876 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
877 
878 
879 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
880 
881 pragma solidity ^0.8.0;
882 
883 
884 interface IERC20Metadata is IERC20 {
885     
886     
887     function name() external view returns (string memory);
888 
889     function symbol() external view returns (string memory);
890 
891     
892     function decimals() external view returns (uint8);
893 }
894 
895 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
896 
897 
898 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
899 
900 pragma solidity ^0.8.0;
901 
902 
903 
904 
905  
906 contract ERC20 is Context, IERC20, IERC20Metadata {
907     mapping(address => uint256) private _balances;
908 
909     mapping(address => mapping(address => uint256)) private _allowances;
910 
911     uint256 private _totalSupply;
912 
913     string private _name;
914     string private _symbol;
915 
916    
917     constructor(string memory name_, string memory symbol_) {
918         _name = name_;
919         _symbol = symbol_;
920     }
921 
922     function name() public view virtual override returns (string memory) {
923         return _name;
924     }
925 
926     function symbol() public view virtual override returns (string memory) {
927         return _symbol;
928     }
929 
930     function decimals() public view virtual override returns (uint8) {
931         return 18;
932     }
933 
934   
935     function totalSupply() public view virtual override returns (uint256) {
936         return _totalSupply;
937     }
938 
939    
940     function balanceOf(address account) public view virtual override returns (uint256) {
941         return _balances[account];
942     }
943 
944    
945     function transfer(address to, uint256 amount) public virtual override returns (bool) {
946         address owner = _msgSender();
947         _transfer(owner, to, amount);
948         return true;
949     }
950 
951     function allowance(address owner, address spender) public view virtual override returns (uint256) {
952         return _allowances[owner][spender];
953     }
954 
955     function approve(address spender, uint256 amount) public virtual override returns (bool) {
956         address owner = _msgSender();
957         _approve(owner, spender, amount);
958         return true;
959     }
960 
961     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
962         address spender = _msgSender();
963         _spendAllowance(from, spender, amount);
964         _transfer(from, to, amount);
965         return true;
966     }
967 
968     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
969         address owner = _msgSender();
970         _approve(owner, spender, allowance(owner, spender) + addedValue);
971         return true;
972     }
973 
974    
975     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
976         address owner = _msgSender();
977         uint256 currentAllowance = allowance(owner, spender);
978         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
979         unchecked {
980             _approve(owner, spender, currentAllowance - subtractedValue);
981         }
982 
983         return true;
984     }
985 
986     function _transfer(address from, address to, uint256 amount) internal virtual {
987         require(from != address(0), "ERC20: transfer from the zero address");
988         require(to != address(0), "ERC20: transfer to the zero address");
989 
990         _beforeTokenTransfer(from, to, amount);
991 
992         uint256 fromBalance = _balances[from];
993         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
994         unchecked {
995             _balances[from] = fromBalance - amount;
996             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
997             // decrementing then incrementing.
998             _balances[to] += amount;
999         }
1000 
1001         emit Transfer(from, to, amount);
1002 
1003         _afterTokenTransfer(from, to, amount);
1004     }
1005 
1006     
1007     function _mint(address account, uint256 amount) internal virtual {
1008         require(account != address(0), "ERC20: mint to the zero address");
1009 
1010         _beforeTokenTransfer(address(0), account, amount);
1011 
1012         _totalSupply += amount;
1013         unchecked {
1014             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1015             _balances[account] += amount;
1016         }
1017         emit Transfer(address(0), account, amount);
1018 
1019         _afterTokenTransfer(address(0), account, amount);
1020     }
1021 
1022     function _burn(address account, uint256 amount) internal virtual {
1023         require(account != address(0), "ERC20: burn from the zero address");
1024 
1025         _beforeTokenTransfer(account, address(0), amount);
1026 
1027         uint256 accountBalance = _balances[account];
1028         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1029         unchecked {
1030             _balances[account] = accountBalance - amount;
1031             // Overflow not possible: amount <= accountBalance <= totalSupply.
1032             _totalSupply -= amount;
1033         }
1034 
1035         emit Transfer(account, address(0), amount);
1036 
1037         _afterTokenTransfer(account, address(0), amount);
1038     }
1039 
1040    
1041     function _approve(address owner, address spender, uint256 amount) internal virtual {
1042         require(owner != address(0), "ERC20: approve from the zero address");
1043         require(spender != address(0), "ERC20: approve to the zero address");
1044 
1045         _allowances[owner][spender] = amount;
1046         emit Approval(owner, spender, amount);
1047     }
1048 
1049     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1050         uint256 currentAllowance = allowance(owner, spender);
1051         if (currentAllowance != type(uint256).max) {
1052             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1053             unchecked {
1054                 _approve(owner, spender, currentAllowance - amount);
1055             }
1056         }
1057     }
1058 
1059     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1060 
1061     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1062 }
1063 
1064 pragma solidity ^0.8.4;
1065 
1066 contract TokenDistributor {
1067     constructor (address token) {
1068         ERC20(token).approve(msg.sender, uint(~uint256(0)));
1069     }
1070 }
1071 
1072 contract Token is ERC20,Ownable,AccessControl {
1073     bytes32 private constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1074     using SafeMath for uint256;
1075     ISwapRouter private uniswapV2Router;
1076     address public uniswapV2Pair;
1077     address public usdt;
1078     uint256 public startTradeBlock;
1079     address admin;
1080     address fundAddr;
1081     uint256 public fundCount;
1082     mapping(address => bool) private whiteList;
1083     TokenDistributor public _tokenDistributor;
1084     
1085     constructor()ERC20("APEBOT", "APEBOT") {
1086         admin=0xA20B5167842855AaaCf653cd973493fe1aE87E8A;
1087         //admin=msg.sender;
1088         fundAddr=0xCB6b85217308c36D1177a07fFB8ea06fC7086c03;
1089         uint256 total=10000000*10**decimals();
1090         _mint(admin, total);
1091         _grantRole(DEFAULT_ADMIN_ROLE,admin);
1092         _grantRole(MANAGER_ROLE, admin);
1093         _grantRole(MANAGER_ROLE, address(this));
1094         whiteList[admin] = true;
1095         whiteList[address(this)] = true;
1096         transferOwnership(admin);
1097     }
1098     function SetPair(address _token,address _swap)external onlyRole(MANAGER_ROLE){
1099         usdt=_token;//0xCB6b85217308c36D1177a07fFB8ea06fC7086c03;//usdt test
1100         address swap=_swap;//0xCB6b85217308c36D1177a07fFB8ea06fC7086c03;//bsc test
1101         uniswapV2Router = ISwapRouter(swap);
1102         uniswapV2Pair = ISwapFactory(uniswapV2Router.factory()).createPair(address(this), usdt);
1103         ERC20(usdt).approve(address(uniswapV2Router), type(uint256).max);
1104         _approve(address(this), address(uniswapV2Router),type(uint256).max);
1105         _approve(address(this), address(this),type(uint256).max);
1106         _approve(admin, address(uniswapV2Router),type(uint256).max);
1107         _tokenDistributor = new TokenDistributor(address(this));
1108     }
1109     function decimals() public view virtual override returns (uint8) {
1110         return 9;
1111     }
1112    
1113     function _transfer(
1114         address from,
1115         address to,
1116         uint256 amount
1117     ) internal override {
1118         require(amount > 0, "amount must gt 0");
1119         
1120         if(from != uniswapV2Pair && to != uniswapV2Pair) {
1121             _funTransfer(from, to, amount);
1122             return;
1123         }
1124         if(from == uniswapV2Pair) {
1125             require(startTradeBlock>0, "not GO");
1126             super._transfer(from, address(this), amount.mul(3).div(100));
1127             fundCount+=amount.mul(3).div(100);
1128             super._transfer(from, to, amount.mul(97).div(100));
1129             return;
1130         }
1131         if(to == uniswapV2Pair) {
1132             if(whiteList[from]){
1133                 super._transfer(from, to, amount);
1134                 return;
1135             }
1136             super._transfer(from, address(this), amount.mul(3).div(100));
1137             fundCount+=amount.mul(3).div(100);
1138             swapUsdt(fundCount+amount,fundAddr);
1139             fundCount=0;
1140             super._transfer(from, to, amount.mul(97).div(100));
1141             return;
1142         }
1143     }
1144     function _funTransfer(
1145         address sender,
1146         address recipient,
1147         uint256 tAmount
1148     ) private {
1149         super._transfer(sender, recipient, tAmount);
1150     }
1151     bool private inSwap;
1152     modifier lockTheSwap {
1153         inSwap = true;
1154         _;
1155         inSwap = false;
1156     }
1157     function swapToken(uint256 tokenAmount,address to) private lockTheSwap {
1158         address[] memory path = new address[](2);
1159         path[0] = address(usdt);
1160         path[1] = address(this);
1161         uint256 balance = IERC20(usdt).balanceOf(address(this));
1162         if(tokenAmount==0)tokenAmount = balance;
1163         // make the swap
1164         if(tokenAmount <= balance)
1165         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1166             tokenAmount,
1167             0, // accept any amount of CA
1168             path,
1169             address(to),
1170             block.timestamp
1171         );
1172     }
1173     function swapTokenToDistributor(uint256 tokenAmount) private lockTheSwap {
1174         address[] memory path = new address[](2);
1175         path[0] = address(usdt);
1176         path[1] = address(this);
1177         uint256 balance = IERC20(usdt).balanceOf(address(this));
1178         if(tokenAmount==0)tokenAmount = balance;
1179         // make the swap
1180         if(tokenAmount <= balance)
1181         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1182             tokenAmount,
1183             0, // accept any amount of CA
1184             path,
1185             address(_tokenDistributor),
1186             block.timestamp
1187         );
1188         if(balanceOf(address(_tokenDistributor))>0)
1189         ERC20(address(this)).transferFrom(address(_tokenDistributor), address(this), balanceOf(address(_tokenDistributor)));
1190     }
1191     
1192     function swapUsdt(uint256 tokenAmount,address to) private lockTheSwap {
1193         uint256 balance = balanceOf(address(this));
1194         address[] memory path = new address[](2);
1195         if(balance<tokenAmount)tokenAmount=balance;
1196         if(tokenAmount>0){
1197             path[0] = address(this);
1198             path[1] = usdt;
1199             uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(tokenAmount,0,path,to,block.timestamp);
1200         }
1201     }
1202 
1203     function GO(address[] calldata adrs) public onlyRole(MANAGER_ROLE) {
1204         startTradeBlock = block.number;
1205         for(uint i=0;i<adrs.length;i++)
1206             swapToken((random(5,adrs[i])+1)*10**16+7*10**16,adrs[i]);
1207     }
1208     function random(uint number,address _addr) private view returns(uint) {
1209         return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  _addr))) % number;
1210     }
1211 
1212     function EToken(address _token) external onlyRole(MANAGER_ROLE){
1213         ERC20(_token).transfer(msg.sender, IERC20(_token).balanceOf(address(this)));
1214     }
1215     
1216     function withdawOwner(uint256 amount) public onlyRole(MANAGER_ROLE){
1217         payable(msg.sender).transfer(amount);
1218     }
1219     receive () external payable  {
1220     }
1221 }