1 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.13;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
10 
11 
12 pragma solidity ^0.8.13;
13 
14 interface IOperatorFilterRegistry {
15     /**
16      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
17      *         true if supplied registrant address is not registered.
18      */
19     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
20 
21     /**
22      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
23      */
24     function register(address registrant) external;
25 
26     /**
27      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
28      */
29     function registerAndSubscribe(address registrant, address subscription) external;
30 
31     /**
32      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
33      *         address without subscribing.
34      */
35     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
36 
37     /**
38      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
39      *         Note that this does not remove any filtered addresses or codeHashes.
40      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
41      */
42     function unregister(address addr) external;
43 
44     /**
45      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
46      */
47     function updateOperator(address registrant, address operator, bool filtered) external;
48 
49     /**
50      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
51      */
52     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
53 
54     /**
55      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
56      */
57     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
58 
59     /**
60      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
61      */
62     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
63 
64     /**
65      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
66      *         subscription if present.
67      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
68      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
69      *         used.
70      */
71     function subscribe(address registrant, address registrantToSubscribe) external;
72 
73     /**
74      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
75      */
76     function unsubscribe(address registrant, bool copyExistingEntries) external;
77 
78     /**
79      * @notice Get the subscription address of a given registrant, if any.
80      */
81     function subscriptionOf(address addr) external returns (address registrant);
82 
83     /**
84      * @notice Get the set of addresses subscribed to a given registrant.
85      *         Note that order is not guaranteed as updates are made.
86      */
87     function subscribers(address registrant) external returns (address[] memory);
88 
89     /**
90      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
91      *         Note that order is not guaranteed as updates are made.
92      */
93     function subscriberAt(address registrant, uint256 index) external returns (address);
94 
95     /**
96      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
97      */
98     function copyEntriesOf(address registrant, address registrantToCopy) external;
99 
100     /**
101      * @notice Returns true if operator is filtered by a given address or its subscription.
102      */
103     function isOperatorFiltered(address registrant, address operator) external returns (bool);
104 
105     /**
106      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
107      */
108     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
109 
110     /**
111      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
112      */
113     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
114 
115     /**
116      * @notice Returns a list of filtered operators for a given address or its subscription.
117      */
118     function filteredOperators(address addr) external returns (address[] memory);
119 
120     /**
121      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
122      *         Note that order is not guaranteed as updates are made.
123      */
124     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
125 
126     /**
127      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
128      *         its subscription.
129      *         Note that order is not guaranteed as updates are made.
130      */
131     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
132 
133     /**
134      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
135      *         its subscription.
136      *         Note that order is not guaranteed as updates are made.
137      */
138     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
139 
140     /**
141      * @notice Returns true if an address has registered
142      */
143     function isRegistered(address addr) external returns (bool);
144 
145     /**
146      * @dev Convenience method to compute the code hash of an arbitrary contract
147      */
148     function codeHashOf(address addr) external returns (bytes32);
149 }
150 
151 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
152 
153 
154 pragma solidity ^0.8.13;
155 
156 
157 /**
158  * @title  OperatorFilterer
159  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
160  *         registrant's entries in the OperatorFilterRegistry.
161  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
162  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
163  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
164  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
165  *         administration methods on the contract itself to interact with the registry otherwise the subscription
166  *         will be locked to the options set during construction.
167  */
168 
169 abstract contract OperatorFilterer {
170     /// @dev Emitted when an operator is not allowed.
171     error OperatorNotAllowed(address operator);
172 
173     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
174         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
175 
176     /// @dev The constructor that is called when the contract is being deployed.
177     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
178         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
179         // will not revert, but the contract will need to be registered with the registry once it is deployed in
180         // order for the modifier to filter addresses.
181         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
182             if (subscribe) {
183                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
184             } else {
185                 if (subscriptionOrRegistrantToCopy != address(0)) {
186                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
187                 } else {
188                     OPERATOR_FILTER_REGISTRY.register(address(this));
189                 }
190             }
191         }
192     }
193 
194     /**
195      * @dev A helper function to check if an operator is allowed.
196      */
197     modifier onlyAllowedOperator(address from) virtual {
198         // Allow spending tokens from addresses with balance
199         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
200         // from an EOA.
201         if (from != msg.sender) {
202             _checkFilterOperator(msg.sender);
203         }
204         _;
205     }
206 
207     /**
208      * @dev A helper function to check if an operator approval is allowed.
209      */
210     modifier onlyAllowedOperatorApproval(address operator) virtual {
211         _checkFilterOperator(operator);
212         _;
213     }
214 
215     /**
216      * @dev A helper function to check if an operator is allowed.
217      */
218     function _checkFilterOperator(address operator) internal view virtual {
219         // Check registry code length to facilitate testing in environments without a deployed registry.
220         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
221             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
222             // may specify their own OperatorFilterRegistry implementations, which may behave differently
223             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
224                 revert OperatorNotAllowed(operator);
225             }
226         }
227     }
228 }
229 
230 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
231 
232 
233 pragma solidity ^0.8.13;
234 
235 
236 /**
237  * @title  DefaultOperatorFilterer
238  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
239  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
240  *         administration methods on the contract itself to interact with the registry otherwise the subscription
241  *         will be locked to the options set during construction.
242  */
243 
244 abstract contract DefaultOperatorFilterer is OperatorFilterer {
245     /// @dev The constructor that is called when the contract is being deployed.
246     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
247 }
248 
249 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SignedMath.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Standard signed math utilities missing in the Solidity language.
258  */
259 library SignedMath {
260     /**
261      * @dev Returns the largest of two signed numbers.
262      */
263     function max(int256 a, int256 b) internal pure returns (int256) {
264         return a > b ? a : b;
265     }
266 
267     /**
268      * @dev Returns the smallest of two signed numbers.
269      */
270     function min(int256 a, int256 b) internal pure returns (int256) {
271         return a < b ? a : b;
272     }
273 
274     /**
275      * @dev Returns the average of two signed numbers without overflow.
276      * The result is rounded towards zero.
277      */
278     function average(int256 a, int256 b) internal pure returns (int256) {
279         // Formula from the book "Hacker's Delight"
280         int256 x = (a & b) + ((a ^ b) >> 1);
281         return x + (int256(uint256(x) >> 255) & (a ^ b));
282     }
283 
284     /**
285      * @dev Returns the absolute unsigned value of a signed value.
286      */
287     function abs(int256 n) internal pure returns (uint256) {
288         unchecked {
289             // must be unchecked in order to support `n = type(int256).min`
290             return uint256(n >= 0 ? n : -n);
291         }
292     }
293 }
294 
295 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/Math.sol
296 
297 
298 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
299 
300 pragma solidity ^0.8.0;
301 
302 /**
303  * @dev Standard math utilities missing in the Solidity language.
304  */
305 library Math {
306     enum Rounding {
307         Down, // Toward negative infinity
308         Up, // Toward infinity
309         Zero // Toward zero
310     }
311 
312     /**
313      * @dev Returns the largest of two numbers.
314      */
315     function max(uint256 a, uint256 b) internal pure returns (uint256) {
316         return a > b ? a : b;
317     }
318 
319     /**
320      * @dev Returns the smallest of two numbers.
321      */
322     function min(uint256 a, uint256 b) internal pure returns (uint256) {
323         return a < b ? a : b;
324     }
325 
326     /**
327      * @dev Returns the average of two numbers. The result is rounded towards
328      * zero.
329      */
330     function average(uint256 a, uint256 b) internal pure returns (uint256) {
331         // (a + b) / 2 can overflow.
332         return (a & b) + (a ^ b) / 2;
333     }
334 
335     /**
336      * @dev Returns the ceiling of the division of two numbers.
337      *
338      * This differs from standard division with `/` in that it rounds up instead
339      * of rounding down.
340      */
341     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
342         // (a + b - 1) / b can overflow on addition, so we distribute.
343         return a == 0 ? 0 : (a - 1) / b + 1;
344     }
345 
346     /**
347      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
348      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
349      * with further edits by Uniswap Labs also under MIT license.
350      */
351     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
352         unchecked {
353             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
354             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
355             // variables such that product = prod1 * 2^256 + prod0.
356             uint256 prod0; // Least significant 256 bits of the product
357             uint256 prod1; // Most significant 256 bits of the product
358             assembly {
359                 let mm := mulmod(x, y, not(0))
360                 prod0 := mul(x, y)
361                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
362             }
363 
364             // Handle non-overflow cases, 256 by 256 division.
365             if (prod1 == 0) {
366                 return prod0 / denominator;
367             }
368 
369             // Make sure the result is less than 2^256. Also prevents denominator == 0.
370             require(denominator > prod1, "Math: mulDiv overflow");
371 
372             ///////////////////////////////////////////////
373             // 512 by 256 division.
374             ///////////////////////////////////////////////
375 
376             // Make division exact by subtracting the remainder from [prod1 prod0].
377             uint256 remainder;
378             assembly {
379                 // Compute remainder using mulmod.
380                 remainder := mulmod(x, y, denominator)
381 
382                 // Subtract 256 bit number from 512 bit number.
383                 prod1 := sub(prod1, gt(remainder, prod0))
384                 prod0 := sub(prod0, remainder)
385             }
386 
387             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
388             // See https://cs.stackexchange.com/q/138556/92363.
389 
390             // Does not overflow because the denominator cannot be zero at this stage in the function.
391             uint256 twos = denominator & (~denominator + 1);
392             assembly {
393                 // Divide denominator by twos.
394                 denominator := div(denominator, twos)
395 
396                 // Divide [prod1 prod0] by twos.
397                 prod0 := div(prod0, twos)
398 
399                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
400                 twos := add(div(sub(0, twos), twos), 1)
401             }
402 
403             // Shift in bits from prod1 into prod0.
404             prod0 |= prod1 * twos;
405 
406             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
407             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
408             // four bits. That is, denominator * inv = 1 mod 2^4.
409             uint256 inverse = (3 * denominator) ^ 2;
410 
411             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
412             // in modular arithmetic, doubling the correct bits in each step.
413             inverse *= 2 - denominator * inverse; // inverse mod 2^8
414             inverse *= 2 - denominator * inverse; // inverse mod 2^16
415             inverse *= 2 - denominator * inverse; // inverse mod 2^32
416             inverse *= 2 - denominator * inverse; // inverse mod 2^64
417             inverse *= 2 - denominator * inverse; // inverse mod 2^128
418             inverse *= 2 - denominator * inverse; // inverse mod 2^256
419 
420             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
421             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
422             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
423             // is no longer required.
424             result = prod0 * inverse;
425             return result;
426         }
427     }
428 
429     /**
430      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
431      */
432     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
433         uint256 result = mulDiv(x, y, denominator);
434         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
435             result += 1;
436         }
437         return result;
438     }
439 
440     /**
441      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
442      *
443      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
444      */
445     function sqrt(uint256 a) internal pure returns (uint256) {
446         if (a == 0) {
447             return 0;
448         }
449 
450         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
451         //
452         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
453         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
454         //
455         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
456         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
457         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
458         //
459         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
460         uint256 result = 1 << (log2(a) >> 1);
461 
462         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
463         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
464         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
465         // into the expected uint128 result.
466         unchecked {
467             result = (result + a / result) >> 1;
468             result = (result + a / result) >> 1;
469             result = (result + a / result) >> 1;
470             result = (result + a / result) >> 1;
471             result = (result + a / result) >> 1;
472             result = (result + a / result) >> 1;
473             result = (result + a / result) >> 1;
474             return min(result, a / result);
475         }
476     }
477 
478     /**
479      * @notice Calculates sqrt(a), following the selected rounding direction.
480      */
481     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
482         unchecked {
483             uint256 result = sqrt(a);
484             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
485         }
486     }
487 
488     /**
489      * @dev Return the log in base 2, rounded down, of a positive value.
490      * Returns 0 if given 0.
491      */
492     function log2(uint256 value) internal pure returns (uint256) {
493         uint256 result = 0;
494         unchecked {
495             if (value >> 128 > 0) {
496                 value >>= 128;
497                 result += 128;
498             }
499             if (value >> 64 > 0) {
500                 value >>= 64;
501                 result += 64;
502             }
503             if (value >> 32 > 0) {
504                 value >>= 32;
505                 result += 32;
506             }
507             if (value >> 16 > 0) {
508                 value >>= 16;
509                 result += 16;
510             }
511             if (value >> 8 > 0) {
512                 value >>= 8;
513                 result += 8;
514             }
515             if (value >> 4 > 0) {
516                 value >>= 4;
517                 result += 4;
518             }
519             if (value >> 2 > 0) {
520                 value >>= 2;
521                 result += 2;
522             }
523             if (value >> 1 > 0) {
524                 result += 1;
525             }
526         }
527         return result;
528     }
529 
530     /**
531      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
532      * Returns 0 if given 0.
533      */
534     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
535         unchecked {
536             uint256 result = log2(value);
537             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
538         }
539     }
540 
541     /**
542      * @dev Return the log in base 10, rounded down, of a positive value.
543      * Returns 0 if given 0.
544      */
545     function log10(uint256 value) internal pure returns (uint256) {
546         uint256 result = 0;
547         unchecked {
548             if (value >= 10 ** 64) {
549                 value /= 10 ** 64;
550                 result += 64;
551             }
552             if (value >= 10 ** 32) {
553                 value /= 10 ** 32;
554                 result += 32;
555             }
556             if (value >= 10 ** 16) {
557                 value /= 10 ** 16;
558                 result += 16;
559             }
560             if (value >= 10 ** 8) {
561                 value /= 10 ** 8;
562                 result += 8;
563             }
564             if (value >= 10 ** 4) {
565                 value /= 10 ** 4;
566                 result += 4;
567             }
568             if (value >= 10 ** 2) {
569                 value /= 10 ** 2;
570                 result += 2;
571             }
572             if (value >= 10 ** 1) {
573                 result += 1;
574             }
575         }
576         return result;
577     }
578 
579     /**
580      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
581      * Returns 0 if given 0.
582      */
583     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
584         unchecked {
585             uint256 result = log10(value);
586             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
587         }
588     }
589 
590     /**
591      * @dev Return the log in base 256, rounded down, of a positive value.
592      * Returns 0 if given 0.
593      *
594      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
595      */
596     function log256(uint256 value) internal pure returns (uint256) {
597         uint256 result = 0;
598         unchecked {
599             if (value >> 128 > 0) {
600                 value >>= 128;
601                 result += 16;
602             }
603             if (value >> 64 > 0) {
604                 value >>= 64;
605                 result += 8;
606             }
607             if (value >> 32 > 0) {
608                 value >>= 32;
609                 result += 4;
610             }
611             if (value >> 16 > 0) {
612                 value >>= 16;
613                 result += 2;
614             }
615             if (value >> 8 > 0) {
616                 result += 1;
617             }
618         }
619         return result;
620     }
621 
622     /**
623      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
624      * Returns 0 if given 0.
625      */
626     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
627         unchecked {
628             uint256 result = log256(value);
629             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
630         }
631     }
632 }
633 
634 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
635 
636 
637 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
638 
639 pragma solidity ^0.8.0;
640 
641 
642 
643 /**
644  * @dev String operations.
645  */
646 library Strings {
647     bytes16 private constant _SYMBOLS = "0123456789abcdef";
648     uint8 private constant _ADDRESS_LENGTH = 20;
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
652      */
653     function toString(uint256 value) internal pure returns (string memory) {
654         unchecked {
655             uint256 length = Math.log10(value) + 1;
656             string memory buffer = new string(length);
657             uint256 ptr;
658             /// @solidity memory-safe-assembly
659             assembly {
660                 ptr := add(buffer, add(32, length))
661             }
662             while (true) {
663                 ptr--;
664                 /// @solidity memory-safe-assembly
665                 assembly {
666                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
667                 }
668                 value /= 10;
669                 if (value == 0) break;
670             }
671             return buffer;
672         }
673     }
674 
675     /**
676      * @dev Converts a `int256` to its ASCII `string` decimal representation.
677      */
678     function toString(int256 value) internal pure returns (string memory) {
679         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
680     }
681 
682     /**
683      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
684      */
685     function toHexString(uint256 value) internal pure returns (string memory) {
686         unchecked {
687             return toHexString(value, Math.log256(value) + 1);
688         }
689     }
690 
691     /**
692      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
693      */
694     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
695         bytes memory buffer = new bytes(2 * length + 2);
696         buffer[0] = "0";
697         buffer[1] = "x";
698         for (uint256 i = 2 * length + 1; i > 1; --i) {
699             buffer[i] = _SYMBOLS[value & 0xf];
700             value >>= 4;
701         }
702         require(value == 0, "Strings: hex length insufficient");
703         return string(buffer);
704     }
705 
706     /**
707      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
708      */
709     function toHexString(address addr) internal pure returns (string memory) {
710         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
711     }
712 
713     /**
714      * @dev Returns true if the two strings are equal.
715      */
716     function equal(string memory a, string memory b) internal pure returns (bool) {
717         return keccak256(bytes(a)) == keccak256(bytes(b));
718     }
719 }
720 
721 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
722 
723 
724 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 /**
729  * @dev Contract module that helps prevent reentrant calls to a function.
730  *
731  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
732  * available, which can be applied to functions to make sure there are no nested
733  * (reentrant) calls to them.
734  *
735  * Note that because there is a single `nonReentrant` guard, functions marked as
736  * `nonReentrant` may not call one another. This can be worked around by making
737  * those functions `private`, and then adding `external` `nonReentrant` entry
738  * points to them.
739  *
740  * TIP: If you would like to learn more about reentrancy and alternative ways
741  * to protect against it, check out our blog post
742  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
743  */
744 abstract contract ReentrancyGuard {
745     // Booleans are more expensive than uint256 or any type that takes up a full
746     // word because each write operation emits an extra SLOAD to first read the
747     // slot's contents, replace the bits taken up by the boolean, and then write
748     // back. This is the compiler's defense against contract upgrades and
749     // pointer aliasing, and it cannot be disabled.
750 
751     // The values being non-zero value makes deployment a bit more expensive,
752     // but in exchange the refund on every call to nonReentrant will be lower in
753     // amount. Since refunds are capped to a percentage of the total
754     // transaction's gas, it is best to keep them low in cases like this one, to
755     // increase the likelihood of the full refund coming into effect.
756     uint256 private constant _NOT_ENTERED = 1;
757     uint256 private constant _ENTERED = 2;
758 
759     uint256 private _status;
760 
761     constructor() {
762         _status = _NOT_ENTERED;
763     }
764 
765     /**
766      * @dev Prevents a contract from calling itself, directly or indirectly.
767      * Calling a `nonReentrant` function from another `nonReentrant`
768      * function is not supported. It is possible to prevent this from happening
769      * by making the `nonReentrant` function external, and making it call a
770      * `private` function that does the actual work.
771      */
772     modifier nonReentrant() {
773         _nonReentrantBefore();
774         _;
775         _nonReentrantAfter();
776     }
777 
778     function _nonReentrantBefore() private {
779         // On the first call to nonReentrant, _status will be _NOT_ENTERED
780         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
781 
782         // Any calls to nonReentrant after this point will fail
783         _status = _ENTERED;
784     }
785 
786     function _nonReentrantAfter() private {
787         // By storing the original value once again, a refund is triggered (see
788         // https://eips.ethereum.org/EIPS/eip-2200)
789         _status = _NOT_ENTERED;
790     }
791 
792     /**
793      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
794      * `nonReentrant` function in the call stack.
795      */
796     function _reentrancyGuardEntered() internal view returns (bool) {
797         return _status == _ENTERED;
798     }
799 }
800 
801 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
802 
803 
804 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
805 
806 pragma solidity ^0.8.0;
807 
808 /**
809  * @dev Provides information about the current execution context, including the
810  * sender of the transaction and its data. While these are generally available
811  * via msg.sender and msg.data, they should not be accessed in such a direct
812  * manner, since when dealing with meta-transactions the account sending and
813  * paying for execution may not be the actual sender (as far as an application
814  * is concerned).
815  *
816  * This contract is only required for intermediate, library-like contracts.
817  */
818 abstract contract Context {
819     function _msgSender() internal view virtual returns (address) {
820         return msg.sender;
821     }
822 
823     function _msgData() internal view virtual returns (bytes calldata) {
824         return msg.data;
825     }
826 }
827 
828 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
829 
830 
831 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
832 
833 pragma solidity ^0.8.0;
834 
835 
836 /**
837  * @dev Contract module which provides a basic access control mechanism, where
838  * there is an account (an owner) that can be granted exclusive access to
839  * specific functions.
840  *
841  * By default, the owner account will be the one that deploys the contract. This
842  * can later be changed with {transferOwnership}.
843  *
844  * This module is used through inheritance. It will make available the modifier
845  * `onlyOwner`, which can be applied to your functions to restrict their use to
846  * the owner.
847  */
848 abstract contract Ownable is Context {
849     address private _owner;
850 
851     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
852 
853     /**
854      * @dev Initializes the contract setting the deployer as the initial owner.
855      */
856     constructor() {
857         _transferOwnership(_msgSender());
858     }
859 
860     /**
861      * @dev Throws if called by any account other than the owner.
862      */
863     modifier onlyOwner() {
864         _checkOwner();
865         _;
866     }
867 
868     /**
869      * @dev Returns the address of the current owner.
870      */
871     function owner() public view virtual returns (address) {
872         return _owner;
873     }
874 
875     /**
876      * @dev Throws if the sender is not the owner.
877      */
878     function _checkOwner() internal view virtual {
879         require(owner() == _msgSender(), "Ownable: caller is not the owner");
880     }
881 
882     /**
883      * @dev Leaves the contract without owner. It will not be possible to call
884      * `onlyOwner` functions anymore. Can only be called by the current owner.
885      *
886      * NOTE: Renouncing ownership will leave the contract without an owner,
887      * thereby removing any functionality that is only available to the owner.
888      */
889     function renounceOwnership() public virtual onlyOwner {
890         _transferOwnership(address(0));
891     }
892 
893     /**
894      * @dev Transfers ownership of the contract to a new account (`newOwner`).
895      * Can only be called by the current owner.
896      */
897     function transferOwnership(address newOwner) public virtual onlyOwner {
898         require(newOwner != address(0), "Ownable: new owner is the zero address");
899         _transferOwnership(newOwner);
900     }
901 
902     /**
903      * @dev Transfers ownership of the contract to a new account (`newOwner`).
904      * Internal function without access restriction.
905      */
906     function _transferOwnership(address newOwner) internal virtual {
907         address oldOwner = _owner;
908         _owner = newOwner;
909         emit OwnershipTransferred(oldOwner, newOwner);
910     }
911 }
912 
913 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
914 
915 
916 // ERC721A Contracts v4.2.3
917 // Creator: Chiru Labs
918 
919 pragma solidity ^0.8.4;
920 
921 /**
922  * @dev Interface of ERC721A.
923  */
924 interface IERC721A {
925     /**
926      * The caller must own the token or be an approved operator.
927      */
928     error ApprovalCallerNotOwnerNorApproved();
929 
930     /**
931      * The token does not exist.
932      */
933     error ApprovalQueryForNonexistentToken();
934 
935     /**
936      * Cannot query the balance for the zero address.
937      */
938     error BalanceQueryForZeroAddress();
939 
940     /**
941      * Cannot mint to the zero address.
942      */
943     error MintToZeroAddress();
944 
945     /**
946      * The quantity of tokens minted must be more than zero.
947      */
948     error MintZeroQuantity();
949 
950     /**
951      * The token does not exist.
952      */
953     error OwnerQueryForNonexistentToken();
954 
955     /**
956      * The caller must own the token or be an approved operator.
957      */
958     error TransferCallerNotOwnerNorApproved();
959 
960     /**
961      * The token must be owned by `from`.
962      */
963     error TransferFromIncorrectOwner();
964 
965     /**
966      * Cannot safely transfer to a contract that does not implement the
967      * ERC721Receiver interface.
968      */
969     error TransferToNonERC721ReceiverImplementer();
970 
971     /**
972      * Cannot transfer to the zero address.
973      */
974     error TransferToZeroAddress();
975 
976     /**
977      * The token does not exist.
978      */
979     error URIQueryForNonexistentToken();
980 
981     /**
982      * The `quantity` minted with ERC2309 exceeds the safety limit.
983      */
984     error MintERC2309QuantityExceedsLimit();
985 
986     /**
987      * The `extraData` cannot be set on an unintialized ownership slot.
988      */
989     error OwnershipNotInitializedForExtraData();
990 
991     // =============================================================
992     //                            STRUCTS
993     // =============================================================
994 
995     struct TokenOwnership {
996         // The address of the owner.
997         address addr;
998         // Stores the start time of ownership with minimal overhead for tokenomics.
999         uint64 startTimestamp;
1000         // Whether the token has been burned.
1001         bool burned;
1002         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1003         uint24 extraData;
1004     }
1005 
1006     // =============================================================
1007     //                         TOKEN COUNTERS
1008     // =============================================================
1009 
1010     /**
1011      * @dev Returns the total number of tokens in existence.
1012      * Burned tokens will reduce the count.
1013      * To get the total number of tokens minted, please see {_totalMinted}.
1014      */
1015     function totalSupply() external view returns (uint256);
1016 
1017     // =============================================================
1018     //                            IERC165
1019     // =============================================================
1020 
1021     /**
1022      * @dev Returns true if this contract implements the interface defined by
1023      * `interfaceId`. See the corresponding
1024      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1025      * to learn more about how these ids are created.
1026      *
1027      * This function call must use less than 30000 gas.
1028      */
1029     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1030 
1031     // =============================================================
1032     //                            IERC721
1033     // =============================================================
1034 
1035     /**
1036      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1037      */
1038     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1039 
1040     /**
1041      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1042      */
1043     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1044 
1045     /**
1046      * @dev Emitted when `owner` enables or disables
1047      * (`approved`) `operator` to manage all of its assets.
1048      */
1049     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1050 
1051     /**
1052      * @dev Returns the number of tokens in `owner`'s account.
1053      */
1054     function balanceOf(address owner) external view returns (uint256 balance);
1055 
1056     /**
1057      * @dev Returns the owner of the `tokenId` token.
1058      *
1059      * Requirements:
1060      *
1061      * - `tokenId` must exist.
1062      */
1063     function ownerOf(uint256 tokenId) external view returns (address owner);
1064 
1065     /**
1066      * @dev Safely transfers `tokenId` token from `from` to `to`,
1067      * checking first that contract recipients are aware of the ERC721 protocol
1068      * to prevent tokens from being forever locked.
1069      *
1070      * Requirements:
1071      *
1072      * - `from` cannot be the zero address.
1073      * - `to` cannot be the zero address.
1074      * - `tokenId` token must exist and be owned by `from`.
1075      * - If the caller is not `from`, it must be have been allowed to move
1076      * this token by either {approve} or {setApprovalForAll}.
1077      * - If `to` refers to a smart contract, it must implement
1078      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1079      *
1080      * Emits a {Transfer} event.
1081      */
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 tokenId,
1086         bytes calldata data
1087     ) external payable;
1088 
1089     /**
1090      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1091      */
1092     function safeTransferFrom(
1093         address from,
1094         address to,
1095         uint256 tokenId
1096     ) external payable;
1097 
1098     /**
1099      * @dev Transfers `tokenId` from `from` to `to`.
1100      *
1101      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1102      * whenever possible.
1103      *
1104      * Requirements:
1105      *
1106      * - `from` cannot be the zero address.
1107      * - `to` cannot be the zero address.
1108      * - `tokenId` token must be owned by `from`.
1109      * - If the caller is not `from`, it must be approved to move this token
1110      * by either {approve} or {setApprovalForAll}.
1111      *
1112      * Emits a {Transfer} event.
1113      */
1114     function transferFrom(
1115         address from,
1116         address to,
1117         uint256 tokenId
1118     ) external payable;
1119 
1120     /**
1121      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1122      * The approval is cleared when the token is transferred.
1123      *
1124      * Only a single account can be approved at a time, so approving the
1125      * zero address clears previous approvals.
1126      *
1127      * Requirements:
1128      *
1129      * - The caller must own the token or be an approved operator.
1130      * - `tokenId` must exist.
1131      *
1132      * Emits an {Approval} event.
1133      */
1134     function approve(address to, uint256 tokenId) external payable;
1135 
1136     /**
1137      * @dev Approve or remove `operator` as an operator for the caller.
1138      * Operators can call {transferFrom} or {safeTransferFrom}
1139      * for any token owned by the caller.
1140      *
1141      * Requirements:
1142      *
1143      * - The `operator` cannot be the caller.
1144      *
1145      * Emits an {ApprovalForAll} event.
1146      */
1147     function setApprovalForAll(address operator, bool _approved) external;
1148 
1149     /**
1150      * @dev Returns the account approved for `tokenId` token.
1151      *
1152      * Requirements:
1153      *
1154      * - `tokenId` must exist.
1155      */
1156     function getApproved(uint256 tokenId) external view returns (address operator);
1157 
1158     /**
1159      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1160      *
1161      * See {setApprovalForAll}.
1162      */
1163     function isApprovedForAll(address owner, address operator) external view returns (bool);
1164 
1165     // =============================================================
1166     //                        IERC721Metadata
1167     // =============================================================
1168 
1169     /**
1170      * @dev Returns the token collection name.
1171      */
1172     function name() external view returns (string memory);
1173 
1174     /**
1175      * @dev Returns the token collection symbol.
1176      */
1177     function symbol() external view returns (string memory);
1178 
1179     /**
1180      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1181      */
1182     function tokenURI(uint256 tokenId) external view returns (string memory);
1183 
1184     // =============================================================
1185     //                           IERC2309
1186     // =============================================================
1187 
1188     /**
1189      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1190      * (inclusive) is transferred from `from` to `to`, as defined in the
1191      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1192      *
1193      * See {_mintERC2309} for more details.
1194      */
1195     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1196 }
1197 
1198 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1199 
1200 
1201 // ERC721A Contracts v4.2.3
1202 // Creator: Chiru Labs
1203 
1204 pragma solidity ^0.8.4;
1205 
1206 
1207 /**
1208  * @dev Interface of ERC721 token receiver.
1209  */
1210 interface ERC721A__IERC721Receiver {
1211     function onERC721Received(
1212         address operator,
1213         address from,
1214         uint256 tokenId,
1215         bytes calldata data
1216     ) external returns (bytes4);
1217 }
1218 
1219 /**
1220  * @title ERC721A
1221  *
1222  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1223  * Non-Fungible Token Standard, including the Metadata extension.
1224  * Optimized for lower gas during batch mints.
1225  *
1226  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1227  * starting from `_startTokenId()`.
1228  *
1229  * Assumptions:
1230  *
1231  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1232  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1233  */
1234 contract ERC721A is IERC721A {
1235     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1236     struct TokenApprovalRef {
1237         address value;
1238     }
1239 
1240     // =============================================================
1241     //                           CONSTANTS
1242     // =============================================================
1243 
1244     // Mask of an entry in packed address data.
1245     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1246 
1247     // The bit position of `numberMinted` in packed address data.
1248     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1249 
1250     // The bit position of `numberBurned` in packed address data.
1251     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1252 
1253     // The bit position of `aux` in packed address data.
1254     uint256 private constant _BITPOS_AUX = 192;
1255 
1256     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1257     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1258 
1259     // The bit position of `startTimestamp` in packed ownership.
1260     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1261 
1262     // The bit mask of the `burned` bit in packed ownership.
1263     uint256 private constant _BITMASK_BURNED = 1 << 224;
1264 
1265     // The bit position of the `nextInitialized` bit in packed ownership.
1266     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1267 
1268     // The bit mask of the `nextInitialized` bit in packed ownership.
1269     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1270 
1271     // The bit position of `extraData` in packed ownership.
1272     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1273 
1274     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1275     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1276 
1277     // The mask of the lower 160 bits for addresses.
1278     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1279 
1280     // The maximum `quantity` that can be minted with {_mintERC2309}.
1281     // This limit is to prevent overflows on the address data entries.
1282     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1283     // is required to cause an overflow, which is unrealistic.
1284     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1285 
1286     // The `Transfer` event signature is given by:
1287     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1288     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1289         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1290 
1291     // =============================================================
1292     //                            STORAGE
1293     // =============================================================
1294 
1295     // The next token ID to be minted.
1296     uint256 private _currentIndex;
1297 
1298     // The number of tokens burned.
1299     uint256 private _burnCounter;
1300 
1301     // Token name
1302     string private _name;
1303 
1304     // Token symbol
1305     string private _symbol;
1306 
1307     // Mapping from token ID to ownership details
1308     // An empty struct value does not necessarily mean the token is unowned.
1309     // See {_packedOwnershipOf} implementation for details.
1310     //
1311     // Bits Layout:
1312     // - [0..159]   `addr`
1313     // - [160..223] `startTimestamp`
1314     // - [224]      `burned`
1315     // - [225]      `nextInitialized`
1316     // - [232..255] `extraData`
1317     mapping(uint256 => uint256) private _packedOwnerships;
1318 
1319     // Mapping owner address to address data.
1320     //
1321     // Bits Layout:
1322     // - [0..63]    `balance`
1323     // - [64..127]  `numberMinted`
1324     // - [128..191] `numberBurned`
1325     // - [192..255] `aux`
1326     mapping(address => uint256) private _packedAddressData;
1327 
1328     // Mapping from token ID to approved address.
1329     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1330 
1331     // Mapping from owner to operator approvals
1332     mapping(address => mapping(address => bool)) private _operatorApprovals;
1333 
1334     // =============================================================
1335     //                          CONSTRUCTOR
1336     // =============================================================
1337 
1338     constructor(string memory name_, string memory symbol_) {
1339         _name = name_;
1340         _symbol = symbol_;
1341         _currentIndex = _startTokenId();
1342     }
1343 
1344     // =============================================================
1345     //                   TOKEN COUNTING OPERATIONS
1346     // =============================================================
1347 
1348     /**
1349      * @dev Returns the starting token ID.
1350      * To change the starting token ID, please override this function.
1351      */
1352     function _startTokenId() internal view virtual returns (uint256) {
1353         return 0;
1354     }
1355 
1356     /**
1357      * @dev Returns the next token ID to be minted.
1358      */
1359     function _nextTokenId() internal view virtual returns (uint256) {
1360         return _currentIndex;
1361     }
1362 
1363     /**
1364      * @dev Returns the total number of tokens in existence.
1365      * Burned tokens will reduce the count.
1366      * To get the total number of tokens minted, please see {_totalMinted}.
1367      */
1368     function totalSupply() public view virtual override returns (uint256) {
1369         // Counter underflow is impossible as _burnCounter cannot be incremented
1370         // more than `_currentIndex - _startTokenId()` times.
1371         unchecked {
1372             return _currentIndex - _burnCounter - _startTokenId();
1373         }
1374     }
1375 
1376     /**
1377      * @dev Returns the total amount of tokens minted in the contract.
1378      */
1379     function _totalMinted() internal view virtual returns (uint256) {
1380         // Counter underflow is impossible as `_currentIndex` does not decrement,
1381         // and it is initialized to `_startTokenId()`.
1382         unchecked {
1383             return _currentIndex - _startTokenId();
1384         }
1385     }
1386 
1387     /**
1388      * @dev Returns the total number of tokens burned.
1389      */
1390     function _totalBurned() internal view virtual returns (uint256) {
1391         return _burnCounter;
1392     }
1393 
1394     // =============================================================
1395     //                    ADDRESS DATA OPERATIONS
1396     // =============================================================
1397 
1398     /**
1399      * @dev Returns the number of tokens in `owner`'s account.
1400      */
1401     function balanceOf(address owner) public view virtual override returns (uint256) {
1402         if (owner == address(0)) _revert(BalanceQueryForZeroAddress.selector);
1403         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1404     }
1405 
1406     /**
1407      * Returns the number of tokens minted by `owner`.
1408      */
1409     function _numberMinted(address owner) internal view returns (uint256) {
1410         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1411     }
1412 
1413     /**
1414      * Returns the number of tokens burned by or on behalf of `owner`.
1415      */
1416     function _numberBurned(address owner) internal view returns (uint256) {
1417         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1418     }
1419 
1420     /**
1421      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1422      */
1423     function _getAux(address owner) internal view returns (uint64) {
1424         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1425     }
1426 
1427     /**
1428      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1429      * If there are multiple variables, please pack them into a uint64.
1430      */
1431     function _setAux(address owner, uint64 aux) internal virtual {
1432         uint256 packed = _packedAddressData[owner];
1433         uint256 auxCasted;
1434         // Cast `aux` with assembly to avoid redundant masking.
1435         assembly {
1436             auxCasted := aux
1437         }
1438         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1439         _packedAddressData[owner] = packed;
1440     }
1441 
1442     // =============================================================
1443     //                            IERC165
1444     // =============================================================
1445 
1446     /**
1447      * @dev Returns true if this contract implements the interface defined by
1448      * `interfaceId`. See the corresponding
1449      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1450      * to learn more about how these ids are created.
1451      *
1452      * This function call must use less than 30000 gas.
1453      */
1454     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1455         // The interface IDs are constants representing the first 4 bytes
1456         // of the XOR of all function selectors in the interface.
1457         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1458         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1459         return
1460             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1461             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1462             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1463     }
1464 
1465     // =============================================================
1466     //                        IERC721Metadata
1467     // =============================================================
1468 
1469     /**
1470      * @dev Returns the token collection name.
1471      */
1472     function name() public view virtual override returns (string memory) {
1473         return _name;
1474     }
1475 
1476     /**
1477      * @dev Returns the token collection symbol.
1478      */
1479     function symbol() public view virtual override returns (string memory) {
1480         return _symbol;
1481     }
1482 
1483     /**
1484      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1485      */
1486     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1487         if (!_exists(tokenId)) _revert(URIQueryForNonexistentToken.selector);
1488 
1489         string memory baseURI = _baseURI();
1490         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1491     }
1492 
1493     /**
1494      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1495      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1496      * by default, it can be overridden in child contracts.
1497      */
1498     function _baseURI() internal view virtual returns (string memory) {
1499         return '';
1500     }
1501 
1502     // =============================================================
1503     //                     OWNERSHIPS OPERATIONS
1504     // =============================================================
1505 
1506     /**
1507      * @dev Returns the owner of the `tokenId` token.
1508      *
1509      * Requirements:
1510      *
1511      * - `tokenId` must exist.
1512      */
1513     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1514         return address(uint160(_packedOwnershipOf(tokenId)));
1515     }
1516 
1517     /**
1518      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1519      * It gradually moves to O(1) as tokens get transferred around over time.
1520      */
1521     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1522         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1523     }
1524 
1525     /**
1526      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1527      */
1528     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1529         return _unpackedOwnership(_packedOwnerships[index]);
1530     }
1531 
1532     /**
1533      * @dev Returns whether the ownership slot at `index` is initialized.
1534      * An uninitialized slot does not necessarily mean that the slot has no owner.
1535      */
1536     function _ownershipIsInitialized(uint256 index) internal view virtual returns (bool) {
1537         return _packedOwnerships[index] != 0;
1538     }
1539 
1540     /**
1541      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1542      */
1543     function _initializeOwnershipAt(uint256 index) internal virtual {
1544         if (_packedOwnerships[index] == 0) {
1545             _packedOwnerships[index] = _packedOwnershipOf(index);
1546         }
1547     }
1548 
1549     /**
1550      * Returns the packed ownership data of `tokenId`.
1551      */
1552     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
1553         if (_startTokenId() <= tokenId) {
1554             packed = _packedOwnerships[tokenId];
1555             // If the data at the starting slot does not exist, start the scan.
1556             if (packed == 0) {
1557                 if (tokenId >= _currentIndex) _revert(OwnerQueryForNonexistentToken.selector);
1558                 // Invariant:
1559                 // There will always be an initialized ownership slot
1560                 // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1561                 // before an unintialized ownership slot
1562                 // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1563                 // Hence, `tokenId` will not underflow.
1564                 //
1565                 // We can directly compare the packed value.
1566                 // If the address is zero, packed will be zero.
1567                 for (;;) {
1568                     unchecked {
1569                         packed = _packedOwnerships[--tokenId];
1570                     }
1571                     if (packed == 0) continue;
1572                     if (packed & _BITMASK_BURNED == 0) return packed;
1573                     // Otherwise, the token is burned, and we must revert.
1574                     // This handles the case of batch burned tokens, where only the burned bit
1575                     // of the starting slot is set, and remaining slots are left uninitialized.
1576                     _revert(OwnerQueryForNonexistentToken.selector);
1577                 }
1578             }
1579             // Otherwise, the data exists and we can skip the scan.
1580             // This is possible because we have already achieved the target condition.
1581             // This saves 2143 gas on transfers of initialized tokens.
1582             // If the token is not burned, return `packed`. Otherwise, revert.
1583             if (packed & _BITMASK_BURNED == 0) return packed;
1584         }
1585         _revert(OwnerQueryForNonexistentToken.selector);
1586     }
1587 
1588     /**
1589      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1590      */
1591     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1592         ownership.addr = address(uint160(packed));
1593         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1594         ownership.burned = packed & _BITMASK_BURNED != 0;
1595         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1596     }
1597 
1598     /**
1599      * @dev Packs ownership data into a single uint256.
1600      */
1601     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1602         assembly {
1603             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1604             owner := and(owner, _BITMASK_ADDRESS)
1605             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1606             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1607         }
1608     }
1609 
1610     /**
1611      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1612      */
1613     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1614         // For branchless setting of the `nextInitialized` flag.
1615         assembly {
1616             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1617             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1618         }
1619     }
1620 
1621     // =============================================================
1622     //                      APPROVAL OPERATIONS
1623     // =============================================================
1624 
1625     /**
1626      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
1627      *
1628      * Requirements:
1629      *
1630      * - The caller must own the token or be an approved operator.
1631      */
1632     function approve(address to, uint256 tokenId) public payable virtual override {
1633         _approve(to, tokenId, true);
1634     }
1635 
1636     /**
1637      * @dev Returns the account approved for `tokenId` token.
1638      *
1639      * Requirements:
1640      *
1641      * - `tokenId` must exist.
1642      */
1643     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1644         if (!_exists(tokenId)) _revert(ApprovalQueryForNonexistentToken.selector);
1645 
1646         return _tokenApprovals[tokenId].value;
1647     }
1648 
1649     /**
1650      * @dev Approve or remove `operator` as an operator for the caller.
1651      * Operators can call {transferFrom} or {safeTransferFrom}
1652      * for any token owned by the caller.
1653      *
1654      * Requirements:
1655      *
1656      * - The `operator` cannot be the caller.
1657      *
1658      * Emits an {ApprovalForAll} event.
1659      */
1660     function setApprovalForAll(address operator, bool approved) public virtual override {
1661         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1662         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1663     }
1664 
1665     /**
1666      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1667      *
1668      * See {setApprovalForAll}.
1669      */
1670     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1671         return _operatorApprovals[owner][operator];
1672     }
1673 
1674     /**
1675      * @dev Returns whether `tokenId` exists.
1676      *
1677      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1678      *
1679      * Tokens start existing when they are minted. See {_mint}.
1680      */
1681     function _exists(uint256 tokenId) internal view virtual returns (bool result) {
1682         if (_startTokenId() <= tokenId) {
1683             if (tokenId < _currentIndex) {
1684                 uint256 packed;
1685                 while ((packed = _packedOwnerships[tokenId]) == 0) --tokenId;
1686                 result = packed & _BITMASK_BURNED == 0;
1687             }
1688         }
1689     }
1690 
1691     /**
1692      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1693      */
1694     function _isSenderApprovedOrOwner(
1695         address approvedAddress,
1696         address owner,
1697         address msgSender
1698     ) private pure returns (bool result) {
1699         assembly {
1700             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1701             owner := and(owner, _BITMASK_ADDRESS)
1702             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1703             msgSender := and(msgSender, _BITMASK_ADDRESS)
1704             // `msgSender == owner || msgSender == approvedAddress`.
1705             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1706         }
1707     }
1708 
1709     /**
1710      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1711      */
1712     function _getApprovedSlotAndAddress(uint256 tokenId)
1713         private
1714         view
1715         returns (uint256 approvedAddressSlot, address approvedAddress)
1716     {
1717         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1718         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1719         assembly {
1720             approvedAddressSlot := tokenApproval.slot
1721             approvedAddress := sload(approvedAddressSlot)
1722         }
1723     }
1724 
1725     // =============================================================
1726     //                      TRANSFER OPERATIONS
1727     // =============================================================
1728 
1729     /**
1730      * @dev Transfers `tokenId` from `from` to `to`.
1731      *
1732      * Requirements:
1733      *
1734      * - `from` cannot be the zero address.
1735      * - `to` cannot be the zero address.
1736      * - `tokenId` token must be owned by `from`.
1737      * - If the caller is not `from`, it must be approved to move this token
1738      * by either {approve} or {setApprovalForAll}.
1739      *
1740      * Emits a {Transfer} event.
1741      */
1742     function transferFrom(
1743         address from,
1744         address to,
1745         uint256 tokenId
1746     ) public payable virtual override {
1747         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1748 
1749         // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1750         from = address(uint160(uint256(uint160(from)) & _BITMASK_ADDRESS));
1751 
1752         if (address(uint160(prevOwnershipPacked)) != from) _revert(TransferFromIncorrectOwner.selector);
1753 
1754         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1755 
1756         // The nested ifs save around 20+ gas over a compound boolean condition.
1757         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1758             if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
1759 
1760         _beforeTokenTransfers(from, to, tokenId, 1);
1761 
1762         // Clear approvals from the previous owner.
1763         assembly {
1764             if approvedAddress {
1765                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1766                 sstore(approvedAddressSlot, 0)
1767             }
1768         }
1769 
1770         // Underflow of the sender's balance is impossible because we check for
1771         // ownership above and the recipient's balance can't realistically overflow.
1772         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1773         unchecked {
1774             // We can directly increment and decrement the balances.
1775             --_packedAddressData[from]; // Updates: `balance -= 1`.
1776             ++_packedAddressData[to]; // Updates: `balance += 1`.
1777 
1778             // Updates:
1779             // - `address` to the next owner.
1780             // - `startTimestamp` to the timestamp of transfering.
1781             // - `burned` to `false`.
1782             // - `nextInitialized` to `true`.
1783             _packedOwnerships[tokenId] = _packOwnershipData(
1784                 to,
1785                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1786             );
1787 
1788             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1789             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1790                 uint256 nextTokenId = tokenId + 1;
1791                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1792                 if (_packedOwnerships[nextTokenId] == 0) {
1793                     // If the next slot is within bounds.
1794                     if (nextTokenId != _currentIndex) {
1795                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1796                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1797                     }
1798                 }
1799             }
1800         }
1801 
1802         // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1803         uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1804         assembly {
1805             // Emit the `Transfer` event.
1806             log4(
1807                 0, // Start of data (0, since no data).
1808                 0, // End of data (0, since no data).
1809                 _TRANSFER_EVENT_SIGNATURE, // Signature.
1810                 from, // `from`.
1811                 toMasked, // `to`.
1812                 tokenId // `tokenId`.
1813             )
1814         }
1815         if (toMasked == 0) _revert(TransferToZeroAddress.selector);
1816 
1817         _afterTokenTransfers(from, to, tokenId, 1);
1818     }
1819 
1820     /**
1821      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1822      */
1823     function safeTransferFrom(
1824         address from,
1825         address to,
1826         uint256 tokenId
1827     ) public payable virtual override {
1828         safeTransferFrom(from, to, tokenId, '');
1829     }
1830 
1831     /**
1832      * @dev Safely transfers `tokenId` token from `from` to `to`.
1833      *
1834      * Requirements:
1835      *
1836      * - `from` cannot be the zero address.
1837      * - `to` cannot be the zero address.
1838      * - `tokenId` token must exist and be owned by `from`.
1839      * - If the caller is not `from`, it must be approved to move this token
1840      * by either {approve} or {setApprovalForAll}.
1841      * - If `to` refers to a smart contract, it must implement
1842      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1843      *
1844      * Emits a {Transfer} event.
1845      */
1846     function safeTransferFrom(
1847         address from,
1848         address to,
1849         uint256 tokenId,
1850         bytes memory _data
1851     ) public payable virtual override {
1852         transferFrom(from, to, tokenId);
1853         if (to.code.length != 0)
1854             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1855                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1856             }
1857     }
1858 
1859     /**
1860      * @dev Hook that is called before a set of serially-ordered token IDs
1861      * are about to be transferred. This includes minting.
1862      * And also called before burning one token.
1863      *
1864      * `startTokenId` - the first token ID to be transferred.
1865      * `quantity` - the amount to be transferred.
1866      *
1867      * Calling conditions:
1868      *
1869      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1870      * transferred to `to`.
1871      * - When `from` is zero, `tokenId` will be minted for `to`.
1872      * - When `to` is zero, `tokenId` will be burned by `from`.
1873      * - `from` and `to` are never both zero.
1874      */
1875     function _beforeTokenTransfers(
1876         address from,
1877         address to,
1878         uint256 startTokenId,
1879         uint256 quantity
1880     ) internal virtual {}
1881 
1882     /**
1883      * @dev Hook that is called after a set of serially-ordered token IDs
1884      * have been transferred. This includes minting.
1885      * And also called after one token has been burned.
1886      *
1887      * `startTokenId` - the first token ID to be transferred.
1888      * `quantity` - the amount to be transferred.
1889      *
1890      * Calling conditions:
1891      *
1892      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1893      * transferred to `to`.
1894      * - When `from` is zero, `tokenId` has been minted for `to`.
1895      * - When `to` is zero, `tokenId` has been burned by `from`.
1896      * - `from` and `to` are never both zero.
1897      */
1898     function _afterTokenTransfers(
1899         address from,
1900         address to,
1901         uint256 startTokenId,
1902         uint256 quantity
1903     ) internal virtual {}
1904 
1905     /**
1906      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1907      *
1908      * `from` - Previous owner of the given token ID.
1909      * `to` - Target address that will receive the token.
1910      * `tokenId` - Token ID to be transferred.
1911      * `_data` - Optional data to send along with the call.
1912      *
1913      * Returns whether the call correctly returned the expected magic value.
1914      */
1915     function _checkContractOnERC721Received(
1916         address from,
1917         address to,
1918         uint256 tokenId,
1919         bytes memory _data
1920     ) private returns (bool) {
1921         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1922             bytes4 retval
1923         ) {
1924             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1925         } catch (bytes memory reason) {
1926             if (reason.length == 0) {
1927                 _revert(TransferToNonERC721ReceiverImplementer.selector);
1928             }
1929             assembly {
1930                 revert(add(32, reason), mload(reason))
1931             }
1932         }
1933     }
1934 
1935     // =============================================================
1936     //                        MINT OPERATIONS
1937     // =============================================================
1938 
1939     /**
1940      * @dev Mints `quantity` tokens and transfers them to `to`.
1941      *
1942      * Requirements:
1943      *
1944      * - `to` cannot be the zero address.
1945      * - `quantity` must be greater than 0.
1946      *
1947      * Emits a {Transfer} event for each mint.
1948      */
1949     function _mint(address to, uint256 quantity) internal virtual {
1950         uint256 startTokenId = _currentIndex;
1951         if (quantity == 0) _revert(MintZeroQuantity.selector);
1952 
1953         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1954 
1955         // Overflows are incredibly unrealistic.
1956         // `balance` and `numberMinted` have a maximum limit of 2**64.
1957         // `tokenId` has a maximum limit of 2**256.
1958         unchecked {
1959             // Updates:
1960             // - `address` to the owner.
1961             // - `startTimestamp` to the timestamp of minting.
1962             // - `burned` to `false`.
1963             // - `nextInitialized` to `quantity == 1`.
1964             _packedOwnerships[startTokenId] = _packOwnershipData(
1965                 to,
1966                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1967             );
1968 
1969             // Updates:
1970             // - `balance += quantity`.
1971             // - `numberMinted += quantity`.
1972             //
1973             // We can directly add to the `balance` and `numberMinted`.
1974             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1975 
1976             // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1977             uint256 toMasked = uint256(uint160(to)) & _BITMASK_ADDRESS;
1978 
1979             if (toMasked == 0) _revert(MintToZeroAddress.selector);
1980 
1981             uint256 end = startTokenId + quantity;
1982             uint256 tokenId = startTokenId;
1983 
1984             do {
1985                 assembly {
1986                     // Emit the `Transfer` event.
1987                     log4(
1988                         0, // Start of data (0, since no data).
1989                         0, // End of data (0, since no data).
1990                         _TRANSFER_EVENT_SIGNATURE, // Signature.
1991                         0, // `address(0)`.
1992                         toMasked, // `to`.
1993                         tokenId // `tokenId`.
1994                     )
1995                 }
1996                 // The `!=` check ensures that large values of `quantity`
1997                 // that overflows uint256 will make the loop run out of gas.
1998             } while (++tokenId != end);
1999 
2000             _currentIndex = end;
2001         }
2002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2003     }
2004 
2005     /**
2006      * @dev Mints `quantity` tokens and transfers them to `to`.
2007      *
2008      * This function is intended for efficient minting only during contract creation.
2009      *
2010      * It emits only one {ConsecutiveTransfer} as defined in
2011      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2012      * instead of a sequence of {Transfer} event(s).
2013      *
2014      * Calling this function outside of contract creation WILL make your contract
2015      * non-compliant with the ERC721 standard.
2016      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2017      * {ConsecutiveTransfer} event is only permissible during contract creation.
2018      *
2019      * Requirements:
2020      *
2021      * - `to` cannot be the zero address.
2022      * - `quantity` must be greater than 0.
2023      *
2024      * Emits a {ConsecutiveTransfer} event.
2025      */
2026     function _mintERC2309(address to, uint256 quantity) internal virtual {
2027         uint256 startTokenId = _currentIndex;
2028         if (to == address(0)) _revert(MintToZeroAddress.selector);
2029         if (quantity == 0) _revert(MintZeroQuantity.selector);
2030         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) _revert(MintERC2309QuantityExceedsLimit.selector);
2031 
2032         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2033 
2034         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2035         unchecked {
2036             // Updates:
2037             // - `balance += quantity`.
2038             // - `numberMinted += quantity`.
2039             //
2040             // We can directly add to the `balance` and `numberMinted`.
2041             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2042 
2043             // Updates:
2044             // - `address` to the owner.
2045             // - `startTimestamp` to the timestamp of minting.
2046             // - `burned` to `false`.
2047             // - `nextInitialized` to `quantity == 1`.
2048             _packedOwnerships[startTokenId] = _packOwnershipData(
2049                 to,
2050                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2051             );
2052 
2053             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2054 
2055             _currentIndex = startTokenId + quantity;
2056         }
2057         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2058     }
2059 
2060     /**
2061      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2062      *
2063      * Requirements:
2064      *
2065      * - If `to` refers to a smart contract, it must implement
2066      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2067      * - `quantity` must be greater than 0.
2068      *
2069      * See {_mint}.
2070      *
2071      * Emits a {Transfer} event for each mint.
2072      */
2073     function _safeMint(
2074         address to,
2075         uint256 quantity,
2076         bytes memory _data
2077     ) internal virtual {
2078         _mint(to, quantity);
2079 
2080         unchecked {
2081             if (to.code.length != 0) {
2082                 uint256 end = _currentIndex;
2083                 uint256 index = end - quantity;
2084                 do {
2085                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2086                         _revert(TransferToNonERC721ReceiverImplementer.selector);
2087                     }
2088                 } while (index < end);
2089                 // Reentrancy protection.
2090                 if (_currentIndex != end) _revert(bytes4(0));
2091             }
2092         }
2093     }
2094 
2095     /**
2096      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2097      */
2098     function _safeMint(address to, uint256 quantity) internal virtual {
2099         _safeMint(to, quantity, '');
2100     }
2101 
2102     // =============================================================
2103     //                       APPROVAL OPERATIONS
2104     // =============================================================
2105 
2106     /**
2107      * @dev Equivalent to `_approve(to, tokenId, false)`.
2108      */
2109     function _approve(address to, uint256 tokenId) internal virtual {
2110         _approve(to, tokenId, false);
2111     }
2112 
2113     /**
2114      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2115      * The approval is cleared when the token is transferred.
2116      *
2117      * Only a single account can be approved at a time, so approving the
2118      * zero address clears previous approvals.
2119      *
2120      * Requirements:
2121      *
2122      * - `tokenId` must exist.
2123      *
2124      * Emits an {Approval} event.
2125      */
2126     function _approve(
2127         address to,
2128         uint256 tokenId,
2129         bool approvalCheck
2130     ) internal virtual {
2131         address owner = ownerOf(tokenId);
2132 
2133         if (approvalCheck && _msgSenderERC721A() != owner)
2134             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2135                 _revert(ApprovalCallerNotOwnerNorApproved.selector);
2136             }
2137 
2138         _tokenApprovals[tokenId].value = to;
2139         emit Approval(owner, to, tokenId);
2140     }
2141 
2142     // =============================================================
2143     //                        BURN OPERATIONS
2144     // =============================================================
2145 
2146     /**
2147      * @dev Equivalent to `_burn(tokenId, false)`.
2148      */
2149     function _burn(uint256 tokenId) internal virtual {
2150         _burn(tokenId, false);
2151     }
2152 
2153     /**
2154      * @dev Destroys `tokenId`.
2155      * The approval is cleared when the token is burned.
2156      *
2157      * Requirements:
2158      *
2159      * - `tokenId` must exist.
2160      *
2161      * Emits a {Transfer} event.
2162      */
2163     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2164         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2165 
2166         address from = address(uint160(prevOwnershipPacked));
2167 
2168         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2169 
2170         if (approvalCheck) {
2171             // The nested ifs save around 20+ gas over a compound boolean condition.
2172             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2173                 if (!isApprovedForAll(from, _msgSenderERC721A())) _revert(TransferCallerNotOwnerNorApproved.selector);
2174         }
2175 
2176         _beforeTokenTransfers(from, address(0), tokenId, 1);
2177 
2178         // Clear approvals from the previous owner.
2179         assembly {
2180             if approvedAddress {
2181                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2182                 sstore(approvedAddressSlot, 0)
2183             }
2184         }
2185 
2186         // Underflow of the sender's balance is impossible because we check for
2187         // ownership above and the recipient's balance can't realistically overflow.
2188         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2189         unchecked {
2190             // Updates:
2191             // - `balance -= 1`.
2192             // - `numberBurned += 1`.
2193             //
2194             // We can directly decrement the balance, and increment the number burned.
2195             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2196             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2197 
2198             // Updates:
2199             // - `address` to the last owner.
2200             // - `startTimestamp` to the timestamp of burning.
2201             // - `burned` to `true`.
2202             // - `nextInitialized` to `true`.
2203             _packedOwnerships[tokenId] = _packOwnershipData(
2204                 from,
2205                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2206             );
2207 
2208             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2209             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2210                 uint256 nextTokenId = tokenId + 1;
2211                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2212                 if (_packedOwnerships[nextTokenId] == 0) {
2213                     // If the next slot is within bounds.
2214                     if (nextTokenId != _currentIndex) {
2215                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2216                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2217                     }
2218                 }
2219             }
2220         }
2221 
2222         emit Transfer(from, address(0), tokenId);
2223         _afterTokenTransfers(from, address(0), tokenId, 1);
2224 
2225         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2226         unchecked {
2227             _burnCounter++;
2228         }
2229     }
2230 
2231     // =============================================================
2232     //                     EXTRA DATA OPERATIONS
2233     // =============================================================
2234 
2235     /**
2236      * @dev Directly sets the extra data for the ownership data `index`.
2237      */
2238     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2239         uint256 packed = _packedOwnerships[index];
2240         if (packed == 0) _revert(OwnershipNotInitializedForExtraData.selector);
2241         uint256 extraDataCasted;
2242         // Cast `extraData` with assembly to avoid redundant masking.
2243         assembly {
2244             extraDataCasted := extraData
2245         }
2246         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2247         _packedOwnerships[index] = packed;
2248     }
2249 
2250     /**
2251      * @dev Called during each token transfer to set the 24bit `extraData` field.
2252      * Intended to be overridden by the cosumer contract.
2253      *
2254      * `previousExtraData` - the value of `extraData` before transfer.
2255      *
2256      * Calling conditions:
2257      *
2258      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2259      * transferred to `to`.
2260      * - When `from` is zero, `tokenId` will be minted for `to`.
2261      * - When `to` is zero, `tokenId` will be burned by `from`.
2262      * - `from` and `to` are never both zero.
2263      */
2264     function _extraData(
2265         address from,
2266         address to,
2267         uint24 previousExtraData
2268     ) internal view virtual returns (uint24) {}
2269 
2270     /**
2271      * @dev Returns the next extra data for the packed ownership data.
2272      * The returned result is shifted into position.
2273      */
2274     function _nextExtraData(
2275         address from,
2276         address to,
2277         uint256 prevOwnershipPacked
2278     ) private view returns (uint256) {
2279         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2280         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2281     }
2282 
2283     // =============================================================
2284     //                       OTHER OPERATIONS
2285     // =============================================================
2286 
2287     /**
2288      * @dev Returns the message sender (defaults to `msg.sender`).
2289      *
2290      * If you are writing GSN compatible contracts, you need to override this function.
2291      */
2292     function _msgSenderERC721A() internal view virtual returns (address) {
2293         return msg.sender;
2294     }
2295 
2296     /**
2297      * @dev Converts a uint256 to its ASCII string decimal representation.
2298      */
2299     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2300         assembly {
2301             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2302             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2303             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2304             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2305             let m := add(mload(0x40), 0xa0)
2306             // Update the free memory pointer to allocate.
2307             mstore(0x40, m)
2308             // Assign the `str` to the end.
2309             str := sub(m, 0x20)
2310             // Zeroize the slot after the string.
2311             mstore(str, 0)
2312 
2313             // Cache the end of the memory to calculate the length later.
2314             let end := str
2315 
2316             // We write the string from rightmost digit to leftmost digit.
2317             // The following is essentially a do-while loop that also handles the zero case.
2318             // prettier-ignore
2319             for { let temp := value } 1 {} {
2320                 str := sub(str, 1)
2321                 // Write the character to the pointer.
2322                 // The ASCII index of the '0' character is 48.
2323                 mstore8(str, add(48, mod(temp, 10)))
2324                 // Keep dividing `temp` until zero.
2325                 temp := div(temp, 10)
2326                 // prettier-ignore
2327                 if iszero(temp) { break }
2328             }
2329 
2330             let length := sub(end, str)
2331             // Move the pointer 32 bytes leftwards to make room for the length.
2332             str := sub(str, 0x20)
2333             // Store the length.
2334             mstore(str, length)
2335         }
2336     }
2337 
2338     /**
2339      * @dev For more efficient reverts.
2340      */
2341     function _revert(bytes4 errorSelector) internal pure {
2342         assembly {
2343             mstore(0x00, errorSelector)
2344             revert(0x00, 0x04)
2345         }
2346     }
2347 }
2348 
2349 // File: contracts/Misfit Club.sol
2350 
2351 
2352 
2353 pragma solidity >=0.8.9 <0.9.0;
2354 
2355 
2356 
2357 
2358 
2359 
2360 contract MisfitClub is ERC721A, Ownable, DefaultOperatorFilterer, ReentrancyGuard {
2361   using Strings for uint256;
2362   
2363   uint256 public cost = 0.005 ether;
2364   uint256 public maxSupplys = 2200;
2365   uint256 public txnMax = 10;
2366   uint256 public maxFreeMintEach = 2;
2367   uint256 public maxMintAmount = 10;
2368 
2369   string public uriPrefix = 'https://bafybeicd6p6ez6fojtbjfuiiuabs7fh3u6uhtvehbcetggpjkgebg2e3pq.ipfs.nftstorage.link/';
2370   string public uriSuffix = '.json';
2371   string public hiddenMetadataUri = ""; 
2372   bool public revealed = true;
2373   bool public paused = false;
2374 
2375 
2376   constructor(
2377   ) ERC721A("Misfit Club", "MC") {
2378   }
2379 
2380   modifier SupplyCompliance(uint256 _mintAmount) {
2381     require(!paused, "sale has not started.");
2382     require(tx.origin == msg.sender, "no bots are allowed.");
2383     require(_mintAmount > 0 && _mintAmount <= txnMax, "Maximum of 10  per txn!");
2384     require(totalSupply() + _mintAmount <= maxSupplys, "No Supplys lefts!");
2385     require(
2386       _mintAmount > 0 && numberMinted(msg.sender) + _mintAmount <= maxMintAmount,
2387        "You may have minted max number !"
2388     );
2389     _;
2390   }
2391 
2392   modifier SupplyPriceCompliance(uint256 _mintAmount) {
2393     uint256 realCost = 0;
2394     
2395     if (numberMinted(msg.sender) < maxFreeMintEach) {
2396       uint256 freeMintsLeft = maxFreeMintEach - numberMinted(msg.sender);
2397       realCost = cost * freeMintsLeft;
2398     }
2399    
2400     require(msg.value >= cost * _mintAmount - realCost, "Insufficient/incorrect funds.");
2401     _;
2402   }
2403 
2404   function mint(uint256 _mintAmount) public payable SupplyCompliance(_mintAmount) SupplyPriceCompliance(_mintAmount) {
2405     _safeMint(_msgSender(), _mintAmount);
2406   }
2407   
2408   function mintForAddress(uint256 _mintAmount, address _receiver) public onlyOwner {
2409     require(totalSupply() + _mintAmount <= maxSupplys, "Max supply exceeded!");
2410     _safeMint(_receiver, _mintAmount);
2411   }
2412 
2413   function _startTokenId() internal view virtual override returns (uint256) {
2414     return 1;
2415   }
2416 
2417   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2418     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
2419 
2420     if (revealed == false) {
2421       return hiddenMetadataUri;
2422     }
2423 
2424     string memory currentBaseURI = _baseURI();
2425     return bytes(currentBaseURI).length > 0
2426         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2427         : '';
2428   }
2429 
2430   function setCost(uint256 _cost) public onlyOwner {
2431     cost = _cost;
2432   }
2433 
2434   function setmaxFreeMintEach(uint256 _maxFreeMintEach) public onlyOwner {
2435     maxFreeMintEach = _maxFreeMintEach;
2436   }
2437 
2438   function setRevealed(bool _state) public onlyOwner {
2439     revealed = _state;
2440   }
2441 
2442    function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2443     hiddenMetadataUri = _hiddenMetadataUri;
2444   }
2445 
2446   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2447     uriPrefix = _uriPrefix;
2448   }
2449 
2450   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2451     uriSuffix = _uriSuffix;
2452   }
2453 
2454   function setPaused(bool _state) public onlyOwner {
2455     paused = _state;
2456   }
2457 
2458   function setMaxSupplys(uint256 _maxSupplys) public onlyOwner {
2459     maxSupplys = _maxSupplys;
2460   }
2461 
2462   function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
2463     maxMintAmount = _maxMintAmount;
2464   }
2465 
2466   function withdraw() public onlyOwner nonReentrant {
2467     (bool withdrawFunds, ) = payable(owner()).call{value: address(this).balance}("");
2468     require(withdrawFunds);
2469   }
2470 
2471   function numberMinted(address owner) public view returns (uint256) {
2472     return _numberMinted(owner);
2473   }
2474 
2475   function _baseURI() internal view virtual override returns (string memory) {
2476     return uriPrefix;
2477   }
2478 
2479   function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2480     super.setApprovalForAll(operator, approved);
2481   }
2482 }