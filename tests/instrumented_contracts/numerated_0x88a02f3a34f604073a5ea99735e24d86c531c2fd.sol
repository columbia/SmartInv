1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
3 
4 
5 // ╭━━━┳━━━┳━━━┳━━━╮
6 // ┃╭━╮┃╭━━┫╭━╮┃╭━━╯
7 // ┃╰━╯┃╰━━┫╰━╯┃╰━━╮
8 // ┃╭━━┫╭━━┫╭━━┫╭━━╯
9 // ┃┃╱╱┃╰━━┫┃╱╱┃╰━━╮
10 // ╰╯╱╱╰━━━┻╯╱╱╰━━━╯
11 
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
17     function register(address registrant) external;
18     function registerAndSubscribe(address registrant, address subscription) external;
19     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
20     function unregister(address addr) external;
21     function updateOperator(address registrant, address operator, bool filtered) external;
22     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
23     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
24     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
25     function subscribe(address registrant, address registrantToSubscribe) external;
26     function unsubscribe(address registrant, bool copyExistingEntries) external;
27     function subscriptionOf(address addr) external returns (address registrant);
28     function subscribers(address registrant) external returns (address[] memory);
29     function subscriberAt(address registrant, uint256 index) external returns (address);
30     function copyEntriesOf(address registrant, address registrantToCopy) external;
31     function isOperatorFiltered(address registrant, address operator) external returns (bool);
32     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
33     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
34     function filteredOperators(address addr) external returns (address[] memory);
35     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
36     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
37     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
38     function isRegistered(address addr) external returns (bool);
39     function codeHashOf(address addr) external returns (bytes32);
40 }
41 
42 // File: operator-filter-registry/src/OperatorFilterer.sol
43 
44 
45 pragma solidity ^0.8.13;
46 
47 
48 /**
49  * @title  OperatorFilterer
50  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
51  *         registrant's entries in the OperatorFilterRegistry.
52  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
53  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
54  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
55  */
56 abstract contract OperatorFilterer {
57     error OperatorNotAllowed(address operator);
58 
59     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
60         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
61 
62     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
63         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
64         // will not revert, but the contract will need to be registered with the registry once it is deployed in
65         // order for the modifier to filter addresses.
66         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
67             if (subscribe) {
68                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
69             } else {
70                 if (subscriptionOrRegistrantToCopy != address(0)) {
71                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
72                 } else {
73                     OPERATOR_FILTER_REGISTRY.register(address(this));
74                 }
75             }
76         }
77     }
78 
79     modifier onlyAllowedOperator(address from) virtual {
80         // Allow spending tokens from addresses with balance
81         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
82         // from an EOA.
83         if (from != msg.sender) {
84             _checkFilterOperator(msg.sender);
85         }
86         _;
87     }
88 
89     modifier onlyAllowedOperatorApproval(address operator) virtual {
90         _checkFilterOperator(operator);
91         _;
92     }
93 
94     function _checkFilterOperator(address operator) internal view virtual {
95         // Check registry code length to facilitate testing in environments without a deployed registry.
96         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
97             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
98                 revert OperatorNotAllowed(operator);
99             }
100         }
101     }
102 }
103 
104 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
105 
106 
107 pragma solidity ^0.8.13;
108 
109 
110 /**
111  * @title  DefaultOperatorFilterer
112  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
113  */
114 abstract contract DefaultOperatorFilterer is OperatorFilterer {
115     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
116 
117     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
118 }
119 
120 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
121 
122 
123 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev Contract module that helps prevent reentrant calls to a function.
129  *
130  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
131  * available, which can be applied to functions to make sure there are no nested
132  * (reentrant) calls to them.
133  *
134  * Note that because there is a single `nonReentrant` guard, functions marked as
135  * `nonReentrant` may not call one another. This can be worked around by making
136  * those functions `private`, and then adding `external` `nonReentrant` entry
137  * points to them.
138  *
139  * TIP: If you would like to learn more about reentrancy and alternative ways
140  * to protect against it, check out our blog post
141  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
142  */
143 abstract contract ReentrancyGuard {
144     // Booleans are more expensive than uint256 or any type that takes up a full
145     // word because each write operation emits an extra SLOAD to first read the
146     // slot's contents, replace the bits taken up by the boolean, and then write
147     // back. This is the compiler's defense against contract upgrades and
148     // pointer aliasing, and it cannot be disabled.
149 
150     // The values being non-zero value makes deployment a bit more expensive,
151     // but in exchange the refund on every call to nonReentrant will be lower in
152     // amount. Since refunds are capped to a percentage of the total
153     // transaction's gas, it is best to keep them low in cases like this one, to
154     // increase the likelihood of the full refund coming into effect.
155     uint256 private constant _NOT_ENTERED = 1;
156     uint256 private constant _ENTERED = 2;
157 
158     uint256 private _status;
159 
160     constructor() {
161         _status = _NOT_ENTERED;
162     }
163 
164     /**
165      * @dev Prevents a contract from calling itself, directly or indirectly.
166      * Calling a `nonReentrant` function from another `nonReentrant`
167      * function is not supported. It is possible to prevent this from happening
168      * by making the `nonReentrant` function external, and making it call a
169      * `private` function that does the actual work.
170      */
171     modifier nonReentrant() {
172         _nonReentrantBefore();
173         _;
174         _nonReentrantAfter();
175     }
176 
177     function _nonReentrantBefore() private {
178         // On the first call to nonReentrant, _status will be _NOT_ENTERED
179         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
180 
181         // Any calls to nonReentrant after this point will fail
182         _status = _ENTERED;
183     }
184 
185     function _nonReentrantAfter() private {
186         // By storing the original value once again, a refund is triggered (see
187         // https://eips.ethereum.org/EIPS/eip-2200)
188         _status = _NOT_ENTERED;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/math/Math.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev Standard math utilities missing in the Solidity language.
201  */
202 library Math {
203     enum Rounding {
204         Down, // Toward negative infinity
205         Up, // Toward infinity
206         Zero // Toward zero
207     }
208 
209     /**
210      * @dev Returns the largest of two numbers.
211      */
212     function max(uint256 a, uint256 b) internal pure returns (uint256) {
213         return a > b ? a : b;
214     }
215 
216     /**
217      * @dev Returns the smallest of two numbers.
218      */
219     function min(uint256 a, uint256 b) internal pure returns (uint256) {
220         return a < b ? a : b;
221     }
222 
223     /**
224      * @dev Returns the average of two numbers. The result is rounded towards
225      * zero.
226      */
227     function average(uint256 a, uint256 b) internal pure returns (uint256) {
228         // (a + b) / 2 can overflow.
229         return (a & b) + (a ^ b) / 2;
230     }
231 
232     /**
233      * @dev Returns the ceiling of the division of two numbers.
234      *
235      * This differs from standard division with `/` in that it rounds up instead
236      * of rounding down.
237      */
238     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
239         // (a + b - 1) / b can overflow on addition, so we distribute.
240         return a == 0 ? 0 : (a - 1) / b + 1;
241     }
242 
243     /**
244      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
245      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
246      * with further edits by Uniswap Labs also under MIT license.
247      */
248     function mulDiv(
249         uint256 x,
250         uint256 y,
251         uint256 denominator
252     ) internal pure returns (uint256 result) {
253         unchecked {
254             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
255             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
256             // variables such that product = prod1 * 2^256 + prod0.
257             uint256 prod0; // Least significant 256 bits of the product
258             uint256 prod1; // Most significant 256 bits of the product
259             assembly {
260                 let mm := mulmod(x, y, not(0))
261                 prod0 := mul(x, y)
262                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
263             }
264 
265             // Handle non-overflow cases, 256 by 256 division.
266             if (prod1 == 0) {
267                 return prod0 / denominator;
268             }
269 
270             // Make sure the result is less than 2^256. Also prevents denominator == 0.
271             require(denominator > prod1);
272 
273             ///////////////////////////////////////////////
274             // 512 by 256 division.
275             ///////////////////////////////////////////////
276 
277             // Make division exact by subtracting the remainder from [prod1 prod0].
278             uint256 remainder;
279             assembly {
280                 // Compute remainder using mulmod.
281                 remainder := mulmod(x, y, denominator)
282 
283                 // Subtract 256 bit number from 512 bit number.
284                 prod1 := sub(prod1, gt(remainder, prod0))
285                 prod0 := sub(prod0, remainder)
286             }
287 
288             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
289             // See https://cs.stackexchange.com/q/138556/92363.
290 
291             // Does not overflow because the denominator cannot be zero at this stage in the function.
292             uint256 twos = denominator & (~denominator + 1);
293             assembly {
294                 // Divide denominator by twos.
295                 denominator := div(denominator, twos)
296 
297                 // Divide [prod1 prod0] by twos.
298                 prod0 := div(prod0, twos)
299 
300                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
301                 twos := add(div(sub(0, twos), twos), 1)
302             }
303 
304             // Shift in bits from prod1 into prod0.
305             prod0 |= prod1 * twos;
306 
307             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
308             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
309             // four bits. That is, denominator * inv = 1 mod 2^4.
310             uint256 inverse = (3 * denominator) ^ 2;
311 
312             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
313             // in modular arithmetic, doubling the correct bits in each step.
314             inverse *= 2 - denominator * inverse; // inverse mod 2^8
315             inverse *= 2 - denominator * inverse; // inverse mod 2^16
316             inverse *= 2 - denominator * inverse; // inverse mod 2^32
317             inverse *= 2 - denominator * inverse; // inverse mod 2^64
318             inverse *= 2 - denominator * inverse; // inverse mod 2^128
319             inverse *= 2 - denominator * inverse; // inverse mod 2^256
320 
321             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
322             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
323             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
324             // is no longer required.
325             result = prod0 * inverse;
326             return result;
327         }
328     }
329 
330     /**
331      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
332      */
333     function mulDiv(
334         uint256 x,
335         uint256 y,
336         uint256 denominator,
337         Rounding rounding
338     ) internal pure returns (uint256) {
339         uint256 result = mulDiv(x, y, denominator);
340         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
341             result += 1;
342         }
343         return result;
344     }
345 
346     /**
347      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
348      *
349      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
350      */
351     function sqrt(uint256 a) internal pure returns (uint256) {
352         if (a == 0) {
353             return 0;
354         }
355 
356         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
357         //
358         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
359         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
360         //
361         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
362         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
363         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
364         //
365         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
366         uint256 result = 1 << (log2(a) >> 1);
367 
368         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
369         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
370         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
371         // into the expected uint128 result.
372         unchecked {
373             result = (result + a / result) >> 1;
374             result = (result + a / result) >> 1;
375             result = (result + a / result) >> 1;
376             result = (result + a / result) >> 1;
377             result = (result + a / result) >> 1;
378             result = (result + a / result) >> 1;
379             result = (result + a / result) >> 1;
380             return min(result, a / result);
381         }
382     }
383 
384     /**
385      * @notice Calculates sqrt(a), following the selected rounding direction.
386      */
387     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
388         unchecked {
389             uint256 result = sqrt(a);
390             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
391         }
392     }
393 
394     /**
395      * @dev Return the log in base 2, rounded down, of a positive value.
396      * Returns 0 if given 0.
397      */
398     function log2(uint256 value) internal pure returns (uint256) {
399         uint256 result = 0;
400         unchecked {
401             if (value >> 128 > 0) {
402                 value >>= 128;
403                 result += 128;
404             }
405             if (value >> 64 > 0) {
406                 value >>= 64;
407                 result += 64;
408             }
409             if (value >> 32 > 0) {
410                 value >>= 32;
411                 result += 32;
412             }
413             if (value >> 16 > 0) {
414                 value >>= 16;
415                 result += 16;
416             }
417             if (value >> 8 > 0) {
418                 value >>= 8;
419                 result += 8;
420             }
421             if (value >> 4 > 0) {
422                 value >>= 4;
423                 result += 4;
424             }
425             if (value >> 2 > 0) {
426                 value >>= 2;
427                 result += 2;
428             }
429             if (value >> 1 > 0) {
430                 result += 1;
431             }
432         }
433         return result;
434     }
435 
436     /**
437      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
438      * Returns 0 if given 0.
439      */
440     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
441         unchecked {
442             uint256 result = log2(value);
443             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
444         }
445     }
446 
447     /**
448      * @dev Return the log in base 10, rounded down, of a positive value.
449      * Returns 0 if given 0.
450      */
451     function log10(uint256 value) internal pure returns (uint256) {
452         uint256 result = 0;
453         unchecked {
454             if (value >= 10**64) {
455                 value /= 10**64;
456                 result += 64;
457             }
458             if (value >= 10**32) {
459                 value /= 10**32;
460                 result += 32;
461             }
462             if (value >= 10**16) {
463                 value /= 10**16;
464                 result += 16;
465             }
466             if (value >= 10**8) {
467                 value /= 10**8;
468                 result += 8;
469             }
470             if (value >= 10**4) {
471                 value /= 10**4;
472                 result += 4;
473             }
474             if (value >= 10**2) {
475                 value /= 10**2;
476                 result += 2;
477             }
478             if (value >= 10**1) {
479                 result += 1;
480             }
481         }
482         return result;
483     }
484 
485     /**
486      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
487      * Returns 0 if given 0.
488      */
489     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
490         unchecked {
491             uint256 result = log10(value);
492             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
493         }
494     }
495 
496     /**
497      * @dev Return the log in base 256, rounded down, of a positive value.
498      * Returns 0 if given 0.
499      *
500      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
501      */
502     function log256(uint256 value) internal pure returns (uint256) {
503         uint256 result = 0;
504         unchecked {
505             if (value >> 128 > 0) {
506                 value >>= 128;
507                 result += 16;
508             }
509             if (value >> 64 > 0) {
510                 value >>= 64;
511                 result += 8;
512             }
513             if (value >> 32 > 0) {
514                 value >>= 32;
515                 result += 4;
516             }
517             if (value >> 16 > 0) {
518                 value >>= 16;
519                 result += 2;
520             }
521             if (value >> 8 > 0) {
522                 result += 1;
523             }
524         }
525         return result;
526     }
527 
528     /**
529      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
530      * Returns 0 if given 0.
531      */
532     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
533         unchecked {
534             uint256 result = log256(value);
535             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
536         }
537     }
538 }
539 
540 // File: @openzeppelin/contracts/utils/Strings.sol
541 
542 
543 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
544 
545 pragma solidity ^0.8.0;
546 
547 
548 /**
549  * @dev String operations.
550  */
551 library Strings {
552     bytes16 private constant _SYMBOLS = "0123456789abcdef";
553     uint8 private constant _ADDRESS_LENGTH = 20;
554 
555     /**
556      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
557      */
558     function toString(uint256 value) internal pure returns (string memory) {
559         unchecked {
560             uint256 length = Math.log10(value) + 1;
561             string memory buffer = new string(length);
562             uint256 ptr;
563             /// @solidity memory-safe-assembly
564             assembly {
565                 ptr := add(buffer, add(32, length))
566             }
567             while (true) {
568                 ptr--;
569                 /// @solidity memory-safe-assembly
570                 assembly {
571                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
572                 }
573                 value /= 10;
574                 if (value == 0) break;
575             }
576             return buffer;
577         }
578     }
579 
580     /**
581      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
582      */
583     function toHexString(uint256 value) internal pure returns (string memory) {
584         unchecked {
585             return toHexString(value, Math.log256(value) + 1);
586         }
587     }
588 
589     /**
590      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
591      */
592     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
593         bytes memory buffer = new bytes(2 * length + 2);
594         buffer[0] = "0";
595         buffer[1] = "x";
596         for (uint256 i = 2 * length + 1; i > 1; --i) {
597             buffer[i] = _SYMBOLS[value & 0xf];
598             value >>= 4;
599         }
600         require(value == 0, "Strings: hex length insufficient");
601         return string(buffer);
602     }
603 
604     /**
605      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
606      */
607     function toHexString(address addr) internal pure returns (string memory) {
608         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
609     }
610 }
611 
612 // File: erc721a/contracts/IERC721A.sol
613 
614 
615 // ERC721A Contracts v4.2.3
616 // Creator: Chiru Labs
617 
618 pragma solidity ^0.8.4;
619 
620 /**
621  * @dev Interface of ERC721A.
622  */
623 interface IERC721A {
624     /**
625      * The caller must own the token or be an approved operator.
626      */
627     error ApprovalCallerNotOwnerNorApproved();
628 
629     /**
630      * The token does not exist.
631      */
632     error ApprovalQueryForNonexistentToken();
633 
634     /**
635      * Cannot query the balance for the zero address.
636      */
637     error BalanceQueryForZeroAddress();
638 
639     /**
640      * Cannot mint to the zero address.
641      */
642     error MintToZeroAddress();
643 
644     /**
645      * The quantity of tokens minted must be more than zero.
646      */
647     error MintZeroQuantity();
648 
649     /**
650      * The token does not exist.
651      */
652     error OwnerQueryForNonexistentToken();
653 
654     /**
655      * The caller must own the token or be an approved operator.
656      */
657     error TransferCallerNotOwnerNorApproved();
658 
659     /**
660      * The token must be owned by `from`.
661      */
662     error TransferFromIncorrectOwner();
663 
664     /**
665      * Cannot safely transfer to a contract that does not implement the
666      * ERC721Receiver interface.
667      */
668     error TransferToNonERC721ReceiverImplementer();
669 
670     /**
671      * Cannot transfer to the zero address.
672      */
673     error TransferToZeroAddress();
674 
675     /**
676      * The token does not exist.
677      */
678     error URIQueryForNonexistentToken();
679 
680     /**
681      * The `quantity` minted with ERC2309 exceeds the safety limit.
682      */
683     error MintERC2309QuantityExceedsLimit();
684 
685     /**
686      * The `extraData` cannot be set on an unintialized ownership slot.
687      */
688     error OwnershipNotInitializedForExtraData();
689 
690     // =============================================================
691     //                            STRUCTS
692     // =============================================================
693 
694     struct TokenOwnership {
695         // The address of the owner.
696         address addr;
697         // Stores the start time of ownership with minimal overhead for tokenomics.
698         uint64 startTimestamp;
699         // Whether the token has been burned.
700         bool burned;
701         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
702         uint24 extraData;
703     }
704 
705     // =============================================================
706     //                         TOKEN COUNTERS
707     // =============================================================
708 
709     /**
710      * @dev Returns the total number of tokens in existence.
711      * Burned tokens will reduce the count.
712      * To get the total number of tokens minted, please see {_totalMinted}.
713      */
714     function totalSupply() external view returns (uint256);
715 
716     // =============================================================
717     //                            IERC165
718     // =============================================================
719 
720     /**
721      * @dev Returns true if this contract implements the interface defined by
722      * `interfaceId`. See the corresponding
723      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
724      * to learn more about how these ids are created.
725      *
726      * This function call must use less than 30000 gas.
727      */
728     function supportsInterface(bytes4 interfaceId) external view returns (bool);
729 
730     // =============================================================
731     //                            IERC721
732     // =============================================================
733 
734     /**
735      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
736      */
737     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
738 
739     /**
740      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
741      */
742     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
743 
744     /**
745      * @dev Emitted when `owner` enables or disables
746      * (`approved`) `operator` to manage all of its assets.
747      */
748     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
749 
750     /**
751      * @dev Returns the number of tokens in `owner`'s account.
752      */
753     function balanceOf(address owner) external view returns (uint256 balance);
754 
755     /**
756      * @dev Returns the owner of the `tokenId` token.
757      *
758      * Requirements:
759      *
760      * - `tokenId` must exist.
761      */
762     function ownerOf(uint256 tokenId) external view returns (address owner);
763 
764     /**
765      * @dev Safely transfers `tokenId` token from `from` to `to`,
766      * checking first that contract recipients are aware of the ERC721 protocol
767      * to prevent tokens from being forever locked.
768      *
769      * Requirements:
770      *
771      * - `from` cannot be the zero address.
772      * - `to` cannot be the zero address.
773      * - `tokenId` token must exist and be owned by `from`.
774      * - If the caller is not `from`, it must be have been allowed to move
775      * this token by either {approve} or {setApprovalForAll}.
776      * - If `to` refers to a smart contract, it must implement
777      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
778      *
779      * Emits a {Transfer} event.
780      */
781     function safeTransferFrom(
782         address from,
783         address to,
784         uint256 tokenId,
785         bytes calldata data
786     ) external payable;
787 
788     /**
789      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
790      */
791     function safeTransferFrom(
792         address from,
793         address to,
794         uint256 tokenId
795     ) external payable;
796 
797     /**
798      * @dev Transfers `tokenId` from `from` to `to`.
799      *
800      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
801      * whenever possible.
802      *
803      * Requirements:
804      *
805      * - `from` cannot be the zero address.
806      * - `to` cannot be the zero address.
807      * - `tokenId` token must be owned by `from`.
808      * - If the caller is not `from`, it must be approved to move this token
809      * by either {approve} or {setApprovalForAll}.
810      *
811      * Emits a {Transfer} event.
812      */
813     function transferFrom(
814         address from,
815         address to,
816         uint256 tokenId
817     ) external payable;
818 
819     /**
820      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
821      * The approval is cleared when the token is transferred.
822      *
823      * Only a single account can be approved at a time, so approving the
824      * zero address clears previous approvals.
825      *
826      * Requirements:
827      *
828      * - The caller must own the token or be an approved operator.
829      * - `tokenId` must exist.
830      *
831      * Emits an {Approval} event.
832      */
833     function approve(address to, uint256 tokenId) external payable;
834 
835     /**
836      * @dev Approve or remove `operator` as an operator for the caller.
837      * Operators can call {transferFrom} or {safeTransferFrom}
838      * for any token owned by the caller.
839      *
840      * Requirements:
841      *
842      * - The `operator` cannot be the caller.
843      *
844      * Emits an {ApprovalForAll} event.
845      */
846     function setApprovalForAll(address operator, bool _approved) external;
847 
848     /**
849      * @dev Returns the account approved for `tokenId` token.
850      *
851      * Requirements:
852      *
853      * - `tokenId` must exist.
854      */
855     function getApproved(uint256 tokenId) external view returns (address operator);
856 
857     /**
858      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
859      *
860      * See {setApprovalForAll}.
861      */
862     function isApprovedForAll(address owner, address operator) external view returns (bool);
863 
864     // =============================================================
865     //                        IERC721Metadata
866     // =============================================================
867 
868     /**
869      * @dev Returns the token collection name.
870      */
871     function name() external view returns (string memory);
872 
873     /**
874      * @dev Returns the token collection symbol.
875      */
876     function symbol() external view returns (string memory);
877 
878     /**
879      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
880      */
881     function tokenURI(uint256 tokenId) external view returns (string memory);
882 
883     // =============================================================
884     //                           IERC2309
885     // =============================================================
886 
887     /**
888      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
889      * (inclusive) is transferred from `from` to `to`, as defined in the
890      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
891      *
892      * See {_mintERC2309} for more details.
893      */
894     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
895 }
896 
897 // File: erc721a/contracts/ERC721A.sol
898 
899 
900 // ERC721A Contracts v4.2.3
901 // Creator: Chiru Labs
902 
903 pragma solidity ^0.8.4;
904 
905 
906 /**
907  * @dev Interface of ERC721 token receiver.
908  */
909 interface ERC721A__IERC721Receiver {
910     function onERC721Received(
911         address operator,
912         address from,
913         uint256 tokenId,
914         bytes calldata data
915     ) external returns (bytes4);
916 }
917 
918 /**
919  * @title ERC721A
920  *
921  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
922  * Non-Fungible Token Standard, including the Metadata extension.
923  * Optimized for lower gas during batch mints.
924  *
925  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
926  * starting from `_startTokenId()`.
927  *
928  * Assumptions:
929  *
930  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
931  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
932  */
933 contract ERC721A is IERC721A {
934     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
935     struct TokenApprovalRef {
936         address value;
937     }
938 
939     // =============================================================
940     //                           CONSTANTS
941     // =============================================================
942 
943     // Mask of an entry in packed address data.
944     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
945 
946     // The bit position of `numberMinted` in packed address data.
947     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
948 
949     // The bit position of `numberBurned` in packed address data.
950     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
951 
952     // The bit position of `aux` in packed address data.
953     uint256 private constant _BITPOS_AUX = 192;
954 
955     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
956     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
957 
958     // The bit position of `startTimestamp` in packed ownership.
959     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
960 
961     // The bit mask of the `burned` bit in packed ownership.
962     uint256 private constant _BITMASK_BURNED = 1 << 224;
963 
964     // The bit position of the `nextInitialized` bit in packed ownership.
965     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
966 
967     // The bit mask of the `nextInitialized` bit in packed ownership.
968     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
969 
970     // The bit position of `extraData` in packed ownership.
971     uint256 private constant _BITPOS_EXTRA_DATA = 232;
972 
973     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
974     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
975 
976     // The mask of the lower 160 bits for addresses.
977     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
978 
979     // The maximum `quantity` that can be minted with {_mintERC2309}.
980     // This limit is to prevent overflows on the address data entries.
981     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
982     // is required to cause an overflow, which is unrealistic.
983     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
984 
985     // The `Transfer` event signature is given by:
986     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
987     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
988         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
989 
990     // =============================================================
991     //                            STORAGE
992     // =============================================================
993 
994     // The next token ID to be minted.
995     uint256 private _currentIndex;
996 
997     // The number of tokens burned.
998     uint256 private _burnCounter;
999 
1000     // Token name
1001     string private _name;
1002 
1003     // Token symbol
1004     string private _symbol;
1005 
1006     // Mapping from token ID to ownership details
1007     // An empty struct value does not necessarily mean the token is unowned.
1008     // See {_packedOwnershipOf} implementation for details.
1009     //
1010     // Bits Layout:
1011     // - [0..159]   `addr`
1012     // - [160..223] `startTimestamp`
1013     // - [224]      `burned`
1014     // - [225]      `nextInitialized`
1015     // - [232..255] `extraData`
1016     mapping(uint256 => uint256) private _packedOwnerships;
1017 
1018     // Mapping owner address to address data.
1019     //
1020     // Bits Layout:
1021     // - [0..63]    `balance`
1022     // - [64..127]  `numberMinted`
1023     // - [128..191] `numberBurned`
1024     // - [192..255] `aux`
1025     mapping(address => uint256) private _packedAddressData;
1026 
1027     // Mapping from token ID to approved address.
1028     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1029 
1030     // Mapping from owner to operator approvals
1031     mapping(address => mapping(address => bool)) private _operatorApprovals;
1032 
1033     // =============================================================
1034     //                          CONSTRUCTOR
1035     // =============================================================
1036 
1037     constructor(string memory name_, string memory symbol_) {
1038         _name = name_;
1039         _symbol = symbol_;
1040         _currentIndex = _startTokenId();
1041     }
1042 
1043     // =============================================================
1044     //                   TOKEN COUNTING OPERATIONS
1045     // =============================================================
1046 
1047     /**
1048      * @dev Returns the starting token ID.
1049      * To change the starting token ID, please override this function.
1050      */
1051     function _startTokenId() internal view virtual returns (uint256) {
1052         return 0;
1053     }
1054 
1055     /**
1056      * @dev Returns the next token ID to be minted.
1057      */
1058     function _nextTokenId() internal view virtual returns (uint256) {
1059         return _currentIndex;
1060     }
1061 
1062     /**
1063      * @dev Returns the total number of tokens in existence.
1064      * Burned tokens will reduce the count.
1065      * To get the total number of tokens minted, please see {_totalMinted}.
1066      */
1067     function totalSupply() public view virtual override returns (uint256) {
1068         // Counter underflow is impossible as _burnCounter cannot be incremented
1069         // more than `_currentIndex - _startTokenId()` times.
1070         unchecked {
1071             return _currentIndex - _burnCounter - _startTokenId();
1072         }
1073     }
1074 
1075     /**
1076      * @dev Returns the total amount of tokens minted in the contract.
1077      */
1078     function _totalMinted() internal view virtual returns (uint256) {
1079         // Counter underflow is impossible as `_currentIndex` does not decrement,
1080         // and it is initialized to `_startTokenId()`.
1081         unchecked {
1082             return _currentIndex - _startTokenId();
1083         }
1084     }
1085 
1086     /**
1087      * @dev Returns the total number of tokens burned.
1088      */
1089     function _totalBurned() internal view virtual returns (uint256) {
1090         return _burnCounter;
1091     }
1092 
1093     // =============================================================
1094     //                    ADDRESS DATA OPERATIONS
1095     // =============================================================
1096 
1097     /**
1098      * @dev Returns the number of tokens in `owner`'s account.
1099      */
1100     function balanceOf(address owner) public view virtual override returns (uint256) {
1101         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1102         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1103     }
1104 
1105     /**
1106      * Returns the number of tokens minted by `owner`.
1107      */
1108     function _numberMinted(address owner) internal view returns (uint256) {
1109         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1110     }
1111 
1112     /**
1113      * Returns the number of tokens burned by or on behalf of `owner`.
1114      */
1115     function _numberBurned(address owner) internal view returns (uint256) {
1116         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1117     }
1118 
1119     /**
1120      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1121      */
1122     function _getAux(address owner) internal view returns (uint64) {
1123         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1124     }
1125 
1126     /**
1127      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1128      * If there are multiple variables, please pack them into a uint64.
1129      */
1130     function _setAux(address owner, uint64 aux) internal virtual {
1131         uint256 packed = _packedAddressData[owner];
1132         uint256 auxCasted;
1133         // Cast `aux` with assembly to avoid redundant masking.
1134         assembly {
1135             auxCasted := aux
1136         }
1137         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1138         _packedAddressData[owner] = packed;
1139     }
1140 
1141     // =============================================================
1142     //                            IERC165
1143     // =============================================================
1144 
1145     /**
1146      * @dev Returns true if this contract implements the interface defined by
1147      * `interfaceId`. See the corresponding
1148      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1149      * to learn more about how these ids are created.
1150      *
1151      * This function call must use less than 30000 gas.
1152      */
1153     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1154         // The interface IDs are constants representing the first 4 bytes
1155         // of the XOR of all function selectors in the interface.
1156         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1157         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1158         return
1159             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1160             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1161             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1162     }
1163 
1164     // =============================================================
1165     //                        IERC721Metadata
1166     // =============================================================
1167 
1168     /**
1169      * @dev Returns the token collection name.
1170      */
1171     function name() public view virtual override returns (string memory) {
1172         return _name;
1173     }
1174 
1175     /**
1176      * @dev Returns the token collection symbol.
1177      */
1178     function symbol() public view virtual override returns (string memory) {
1179         return _symbol;
1180     }
1181 
1182     /**
1183      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1184      */
1185     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1186         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1187 
1188         string memory baseURI = _baseURI();
1189         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1190     }
1191 
1192     /**
1193      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1194      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1195      * by default, it can be overridden in child contracts.
1196      */
1197     function _baseURI() internal view virtual returns (string memory) {
1198         return '';
1199     }
1200 
1201     // =============================================================
1202     //                     OWNERSHIPS OPERATIONS
1203     // =============================================================
1204 
1205     /**
1206      * @dev Returns the owner of the `tokenId` token.
1207      *
1208      * Requirements:
1209      *
1210      * - `tokenId` must exist.
1211      */
1212     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1213         return address(uint160(_packedOwnershipOf(tokenId)));
1214     }
1215 
1216     /**
1217      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1218      * It gradually moves to O(1) as tokens get transferred around over time.
1219      */
1220     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1221         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1222     }
1223 
1224     /**
1225      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1226      */
1227     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1228         return _unpackedOwnership(_packedOwnerships[index]);
1229     }
1230 
1231     /**
1232      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1233      */
1234     function _initializeOwnershipAt(uint256 index) internal virtual {
1235         if (_packedOwnerships[index] == 0) {
1236             _packedOwnerships[index] = _packedOwnershipOf(index);
1237         }
1238     }
1239 
1240     /**
1241      * Returns the packed ownership data of `tokenId`.
1242      */
1243     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1244         uint256 curr = tokenId;
1245 
1246         unchecked {
1247             if (_startTokenId() <= curr)
1248                 if (curr < _currentIndex) {
1249                     uint256 packed = _packedOwnerships[curr];
1250                     // If not burned.
1251                     if (packed & _BITMASK_BURNED == 0) {
1252                         // Invariant:
1253                         // There will always be an initialized ownership slot
1254                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1255                         // before an unintialized ownership slot
1256                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1257                         // Hence, `curr` will not underflow.
1258                         //
1259                         // We can directly compare the packed value.
1260                         // If the address is zero, packed will be zero.
1261                         while (packed == 0) {
1262                             packed = _packedOwnerships[--curr];
1263                         }
1264                         return packed;
1265                     }
1266                 }
1267         }
1268         revert OwnerQueryForNonexistentToken();
1269     }
1270 
1271     /**
1272      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1273      */
1274     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1275         ownership.addr = address(uint160(packed));
1276         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1277         ownership.burned = packed & _BITMASK_BURNED != 0;
1278         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1279     }
1280 
1281     /**
1282      * @dev Packs ownership data into a single uint256.
1283      */
1284     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1285         assembly {
1286             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1287             owner := and(owner, _BITMASK_ADDRESS)
1288             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1289             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1290         }
1291     }
1292 
1293     /**
1294      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1295      */
1296     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1297         // For branchless setting of the `nextInitialized` flag.
1298         assembly {
1299             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1300             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1301         }
1302     }
1303 
1304     // =============================================================
1305     //                      APPROVAL OPERATIONS
1306     // =============================================================
1307 
1308     /**
1309      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1310      * The approval is cleared when the token is transferred.
1311      *
1312      * Only a single account can be approved at a time, so approving the
1313      * zero address clears previous approvals.
1314      *
1315      * Requirements:
1316      *
1317      * - The caller must own the token or be an approved operator.
1318      * - `tokenId` must exist.
1319      *
1320      * Emits an {Approval} event.
1321      */
1322     function approve(address to, uint256 tokenId) public payable virtual override {
1323         address owner = ownerOf(tokenId);
1324 
1325         if (_msgSenderERC721A() != owner)
1326             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1327                 revert ApprovalCallerNotOwnerNorApproved();
1328             }
1329 
1330         _tokenApprovals[tokenId].value = to;
1331         emit Approval(owner, to, tokenId);
1332     }
1333 
1334     /**
1335      * @dev Returns the account approved for `tokenId` token.
1336      *
1337      * Requirements:
1338      *
1339      * - `tokenId` must exist.
1340      */
1341     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1342         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1343 
1344         return _tokenApprovals[tokenId].value;
1345     }
1346 
1347     /**
1348      * @dev Approve or remove `operator` as an operator for the caller.
1349      * Operators can call {transferFrom} or {safeTransferFrom}
1350      * for any token owned by the caller.
1351      *
1352      * Requirements:
1353      *
1354      * - The `operator` cannot be the caller.
1355      *
1356      * Emits an {ApprovalForAll} event.
1357      */
1358     function setApprovalForAll(address operator, bool approved) public virtual override {
1359         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1360         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1361     }
1362 
1363     /**
1364      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1365      *
1366      * See {setApprovalForAll}.
1367      */
1368     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1369         return _operatorApprovals[owner][operator];
1370     }
1371 
1372     /**
1373      * @dev Returns whether `tokenId` exists.
1374      *
1375      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1376      *
1377      * Tokens start existing when they are minted. See {_mint}.
1378      */
1379     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1380         return
1381             _startTokenId() <= tokenId &&
1382             tokenId < _currentIndex && // If within bounds,
1383             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1384     }
1385 
1386     /**
1387      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1388      */
1389     function _isSenderApprovedOrOwner(
1390         address approvedAddress,
1391         address owner,
1392         address msgSender
1393     ) private pure returns (bool result) {
1394         assembly {
1395             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1396             owner := and(owner, _BITMASK_ADDRESS)
1397             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1398             msgSender := and(msgSender, _BITMASK_ADDRESS)
1399             // `msgSender == owner || msgSender == approvedAddress`.
1400             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1401         }
1402     }
1403 
1404     /**
1405      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1406      */
1407     function _getApprovedSlotAndAddress(uint256 tokenId)
1408         private
1409         view
1410         returns (uint256 approvedAddressSlot, address approvedAddress)
1411     {
1412         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1413         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1414         assembly {
1415             approvedAddressSlot := tokenApproval.slot
1416             approvedAddress := sload(approvedAddressSlot)
1417         }
1418     }
1419 
1420     // =============================================================
1421     //                      TRANSFER OPERATIONS
1422     // =============================================================
1423 
1424     /**
1425      * @dev Transfers `tokenId` from `from` to `to`.
1426      *
1427      * Requirements:
1428      *
1429      * - `from` cannot be the zero address.
1430      * - `to` cannot be the zero address.
1431      * - `tokenId` token must be owned by `from`.
1432      * - If the caller is not `from`, it must be approved to move this token
1433      * by either {approve} or {setApprovalForAll}.
1434      *
1435      * Emits a {Transfer} event.
1436      */
1437     function transferFrom(
1438         address from,
1439         address to,
1440         uint256 tokenId
1441     ) public payable virtual override {
1442         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1443 
1444         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1445 
1446         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1447 
1448         // The nested ifs save around 20+ gas over a compound boolean condition.
1449         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1450             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1451 
1452         if (to == address(0)) revert TransferToZeroAddress();
1453 
1454         _beforeTokenTransfers(from, to, tokenId, 1);
1455 
1456         // Clear approvals from the previous owner.
1457         assembly {
1458             if approvedAddress {
1459                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1460                 sstore(approvedAddressSlot, 0)
1461             }
1462         }
1463 
1464         // Underflow of the sender's balance is impossible because we check for
1465         // ownership above and the recipient's balance can't realistically overflow.
1466         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1467         unchecked {
1468             // We can directly increment and decrement the balances.
1469             --_packedAddressData[from]; // Updates: `balance -= 1`.
1470             ++_packedAddressData[to]; // Updates: `balance += 1`.
1471 
1472             // Updates:
1473             // - `address` to the next owner.
1474             // - `startTimestamp` to the timestamp of transfering.
1475             // - `burned` to `false`.
1476             // - `nextInitialized` to `true`.
1477             _packedOwnerships[tokenId] = _packOwnershipData(
1478                 to,
1479                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1480             );
1481 
1482             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1483             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1484                 uint256 nextTokenId = tokenId + 1;
1485                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1486                 if (_packedOwnerships[nextTokenId] == 0) {
1487                     // If the next slot is within bounds.
1488                     if (nextTokenId != _currentIndex) {
1489                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1490                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1491                     }
1492                 }
1493             }
1494         }
1495 
1496         emit Transfer(from, to, tokenId);
1497         _afterTokenTransfers(from, to, tokenId, 1);
1498     }
1499 
1500     /**
1501      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1502      */
1503     function safeTransferFrom(
1504         address from,
1505         address to,
1506         uint256 tokenId
1507     ) public payable virtual override {
1508         safeTransferFrom(from, to, tokenId, '');
1509     }
1510 
1511     /**
1512      * @dev Safely transfers `tokenId` token from `from` to `to`.
1513      *
1514      * Requirements:
1515      *
1516      * - `from` cannot be the zero address.
1517      * - `to` cannot be the zero address.
1518      * - `tokenId` token must exist and be owned by `from`.
1519      * - If the caller is not `from`, it must be approved to move this token
1520      * by either {approve} or {setApprovalForAll}.
1521      * - If `to` refers to a smart contract, it must implement
1522      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1523      *
1524      * Emits a {Transfer} event.
1525      */
1526     function safeTransferFrom(
1527         address from,
1528         address to,
1529         uint256 tokenId,
1530         bytes memory _data
1531     ) public payable virtual override {
1532         transferFrom(from, to, tokenId);
1533         if (to.code.length != 0)
1534             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1535                 revert TransferToNonERC721ReceiverImplementer();
1536             }
1537     }
1538 
1539     /**
1540      * @dev Hook that is called before a set of serially-ordered token IDs
1541      * are about to be transferred. This includes minting.
1542      * And also called before burning one token.
1543      *
1544      * `startTokenId` - the first token ID to be transferred.
1545      * `quantity` - the amount to be transferred.
1546      *
1547      * Calling conditions:
1548      *
1549      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1550      * transferred to `to`.
1551      * - When `from` is zero, `tokenId` will be minted for `to`.
1552      * - When `to` is zero, `tokenId` will be burned by `from`.
1553      * - `from` and `to` are never both zero.
1554      */
1555     function _beforeTokenTransfers(
1556         address from,
1557         address to,
1558         uint256 startTokenId,
1559         uint256 quantity
1560     ) internal virtual {}
1561 
1562     /**
1563      * @dev Hook that is called after a set of serially-ordered token IDs
1564      * have been transferred. This includes minting.
1565      * And also called after one token has been burned.
1566      *
1567      * `startTokenId` - the first token ID to be transferred.
1568      * `quantity` - the amount to be transferred.
1569      *
1570      * Calling conditions:
1571      *
1572      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1573      * transferred to `to`.
1574      * - When `from` is zero, `tokenId` has been minted for `to`.
1575      * - When `to` is zero, `tokenId` has been burned by `from`.
1576      * - `from` and `to` are never both zero.
1577      */
1578     function _afterTokenTransfers(
1579         address from,
1580         address to,
1581         uint256 startTokenId,
1582         uint256 quantity
1583     ) internal virtual {}
1584 
1585     /**
1586      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1587      *
1588      * `from` - Previous owner of the given token ID.
1589      * `to` - Target address that will receive the token.
1590      * `tokenId` - Token ID to be transferred.
1591      * `_data` - Optional data to send along with the call.
1592      *
1593      * Returns whether the call correctly returned the expected magic value.
1594      */
1595     function _checkContractOnERC721Received(
1596         address from,
1597         address to,
1598         uint256 tokenId,
1599         bytes memory _data
1600     ) private returns (bool) {
1601         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1602             bytes4 retval
1603         ) {
1604             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1605         } catch (bytes memory reason) {
1606             if (reason.length == 0) {
1607                 revert TransferToNonERC721ReceiverImplementer();
1608             } else {
1609                 assembly {
1610                     revert(add(32, reason), mload(reason))
1611                 }
1612             }
1613         }
1614     }
1615 
1616     // =============================================================
1617     //                        MINT OPERATIONS
1618     // =============================================================
1619 
1620     /**
1621      * @dev Mints `quantity` tokens and transfers them to `to`.
1622      *
1623      * Requirements:
1624      *
1625      * - `to` cannot be the zero address.
1626      * - `quantity` must be greater than 0.
1627      *
1628      * Emits a {Transfer} event for each mint.
1629      */
1630     function _mint(address to, uint256 quantity) internal virtual {
1631         uint256 startTokenId = _currentIndex;
1632         if (quantity == 0) revert MintZeroQuantity();
1633 
1634         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1635 
1636         // Overflows are incredibly unrealistic.
1637         // `balance` and `numberMinted` have a maximum limit of 2**64.
1638         // `tokenId` has a maximum limit of 2**256.
1639         unchecked {
1640             // Updates:
1641             // - `balance += quantity`.
1642             // - `numberMinted += quantity`.
1643             //
1644             // We can directly add to the `balance` and `numberMinted`.
1645             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1646 
1647             // Updates:
1648             // - `address` to the owner.
1649             // - `startTimestamp` to the timestamp of minting.
1650             // - `burned` to `false`.
1651             // - `nextInitialized` to `quantity == 1`.
1652             _packedOwnerships[startTokenId] = _packOwnershipData(
1653                 to,
1654                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1655             );
1656 
1657             uint256 toMasked;
1658             uint256 end = startTokenId + quantity;
1659 
1660             // Use assembly to loop and emit the `Transfer` event for gas savings.
1661             // The duplicated `log4` removes an extra check and reduces stack juggling.
1662             // The assembly, together with the surrounding Solidity code, have been
1663             // delicately arranged to nudge the compiler into producing optimized opcodes.
1664             assembly {
1665                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1666                 toMasked := and(to, _BITMASK_ADDRESS)
1667                 // Emit the `Transfer` event.
1668                 log4(
1669                     0, // Start of data (0, since no data).
1670                     0, // End of data (0, since no data).
1671                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1672                     0, // `address(0)`.
1673                     toMasked, // `to`.
1674                     startTokenId // `tokenId`.
1675                 )
1676 
1677                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1678                 // that overflows uint256 will make the loop run out of gas.
1679                 // The compiler will optimize the `iszero` away for performance.
1680                 for {
1681                     let tokenId := add(startTokenId, 1)
1682                 } iszero(eq(tokenId, end)) {
1683                     tokenId := add(tokenId, 1)
1684                 } {
1685                     // Emit the `Transfer` event. Similar to above.
1686                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1687                 }
1688             }
1689             if (toMasked == 0) revert MintToZeroAddress();
1690 
1691             _currentIndex = end;
1692         }
1693         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1694     }
1695 
1696     /**
1697      * @dev Mints `quantity` tokens and transfers them to `to`.
1698      *
1699      * This function is intended for efficient minting only during contract creation.
1700      *
1701      * It emits only one {ConsecutiveTransfer} as defined in
1702      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1703      * instead of a sequence of {Transfer} event(s).
1704      *
1705      * Calling this function outside of contract creation WILL make your contract
1706      * non-compliant with the ERC721 standard.
1707      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1708      * {ConsecutiveTransfer} event is only permissible during contract creation.
1709      *
1710      * Requirements:
1711      *
1712      * - `to` cannot be the zero address.
1713      * - `quantity` must be greater than 0.
1714      *
1715      * Emits a {ConsecutiveTransfer} event.
1716      */
1717     function _mintERC2309(address to, uint256 quantity) internal virtual {
1718         uint256 startTokenId = _currentIndex;
1719         if (to == address(0)) revert MintToZeroAddress();
1720         if (quantity == 0) revert MintZeroQuantity();
1721         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1722 
1723         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1724 
1725         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1726         unchecked {
1727             // Updates:
1728             // - `balance += quantity`.
1729             // - `numberMinted += quantity`.
1730             //
1731             // We can directly add to the `balance` and `numberMinted`.
1732             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1733 
1734             // Updates:
1735             // - `address` to the owner.
1736             // - `startTimestamp` to the timestamp of minting.
1737             // - `burned` to `false`.
1738             // - `nextInitialized` to `quantity == 1`.
1739             _packedOwnerships[startTokenId] = _packOwnershipData(
1740                 to,
1741                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1742             );
1743 
1744             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1745 
1746             _currentIndex = startTokenId + quantity;
1747         }
1748         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1749     }
1750 
1751     /**
1752      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1753      *
1754      * Requirements:
1755      *
1756      * - If `to` refers to a smart contract, it must implement
1757      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1758      * - `quantity` must be greater than 0.
1759      *
1760      * See {_mint}.
1761      *
1762      * Emits a {Transfer} event for each mint.
1763      */
1764     function _safeMint(
1765         address to,
1766         uint256 quantity,
1767         bytes memory _data
1768     ) internal virtual {
1769         _mint(to, quantity);
1770 
1771         unchecked {
1772             if (to.code.length != 0) {
1773                 uint256 end = _currentIndex;
1774                 uint256 index = end - quantity;
1775                 do {
1776                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1777                         revert TransferToNonERC721ReceiverImplementer();
1778                     }
1779                 } while (index < end);
1780                 // Reentrancy protection.
1781                 if (_currentIndex != end) revert();
1782             }
1783         }
1784     }
1785 
1786     /**
1787      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1788      */
1789     function _safeMint(address to, uint256 quantity) internal virtual {
1790         _safeMint(to, quantity, '');
1791     }
1792 
1793     // =============================================================
1794     //                        BURN OPERATIONS
1795     // =============================================================
1796 
1797     /**
1798      * @dev Equivalent to `_burn(tokenId, false)`.
1799      */
1800     function _burn(uint256 tokenId) internal virtual {
1801         _burn(tokenId, false);
1802     }
1803 
1804     /**
1805      * @dev Destroys `tokenId`.
1806      * The approval is cleared when the token is burned.
1807      *
1808      * Requirements:
1809      *
1810      * - `tokenId` must exist.
1811      *
1812      * Emits a {Transfer} event.
1813      */
1814     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1815         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1816 
1817         address from = address(uint160(prevOwnershipPacked));
1818 
1819         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1820 
1821         if (approvalCheck) {
1822             // The nested ifs save around 20+ gas over a compound boolean condition.
1823             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1824                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1825         }
1826 
1827         _beforeTokenTransfers(from, address(0), tokenId, 1);
1828 
1829         // Clear approvals from the previous owner.
1830         assembly {
1831             if approvedAddress {
1832                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1833                 sstore(approvedAddressSlot, 0)
1834             }
1835         }
1836 
1837         // Underflow of the sender's balance is impossible because we check for
1838         // ownership above and the recipient's balance can't realistically overflow.
1839         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1840         unchecked {
1841             // Updates:
1842             // - `balance -= 1`.
1843             // - `numberBurned += 1`.
1844             //
1845             // We can directly decrement the balance, and increment the number burned.
1846             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1847             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1848 
1849             // Updates:
1850             // - `address` to the last owner.
1851             // - `startTimestamp` to the timestamp of burning.
1852             // - `burned` to `true`.
1853             // - `nextInitialized` to `true`.
1854             _packedOwnerships[tokenId] = _packOwnershipData(
1855                 from,
1856                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1857             );
1858 
1859             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1860             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1861                 uint256 nextTokenId = tokenId + 1;
1862                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1863                 if (_packedOwnerships[nextTokenId] == 0) {
1864                     // If the next slot is within bounds.
1865                     if (nextTokenId != _currentIndex) {
1866                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1867                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1868                     }
1869                 }
1870             }
1871         }
1872 
1873         emit Transfer(from, address(0), tokenId);
1874         _afterTokenTransfers(from, address(0), tokenId, 1);
1875 
1876         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1877         unchecked {
1878             _burnCounter++;
1879         }
1880     }
1881 
1882     // =============================================================
1883     //                     EXTRA DATA OPERATIONS
1884     // =============================================================
1885 
1886     /**
1887      * @dev Directly sets the extra data for the ownership data `index`.
1888      */
1889     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1890         uint256 packed = _packedOwnerships[index];
1891         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1892         uint256 extraDataCasted;
1893         // Cast `extraData` with assembly to avoid redundant masking.
1894         assembly {
1895             extraDataCasted := extraData
1896         }
1897         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1898         _packedOwnerships[index] = packed;
1899     }
1900 
1901     /**
1902      * @dev Called during each token transfer to set the 24bit `extraData` field.
1903      * Intended to be overridden by the cosumer contract.
1904      *
1905      * `previousExtraData` - the value of `extraData` before transfer.
1906      *
1907      * Calling conditions:
1908      *
1909      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1910      * transferred to `to`.
1911      * - When `from` is zero, `tokenId` will be minted for `to`.
1912      * - When `to` is zero, `tokenId` will be burned by `from`.
1913      * - `from` and `to` are never both zero.
1914      */
1915     function _extraData(
1916         address from,
1917         address to,
1918         uint24 previousExtraData
1919     ) internal view virtual returns (uint24) {}
1920 
1921     /**
1922      * @dev Returns the next extra data for the packed ownership data.
1923      * The returned result is shifted into position.
1924      */
1925     function _nextExtraData(
1926         address from,
1927         address to,
1928         uint256 prevOwnershipPacked
1929     ) private view returns (uint256) {
1930         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1931         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1932     }
1933 
1934     // =============================================================
1935     //                       OTHER OPERATIONS
1936     // =============================================================
1937 
1938     /**
1939      * @dev Returns the message sender (defaults to `msg.sender`).
1940      *
1941      * If you are writing GSN compatible contracts, you need to override this function.
1942      */
1943     function _msgSenderERC721A() internal view virtual returns (address) {
1944         return msg.sender;
1945     }
1946 
1947     /**
1948      * @dev Converts a uint256 to its ASCII string decimal representation.
1949      */
1950     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1951         assembly {
1952             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1953             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1954             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1955             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1956             let m := add(mload(0x40), 0xa0)
1957             // Update the free memory pointer to allocate.
1958             mstore(0x40, m)
1959             // Assign the `str` to the end.
1960             str := sub(m, 0x20)
1961             // Zeroize the slot after the string.
1962             mstore(str, 0)
1963 
1964             // Cache the end of the memory to calculate the length later.
1965             let end := str
1966 
1967             // We write the string from rightmost digit to leftmost digit.
1968             // The following is essentially a do-while loop that also handles the zero case.
1969             // prettier-ignore
1970             for { let temp := value } 1 {} {
1971                 str := sub(str, 1)
1972                 // Write the character to the pointer.
1973                 // The ASCII index of the '0' character is 48.
1974                 mstore8(str, add(48, mod(temp, 10)))
1975                 // Keep dividing `temp` until zero.
1976                 temp := div(temp, 10)
1977                 // prettier-ignore
1978                 if iszero(temp) { break }
1979             }
1980 
1981             let length := sub(end, str)
1982             // Move the pointer 32 bytes leftwards to make room for the length.
1983             str := sub(str, 0x20)
1984             // Store the length.
1985             mstore(str, length)
1986         }
1987     }
1988 }
1989 
1990 // File: @openzeppelin/contracts/utils/Context.sol
1991 
1992 
1993 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1994 
1995 pragma solidity ^0.8.0;
1996 
1997 /**
1998  * @dev Provides information about the current execution context, including the
1999  * sender of the transaction and its data. While these are generally available
2000  * via msg.sender and msg.data, they should not be accessed in such a direct
2001  * manner, since when dealing with meta-transactions the account sending and
2002  * paying for execution may not be the actual sender (as far as an application
2003  * is concerned).
2004  *
2005  * This contract is only required for intermediate, library-like contracts.
2006  */
2007 abstract contract Context {
2008     function _msgSender() internal view virtual returns (address) {
2009         return msg.sender;
2010     }
2011 
2012     function _msgData() internal view virtual returns (bytes calldata) {
2013         return msg.data;
2014     }
2015 }
2016 
2017 // File: @openzeppelin/contracts/access/Ownable.sol
2018 
2019 
2020 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2021 
2022 pragma solidity ^0.8.0;
2023 
2024 
2025 /**
2026  * @dev Contract module which provides a basic access control mechanism, where
2027  * there is an account (an owner) that can be granted exclusive access to
2028  * specific functions.
2029  *
2030  * By default, the owner account will be the one that deploys the contract. This
2031  * can later be changed with {transferOwnership}.
2032  *
2033  * This module is used through inheritance. It will make available the modifier
2034  * `onlyOwner`, which can be applied to your functions to restrict their use to
2035  * the owner.
2036  */
2037 abstract contract Ownable is Context {
2038     address private _owner;
2039 
2040     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2041 
2042     /**
2043      * @dev Initializes the contract setting the deployer as the initial owner.
2044      */
2045     constructor() {
2046         _transferOwnership(_msgSender());
2047     }
2048 
2049     /**
2050      * @dev Throws if called by any account other than the owner.
2051      */
2052     modifier onlyOwner() {
2053         _checkOwner();
2054         _;
2055     }
2056 
2057     /**
2058      * @dev Returns the address of the current owner.
2059      */
2060     function owner() public view virtual returns (address) {
2061         return _owner;
2062     }
2063 
2064     /**
2065      * @dev Throws if the sender is not the owner.
2066      */
2067     function _checkOwner() internal view virtual {
2068         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2069     }
2070 
2071     /**
2072      * @dev Leaves the contract without owner. It will not be possible to call
2073      * `onlyOwner` functions anymore. Can only be called by the current owner.
2074      *
2075      * NOTE: Renouncing ownership will leave the contract without an owner,
2076      * thereby removing any functionality that is only available to the owner.
2077      */
2078     function renounceOwnership() public virtual onlyOwner {
2079         _transferOwnership(address(0));
2080     }
2081 
2082     /**
2083      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2084      * Can only be called by the current owner.
2085      */
2086     function transferOwnership(address newOwner) public virtual onlyOwner {
2087         require(newOwner != address(0), "Ownable: new owner is the zero address");
2088         _transferOwnership(newOwner);
2089     }
2090 
2091     /**
2092      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2093      * Internal function without access restriction.
2094      */
2095     function _transferOwnership(address newOwner) internal virtual {
2096         address oldOwner = _owner;
2097         _owner = newOwner;
2098         emit OwnershipTransferred(oldOwner, newOwner);
2099     }
2100 }
2101 
2102 // File: apeapeapeape.sol
2103 
2104 
2105 
2106 
2107 //  
2108 // ╭━━━┳━━━┳━━━┳━━━╮
2109 // ┃╭━╮┃╭━━┫╭━╮┃╭━━╯
2110 // ┃╰━╯┃╰━━┫╰━╯┃╰━━╮
2111 // ┃╭━━┫╭━━┫╭━━┫╭━━╯
2112 // ┃┃╱╱┃╰━━┫┃╱╱┃╰━━╮
2113 // ╰╯╱╱╰━━━┻╯╱╱╰━━━╯
2114 
2115         pragma solidity ^0.8.13;
2116 
2117 
2118 
2119 
2120 
2121 
2122         contract Pepes1935 is ERC721A, Ownable, ReentrancyGuard  , DefaultOperatorFilterer{
2123             using Strings for uint256;
2124             uint256 public _maxSupply = 2222;
2125             uint256 public maxMintAmountPerWallet = 5;
2126             uint256 public maxMintAmountPerTx = 5;
2127             string baseURL = "";
2128             string ExtensionURL = ".json";
2129             uint256 _initalPrice = 0 ether;
2130             uint256 public costOfNFT = 0.003 ether;
2131             uint256 public numberOfFreeNFTs = 1;
2132             
2133             string HiddenURL;
2134             bool revealed = false;
2135             bool paused = true;
2136             
2137             error ContractPaused();
2138             error MaxMintWalletExceeded();
2139             error MaxSupply();
2140             error InvalidMintAmount();
2141             error InsufficientFund();
2142             error NoSmartContract();
2143             error TokenNotExisting();
2144 
2145         constructor(string memory _initBaseURI) ERC721A("1935 Pepes", "Pepe35") {
2146             baseURL = _initBaseURI;
2147         }
2148 
2149         // ================== Mint Function =======================
2150 
2151         modifier mintCompliance(uint256 _mintAmount) {
2152             if (msg.sender != tx.origin) revert NoSmartContract();
2153             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2154             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2155             if(paused) revert ContractPaused();
2156             _;
2157         }
2158 
2159         modifier mintPriceCompliance(uint256 _mintAmount) {
2160             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2161             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2162               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2163             _;
2164         }
2165         
2166         /// @notice compliance of minting
2167         /// @dev user (msg.sender) mint
2168         /// @param _mintAmount the amount of tokens to mint
2169         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2170          
2171           
2172           _safeMint(msg.sender, _mintAmount);
2173           }
2174 
2175         /// @dev user (msg.sender) mint
2176         /// @param _mintAmount the amount of tokens to mint 
2177         /// @return value from number to mint
2178         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2179           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2180           if ((totalMints <= numberOfFreeNFTs) ) {
2181           return _initalPrice;
2182           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2183           uint256 total = costOfNFT * (_mintAmount - numberOfFreeNFTs);
2184           return total;
2185           } 
2186           else {
2187           uint256 total2 = costOfNFT * _mintAmount;
2188           return total2;
2189             }
2190         }
2191         
2192 
2193 
2194         /// @notice airdrop function to airdrop same amount of tokens to addresses
2195         /// @dev only owner function
2196         /// @param accounts  array of addresses
2197         /// @param amount the amount of tokens to airdrop users
2198         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2199           for(uint256 i = 0; i < accounts.length; i++){
2200           _safeMint(accounts[i], amount);
2201           }
2202         }
2203 
2204         // =================== Orange Functions (Owner Only) ===============
2205 
2206         /// @dev pause/unpause minting
2207         function pause() public onlyOwner {
2208           paused = !paused;
2209         }
2210 
2211         
2212 
2213         /// @dev set URI
2214         /// @param uri  new URI
2215         function setbaseURL(string memory uri) public onlyOwner{
2216           baseURL = uri;
2217         }
2218 
2219         /// @dev extension URI like 'json'
2220         function setExtensionURL(string memory uri) public onlyOwner{
2221           ExtensionURL = uri;
2222         }
2223         
2224         /// @dev set new cost of tokenId in WEI
2225         /// @param _cost  new price in wei
2226         function setCostPrice(uint256 _cost) public onlyOwner{
2227           costOfNFT = _cost;
2228         } 
2229 
2230         /// @dev only owner
2231         /// @param supply  new max supply
2232         function setSupply(uint256 supply) public onlyOwner{
2233           _maxSupply = supply;
2234         }
2235 
2236         /// @dev only owner
2237         /// @param perTx  new max mint per transaction
2238         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2239           maxMintAmountPerTx = perTx;
2240         }
2241 
2242         /// @dev only owner
2243         /// @param perWallet  new max mint per wallet
2244         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2245           maxMintAmountPerWallet = perWallet;
2246         }  
2247         
2248         /// @dev only owner
2249         /// @param perWallet set free number of nft per wallet
2250         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2251           numberOfFreeNFTs = perWallet;
2252         }            
2253 
2254         // ================================ Withdraw Function ====================
2255 
2256         /// @notice withdraw ether from contract.
2257         /// @dev only owner function
2258         function withdraw() public onlyOwner nonReentrant{
2259           
2260 
2261           
2262 
2263         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2264         require(owner);
2265         }
2266         // =================== Blue Functions (View Only) ====================
2267 
2268         /// @dev return uri of token ID
2269         /// @param tokenId  token ID to find uri for
2270         ///@return value for 'tokenId uri'
2271         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2272           if (!_exists(tokenId)) revert TokenNotExisting();   
2273 
2274         
2275 
2276         string memory currentBaseURI = _baseURI();
2277         return bytes(currentBaseURI).length > 0
2278         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), ExtensionURL))
2279         : '';
2280         }
2281         
2282         /// @dev tokenId to start (1)
2283         function _startTokenId() internal view virtual override returns (uint256) {
2284           return 1;
2285         }
2286 
2287         ///@dev maxSupply of token
2288         /// @return max supply
2289         function _baseURI() internal view virtual override returns (string memory) {
2290           return baseURL;
2291         }
2292 
2293     
2294         /// @dev internal function to 
2295         /// @param from  user address where token belongs
2296         /// @param to  user address
2297         /// @param tokenId  number of tokenId
2298           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2299         super.transferFrom(from, to, tokenId);
2300         }
2301         
2302         /// @dev internal function to 
2303         /// @param from  user address where token belongs
2304         /// @param to  user address
2305         /// @param tokenId  number of tokenId
2306         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2307         super.safeTransferFrom(from, to, tokenId);
2308         }
2309 
2310         /// @dev internal function to 
2311         /// @param from  user address where token belongs
2312         /// @param to  user address
2313         /// @param tokenId  number of tokenId
2314         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2315         public payable
2316         override
2317         onlyAllowedOperator(from)
2318         {
2319         super.safeTransferFrom(from, to, tokenId, data);
2320         }
2321         
2322 
2323 }