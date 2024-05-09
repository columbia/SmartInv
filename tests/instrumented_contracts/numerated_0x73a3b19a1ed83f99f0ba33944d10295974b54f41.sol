1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 pragma solidity ^0.8.17;
4 
5 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
6 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
7 
8 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
9 
10 
11 pragma solidity ^0.8.13;
12 
13 interface IOperatorFilterRegistry {
14     /**
15      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
16      *         true if supplied registrant address is not registered.
17      */
18     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
19 
20     /**
21      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
22      */
23     function register(address registrant) external;
24 
25     /**
26      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
27      */
28     function registerAndSubscribe(address registrant, address subscription) external;
29 
30     /**
31      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
32      *         address without subscribing.
33      */
34     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
35 
36     /**
37      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
38      *         Note that this does not remove any filtered addresses or codeHashes.
39      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
40      */
41     function unregister(address addr) external;
42 
43     /**
44      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
45      */
46     function updateOperator(address registrant, address operator, bool filtered) external;
47 
48     /**
49      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
50      */
51     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
52 
53     /**
54      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
55      */
56     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
57 
58     /**
59      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
60      */
61     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
62 
63     /**
64      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
65      *         subscription if present.
66      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
67      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
68      *         used.
69      */
70     function subscribe(address registrant, address registrantToSubscribe) external;
71 
72     /**
73      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
74      */
75     function unsubscribe(address registrant, bool copyExistingEntries) external;
76 
77     /**
78      * @notice Get the subscription address of a given registrant, if any.
79      */
80     function subscriptionOf(address addr) external returns (address registrant);
81 
82     /**
83      * @notice Get the set of addresses subscribed to a given registrant.
84      *         Note that order is not guaranteed as updates are made.
85      */
86     function subscribers(address registrant) external returns (address[] memory);
87 
88     /**
89      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
90      *         Note that order is not guaranteed as updates are made.
91      */
92     function subscriberAt(address registrant, uint256 index) external returns (address);
93 
94     /**
95      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
96      */
97     function copyEntriesOf(address registrant, address registrantToCopy) external;
98 
99     /**
100      * @notice Returns true if operator is filtered by a given address or its subscription.
101      */
102     function isOperatorFiltered(address registrant, address operator) external returns (bool);
103 
104     /**
105      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
106      */
107     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
108 
109     /**
110      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
111      */
112     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
113 
114     /**
115      * @notice Returns a list of filtered operators for a given address or its subscription.
116      */
117     function filteredOperators(address addr) external returns (address[] memory);
118 
119     /**
120      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
121      *         Note that order is not guaranteed as updates are made.
122      */
123     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
124 
125     /**
126      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
127      *         its subscription.
128      *         Note that order is not guaranteed as updates are made.
129      */
130     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
131 
132     /**
133      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
134      *         its subscription.
135      *         Note that order is not guaranteed as updates are made.
136      */
137     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
138 
139     /**
140      * @notice Returns true if an address has registered
141      */
142     function isRegistered(address addr) external returns (bool);
143 
144     /**
145      * @dev Convenience method to compute the code hash of an arbitrary contract
146      */
147     function codeHashOf(address addr) external returns (bytes32);
148 }
149 
150 // File: operator-filter-registry/src/OperatorFilterer.sol
151 
152 
153 pragma solidity ^0.8.13;
154 
155 
156 /**
157  * @title  OperatorFilterer
158  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
159  *         registrant's entries in the OperatorFilterRegistry.
160  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
161  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
162  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
163  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
164  *         administration methods on the contract itself to interact with the registry otherwise the subscription
165  *         will be locked to the options set during construction.
166  */
167 
168 abstract contract OperatorFilterer {
169     /// @dev Emitted when an operator is not allowed.
170     error OperatorNotAllowed(address operator);
171 
172     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
173         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
174 
175     /// @dev The constructor that is called when the contract is being deployed.
176     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
177         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
178         // will not revert, but the contract will need to be registered with the registry once it is deployed in
179         // order for the modifier to filter addresses.
180         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
181             if (subscribe) {
182                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
183             } else {
184                 if (subscriptionOrRegistrantToCopy != address(0)) {
185                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
186                 } else {
187                     OPERATOR_FILTER_REGISTRY.register(address(this));
188                 }
189             }
190         }
191     }
192 
193     /**
194      * @dev A helper function to check if an operator is allowed.
195      */
196     modifier onlyAllowedOperator(address from) virtual {
197         // Allow spending tokens from addresses with balance
198         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
199         // from an EOA.
200         if (from != msg.sender) {
201             _checkFilterOperator(msg.sender);
202         }
203         _;
204     }
205 
206     /**
207      * @dev A helper function to check if an operator approval is allowed.
208      */
209     modifier onlyAllowedOperatorApproval(address operator) virtual {
210         _checkFilterOperator(operator);
211         _;
212     }
213 
214     /**
215      * @dev A helper function to check if an operator is allowed.
216      */
217     function _checkFilterOperator(address operator) internal view virtual {
218         // Check registry code length to facilitate testing in environments without a deployed registry.
219         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
220             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
221             // may specify their own OperatorFilterRegistry implementations, which may behave differently
222             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
223                 revert OperatorNotAllowed(operator);
224             }
225         }
226     }
227 }
228 
229 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
230 
231 
232 pragma solidity ^0.8.13;
233 
234 
235 /**
236  * @title  DefaultOperatorFilterer
237  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
238  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
239  *         administration methods on the contract itself to interact with the registry otherwise the subscription
240  *         will be locked to the options set during construction.
241  */
242 
243 abstract contract DefaultOperatorFilterer is OperatorFilterer {
244     /// @dev The constructor that is called when the contract is being deployed.
245     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
246 }
247 
248 // File: @openzeppelin/contracts/utils/math/Math.sol
249 
250 
251 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 /**
256  * @dev Standard math utilities missing in the Solidity language.
257  */
258 library Math {
259     enum Rounding {
260         Down, // Toward negative infinity
261         Up, // Toward infinity
262         Zero // Toward zero
263     }
264 
265     /**
266      * @dev Returns the largest of two numbers.
267      */
268     function max(uint256 a, uint256 b) internal pure returns (uint256) {
269         return a > b ? a : b;
270     }
271 
272     /**
273      * @dev Returns the smallest of two numbers.
274      */
275     function min(uint256 a, uint256 b) internal pure returns (uint256) {
276         return a < b ? a : b;
277     }
278 
279     /**
280      * @dev Returns the average of two numbers. The result is rounded towards
281      * zero.
282      */
283     function average(uint256 a, uint256 b) internal pure returns (uint256) {
284         // (a + b) / 2 can overflow.
285         return (a & b) + (a ^ b) / 2;
286     }
287 
288     /**
289      * @dev Returns the ceiling of the division of two numbers.
290      *
291      * This differs from standard division with `/` in that it rounds up instead
292      * of rounding down.
293      */
294     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
295         // (a + b - 1) / b can overflow on addition, so we distribute.
296         return a == 0 ? 0 : (a - 1) / b + 1;
297     }
298 
299     /**
300      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
301      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
302      * with further edits by Uniswap Labs also under MIT license.
303      */
304     function mulDiv(
305         uint256 x,
306         uint256 y,
307         uint256 denominator
308     ) internal pure returns (uint256 result) {
309         unchecked {
310             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
311             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
312             // variables such that product = prod1 * 2^256 + prod0.
313             uint256 prod0; // Least significant 256 bits of the product
314             uint256 prod1; // Most significant 256 bits of the product
315             assembly {
316                 let mm := mulmod(x, y, not(0))
317                 prod0 := mul(x, y)
318                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
319             }
320 
321             // Handle non-overflow cases, 256 by 256 division.
322             if (prod1 == 0) {
323                 return prod0 / denominator;
324             }
325 
326             // Make sure the result is less than 2^256. Also prevents denominator == 0.
327             require(denominator > prod1);
328 
329             ///////////////////////////////////////////////
330             // 512 by 256 division.
331             ///////////////////////////////////////////////
332 
333             // Make division exact by subtracting the remainder from [prod1 prod0].
334             uint256 remainder;
335             assembly {
336                 // Compute remainder using mulmod.
337                 remainder := mulmod(x, y, denominator)
338 
339                 // Subtract 256 bit number from 512 bit number.
340                 prod1 := sub(prod1, gt(remainder, prod0))
341                 prod0 := sub(prod0, remainder)
342             }
343 
344             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
345             // See https://cs.stackexchange.com/q/138556/92363.
346 
347             // Does not overflow because the denominator cannot be zero at this stage in the function.
348             uint256 twos = denominator & (~denominator + 1);
349             assembly {
350                 // Divide denominator by twos.
351                 denominator := div(denominator, twos)
352 
353                 // Divide [prod1 prod0] by twos.
354                 prod0 := div(prod0, twos)
355 
356                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
357                 twos := add(div(sub(0, twos), twos), 1)
358             }
359 
360             // Shift in bits from prod1 into prod0.
361             prod0 |= prod1 * twos;
362 
363             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
364             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
365             // four bits. That is, denominator * inv = 1 mod 2^4.
366             uint256 inverse = (3 * denominator) ^ 2;
367 
368             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
369             // in modular arithmetic, doubling the correct bits in each step.
370             inverse *= 2 - denominator * inverse; // inverse mod 2^8
371             inverse *= 2 - denominator * inverse; // inverse mod 2^16
372             inverse *= 2 - denominator * inverse; // inverse mod 2^32
373             inverse *= 2 - denominator * inverse; // inverse mod 2^64
374             inverse *= 2 - denominator * inverse; // inverse mod 2^128
375             inverse *= 2 - denominator * inverse; // inverse mod 2^256
376 
377             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
378             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
379             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
380             // is no longer required.
381             result = prod0 * inverse;
382             return result;
383         }
384     }
385 
386     /**
387      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
388      */
389     function mulDiv(
390         uint256 x,
391         uint256 y,
392         uint256 denominator,
393         Rounding rounding
394     ) internal pure returns (uint256) {
395         uint256 result = mulDiv(x, y, denominator);
396         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
397             result += 1;
398         }
399         return result;
400     }
401 
402     /**
403      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
404      *
405      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
406      */
407     function sqrt(uint256 a) internal pure returns (uint256) {
408         if (a == 0) {
409             return 0;
410         }
411 
412         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
413         //
414         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
415         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
416         //
417         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
418         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
419         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
420         //
421         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
422         uint256 result = 1 << (log2(a) >> 1);
423 
424         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
425         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
426         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
427         // into the expected uint128 result.
428         unchecked {
429             result = (result + a / result) >> 1;
430             result = (result + a / result) >> 1;
431             result = (result + a / result) >> 1;
432             result = (result + a / result) >> 1;
433             result = (result + a / result) >> 1;
434             result = (result + a / result) >> 1;
435             result = (result + a / result) >> 1;
436             return min(result, a / result);
437         }
438     }
439 
440     /**
441      * @notice Calculates sqrt(a), following the selected rounding direction.
442      */
443     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
444         unchecked {
445             uint256 result = sqrt(a);
446             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
447         }
448     }
449 
450     /**
451      * @dev Return the log in base 2, rounded down, of a positive value.
452      * Returns 0 if given 0.
453      */
454     function log2(uint256 value) internal pure returns (uint256) {
455         uint256 result = 0;
456         unchecked {
457             if (value >> 128 > 0) {
458                 value >>= 128;
459                 result += 128;
460             }
461             if (value >> 64 > 0) {
462                 value >>= 64;
463                 result += 64;
464             }
465             if (value >> 32 > 0) {
466                 value >>= 32;
467                 result += 32;
468             }
469             if (value >> 16 > 0) {
470                 value >>= 16;
471                 result += 16;
472             }
473             if (value >> 8 > 0) {
474                 value >>= 8;
475                 result += 8;
476             }
477             if (value >> 4 > 0) {
478                 value >>= 4;
479                 result += 4;
480             }
481             if (value >> 2 > 0) {
482                 value >>= 2;
483                 result += 2;
484             }
485             if (value >> 1 > 0) {
486                 result += 1;
487             }
488         }
489         return result;
490     }
491 
492     /**
493      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
494      * Returns 0 if given 0.
495      */
496     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
497         unchecked {
498             uint256 result = log2(value);
499             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
500         }
501     }
502 
503     /**
504      * @dev Return the log in base 10, rounded down, of a positive value.
505      * Returns 0 if given 0.
506      */
507     function log10(uint256 value) internal pure returns (uint256) {
508         uint256 result = 0;
509         unchecked {
510             if (value >= 10**64) {
511                 value /= 10**64;
512                 result += 64;
513             }
514             if (value >= 10**32) {
515                 value /= 10**32;
516                 result += 32;
517             }
518             if (value >= 10**16) {
519                 value /= 10**16;
520                 result += 16;
521             }
522             if (value >= 10**8) {
523                 value /= 10**8;
524                 result += 8;
525             }
526             if (value >= 10**4) {
527                 value /= 10**4;
528                 result += 4;
529             }
530             if (value >= 10**2) {
531                 value /= 10**2;
532                 result += 2;
533             }
534             if (value >= 10**1) {
535                 result += 1;
536             }
537         }
538         return result;
539     }
540 
541     /**
542      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
546         unchecked {
547             uint256 result = log10(value);
548             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
549         }
550     }
551 
552     /**
553      * @dev Return the log in base 256, rounded down, of a positive value.
554      * Returns 0 if given 0.
555      *
556      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
557      */
558     function log256(uint256 value) internal pure returns (uint256) {
559         uint256 result = 0;
560         unchecked {
561             if (value >> 128 > 0) {
562                 value >>= 128;
563                 result += 16;
564             }
565             if (value >> 64 > 0) {
566                 value >>= 64;
567                 result += 8;
568             }
569             if (value >> 32 > 0) {
570                 value >>= 32;
571                 result += 4;
572             }
573             if (value >> 16 > 0) {
574                 value >>= 16;
575                 result += 2;
576             }
577             if (value >> 8 > 0) {
578                 result += 1;
579             }
580         }
581         return result;
582     }
583 
584     /**
585      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
586      * Returns 0 if given 0.
587      */
588     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
589         unchecked {
590             uint256 result = log256(value);
591             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
592         }
593     }
594 }
595 
596 // File: @openzeppelin/contracts/utils/Strings.sol
597 
598 
599 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
600 
601 pragma solidity ^0.8.0;
602 
603 
604 /**
605  * @dev String operations.
606  */
607 library Strings {
608     bytes16 private constant _SYMBOLS = "0123456789abcdef";
609     uint8 private constant _ADDRESS_LENGTH = 20;
610 
611     /**
612      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
613      */
614     function toString(uint256 value) internal pure returns (string memory) {
615         unchecked {
616             uint256 length = Math.log10(value) + 1;
617             string memory buffer = new string(length);
618             uint256 ptr;
619             /// @solidity memory-safe-assembly
620             assembly {
621                 ptr := add(buffer, add(32, length))
622             }
623             while (true) {
624                 ptr--;
625                 /// @solidity memory-safe-assembly
626                 assembly {
627                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
628                 }
629                 value /= 10;
630                 if (value == 0) break;
631             }
632             return buffer;
633         }
634     }
635 
636     /**
637      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
638      */
639     function toHexString(uint256 value) internal pure returns (string memory) {
640         unchecked {
641             return toHexString(value, Math.log256(value) + 1);
642         }
643     }
644 
645     /**
646      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
647      */
648     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
649         bytes memory buffer = new bytes(2 * length + 2);
650         buffer[0] = "0";
651         buffer[1] = "x";
652         for (uint256 i = 2 * length + 1; i > 1; --i) {
653             buffer[i] = _SYMBOLS[value & 0xf];
654             value >>= 4;
655         }
656         require(value == 0, "Strings: hex length insufficient");
657         return string(buffer);
658     }
659 
660     /**
661      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
662      */
663     function toHexString(address addr) internal pure returns (string memory) {
664         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
665     }
666 }
667 
668 // File: @openzeppelin/contracts/utils/Context.sol
669 
670 
671 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
672 
673 pragma solidity ^0.8.0;
674 
675 /**
676  * @dev Provides information about the current execution context, including the
677  * sender of the transaction and its data. While these are generally available
678  * via msg.sender and msg.data, they should not be accessed in such a direct
679  * manner, since when dealing with meta-transactions the account sending and
680  * paying for execution may not be the actual sender (as far as an application
681  * is concerned).
682  *
683  * This contract is only required for intermediate, library-like contracts.
684  */
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
695 // File: @openzeppelin/contracts/access/Ownable.sol
696 
697 
698 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
699 
700 pragma solidity ^0.8.0;
701 
702 
703 /**
704  * @dev Contract module which provides a basic access control mechanism, where
705  * there is an account (an owner) that can be granted exclusive access to
706  * specific functions.
707  *
708  * By default, the owner account will be the one that deploys the contract. This
709  * can later be changed with {transferOwnership}.
710  *
711  * This module is used through inheritance. It will make available the modifier
712  * `onlyOwner`, which can be applied to your functions to restrict their use to
713  * the owner.
714  */
715 abstract contract Ownable is Context {
716     address private _owner;
717 
718     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
719 
720     /**
721      * @dev Initializes the contract setting the deployer as the initial owner.
722      */
723     constructor() {
724         _transferOwnership(_msgSender());
725     }
726 
727     /**
728      * @dev Throws if called by any account other than the owner.
729      */
730     modifier onlyOwner() {
731         _checkOwner();
732         _;
733     }
734 
735     /**
736      * @dev Returns the address of the current owner.
737      */
738     function owner() public view virtual returns (address) {
739         return _owner;
740     }
741 
742     /**
743      * @dev Throws if the sender is not the owner.
744      */
745     function _checkOwner() internal view virtual {
746         require(owner() == _msgSender(), "Ownable: caller is not the owner");
747     }
748 
749     /**
750      * @dev Leaves the contract without owner. It will not be possible to call
751      * `onlyOwner` functions anymore. Can only be called by the current owner.
752      *
753      * NOTE: Renouncing ownership will leave the contract without an owner,
754      * thereby removing any functionality that is only available to the owner.
755      */
756     function renounceOwnership() public virtual onlyOwner {
757         _transferOwnership(address(0));
758     }
759 
760     /**
761      * @dev Transfers ownership of the contract to a new account (`newOwner`).
762      * Can only be called by the current owner.
763      */
764     function transferOwnership(address newOwner) public virtual onlyOwner {
765         require(newOwner != address(0), "Ownable: new owner is the zero address");
766         _transferOwnership(newOwner);
767     }
768 
769     /**
770      * @dev Transfers ownership of the contract to a new account (`newOwner`).
771      * Internal function without access restriction.
772      */
773     function _transferOwnership(address newOwner) internal virtual {
774         address oldOwner = _owner;
775         _owner = newOwner;
776         emit OwnershipTransferred(oldOwner, newOwner);
777     }
778 }
779 
780 // File: erc721a/contracts/IERC721A.sol
781 
782 
783 // ERC721A Contracts v4.2.3
784 // Creator: Chiru Labs
785 
786 pragma solidity ^0.8.4;
787 
788 /**
789  * @dev Interface of ERC721A.
790  */
791 interface IERC721A {
792     /**
793      * The caller must own the token or be an approved operator.
794      */
795     error ApprovalCallerNotOwnerNorApproved();
796 
797     /**
798      * The token does not exist.
799      */
800     error ApprovalQueryForNonexistentToken();
801 
802     /**
803      * Cannot query the balance for the zero address.
804      */
805     error BalanceQueryForZeroAddress();
806 
807     /**
808      * Cannot mint to the zero address.
809      */
810     error MintToZeroAddress();
811 
812     /**
813      * The quantity of tokens minted must be more than zero.
814      */
815     error MintZeroQuantity();
816 
817     /**
818      * The token does not exist.
819      */
820     error OwnerQueryForNonexistentToken();
821 
822     /**
823      * The caller must own the token or be an approved operator.
824      */
825     error TransferCallerNotOwnerNorApproved();
826 
827     /**
828      * The token must be owned by `from`.
829      */
830     error TransferFromIncorrectOwner();
831 
832     /**
833      * Cannot safely transfer to a contract that does not implement the
834      * ERC721Receiver interface.
835      */
836     error TransferToNonERC721ReceiverImplementer();
837 
838     /**
839      * Cannot transfer to the zero address.
840      */
841     error TransferToZeroAddress();
842 
843     /**
844      * The token does not exist.
845      */
846     error URIQueryForNonexistentToken();
847 
848     /**
849      * The `quantity` minted with ERC2309 exceeds the safety limit.
850      */
851     error MintERC2309QuantityExceedsLimit();
852 
853     /**
854      * The `extraData` cannot be set on an unintialized ownership slot.
855      */
856     error OwnershipNotInitializedForExtraData();
857 
858     // =============================================================
859     //                            STRUCTS
860     // =============================================================
861 
862     struct TokenOwnership {
863         // The address of the owner.
864         address addr;
865         // Stores the start time of ownership with minimal overhead for tokenomics.
866         uint64 startTimestamp;
867         // Whether the token has been burned.
868         bool burned;
869         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
870         uint24 extraData;
871     }
872 
873     // =============================================================
874     //                         TOKEN COUNTERS
875     // =============================================================
876 
877     /**
878      * @dev Returns the total number of tokens in existence.
879      * Burned tokens will reduce the count.
880      * To get the total number of tokens minted, please see {_totalMinted}.
881      */
882     function totalSupply() external view returns (uint256);
883 
884     // =============================================================
885     //                            IERC165
886     // =============================================================
887 
888     /**
889      * @dev Returns true if this contract implements the interface defined by
890      * `interfaceId`. See the corresponding
891      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
892      * to learn more about how these ids are created.
893      *
894      * This function call must use less than 30000 gas.
895      */
896     function supportsInterface(bytes4 interfaceId) external view returns (bool);
897 
898     // =============================================================
899     //                            IERC721
900     // =============================================================
901 
902     /**
903      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
904      */
905     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
906 
907     /**
908      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
909      */
910     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
911 
912     /**
913      * @dev Emitted when `owner` enables or disables
914      * (`approved`) `operator` to manage all of its assets.
915      */
916     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
917 
918     /**
919      * @dev Returns the number of tokens in `owner`'s account.
920      */
921     function balanceOf(address owner) external view returns (uint256 balance);
922 
923     /**
924      * @dev Returns the owner of the `tokenId` token.
925      *
926      * Requirements:
927      *
928      * - `tokenId` must exist.
929      */
930     function ownerOf(uint256 tokenId) external view returns (address owner);
931 
932     /**
933      * @dev Safely transfers `tokenId` token from `from` to `to`,
934      * checking first that contract recipients are aware of the ERC721 protocol
935      * to prevent tokens from being forever locked.
936      *
937      * Requirements:
938      *
939      * - `from` cannot be the zero address.
940      * - `to` cannot be the zero address.
941      * - `tokenId` token must exist and be owned by `from`.
942      * - If the caller is not `from`, it must be have been allowed to move
943      * this token by either {approve} or {setApprovalForAll}.
944      * - If `to` refers to a smart contract, it must implement
945      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
946      *
947      * Emits a {Transfer} event.
948      */
949     function safeTransferFrom(
950         address from,
951         address to,
952         uint256 tokenId,
953         bytes calldata data
954     ) external payable;
955 
956     /**
957      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
958      */
959     function safeTransferFrom(
960         address from,
961         address to,
962         uint256 tokenId
963     ) external payable;
964 
965     /**
966      * @dev Transfers `tokenId` from `from` to `to`.
967      *
968      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
969      * whenever possible.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      * - If the caller is not `from`, it must be approved to move this token
977      * by either {approve} or {setApprovalForAll}.
978      *
979      * Emits a {Transfer} event.
980      */
981     function transferFrom(
982         address from,
983         address to,
984         uint256 tokenId
985     ) external payable;
986 
987     /**
988      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
989      * The approval is cleared when the token is transferred.
990      *
991      * Only a single account can be approved at a time, so approving the
992      * zero address clears previous approvals.
993      *
994      * Requirements:
995      *
996      * - The caller must own the token or be an approved operator.
997      * - `tokenId` must exist.
998      *
999      * Emits an {Approval} event.
1000      */
1001     function approve(address to, uint256 tokenId) external payable;
1002 
1003     /**
1004      * @dev Approve or remove `operator` as an operator for the caller.
1005      * Operators can call {transferFrom} or {safeTransferFrom}
1006      * for any token owned by the caller.
1007      *
1008      * Requirements:
1009      *
1010      * - The `operator` cannot be the caller.
1011      *
1012      * Emits an {ApprovalForAll} event.
1013      */
1014     function setApprovalForAll(address operator, bool _approved) external;
1015 
1016     /**
1017      * @dev Returns the account approved for `tokenId` token.
1018      *
1019      * Requirements:
1020      *
1021      * - `tokenId` must exist.
1022      */
1023     function getApproved(uint256 tokenId) external view returns (address operator);
1024 
1025     /**
1026      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1027      *
1028      * See {setApprovalForAll}.
1029      */
1030     function isApprovedForAll(address owner, address operator) external view returns (bool);
1031 
1032     // =============================================================
1033     //                        IERC721Metadata
1034     // =============================================================
1035 
1036     /**
1037      * @dev Returns the token collection name.
1038      */
1039     function name() external view returns (string memory);
1040 
1041     /**
1042      * @dev Returns the token collection symbol.
1043      */
1044     function symbol() external view returns (string memory);
1045 
1046     /**
1047      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1048      */
1049     function tokenURI(uint256 tokenId) external view returns (string memory);
1050 
1051     // =============================================================
1052     //                           IERC2309
1053     // =============================================================
1054 
1055     /**
1056      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1057      * (inclusive) is transferred from `from` to `to`, as defined in the
1058      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1059      *
1060      * See {_mintERC2309} for more details.
1061      */
1062     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1063 }
1064 
1065 // File: erc721a/contracts/ERC721A.sol
1066 
1067 
1068 // ERC721A Contracts v4.2.3
1069 // Creator: Chiru Labs
1070 
1071 pragma solidity ^0.8.4;
1072 
1073 
1074 /**
1075  * @dev Interface of ERC721 token receiver.
1076  */
1077 interface ERC721A__IERC721Receiver {
1078     function onERC721Received(
1079         address operator,
1080         address from,
1081         uint256 tokenId,
1082         bytes calldata data
1083     ) external returns (bytes4);
1084 }
1085 
1086 /**
1087  * @title ERC721A
1088  *
1089  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1090  * Non-Fungible Token Standard, including the Metadata extension.
1091  * Optimized for lower gas during batch mints.
1092  *
1093  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1094  * starting from `_startTokenId()`.
1095  *
1096  * Assumptions:
1097  *
1098  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1099  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1100  */
1101 contract ERC721A is IERC721A {
1102     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1103     struct TokenApprovalRef {
1104         address value;
1105     }
1106 
1107     // =============================================================
1108     //                           CONSTANTS
1109     // =============================================================
1110 
1111     // Mask of an entry in packed address data.
1112     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1113 
1114     // The bit position of `numberMinted` in packed address data.
1115     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1116 
1117     // The bit position of `numberBurned` in packed address data.
1118     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1119 
1120     // The bit position of `aux` in packed address data.
1121     uint256 private constant _BITPOS_AUX = 192;
1122 
1123     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1124     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1125 
1126     // The bit position of `startTimestamp` in packed ownership.
1127     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1128 
1129     // The bit mask of the `burned` bit in packed ownership.
1130     uint256 private constant _BITMASK_BURNED = 1 << 224;
1131 
1132     // The bit position of the `nextInitialized` bit in packed ownership.
1133     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1134 
1135     // The bit mask of the `nextInitialized` bit in packed ownership.
1136     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1137 
1138     // The bit position of `extraData` in packed ownership.
1139     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1140 
1141     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1142     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1143 
1144     // The mask of the lower 160 bits for addresses.
1145     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1146 
1147     // The maximum `quantity` that can be minted with {_mintERC2309}.
1148     // This limit is to prevent overflows on the address data entries.
1149     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1150     // is required to cause an overflow, which is unrealistic.
1151     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1152 
1153     // The `Transfer` event signature is given by:
1154     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1155     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1156         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1157 
1158     // =============================================================
1159     //                            STORAGE
1160     // =============================================================
1161 
1162     // The next token ID to be minted.
1163     uint256 private _currentIndex;
1164 
1165     // The number of tokens burned.
1166     uint256 private _burnCounter;
1167 
1168     // Token name
1169     string private _name;
1170 
1171     // Token symbol
1172     string private _symbol;
1173 
1174     // Mapping from token ID to ownership details
1175     // An empty struct value does not necessarily mean the token is unowned.
1176     // See {_packedOwnershipOf} implementation for details.
1177     //
1178     // Bits Layout:
1179     // - [0..159]   `addr`
1180     // - [160..223] `startTimestamp`
1181     // - [224]      `burned`
1182     // - [225]      `nextInitialized`
1183     // - [232..255] `extraData`
1184     mapping(uint256 => uint256) private _packedOwnerships;
1185 
1186     // Mapping owner address to address data.
1187     //
1188     // Bits Layout:
1189     // - [0..63]    `balance`
1190     // - [64..127]  `numberMinted`
1191     // - [128..191] `numberBurned`
1192     // - [192..255] `aux`
1193     mapping(address => uint256) private _packedAddressData;
1194 
1195     // Mapping from token ID to approved address.
1196     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1197 
1198     // Mapping from owner to operator approvals
1199     mapping(address => mapping(address => bool)) private _operatorApprovals;
1200 
1201     // =============================================================
1202     //                          CONSTRUCTOR
1203     // =============================================================
1204 
1205     constructor(string memory name_, string memory symbol_) {
1206         _name = name_;
1207         _symbol = symbol_;
1208         _currentIndex = _startTokenId();
1209     }
1210 
1211     // =============================================================
1212     //                   TOKEN COUNTING OPERATIONS
1213     // =============================================================
1214 
1215     /**
1216      * @dev Returns the starting token ID.
1217      * To change the starting token ID, please override this function.
1218      */
1219     function _startTokenId() internal view virtual returns (uint256) {
1220         return 0;
1221     }
1222 
1223     /**
1224      * @dev Returns the next token ID to be minted.
1225      */
1226     function _nextTokenId() internal view virtual returns (uint256) {
1227         return _currentIndex;
1228     }
1229 
1230     /**
1231      * @dev Returns the total number of tokens in existence.
1232      * Burned tokens will reduce the count.
1233      * To get the total number of tokens minted, please see {_totalMinted}.
1234      */
1235     function totalSupply() public view virtual override returns (uint256) {
1236         // Counter underflow is impossible as _burnCounter cannot be incremented
1237         // more than `_currentIndex - _startTokenId()` times.
1238         unchecked {
1239             return _currentIndex - _burnCounter - _startTokenId();
1240         }
1241     }
1242 
1243     /**
1244      * @dev Returns the total amount of tokens minted in the contract.
1245      */
1246     function _totalMinted() internal view virtual returns (uint256) {
1247         // Counter underflow is impossible as `_currentIndex` does not decrement,
1248         // and it is initialized to `_startTokenId()`.
1249         unchecked {
1250             return _currentIndex - _startTokenId();
1251         }
1252     }
1253 
1254     /**
1255      * @dev Returns the total number of tokens burned.
1256      */
1257     function _totalBurned() internal view virtual returns (uint256) {
1258         return _burnCounter;
1259     }
1260 
1261     // =============================================================
1262     //                    ADDRESS DATA OPERATIONS
1263     // =============================================================
1264 
1265     /**
1266      * @dev Returns the number of tokens in `owner`'s account.
1267      */
1268     function balanceOf(address owner) public view virtual override returns (uint256) {
1269         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1270         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1271     }
1272 
1273     /**
1274      * Returns the number of tokens minted by `owner`.
1275      */
1276     function _numberMinted(address owner) internal view returns (uint256) {
1277         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1278     }
1279 
1280     /**
1281      * Returns the number of tokens burned by or on behalf of `owner`.
1282      */
1283     function _numberBurned(address owner) internal view returns (uint256) {
1284         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1285     }
1286 
1287     /**
1288      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1289      */
1290     function _getAux(address owner) internal view returns (uint64) {
1291         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1292     }
1293 
1294     /**
1295      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1296      * If there are multiple variables, please pack them into a uint64.
1297      */
1298     function _setAux(address owner, uint64 aux) internal virtual {
1299         uint256 packed = _packedAddressData[owner];
1300         uint256 auxCasted;
1301         // Cast `aux` with assembly to avoid redundant masking.
1302         assembly {
1303             auxCasted := aux
1304         }
1305         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1306         _packedAddressData[owner] = packed;
1307     }
1308 
1309     // =============================================================
1310     //                            IERC165
1311     // =============================================================
1312 
1313     /**
1314      * @dev Returns true if this contract implements the interface defined by
1315      * `interfaceId`. See the corresponding
1316      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1317      * to learn more about how these ids are created.
1318      *
1319      * This function call must use less than 30000 gas.
1320      */
1321     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1322         // The interface IDs are constants representing the first 4 bytes
1323         // of the XOR of all function selectors in the interface.
1324         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1325         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1326         return
1327             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1328             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1329             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1330     }
1331 
1332     // =============================================================
1333     //                        IERC721Metadata
1334     // =============================================================
1335 
1336     /**
1337      * @dev Returns the token collection name.
1338      */
1339     function name() public view virtual override returns (string memory) {
1340         return _name;
1341     }
1342 
1343     /**
1344      * @dev Returns the token collection symbol.
1345      */
1346     function symbol() public view virtual override returns (string memory) {
1347         return _symbol;
1348     }
1349 
1350     /**
1351      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1352      */
1353     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1354         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1355 
1356         string memory baseURI = _baseURI();
1357         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1358     }
1359 
1360     /**
1361      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1362      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1363      * by default, it can be overridden in child contracts.
1364      */
1365     function _baseURI() internal view virtual returns (string memory) {
1366         return '';
1367     }
1368 
1369     // =============================================================
1370     //                     OWNERSHIPS OPERATIONS
1371     // =============================================================
1372 
1373     /**
1374      * @dev Returns the owner of the `tokenId` token.
1375      *
1376      * Requirements:
1377      *
1378      * - `tokenId` must exist.
1379      */
1380     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1381         return address(uint160(_packedOwnershipOf(tokenId)));
1382     }
1383 
1384     /**
1385      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1386      * It gradually moves to O(1) as tokens get transferred around over time.
1387      */
1388     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1389         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1390     }
1391 
1392     /**
1393      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1394      */
1395     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1396         return _unpackedOwnership(_packedOwnerships[index]);
1397     }
1398 
1399     /**
1400      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1401      */
1402     function _initializeOwnershipAt(uint256 index) internal virtual {
1403         if (_packedOwnerships[index] == 0) {
1404             _packedOwnerships[index] = _packedOwnershipOf(index);
1405         }
1406     }
1407 
1408     /**
1409      * Returns the packed ownership data of `tokenId`.
1410      */
1411     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1412         uint256 curr = tokenId;
1413 
1414         unchecked {
1415             if (_startTokenId() <= curr)
1416                 if (curr < _currentIndex) {
1417                     uint256 packed = _packedOwnerships[curr];
1418                     // If not burned.
1419                     if (packed & _BITMASK_BURNED == 0) {
1420                         // Invariant:
1421                         // There will always be an initialized ownership slot
1422                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1423                         // before an unintialized ownership slot
1424                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1425                         // Hence, `curr` will not underflow.
1426                         //
1427                         // We can directly compare the packed value.
1428                         // If the address is zero, packed will be zero.
1429                         while (packed == 0) {
1430                             packed = _packedOwnerships[--curr];
1431                         }
1432                         return packed;
1433                     }
1434                 }
1435         }
1436         revert OwnerQueryForNonexistentToken();
1437     }
1438 
1439     /**
1440      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1441      */
1442     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1443         ownership.addr = address(uint160(packed));
1444         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1445         ownership.burned = packed & _BITMASK_BURNED != 0;
1446         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1447     }
1448 
1449     /**
1450      * @dev Packs ownership data into a single uint256.
1451      */
1452     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1453         assembly {
1454             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1455             owner := and(owner, _BITMASK_ADDRESS)
1456             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1457             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1458         }
1459     }
1460 
1461     /**
1462      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1463      */
1464     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1465         // For branchless setting of the `nextInitialized` flag.
1466         assembly {
1467             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1468             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1469         }
1470     }
1471 
1472     // =============================================================
1473     //                      APPROVAL OPERATIONS
1474     // =============================================================
1475 
1476     /**
1477      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1478      * The approval is cleared when the token is transferred.
1479      *
1480      * Only a single account can be approved at a time, so approving the
1481      * zero address clears previous approvals.
1482      *
1483      * Requirements:
1484      *
1485      * - The caller must own the token or be an approved operator.
1486      * - `tokenId` must exist.
1487      *
1488      * Emits an {Approval} event.
1489      */
1490     function approve(address to, uint256 tokenId) public payable virtual override {
1491         address owner = ownerOf(tokenId);
1492 
1493         if (_msgSenderERC721A() != owner)
1494             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1495                 revert ApprovalCallerNotOwnerNorApproved();
1496             }
1497 
1498         _tokenApprovals[tokenId].value = to;
1499         emit Approval(owner, to, tokenId);
1500     }
1501 
1502     /**
1503      * @dev Returns the account approved for `tokenId` token.
1504      *
1505      * Requirements:
1506      *
1507      * - `tokenId` must exist.
1508      */
1509     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1510         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1511 
1512         return _tokenApprovals[tokenId].value;
1513     }
1514 
1515     /**
1516      * @dev Approve or remove `operator` as an operator for the caller.
1517      * Operators can call {transferFrom} or {safeTransferFrom}
1518      * for any token owned by the caller.
1519      *
1520      * Requirements:
1521      *
1522      * - The `operator` cannot be the caller.
1523      *
1524      * Emits an {ApprovalForAll} event.
1525      */
1526     function setApprovalForAll(address operator, bool approved) public virtual override {
1527         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1528         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1529     }
1530 
1531     /**
1532      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1533      *
1534      * See {setApprovalForAll}.
1535      */
1536     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1537         return _operatorApprovals[owner][operator];
1538     }
1539 
1540     /**
1541      * @dev Returns whether `tokenId` exists.
1542      *
1543      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1544      *
1545      * Tokens start existing when they are minted. See {_mint}.
1546      */
1547     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1548         return
1549             _startTokenId() <= tokenId &&
1550             tokenId < _currentIndex && // If within bounds,
1551             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1552     }
1553 
1554     /**
1555      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1556      */
1557     function _isSenderApprovedOrOwner(
1558         address approvedAddress,
1559         address owner,
1560         address msgSender
1561     ) private pure returns (bool result) {
1562         assembly {
1563             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1564             owner := and(owner, _BITMASK_ADDRESS)
1565             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1566             msgSender := and(msgSender, _BITMASK_ADDRESS)
1567             // `msgSender == owner || msgSender == approvedAddress`.
1568             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1569         }
1570     }
1571 
1572     /**
1573      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1574      */
1575     function _getApprovedSlotAndAddress(uint256 tokenId)
1576         private
1577         view
1578         returns (uint256 approvedAddressSlot, address approvedAddress)
1579     {
1580         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1581         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1582         assembly {
1583             approvedAddressSlot := tokenApproval.slot
1584             approvedAddress := sload(approvedAddressSlot)
1585         }
1586     }
1587 
1588     // =============================================================
1589     //                      TRANSFER OPERATIONS
1590     // =============================================================
1591 
1592     /**
1593      * @dev Transfers `tokenId` from `from` to `to`.
1594      *
1595      * Requirements:
1596      *
1597      * - `from` cannot be the zero address.
1598      * - `to` cannot be the zero address.
1599      * - `tokenId` token must be owned by `from`.
1600      * - If the caller is not `from`, it must be approved to move this token
1601      * by either {approve} or {setApprovalForAll}.
1602      *
1603      * Emits a {Transfer} event.
1604      */
1605     function transferFrom(
1606         address from,
1607         address to,
1608         uint256 tokenId
1609     ) public payable virtual override {
1610         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1611 
1612         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1613 
1614         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1615 
1616         // The nested ifs save around 20+ gas over a compound boolean condition.
1617         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1618             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1619 
1620         if (to == address(0)) revert TransferToZeroAddress();
1621 
1622         _beforeTokenTransfers(from, to, tokenId, 1);
1623 
1624         // Clear approvals from the previous owner.
1625         assembly {
1626             if approvedAddress {
1627                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1628                 sstore(approvedAddressSlot, 0)
1629             }
1630         }
1631 
1632         // Underflow of the sender's balance is impossible because we check for
1633         // ownership above and the recipient's balance can't realistically overflow.
1634         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1635         unchecked {
1636             // We can directly increment and decrement the balances.
1637             --_packedAddressData[from]; // Updates: `balance -= 1`.
1638             ++_packedAddressData[to]; // Updates: `balance += 1`.
1639 
1640             // Updates:
1641             // - `address` to the next owner.
1642             // - `startTimestamp` to the timestamp of transfering.
1643             // - `burned` to `false`.
1644             // - `nextInitialized` to `true`.
1645             _packedOwnerships[tokenId] = _packOwnershipData(
1646                 to,
1647                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1648             );
1649 
1650             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1651             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1652                 uint256 nextTokenId = tokenId + 1;
1653                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1654                 if (_packedOwnerships[nextTokenId] == 0) {
1655                     // If the next slot is within bounds.
1656                     if (nextTokenId != _currentIndex) {
1657                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1658                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1659                     }
1660                 }
1661             }
1662         }
1663 
1664         emit Transfer(from, to, tokenId);
1665         _afterTokenTransfers(from, to, tokenId, 1);
1666     }
1667 
1668     /**
1669      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1670      */
1671     function safeTransferFrom(
1672         address from,
1673         address to,
1674         uint256 tokenId
1675     ) public payable virtual override {
1676         safeTransferFrom(from, to, tokenId, '');
1677     }
1678 
1679     /**
1680      * @dev Safely transfers `tokenId` token from `from` to `to`.
1681      *
1682      * Requirements:
1683      *
1684      * - `from` cannot be the zero address.
1685      * - `to` cannot be the zero address.
1686      * - `tokenId` token must exist and be owned by `from`.
1687      * - If the caller is not `from`, it must be approved to move this token
1688      * by either {approve} or {setApprovalForAll}.
1689      * - If `to` refers to a smart contract, it must implement
1690      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1691      *
1692      * Emits a {Transfer} event.
1693      */
1694     function safeTransferFrom(
1695         address from,
1696         address to,
1697         uint256 tokenId,
1698         bytes memory _data
1699     ) public payable virtual override {
1700         transferFrom(from, to, tokenId);
1701         if (to.code.length != 0)
1702             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1703                 revert TransferToNonERC721ReceiverImplementer();
1704             }
1705     }
1706 
1707     /**
1708      * @dev Hook that is called before a set of serially-ordered token IDs
1709      * are about to be transferred. This includes minting.
1710      * And also called before burning one token.
1711      *
1712      * `startTokenId` - the first token ID to be transferred.
1713      * `quantity` - the amount to be transferred.
1714      *
1715      * Calling conditions:
1716      *
1717      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1718      * transferred to `to`.
1719      * - When `from` is zero, `tokenId` will be minted for `to`.
1720      * - When `to` is zero, `tokenId` will be burned by `from`.
1721      * - `from` and `to` are never both zero.
1722      */
1723     function _beforeTokenTransfers(
1724         address from,
1725         address to,
1726         uint256 startTokenId,
1727         uint256 quantity
1728     ) internal virtual {}
1729 
1730     /**
1731      * @dev Hook that is called after a set of serially-ordered token IDs
1732      * have been transferred. This includes minting.
1733      * And also called after one token has been burned.
1734      *
1735      * `startTokenId` - the first token ID to be transferred.
1736      * `quantity` - the amount to be transferred.
1737      *
1738      * Calling conditions:
1739      *
1740      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1741      * transferred to `to`.
1742      * - When `from` is zero, `tokenId` has been minted for `to`.
1743      * - When `to` is zero, `tokenId` has been burned by `from`.
1744      * - `from` and `to` are never both zero.
1745      */
1746     function _afterTokenTransfers(
1747         address from,
1748         address to,
1749         uint256 startTokenId,
1750         uint256 quantity
1751     ) internal virtual {}
1752 
1753     /**
1754      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1755      *
1756      * `from` - Previous owner of the given token ID.
1757      * `to` - Target address that will receive the token.
1758      * `tokenId` - Token ID to be transferred.
1759      * `_data` - Optional data to send along with the call.
1760      *
1761      * Returns whether the call correctly returned the expected magic value.
1762      */
1763     function _checkContractOnERC721Received(
1764         address from,
1765         address to,
1766         uint256 tokenId,
1767         bytes memory _data
1768     ) private returns (bool) {
1769         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1770             bytes4 retval
1771         ) {
1772             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1773         } catch (bytes memory reason) {
1774             if (reason.length == 0) {
1775                 revert TransferToNonERC721ReceiverImplementer();
1776             } else {
1777                 assembly {
1778                     revert(add(32, reason), mload(reason))
1779                 }
1780             }
1781         }
1782     }
1783 
1784     // =============================================================
1785     //                        MINT OPERATIONS
1786     // =============================================================
1787 
1788     /**
1789      * @dev Mints `quantity` tokens and transfers them to `to`.
1790      *
1791      * Requirements:
1792      *
1793      * - `to` cannot be the zero address.
1794      * - `quantity` must be greater than 0.
1795      *
1796      * Emits a {Transfer} event for each mint.
1797      */
1798     function _mint(address to, uint256 quantity) internal virtual {
1799         uint256 startTokenId = _currentIndex;
1800         if (quantity == 0) revert MintZeroQuantity();
1801 
1802         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1803 
1804         // Overflows are incredibly unrealistic.
1805         // `balance` and `numberMinted` have a maximum limit of 2**64.
1806         // `tokenId` has a maximum limit of 2**256.
1807         unchecked {
1808             // Updates:
1809             // - `balance += quantity`.
1810             // - `numberMinted += quantity`.
1811             //
1812             // We can directly add to the `balance` and `numberMinted`.
1813             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1814 
1815             // Updates:
1816             // - `address` to the owner.
1817             // - `startTimestamp` to the timestamp of minting.
1818             // - `burned` to `false`.
1819             // - `nextInitialized` to `quantity == 1`.
1820             _packedOwnerships[startTokenId] = _packOwnershipData(
1821                 to,
1822                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1823             );
1824 
1825             uint256 toMasked;
1826             uint256 end = startTokenId + quantity;
1827 
1828             // Use assembly to loop and emit the `Transfer` event for gas savings.
1829             // The duplicated `log4` removes an extra check and reduces stack juggling.
1830             // The assembly, together with the surrounding Solidity code, have been
1831             // delicately arranged to nudge the compiler into producing optimized opcodes.
1832             assembly {
1833                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1834                 toMasked := and(to, _BITMASK_ADDRESS)
1835                 // Emit the `Transfer` event.
1836                 log4(
1837                     0, // Start of data (0, since no data).
1838                     0, // End of data (0, since no data).
1839                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1840                     0, // `address(0)`.
1841                     toMasked, // `to`.
1842                     startTokenId // `tokenId`.
1843                 )
1844 
1845                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1846                 // that overflows uint256 will make the loop run out of gas.
1847                 // The compiler will optimize the `iszero` away for performance.
1848                 for {
1849                     let tokenId := add(startTokenId, 1)
1850                 } iszero(eq(tokenId, end)) {
1851                     tokenId := add(tokenId, 1)
1852                 } {
1853                     // Emit the `Transfer` event. Similar to above.
1854                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1855                 }
1856             }
1857             if (toMasked == 0) revert MintToZeroAddress();
1858 
1859             _currentIndex = end;
1860         }
1861         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1862     }
1863 
1864     /**
1865      * @dev Mints `quantity` tokens and transfers them to `to`.
1866      *
1867      * This function is intended for efficient minting only during contract creation.
1868      *
1869      * It emits only one {ConsecutiveTransfer} as defined in
1870      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1871      * instead of a sequence of {Transfer} event(s).
1872      *
1873      * Calling this function outside of contract creation WILL make your contract
1874      * non-compliant with the ERC721 standard.
1875      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1876      * {ConsecutiveTransfer} event is only permissible during contract creation.
1877      *
1878      * Requirements:
1879      *
1880      * - `to` cannot be the zero address.
1881      * - `quantity` must be greater than 0.
1882      *
1883      * Emits a {ConsecutiveTransfer} event.
1884      */
1885     function _mintERC2309(address to, uint256 quantity) internal virtual {
1886         uint256 startTokenId = _currentIndex;
1887         if (to == address(0)) revert MintToZeroAddress();
1888         if (quantity == 0) revert MintZeroQuantity();
1889         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1890 
1891         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1892 
1893         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1894         unchecked {
1895             // Updates:
1896             // - `balance += quantity`.
1897             // - `numberMinted += quantity`.
1898             //
1899             // We can directly add to the `balance` and `numberMinted`.
1900             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1901 
1902             // Updates:
1903             // - `address` to the owner.
1904             // - `startTimestamp` to the timestamp of minting.
1905             // - `burned` to `false`.
1906             // - `nextInitialized` to `quantity == 1`.
1907             _packedOwnerships[startTokenId] = _packOwnershipData(
1908                 to,
1909                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1910             );
1911 
1912             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1913 
1914             _currentIndex = startTokenId + quantity;
1915         }
1916         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1917     }
1918 
1919     /**
1920      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1921      *
1922      * Requirements:
1923      *
1924      * - If `to` refers to a smart contract, it must implement
1925      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1926      * - `quantity` must be greater than 0.
1927      *
1928      * See {_mint}.
1929      *
1930      * Emits a {Transfer} event for each mint.
1931      */
1932     function _safeMint(
1933         address to,
1934         uint256 quantity,
1935         bytes memory _data
1936     ) internal virtual {
1937         _mint(to, quantity);
1938 
1939         unchecked {
1940             if (to.code.length != 0) {
1941                 uint256 end = _currentIndex;
1942                 uint256 index = end - quantity;
1943                 do {
1944                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1945                         revert TransferToNonERC721ReceiverImplementer();
1946                     }
1947                 } while (index < end);
1948                 // Reentrancy protection.
1949                 if (_currentIndex != end) revert();
1950             }
1951         }
1952     }
1953 
1954     /**
1955      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1956      */
1957     function _safeMint(address to, uint256 quantity) internal virtual {
1958         _safeMint(to, quantity, '');
1959     }
1960 
1961     // =============================================================
1962     //                        BURN OPERATIONS
1963     // =============================================================
1964 
1965     /**
1966      * @dev Equivalent to `_burn(tokenId, false)`.
1967      */
1968     function _burn(uint256 tokenId) internal virtual {
1969         _burn(tokenId, false);
1970     }
1971 
1972     /**
1973      * @dev Destroys `tokenId`.
1974      * The approval is cleared when the token is burned.
1975      *
1976      * Requirements:
1977      *
1978      * - `tokenId` must exist.
1979      *
1980      * Emits a {Transfer} event.
1981      */
1982     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1983         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1984 
1985         address from = address(uint160(prevOwnershipPacked));
1986 
1987         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1988 
1989         if (approvalCheck) {
1990             // The nested ifs save around 20+ gas over a compound boolean condition.
1991             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1992                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1993         }
1994 
1995         _beforeTokenTransfers(from, address(0), tokenId, 1);
1996 
1997         // Clear approvals from the previous owner.
1998         assembly {
1999             if approvedAddress {
2000                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2001                 sstore(approvedAddressSlot, 0)
2002             }
2003         }
2004 
2005         // Underflow of the sender's balance is impossible because we check for
2006         // ownership above and the recipient's balance can't realistically overflow.
2007         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2008         unchecked {
2009             // Updates:
2010             // - `balance -= 1`.
2011             // - `numberBurned += 1`.
2012             //
2013             // We can directly decrement the balance, and increment the number burned.
2014             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2015             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2016 
2017             // Updates:
2018             // - `address` to the last owner.
2019             // - `startTimestamp` to the timestamp of burning.
2020             // - `burned` to `true`.
2021             // - `nextInitialized` to `true`.
2022             _packedOwnerships[tokenId] = _packOwnershipData(
2023                 from,
2024                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2025             );
2026 
2027             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2028             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2029                 uint256 nextTokenId = tokenId + 1;
2030                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2031                 if (_packedOwnerships[nextTokenId] == 0) {
2032                     // If the next slot is within bounds.
2033                     if (nextTokenId != _currentIndex) {
2034                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2035                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2036                     }
2037                 }
2038             }
2039         }
2040 
2041         emit Transfer(from, address(0), tokenId);
2042         _afterTokenTransfers(from, address(0), tokenId, 1);
2043 
2044         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2045         unchecked {
2046             _burnCounter++;
2047         }
2048     }
2049 
2050     // =============================================================
2051     //                     EXTRA DATA OPERATIONS
2052     // =============================================================
2053 
2054     /**
2055      * @dev Directly sets the extra data for the ownership data `index`.
2056      */
2057     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2058         uint256 packed = _packedOwnerships[index];
2059         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2060         uint256 extraDataCasted;
2061         // Cast `extraData` with assembly to avoid redundant masking.
2062         assembly {
2063             extraDataCasted := extraData
2064         }
2065         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2066         _packedOwnerships[index] = packed;
2067     }
2068 
2069     /**
2070      * @dev Called during each token transfer to set the 24bit `extraData` field.
2071      * Intended to be overridden by the cosumer contract.
2072      *
2073      * `previousExtraData` - the value of `extraData` before transfer.
2074      *
2075      * Calling conditions:
2076      *
2077      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2078      * transferred to `to`.
2079      * - When `from` is zero, `tokenId` will be minted for `to`.
2080      * - When `to` is zero, `tokenId` will be burned by `from`.
2081      * - `from` and `to` are never both zero.
2082      */
2083     function _extraData(
2084         address from,
2085         address to,
2086         uint24 previousExtraData
2087     ) internal view virtual returns (uint24) {}
2088 
2089     /**
2090      * @dev Returns the next extra data for the packed ownership data.
2091      * The returned result is shifted into position.
2092      */
2093     function _nextExtraData(
2094         address from,
2095         address to,
2096         uint256 prevOwnershipPacked
2097     ) private view returns (uint256) {
2098         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2099         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2100     }
2101 
2102     // =============================================================
2103     //                       OTHER OPERATIONS
2104     // =============================================================
2105 
2106     /**
2107      * @dev Returns the message sender (defaults to `msg.sender`).
2108      *
2109      * If you are writing GSN compatible contracts, you need to override this function.
2110      */
2111     function _msgSenderERC721A() internal view virtual returns (address) {
2112         return msg.sender;
2113     }
2114 
2115     /**
2116      * @dev Converts a uint256 to its ASCII string decimal representation.
2117      */
2118     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2119         assembly {
2120             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2121             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2122             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2123             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2124             let m := add(mload(0x40), 0xa0)
2125             // Update the free memory pointer to allocate.
2126             mstore(0x40, m)
2127             // Assign the `str` to the end.
2128             str := sub(m, 0x20)
2129             // Zeroize the slot after the string.
2130             mstore(str, 0)
2131 
2132             // Cache the end of the memory to calculate the length later.
2133             let end := str
2134 
2135             // We write the string from rightmost digit to leftmost digit.
2136             // The following is essentially a do-while loop that also handles the zero case.
2137             // prettier-ignore
2138             for { let temp := value } 1 {} {
2139                 str := sub(str, 1)
2140                 // Write the character to the pointer.
2141                 // The ASCII index of the '0' character is 48.
2142                 mstore8(str, add(48, mod(temp, 10)))
2143                 // Keep dividing `temp` until zero.
2144                 temp := div(temp, 10)
2145                 // prettier-ignore
2146                 if iszero(temp) { break }
2147             }
2148 
2149             let length := sub(end, str)
2150             // Move the pointer 32 bytes leftwards to make room for the length.
2151             str := sub(str, 0x20)
2152             // Store the length.
2153             mstore(str, length)
2154         }
2155     }
2156 }
2157 
2158 // File: contracts/pixelville.sol
2159 
2160 
2161 
2162 pragma solidity ^0.8.17;
2163 
2164 
2165 
2166 
2167 
2168 contract PixelVille is ERC721A, DefaultOperatorFilterer, Ownable{
2169 
2170     using Strings for uint256;
2171     uint256 public constant MAX_SUPPLY = 3333;
2172     uint256 public mintPrice = 0.001 ether; 
2173     uint256 public maxBalance = 3; 
2174     uint256 public maxMint = 3; 
2175     bool public _isSaleActive = false; 
2176     bool public _revealed = false;
2177     string baseURI;
2178     string public notRevealedUri;
2179     string public baseExtension = ".json";
2180     mapping(uint256 => string) private _tokenURIs;
2181 
2182     constructor(string memory initBaseURI, string memory initNotRevealedUri) 
2183         ERC721A("PixelVille", "PV") 
2184     {
2185         setBaseURI(initBaseURI);
2186         setNotRevealedURI(initNotRevealedUri);
2187     }
2188 
2189     function mintPublic(uint256 tokenQuantity) public payable {
2190         require(_isSaleActive, "Sale must be active to mint NFT");
2191         require(tokenQuantity <= maxMint, "Mint too many tokens at a time");
2192         require(
2193             balanceOf(msg.sender)  + tokenQuantity <= maxBalance, 
2194             "Sale would exceed max balance"
2195         );
2196         require(
2197             totalSupply() + tokenQuantity <= MAX_SUPPLY,
2198             "Sale would exceed max supply"
2199         );
2200         require(tokenQuantity * mintPrice <= msg.value, "Not enough ether");
2201         _safeMint(msg.sender, tokenQuantity);
2202     }
2203 
2204     function tokenURI(uint256 tokenId)
2205         public
2206         view
2207         virtual
2208         override
2209         returns (string memory)
2210     {
2211         require(
2212             _exists(tokenId),
2213             "URI query for nonexistent token"
2214         );
2215 
2216         if (_revealed == false) {
2217             return notRevealedUri;
2218         }
2219 
2220         string memory _tokenURI = _tokenURIs[tokenId];
2221         string memory base = _baseURI();
2222 
2223         if (bytes(base).length == 0) {
2224             return _tokenURI;
2225         }
2226 
2227         if (bytes(_tokenURI).length > 0) {
2228             return string(abi.encodePacked(base, _tokenURI));
2229         }
2230 
2231         return
2232             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
2233     }
2234 
2235     function _baseURI() internal view virtual override returns (string memory) {
2236         return baseURI;
2237     }
2238 
2239     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2240         baseURI = _newBaseURI;
2241     }
2242 
2243     function flipSaleActive() public onlyOwner {
2244         _isSaleActive = !_isSaleActive;
2245     }
2246 
2247     function flipReveal() public onlyOwner {
2248         _revealed = !_revealed;
2249     }
2250 
2251     function mintOwner() public onlyOwner {
2252         _safeMint(msg.sender, 1);
2253     }
2254 
2255     function setMintPrice(uint256 _mintPrice) public onlyOwner {
2256         mintPrice = _mintPrice;
2257     }
2258 
2259     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2260         notRevealedUri = _notRevealedURI;
2261     }
2262 
2263     function setBaseExtension(string memory _newBaseExtension)
2264         public
2265         onlyOwner
2266     {
2267         baseExtension = _newBaseExtension;
2268     }
2269 
2270     function setMaxBalance(uint256 _maxBalance) public onlyOwner {
2271         maxBalance = _maxBalance;
2272     }
2273 
2274     function setMaxMint(uint256 _maxMint) public onlyOwner {
2275         maxMint = _maxMint;
2276     }
2277 
2278     function withdraw(address to) public onlyOwner {
2279         uint256 balance = address(this).balance;
2280         payable(to).transfer(balance);
2281     }
2282 
2283     //Override some methods based on opensea new policy
2284     
2285     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2286         super.setApprovalForAll(operator, approved);
2287     }
2288 
2289     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2290         super.approve(operator, tokenId);
2291     }
2292 
2293     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2294         super.transferFrom(from, to, tokenId);
2295     }
2296 
2297     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2298         super.safeTransferFrom(from, to, tokenId);
2299     }
2300 
2301     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2302       public payable
2303       override
2304       onlyAllowedOperator(from)
2305     {
2306        super.safeTransferFrom(from, to, tokenId, data);
2307     }
2308 
2309 }