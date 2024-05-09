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
11 pragma solidity ^0.8.13;
12 
13 interface IOperatorFilterRegistry {
14     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
15     function register(address registrant) external;
16     function registerAndSubscribe(address registrant, address subscription) external;
17     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
18     function unregister(address addr) external;
19     function updateOperator(address registrant, address operator, bool filtered) external;
20     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
21     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
22     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
23     function subscribe(address registrant, address registrantToSubscribe) external;
24     function unsubscribe(address registrant, bool copyExistingEntries) external;
25     function subscriptionOf(address addr) external returns (address registrant);
26     function subscribers(address registrant) external returns (address[] memory);
27     function subscriberAt(address registrant, uint256 index) external returns (address);
28     function copyEntriesOf(address registrant, address registrantToCopy) external;
29     function isOperatorFiltered(address registrant, address operator) external returns (bool);
30     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
31     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
32     function filteredOperators(address addr) external returns (address[] memory);
33     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
34     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
35     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
36     function isRegistered(address addr) external returns (bool);
37     function codeHashOf(address addr) external returns (bytes32);
38 }
39 
40 // File: operator-filter-registry/src/OperatorFilterer.sol
41 
42 
43 pragma solidity ^0.8.13;
44 
45 
46 /**
47  * @title  OperatorFilterer
48  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
49  *         registrant's entries in the OperatorFilterRegistry.
50  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
51  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
52  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
53  */
54 abstract contract OperatorFilterer {
55     error OperatorNotAllowed(address operator);
56 
57     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
58         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
59 
60     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
61         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
62         // will not revert, but the contract will need to be registered with the registry once it is deployed in
63         // order for the modifier to filter addresses.
64         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
65             if (subscribe) {
66                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
67             } else {
68                 if (subscriptionOrRegistrantToCopy != address(0)) {
69                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
70                 } else {
71                     OPERATOR_FILTER_REGISTRY.register(address(this));
72                 }
73             }
74         }
75     }
76 
77     modifier onlyAllowedOperator(address from) virtual {
78         // Allow spending tokens from addresses with balance
79         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
80         // from an EOA.
81         if (from != msg.sender) {
82             _checkFilterOperator(msg.sender);
83         }
84         _;
85     }
86 
87     modifier onlyAllowedOperatorApproval(address operator) virtual {
88         _checkFilterOperator(operator);
89         _;
90     }
91 
92     function _checkFilterOperator(address operator) internal view virtual {
93         // Check registry code length to facilitate testing in environments without a deployed registry.
94         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
95             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
96                 revert OperatorNotAllowed(operator);
97             }
98         }
99     }
100 }
101 
102 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
103 
104 
105 pragma solidity ^0.8.13;
106 
107 
108 /**
109  * @title  DefaultOperatorFilterer
110  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
111  */
112 abstract contract DefaultOperatorFilterer is OperatorFilterer {
113     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
114 
115     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
116 }
117 
118 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
119 
120 
121 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
122 
123 pragma solidity ^0.8.0;
124 
125 /**
126  * @dev Contract module that helps prevent reentrant calls to a function.
127  *
128  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
129  * available, which can be applied to functions to make sure there are no nested
130  * (reentrant) calls to them.
131  *
132  * Note that because there is a single `nonReentrant` guard, functions marked as
133  * `nonReentrant` may not call one another. This can be worked around by making
134  * those functions `private`, and then adding `external` `nonReentrant` entry
135  * points to them.
136  *
137  * TIP: If you would like to learn more about reentrancy and alternative ways
138  * to protect against it, check out our blog post
139  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
140  */
141 abstract contract ReentrancyGuard {
142     // Booleans are more expensive than uint256 or any type that takes up a full
143     // word because each write operation emits an extra SLOAD to first read the
144     // slot's contents, replace the bits taken up by the boolean, and then write
145     // back. This is the compiler's defense against contract upgrades and
146     // pointer aliasing, and it cannot be disabled.
147 
148     // The values being non-zero value makes deployment a bit more expensive,
149     // but in exchange the refund on every call to nonReentrant will be lower in
150     // amount. Since refunds are capped to a percentage of the total
151     // transaction's gas, it is best to keep them low in cases like this one, to
152     // increase the likelihood of the full refund coming into effect.
153     uint256 private constant _NOT_ENTERED = 1;
154     uint256 private constant _ENTERED = 2;
155 
156     uint256 private _status;
157 
158     constructor() {
159         _status = _NOT_ENTERED;
160     }
161 
162     /**
163      * @dev Prevents a contract from calling itself, directly or indirectly.
164      * Calling a `nonReentrant` function from another `nonReentrant`
165      * function is not supported. It is possible to prevent this from happening
166      * by making the `nonReentrant` function external, and making it call a
167      * `private` function that does the actual work.
168      */
169     modifier nonReentrant() {
170         _nonReentrantBefore();
171         _;
172         _nonReentrantAfter();
173     }
174 
175     function _nonReentrantBefore() private {
176         // On the first call to nonReentrant, _status will be _NOT_ENTERED
177         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
178 
179         // Any calls to nonReentrant after this point will fail
180         _status = _ENTERED;
181     }
182 
183     function _nonReentrantAfter() private {
184         // By storing the original value once again, a refund is triggered (see
185         // https://eips.ethereum.org/EIPS/eip-2200)
186         _status = _NOT_ENTERED;
187     }
188 }
189 
190 // File: @openzeppelin/contracts/utils/math/Math.sol
191 
192 
193 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Standard math utilities missing in the Solidity language.
199  */
200 library Math {
201     enum Rounding {
202         Down, // Toward negative infinity
203         Up, // Toward infinity
204         Zero // Toward zero
205     }
206 
207     /**
208      * @dev Returns the largest of two numbers.
209      */
210     function max(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a > b ? a : b;
212     }
213 
214     /**
215      * @dev Returns the smallest of two numbers.
216      */
217     function min(uint256 a, uint256 b) internal pure returns (uint256) {
218         return a < b ? a : b;
219     }
220 
221     /**
222      * @dev Returns the average of two numbers. The result is rounded towards
223      * zero.
224      */
225     function average(uint256 a, uint256 b) internal pure returns (uint256) {
226         // (a + b) / 2 can overflow.
227         return (a & b) + (a ^ b) / 2;
228     }
229 
230     /**
231      * @dev Returns the ceiling of the division of two numbers.
232      *
233      * This differs from standard division with `/` in that it rounds up instead
234      * of rounding down.
235      */
236     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
237         // (a + b - 1) / b can overflow on addition, so we distribute.
238         return a == 0 ? 0 : (a - 1) / b + 1;
239     }
240 
241     /**
242      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
243      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
244      * with further edits by Uniswap Labs also under MIT license.
245      */
246     function mulDiv(
247         uint256 x,
248         uint256 y,
249         uint256 denominator
250     ) internal pure returns (uint256 result) {
251         unchecked {
252             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
253             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
254             // variables such that product = prod1 * 2^256 + prod0.
255             uint256 prod0; // Least significant 256 bits of the product
256             uint256 prod1; // Most significant 256 bits of the product
257             assembly {
258                 let mm := mulmod(x, y, not(0))
259                 prod0 := mul(x, y)
260                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
261             }
262 
263             // Handle non-overflow cases, 256 by 256 division.
264             if (prod1 == 0) {
265                 return prod0 / denominator;
266             }
267 
268             // Make sure the result is less than 2^256. Also prevents denominator == 0.
269             require(denominator > prod1);
270 
271             ///////////////////////////////////////////////
272             // 512 by 256 division.
273             ///////////////////////////////////////////////
274 
275             // Make division exact by subtracting the remainder from [prod1 prod0].
276             uint256 remainder;
277             assembly {
278                 // Compute remainder using mulmod.
279                 remainder := mulmod(x, y, denominator)
280 
281                 // Subtract 256 bit number from 512 bit number.
282                 prod1 := sub(prod1, gt(remainder, prod0))
283                 prod0 := sub(prod0, remainder)
284             }
285 
286             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
287             // See https://cs.stackexchange.com/q/138556/92363.
288 
289             // Does not overflow because the denominator cannot be zero at this stage in the function.
290             uint256 twos = denominator & (~denominator + 1);
291             assembly {
292                 // Divide denominator by twos.
293                 denominator := div(denominator, twos)
294 
295                 // Divide [prod1 prod0] by twos.
296                 prod0 := div(prod0, twos)
297 
298                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
299                 twos := add(div(sub(0, twos), twos), 1)
300             }
301 
302             // Shift in bits from prod1 into prod0.
303             prod0 |= prod1 * twos;
304 
305             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
306             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
307             // four bits. That is, denominator * inv = 1 mod 2^4.
308             uint256 inverse = (3 * denominator) ^ 2;
309 
310             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
311             // in modular arithmetic, doubling the correct bits in each step.
312             inverse *= 2 - denominator * inverse; // inverse mod 2^8
313             inverse *= 2 - denominator * inverse; // inverse mod 2^16
314             inverse *= 2 - denominator * inverse; // inverse mod 2^32
315             inverse *= 2 - denominator * inverse; // inverse mod 2^64
316             inverse *= 2 - denominator * inverse; // inverse mod 2^128
317             inverse *= 2 - denominator * inverse; // inverse mod 2^256
318 
319             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
320             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
321             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
322             // is no longer required.
323             result = prod0 * inverse;
324             return result;
325         }
326     }
327 
328     /**
329      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
330      */
331     function mulDiv(
332         uint256 x,
333         uint256 y,
334         uint256 denominator,
335         Rounding rounding
336     ) internal pure returns (uint256) {
337         uint256 result = mulDiv(x, y, denominator);
338         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
339             result += 1;
340         }
341         return result;
342     }
343 
344     /**
345      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
346      *
347      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
348      */
349     function sqrt(uint256 a) internal pure returns (uint256) {
350         if (a == 0) {
351             return 0;
352         }
353 
354         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
355         //
356         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
357         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
358         //
359         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
360         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
361         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
362         //
363         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
364         uint256 result = 1 << (log2(a) >> 1);
365 
366         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
367         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
368         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
369         // into the expected uint128 result.
370         unchecked {
371             result = (result + a / result) >> 1;
372             result = (result + a / result) >> 1;
373             result = (result + a / result) >> 1;
374             result = (result + a / result) >> 1;
375             result = (result + a / result) >> 1;
376             result = (result + a / result) >> 1;
377             result = (result + a / result) >> 1;
378             return min(result, a / result);
379         }
380     }
381 
382     /**
383      * @notice Calculates sqrt(a), following the selected rounding direction.
384      */
385     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
386         unchecked {
387             uint256 result = sqrt(a);
388             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
389         }
390     }
391 
392     /**
393      * @dev Return the log in base 2, rounded down, of a positive value.
394      * Returns 0 if given 0.
395      */
396     function log2(uint256 value) internal pure returns (uint256) {
397         uint256 result = 0;
398         unchecked {
399             if (value >> 128 > 0) {
400                 value >>= 128;
401                 result += 128;
402             }
403             if (value >> 64 > 0) {
404                 value >>= 64;
405                 result += 64;
406             }
407             if (value >> 32 > 0) {
408                 value >>= 32;
409                 result += 32;
410             }
411             if (value >> 16 > 0) {
412                 value >>= 16;
413                 result += 16;
414             }
415             if (value >> 8 > 0) {
416                 value >>= 8;
417                 result += 8;
418             }
419             if (value >> 4 > 0) {
420                 value >>= 4;
421                 result += 4;
422             }
423             if (value >> 2 > 0) {
424                 value >>= 2;
425                 result += 2;
426             }
427             if (value >> 1 > 0) {
428                 result += 1;
429             }
430         }
431         return result;
432     }
433 
434     /**
435      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
436      * Returns 0 if given 0.
437      */
438     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
439         unchecked {
440             uint256 result = log2(value);
441             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
442         }
443     }
444 
445     /**
446      * @dev Return the log in base 10, rounded down, of a positive value.
447      * Returns 0 if given 0.
448      */
449     function log10(uint256 value) internal pure returns (uint256) {
450         uint256 result = 0;
451         unchecked {
452             if (value >= 10**64) {
453                 value /= 10**64;
454                 result += 64;
455             }
456             if (value >= 10**32) {
457                 value /= 10**32;
458                 result += 32;
459             }
460             if (value >= 10**16) {
461                 value /= 10**16;
462                 result += 16;
463             }
464             if (value >= 10**8) {
465                 value /= 10**8;
466                 result += 8;
467             }
468             if (value >= 10**4) {
469                 value /= 10**4;
470                 result += 4;
471             }
472             if (value >= 10**2) {
473                 value /= 10**2;
474                 result += 2;
475             }
476             if (value >= 10**1) {
477                 result += 1;
478             }
479         }
480         return result;
481     }
482 
483     /**
484      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
485      * Returns 0 if given 0.
486      */
487     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
488         unchecked {
489             uint256 result = log10(value);
490             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
491         }
492     }
493 
494     /**
495      * @dev Return the log in base 256, rounded down, of a positive value.
496      * Returns 0 if given 0.
497      *
498      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
499      */
500     function log256(uint256 value) internal pure returns (uint256) {
501         uint256 result = 0;
502         unchecked {
503             if (value >> 128 > 0) {
504                 value >>= 128;
505                 result += 16;
506             }
507             if (value >> 64 > 0) {
508                 value >>= 64;
509                 result += 8;
510             }
511             if (value >> 32 > 0) {
512                 value >>= 32;
513                 result += 4;
514             }
515             if (value >> 16 > 0) {
516                 value >>= 16;
517                 result += 2;
518             }
519             if (value >> 8 > 0) {
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
530     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
531         unchecked {
532             uint256 result = log256(value);
533             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
534         }
535     }
536 }
537 
538 // File: @openzeppelin/contracts/utils/Strings.sol
539 
540 
541 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
542 
543 pragma solidity ^0.8.0;
544 
545 
546 /**
547  * @dev String operations.
548  */
549 library Strings {
550     bytes16 private constant _SYMBOLS = "0123456789abcdef";
551     uint8 private constant _ADDRESS_LENGTH = 20;
552 
553     /**
554      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
555      */
556     function toString(uint256 value) internal pure returns (string memory) {
557         unchecked {
558             uint256 length = Math.log10(value) + 1;
559             string memory buffer = new string(length);
560             uint256 ptr;
561             /// @solidity memory-safe-assembly
562             assembly {
563                 ptr := add(buffer, add(32, length))
564             }
565             while (true) {
566                 ptr--;
567                 /// @solidity memory-safe-assembly
568                 assembly {
569                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
570                 }
571                 value /= 10;
572                 if (value == 0) break;
573             }
574             return buffer;
575         }
576     }
577 
578     /**
579      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
580      */
581     function toHexString(uint256 value) internal pure returns (string memory) {
582         unchecked {
583             return toHexString(value, Math.log256(value) + 1);
584         }
585     }
586 
587     /**
588      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
589      */
590     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
591         bytes memory buffer = new bytes(2 * length + 2);
592         buffer[0] = "0";
593         buffer[1] = "x";
594         for (uint256 i = 2 * length + 1; i > 1; --i) {
595             buffer[i] = _SYMBOLS[value & 0xf];
596             value >>= 4;
597         }
598         require(value == 0, "Strings: hex length insufficient");
599         return string(buffer);
600     }
601 
602     /**
603      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
604      */
605     function toHexString(address addr) internal pure returns (string memory) {
606         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
607     }
608 }
609 
610 // File: erc721a/contracts/IERC721A.sol
611 
612 
613 // ERC721A Contracts v4.2.3
614 // Creator: Chiru Labs
615 
616 pragma solidity ^0.8.4;
617 
618 /**
619  * @dev Interface of ERC721A.
620  */
621 interface IERC721A {
622     /**
623      * The caller must own the token or be an approved operator.
624      */
625     error ApprovalCallerNotOwnerNorApproved();
626 
627     /**
628      * The token does not exist.
629      */
630     error ApprovalQueryForNonexistentToken();
631 
632     /**
633      * Cannot query the balance for the zero address.
634      */
635     error BalanceQueryForZeroAddress();
636 
637     /**
638      * Cannot mint to the zero address.
639      */
640     error MintToZeroAddress();
641 
642     /**
643      * The quantity of tokens minted must be more than zero.
644      */
645     error MintZeroQuantity();
646 
647     /**
648      * The token does not exist.
649      */
650     error OwnerQueryForNonexistentToken();
651 
652     /**
653      * The caller must own the token or be an approved operator.
654      */
655     error TransferCallerNotOwnerNorApproved();
656 
657     /**
658      * The token must be owned by `from`.
659      */
660     error TransferFromIncorrectOwner();
661 
662     /**
663      * Cannot safely transfer to a contract that does not implement the
664      * ERC721Receiver interface.
665      */
666     error TransferToNonERC721ReceiverImplementer();
667 
668     /**
669      * Cannot transfer to the zero address.
670      */
671     error TransferToZeroAddress();
672 
673     /**
674      * The token does not exist.
675      */
676     error URIQueryForNonexistentToken();
677 
678     /**
679      * The `quantity` minted with ERC2309 exceeds the safety limit.
680      */
681     error MintERC2309QuantityExceedsLimit();
682 
683     /**
684      * The `extraData` cannot be set on an unintialized ownership slot.
685      */
686     error OwnershipNotInitializedForExtraData();
687 
688     // =============================================================
689     //                            STRUCTS
690     // =============================================================
691 
692     struct TokenOwnership {
693         // The address of the owner.
694         address addr;
695         // Stores the start time of ownership with minimal overhead for tokenomics.
696         uint64 startTimestamp;
697         // Whether the token has been burned.
698         bool burned;
699         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
700         uint24 extraData;
701     }
702 
703     // =============================================================
704     //                         TOKEN COUNTERS
705     // =============================================================
706 
707     /**
708      * @dev Returns the total number of tokens in existence.
709      * Burned tokens will reduce the count.
710      * To get the total number of tokens minted, please see {_totalMinted}.
711      */
712     function totalSupply() external view returns (uint256);
713 
714     // =============================================================
715     //                            IERC165
716     // =============================================================
717 
718     /**
719      * @dev Returns true if this contract implements the interface defined by
720      * `interfaceId`. See the corresponding
721      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
722      * to learn more about how these ids are created.
723      *
724      * This function call must use less than 30000 gas.
725      */
726     function supportsInterface(bytes4 interfaceId) external view returns (bool);
727 
728     // =============================================================
729     //                            IERC721
730     // =============================================================
731 
732     /**
733      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
734      */
735     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
736 
737     /**
738      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
739      */
740     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
741 
742     /**
743      * @dev Emitted when `owner` enables or disables
744      * (`approved`) `operator` to manage all of its assets.
745      */
746     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
747 
748     /**
749      * @dev Returns the number of tokens in `owner`'s account.
750      */
751     function balanceOf(address owner) external view returns (uint256 balance);
752 
753     /**
754      * @dev Returns the owner of the `tokenId` token.
755      *
756      * Requirements:
757      *
758      * - `tokenId` must exist.
759      */
760     function ownerOf(uint256 tokenId) external view returns (address owner);
761 
762     /**
763      * @dev Safely transfers `tokenId` token from `from` to `to`,
764      * checking first that contract recipients are aware of the ERC721 protocol
765      * to prevent tokens from being forever locked.
766      *
767      * Requirements:
768      *
769      * - `from` cannot be the zero address.
770      * - `to` cannot be the zero address.
771      * - `tokenId` token must exist and be owned by `from`.
772      * - If the caller is not `from`, it must be have been allowed to move
773      * this token by either {approve} or {setApprovalForAll}.
774      * - If `to` refers to a smart contract, it must implement
775      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
776      *
777      * Emits a {Transfer} event.
778      */
779     function safeTransferFrom(
780         address from,
781         address to,
782         uint256 tokenId,
783         bytes calldata data
784     ) external payable;
785 
786     /**
787      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
788      */
789     function safeTransferFrom(
790         address from,
791         address to,
792         uint256 tokenId
793     ) external payable;
794 
795     /**
796      * @dev Transfers `tokenId` from `from` to `to`.
797      *
798      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
799      * whenever possible.
800      *
801      * Requirements:
802      *
803      * - `from` cannot be the zero address.
804      * - `to` cannot be the zero address.
805      * - `tokenId` token must be owned by `from`.
806      * - If the caller is not `from`, it must be approved to move this token
807      * by either {approve} or {setApprovalForAll}.
808      *
809      * Emits a {Transfer} event.
810      */
811     function transferFrom(
812         address from,
813         address to,
814         uint256 tokenId
815     ) external payable;
816 
817     /**
818      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
819      * The approval is cleared when the token is transferred.
820      *
821      * Only a single account can be approved at a time, so approving the
822      * zero address clears previous approvals.
823      *
824      * Requirements:
825      *
826      * - The caller must own the token or be an approved operator.
827      * - `tokenId` must exist.
828      *
829      * Emits an {Approval} event.
830      */
831     function approve(address to, uint256 tokenId) external payable;
832 
833     /**
834      * @dev Approve or remove `operator` as an operator for the caller.
835      * Operators can call {transferFrom} or {safeTransferFrom}
836      * for any token owned by the caller.
837      *
838      * Requirements:
839      *
840      * - The `operator` cannot be the caller.
841      *
842      * Emits an {ApprovalForAll} event.
843      */
844     function setApprovalForAll(address operator, bool _approved) external;
845 
846     /**
847      * @dev Returns the account approved for `tokenId` token.
848      *
849      * Requirements:
850      *
851      * - `tokenId` must exist.
852      */
853     function getApproved(uint256 tokenId) external view returns (address operator);
854 
855     /**
856      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
857      *
858      * See {setApprovalForAll}.
859      */
860     function isApprovedForAll(address owner, address operator) external view returns (bool);
861 
862     // =============================================================
863     //                        IERC721Metadata
864     // =============================================================
865 
866     /**
867      * @dev Returns the token collection name.
868      */
869     function name() external view returns (string memory);
870 
871     /**
872      * @dev Returns the token collection symbol.
873      */
874     function symbol() external view returns (string memory);
875 
876     /**
877      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
878      */
879     function tokenURI(uint256 tokenId) external view returns (string memory);
880 
881     // =============================================================
882     //                           IERC2309
883     // =============================================================
884 
885     /**
886      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
887      * (inclusive) is transferred from `from` to `to`, as defined in the
888      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
889      *
890      * See {_mintERC2309} for more details.
891      */
892     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
893 }
894 
895 // File: erc721a/contracts/ERC721A.sol
896 
897 
898 // ERC721A Contracts v4.2.3
899 // Creator: Chiru Labs
900 
901 pragma solidity ^0.8.4;
902 
903 
904 /**
905  * @dev Interface of ERC721 token receiver.
906  */
907 interface ERC721A__IERC721Receiver {
908     function onERC721Received(
909         address operator,
910         address from,
911         uint256 tokenId,
912         bytes calldata data
913     ) external returns (bytes4);
914 }
915 
916 /**
917  * @title ERC721A
918  *
919  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
920  * Non-Fungible Token Standard, including the Metadata extension.
921  * Optimized for lower gas during batch mints.
922  *
923  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
924  * starting from `_startTokenId()`.
925  *
926  * Assumptions:
927  *
928  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
929  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
930  */
931 contract ERC721A is IERC721A {
932     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
933     struct TokenApprovalRef {
934         address value;
935     }
936 
937     // =============================================================
938     //                           CONSTANTS
939     // =============================================================
940 
941     // Mask of an entry in packed address data.
942     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
943 
944     // The bit position of `numberMinted` in packed address data.
945     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
946 
947     // The bit position of `numberBurned` in packed address data.
948     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
949 
950     // The bit position of `aux` in packed address data.
951     uint256 private constant _BITPOS_AUX = 192;
952 
953     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
954     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
955 
956     // The bit position of `startTimestamp` in packed ownership.
957     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
958 
959     // The bit mask of the `burned` bit in packed ownership.
960     uint256 private constant _BITMASK_BURNED = 1 << 224;
961 
962     // The bit position of the `nextInitialized` bit in packed ownership.
963     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
964 
965     // The bit mask of the `nextInitialized` bit in packed ownership.
966     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
967 
968     // The bit position of `extraData` in packed ownership.
969     uint256 private constant _BITPOS_EXTRA_DATA = 232;
970 
971     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
972     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
973 
974     // The mask of the lower 160 bits for addresses.
975     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
976 
977     // The maximum `quantity` that can be minted with {_mintERC2309}.
978     // This limit is to prevent overflows on the address data entries.
979     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
980     // is required to cause an overflow, which is unrealistic.
981     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
982 
983     // The `Transfer` event signature is given by:
984     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
985     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
986         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
987 
988     // =============================================================
989     //                            STORAGE
990     // =============================================================
991 
992     // The next token ID to be minted.
993     uint256 private _currentIndex;
994 
995     // The number of tokens burned.
996     uint256 private _burnCounter;
997 
998     // Token name
999     string private _name;
1000 
1001     // Token symbol
1002     string private _symbol;
1003 
1004     // Mapping from token ID to ownership details
1005     // An empty struct value does not necessarily mean the token is unowned.
1006     // See {_packedOwnershipOf} implementation for details.
1007     //
1008     // Bits Layout:
1009     // - [0..159]   `addr`
1010     // - [160..223] `startTimestamp`
1011     // - [224]      `burned`
1012     // - [225]      `nextInitialized`
1013     // - [232..255] `extraData`
1014     mapping(uint256 => uint256) private _packedOwnerships;
1015 
1016     // Mapping owner address to address data.
1017     //
1018     // Bits Layout:
1019     // - [0..63]    `balance`
1020     // - [64..127]  `numberMinted`
1021     // - [128..191] `numberBurned`
1022     // - [192..255] `aux`
1023     mapping(address => uint256) private _packedAddressData;
1024 
1025     // Mapping from token ID to approved address.
1026     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1027 
1028     // Mapping from owner to operator approvals
1029     mapping(address => mapping(address => bool)) private _operatorApprovals;
1030 
1031     // =============================================================
1032     //                          CONSTRUCTOR
1033     // =============================================================
1034 
1035     constructor(string memory name_, string memory symbol_) {
1036         _name = name_;
1037         _symbol = symbol_;
1038         _currentIndex = _startTokenId();
1039     }
1040 
1041     // =============================================================
1042     //                   TOKEN COUNTING OPERATIONS
1043     // =============================================================
1044 
1045     /**
1046      * @dev Returns the starting token ID.
1047      * To change the starting token ID, please override this function.
1048      */
1049     function _startTokenId() internal view virtual returns (uint256) {
1050         return 0;
1051     }
1052 
1053     /**
1054      * @dev Returns the next token ID to be minted.
1055      */
1056     function _nextTokenId() internal view virtual returns (uint256) {
1057         return _currentIndex;
1058     }
1059 
1060     /**
1061      * @dev Returns the total number of tokens in existence.
1062      * Burned tokens will reduce the count.
1063      * To get the total number of tokens minted, please see {_totalMinted}.
1064      */
1065     function totalSupply() public view virtual override returns (uint256) {
1066         // Counter underflow is impossible as _burnCounter cannot be incremented
1067         // more than `_currentIndex - _startTokenId()` times.
1068         unchecked {
1069             return _currentIndex - _burnCounter - _startTokenId();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns the total amount of tokens minted in the contract.
1075      */
1076     function _totalMinted() internal view virtual returns (uint256) {
1077         // Counter underflow is impossible as `_currentIndex` does not decrement,
1078         // and it is initialized to `_startTokenId()`.
1079         unchecked {
1080             return _currentIndex - _startTokenId();
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the total number of tokens burned.
1086      */
1087     function _totalBurned() internal view virtual returns (uint256) {
1088         return _burnCounter;
1089     }
1090 
1091     // =============================================================
1092     //                    ADDRESS DATA OPERATIONS
1093     // =============================================================
1094 
1095     /**
1096      * @dev Returns the number of tokens in `owner`'s account.
1097      */
1098     function balanceOf(address owner) public view virtual override returns (uint256) {
1099         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1100         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1101     }
1102 
1103     /**
1104      * Returns the number of tokens minted by `owner`.
1105      */
1106     function _numberMinted(address owner) internal view returns (uint256) {
1107         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1108     }
1109 
1110     /**
1111      * Returns the number of tokens burned by or on behalf of `owner`.
1112      */
1113     function _numberBurned(address owner) internal view returns (uint256) {
1114         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1115     }
1116 
1117     /**
1118      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1119      */
1120     function _getAux(address owner) internal view returns (uint64) {
1121         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1122     }
1123 
1124     /**
1125      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1126      * If there are multiple variables, please pack them into a uint64.
1127      */
1128     function _setAux(address owner, uint64 aux) internal virtual {
1129         uint256 packed = _packedAddressData[owner];
1130         uint256 auxCasted;
1131         // Cast `aux` with assembly to avoid redundant masking.
1132         assembly {
1133             auxCasted := aux
1134         }
1135         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1136         _packedAddressData[owner] = packed;
1137     }
1138 
1139     // =============================================================
1140     //                            IERC165
1141     // =============================================================
1142 
1143     /**
1144      * @dev Returns true if this contract implements the interface defined by
1145      * `interfaceId`. See the corresponding
1146      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1147      * to learn more about how these ids are created.
1148      *
1149      * This function call must use less than 30000 gas.
1150      */
1151     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1152         // The interface IDs are constants representing the first 4 bytes
1153         // of the XOR of all function selectors in the interface.
1154         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1155         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1156         return
1157             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1158             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1159             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1160     }
1161 
1162     // =============================================================
1163     //                        IERC721Metadata
1164     // =============================================================
1165 
1166     /**
1167      * @dev Returns the token collection name.
1168      */
1169     function name() public view virtual override returns (string memory) {
1170         return _name;
1171     }
1172 
1173     /**
1174      * @dev Returns the token collection symbol.
1175      */
1176     function symbol() public view virtual override returns (string memory) {
1177         return _symbol;
1178     }
1179 
1180     /**
1181      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1182      */
1183     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1184         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1185 
1186         string memory baseURI = _baseURI();
1187         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1188     }
1189 
1190     /**
1191      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1192      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1193      * by default, it can be overridden in child contracts.
1194      */
1195     function _baseURI() internal view virtual returns (string memory) {
1196         return '';
1197     }
1198 
1199     // =============================================================
1200     //                     OWNERSHIPS OPERATIONS
1201     // =============================================================
1202 
1203     /**
1204      * @dev Returns the owner of the `tokenId` token.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      */
1210     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1211         return address(uint160(_packedOwnershipOf(tokenId)));
1212     }
1213 
1214     /**
1215      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1216      * It gradually moves to O(1) as tokens get transferred around over time.
1217      */
1218     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1219         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1220     }
1221 
1222     /**
1223      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1224      */
1225     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1226         return _unpackedOwnership(_packedOwnerships[index]);
1227     }
1228 
1229     /**
1230      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1231      */
1232     function _initializeOwnershipAt(uint256 index) internal virtual {
1233         if (_packedOwnerships[index] == 0) {
1234             _packedOwnerships[index] = _packedOwnershipOf(index);
1235         }
1236     }
1237 
1238     /**
1239      * Returns the packed ownership data of `tokenId`.
1240      */
1241     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1242         uint256 curr = tokenId;
1243 
1244         unchecked {
1245             if (_startTokenId() <= curr)
1246                 if (curr < _currentIndex) {
1247                     uint256 packed = _packedOwnerships[curr];
1248                     // If not burned.
1249                     if (packed & _BITMASK_BURNED == 0) {
1250                         // Invariant:
1251                         // There will always be an initialized ownership slot
1252                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1253                         // before an unintialized ownership slot
1254                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1255                         // Hence, `curr` will not underflow.
1256                         //
1257                         // We can directly compare the packed value.
1258                         // If the address is zero, packed will be zero.
1259                         while (packed == 0) {
1260                             packed = _packedOwnerships[--curr];
1261                         }
1262                         return packed;
1263                     }
1264                 }
1265         }
1266         revert OwnerQueryForNonexistentToken();
1267     }
1268 
1269     /**
1270      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1271      */
1272     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1273         ownership.addr = address(uint160(packed));
1274         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1275         ownership.burned = packed & _BITMASK_BURNED != 0;
1276         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1277     }
1278 
1279     /**
1280      * @dev Packs ownership data into a single uint256.
1281      */
1282     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1283         assembly {
1284             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1285             owner := and(owner, _BITMASK_ADDRESS)
1286             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1287             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1288         }
1289     }
1290 
1291     /**
1292      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1293      */
1294     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1295         // For branchless setting of the `nextInitialized` flag.
1296         assembly {
1297             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1298             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1299         }
1300     }
1301 
1302     // =============================================================
1303     //                      APPROVAL OPERATIONS
1304     // =============================================================
1305 
1306     /**
1307      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1308      * The approval is cleared when the token is transferred.
1309      *
1310      * Only a single account can be approved at a time, so approving the
1311      * zero address clears previous approvals.
1312      *
1313      * Requirements:
1314      *
1315      * - The caller must own the token or be an approved operator.
1316      * - `tokenId` must exist.
1317      *
1318      * Emits an {Approval} event.
1319      */
1320     function approve(address to, uint256 tokenId) public payable virtual override {
1321         address owner = ownerOf(tokenId);
1322 
1323         if (_msgSenderERC721A() != owner)
1324             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1325                 revert ApprovalCallerNotOwnerNorApproved();
1326             }
1327 
1328         _tokenApprovals[tokenId].value = to;
1329         emit Approval(owner, to, tokenId);
1330     }
1331 
1332     /**
1333      * @dev Returns the account approved for `tokenId` token.
1334      *
1335      * Requirements:
1336      *
1337      * - `tokenId` must exist.
1338      */
1339     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1340         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1341 
1342         return _tokenApprovals[tokenId].value;
1343     }
1344 
1345     /**
1346      * @dev Approve or remove `operator` as an operator for the caller.
1347      * Operators can call {transferFrom} or {safeTransferFrom}
1348      * for any token owned by the caller.
1349      *
1350      * Requirements:
1351      *
1352      * - The `operator` cannot be the caller.
1353      *
1354      * Emits an {ApprovalForAll} event.
1355      */
1356     function setApprovalForAll(address operator, bool approved) public virtual override {
1357         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1358         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1359     }
1360 
1361     /**
1362      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1363      *
1364      * See {setApprovalForAll}.
1365      */
1366     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1367         return _operatorApprovals[owner][operator];
1368     }
1369 
1370     /**
1371      * @dev Returns whether `tokenId` exists.
1372      *
1373      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1374      *
1375      * Tokens start existing when they are minted. See {_mint}.
1376      */
1377     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1378         return
1379             _startTokenId() <= tokenId &&
1380             tokenId < _currentIndex && // If within bounds,
1381             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1382     }
1383 
1384     /**
1385      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1386      */
1387     function _isSenderApprovedOrOwner(
1388         address approvedAddress,
1389         address owner,
1390         address msgSender
1391     ) private pure returns (bool result) {
1392         assembly {
1393             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1394             owner := and(owner, _BITMASK_ADDRESS)
1395             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1396             msgSender := and(msgSender, _BITMASK_ADDRESS)
1397             // `msgSender == owner || msgSender == approvedAddress`.
1398             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1399         }
1400     }
1401 
1402     /**
1403      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1404      */
1405     function _getApprovedSlotAndAddress(uint256 tokenId)
1406         private
1407         view
1408         returns (uint256 approvedAddressSlot, address approvedAddress)
1409     {
1410         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1411         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1412         assembly {
1413             approvedAddressSlot := tokenApproval.slot
1414             approvedAddress := sload(approvedAddressSlot)
1415         }
1416     }
1417 
1418     // =============================================================
1419     //                      TRANSFER OPERATIONS
1420     // =============================================================
1421 
1422     /**
1423      * @dev Transfers `tokenId` from `from` to `to`.
1424      *
1425      * Requirements:
1426      *
1427      * - `from` cannot be the zero address.
1428      * - `to` cannot be the zero address.
1429      * - `tokenId` token must be owned by `from`.
1430      * - If the caller is not `from`, it must be approved to move this token
1431      * by either {approve} or {setApprovalForAll}.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function transferFrom(
1436         address from,
1437         address to,
1438         uint256 tokenId
1439     ) public payable virtual override {
1440         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1441 
1442         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1443 
1444         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1445 
1446         // The nested ifs save around 20+ gas over a compound boolean condition.
1447         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1448             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1449 
1450         if (to == address(0)) revert TransferToZeroAddress();
1451 
1452         _beforeTokenTransfers(from, to, tokenId, 1);
1453 
1454         // Clear approvals from the previous owner.
1455         assembly {
1456             if approvedAddress {
1457                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1458                 sstore(approvedAddressSlot, 0)
1459             }
1460         }
1461 
1462         // Underflow of the sender's balance is impossible because we check for
1463         // ownership above and the recipient's balance can't realistically overflow.
1464         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1465         unchecked {
1466             // We can directly increment and decrement the balances.
1467             --_packedAddressData[from]; // Updates: `balance -= 1`.
1468             ++_packedAddressData[to]; // Updates: `balance += 1`.
1469 
1470             // Updates:
1471             // - `address` to the next owner.
1472             // - `startTimestamp` to the timestamp of transfering.
1473             // - `burned` to `false`.
1474             // - `nextInitialized` to `true`.
1475             _packedOwnerships[tokenId] = _packOwnershipData(
1476                 to,
1477                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1478             );
1479 
1480             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1481             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1482                 uint256 nextTokenId = tokenId + 1;
1483                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1484                 if (_packedOwnerships[nextTokenId] == 0) {
1485                     // If the next slot is within bounds.
1486                     if (nextTokenId != _currentIndex) {
1487                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1488                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1489                     }
1490                 }
1491             }
1492         }
1493 
1494         emit Transfer(from, to, tokenId);
1495         _afterTokenTransfers(from, to, tokenId, 1);
1496     }
1497 
1498     /**
1499      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1500      */
1501     function safeTransferFrom(
1502         address from,
1503         address to,
1504         uint256 tokenId
1505     ) public payable virtual override {
1506         safeTransferFrom(from, to, tokenId, '');
1507     }
1508 
1509     /**
1510      * @dev Safely transfers `tokenId` token from `from` to `to`.
1511      *
1512      * Requirements:
1513      *
1514      * - `from` cannot be the zero address.
1515      * - `to` cannot be the zero address.
1516      * - `tokenId` token must exist and be owned by `from`.
1517      * - If the caller is not `from`, it must be approved to move this token
1518      * by either {approve} or {setApprovalForAll}.
1519      * - If `to` refers to a smart contract, it must implement
1520      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1521      *
1522      * Emits a {Transfer} event.
1523      */
1524     function safeTransferFrom(
1525         address from,
1526         address to,
1527         uint256 tokenId,
1528         bytes memory _data
1529     ) public payable virtual override {
1530         transferFrom(from, to, tokenId);
1531         if (to.code.length != 0)
1532             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1533                 revert TransferToNonERC721ReceiverImplementer();
1534             }
1535     }
1536 
1537     /**
1538      * @dev Hook that is called before a set of serially-ordered token IDs
1539      * are about to be transferred. This includes minting.
1540      * And also called before burning one token.
1541      *
1542      * `startTokenId` - the first token ID to be transferred.
1543      * `quantity` - the amount to be transferred.
1544      *
1545      * Calling conditions:
1546      *
1547      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1548      * transferred to `to`.
1549      * - When `from` is zero, `tokenId` will be minted for `to`.
1550      * - When `to` is zero, `tokenId` will be burned by `from`.
1551      * - `from` and `to` are never both zero.
1552      */
1553     function _beforeTokenTransfers(
1554         address from,
1555         address to,
1556         uint256 startTokenId,
1557         uint256 quantity
1558     ) internal virtual {}
1559 
1560     /**
1561      * @dev Hook that is called after a set of serially-ordered token IDs
1562      * have been transferred. This includes minting.
1563      * And also called after one token has been burned.
1564      *
1565      * `startTokenId` - the first token ID to be transferred.
1566      * `quantity` - the amount to be transferred.
1567      *
1568      * Calling conditions:
1569      *
1570      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1571      * transferred to `to`.
1572      * - When `from` is zero, `tokenId` has been minted for `to`.
1573      * - When `to` is zero, `tokenId` has been burned by `from`.
1574      * - `from` and `to` are never both zero.
1575      */
1576     function _afterTokenTransfers(
1577         address from,
1578         address to,
1579         uint256 startTokenId,
1580         uint256 quantity
1581     ) internal virtual {}
1582 
1583     /**
1584      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1585      *
1586      * `from` - Previous owner of the given token ID.
1587      * `to` - Target address that will receive the token.
1588      * `tokenId` - Token ID to be transferred.
1589      * `_data` - Optional data to send along with the call.
1590      *
1591      * Returns whether the call correctly returned the expected magic value.
1592      */
1593     function _checkContractOnERC721Received(
1594         address from,
1595         address to,
1596         uint256 tokenId,
1597         bytes memory _data
1598     ) private returns (bool) {
1599         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1600             bytes4 retval
1601         ) {
1602             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1603         } catch (bytes memory reason) {
1604             if (reason.length == 0) {
1605                 revert TransferToNonERC721ReceiverImplementer();
1606             } else {
1607                 assembly {
1608                     revert(add(32, reason), mload(reason))
1609                 }
1610             }
1611         }
1612     }
1613 
1614     // =============================================================
1615     //                        MINT OPERATIONS
1616     // =============================================================
1617 
1618     /**
1619      * @dev Mints `quantity` tokens and transfers them to `to`.
1620      *
1621      * Requirements:
1622      *
1623      * - `to` cannot be the zero address.
1624      * - `quantity` must be greater than 0.
1625      *
1626      * Emits a {Transfer} event for each mint.
1627      */
1628     function _mint(address to, uint256 quantity) internal virtual {
1629         uint256 startTokenId = _currentIndex;
1630         if (quantity == 0) revert MintZeroQuantity();
1631 
1632         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1633 
1634         // Overflows are incredibly unrealistic.
1635         // `balance` and `numberMinted` have a maximum limit of 2**64.
1636         // `tokenId` has a maximum limit of 2**256.
1637         unchecked {
1638             // Updates:
1639             // - `balance += quantity`.
1640             // - `numberMinted += quantity`.
1641             //
1642             // We can directly add to the `balance` and `numberMinted`.
1643             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1644 
1645             // Updates:
1646             // - `address` to the owner.
1647             // - `startTimestamp` to the timestamp of minting.
1648             // - `burned` to `false`.
1649             // - `nextInitialized` to `quantity == 1`.
1650             _packedOwnerships[startTokenId] = _packOwnershipData(
1651                 to,
1652                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1653             );
1654 
1655             uint256 toMasked;
1656             uint256 end = startTokenId + quantity;
1657 
1658             // Use assembly to loop and emit the `Transfer` event for gas savings.
1659             // The duplicated `log4` removes an extra check and reduces stack juggling.
1660             // The assembly, together with the surrounding Solidity code, have been
1661             // delicately arranged to nudge the compiler into producing optimized opcodes.
1662             assembly {
1663                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1664                 toMasked := and(to, _BITMASK_ADDRESS)
1665                 // Emit the `Transfer` event.
1666                 log4(
1667                     0, // Start of data (0, since no data).
1668                     0, // End of data (0, since no data).
1669                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1670                     0, // `address(0)`.
1671                     toMasked, // `to`.
1672                     startTokenId // `tokenId`.
1673                 )
1674 
1675                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1676                 // that overflows uint256 will make the loop run out of gas.
1677                 // The compiler will optimize the `iszero` away for performance.
1678                 for {
1679                     let tokenId := add(startTokenId, 1)
1680                 } iszero(eq(tokenId, end)) {
1681                     tokenId := add(tokenId, 1)
1682                 } {
1683                     // Emit the `Transfer` event. Similar to above.
1684                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1685                 }
1686             }
1687             if (toMasked == 0) revert MintToZeroAddress();
1688 
1689             _currentIndex = end;
1690         }
1691         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1692     }
1693 
1694     /**
1695      * @dev Mints `quantity` tokens and transfers them to `to`.
1696      *
1697      * This function is intended for efficient minting only during contract creation.
1698      *
1699      * It emits only one {ConsecutiveTransfer} as defined in
1700      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1701      * instead of a sequence of {Transfer} event(s).
1702      *
1703      * Calling this function outside of contract creation WILL make your contract
1704      * non-compliant with the ERC721 standard.
1705      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1706      * {ConsecutiveTransfer} event is only permissible during contract creation.
1707      *
1708      * Requirements:
1709      *
1710      * - `to` cannot be the zero address.
1711      * - `quantity` must be greater than 0.
1712      *
1713      * Emits a {ConsecutiveTransfer} event.
1714      */
1715     function _mintERC2309(address to, uint256 quantity) internal virtual {
1716         uint256 startTokenId = _currentIndex;
1717         if (to == address(0)) revert MintToZeroAddress();
1718         if (quantity == 0) revert MintZeroQuantity();
1719         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1720 
1721         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1722 
1723         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1724         unchecked {
1725             // Updates:
1726             // - `balance += quantity`.
1727             // - `numberMinted += quantity`.
1728             //
1729             // We can directly add to the `balance` and `numberMinted`.
1730             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1731 
1732             // Updates:
1733             // - `address` to the owner.
1734             // - `startTimestamp` to the timestamp of minting.
1735             // - `burned` to `false`.
1736             // - `nextInitialized` to `quantity == 1`.
1737             _packedOwnerships[startTokenId] = _packOwnershipData(
1738                 to,
1739                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1740             );
1741 
1742             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1743 
1744             _currentIndex = startTokenId + quantity;
1745         }
1746         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1747     }
1748 
1749     /**
1750      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1751      *
1752      * Requirements:
1753      *
1754      * - If `to` refers to a smart contract, it must implement
1755      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1756      * - `quantity` must be greater than 0.
1757      *
1758      * See {_mint}.
1759      *
1760      * Emits a {Transfer} event for each mint.
1761      */
1762     function _safeMint(
1763         address to,
1764         uint256 quantity,
1765         bytes memory _data
1766     ) internal virtual {
1767         _mint(to, quantity);
1768 
1769         unchecked {
1770             if (to.code.length != 0) {
1771                 uint256 end = _currentIndex;
1772                 uint256 index = end - quantity;
1773                 do {
1774                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1775                         revert TransferToNonERC721ReceiverImplementer();
1776                     }
1777                 } while (index < end);
1778                 // Reentrancy protection.
1779                 if (_currentIndex != end) revert();
1780             }
1781         }
1782     }
1783 
1784     /**
1785      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1786      */
1787     function _safeMint(address to, uint256 quantity) internal virtual {
1788         _safeMint(to, quantity, '');
1789     }
1790 
1791     // =============================================================
1792     //                        BURN OPERATIONS
1793     // =============================================================
1794 
1795     /**
1796      * @dev Equivalent to `_burn(tokenId, false)`.
1797      */
1798     function _burn(uint256 tokenId) internal virtual {
1799         _burn(tokenId, false);
1800     }
1801 
1802     /**
1803      * @dev Destroys `tokenId`.
1804      * The approval is cleared when the token is burned.
1805      *
1806      * Requirements:
1807      *
1808      * - `tokenId` must exist.
1809      *
1810      * Emits a {Transfer} event.
1811      */
1812     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1813         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1814 
1815         address from = address(uint160(prevOwnershipPacked));
1816 
1817         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1818 
1819         if (approvalCheck) {
1820             // The nested ifs save around 20+ gas over a compound boolean condition.
1821             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1822                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1823         }
1824 
1825         _beforeTokenTransfers(from, address(0), tokenId, 1);
1826 
1827         // Clear approvals from the previous owner.
1828         assembly {
1829             if approvedAddress {
1830                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1831                 sstore(approvedAddressSlot, 0)
1832             }
1833         }
1834 
1835         // Underflow of the sender's balance is impossible because we check for
1836         // ownership above and the recipient's balance can't realistically overflow.
1837         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1838         unchecked {
1839             // Updates:
1840             // - `balance -= 1`.
1841             // - `numberBurned += 1`.
1842             //
1843             // We can directly decrement the balance, and increment the number burned.
1844             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1845             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1846 
1847             // Updates:
1848             // - `address` to the last owner.
1849             // - `startTimestamp` to the timestamp of burning.
1850             // - `burned` to `true`.
1851             // - `nextInitialized` to `true`.
1852             _packedOwnerships[tokenId] = _packOwnershipData(
1853                 from,
1854                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1855             );
1856 
1857             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1858             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1859                 uint256 nextTokenId = tokenId + 1;
1860                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1861                 if (_packedOwnerships[nextTokenId] == 0) {
1862                     // If the next slot is within bounds.
1863                     if (nextTokenId != _currentIndex) {
1864                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1865                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1866                     }
1867                 }
1868             }
1869         }
1870 
1871         emit Transfer(from, address(0), tokenId);
1872         _afterTokenTransfers(from, address(0), tokenId, 1);
1873 
1874         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1875         unchecked {
1876             _burnCounter++;
1877         }
1878     }
1879 
1880     // =============================================================
1881     //                     EXTRA DATA OPERATIONS
1882     // =============================================================
1883 
1884     /**
1885      * @dev Directly sets the extra data for the ownership data `index`.
1886      */
1887     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1888         uint256 packed = _packedOwnerships[index];
1889         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1890         uint256 extraDataCasted;
1891         // Cast `extraData` with assembly to avoid redundant masking.
1892         assembly {
1893             extraDataCasted := extraData
1894         }
1895         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1896         _packedOwnerships[index] = packed;
1897     }
1898 
1899     /**
1900      * @dev Called during each token transfer to set the 24bit `extraData` field.
1901      * Intended to be overridden by the cosumer contract.
1902      *
1903      * `previousExtraData` - the value of `extraData` before transfer.
1904      *
1905      * Calling conditions:
1906      *
1907      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1908      * transferred to `to`.
1909      * - When `from` is zero, `tokenId` will be minted for `to`.
1910      * - When `to` is zero, `tokenId` will be burned by `from`.
1911      * - `from` and `to` are never both zero.
1912      */
1913     function _extraData(
1914         address from,
1915         address to,
1916         uint24 previousExtraData
1917     ) internal view virtual returns (uint24) {}
1918 
1919     /**
1920      * @dev Returns the next extra data for the packed ownership data.
1921      * The returned result is shifted into position.
1922      */
1923     function _nextExtraData(
1924         address from,
1925         address to,
1926         uint256 prevOwnershipPacked
1927     ) private view returns (uint256) {
1928         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1929         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1930     }
1931 
1932     // =============================================================
1933     //                       OTHER OPERATIONS
1934     // =============================================================
1935 
1936     /**
1937      * @dev Returns the message sender (defaults to `msg.sender`).
1938      *
1939      * If you are writing GSN compatible contracts, you need to override this function.
1940      */
1941     function _msgSenderERC721A() internal view virtual returns (address) {
1942         return msg.sender;
1943     }
1944 
1945     /**
1946      * @dev Converts a uint256 to its ASCII string decimal representation.
1947      */
1948     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1949         assembly {
1950             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1951             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1952             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1953             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1954             let m := add(mload(0x40), 0xa0)
1955             // Update the free memory pointer to allocate.
1956             mstore(0x40, m)
1957             // Assign the `str` to the end.
1958             str := sub(m, 0x20)
1959             // Zeroize the slot after the string.
1960             mstore(str, 0)
1961 
1962             // Cache the end of the memory to calculate the length later.
1963             let end := str
1964 
1965             // We write the string from rightmost digit to leftmost digit.
1966             // The following is essentially a do-while loop that also handles the zero case.
1967             // prettier-ignore
1968             for { let temp := value } 1 {} {
1969                 str := sub(str, 1)
1970                 // Write the character to the pointer.
1971                 // The ASCII index of the '0' character is 48.
1972                 mstore8(str, add(48, mod(temp, 10)))
1973                 // Keep dividing `temp` until zero.
1974                 temp := div(temp, 10)
1975                 // prettier-ignore
1976                 if iszero(temp) { break }
1977             }
1978 
1979             let length := sub(end, str)
1980             // Move the pointer 32 bytes leftwards to make room for the length.
1981             str := sub(str, 0x20)
1982             // Store the length.
1983             mstore(str, length)
1984         }
1985     }
1986 }
1987 
1988 // File: @openzeppelin/contracts/utils/Context.sol
1989 
1990 
1991 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1992 
1993 pragma solidity ^0.8.0;
1994 
1995 /**
1996  * @dev Provides information about the current execution context, including the
1997  * sender of the transaction and its data. While these are generally available
1998  * via msg.sender and msg.data, they should not be accessed in such a direct
1999  * manner, since when dealing with meta-transactions the account sending and
2000  * paying for execution may not be the actual sender (as far as an application
2001  * is concerned).
2002  *
2003  * This contract is only required for intermediate, library-like contracts.
2004  */
2005 abstract contract Context {
2006     function _msgSender() internal view virtual returns (address) {
2007         return msg.sender;
2008     }
2009 
2010     function _msgData() internal view virtual returns (bytes calldata) {
2011         return msg.data;
2012     }
2013 }
2014 
2015 // File: @openzeppelin/contracts/access/Ownable.sol
2016 
2017 
2018 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2019 
2020 pragma solidity ^0.8.0;
2021 
2022 
2023 /**
2024  * @dev Contract module which provides a basic access control mechanism, where
2025  * there is an account (an owner) that can be granted exclusive access to
2026  * specific functions.
2027  *
2028  * By default, the owner account will be the one that deploys the contract. This
2029  * can later be changed with {transferOwnership}.
2030  *
2031  * This module is used through inheritance. It will make available the modifier
2032  * `onlyOwner`, which can be applied to your functions to restrict their use to
2033  * the owner.
2034  */
2035 abstract contract Ownable is Context {
2036     address private _owner;
2037 
2038     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2039 
2040     /**
2041      * @dev Initializes the contract setting the deployer as the initial owner.
2042      */
2043     constructor() {
2044         _transferOwnership(_msgSender());
2045     }
2046 
2047     /**
2048      * @dev Throws if called by any account other than the owner.
2049      */
2050     modifier onlyOwner() {
2051         _checkOwner();
2052         _;
2053     }
2054 
2055     /**
2056      * @dev Returns the address of the current owner.
2057      */
2058     function owner() public view virtual returns (address) {
2059         return _owner;
2060     }
2061 
2062     /**
2063      * @dev Throws if the sender is not the owner.
2064      */
2065     function _checkOwner() internal view virtual {
2066         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2067     }
2068 
2069     /**
2070      * @dev Leaves the contract without owner. It will not be possible to call
2071      * `onlyOwner` functions anymore. Can only be called by the current owner.
2072      *
2073      * NOTE: Renouncing ownership will leave the contract without an owner,
2074      * thereby removing any functionality that is only available to the owner.
2075      */
2076     function renounceOwnership() public virtual onlyOwner {
2077         _transferOwnership(address(0));
2078     }
2079 
2080     /**
2081      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2082      * Can only be called by the current owner.
2083      */
2084     function transferOwnership(address newOwner) public virtual onlyOwner {
2085         require(newOwner != address(0), "Ownable: new owner is the zero address");
2086         _transferOwnership(newOwner);
2087     }
2088 
2089     /**
2090      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2091      * Internal function without access restriction.
2092      */
2093     function _transferOwnership(address newOwner) internal virtual {
2094         address oldOwner = _owner;
2095         _owner = newOwner;
2096         emit OwnershipTransferred(oldOwner, newOwner);
2097     }
2098 }
2099 
2100 
2101         pragma solidity ^0.8.13;
2102 
2103 
2104 
2105 
2106 
2107 
2108         contract Nakaeggs is ERC721A, Ownable, ReentrancyGuard  , DefaultOperatorFilterer{
2109             using Strings for uint256;
2110             uint256 public _maxSupply = 999;
2111             uint256 public maxMintAmountPerWallet = 3;
2112             uint256 public maxMintAmountPerTx = 3;
2113             string baseURL = "";
2114             string ExtensionURL = ".json";
2115             uint256 _initalPrice = 0 ether;
2116             uint256 public costOfNFT = 0.003 ether;
2117             uint256 public numberOfFreeNFTs = 1;
2118             
2119             string HiddenURL;
2120             bool revealed = false;
2121             bool paused = true;
2122             
2123             error ContractPaused();
2124             error MaxMintWalletExceeded();
2125             error MaxSupply();
2126             error InvalidMintAmount();
2127             error InsufficientFund();
2128             error NoSmartContract();
2129             error TokenNotExisting();
2130 
2131         constructor(string memory _initBaseURI) ERC721A("Nakaeggs", "NKEGS") {
2132             baseURL = _initBaseURI;
2133         }
2134 
2135         // ================== Mint Function =======================
2136 
2137         modifier mintCompliance(uint256 _mintAmount) {
2138             if (totalSupply()  + _mintAmount > _maxSupply) revert MaxSupply();
2139             if (_mintAmount > maxMintAmountPerTx) revert InvalidMintAmount();
2140             if(paused) revert ContractPaused();
2141             _;
2142         }
2143 
2144         modifier mintPriceCompliance(uint256 _mintAmount) {
2145             if(balanceOf(msg.sender) + _mintAmount > maxMintAmountPerWallet) revert MaxMintWalletExceeded();
2146             if (_mintAmount < 0 || _mintAmount > maxMintAmountPerWallet) revert InvalidMintAmount();
2147               if (msg.value < checkCost(_mintAmount)) revert InsufficientFund();
2148             _;
2149         }
2150         
2151         /// @notice compliance of minting
2152         /// @dev user (msg.sender) mint
2153         /// @param _mintAmount the amount of tokens to mint
2154         function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) mintPriceCompliance(_mintAmount){
2155          
2156           
2157           _safeMint(msg.sender, _mintAmount);
2158           }
2159 
2160         /// @dev user (msg.sender) mint
2161         /// @param _mintAmount the amount of tokens to mint 
2162         /// @return value from number to mint
2163         function checkCost(uint256 _mintAmount) public view returns (uint256) {
2164           uint256 totalMints = _mintAmount + balanceOf(msg.sender);
2165           if ((totalMints <= numberOfFreeNFTs) ) {
2166           return _initalPrice;
2167           } else if ((balanceOf(msg.sender) == 0) && (totalMints > numberOfFreeNFTs) ) { 
2168           uint256 total = costOfNFT * _mintAmount;
2169           return total;
2170           } 
2171           else {
2172           uint256 total2 = costOfNFT * _mintAmount;
2173           return total2;
2174             }
2175         }
2176         
2177 
2178 
2179         /// @notice airdrop function to airdrop same amount of tokens to addresses
2180         /// @dev only owner function
2181         /// @param accounts  array of addresses
2182         /// @param amount the amount of tokens to airdrop users
2183         function airdrop(address[] memory accounts, uint256 amount)public onlyOwner mintCompliance(amount) {
2184           for(uint256 i = 0; i < accounts.length; i++){
2185           _safeMint(accounts[i], amount);
2186           }
2187         }
2188 
2189         // =================== Orange Functions (Owner Only) ===============
2190 
2191         /// @dev pause/unpause minting
2192         function pause() public onlyOwner {
2193           paused = !paused;
2194         }
2195 
2196         
2197 
2198         /// @dev set URI
2199         /// @param uri  new URI
2200         function setbaseURL(string memory uri) public onlyOwner{
2201           baseURL = uri;
2202         }
2203 
2204         /// @dev extension URI like 'json'
2205         function setExtensionURL(string memory uri) public onlyOwner{
2206           ExtensionURL = uri;
2207         }
2208         
2209         /// @dev set new cost of tokenId in WEI
2210         /// @param _cost  new price in wei
2211         function setCostPrice(uint256 _cost) public onlyOwner{
2212           costOfNFT = _cost;
2213         } 
2214 
2215         /// @dev only owner
2216         /// @param perTx  new max mint per transaction
2217         function setMaxMintAmountPerTx(uint256 perTx) public onlyOwner{
2218           maxMintAmountPerTx = perTx;
2219         }
2220 
2221         /// @dev only owner
2222         /// @param perWallet  new max mint per wallet
2223         function setMaxMintAmountPerWallet(uint256 perWallet) public onlyOwner{
2224           maxMintAmountPerWallet = perWallet;
2225         }  
2226         
2227         /// @dev only owner
2228         /// @param perWallet set free number of nft per wallet
2229         function setnumberOfFreeNFTs(uint256 perWallet) public onlyOwner{
2230           numberOfFreeNFTs = perWallet;
2231         }            
2232 
2233         // ================================ Withdraw Function ====================
2234 
2235         /// @notice withdraw ether from contract.
2236         /// @dev only owner function
2237         function withdraw() public onlyOwner nonReentrant{
2238           
2239 
2240           
2241 
2242         (bool owner, ) = payable(owner()).call{value: address(this).balance}('');
2243         require(owner);
2244         }
2245         // =================== Blue Functions (View Only) ====================
2246 
2247         /// @dev return uri of token ID
2248         /// @param tokenId  token ID to find uri for
2249         ///@return value for 'tokenId uri'
2250         function tokenURI(uint256 tokenId) public view override(ERC721A) returns (string memory) {
2251           if (!_exists(tokenId)) revert TokenNotExisting();   
2252 
2253         
2254 
2255         string memory currentBaseURI = _baseURI();
2256         return bytes(currentBaseURI).length > 0
2257         ? string(abi.encodePacked(currentBaseURI, tokenId.toString()))
2258         : '';
2259         }
2260         
2261         /// @dev tokenId to start (1)
2262         function _startTokenId() internal view virtual override returns (uint256) {
2263           return 1;
2264         }
2265 
2266         ///@dev maxSupply of token
2267         /// @return max supply
2268         function _baseURI() internal view virtual override returns (string memory) {
2269           return baseURL;
2270         }
2271 
2272     
2273         /// @dev internal function to 
2274         /// @param from  user address where token belongs
2275         /// @param to  user address
2276         /// @param tokenId  number of tokenId
2277           function transferFrom(address from, address to, uint256 tokenId) public payable  override onlyAllowedOperator(from) {
2278         super.transferFrom(from, to, tokenId);
2279         }
2280         
2281         /// @dev internal function to 
2282         /// @param from  user address where token belongs
2283         /// @param to  user address
2284         /// @param tokenId  number of tokenId
2285         function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2286         super.safeTransferFrom(from, to, tokenId);
2287         }
2288 
2289         /// @dev internal function to 
2290         /// @param from  user address where token belongs
2291         /// @param to  user address
2292         /// @param tokenId  number of tokenId
2293         function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2294         public payable
2295         override
2296         onlyAllowedOperator(from)
2297         {
2298         super.safeTransferFrom(from, to, tokenId, data);
2299         }
2300         
2301 
2302 }