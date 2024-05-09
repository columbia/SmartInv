1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
7                                                                                                                                      
8                                                                                                                                      
9                                                                                                                                      
10                                                                                                                                      
11 //`7MN.   `7MF'     db     `7MMF' `YMM'      db     `7MMM.     ,MMF' .g8""8q. `7MN.   `7MF'`7MMF' `YMM'`7MM"""YMM `YMM'   `MM'.M"""bgd 
12 //  MMN.    M      ;MM:      MM   .M'       ;MM:      MMMb    dPMM .dP'    `YM. MMN.    M    MM   .M'    MM    `7   VMA   ,V ,MI    "Y 
13 //  M YMb   M     ,V^MM.     MM .d"        ,V^MM.     M YM   ,M MM dM'      `MM M YMb   M    MM .d"      MM   d      VMA ,V  `MMb.     
14 //  M  `MN. M    ,M  `MM     MMMMM.       ,M  `MM     M  Mb  M' MM MM        MM M  `MN. M    MMMMM.      MMmmMM       VMMP     `YMMNq. 
15 //  M   `MM.M    AbmmmqMA    MM  VMA      AbmmmqMA    M  YM.P'  MM MM.      ,MP M   `MM.M    MM  VMA     MM   Y  ,     MM    .     `MM 
16 //  M     YMM   A'     VML   MM   `MM.   A'     VML   M  `YM'   MM `Mb.    ,dP' M     YMM    MM   `MM.   MM     ,M     MM    Mb     dM 
17 //.JML.    YM .AMA.   .AMMA.JMML.   MMb.AMA.   .AMMA.JML. `'  .JMML. `"bmmd"' .JML.    YM  .JMML.   MMb.JMMmmmmMMM   .JMML.  P"Ybmmd"  
18                                                                                                                                      
19                                                                                                                                      
20                                                                                                                                      
21 
22 pragma solidity ^0.8.13;
23 
24 interface IOperatorFilterRegistry {
25     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
26     function register(address registrant) external;
27     function registerAndSubscribe(address registrant, address subscription) external;
28     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
29     function unregister(address addr) external;
30     function updateOperator(address registrant, address operator, bool filtered) external;
31     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
32     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
33     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
34     function subscribe(address registrant, address registrantToSubscribe) external;
35     function unsubscribe(address registrant, bool copyExistingEntries) external;
36     function subscriptionOf(address addr) external returns (address registrant);
37     function subscribers(address registrant) external returns (address[] memory);
38     function subscriberAt(address registrant, uint256 index) external returns (address);
39     function copyEntriesOf(address registrant, address registrantToCopy) external;
40     function isOperatorFiltered(address registrant, address operator) external returns (bool);
41     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
42     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
43     function filteredOperators(address addr) external returns (address[] memory);
44     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
45     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
46     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
47     function isRegistered(address addr) external returns (bool);
48     function codeHashOf(address addr) external returns (bytes32);
49 }
50 
51 // File: operator-filter-registry/src/OperatorFilterer.sol
52 
53 
54 pragma solidity ^0.8.13;
55 
56 
57 /**
58  * @title  OperatorFilterer
59  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
60  *         registrant's entries in the OperatorFilterRegistry.
61  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
62  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
63  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
64  */
65 abstract contract OperatorFilterer {
66     error OperatorNotAllowed(address operator);
67 
68     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
69         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
70 
71     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
72         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
73         // will not revert, but the contract will need to be registered with the registry once it is deployed in
74         // order for the modifier to filter addresses.
75         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
76             if (subscribe) {
77                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
78             } else {
79                 if (subscriptionOrRegistrantToCopy != address(0)) {
80                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
81                 } else {
82                     OPERATOR_FILTER_REGISTRY.register(address(this));
83                 }
84             }
85         }
86     }
87 
88     modifier onlyAllowedOperator(address from) virtual {
89         // Allow spending tokens from addresses with balance
90         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
91         // from an EOA.
92         if (from != msg.sender) {
93             _checkFilterOperator(msg.sender);
94         }
95         _;
96     }
97 
98     modifier onlyAllowedOperatorApproval(address operator) virtual {
99         _checkFilterOperator(operator);
100         _;
101     }
102 
103     function _checkFilterOperator(address operator) internal view virtual {
104         // Check registry code length to facilitate testing in environments without a deployed registry.
105         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
106             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
107                 revert OperatorNotAllowed(operator);
108             }
109         }
110     }
111 }
112 
113 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
114 
115 
116 pragma solidity ^0.8.13;
117 
118 
119 /**
120  * @title  DefaultOperatorFilterer
121  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
122  */
123 abstract contract DefaultOperatorFilterer is OperatorFilterer {
124     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
125 
126     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
127 }
128 
129 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
130 
131 
132 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
133 
134 pragma solidity ^0.8.0;
135 
136 /**
137  * @dev Contract module that helps prevent reentrant calls to a function.
138  *
139  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
140  * available, which can be applied to functions to make sure there are no nested
141  * (reentrant) calls to them.
142  *
143  * Note that because there is a single `nonReentrant` guard, functions marked as
144  * `nonReentrant` may not call one another. This can be worked around by making
145  * those functions `private`, and then adding `external` `nonReentrant` entry
146  * points to them.
147  *
148  * TIP: If you would like to learn more about reentrancy and alternative ways
149  * to protect against it, check out our blog post
150  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
151  */
152 abstract contract ReentrancyGuard {
153     // Booleans are more expensive than uint256 or any type that takes up a full
154     // word because each write operation emits an extra SLOAD to first read the
155     // slot's contents, replace the bits taken up by the boolean, and then write
156     // back. This is the compiler's defense against contract upgrades and
157     // pointer aliasing, and it cannot be disabled.
158 
159     // The values being non-zero value makes deployment a bit more expensive,
160     // but in exchange the refund on every call to nonReentrant will be lower in
161     // amount. Since refunds are capped to a percentage of the total
162     // transaction's gas, it is best to keep them low in cases like this one, to
163     // increase the likelihood of the full refund coming into effect.
164     uint256 private constant _NOT_ENTERED = 1;
165     uint256 private constant _ENTERED = 2;
166 
167     uint256 private _status;
168 
169     constructor() {
170         _status = _NOT_ENTERED;
171     }
172 
173     /**
174      * @dev Prevents a contract from calling itself, directly or indirectly.
175      * Calling a `nonReentrant` function from another `nonReentrant`
176      * function is not supported. It is possible to prevent this from happening
177      * by making the `nonReentrant` function external, and making it call a
178      * `private` function that does the actual work.
179      */
180     modifier nonReentrant() {
181         _nonReentrantBefore();
182         _;
183         _nonReentrantAfter();
184     }
185 
186     function _nonReentrantBefore() private {
187         // On the first call to nonReentrant, _status will be _NOT_ENTERED
188         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
189 
190         // Any calls to nonReentrant after this point will fail
191         _status = _ENTERED;
192     }
193 
194     function _nonReentrantAfter() private {
195         // By storing the original value once again, a refund is triggered (see
196         // https://eips.ethereum.org/EIPS/eip-2200)
197         _status = _NOT_ENTERED;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/utils/math/Math.sol
202 
203 
204 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 /**
209  * @dev Standard math utilities missing in the Solidity language.
210  */
211 library Math {
212     enum Rounding {
213         Down, // Toward negative infinity
214         Up, // Toward infinity
215         Zero // Toward zero
216     }
217 
218     /**
219      * @dev Returns the largest of two numbers.
220      */
221     function max(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a > b ? a : b;
223     }
224 
225     /**
226      * @dev Returns the smallest of two numbers.
227      */
228     function min(uint256 a, uint256 b) internal pure returns (uint256) {
229         return a < b ? a : b;
230     }
231 
232     /**
233      * @dev Returns the average of two numbers. The result is rounded towards
234      * zero.
235      */
236     function average(uint256 a, uint256 b) internal pure returns (uint256) {
237         // (a + b) / 2 can overflow.
238         return (a & b) + (a ^ b) / 2;
239     }
240 
241     /**
242      * @dev Returns the ceiling of the division of two numbers.
243      *
244      * This differs from standard division with `/` in that it rounds up instead
245      * of rounding down.
246      */
247     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
248         // (a + b - 1) / b can overflow on addition, so we distribute.
249         return a == 0 ? 0 : (a - 1) / b + 1;
250     }
251 
252     /**
253      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
254      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
255      * with further edits by Uniswap Labs also under MIT license.
256      */
257     function mulDiv(
258         uint256 x,
259         uint256 y,
260         uint256 denominator
261     ) internal pure returns (uint256 result) {
262         unchecked {
263             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
264             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
265             // variables such that product = prod1 * 2^256 + prod0.
266             uint256 prod0; // Least significant 256 bits of the product
267             uint256 prod1; // Most significant 256 bits of the product
268             assembly {
269                 let mm := mulmod(x, y, not(0))
270                 prod0 := mul(x, y)
271                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
272             }
273 
274             // Handle non-overflow cases, 256 by 256 division.
275             if (prod1 == 0) {
276                 return prod0 / denominator;
277             }
278 
279             // Make sure the result is less than 2^256. Also prevents denominator == 0.
280             require(denominator > prod1);
281 
282             ///////////////////////////////////////////////
283             // 512 by 256 division.
284             ///////////////////////////////////////////////
285 
286             // Make division exact by subtracting the remainder from [prod1 prod0].
287             uint256 remainder;
288             assembly {
289                 // Compute remainder using mulmod.
290                 remainder := mulmod(x, y, denominator)
291 
292                 // Subtract 256 bit number from 512 bit number.
293                 prod1 := sub(prod1, gt(remainder, prod0))
294                 prod0 := sub(prod0, remainder)
295             }
296 
297             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
298             // See https://cs.stackexchange.com/q/138556/92363.
299 
300             // Does not overflow because the denominator cannot be zero at this stage in the function.
301             uint256 twos = denominator & (~denominator + 1);
302             assembly {
303                 // Divide denominator by twos.
304                 denominator := div(denominator, twos)
305 
306                 // Divide [prod1 prod0] by twos.
307                 prod0 := div(prod0, twos)
308 
309                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
310                 twos := add(div(sub(0, twos), twos), 1)
311             }
312 
313             // Shift in bits from prod1 into prod0.
314             prod0 |= prod1 * twos;
315 
316             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
317             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
318             // four bits. That is, denominator * inv = 1 mod 2^4.
319             uint256 inverse = (3 * denominator) ^ 2;
320 
321             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
322             // in modular arithmetic, doubling the correct bits in each step.
323             inverse *= 2 - denominator * inverse; // inverse mod 2^8
324             inverse *= 2 - denominator * inverse; // inverse mod 2^16
325             inverse *= 2 - denominator * inverse; // inverse mod 2^32
326             inverse *= 2 - denominator * inverse; // inverse mod 2^64
327             inverse *= 2 - denominator * inverse; // inverse mod 2^128
328             inverse *= 2 - denominator * inverse; // inverse mod 2^256
329 
330             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
331             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
332             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
333             // is no longer required.
334             result = prod0 * inverse;
335             return result;
336         }
337     }
338 
339     /**
340      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
341      */
342     function mulDiv(
343         uint256 x,
344         uint256 y,
345         uint256 denominator,
346         Rounding rounding
347     ) internal pure returns (uint256) {
348         uint256 result = mulDiv(x, y, denominator);
349         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
350             result += 1;
351         }
352         return result;
353     }
354 
355     /**
356      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
357      *
358      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
359      */
360     function sqrt(uint256 a) internal pure returns (uint256) {
361         if (a == 0) {
362             return 0;
363         }
364 
365         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
366         //
367         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
368         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
369         //
370         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
371         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
372         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
373         //
374         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
375         uint256 result = 1 << (log2(a) >> 1);
376 
377         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
378         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
379         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
380         // into the expected uint128 result.
381         unchecked {
382             result = (result + a / result) >> 1;
383             result = (result + a / result) >> 1;
384             result = (result + a / result) >> 1;
385             result = (result + a / result) >> 1;
386             result = (result + a / result) >> 1;
387             result = (result + a / result) >> 1;
388             result = (result + a / result) >> 1;
389             return min(result, a / result);
390         }
391     }
392 
393     /**
394      * @notice Calculates sqrt(a), following the selected rounding direction.
395      */
396     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
397         unchecked {
398             uint256 result = sqrt(a);
399             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
400         }
401     }
402 
403     /**
404      * @dev Return the log in base 2, rounded down, of a positive value.
405      * Returns 0 if given 0.
406      */
407     function log2(uint256 value) internal pure returns (uint256) {
408         uint256 result = 0;
409         unchecked {
410             if (value >> 128 > 0) {
411                 value >>= 128;
412                 result += 128;
413             }
414             if (value >> 64 > 0) {
415                 value >>= 64;
416                 result += 64;
417             }
418             if (value >> 32 > 0) {
419                 value >>= 32;
420                 result += 32;
421             }
422             if (value >> 16 > 0) {
423                 value >>= 16;
424                 result += 16;
425             }
426             if (value >> 8 > 0) {
427                 value >>= 8;
428                 result += 8;
429             }
430             if (value >> 4 > 0) {
431                 value >>= 4;
432                 result += 4;
433             }
434             if (value >> 2 > 0) {
435                 value >>= 2;
436                 result += 2;
437             }
438             if (value >> 1 > 0) {
439                 result += 1;
440             }
441         }
442         return result;
443     }
444 
445     /**
446      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
447      * Returns 0 if given 0.
448      */
449     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
450         unchecked {
451             uint256 result = log2(value);
452             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
453         }
454     }
455 
456     /**
457      * @dev Return the log in base 10, rounded down, of a positive value.
458      * Returns 0 if given 0.
459      */
460     function log10(uint256 value) internal pure returns (uint256) {
461         uint256 result = 0;
462         unchecked {
463             if (value >= 10**64) {
464                 value /= 10**64;
465                 result += 64;
466             }
467             if (value >= 10**32) {
468                 value /= 10**32;
469                 result += 32;
470             }
471             if (value >= 10**16) {
472                 value /= 10**16;
473                 result += 16;
474             }
475             if (value >= 10**8) {
476                 value /= 10**8;
477                 result += 8;
478             }
479             if (value >= 10**4) {
480                 value /= 10**4;
481                 result += 4;
482             }
483             if (value >= 10**2) {
484                 value /= 10**2;
485                 result += 2;
486             }
487             if (value >= 10**1) {
488                 result += 1;
489             }
490         }
491         return result;
492     }
493 
494     /**
495      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
496      * Returns 0 if given 0.
497      */
498     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
499         unchecked {
500             uint256 result = log10(value);
501             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
502         }
503     }
504 
505     /**
506      * @dev Return the log in base 256, rounded down, of a positive value.
507      * Returns 0 if given 0.
508      *
509      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
510      */
511     function log256(uint256 value) internal pure returns (uint256) {
512         uint256 result = 0;
513         unchecked {
514             if (value >> 128 > 0) {
515                 value >>= 128;
516                 result += 16;
517             }
518             if (value >> 64 > 0) {
519                 value >>= 64;
520                 result += 8;
521             }
522             if (value >> 32 > 0) {
523                 value >>= 32;
524                 result += 4;
525             }
526             if (value >> 16 > 0) {
527                 value >>= 16;
528                 result += 2;
529             }
530             if (value >> 8 > 0) {
531                 result += 1;
532             }
533         }
534         return result;
535     }
536 
537     /**
538      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
539      * Returns 0 if given 0.
540      */
541     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
542         unchecked {
543             uint256 result = log256(value);
544             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
545         }
546     }
547 }
548 
549 // File: @openzeppelin/contracts/utils/Strings.sol
550 
551 
552 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
553 
554 pragma solidity ^0.8.0;
555 
556 
557 /**
558  * @dev String operations.
559  */
560 library Strings {
561     bytes16 private constant _SYMBOLS = "0123456789abcdef";
562     uint8 private constant _ADDRESS_LENGTH = 20;
563 
564     /**
565      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
566      */
567     function toString(uint256 value) internal pure returns (string memory) {
568         unchecked {
569             uint256 length = Math.log10(value) + 1;
570             string memory buffer = new string(length);
571             uint256 ptr;
572             /// @solidity memory-safe-assembly
573             assembly {
574                 ptr := add(buffer, add(32, length))
575             }
576             while (true) {
577                 ptr--;
578                 /// @solidity memory-safe-assembly
579                 assembly {
580                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
581                 }
582                 value /= 10;
583                 if (value == 0) break;
584             }
585             return buffer;
586         }
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
591      */
592     function toHexString(uint256 value) internal pure returns (string memory) {
593         unchecked {
594             return toHexString(value, Math.log256(value) + 1);
595         }
596     }
597 
598     /**
599      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
600      */
601     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
602         bytes memory buffer = new bytes(2 * length + 2);
603         buffer[0] = "0";
604         buffer[1] = "x";
605         for (uint256 i = 2 * length + 1; i > 1; --i) {
606             buffer[i] = _SYMBOLS[value & 0xf];
607             value >>= 4;
608         }
609         require(value == 0, "Strings: hex length insufficient");
610         return string(buffer);
611     }
612 
613     /**
614      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
615      */
616     function toHexString(address addr) internal pure returns (string memory) {
617         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
618     }
619 }
620 
621 // File: erc721a/contracts/IERC721A.sol
622 
623 
624 // ERC721A Contracts v4.2.3
625 // Creator: Chiru Labs
626 
627 pragma solidity ^0.8.4;
628 
629 /**
630  * @dev Interface of ERC721A.
631  */
632 interface IERC721A {
633     /**
634      * The caller must own the token or be an approved operator.
635      */
636     error ApprovalCallerNotOwnerNorApproved();
637 
638     /**
639      * The token does not exist.
640      */
641     error ApprovalQueryForNonexistentToken();
642 
643     /**
644      * Cannot query the balance for the zero address.
645      */
646     error BalanceQueryForZeroAddress();
647 
648     /**
649      * Cannot mint to the zero address.
650      */
651     error MintToZeroAddress();
652 
653     /**
654      * The quantity of tokens minted must be more than zero.
655      */
656     error MintZeroQuantity();
657 
658     /**
659      * The token does not exist.
660      */
661     error OwnerQueryForNonexistentToken();
662 
663     /**
664      * The caller must own the token or be an approved operator.
665      */
666     error TransferCallerNotOwnerNorApproved();
667 
668     /**
669      * The token must be owned by `from`.
670      */
671     error TransferFromIncorrectOwner();
672 
673     /**
674      * Cannot safely transfer to a contract that does not implement the
675      * ERC721Receiver interface.
676      */
677     error TransferToNonERC721ReceiverImplementer();
678 
679     /**
680      * Cannot transfer to the zero address.
681      */
682     error TransferToZeroAddress();
683 
684     /**
685      * The token does not exist.
686      */
687     error URIQueryForNonexistentToken();
688 
689     /**
690      * The `quantity` minted with ERC2309 exceeds the safety limit.
691      */
692     error MintERC2309QuantityExceedsLimit();
693 
694     /**
695      * The `extraData` cannot be set on an unintialized ownership slot.
696      */
697     error OwnershipNotInitializedForExtraData();
698 
699     // =============================================================
700     //                            STRUCTS
701     // =============================================================
702 
703     struct TokenOwnership {
704         // The address of the owner.
705         address addr;
706         // Stores the start time of ownership with minimal overhead for tokenomics.
707         uint64 startTimestamp;
708         // Whether the token has been burned.
709         bool burned;
710         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
711         uint24 extraData;
712     }
713 
714     // =============================================================
715     //                         TOKEN COUNTERS
716     // =============================================================
717 
718     /**
719      * @dev Returns the total number of tokens in existence.
720      * Burned tokens will reduce the count.
721      * To get the total number of tokens minted, please see {_totalMinted}.
722      */
723     function totalSupply() external view returns (uint256);
724 
725     // =============================================================
726     //                            IERC165
727     // =============================================================
728 
729     /**
730      * @dev Returns true if this contract implements the interface defined by
731      * `interfaceId`. See the corresponding
732      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
733      * to learn more about how these ids are created.
734      *
735      * This function call must use less than 30000 gas.
736      */
737     function supportsInterface(bytes4 interfaceId) external view returns (bool);
738 
739     // =============================================================
740     //                            IERC721
741     // =============================================================
742 
743     /**
744      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
745      */
746     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
747 
748     /**
749      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
750      */
751     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
752 
753     /**
754      * @dev Emitted when `owner` enables or disables
755      * (`approved`) `operator` to manage all of its assets.
756      */
757     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
758 
759     /**
760      * @dev Returns the number of tokens in `owner`'s account.
761      */
762     function balanceOf(address owner) external view returns (uint256 balance);
763 
764     /**
765      * @dev Returns the owner of the `tokenId` token.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function ownerOf(uint256 tokenId) external view returns (address owner);
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`,
775      * checking first that contract recipients are aware of the ERC721 protocol
776      * to prevent tokens from being forever locked.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If the caller is not `from`, it must be have been allowed to move
784      * this token by either {approve} or {setApprovalForAll}.
785      * - If `to` refers to a smart contract, it must implement
786      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes calldata data
795     ) external payable;
796 
797     /**
798      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external payable;
805 
806     /**
807      * @dev Transfers `tokenId` from `from` to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
810      * whenever possible.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token
818      * by either {approve} or {setApprovalForAll}.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external payable;
827 
828     /**
829      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
830      * The approval is cleared when the token is transferred.
831      *
832      * Only a single account can be approved at a time, so approving the
833      * zero address clears previous approvals.
834      *
835      * Requirements:
836      *
837      * - The caller must own the token or be an approved operator.
838      * - `tokenId` must exist.
839      *
840      * Emits an {Approval} event.
841      */
842     function approve(address to, uint256 tokenId) external payable;
843 
844     /**
845      * @dev Approve or remove `operator` as an operator for the caller.
846      * Operators can call {transferFrom} or {safeTransferFrom}
847      * for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool _approved) external;
856 
857     /**
858      * @dev Returns the account approved for `tokenId` token.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function getApproved(uint256 tokenId) external view returns (address operator);
865 
866     /**
867      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
868      *
869      * See {setApprovalForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) external view returns (bool);
872 
873     // =============================================================
874     //                        IERC721Metadata
875     // =============================================================
876 
877     /**
878      * @dev Returns the token collection name.
879      */
880     function name() external view returns (string memory);
881 
882     /**
883      * @dev Returns the token collection symbol.
884      */
885     function symbol() external view returns (string memory);
886 
887     /**
888      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
889      */
890     function tokenURI(uint256 tokenId) external view returns (string memory);
891 
892     // =============================================================
893     //                           IERC2309
894     // =============================================================
895 
896     /**
897      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
898      * (inclusive) is transferred from `from` to `to`, as defined in the
899      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
900      *
901      * See {_mintERC2309} for more details.
902      */
903     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
904 }
905 
906 // File: erc721a/contracts/ERC721A.sol
907 
908 
909 // ERC721A Contracts v4.2.3
910 // Creator: Chiru Labs
911 
912 pragma solidity ^0.8.4;
913 
914 
915 /**
916  * @dev Interface of ERC721 token receiver.
917  */
918 interface ERC721A__IERC721Receiver {
919     function onERC721Received(
920         address operator,
921         address from,
922         uint256 tokenId,
923         bytes calldata data
924     ) external returns (bytes4);
925 }
926 
927 /**
928  * @title ERC721A
929  *
930  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
931  * Non-Fungible Token Standard, including the Metadata extension.
932  * Optimized for lower gas during batch mints.
933  *
934  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
935  * starting from `_startTokenId()`.
936  *
937  * Assumptions:
938  *
939  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
940  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
941  */
942 contract ERC721A is IERC721A {
943     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
944     struct TokenApprovalRef {
945         address value;
946     }
947 
948     // =============================================================
949     //                           CONSTANTS
950     // =============================================================
951 
952     // Mask of an entry in packed address data.
953     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
954 
955     // The bit position of `numberMinted` in packed address data.
956     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
957 
958     // The bit position of `numberBurned` in packed address data.
959     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
960 
961     // The bit position of `aux` in packed address data.
962     uint256 private constant _BITPOS_AUX = 192;
963 
964     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
965     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
966 
967     // The bit position of `startTimestamp` in packed ownership.
968     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
969 
970     // The bit mask of the `burned` bit in packed ownership.
971     uint256 private constant _BITMASK_BURNED = 1 << 224;
972 
973     // The bit position of the `nextInitialized` bit in packed ownership.
974     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
975 
976     // The bit mask of the `nextInitialized` bit in packed ownership.
977     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
978 
979     // The bit position of `extraData` in packed ownership.
980     uint256 private constant _BITPOS_EXTRA_DATA = 232;
981 
982     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
983     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
984 
985     // The mask of the lower 160 bits for addresses.
986     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
987 
988     // The maximum `quantity` that can be minted with {_mintERC2309}.
989     // This limit is to prevent overflows on the address data entries.
990     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
991     // is required to cause an overflow, which is unrealistic.
992     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
993 
994     // The `Transfer` event signature is given by:
995     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
996     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
997         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
998 
999     // =============================================================
1000     //                            STORAGE
1001     // =============================================================
1002 
1003     // The next token ID to be minted.
1004     uint256 private _currentIndex;
1005 
1006     // The number of tokens burned.
1007     uint256 private _burnCounter;
1008 
1009     // Token name
1010     string private _name;
1011 
1012     // Token symbol
1013     string private _symbol;
1014 
1015     // Mapping from token ID to ownership details
1016     // An empty struct value does not necessarily mean the token is unowned.
1017     // See {_packedOwnershipOf} implementation for details.
1018     //
1019     // Bits Layout:
1020     // - [0..159]   `addr`
1021     // - [160..223] `startTimestamp`
1022     // - [224]      `burned`
1023     // - [225]      `nextInitialized`
1024     // - [232..255] `extraData`
1025     mapping(uint256 => uint256) private _packedOwnerships;
1026 
1027     // Mapping owner address to address data.
1028     //
1029     // Bits Layout:
1030     // - [0..63]    `balance`
1031     // - [64..127]  `numberMinted`
1032     // - [128..191] `numberBurned`
1033     // - [192..255] `aux`
1034     mapping(address => uint256) private _packedAddressData;
1035 
1036     // Mapping from token ID to approved address.
1037     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1038 
1039     // Mapping from owner to operator approvals
1040     mapping(address => mapping(address => bool)) private _operatorApprovals;
1041 
1042     // =============================================================
1043     //                          CONSTRUCTOR
1044     // =============================================================
1045 
1046     constructor(string memory name_, string memory symbol_) {
1047         _name = name_;
1048         _symbol = symbol_;
1049         _currentIndex = _startTokenId();
1050     }
1051 
1052     // =============================================================
1053     //                   TOKEN COUNTING OPERATIONS
1054     // =============================================================
1055 
1056     /**
1057      * @dev Returns the starting token ID.
1058      * To change the starting token ID, please override this function.
1059      */
1060     function _startTokenId() internal view virtual returns (uint256) {
1061         return 0;
1062     }
1063 
1064     /**
1065      * @dev Returns the next token ID to be minted.
1066      */
1067     function _nextTokenId() internal view virtual returns (uint256) {
1068         return _currentIndex;
1069     }
1070 
1071     /**
1072      * @dev Returns the total number of tokens in existence.
1073      * Burned tokens will reduce the count.
1074      * To get the total number of tokens minted, please see {_totalMinted}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         // Counter underflow is impossible as _burnCounter cannot be incremented
1078         // more than `_currentIndex - _startTokenId()` times.
1079         unchecked {
1080             return _currentIndex - _burnCounter - _startTokenId();
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the total amount of tokens minted in the contract.
1086      */
1087     function _totalMinted() internal view virtual returns (uint256) {
1088         // Counter underflow is impossible as `_currentIndex` does not decrement,
1089         // and it is initialized to `_startTokenId()`.
1090         unchecked {
1091             return _currentIndex - _startTokenId();
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns the total number of tokens burned.
1097      */
1098     function _totalBurned() internal view virtual returns (uint256) {
1099         return _burnCounter;
1100     }
1101 
1102     // =============================================================
1103     //                    ADDRESS DATA OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Returns the number of tokens in `owner`'s account.
1108      */
1109     function balanceOf(address owner) public view virtual override returns (uint256) {
1110         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1111         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1112     }
1113 
1114     /**
1115      * Returns the number of tokens minted by `owner`.
1116      */
1117     function _numberMinted(address owner) internal view returns (uint256) {
1118         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1119     }
1120 
1121     /**
1122      * Returns the number of tokens burned by or on behalf of `owner`.
1123      */
1124     function _numberBurned(address owner) internal view returns (uint256) {
1125         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1126     }
1127 
1128     /**
1129      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1130      */
1131     function _getAux(address owner) internal view returns (uint64) {
1132         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1133     }
1134 
1135     /**
1136      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1137      * If there are multiple variables, please pack them into a uint64.
1138      */
1139     function _setAux(address owner, uint64 aux) internal virtual {
1140         uint256 packed = _packedAddressData[owner];
1141         uint256 auxCasted;
1142         // Cast `aux` with assembly to avoid redundant masking.
1143         assembly {
1144             auxCasted := aux
1145         }
1146         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1147         _packedAddressData[owner] = packed;
1148     }
1149 
1150     // =============================================================
1151     //                            IERC165
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns true if this contract implements the interface defined by
1156      * `interfaceId`. See the corresponding
1157      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1158      * to learn more about how these ids are created.
1159      *
1160      * This function call must use less than 30000 gas.
1161      */
1162     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1163         // The interface IDs are constants representing the first 4 bytes
1164         // of the XOR of all function selectors in the interface.
1165         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1166         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1167         return
1168             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1169             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1170             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1171     }
1172 
1173     // =============================================================
1174     //                        IERC721Metadata
1175     // =============================================================
1176 
1177     /**
1178      * @dev Returns the token collection name.
1179      */
1180     function name() public view virtual override returns (string memory) {
1181         return _name;
1182     }
1183 
1184     /**
1185      * @dev Returns the token collection symbol.
1186      */
1187     function symbol() public view virtual override returns (string memory) {
1188         return _symbol;
1189     }
1190 
1191     /**
1192      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1193      */
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1196 
1197         string memory baseURI = _baseURI();
1198         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1199     }
1200 
1201     /**
1202      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1204      * by default, it can be overridden in child contracts.
1205      */
1206     function _baseURI() internal view virtual returns (string memory) {
1207         return '';
1208     }
1209 
1210     // =============================================================
1211     //                     OWNERSHIPS OPERATIONS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Returns the owner of the `tokenId` token.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      */
1221     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1222         return address(uint160(_packedOwnershipOf(tokenId)));
1223     }
1224 
1225     /**
1226      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1227      * It gradually moves to O(1) as tokens get transferred around over time.
1228      */
1229     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1230         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1231     }
1232 
1233     /**
1234      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1235      */
1236     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1237         return _unpackedOwnership(_packedOwnerships[index]);
1238     }
1239 
1240     /**
1241      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1242      */
1243     function _initializeOwnershipAt(uint256 index) internal virtual {
1244         if (_packedOwnerships[index] == 0) {
1245             _packedOwnerships[index] = _packedOwnershipOf(index);
1246         }
1247     }
1248 
1249     /**
1250      * Returns the packed ownership data of `tokenId`.
1251      */
1252     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1253         uint256 curr = tokenId;
1254 
1255         unchecked {
1256             if (_startTokenId() <= curr)
1257                 if (curr < _currentIndex) {
1258                     uint256 packed = _packedOwnerships[curr];
1259                     // If not burned.
1260                     if (packed & _BITMASK_BURNED == 0) {
1261                         // Invariant:
1262                         // There will always be an initialized ownership slot
1263                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1264                         // before an unintialized ownership slot
1265                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1266                         // Hence, `curr` will not underflow.
1267                         //
1268                         // We can directly compare the packed value.
1269                         // If the address is zero, packed will be zero.
1270                         while (packed == 0) {
1271                             packed = _packedOwnerships[--curr];
1272                         }
1273                         return packed;
1274                     }
1275                 }
1276         }
1277         revert OwnerQueryForNonexistentToken();
1278     }
1279 
1280     /**
1281      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1282      */
1283     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1284         ownership.addr = address(uint160(packed));
1285         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1286         ownership.burned = packed & _BITMASK_BURNED != 0;
1287         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1288     }
1289 
1290     /**
1291      * @dev Packs ownership data into a single uint256.
1292      */
1293     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1294         assembly {
1295             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1296             owner := and(owner, _BITMASK_ADDRESS)
1297             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1298             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1304      */
1305     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1306         // For branchless setting of the `nextInitialized` flag.
1307         assembly {
1308             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1309             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1310         }
1311     }
1312 
1313     // =============================================================
1314     //                      APPROVAL OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1319      * The approval is cleared when the token is transferred.
1320      *
1321      * Only a single account can be approved at a time, so approving the
1322      * zero address clears previous approvals.
1323      *
1324      * Requirements:
1325      *
1326      * - The caller must own the token or be an approved operator.
1327      * - `tokenId` must exist.
1328      *
1329      * Emits an {Approval} event.
1330      */
1331     function approve(address to, uint256 tokenId) public payable virtual override {
1332         address owner = ownerOf(tokenId);
1333 
1334         if (_msgSenderERC721A() != owner)
1335             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1336                 revert ApprovalCallerNotOwnerNorApproved();
1337             }
1338 
1339         _tokenApprovals[tokenId].value = to;
1340         emit Approval(owner, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Returns the account approved for `tokenId` token.
1345      *
1346      * Requirements:
1347      *
1348      * - `tokenId` must exist.
1349      */
1350     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1351         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1352 
1353         return _tokenApprovals[tokenId].value;
1354     }
1355 
1356     /**
1357      * @dev Approve or remove `operator` as an operator for the caller.
1358      * Operators can call {transferFrom} or {safeTransferFrom}
1359      * for any token owned by the caller.
1360      *
1361      * Requirements:
1362      *
1363      * - The `operator` cannot be the caller.
1364      *
1365      * Emits an {ApprovalForAll} event.
1366      */
1367     function setApprovalForAll(address operator, bool approved) public virtual override {
1368         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1369         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1370     }
1371 
1372     /**
1373      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1374      *
1375      * See {setApprovalForAll}.
1376      */
1377     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1378         return _operatorApprovals[owner][operator];
1379     }
1380 
1381     /**
1382      * @dev Returns whether `tokenId` exists.
1383      *
1384      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1385      *
1386      * Tokens start existing when they are minted. See {_mint}.
1387      */
1388     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1389         return
1390             _startTokenId() <= tokenId &&
1391             tokenId < _currentIndex && // If within bounds,
1392             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1393     }
1394 
1395     /**
1396      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1397      */
1398     function _isSenderApprovedOrOwner(
1399         address approvedAddress,
1400         address owner,
1401         address msgSender
1402     ) private pure returns (bool result) {
1403         assembly {
1404             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1405             owner := and(owner, _BITMASK_ADDRESS)
1406             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1407             msgSender := and(msgSender, _BITMASK_ADDRESS)
1408             // `msgSender == owner || msgSender == approvedAddress`.
1409             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1410         }
1411     }
1412 
1413     /**
1414      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1415      */
1416     function _getApprovedSlotAndAddress(uint256 tokenId)
1417         private
1418         view
1419         returns (uint256 approvedAddressSlot, address approvedAddress)
1420     {
1421         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1422         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1423         assembly {
1424             approvedAddressSlot := tokenApproval.slot
1425             approvedAddress := sload(approvedAddressSlot)
1426         }
1427     }
1428 
1429     // =============================================================
1430     //                      TRANSFER OPERATIONS
1431     // =============================================================
1432 
1433     /**
1434      * @dev Transfers `tokenId` from `from` to `to`.
1435      *
1436      * Requirements:
1437      *
1438      * - `from` cannot be the zero address.
1439      * - `to` cannot be the zero address.
1440      * - `tokenId` token must be owned by `from`.
1441      * - If the caller is not `from`, it must be approved to move this token
1442      * by either {approve} or {setApprovalForAll}.
1443      *
1444      * Emits a {Transfer} event.
1445      */
1446     function transferFrom(
1447         address from,
1448         address to,
1449         uint256 tokenId
1450     ) public payable virtual override {
1451         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1452 
1453         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1454 
1455         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1456 
1457         // The nested ifs save around 20+ gas over a compound boolean condition.
1458         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1459             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1460 
1461         if (to == address(0)) revert TransferToZeroAddress();
1462 
1463         _beforeTokenTransfers(from, to, tokenId, 1);
1464 
1465         // Clear approvals from the previous owner.
1466         assembly {
1467             if approvedAddress {
1468                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1469                 sstore(approvedAddressSlot, 0)
1470             }
1471         }
1472 
1473         // Underflow of the sender's balance is impossible because we check for
1474         // ownership above and the recipient's balance can't realistically overflow.
1475         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1476         unchecked {
1477             // We can directly increment and decrement the balances.
1478             --_packedAddressData[from]; // Updates: `balance -= 1`.
1479             ++_packedAddressData[to]; // Updates: `balance += 1`.
1480 
1481             // Updates:
1482             // - `address` to the next owner.
1483             // - `startTimestamp` to the timestamp of transfering.
1484             // - `burned` to `false`.
1485             // - `nextInitialized` to `true`.
1486             _packedOwnerships[tokenId] = _packOwnershipData(
1487                 to,
1488                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1489             );
1490 
1491             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1492             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1493                 uint256 nextTokenId = tokenId + 1;
1494                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1495                 if (_packedOwnerships[nextTokenId] == 0) {
1496                     // If the next slot is within bounds.
1497                     if (nextTokenId != _currentIndex) {
1498                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1499                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1500                     }
1501                 }
1502             }
1503         }
1504 
1505         emit Transfer(from, to, tokenId);
1506         _afterTokenTransfers(from, to, tokenId, 1);
1507     }
1508 
1509     /**
1510      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1511      */
1512     function safeTransferFrom(
1513         address from,
1514         address to,
1515         uint256 tokenId
1516     ) public payable virtual override {
1517         safeTransferFrom(from, to, tokenId, '');
1518     }
1519 
1520     /**
1521      * @dev Safely transfers `tokenId` token from `from` to `to`.
1522      *
1523      * Requirements:
1524      *
1525      * - `from` cannot be the zero address.
1526      * - `to` cannot be the zero address.
1527      * - `tokenId` token must exist and be owned by `from`.
1528      * - If the caller is not `from`, it must be approved to move this token
1529      * by either {approve} or {setApprovalForAll}.
1530      * - If `to` refers to a smart contract, it must implement
1531      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1532      *
1533      * Emits a {Transfer} event.
1534      */
1535     function safeTransferFrom(
1536         address from,
1537         address to,
1538         uint256 tokenId,
1539         bytes memory _data
1540     ) public payable virtual override {
1541         transferFrom(from, to, tokenId);
1542         if (to.code.length != 0)
1543             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1544                 revert TransferToNonERC721ReceiverImplementer();
1545             }
1546     }
1547 
1548     /**
1549      * @dev Hook that is called before a set of serially-ordered token IDs
1550      * are about to be transferred. This includes minting.
1551      * And also called before burning one token.
1552      *
1553      * `startTokenId` - the first token ID to be transferred.
1554      * `quantity` - the amount to be transferred.
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` will be minted for `to`.
1561      * - When `to` is zero, `tokenId` will be burned by `from`.
1562      * - `from` and `to` are never both zero.
1563      */
1564     function _beforeTokenTransfers(
1565         address from,
1566         address to,
1567         uint256 startTokenId,
1568         uint256 quantity
1569     ) internal virtual {}
1570 
1571     /**
1572      * @dev Hook that is called after a set of serially-ordered token IDs
1573      * have been transferred. This includes minting.
1574      * And also called after one token has been burned.
1575      *
1576      * `startTokenId` - the first token ID to be transferred.
1577      * `quantity` - the amount to be transferred.
1578      *
1579      * Calling conditions:
1580      *
1581      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1582      * transferred to `to`.
1583      * - When `from` is zero, `tokenId` has been minted for `to`.
1584      * - When `to` is zero, `tokenId` has been burned by `from`.
1585      * - `from` and `to` are never both zero.
1586      */
1587     function _afterTokenTransfers(
1588         address from,
1589         address to,
1590         uint256 startTokenId,
1591         uint256 quantity
1592     ) internal virtual {}
1593 
1594     /**
1595      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1596      *
1597      * `from` - Previous owner of the given token ID.
1598      * `to` - Target address that will receive the token.
1599      * `tokenId` - Token ID to be transferred.
1600      * `_data` - Optional data to send along with the call.
1601      *
1602      * Returns whether the call correctly returned the expected magic value.
1603      */
1604     function _checkContractOnERC721Received(
1605         address from,
1606         address to,
1607         uint256 tokenId,
1608         bytes memory _data
1609     ) private returns (bool) {
1610         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1611             bytes4 retval
1612         ) {
1613             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1614         } catch (bytes memory reason) {
1615             if (reason.length == 0) {
1616                 revert TransferToNonERC721ReceiverImplementer();
1617             } else {
1618                 assembly {
1619                     revert(add(32, reason), mload(reason))
1620                 }
1621             }
1622         }
1623     }
1624 
1625     // =============================================================
1626     //                        MINT OPERATIONS
1627     // =============================================================
1628 
1629     /**
1630      * @dev Mints `quantity` tokens and transfers them to `to`.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `quantity` must be greater than 0.
1636      *
1637      * Emits a {Transfer} event for each mint.
1638      */
1639     function _mint(address to, uint256 quantity) internal virtual {
1640         uint256 startTokenId = _currentIndex;
1641         if (quantity == 0) revert MintZeroQuantity();
1642 
1643         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1644 
1645         // Overflows are incredibly unrealistic.
1646         // `balance` and `numberMinted` have a maximum limit of 2**64.
1647         // `tokenId` has a maximum limit of 2**256.
1648         unchecked {
1649             // Updates:
1650             // - `balance += quantity`.
1651             // - `numberMinted += quantity`.
1652             //
1653             // We can directly add to the `balance` and `numberMinted`.
1654             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1655 
1656             // Updates:
1657             // - `address` to the owner.
1658             // - `startTimestamp` to the timestamp of minting.
1659             // - `burned` to `false`.
1660             // - `nextInitialized` to `quantity == 1`.
1661             _packedOwnerships[startTokenId] = _packOwnershipData(
1662                 to,
1663                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1664             );
1665 
1666             uint256 toMasked;
1667             uint256 end = startTokenId + quantity;
1668 
1669             // Use assembly to loop and emit the `Transfer` event for gas savings.
1670             // The duplicated `log4` removes an extra check and reduces stack juggling.
1671             // The assembly, together with the surrounding Solidity code, have been
1672             // delicately arranged to nudge the compiler into producing optimized opcodes.
1673             assembly {
1674                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1675                 toMasked := and(to, _BITMASK_ADDRESS)
1676                 // Emit the `Transfer` event.
1677                 log4(
1678                     0, // Start of data (0, since no data).
1679                     0, // End of data (0, since no data).
1680                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1681                     0, // `address(0)`.
1682                     toMasked, // `to`.
1683                     startTokenId // `tokenId`.
1684                 )
1685 
1686                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1687                 // that overflows uint256 will make the loop run out of gas.
1688                 // The compiler will optimize the `iszero` away for performance.
1689                 for {
1690                     let tokenId := add(startTokenId, 1)
1691                 } iszero(eq(tokenId, end)) {
1692                     tokenId := add(tokenId, 1)
1693                 } {
1694                     // Emit the `Transfer` event. Similar to above.
1695                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1696                 }
1697             }
1698             if (toMasked == 0) revert MintToZeroAddress();
1699 
1700             _currentIndex = end;
1701         }
1702         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1703     }
1704 
1705     /**
1706      * @dev Mints `quantity` tokens and transfers them to `to`.
1707      *
1708      * This function is intended for efficient minting only during contract creation.
1709      *
1710      * It emits only one {ConsecutiveTransfer} as defined in
1711      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1712      * instead of a sequence of {Transfer} event(s).
1713      *
1714      * Calling this function outside of contract creation WILL make your contract
1715      * non-compliant with the ERC721 standard.
1716      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1717      * {ConsecutiveTransfer} event is only permissible during contract creation.
1718      *
1719      * Requirements:
1720      *
1721      * - `to` cannot be the zero address.
1722      * - `quantity` must be greater than 0.
1723      *
1724      * Emits a {ConsecutiveTransfer} event.
1725      */
1726     function _mintERC2309(address to, uint256 quantity) internal virtual {
1727         uint256 startTokenId = _currentIndex;
1728         if (to == address(0)) revert MintToZeroAddress();
1729         if (quantity == 0) revert MintZeroQuantity();
1730         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1731 
1732         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1733 
1734         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1735         unchecked {
1736             // Updates:
1737             // - `balance += quantity`.
1738             // - `numberMinted += quantity`.
1739             //
1740             // We can directly add to the `balance` and `numberMinted`.
1741             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1742 
1743             // Updates:
1744             // - `address` to the owner.
1745             // - `startTimestamp` to the timestamp of minting.
1746             // - `burned` to `false`.
1747             // - `nextInitialized` to `quantity == 1`.
1748             _packedOwnerships[startTokenId] = _packOwnershipData(
1749                 to,
1750                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1751             );
1752 
1753             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1754 
1755             _currentIndex = startTokenId + quantity;
1756         }
1757         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1758     }
1759 
1760     /**
1761      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1762      *
1763      * Requirements:
1764      *
1765      * - If `to` refers to a smart contract, it must implement
1766      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1767      * - `quantity` must be greater than 0.
1768      *
1769      * See {_mint}.
1770      *
1771      * Emits a {Transfer} event for each mint.
1772      */
1773     function _safeMint(
1774         address to,
1775         uint256 quantity,
1776         bytes memory _data
1777     ) internal virtual {
1778         _mint(to, quantity);
1779 
1780         unchecked {
1781             if (to.code.length != 0) {
1782                 uint256 end = _currentIndex;
1783                 uint256 index = end - quantity;
1784                 do {
1785                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1786                         revert TransferToNonERC721ReceiverImplementer();
1787                     }
1788                 } while (index < end);
1789                 // Reentrancy protection.
1790                 if (_currentIndex != end) revert();
1791             }
1792         }
1793     }
1794 
1795     /**
1796      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1797      */
1798     function _safeMint(address to, uint256 quantity) internal virtual {
1799         _safeMint(to, quantity, '');
1800     }
1801 
1802     // =============================================================
1803     //                        BURN OPERATIONS
1804     // =============================================================
1805 
1806     /**
1807      * @dev Equivalent to `_burn(tokenId, false)`.
1808      */
1809     function _burn(uint256 tokenId) internal virtual {
1810         _burn(tokenId, false);
1811     }
1812 
1813     /**
1814      * @dev Destroys `tokenId`.
1815      * The approval is cleared when the token is burned.
1816      *
1817      * Requirements:
1818      *
1819      * - `tokenId` must exist.
1820      *
1821      * Emits a {Transfer} event.
1822      */
1823     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1824         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1825 
1826         address from = address(uint160(prevOwnershipPacked));
1827 
1828         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1829 
1830         if (approvalCheck) {
1831             // The nested ifs save around 20+ gas over a compound boolean condition.
1832             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1833                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1834         }
1835 
1836         _beforeTokenTransfers(from, address(0), tokenId, 1);
1837 
1838         // Clear approvals from the previous owner.
1839         assembly {
1840             if approvedAddress {
1841                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1842                 sstore(approvedAddressSlot, 0)
1843             }
1844         }
1845 
1846         // Underflow of the sender's balance is impossible because we check for
1847         // ownership above and the recipient's balance can't realistically overflow.
1848         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1849         unchecked {
1850             // Updates:
1851             // - `balance -= 1`.
1852             // - `numberBurned += 1`.
1853             //
1854             // We can directly decrement the balance, and increment the number burned.
1855             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1856             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1857 
1858             // Updates:
1859             // - `address` to the last owner.
1860             // - `startTimestamp` to the timestamp of burning.
1861             // - `burned` to `true`.
1862             // - `nextInitialized` to `true`.
1863             _packedOwnerships[tokenId] = _packOwnershipData(
1864                 from,
1865                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1866             );
1867 
1868             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1869             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1870                 uint256 nextTokenId = tokenId + 1;
1871                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1872                 if (_packedOwnerships[nextTokenId] == 0) {
1873                     // If the next slot is within bounds.
1874                     if (nextTokenId != _currentIndex) {
1875                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1876                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1877                     }
1878                 }
1879             }
1880         }
1881 
1882         emit Transfer(from, address(0), tokenId);
1883         _afterTokenTransfers(from, address(0), tokenId, 1);
1884 
1885         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1886         unchecked {
1887             _burnCounter++;
1888         }
1889     }
1890 
1891     // =============================================================
1892     //                     EXTRA DATA OPERATIONS
1893     // =============================================================
1894 
1895     /**
1896      * @dev Directly sets the extra data for the ownership data `index`.
1897      */
1898     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1899         uint256 packed = _packedOwnerships[index];
1900         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1901         uint256 extraDataCasted;
1902         // Cast `extraData` with assembly to avoid redundant masking.
1903         assembly {
1904             extraDataCasted := extraData
1905         }
1906         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1907         _packedOwnerships[index] = packed;
1908     }
1909 
1910     /**
1911      * @dev Called during each token transfer to set the 24bit `extraData` field.
1912      * Intended to be overridden by the cosumer contract.
1913      *
1914      * `previousExtraData` - the value of `extraData` before transfer.
1915      *
1916      * Calling conditions:
1917      *
1918      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1919      * transferred to `to`.
1920      * - When `from` is zero, `tokenId` will be minted for `to`.
1921      * - When `to` is zero, `tokenId` will be burned by `from`.
1922      * - `from` and `to` are never both zero.
1923      */
1924     function _extraData(
1925         address from,
1926         address to,
1927         uint24 previousExtraData
1928     ) internal view virtual returns (uint24) {}
1929 
1930     /**
1931      * @dev Returns the next extra data for the packed ownership data.
1932      * The returned result is shifted into position.
1933      */
1934     function _nextExtraData(
1935         address from,
1936         address to,
1937         uint256 prevOwnershipPacked
1938     ) private view returns (uint256) {
1939         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1940         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1941     }
1942 
1943     // =============================================================
1944     //                       OTHER OPERATIONS
1945     // =============================================================
1946 
1947     /**
1948      * @dev Returns the message sender (defaults to `msg.sender`).
1949      *
1950      * If you are writing GSN compatible contracts, you need to override this function.
1951      */
1952     function _msgSenderERC721A() internal view virtual returns (address) {
1953         return msg.sender;
1954     }
1955 
1956     /**
1957      * @dev Converts a uint256 to its ASCII string decimal representation.
1958      */
1959     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1960         assembly {
1961             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1962             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1963             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1964             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1965             let m := add(mload(0x40), 0xa0)
1966             // Update the free memory pointer to allocate.
1967             mstore(0x40, m)
1968             // Assign the `str` to the end.
1969             str := sub(m, 0x20)
1970             // Zeroize the slot after the string.
1971             mstore(str, 0)
1972 
1973             // Cache the end of the memory to calculate the length later.
1974             let end := str
1975 
1976             // We write the string from rightmost digit to leftmost digit.
1977             // The following is essentially a do-while loop that also handles the zero case.
1978             // prettier-ignore
1979             for { let temp := value } 1 {} {
1980                 str := sub(str, 1)
1981                 // Write the character to the pointer.
1982                 // The ASCII index of the '0' character is 48.
1983                 mstore8(str, add(48, mod(temp, 10)))
1984                 // Keep dividing `temp` until zero.
1985                 temp := div(temp, 10)
1986                 // prettier-ignore
1987                 if iszero(temp) { break }
1988             }
1989 
1990             let length := sub(end, str)
1991             // Move the pointer 32 bytes leftwards to make room for the length.
1992             str := sub(str, 0x20)
1993             // Store the length.
1994             mstore(str, length)
1995         }
1996     }
1997 }
1998 
1999 // File: @openzeppelin/contracts/utils/Context.sol
2000 
2001 
2002 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2003 
2004 pragma solidity ^0.8.0;
2005 
2006 /**
2007  * @dev Provides information about the current execution context, including the
2008  * sender of the transaction and its data. While these are generally available
2009  * via msg.sender and msg.data, they should not be accessed in such a direct
2010  * manner, since when dealing with meta-transactions the account sending and
2011  * paying for execution may not be the actual sender (as far as an application
2012  * is concerned).
2013  *
2014  * This contract is only required for intermediate, library-like contracts.
2015  */
2016 abstract contract Context {
2017     function _msgSender() internal view virtual returns (address) {
2018         return msg.sender;
2019     }
2020 
2021     function _msgData() internal view virtual returns (bytes calldata) {
2022         return msg.data;
2023     }
2024 }
2025 
2026 // File: @openzeppelin/contracts/access/Ownable.sol
2027 
2028 
2029 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2030 
2031 pragma solidity ^0.8.0;
2032 
2033 
2034 /**
2035  * @dev Contract module which provides a basic access control mechanism, where
2036  * there is an account (an owner) that can be granted exclusive access to
2037  * specific functions.
2038  *
2039  * By default, the owner account will be the one that deploys the contract. This
2040  * can later be changed with {transferOwnership}.
2041  *
2042  * This module is used through inheritance. It will make available the modifier
2043  * `onlyOwner`, which can be applied to your functions to restrict their use to
2044  * the owner.
2045  */
2046 abstract contract Ownable is Context {
2047     address private _owner;
2048 
2049     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2050 
2051     /**
2052      * @dev Initializes the contract setting the deployer as the initial owner.
2053      */
2054     constructor() {
2055         _transferOwnership(_msgSender());
2056     }
2057 
2058     /**
2059      * @dev Throws if called by any account other than the owner.
2060      */
2061     modifier onlyOwner() {
2062         _checkOwner();
2063         _;
2064     }
2065 
2066     /**
2067      * @dev Returns the address of the current owner.
2068      */
2069     function owner() public view virtual returns (address) {
2070         return _owner;
2071     }
2072 
2073     /**
2074      * @dev Throws if the sender is not the owner.
2075      */
2076     function _checkOwner() internal view virtual {
2077         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2078     }
2079 
2080     /**
2081      * @dev Leaves the contract without owner. It will not be possible to call
2082      * `onlyOwner` functions anymore. Can only be called by the current owner.
2083      *
2084      * NOTE: Renouncing ownership will leave the contract without an owner,
2085      * thereby removing any functionality that is only available to the owner.
2086      */
2087     function renounceOwnership() public virtual onlyOwner {
2088         _transferOwnership(address(0));
2089     }
2090 
2091     /**
2092      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2093      * Can only be called by the current owner.
2094      */
2095     function transferOwnership(address newOwner) public virtual onlyOwner {
2096         require(newOwner != address(0), "Ownable: new owner is the zero address");
2097         _transferOwnership(newOwner);
2098     }
2099 
2100     /**
2101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2102      * Internal function without access restriction.
2103      */
2104     function _transferOwnership(address newOwner) internal virtual {
2105         address oldOwner = _owner;
2106         _owner = newOwner;
2107         emit OwnershipTransferred(oldOwner, newOwner);
2108     }
2109 }
2110 
2111 
2112         pragma solidity ^0.8.13;
2113 
2114 
2115 
2116 
2117 
2118 
2119         contract Nakamonkeys is ERC721A, Ownable, ReentrancyGuard  , DefaultOperatorFilterer{
2120             using Strings for uint256;
2121             uint256 public _maxSupply = 20000;
2122             uint256 public maxMintAmountPerWallet = 10;
2123             uint256 public maxMintAmountPerTx = 69;
2124             string baseURL = "";
2125             string ExtensionURL = ".json";
2126             uint256 _initalPrice = 0 ether;
2127             uint256 public costOfNFT = 0.003 ether;
2128             uint256 public numberOfFreeNFTs = 1;
2129             
2130             string HiddenURL;
2131             bool revealed = false;
2132             bool paused = true;
2133             
2134             error ContractPaused();
2135             error MaxMintWalletExceeded();
2136             error MaxSupply();
2137             error InvalidMintAmount();
2138             error InsufficientFund();
2139             error NoSmartContract();
2140             error TokenNotExisting();
2141 
2142         constructor(string memory _initBaseURI) ERC721A("Nakamonkeys", "NGMKS") {
2143             baseURL = _initBaseURI;
2144         }
2145 
2146         // ================== Mint Function =======================
2147 
2148         modifier mintCompliance(uint256 _mintAmount) {
2149             if (msg.sender != tx.origin) revert NoSmartContract();
2150             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2151             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2152             if(paused) revert ContractPaused();
2153             _;
2154         }
2155 
2156         modifier mintPriceCompliance(uint256 _mintAmount) {
2157             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2158             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2159               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2160             _;
2161         }
2162         
2163         /// @notice compliance of minting
2164         /// @dev user (msg.sender) mint
2165         /// @param _mintAmount the amount of tokens to mint
2166         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2167          
2168           
2169           _safeMint(msg.sender, _mintAmount);
2170           }
2171 
2172         /// @dev user (msg.sender) mint
2173         /// @param _mintAmount the amount of tokens to mint 
2174         /// @return value from number to mint
2175         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2176           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2177           if ((totalMints <= numberOfFreeNFTs) ) {
2178           return _initalPrice;
2179           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2180           uint256 total = costOfNFT * (_mintAmount - numberOfFreeNFTs);
2181           return total;
2182           } 
2183           else {
2184           uint256 total2 = costOfNFT * _mintAmount;
2185           return total2;
2186             }
2187         }
2188         
2189 
2190 
2191         /// @notice airdrop function to airdrop same amount of tokens to addresses
2192         /// @dev only owner function
2193         /// @param accounts  array of addresses
2194         /// @param amount the amount of tokens to airdrop users
2195         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2196           for(uint256 i = 0; i < accounts.length; i++){
2197           _safeMint(accounts[i], amount);
2198           }
2199         }
2200 
2201         // =================== Orange Functions (Owner Only) ===============
2202 
2203         /// @dev pause/unpause minting
2204         function pause() public onlyOwner {
2205           paused = !paused;
2206         }
2207 
2208         
2209 
2210         /// @dev set URI
2211         /// @param uri  new URI
2212         function setbaseURL(string memory uri) public onlyOwner{
2213           baseURL = uri;
2214         }
2215 
2216         /// @dev extension URI like 'json'
2217         function setExtensionURL(string memory uri) public onlyOwner{
2218           ExtensionURL = uri;
2219         }
2220         
2221         /// @dev set new cost of tokenId in WEI
2222         /// @param _cost  new price in wei
2223         function setCostPrice(uint256 _cost) public onlyOwner{
2224           costOfNFT = _cost;
2225         } 
2226 
2227         /// @dev only owner
2228         /// @param perTx  new max mint per transaction
2229         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2230           maxMintAmountPerTx = perTx;
2231         }
2232 
2233         /// @dev only owner
2234         /// @param perWallet  new max mint per wallet
2235         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2236           maxMintAmountPerWallet = perWallet;
2237         }  
2238         
2239         /// @dev only owner
2240         /// @param perWallet set free number of nft per wallet
2241         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2242           numberOfFreeNFTs = perWallet;
2243         }            
2244 
2245         // ================================ Withdraw Function ====================
2246 
2247         /// @notice withdraw ether from contract.
2248         /// @dev only owner function
2249         function withdraw() public onlyOwner nonReentrant{
2250           
2251 
2252           
2253 
2254         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2255         require(owner);
2256         }
2257         // =================== Blue Functions (View Only) ====================
2258 
2259         /// @dev return uri of token ID
2260         /// @param tokenId  token ID to find uri for
2261         ///@return value for 'tokenId uri'
2262         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2263           if (!_exists(tokenId)) revert TokenNotExisting();   
2264 
2265         
2266 
2267         string memory currentBaseURI = _baseURI();
2268         return bytes(currentBaseURI).length > 0
2269         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2270         : '';
2271         }
2272         
2273         /// @dev tokenId to start (1)
2274         function _startTokenId() internal view virtual override returns (uint256) {
2275           return 1;
2276         }
2277 
2278         ///@dev maxSupply of token
2279         /// @return max supply
2280         function _baseURI() internal view virtual override returns (string memory) {
2281           return baseURL;
2282         }
2283 
2284     
2285         /// @dev internal function to 
2286         /// @param from  user address where token belongs
2287         /// @param to  user address
2288         /// @param tokenId  number of tokenId
2289           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2290         super.transferFrom(from, to, tokenId);
2291         }
2292         
2293         /// @dev internal function to 
2294         /// @param from  user address where token belongs
2295         /// @param to  user address
2296         /// @param tokenId  number of tokenId
2297         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2298         super.safeTransferFrom(from, to, tokenId);
2299         }
2300 
2301         /// @dev internal function to 
2302         /// @param from  user address where token belongs
2303         /// @param to  user address
2304         /// @param tokenId  number of tokenId
2305         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2306         public payable
2307         override
2308         onlyAllowedOperator(from)
2309         {
2310         super.safeTransferFrom(from, to, tokenId, data);
2311         }
2312         
2313 
2314 }