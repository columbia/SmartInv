1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.17;
5 
6 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
7 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
8 
9 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
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
151 // File: operator-filter-registry/src/OperatorFilterer.sol
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
230 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
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
249 // File: @openzeppelin/contracts/utils/math/Math.sol
250 
251 
252 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
253 
254 pragma solidity ^0.8.0;
255 
256 /**
257  * @dev Standard math utilities missing in the Solidity language.
258  */
259 library Math {
260     enum Rounding {
261         Down, // Toward negative infinity
262         Up, // Toward infinity
263         Zero // Toward zero
264     }
265 
266     /**
267      * @dev Returns the largest of two numbers.
268      */
269     function max(uint256 a, uint256 b) internal pure returns (uint256) {
270         return a > b ? a : b;
271     }
272 
273     /**
274      * @dev Returns the smallest of two numbers.
275      */
276     function min(uint256 a, uint256 b) internal pure returns (uint256) {
277         return a < b ? a : b;
278     }
279 
280     /**
281      * @dev Returns the average of two numbers. The result is rounded towards
282      * zero.
283      */
284     function average(uint256 a, uint256 b) internal pure returns (uint256) {
285         // (a + b) / 2 can overflow.
286         return (a & b) + (a ^ b) / 2;
287     }
288 
289     /**
290      * @dev Returns the ceiling of the division of two numbers.
291      *
292      * This differs from standard division with `/` in that it rounds up instead
293      * of rounding down.
294      */
295     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
296         // (a + b - 1) / b can overflow on addition, so we distribute.
297         return a == 0 ? 0 : (a - 1) / b + 1;
298     }
299 
300     /**
301      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
302      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
303      * with further edits by Uniswap Labs also under MIT license.
304      */
305     function mulDiv(
306         uint256 x,
307         uint256 y,
308         uint256 denominator
309     ) internal pure returns (uint256 result) {
310         unchecked {
311             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
312             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
313             // variables such that product = prod1 * 2^256 + prod0.
314             uint256 prod0; // Least significant 256 bits of the product
315             uint256 prod1; // Most significant 256 bits of the product
316             assembly {
317                 let mm := mulmod(x, y, not(0))
318                 prod0 := mul(x, y)
319                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
320             }
321 
322             // Handle non-overflow cases, 256 by 256 division.
323             if (prod1 == 0) {
324                 return prod0 / denominator;
325             }
326 
327             // Make sure the result is less than 2^256. Also prevents denominator == 0.
328             require(denominator > prod1);
329 
330             ///////////////////////////////////////////////
331             // 512 by 256 division.
332             ///////////////////////////////////////////////
333 
334             // Make division exact by subtracting the remainder from [prod1 prod0].
335             uint256 remainder;
336             assembly {
337                 // Compute remainder using mulmod.
338                 remainder := mulmod(x, y, denominator)
339 
340                 // Subtract 256 bit number from 512 bit number.
341                 prod1 := sub(prod1, gt(remainder, prod0))
342                 prod0 := sub(prod0, remainder)
343             }
344 
345             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
346             // See https://cs.stackexchange.com/q/138556/92363.
347 
348             // Does not overflow because the denominator cannot be zero at this stage in the function.
349             uint256 twos = denominator & (~denominator + 1);
350             assembly {
351                 // Divide denominator by twos.
352                 denominator := div(denominator, twos)
353 
354                 // Divide [prod1 prod0] by twos.
355                 prod0 := div(prod0, twos)
356 
357                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
358                 twos := add(div(sub(0, twos), twos), 1)
359             }
360 
361             // Shift in bits from prod1 into prod0.
362             prod0 |= prod1 * twos;
363 
364             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
365             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
366             // four bits. That is, denominator * inv = 1 mod 2^4.
367             uint256 inverse = (3 * denominator) ^ 2;
368 
369             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
370             // in modular arithmetic, doubling the correct bits in each step.
371             inverse *= 2 - denominator * inverse; // inverse mod 2^8
372             inverse *= 2 - denominator * inverse; // inverse mod 2^16
373             inverse *= 2 - denominator * inverse; // inverse mod 2^32
374             inverse *= 2 - denominator * inverse; // inverse mod 2^64
375             inverse *= 2 - denominator * inverse; // inverse mod 2^128
376             inverse *= 2 - denominator * inverse; // inverse mod 2^256
377 
378             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
379             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
380             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
381             // is no longer required.
382             result = prod0 * inverse;
383             return result;
384         }
385     }
386 
387     /**
388      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
389      */
390     function mulDiv(
391         uint256 x,
392         uint256 y,
393         uint256 denominator,
394         Rounding rounding
395     ) internal pure returns (uint256) {
396         uint256 result = mulDiv(x, y, denominator);
397         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
398             result += 1;
399         }
400         return result;
401     }
402 
403     /**
404      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
405      *
406      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
407      */
408     function sqrt(uint256 a) internal pure returns (uint256) {
409         if (a == 0) {
410             return 0;
411         }
412 
413         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
414         //
415         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
416         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
417         //
418         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
419         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
420         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
421         //
422         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
423         uint256 result = 1 << (log2(a) >> 1);
424 
425         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
426         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
427         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
428         // into the expected uint128 result.
429         unchecked {
430             result = (result + a / result) >> 1;
431             result = (result + a / result) >> 1;
432             result = (result + a / result) >> 1;
433             result = (result + a / result) >> 1;
434             result = (result + a / result) >> 1;
435             result = (result + a / result) >> 1;
436             result = (result + a / result) >> 1;
437             return min(result, a / result);
438         }
439     }
440 
441     /**
442      * @notice Calculates sqrt(a), following the selected rounding direction.
443      */
444     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
445         unchecked {
446             uint256 result = sqrt(a);
447             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
448         }
449     }
450 
451     /**
452      * @dev Return the log in base 2, rounded down, of a positive value.
453      * Returns 0 if given 0.
454      */
455     function log2(uint256 value) internal pure returns (uint256) {
456         uint256 result = 0;
457         unchecked {
458             if (value >> 128 > 0) {
459                 value >>= 128;
460                 result += 128;
461             }
462             if (value >> 64 > 0) {
463                 value >>= 64;
464                 result += 64;
465             }
466             if (value >> 32 > 0) {
467                 value >>= 32;
468                 result += 32;
469             }
470             if (value >> 16 > 0) {
471                 value >>= 16;
472                 result += 16;
473             }
474             if (value >> 8 > 0) {
475                 value >>= 8;
476                 result += 8;
477             }
478             if (value >> 4 > 0) {
479                 value >>= 4;
480                 result += 4;
481             }
482             if (value >> 2 > 0) {
483                 value >>= 2;
484                 result += 2;
485             }
486             if (value >> 1 > 0) {
487                 result += 1;
488             }
489         }
490         return result;
491     }
492 
493     /**
494      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
495      * Returns 0 if given 0.
496      */
497     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
498         unchecked {
499             uint256 result = log2(value);
500             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
501         }
502     }
503 
504     /**
505      * @dev Return the log in base 10, rounded down, of a positive value.
506      * Returns 0 if given 0.
507      */
508     function log10(uint256 value) internal pure returns (uint256) {
509         uint256 result = 0;
510         unchecked {
511             if (value >= 10**64) {
512                 value /= 10**64;
513                 result += 64;
514             }
515             if (value >= 10**32) {
516                 value /= 10**32;
517                 result += 32;
518             }
519             if (value >= 10**16) {
520                 value /= 10**16;
521                 result += 16;
522             }
523             if (value >= 10**8) {
524                 value /= 10**8;
525                 result += 8;
526             }
527             if (value >= 10**4) {
528                 value /= 10**4;
529                 result += 4;
530             }
531             if (value >= 10**2) {
532                 value /= 10**2;
533                 result += 2;
534             }
535             if (value >= 10**1) {
536                 result += 1;
537             }
538         }
539         return result;
540     }
541 
542     /**
543      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
544      * Returns 0 if given 0.
545      */
546     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
547         unchecked {
548             uint256 result = log10(value);
549             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
550         }
551     }
552 
553     /**
554      * @dev Return the log in base 256, rounded down, of a positive value.
555      * Returns 0 if given 0.
556      *
557      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
558      */
559     function log256(uint256 value) internal pure returns (uint256) {
560         uint256 result = 0;
561         unchecked {
562             if (value >> 128 > 0) {
563                 value >>= 128;
564                 result += 16;
565             }
566             if (value >> 64 > 0) {
567                 value >>= 64;
568                 result += 8;
569             }
570             if (value >> 32 > 0) {
571                 value >>= 32;
572                 result += 4;
573             }
574             if (value >> 16 > 0) {
575                 value >>= 16;
576                 result += 2;
577             }
578             if (value >> 8 > 0) {
579                 result += 1;
580             }
581         }
582         return result;
583     }
584 
585     /**
586      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
587      * Returns 0 if given 0.
588      */
589     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
590         unchecked {
591             uint256 result = log256(value);
592             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
593         }
594     }
595 }
596 
597 // File: @openzeppelin/contracts/utils/Strings.sol
598 
599 
600 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
601 
602 pragma solidity ^0.8.0;
603 
604 
605 /**
606  * @dev String operations.
607  */
608 library Strings {
609     bytes16 private constant _SYMBOLS = "0123456789abcdef";
610     uint8 private constant _ADDRESS_LENGTH = 20;
611 
612     /**
613      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
614      */
615     function toString(uint256 value) internal pure returns (string memory) {
616         unchecked {
617             uint256 length = Math.log10(value) + 1;
618             string memory buffer = new string(length);
619             uint256 ptr;
620             /// @solidity memory-safe-assembly
621             assembly {
622                 ptr := add(buffer, add(32, length))
623             }
624             while (true) {
625                 ptr--;
626                 /// @solidity memory-safe-assembly
627                 assembly {
628                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
629                 }
630                 value /= 10;
631                 if (value == 0) break;
632             }
633             return buffer;
634         }
635     }
636 
637     /**
638      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
639      */
640     function toHexString(uint256 value) internal pure returns (string memory) {
641         unchecked {
642             return toHexString(value, Math.log256(value) + 1);
643         }
644     }
645 
646     /**
647      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
648      */
649     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
650         bytes memory buffer = new bytes(2 * length + 2);
651         buffer[0] = "0";
652         buffer[1] = "x";
653         for (uint256 i = 2 * length + 1; i > 1; --i) {
654             buffer[i] = _SYMBOLS[value & 0xf];
655             value >>= 4;
656         }
657         require(value == 0, "Strings: hex length insufficient");
658         return string(buffer);
659     }
660 
661     /**
662      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
663      */
664     function toHexString(address addr) internal pure returns (string memory) {
665         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
666     }
667 }
668 
669 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
670 
671 
672 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Contract module that helps prevent reentrant calls to a function.
678  *
679  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
680  * available, which can be applied to functions to make sure there are no nested
681  * (reentrant) calls to them.
682  *
683  * Note that because there is a single `nonReentrant` guard, functions marked as
684  * `nonReentrant` may not call one another. This can be worked around by making
685  * those functions `private`, and then adding `external` `nonReentrant` entry
686  * points to them.
687  *
688  * TIP: If you would like to learn more about reentrancy and alternative ways
689  * to protect against it, check out our blog post
690  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
691  */
692 abstract contract ReentrancyGuard {
693     // Booleans are more expensive than uint256 or any type that takes up a full
694     // word because each write operation emits an extra SLOAD to first read the
695     // slot's contents, replace the bits taken up by the boolean, and then write
696     // back. This is the compiler's defense against contract upgrades and
697     // pointer aliasing, and it cannot be disabled.
698 
699     // The values being non-zero value makes deployment a bit more expensive,
700     // but in exchange the refund on every call to nonReentrant will be lower in
701     // amount. Since refunds are capped to a percentage of the total
702     // transaction's gas, it is best to keep them low in cases like this one, to
703     // increase the likelihood of the full refund coming into effect.
704     uint256 private constant _NOT_ENTERED = 1;
705     uint256 private constant _ENTERED = 2;
706 
707     uint256 private _status;
708 
709     constructor() {
710         _status = _NOT_ENTERED;
711     }
712 
713     /**
714      * @dev Prevents a contract from calling itself, directly or indirectly.
715      * Calling a `nonReentrant` function from another `nonReentrant`
716      * function is not supported. It is possible to prevent this from happening
717      * by making the `nonReentrant` function external, and making it call a
718      * `private` function that does the actual work.
719      */
720     modifier nonReentrant() {
721         _nonReentrantBefore();
722         _;
723         _nonReentrantAfter();
724     }
725 
726     function _nonReentrantBefore() private {
727         // On the first call to nonReentrant, _status will be _NOT_ENTERED
728         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
729 
730         // Any calls to nonReentrant after this point will fail
731         _status = _ENTERED;
732     }
733 
734     function _nonReentrantAfter() private {
735         // By storing the original value once again, a refund is triggered (see
736         // https://eips.ethereum.org/EIPS/eip-2200)
737         _status = _NOT_ENTERED;
738     }
739 }
740 
741 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
742 
743 
744 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/MerkleProof.sol)
745 
746 pragma solidity ^0.8.0;
747 
748 /**
749  * @dev These functions deal with verification of Merkle Tree proofs.
750  *
751  * The tree and the proofs can be generated using our
752  * https://github.com/OpenZeppelin/merkle-tree[JavaScript library].
753  * You will find a quickstart guide in the readme.
754  *
755  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
756  * hashing, or use a hash function other than keccak256 for hashing leaves.
757  * This is because the concatenation of a sorted pair of internal nodes in
758  * the merkle tree could be reinterpreted as a leaf value.
759  * OpenZeppelin's JavaScript library generates merkle trees that are safe
760  * against this attack out of the box.
761  */
762 library MerkleProof {
763     /**
764      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
765      * defined by `root`. For this, a `proof` must be provided, containing
766      * sibling hashes on the branch from the leaf to the root of the tree. Each
767      * pair of leaves and each pair of pre-images are assumed to be sorted.
768      */
769     function verify(
770         bytes32[] memory proof,
771         bytes32 root,
772         bytes32 leaf
773     ) internal pure returns (bool) {
774         return processProof(proof, leaf) == root;
775     }
776 
777     /**
778      * @dev Calldata version of {verify}
779      *
780      * _Available since v4.7._
781      */
782     function verifyCalldata(
783         bytes32[] calldata proof,
784         bytes32 root,
785         bytes32 leaf
786     ) internal pure returns (bool) {
787         return processProofCalldata(proof, leaf) == root;
788     }
789 
790     /**
791      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
792      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
793      * hash matches the root of the tree. When processing the proof, the pairs
794      * of leafs & pre-images are assumed to be sorted.
795      *
796      * _Available since v4.4._
797      */
798     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
799         bytes32 computedHash = leaf;
800         for (uint256 i = 0; i < proof.length; i++) {
801             computedHash = _hashPair(computedHash, proof[i]);
802         }
803         return computedHash;
804     }
805 
806     /**
807      * @dev Calldata version of {processProof}
808      *
809      * _Available since v4.7._
810      */
811     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
812         bytes32 computedHash = leaf;
813         for (uint256 i = 0; i < proof.length; i++) {
814             computedHash = _hashPair(computedHash, proof[i]);
815         }
816         return computedHash;
817     }
818 
819     /**
820      * @dev Returns true if the `leaves` can be simultaneously proven to be a part of a merkle tree defined by
821      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
822      *
823      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
824      *
825      * _Available since v4.7._
826      */
827     function multiProofVerify(
828         bytes32[] memory proof,
829         bool[] memory proofFlags,
830         bytes32 root,
831         bytes32[] memory leaves
832     ) internal pure returns (bool) {
833         return processMultiProof(proof, proofFlags, leaves) == root;
834     }
835 
836     /**
837      * @dev Calldata version of {multiProofVerify}
838      *
839      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
840      *
841      * _Available since v4.7._
842      */
843     function multiProofVerifyCalldata(
844         bytes32[] calldata proof,
845         bool[] calldata proofFlags,
846         bytes32 root,
847         bytes32[] memory leaves
848     ) internal pure returns (bool) {
849         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
850     }
851 
852     /**
853      * @dev Returns the root of a tree reconstructed from `leaves` and sibling nodes in `proof`. The reconstruction
854      * proceeds by incrementally reconstructing all inner nodes by combining a leaf/inner node with either another
855      * leaf/inner node or a proof sibling node, depending on whether each `proofFlags` item is true or false
856      * respectively.
857      *
858      * CAUTION: Not all merkle trees admit multiproofs. To use multiproofs, it is sufficient to ensure that: 1) the tree
859      * is complete (but not necessarily perfect), 2) the leaves to be proven are in the opposite order they are in the
860      * tree (i.e., as seen from right to left starting at the deepest layer and continuing at the next layer).
861      *
862      * _Available since v4.7._
863      */
864     function processMultiProof(
865         bytes32[] memory proof,
866         bool[] memory proofFlags,
867         bytes32[] memory leaves
868     ) internal pure returns (bytes32 merkleRoot) {
869         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
870         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
871         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
872         // the merkle tree.
873         uint256 leavesLen = leaves.length;
874         uint256 totalHashes = proofFlags.length;
875 
876         // Check proof validity.
877         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
878 
879         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
880         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
881         bytes32[] memory hashes = new bytes32[](totalHashes);
882         uint256 leafPos = 0;
883         uint256 hashPos = 0;
884         uint256 proofPos = 0;
885         // At each step, we compute the next hash using two values:
886         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
887         //   get the next hash.
888         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
889         //   `proof` array.
890         for (uint256 i = 0; i < totalHashes; i++) {
891             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
892             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
893             hashes[i] = _hashPair(a, b);
894         }
895 
896         if (totalHashes > 0) {
897             return hashes[totalHashes - 1];
898         } else if (leavesLen > 0) {
899             return leaves[0];
900         } else {
901             return proof[0];
902         }
903     }
904 
905     /**
906      * @dev Calldata version of {processMultiProof}.
907      *
908      * CAUTION: Not all merkle trees admit multiproofs. See {processMultiProof} for details.
909      *
910      * _Available since v4.7._
911      */
912     function processMultiProofCalldata(
913         bytes32[] calldata proof,
914         bool[] calldata proofFlags,
915         bytes32[] memory leaves
916     ) internal pure returns (bytes32 merkleRoot) {
917         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
918         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
919         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
920         // the merkle tree.
921         uint256 leavesLen = leaves.length;
922         uint256 totalHashes = proofFlags.length;
923 
924         // Check proof validity.
925         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
926 
927         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
928         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
929         bytes32[] memory hashes = new bytes32[](totalHashes);
930         uint256 leafPos = 0;
931         uint256 hashPos = 0;
932         uint256 proofPos = 0;
933         // At each step, we compute the next hash using two values:
934         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
935         //   get the next hash.
936         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
937         //   `proof` array.
938         for (uint256 i = 0; i < totalHashes; i++) {
939             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
940             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
941             hashes[i] = _hashPair(a, b);
942         }
943 
944         if (totalHashes > 0) {
945             return hashes[totalHashes - 1];
946         } else if (leavesLen > 0) {
947             return leaves[0];
948         } else {
949             return proof[0];
950         }
951     }
952 
953     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
954         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
955     }
956 
957     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
958         /// @solidity memory-safe-assembly
959         assembly {
960             mstore(0x00, a)
961             mstore(0x20, b)
962             value := keccak256(0x00, 0x40)
963         }
964     }
965 }
966 
967 // File: @openzeppelin/contracts/utils/Context.sol
968 
969 
970 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
971 
972 pragma solidity ^0.8.0;
973 
974 /**
975  * @dev Provides information about the current execution context, including the
976  * sender of the transaction and its data. While these are generally available
977  * via msg.sender and msg.data, they should not be accessed in such a direct
978  * manner, since when dealing with meta-transactions the account sending and
979  * paying for execution may not be the actual sender (as far as an application
980  * is concerned).
981  *
982  * This contract is only required for intermediate, library-like contracts.
983  */
984 abstract contract Context {
985     function _msgSender() internal view virtual returns (address) {
986         return msg.sender;
987     }
988 
989     function _msgData() internal view virtual returns (bytes calldata) {
990         return msg.data;
991     }
992 }
993 
994 // File: @openzeppelin/contracts/access/Ownable.sol
995 
996 
997 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
998 
999 pragma solidity ^0.8.0;
1000 
1001 
1002 /**
1003  * @dev Contract module which provides a basic access control mechanism, where
1004  * there is an account (an owner) that can be granted exclusive access to
1005  * specific functions.
1006  *
1007  * By default, the owner account will be the one that deploys the contract. This
1008  * can later be changed with {transferOwnership}.
1009  *
1010  * This module is used through inheritance. It will make available the modifier
1011  * `onlyOwner`, which can be applied to your functions to restrict their use to
1012  * the owner.
1013  */
1014 abstract contract Ownable is Context {
1015     address private _owner;
1016 
1017     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1018 
1019     /**
1020      * @dev Initializes the contract setting the deployer as the initial owner.
1021      */
1022     constructor() {
1023         _transferOwnership(_msgSender());
1024     }
1025 
1026     /**
1027      * @dev Throws if called by any account other than the owner.
1028      */
1029     modifier onlyOwner() {
1030         _checkOwner();
1031         _;
1032     }
1033 
1034     /**
1035      * @dev Returns the address of the current owner.
1036      */
1037     function owner() public view virtual returns (address) {
1038         return _owner;
1039     }
1040 
1041     /**
1042      * @dev Throws if the sender is not the owner.
1043      */
1044     function _checkOwner() internal view virtual {
1045         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1046     }
1047 
1048     /**
1049      * @dev Leaves the contract without owner. It will not be possible to call
1050      * `onlyOwner` functions anymore. Can only be called by the current owner.
1051      *
1052      * NOTE: Renouncing ownership will leave the contract without an owner,
1053      * thereby removing any functionality that is only available to the owner.
1054      */
1055     function renounceOwnership() public virtual onlyOwner {
1056         _transferOwnership(address(0));
1057     }
1058 
1059     /**
1060      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1061      * Can only be called by the current owner.
1062      */
1063     function transferOwnership(address newOwner) public virtual onlyOwner {
1064         require(newOwner != address(0), "Ownable: new owner is the zero address");
1065         _transferOwnership(newOwner);
1066     }
1067 
1068     /**
1069      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1070      * Internal function without access restriction.
1071      */
1072     function _transferOwnership(address newOwner) internal virtual {
1073         address oldOwner = _owner;
1074         _owner = newOwner;
1075         emit OwnershipTransferred(oldOwner, newOwner);
1076     }
1077 }
1078 
1079 // File: erc721a/contracts/IERC721A.sol
1080 
1081 
1082 // ERC721A Contracts v4.2.3
1083 // Creator: Chiru Labs
1084 
1085 pragma solidity ^0.8.4;
1086 
1087 /**
1088  * @dev Interface of ERC721A.
1089  */
1090 interface IERC721A {
1091     /**
1092      * The caller must own the token or be an approved operator.
1093      */
1094     error ApprovalCallerNotOwnerNorApproved();
1095 
1096     /**
1097      * The token does not exist.
1098      */
1099     error ApprovalQueryForNonexistentToken();
1100 
1101     /**
1102      * Cannot query the balance for the zero address.
1103      */
1104     error BalanceQueryForZeroAddress();
1105 
1106     /**
1107      * Cannot mint to the zero address.
1108      */
1109     error MintToZeroAddress();
1110 
1111     /**
1112      * The quantity of tokens minted must be more than zero.
1113      */
1114     error MintZeroQuantity();
1115 
1116     /**
1117      * The token does not exist.
1118      */
1119     error OwnerQueryForNonexistentToken();
1120 
1121     /**
1122      * The caller must own the token or be an approved operator.
1123      */
1124     error TransferCallerNotOwnerNorApproved();
1125 
1126     /**
1127      * The token must be owned by `from`.
1128      */
1129     error TransferFromIncorrectOwner();
1130 
1131     /**
1132      * Cannot safely transfer to a contract that does not implement the
1133      * ERC721Receiver interface.
1134      */
1135     error TransferToNonERC721ReceiverImplementer();
1136 
1137     /**
1138      * Cannot transfer to the zero address.
1139      */
1140     error TransferToZeroAddress();
1141 
1142     /**
1143      * The token does not exist.
1144      */
1145     error URIQueryForNonexistentToken();
1146 
1147     /**
1148      * The `quantity` minted with ERC2309 exceeds the safety limit.
1149      */
1150     error MintERC2309QuantityExceedsLimit();
1151 
1152     /**
1153      * The `extraData` cannot be set on an unintialized ownership slot.
1154      */
1155     error OwnershipNotInitializedForExtraData();
1156 
1157     // =============================================================
1158     //                            STRUCTS
1159     // =============================================================
1160 
1161     struct TokenOwnership {
1162         // The address of the owner.
1163         address addr;
1164         // Stores the start time of ownership with minimal overhead for tokenomics.
1165         uint64 startTimestamp;
1166         // Whether the token has been burned.
1167         bool burned;
1168         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1169         uint24 extraData;
1170     }
1171 
1172     // =============================================================
1173     //                         TOKEN COUNTERS
1174     // =============================================================
1175 
1176     /**
1177      * @dev Returns the total number of tokens in existence.
1178      * Burned tokens will reduce the count.
1179      * To get the total number of tokens minted, please see {_totalMinted}.
1180      */
1181     function totalSupply() external view returns (uint256);
1182 
1183     // =============================================================
1184     //                            IERC165
1185     // =============================================================
1186 
1187     /**
1188      * @dev Returns true if this contract implements the interface defined by
1189      * `interfaceId`. See the corresponding
1190      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1191      * to learn more about how these ids are created.
1192      *
1193      * This function call must use less than 30000 gas.
1194      */
1195     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1196 
1197     // =============================================================
1198     //                            IERC721
1199     // =============================================================
1200 
1201     /**
1202      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1203      */
1204     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1205 
1206     /**
1207      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1208      */
1209     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1210 
1211     /**
1212      * @dev Emitted when `owner` enables or disables
1213      * (`approved`) `operator` to manage all of its assets.
1214      */
1215     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1216 
1217     /**
1218      * @dev Returns the number of tokens in `owner`'s account.
1219      */
1220     function balanceOf(address owner) external view returns (uint256 balance);
1221 
1222     /**
1223      * @dev Returns the owner of the `tokenId` token.
1224      *
1225      * Requirements:
1226      *
1227      * - `tokenId` must exist.
1228      */
1229     function ownerOf(uint256 tokenId) external view returns (address owner);
1230 
1231     /**
1232      * @dev Safely transfers `tokenId` token from `from` to `to`,
1233      * checking first that contract recipients are aware of the ERC721 protocol
1234      * to prevent tokens from being forever locked.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must exist and be owned by `from`.
1241      * - If the caller is not `from`, it must be have been allowed to move
1242      * this token by either {approve} or {setApprovalForAll}.
1243      * - If `to` refers to a smart contract, it must implement
1244      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1245      *
1246      * Emits a {Transfer} event.
1247      */
1248     function safeTransferFrom(
1249         address from,
1250         address to,
1251         uint256 tokenId,
1252         bytes calldata data
1253     ) external payable;
1254 
1255     /**
1256      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1257      */
1258     function safeTransferFrom(
1259         address from,
1260         address to,
1261         uint256 tokenId
1262     ) external payable;
1263 
1264     /**
1265      * @dev Transfers `tokenId` from `from` to `to`.
1266      *
1267      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1268      * whenever possible.
1269      *
1270      * Requirements:
1271      *
1272      * - `from` cannot be the zero address.
1273      * - `to` cannot be the zero address.
1274      * - `tokenId` token must be owned by `from`.
1275      * - If the caller is not `from`, it must be approved to move this token
1276      * by either {approve} or {setApprovalForAll}.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function transferFrom(
1281         address from,
1282         address to,
1283         uint256 tokenId
1284     ) external payable;
1285 
1286     /**
1287      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1288      * The approval is cleared when the token is transferred.
1289      *
1290      * Only a single account can be approved at a time, so approving the
1291      * zero address clears previous approvals.
1292      *
1293      * Requirements:
1294      *
1295      * - The caller must own the token or be an approved operator.
1296      * - `tokenId` must exist.
1297      *
1298      * Emits an {Approval} event.
1299      */
1300     function approve(address to, uint256 tokenId) external payable;
1301 
1302     /**
1303      * @dev Approve or remove `operator` as an operator for the caller.
1304      * Operators can call {transferFrom} or {safeTransferFrom}
1305      * for any token owned by the caller.
1306      *
1307      * Requirements:
1308      *
1309      * - The `operator` cannot be the caller.
1310      *
1311      * Emits an {ApprovalForAll} event.
1312      */
1313     function setApprovalForAll(address operator, bool _approved) external;
1314 
1315     /**
1316      * @dev Returns the account approved for `tokenId` token.
1317      *
1318      * Requirements:
1319      *
1320      * - `tokenId` must exist.
1321      */
1322     function getApproved(uint256 tokenId) external view returns (address operator);
1323 
1324     /**
1325      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1326      *
1327      * See {setApprovalForAll}.
1328      */
1329     function isApprovedForAll(address owner, address operator) external view returns (bool);
1330 
1331     // =============================================================
1332     //                        IERC721Metadata
1333     // =============================================================
1334 
1335     /**
1336      * @dev Returns the token collection name.
1337      */
1338     function name() external view returns (string memory);
1339 
1340     /**
1341      * @dev Returns the token collection symbol.
1342      */
1343     function symbol() external view returns (string memory);
1344 
1345     /**
1346      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1347      */
1348     function tokenURI(uint256 tokenId) external view returns (string memory);
1349 
1350     // =============================================================
1351     //                           IERC2309
1352     // =============================================================
1353 
1354     /**
1355      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1356      * (inclusive) is transferred from `from` to `to`, as defined in the
1357      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1358      *
1359      * See {_mintERC2309} for more details.
1360      */
1361     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1362 }
1363 
1364 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1365 
1366 
1367 // ERC721A Contracts v4.2.3
1368 // Creator: Chiru Labs
1369 
1370 pragma solidity ^0.8.4;
1371 
1372 
1373 /**
1374  * @dev Interface of ERC721AQueryable.
1375  */
1376 interface IERC721AQueryable is IERC721A {
1377     /**
1378      * Invalid query range (`start` >= `stop`).
1379      */
1380     error InvalidQueryRange();
1381 
1382     /**
1383      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1384      *
1385      * If the `tokenId` is out of bounds:
1386      *
1387      * - `addr = address(0)`
1388      * - `startTimestamp = 0`
1389      * - `burned = false`
1390      * - `extraData = 0`
1391      *
1392      * If the `tokenId` is burned:
1393      *
1394      * - `addr = <Address of owner before token was burned>`
1395      * - `startTimestamp = <Timestamp when token was burned>`
1396      * - `burned = true`
1397      * - `extraData = <Extra data when token was burned>`
1398      *
1399      * Otherwise:
1400      *
1401      * - `addr = <Address of owner>`
1402      * - `startTimestamp = <Timestamp of start of ownership>`
1403      * - `burned = false`
1404      * - `extraData = <Extra data at start of ownership>`
1405      */
1406     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1407 
1408     /**
1409      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1410      * See {ERC721AQueryable-explicitOwnershipOf}
1411      */
1412     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1413 
1414     /**
1415      * @dev Returns an array of token IDs owned by `owner`,
1416      * in the range [`start`, `stop`)
1417      * (i.e. `start <= tokenId < stop`).
1418      *
1419      * This function allows for tokens to be queried if the collection
1420      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1421      *
1422      * Requirements:
1423      *
1424      * - `start < stop`
1425      */
1426     function tokensOfOwnerIn(
1427         address owner,
1428         uint256 start,
1429         uint256 stop
1430     ) external view returns (uint256[] memory);
1431 
1432     /**
1433      * @dev Returns an array of token IDs owned by `owner`.
1434      *
1435      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1436      * It is meant to be called off-chain.
1437      *
1438      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1439      * multiple smaller scans if the collection is large enough to cause
1440      * an out-of-gas error (10K collections should be fine).
1441      */
1442     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1443 }
1444 
1445 // File: erc721a/contracts/ERC721A.sol
1446 
1447 
1448 // ERC721A Contracts v4.2.3
1449 // Creator: Chiru Labs
1450 
1451 pragma solidity ^0.8.4;
1452 
1453 
1454 /**
1455  * @dev Interface of ERC721 token receiver.
1456  */
1457 interface ERC721A__IERC721Receiver {
1458     function onERC721Received(
1459         address operator,
1460         address from,
1461         uint256 tokenId,
1462         bytes calldata data
1463     ) external returns (bytes4);
1464 }
1465 
1466 /**
1467  * @title ERC721A
1468  *
1469  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1470  * Non-Fungible Token Standard, including the Metadata extension.
1471  * Optimized for lower gas during batch mints.
1472  *
1473  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1474  * starting from `_startTokenId()`.
1475  *
1476  * Assumptions:
1477  *
1478  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1479  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1480  */
1481 contract ERC721A is IERC721A {
1482     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1483     struct TokenApprovalRef {
1484         address value;
1485     }
1486 
1487     // =============================================================
1488     //                           CONSTANTS
1489     // =============================================================
1490 
1491     // Mask of an entry in packed address data.
1492     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1493 
1494     // The bit position of `numberMinted` in packed address data.
1495     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1496 
1497     // The bit position of `numberBurned` in packed address data.
1498     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1499 
1500     // The bit position of `aux` in packed address data.
1501     uint256 private constant _BITPOS_AUX = 192;
1502 
1503     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1504     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1505 
1506     // The bit position of `startTimestamp` in packed ownership.
1507     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1508 
1509     // The bit mask of the `burned` bit in packed ownership.
1510     uint256 private constant _BITMASK_BURNED = 1 << 224;
1511 
1512     // The bit position of the `nextInitialized` bit in packed ownership.
1513     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1514 
1515     // The bit mask of the `nextInitialized` bit in packed ownership.
1516     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1517 
1518     // The bit position of `extraData` in packed ownership.
1519     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1520 
1521     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1522     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1523 
1524     // The mask of the lower 160 bits for addresses.
1525     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1526 
1527     // The maximum `quantity` that can be minted with {_mintERC2309}.
1528     // This limit is to prevent overflows on the address data entries.
1529     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1530     // is required to cause an overflow, which is unrealistic.
1531     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1532 
1533     // The `Transfer` event signature is given by:
1534     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1535     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1536         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1537 
1538     // =============================================================
1539     //                            STORAGE
1540     // =============================================================
1541 
1542     // The next token ID to be minted.
1543     uint256 private _currentIndex;
1544 
1545     // The number of tokens burned.
1546     uint256 private _burnCounter;
1547 
1548     // Token name
1549     string private _name;
1550 
1551     // Token symbol
1552     string private _symbol;
1553 
1554     // Mapping from token ID to ownership details
1555     // An empty struct value does not necessarily mean the token is unowned.
1556     // See {_packedOwnershipOf} implementation for details.
1557     //
1558     // Bits Layout:
1559     // - [0..159]   `addr`
1560     // - [160..223] `startTimestamp`
1561     // - [224]      `burned`
1562     // - [225]      `nextInitialized`
1563     // - [232..255] `extraData`
1564     mapping(uint256 => uint256) private _packedOwnerships;
1565 
1566     // Mapping owner address to address data.
1567     //
1568     // Bits Layout:
1569     // - [0..63]    `balance`
1570     // - [64..127]  `numberMinted`
1571     // - [128..191] `numberBurned`
1572     // - [192..255] `aux`
1573     mapping(address => uint256) private _packedAddressData;
1574 
1575     // Mapping from token ID to approved address.
1576     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1577 
1578     // Mapping from owner to operator approvals
1579     mapping(address => mapping(address => bool)) private _operatorApprovals;
1580 
1581     // =============================================================
1582     //                          CONSTRUCTOR
1583     // =============================================================
1584 
1585     constructor(string memory name_, string memory symbol_) {
1586         _name = name_;
1587         _symbol = symbol_;
1588         _currentIndex = _startTokenId();
1589     }
1590 
1591     // =============================================================
1592     //                   TOKEN COUNTING OPERATIONS
1593     // =============================================================
1594 
1595     /**
1596      * @dev Returns the starting token ID.
1597      * To change the starting token ID, please override this function.
1598      */
1599     function _startTokenId() internal view virtual returns (uint256) {
1600         return 0;
1601     }
1602 
1603     /**
1604      * @dev Returns the next token ID to be minted.
1605      */
1606     function _nextTokenId() internal view virtual returns (uint256) {
1607         return _currentIndex;
1608     }
1609 
1610     /**
1611      * @dev Returns the total number of tokens in existence.
1612      * Burned tokens will reduce the count.
1613      * To get the total number of tokens minted, please see {_totalMinted}.
1614      */
1615     function totalSupply() public view virtual override returns (uint256) {
1616         // Counter underflow is impossible as _burnCounter cannot be incremented
1617         // more than `_currentIndex - _startTokenId()` times.
1618         unchecked {
1619             return _currentIndex - _burnCounter - _startTokenId();
1620         }
1621     }
1622 
1623     /**
1624      * @dev Returns the total amount of tokens minted in the contract.
1625      */
1626     function _totalMinted() internal view virtual returns (uint256) {
1627         // Counter underflow is impossible as `_currentIndex` does not decrement,
1628         // and it is initialized to `_startTokenId()`.
1629         unchecked {
1630             return _currentIndex - _startTokenId();
1631         }
1632     }
1633 
1634     /**
1635      * @dev Returns the total number of tokens burned.
1636      */
1637     function _totalBurned() internal view virtual returns (uint256) {
1638         return _burnCounter;
1639     }
1640 
1641     // =============================================================
1642     //                    ADDRESS DATA OPERATIONS
1643     // =============================================================
1644 
1645     /**
1646      * @dev Returns the number of tokens in `owner`'s account.
1647      */
1648     function balanceOf(address owner) public view virtual override returns (uint256) {
1649         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1650         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1651     }
1652 
1653     /**
1654      * Returns the number of tokens minted by `owner`.
1655      */
1656     function _numberMinted(address owner) internal view returns (uint256) {
1657         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1658     }
1659 
1660     /**
1661      * Returns the number of tokens burned by or on behalf of `owner`.
1662      */
1663     function _numberBurned(address owner) internal view returns (uint256) {
1664         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1665     }
1666 
1667     /**
1668      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1669      */
1670     function _getAux(address owner) internal view returns (uint64) {
1671         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1672     }
1673 
1674     /**
1675      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1676      * If there are multiple variables, please pack them into a uint64.
1677      */
1678     function _setAux(address owner, uint64 aux) internal virtual {
1679         uint256 packed = _packedAddressData[owner];
1680         uint256 auxCasted;
1681         // Cast `aux` with assembly to avoid redundant masking.
1682         assembly {
1683             auxCasted := aux
1684         }
1685         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1686         _packedAddressData[owner] = packed;
1687     }
1688 
1689     // =============================================================
1690     //                            IERC165
1691     // =============================================================
1692 
1693     /**
1694      * @dev Returns true if this contract implements the interface defined by
1695      * `interfaceId`. See the corresponding
1696      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1697      * to learn more about how these ids are created.
1698      *
1699      * This function call must use less than 30000 gas.
1700      */
1701     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1702         // The interface IDs are constants representing the first 4 bytes
1703         // of the XOR of all function selectors in the interface.
1704         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1705         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1706         return
1707             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1708             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1709             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1710     }
1711 
1712     // =============================================================
1713     //                        IERC721Metadata
1714     // =============================================================
1715 
1716     /**
1717      * @dev Returns the token collection name.
1718      */
1719     function name() public view virtual override returns (string memory) {
1720         return _name;
1721     }
1722 
1723     /**
1724      * @dev Returns the token collection symbol.
1725      */
1726     function symbol() public view virtual override returns (string memory) {
1727         return _symbol;
1728     }
1729 
1730     /**
1731      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1732      */
1733     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1734         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1735 
1736         string memory baseURI = _baseURI();
1737         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1738     }
1739 
1740     /**
1741      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1742      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1743      * by default, it can be overridden in child contracts.
1744      */
1745     function _baseURI() internal view virtual returns (string memory) {
1746         return '';
1747     }
1748 
1749     // =============================================================
1750     //                     OWNERSHIPS OPERATIONS
1751     // =============================================================
1752 
1753     /**
1754      * @dev Returns the owner of the `tokenId` token.
1755      *
1756      * Requirements:
1757      *
1758      * - `tokenId` must exist.
1759      */
1760     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1761         return address(uint160(_packedOwnershipOf(tokenId)));
1762     }
1763 
1764     /**
1765      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1766      * It gradually moves to O(1) as tokens get transferred around over time.
1767      */
1768     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1769         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1770     }
1771 
1772     /**
1773      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1774      */
1775     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1776         return _unpackedOwnership(_packedOwnerships[index]);
1777     }
1778 
1779     /**
1780      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1781      */
1782     function _initializeOwnershipAt(uint256 index) internal virtual {
1783         if (_packedOwnerships[index] == 0) {
1784             _packedOwnerships[index] = _packedOwnershipOf(index);
1785         }
1786     }
1787 
1788     /**
1789      * Returns the packed ownership data of `tokenId`.
1790      */
1791     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1792         uint256 curr = tokenId;
1793 
1794         unchecked {
1795             if (_startTokenId() <= curr)
1796                 if (curr < _currentIndex) {
1797                     uint256 packed = _packedOwnerships[curr];
1798                     // If not burned.
1799                     if (packed & _BITMASK_BURNED == 0) {
1800                         // Invariant:
1801                         // There will always be an initialized ownership slot
1802                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1803                         // before an unintialized ownership slot
1804                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1805                         // Hence, `curr` will not underflow.
1806                         //
1807                         // We can directly compare the packed value.
1808                         // If the address is zero, packed will be zero.
1809                         while (packed == 0) {
1810                             packed = _packedOwnerships[--curr];
1811                         }
1812                         return packed;
1813                     }
1814                 }
1815         }
1816         revert OwnerQueryForNonexistentToken();
1817     }
1818 
1819     /**
1820      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1821      */
1822     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1823         ownership.addr = address(uint160(packed));
1824         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1825         ownership.burned = packed & _BITMASK_BURNED != 0;
1826         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1827     }
1828 
1829     /**
1830      * @dev Packs ownership data into a single uint256.
1831      */
1832     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1833         assembly {
1834             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1835             owner := and(owner, _BITMASK_ADDRESS)
1836             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1837             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1838         }
1839     }
1840 
1841     /**
1842      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1843      */
1844     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1845         // For branchless setting of the `nextInitialized` flag.
1846         assembly {
1847             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1848             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1849         }
1850     }
1851 
1852     // =============================================================
1853     //                      APPROVAL OPERATIONS
1854     // =============================================================
1855 
1856     /**
1857      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1858      * The approval is cleared when the token is transferred.
1859      *
1860      * Only a single account can be approved at a time, so approving the
1861      * zero address clears previous approvals.
1862      *
1863      * Requirements:
1864      *
1865      * - The caller must own the token or be an approved operator.
1866      * - `tokenId` must exist.
1867      *
1868      * Emits an {Approval} event.
1869      */
1870     function approve(address to, uint256 tokenId) public payable virtual override {
1871         address owner = ownerOf(tokenId);
1872 
1873         if (_msgSenderERC721A() != owner)
1874             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1875                 revert ApprovalCallerNotOwnerNorApproved();
1876             }
1877 
1878         _tokenApprovals[tokenId].value = to;
1879         emit Approval(owner, to, tokenId);
1880     }
1881 
1882     /**
1883      * @dev Returns the account approved for `tokenId` token.
1884      *
1885      * Requirements:
1886      *
1887      * - `tokenId` must exist.
1888      */
1889     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1890         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1891 
1892         return _tokenApprovals[tokenId].value;
1893     }
1894 
1895     /**
1896      * @dev Approve or remove `operator` as an operator for the caller.
1897      * Operators can call {transferFrom} or {safeTransferFrom}
1898      * for any token owned by the caller.
1899      *
1900      * Requirements:
1901      *
1902      * - The `operator` cannot be the caller.
1903      *
1904      * Emits an {ApprovalForAll} event.
1905      */
1906     function setApprovalForAll(address operator, bool approved) public virtual override {
1907         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1908         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1909     }
1910 
1911     /**
1912      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1913      *
1914      * See {setApprovalForAll}.
1915      */
1916     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1917         return _operatorApprovals[owner][operator];
1918     }
1919 
1920     /**
1921      * @dev Returns whether `tokenId` exists.
1922      *
1923      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1924      *
1925      * Tokens start existing when they are minted. See {_mint}.
1926      */
1927     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1928         return
1929             _startTokenId() <= tokenId &&
1930             tokenId < _currentIndex && // If within bounds,
1931             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1932     }
1933 
1934     /**
1935      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1936      */
1937     function _isSenderApprovedOrOwner(
1938         address approvedAddress,
1939         address owner,
1940         address msgSender
1941     ) private pure returns (bool result) {
1942         assembly {
1943             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1944             owner := and(owner, _BITMASK_ADDRESS)
1945             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1946             msgSender := and(msgSender, _BITMASK_ADDRESS)
1947             // `msgSender == owner || msgSender == approvedAddress`.
1948             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1949         }
1950     }
1951 
1952     /**
1953      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1954      */
1955     function _getApprovedSlotAndAddress(uint256 tokenId)
1956         private
1957         view
1958         returns (uint256 approvedAddressSlot, address approvedAddress)
1959     {
1960         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1961         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1962         assembly {
1963             approvedAddressSlot := tokenApproval.slot
1964             approvedAddress := sload(approvedAddressSlot)
1965         }
1966     }
1967 
1968     // =============================================================
1969     //                      TRANSFER OPERATIONS
1970     // =============================================================
1971 
1972     /**
1973      * @dev Transfers `tokenId` from `from` to `to`.
1974      *
1975      * Requirements:
1976      *
1977      * - `from` cannot be the zero address.
1978      * - `to` cannot be the zero address.
1979      * - `tokenId` token must be owned by `from`.
1980      * - If the caller is not `from`, it must be approved to move this token
1981      * by either {approve} or {setApprovalForAll}.
1982      *
1983      * Emits a {Transfer} event.
1984      */
1985     function transferFrom(
1986         address from,
1987         address to,
1988         uint256 tokenId
1989     ) public payable virtual override {
1990         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1991 
1992         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1993 
1994         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1995 
1996         // The nested ifs save around 20+ gas over a compound boolean condition.
1997         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1998             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1999 
2000         if (to == address(0)) revert TransferToZeroAddress();
2001 
2002         _beforeTokenTransfers(from, to, tokenId, 1);
2003 
2004         // Clear approvals from the previous owner.
2005         assembly {
2006             if approvedAddress {
2007                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2008                 sstore(approvedAddressSlot, 0)
2009             }
2010         }
2011 
2012         // Underflow of the sender's balance is impossible because we check for
2013         // ownership above and the recipient's balance can't realistically overflow.
2014         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2015         unchecked {
2016             // We can directly increment and decrement the balances.
2017             --_packedAddressData[from]; // Updates: `balance -= 1`.
2018             ++_packedAddressData[to]; // Updates: `balance += 1`.
2019 
2020             // Updates:
2021             // - `address` to the next owner.
2022             // - `startTimestamp` to the timestamp of transfering.
2023             // - `burned` to `false`.
2024             // - `nextInitialized` to `true`.
2025             _packedOwnerships[tokenId] = _packOwnershipData(
2026                 to,
2027                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2028             );
2029 
2030             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2031             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2032                 uint256 nextTokenId = tokenId + 1;
2033                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2034                 if (_packedOwnerships[nextTokenId] == 0) {
2035                     // If the next slot is within bounds.
2036                     if (nextTokenId != _currentIndex) {
2037                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2038                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2039                     }
2040                 }
2041             }
2042         }
2043 
2044         emit Transfer(from, to, tokenId);
2045         _afterTokenTransfers(from, to, tokenId, 1);
2046     }
2047 
2048     /**
2049      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2050      */
2051     function safeTransferFrom(
2052         address from,
2053         address to,
2054         uint256 tokenId
2055     ) public payable virtual override {
2056         safeTransferFrom(from, to, tokenId, '');
2057     }
2058 
2059     /**
2060      * @dev Safely transfers `tokenId` token from `from` to `to`.
2061      *
2062      * Requirements:
2063      *
2064      * - `from` cannot be the zero address.
2065      * - `to` cannot be the zero address.
2066      * - `tokenId` token must exist and be owned by `from`.
2067      * - If the caller is not `from`, it must be approved to move this token
2068      * by either {approve} or {setApprovalForAll}.
2069      * - If `to` refers to a smart contract, it must implement
2070      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2071      *
2072      * Emits a {Transfer} event.
2073      */
2074     function safeTransferFrom(
2075         address from,
2076         address to,
2077         uint256 tokenId,
2078         bytes memory _data
2079     ) public payable virtual override {
2080         transferFrom(from, to, tokenId);
2081         if (to.code.length != 0)
2082             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2083                 revert TransferToNonERC721ReceiverImplementer();
2084             }
2085     }
2086 
2087     /**
2088      * @dev Hook that is called before a set of serially-ordered token IDs
2089      * are about to be transferred. This includes minting.
2090      * And also called before burning one token.
2091      *
2092      * `startTokenId` - the first token ID to be transferred.
2093      * `quantity` - the amount to be transferred.
2094      *
2095      * Calling conditions:
2096      *
2097      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2098      * transferred to `to`.
2099      * - When `from` is zero, `tokenId` will be minted for `to`.
2100      * - When `to` is zero, `tokenId` will be burned by `from`.
2101      * - `from` and `to` are never both zero.
2102      */
2103     function _beforeTokenTransfers(
2104         address from,
2105         address to,
2106         uint256 startTokenId,
2107         uint256 quantity
2108     ) internal virtual {}
2109 
2110     /**
2111      * @dev Hook that is called after a set of serially-ordered token IDs
2112      * have been transferred. This includes minting.
2113      * And also called after one token has been burned.
2114      *
2115      * `startTokenId` - the first token ID to be transferred.
2116      * `quantity` - the amount to be transferred.
2117      *
2118      * Calling conditions:
2119      *
2120      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2121      * transferred to `to`.
2122      * - When `from` is zero, `tokenId` has been minted for `to`.
2123      * - When `to` is zero, `tokenId` has been burned by `from`.
2124      * - `from` and `to` are never both zero.
2125      */
2126     function _afterTokenTransfers(
2127         address from,
2128         address to,
2129         uint256 startTokenId,
2130         uint256 quantity
2131     ) internal virtual {}
2132 
2133     /**
2134      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2135      *
2136      * `from` - Previous owner of the given token ID.
2137      * `to` - Target address that will receive the token.
2138      * `tokenId` - Token ID to be transferred.
2139      * `_data` - Optional data to send along with the call.
2140      *
2141      * Returns whether the call correctly returned the expected magic value.
2142      */
2143     function _checkContractOnERC721Received(
2144         address from,
2145         address to,
2146         uint256 tokenId,
2147         bytes memory _data
2148     ) private returns (bool) {
2149         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2150             bytes4 retval
2151         ) {
2152             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2153         } catch (bytes memory reason) {
2154             if (reason.length == 0) {
2155                 revert TransferToNonERC721ReceiverImplementer();
2156             } else {
2157                 assembly {
2158                     revert(add(32, reason), mload(reason))
2159                 }
2160             }
2161         }
2162     }
2163 
2164     // =============================================================
2165     //                        MINT OPERATIONS
2166     // =============================================================
2167 
2168     /**
2169      * @dev Mints `quantity` tokens and transfers them to `to`.
2170      *
2171      * Requirements:
2172      *
2173      * - `to` cannot be the zero address.
2174      * - `quantity` must be greater than 0.
2175      *
2176      * Emits a {Transfer} event for each mint.
2177      */
2178     function _mint(address to, uint256 quantity) internal virtual {
2179         uint256 startTokenId = _currentIndex;
2180         if (quantity == 0) revert MintZeroQuantity();
2181 
2182         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2183 
2184         // Overflows are incredibly unrealistic.
2185         // `balance` and `numberMinted` have a maximum limit of 2**64.
2186         // `tokenId` has a maximum limit of 2**256.
2187         unchecked {
2188             // Updates:
2189             // - `balance += quantity`.
2190             // - `numberMinted += quantity`.
2191             //
2192             // We can directly add to the `balance` and `numberMinted`.
2193             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2194 
2195             // Updates:
2196             // - `address` to the owner.
2197             // - `startTimestamp` to the timestamp of minting.
2198             // - `burned` to `false`.
2199             // - `nextInitialized` to `quantity == 1`.
2200             _packedOwnerships[startTokenId] = _packOwnershipData(
2201                 to,
2202                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2203             );
2204 
2205             uint256 toMasked;
2206             uint256 end = startTokenId + quantity;
2207 
2208             // Use assembly to loop and emit the `Transfer` event for gas savings.
2209             // The duplicated `log4` removes an extra check and reduces stack juggling.
2210             // The assembly, together with the surrounding Solidity code, have been
2211             // delicately arranged to nudge the compiler into producing optimized opcodes.
2212             assembly {
2213                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2214                 toMasked := and(to, _BITMASK_ADDRESS)
2215                 // Emit the `Transfer` event.
2216                 log4(
2217                     0, // Start of data (0, since no data).
2218                     0, // End of data (0, since no data).
2219                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2220                     0, // `address(0)`.
2221                     toMasked, // `to`.
2222                     startTokenId // `tokenId`.
2223                 )
2224 
2225                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2226                 // that overflows uint256 will make the loop run out of gas.
2227                 // The compiler will optimize the `iszero` away for performance.
2228                 for {
2229                     let tokenId := add(startTokenId, 1)
2230                 } iszero(eq(tokenId, end)) {
2231                     tokenId := add(tokenId, 1)
2232                 } {
2233                     // Emit the `Transfer` event. Similar to above.
2234                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2235                 }
2236             }
2237             if (toMasked == 0) revert MintToZeroAddress();
2238 
2239             _currentIndex = end;
2240         }
2241         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2242     }
2243 
2244     /**
2245      * @dev Mints `quantity` tokens and transfers them to `to`.
2246      *
2247      * This function is intended for efficient minting only during contract creation.
2248      *
2249      * It emits only one {ConsecutiveTransfer} as defined in
2250      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2251      * instead of a sequence of {Transfer} event(s).
2252      *
2253      * Calling this function outside of contract creation WILL make your contract
2254      * non-compliant with the ERC721 standard.
2255      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2256      * {ConsecutiveTransfer} event is only permissible during contract creation.
2257      *
2258      * Requirements:
2259      *
2260      * - `to` cannot be the zero address.
2261      * - `quantity` must be greater than 0.
2262      *
2263      * Emits a {ConsecutiveTransfer} event.
2264      */
2265     function _mintERC2309(address to, uint256 quantity) internal virtual {
2266         uint256 startTokenId = _currentIndex;
2267         if (to == address(0)) revert MintToZeroAddress();
2268         if (quantity == 0) revert MintZeroQuantity();
2269         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2270 
2271         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2272 
2273         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2274         unchecked {
2275             // Updates:
2276             // - `balance += quantity`.
2277             // - `numberMinted += quantity`.
2278             //
2279             // We can directly add to the `balance` and `numberMinted`.
2280             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2281 
2282             // Updates:
2283             // - `address` to the owner.
2284             // - `startTimestamp` to the timestamp of minting.
2285             // - `burned` to `false`.
2286             // - `nextInitialized` to `quantity == 1`.
2287             _packedOwnerships[startTokenId] = _packOwnershipData(
2288                 to,
2289                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2290             );
2291 
2292             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2293 
2294             _currentIndex = startTokenId + quantity;
2295         }
2296         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2297     }
2298 
2299     /**
2300      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2301      *
2302      * Requirements:
2303      *
2304      * - If `to` refers to a smart contract, it must implement
2305      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2306      * - `quantity` must be greater than 0.
2307      *
2308      * See {_mint}.
2309      *
2310      * Emits a {Transfer} event for each mint.
2311      */
2312     function _safeMint(
2313         address to,
2314         uint256 quantity,
2315         bytes memory _data
2316     ) internal virtual {
2317         _mint(to, quantity);
2318 
2319         unchecked {
2320             if (to.code.length != 0) {
2321                 uint256 end = _currentIndex;
2322                 uint256 index = end - quantity;
2323                 do {
2324                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2325                         revert TransferToNonERC721ReceiverImplementer();
2326                     }
2327                 } while (index < end);
2328                 // Reentrancy protection.
2329                 if (_currentIndex != end) revert();
2330             }
2331         }
2332     }
2333 
2334     /**
2335      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2336      */
2337     function _safeMint(address to, uint256 quantity) internal virtual {
2338         _safeMint(to, quantity, '');
2339     }
2340 
2341     // =============================================================
2342     //                        BURN OPERATIONS
2343     // =============================================================
2344 
2345     /**
2346      * @dev Equivalent to `_burn(tokenId, false)`.
2347      */
2348     function _burn(uint256 tokenId) internal virtual {
2349         _burn(tokenId, false);
2350     }
2351 
2352     /**
2353      * @dev Destroys `tokenId`.
2354      * The approval is cleared when the token is burned.
2355      *
2356      * Requirements:
2357      *
2358      * - `tokenId` must exist.
2359      *
2360      * Emits a {Transfer} event.
2361      */
2362     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2363         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2364 
2365         address from = address(uint160(prevOwnershipPacked));
2366 
2367         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2368 
2369         if (approvalCheck) {
2370             // The nested ifs save around 20+ gas over a compound boolean condition.
2371             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2372                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2373         }
2374 
2375         _beforeTokenTransfers(from, address(0), tokenId, 1);
2376 
2377         // Clear approvals from the previous owner.
2378         assembly {
2379             if approvedAddress {
2380                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2381                 sstore(approvedAddressSlot, 0)
2382             }
2383         }
2384 
2385         // Underflow of the sender's balance is impossible because we check for
2386         // ownership above and the recipient's balance can't realistically overflow.
2387         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2388         unchecked {
2389             // Updates:
2390             // - `balance -= 1`.
2391             // - `numberBurned += 1`.
2392             //
2393             // We can directly decrement the balance, and increment the number burned.
2394             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2395             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2396 
2397             // Updates:
2398             // - `address` to the last owner.
2399             // - `startTimestamp` to the timestamp of burning.
2400             // - `burned` to `true`.
2401             // - `nextInitialized` to `true`.
2402             _packedOwnerships[tokenId] = _packOwnershipData(
2403                 from,
2404                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2405             );
2406 
2407             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2408             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2409                 uint256 nextTokenId = tokenId + 1;
2410                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2411                 if (_packedOwnerships[nextTokenId] == 0) {
2412                     // If the next slot is within bounds.
2413                     if (nextTokenId != _currentIndex) {
2414                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2415                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2416                     }
2417                 }
2418             }
2419         }
2420 
2421         emit Transfer(from, address(0), tokenId);
2422         _afterTokenTransfers(from, address(0), tokenId, 1);
2423 
2424         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2425         unchecked {
2426             _burnCounter++;
2427         }
2428     }
2429 
2430     // =============================================================
2431     //                     EXTRA DATA OPERATIONS
2432     // =============================================================
2433 
2434     /**
2435      * @dev Directly sets the extra data for the ownership data `index`.
2436      */
2437     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2438         uint256 packed = _packedOwnerships[index];
2439         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2440         uint256 extraDataCasted;
2441         // Cast `extraData` with assembly to avoid redundant masking.
2442         assembly {
2443             extraDataCasted := extraData
2444         }
2445         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2446         _packedOwnerships[index] = packed;
2447     }
2448 
2449     /**
2450      * @dev Called during each token transfer to set the 24bit `extraData` field.
2451      * Intended to be overridden by the cosumer contract.
2452      *
2453      * `previousExtraData` - the value of `extraData` before transfer.
2454      *
2455      * Calling conditions:
2456      *
2457      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2458      * transferred to `to`.
2459      * - When `from` is zero, `tokenId` will be minted for `to`.
2460      * - When `to` is zero, `tokenId` will be burned by `from`.
2461      * - `from` and `to` are never both zero.
2462      */
2463     function _extraData(
2464         address from,
2465         address to,
2466         uint24 previousExtraData
2467     ) internal view virtual returns (uint24) {}
2468 
2469     /**
2470      * @dev Returns the next extra data for the packed ownership data.
2471      * The returned result is shifted into position.
2472      */
2473     function _nextExtraData(
2474         address from,
2475         address to,
2476         uint256 prevOwnershipPacked
2477     ) private view returns (uint256) {
2478         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2479         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2480     }
2481 
2482     // =============================================================
2483     //                       OTHER OPERATIONS
2484     // =============================================================
2485 
2486     /**
2487      * @dev Returns the message sender (defaults to `msg.sender`).
2488      *
2489      * If you are writing GSN compatible contracts, you need to override this function.
2490      */
2491     function _msgSenderERC721A() internal view virtual returns (address) {
2492         return msg.sender;
2493     }
2494 
2495     /**
2496      * @dev Converts a uint256 to its ASCII string decimal representation.
2497      */
2498     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2499         assembly {
2500             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2501             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2502             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2503             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2504             let m := add(mload(0x40), 0xa0)
2505             // Update the free memory pointer to allocate.
2506             mstore(0x40, m)
2507             // Assign the `str` to the end.
2508             str := sub(m, 0x20)
2509             // Zeroize the slot after the string.
2510             mstore(str, 0)
2511 
2512             // Cache the end of the memory to calculate the length later.
2513             let end := str
2514 
2515             // We write the string from rightmost digit to leftmost digit.
2516             // The following is essentially a do-while loop that also handles the zero case.
2517             // prettier-ignore
2518             for { let temp := value } 1 {} {
2519                 str := sub(str, 1)
2520                 // Write the character to the pointer.
2521                 // The ASCII index of the '0' character is 48.
2522                 mstore8(str, add(48, mod(temp, 10)))
2523                 // Keep dividing `temp` until zero.
2524                 temp := div(temp, 10)
2525                 // prettier-ignore
2526                 if iszero(temp) { break }
2527             }
2528 
2529             let length := sub(end, str)
2530             // Move the pointer 32 bytes leftwards to make room for the length.
2531             str := sub(str, 0x20)
2532             // Store the length.
2533             mstore(str, length)
2534         }
2535     }
2536 }
2537 
2538 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2539 
2540 
2541 // ERC721A Contracts v4.2.3
2542 // Creator: Chiru Labs
2543 
2544 pragma solidity ^0.8.4;
2545 
2546 
2547 
2548 /**
2549  * @title ERC721AQueryable.
2550  *
2551  * @dev ERC721A subclass with convenience query functions.
2552  */
2553 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2554     /**
2555      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2556      *
2557      * If the `tokenId` is out of bounds:
2558      *
2559      * - `addr = address(0)`
2560      * - `startTimestamp = 0`
2561      * - `burned = false`
2562      * - `extraData = 0`
2563      *
2564      * If the `tokenId` is burned:
2565      *
2566      * - `addr = <Address of owner before token was burned>`
2567      * - `startTimestamp = <Timestamp when token was burned>`
2568      * - `burned = true`
2569      * - `extraData = <Extra data when token was burned>`
2570      *
2571      * Otherwise:
2572      *
2573      * - `addr = <Address of owner>`
2574      * - `startTimestamp = <Timestamp of start of ownership>`
2575      * - `burned = false`
2576      * - `extraData = <Extra data at start of ownership>`
2577      */
2578     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2579         TokenOwnership memory ownership;
2580         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2581             return ownership;
2582         }
2583         ownership = _ownershipAt(tokenId);
2584         if (ownership.burned) {
2585             return ownership;
2586         }
2587         return _ownershipOf(tokenId);
2588     }
2589 
2590     /**
2591      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2592      * See {ERC721AQueryable-explicitOwnershipOf}
2593      */
2594     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2595         external
2596         view
2597         virtual
2598         override
2599         returns (TokenOwnership[] memory)
2600     {
2601         unchecked {
2602             uint256 tokenIdsLength = tokenIds.length;
2603             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2604             for (uint256 i; i != tokenIdsLength; ++i) {
2605                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2606             }
2607             return ownerships;
2608         }
2609     }
2610 
2611     /**
2612      * @dev Returns an array of token IDs owned by `owner`,
2613      * in the range [`start`, `stop`)
2614      * (i.e. `start <= tokenId < stop`).
2615      *
2616      * This function allows for tokens to be queried if the collection
2617      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2618      *
2619      * Requirements:
2620      *
2621      * - `start < stop`
2622      */
2623     function tokensOfOwnerIn(
2624         address owner,
2625         uint256 start,
2626         uint256 stop
2627     ) external view virtual override returns (uint256[] memory) {
2628         unchecked {
2629             if (start >= stop) revert InvalidQueryRange();
2630             uint256 tokenIdsIdx;
2631             uint256 stopLimit = _nextTokenId();
2632             // Set `start = max(start, _startTokenId())`.
2633             if (start < _startTokenId()) {
2634                 start = _startTokenId();
2635             }
2636             // Set `stop = min(stop, stopLimit)`.
2637             if (stop > stopLimit) {
2638                 stop = stopLimit;
2639             }
2640             uint256 tokenIdsMaxLength = balanceOf(owner);
2641             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2642             // to cater for cases where `balanceOf(owner)` is too big.
2643             if (start < stop) {
2644                 uint256 rangeLength = stop - start;
2645                 if (rangeLength < tokenIdsMaxLength) {
2646                     tokenIdsMaxLength = rangeLength;
2647                 }
2648             } else {
2649                 tokenIdsMaxLength = 0;
2650             }
2651             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2652             if (tokenIdsMaxLength == 0) {
2653                 return tokenIds;
2654             }
2655             // We need to call `explicitOwnershipOf(start)`,
2656             // because the slot at `start` may not be initialized.
2657             TokenOwnership memory ownership = explicitOwnershipOf(start);
2658             address currOwnershipAddr;
2659             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2660             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2661             if (!ownership.burned) {
2662                 currOwnershipAddr = ownership.addr;
2663             }
2664             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2665                 ownership = _ownershipAt(i);
2666                 if (ownership.burned) {
2667                     continue;
2668                 }
2669                 if (ownership.addr != address(0)) {
2670                     currOwnershipAddr = ownership.addr;
2671                 }
2672                 if (currOwnershipAddr == owner) {
2673                     tokenIds[tokenIdsIdx++] = i;
2674                 }
2675             }
2676             // Downsize the array to fit.
2677             assembly {
2678                 mstore(tokenIds, tokenIdsIdx)
2679             }
2680             return tokenIds;
2681         }
2682     }
2683 
2684     /**
2685      * @dev Returns an array of token IDs owned by `owner`.
2686      *
2687      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2688      * It is meant to be called off-chain.
2689      *
2690      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2691      * multiple smaller scans if the collection is large enough to cause
2692      * an out-of-gas error (10K collections should be fine).
2693      */
2694     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2695         unchecked {
2696             uint256 tokenIdsIdx;
2697             address currOwnershipAddr;
2698             uint256 tokenIdsLength = balanceOf(owner);
2699             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2700             TokenOwnership memory ownership;
2701             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2702                 ownership = _ownershipAt(i);
2703                 if (ownership.burned) {
2704                     continue;
2705                 }
2706                 if (ownership.addr != address(0)) {
2707                     currOwnershipAddr = ownership.addr;
2708                 }
2709                 if (currOwnershipAddr == owner) {
2710                     tokenIds[tokenIdsIdx++] = i;
2711                 }
2712             }
2713             return tokenIds;
2714         }
2715     }
2716 }
2717 
2718 // File: contracts/DeviantsCrimsonPass.sol
2719 
2720 
2721 pragma solidity ^0.8.4;
2722 
2723 
2724 
2725 
2726 
2727 
2728 
2729 
2730  /**
2731   * @title DeviantsCrimsonPass
2732   * @dev The contract allows users to mint:
2733   * For each Silver Mint Pass - Mint 2 crimson pass
2734   * For each Diamond Mint Pass- Mint 3 crimson pass
2735   * For each Gold Mint Pass- Mint 4 crimson pass
2736   * @dev The contract has 2 phases, Phase1 sale and Phase2.
2737   * @dev The contract uses a Merkle proof to validate that an address is whitelisted.
2738   * @dev The contract also has an owner who have the privilages to set the state of the contract and withdraw erc20 native tokens.
2739   */
2740 contract DeviantsCrimsonPass is ERC721A, ERC721AQueryable, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2741     using Strings for uint256;
2742 
2743     /** 
2744      * @dev Set max supply for the DeviantsCrimsonPass collection
2745      */
2746     uint256 public constant maxSupply = 2222;
2747 
2748     /** 
2749      * @dev Set max amount of NFTs per address for wihitelist and waitlist address
2750      */
2751     uint256 public constant maxMintPerWLWallet = 2;
2752 
2753     /** 
2754      * @dev Set cost for NFT minted 
2755      */
2756     uint256 public constant price = 0.004 ether;
2757 
2758     /** 
2759      * @dev Set whitelist mintPhase1 period and public mintPhase2 period
2760      */
2761     uint256 public constant startPhase1 = 1677330000;
2762     uint256 public constant endPhase1 = 1677416400;
2763     uint256 public constant startPhase2 = 1677416401;
2764     uint256 public constant endPhase2 = 1677459601;
2765 
2766     /** 
2767      * @dev A boolean that indicates whether the MintPhase1 function is paused or not.
2768      */
2769     bool public pausePhase1 = true;
2770 
2771     /** 
2772      * @dev A boolean that indicates whether the MintPhase2 function is paused or not.
2773      */
2774     bool public pausePhase2 = true;
2775 
2776     /** 
2777      * @dev A boolean that indicates whether the contract isindicates is paused or not.
2778      */
2779     bool public globalPause = false;
2780 
2781     /**
2782      * @dev The root of the Merkle tree that is used for whitelist check.
2783      */
2784     bytes32 public merkleRoot;
2785 
2786     /**
2787      * @dev The account that recive the money from the mints.
2788      */
2789     address public payerAccount;
2790 
2791 
2792     /**
2793      * @dev Define three ERC721A contracts 
2794      */
2795     ERC721A public deviantsSilverPassCollection; 
2796     ERC721A public deviantsDiamondPassCollection;
2797     ERC721A public deviantsGoldPassCollection;
2798     
2799     /** 
2800      * @dev Prefix for tokens metadata URIs
2801      */
2802     string public baseURI;
2803 
2804     /** 
2805      * @dev Sufix for tokens metadata URIs
2806      */
2807     string public uriSuffix = '.json';
2808 
2809     /**
2810      * @dev A mapping that stores if the user minted a crimson or not.
2811      */
2812     mapping(address => uint256) public addressWLMintedAmount;
2813 
2814     /**
2815      * @dev A mapping that stores how many nfts did the user minted through those held
2816      */
2817     mapping(address => uint256) public holderMintedAmount;
2818 
2819     /**
2820      * @dev Emits an event when an NFT is minted in Phase1 period.
2821      * @param minterAddress The address of the user who executed the mint.
2822      * @param amount The amount of NFTs minted.
2823      */
2824     event MintPhase1(
2825         address indexed minterAddress,
2826         uint256 amount
2827     );
2828 
2829     /**
2830      * @dev Emits an event when an NFT is minted in Phase2 period.
2831      * @param minterAddress The address of the user who executed the mint.
2832      * @param amount The amount of NFTs minted.
2833      */
2834     event MintPhase2(
2835         address indexed minterAddress,
2836         uint256 amount
2837     );
2838 
2839     /**
2840      * @dev Emits an event when owner mint a batch.
2841      * @param owner The addresses who is the contract owner.
2842      * @param addresses The addresses array.
2843      * @param amount The amount of NFTs minted for each address.
2844      */
2845     event MintBatch(
2846         address indexed owner,
2847         address[] addresses,
2848         uint256 amount
2849     );
2850     
2851     /**
2852      * @dev Emits an event when owner mint a batch.
2853      * @param owner The addresses who is the contract owner.
2854      * @param amount The amount of native tokens withdrawn.
2855      */
2856     event Withdraw(
2857         address indexed owner,
2858         uint256 amount
2859     );
2860 
2861     /**
2862      * @dev Constructor function that sets the initial values for the contract's variables.
2863      * @param _merkleRoot The root of the Merkle tree.
2864      * @param uri The metadata URI prefix.
2865      * @param _payerAccount The account that can withdraw funds from the contract.
2866      * @param _deviantsSilverPassCollection Silver collection address.
2867      * @param _deviantsDiamondPassCollection Dimond collection address.
2868      * @param _deviantsGoldPassCollection Gold collection address.
2869      */
2870     constructor(
2871         bytes32 _merkleRoot,
2872         string  memory uri,
2873         address _payerAccount,
2874         ERC721A _deviantsSilverPassCollection,
2875         ERC721A _deviantsDiamondPassCollection,
2876         ERC721A _deviantsGoldPassCollection
2877     ) ERC721A("Deviants Crimson Mint Pass", "DMPC") {
2878         merkleRoot = _merkleRoot;
2879         baseURI = uri;
2880         payerAccount = _payerAccount;
2881         deviantsSilverPassCollection = _deviantsSilverPassCollection;
2882         deviantsDiamondPassCollection = _deviantsDiamondPassCollection;
2883         deviantsGoldPassCollection = _deviantsGoldPassCollection; 
2884     }
2885 
2886     /**
2887       * @dev mintPhase1 creates NFT tokens for for users who own NFTs from previous collections or are on whitelist.
2888       * @param _mintAmount the amount of NFT tokens to mint.
2889       * @param _merkleProof the proof of user's whitelist status.
2890       * @notice Throws if:
2891       * - mintPhase1 closed if the function is called outside of the mintPhase1 period or if the contract is paused.
2892       * - maxSupply exceeded if the minted amount exceeds the maxSupply.
2893       * - the amount of nfts that the user can mint is determined by the number of nfts held from previous collections and if it is on the whitelist
2894       * - user must send the exact price.
2895       */
2896     function mintPhase1(uint256 _mintAmount,bytes32[] calldata _merkleProof) external payable nonReentrant{
2897         require(!globalPause,"DMPC: contract is paused");
2898         require((block.timestamp >= startPhase1 && block.timestamp <= endPhase1 ) || !pausePhase1, "DMPC: Phase1 closed");
2899         require(totalSupply() + _mintAmount <= maxSupply, "DMPC: maxSupply exceeded");
2900         require(_mintAmount > 0 , "DMPC: cannot mint 0");
2901         require(msg.value == price * _mintAmount,"DMPC: user must send the exact price");
2902 
2903         uint256 maxCrimsonMintAmount = deviantsSilverPassCollection.balanceOf(msg.sender) * 2 + deviantsDiamondPassCollection.balanceOf(msg.sender) * 3 + deviantsGoldPassCollection.balanceOf(msg.sender) * 4;
2904         bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender))));
2905         bool eligibleWL = MerkleProof.verify(_merkleProof, merkleRoot, leaf);
2906 
2907         if(maxCrimsonMintAmount>0 && eligibleWL==false){
2908             require(holderMintedAmount[msg.sender] + _mintAmount <= maxCrimsonMintAmount,"DMPC: user already minted more than Hold amount"); 
2909 
2910             holderMintedAmount[msg.sender] +=_mintAmount;
2911             _safeMint(msg.sender,_mintAmount);
2912         }
2913         else if(maxCrimsonMintAmount>0 && eligibleWL){
2914             require(holderMintedAmount[msg.sender] + addressWLMintedAmount[msg.sender] + _mintAmount <= maxCrimsonMintAmount + maxMintPerWLWallet,"DMPC: user already minted more than Hold amount + WL alocation"); 
2915             uint256 holderLeft = maxCrimsonMintAmount - holderMintedAmount[msg.sender];
2916 
2917             if(_mintAmount <= holderLeft){
2918                 holderMintedAmount[msg.sender] += _mintAmount;
2919 
2920                 _safeMint(msg.sender,_mintAmount);
2921             } else {
2922                 holderMintedAmount[msg.sender] += holderLeft;
2923                 addressWLMintedAmount[msg.sender] += (_mintAmount - holderLeft);
2924 
2925                 _safeMint(msg.sender,_mintAmount);
2926             }
2927          
2928         } else if(eligibleWL){
2929             require(addressWLMintedAmount[msg.sender] + _mintAmount <=maxMintPerWLWallet,"DMPC: user already minted more than WL amount");
2930             addressWLMintedAmount[msg.sender] += _mintAmount; 
2931             
2932             _safeMint(msg.sender,_mintAmount);
2933         }
2934 
2935         else revert("DMPC: user not a holder or on WL");
2936 
2937         emit MintPhase1(msg.sender, _mintAmount);      
2938     } 
2939 
2940     /**
2941      * @dev Mints NFTs in the mintPhase2
2942      * @param _mintAmount The number of NFTs to mint (1 or 2).
2943      * @param _merkleProof the proof of user's whitelist status.
2944      * @notice Throws if:
2945      * - mintPhase2 period has ended or the contract is paused.
2946      * - The maximum supply of NFTs is exceeded.
2947      * - The `_mintAmount` is not 1 or 2.
2948      * - The user tries to mint more than 2 NFTs.
2949      * - The user tries to mint 2 NFTs but does not send the exact price.
2950      * - The user tries to mint 1 NFT but sends more than the exact price.
2951      * - The user is not on whitelist.
2952      */
2953     function mintPhase2(uint256 _mintAmount,bytes32[] calldata _merkleProof) external payable nonReentrant{
2954         require(!globalPause,"DMPC: contract is paused");
2955         require((block.timestamp >= startPhase2 && block.timestamp <= endPhase2) || !pausePhase2 ,"DMPC: Phase2 sale closed");
2956         require(_mintAmount == 1 || _mintAmount == 2, "DMPC: mintAmount must be 1 or 2");
2957         require(totalSupply() + _mintAmount <= maxSupply,"DMPC: maxSupply exceeded");
2958         require(addressWLMintedAmount[msg.sender] + _mintAmount <= maxMintPerWLWallet ,"DMPC: user cannot mint more then 2 NFT" );
2959         require(msg.value == price * _mintAmount,"DMPC: user must send the exact price");
2960         bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender))));
2961         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "DMPC: Invalid proof");
2962         
2963         addressWLMintedAmount[msg.sender] += _mintAmount;
2964         _safeMint(msg.sender,_mintAmount);
2965         emit MintPhase2(msg.sender, _mintAmount);     
2966     }
2967 
2968     /**
2969      * @dev Function to mint a batch of NFTs to multiple addresses
2970      * @param addresses An array of addresses to mint NFTs to
2971      * @param _mintAmounts The amount of NFTs to mint to each address
2972      * @notice Only the contract owner can call this function.
2973      */
2974     function mintBatch(address[] memory addresses, uint256 _mintAmounts) external onlyOwner{
2975         require(totalSupply() + addresses.length * _mintAmounts <= maxSupply,"DMPC: maxSupply exceeded");
2976 
2977         for(uint256 i = 0;i < addresses.length; i++){
2978             _safeMint(addresses[i],_mintAmounts);
2979         }
2980 
2981         emit MintBatch(msg.sender, addresses, _mintAmounts);
2982     }
2983 
2984     /**
2985      * @dev Sets the Merkle root on the contract
2986      * @param _merkleRoot bytes32: the Merkle root to be set
2987      * @notice Only the contract owner can call this function.
2988      */
2989     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
2990         merkleRoot = _merkleRoot;
2991     }
2992     
2993     /**
2994      * @dev This function sets the base URI of the NFT contract.
2995      * @param uri The new base URI of the NFT contract.
2996      * @notice Only the contract owner can call this function.
2997      */
2998     function setBasedURI(string memory uri) external onlyOwner{
2999         baseURI = uri;
3000     }
3001 
3002     /**
3003      * @dev Set the pause state of the contract for the WL Sale, only the contract owner can set the pause state
3004      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
3005      */
3006     function setpausePhase1(bool state) external onlyOwner{
3007         pausePhase1 = state;
3008     }
3009 
3010     /**
3011      * @dev Set the pause state of the contract for the PB Sale, only the contract owner can set the pause state
3012      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
3013      */
3014     function setpausePhase2(bool state) external onlyOwner{
3015         pausePhase2 = state;
3016     }
3017 
3018     /**
3019      * @dev Set the global pause state of the contract, only the contract owner can set the pause state
3020      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
3021      */
3022     function setGlobalPause(bool state) external onlyOwner{
3023         globalPause = state;
3024     }
3025 
3026     /**
3027      * @dev Sets the uriSuffix for the ERC-721 token metadata.
3028      * @param _uriSuffix The new uriSuffix to be set.
3029      */
3030     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
3031         uriSuffix = _uriSuffix;
3032     }
3033 
3034     /**
3035      * @dev Sets the payerAccount.
3036      * @param _payerAccount The new payerAccount.
3037      */
3038     function setPayerAccount(address _payerAccount) public onlyOwner {
3039         payerAccount = _payerAccount;
3040     }
3041 
3042     /**
3043      * setters for deviantsPASS Addresses;
3044      */
3045     function setDeviantsSilverPassCollection(ERC721A _deviantsSilverPassColeection) external onlyOwner{
3046         deviantsSilverPassCollection = _deviantsSilverPassColeection;
3047     }
3048 
3049     function setDeviantsDiamondPassCollection(ERC721A _deviantsDiamondPassColeection) external onlyOwner{
3050         deviantsDiamondPassCollection = _deviantsDiamondPassColeection;
3051     }
3052 
3053     function setDeviantsGoldPassCollection(ERC721A _deviantsGoldPassColeection) external onlyOwner{
3054         deviantsGoldPassCollection = _deviantsGoldPassColeection;
3055     }
3056 
3057     /**
3058      * @dev Returns the state of the Phase1 sale (true if is open, false if is closed)
3059      */
3060     function getPhase1Status() public view returns(bool){
3061         if((block.timestamp >= startPhase1 && block.timestamp <= endPhase1) || !pausePhase1) {
3062             return true;
3063         }else{
3064             return false;
3065         }
3066     }
3067     
3068     /**
3069      * @dev Returns the state of the Phase2 sale (true if is open, false if is closed)
3070      */
3071     function getPhase2Status() public view returns(bool){
3072         if((block.timestamp >= startPhase2 && block.timestamp <= endPhase2) || !pausePhase2) {
3073             return true;
3074         }else{
3075             return false;
3076         }
3077     }
3078 
3079     /**
3080      * @dev Returns total balance returns the total balance of nfts held(Silver + Dimond + Gold)
3081      */
3082 
3083     function getHolderStatus(address holder) public view returns(uint256){
3084         uint256 maxCrimsonMintAmount = deviantsSilverPassCollection.balanceOf(holder) * 2 + deviantsDiamondPassCollection.balanceOf(holder) * 3 + deviantsGoldPassCollection.balanceOf(holder) * 4;
3085         return maxCrimsonMintAmount - holderMintedAmount[holder];
3086     }
3087 
3088     
3089     /**
3090      * Transfers the total native coin balance to contract's owner account.
3091      * The balance must be > 0 so a zero transfer is avoided.
3092      * 
3093      * Access: Contract Owner
3094      */
3095     function withdraw() public nonReentrant {
3096         require(msg.sender == owner() || msg.sender == payerAccount, "DMPC: can be called only with the owner or payerAccount");
3097         uint256 balance = address(this).balance;
3098         require(balance != 0, "DMPC: contract balance is zero");
3099         sendViaCall(payable(payerAccount), balance);
3100 
3101         emit Withdraw(msg.sender, balance);
3102     }
3103 
3104     /**
3105      * @dev Function to transfer coins (the native cryptocurrency of the platform, i.e.: ETH) 
3106      * from this contract to the specified address.
3107      *
3108      * @param _to the address to transfer the coins to
3109      * @param _amount amount (in wei)
3110      */
3111     function sendViaCall(address payable _to, uint256 _amount) private {
3112         (bool sent, ) = _to.call { value: _amount } ("");
3113         require(sent, "DMPC: failed to send amount");
3114     }
3115 
3116     /**
3117     * @dev Returns the starting token ID for the token.
3118     * @return uint256 The starting token ID for the token.
3119     */
3120     function _startTokenId() internal view virtual override returns (uint256) {
3121         return 1;
3122     }
3123 
3124     /**
3125      * @dev Returns the token URI for the given token ID. Throws if the token ID does not exist
3126      * @param _tokenId The token ID to retrieve the URI for
3127      * @notice Retrieve the URI for the given token ID
3128      * @return The token URI for the given token ID
3129      */
3130     function tokenURI(uint256 _tokenId) public view virtual override(ERC721A,IERC721A) returns (string memory) {
3131         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
3132 
3133         string memory currentBaseURI = _baseURI();
3134         return bytes(currentBaseURI).length > 0
3135             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
3136             : '';
3137     }
3138         
3139     /**
3140      * @dev Returns the current base URI.
3141      * @return The base URI of the contract.
3142      */
3143     function _baseURI() internal view virtual override returns (string memory) {
3144         return baseURI;
3145     }
3146 
3147     function setApprovalForAll(address operator, bool approved) public  override(ERC721A,IERC721A) onlyAllowedOperatorApproval(operator) {
3148         super.setApprovalForAll(operator, approved);
3149     }
3150 
3151     function approve(address operator, uint256 tokenId) public payable override(ERC721A,IERC721A) onlyAllowedOperatorApproval(operator) {
3152         super.approve(operator, tokenId);
3153     }
3154 
3155     function transferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A,IERC721A) onlyAllowedOperator(from) {
3156         super.transferFrom(from, to, tokenId);
3157     }
3158 
3159     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override(ERC721A,IERC721A) onlyAllowedOperator(from) {
3160         super.safeTransferFrom(from, to, tokenId);
3161     }
3162 
3163     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3164         public
3165         payable 
3166         override(ERC721A,IERC721A)
3167         onlyAllowedOperator(from)
3168     {
3169         super.safeTransferFrom(from, to, tokenId, data);
3170     }
3171 
3172 
3173 }