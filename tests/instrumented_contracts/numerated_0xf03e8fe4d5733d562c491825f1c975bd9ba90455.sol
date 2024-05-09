1 //File： https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/lib/Constants.sol
2 
3 pragma solidity ^0.8.13;
4 
5 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
6 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
7 //File： https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/IOperatorFilterRegistry.sol
8 
9 pragma solidity ^0.8.13;
10 
11 interface IOperatorFilterRegistry {
12     /**
13      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
14      *         true if supplied registrant address is not registered.
15      */
16     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
17 
18     /**
19      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
20      */
21     function register(address registrant) external;
22 
23     /**
24      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
25      */
26     function registerAndSubscribe(address registrant, address subscription) external;
27 
28     /**
29      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
30      *         address without subscribing.
31      */
32     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
33 
34     /**
35      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
36      *         Note that this does not remove any filtered addresses or codeHashes.
37      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
38      */
39     function unregister(address addr) external;
40 
41     /**
42      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
43      */
44     function updateOperator(address registrant, address operator, bool filtered) external;
45 
46     /**
47      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
48      */
49     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
50 
51     /**
52      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
53      */
54     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
55 
56     /**
57      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
58      */
59     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
60 
61     /**
62      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
63      *         subscription if present.
64      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
65      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
66      *         used.
67      */
68     function subscribe(address registrant, address registrantToSubscribe) external;
69 
70     /**
71      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
72      */
73     function unsubscribe(address registrant, bool copyExistingEntries) external;
74 
75     /**
76      * @notice Get the subscription address of a given registrant, if any.
77      */
78     function subscriptionOf(address addr) external returns (address registrant);
79 
80     /**
81      * @notice Get the set of addresses subscribed to a given registrant.
82      *         Note that order is not guaranteed as updates are made.
83      */
84     function subscribers(address registrant) external returns (address[] memory);
85 
86     /**
87      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
88      *         Note that order is not guaranteed as updates are made.
89      */
90     function subscriberAt(address registrant, uint256 index) external returns (address);
91 
92     /**
93      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
94      */
95     function copyEntriesOf(address registrant, address registrantToCopy) external;
96 
97     /**
98      * @notice Returns true if operator is filtered by a given address or its subscription.
99      */
100     function isOperatorFiltered(address registrant, address operator) external returns (bool);
101 
102     /**
103      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
104      */
105     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
106 
107     /**
108      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
109      */
110     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
111 
112     /**
113      * @notice Returns a list of filtered operators for a given address or its subscription.
114      */
115     function filteredOperators(address addr) external returns (address[] memory);
116 
117     /**
118      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
119      *         Note that order is not guaranteed as updates are made.
120      */
121     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
122 
123     /**
124      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
125      *         its subscription.
126      *         Note that order is not guaranteed as updates are made.
127      */
128     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
129 
130     /**
131      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
132      *         its subscription.
133      *         Note that order is not guaranteed as updates are made.
134      */
135     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
136 
137     /**
138      * @notice Returns true if an address has registered
139      */
140     function isRegistered(address addr) external returns (bool);
141 
142     /**
143      * @dev Convenience method to compute the code hash of an arbitrary contract
144      */
145     function codeHashOf(address addr) external returns (bytes32);
146 }
147 //File： https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/OperatorFilterer.sol
148 
149 pragma solidity ^0.8.13;
150 
151 
152 /**
153  * @title  OperatorFilterer
154  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
155  *         registrant's entries in the OperatorFilterRegistry.
156  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
157  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
158  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
159  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
160  *         administration methods on the contract itself to interact with the registry otherwise the subscription
161  *         will be locked to the options set during construction.
162  */
163 
164 abstract contract OperatorFilterer {
165     /// @dev Emitted when an operator is not allowed.
166     error OperatorNotAllowed(address operator);
167 
168     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
169         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
170 
171     /// @dev The constructor that is called when the contract is being deployed.
172     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
173         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
174         // will not revert, but the contract will need to be registered with the registry once it is deployed in
175         // order for the modifier to filter addresses.
176         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
177             if (subscribe) {
178                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
179             } else {
180                 if (subscriptionOrRegistrantToCopy != address(0)) {
181                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
182                 } else {
183                     OPERATOR_FILTER_REGISTRY.register(address(this));
184                 }
185             }
186         }
187     }
188 
189     /**
190      * @dev A helper function to check if an operator is allowed.
191      */
192     modifier onlyAllowedOperator(address from) virtual {
193         // Allow spending tokens from addresses with balance
194         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
195         // from an EOA.
196         if (from != msg.sender) {
197             _checkFilterOperator(msg.sender);
198         }
199         _;
200     }
201 
202     /**
203      * @dev A helper function to check if an operator approval is allowed.
204      */
205     modifier onlyAllowedOperatorApproval(address operator) virtual {
206         _checkFilterOperator(operator);
207         _;
208     }
209 
210     /**
211      * @dev A helper function to check if an operator is allowed.
212      */
213     function _checkFilterOperator(address operator) internal view virtual {
214         // Check registry code length to facilitate testing in environments without a deployed registry.
215         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
216             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
217             // may specify their own OperatorFilterRegistry implementations, which may behave differently
218             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
219                 revert OperatorNotAllowed(operator);
220             }
221         }
222     }
223 }
224 //File： @openzeppelin/contracts@4.5.0/utils/cryptography/MerkleProof.sol
225 
226 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/MerkleProof.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev These functions deal with verification of Merkle Trees proofs.
232  *
233  * The proofs can be generated using the JavaScript library
234  * https://github.com/miguelmota/merkletreejs[merkletreejs].
235  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
236  *
237  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
238  */
239 library MerkleProof {
240     /**
241      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
242      * defined by `root`. For this, a `proof` must be provided, containing
243      * sibling hashes on the branch from the leaf to the root of the tree. Each
244      * pair of leaves and each pair of pre-images are assumed to be sorted.
245      */
246     function verify(
247         bytes32[] memory proof,
248         bytes32 root,
249         bytes32 leaf
250     ) internal pure returns (bool) {
251         return processProof(proof, leaf) == root;
252     }
253 
254     /**
255      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
256      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
257      * hash matches the root of the tree. When processing the proof, the pairs
258      * of leafs & pre-images are assumed to be sorted.
259      *
260      * _Available since v4.4._
261      */
262     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
263         bytes32 computedHash = leaf;
264         for (uint256 i = 0; i < proof.length; i++) {
265             bytes32 proofElement = proof[i];
266             if (computedHash <= proofElement) {
267                 // Hash(current computed hash + current element of the proof)
268                 computedHash = _efficientHash(computedHash, proofElement);
269             } else {
270                 // Hash(current element of the proof + current computed hash)
271                 computedHash = _efficientHash(proofElement, computedHash);
272             }
273         }
274         return computedHash;
275     }
276 
277     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
278         assembly {
279             mstore(0x00, a)
280             mstore(0x20, b)
281             value := keccak256(0x00, 0x40)
282         }
283     }
284 }
285 //File： @openzeppelin/contracts/utils/Counters.sol
286 
287 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
288 
289 pragma solidity ^0.8.0;
290 
291 /**
292  * @title Counters
293  * @author Matt Condon (@shrugs)
294  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
295  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
296  *
297  * Include with `using Counters for Counters.Counter;`
298  */
299 library Counters {
300     struct Counter {
301         // This variable should never be directly accessed by users of the library: interactions must be restricted to
302         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
303         // this feature: see https://github.com/ethereum/solidity/issues/4637
304         uint256 _value; // default: 0
305     }
306 
307     function current(Counter storage counter) internal view returns (uint256) {
308         return counter._value;
309     }
310 
311     function increment(Counter storage counter) internal {
312         unchecked {
313             counter._value += 1;
314         }
315     }
316 
317     function decrement(Counter storage counter) internal {
318         uint256 value = counter._value;
319         require(value > 0, "Counter: decrement overflow");
320         unchecked {
321             counter._value = value - 1;
322         }
323     }
324 
325     function reset(Counter storage counter) internal {
326         counter._value = 0;
327     }
328 }
329 //File： @openzeppelin/contracts/utils/math/Math.sol
330 
331 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
332 
333 pragma solidity ^0.8.0;
334 
335 /**
336  * @dev Standard math utilities missing in the Solidity language.
337  */
338 library Math {
339     enum Rounding {
340         Down, // Toward negative infinity
341         Up, // Toward infinity
342         Zero // Toward zero
343     }
344 
345     /**
346      * @dev Returns the largest of two numbers.
347      */
348     function max(uint256 a, uint256 b) internal pure returns (uint256) {
349         return a > b ? a : b;
350     }
351 
352     /**
353      * @dev Returns the smallest of two numbers.
354      */
355     function min(uint256 a, uint256 b) internal pure returns (uint256) {
356         return a < b ? a : b;
357     }
358 
359     /**
360      * @dev Returns the average of two numbers. The result is rounded towards
361      * zero.
362      */
363     function average(uint256 a, uint256 b) internal pure returns (uint256) {
364         // (a + b) / 2 can overflow.
365         return (a & b) + (a ^ b) / 2;
366     }
367 
368     /**
369      * @dev Returns the ceiling of the division of two numbers.
370      *
371      * This differs from standard division with `/` in that it rounds up instead
372      * of rounding down.
373      */
374     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
375         // (a + b - 1) / b can overflow on addition, so we distribute.
376         return a == 0 ? 0 : (a - 1) / b + 1;
377     }
378 
379     /**
380      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
381      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
382      * with further edits by Uniswap Labs also under MIT license.
383      */
384     function mulDiv(
385         uint256 x,
386         uint256 y,
387         uint256 denominator
388     ) internal pure returns (uint256 result) {
389         unchecked {
390             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
391             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
392             // variables such that product = prod1 * 2^256 + prod0.
393             uint256 prod0; // Least significant 256 bits of the product
394             uint256 prod1; // Most significant 256 bits of the product
395             assembly {
396                 let mm := mulmod(x, y, not(0))
397                 prod0 := mul(x, y)
398                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
399             }
400 
401             // Handle non-overflow cases, 256 by 256 division.
402             if (prod1 == 0) {
403                 return prod0 / denominator;
404             }
405 
406             // Make sure the result is less than 2^256. Also prevents denominator == 0.
407             require(denominator > prod1);
408 
409             ///////////////////////////////////////////////
410             // 512 by 256 division.
411             ///////////////////////////////////////////////
412 
413             // Make division exact by subtracting the remainder from [prod1 prod0].
414             uint256 remainder;
415             assembly {
416                 // Compute remainder using mulmod.
417                 remainder := mulmod(x, y, denominator)
418 
419                 // Subtract 256 bit number from 512 bit number.
420                 prod1 := sub(prod1, gt(remainder, prod0))
421                 prod0 := sub(prod0, remainder)
422             }
423 
424             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
425             // See https://cs.stackexchange.com/q/138556/92363.
426 
427             // Does not overflow because the denominator cannot be zero at this stage in the function.
428             uint256 twos = denominator & (~denominator + 1);
429             assembly {
430                 // Divide denominator by twos.
431                 denominator := div(denominator, twos)
432 
433                 // Divide [prod1 prod0] by twos.
434                 prod0 := div(prod0, twos)
435 
436                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
437                 twos := add(div(sub(0, twos), twos), 1)
438             }
439 
440             // Shift in bits from prod1 into prod0.
441             prod0 |= prod1 * twos;
442 
443             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
444             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
445             // four bits. That is, denominator * inv = 1 mod 2^4.
446             uint256 inverse = (3 * denominator) ^ 2;
447 
448             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
449             // in modular arithmetic, doubling the correct bits in each step.
450             inverse *= 2 - denominator * inverse; // inverse mod 2^8
451             inverse *= 2 - denominator * inverse; // inverse mod 2^16
452             inverse *= 2 - denominator * inverse; // inverse mod 2^32
453             inverse *= 2 - denominator * inverse; // inverse mod 2^64
454             inverse *= 2 - denominator * inverse; // inverse mod 2^128
455             inverse *= 2 - denominator * inverse; // inverse mod 2^256
456 
457             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
458             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
459             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
460             // is no longer required.
461             result = prod0 * inverse;
462             return result;
463         }
464     }
465 
466     /**
467      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
468      */
469     function mulDiv(
470         uint256 x,
471         uint256 y,
472         uint256 denominator,
473         Rounding rounding
474     ) internal pure returns (uint256) {
475         uint256 result = mulDiv(x, y, denominator);
476         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
477             result += 1;
478         }
479         return result;
480     }
481 
482     /**
483      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
484      *
485      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
486      */
487     function sqrt(uint256 a) internal pure returns (uint256) {
488         if (a == 0) {
489             return 0;
490         }
491 
492         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
493         //
494         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
495         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
496         //
497         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
498         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
499         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
500         //
501         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
502         uint256 result = 1 << (log2(a) >> 1);
503 
504         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
505         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
506         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
507         // into the expected uint128 result.
508         unchecked {
509             result = (result + a / result) >> 1;
510             result = (result + a / result) >> 1;
511             result = (result + a / result) >> 1;
512             result = (result + a / result) >> 1;
513             result = (result + a / result) >> 1;
514             result = (result + a / result) >> 1;
515             result = (result + a / result) >> 1;
516             return min(result, a / result);
517         }
518     }
519 
520     /**
521      * @notice Calculates sqrt(a), following the selected rounding direction.
522      */
523     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
524         unchecked {
525             uint256 result = sqrt(a);
526             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
527         }
528     }
529 
530     /**
531      * @dev Return the log in base 2, rounded down, of a positive value.
532      * Returns 0 if given 0.
533      */
534     function log2(uint256 value) internal pure returns (uint256) {
535         uint256 result = 0;
536         unchecked {
537             if (value >> 128 > 0) {
538                 value >>= 128;
539                 result += 128;
540             }
541             if (value >> 64 > 0) {
542                 value >>= 64;
543                 result += 64;
544             }
545             if (value >> 32 > 0) {
546                 value >>= 32;
547                 result += 32;
548             }
549             if (value >> 16 > 0) {
550                 value >>= 16;
551                 result += 16;
552             }
553             if (value >> 8 > 0) {
554                 value >>= 8;
555                 result += 8;
556             }
557             if (value >> 4 > 0) {
558                 value >>= 4;
559                 result += 4;
560             }
561             if (value >> 2 > 0) {
562                 value >>= 2;
563                 result += 2;
564             }
565             if (value >> 1 > 0) {
566                 result += 1;
567             }
568         }
569         return result;
570     }
571 
572     /**
573      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
574      * Returns 0 if given 0.
575      */
576     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
577         unchecked {
578             uint256 result = log2(value);
579             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
580         }
581     }
582 
583     /**
584      * @dev Return the log in base 10, rounded down, of a positive value.
585      * Returns 0 if given 0.
586      */
587     function log10(uint256 value) internal pure returns (uint256) {
588         uint256 result = 0;
589         unchecked {
590             if (value >= 10**64) {
591                 value /= 10**64;
592                 result += 64;
593             }
594             if (value >= 10**32) {
595                 value /= 10**32;
596                 result += 32;
597             }
598             if (value >= 10**16) {
599                 value /= 10**16;
600                 result += 16;
601             }
602             if (value >= 10**8) {
603                 value /= 10**8;
604                 result += 8;
605             }
606             if (value >= 10**4) {
607                 value /= 10**4;
608                 result += 4;
609             }
610             if (value >= 10**2) {
611                 value /= 10**2;
612                 result += 2;
613             }
614             if (value >= 10**1) {
615                 result += 1;
616             }
617         }
618         return result;
619     }
620 
621     /**
622      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
623      * Returns 0 if given 0.
624      */
625     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
626         unchecked {
627             uint256 result = log10(value);
628             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
629         }
630     }
631 
632     /**
633      * @dev Return the log in base 256, rounded down, of a positive value.
634      * Returns 0 if given 0.
635      *
636      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
637      */
638     function log256(uint256 value) internal pure returns (uint256) {
639         uint256 result = 0;
640         unchecked {
641             if (value >> 128 > 0) {
642                 value >>= 128;
643                 result += 16;
644             }
645             if (value >> 64 > 0) {
646                 value >>= 64;
647                 result += 8;
648             }
649             if (value >> 32 > 0) {
650                 value >>= 32;
651                 result += 4;
652             }
653             if (value >> 16 > 0) {
654                 value >>= 16;
655                 result += 2;
656             }
657             if (value >> 8 > 0) {
658                 result += 1;
659             }
660         }
661         return result;
662     }
663 
664     /**
665      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
666      * Returns 0 if given 0.
667      */
668     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
669         unchecked {
670             uint256 result = log256(value);
671             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
672         }
673     }
674 }
675 //File： @openzeppelin/contracts/utils/Strings.sol
676 
677 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
678 
679 pragma solidity ^0.8.0;
680 
681 
682 /**
683  * @dev String operations.
684  */
685 library Strings {
686     bytes16 private constant _SYMBOLS = "0123456789abcdef";
687     uint8 private constant _ADDRESS_LENGTH = 20;
688 
689     /**
690      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
691      */
692     function toString(uint256 value) internal pure returns (string memory) {
693         unchecked {
694             uint256 length = Math.log10(value) + 1;
695             string memory buffer = new string(length);
696             uint256 ptr;
697             /// @solidity memory-safe-assembly
698             assembly {
699                 ptr := add(buffer, add(32, length))
700             }
701             while (true) {
702                 ptr--;
703                 /// @solidity memory-safe-assembly
704                 assembly {
705                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
706                 }
707                 value /= 10;
708                 if (value == 0) break;
709             }
710             return buffer;
711         }
712     }
713 
714     /**
715      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
716      */
717     function toHexString(uint256 value) internal pure returns (string memory) {
718         unchecked {
719             return toHexString(value, Math.log256(value) + 1);
720         }
721     }
722 
723     /**
724      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
725      */
726     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
727         bytes memory buffer = new bytes(2 * length + 2);
728         buffer[0] = "0";
729         buffer[1] = "x";
730         for (uint256 i = 2 * length + 1; i > 1; --i) {
731             buffer[i] = _SYMBOLS[value & 0xf];
732             value >>= 4;
733         }
734         require(value == 0, "Strings: hex length insufficient");
735         return string(buffer);
736     }
737 
738     /**
739      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
740      */
741     function toHexString(address addr) internal pure returns (string memory) {
742         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
743     }
744 }
745 //File： @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
746 
747 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
748 
749 pragma solidity ^0.8.0;
750 
751 /**
752  * @title ERC721 token receiver interface
753  * @dev Interface for any contract that wants to support safeTransfers
754  * from ERC721 asset contracts.
755  */
756 interface IERC721Receiver {
757     /**
758      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
759      * by `operator` from `from`, this function is called.
760      *
761      * It must return its Solidity selector to confirm the token transfer.
762      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
763      *
764      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
765      */
766     function onERC721Received(
767         address operator,
768         address from,
769         uint256 tokenId,
770         bytes calldata data
771     ) external returns (bytes4);
772 }
773 //File： @openzeppelin/contracts/utils/Context.sol
774 
775 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
776 
777 pragma solidity ^0.8.0;
778 
779 /**
780  * @dev Provides information about the current execution context, including the
781  * sender of the transaction and its data. While these are generally available
782  * via msg.sender and msg.data, they should not be accessed in such a direct
783  * manner, since when dealing with meta-transactions the account sending and
784  * paying for execution may not be the actual sender (as far as an application
785  * is concerned).
786  *
787  * This contract is only required for intermediate, library-like contracts.
788  */
789 abstract contract Context {
790     function _msgSender() internal view virtual returns (address) {
791         return msg.sender;
792     }
793 
794     function _msgData() internal view virtual returns (bytes calldata) {
795         return msg.data;
796     }
797 }
798 //File： @openzeppelin/contracts/utils/Address.sol
799 
800 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
801 
802 pragma solidity ^0.8.1;
803 
804 /**
805  * @dev Collection of functions related to the address type
806  */
807 library Address {
808     /**
809      * @dev Returns true if `account` is a contract.
810      *
811      * [IMPORTANT]
812      * ====
813      * It is unsafe to assume that an address for which this function returns
814      * false is an externally-owned account (EOA) and not a contract.
815      *
816      * Among others, `isContract` will return false for the following
817      * types of addresses:
818      *
819      *  - an externally-owned account
820      *  - a contract in construction
821      *  - an address where a contract will be created
822      *  - an address where a contract lived, but was destroyed
823      * ====
824      *
825      * [IMPORTANT]
826      * ====
827      * You shouldn't rely on `isContract` to protect against flash loan attacks!
828      *
829      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
830      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
831      * constructor.
832      * ====
833      */
834     function isContract(address account) internal view returns (bool) {
835         // This method relies on extcodesize/address.code.length, which returns 0
836         // for contracts in construction, since the code is only stored at the end
837         // of the constructor execution.
838 
839         return account.code.length > 0;
840     }
841 
842     /**
843      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
844      * `recipient`, forwarding all available gas and reverting on errors.
845      *
846      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
847      * of certain opcodes, possibly making contracts go over the 2300 gas limit
848      * imposed by `transfer`, making them unable to receive funds via
849      * `transfer`. {sendValue} removes this limitation.
850      *
851      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
852      *
853      * IMPORTANT: because control is transferred to `recipient`, care must be
854      * taken to not create reentrancy vulnerabilities. Consider using
855      * {ReentrancyGuard} or the
856      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
857      */
858     function sendValue(address payable recipient, uint256 amount) internal {
859         require(address(this).balance >= amount, "Address: insufficient balance");
860 
861         (bool success, ) = recipient.call{value: amount}("");
862         require(success, "Address: unable to send value, recipient may have reverted");
863     }
864 
865     /**
866      * @dev Performs a Solidity function call using a low level `call`. A
867      * plain `call` is an unsafe replacement for a function call: use this
868      * function instead.
869      *
870      * If `target` reverts with a revert reason, it is bubbled up by this
871      * function (like regular Solidity function calls).
872      *
873      * Returns the raw returned data. To convert to the expected return value,
874      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
875      *
876      * Requirements:
877      *
878      * - `target` must be a contract.
879      * - calling `target` with `data` must not revert.
880      *
881      * _Available since v3.1._
882      */
883     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
884         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
885     }
886 
887     /**
888      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
889      * `errorMessage` as a fallback revert reason when `target` reverts.
890      *
891      * _Available since v3.1._
892      */
893     function functionCall(
894         address target,
895         bytes memory data,
896         string memory errorMessage
897     ) internal returns (bytes memory) {
898         return functionCallWithValue(target, data, 0, errorMessage);
899     }
900 
901     /**
902      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
903      * but also transferring `value` wei to `target`.
904      *
905      * Requirements:
906      *
907      * - the calling contract must have an ETH balance of at least `value`.
908      * - the called Solidity function must be `payable`.
909      *
910      * _Available since v3.1._
911      */
912     function functionCallWithValue(
913         address target,
914         bytes memory data,
915         uint256 value
916     ) internal returns (bytes memory) {
917         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
918     }
919 
920     /**
921      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
922      * with `errorMessage` as a fallback revert reason when `target` reverts.
923      *
924      * _Available since v3.1._
925      */
926     function functionCallWithValue(
927         address target,
928         bytes memory data,
929         uint256 value,
930         string memory errorMessage
931     ) internal returns (bytes memory) {
932         require(address(this).balance >= value, "Address: insufficient balance for call");
933         (bool success, bytes memory returndata) = target.call{value: value}(data);
934         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
935     }
936 
937     /**
938      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
939      * but performing a static call.
940      *
941      * _Available since v3.3._
942      */
943     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
944         return functionStaticCall(target, data, "Address: low-level static call failed");
945     }
946 
947     /**
948      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
949      * but performing a static call.
950      *
951      * _Available since v3.3._
952      */
953     function functionStaticCall(
954         address target,
955         bytes memory data,
956         string memory errorMessage
957     ) internal view returns (bytes memory) {
958         (bool success, bytes memory returndata) = target.staticcall(data);
959         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
960     }
961 
962     /**
963      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
964      * but performing a delegate call.
965      *
966      * _Available since v3.4._
967      */
968     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
969         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
970     }
971 
972     /**
973      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
974      * but performing a delegate call.
975      *
976      * _Available since v3.4._
977      */
978     function functionDelegateCall(
979         address target,
980         bytes memory data,
981         string memory errorMessage
982     ) internal returns (bytes memory) {
983         (bool success, bytes memory returndata) = target.delegatecall(data);
984         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
985     }
986 
987     /**
988      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
989      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
990      *
991      * _Available since v4.8._
992      */
993     function verifyCallResultFromTarget(
994         address target,
995         bool success,
996         bytes memory returndata,
997         string memory errorMessage
998     ) internal view returns (bytes memory) {
999         if (success) {
1000             if (returndata.length == 0) {
1001                 // only check isContract if the call was successful and the return data is empty
1002                 // otherwise we already know that it was a contract
1003                 require(isContract(target), "Address: call to non-contract");
1004             }
1005             return returndata;
1006         } else {
1007             _revert(returndata, errorMessage);
1008         }
1009     }
1010 
1011     /**
1012      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1013      * revert reason or using the provided one.
1014      *
1015      * _Available since v4.3._
1016      */
1017     function verifyCallResult(
1018         bool success,
1019         bytes memory returndata,
1020         string memory errorMessage
1021     ) internal pure returns (bytes memory) {
1022         if (success) {
1023             return returndata;
1024         } else {
1025             _revert(returndata, errorMessage);
1026         }
1027     }
1028 
1029     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1030         // Look for revert reason and bubble it up if present
1031         if (returndata.length > 0) {
1032             // The easiest way to bubble the revert reason is using memory via assembly
1033             /// @solidity memory-safe-assembly
1034             assembly {
1035                 let returndata_size := mload(returndata)
1036                 revert(add(32, returndata), returndata_size)
1037             }
1038         } else {
1039             revert(errorMessage);
1040         }
1041     }
1042 }
1043 //File： @openzeppelin/contracts/utils/introspection/IERC165.sol
1044 
1045 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1046 
1047 pragma solidity ^0.8.0;
1048 
1049 /**
1050  * @dev Interface of the ERC165 standard, as defined in the
1051  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1052  *
1053  * Implementers can declare support of contract interfaces, which can then be
1054  * queried by others ({ERC165Checker}).
1055  *
1056  * For an implementation, see {ERC165}.
1057  */
1058 interface IERC165 {
1059     /**
1060      * @dev Returns true if this contract implements the interface defined by
1061      * `interfaceId`. See the corresponding
1062      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1063      * to learn more about how these ids are created.
1064      *
1065      * This function call must use less than 30 000 gas.
1066      */
1067     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1068 }
1069 //File： @openzeppelin/contracts/token/ERC721/IERC721.sol
1070 
1071 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1072 
1073 pragma solidity ^0.8.0;
1074 
1075 
1076 /**
1077  * @dev Required interface of an ERC721 compliant contract.
1078  */
1079 interface IERC721 is IERC165 {
1080     /**
1081      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1082      */
1083     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1084 
1085     /**
1086      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1087      */
1088     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1089 
1090     /**
1091      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1092      */
1093     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1094 
1095     /**
1096      * @dev Returns the number of tokens in ``owner``'s account.
1097      */
1098     function balanceOf(address owner) external view returns (uint256 balance);
1099 
1100     /**
1101      * @dev Returns the owner of the `tokenId` token.
1102      *
1103      * Requirements:
1104      *
1105      * - `tokenId` must exist.
1106      */
1107     function ownerOf(uint256 tokenId) external view returns (address owner);
1108 
1109     /**
1110      * @dev Safely transfers `tokenId` token from `from` to `to`.
1111      *
1112      * Requirements:
1113      *
1114      * - `from` cannot be the zero address.
1115      * - `to` cannot be the zero address.
1116      * - `tokenId` token must exist and be owned by `from`.
1117      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1118      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1119      *
1120      * Emits a {Transfer} event.
1121      */
1122     function safeTransferFrom(
1123         address from,
1124         address to,
1125         uint256 tokenId,
1126         bytes calldata data
1127     ) external;
1128 
1129     /**
1130      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1131      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1132      *
1133      * Requirements:
1134      *
1135      * - `from` cannot be the zero address.
1136      * - `to` cannot be the zero address.
1137      * - `tokenId` token must exist and be owned by `from`.
1138      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1139      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1140      *
1141      * Emits a {Transfer} event.
1142      */
1143     function safeTransferFrom(
1144         address from,
1145         address to,
1146         uint256 tokenId
1147     ) external;
1148 
1149     /**
1150      * @dev Transfers `tokenId` token from `from` to `to`.
1151      *
1152      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1153      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1154      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1155      *
1156      * Requirements:
1157      *
1158      * - `from` cannot be the zero address.
1159      * - `to` cannot be the zero address.
1160      * - `tokenId` token must be owned by `from`.
1161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function transferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId
1169     ) external;
1170 
1171     /**
1172      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1173      * The approval is cleared when the token is transferred.
1174      *
1175      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1176      *
1177      * Requirements:
1178      *
1179      * - The caller must own the token or be an approved operator.
1180      * - `tokenId` must exist.
1181      *
1182      * Emits an {Approval} event.
1183      */
1184     function approve(address to, uint256 tokenId) external;
1185 
1186     /**
1187      * @dev Approve or remove `operator` as an operator for the caller.
1188      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1189      *
1190      * Requirements:
1191      *
1192      * - The `operator` cannot be the caller.
1193      *
1194      * Emits an {ApprovalForAll} event.
1195      */
1196     function setApprovalForAll(address operator, bool _approved) external;
1197 
1198     /**
1199      * @dev Returns the account approved for `tokenId` token.
1200      *
1201      * Requirements:
1202      *
1203      * - `tokenId` must exist.
1204      */
1205     function getApproved(uint256 tokenId) external view returns (address operator);
1206 
1207     /**
1208      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1209      *
1210      * See {setApprovalForAll}
1211      */
1212     function isApprovedForAll(address owner, address operator) external view returns (bool);
1213 }
1214 //File： @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1215 
1216 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 
1221 /**
1222  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1223  * @dev See https://eips.ethereum.org/EIPS/eip-721
1224  */
1225 interface IERC721Metadata is IERC721 {
1226     /**
1227      * @dev Returns the token collection name.
1228      */
1229     function name() external view returns (string memory);
1230 
1231     /**
1232      * @dev Returns the token collection symbol.
1233      */
1234     function symbol() external view returns (string memory);
1235 
1236     /**
1237      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1238      */
1239     function tokenURI(uint256 tokenId) external view returns (string memory);
1240 }
1241 //File： @openzeppelin/contracts/utils/introspection/ERC165.sol
1242 
1243 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1244 
1245 pragma solidity ^0.8.0;
1246 
1247 
1248 /**
1249  * @dev Implementation of the {IERC165} interface.
1250  *
1251  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1252  * for the additional interface id that will be supported. For example:
1253  *
1254  * ```solidity
1255  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1256  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1257  * }
1258  * ```
1259  *
1260  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1261  */
1262 abstract contract ERC165 is IERC165 {
1263     /**
1264      * @dev See {IERC165-supportsInterface}.
1265      */
1266     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1267         return interfaceId == type(IERC165).interfaceId;
1268     }
1269 }
1270 //File： @openzeppelin/contracts/token/ERC721/ERC721.sol
1271 
1272 // OpenZeppelin Contracts (last updated v4.8.2) (token/ERC721/ERC721.sol)
1273 
1274 pragma solidity ^0.8.0;
1275 
1276 
1277 
1278 
1279 
1280 
1281 
1282 
1283 /**
1284  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1285  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1286  * {ERC721Enumerable}.
1287  */
1288 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1289     using Address for address;
1290     using Strings for uint256;
1291 
1292     // Token name
1293     string private _name;
1294 
1295     // Token symbol
1296     string private _symbol;
1297 
1298     // Mapping from token ID to owner address
1299     mapping(uint256 => address) private _owners;
1300 
1301     // Mapping owner address to token count
1302     mapping(address => uint256) private _balances;
1303 
1304     // Mapping from token ID to approved address
1305     mapping(uint256 => address) private _tokenApprovals;
1306 
1307     // Mapping from owner to operator approvals
1308     mapping(address => mapping(address => bool)) private _operatorApprovals;
1309 
1310     /**
1311      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1312      */
1313     constructor(string memory name_, string memory symbol_) {
1314         _name = name_;
1315         _symbol = symbol_;
1316     }
1317 
1318     /**
1319      * @dev See {IERC165-supportsInterface}.
1320      */
1321     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1322         return
1323             interfaceId == type(IERC721).interfaceId ||
1324             interfaceId == type(IERC721Metadata).interfaceId ||
1325             super.supportsInterface(interfaceId);
1326     }
1327 
1328     /**
1329      * @dev See {IERC721-balanceOf}.
1330      */
1331     function balanceOf(address owner) public view virtual override returns (uint256) {
1332         require(owner != address(0), "ERC721: address zero is not a valid owner");
1333         return _balances[owner];
1334     }
1335 
1336     /**
1337      * @dev See {IERC721-ownerOf}.
1338      */
1339     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1340         address owner = _ownerOf(tokenId);
1341         require(owner != address(0), "ERC721: invalid token ID");
1342         return owner;
1343     }
1344 
1345     /**
1346      * @dev See {IERC721Metadata-name}.
1347      */
1348     function name() public view virtual override returns (string memory) {
1349         return _name;
1350     }
1351 
1352     /**
1353      * @dev See {IERC721Metadata-symbol}.
1354      */
1355     function symbol() public view virtual override returns (string memory) {
1356         return _symbol;
1357     }
1358 
1359     /**
1360      * @dev See {IERC721Metadata-tokenURI}.
1361      */
1362     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1363         _requireMinted(tokenId);
1364 
1365         string memory baseURI = _baseURI();
1366         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1367     }
1368 
1369     /**
1370      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1371      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1372      * by default, can be overridden in child contracts.
1373      */
1374     function _baseURI() internal view virtual returns (string memory) {
1375         return "";
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-approve}.
1380      */
1381     function approve(address to, uint256 tokenId) public virtual override {
1382         address owner = ERC721.ownerOf(tokenId);
1383         require(to != owner, "ERC721: approval to current owner");
1384 
1385         require(
1386             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1387             "ERC721: approve caller is not token owner or approved for all"
1388         );
1389 
1390         _approve(to, tokenId);
1391     }
1392 
1393     /**
1394      * @dev See {IERC721-getApproved}.
1395      */
1396     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1397         _requireMinted(tokenId);
1398 
1399         return _tokenApprovals[tokenId];
1400     }
1401 
1402     /**
1403      * @dev See {IERC721-setApprovalForAll}.
1404      */
1405     function setApprovalForAll(address operator, bool approved) public virtual override {
1406         _setApprovalForAll(_msgSender(), operator, approved);
1407     }
1408 
1409     /**
1410      * @dev See {IERC721-isApprovedForAll}.
1411      */
1412     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1413         return _operatorApprovals[owner][operator];
1414     }
1415 
1416     /**
1417      * @dev See {IERC721-transferFrom}.
1418      */
1419     function transferFrom(
1420         address from,
1421         address to,
1422         uint256 tokenId
1423     ) public virtual override {
1424         //solhint-disable-next-line max-line-length
1425         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1426 
1427         _transfer(from, to, tokenId);
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-safeTransferFrom}.
1432      */
1433     function safeTransferFrom(
1434         address from,
1435         address to,
1436         uint256 tokenId
1437     ) public virtual override {
1438         safeTransferFrom(from, to, tokenId, "");
1439     }
1440 
1441     /**
1442      * @dev See {IERC721-safeTransferFrom}.
1443      */
1444     function safeTransferFrom(
1445         address from,
1446         address to,
1447         uint256 tokenId,
1448         bytes memory data
1449     ) public virtual override {
1450         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1451         _safeTransfer(from, to, tokenId, data);
1452     }
1453 
1454     /**
1455      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1456      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1457      *
1458      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1459      *
1460      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1461      * implement alternative mechanisms to perform token transfer, such as signature-based.
1462      *
1463      * Requirements:
1464      *
1465      * - `from` cannot be the zero address.
1466      * - `to` cannot be the zero address.
1467      * - `tokenId` token must exist and be owned by `from`.
1468      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1469      *
1470      * Emits a {Transfer} event.
1471      */
1472     function _safeTransfer(
1473         address from,
1474         address to,
1475         uint256 tokenId,
1476         bytes memory data
1477     ) internal virtual {
1478         _transfer(from, to, tokenId);
1479         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1480     }
1481 
1482     /**
1483      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1484      */
1485     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1486         return _owners[tokenId];
1487     }
1488 
1489     /**
1490      * @dev Returns whether `tokenId` exists.
1491      *
1492      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1493      *
1494      * Tokens start existing when they are minted (`_mint`),
1495      * and stop existing when they are burned (`_burn`).
1496      */
1497     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1498         return _ownerOf(tokenId) != address(0);
1499     }
1500 
1501     /**
1502      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must exist.
1507      */
1508     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1509         address owner = ERC721.ownerOf(tokenId);
1510         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1511     }
1512 
1513     /**
1514      * @dev Safely mints `tokenId` and transfers it to `to`.
1515      *
1516      * Requirements:
1517      *
1518      * - `tokenId` must not exist.
1519      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1520      *
1521      * Emits a {Transfer} event.
1522      */
1523     function _safeMint(address to, uint256 tokenId) internal virtual {
1524         _safeMint(to, tokenId, "");
1525     }
1526 
1527     /**
1528      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1529      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1530      */
1531     function _safeMint(
1532         address to,
1533         uint256 tokenId,
1534         bytes memory data
1535     ) internal virtual {
1536         _mint(to, tokenId);
1537         require(
1538             _checkOnERC721Received(address(0), to, tokenId, data),
1539             "ERC721: transfer to non ERC721Receiver implementer"
1540         );
1541     }
1542 
1543     /**
1544      * @dev Mints `tokenId` and transfers it to `to`.
1545      *
1546      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1547      *
1548      * Requirements:
1549      *
1550      * - `tokenId` must not exist.
1551      * - `to` cannot be the zero address.
1552      *
1553      * Emits a {Transfer} event.
1554      */
1555     function _mint(address to, uint256 tokenId) internal virtual {
1556         require(to != address(0), "ERC721: mint to the zero address");
1557         require(!_exists(tokenId), "ERC721: token already minted");
1558 
1559         _beforeTokenTransfer(address(0), to, tokenId, 1);
1560 
1561         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1562         require(!_exists(tokenId), "ERC721: token already minted");
1563 
1564         unchecked {
1565             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1566             // Given that tokens are minted one by one, it is impossible in practice that
1567             // this ever happens. Might change if we allow batch minting.
1568             // The ERC fails to describe this case.
1569             _balances[to] += 1;
1570         }
1571 
1572         _owners[tokenId] = to;
1573 
1574         emit Transfer(address(0), to, tokenId);
1575 
1576         _afterTokenTransfer(address(0), to, tokenId, 1);
1577     }
1578 
1579     /**
1580      * @dev Destroys `tokenId`.
1581      * The approval is cleared when the token is burned.
1582      * This is an internal function that does not check if the sender is authorized to operate on the token.
1583      *
1584      * Requirements:
1585      *
1586      * - `tokenId` must exist.
1587      *
1588      * Emits a {Transfer} event.
1589      */
1590     function _burn(uint256 tokenId) internal virtual {
1591         address owner = ERC721.ownerOf(tokenId);
1592 
1593         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1594 
1595         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1596         owner = ERC721.ownerOf(tokenId);
1597 
1598         // Clear approvals
1599         delete _tokenApprovals[tokenId];
1600 
1601         unchecked {
1602             // Cannot overflow, as that would require more tokens to be burned/transferred
1603             // out than the owner initially received through minting and transferring in.
1604             _balances[owner] -= 1;
1605         }
1606         delete _owners[tokenId];
1607 
1608         emit Transfer(owner, address(0), tokenId);
1609 
1610         _afterTokenTransfer(owner, address(0), tokenId, 1);
1611     }
1612 
1613     /**
1614      * @dev Transfers `tokenId` from `from` to `to`.
1615      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1616      *
1617      * Requirements:
1618      *
1619      * - `to` cannot be the zero address.
1620      * - `tokenId` token must be owned by `from`.
1621      *
1622      * Emits a {Transfer} event.
1623      */
1624     function _transfer(
1625         address from,
1626         address to,
1627         uint256 tokenId
1628     ) internal virtual {
1629         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1630         require(to != address(0), "ERC721: transfer to the zero address");
1631 
1632         _beforeTokenTransfer(from, to, tokenId, 1);
1633 
1634         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1635         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1636 
1637         // Clear approvals from the previous owner
1638         delete _tokenApprovals[tokenId];
1639 
1640         unchecked {
1641             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1642             // `from`'s balance is the number of token held, which is at least one before the current
1643             // transfer.
1644             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1645             // all 2**256 token ids to be minted, which in practice is impossible.
1646             _balances[from] -= 1;
1647             _balances[to] += 1;
1648         }
1649         _owners[tokenId] = to;
1650 
1651         emit Transfer(from, to, tokenId);
1652 
1653         _afterTokenTransfer(from, to, tokenId, 1);
1654     }
1655 
1656     /**
1657      * @dev Approve `to` to operate on `tokenId`
1658      *
1659      * Emits an {Approval} event.
1660      */
1661     function _approve(address to, uint256 tokenId) internal virtual {
1662         _tokenApprovals[tokenId] = to;
1663         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev Approve `operator` to operate on all of `owner` tokens
1668      *
1669      * Emits an {ApprovalForAll} event.
1670      */
1671     function _setApprovalForAll(
1672         address owner,
1673         address operator,
1674         bool approved
1675     ) internal virtual {
1676         require(owner != operator, "ERC721: approve to caller");
1677         _operatorApprovals[owner][operator] = approved;
1678         emit ApprovalForAll(owner, operator, approved);
1679     }
1680 
1681     /**
1682      * @dev Reverts if the `tokenId` has not been minted yet.
1683      */
1684     function _requireMinted(uint256 tokenId) internal view virtual {
1685         require(_exists(tokenId), "ERC721: invalid token ID");
1686     }
1687 
1688     /**
1689      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1690      * The call is not executed if the target address is not a contract.
1691      *
1692      * @param from address representing the previous owner of the given token ID
1693      * @param to target address that will receive the tokens
1694      * @param tokenId uint256 ID of the token to be transferred
1695      * @param data bytes optional data to send along with the call
1696      * @return bool whether the call correctly returned the expected magic value
1697      */
1698     function _checkOnERC721Received(
1699         address from,
1700         address to,
1701         uint256 tokenId,
1702         bytes memory data
1703     ) private returns (bool) {
1704         if (to.isContract()) {
1705             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1706                 return retval == IERC721Receiver.onERC721Received.selector;
1707             } catch (bytes memory reason) {
1708                 if (reason.length == 0) {
1709                     revert("ERC721: transfer to non ERC721Receiver implementer");
1710                 } else {
1711                     /// @solidity memory-safe-assembly
1712                     assembly {
1713                         revert(add(32, reason), mload(reason))
1714                     }
1715                 }
1716             }
1717         } else {
1718             return true;
1719         }
1720     }
1721 
1722     /**
1723      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1724      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1725      *
1726      * Calling conditions:
1727      *
1728      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1729      * - When `from` is zero, the tokens will be minted for `to`.
1730      * - When `to` is zero, ``from``'s tokens will be burned.
1731      * - `from` and `to` are never both zero.
1732      * - `batchSize` is non-zero.
1733      *
1734      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1735      */
1736     function _beforeTokenTransfer(
1737         address from,
1738         address to,
1739         uint256 firstTokenId,
1740         uint256 batchSize
1741     ) internal virtual {}
1742 
1743     /**
1744      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1745      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1746      *
1747      * Calling conditions:
1748      *
1749      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1750      * - When `from` is zero, the tokens were minted for `to`.
1751      * - When `to` is zero, ``from``'s tokens were burned.
1752      * - `from` and `to` are never both zero.
1753      * - `batchSize` is non-zero.
1754      *
1755      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1756      */
1757     function _afterTokenTransfer(
1758         address from,
1759         address to,
1760         uint256 firstTokenId,
1761         uint256 batchSize
1762     ) internal virtual {}
1763 
1764     /**
1765      * @dev Unsafe write access to the balances, used by extensions that "mint" tokens using an {ownerOf} override.
1766      *
1767      * WARNING: Anyone calling this MUST ensure that the balances remain consistent with the ownership. The invariant
1768      * being that for any address `a` the value returned by `balanceOf(a)` must be equal to the number of tokens such
1769      * that `ownerOf(tokenId)` is `a`.
1770      */
1771     // solhint-disable-next-line func-name-mixedcase
1772     function __unsafe_increaseBalance(address account, uint256 amount) internal {
1773         _balances[account] += amount;
1774     }
1775 }
1776 //File： @openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol
1777 
1778 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/extensions/ERC721URIStorage.sol)
1779 
1780 pragma solidity ^0.8.0;
1781 
1782 
1783 /**
1784  * @dev ERC721 token with storage based token URI management.
1785  */
1786 abstract contract ERC721URIStorage is ERC721 {
1787     using Strings for uint256;
1788 
1789     // Optional mapping for token URIs
1790     mapping(uint256 => string) private _tokenURIs;
1791 
1792     /**
1793      * @dev See {IERC721Metadata-tokenURI}.
1794      */
1795     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1796         _requireMinted(tokenId);
1797 
1798         string memory _tokenURI = _tokenURIs[tokenId];
1799         string memory base = _baseURI();
1800 
1801         // If there is no base URI, return the token URI.
1802         if (bytes(base).length == 0) {
1803             return _tokenURI;
1804         }
1805         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1806         if (bytes(_tokenURI).length > 0) {
1807             return string(abi.encodePacked(base, _tokenURI));
1808         }
1809 
1810         return super.tokenURI(tokenId);
1811     }
1812 
1813     /**
1814      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1815      *
1816      * Requirements:
1817      *
1818      * - `tokenId` must exist.
1819      */
1820     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1821         require(_exists(tokenId), "ERC721URIStorage: URI set of nonexistent token");
1822         _tokenURIs[tokenId] = _tokenURI;
1823     }
1824 
1825     /**
1826      * @dev See {ERC721-_burn}. This override additionally checks to see if a
1827      * token-specific URI was set for the token, and if so, it deletes the token URI from
1828      * the storage mapping.
1829      */
1830     function _burn(uint256 tokenId) internal virtual override {
1831         super._burn(tokenId);
1832 
1833         if (bytes(_tokenURIs[tokenId]).length != 0) {
1834             delete _tokenURIs[tokenId];
1835         }
1836     }
1837 }
1838 //File： @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1839 
1840 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1841 
1842 pragma solidity ^0.8.0;
1843 
1844 
1845 /**
1846  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1847  * @dev See https://eips.ethereum.org/EIPS/eip-721
1848  */
1849 interface IERC721Enumerable is IERC721 {
1850     /**
1851      * @dev Returns the total amount of tokens stored by the contract.
1852      */
1853     function totalSupply() external view returns (uint256);
1854 
1855     /**
1856      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1857      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1858      */
1859     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1860 
1861     /**
1862      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1863      * Use along with {totalSupply} to enumerate all tokens.
1864      */
1865     function tokenByIndex(uint256 index) external view returns (uint256);
1866 }
1867 //File： https://github.com/ErickQueiroz93/solidity/blob/main/ERC721A.sol
1868 
1869 // Creator: Chiru Labs
1870 
1871 pragma solidity ^0.8.4;
1872 
1873 
1874 
1875 
1876 
1877 
1878 
1879 
1880 
1881 error ApprovalCallerNotOwnerNorApproved();
1882 error ApprovalQueryForNonexistentToken();
1883 error ApproveToCaller();
1884 error ApprovalToCurrentOwner();
1885 error BalanceQueryForZeroAddress();
1886 error MintToZeroAddress();
1887 error MintZeroQuantity();
1888 error OwnerQueryForNonexistentToken();
1889 error TransferCallerNotOwnerNorApproved();
1890 error TransferFromIncorrectOwner();
1891 error TransferToNonERC721ReceiverImplementer();
1892 error TransferToZeroAddress();
1893 error URIQueryForNonexistentToken();
1894 
1895 /**
1896  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1897  * the Metadata extension. Built to optimize for lower gas during batch mints.
1898  *
1899  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1900  *
1901  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1902  *
1903  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1904  */
1905 contract ERC721A is Context, ERC165, IERC721 {
1906     using Address for address;
1907     using Strings for uint256;
1908     mapping(address => uint256[]) public _addressLastMintedTokenIds;
1909 
1910     // Compiler will pack this into a single 256bit word.
1911     struct TokenOwnership {
1912         // The address of the owner.
1913         address addr;
1914         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1915         uint64 startTimestamp;
1916         // Whether the token has been burned.
1917         bool burned;
1918     }
1919 
1920     // Compiler will pack this into a single 256bit word.
1921     struct AddressData {
1922         // Realistically, 2**64-1 is more than enough.
1923         uint64 balance;
1924         // Keeps track of mint count with minimal overhead for tokenomics.
1925         uint64 numberMinted;
1926         // Keeps track of burn count with minimal overhead for tokenomics.
1927         uint64 numberBurned;
1928         // For miscellaneous variable(s) pertaining to the address
1929         // (e.g. number of whitelist mint slots used).
1930         // If there are multiple variables, please pack them into a uint64.
1931         uint64 aux;
1932     }
1933 
1934     // The tokenId of the next token to be minted.
1935     uint256 internal _currentIndex;
1936 
1937     // The number of tokens burned.
1938     uint256 internal _burnCounter;
1939 
1940     // Token name
1941     string private _name;
1942 
1943     // Token symbol
1944     string private _symbol;
1945 
1946     // Mapping from token ID to ownership details
1947     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1948     mapping(uint256 => TokenOwnership) internal _ownerships;
1949 
1950     // Mapping owner address to address data
1951     mapping(address => AddressData) internal _addressData;
1952 
1953     // Mapping from token ID to approved address
1954     mapping(uint256 => address) private _tokenApprovals;
1955 
1956     // Mapping from owner to operator approvals
1957     mapping(address => mapping(address => bool)) private _operatorApprovals;
1958 
1959     constructor(string memory name_, string memory symbol_) {
1960         _name = name_;
1961         _symbol = symbol_;
1962         _currentIndex = _startTokenId();
1963     }
1964 
1965     /**
1966      * To change the starting tokenId, please override this function.
1967      */
1968     function _startTokenId() internal view virtual returns (uint256) {
1969         return 1;
1970     }
1971 
1972     /**
1973      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1974      */
1975     function totalSupply() public view returns (uint256) {
1976         // Counter underflow is impossible as _burnCounter cannot be incremented
1977         // more than _currentIndex - _startTokenId() times
1978         unchecked {
1979             return _currentIndex - _burnCounter - _startTokenId();
1980         }
1981     }
1982 
1983     /**
1984      * Returns the total amount of tokens minted in the contract.
1985      */
1986     function _totalMinted() internal view returns (uint256) {
1987         // Counter underflow is impossible as _currentIndex does not decrement,
1988         // and it is initialized to _startTokenId()
1989         unchecked {
1990             return _currentIndex - _startTokenId();
1991         }
1992     }
1993 
1994     /**
1995      * @dev See {IERC165-supportsInterface}.
1996      */
1997     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1998         return
1999             interfaceId == type(IERC721).interfaceId ||
2000             interfaceId == type(IERC721Metadata).interfaceId ||
2001             super.supportsInterface(interfaceId);
2002     }
2003 
2004     /**
2005      * @dev See {IERC721-balanceOf}.
2006      */
2007     function balanceOf(address owner) public view override returns (uint256) {
2008         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2009         return uint256(_addressData[owner].balance);
2010     }
2011 
2012     /**
2013      * Returns the number of tokens minted by `owner`.
2014      */
2015     function _numberMinted(address owner) internal view returns (uint256) {
2016         return uint256(_addressData[owner].numberMinted);
2017     }
2018 
2019     /**
2020      * Returns the number of tokens burned by or on behalf of `owner`.
2021      */
2022     function _numberBurned(address owner) internal view returns (uint256) {
2023         return uint256(_addressData[owner].numberBurned);
2024     }
2025 
2026     /**
2027      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2028      */
2029     function _getAux(address owner) internal view returns (uint64) {
2030         return _addressData[owner].aux;
2031     }
2032 
2033     /**
2034      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
2035      * If there are multiple variables, please pack them into a uint64.
2036      */
2037     function _setAux(address owner, uint64 aux) internal {
2038         _addressData[owner].aux = aux;
2039     }
2040 
2041     /**
2042      * Gas spent here starts off proportional to the maximum mint batch size.
2043      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
2044      */
2045     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
2046         uint256 curr = tokenId;
2047 
2048         unchecked {
2049             if (_startTokenId() <= curr && curr < _currentIndex) {
2050                 TokenOwnership memory ownership = _ownerships[curr];
2051                 if (!ownership.burned) {
2052                     if (ownership.addr != address(0)) {
2053                         return ownership;
2054                     }
2055                     // Invariant:
2056                     // There will always be an ownership that has an address and is not burned
2057                     // before an ownership that does not have an address and is not burned.
2058                     // Hence, curr will not underflow.
2059                     while (true) {
2060                         curr--;
2061                         ownership = _ownerships[curr];
2062                         if (ownership.addr != address(0)) {
2063                             return ownership;
2064                         }
2065                     }
2066                 }
2067             }
2068         }
2069         revert OwnerQueryForNonexistentToken();
2070     }
2071 
2072     /**
2073      * @dev See {IERC721-ownerOf}.
2074      */
2075     function ownerOf(uint256 tokenId) public view override returns (address) {
2076         return _ownershipOf(tokenId).addr;
2077     }
2078 
2079     /**
2080      * @dev See {IERC721Metadata-name}.
2081      */
2082     function name() public view virtual returns (string memory) {
2083         return _name;
2084     }
2085 
2086     /**
2087      * @dev See {IERC721Metadata-symbol}.
2088      */
2089     function symbol() public view virtual returns (string memory) {
2090         return _symbol;
2091     }
2092 
2093     /**
2094      * @dev See {IERC721Metadata-tokenURI}.
2095      */
2096     function tokenURI(uint256 tokenId, string memory baseExtension) public view virtual returns (string memory) {
2097         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2098 
2099         string memory baseURI = _baseURI();
2100         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString(), baseExtension)) : '';
2101     }
2102 
2103     /**
2104      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2105      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2106      * by default, can be overriden in child contracts.
2107      */
2108     function _baseURI() internal view virtual returns (string memory) {
2109         return '';
2110     }
2111 
2112     /**
2113      * @dev See {IERC721-approve}.
2114      */
2115     function approve(address to, uint256 tokenId) public override virtual {
2116         address owner = ERC721A.ownerOf(tokenId);
2117         if (to == owner) revert ApprovalToCurrentOwner();
2118 
2119         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
2120             revert ApprovalCallerNotOwnerNorApproved();
2121         }
2122 
2123         _approve(to, tokenId, owner);
2124     }
2125 
2126     /**
2127      * @dev See {IERC721-getApproved}.
2128      */
2129     function getApproved(uint256 tokenId) public view override returns (address) {
2130         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2131 
2132         return _tokenApprovals[tokenId];
2133     }
2134 
2135     /**
2136      * @dev See {IERC721-setApprovalForAll}.
2137      */
2138     function setApprovalForAll(address operator, bool approved) public virtual override {
2139         if (operator == _msgSender()) revert ApproveToCaller();
2140 
2141         _operatorApprovals[_msgSender()][operator] = approved;
2142         emit ApprovalForAll(_msgSender(), operator, approved);
2143     }
2144 
2145     /**
2146      * @dev See {IERC721-isApprovedForAll}.
2147      */
2148     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2149         return _operatorApprovals[owner][operator];
2150     }
2151 
2152     /**
2153      * @dev See {IERC721-transferFrom}.
2154      */
2155     function transferFrom(
2156         address from,
2157         address to,
2158         uint256 tokenId
2159     ) public virtual override {
2160         _transfer(from, to, tokenId);
2161     }
2162 
2163     /**
2164      * @dev See {IERC721-safeTransferFrom}.
2165      */
2166     function safeTransferFrom(
2167         address from,
2168         address to,
2169         uint256 tokenId
2170     ) public virtual override {
2171         safeTransferFrom(from, to, tokenId, '');
2172     }
2173 
2174     /**
2175      * @dev See {IERC721-safeTransferFrom}.
2176      */
2177     function safeTransferFrom(
2178         address from,
2179         address to,
2180         uint256 tokenId,
2181         bytes memory _data
2182     ) public virtual override {
2183         _transfer(from, to, tokenId);
2184         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
2185             revert TransferToNonERC721ReceiverImplementer();
2186         }
2187     }
2188 
2189     /**
2190      * @dev Returns whether `tokenId` exists.
2191      *
2192      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2193      *
2194      * Tokens start existing when they are minted (`_mint`),
2195      */
2196     function _exists(uint256 tokenId) internal view returns (bool) {
2197         return _startTokenId() <= tokenId && tokenId < _currentIndex && !_ownerships[tokenId].burned;
2198     }
2199 
2200     function _safeMint(address to, uint256 quantity) internal {
2201         _safeMint(to, quantity, '');
2202     }
2203 
2204     /**
2205      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2206      *
2207      * Requirements:
2208      *
2209      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2210      * - `quantity` must be greater than 0.
2211      *
2212      * Emits a {Transfer} event.
2213      */
2214     function _safeMint(
2215         address to,
2216         uint256 quantity,
2217         bytes memory _data
2218     ) internal {
2219         _mint(to, quantity, _data, true);
2220     }
2221 
2222     /**
2223      * @dev Mints `quantity` tokens and transfers them to `to`.
2224      *
2225      * Requirements:
2226      *
2227      * - `to` cannot be the zero address.
2228      * - `quantity` must be greater than 0.
2229      *
2230      * Emits a {Transfer} event.
2231      */
2232     function _mint(
2233         address to,
2234         uint256 quantity,
2235         bytes memory _data,
2236         bool safe
2237     ) internal {
2238         uint256 startTokenId = _currentIndex;
2239         if (to == address(0)) revert MintToZeroAddress();
2240         if (quantity == 0) revert MintZeroQuantity();
2241 
2242         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2243 
2244         delete _addressLastMintedTokenIds[msg.sender];
2245 
2246         // Overflows are incredibly unrealistic.
2247         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
2248         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
2249         unchecked {
2250             _addressData[to].balance += uint64(quantity);
2251             _addressData[to].numberMinted += uint64(quantity);
2252 
2253             _ownerships[startTokenId].addr = to;
2254             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
2255 
2256             uint256 updatedIndex = startTokenId;
2257             uint256 end = updatedIndex + quantity;
2258 
2259             if (safe && to.isContract()) {
2260                 do {
2261                     emit Transfer(address(0), to, updatedIndex);
2262                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
2263                         revert TransferToNonERC721ReceiverImplementer();
2264                     }
2265                 } while (updatedIndex != end);
2266                 // Reentrancy protection
2267                 if (_currentIndex != startTokenId) revert();
2268             } else {
2269                 do {
2270                     _addressLastMintedTokenIds[msg.sender].push(updatedIndex);
2271                     emit Transfer(address(0), to, updatedIndex++);
2272                 } while (updatedIndex != end);
2273             }
2274             _currentIndex = updatedIndex;
2275         }
2276         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2277     }
2278 
2279     /**
2280      * @dev Transfers `tokenId` from `from` to `to`.
2281      *
2282      * Requirements:
2283      *
2284      * - `to` cannot be the zero address.
2285      * - `tokenId` token must be owned by `from`.
2286      *
2287      * Emits a {Transfer} event.
2288      */
2289     function _transfer(
2290         address from,
2291         address to,
2292         uint256 tokenId
2293     ) private {
2294         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2295 
2296         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
2297 
2298         bool isApprovedOrOwner = (_msgSender() == from ||
2299             isApprovedForAll(from, _msgSender()) ||
2300             getApproved(tokenId) == _msgSender());
2301 
2302         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2303         if (to == address(0)) revert TransferToZeroAddress();
2304 
2305         _beforeTokenTransfers(from, to, tokenId, 1);
2306 
2307         // Clear approvals from the previous owner
2308         _approve(address(0), tokenId, from);
2309 
2310         // Underflow of the sender's balance is impossible because we check for
2311         // ownership above and the recipient's balance can't realistically overflow.
2312         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2313         unchecked {
2314             _addressData[from].balance -= 1;
2315             _addressData[to].balance += 1;
2316 
2317             TokenOwnership storage currSlot = _ownerships[tokenId];
2318             currSlot.addr = to;
2319             currSlot.startTimestamp = uint64(block.timestamp);
2320 
2321             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
2322             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2323             uint256 nextTokenId = tokenId + 1;
2324             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2325             if (nextSlot.addr == address(0)) {
2326                 // This will suffice for checking _exists(nextTokenId),
2327                 // as a burned slot cannot contain the zero address.
2328                 if (nextTokenId != _currentIndex) {
2329                     nextSlot.addr = from;
2330                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2331                 }
2332             }
2333         }
2334 
2335         emit Transfer(from, to, tokenId);
2336         _afterTokenTransfers(from, to, tokenId, 1);
2337     }
2338 
2339     /**
2340      * @dev This is equivalent to _burn(tokenId, false)
2341      */
2342     function _burn(uint256 tokenId) internal virtual {
2343         _burn(tokenId, false);
2344     }
2345 
2346     /**
2347      * @dev Destroys `tokenId`.
2348      * The approval is cleared when the token is burned.
2349      *
2350      * Requirements:
2351      *
2352      * - `tokenId` must exist.
2353      *
2354      * Emits a {Transfer} event.
2355      */
2356     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2357         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
2358 
2359         address from = prevOwnership.addr;
2360 
2361         if (approvalCheck) {
2362             bool isApprovedOrOwner = (_msgSender() == from ||
2363                 isApprovedForAll(from, _msgSender()) ||
2364                 getApproved(tokenId) == _msgSender());
2365 
2366             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
2367         }
2368 
2369         _beforeTokenTransfers(from, address(0), tokenId, 1);
2370 
2371         // Clear approvals from the previous owner
2372         _approve(address(0), tokenId, from);
2373 
2374         // Underflow of the sender's balance is impossible because we check for
2375         // ownership above and the recipient's balance can't realistically overflow.
2376         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
2377         unchecked {
2378             AddressData storage addressData = _addressData[from];
2379             addressData.balance -= 1;
2380             addressData.numberBurned += 1;
2381 
2382             // Keep track of who burned the token, and the timestamp of burning.
2383             TokenOwnership storage currSlot = _ownerships[tokenId];
2384             currSlot.addr = from;
2385             currSlot.startTimestamp = uint64(block.timestamp);
2386             currSlot.burned = true;
2387 
2388             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
2389             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
2390             uint256 nextTokenId = tokenId + 1;
2391             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
2392             if (nextSlot.addr == address(0)) {
2393                 // This will suffice for checking _exists(nextTokenId),
2394                 // as a burned slot cannot contain the zero address.
2395                 if (nextTokenId != _currentIndex) {
2396                     nextSlot.addr = from;
2397                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
2398                 }
2399             }
2400         }
2401 
2402         emit Transfer(from, address(0), tokenId);
2403         _afterTokenTransfers(from, address(0), tokenId, 1);
2404 
2405         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2406         unchecked {
2407             _burnCounter++;
2408         }
2409     }
2410 
2411     /**
2412      * @dev Approve `to` to operate on `tokenId`
2413      *
2414      * Emits a {Approval} event.
2415      */
2416     function _approve(
2417         address to,
2418         uint256 tokenId,
2419         address owner
2420     ) private {
2421         _tokenApprovals[tokenId] = to;
2422         emit Approval(owner, to, tokenId);
2423     }
2424 
2425     /**
2426      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2427      *
2428      * @param from address representing the previous owner of the given token ID
2429      * @param to target address that will receive the tokens
2430      * @param tokenId uint256 ID of the token to be transferred
2431      * @param _data bytes optional data to send along with the call
2432      * @return bool whether the call correctly returned the expected magic value
2433      */
2434     function _checkContractOnERC721Received(
2435         address from,
2436         address to,
2437         uint256 tokenId,
2438         bytes memory _data
2439     ) private returns (bool) {
2440         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
2441             return retval == IERC721Receiver(to).onERC721Received.selector;
2442         } catch (bytes memory reason) {
2443             if (reason.length == 0) {
2444                 revert TransferToNonERC721ReceiverImplementer();
2445             } else {
2446                 assembly {
2447                     revert(add(32, reason), mload(reason))
2448                 }
2449             }
2450         }
2451     }
2452 
2453     /**
2454      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
2455      * And also called before burning one token.
2456      *
2457      * startTokenId - the first token id to be transferred
2458      * quantity - the amount to be transferred
2459      *
2460      * Calling conditions:
2461      *
2462      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2463      * transferred to `to`.
2464      * - When `from` is zero, `tokenId` will be minted for `to`.
2465      * - When `to` is zero, `tokenId` will be burned by `from`.
2466      * - `from` and `to` are never both zero.
2467      */
2468     function _beforeTokenTransfers(
2469         address from,
2470         address to,
2471         uint256 startTokenId,
2472         uint256 quantity
2473     ) internal virtual {}
2474 
2475     /**
2476      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
2477      * minting.
2478      * And also called after one token has been burned.
2479      *
2480      * startTokenId - the first token id to be transferred
2481      * quantity - the amount to be transferred
2482      *
2483      * Calling conditions:
2484      *
2485      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2486      * transferred to `to`.
2487      * - When `from` is zero, `tokenId` has been minted for `to`.
2488      * - When `to` is zero, `tokenId` has been burned by `from`.
2489      * - `from` and `to` are never both zero.
2490      */
2491     function _afterTokenTransfers(
2492         address from,
2493         address to,
2494         uint256 startTokenId,
2495         uint256 quantity
2496     ) internal virtual {}
2497 }
2498 //File： https://github.com/ProjectOpenSea/operator-filter-registry/blob/main/src/DefaultOperatorFilterer.sol
2499 
2500 pragma solidity ^0.8.13;
2501 
2502 
2503 /**
2504  * @title  DefaultOperatorFilterer
2505  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
2506  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
2507  *         administration methods on the contract itself to interact with the registry otherwise the subscription
2508  *         will be locked to the options set during construction.
2509  */
2510 
2511 abstract contract DefaultOperatorFilterer is OperatorFilterer {
2512     /// @dev The constructor that is called when the contract is being deployed.
2513     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
2514 }
2515 //File： @openzeppelin/contracts/access/Ownable.sol
2516 
2517 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2518 
2519 pragma solidity ^0.8.0;
2520 
2521 
2522 /**
2523  * @dev Contract module which provides a basic access control mechanism, where
2524  * there is an account (an owner) that can be granted exclusive access to
2525  * specific functions.
2526  *
2527  * By default, the owner account will be the one that deploys the contract. This
2528  * can later be changed with {transferOwnership}.
2529  *
2530  * This module is used through inheritance. It will make available the modifier
2531  * `onlyOwner`, which can be applied to your functions to restrict their use to
2532  * the owner.
2533  */
2534 abstract contract Ownable is Context {
2535     address private _owner;
2536 
2537     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2538 
2539     /**
2540      * @dev Initializes the contract setting the deployer as the initial owner.
2541      */
2542     constructor() {
2543         _transferOwnership(_msgSender());
2544     }
2545 
2546     /**
2547      * @dev Throws if called by any account other than the owner.
2548      */
2549     modifier onlyOwner() {
2550         _checkOwner();
2551         _;
2552     }
2553 
2554     /**
2555      * @dev Returns the address of the current owner.
2556      */
2557     function owner() public view virtual returns (address) {
2558         return _owner;
2559     }
2560 
2561     /**
2562      * @dev Throws if the sender is not the owner.
2563      */
2564     function _checkOwner() internal view virtual {
2565         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2566     }
2567 
2568     /**
2569      * @dev Leaves the contract without owner. It will not be possible to call
2570      * `onlyOwner` functions anymore. Can only be called by the current owner.
2571      *
2572      * NOTE: Renouncing ownership will leave the contract without an owner,
2573      * thereby removing any functionality that is only available to the owner.
2574      */
2575     function renounceOwnership() public virtual onlyOwner {
2576         _transferOwnership(address(0));
2577     }
2578 
2579     /**
2580      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2581      * Can only be called by the current owner.
2582      */
2583     function transferOwnership(address newOwner) public virtual onlyOwner {
2584         require(newOwner != address(0), "Ownable: new owner is the zero address");
2585         _transferOwnership(newOwner);
2586     }
2587 
2588     /**
2589      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2590      * Internal function without access restriction.
2591      */
2592     function _transferOwnership(address newOwner) internal virtual {
2593         address oldOwner = _owner;
2594         _owner = newOwner;
2595         emit OwnershipTransferred(oldOwner, newOwner);
2596     }
2597 }
2598 //File： fs://dec2d85c93724763b5c2b4fe69b265d4/SurfJunkie.sol
2599 
2600 
2601 pragma solidity >=0.7.0 <0.9.0;
2602 pragma abicoder v2;
2603 
2604 
2605 
2606 
2607 
2608 
2609 
2610 
2611 
2612 contract SurfJunkie is DefaultOperatorFilterer, ERC721A, Ownable {
2613     using Address for address;
2614     using Strings for uint256;
2615 
2616     string private baseURI; //Deve ser a URL do json do pinata:
2617     string private baseExtension = ".json";
2618     string private notRevealedUri = "";
2619     uint256 private maxSupply = 4000;
2620     uint256 public maxMintAmount = 6;
2621     uint256 public maxMintAmountWaitList = 10;
2622     bool private paused = false;
2623     mapping(uint256 => uint) private _availableTokens;
2624     uint256 private _numAvailableTokens;
2625 
2626     string private _contractUri;
2627 
2628     address _contractOwner;
2629 
2630     uint256 private _royalties = 7;
2631 
2632     mapping(address => uint256) private _addressLastMintedTokenId;
2633 
2634     uint256 public _nftEtherValue = 2000000000000000;
2635     uint256 public _nftEtherValueWaitList = 1000000000000000;
2636 
2637     uint256 private royalties      = 7;
2638     uint256 private royaltiesOne   = 44;
2639     uint256 private royaltiesTwo   = 28;
2640     uint256 private royaltiesThree = 28;
2641     
2642     address private wSplit      = 0xdaC531b352a67C49E9a9268C44A72Bb54D83dCFE;
2643 
2644     address private wOwnerOne   = 0xfe2fe58dB4F0875937d38647B5b8431444851D3d;
2645     address private wOwnerTwo   = 0x16aD40534Ce1Ad71586b2aD56BC3915c6d3D0646;
2646     address private wOwnerThree = 0x850656E615c3aCfD1e3afC8AF9d7bB28ddC9E59D;
2647 
2648     uint256 private statusPhase = 0;
2649 
2650     uint256[] tokenIds;
2651 
2652     bytes32 public root;
2653     bytes32[] public merkleProof;
2654     uint256 private initSaleWaitList;
2655     uint256 private endSaleWaitList;
2656     uint256 private endSalePublic;
2657 
2658     constructor(
2659         bytes32 _root,
2660         uint256 _initSaleWaitList,
2661         uint256 _endSaleWaitList,
2662         uint256 _endSalePublic
2663     ) ERC721A("SurfJunkies", "SJC") {
2664         setBaseURI("https://gateway.pinata.cloud/ipfs/QmNMC2v1g3ZzHNEUfKyya4KkQYb8Zc7oC9zUHSEVjPvuLK/");
2665         _contractUri = "";
2666         _contractOwner = msg.sender;
2667         root = _root;
2668         initSaleWaitList = _initSaleWaitList;
2669         endSaleWaitList = _endSaleWaitList;
2670         endSalePublic = _endSalePublic;
2671     }
2672 
2673     function phase() public view returns (uint256) {
2674         if (block.timestamp >= initSaleWaitList && block.timestamp <= endSaleWaitList) {
2675             return 0; //For WaitList
2676         }
2677 
2678         if (block.timestamp >= endSaleWaitList && block.timestamp <= endSalePublic) {
2679             return 1; //For Public
2680         }
2681 
2682         return 2; //Not Sale Available
2683     }
2684 
2685     function conditionPrice() public view returns (uint256) {
2686         uint256 phaseTemp = phase();
2687         if (phaseTemp == 0) {
2688             return _nftEtherValueWaitList;
2689         }
2690 
2691         if (phaseTemp == 1 || phaseTemp == 2) {
2692             return _nftEtherValue;
2693         }
2694     }
2695 
2696     function setNewTimesSales(uint256 _initSaleWaitList, uint256 _endSaleWaitList, uint256 _endSalePublic) public onlyOwner {
2697         require(_endSaleWaitList > _initSaleWaitList, "Data Inicial de venda publica deve ser menor que da data de venda da WaitList");
2698         require(_endSalePublic > _endSaleWaitList, "Data Final de venda publica deve ser menor que da data final de venda da WaitList");
2699         initSaleWaitList = _initSaleWaitList;
2700         endSaleWaitList = _endSaleWaitList;
2701         endSalePublic = _endSalePublic;
2702     }
2703 
2704     function isValid(bytes32[] memory proof, bytes32 leaf) public view returns (bool) {
2705         return MerkleProof.verify(proof, root, leaf);
2706     }
2707     
2708     function setRootKey(bytes32 _newRootKey) public onlyOwner {
2709         root = _newRootKey;
2710     }
2711 
2712     function _baseURI() internal view virtual override returns (string memory) {
2713         return baseURI;
2714     }
2715 
2716     function setBaseURI(string memory _newBaseURI) public onlyOwner {
2717         baseURI = _newBaseURI;
2718     }
2719 
2720     function setMaxMintAmount(uint256 _maxMintAmount) public onlyOwner {
2721         maxMintAmount = _maxMintAmount;
2722     }
2723 
2724     function pause(bool _state) public onlyOwner {
2725         paused = _state;
2726     }
2727 
2728     function setMaxSupply(uint256 _maxSupply) public onlyOwner {
2729         maxSupply = _maxSupply;
2730     }
2731 
2732     function setNftEtherValue(uint256 nftEtherValue) public onlyOwner {
2733         _nftEtherValue = nftEtherValue;
2734     }
2735 
2736     function setNftEtherValueWaitList(uint256 _nftEtherValue) public onlyOwner {
2737         _nftEtherValueWaitList = _nftEtherValue;
2738     }
2739 
2740     function getQtdAvailableTokens() public view returns (uint256) {
2741         if(_numAvailableTokens > 0) {
2742             return _numAvailableTokens;
2743         }
2744         return maxSupply;
2745     }
2746 
2747     function getMaxSupply() public view returns (uint) {
2748         return maxSupply;
2749     }
2750 
2751     function getNftEtherValue() public view returns (uint256) {
2752         return _nftEtherValue;
2753     }
2754 
2755     function getAddressLastMintedTokenId(address wallet) public view returns (uint256) {
2756         return _addressLastMintedTokenId[wallet];
2757     }
2758 
2759     function getMaxMintAmount() public view returns (uint256) {
2760         return maxMintAmount;
2761     }
2762 
2763     function getBaseURI() public view returns (string memory) {
2764         return baseURI;
2765     }
2766 
2767     function getNFTURI(uint256 tokenId) public view returns(string memory) {
2768         return string(abi.encodePacked(baseURI, Strings.toString(tokenId), baseExtension));
2769     }
2770 
2771     function isPaused() public view returns (bool) {
2772         return paused;
2773     }
2774 
2775     function mintPublic(
2776         uint256 _mintAmount,
2777         address payable endUser
2778     ) public payable {
2779         require(phase() == 1, "Mint Public desativado");
2780         require(!paused, "O contrato pausado");
2781         uint256 supply = totalSupply();
2782         require(_mintAmount > 0, "Precisa mintar pelo menos 1 NFT");
2783         require(_mintAmount + balanceOf(endUser) <= maxMintAmount, "Quantidade limite de mint por carteira excedida");
2784         require(supply + _mintAmount <= maxSupply, "Quantidade limite de NFT excedida");
2785 
2786         split(_mintAmount);
2787 
2788         uint256 updatedNumAvailableTokens = maxSupply - totalSupply();
2789 
2790         for (uint256 i = 1; i <= _mintAmount; i++) {
2791             _safeMint(endUser, 1);
2792             uint256 newIdToken = supply + 1;
2793             tokenURI(newIdToken);
2794             --updatedNumAvailableTokens;
2795             _addressLastMintedTokenId[endUser] = i;
2796         }
2797         _numAvailableTokens = updatedNumAvailableTokens;
2798     }
2799 
2800     function mintWaitlist(
2801         uint256 _mintAmount,
2802         address payable endUser,
2803         bytes32[] memory proof
2804     ) public payable {
2805         require(phase() == 0, "Mint WaitList desativado");
2806         require(!paused, "O contrato pausado");
2807         uint256 supply = totalSupply();
2808         require(_mintAmount > 0, "Precisa mintar pelo menos 1 NFT");
2809         require(_mintAmount + balanceOf(endUser) <= maxMintAmountWaitList, "Quantidade limite de mint por carteira excedida");
2810         require(supply + _mintAmount <= maxSupply, "Quantidade limite de NFT excedida");
2811         require(isValid(proof, keccak256(abi.encodePacked(endUser))), "Voce nao esta na WaitList");
2812 
2813         split(_mintAmount);
2814 
2815         uint256 updatedNumAvailableTokens = maxSupply - totalSupply();
2816 
2817         for (uint256 i = 1; i <= _mintAmount; i++) {
2818             _safeMint(endUser, 1);
2819             uint256 newIdToken = supply + 1;
2820             tokenURI(newIdToken);
2821             --updatedNumAvailableTokens;
2822             _addressLastMintedTokenId[endUser] = i;
2823         }
2824         _numAvailableTokens = updatedNumAvailableTokens;
2825     }
2826 
2827     function AirDrop(
2828         address[] memory endUser,
2829         uint256[] memory amount
2830     ) public onlyOwner {
2831         require(!paused, "O contrato pausado");
2832         require(endUser.length == amount.length, "Matrizes invalidas");
2833         tokenIds = new uint256[](endUser.length);
2834 
2835         uint256 updatedNumAvailableTokens = maxSupply - totalSupply();
2836 
2837         for (uint i = 0; i < endUser.length; i++) {
2838             uint256 supply = totalSupply();
2839             _safeMint(endUser[i], 1);
2840             uint256 newIdToken = supply + 1;
2841             tokenURI(newIdToken);
2842             --updatedNumAvailableTokens;
2843             _addressLastMintedTokenId[endUser[i]] = i;
2844         }
2845     }
2846 
2847     function contractURI() external view returns (string memory) {
2848         return _contractUri;
2849     }
2850 
2851     function setContractURI(string memory contractURI_) external onlyOwner {
2852         _contractUri = contractURI_;
2853     }
2854 
2855     function tokenURI(uint256 tokenId)
2856         public
2857         view
2858         virtual
2859         returns (string memory)
2860     {
2861         require(
2862         _exists(tokenId),
2863         "ERC721Metadata: URI query for nonexistent token"
2864         );
2865 
2866         string memory currentBaseURI = _baseURI();
2867         return bytes(currentBaseURI).length > 0
2868             ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
2869             : "";
2870     }
2871 
2872     function split(uint256 _mintAmount) public payable {
2873         uint256 _nftEtherValueTemp = conditionPrice();
2874 
2875         require(msg.value >= (_nftEtherValueTemp * _mintAmount), "Valor da mintagem diferente do valor definido no contrato");
2876         
2877         payable(wSplit).transfer(address(this).balance);
2878     }
2879 
2880     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2881         super.setApprovalForAll(operator, approved);
2882     }
2883 
2884     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2885         super.approve(operator, tokenId);
2886     }
2887 
2888     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2889         super.transferFrom(from, to, tokenId);
2890     }
2891 
2892     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2893         super.safeTransferFrom(from, to, tokenId);
2894     }
2895 
2896     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
2897         public
2898         override
2899         onlyAllowedOperator(from)
2900     {
2901         super.safeTransferFrom(from, to, tokenId, data);
2902     }
2903 
2904     function destroy() public onlyOwner {
2905         require(msg.sender == _contractOwner, "Only the owner can destroy the contract");
2906         selfdestruct(payable(_contractOwner));
2907     }
2908 
2909     function burn(uint256 _tokenId) external {
2910         require(ownerOf(_tokenId) == msg.sender || msg.sender == _contractOwner, "You can't revoke this token");
2911         _burn(_tokenId);
2912     }
2913 
2914     fallback() external payable {
2915         revert();
2916     }
2917 
2918     receive() external payable {
2919         uint256 amountRoyaltiesOne = msg.value * royaltiesOne / 100;
2920         payable(wOwnerOne).transfer(amountRoyaltiesOne);
2921 
2922         uint256 amountRoyaltiesTwo = msg.value * royaltiesTwo / 100;
2923         payable(wOwnerTwo).transfer(amountRoyaltiesTwo);
2924 
2925         payable(wOwnerThree).transfer(address(this).balance);
2926     }
2927 }