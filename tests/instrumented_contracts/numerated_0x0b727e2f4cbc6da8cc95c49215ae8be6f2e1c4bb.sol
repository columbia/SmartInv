1 /**
2  *Submitted for verification at Etherscan.io on 2023-03-10
3 */
4 
5 // SPDX-License-Identifier: MIT
6 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
7 
8 
9 //   _____       _                       _   _       _   _             
10 //  /  __ \     | |                     | \ | |     | | (_)            
11 //  | /  \/_   _| |__   ___  _ __ __ _  |  \| | __ _| |_ _  ___  _ __  
12 //  | |   | | | | '_ \ / _ \| '__/ _` | | . ` |/ _` | __| |/ _ \| '_ \ 
13 //  | \__/| |_| | |_) | (_) | | | (_| | | |\  | (_| | |_| | (_) | | | |
14 //   \____/\__, |_.__/ \___/|_|  \__, | \_| \_/\__,_|\__|_|\___/|_| |_|
15 //          __/ |                 __/ |                                
16 //         |___/                 |___/                                 
17 
18 
19 pragma solidity ^0.8.13;
20 
21 interface IOperatorFilterRegistry {
22     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
23     function register(address registrant) external;
24     function registerAndSubscribe(address registrant, address subscription) external;
25     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
26     function unregister(address addr) external;
27     function updateOperator(address registrant, address operator, bool filtered) external;
28     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
29     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
30     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
31     function subscribe(address registrant, address registrantToSubscribe) external;
32     function unsubscribe(address registrant, bool copyExistingEntries) external;
33     function subscriptionOf(address addr) external returns (address registrant);
34     function subscribers(address registrant) external returns (address[] memory);
35     function subscriberAt(address registrant, uint256 index) external returns (address);
36     function copyEntriesOf(address registrant, address registrantToCopy) external;
37     function isOperatorFiltered(address registrant, address operator) external returns (bool);
38     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
39     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
40     function filteredOperators(address addr) external returns (address[] memory);
41     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
42     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
43     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
44     function isRegistered(address addr) external returns (bool);
45     function codeHashOf(address addr) external returns (bytes32);
46 }
47 
48 // File: operator-filter-registry/src/OperatorFilterer.sol
49 
50 
51 pragma solidity ^0.8.13;
52 
53 
54 /**
55  * @title  OperatorFilterer
56  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
57  *         registrant's entries in the OperatorFilterRegistry.
58  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
59  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
60  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
61  */
62 abstract contract OperatorFilterer {
63     error OperatorNotAllowed(address operator);
64 
65     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
66         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
67 
68     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
69         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
70         // will not revert, but the contract will need to be registered with the registry once it is deployed in
71         // order for the modifier to filter addresses.
72         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
73             if (subscribe) {
74                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
75             } else {
76                 if (subscriptionOrRegistrantToCopy != address(0)) {
77                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
78                 } else {
79                     OPERATOR_FILTER_REGISTRY.register(address(this));
80                 }
81             }
82         }
83     }
84 
85     modifier onlyAllowedOperator(address from) virtual {
86         // Allow spending tokens from addresses with balance
87         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
88         // from an EOA.
89         if (from != msg.sender) {
90             _checkFilterOperator(msg.sender);
91         }
92         _;
93     }
94 
95     modifier onlyAllowedOperatorApproval(address operator) virtual {
96         _checkFilterOperator(operator);
97         _;
98     }
99 
100     function _checkFilterOperator(address operator) internal view virtual {
101         // Check registry code length to facilitate testing in environments without a deployed registry.
102         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
103             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
104                 revert OperatorNotAllowed(operator);
105             }
106         }
107     }
108 }
109 
110 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
111 
112 
113 pragma solidity ^0.8.13;
114 
115 
116 /**
117  * @title  DefaultOperatorFilterer
118  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
119  */
120 abstract contract DefaultOperatorFilterer is OperatorFilterer {
121     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
122 
123     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
124 }
125 
126 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
127 
128 
129 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Contract module that helps prevent reentrant calls to a function.
135  *
136  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
137  * available, which can be applied to functions to make sure there are no nested
138  * (reentrant) calls to them.
139  *
140  * Note that because there is a single `nonReentrant` guard, functions marked as
141  * `nonReentrant` may not call one another. This can be worked around by making
142  * those functions `private`, and then adding `external` `nonReentrant` entry
143  * points to them.
144  *
145  * TIP: If you would like to learn more about reentrancy and alternative ways
146  * to protect against it, check out our blog post
147  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
148  */
149 abstract contract ReentrancyGuard {
150     // Booleans are more expensive than uint256 or any type that takes up a full
151     // word because each write operation emits an extra SLOAD to first read the
152     // slot's contents, replace the bits taken up by the boolean, and then write
153     // back. This is the compiler's defense against contract upgrades and
154     // pointer aliasing, and it cannot be disabled.
155 
156     // The values being non-zero value makes deployment a bit more expensive,
157     // but in exchange the refund on every call to nonReentrant will be lower in
158     // amount. Since refunds are capped to a percentage of the total
159     // transaction's gas, it is best to keep them low in cases like this one, to
160     // increase the likelihood of the full refund coming into effect.
161     uint256 private constant _NOT_ENTERED = 1;
162     uint256 private constant _ENTERED = 2;
163 
164     uint256 private _status;
165 
166     constructor() {
167         _status = _NOT_ENTERED;
168     }
169 
170     /**
171      * @dev Prevents a contract from calling itself, directly or indirectly.
172      * Calling a `nonReentrant` function from another `nonReentrant`
173      * function is not supported. It is possible to prevent this from happening
174      * by making the `nonReentrant` function external, and making it call a
175      * `private` function that does the actual work.
176      */
177     modifier nonReentrant() {
178         _nonReentrantBefore();
179         _;
180         _nonReentrantAfter();
181     }
182 
183     function _nonReentrantBefore() private {
184         // On the first call to nonReentrant, _status will be _NOT_ENTERED
185         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
186 
187         // Any calls to nonReentrant after this point will fail
188         _status = _ENTERED;
189     }
190 
191     function _nonReentrantAfter() private {
192         // By storing the original value once again, a refund is triggered (see
193         // https://eips.ethereum.org/EIPS/eip-2200)
194         _status = _NOT_ENTERED;
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/math/Math.sol
199 
200 
201 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Standard math utilities missing in the Solidity language.
207  */
208 library Math {
209     enum Rounding {
210         Down, // Toward negative infinity
211         Up, // Toward infinity
212         Zero // Toward zero
213     }
214 
215     /**
216      * @dev Returns the largest of two numbers.
217      */
218     function max(uint256 a, uint256 b) internal pure returns (uint256) {
219         return a > b ? a : b;
220     }
221 
222     /**
223      * @dev Returns the smallest of two numbers.
224      */
225     function min(uint256 a, uint256 b) internal pure returns (uint256) {
226         return a < b ? a : b;
227     }
228 
229     /**
230      * @dev Returns the average of two numbers. The result is rounded towards
231      * zero.
232      */
233     function average(uint256 a, uint256 b) internal pure returns (uint256) {
234         // (a + b) / 2 can overflow.
235         return (a & b) + (a ^ b) / 2;
236     }
237 
238     /**
239      * @dev Returns the ceiling of the division of two numbers.
240      *
241      * This differs from standard division with `/` in that it rounds up instead
242      * of rounding down.
243      */
244     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
245         // (a + b - 1) / b can overflow on addition, so we distribute.
246         return a == 0 ? 0 : (a - 1) / b + 1;
247     }
248 
249     /**
250      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
251      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
252      * with further edits by Uniswap Labs also under MIT license.
253      */
254     function mulDiv(
255         uint256 x,
256         uint256 y,
257         uint256 denominator
258     ) internal pure returns (uint256 result) {
259         unchecked {
260             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
261             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
262             // variables such that product = prod1 * 2^256 + prod0.
263             uint256 prod0; // Least significant 256 bits of the product
264             uint256 prod1; // Most significant 256 bits of the product
265             assembly {
266                 let mm := mulmod(x, y, not(0))
267                 prod0 := mul(x, y)
268                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
269             }
270 
271             // Handle non-overflow cases, 256 by 256 division.
272             if (prod1 == 0) {
273                 return prod0 / denominator;
274             }
275 
276             // Make sure the result is less than 2^256. Also prevents denominator == 0.
277             require(denominator > prod1);
278 
279             ///////////////////////////////////////////////
280             // 512 by 256 division.
281             ///////////////////////////////////////////////
282 
283             // Make division exact by subtracting the remainder from [prod1 prod0].
284             uint256 remainder;
285             assembly {
286                 // Compute remainder using mulmod.
287                 remainder := mulmod(x, y, denominator)
288 
289                 // Subtract 256 bit number from 512 bit number.
290                 prod1 := sub(prod1, gt(remainder, prod0))
291                 prod0 := sub(prod0, remainder)
292             }
293 
294             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
295             // See https://cs.stackexchange.com/q/138556/92363.
296 
297             // Does not overflow because the denominator cannot be zero at this stage in the function.
298             uint256 twos = denominator & (~denominator + 1);
299             assembly {
300                 // Divide denominator by twos.
301                 denominator := div(denominator, twos)
302 
303                 // Divide [prod1 prod0] by twos.
304                 prod0 := div(prod0, twos)
305 
306                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
307                 twos := add(div(sub(0, twos), twos), 1)
308             }
309 
310             // Shift in bits from prod1 into prod0.
311             prod0 |= prod1 * twos;
312 
313             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
314             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
315             // four bits. That is, denominator * inv = 1 mod 2^4.
316             uint256 inverse = (3 * denominator) ^ 2;
317 
318             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
319             // in modular arithmetic, doubling the correct bits in each step.
320             inverse *= 2 - denominator * inverse; // inverse mod 2^8
321             inverse *= 2 - denominator * inverse; // inverse mod 2^16
322             inverse *= 2 - denominator * inverse; // inverse mod 2^32
323             inverse *= 2 - denominator * inverse; // inverse mod 2^64
324             inverse *= 2 - denominator * inverse; // inverse mod 2^128
325             inverse *= 2 - denominator * inverse; // inverse mod 2^256
326 
327             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
328             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
329             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
330             // is no longer required.
331             result = prod0 * inverse;
332             return result;
333         }
334     }
335 
336     /**
337      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
338      */
339     function mulDiv(
340         uint256 x,
341         uint256 y,
342         uint256 denominator,
343         Rounding rounding
344     ) internal pure returns (uint256) {
345         uint256 result = mulDiv(x, y, denominator);
346         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
347             result += 1;
348         }
349         return result;
350     }
351 
352     /**
353      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
354      *
355      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
356      */
357     function sqrt(uint256 a) internal pure returns (uint256) {
358         if (a == 0) {
359             return 0;
360         }
361 
362         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
363         //
364         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
365         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
366         //
367         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
368         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
369         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
370         //
371         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
372         uint256 result = 1 << (log2(a) >> 1);
373 
374         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
375         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
376         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
377         // into the expected uint128 result.
378         unchecked {
379             result = (result + a / result) >> 1;
380             result = (result + a / result) >> 1;
381             result = (result + a / result) >> 1;
382             result = (result + a / result) >> 1;
383             result = (result + a / result) >> 1;
384             result = (result + a / result) >> 1;
385             result = (result + a / result) >> 1;
386             return min(result, a / result);
387         }
388     }
389 
390     /**
391      * @notice Calculates sqrt(a), following the selected rounding direction.
392      */
393     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
394         unchecked {
395             uint256 result = sqrt(a);
396             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
397         }
398     }
399 
400     /**
401      * @dev Return the log in base 2, rounded down, of a positive value.
402      * Returns 0 if given 0.
403      */
404     function log2(uint256 value) internal pure returns (uint256) {
405         uint256 result = 0;
406         unchecked {
407             if (value >> 128 > 0) {
408                 value >>= 128;
409                 result += 128;
410             }
411             if (value >> 64 > 0) {
412                 value >>= 64;
413                 result += 64;
414             }
415             if (value >> 32 > 0) {
416                 value >>= 32;
417                 result += 32;
418             }
419             if (value >> 16 > 0) {
420                 value >>= 16;
421                 result += 16;
422             }
423             if (value >> 8 > 0) {
424                 value >>= 8;
425                 result += 8;
426             }
427             if (value >> 4 > 0) {
428                 value >>= 4;
429                 result += 4;
430             }
431             if (value >> 2 > 0) {
432                 value >>= 2;
433                 result += 2;
434             }
435             if (value >> 1 > 0) {
436                 result += 1;
437             }
438         }
439         return result;
440     }
441 
442     /**
443      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
444      * Returns 0 if given 0.
445      */
446     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
447         unchecked {
448             uint256 result = log2(value);
449             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
450         }
451     }
452 
453     /**
454      * @dev Return the log in base 10, rounded down, of a positive value.
455      * Returns 0 if given 0.
456      */
457     function log10(uint256 value) internal pure returns (uint256) {
458         uint256 result = 0;
459         unchecked {
460             if (value >= 10**64) {
461                 value /= 10**64;
462                 result += 64;
463             }
464             if (value >= 10**32) {
465                 value /= 10**32;
466                 result += 32;
467             }
468             if (value >= 10**16) {
469                 value /= 10**16;
470                 result += 16;
471             }
472             if (value >= 10**8) {
473                 value /= 10**8;
474                 result += 8;
475             }
476             if (value >= 10**4) {
477                 value /= 10**4;
478                 result += 4;
479             }
480             if (value >= 10**2) {
481                 value /= 10**2;
482                 result += 2;
483             }
484             if (value >= 10**1) {
485                 result += 1;
486             }
487         }
488         return result;
489     }
490 
491     /**
492      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
493      * Returns 0 if given 0.
494      */
495     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
496         unchecked {
497             uint256 result = log10(value);
498             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
499         }
500     }
501 
502     /**
503      * @dev Return the log in base 256, rounded down, of a positive value.
504      * Returns 0 if given 0.
505      *
506      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
507      */
508     function log256(uint256 value) internal pure returns (uint256) {
509         uint256 result = 0;
510         unchecked {
511             if (value >> 128 > 0) {
512                 value >>= 128;
513                 result += 16;
514             }
515             if (value >> 64 > 0) {
516                 value >>= 64;
517                 result += 8;
518             }
519             if (value >> 32 > 0) {
520                 value >>= 32;
521                 result += 4;
522             }
523             if (value >> 16 > 0) {
524                 value >>= 16;
525                 result += 2;
526             }
527             if (value >> 8 > 0) {
528                 result += 1;
529             }
530         }
531         return result;
532     }
533 
534     /**
535      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
536      * Returns 0 if given 0.
537      */
538     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
539         unchecked {
540             uint256 result = log256(value);
541             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
542         }
543     }
544 }
545 
546 // File: @openzeppelin/contracts/utils/Strings.sol
547 
548 
549 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
550 
551 pragma solidity ^0.8.0;
552 
553 
554 /**
555  * @dev String operations.
556  */
557 library Strings {
558     bytes16 private constant _SYMBOLS = "0123456789abcdef";
559     uint8 private constant _ADDRESS_LENGTH = 20;
560 
561     /**
562      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
563      */
564     function toString(uint256 value) internal pure returns (string memory) {
565         unchecked {
566             uint256 length = Math.log10(value) + 1;
567             string memory buffer = new string(length);
568             uint256 ptr;
569             /// @solidity memory-safe-assembly
570             assembly {
571                 ptr := add(buffer, add(32, length))
572             }
573             while (true) {
574                 ptr--;
575                 /// @solidity memory-safe-assembly
576                 assembly {
577                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
578                 }
579                 value /= 10;
580                 if (value == 0) break;
581             }
582             return buffer;
583         }
584     }
585 
586     /**
587      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
588      */
589     function toHexString(uint256 value) internal pure returns (string memory) {
590         unchecked {
591             return toHexString(value, Math.log256(value) + 1);
592         }
593     }
594 
595     /**
596      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
597      */
598     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
599         bytes memory buffer = new bytes(2 * length + 2);
600         buffer[0] = "0";
601         buffer[1] = "x";
602         for (uint256 i = 2 * length + 1; i > 1; --i) {
603             buffer[i] = _SYMBOLS[value & 0xf];
604             value >>= 4;
605         }
606         require(value == 0, "Strings: hex length insufficient");
607         return string(buffer);
608     }
609 
610     /**
611      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
612      */
613     function toHexString(address addr) internal pure returns (string memory) {
614         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
615     }
616 }
617 
618 // File: erc721a/contracts/IERC721A.sol
619 
620 
621 // ERC721A Contracts v4.2.3
622 // Creator: Chiru Labs
623 
624 pragma solidity ^0.8.4;
625 
626 /**
627  * @dev Interface of ERC721A.
628  */
629 interface IERC721A {
630     /**
631      * The caller must own the token or be an approved operator.
632      */
633     error ApprovalCallerNotOwnerNorApproved();
634 
635     /**
636      * The token does not exist.
637      */
638     error ApprovalQueryForNonexistentToken();
639 
640     /**
641      * Cannot query the balance for the zero address.
642      */
643     error BalanceQueryForZeroAddress();
644 
645     /**
646      * Cannot mint to the zero address.
647      */
648     error MintToZeroAddress();
649 
650     /**
651      * The quantity of tokens minted must be more than zero.
652      */
653     error MintZeroQuantity();
654 
655     /**
656      * The token does not exist.
657      */
658     error OwnerQueryForNonexistentToken();
659 
660     /**
661      * The caller must own the token or be an approved operator.
662      */
663     error TransferCallerNotOwnerNorApproved();
664 
665     /**
666      * The token must be owned by `from`.
667      */
668     error TransferFromIncorrectOwner();
669 
670     /**
671      * Cannot safely transfer to a contract that does not implement the
672      * ERC721Receiver interface.
673      */
674     error TransferToNonERC721ReceiverImplementer();
675 
676     /**
677      * Cannot transfer to the zero address.
678      */
679     error TransferToZeroAddress();
680 
681     /**
682      * The token does not exist.
683      */
684     error URIQueryForNonexistentToken();
685 
686     /**
687      * The `quantity` minted with ERC2309 exceeds the safety limit.
688      */
689     error MintERC2309QuantityExceedsLimit();
690 
691     /**
692      * The `extraData` cannot be set on an unintialized ownership slot.
693      */
694     error OwnershipNotInitializedForExtraData();
695 
696     // =============================================================
697     //                            STRUCTS
698     // =============================================================
699 
700     struct TokenOwnership {
701         // The address of the owner.
702         address addr;
703         // Stores the start time of ownership with minimal overhead for tokenomics.
704         uint64 startTimestamp;
705         // Whether the token has been burned.
706         bool burned;
707         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
708         uint24 extraData;
709     }
710 
711     // =============================================================
712     //                         TOKEN COUNTERS
713     // =============================================================
714 
715     /**
716      * @dev Returns the total number of tokens in existence.
717      * Burned tokens will reduce the count.
718      * To get the total number of tokens minted, please see {_totalMinted}.
719      */
720     function totalSupply() external view returns (uint256);
721 
722     // =============================================================
723     //                            IERC165
724     // =============================================================
725 
726     /**
727      * @dev Returns true if this contract implements the interface defined by
728      * `interfaceId`. See the corresponding
729      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
730      * to learn more about how these ids are created.
731      *
732      * This function call must use less than 30000 gas.
733      */
734     function supportsInterface(bytes4 interfaceId) external view returns (bool);
735 
736     // =============================================================
737     //                            IERC721
738     // =============================================================
739 
740     /**
741      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
742      */
743     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
744 
745     /**
746      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
747      */
748     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
749 
750     /**
751      * @dev Emitted when `owner` enables or disables
752      * (`approved`) `operator` to manage all of its assets.
753      */
754     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
755 
756     /**
757      * @dev Returns the number of tokens in `owner`'s account.
758      */
759     function balanceOf(address owner) external view returns (uint256 balance);
760 
761     /**
762      * @dev Returns the owner of the `tokenId` token.
763      *
764      * Requirements:
765      *
766      * - `tokenId` must exist.
767      */
768     function ownerOf(uint256 tokenId) external view returns (address owner);
769 
770     /**
771      * @dev Safely transfers `tokenId` token from `from` to `to`,
772      * checking first that contract recipients are aware of the ERC721 protocol
773      * to prevent tokens from being forever locked.
774      *
775      * Requirements:
776      *
777      * - `from` cannot be the zero address.
778      * - `to` cannot be the zero address.
779      * - `tokenId` token must exist and be owned by `from`.
780      * - If the caller is not `from`, it must be have been allowed to move
781      * this token by either {approve} or {setApprovalForAll}.
782      * - If `to` refers to a smart contract, it must implement
783      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
784      *
785      * Emits a {Transfer} event.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId,
791         bytes calldata data
792     ) external payable;
793 
794     /**
795      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
796      */
797     function safeTransferFrom(
798         address from,
799         address to,
800         uint256 tokenId
801     ) external payable;
802 
803     /**
804      * @dev Transfers `tokenId` from `from` to `to`.
805      *
806      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
807      * whenever possible.
808      *
809      * Requirements:
810      *
811      * - `from` cannot be the zero address.
812      * - `to` cannot be the zero address.
813      * - `tokenId` token must be owned by `from`.
814      * - If the caller is not `from`, it must be approved to move this token
815      * by either {approve} or {setApprovalForAll}.
816      *
817      * Emits a {Transfer} event.
818      */
819     function transferFrom(
820         address from,
821         address to,
822         uint256 tokenId
823     ) external payable;
824 
825     /**
826      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
827      * The approval is cleared when the token is transferred.
828      *
829      * Only a single account can be approved at a time, so approving the
830      * zero address clears previous approvals.
831      *
832      * Requirements:
833      *
834      * - The caller must own the token or be an approved operator.
835      * - `tokenId` must exist.
836      *
837      * Emits an {Approval} event.
838      */
839     function approve(address to, uint256 tokenId) external payable;
840 
841     /**
842      * @dev Approve or remove `operator` as an operator for the caller.
843      * Operators can call {transferFrom} or {safeTransferFrom}
844      * for any token owned by the caller.
845      *
846      * Requirements:
847      *
848      * - The `operator` cannot be the caller.
849      *
850      * Emits an {ApprovalForAll} event.
851      */
852     function setApprovalForAll(address operator, bool _approved) external;
853 
854     /**
855      * @dev Returns the account approved for `tokenId` token.
856      *
857      * Requirements:
858      *
859      * - `tokenId` must exist.
860      */
861     function getApproved(uint256 tokenId) external view returns (address operator);
862 
863     /**
864      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
865      *
866      * See {setApprovalForAll}.
867      */
868     function isApprovedForAll(address owner, address operator) external view returns (bool);
869 
870     // =============================================================
871     //                        IERC721Metadata
872     // =============================================================
873 
874     /**
875      * @dev Returns the token collection name.
876      */
877     function name() external view returns (string memory);
878 
879     /**
880      * @dev Returns the token collection symbol.
881      */
882     function symbol() external view returns (string memory);
883 
884     /**
885      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
886      */
887     function tokenURI(uint256 tokenId) external view returns (string memory);
888 
889     // =============================================================
890     //                           IERC2309
891     // =============================================================
892 
893     /**
894      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
895      * (inclusive) is transferred from `from` to `to`, as defined in the
896      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
897      *
898      * See {_mintERC2309} for more details.
899      */
900     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
901 }
902 
903 // File: erc721a/contracts/ERC721A.sol
904 
905 
906 // ERC721A Contracts v4.2.3
907 // Creator: Chiru Labs
908 
909 pragma solidity ^0.8.4;
910 
911 
912 /**
913  * @dev Interface of ERC721 token receiver.
914  */
915 interface ERC721A__IERC721Receiver {
916     function onERC721Received(
917         address operator,
918         address from,
919         uint256 tokenId,
920         bytes calldata data
921     ) external returns (bytes4);
922 }
923 
924 /**
925  * @title ERC721A
926  *
927  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
928  * Non-Fungible Token Standard, including the Metadata extension.
929  * Optimized for lower gas during batch mints.
930  *
931  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
932  * starting from `_startTokenId()`.
933  *
934  * Assumptions:
935  *
936  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
937  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
938  */
939 contract ERC721A is IERC721A {
940     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
941     struct TokenApprovalRef {
942         address value;
943     }
944 
945     // =============================================================
946     //                           CONSTANTS
947     // =============================================================
948 
949     // Mask of an entry in packed address data.
950     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
951 
952     // The bit position of `numberMinted` in packed address data.
953     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
954 
955     // The bit position of `numberBurned` in packed address data.
956     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
957 
958     // The bit position of `aux` in packed address data.
959     uint256 private constant _BITPOS_AUX = 192;
960 
961     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
962     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
963 
964     // The bit position of `startTimestamp` in packed ownership.
965     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
966 
967     // The bit mask of the `burned` bit in packed ownership.
968     uint256 private constant _BITMASK_BURNED = 1 << 224;
969 
970     // The bit position of the `nextInitialized` bit in packed ownership.
971     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
972 
973     // The bit mask of the `nextInitialized` bit in packed ownership.
974     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
975 
976     // The bit position of `extraData` in packed ownership.
977     uint256 private constant _BITPOS_EXTRA_DATA = 232;
978 
979     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
980     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
981 
982     // The mask of the lower 160 bits for addresses.
983     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
984 
985     // The maximum `quantity` that can be minted with {_mintERC2309}.
986     // This limit is to prevent overflows on the address data entries.
987     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
988     // is required to cause an overflow, which is unrealistic.
989     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
990 
991     // The `Transfer` event signature is given by:
992     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
993     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
994         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
995 
996     // =============================================================
997     //                            STORAGE
998     // =============================================================
999 
1000     // The next token ID to be minted.
1001     uint256 private _currentIndex;
1002 
1003     // The number of tokens burned.
1004     uint256 private _burnCounter;
1005 
1006     // Token name
1007     string private _name;
1008 
1009     // Token symbol
1010     string private _symbol;
1011 
1012     // Mapping from token ID to ownership details
1013     // An empty struct value does not necessarily mean the token is unowned.
1014     // See {_packedOwnershipOf} implementation for details.
1015     //
1016     // Bits Layout:
1017     // - [0..159]   `addr`
1018     // - [160..223] `startTimestamp`
1019     // - [224]      `burned`
1020     // - [225]      `nextInitialized`
1021     // - [232..255] `extraData`
1022     mapping(uint256 => uint256) private _packedOwnerships;
1023 
1024     // Mapping owner address to address data.
1025     //
1026     // Bits Layout:
1027     // - [0..63]    `balance`
1028     // - [64..127]  `numberMinted`
1029     // - [128..191] `numberBurned`
1030     // - [192..255] `aux`
1031     mapping(address => uint256) private _packedAddressData;
1032 
1033     // Mapping from token ID to approved address.
1034     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1035 
1036     // Mapping from owner to operator approvals
1037     mapping(address => mapping(address => bool)) private _operatorApprovals;
1038 
1039     // =============================================================
1040     //                          CONSTRUCTOR
1041     // =============================================================
1042 
1043     constructor(string memory name_, string memory symbol_) {
1044         _name = name_;
1045         _symbol = symbol_;
1046         _currentIndex = _startTokenId();
1047     }
1048 
1049     // =============================================================
1050     //                   TOKEN COUNTING OPERATIONS
1051     // =============================================================
1052 
1053     /**
1054      * @dev Returns the starting token ID.
1055      * To change the starting token ID, please override this function.
1056      */
1057     function _startTokenId() internal view virtual returns (uint256) {
1058         return 0;
1059     }
1060 
1061     /**
1062      * @dev Returns the next token ID to be minted.
1063      */
1064     function _nextTokenId() internal view virtual returns (uint256) {
1065         return _currentIndex;
1066     }
1067 
1068     /**
1069      * @dev Returns the total number of tokens in existence.
1070      * Burned tokens will reduce the count.
1071      * To get the total number of tokens minted, please see {_totalMinted}.
1072      */
1073     function totalSupply() public view virtual override returns (uint256) {
1074         // Counter underflow is impossible as _burnCounter cannot be incremented
1075         // more than `_currentIndex - _startTokenId()` times.
1076         unchecked {
1077             return _currentIndex - _burnCounter - _startTokenId();
1078         }
1079     }
1080 
1081     /**
1082      * @dev Returns the total amount of tokens minted in the contract.
1083      */
1084     function _totalMinted() internal view virtual returns (uint256) {
1085         // Counter underflow is impossible as `_currentIndex` does not decrement,
1086         // and it is initialized to `_startTokenId()`.
1087         unchecked {
1088             return _currentIndex - _startTokenId();
1089         }
1090     }
1091 
1092     /**
1093      * @dev Returns the total number of tokens burned.
1094      */
1095     function _totalBurned() internal view virtual returns (uint256) {
1096         return _burnCounter;
1097     }
1098 
1099     // =============================================================
1100     //                    ADDRESS DATA OPERATIONS
1101     // =============================================================
1102 
1103     /**
1104      * @dev Returns the number of tokens in `owner`'s account.
1105      */
1106     function balanceOf(address owner) public view virtual override returns (uint256) {
1107         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1108         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1109     }
1110 
1111     /**
1112      * Returns the number of tokens minted by `owner`.
1113      */
1114     function _numberMinted(address owner) internal view returns (uint256) {
1115         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1116     }
1117 
1118     /**
1119      * Returns the number of tokens burned by or on behalf of `owner`.
1120      */
1121     function _numberBurned(address owner) internal view returns (uint256) {
1122         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1123     }
1124 
1125     /**
1126      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1127      */
1128     function _getAux(address owner) internal view returns (uint64) {
1129         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1130     }
1131 
1132     /**
1133      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1134      * If there are multiple variables, please pack them into a uint64.
1135      */
1136     function _setAux(address owner, uint64 aux) internal virtual {
1137         uint256 packed = _packedAddressData[owner];
1138         uint256 auxCasted;
1139         // Cast `aux` with assembly to avoid redundant masking.
1140         assembly {
1141             auxCasted := aux
1142         }
1143         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1144         _packedAddressData[owner] = packed;
1145     }
1146 
1147     // =============================================================
1148     //                            IERC165
1149     // =============================================================
1150 
1151     /**
1152      * @dev Returns true if this contract implements the interface defined by
1153      * `interfaceId`. See the corresponding
1154      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1155      * to learn more about how these ids are created.
1156      *
1157      * This function call must use less than 30000 gas.
1158      */
1159     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1160         // The interface IDs are constants representing the first 4 bytes
1161         // of the XOR of all function selectors in the interface.
1162         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1163         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1164         return
1165             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1166             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1167             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1168     }
1169 
1170     // =============================================================
1171     //                        IERC721Metadata
1172     // =============================================================
1173 
1174     /**
1175      * @dev Returns the token collection name.
1176      */
1177     function name() public view virtual override returns (string memory) {
1178         return _name;
1179     }
1180 
1181     /**
1182      * @dev Returns the token collection symbol.
1183      */
1184     function symbol() public view virtual override returns (string memory) {
1185         return _symbol;
1186     }
1187 
1188     /**
1189      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1190      */
1191     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1192         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1193 
1194         string memory baseURI = _baseURI();
1195         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1196     }
1197 
1198     /**
1199      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1200      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1201      * by default, it can be overridden in child contracts.
1202      */
1203     function _baseURI() internal view virtual returns (string memory) {
1204         return '';
1205     }
1206 
1207     // =============================================================
1208     //                     OWNERSHIPS OPERATIONS
1209     // =============================================================
1210 
1211     /**
1212      * @dev Returns the owner of the `tokenId` token.
1213      *
1214      * Requirements:
1215      *
1216      * - `tokenId` must exist.
1217      */
1218     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1219         return address(uint160(_packedOwnershipOf(tokenId)));
1220     }
1221 
1222     /**
1223      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1224      * It gradually moves to O(1) as tokens get transferred around over time.
1225      */
1226     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1227         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1228     }
1229 
1230     /**
1231      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1232      */
1233     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1234         return _unpackedOwnership(_packedOwnerships[index]);
1235     }
1236 
1237     /**
1238      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1239      */
1240     function _initializeOwnershipAt(uint256 index) internal virtual {
1241         if (_packedOwnerships[index] == 0) {
1242             _packedOwnerships[index] = _packedOwnershipOf(index);
1243         }
1244     }
1245 
1246     /**
1247      * Returns the packed ownership data of `tokenId`.
1248      */
1249     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1250         uint256 curr = tokenId;
1251 
1252         unchecked {
1253             if (_startTokenId() <= curr)
1254                 if (curr < _currentIndex) {
1255                     uint256 packed = _packedOwnerships[curr];
1256                     // If not burned.
1257                     if (packed & _BITMASK_BURNED == 0) {
1258                         // Invariant:
1259                         // There will always be an initialized ownership slot
1260                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1261                         // before an unintialized ownership slot
1262                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1263                         // Hence, `curr` will not underflow.
1264                         //
1265                         // We can directly compare the packed value.
1266                         // If the address is zero, packed will be zero.
1267                         while (packed == 0) {
1268                             packed = _packedOwnerships[--curr];
1269                         }
1270                         return packed;
1271                     }
1272                 }
1273         }
1274         revert OwnerQueryForNonexistentToken();
1275     }
1276 
1277     /**
1278      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1279      */
1280     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1281         ownership.addr = address(uint160(packed));
1282         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1283         ownership.burned = packed & _BITMASK_BURNED != 0;
1284         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1285     }
1286 
1287     /**
1288      * @dev Packs ownership data into a single uint256.
1289      */
1290     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1291         assembly {
1292             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1293             owner := and(owner, _BITMASK_ADDRESS)
1294             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1295             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1296         }
1297     }
1298 
1299     /**
1300      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1301      */
1302     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1303         // For branchless setting of the `nextInitialized` flag.
1304         assembly {
1305             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1306             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1307         }
1308     }
1309 
1310     // =============================================================
1311     //                      APPROVAL OPERATIONS
1312     // =============================================================
1313 
1314     /**
1315      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1316      * The approval is cleared when the token is transferred.
1317      *
1318      * Only a single account can be approved at a time, so approving the
1319      * zero address clears previous approvals.
1320      *
1321      * Requirements:
1322      *
1323      * - The caller must own the token or be an approved operator.
1324      * - `tokenId` must exist.
1325      *
1326      * Emits an {Approval} event.
1327      */
1328     function approve(address to, uint256 tokenId) public payable virtual override {
1329         address owner = ownerOf(tokenId);
1330 
1331         if (_msgSenderERC721A() != owner)
1332             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1333                 revert ApprovalCallerNotOwnerNorApproved();
1334             }
1335 
1336         _tokenApprovals[tokenId].value = to;
1337         emit Approval(owner, to, tokenId);
1338     }
1339 
1340     /**
1341      * @dev Returns the account approved for `tokenId` token.
1342      *
1343      * Requirements:
1344      *
1345      * - `tokenId` must exist.
1346      */
1347     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1348         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1349 
1350         return _tokenApprovals[tokenId].value;
1351     }
1352 
1353     /**
1354      * @dev Approve or remove `operator` as an operator for the caller.
1355      * Operators can call {transferFrom} or {safeTransferFrom}
1356      * for any token owned by the caller.
1357      *
1358      * Requirements:
1359      *
1360      * - The `operator` cannot be the caller.
1361      *
1362      * Emits an {ApprovalForAll} event.
1363      */
1364     function setApprovalForAll(address operator, bool approved) public virtual override {
1365         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1366         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1367     }
1368 
1369     /**
1370      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1371      *
1372      * See {setApprovalForAll}.
1373      */
1374     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1375         return _operatorApprovals[owner][operator];
1376     }
1377 
1378     /**
1379      * @dev Returns whether `tokenId` exists.
1380      *
1381      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1382      *
1383      * Tokens start existing when they are minted. See {_mint}.
1384      */
1385     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1386         return
1387             _startTokenId() <= tokenId &&
1388             tokenId < _currentIndex && // If within bounds,
1389             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1390     }
1391 
1392     /**
1393      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1394      */
1395     function _isSenderApprovedOrOwner(
1396         address approvedAddress,
1397         address owner,
1398         address msgSender
1399     ) private pure returns (bool result) {
1400         assembly {
1401             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1402             owner := and(owner, _BITMASK_ADDRESS)
1403             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1404             msgSender := and(msgSender, _BITMASK_ADDRESS)
1405             // `msgSender == owner || msgSender == approvedAddress`.
1406             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1407         }
1408     }
1409 
1410     /**
1411      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1412      */
1413     function _getApprovedSlotAndAddress(uint256 tokenId)
1414         private
1415         view
1416         returns (uint256 approvedAddressSlot, address approvedAddress)
1417     {
1418         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1419         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1420         assembly {
1421             approvedAddressSlot := tokenApproval.slot
1422             approvedAddress := sload(approvedAddressSlot)
1423         }
1424     }
1425 
1426     // =============================================================
1427     //                      TRANSFER OPERATIONS
1428     // =============================================================
1429 
1430     /**
1431      * @dev Transfers `tokenId` from `from` to `to`.
1432      *
1433      * Requirements:
1434      *
1435      * - `from` cannot be the zero address.
1436      * - `to` cannot be the zero address.
1437      * - `tokenId` token must be owned by `from`.
1438      * - If the caller is not `from`, it must be approved to move this token
1439      * by either {approve} or {setApprovalForAll}.
1440      *
1441      * Emits a {Transfer} event.
1442      */
1443     function transferFrom(
1444         address from,
1445         address to,
1446         uint256 tokenId
1447     ) public payable virtual override {
1448         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1449 
1450         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1451 
1452         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1453 
1454         // The nested ifs save around 20+ gas over a compound boolean condition.
1455         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1456             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1457 
1458         if (to == address(0)) revert TransferToZeroAddress();
1459 
1460         _beforeTokenTransfers(from, to, tokenId, 1);
1461 
1462         // Clear approvals from the previous owner.
1463         assembly {
1464             if approvedAddress {
1465                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1466                 sstore(approvedAddressSlot, 0)
1467             }
1468         }
1469 
1470         // Underflow of the sender's balance is impossible because we check for
1471         // ownership above and the recipient's balance can't realistically overflow.
1472         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1473         unchecked {
1474             // We can directly increment and decrement the balances.
1475             --_packedAddressData[from]; // Updates: `balance -= 1`.
1476             ++_packedAddressData[to]; // Updates: `balance += 1`.
1477 
1478             // Updates:
1479             // - `address` to the next owner.
1480             // - `startTimestamp` to the timestamp of transfering.
1481             // - `burned` to `false`.
1482             // - `nextInitialized` to `true`.
1483             _packedOwnerships[tokenId] = _packOwnershipData(
1484                 to,
1485                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1486             );
1487 
1488             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1489             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1490                 uint256 nextTokenId = tokenId + 1;
1491                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1492                 if (_packedOwnerships[nextTokenId] == 0) {
1493                     // If the next slot is within bounds.
1494                     if (nextTokenId != _currentIndex) {
1495                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1496                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1497                     }
1498                 }
1499             }
1500         }
1501 
1502         emit Transfer(from, to, tokenId);
1503         _afterTokenTransfers(from, to, tokenId, 1);
1504     }
1505 
1506     /**
1507      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1508      */
1509     function safeTransferFrom(
1510         address from,
1511         address to,
1512         uint256 tokenId
1513     ) public payable virtual override {
1514         safeTransferFrom(from, to, tokenId, '');
1515     }
1516 
1517     /**
1518      * @dev Safely transfers `tokenId` token from `from` to `to`.
1519      *
1520      * Requirements:
1521      *
1522      * - `from` cannot be the zero address.
1523      * - `to` cannot be the zero address.
1524      * - `tokenId` token must exist and be owned by `from`.
1525      * - If the caller is not `from`, it must be approved to move this token
1526      * by either {approve} or {setApprovalForAll}.
1527      * - If `to` refers to a smart contract, it must implement
1528      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1529      *
1530      * Emits a {Transfer} event.
1531      */
1532     function safeTransferFrom(
1533         address from,
1534         address to,
1535         uint256 tokenId,
1536         bytes memory _data
1537     ) public payable virtual override {
1538         transferFrom(from, to, tokenId);
1539         if (to.code.length != 0)
1540             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1541                 revert TransferToNonERC721ReceiverImplementer();
1542             }
1543     }
1544 
1545     /**
1546      * @dev Hook that is called before a set of serially-ordered token IDs
1547      * are about to be transferred. This includes minting.
1548      * And also called before burning one token.
1549      *
1550      * `startTokenId` - the first token ID to be transferred.
1551      * `quantity` - the amount to be transferred.
1552      *
1553      * Calling conditions:
1554      *
1555      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1556      * transferred to `to`.
1557      * - When `from` is zero, `tokenId` will be minted for `to`.
1558      * - When `to` is zero, `tokenId` will be burned by `from`.
1559      * - `from` and `to` are never both zero.
1560      */
1561     function _beforeTokenTransfers(
1562         address from,
1563         address to,
1564         uint256 startTokenId,
1565         uint256 quantity
1566     ) internal virtual {}
1567 
1568     /**
1569      * @dev Hook that is called after a set of serially-ordered token IDs
1570      * have been transferred. This includes minting.
1571      * And also called after one token has been burned.
1572      *
1573      * `startTokenId` - the first token ID to be transferred.
1574      * `quantity` - the amount to be transferred.
1575      *
1576      * Calling conditions:
1577      *
1578      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1579      * transferred to `to`.
1580      * - When `from` is zero, `tokenId` has been minted for `to`.
1581      * - When `to` is zero, `tokenId` has been burned by `from`.
1582      * - `from` and `to` are never both zero.
1583      */
1584     function _afterTokenTransfers(
1585         address from,
1586         address to,
1587         uint256 startTokenId,
1588         uint256 quantity
1589     ) internal virtual {}
1590 
1591     /**
1592      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1593      *
1594      * `from` - Previous owner of the given token ID.
1595      * `to` - Target address that will receive the token.
1596      * `tokenId` - Token ID to be transferred.
1597      * `_data` - Optional data to send along with the call.
1598      *
1599      * Returns whether the call correctly returned the expected magic value.
1600      */
1601     function _checkContractOnERC721Received(
1602         address from,
1603         address to,
1604         uint256 tokenId,
1605         bytes memory _data
1606     ) private returns (bool) {
1607         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1608             bytes4 retval
1609         ) {
1610             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1611         } catch (bytes memory reason) {
1612             if (reason.length == 0) {
1613                 revert TransferToNonERC721ReceiverImplementer();
1614             } else {
1615                 assembly {
1616                     revert(add(32, reason), mload(reason))
1617                 }
1618             }
1619         }
1620     }
1621 
1622     // =============================================================
1623     //                        MINT OPERATIONS
1624     // =============================================================
1625 
1626     /**
1627      * @dev Mints `quantity` tokens and transfers them to `to`.
1628      *
1629      * Requirements:
1630      *
1631      * - `to` cannot be the zero address.
1632      * - `quantity` must be greater than 0.
1633      *
1634      * Emits a {Transfer} event for each mint.
1635      */
1636     function _mint(address to, uint256 quantity) internal virtual {
1637         uint256 startTokenId = _currentIndex;
1638         if (quantity == 0) revert MintZeroQuantity();
1639 
1640         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1641 
1642         // Overflows are incredibly unrealistic.
1643         // `balance` and `numberMinted` have a maximum limit of 2**64.
1644         // `tokenId` has a maximum limit of 2**256.
1645         unchecked {
1646             // Updates:
1647             // - `balance += quantity`.
1648             // - `numberMinted += quantity`.
1649             //
1650             // We can directly add to the `balance` and `numberMinted`.
1651             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1652 
1653             // Updates:
1654             // - `address` to the owner.
1655             // - `startTimestamp` to the timestamp of minting.
1656             // - `burned` to `false`.
1657             // - `nextInitialized` to `quantity == 1`.
1658             _packedOwnerships[startTokenId] = _packOwnershipData(
1659                 to,
1660                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1661             );
1662 
1663             uint256 toMasked;
1664             uint256 end = startTokenId + quantity;
1665 
1666             // Use assembly to loop and emit the `Transfer` event for gas savings.
1667             // The duplicated `log4` removes an extra check and reduces stack juggling.
1668             // The assembly, together with the surrounding Solidity code, have been
1669             // delicately arranged to nudge the compiler into producing optimized opcodes.
1670             assembly {
1671                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1672                 toMasked := and(to, _BITMASK_ADDRESS)
1673                 // Emit the `Transfer` event.
1674                 log4(
1675                     0, // Start of data (0, since no data).
1676                     0, // End of data (0, since no data).
1677                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1678                     0, // `address(0)`.
1679                     toMasked, // `to`.
1680                     startTokenId // `tokenId`.
1681                 )
1682 
1683                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1684                 // that overflows uint256 will make the loop run out of gas.
1685                 // The compiler will optimize the `iszero` away for performance.
1686                 for {
1687                     let tokenId := add(startTokenId, 1)
1688                 } iszero(eq(tokenId, end)) {
1689                     tokenId := add(tokenId, 1)
1690                 } {
1691                     // Emit the `Transfer` event. Similar to above.
1692                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1693                 }
1694             }
1695             if (toMasked == 0) revert MintToZeroAddress();
1696 
1697             _currentIndex = end;
1698         }
1699         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1700     }
1701 
1702     /**
1703      * @dev Mints `quantity` tokens and transfers them to `to`.
1704      *
1705      * This function is intended for efficient minting only during contract creation.
1706      *
1707      * It emits only one {ConsecutiveTransfer} as defined in
1708      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1709      * instead of a sequence of {Transfer} event(s).
1710      *
1711      * Calling this function outside of contract creation WILL make your contract
1712      * non-compliant with the ERC721 standard.
1713      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1714      * {ConsecutiveTransfer} event is only permissible during contract creation.
1715      *
1716      * Requirements:
1717      *
1718      * - `to` cannot be the zero address.
1719      * - `quantity` must be greater than 0.
1720      *
1721      * Emits a {ConsecutiveTransfer} event.
1722      */
1723     function _mintERC2309(address to, uint256 quantity) internal virtual {
1724         uint256 startTokenId = _currentIndex;
1725         if (to == address(0)) revert MintToZeroAddress();
1726         if (quantity == 0) revert MintZeroQuantity();
1727         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1728 
1729         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1730 
1731         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1732         unchecked {
1733             // Updates:
1734             // - `balance += quantity`.
1735             // - `numberMinted += quantity`.
1736             //
1737             // We can directly add to the `balance` and `numberMinted`.
1738             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1739 
1740             // Updates:
1741             // - `address` to the owner.
1742             // - `startTimestamp` to the timestamp of minting.
1743             // - `burned` to `false`.
1744             // - `nextInitialized` to `quantity == 1`.
1745             _packedOwnerships[startTokenId] = _packOwnershipData(
1746                 to,
1747                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1748             );
1749 
1750             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1751 
1752             _currentIndex = startTokenId + quantity;
1753         }
1754         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1755     }
1756 
1757     /**
1758      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1759      *
1760      * Requirements:
1761      *
1762      * - If `to` refers to a smart contract, it must implement
1763      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1764      * - `quantity` must be greater than 0.
1765      *
1766      * See {_mint}.
1767      *
1768      * Emits a {Transfer} event for each mint.
1769      */
1770     function _safeMint(
1771         address to,
1772         uint256 quantity,
1773         bytes memory _data
1774     ) internal virtual {
1775         _mint(to, quantity);
1776 
1777         unchecked {
1778             if (to.code.length != 0) {
1779                 uint256 end = _currentIndex;
1780                 uint256 index = end - quantity;
1781                 do {
1782                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1783                         revert TransferToNonERC721ReceiverImplementer();
1784                     }
1785                 } while (index < end);
1786                 // Reentrancy protection.
1787                 if (_currentIndex != end) revert();
1788             }
1789         }
1790     }
1791 
1792     /**
1793      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1794      */
1795     function _safeMint(address to, uint256 quantity) internal virtual {
1796         _safeMint(to, quantity, '');
1797     }
1798 
1799     // =============================================================
1800     //                        BURN OPERATIONS
1801     // =============================================================
1802 
1803     /**
1804      * @dev Equivalent to `_burn(tokenId, false)`.
1805      */
1806     function _burn(uint256 tokenId) internal virtual {
1807         _burn(tokenId, false);
1808     }
1809 
1810     /**
1811      * @dev Destroys `tokenId`.
1812      * The approval is cleared when the token is burned.
1813      *
1814      * Requirements:
1815      *
1816      * - `tokenId` must exist.
1817      *
1818      * Emits a {Transfer} event.
1819      */
1820     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1821         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1822 
1823         address from = address(uint160(prevOwnershipPacked));
1824 
1825         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1826 
1827         if (approvalCheck) {
1828             // The nested ifs save around 20+ gas over a compound boolean condition.
1829             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1830                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1831         }
1832 
1833         _beforeTokenTransfers(from, address(0), tokenId, 1);
1834 
1835         // Clear approvals from the previous owner.
1836         assembly {
1837             if approvedAddress {
1838                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1839                 sstore(approvedAddressSlot, 0)
1840             }
1841         }
1842 
1843         // Underflow of the sender's balance is impossible because we check for
1844         // ownership above and the recipient's balance can't realistically overflow.
1845         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1846         unchecked {
1847             // Updates:
1848             // - `balance -= 1`.
1849             // - `numberBurned += 1`.
1850             //
1851             // We can directly decrement the balance, and increment the number burned.
1852             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1853             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1854 
1855             // Updates:
1856             // - `address` to the last owner.
1857             // - `startTimestamp` to the timestamp of burning.
1858             // - `burned` to `true`.
1859             // - `nextInitialized` to `true`.
1860             _packedOwnerships[tokenId] = _packOwnershipData(
1861                 from,
1862                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1863             );
1864 
1865             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1866             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1867                 uint256 nextTokenId = tokenId + 1;
1868                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1869                 if (_packedOwnerships[nextTokenId] == 0) {
1870                     // If the next slot is within bounds.
1871                     if (nextTokenId != _currentIndex) {
1872                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1873                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1874                     }
1875                 }
1876             }
1877         }
1878 
1879         emit Transfer(from, address(0), tokenId);
1880         _afterTokenTransfers(from, address(0), tokenId, 1);
1881 
1882         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1883         unchecked {
1884             _burnCounter++;
1885         }
1886     }
1887 
1888     // =============================================================
1889     //                     EXTRA DATA OPERATIONS
1890     // =============================================================
1891 
1892     /**
1893      * @dev Directly sets the extra data for the ownership data `index`.
1894      */
1895     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1896         uint256 packed = _packedOwnerships[index];
1897         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1898         uint256 extraDataCasted;
1899         // Cast `extraData` with assembly to avoid redundant masking.
1900         assembly {
1901             extraDataCasted := extraData
1902         }
1903         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1904         _packedOwnerships[index] = packed;
1905     }
1906 
1907     /**
1908      * @dev Called during each token transfer to set the 24bit `extraData` field.
1909      * Intended to be overridden by the cosumer contract.
1910      *
1911      * `previousExtraData` - the value of `extraData` before transfer.
1912      *
1913      * Calling conditions:
1914      *
1915      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1916      * transferred to `to`.
1917      * - When `from` is zero, `tokenId` will be minted for `to`.
1918      * - When `to` is zero, `tokenId` will be burned by `from`.
1919      * - `from` and `to` are never both zero.
1920      */
1921     function _extraData(
1922         address from,
1923         address to,
1924         uint24 previousExtraData
1925     ) internal view virtual returns (uint24) {}
1926 
1927     /**
1928      * @dev Returns the next extra data for the packed ownership data.
1929      * The returned result is shifted into position.
1930      */
1931     function _nextExtraData(
1932         address from,
1933         address to,
1934         uint256 prevOwnershipPacked
1935     ) private view returns (uint256) {
1936         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1937         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1938     }
1939 
1940     // =============================================================
1941     //                       OTHER OPERATIONS
1942     // =============================================================
1943 
1944     /**
1945      * @dev Returns the message sender (defaults to `msg.sender`).
1946      *
1947      * If you are writing GSN compatible contracts, you need to override this function.
1948      */
1949     function _msgSenderERC721A() internal view virtual returns (address) {
1950         return msg.sender;
1951     }
1952 
1953     /**
1954      * @dev Converts a uint256 to its ASCII string decimal representation.
1955      */
1956     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1957         assembly {
1958             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1959             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1960             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1961             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1962             let m := add(mload(0x40), 0xa0)
1963             // Update the free memory pointer to allocate.
1964             mstore(0x40, m)
1965             // Assign the `str` to the end.
1966             str := sub(m, 0x20)
1967             // Zeroize the slot after the string.
1968             mstore(str, 0)
1969 
1970             // Cache the end of the memory to calculate the length later.
1971             let end := str
1972 
1973             // We write the string from rightmost digit to leftmost digit.
1974             // The following is essentially a do-while loop that also handles the zero case.
1975             // prettier-ignore
1976             for { let temp := value } 1 {} {
1977                 str := sub(str, 1)
1978                 // Write the character to the pointer.
1979                 // The ASCII index of the '0' character is 48.
1980                 mstore8(str, add(48, mod(temp, 10)))
1981                 // Keep dividing `temp` until zero.
1982                 temp := div(temp, 10)
1983                 // prettier-ignore
1984                 if iszero(temp) { break }
1985             }
1986 
1987             let length := sub(end, str)
1988             // Move the pointer 32 bytes leftwards to make room for the length.
1989             str := sub(str, 0x20)
1990             // Store the length.
1991             mstore(str, length)
1992         }
1993     }
1994 }
1995 
1996 // File: @openzeppelin/contracts/utils/Context.sol
1997 
1998 
1999 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2000 
2001 pragma solidity ^0.8.0;
2002 
2003 /**
2004  * @dev Provides information about the current execution context, including the
2005  * sender of the transaction and its data. While these are generally available
2006  * via msg.sender and msg.data, they should not be accessed in such a direct
2007  * manner, since when dealing with meta-transactions the account sending and
2008  * paying for execution may not be the actual sender (as far as an application
2009  * is concerned).
2010  *
2011  * This contract is only required for intermediate, library-like contracts.
2012  */
2013 abstract contract Context {
2014     function _msgSender() internal view virtual returns (address) {
2015         return msg.sender;
2016     }
2017 
2018     function _msgData() internal view virtual returns (bytes calldata) {
2019         return msg.data;
2020     }
2021 }
2022 
2023 // File: @openzeppelin/contracts/access/Ownable.sol
2024 
2025 
2026 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2027 
2028 pragma solidity ^0.8.0;
2029 
2030 
2031 /**
2032  * @dev Contract module which provides a basic access control mechanism, where
2033  * there is an account (an owner) that can be granted exclusive access to
2034  * specific functions.
2035  *
2036  * By default, the owner account will be the one that deploys the contract. This
2037  * can later be changed with {transferOwnership}.
2038  *
2039  * This module is used through inheritance. It will make available the modifier
2040  * `onlyOwner`, which can be applied to your functions to restrict their use to
2041  * the owner.
2042  */
2043 abstract contract Ownable is Context {
2044     address private _owner;
2045 
2046     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2047 
2048     /**
2049      * @dev Initializes the contract setting the deployer as the initial owner.
2050      */
2051     constructor() {
2052         _transferOwnership(_msgSender());
2053     }
2054 
2055     /**
2056      * @dev Throws if called by any account other than the owner.
2057      */
2058     modifier onlyOwner() {
2059         _checkOwner();
2060         _;
2061     }
2062 
2063     /**
2064      * @dev Returns the address of the current owner.
2065      */
2066     function owner() public view virtual returns (address) {
2067         return _owner;
2068     }
2069 
2070     /**
2071      * @dev Throws if the sender is not the owner.
2072      */
2073     function _checkOwner() internal view virtual {
2074         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2075     }
2076 
2077     /**
2078      * @dev Leaves the contract without owner. It will not be possible to call
2079      * `onlyOwner` functions anymore. Can only be called by the current owner.
2080      *
2081      * NOTE: Renouncing ownership will leave the contract without an owner,
2082      * thereby removing any functionality that is only available to the owner.
2083      */
2084     function renounceOwnership() public virtual onlyOwner {
2085         _transferOwnership(address(0));
2086     }
2087 
2088     /**
2089      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2090      * Can only be called by the current owner.
2091      */
2092     function transferOwnership(address newOwner) public virtual onlyOwner {
2093         require(newOwner != address(0), "Ownable: new owner is the zero address");
2094         _transferOwnership(newOwner);
2095     }
2096 
2097     /**
2098      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2099      * Internal function without access restriction.
2100      */
2101     function _transferOwnership(address newOwner) internal virtual {
2102         address oldOwner = _owner;
2103         _owner = newOwner;
2104         emit OwnershipTransferred(oldOwner, newOwner);
2105     }
2106 }
2107 
2108 
2109 
2110 //   _____       _                       _   _       _   _             
2111 //  /  __ \     | |                     | \ | |     | | (_)            
2112 //  | /  \/_   _| |__   ___  _ __ __ _  |  \| | __ _| |_ _  ___  _ __  
2113 //  | |   | | | | '_ \ / _ \| '__/ _` | | . ` |/ _` | __| |/ _ \| '_ \ 
2114 //  | \__/| |_| | |_) | (_) | | | (_| | | |\  | (_| | |_| | (_) | | | |
2115 //   \____/\__, |_.__/ \___/|_|  \__, | \_| \_/\__,_|\__|_|\___/|_| |_|
2116 //          __/ |                 __/ |                                
2117 //         |___/                 |___/       
2118 
2119         pragma solidity ^0.8.13;
2120 
2121 
2122 
2123 
2124 
2125 
2126         contract CyborgNation is ERC721A, Ownable, ReentrancyGuard  , DefaultOperatorFilterer{
2127             using Strings for uint256;
2128             uint256 public _maxSupply = 3333;
2129             uint256 public maxMintAmountPerWallet = 5;
2130             uint256 public maxMintAmountPerTx = 5;
2131             string baseURL = "";
2132             string ExtensionURL = ".json";
2133             uint256 _initalPrice = 0 ether;
2134             uint256 public costOfNFT = 0.003 ether;
2135             uint256 public numberOfFreeNFTs = 1;
2136             
2137             string HiddenURL;
2138             bool revealed = false;
2139             bool paused = true;
2140             
2141             error ContractPaused();
2142             error MaxMintWalletExceeded();
2143             error MaxSupply();
2144             error InvalidMintAmount();
2145             error InsufficientFund();
2146             error NoSmartContract();
2147             error TokenNotExisting();
2148 
2149         constructor(string memory _initBaseURI) ERC721A("CyborgNation", "CyborgN") {
2150             baseURL = _initBaseURI;
2151         }
2152 
2153         // ================== Mint Function =======================
2154 
2155         modifier mintCompliance(uint256 _mintAmount) {
2156             if (msg.sender != tx.origin) revert NoSmartContract();
2157             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2158             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2159             if(paused) revert ContractPaused();
2160             _;
2161         }
2162 
2163         modifier mintPriceCompliance(uint256 _mintAmount) {
2164             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2165             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2166               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2167             _;
2168         }
2169         
2170         /// @notice compliance of minting
2171         /// @dev user (msg.sender) mint
2172         /// @param _mintAmount the amount of tokens to mint
2173         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2174          
2175           
2176           _safeMint(msg.sender, _mintAmount);
2177           }
2178 
2179         /// @dev user (msg.sender) mint
2180         /// @param _mintAmount the amount of tokens to mint 
2181         /// @return value from number to mint
2182         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2183           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2184           if ((totalMints <= numberOfFreeNFTs) ) {
2185           return _initalPrice;
2186           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2187           uint256 total = costOfNFT * (_mintAmount - numberOfFreeNFTs);
2188           return total;
2189           } 
2190           else {
2191           uint256 total2 = costOfNFT * _mintAmount;
2192           return total2;
2193             }
2194         }
2195         
2196 
2197 
2198         /// @notice airdrop function to airdrop same amount of tokens to addresses
2199         /// @dev only owner function
2200         /// @param accounts  array of addresses
2201         /// @param amount the amount of tokens to airdrop users
2202         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2203           for(uint256 i = 0; i < accounts.length; i++){
2204           _safeMint(accounts[i], amount);
2205           }
2206         }
2207 
2208         // =================== Orange Functions (Owner Only) ===============
2209 
2210         /// @dev pause/unpause minting
2211         function pause() public onlyOwner {
2212           paused = !paused;
2213         }
2214 
2215         
2216 
2217         /// @dev set URI
2218         /// @param uri  new URI
2219         function setbaseURL(string memory uri) public onlyOwner{
2220           baseURL = uri;
2221         }
2222 
2223         /// @dev extension URI like 'json'
2224         function setExtensionURL(string memory uri) public onlyOwner{
2225           ExtensionURL = uri;
2226         }
2227         
2228         /// @dev set new cost of tokenId in WEI
2229         /// @param _cost  new price in wei
2230         function setCostPrice(uint256 _cost) public onlyOwner{
2231           costOfNFT = _cost;
2232         } 
2233 
2234         /// @dev only owner
2235         /// @param supply  new max supply
2236         function setSupply(uint256 supply) public onlyOwner{
2237           _maxSupply = supply;
2238         }
2239 
2240         /// @dev only owner
2241         /// @param perTx  new max mint per transaction
2242         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2243           maxMintAmountPerTx = perTx;
2244         }
2245 
2246         /// @dev only owner
2247         /// @param perWallet  new max mint per wallet
2248         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2249           maxMintAmountPerWallet = perWallet;
2250         }  
2251         
2252         /// @dev only owner
2253         /// @param perWallet set free number of nft per wallet
2254         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2255           numberOfFreeNFTs = perWallet;
2256         }            
2257 
2258         // ================================ Withdraw Function ====================
2259 
2260         /// @notice withdraw ether from contract.
2261         /// @dev only owner function
2262         function withdraw() public onlyOwner nonReentrant{
2263           
2264 
2265           
2266 
2267         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2268         require(owner);
2269         }
2270         // =================== Blue Functions (View Only) ====================
2271 
2272         /// @dev return uri of token ID
2273         /// @param tokenId  token ID to find uri for
2274         ///@return value for 'tokenId uri'
2275         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2276           if (!_exists(tokenId)) revert TokenNotExisting();   
2277 
2278         
2279 
2280         string memory currentBaseURI = _baseURI();
2281         return bytes(currentBaseURI).length > 0
2282         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ExtensionURL))
2283         : '';
2284         }
2285         
2286         /// @dev tokenId to start (1)
2287         function _startTokenId() internal view virtual override returns (uint256) {
2288           return 1;
2289         }
2290 
2291         ///@dev maxSupply of token
2292         /// @return max supply
2293         function _baseURI() internal view virtual override returns (string memory) {
2294           return baseURL;
2295         }
2296 
2297     
2298         /// @dev internal function to 
2299         /// @param from  user address where token belongs
2300         /// @param to  user address
2301         /// @param tokenId  number of tokenId
2302           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2303         super.transferFrom(from, to, tokenId);
2304         }
2305         
2306         /// @dev internal function to 
2307         /// @param from  user address where token belongs
2308         /// @param to  user address
2309         /// @param tokenId  number of tokenId
2310         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2311         super.safeTransferFrom(from, to, tokenId);
2312         }
2313 
2314         /// @dev internal function to 
2315         /// @param from  user address where token belongs
2316         /// @param to  user address
2317         /// @param tokenId  number of tokenId
2318         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2319         public payable
2320         override
2321         onlyAllowedOperator(from)
2322         {
2323         super.safeTransferFrom(from, to, tokenId, data);
2324         }
2325         
2326 
2327 }