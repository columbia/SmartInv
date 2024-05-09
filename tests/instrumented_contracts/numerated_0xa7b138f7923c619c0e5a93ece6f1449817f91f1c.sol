1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-09
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-03-10
7 */
8 
9 // SPDX-License-Identifier: MIT
10 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
11                                                                                                                                      
12                                                                                                                                                                                                                                                                     
13                                                                                                                                      
14 
15 pragma solidity ^0.8.13;
16 
17 interface IOperatorFilterRegistry {
18     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
19     function register(address registrant) external;
20     function registerAndSubscribe(address registrant, address subscription) external;
21     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
22     function unregister(address addr) external;
23     function updateOperator(address registrant, address operator, bool filtered) external;
24     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
25     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
26     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
27     function subscribe(address registrant, address registrantToSubscribe) external;
28     function unsubscribe(address registrant, bool copyExistingEntries) external;
29     function subscriptionOf(address addr) external returns (address registrant);
30     function subscribers(address registrant) external returns (address[] memory);
31     function subscriberAt(address registrant, uint256 index) external returns (address);
32     function copyEntriesOf(address registrant, address registrantToCopy) external;
33     function isOperatorFiltered(address registrant, address operator) external returns (bool);
34     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
35     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
36     function filteredOperators(address addr) external returns (address[] memory);
37     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
38     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
39     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
40     function isRegistered(address addr) external returns (bool);
41     function codeHashOf(address addr) external returns (bytes32);
42 }
43 
44 // File: operator-filter-registry/src/OperatorFilterer.sol
45 
46 
47 pragma solidity ^0.8.13;
48 
49 
50 /**
51  * @title  OperatorFilterer
52  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
53  *         registrant's entries in the OperatorFilterRegistry.
54  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
55  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
56  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
57  */
58 abstract contract OperatorFilterer {
59     error OperatorNotAllowed(address operator);
60 
61     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
62         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
63 
64     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
65         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
66         // will not revert, but the contract will need to be registered with the registry once it is deployed in
67         // order for the modifier to filter addresses.
68         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
69             if (subscribe) {
70                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
71             } else {
72                 if (subscriptionOrRegistrantToCopy != address(0)) {
73                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
74                 } else {
75                     OPERATOR_FILTER_REGISTRY.register(address(this));
76                 }
77             }
78         }
79     }
80 
81     modifier onlyAllowedOperator(address from) virtual {
82         // Allow spending tokens from addresses with balance
83         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
84         // from an EOA.
85         if (from != msg.sender) {
86             _checkFilterOperator(msg.sender);
87         }
88         _;
89     }
90 
91     modifier onlyAllowedOperatorApproval(address operator) virtual {
92         _checkFilterOperator(operator);
93         _;
94     }
95 
96     function _checkFilterOperator(address operator) internal view virtual {
97         // Check registry code length to facilitate testing in environments without a deployed registry.
98         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
99             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
100                 revert OperatorNotAllowed(operator);
101             }
102         }
103     }
104 }
105 
106 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
107 
108 
109 pragma solidity ^0.8.13;
110 
111 
112 /**
113  * @title  DefaultOperatorFilterer
114  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
115  */
116 abstract contract DefaultOperatorFilterer is OperatorFilterer {
117     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
118 
119     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
120 }
121 
122 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
123 
124 
125 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
126 
127 pragma solidity ^0.8.0;
128 
129 /**
130  * @dev Contract module that helps prevent reentrant calls to a function.
131  *
132  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
133  * available, which can be applied to functions to make sure there are no nested
134  * (reentrant) calls to them.
135  *
136  * Note that because there is a single `nonReentrant` guard, functions marked as
137  * `nonReentrant` may not call one another. This can be worked around by making
138  * those functions `private`, and then adding `external` `nonReentrant` entry
139  * points to them.
140  *
141  * TIP: If you would like to learn more about reentrancy and alternative ways
142  * to protect against it, check out our blog post
143  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
144  */
145 abstract contract ReentrancyGuard {
146     // Booleans are more expensive than uint256 or any type that takes up a full
147     // word because each write operation emits an extra SLOAD to first read the
148     // slot's contents, replace the bits taken up by the boolean, and then write
149     // back. This is the compiler's defense against contract upgrades and
150     // pointer aliasing, and it cannot be disabled.
151 
152     // The values being non-zero value makes deployment a bit more expensive,
153     // but in exchange the refund on every call to nonReentrant will be lower in
154     // amount. Since refunds are capped to a percentage of the total
155     // transaction's gas, it is best to keep them low in cases like this one, to
156     // increase the likelihood of the full refund coming into effect.
157     uint256 private constant _NOT_ENTERED = 1;
158     uint256 private constant _ENTERED = 2;
159 
160     uint256 private _status;
161 
162     constructor() {
163         _status = _NOT_ENTERED;
164     }
165 
166     /**
167      * @dev Prevents a contract from calling itself, directly or indirectly.
168      * Calling a `nonReentrant` function from another `nonReentrant`
169      * function is not supported. It is possible to prevent this from happening
170      * by making the `nonReentrant` function external, and making it call a
171      * `private` function that does the actual work.
172      */
173     modifier nonReentrant() {
174         _nonReentrantBefore();
175         _;
176         _nonReentrantAfter();
177     }
178 
179     function _nonReentrantBefore() private {
180         // On the first call to nonReentrant, _status will be _NOT_ENTERED
181         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
182 
183         // Any calls to nonReentrant after this point will fail
184         _status = _ENTERED;
185     }
186 
187     function _nonReentrantAfter() private {
188         // By storing the original value once again, a refund is triggered (see
189         // https://eips.ethereum.org/EIPS/eip-2200)
190         _status = _NOT_ENTERED;
191     }
192 }
193 
194 // File: @openzeppelin/contracts/utils/math/Math.sol
195 
196 
197 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Standard math utilities missing in the Solidity language.
203  */
204 library Math {
205     enum Rounding {
206         Down, // Toward negative infinity
207         Up, // Toward infinity
208         Zero // Toward zero
209     }
210 
211     /**
212      * @dev Returns the largest of two numbers.
213      */
214     function max(uint256 a, uint256 b) internal pure returns (uint256) {
215         return a > b ? a : b;
216     }
217 
218     /**
219      * @dev Returns the smallest of two numbers.
220      */
221     function min(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a < b ? a : b;
223     }
224 
225     /**
226      * @dev Returns the average of two numbers. The result is rounded towards
227      * zero.
228      */
229     function average(uint256 a, uint256 b) internal pure returns (uint256) {
230         // (a + b) / 2 can overflow.
231         return (a & b) + (a ^ b) / 2;
232     }
233 
234     /**
235      * @dev Returns the ceiling of the division of two numbers.
236      *
237      * This differs from standard division with `/` in that it rounds up instead
238      * of rounding down.
239      */
240     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
241         // (a + b - 1) / b can overflow on addition, so we distribute.
242         return a == 0 ? 0 : (a - 1) / b + 1;
243     }
244 
245     /**
246      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
247      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
248      * with further edits by Uniswap Labs also under MIT license.
249      */
250     function mulDiv(
251         uint256 x,
252         uint256 y,
253         uint256 denominator
254     ) internal pure returns (uint256 result) {
255         unchecked {
256             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
257             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
258             // variables such that product = prod1 * 2^256 + prod0.
259             uint256 prod0; // Least significant 256 bits of the product
260             uint256 prod1; // Most significant 256 bits of the product
261             assembly {
262                 let mm := mulmod(x, y, not(0))
263                 prod0 := mul(x, y)
264                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
265             }
266 
267             // Handle non-overflow cases, 256 by 256 division.
268             if (prod1 == 0) {
269                 return prod0 / denominator;
270             }
271 
272             // Make sure the result is less than 2^256. Also prevents denominator == 0.
273             require(denominator > prod1);
274 
275             ///////////////////////////////////////////////
276             // 512 by 256 division.
277             ///////////////////////////////////////////////
278 
279             // Make division exact by subtracting the remainder from [prod1 prod0].
280             uint256 remainder;
281             assembly {
282                 // Compute remainder using mulmod.
283                 remainder := mulmod(x, y, denominator)
284 
285                 // Subtract 256 bit number from 512 bit number.
286                 prod1 := sub(prod1, gt(remainder, prod0))
287                 prod0 := sub(prod0, remainder)
288             }
289 
290             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
291             // See https://cs.stackexchange.com/q/138556/92363.
292 
293             // Does not overflow because the denominator cannot be zero at this stage in the function.
294             uint256 twos = denominator & (~denominator + 1);
295             assembly {
296                 // Divide denominator by twos.
297                 denominator := div(denominator, twos)
298 
299                 // Divide [prod1 prod0] by twos.
300                 prod0 := div(prod0, twos)
301 
302                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
303                 twos := add(div(sub(0, twos), twos), 1)
304             }
305 
306             // Shift in bits from prod1 into prod0.
307             prod0 |= prod1 * twos;
308 
309             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
310             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
311             // four bits. That is, denominator * inv = 1 mod 2^4.
312             uint256 inverse = (3 * denominator) ^ 2;
313 
314             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
315             // in modular arithmetic, doubling the correct bits in each step.
316             inverse *= 2 - denominator * inverse; // inverse mod 2^8
317             inverse *= 2 - denominator * inverse; // inverse mod 2^16
318             inverse *= 2 - denominator * inverse; // inverse mod 2^32
319             inverse *= 2 - denominator * inverse; // inverse mod 2^64
320             inverse *= 2 - denominator * inverse; // inverse mod 2^128
321             inverse *= 2 - denominator * inverse; // inverse mod 2^256
322 
323             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
324             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
325             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
326             // is no longer required.
327             result = prod0 * inverse;
328             return result;
329         }
330     }
331 
332     /**
333      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
334      */
335     function mulDiv(
336         uint256 x,
337         uint256 y,
338         uint256 denominator,
339         Rounding rounding
340     ) internal pure returns (uint256) {
341         uint256 result = mulDiv(x, y, denominator);
342         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
343             result += 1;
344         }
345         return result;
346     }
347 
348     /**
349      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
350      *
351      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
352      */
353     function sqrt(uint256 a) internal pure returns (uint256) {
354         if (a == 0) {
355             return 0;
356         }
357 
358         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
359         //
360         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
361         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
362         //
363         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
364         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
365         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
366         //
367         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
368         uint256 result = 1 << (log2(a) >> 1);
369 
370         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
371         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
372         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
373         // into the expected uint128 result.
374         unchecked {
375             result = (result + a / result) >> 1;
376             result = (result + a / result) >> 1;
377             result = (result + a / result) >> 1;
378             result = (result + a / result) >> 1;
379             result = (result + a / result) >> 1;
380             result = (result + a / result) >> 1;
381             result = (result + a / result) >> 1;
382             return min(result, a / result);
383         }
384     }
385 
386     /**
387      * @notice Calculates sqrt(a), following the selected rounding direction.
388      */
389     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
390         unchecked {
391             uint256 result = sqrt(a);
392             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
393         }
394     }
395 
396     /**
397      * @dev Return the log in base 2, rounded down, of a positive value.
398      * Returns 0 if given 0.
399      */
400     function log2(uint256 value) internal pure returns (uint256) {
401         uint256 result = 0;
402         unchecked {
403             if (value >> 128 > 0) {
404                 value >>= 128;
405                 result += 128;
406             }
407             if (value >> 64 > 0) {
408                 value >>= 64;
409                 result += 64;
410             }
411             if (value >> 32 > 0) {
412                 value >>= 32;
413                 result += 32;
414             }
415             if (value >> 16 > 0) {
416                 value >>= 16;
417                 result += 16;
418             }
419             if (value >> 8 > 0) {
420                 value >>= 8;
421                 result += 8;
422             }
423             if (value >> 4 > 0) {
424                 value >>= 4;
425                 result += 4;
426             }
427             if (value >> 2 > 0) {
428                 value >>= 2;
429                 result += 2;
430             }
431             if (value >> 1 > 0) {
432                 result += 1;
433             }
434         }
435         return result;
436     }
437 
438     /**
439      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
440      * Returns 0 if given 0.
441      */
442     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
443         unchecked {
444             uint256 result = log2(value);
445             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
446         }
447     }
448 
449     /**
450      * @dev Return the log in base 10, rounded down, of a positive value.
451      * Returns 0 if given 0.
452      */
453     function log10(uint256 value) internal pure returns (uint256) {
454         uint256 result = 0;
455         unchecked {
456             if (value >= 10**64) {
457                 value /= 10**64;
458                 result += 64;
459             }
460             if (value >= 10**32) {
461                 value /= 10**32;
462                 result += 32;
463             }
464             if (value >= 10**16) {
465                 value /= 10**16;
466                 result += 16;
467             }
468             if (value >= 10**8) {
469                 value /= 10**8;
470                 result += 8;
471             }
472             if (value >= 10**4) {
473                 value /= 10**4;
474                 result += 4;
475             }
476             if (value >= 10**2) {
477                 value /= 10**2;
478                 result += 2;
479             }
480             if (value >= 10**1) {
481                 result += 1;
482             }
483         }
484         return result;
485     }
486 
487     /**
488      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
489      * Returns 0 if given 0.
490      */
491     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
492         unchecked {
493             uint256 result = log10(value);
494             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
495         }
496     }
497 
498     /**
499      * @dev Return the log in base 256, rounded down, of a positive value.
500      * Returns 0 if given 0.
501      *
502      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
503      */
504     function log256(uint256 value) internal pure returns (uint256) {
505         uint256 result = 0;
506         unchecked {
507             if (value >> 128 > 0) {
508                 value >>= 128;
509                 result += 16;
510             }
511             if (value >> 64 > 0) {
512                 value >>= 64;
513                 result += 8;
514             }
515             if (value >> 32 > 0) {
516                 value >>= 32;
517                 result += 4;
518             }
519             if (value >> 16 > 0) {
520                 value >>= 16;
521                 result += 2;
522             }
523             if (value >> 8 > 0) {
524                 result += 1;
525             }
526         }
527         return result;
528     }
529 
530     /**
531      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
532      * Returns 0 if given 0.
533      */
534     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
535         unchecked {
536             uint256 result = log256(value);
537             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
538         }
539     }
540 }
541 
542 // File: @openzeppelin/contracts/utils/Strings.sol
543 
544 
545 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
546 
547 pragma solidity ^0.8.0;
548 
549 
550 /**
551  * @dev String operations.
552  */
553 library Strings {
554     bytes16 private constant _SYMBOLS = "0123456789abcdef";
555     uint8 private constant _ADDRESS_LENGTH = 20;
556 
557     /**
558      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
559      */
560     function toString(uint256 value) internal pure returns (string memory) {
561         unchecked {
562             uint256 length = Math.log10(value) + 1;
563             string memory buffer = new string(length);
564             uint256 ptr;
565             /// @solidity memory-safe-assembly
566             assembly {
567                 ptr := add(buffer, add(32, length))
568             }
569             while (true) {
570                 ptr--;
571                 /// @solidity memory-safe-assembly
572                 assembly {
573                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
574                 }
575                 value /= 10;
576                 if (value == 0) break;
577             }
578             return buffer;
579         }
580     }
581 
582     /**
583      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
584      */
585     function toHexString(uint256 value) internal pure returns (string memory) {
586         unchecked {
587             return toHexString(value, Math.log256(value) + 1);
588         }
589     }
590 
591     /**
592      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
593      */
594     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
595         bytes memory buffer = new bytes(2 * length + 2);
596         buffer[0] = "0";
597         buffer[1] = "x";
598         for (uint256 i = 2 * length + 1; i > 1; --i) {
599             buffer[i] = _SYMBOLS[value & 0xf];
600             value >>= 4;
601         }
602         require(value == 0, "Strings: hex length insufficient");
603         return string(buffer);
604     }
605 
606     /**
607      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
608      */
609     function toHexString(address addr) internal pure returns (string memory) {
610         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
611     }
612 }
613 
614 // File: erc721a/contracts/IERC721A.sol
615 
616 
617 // ERC721A Contracts v4.2.3
618 // Creator: Chiru Labs
619 
620 pragma solidity ^0.8.4;
621 
622 /**
623  * @dev Interface of ERC721A.
624  */
625 interface IERC721A {
626     /**
627      * The caller must own the token or be an approved operator.
628      */
629     error ApprovalCallerNotOwnerNorApproved();
630 
631     /**
632      * The token does not exist.
633      */
634     error ApprovalQueryForNonexistentToken();
635 
636     /**
637      * Cannot query the balance for the zero address.
638      */
639     error BalanceQueryForZeroAddress();
640 
641     /**
642      * Cannot mint to the zero address.
643      */
644     error MintToZeroAddress();
645 
646     /**
647      * The quantity of tokens minted must be more than zero.
648      */
649     error MintZeroQuantity();
650 
651     /**
652      * The token does not exist.
653      */
654     error OwnerQueryForNonexistentToken();
655 
656     /**
657      * The caller must own the token or be an approved operator.
658      */
659     error TransferCallerNotOwnerNorApproved();
660 
661     /**
662      * The token must be owned by `from`.
663      */
664     error TransferFromIncorrectOwner();
665 
666     /**
667      * Cannot safely transfer to a contract that does not implement the
668      * ERC721Receiver interface.
669      */
670     error TransferToNonERC721ReceiverImplementer();
671 
672     /**
673      * Cannot transfer to the zero address.
674      */
675     error TransferToZeroAddress();
676 
677     /**
678      * The token does not exist.
679      */
680     error URIQueryForNonexistentToken();
681 
682     /**
683      * The `quantity` minted with ERC2309 exceeds the safety limit.
684      */
685     error MintERC2309QuantityExceedsLimit();
686 
687     /**
688      * The `extraData` cannot be set on an unintialized ownership slot.
689      */
690     error OwnershipNotInitializedForExtraData();
691 
692     // =============================================================
693     //                            STRUCTS
694     // =============================================================
695 
696     struct TokenOwnership {
697         // The address of the owner.
698         address addr;
699         // Stores the start time of ownership with minimal overhead for tokenomics.
700         uint64 startTimestamp;
701         // Whether the token has been burned.
702         bool burned;
703         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
704         uint24 extraData;
705     }
706 
707     // =============================================================
708     //                         TOKEN COUNTERS
709     // =============================================================
710 
711     /**
712      * @dev Returns the total number of tokens in existence.
713      * Burned tokens will reduce the count.
714      * To get the total number of tokens minted, please see {_totalMinted}.
715      */
716     function totalSupply() external view returns (uint256);
717 
718     // =============================================================
719     //                            IERC165
720     // =============================================================
721 
722     /**
723      * @dev Returns true if this contract implements the interface defined by
724      * `interfaceId`. See the corresponding
725      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
726      * to learn more about how these ids are created.
727      *
728      * This function call must use less than 30000 gas.
729      */
730     function supportsInterface(bytes4 interfaceId) external view returns (bool);
731 
732     // =============================================================
733     //                            IERC721
734     // =============================================================
735 
736     /**
737      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
738      */
739     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
740 
741     /**
742      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
743      */
744     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
745 
746     /**
747      * @dev Emitted when `owner` enables or disables
748      * (`approved`) `operator` to manage all of its assets.
749      */
750     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
751 
752     /**
753      * @dev Returns the number of tokens in `owner`'s account.
754      */
755     function balanceOf(address owner) external view returns (uint256 balance);
756 
757     /**
758      * @dev Returns the owner of the `tokenId` token.
759      *
760      * Requirements:
761      *
762      * - `tokenId` must exist.
763      */
764     function ownerOf(uint256 tokenId) external view returns (address owner);
765 
766     /**
767      * @dev Safely transfers `tokenId` token from `from` to `to`,
768      * checking first that contract recipients are aware of the ERC721 protocol
769      * to prevent tokens from being forever locked.
770      *
771      * Requirements:
772      *
773      * - `from` cannot be the zero address.
774      * - `to` cannot be the zero address.
775      * - `tokenId` token must exist and be owned by `from`.
776      * - If the caller is not `from`, it must be have been allowed to move
777      * this token by either {approve} or {setApprovalForAll}.
778      * - If `to` refers to a smart contract, it must implement
779      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
780      *
781      * Emits a {Transfer} event.
782      */
783     function safeTransferFrom(
784         address from,
785         address to,
786         uint256 tokenId,
787         bytes calldata data
788     ) external payable;
789 
790     /**
791      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
792      */
793     function safeTransferFrom(
794         address from,
795         address to,
796         uint256 tokenId
797     ) external payable;
798 
799     /**
800      * @dev Transfers `tokenId` from `from` to `to`.
801      *
802      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
803      * whenever possible.
804      *
805      * Requirements:
806      *
807      * - `from` cannot be the zero address.
808      * - `to` cannot be the zero address.
809      * - `tokenId` token must be owned by `from`.
810      * - If the caller is not `from`, it must be approved to move this token
811      * by either {approve} or {setApprovalForAll}.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transferFrom(
816         address from,
817         address to,
818         uint256 tokenId
819     ) external payable;
820 
821     /**
822      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
823      * The approval is cleared when the token is transferred.
824      *
825      * Only a single account can be approved at a time, so approving the
826      * zero address clears previous approvals.
827      *
828      * Requirements:
829      *
830      * - The caller must own the token or be an approved operator.
831      * - `tokenId` must exist.
832      *
833      * Emits an {Approval} event.
834      */
835     function approve(address to, uint256 tokenId) external payable;
836 
837     /**
838      * @dev Approve or remove `operator` as an operator for the caller.
839      * Operators can call {transferFrom} or {safeTransferFrom}
840      * for any token owned by the caller.
841      *
842      * Requirements:
843      *
844      * - The `operator` cannot be the caller.
845      *
846      * Emits an {ApprovalForAll} event.
847      */
848     function setApprovalForAll(address operator, bool _approved) external;
849 
850     /**
851      * @dev Returns the account approved for `tokenId` token.
852      *
853      * Requirements:
854      *
855      * - `tokenId` must exist.
856      */
857     function getApproved(uint256 tokenId) external view returns (address operator);
858 
859     /**
860      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
861      *
862      * See {setApprovalForAll}.
863      */
864     function isApprovedForAll(address owner, address operator) external view returns (bool);
865 
866     // =============================================================
867     //                        IERC721Metadata
868     // =============================================================
869 
870     /**
871      * @dev Returns the token collection name.
872      */
873     function name() external view returns (string memory);
874 
875     /**
876      * @dev Returns the token collection symbol.
877      */
878     function symbol() external view returns (string memory);
879 
880     /**
881      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
882      */
883     function tokenURI(uint256 tokenId) external view returns (string memory);
884 
885     // =============================================================
886     //                           IERC2309
887     // =============================================================
888 
889     /**
890      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
891      * (inclusive) is transferred from `from` to `to`, as defined in the
892      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
893      *
894      * See {_mintERC2309} for more details.
895      */
896     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
897 }
898 
899 // File: erc721a/contracts/ERC721A.sol
900 
901 
902 // ERC721A Contracts v4.2.3
903 // Creator: Chiru Labs
904 
905 pragma solidity ^0.8.4;
906 
907 
908 /**
909  * @dev Interface of ERC721 token receiver.
910  */
911 interface ERC721A__IERC721Receiver {
912     function onERC721Received(
913         address operator,
914         address from,
915         uint256 tokenId,
916         bytes calldata data
917     ) external returns (bytes4);
918 }
919 
920 /**
921  * @title ERC721A
922  *
923  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
924  * Non-Fungible Token Standard, including the Metadata extension.
925  * Optimized for lower gas during batch mints.
926  *
927  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
928  * starting from `_startTokenId()`.
929  *
930  * Assumptions:
931  *
932  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
933  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
934  */
935 contract ERC721A is IERC721A {
936     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
937     struct TokenApprovalRef {
938         address value;
939     }
940 
941     // =============================================================
942     //                           CONSTANTS
943     // =============================================================
944 
945     // Mask of an entry in packed address data.
946     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
947 
948     // The bit position of `numberMinted` in packed address data.
949     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
950 
951     // The bit position of `numberBurned` in packed address data.
952     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
953 
954     // The bit position of `aux` in packed address data.
955     uint256 private constant _BITPOS_AUX = 192;
956 
957     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
958     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
959 
960     // The bit position of `startTimestamp` in packed ownership.
961     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
962 
963     // The bit mask of the `burned` bit in packed ownership.
964     uint256 private constant _BITMASK_BURNED = 1 << 224;
965 
966     // The bit position of the `nextInitialized` bit in packed ownership.
967     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
968 
969     // The bit mask of the `nextInitialized` bit in packed ownership.
970     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
971 
972     // The bit position of `extraData` in packed ownership.
973     uint256 private constant _BITPOS_EXTRA_DATA = 232;
974 
975     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
976     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
977 
978     // The mask of the lower 160 bits for addresses.
979     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
980 
981     // The maximum `quantity` that can be minted with {_mintERC2309}.
982     // This limit is to prevent overflows on the address data entries.
983     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
984     // is required to cause an overflow, which is unrealistic.
985     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
986 
987     // The `Transfer` event signature is given by:
988     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
989     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
990         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
991 
992     // =============================================================
993     //                            STORAGE
994     // =============================================================
995 
996     // The next token ID to be minted.
997     uint256 private _currentIndex;
998 
999     // The number of tokens burned.
1000     uint256 private _burnCounter;
1001 
1002     // Token name
1003     string private _name;
1004 
1005     // Token symbol
1006     string private _symbol;
1007 
1008     // Mapping from token ID to ownership details
1009     // An empty struct value does not necessarily mean the token is unowned.
1010     // See {_packedOwnershipOf} implementation for details.
1011     //
1012     // Bits Layout:
1013     // - [0..159]   `addr`
1014     // - [160..223] `startTimestamp`
1015     // - [224]      `burned`
1016     // - [225]      `nextInitialized`
1017     // - [232..255] `extraData`
1018     mapping(uint256 => uint256) private _packedOwnerships;
1019 
1020     // Mapping owner address to address data.
1021     //
1022     // Bits Layout:
1023     // - [0..63]    `balance`
1024     // - [64..127]  `numberMinted`
1025     // - [128..191] `numberBurned`
1026     // - [192..255] `aux`
1027     mapping(address => uint256) private _packedAddressData;
1028 
1029     // Mapping from token ID to approved address.
1030     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1031 
1032     // Mapping from owner to operator approvals
1033     mapping(address => mapping(address => bool)) private _operatorApprovals;
1034 
1035     // =============================================================
1036     //                          CONSTRUCTOR
1037     // =============================================================
1038 
1039     constructor(string memory name_, string memory symbol_) {
1040         _name = name_;
1041         _symbol = symbol_;
1042         _currentIndex = _startTokenId();
1043     }
1044 
1045     // =============================================================
1046     //                   TOKEN COUNTING OPERATIONS
1047     // =============================================================
1048 
1049     /**
1050      * @dev Returns the starting token ID.
1051      * To change the starting token ID, please override this function.
1052      */
1053     function _startTokenId() internal view virtual returns (uint256) {
1054         return 0;
1055     }
1056 
1057     /**
1058      * @dev Returns the next token ID to be minted.
1059      */
1060     function _nextTokenId() internal view virtual returns (uint256) {
1061         return _currentIndex;
1062     }
1063 
1064     /**
1065      * @dev Returns the total number of tokens in existence.
1066      * Burned tokens will reduce the count.
1067      * To get the total number of tokens minted, please see {_totalMinted}.
1068      */
1069     function totalSupply() public view virtual override returns (uint256) {
1070         // Counter underflow is impossible as _burnCounter cannot be incremented
1071         // more than `_currentIndex - _startTokenId()` times.
1072         unchecked {
1073             return _currentIndex - _burnCounter - _startTokenId();
1074         }
1075     }
1076 
1077     /**
1078      * @dev Returns the total amount of tokens minted in the contract.
1079      */
1080     function _totalMinted() internal view virtual returns (uint256) {
1081         // Counter underflow is impossible as `_currentIndex` does not decrement,
1082         // and it is initialized to `_startTokenId()`.
1083         unchecked {
1084             return _currentIndex - _startTokenId();
1085         }
1086     }
1087 
1088     /**
1089      * @dev Returns the total number of tokens burned.
1090      */
1091     function _totalBurned() internal view virtual returns (uint256) {
1092         return _burnCounter;
1093     }
1094 
1095     // =============================================================
1096     //                    ADDRESS DATA OPERATIONS
1097     // =============================================================
1098 
1099     /**
1100      * @dev Returns the number of tokens in `owner`'s account.
1101      */
1102     function balanceOf(address owner) public view virtual override returns (uint256) {
1103         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1104         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1105     }
1106 
1107     /**
1108      * Returns the number of tokens minted by `owner`.
1109      */
1110     function _numberMinted(address owner) internal view returns (uint256) {
1111         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1112     }
1113 
1114     /**
1115      * Returns the number of tokens burned by or on behalf of `owner`.
1116      */
1117     function _numberBurned(address owner) internal view returns (uint256) {
1118         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1119     }
1120 
1121     /**
1122      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1123      */
1124     function _getAux(address owner) internal view returns (uint64) {
1125         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1126     }
1127 
1128     /**
1129      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1130      * If there are multiple variables, please pack them into a uint64.
1131      */
1132     function _setAux(address owner, uint64 aux) internal virtual {
1133         uint256 packed = _packedAddressData[owner];
1134         uint256 auxCasted;
1135         // Cast `aux` with assembly to avoid redundant masking.
1136         assembly {
1137             auxCasted := aux
1138         }
1139         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1140         _packedAddressData[owner] = packed;
1141     }
1142 
1143     // =============================================================
1144     //                            IERC165
1145     // =============================================================
1146 
1147     /**
1148      * @dev Returns true if this contract implements the interface defined by
1149      * `interfaceId`. See the corresponding
1150      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1151      * to learn more about how these ids are created.
1152      *
1153      * This function call must use less than 30000 gas.
1154      */
1155     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1156         // The interface IDs are constants representing the first 4 bytes
1157         // of the XOR of all function selectors in the interface.
1158         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1159         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1160         return
1161             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1162             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1163             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1164     }
1165 
1166     // =============================================================
1167     //                        IERC721Metadata
1168     // =============================================================
1169 
1170     /**
1171      * @dev Returns the token collection name.
1172      */
1173     function name() public view virtual override returns (string memory) {
1174         return _name;
1175     }
1176 
1177     /**
1178      * @dev Returns the token collection symbol.
1179      */
1180     function symbol() public view virtual override returns (string memory) {
1181         return _symbol;
1182     }
1183 
1184     /**
1185      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1186      */
1187     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1188         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1189 
1190         string memory baseURI = _baseURI();
1191         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1192     }
1193 
1194     /**
1195      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1196      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1197      * by default, it can be overridden in child contracts.
1198      */
1199     function _baseURI() internal view virtual returns (string memory) {
1200         return '';
1201     }
1202 
1203     // =============================================================
1204     //                     OWNERSHIPS OPERATIONS
1205     // =============================================================
1206 
1207     /**
1208      * @dev Returns the owner of the `tokenId` token.
1209      *
1210      * Requirements:
1211      *
1212      * - `tokenId` must exist.
1213      */
1214     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1215         return address(uint160(_packedOwnershipOf(tokenId)));
1216     }
1217 
1218     /**
1219      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1220      * It gradually moves to O(1) as tokens get transferred around over time.
1221      */
1222     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1223         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1224     }
1225 
1226     /**
1227      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1228      */
1229     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1230         return _unpackedOwnership(_packedOwnerships[index]);
1231     }
1232 
1233     /**
1234      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1235      */
1236     function _initializeOwnershipAt(uint256 index) internal virtual {
1237         if (_packedOwnerships[index] == 0) {
1238             _packedOwnerships[index] = _packedOwnershipOf(index);
1239         }
1240     }
1241 
1242     /**
1243      * Returns the packed ownership data of `tokenId`.
1244      */
1245     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1246         uint256 curr = tokenId;
1247 
1248         unchecked {
1249             if (_startTokenId() <= curr)
1250                 if (curr < _currentIndex) {
1251                     uint256 packed = _packedOwnerships[curr];
1252                     // If not burned.
1253                     if (packed & _BITMASK_BURNED == 0) {
1254                         // Invariant:
1255                         // There will always be an initialized ownership slot
1256                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1257                         // before an unintialized ownership slot
1258                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1259                         // Hence, `curr` will not underflow.
1260                         //
1261                         // We can directly compare the packed value.
1262                         // If the address is zero, packed will be zero.
1263                         while (packed == 0) {
1264                             packed = _packedOwnerships[--curr];
1265                         }
1266                         return packed;
1267                     }
1268                 }
1269         }
1270         revert OwnerQueryForNonexistentToken();
1271     }
1272 
1273     /**
1274      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1275      */
1276     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1277         ownership.addr = address(uint160(packed));
1278         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1279         ownership.burned = packed & _BITMASK_BURNED != 0;
1280         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1281     }
1282 
1283     /**
1284      * @dev Packs ownership data into a single uint256.
1285      */
1286     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1287         assembly {
1288             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1289             owner := and(owner, _BITMASK_ADDRESS)
1290             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1291             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1292         }
1293     }
1294 
1295     /**
1296      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1297      */
1298     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1299         // For branchless setting of the `nextInitialized` flag.
1300         assembly {
1301             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1302             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1303         }
1304     }
1305 
1306     // =============================================================
1307     //                      APPROVAL OPERATIONS
1308     // =============================================================
1309 
1310     /**
1311      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1312      * The approval is cleared when the token is transferred.
1313      *
1314      * Only a single account can be approved at a time, so approving the
1315      * zero address clears previous approvals.
1316      *
1317      * Requirements:
1318      *
1319      * - The caller must own the token or be an approved operator.
1320      * - `tokenId` must exist.
1321      *
1322      * Emits an {Approval} event.
1323      */
1324     function approve(address to, uint256 tokenId) public payable virtual override {
1325         address owner = ownerOf(tokenId);
1326 
1327         if (_msgSenderERC721A() != owner)
1328             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1329                 revert ApprovalCallerNotOwnerNorApproved();
1330             }
1331 
1332         _tokenApprovals[tokenId].value = to;
1333         emit Approval(owner, to, tokenId);
1334     }
1335 
1336     /**
1337      * @dev Returns the account approved for `tokenId` token.
1338      *
1339      * Requirements:
1340      *
1341      * - `tokenId` must exist.
1342      */
1343     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1344         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1345 
1346         return _tokenApprovals[tokenId].value;
1347     }
1348 
1349     /**
1350      * @dev Approve or remove `operator` as an operator for the caller.
1351      * Operators can call {transferFrom} or {safeTransferFrom}
1352      * for any token owned by the caller.
1353      *
1354      * Requirements:
1355      *
1356      * - The `operator` cannot be the caller.
1357      *
1358      * Emits an {ApprovalForAll} event.
1359      */
1360     function setApprovalForAll(address operator, bool approved) public virtual override {
1361         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1362         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1363     }
1364 
1365     /**
1366      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1367      *
1368      * See {setApprovalForAll}.
1369      */
1370     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1371         return _operatorApprovals[owner][operator];
1372     }
1373 
1374     /**
1375      * @dev Returns whether `tokenId` exists.
1376      *
1377      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1378      *
1379      * Tokens start existing when they are minted. See {_mint}.
1380      */
1381     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1382         return
1383             _startTokenId() <= tokenId &&
1384             tokenId < _currentIndex && // If within bounds,
1385             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1386     }
1387 
1388     /**
1389      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1390      */
1391     function _isSenderApprovedOrOwner(
1392         address approvedAddress,
1393         address owner,
1394         address msgSender
1395     ) private pure returns (bool result) {
1396         assembly {
1397             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1398             owner := and(owner, _BITMASK_ADDRESS)
1399             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1400             msgSender := and(msgSender, _BITMASK_ADDRESS)
1401             // `msgSender == owner || msgSender == approvedAddress`.
1402             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1403         }
1404     }
1405 
1406     /**
1407      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1408      */
1409     function _getApprovedSlotAndAddress(uint256 tokenId)
1410         private
1411         view
1412         returns (uint256 approvedAddressSlot, address approvedAddress)
1413     {
1414         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1415         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1416         assembly {
1417             approvedAddressSlot := tokenApproval.slot
1418             approvedAddress := sload(approvedAddressSlot)
1419         }
1420     }
1421 
1422     // =============================================================
1423     //                      TRANSFER OPERATIONS
1424     // =============================================================
1425 
1426     /**
1427      * @dev Transfers `tokenId` from `from` to `to`.
1428      *
1429      * Requirements:
1430      *
1431      * - `from` cannot be the zero address.
1432      * - `to` cannot be the zero address.
1433      * - `tokenId` token must be owned by `from`.
1434      * - If the caller is not `from`, it must be approved to move this token
1435      * by either {approve} or {setApprovalForAll}.
1436      *
1437      * Emits a {Transfer} event.
1438      */
1439     function transferFrom(
1440         address from,
1441         address to,
1442         uint256 tokenId
1443     ) public payable virtual override {
1444         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1445 
1446         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1447 
1448         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1449 
1450         // The nested ifs save around 20+ gas over a compound boolean condition.
1451         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1452             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1453 
1454         if (to == address(0)) revert TransferToZeroAddress();
1455 
1456         _beforeTokenTransfers(from, to, tokenId, 1);
1457 
1458         // Clear approvals from the previous owner.
1459         assembly {
1460             if approvedAddress {
1461                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1462                 sstore(approvedAddressSlot, 0)
1463             }
1464         }
1465 
1466         // Underflow of the sender's balance is impossible because we check for
1467         // ownership above and the recipient's balance can't realistically overflow.
1468         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1469         unchecked {
1470             // We can directly increment and decrement the balances.
1471             --_packedAddressData[from]; // Updates: `balance -= 1`.
1472             ++_packedAddressData[to]; // Updates: `balance += 1`.
1473 
1474             // Updates:
1475             // - `address` to the next owner.
1476             // - `startTimestamp` to the timestamp of transfering.
1477             // - `burned` to `false`.
1478             // - `nextInitialized` to `true`.
1479             _packedOwnerships[tokenId] = _packOwnershipData(
1480                 to,
1481                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1482             );
1483 
1484             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1485             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1486                 uint256 nextTokenId = tokenId + 1;
1487                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1488                 if (_packedOwnerships[nextTokenId] == 0) {
1489                     // If the next slot is within bounds.
1490                     if (nextTokenId != _currentIndex) {
1491                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1492                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1493                     }
1494                 }
1495             }
1496         }
1497 
1498         emit Transfer(from, to, tokenId);
1499         _afterTokenTransfers(from, to, tokenId, 1);
1500     }
1501 
1502     /**
1503      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1504      */
1505     function safeTransferFrom(
1506         address from,
1507         address to,
1508         uint256 tokenId
1509     ) public payable virtual override {
1510         safeTransferFrom(from, to, tokenId, '');
1511     }
1512 
1513     /**
1514      * @dev Safely transfers `tokenId` token from `from` to `to`.
1515      *
1516      * Requirements:
1517      *
1518      * - `from` cannot be the zero address.
1519      * - `to` cannot be the zero address.
1520      * - `tokenId` token must exist and be owned by `from`.
1521      * - If the caller is not `from`, it must be approved to move this token
1522      * by either {approve} or {setApprovalForAll}.
1523      * - If `to` refers to a smart contract, it must implement
1524      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1525      *
1526      * Emits a {Transfer} event.
1527      */
1528     function safeTransferFrom(
1529         address from,
1530         address to,
1531         uint256 tokenId,
1532         bytes memory _data
1533     ) public payable virtual override {
1534         transferFrom(from, to, tokenId);
1535         if (to.code.length != 0)
1536             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1537                 revert TransferToNonERC721ReceiverImplementer();
1538             }
1539     }
1540 
1541     /**
1542      * @dev Hook that is called before a set of serially-ordered token IDs
1543      * are about to be transferred. This includes minting.
1544      * And also called before burning one token.
1545      *
1546      * `startTokenId` - the first token ID to be transferred.
1547      * `quantity` - the amount to be transferred.
1548      *
1549      * Calling conditions:
1550      *
1551      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1552      * transferred to `to`.
1553      * - When `from` is zero, `tokenId` will be minted for `to`.
1554      * - When `to` is zero, `tokenId` will be burned by `from`.
1555      * - `from` and `to` are never both zero.
1556      */
1557     function _beforeTokenTransfers(
1558         address from,
1559         address to,
1560         uint256 startTokenId,
1561         uint256 quantity
1562     ) internal virtual {}
1563 
1564     /**
1565      * @dev Hook that is called after a set of serially-ordered token IDs
1566      * have been transferred. This includes minting.
1567      * And also called after one token has been burned.
1568      *
1569      * `startTokenId` - the first token ID to be transferred.
1570      * `quantity` - the amount to be transferred.
1571      *
1572      * Calling conditions:
1573      *
1574      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1575      * transferred to `to`.
1576      * - When `from` is zero, `tokenId` has been minted for `to`.
1577      * - When `to` is zero, `tokenId` has been burned by `from`.
1578      * - `from` and `to` are never both zero.
1579      */
1580     function _afterTokenTransfers(
1581         address from,
1582         address to,
1583         uint256 startTokenId,
1584         uint256 quantity
1585     ) internal virtual {}
1586 
1587     /**
1588      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1589      *
1590      * `from` - Previous owner of the given token ID.
1591      * `to` - Target address that will receive the token.
1592      * `tokenId` - Token ID to be transferred.
1593      * `_data` - Optional data to send along with the call.
1594      *
1595      * Returns whether the call correctly returned the expected magic value.
1596      */
1597     function _checkContractOnERC721Received(
1598         address from,
1599         address to,
1600         uint256 tokenId,
1601         bytes memory _data
1602     ) private returns (bool) {
1603         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1604             bytes4 retval
1605         ) {
1606             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1607         } catch (bytes memory reason) {
1608             if (reason.length == 0) {
1609                 revert TransferToNonERC721ReceiverImplementer();
1610             } else {
1611                 assembly {
1612                     revert(add(32, reason), mload(reason))
1613                 }
1614             }
1615         }
1616     }
1617 
1618     // =============================================================
1619     //                        MINT OPERATIONS
1620     // =============================================================
1621 
1622     /**
1623      * @dev Mints `quantity` tokens and transfers them to `to`.
1624      *
1625      * Requirements:
1626      *
1627      * - `to` cannot be the zero address.
1628      * - `quantity` must be greater than 0.
1629      *
1630      * Emits a {Transfer} event for each mint.
1631      */
1632     function _mint(address to, uint256 quantity) internal virtual {
1633         uint256 startTokenId = _currentIndex;
1634         if (quantity == 0) revert MintZeroQuantity();
1635 
1636         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1637 
1638         // Overflows are incredibly unrealistic.
1639         // `balance` and `numberMinted` have a maximum limit of 2**64.
1640         // `tokenId` has a maximum limit of 2**256.
1641         unchecked {
1642             // Updates:
1643             // - `balance += quantity`.
1644             // - `numberMinted += quantity`.
1645             //
1646             // We can directly add to the `balance` and `numberMinted`.
1647             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1648 
1649             // Updates:
1650             // - `address` to the owner.
1651             // - `startTimestamp` to the timestamp of minting.
1652             // - `burned` to `false`.
1653             // - `nextInitialized` to `quantity == 1`.
1654             _packedOwnerships[startTokenId] = _packOwnershipData(
1655                 to,
1656                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1657             );
1658 
1659             uint256 toMasked;
1660             uint256 end = startTokenId + quantity;
1661 
1662             // Use assembly to loop and emit the `Transfer` event for gas savings.
1663             // The duplicated `log4` removes an extra check and reduces stack juggling.
1664             // The assembly, together with the surrounding Solidity code, have been
1665             // delicately arranged to nudge the compiler into producing optimized opcodes.
1666             assembly {
1667                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1668                 toMasked := and(to, _BITMASK_ADDRESS)
1669                 // Emit the `Transfer` event.
1670                 log4(
1671                     0, // Start of data (0, since no data).
1672                     0, // End of data (0, since no data).
1673                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1674                     0, // `address(0)`.
1675                     toMasked, // `to`.
1676                     startTokenId // `tokenId`.
1677                 )
1678 
1679                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1680                 // that overflows uint256 will make the loop run out of gas.
1681                 // The compiler will optimize the `iszero` away for performance.
1682                 for {
1683                     let tokenId := add(startTokenId, 1)
1684                 } iszero(eq(tokenId, end)) {
1685                     tokenId := add(tokenId, 1)
1686                 } {
1687                     // Emit the `Transfer` event. Similar to above.
1688                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1689                 }
1690             }
1691             if (toMasked == 0) revert MintToZeroAddress();
1692 
1693             _currentIndex = end;
1694         }
1695         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1696     }
1697 
1698     /**
1699      * @dev Mints `quantity` tokens and transfers them to `to`.
1700      *
1701      * This function is intended for efficient minting only during contract creation.
1702      *
1703      * It emits only one {ConsecutiveTransfer} as defined in
1704      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1705      * instead of a sequence of {Transfer} event(s).
1706      *
1707      * Calling this function outside of contract creation WILL make your contract
1708      * non-compliant with the ERC721 standard.
1709      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1710      * {ConsecutiveTransfer} event is only permissible during contract creation.
1711      *
1712      * Requirements:
1713      *
1714      * - `to` cannot be the zero address.
1715      * - `quantity` must be greater than 0.
1716      *
1717      * Emits a {ConsecutiveTransfer} event.
1718      */
1719     function _mintERC2309(address to, uint256 quantity) internal virtual {
1720         uint256 startTokenId = _currentIndex;
1721         if (to == address(0)) revert MintToZeroAddress();
1722         if (quantity == 0) revert MintZeroQuantity();
1723         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1724 
1725         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1726 
1727         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1728         unchecked {
1729             // Updates:
1730             // - `balance += quantity`.
1731             // - `numberMinted += quantity`.
1732             //
1733             // We can directly add to the `balance` and `numberMinted`.
1734             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1735 
1736             // Updates:
1737             // - `address` to the owner.
1738             // - `startTimestamp` to the timestamp of minting.
1739             // - `burned` to `false`.
1740             // - `nextInitialized` to `quantity == 1`.
1741             _packedOwnerships[startTokenId] = _packOwnershipData(
1742                 to,
1743                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1744             );
1745 
1746             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1747 
1748             _currentIndex = startTokenId + quantity;
1749         }
1750         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1751     }
1752 
1753     /**
1754      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1755      *
1756      * Requirements:
1757      *
1758      * - If `to` refers to a smart contract, it must implement
1759      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1760      * - `quantity` must be greater than 0.
1761      *
1762      * See {_mint}.
1763      *
1764      * Emits a {Transfer} event for each mint.
1765      */
1766     function _safeMint(
1767         address to,
1768         uint256 quantity,
1769         bytes memory _data
1770     ) internal virtual {
1771         _mint(to, quantity);
1772 
1773         unchecked {
1774             if (to.code.length != 0) {
1775                 uint256 end = _currentIndex;
1776                 uint256 index = end - quantity;
1777                 do {
1778                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1779                         revert TransferToNonERC721ReceiverImplementer();
1780                     }
1781                 } while (index < end);
1782                 // Reentrancy protection.
1783                 if (_currentIndex != end) revert();
1784             }
1785         }
1786     }
1787 
1788     /**
1789      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1790      */
1791     function _safeMint(address to, uint256 quantity) internal virtual {
1792         _safeMint(to, quantity, '');
1793     }
1794 
1795     // =============================================================
1796     //                        BURN OPERATIONS
1797     // =============================================================
1798 
1799     /**
1800      * @dev Equivalent to `_burn(tokenId, false)`.
1801      */
1802     function _burn(uint256 tokenId) internal virtual {
1803         _burn(tokenId, false);
1804     }
1805 
1806     /**
1807      * @dev Destroys `tokenId`.
1808      * The approval is cleared when the token is burned.
1809      *
1810      * Requirements:
1811      *
1812      * - `tokenId` must exist.
1813      *
1814      * Emits a {Transfer} event.
1815      */
1816     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1817         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1818 
1819         address from = address(uint160(prevOwnershipPacked));
1820 
1821         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1822 
1823         if (approvalCheck) {
1824             // The nested ifs save around 20+ gas over a compound boolean condition.
1825             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1826                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1827         }
1828 
1829         _beforeTokenTransfers(from, address(0), tokenId, 1);
1830 
1831         // Clear approvals from the previous owner.
1832         assembly {
1833             if approvedAddress {
1834                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1835                 sstore(approvedAddressSlot, 0)
1836             }
1837         }
1838 
1839         // Underflow of the sender's balance is impossible because we check for
1840         // ownership above and the recipient's balance can't realistically overflow.
1841         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1842         unchecked {
1843             // Updates:
1844             // - `balance -= 1`.
1845             // - `numberBurned += 1`.
1846             //
1847             // We can directly decrement the balance, and increment the number burned.
1848             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1849             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1850 
1851             // Updates:
1852             // - `address` to the last owner.
1853             // - `startTimestamp` to the timestamp of burning.
1854             // - `burned` to `true`.
1855             // - `nextInitialized` to `true`.
1856             _packedOwnerships[tokenId] = _packOwnershipData(
1857                 from,
1858                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1859             );
1860 
1861             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1862             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1863                 uint256 nextTokenId = tokenId + 1;
1864                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1865                 if (_packedOwnerships[nextTokenId] == 0) {
1866                     // If the next slot is within bounds.
1867                     if (nextTokenId != _currentIndex) {
1868                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1869                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1870                     }
1871                 }
1872             }
1873         }
1874 
1875         emit Transfer(from, address(0), tokenId);
1876         _afterTokenTransfers(from, address(0), tokenId, 1);
1877 
1878         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1879         unchecked {
1880             _burnCounter++;
1881         }
1882     }
1883 
1884     // =============================================================
1885     //                     EXTRA DATA OPERATIONS
1886     // =============================================================
1887 
1888     /**
1889      * @dev Directly sets the extra data for the ownership data `index`.
1890      */
1891     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1892         uint256 packed = _packedOwnerships[index];
1893         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1894         uint256 extraDataCasted;
1895         // Cast `extraData` with assembly to avoid redundant masking.
1896         assembly {
1897             extraDataCasted := extraData
1898         }
1899         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1900         _packedOwnerships[index] = packed;
1901     }
1902 
1903     /**
1904      * @dev Called during each token transfer to set the 24bit `extraData` field.
1905      * Intended to be overridden by the cosumer contract.
1906      *
1907      * `previousExtraData` - the value of `extraData` before transfer.
1908      *
1909      * Calling conditions:
1910      *
1911      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1912      * transferred to `to`.
1913      * - When `from` is zero, `tokenId` will be minted for `to`.
1914      * - When `to` is zero, `tokenId` will be burned by `from`.
1915      * - `from` and `to` are never both zero.
1916      */
1917     function _extraData(
1918         address from,
1919         address to,
1920         uint24 previousExtraData
1921     ) internal view virtual returns (uint24) {}
1922 
1923     /**
1924      * @dev Returns the next extra data for the packed ownership data.
1925      * The returned result is shifted into position.
1926      */
1927     function _nextExtraData(
1928         address from,
1929         address to,
1930         uint256 prevOwnershipPacked
1931     ) private view returns (uint256) {
1932         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1933         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1934     }
1935 
1936     // =============================================================
1937     //                       OTHER OPERATIONS
1938     // =============================================================
1939 
1940     /**
1941      * @dev Returns the message sender (defaults to `msg.sender`).
1942      *
1943      * If you are writing GSN compatible contracts, you need to override this function.
1944      */
1945     function _msgSenderERC721A() internal view virtual returns (address) {
1946         return msg.sender;
1947     }
1948 
1949     /**
1950      * @dev Converts a uint256 to its ASCII string decimal representation.
1951      */
1952     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1953         assembly {
1954             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1955             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1956             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1957             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1958             let m := add(mload(0x40), 0xa0)
1959             // Update the free memory pointer to allocate.
1960             mstore(0x40, m)
1961             // Assign the `str` to the end.
1962             str := sub(m, 0x20)
1963             // Zeroize the slot after the string.
1964             mstore(str, 0)
1965 
1966             // Cache the end of the memory to calculate the length later.
1967             let end := str
1968 
1969             // We write the string from rightmost digit to leftmost digit.
1970             // The following is essentially a do-while loop that also handles the zero case.
1971             // prettier-ignore
1972             for { let temp := value } 1 {} {
1973                 str := sub(str, 1)
1974                 // Write the character to the pointer.
1975                 // The ASCII index of the '0' character is 48.
1976                 mstore8(str, add(48, mod(temp, 10)))
1977                 // Keep dividing `temp` until zero.
1978                 temp := div(temp, 10)
1979                 // prettier-ignore
1980                 if iszero(temp) { break }
1981             }
1982 
1983             let length := sub(end, str)
1984             // Move the pointer 32 bytes leftwards to make room for the length.
1985             str := sub(str, 0x20)
1986             // Store the length.
1987             mstore(str, length)
1988         }
1989     }
1990 }
1991 
1992 // File: @openzeppelin/contracts/utils/Context.sol
1993 
1994 
1995 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1996 
1997 pragma solidity ^0.8.0;
1998 
1999 /**
2000  * @dev Provides information about the current execution context, including the
2001  * sender of the transaction and its data. While these are generally available
2002  * via msg.sender and msg.data, they should not be accessed in such a direct
2003  * manner, since when dealing with meta-transactions the account sending and
2004  * paying for execution may not be the actual sender (as far as an application
2005  * is concerned).
2006  *
2007  * This contract is only required for intermediate, library-like contracts.
2008  */
2009 abstract contract Context {
2010     function _msgSender() internal view virtual returns (address) {
2011         return msg.sender;
2012     }
2013 
2014     function _msgData() internal view virtual returns (bytes calldata) {
2015         return msg.data;
2016     }
2017 }
2018 
2019 // File: @openzeppelin/contracts/access/Ownable.sol
2020 
2021 
2022 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2023 
2024 pragma solidity ^0.8.0;
2025 
2026 
2027 /**
2028  * @dev Contract module which provides a basic access control mechanism, where
2029  * there is an account (an owner) that can be granted exclusive access to
2030  * specific functions.
2031  *
2032  * By default, the owner account will be the one that deploys the contract. This
2033  * can later be changed with {transferOwnership}.
2034  *
2035  * This module is used through inheritance. It will make available the modifier
2036  * `onlyOwner`, which can be applied to your functions to restrict their use to
2037  * the owner.
2038  */
2039 abstract contract Ownable is Context {
2040     address private _owner;
2041 
2042     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2043 
2044     /**
2045      * @dev Initializes the contract setting the deployer as the initial owner.
2046      */
2047     constructor() {
2048         _transferOwnership(_msgSender());
2049     }
2050 
2051     /**
2052      * @dev Throws if called by any account other than the owner.
2053      */
2054     modifier onlyOwner() {
2055         _checkOwner();
2056         _;
2057     }
2058 
2059     /**
2060      * @dev Returns the address of the current owner.
2061      */
2062     function owner() public view virtual returns (address) {
2063         return _owner;
2064     }
2065 
2066     /**
2067      * @dev Throws if the sender is not the owner.
2068      */
2069     function _checkOwner() internal view virtual {
2070         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2071     }
2072 
2073     /**
2074      * @dev Leaves the contract without owner. It will not be possible to call
2075      * `onlyOwner` functions anymore. Can only be called by the current owner.
2076      *
2077      * NOTE: Renouncing ownership will leave the contract without an owner,
2078      * thereby removing any functionality that is only available to the owner.
2079      */
2080     function renounceOwnership() public virtual onlyOwner {
2081         _transferOwnership(address(0));
2082     }
2083 
2084     /**
2085      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2086      * Can only be called by the current owner.
2087      */
2088     function transferOwnership(address newOwner) public virtual onlyOwner {
2089         require(newOwner != address(0), "Ownable: new owner is the zero address");
2090         _transferOwnership(newOwner);
2091     }
2092 
2093     /**
2094      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2095      * Internal function without access restriction.
2096      */
2097     function _transferOwnership(address newOwner) internal virtual {
2098         address oldOwner = _owner;
2099         _owner = newOwner;
2100         emit OwnershipTransferred(oldOwner, newOwner);
2101     }
2102 }
2103 
2104 
2105         pragma solidity ^0.8.13;
2106 
2107 
2108 
2109 
2110 
2111 
2112         contract Bored is ERC721A, Ownable, ReentrancyGuard  , DefaultOperatorFilterer{
2113             using Strings for uint256;
2114             uint256 public _maxSupply = 999;
2115             uint256 public maxMintAmountPerWallet = 3;
2116             uint256 public maxMintAmountPerTx = 3;
2117             string baseURL = "";
2118             string ExtensionURL = ".json";
2119             uint256 _initalPrice = 0 ether;
2120             uint256 public costOfNFT = 0.003 ether;
2121             uint256 public numberOfFreeNFTs = 1;
2122             
2123             string HiddenURL;
2124             bool revealed = false;
2125             bool paused = true;
2126             
2127             error ContractPaused();
2128             error MaxMintWalletExceeded();
2129             error MaxSupply();
2130             error InvalidMintAmount();
2131             error InsufficientFund();
2132             error NoSmartContract();
2133             error TokenNotExisting();
2134 
2135         constructor(string memory _initBaseURI) ERC721A("Just a Bored Profile Picture", "BORED") {
2136             baseURL = _initBaseURI;
2137         }
2138 
2139         // ================== Mint Function =======================
2140 
2141         modifier mintCompliance(uint256 _mintAmount) {
2142             if (msg.sender != tx.origin) revert NoSmartContract();
2143             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2144             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2145             if(paused) revert ContractPaused();
2146             _;
2147         }
2148 
2149         modifier mintPriceCompliance(uint256 _mintAmount) {
2150             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2151             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2152               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2153             _;
2154         }
2155         
2156         /// @notice compliance of minting
2157         /// @dev user (msg.sender) mint
2158         /// @param _mintAmount the amount of tokens to mint
2159         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2160          
2161           
2162           _safeMint(msg.sender, _mintAmount);
2163           }
2164 
2165         /// @dev user (msg.sender) mint
2166         /// @param _mintAmount the amount of tokens to mint 
2167         /// @return value from number to mint
2168         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2169           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2170           if ((totalMints <= numberOfFreeNFTs) ) {
2171           return _initalPrice;
2172           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2173           uint256 total = costOfNFT * _mintAmount;
2174           return total;
2175           } 
2176           else {
2177           uint256 total2 = costOfNFT * _mintAmount;
2178           return total2;
2179             }
2180         }
2181         
2182 
2183 
2184         /// @notice airdrop function to airdrop same amount of tokens to addresses
2185         /// @dev only owner function
2186         /// @param accounts  array of addresses
2187         /// @param amount the amount of tokens to airdrop users
2188         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2189           for(uint256 i = 0; i < accounts.length; i++){
2190           _safeMint(accounts[i], amount);
2191           }
2192         }
2193 
2194         // =================== Orange Functions (Owner Only) ===============
2195 
2196         /// @dev pause/unpause minting
2197         function pause() public onlyOwner {
2198           paused = !paused;
2199         }
2200 
2201         
2202 
2203         /// @dev set URI
2204         /// @param uri  new URI
2205         function setbaseURL(string memory uri) public onlyOwner{
2206           baseURL = uri;
2207         }
2208 
2209         /// @dev extension URI like 'json'
2210         function setExtensionURL(string memory uri) public onlyOwner{
2211           ExtensionURL = uri;
2212         }
2213         
2214         /// @dev set new cost of tokenId in WEI
2215         /// @param _cost  new price in wei
2216         function setCostPrice(uint256 _cost) public onlyOwner{
2217           costOfNFT = _cost;
2218         } 
2219 
2220         /// @dev only owner
2221         /// @param perTx  new max mint per transaction
2222         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2223           maxMintAmountPerTx = perTx;
2224         }
2225 
2226         /// @dev only owner
2227         /// @param perWallet  new max mint per wallet
2228         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2229           maxMintAmountPerWallet = perWallet;
2230         }  
2231         
2232         /// @dev only owner
2233         /// @param perWallet set free number of nft per wallet
2234         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2235           numberOfFreeNFTs = perWallet;
2236         }            
2237 
2238         // ================================ Withdraw Function ====================
2239 
2240         /// @notice withdraw ether from contract.
2241         /// @dev only owner function
2242         function withdraw() public onlyOwner nonReentrant{
2243           
2244 
2245           
2246 
2247         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2248         require(owner);
2249         }
2250         // =================== Blue Functions (View Only) ====================
2251 
2252         /// @dev return uri of token ID
2253         /// @param tokenId  token ID to find uri for
2254         ///@return value for 'tokenId uri'
2255         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2256           if (!_exists(tokenId)) revert TokenNotExisting();   
2257 
2258         
2259 
2260         string memory currentBaseURI = _baseURI();
2261         return bytes(currentBaseURI).length > 0
2262         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2263         : '';
2264         }
2265         
2266         /// @dev tokenId to start (1)
2267         function _startTokenId() internal view virtual override returns (uint256) {
2268           return 1;
2269         }
2270 
2271         ///@dev maxSupply of token
2272         /// @return max supply
2273         function _baseURI() internal view virtual override returns (string memory) {
2274           return baseURL;
2275         }
2276 
2277     
2278         /// @dev internal function to 
2279         /// @param from  user address where token belongs
2280         /// @param to  user address
2281         /// @param tokenId  number of tokenId
2282           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2283         super.transferFrom(from, to, tokenId);
2284         }
2285         
2286         /// @dev internal function to 
2287         /// @param from  user address where token belongs
2288         /// @param to  user address
2289         /// @param tokenId  number of tokenId
2290         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2291         super.safeTransferFrom(from, to, tokenId);
2292         }
2293 
2294         /// @dev internal function to 
2295         /// @param from  user address where token belongs
2296         /// @param to  user address
2297         /// @param tokenId  number of tokenId
2298         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2299         public payable
2300         override
2301         onlyAllowedOperator(from)
2302         {
2303         super.safeTransferFrom(from, to, tokenId, data);
2304         }
2305         
2306 
2307 }