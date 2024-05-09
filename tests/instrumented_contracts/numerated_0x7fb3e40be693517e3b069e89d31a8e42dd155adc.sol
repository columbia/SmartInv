1 // SPDX-License-Identifier: MIT
2 
3 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
4 
5 pragma solidity ^0.8.13;
6 
7 interface IOperatorFilterRegistry {
8     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
9     function register(address registrant) external;
10     function registerAndSubscribe(address registrant, address subscription) external;
11     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
12     function unregister(address addr) external;
13     function updateOperator(address registrant, address operator, bool filtered) external;
14     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
15     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
16     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
17     function subscribe(address registrant, address registrantToSubscribe) external;
18     function unsubscribe(address registrant, bool copyExistingEntries) external;
19     function subscriptionOf(address addr) external returns (address registrant);
20     function subscribers(address registrant) external returns (address[] memory);
21     function subscriberAt(address registrant, uint256 index) external returns (address);
22     function copyEntriesOf(address registrant, address registrantToCopy) external;
23     function isOperatorFiltered(address registrant, address operator) external returns (bool);
24     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
25     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
26     function filteredOperators(address addr) external returns (address[] memory);
27     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
28     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
29     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
30     function isRegistered(address addr) external returns (bool);
31     function codeHashOf(address addr) external returns (bytes32);
32 }
33 
34 // File: operator-filter-registry/src/OperatorFilterer.sol
35 
36 
37 pragma solidity ^0.8.13;
38 
39 
40 /**
41  * @title  OperatorFilterer
42  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
43  *         registrant's entries in the OperatorFilterRegistry.
44  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
45  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
46  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
47  */
48 abstract contract OperatorFilterer {
49     error OperatorNotAllowed(address operator);
50 
51     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
52         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
53 
54     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
55         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
56         // will not revert, but the contract will need to be registered with the registry once it is deployed in
57         // order for the modifier to filter addresses.
58         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
59             if (subscribe) {
60                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
61             } else {
62                 if (subscriptionOrRegistrantToCopy != address(0)) {
63                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
64                 } else {
65                     OPERATOR_FILTER_REGISTRY.register(address(this));
66                 }
67             }
68         }
69     }
70 
71     modifier onlyAllowedOperator(address from) virtual {
72         // Allow spending tokens from addresses with balance
73         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
74         // from an EOA.
75         if (from != msg.sender) {
76             _checkFilterOperator(msg.sender);
77         }
78         _;
79     }
80 
81     modifier onlyAllowedOperatorApproval(address operator) virtual {
82         _checkFilterOperator(operator);
83         _;
84     }
85 
86     function _checkFilterOperator(address operator) internal view virtual {
87         // Check registry code length to facilitate testing in environments without a deployed registry.
88         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
89             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
90                 revert OperatorNotAllowed(operator);
91             }
92         }
93     }
94 }
95 
96 // File: operator-filter-registry/src/DefaultOperatorFilterer.sol
97 
98 
99 pragma solidity ^0.8.13;
100 
101 
102 /**
103  * @title  DefaultOperatorFilterer
104  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
105  */
106 abstract contract DefaultOperatorFilterer is OperatorFilterer {
107     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
108 
109     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
110 }
111 
112 // File: @openzeppelin/contracts/utils/math/Math.sol
113 
114 
115 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
116 
117 pragma solidity ^0.8.0;
118 
119 /**
120  * @dev Standard math utilities missing in the Solidity language.
121  */
122 library Math {
123     enum Rounding {
124         Down, // Toward negative infinity
125         Up, // Toward infinity
126         Zero // Toward zero
127     }
128 
129     /**
130      * @dev Returns the largest of two numbers.
131      */
132     function max(uint256 a, uint256 b) internal pure returns (uint256) {
133         return a > b ? a : b;
134     }
135 
136     /**
137      * @dev Returns the smallest of two numbers.
138      */
139     function min(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a < b ? a : b;
141     }
142 
143     /**
144      * @dev Returns the average of two numbers. The result is rounded towards
145      * zero.
146      */
147     function average(uint256 a, uint256 b) internal pure returns (uint256) {
148         // (a + b) / 2 can overflow.
149         return (a & b) + (a ^ b) / 2;
150     }
151 
152     /**
153      * @dev Returns the ceiling of the division of two numbers.
154      *
155      * This differs from standard division with `/` in that it rounds up instead
156      * of rounding down.
157      */
158     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
159         // (a + b - 1) / b can overflow on addition, so we distribute.
160         return a == 0 ? 0 : (a - 1) / b + 1;
161     }
162 
163     /**
164      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
165      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
166      * with further edits by Uniswap Labs also under MIT license.
167      */
168     function mulDiv(
169         uint256 x,
170         uint256 y,
171         uint256 denominator
172     ) internal pure returns (uint256 result) {
173         unchecked {
174             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
175             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
176             // variables such that product = prod1 * 2^256 + prod0.
177             uint256 prod0; // Least significant 256 bits of the product
178             uint256 prod1; // Most significant 256 bits of the product
179             assembly {
180                 let mm := mulmod(x, y, not(0))
181                 prod0 := mul(x, y)
182                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
183             }
184 
185             // Handle non-overflow cases, 256 by 256 division.
186             if (prod1 == 0) {
187                 return prod0 / denominator;
188             }
189 
190             // Make sure the result is less than 2^256. Also prevents denominator == 0.
191             require(denominator > prod1);
192 
193             ///////////////////////////////////////////////
194             // 512 by 256 division.
195             ///////////////////////////////////////////////
196 
197             // Make division exact by subtracting the remainder from [prod1 prod0].
198             uint256 remainder;
199             assembly {
200                 // Compute remainder using mulmod.
201                 remainder := mulmod(x, y, denominator)
202 
203                 // Subtract 256 bit number from 512 bit number.
204                 prod1 := sub(prod1, gt(remainder, prod0))
205                 prod0 := sub(prod0, remainder)
206             }
207 
208             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
209             // See https://cs.stackexchange.com/q/138556/92363.
210 
211             // Does not overflow because the denominator cannot be zero at this stage in the function.
212             uint256 twos = denominator & (~denominator + 1);
213             assembly {
214                 // Divide denominator by twos.
215                 denominator := div(denominator, twos)
216 
217                 // Divide [prod1 prod0] by twos.
218                 prod0 := div(prod0, twos)
219 
220                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
221                 twos := add(div(sub(0, twos), twos), 1)
222             }
223 
224             // Shift in bits from prod1 into prod0.
225             prod0 |= prod1 * twos;
226 
227             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
228             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
229             // four bits. That is, denominator * inv = 1 mod 2^4.
230             uint256 inverse = (3 * denominator) ^ 2;
231 
232             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
233             // in modular arithmetic, doubling the correct bits in each step.
234             inverse *= 2 - denominator * inverse; // inverse mod 2^8
235             inverse *= 2 - denominator * inverse; // inverse mod 2^16
236             inverse *= 2 - denominator * inverse; // inverse mod 2^32
237             inverse *= 2 - denominator * inverse; // inverse mod 2^64
238             inverse *= 2 - denominator * inverse; // inverse mod 2^128
239             inverse *= 2 - denominator * inverse; // inverse mod 2^256
240 
241             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
242             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
243             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
244             // is no longer required.
245             result = prod0 * inverse;
246             return result;
247         }
248     }
249 
250     /**
251      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
252      */
253     function mulDiv(
254         uint256 x,
255         uint256 y,
256         uint256 denominator,
257         Rounding rounding
258     ) internal pure returns (uint256) {
259         uint256 result = mulDiv(x, y, denominator);
260         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
261             result += 1;
262         }
263         return result;
264     }
265 
266     /**
267      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
268      *
269      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
270      */
271     function sqrt(uint256 a) internal pure returns (uint256) {
272         if (a == 0) {
273             return 0;
274         }
275 
276         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
277         //
278         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
279         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
280         //
281         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
282         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
283         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
284         //
285         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
286         uint256 result = 1 << (log2(a) >> 1);
287 
288         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
289         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
290         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
291         // into the expected uint128 result.
292         unchecked {
293             result = (result + a / result) >> 1;
294             result = (result + a / result) >> 1;
295             result = (result + a / result) >> 1;
296             result = (result + a / result) >> 1;
297             result = (result + a / result) >> 1;
298             result = (result + a / result) >> 1;
299             result = (result + a / result) >> 1;
300             return min(result, a / result);
301         }
302     }
303 
304     /**
305      * @notice Calculates sqrt(a), following the selected rounding direction.
306      */
307     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
308         unchecked {
309             uint256 result = sqrt(a);
310             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
311         }
312     }
313 
314     /**
315      * @dev Return the log in base 2, rounded down, of a positive value.
316      * Returns 0 if given 0.
317      */
318     function log2(uint256 value) internal pure returns (uint256) {
319         uint256 result = 0;
320         unchecked {
321             if (value >> 128 > 0) {
322                 value >>= 128;
323                 result += 128;
324             }
325             if (value >> 64 > 0) {
326                 value >>= 64;
327                 result += 64;
328             }
329             if (value >> 32 > 0) {
330                 value >>= 32;
331                 result += 32;
332             }
333             if (value >> 16 > 0) {
334                 value >>= 16;
335                 result += 16;
336             }
337             if (value >> 8 > 0) {
338                 value >>= 8;
339                 result += 8;
340             }
341             if (value >> 4 > 0) {
342                 value >>= 4;
343                 result += 4;
344             }
345             if (value >> 2 > 0) {
346                 value >>= 2;
347                 result += 2;
348             }
349             if (value >> 1 > 0) {
350                 result += 1;
351             }
352         }
353         return result;
354     }
355 
356     /**
357      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
358      * Returns 0 if given 0.
359      */
360     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
361         unchecked {
362             uint256 result = log2(value);
363             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
364         }
365     }
366 
367     /**
368      * @dev Return the log in base 10, rounded down, of a positive value.
369      * Returns 0 if given 0.
370      */
371     function log10(uint256 value) internal pure returns (uint256) {
372         uint256 result = 0;
373         unchecked {
374             if (value >= 10**64) {
375                 value /= 10**64;
376                 result += 64;
377             }
378             if (value >= 10**32) {
379                 value /= 10**32;
380                 result += 32;
381             }
382             if (value >= 10**16) {
383                 value /= 10**16;
384                 result += 16;
385             }
386             if (value >= 10**8) {
387                 value /= 10**8;
388                 result += 8;
389             }
390             if (value >= 10**4) {
391                 value /= 10**4;
392                 result += 4;
393             }
394             if (value >= 10**2) {
395                 value /= 10**2;
396                 result += 2;
397             }
398             if (value >= 10**1) {
399                 result += 1;
400             }
401         }
402         return result;
403     }
404 
405     /**
406      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
407      * Returns 0 if given 0.
408      */
409     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
410         unchecked {
411             uint256 result = log10(value);
412             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
413         }
414     }
415 
416     /**
417      * @dev Return the log in base 256, rounded down, of a positive value.
418      * Returns 0 if given 0.
419      *
420      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
421      */
422     function log256(uint256 value) internal pure returns (uint256) {
423         uint256 result = 0;
424         unchecked {
425             if (value >> 128 > 0) {
426                 value >>= 128;
427                 result += 16;
428             }
429             if (value >> 64 > 0) {
430                 value >>= 64;
431                 result += 8;
432             }
433             if (value >> 32 > 0) {
434                 value >>= 32;
435                 result += 4;
436             }
437             if (value >> 16 > 0) {
438                 value >>= 16;
439                 result += 2;
440             }
441             if (value >> 8 > 0) {
442                 result += 1;
443             }
444         }
445         return result;
446     }
447 
448     /**
449      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
450      * Returns 0 if given 0.
451      */
452     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
453         unchecked {
454             uint256 result = log256(value);
455             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
456         }
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/Strings.sol
461 
462 
463 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 
468 /**
469  * @dev String operations.
470  */
471 library Strings {
472     bytes16 private constant _SYMBOLS = "0123456789abcdef";
473     uint8 private constant _ADDRESS_LENGTH = 20;
474 
475     /**
476      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
477      */
478     function toString(uint256 value) internal pure returns (string memory) {
479         unchecked {
480             uint256 length = Math.log10(value) + 1;
481             string memory buffer = new string(length);
482             uint256 ptr;
483             /// @solidity memory-safe-assembly
484             assembly {
485                 ptr := add(buffer, add(32, length))
486             }
487             while (true) {
488                 ptr--;
489                 /// @solidity memory-safe-assembly
490                 assembly {
491                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
492                 }
493                 value /= 10;
494                 if (value == 0) break;
495             }
496             return buffer;
497         }
498     }
499 
500     /**
501      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
502      */
503     function toHexString(uint256 value) internal pure returns (string memory) {
504         unchecked {
505             return toHexString(value, Math.log256(value) + 1);
506         }
507     }
508 
509     /**
510      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
511      */
512     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
513         bytes memory buffer = new bytes(2 * length + 2);
514         buffer[0] = "0";
515         buffer[1] = "x";
516         for (uint256 i = 2 * length + 1; i > 1; --i) {
517             buffer[i] = _SYMBOLS[value & 0xf];
518             value >>= 4;
519         }
520         require(value == 0, "Strings: hex length insufficient");
521         return string(buffer);
522     }
523 
524     /**
525      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
526      */
527     function toHexString(address addr) internal pure returns (string memory) {
528         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
529     }
530 }
531 
532 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
533 
534 
535 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
536 
537 pragma solidity ^0.8.0;
538 
539 
540 /**
541  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
542  *
543  * These functions can be used to verify that a message was signed by the holder
544  * of the private keys of a given address.
545  */
546 library ECDSA {
547     enum RecoverError {
548         NoError,
549         InvalidSignature,
550         InvalidSignatureLength,
551         InvalidSignatureS,
552         InvalidSignatureV // Deprecated in v4.8
553     }
554 
555     function _throwError(RecoverError error) private pure {
556         if (error == RecoverError.NoError) {
557             return; // no error: do nothing
558         } else if (error == RecoverError.InvalidSignature) {
559             revert("ECDSA: invalid signature");
560         } else if (error == RecoverError.InvalidSignatureLength) {
561             revert("ECDSA: invalid signature length");
562         } else if (error == RecoverError.InvalidSignatureS) {
563             revert("ECDSA: invalid signature 's' value");
564         }
565     }
566 
567     /**
568      * @dev Returns the address that signed a hashed message (`hash`) with
569      * `signature` or error string. This address can then be used for verification purposes.
570      *
571      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
572      * this function rejects them by requiring the `s` value to be in the lower
573      * half order, and the `v` value to be either 27 or 28.
574      *
575      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
576      * verification to be secure: it is possible to craft signatures that
577      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
578      * this is by receiving a hash of the original message (which may otherwise
579      * be too long), and then calling {toEthSignedMessageHash} on it.
580      *
581      * Documentation for signature generation:
582      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
583      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
584      *
585      * _Available since v4.3._
586      */
587     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
588         if (signature.length == 65) {
589             bytes32 r;
590             bytes32 s;
591             uint8 v;
592             // ecrecover takes the signature parameters, and the only way to get them
593             // currently is to use assembly.
594             /// @solidity memory-safe-assembly
595             assembly {
596                 r := mload(add(signature, 0x20))
597                 s := mload(add(signature, 0x40))
598                 v := byte(0, mload(add(signature, 0x60)))
599             }
600             return tryRecover(hash, v, r, s);
601         } else {
602             return (address(0), RecoverError.InvalidSignatureLength);
603         }
604     }
605 
606     /**
607      * @dev Returns the address that signed a hashed message (`hash`) with
608      * `signature`. This address can then be used for verification purposes.
609      *
610      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
611      * this function rejects them by requiring the `s` value to be in the lower
612      * half order, and the `v` value to be either 27 or 28.
613      *
614      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
615      * verification to be secure: it is possible to craft signatures that
616      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
617      * this is by receiving a hash of the original message (which may otherwise
618      * be too long), and then calling {toEthSignedMessageHash} on it.
619      */
620     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
621         (address recovered, RecoverError error) = tryRecover(hash, signature);
622         _throwError(error);
623         return recovered;
624     }
625 
626     /**
627      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
628      *
629      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
630      *
631      * _Available since v4.3._
632      */
633     function tryRecover(
634         bytes32 hash,
635         bytes32 r,
636         bytes32 vs
637     ) internal pure returns (address, RecoverError) {
638         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
639         uint8 v = uint8((uint256(vs) >> 255) + 27);
640         return tryRecover(hash, v, r, s);
641     }
642 
643     /**
644      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
645      *
646      * _Available since v4.2._
647      */
648     function recover(
649         bytes32 hash,
650         bytes32 r,
651         bytes32 vs
652     ) internal pure returns (address) {
653         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
654         _throwError(error);
655         return recovered;
656     }
657 
658     /**
659      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
660      * `r` and `s` signature fields separately.
661      *
662      * _Available since v4.3._
663      */
664     function tryRecover(
665         bytes32 hash,
666         uint8 v,
667         bytes32 r,
668         bytes32 s
669     ) internal pure returns (address, RecoverError) {
670         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
671         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
672         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
673         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
674         //
675         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
676         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
677         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
678         // these malleable signatures as well.
679         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
680             return (address(0), RecoverError.InvalidSignatureS);
681         }
682 
683         // If the signature is valid (and not malleable), return the signer address
684         address signer = ecrecover(hash, v, r, s);
685         if (signer == address(0)) {
686             return (address(0), RecoverError.InvalidSignature);
687         }
688 
689         return (signer, RecoverError.NoError);
690     }
691 
692     /**
693      * @dev Overload of {ECDSA-recover} that receives the `v`,
694      * `r` and `s` signature fields separately.
695      */
696     function recover(
697         bytes32 hash,
698         uint8 v,
699         bytes32 r,
700         bytes32 s
701     ) internal pure returns (address) {
702         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
703         _throwError(error);
704         return recovered;
705     }
706 
707     /**
708      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
709      * produces hash corresponding to the one signed with the
710      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
711      * JSON-RPC method as part of EIP-191.
712      *
713      * See {recover}.
714      */
715     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
716         // 32 is the length in bytes of hash,
717         // enforced by the type signature above
718         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
719     }
720 
721     /**
722      * @dev Returns an Ethereum Signed Message, created from `s`. This
723      * produces hash corresponding to the one signed with the
724      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
725      * JSON-RPC method as part of EIP-191.
726      *
727      * See {recover}.
728      */
729     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
730         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
731     }
732 
733     /**
734      * @dev Returns an Ethereum Signed Typed Data, created from a
735      * `domainSeparator` and a `structHash`. This produces hash corresponding
736      * to the one signed with the
737      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
738      * JSON-RPC method as part of EIP-712.
739      *
740      * See {recover}.
741      */
742     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
743         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
744     }
745 }
746 
747 // File: @openzeppelin/contracts/utils/Context.sol
748 
749 
750 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
751 
752 pragma solidity ^0.8.0;
753 
754 /**
755  * @dev Provides information about the current execution context, including the
756  * sender of the transaction and its data. While these are generally available
757  * via msg.sender and msg.data, they should not be accessed in such a direct
758  * manner, since when dealing with meta-transactions the account sending and
759  * paying for execution may not be the actual sender (as far as an application
760  * is concerned).
761  *
762  * This contract is only required for intermediate, library-like contracts.
763  */
764 abstract contract Context {
765     function _msgSender() internal view virtual returns (address) {
766         return msg.sender;
767     }
768 
769     function _msgData() internal view virtual returns (bytes calldata) {
770         return msg.data;
771     }
772 }
773 
774 // File: @openzeppelin/contracts/access/Ownable.sol
775 
776 
777 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
778 
779 pragma solidity ^0.8.0;
780 
781 
782 /**
783  * @dev Contract module which provides a basic access control mechanism, where
784  * there is an account (an owner) that can be granted exclusive access to
785  * specific functions.
786  *
787  * By default, the owner account will be the one that deploys the contract. This
788  * can later be changed with {transferOwnership}.
789  *
790  * This module is used through inheritance. It will make available the modifier
791  * `onlyOwner`, which can be applied to your functions to restrict their use to
792  * the owner.
793  */
794 abstract contract Ownable is Context {
795     address private _owner;
796 
797     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
798 
799     /**
800      * @dev Initializes the contract setting the deployer as the initial owner.
801      */
802     constructor() {
803         _transferOwnership(_msgSender());
804     }
805 
806     /**
807      * @dev Throws if called by any account other than the owner.
808      */
809     modifier onlyOwner() {
810         _checkOwner();
811         _;
812     }
813 
814     /**
815      * @dev Returns the address of the current owner.
816      */
817     function owner() public view virtual returns (address) {
818         return _owner;
819     }
820 
821     /**
822      * @dev Throws if the sender is not the owner.
823      */
824     function _checkOwner() internal view virtual {
825         require(owner() == _msgSender(), "Ownable: caller is not the owner");
826     }
827 
828     /**
829      * @dev Leaves the contract without owner. It will not be possible to call
830      * `onlyOwner` functions anymore. Can only be called by the current owner.
831      *
832      * NOTE: Renouncing ownership will leave the contract without an owner,
833      * thereby removing any functionality that is only available to the owner.
834      */
835     function renounceOwnership() public virtual onlyOwner {
836         _transferOwnership(address(0));
837     }
838 
839     /**
840      * @dev Transfers ownership of the contract to a new account (`newOwner`).
841      * Can only be called by the current owner.
842      */
843     function transferOwnership(address newOwner) public virtual onlyOwner {
844         require(newOwner != address(0), "Ownable: new owner is the zero address");
845         _transferOwnership(newOwner);
846     }
847 
848     /**
849      * @dev Transfers ownership of the contract to a new account (`newOwner`).
850      * Internal function without access restriction.
851      */
852     function _transferOwnership(address newOwner) internal virtual {
853         address oldOwner = _owner;
854         _owner = newOwner;
855         emit OwnershipTransferred(oldOwner, newOwner);
856     }
857 }
858 
859 // File: @openzeppelin/contracts/utils/Address.sol
860 
861 
862 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
863 
864 pragma solidity ^0.8.1;
865 
866 /**
867  * @dev Collection of functions related to the address type
868  */
869 library Address {
870     /**
871      * @dev Returns true if `account` is a contract.
872      *
873      * [IMPORTANT]
874      * ====
875      * It is unsafe to assume that an address for which this function returns
876      * false is an externally-owned account (EOA) and not a contract.
877      *
878      * Among others, `isContract` will return false for the following
879      * types of addresses:
880      *
881      *  - an externally-owned account
882      *  - a contract in construction
883      *  - an address where a contract will be created
884      *  - an address where a contract lived, but was destroyed
885      * ====
886      *
887      * [IMPORTANT]
888      * ====
889      * You shouldn't rely on `isContract` to protect against flash loan attacks!
890      *
891      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
892      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
893      * constructor.
894      * ====
895      */
896     function isContract(address account) internal view returns (bool) {
897         // This method relies on extcodesize/address.code.length, which returns 0
898         // for contracts in construction, since the code is only stored at the end
899         // of the constructor execution.
900 
901         return account.code.length > 0;
902     }
903 
904     /**
905      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
906      * `recipient`, forwarding all available gas and reverting on errors.
907      *
908      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
909      * of certain opcodes, possibly making contracts go over the 2300 gas limit
910      * imposed by `transfer`, making them unable to receive funds via
911      * `transfer`. {sendValue} removes this limitation.
912      *
913      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
914      *
915      * IMPORTANT: because control is transferred to `recipient`, care must be
916      * taken to not create reentrancy vulnerabilities. Consider using
917      * {ReentrancyGuard} or the
918      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
919      */
920     function sendValue(address payable recipient, uint256 amount) internal {
921         require(address(this).balance >= amount, "Address: insufficient balance");
922 
923         (bool success, ) = recipient.call{value: amount}("");
924         require(success, "Address: unable to send value, recipient may have reverted");
925     }
926 
927     /**
928      * @dev Performs a Solidity function call using a low level `call`. A
929      * plain `call` is an unsafe replacement for a function call: use this
930      * function instead.
931      *
932      * If `target` reverts with a revert reason, it is bubbled up by this
933      * function (like regular Solidity function calls).
934      *
935      * Returns the raw returned data. To convert to the expected return value,
936      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
937      *
938      * Requirements:
939      *
940      * - `target` must be a contract.
941      * - calling `target` with `data` must not revert.
942      *
943      * _Available since v3.1._
944      */
945     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
946         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
947     }
948 
949     /**
950      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
951      * `errorMessage` as a fallback revert reason when `target` reverts.
952      *
953      * _Available since v3.1._
954      */
955     function functionCall(
956         address target,
957         bytes memory data,
958         string memory errorMessage
959     ) internal returns (bytes memory) {
960         return functionCallWithValue(target, data, 0, errorMessage);
961     }
962 
963     /**
964      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
965      * but also transferring `value` wei to `target`.
966      *
967      * Requirements:
968      *
969      * - the calling contract must have an ETH balance of at least `value`.
970      * - the called Solidity function must be `payable`.
971      *
972      * _Available since v3.1._
973      */
974     function functionCallWithValue(
975         address target,
976         bytes memory data,
977         uint256 value
978     ) internal returns (bytes memory) {
979         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
980     }
981 
982     /**
983      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
984      * with `errorMessage` as a fallback revert reason when `target` reverts.
985      *
986      * _Available since v3.1._
987      */
988     function functionCallWithValue(
989         address target,
990         bytes memory data,
991         uint256 value,
992         string memory errorMessage
993     ) internal returns (bytes memory) {
994         require(address(this).balance >= value, "Address: insufficient balance for call");
995         (bool success, bytes memory returndata) = target.call{value: value}(data);
996         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
997     }
998 
999     /**
1000      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1001      * but performing a static call.
1002      *
1003      * _Available since v3.3._
1004      */
1005     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1006         return functionStaticCall(target, data, "Address: low-level static call failed");
1007     }
1008 
1009     /**
1010      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1011      * but performing a static call.
1012      *
1013      * _Available since v3.3._
1014      */
1015     function functionStaticCall(
1016         address target,
1017         bytes memory data,
1018         string memory errorMessage
1019     ) internal view returns (bytes memory) {
1020         (bool success, bytes memory returndata) = target.staticcall(data);
1021         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1022     }
1023 
1024     /**
1025      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1026      * but performing a delegate call.
1027      *
1028      * _Available since v3.4._
1029      */
1030     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1031         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1032     }
1033 
1034     /**
1035      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1036      * but performing a delegate call.
1037      *
1038      * _Available since v3.4._
1039      */
1040     function functionDelegateCall(
1041         address target,
1042         bytes memory data,
1043         string memory errorMessage
1044     ) internal returns (bytes memory) {
1045         (bool success, bytes memory returndata) = target.delegatecall(data);
1046         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1047     }
1048 
1049     /**
1050      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1051      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1052      *
1053      * _Available since v4.8._
1054      */
1055     function verifyCallResultFromTarget(
1056         address target,
1057         bool success,
1058         bytes memory returndata,
1059         string memory errorMessage
1060     ) internal view returns (bytes memory) {
1061         if (success) {
1062             if (returndata.length == 0) {
1063                 // only check isContract if the call was successful and the return data is empty
1064                 // otherwise we already know that it was a contract
1065                 require(isContract(target), "Address: call to non-contract");
1066             }
1067             return returndata;
1068         } else {
1069             _revert(returndata, errorMessage);
1070         }
1071     }
1072 
1073     /**
1074      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1075      * revert reason or using the provided one.
1076      *
1077      * _Available since v4.3._
1078      */
1079     function verifyCallResult(
1080         bool success,
1081         bytes memory returndata,
1082         string memory errorMessage
1083     ) internal pure returns (bytes memory) {
1084         if (success) {
1085             return returndata;
1086         } else {
1087             _revert(returndata, errorMessage);
1088         }
1089     }
1090 
1091     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1092         // Look for revert reason and bubble it up if present
1093         if (returndata.length > 0) {
1094             // The easiest way to bubble the revert reason is using memory via assembly
1095             /// @solidity memory-safe-assembly
1096             assembly {
1097                 let returndata_size := mload(returndata)
1098                 revert(add(32, returndata), returndata_size)
1099             }
1100         } else {
1101             revert(errorMessage);
1102         }
1103     }
1104 }
1105 
1106 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1107 
1108 
1109 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1110 
1111 pragma solidity ^0.8.0;
1112 
1113 /**
1114  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1115  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1116  *
1117  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1118  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1119  * need to send a transaction, and thus is not required to hold Ether at all.
1120  */
1121 interface IERC20Permit {
1122     /**
1123      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1124      * given ``owner``'s signed approval.
1125      *
1126      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1127      * ordering also apply here.
1128      *
1129      * Emits an {Approval} event.
1130      *
1131      * Requirements:
1132      *
1133      * - `spender` cannot be the zero address.
1134      * - `deadline` must be a timestamp in the future.
1135      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1136      * over the EIP712-formatted function arguments.
1137      * - the signature must use ``owner``'s current nonce (see {nonces}).
1138      *
1139      * For more information on the signature format, see the
1140      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1141      * section].
1142      */
1143     function permit(
1144         address owner,
1145         address spender,
1146         uint256 value,
1147         uint256 deadline,
1148         uint8 v,
1149         bytes32 r,
1150         bytes32 s
1151     ) external;
1152 
1153     /**
1154      * @dev Returns the current nonce for `owner`. This value must be
1155      * included whenever a signature is generated for {permit}.
1156      *
1157      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1158      * prevents a signature from being used multiple times.
1159      */
1160     function nonces(address owner) external view returns (uint256);
1161 
1162     /**
1163      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1164      */
1165     // solhint-disable-next-line func-name-mixedcase
1166     function DOMAIN_SEPARATOR() external view returns (bytes32);
1167 }
1168 
1169 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1170 
1171 
1172 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 /**
1177  * @dev Interface of the ERC20 standard as defined in the EIP.
1178  */
1179 interface IERC20 {
1180     /**
1181      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1182      * another (`to`).
1183      *
1184      * Note that `value` may be zero.
1185      */
1186     event Transfer(address indexed from, address indexed to, uint256 value);
1187 
1188     /**
1189      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1190      * a call to {approve}. `value` is the new allowance.
1191      */
1192     event Approval(address indexed owner, address indexed spender, uint256 value);
1193 
1194     /**
1195      * @dev Returns the amount of tokens in existence.
1196      */
1197     function totalSupply() external view returns (uint256);
1198 
1199     /**
1200      * @dev Returns the amount of tokens owned by `account`.
1201      */
1202     function balanceOf(address account) external view returns (uint256);
1203 
1204     /**
1205      * @dev Moves `amount` tokens from the caller's account to `to`.
1206      *
1207      * Returns a boolean value indicating whether the operation succeeded.
1208      *
1209      * Emits a {Transfer} event.
1210      */
1211     function transfer(address to, uint256 amount) external returns (bool);
1212 
1213     /**
1214      * @dev Returns the remaining number of tokens that `spender` will be
1215      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1216      * zero by default.
1217      *
1218      * This value changes when {approve} or {transferFrom} are called.
1219      */
1220     function allowance(address owner, address spender) external view returns (uint256);
1221 
1222     /**
1223      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1224      *
1225      * Returns a boolean value indicating whether the operation succeeded.
1226      *
1227      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1228      * that someone may use both the old and the new allowance by unfortunate
1229      * transaction ordering. One possible solution to mitigate this race
1230      * condition is to first reduce the spender's allowance to 0 and set the
1231      * desired value afterwards:
1232      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1233      *
1234      * Emits an {Approval} event.
1235      */
1236     function approve(address spender, uint256 amount) external returns (bool);
1237 
1238     /**
1239      * @dev Moves `amount` tokens from `from` to `to` using the
1240      * allowance mechanism. `amount` is then deducted from the caller's
1241      * allowance.
1242      *
1243      * Returns a boolean value indicating whether the operation succeeded.
1244      *
1245      * Emits a {Transfer} event.
1246      */
1247     function transferFrom(
1248         address from,
1249         address to,
1250         uint256 amount
1251     ) external returns (bool);
1252 }
1253 
1254 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1255 
1256 
1257 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1258 
1259 pragma solidity ^0.8.0;
1260 
1261 
1262 
1263 
1264 /**
1265  * @title SafeERC20
1266  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1267  * contract returns false). Tokens that return no value (and instead revert or
1268  * throw on failure) are also supported, non-reverting calls are assumed to be
1269  * successful.
1270  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1271  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1272  */
1273 library SafeERC20 {
1274     using Address for address;
1275 
1276     function safeTransfer(
1277         IERC20 token,
1278         address to,
1279         uint256 value
1280     ) internal {
1281         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1282     }
1283 
1284     function safeTransferFrom(
1285         IERC20 token,
1286         address from,
1287         address to,
1288         uint256 value
1289     ) internal {
1290         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1291     }
1292 
1293     /**
1294      * @dev Deprecated. This function has issues similar to the ones found in
1295      * {IERC20-approve}, and its usage is discouraged.
1296      *
1297      * Whenever possible, use {safeIncreaseAllowance} and
1298      * {safeDecreaseAllowance} instead.
1299      */
1300     function safeApprove(
1301         IERC20 token,
1302         address spender,
1303         uint256 value
1304     ) internal {
1305         // safeApprove should only be called when setting an initial allowance,
1306         // or when resetting it to zero. To increase and decrease it, use
1307         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1308         require(
1309             (value == 0) || (token.allowance(address(this), spender) == 0),
1310             "SafeERC20: approve from non-zero to non-zero allowance"
1311         );
1312         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1313     }
1314 
1315     function safeIncreaseAllowance(
1316         IERC20 token,
1317         address spender,
1318         uint256 value
1319     ) internal {
1320         uint256 newAllowance = token.allowance(address(this), spender) + value;
1321         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1322     }
1323 
1324     function safeDecreaseAllowance(
1325         IERC20 token,
1326         address spender,
1327         uint256 value
1328     ) internal {
1329         unchecked {
1330             uint256 oldAllowance = token.allowance(address(this), spender);
1331             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1332             uint256 newAllowance = oldAllowance - value;
1333             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1334         }
1335     }
1336 
1337     function safePermit(
1338         IERC20Permit token,
1339         address owner,
1340         address spender,
1341         uint256 value,
1342         uint256 deadline,
1343         uint8 v,
1344         bytes32 r,
1345         bytes32 s
1346     ) internal {
1347         uint256 nonceBefore = token.nonces(owner);
1348         token.permit(owner, spender, value, deadline, v, r, s);
1349         uint256 nonceAfter = token.nonces(owner);
1350         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1351     }
1352 
1353     /**
1354      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1355      * on the return value: the return value is optional (but if data is returned, it must not be false).
1356      * @param token The token targeted by the call.
1357      * @param data The call data (encoded using abi.encode or one of its variants).
1358      */
1359     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1360         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1361         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1362         // the target address contains contract code and also asserts for success in the low-level call.
1363 
1364         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1365         if (returndata.length > 0) {
1366             // Return data is optional
1367             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1368         }
1369     }
1370 }
1371 
1372 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
1373 
1374 
1375 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 
1380 
1381 
1382 /**
1383  * @title PaymentSplitter
1384  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
1385  * that the Ether will be split in this way, since it is handled transparently by the contract.
1386  *
1387  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
1388  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
1389  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
1390  * time of contract deployment and can't be updated thereafter.
1391  *
1392  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
1393  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
1394  * function.
1395  *
1396  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
1397  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
1398  * to run tests before sending real value to this contract.
1399  */
1400 contract PaymentSplitter is Context {
1401     event PayeeAdded(address account, uint256 shares);
1402     event PaymentReleased(address to, uint256 amount);
1403     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
1404     event PaymentReceived(address from, uint256 amount);
1405 
1406     uint256 private _totalShares;
1407     uint256 private _totalReleased;
1408 
1409     mapping(address => uint256) private _shares;
1410     mapping(address => uint256) private _released;
1411     address[] private _payees;
1412 
1413     mapping(IERC20 => uint256) private _erc20TotalReleased;
1414     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
1415 
1416     /**
1417      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
1418      * the matching position in the `shares` array.
1419      *
1420      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
1421      * duplicates in `payees`.
1422      */
1423     constructor(address[] memory payees, uint256[] memory shares_) payable {
1424         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
1425         require(payees.length > 0, "PaymentSplitter: no payees");
1426 
1427         for (uint256 i = 0; i < payees.length; i++) {
1428             _addPayee(payees[i], shares_[i]);
1429         }
1430     }
1431 
1432     /**
1433      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1434      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1435      * reliability of the events, and not the actual splitting of Ether.
1436      *
1437      * To learn more about this see the Solidity documentation for
1438      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1439      * functions].
1440      */
1441     receive() external payable virtual {
1442         emit PaymentReceived(_msgSender(), msg.value);
1443     }
1444 
1445     /**
1446      * @dev Getter for the total shares held by payees.
1447      */
1448     function totalShares() public view returns (uint256) {
1449         return _totalShares;
1450     }
1451 
1452     /**
1453      * @dev Getter for the total amount of Ether already released.
1454      */
1455     function totalReleased() public view returns (uint256) {
1456         return _totalReleased;
1457     }
1458 
1459     /**
1460      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
1461      * contract.
1462      */
1463     function totalReleased(IERC20 token) public view returns (uint256) {
1464         return _erc20TotalReleased[token];
1465     }
1466 
1467     /**
1468      * @dev Getter for the amount of shares held by an account.
1469      */
1470     function shares(address account) public view returns (uint256) {
1471         return _shares[account];
1472     }
1473 
1474     /**
1475      * @dev Getter for the amount of Ether already released to a payee.
1476      */
1477     function released(address account) public view returns (uint256) {
1478         return _released[account];
1479     }
1480 
1481     /**
1482      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
1483      * IERC20 contract.
1484      */
1485     function released(IERC20 token, address account) public view returns (uint256) {
1486         return _erc20Released[token][account];
1487     }
1488 
1489     /**
1490      * @dev Getter for the address of the payee number `index`.
1491      */
1492     function payee(uint256 index) public view returns (address) {
1493         return _payees[index];
1494     }
1495 
1496     /**
1497      * @dev Getter for the amount of payee's releasable Ether.
1498      */
1499     function releasable(address account) public view returns (uint256) {
1500         uint256 totalReceived = address(this).balance + totalReleased();
1501         return _pendingPayment(account, totalReceived, released(account));
1502     }
1503 
1504     /**
1505      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
1506      * IERC20 contract.
1507      */
1508     function releasable(IERC20 token, address account) public view returns (uint256) {
1509         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
1510         return _pendingPayment(account, totalReceived, released(token, account));
1511     }
1512 
1513     /**
1514      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1515      * total shares and their previous withdrawals.
1516      */
1517     function release(address payable account) public virtual {
1518         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1519 
1520         uint256 payment = releasable(account);
1521 
1522         require(payment != 0, "PaymentSplitter: account is not due payment");
1523 
1524         // _totalReleased is the sum of all values in _released.
1525         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
1526         _totalReleased += payment;
1527         unchecked {
1528             _released[account] += payment;
1529         }
1530 
1531         Address.sendValue(account, payment);
1532         emit PaymentReleased(account, payment);
1533     }
1534 
1535     /**
1536      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
1537      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
1538      * contract.
1539      */
1540     function release(IERC20 token, address account) public virtual {
1541         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1542 
1543         uint256 payment = releasable(token, account);
1544 
1545         require(payment != 0, "PaymentSplitter: account is not due payment");
1546 
1547         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
1548         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
1549         // cannot overflow.
1550         _erc20TotalReleased[token] += payment;
1551         unchecked {
1552             _erc20Released[token][account] += payment;
1553         }
1554 
1555         SafeERC20.safeTransfer(token, account, payment);
1556         emit ERC20PaymentReleased(token, account, payment);
1557     }
1558 
1559     /**
1560      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
1561      * already released amounts.
1562      */
1563     function _pendingPayment(
1564         address account,
1565         uint256 totalReceived,
1566         uint256 alreadyReleased
1567     ) private view returns (uint256) {
1568         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
1569     }
1570 
1571     /**
1572      * @dev Add a new payee to the contract.
1573      * @param account The address of the payee to add.
1574      * @param shares_ The number of shares owned by the payee.
1575      */
1576     function _addPayee(address account, uint256 shares_) private {
1577         require(account != address(0), "PaymentSplitter: account is the zero address");
1578         require(shares_ > 0, "PaymentSplitter: shares are 0");
1579         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1580 
1581         _payees.push(account);
1582         _shares[account] = shares_;
1583         _totalShares = _totalShares + shares_;
1584         emit PayeeAdded(account, shares_);
1585     }
1586 }
1587 
1588 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
1589 
1590 
1591 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
1592 
1593 pragma solidity ^0.8.0;
1594 
1595 /**
1596  * @dev Contract module that helps prevent reentrant calls to a function.
1597  *
1598  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
1599  * available, which can be applied to functions to make sure there are no nested
1600  * (reentrant) calls to them.
1601  *
1602  * Note that because there is a single `nonReentrant` guard, functions marked as
1603  * `nonReentrant` may not call one another. This can be worked around by making
1604  * those functions `private`, and then adding `external` `nonReentrant` entry
1605  * points to them.
1606  *
1607  * TIP: If you would like to learn more about reentrancy and alternative ways
1608  * to protect against it, check out our blog post
1609  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
1610  */
1611 abstract contract ReentrancyGuard {
1612     // Booleans are more expensive than uint256 or any type that takes up a full
1613     // word because each write operation emits an extra SLOAD to first read the
1614     // slot's contents, replace the bits taken up by the boolean, and then write
1615     // back. This is the compiler's defense against contract upgrades and
1616     // pointer aliasing, and it cannot be disabled.
1617 
1618     // The values being non-zero value makes deployment a bit more expensive,
1619     // but in exchange the refund on every call to nonReentrant will be lower in
1620     // amount. Since refunds are capped to a percentage of the total
1621     // transaction's gas, it is best to keep them low in cases like this one, to
1622     // increase the likelihood of the full refund coming into effect.
1623     uint256 private constant _NOT_ENTERED = 1;
1624     uint256 private constant _ENTERED = 2;
1625 
1626     uint256 private _status;
1627 
1628     constructor() {
1629         _status = _NOT_ENTERED;
1630     }
1631 
1632     /**
1633      * @dev Prevents a contract from calling itself, directly or indirectly.
1634      * Calling a `nonReentrant` function from another `nonReentrant`
1635      * function is not supported. It is possible to prevent this from happening
1636      * by making the `nonReentrant` function external, and making it call a
1637      * `private` function that does the actual work.
1638      */
1639     modifier nonReentrant() {
1640         _nonReentrantBefore();
1641         _;
1642         _nonReentrantAfter();
1643     }
1644 
1645     function _nonReentrantBefore() private {
1646         // On the first call to nonReentrant, _status will be _NOT_ENTERED
1647         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1648 
1649         // Any calls to nonReentrant after this point will fail
1650         _status = _ENTERED;
1651     }
1652 
1653     function _nonReentrantAfter() private {
1654         // By storing the original value once again, a refund is triggered (see
1655         // https://eips.ethereum.org/EIPS/eip-2200)
1656         _status = _NOT_ENTERED;
1657     }
1658 }
1659 
1660 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/IERC721A.sol
1661 
1662 
1663 // ERC721A Contracts v4.2.3
1664 // Creator: Chiru Labs
1665 
1666 pragma solidity ^0.8.4;
1667 
1668 /**
1669  * @dev Interface of ERC721A.
1670  */
1671 interface IERC721A {
1672     /**
1673      * The caller must own the token or be an approved operator.
1674      */
1675     error ApprovalCallerNotOwnerNorApproved();
1676 
1677     /**
1678      * The token does not exist.
1679      */
1680     error ApprovalQueryForNonexistentToken();
1681 
1682     /**
1683      * Cannot query the balance for the zero address.
1684      */
1685     error BalanceQueryForZeroAddress();
1686 
1687     /**
1688      * Cannot mint to the zero address.
1689      */
1690     error MintToZeroAddress();
1691 
1692     /**
1693      * The quantity of tokens minted must be more than zero.
1694      */
1695     error MintZeroQuantity();
1696 
1697     /**
1698      * The token does not exist.
1699      */
1700     error OwnerQueryForNonexistentToken();
1701 
1702     /**
1703      * The caller must own the token or be an approved operator.
1704      */
1705     error TransferCallerNotOwnerNorApproved();
1706 
1707     /**
1708      * The token must be owned by `from`.
1709      */
1710     error TransferFromIncorrectOwner();
1711 
1712     /**
1713      * Cannot safely transfer to a contract that does not implement the
1714      * ERC721Receiver interface.
1715      */
1716     error TransferToNonERC721ReceiverImplementer();
1717 
1718     /**
1719      * Cannot transfer to the zero address.
1720      */
1721     error TransferToZeroAddress();
1722 
1723     /**
1724      * The token does not exist.
1725      */
1726     error URIQueryForNonexistentToken();
1727 
1728     /**
1729      * The `quantity` minted with ERC2309 exceeds the safety limit.
1730      */
1731     error MintERC2309QuantityExceedsLimit();
1732 
1733     /**
1734      * The `extraData` cannot be set on an unintialized ownership slot.
1735      */
1736     error OwnershipNotInitializedForExtraData();
1737 
1738     // =============================================================
1739     //                            STRUCTS
1740     // =============================================================
1741 
1742     struct TokenOwnership {
1743         // The address of the owner.
1744         address addr;
1745         // Stores the start time of ownership with minimal overhead for tokenomics.
1746         uint64 startTimestamp;
1747         // Whether the token has been burned.
1748         bool burned;
1749         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1750         uint24 extraData;
1751     }
1752 
1753     // =============================================================
1754     //                         TOKEN COUNTERS
1755     // =============================================================
1756 
1757     /**
1758      * @dev Returns the total number of tokens in existence.
1759      * Burned tokens will reduce the count.
1760      * To get the total number of tokens minted, please see {_totalMinted}.
1761      */
1762     function totalSupply() external view returns (uint256);
1763 
1764     // =============================================================
1765     //                            IERC165
1766     // =============================================================
1767 
1768     /**
1769      * @dev Returns true if this contract implements the interface defined by
1770      * `interfaceId`. See the corresponding
1771      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1772      * to learn more about how these ids are created.
1773      *
1774      * This function call must use less than 30000 gas.
1775      */
1776     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1777 
1778     // =============================================================
1779     //                            IERC721
1780     // =============================================================
1781 
1782     /**
1783      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1784      */
1785     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1786 
1787     /**
1788      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1789      */
1790     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1791 
1792     /**
1793      * @dev Emitted when `owner` enables or disables
1794      * (`approved`) `operator` to manage all of its assets.
1795      */
1796     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1797 
1798     /**
1799      * @dev Returns the number of tokens in `owner`'s account.
1800      */
1801     function balanceOf(address owner) external view returns (uint256 balance);
1802 
1803     /**
1804      * @dev Returns the owner of the `tokenId` token.
1805      *
1806      * Requirements:
1807      *
1808      * - `tokenId` must exist.
1809      */
1810     function ownerOf(uint256 tokenId) external view returns (address owner);
1811 
1812     /**
1813      * @dev Safely transfers `tokenId` token from `from` to `to`,
1814      * checking first that contract recipients are aware of the ERC721 protocol
1815      * to prevent tokens from being forever locked.
1816      *
1817      * Requirements:
1818      *
1819      * - `from` cannot be the zero address.
1820      * - `to` cannot be the zero address.
1821      * - `tokenId` token must exist and be owned by `from`.
1822      * - If the caller is not `from`, it must be have been allowed to move
1823      * this token by either {approve} or {setApprovalForAll}.
1824      * - If `to` refers to a smart contract, it must implement
1825      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1826      *
1827      * Emits a {Transfer} event.
1828      */
1829     function safeTransferFrom(
1830         address from,
1831         address to,
1832         uint256 tokenId,
1833         bytes calldata data
1834     ) external payable;
1835 
1836     /**
1837      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1838      */
1839     function safeTransferFrom(
1840         address from,
1841         address to,
1842         uint256 tokenId
1843     ) external payable;
1844 
1845     /**
1846      * @dev Transfers `tokenId` from `from` to `to`.
1847      *
1848      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1849      * whenever possible.
1850      *
1851      * Requirements:
1852      *
1853      * - `from` cannot be the zero address.
1854      * - `to` cannot be the zero address.
1855      * - `tokenId` token must be owned by `from`.
1856      * - If the caller is not `from`, it must be approved to move this token
1857      * by either {approve} or {setApprovalForAll}.
1858      *
1859      * Emits a {Transfer} event.
1860      */
1861     function transferFrom(
1862         address from,
1863         address to,
1864         uint256 tokenId
1865     ) external payable;
1866 
1867     /**
1868      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1869      * The approval is cleared when the token is transferred.
1870      *
1871      * Only a single account can be approved at a time, so approving the
1872      * zero address clears previous approvals.
1873      *
1874      * Requirements:
1875      *
1876      * - The caller must own the token or be an approved operator.
1877      * - `tokenId` must exist.
1878      *
1879      * Emits an {Approval} event.
1880      */
1881     function approve(address to, uint256 tokenId) external payable;
1882 
1883     /**
1884      * @dev Approve or remove `operator` as an operator for the caller.
1885      * Operators can call {transferFrom} or {safeTransferFrom}
1886      * for any token owned by the caller.
1887      *
1888      * Requirements:
1889      *
1890      * - The `operator` cannot be the caller.
1891      *
1892      * Emits an {ApprovalForAll} event.
1893      */
1894     function setApprovalForAll(address operator, bool _approved) external;
1895 
1896     /**
1897      * @dev Returns the account approved for `tokenId` token.
1898      *
1899      * Requirements:
1900      *
1901      * - `tokenId` must exist.
1902      */
1903     function getApproved(uint256 tokenId) external view returns (address operator);
1904 
1905     /**
1906      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1907      *
1908      * See {setApprovalForAll}.
1909      */
1910     function isApprovedForAll(address owner, address operator) external view returns (bool);
1911 
1912     // =============================================================
1913     //                        IERC721Metadata
1914     // =============================================================
1915 
1916     /**
1917      * @dev Returns the token collection name.
1918      */
1919     function name() external view returns (string memory);
1920 
1921     /**
1922      * @dev Returns the token collection symbol.
1923      */
1924     function symbol() external view returns (string memory);
1925 
1926     /**
1927      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1928      */
1929     function tokenURI(uint256 tokenId) external view returns (string memory);
1930 
1931     // =============================================================
1932     //                           IERC2309
1933     // =============================================================
1934 
1935     /**
1936      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1937      * (inclusive) is transferred from `from` to `to`, as defined in the
1938      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1939      *
1940      * See {_mintERC2309} for more details.
1941      */
1942     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1943 }
1944 
1945 // File: https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol
1946 
1947 
1948 // ERC721A Contracts v4.2.3
1949 // Creator: Chiru Labs
1950 
1951 pragma solidity ^0.8.4;
1952 
1953 
1954 /**
1955  * @dev Interface of ERC721 token receiver.
1956  */
1957 interface ERC721A__IERC721Receiver {
1958     function onERC721Received(
1959         address operator,
1960         address from,
1961         uint256 tokenId,
1962         bytes calldata data
1963     ) external returns (bytes4);
1964 }
1965 
1966 /**
1967  * @title ERC721A
1968  *
1969  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1970  * Non-Fungible Token Standard, including the Metadata extension.
1971  * Optimized for lower gas during batch mints.
1972  *
1973  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1974  * starting from `_startTokenId()`.
1975  *
1976  * Assumptions:
1977  *
1978  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1979  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1980  */
1981 contract ERC721A is IERC721A {
1982     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1983     struct TokenApprovalRef {
1984         address value;
1985     }
1986 
1987     // =============================================================
1988     //                           CONSTANTS
1989     // =============================================================
1990 
1991     // Mask of an entry in packed address data.
1992     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1993 
1994     // The bit position of `numberMinted` in packed address data.
1995     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1996 
1997     // The bit position of `numberBurned` in packed address data.
1998     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1999 
2000     // The bit position of `aux` in packed address data.
2001     uint256 private constant _BITPOS_AUX = 192;
2002 
2003     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
2004     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
2005 
2006     // The bit position of `startTimestamp` in packed ownership.
2007     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
2008 
2009     // The bit mask of the `burned` bit in packed ownership.
2010     uint256 private constant _BITMASK_BURNED = 1 << 224;
2011 
2012     // The bit position of the `nextInitialized` bit in packed ownership.
2013     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
2014 
2015     // The bit mask of the `nextInitialized` bit in packed ownership.
2016     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
2017 
2018     // The bit position of `extraData` in packed ownership.
2019     uint256 private constant _BITPOS_EXTRA_DATA = 232;
2020 
2021     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
2022     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
2023 
2024     // The mask of the lower 160 bits for addresses.
2025     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
2026 
2027     // The maximum `quantity` that can be minted with {_mintERC2309}.
2028     // This limit is to prevent overflows on the address data entries.
2029     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
2030     // is required to cause an overflow, which is unrealistic.
2031     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
2032 
2033     // The `Transfer` event signature is given by:
2034     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
2035     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
2036         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
2037 
2038     // =============================================================
2039     //                            STORAGE
2040     // =============================================================
2041 
2042     // The next token ID to be minted.
2043     uint256 private _currentIndex;
2044 
2045     // The number of tokens burned.
2046     uint256 private _burnCounter;
2047 
2048     // Token name
2049     string private _name;
2050 
2051     // Token symbol
2052     string private _symbol;
2053 
2054     // Mapping from token ID to ownership details
2055     // An empty struct value does not necessarily mean the token is unowned.
2056     // See {_packedOwnershipOf} implementation for details.
2057     //
2058     // Bits Layout:
2059     // - [0..159]   `addr`
2060     // - [160..223] `startTimestamp`
2061     // - [224]      `burned`
2062     // - [225]      `nextInitialized`
2063     // - [232..255] `extraData`
2064     mapping(uint256 => uint256) private _packedOwnerships;
2065 
2066     // Mapping owner address to address data.
2067     //
2068     // Bits Layout:
2069     // - [0..63]    `balance`
2070     // - [64..127]  `numberMinted`
2071     // - [128..191] `numberBurned`
2072     // - [192..255] `aux`
2073     mapping(address => uint256) private _packedAddressData;
2074 
2075     // Mapping from token ID to approved address.
2076     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
2077 
2078     // Mapping from owner to operator approvals
2079     mapping(address => mapping(address => bool)) private _operatorApprovals;
2080 
2081     // =============================================================
2082     //                          CONSTRUCTOR
2083     // =============================================================
2084 
2085     constructor(string memory name_, string memory symbol_) {
2086         _name = name_;
2087         _symbol = symbol_;
2088         _currentIndex = _startTokenId();
2089     }
2090 
2091     // =============================================================
2092     //                   TOKEN COUNTING OPERATIONS
2093     // =============================================================
2094 
2095     /**
2096      * @dev Returns the starting token ID.
2097      * To change the starting token ID, please override this function.
2098      */
2099     function _startTokenId() internal view virtual returns (uint256) {
2100         return 0;
2101     }
2102 
2103     /**
2104      * @dev Returns the next token ID to be minted.
2105      */
2106     function _nextTokenId() internal view virtual returns (uint256) {
2107         return _currentIndex;
2108     }
2109 
2110     /**
2111      * @dev Returns the total number of tokens in existence.
2112      * Burned tokens will reduce the count.
2113      * To get the total number of tokens minted, please see {_totalMinted}.
2114      */
2115     function totalSupply() public view virtual override returns (uint256) {
2116         // Counter underflow is impossible as _burnCounter cannot be incremented
2117         // more than `_currentIndex - _startTokenId()` times.
2118         unchecked {
2119             return _currentIndex - _burnCounter - _startTokenId();
2120         }
2121     }
2122 
2123     /**
2124      * @dev Returns the total amount of tokens minted in the contract.
2125      */
2126     function _totalMinted() internal view virtual returns (uint256) {
2127         // Counter underflow is impossible as `_currentIndex` does not decrement,
2128         // and it is initialized to `_startTokenId()`.
2129         unchecked {
2130             return _currentIndex - _startTokenId();
2131         }
2132     }
2133 
2134     /**
2135      * @dev Returns the total number of tokens burned.
2136      */
2137     function _totalBurned() internal view virtual returns (uint256) {
2138         return _burnCounter;
2139     }
2140 
2141     // =============================================================
2142     //                    ADDRESS DATA OPERATIONS
2143     // =============================================================
2144 
2145     /**
2146      * @dev Returns the number of tokens in `owner`'s account.
2147      */
2148     function balanceOf(address owner) public view virtual override returns (uint256) {
2149         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2150         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2151     }
2152 
2153     /**
2154      * Returns the number of tokens minted by `owner`.
2155      */
2156     function _numberMinted(address owner) internal view returns (uint256) {
2157         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2158     }
2159 
2160     /**
2161      * Returns the number of tokens burned by or on behalf of `owner`.
2162      */
2163     function _numberBurned(address owner) internal view returns (uint256) {
2164         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2165     }
2166 
2167     /**
2168      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2169      */
2170     function _getAux(address owner) internal view returns (uint64) {
2171         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2172     }
2173 
2174     /**
2175      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2176      * If there are multiple variables, please pack them into a uint64.
2177      */
2178     function _setAux(address owner, uint64 aux) internal virtual {
2179         uint256 packed = _packedAddressData[owner];
2180         uint256 auxCasted;
2181         // Cast `aux` with assembly to avoid redundant masking.
2182         assembly {
2183             auxCasted := aux
2184         }
2185         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2186         _packedAddressData[owner] = packed;
2187     }
2188 
2189     // =============================================================
2190     //                            IERC165
2191     // =============================================================
2192 
2193     /**
2194      * @dev Returns true if this contract implements the interface defined by
2195      * `interfaceId`. See the corresponding
2196      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2197      * to learn more about how these ids are created.
2198      *
2199      * This function call must use less than 30000 gas.
2200      */
2201     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2202         // The interface IDs are constants representing the first 4 bytes
2203         // of the XOR of all function selectors in the interface.
2204         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2205         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2206         return
2207             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2208             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2209             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2210     }
2211 
2212     // =============================================================
2213     //                        IERC721Metadata
2214     // =============================================================
2215 
2216     /**
2217      * @dev Returns the token collection name.
2218      */
2219     function name() public view virtual override returns (string memory) {
2220         return _name;
2221     }
2222 
2223     /**
2224      * @dev Returns the token collection symbol.
2225      */
2226     function symbol() public view virtual override returns (string memory) {
2227         return _symbol;
2228     }
2229 
2230     /**
2231      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2232      */
2233     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2234         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2235 
2236         string memory baseURI = _baseURI();
2237         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2238     }
2239 
2240     /**
2241      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2242      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2243      * by default, it can be overridden in child contracts.
2244      */
2245     function _baseURI() internal view virtual returns (string memory) {
2246         return '';
2247     }
2248 
2249     // =============================================================
2250     //                     OWNERSHIPS OPERATIONS
2251     // =============================================================
2252 
2253     /**
2254      * @dev Returns the owner of the `tokenId` token.
2255      *
2256      * Requirements:
2257      *
2258      * - `tokenId` must exist.
2259      */
2260     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2261         return address(uint160(_packedOwnershipOf(tokenId)));
2262     }
2263 
2264     /**
2265      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2266      * It gradually moves to O(1) as tokens get transferred around over time.
2267      */
2268     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2269         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2270     }
2271 
2272     /**
2273      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2274      */
2275     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2276         return _unpackedOwnership(_packedOwnerships[index]);
2277     }
2278 
2279     /**
2280      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2281      */
2282     function _initializeOwnershipAt(uint256 index) internal virtual {
2283         if (_packedOwnerships[index] == 0) {
2284             _packedOwnerships[index] = _packedOwnershipOf(index);
2285         }
2286     }
2287 
2288     /**
2289      * Returns the packed ownership data of `tokenId`.
2290      */
2291     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256 packed) {
2292         if (_startTokenId() <= tokenId) {
2293             packed = _packedOwnerships[tokenId];
2294             // If not burned.
2295             if (packed & _BITMASK_BURNED == 0) {
2296                 // If the data at the starting slot does not exist, start the scan.
2297                 if (packed == 0) {
2298                     if (tokenId >= _currentIndex) revert OwnerQueryForNonexistentToken();
2299                     // Invariant:
2300                     // There will always be an initialized ownership slot
2301                     // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2302                     // before an unintialized ownership slot
2303                     // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2304                     // Hence, `tokenId` will not underflow.
2305                     //
2306                     // We can directly compare the packed value.
2307                     // If the address is zero, packed will be zero.
2308                     for (;;) {
2309                         unchecked {
2310                             packed = _packedOwnerships[--tokenId];
2311                         }
2312                         if (packed == 0) continue;
2313                         return packed;
2314                     }
2315                 }
2316                 // Otherwise, the data exists and is not burned. We can skip the scan.
2317                 // This is possible because we have already achieved the target condition.
2318                 // This saves 2143 gas on transfers of initialized tokens.
2319                 return packed;
2320             }
2321         }
2322         revert OwnerQueryForNonexistentToken();
2323     }
2324 
2325     /**
2326      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2327      */
2328     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2329         ownership.addr = address(uint160(packed));
2330         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2331         ownership.burned = packed & _BITMASK_BURNED != 0;
2332         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2333     }
2334 
2335     /**
2336      * @dev Packs ownership data into a single uint256.
2337      */
2338     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2339         assembly {
2340             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2341             owner := and(owner, _BITMASK_ADDRESS)
2342             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2343             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2344         }
2345     }
2346 
2347     /**
2348      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2349      */
2350     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2351         // For branchless setting of the `nextInitialized` flag.
2352         assembly {
2353             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2354             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2355         }
2356     }
2357 
2358     // =============================================================
2359     //                      APPROVAL OPERATIONS
2360     // =============================================================
2361 
2362     /**
2363      * @dev Gives permission to `to` to transfer `tokenId` token to another account. See {ERC721A-_approve}.
2364      *
2365      * Requirements:
2366      *
2367      * - The caller must own the token or be an approved operator.
2368      */
2369     function approve(address to, uint256 tokenId) public payable virtual override {
2370         _approve(to, tokenId, true);
2371     }
2372 
2373     /**
2374      * @dev Returns the account approved for `tokenId` token.
2375      *
2376      * Requirements:
2377      *
2378      * - `tokenId` must exist.
2379      */
2380     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2381         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2382 
2383         return _tokenApprovals[tokenId].value;
2384     }
2385 
2386     /**
2387      * @dev Approve or remove `operator` as an operator for the caller.
2388      * Operators can call {transferFrom} or {safeTransferFrom}
2389      * for any token owned by the caller.
2390      *
2391      * Requirements:
2392      *
2393      * - The `operator` cannot be the caller.
2394      *
2395      * Emits an {ApprovalForAll} event.
2396      */
2397     function setApprovalForAll(address operator, bool approved) public virtual override {
2398         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2399         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2400     }
2401 
2402     /**
2403      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2404      *
2405      * See {setApprovalForAll}.
2406      */
2407     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2408         return _operatorApprovals[owner][operator];
2409     }
2410 
2411     /**
2412      * @dev Returns whether `tokenId` exists.
2413      *
2414      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2415      *
2416      * Tokens start existing when they are minted. See {_mint}.
2417      */
2418     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2419         return
2420             _startTokenId() <= tokenId &&
2421             tokenId < _currentIndex && // If within bounds,
2422             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2423     }
2424 
2425     /**
2426      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2427      */
2428     function _isSenderApprovedOrOwner(
2429         address approvedAddress,
2430         address owner,
2431         address msgSender
2432     ) private pure returns (bool result) {
2433         assembly {
2434             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2435             owner := and(owner, _BITMASK_ADDRESS)
2436             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2437             msgSender := and(msgSender, _BITMASK_ADDRESS)
2438             // `msgSender == owner || msgSender == approvedAddress`.
2439             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2440         }
2441     }
2442 
2443     /**
2444      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2445      */
2446     function _getApprovedSlotAndAddress(uint256 tokenId)
2447         private
2448         view
2449         returns (uint256 approvedAddressSlot, address approvedAddress)
2450     {
2451         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2452         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2453         assembly {
2454             approvedAddressSlot := tokenApproval.slot
2455             approvedAddress := sload(approvedAddressSlot)
2456         }
2457     }
2458 
2459     // =============================================================
2460     //                      TRANSFER OPERATIONS
2461     // =============================================================
2462 
2463     /**
2464      * @dev Transfers `tokenId` from `from` to `to`.
2465      *
2466      * Requirements:
2467      *
2468      * - `from` cannot be the zero address.
2469      * - `to` cannot be the zero address.
2470      * - `tokenId` token must be owned by `from`.
2471      * - If the caller is not `from`, it must be approved to move this token
2472      * by either {approve} or {setApprovalForAll}.
2473      *
2474      * Emits a {Transfer} event.
2475      */
2476     function transferFrom(
2477         address from,
2478         address to,
2479         uint256 tokenId
2480     ) public payable virtual override {
2481         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2482 
2483         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2484 
2485         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2486 
2487         // The nested ifs save around 20+ gas over a compound boolean condition.
2488         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2489             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2490 
2491         if (to == address(0)) revert TransferToZeroAddress();
2492 
2493         _beforeTokenTransfers(from, to, tokenId, 1);
2494 
2495         // Clear approvals from the previous owner.
2496         assembly {
2497             if approvedAddress {
2498                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2499                 sstore(approvedAddressSlot, 0)
2500             }
2501         }
2502 
2503         // Underflow of the sender's balance is impossible because we check for
2504         // ownership above and the recipient's balance can't realistically overflow.
2505         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2506         unchecked {
2507             // We can directly increment and decrement the balances.
2508             --_packedAddressData[from]; // Updates: `balance -= 1`.
2509             ++_packedAddressData[to]; // Updates: `balance += 1`.
2510 
2511             // Updates:
2512             // - `address` to the next owner.
2513             // - `startTimestamp` to the timestamp of transfering.
2514             // - `burned` to `false`.
2515             // - `nextInitialized` to `true`.
2516             _packedOwnerships[tokenId] = _packOwnershipData(
2517                 to,
2518                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2519             );
2520 
2521             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2522             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2523                 uint256 nextTokenId = tokenId + 1;
2524                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2525                 if (_packedOwnerships[nextTokenId] == 0) {
2526                     // If the next slot is within bounds.
2527                     if (nextTokenId != _currentIndex) {
2528                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2529                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2530                     }
2531                 }
2532             }
2533         }
2534 
2535         emit Transfer(from, to, tokenId);
2536         _afterTokenTransfers(from, to, tokenId, 1);
2537     }
2538 
2539     /**
2540      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2541      */
2542     function safeTransferFrom(
2543         address from,
2544         address to,
2545         uint256 tokenId
2546     ) public payable virtual override {
2547         safeTransferFrom(from, to, tokenId, '');
2548     }
2549 
2550     /**
2551      * @dev Safely transfers `tokenId` token from `from` to `to`.
2552      *
2553      * Requirements:
2554      *
2555      * - `from` cannot be the zero address.
2556      * - `to` cannot be the zero address.
2557      * - `tokenId` token must exist and be owned by `from`.
2558      * - If the caller is not `from`, it must be approved to move this token
2559      * by either {approve} or {setApprovalForAll}.
2560      * - If `to` refers to a smart contract, it must implement
2561      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2562      *
2563      * Emits a {Transfer} event.
2564      */
2565     function safeTransferFrom(
2566         address from,
2567         address to,
2568         uint256 tokenId,
2569         bytes memory _data
2570     ) public payable virtual override {
2571         transferFrom(from, to, tokenId);
2572         if (to.code.length != 0)
2573             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2574                 revert TransferToNonERC721ReceiverImplementer();
2575             }
2576     }
2577 
2578     /**
2579      * @dev Hook that is called before a set of serially-ordered token IDs
2580      * are about to be transferred. This includes minting.
2581      * And also called before burning one token.
2582      *
2583      * `startTokenId` - the first token ID to be transferred.
2584      * `quantity` - the amount to be transferred.
2585      *
2586      * Calling conditions:
2587      *
2588      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2589      * transferred to `to`.
2590      * - When `from` is zero, `tokenId` will be minted for `to`.
2591      * - When `to` is zero, `tokenId` will be burned by `from`.
2592      * - `from` and `to` are never both zero.
2593      */
2594     function _beforeTokenTransfers(
2595         address from,
2596         address to,
2597         uint256 startTokenId,
2598         uint256 quantity
2599     ) internal virtual {}
2600 
2601     /**
2602      * @dev Hook that is called after a set of serially-ordered token IDs
2603      * have been transferred. This includes minting.
2604      * And also called after one token has been burned.
2605      *
2606      * `startTokenId` - the first token ID to be transferred.
2607      * `quantity` - the amount to be transferred.
2608      *
2609      * Calling conditions:
2610      *
2611      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2612      * transferred to `to`.
2613      * - When `from` is zero, `tokenId` has been minted for `to`.
2614      * - When `to` is zero, `tokenId` has been burned by `from`.
2615      * - `from` and `to` are never both zero.
2616      */
2617     function _afterTokenTransfers(
2618         address from,
2619         address to,
2620         uint256 startTokenId,
2621         uint256 quantity
2622     ) internal virtual {}
2623 
2624     /**
2625      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2626      *
2627      * `from` - Previous owner of the given token ID.
2628      * `to` - Target address that will receive the token.
2629      * `tokenId` - Token ID to be transferred.
2630      * `_data` - Optional data to send along with the call.
2631      *
2632      * Returns whether the call correctly returned the expected magic value.
2633      */
2634     function _checkContractOnERC721Received(
2635         address from,
2636         address to,
2637         uint256 tokenId,
2638         bytes memory _data
2639     ) private returns (bool) {
2640         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2641             bytes4 retval
2642         ) {
2643             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2644         } catch (bytes memory reason) {
2645             if (reason.length == 0) {
2646                 revert TransferToNonERC721ReceiverImplementer();
2647             } else {
2648                 assembly {
2649                     revert(add(32, reason), mload(reason))
2650                 }
2651             }
2652         }
2653     }
2654 
2655     // =============================================================
2656     //                        MINT OPERATIONS
2657     // =============================================================
2658 
2659     /**
2660      * @dev Mints `quantity` tokens and transfers them to `to`.
2661      *
2662      * Requirements:
2663      *
2664      * - `to` cannot be the zero address.
2665      * - `quantity` must be greater than 0.
2666      *
2667      * Emits a {Transfer} event for each mint.
2668      */
2669     function _mint(address to, uint256 quantity) internal virtual {
2670         uint256 startTokenId = _currentIndex;
2671         if (quantity == 0) revert MintZeroQuantity();
2672 
2673         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2674 
2675         // Overflows are incredibly unrealistic.
2676         // `balance` and `numberMinted` have a maximum limit of 2**64.
2677         // `tokenId` has a maximum limit of 2**256.
2678         unchecked {
2679             // Updates:
2680             // - `balance += quantity`.
2681             // - `numberMinted += quantity`.
2682             //
2683             // We can directly add to the `balance` and `numberMinted`.
2684             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2685 
2686             // Updates:
2687             // - `address` to the owner.
2688             // - `startTimestamp` to the timestamp of minting.
2689             // - `burned` to `false`.
2690             // - `nextInitialized` to `quantity == 1`.
2691             _packedOwnerships[startTokenId] = _packOwnershipData(
2692                 to,
2693                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2694             );
2695 
2696             uint256 toMasked;
2697             uint256 end = startTokenId + quantity;
2698 
2699             // Use assembly to loop and emit the `Transfer` event for gas savings.
2700             // The duplicated `log4` removes an extra check and reduces stack juggling.
2701             // The assembly, together with the surrounding Solidity code, have been
2702             // delicately arranged to nudge the compiler into producing optimized opcodes.
2703             assembly {
2704                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2705                 toMasked := and(to, _BITMASK_ADDRESS)
2706                 // Emit the `Transfer` event.
2707                 log4(
2708                     0, // Start of data (0, since no data).
2709                     0, // End of data (0, since no data).
2710                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2711                     0, // `address(0)`.
2712                     toMasked, // `to`.
2713                     startTokenId // `tokenId`.
2714                 )
2715 
2716                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2717                 // that overflows uint256 will make the loop run out of gas.
2718                 // The compiler will optimize the `iszero` away for performance.
2719                 for {
2720                     let tokenId := add(startTokenId, 1)
2721                 } iszero(eq(tokenId, end)) {
2722                     tokenId := add(tokenId, 1)
2723                 } {
2724                     // Emit the `Transfer` event. Similar to above.
2725                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2726                 }
2727             }
2728             if (toMasked == 0) revert MintToZeroAddress();
2729 
2730             _currentIndex = end;
2731         }
2732         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2733     }
2734 
2735     /**
2736      * @dev Mints `quantity` tokens and transfers them to `to`.
2737      *
2738      * This function is intended for efficient minting only during contract creation.
2739      *
2740      * It emits only one {ConsecutiveTransfer} as defined in
2741      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2742      * instead of a sequence of {Transfer} event(s).
2743      *
2744      * Calling this function outside of contract creation WILL make your contract
2745      * non-compliant with the ERC721 standard.
2746      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2747      * {ConsecutiveTransfer} event is only permissible during contract creation.
2748      *
2749      * Requirements:
2750      *
2751      * - `to` cannot be the zero address.
2752      * - `quantity` must be greater than 0.
2753      *
2754      * Emits a {ConsecutiveTransfer} event.
2755      */
2756     function _mintERC2309(address to, uint256 quantity) internal virtual {
2757         uint256 startTokenId = _currentIndex;
2758         if (to == address(0)) revert MintToZeroAddress();
2759         if (quantity == 0) revert MintZeroQuantity();
2760         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2761 
2762         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2763 
2764         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2765         unchecked {
2766             // Updates:
2767             // - `balance += quantity`.
2768             // - `numberMinted += quantity`.
2769             //
2770             // We can directly add to the `balance` and `numberMinted`.
2771             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2772 
2773             // Updates:
2774             // - `address` to the owner.
2775             // - `startTimestamp` to the timestamp of minting.
2776             // - `burned` to `false`.
2777             // - `nextInitialized` to `quantity == 1`.
2778             _packedOwnerships[startTokenId] = _packOwnershipData(
2779                 to,
2780                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2781             );
2782 
2783             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2784 
2785             _currentIndex = startTokenId + quantity;
2786         }
2787         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2788     }
2789 
2790     /**
2791      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2792      *
2793      * Requirements:
2794      *
2795      * - If `to` refers to a smart contract, it must implement
2796      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2797      * - `quantity` must be greater than 0.
2798      *
2799      * See {_mint}.
2800      *
2801      * Emits a {Transfer} event for each mint.
2802      */
2803     function _safeMint(
2804         address to,
2805         uint256 quantity,
2806         bytes memory _data
2807     ) internal virtual {
2808         _mint(to, quantity);
2809 
2810         unchecked {
2811             if (to.code.length != 0) {
2812                 uint256 end = _currentIndex;
2813                 uint256 index = end - quantity;
2814                 do {
2815                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2816                         revert TransferToNonERC721ReceiverImplementer();
2817                     }
2818                 } while (index < end);
2819                 // Reentrancy protection.
2820                 if (_currentIndex != end) revert();
2821             }
2822         }
2823     }
2824 
2825     /**
2826      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2827      */
2828     function _safeMint(address to, uint256 quantity) internal virtual {
2829         _safeMint(to, quantity, '');
2830     }
2831 
2832     // =============================================================
2833     //                       APPROVAL OPERATIONS
2834     // =============================================================
2835 
2836     /**
2837      * @dev Equivalent to `_approve(to, tokenId, false)`.
2838      */
2839     function _approve(address to, uint256 tokenId) internal virtual {
2840         _approve(to, tokenId, false);
2841     }
2842 
2843     /**
2844      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2845      * The approval is cleared when the token is transferred.
2846      *
2847      * Only a single account can be approved at a time, so approving the
2848      * zero address clears previous approvals.
2849      *
2850      * Requirements:
2851      *
2852      * - `tokenId` must exist.
2853      *
2854      * Emits an {Approval} event.
2855      */
2856     function _approve(
2857         address to,
2858         uint256 tokenId,
2859         bool approvalCheck
2860     ) internal virtual {
2861         address owner = ownerOf(tokenId);
2862 
2863         if (approvalCheck)
2864             if (_msgSenderERC721A() != owner)
2865                 if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2866                     revert ApprovalCallerNotOwnerNorApproved();
2867                 }
2868 
2869         _tokenApprovals[tokenId].value = to;
2870         emit Approval(owner, to, tokenId);
2871     }
2872 
2873     // =============================================================
2874     //                        BURN OPERATIONS
2875     // =============================================================
2876 
2877     /**
2878      * @dev Equivalent to `_burn(tokenId, false)`.
2879      */
2880     function _burn(uint256 tokenId) internal virtual {
2881         _burn(tokenId, false);
2882     }
2883 
2884     /**
2885      * @dev Destroys `tokenId`.
2886      * The approval is cleared when the token is burned.
2887      *
2888      * Requirements:
2889      *
2890      * - `tokenId` must exist.
2891      *
2892      * Emits a {Transfer} event.
2893      */
2894     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2895         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2896 
2897         address from = address(uint160(prevOwnershipPacked));
2898 
2899         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2900 
2901         if (approvalCheck) {
2902             // The nested ifs save around 20+ gas over a compound boolean condition.
2903             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2904                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2905         }
2906 
2907         _beforeTokenTransfers(from, address(0), tokenId, 1);
2908 
2909         // Clear approvals from the previous owner.
2910         assembly {
2911             if approvedAddress {
2912                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2913                 sstore(approvedAddressSlot, 0)
2914             }
2915         }
2916 
2917         // Underflow of the sender's balance is impossible because we check for
2918         // ownership above and the recipient's balance can't realistically overflow.
2919         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2920         unchecked {
2921             // Updates:
2922             // - `balance -= 1`.
2923             // - `numberBurned += 1`.
2924             //
2925             // We can directly decrement the balance, and increment the number burned.
2926             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2927             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2928 
2929             // Updates:
2930             // - `address` to the last owner.
2931             // - `startTimestamp` to the timestamp of burning.
2932             // - `burned` to `true`.
2933             // - `nextInitialized` to `true`.
2934             _packedOwnerships[tokenId] = _packOwnershipData(
2935                 from,
2936                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2937             );
2938 
2939             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2940             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2941                 uint256 nextTokenId = tokenId + 1;
2942                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2943                 if (_packedOwnerships[nextTokenId] == 0) {
2944                     // If the next slot is within bounds.
2945                     if (nextTokenId != _currentIndex) {
2946                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2947                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2948                     }
2949                 }
2950             }
2951         }
2952 
2953         emit Transfer(from, address(0), tokenId);
2954         _afterTokenTransfers(from, address(0), tokenId, 1);
2955 
2956         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2957         unchecked {
2958             _burnCounter++;
2959         }
2960     }
2961 
2962     // =============================================================
2963     //                     EXTRA DATA OPERATIONS
2964     // =============================================================
2965 
2966     /**
2967      * @dev Directly sets the extra data for the ownership data `index`.
2968      */
2969     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2970         uint256 packed = _packedOwnerships[index];
2971         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2972         uint256 extraDataCasted;
2973         // Cast `extraData` with assembly to avoid redundant masking.
2974         assembly {
2975             extraDataCasted := extraData
2976         }
2977         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2978         _packedOwnerships[index] = packed;
2979     }
2980 
2981     /**
2982      * @dev Called during each token transfer to set the 24bit `extraData` field.
2983      * Intended to be overridden by the cosumer contract.
2984      *
2985      * `previousExtraData` - the value of `extraData` before transfer.
2986      *
2987      * Calling conditions:
2988      *
2989      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2990      * transferred to `to`.
2991      * - When `from` is zero, `tokenId` will be minted for `to`.
2992      * - When `to` is zero, `tokenId` will be burned by `from`.
2993      * - `from` and `to` are never both zero.
2994      */
2995     function _extraData(
2996         address from,
2997         address to,
2998         uint24 previousExtraData
2999     ) internal view virtual returns (uint24) {}
3000 
3001     /**
3002      * @dev Returns the next extra data for the packed ownership data.
3003      * The returned result is shifted into position.
3004      */
3005     function _nextExtraData(
3006         address from,
3007         address to,
3008         uint256 prevOwnershipPacked
3009     ) private view returns (uint256) {
3010         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
3011         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
3012     }
3013 
3014     // =============================================================
3015     //                       OTHER OPERATIONS
3016     // =============================================================
3017 
3018     /**
3019      * @dev Returns the message sender (defaults to `msg.sender`).
3020      *
3021      * If you are writing GSN compatible contracts, you need to override this function.
3022      */
3023     function _msgSenderERC721A() internal view virtual returns (address) {
3024         return msg.sender;
3025     }
3026 
3027     /**
3028      * @dev Converts a uint256 to its ASCII string decimal representation.
3029      */
3030     function _toString(uint256 value) internal pure virtual returns (string memory str) {
3031         assembly {
3032             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
3033             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
3034             // We will need 1 word for the trailing zeros padding, 1 word for the length,
3035             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
3036             let m := add(mload(0x40), 0xa0)
3037             // Update the free memory pointer to allocate.
3038             mstore(0x40, m)
3039             // Assign the `str` to the end.
3040             str := sub(m, 0x20)
3041             // Zeroize the slot after the string.
3042             mstore(str, 0)
3043 
3044             // Cache the end of the memory to calculate the length later.
3045             let end := str
3046 
3047             // We write the string from rightmost digit to leftmost digit.
3048             // The following is essentially a do-while loop that also handles the zero case.
3049             // prettier-ignore
3050             for { let temp := value } 1 {} {
3051                 str := sub(str, 1)
3052                 // Write the character to the pointer.
3053                 // The ASCII index of the '0' character is 48.
3054                 mstore8(str, add(48, mod(temp, 10)))
3055                 // Keep dividing `temp` until zero.
3056                 temp := div(temp, 10)
3057                 // prettier-ignore
3058                 if iszero(temp) { break }
3059             }
3060 
3061             let length := sub(end, str)
3062             // Move the pointer 32 bytes leftwards to make room for the length.
3063             str := sub(str, 0x20)
3064             // Store the length.
3065             mstore(str, length)
3066         }
3067     }
3068 }
3069 
3070 pragma solidity ^ 0.8.2;
3071 contract Cream is ERC721A, Ownable, ReentrancyGuard, DefaultOperatorFilterer {
3072 
3073     /// @notice status booleans for phases 
3074     bool public isAllowlistActive = false;
3075 
3076     /// @notice settings for future burn utility
3077     address public meltContract;
3078     bool public isMeltActive = false;
3079     bool public meltDependent = false;
3080 
3081     /// @notice signer for allowlist
3082     address private signer = 0x9178080862BB0b4DDf91Ec3C3DB2A184C068180a;
3083 
3084     /// @notice collection settings
3085     uint256 public MAX_SUPPLY = 2222;
3086     uint256 private maxMintPerWalletAllowlist = 5;
3087 
3088     /// @notice mnetadata path
3089     string public _metadata;
3090 
3091     /// @notice tracks number minted per person for each phase
3092     mapping(address => uint256) public numMintedPerPersonAllowlist;
3093 
3094     constructor() ERC721A("Cream", "ICS") {}
3095 
3096     /// @notice mint allowlist
3097     function mintAllowlist(address _address, bytes calldata _voucher, uint256 _tokenAmount) external nonReentrant {
3098         uint256 ts = totalSupply();
3099         require(isAllowlistActive);
3100         require(_tokenAmount <= maxMintPerWalletAllowlist, "Purchase would exceed max tokens per tx in this phase");
3101         require(ts + _tokenAmount <= MAX_SUPPLY, "Purchase would exceed max tokens in the allowlist");
3102         require(msg.sender == _address, "Not your voucher");
3103         require(msg.sender == tx.origin);
3104         require(numMintedPerPersonAllowlist[_address] + _tokenAmount <= maxMintPerWalletAllowlist, "Purchase would exceed max tokens per Wallet");
3105 
3106         bytes32 hash = keccak256(
3107             abi.encodePacked(_address)
3108         );
3109         require(_verifySignature(signer, hash, _voucher), "Invalid voucher");
3110 
3111         _safeMint(_address, _tokenAmount);
3112         numMintedPerPersonAllowlist[_address] += _tokenAmount;
3113     }
3114 
3115 
3116     /// @notice reserve to wallets, only owner
3117     function reserve(address addr, uint256 _tokenAmount) public onlyOwner {
3118         uint256 ts = totalSupply();
3119         require(ts + _tokenAmount <= MAX_SUPPLY);
3120         _safeMint(addr, _tokenAmount);
3121     }
3122 
3123     /// @notice melt token, future utility
3124     function melt(uint256 token) external {
3125         require(isMeltActive);
3126         if (meltDependent) {
3127             require(tx.origin == meltContract || msg.sender == meltContract);
3128             _burn(token);
3129         } else {
3130             require(ownerOf(token) == msg.sender);
3131             _burn(token);
3132         }
3133     }
3134 
3135     /// @notice verify voucher
3136     function _verifySignature(address _signer, bytes32 _hash, bytes memory _signature) private pure returns(bool) {
3137         return _signer == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
3138     }
3139 
3140     /// @notice set signer for signature
3141     function setSigner(address _signer) external onlyOwner {
3142         signer = _signer;
3143     }
3144 
3145     /// @notice set allowlist active
3146     function setAllowlist(bool _status) external onlyOwner {
3147         isAllowlistActive = _status;
3148     }
3149 
3150     /// @notice set melt active
3151     function setMelt(bool _status) external onlyOwner {
3152         isMeltActive = _status;
3153     }
3154 
3155     /// @notice set future melt utility contract
3156     function setMeltContract(address _contract) external onlyOwner {
3157         meltContract = _contract;
3158     }
3159 
3160     /// @notice set burn dependent on a external contract
3161     function setMeltDependent(bool _status) external onlyOwner {
3162         meltDependent = _status;
3163     }
3164 
3165     /// @notice set max mint per wallet for allowlist
3166     function setMaxMintPerWalletAllowlist(uint256 _amount) external onlyOwner {
3167         maxMintPerWalletAllowlist = _amount;
3168     }
3169 
3170     /// @notice set metadata path
3171     function setMetadata(string memory metadata_) external onlyOwner {
3172         _metadata = metadata_;
3173     }
3174 
3175     /// @notice read metadata
3176     function _baseURI() internal view virtual override returns(string memory) {
3177         return _metadata;
3178     }
3179 
3180     /// @notice withdraw funds to deployer wallet
3181     function withdraw() public payable onlyOwner {
3182         (bool success, ) = payable(msg.sender).call {
3183             value: address(this).balance
3184         }("");
3185         require(success);
3186     }
3187 
3188     /// @notice opensea royalty filter
3189 
3190    function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
3191        super.setApprovalForAll(operator, approved);
3192    }
3193  
3194    function approve(address operator, uint256 tokenId) public payable override onlyAllowedOperatorApproval(operator) {
3195        super.approve(operator, tokenId);
3196    }
3197  
3198    function transferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
3199        super.transferFrom(from, to, tokenId);
3200    }
3201  
3202    function safeTransferFrom(address from, address to, uint256 tokenId) public payable override onlyAllowedOperator(from) {
3203        super.safeTransferFrom(from, to, tokenId);
3204    }
3205  
3206    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data)
3207        public
3208        override
3209        payable
3210        onlyAllowedOperator(from)
3211    {
3212        super.safeTransferFrom(from, to, tokenId, data);
3213    }
3214 
3215 }