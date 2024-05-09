1 /**
2          __           .__   .__                      _____  .__           __            
3   ______|  | __ __ __ |  |  |  |    ______   ____  _/ ____\ |  |   __ __ |  | _______   
4  /  ___/|  |/ /|  |  \|  |  |  |   /  ___/  /  _ \ \   __\  |  |  |  |  \|  |/ /\__  \  
5  \___ \ |    < |  |  /|  |__|  |__ \___ \  (  <_> ) |  |    |  |__|  |  /|    <  / __ \_
6 /____  >|__|_ \|____/ |____/|____//____  >  \____/  |__|    |____/|____/ |__|_ \(____  /
7      \/      \/                        \/                                     \/     \/ 
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 
14 pragma solidity ^0.8.13;
15 
16 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
17 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
18 
19 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
20 
21 
22 pragma solidity ^0.8.13;
23 
24 interface IOperatorFilterRegistry {
25     /**
26      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
27      *         true if supplied registrant address is not registered.
28      */
29     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
30 
31     /**
32      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
33      */
34     function register(address registrant) external;
35 
36     /**
37      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
38      */
39     function registerAndSubscribe(address registrant, address subscription) external;
40 
41     /**
42      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
43      *         address without subscribing.
44      */
45     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
46 
47     /**
48      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
49      *         Note that this does not remove any filtered addresses or codeHashes.
50      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
51      */
52     function unregister(address addr) external;
53 
54     /**
55      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
56      */
57     function updateOperator(address registrant, address operator, bool filtered) external;
58 
59     /**
60      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
61      */
62     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
63 
64     /**
65      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
66      */
67     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
68 
69     /**
70      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
71      */
72     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
73 
74     /**
75      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
76      *         subscription if present.
77      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
78      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
79      *         used.
80      */
81     function subscribe(address registrant, address registrantToSubscribe) external;
82 
83     /**
84      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
85      */
86     function unsubscribe(address registrant, bool copyExistingEntries) external;
87 
88     /**
89      * @notice Get the subscription address of a given registrant, if any.
90      */
91     function subscriptionOf(address addr) external returns (address registrant);
92 
93     /**
94      * @notice Get the set of addresses subscribed to a given registrant.
95      *         Note that order is not guaranteed as updates are made.
96      */
97     function subscribers(address registrant) external returns (address[] memory);
98 
99     /**
100      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
101      *         Note that order is not guaranteed as updates are made.
102      */
103     function subscriberAt(address registrant, uint256 index) external returns (address);
104 
105     /**
106      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
107      */
108     function copyEntriesOf(address registrant, address registrantToCopy) external;
109 
110     /**
111      * @notice Returns true if operator is filtered by a given address or its subscription.
112      */
113     function isOperatorFiltered(address registrant, address operator) external returns (bool);
114 
115     /**
116      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
117      */
118     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
119 
120     /**
121      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
122      */
123     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
124 
125     /**
126      * @notice Returns a list of filtered operators for a given address or its subscription.
127      */
128     function filteredOperators(address addr) external returns (address[] memory);
129 
130     /**
131      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
132      *         Note that order is not guaranteed as updates are made.
133      */
134     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
135 
136     /**
137      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
138      *         its subscription.
139      *         Note that order is not guaranteed as updates are made.
140      */
141     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
142 
143     /**
144      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
145      *         its subscription.
146      *         Note that order is not guaranteed as updates are made.
147      */
148     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
149 
150     /**
151      * @notice Returns true if an address has registered
152      */
153     function isRegistered(address addr) external returns (bool);
154 
155     /**
156      * @dev Convenience method to compute the code hash of an arbitrary contract
157      */
158     function codeHashOf(address addr) external returns (bytes32);
159 }
160 
161 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
162 
163 
164 pragma solidity ^0.8.13;
165 
166 
167 /**
168  * @title  OperatorFilterer
169  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
170  *         registrant's entries in the OperatorFilterRegistry.
171  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
172  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
173  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
174  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
175  *         administration methods on the contract itself to interact with the registry otherwise the subscription
176  *         will be locked to the options set during construction.
177  */
178 
179 abstract contract OperatorFilterer {
180     /// @dev Emitted when an operator is not allowed.
181     error OperatorNotAllowed(address operator);
182 
183     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
184         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
185 
186     /// @dev The constructor that is called when the contract is being deployed.
187     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
188         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
189         // will not revert, but the contract will need to be registered with the registry once it is deployed in
190         // order for the modifier to filter addresses.
191         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
192             if (subscribe) {
193                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
194             } else {
195                 if (subscriptionOrRegistrantToCopy != address(0)) {
196                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
197                 } else {
198                     OPERATOR_FILTER_REGISTRY.register(address(this));
199                 }
200             }
201         }
202     }
203 
204     /**
205      * @dev A helper function to check if an operator is allowed.
206      */
207     modifier onlyAllowedOperator(address from) virtual {
208         // Allow spending tokens from addresses with balance
209         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
210         // from an EOA.
211         if (from != msg.sender) {
212             _checkFilterOperator(msg.sender);
213         }
214         _;
215     }
216 
217     /**
218      * @dev A helper function to check if an operator approval is allowed.
219      */
220     modifier onlyAllowedOperatorApproval(address operator) virtual {
221         _checkFilterOperator(operator);
222         _;
223     }
224 
225     /**
226      * @dev A helper function to check if an operator is allowed.
227      */
228     function _checkFilterOperator(address operator) internal view virtual {
229         // Check registry code length to facilitate testing in environments without a deployed registry.
230         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
231             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
232             // may specify their own OperatorFilterRegistry implementations, which may behave differently
233             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
234                 revert OperatorNotAllowed(operator);
235             }
236         }
237     }
238 }
239 
240 // File: https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
241 
242 
243 pragma solidity ^0.8.13;
244 
245 
246 /**
247  * @title  DefaultOperatorFilterer
248  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
249  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
250  *         administration methods on the contract itself to interact with the registry otherwise the subscription
251  *         will be locked to the options set during construction.
252  */
253 
254 abstract contract DefaultOperatorFilterer is OperatorFilterer {
255     /// @dev The constructor that is called when the contract is being deployed.
256     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
257 }
258 
259 // File: @openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol
260 
261 
262 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 /**
267  * @dev These functions deal with verification of Merkle Trees proofs.
268  *
269  * The proofs can be generated using the JavaScript library
270  * https://github.com/miguelmota/merkletreejs[merkletreejs].
271  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
272  *
273  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
274  */
275 library MerkleProof {
276     /**
277      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
278      * defined by `root`. For this, a `proof` must be provided, containing
279      * sibling hashes on the branch from the leaf to the root of the tree. Each
280      * pair of leaves and each pair of pre-images are assumed to be sorted.
281      */
282     function verify(
283         bytes32[] memory proof,
284         bytes32 root,
285         bytes32 leaf
286     ) internal pure returns (bool) {
287         return processProof(proof, leaf) == root;
288     }
289 
290     /**
291      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
292      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
293      * hash matches the root of the tree. When processing the proof, the pairs
294      * of leafs & pre-images are assumed to be sorted.
295      *
296      * _Available since v4.4._
297      */
298     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
299         bytes32 computedHash = leaf;
300         for (uint256 i = 0; i < proof.length; i++) {
301             bytes32 proofElement = proof[i];
302             if (computedHash <= proofElement) {
303                 // Hash(current computed hash + current element of the proof)
304                 computedHash = _efficientHash(computedHash, proofElement);
305             } else {
306                 // Hash(current element of the proof + current computed hash)
307                 computedHash = _efficientHash(proofElement, computedHash);
308             }
309         }
310         return computedHash;
311     }
312 
313     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
314         assembly {
315             mstore(0x00, a)
316             mstore(0x20, b)
317             value := keccak256(0x00, 0x40)
318         }
319     }
320 }
321 
322 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
323 
324 
325 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 /**
330  * @dev Contract module that helps prevent reentrant calls to a function.
331  *
332  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
333  * available, which can be applied to functions to make sure there are no nested
334  * (reentrant) calls to them.
335  *
336  * Note that because there is a single `nonReentrant` guard, functions marked as
337  * `nonReentrant` may not call one another. This can be worked around by making
338  * those functions `private`, and then adding `external` `nonReentrant` entry
339  * points to them.
340  *
341  * TIP: If you would like to learn more about reentrancy and alternative ways
342  * to protect against it, check out our blog post
343  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
344  */
345 abstract contract ReentrancyGuard {
346     // Booleans are more expensive than uint256 or any type that takes up a full
347     // word because each write operation emits an extra SLOAD to first read the
348     // slot's contents, replace the bits taken up by the boolean, and then write
349     // back. This is the compiler's defense against contract upgrades and
350     // pointer aliasing, and it cannot be disabled.
351 
352     // The values being non-zero value makes deployment a bit more expensive,
353     // but in exchange the refund on every call to nonReentrant will be lower in
354     // amount. Since refunds are capped to a percentage of the total
355     // transaction's gas, it is best to keep them low in cases like this one, to
356     // increase the likelihood of the full refund coming into effect.
357     uint256 private constant _NOT_ENTERED = 1;
358     uint256 private constant _ENTERED = 2;
359 
360     uint256 private _status;
361 
362     constructor() {
363         _status = _NOT_ENTERED;
364     }
365 
366     /**
367      * @dev Prevents a contract from calling itself, directly or indirectly.
368      * Calling a `nonReentrant` function from another `nonReentrant`
369      * function is not supported. It is possible to prevent this from happening
370      * by making the `nonReentrant` function external, and making it call a
371      * `private` function that does the actual work.
372      */
373     modifier nonReentrant() {
374         _nonReentrantBefore();
375         _;
376         _nonReentrantAfter();
377     }
378 
379     function _nonReentrantBefore() private {
380         // On the first call to nonReentrant, _status will be _NOT_ENTERED
381         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
382 
383         // Any calls to nonReentrant after this point will fail
384         _status = _ENTERED;
385     }
386 
387     function _nonReentrantAfter() private {
388         // By storing the original value once again, a refund is triggered (see
389         // https://eips.ethereum.org/EIPS/eip-2200)
390         _status = _NOT_ENTERED;
391     }
392 }
393 
394 // File: @openzeppelin/contracts/utils/math/Math.sol
395 
396 
397 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 /**
402  * @dev Standard math utilities missing in the Solidity language.
403  */
404 library Math {
405     enum Rounding {
406         Down, // Toward negative infinity
407         Up, // Toward infinity
408         Zero // Toward zero
409     }
410 
411     /**
412      * @dev Returns the largest of two numbers.
413      */
414     function max(uint256 a, uint256 b) internal pure returns (uint256) {
415         return a > b ? a : b;
416     }
417 
418     /**
419      * @dev Returns the smallest of two numbers.
420      */
421     function min(uint256 a, uint256 b) internal pure returns (uint256) {
422         return a < b ? a : b;
423     }
424 
425     /**
426      * @dev Returns the average of two numbers. The result is rounded towards
427      * zero.
428      */
429     function average(uint256 a, uint256 b) internal pure returns (uint256) {
430         // (a + b) / 2 can overflow.
431         return (a & b) + (a ^ b) / 2;
432     }
433 
434     /**
435      * @dev Returns the ceiling of the division of two numbers.
436      *
437      * This differs from standard division with `/` in that it rounds up instead
438      * of rounding down.
439      */
440     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
441         // (a + b - 1) / b can overflow on addition, so we distribute.
442         return a == 0 ? 0 : (a - 1) / b + 1;
443     }
444 
445     /**
446      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
447      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
448      * with further edits by Uniswap Labs also under MIT license.
449      */
450     function mulDiv(
451         uint256 x,
452         uint256 y,
453         uint256 denominator
454     ) internal pure returns (uint256 result) {
455         unchecked {
456             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
457             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
458             // variables such that product = prod1 * 2^256 + prod0.
459             uint256 prod0; // Least significant 256 bits of the product
460             uint256 prod1; // Most significant 256 bits of the product
461             assembly {
462                 let mm := mulmod(x, y, not(0))
463                 prod0 := mul(x, y)
464                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
465             }
466 
467             // Handle non-overflow cases, 256 by 256 division.
468             if (prod1 == 0) {
469                 return prod0 / denominator;
470             }
471 
472             // Make sure the result is less than 2^256. Also prevents denominator == 0.
473             require(denominator > prod1);
474 
475             ///////////////////////////////////////////////
476             // 512 by 256 division.
477             ///////////////////////////////////////////////
478 
479             // Make division exact by subtracting the remainder from [prod1 prod0].
480             uint256 remainder;
481             assembly {
482                 // Compute remainder using mulmod.
483                 remainder := mulmod(x, y, denominator)
484 
485                 // Subtract 256 bit number from 512 bit number.
486                 prod1 := sub(prod1, gt(remainder, prod0))
487                 prod0 := sub(prod0, remainder)
488             }
489 
490             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
491             // See https://cs.stackexchange.com/q/138556/92363.
492 
493             // Does not overflow because the denominator cannot be zero at this stage in the function.
494             uint256 twos = denominator & (~denominator + 1);
495             assembly {
496                 // Divide denominator by twos.
497                 denominator := div(denominator, twos)
498 
499                 // Divide [prod1 prod0] by twos.
500                 prod0 := div(prod0, twos)
501 
502                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
503                 twos := add(div(sub(0, twos), twos), 1)
504             }
505 
506             // Shift in bits from prod1 into prod0.
507             prod0 |= prod1 * twos;
508 
509             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
510             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
511             // four bits. That is, denominator * inv = 1 mod 2^4.
512             uint256 inverse = (3 * denominator) ^ 2;
513 
514             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
515             // in modular arithmetic, doubling the correct bits in each step.
516             inverse *= 2 - denominator * inverse; // inverse mod 2^8
517             inverse *= 2 - denominator * inverse; // inverse mod 2^16
518             inverse *= 2 - denominator * inverse; // inverse mod 2^32
519             inverse *= 2 - denominator * inverse; // inverse mod 2^64
520             inverse *= 2 - denominator * inverse; // inverse mod 2^128
521             inverse *= 2 - denominator * inverse; // inverse mod 2^256
522 
523             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
524             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
525             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
526             // is no longer required.
527             result = prod0 * inverse;
528             return result;
529         }
530     }
531 
532     /**
533      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
534      */
535     function mulDiv(
536         uint256 x,
537         uint256 y,
538         uint256 denominator,
539         Rounding rounding
540     ) internal pure returns (uint256) {
541         uint256 result = mulDiv(x, y, denominator);
542         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
543             result += 1;
544         }
545         return result;
546     }
547 
548     /**
549      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
550      *
551      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
552      */
553     function sqrt(uint256 a) internal pure returns (uint256) {
554         if (a == 0) {
555             return 0;
556         }
557 
558         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
559         //
560         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
561         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
562         //
563         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
564         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
565         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
566         //
567         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
568         uint256 result = 1 << (log2(a) >> 1);
569 
570         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
571         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
572         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
573         // into the expected uint128 result.
574         unchecked {
575             result = (result + a / result) >> 1;
576             result = (result + a / result) >> 1;
577             result = (result + a / result) >> 1;
578             result = (result + a / result) >> 1;
579             result = (result + a / result) >> 1;
580             result = (result + a / result) >> 1;
581             result = (result + a / result) >> 1;
582             return min(result, a / result);
583         }
584     }
585 
586     /**
587      * @notice Calculates sqrt(a), following the selected rounding direction.
588      */
589     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
590         unchecked {
591             uint256 result = sqrt(a);
592             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
593         }
594     }
595 
596     /**
597      * @dev Return the log in base 2, rounded down, of a positive value.
598      * Returns 0 if given 0.
599      */
600     function log2(uint256 value) internal pure returns (uint256) {
601         uint256 result = 0;
602         unchecked {
603             if (value >> 128 > 0) {
604                 value >>= 128;
605                 result += 128;
606             }
607             if (value >> 64 > 0) {
608                 value >>= 64;
609                 result += 64;
610             }
611             if (value >> 32 > 0) {
612                 value >>= 32;
613                 result += 32;
614             }
615             if (value >> 16 > 0) {
616                 value >>= 16;
617                 result += 16;
618             }
619             if (value >> 8 > 0) {
620                 value >>= 8;
621                 result += 8;
622             }
623             if (value >> 4 > 0) {
624                 value >>= 4;
625                 result += 4;
626             }
627             if (value >> 2 > 0) {
628                 value >>= 2;
629                 result += 2;
630             }
631             if (value >> 1 > 0) {
632                 result += 1;
633             }
634         }
635         return result;
636     }
637 
638     /**
639      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
640      * Returns 0 if given 0.
641      */
642     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
643         unchecked {
644             uint256 result = log2(value);
645             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
646         }
647     }
648 
649     /**
650      * @dev Return the log in base 10, rounded down, of a positive value.
651      * Returns 0 if given 0.
652      */
653     function log10(uint256 value) internal pure returns (uint256) {
654         uint256 result = 0;
655         unchecked {
656             if (value >= 10**64) {
657                 value /= 10**64;
658                 result += 64;
659             }
660             if (value >= 10**32) {
661                 value /= 10**32;
662                 result += 32;
663             }
664             if (value >= 10**16) {
665                 value /= 10**16;
666                 result += 16;
667             }
668             if (value >= 10**8) {
669                 value /= 10**8;
670                 result += 8;
671             }
672             if (value >= 10**4) {
673                 value /= 10**4;
674                 result += 4;
675             }
676             if (value >= 10**2) {
677                 value /= 10**2;
678                 result += 2;
679             }
680             if (value >= 10**1) {
681                 result += 1;
682             }
683         }
684         return result;
685     }
686 
687     /**
688      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
689      * Returns 0 if given 0.
690      */
691     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
692         unchecked {
693             uint256 result = log10(value);
694             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
695         }
696     }
697 
698     /**
699      * @dev Return the log in base 256, rounded down, of a positive value.
700      * Returns 0 if given 0.
701      *
702      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
703      */
704     function log256(uint256 value) internal pure returns (uint256) {
705         uint256 result = 0;
706         unchecked {
707             if (value >> 128 > 0) {
708                 value >>= 128;
709                 result += 16;
710             }
711             if (value >> 64 > 0) {
712                 value >>= 64;
713                 result += 8;
714             }
715             if (value >> 32 > 0) {
716                 value >>= 32;
717                 result += 4;
718             }
719             if (value >> 16 > 0) {
720                 value >>= 16;
721                 result += 2;
722             }
723             if (value >> 8 > 0) {
724                 result += 1;
725             }
726         }
727         return result;
728     }
729 
730     /**
731      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
732      * Returns 0 if given 0.
733      */
734     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
735         unchecked {
736             uint256 result = log256(value);
737             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
738         }
739     }
740 }
741 
742 // File: @openzeppelin/contracts/utils/Strings.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 
750 /**
751  * @dev String operations.
752  */
753 library Strings {
754     bytes16 private constant _SYMBOLS = "0123456789abcdef";
755     uint8 private constant _ADDRESS_LENGTH = 20;
756 
757     /**
758      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
759      */
760     function toString(uint256 value) internal pure returns (string memory) {
761         unchecked {
762             uint256 length = Math.log10(value) + 1;
763             string memory buffer = new string(length);
764             uint256 ptr;
765             /// @solidity memory-safe-assembly
766             assembly {
767                 ptr := add(buffer, add(32, length))
768             }
769             while (true) {
770                 ptr--;
771                 /// @solidity memory-safe-assembly
772                 assembly {
773                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
774                 }
775                 value /= 10;
776                 if (value == 0) break;
777             }
778             return buffer;
779         }
780     }
781 
782     /**
783      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
784      */
785     function toHexString(uint256 value) internal pure returns (string memory) {
786         unchecked {
787             return toHexString(value, Math.log256(value) + 1);
788         }
789     }
790 
791     /**
792      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
793      */
794     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
795         bytes memory buffer = new bytes(2 * length + 2);
796         buffer[0] = "0";
797         buffer[1] = "x";
798         for (uint256 i = 2 * length + 1; i > 1; --i) {
799             buffer[i] = _SYMBOLS[value & 0xf];
800             value >>= 4;
801         }
802         require(value == 0, "Strings: hex length insufficient");
803         return string(buffer);
804     }
805 
806     /**
807      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
808      */
809     function toHexString(address addr) internal pure returns (string memory) {
810         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
811     }
812 }
813 
814 // File: @openzeppelin/contracts/utils/Context.sol
815 
816 
817 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
818 
819 pragma solidity ^0.8.0;
820 
821 /**
822  * @dev Provides information about the current execution context, including the
823  * sender of the transaction and its data. While these are generally available
824  * via msg.sender and msg.data, they should not be accessed in such a direct
825  * manner, since when dealing with meta-transactions the account sending and
826  * paying for execution may not be the actual sender (as far as an application
827  * is concerned).
828  *
829  * This contract is only required for intermediate, library-like contracts.
830  */
831 abstract contract Context {
832     function _msgSender() internal view virtual returns (address) {
833         return msg.sender;
834     }
835 
836     function _msgData() internal view virtual returns (bytes calldata) {
837         return msg.data;
838     }
839 }
840 
841 // File: @openzeppelin/contracts/access/Ownable.sol
842 
843 
844 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
845 
846 pragma solidity ^0.8.0;
847 
848 
849 /**
850  * @dev Contract module which provides a basic access control mechanism, where
851  * there is an account (an owner) that can be granted exclusive access to
852  * specific functions.
853  *
854  * By default, the owner account will be the one that deploys the contract. This
855  * can later be changed with {transferOwnership}.
856  *
857  * This module is used through inheritance. It will make available the modifier
858  * `onlyOwner`, which can be applied to your functions to restrict their use to
859  * the owner.
860  */
861 abstract contract Ownable is Context {
862     address private _owner;
863 
864     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
865 
866     /**
867      * @dev Initializes the contract setting the deployer as the initial owner.
868      */
869     constructor() {
870         _transferOwnership(_msgSender());
871     }
872 
873     /**
874      * @dev Throws if called by any account other than the owner.
875      */
876     modifier onlyOwner() {
877         _checkOwner();
878         _;
879     }
880 
881     /**
882      * @dev Returns the address of the current owner.
883      */
884     function owner() public view virtual returns (address) {
885         return _owner;
886     }
887 
888     /**
889      * @dev Throws if the sender is not the owner.
890      */
891     function _checkOwner() internal view virtual {
892         require(owner() == _msgSender(), "Ownable: caller is not the owner");
893     }
894 
895     /**
896      * @dev Leaves the contract without owner. It will not be possible to call
897      * `onlyOwner` functions anymore. Can only be called by the current owner.
898      *
899      * NOTE: Renouncing ownership will leave the contract without an owner,
900      * thereby removing any functionality that is only available to the owner.
901      */
902     function renounceOwnership() public virtual onlyOwner {
903         _transferOwnership(address(0));
904     }
905 
906     /**
907      * @dev Transfers ownership of the contract to a new account (`newOwner`).
908      * Can only be called by the current owner.
909      */
910     function transferOwnership(address newOwner) public virtual onlyOwner {
911         require(newOwner != address(0), "Ownable: new owner is the zero address");
912         _transferOwnership(newOwner);
913     }
914 
915     /**
916      * @dev Transfers ownership of the contract to a new account (`newOwner`).
917      * Internal function without access restriction.
918      */
919     function _transferOwnership(address newOwner) internal virtual {
920         address oldOwner = _owner;
921         _owner = newOwner;
922         emit OwnershipTransferred(oldOwner, newOwner);
923     }
924 }
925 
926 // File: erc721a/contracts/IERC721A.sol
927 
928 
929 // ERC721A Contracts v4.2.3
930 // Creator: Chiru Labs
931 
932 pragma solidity ^0.8.4;
933 
934 /**
935  * @dev Interface of ERC721A.
936  */
937 interface IERC721A {
938     /**
939      * The caller must own the token or be an approved operator.
940      */
941     error ApprovalCallerNotOwnerNorApproved();
942 
943     /**
944      * The token does not exist.
945      */
946     error ApprovalQueryForNonexistentToken();
947 
948     /**
949      * Cannot query the balance for the zero address.
950      */
951     error BalanceQueryForZeroAddress();
952 
953     /**
954      * Cannot mint to the zero address.
955      */
956     error MintToZeroAddress();
957 
958     /**
959      * The quantity of tokens minted must be more than zero.
960      */
961     error MintZeroQuantity();
962 
963     /**
964      * The token does not exist.
965      */
966     error OwnerQueryForNonexistentToken();
967 
968     /**
969      * The caller must own the token or be an approved operator.
970      */
971     error TransferCallerNotOwnerNorApproved();
972 
973     /**
974      * The token must be owned by `from`.
975      */
976     error TransferFromIncorrectOwner();
977 
978     /**
979      * Cannot safely transfer to a contract that does not implement the
980      * ERC721Receiver interface.
981      */
982     error TransferToNonERC721ReceiverImplementer();
983 
984     /**
985      * Cannot transfer to the zero address.
986      */
987     error TransferToZeroAddress();
988 
989     /**
990      * The token does not exist.
991      */
992     error URIQueryForNonexistentToken();
993 
994     /**
995      * The `quantity` minted with ERC2309 exceeds the safety limit.
996      */
997     error MintERC2309QuantityExceedsLimit();
998 
999     /**
1000      * The `extraData` cannot be set on an unintialized ownership slot.
1001      */
1002     error OwnershipNotInitializedForExtraData();
1003 
1004     // =============================================================
1005     //                            STRUCTS
1006     // =============================================================
1007 
1008     struct TokenOwnership {
1009         // The address of the owner.
1010         address addr;
1011         // Stores the start time of ownership with minimal overhead for tokenomics.
1012         uint64 startTimestamp;
1013         // Whether the token has been burned.
1014         bool burned;
1015         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1016         uint24 extraData;
1017     }
1018 
1019     // =============================================================
1020     //                         TOKEN COUNTERS
1021     // =============================================================
1022 
1023     /**
1024      * @dev Returns the total number of tokens in existence.
1025      * Burned tokens will reduce the count.
1026      * To get the total number of tokens minted, please see {_totalMinted}.
1027      */
1028     function totalSupply() external view returns (uint256);
1029 
1030     // =============================================================
1031     //                            IERC165
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns true if this contract implements the interface defined by
1036      * `interfaceId`. See the corresponding
1037      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1038      * to learn more about how these ids are created.
1039      *
1040      * This function call must use less than 30000 gas.
1041      */
1042     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1043 
1044     // =============================================================
1045     //                            IERC721
1046     // =============================================================
1047 
1048     /**
1049      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1050      */
1051     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1052 
1053     /**
1054      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1055      */
1056     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1057 
1058     /**
1059      * @dev Emitted when `owner` enables or disables
1060      * (`approved`) `operator` to manage all of its assets.
1061      */
1062     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1063 
1064     /**
1065      * @dev Returns the number of tokens in `owner`'s account.
1066      */
1067     function balanceOf(address owner) external view returns (uint256 balance);
1068 
1069     /**
1070      * @dev Returns the owner of the `tokenId` token.
1071      *
1072      * Requirements:
1073      *
1074      * - `tokenId` must exist.
1075      */
1076     function ownerOf(uint256 tokenId) external view returns (address owner);
1077 
1078     /**
1079      * @dev Safely transfers `tokenId` token from `from` to `to`,
1080      * checking first that contract recipients are aware of the ERC721 protocol
1081      * to prevent tokens from being forever locked.
1082      *
1083      * Requirements:
1084      *
1085      * - `from` cannot be the zero address.
1086      * - `to` cannot be the zero address.
1087      * - `tokenId` token must exist and be owned by `from`.
1088      * - If the caller is not `from`, it must be have been allowed to move
1089      * this token by either {approve} or {setApprovalForAll}.
1090      * - If `to` refers to a smart contract, it must implement
1091      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes calldata data
1100     ) external payable;
1101 
1102     /**
1103      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1104      */
1105     function safeTransferFrom(
1106         address from,
1107         address to,
1108         uint256 tokenId
1109     ) external payable;
1110 
1111     /**
1112      * @dev Transfers `tokenId` from `from` to `to`.
1113      *
1114      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1115      * whenever possible.
1116      *
1117      * Requirements:
1118      *
1119      * - `from` cannot be the zero address.
1120      * - `to` cannot be the zero address.
1121      * - `tokenId` token must be owned by `from`.
1122      * - If the caller is not `from`, it must be approved to move this token
1123      * by either {approve} or {setApprovalForAll}.
1124      *
1125      * Emits a {Transfer} event.
1126      */
1127     function transferFrom(
1128         address from,
1129         address to,
1130         uint256 tokenId
1131     ) external payable;
1132 
1133     /**
1134      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1135      * The approval is cleared when the token is transferred.
1136      *
1137      * Only a single account can be approved at a time, so approving the
1138      * zero address clears previous approvals.
1139      *
1140      * Requirements:
1141      *
1142      * - The caller must own the token or be an approved operator.
1143      * - `tokenId` must exist.
1144      *
1145      * Emits an {Approval} event.
1146      */
1147     function approve(address to, uint256 tokenId) external payable;
1148 
1149     /**
1150      * @dev Approve or remove `operator` as an operator for the caller.
1151      * Operators can call {transferFrom} or {safeTransferFrom}
1152      * for any token owned by the caller.
1153      *
1154      * Requirements:
1155      *
1156      * - The `operator` cannot be the caller.
1157      *
1158      * Emits an {ApprovalForAll} event.
1159      */
1160     function setApprovalForAll(address operator, bool _approved) external;
1161 
1162     /**
1163      * @dev Returns the account approved for `tokenId` token.
1164      *
1165      * Requirements:
1166      *
1167      * - `tokenId` must exist.
1168      */
1169     function getApproved(uint256 tokenId) external view returns (address operator);
1170 
1171     /**
1172      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1173      *
1174      * See {setApprovalForAll}.
1175      */
1176     function isApprovedForAll(address owner, address operator) external view returns (bool);
1177 
1178     // =============================================================
1179     //                        IERC721Metadata
1180     // =============================================================
1181 
1182     /**
1183      * @dev Returns the token collection name.
1184      */
1185     function name() external view returns (string memory);
1186 
1187     /**
1188      * @dev Returns the token collection symbol.
1189      */
1190     function symbol() external view returns (string memory);
1191 
1192     /**
1193      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1194      */
1195     function tokenURI(uint256 tokenId) external view returns (string memory);
1196 
1197     // =============================================================
1198     //                           IERC2309
1199     // =============================================================
1200 
1201     /**
1202      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1203      * (inclusive) is transferred from `from` to `to`, as defined in the
1204      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1205      *
1206      * See {_mintERC2309} for more details.
1207      */
1208     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1209 }
1210 
1211 // File: erc721a/contracts/ERC721A.sol
1212 
1213 
1214 // ERC721A Contracts v4.2.3
1215 // Creator: Chiru Labs
1216 
1217 pragma solidity ^0.8.4;
1218 
1219 
1220 /**
1221  * @dev Interface of ERC721 token receiver.
1222  */
1223 interface ERC721A__IERC721Receiver {
1224     function onERC721Received(
1225         address operator,
1226         address from,
1227         uint256 tokenId,
1228         bytes calldata data
1229     ) external returns (bytes4);
1230 }
1231 
1232 /**
1233  * @title ERC721A
1234  *
1235  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1236  * Non-Fungible Token Standard, including the Metadata extension.
1237  * Optimized for lower gas during batch mints.
1238  *
1239  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1240  * starting from `_startTokenId()`.
1241  *
1242  * Assumptions:
1243  *
1244  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1245  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1246  */
1247 contract ERC721A is IERC721A {
1248     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1249     struct TokenApprovalRef {
1250         address value;
1251     }
1252 
1253     // =============================================================
1254     //                           CONSTANTS
1255     // =============================================================
1256 
1257     // Mask of an entry in packed address data.
1258     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1259 
1260     // The bit position of `numberMinted` in packed address data.
1261     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1262 
1263     // The bit position of `numberBurned` in packed address data.
1264     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1265 
1266     // The bit position of `aux` in packed address data.
1267     uint256 private constant _BITPOS_AUX = 192;
1268 
1269     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1270     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1271 
1272     // The bit position of `startTimestamp` in packed ownership.
1273     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1274 
1275     // The bit mask of the `burned` bit in packed ownership.
1276     uint256 private constant _BITMASK_BURNED = 1 << 224;
1277 
1278     // The bit position of the `nextInitialized` bit in packed ownership.
1279     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1280 
1281     // The bit mask of the `nextInitialized` bit in packed ownership.
1282     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1283 
1284     // The bit position of `extraData` in packed ownership.
1285     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1286 
1287     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1288     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1289 
1290     // The mask of the lower 160 bits for addresses.
1291     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1292 
1293     // The maximum `quantity` that can be minted with {_mintERC2309}.
1294     // This limit is to prevent overflows on the address data entries.
1295     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1296     // is required to cause an overflow, which is unrealistic.
1297     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1298 
1299     // The `Transfer` event signature is given by:
1300     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1301     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1302         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1303 
1304     // =============================================================
1305     //                            STORAGE
1306     // =============================================================
1307 
1308     // The next token ID to be minted.
1309     uint256 private _currentIndex;
1310 
1311     // The number of tokens burned.
1312     uint256 private _burnCounter;
1313 
1314     // Token name
1315     string private _name;
1316 
1317     // Token symbol
1318     string private _symbol;
1319 
1320     // Mapping from token ID to ownership details
1321     // An empty struct value does not necessarily mean the token is unowned.
1322     // See {_packedOwnershipOf} implementation for details.
1323     //
1324     // Bits Layout:
1325     // - [0..159]   `addr`
1326     // - [160..223] `startTimestamp`
1327     // - [224]      `burned`
1328     // - [225]      `nextInitialized`
1329     // - [232..255] `extraData`
1330     mapping(uint256 => uint256) private _packedOwnerships;
1331 
1332     // Mapping owner address to address data.
1333     //
1334     // Bits Layout:
1335     // - [0..63]    `balance`
1336     // - [64..127]  `numberMinted`
1337     // - [128..191] `numberBurned`
1338     // - [192..255] `aux`
1339     mapping(address => uint256) private _packedAddressData;
1340 
1341     // Mapping from token ID to approved address.
1342     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1343 
1344     // Mapping from owner to operator approvals
1345     mapping(address => mapping(address => bool)) private _operatorApprovals;
1346 
1347     // =============================================================
1348     //                          CONSTRUCTOR
1349     // =============================================================
1350 
1351     constructor(string memory name_, string memory symbol_) {
1352         _name = name_;
1353         _symbol = symbol_;
1354         _currentIndex = _startTokenId();
1355     }
1356 
1357     // =============================================================
1358     //                   TOKEN COUNTING OPERATIONS
1359     // =============================================================
1360 
1361     /**
1362      * @dev Returns the starting token ID.
1363      * To change the starting token ID, please override this function.
1364      */
1365     function _startTokenId() internal view virtual returns (uint256) {
1366         return 0;
1367     }
1368 
1369     /**
1370      * @dev Returns the next token ID to be minted.
1371      */
1372     function _nextTokenId() internal view virtual returns (uint256) {
1373         return _currentIndex;
1374     }
1375 
1376     /**
1377      * @dev Returns the total number of tokens in existence.
1378      * Burned tokens will reduce the count.
1379      * To get the total number of tokens minted, please see {_totalMinted}.
1380      */
1381     function totalSupply() public view virtual override returns (uint256) {
1382         // Counter underflow is impossible as _burnCounter cannot be incremented
1383         // more than `_currentIndex - _startTokenId()` times.
1384         unchecked {
1385             return _currentIndex - _burnCounter - _startTokenId();
1386         }
1387     }
1388 
1389     /**
1390      * @dev Returns the total amount of tokens minted in the contract.
1391      */
1392     function _totalMinted() internal view virtual returns (uint256) {
1393         // Counter underflow is impossible as `_currentIndex` does not decrement,
1394         // and it is initialized to `_startTokenId()`.
1395         unchecked {
1396             return _currentIndex - _startTokenId();
1397         }
1398     }
1399 
1400     /**
1401      * @dev Returns the total number of tokens burned.
1402      */
1403     function _totalBurned() internal view virtual returns (uint256) {
1404         return _burnCounter;
1405     }
1406 
1407     // =============================================================
1408     //                    ADDRESS DATA OPERATIONS
1409     // =============================================================
1410 
1411     /**
1412      * @dev Returns the number of tokens in `owner`'s account.
1413      */
1414     function balanceOf(address owner) public view virtual override returns (uint256) {
1415         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1416         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1417     }
1418 
1419     /**
1420      * Returns the number of tokens minted by `owner`.
1421      */
1422     function _numberMinted(address owner) internal view returns (uint256) {
1423         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1424     }
1425 
1426     /**
1427      * Returns the number of tokens burned by or on behalf of `owner`.
1428      */
1429     function _numberBurned(address owner) internal view returns (uint256) {
1430         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1431     }
1432 
1433     /**
1434      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1435      */
1436     function _getAux(address owner) internal view returns (uint64) {
1437         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1438     }
1439 
1440     /**
1441      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1442      * If there are multiple variables, please pack them into a uint64.
1443      */
1444     function _setAux(address owner, uint64 aux) internal virtual {
1445         uint256 packed = _packedAddressData[owner];
1446         uint256 auxCasted;
1447         // Cast `aux` with assembly to avoid redundant masking.
1448         assembly {
1449             auxCasted := aux
1450         }
1451         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1452         _packedAddressData[owner] = packed;
1453     }
1454 
1455     // =============================================================
1456     //                            IERC165
1457     // =============================================================
1458 
1459     /**
1460      * @dev Returns true if this contract implements the interface defined by
1461      * `interfaceId`. See the corresponding
1462      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1463      * to learn more about how these ids are created.
1464      *
1465      * This function call must use less than 30000 gas.
1466      */
1467     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1468         // The interface IDs are constants representing the first 4 bytes
1469         // of the XOR of all function selectors in the interface.
1470         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1471         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1472         return
1473             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1474             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1475             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1476     }
1477 
1478     // =============================================================
1479     //                        IERC721Metadata
1480     // =============================================================
1481 
1482     /**
1483      * @dev Returns the token collection name.
1484      */
1485     function name() public view virtual override returns (string memory) {
1486         return _name;
1487     }
1488 
1489     /**
1490      * @dev Returns the token collection symbol.
1491      */
1492     function symbol() public view virtual override returns (string memory) {
1493         return _symbol;
1494     }
1495 
1496     /**
1497      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1498      */
1499     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1500         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1501 
1502         string memory baseURI = _baseURI();
1503         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1504     }
1505 
1506     /**
1507      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1508      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1509      * by default, it can be overridden in child contracts.
1510      */
1511     function _baseURI() internal view virtual returns (string memory) {
1512         return '';
1513     }
1514 
1515     // =============================================================
1516     //                     OWNERSHIPS OPERATIONS
1517     // =============================================================
1518 
1519     /**
1520      * @dev Returns the owner of the `tokenId` token.
1521      *
1522      * Requirements:
1523      *
1524      * - `tokenId` must exist.
1525      */
1526     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1527         return address(uint160(_packedOwnershipOf(tokenId)));
1528     }
1529 
1530     /**
1531      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1532      * It gradually moves to O(1) as tokens get transferred around over time.
1533      */
1534     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1535         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1536     }
1537 
1538     /**
1539      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1540      */
1541     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1542         return _unpackedOwnership(_packedOwnerships[index]);
1543     }
1544 
1545     /**
1546      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1547      */
1548     function _initializeOwnershipAt(uint256 index) internal virtual {
1549         if (_packedOwnerships[index] == 0) {
1550             _packedOwnerships[index] = _packedOwnershipOf(index);
1551         }
1552     }
1553 
1554     /**
1555      * Returns the packed ownership data of `tokenId`.
1556      */
1557     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1558         uint256 curr = tokenId;
1559 
1560         unchecked {
1561             if (_startTokenId() <= curr)
1562                 if (curr < _currentIndex) {
1563                     uint256 packed = _packedOwnerships[curr];
1564                     // If not burned.
1565                     if (packed & _BITMASK_BURNED == 0) {
1566                         // Invariant:
1567                         // There will always be an initialized ownership slot
1568                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1569                         // before an unintialized ownership slot
1570                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1571                         // Hence, `curr` will not underflow.
1572                         //
1573                         // We can directly compare the packed value.
1574                         // If the address is zero, packed will be zero.
1575                         while (packed == 0) {
1576                             packed = _packedOwnerships[--curr];
1577                         }
1578                         return packed;
1579                     }
1580                 }
1581         }
1582         revert OwnerQueryForNonexistentToken();
1583     }
1584 
1585     /**
1586      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1587      */
1588     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1589         ownership.addr = address(uint160(packed));
1590         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1591         ownership.burned = packed & _BITMASK_BURNED != 0;
1592         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1593     }
1594 
1595     /**
1596      * @dev Packs ownership data into a single uint256.
1597      */
1598     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1599         assembly {
1600             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1601             owner := and(owner, _BITMASK_ADDRESS)
1602             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1603             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1604         }
1605     }
1606 
1607     /**
1608      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1609      */
1610     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1611         // For branchless setting of the `nextInitialized` flag.
1612         assembly {
1613             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1614             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1615         }
1616     }
1617 
1618     // =============================================================
1619     //                      APPROVAL OPERATIONS
1620     // =============================================================
1621 
1622     /**
1623      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1624      * The approval is cleared when the token is transferred.
1625      *
1626      * Only a single account can be approved at a time, so approving the
1627      * zero address clears previous approvals.
1628      *
1629      * Requirements:
1630      *
1631      * - The caller must own the token or be an approved operator.
1632      * - `tokenId` must exist.
1633      *
1634      * Emits an {Approval} event.
1635      */
1636     function approve(address to, uint256 tokenId) public payable virtual override {
1637         address owner = ownerOf(tokenId);
1638 
1639         if (_msgSenderERC721A() != owner)
1640             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1641                 revert ApprovalCallerNotOwnerNorApproved();
1642             }
1643 
1644         _tokenApprovals[tokenId].value = to;
1645         emit Approval(owner, to, tokenId);
1646     }
1647 
1648     /**
1649      * @dev Returns the account approved for `tokenId` token.
1650      *
1651      * Requirements:
1652      *
1653      * - `tokenId` must exist.
1654      */
1655     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1656         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1657 
1658         return _tokenApprovals[tokenId].value;
1659     }
1660 
1661     /**
1662      * @dev Approve or remove `operator` as an operator for the caller.
1663      * Operators can call {transferFrom} or {safeTransferFrom}
1664      * for any token owned by the caller.
1665      *
1666      * Requirements:
1667      *
1668      * - The `operator` cannot be the caller.
1669      *
1670      * Emits an {ApprovalForAll} event.
1671      */
1672     function setApprovalForAll(address operator, bool approved) public virtual override {
1673         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1674         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1675     }
1676 
1677     /**
1678      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1679      *
1680      * See {setApprovalForAll}.
1681      */
1682     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1683         return _operatorApprovals[owner][operator];
1684     }
1685 
1686     /**
1687      * @dev Returns whether `tokenId` exists.
1688      *
1689      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1690      *
1691      * Tokens start existing when they are minted. See {_mint}.
1692      */
1693     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1694         return
1695             _startTokenId() <= tokenId &&
1696             tokenId < _currentIndex && // If within bounds,
1697             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1698     }
1699 
1700     /**
1701      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1702      */
1703     function _isSenderApprovedOrOwner(
1704         address approvedAddress,
1705         address owner,
1706         address msgSender
1707     ) private pure returns (bool result) {
1708         assembly {
1709             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1710             owner := and(owner, _BITMASK_ADDRESS)
1711             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1712             msgSender := and(msgSender, _BITMASK_ADDRESS)
1713             // `msgSender == owner || msgSender == approvedAddress`.
1714             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1715         }
1716     }
1717 
1718     /**
1719      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1720      */
1721     function _getApprovedSlotAndAddress(uint256 tokenId)
1722         private
1723         view
1724         returns (uint256 approvedAddressSlot, address approvedAddress)
1725     {
1726         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1727         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1728         assembly {
1729             approvedAddressSlot := tokenApproval.slot
1730             approvedAddress := sload(approvedAddressSlot)
1731         }
1732     }
1733 
1734     // =============================================================
1735     //                      TRANSFER OPERATIONS
1736     // =============================================================
1737 
1738     /**
1739      * @dev Transfers `tokenId` from `from` to `to`.
1740      *
1741      * Requirements:
1742      *
1743      * - `from` cannot be the zero address.
1744      * - `to` cannot be the zero address.
1745      * - `tokenId` token must be owned by `from`.
1746      * - If the caller is not `from`, it must be approved to move this token
1747      * by either {approve} or {setApprovalForAll}.
1748      *
1749      * Emits a {Transfer} event.
1750      */
1751     function transferFrom(
1752         address from,
1753         address to,
1754         uint256 tokenId
1755     ) public payable virtual override {
1756         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1757 
1758         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1759 
1760         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1761 
1762         // The nested ifs save around 20+ gas over a compound boolean condition.
1763         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1764             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1765 
1766         if (to == address(0)) revert TransferToZeroAddress();
1767 
1768         _beforeTokenTransfers(from, to, tokenId, 1);
1769 
1770         // Clear approvals from the previous owner.
1771         assembly {
1772             if approvedAddress {
1773                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1774                 sstore(approvedAddressSlot, 0)
1775             }
1776         }
1777 
1778         // Underflow of the sender's balance is impossible because we check for
1779         // ownership above and the recipient's balance can't realistically overflow.
1780         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1781         unchecked {
1782             // We can directly increment and decrement the balances.
1783             --_packedAddressData[from]; // Updates: `balance -= 1`.
1784             ++_packedAddressData[to]; // Updates: `balance += 1`.
1785 
1786             // Updates:
1787             // - `address` to the next owner.
1788             // - `startTimestamp` to the timestamp of transfering.
1789             // - `burned` to `false`.
1790             // - `nextInitialized` to `true`.
1791             _packedOwnerships[tokenId] = _packOwnershipData(
1792                 to,
1793                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1794             );
1795 
1796             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1797             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1798                 uint256 nextTokenId = tokenId + 1;
1799                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1800                 if (_packedOwnerships[nextTokenId] == 0) {
1801                     // If the next slot is within bounds.
1802                     if (nextTokenId != _currentIndex) {
1803                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1804                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1805                     }
1806                 }
1807             }
1808         }
1809 
1810         emit Transfer(from, to, tokenId);
1811         _afterTokenTransfers(from, to, tokenId, 1);
1812     }
1813 
1814     /**
1815      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1816      */
1817     function safeTransferFrom(
1818         address from,
1819         address to,
1820         uint256 tokenId
1821     ) public payable virtual override {
1822         safeTransferFrom(from, to, tokenId, '');
1823     }
1824 
1825     /**
1826      * @dev Safely transfers `tokenId` token from `from` to `to`.
1827      *
1828      * Requirements:
1829      *
1830      * - `from` cannot be the zero address.
1831      * - `to` cannot be the zero address.
1832      * - `tokenId` token must exist and be owned by `from`.
1833      * - If the caller is not `from`, it must be approved to move this token
1834      * by either {approve} or {setApprovalForAll}.
1835      * - If `to` refers to a smart contract, it must implement
1836      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1837      *
1838      * Emits a {Transfer} event.
1839      */
1840     function safeTransferFrom(
1841         address from,
1842         address to,
1843         uint256 tokenId,
1844         bytes memory _data
1845     ) public payable virtual override {
1846         transferFrom(from, to, tokenId);
1847         if (to.code.length != 0)
1848             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1849                 revert TransferToNonERC721ReceiverImplementer();
1850             }
1851     }
1852 
1853     /**
1854      * @dev Hook that is called before a set of serially-ordered token IDs
1855      * are about to be transferred. This includes minting.
1856      * And also called before burning one token.
1857      *
1858      * `startTokenId` - the first token ID to be transferred.
1859      * `quantity` - the amount to be transferred.
1860      *
1861      * Calling conditions:
1862      *
1863      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1864      * transferred to `to`.
1865      * - When `from` is zero, `tokenId` will be minted for `to`.
1866      * - When `to` is zero, `tokenId` will be burned by `from`.
1867      * - `from` and `to` are never both zero.
1868      */
1869     function _beforeTokenTransfers(
1870         address from,
1871         address to,
1872         uint256 startTokenId,
1873         uint256 quantity
1874     ) internal virtual {}
1875 
1876     /**
1877      * @dev Hook that is called after a set of serially-ordered token IDs
1878      * have been transferred. This includes minting.
1879      * And also called after one token has been burned.
1880      *
1881      * `startTokenId` - the first token ID to be transferred.
1882      * `quantity` - the amount to be transferred.
1883      *
1884      * Calling conditions:
1885      *
1886      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1887      * transferred to `to`.
1888      * - When `from` is zero, `tokenId` has been minted for `to`.
1889      * - When `to` is zero, `tokenId` has been burned by `from`.
1890      * - `from` and `to` are never both zero.
1891      */
1892     function _afterTokenTransfers(
1893         address from,
1894         address to,
1895         uint256 startTokenId,
1896         uint256 quantity
1897     ) internal virtual {}
1898 
1899     /**
1900      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1901      *
1902      * `from` - Previous owner of the given token ID.
1903      * `to` - Target address that will receive the token.
1904      * `tokenId` - Token ID to be transferred.
1905      * `_data` - Optional data to send along with the call.
1906      *
1907      * Returns whether the call correctly returned the expected magic value.
1908      */
1909     function _checkContractOnERC721Received(
1910         address from,
1911         address to,
1912         uint256 tokenId,
1913         bytes memory _data
1914     ) private returns (bool) {
1915         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1916             bytes4 retval
1917         ) {
1918             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1919         } catch (bytes memory reason) {
1920             if (reason.length == 0) {
1921                 revert TransferToNonERC721ReceiverImplementer();
1922             } else {
1923                 assembly {
1924                     revert(add(32, reason), mload(reason))
1925                 }
1926             }
1927         }
1928     }
1929 
1930     // =============================================================
1931     //                        MINT OPERATIONS
1932     // =============================================================
1933 
1934     /**
1935      * @dev Mints `quantity` tokens and transfers them to `to`.
1936      *
1937      * Requirements:
1938      *
1939      * - `to` cannot be the zero address.
1940      * - `quantity` must be greater than 0.
1941      *
1942      * Emits a {Transfer} event for each mint.
1943      */
1944     function _mint(address to, uint256 quantity) internal virtual {
1945         uint256 startTokenId = _currentIndex;
1946         if (quantity == 0) revert MintZeroQuantity();
1947 
1948         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1949 
1950         // Overflows are incredibly unrealistic.
1951         // `balance` and `numberMinted` have a maximum limit of 2**64.
1952         // `tokenId` has a maximum limit of 2**256.
1953         unchecked {
1954             // Updates:
1955             // - `balance += quantity`.
1956             // - `numberMinted += quantity`.
1957             //
1958             // We can directly add to the `balance` and `numberMinted`.
1959             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1960 
1961             // Updates:
1962             // - `address` to the owner.
1963             // - `startTimestamp` to the timestamp of minting.
1964             // - `burned` to `false`.
1965             // - `nextInitialized` to `quantity == 1`.
1966             _packedOwnerships[startTokenId] = _packOwnershipData(
1967                 to,
1968                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1969             );
1970 
1971             uint256 toMasked;
1972             uint256 end = startTokenId + quantity;
1973 
1974             // Use assembly to loop and emit the `Transfer` event for gas savings.
1975             // The duplicated `log4` removes an extra check and reduces stack juggling.
1976             // The assembly, together with the surrounding Solidity code, have been
1977             // delicately arranged to nudge the compiler into producing optimized opcodes.
1978             assembly {
1979                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1980                 toMasked := and(to, _BITMASK_ADDRESS)
1981                 // Emit the `Transfer` event.
1982                 log4(
1983                     0, // Start of data (0, since no data).
1984                     0, // End of data (0, since no data).
1985                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1986                     0, // `address(0)`.
1987                     toMasked, // `to`.
1988                     startTokenId // `tokenId`.
1989                 )
1990 
1991                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1992                 // that overflows uint256 will make the loop run out of gas.
1993                 // The compiler will optimize the `iszero` away for performance.
1994                 for {
1995                     let tokenId := add(startTokenId, 1)
1996                 } iszero(eq(tokenId, end)) {
1997                     tokenId := add(tokenId, 1)
1998                 } {
1999                     // Emit the `Transfer` event. Similar to above.
2000                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2001                 }
2002             }
2003             if (toMasked == 0) revert MintToZeroAddress();
2004 
2005             _currentIndex = end;
2006         }
2007         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2008     }
2009 
2010     /**
2011      * @dev Mints `quantity` tokens and transfers them to `to`.
2012      *
2013      * This function is intended for efficient minting only during contract creation.
2014      *
2015      * It emits only one {ConsecutiveTransfer} as defined in
2016      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2017      * instead of a sequence of {Transfer} event(s).
2018      *
2019      * Calling this function outside of contract creation WILL make your contract
2020      * non-compliant with the ERC721 standard.
2021      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2022      * {ConsecutiveTransfer} event is only permissible during contract creation.
2023      *
2024      * Requirements:
2025      *
2026      * - `to` cannot be the zero address.
2027      * - `quantity` must be greater than 0.
2028      *
2029      * Emits a {ConsecutiveTransfer} event.
2030      */
2031     function _mintERC2309(address to, uint256 quantity) internal virtual {
2032         uint256 startTokenId = _currentIndex;
2033         if (to == address(0)) revert MintToZeroAddress();
2034         if (quantity == 0) revert MintZeroQuantity();
2035         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2036 
2037         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2038 
2039         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2040         unchecked {
2041             // Updates:
2042             // - `balance += quantity`.
2043             // - `numberMinted += quantity`.
2044             //
2045             // We can directly add to the `balance` and `numberMinted`.
2046             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2047 
2048             // Updates:
2049             // - `address` to the owner.
2050             // - `startTimestamp` to the timestamp of minting.
2051             // - `burned` to `false`.
2052             // - `nextInitialized` to `quantity == 1`.
2053             _packedOwnerships[startTokenId] = _packOwnershipData(
2054                 to,
2055                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2056             );
2057 
2058             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2059 
2060             _currentIndex = startTokenId + quantity;
2061         }
2062         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2063     }
2064 
2065     /**
2066      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2067      *
2068      * Requirements:
2069      *
2070      * - If `to` refers to a smart contract, it must implement
2071      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2072      * - `quantity` must be greater than 0.
2073      *
2074      * See {_mint}.
2075      *
2076      * Emits a {Transfer} event for each mint.
2077      */
2078     function _safeMint(
2079         address to,
2080         uint256 quantity,
2081         bytes memory _data
2082     ) internal virtual {
2083         _mint(to, quantity);
2084 
2085         unchecked {
2086             if (to.code.length != 0) {
2087                 uint256 end = _currentIndex;
2088                 uint256 index = end - quantity;
2089                 do {
2090                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2091                         revert TransferToNonERC721ReceiverImplementer();
2092                     }
2093                 } while (index < end);
2094                 // Reentrancy protection.
2095                 if (_currentIndex != end) revert();
2096             }
2097         }
2098     }
2099 
2100     /**
2101      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2102      */
2103     function _safeMint(address to, uint256 quantity) internal virtual {
2104         _safeMint(to, quantity, '');
2105     }
2106 
2107     // =============================================================
2108     //                        BURN OPERATIONS
2109     // =============================================================
2110 
2111     /**
2112      * @dev Equivalent to `_burn(tokenId, false)`.
2113      */
2114     function _burn(uint256 tokenId) internal virtual {
2115         _burn(tokenId, false);
2116     }
2117 
2118     /**
2119      * @dev Destroys `tokenId`.
2120      * The approval is cleared when the token is burned.
2121      *
2122      * Requirements:
2123      *
2124      * - `tokenId` must exist.
2125      *
2126      * Emits a {Transfer} event.
2127      */
2128     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2129         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2130 
2131         address from = address(uint160(prevOwnershipPacked));
2132 
2133         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2134 
2135         if (approvalCheck) {
2136             // The nested ifs save around 20+ gas over a compound boolean condition.
2137             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2138                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2139         }
2140 
2141         _beforeTokenTransfers(from, address(0), tokenId, 1);
2142 
2143         // Clear approvals from the previous owner.
2144         assembly {
2145             if approvedAddress {
2146                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2147                 sstore(approvedAddressSlot, 0)
2148             }
2149         }
2150 
2151         // Underflow of the sender's balance is impossible because we check for
2152         // ownership above and the recipient's balance can't realistically overflow.
2153         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2154         unchecked {
2155             // Updates:
2156             // - `balance -= 1`.
2157             // - `numberBurned += 1`.
2158             //
2159             // We can directly decrement the balance, and increment the number burned.
2160             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2161             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2162 
2163             // Updates:
2164             // - `address` to the last owner.
2165             // - `startTimestamp` to the timestamp of burning.
2166             // - `burned` to `true`.
2167             // - `nextInitialized` to `true`.
2168             _packedOwnerships[tokenId] = _packOwnershipData(
2169                 from,
2170                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2171             );
2172 
2173             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2174             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2175                 uint256 nextTokenId = tokenId + 1;
2176                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2177                 if (_packedOwnerships[nextTokenId] == 0) {
2178                     // If the next slot is within bounds.
2179                     if (nextTokenId != _currentIndex) {
2180                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2181                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2182                     }
2183                 }
2184             }
2185         }
2186 
2187         emit Transfer(from, address(0), tokenId);
2188         _afterTokenTransfers(from, address(0), tokenId, 1);
2189 
2190         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2191         unchecked {
2192             _burnCounter++;
2193         }
2194     }
2195 
2196     // =============================================================
2197     //                     EXTRA DATA OPERATIONS
2198     // =============================================================
2199 
2200     /**
2201      * @dev Directly sets the extra data for the ownership data `index`.
2202      */
2203     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2204         uint256 packed = _packedOwnerships[index];
2205         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2206         uint256 extraDataCasted;
2207         // Cast `extraData` with assembly to avoid redundant masking.
2208         assembly {
2209             extraDataCasted := extraData
2210         }
2211         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2212         _packedOwnerships[index] = packed;
2213     }
2214 
2215     /**
2216      * @dev Called during each token transfer to set the 24bit `extraData` field.
2217      * Intended to be overridden by the cosumer contract.
2218      *
2219      * `previousExtraData` - the value of `extraData` before transfer.
2220      *
2221      * Calling conditions:
2222      *
2223      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2224      * transferred to `to`.
2225      * - When `from` is zero, `tokenId` will be minted for `to`.
2226      * - When `to` is zero, `tokenId` will be burned by `from`.
2227      * - `from` and `to` are never both zero.
2228      */
2229     function _extraData(
2230         address from,
2231         address to,
2232         uint24 previousExtraData
2233     ) internal view virtual returns (uint24) {}
2234 
2235     /**
2236      * @dev Returns the next extra data for the packed ownership data.
2237      * The returned result is shifted into position.
2238      */
2239     function _nextExtraData(
2240         address from,
2241         address to,
2242         uint256 prevOwnershipPacked
2243     ) private view returns (uint256) {
2244         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2245         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2246     }
2247 
2248     // =============================================================
2249     //                       OTHER OPERATIONS
2250     // =============================================================
2251 
2252     /**
2253      * @dev Returns the message sender (defaults to `msg.sender`).
2254      *
2255      * If you are writing GSN compatible contracts, you need to override this function.
2256      */
2257     function _msgSenderERC721A() internal view virtual returns (address) {
2258         return msg.sender;
2259     }
2260 
2261     /**
2262      * @dev Converts a uint256 to its ASCII string decimal representation.
2263      */
2264     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2265         assembly {
2266             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2267             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2268             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2269             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2270             let m := add(mload(0x40), 0xa0)
2271             // Update the free memory pointer to allocate.
2272             mstore(0x40, m)
2273             // Assign the `str` to the end.
2274             str := sub(m, 0x20)
2275             // Zeroize the slot after the string.
2276             mstore(str, 0)
2277 
2278             // Cache the end of the memory to calculate the length later.
2279             let end := str
2280 
2281             // We write the string from rightmost digit to leftmost digit.
2282             // The following is essentially a do-while loop that also handles the zero case.
2283             // prettier-ignore
2284             for { let temp := value } 1 {} {
2285                 str := sub(str, 1)
2286                 // Write the character to the pointer.
2287                 // The ASCII index of the '0' character is 48.
2288                 mstore8(str, add(48, mod(temp, 10)))
2289                 // Keep dividing `temp` until zero.
2290                 temp := div(temp, 10)
2291                 // prettier-ignore
2292                 if iszero(temp) { break }
2293             }
2294 
2295             let length := sub(end, str)
2296             // Move the pointer 32 bytes leftwards to make room for the length.
2297             str := sub(str, 0x20)
2298             // Store the length.
2299             mstore(str, length)
2300         }
2301     }
2302 }
2303 
2304 // File: contracts/mario.sol
2305 
2306 
2307 pragma solidity ^0.8.12;
2308 
2309 
2310 
2311 
2312 
2313 
2314 
2315 contract SkullsOfLuka is
2316     ERC721A,
2317     DefaultOperatorFilterer,
2318     Ownable,
2319     ReentrancyGuard
2320 {
2321     using Strings for uint256;
2322 
2323     mapping(address => uint256) public ClaimedAllowlist;
2324     mapping(address => uint256) public ClaimedPublic;
2325 
2326     uint256 public constant MAX_SUPPLY = 3333;
2327     uint256 public constant MAX_MINTS_WALLET_ALLOWLIST = 1;
2328     uint256 public constant MAX_MINTS_WALLET_PUBLIC = 10;
2329     uint256 public constant PRICE_ALLOWLIST = 0 ether;
2330     uint256 public constant PRICE_PUBLIC = 0.003 ether;
2331     uint256 public FREE_TOKEN_PRICE = 0.000777 ether;
2332     
2333     uint256 public FREE_MINT_LIMIT = 1;
2334 
2335     string private baseURI;
2336     uint256 private _mintedTeam = 0;
2337     bool public TeamMinted = false;
2338     bytes32 public root;
2339     bool public AllowlistPaused = true;
2340     bool public paused = true;
2341 
2342 
2343    constructor(
2344     string memory _tokenName,
2345     string memory _tokenSymbol
2346   ) ERC721A(_tokenName, _tokenSymbol) {
2347     
2348   }
2349 
2350  modifier callerIsUser() {
2351     require(tx.origin == msg.sender, "The caller is another contract");
2352     _;
2353   }
2354 
2355     function AllowlistMint(
2356         uint256 amount,
2357         bytes32[] memory proof
2358     ) public payable nonReentrant {
2359         require(!AllowlistPaused, "Allowlist minting is paused!");
2360         require(
2361             isValid(proof, keccak256(abi.encodePacked(msg.sender))),
2362             'Not a part of Allowlist'
2363         );
2364         require(
2365             msg.value == amount * PRICE_ALLOWLIST,
2366             'Invalid funds provided'
2367         );
2368         require(
2369             amount > 0 && amount <= MAX_MINTS_WALLET_ALLOWLIST,
2370             'Must mint between the min and max.'
2371         );
2372         require(totalSupply() + amount <= MAX_SUPPLY, 'Exceed max supply');
2373         require(
2374             ClaimedAllowlist[msg.sender] + amount <= MAX_MINTS_WALLET_ALLOWLIST,
2375             'Already minted Max Mints Allowlist'
2376         );
2377         ClaimedAllowlist[msg.sender] += amount;
2378         _safeMint(msg.sender, amount);
2379     }
2380 
2381     function PublicMint(uint256 amount) public payable nonReentrant {
2382          require(!paused, "mint is paused!");
2383         require(msg.value == amount * PRICE_PUBLIC, 'Invalid funds provided');
2384         require(
2385             amount > 0 && amount <= MAX_MINTS_WALLET_PUBLIC,
2386             'Must mint between the min and max.'
2387         );
2388         require(totalSupply() + amount <= MAX_SUPPLY, 'Exceed max supply');
2389         require(
2390             ClaimedPublic[msg.sender] + amount <= MAX_MINTS_WALLET_PUBLIC,
2391             'Already minted Max Mints Public'
2392         );
2393         ClaimedPublic[msg.sender] += amount;
2394         _safeMint(msg.sender, amount);
2395     }
2396 
2397     function mintFree() external callerIsUser {
2398         require(!paused, "mint is paused!");
2399         uint256 amount = FREE_MINT_LIMIT;
2400         require(totalSupply() + amount <= MAX_SUPPLY, 'Exceed max supply');
2401        
2402         require(freeTokensRemainingForAddress(msg.sender) >= amount, "Mint limit for user reached");
2403 
2404         _safeMint(msg.sender, amount);
2405 
2406         _setAux(msg.sender, _getAux(msg.sender) + uint64(amount));
2407     }
2408 
2409    function Reserve(uint16 _mintAmount, address _receiver) external onlyOwner {
2410      uint16 totalSupply = uint16(totalSupply());
2411     require(totalSupply + _mintAmount <= MAX_SUPPLY, "Excedes max supply.");
2412      _safeMint(_receiver , _mintAmount);
2413      delete _mintAmount;
2414      delete _receiver;
2415      delete totalSupply;
2416   }
2417 
2418 
2419    function freeTokensRemainingForAddress(address who) public view returns (uint256) {
2420         
2421          return FREE_MINT_LIMIT - _getAux(who);
2422        
2423     }
2424    function setPaused() external onlyOwner {
2425     paused = !paused;
2426 
2427   }
2428   function setAllowlistPaused() external onlyOwner {
2429     AllowlistPaused = !AllowlistPaused;
2430 
2431   }
2432     function _baseURI() internal view virtual override returns (string memory) {
2433         return baseURI;
2434     }
2435 
2436     function tokenURI(
2437         uint256 _tokenId
2438     ) public view virtual override returns (string memory) {
2439         require(
2440             _exists(_tokenId),
2441             'ERC721Metadata: URI query for nonexistent token'
2442         );
2443         string memory currentBaseURI = _baseURI();
2444         return
2445             bytes(currentBaseURI).length > 0
2446                 ? string(
2447                     abi.encodePacked(
2448                         currentBaseURI,
2449                         _tokenId.toString(),
2450                         '.json'
2451                     )
2452                 )
2453                 : '';
2454     }
2455 
2456     function setBaseUri(string memory _newBaseURI) external onlyOwner {
2457         baseURI = _newBaseURI;
2458     }
2459 
2460     function transferFrom(
2461         address from,
2462         address to,
2463         uint256 tokenId
2464     ) public payable override onlyAllowedOperator(from) {
2465         super.transferFrom(from, to, tokenId);
2466     }
2467 
2468     function safeTransferFrom(
2469         address from,
2470         address to,
2471         uint256 tokenId
2472     ) public payable override onlyAllowedOperator(from) {
2473         super.safeTransferFrom(from, to, tokenId);
2474     }
2475 
2476     function safeTransferFrom(
2477         address from,
2478         address to,
2479         uint256 tokenId,
2480         bytes memory data
2481     ) public payable override onlyAllowedOperator(from) {
2482         super.safeTransferFrom(from, to, tokenId, data);
2483     }
2484 
2485     function isValid(
2486         bytes32[] memory proof,
2487         bytes32 leaf
2488     ) public view returns (bool) {
2489         return MerkleProof.verify(proof, root, leaf);
2490     }
2491 
2492     function setMerkleRoot(bytes32 _root) external onlyOwner {
2493         root = _root;
2494     }
2495 
2496      function withdraw() public onlyOwner nonReentrant {
2497     // This will transfer the remaining contract balance to the owner.
2498     // Do not remove this otherwise you will not be able to withdraw the funds.
2499     // =============================================================================
2500     (bool os, ) = payable(owner()).call{value: address(this).balance}('');
2501     require(os);
2502     // =============================================================================
2503   }
2504 
2505     function _startTokenId() internal pure override returns (uint256) {
2506         return 1;
2507     }
2508 }