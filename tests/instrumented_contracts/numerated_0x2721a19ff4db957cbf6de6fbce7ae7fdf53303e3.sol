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
1364 // File: erc721a/contracts/ERC721A.sol
1365 
1366 
1367 // ERC721A Contracts v4.2.3
1368 // Creator: Chiru Labs
1369 
1370 pragma solidity ^0.8.4;
1371 
1372 
1373 /**
1374  * @dev Interface of ERC721 token receiver.
1375  */
1376 interface ERC721A__IERC721Receiver {
1377     function onERC721Received(
1378         address operator,
1379         address from,
1380         uint256 tokenId,
1381         bytes calldata data
1382     ) external returns (bytes4);
1383 }
1384 
1385 /**
1386  * @title ERC721A
1387  *
1388  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1389  * Non-Fungible Token Standard, including the Metadata extension.
1390  * Optimized for lower gas during batch mints.
1391  *
1392  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1393  * starting from `_startTokenId()`.
1394  *
1395  * Assumptions:
1396  *
1397  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1398  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1399  */
1400 contract ERC721A is IERC721A {
1401     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1402     struct TokenApprovalRef {
1403         address value;
1404     }
1405 
1406     // =============================================================
1407     //                           CONSTANTS
1408     // =============================================================
1409 
1410     // Mask of an entry in packed address data.
1411     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1412 
1413     // The bit position of `numberMinted` in packed address data.
1414     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1415 
1416     // The bit position of `numberBurned` in packed address data.
1417     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1418 
1419     // The bit position of `aux` in packed address data.
1420     uint256 private constant _BITPOS_AUX = 192;
1421 
1422     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1423     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1424 
1425     // The bit position of `startTimestamp` in packed ownership.
1426     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1427 
1428     // The bit mask of the `burned` bit in packed ownership.
1429     uint256 private constant _BITMASK_BURNED = 1 << 224;
1430 
1431     // The bit position of the `nextInitialized` bit in packed ownership.
1432     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1433 
1434     // The bit mask of the `nextInitialized` bit in packed ownership.
1435     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1436 
1437     // The bit position of `extraData` in packed ownership.
1438     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1439 
1440     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1441     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1442 
1443     // The mask of the lower 160 bits for addresses.
1444     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1445 
1446     // The maximum `quantity` that can be minted with {_mintERC2309}.
1447     // This limit is to prevent overflows on the address data entries.
1448     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1449     // is required to cause an overflow, which is unrealistic.
1450     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1451 
1452     // The `Transfer` event signature is given by:
1453     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1454     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1455         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1456 
1457     // =============================================================
1458     //                            STORAGE
1459     // =============================================================
1460 
1461     // The next token ID to be minted.
1462     uint256 private _currentIndex;
1463 
1464     // The number of tokens burned.
1465     uint256 private _burnCounter;
1466 
1467     // Token name
1468     string private _name;
1469 
1470     // Token symbol
1471     string private _symbol;
1472 
1473     // Mapping from token ID to ownership details
1474     // An empty struct value does not necessarily mean the token is unowned.
1475     // See {_packedOwnershipOf} implementation for details.
1476     //
1477     // Bits Layout:
1478     // - [0..159]   `addr`
1479     // - [160..223] `startTimestamp`
1480     // - [224]      `burned`
1481     // - [225]      `nextInitialized`
1482     // - [232..255] `extraData`
1483     mapping(uint256 => uint256) private _packedOwnerships;
1484 
1485     // Mapping owner address to address data.
1486     //
1487     // Bits Layout:
1488     // - [0..63]    `balance`
1489     // - [64..127]  `numberMinted`
1490     // - [128..191] `numberBurned`
1491     // - [192..255] `aux`
1492     mapping(address => uint256) private _packedAddressData;
1493 
1494     // Mapping from token ID to approved address.
1495     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1496 
1497     // Mapping from owner to operator approvals
1498     mapping(address => mapping(address => bool)) private _operatorApprovals;
1499 
1500     // =============================================================
1501     //                          CONSTRUCTOR
1502     // =============================================================
1503 
1504     constructor(string memory name_, string memory symbol_) {
1505         _name = name_;
1506         _symbol = symbol_;
1507         _currentIndex = _startTokenId();
1508     }
1509 
1510     // =============================================================
1511     //                   TOKEN COUNTING OPERATIONS
1512     // =============================================================
1513 
1514     /**
1515      * @dev Returns the starting token ID.
1516      * To change the starting token ID, please override this function.
1517      */
1518     function _startTokenId() internal view virtual returns (uint256) {
1519         return 0;
1520     }
1521 
1522     /**
1523      * @dev Returns the next token ID to be minted.
1524      */
1525     function _nextTokenId() internal view virtual returns (uint256) {
1526         return _currentIndex;
1527     }
1528 
1529     /**
1530      * @dev Returns the total number of tokens in existence.
1531      * Burned tokens will reduce the count.
1532      * To get the total number of tokens minted, please see {_totalMinted}.
1533      */
1534     function totalSupply() public view virtual override returns (uint256) {
1535         // Counter underflow is impossible as _burnCounter cannot be incremented
1536         // more than `_currentIndex - _startTokenId()` times.
1537         unchecked {
1538             return _currentIndex - _burnCounter - _startTokenId();
1539         }
1540     }
1541 
1542     /**
1543      * @dev Returns the total amount of tokens minted in the contract.
1544      */
1545     function _totalMinted() internal view virtual returns (uint256) {
1546         // Counter underflow is impossible as `_currentIndex` does not decrement,
1547         // and it is initialized to `_startTokenId()`.
1548         unchecked {
1549             return _currentIndex - _startTokenId();
1550         }
1551     }
1552 
1553     /**
1554      * @dev Returns the total number of tokens burned.
1555      */
1556     function _totalBurned() internal view virtual returns (uint256) {
1557         return _burnCounter;
1558     }
1559 
1560     // =============================================================
1561     //                    ADDRESS DATA OPERATIONS
1562     // =============================================================
1563 
1564     /**
1565      * @dev Returns the number of tokens in `owner`'s account.
1566      */
1567     function balanceOf(address owner) public view virtual override returns (uint256) {
1568         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1569         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1570     }
1571 
1572     /**
1573      * Returns the number of tokens minted by `owner`.
1574      */
1575     function _numberMinted(address owner) internal view returns (uint256) {
1576         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1577     }
1578 
1579     /**
1580      * Returns the number of tokens burned by or on behalf of `owner`.
1581      */
1582     function _numberBurned(address owner) internal view returns (uint256) {
1583         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1584     }
1585 
1586     /**
1587      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1588      */
1589     function _getAux(address owner) internal view returns (uint64) {
1590         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1591     }
1592 
1593     /**
1594      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1595      * If there are multiple variables, please pack them into a uint64.
1596      */
1597     function _setAux(address owner, uint64 aux) internal virtual {
1598         uint256 packed = _packedAddressData[owner];
1599         uint256 auxCasted;
1600         // Cast `aux` with assembly to avoid redundant masking.
1601         assembly {
1602             auxCasted := aux
1603         }
1604         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1605         _packedAddressData[owner] = packed;
1606     }
1607 
1608     // =============================================================
1609     //                            IERC165
1610     // =============================================================
1611 
1612     /**
1613      * @dev Returns true if this contract implements the interface defined by
1614      * `interfaceId`. See the corresponding
1615      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1616      * to learn more about how these ids are created.
1617      *
1618      * This function call must use less than 30000 gas.
1619      */
1620     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1621         // The interface IDs are constants representing the first 4 bytes
1622         // of the XOR of all function selectors in the interface.
1623         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1624         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1625         return
1626             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1627             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1628             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1629     }
1630 
1631     // =============================================================
1632     //                        IERC721Metadata
1633     // =============================================================
1634 
1635     /**
1636      * @dev Returns the token collection name.
1637      */
1638     function name() public view virtual override returns (string memory) {
1639         return _name;
1640     }
1641 
1642     /**
1643      * @dev Returns the token collection symbol.
1644      */
1645     function symbol() public view virtual override returns (string memory) {
1646         return _symbol;
1647     }
1648 
1649     /**
1650      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1651      */
1652     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1653         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1654 
1655         string memory baseURI = _baseURI();
1656         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1657     }
1658 
1659     /**
1660      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1661      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1662      * by default, it can be overridden in child contracts.
1663      */
1664     function _baseURI() internal view virtual returns (string memory) {
1665         return '';
1666     }
1667 
1668     // =============================================================
1669     //                     OWNERSHIPS OPERATIONS
1670     // =============================================================
1671 
1672     /**
1673      * @dev Returns the owner of the `tokenId` token.
1674      *
1675      * Requirements:
1676      *
1677      * - `tokenId` must exist.
1678      */
1679     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1680         return address(uint160(_packedOwnershipOf(tokenId)));
1681     }
1682 
1683     /**
1684      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1685      * It gradually moves to O(1) as tokens get transferred around over time.
1686      */
1687     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1688         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1689     }
1690 
1691     /**
1692      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1693      */
1694     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1695         return _unpackedOwnership(_packedOwnerships[index]);
1696     }
1697 
1698     /**
1699      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1700      */
1701     function _initializeOwnershipAt(uint256 index) internal virtual {
1702         if (_packedOwnerships[index] == 0) {
1703             _packedOwnerships[index] = _packedOwnershipOf(index);
1704         }
1705     }
1706 
1707     /**
1708      * Returns the packed ownership data of `tokenId`.
1709      */
1710     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1711         uint256 curr = tokenId;
1712 
1713         unchecked {
1714             if (_startTokenId() <= curr)
1715                 if (curr < _currentIndex) {
1716                     uint256 packed = _packedOwnerships[curr];
1717                     // If not burned.
1718                     if (packed & _BITMASK_BURNED == 0) {
1719                         // Invariant:
1720                         // There will always be an initialized ownership slot
1721                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1722                         // before an unintialized ownership slot
1723                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1724                         // Hence, `curr` will not underflow.
1725                         //
1726                         // We can directly compare the packed value.
1727                         // If the address is zero, packed will be zero.
1728                         while (packed == 0) {
1729                             packed = _packedOwnerships[--curr];
1730                         }
1731                         return packed;
1732                     }
1733                 }
1734         }
1735         revert OwnerQueryForNonexistentToken();
1736     }
1737 
1738     /**
1739      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1740      */
1741     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1742         ownership.addr = address(uint160(packed));
1743         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1744         ownership.burned = packed & _BITMASK_BURNED != 0;
1745         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1746     }
1747 
1748     /**
1749      * @dev Packs ownership data into a single uint256.
1750      */
1751     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1752         assembly {
1753             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1754             owner := and(owner, _BITMASK_ADDRESS)
1755             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1756             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1757         }
1758     }
1759 
1760     /**
1761      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1762      */
1763     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1764         // For branchless setting of the `nextInitialized` flag.
1765         assembly {
1766             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1767             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1768         }
1769     }
1770 
1771     // =============================================================
1772     //                      APPROVAL OPERATIONS
1773     // =============================================================
1774 
1775     /**
1776      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1777      * The approval is cleared when the token is transferred.
1778      *
1779      * Only a single account can be approved at a time, so approving the
1780      * zero address clears previous approvals.
1781      *
1782      * Requirements:
1783      *
1784      * - The caller must own the token or be an approved operator.
1785      * - `tokenId` must exist.
1786      *
1787      * Emits an {Approval} event.
1788      */
1789     function approve(address to, uint256 tokenId) public payable virtual override {
1790         address owner = ownerOf(tokenId);
1791 
1792         if (_msgSenderERC721A() != owner)
1793             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1794                 revert ApprovalCallerNotOwnerNorApproved();
1795             }
1796 
1797         _tokenApprovals[tokenId].value = to;
1798         emit Approval(owner, to, tokenId);
1799     }
1800 
1801     /**
1802      * @dev Returns the account approved for `tokenId` token.
1803      *
1804      * Requirements:
1805      *
1806      * - `tokenId` must exist.
1807      */
1808     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1809         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1810 
1811         return _tokenApprovals[tokenId].value;
1812     }
1813 
1814     /**
1815      * @dev Approve or remove `operator` as an operator for the caller.
1816      * Operators can call {transferFrom} or {safeTransferFrom}
1817      * for any token owned by the caller.
1818      *
1819      * Requirements:
1820      *
1821      * - The `operator` cannot be the caller.
1822      *
1823      * Emits an {ApprovalForAll} event.
1824      */
1825     function setApprovalForAll(address operator, bool approved) public virtual override {
1826         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1827         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1828     }
1829 
1830     /**
1831      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1832      *
1833      * See {setApprovalForAll}.
1834      */
1835     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1836         return _operatorApprovals[owner][operator];
1837     }
1838 
1839     /**
1840      * @dev Returns whether `tokenId` exists.
1841      *
1842      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1843      *
1844      * Tokens start existing when they are minted. See {_mint}.
1845      */
1846     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1847         return
1848             _startTokenId() <= tokenId &&
1849             tokenId < _currentIndex && // If within bounds,
1850             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1851     }
1852 
1853     /**
1854      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1855      */
1856     function _isSenderApprovedOrOwner(
1857         address approvedAddress,
1858         address owner,
1859         address msgSender
1860     ) private pure returns (bool result) {
1861         assembly {
1862             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1863             owner := and(owner, _BITMASK_ADDRESS)
1864             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1865             msgSender := and(msgSender, _BITMASK_ADDRESS)
1866             // `msgSender == owner || msgSender == approvedAddress`.
1867             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1868         }
1869     }
1870 
1871     /**
1872      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1873      */
1874     function _getApprovedSlotAndAddress(uint256 tokenId)
1875         private
1876         view
1877         returns (uint256 approvedAddressSlot, address approvedAddress)
1878     {
1879         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1880         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1881         assembly {
1882             approvedAddressSlot := tokenApproval.slot
1883             approvedAddress := sload(approvedAddressSlot)
1884         }
1885     }
1886 
1887     // =============================================================
1888     //                      TRANSFER OPERATIONS
1889     // =============================================================
1890 
1891     /**
1892      * @dev Transfers `tokenId` from `from` to `to`.
1893      *
1894      * Requirements:
1895      *
1896      * - `from` cannot be the zero address.
1897      * - `to` cannot be the zero address.
1898      * - `tokenId` token must be owned by `from`.
1899      * - If the caller is not `from`, it must be approved to move this token
1900      * by either {approve} or {setApprovalForAll}.
1901      *
1902      * Emits a {Transfer} event.
1903      */
1904     function transferFrom(
1905         address from,
1906         address to,
1907         uint256 tokenId
1908     ) public payable virtual override {
1909         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1910 
1911         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1912 
1913         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1914 
1915         // The nested ifs save around 20+ gas over a compound boolean condition.
1916         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1917             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1918 
1919         if (to == address(0)) revert TransferToZeroAddress();
1920 
1921         _beforeTokenTransfers(from, to, tokenId, 1);
1922 
1923         // Clear approvals from the previous owner.
1924         assembly {
1925             if approvedAddress {
1926                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1927                 sstore(approvedAddressSlot, 0)
1928             }
1929         }
1930 
1931         // Underflow of the sender's balance is impossible because we check for
1932         // ownership above and the recipient's balance can't realistically overflow.
1933         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1934         unchecked {
1935             // We can directly increment and decrement the balances.
1936             --_packedAddressData[from]; // Updates: `balance -= 1`.
1937             ++_packedAddressData[to]; // Updates: `balance += 1`.
1938 
1939             // Updates:
1940             // - `address` to the next owner.
1941             // - `startTimestamp` to the timestamp of transfering.
1942             // - `burned` to `false`.
1943             // - `nextInitialized` to `true`.
1944             _packedOwnerships[tokenId] = _packOwnershipData(
1945                 to,
1946                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1947             );
1948 
1949             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1950             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1951                 uint256 nextTokenId = tokenId + 1;
1952                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1953                 if (_packedOwnerships[nextTokenId] == 0) {
1954                     // If the next slot is within bounds.
1955                     if (nextTokenId != _currentIndex) {
1956                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1957                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1958                     }
1959                 }
1960             }
1961         }
1962 
1963         emit Transfer(from, to, tokenId);
1964         _afterTokenTransfers(from, to, tokenId, 1);
1965     }
1966 
1967     /**
1968      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1969      */
1970     function safeTransferFrom(
1971         address from,
1972         address to,
1973         uint256 tokenId
1974     ) public payable virtual override {
1975         safeTransferFrom(from, to, tokenId, '');
1976     }
1977 
1978     /**
1979      * @dev Safely transfers `tokenId` token from `from` to `to`.
1980      *
1981      * Requirements:
1982      *
1983      * - `from` cannot be the zero address.
1984      * - `to` cannot be the zero address.
1985      * - `tokenId` token must exist and be owned by `from`.
1986      * - If the caller is not `from`, it must be approved to move this token
1987      * by either {approve} or {setApprovalForAll}.
1988      * - If `to` refers to a smart contract, it must implement
1989      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1990      *
1991      * Emits a {Transfer} event.
1992      */
1993     function safeTransferFrom(
1994         address from,
1995         address to,
1996         uint256 tokenId,
1997         bytes memory _data
1998     ) public payable virtual override {
1999         transferFrom(from, to, tokenId);
2000         if (to.code.length != 0)
2001             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2002                 revert TransferToNonERC721ReceiverImplementer();
2003             }
2004     }
2005 
2006     /**
2007      * @dev Hook that is called before a set of serially-ordered token IDs
2008      * are about to be transferred. This includes minting.
2009      * And also called before burning one token.
2010      *
2011      * `startTokenId` - the first token ID to be transferred.
2012      * `quantity` - the amount to be transferred.
2013      *
2014      * Calling conditions:
2015      *
2016      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2017      * transferred to `to`.
2018      * - When `from` is zero, `tokenId` will be minted for `to`.
2019      * - When `to` is zero, `tokenId` will be burned by `from`.
2020      * - `from` and `to` are never both zero.
2021      */
2022     function _beforeTokenTransfers(
2023         address from,
2024         address to,
2025         uint256 startTokenId,
2026         uint256 quantity
2027     ) internal virtual {}
2028 
2029     /**
2030      * @dev Hook that is called after a set of serially-ordered token IDs
2031      * have been transferred. This includes minting.
2032      * And also called after one token has been burned.
2033      *
2034      * `startTokenId` - the first token ID to be transferred.
2035      * `quantity` - the amount to be transferred.
2036      *
2037      * Calling conditions:
2038      *
2039      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2040      * transferred to `to`.
2041      * - When `from` is zero, `tokenId` has been minted for `to`.
2042      * - When `to` is zero, `tokenId` has been burned by `from`.
2043      * - `from` and `to` are never both zero.
2044      */
2045     function _afterTokenTransfers(
2046         address from,
2047         address to,
2048         uint256 startTokenId,
2049         uint256 quantity
2050     ) internal virtual {}
2051 
2052     /**
2053      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2054      *
2055      * `from` - Previous owner of the given token ID.
2056      * `to` - Target address that will receive the token.
2057      * `tokenId` - Token ID to be transferred.
2058      * `_data` - Optional data to send along with the call.
2059      *
2060      * Returns whether the call correctly returned the expected magic value.
2061      */
2062     function _checkContractOnERC721Received(
2063         address from,
2064         address to,
2065         uint256 tokenId,
2066         bytes memory _data
2067     ) private returns (bool) {
2068         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2069             bytes4 retval
2070         ) {
2071             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2072         } catch (bytes memory reason) {
2073             if (reason.length == 0) {
2074                 revert TransferToNonERC721ReceiverImplementer();
2075             } else {
2076                 assembly {
2077                     revert(add(32, reason), mload(reason))
2078                 }
2079             }
2080         }
2081     }
2082 
2083     // =============================================================
2084     //                        MINT OPERATIONS
2085     // =============================================================
2086 
2087     /**
2088      * @dev Mints `quantity` tokens and transfers them to `to`.
2089      *
2090      * Requirements:
2091      *
2092      * - `to` cannot be the zero address.
2093      * - `quantity` must be greater than 0.
2094      *
2095      * Emits a {Transfer} event for each mint.
2096      */
2097     function _mint(address to, uint256 quantity) internal virtual {
2098         uint256 startTokenId = _currentIndex;
2099         if (quantity == 0) revert MintZeroQuantity();
2100 
2101         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2102 
2103         // Overflows are incredibly unrealistic.
2104         // `balance` and `numberMinted` have a maximum limit of 2**64.
2105         // `tokenId` has a maximum limit of 2**256.
2106         unchecked {
2107             // Updates:
2108             // - `balance += quantity`.
2109             // - `numberMinted += quantity`.
2110             //
2111             // We can directly add to the `balance` and `numberMinted`.
2112             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2113 
2114             // Updates:
2115             // - `address` to the owner.
2116             // - `startTimestamp` to the timestamp of minting.
2117             // - `burned` to `false`.
2118             // - `nextInitialized` to `quantity == 1`.
2119             _packedOwnerships[startTokenId] = _packOwnershipData(
2120                 to,
2121                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2122             );
2123 
2124             uint256 toMasked;
2125             uint256 end = startTokenId + quantity;
2126 
2127             // Use assembly to loop and emit the `Transfer` event for gas savings.
2128             // The duplicated `log4` removes an extra check and reduces stack juggling.
2129             // The assembly, together with the surrounding Solidity code, have been
2130             // delicately arranged to nudge the compiler into producing optimized opcodes.
2131             assembly {
2132                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2133                 toMasked := and(to, _BITMASK_ADDRESS)
2134                 // Emit the `Transfer` event.
2135                 log4(
2136                     0, // Start of data (0, since no data).
2137                     0, // End of data (0, since no data).
2138                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2139                     0, // `address(0)`.
2140                     toMasked, // `to`.
2141                     startTokenId // `tokenId`.
2142                 )
2143 
2144                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2145                 // that overflows uint256 will make the loop run out of gas.
2146                 // The compiler will optimize the `iszero` away for performance.
2147                 for {
2148                     let tokenId := add(startTokenId, 1)
2149                 } iszero(eq(tokenId, end)) {
2150                     tokenId := add(tokenId, 1)
2151                 } {
2152                     // Emit the `Transfer` event. Similar to above.
2153                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2154                 }
2155             }
2156             if (toMasked == 0) revert MintToZeroAddress();
2157 
2158             _currentIndex = end;
2159         }
2160         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2161     }
2162 
2163     /**
2164      * @dev Mints `quantity` tokens and transfers them to `to`.
2165      *
2166      * This function is intended for efficient minting only during contract creation.
2167      *
2168      * It emits only one {ConsecutiveTransfer} as defined in
2169      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2170      * instead of a sequence of {Transfer} event(s).
2171      *
2172      * Calling this function outside of contract creation WILL make your contract
2173      * non-compliant with the ERC721 standard.
2174      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2175      * {ConsecutiveTransfer} event is only permissible during contract creation.
2176      *
2177      * Requirements:
2178      *
2179      * - `to` cannot be the zero address.
2180      * - `quantity` must be greater than 0.
2181      *
2182      * Emits a {ConsecutiveTransfer} event.
2183      */
2184     function _mintERC2309(address to, uint256 quantity) internal virtual {
2185         uint256 startTokenId = _currentIndex;
2186         if (to == address(0)) revert MintToZeroAddress();
2187         if (quantity == 0) revert MintZeroQuantity();
2188         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2189 
2190         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2191 
2192         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2193         unchecked {
2194             // Updates:
2195             // - `balance += quantity`.
2196             // - `numberMinted += quantity`.
2197             //
2198             // We can directly add to the `balance` and `numberMinted`.
2199             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2200 
2201             // Updates:
2202             // - `address` to the owner.
2203             // - `startTimestamp` to the timestamp of minting.
2204             // - `burned` to `false`.
2205             // - `nextInitialized` to `quantity == 1`.
2206             _packedOwnerships[startTokenId] = _packOwnershipData(
2207                 to,
2208                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2209             );
2210 
2211             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2212 
2213             _currentIndex = startTokenId + quantity;
2214         }
2215         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2216     }
2217 
2218     /**
2219      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2220      *
2221      * Requirements:
2222      *
2223      * - If `to` refers to a smart contract, it must implement
2224      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2225      * - `quantity` must be greater than 0.
2226      *
2227      * See {_mint}.
2228      *
2229      * Emits a {Transfer} event for each mint.
2230      */
2231     function _safeMint(
2232         address to,
2233         uint256 quantity,
2234         bytes memory _data
2235     ) internal virtual {
2236         _mint(to, quantity);
2237 
2238         unchecked {
2239             if (to.code.length != 0) {
2240                 uint256 end = _currentIndex;
2241                 uint256 index = end - quantity;
2242                 do {
2243                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2244                         revert TransferToNonERC721ReceiverImplementer();
2245                     }
2246                 } while (index < end);
2247                 // Reentrancy protection.
2248                 if (_currentIndex != end) revert();
2249             }
2250         }
2251     }
2252 
2253     /**
2254      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2255      */
2256     function _safeMint(address to, uint256 quantity) internal virtual {
2257         _safeMint(to, quantity, '');
2258     }
2259 
2260     // =============================================================
2261     //                        BURN OPERATIONS
2262     // =============================================================
2263 
2264     /**
2265      * @dev Equivalent to `_burn(tokenId, false)`.
2266      */
2267     function _burn(uint256 tokenId) internal virtual {
2268         _burn(tokenId, false);
2269     }
2270 
2271     /**
2272      * @dev Destroys `tokenId`.
2273      * The approval is cleared when the token is burned.
2274      *
2275      * Requirements:
2276      *
2277      * - `tokenId` must exist.
2278      *
2279      * Emits a {Transfer} event.
2280      */
2281     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2282         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2283 
2284         address from = address(uint160(prevOwnershipPacked));
2285 
2286         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2287 
2288         if (approvalCheck) {
2289             // The nested ifs save around 20+ gas over a compound boolean condition.
2290             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2291                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2292         }
2293 
2294         _beforeTokenTransfers(from, address(0), tokenId, 1);
2295 
2296         // Clear approvals from the previous owner.
2297         assembly {
2298             if approvedAddress {
2299                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2300                 sstore(approvedAddressSlot, 0)
2301             }
2302         }
2303 
2304         // Underflow of the sender's balance is impossible because we check for
2305         // ownership above and the recipient's balance can't realistically overflow.
2306         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2307         unchecked {
2308             // Updates:
2309             // - `balance -= 1`.
2310             // - `numberBurned += 1`.
2311             //
2312             // We can directly decrement the balance, and increment the number burned.
2313             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2314             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2315 
2316             // Updates:
2317             // - `address` to the last owner.
2318             // - `startTimestamp` to the timestamp of burning.
2319             // - `burned` to `true`.
2320             // - `nextInitialized` to `true`.
2321             _packedOwnerships[tokenId] = _packOwnershipData(
2322                 from,
2323                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2324             );
2325 
2326             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2327             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2328                 uint256 nextTokenId = tokenId + 1;
2329                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2330                 if (_packedOwnerships[nextTokenId] == 0) {
2331                     // If the next slot is within bounds.
2332                     if (nextTokenId != _currentIndex) {
2333                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2334                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2335                     }
2336                 }
2337             }
2338         }
2339 
2340         emit Transfer(from, address(0), tokenId);
2341         _afterTokenTransfers(from, address(0), tokenId, 1);
2342 
2343         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2344         unchecked {
2345             _burnCounter++;
2346         }
2347     }
2348 
2349     // =============================================================
2350     //                     EXTRA DATA OPERATIONS
2351     // =============================================================
2352 
2353     /**
2354      * @dev Directly sets the extra data for the ownership data `index`.
2355      */
2356     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2357         uint256 packed = _packedOwnerships[index];
2358         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2359         uint256 extraDataCasted;
2360         // Cast `extraData` with assembly to avoid redundant masking.
2361         assembly {
2362             extraDataCasted := extraData
2363         }
2364         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2365         _packedOwnerships[index] = packed;
2366     }
2367 
2368     /**
2369      * @dev Called during each token transfer to set the 24bit `extraData` field.
2370      * Intended to be overridden by the cosumer contract.
2371      *
2372      * `previousExtraData` - the value of `extraData` before transfer.
2373      *
2374      * Calling conditions:
2375      *
2376      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2377      * transferred to `to`.
2378      * - When `from` is zero, `tokenId` will be minted for `to`.
2379      * - When `to` is zero, `tokenId` will be burned by `from`.
2380      * - `from` and `to` are never both zero.
2381      */
2382     function _extraData(
2383         address from,
2384         address to,
2385         uint24 previousExtraData
2386     ) internal view virtual returns (uint24) {}
2387 
2388     /**
2389      * @dev Returns the next extra data for the packed ownership data.
2390      * The returned result is shifted into position.
2391      */
2392     function _nextExtraData(
2393         address from,
2394         address to,
2395         uint256 prevOwnershipPacked
2396     ) private view returns (uint256) {
2397         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2398         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2399     }
2400 
2401     // =============================================================
2402     //                       OTHER OPERATIONS
2403     // =============================================================
2404 
2405     /**
2406      * @dev Returns the message sender (defaults to `msg.sender`).
2407      *
2408      * If you are writing GSN compatible contracts, you need to override this function.
2409      */
2410     function _msgSenderERC721A() internal view virtual returns (address) {
2411         return msg.sender;
2412     }
2413 
2414     /**
2415      * @dev Converts a uint256 to its ASCII string decimal representation.
2416      */
2417     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2418         assembly {
2419             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2420             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2421             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2422             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2423             let m := add(mload(0x40), 0xa0)
2424             // Update the free memory pointer to allocate.
2425             mstore(0x40, m)
2426             // Assign the `str` to the end.
2427             str := sub(m, 0x20)
2428             // Zeroize the slot after the string.
2429             mstore(str, 0)
2430 
2431             // Cache the end of the memory to calculate the length later.
2432             let end := str
2433 
2434             // We write the string from rightmost digit to leftmost digit.
2435             // The following is essentially a do-while loop that also handles the zero case.
2436             // prettier-ignore
2437             for { let temp := value } 1 {} {
2438                 str := sub(str, 1)
2439                 // Write the character to the pointer.
2440                 // The ASCII index of the '0' character is 48.
2441                 mstore8(str, add(48, mod(temp, 10)))
2442                 // Keep dividing `temp` until zero.
2443                 temp := div(temp, 10)
2444                 // prettier-ignore
2445                 if iszero(temp) { break }
2446             }
2447 
2448             let length := sub(end, str)
2449             // Move the pointer 32 bytes leftwards to make room for the length.
2450             str := sub(str, 0x20)
2451             // Store the length.
2452             mstore(str, length)
2453         }
2454     }
2455 }
2456 
2457 // File: contracts/DeviantsSilverPass.sol
2458 
2459 
2460 pragma solidity ^0.8.4;
2461 
2462 
2463 
2464 
2465 
2466 
2467 
2468  /**
2469   * @title DeviantsSilverPass
2470   * @dev The contract allows users to mint max 2 NFTs per address.
2471   * @dev The contract has 2 phases, whitelist sale and public sale.
2472   * @dev The contract uses a Merkle proof to validate that an address is whitelisted.
2473   * @dev Each phase lasts one day.
2474   * @dev Whitelist phase starts on 07.02.2023 at 4 pm UTC, ends in 08.02.2023 at 4 pm UTC.
2475   * @dev Public phase starts on 08.02.2023 at 4:01 pm UTC, ends in 09.02.2023 at 4 pm UTC.
2476   * @dev The contract also has an owner who have the privilages to set the state of the contract and withdraw erc20 native tokens.
2477   */
2478 contract DeviantsSilverPass is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2479     using Strings for uint256;
2480 
2481     /** 
2482      * @dev Set max supply for the DeviantsSilverPass collection
2483      */
2484     uint256 public constant maxSupply = 5555;
2485 
2486     /** 
2487      * @dev Set max amount of NFTs per address
2488      */
2489     uint256 public constant maxMintPerWallet = 2;
2490 
2491     /** 
2492      * @dev Set cost for second NFT minted during the whitelist sale period
2493      */
2494     uint256 public constant priceWhitelistSale = 0.0035 ether;
2495 
2496     /** 
2497      * @dev Set cost for second NFT minted during the public sale period
2498      */
2499     uint256 public constant pricePublicSale = 0.0035 ether;
2500 
2501     /** 
2502      * @dev Set whitelist mint period and public mint period
2503      */
2504     uint256 public constant startWLMintTime = 1675785600;
2505     uint256 public constant endWLtMintTime = 1675872000;
2506     uint256 public constant startPBMintTime = 1675872060;
2507     uint256 public constant endPBMintTime = 1675958400;
2508 
2509     /** 
2510      * @dev A boolean that indicates whether the mintWhitelistSale function is paused or not.
2511      */
2512     bool public pauseWLSale = true;
2513 
2514     /** 
2515      * @dev A boolean that indicates whether the mintPublicSale function is paused or not.
2516      */
2517     bool public pausePBSale = true;
2518 
2519 
2520     /** 
2521      * @dev A boolean that indicates whether the contract isindicates is paused or not.
2522      */
2523     bool public globalPause = false;
2524 
2525     /**
2526      * @dev The root of the Merkle tree that is used for whitelist check.
2527      */
2528     bytes32 public merkleRoot;
2529 
2530     /**
2531      * @dev The account that recive the money from the mints.
2532      */
2533     address public payerAccount;
2534 
2535     /** 
2536      * @dev Prefix for tokens metadata URIs
2537      */
2538     string public baseURI;
2539 
2540     /** 
2541      * @dev Sufix for tokens metadata URIs
2542      */
2543     string public uriSuffix = '.json';
2544 
2545     /**
2546      * @dev A mapping that stores the amount of NFTs minted for each address.
2547      */
2548     mapping(address => uint256) public addressMintedAmount;
2549 
2550     /**
2551      * @dev Emits an event when an NFT is minted in whitelist sale period.
2552      * @param minterAddress The address of the user who executed the mintWhitelistSale.
2553      * @param amount The amount of NFTs minted.
2554      */
2555     event MintWhitelistSale(
2556         address indexed minterAddress,
2557         uint256 amount
2558     );
2559 
2560     /**
2561      * @dev Emits an event when an NFT is minted in public sale period.
2562      * @param minterAddress The address of the user who executed the mintWhitelistSale.
2563      * @param amount The amount of NFTs minted.
2564      */
2565     event MintPublicSale(
2566         address indexed minterAddress,
2567         uint256 amount
2568     );
2569 
2570     /**
2571      * @dev Emits an event when owner mint a batch.
2572      * @param owner The addresses who is the contract owner.
2573      * @param addresses The addresses array.
2574      * @param amount The amount of NFTs minted for each address.
2575      */
2576     event MintBatch(
2577         address indexed owner,
2578         address[] addresses,
2579         uint256 amount
2580     );
2581     
2582     /**
2583      * @dev Emits an event when owner mint a batch.
2584      * @param owner The addresses who is the contract owner.
2585      * @param amount The amount of native tokens withdrawn.
2586      */
2587     event Withdraw(
2588         address indexed owner,
2589         uint256 amount
2590     );
2591 
2592     /**
2593      * @dev Constructor function that sets the initial values for the contract's variables.
2594      * @param _merkleRoot The root of the Merkle tree.
2595      * @param uri The metadata URI prefix.
2596      */
2597     constructor(
2598         bytes32 _merkleRoot,
2599         string  memory uri,
2600         address _payerAccount
2601     ) ERC721A("Deviants Silver Mint Pass", "DMPS") {
2602         merkleRoot = _merkleRoot;
2603         baseURI = uri;
2604         payerAccount = _payerAccount;
2605     }
2606 
2607      /**
2608       * @dev mintWhitelistSale creates NFT tokens for whitelist sale.
2609       * @param _mintAmount the amount of NFT tokens to mint.
2610       * @param _merkleProof the proof of user's whitelist status.
2611       * @notice Throws if:
2612       * - whitelistSale closed if the function is called outside of the whitelist sale period or if the contract is paused.
2613       * - maxSupply exceeded if the minted amount exceeds the maxSupply.
2614       * - mintAmount must be 1 or 2 if the _mintAmount is not 1 or 2.
2615       * - Invalid proof if the provided merkle proof is invalid.
2616       * - user cannot mint more then 2 NFTs if the user already owns 2 NFTs.
2617       * - user must send the exact price if the user already owns 1 NFT and tries to mint 2 NFTs.
2618       */
2619     function mintWhitelistSale(uint256 _mintAmount, bytes32[] calldata _merkleProof) external payable nonReentrant{
2620         require(!globalPause,"DMPS: contract is paused");
2621         require((block.timestamp >= startWLMintTime && block.timestamp <= endWLtMintTime) || !pauseWLSale, "DMPS: whitelistSale closed");
2622         require(totalSupply() + _mintAmount <= maxSupply, "DMPS: maxSupply exceeded");
2623         require(_mintAmount == 1 || _mintAmount == 2, "DMPS: mintAmount must be 1 or 2");
2624             
2625         bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender))));
2626         require(MerkleProof.verify(_merkleProof, merkleRoot, leaf), "DMPS: Invalid proof");
2627         require(_mintAmount + addressMintedAmount[msg.sender] <= 2, "DMPS: user cannot mint more then 2 NFTs" );
2628         
2629         if(addressMintedAmount[msg.sender] == 0 && _mintAmount == 1 ){
2630             addressMintedAmount[msg.sender] += _mintAmount;
2631             _safeMint(msg.sender,_mintAmount);
2632         }
2633         else if(addressMintedAmount[msg.sender] == 0 && _mintAmount == 2){
2634             require(msg.value == priceWhitelistSale,"DMPS: user must send the exact price");
2635 
2636             addressMintedAmount[msg.sender] += _mintAmount;
2637             _safeMint(msg.sender,_mintAmount);
2638         }
2639         else{
2640              require(msg.value == priceWhitelistSale,"DMPS: user must send the exact price");
2641 
2642             addressMintedAmount[msg.sender] += _mintAmount;
2643             _safeMint(msg.sender,_mintAmount);
2644         } 
2645 
2646         emit MintWhitelistSale(msg.sender, _mintAmount);      
2647     } 
2648 
2649     /**
2650      * @dev Mints NFTs in the public sale period.
2651      * @param _mintAmount The number of NFTs to mint (1 or 2).
2652      * @notice Throws if:
2653      * - public sale period has ended or the contract is paused.
2654      * - The maximum supply of NFTs is exceeded.
2655      * - The `_mintAmount` is not 1 or 2.
2656      * - The user tries to mint more than 2 NFTs.
2657      * - The user tries to mint 2 NFTs but does not send the exact price.
2658      * - The user tries to mint 1 NFT but sends more than the exact price.
2659      */
2660     function mintPublicSale(uint256 _mintAmount) external payable nonReentrant{
2661         require(!globalPause,"DMPS: contract is paused");
2662         require((block.timestamp >= startPBMintTime && block.timestamp <= endPBMintTime) || !pausePBSale ,"DMPS: publicSale closed");
2663         require(totalSupply() + _mintAmount <= maxSupply,"DMPS: maxSupply exceeded");
2664         require(_mintAmount== 1 || _mintAmount == 2, "DMPS: mintAmount must be 1 or 2");    
2665         require(_mintAmount + addressMintedAmount[msg.sender] <= 2,"DMPS: user cannot mint more then 2 NFTs" );
2666 
2667         if(addressMintedAmount[msg.sender] == 0 && _mintAmount == 1 ){
2668 
2669             addressMintedAmount[msg.sender] += _mintAmount;
2670             _safeMint(msg.sender,_mintAmount);
2671         }
2672         else if(addressMintedAmount[msg.sender] == 0 && _mintAmount == 2){
2673             require(msg.value == pricePublicSale,"DMPS: user must send the exact price");
2674 
2675             addressMintedAmount[msg.sender] += _mintAmount;
2676             _safeMint(msg.sender,_mintAmount);
2677         }
2678         else{
2679              require(msg.value == pricePublicSale,"DMPS: user must send the exact price");
2680             
2681             addressMintedAmount[msg.sender] += _mintAmount;
2682             _safeMint(msg.sender,_mintAmount);
2683         }    
2684 
2685         emit MintPublicSale(msg.sender, _mintAmount);     
2686     }
2687 
2688     /**
2689      * @dev Function to mint a batch of NFTs to multiple addresses
2690      * @param addresses An array of addresses to mint NFTs to
2691      * @param _mintAmounts The amount of NFTs to mint to each address
2692      * @notice Only the contract owner can call this function.
2693      */
2694     function mintBatch(address[] memory addresses, uint256 _mintAmounts) external onlyOwner{
2695         require(totalSupply() + addresses.length * _mintAmounts <= maxSupply,"DMPS: maxSupply exceeded");
2696 
2697         for(uint256 i = 0;i < addresses.length; i++){
2698             _safeMint(addresses[i],_mintAmounts);
2699         }
2700 
2701         emit MintBatch(msg.sender, addresses, _mintAmounts);
2702     }
2703 
2704     /**
2705      * @dev Sets the Merkle root on the contract
2706      * @param _merkleRoot bytes32: the Merkle root to be set
2707      * @notice Only the contract owner can call this function.
2708      */
2709     function setMerkleRoot(bytes32 _merkleRoot) external onlyOwner{
2710         merkleRoot = _merkleRoot;
2711     }
2712     
2713     /**
2714      * @dev This function sets the base URI of the NFT contract.
2715      * @param uri The new base URI of the NFT contract.
2716      * @notice Only the contract owner can call this function.
2717      */
2718     function setBasedURI(string memory uri) external onlyOwner{
2719         baseURI = uri;
2720     }
2721 
2722     /**
2723      * @dev Set the pause state of the contract for the WL Sale, only the contract owner can set the pause state
2724      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
2725      */
2726     function setPauseWLSale(bool state) external onlyOwner{
2727         pauseWLSale = state;
2728     }
2729 
2730     /**
2731      * @dev Set the pause state of the contract for the PB Sale, only the contract owner can set the pause state
2732      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
2733      */
2734     function setPausePBSale(bool state) external onlyOwner{
2735         pausePBSale = state;
2736     }
2737 
2738     /**
2739      * @dev Set the global pause state of the contract, only the contract owner can set the pause state
2740      * @param state Boolean state of the pause, true means that the contract is paused, false means that the contract is not paused
2741      */
2742     function setGlobalPause(bool state) external onlyOwner{
2743         globalPause = state;
2744     }
2745 
2746 
2747     /**
2748      * @dev Sets the uriSuffix for the ERC-721 token metadata.
2749      * @param _uriSuffix The new uriSuffix to be set.
2750      */
2751     function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2752         uriSuffix = _uriSuffix;
2753     }
2754 
2755     /**
2756      * @dev Sets the payerAccount.
2757      * @param _payerAccount The new payerAccount.
2758      */
2759     function setPayerAccount(address _payerAccount) public onlyOwner {
2760         payerAccount = _payerAccount;
2761     }
2762 
2763     /**
2764      * @dev Returns the state of the WhitelistState (true if is open, false if is closed)
2765      */
2766     function getWhitelistSaleStatus() public view returns(bool){
2767         if((block.timestamp >= startWLMintTime && block.timestamp <= endWLtMintTime) || !pauseWLSale) {
2768             return true;
2769         }else{
2770             return false;
2771         }
2772     }
2773     
2774     /**
2775      * @dev Returns the state of the PauseSale (true if is open, false if is closed)
2776      */
2777     function getPauseSaleStatus() public view returns(bool){
2778         if((block.timestamp >= startPBMintTime && block.timestamp <= endPBMintTime) || !pausePBSale) {
2779             return true;
2780         }else{
2781             return false;
2782         }
2783     }
2784     
2785     /**
2786      * Transfers the total native coin balance to contract's owner account.
2787      * The balance must be > 0 so a zero transfer is avoided.
2788      * 
2789      * Access: Contract Owner
2790      */
2791     function withdraw() public nonReentrant {
2792         require(msg.sender == owner() || msg.sender == payerAccount, "DMPS: can be called only with the owner or payerAccount");
2793         uint256 balance = address(this).balance;
2794         require(balance != 0, "DMPS: contract balance is zero");
2795         sendViaCall(payable(payerAccount), balance);
2796 
2797         emit Withdraw(msg.sender, balance);
2798     }
2799 
2800     /**
2801      * @dev Function to transfer coins (the native cryptocurrency of the platform, i.e.: ETH) 
2802      * from this contract to the specified address.
2803      *
2804      * @param _to the address to transfer the coins to
2805      * @param _amount amount (in wei)
2806      */
2807     function sendViaCall(address payable _to, uint256 _amount) private {
2808         (bool sent, ) = _to.call { value: _amount } ("");
2809         require(sent, "DMPS: failed to send amount");
2810     }
2811 
2812     /**
2813     * @dev Returns the starting token ID for the token.
2814     * @return uint256 The starting token ID for the token.
2815     */
2816     function _startTokenId() internal view virtual override returns (uint256) {
2817         return 1;
2818     }
2819 
2820     /**
2821      * @dev Returns the token URI for the given token ID. Throws if the token ID does not exist
2822      * @param _tokenId The token ID to retrieve the URI for
2823      * @notice Retrieve the URI for the given token ID
2824      * @return The token URI for the given token ID
2825      */
2826     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
2827         require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
2828 
2829         string memory currentBaseURI = _baseURI();
2830         return bytes(currentBaseURI).length > 0
2831             ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2832             : '';
2833     }
2834         
2835     /**
2836      * @dev Returns the current base URI.
2837      * @return The base URI of the contract.
2838      */
2839     function _baseURI() internal view virtual override returns (string memory) {
2840         return baseURI;
2841     }
2842 
2843     function setApprovalForAll(address operator, bool approved) public  override onlyAllowedOperatorApproval(operator) {
2844         super.setApprovalForAll(operator, approved);
2845     }
2846 
2847     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2848         super.approve(operator, tokenId);
2849     }
2850 
2851     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2852         super.transferFrom(from, to, tokenId);
2853     }
2854 
2855     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2856         super.safeTransferFrom(from, to, tokenId);
2857     }
2858 
2859     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2860         public
2861         payable 
2862         override
2863         onlyAllowedOperator(from)
2864     {
2865         super.safeTransferFrom(from, to, tokenId, data);
2866     }
2867 
2868 
2869 }