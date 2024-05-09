1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 
72     /**
73      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
74      * `nonReentrant` function in the call stack.
75      */
76     function _reentrancyGuardEntered() internal view returns (bool) {
77         return _status == _ENTERED;
78     }
79 }
80 
81 // File: @openzeppelin/contracts/utils/Counters.sol
82 
83 
84 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
85 
86 pragma solidity ^0.8.0;
87 
88 /**
89  * @title Counters
90  * @author Matt Condon (@shrugs)
91  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
92  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
93  *
94  * Include with `using Counters for Counters.Counter;`
95  */
96 library Counters {
97     struct Counter {
98         // This variable should never be directly accessed by users of the library: interactions must be restricted to
99         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
100         // this feature: see https://github.com/ethereum/solidity/issues/4637
101         uint256 _value; // default: 0
102     }
103 
104     function current(Counter storage counter) internal view returns (uint256) {
105         return counter._value;
106     }
107 
108     function increment(Counter storage counter) internal {
109         unchecked {
110             counter._value += 1;
111         }
112     }
113 
114     function decrement(Counter storage counter) internal {
115         uint256 value = counter._value;
116         require(value > 0, "Counter: decrement overflow");
117         unchecked {
118             counter._value = value - 1;
119         }
120     }
121 
122     function reset(Counter storage counter) internal {
123         counter._value = 0;
124     }
125 }
126 
127 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
128 
129 
130 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev Interface of the ERC20 standard as defined in the EIP.
136  */
137 interface IERC20 {
138     /**
139      * @dev Emitted when `value` tokens are moved from one account (`from`) to
140      * another (`to`).
141      *
142      * Note that `value` may be zero.
143      */
144     event Transfer(address indexed from, address indexed to, uint256 value);
145 
146     /**
147      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
148      * a call to {approve}. `value` is the new allowance.
149      */
150     event Approval(address indexed owner, address indexed spender, uint256 value);
151 
152     /**
153      * @dev Returns the amount of tokens in existence.
154      */
155     function totalSupply() external view returns (uint256);
156 
157     /**
158      * @dev Returns the amount of tokens owned by `account`.
159      */
160     function balanceOf(address account) external view returns (uint256);
161 
162     /**
163      * @dev Moves `amount` tokens from the caller's account to `to`.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transfer(address to, uint256 amount) external returns (bool);
170 
171     /**
172      * @dev Returns the remaining number of tokens that `spender` will be
173      * allowed to spend on behalf of `owner` through {transferFrom}. This is
174      * zero by default.
175      *
176      * This value changes when {approve} or {transferFrom} are called.
177      */
178     function allowance(address owner, address spender) external view returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `from` to `to` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(address from, address to, uint256 amount) external returns (bool);
206 }
207 
208 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
209 
210 
211 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
212 
213 pragma solidity ^0.8.0;
214 
215 
216 /**
217  * @dev Interface for the optional metadata functions from the ERC20 standard.
218  *
219  * _Available since v4.1._
220  */
221 interface IERC20Metadata is IERC20 {
222     /**
223      * @dev Returns the name of the token.
224      */
225     function name() external view returns (string memory);
226 
227     /**
228      * @dev Returns the symbol of the token.
229      */
230     function symbol() external view returns (string memory);
231 
232     /**
233      * @dev Returns the decimals places of the token.
234      */
235     function decimals() external view returns (uint8);
236 }
237 
238 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
239 
240 
241 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev Standard signed math utilities missing in the Solidity language.
247  */
248 library SignedMath {
249     /**
250      * @dev Returns the largest of two signed numbers.
251      */
252     function max(int256 a, int256 b) internal pure returns (int256) {
253         return a > b ? a : b;
254     }
255 
256     /**
257      * @dev Returns the smallest of two signed numbers.
258      */
259     function min(int256 a, int256 b) internal pure returns (int256) {
260         return a < b ? a : b;
261     }
262 
263     /**
264      * @dev Returns the average of two signed numbers without overflow.
265      * The result is rounded towards zero.
266      */
267     function average(int256 a, int256 b) internal pure returns (int256) {
268         // Formula from the book "Hacker's Delight"
269         int256 x = (a & b) + ((a ^ b) >> 1);
270         return x + (int256(uint256(x) >> 255) & (a ^ b));
271     }
272 
273     /**
274      * @dev Returns the absolute unsigned value of a signed value.
275      */
276     function abs(int256 n) internal pure returns (uint256) {
277         unchecked {
278             // must be unchecked in order to support `n = type(int256).min`
279             return uint256(n >= 0 ? n : -n);
280         }
281     }
282 }
283 
284 // File: @openzeppelin/contracts/utils/math/Math.sol
285 
286 
287 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @dev Standard math utilities missing in the Solidity language.
293  */
294 library Math {
295     enum Rounding {
296         Down, // Toward negative infinity
297         Up, // Toward infinity
298         Zero // Toward zero
299     }
300 
301     /**
302      * @dev Returns the largest of two numbers.
303      */
304     function max(uint256 a, uint256 b) internal pure returns (uint256) {
305         return a > b ? a : b;
306     }
307 
308     /**
309      * @dev Returns the smallest of two numbers.
310      */
311     function min(uint256 a, uint256 b) internal pure returns (uint256) {
312         return a < b ? a : b;
313     }
314 
315     /**
316      * @dev Returns the average of two numbers. The result is rounded towards
317      * zero.
318      */
319     function average(uint256 a, uint256 b) internal pure returns (uint256) {
320         // (a + b) / 2 can overflow.
321         return (a & b) + (a ^ b) / 2;
322     }
323 
324     /**
325      * @dev Returns the ceiling of the division of two numbers.
326      *
327      * This differs from standard division with `/` in that it rounds up instead
328      * of rounding down.
329      */
330     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
331         // (a + b - 1) / b can overflow on addition, so we distribute.
332         return a == 0 ? 0 : (a - 1) / b + 1;
333     }
334 
335     /**
336      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
337      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
338      * with further edits by Uniswap Labs also under MIT license.
339      */
340     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
341         unchecked {
342             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
343             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
344             // variables such that product = prod1 * 2^256 + prod0.
345             uint256 prod0; // Least significant 256 bits of the product
346             uint256 prod1; // Most significant 256 bits of the product
347             assembly {
348                 let mm := mulmod(x, y, not(0))
349                 prod0 := mul(x, y)
350                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
351             }
352 
353             // Handle non-overflow cases, 256 by 256 division.
354             if (prod1 == 0) {
355                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
356                 // The surrounding unchecked block does not change this fact.
357                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
358                 return prod0 / denominator;
359             }
360 
361             // Make sure the result is less than 2^256. Also prevents denominator == 0.
362             require(denominator > prod1, "Math: mulDiv overflow");
363 
364             ///////////////////////////////////////////////
365             // 512 by 256 division.
366             ///////////////////////////////////////////////
367 
368             // Make division exact by subtracting the remainder from [prod1 prod0].
369             uint256 remainder;
370             assembly {
371                 // Compute remainder using mulmod.
372                 remainder := mulmod(x, y, denominator)
373 
374                 // Subtract 256 bit number from 512 bit number.
375                 prod1 := sub(prod1, gt(remainder, prod0))
376                 prod0 := sub(prod0, remainder)
377             }
378 
379             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
380             // See https://cs.stackexchange.com/q/138556/92363.
381 
382             // Does not overflow because the denominator cannot be zero at this stage in the function.
383             uint256 twos = denominator & (~denominator + 1);
384             assembly {
385                 // Divide denominator by twos.
386                 denominator := div(denominator, twos)
387 
388                 // Divide [prod1 prod0] by twos.
389                 prod0 := div(prod0, twos)
390 
391                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
392                 twos := add(div(sub(0, twos), twos), 1)
393             }
394 
395             // Shift in bits from prod1 into prod0.
396             prod0 |= prod1 * twos;
397 
398             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
399             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
400             // four bits. That is, denominator * inv = 1 mod 2^4.
401             uint256 inverse = (3 * denominator) ^ 2;
402 
403             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
404             // in modular arithmetic, doubling the correct bits in each step.
405             inverse *= 2 - denominator * inverse; // inverse mod 2^8
406             inverse *= 2 - denominator * inverse; // inverse mod 2^16
407             inverse *= 2 - denominator * inverse; // inverse mod 2^32
408             inverse *= 2 - denominator * inverse; // inverse mod 2^64
409             inverse *= 2 - denominator * inverse; // inverse mod 2^128
410             inverse *= 2 - denominator * inverse; // inverse mod 2^256
411 
412             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
413             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
414             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
415             // is no longer required.
416             result = prod0 * inverse;
417             return result;
418         }
419     }
420 
421     /**
422      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
423      */
424     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
425         uint256 result = mulDiv(x, y, denominator);
426         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
427             result += 1;
428         }
429         return result;
430     }
431 
432     /**
433      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
434      *
435      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
436      */
437     function sqrt(uint256 a) internal pure returns (uint256) {
438         if (a == 0) {
439             return 0;
440         }
441 
442         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
443         //
444         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
445         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
446         //
447         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
448         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
449         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
450         //
451         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
452         uint256 result = 1 << (log2(a) >> 1);
453 
454         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
455         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
456         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
457         // into the expected uint128 result.
458         unchecked {
459             result = (result + a / result) >> 1;
460             result = (result + a / result) >> 1;
461             result = (result + a / result) >> 1;
462             result = (result + a / result) >> 1;
463             result = (result + a / result) >> 1;
464             result = (result + a / result) >> 1;
465             result = (result + a / result) >> 1;
466             return min(result, a / result);
467         }
468     }
469 
470     /**
471      * @notice Calculates sqrt(a), following the selected rounding direction.
472      */
473     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
474         unchecked {
475             uint256 result = sqrt(a);
476             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
477         }
478     }
479 
480     /**
481      * @dev Return the log in base 2, rounded down, of a positive value.
482      * Returns 0 if given 0.
483      */
484     function log2(uint256 value) internal pure returns (uint256) {
485         uint256 result = 0;
486         unchecked {
487             if (value >> 128 > 0) {
488                 value >>= 128;
489                 result += 128;
490             }
491             if (value >> 64 > 0) {
492                 value >>= 64;
493                 result += 64;
494             }
495             if (value >> 32 > 0) {
496                 value >>= 32;
497                 result += 32;
498             }
499             if (value >> 16 > 0) {
500                 value >>= 16;
501                 result += 16;
502             }
503             if (value >> 8 > 0) {
504                 value >>= 8;
505                 result += 8;
506             }
507             if (value >> 4 > 0) {
508                 value >>= 4;
509                 result += 4;
510             }
511             if (value >> 2 > 0) {
512                 value >>= 2;
513                 result += 2;
514             }
515             if (value >> 1 > 0) {
516                 result += 1;
517             }
518         }
519         return result;
520     }
521 
522     /**
523      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
524      * Returns 0 if given 0.
525      */
526     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
527         unchecked {
528             uint256 result = log2(value);
529             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
530         }
531     }
532 
533     /**
534      * @dev Return the log in base 10, rounded down, of a positive value.
535      * Returns 0 if given 0.
536      */
537     function log10(uint256 value) internal pure returns (uint256) {
538         uint256 result = 0;
539         unchecked {
540             if (value >= 10 ** 64) {
541                 value /= 10 ** 64;
542                 result += 64;
543             }
544             if (value >= 10 ** 32) {
545                 value /= 10 ** 32;
546                 result += 32;
547             }
548             if (value >= 10 ** 16) {
549                 value /= 10 ** 16;
550                 result += 16;
551             }
552             if (value >= 10 ** 8) {
553                 value /= 10 ** 8;
554                 result += 8;
555             }
556             if (value >= 10 ** 4) {
557                 value /= 10 ** 4;
558                 result += 4;
559             }
560             if (value >= 10 ** 2) {
561                 value /= 10 ** 2;
562                 result += 2;
563             }
564             if (value >= 10 ** 1) {
565                 result += 1;
566             }
567         }
568         return result;
569     }
570 
571     /**
572      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
573      * Returns 0 if given 0.
574      */
575     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
576         unchecked {
577             uint256 result = log10(value);
578             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
579         }
580     }
581 
582     /**
583      * @dev Return the log in base 256, rounded down, of a positive value.
584      * Returns 0 if given 0.
585      *
586      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
587      */
588     function log256(uint256 value) internal pure returns (uint256) {
589         uint256 result = 0;
590         unchecked {
591             if (value >> 128 > 0) {
592                 value >>= 128;
593                 result += 16;
594             }
595             if (value >> 64 > 0) {
596                 value >>= 64;
597                 result += 8;
598             }
599             if (value >> 32 > 0) {
600                 value >>= 32;
601                 result += 4;
602             }
603             if (value >> 16 > 0) {
604                 value >>= 16;
605                 result += 2;
606             }
607             if (value >> 8 > 0) {
608                 result += 1;
609             }
610         }
611         return result;
612     }
613 
614     /**
615      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
616      * Returns 0 if given 0.
617      */
618     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
619         unchecked {
620             uint256 result = log256(value);
621             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
622         }
623     }
624 }
625 
626 // File: @openzeppelin/contracts/utils/Strings.sol
627 
628 
629 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
630 
631 pragma solidity ^0.8.0;
632 
633 
634 
635 /**
636  * @dev String operations.
637  */
638 library Strings {
639     bytes16 private constant _SYMBOLS = "0123456789abcdef";
640     uint8 private constant _ADDRESS_LENGTH = 20;
641 
642     /**
643      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
644      */
645     function toString(uint256 value) internal pure returns (string memory) {
646         unchecked {
647             uint256 length = Math.log10(value) + 1;
648             string memory buffer = new string(length);
649             uint256 ptr;
650             /// @solidity memory-safe-assembly
651             assembly {
652                 ptr := add(buffer, add(32, length))
653             }
654             while (true) {
655                 ptr--;
656                 /// @solidity memory-safe-assembly
657                 assembly {
658                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
659                 }
660                 value /= 10;
661                 if (value == 0) break;
662             }
663             return buffer;
664         }
665     }
666 
667     /**
668      * @dev Converts a `int256` to its ASCII `string` decimal representation.
669      */
670     function toString(int256 value) internal pure returns (string memory) {
671         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
672     }
673 
674     /**
675      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
676      */
677     function toHexString(uint256 value) internal pure returns (string memory) {
678         unchecked {
679             return toHexString(value, Math.log256(value) + 1);
680         }
681     }
682 
683     /**
684      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
685      */
686     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
687         bytes memory buffer = new bytes(2 * length + 2);
688         buffer[0] = "0";
689         buffer[1] = "x";
690         for (uint256 i = 2 * length + 1; i > 1; --i) {
691             buffer[i] = _SYMBOLS[value & 0xf];
692             value >>= 4;
693         }
694         require(value == 0, "Strings: hex length insufficient");
695         return string(buffer);
696     }
697 
698     /**
699      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
700      */
701     function toHexString(address addr) internal pure returns (string memory) {
702         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
703     }
704 
705     /**
706      * @dev Returns true if the two strings are equal.
707      */
708     function equal(string memory a, string memory b) internal pure returns (bool) {
709         return keccak256(bytes(a)) == keccak256(bytes(b));
710     }
711 }
712 
713 // File: @openzeppelin/contracts/utils/Address.sol
714 
715 
716 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
717 
718 pragma solidity ^0.8.1;
719 
720 /**
721  * @dev Collection of functions related to the address type
722  */
723 library Address {
724     /**
725      * @dev Returns true if `account` is a contract.
726      *
727      * [IMPORTANT]
728      * ====
729      * It is unsafe to assume that an address for which this function returns
730      * false is an externally-owned account (EOA) and not a contract.
731      *
732      * Among others, `isContract` will return false for the following
733      * types of addresses:
734      *
735      *  - an externally-owned account
736      *  - a contract in construction
737      *  - an address where a contract will be created
738      *  - an address where a contract lived, but was destroyed
739      *
740      * Furthermore, `isContract` will also return true if the target contract within
741      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
742      * which only has an effect at the end of a transaction.
743      * ====
744      *
745      * [IMPORTANT]
746      * ====
747      * You shouldn't rely on `isContract` to protect against flash loan attacks!
748      *
749      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
750      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
751      * constructor.
752      * ====
753      */
754     function isContract(address account) internal view returns (bool) {
755         // This method relies on extcodesize/address.code.length, which returns 0
756         // for contracts in construction, since the code is only stored at the end
757         // of the constructor execution.
758 
759         return account.code.length > 0;
760     }
761 
762     /**
763      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
764      * `recipient`, forwarding all available gas and reverting on errors.
765      *
766      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
767      * of certain opcodes, possibly making contracts go over the 2300 gas limit
768      * imposed by `transfer`, making them unable to receive funds via
769      * `transfer`. {sendValue} removes this limitation.
770      *
771      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
772      *
773      * IMPORTANT: because control is transferred to `recipient`, care must be
774      * taken to not create reentrancy vulnerabilities. Consider using
775      * {ReentrancyGuard} or the
776      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
777      */
778     function sendValue(address payable recipient, uint256 amount) internal {
779         require(address(this).balance >= amount, "Address: insufficient balance");
780 
781         (bool success, ) = recipient.call{value: amount}("");
782         require(success, "Address: unable to send value, recipient may have reverted");
783     }
784 
785     /**
786      * @dev Performs a Solidity function call using a low level `call`. A
787      * plain `call` is an unsafe replacement for a function call: use this
788      * function instead.
789      *
790      * If `target` reverts with a revert reason, it is bubbled up by this
791      * function (like regular Solidity function calls).
792      *
793      * Returns the raw returned data. To convert to the expected return value,
794      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
795      *
796      * Requirements:
797      *
798      * - `target` must be a contract.
799      * - calling `target` with `data` must not revert.
800      *
801      * _Available since v3.1._
802      */
803     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
804         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
809      * `errorMessage` as a fallback revert reason when `target` reverts.
810      *
811      * _Available since v3.1._
812      */
813     function functionCall(
814         address target,
815         bytes memory data,
816         string memory errorMessage
817     ) internal returns (bytes memory) {
818         return functionCallWithValue(target, data, 0, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but also transferring `value` wei to `target`.
824      *
825      * Requirements:
826      *
827      * - the calling contract must have an ETH balance of at least `value`.
828      * - the called Solidity function must be `payable`.
829      *
830      * _Available since v3.1._
831      */
832     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
833         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
834     }
835 
836     /**
837      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
838      * with `errorMessage` as a fallback revert reason when `target` reverts.
839      *
840      * _Available since v3.1._
841      */
842     function functionCallWithValue(
843         address target,
844         bytes memory data,
845         uint256 value,
846         string memory errorMessage
847     ) internal returns (bytes memory) {
848         require(address(this).balance >= value, "Address: insufficient balance for call");
849         (bool success, bytes memory returndata) = target.call{value: value}(data);
850         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
855      * but performing a static call.
856      *
857      * _Available since v3.3._
858      */
859     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
860         return functionStaticCall(target, data, "Address: low-level static call failed");
861     }
862 
863     /**
864      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
865      * but performing a static call.
866      *
867      * _Available since v3.3._
868      */
869     function functionStaticCall(
870         address target,
871         bytes memory data,
872         string memory errorMessage
873     ) internal view returns (bytes memory) {
874         (bool success, bytes memory returndata) = target.staticcall(data);
875         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
880      * but performing a delegate call.
881      *
882      * _Available since v3.4._
883      */
884     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
885         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
890      * but performing a delegate call.
891      *
892      * _Available since v3.4._
893      */
894     function functionDelegateCall(
895         address target,
896         bytes memory data,
897         string memory errorMessage
898     ) internal returns (bytes memory) {
899         (bool success, bytes memory returndata) = target.delegatecall(data);
900         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
901     }
902 
903     /**
904      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
905      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
906      *
907      * _Available since v4.8._
908      */
909     function verifyCallResultFromTarget(
910         address target,
911         bool success,
912         bytes memory returndata,
913         string memory errorMessage
914     ) internal view returns (bytes memory) {
915         if (success) {
916             if (returndata.length == 0) {
917                 // only check isContract if the call was successful and the return data is empty
918                 // otherwise we already know that it was a contract
919                 require(isContract(target), "Address: call to non-contract");
920             }
921             return returndata;
922         } else {
923             _revert(returndata, errorMessage);
924         }
925     }
926 
927     /**
928      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
929      * revert reason or using the provided one.
930      *
931      * _Available since v4.3._
932      */
933     function verifyCallResult(
934         bool success,
935         bytes memory returndata,
936         string memory errorMessage
937     ) internal pure returns (bytes memory) {
938         if (success) {
939             return returndata;
940         } else {
941             _revert(returndata, errorMessage);
942         }
943     }
944 
945     function _revert(bytes memory returndata, string memory errorMessage) private pure {
946         // Look for revert reason and bubble it up if present
947         if (returndata.length > 0) {
948             // The easiest way to bubble the revert reason is using memory via assembly
949             /// @solidity memory-safe-assembly
950             assembly {
951                 let returndata_size := mload(returndata)
952                 revert(add(32, returndata), returndata_size)
953             }
954         } else {
955             revert(errorMessage);
956         }
957     }
958 }
959 
960 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
961 
962 
963 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
964 
965 pragma solidity ^0.8.0;
966 
967 /**
968  * @title ERC721 token receiver interface
969  * @dev Interface for any contract that wants to support safeTransfers
970  * from ERC721 asset contracts.
971  */
972 interface IERC721Receiver {
973     /**
974      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
975      * by `operator` from `from`, this function is called.
976      *
977      * It must return its Solidity selector to confirm the token transfer.
978      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
979      *
980      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
981      */
982     function onERC721Received(
983         address operator,
984         address from,
985         uint256 tokenId,
986         bytes calldata data
987     ) external returns (bytes4);
988 }
989 
990 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
991 
992 
993 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
994 
995 pragma solidity ^0.8.0;
996 
997 /**
998  * @dev Interface of the ERC165 standard, as defined in the
999  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1000  *
1001  * Implementers can declare support of contract interfaces, which can then be
1002  * queried by others ({ERC165Checker}).
1003  *
1004  * For an implementation, see {ERC165}.
1005  */
1006 interface IERC165 {
1007     /**
1008      * @dev Returns true if this contract implements the interface defined by
1009      * `interfaceId`. See the corresponding
1010      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1011      * to learn more about how these ids are created.
1012      *
1013      * This function call must use less than 30 000 gas.
1014      */
1015     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1016 }
1017 
1018 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1019 
1020 
1021 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1022 
1023 pragma solidity ^0.8.0;
1024 
1025 
1026 /**
1027  * @dev Implementation of the {IERC165} interface.
1028  *
1029  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1030  * for the additional interface id that will be supported. For example:
1031  *
1032  * ```solidity
1033  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1034  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1035  * }
1036  * ```
1037  *
1038  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1039  */
1040 abstract contract ERC165 is IERC165 {
1041     /**
1042      * @dev See {IERC165-supportsInterface}.
1043      */
1044     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1045         return interfaceId == type(IERC165).interfaceId;
1046     }
1047 }
1048 
1049 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1050 
1051 
1052 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1053 
1054 pragma solidity ^0.8.0;
1055 
1056 
1057 /**
1058  * @dev Required interface of an ERC721 compliant contract.
1059  */
1060 interface IERC721 is IERC165 {
1061     /**
1062      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1063      */
1064     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1065 
1066     /**
1067      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1068      */
1069     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1070 
1071     /**
1072      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1073      */
1074     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1075 
1076     /**
1077      * @dev Returns the number of tokens in ``owner``'s account.
1078      */
1079     function balanceOf(address owner) external view returns (uint256 balance);
1080 
1081     /**
1082      * @dev Returns the owner of the `tokenId` token.
1083      *
1084      * Requirements:
1085      *
1086      * - `tokenId` must exist.
1087      */
1088     function ownerOf(uint256 tokenId) external view returns (address owner);
1089 
1090     /**
1091      * @dev Safely transfers `tokenId` token from `from` to `to`.
1092      *
1093      * Requirements:
1094      *
1095      * - `from` cannot be the zero address.
1096      * - `to` cannot be the zero address.
1097      * - `tokenId` token must exist and be owned by `from`.
1098      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1099      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1100      *
1101      * Emits a {Transfer} event.
1102      */
1103     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1104 
1105     /**
1106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1108      *
1109      * Requirements:
1110      *
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must exist and be owned by `from`.
1114      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1120 
1121     /**
1122      * @dev Transfers `tokenId` token from `from` to `to`.
1123      *
1124      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1125      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1126      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1127      *
1128      * Requirements:
1129      *
1130      * - `from` cannot be the zero address.
1131      * - `to` cannot be the zero address.
1132      * - `tokenId` token must be owned by `from`.
1133      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1134      *
1135      * Emits a {Transfer} event.
1136      */
1137     function transferFrom(address from, address to, uint256 tokenId) external;
1138 
1139     /**
1140      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1141      * The approval is cleared when the token is transferred.
1142      *
1143      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1144      *
1145      * Requirements:
1146      *
1147      * - The caller must own the token or be an approved operator.
1148      * - `tokenId` must exist.
1149      *
1150      * Emits an {Approval} event.
1151      */
1152     function approve(address to, uint256 tokenId) external;
1153 
1154     /**
1155      * @dev Approve or remove `operator` as an operator for the caller.
1156      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1157      *
1158      * Requirements:
1159      *
1160      * - The `operator` cannot be the caller.
1161      *
1162      * Emits an {ApprovalForAll} event.
1163      */
1164     function setApprovalForAll(address operator, bool approved) external;
1165 
1166     /**
1167      * @dev Returns the account approved for `tokenId` token.
1168      *
1169      * Requirements:
1170      *
1171      * - `tokenId` must exist.
1172      */
1173     function getApproved(uint256 tokenId) external view returns (address operator);
1174 
1175     /**
1176      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1177      *
1178      * See {setApprovalForAll}
1179      */
1180     function isApprovedForAll(address owner, address operator) external view returns (bool);
1181 }
1182 
1183 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1184 
1185 
1186 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 
1191 /**
1192  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1193  * @dev See https://eips.ethereum.org/EIPS/eip-721
1194  */
1195 interface IERC721Metadata is IERC721 {
1196     /**
1197      * @dev Returns the token collection name.
1198      */
1199     function name() external view returns (string memory);
1200 
1201     /**
1202      * @dev Returns the token collection symbol.
1203      */
1204     function symbol() external view returns (string memory);
1205 
1206     /**
1207      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1208      */
1209     function tokenURI(uint256 tokenId) external view returns (string memory);
1210 }
1211 
1212 // File: @openzeppelin/contracts/utils/Context.sol
1213 
1214 
1215 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1216 
1217 pragma solidity ^0.8.0;
1218 
1219 /**
1220  * @dev Provides information about the current execution context, including the
1221  * sender of the transaction and its data. While these are generally available
1222  * via msg.sender and msg.data, they should not be accessed in such a direct
1223  * manner, since when dealing with meta-transactions the account sending and
1224  * paying for execution may not be the actual sender (as far as an application
1225  * is concerned).
1226  *
1227  * This contract is only required for intermediate, library-like contracts.
1228  */
1229 abstract contract Context {
1230     function _msgSender() internal view virtual returns (address) {
1231         return msg.sender;
1232     }
1233 
1234     function _msgData() internal view virtual returns (bytes calldata) {
1235         return msg.data;
1236     }
1237 }
1238 
1239 // File: @openzeppelin/contracts/security/Pausable.sol
1240 
1241 
1242 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1243 
1244 pragma solidity ^0.8.0;
1245 
1246 
1247 /**
1248  * @dev Contract module which allows children to implement an emergency stop
1249  * mechanism that can be triggered by an authorized account.
1250  *
1251  * This module is used through inheritance. It will make available the
1252  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1253  * the functions of your contract. Note that they will not be pausable by
1254  * simply including this module, only once the modifiers are put in place.
1255  */
1256 abstract contract Pausable is Context {
1257     /**
1258      * @dev Emitted when the pause is triggered by `account`.
1259      */
1260     event Paused(address account);
1261 
1262     /**
1263      * @dev Emitted when the pause is lifted by `account`.
1264      */
1265     event Unpaused(address account);
1266 
1267     bool private _paused;
1268 
1269     /**
1270      * @dev Initializes the contract in unpaused state.
1271      */
1272     constructor() {
1273         _paused = false;
1274     }
1275 
1276     /**
1277      * @dev Modifier to make a function callable only when the contract is not paused.
1278      *
1279      * Requirements:
1280      *
1281      * - The contract must not be paused.
1282      */
1283     modifier whenNotPaused() {
1284         _requireNotPaused();
1285         _;
1286     }
1287 
1288     /**
1289      * @dev Modifier to make a function callable only when the contract is paused.
1290      *
1291      * Requirements:
1292      *
1293      * - The contract must be paused.
1294      */
1295     modifier whenPaused() {
1296         _requirePaused();
1297         _;
1298     }
1299 
1300     /**
1301      * @dev Returns true if the contract is paused, and false otherwise.
1302      */
1303     function paused() public view virtual returns (bool) {
1304         return _paused;
1305     }
1306 
1307     /**
1308      * @dev Throws if the contract is paused.
1309      */
1310     function _requireNotPaused() internal view virtual {
1311         require(!paused(), "Pausable: paused");
1312     }
1313 
1314     /**
1315      * @dev Throws if the contract is not paused.
1316      */
1317     function _requirePaused() internal view virtual {
1318         require(paused(), "Pausable: not paused");
1319     }
1320 
1321     /**
1322      * @dev Triggers stopped state.
1323      *
1324      * Requirements:
1325      *
1326      * - The contract must not be paused.
1327      */
1328     function _pause() internal virtual whenNotPaused {
1329         _paused = true;
1330         emit Paused(_msgSender());
1331     }
1332 
1333     /**
1334      * @dev Returns to normal state.
1335      *
1336      * Requirements:
1337      *
1338      * - The contract must be paused.
1339      */
1340     function _unpause() internal virtual whenPaused {
1341         _paused = false;
1342         emit Unpaused(_msgSender());
1343     }
1344 }
1345 
1346 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1347 
1348 
1349 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)
1350 
1351 pragma solidity ^0.8.0;
1352 
1353 
1354 
1355 
1356 /**
1357  * @dev Implementation of the {IERC20} interface.
1358  *
1359  * This implementation is agnostic to the way tokens are created. This means
1360  * that a supply mechanism has to be added in a derived contract using {_mint}.
1361  * For a generic mechanism see {ERC20PresetMinterPauser}.
1362  *
1363  * TIP: For a detailed writeup see our guide
1364  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1365  * to implement supply mechanisms].
1366  *
1367  * The default value of {decimals} is 18. To change this, you should override
1368  * this function so it returns a different value.
1369  *
1370  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1371  * instead returning `false` on failure. This behavior is nonetheless
1372  * conventional and does not conflict with the expectations of ERC20
1373  * applications.
1374  *
1375  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1376  * This allows applications to reconstruct the allowance for all accounts just
1377  * by listening to said events. Other implementations of the EIP may not emit
1378  * these events, as it isn't required by the specification.
1379  *
1380  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1381  * functions have been added to mitigate the well-known issues around setting
1382  * allowances. See {IERC20-approve}.
1383  */
1384 contract ERC20 is Context, IERC20, IERC20Metadata {
1385     mapping(address => uint256) private _balances;
1386 
1387     mapping(address => mapping(address => uint256)) private _allowances;
1388 
1389     uint256 private _totalSupply;
1390 
1391     string private _name;
1392     string private _symbol;
1393 
1394     /**
1395      * @dev Sets the values for {name} and {symbol}.
1396      *
1397      * All two of these values are immutable: they can only be set once during
1398      * construction.
1399      */
1400     constructor(string memory name_, string memory symbol_) {
1401         _name = name_;
1402         _symbol = symbol_;
1403     }
1404 
1405     /**
1406      * @dev Returns the name of the token.
1407      */
1408     function name() public view virtual override returns (string memory) {
1409         return _name;
1410     }
1411 
1412     /**
1413      * @dev Returns the symbol of the token, usually a shorter version of the
1414      * name.
1415      */
1416     function symbol() public view virtual override returns (string memory) {
1417         return _symbol;
1418     }
1419 
1420     /**
1421      * @dev Returns the number of decimals used to get its user representation.
1422      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1423      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1424      *
1425      * Tokens usually opt for a value of 18, imitating the relationship between
1426      * Ether and Wei. This is the default value returned by this function, unless
1427      * it's overridden.
1428      *
1429      * NOTE: This information is only used for _display_ purposes: it in
1430      * no way affects any of the arithmetic of the contract, including
1431      * {IERC20-balanceOf} and {IERC20-transfer}.
1432      */
1433     function decimals() public view virtual override returns (uint8) {
1434         return 18;
1435     }
1436 
1437     /**
1438      * @dev See {IERC20-totalSupply}.
1439      */
1440     function totalSupply() public view virtual override returns (uint256) {
1441         return _totalSupply;
1442     }
1443 
1444     /**
1445      * @dev See {IERC20-balanceOf}.
1446      */
1447     function balanceOf(address account) public view virtual override returns (uint256) {
1448         return _balances[account];
1449     }
1450 
1451     /**
1452      * @dev See {IERC20-transfer}.
1453      *
1454      * Requirements:
1455      *
1456      * - `to` cannot be the zero address.
1457      * - the caller must have a balance of at least `amount`.
1458      */
1459     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1460         address owner = _msgSender();
1461         _transfer(owner, to, amount);
1462         return true;
1463     }
1464 
1465     /**
1466      * @dev See {IERC20-allowance}.
1467      */
1468     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1469         return _allowances[owner][spender];
1470     }
1471 
1472     /**
1473      * @dev See {IERC20-approve}.
1474      *
1475      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1476      * `transferFrom`. This is semantically equivalent to an infinite approval.
1477      *
1478      * Requirements:
1479      *
1480      * - `spender` cannot be the zero address.
1481      */
1482     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1483         address owner = _msgSender();
1484         _approve(owner, spender, amount);
1485         return true;
1486     }
1487 
1488     /**
1489      * @dev See {IERC20-transferFrom}.
1490      *
1491      * Emits an {Approval} event indicating the updated allowance. This is not
1492      * required by the EIP. See the note at the beginning of {ERC20}.
1493      *
1494      * NOTE: Does not update the allowance if the current allowance
1495      * is the maximum `uint256`.
1496      *
1497      * Requirements:
1498      *
1499      * - `from` and `to` cannot be the zero address.
1500      * - `from` must have a balance of at least `amount`.
1501      * - the caller must have allowance for ``from``'s tokens of at least
1502      * `amount`.
1503      */
1504     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
1505         address spender = _msgSender();
1506         _spendAllowance(from, spender, amount);
1507         _transfer(from, to, amount);
1508         return true;
1509     }
1510 
1511     /**
1512      * @dev Atomically increases the allowance granted to `spender` by the caller.
1513      *
1514      * This is an alternative to {approve} that can be used as a mitigation for
1515      * problems described in {IERC20-approve}.
1516      *
1517      * Emits an {Approval} event indicating the updated allowance.
1518      *
1519      * Requirements:
1520      *
1521      * - `spender` cannot be the zero address.
1522      */
1523     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1524         address owner = _msgSender();
1525         _approve(owner, spender, allowance(owner, spender) + addedValue);
1526         return true;
1527     }
1528 
1529     /**
1530      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1531      *
1532      * This is an alternative to {approve} that can be used as a mitigation for
1533      * problems described in {IERC20-approve}.
1534      *
1535      * Emits an {Approval} event indicating the updated allowance.
1536      *
1537      * Requirements:
1538      *
1539      * - `spender` cannot be the zero address.
1540      * - `spender` must have allowance for the caller of at least
1541      * `subtractedValue`.
1542      */
1543     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1544         address owner = _msgSender();
1545         uint256 currentAllowance = allowance(owner, spender);
1546         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1547         unchecked {
1548             _approve(owner, spender, currentAllowance - subtractedValue);
1549         }
1550 
1551         return true;
1552     }
1553 
1554     /**
1555      * @dev Moves `amount` of tokens from `from` to `to`.
1556      *
1557      * This internal function is equivalent to {transfer}, and can be used to
1558      * e.g. implement automatic token fees, slashing mechanisms, etc.
1559      *
1560      * Emits a {Transfer} event.
1561      *
1562      * Requirements:
1563      *
1564      * - `from` cannot be the zero address.
1565      * - `to` cannot be the zero address.
1566      * - `from` must have a balance of at least `amount`.
1567      */
1568     function _transfer(address from, address to, uint256 amount) internal virtual {
1569         require(from != address(0), "ERC20: transfer from the zero address");
1570         require(to != address(0), "ERC20: transfer to the zero address");
1571 
1572         _beforeTokenTransfer(from, to, amount);
1573 
1574         uint256 fromBalance = _balances[from];
1575         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1576         unchecked {
1577             _balances[from] = fromBalance - amount;
1578             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1579             // decrementing then incrementing.
1580             _balances[to] += amount;
1581         }
1582 
1583         emit Transfer(from, to, amount);
1584 
1585         _afterTokenTransfer(from, to, amount);
1586     }
1587 
1588     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1589      * the total supply.
1590      *
1591      * Emits a {Transfer} event with `from` set to the zero address.
1592      *
1593      * Requirements:
1594      *
1595      * - `account` cannot be the zero address.
1596      */
1597     function _mint(address account, uint256 amount) internal virtual {
1598         require(account != address(0), "ERC20: mint to the zero address");
1599 
1600         _beforeTokenTransfer(address(0), account, amount);
1601 
1602         _totalSupply += amount;
1603         unchecked {
1604             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1605             _balances[account] += amount;
1606         }
1607         emit Transfer(address(0), account, amount);
1608 
1609         _afterTokenTransfer(address(0), account, amount);
1610     }
1611 
1612     /**
1613      * @dev Destroys `amount` tokens from `account`, reducing the
1614      * total supply.
1615      *
1616      * Emits a {Transfer} event with `to` set to the zero address.
1617      *
1618      * Requirements:
1619      *
1620      * - `account` cannot be the zero address.
1621      * - `account` must have at least `amount` tokens.
1622      */
1623     function _burn(address account, uint256 amount) internal virtual {
1624         require(account != address(0), "ERC20: burn from the zero address");
1625 
1626         _beforeTokenTransfer(account, address(0), amount);
1627 
1628         uint256 accountBalance = _balances[account];
1629         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1630         unchecked {
1631             _balances[account] = accountBalance - amount;
1632             // Overflow not possible: amount <= accountBalance <= totalSupply.
1633             _totalSupply -= amount;
1634         }
1635 
1636         emit Transfer(account, address(0), amount);
1637 
1638         _afterTokenTransfer(account, address(0), amount);
1639     }
1640 
1641     /**
1642      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1643      *
1644      * This internal function is equivalent to `approve`, and can be used to
1645      * e.g. set automatic allowances for certain subsystems, etc.
1646      *
1647      * Emits an {Approval} event.
1648      *
1649      * Requirements:
1650      *
1651      * - `owner` cannot be the zero address.
1652      * - `spender` cannot be the zero address.
1653      */
1654     function _approve(address owner, address spender, uint256 amount) internal virtual {
1655         require(owner != address(0), "ERC20: approve from the zero address");
1656         require(spender != address(0), "ERC20: approve to the zero address");
1657 
1658         _allowances[owner][spender] = amount;
1659         emit Approval(owner, spender, amount);
1660     }
1661 
1662     /**
1663      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1664      *
1665      * Does not update the allowance amount in case of infinite allowance.
1666      * Revert if not enough allowance is available.
1667      *
1668      * Might emit an {Approval} event.
1669      */
1670     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
1671         uint256 currentAllowance = allowance(owner, spender);
1672         if (currentAllowance != type(uint256).max) {
1673             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1674             unchecked {
1675                 _approve(owner, spender, currentAllowance - amount);
1676             }
1677         }
1678     }
1679 
1680     /**
1681      * @dev Hook that is called before any transfer of tokens. This includes
1682      * minting and burning.
1683      *
1684      * Calling conditions:
1685      *
1686      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1687      * will be transferred to `to`.
1688      * - when `from` is zero, `amount` tokens will be minted for `to`.
1689      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1690      * - `from` and `to` are never both zero.
1691      *
1692      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1693      */
1694     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1695 
1696     /**
1697      * @dev Hook that is called after any transfer of tokens. This includes
1698      * minting and burning.
1699      *
1700      * Calling conditions:
1701      *
1702      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1703      * has been transferred to `to`.
1704      * - when `from` is zero, `amount` tokens have been minted for `to`.
1705      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1706      * - `from` and `to` are never both zero.
1707      *
1708      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1709      */
1710     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
1711 }
1712 
1713 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1714 
1715 
1716 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/ERC721.sol)
1717 
1718 pragma solidity ^0.8.0;
1719 
1720 
1721 
1722 
1723 
1724 
1725 
1726 
1727 /**
1728  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1729  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1730  * {ERC721Enumerable}.
1731  */
1732 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1733     using Address for address;
1734     using Strings for uint256;
1735 
1736     // Token name
1737     string private _name;
1738 
1739     // Token symbol
1740     string private _symbol;
1741 
1742     // Mapping from token ID to owner address
1743     mapping(uint256 => address) private _owners;
1744 
1745     // Mapping owner address to token count
1746     mapping(address => uint256) private _balances;
1747 
1748     // Mapping from token ID to approved address
1749     mapping(uint256 => address) private _tokenApprovals;
1750 
1751     // Mapping from owner to operator approvals
1752     mapping(address => mapping(address => bool)) private _operatorApprovals;
1753 
1754     /**
1755      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1756      */
1757     constructor(string memory name_, string memory symbol_) {
1758         _name = name_;
1759         _symbol = symbol_;
1760     }
1761 
1762     /**
1763      * @dev See {IERC165-supportsInterface}.
1764      */
1765     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1766         return
1767             interfaceId == type(IERC721).interfaceId ||
1768             interfaceId == type(IERC721Metadata).interfaceId ||
1769             super.supportsInterface(interfaceId);
1770     }
1771 
1772     /**
1773      * @dev See {IERC721-balanceOf}.
1774      */
1775     function balanceOf(address owner) public view virtual override returns (uint256) {
1776         require(owner != address(0), "ERC721: address zero is not a valid owner");
1777         return _balances[owner];
1778     }
1779 
1780     /**
1781      * @dev See {IERC721-ownerOf}.
1782      */
1783     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1784         address owner = _ownerOf(tokenId);
1785         require(owner != address(0), "ERC721: invalid token ID");
1786         return owner;
1787     }
1788 
1789     /**
1790      * @dev See {IERC721Metadata-name}.
1791      */
1792     function name() public view virtual override returns (string memory) {
1793         return _name;
1794     }
1795 
1796     /**
1797      * @dev See {IERC721Metadata-symbol}.
1798      */
1799     function symbol() public view virtual override returns (string memory) {
1800         return _symbol;
1801     }
1802 
1803     /**
1804      * @dev See {IERC721Metadata-tokenURI}.
1805      */
1806     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1807         _requireMinted(tokenId);
1808 
1809         string memory baseURI = _baseURI();
1810         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1811     }
1812 
1813     /**
1814      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1815      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1816      * by default, can be overridden in child contracts.
1817      */
1818     function _baseURI() internal view virtual returns (string memory) {
1819         return "";
1820     }
1821 
1822     /**
1823      * @dev See {IERC721-approve}.
1824      */
1825     function approve(address to, uint256 tokenId) public virtual override {
1826         address owner = ERC721.ownerOf(tokenId);
1827         require(to != owner, "ERC721: approval to current owner");
1828 
1829         require(
1830             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1831             "ERC721: approve caller is not token owner or approved for all"
1832         );
1833 
1834         _approve(to, tokenId);
1835     }
1836 
1837     /**
1838      * @dev See {IERC721-getApproved}.
1839      */
1840     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1841         _requireMinted(tokenId);
1842 
1843         return _tokenApprovals[tokenId];
1844     }
1845 
1846     /**
1847      * @dev See {IERC721-setApprovalForAll}.
1848      */
1849     function setApprovalForAll(address operator, bool approved) public virtual override {
1850         _setApprovalForAll(_msgSender(), operator, approved);
1851     }
1852 
1853     /**
1854      * @dev See {IERC721-isApprovedForAll}.
1855      */
1856     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1857         return _operatorApprovals[owner][operator];
1858     }
1859 
1860     /**
1861      * @dev See {IERC721-transferFrom}.
1862      */
1863     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1864         //solhint-disable-next-line max-line-length
1865         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1866 
1867         _transfer(from, to, tokenId);
1868     }
1869 
1870     /**
1871      * @dev See {IERC721-safeTransferFrom}.
1872      */
1873     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1874         safeTransferFrom(from, to, tokenId, "");
1875     }
1876 
1877     /**
1878      * @dev See {IERC721-safeTransferFrom}.
1879      */
1880     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1881         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1882         _safeTransfer(from, to, tokenId, data);
1883     }
1884 
1885     /**
1886      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1887      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1888      *
1889      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1890      *
1891      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1892      * implement alternative mechanisms to perform token transfer, such as signature-based.
1893      *
1894      * Requirements:
1895      *
1896      * - `from` cannot be the zero address.
1897      * - `to` cannot be the zero address.
1898      * - `tokenId` token must exist and be owned by `from`.
1899      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1900      *
1901      * Emits a {Transfer} event.
1902      */
1903     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1904         _transfer(from, to, tokenId);
1905         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1906     }
1907 
1908     /**
1909      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1910      */
1911     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1912         return _owners[tokenId];
1913     }
1914 
1915     /**
1916      * @dev Returns whether `tokenId` exists.
1917      *
1918      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1919      *
1920      * Tokens start existing when they are minted (`_mint`),
1921      * and stop existing when they are burned (`_burn`).
1922      */
1923     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1924         return _ownerOf(tokenId) != address(0);
1925     }
1926 
1927     /**
1928      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1929      *
1930      * Requirements:
1931      *
1932      * - `tokenId` must exist.
1933      */
1934     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1935         address owner = ERC721.ownerOf(tokenId);
1936         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1937     }
1938 
1939     /**
1940      * @dev Safely mints `tokenId` and transfers it to `to`.
1941      *
1942      * Requirements:
1943      *
1944      * - `tokenId` must not exist.
1945      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1946      *
1947      * Emits a {Transfer} event.
1948      */
1949     function _safeMint(address to, uint256 tokenId) internal virtual {
1950         _safeMint(to, tokenId, "");
1951     }
1952 
1953     /**
1954      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1955      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1956      */
1957     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1958         _mint(to, tokenId);
1959         require(
1960             _checkOnERC721Received(address(0), to, tokenId, data),
1961             "ERC721: transfer to non ERC721Receiver implementer"
1962         );
1963     }
1964 
1965     /**
1966      * @dev Mints `tokenId` and transfers it to `to`.
1967      *
1968      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1969      *
1970      * Requirements:
1971      *
1972      * - `tokenId` must not exist.
1973      * - `to` cannot be the zero address.
1974      *
1975      * Emits a {Transfer} event.
1976      */
1977     function _mint(address to, uint256 tokenId) internal virtual {
1978         require(to != address(0), "ERC721: mint to the zero address");
1979         require(!_exists(tokenId), "ERC721: token already minted");
1980 
1981         _beforeTokenTransfer(address(0), to, tokenId, 1);
1982 
1983         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1984         require(!_exists(tokenId), "ERC721: token already minted");
1985 
1986         unchecked {
1987             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1988             // Given that tokens are minted one by one, it is impossible in practice that
1989             // this ever happens. Might change if we allow batch minting.
1990             // The ERC fails to describe this case.
1991             _balances[to] += 1;
1992         }
1993 
1994         _owners[tokenId] = to;
1995 
1996         emit Transfer(address(0), to, tokenId);
1997 
1998         _afterTokenTransfer(address(0), to, tokenId, 1);
1999     }
2000 
2001     /**
2002      * @dev Destroys `tokenId`.
2003      * The approval is cleared when the token is burned.
2004      * This is an internal function that does not check if the sender is authorized to operate on the token.
2005      *
2006      * Requirements:
2007      *
2008      * - `tokenId` must exist.
2009      *
2010      * Emits a {Transfer} event.
2011      */
2012     function _burn(uint256 tokenId) internal virtual {
2013         address owner = ERC721.ownerOf(tokenId);
2014 
2015         _beforeTokenTransfer(owner, address(0), tokenId, 1);
2016 
2017         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
2018         owner = ERC721.ownerOf(tokenId);
2019 
2020         // Clear approvals
2021         delete _tokenApprovals[tokenId];
2022 
2023         unchecked {
2024             // Cannot overflow, as that would require more tokens to be burned/transferred
2025             // out than the owner initially received through minting and transferring in.
2026             _balances[owner] -= 1;
2027         }
2028         delete _owners[tokenId];
2029 
2030         emit Transfer(owner, address(0), tokenId);
2031 
2032         _afterTokenTransfer(owner, address(0), tokenId, 1);
2033     }
2034 
2035     /**
2036      * @dev Transfers `tokenId` from `from` to `to`.
2037      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2038      *
2039      * Requirements:
2040      *
2041      * - `to` cannot be the zero address.
2042      * - `tokenId` token must be owned by `from`.
2043      *
2044      * Emits a {Transfer} event.
2045      */
2046     function _transfer(address from, address to, uint256 tokenId) internal virtual {
2047         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2048         require(to != address(0), "ERC721: transfer to the zero address");
2049 
2050         _beforeTokenTransfer(from, to, tokenId, 1);
2051 
2052         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
2053         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
2054 
2055         // Clear approvals from the previous owner
2056         delete _tokenApprovals[tokenId];
2057 
2058         unchecked {
2059             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
2060             // `from`'s balance is the number of token held, which is at least one before the current
2061             // transfer.
2062             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
2063             // all 2**256 token ids to be minted, which in practice is impossible.
2064             _balances[from] -= 1;
2065             _balances[to] += 1;
2066         }
2067         _owners[tokenId] = to;
2068 
2069         emit Transfer(from, to, tokenId);
2070 
2071         _afterTokenTransfer(from, to, tokenId, 1);
2072     }
2073 
2074     /**
2075      * @dev Approve `to` to operate on `tokenId`
2076      *
2077      * Emits an {Approval} event.
2078      */
2079     function _approve(address to, uint256 tokenId) internal virtual {
2080         _tokenApprovals[tokenId] = to;
2081         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
2082     }
2083 
2084     /**
2085      * @dev Approve `operator` to operate on all of `owner` tokens
2086      *
2087      * Emits an {ApprovalForAll} event.
2088      */
2089     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
2090         require(owner != operator, "ERC721: approve to caller");
2091         _operatorApprovals[owner][operator] = approved;
2092         emit ApprovalForAll(owner, operator, approved);
2093     }
2094 
2095     /**
2096      * @dev Reverts if the `tokenId` has not been minted yet.
2097      */
2098     function _requireMinted(uint256 tokenId) internal view virtual {
2099         require(_exists(tokenId), "ERC721: invalid token ID");
2100     }
2101 
2102     /**
2103      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2104      * The call is not executed if the target address is not a contract.
2105      *
2106      * @param from address representing the previous owner of the given token ID
2107      * @param to target address that will receive the tokens
2108      * @param tokenId uint256 ID of the token to be transferred
2109      * @param data bytes optional data to send along with the call
2110      * @return bool whether the call correctly returned the expected magic value
2111      */
2112     function _checkOnERC721Received(
2113         address from,
2114         address to,
2115         uint256 tokenId,
2116         bytes memory data
2117     ) private returns (bool) {
2118         if (to.isContract()) {
2119             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2120                 return retval == IERC721Receiver.onERC721Received.selector;
2121             } catch (bytes memory reason) {
2122                 if (reason.length == 0) {
2123                     revert("ERC721: transfer to non ERC721Receiver implementer");
2124                 } else {
2125                     /// @solidity memory-safe-assembly
2126                     assembly {
2127                         revert(add(32, reason), mload(reason))
2128                     }
2129                 }
2130             }
2131         } else {
2132             return true;
2133         }
2134     }
2135 
2136     /**
2137      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2138      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2139      *
2140      * Calling conditions:
2141      *
2142      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2143      * - When `from` is zero, the tokens will be minted for `to`.
2144      * - When `to` is zero, ``from``'s tokens will be burned.
2145      * - `from` and `to` are never both zero.
2146      * - `batchSize` is non-zero.
2147      *
2148      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2149      */
2150     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2151 
2152     /**
2153      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2154      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2155      *
2156      * Calling conditions:
2157      *
2158      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2159      * - When `from` is zero, the tokens were minted for `to`.
2160      * - When `to` is zero, ``from``'s tokens were burned.
2161      * - `from` and `to` are never both zero.
2162      * - `batchSize` is non-zero.
2163      *
2164      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2165      */
2166     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2167 
2168     /**
2169      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
2170      *
2171      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
2172      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
2173      * that `ownerOf(tokenId)` is `a`.
2174      */
2175     // solhint-disable-next-line func-name-mixedcase
2176     function __unsafe_increaseBalance(address account, uint256 amount) internal {
2177         _balances[account] += amount;
2178     }
2179 }
2180 
2181 // File: @openzeppelin/contracts/access/Ownable.sol
2182 
2183 
2184 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
2185 
2186 pragma solidity ^0.8.0;
2187 
2188 
2189 /**
2190  * @dev Contract module which provides a basic access control mechanism, where
2191  * there is an account (an owner) that can be granted exclusive access to
2192  * specific functions.
2193  *
2194  * By default, the owner account will be the one that deploys the contract. This
2195  * can later be changed with {transferOwnership}.
2196  *
2197  * This module is used through inheritance. It will make available the modifier
2198  * `onlyOwner`, which can be applied to your functions to restrict their use to
2199  * the owner.
2200  */
2201 abstract contract Ownable is Context {
2202     address private _owner;
2203 
2204     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2205 
2206     /**
2207      * @dev Initializes the contract setting the deployer as the initial owner.
2208      */
2209     constructor() {
2210         _transferOwnership(_msgSender());
2211     }
2212 
2213     /**
2214      * @dev Throws if called by any account other than the owner.
2215      */
2216     modifier onlyOwner() {
2217         _checkOwner();
2218         _;
2219     }
2220 
2221     /**
2222      * @dev Returns the address of the current owner.
2223      */
2224     function owner() public view virtual returns (address) {
2225         return _owner;
2226     }
2227 
2228     /**
2229      * @dev Throws if the sender is not the owner.
2230      */
2231     function _checkOwner() internal view virtual {
2232         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2233     }
2234 
2235     /**
2236      * @dev Leaves the contract without owner. It will not be possible to call
2237      * `onlyOwner` functions. Can only be called by the current owner.
2238      *
2239      * NOTE: Renouncing ownership will leave the contract without an owner,
2240      * thereby disabling any functionality that is only available to the owner.
2241      */
2242     function renounceOwnership() public virtual onlyOwner {
2243         _transferOwnership(address(0));
2244     }
2245 
2246     /**
2247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2248      * Can only be called by the current owner.
2249      */
2250     function transferOwnership(address newOwner) public virtual onlyOwner {
2251         require(newOwner != address(0), "Ownable: new owner is the zero address");
2252         _transferOwnership(newOwner);
2253     }
2254 
2255     /**
2256      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2257      * Internal function without access restriction.
2258      */
2259     function _transferOwnership(address newOwner) internal virtual {
2260         address oldOwner = _owner;
2261         _owner = newOwner;
2262         emit OwnershipTransferred(oldOwner, newOwner);
2263     }
2264 }
2265 
2266 // File: contracts/elmofos_stake.sol
2267 
2268 
2269 
2270 pragma solidity ^0.8.0;
2271 
2272 
2273 
2274 
2275 
2276 
2277 
2278 contract NFTStaking is Ownable, ReentrancyGuard, Pausable {
2279     using Counters for Counters.Counter;
2280 
2281     ERC721 public nft;
2282     ERC20 public rewardToken;
2283 
2284     struct StakeInfo {
2285         uint256 startTime;
2286         uint256 reward;
2287         uint256 toBurn;
2288     }
2289 
2290     // user => NFT => stake info
2291     mapping(address => mapping(uint256 => StakeInfo)) public stakes;
2292 
2293     // user => staked NFT count
2294     mapping(address => Counters.Counter) private stakedNFTCount;
2295 
2296     // NFT => staked or not
2297     mapping(uint256 => bool) public stakedStatus;
2298 
2299     // NFT => excluded or not
2300     mapping(uint256 => bool) public isExcludedFromStaking;
2301 
2302     // user => total rewards and total burned
2303     mapping(address => uint256) public totalRewards;
2304     mapping(address => uint256) public totalBurned;
2305 
2306     // total staked NFT count
2307     Counters.Counter private totalStakedNFTCount;
2308 
2309     // User address to staked token IDs
2310     mapping(address => uint256[]) public _stakedTokensByUser;
2311 
2312     uint256 public constant STAKE_PERIOD = 30 days;
2313 
2314     uint256 public _rewardAmount = 20000 * 10**18; //20,000 ELMO
2315 
2316     uint256 public stakingPool;
2317     uint256 public totalBurnedByAll;
2318 
2319     event NFTStaked(address indexed user, uint256 indexed tokenId);
2320     event NFTUnstaked(address indexed user, uint256 indexed tokenId);
2321 
2322     constructor(address _nft, address _rewardToken) {
2323         nft = ERC721(_nft);
2324         rewardToken = ERC20(_rewardToken);
2325     }
2326 
2327     function stakeNFT(uint256 _tokenId, uint256 _burnPercent) external nonReentrant whenNotPaused {
2328         require(nft.ownerOf(_tokenId) == msg.sender, "Not the owner");
2329         require(!stakedStatus[_tokenId], "NFT already staked");  // Check if the NFT has been staked before
2330         require(!isExcludedFromStaking[_tokenId], "You can't stake this NFT!");
2331 
2332         require(stakingPool >= _rewardAmount, "Staking pool doesn't have sufficient funds");
2333 
2334         require(_burnPercent == 40 || _burnPercent == 60 || _burnPercent == 80, "The burn percent doesn't match");
2335 
2336         uint256 toBurn = (_rewardAmount * _burnPercent) / 100;
2337         uint256 reward = _rewardAmount - toBurn;
2338 
2339         stakingPool -= _rewardAmount;
2340 
2341         burn(toBurn);
2342         totalBurned[msg.sender] += toBurn;
2343         totalRewards[msg.sender] += reward;
2344 
2345         stakes[msg.sender][_tokenId] = StakeInfo(block.timestamp, reward, toBurn);
2346         stakedStatus[_tokenId] = true;  // Mark the NFT as staked
2347         stakedNFTCount[msg.sender].increment();
2348         totalStakedNFTCount.increment();
2349 
2350         _stakedTokensByUser[msg.sender].push(_tokenId); // Record the staked token
2351 
2352         emit NFTStaked(msg.sender, _tokenId);
2353     }
2354 
2355     function unstakeNFT(uint256 _tokenId) external nonReentrant {
2356         require(stakes[msg.sender][_tokenId].startTime > 0, "Not the staker");
2357         require(stakes[msg.sender][_tokenId].startTime + STAKE_PERIOD <= block.timestamp, "Staking period not ended");
2358         require(stakedStatus[_tokenId] == true, "NFT was never staked");
2359 
2360         uint256 reward = stakes[msg.sender][_tokenId].reward;
2361 
2362         require(rewardToken.balanceOf(address(this)) >= reward, "Contract has insufficient reward tokens");
2363 
2364         rewardToken.transfer(msg.sender, reward);
2365         totalRewards[msg.sender] -= reward;
2366 
2367         delete stakes[msg.sender][_tokenId];
2368         stakedNFTCount[msg.sender].decrement();
2369         totalStakedNFTCount.decrement();
2370 
2371         uint256[] storage userStakedTokens = _stakedTokensByUser[msg.sender];
2372         for (uint256 i = 0; i < userStakedTokens.length; i++) {
2373             if (userStakedTokens[i] == _tokenId) {
2374                 userStakedTokens[i] = userStakedTokens[userStakedTokens.length - 1];
2375                 userStakedTokens.pop();
2376                 break;
2377             }
2378         }
2379 
2380         emit NFTUnstaked(msg.sender, _tokenId);
2381     }
2382 
2383     function getStakedNFTCount(address _user) external view returns (uint256) {
2384         return stakedNFTCount[_user].current();
2385     }
2386 
2387     function getTotalStakedNFTCount() external view returns (uint256) {
2388         return totalStakedNFTCount.current();
2389     }
2390 
2391     function pauseStaking() external onlyOwner {
2392         _pause();
2393     }
2394 
2395     function unpauseStaking() external onlyOwner {
2396         _unpause();
2397     }
2398 
2399     function addRewards(uint256 _amount) external onlyOwner {
2400         uint256 balance = rewardToken.balanceOf(msg.sender);
2401         require(_amount <= balance, "Insufficient balance");
2402 
2403         uint256 balanceBefore = rewardToken.balanceOf(address(this));
2404         rewardToken.transferFrom(msg.sender, address(this), _amount);
2405         uint256 received = rewardToken.balanceOf(address(this)) - balanceBefore;
2406         assert(received == _amount);
2407         stakingPool += _amount;
2408     }
2409 
2410     function setExcludeFromStake(uint256 _tokenId, bool excluded) external onlyOwner {
2411         isExcludedFromStaking[_tokenId] = excluded;
2412     }
2413 
2414     function setRewardAmount(uint256 amount) external onlyOwner {
2415         require(amount > 0, "The amount should be more than 0");
2416         _rewardAmount = amount;
2417     }
2418 
2419     function burn(uint256 amount) private {
2420         (bool success, ) = address(rewardToken).call(abi.encodeWithSignature("publicBurn(uint256)", amount));
2421         require(success, "Burn failed");
2422         totalBurnedByAll += amount;
2423     }
2424 }