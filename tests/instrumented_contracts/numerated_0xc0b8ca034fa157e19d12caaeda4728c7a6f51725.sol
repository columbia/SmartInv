1 // SPDX-License-Identifier: MIT
2 // File: operator-filter-registry/src/lib/Constants.sol
3 
4 
5 //    _  _____  _____  _    ___  _  __   ___    _    __  __  ___ 
6 //   /_\|_   _||_   _|/_\  / __|| |/ /  / __|  /_\  |  \/  || __|
7 //  / _ \ | |    | | / _ \| (__ | ' <  | (_ | / _ \ | |\/| || _| 
8 // /_/ \_\|_|    |_|/_/ \_\\___||_|\_\  \___|/_/ \_\|_|  |_||___|
9                                                                
10 
11 
12 pragma solidity ^0.8.13;
13 
14 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
15 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
16 
17 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
18 
19 
20 pragma solidity ^0.8.13;
21 
22 interface IOperatorFilterRegistry {
23     /**
24      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
25      *         true if supplied registrant address is not registered.
26      */
27     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
28 
29     /**
30      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
31      */
32     function register(address registrant) external;
33 
34     /**
35      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
36      */
37     function registerAndSubscribe(address registrant, address subscription) external;
38 
39     /**
40      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
41      *         address without subscribing.
42      */
43     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
44 
45     /**
46      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
47      *         Note that this does not remove any filtered addresses or codeHashes.
48      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
49      */
50     function unregister(address addr) external;
51 
52     /**
53      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
54      */
55     function updateOperator(address registrant, address operator, bool filtered) external;
56 
57     /**
58      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
59      */
60     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
61 
62     /**
63      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
64      */
65     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
66 
67     /**
68      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
69      */
70     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
71 
72     /**
73      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
74      *         subscription if present.
75      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
76      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
77      *         used.
78      */
79     function subscribe(address registrant, address registrantToSubscribe) external;
80 
81     /**
82      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
83      */
84     function unsubscribe(address registrant, bool copyExistingEntries) external;
85 
86     /**
87      * @notice Get the subscription address of a given registrant, if any.
88      */
89     function subscriptionOf(address addr) external returns (address registrant);
90 
91     /**
92      * @notice Get the set of addresses subscribed to a given registrant.
93      *         Note that order is not guaranteed as updates are made.
94      */
95     function subscribers(address registrant) external returns (address[] memory);
96 
97     /**
98      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
99      *         Note that order is not guaranteed as updates are made.
100      */
101     function subscriberAt(address registrant, uint256 index) external returns (address);
102 
103     /**
104      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
105      */
106     function copyEntriesOf(address registrant, address registrantToCopy) external;
107 
108     /**
109      * @notice Returns true if operator is filtered by a given address or its subscription.
110      */
111     function isOperatorFiltered(address registrant, address operator) external returns (bool);
112 
113     /**
114      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
115      */
116     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
117 
118     /**
119      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
120      */
121     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
122 
123     /**
124      * @notice Returns a list of filtered operators for a given address or its subscription.
125      */
126     function filteredOperators(address addr) external returns (address[] memory);
127 
128     /**
129      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
130      *         Note that order is not guaranteed as updates are made.
131      */
132     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
133 
134     /**
135      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
136      *         its subscription.
137      *         Note that order is not guaranteed as updates are made.
138      */
139     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
140 
141     /**
142      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
143      *         its subscription.
144      *         Note that order is not guaranteed as updates are made.
145      */
146     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
147 
148     /**
149      * @notice Returns true if an address has registered
150      */
151     function isRegistered(address addr) external returns (bool);
152 
153     /**
154      * @dev Convenience method to compute the code hash of an arbitrary contract
155      */
156     function codeHashOf(address addr) external returns (bytes32);
157 }
158 
159 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
160 
161 
162 pragma solidity ^0.8.13;
163 
164 
165 /**
166  * @title  UpdatableOperatorFilterer
167  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
168  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
169  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
170  *         which will bypass registry checks.
171  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
172  *         on-chain, eg, if the registry is revoked or bypassed.
173  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
174  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
175  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
176  */
177 abstract contract UpdatableOperatorFilterer {
178     /// @dev Emitted when an operator is not allowed.
179     error OperatorNotAllowed(address operator);
180     /// @dev Emitted when someone other than the owner is trying to call an only owner function.
181     error OnlyOwner();
182 
183     event OperatorFilterRegistryAddressUpdated(address newRegistry);
184 
185     IOperatorFilterRegistry public operatorFilterRegistry;
186 
187     /// @dev The constructor that is called when the contract is being deployed.
188     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
189         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
190         operatorFilterRegistry = registry;
191         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
192         // will not revert, but the contract will need to be registered with the registry once it is deployed in
193         // order for the modifier to filter addresses.
194         if (address(registry).code.length > 0) {
195             if (subscribe) {
196                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
197             } else {
198                 if (subscriptionOrRegistrantToCopy != address(0)) {
199                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
200                 } else {
201                     registry.register(address(this));
202                 }
203             }
204         }
205     }
206 
207     /**
208      * @dev A helper function to check if the operator is allowed.
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
221      * @dev A helper function to check if the operator approval is allowed.
222      */
223     modifier onlyAllowedOperatorApproval(address operator) virtual {
224         _checkFilterOperator(operator);
225         _;
226     }
227 
228     /**
229      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
230      *         address, checks will be bypassed. OnlyOwner.
231      */
232     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
233         if (msg.sender != owner()) {
234             revert OnlyOwner();
235         }
236         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
237         emit OperatorFilterRegistryAddressUpdated(newRegistry);
238     }
239 
240     /**
241      * @dev Assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract.
242      */
243     function owner() public view virtual returns (address);
244 
245     /**
246      * @dev A helper function to check if the operator is allowed.
247      */
248     function _checkFilterOperator(address operator) internal view virtual {
249         IOperatorFilterRegistry registry = operatorFilterRegistry;
250         // Check registry code length to facilitate testing in environments without a deployed registry.
251         if (address(registry) != address(0) && address(registry).code.length > 0) {
252             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
253             // may specify their own OperatorFilterRegistry implementations, which may behave differently
254             if (!registry.isOperatorAllowed(address(this), operator)) {
255                 revert OperatorNotAllowed(operator);
256             }
257         }
258     }
259 }
260 
261 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
262 
263 
264 pragma solidity ^0.8.13;
265 
266 
267 
268 /**
269  * @title  RevokableOperatorFilterer
270  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
271  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
272  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
273  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
274  *         address cannot be further updated.
275  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
276  *         on-chain, eg, if the registry is revoked or bypassed.
277  */
278 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
279     /// @dev Emitted when the registry has already been revoked.
280     error RegistryHasBeenRevoked();
281     /// @dev Emitted when the initial registry address is attempted to be set to the zero address.
282     error InitialRegistryAddressCannotBeZeroAddress();
283 
284     event OperatorFilterRegistryRevoked();
285 
286     bool public isOperatorFilterRegistryRevoked;
287 
288     /// @dev The constructor that is called when the contract is being deployed.
289     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
290         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
291     {
292         // don't allow creating a contract with a permanently revoked registry
293         if (_registry == address(0)) {
294             revert InitialRegistryAddressCannotBeZeroAddress();
295         }
296     }
297 
298     /**
299      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
300      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
301      */
302     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
303         if (msg.sender != owner()) {
304             revert OnlyOwner();
305         }
306         // if registry has been revoked, do not allow further updates
307         if (isOperatorFilterRegistryRevoked) {
308             revert RegistryHasBeenRevoked();
309         }
310 
311         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
312         emit OperatorFilterRegistryAddressUpdated(newRegistry);
313     }
314 
315     /**
316      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
317      */
318     function revokeOperatorFilterRegistry() public {
319         if (msg.sender != owner()) {
320             revert OnlyOwner();
321         }
322         // if registry has been revoked, do not allow further updates
323         if (isOperatorFilterRegistryRevoked) {
324             revert RegistryHasBeenRevoked();
325         }
326 
327         // set to zero address to bypass checks
328         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
329         isOperatorFilterRegistryRevoked = true;
330         emit OperatorFilterRegistryRevoked();
331     }
332 }
333 
334 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
335 
336 
337 pragma solidity ^0.8.13;
338 
339 
340 /**
341  * @title  RevokableDefaultOperatorFilterer
342  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
343  *         Note that OpenSea will disable creator earnings enforcement if filtered operators begin fulfilling orders
344  *         on-chain, eg, if the registry is revoked or bypassed.
345  */
346 
347 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
348     /// @dev The constructor that is called when the contract is being deployed.
349     constructor()
350         RevokableOperatorFilterer(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS, CANONICAL_CORI_SUBSCRIPTION, true)
351     {}
352 }
353 
354 // File: @openzeppelin/contracts/utils/Counters.sol
355 
356 
357 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
358 
359 pragma solidity ^0.8.0;
360 
361 /**
362  * @title Counters
363  * @author Matt Condon (@shrugs)
364  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
365  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
366  *
367  * Include with `using Counters for Counters.Counter;`
368  */
369 library Counters {
370     struct Counter {
371         // This variable should never be directly accessed by users of the library: interactions must be restricted to
372         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
373         // this feature: see https://github.com/ethereum/solidity/issues/4637
374         uint256 _value; // default: 0
375     }
376 
377     function current(Counter storage counter) internal view returns (uint256) {
378         return counter._value;
379     }
380 
381     function increment(Counter storage counter) internal {
382         unchecked {
383             counter._value += 1;
384         }
385     }
386 
387     function decrement(Counter storage counter) internal {
388         uint256 value = counter._value;
389         require(value > 0, "Counter: decrement overflow");
390         unchecked {
391             counter._value = value - 1;
392         }
393     }
394 
395     function reset(Counter storage counter) internal {
396         counter._value = 0;
397     }
398 }
399 
400 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
401 
402 
403 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
404 
405 pragma solidity ^0.8.0;
406 
407 /**
408  * @dev Standard signed math utilities missing in the Solidity language.
409  */
410 library SignedMath {
411     /**
412      * @dev Returns the largest of two signed numbers.
413      */
414     function max(int256 a, int256 b) internal pure returns (int256) {
415         return a > b ? a : b;
416     }
417 
418     /**
419      * @dev Returns the smallest of two signed numbers.
420      */
421     function min(int256 a, int256 b) internal pure returns (int256) {
422         return a < b ? a : b;
423     }
424 
425     /**
426      * @dev Returns the average of two signed numbers without overflow.
427      * The result is rounded towards zero.
428      */
429     function average(int256 a, int256 b) internal pure returns (int256) {
430         // Formula from the book "Hacker's Delight"
431         int256 x = (a & b) + ((a ^ b) >> 1);
432         return x + (int256(uint256(x) >> 255) & (a ^ b));
433     }
434 
435     /**
436      * @dev Returns the absolute unsigned value of a signed value.
437      */
438     function abs(int256 n) internal pure returns (uint256) {
439         unchecked {
440             // must be unchecked in order to support `n = type(int256).min`
441             return uint256(n >= 0 ? n : -n);
442         }
443     }
444 }
445 
446 // File: @openzeppelin/contracts/utils/math/Math.sol
447 
448 
449 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
450 
451 pragma solidity ^0.8.0;
452 
453 /**
454  * @dev Standard math utilities missing in the Solidity language.
455  */
456 library Math {
457     enum Rounding {
458         Down, // Toward negative infinity
459         Up, // Toward infinity
460         Zero // Toward zero
461     }
462 
463     /**
464      * @dev Returns the largest of two numbers.
465      */
466     function max(uint256 a, uint256 b) internal pure returns (uint256) {
467         return a > b ? a : b;
468     }
469 
470     /**
471      * @dev Returns the smallest of two numbers.
472      */
473     function min(uint256 a, uint256 b) internal pure returns (uint256) {
474         return a < b ? a : b;
475     }
476 
477     /**
478      * @dev Returns the average of two numbers. The result is rounded towards
479      * zero.
480      */
481     function average(uint256 a, uint256 b) internal pure returns (uint256) {
482         // (a + b) / 2 can overflow.
483         return (a & b) + (a ^ b) / 2;
484     }
485 
486     /**
487      * @dev Returns the ceiling of the division of two numbers.
488      *
489      * This differs from standard division with `/` in that it rounds up instead
490      * of rounding down.
491      */
492     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
493         // (a + b - 1) / b can overflow on addition, so we distribute.
494         return a == 0 ? 0 : (a - 1) / b + 1;
495     }
496 
497     /**
498      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
499      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
500      * with further edits by Uniswap Labs also under MIT license.
501      */
502     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
503         unchecked {
504             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
505             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
506             // variables such that product = prod1 * 2^256 + prod0.
507             uint256 prod0; // Least significant 256 bits of the product
508             uint256 prod1; // Most significant 256 bits of the product
509             assembly {
510                 let mm := mulmod(x, y, not(0))
511                 prod0 := mul(x, y)
512                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
513             }
514 
515             // Handle non-overflow cases, 256 by 256 division.
516             if (prod1 == 0) {
517                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
518                 // The surrounding unchecked block does not change this fact.
519                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
520                 return prod0 / denominator;
521             }
522 
523             // Make sure the result is less than 2^256. Also prevents denominator == 0.
524             require(denominator > prod1, "Math: mulDiv overflow");
525 
526             ///////////////////////////////////////////////
527             // 512 by 256 division.
528             ///////////////////////////////////////////////
529 
530             // Make division exact by subtracting the remainder from [prod1 prod0].
531             uint256 remainder;
532             assembly {
533                 // Compute remainder using mulmod.
534                 remainder := mulmod(x, y, denominator)
535 
536                 // Subtract 256 bit number from 512 bit number.
537                 prod1 := sub(prod1, gt(remainder, prod0))
538                 prod0 := sub(prod0, remainder)
539             }
540 
541             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
542             // See https://cs.stackexchange.com/q/138556/92363.
543 
544             // Does not overflow because the denominator cannot be zero at this stage in the function.
545             uint256 twos = denominator & (~denominator + 1);
546             assembly {
547                 // Divide denominator by twos.
548                 denominator := div(denominator, twos)
549 
550                 // Divide [prod1 prod0] by twos.
551                 prod0 := div(prod0, twos)
552 
553                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
554                 twos := add(div(sub(0, twos), twos), 1)
555             }
556 
557             // Shift in bits from prod1 into prod0.
558             prod0 |= prod1 * twos;
559 
560             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
561             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
562             // four bits. That is, denominator * inv = 1 mod 2^4.
563             uint256 inverse = (3 * denominator) ^ 2;
564 
565             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
566             // in modular arithmetic, doubling the correct bits in each step.
567             inverse *= 2 - denominator * inverse; // inverse mod 2^8
568             inverse *= 2 - denominator * inverse; // inverse mod 2^16
569             inverse *= 2 - denominator * inverse; // inverse mod 2^32
570             inverse *= 2 - denominator * inverse; // inverse mod 2^64
571             inverse *= 2 - denominator * inverse; // inverse mod 2^128
572             inverse *= 2 - denominator * inverse; // inverse mod 2^256
573 
574             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
575             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
576             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
577             // is no longer required.
578             result = prod0 * inverse;
579             return result;
580         }
581     }
582 
583     /**
584      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
585      */
586     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
587         uint256 result = mulDiv(x, y, denominator);
588         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
589             result += 1;
590         }
591         return result;
592     }
593 
594     /**
595      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
596      *
597      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
598      */
599     function sqrt(uint256 a) internal pure returns (uint256) {
600         if (a == 0) {
601             return 0;
602         }
603 
604         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
605         //
606         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
607         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
608         //
609         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
610         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
611         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
612         //
613         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
614         uint256 result = 1 << (log2(a) >> 1);
615 
616         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
617         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
618         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
619         // into the expected uint128 result.
620         unchecked {
621             result = (result + a / result) >> 1;
622             result = (result + a / result) >> 1;
623             result = (result + a / result) >> 1;
624             result = (result + a / result) >> 1;
625             result = (result + a / result) >> 1;
626             result = (result + a / result) >> 1;
627             result = (result + a / result) >> 1;
628             return min(result, a / result);
629         }
630     }
631 
632     /**
633      * @notice Calculates sqrt(a), following the selected rounding direction.
634      */
635     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
636         unchecked {
637             uint256 result = sqrt(a);
638             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
639         }
640     }
641 
642     /**
643      * @dev Return the log in base 2, rounded down, of a positive value.
644      * Returns 0 if given 0.
645      */
646     function log2(uint256 value) internal pure returns (uint256) {
647         uint256 result = 0;
648         unchecked {
649             if (value >> 128 > 0) {
650                 value >>= 128;
651                 result += 128;
652             }
653             if (value >> 64 > 0) {
654                 value >>= 64;
655                 result += 64;
656             }
657             if (value >> 32 > 0) {
658                 value >>= 32;
659                 result += 32;
660             }
661             if (value >> 16 > 0) {
662                 value >>= 16;
663                 result += 16;
664             }
665             if (value >> 8 > 0) {
666                 value >>= 8;
667                 result += 8;
668             }
669             if (value >> 4 > 0) {
670                 value >>= 4;
671                 result += 4;
672             }
673             if (value >> 2 > 0) {
674                 value >>= 2;
675                 result += 2;
676             }
677             if (value >> 1 > 0) {
678                 result += 1;
679             }
680         }
681         return result;
682     }
683 
684     /**
685      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
686      * Returns 0 if given 0.
687      */
688     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
689         unchecked {
690             uint256 result = log2(value);
691             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
692         }
693     }
694 
695     /**
696      * @dev Return the log in base 10, rounded down, of a positive value.
697      * Returns 0 if given 0.
698      */
699     function log10(uint256 value) internal pure returns (uint256) {
700         uint256 result = 0;
701         unchecked {
702             if (value >= 10 ** 64) {
703                 value /= 10 ** 64;
704                 result += 64;
705             }
706             if (value >= 10 ** 32) {
707                 value /= 10 ** 32;
708                 result += 32;
709             }
710             if (value >= 10 ** 16) {
711                 value /= 10 ** 16;
712                 result += 16;
713             }
714             if (value >= 10 ** 8) {
715                 value /= 10 ** 8;
716                 result += 8;
717             }
718             if (value >= 10 ** 4) {
719                 value /= 10 ** 4;
720                 result += 4;
721             }
722             if (value >= 10 ** 2) {
723                 value /= 10 ** 2;
724                 result += 2;
725             }
726             if (value >= 10 ** 1) {
727                 result += 1;
728             }
729         }
730         return result;
731     }
732 
733     /**
734      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
735      * Returns 0 if given 0.
736      */
737     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
738         unchecked {
739             uint256 result = log10(value);
740             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
741         }
742     }
743 
744     /**
745      * @dev Return the log in base 256, rounded down, of a positive value.
746      * Returns 0 if given 0.
747      *
748      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
749      */
750     function log256(uint256 value) internal pure returns (uint256) {
751         uint256 result = 0;
752         unchecked {
753             if (value >> 128 > 0) {
754                 value >>= 128;
755                 result += 16;
756             }
757             if (value >> 64 > 0) {
758                 value >>= 64;
759                 result += 8;
760             }
761             if (value >> 32 > 0) {
762                 value >>= 32;
763                 result += 4;
764             }
765             if (value >> 16 > 0) {
766                 value >>= 16;
767                 result += 2;
768             }
769             if (value >> 8 > 0) {
770                 result += 1;
771             }
772         }
773         return result;
774     }
775 
776     /**
777      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
778      * Returns 0 if given 0.
779      */
780     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
781         unchecked {
782             uint256 result = log256(value);
783             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
784         }
785     }
786 }
787 
788 // File: @openzeppelin/contracts/utils/Strings.sol
789 
790 
791 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 
796 
797 /**
798  * @dev String operations.
799  */
800 library Strings {
801     bytes16 private constant _SYMBOLS = "0123456789abcdef";
802     uint8 private constant _ADDRESS_LENGTH = 20;
803 
804     /**
805      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
806      */
807     function toString(uint256 value) internal pure returns (string memory) {
808         unchecked {
809             uint256 length = Math.log10(value) + 1;
810             string memory buffer = new string(length);
811             uint256 ptr;
812             /// @solidity memory-safe-assembly
813             assembly {
814                 ptr := add(buffer, add(32, length))
815             }
816             while (true) {
817                 ptr--;
818                 /// @solidity memory-safe-assembly
819                 assembly {
820                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
821                 }
822                 value /= 10;
823                 if (value == 0) break;
824             }
825             return buffer;
826         }
827     }
828 
829     /**
830      * @dev Converts a `int256` to its ASCII `string` decimal representation.
831      */
832     function toString(int256 value) internal pure returns (string memory) {
833         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
834     }
835 
836     /**
837      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
838      */
839     function toHexString(uint256 value) internal pure returns (string memory) {
840         unchecked {
841             return toHexString(value, Math.log256(value) + 1);
842         }
843     }
844 
845     /**
846      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
847      */
848     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
849         bytes memory buffer = new bytes(2 * length + 2);
850         buffer[0] = "0";
851         buffer[1] = "x";
852         for (uint256 i = 2 * length + 1; i > 1; --i) {
853             buffer[i] = _SYMBOLS[value & 0xf];
854             value >>= 4;
855         }
856         require(value == 0, "Strings: hex length insufficient");
857         return string(buffer);
858     }
859 
860     /**
861      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
862      */
863     function toHexString(address addr) internal pure returns (string memory) {
864         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
865     }
866 
867     /**
868      * @dev Returns true if the two strings are equal.
869      */
870     function equal(string memory a, string memory b) internal pure returns (bool) {
871         return keccak256(bytes(a)) == keccak256(bytes(b));
872     }
873 }
874 
875 // File: @openzeppelin/contracts/utils/Context.sol
876 
877 
878 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
879 
880 pragma solidity ^0.8.0;
881 
882 /**
883  * @dev Provides information about the current execution context, including the
884  * sender of the transaction and its data. While these are generally available
885  * via msg.sender and msg.data, they should not be accessed in such a direct
886  * manner, since when dealing with meta-transactions the account sending and
887  * paying for execution may not be the actual sender (as far as an application
888  * is concerned).
889  *
890  * This contract is only required for intermediate, library-like contracts.
891  */
892 abstract contract Context {
893     function _msgSender() internal view virtual returns (address) {
894         return msg.sender;
895     }
896 
897     function _msgData() internal view virtual returns (bytes calldata) {
898         return msg.data;
899     }
900 }
901 
902 // File: @openzeppelin/contracts/access/Ownable.sol
903 
904 
905 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
906 
907 pragma solidity ^0.8.0;
908 
909 
910 /**
911  * @dev Contract module which provides a basic access control mechanism, where
912  * there is an account (an owner) that can be granted exclusive access to
913  * specific functions.
914  *
915  * By default, the owner account will be the one that deploys the contract. This
916  * can later be changed with {transferOwnership}.
917  *
918  * This module is used through inheritance. It will make available the modifier
919  * `onlyOwner`, which can be applied to your functions to restrict their use to
920  * the owner.
921  */
922 abstract contract Ownable is Context {
923     address private _owner;
924 
925     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
926 
927     /**
928      * @dev Initializes the contract setting the deployer as the initial owner.
929      */
930     constructor() {
931         _transferOwnership(_msgSender());
932     }
933 
934     /**
935      * @dev Throws if called by any account other than the owner.
936      */
937     modifier onlyOwner() {
938         _checkOwner();
939         _;
940     }
941 
942     /**
943      * @dev Returns the address of the current owner.
944      */
945     function owner() public view virtual returns (address) {
946         return _owner;
947     }
948 
949     /**
950      * @dev Throws if the sender is not the owner.
951      */
952     function _checkOwner() internal view virtual {
953         require(owner() == _msgSender(), "Ownable: caller is not the owner");
954     }
955 
956     /**
957      * @dev Leaves the contract without owner. It will not be possible to call
958      * `onlyOwner` functions. Can only be called by the current owner.
959      *
960      * NOTE: Renouncing ownership will leave the contract without an owner,
961      * thereby disabling any functionality that is only available to the owner.
962      */
963     function renounceOwnership() public virtual onlyOwner {
964         _transferOwnership(address(0));
965     }
966 
967     /**
968      * @dev Transfers ownership of the contract to a new account (`newOwner`).
969      * Can only be called by the current owner.
970      */
971     function transferOwnership(address newOwner) public virtual onlyOwner {
972         require(newOwner != address(0), "Ownable: new owner is the zero address");
973         _transferOwnership(newOwner);
974     }
975 
976     /**
977      * @dev Transfers ownership of the contract to a new account (`newOwner`).
978      * Internal function without access restriction.
979      */
980     function _transferOwnership(address newOwner) internal virtual {
981         address oldOwner = _owner;
982         _owner = newOwner;
983         emit OwnershipTransferred(oldOwner, newOwner);
984     }
985 }
986 
987 // File: @openzeppelin/contracts/utils/Address.sol
988 
989 
990 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Address.sol)
991 
992 pragma solidity ^0.8.1;
993 
994 /**
995  * @dev Collection of functions related to the address type
996  */
997 library Address {
998     /**
999      * @dev Returns true if `account` is a contract.
1000      *
1001      * [IMPORTANT]
1002      * ====
1003      * It is unsafe to assume that an address for which this function returns
1004      * false is an externally-owned account (EOA) and not a contract.
1005      *
1006      * Among others, `isContract` will return false for the following
1007      * types of addresses:
1008      *
1009      *  - an externally-owned account
1010      *  - a contract in construction
1011      *  - an address where a contract will be created
1012      *  - an address where a contract lived, but was destroyed
1013      *
1014      * Furthermore, `isContract` will also return true if the target contract within
1015      * the same transaction is already scheduled for destruction by `SELFDESTRUCT`,
1016      * which only has an effect at the end of a transaction.
1017      * ====
1018      *
1019      * [IMPORTANT]
1020      * ====
1021      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1022      *
1023      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1024      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1025      * constructor.
1026      * ====
1027      */
1028     function isContract(address account) internal view returns (bool) {
1029         // This method relies on extcodesize/address.code.length, which returns 0
1030         // for contracts in construction, since the code is only stored at the end
1031         // of the constructor execution.
1032 
1033         return account.code.length > 0;
1034     }
1035 
1036     /**
1037      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1038      * `recipient`, forwarding all available gas and reverting on errors.
1039      *
1040      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1041      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1042      * imposed by `transfer`, making them unable to receive funds via
1043      * `transfer`. {sendValue} removes this limitation.
1044      *
1045      * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1046      *
1047      * IMPORTANT: because control is transferred to `recipient`, care must be
1048      * taken to not create reentrancy vulnerabilities. Consider using
1049      * {ReentrancyGuard} or the
1050      * https://solidity.readthedocs.io/en/v0.8.0/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1051      */
1052     function sendValue(address payable recipient, uint256 amount) internal {
1053         require(address(this).balance >= amount, "Address: insufficient balance");
1054 
1055         (bool success, ) = recipient.call{value: amount}("");
1056         require(success, "Address: unable to send value, recipient may have reverted");
1057     }
1058 
1059     /**
1060      * @dev Performs a Solidity function call using a low level `call`. A
1061      * plain `call` is an unsafe replacement for a function call: use this
1062      * function instead.
1063      *
1064      * If `target` reverts with a revert reason, it is bubbled up by this
1065      * function (like regular Solidity function calls).
1066      *
1067      * Returns the raw returned data. To convert to the expected return value,
1068      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1069      *
1070      * Requirements:
1071      *
1072      * - `target` must be a contract.
1073      * - calling `target` with `data` must not revert.
1074      *
1075      * _Available since v3.1._
1076      */
1077     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1078         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1079     }
1080 
1081     /**
1082      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1083      * `errorMessage` as a fallback revert reason when `target` reverts.
1084      *
1085      * _Available since v3.1._
1086      */
1087     function functionCall(
1088         address target,
1089         bytes memory data,
1090         string memory errorMessage
1091     ) internal returns (bytes memory) {
1092         return functionCallWithValue(target, data, 0, errorMessage);
1093     }
1094 
1095     /**
1096      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1097      * but also transferring `value` wei to `target`.
1098      *
1099      * Requirements:
1100      *
1101      * - the calling contract must have an ETH balance of at least `value`.
1102      * - the called Solidity function must be `payable`.
1103      *
1104      * _Available since v3.1._
1105      */
1106     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1107         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1108     }
1109 
1110     /**
1111      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1112      * with `errorMessage` as a fallback revert reason when `target` reverts.
1113      *
1114      * _Available since v3.1._
1115      */
1116     function functionCallWithValue(
1117         address target,
1118         bytes memory data,
1119         uint256 value,
1120         string memory errorMessage
1121     ) internal returns (bytes memory) {
1122         require(address(this).balance >= value, "Address: insufficient balance for call");
1123         (bool success, bytes memory returndata) = target.call{value: value}(data);
1124         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1125     }
1126 
1127     /**
1128      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1129      * but performing a static call.
1130      *
1131      * _Available since v3.3._
1132      */
1133     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1134         return functionStaticCall(target, data, "Address: low-level static call failed");
1135     }
1136 
1137     /**
1138      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1139      * but performing a static call.
1140      *
1141      * _Available since v3.3._
1142      */
1143     function functionStaticCall(
1144         address target,
1145         bytes memory data,
1146         string memory errorMessage
1147     ) internal view returns (bytes memory) {
1148         (bool success, bytes memory returndata) = target.staticcall(data);
1149         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1150     }
1151 
1152     /**
1153      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1154      * but performing a delegate call.
1155      *
1156      * _Available since v3.4._
1157      */
1158     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1159         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1160     }
1161 
1162     /**
1163      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1164      * but performing a delegate call.
1165      *
1166      * _Available since v3.4._
1167      */
1168     function functionDelegateCall(
1169         address target,
1170         bytes memory data,
1171         string memory errorMessage
1172     ) internal returns (bytes memory) {
1173         (bool success, bytes memory returndata) = target.delegatecall(data);
1174         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1175     }
1176 
1177     /**
1178      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1179      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1180      *
1181      * _Available since v4.8._
1182      */
1183     function verifyCallResultFromTarget(
1184         address target,
1185         bool success,
1186         bytes memory returndata,
1187         string memory errorMessage
1188     ) internal view returns (bytes memory) {
1189         if (success) {
1190             if (returndata.length == 0) {
1191                 // only check isContract if the call was successful and the return data is empty
1192                 // otherwise we already know that it was a contract
1193                 require(isContract(target), "Address: call to non-contract");
1194             }
1195             return returndata;
1196         } else {
1197             _revert(returndata, errorMessage);
1198         }
1199     }
1200 
1201     /**
1202      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1203      * revert reason or using the provided one.
1204      *
1205      * _Available since v4.3._
1206      */
1207     function verifyCallResult(
1208         bool success,
1209         bytes memory returndata,
1210         string memory errorMessage
1211     ) internal pure returns (bytes memory) {
1212         if (success) {
1213             return returndata;
1214         } else {
1215             _revert(returndata, errorMessage);
1216         }
1217     }
1218 
1219     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1220         // Look for revert reason and bubble it up if present
1221         if (returndata.length > 0) {
1222             // The easiest way to bubble the revert reason is using memory via assembly
1223             /// @solidity memory-safe-assembly
1224             assembly {
1225                 let returndata_size := mload(returndata)
1226                 revert(add(32, returndata), returndata_size)
1227             }
1228         } else {
1229             revert(errorMessage);
1230         }
1231     }
1232 }
1233 
1234 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1235 
1236 
1237 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1238 
1239 pragma solidity ^0.8.0;
1240 
1241 /**
1242  * @title ERC721 token receiver interface
1243  * @dev Interface for any contract that wants to support safeTransfers
1244  * from ERC721 asset contracts.
1245  */
1246 interface IERC721Receiver {
1247     /**
1248      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1249      * by `operator` from `from`, this function is called.
1250      *
1251      * It must return its Solidity selector to confirm the token transfer.
1252      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1253      *
1254      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1255      */
1256     function onERC721Received(
1257         address operator,
1258         address from,
1259         uint256 tokenId,
1260         bytes calldata data
1261     ) external returns (bytes4);
1262 }
1263 
1264 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1265 
1266 
1267 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 /**
1272  * @dev Interface of the ERC165 standard, as defined in the
1273  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1274  *
1275  * Implementers can declare support of contract interfaces, which can then be
1276  * queried by others ({ERC165Checker}).
1277  *
1278  * For an implementation, see {ERC165}.
1279  */
1280 interface IERC165 {
1281     /**
1282      * @dev Returns true if this contract implements the interface defined by
1283      * `interfaceId`. See the corresponding
1284      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1285      * to learn more about how these ids are created.
1286      *
1287      * This function call must use less than 30 000 gas.
1288      */
1289     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1290 }
1291 
1292 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1293 
1294 
1295 // OpenZeppelin Contracts (last updated v4.9.0) (interfaces/IERC2981.sol)
1296 
1297 pragma solidity ^0.8.0;
1298 
1299 
1300 /**
1301  * @dev Interface for the NFT Royalty Standard.
1302  *
1303  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1304  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1305  *
1306  * _Available since v4.5._
1307  */
1308 interface IERC2981 is IERC165 {
1309     /**
1310      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1311      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1312      */
1313     function royaltyInfo(
1314         uint256 tokenId,
1315         uint256 salePrice
1316     ) external view returns (address receiver, uint256 royaltyAmount);
1317 }
1318 
1319 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1320 
1321 
1322 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1323 
1324 pragma solidity ^0.8.0;
1325 
1326 
1327 /**
1328  * @dev Implementation of the {IERC165} interface.
1329  *
1330  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1331  * for the additional interface id that will be supported. For example:
1332  *
1333  * ```solidity
1334  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1335  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1336  * }
1337  * ```
1338  *
1339  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1340  */
1341 abstract contract ERC165 is IERC165 {
1342     /**
1343      * @dev See {IERC165-supportsInterface}.
1344      */
1345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1346         return interfaceId == type(IERC165).interfaceId;
1347     }
1348 }
1349 
1350 // File: @openzeppelin/contracts/token/common/ERC2981.sol
1351 
1352 
1353 // OpenZeppelin Contracts (last updated v4.9.0) (token/common/ERC2981.sol)
1354 
1355 pragma solidity ^0.8.0;
1356 
1357 
1358 
1359 /**
1360  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
1361  *
1362  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
1363  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
1364  *
1365  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
1366  * fee is specified in basis points by default.
1367  *
1368  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
1369  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
1370  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
1371  *
1372  * _Available since v4.5._
1373  */
1374 abstract contract ERC2981 is IERC2981, ERC165 {
1375     struct RoyaltyInfo {
1376         address receiver;
1377         uint96 royaltyFraction;
1378     }
1379 
1380     RoyaltyInfo private _defaultRoyaltyInfo;
1381     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
1382 
1383     /**
1384      * @dev See {IERC165-supportsInterface}.
1385      */
1386     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
1387         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
1388     }
1389 
1390     /**
1391      * @inheritdoc IERC2981
1392      */
1393     function royaltyInfo(uint256 tokenId, uint256 salePrice) public view virtual override returns (address, uint256) {
1394         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[tokenId];
1395 
1396         if (royalty.receiver == address(0)) {
1397             royalty = _defaultRoyaltyInfo;
1398         }
1399 
1400         uint256 royaltyAmount = (salePrice * royalty.royaltyFraction) / _feeDenominator();
1401 
1402         return (royalty.receiver, royaltyAmount);
1403     }
1404 
1405     /**
1406      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
1407      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
1408      * override.
1409      */
1410     function _feeDenominator() internal pure virtual returns (uint96) {
1411         return 10000;
1412     }
1413 
1414     /**
1415      * @dev Sets the royalty information that all ids in this contract will default to.
1416      *
1417      * Requirements:
1418      *
1419      * - `receiver` cannot be the zero address.
1420      * - `feeNumerator` cannot be greater than the fee denominator.
1421      */
1422     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
1423         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1424         require(receiver != address(0), "ERC2981: invalid receiver");
1425 
1426         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
1427     }
1428 
1429     /**
1430      * @dev Removes default royalty information.
1431      */
1432     function _deleteDefaultRoyalty() internal virtual {
1433         delete _defaultRoyaltyInfo;
1434     }
1435 
1436     /**
1437      * @dev Sets the royalty information for a specific token id, overriding the global default.
1438      *
1439      * Requirements:
1440      *
1441      * - `receiver` cannot be the zero address.
1442      * - `feeNumerator` cannot be greater than the fee denominator.
1443      */
1444     function _setTokenRoyalty(uint256 tokenId, address receiver, uint96 feeNumerator) internal virtual {
1445         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
1446         require(receiver != address(0), "ERC2981: Invalid parameters");
1447 
1448         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
1449     }
1450 
1451     /**
1452      * @dev Resets royalty information for the token id back to the global default.
1453      */
1454     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
1455         delete _tokenRoyaltyInfo[tokenId];
1456     }
1457 }
1458 
1459 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1460 
1461 
1462 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/IERC721.sol)
1463 
1464 pragma solidity ^0.8.0;
1465 
1466 
1467 /**
1468  * @dev Required interface of an ERC721 compliant contract.
1469  */
1470 interface IERC721 is IERC165 {
1471     /**
1472      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1473      */
1474     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1475 
1476     /**
1477      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1478      */
1479     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1480 
1481     /**
1482      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1483      */
1484     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1485 
1486     /**
1487      * @dev Returns the number of tokens in ``owner``'s account.
1488      */
1489     function balanceOf(address owner) external view returns (uint256 balance);
1490 
1491     /**
1492      * @dev Returns the owner of the `tokenId` token.
1493      *
1494      * Requirements:
1495      *
1496      * - `tokenId` must exist.
1497      */
1498     function ownerOf(uint256 tokenId) external view returns (address owner);
1499 
1500     /**
1501      * @dev Safely transfers `tokenId` token from `from` to `to`.
1502      *
1503      * Requirements:
1504      *
1505      * - `from` cannot be the zero address.
1506      * - `to` cannot be the zero address.
1507      * - `tokenId` token must exist and be owned by `from`.
1508      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1509      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1514 
1515     /**
1516      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1517      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1518      *
1519      * Requirements:
1520      *
1521      * - `from` cannot be the zero address.
1522      * - `to` cannot be the zero address.
1523      * - `tokenId` token must exist and be owned by `from`.
1524      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1525      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1526      *
1527      * Emits a {Transfer} event.
1528      */
1529     function safeTransferFrom(address from, address to, uint256 tokenId) external;
1530 
1531     /**
1532      * @dev Transfers `tokenId` token from `from` to `to`.
1533      *
1534      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1535      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1536      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1537      *
1538      * Requirements:
1539      *
1540      * - `from` cannot be the zero address.
1541      * - `to` cannot be the zero address.
1542      * - `tokenId` token must be owned by `from`.
1543      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1544      *
1545      * Emits a {Transfer} event.
1546      */
1547     function transferFrom(address from, address to, uint256 tokenId) external;
1548 
1549     /**
1550      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1551      * The approval is cleared when the token is transferred.
1552      *
1553      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1554      *
1555      * Requirements:
1556      *
1557      * - The caller must own the token or be an approved operator.
1558      * - `tokenId` must exist.
1559      *
1560      * Emits an {Approval} event.
1561      */
1562     function approve(address to, uint256 tokenId) external;
1563 
1564     /**
1565      * @dev Approve or remove `operator` as an operator for the caller.
1566      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1567      *
1568      * Requirements:
1569      *
1570      * - The `operator` cannot be the caller.
1571      *
1572      * Emits an {ApprovalForAll} event.
1573      */
1574     function setApprovalForAll(address operator, bool approved) external;
1575 
1576     /**
1577      * @dev Returns the account approved for `tokenId` token.
1578      *
1579      * Requirements:
1580      *
1581      * - `tokenId` must exist.
1582      */
1583     function getApproved(uint256 tokenId) external view returns (address operator);
1584 
1585     /**
1586      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1587      *
1588      * See {setApprovalForAll}
1589      */
1590     function isApprovedForAll(address owner, address operator) external view returns (bool);
1591 }
1592 
1593 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1594 
1595 
1596 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1597 
1598 pragma solidity ^0.8.0;
1599 
1600 
1601 /**
1602  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1603  * @dev See https://eips.ethereum.org/EIPS/eip-721
1604  */
1605 interface IERC721Metadata is IERC721 {
1606     /**
1607      * @dev Returns the token collection name.
1608      */
1609     function name() external view returns (string memory);
1610 
1611     /**
1612      * @dev Returns the token collection symbol.
1613      */
1614     function symbol() external view returns (string memory);
1615 
1616     /**
1617      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1618      */
1619     function tokenURI(uint256 tokenId) external view returns (string memory);
1620 }
1621 
1622 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1623 
1624 
1625 // OpenZeppelin Contracts (last updated v4.9.0) (token/ERC721/ERC721.sol)
1626 
1627 pragma solidity ^0.8.0;
1628 
1629 
1630 
1631 
1632 
1633 
1634 
1635 
1636 /**
1637  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1638  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1639  * {ERC721Enumerable}.
1640  */
1641 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1642     using Address for address;
1643     using Strings for uint256;
1644 
1645     // Token name
1646     string private _name;
1647 
1648     // Token symbol
1649     string private _symbol;
1650 
1651     // Mapping from token ID to owner address
1652     mapping(uint256 => address) private _owners;
1653 
1654     // Mapping owner address to token count
1655     mapping(address => uint256) private _balances;
1656 
1657     // Mapping from token ID to approved address
1658     mapping(uint256 => address) private _tokenApprovals;
1659 
1660     // Mapping from owner to operator approvals
1661     mapping(address => mapping(address => bool)) private _operatorApprovals;
1662 
1663     /**
1664      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1665      */
1666     constructor(string memory name_, string memory symbol_) {
1667         _name = name_;
1668         _symbol = symbol_;
1669     }
1670 
1671     /**
1672      * @dev See {IERC165-supportsInterface}.
1673      */
1674     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1675         return
1676             interfaceId == type(IERC721).interfaceId ||
1677             interfaceId == type(IERC721Metadata).interfaceId ||
1678             super.supportsInterface(interfaceId);
1679     }
1680 
1681     /**
1682      * @dev See {IERC721-balanceOf}.
1683      */
1684     function balanceOf(address owner) public view virtual override returns (uint256) {
1685         require(owner != address(0), "ERC721: address zero is not a valid owner");
1686         return _balances[owner];
1687     }
1688 
1689     /**
1690      * @dev See {IERC721-ownerOf}.
1691      */
1692     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1693         address owner = _ownerOf(tokenId);
1694         require(owner != address(0), "ERC721: invalid token ID");
1695         return owner;
1696     }
1697 
1698     /**
1699      * @dev See {IERC721Metadata-name}.
1700      */
1701     function name() public view virtual override returns (string memory) {
1702         return _name;
1703     }
1704 
1705     /**
1706      * @dev See {IERC721Metadata-symbol}.
1707      */
1708     function symbol() public view virtual override returns (string memory) {
1709         return _symbol;
1710     }
1711 
1712     /**
1713      * @dev See {IERC721Metadata-tokenURI}.
1714      */
1715     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1716         _requireMinted(tokenId);
1717 
1718         string memory baseURI = _baseURI();
1719         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1720     }
1721 
1722     /**
1723      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1724      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1725      * by default, can be overridden in child contracts.
1726      */
1727     function _baseURI() internal view virtual returns (string memory) {
1728         return "";
1729     }
1730 
1731     /**
1732      * @dev See {IERC721-approve}.
1733      */
1734     function approve(address to, uint256 tokenId) public virtual override {
1735         address owner = ERC721.ownerOf(tokenId);
1736         require(to != owner, "ERC721: approval to current owner");
1737 
1738         require(
1739             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1740             "ERC721: approve caller is not token owner or approved for all"
1741         );
1742 
1743         _approve(to, tokenId);
1744     }
1745 
1746     /**
1747      * @dev See {IERC721-getApproved}.
1748      */
1749     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1750         _requireMinted(tokenId);
1751 
1752         return _tokenApprovals[tokenId];
1753     }
1754 
1755     /**
1756      * @dev See {IERC721-setApprovalForAll}.
1757      */
1758     function setApprovalForAll(address operator, bool approved) public virtual override {
1759         _setApprovalForAll(_msgSender(), operator, approved);
1760     }
1761 
1762     /**
1763      * @dev See {IERC721-isApprovedForAll}.
1764      */
1765     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1766         return _operatorApprovals[owner][operator];
1767     }
1768 
1769     /**
1770      * @dev See {IERC721-transferFrom}.
1771      */
1772     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1773         //solhint-disable-next-line max-line-length
1774         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1775 
1776         _transfer(from, to, tokenId);
1777     }
1778 
1779     /**
1780      * @dev See {IERC721-safeTransferFrom}.
1781      */
1782     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1783         safeTransferFrom(from, to, tokenId, "");
1784     }
1785 
1786     /**
1787      * @dev See {IERC721-safeTransferFrom}.
1788      */
1789     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public virtual override {
1790         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1791         _safeTransfer(from, to, tokenId, data);
1792     }
1793 
1794     /**
1795      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1796      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1797      *
1798      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1799      *
1800      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1801      * implement alternative mechanisms to perform token transfer, such as signature-based.
1802      *
1803      * Requirements:
1804      *
1805      * - `from` cannot be the zero address.
1806      * - `to` cannot be the zero address.
1807      * - `tokenId` token must exist and be owned by `from`.
1808      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1809      *
1810      * Emits a {Transfer} event.
1811      */
1812     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory data) internal virtual {
1813         _transfer(from, to, tokenId);
1814         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1815     }
1816 
1817     /**
1818      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1819      */
1820     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1821         return _owners[tokenId];
1822     }
1823 
1824     /**
1825      * @dev Returns whether `tokenId` exists.
1826      *
1827      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1828      *
1829      * Tokens start existing when they are minted (`_mint`),
1830      * and stop existing when they are burned (`_burn`).
1831      */
1832     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1833         return _ownerOf(tokenId) != address(0);
1834     }
1835 
1836     /**
1837      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1838      *
1839      * Requirements:
1840      *
1841      * - `tokenId` must exist.
1842      */
1843     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1844         address owner = ERC721.ownerOf(tokenId);
1845         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1846     }
1847 
1848     /**
1849      * @dev Safely mints `tokenId` and transfers it to `to`.
1850      *
1851      * Requirements:
1852      *
1853      * - `tokenId` must not exist.
1854      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1855      *
1856      * Emits a {Transfer} event.
1857      */
1858     function _safeMint(address to, uint256 tokenId) internal virtual {
1859         _safeMint(to, tokenId, "");
1860     }
1861 
1862     /**
1863      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1864      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1865      */
1866     function _safeMint(address to, uint256 tokenId, bytes memory data) internal virtual {
1867         _mint(to, tokenId);
1868         require(
1869             _checkOnERC721Received(address(0), to, tokenId, data),
1870             "ERC721: transfer to non ERC721Receiver implementer"
1871         );
1872     }
1873 
1874     /**
1875      * @dev Mints `tokenId` and transfers it to `to`.
1876      *
1877      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1878      *
1879      * Requirements:
1880      *
1881      * - `tokenId` must not exist.
1882      * - `to` cannot be the zero address.
1883      *
1884      * Emits a {Transfer} event.
1885      */
1886     function _mint(address to, uint256 tokenId) internal virtual {
1887         require(to != address(0), "ERC721: mint to the zero address");
1888         require(!_exists(tokenId), "ERC721: token already minted");
1889 
1890         _beforeTokenTransfer(address(0), to, tokenId, 1);
1891 
1892         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1893         require(!_exists(tokenId), "ERC721: token already minted");
1894 
1895         unchecked {
1896             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1897             // Given that tokens are minted one by one, it is impossible in practice that
1898             // this ever happens. Might change if we allow batch minting.
1899             // The ERC fails to describe this case.
1900             _balances[to] += 1;
1901         }
1902 
1903         _owners[tokenId] = to;
1904 
1905         emit Transfer(address(0), to, tokenId);
1906 
1907         _afterTokenTransfer(address(0), to, tokenId, 1);
1908     }
1909 
1910     /**
1911      * @dev Destroys `tokenId`.
1912      * The approval is cleared when the token is burned.
1913      * This is an internal function that does not check if the sender is authorized to operate on the token.
1914      *
1915      * Requirements:
1916      *
1917      * - `tokenId` must exist.
1918      *
1919      * Emits a {Transfer} event.
1920      */
1921     function _burn(uint256 tokenId) internal virtual {
1922         address owner = ERC721.ownerOf(tokenId);
1923 
1924         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1925 
1926         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1927         owner = ERC721.ownerOf(tokenId);
1928 
1929         // Clear approvals
1930         delete _tokenApprovals[tokenId];
1931 
1932         unchecked {
1933             // Cannot overflow, as that would require more tokens to be burned/transferred
1934             // out than the owner initially received through minting and transferring in.
1935             _balances[owner] -= 1;
1936         }
1937         delete _owners[tokenId];
1938 
1939         emit Transfer(owner, address(0), tokenId);
1940 
1941         _afterTokenTransfer(owner, address(0), tokenId, 1);
1942     }
1943 
1944     /**
1945      * @dev Transfers `tokenId` from `from` to `to`.
1946      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1947      *
1948      * Requirements:
1949      *
1950      * - `to` cannot be the zero address.
1951      * - `tokenId` token must be owned by `from`.
1952      *
1953      * Emits a {Transfer} event.
1954      */
1955     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1956         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1957         require(to != address(0), "ERC721: transfer to the zero address");
1958 
1959         _beforeTokenTransfer(from, to, tokenId, 1);
1960 
1961         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1962         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1963 
1964         // Clear approvals from the previous owner
1965         delete _tokenApprovals[tokenId];
1966 
1967         unchecked {
1968             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1969             // `from`'s balance is the number of token held, which is at least one before the current
1970             // transfer.
1971             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1972             // all 2**256 token ids to be minted, which in practice is impossible.
1973             _balances[from] -= 1;
1974             _balances[to] += 1;
1975         }
1976         _owners[tokenId] = to;
1977 
1978         emit Transfer(from, to, tokenId);
1979 
1980         _afterTokenTransfer(from, to, tokenId, 1);
1981     }
1982 
1983     /**
1984      * @dev Approve `to` to operate on `tokenId`
1985      *
1986      * Emits an {Approval} event.
1987      */
1988     function _approve(address to, uint256 tokenId) internal virtual {
1989         _tokenApprovals[tokenId] = to;
1990         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1991     }
1992 
1993     /**
1994      * @dev Approve `operator` to operate on all of `owner` tokens
1995      *
1996      * Emits an {ApprovalForAll} event.
1997      */
1998     function _setApprovalForAll(address owner, address operator, bool approved) internal virtual {
1999         require(owner != operator, "ERC721: approve to caller");
2000         _operatorApprovals[owner][operator] = approved;
2001         emit ApprovalForAll(owner, operator, approved);
2002     }
2003 
2004     /**
2005      * @dev Reverts if the `tokenId` has not been minted yet.
2006      */
2007     function _requireMinted(uint256 tokenId) internal view virtual {
2008         require(_exists(tokenId), "ERC721: invalid token ID");
2009     }
2010 
2011     /**
2012      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2013      * The call is not executed if the target address is not a contract.
2014      *
2015      * @param from address representing the previous owner of the given token ID
2016      * @param to target address that will receive the tokens
2017      * @param tokenId uint256 ID of the token to be transferred
2018      * @param data bytes optional data to send along with the call
2019      * @return bool whether the call correctly returned the expected magic value
2020      */
2021     function _checkOnERC721Received(
2022         address from,
2023         address to,
2024         uint256 tokenId,
2025         bytes memory data
2026     ) private returns (bool) {
2027         if (to.isContract()) {
2028             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
2029                 return retval == IERC721Receiver.onERC721Received.selector;
2030             } catch (bytes memory reason) {
2031                 if (reason.length == 0) {
2032                     revert("ERC721: transfer to non ERC721Receiver implementer");
2033                 } else {
2034                     /// @solidity memory-safe-assembly
2035                     assembly {
2036                         revert(add(32, reason), mload(reason))
2037                     }
2038                 }
2039             }
2040         } else {
2041             return true;
2042         }
2043     }
2044 
2045     /**
2046      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2047      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2048      *
2049      * Calling conditions:
2050      *
2051      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
2052      * - When `from` is zero, the tokens will be minted for `to`.
2053      * - When `to` is zero, ``from``'s tokens will be burned.
2054      * - `from` and `to` are never both zero.
2055      * - `batchSize` is non-zero.
2056      *
2057      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2058      */
2059     function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2060 
2061     /**
2062      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
2063      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
2064      *
2065      * Calling conditions:
2066      *
2067      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
2068      * - When `from` is zero, the tokens were minted for `to`.
2069      * - When `to` is zero, ``from``'s tokens were burned.
2070      * - `from` and `to` are never both zero.
2071      * - `batchSize` is non-zero.
2072      *
2073      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2074      */
2075     function _afterTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize) internal virtual {}
2076 
2077     /**
2078      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
2079      *
2080      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
2081      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
2082      * that `ownerOf(tokenId)` is `a`.
2083      */
2084     // solhint-disable-next-line func-name-mixedcase
2085     function __unsafe_increaseBalance(address account, uint256 amount) internal {
2086         _balances[account] += amount;
2087     }
2088 }
2089 
2090 // File: contracts/lowGasContract.sol
2091 
2092 
2093 
2094 pragma solidity >=0.7.0 <0.9.0;
2095 
2096 
2097 
2098 
2099 
2100 
2101 
2102 contract AttackGameOfficial is ERC721, Ownable,  ERC2981, RevokableDefaultOperatorFilterer {
2103   using Strings for uint256;
2104   using Counters for Counters.Counter;
2105 
2106   Counters.Counter private supply;
2107 
2108   string public uriPrefix = "";
2109   string public uriSuffix = ".json";
2110   string public hiddenMetadataUri;
2111   
2112   uint256 public cost = 0 ether;
2113   uint256 public maxSupply = 6000;
2114   uint256 public maxMintAmountPerTx = 5;
2115   
2116   bool public paused = true;
2117   bool public revealed = false;
2118 
2119   constructor() ERC721("AttackGame Official", "ATTGO") {
2120     setHiddenMetadataUri("ipfs://QmfAfnhZXzDqYqNSxuf94CzQAgh4GZ6zVM7WmRrUUGqfTA/1.json");
2121   }
2122 
2123   modifier mintCompliance(uint256 _mintAmount) {
2124     require(msg.sender == tx.origin, "Contract minting is not allowed");
2125     require(_mintAmount > 0 && _mintAmount <= maxMintAmountPerTx, "Invalid mint amount");
2126     require(supply.current() + _mintAmount <= maxSupply, "Max supply exceeded");
2127     _;
2128   }
2129 
2130   function totalSupply() public view returns (uint256) {
2131     return supply.current();
2132   }
2133 
2134   function mint(uint256 _mintAmount) public payable mintCompliance(_mintAmount) {
2135     require(!paused, "The contract is paused");
2136     require(msg.value >= cost * _mintAmount, "Insufficient funds");
2137     require(balanceOf(msg.sender) + _mintAmount <= maxMintAmountPerTx, "Can not mint this many");
2138 
2139     _mintLoop(msg.sender, _mintAmount);
2140   }
2141   
2142   function mintForAddress(uint256 _mintAmount, address _receiver) public mintCompliance(_mintAmount) onlyOwner {
2143     _mintLoop(_receiver, _mintAmount);
2144   }
2145 
2146   function walletOfOwner(address _owner)
2147     public
2148     view
2149     returns (uint256[] memory)
2150   {
2151     uint256 ownerTokenCount = balanceOf(_owner);
2152     uint256[] memory ownedTokenIds = new uint256[](ownerTokenCount);
2153     uint256 currentTokenId = 1;
2154     uint256 ownedTokenIndex = 0;
2155 
2156     while (ownedTokenIndex < ownerTokenCount && currentTokenId <= maxSupply) {
2157       address currentTokenOwner = ownerOf(currentTokenId);
2158 
2159       if (currentTokenOwner == _owner) {
2160         ownedTokenIds[ownedTokenIndex] = currentTokenId;
2161 
2162         ownedTokenIndex++;
2163       }
2164 
2165       currentTokenId++;
2166     }
2167 
2168     return ownedTokenIds;
2169   }
2170 
2171   function tokenURI(uint256 _tokenId)
2172     public
2173     view
2174     virtual
2175     override
2176     returns (string memory)
2177   {
2178     require(
2179       _exists(_tokenId),
2180       "ERC721Metadata: URI query for nonexistent token"
2181     );
2182 
2183     if (revealed == false) {
2184       return hiddenMetadataUri;
2185     }
2186 
2187     string memory currentBaseURI = _baseURI();
2188     return bytes(currentBaseURI).length > 0
2189         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
2190         : "";
2191   }
2192 
2193   function setRevealed(bool _state) public onlyOwner {
2194     revealed = _state;
2195   }
2196 
2197   function setCost(uint256 _cost) public onlyOwner {
2198     cost = _cost;
2199   }
2200 
2201   function setMaxMintAmountPerTx(uint256 _maxMintAmountPerTx) public onlyOwner {
2202     maxMintAmountPerTx = _maxMintAmountPerTx;
2203 
2204   }
2205 
2206   function setHiddenMetadataUri(string memory _hiddenMetadataUri) public onlyOwner {
2207     hiddenMetadataUri = _hiddenMetadataUri;
2208   }
2209 
2210   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
2211     uriPrefix = _uriPrefix;
2212   }
2213 
2214   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
2215     uriSuffix = _uriSuffix;
2216   }
2217 
2218   function setPaused(bool _state) public onlyOwner {
2219     paused = _state;
2220   }
2221 
2222   function withdraw() public onlyOwner {
2223     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2224     require(os);
2225   }
2226 
2227   function _mintLoop(address _receiver, uint256 _mintAmount) internal {
2228     for (uint256 i = 0; i < _mintAmount; i++) {
2229       supply.increment();
2230       _safeMint(_receiver, supply.current());
2231     }
2232   }
2233 
2234   function _baseURI() internal view virtual override returns (string memory) {
2235     return uriPrefix;
2236   }
2237 
2238   /// ============ ERC2981 ============
2239    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
2240         return super.supportsInterface(interfaceId);
2241     }
2242 
2243   /// ============ OPERATOR FILTER REGISTRY ============
2244         function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2245         super.setApprovalForAll(operator, approved);
2246     }
2247 
2248         function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2249         super.approve(operator, tokenId);
2250     }
2251 
2252         function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2253         super.transferFrom(from, to, tokenId);
2254     }
2255 
2256         function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2257         super.safeTransferFrom(from, to, tokenId);
2258     }
2259 
2260     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2261         public
2262         override
2263         onlyAllowedOperator(from)
2264     {
2265         super.safeTransferFrom(from, to, tokenId, data);
2266     }
2267 
2268         function owner() public view virtual override(Ownable, UpdatableOperatorFilterer) returns (address) {
2269         return Ownable.owner();
2270     }
2271 }