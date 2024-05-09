1 // File: operator-filter-registry/src/lib/Constants.sol
2 
3 
4 pragma solidity ^0.8.13;
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
669 // File: @openzeppelin/contracts/utils/Context.sol
670 
671 
672 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
673 
674 pragma solidity ^0.8.0;
675 
676 /**
677  * @dev Provides information about the current execution context, including the
678  * sender of the transaction and its data. While these are generally available
679  * via msg.sender and msg.data, they should not be accessed in such a direct
680  * manner, since when dealing with meta-transactions the account sending and
681  * paying for execution may not be the actual sender (as far as an application
682  * is concerned).
683  *
684  * This contract is only required for intermediate, library-like contracts.
685  */
686 abstract contract Context {
687     function _msgSender() internal view virtual returns (address) {
688         return msg.sender;
689     }
690 
691     function _msgData() internal view virtual returns (bytes calldata) {
692         return msg.data;
693     }
694 }
695 
696 // File: @openzeppelin/contracts/access/Ownable.sol
697 
698 
699 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 /**
705  * @dev Contract module which provides a basic access control mechanism, where
706  * there is an account (an owner) that can be granted exclusive access to
707  * specific functions.
708  *
709  * By default, the owner account will be the one that deploys the contract. This
710  * can later be changed with {transferOwnership}.
711  *
712  * This module is used through inheritance. It will make available the modifier
713  * `onlyOwner`, which can be applied to your functions to restrict their use to
714  * the owner.
715  */
716 abstract contract Ownable is Context {
717     address private _owner;
718 
719     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
720 
721     /**
722      * @dev Initializes the contract setting the deployer as the initial owner.
723      */
724     constructor() {
725         _transferOwnership(_msgSender());
726     }
727 
728     /**
729      * @dev Throws if called by any account other than the owner.
730      */
731     modifier onlyOwner() {
732         _checkOwner();
733         _;
734     }
735 
736     /**
737      * @dev Returns the address of the current owner.
738      */
739     function owner() public view virtual returns (address) {
740         return _owner;
741     }
742 
743     /**
744      * @dev Throws if the sender is not the owner.
745      */
746     function _checkOwner() internal view virtual {
747         require(owner() == _msgSender(), "Ownable: caller is not the owner");
748     }
749 
750     /**
751      * @dev Leaves the contract without owner. It will not be possible to call
752      * `onlyOwner` functions anymore. Can only be called by the current owner.
753      *
754      * NOTE: Renouncing ownership will leave the contract without an owner,
755      * thereby removing any functionality that is only available to the owner.
756      */
757     function renounceOwnership() public virtual onlyOwner {
758         _transferOwnership(address(0));
759     }
760 
761     /**
762      * @dev Transfers ownership of the contract to a new account (`newOwner`).
763      * Can only be called by the current owner.
764      */
765     function transferOwnership(address newOwner) public virtual onlyOwner {
766         require(newOwner != address(0), "Ownable: new owner is the zero address");
767         _transferOwnership(newOwner);
768     }
769 
770     /**
771      * @dev Transfers ownership of the contract to a new account (`newOwner`).
772      * Internal function without access restriction.
773      */
774     function _transferOwnership(address newOwner) internal virtual {
775         address oldOwner = _owner;
776         _owner = newOwner;
777         emit OwnershipTransferred(oldOwner, newOwner);
778     }
779 }
780 
781 // File: erc721a/contracts/IERC721A.sol
782 
783 
784 // ERC721A Contracts v4.2.3
785 // Creator: Chiru Labs
786 
787 pragma solidity ^0.8.4;
788 
789 /**
790  * @dev Interface of ERC721A.
791  */
792 interface IERC721A {
793     /**
794      * The caller must own the token or be an approved operator.
795      */
796     error ApprovalCallerNotOwnerNorApproved();
797 
798     /**
799      * The token does not exist.
800      */
801     error ApprovalQueryForNonexistentToken();
802 
803     /**
804      * Cannot query the balance for the zero address.
805      */
806     error BalanceQueryForZeroAddress();
807 
808     /**
809      * Cannot mint to the zero address.
810      */
811     error MintToZeroAddress();
812 
813     /**
814      * The quantity of tokens minted must be more than zero.
815      */
816     error MintZeroQuantity();
817 
818     /**
819      * The token does not exist.
820      */
821     error OwnerQueryForNonexistentToken();
822 
823     /**
824      * The caller must own the token or be an approved operator.
825      */
826     error TransferCallerNotOwnerNorApproved();
827 
828     /**
829      * The token must be owned by `from`.
830      */
831     error TransferFromIncorrectOwner();
832 
833     /**
834      * Cannot safely transfer to a contract that does not implement the
835      * ERC721Receiver interface.
836      */
837     error TransferToNonERC721ReceiverImplementer();
838 
839     /**
840      * Cannot transfer to the zero address.
841      */
842     error TransferToZeroAddress();
843 
844     /**
845      * The token does not exist.
846      */
847     error URIQueryForNonexistentToken();
848 
849     /**
850      * The `quantity` minted with ERC2309 exceeds the safety limit.
851      */
852     error MintERC2309QuantityExceedsLimit();
853 
854     /**
855      * The `extraData` cannot be set on an unintialized ownership slot.
856      */
857     error OwnershipNotInitializedForExtraData();
858 
859     // =============================================================
860     //                            STRUCTS
861     // =============================================================
862 
863     struct TokenOwnership {
864         // The address of the owner.
865         address addr;
866         // Stores the start time of ownership with minimal overhead for tokenomics.
867         uint64 startTimestamp;
868         // Whether the token has been burned.
869         bool burned;
870         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
871         uint24 extraData;
872     }
873 
874     // =============================================================
875     //                         TOKEN COUNTERS
876     // =============================================================
877 
878     /**
879      * @dev Returns the total number of tokens in existence.
880      * Burned tokens will reduce the count.
881      * To get the total number of tokens minted, please see {_totalMinted}.
882      */
883     function totalSupply() external view returns (uint256);
884 
885     // =============================================================
886     //                            IERC165
887     // =============================================================
888 
889     /**
890      * @dev Returns true if this contract implements the interface defined by
891      * `interfaceId`. See the corresponding
892      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
893      * to learn more about how these ids are created.
894      *
895      * This function call must use less than 30000 gas.
896      */
897     function supportsInterface(bytes4 interfaceId) external view returns (bool);
898 
899     // =============================================================
900     //                            IERC721
901     // =============================================================
902 
903     /**
904      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
905      */
906     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
907 
908     /**
909      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
910      */
911     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
912 
913     /**
914      * @dev Emitted when `owner` enables or disables
915      * (`approved`) `operator` to manage all of its assets.
916      */
917     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
918 
919     /**
920      * @dev Returns the number of tokens in `owner`'s account.
921      */
922     function balanceOf(address owner) external view returns (uint256 balance);
923 
924     /**
925      * @dev Returns the owner of the `tokenId` token.
926      *
927      * Requirements:
928      *
929      * - `tokenId` must exist.
930      */
931     function ownerOf(uint256 tokenId) external view returns (address owner);
932 
933     /**
934      * @dev Safely transfers `tokenId` token from `from` to `to`,
935      * checking first that contract recipients are aware of the ERC721 protocol
936      * to prevent tokens from being forever locked.
937      *
938      * Requirements:
939      *
940      * - `from` cannot be the zero address.
941      * - `to` cannot be the zero address.
942      * - `tokenId` token must exist and be owned by `from`.
943      * - If the caller is not `from`, it must be have been allowed to move
944      * this token by either {approve} or {setApprovalForAll}.
945      * - If `to` refers to a smart contract, it must implement
946      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
947      *
948      * Emits a {Transfer} event.
949      */
950     function safeTransferFrom(
951         address from,
952         address to,
953         uint256 tokenId,
954         bytes calldata data
955     ) external payable;
956 
957     /**
958      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
959      */
960     function safeTransferFrom(
961         address from,
962         address to,
963         uint256 tokenId
964     ) external payable;
965 
966     /**
967      * @dev Transfers `tokenId` from `from` to `to`.
968      *
969      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
970      * whenever possible.
971      *
972      * Requirements:
973      *
974      * - `from` cannot be the zero address.
975      * - `to` cannot be the zero address.
976      * - `tokenId` token must be owned by `from`.
977      * - If the caller is not `from`, it must be approved to move this token
978      * by either {approve} or {setApprovalForAll}.
979      *
980      * Emits a {Transfer} event.
981      */
982     function transferFrom(
983         address from,
984         address to,
985         uint256 tokenId
986     ) external payable;
987 
988     /**
989      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
990      * The approval is cleared when the token is transferred.
991      *
992      * Only a single account can be approved at a time, so approving the
993      * zero address clears previous approvals.
994      *
995      * Requirements:
996      *
997      * - The caller must own the token or be an approved operator.
998      * - `tokenId` must exist.
999      *
1000      * Emits an {Approval} event.
1001      */
1002     function approve(address to, uint256 tokenId) external payable;
1003 
1004     /**
1005      * @dev Approve or remove `operator` as an operator for the caller.
1006      * Operators can call {transferFrom} or {safeTransferFrom}
1007      * for any token owned by the caller.
1008      *
1009      * Requirements:
1010      *
1011      * - The `operator` cannot be the caller.
1012      *
1013      * Emits an {ApprovalForAll} event.
1014      */
1015     function setApprovalForAll(address operator, bool _approved) external;
1016 
1017     /**
1018      * @dev Returns the account approved for `tokenId` token.
1019      *
1020      * Requirements:
1021      *
1022      * - `tokenId` must exist.
1023      */
1024     function getApproved(uint256 tokenId) external view returns (address operator);
1025 
1026     /**
1027      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1028      *
1029      * See {setApprovalForAll}.
1030      */
1031     function isApprovedForAll(address owner, address operator) external view returns (bool);
1032 
1033     // =============================================================
1034     //                        IERC721Metadata
1035     // =============================================================
1036 
1037     /**
1038      * @dev Returns the token collection name.
1039      */
1040     function name() external view returns (string memory);
1041 
1042     /**
1043      * @dev Returns the token collection symbol.
1044      */
1045     function symbol() external view returns (string memory);
1046 
1047     /**
1048      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1049      */
1050     function tokenURI(uint256 tokenId) external view returns (string memory);
1051 
1052     // =============================================================
1053     //                           IERC2309
1054     // =============================================================
1055 
1056     /**
1057      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1058      * (inclusive) is transferred from `from` to `to`, as defined in the
1059      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1060      *
1061      * See {_mintERC2309} for more details.
1062      */
1063     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1064 }
1065 
1066 // File: erc721a/contracts/ERC721A.sol
1067 
1068 
1069 // ERC721A Contracts v4.2.3
1070 // Creator: Chiru Labs
1071 
1072 pragma solidity ^0.8.4;
1073 
1074 
1075 /**
1076  * @dev Interface of ERC721 token receiver.
1077  */
1078 interface ERC721A__IERC721Receiver {
1079     function onERC721Received(
1080         address operator,
1081         address from,
1082         uint256 tokenId,
1083         bytes calldata data
1084     ) external returns (bytes4);
1085 }
1086 
1087 /**
1088  * @title ERC721A
1089  *
1090  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1091  * Non-Fungible Token Standard, including the Metadata extension.
1092  * Optimized for lower gas during batch mints.
1093  *
1094  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1095  * starting from `_startTokenId()`.
1096  *
1097  * Assumptions:
1098  *
1099  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1100  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1101  */
1102 contract ERC721A is IERC721A {
1103     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1104     struct TokenApprovalRef {
1105         address value;
1106     }
1107 
1108     // =============================================================
1109     //                           CONSTANTS
1110     // =============================================================
1111 
1112     // Mask of an entry in packed address data.
1113     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1114 
1115     // The bit position of `numberMinted` in packed address data.
1116     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1117 
1118     // The bit position of `numberBurned` in packed address data.
1119     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1120 
1121     // The bit position of `aux` in packed address data.
1122     uint256 private constant _BITPOS_AUX = 192;
1123 
1124     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1125     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1126 
1127     // The bit position of `startTimestamp` in packed ownership.
1128     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1129 
1130     // The bit mask of the `burned` bit in packed ownership.
1131     uint256 private constant _BITMASK_BURNED = 1 << 224;
1132 
1133     // The bit position of the `nextInitialized` bit in packed ownership.
1134     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1135 
1136     // The bit mask of the `nextInitialized` bit in packed ownership.
1137     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1138 
1139     // The bit position of `extraData` in packed ownership.
1140     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1141 
1142     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1143     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1144 
1145     // The mask of the lower 160 bits for addresses.
1146     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1147 
1148     // The maximum `quantity` that can be minted with {_mintERC2309}.
1149     // This limit is to prevent overflows on the address data entries.
1150     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1151     // is required to cause an overflow, which is unrealistic.
1152     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1153 
1154     // The `Transfer` event signature is given by:
1155     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1156     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1157         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1158 
1159     // =============================================================
1160     //                            STORAGE
1161     // =============================================================
1162 
1163     // The next token ID to be minted.
1164     uint256 private _currentIndex;
1165 
1166     // The number of tokens burned.
1167     uint256 private _burnCounter;
1168 
1169     // Token name
1170     string private _name;
1171 
1172     // Token symbol
1173     string private _symbol;
1174 
1175     // Mapping from token ID to ownership details
1176     // An empty struct value does not necessarily mean the token is unowned.
1177     // See {_packedOwnershipOf} implementation for details.
1178     //
1179     // Bits Layout:
1180     // - [0..159]   `addr`
1181     // - [160..223] `startTimestamp`
1182     // - [224]      `burned`
1183     // - [225]      `nextInitialized`
1184     // - [232..255] `extraData`
1185     mapping(uint256 => uint256) private _packedOwnerships;
1186 
1187     // Mapping owner address to address data.
1188     //
1189     // Bits Layout:
1190     // - [0..63]    `balance`
1191     // - [64..127]  `numberMinted`
1192     // - [128..191] `numberBurned`
1193     // - [192..255] `aux`
1194     mapping(address => uint256) private _packedAddressData;
1195 
1196     // Mapping from token ID to approved address.
1197     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1198 
1199     // Mapping from owner to operator approvals
1200     mapping(address => mapping(address => bool)) private _operatorApprovals;
1201 
1202     // =============================================================
1203     //                          CONSTRUCTOR
1204     // =============================================================
1205 
1206     constructor(string memory name_, string memory symbol_) {
1207         _name = name_;
1208         _symbol = symbol_;
1209         _currentIndex = _startTokenId();
1210     }
1211 
1212     // =============================================================
1213     //                   TOKEN COUNTING OPERATIONS
1214     // =============================================================
1215 
1216     /**
1217      * @dev Returns the starting token ID.
1218      * To change the starting token ID, please override this function.
1219      */
1220     function _startTokenId() internal view virtual returns (uint256) {
1221         return 0;
1222     }
1223 
1224     /**
1225      * @dev Returns the next token ID to be minted.
1226      */
1227     function _nextTokenId() internal view virtual returns (uint256) {
1228         return _currentIndex;
1229     }
1230 
1231     /**
1232      * @dev Returns the total number of tokens in existence.
1233      * Burned tokens will reduce the count.
1234      * To get the total number of tokens minted, please see {_totalMinted}.
1235      */
1236     function totalSupply() public view virtual override returns (uint256) {
1237         // Counter underflow is impossible as _burnCounter cannot be incremented
1238         // more than `_currentIndex - _startTokenId()` times.
1239         unchecked {
1240             return _currentIndex - _burnCounter - _startTokenId();
1241         }
1242     }
1243 
1244     /**
1245      * @dev Returns the total amount of tokens minted in the contract.
1246      */
1247     function _totalMinted() internal view virtual returns (uint256) {
1248         // Counter underflow is impossible as `_currentIndex` does not decrement,
1249         // and it is initialized to `_startTokenId()`.
1250         unchecked {
1251             return _currentIndex - _startTokenId();
1252         }
1253     }
1254 
1255     /**
1256      * @dev Returns the total number of tokens burned.
1257      */
1258     function _totalBurned() internal view virtual returns (uint256) {
1259         return _burnCounter;
1260     }
1261 
1262     // =============================================================
1263     //                    ADDRESS DATA OPERATIONS
1264     // =============================================================
1265 
1266     /**
1267      * @dev Returns the number of tokens in `owner`'s account.
1268      */
1269     function balanceOf(address owner) public view virtual override returns (uint256) {
1270         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1271         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1272     }
1273 
1274     /**
1275      * Returns the number of tokens minted by `owner`.
1276      */
1277     function _numberMinted(address owner) internal view returns (uint256) {
1278         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1279     }
1280 
1281     /**
1282      * Returns the number of tokens burned by or on behalf of `owner`.
1283      */
1284     function _numberBurned(address owner) internal view returns (uint256) {
1285         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1286     }
1287 
1288     /**
1289      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1290      */
1291     function _getAux(address owner) internal view returns (uint64) {
1292         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1293     }
1294 
1295     /**
1296      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1297      * If there are multiple variables, please pack them into a uint64.
1298      */
1299     function _setAux(address owner, uint64 aux) internal virtual {
1300         uint256 packed = _packedAddressData[owner];
1301         uint256 auxCasted;
1302         // Cast `aux` with assembly to avoid redundant masking.
1303         assembly {
1304             auxCasted := aux
1305         }
1306         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1307         _packedAddressData[owner] = packed;
1308     }
1309 
1310     // =============================================================
1311     //                            IERC165
1312     // =============================================================
1313 
1314     /**
1315      * @dev Returns true if this contract implements the interface defined by
1316      * `interfaceId`. See the corresponding
1317      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1318      * to learn more about how these ids are created.
1319      *
1320      * This function call must use less than 30000 gas.
1321      */
1322     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1323         // The interface IDs are constants representing the first 4 bytes
1324         // of the XOR of all function selectors in the interface.
1325         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1326         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1327         return
1328             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1329             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1330             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1331     }
1332 
1333     // =============================================================
1334     //                        IERC721Metadata
1335     // =============================================================
1336 
1337     /**
1338      * @dev Returns the token collection name.
1339      */
1340     function name() public view virtual override returns (string memory) {
1341         return _name;
1342     }
1343 
1344     /**
1345      * @dev Returns the token collection symbol.
1346      */
1347     function symbol() public view virtual override returns (string memory) {
1348         return _symbol;
1349     }
1350 
1351     /**
1352      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1353      */
1354     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1355         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1356 
1357         string memory baseURI = _baseURI();
1358         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1359     }
1360 
1361     /**
1362      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1363      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1364      * by default, it can be overridden in child contracts.
1365      */
1366     function _baseURI() internal view virtual returns (string memory) {
1367         return '';
1368     }
1369 
1370     // =============================================================
1371     //                     OWNERSHIPS OPERATIONS
1372     // =============================================================
1373 
1374     /**
1375      * @dev Returns the owner of the `tokenId` token.
1376      *
1377      * Requirements:
1378      *
1379      * - `tokenId` must exist.
1380      */
1381     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1382         return address(uint160(_packedOwnershipOf(tokenId)));
1383     }
1384 
1385     /**
1386      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1387      * It gradually moves to O(1) as tokens get transferred around over time.
1388      */
1389     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1390         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1391     }
1392 
1393     /**
1394      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1395      */
1396     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1397         return _unpackedOwnership(_packedOwnerships[index]);
1398     }
1399 
1400     /**
1401      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1402      */
1403     function _initializeOwnershipAt(uint256 index) internal virtual {
1404         if (_packedOwnerships[index] == 0) {
1405             _packedOwnerships[index] = _packedOwnershipOf(index);
1406         }
1407     }
1408 
1409     /**
1410      * Returns the packed ownership data of `tokenId`.
1411      */
1412     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1413         uint256 curr = tokenId;
1414 
1415         unchecked {
1416             if (_startTokenId() <= curr)
1417                 if (curr < _currentIndex) {
1418                     uint256 packed = _packedOwnerships[curr];
1419                     // If not burned.
1420                     if (packed & _BITMASK_BURNED == 0) {
1421                         // Invariant:
1422                         // There will always be an initialized ownership slot
1423                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1424                         // before an unintialized ownership slot
1425                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1426                         // Hence, `curr` will not underflow.
1427                         //
1428                         // We can directly compare the packed value.
1429                         // If the address is zero, packed will be zero.
1430                         while (packed == 0) {
1431                             packed = _packedOwnerships[--curr];
1432                         }
1433                         return packed;
1434                     }
1435                 }
1436         }
1437         revert OwnerQueryForNonexistentToken();
1438     }
1439 
1440     /**
1441      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1442      */
1443     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1444         ownership.addr = address(uint160(packed));
1445         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1446         ownership.burned = packed & _BITMASK_BURNED != 0;
1447         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1448     }
1449 
1450     /**
1451      * @dev Packs ownership data into a single uint256.
1452      */
1453     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1454         assembly {
1455             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1456             owner := and(owner, _BITMASK_ADDRESS)
1457             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1458             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1459         }
1460     }
1461 
1462     /**
1463      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1464      */
1465     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1466         // For branchless setting of the `nextInitialized` flag.
1467         assembly {
1468             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1469             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1470         }
1471     }
1472 
1473     // =============================================================
1474     //                      APPROVAL OPERATIONS
1475     // =============================================================
1476 
1477     /**
1478      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1479      * The approval is cleared when the token is transferred.
1480      *
1481      * Only a single account can be approved at a time, so approving the
1482      * zero address clears previous approvals.
1483      *
1484      * Requirements:
1485      *
1486      * - The caller must own the token or be an approved operator.
1487      * - `tokenId` must exist.
1488      *
1489      * Emits an {Approval} event.
1490      */
1491     function approve(address to, uint256 tokenId) public payable virtual override {
1492         address owner = ownerOf(tokenId);
1493 
1494         if (_msgSenderERC721A() != owner)
1495             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1496                 revert ApprovalCallerNotOwnerNorApproved();
1497             }
1498 
1499         _tokenApprovals[tokenId].value = to;
1500         emit Approval(owner, to, tokenId);
1501     }
1502 
1503     /**
1504      * @dev Returns the account approved for `tokenId` token.
1505      *
1506      * Requirements:
1507      *
1508      * - `tokenId` must exist.
1509      */
1510     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1511         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1512 
1513         return _tokenApprovals[tokenId].value;
1514     }
1515 
1516     /**
1517      * @dev Approve or remove `operator` as an operator for the caller.
1518      * Operators can call {transferFrom} or {safeTransferFrom}
1519      * for any token owned by the caller.
1520      *
1521      * Requirements:
1522      *
1523      * - The `operator` cannot be the caller.
1524      *
1525      * Emits an {ApprovalForAll} event.
1526      */
1527     function setApprovalForAll(address operator, bool approved) public virtual override {
1528         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1529         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1530     }
1531 
1532     /**
1533      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1534      *
1535      * See {setApprovalForAll}.
1536      */
1537     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1538         return _operatorApprovals[owner][operator];
1539     }
1540 
1541     /**
1542      * @dev Returns whether `tokenId` exists.
1543      *
1544      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1545      *
1546      * Tokens start existing when they are minted. See {_mint}.
1547      */
1548     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1549         return
1550             _startTokenId() <= tokenId &&
1551             tokenId < _currentIndex && // If within bounds,
1552             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1553     }
1554 
1555     /**
1556      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1557      */
1558     function _isSenderApprovedOrOwner(
1559         address approvedAddress,
1560         address owner,
1561         address msgSender
1562     ) private pure returns (bool result) {
1563         assembly {
1564             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1565             owner := and(owner, _BITMASK_ADDRESS)
1566             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1567             msgSender := and(msgSender, _BITMASK_ADDRESS)
1568             // `msgSender == owner || msgSender == approvedAddress`.
1569             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1570         }
1571     }
1572 
1573     /**
1574      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1575      */
1576     function _getApprovedSlotAndAddress(uint256 tokenId)
1577         private
1578         view
1579         returns (uint256 approvedAddressSlot, address approvedAddress)
1580     {
1581         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1582         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1583         assembly {
1584             approvedAddressSlot := tokenApproval.slot
1585             approvedAddress := sload(approvedAddressSlot)
1586         }
1587     }
1588 
1589     // =============================================================
1590     //                      TRANSFER OPERATIONS
1591     // =============================================================
1592 
1593     /**
1594      * @dev Transfers `tokenId` from `from` to `to`.
1595      *
1596      * Requirements:
1597      *
1598      * - `from` cannot be the zero address.
1599      * - `to` cannot be the zero address.
1600      * - `tokenId` token must be owned by `from`.
1601      * - If the caller is not `from`, it must be approved to move this token
1602      * by either {approve} or {setApprovalForAll}.
1603      *
1604      * Emits a {Transfer} event.
1605      */
1606     function transferFrom(
1607         address from,
1608         address to,
1609         uint256 tokenId
1610     ) public payable virtual override {
1611         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1612 
1613         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1614 
1615         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1616 
1617         // The nested ifs save around 20+ gas over a compound boolean condition.
1618         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1619             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1620 
1621         if (to == address(0)) revert TransferToZeroAddress();
1622 
1623         _beforeTokenTransfers(from, to, tokenId, 1);
1624 
1625         // Clear approvals from the previous owner.
1626         assembly {
1627             if approvedAddress {
1628                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1629                 sstore(approvedAddressSlot, 0)
1630             }
1631         }
1632 
1633         // Underflow of the sender's balance is impossible because we check for
1634         // ownership above and the recipient's balance can't realistically overflow.
1635         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1636         unchecked {
1637             // We can directly increment and decrement the balances.
1638             --_packedAddressData[from]; // Updates: `balance -= 1`.
1639             ++_packedAddressData[to]; // Updates: `balance += 1`.
1640 
1641             // Updates:
1642             // - `address` to the next owner.
1643             // - `startTimestamp` to the timestamp of transfering.
1644             // - `burned` to `false`.
1645             // - `nextInitialized` to `true`.
1646             _packedOwnerships[tokenId] = _packOwnershipData(
1647                 to,
1648                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1649             );
1650 
1651             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1652             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1653                 uint256 nextTokenId = tokenId + 1;
1654                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1655                 if (_packedOwnerships[nextTokenId] == 0) {
1656                     // If the next slot is within bounds.
1657                     if (nextTokenId != _currentIndex) {
1658                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1659                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1660                     }
1661                 }
1662             }
1663         }
1664 
1665         emit Transfer(from, to, tokenId);
1666         _afterTokenTransfers(from, to, tokenId, 1);
1667     }
1668 
1669     /**
1670      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1671      */
1672     function safeTransferFrom(
1673         address from,
1674         address to,
1675         uint256 tokenId
1676     ) public payable virtual override {
1677         safeTransferFrom(from, to, tokenId, '');
1678     }
1679 
1680     /**
1681      * @dev Safely transfers `tokenId` token from `from` to `to`.
1682      *
1683      * Requirements:
1684      *
1685      * - `from` cannot be the zero address.
1686      * - `to` cannot be the zero address.
1687      * - `tokenId` token must exist and be owned by `from`.
1688      * - If the caller is not `from`, it must be approved to move this token
1689      * by either {approve} or {setApprovalForAll}.
1690      * - If `to` refers to a smart contract, it must implement
1691      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1692      *
1693      * Emits a {Transfer} event.
1694      */
1695     function safeTransferFrom(
1696         address from,
1697         address to,
1698         uint256 tokenId,
1699         bytes memory _data
1700     ) public payable virtual override {
1701         transferFrom(from, to, tokenId);
1702         if (to.code.length != 0)
1703             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1704                 revert TransferToNonERC721ReceiverImplementer();
1705             }
1706     }
1707 
1708     /**
1709      * @dev Hook that is called before a set of serially-ordered token IDs
1710      * are about to be transferred. This includes minting.
1711      * And also called before burning one token.
1712      *
1713      * `startTokenId` - the first token ID to be transferred.
1714      * `quantity` - the amount to be transferred.
1715      *
1716      * Calling conditions:
1717      *
1718      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1719      * transferred to `to`.
1720      * - When `from` is zero, `tokenId` will be minted for `to`.
1721      * - When `to` is zero, `tokenId` will be burned by `from`.
1722      * - `from` and `to` are never both zero.
1723      */
1724     function _beforeTokenTransfers(
1725         address from,
1726         address to,
1727         uint256 startTokenId,
1728         uint256 quantity
1729     ) internal virtual {}
1730 
1731     /**
1732      * @dev Hook that is called after a set of serially-ordered token IDs
1733      * have been transferred. This includes minting.
1734      * And also called after one token has been burned.
1735      *
1736      * `startTokenId` - the first token ID to be transferred.
1737      * `quantity` - the amount to be transferred.
1738      *
1739      * Calling conditions:
1740      *
1741      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1742      * transferred to `to`.
1743      * - When `from` is zero, `tokenId` has been minted for `to`.
1744      * - When `to` is zero, `tokenId` has been burned by `from`.
1745      * - `from` and `to` are never both zero.
1746      */
1747     function _afterTokenTransfers(
1748         address from,
1749         address to,
1750         uint256 startTokenId,
1751         uint256 quantity
1752     ) internal virtual {}
1753 
1754     /**
1755      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1756      *
1757      * `from` - Previous owner of the given token ID.
1758      * `to` - Target address that will receive the token.
1759      * `tokenId` - Token ID to be transferred.
1760      * `_data` - Optional data to send along with the call.
1761      *
1762      * Returns whether the call correctly returned the expected magic value.
1763      */
1764     function _checkContractOnERC721Received(
1765         address from,
1766         address to,
1767         uint256 tokenId,
1768         bytes memory _data
1769     ) private returns (bool) {
1770         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1771             bytes4 retval
1772         ) {
1773             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1774         } catch (bytes memory reason) {
1775             if (reason.length == 0) {
1776                 revert TransferToNonERC721ReceiverImplementer();
1777             } else {
1778                 assembly {
1779                     revert(add(32, reason), mload(reason))
1780                 }
1781             }
1782         }
1783     }
1784 
1785     // =============================================================
1786     //                        MINT OPERATIONS
1787     // =============================================================
1788 
1789     /**
1790      * @dev Mints `quantity` tokens and transfers them to `to`.
1791      *
1792      * Requirements:
1793      *
1794      * - `to` cannot be the zero address.
1795      * - `quantity` must be greater than 0.
1796      *
1797      * Emits a {Transfer} event for each mint.
1798      */
1799     function _mint(address to, uint256 quantity) internal virtual {
1800         uint256 startTokenId = _currentIndex;
1801         if (quantity == 0) revert MintZeroQuantity();
1802 
1803         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1804 
1805         // Overflows are incredibly unrealistic.
1806         // `balance` and `numberMinted` have a maximum limit of 2**64.
1807         // `tokenId` has a maximum limit of 2**256.
1808         unchecked {
1809             // Updates:
1810             // - `balance += quantity`.
1811             // - `numberMinted += quantity`.
1812             //
1813             // We can directly add to the `balance` and `numberMinted`.
1814             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1815 
1816             // Updates:
1817             // - `address` to the owner.
1818             // - `startTimestamp` to the timestamp of minting.
1819             // - `burned` to `false`.
1820             // - `nextInitialized` to `quantity == 1`.
1821             _packedOwnerships[startTokenId] = _packOwnershipData(
1822                 to,
1823                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1824             );
1825 
1826             uint256 toMasked;
1827             uint256 end = startTokenId + quantity;
1828 
1829             // Use assembly to loop and emit the `Transfer` event for gas savings.
1830             // The duplicated `log4` removes an extra check and reduces stack juggling.
1831             // The assembly, together with the surrounding Solidity code, have been
1832             // delicately arranged to nudge the compiler into producing optimized opcodes.
1833             assembly {
1834                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1835                 toMasked := and(to, _BITMASK_ADDRESS)
1836                 // Emit the `Transfer` event.
1837                 log4(
1838                     0, // Start of data (0, since no data).
1839                     0, // End of data (0, since no data).
1840                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1841                     0, // `address(0)`.
1842                     toMasked, // `to`.
1843                     startTokenId // `tokenId`.
1844                 )
1845 
1846                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1847                 // that overflows uint256 will make the loop run out of gas.
1848                 // The compiler will optimize the `iszero` away for performance.
1849                 for {
1850                     let tokenId := add(startTokenId, 1)
1851                 } iszero(eq(tokenId, end)) {
1852                     tokenId := add(tokenId, 1)
1853                 } {
1854                     // Emit the `Transfer` event. Similar to above.
1855                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1856                 }
1857             }
1858             if (toMasked == 0) revert MintToZeroAddress();
1859 
1860             _currentIndex = end;
1861         }
1862         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1863     }
1864 
1865     /**
1866      * @dev Mints `quantity` tokens and transfers them to `to`.
1867      *
1868      * This function is intended for efficient minting only during contract creation.
1869      *
1870      * It emits only one {ConsecutiveTransfer} as defined in
1871      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1872      * instead of a sequence of {Transfer} event(s).
1873      *
1874      * Calling this function outside of contract creation WILL make your contract
1875      * non-compliant with the ERC721 standard.
1876      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1877      * {ConsecutiveTransfer} event is only permissible during contract creation.
1878      *
1879      * Requirements:
1880      *
1881      * - `to` cannot be the zero address.
1882      * - `quantity` must be greater than 0.
1883      *
1884      * Emits a {ConsecutiveTransfer} event.
1885      */
1886     function _mintERC2309(address to, uint256 quantity) internal virtual {
1887         uint256 startTokenId = _currentIndex;
1888         if (to == address(0)) revert MintToZeroAddress();
1889         if (quantity == 0) revert MintZeroQuantity();
1890         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1891 
1892         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1893 
1894         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1895         unchecked {
1896             // Updates:
1897             // - `balance += quantity`.
1898             // - `numberMinted += quantity`.
1899             //
1900             // We can directly add to the `balance` and `numberMinted`.
1901             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1902 
1903             // Updates:
1904             // - `address` to the owner.
1905             // - `startTimestamp` to the timestamp of minting.
1906             // - `burned` to `false`.
1907             // - `nextInitialized` to `quantity == 1`.
1908             _packedOwnerships[startTokenId] = _packOwnershipData(
1909                 to,
1910                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1911             );
1912 
1913             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1914 
1915             _currentIndex = startTokenId + quantity;
1916         }
1917         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1918     }
1919 
1920     /**
1921      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1922      *
1923      * Requirements:
1924      *
1925      * - If `to` refers to a smart contract, it must implement
1926      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1927      * - `quantity` must be greater than 0.
1928      *
1929      * See {_mint}.
1930      *
1931      * Emits a {Transfer} event for each mint.
1932      */
1933     function _safeMint(
1934         address to,
1935         uint256 quantity,
1936         bytes memory _data
1937     ) internal virtual {
1938         _mint(to, quantity);
1939 
1940         unchecked {
1941             if (to.code.length != 0) {
1942                 uint256 end = _currentIndex;
1943                 uint256 index = end - quantity;
1944                 do {
1945                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1946                         revert TransferToNonERC721ReceiverImplementer();
1947                     }
1948                 } while (index < end);
1949                 // Reentrancy protection.
1950                 if (_currentIndex != end) revert();
1951             }
1952         }
1953     }
1954 
1955     /**
1956      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1957      */
1958     function _safeMint(address to, uint256 quantity) internal virtual {
1959         _safeMint(to, quantity, '');
1960     }
1961 
1962     // =============================================================
1963     //                        BURN OPERATIONS
1964     // =============================================================
1965 
1966     /**
1967      * @dev Equivalent to `_burn(tokenId, false)`.
1968      */
1969     function _burn(uint256 tokenId) internal virtual {
1970         _burn(tokenId, false);
1971     }
1972 
1973     /**
1974      * @dev Destroys `tokenId`.
1975      * The approval is cleared when the token is burned.
1976      *
1977      * Requirements:
1978      *
1979      * - `tokenId` must exist.
1980      *
1981      * Emits a {Transfer} event.
1982      */
1983     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1984         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1985 
1986         address from = address(uint160(prevOwnershipPacked));
1987 
1988         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1989 
1990         if (approvalCheck) {
1991             // The nested ifs save around 20+ gas over a compound boolean condition.
1992             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1993                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1994         }
1995 
1996         _beforeTokenTransfers(from, address(0), tokenId, 1);
1997 
1998         // Clear approvals from the previous owner.
1999         assembly {
2000             if approvedAddress {
2001                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2002                 sstore(approvedAddressSlot, 0)
2003             }
2004         }
2005 
2006         // Underflow of the sender's balance is impossible because we check for
2007         // ownership above and the recipient's balance can't realistically overflow.
2008         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2009         unchecked {
2010             // Updates:
2011             // - `balance -= 1`.
2012             // - `numberBurned += 1`.
2013             //
2014             // We can directly decrement the balance, and increment the number burned.
2015             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2016             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2017 
2018             // Updates:
2019             // - `address` to the last owner.
2020             // - `startTimestamp` to the timestamp of burning.
2021             // - `burned` to `true`.
2022             // - `nextInitialized` to `true`.
2023             _packedOwnerships[tokenId] = _packOwnershipData(
2024                 from,
2025                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2026             );
2027 
2028             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2029             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2030                 uint256 nextTokenId = tokenId + 1;
2031                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2032                 if (_packedOwnerships[nextTokenId] == 0) {
2033                     // If the next slot is within bounds.
2034                     if (nextTokenId != _currentIndex) {
2035                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2036                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2037                     }
2038                 }
2039             }
2040         }
2041 
2042         emit Transfer(from, address(0), tokenId);
2043         _afterTokenTransfers(from, address(0), tokenId, 1);
2044 
2045         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2046         unchecked {
2047             _burnCounter++;
2048         }
2049     }
2050 
2051     // =============================================================
2052     //                     EXTRA DATA OPERATIONS
2053     // =============================================================
2054 
2055     /**
2056      * @dev Directly sets the extra data for the ownership data `index`.
2057      */
2058     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2059         uint256 packed = _packedOwnerships[index];
2060         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2061         uint256 extraDataCasted;
2062         // Cast `extraData` with assembly to avoid redundant masking.
2063         assembly {
2064             extraDataCasted := extraData
2065         }
2066         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2067         _packedOwnerships[index] = packed;
2068     }
2069 
2070     /**
2071      * @dev Called during each token transfer to set the 24bit `extraData` field.
2072      * Intended to be overridden by the cosumer contract.
2073      *
2074      * `previousExtraData` - the value of `extraData` before transfer.
2075      *
2076      * Calling conditions:
2077      *
2078      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2079      * transferred to `to`.
2080      * - When `from` is zero, `tokenId` will be minted for `to`.
2081      * - When `to` is zero, `tokenId` will be burned by `from`.
2082      * - `from` and `to` are never both zero.
2083      */
2084     function _extraData(
2085         address from,
2086         address to,
2087         uint24 previousExtraData
2088     ) internal view virtual returns (uint24) {}
2089 
2090     /**
2091      * @dev Returns the next extra data for the packed ownership data.
2092      * The returned result is shifted into position.
2093      */
2094     function _nextExtraData(
2095         address from,
2096         address to,
2097         uint256 prevOwnershipPacked
2098     ) private view returns (uint256) {
2099         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2100         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2101     }
2102 
2103     // =============================================================
2104     //                       OTHER OPERATIONS
2105     // =============================================================
2106 
2107     /**
2108      * @dev Returns the message sender (defaults to `msg.sender`).
2109      *
2110      * If you are writing GSN compatible contracts, you need to override this function.
2111      */
2112     function _msgSenderERC721A() internal view virtual returns (address) {
2113         return msg.sender;
2114     }
2115 
2116     /**
2117      * @dev Converts a uint256 to its ASCII string decimal representation.
2118      */
2119     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2120         assembly {
2121             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2122             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2123             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2124             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2125             let m := add(mload(0x40), 0xa0)
2126             // Update the free memory pointer to allocate.
2127             mstore(0x40, m)
2128             // Assign the `str` to the end.
2129             str := sub(m, 0x20)
2130             // Zeroize the slot after the string.
2131             mstore(str, 0)
2132 
2133             // Cache the end of the memory to calculate the length later.
2134             let end := str
2135 
2136             // We write the string from rightmost digit to leftmost digit.
2137             // The following is essentially a do-while loop that also handles the zero case.
2138             // prettier-ignore
2139             for { let temp := value } 1 {} {
2140                 str := sub(str, 1)
2141                 // Write the character to the pointer.
2142                 // The ASCII index of the '0' character is 48.
2143                 mstore8(str, add(48, mod(temp, 10)))
2144                 // Keep dividing `temp` until zero.
2145                 temp := div(temp, 10)
2146                 // prettier-ignore
2147                 if iszero(temp) { break }
2148             }
2149 
2150             let length := sub(end, str)
2151             // Move the pointer 32 bytes leftwards to make room for the length.
2152             str := sub(str, 0x20)
2153             // Store the length.
2154             mstore(str, length)
2155         }
2156     }
2157 }
2158 
2159 // File: contracts/t.sol
2160 
2161 
2162 // ERC721A Contracts v4.2.3
2163 
2164 pragma solidity ^0.8.18;
2165 
2166 
2167 
2168 
2169 
2170 contract CryingTwT is ERC721A, DefaultOperatorFilterer, Ownable{
2171 
2172     using Strings for uint256;
2173     uint256 public constant MAX_SUPPLY = 2888;
2174     uint256 public maxMint = 3; 
2175     uint256 public maxBalance = 3; 
2176     uint256 public mintPrice = 0.0033 ether; 
2177     bool public _isSaleActive = false; 
2178     bool public _revealed = true;
2179     string baseURI;
2180     string public notRevealedUri;
2181     string public baseExtension = ".json";
2182     mapping(uint256 => string) private _tokenURIs;
2183 
2184     constructor(string memory initBaseURI, string memory initNotRevealedUri) 
2185         ERC721A("CryingTwT", "CT") 
2186     {
2187         setBaseURI(initBaseURI);
2188         setNotRevealedURI(initNotRevealedUri);
2189     }
2190 
2191     function mintPublic(uint256 tokenQuantity) public payable {
2192         require(_isSaleActive, "Sale must be active to mint NFT");
2193         require(tokenQuantity <= maxMint, "Mint too many tokens at a time");
2194         require(
2195             balanceOf(msg.sender)  + tokenQuantity <= maxBalance, 
2196             "Sale would exceed max balance"
2197         );
2198         require(
2199             totalSupply() + tokenQuantity <= MAX_SUPPLY,
2200             "Sale would exceed max supply"
2201         );
2202         require(tokenQuantity * mintPrice <= msg.value, "Not enough ether");
2203         _safeMint(msg.sender, tokenQuantity);
2204     }
2205 
2206     function tokenURI(uint256 tokenId)
2207         public
2208         view
2209         virtual
2210         override
2211         returns (string memory)
2212     {
2213         require(
2214             _exists(tokenId),
2215             "URI query for nonexistent token"
2216         );
2217 
2218         if (_revealed == false) {
2219             return notRevealedUri;
2220         }
2221 
2222         string memory _tokenURI = _tokenURIs[tokenId];
2223         string memory base = _baseURI();
2224 
2225         if (bytes(base).length == 0) {
2226             return _tokenURI;
2227         }
2228 
2229         if (bytes(_tokenURI).length > 0) {
2230             return string(abi.encodePacked(base, _tokenURI));
2231         }
2232 
2233         return
2234             string(abi.encodePacked(base, tokenId.toString(), baseExtension));
2235     }
2236 
2237     function _baseURI() internal view virtual override returns (string memory) {
2238         return baseURI;
2239     }
2240 
2241     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2242         baseURI = _newBaseURI;
2243     }
2244 
2245     function flipSaleActive() public onlyOwner {
2246         _isSaleActive = !_isSaleActive;
2247     }
2248 
2249     function flipReveal() public onlyOwner {
2250         _revealed = !_revealed;
2251     }
2252 
2253     function mintOwner(uint256 tokenQuantity) public onlyOwner {
2254         _safeMint(msg.sender, tokenQuantity);
2255     }
2256 
2257     function setMintPrice(uint256 _mintPrice) public onlyOwner {
2258         mintPrice = _mintPrice;
2259     }
2260 
2261     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2262         notRevealedUri = _notRevealedURI;
2263     }
2264 
2265     function setBaseExtension(string memory _newBaseExtension)
2266         public
2267         onlyOwner
2268     {
2269         baseExtension = _newBaseExtension;
2270     }
2271 
2272     function setMaxBalance(uint256 _maxBalance) public onlyOwner {
2273         maxBalance = _maxBalance;
2274     }
2275 
2276     function setMaxMint(uint256 _maxMint) public onlyOwner {
2277         maxMint = _maxMint;
2278     }
2279 
2280     function withdraw(address to) public onlyOwner {
2281         uint256 balance = address(this).balance;
2282         payable(to).transfer(balance);
2283     }
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