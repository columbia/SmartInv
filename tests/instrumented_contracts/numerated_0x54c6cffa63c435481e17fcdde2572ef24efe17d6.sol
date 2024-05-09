1 // SPDX-License-Identifier: MIT
2 
3 //           JJJJJJJJJJJ          AAA                  CCCCCCCCCCCCCKKKKKKKKK    KKKKKKKEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDD        
4 //           J:::::::::J         A:::A              CCC::::::::::::CK:::::::K    K:::::KE::::::::::::::::::::ED::::::::::::DDD     
5 //           J::::J::::J        A:::::A           CC:::::::::::::::CK:::::::K    K:::::KE::::::::::::::::::::ED:::::::::::::::DD   
6 //           JJ:::A:::JJ       A:::::::A         C:::::CCCCCCCC::::CK:::::::K   K::::::KEE::::::EEEEEEEEE::::EDDD:::::DDDDD:::::D  
7 //             J::C::J        A:::::::::A       C:::::C       CCCCCCKK::::::K  K:::::KKK  E:::::E       EEEEEE  D:::::D    D:::::D 
8 //             J::K::J       A:::::A:::::A     C:::::C                K:::::K K:::::K     E:::::E               D:::::D     D:::::D
9 //             J::E::J      A:::::A A:::::A    C:::::C                K::::::K:::::K      E::::::EEEEEEEEEE     D:::::D     D:::::D
10 //             J::D::J     A:::::A   A:::::A   C:::::C                K:::::::::::K       E:::::::::::::::E     D:::::D     D:::::D
11 //             J:::::J    A:::::A     A:::::A  C:::::C                K:::::::::::K       E:::::::::::::::E     D:::::D     D:::::D
12 // JJJJJJJ     J:::::J   A:::::AAAAAAAAA:::::A C:::::C                K::::::K:::::K      E::::::EEEEEEEEEE     D:::::D     D:::::D
13 // J:::::J     J:::::J  A:::::::::::::::::::::AC:::::C                K:::::K K:::::K     E:::::E               D:::::D     D:::::D
14 // J::::::J   J::::::J A:::::AAAAAAAAAAAAA:::::AC:::::C       CCCCCCKK::::::K  K:::::KKK  E:::::E       EEEEEE  D:::::D    D:::::D 
15 // J:::::::JJJ:::::::JA:::::A  _________  A:::::AC:::::CCCCCCCC::::CK:::::::K   K::::::KEE::::::EEEEEEEE:::::EDDD:::::DDDDD:::::D  
16 //  JJ:::::::::::::JJA:::::A    _______    A:::::ACC:::::::::::::::CK:::::::K    K:::::KE::::::::::::::::::::ED:::::::::::::::DD   
17 //    JJ:::::::::JJ A:::::A       ___       A:::::A CCC::::::::::::CK:::::::K    K:::::KE::::::::::::::::::::ED::::::::::::DDD     
18 //      JJJJJJJJJ  AAAAAAA         _         AAAAAAA   CCCCCCCCCCCCCKKKKKKKKK    KKKKKKKEEEEEEEEEEEEEEEEEEEEEEDDDDDDDDDDDDD        
19                                           
20 // DDDDDDDDDDDDD      EEEEEEEEEEEEEEEEEEEEEE       GGGGGGGGGGGGGEEEEEEEEEEEEEEEEEEEEEENNNNNNNN        NNNNNNNN    SSSSSSSSSSSSSSS 
21 // D::::::::::::DDD   E::::::::::::::::::::E    GGG::::::::::::GE::::::::::::::::::::EN:::::::N       N::::::N  SS:::::::::::::::S
22 // D::::D::::::::::DD E::::::::::::::::::::E  GG:::::::::::::::GE::::::::::::::::::::EN::::::::N      N::::::N S:::::SSSSSS::::::S
23 // DDD::E::DDDDD:::::DEE::::::EEEEEEEEE::::E G:::::GGGGGGGG::::GEE::::::EEEEEEEEE::::EN:::::::::N     N::::::N S:::::S     SSSSSSS
24 //   D::G::D    D:::::D E:::::E       EEEEEEG:::::G       GGGGGG  E:::::E       EEEEEEN::::::::::N    N::::::N S:::::S            
25 //   D::E::D     D:::::DE:::::E            G:::::G                E:::::E             N:::::::::::N   N::::::N S:::::S            
26 //   D::N::D     D:::::DE::::::EEEEEEEEEE  G:::::G                E::::::EEEEEEEEEE   N:::::::N::::N  N::::::N  S::::SSSS         
27 //   D::E::D     D:::::DE:::::::::::::::E  G:::::G    GGGGGGGGGG  E:::::::::::::::E   N::::::N N::::N N::::::N   SS::::::SSSSS    
28 //   D::R::D     D:::::DE:::::::::::::::E  G:::::G    G::::::::G  E:::::::::::::::E   N::::::N  N::::N:::::::N     SSS::::::::SS  
29 //   D::A::D     D:::::DE::::::EEEEEEEEEE  G:::::G    GGGGG::::G  E::::::EEEEEEEEEE   N::::::N   N:::::::::::N        SSSSSS::::S 
30 //   D::T::D     D:::::DE:::::E            G:::::G        G::::G  E:::::E             N::::::N    N::::::::::N             S:::::S
31 //   D::E::D    D:::::D E:::::E       EEEEEEG:::::G       G::::G  E:::::E       EEEEEEN::::::N     N:::::::::N             S:::::S
32 // DDD::S::DDDDD:::::DEE::::::EEEEEEEE:::::E G:::::GGGGGGGG::::GEE::::::EEEEEEEE:::::EN::::::N      N::::::::N SSSSSSS     S:::::S
33 // D:::::::::::::::DD E::::::::::::::::::::E  GG:::::::::::::::GE::::::::::::::::::::EN::::::N       N:::::::N S::::::SSSSSS:::::S
34 // D::::::::::::DDD   E::::::::::::::::::::E    GGG::::::GGG:::GE::::::::::::::::::::EN::::::N        N::::::N S:::::::::::::::SS 
35 // DDDDDDDDDDDDD      EEEEEEEEEEEEEEEEEEEEEE       GGGGGG   GGGGEEEEEEEEEEEEEEEEEEEEEENNNNNNNN         NNNNNNN  SSSSSSSSSSSSSSS
36 
37 
38 // File: @openzeppelin/contracts-upgradeable/utils/math/MathUpgradeable.sol
39 
40 
41 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
42 
43 pragma solidity ^0.8.0;
44 
45 /**
46  * @dev Standard math utilities missing in the Solidity language.
47  */
48 library MathUpgradeable {
49     enum Rounding {
50         Down, // Toward negative infinity
51         Up, // Toward infinity
52         Zero // Toward zero
53     }
54 
55     /**
56      * @dev Returns the largest of two numbers.
57      */
58     function max(uint256 a, uint256 b) internal pure returns (uint256) {
59         return a > b ? a : b;
60     }
61 
62     /**
63      * @dev Returns the smallest of two numbers.
64      */
65     function min(uint256 a, uint256 b) internal pure returns (uint256) {
66         return a < b ? a : b;
67     }
68 
69     /**
70      * @dev Returns the average of two numbers. The result is rounded towards
71      * zero.
72      */
73     function average(uint256 a, uint256 b) internal pure returns (uint256) {
74         // (a + b) / 2 can overflow.
75         return (a & b) + (a ^ b) / 2;
76     }
77 
78     /**
79      * @dev Returns the ceiling of the division of two numbers.
80      *
81      * This differs from standard division with `/` in that it rounds up instead
82      * of rounding down.
83      */
84     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
85         // (a + b - 1) / b can overflow on addition, so we distribute.
86         return a == 0 ? 0 : (a - 1) / b + 1;
87     }
88 
89     /**
90      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
91      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
92      * with further edits by Uniswap Labs also under MIT license.
93      */
94     function mulDiv(
95         uint256 x,
96         uint256 y,
97         uint256 denominator
98     ) internal pure returns (uint256 result) {
99         unchecked {
100             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
101             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
102             // variables such that product = prod1 * 2^256 + prod0.
103             uint256 prod0; // Least significant 256 bits of the product
104             uint256 prod1; // Most significant 256 bits of the product
105             assembly {
106                 let mm := mulmod(x, y, not(0))
107                 prod0 := mul(x, y)
108                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
109             }
110 
111             // Handle non-overflow cases, 256 by 256 division.
112             if (prod1 == 0) {
113                 return prod0 / denominator;
114             }
115 
116             // Make sure the result is less than 2^256. Also prevents denominator == 0.
117             require(denominator > prod1);
118 
119             ///////////////////////////////////////////////
120             // 512 by 256 division.
121             ///////////////////////////////////////////////
122 
123             // Make division exact by subtracting the remainder from [prod1 prod0].
124             uint256 remainder;
125             assembly {
126                 // Compute remainder using mulmod.
127                 remainder := mulmod(x, y, denominator)
128 
129                 // Subtract 256 bit number from 512 bit number.
130                 prod1 := sub(prod1, gt(remainder, prod0))
131                 prod0 := sub(prod0, remainder)
132             }
133 
134             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
135             // See https://cs.stackexchange.com/q/138556/92363.
136 
137             // Does not overflow because the denominator cannot be zero at this stage in the function.
138             uint256 twos = denominator & (~denominator + 1);
139             assembly {
140                 // Divide denominator by twos.
141                 denominator := div(denominator, twos)
142 
143                 // Divide [prod1 prod0] by twos.
144                 prod0 := div(prod0, twos)
145 
146                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
147                 twos := add(div(sub(0, twos), twos), 1)
148             }
149 
150             // Shift in bits from prod1 into prod0.
151             prod0 |= prod1 * twos;
152 
153             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
154             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
155             // four bits. That is, denominator * inv = 1 mod 2^4.
156             uint256 inverse = (3 * denominator) ^ 2;
157 
158             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
159             // in modular arithmetic, doubling the correct bits in each step.
160             inverse *= 2 - denominator * inverse; // inverse mod 2^8
161             inverse *= 2 - denominator * inverse; // inverse mod 2^16
162             inverse *= 2 - denominator * inverse; // inverse mod 2^32
163             inverse *= 2 - denominator * inverse; // inverse mod 2^64
164             inverse *= 2 - denominator * inverse; // inverse mod 2^128
165             inverse *= 2 - denominator * inverse; // inverse mod 2^256
166 
167             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
168             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
169             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
170             // is no longer required.
171             result = prod0 * inverse;
172             return result;
173         }
174     }
175 
176     /**
177      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
178      */
179     function mulDiv(
180         uint256 x,
181         uint256 y,
182         uint256 denominator,
183         Rounding rounding
184     ) internal pure returns (uint256) {
185         uint256 result = mulDiv(x, y, denominator);
186         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
187             result += 1;
188         }
189         return result;
190     }
191 
192     /**
193      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
194      *
195      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
196      */
197     function sqrt(uint256 a) internal pure returns (uint256) {
198         if (a == 0) {
199             return 0;
200         }
201 
202         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
203         //
204         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
205         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
206         //
207         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
208         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
209         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
210         //
211         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
212         uint256 result = 1 << (log2(a) >> 1);
213 
214         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
215         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
216         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
217         // into the expected uint128 result.
218         unchecked {
219             result = (result + a / result) >> 1;
220             result = (result + a / result) >> 1;
221             result = (result + a / result) >> 1;
222             result = (result + a / result) >> 1;
223             result = (result + a / result) >> 1;
224             result = (result + a / result) >> 1;
225             result = (result + a / result) >> 1;
226             return min(result, a / result);
227         }
228     }
229 
230     /**
231      * @notice Calculates sqrt(a), following the selected rounding direction.
232      */
233     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
234         unchecked {
235             uint256 result = sqrt(a);
236             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
237         }
238     }
239 
240     /**
241      * @dev Return the log in base 2, rounded down, of a positive value.
242      * Returns 0 if given 0.
243      */
244     function log2(uint256 value) internal pure returns (uint256) {
245         uint256 result = 0;
246         unchecked {
247             if (value >> 128 > 0) {
248                 value >>= 128;
249                 result += 128;
250             }
251             if (value >> 64 > 0) {
252                 value >>= 64;
253                 result += 64;
254             }
255             if (value >> 32 > 0) {
256                 value >>= 32;
257                 result += 32;
258             }
259             if (value >> 16 > 0) {
260                 value >>= 16;
261                 result += 16;
262             }
263             if (value >> 8 > 0) {
264                 value >>= 8;
265                 result += 8;
266             }
267             if (value >> 4 > 0) {
268                 value >>= 4;
269                 result += 4;
270             }
271             if (value >> 2 > 0) {
272                 value >>= 2;
273                 result += 2;
274             }
275             if (value >> 1 > 0) {
276                 result += 1;
277             }
278         }
279         return result;
280     }
281 
282     /**
283      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
284      * Returns 0 if given 0.
285      */
286     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
287         unchecked {
288             uint256 result = log2(value);
289             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
290         }
291     }
292 
293     /**
294      * @dev Return the log in base 10, rounded down, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log10(uint256 value) internal pure returns (uint256) {
298         uint256 result = 0;
299         unchecked {
300             if (value >= 10**64) {
301                 value /= 10**64;
302                 result += 64;
303             }
304             if (value >= 10**32) {
305                 value /= 10**32;
306                 result += 32;
307             }
308             if (value >= 10**16) {
309                 value /= 10**16;
310                 result += 16;
311             }
312             if (value >= 10**8) {
313                 value /= 10**8;
314                 result += 8;
315             }
316             if (value >= 10**4) {
317                 value /= 10**4;
318                 result += 4;
319             }
320             if (value >= 10**2) {
321                 value /= 10**2;
322                 result += 2;
323             }
324             if (value >= 10**1) {
325                 result += 1;
326             }
327         }
328         return result;
329     }
330 
331     /**
332      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
333      * Returns 0 if given 0.
334      */
335     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
336         unchecked {
337             uint256 result = log10(value);
338             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
339         }
340     }
341 
342     /**
343      * @dev Return the log in base 256, rounded down, of a positive value.
344      * Returns 0 if given 0.
345      *
346      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
347      */
348     function log256(uint256 value) internal pure returns (uint256) {
349         uint256 result = 0;
350         unchecked {
351             if (value >> 128 > 0) {
352                 value >>= 128;
353                 result += 16;
354             }
355             if (value >> 64 > 0) {
356                 value >>= 64;
357                 result += 8;
358             }
359             if (value >> 32 > 0) {
360                 value >>= 32;
361                 result += 4;
362             }
363             if (value >> 16 > 0) {
364                 value >>= 16;
365                 result += 2;
366             }
367             if (value >> 8 > 0) {
368                 result += 1;
369             }
370         }
371         return result;
372     }
373 
374     /**
375      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
376      * Returns 0 if given 0.
377      */
378     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
379         unchecked {
380             uint256 result = log256(value);
381             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
382         }
383     }
384 }
385 
386 // File: @openzeppelin/contracts-upgradeable/utils/StringsUpgradeable.sol
387 
388 
389 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
390 
391 pragma solidity ^0.8.0;
392 
393 
394 /**
395  * @dev String operations.
396  */
397 library StringsUpgradeable {
398     bytes16 private constant _SYMBOLS = "0123456789abcdef";
399     uint8 private constant _ADDRESS_LENGTH = 20;
400 
401     /**
402      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
403      */
404     function toString(uint256 value) internal pure returns (string memory) {
405         unchecked {
406             uint256 length = MathUpgradeable.log10(value) + 1;
407             string memory buffer = new string(length);
408             uint256 ptr;
409             /// @solidity memory-safe-assembly
410             assembly {
411                 ptr := add(buffer, add(32, length))
412             }
413             while (true) {
414                 ptr--;
415                 /// @solidity memory-safe-assembly
416                 assembly {
417                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
418                 }
419                 value /= 10;
420                 if (value == 0) break;
421             }
422             return buffer;
423         }
424     }
425 
426     /**
427      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
428      */
429     function toHexString(uint256 value) internal pure returns (string memory) {
430         unchecked {
431             return toHexString(value, MathUpgradeable.log256(value) + 1);
432         }
433     }
434 
435     /**
436      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
437      */
438     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
439         bytes memory buffer = new bytes(2 * length + 2);
440         buffer[0] = "0";
441         buffer[1] = "x";
442         for (uint256 i = 2 * length + 1; i > 1; --i) {
443             buffer[i] = _SYMBOLS[value & 0xf];
444             value >>= 4;
445         }
446         require(value == 0, "Strings: hex length insufficient");
447         return string(buffer);
448     }
449 
450     /**
451      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
452      */
453     function toHexString(address addr) internal pure returns (string memory) {
454         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
455     }
456 }
457 
458 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
459 
460 
461 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
462 
463 pragma solidity ^0.8.0;
464 
465 /**
466  * @dev Contract module that helps prevent reentrant calls to a function.
467  *
468  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
469  * available, which can be applied to functions to make sure there are no nested
470  * (reentrant) calls to them.
471  *
472  * Note that because there is a single `nonReentrant` guard, functions marked as
473  * `nonReentrant` may not call one another. This can be worked around by making
474  * those functions `private`, and then adding `external` `nonReentrant` entry
475  * points to them.
476  *
477  * TIP: If you would like to learn more about reentrancy and alternative ways
478  * to protect against it, check out our blog post
479  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
480  */
481 abstract contract ReentrancyGuard {
482     // Booleans are more expensive than uint256 or any type that takes up a full
483     // word because each write operation emits an extra SLOAD to first read the
484     // slot's contents, replace the bits taken up by the boolean, and then write
485     // back. This is the compiler's defense against contract upgrades and
486     // pointer aliasing, and it cannot be disabled.
487 
488     // The values being non-zero value makes deployment a bit more expensive,
489     // but in exchange the refund on every call to nonReentrant will be lower in
490     // amount. Since refunds are capped to a percentage of the total
491     // transaction's gas, it is best to keep them low in cases like this one, to
492     // increase the likelihood of the full refund coming into effect.
493     uint256 private constant _NOT_ENTERED = 1;
494     uint256 private constant _ENTERED = 2;
495 
496     uint256 private _status;
497 
498     constructor() {
499         _status = _NOT_ENTERED;
500     }
501 
502     /**
503      * @dev Prevents a contract from calling itself, directly or indirectly.
504      * Calling a `nonReentrant` function from another `nonReentrant`
505      * function is not supported. It is possible to prevent this from happening
506      * by making the `nonReentrant` function external, and making it call a
507      * `private` function that does the actual work.
508      */
509     modifier nonReentrant() {
510         _nonReentrantBefore();
511         _;
512         _nonReentrantAfter();
513     }
514 
515     function _nonReentrantBefore() private {
516         // On the first call to nonReentrant, _status will be _NOT_ENTERED
517         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
518 
519         // Any calls to nonReentrant after this point will fail
520         _status = _ENTERED;
521     }
522 
523     function _nonReentrantAfter() private {
524         // By storing the original value once again, a refund is triggered (see
525         // https://eips.ethereum.org/EIPS/eip-2200)
526         _status = _NOT_ENTERED;
527     }
528 }
529 
530 // File: @openzeppelin/contracts/utils/Context.sol
531 
532 
533 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
534 
535 pragma solidity ^0.8.0;
536 
537 /**
538  * @dev Provides information about the current execution context, including the
539  * sender of the transaction and its data. While these are generally available
540  * via msg.sender and msg.data, they should not be accessed in such a direct
541  * manner, since when dealing with meta-transactions the account sending and
542  * paying for execution may not be the actual sender (as far as an application
543  * is concerned).
544  *
545  * This contract is only required for intermediate, library-like contracts.
546  */
547 abstract contract Context {
548     function _msgSender() internal view virtual returns (address) {
549         return msg.sender;
550     }
551 
552     function _msgData() internal view virtual returns (bytes calldata) {
553         return msg.data;
554     }
555 }
556 
557 // File: @openzeppelin/contracts/access/Ownable.sol
558 
559 
560 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 
565 /**
566  * @dev Contract module which provides a basic access control mechanism, where
567  * there is an account (an owner) that can be granted exclusive access to
568  * specific functions.
569  *
570  * By default, the owner account will be the one that deploys the contract. This
571  * can later be changed with {transferOwnership}.
572  *
573  * This module is used through inheritance. It will make available the modifier
574  * `onlyOwner`, which can be applied to your functions to restrict their use to
575  * the owner.
576  */
577 abstract contract Ownable is Context {
578     address private _owner;
579 
580     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
581 
582     /**
583      * @dev Initializes the contract setting the deployer as the initial owner.
584      */
585     constructor() {
586         _transferOwnership(_msgSender());
587     }
588 
589     /**
590      * @dev Throws if called by any account other than the owner.
591      */
592     modifier onlyOwner() {
593         _checkOwner();
594         _;
595     }
596 
597     /**
598      * @dev Returns the address of the current owner.
599      */
600     function owner() public view virtual returns (address) {
601         return _owner;
602     }
603 
604     /**
605      * @dev Throws if the sender is not the owner.
606      */
607     function _checkOwner() internal view virtual {
608         require(owner() == _msgSender(), "Ownable: caller is not the owner");
609     }
610 
611     /**
612      * @dev Leaves the contract without owner. It will not be possible to call
613      * `onlyOwner` functions anymore. Can only be called by the current owner.
614      *
615      * NOTE: Renouncing ownership will leave the contract without an owner,
616      * thereby removing any functionality that is only available to the owner.
617      */
618     function renounceOwnership() public virtual onlyOwner {
619         _transferOwnership(address(0));
620     }
621 
622     /**
623      * @dev Transfers ownership of the contract to a new account (`newOwner`).
624      * Can only be called by the current owner.
625      */
626     function transferOwnership(address newOwner) public virtual onlyOwner {
627         require(newOwner != address(0), "Ownable: new owner is the zero address");
628         _transferOwnership(newOwner);
629     }
630 
631     /**
632      * @dev Transfers ownership of the contract to a new account (`newOwner`).
633      * Internal function without access restriction.
634      */
635     function _transferOwnership(address newOwner) internal virtual {
636         address oldOwner = _owner;
637         _owner = newOwner;
638         emit OwnershipTransferred(oldOwner, newOwner);
639     }
640 }
641 
642 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
643 
644 
645 // OpenZeppelin Contracts (last updated v4.8.0) (utils/structs/EnumerableSet.sol)
646 // This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.
647 
648 pragma solidity ^0.8.0;
649 
650 /**
651  * @dev Library for managing
652  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
653  * types.
654  *
655  * Sets have the following properties:
656  *
657  * - Elements are added, removed, and checked for existence in constant time
658  * (O(1)).
659  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
660  *
661  * ```
662  * contract Example {
663  *     // Add the library methods
664  *     using EnumerableSet for EnumerableSet.AddressSet;
665  *
666  *     // Declare a set state variable
667  *     EnumerableSet.AddressSet private mySet;
668  * }
669  * ```
670  *
671  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
672  * and `uint256` (`UintSet`) are supported.
673  *
674  * [WARNING]
675  * ====
676  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
677  * unusable.
678  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
679  *
680  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
681  * array of EnumerableSet.
682  * ====
683  */
684 library EnumerableSet {
685     // To implement this library for multiple types with as little code
686     // repetition as possible, we write it in terms of a generic Set type with
687     // bytes32 values.
688     // The Set implementation uses private functions, and user-facing
689     // implementations (such as AddressSet) are just wrappers around the
690     // underlying Set.
691     // This means that we can only create new EnumerableSets for types that fit
692     // in bytes32.
693 
694     struct Set {
695         // Storage of set values
696         bytes32[] _values;
697         // Position of the value in the `values` array, plus 1 because index 0
698         // means a value is not in the set.
699         mapping(bytes32 => uint256) _indexes;
700     }
701 
702     /**
703      * @dev Add a value to a set. O(1).
704      *
705      * Returns true if the value was added to the set, that is if it was not
706      * already present.
707      */
708     function _add(Set storage set, bytes32 value) private returns (bool) {
709         if (!_contains(set, value)) {
710             set._values.push(value);
711             // The value is stored at length-1, but we add 1 to all indexes
712             // and use 0 as a sentinel value
713             set._indexes[value] = set._values.length;
714             return true;
715         } else {
716             return false;
717         }
718     }
719 
720     /**
721      * @dev Removes a value from a set. O(1).
722      *
723      * Returns true if the value was removed from the set, that is if it was
724      * present.
725      */
726     function _remove(Set storage set, bytes32 value) private returns (bool) {
727         // We read and store the value's index to prevent multiple reads from the same storage slot
728         uint256 valueIndex = set._indexes[value];
729 
730         if (valueIndex != 0) {
731             // Equivalent to contains(set, value)
732             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
733             // the array, and then remove the last element (sometimes called as 'swap and pop').
734             // This modifies the order of the array, as noted in {at}.
735 
736             uint256 toDeleteIndex = valueIndex - 1;
737             uint256 lastIndex = set._values.length - 1;
738 
739             if (lastIndex != toDeleteIndex) {
740                 bytes32 lastValue = set._values[lastIndex];
741 
742                 // Move the last value to the index where the value to delete is
743                 set._values[toDeleteIndex] = lastValue;
744                 // Update the index for the moved value
745                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
746             }
747 
748             // Delete the slot where the moved value was stored
749             set._values.pop();
750 
751             // Delete the index for the deleted slot
752             delete set._indexes[value];
753 
754             return true;
755         } else {
756             return false;
757         }
758     }
759 
760     /**
761      * @dev Returns true if the value is in the set. O(1).
762      */
763     function _contains(Set storage set, bytes32 value) private view returns (bool) {
764         return set._indexes[value] != 0;
765     }
766 
767     /**
768      * @dev Returns the number of values on the set. O(1).
769      */
770     function _length(Set storage set) private view returns (uint256) {
771         return set._values.length;
772     }
773 
774     /**
775      * @dev Returns the value stored at position `index` in the set. O(1).
776      *
777      * Note that there are no guarantees on the ordering of values inside the
778      * array, and it may change when more values are added or removed.
779      *
780      * Requirements:
781      *
782      * - `index` must be strictly less than {length}.
783      */
784     function _at(Set storage set, uint256 index) private view returns (bytes32) {
785         return set._values[index];
786     }
787 
788     /**
789      * @dev Return the entire set in an array
790      *
791      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
792      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
793      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
794      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
795      */
796     function _values(Set storage set) private view returns (bytes32[] memory) {
797         return set._values;
798     }
799 
800     // Bytes32Set
801 
802     struct Bytes32Set {
803         Set _inner;
804     }
805 
806     /**
807      * @dev Add a value to a set. O(1).
808      *
809      * Returns true if the value was added to the set, that is if it was not
810      * already present.
811      */
812     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
813         return _add(set._inner, value);
814     }
815 
816     /**
817      * @dev Removes a value from a set. O(1).
818      *
819      * Returns true if the value was removed from the set, that is if it was
820      * present.
821      */
822     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
823         return _remove(set._inner, value);
824     }
825 
826     /**
827      * @dev Returns true if the value is in the set. O(1).
828      */
829     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
830         return _contains(set._inner, value);
831     }
832 
833     /**
834      * @dev Returns the number of values in the set. O(1).
835      */
836     function length(Bytes32Set storage set) internal view returns (uint256) {
837         return _length(set._inner);
838     }
839 
840     /**
841      * @dev Returns the value stored at position `index` in the set. O(1).
842      *
843      * Note that there are no guarantees on the ordering of values inside the
844      * array, and it may change when more values are added or removed.
845      *
846      * Requirements:
847      *
848      * - `index` must be strictly less than {length}.
849      */
850     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
851         return _at(set._inner, index);
852     }
853 
854     /**
855      * @dev Return the entire set in an array
856      *
857      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
858      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
859      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
860      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
861      */
862     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
863         bytes32[] memory store = _values(set._inner);
864         bytes32[] memory result;
865 
866         /// @solidity memory-safe-assembly
867         assembly {
868             result := store
869         }
870 
871         return result;
872     }
873 
874     // AddressSet
875 
876     struct AddressSet {
877         Set _inner;
878     }
879 
880     /**
881      * @dev Add a value to a set. O(1).
882      *
883      * Returns true if the value was added to the set, that is if it was not
884      * already present.
885      */
886     function add(AddressSet storage set, address value) internal returns (bool) {
887         return _add(set._inner, bytes32(uint256(uint160(value))));
888     }
889 
890     /**
891      * @dev Removes a value from a set. O(1).
892      *
893      * Returns true if the value was removed from the set, that is if it was
894      * present.
895      */
896     function remove(AddressSet storage set, address value) internal returns (bool) {
897         return _remove(set._inner, bytes32(uint256(uint160(value))));
898     }
899 
900     /**
901      * @dev Returns true if the value is in the set. O(1).
902      */
903     function contains(AddressSet storage set, address value) internal view returns (bool) {
904         return _contains(set._inner, bytes32(uint256(uint160(value))));
905     }
906 
907     /**
908      * @dev Returns the number of values in the set. O(1).
909      */
910     function length(AddressSet storage set) internal view returns (uint256) {
911         return _length(set._inner);
912     }
913 
914     /**
915      * @dev Returns the value stored at position `index` in the set. O(1).
916      *
917      * Note that there are no guarantees on the ordering of values inside the
918      * array, and it may change when more values are added or removed.
919      *
920      * Requirements:
921      *
922      * - `index` must be strictly less than {length}.
923      */
924     function at(AddressSet storage set, uint256 index) internal view returns (address) {
925         return address(uint160(uint256(_at(set._inner, index))));
926     }
927 
928     /**
929      * @dev Return the entire set in an array
930      *
931      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
932      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
933      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
934      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
935      */
936     function values(AddressSet storage set) internal view returns (address[] memory) {
937         bytes32[] memory store = _values(set._inner);
938         address[] memory result;
939 
940         /// @solidity memory-safe-assembly
941         assembly {
942             result := store
943         }
944 
945         return result;
946     }
947 
948     // UintSet
949 
950     struct UintSet {
951         Set _inner;
952     }
953 
954     /**
955      * @dev Add a value to a set. O(1).
956      *
957      * Returns true if the value was added to the set, that is if it was not
958      * already present.
959      */
960     function add(UintSet storage set, uint256 value) internal returns (bool) {
961         return _add(set._inner, bytes32(value));
962     }
963 
964     /**
965      * @dev Removes a value from a set. O(1).
966      *
967      * Returns true if the value was removed from the set, that is if it was
968      * present.
969      */
970     function remove(UintSet storage set, uint256 value) internal returns (bool) {
971         return _remove(set._inner, bytes32(value));
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
978         return _contains(set._inner, bytes32(value));
979     }
980 
981     /**
982      * @dev Returns the number of values in the set. O(1).
983      */
984     function length(UintSet storage set) internal view returns (uint256) {
985         return _length(set._inner);
986     }
987 
988     /**
989      * @dev Returns the value stored at position `index` in the set. O(1).
990      *
991      * Note that there are no guarantees on the ordering of values inside the
992      * array, and it may change when more values are added or removed.
993      *
994      * Requirements:
995      *
996      * - `index` must be strictly less than {length}.
997      */
998     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
999         return uint256(_at(set._inner, index));
1000     }
1001 
1002     /**
1003      * @dev Return the entire set in an array
1004      *
1005      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1006      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1007      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1008      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1009      */
1010     function values(UintSet storage set) internal view returns (uint256[] memory) {
1011         bytes32[] memory store = _values(set._inner);
1012         uint256[] memory result;
1013 
1014         /// @solidity memory-safe-assembly
1015         assembly {
1016             result := store
1017         }
1018 
1019         return result;
1020     }
1021 }
1022 
1023 // File: contracts/IOperatorFilterRegistry.sol
1024 
1025 
1026 pragma solidity ^0.8.13;
1027 
1028 
1029 interface IOperatorFilterRegistry {
1030     function isOperatorAllowed(address registrant, address operator) external returns (bool);
1031     function register(address registrant) external;
1032     function registerAndSubscribe(address registrant, address subscription) external;
1033     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1034     function updateOperator(address registrant, address operator, bool filtered) external;
1035     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1036     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1037     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1038     function subscribe(address registrant, address registrantToSubscribe) external;
1039     function unsubscribe(address registrant, bool copyExistingEntries) external;
1040     function subscriptionOf(address addr) external returns (address registrant);
1041     function subscribers(address registrant) external returns (address[] memory);
1042     function subscriberAt(address registrant, uint256 index) external returns (address);
1043     function copyEntriesOf(address registrant, address registrantToCopy) external;
1044     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1045     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1046     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1047     function filteredOperators(address addr) external returns (address[] memory);
1048     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1049     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1050     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1051     function isRegistered(address addr) external returns (bool);
1052     function codeHashOf(address addr) external returns (bytes32);
1053 }
1054 // File: contracts/OperatorFilterer.sol
1055 
1056 
1057 pragma solidity ^0.8.13;
1058 
1059 
1060 contract OperatorFilterer {
1061     error OperatorNotAllowed(address operator);
1062 
1063     IOperatorFilterRegistry constant operatorFilterRegistry =
1064         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1065 
1066     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1067         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1068         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1069         // order for the modifier to filter addresses.
1070         if (address(operatorFilterRegistry).code.length > 0) {
1071             if (subscribe) {
1072                 operatorFilterRegistry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1073             } else {
1074                 if (subscriptionOrRegistrantToCopy != address(0)) {
1075                     operatorFilterRegistry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1076                 } else {
1077                     operatorFilterRegistry.register(address(this));
1078                 }
1079             }
1080         }
1081     }
1082 
1083     modifier onlyAllowedOperator() virtual {
1084         // Check registry code length to facilitate testing in environments without a deployed registry.
1085         if (address(operatorFilterRegistry).code.length > 0) {
1086             if (!operatorFilterRegistry.isOperatorAllowed(address(this), msg.sender)) {
1087                 revert OperatorNotAllowed(msg.sender);
1088             }
1089         }
1090         _;
1091     }
1092 }
1093 // File: contracts/DefaultOperatorFilterer.sol
1094 
1095 
1096 pragma solidity ^0.8.13;
1097 
1098 
1099 contract DefaultOperatorFilterer is OperatorFilterer {
1100     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1101 
1102     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1103 }
1104 // File: contracts/IERC721A.sol
1105 
1106 
1107 // ERC721A Contracts v4.2.3
1108 // Creator: Chiru Labs
1109 
1110 pragma solidity ^0.8.4;
1111 
1112 /**
1113  * @dev Interface of ERC721A.
1114  */
1115 interface IERC721A {
1116     /**
1117      * The caller must own the token or be an approved operator.
1118      */
1119     error ApprovalCallerNotOwnerNorApproved();
1120 
1121     /**
1122      * The token does not exist.
1123      */
1124     error ApprovalQueryForNonexistentToken();
1125 
1126     /**
1127      * Cannot query the balance for the zero address.
1128      */
1129     error BalanceQueryForZeroAddress();
1130 
1131     /**
1132      * Cannot mint to the zero address.
1133      */
1134     error MintToZeroAddress();
1135 
1136     /**
1137      * The quantity of tokens minted must be more than zero.
1138      */
1139     error MintZeroQuantity();
1140 
1141     /**
1142      * The token does not exist.
1143      */
1144     error OwnerQueryForNonexistentToken();
1145 
1146     /**
1147      * The caller must own the token or be an approved operator.
1148      */
1149     error TransferCallerNotOwnerNorApproved();
1150 
1151     /**
1152      * The token must be owned by `from`.
1153      */
1154     error TransferFromIncorrectOwner();
1155 
1156     /**
1157      * Cannot safely transfer to a contract that does not implement the
1158      * ERC721Receiver interface.
1159      */
1160     error TransferToNonERC721ReceiverImplementer();
1161 
1162     /**
1163      * Cannot transfer to the zero address.
1164      */
1165     error TransferToZeroAddress();
1166 
1167     /**
1168      * The token does not exist.
1169      */
1170     error URIQueryForNonexistentToken();
1171 
1172     /**
1173      * The `quantity` minted with ERC2309 exceeds the safety limit.
1174      */
1175     error MintERC2309QuantityExceedsLimit();
1176 
1177     /**
1178      * The `extraData` cannot be set on an unintialized ownership slot.
1179      */
1180     error OwnershipNotInitializedForExtraData();
1181 
1182     // =============================================================
1183     //                            STRUCTS
1184     // =============================================================
1185 
1186     struct TokenOwnership {
1187         // The address of the owner.
1188         address addr;
1189         // Stores the start time of ownership with minimal overhead for tokenomics.
1190         uint64 startTimestamp;
1191         // Whether the token has been burned.
1192         bool burned;
1193         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1194         uint24 extraData;
1195     }
1196 
1197     // =============================================================
1198     //                         TOKEN COUNTERS
1199     // =============================================================
1200 
1201     /**
1202      * @dev Returns the total number of tokens in existence.
1203      * Burned tokens will reduce the count.
1204      * To get the total number of tokens minted, please see {_totalMinted}.
1205      */
1206     function totalSupply() external view returns (uint256);
1207 
1208     // =============================================================
1209     //                            IERC165
1210     // =============================================================
1211 
1212     /**
1213      * @dev Returns true if this contract implements the interface defined by
1214      * `interfaceId`. See the corresponding
1215      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1216      * to learn more about how these ids are created.
1217      *
1218      * This function call must use less than 30000 gas.
1219      */
1220     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1221 
1222     // =============================================================
1223     //                            IERC721
1224     // =============================================================
1225 
1226     /**
1227      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1228      */
1229     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1230 
1231     /**
1232      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1233      */
1234     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1235 
1236     /**
1237      * @dev Emitted when `owner` enables or disables
1238      * (`approved`) `operator` to manage all of its assets.
1239      */
1240     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1241 
1242     /**
1243      * @dev Returns the number of tokens in `owner`'s account.
1244      */
1245     function balanceOf(address owner) external view returns (uint256 balance);
1246 
1247     /**
1248      * @dev Returns the owner of the `tokenId` token.
1249      *
1250      * Requirements:
1251      *
1252      * - `tokenId` must exist.
1253      */
1254     function ownerOf(uint256 tokenId) external view returns (address owner);
1255 
1256     /**
1257      * @dev Safely transfers `tokenId` token from `from` to `to`,
1258      * checking first that contract recipients are aware of the ERC721 protocol
1259      * to prevent tokens from being forever locked.
1260      *
1261      * Requirements:
1262      *
1263      * - `from` cannot be the zero address.
1264      * - `to` cannot be the zero address.
1265      * - `tokenId` token must exist and be owned by `from`.
1266      * - If the caller is not `from`, it must be have been allowed to move
1267      * this token by either {approve} or {setApprovalForAll}.
1268      * - If `to` refers to a smart contract, it must implement
1269      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1270      *
1271      * Emits a {Transfer} event.
1272      */
1273     function safeTransferFrom(
1274         address from,
1275         address to,
1276         uint256 tokenId,
1277         bytes calldata data
1278     ) external;
1279 
1280     /**
1281      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1282      */
1283     function safeTransferFrom(
1284         address from,
1285         address to,
1286         uint256 tokenId
1287     ) external;
1288 
1289     /**
1290      * @dev Transfers `tokenId` from `from` to `to`.
1291      *
1292      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1293      * whenever possible.
1294      *
1295      * Requirements:
1296      *
1297      * - `from` cannot be the zero address.
1298      * - `to` cannot be the zero address.
1299      * - `tokenId` token must be owned by `from`.
1300      * - If the caller is not `from`, it must be approved to move this token
1301      * by either {approve} or {setApprovalForAll}.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function transferFrom(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) external;
1310 
1311     /**
1312      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1313      * The approval is cleared when the token is transferred.
1314      *
1315      * Only a single account can be approved at a time, so approving the
1316      * zero address clears previous approvals.
1317      *
1318      * Requirements:
1319      *
1320      * - The caller must own the token or be an approved operator.
1321      * - `tokenId` must exist.
1322      *
1323      * Emits an {Approval} event.
1324      */
1325     function approve(address to, uint256 tokenId) external payable;
1326 
1327     /**
1328      * @dev Approve or remove `operator` as an operator for the caller.
1329      * Operators can call {transferFrom} or {safeTransferFrom}
1330      * for any token owned by the caller.
1331      *
1332      * Requirements:
1333      *
1334      * - The `operator` cannot be the caller.
1335      *
1336      * Emits an {ApprovalForAll} event.
1337      */
1338     function setApprovalForAll(address operator, bool _approved) external;
1339 
1340     /**
1341      * @dev Returns the account approved for `tokenId` token.
1342      *
1343      * Requirements:
1344      *
1345      * - `tokenId` must exist.
1346      */
1347     function getApproved(uint256 tokenId) external view returns (address operator);
1348 
1349     /**
1350      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1351      *
1352      * See {setApprovalForAll}.
1353      */
1354     function isApprovedForAll(address owner, address operator) external view returns (bool);
1355 
1356     // =============================================================
1357     //                        IERC721Metadata
1358     // =============================================================
1359 
1360     /**
1361      * @dev Returns the token collection name.
1362      */
1363     function name() external view returns (string memory);
1364 
1365     /**
1366      * @dev Returns the token collection symbol.
1367      */
1368     function symbol() external view returns (string memory);
1369 
1370     /**
1371      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1372      */
1373     function tokenURI(uint256 tokenId) external view returns (string memory);
1374 
1375     // =============================================================
1376     //                           IERC2309
1377     // =============================================================
1378 
1379     /**
1380      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1381      * (inclusive) is transferred from `from` to `to`, as defined in the
1382      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1383      *
1384      * See {_mintERC2309} for more details.
1385      */
1386     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1387 }
1388 // File: contracts/ERC721A.sol
1389 
1390 
1391 // ERC721A Contracts v4.2.3
1392 // Creator: Chiru Labs
1393 
1394 pragma solidity ^0.8.4;
1395 
1396 
1397 /**
1398  * @dev Interface of ERC721 token receiver.
1399  */
1400 interface ERC721A__IERC721Receiver {
1401     function onERC721Received(
1402         address operator,
1403         address from,
1404         uint256 tokenId,
1405         bytes calldata data
1406     ) external returns (bytes4);
1407 }
1408 
1409 /**
1410  * @title ERC721A
1411  *
1412  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1413  * Non-Fungible Token Standard, including the Metadata extension.
1414  * Optimized for lower gas during batch mints.
1415  *
1416  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1417  * starting from `_startTokenId()`.
1418  *
1419  * Assumptions:
1420  *
1421  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1422  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1423  */
1424 contract ERC721A is IERC721A {
1425     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1426     struct TokenApprovalRef {
1427         address value;
1428     }
1429 
1430     // =============================================================
1431     //                           CONSTANTS
1432     // =============================================================
1433 
1434     // Mask of an entry in packed address data.
1435     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1436 
1437     // The bit position of `numberMinted` in packed address data.
1438     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1439 
1440     // The bit position of `numberBurned` in packed address data.
1441     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1442 
1443     // The bit position of `aux` in packed address data.
1444     uint256 private constant _BITPOS_AUX = 192;
1445 
1446     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1447     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1448 
1449     // The bit position of `startTimestamp` in packed ownership.
1450     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1451 
1452     // The bit mask of the `burned` bit in packed ownership.
1453     uint256 private constant _BITMASK_BURNED = 1 << 224;
1454 
1455     // The bit position of the `nextInitialized` bit in packed ownership.
1456     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1457 
1458     // The bit mask of the `nextInitialized` bit in packed ownership.
1459     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1460 
1461     // The bit position of `extraData` in packed ownership.
1462     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1463 
1464     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1465     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1466 
1467     // The mask of the lower 160 bits for addresses.
1468     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1469 
1470     // The maximum `quantity` that can be minted with {_mintERC2309}.
1471     // This limit is to prevent overflows on the address data entries.
1472     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1473     // is required to cause an overflow, which is unrealistic.
1474     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1475 
1476     // The `Transfer` event signature is given by:
1477     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1478     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1479         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1480 
1481     // =============================================================
1482     //                            STORAGE
1483     // =============================================================
1484 
1485     // The next token ID to be minted.
1486     uint256 private _currentIndex;
1487 
1488     // The number of tokens burned.
1489     uint256 private _burnCounter;
1490 
1491     // Token name
1492     string private _name;
1493 
1494     // Token symbol
1495     string private _symbol;
1496 
1497     // Mapping from token ID to ownership details
1498     // An empty struct value does not necessarily mean the token is unowned.
1499     // See {_packedOwnershipOf} implementation for details.
1500     //
1501     // Bits Layout:
1502     // - [0..159]   `addr`
1503     // - [160..223] `startTimestamp`
1504     // - [224]      `burned`
1505     // - [225]      `nextInitialized`
1506     // - [232..255] `extraData`
1507     mapping(uint256 => uint256) private _packedOwnerships;
1508 
1509     // Mapping owner address to address data.
1510     //
1511     // Bits Layout:
1512     // - [0..63]    `balance`
1513     // - [64..127]  `numberMinted`
1514     // - [128..191] `numberBurned`
1515     // - [192..255] `aux`
1516     mapping(address => uint256) private _packedAddressData;
1517 
1518     // Mapping from token ID to approved address.
1519     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1520 
1521     // Mapping from owner to operator approvals
1522     mapping(address => mapping(address => bool)) private _operatorApprovals;
1523 
1524     // =============================================================
1525     //                          CONSTRUCTOR
1526     // =============================================================
1527 
1528     constructor(string memory name_, string memory symbol_) {
1529         _name = name_;
1530         _symbol = symbol_;
1531         _currentIndex = _startTokenId();
1532     }
1533 
1534     // =============================================================
1535     //                   TOKEN COUNTING OPERATIONS
1536     // =============================================================
1537 
1538     /**
1539      * @dev Returns the starting token ID.
1540      * To change the starting token ID, please override this function.
1541      */
1542     function _startTokenId() internal view virtual returns (uint256) {
1543         return 0;
1544     }
1545 
1546     /**
1547      * @dev Returns the next token ID to be minted.
1548      */
1549     function _nextTokenId() internal view virtual returns (uint256) {
1550         return _currentIndex;
1551     }
1552 
1553     /**
1554      * @dev Returns the total number of tokens in existence.
1555      * Burned tokens will reduce the count.
1556      * To get the total number of tokens minted, please see {_totalMinted}.
1557      */
1558     function totalSupply() public view virtual override returns (uint256) {
1559         // Counter underflow is impossible as _burnCounter cannot be incremented
1560         // more than `_currentIndex - _startTokenId()` times.
1561         unchecked {
1562             return _currentIndex - _burnCounter - _startTokenId();
1563         }
1564     }
1565 
1566     /**
1567      * @dev Returns the total amount of tokens minted in the contract.
1568      */
1569     function _totalMinted() internal view virtual returns (uint256) {
1570         // Counter underflow is impossible as `_currentIndex` does not decrement,
1571         // and it is initialized to `_startTokenId()`.
1572         unchecked {
1573             return _currentIndex - _startTokenId();
1574         }
1575     }
1576 
1577     /**
1578      * @dev Returns the total number of tokens burned.
1579      */
1580     function _totalBurned() internal view virtual returns (uint256) {
1581         return _burnCounter;
1582     }
1583 
1584     // =============================================================
1585     //                    ADDRESS DATA OPERATIONS
1586     // =============================================================
1587 
1588     /**
1589      * @dev Returns the number of tokens in `owner`'s account.
1590      */
1591     function balanceOf(address owner) public view virtual override returns (uint256) {
1592         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1593         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1594     }
1595 
1596     /**
1597      * Returns the number of tokens minted by `owner`.
1598      */
1599     function _numberMinted(address owner) internal view returns (uint256) {
1600         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1601     }
1602 
1603     /**
1604      * Returns the number of tokens burned by or on behalf of `owner`.
1605      */
1606     function _numberBurned(address owner) internal view returns (uint256) {
1607         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1608     }
1609 
1610     /**
1611      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1612      */
1613     function _getAux(address owner) internal view returns (uint64) {
1614         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1615     }
1616 
1617     /**
1618      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1619      * If there are multiple variables, please pack them into a uint64.
1620      */
1621     function _setAux(address owner, uint64 aux) internal virtual {
1622         uint256 packed = _packedAddressData[owner];
1623         uint256 auxCasted;
1624         // Cast `aux` with assembly to avoid redundant masking.
1625         assembly {
1626             auxCasted := aux
1627         }
1628         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1629         _packedAddressData[owner] = packed;
1630     }
1631 
1632     // =============================================================
1633     //                            IERC165
1634     // =============================================================
1635 
1636     /**
1637      * @dev Returns true if this contract implements the interface defined by
1638      * `interfaceId`. See the corresponding
1639      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1640      * to learn more about how these ids are created.
1641      *
1642      * This function call must use less than 30000 gas.
1643      */
1644     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1645         // The interface IDs are constants representing the first 4 bytes
1646         // of the XOR of all function selectors in the interface.
1647         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1648         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1649         return
1650             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1651             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1652             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1653     }
1654 
1655     // =============================================================
1656     //                        IERC721Metadata
1657     // =============================================================
1658 
1659     /**
1660      * @dev Returns the token collection name.
1661      */
1662     function name() public view virtual override returns (string memory) {
1663         return _name;
1664     }
1665 
1666     /**
1667      * @dev Returns the token collection symbol.
1668      */
1669     function symbol() public view virtual override returns (string memory) {
1670         return _symbol;
1671     }
1672 
1673     /**
1674      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1675      */
1676     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1677         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1678 
1679         string memory baseURI = _baseURI();
1680         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1681     }
1682 
1683     /**
1684      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1685      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1686      * by default, it can be overridden in child contracts.
1687      */
1688     function _baseURI() internal view virtual returns (string memory) {
1689         return '';
1690     }
1691 
1692     // =============================================================
1693     //                     OWNERSHIPS OPERATIONS
1694     // =============================================================
1695 
1696     /**
1697      * @dev Returns the owner of the `tokenId` token.
1698      *
1699      * Requirements:
1700      *
1701      * - `tokenId` must exist.
1702      */
1703     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1704         return address(uint160(_packedOwnershipOf(tokenId)));
1705     }
1706 
1707     /**
1708      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1709      * It gradually moves to O(1) as tokens get transferred around over time.
1710      */
1711     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1712         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1713     }
1714 
1715     /**
1716      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1717      */
1718     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1719         return _unpackedOwnership(_packedOwnerships[index]);
1720     }
1721 
1722     /**
1723      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1724      */
1725     function _initializeOwnershipAt(uint256 index) internal virtual {
1726         if (_packedOwnerships[index] == 0) {
1727             _packedOwnerships[index] = _packedOwnershipOf(index);
1728         }
1729     }
1730 
1731     /**
1732      * Returns the packed ownership data of `tokenId`.
1733      */
1734     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1735         uint256 curr = tokenId;
1736 
1737         unchecked {
1738             if (_startTokenId() <= curr)
1739                 if (curr < _currentIndex) {
1740                     uint256 packed = _packedOwnerships[curr];
1741                     // If not burned.
1742                     if (packed & _BITMASK_BURNED == 0) {
1743                         // Invariant:
1744                         // There will always be an initialized ownership slot
1745                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1746                         // before an unintialized ownership slot
1747                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1748                         // Hence, `curr` will not underflow.
1749                         //
1750                         // We can directly compare the packed value.
1751                         // If the address is zero, packed will be zero.
1752                         while (packed == 0) {
1753                             packed = _packedOwnerships[--curr];
1754                         }
1755                         return packed;
1756                     }
1757                 }
1758         }
1759         revert OwnerQueryForNonexistentToken();
1760     }
1761 
1762     /**
1763      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1764      */
1765     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1766         ownership.addr = address(uint160(packed));
1767         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1768         ownership.burned = packed & _BITMASK_BURNED != 0;
1769         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1770     }
1771 
1772     /**
1773      * @dev Packs ownership data into a single uint256.
1774      */
1775     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1776         assembly {
1777             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1778             owner := and(owner, _BITMASK_ADDRESS)
1779             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1780             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1781         }
1782     }
1783 
1784     /**
1785      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1786      */
1787     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1788         // For branchless setting of the `nextInitialized` flag.
1789         assembly {
1790             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1791             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1792         }
1793     }
1794 
1795     // =============================================================
1796     //                      APPROVAL OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1801      * The approval is cleared when the token is transferred.
1802      *
1803      * Only a single account can be approved at a time, so approving the
1804      * zero address clears previous approvals.
1805      *
1806      * Requirements:
1807      *
1808      * - The caller must own the token or be an approved operator.
1809      * - `tokenId` must exist.
1810      *
1811      * Emits an {Approval} event.
1812      */
1813     function approve(address to, uint256 tokenId) public payable virtual override {
1814         address owner = ownerOf(tokenId);
1815 
1816         if (_msgSenderERC721A() != owner)
1817             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1818                 revert ApprovalCallerNotOwnerNorApproved();
1819             }
1820 
1821         _tokenApprovals[tokenId].value = to;
1822         emit Approval(owner, to, tokenId);
1823     }
1824 
1825     /**
1826      * @dev Returns the account approved for `tokenId` token.
1827      *
1828      * Requirements:
1829      *
1830      * - `tokenId` must exist.
1831      */
1832     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1833         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1834 
1835         return _tokenApprovals[tokenId].value;
1836     }
1837 
1838     /**
1839      * @dev Approve or remove `operator` as an operator for the caller.
1840      * Operators can call {transferFrom} or {safeTransferFrom}
1841      * for any token owned by the caller.
1842      *
1843      * Requirements:
1844      *
1845      * - The `operator` cannot be the caller.
1846      *
1847      * Emits an {ApprovalForAll} event.
1848      */
1849     function setApprovalForAll(address operator, bool approved) public virtual override {
1850         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1851         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1852     }
1853 
1854     /**
1855      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1856      *
1857      * See {setApprovalForAll}.
1858      */
1859     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1860         return _operatorApprovals[owner][operator];
1861     }
1862 
1863     /**
1864      * @dev Returns whether `tokenId` exists.
1865      *
1866      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1867      *
1868      * Tokens start existing when they are minted. See {_mint}.
1869      */
1870     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1871         return
1872             _startTokenId() <= tokenId &&
1873             tokenId < _currentIndex && // If within bounds,
1874             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1875     }
1876 
1877     /**
1878      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1879      */
1880     function _isSenderApprovedOrOwner(
1881         address approvedAddress,
1882         address owner,
1883         address msgSender
1884     ) private pure returns (bool result) {
1885         assembly {
1886             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1887             owner := and(owner, _BITMASK_ADDRESS)
1888             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1889             msgSender := and(msgSender, _BITMASK_ADDRESS)
1890             // `msgSender == owner || msgSender == approvedAddress`.
1891             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1892         }
1893     }
1894 
1895     /**
1896      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1897      */
1898     function _getApprovedSlotAndAddress(uint256 tokenId)
1899         private
1900         view
1901         returns (uint256 approvedAddressSlot, address approvedAddress)
1902     {
1903         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1904         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1905         assembly {
1906             approvedAddressSlot := tokenApproval.slot
1907             approvedAddress := sload(approvedAddressSlot)
1908         }
1909     }
1910 
1911     // =============================================================
1912     //                      TRANSFER OPERATIONS
1913     // =============================================================
1914 
1915     /**
1916      * @dev Transfers `tokenId` from `from` to `to`.
1917      *
1918      * Requirements:
1919      *
1920      * - `from` cannot be the zero address.
1921      * - `to` cannot be the zero address.
1922      * - `tokenId` token must be owned by `from`.
1923      * - If the caller is not `from`, it must be approved to move this token
1924      * by either {approve} or {setApprovalForAll}.
1925      *
1926      * Emits a {Transfer} event.
1927      */
1928     function transferFrom(
1929         address from,
1930         address to,
1931         uint256 tokenId
1932     ) public virtual override {
1933         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1934 
1935         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1936 
1937         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1938 
1939         // The nested ifs save around 20+ gas over a compound boolean condition.
1940         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1941             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1942 
1943         if (to == address(0)) revert TransferToZeroAddress();
1944 
1945         _beforeTokenTransfers(from, to, tokenId, 1);
1946 
1947         // Clear approvals from the previous owner.
1948         assembly {
1949             if approvedAddress {
1950                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1951                 sstore(approvedAddressSlot, 0)
1952             }
1953         }
1954 
1955         // Underflow of the sender's balance is impossible because we check for
1956         // ownership above and the recipient's balance can't realistically overflow.
1957         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1958         unchecked {
1959             // We can directly increment and decrement the balances.
1960             --_packedAddressData[from]; // Updates: `balance -= 1`.
1961             ++_packedAddressData[to]; // Updates: `balance += 1`.
1962 
1963             // Updates:
1964             // - `address` to the next owner.
1965             // - `startTimestamp` to the timestamp of transfering.
1966             // - `burned` to `false`.
1967             // - `nextInitialized` to `true`.
1968             _packedOwnerships[tokenId] = _packOwnershipData(
1969                 to,
1970                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1971             );
1972 
1973             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1974             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1975                 uint256 nextTokenId = tokenId + 1;
1976                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1977                 if (_packedOwnerships[nextTokenId] == 0) {
1978                     // If the next slot is within bounds.
1979                     if (nextTokenId != _currentIndex) {
1980                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1981                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1982                     }
1983                 }
1984             }
1985         }
1986 
1987         emit Transfer(from, to, tokenId);
1988         _afterTokenTransfers(from, to, tokenId, 1);
1989     }
1990 
1991     /**
1992      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1993      */
1994     function safeTransferFrom(
1995         address from,
1996         address to,
1997         uint256 tokenId
1998     ) public virtual override {
1999         safeTransferFrom(from, to, tokenId, '');
2000     }
2001 
2002     /**
2003      * @dev Safely transfers `tokenId` token from `from` to `to`.
2004      *
2005      * Requirements:
2006      *
2007      * - `from` cannot be the zero address.
2008      * - `to` cannot be the zero address.
2009      * - `tokenId` token must exist and be owned by `from`.
2010      * - If the caller is not `from`, it must be approved to move this token
2011      * by either {approve} or {setApprovalForAll}.
2012      * - If `to` refers to a smart contract, it must implement
2013      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2014      *
2015      * Emits a {Transfer} event.
2016      */
2017     function safeTransferFrom(
2018         address from,
2019         address to,
2020         uint256 tokenId,
2021         bytes memory _data
2022     ) public virtual override {
2023         transferFrom(from, to, tokenId);
2024         if (to.code.length != 0)
2025             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2026                 revert TransferToNonERC721ReceiverImplementer();
2027             }
2028     }
2029 
2030     /**
2031      * @dev Hook that is called before a set of serially-ordered token IDs
2032      * are about to be transferred. This includes minting.
2033      * And also called before burning one token.
2034      *
2035      * `startTokenId` - the first token ID to be transferred.
2036      * `quantity` - the amount to be transferred.
2037      *
2038      * Calling conditions:
2039      *
2040      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2041      * transferred to `to`.
2042      * - When `from` is zero, `tokenId` will be minted for `to`.
2043      * - When `to` is zero, `tokenId` will be burned by `from`.
2044      * - `from` and `to` are never both zero.
2045      */
2046     function _beforeTokenTransfers(
2047         address from,
2048         address to,
2049         uint256 startTokenId,
2050         uint256 quantity
2051     ) internal virtual {}
2052 
2053     /**
2054      * @dev Hook that is called after a set of serially-ordered token IDs
2055      * have been transferred. This includes minting.
2056      * And also called after one token has been burned.
2057      *
2058      * `startTokenId` - the first token ID to be transferred.
2059      * `quantity` - the amount to be transferred.
2060      *
2061      * Calling conditions:
2062      *
2063      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2064      * transferred to `to`.
2065      * - When `from` is zero, `tokenId` has been minted for `to`.
2066      * - When `to` is zero, `tokenId` has been burned by `from`.
2067      * - `from` and `to` are never both zero.
2068      */
2069     function _afterTokenTransfers(
2070         address from,
2071         address to,
2072         uint256 startTokenId,
2073         uint256 quantity
2074     ) internal virtual {}
2075 
2076     /**
2077      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2078      *
2079      * `from` - Previous owner of the given token ID.
2080      * `to` - Target address that will receive the token.
2081      * `tokenId` - Token ID to be transferred.
2082      * `_data` - Optional data to send along with the call.
2083      *
2084      * Returns whether the call correctly returned the expected magic value.
2085      */
2086     function _checkContractOnERC721Received(
2087         address from,
2088         address to,
2089         uint256 tokenId,
2090         bytes memory _data
2091     ) private returns (bool) {
2092         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2093             bytes4 retval
2094         ) {
2095             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2096         } catch (bytes memory reason) {
2097             if (reason.length == 0) {
2098                 revert TransferToNonERC721ReceiverImplementer();
2099             } else {
2100                 assembly {
2101                     revert(add(32, reason), mload(reason))
2102                 }
2103             }
2104         }
2105     }
2106 
2107     // =============================================================
2108     //                        MINT OPERATIONS
2109     // =============================================================
2110 
2111     /**
2112      * @dev Mints `quantity` tokens and transfers them to `to`.
2113      *
2114      * Requirements:
2115      *
2116      * - `to` cannot be the zero address.
2117      * - `quantity` must be greater than 0.
2118      *
2119      * Emits a {Transfer} event for each mint.
2120      */
2121     function _mint(address to, uint256 quantity) internal virtual {
2122         uint256 startTokenId = _currentIndex;
2123         if (quantity == 0) revert MintZeroQuantity();
2124 
2125         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2126 
2127         // Overflows are incredibly unrealistic.
2128         // `balance` and `numberMinted` have a maximum limit of 2**64.
2129         // `tokenId` has a maximum limit of 2**256.
2130         unchecked {
2131             // Updates:
2132             // - `balance += quantity`.
2133             // - `numberMinted += quantity`.
2134             //
2135             // We can directly add to the `balance` and `numberMinted`.
2136             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2137 
2138             // Updates:
2139             // - `address` to the owner.
2140             // - `startTimestamp` to the timestamp of minting.
2141             // - `burned` to `false`.
2142             // - `nextInitialized` to `quantity == 1`.
2143             _packedOwnerships[startTokenId] = _packOwnershipData(
2144                 to,
2145                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2146             );
2147 
2148             uint256 toMasked;
2149             uint256 end = startTokenId + quantity;
2150 
2151             // Use assembly to loop and emit the `Transfer` event for gas savings.
2152             // The duplicated `log4` removes an extra check and reduces stack juggling.
2153             // The assembly, together with the surrounding Solidity code, have been
2154             // delicately arranged to nudge the compiler into producing optimized opcodes.
2155             assembly {
2156                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2157                 toMasked := and(to, _BITMASK_ADDRESS)
2158                 // Emit the `Transfer` event.
2159                 log4(
2160                     0, // Start of data (0, since no data).
2161                     0, // End of data (0, since no data).
2162                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2163                     0, // `address(0)`.
2164                     toMasked, // `to`.
2165                     startTokenId // `tokenId`.
2166                 )
2167 
2168                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2169                 // that overflows uint256 will make the loop run out of gas.
2170                 // The compiler will optimize the `iszero` away for performance.
2171                 for {
2172                     let tokenId := add(startTokenId, 1)
2173                 } iszero(eq(tokenId, end)) {
2174                     tokenId := add(tokenId, 1)
2175                 } {
2176                     // Emit the `Transfer` event. Similar to above.
2177                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2178                 }
2179             }
2180             if (toMasked == 0) revert MintToZeroAddress();
2181 
2182             _currentIndex = end;
2183         }
2184         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2185     }
2186 
2187     /**
2188      * @dev Mints `quantity` tokens and transfers them to `to`.
2189      *
2190      * This function is intended for efficient minting only during contract creation.
2191      *
2192      * It emits only one {ConsecutiveTransfer} as defined in
2193      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2194      * instead of a sequence of {Transfer} event(s).
2195      *
2196      * Calling this function outside of contract creation WILL make your contract
2197      * non-compliant with the ERC721 standard.
2198      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2199      * {ConsecutiveTransfer} event is only permissible during contract creation.
2200      *
2201      * Requirements:
2202      *
2203      * - `to` cannot be the zero address.
2204      * - `quantity` must be greater than 0.
2205      *
2206      * Emits a {ConsecutiveTransfer} event.
2207      */
2208     function _mintERC2309(address to, uint256 quantity) internal virtual {
2209         uint256 startTokenId = _currentIndex;
2210         if (to == address(0)) revert MintToZeroAddress();
2211         if (quantity == 0) revert MintZeroQuantity();
2212         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2213 
2214         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2215 
2216         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2217         unchecked {
2218             // Updates:
2219             // - `balance += quantity`.
2220             // - `numberMinted += quantity`.
2221             //
2222             // We can directly add to the `balance` and `numberMinted`.
2223             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2224 
2225             // Updates:
2226             // - `address` to the owner.
2227             // - `startTimestamp` to the timestamp of minting.
2228             // - `burned` to `false`.
2229             // - `nextInitialized` to `quantity == 1`.
2230             _packedOwnerships[startTokenId] = _packOwnershipData(
2231                 to,
2232                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2233             );
2234 
2235             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2236 
2237             _currentIndex = startTokenId + quantity;
2238         }
2239         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2240     }
2241 
2242     /**
2243      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2244      *
2245      * Requirements:
2246      *
2247      * - If `to` refers to a smart contract, it must implement
2248      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2249      * - `quantity` must be greater than 0.
2250      *
2251      * See {_mint}.
2252      *
2253      * Emits a {Transfer} event for each mint.
2254      */
2255     function _safeMint(
2256         address to,
2257         uint256 quantity,
2258         bytes memory _data
2259     ) internal virtual {
2260         _mint(to, quantity);
2261 
2262         unchecked {
2263             if (to.code.length != 0) {
2264                 uint256 end = _currentIndex;
2265                 uint256 index = end - quantity;
2266                 do {
2267                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2268                         revert TransferToNonERC721ReceiverImplementer();
2269                     }
2270                 } while (index < end);
2271                 // Reentrancy protection.
2272                 if (_currentIndex != end) revert();
2273             }
2274         }
2275     }
2276 
2277     /**
2278      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2279      */
2280     function _safeMint(address to, uint256 quantity) internal virtual {
2281         _safeMint(to, quantity, '');
2282     }
2283 
2284     // =============================================================
2285     //                        BURN OPERATIONS
2286     // =============================================================
2287 
2288     /**
2289      * @dev Equivalent to `_burn(tokenId, false)`.
2290      */
2291     function _burn(uint256 tokenId) internal virtual {
2292         _burn(tokenId, false);
2293     }
2294 
2295     /**
2296      * @dev Destroys `tokenId`.
2297      * The approval is cleared when the token is burned.
2298      *
2299      * Requirements:
2300      *
2301      * - `tokenId` must exist.
2302      *
2303      * Emits a {Transfer} event.
2304      */
2305     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2306         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2307 
2308         address from = address(uint160(prevOwnershipPacked));
2309 
2310         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2311 
2312         if (approvalCheck) {
2313             // The nested ifs save around 20+ gas over a compound boolean condition.
2314             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2315                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2316         }
2317 
2318         _beforeTokenTransfers(from, address(0), tokenId, 1);
2319 
2320         // Clear approvals from the previous owner.
2321         assembly {
2322             if approvedAddress {
2323                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2324                 sstore(approvedAddressSlot, 0)
2325             }
2326         }
2327 
2328         // Underflow of the sender's balance is impossible because we check for
2329         // ownership above and the recipient's balance can't realistically overflow.
2330         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2331         unchecked {
2332             // Updates:
2333             // - `balance -= 1`.
2334             // - `numberBurned += 1`.
2335             //
2336             // We can directly decrement the balance, and increment the number burned.
2337             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2338             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2339 
2340             // Updates:
2341             // - `address` to the last owner.
2342             // - `startTimestamp` to the timestamp of burning.
2343             // - `burned` to `true`.
2344             // - `nextInitialized` to `true`.
2345             _packedOwnerships[tokenId] = _packOwnershipData(
2346                 from,
2347                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2348             );
2349 
2350             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2351             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2352                 uint256 nextTokenId = tokenId + 1;
2353                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2354                 if (_packedOwnerships[nextTokenId] == 0) {
2355                     // If the next slot is within bounds.
2356                     if (nextTokenId != _currentIndex) {
2357                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2358                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2359                     }
2360                 }
2361             }
2362         }
2363 
2364         emit Transfer(from, address(0), tokenId);
2365         _afterTokenTransfers(from, address(0), tokenId, 1);
2366 
2367         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2368         unchecked {
2369             _burnCounter++;
2370         }
2371     }
2372 
2373     // =============================================================
2374     //                     EXTRA DATA OPERATIONS
2375     // =============================================================
2376 
2377     /**
2378      * @dev Directly sets the extra data for the ownership data `index`.
2379      */
2380     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2381         uint256 packed = _packedOwnerships[index];
2382         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2383         uint256 extraDataCasted;
2384         // Cast `extraData` with assembly to avoid redundant masking.
2385         assembly {
2386             extraDataCasted := extraData
2387         }
2388         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2389         _packedOwnerships[index] = packed;
2390     }
2391 
2392     /**
2393      * @dev Called during each token transfer to set the 24bit `extraData` field.
2394      * Intended to be overridden by the cosumer contract.
2395      *
2396      * `previousExtraData` - the value of `extraData` before transfer.
2397      *
2398      * Calling conditions:
2399      *
2400      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2401      * transferred to `to`.
2402      * - When `from` is zero, `tokenId` will be minted for `to`.
2403      * - When `to` is zero, `tokenId` will be burned by `from`.
2404      * - `from` and `to` are never both zero.
2405      */
2406     function _extraData(
2407         address from,
2408         address to,
2409         uint24 previousExtraData
2410     ) internal view virtual returns (uint24) {}
2411 
2412     /**
2413      * @dev Returns the next extra data for the packed ownership data.
2414      * The returned result is shifted into position.
2415      */
2416     function _nextExtraData(
2417         address from,
2418         address to,
2419         uint256 prevOwnershipPacked
2420     ) private view returns (uint256) {
2421         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2422         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2423     }
2424 
2425     // =============================================================
2426     //                       OTHER OPERATIONS
2427     // =============================================================
2428 
2429     /**
2430      * @dev Returns the message sender (defaults to `msg.sender`).
2431      *
2432      * If you are writing GSN compatible contracts, you need to override this function.
2433      */
2434     function _msgSenderERC721A() internal view virtual returns (address) {
2435         return msg.sender;
2436     }
2437 
2438     /**
2439      * @dev Converts a uint256 to its ASCII string decimal representation.
2440      */
2441     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2442         assembly {
2443             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2444             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2445             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2446             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2447             let m := add(mload(0x40), 0xa0)
2448             // Update the free memory pointer to allocate.
2449             mstore(0x40, m)
2450             // Assign the `str` to the end.
2451             str := sub(m, 0x20)
2452             // Zeroize the slot after the string.
2453             mstore(str, 0)
2454 
2455             // Cache the end of the memory to calculate the length later.
2456             let end := str
2457 
2458             // We write the string from rightmost digit to leftmost digit.
2459             // The following is essentially a do-while loop that also handles the zero case.
2460             // prettier-ignore
2461             for { let temp := value } 1 {} {
2462                 str := sub(str, 1)
2463                 // Write the character to the pointer.
2464                 // The ASCII index of the '0' character is 48.
2465                 mstore8(str, add(48, mod(temp, 10)))
2466                 // Keep dividing `temp` until zero.
2467                 temp := div(temp, 10)
2468                 // prettier-ignore
2469                 if iszero(temp) { break }
2470             }
2471 
2472             let length := sub(end, str)
2473             // Move the pointer 32 bytes leftwards to make room for the length.
2474             str := sub(str, 0x20)
2475             // Store the length.
2476             mstore(str, length)
2477         }
2478     }
2479 }
2480 // File: contracts/JackedDegenerates.sol
2481 pragma solidity >=0.8.9 <0.9.0;
2482 
2483 
2484 
2485 
2486 
2487 
2488 
2489 contract JackedDegenerates is ERC721A, Ownable, DefaultOperatorFilterer, ReentrancyGuard {
2490     using StringsUpgradeable for uint256;
2491     
2492     string public uriPrefix = "";
2493     string public uriSuffix = ".json";
2494     string public hiddenMetadataUri;
2495     string public provenance;
2496 
2497     uint256 public cost = .0025 ether;
2498     uint256 public maxSupply = 10000;
2499     uint256 public maxMintAmountPerTx = 10;
2500 
2501     bool public paused = true;
2502     bool public revealed = false;
2503 
2504     constructor(
2505         string memory _tokenName,
2506         string memory _tokenSymbol,
2507         string memory _hiddenMetadataUri
2508     ) ERC721A(_tokenName, _tokenSymbol) {
2509         setHiddenMetadataUri(_hiddenMetadataUri);
2510     }
2511 
2512     modifier mintCompliance(uint256 _mintAmount) {
2513         require(
2514             _mintAmount > 0 && _mintAmount <= maxMintAmountPerTx,
2515             "Invalid mint amount!"
2516         );
2517         require(
2518             totalSupply() + _mintAmount <= maxSupply,
2519             "Max supply exceeded!"
2520         );
2521         _;
2522     }
2523 
2524     modifier mintPriceCompliance(uint256 _mintAmount) {
2525             require(msg.value >= cost * _mintAmount, "Insufficient funds!");
2526         _;
2527     }
2528 
2529     modifier callerIsUser(){
2530         require(tx.origin == msg.sender, "Jacked Degenerates cannot be called by a contract");
2531         _;
2532     }
2533 
2534 
2535     function mint(uint256 _mintAmount)
2536         public
2537         payable
2538         callerIsUser()
2539         mintCompliance(_mintAmount)
2540         mintPriceCompliance(_mintAmount)
2541     {
2542         require(!paused, "The contract is paused!");
2543 
2544         _safeMint(_msgSender(), _mintAmount);
2545     }
2546 
2547 
2548     function _startTokenId() internal view virtual override returns (uint256) {
2549         return 1;
2550     }
2551 
2552     function tokenURI(uint256 _tokenId)
2553         public
2554         view
2555         virtual
2556         override
2557         returns (string memory)
2558     {
2559         require(
2560             _exists(_tokenId),
2561             "ERC721Metadata: URI query for nonexistent token"
2562         );
2563 
2564         if (revealed == false) {
2565             return hiddenMetadataUri;
2566         }
2567 
2568         string memory currentBaseURI = _baseURI();
2569         return
2570             bytes(currentBaseURI).length > 0
2571                 ? string(
2572                     abi.encodePacked(
2573                         currentBaseURI,
2574                         _tokenId.toString(),
2575                         uriSuffix
2576                     )
2577                 )
2578                 : "";
2579     }
2580 
2581     function setRevealed(bool _state) public onlyOwner {
2582         revealed = _state;
2583     }
2584 
2585     function setHiddenMetadataUri(string memory _hiddenMetadataUri)
2586         public
2587         onlyOwner
2588     {
2589         hiddenMetadataUri = _hiddenMetadataUri;
2590     }
2591 
2592     function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2593         uriPrefix = _uriPrefix;
2594     }
2595 
2596     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2597         uriSuffix = _uriSuffix;
2598     }
2599 
2600     function setPaused(bool _state) public onlyOwner {
2601         paused = _state;
2602     }
2603 
2604     function setCost(uint256 _cost) public onlyOwner {
2605         cost = _cost;
2606     }
2607 
2608 
2609     function setProvenance(string memory _provenance) public onlyOwner {
2610         provenance = _provenance;
2611     }
2612 
2613     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2614         super.transferFrom(from, to, tokenId);
2615     }
2616 
2617     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator {
2618         super.safeTransferFrom(from, to, tokenId);
2619     }
2620 
2621     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2622         public
2623         override
2624         onlyAllowedOperator
2625     {
2626         super.safeTransferFrom(from, to, tokenId, data);
2627     }
2628 
2629 
2630     function withdraw() public onlyOwner nonReentrant {
2631         (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2632         require(os);
2633     }
2634 
2635     function _baseURI() internal view virtual override returns (string memory) {
2636         return uriPrefix;
2637     }
2638 }