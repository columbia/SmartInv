1 // File: utils.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 
7 
8 library Utils {
9     function substring(string memory str, uint startIndex, uint endIndex) internal pure returns (string memory) {
10         bytes memory strBytes = bytes(str);
11         bytes memory result = new bytes(endIndex-startIndex);
12         for(uint i = startIndex; i < endIndex; i++) {
13             result[i-startIndex] = strBytes[i];
14         }
15         return string(result);
16     }
17 
18     function replaceInString(string memory sourceText, string memory search, string memory replacement) internal pure returns (string memory) {
19         bytes memory sourceBytes = bytes(sourceText);
20         bytes memory searchBytes = bytes(search);
21 
22         if (searchBytes.length > sourceBytes.length) {
23             return sourceText;
24         }
25 
26         // Searching for the given string
27         bool found = false;
28         uint256 position = 0;
29         for (uint256 i = 0; i <= sourceBytes.length - searchBytes.length; i++) {
30             bool flag = true;
31             for (uint256 j = 0; j < searchBytes.length; j++)
32                 if (sourceBytes [i + j] != searchBytes [j]) {
33                     flag = false;
34                     break;
35                 }
36             if (flag) {
37                 found = true;
38                 position = i;
39                 break;
40             }
41         }
42 
43         // Replace to the given replacement string
44         if (found) {
45             string memory firstHalf = substring(sourceText, 0, position);
46             string memory secondHalf = substring(sourceText, position + searchBytes.length, sourceBytes.length);
47 
48             return string.concat(firstHalf, replacement, secondHalf);
49         }
50         
51         return sourceText;
52     }
53 
54     function uintToString(uint v) internal pure returns (string memory) {
55         if (v == 0) return "0";
56         uint maxlength = 100;
57         bytes memory reversed = new bytes(maxlength);
58         uint i = 0;
59         while (v != 0) {
60             uint remainder = v % 10;
61             v = v / 10;
62             reversed[i++] = bytes1(uint8(48 + remainder));
63         }
64         bytes memory s = new bytes(i); // i + 1 is inefficient
65         for (uint j = 0; j < i; j++) {
66             s[j] = reversed[i - j - 1]; // to avoid the off-by-one error
67         }
68         string memory str = string(s);  // memory isn't implicitly convertible to storage
69         return str;
70     }
71 }
72 // File: @openzeppelin/contracts/utils/Base64.sol
73 
74 
75 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Base64.sol)
76 
77 pragma solidity ^0.8.0;
78 
79 /**
80  * @dev Provides a set of functions to operate with Base64 strings.
81  *
82  * _Available since v4.5._
83  */
84 library Base64 {
85     /**
86      * @dev Base64 Encoding/Decoding Table
87      */
88     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
89 
90     /**
91      * @dev Converts a `bytes` to its Bytes64 `string` representation.
92      */
93     function encode(bytes memory data) internal pure returns (string memory) {
94         /**
95          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
96          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
97          */
98         if (data.length == 0) return "";
99 
100         // Loads the table into memory
101         string memory table = _TABLE;
102 
103         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
104         // and split into 4 numbers of 6 bits.
105         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
106         // - `data.length + 2`  -> Round up
107         // - `/ 3`              -> Number of 3-bytes chunks
108         // - `4 *`              -> 4 characters for each chunk
109         string memory result = new string(4 * ((data.length + 2) / 3));
110 
111         /// @solidity memory-safe-assembly
112         assembly {
113             // Prepare the lookup table (skip the first "length" byte)
114             let tablePtr := add(table, 1)
115 
116             // Prepare result pointer, jump over length
117             let resultPtr := add(result, 32)
118 
119             // Run over the input, 3 bytes at a time
120             for {
121                 let dataPtr := data
122                 let endPtr := add(data, mload(data))
123             } lt(dataPtr, endPtr) {
124 
125             } {
126                 // Advance 3 bytes
127                 dataPtr := add(dataPtr, 3)
128                 let input := mload(dataPtr)
129 
130                 // To write each character, shift the 3 bytes (18 bits) chunk
131                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
132                 // and apply logical AND with 0x3F which is the number of
133                 // the previous character in the ASCII table prior to the Base64 Table
134                 // The result is then added to the table to get the character to write,
135                 // and finally write it in the result pointer but with a left shift
136                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
137 
138                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
139                 resultPtr := add(resultPtr, 1) // Advance
140 
141                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
142                 resultPtr := add(resultPtr, 1) // Advance
143 
144                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
145                 resultPtr := add(resultPtr, 1) // Advance
146 
147                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
148                 resultPtr := add(resultPtr, 1) // Advance
149             }
150 
151             // When data `bytes` is not exactly 3 bytes long
152             // it is padded with `=` characters at the end
153             switch mod(mload(data), 3)
154             case 1 {
155                 mstore8(sub(resultPtr, 1), 0x3d)
156                 mstore8(sub(resultPtr, 2), 0x3d)
157             }
158             case 2 {
159                 mstore8(sub(resultPtr, 1), 0x3d)
160             }
161         }
162 
163         return result;
164     }
165 }
166 
167 // File: operator-filter-registry/src/lib/Constants.sol
168 
169 
170 pragma solidity ^0.8.13;
171 
172 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
173 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
174 
175 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
176 
177 
178 pragma solidity ^0.8.13;
179 
180 interface IOperatorFilterRegistry {
181     /**
182      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
183      *         true if supplied registrant address is not registered.
184      */
185     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
186 
187     /**
188      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
189      */
190     function register(address registrant) external;
191 
192     /**
193      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
194      */
195     function registerAndSubscribe(address registrant, address subscription) external;
196 
197     /**
198      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
199      *         address without subscribing.
200      */
201     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
202 
203     /**
204      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
205      *         Note that this does not remove any filtered addresses or codeHashes.
206      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
207      */
208     function unregister(address addr) external;
209 
210     /**
211      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
212      */
213     function updateOperator(address registrant, address operator, bool filtered) external;
214 
215     /**
216      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
217      */
218     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
219 
220     /**
221      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
222      */
223     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
224 
225     /**
226      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
227      */
228     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
229 
230     /**
231      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
232      *         subscription if present.
233      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
234      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
235      *         used.
236      */
237     function subscribe(address registrant, address registrantToSubscribe) external;
238 
239     /**
240      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
241      */
242     function unsubscribe(address registrant, bool copyExistingEntries) external;
243 
244     /**
245      * @notice Get the subscription address of a given registrant, if any.
246      */
247     function subscriptionOf(address addr) external returns (address registrant);
248 
249     /**
250      * @notice Get the set of addresses subscribed to a given registrant.
251      *         Note that order is not guaranteed as updates are made.
252      */
253     function subscribers(address registrant) external returns (address[] memory);
254 
255     /**
256      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
257      *         Note that order is not guaranteed as updates are made.
258      */
259     function subscriberAt(address registrant, uint256 index) external returns (address);
260 
261     /**
262      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
263      */
264     function copyEntriesOf(address registrant, address registrantToCopy) external;
265 
266     /**
267      * @notice Returns true if operator is filtered by a given address or its subscription.
268      */
269     function isOperatorFiltered(address registrant, address operator) external returns (bool);
270 
271     /**
272      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
273      */
274     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
275 
276     /**
277      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
278      */
279     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
280 
281     /**
282      * @notice Returns a list of filtered operators for a given address or its subscription.
283      */
284     function filteredOperators(address addr) external returns (address[] memory);
285 
286     /**
287      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
288      *         Note that order is not guaranteed as updates are made.
289      */
290     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
291 
292     /**
293      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
294      *         its subscription.
295      *         Note that order is not guaranteed as updates are made.
296      */
297     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
298 
299     /**
300      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
301      *         its subscription.
302      *         Note that order is not guaranteed as updates are made.
303      */
304     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
305 
306     /**
307      * @notice Returns true if an address has registered
308      */
309     function isRegistered(address addr) external returns (bool);
310 
311     /**
312      * @dev Convenience method to compute the code hash of an arbitrary contract
313      */
314     function codeHashOf(address addr) external returns (bytes32);
315 }
316 
317 // File: operator-filter-registry/src/OperatorFilterer.sol
318 
319 
320 pragma solidity ^0.8.13;
321 
322 
323 /**
324  * @title  OperatorFilterer
325  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
326  *         registrant's entries in the OperatorFilterRegistry.
327  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
328  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
329  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
330  *         Please note that if your token contract does not provide an owner with EIP-173, it must provide
331  *         administration methods on the contract itself to interact with the registry otherwise the subscription
332  *         will be locked to the options set during construction.
333  */
334 
335 abstract contract OperatorFilterer {
336     /// @dev Emitted when an operator is not allowed.
337     error OperatorNotAllowed(address operator);
338 
339     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
340         IOperatorFilterRegistry(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS);
341 
342     /// @dev The constructor that is called when the contract is being deployed.
343     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
344         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
345         // will not revert, but the contract will need to be registered with the registry once it is deployed in
346         // order for the modifier to filter addresses.
347         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
348             if (subscribe) {
349                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
350             } else {
351                 if (subscriptionOrRegistrantToCopy != address(0)) {
352                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
353                 } else {
354                     OPERATOR_FILTER_REGISTRY.register(address(this));
355                 }
356             }
357         }
358     }
359 
360     /**
361      * @dev A helper function to check if an operator is allowed.
362      */
363     modifier onlyAllowedOperator(address from) virtual {
364         // Allow spending tokens from addresses with balance
365         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
366         // from an EOA.
367         if (from != msg.sender) {
368             _checkFilterOperator(msg.sender);
369         }
370         _;
371     }
372 
373     /**
374      * @dev A helper function to check if an operator approval is allowed.
375      */
376     modifier onlyAllowedOperatorApproval(address operator) virtual {
377         _checkFilterOperator(operator);
378         _;
379     }
380 
381     /**
382      * @dev A helper function to check if an operator is allowed.
383      */
384     function _checkFilterOperator(address operator) internal view virtual {
385         // Check registry code length to facilitate testing in environments without a deployed registry.
386         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
387             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
388             // may specify their own OperatorFilterRegistry implementations, which may behave differently
389             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
390                 revert OperatorNotAllowed(operator);
391             }
392         }
393     }
394 }
395 
396 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
397 
398 
399 pragma solidity ^0.8.13;
400 
401 
402 /**
403  * @title  DefaultOperatorFilterer
404  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
405  * @dev    Please note that if your token contract does not provide an owner with EIP-173, it must provide
406  *         administration methods on the contract itself to interact with the registry otherwise the subscription
407  *         will be locked to the options set during construction.
408  */
409 
410 abstract contract DefaultOperatorFilterer is OperatorFilterer {
411     /// @dev The constructor that is called when the contract is being deployed.
412     constructor() OperatorFilterer(CANONICAL_CORI_SUBSCRIPTION, true) {}
413 }
414 
415 // File: @openzeppelin/contracts/utils/math/SignedMath.sol
416 
417 
418 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/SignedMath.sol)
419 
420 pragma solidity ^0.8.0;
421 
422 /**
423  * @dev Standard signed math utilities missing in the Solidity language.
424  */
425 library SignedMath {
426     /**
427      * @dev Returns the largest of two signed numbers.
428      */
429     function max(int256 a, int256 b) internal pure returns (int256) {
430         return a > b ? a : b;
431     }
432 
433     /**
434      * @dev Returns the smallest of two signed numbers.
435      */
436     function min(int256 a, int256 b) internal pure returns (int256) {
437         return a < b ? a : b;
438     }
439 
440     /**
441      * @dev Returns the average of two signed numbers without overflow.
442      * The result is rounded towards zero.
443      */
444     function average(int256 a, int256 b) internal pure returns (int256) {
445         // Formula from the book "Hacker's Delight"
446         int256 x = (a & b) + ((a ^ b) >> 1);
447         return x + (int256(uint256(x) >> 255) & (a ^ b));
448     }
449 
450     /**
451      * @dev Returns the absolute unsigned value of a signed value.
452      */
453     function abs(int256 n) internal pure returns (uint256) {
454         unchecked {
455             // must be unchecked in order to support `n = type(int256).min`
456             return uint256(n >= 0 ? n : -n);
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/utils/math/Math.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.9.0) (utils/math/Math.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 /**
469  * @dev Standard math utilities missing in the Solidity language.
470  */
471 library Math {
472     enum Rounding {
473         Down, // Toward negative infinity
474         Up, // Toward infinity
475         Zero // Toward zero
476     }
477 
478     /**
479      * @dev Returns the largest of two numbers.
480      */
481     function max(uint256 a, uint256 b) internal pure returns (uint256) {
482         return a > b ? a : b;
483     }
484 
485     /**
486      * @dev Returns the smallest of two numbers.
487      */
488     function min(uint256 a, uint256 b) internal pure returns (uint256) {
489         return a < b ? a : b;
490     }
491 
492     /**
493      * @dev Returns the average of two numbers. The result is rounded towards
494      * zero.
495      */
496     function average(uint256 a, uint256 b) internal pure returns (uint256) {
497         // (a + b) / 2 can overflow.
498         return (a & b) + (a ^ b) / 2;
499     }
500 
501     /**
502      * @dev Returns the ceiling of the division of two numbers.
503      *
504      * This differs from standard division with `/` in that it rounds up instead
505      * of rounding down.
506      */
507     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
508         // (a + b - 1) / b can overflow on addition, so we distribute.
509         return a == 0 ? 0 : (a - 1) / b + 1;
510     }
511 
512     /**
513      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
514      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
515      * with further edits by Uniswap Labs also under MIT license.
516      */
517     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
518         unchecked {
519             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
520             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
521             // variables such that product = prod1 * 2^256 + prod0.
522             uint256 prod0; // Least significant 256 bits of the product
523             uint256 prod1; // Most significant 256 bits of the product
524             assembly {
525                 let mm := mulmod(x, y, not(0))
526                 prod0 := mul(x, y)
527                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
528             }
529 
530             // Handle non-overflow cases, 256 by 256 division.
531             if (prod1 == 0) {
532                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
533                 // The surrounding unchecked block does not change this fact.
534                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
535                 return prod0 / denominator;
536             }
537 
538             // Make sure the result is less than 2^256. Also prevents denominator == 0.
539             require(denominator > prod1, "Math: mulDiv overflow");
540 
541             ///////////////////////////////////////////////
542             // 512 by 256 division.
543             ///////////////////////////////////////////////
544 
545             // Make division exact by subtracting the remainder from [prod1 prod0].
546             uint256 remainder;
547             assembly {
548                 // Compute remainder using mulmod.
549                 remainder := mulmod(x, y, denominator)
550 
551                 // Subtract 256 bit number from 512 bit number.
552                 prod1 := sub(prod1, gt(remainder, prod0))
553                 prod0 := sub(prod0, remainder)
554             }
555 
556             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
557             // See https://cs.stackexchange.com/q/138556/92363.
558 
559             // Does not overflow because the denominator cannot be zero at this stage in the function.
560             uint256 twos = denominator & (~denominator + 1);
561             assembly {
562                 // Divide denominator by twos.
563                 denominator := div(denominator, twos)
564 
565                 // Divide [prod1 prod0] by twos.
566                 prod0 := div(prod0, twos)
567 
568                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
569                 twos := add(div(sub(0, twos), twos), 1)
570             }
571 
572             // Shift in bits from prod1 into prod0.
573             prod0 |= prod1 * twos;
574 
575             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
576             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
577             // four bits. That is, denominator * inv = 1 mod 2^4.
578             uint256 inverse = (3 * denominator) ^ 2;
579 
580             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
581             // in modular arithmetic, doubling the correct bits in each step.
582             inverse *= 2 - denominator * inverse; // inverse mod 2^8
583             inverse *= 2 - denominator * inverse; // inverse mod 2^16
584             inverse *= 2 - denominator * inverse; // inverse mod 2^32
585             inverse *= 2 - denominator * inverse; // inverse mod 2^64
586             inverse *= 2 - denominator * inverse; // inverse mod 2^128
587             inverse *= 2 - denominator * inverse; // inverse mod 2^256
588 
589             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
590             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
591             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
592             // is no longer required.
593             result = prod0 * inverse;
594             return result;
595         }
596     }
597 
598     /**
599      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
600      */
601     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
602         uint256 result = mulDiv(x, y, denominator);
603         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
604             result += 1;
605         }
606         return result;
607     }
608 
609     /**
610      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
611      *
612      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
613      */
614     function sqrt(uint256 a) internal pure returns (uint256) {
615         if (a == 0) {
616             return 0;
617         }
618 
619         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
620         //
621         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
622         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
623         //
624         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
625         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
626         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
627         //
628         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
629         uint256 result = 1 << (log2(a) >> 1);
630 
631         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
632         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
633         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
634         // into the expected uint128 result.
635         unchecked {
636             result = (result + a / result) >> 1;
637             result = (result + a / result) >> 1;
638             result = (result + a / result) >> 1;
639             result = (result + a / result) >> 1;
640             result = (result + a / result) >> 1;
641             result = (result + a / result) >> 1;
642             result = (result + a / result) >> 1;
643             return min(result, a / result);
644         }
645     }
646 
647     /**
648      * @notice Calculates sqrt(a), following the selected rounding direction.
649      */
650     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
651         unchecked {
652             uint256 result = sqrt(a);
653             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
654         }
655     }
656 
657     /**
658      * @dev Return the log in base 2, rounded down, of a positive value.
659      * Returns 0 if given 0.
660      */
661     function log2(uint256 value) internal pure returns (uint256) {
662         uint256 result = 0;
663         unchecked {
664             if (value >> 128 > 0) {
665                 value >>= 128;
666                 result += 128;
667             }
668             if (value >> 64 > 0) {
669                 value >>= 64;
670                 result += 64;
671             }
672             if (value >> 32 > 0) {
673                 value >>= 32;
674                 result += 32;
675             }
676             if (value >> 16 > 0) {
677                 value >>= 16;
678                 result += 16;
679             }
680             if (value >> 8 > 0) {
681                 value >>= 8;
682                 result += 8;
683             }
684             if (value >> 4 > 0) {
685                 value >>= 4;
686                 result += 4;
687             }
688             if (value >> 2 > 0) {
689                 value >>= 2;
690                 result += 2;
691             }
692             if (value >> 1 > 0) {
693                 result += 1;
694             }
695         }
696         return result;
697     }
698 
699     /**
700      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
701      * Returns 0 if given 0.
702      */
703     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
704         unchecked {
705             uint256 result = log2(value);
706             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
707         }
708     }
709 
710     /**
711      * @dev Return the log in base 10, rounded down, of a positive value.
712      * Returns 0 if given 0.
713      */
714     function log10(uint256 value) internal pure returns (uint256) {
715         uint256 result = 0;
716         unchecked {
717             if (value >= 10 ** 64) {
718                 value /= 10 ** 64;
719                 result += 64;
720             }
721             if (value >= 10 ** 32) {
722                 value /= 10 ** 32;
723                 result += 32;
724             }
725             if (value >= 10 ** 16) {
726                 value /= 10 ** 16;
727                 result += 16;
728             }
729             if (value >= 10 ** 8) {
730                 value /= 10 ** 8;
731                 result += 8;
732             }
733             if (value >= 10 ** 4) {
734                 value /= 10 ** 4;
735                 result += 4;
736             }
737             if (value >= 10 ** 2) {
738                 value /= 10 ** 2;
739                 result += 2;
740             }
741             if (value >= 10 ** 1) {
742                 result += 1;
743             }
744         }
745         return result;
746     }
747 
748     /**
749      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
750      * Returns 0 if given 0.
751      */
752     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
753         unchecked {
754             uint256 result = log10(value);
755             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
756         }
757     }
758 
759     /**
760      * @dev Return the log in base 256, rounded down, of a positive value.
761      * Returns 0 if given 0.
762      *
763      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
764      */
765     function log256(uint256 value) internal pure returns (uint256) {
766         uint256 result = 0;
767         unchecked {
768             if (value >> 128 > 0) {
769                 value >>= 128;
770                 result += 16;
771             }
772             if (value >> 64 > 0) {
773                 value >>= 64;
774                 result += 8;
775             }
776             if (value >> 32 > 0) {
777                 value >>= 32;
778                 result += 4;
779             }
780             if (value >> 16 > 0) {
781                 value >>= 16;
782                 result += 2;
783             }
784             if (value >> 8 > 0) {
785                 result += 1;
786             }
787         }
788         return result;
789     }
790 
791     /**
792      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
793      * Returns 0 if given 0.
794      */
795     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
796         unchecked {
797             uint256 result = log256(value);
798             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
799         }
800     }
801 }
802 
803 // File: @openzeppelin/contracts/utils/Strings.sol
804 
805 
806 // OpenZeppelin Contracts (last updated v4.9.0) (utils/Strings.sol)
807 
808 pragma solidity ^0.8.0;
809 
810 
811 
812 /**
813  * @dev String operations.
814  */
815 library Strings {
816     bytes16 private constant _SYMBOLS = "0123456789abcdef";
817     uint8 private constant _ADDRESS_LENGTH = 20;
818 
819     /**
820      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
821      */
822     function toString(uint256 value) internal pure returns (string memory) {
823         unchecked {
824             uint256 length = Math.log10(value) + 1;
825             string memory buffer = new string(length);
826             uint256 ptr;
827             /// @solidity memory-safe-assembly
828             assembly {
829                 ptr := add(buffer, add(32, length))
830             }
831             while (true) {
832                 ptr--;
833                 /// @solidity memory-safe-assembly
834                 assembly {
835                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
836                 }
837                 value /= 10;
838                 if (value == 0) break;
839             }
840             return buffer;
841         }
842     }
843 
844     /**
845      * @dev Converts a `int256` to its ASCII `string` decimal representation.
846      */
847     function toString(int256 value) internal pure returns (string memory) {
848         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
849     }
850 
851     /**
852      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
853      */
854     function toHexString(uint256 value) internal pure returns (string memory) {
855         unchecked {
856             return toHexString(value, Math.log256(value) + 1);
857         }
858     }
859 
860     /**
861      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
862      */
863     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
864         bytes memory buffer = new bytes(2 * length + 2);
865         buffer[0] = "0";
866         buffer[1] = "x";
867         for (uint256 i = 2 * length + 1; i > 1; --i) {
868             buffer[i] = _SYMBOLS[value & 0xf];
869             value >>= 4;
870         }
871         require(value == 0, "Strings: hex length insufficient");
872         return string(buffer);
873     }
874 
875     /**
876      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
877      */
878     function toHexString(address addr) internal pure returns (string memory) {
879         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
880     }
881 
882     /**
883      * @dev Returns true if the two strings are equal.
884      */
885     function equal(string memory a, string memory b) internal pure returns (bool) {
886         return keccak256(bytes(a)) == keccak256(bytes(b));
887     }
888 }
889 
890 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
891 
892 
893 // OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)
894 
895 pragma solidity ^0.8.0;
896 
897 /**
898  * @dev Contract module that helps prevent reentrant calls to a function.
899  *
900  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
901  * available, which can be applied to functions to make sure there are no nested
902  * (reentrant) calls to them.
903  *
904  * Note that because there is a single `nonReentrant` guard, functions marked as
905  * `nonReentrant` may not call one another. This can be worked around by making
906  * those functions `private`, and then adding `external` `nonReentrant` entry
907  * points to them.
908  *
909  * TIP: If you would like to learn more about reentrancy and alternative ways
910  * to protect against it, check out our blog post
911  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
912  */
913 abstract contract ReentrancyGuard {
914     // Booleans are more expensive than uint256 or any type that takes up a full
915     // word because each write operation emits an extra SLOAD to first read the
916     // slot's contents, replace the bits taken up by the boolean, and then write
917     // back. This is the compiler's defense against contract upgrades and
918     // pointer aliasing, and it cannot be disabled.
919 
920     // The values being non-zero value makes deployment a bit more expensive,
921     // but in exchange the refund on every call to nonReentrant will be lower in
922     // amount. Since refunds are capped to a percentage of the total
923     // transaction's gas, it is best to keep them low in cases like this one, to
924     // increase the likelihood of the full refund coming into effect.
925     uint256 private constant _NOT_ENTERED = 1;
926     uint256 private constant _ENTERED = 2;
927 
928     uint256 private _status;
929 
930     constructor() {
931         _status = _NOT_ENTERED;
932     }
933 
934     /**
935      * @dev Prevents a contract from calling itself, directly or indirectly.
936      * Calling a `nonReentrant` function from another `nonReentrant`
937      * function is not supported. It is possible to prevent this from happening
938      * by making the `nonReentrant` function external, and making it call a
939      * `private` function that does the actual work.
940      */
941     modifier nonReentrant() {
942         _nonReentrantBefore();
943         _;
944         _nonReentrantAfter();
945     }
946 
947     function _nonReentrantBefore() private {
948         // On the first call to nonReentrant, _status will be _NOT_ENTERED
949         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
950 
951         // Any calls to nonReentrant after this point will fail
952         _status = _ENTERED;
953     }
954 
955     function _nonReentrantAfter() private {
956         // By storing the original value once again, a refund is triggered (see
957         // https://eips.ethereum.org/EIPS/eip-2200)
958         _status = _NOT_ENTERED;
959     }
960 
961     /**
962      * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
963      * `nonReentrant` function in the call stack.
964      */
965     function _reentrancyGuardEntered() internal view returns (bool) {
966         return _status == _ENTERED;
967     }
968 }
969 
970 // File: @openzeppelin/contracts/utils/Context.sol
971 
972 
973 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
974 
975 pragma solidity ^0.8.0;
976 
977 /**
978  * @dev Provides information about the current execution context, including the
979  * sender of the transaction and its data. While these are generally available
980  * via msg.sender and msg.data, they should not be accessed in such a direct
981  * manner, since when dealing with meta-transactions the account sending and
982  * paying for execution may not be the actual sender (as far as an application
983  * is concerned).
984  *
985  * This contract is only required for intermediate, library-like contracts.
986  */
987 abstract contract Context {
988     function _msgSender() internal view virtual returns (address) {
989         return msg.sender;
990     }
991 
992     function _msgData() internal view virtual returns (bytes calldata) {
993         return msg.data;
994     }
995 }
996 
997 // File: @openzeppelin/contracts/security/Pausable.sol
998 
999 
1000 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
1001 
1002 pragma solidity ^0.8.0;
1003 
1004 
1005 /**
1006  * @dev Contract module which allows children to implement an emergency stop
1007  * mechanism that can be triggered by an authorized account.
1008  *
1009  * This module is used through inheritance. It will make available the
1010  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
1011  * the functions of your contract. Note that they will not be pausable by
1012  * simply including this module, only once the modifiers are put in place.
1013  */
1014 abstract contract Pausable is Context {
1015     /**
1016      * @dev Emitted when the pause is triggered by `account`.
1017      */
1018     event Paused(address account);
1019 
1020     /**
1021      * @dev Emitted when the pause is lifted by `account`.
1022      */
1023     event Unpaused(address account);
1024 
1025     bool private _paused;
1026 
1027     /**
1028      * @dev Initializes the contract in unpaused state.
1029      */
1030     constructor() {
1031         _paused = false;
1032     }
1033 
1034     /**
1035      * @dev Modifier to make a function callable only when the contract is not paused.
1036      *
1037      * Requirements:
1038      *
1039      * - The contract must not be paused.
1040      */
1041     modifier whenNotPaused() {
1042         _requireNotPaused();
1043         _;
1044     }
1045 
1046     /**
1047      * @dev Modifier to make a function callable only when the contract is paused.
1048      *
1049      * Requirements:
1050      *
1051      * - The contract must be paused.
1052      */
1053     modifier whenPaused() {
1054         _requirePaused();
1055         _;
1056     }
1057 
1058     /**
1059      * @dev Returns true if the contract is paused, and false otherwise.
1060      */
1061     function paused() public view virtual returns (bool) {
1062         return _paused;
1063     }
1064 
1065     /**
1066      * @dev Throws if the contract is paused.
1067      */
1068     function _requireNotPaused() internal view virtual {
1069         require(!paused(), "Pausable: paused");
1070     }
1071 
1072     /**
1073      * @dev Throws if the contract is not paused.
1074      */
1075     function _requirePaused() internal view virtual {
1076         require(paused(), "Pausable: not paused");
1077     }
1078 
1079     /**
1080      * @dev Triggers stopped state.
1081      *
1082      * Requirements:
1083      *
1084      * - The contract must not be paused.
1085      */
1086     function _pause() internal virtual whenNotPaused {
1087         _paused = true;
1088         emit Paused(_msgSender());
1089     }
1090 
1091     /**
1092      * @dev Returns to normal state.
1093      *
1094      * Requirements:
1095      *
1096      * - The contract must be paused.
1097      */
1098     function _unpause() internal virtual whenPaused {
1099         _paused = false;
1100         emit Unpaused(_msgSender());
1101     }
1102 }
1103 
1104 // File: @openzeppelin/contracts/access/Ownable.sol
1105 
1106 
1107 // OpenZeppelin Contracts (last updated v4.9.0) (access/Ownable.sol)
1108 
1109 pragma solidity ^0.8.0;
1110 
1111 
1112 /**
1113  * @dev Contract module which provides a basic access control mechanism, where
1114  * there is an account (an owner) that can be granted exclusive access to
1115  * specific functions.
1116  *
1117  * By default, the owner account will be the one that deploys the contract. This
1118  * can later be changed with {transferOwnership}.
1119  *
1120  * This module is used through inheritance. It will make available the modifier
1121  * `onlyOwner`, which can be applied to your functions to restrict their use to
1122  * the owner.
1123  */
1124 abstract contract Ownable is Context {
1125     address private _owner;
1126 
1127     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1128 
1129     /**
1130      * @dev Initializes the contract setting the deployer as the initial owner.
1131      */
1132     constructor() {
1133         _transferOwnership(_msgSender());
1134     }
1135 
1136     /**
1137      * @dev Throws if called by any account other than the owner.
1138      */
1139     modifier onlyOwner() {
1140         _checkOwner();
1141         _;
1142     }
1143 
1144     /**
1145      * @dev Returns the address of the current owner.
1146      */
1147     function owner() public view virtual returns (address) {
1148         return _owner;
1149     }
1150 
1151     /**
1152      * @dev Throws if the sender is not the owner.
1153      */
1154     function _checkOwner() internal view virtual {
1155         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1156     }
1157 
1158     /**
1159      * @dev Leaves the contract without owner. It will not be possible to call
1160      * `onlyOwner` functions. Can only be called by the current owner.
1161      *
1162      * NOTE: Renouncing ownership will leave the contract without an owner,
1163      * thereby disabling any functionality that is only available to the owner.
1164      */
1165     function renounceOwnership() public virtual onlyOwner {
1166         _transferOwnership(address(0));
1167     }
1168 
1169     /**
1170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1171      * Can only be called by the current owner.
1172      */
1173     function transferOwnership(address newOwner) public virtual onlyOwner {
1174         require(newOwner != address(0), "Ownable: new owner is the zero address");
1175         _transferOwnership(newOwner);
1176     }
1177 
1178     /**
1179      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1180      * Internal function without access restriction.
1181      */
1182     function _transferOwnership(address newOwner) internal virtual {
1183         address oldOwner = _owner;
1184         _owner = newOwner;
1185         emit OwnershipTransferred(oldOwner, newOwner);
1186     }
1187 }
1188 
1189 // File: erc721a/contracts/IERC721A.sol
1190 
1191 
1192 // ERC721A Contracts v4.2.3
1193 // Creator: Chiru Labs
1194 
1195 pragma solidity ^0.8.4;
1196 
1197 /**
1198  * @dev Interface of ERC721A.
1199  */
1200 interface IERC721A {
1201     /**
1202      * The caller must own the token or be an approved operator.
1203      */
1204     error ApprovalCallerNotOwnerNorApproved();
1205 
1206     /**
1207      * The token does not exist.
1208      */
1209     error ApprovalQueryForNonexistentToken();
1210 
1211     /**
1212      * Cannot query the balance for the zero address.
1213      */
1214     error BalanceQueryForZeroAddress();
1215 
1216     /**
1217      * Cannot mint to the zero address.
1218      */
1219     error MintToZeroAddress();
1220 
1221     /**
1222      * The quantity of tokens minted must be more than zero.
1223      */
1224     error MintZeroQuantity();
1225 
1226     /**
1227      * The token does not exist.
1228      */
1229     error OwnerQueryForNonexistentToken();
1230 
1231     /**
1232      * The caller must own the token or be an approved operator.
1233      */
1234     error TransferCallerNotOwnerNorApproved();
1235 
1236     /**
1237      * The token must be owned by `from`.
1238      */
1239     error TransferFromIncorrectOwner();
1240 
1241     /**
1242      * Cannot safely transfer to a contract that does not implement the
1243      * ERC721Receiver interface.
1244      */
1245     error TransferToNonERC721ReceiverImplementer();
1246 
1247     /**
1248      * Cannot transfer to the zero address.
1249      */
1250     error TransferToZeroAddress();
1251 
1252     /**
1253      * The token does not exist.
1254      */
1255     error URIQueryForNonexistentToken();
1256 
1257     /**
1258      * The `quantity` minted with ERC2309 exceeds the safety limit.
1259      */
1260     error MintERC2309QuantityExceedsLimit();
1261 
1262     /**
1263      * The `extraData` cannot be set on an unintialized ownership slot.
1264      */
1265     error OwnershipNotInitializedForExtraData();
1266 
1267     // =============================================================
1268     //                            STRUCTS
1269     // =============================================================
1270 
1271     struct TokenOwnership {
1272         // The address of the owner.
1273         address addr;
1274         // Stores the start time of ownership with minimal overhead for tokenomics.
1275         uint64 startTimestamp;
1276         // Whether the token has been burned.
1277         bool burned;
1278         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1279         uint24 extraData;
1280     }
1281 
1282     // =============================================================
1283     //                         TOKEN COUNTERS
1284     // =============================================================
1285 
1286     /**
1287      * @dev Returns the total number of tokens in existence.
1288      * Burned tokens will reduce the count.
1289      * To get the total number of tokens minted, please see {_totalMinted}.
1290      */
1291     function totalSupply() external view returns (uint256);
1292 
1293     // =============================================================
1294     //                            IERC165
1295     // =============================================================
1296 
1297     /**
1298      * @dev Returns true if this contract implements the interface defined by
1299      * `interfaceId`. See the corresponding
1300      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1301      * to learn more about how these ids are created.
1302      *
1303      * This function call must use less than 30000 gas.
1304      */
1305     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1306 
1307     // =============================================================
1308     //                            IERC721
1309     // =============================================================
1310 
1311     /**
1312      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1313      */
1314     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1315 
1316     /**
1317      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1318      */
1319     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1320 
1321     /**
1322      * @dev Emitted when `owner` enables or disables
1323      * (`approved`) `operator` to manage all of its assets.
1324      */
1325     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1326 
1327     /**
1328      * @dev Returns the number of tokens in `owner`'s account.
1329      */
1330     function balanceOf(address owner) external view returns (uint256 balance);
1331 
1332     /**
1333      * @dev Returns the owner of the `tokenId` token.
1334      *
1335      * Requirements:
1336      *
1337      * - `tokenId` must exist.
1338      */
1339     function ownerOf(uint256 tokenId) external view returns (address owner);
1340 
1341     /**
1342      * @dev Safely transfers `tokenId` token from `from` to `to`,
1343      * checking first that contract recipients are aware of the ERC721 protocol
1344      * to prevent tokens from being forever locked.
1345      *
1346      * Requirements:
1347      *
1348      * - `from` cannot be the zero address.
1349      * - `to` cannot be the zero address.
1350      * - `tokenId` token must exist and be owned by `from`.
1351      * - If the caller is not `from`, it must be have been allowed to move
1352      * this token by either {approve} or {setApprovalForAll}.
1353      * - If `to` refers to a smart contract, it must implement
1354      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1355      *
1356      * Emits a {Transfer} event.
1357      */
1358     function safeTransferFrom(
1359         address from,
1360         address to,
1361         uint256 tokenId,
1362         bytes calldata data
1363     ) external payable;
1364 
1365     /**
1366      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1367      */
1368     function safeTransferFrom(
1369         address from,
1370         address to,
1371         uint256 tokenId
1372     ) external payable;
1373 
1374     /**
1375      * @dev Transfers `tokenId` from `from` to `to`.
1376      *
1377      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1378      * whenever possible.
1379      *
1380      * Requirements:
1381      *
1382      * - `from` cannot be the zero address.
1383      * - `to` cannot be the zero address.
1384      * - `tokenId` token must be owned by `from`.
1385      * - If the caller is not `from`, it must be approved to move this token
1386      * by either {approve} or {setApprovalForAll}.
1387      *
1388      * Emits a {Transfer} event.
1389      */
1390     function transferFrom(
1391         address from,
1392         address to,
1393         uint256 tokenId
1394     ) external payable;
1395 
1396     /**
1397      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1398      * The approval is cleared when the token is transferred.
1399      *
1400      * Only a single account can be approved at a time, so approving the
1401      * zero address clears previous approvals.
1402      *
1403      * Requirements:
1404      *
1405      * - The caller must own the token or be an approved operator.
1406      * - `tokenId` must exist.
1407      *
1408      * Emits an {Approval} event.
1409      */
1410     function approve(address to, uint256 tokenId) external payable;
1411 
1412     /**
1413      * @dev Approve or remove `operator` as an operator for the caller.
1414      * Operators can call {transferFrom} or {safeTransferFrom}
1415      * for any token owned by the caller.
1416      *
1417      * Requirements:
1418      *
1419      * - The `operator` cannot be the caller.
1420      *
1421      * Emits an {ApprovalForAll} event.
1422      */
1423     function setApprovalForAll(address operator, bool _approved) external;
1424 
1425     /**
1426      * @dev Returns the account approved for `tokenId` token.
1427      *
1428      * Requirements:
1429      *
1430      * - `tokenId` must exist.
1431      */
1432     function getApproved(uint256 tokenId) external view returns (address operator);
1433 
1434     /**
1435      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1436      *
1437      * See {setApprovalForAll}.
1438      */
1439     function isApprovedForAll(address owner, address operator) external view returns (bool);
1440 
1441     // =============================================================
1442     //                        IERC721Metadata
1443     // =============================================================
1444 
1445     /**
1446      * @dev Returns the token collection name.
1447      */
1448     function name() external view returns (string memory);
1449 
1450     /**
1451      * @dev Returns the token collection symbol.
1452      */
1453     function symbol() external view returns (string memory);
1454 
1455     /**
1456      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1457      */
1458     function tokenURI(uint256 tokenId) external view returns (string memory);
1459 
1460     // =============================================================
1461     //                           IERC2309
1462     // =============================================================
1463 
1464     /**
1465      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1466      * (inclusive) is transferred from `from` to `to`, as defined in the
1467      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1468      *
1469      * See {_mintERC2309} for more details.
1470      */
1471     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1472 }
1473 
1474 // File: erc721a/contracts/ERC721A.sol
1475 
1476 
1477 // ERC721A Contracts v4.2.3
1478 // Creator: Chiru Labs
1479 
1480 pragma solidity ^0.8.4;
1481 
1482 
1483 /**
1484  * @dev Interface of ERC721 token receiver.
1485  */
1486 interface ERC721A__IERC721Receiver {
1487     function onERC721Received(
1488         address operator,
1489         address from,
1490         uint256 tokenId,
1491         bytes calldata data
1492     ) external returns (bytes4);
1493 }
1494 
1495 /**
1496  * @title ERC721A
1497  *
1498  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1499  * Non-Fungible Token Standard, including the Metadata extension.
1500  * Optimized for lower gas during batch mints.
1501  *
1502  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1503  * starting from `_startTokenId()`.
1504  *
1505  * Assumptions:
1506  *
1507  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1508  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1509  */
1510 contract ERC721A is IERC721A {
1511     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1512     struct TokenApprovalRef {
1513         address value;
1514     }
1515 
1516     // =============================================================
1517     //                           CONSTANTS
1518     // =============================================================
1519 
1520     // Mask of an entry in packed address data.
1521     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1522 
1523     // The bit position of `numberMinted` in packed address data.
1524     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1525 
1526     // The bit position of `numberBurned` in packed address data.
1527     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1528 
1529     // The bit position of `aux` in packed address data.
1530     uint256 private constant _BITPOS_AUX = 192;
1531 
1532     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1533     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1534 
1535     // The bit position of `startTimestamp` in packed ownership.
1536     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1537 
1538     // The bit mask of the `burned` bit in packed ownership.
1539     uint256 private constant _BITMASK_BURNED = 1 << 224;
1540 
1541     // The bit position of the `nextInitialized` bit in packed ownership.
1542     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1543 
1544     // The bit mask of the `nextInitialized` bit in packed ownership.
1545     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1546 
1547     // The bit position of `extraData` in packed ownership.
1548     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1549 
1550     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1551     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1552 
1553     // The mask of the lower 160 bits for addresses.
1554     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1555 
1556     // The maximum `quantity` that can be minted with {_mintERC2309}.
1557     // This limit is to prevent overflows on the address data entries.
1558     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1559     // is required to cause an overflow, which is unrealistic.
1560     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1561 
1562     // The `Transfer` event signature is given by:
1563     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1564     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1565         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1566 
1567     // =============================================================
1568     //                            STORAGE
1569     // =============================================================
1570 
1571     // The next token ID to be minted.
1572     uint256 private _currentIndex;
1573 
1574     // The number of tokens burned.
1575     uint256 private _burnCounter;
1576 
1577     // Token name
1578     string private _name;
1579 
1580     // Token symbol
1581     string private _symbol;
1582 
1583     // Mapping from token ID to ownership details
1584     // An empty struct value does not necessarily mean the token is unowned.
1585     // See {_packedOwnershipOf} implementation for details.
1586     //
1587     // Bits Layout:
1588     // - [0..159]   `addr`
1589     // - [160..223] `startTimestamp`
1590     // - [224]      `burned`
1591     // - [225]      `nextInitialized`
1592     // - [232..255] `extraData`
1593     mapping(uint256 => uint256) private _packedOwnerships;
1594 
1595     // Mapping owner address to address data.
1596     //
1597     // Bits Layout:
1598     // - [0..63]    `balance`
1599     // - [64..127]  `numberMinted`
1600     // - [128..191] `numberBurned`
1601     // - [192..255] `aux`
1602     mapping(address => uint256) private _packedAddressData;
1603 
1604     // Mapping from token ID to approved address.
1605     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1606 
1607     // Mapping from owner to operator approvals
1608     mapping(address => mapping(address => bool)) private _operatorApprovals;
1609 
1610     // =============================================================
1611     //                          CONSTRUCTOR
1612     // =============================================================
1613 
1614     constructor(string memory name_, string memory symbol_) {
1615         _name = name_;
1616         _symbol = symbol_;
1617         _currentIndex = _startTokenId();
1618     }
1619 
1620     // =============================================================
1621     //                   TOKEN COUNTING OPERATIONS
1622     // =============================================================
1623 
1624     /**
1625      * @dev Returns the starting token ID.
1626      * To change the starting token ID, please override this function.
1627      */
1628     function _startTokenId() internal view virtual returns (uint256) {
1629         return 0;
1630     }
1631 
1632     /**
1633      * @dev Returns the next token ID to be minted.
1634      */
1635     function _nextTokenId() internal view virtual returns (uint256) {
1636         return _currentIndex;
1637     }
1638 
1639     /**
1640      * @dev Returns the total number of tokens in existence.
1641      * Burned tokens will reduce the count.
1642      * To get the total number of tokens minted, please see {_totalMinted}.
1643      */
1644     function totalSupply() public view virtual override returns (uint256) {
1645         // Counter underflow is impossible as _burnCounter cannot be incremented
1646         // more than `_currentIndex - _startTokenId()` times.
1647         unchecked {
1648             return _currentIndex - _burnCounter - _startTokenId();
1649         }
1650     }
1651 
1652     /**
1653      * @dev Returns the total amount of tokens minted in the contract.
1654      */
1655     function _totalMinted() internal view virtual returns (uint256) {
1656         // Counter underflow is impossible as `_currentIndex` does not decrement,
1657         // and it is initialized to `_startTokenId()`.
1658         unchecked {
1659             return _currentIndex - _startTokenId();
1660         }
1661     }
1662 
1663     /**
1664      * @dev Returns the total number of tokens burned.
1665      */
1666     function _totalBurned() internal view virtual returns (uint256) {
1667         return _burnCounter;
1668     }
1669 
1670     // =============================================================
1671     //                    ADDRESS DATA OPERATIONS
1672     // =============================================================
1673 
1674     /**
1675      * @dev Returns the number of tokens in `owner`'s account.
1676      */
1677     function balanceOf(address owner) public view virtual override returns (uint256) {
1678         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1679         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1680     }
1681 
1682     /**
1683      * Returns the number of tokens minted by `owner`.
1684      */
1685     function _numberMinted(address owner) internal view returns (uint256) {
1686         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1687     }
1688 
1689     /**
1690      * Returns the number of tokens burned by or on behalf of `owner`.
1691      */
1692     function _numberBurned(address owner) internal view returns (uint256) {
1693         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1694     }
1695 
1696     /**
1697      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1698      */
1699     function _getAux(address owner) internal view returns (uint64) {
1700         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1701     }
1702 
1703     /**
1704      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1705      * If there are multiple variables, please pack them into a uint64.
1706      */
1707     function _setAux(address owner, uint64 aux) internal virtual {
1708         uint256 packed = _packedAddressData[owner];
1709         uint256 auxCasted;
1710         // Cast `aux` with assembly to avoid redundant masking.
1711         assembly {
1712             auxCasted := aux
1713         }
1714         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1715         _packedAddressData[owner] = packed;
1716     }
1717 
1718     // =============================================================
1719     //                            IERC165
1720     // =============================================================
1721 
1722     /**
1723      * @dev Returns true if this contract implements the interface defined by
1724      * `interfaceId`. See the corresponding
1725      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1726      * to learn more about how these ids are created.
1727      *
1728      * This function call must use less than 30000 gas.
1729      */
1730     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1731         // The interface IDs are constants representing the first 4 bytes
1732         // of the XOR of all function selectors in the interface.
1733         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1734         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1735         return
1736             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1737             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1738             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1739     }
1740 
1741     // =============================================================
1742     //                        IERC721Metadata
1743     // =============================================================
1744 
1745     /**
1746      * @dev Returns the token collection name.
1747      */
1748     function name() public view virtual override returns (string memory) {
1749         return _name;
1750     }
1751 
1752     /**
1753      * @dev Returns the token collection symbol.
1754      */
1755     function symbol() public view virtual override returns (string memory) {
1756         return _symbol;
1757     }
1758 
1759     /**
1760      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1761      */
1762     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1763         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1764 
1765         string memory baseURI = _baseURI();
1766         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1767     }
1768 
1769     /**
1770      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1771      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1772      * by default, it can be overridden in child contracts.
1773      */
1774     function _baseURI() internal view virtual returns (string memory) {
1775         return '';
1776     }
1777 
1778     // =============================================================
1779     //                     OWNERSHIPS OPERATIONS
1780     // =============================================================
1781 
1782     /**
1783      * @dev Returns the owner of the `tokenId` token.
1784      *
1785      * Requirements:
1786      *
1787      * - `tokenId` must exist.
1788      */
1789     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1790         return address(uint160(_packedOwnershipOf(tokenId)));
1791     }
1792 
1793     /**
1794      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1795      * It gradually moves to O(1) as tokens get transferred around over time.
1796      */
1797     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1798         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1799     }
1800 
1801     /**
1802      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1803      */
1804     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1805         return _unpackedOwnership(_packedOwnerships[index]);
1806     }
1807 
1808     /**
1809      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1810      */
1811     function _initializeOwnershipAt(uint256 index) internal virtual {
1812         if (_packedOwnerships[index] == 0) {
1813             _packedOwnerships[index] = _packedOwnershipOf(index);
1814         }
1815     }
1816 
1817     /**
1818      * Returns the packed ownership data of `tokenId`.
1819      */
1820     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1821         uint256 curr = tokenId;
1822 
1823         unchecked {
1824             if (_startTokenId() <= curr)
1825                 if (curr < _currentIndex) {
1826                     uint256 packed = _packedOwnerships[curr];
1827                     // If not burned.
1828                     if (packed & _BITMASK_BURNED == 0) {
1829                         // Invariant:
1830                         // There will always be an initialized ownership slot
1831                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1832                         // before an unintialized ownership slot
1833                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1834                         // Hence, `curr` will not underflow.
1835                         //
1836                         // We can directly compare the packed value.
1837                         // If the address is zero, packed will be zero.
1838                         while (packed == 0) {
1839                             packed = _packedOwnerships[--curr];
1840                         }
1841                         return packed;
1842                     }
1843                 }
1844         }
1845         revert OwnerQueryForNonexistentToken();
1846     }
1847 
1848     /**
1849      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1850      */
1851     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1852         ownership.addr = address(uint160(packed));
1853         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1854         ownership.burned = packed & _BITMASK_BURNED != 0;
1855         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1856     }
1857 
1858     /**
1859      * @dev Packs ownership data into a single uint256.
1860      */
1861     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1862         assembly {
1863             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1864             owner := and(owner, _BITMASK_ADDRESS)
1865             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1866             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1867         }
1868     }
1869 
1870     /**
1871      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1872      */
1873     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1874         // For branchless setting of the `nextInitialized` flag.
1875         assembly {
1876             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1877             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1878         }
1879     }
1880 
1881     // =============================================================
1882     //                      APPROVAL OPERATIONS
1883     // =============================================================
1884 
1885     /**
1886      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1887      * The approval is cleared when the token is transferred.
1888      *
1889      * Only a single account can be approved at a time, so approving the
1890      * zero address clears previous approvals.
1891      *
1892      * Requirements:
1893      *
1894      * - The caller must own the token or be an approved operator.
1895      * - `tokenId` must exist.
1896      *
1897      * Emits an {Approval} event.
1898      */
1899     function approve(address to, uint256 tokenId) public payable virtual override {
1900         address owner = ownerOf(tokenId);
1901 
1902         if (_msgSenderERC721A() != owner)
1903             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1904                 revert ApprovalCallerNotOwnerNorApproved();
1905             }
1906 
1907         _tokenApprovals[tokenId].value = to;
1908         emit Approval(owner, to, tokenId);
1909     }
1910 
1911     /**
1912      * @dev Returns the account approved for `tokenId` token.
1913      *
1914      * Requirements:
1915      *
1916      * - `tokenId` must exist.
1917      */
1918     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1919         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1920 
1921         return _tokenApprovals[tokenId].value;
1922     }
1923 
1924     /**
1925      * @dev Approve or remove `operator` as an operator for the caller.
1926      * Operators can call {transferFrom} or {safeTransferFrom}
1927      * for any token owned by the caller.
1928      *
1929      * Requirements:
1930      *
1931      * - The `operator` cannot be the caller.
1932      *
1933      * Emits an {ApprovalForAll} event.
1934      */
1935     function setApprovalForAll(address operator, bool approved) public virtual override {
1936         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1937         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1938     }
1939 
1940     /**
1941      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1942      *
1943      * See {setApprovalForAll}.
1944      */
1945     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1946         return _operatorApprovals[owner][operator];
1947     }
1948 
1949     /**
1950      * @dev Returns whether `tokenId` exists.
1951      *
1952      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1953      *
1954      * Tokens start existing when they are minted. See {_mint}.
1955      */
1956     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1957         return
1958             _startTokenId() <= tokenId &&
1959             tokenId < _currentIndex && // If within bounds,
1960             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1961     }
1962 
1963     /**
1964      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1965      */
1966     function _isSenderApprovedOrOwner(
1967         address approvedAddress,
1968         address owner,
1969         address msgSender
1970     ) private pure returns (bool result) {
1971         assembly {
1972             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1973             owner := and(owner, _BITMASK_ADDRESS)
1974             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1975             msgSender := and(msgSender, _BITMASK_ADDRESS)
1976             // `msgSender == owner || msgSender == approvedAddress`.
1977             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1978         }
1979     }
1980 
1981     /**
1982      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1983      */
1984     function _getApprovedSlotAndAddress(uint256 tokenId)
1985         private
1986         view
1987         returns (uint256 approvedAddressSlot, address approvedAddress)
1988     {
1989         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1990         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1991         assembly {
1992             approvedAddressSlot := tokenApproval.slot
1993             approvedAddress := sload(approvedAddressSlot)
1994         }
1995     }
1996 
1997     // =============================================================
1998     //                      TRANSFER OPERATIONS
1999     // =============================================================
2000 
2001     /**
2002      * @dev Transfers `tokenId` from `from` to `to`.
2003      *
2004      * Requirements:
2005      *
2006      * - `from` cannot be the zero address.
2007      * - `to` cannot be the zero address.
2008      * - `tokenId` token must be owned by `from`.
2009      * - If the caller is not `from`, it must be approved to move this token
2010      * by either {approve} or {setApprovalForAll}.
2011      *
2012      * Emits a {Transfer} event.
2013      */
2014     function transferFrom(
2015         address from,
2016         address to,
2017         uint256 tokenId
2018     ) public payable virtual override {
2019         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2020 
2021         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2022 
2023         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2024 
2025         // The nested ifs save around 20+ gas over a compound boolean condition.
2026         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2027             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2028 
2029         if (to == address(0)) revert TransferToZeroAddress();
2030 
2031         _beforeTokenTransfers(from, to, tokenId, 1);
2032 
2033         // Clear approvals from the previous owner.
2034         assembly {
2035             if approvedAddress {
2036                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2037                 sstore(approvedAddressSlot, 0)
2038             }
2039         }
2040 
2041         // Underflow of the sender's balance is impossible because we check for
2042         // ownership above and the recipient's balance can't realistically overflow.
2043         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2044         unchecked {
2045             // We can directly increment and decrement the balances.
2046             --_packedAddressData[from]; // Updates: `balance -= 1`.
2047             ++_packedAddressData[to]; // Updates: `balance += 1`.
2048 
2049             // Updates:
2050             // - `address` to the next owner.
2051             // - `startTimestamp` to the timestamp of transfering.
2052             // - `burned` to `false`.
2053             // - `nextInitialized` to `true`.
2054             _packedOwnerships[tokenId] = _packOwnershipData(
2055                 to,
2056                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2057             );
2058 
2059             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2060             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2061                 uint256 nextTokenId = tokenId + 1;
2062                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2063                 if (_packedOwnerships[nextTokenId] == 0) {
2064                     // If the next slot is within bounds.
2065                     if (nextTokenId != _currentIndex) {
2066                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2067                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2068                     }
2069                 }
2070             }
2071         }
2072 
2073         emit Transfer(from, to, tokenId);
2074         _afterTokenTransfers(from, to, tokenId, 1);
2075     }
2076 
2077     /**
2078      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2079      */
2080     function safeTransferFrom(
2081         address from,
2082         address to,
2083         uint256 tokenId
2084     ) public payable virtual override {
2085         safeTransferFrom(from, to, tokenId, '');
2086     }
2087 
2088     /**
2089      * @dev Safely transfers `tokenId` token from `from` to `to`.
2090      *
2091      * Requirements:
2092      *
2093      * - `from` cannot be the zero address.
2094      * - `to` cannot be the zero address.
2095      * - `tokenId` token must exist and be owned by `from`.
2096      * - If the caller is not `from`, it must be approved to move this token
2097      * by either {approve} or {setApprovalForAll}.
2098      * - If `to` refers to a smart contract, it must implement
2099      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2100      *
2101      * Emits a {Transfer} event.
2102      */
2103     function safeTransferFrom(
2104         address from,
2105         address to,
2106         uint256 tokenId,
2107         bytes memory _data
2108     ) public payable virtual override {
2109         transferFrom(from, to, tokenId);
2110         if (to.code.length != 0)
2111             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2112                 revert TransferToNonERC721ReceiverImplementer();
2113             }
2114     }
2115 
2116     /**
2117      * @dev Hook that is called before a set of serially-ordered token IDs
2118      * are about to be transferred. This includes minting.
2119      * And also called before burning one token.
2120      *
2121      * `startTokenId` - the first token ID to be transferred.
2122      * `quantity` - the amount to be transferred.
2123      *
2124      * Calling conditions:
2125      *
2126      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2127      * transferred to `to`.
2128      * - When `from` is zero, `tokenId` will be minted for `to`.
2129      * - When `to` is zero, `tokenId` will be burned by `from`.
2130      * - `from` and `to` are never both zero.
2131      */
2132     function _beforeTokenTransfers(
2133         address from,
2134         address to,
2135         uint256 startTokenId,
2136         uint256 quantity
2137     ) internal virtual {}
2138 
2139     /**
2140      * @dev Hook that is called after a set of serially-ordered token IDs
2141      * have been transferred. This includes minting.
2142      * And also called after one token has been burned.
2143      *
2144      * `startTokenId` - the first token ID to be transferred.
2145      * `quantity` - the amount to be transferred.
2146      *
2147      * Calling conditions:
2148      *
2149      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2150      * transferred to `to`.
2151      * - When `from` is zero, `tokenId` has been minted for `to`.
2152      * - When `to` is zero, `tokenId` has been burned by `from`.
2153      * - `from` and `to` are never both zero.
2154      */
2155     function _afterTokenTransfers(
2156         address from,
2157         address to,
2158         uint256 startTokenId,
2159         uint256 quantity
2160     ) internal virtual {}
2161 
2162     /**
2163      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2164      *
2165      * `from` - Previous owner of the given token ID.
2166      * `to` - Target address that will receive the token.
2167      * `tokenId` - Token ID to be transferred.
2168      * `_data` - Optional data to send along with the call.
2169      *
2170      * Returns whether the call correctly returned the expected magic value.
2171      */
2172     function _checkContractOnERC721Received(
2173         address from,
2174         address to,
2175         uint256 tokenId,
2176         bytes memory _data
2177     ) private returns (bool) {
2178         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2179             bytes4 retval
2180         ) {
2181             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2182         } catch (bytes memory reason) {
2183             if (reason.length == 0) {
2184                 revert TransferToNonERC721ReceiverImplementer();
2185             } else {
2186                 assembly {
2187                     revert(add(32, reason), mload(reason))
2188                 }
2189             }
2190         }
2191     }
2192 
2193     // =============================================================
2194     //                        MINT OPERATIONS
2195     // =============================================================
2196 
2197     /**
2198      * @dev Mints `quantity` tokens and transfers them to `to`.
2199      *
2200      * Requirements:
2201      *
2202      * - `to` cannot be the zero address.
2203      * - `quantity` must be greater than 0.
2204      *
2205      * Emits a {Transfer} event for each mint.
2206      */
2207     function _mint(address to, uint256 quantity) internal virtual {
2208         uint256 startTokenId = _currentIndex;
2209         if (quantity == 0) revert MintZeroQuantity();
2210 
2211         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2212 
2213         // Overflows are incredibly unrealistic.
2214         // `balance` and `numberMinted` have a maximum limit of 2**64.
2215         // `tokenId` has a maximum limit of 2**256.
2216         unchecked {
2217             // Updates:
2218             // - `balance += quantity`.
2219             // - `numberMinted += quantity`.
2220             //
2221             // We can directly add to the `balance` and `numberMinted`.
2222             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2223 
2224             // Updates:
2225             // - `address` to the owner.
2226             // - `startTimestamp` to the timestamp of minting.
2227             // - `burned` to `false`.
2228             // - `nextInitialized` to `quantity == 1`.
2229             _packedOwnerships[startTokenId] = _packOwnershipData(
2230                 to,
2231                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2232             );
2233 
2234             uint256 toMasked;
2235             uint256 end = startTokenId + quantity;
2236 
2237             // Use assembly to loop and emit the `Transfer` event for gas savings.
2238             // The duplicated `log4` removes an extra check and reduces stack juggling.
2239             // The assembly, together with the surrounding Solidity code, have been
2240             // delicately arranged to nudge the compiler into producing optimized opcodes.
2241             assembly {
2242                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2243                 toMasked := and(to, _BITMASK_ADDRESS)
2244                 // Emit the `Transfer` event.
2245                 log4(
2246                     0, // Start of data (0, since no data).
2247                     0, // End of data (0, since no data).
2248                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2249                     0, // `address(0)`.
2250                     toMasked, // `to`.
2251                     startTokenId // `tokenId`.
2252                 )
2253 
2254                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2255                 // that overflows uint256 will make the loop run out of gas.
2256                 // The compiler will optimize the `iszero` away for performance.
2257                 for {
2258                     let tokenId := add(startTokenId, 1)
2259                 } iszero(eq(tokenId, end)) {
2260                     tokenId := add(tokenId, 1)
2261                 } {
2262                     // Emit the `Transfer` event. Similar to above.
2263                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2264                 }
2265             }
2266             if (toMasked == 0) revert MintToZeroAddress();
2267 
2268             _currentIndex = end;
2269         }
2270         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2271     }
2272 
2273     /**
2274      * @dev Mints `quantity` tokens and transfers them to `to`.
2275      *
2276      * This function is intended for efficient minting only during contract creation.
2277      *
2278      * It emits only one {ConsecutiveTransfer} as defined in
2279      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2280      * instead of a sequence of {Transfer} event(s).
2281      *
2282      * Calling this function outside of contract creation WILL make your contract
2283      * non-compliant with the ERC721 standard.
2284      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2285      * {ConsecutiveTransfer} event is only permissible during contract creation.
2286      *
2287      * Requirements:
2288      *
2289      * - `to` cannot be the zero address.
2290      * - `quantity` must be greater than 0.
2291      *
2292      * Emits a {ConsecutiveTransfer} event.
2293      */
2294     function _mintERC2309(address to, uint256 quantity) internal virtual {
2295         uint256 startTokenId = _currentIndex;
2296         if (to == address(0)) revert MintToZeroAddress();
2297         if (quantity == 0) revert MintZeroQuantity();
2298         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2299 
2300         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2301 
2302         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2303         unchecked {
2304             // Updates:
2305             // - `balance += quantity`.
2306             // - `numberMinted += quantity`.
2307             //
2308             // We can directly add to the `balance` and `numberMinted`.
2309             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2310 
2311             // Updates:
2312             // - `address` to the owner.
2313             // - `startTimestamp` to the timestamp of minting.
2314             // - `burned` to `false`.
2315             // - `nextInitialized` to `quantity == 1`.
2316             _packedOwnerships[startTokenId] = _packOwnershipData(
2317                 to,
2318                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2319             );
2320 
2321             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2322 
2323             _currentIndex = startTokenId + quantity;
2324         }
2325         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2326     }
2327 
2328     /**
2329      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2330      *
2331      * Requirements:
2332      *
2333      * - If `to` refers to a smart contract, it must implement
2334      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2335      * - `quantity` must be greater than 0.
2336      *
2337      * See {_mint}.
2338      *
2339      * Emits a {Transfer} event for each mint.
2340      */
2341     function _safeMint(
2342         address to,
2343         uint256 quantity,
2344         bytes memory _data
2345     ) internal virtual {
2346         _mint(to, quantity);
2347 
2348         unchecked {
2349             if (to.code.length != 0) {
2350                 uint256 end = _currentIndex;
2351                 uint256 index = end - quantity;
2352                 do {
2353                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2354                         revert TransferToNonERC721ReceiverImplementer();
2355                     }
2356                 } while (index < end);
2357                 // Reentrancy protection.
2358                 if (_currentIndex != end) revert();
2359             }
2360         }
2361     }
2362 
2363     /**
2364      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2365      */
2366     function _safeMint(address to, uint256 quantity) internal virtual {
2367         _safeMint(to, quantity, '');
2368     }
2369 
2370     // =============================================================
2371     //                        BURN OPERATIONS
2372     // =============================================================
2373 
2374     /**
2375      * @dev Equivalent to `_burn(tokenId, false)`.
2376      */
2377     function _burn(uint256 tokenId) internal virtual {
2378         _burn(tokenId, false);
2379     }
2380 
2381     /**
2382      * @dev Destroys `tokenId`.
2383      * The approval is cleared when the token is burned.
2384      *
2385      * Requirements:
2386      *
2387      * - `tokenId` must exist.
2388      *
2389      * Emits a {Transfer} event.
2390      */
2391     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2392         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2393 
2394         address from = address(uint160(prevOwnershipPacked));
2395 
2396         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2397 
2398         if (approvalCheck) {
2399             // The nested ifs save around 20+ gas over a compound boolean condition.
2400             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2401                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2402         }
2403 
2404         _beforeTokenTransfers(from, address(0), tokenId, 1);
2405 
2406         // Clear approvals from the previous owner.
2407         assembly {
2408             if approvedAddress {
2409                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2410                 sstore(approvedAddressSlot, 0)
2411             }
2412         }
2413 
2414         // Underflow of the sender's balance is impossible because we check for
2415         // ownership above and the recipient's balance can't realistically overflow.
2416         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2417         unchecked {
2418             // Updates:
2419             // - `balance -= 1`.
2420             // - `numberBurned += 1`.
2421             //
2422             // We can directly decrement the balance, and increment the number burned.
2423             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2424             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2425 
2426             // Updates:
2427             // - `address` to the last owner.
2428             // - `startTimestamp` to the timestamp of burning.
2429             // - `burned` to `true`.
2430             // - `nextInitialized` to `true`.
2431             _packedOwnerships[tokenId] = _packOwnershipData(
2432                 from,
2433                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2434             );
2435 
2436             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2437             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2438                 uint256 nextTokenId = tokenId + 1;
2439                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2440                 if (_packedOwnerships[nextTokenId] == 0) {
2441                     // If the next slot is within bounds.
2442                     if (nextTokenId != _currentIndex) {
2443                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2444                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2445                     }
2446                 }
2447             }
2448         }
2449 
2450         emit Transfer(from, address(0), tokenId);
2451         _afterTokenTransfers(from, address(0), tokenId, 1);
2452 
2453         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2454         unchecked {
2455             _burnCounter++;
2456         }
2457     }
2458 
2459     // =============================================================
2460     //                     EXTRA DATA OPERATIONS
2461     // =============================================================
2462 
2463     /**
2464      * @dev Directly sets the extra data for the ownership data `index`.
2465      */
2466     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2467         uint256 packed = _packedOwnerships[index];
2468         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2469         uint256 extraDataCasted;
2470         // Cast `extraData` with assembly to avoid redundant masking.
2471         assembly {
2472             extraDataCasted := extraData
2473         }
2474         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2475         _packedOwnerships[index] = packed;
2476     }
2477 
2478     /**
2479      * @dev Called during each token transfer to set the 24bit `extraData` field.
2480      * Intended to be overridden by the cosumer contract.
2481      *
2482      * `previousExtraData` - the value of `extraData` before transfer.
2483      *
2484      * Calling conditions:
2485      *
2486      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2487      * transferred to `to`.
2488      * - When `from` is zero, `tokenId` will be minted for `to`.
2489      * - When `to` is zero, `tokenId` will be burned by `from`.
2490      * - `from` and `to` are never both zero.
2491      */
2492     function _extraData(
2493         address from,
2494         address to,
2495         uint24 previousExtraData
2496     ) internal view virtual returns (uint24) {}
2497 
2498     /**
2499      * @dev Returns the next extra data for the packed ownership data.
2500      * The returned result is shifted into position.
2501      */
2502     function _nextExtraData(
2503         address from,
2504         address to,
2505         uint256 prevOwnershipPacked
2506     ) private view returns (uint256) {
2507         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2508         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2509     }
2510 
2511     // =============================================================
2512     //                       OTHER OPERATIONS
2513     // =============================================================
2514 
2515     /**
2516      * @dev Returns the message sender (defaults to `msg.sender`).
2517      *
2518      * If you are writing GSN compatible contracts, you need to override this function.
2519      */
2520     function _msgSenderERC721A() internal view virtual returns (address) {
2521         return msg.sender;
2522     }
2523 
2524     /**
2525      * @dev Converts a uint256 to its ASCII string decimal representation.
2526      */
2527     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2528         assembly {
2529             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2530             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2531             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2532             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2533             let m := add(mload(0x40), 0xa0)
2534             // Update the free memory pointer to allocate.
2535             mstore(0x40, m)
2536             // Assign the `str` to the end.
2537             str := sub(m, 0x20)
2538             // Zeroize the slot after the string.
2539             mstore(str, 0)
2540 
2541             // Cache the end of the memory to calculate the length later.
2542             let end := str
2543 
2544             // We write the string from rightmost digit to leftmost digit.
2545             // The following is essentially a do-while loop that also handles the zero case.
2546             // prettier-ignore
2547             for { let temp := value } 1 {} {
2548                 str := sub(str, 1)
2549                 // Write the character to the pointer.
2550                 // The ASCII index of the '0' character is 48.
2551                 mstore8(str, add(48, mod(temp, 10)))
2552                 // Keep dividing `temp` until zero.
2553                 temp := div(temp, 10)
2554                 // prettier-ignore
2555                 if iszero(temp) { break }
2556             }
2557 
2558             let length := sub(end, str)
2559             // Move the pointer 32 bytes leftwards to make room for the length.
2560             str := sub(str, 0x20)
2561             // Store the length.
2562             mstore(str, length)
2563         }
2564     }
2565 }
2566 
2567 // File: chillorbs.sol
2568 
2569 
2570 pragma solidity ^0.8.4;
2571 
2572 
2573 
2574 
2575 
2576 
2577 
2578 
2579 
2580 contract ChillOrbs is
2581     ERC721A,
2582     Ownable,
2583     Pausable,
2584     ReentrancyGuard,
2585     DefaultOperatorFilterer
2586 {
2587     constructor() ERC721A("ChillOrbs", "CHILLORBS") {}
2588 
2589     uint256 public MINT_START_TIME = 0;
2590     uint256 public MINT_END_TIME = 0;
2591     uint256 public MINT_PRICE = 0.0069 ether;
2592     uint16 public COLLECTION_SIZE = 10000;
2593     bool public BURN_OPEN = false;
2594     string private previewBaseURI = "ipfs://QmbWA9qTcgpw3oZVE5AM1iegzCzg6DjqDzEfR8ru8deDbM";
2595     string private tokenHtmlSourceCode = '<!doctype html><title>ChillOrb</title><script src="https://cdnjs.cloudflare.com/ajax/libs/seedrandom/3.0.5/seedrandom.min.js" integrity="sha512-+Ru50BzEpZjlFzVnjSmJfYFPFfY2hS0Kjlu/IvqaJoux7maF5lJrRVUJWJ2LevPls7rd242GLbWEt+zAo4OVVQ==" crossorigin="anonymous"></script><script src="https://cdnjs.cloudflare.com/ajax/libs/p5.js/1.5.0/p5.min.js" integrity="sha512-WJXVjqeINVpi5XXJ2jn0BSCfp0y80IKrYh731gLRnkAS9TKc5KNt/OfLtu+fCueqdWniouJ1ubM+VI/hbo7POQ==" crossorigin="anonymous"></script><body style="background:#000;padding:0;margin:0;overflow: hidden"><script>(()=>{"use strict";function m(m){return m<=.33?"x":m<=.66?"y":"z"}let b=new URLSearchParams(window.location.search),l=b.get("tokenId")||(0,1e3,Math.floor(1001*Math.random())+0);let W="true"===b.get("blackAndWhite"),t="%TOREPLACE.TOKENID%";t.startsWith("%TOREPLACE.")||(l=t);let e="%TOREPLACE.ISCOLORED%";e.startsWith("%TOREPLACE.")||(W="false"===e.toLowerCase());let Z=new Math.seedrandom(l);new p5((b=>{let l;function t(){let m=Z();return m>.3?200:parseInt(50*m)+2}b.preload=()=>{l=b.loadShader("data:@file/x-c;base64,YXR0cmlidXRlIHZlYzMgYVBvc2l0aW9uO2F0dHJpYnV0ZSB2ZWMzIGFOb3JtYWw7dW5pZm9ybSBtYXQ0IHVQcm9qZWN0aW9uTWF0cml4O3VuaWZvcm0gbWF0NCB1TW9kZWxWaWV3TWF0cml4O3VuaWZvcm0gZmxvYXQgZnJhbWVDb3VudDt1bmlmb3JtIGZsb2F0IG1vdmluZ1NwZWVkO3VuaWZvcm0gZmxvYXQgZnJlcXVlbmN5O3VuaWZvcm0gZmxvYXQgYW1wbGl0dWRlO3VuaWZvcm0gZmxvYXQgY29udHJhc3ROb3JtYWxpemVyO3VuaWZvcm0gZmxvYXQgYnJpZ2h0bmVzc05vcm1hbGl6ZXI7dW5pZm9ybSBmbG9hdCBzaXplO3VuaWZvcm0gZmxvYXQgY29sb3JSYW5kWDt1bmlmb3JtIGZsb2F0IGNvbG9yUmFuZFk7dW5pZm9ybSBmbG9hdCBjb2xvclJhbmRaO3VuaWZvcm0gYm9vbCBwb3NpdGlvbk1peGVyO3VuaWZvcm0gYm9vbCBwb3NpdGlvbk1vdmVyO3ZhcnlpbmcgdmVjMyB2Tm9ybWFsO3ZhcnlpbmcgZmxvYXQgdkNvbnRyYXN0Tm9ybWFsaXplcjt2YXJ5aW5nIGZsb2F0IHZCcmlnaHRuZXNzTm9ybWFsaXplcjt2YXJ5aW5nIGZsb2F0IHZDb2xvclJhbmRYO3ZhcnlpbmcgZmxvYXQgdkNvbG9yUmFuZFk7dmFyeWluZyBmbG9hdCB2Q29sb3JSYW5kWjt2ZWM0IHBvc2l0aW9uTW92ZXJGdW5jKHZlYzQgcG9zaXRpb25WZWM0LCBmbG9hdCBzdW0pIHtpZiAocG9zaXRpb25Nb3Zlcikge3Bvc2l0aW9uVmVjNC54ICs9IHN1bTt9IGVsc2Uge3Bvc2l0aW9uVmVjNC55ICs9IHN1bTt9cmV0dXJuIHBvc2l0aW9uVmVjNDt9dm9pZCBtYWluKCkge3ZlYzQgcG9zaXRpb25WZWM0ID0gdmVjNChhUG9zaXRpb24sIHNpemUpO2Zsb2F0IHJhbmRQb3NpdGlvblZlYzQgPSBwb3NpdGlvbk1peGVyID8gcG9zaXRpb25WZWM0LnggOiBwb3NpdGlvblZlYzQueTtmbG9hdCBkaXN0b3J0aW9uID0gc2luKHJhbmRQb3NpdGlvblZlYzQgKiBmcmVxdWVuY3kgKyBmcmFtZUNvdW50ICogbW92aW5nU3BlZWQpO3Bvc2l0aW9uVmVjNCA9IHBvc2l0aW9uTW92ZXJGdW5jKHBvc2l0aW9uVmVjNCwgZGlzdG9ydGlvbiAqIGFOb3JtYWwueCAqIGFtcGxpdHVkZSk7dk5vcm1hbCA9IGFOb3JtYWw7dkNvbnRyYXN0Tm9ybWFsaXplciA9IGNvbnRyYXN0Tm9ybWFsaXplcjt2Q29sb3JSYW5kWCA9IGNvbG9yUmFuZFg7dkNvbG9yUmFuZFkgPSBjb2xvclJhbmRZO3ZDb2xvclJhbmRaID0gY29sb3JSYW5kWjt2QnJpZ2h0bmVzc05vcm1hbGl6ZXIgPSBicmlnaHRuZXNzTm9ybWFsaXplcjtnbF9Qb3NpdGlvbiA9IHVQcm9qZWN0aW9uTWF0cml4ICogdU1vZGVsVmlld01hdHJpeCAqIHBvc2l0aW9uVmVjNDt9","data:@file/x-c;base64,cHJlY2lzaW9uIG1lZGl1bXAgZmxvYXQ7dmFyeWluZyB2ZWMzIHZOb3JtYWw7dmFyeWluZyBmbG9hdCB2Q29udHJhc3ROb3JtYWxpemVyO3ZhcnlpbmcgZmxvYXQgdkJyaWdodG5lc3NOb3JtYWxpemVyO3ZhcnlpbmcgZmxvYXQgdkNvbG9yUmFuZFg7dmFyeWluZyBmbG9hdCB2Q29sb3JSYW5kWTt2YXJ5aW5nIGZsb2F0IHZDb2xvclJhbmRaO2Zsb2F0IGRpbWVuc29pbk1peGVyKHZlYzMgYXJyYXksIGZsb2F0IHJhbmQpIHtpZiAocmFuZCA8PSAwLjMzKSB7cmV0dXJuIGFycmF5Lng7fSBlbHNlIGlmIChyYW5kIDw9IDAuNjYpIHtyZXR1cm4gYXJyYXkueTt9IGVsc2Uge3JldHVybiBhcnJheS56O319dm9pZCBtYWluKCkge3ZlYzMgY29sb3IgPSB2Tm9ybWFsICogdkNvbnRyYXN0Tm9ybWFsaXplciArIHZCcmlnaHRuZXNzTm9ybWFsaXplcjtnbF9GcmFnQ29sb3IgPSB2ZWM0KGRpbWVuc29pbk1peGVyKGNvbG9yLCB2Q29sb3JSYW5kWCksZGltZW5zb2luTWl4ZXIoY29sb3IsIHZDb2xvclJhbmRZKSxkaW1lbnNvaW5NaXhlcihjb2xvciwgdkNvbG9yUmFuZFopLDEuMCk7fQ==")},b.setup=()=>{b.createCanvas(b.windowWidth,b.windowHeight,b.WEBGL),b.noStroke()};const e=t(),c=t(),a=.2*Z()+.03,d=20*Z()+10,n=Z(),s=.25+.5*Z(),v=.25+.5*Z();let G=Z(),g=Z(),u=Z();const Y=Z()<=.8,o=Z()<=.8;let p=1+.5*Z();window.addEventListener("wheel",(m=>{const b=Math.sign(m.deltaY);p*=1===b?1.2:.8})),W?(g=G,u=G):m(G)===m(g)&&m(g)===m(u)&&(G>=.5?G-=.34:G+=.34),b.draw=()=>{let m=(new Date).getTime()/1e3;b.background("#000"),b.shader(l),l.setUniform("frameCount",b.frameCount),l.setUniform("movingSpeed",a),l.setUniform("frequency",d),l.setUniform("amplitude",n),l.setUniform("contrastNormalizer",s),l.setUniform("brightnessNormalizer",v),l.setUniform("size",p),l.setUniform("colorRandX",G),l.setUniform("colorRandY",g),l.setUniform("colorRandZ",u),l.setUniform("positionMixer",Y),l.setUniform("positionMover",o),b.rotateX(.6*m),b.rotateY(.3*m),b.sphere(b.width/5,e,c)},b.windowResized=()=>{b.resizeCanvas(b.windowWidth,b.windowHeight)}}))})();</script></body>';
2596 
2597     string private metadataBaseJSON = '{"name":"ChillOrb #%TOKENID%","image":"%PREVIEW%","animation_url":"%ORBURI%","attributes":[{"trait_type":"Colorful","value":"%COLORFUL%"}]}';
2598 
2599     // tokenId => isColored (stores colored tokens)
2600     mapping(uint256 => bool) private COLORED_TOKENS;
2601 
2602     // Helpers & tools
2603     function numberMinted(address owner) public view returns (uint256) {
2604         return _numberMinted(owner);
2605     }
2606     
2607     // Preview URI
2608     function tokenPreviewURI(uint256 tokenId) private view returns (string memory) {
2609         return string.concat(previewBaseURI, isColored(tokenId) ? "/colorful/" : "/blackAndWhite/", Utils.uintToString(tokenId), ".jpg");
2610     }
2611     
2612     function setTokenPreviewBaseURI(string calldata baseURI) external onlyOwner {
2613         previewBaseURI = baseURI;
2614     }
2615 
2616     // Working with token source
2617     function uploadHTML(string calldata sourceCode) external onlyOwner {
2618         tokenHtmlSourceCode = sourceCode;
2619     }
2620 
2621     function downloadHTML() external view onlyOwner returns (string memory) {
2622         return tokenHtmlSourceCode;
2623     }
2624 
2625     function generateHTML(uint256 tokenId) public view returns (string memory) {
2626         // %TOREPLACE.TOKENID% -> tokenId
2627         // %TOREPLACE.ISCOLORED% -> isColored
2628         string memory withTokenId = Utils.replaceInString(tokenHtmlSourceCode, "%TOREPLACE.TOKENID%", Utils.uintToString(tokenId));
2629         string memory coloredString = isColored(tokenId) ? "true" : "false";
2630 
2631         return Utils.replaceInString(withTokenId, "%TOREPLACE.ISCOLORED%", coloredString);
2632     }
2633 
2634     function orbBase64(uint256 tokenId) private view returns (string memory) {
2635         return Base64.encode(bytes(generateHTML(tokenId)));
2636     }
2637 
2638     function generateOrbURI(uint256 tokenId) public view returns (string memory) {
2639         return string.concat("data:text/html;base64,", orbBase64(tokenId));
2640     }
2641 
2642     // Initial mint to get the collection listed on marketplaces
2643     function initialMint() external onlyOwner {
2644         uint256 quantity = 1;
2645         _mint(msg.sender, quantity);
2646     }
2647 
2648     // Dev mint
2649     function devMint() external onlyOwner {
2650         uint256 quantity = 50;
2651         require(
2652             totalSupply() + quantity <= COLLECTION_SIZE,
2653             "Not enough remaining NFTs to support desired mint amount."
2654         );
2655         _mint(msg.sender, quantity);
2656     }
2657 
2658     // Mint
2659     function mint(uint256 quantity) external payable {
2660         require(
2661             totalSupply() + quantity <= COLLECTION_SIZE,
2662             "Not enough remaining NFTs to support desired mint amount."
2663         );
2664 
2665         require(
2666             MINT_START_TIME <= block.timestamp && MINT_START_TIME != 0,
2667             "Public mint is not started yet. Please check back later and follow us on twitter: @chillorbs"
2668         );
2669 
2670         require(
2671             MINT_END_TIME > block.timestamp,
2672             "Public mint is closed. Please check back later and follow us on twitter: @chillorbs"
2673         );
2674 
2675         uint256 totalCost = MINT_PRICE * quantity - (numberMinted(msg.sender) == 0 ? MINT_PRICE : 0);
2676         _refundIfOver(totalCost);
2677         _mint(msg.sender, quantity);
2678     }
2679 
2680     // Start mint at the specified time
2681     function startMintAt(uint256 startTimestampSeconds) public onlyOwner {
2682         // Locks the minting process after 24 hours
2683         MINT_START_TIME = startTimestampSeconds;
2684         MINT_END_TIME = startTimestampSeconds + 24 * 60 * 60;
2685     }
2686 
2687     // Start mint now
2688     function startMint() external onlyOwner {
2689         startMintAt(block.timestamp);
2690     }
2691 
2692     // End mint
2693     function endMint() external onlyOwner {
2694         MINT_END_TIME = block.timestamp;
2695     }
2696 
2697     // Set end time manually
2698     function setEndTime(uint256 endTimestampSeconds) external onlyOwner {
2699         MINT_END_TIME = endTimestampSeconds;
2700     }
2701 
2702     // Helpers & tools
2703 
2704     function _refundIfOver(uint256 price) private {
2705         require(msg.value >= price, "Need to send more ETH.");
2706         if (msg.value > price) {
2707             payable(msg.sender).transfer(msg.value - price);
2708         }
2709     }
2710 
2711     function withdrawMoney() external onlyOwner nonReentrant {
2712         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2713         require(success, "Transfer failed.");
2714     }
2715 
2716     function getOwnershipData(uint256 tokenId)
2717         external
2718         view
2719         returns (TokenOwnership memory)
2720     {
2721         return _ownershipOf(tokenId);
2722     }
2723 
2724     // Burn
2725     function burn(uint256 tokenId1, uint256 tokenId2, uint256 tokenId3) public {
2726         require(BURN_OPEN, "Burn is currently paused.");
2727 
2728         _burn(tokenId1, true); // true required for approval check
2729         _burn(tokenId2, true); // true required for approval check
2730 
2731         require(
2732             !COLORED_TOKENS[tokenId3],
2733             "The third token is already colored."
2734         );
2735         require(
2736             ownerOf(tokenId3) == msg.sender,
2737             "You must be the owner of the third token."
2738         );
2739         COLORED_TOKENS[tokenId3] = true;
2740     }
2741 
2742     // Contract owner can burn any NFT if it was stolen
2743     function burnStolen(uint256 tokenId) external onlyOwner {
2744         _burn(tokenId, false);
2745     }
2746 
2747     function closeBurn() external onlyOwner {
2748         BURN_OPEN = false;
2749     }
2750 
2751     function openBurn() external onlyOwner {
2752         BURN_OPEN = true;
2753     }
2754 
2755     // Returns true if the token is colored
2756     function isColored(uint256 tokenId) public view returns (bool) {
2757         return COLORED_TOKENS[tokenId];
2758     }
2759 
2760     // metadata URI
2761     function generateJSON(uint256 tokenId) private view returns (string memory) {
2762         string memory json = metadataBaseJSON;
2763         json = Utils.replaceInString(json, "%TOKENID%", Utils.uintToString(tokenId));
2764         json = Utils.replaceInString(json, "%PREVIEW%", tokenPreviewURI(tokenId));
2765         json = Utils.replaceInString(json, "%ORBURI%", generateOrbURI(tokenId));
2766         json = Utils.replaceInString(json, "%ORBURI%", generateOrbURI(tokenId));
2767         json = Utils.replaceInString(json, "%COLORFUL%", isColored(tokenId) ? "Yes" : "No");
2768         return json;
2769     }
2770 
2771     function tokenURI(uint256 tokenId)
2772         public
2773         view
2774         override
2775         returns (string memory)
2776     {
2777         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2778 
2779         string memory json = generateJSON(tokenId);
2780 
2781         return string.concat("data:application/json;base64,", Base64.encode(bytes(json)));
2782     }
2783 
2784     function setMintPrice(uint256 price) external onlyOwner {
2785         MINT_PRICE = price;
2786     }
2787 
2788     /* 
2789     Force fee collecting on-chain
2790     override the ERC721 transfer and approval methods (modifiers are overridable as needed)
2791     Source: https://github.com/ProjectOpenSea/operator-filter-registry
2792     */
2793     function setApprovalForAll(address operator, bool approved)
2794         public
2795         override
2796         onlyAllowedOperatorApproval(operator)
2797     {
2798         super.setApprovalForAll(operator, approved);
2799     }
2800 
2801     function approve(address operator, uint256 tokenId)
2802         public
2803         payable
2804         override
2805         onlyAllowedOperatorApproval(operator)
2806     {
2807         super.approve(operator, tokenId);
2808     }
2809 
2810     function transferFrom(
2811         address from,
2812         address to,
2813         uint256 tokenId
2814     ) public payable override onlyAllowedOperator(from) {
2815         super.transferFrom(from, to, tokenId);
2816     }
2817 
2818     function safeTransferFrom(
2819         address from,
2820         address to,
2821         uint256 tokenId
2822     ) public payable override onlyAllowedOperator(from) {
2823         super.safeTransferFrom(from, to, tokenId);
2824     }
2825 
2826     function safeTransferFrom(
2827         address from,
2828         address to,
2829         uint256 tokenId,
2830         bytes memory data
2831     ) public payable override onlyAllowedOperator(from) {
2832         super.safeTransferFrom(from, to, tokenId, data);
2833     }
2834 
2835     /* 
2836     Pause NFT
2837     Helper functions for pausing transfers (including sales) of NFTs
2838     */
2839     function pause() public onlyOwner {
2840         _pause();
2841     }
2842 
2843     function unpause() public onlyOwner {
2844         _unpause();
2845     }
2846 
2847     function _beforeTokenTransfers(
2848         address from,
2849         address to,
2850         uint256 tokenId,
2851         uint256 batchSize
2852     ) internal override whenNotPaused {
2853         super._beforeTokenTransfers(from, to, tokenId, batchSize);
2854     }
2855 }