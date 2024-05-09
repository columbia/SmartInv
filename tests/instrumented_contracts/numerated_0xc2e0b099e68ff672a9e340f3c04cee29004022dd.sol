1 // SPDX-License-Identifier: MIT
2 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/lib/Constants.sol
3 
4 
5 pragma solidity ^0.8.13;
6 
7 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
8 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
9 
10 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
11 
12 
13 pragma solidity ^0.8.13;
14 
15 interface IOperatorFilterRegistry {
16     /**
17      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
18      *         true if supplied registrant address is not registered.
19      */
20     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
21 
22     /**
23      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
24      */
25     function register(address registrant) external;
26 
27     /**
28      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
29      */
30     function registerAndSubscribe(address registrant, address subscription) external;
31 
32     /**
33      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
34      *         address without subscribing.
35      */
36     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
37 
38     /**
39      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
40      *         Note that this does not remove any filtered addresses or codeHashes.
41      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
42      */
43     function unregister(address addr) external;
44 
45     /**
46      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
47      */
48     function updateOperator(address registrant, address operator, bool filtered) external;
49 
50     /**
51      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
52      */
53     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
54 
55     /**
56      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
57      */
58     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
59 
60     /**
61      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
62      */
63     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
64 
65     /**
66      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
67      *         subscription if present.
68      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
69      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
70      *         used.
71      */
72     function subscribe(address registrant, address registrantToSubscribe) external;
73 
74     /**
75      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
76      */
77     function unsubscribe(address registrant, bool copyExistingEntries) external;
78 
79     /**
80      * @notice Get the subscription address of a given registrant, if any.
81      */
82     function subscriptionOf(address addr) external returns (address registrant);
83 
84     /**
85      * @notice Get the set of addresses subscribed to a given registrant.
86      *         Note that order is not guaranteed as updates are made.
87      */
88     function subscribers(address registrant) external returns (address[] memory);
89 
90     /**
91      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
92      *         Note that order is not guaranteed as updates are made.
93      */
94     function subscriberAt(address registrant, uint256 index) external returns (address);
95 
96     /**
97      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
98      */
99     function copyEntriesOf(address registrant, address registrantToCopy) external;
100 
101     /**
102      * @notice Returns true if operator is filtered by a given address or its subscription.
103      */
104     function isOperatorFiltered(address registrant, address operator) external returns (bool);
105 
106     /**
107      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
108      */
109     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
110 
111     /**
112      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
113      */
114     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
115 
116     /**
117      * @notice Returns a list of filtered operators for a given address or its subscription.
118      */
119     function filteredOperators(address addr) external returns (address[] memory);
120 
121     /**
122      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
123      *         Note that order is not guaranteed as updates are made.
124      */
125     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
126 
127     /**
128      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
129      *         its subscription.
130      *         Note that order is not guaranteed as updates are made.
131      */
132     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
133 
134     /**
135      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
136      *         its subscription.
137      *         Note that order is not guaranteed as updates are made.
138      */
139     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
140 
141     /**
142      * @notice Returns true if an address has registered
143      */
144     function isRegistered(address addr) external returns (bool);
145 
146     /**
147      * @dev Convenience method to compute the code hash of an arbitrary contract
148      */
149     function codeHashOf(address addr) external returns (bytes32);
150 }
151 
152 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
153 
154 
155 pragma solidity ^0.8.13;
156 
157 
158 /**
159  * @title  OperatorFilterer
160  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
161  *         registrant's entries in the OperatorFilterRegistry.
162  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
163  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
164  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
165  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
166  *         administration methods on the contract itself to interact with the registry otherwise the subscription
167  *         will be locked to the options set during construction.
168  */
169 
170 abstract contract OperatorFilterer {
171     /// @dev Emitted when an operator is not allowed.
172     error OperatorNotAllowed(address operator);
173 
174     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
175         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
176 
177     /// @dev The constructor that is called when the contract is being deployed.
178     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
179         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
180         // will not revert, but the contract will need to be registered with the registry once it is deployed in
181         // order for the modifier to filter addresses.
182         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
183             if (subscribe) {
184                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
185             } else {
186                 if (subscriptionOrRegistrantToCopy != address(0)) {
187                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
188                 } else {
189                     OPERATOR_FILTER_REGISTRY.register(address(this));
190                 }
191             }
192         }
193     }
194 
195     /**
196      * @dev A helper function to check if an operator is allowed.
197      */
198     modifier onlyAllowedOperator(address from) virtual {
199         // Allow spending tokens from addresses with balance
200         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
201         // from an EOA.
202         if (from != msg.sender) {
203             _checkFilterOperator(msg.sender);
204         }
205         _;
206     }
207 
208     /**
209      * @dev A helper function to check if an operator approval is allowed.
210      */
211     modifier onlyAllowedOperatorApproval(address operator) virtual {
212         _checkFilterOperator(operator);
213         _;
214     }
215 
216     /**
217      * @dev A helper function to check if an operator is allowed.
218      */
219     function _checkFilterOperator(address operator) internal view virtual {
220         // Check registry code length to facilitate testing in environments without a deployed registry.
221         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
222             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
223             // may specify their own OperatorFilterRegistry implementations, which may behave differently
224             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
225                 revert OperatorNotAllowed(operator);
226             }
227         }
228     }
229 }
230 
231 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
232 
233 
234 pragma solidity ^0.8.13;
235 
236 
237 /**
238  * @title  DefaultOperatorFilterer
239  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
240  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
241  *         administration methods on the contract itself to interact with the registry otherwise the subscription
242  *         will be locked to the options set during construction.
243  */
244 
245 abstract contract DefaultOperatorFilterer is OperatorFilterer {
246     /// @dev The constructor that is called when the contract is being deployed.
247     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
248 }
249 
250 // File: @openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol
251 
252 
253 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
254 
255 pragma solidity ^0.8.0;
256 
257 /**
258  * @dev These functions deal with verification of Merkle Trees proofs.
259  *
260  * The proofs can be generated using the JavaScript library
261  * https://github.com/miguelmota/merkletreejs[merkletreejs].
262  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
263  *
264  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
265  */
266 library MerkleProof {
267     /**
268      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
269      * defined by `root`. For this, a `proof` must be provided, containing
270      * sibling hashes on the branch from the leaf to the root of the tree. Each
271      * pair of leaves and each pair of pre-images are assumed to be sorted.
272      */
273     function verify(
274         bytes32[] memory proof,
275         bytes32 root,
276         bytes32 leaf
277     ) internal pure returns (bool) {
278         return processProof(proof, leaf) == root;
279     }
280 
281     /**
282      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
283      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
284      * hash matches the root of the tree. When processing the proof, the pairs
285      * of leafs & pre-images are assumed to be sorted.
286      *
287      * _Available since v4.4._
288      */
289     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
290         bytes32 computedHash = leaf;
291         for (uint256 i = 0; i < proof.length; i++) {
292             bytes32 proofElement = proof[i];
293             if (computedHash <= proofElement) {
294                 // Hash(current computed hash + current element of the proof)
295                 computedHash = _efficientHash(computedHash, proofElement);
296             } else {
297                 // Hash(current element of the proof + current computed hash)
298                 computedHash = _efficientHash(proofElement, computedHash);
299             }
300         }
301         return computedHash;
302     }
303 
304     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
305         assembly {
306             mstore(0x00, a)
307             mstore(0x20, b)
308             value := keccak256(0x00, 0x40)
309         }
310     }
311 }
312 
313 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
314 
315 
316 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
317 
318 pragma solidity ^0.8.0;
319 
320 /**
321  * @dev Contract module that helps prevent reentrant calls to a function.
322  *
323  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
324  * available, which can be applied to functions to make sure there are no nested
325  * (reentrant) calls to them.
326  *
327  * Note that because there is a single `nonReentrant` guard, functions marked as
328  * `nonReentrant` may not call one another. This can be worked around by making
329  * those functions `private`, and then adding `external` `nonReentrant` entry
330  * points to them.
331  *
332  * TIP: If you would like to learn more about reentrancy and alternative ways
333  * to protect against it, check out our blog post
334  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
335  */
336 abstract contract ReentrancyGuard {
337     // Booleans are more expensive than uint256 or any type that takes up a full
338     // word because each write operation emits an extra SLOAD to first read the
339     // slot's contents, replace the bits taken up by the boolean, and then write
340     // back. This is the compiler's defense against contract upgrades and
341     // pointer aliasing, and it cannot be disabled.
342 
343     // The values being non-zero value makes deployment a bit more expensive,
344     // but in exchange the refund on every call to nonReentrant will be lower in
345     // amount. Since refunds are capped to a percentage of the total
346     // transaction's gas, it is best to keep them low in cases like this one, to
347     // increase the likelihood of the full refund coming into effect.
348     uint256 private constant _NOT_ENTERED = 1;
349     uint256 private constant _ENTERED = 2;
350 
351     uint256 private _status;
352 
353     constructor() {
354         _status = _NOT_ENTERED;
355     }
356 
357     /**
358      * @dev Prevents a contract from calling itself, directly or indirectly.
359      * Calling a `nonReentrant` function from another `nonReentrant`
360      * function is not supported. It is possible to prevent this from happening
361      * by making the `nonReentrant` function external, and making it call a
362      * `private` function that does the actual work.
363      */
364     modifier nonReentrant() {
365         _nonReentrantBefore();
366         _;
367         _nonReentrantAfter();
368     }
369 
370     function _nonReentrantBefore() private {
371         // On the first call to nonReentrant, _status will be _NOT_ENTERED
372         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
373 
374         // Any calls to nonReentrant after this point will fail
375         _status = _ENTERED;
376     }
377 
378     function _nonReentrantAfter() private {
379         // By storing the original value once again, a refund is triggered (see
380         // https://eips.ethereum.org/EIPS/eip-2200)
381         _status = _NOT_ENTERED;
382     }
383 }
384 
385 // File: @openzeppelin/contracts/utils/math/Math.sol
386 
387 
388 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
389 
390 pragma solidity ^0.8.0;
391 
392 /**
393  * @dev Standard math utilities missing in the Solidity language.
394  */
395 library Math {
396     enum Rounding {
397         Down, // Toward negative infinity
398         Up, // Toward infinity
399         Zero // Toward zero
400     }
401 
402     /**
403      * @dev Returns the largest of two numbers.
404      */
405     function max(uint256 a, uint256 b) internal pure returns (uint256) {
406         return a > b ? a : b;
407     }
408 
409     /**
410      * @dev Returns the smallest of two numbers.
411      */
412     function min(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a < b ? a : b;
414     }
415 
416     /**
417      * @dev Returns the average of two numbers. The result is rounded towards
418      * zero.
419      */
420     function average(uint256 a, uint256 b) internal pure returns (uint256) {
421         // (a + b) / 2 can overflow.
422         return (a & b) + (a ^ b) / 2;
423     }
424 
425     /**
426      * @dev Returns the ceiling of the division of two numbers.
427      *
428      * This differs from standard division with `/` in that it rounds up instead
429      * of rounding down.
430      */
431     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
432         // (a + b - 1) / b can overflow on addition, so we distribute.
433         return a == 0 ? 0 : (a - 1) / b + 1;
434     }
435 
436     /**
437      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
438      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
439      * with further edits by Uniswap Labs also under MIT license.
440      */
441     function mulDiv(
442         uint256 x,
443         uint256 y,
444         uint256 denominator
445     ) internal pure returns (uint256 result) {
446         unchecked {
447             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
448             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
449             // variables such that product = prod1 * 2^256 + prod0.
450             uint256 prod0; // Least significant 256 bits of the product
451             uint256 prod1; // Most significant 256 bits of the product
452             assembly {
453                 let mm := mulmod(x, y, not(0))
454                 prod0 := mul(x, y)
455                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
456             }
457 
458             // Handle non-overflow cases, 256 by 256 division.
459             if (prod1 == 0) {
460                 return prod0 / denominator;
461             }
462 
463             // Make sure the result is less than 2^256. Also prevents denominator == 0.
464             require(denominator > prod1);
465 
466             ///////////////////////////////////////////////
467             // 512 by 256 division.
468             ///////////////////////////////////////////////
469 
470             // Make division exact by subtracting the remainder from [prod1 prod0].
471             uint256 remainder;
472             assembly {
473                 // Compute remainder using mulmod.
474                 remainder := mulmod(x, y, denominator)
475 
476                 // Subtract 256 bit number from 512 bit number.
477                 prod1 := sub(prod1, gt(remainder, prod0))
478                 prod0 := sub(prod0, remainder)
479             }
480 
481             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
482             // See https://cs.stackexchange.com/q/138556/92363.
483 
484             // Does not overflow because the denominator cannot be zero at this stage in the function.
485             uint256 twos = denominator & (~denominator + 1);
486             assembly {
487                 // Divide denominator by twos.
488                 denominator := div(denominator, twos)
489 
490                 // Divide [prod1 prod0] by twos.
491                 prod0 := div(prod0, twos)
492 
493                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
494                 twos := add(div(sub(0, twos), twos), 1)
495             }
496 
497             // Shift in bits from prod1 into prod0.
498             prod0 |= prod1 * twos;
499 
500             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
501             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
502             // four bits. That is, denominator * inv = 1 mod 2^4.
503             uint256 inverse = (3 * denominator) ^ 2;
504 
505             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
506             // in modular arithmetic, doubling the correct bits in each step.
507             inverse *= 2 - denominator * inverse; // inverse mod 2^8
508             inverse *= 2 - denominator * inverse; // inverse mod 2^16
509             inverse *= 2 - denominator * inverse; // inverse mod 2^32
510             inverse *= 2 - denominator * inverse; // inverse mod 2^64
511             inverse *= 2 - denominator * inverse; // inverse mod 2^128
512             inverse *= 2 - denominator * inverse; // inverse mod 2^256
513 
514             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
515             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
516             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
517             // is no longer required.
518             result = prod0 * inverse;
519             return result;
520         }
521     }
522 
523     /**
524      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
525      */
526     function mulDiv(
527         uint256 x,
528         uint256 y,
529         uint256 denominator,
530         Rounding rounding
531     ) internal pure returns (uint256) {
532         uint256 result = mulDiv(x, y, denominator);
533         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
534             result += 1;
535         }
536         return result;
537     }
538 
539     /**
540      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
541      *
542      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
543      */
544     function sqrt(uint256 a) internal pure returns (uint256) {
545         if (a == 0) {
546             return 0;
547         }
548 
549         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
550         //
551         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
552         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
553         //
554         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
555         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
556         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
557         //
558         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
559         uint256 result = 1 << (log2(a) >> 1);
560 
561         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
562         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
563         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
564         // into the expected uint128 result.
565         unchecked {
566             result = (result + a / result) >> 1;
567             result = (result + a / result) >> 1;
568             result = (result + a / result) >> 1;
569             result = (result + a / result) >> 1;
570             result = (result + a / result) >> 1;
571             result = (result + a / result) >> 1;
572             result = (result + a / result) >> 1;
573             return min(result, a / result);
574         }
575     }
576 
577     /**
578      * @notice Calculates sqrt(a), following the selected rounding direction.
579      */
580     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
581         unchecked {
582             uint256 result = sqrt(a);
583             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
584         }
585     }
586 
587     /**
588      * @dev Return the log in base 2, rounded down, of a positive value.
589      * Returns 0 if given 0.
590      */
591     function log2(uint256 value) internal pure returns (uint256) {
592         uint256 result = 0;
593         unchecked {
594             if (value >> 128 > 0) {
595                 value >>= 128;
596                 result += 128;
597             }
598             if (value >> 64 > 0) {
599                 value >>= 64;
600                 result += 64;
601             }
602             if (value >> 32 > 0) {
603                 value >>= 32;
604                 result += 32;
605             }
606             if (value >> 16 > 0) {
607                 value >>= 16;
608                 result += 16;
609             }
610             if (value >> 8 > 0) {
611                 value >>= 8;
612                 result += 8;
613             }
614             if (value >> 4 > 0) {
615                 value >>= 4;
616                 result += 4;
617             }
618             if (value >> 2 > 0) {
619                 value >>= 2;
620                 result += 2;
621             }
622             if (value >> 1 > 0) {
623                 result += 1;
624             }
625         }
626         return result;
627     }
628 
629     /**
630      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
631      * Returns 0 if given 0.
632      */
633     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
634         unchecked {
635             uint256 result = log2(value);
636             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
637         }
638     }
639 
640     /**
641      * @dev Return the log in base 10, rounded down, of a positive value.
642      * Returns 0 if given 0.
643      */
644     function log10(uint256 value) internal pure returns (uint256) {
645         uint256 result = 0;
646         unchecked {
647             if (value >= 10**64) {
648                 value /= 10**64;
649                 result += 64;
650             }
651             if (value >= 10**32) {
652                 value /= 10**32;
653                 result += 32;
654             }
655             if (value >= 10**16) {
656                 value /= 10**16;
657                 result += 16;
658             }
659             if (value >= 10**8) {
660                 value /= 10**8;
661                 result += 8;
662             }
663             if (value >= 10**4) {
664                 value /= 10**4;
665                 result += 4;
666             }
667             if (value >= 10**2) {
668                 value /= 10**2;
669                 result += 2;
670             }
671             if (value >= 10**1) {
672                 result += 1;
673             }
674         }
675         return result;
676     }
677 
678     /**
679      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
680      * Returns 0 if given 0.
681      */
682     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
683         unchecked {
684             uint256 result = log10(value);
685             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
686         }
687     }
688 
689     /**
690      * @dev Return the log in base 256, rounded down, of a positive value.
691      * Returns 0 if given 0.
692      *
693      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
694      */
695     function log256(uint256 value) internal pure returns (uint256) {
696         uint256 result = 0;
697         unchecked {
698             if (value >> 128 > 0) {
699                 value >>= 128;
700                 result += 16;
701             }
702             if (value >> 64 > 0) {
703                 value >>= 64;
704                 result += 8;
705             }
706             if (value >> 32 > 0) {
707                 value >>= 32;
708                 result += 4;
709             }
710             if (value >> 16 > 0) {
711                 value >>= 16;
712                 result += 2;
713             }
714             if (value >> 8 > 0) {
715                 result += 1;
716             }
717         }
718         return result;
719     }
720 
721     /**
722      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
723      * Returns 0 if given 0.
724      */
725     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
726         unchecked {
727             uint256 result = log256(value);
728             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
729         }
730     }
731 }
732 
733 // File: @openzeppelin/contracts/utils/Strings.sol
734 
735 
736 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
737 
738 pragma solidity ^0.8.0;
739 
740 
741 /**
742  * @dev String operations.
743  */
744 library Strings {
745     bytes16 private constant _SYMBOLS = "0123456789abcdef";
746     uint8 private constant _ADDRESS_LENGTH = 20;
747 
748     /**
749      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
750      */
751     function toString(uint256 value) internal pure returns (string memory) {
752         unchecked {
753             uint256 length = Math.log10(value) + 1;
754             string memory buffer = new string(length);
755             uint256 ptr;
756             /// @solidity memory-safe-assembly
757             assembly {
758                 ptr := add(buffer, add(32, length))
759             }
760             while (true) {
761                 ptr--;
762                 /// @solidity memory-safe-assembly
763                 assembly {
764                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
765                 }
766                 value /= 10;
767                 if (value == 0) break;
768             }
769             return buffer;
770         }
771     }
772 
773     /**
774      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
775      */
776     function toHexString(uint256 value) internal pure returns (string memory) {
777         unchecked {
778             return toHexString(value, Math.log256(value) + 1);
779         }
780     }
781 
782     /**
783      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
784      */
785     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
786         bytes memory buffer = new bytes(2 * length + 2);
787         buffer[0] = "0";
788         buffer[1] = "x";
789         for (uint256 i = 2 * length + 1; i > 1; --i) {
790             buffer[i] = _SYMBOLS[value & 0xf];
791             value >>= 4;
792         }
793         require(value == 0, "Strings: hex length insufficient");
794         return string(buffer);
795     }
796 
797     /**
798      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
799      */
800     function toHexString(address addr) internal pure returns (string memory) {
801         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
802     }
803 }
804 
805 // File: @openzeppelin/contracts/utils/Context.sol
806 
807 
808 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
809 
810 pragma solidity ^0.8.0;
811 
812 /**
813  * @dev Provides information about the current execution context, including the
814  * sender of the transaction and its data. While these are generally available
815  * via msg.sender and msg.data, they should not be accessed in such a direct
816  * manner, since when dealing with meta-transactions the account sending and
817  * paying for execution may not be the actual sender (as far as an application
818  * is concerned).
819  *
820  * This contract is only required for intermediate, library-like contracts.
821  */
822 abstract contract Context {
823     function _msgSender() internal view virtual returns (address) {
824         return msg.sender;
825     }
826 
827     function _msgData() internal view virtual returns (bytes calldata) {
828         return msg.data;
829     }
830 }
831 
832 // File: @openzeppelin/contracts/access/Ownable.sol
833 
834 
835 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
836 
837 pragma solidity ^0.8.0;
838 
839 
840 /**
841  * @dev Contract module which provides a basic access control mechanism, where
842  * there is an account (an owner) that can be granted exclusive access to
843  * specific functions.
844  *
845  * By default, the owner account will be the one that deploys the contract. This
846  * can later be changed with {transferOwnership}.
847  *
848  * This module is used through inheritance. It will make available the modifier
849  * `onlyOwner`, which can be applied to your functions to restrict their use to
850  * the owner.
851  */
852 abstract contract Ownable is Context {
853     address private _owner;
854 
855     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
856 
857     /**
858      * @dev Initializes the contract setting the deployer as the initial owner.
859      */
860     constructor() {
861         _transferOwnership(_msgSender());
862     }
863 
864     /**
865      * @dev Throws if called by any account other than the owner.
866      */
867     modifier onlyOwner() {
868         _checkOwner();
869         _;
870     }
871 
872     /**
873      * @dev Returns the address of the current owner.
874      */
875     function owner() public view virtual returns (address) {
876         return _owner;
877     }
878 
879     /**
880      * @dev Throws if the sender is not the owner.
881      */
882     function _checkOwner() internal view virtual {
883         require(owner() == _msgSender(), "Ownable: caller is not the owner");
884     }
885 
886     /**
887      * @dev Leaves the contract without owner. It will not be possible to call
888      * `onlyOwner` functions anymore. Can only be called by the current owner.
889      *
890      * NOTE: Renouncing ownership will leave the contract without an owner,
891      * thereby removing any functionality that is only available to the owner.
892      */
893     function renounceOwnership() public virtual onlyOwner {
894         _transferOwnership(address(0));
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Can only be called by the current owner.
900      */
901     function transferOwnership(address newOwner) public virtual onlyOwner {
902         require(newOwner != address(0), "Ownable: new owner is the zero address");
903         _transferOwnership(newOwner);
904     }
905 
906     /**
907      * @dev Transfers ownership of the contract to a new account (`newOwner`).
908      * Internal function without access restriction.
909      */
910     function _transferOwnership(address newOwner) internal virtual {
911         address oldOwner = _owner;
912         _owner = newOwner;
913         emit OwnershipTransferred(oldOwner, newOwner);
914     }
915 }
916 
917 // File: erc721a/contracts/IERC721A.sol
918 
919 
920 // ERC721A Contracts v4.2.3
921 // Creator: Chiru Labs
922 
923 pragma solidity ^0.8.4;
924 
925 /**
926  * @dev Interface of ERC721A.
927  */
928 interface IERC721A {
929     /**
930      * The caller must own the token or be an approved operator.
931      */
932     error ApprovalCallerNotOwnerNorApproved();
933 
934     /**
935      * The token does not exist.
936      */
937     error ApprovalQueryForNonexistentToken();
938 
939     /**
940      * Cannot query the balance for the zero address.
941      */
942     error BalanceQueryForZeroAddress();
943 
944     /**
945      * Cannot mint to the zero address.
946      */
947     error MintToZeroAddress();
948 
949     /**
950      * The quantity of tokens minted must be more than zero.
951      */
952     error MintZeroQuantity();
953 
954     /**
955      * The token does not exist.
956      */
957     error OwnerQueryForNonexistentToken();
958 
959     /**
960      * The caller must own the token or be an approved operator.
961      */
962     error TransferCallerNotOwnerNorApproved();
963 
964     /**
965      * The token must be owned by `from`.
966      */
967     error TransferFromIncorrectOwner();
968 
969     /**
970      * Cannot safely transfer to a contract that does not implement the
971      * ERC721Receiver interface.
972      */
973     error TransferToNonERC721ReceiverImplementer();
974 
975     /**
976      * Cannot transfer to the zero address.
977      */
978     error TransferToZeroAddress();
979 
980     /**
981      * The token does not exist.
982      */
983     error URIQueryForNonexistentToken();
984 
985     /**
986      * The `quantity` minted with ERC2309 exceeds the safety limit.
987      */
988     error MintERC2309QuantityExceedsLimit();
989 
990     /**
991      * The `extraData` cannot be set on an unintialized ownership slot.
992      */
993     error OwnershipNotInitializedForExtraData();
994 
995     // =============================================================
996     //                            STRUCTS
997     // =============================================================
998 
999     struct TokenOwnership {
1000         // The address of the owner.
1001         address addr;
1002         // Stores the start time of ownership with minimal overhead for tokenomics.
1003         uint64 startTimestamp;
1004         // Whether the token has been burned.
1005         bool burned;
1006         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1007         uint24 extraData;
1008     }
1009 
1010     // =============================================================
1011     //                         TOKEN COUNTERS
1012     // =============================================================
1013 
1014     /**
1015      * @dev Returns the total number of tokens in existence.
1016      * Burned tokens will reduce the count.
1017      * To get the total number of tokens minted, please see {_totalMinted}.
1018      */
1019     function totalSupply() external view returns (uint256);
1020 
1021     // =============================================================
1022     //                            IERC165
1023     // =============================================================
1024 
1025     /**
1026      * @dev Returns true if this contract implements the interface defined by
1027      * `interfaceId`. See the corresponding
1028      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1029      * to learn more about how these ids are created.
1030      *
1031      * This function call must use less than 30000 gas.
1032      */
1033     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1034 
1035     // =============================================================
1036     //                            IERC721
1037     // =============================================================
1038 
1039     /**
1040      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1041      */
1042     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1043 
1044     /**
1045      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1046      */
1047     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1048 
1049     /**
1050      * @dev Emitted when `owner` enables or disables
1051      * (`approved`) `operator` to manage all of its assets.
1052      */
1053     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1054 
1055     /**
1056      * @dev Returns the number of tokens in `owner`'s account.
1057      */
1058     function balanceOf(address owner) external view returns (uint256 balance);
1059 
1060     /**
1061      * @dev Returns the owner of the `tokenId` token.
1062      *
1063      * Requirements:
1064      *
1065      * - `tokenId` must exist.
1066      */
1067     function ownerOf(uint256 tokenId) external view returns (address owner);
1068 
1069     /**
1070      * @dev Safely transfers `tokenId` token from `from` to `to`,
1071      * checking first that contract recipients are aware of the ERC721 protocol
1072      * to prevent tokens from being forever locked.
1073      *
1074      * Requirements:
1075      *
1076      * - `from` cannot be the zero address.
1077      * - `to` cannot be the zero address.
1078      * - `tokenId` token must exist and be owned by `from`.
1079      * - If the caller is not `from`, it must be have been allowed to move
1080      * this token by either {approve} or {setApprovalForAll}.
1081      * - If `to` refers to a smart contract, it must implement
1082      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1083      *
1084      * Emits a {Transfer} event.
1085      */
1086     function safeTransferFrom(
1087         address from,
1088         address to,
1089         uint256 tokenId,
1090         bytes calldata data
1091     ) external payable;
1092 
1093     /**
1094      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1095      */
1096     function safeTransferFrom(
1097         address from,
1098         address to,
1099         uint256 tokenId
1100     ) external payable;
1101 
1102     /**
1103      * @dev Transfers `tokenId` from `from` to `to`.
1104      *
1105      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1106      * whenever possible.
1107      *
1108      * Requirements:
1109      *
1110      * - `from` cannot be the zero address.
1111      * - `to` cannot be the zero address.
1112      * - `tokenId` token must be owned by `from`.
1113      * - If the caller is not `from`, it must be approved to move this token
1114      * by either {approve} or {setApprovalForAll}.
1115      *
1116      * Emits a {Transfer} event.
1117      */
1118     function transferFrom(
1119         address from,
1120         address to,
1121         uint256 tokenId
1122     ) external payable;
1123 
1124     /**
1125      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1126      * The approval is cleared when the token is transferred.
1127      *
1128      * Only a single account can be approved at a time, so approving the
1129      * zero address clears previous approvals.
1130      *
1131      * Requirements:
1132      *
1133      * - The caller must own the token or be an approved operator.
1134      * - `tokenId` must exist.
1135      *
1136      * Emits an {Approval} event.
1137      */
1138     function approve(address to, uint256 tokenId) external payable;
1139 
1140     /**
1141      * @dev Approve or remove `operator` as an operator for the caller.
1142      * Operators can call {transferFrom} or {safeTransferFrom}
1143      * for any token owned by the caller.
1144      *
1145      * Requirements:
1146      *
1147      * - The `operator` cannot be the caller.
1148      *
1149      * Emits an {ApprovalForAll} event.
1150      */
1151     function setApprovalForAll(address operator, bool _approved) external;
1152 
1153     /**
1154      * @dev Returns the account approved for `tokenId` token.
1155      *
1156      * Requirements:
1157      *
1158      * - `tokenId` must exist.
1159      */
1160     function getApproved(uint256 tokenId) external view returns (address operator);
1161 
1162     /**
1163      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1164      *
1165      * See {setApprovalForAll}.
1166      */
1167     function isApprovedForAll(address owner, address operator) external view returns (bool);
1168 
1169     // =============================================================
1170     //                        IERC721Metadata
1171     // =============================================================
1172 
1173     /**
1174      * @dev Returns the token collection name.
1175      */
1176     function name() external view returns (string memory);
1177 
1178     /**
1179      * @dev Returns the token collection symbol.
1180      */
1181     function symbol() external view returns (string memory);
1182 
1183     /**
1184      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1185      */
1186     function tokenURI(uint256 tokenId) external view returns (string memory);
1187 
1188     // =============================================================
1189     //                           IERC2309
1190     // =============================================================
1191 
1192     /**
1193      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1194      * (inclusive) is transferred from `from` to `to`, as defined in the
1195      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1196      *
1197      * See {_mintERC2309} for more details.
1198      */
1199     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1200 }
1201 
1202 // File: erc721a/contracts/ERC721A.sol
1203 
1204 
1205 // ERC721A Contracts v4.2.3
1206 // Creator: Chiru Labs
1207 
1208 pragma solidity ^0.8.4;
1209 
1210 
1211 /**
1212  * @dev Interface of ERC721 token receiver.
1213  */
1214 interface ERC721A__IERC721Receiver {
1215     function onERC721Received(
1216         address operator,
1217         address from,
1218         uint256 tokenId,
1219         bytes calldata data
1220     ) external returns (bytes4);
1221 }
1222 
1223 /**
1224  * @title ERC721A
1225  *
1226  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1227  * Non-Fungible Token Standard, including the Metadata extension.
1228  * Optimized for lower gas during batch mints.
1229  *
1230  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1231  * starting from `_startTokenId()`.
1232  *
1233  * Assumptions:
1234  *
1235  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1236  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1237  */
1238 contract ERC721A is IERC721A {
1239     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1240     struct TokenApprovalRef {
1241         address value;
1242     }
1243 
1244     // =============================================================
1245     //                           CONSTANTS
1246     // =============================================================
1247 
1248     // Mask of an entry in packed address data.
1249     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1250 
1251     // The bit position of `numberMinted` in packed address data.
1252     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1253 
1254     // The bit position of `numberBurned` in packed address data.
1255     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1256 
1257     // The bit position of `aux` in packed address data.
1258     uint256 private constant _BITPOS_AUX = 192;
1259 
1260     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1261     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1262 
1263     // The bit position of `startTimestamp` in packed ownership.
1264     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1265 
1266     // The bit mask of the `burned` bit in packed ownership.
1267     uint256 private constant _BITMASK_BURNED = 1 << 224;
1268 
1269     // The bit position of the `nextInitialized` bit in packed ownership.
1270     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1271 
1272     // The bit mask of the `nextInitialized` bit in packed ownership.
1273     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1274 
1275     // The bit position of `extraData` in packed ownership.
1276     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1277 
1278     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1279     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1280 
1281     // The mask of the lower 160 bits for addresses.
1282     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1283 
1284     // The maximum `quantity` that can be minted with {_mintERC2309}.
1285     // This limit is to prevent overflows on the address data entries.
1286     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1287     // is required to cause an overflow, which is unrealistic.
1288     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1289 
1290     // The `Transfer` event signature is given by:
1291     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1292     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1293         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1294 
1295     // =============================================================
1296     //                            STORAGE
1297     // =============================================================
1298 
1299     // The next token ID to be minted.
1300     uint256 private _currentIndex;
1301 
1302     // The number of tokens burned.
1303     uint256 private _burnCounter;
1304 
1305     // Token name
1306     string private _name;
1307 
1308     // Token symbol
1309     string private _symbol;
1310 
1311     // Mapping from token ID to ownership details
1312     // An empty struct value does not necessarily mean the token is unowned.
1313     // See {_packedOwnershipOf} implementation for details.
1314     //
1315     // Bits Layout:
1316     // - [0..159]   `addr`
1317     // - [160..223] `startTimestamp`
1318     // - [224]      `burned`
1319     // - [225]      `nextInitialized`
1320     // - [232..255] `extraData`
1321     mapping(uint256 => uint256) private _packedOwnerships;
1322 
1323     // Mapping owner address to address data.
1324     //
1325     // Bits Layout:
1326     // - [0..63]    `balance`
1327     // - [64..127]  `numberMinted`
1328     // - [128..191] `numberBurned`
1329     // - [192..255] `aux`
1330     mapping(address => uint256) private _packedAddressData;
1331 
1332     // Mapping from token ID to approved address.
1333     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1334 
1335     // Mapping from owner to operator approvals
1336     mapping(address => mapping(address => bool)) private _operatorApprovals;
1337 
1338     // =============================================================
1339     //                          CONSTRUCTOR
1340     // =============================================================
1341 
1342     constructor(string memory name_, string memory symbol_) {
1343         _name = name_;
1344         _symbol = symbol_;
1345         _currentIndex = _startTokenId();
1346     }
1347 
1348     // =============================================================
1349     //                   TOKEN COUNTING OPERATIONS
1350     // =============================================================
1351 
1352     /**
1353      * @dev Returns the starting token ID.
1354      * To change the starting token ID, please override this function.
1355      */
1356     function _startTokenId() internal view virtual returns (uint256) {
1357         return 0;
1358     }
1359 
1360     /**
1361      * @dev Returns the next token ID to be minted.
1362      */
1363     function _nextTokenId() internal view virtual returns (uint256) {
1364         return _currentIndex;
1365     }
1366 
1367     /**
1368      * @dev Returns the total number of tokens in existence.
1369      * Burned tokens will reduce the count.
1370      * To get the total number of tokens minted, please see {_totalMinted}.
1371      */
1372     function totalSupply() public view virtual override returns (uint256) {
1373         // Counter underflow is impossible as _burnCounter cannot be incremented
1374         // more than `_currentIndex - _startTokenId()` times.
1375         unchecked {
1376             return _currentIndex - _burnCounter - _startTokenId();
1377         }
1378     }
1379 
1380     /**
1381      * @dev Returns the total amount of tokens minted in the contract.
1382      */
1383     function _totalMinted() internal view virtual returns (uint256) {
1384         // Counter underflow is impossible as `_currentIndex` does not decrement,
1385         // and it is initialized to `_startTokenId()`.
1386         unchecked {
1387             return _currentIndex - _startTokenId();
1388         }
1389     }
1390 
1391     /**
1392      * @dev Returns the total number of tokens burned.
1393      */
1394     function _totalBurned() internal view virtual returns (uint256) {
1395         return _burnCounter;
1396     }
1397 
1398     // =============================================================
1399     //                    ADDRESS DATA OPERATIONS
1400     // =============================================================
1401 
1402     /**
1403      * @dev Returns the number of tokens in `owner`'s account.
1404      */
1405     function balanceOf(address owner) public view virtual override returns (uint256) {
1406         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1407         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1408     }
1409 
1410     /**
1411      * Returns the number of tokens minted by `owner`.
1412      */
1413     function _numberMinted(address owner) internal view returns (uint256) {
1414         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1415     }
1416 
1417     /**
1418      * Returns the number of tokens burned by or on behalf of `owner`.
1419      */
1420     function _numberBurned(address owner) internal view returns (uint256) {
1421         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1422     }
1423 
1424     /**
1425      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1426      */
1427     function _getAux(address owner) internal view returns (uint64) {
1428         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1429     }
1430 
1431     /**
1432      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1433      * If there are multiple variables, please pack them into a uint64.
1434      */
1435     function _setAux(address owner, uint64 aux) internal virtual {
1436         uint256 packed = _packedAddressData[owner];
1437         uint256 auxCasted;
1438         // Cast `aux` with assembly to avoid redundant masking.
1439         assembly {
1440             auxCasted := aux
1441         }
1442         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1443         _packedAddressData[owner] = packed;
1444     }
1445 
1446     // =============================================================
1447     //                            IERC165
1448     // =============================================================
1449 
1450     /**
1451      * @dev Returns true if this contract implements the interface defined by
1452      * `interfaceId`. See the corresponding
1453      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1454      * to learn more about how these ids are created.
1455      *
1456      * This function call must use less than 30000 gas.
1457      */
1458     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1459         // The interface IDs are constants representing the first 4 bytes
1460         // of the XOR of all function selectors in the interface.
1461         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1462         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1463         return
1464             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1465             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1466             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1467     }
1468 
1469     // =============================================================
1470     //                        IERC721Metadata
1471     // =============================================================
1472 
1473     /**
1474      * @dev Returns the token collection name.
1475      */
1476     function name() public view virtual override returns (string memory) {
1477         return _name;
1478     }
1479 
1480     /**
1481      * @dev Returns the token collection symbol.
1482      */
1483     function symbol() public view virtual override returns (string memory) {
1484         return _symbol;
1485     }
1486 
1487     /**
1488      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1489      */
1490     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1491         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1492 
1493         string memory baseURI = _baseURI();
1494         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1495     }
1496 
1497     /**
1498      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1499      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1500      * by default, it can be overridden in child contracts.
1501      */
1502     function _baseURI() internal view virtual returns (string memory) {
1503         return '';
1504     }
1505 
1506     // =============================================================
1507     //                     OWNERSHIPS OPERATIONS
1508     // =============================================================
1509 
1510     /**
1511      * @dev Returns the owner of the `tokenId` token.
1512      *
1513      * Requirements:
1514      *
1515      * - `tokenId` must exist.
1516      */
1517     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1518         return address(uint160(_packedOwnershipOf(tokenId)));
1519     }
1520 
1521     /**
1522      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1523      * It gradually moves to O(1) as tokens get transferred around over time.
1524      */
1525     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1526         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1527     }
1528 
1529     /**
1530      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1531      */
1532     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1533         return _unpackedOwnership(_packedOwnerships[index]);
1534     }
1535 
1536     /**
1537      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1538      */
1539     function _initializeOwnershipAt(uint256 index) internal virtual {
1540         if (_packedOwnerships[index] == 0) {
1541             _packedOwnerships[index] = _packedOwnershipOf(index);
1542         }
1543     }
1544 
1545     /**
1546      * Returns the packed ownership data of `tokenId`.
1547      */
1548     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1549         uint256 curr = tokenId;
1550 
1551         unchecked {
1552             if (_startTokenId() <= curr)
1553                 if (curr < _currentIndex) {
1554                     uint256 packed = _packedOwnerships[curr];
1555                     // If not burned.
1556                     if (packed & _BITMASK_BURNED == 0) {
1557                         // Invariant:
1558                         // There will always be an initialized ownership slot
1559                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1560                         // before an unintialized ownership slot
1561                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1562                         // Hence, `curr` will not underflow.
1563                         //
1564                         // We can directly compare the packed value.
1565                         // If the address is zero, packed will be zero.
1566                         while (packed == 0) {
1567                             packed = _packedOwnerships[--curr];
1568                         }
1569                         return packed;
1570                     }
1571                 }
1572         }
1573         revert OwnerQueryForNonexistentToken();
1574     }
1575 
1576     /**
1577      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1578      */
1579     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1580         ownership.addr = address(uint160(packed));
1581         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1582         ownership.burned = packed & _BITMASK_BURNED != 0;
1583         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1584     }
1585 
1586     /**
1587      * @dev Packs ownership data into a single uint256.
1588      */
1589     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1590         assembly {
1591             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1592             owner := and(owner, _BITMASK_ADDRESS)
1593             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1594             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1595         }
1596     }
1597 
1598     /**
1599      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1600      */
1601     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1602         // For branchless setting of the `nextInitialized` flag.
1603         assembly {
1604             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1605             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1606         }
1607     }
1608 
1609     // =============================================================
1610     //                      APPROVAL OPERATIONS
1611     // =============================================================
1612 
1613     /**
1614      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1615      * The approval is cleared when the token is transferred.
1616      *
1617      * Only a single account can be approved at a time, so approving the
1618      * zero address clears previous approvals.
1619      *
1620      * Requirements:
1621      *
1622      * - The caller must own the token or be an approved operator.
1623      * - `tokenId` must exist.
1624      *
1625      * Emits an {Approval} event.
1626      */
1627     function approve(address to, uint256 tokenId) public payable virtual override {
1628         address owner = ownerOf(tokenId);
1629 
1630         if (_msgSenderERC721A() != owner)
1631             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1632                 revert ApprovalCallerNotOwnerNorApproved();
1633             }
1634 
1635         _tokenApprovals[tokenId].value = to;
1636         emit Approval(owner, to, tokenId);
1637     }
1638 
1639     /**
1640      * @dev Returns the account approved for `tokenId` token.
1641      *
1642      * Requirements:
1643      *
1644      * - `tokenId` must exist.
1645      */
1646     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1647         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1648 
1649         return _tokenApprovals[tokenId].value;
1650     }
1651 
1652     /**
1653      * @dev Approve or remove `operator` as an operator for the caller.
1654      * Operators can call {transferFrom} or {safeTransferFrom}
1655      * for any token owned by the caller.
1656      *
1657      * Requirements:
1658      *
1659      * - The `operator` cannot be the caller.
1660      *
1661      * Emits an {ApprovalForAll} event.
1662      */
1663     function setApprovalForAll(address operator, bool approved) public virtual override {
1664         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1665         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1666     }
1667 
1668     /**
1669      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1670      *
1671      * See {setApprovalForAll}.
1672      */
1673     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1674         return _operatorApprovals[owner][operator];
1675     }
1676 
1677     /**
1678      * @dev Returns whether `tokenId` exists.
1679      *
1680      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1681      *
1682      * Tokens start existing when they are minted. See {_mint}.
1683      */
1684     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1685         return
1686             _startTokenId() <= tokenId &&
1687             tokenId < _currentIndex && // If within bounds,
1688             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
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
1749         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1750 
1751         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1752 
1753         // The nested ifs save around 20+ gas over a compound boolean condition.
1754         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1755             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1756 
1757         if (to == address(0)) revert TransferToZeroAddress();
1758 
1759         _beforeTokenTransfers(from, to, tokenId, 1);
1760 
1761         // Clear approvals from the previous owner.
1762         assembly {
1763             if approvedAddress {
1764                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1765                 sstore(approvedAddressSlot, 0)
1766             }
1767         }
1768 
1769         // Underflow of the sender's balance is impossible because we check for
1770         // ownership above and the recipient's balance can't realistically overflow.
1771         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1772         unchecked {
1773             // We can directly increment and decrement the balances.
1774             --_packedAddressData[from]; // Updates: `balance -= 1`.
1775             ++_packedAddressData[to]; // Updates: `balance += 1`.
1776 
1777             // Updates:
1778             // - `address` to the next owner.
1779             // - `startTimestamp` to the timestamp of transfering.
1780             // - `burned` to `false`.
1781             // - `nextInitialized` to `true`.
1782             _packedOwnerships[tokenId] = _packOwnershipData(
1783                 to,
1784                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1785             );
1786 
1787             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1788             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1789                 uint256 nextTokenId = tokenId + 1;
1790                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1791                 if (_packedOwnerships[nextTokenId] == 0) {
1792                     // If the next slot is within bounds.
1793                     if (nextTokenId != _currentIndex) {
1794                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1795                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1796                     }
1797                 }
1798             }
1799         }
1800 
1801         emit Transfer(from, to, tokenId);
1802         _afterTokenTransfers(from, to, tokenId, 1);
1803     }
1804 
1805     /**
1806      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1807      */
1808     function safeTransferFrom(
1809         address from,
1810         address to,
1811         uint256 tokenId
1812     ) public payable virtual override {
1813         safeTransferFrom(from, to, tokenId, '');
1814     }
1815 
1816     /**
1817      * @dev Safely transfers `tokenId` token from `from` to `to`.
1818      *
1819      * Requirements:
1820      *
1821      * - `from` cannot be the zero address.
1822      * - `to` cannot be the zero address.
1823      * - `tokenId` token must exist and be owned by `from`.
1824      * - If the caller is not `from`, it must be approved to move this token
1825      * by either {approve} or {setApprovalForAll}.
1826      * - If `to` refers to a smart contract, it must implement
1827      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1828      *
1829      * Emits a {Transfer} event.
1830      */
1831     function safeTransferFrom(
1832         address from,
1833         address to,
1834         uint256 tokenId,
1835         bytes memory _data
1836     ) public payable virtual override {
1837         transferFrom(from, to, tokenId);
1838         if (to.code.length != 0)
1839             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1840                 revert TransferToNonERC721ReceiverImplementer();
1841             }
1842     }
1843 
1844     /**
1845      * @dev Hook that is called before a set of serially-ordered token IDs
1846      * are about to be transferred. This includes minting.
1847      * And also called before burning one token.
1848      *
1849      * `startTokenId` - the first token ID to be transferred.
1850      * `quantity` - the amount to be transferred.
1851      *
1852      * Calling conditions:
1853      *
1854      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1855      * transferred to `to`.
1856      * - When `from` is zero, `tokenId` will be minted for `to`.
1857      * - When `to` is zero, `tokenId` will be burned by `from`.
1858      * - `from` and `to` are never both zero.
1859      */
1860     function _beforeTokenTransfers(
1861         address from,
1862         address to,
1863         uint256 startTokenId,
1864         uint256 quantity
1865     ) internal virtual {}
1866 
1867     /**
1868      * @dev Hook that is called after a set of serially-ordered token IDs
1869      * have been transferred. This includes minting.
1870      * And also called after one token has been burned.
1871      *
1872      * `startTokenId` - the first token ID to be transferred.
1873      * `quantity` - the amount to be transferred.
1874      *
1875      * Calling conditions:
1876      *
1877      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1878      * transferred to `to`.
1879      * - When `from` is zero, `tokenId` has been minted for `to`.
1880      * - When `to` is zero, `tokenId` has been burned by `from`.
1881      * - `from` and `to` are never both zero.
1882      */
1883     function _afterTokenTransfers(
1884         address from,
1885         address to,
1886         uint256 startTokenId,
1887         uint256 quantity
1888     ) internal virtual {}
1889 
1890     /**
1891      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1892      *
1893      * `from` - Previous owner of the given token ID.
1894      * `to` - Target address that will receive the token.
1895      * `tokenId` - Token ID to be transferred.
1896      * `_data` - Optional data to send along with the call.
1897      *
1898      * Returns whether the call correctly returned the expected magic value.
1899      */
1900     function _checkContractOnERC721Received(
1901         address from,
1902         address to,
1903         uint256 tokenId,
1904         bytes memory _data
1905     ) private returns (bool) {
1906         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1907             bytes4 retval
1908         ) {
1909             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1910         } catch (bytes memory reason) {
1911             if (reason.length == 0) {
1912                 revert TransferToNonERC721ReceiverImplementer();
1913             } else {
1914                 assembly {
1915                     revert(add(32, reason), mload(reason))
1916                 }
1917             }
1918         }
1919     }
1920 
1921     // =============================================================
1922     //                        MINT OPERATIONS
1923     // =============================================================
1924 
1925     /**
1926      * @dev Mints `quantity` tokens and transfers them to `to`.
1927      *
1928      * Requirements:
1929      *
1930      * - `to` cannot be the zero address.
1931      * - `quantity` must be greater than 0.
1932      *
1933      * Emits a {Transfer} event for each mint.
1934      */
1935     function _mint(address to, uint256 quantity) internal virtual {
1936         uint256 startTokenId = _currentIndex;
1937         if (quantity == 0) revert MintZeroQuantity();
1938 
1939         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1940 
1941         // Overflows are incredibly unrealistic.
1942         // `balance` and `numberMinted` have a maximum limit of 2**64.
1943         // `tokenId` has a maximum limit of 2**256.
1944         unchecked {
1945             // Updates:
1946             // - `balance += quantity`.
1947             // - `numberMinted += quantity`.
1948             //
1949             // We can directly add to the `balance` and `numberMinted`.
1950             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1951 
1952             // Updates:
1953             // - `address` to the owner.
1954             // - `startTimestamp` to the timestamp of minting.
1955             // - `burned` to `false`.
1956             // - `nextInitialized` to `quantity == 1`.
1957             _packedOwnerships[startTokenId] = _packOwnershipData(
1958                 to,
1959                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1960             );
1961 
1962             uint256 toMasked;
1963             uint256 end = startTokenId + quantity;
1964 
1965             // Use assembly to loop and emit the `Transfer` event for gas savings.
1966             // The duplicated `log4` removes an extra check and reduces stack juggling.
1967             // The assembly, together with the surrounding Solidity code, have been
1968             // delicately arranged to nudge the compiler into producing optimized opcodes.
1969             assembly {
1970                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1971                 toMasked := and(to, _BITMASK_ADDRESS)
1972                 // Emit the `Transfer` event.
1973                 log4(
1974                     0, // Start of data (0, since no data).
1975                     0, // End of data (0, since no data).
1976                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1977                     0, // `address(0)`.
1978                     toMasked, // `to`.
1979                     startTokenId // `tokenId`.
1980                 )
1981 
1982                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1983                 // that overflows uint256 will make the loop run out of gas.
1984                 // The compiler will optimize the `iszero` away for performance.
1985                 for {
1986                     let tokenId := add(startTokenId, 1)
1987                 } iszero(eq(tokenId, end)) {
1988                     tokenId := add(tokenId, 1)
1989                 } {
1990                     // Emit the `Transfer` event. Similar to above.
1991                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1992                 }
1993             }
1994             if (toMasked == 0) revert MintToZeroAddress();
1995 
1996             _currentIndex = end;
1997         }
1998         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1999     }
2000 
2001     /**
2002      * @dev Mints `quantity` tokens and transfers them to `to`.
2003      *
2004      * This function is intended for efficient minting only during contract creation.
2005      *
2006      * It emits only one {ConsecutiveTransfer} as defined in
2007      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2008      * instead of a sequence of {Transfer} event(s).
2009      *
2010      * Calling this function outside of contract creation WILL make your contract
2011      * non-compliant with the ERC721 standard.
2012      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2013      * {ConsecutiveTransfer} event is only permissible during contract creation.
2014      *
2015      * Requirements:
2016      *
2017      * - `to` cannot be the zero address.
2018      * - `quantity` must be greater than 0.
2019      *
2020      * Emits a {ConsecutiveTransfer} event.
2021      */
2022     function _mintERC2309(address to, uint256 quantity) internal virtual {
2023         uint256 startTokenId = _currentIndex;
2024         if (to == address(0)) revert MintToZeroAddress();
2025         if (quantity == 0) revert MintZeroQuantity();
2026         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2027 
2028         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2029 
2030         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2031         unchecked {
2032             // Updates:
2033             // - `balance += quantity`.
2034             // - `numberMinted += quantity`.
2035             //
2036             // We can directly add to the `balance` and `numberMinted`.
2037             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2038 
2039             // Updates:
2040             // - `address` to the owner.
2041             // - `startTimestamp` to the timestamp of minting.
2042             // - `burned` to `false`.
2043             // - `nextInitialized` to `quantity == 1`.
2044             _packedOwnerships[startTokenId] = _packOwnershipData(
2045                 to,
2046                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2047             );
2048 
2049             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2050 
2051             _currentIndex = startTokenId + quantity;
2052         }
2053         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2054     }
2055 
2056     /**
2057      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2058      *
2059      * Requirements:
2060      *
2061      * - If `to` refers to a smart contract, it must implement
2062      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2063      * - `quantity` must be greater than 0.
2064      *
2065      * See {_mint}.
2066      *
2067      * Emits a {Transfer} event for each mint.
2068      */
2069     function _safeMint(
2070         address to,
2071         uint256 quantity,
2072         bytes memory _data
2073     ) internal virtual {
2074         _mint(to, quantity);
2075 
2076         unchecked {
2077             if (to.code.length != 0) {
2078                 uint256 end = _currentIndex;
2079                 uint256 index = end - quantity;
2080                 do {
2081                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2082                         revert TransferToNonERC721ReceiverImplementer();
2083                     }
2084                 } while (index < end);
2085                 // Reentrancy protection.
2086                 if (_currentIndex != end) revert();
2087             }
2088         }
2089     }
2090 
2091     /**
2092      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2093      */
2094     function _safeMint(address to, uint256 quantity) internal virtual {
2095         _safeMint(to, quantity, '');
2096     }
2097 
2098     // =============================================================
2099     //                        BURN OPERATIONS
2100     // =============================================================
2101 
2102     /**
2103      * @dev Equivalent to `_burn(tokenId, false)`.
2104      */
2105     function _burn(uint256 tokenId) internal virtual {
2106         _burn(tokenId, false);
2107     }
2108 
2109     /**
2110      * @dev Destroys `tokenId`.
2111      * The approval is cleared when the token is burned.
2112      *
2113      * Requirements:
2114      *
2115      * - `tokenId` must exist.
2116      *
2117      * Emits a {Transfer} event.
2118      */
2119     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2120         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2121 
2122         address from = address(uint160(prevOwnershipPacked));
2123 
2124         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2125 
2126         if (approvalCheck) {
2127             // The nested ifs save around 20+ gas over a compound boolean condition.
2128             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2129                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2130         }
2131 
2132         _beforeTokenTransfers(from, address(0), tokenId, 1);
2133 
2134         // Clear approvals from the previous owner.
2135         assembly {
2136             if approvedAddress {
2137                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2138                 sstore(approvedAddressSlot, 0)
2139             }
2140         }
2141 
2142         // Underflow of the sender's balance is impossible because we check for
2143         // ownership above and the recipient's balance can't realistically overflow.
2144         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2145         unchecked {
2146             // Updates:
2147             // - `balance -= 1`.
2148             // - `numberBurned += 1`.
2149             //
2150             // We can directly decrement the balance, and increment the number burned.
2151             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2152             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2153 
2154             // Updates:
2155             // - `address` to the last owner.
2156             // - `startTimestamp` to the timestamp of burning.
2157             // - `burned` to `true`.
2158             // - `nextInitialized` to `true`.
2159             _packedOwnerships[tokenId] = _packOwnershipData(
2160                 from,
2161                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2162             );
2163 
2164             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2165             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2166                 uint256 nextTokenId = tokenId + 1;
2167                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2168                 if (_packedOwnerships[nextTokenId] == 0) {
2169                     // If the next slot is within bounds.
2170                     if (nextTokenId != _currentIndex) {
2171                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2172                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2173                     }
2174                 }
2175             }
2176         }
2177 
2178         emit Transfer(from, address(0), tokenId);
2179         _afterTokenTransfers(from, address(0), tokenId, 1);
2180 
2181         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2182         unchecked {
2183             _burnCounter++;
2184         }
2185     }
2186 
2187     // =============================================================
2188     //                     EXTRA DATA OPERATIONS
2189     // =============================================================
2190 
2191     /**
2192      * @dev Directly sets the extra data for the ownership data `index`.
2193      */
2194     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2195         uint256 packed = _packedOwnerships[index];
2196         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2197         uint256 extraDataCasted;
2198         // Cast `extraData` with assembly to avoid redundant masking.
2199         assembly {
2200             extraDataCasted := extraData
2201         }
2202         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2203         _packedOwnerships[index] = packed;
2204     }
2205 
2206     /**
2207      * @dev Called during each token transfer to set the 24bit `extraData` field.
2208      * Intended to be overridden by the cosumer contract.
2209      *
2210      * `previousExtraData` - the value of `extraData` before transfer.
2211      *
2212      * Calling conditions:
2213      *
2214      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2215      * transferred to `to`.
2216      * - When `from` is zero, `tokenId` will be minted for `to`.
2217      * - When `to` is zero, `tokenId` will be burned by `from`.
2218      * - `from` and `to` are never both zero.
2219      */
2220     function _extraData(
2221         address from,
2222         address to,
2223         uint24 previousExtraData
2224     ) internal view virtual returns (uint24) {}
2225 
2226     /**
2227      * @dev Returns the next extra data for the packed ownership data.
2228      * The returned result is shifted into position.
2229      */
2230     function _nextExtraData(
2231         address from,
2232         address to,
2233         uint256 prevOwnershipPacked
2234     ) private view returns (uint256) {
2235         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2236         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2237     }
2238 
2239     // =============================================================
2240     //                       OTHER OPERATIONS
2241     // =============================================================
2242 
2243     /**
2244      * @dev Returns the message sender (defaults to `msg.sender`).
2245      *
2246      * If you are writing GSN compatible contracts, you need to override this function.
2247      */
2248     function _msgSenderERC721A() internal view virtual returns (address) {
2249         return msg.sender;
2250     }
2251 
2252     /**
2253      * @dev Converts a uint256 to its ASCII string decimal representation.
2254      */
2255     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2256         assembly {
2257             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2258             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2259             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2260             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2261             let m := add(mload(0x40), 0xa0)
2262             // Update the free memory pointer to allocate.
2263             mstore(0x40, m)
2264             // Assign the `str` to the end.
2265             str := sub(m, 0x20)
2266             // Zeroize the slot after the string.
2267             mstore(str, 0)
2268 
2269             // Cache the end of the memory to calculate the length later.
2270             let end := str
2271 
2272             // We write the string from rightmost digit to leftmost digit.
2273             // The following is essentially a do-while loop that also handles the zero case.
2274             // prettier-ignore
2275             for { let temp := value } 1 {} {
2276                 str := sub(str, 1)
2277                 // Write the character to the pointer.
2278                 // The ASCII index of the '0' character is 48.
2279                 mstore8(str, add(48, mod(temp, 10)))
2280                 // Keep dividing `temp` until zero.
2281                 temp := div(temp, 10)
2282                 // prettier-ignore
2283                 if iszero(temp) { break }
2284             }
2285 
2286             let length := sub(end, str)
2287             // Move the pointer 32 bytes leftwards to make room for the length.
2288             str := sub(str, 0x20)
2289             // Store the length.
2290             mstore(str, length)
2291         }
2292     }
2293 }
2294 
2295 // File: contracts/mario.sol
2296 
2297 
2298 pragma solidity ^0.8.12;
2299 
2300 
2301 
2302 
2303 
2304 
2305 
2306 contract SuperETHBros is
2307     ERC721A,
2308     DefaultOperatorFilterer,
2309     Ownable,
2310     ReentrancyGuard
2311 {
2312     using Strings for uint256;
2313 
2314     mapping(address => uint256) public ClaimedAllowlist;
2315     mapping(address => uint256) public ClaimedPublic;
2316 
2317     uint256 public constant MAX_SUPPLY = 4444;
2318     uint256 public constant MAX_MINTS_WALLET_ALLOWLIST = 10;
2319     uint256 public constant MAX_MINTS_WALLET_PUBLIC = 10;
2320     uint256 public constant PRICE_ALLOWLIST = 0.003 ether;
2321     uint256 public constant PRICE_PUBLIC = 0.003 ether;
2322     uint256 public FREE_TOKEN_PRICE = 0 ether;
2323     
2324     uint256 public FREE_MINT_LIMIT = 1;
2325 
2326     string private baseURI;
2327     uint256 private _mintedTeam = 0;
2328     bool public TeamMinted = false;
2329     bytes32 public root;
2330     bool public AllowlistPaused = true;
2331     bool public paused = true;
2332 
2333 
2334    constructor(
2335     string memory _tokenName,
2336     string memory _tokenSymbol
2337   ) ERC721A(_tokenName, _tokenSymbol) {
2338     
2339   }
2340 
2341  modifier callerIsUser() {
2342     require(tx.origin == msg.sender, "The caller is another contract");
2343     _;
2344   }
2345 
2346     function AllowlistMint(
2347         uint256 amount,
2348         bytes32[] memory proof
2349     ) public payable nonReentrant {
2350         require(!AllowlistPaused, "Allowlist minting is paused!");
2351         require(
2352             isValid(proof, keccak256(abi.encodePacked(msg.sender))),
2353             'Not a part of Allowlist'
2354         );
2355         require(
2356             msg.value == amount * PRICE_ALLOWLIST,
2357             'Invalid funds provided'
2358         );
2359         require(
2360             amount > 0 && amount <= MAX_MINTS_WALLET_ALLOWLIST,
2361             'Must mint between the min and max.'
2362         );
2363         require(totalSupply() + amount <= MAX_SUPPLY, 'Exceed max supply');
2364         require(
2365             ClaimedAllowlist[msg.sender] + amount <= MAX_MINTS_WALLET_ALLOWLIST,
2366             'Already minted Max Mints Allowlist'
2367         );
2368         ClaimedAllowlist[msg.sender] += amount;
2369         _safeMint(msg.sender, amount);
2370     }
2371 
2372     function PublicMint(uint256 amount) public payable nonReentrant {
2373          require(!paused, "mint is paused!");
2374         require(msg.value == amount * PRICE_PUBLIC, 'Invalid funds provided');
2375         require(
2376             amount > 0 && amount <= MAX_MINTS_WALLET_PUBLIC,
2377             'Must mint between the min and max.'
2378         );
2379         require(totalSupply() + amount <= MAX_SUPPLY, 'Exceed max supply');
2380         require(
2381             ClaimedPublic[msg.sender] + amount <= MAX_MINTS_WALLET_PUBLIC,
2382             'Already minted Max Mints Public'
2383         );
2384         ClaimedPublic[msg.sender] += amount;
2385         _safeMint(msg.sender, amount);
2386     }
2387 
2388     function mintFree() external callerIsUser {
2389         require(!paused, "mint is paused!");
2390         uint256 amount = FREE_MINT_LIMIT;
2391         require(totalSupply() + amount <= MAX_SUPPLY, 'Exceed max supply');
2392        
2393         require(freeTokensRemainingForAddress(msg.sender) >= amount, "Mint limit for user reached");
2394 
2395         _safeMint(msg.sender, amount);
2396 
2397         _setAux(msg.sender, _getAux(msg.sender) + uint64(amount));
2398     }
2399 
2400    function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
2401      uint16 totalSupply = uint16(totalSupply());
2402     require(totalSupply + _mintAmount <= MAX_SUPPLY, "Excedes max supply.");
2403      _safeMint(_receiver , _mintAmount);
2404      delete _mintAmount;
2405      delete _receiver;
2406      delete totalSupply;
2407   }
2408 
2409 
2410    function freeTokensRemainingForAddress(address who) public view returns (uint256) {
2411         
2412          return FREE_MINT_LIMIT - _getAux(who);
2413        
2414     }
2415    function setPaused() external onlyOwner {
2416     paused = !paused;
2417 
2418   }
2419   function setAllowlistPaused() external onlyOwner {
2420     AllowlistPaused = !AllowlistPaused;
2421 
2422   }
2423     function _baseURI() internal view virtual override returns (string memory) {
2424         return baseURI;
2425     }
2426 
2427     function tokenURI(
2428         uint256 _tokenId
2429     ) public view virtual override returns (string memory) {
2430         require(
2431             _exists(_tokenId),
2432             'ERC721Metadata: URI query for nonexistent token'
2433         );
2434         string memory currentBaseURI = _baseURI();
2435         return
2436             bytes(currentBaseURI).length > 0
2437                 ? string(
2438                     abi.encodePacked(
2439                         currentBaseURI,
2440                         _tokenId.toString(),
2441                         '.json'
2442                     )
2443                 )
2444                 : '';
2445     }
2446 
2447     function setBaseUri(string memory _newBaseURI) external onlyOwner {
2448         baseURI = _newBaseURI;
2449     }
2450 
2451     function transferFrom(
2452         address from,
2453         address to,
2454         uint256 tokenId
2455     ) public payable override onlyAllowedOperator(from) {
2456         super.transferFrom(from, to, tokenId);
2457     }
2458 
2459     function safeTransferFrom(
2460         address from,
2461         address to,
2462         uint256 tokenId
2463     ) public payable override onlyAllowedOperator(from) {
2464         super.safeTransferFrom(from, to, tokenId);
2465     }
2466 
2467     function safeTransferFrom(
2468         address from,
2469         address to,
2470         uint256 tokenId,
2471         bytes memory data
2472     ) public payable override onlyAllowedOperator(from) {
2473         super.safeTransferFrom(from, to, tokenId, data);
2474     }
2475 
2476     function isValid(
2477         bytes32[] memory proof,
2478         bytes32 leaf
2479     ) public view returns (bool) {
2480         return MerkleProof.verify(proof, root, leaf);
2481     }
2482 
2483     function setMerkleRoot(bytes32 _root) external onlyOwner {
2484         root = _root;
2485     }
2486 
2487      function withdraw() public onlyOwner nonReentrant {
2488     // This will transfer the remaining contract balance to the owner.
2489     // Do not remove this otherwise you will not be able to withdraw the funds.
2490     // =============================================================================
2491     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2492     require(os);
2493     // =============================================================================
2494   }
2495 
2496     function _startTokenId() internal pure override returns (uint256) {
2497         return 1;
2498     }
2499 }