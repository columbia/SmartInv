1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3                                                                                                                                      
4                                                                                                                                                                                                                                                                     
5                                                                                                                                      
6 
7 pragma solidity ^0.8.13;
8 
9 interface IOperatorFilterRegistry {
10     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
11     function register(address registrant) external;
12     function registerAndSubscribe(address registrant, address subscription) external;
13     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
14     function unregister(address addr) external;
15     function updateOperator(address registrant, address operator, bool filtered) external;
16     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
17     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
18     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
19     function subscribe(address registrant, address registrantToSubscribe) external;
20     function unsubscribe(address registrant, bool copyExistingEntries) external;
21     function subscriptionOf(address addr) external returns (address registrant);
22     function subscribers(address registrant) external returns (address[] memory);
23     function subscriberAt(address registrant, uint256 index) external returns (address);
24     function copyEntriesOf(address registrant, address registrantToCopy) external;
25     function isOperatorFiltered(address registrant, address operator) external returns (bool);
26     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
27     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
28     function filteredOperators(address addr) external returns (address[] memory);
29     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
30     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
31     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
32     function isRegistered(address addr) external returns (bool);
33     function codeHashOf(address addr) external returns (bytes32);
34 }
35 
36 // File: operator-filter-registry/src/OperatorFilterer.sol
37 
38 
39 pragma solidity ^0.8.13;
40 
41 
42 /**
43  * @title  OperatorFilterer
44  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
45  *         registrant's entries in the OperatorFilterRegistry.
46  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
47  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
48  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
49  */
50 abstract contract OperatorFilterer {
51     error OperatorNotAllowed(address operator);
52 
53     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
54         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
55 
56     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
57         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
58         // will not revert, but the contract will need to be registered with the registry once it is deployed in
59         // order for the modifier to filter addresses.
60         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
61             if (subscribe) {
62                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
63             } else {
64                 if (subscriptionOrRegistrantToCopy != address(0)) {
65                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
66                 } else {
67                     OPERATOR_FILTER_REGISTRY.register(address(this));
68                 }
69             }
70         }
71     }
72 
73     modifier onlyAllowedOperator(address from) virtual {
74         // Allow spending tokens from addresses with balance
75         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
76         // from an EOA.
77         if (from != msg.sender) {
78             _checkFilterOperator(msg.sender);
79         }
80         _;
81     }
82 
83     modifier onlyAllowedOperatorApproval(address operator) virtual {
84         _checkFilterOperator(operator);
85         _;
86     }
87 
88     function _checkFilterOperator(address operator) internal view virtual {
89         // Check registry code length to facilitate testing in environments without a deployed registry.
90         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
91             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
92                 revert OperatorNotAllowed(operator);
93             }
94         }
95     }
96 }
97 
98 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
99 
100 
101 pragma solidity ^0.8.13;
102 
103 
104 /**
105  * @title  DefaultOperatorFilterer
106  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
107  */
108 abstract contract DefaultOperatorFilterer is OperatorFilterer {
109     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
110 
111     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
112 }
113 
114 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev Contract module that helps prevent reentrant calls to a function.
123  *
124  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
125  * available, which can be applied to functions to make sure there are no nested
126  * (reentrant) calls to them.
127  *
128  * Note that because there is a single `nonReentrant` guard, functions marked as
129  * `nonReentrant` may not call one another. This can be worked around by making
130  * those functions `private`, and then adding `external` `nonReentrant` entry
131  * points to them.
132  *
133  * TIP: If you would like to learn more about reentrancy and alternative ways
134  * to protect against it, check out our blog post
135  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
136  */
137 abstract contract ReentrancyGuard {
138     // Booleans are more expensive than uint256 or any type that takes up a full
139     // word because each write operation emits an extra SLOAD to first read the
140     // slot's contents, replace the bits taken up by the boolean, and then write
141     // back. This is the compiler's defense against contract upgrades and
142     // pointer aliasing, and it cannot be disabled.
143 
144     // The values being non-zero value makes deployment a bit more expensive,
145     // but in exchange the refund on every call to nonReentrant will be lower in
146     // amount. Since refunds are capped to a percentage of the total
147     // transaction's gas, it is best to keep them low in cases like this one, to
148     // increase the likelihood of the full refund coming into effect.
149     uint256 private constant _NOT_ENTERED = 1;
150     uint256 private constant _ENTERED = 2;
151 
152     uint256 private _status;
153 
154     constructor() {
155         _status = _NOT_ENTERED;
156     }
157 
158     /**
159      * @dev Prevents a contract from calling itself, directly or indirectly.
160      * Calling a `nonReentrant` function from another `nonReentrant`
161      * function is not supported. It is possible to prevent this from happening
162      * by making the `nonReentrant` function external, and making it call a
163      * `private` function that does the actual work.
164      */
165     modifier nonReentrant() {
166         _nonReentrantBefore();
167         _;
168         _nonReentrantAfter();
169     }
170 
171     function _nonReentrantBefore() private {
172         // On the first call to nonReentrant, _status will be _NOT_ENTERED
173         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
174 
175         // Any calls to nonReentrant after this point will fail
176         _status = _ENTERED;
177     }
178 
179     function _nonReentrantAfter() private {
180         // By storing the original value once again, a refund is triggered (see
181         // https://eips.ethereum.org/EIPS/eip-2200)
182         _status = _NOT_ENTERED;
183     }
184 }
185 
186 // File: @openzeppelin/contracts/utils/math/Math.sol
187 
188 
189 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
190 
191 pragma solidity ^0.8.0;
192 
193 /**
194  * @dev Standard math utilities missing in the Solidity language.
195  */
196 library Math {
197     enum Rounding {
198         Down, // Toward negative infinity
199         Up, // Toward infinity
200         Zero // Toward zero
201     }
202 
203     /**
204      * @dev Returns the largest of two numbers.
205      */
206     function max(uint256 a, uint256 b) internal pure returns (uint256) {
207         return a > b ? a : b;
208     }
209 
210     /**
211      * @dev Returns the smallest of two numbers.
212      */
213     function min(uint256 a, uint256 b) internal pure returns (uint256) {
214         return a < b ? a : b;
215     }
216 
217     /**
218      * @dev Returns the average of two numbers. The result is rounded towards
219      * zero.
220      */
221     function average(uint256 a, uint256 b) internal pure returns (uint256) {
222         // (a + b) / 2 can overflow.
223         return (a & b) + (a ^ b) / 2;
224     }
225 
226     /**
227      * @dev Returns the ceiling of the division of two numbers.
228      *
229      * This differs from standard division with `/` in that it rounds up instead
230      * of rounding down.
231      */
232     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
233         // (a + b - 1) / b can overflow on addition, so we distribute.
234         return a == 0 ? 0 : (a - 1) / b + 1;
235     }
236 
237     /**
238      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
239      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
240      * with further edits by Uniswap Labs also under MIT license.
241      */
242     function mulDiv(
243         uint256 x,
244         uint256 y,
245         uint256 denominator
246     ) internal pure returns (uint256 result) {
247         unchecked {
248             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
249             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
250             // variables such that product = prod1 * 2^256 + prod0.
251             uint256 prod0; // Least significant 256 bits of the product
252             uint256 prod1; // Most significant 256 bits of the product
253             assembly {
254                 let mm := mulmod(x, y, not(0))
255                 prod0 := mul(x, y)
256                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
257             }
258 
259             // Handle non-overflow cases, 256 by 256 division.
260             if (prod1 == 0) {
261                 return prod0 / denominator;
262             }
263 
264             // Make sure the result is less than 2^256. Also prevents denominator == 0.
265             require(denominator > prod1);
266 
267             ///////////////////////////////////////////////
268             // 512 by 256 division.
269             ///////////////////////////////////////////////
270 
271             // Make division exact by subtracting the remainder from [prod1 prod0].
272             uint256 remainder;
273             assembly {
274                 // Compute remainder using mulmod.
275                 remainder := mulmod(x, y, denominator)
276 
277                 // Subtract 256 bit number from 512 bit number.
278                 prod1 := sub(prod1, gt(remainder, prod0))
279                 prod0 := sub(prod0, remainder)
280             }
281 
282             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
283             // See https://cs.stackexchange.com/q/138556/92363.
284 
285             // Does not overflow because the denominator cannot be zero at this stage in the function.
286             uint256 twos = denominator & (~denominator + 1);
287             assembly {
288                 // Divide denominator by twos.
289                 denominator := div(denominator, twos)
290 
291                 // Divide [prod1 prod0] by twos.
292                 prod0 := div(prod0, twos)
293 
294                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
295                 twos := add(div(sub(0, twos), twos), 1)
296             }
297 
298             // Shift in bits from prod1 into prod0.
299             prod0 |= prod1 * twos;
300 
301             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
302             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
303             // four bits. That is, denominator * inv = 1 mod 2^4.
304             uint256 inverse = (3 * denominator) ^ 2;
305 
306             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
307             // in modular arithmetic, doubling the correct bits in each step.
308             inverse *= 2 - denominator * inverse; // inverse mod 2^8
309             inverse *= 2 - denominator * inverse; // inverse mod 2^16
310             inverse *= 2 - denominator * inverse; // inverse mod 2^32
311             inverse *= 2 - denominator * inverse; // inverse mod 2^64
312             inverse *= 2 - denominator * inverse; // inverse mod 2^128
313             inverse *= 2 - denominator * inverse; // inverse mod 2^256
314 
315             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
316             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
317             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
318             // is no longer required.
319             result = prod0 * inverse;
320             return result;
321         }
322     }
323 
324     /**
325      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
326      */
327     function mulDiv(
328         uint256 x,
329         uint256 y,
330         uint256 denominator,
331         Rounding rounding
332     ) internal pure returns (uint256) {
333         uint256 result = mulDiv(x, y, denominator);
334         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
335             result += 1;
336         }
337         return result;
338     }
339 
340     /**
341      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
342      *
343      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
344      */
345     function sqrt(uint256 a) internal pure returns (uint256) {
346         if (a == 0) {
347             return 0;
348         }
349 
350         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
351         //
352         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
353         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
354         //
355         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
356         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
357         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
358         //
359         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
360         uint256 result = 1 << (log2(a) >> 1);
361 
362         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
363         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
364         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
365         // into the expected uint128 result.
366         unchecked {
367             result = (result + a / result) >> 1;
368             result = (result + a / result) >> 1;
369             result = (result + a / result) >> 1;
370             result = (result + a / result) >> 1;
371             result = (result + a / result) >> 1;
372             result = (result + a / result) >> 1;
373             result = (result + a / result) >> 1;
374             return min(result, a / result);
375         }
376     }
377 
378     /**
379      * @notice Calculates sqrt(a), following the selected rounding direction.
380      */
381     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = sqrt(a);
384             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
385         }
386     }
387 
388     /**
389      * @dev Return the log in base 2, rounded down, of a positive value.
390      * Returns 0 if given 0.
391      */
392     function log2(uint256 value) internal pure returns (uint256) {
393         uint256 result = 0;
394         unchecked {
395             if (value >> 128 > 0) {
396                 value >>= 128;
397                 result += 128;
398             }
399             if (value >> 64 > 0) {
400                 value >>= 64;
401                 result += 64;
402             }
403             if (value >> 32 > 0) {
404                 value >>= 32;
405                 result += 32;
406             }
407             if (value >> 16 > 0) {
408                 value >>= 16;
409                 result += 16;
410             }
411             if (value >> 8 > 0) {
412                 value >>= 8;
413                 result += 8;
414             }
415             if (value >> 4 > 0) {
416                 value >>= 4;
417                 result += 4;
418             }
419             if (value >> 2 > 0) {
420                 value >>= 2;
421                 result += 2;
422             }
423             if (value >> 1 > 0) {
424                 result += 1;
425             }
426         }
427         return result;
428     }
429 
430     /**
431      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
432      * Returns 0 if given 0.
433      */
434     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
435         unchecked {
436             uint256 result = log2(value);
437             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
438         }
439     }
440 
441     /**
442      * @dev Return the log in base 10, rounded down, of a positive value.
443      * Returns 0 if given 0.
444      */
445     function log10(uint256 value) internal pure returns (uint256) {
446         uint256 result = 0;
447         unchecked {
448             if (value >= 10**64) {
449                 value /= 10**64;
450                 result += 64;
451             }
452             if (value >= 10**32) {
453                 value /= 10**32;
454                 result += 32;
455             }
456             if (value >= 10**16) {
457                 value /= 10**16;
458                 result += 16;
459             }
460             if (value >= 10**8) {
461                 value /= 10**8;
462                 result += 8;
463             }
464             if (value >= 10**4) {
465                 value /= 10**4;
466                 result += 4;
467             }
468             if (value >= 10**2) {
469                 value /= 10**2;
470                 result += 2;
471             }
472             if (value >= 10**1) {
473                 result += 1;
474             }
475         }
476         return result;
477     }
478 
479     /**
480      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
481      * Returns 0 if given 0.
482      */
483     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
484         unchecked {
485             uint256 result = log10(value);
486             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
487         }
488     }
489 
490     /**
491      * @dev Return the log in base 256, rounded down, of a positive value.
492      * Returns 0 if given 0.
493      *
494      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
495      */
496     function log256(uint256 value) internal pure returns (uint256) {
497         uint256 result = 0;
498         unchecked {
499             if (value >> 128 > 0) {
500                 value >>= 128;
501                 result += 16;
502             }
503             if (value >> 64 > 0) {
504                 value >>= 64;
505                 result += 8;
506             }
507             if (value >> 32 > 0) {
508                 value >>= 32;
509                 result += 4;
510             }
511             if (value >> 16 > 0) {
512                 value >>= 16;
513                 result += 2;
514             }
515             if (value >> 8 > 0) {
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
526     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
527         unchecked {
528             uint256 result = log256(value);
529             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
530         }
531     }
532 }
533 
534 // File: @openzeppelin/contracts/utils/Strings.sol
535 
536 
537 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
538 
539 pragma solidity ^0.8.0;
540 
541 
542 /**
543  * @dev String operations.
544  */
545 library Strings {
546     bytes16 private constant _SYMBOLS = "0123456789abcdef";
547     uint8 private constant _ADDRESS_LENGTH = 20;
548 
549     /**
550      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
551      */
552     function toString(uint256 value) internal pure returns (string memory) {
553         unchecked {
554             uint256 length = Math.log10(value) + 1;
555             string memory buffer = new string(length);
556             uint256 ptr;
557             /// @solidity memory-safe-assembly
558             assembly {
559                 ptr := add(buffer, add(32, length))
560             }
561             while (true) {
562                 ptr--;
563                 /// @solidity memory-safe-assembly
564                 assembly {
565                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
566                 }
567                 value /= 10;
568                 if (value == 0) break;
569             }
570             return buffer;
571         }
572     }
573 
574     /**
575      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
576      */
577     function toHexString(uint256 value) internal pure returns (string memory) {
578         unchecked {
579             return toHexString(value, Math.log256(value) + 1);
580         }
581     }
582 
583     /**
584      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
585      */
586     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
587         bytes memory buffer = new bytes(2 * length + 2);
588         buffer[0] = "0";
589         buffer[1] = "x";
590         for (uint256 i = 2 * length + 1; i > 1; --i) {
591             buffer[i] = _SYMBOLS[value & 0xf];
592             value >>= 4;
593         }
594         require(value == 0, "Strings: hex length insufficient");
595         return string(buffer);
596     }
597 
598     /**
599      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
600      */
601     function toHexString(address addr) internal pure returns (string memory) {
602         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
603     }
604 }
605 
606 // File: erc721a/contracts/IERC721A.sol
607 
608 
609 // ERC721A Contracts v4.2.3
610 // Creator: Chiru Labs
611 
612 pragma solidity ^0.8.4;
613 
614 /**
615  * @dev Interface of ERC721A.
616  */
617 interface IERC721A {
618     /**
619      * The caller must own the token or be an approved operator.
620      */
621     error ApprovalCallerNotOwnerNorApproved();
622 
623     /**
624      * The token does not exist.
625      */
626     error ApprovalQueryForNonexistentToken();
627 
628     /**
629      * Cannot query the balance for the zero address.
630      */
631     error BalanceQueryForZeroAddress();
632 
633     /**
634      * Cannot mint to the zero address.
635      */
636     error MintToZeroAddress();
637 
638     /**
639      * The quantity of tokens minted must be more than zero.
640      */
641     error MintZeroQuantity();
642 
643     /**
644      * The token does not exist.
645      */
646     error OwnerQueryForNonexistentToken();
647 
648     /**
649      * The caller must own the token or be an approved operator.
650      */
651     error TransferCallerNotOwnerNorApproved();
652 
653     /**
654      * The token must be owned by `from`.
655      */
656     error TransferFromIncorrectOwner();
657 
658     /**
659      * Cannot safely transfer to a contract that does not implement the
660      * ERC721Receiver interface.
661      */
662     error TransferToNonERC721ReceiverImplementer();
663 
664     /**
665      * Cannot transfer to the zero address.
666      */
667     error TransferToZeroAddress();
668 
669     /**
670      * The token does not exist.
671      */
672     error URIQueryForNonexistentToken();
673 
674     /**
675      * The `quantity` minted with ERC2309 exceeds the safety limit.
676      */
677     error MintERC2309QuantityExceedsLimit();
678 
679     /**
680      * The `extraData` cannot be set on an unintialized ownership slot.
681      */
682     error OwnershipNotInitializedForExtraData();
683 
684     // =============================================================
685     //                            STRUCTS
686     // =============================================================
687 
688     struct TokenOwnership {
689         // The address of the owner.
690         address addr;
691         // Stores the start time of ownership with minimal overhead for tokenomics.
692         uint64 startTimestamp;
693         // Whether the token has been burned.
694         bool burned;
695         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
696         uint24 extraData;
697     }
698 
699     // =============================================================
700     //                         TOKEN COUNTERS
701     // =============================================================
702 
703     /**
704      * @dev Returns the total number of tokens in existence.
705      * Burned tokens will reduce the count.
706      * To get the total number of tokens minted, please see {_totalMinted}.
707      */
708     function totalSupply() external view returns (uint256);
709 
710     // =============================================================
711     //                            IERC165
712     // =============================================================
713 
714     /**
715      * @dev Returns true if this contract implements the interface defined by
716      * `interfaceId`. See the corresponding
717      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
718      * to learn more about how these ids are created.
719      *
720      * This function call must use less than 30000 gas.
721      */
722     function supportsInterface(bytes4 interfaceId) external view returns (bool);
723 
724     // =============================================================
725     //                            IERC721
726     // =============================================================
727 
728     /**
729      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
730      */
731     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
732 
733     /**
734      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
735      */
736     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
737 
738     /**
739      * @dev Emitted when `owner` enables or disables
740      * (`approved`) `operator` to manage all of its assets.
741      */
742     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
743 
744     /**
745      * @dev Returns the number of tokens in `owner`'s account.
746      */
747     function balanceOf(address owner) external view returns (uint256 balance);
748 
749     /**
750      * @dev Returns the owner of the `tokenId` token.
751      *
752      * Requirements:
753      *
754      * - `tokenId` must exist.
755      */
756     function ownerOf(uint256 tokenId) external view returns (address owner);
757 
758     /**
759      * @dev Safely transfers `tokenId` token from `from` to `to`,
760      * checking first that contract recipients are aware of the ERC721 protocol
761      * to prevent tokens from being forever locked.
762      *
763      * Requirements:
764      *
765      * - `from` cannot be the zero address.
766      * - `to` cannot be the zero address.
767      * - `tokenId` token must exist and be owned by `from`.
768      * - If the caller is not `from`, it must be have been allowed to move
769      * this token by either {approve} or {setApprovalForAll}.
770      * - If `to` refers to a smart contract, it must implement
771      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
772      *
773      * Emits a {Transfer} event.
774      */
775     function safeTransferFrom(
776         address from,
777         address to,
778         uint256 tokenId,
779         bytes calldata data
780     ) external payable;
781 
782     /**
783      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
784      */
785     function safeTransferFrom(
786         address from,
787         address to,
788         uint256 tokenId
789     ) external payable;
790 
791     /**
792      * @dev Transfers `tokenId` from `from` to `to`.
793      *
794      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
795      * whenever possible.
796      *
797      * Requirements:
798      *
799      * - `from` cannot be the zero address.
800      * - `to` cannot be the zero address.
801      * - `tokenId` token must be owned by `from`.
802      * - If the caller is not `from`, it must be approved to move this token
803      * by either {approve} or {setApprovalForAll}.
804      *
805      * Emits a {Transfer} event.
806      */
807     function transferFrom(
808         address from,
809         address to,
810         uint256 tokenId
811     ) external payable;
812 
813     /**
814      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
815      * The approval is cleared when the token is transferred.
816      *
817      * Only a single account can be approved at a time, so approving the
818      * zero address clears previous approvals.
819      *
820      * Requirements:
821      *
822      * - The caller must own the token or be an approved operator.
823      * - `tokenId` must exist.
824      *
825      * Emits an {Approval} event.
826      */
827     function approve(address to, uint256 tokenId) external payable;
828 
829     /**
830      * @dev Approve or remove `operator` as an operator for the caller.
831      * Operators can call {transferFrom} or {safeTransferFrom}
832      * for any token owned by the caller.
833      *
834      * Requirements:
835      *
836      * - The `operator` cannot be the caller.
837      *
838      * Emits an {ApprovalForAll} event.
839      */
840     function setApprovalForAll(address operator, bool _approved) external;
841 
842     /**
843      * @dev Returns the account approved for `tokenId` token.
844      *
845      * Requirements:
846      *
847      * - `tokenId` must exist.
848      */
849     function getApproved(uint256 tokenId) external view returns (address operator);
850 
851     /**
852      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
853      *
854      * See {setApprovalForAll}.
855      */
856     function isApprovedForAll(address owner, address operator) external view returns (bool);
857 
858     // =============================================================
859     //                        IERC721Metadata
860     // =============================================================
861 
862     /**
863      * @dev Returns the token collection name.
864      */
865     function name() external view returns (string memory);
866 
867     /**
868      * @dev Returns the token collection symbol.
869      */
870     function symbol() external view returns (string memory);
871 
872     /**
873      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
874      */
875     function tokenURI(uint256 tokenId) external view returns (string memory);
876 
877     // =============================================================
878     //                           IERC2309
879     // =============================================================
880 
881     /**
882      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
883      * (inclusive) is transferred from `from` to `to`, as defined in the
884      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
885      *
886      * See {_mintERC2309} for more details.
887      */
888     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
889 }
890 
891 // File: erc721a/contracts/ERC721A.sol
892 
893 
894 // ERC721A Contracts v4.2.3
895 // Creator: Chiru Labs
896 
897 pragma solidity ^0.8.4;
898 
899 
900 /**
901  * @dev Interface of ERC721 token receiver.
902  */
903 interface ERC721A__IERC721Receiver {
904     function onERC721Received(
905         address operator,
906         address from,
907         uint256 tokenId,
908         bytes calldata data
909     ) external returns (bytes4);
910 }
911 
912 /**
913  * @title ERC721A
914  *
915  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
916  * Non-Fungible Token Standard, including the Metadata extension.
917  * Optimized for lower gas during batch mints.
918  *
919  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
920  * starting from `_startTokenId()`.
921  *
922  * Assumptions:
923  *
924  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
925  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
926  */
927 contract ERC721A is IERC721A {
928     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
929     struct TokenApprovalRef {
930         address value;
931     }
932 
933     // =============================================================
934     //                           CONSTANTS
935     // =============================================================
936 
937     // Mask of an entry in packed address data.
938     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
939 
940     // The bit position of `numberMinted` in packed address data.
941     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
942 
943     // The bit position of `numberBurned` in packed address data.
944     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
945 
946     // The bit position of `aux` in packed address data.
947     uint256 private constant _BITPOS_AUX = 192;
948 
949     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
950     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
951 
952     // The bit position of `startTimestamp` in packed ownership.
953     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
954 
955     // The bit mask of the `burned` bit in packed ownership.
956     uint256 private constant _BITMASK_BURNED = 1 << 224;
957 
958     // The bit position of the `nextInitialized` bit in packed ownership.
959     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
960 
961     // The bit mask of the `nextInitialized` bit in packed ownership.
962     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
963 
964     // The bit position of `extraData` in packed ownership.
965     uint256 private constant _BITPOS_EXTRA_DATA = 232;
966 
967     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
968     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
969 
970     // The mask of the lower 160 bits for addresses.
971     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
972 
973     // The maximum `quantity` that can be minted with {_mintERC2309}.
974     // This limit is to prevent overflows on the address data entries.
975     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
976     // is required to cause an overflow, which is unrealistic.
977     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
978 
979     // The `Transfer` event signature is given by:
980     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
981     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
982         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
983 
984     // =============================================================
985     //                            STORAGE
986     // =============================================================
987 
988     // The next token ID to be minted.
989     uint256 private _currentIndex;
990 
991     // The number of tokens burned.
992     uint256 private _burnCounter;
993 
994     // Token name
995     string private _name;
996 
997     // Token symbol
998     string private _symbol;
999 
1000     // Mapping from token ID to ownership details
1001     // An empty struct value does not necessarily mean the token is unowned.
1002     // See {_packedOwnershipOf} implementation for details.
1003     //
1004     // Bits Layout:
1005     // - [0..159]   `addr`
1006     // - [160..223] `startTimestamp`
1007     // - [224]      `burned`
1008     // - [225]      `nextInitialized`
1009     // - [232..255] `extraData`
1010     mapping(uint256 => uint256) private _packedOwnerships;
1011 
1012     // Mapping owner address to address data.
1013     //
1014     // Bits Layout:
1015     // - [0..63]    `balance`
1016     // - [64..127]  `numberMinted`
1017     // - [128..191] `numberBurned`
1018     // - [192..255] `aux`
1019     mapping(address => uint256) private _packedAddressData;
1020 
1021     // Mapping from token ID to approved address.
1022     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1023 
1024     // Mapping from owner to operator approvals
1025     mapping(address => mapping(address => bool)) private _operatorApprovals;
1026 
1027     // =============================================================
1028     //                          CONSTRUCTOR
1029     // =============================================================
1030 
1031     constructor(string memory name_, string memory symbol_) {
1032         _name = name_;
1033         _symbol = symbol_;
1034         _currentIndex = _startTokenId();
1035     }
1036 
1037     // =============================================================
1038     //                   TOKEN COUNTING OPERATIONS
1039     // =============================================================
1040 
1041     /**
1042      * @dev Returns the starting token ID.
1043      * To change the starting token ID, please override this function.
1044      */
1045     function _startTokenId() internal view virtual returns (uint256) {
1046         return 0;
1047     }
1048 
1049     /**
1050      * @dev Returns the next token ID to be minted.
1051      */
1052     function _nextTokenId() internal view virtual returns (uint256) {
1053         return _currentIndex;
1054     }
1055 
1056     /**
1057      * @dev Returns the total number of tokens in existence.
1058      * Burned tokens will reduce the count.
1059      * To get the total number of tokens minted, please see {_totalMinted}.
1060      */
1061     function totalSupply() public view virtual override returns (uint256) {
1062         // Counter underflow is impossible as _burnCounter cannot be incremented
1063         // more than `_currentIndex - _startTokenId()` times.
1064         unchecked {
1065             return _currentIndex - _burnCounter - _startTokenId();
1066         }
1067     }
1068 
1069     /**
1070      * @dev Returns the total amount of tokens minted in the contract.
1071      */
1072     function _totalMinted() internal view virtual returns (uint256) {
1073         // Counter underflow is impossible as `_currentIndex` does not decrement,
1074         // and it is initialized to `_startTokenId()`.
1075         unchecked {
1076             return _currentIndex - _startTokenId();
1077         }
1078     }
1079 
1080     /**
1081      * @dev Returns the total number of tokens burned.
1082      */
1083     function _totalBurned() internal view virtual returns (uint256) {
1084         return _burnCounter;
1085     }
1086 
1087     // =============================================================
1088     //                    ADDRESS DATA OPERATIONS
1089     // =============================================================
1090 
1091     /**
1092      * @dev Returns the number of tokens in `owner`'s account.
1093      */
1094     function balanceOf(address owner) public view virtual override returns (uint256) {
1095         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1096         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1097     }
1098 
1099     /**
1100      * Returns the number of tokens minted by `owner`.
1101      */
1102     function _numberMinted(address owner) internal view returns (uint256) {
1103         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1104     }
1105 
1106     /**
1107      * Returns the number of tokens burned by or on behalf of `owner`.
1108      */
1109     function _numberBurned(address owner) internal view returns (uint256) {
1110         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1111     }
1112 
1113     /**
1114      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1115      */
1116     function _getAux(address owner) internal view returns (uint64) {
1117         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1118     }
1119 
1120     /**
1121      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1122      * If there are multiple variables, please pack them into a uint64.
1123      */
1124     function _setAux(address owner, uint64 aux) internal virtual {
1125         uint256 packed = _packedAddressData[owner];
1126         uint256 auxCasted;
1127         // Cast `aux` with assembly to avoid redundant masking.
1128         assembly {
1129             auxCasted := aux
1130         }
1131         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1132         _packedAddressData[owner] = packed;
1133     }
1134 
1135     // =============================================================
1136     //                            IERC165
1137     // =============================================================
1138 
1139     /**
1140      * @dev Returns true if this contract implements the interface defined by
1141      * `interfaceId`. See the corresponding
1142      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1143      * to learn more about how these ids are created.
1144      *
1145      * This function call must use less than 30000 gas.
1146      */
1147     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1148         // The interface IDs are constants representing the first 4 bytes
1149         // of the XOR of all function selectors in the interface.
1150         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1151         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1152         return
1153             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1154             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1155             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1156     }
1157 
1158     // =============================================================
1159     //                        IERC721Metadata
1160     // =============================================================
1161 
1162     /**
1163      * @dev Returns the token collection name.
1164      */
1165     function name() public view virtual override returns (string memory) {
1166         return _name;
1167     }
1168 
1169     /**
1170      * @dev Returns the token collection symbol.
1171      */
1172     function symbol() public view virtual override returns (string memory) {
1173         return _symbol;
1174     }
1175 
1176     /**
1177      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1178      */
1179     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1180         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1181 
1182         string memory baseURI = _baseURI();
1183         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1184     }
1185 
1186     /**
1187      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1188      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1189      * by default, it can be overridden in child contracts.
1190      */
1191     function _baseURI() internal view virtual returns (string memory) {
1192         return '';
1193     }
1194 
1195     // =============================================================
1196     //                     OWNERSHIPS OPERATIONS
1197     // =============================================================
1198 
1199     /**
1200      * @dev Returns the owner of the `tokenId` token.
1201      *
1202      * Requirements:
1203      *
1204      * - `tokenId` must exist.
1205      */
1206     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1207         return address(uint160(_packedOwnershipOf(tokenId)));
1208     }
1209 
1210     /**
1211      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1212      * It gradually moves to O(1) as tokens get transferred around over time.
1213      */
1214     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1215         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1216     }
1217 
1218     /**
1219      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1220      */
1221     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1222         return _unpackedOwnership(_packedOwnerships[index]);
1223     }
1224 
1225     /**
1226      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1227      */
1228     function _initializeOwnershipAt(uint256 index) internal virtual {
1229         if (_packedOwnerships[index] == 0) {
1230             _packedOwnerships[index] = _packedOwnershipOf(index);
1231         }
1232     }
1233 
1234     /**
1235      * Returns the packed ownership data of `tokenId`.
1236      */
1237     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1238         uint256 curr = tokenId;
1239 
1240         unchecked {
1241             if (_startTokenId() <= curr)
1242                 if (curr < _currentIndex) {
1243                     uint256 packed = _packedOwnerships[curr];
1244                     // If not burned.
1245                     if (packed & _BITMASK_BURNED == 0) {
1246                         // Invariant:
1247                         // There will always be an initialized ownership slot
1248                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1249                         // before an unintialized ownership slot
1250                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1251                         // Hence, `curr` will not underflow.
1252                         //
1253                         // We can directly compare the packed value.
1254                         // If the address is zero, packed will be zero.
1255                         while (packed == 0) {
1256                             packed = _packedOwnerships[--curr];
1257                         }
1258                         return packed;
1259                     }
1260                 }
1261         }
1262         revert OwnerQueryForNonexistentToken();
1263     }
1264 
1265     /**
1266      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1267      */
1268     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1269         ownership.addr = address(uint160(packed));
1270         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1271         ownership.burned = packed & _BITMASK_BURNED != 0;
1272         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1273     }
1274 
1275     /**
1276      * @dev Packs ownership data into a single uint256.
1277      */
1278     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1279         assembly {
1280             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1281             owner := and(owner, _BITMASK_ADDRESS)
1282             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1283             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1284         }
1285     }
1286 
1287     /**
1288      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1289      */
1290     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1291         // For branchless setting of the `nextInitialized` flag.
1292         assembly {
1293             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1294             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1295         }
1296     }
1297 
1298     // =============================================================
1299     //                      APPROVAL OPERATIONS
1300     // =============================================================
1301 
1302     /**
1303      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1304      * The approval is cleared when the token is transferred.
1305      *
1306      * Only a single account can be approved at a time, so approving the
1307      * zero address clears previous approvals.
1308      *
1309      * Requirements:
1310      *
1311      * - The caller must own the token or be an approved operator.
1312      * - `tokenId` must exist.
1313      *
1314      * Emits an {Approval} event.
1315      */
1316     function approve(address to, uint256 tokenId) public payable virtual override {
1317         address owner = ownerOf(tokenId);
1318 
1319         if (_msgSenderERC721A() != owner)
1320             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1321                 revert ApprovalCallerNotOwnerNorApproved();
1322             }
1323 
1324         _tokenApprovals[tokenId].value = to;
1325         emit Approval(owner, to, tokenId);
1326     }
1327 
1328     /**
1329      * @dev Returns the account approved for `tokenId` token.
1330      *
1331      * Requirements:
1332      *
1333      * - `tokenId` must exist.
1334      */
1335     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1336         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1337 
1338         return _tokenApprovals[tokenId].value;
1339     }
1340 
1341     /**
1342      * @dev Approve or remove `operator` as an operator for the caller.
1343      * Operators can call {transferFrom} or {safeTransferFrom}
1344      * for any token owned by the caller.
1345      *
1346      * Requirements:
1347      *
1348      * - The `operator` cannot be the caller.
1349      *
1350      * Emits an {ApprovalForAll} event.
1351      */
1352     function setApprovalForAll(address operator, bool approved) public virtual override {
1353         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1354         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1355     }
1356 
1357     /**
1358      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1359      *
1360      * See {setApprovalForAll}.
1361      */
1362     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1363         return _operatorApprovals[owner][operator];
1364     }
1365 
1366     /**
1367      * @dev Returns whether `tokenId` exists.
1368      *
1369      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1370      *
1371      * Tokens start existing when they are minted. See {_mint}.
1372      */
1373     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1374         return
1375             _startTokenId() <= tokenId &&
1376             tokenId < _currentIndex && // If within bounds,
1377             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1378     }
1379 
1380     /**
1381      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1382      */
1383     function _isSenderApprovedOrOwner(
1384         address approvedAddress,
1385         address owner,
1386         address msgSender
1387     ) private pure returns (bool result) {
1388         assembly {
1389             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1390             owner := and(owner, _BITMASK_ADDRESS)
1391             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1392             msgSender := and(msgSender, _BITMASK_ADDRESS)
1393             // `msgSender == owner || msgSender == approvedAddress`.
1394             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1395         }
1396     }
1397 
1398     /**
1399      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1400      */
1401     function _getApprovedSlotAndAddress(uint256 tokenId)
1402         private
1403         view
1404         returns (uint256 approvedAddressSlot, address approvedAddress)
1405     {
1406         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1407         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1408         assembly {
1409             approvedAddressSlot := tokenApproval.slot
1410             approvedAddress := sload(approvedAddressSlot)
1411         }
1412     }
1413 
1414     // =============================================================
1415     //                      TRANSFER OPERATIONS
1416     // =============================================================
1417 
1418     /**
1419      * @dev Transfers `tokenId` from `from` to `to`.
1420      *
1421      * Requirements:
1422      *
1423      * - `from` cannot be the zero address.
1424      * - `to` cannot be the zero address.
1425      * - `tokenId` token must be owned by `from`.
1426      * - If the caller is not `from`, it must be approved to move this token
1427      * by either {approve} or {setApprovalForAll}.
1428      *
1429      * Emits a {Transfer} event.
1430      */
1431     function transferFrom(
1432         address from,
1433         address to,
1434         uint256 tokenId
1435     ) public payable virtual override {
1436         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1437 
1438         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1439 
1440         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1441 
1442         // The nested ifs save around 20+ gas over a compound boolean condition.
1443         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1444             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1445 
1446         if (to == address(0)) revert TransferToZeroAddress();
1447 
1448         _beforeTokenTransfers(from, to, tokenId, 1);
1449 
1450         // Clear approvals from the previous owner.
1451         assembly {
1452             if approvedAddress {
1453                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1454                 sstore(approvedAddressSlot, 0)
1455             }
1456         }
1457 
1458         // Underflow of the sender's balance is impossible because we check for
1459         // ownership above and the recipient's balance can't realistically overflow.
1460         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1461         unchecked {
1462             // We can directly increment and decrement the balances.
1463             --_packedAddressData[from]; // Updates: `balance -= 1`.
1464             ++_packedAddressData[to]; // Updates: `balance += 1`.
1465 
1466             // Updates:
1467             // - `address` to the next owner.
1468             // - `startTimestamp` to the timestamp of transfering.
1469             // - `burned` to `false`.
1470             // - `nextInitialized` to `true`.
1471             _packedOwnerships[tokenId] = _packOwnershipData(
1472                 to,
1473                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1474             );
1475 
1476             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1477             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1478                 uint256 nextTokenId = tokenId + 1;
1479                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1480                 if (_packedOwnerships[nextTokenId] == 0) {
1481                     // If the next slot is within bounds.
1482                     if (nextTokenId != _currentIndex) {
1483                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1484                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1485                     }
1486                 }
1487             }
1488         }
1489 
1490         emit Transfer(from, to, tokenId);
1491         _afterTokenTransfers(from, to, tokenId, 1);
1492     }
1493 
1494     /**
1495      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1496      */
1497     function safeTransferFrom(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) public payable virtual override {
1502         safeTransferFrom(from, to, tokenId, '');
1503     }
1504 
1505     /**
1506      * @dev Safely transfers `tokenId` token from `from` to `to`.
1507      *
1508      * Requirements:
1509      *
1510      * - `from` cannot be the zero address.
1511      * - `to` cannot be the zero address.
1512      * - `tokenId` token must exist and be owned by `from`.
1513      * - If the caller is not `from`, it must be approved to move this token
1514      * by either {approve} or {setApprovalForAll}.
1515      * - If `to` refers to a smart contract, it must implement
1516      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1517      *
1518      * Emits a {Transfer} event.
1519      */
1520     function safeTransferFrom(
1521         address from,
1522         address to,
1523         uint256 tokenId,
1524         bytes memory _data
1525     ) public payable virtual override {
1526         transferFrom(from, to, tokenId);
1527         if (to.code.length != 0)
1528             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1529                 revert TransferToNonERC721ReceiverImplementer();
1530             }
1531     }
1532 
1533     /**
1534      * @dev Hook that is called before a set of serially-ordered token IDs
1535      * are about to be transferred. This includes minting.
1536      * And also called before burning one token.
1537      *
1538      * `startTokenId` - the first token ID to be transferred.
1539      * `quantity` - the amount to be transferred.
1540      *
1541      * Calling conditions:
1542      *
1543      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1544      * transferred to `to`.
1545      * - When `from` is zero, `tokenId` will be minted for `to`.
1546      * - When `to` is zero, `tokenId` will be burned by `from`.
1547      * - `from` and `to` are never both zero.
1548      */
1549     function _beforeTokenTransfers(
1550         address from,
1551         address to,
1552         uint256 startTokenId,
1553         uint256 quantity
1554     ) internal virtual {}
1555 
1556     /**
1557      * @dev Hook that is called after a set of serially-ordered token IDs
1558      * have been transferred. This includes minting.
1559      * And also called after one token has been burned.
1560      *
1561      * `startTokenId` - the first token ID to be transferred.
1562      * `quantity` - the amount to be transferred.
1563      *
1564      * Calling conditions:
1565      *
1566      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1567      * transferred to `to`.
1568      * - When `from` is zero, `tokenId` has been minted for `to`.
1569      * - When `to` is zero, `tokenId` has been burned by `from`.
1570      * - `from` and `to` are never both zero.
1571      */
1572     function _afterTokenTransfers(
1573         address from,
1574         address to,
1575         uint256 startTokenId,
1576         uint256 quantity
1577     ) internal virtual {}
1578 
1579     /**
1580      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1581      *
1582      * `from` - Previous owner of the given token ID.
1583      * `to` - Target address that will receive the token.
1584      * `tokenId` - Token ID to be transferred.
1585      * `_data` - Optional data to send along with the call.
1586      *
1587      * Returns whether the call correctly returned the expected magic value.
1588      */
1589     function _checkContractOnERC721Received(
1590         address from,
1591         address to,
1592         uint256 tokenId,
1593         bytes memory _data
1594     ) private returns (bool) {
1595         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1596             bytes4 retval
1597         ) {
1598             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1599         } catch (bytes memory reason) {
1600             if (reason.length == 0) {
1601                 revert TransferToNonERC721ReceiverImplementer();
1602             } else {
1603                 assembly {
1604                     revert(add(32, reason), mload(reason))
1605                 }
1606             }
1607         }
1608     }
1609 
1610     // =============================================================
1611     //                        MINT OPERATIONS
1612     // =============================================================
1613 
1614     /**
1615      * @dev Mints `quantity` tokens and transfers them to `to`.
1616      *
1617      * Requirements:
1618      *
1619      * - `to` cannot be the zero address.
1620      * - `quantity` must be greater than 0.
1621      *
1622      * Emits a {Transfer} event for each mint.
1623      */
1624     function _mint(address to, uint256 quantity) internal virtual {
1625         uint256 startTokenId = _currentIndex;
1626         if (quantity == 0) revert MintZeroQuantity();
1627 
1628         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1629 
1630         // Overflows are incredibly unrealistic.
1631         // `balance` and `numberMinted` have a maximum limit of 2**64.
1632         // `tokenId` has a maximum limit of 2**256.
1633         unchecked {
1634             // Updates:
1635             // - `balance += quantity`.
1636             // - `numberMinted += quantity`.
1637             //
1638             // We can directly add to the `balance` and `numberMinted`.
1639             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1640 
1641             // Updates:
1642             // - `address` to the owner.
1643             // - `startTimestamp` to the timestamp of minting.
1644             // - `burned` to `false`.
1645             // - `nextInitialized` to `quantity == 1`.
1646             _packedOwnerships[startTokenId] = _packOwnershipData(
1647                 to,
1648                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1649             );
1650 
1651             uint256 toMasked;
1652             uint256 end = startTokenId + quantity;
1653 
1654             // Use assembly to loop and emit the `Transfer` event for gas savings.
1655             // The duplicated `log4` removes an extra check and reduces stack juggling.
1656             // The assembly, together with the surrounding Solidity code, have been
1657             // delicately arranged to nudge the compiler into producing optimized opcodes.
1658             assembly {
1659                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1660                 toMasked := and(to, _BITMASK_ADDRESS)
1661                 // Emit the `Transfer` event.
1662                 log4(
1663                     0, // Start of data (0, since no data).
1664                     0, // End of data (0, since no data).
1665                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1666                     0, // `address(0)`.
1667                     toMasked, // `to`.
1668                     startTokenId // `tokenId`.
1669                 )
1670 
1671                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1672                 // that overflows uint256 will make the loop run out of gas.
1673                 // The compiler will optimize the `iszero` away for performance.
1674                 for {
1675                     let tokenId := add(startTokenId, 1)
1676                 } iszero(eq(tokenId, end)) {
1677                     tokenId := add(tokenId, 1)
1678                 } {
1679                     // Emit the `Transfer` event. Similar to above.
1680                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1681                 }
1682             }
1683             if (toMasked == 0) revert MintToZeroAddress();
1684 
1685             _currentIndex = end;
1686         }
1687         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1688     }
1689 
1690     /**
1691      * @dev Mints `quantity` tokens and transfers them to `to`.
1692      *
1693      * This function is intended for efficient minting only during contract creation.
1694      *
1695      * It emits only one {ConsecutiveTransfer} as defined in
1696      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1697      * instead of a sequence of {Transfer} event(s).
1698      *
1699      * Calling this function outside of contract creation WILL make your contract
1700      * non-compliant with the ERC721 standard.
1701      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1702      * {ConsecutiveTransfer} event is only permissible during contract creation.
1703      *
1704      * Requirements:
1705      *
1706      * - `to` cannot be the zero address.
1707      * - `quantity` must be greater than 0.
1708      *
1709      * Emits a {ConsecutiveTransfer} event.
1710      */
1711     function _mintERC2309(address to, uint256 quantity) internal virtual {
1712         uint256 startTokenId = _currentIndex;
1713         if (to == address(0)) revert MintToZeroAddress();
1714         if (quantity == 0) revert MintZeroQuantity();
1715         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1716 
1717         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1718 
1719         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1720         unchecked {
1721             // Updates:
1722             // - `balance += quantity`.
1723             // - `numberMinted += quantity`.
1724             //
1725             // We can directly add to the `balance` and `numberMinted`.
1726             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1727 
1728             // Updates:
1729             // - `address` to the owner.
1730             // - `startTimestamp` to the timestamp of minting.
1731             // - `burned` to `false`.
1732             // - `nextInitialized` to `quantity == 1`.
1733             _packedOwnerships[startTokenId] = _packOwnershipData(
1734                 to,
1735                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1736             );
1737 
1738             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1739 
1740             _currentIndex = startTokenId + quantity;
1741         }
1742         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1743     }
1744 
1745     /**
1746      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1747      *
1748      * Requirements:
1749      *
1750      * - If `to` refers to a smart contract, it must implement
1751      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1752      * - `quantity` must be greater than 0.
1753      *
1754      * See {_mint}.
1755      *
1756      * Emits a {Transfer} event for each mint.
1757      */
1758     function _safeMint(
1759         address to,
1760         uint256 quantity,
1761         bytes memory _data
1762     ) internal virtual {
1763         _mint(to, quantity);
1764 
1765         unchecked {
1766             if (to.code.length != 0) {
1767                 uint256 end = _currentIndex;
1768                 uint256 index = end - quantity;
1769                 do {
1770                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1771                         revert TransferToNonERC721ReceiverImplementer();
1772                     }
1773                 } while (index < end);
1774                 // Reentrancy protection.
1775                 if (_currentIndex != end) revert();
1776             }
1777         }
1778     }
1779 
1780     /**
1781      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1782      */
1783     function _safeMint(address to, uint256 quantity) internal virtual {
1784         _safeMint(to, quantity, '');
1785     }
1786 
1787     // =============================================================
1788     //                        BURN OPERATIONS
1789     // =============================================================
1790 
1791     /**
1792      * @dev Equivalent to `_burn(tokenId, false)`.
1793      */
1794     function _burn(uint256 tokenId) internal virtual {
1795         _burn(tokenId, false);
1796     }
1797 
1798     /**
1799      * @dev Destroys `tokenId`.
1800      * The approval is cleared when the token is burned.
1801      *
1802      * Requirements:
1803      *
1804      * - `tokenId` must exist.
1805      *
1806      * Emits a {Transfer} event.
1807      */
1808     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1809         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1810 
1811         address from = address(uint160(prevOwnershipPacked));
1812 
1813         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1814 
1815         if (approvalCheck) {
1816             // The nested ifs save around 20+ gas over a compound boolean condition.
1817             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1818                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1819         }
1820 
1821         _beforeTokenTransfers(from, address(0), tokenId, 1);
1822 
1823         // Clear approvals from the previous owner.
1824         assembly {
1825             if approvedAddress {
1826                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1827                 sstore(approvedAddressSlot, 0)
1828             }
1829         }
1830 
1831         // Underflow of the sender's balance is impossible because we check for
1832         // ownership above and the recipient's balance can't realistically overflow.
1833         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1834         unchecked {
1835             // Updates:
1836             // - `balance -= 1`.
1837             // - `numberBurned += 1`.
1838             //
1839             // We can directly decrement the balance, and increment the number burned.
1840             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1841             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1842 
1843             // Updates:
1844             // - `address` to the last owner.
1845             // - `startTimestamp` to the timestamp of burning.
1846             // - `burned` to `true`.
1847             // - `nextInitialized` to `true`.
1848             _packedOwnerships[tokenId] = _packOwnershipData(
1849                 from,
1850                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1851             );
1852 
1853             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1854             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1855                 uint256 nextTokenId = tokenId + 1;
1856                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1857                 if (_packedOwnerships[nextTokenId] == 0) {
1858                     // If the next slot is within bounds.
1859                     if (nextTokenId != _currentIndex) {
1860                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1861                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1862                     }
1863                 }
1864             }
1865         }
1866 
1867         emit Transfer(from, address(0), tokenId);
1868         _afterTokenTransfers(from, address(0), tokenId, 1);
1869 
1870         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1871         unchecked {
1872             _burnCounter++;
1873         }
1874     }
1875 
1876     // =============================================================
1877     //                     EXTRA DATA OPERATIONS
1878     // =============================================================
1879 
1880     /**
1881      * @dev Directly sets the extra data for the ownership data `index`.
1882      */
1883     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1884         uint256 packed = _packedOwnerships[index];
1885         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1886         uint256 extraDataCasted;
1887         // Cast `extraData` with assembly to avoid redundant masking.
1888         assembly {
1889             extraDataCasted := extraData
1890         }
1891         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1892         _packedOwnerships[index] = packed;
1893     }
1894 
1895     /**
1896      * @dev Called during each token transfer to set the 24bit `extraData` field.
1897      * Intended to be overridden by the cosumer contract.
1898      *
1899      * `previousExtraData` - the value of `extraData` before transfer.
1900      *
1901      * Calling conditions:
1902      *
1903      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1904      * transferred to `to`.
1905      * - When `from` is zero, `tokenId` will be minted for `to`.
1906      * - When `to` is zero, `tokenId` will be burned by `from`.
1907      * - `from` and `to` are never both zero.
1908      */
1909     function _extraData(
1910         address from,
1911         address to,
1912         uint24 previousExtraData
1913     ) internal view virtual returns (uint24) {}
1914 
1915     /**
1916      * @dev Returns the next extra data for the packed ownership data.
1917      * The returned result is shifted into position.
1918      */
1919     function _nextExtraData(
1920         address from,
1921         address to,
1922         uint256 prevOwnershipPacked
1923     ) private view returns (uint256) {
1924         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1925         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1926     }
1927 
1928     // =============================================================
1929     //                       OTHER OPERATIONS
1930     // =============================================================
1931 
1932     /**
1933      * @dev Returns the message sender (defaults to `msg.sender`).
1934      *
1935      * If you are writing GSN compatible contracts, you need to override this function.
1936      */
1937     function _msgSenderERC721A() internal view virtual returns (address) {
1938         return msg.sender;
1939     }
1940 
1941     /**
1942      * @dev Converts a uint256 to its ASCII string decimal representation.
1943      */
1944     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1945         assembly {
1946             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1947             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1948             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1949             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1950             let m := add(mload(0x40), 0xa0)
1951             // Update the free memory pointer to allocate.
1952             mstore(0x40, m)
1953             // Assign the `str` to the end.
1954             str := sub(m, 0x20)
1955             // Zeroize the slot after the string.
1956             mstore(str, 0)
1957 
1958             // Cache the end of the memory to calculate the length later.
1959             let end := str
1960 
1961             // We write the string from rightmost digit to leftmost digit.
1962             // The following is essentially a do-while loop that also handles the zero case.
1963             // prettier-ignore
1964             for { let temp := value } 1 {} {
1965                 str := sub(str, 1)
1966                 // Write the character to the pointer.
1967                 // The ASCII index of the '0' character is 48.
1968                 mstore8(str, add(48, mod(temp, 10)))
1969                 // Keep dividing `temp` until zero.
1970                 temp := div(temp, 10)
1971                 // prettier-ignore
1972                 if iszero(temp) { break }
1973             }
1974 
1975             let length := sub(end, str)
1976             // Move the pointer 32 bytes leftwards to make room for the length.
1977             str := sub(str, 0x20)
1978             // Store the length.
1979             mstore(str, length)
1980         }
1981     }
1982 }
1983 
1984 // File: @openzeppelin/contracts/utils/Context.sol
1985 
1986 
1987 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1988 
1989 pragma solidity ^0.8.0;
1990 
1991 /**
1992  * @dev Provides information about the current execution context, including the
1993  * sender of the transaction and its data. While these are generally available
1994  * via msg.sender and msg.data, they should not be accessed in such a direct
1995  * manner, since when dealing with meta-transactions the account sending and
1996  * paying for execution may not be the actual sender (as far as an application
1997  * is concerned).
1998  *
1999  * This contract is only required for intermediate, library-like contracts.
2000  */
2001 abstract contract Context {
2002     function _msgSender() internal view virtual returns (address) {
2003         return msg.sender;
2004     }
2005 
2006     function _msgData() internal view virtual returns (bytes calldata) {
2007         return msg.data;
2008     }
2009 }
2010 
2011 // File: @openzeppelin/contracts/access/Ownable.sol
2012 
2013 
2014 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2015 
2016 pragma solidity ^0.8.0;
2017 
2018 
2019 /**
2020  * @dev Contract module which provides a basic access control mechanism, where
2021  * there is an account (an owner) that can be granted exclusive access to
2022  * specific functions.
2023  *
2024  * By default, the owner account will be the one that deploys the contract. This
2025  * can later be changed with {transferOwnership}.
2026  *
2027  * This module is used through inheritance. It will make available the modifier
2028  * `onlyOwner`, which can be applied to your functions to restrict their use to
2029  * the owner.
2030  */
2031 abstract contract Ownable is Context {
2032     address private _owner;
2033 
2034     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2035 
2036     /**
2037      * @dev Initializes the contract setting the deployer as the initial owner.
2038      */
2039     constructor() {
2040         _transferOwnership(_msgSender());
2041     }
2042 
2043     /**
2044      * @dev Throws if called by any account other than the owner.
2045      */
2046     modifier onlyOwner() {
2047         _checkOwner();
2048         _;
2049     }
2050 
2051     /**
2052      * @dev Returns the address of the current owner.
2053      */
2054     function owner() public view virtual returns (address) {
2055         return _owner;
2056     }
2057 
2058     /**
2059      * @dev Throws if the sender is not the owner.
2060      */
2061     function _checkOwner() internal view virtual {
2062         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2063     }
2064 
2065     /**
2066      * @dev Leaves the contract without owner. It will not be possible to call
2067      * `onlyOwner` functions anymore. Can only be called by the current owner.
2068      *
2069      * NOTE: Renouncing ownership will leave the contract without an owner,
2070      * thereby removing any functionality that is only available to the owner.
2071      */
2072     function renounceOwnership() public virtual onlyOwner {
2073         _transferOwnership(address(0));
2074     }
2075 
2076     /**
2077      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2078      * Can only be called by the current owner.
2079      */
2080     function transferOwnership(address newOwner) public virtual onlyOwner {
2081         require(newOwner != address(0), "Ownable: new owner is the zero address");
2082         _transferOwnership(newOwner);
2083     }
2084 
2085     /**
2086      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2087      * Internal function without access restriction.
2088      */
2089     function _transferOwnership(address newOwner) internal virtual {
2090         address oldOwner = _owner;
2091         _owner = newOwner;
2092         emit OwnershipTransferred(oldOwner, newOwner);
2093     }
2094 }
2095 
2096 
2097         pragma solidity ^0.8.13;
2098 
2099 
2100 
2101 
2102 
2103 
2104         contract Monzuki is ERC721A, Ownable, ReentrancyGuard  , DefaultOperatorFilterer{
2105             using Strings for uint256;
2106             uint256 public _maxSupply = 5555;
2107             uint256 public maxMintAmountPerWallet = 2;
2108             uint256 public maxMintAmountPerTx = 2;
2109             string baseURL = "";
2110             string ExtensionURL = ".json";
2111             uint256 _initalPrice = 0 ether;
2112             uint256 public costOfNFT = 0 ether;
2113             uint256 public numberOfFreeNFTs = 5555;
2114             
2115             string HiddenURL;
2116             bool revealed = true;
2117             bool paused = false;
2118             
2119             error ContractPaused();
2120             error MaxMintWalletExceeded();
2121             error MaxSupply();
2122             error InvalidMintAmount();
2123             error InsufficientFund();
2124             error NoSmartContract();
2125             error TokenNotExisting();
2126 
2127         constructor(string memory _initBaseURI) ERC721A("Monzuki", "MZK") {
2128             baseURL = _initBaseURI;
2129         }
2130 
2131         // ================== Mint Function =======================
2132 
2133         modifier mintCompliance(uint256 _mintAmount) {
2134             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2135             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2136             if(paused) revert ContractPaused();
2137             _;
2138         }
2139 
2140         modifier mintPriceCompliance(uint256 _mintAmount) {
2141             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2142             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2143               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2144             _;
2145         }
2146         
2147         /// @notice compliance of minting
2148         /// @dev user (msg.sender) mint
2149         /// @param _mintAmount the amount of tokens to mint
2150         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2151          
2152           
2153           _safeMint(msg.sender, _mintAmount);
2154           }
2155 
2156         /// @dev user (msg.sender) mint
2157         /// @param _mintAmount the amount of tokens to mint 
2158         /// @return value from number to mint
2159         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2160           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2161           if ((totalMints <= numberOfFreeNFTs) ) {
2162           return _initalPrice;
2163           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2164           uint256 total = costOfNFT * _mintAmount;
2165           return total;
2166           } 
2167           else {
2168           uint256 total2 = costOfNFT * _mintAmount;
2169           return total2;
2170             }
2171         }
2172         
2173 
2174 
2175         /// @notice airdrop function to airdrop same amount of tokens to addresses
2176         /// @dev only owner function
2177         /// @param accounts  array of addresses
2178         /// @param amount the amount of tokens to airdrop users
2179         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2180           for(uint256 i = 0; i < accounts.length; i++){
2181           _safeMint(accounts[i], amount);
2182           }
2183         }
2184 
2185         // =================== Orange Functions (Owner Only) ===============
2186 
2187         /// @dev pause/unpause minting
2188         function pause() public onlyOwner {
2189           paused = !paused;
2190         }
2191 
2192         
2193 
2194         /// @dev set URI
2195         /// @param uri  new URI
2196         function setbaseURL(string memory uri) public onlyOwner{
2197           baseURL = uri;
2198         }
2199 
2200         /// @dev extension URI like 'json'
2201         function setExtensionURL(string memory uri) public onlyOwner{
2202           ExtensionURL = uri;
2203         }
2204         
2205         /// @dev set new cost of tokenId in WEI
2206         /// @param _cost  new price in wei
2207         function setCostPrice(uint256 _cost) public onlyOwner{
2208           costOfNFT = _cost;
2209         } 
2210 
2211         /// @dev only owner
2212         /// @param perTx  new max mint per transaction
2213         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2214           maxMintAmountPerTx = perTx;
2215         }
2216 
2217         /// @dev only owner
2218         /// @param perWallet  new max mint per wallet
2219         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2220           maxMintAmountPerWallet = perWallet;
2221         }  
2222         
2223         /// @dev only owner
2224         /// @param perWallet set free number of nft per wallet
2225         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2226           numberOfFreeNFTs = perWallet;
2227         }            
2228 
2229         // ================================ Withdraw Function ====================
2230 
2231         /// @notice withdraw ether from contract.
2232         /// @dev only owner function
2233         function withdraw() public onlyOwner nonReentrant{
2234           
2235 
2236           
2237 
2238         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2239         require(owner);
2240         }
2241         // =================== Blue Functions (View Only) ====================
2242 
2243         /// @dev return uri of token ID
2244         /// @param tokenId  token ID to find uri for
2245         ///@return value for 'tokenId uri'
2246         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2247           if (!_exists(tokenId)) revert TokenNotExisting();   
2248 
2249         
2250 
2251         string memory currentBaseURI = _baseURI();
2252         return bytes(currentBaseURI).length > 0
2253         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2254         : '';
2255         }
2256         
2257         /// @dev tokenId to start (1)
2258         function _startTokenId() internal view virtual override returns (uint256) {
2259           return 1;
2260         }
2261 
2262         ///@dev maxSupply of token
2263         /// @return max supply
2264         function _baseURI() internal view virtual override returns (string memory) {
2265           return baseURL;
2266         }
2267 
2268     
2269         /// @dev internal function to 
2270         /// @param from  user address where token belongs
2271         /// @param to  user address
2272         /// @param tokenId  number of tokenId
2273           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2274         super.transferFrom(from, to, tokenId);
2275         }
2276         
2277         /// @dev internal function to 
2278         /// @param from  user address where token belongs
2279         /// @param to  user address
2280         /// @param tokenId  number of tokenId
2281         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2282         super.safeTransferFrom(from, to, tokenId);
2283         }
2284 
2285         /// @dev internal function to 
2286         /// @param from  user address where token belongs
2287         /// @param to  user address
2288         /// @param tokenId  number of tokenId
2289         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2290         public payable
2291         override
2292         onlyAllowedOperator(from)
2293         {
2294         super.safeTransferFrom(from, to, tokenId, data);
2295         }
2296         
2297 
2298 }