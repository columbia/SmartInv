1 /*
2  ________  ________  _______   ________  ________           ________  ___       ________      ___    ___ ________  ________  ________  ___  ___  ________   ________     
3 |\   __  \|\   ____\|\  ___ \ |\   __  \|\   ___  \        |\   __  \|\  \     |\   __  \    |\  \  /  /|\   ____\|\   __  \|\   __  \|\  \|\  \|\   ___  \|\   ___ \    
4 \ \  \|\  \ \  \___|\ \   __/|\ \  \|\  \ \  \\ \  \       \ \  \|\  \ \  \    \ \  \|\  \   \ \  \/  / | \  \___|\ \  \|\  \ \  \|\  \ \  \\\  \ \  \\ \  \ \  \_|\ \   
5  \ \  \\\  \ \  \    \ \  \_|/_\ \   __  \ \  \\ \  \       \ \   ____\ \  \    \ \   __  \   \ \    / / \ \  \  __\ \   _  _\ \  \\\  \ \  \\\  \ \  \\ \  \ \  \ \\ \  
6   \ \  \\\  \ \  \____\ \  \_|\ \ \  \ \  \ \  \\ \  \       \ \  \___|\ \  \____\ \  \ \  \   \/  /  /   \ \  \|\  \ \  \\  \\ \  \\\  \ \  \\\  \ \  \\ \  \ \  \_\\ \ 
7    \ \_______\ \_______\ \_______\ \__\ \__\ \__\\ \__\       \ \__\    \ \_______\ \__\ \__\__/  / /      \ \_______\ \__\\ _\\ \_______\ \_______\ \__\\ \__\ \_______\
8     \|_______|\|_______|\|_______|\|__|\|__|\|__| \|__|        \|__|     \|_______|\|__|\|__|\___/ /        \|_______|\|__|\|__|\|_______|\|_______|\|__| \|__|\|_______|
9                                                                                             \|___|/                                                                      
10                                                                                                                                                                          */ 
11                                                                                                                                                                          
12                                                                                           
13 // SPDX-License-Identifier: MIT
14 // File: operator-filter-registry/src/lib/Constants.sol
15 
16 
17 pragma solidity ^0.8.17;
18 
19 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
20 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
21 
22 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
23 
24 
25 pragma solidity ^0.8.13;
26 
27 interface IOperatorFilterRegistry {
28     /**
29      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
30      *         true if supplied registrant address is not registered.
31      */
32     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
33 
34     /**
35      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
36      */
37     function register(address registrant) external;
38 
39     /**
40      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
41      */
42     function registerAndSubscribe(address registrant, address subscription) external;
43 
44     /**
45      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
46      *         address without subscribing.
47      */
48     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
49 
50     /**
51      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
52      *         Note that this does not remove any filtered addresses or codeHashes.
53      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
54      */
55     function unregister(address addr) external;
56 
57     /**
58      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
59      */
60     function updateOperator(address registrant, address operator, bool filtered) external;
61 
62     /**
63      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
64      */
65     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
66 
67     /**
68      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
69      */
70     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
71 
72     /**
73      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
74      */
75     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
76 
77     /**
78      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
79      *         subscription if present.
80      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
81      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
82      *         used.
83      */
84     function subscribe(address registrant, address registrantToSubscribe) external;
85 
86     /**
87      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
88      */
89     function unsubscribe(address registrant, bool copyExistingEntries) external;
90 
91     /**
92      * @notice Get the subscription address of a given registrant, if any.
93      */
94     function subscriptionOf(address addr) external returns (address registrant);
95 
96     /**
97      * @notice Get the set of addresses subscribed to a given registrant.
98      *         Note that order is not guaranteed as updates are made.
99      */
100     function subscribers(address registrant) external returns (address[] memory);
101 
102     /**
103      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
104      *         Note that order is not guaranteed as updates are made.
105      */
106     function subscriberAt(address registrant, uint256 index) external returns (address);
107 
108     /**
109      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
110      */
111     function copyEntriesOf(address registrant, address registrantToCopy) external;
112 
113     /**
114      * @notice Returns true if operator is filtered by a given address or its subscription.
115      */
116     function isOperatorFiltered(address registrant, address operator) external returns (bool);
117 
118     /**
119      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
120      */
121     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
122 
123     /**
124      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
125      */
126     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
127 
128     /**
129      * @notice Returns a list of filtered operators for a given address or its subscription.
130      */
131     function filteredOperators(address addr) external returns (address[] memory);
132 
133     /**
134      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
135      *         Note that order is not guaranteed as updates are made.
136      */
137     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
138 
139     /**
140      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
141      *         its subscription.
142      *         Note that order is not guaranteed as updates are made.
143      */
144     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
145 
146     /**
147      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
148      *         its subscription.
149      *         Note that order is not guaranteed as updates are made.
150      */
151     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
152 
153     /**
154      * @notice Returns true if an address has registered
155      */
156     function isRegistered(address addr) external returns (bool);
157 
158     /**
159      * @dev Convenience method to compute the code hash of an arbitrary contract
160      */
161     function codeHashOf(address addr) external returns (bytes32);
162 }
163 
164 // File: operator-filter-registry/src/OperatorFilterer.sol
165 
166 
167 pragma solidity ^0.8.13;
168 
169 
170 /**
171  * @title  OperatorFilterer
172  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
173  *         registrant's entries in the OperatorFilterRegistry.
174  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
175  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
176  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
177  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
178  *         administration methods on the contract itself to interact with the registry otherwise the subscription
179  *         will be locked to the options set during construction.
180  */
181 
182 abstract contract OperatorFilterer {
183     /// @dev Emitted when an operator is not allowed.
184     error OperatorNotAllowed(address operator);
185 
186     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
187         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
188 
189     /// @dev The constructor that is called when the contract is being deployed.
190     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
191         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
192         // will not revert, but the contract will need to be registered with the registry once it is deployed in
193         // order for the modifier to filter addresses.
194         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
195             if (subscribe) {
196                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
197             } else {
198                 if (subscriptionOrRegistrantToCopy != address(0)) {
199                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
200                 } else {
201                     OPERATOR_FILTER_REGISTRY.register(address(this));
202                 }
203             }
204         }
205     }
206 
207     /**
208      * @dev A helper function to check if an operator is allowed.
209      */
210     modifier onlyAllowedOperator(address from) virtual {
211         // Allow spending tokens from addresses with balance
212         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
213         // from an EOA.
214         if (from != msg.sender) {
215             _checkFilterOperator(msg.sender);
216         }
217         _;
218     }
219 
220     /**
221      * @dev A helper function to check if an operator approval is allowed.
222      */
223     modifier onlyAllowedOperatorApproval(address operator) virtual {
224         _checkFilterOperator(operator);
225         _;
226     }
227 
228     /**
229      * @dev A helper function to check if an operator is allowed.
230      */
231     function _checkFilterOperator(address operator) internal view virtual {
232         // Check registry code length to facilitate testing in environments without a deployed registry.
233         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
234             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
235             // may specify their own OperatorFilterRegistry implementations, which may behave differently
236             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
237                 revert OperatorNotAllowed(operator);
238             }
239         }
240     }
241 }
242 
243 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
244 
245 
246 pragma solidity ^0.8.13;
247 
248 
249 /**
250  * @title  DefaultOperatorFilterer
251  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
252  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
253  *         administration methods on the contract itself to interact with the registry otherwise the subscription
254  *         will be locked to the options set during construction.
255  */
256 
257 abstract contract DefaultOperatorFilterer is OperatorFilterer {
258     /// @dev The constructor that is called when the contract is being deployed.
259     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
260 }
261 
262 // File: @openzeppelin/contracts/utils/math/Math.sol
263 
264 
265 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Standard math utilities missing in the Solidity language.
271  */
272 library Math {
273     enum Rounding {
274         Down, // Toward negative infinity
275         Up, // Toward infinity
276         Zero // Toward zero
277     }
278 
279     /**
280      * @dev Returns the largest of two numbers.
281      */
282     function max(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a > b ? a : b;
284     }
285 
286     /**
287      * @dev Returns the smallest of two numbers.
288      */
289     function min(uint256 a, uint256 b) internal pure returns (uint256) {
290         return a < b ? a : b;
291     }
292 
293     /**
294      * @dev Returns the average of two numbers. The result is rounded towards
295      * zero.
296      */
297     function average(uint256 a, uint256 b) internal pure returns (uint256) {
298         // (a + b) / 2 can overflow.
299         return (a & b) + (a ^ b) / 2;
300     }
301 
302     /**
303      * @dev Returns the ceiling of the division of two numbers.
304      *
305      * This differs from standard division with `/` in that it rounds up instead
306      * of rounding down.
307      */
308     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
309         // (a + b - 1) / b can overflow on addition, so we distribute.
310         return a == 0 ? 0 : (a - 1) / b + 1;
311     }
312 
313     /**
314      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
315      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
316      * with further edits by Uniswap Labs also under MIT license.
317      */
318     function mulDiv(
319         uint256 x,
320         uint256 y,
321         uint256 denominator
322     ) internal pure returns (uint256 result) {
323         unchecked {
324             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
325             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
326             // variables such that product = prod1 * 2^256 + prod0.
327             uint256 prod0; // Least significant 256 bits of the product
328             uint256 prod1; // Most significant 256 bits of the product
329             assembly {
330                 let mm := mulmod(x, y, not(0))
331                 prod0 := mul(x, y)
332                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
333             }
334 
335             // Handle non-overflow cases, 256 by 256 division.
336             if (prod1 == 0) {
337                 return prod0 / denominator;
338             }
339 
340             // Make sure the result is less than 2^256. Also prevents denominator == 0.
341             require(denominator > prod1);
342 
343             ///////////////////////////////////////////////
344             // 512 by 256 division.
345             ///////////////////////////////////////////////
346 
347             // Make division exact by subtracting the remainder from [prod1 prod0].
348             uint256 remainder;
349             assembly {
350                 // Compute remainder using mulmod.
351                 remainder := mulmod(x, y, denominator)
352 
353                 // Subtract 256 bit number from 512 bit number.
354                 prod1 := sub(prod1, gt(remainder, prod0))
355                 prod0 := sub(prod0, remainder)
356             }
357 
358             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
359             // See https://cs.stackexchange.com/q/138556/92363.
360 
361             // Does not overflow because the denominator cannot be zero at this stage in the function.
362             uint256 twos = denominator & (~denominator + 1);
363             assembly {
364                 // Divide denominator by twos.
365                 denominator := div(denominator, twos)
366 
367                 // Divide [prod1 prod0] by twos.
368                 prod0 := div(prod0, twos)
369 
370                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
371                 twos := add(div(sub(0, twos), twos), 1)
372             }
373 
374             // Shift in bits from prod1 into prod0.
375             prod0 |= prod1 * twos;
376 
377             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
378             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
379             // four bits. That is, denominator * inv = 1 mod 2^4.
380             uint256 inverse = (3 * denominator) ^ 2;
381 
382             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
383             // in modular arithmetic, doubling the correct bits in each step.
384             inverse *= 2 - denominator * inverse; // inverse mod 2^8
385             inverse *= 2 - denominator * inverse; // inverse mod 2^16
386             inverse *= 2 - denominator * inverse; // inverse mod 2^32
387             inverse *= 2 - denominator * inverse; // inverse mod 2^64
388             inverse *= 2 - denominator * inverse; // inverse mod 2^128
389             inverse *= 2 - denominator * inverse; // inverse mod 2^256
390 
391             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
392             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
393             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
394             // is no longer required.
395             result = prod0 * inverse;
396             return result;
397         }
398     }
399 
400     /**
401      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
402      */
403     function mulDiv(
404         uint256 x,
405         uint256 y,
406         uint256 denominator,
407         Rounding rounding
408     ) internal pure returns (uint256) {
409         uint256 result = mulDiv(x, y, denominator);
410         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
411             result += 1;
412         }
413         return result;
414     }
415 
416     /**
417      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
418      *
419      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
420      */
421     function sqrt(uint256 a) internal pure returns (uint256) {
422         if (a == 0) {
423             return 0;
424         }
425 
426         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
427         //
428         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
429         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
430         //
431         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
432         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
433         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
434         //
435         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
436         uint256 result = 1 << (log2(a) >> 1);
437 
438         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
439         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
440         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
441         // into the expected uint128 result.
442         unchecked {
443             result = (result + a / result) >> 1;
444             result = (result + a / result) >> 1;
445             result = (result + a / result) >> 1;
446             result = (result + a / result) >> 1;
447             result = (result + a / result) >> 1;
448             result = (result + a / result) >> 1;
449             result = (result + a / result) >> 1;
450             return min(result, a / result);
451         }
452     }
453 
454     /**
455      * @notice Calculates sqrt(a), following the selected rounding direction.
456      */
457     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
458         unchecked {
459             uint256 result = sqrt(a);
460             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
461         }
462     }
463 
464     /**
465      * @dev Return the log in base 2, rounded down, of a positive value.
466      * Returns 0 if given 0.
467      */
468     function log2(uint256 value) internal pure returns (uint256) {
469         uint256 result = 0;
470         unchecked {
471             if (value >> 128 > 0) {
472                 value >>= 128;
473                 result += 128;
474             }
475             if (value >> 64 > 0) {
476                 value >>= 64;
477                 result += 64;
478             }
479             if (value >> 32 > 0) {
480                 value >>= 32;
481                 result += 32;
482             }
483             if (value >> 16 > 0) {
484                 value >>= 16;
485                 result += 16;
486             }
487             if (value >> 8 > 0) {
488                 value >>= 8;
489                 result += 8;
490             }
491             if (value >> 4 > 0) {
492                 value >>= 4;
493                 result += 4;
494             }
495             if (value >> 2 > 0) {
496                 value >>= 2;
497                 result += 2;
498             }
499             if (value >> 1 > 0) {
500                 result += 1;
501             }
502         }
503         return result;
504     }
505 
506     /**
507      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
508      * Returns 0 if given 0.
509      */
510     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
511         unchecked {
512             uint256 result = log2(value);
513             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
514         }
515     }
516 
517     /**
518      * @dev Return the log in base 10, rounded down, of a positive value.
519      * Returns 0 if given 0.
520      */
521     function log10(uint256 value) internal pure returns (uint256) {
522         uint256 result = 0;
523         unchecked {
524             if (value >= 10**64) {
525                 value /= 10**64;
526                 result += 64;
527             }
528             if (value >= 10**32) {
529                 value /= 10**32;
530                 result += 32;
531             }
532             if (value >= 10**16) {
533                 value /= 10**16;
534                 result += 16;
535             }
536             if (value >= 10**8) {
537                 value /= 10**8;
538                 result += 8;
539             }
540             if (value >= 10**4) {
541                 value /= 10**4;
542                 result += 4;
543             }
544             if (value >= 10**2) {
545                 value /= 10**2;
546                 result += 2;
547             }
548             if (value >= 10**1) {
549                 result += 1;
550             }
551         }
552         return result;
553     }
554 
555     /**
556      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
557      * Returns 0 if given 0.
558      */
559     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
560         unchecked {
561             uint256 result = log10(value);
562             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
563         }
564     }
565 
566     /**
567      * @dev Return the log in base 256, rounded down, of a positive value.
568      * Returns 0 if given 0.
569      *
570      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
571      */
572     function log256(uint256 value) internal pure returns (uint256) {
573         uint256 result = 0;
574         unchecked {
575             if (value >> 128 > 0) {
576                 value >>= 128;
577                 result += 16;
578             }
579             if (value >> 64 > 0) {
580                 value >>= 64;
581                 result += 8;
582             }
583             if (value >> 32 > 0) {
584                 value >>= 32;
585                 result += 4;
586             }
587             if (value >> 16 > 0) {
588                 value >>= 16;
589                 result += 2;
590             }
591             if (value >> 8 > 0) {
592                 result += 1;
593             }
594         }
595         return result;
596     }
597 
598     /**
599      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
600      * Returns 0 if given 0.
601      */
602     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
603         unchecked {
604             uint256 result = log256(value);
605             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
606         }
607     }
608 }
609 
610 // File: @openzeppelin/contracts/utils/Strings.sol
611 
612 
613 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
614 
615 pragma solidity ^0.8.0;
616 
617 
618 /**
619  * @dev String operations.
620  */
621 library Strings {
622     bytes16 private constant _SYMBOLS = "0123456789abcdef";
623     uint8 private constant _ADDRESS_LENGTH = 20;
624 
625     /**
626      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
627      */
628     function toString(uint256 value) internal pure returns (string memory) {
629         unchecked {
630             uint256 length = Math.log10(value) + 1;
631             string memory buffer = new string(length);
632             uint256 ptr;
633             /// @solidity memory-safe-assembly
634             assembly {
635                 ptr := add(buffer, add(32, length))
636             }
637             while (true) {
638                 ptr--;
639                 /// @solidity memory-safe-assembly
640                 assembly {
641                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
642                 }
643                 value /= 10;
644                 if (value == 0) break;
645             }
646             return buffer;
647         }
648     }
649 
650     /**
651      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
652      */
653     function toHexString(uint256 value) internal pure returns (string memory) {
654         unchecked {
655             return toHexString(value, Math.log256(value) + 1);
656         }
657     }
658 
659     /**
660      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
661      */
662     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
663         bytes memory buffer = new bytes(2 * length + 2);
664         buffer[0] = "0";
665         buffer[1] = "x";
666         for (uint256 i = 2 * length + 1; i > 1; --i) {
667             buffer[i] = _SYMBOLS[value & 0xf];
668             value >>= 4;
669         }
670         require(value == 0, "Strings: hex length insufficient");
671         return string(buffer);
672     }
673 
674     /**
675      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
676      */
677     function toHexString(address addr) internal pure returns (string memory) {
678         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
679     }
680 }
681 
682 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
683 
684 
685 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 /**
690  * @dev Contract module that helps prevent reentrant calls to a function.
691  *
692  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
693  * available, which can be applied to functions to make sure there are no nested
694  * (reentrant) calls to them.
695  *
696  * Note that because there is a single `nonReentrant` guard, functions marked as
697  * `nonReentrant` may not call one another. This can be worked around by making
698  * those functions `private`, and then adding `external` `nonReentrant` entry
699  * points to them.
700  *
701  * TIP: If you would like to learn more about reentrancy and alternative ways
702  * to protect against it, check out our blog post
703  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
704  */
705 abstract contract ReentrancyGuard {
706     // Booleans are more expensive than uint256 or any type that takes up a full
707     // word because each write operation emits an extra SLOAD to first read the
708     // slot's contents, replace the bits taken up by the boolean, and then write
709     // back. This is the compiler's defense against contract upgrades and
710     // pointer aliasing, and it cannot be disabled.
711 
712     // The values being non-zero value makes deployment a bit more expensive,
713     // but in exchange the refund on every call to nonReentrant will be lower in
714     // amount. Since refunds are capped to a percentage of the total
715     // transaction's gas, it is best to keep them low in cases like this one, to
716     // increase the likelihood of the full refund coming into effect.
717     uint256 private constant _NOT_ENTERED = 1;
718     uint256 private constant _ENTERED = 2;
719 
720     uint256 private _status;
721 
722     constructor() {
723         _status = _NOT_ENTERED;
724     }
725 
726     /**
727      * @dev Prevents a contract from calling itself, directly or indirectly.
728      * Calling a `nonReentrant` function from another `nonReentrant`
729      * function is not supported. It is possible to prevent this from happening
730      * by making the `nonReentrant` function external, and making it call a
731      * `private` function that does the actual work.
732      */
733     modifier nonReentrant() {
734         _nonReentrantBefore();
735         _;
736         _nonReentrantAfter();
737     }
738 
739     function _nonReentrantBefore() private {
740         // On the first call to nonReentrant, _status will be _NOT_ENTERED
741         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
742 
743         // Any calls to nonReentrant after this point will fail
744         _status = _ENTERED;
745     }
746 
747     function _nonReentrantAfter() private {
748         // By storing the original value once again, a refund is triggered (see
749         // https://eips.ethereum.org/EIPS/eip-2200)
750         _status = _NOT_ENTERED;
751     }
752 }
753 
754 // File: @openzeppelin/contracts/utils/Context.sol
755 
756 
757 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
758 
759 pragma solidity ^0.8.0;
760 
761 /**
762  * @dev Provides information about the current execution context, including the
763  * sender of the transaction and its data. While these are generally available
764  * via msg.sender and msg.data, they should not be accessed in such a direct
765  * manner, since when dealing with meta-transactions the account sending and
766  * paying for execution may not be the actual sender (as far as an application
767  * is concerned).
768  *
769  * This contract is only required for intermediate, library-like contracts.
770  */
771 abstract contract Context {
772     function _msgSender() internal view virtual returns (address) {
773         return msg.sender;
774     }
775 
776     function _msgData() internal view virtual returns (bytes calldata) {
777         return msg.data;
778     }
779 }
780 
781 // File: @openzeppelin/contracts/access/Ownable.sol
782 
783 
784 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
785 
786 pragma solidity ^0.8.0;
787 
788 
789 /**
790  * @dev Contract module which provides a basic access control mechanism, where
791  * there is an account (an owner) that can be granted exclusive access to
792  * specific functions.
793  *
794  * By default, the owner account will be the one that deploys the contract. This
795  * can later be changed with {transferOwnership}.
796  *
797  * This module is used through inheritance. It will make available the modifier
798  * `onlyOwner`, which can be applied to your functions to restrict their use to
799  * the owner.
800  */
801 abstract contract Ownable is Context {
802     address private _owner;
803 
804     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
805 
806     /**
807      * @dev Initializes the contract setting the deployer as the initial owner.
808      */
809     constructor() {
810         _transferOwnership(_msgSender());
811     }
812 
813     /**
814      * @dev Throws if called by any account other than the owner.
815      */
816     modifier onlyOwner() {
817         _checkOwner();
818         _;
819     }
820 
821     /**
822      * @dev Returns the address of the current owner.
823      */
824     function owner() public view virtual returns (address) {
825         return _owner;
826     }
827 
828     /**
829      * @dev Throws if the sender is not the owner.
830      */
831     function _checkOwner() internal view virtual {
832         require(owner() == _msgSender(), "Ownable: caller is not the owner");
833     }
834 
835     /**
836      * @dev Leaves the contract without owner. It will not be possible to call
837      * `onlyOwner` functions anymore. Can only be called by the current owner.
838      *
839      * NOTE: Renouncing ownership will leave the contract without an owner,
840      * thereby removing any functionality that is only available to the owner.
841      */
842     function renounceOwnership() public virtual onlyOwner {
843         _transferOwnership(address(0));
844     }
845 
846     /**
847      * @dev Transfers ownership of the contract to a new account (`newOwner`).
848      * Can only be called by the current owner.
849      */
850     function transferOwnership(address newOwner) public virtual onlyOwner {
851         require(newOwner != address(0), "Ownable: new owner is the zero address");
852         _transferOwnership(newOwner);
853     }
854 
855     /**
856      * @dev Transfers ownership of the contract to a new account (`newOwner`).
857      * Internal function without access restriction.
858      */
859     function _transferOwnership(address newOwner) internal virtual {
860         address oldOwner = _owner;
861         _owner = newOwner;
862         emit OwnershipTransferred(oldOwner, newOwner);
863     }
864 }
865 
866 // File: erc721a/contracts/IERC721A.sol
867 
868 
869 // ERC721A Contracts v4.2.3
870 // Creator: Chiru Labs
871 
872 pragma solidity ^0.8.4;
873 
874 /**
875  * @dev Interface of ERC721A.
876  */
877 interface IERC721A {
878     /**
879      * The caller must own the token or be an approved operator.
880      */
881     error ApprovalCallerNotOwnerNorApproved();
882 
883     /**
884      * The token does not exist.
885      */
886     error ApprovalQueryForNonexistentToken();
887 
888     /**
889      * Cannot query the balance for the zero address.
890      */
891     error BalanceQueryForZeroAddress();
892 
893     /**
894      * Cannot mint to the zero address.
895      */
896     error MintToZeroAddress();
897 
898     /**
899      * The quantity of tokens minted must be more than zero.
900      */
901     error MintZeroQuantity();
902 
903     /**
904      * The token does not exist.
905      */
906     error OwnerQueryForNonexistentToken();
907 
908     /**
909      * The caller must own the token or be an approved operator.
910      */
911     error TransferCallerNotOwnerNorApproved();
912 
913     /**
914      * The token must be owned by `from`.
915      */
916     error TransferFromIncorrectOwner();
917 
918     /**
919      * Cannot safely transfer to a contract that does not implement the
920      * ERC721Receiver interface.
921      */
922     error TransferToNonERC721ReceiverImplementer();
923 
924     /**
925      * Cannot transfer to the zero address.
926      */
927     error TransferToZeroAddress();
928 
929     /**
930      * The token does not exist.
931      */
932     error URIQueryForNonexistentToken();
933 
934     /**
935      * The `quantity` minted with ERC2309 exceeds the safety limit.
936      */
937     error MintERC2309QuantityExceedsLimit();
938 
939     /**
940      * The `extraData` cannot be set on an unintialized ownership slot.
941      */
942     error OwnershipNotInitializedForExtraData();
943 
944     // =============================================================
945     //                            STRUCTS
946     // =============================================================
947 
948     struct TokenOwnership {
949         // The address of the owner.
950         address addr;
951         // Stores the start time of ownership with minimal overhead for tokenomics.
952         uint64 startTimestamp;
953         // Whether the token has been burned.
954         bool burned;
955         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
956         uint24 extraData;
957     }
958 
959     // =============================================================
960     //                         TOKEN COUNTERS
961     // =============================================================
962 
963     /**
964      * @dev Returns the total number of tokens in existence.
965      * Burned tokens will reduce the count.
966      * To get the total number of tokens minted, please see {_totalMinted}.
967      */
968     function totalSupply() external view returns (uint256);
969 
970     // =============================================================
971     //                            IERC165
972     // =============================================================
973 
974     /**
975      * @dev Returns true if this contract implements the interface defined by
976      * `interfaceId`. See the corresponding
977      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
978      * to learn more about how these ids are created.
979      *
980      * This function call must use less than 30000 gas.
981      */
982     function supportsInterface(bytes4 interfaceId) external view returns (bool);
983 
984     // =============================================================
985     //                            IERC721
986     // =============================================================
987 
988     /**
989      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
990      */
991     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
992 
993     /**
994      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
995      */
996     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
997 
998     /**
999      * @dev Emitted when `owner` enables or disables
1000      * (`approved`) `operator` to manage all of its assets.
1001      */
1002     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1003 
1004     /**
1005      * @dev Returns the number of tokens in `owner`'s account.
1006      */
1007     function balanceOf(address owner) external view returns (uint256 balance);
1008 
1009     /**
1010      * @dev Returns the owner of the `tokenId` token.
1011      *
1012      * Requirements:
1013      *
1014      * - `tokenId` must exist.
1015      */
1016     function ownerOf(uint256 tokenId) external view returns (address owner);
1017 
1018     /**
1019      * @dev Safely transfers `tokenId` token from `from` to `to`,
1020      * checking first that contract recipients are aware of the ERC721 protocol
1021      * to prevent tokens from being forever locked.
1022      *
1023      * Requirements:
1024      *
1025      * - `from` cannot be the zero address.
1026      * - `to` cannot be the zero address.
1027      * - `tokenId` token must exist and be owned by `from`.
1028      * - If the caller is not `from`, it must be have been allowed to move
1029      * this token by either {approve} or {setApprovalForAll}.
1030      * - If `to` refers to a smart contract, it must implement
1031      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1032      *
1033      * Emits a {Transfer} event.
1034      */
1035     function safeTransferFrom(
1036         address from,
1037         address to,
1038         uint256 tokenId,
1039         bytes calldata data
1040     ) external payable;
1041 
1042     /**
1043      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1044      */
1045     function safeTransferFrom(
1046         address from,
1047         address to,
1048         uint256 tokenId
1049     ) external payable;
1050 
1051     /**
1052      * @dev Transfers `tokenId` from `from` to `to`.
1053      *
1054      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1055      * whenever possible.
1056      *
1057      * Requirements:
1058      *
1059      * - `from` cannot be the zero address.
1060      * - `to` cannot be the zero address.
1061      * - `tokenId` token must be owned by `from`.
1062      * - If the caller is not `from`, it must be approved to move this token
1063      * by either {approve} or {setApprovalForAll}.
1064      *
1065      * Emits a {Transfer} event.
1066      */
1067     function transferFrom(
1068         address from,
1069         address to,
1070         uint256 tokenId
1071     ) external payable;
1072 
1073     /**
1074      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1075      * The approval is cleared when the token is transferred.
1076      *
1077      * Only a single account can be approved at a time, so approving the
1078      * zero address clears previous approvals.
1079      *
1080      * Requirements:
1081      *
1082      * - The caller must own the token or be an approved operator.
1083      * - `tokenId` must exist.
1084      *
1085      * Emits an {Approval} event.
1086      */
1087     function approve(address to, uint256 tokenId) external payable;
1088 
1089     /**
1090      * @dev Approve or remove `operator` as an operator for the caller.
1091      * Operators can call {transferFrom} or {safeTransferFrom}
1092      * for any token owned by the caller.
1093      *
1094      * Requirements:
1095      *
1096      * - The `operator` cannot be the caller.
1097      *
1098      * Emits an {ApprovalForAll} event.
1099      */
1100     function setApprovalForAll(address operator, bool _approved) external;
1101 
1102     /**
1103      * @dev Returns the account approved for `tokenId` token.
1104      *
1105      * Requirements:
1106      *
1107      * - `tokenId` must exist.
1108      */
1109     function getApproved(uint256 tokenId) external view returns (address operator);
1110 
1111     /**
1112      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1113      *
1114      * See {setApprovalForAll}.
1115      */
1116     function isApprovedForAll(address owner, address operator) external view returns (bool);
1117 
1118     // =============================================================
1119     //                        IERC721Metadata
1120     // =============================================================
1121 
1122     /**
1123      * @dev Returns the token collection name.
1124      */
1125     function name() external view returns (string memory);
1126 
1127     /**
1128      * @dev Returns the token collection symbol.
1129      */
1130     function symbol() external view returns (string memory);
1131 
1132     /**
1133      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1134      */
1135     function tokenURI(uint256 tokenId) external view returns (string memory);
1136 
1137     // =============================================================
1138     //                           IERC2309
1139     // =============================================================
1140 
1141     /**
1142      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1143      * (inclusive) is transferred from `from` to `to`, as defined in the
1144      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1145      *
1146      * See {_mintERC2309} for more details.
1147      */
1148     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1149 }
1150 
1151 // File: erc721a/contracts/ERC721A.sol
1152 
1153 
1154 // ERC721A Contracts v4.2.3
1155 // Creator: Chiru Labs
1156 
1157 pragma solidity ^0.8.4;
1158 
1159 
1160 /**
1161  * @dev Interface of ERC721 token receiver.
1162  */
1163 interface ERC721A__IERC721Receiver {
1164     function onERC721Received(
1165         address operator,
1166         address from,
1167         uint256 tokenId,
1168         bytes calldata data
1169     ) external returns (bytes4);
1170 }
1171 
1172 /**
1173  * @title ERC721A
1174  *
1175  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1176  * Non-Fungible Token Standard, including the Metadata extension.
1177  * Optimized for lower gas during batch mints.
1178  *
1179  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1180  * starting from `_startTokenId()`.
1181  *
1182  * Assumptions:
1183  *
1184  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1185  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1186  */
1187 contract ERC721A is IERC721A {
1188     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1189     struct TokenApprovalRef {
1190         address value;
1191     }
1192 
1193     // =============================================================
1194     //                           CONSTANTS
1195     // =============================================================
1196 
1197     // Mask of an entry in packed address data.
1198     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1199 
1200     // The bit position of `numberMinted` in packed address data.
1201     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1202 
1203     // The bit position of `numberBurned` in packed address data.
1204     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1205 
1206     // The bit position of `aux` in packed address data.
1207     uint256 private constant _BITPOS_AUX = 192;
1208 
1209     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1210     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1211 
1212     // The bit position of `startTimestamp` in packed ownership.
1213     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1214 
1215     // The bit mask of the `burned` bit in packed ownership.
1216     uint256 private constant _BITMASK_BURNED = 1 << 224;
1217 
1218     // The bit position of the `nextInitialized` bit in packed ownership.
1219     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1220 
1221     // The bit mask of the `nextInitialized` bit in packed ownership.
1222     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1223 
1224     // The bit position of `extraData` in packed ownership.
1225     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1226 
1227     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1228     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1229 
1230     // The mask of the lower 160 bits for addresses.
1231     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1232 
1233     // The maximum `quantity` that can be minted with {_mintERC2309}.
1234     // This limit is to prevent overflows on the address data entries.
1235     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1236     // is required to cause an overflow, which is unrealistic.
1237     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1238 
1239     // The `Transfer` event signature is given by:
1240     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1241     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1242         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1243 
1244     // =============================================================
1245     //                            STORAGE
1246     // =============================================================
1247 
1248     // The next token ID to be minted.
1249     uint256 private _currentIndex;
1250 
1251     // The number of tokens burned.
1252     uint256 private _burnCounter;
1253 
1254     // Token name
1255     string private _name;
1256 
1257     // Token symbol
1258     string private _symbol;
1259 
1260     // Mapping from token ID to ownership details
1261     // An empty struct value does not necessarily mean the token is unowned.
1262     // See {_packedOwnershipOf} implementation for details.
1263     //
1264     // Bits Layout:
1265     // - [0..159]   `addr`
1266     // - [160..223] `startTimestamp`
1267     // - [224]      `burned`
1268     // - [225]      `nextInitialized`
1269     // - [232..255] `extraData`
1270     mapping(uint256 => uint256) private _packedOwnerships;
1271 
1272     // Mapping owner address to address data.
1273     //
1274     // Bits Layout:
1275     // - [0..63]    `balance`
1276     // - [64..127]  `numberMinted`
1277     // - [128..191] `numberBurned`
1278     // - [192..255] `aux`
1279     mapping(address => uint256) private _packedAddressData;
1280 
1281     // Mapping from token ID to approved address.
1282     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1283 
1284     // Mapping from owner to operator approvals
1285     mapping(address => mapping(address => bool)) private _operatorApprovals;
1286 
1287     // =============================================================
1288     //                          CONSTRUCTOR
1289     // =============================================================
1290 
1291     constructor(string memory name_, string memory symbol_) {
1292         _name = name_;
1293         _symbol = symbol_;
1294         _currentIndex = _startTokenId();
1295     }
1296 
1297     // =============================================================
1298     //                   TOKEN COUNTING OPERATIONS
1299     // =============================================================
1300 
1301     /**
1302      * @dev Returns the starting token ID.
1303      * To change the starting token ID, please override this function.
1304      */
1305     function _startTokenId() internal view virtual returns (uint256) {
1306         return 0;
1307     }
1308 
1309     /**
1310      * @dev Returns the next token ID to be minted.
1311      */
1312     function _nextTokenId() internal view virtual returns (uint256) {
1313         return _currentIndex;
1314     }
1315 
1316     /**
1317      * @dev Returns the total number of tokens in existence.
1318      * Burned tokens will reduce the count.
1319      * To get the total number of tokens minted, please see {_totalMinted}.
1320      */
1321     function totalSupply() public view virtual override returns (uint256) {
1322         // Counter underflow is impossible as _burnCounter cannot be incremented
1323         // more than `_currentIndex - _startTokenId()` times.
1324         unchecked {
1325             return _currentIndex - _burnCounter - _startTokenId();
1326         }
1327     }
1328 
1329     /**
1330      * @dev Returns the total amount of tokens minted in the contract.
1331      */
1332     function _totalMinted() internal view virtual returns (uint256) {
1333         // Counter underflow is impossible as `_currentIndex` does not decrement,
1334         // and it is initialized to `_startTokenId()`.
1335         unchecked {
1336             return _currentIndex - _startTokenId();
1337         }
1338     }
1339 
1340     /**
1341      * @dev Returns the total number of tokens burned.
1342      */
1343     function _totalBurned() internal view virtual returns (uint256) {
1344         return _burnCounter;
1345     }
1346 
1347     // =============================================================
1348     //                    ADDRESS DATA OPERATIONS
1349     // =============================================================
1350 
1351     /**
1352      * @dev Returns the number of tokens in `owner`'s account.
1353      */
1354     function balanceOf(address owner) public view virtual override returns (uint256) {
1355         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1356         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1357     }
1358 
1359     /**
1360      * Returns the number of tokens minted by `owner`.
1361      */
1362     function _numberMinted(address owner) internal view returns (uint256) {
1363         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1364     }
1365 
1366     /**
1367      * Returns the number of tokens burned by or on behalf of `owner`.
1368      */
1369     function _numberBurned(address owner) internal view returns (uint256) {
1370         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1371     }
1372 
1373     /**
1374      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1375      */
1376     function _getAux(address owner) internal view returns (uint64) {
1377         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1378     }
1379 
1380     /**
1381      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1382      * If there are multiple variables, please pack them into a uint64.
1383      */
1384     function _setAux(address owner, uint64 aux) internal virtual {
1385         uint256 packed = _packedAddressData[owner];
1386         uint256 auxCasted;
1387         // Cast `aux` with assembly to avoid redundant masking.
1388         assembly {
1389             auxCasted := aux
1390         }
1391         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1392         _packedAddressData[owner] = packed;
1393     }
1394 
1395     // =============================================================
1396     //                            IERC165
1397     // =============================================================
1398 
1399     /**
1400      * @dev Returns true if this contract implements the interface defined by
1401      * `interfaceId`. See the corresponding
1402      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1403      * to learn more about how these ids are created.
1404      *
1405      * This function call must use less than 30000 gas.
1406      */
1407     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1408         // The interface IDs are constants representing the first 4 bytes
1409         // of the XOR of all function selectors in the interface.
1410         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1411         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1412         return
1413             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1414             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1415             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1416     }
1417 
1418     // =============================================================
1419     //                        IERC721Metadata
1420     // =============================================================
1421 
1422     /**
1423      * @dev Returns the token collection name.
1424      */
1425     function name() public view virtual override returns (string memory) {
1426         return _name;
1427     }
1428 
1429     /**
1430      * @dev Returns the token collection symbol.
1431      */
1432     function symbol() public view virtual override returns (string memory) {
1433         return _symbol;
1434     }
1435 
1436     /**
1437      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1438      */
1439     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1440         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1441 
1442         string memory baseURI = _baseURI();
1443         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1444     }
1445 
1446     /**
1447      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1448      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1449      * by default, it can be overridden in child contracts.
1450      */
1451     function _baseURI() internal view virtual returns (string memory) {
1452         return '';
1453     }
1454 
1455     // =============================================================
1456     //                     OWNERSHIPS OPERATIONS
1457     // =============================================================
1458 
1459     /**
1460      * @dev Returns the owner of the `tokenId` token.
1461      *
1462      * Requirements:
1463      *
1464      * - `tokenId` must exist.
1465      */
1466     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1467         return address(uint160(_packedOwnershipOf(tokenId)));
1468     }
1469 
1470     /**
1471      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1472      * It gradually moves to O(1) as tokens get transferred around over time.
1473      */
1474     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1475         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1476     }
1477 
1478     /**
1479      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1480      */
1481     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1482         return _unpackedOwnership(_packedOwnerships[index]);
1483     }
1484 
1485     /**
1486      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1487      */
1488     function _initializeOwnershipAt(uint256 index) internal virtual {
1489         if (_packedOwnerships[index] == 0) {
1490             _packedOwnerships[index] = _packedOwnershipOf(index);
1491         }
1492     }
1493 
1494     /**
1495      * Returns the packed ownership data of `tokenId`.
1496      */
1497     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1498         uint256 curr = tokenId;
1499 
1500         unchecked {
1501             if (_startTokenId() <= curr)
1502                 if (curr < _currentIndex) {
1503                     uint256 packed = _packedOwnerships[curr];
1504                     // If not burned.
1505                     if (packed & _BITMASK_BURNED == 0) {
1506                         // Invariant:
1507                         // There will always be an initialized ownership slot
1508                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1509                         // before an unintialized ownership slot
1510                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1511                         // Hence, `curr` will not underflow.
1512                         //
1513                         // We can directly compare the packed value.
1514                         // If the address is zero, packed will be zero.
1515                         while (packed == 0) {
1516                             packed = _packedOwnerships[--curr];
1517                         }
1518                         return packed;
1519                     }
1520                 }
1521         }
1522         revert OwnerQueryForNonexistentToken();
1523     }
1524 
1525     /**
1526      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1527      */
1528     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1529         ownership.addr = address(uint160(packed));
1530         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1531         ownership.burned = packed & _BITMASK_BURNED != 0;
1532         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1533     }
1534 
1535     /**
1536      * @dev Packs ownership data into a single uint256.
1537      */
1538     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1539         assembly {
1540             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1541             owner := and(owner, _BITMASK_ADDRESS)
1542             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1543             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1544         }
1545     }
1546 
1547     /**
1548      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1549      */
1550     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1551         // For branchless setting of the `nextInitialized` flag.
1552         assembly {
1553             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1554             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1555         }
1556     }
1557 
1558     // =============================================================
1559     //                      APPROVAL OPERATIONS
1560     // =============================================================
1561 
1562     /**
1563      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1564      * The approval is cleared when the token is transferred.
1565      *
1566      * Only a single account can be approved at a time, so approving the
1567      * zero address clears previous approvals.
1568      *
1569      * Requirements:
1570      *
1571      * - The caller must own the token or be an approved operator.
1572      * - `tokenId` must exist.
1573      *
1574      * Emits an {Approval} event.
1575      */
1576     function approve(address to, uint256 tokenId) public payable virtual override {
1577         address owner = ownerOf(tokenId);
1578 
1579         if (_msgSenderERC721A() != owner)
1580             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1581                 revert ApprovalCallerNotOwnerNorApproved();
1582             }
1583 
1584         _tokenApprovals[tokenId].value = to;
1585         emit Approval(owner, to, tokenId);
1586     }
1587 
1588     /**
1589      * @dev Returns the account approved for `tokenId` token.
1590      *
1591      * Requirements:
1592      *
1593      * - `tokenId` must exist.
1594      */
1595     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1596         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1597 
1598         return _tokenApprovals[tokenId].value;
1599     }
1600 
1601     /**
1602      * @dev Approve or remove `operator` as an operator for the caller.
1603      * Operators can call {transferFrom} or {safeTransferFrom}
1604      * for any token owned by the caller.
1605      *
1606      * Requirements:
1607      *
1608      * - The `operator` cannot be the caller.
1609      *
1610      * Emits an {ApprovalForAll} event.
1611      */
1612     function setApprovalForAll(address operator, bool approved) public virtual override {
1613         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1614         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1615     }
1616 
1617     /**
1618      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1619      *
1620      * See {setApprovalForAll}.
1621      */
1622     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1623         return _operatorApprovals[owner][operator];
1624     }
1625 
1626     /**
1627      * @dev Returns whether `tokenId` exists.
1628      *
1629      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1630      *
1631      * Tokens start existing when they are minted. See {_mint}.
1632      */
1633     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1634         return
1635             _startTokenId() <= tokenId &&
1636             tokenId < _currentIndex && // If within bounds,
1637             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1638     }
1639 
1640     /**
1641      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1642      */
1643     function _isSenderApprovedOrOwner(
1644         address approvedAddress,
1645         address owner,
1646         address msgSender
1647     ) private pure returns (bool result) {
1648         assembly {
1649             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1650             owner := and(owner, _BITMASK_ADDRESS)
1651             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1652             msgSender := and(msgSender, _BITMASK_ADDRESS)
1653             // `msgSender == owner || msgSender == approvedAddress`.
1654             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1655         }
1656     }
1657 
1658     /**
1659      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1660      */
1661     function _getApprovedSlotAndAddress(uint256 tokenId)
1662         private
1663         view
1664         returns (uint256 approvedAddressSlot, address approvedAddress)
1665     {
1666         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1667         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1668         assembly {
1669             approvedAddressSlot := tokenApproval.slot
1670             approvedAddress := sload(approvedAddressSlot)
1671         }
1672     }
1673 
1674     // =============================================================
1675     //                      TRANSFER OPERATIONS
1676     // =============================================================
1677 
1678     /**
1679      * @dev Transfers `tokenId` from `from` to `to`.
1680      *
1681      * Requirements:
1682      *
1683      * - `from` cannot be the zero address.
1684      * - `to` cannot be the zero address.
1685      * - `tokenId` token must be owned by `from`.
1686      * - If the caller is not `from`, it must be approved to move this token
1687      * by either {approve} or {setApprovalForAll}.
1688      *
1689      * Emits a {Transfer} event.
1690      */
1691     function transferFrom(
1692         address from,
1693         address to,
1694         uint256 tokenId
1695     ) public payable virtual override {
1696         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1697 
1698         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1699 
1700         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1701 
1702         // The nested ifs save around 20+ gas over a compound boolean condition.
1703         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1704             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1705 
1706         if (to == address(0)) revert TransferToZeroAddress();
1707 
1708         _beforeTokenTransfers(from, to, tokenId, 1);
1709 
1710         // Clear approvals from the previous owner.
1711         assembly {
1712             if approvedAddress {
1713                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1714                 sstore(approvedAddressSlot, 0)
1715             }
1716         }
1717 
1718         // Underflow of the sender's balance is impossible because we check for
1719         // ownership above and the recipient's balance can't realistically overflow.
1720         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1721         unchecked {
1722             // We can directly increment and decrement the balances.
1723             --_packedAddressData[from]; // Updates: `balance -= 1`.
1724             ++_packedAddressData[to]; // Updates: `balance += 1`.
1725 
1726             // Updates:
1727             // - `address` to the next owner.
1728             // - `startTimestamp` to the timestamp of transfering.
1729             // - `burned` to `false`.
1730             // - `nextInitialized` to `true`.
1731             _packedOwnerships[tokenId] = _packOwnershipData(
1732                 to,
1733                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1734             );
1735 
1736             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1737             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1738                 uint256 nextTokenId = tokenId + 1;
1739                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1740                 if (_packedOwnerships[nextTokenId] == 0) {
1741                     // If the next slot is within bounds.
1742                     if (nextTokenId != _currentIndex) {
1743                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1744                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1745                     }
1746                 }
1747             }
1748         }
1749 
1750         emit Transfer(from, to, tokenId);
1751         _afterTokenTransfers(from, to, tokenId, 1);
1752     }
1753 
1754     /**
1755      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1756      */
1757     function safeTransferFrom(
1758         address from,
1759         address to,
1760         uint256 tokenId
1761     ) public payable virtual override {
1762         safeTransferFrom(from, to, tokenId, '');
1763     }
1764 
1765     /**
1766      * @dev Safely transfers `tokenId` token from `from` to `to`.
1767      *
1768      * Requirements:
1769      *
1770      * - `from` cannot be the zero address.
1771      * - `to` cannot be the zero address.
1772      * - `tokenId` token must exist and be owned by `from`.
1773      * - If the caller is not `from`, it must be approved to move this token
1774      * by either {approve} or {setApprovalForAll}.
1775      * - If `to` refers to a smart contract, it must implement
1776      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1777      *
1778      * Emits a {Transfer} event.
1779      */
1780     function safeTransferFrom(
1781         address from,
1782         address to,
1783         uint256 tokenId,
1784         bytes memory _data
1785     ) public payable virtual override {
1786         transferFrom(from, to, tokenId);
1787         if (to.code.length != 0)
1788             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1789                 revert TransferToNonERC721ReceiverImplementer();
1790             }
1791     }
1792 
1793     /**
1794      * @dev Hook that is called before a set of serially-ordered token IDs
1795      * are about to be transferred. This includes minting.
1796      * And also called before burning one token.
1797      *
1798      * `startTokenId` - the first token ID to be transferred.
1799      * `quantity` - the amount to be transferred.
1800      *
1801      * Calling conditions:
1802      *
1803      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1804      * transferred to `to`.
1805      * - When `from` is zero, `tokenId` will be minted for `to`.
1806      * - When `to` is zero, `tokenId` will be burned by `from`.
1807      * - `from` and `to` are never both zero.
1808      */
1809     function _beforeTokenTransfers(
1810         address from,
1811         address to,
1812         uint256 startTokenId,
1813         uint256 quantity
1814     ) internal virtual {}
1815 
1816     /**
1817      * @dev Hook that is called after a set of serially-ordered token IDs
1818      * have been transferred. This includes minting.
1819      * And also called after one token has been burned.
1820      *
1821      * `startTokenId` - the first token ID to be transferred.
1822      * `quantity` - the amount to be transferred.
1823      *
1824      * Calling conditions:
1825      *
1826      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1827      * transferred to `to`.
1828      * - When `from` is zero, `tokenId` has been minted for `to`.
1829      * - When `to` is zero, `tokenId` has been burned by `from`.
1830      * - `from` and `to` are never both zero.
1831      */
1832     function _afterTokenTransfers(
1833         address from,
1834         address to,
1835         uint256 startTokenId,
1836         uint256 quantity
1837     ) internal virtual {}
1838 
1839     /**
1840      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1841      *
1842      * `from` - Previous owner of the given token ID.
1843      * `to` - Target address that will receive the token.
1844      * `tokenId` - Token ID to be transferred.
1845      * `_data` - Optional data to send along with the call.
1846      *
1847      * Returns whether the call correctly returned the expected magic value.
1848      */
1849     function _checkContractOnERC721Received(
1850         address from,
1851         address to,
1852         uint256 tokenId,
1853         bytes memory _data
1854     ) private returns (bool) {
1855         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1856             bytes4 retval
1857         ) {
1858             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1859         } catch (bytes memory reason) {
1860             if (reason.length == 0) {
1861                 revert TransferToNonERC721ReceiverImplementer();
1862             } else {
1863                 assembly {
1864                     revert(add(32, reason), mload(reason))
1865                 }
1866             }
1867         }
1868     }
1869 
1870     // =============================================================
1871     //                        MINT OPERATIONS
1872     // =============================================================
1873 
1874     /**
1875      * @dev Mints `quantity` tokens and transfers them to `to`.
1876      *
1877      * Requirements:
1878      *
1879      * - `to` cannot be the zero address.
1880      * - `quantity` must be greater than 0.
1881      *
1882      * Emits a {Transfer} event for each mint.
1883      */
1884     function _mint(address to, uint256 quantity) internal virtual {
1885         uint256 startTokenId = _currentIndex;
1886         if (quantity == 0) revert MintZeroQuantity();
1887 
1888         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1889 
1890         // Overflows are incredibly unrealistic.
1891         // `balance` and `numberMinted` have a maximum limit of 2**64.
1892         // `tokenId` has a maximum limit of 2**256.
1893         unchecked {
1894             // Updates:
1895             // - `balance += quantity`.
1896             // - `numberMinted += quantity`.
1897             //
1898             // We can directly add to the `balance` and `numberMinted`.
1899             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1900 
1901             // Updates:
1902             // - `address` to the owner.
1903             // - `startTimestamp` to the timestamp of minting.
1904             // - `burned` to `false`.
1905             // - `nextInitialized` to `quantity == 1`.
1906             _packedOwnerships[startTokenId] = _packOwnershipData(
1907                 to,
1908                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1909             );
1910 
1911             uint256 toMasked;
1912             uint256 end = startTokenId + quantity;
1913 
1914             // Use assembly to loop and emit the `Transfer` event for gas savings.
1915             // The duplicated `log4` removes an extra check and reduces stack juggling.
1916             // The assembly, together with the surrounding Solidity code, have been
1917             // delicately arranged to nudge the compiler into producing optimized opcodes.
1918             assembly {
1919                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1920                 toMasked := and(to, _BITMASK_ADDRESS)
1921                 // Emit the `Transfer` event.
1922                 log4(
1923                     0, // Start of data (0, since no data).
1924                     0, // End of data (0, since no data).
1925                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1926                     0, // `address(0)`.
1927                     toMasked, // `to`.
1928                     startTokenId // `tokenId`.
1929                 )
1930 
1931                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1932                 // that overflows uint256 will make the loop run out of gas.
1933                 // The compiler will optimize the `iszero` away for performance.
1934                 for {
1935                     let tokenId := add(startTokenId, 1)
1936                 } iszero(eq(tokenId, end)) {
1937                     tokenId := add(tokenId, 1)
1938                 } {
1939                     // Emit the `Transfer` event. Similar to above.
1940                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1941                 }
1942             }
1943             if (toMasked == 0) revert MintToZeroAddress();
1944 
1945             _currentIndex = end;
1946         }
1947         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1948     }
1949 
1950     /**
1951      * @dev Mints `quantity` tokens and transfers them to `to`.
1952      *
1953      * This function is intended for efficient minting only during contract creation.
1954      *
1955      * It emits only one {ConsecutiveTransfer} as defined in
1956      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1957      * instead of a sequence of {Transfer} event(s).
1958      *
1959      * Calling this function outside of contract creation WILL make your contract
1960      * non-compliant with the ERC721 standard.
1961      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1962      * {ConsecutiveTransfer} event is only permissible during contract creation.
1963      *
1964      * Requirements:
1965      *
1966      * - `to` cannot be the zero address.
1967      * - `quantity` must be greater than 0.
1968      *
1969      * Emits a {ConsecutiveTransfer} event.
1970      */
1971     function _mintERC2309(address to, uint256 quantity) internal virtual {
1972         uint256 startTokenId = _currentIndex;
1973         if (to == address(0)) revert MintToZeroAddress();
1974         if (quantity == 0) revert MintZeroQuantity();
1975         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1976 
1977         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1978 
1979         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1980         unchecked {
1981             // Updates:
1982             // - `balance += quantity`.
1983             // - `numberMinted += quantity`.
1984             //
1985             // We can directly add to the `balance` and `numberMinted`.
1986             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1987 
1988             // Updates:
1989             // - `address` to the owner.
1990             // - `startTimestamp` to the timestamp of minting.
1991             // - `burned` to `false`.
1992             // - `nextInitialized` to `quantity == 1`.
1993             _packedOwnerships[startTokenId] = _packOwnershipData(
1994                 to,
1995                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1996             );
1997 
1998             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1999 
2000             _currentIndex = startTokenId + quantity;
2001         }
2002         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2003     }
2004 
2005     /**
2006      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2007      *
2008      * Requirements:
2009      *
2010      * - If `to` refers to a smart contract, it must implement
2011      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2012      * - `quantity` must be greater than 0.
2013      *
2014      * See {_mint}.
2015      *
2016      * Emits a {Transfer} event for each mint.
2017      */
2018     function _safeMint(
2019         address to,
2020         uint256 quantity,
2021         bytes memory _data
2022     ) internal virtual {
2023         _mint(to, quantity);
2024 
2025         unchecked {
2026             if (to.code.length != 0) {
2027                 uint256 end = _currentIndex;
2028                 uint256 index = end - quantity;
2029                 do {
2030                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2031                         revert TransferToNonERC721ReceiverImplementer();
2032                     }
2033                 } while (index < end);
2034                 // Reentrancy protection.
2035                 if (_currentIndex != end) revert();
2036             }
2037         }
2038     }
2039 
2040     /**
2041      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2042      */
2043     function _safeMint(address to, uint256 quantity) internal virtual {
2044         _safeMint(to, quantity, '');
2045     }
2046 
2047     // =============================================================
2048     //                        BURN OPERATIONS
2049     // =============================================================
2050 
2051     /**
2052      * @dev Equivalent to `_burn(tokenId, false)`.
2053      */
2054     function _burn(uint256 tokenId) internal virtual {
2055         _burn(tokenId, false);
2056     }
2057 
2058     /**
2059      * @dev Destroys `tokenId`.
2060      * The approval is cleared when the token is burned.
2061      *
2062      * Requirements:
2063      *
2064      * - `tokenId` must exist.
2065      *
2066      * Emits a {Transfer} event.
2067      */
2068     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2069         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2070 
2071         address from = address(uint160(prevOwnershipPacked));
2072 
2073         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2074 
2075         if (approvalCheck) {
2076             // The nested ifs save around 20+ gas over a compound boolean condition.
2077             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2078                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2079         }
2080 
2081         _beforeTokenTransfers(from, address(0), tokenId, 1);
2082 
2083         // Clear approvals from the previous owner.
2084         assembly {
2085             if approvedAddress {
2086                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2087                 sstore(approvedAddressSlot, 0)
2088             }
2089         }
2090 
2091         // Underflow of the sender's balance is impossible because we check for
2092         // ownership above and the recipient's balance can't realistically overflow.
2093         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2094         unchecked {
2095             // Updates:
2096             // - `balance -= 1`.
2097             // - `numberBurned += 1`.
2098             //
2099             // We can directly decrement the balance, and increment the number burned.
2100             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2101             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2102 
2103             // Updates:
2104             // - `address` to the last owner.
2105             // - `startTimestamp` to the timestamp of burning.
2106             // - `burned` to `true`.
2107             // - `nextInitialized` to `true`.
2108             _packedOwnerships[tokenId] = _packOwnershipData(
2109                 from,
2110                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2111             );
2112 
2113             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2114             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2115                 uint256 nextTokenId = tokenId + 1;
2116                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2117                 if (_packedOwnerships[nextTokenId] == 0) {
2118                     // If the next slot is within bounds.
2119                     if (nextTokenId != _currentIndex) {
2120                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2121                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2122                     }
2123                 }
2124             }
2125         }
2126 
2127         emit Transfer(from, address(0), tokenId);
2128         _afterTokenTransfers(from, address(0), tokenId, 1);
2129 
2130         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2131         unchecked {
2132             _burnCounter++;
2133         }
2134     }
2135 
2136     // =============================================================
2137     //                     EXTRA DATA OPERATIONS
2138     // =============================================================
2139 
2140     /**
2141      * @dev Directly sets the extra data for the ownership data `index`.
2142      */
2143     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2144         uint256 packed = _packedOwnerships[index];
2145         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2146         uint256 extraDataCasted;
2147         // Cast `extraData` with assembly to avoid redundant masking.
2148         assembly {
2149             extraDataCasted := extraData
2150         }
2151         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2152         _packedOwnerships[index] = packed;
2153     }
2154 
2155     /**
2156      * @dev Called during each token transfer to set the 24bit `extraData` field.
2157      * Intended to be overridden by the cosumer contract.
2158      *
2159      * `previousExtraData` - the value of `extraData` before transfer.
2160      *
2161      * Calling conditions:
2162      *
2163      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2164      * transferred to `to`.
2165      * - When `from` is zero, `tokenId` will be minted for `to`.
2166      * - When `to` is zero, `tokenId` will be burned by `from`.
2167      * - `from` and `to` are never both zero.
2168      */
2169     function _extraData(
2170         address from,
2171         address to,
2172         uint24 previousExtraData
2173     ) internal view virtual returns (uint24) {}
2174 
2175     /**
2176      * @dev Returns the next extra data for the packed ownership data.
2177      * The returned result is shifted into position.
2178      */
2179     function _nextExtraData(
2180         address from,
2181         address to,
2182         uint256 prevOwnershipPacked
2183     ) private view returns (uint256) {
2184         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2185         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2186     }
2187 
2188     // =============================================================
2189     //                       OTHER OPERATIONS
2190     // =============================================================
2191 
2192     /**
2193      * @dev Returns the message sender (defaults to `msg.sender`).
2194      *
2195      * If you are writing GSN compatible contracts, you need to override this function.
2196      */
2197     function _msgSenderERC721A() internal view virtual returns (address) {
2198         return msg.sender;
2199     }
2200 
2201     /**
2202      * @dev Converts a uint256 to its ASCII string decimal representation.
2203      */
2204     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2205         assembly {
2206             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2207             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2208             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2209             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2210             let m := add(mload(0x40), 0xa0)
2211             // Update the free memory pointer to allocate.
2212             mstore(0x40, m)
2213             // Assign the `str` to the end.
2214             str := sub(m, 0x20)
2215             // Zeroize the slot after the string.
2216             mstore(str, 0)
2217 
2218             // Cache the end of the memory to calculate the length later.
2219             let end := str
2220 
2221             // We write the string from rightmost digit to leftmost digit.
2222             // The following is essentially a do-while loop that also handles the zero case.
2223             // prettier-ignore
2224             for { let temp := value } 1 {} {
2225                 str := sub(str, 1)
2226                 // Write the character to the pointer.
2227                 // The ASCII index of the '0' character is 48.
2228                 mstore8(str, add(48, mod(temp, 10)))
2229                 // Keep dividing `temp` until zero.
2230                 temp := div(temp, 10)
2231                 // prettier-ignore
2232                 if iszero(temp) { break }
2233             }
2234 
2235             let length := sub(end, str)
2236             // Move the pointer 32 bytes leftwards to make room for the length.
2237             str := sub(str, 0x20)
2238             // Store the length.
2239             mstore(str, length)
2240         }
2241     }
2242 }
2243 
2244 // File: contracts/oceanplayground.sol
2245 
2246 /*
2247  ________  ________  _______   ________  ________           ________  ___       ________      ___    ___ ________  ________  ________  ___  ___  ________   ________     
2248 |\   __  \|\   ____\|\  ___ \ |\   __  \|\   ___  \        |\   __  \|\  \     |\   __  \    |\  \  /  /|\   ____\|\   __  \|\   __  \|\  \|\  \|\   ___  \|\   ___ \    
2249 \ \  \|\  \ \  \___|\ \   __/|\ \  \|\  \ \  \\ \  \       \ \  \|\  \ \  \    \ \  \|\  \   \ \  \/  / | \  \___|\ \  \|\  \ \  \|\  \ \  \\\  \ \  \\ \  \ \  \_|\ \   
2250  \ \  \\\  \ \  \    \ \  \_|/_\ \   __  \ \  \\ \  \       \ \   ____\ \  \    \ \   __  \   \ \    / / \ \  \  __\ \   _  _\ \  \\\  \ \  \\\  \ \  \\ \  \ \  \ \\ \  
2251   \ \  \\\  \ \  \____\ \  \_|\ \ \  \ \  \ \  \\ \  \       \ \  \___|\ \  \____\ \  \ \  \   \/  /  /   \ \  \|\  \ \  \\  \\ \  \\\  \ \  \\\  \ \  \\ \  \ \  \_\\ \ 
2252    \ \_______\ \_______\ \_______\ \__\ \__\ \__\\ \__\       \ \__\    \ \_______\ \__\ \__\__/  / /      \ \_______\ \__\\ _\\ \_______\ \_______\ \__\\ \__\ \_______\
2253     \|_______|\|_______|\|_______|\|__|\|__|\|__| \|__|        \|__|     \|_______|\|__|\|__|\___/ /        \|_______|\|__|\|__|\|_______|\|_______|\|__| \|__|\|_______|
2254                                                                                             \|___|/                                                                      
2255                                                                                                                                                                          */ 
2256 
2257 
2258 pragma solidity >=0.8.9 <0.9.0;
2259 
2260 
2261 
2262 
2263 
2264 
2265 contract OCEANPLAYGROUND is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
2266     using Strings for uint256;
2267 
2268     string public baseURI = "ipfs://bafybeicr3cwnlemdc37wdhqfxfhveidqjoi3m5mo5fgbvakbqqrqw7jdqa/";
2269     string public baseExtension = ".json";
2270     uint256 public Freecost = 0 ether;
2271     uint256 public cost = 0.00999 ether;
2272     uint256 public freeSupply = 99;
2273     uint256 public maxSupply = 999;
2274     uint256 public maxMintAmountFree = 3;
2275     uint256 public maxMintAmountPublic = 9;
2276 
2277     mapping(address => uint256) public addressFreeMintedBalance;
2278     
2279     uint256 public currentState = 0;
2280   
2281     constructor() ERC721A("OCEAN PLAYGROUND", "OP") {}
2282 
2283     /////////////////////////////
2284     // CORE FUNCTIONALITY
2285     /////////////////////////////
2286 
2287     function mint(uint256 _mintAmount) public payable {
2288         uint256 supply = totalSupply();
2289         require(_mintAmount > 0, "need to mint at least 1 NFT");
2290         if (msg.sender != owner()) {
2291             require(currentState > 0, "the contract is paused");
2292                 if (currentState == 1) {
2293                 require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
2294                 require(_mintAmount <= maxMintAmountPublic, "Max mint amount per session exceeded" );
2295                 require(msg.value >= cost * _mintAmount, "insufficient funds");
2296             } else if (currentState == 2) {
2297                 uint256 ownerMintedCount = addressFreeMintedBalance[msg.sender];
2298                 require(supply + _mintAmount <= freeSupply, "max Free NFT limit exceeded");
2299                 require(_mintAmount <= maxMintAmountFree, "Max mint amount per session exceeded" );
2300                 require(ownerMintedCount + _mintAmount <= maxMintAmountFree, "max NFT per address exceeded" );
2301                 require(msg.value >= Freecost * _mintAmount, "insufficient funds");
2302             }
2303         }
2304 
2305         _safeMint(msg.sender, _mintAmount);
2306          if (currentState == 2) {
2307             addressFreeMintedBalance[msg.sender] += _mintAmount;
2308         }
2309     }
2310 	
2311     function Airdrop(uint256 _mintAmount, address _receiver) public onlyOwner {
2312 	    require(_mintAmount > 0, "need to mint at least 1 NFT");
2313 	    require(totalSupply() + _mintAmount <= maxSupply, "max NFT limit exceeded");
2314         _safeMint(_receiver, _mintAmount);
2315     }
2316 
2317     function mintableAmountForUser(address _user) public view returns (uint256) {
2318             if (currentState == 2) {
2319             return maxMintAmountFree - addressFreeMintedBalance[_user];
2320         }
2321         return 0;
2322     }
2323 
2324     function _baseURI() internal view virtual override returns (string memory) {
2325         return baseURI;
2326     }
2327 	
2328     function _startTokenId() internal view virtual override returns (uint256) {
2329         return 1;
2330     }
2331 	
2332     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2333         require( _exists(tokenId), "ERC721Metadata: URI query for nonexistent token" );
2334         string memory currentBaseURI = _baseURI();
2335         return
2336             bytes(currentBaseURI).length > 0
2337                 ? string( abi.encodePacked( currentBaseURI, tokenId.toString(), baseExtension ) ) : "";
2338     }
2339 
2340     /////////////////////////////
2341     // CONTRACT MANAGEMENT 
2342     /////////////////////////////
2343 
2344     function setmaxMintAmountFree(uint256 _newmaxMintAmountFree) public onlyOwner {
2345         maxMintAmountFree = _newmaxMintAmountFree;
2346     }
2347 
2348     function setmaxMintAmountPaid(uint256 _newmaxMintAmount) public onlyOwner {
2349         maxMintAmountPublic = _newmaxMintAmount;
2350     }
2351 
2352     function setfreeSupply(uint256 _newfreeSupply) public onlyOwner {
2353         require( _newfreeSupply <= maxSupply, "maxSupply exceeded");
2354         freeSupply = _newfreeSupply;
2355     }
2356 	
2357     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2358         baseURI = _newBaseURI;
2359     }
2360 
2361     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2362         baseExtension = _newBaseExtension;
2363     }
2364 
2365     function setCost(uint256 _price) public onlyOwner {
2366         cost = _price;
2367     }
2368 
2369     function setFreeCost(uint256 _price) public onlyOwner {
2370         Freecost = _price;
2371     }
2372 
2373     function pause() public onlyOwner {
2374         currentState = 0;
2375     }
2376 
2377     function setPaidMint() public onlyOwner {
2378         currentState = 1;
2379     }
2380 
2381     function setFreeMint() public onlyOwner {
2382         currentState = 2;
2383     }
2384 
2385     function withdraw() public onlyOwner nonReentrant {
2386         (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2387         require(os);
2388     }
2389 
2390     /////////////////////////////
2391     // OPENSEA FILTER REGISTRY 
2392     /////////////////////////////
2393 
2394     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2395         super.setApprovalForAll(operator, approved);
2396     }
2397 
2398     function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
2399         super.approve(operator, tokenId);
2400     }
2401 
2402     function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2403         super.transferFrom(from, to, tokenId);
2404     }
2405 
2406     function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
2407         super.safeTransferFrom(from, to, tokenId);
2408     }
2409 
2410     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2411         public
2412         payable
2413         override
2414         onlyAllowedOperator(from)
2415     {
2416         super.safeTransferFrom(from, to, tokenId, data);
2417     }
2418 }