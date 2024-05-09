1 // File: @openzeppelin/contracts/utils/math/Math.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Standard math utilities missing in the Solidity language.
10  */
11 library Math {
12     enum Rounding {
13         Down, // Toward negative infinity
14         Up, // Toward infinity
15         Zero // Toward zero
16     }
17 
18     /**
19      * @dev Returns the largest of two numbers.
20      */
21     function max(uint256 a, uint256 b) internal pure returns (uint256) {
22         return a > b ? a : b;
23     }
24 
25     /**
26      * @dev Returns the smallest of two numbers.
27      */
28     function min(uint256 a, uint256 b) internal pure returns (uint256) {
29         return a < b ? a : b;
30     }
31 
32     /**
33      * @dev Returns the average of two numbers. The result is rounded towards
34      * zero.
35      */
36     function average(uint256 a, uint256 b) internal pure returns (uint256) {
37         // (a + b) / 2 can overflow.
38         return (a & b) + (a ^ b) / 2;
39     }
40 
41     /**
42      * @dev Returns the ceiling of the division of two numbers.
43      *
44      * This differs from standard division with `/` in that it rounds up instead
45      * of rounding down.
46      */
47     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
48         // (a + b - 1) / b can overflow on addition, so we distribute.
49         return a == 0 ? 0 : (a - 1) / b + 1;
50     }
51 
52     /**
53      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
54      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
55      * with further edits by Uniswap Labs also under MIT license.
56      */
57     function mulDiv(
58         uint256 x,
59         uint256 y,
60         uint256 denominator
61     ) internal pure returns (uint256 result) {
62         unchecked {
63             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
64             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
65             // variables such that product = prod1 * 2^256 + prod0.
66             uint256 prod0; // Least significant 256 bits of the product
67             uint256 prod1; // Most significant 256 bits of the product
68             assembly {
69                 let mm := mulmod(x, y, not(0))
70                 prod0 := mul(x, y)
71                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
72             }
73 
74             // Handle non-overflow cases, 256 by 256 division.
75             if (prod1 == 0) {
76                 return prod0 / denominator;
77             }
78 
79             // Make sure the result is less than 2^256. Also prevents denominator == 0.
80             require(denominator > prod1);
81 
82             ///////////////////////////////////////////////
83             // 512 by 256 division.
84             ///////////////////////////////////////////////
85 
86             // Make division exact by subtracting the remainder from [prod1 prod0].
87             uint256 remainder;
88             assembly {
89                 // Compute remainder using mulmod.
90                 remainder := mulmod(x, y, denominator)
91 
92                 // Subtract 256 bit number from 512 bit number.
93                 prod1 := sub(prod1, gt(remainder, prod0))
94                 prod0 := sub(prod0, remainder)
95             }
96 
97             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
98             // See https://cs.stackexchange.com/q/138556/92363.
99 
100             // Does not overflow because the denominator cannot be zero at this stage in the function.
101             uint256 twos = denominator & (~denominator + 1);
102             assembly {
103                 // Divide denominator by twos.
104                 denominator := div(denominator, twos)
105 
106                 // Divide [prod1 prod0] by twos.
107                 prod0 := div(prod0, twos)
108 
109                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
110                 twos := add(div(sub(0, twos), twos), 1)
111             }
112 
113             // Shift in bits from prod1 into prod0.
114             prod0 |= prod1 * twos;
115 
116             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
117             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
118             // four bits. That is, denominator * inv = 1 mod 2^4.
119             uint256 inverse = (3 * denominator) ^ 2;
120 
121             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
122             // in modular arithmetic, doubling the correct bits in each step.
123             inverse *= 2 - denominator * inverse; // inverse mod 2^8
124             inverse *= 2 - denominator * inverse; // inverse mod 2^16
125             inverse *= 2 - denominator * inverse; // inverse mod 2^32
126             inverse *= 2 - denominator * inverse; // inverse mod 2^64
127             inverse *= 2 - denominator * inverse; // inverse mod 2^128
128             inverse *= 2 - denominator * inverse; // inverse mod 2^256
129 
130             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
131             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
132             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
133             // is no longer required.
134             result = prod0 * inverse;
135             return result;
136         }
137     }
138 
139     /**
140      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
141      */
142     function mulDiv(
143         uint256 x,
144         uint256 y,
145         uint256 denominator,
146         Rounding rounding
147     ) internal pure returns (uint256) {
148         uint256 result = mulDiv(x, y, denominator);
149         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
150             result += 1;
151         }
152         return result;
153     }
154 
155     /**
156      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
157      *
158      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
159      */
160     function sqrt(uint256 a) internal pure returns (uint256) {
161         if (a == 0) {
162             return 0;
163         }
164 
165         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
166         //
167         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
168         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
169         //
170         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
171         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
172         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
173         //
174         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
175         uint256 result = 1 << (log2(a) >> 1);
176 
177         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
178         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
179         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
180         // into the expected uint128 result.
181         unchecked {
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             return min(result, a / result);
190         }
191     }
192 
193     /**
194      * @notice Calculates sqrt(a), following the selected rounding direction.
195      */
196     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
197         unchecked {
198             uint256 result = sqrt(a);
199             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
200         }
201     }
202 
203     /**
204      * @dev Return the log in base 2, rounded down, of a positive value.
205      * Returns 0 if given 0.
206      */
207     function log2(uint256 value) internal pure returns (uint256) {
208         uint256 result = 0;
209         unchecked {
210             if (value >> 128 > 0) {
211                 value >>= 128;
212                 result += 128;
213             }
214             if (value >> 64 > 0) {
215                 value >>= 64;
216                 result += 64;
217             }
218             if (value >> 32 > 0) {
219                 value >>= 32;
220                 result += 32;
221             }
222             if (value >> 16 > 0) {
223                 value >>= 16;
224                 result += 16;
225             }
226             if (value >> 8 > 0) {
227                 value >>= 8;
228                 result += 8;
229             }
230             if (value >> 4 > 0) {
231                 value >>= 4;
232                 result += 4;
233             }
234             if (value >> 2 > 0) {
235                 value >>= 2;
236                 result += 2;
237             }
238             if (value >> 1 > 0) {
239                 result += 1;
240             }
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
247      * Returns 0 if given 0.
248      */
249     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
250         unchecked {
251             uint256 result = log2(value);
252             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
253         }
254     }
255 
256     /**
257      * @dev Return the log in base 10, rounded down, of a positive value.
258      * Returns 0 if given 0.
259      */
260     function log10(uint256 value) internal pure returns (uint256) {
261         uint256 result = 0;
262         unchecked {
263             if (value >= 10**64) {
264                 value /= 10**64;
265                 result += 64;
266             }
267             if (value >= 10**32) {
268                 value /= 10**32;
269                 result += 32;
270             }
271             if (value >= 10**16) {
272                 value /= 10**16;
273                 result += 16;
274             }
275             if (value >= 10**8) {
276                 value /= 10**8;
277                 result += 8;
278             }
279             if (value >= 10**4) {
280                 value /= 10**4;
281                 result += 4;
282             }
283             if (value >= 10**2) {
284                 value /= 10**2;
285                 result += 2;
286             }
287             if (value >= 10**1) {
288                 result += 1;
289             }
290         }
291         return result;
292     }
293 
294     /**
295      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
296      * Returns 0 if given 0.
297      */
298     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
299         unchecked {
300             uint256 result = log10(value);
301             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
302         }
303     }
304 
305     /**
306      * @dev Return the log in base 256, rounded down, of a positive value.
307      * Returns 0 if given 0.
308      *
309      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
310      */
311     function log256(uint256 value) internal pure returns (uint256) {
312         uint256 result = 0;
313         unchecked {
314             if (value >> 128 > 0) {
315                 value >>= 128;
316                 result += 16;
317             }
318             if (value >> 64 > 0) {
319                 value >>= 64;
320                 result += 8;
321             }
322             if (value >> 32 > 0) {
323                 value >>= 32;
324                 result += 4;
325             }
326             if (value >> 16 > 0) {
327                 value >>= 16;
328                 result += 2;
329             }
330             if (value >> 8 > 0) {
331                 result += 1;
332             }
333         }
334         return result;
335     }
336 
337     /**
338      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
339      * Returns 0 if given 0.
340      */
341     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
342         unchecked {
343             uint256 result = log256(value);
344             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
345         }
346     }
347 }
348 
349 // File: @openzeppelin/contracts/utils/Strings.sol
350 
351 
352 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
353 
354 pragma solidity ^0.8.0;
355 
356 
357 /**
358  * @dev String operations.
359  */
360 library Strings {
361     bytes16 private constant _SYMBOLS = "0123456789abcdef";
362     uint8 private constant _ADDRESS_LENGTH = 20;
363 
364     /**
365      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
366      */
367     function toString(uint256 value) internal pure returns (string memory) {
368         unchecked {
369             uint256 length = Math.log10(value) + 1;
370             string memory buffer = new string(length);
371             uint256 ptr;
372             /// @solidity memory-safe-assembly
373             assembly {
374                 ptr := add(buffer, add(32, length))
375             }
376             while (true) {
377                 ptr--;
378                 /// @solidity memory-safe-assembly
379                 assembly {
380                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
381                 }
382                 value /= 10;
383                 if (value == 0) break;
384             }
385             return buffer;
386         }
387     }
388 
389     /**
390      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
391      */
392     function toHexString(uint256 value) internal pure returns (string memory) {
393         unchecked {
394             return toHexString(value, Math.log256(value) + 1);
395         }
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 
413     /**
414      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
415      */
416     function toHexString(address addr) internal pure returns (string memory) {
417         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
431  *
432  * These functions can be used to verify that a message was signed by the holder
433  * of the private keys of a given address.
434  */
435 library ECDSA {
436     enum RecoverError {
437         NoError,
438         InvalidSignature,
439         InvalidSignatureLength,
440         InvalidSignatureS,
441         InvalidSignatureV // Deprecated in v4.8
442     }
443 
444     function _throwError(RecoverError error) private pure {
445         if (error == RecoverError.NoError) {
446             return; // no error: do nothing
447         } else if (error == RecoverError.InvalidSignature) {
448             revert("ECDSA: invalid signature");
449         } else if (error == RecoverError.InvalidSignatureLength) {
450             revert("ECDSA: invalid signature length");
451         } else if (error == RecoverError.InvalidSignatureS) {
452             revert("ECDSA: invalid signature 's' value");
453         }
454     }
455 
456     /**
457      * @dev Returns the address that signed a hashed message (`hash`) with
458      * `signature` or error string. This address can then be used for verification purposes.
459      *
460      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
461      * this function rejects them by requiring the `s` value to be in the lower
462      * half order, and the `v` value to be either 27 or 28.
463      *
464      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
465      * verification to be secure: it is possible to craft signatures that
466      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
467      * this is by receiving a hash of the original message (which may otherwise
468      * be too long), and then calling {toEthSignedMessageHash} on it.
469      *
470      * Documentation for signature generation:
471      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
472      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
473      *
474      * _Available since v4.3._
475      */
476     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
477         if (signature.length == 65) {
478             bytes32 r;
479             bytes32 s;
480             uint8 v;
481             // ecrecover takes the signature parameters, and the only way to get them
482             // currently is to use assembly.
483             /// @solidity memory-safe-assembly
484             assembly {
485                 r := mload(add(signature, 0x20))
486                 s := mload(add(signature, 0x40))
487                 v := byte(0, mload(add(signature, 0x60)))
488             }
489             return tryRecover(hash, v, r, s);
490         } else {
491             return (address(0), RecoverError.InvalidSignatureLength);
492         }
493     }
494 
495     /**
496      * @dev Returns the address that signed a hashed message (`hash`) with
497      * `signature`. This address can then be used for verification purposes.
498      *
499      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
500      * this function rejects them by requiring the `s` value to be in the lower
501      * half order, and the `v` value to be either 27 or 28.
502      *
503      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
504      * verification to be secure: it is possible to craft signatures that
505      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
506      * this is by receiving a hash of the original message (which may otherwise
507      * be too long), and then calling {toEthSignedMessageHash} on it.
508      */
509     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
510         (address recovered, RecoverError error) = tryRecover(hash, signature);
511         _throwError(error);
512         return recovered;
513     }
514 
515     /**
516      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
517      *
518      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
519      *
520      * _Available since v4.3._
521      */
522     function tryRecover(
523         bytes32 hash,
524         bytes32 r,
525         bytes32 vs
526     ) internal pure returns (address, RecoverError) {
527         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
528         uint8 v = uint8((uint256(vs) >> 255) + 27);
529         return tryRecover(hash, v, r, s);
530     }
531 
532     /**
533      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
534      *
535      * _Available since v4.2._
536      */
537     function recover(
538         bytes32 hash,
539         bytes32 r,
540         bytes32 vs
541     ) internal pure returns (address) {
542         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
543         _throwError(error);
544         return recovered;
545     }
546 
547     /**
548      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
549      * `r` and `s` signature fields separately.
550      *
551      * _Available since v4.3._
552      */
553     function tryRecover(
554         bytes32 hash,
555         uint8 v,
556         bytes32 r,
557         bytes32 s
558     ) internal pure returns (address, RecoverError) {
559         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
560         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
561         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
562         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
563         //
564         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
565         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
566         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
567         // these malleable signatures as well.
568         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
569             return (address(0), RecoverError.InvalidSignatureS);
570         }
571 
572         // If the signature is valid (and not malleable), return the signer address
573         address signer = ecrecover(hash, v, r, s);
574         if (signer == address(0)) {
575             return (address(0), RecoverError.InvalidSignature);
576         }
577 
578         return (signer, RecoverError.NoError);
579     }
580 
581     /**
582      * @dev Overload of {ECDSA-recover} that receives the `v`,
583      * `r` and `s` signature fields separately.
584      */
585     function recover(
586         bytes32 hash,
587         uint8 v,
588         bytes32 r,
589         bytes32 s
590     ) internal pure returns (address) {
591         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
592         _throwError(error);
593         return recovered;
594     }
595 
596     /**
597      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
598      * produces hash corresponding to the one signed with the
599      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
600      * JSON-RPC method as part of EIP-191.
601      *
602      * See {recover}.
603      */
604     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
605         // 32 is the length in bytes of hash,
606         // enforced by the type signature above
607         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
608     }
609 
610     /**
611      * @dev Returns an Ethereum Signed Message, created from `s`. This
612      * produces hash corresponding to the one signed with the
613      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
614      * JSON-RPC method as part of EIP-191.
615      *
616      * See {recover}.
617      */
618     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
619         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
620     }
621 
622     /**
623      * @dev Returns an Ethereum Signed Typed Data, created from a
624      * `domainSeparator` and a `structHash`. This produces hash corresponding
625      * to the one signed with the
626      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
627      * JSON-RPC method as part of EIP-712.
628      *
629      * See {recover}.
630      */
631     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
632         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
633     }
634 }
635 
636 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Contract module that helps prevent reentrant calls to a function.
645  *
646  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
647  * available, which can be applied to functions to make sure there are no nested
648  * (reentrant) calls to them.
649  *
650  * Note that because there is a single `nonReentrant` guard, functions marked as
651  * `nonReentrant` may not call one another. This can be worked around by making
652  * those functions `private`, and then adding `external` `nonReentrant` entry
653  * points to them.
654  *
655  * TIP: If you would like to learn more about reentrancy and alternative ways
656  * to protect against it, check out our blog post
657  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
658  */
659 abstract contract ReentrancyGuard {
660     // Booleans are more expensive than uint256 or any type that takes up a full
661     // word because each write operation emits an extra SLOAD to first read the
662     // slot's contents, replace the bits taken up by the boolean, and then write
663     // back. This is the compiler's defense against contract upgrades and
664     // pointer aliasing, and it cannot be disabled.
665 
666     // The values being non-zero value makes deployment a bit more expensive,
667     // but in exchange the refund on every call to nonReentrant will be lower in
668     // amount. Since refunds are capped to a percentage of the total
669     // transaction's gas, it is best to keep them low in cases like this one, to
670     // increase the likelihood of the full refund coming into effect.
671     uint256 private constant _NOT_ENTERED = 1;
672     uint256 private constant _ENTERED = 2;
673 
674     uint256 private _status;
675 
676     constructor() {
677         _status = _NOT_ENTERED;
678     }
679 
680     /**
681      * @dev Prevents a contract from calling itself, directly or indirectly.
682      * Calling a `nonReentrant` function from another `nonReentrant`
683      * function is not supported. It is possible to prevent this from happening
684      * by making the `nonReentrant` function external, and making it call a
685      * `private` function that does the actual work.
686      */
687     modifier nonReentrant() {
688         _nonReentrantBefore();
689         _;
690         _nonReentrantAfter();
691     }
692 
693     function _nonReentrantBefore() private {
694         // On the first call to nonReentrant, _status will be _NOT_ENTERED
695         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
696 
697         // Any calls to nonReentrant after this point will fail
698         _status = _ENTERED;
699     }
700 
701     function _nonReentrantAfter() private {
702         // By storing the original value once again, a refund is triggered (see
703         // https://eips.ethereum.org/EIPS/eip-2200)
704         _status = _NOT_ENTERED;
705     }
706 }
707 
708 // File: @openzeppelin/contracts/utils/Context.sol
709 
710 
711 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
712 
713 pragma solidity ^0.8.0;
714 
715 /**
716  * @dev Provides information about the current execution context, including the
717  * sender of the transaction and its data. While these are generally available
718  * via msg.sender and msg.data, they should not be accessed in such a direct
719  * manner, since when dealing with meta-transactions the account sending and
720  * paying for execution may not be the actual sender (as far as an application
721  * is concerned).
722  *
723  * This contract is only required for intermediate, library-like contracts.
724  */
725 abstract contract Context {
726     function _msgSender() internal view virtual returns (address) {
727         return msg.sender;
728     }
729 
730     function _msgData() internal view virtual returns (bytes calldata) {
731         return msg.data;
732     }
733 }
734 
735 // File: @openzeppelin/contracts/access/Ownable.sol
736 
737 
738 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Contract module which provides a basic access control mechanism, where
745  * there is an account (an owner) that can be granted exclusive access to
746  * specific functions.
747  *
748  * By default, the owner account will be the one that deploys the contract. This
749  * can later be changed with {transferOwnership}.
750  *
751  * This module is used through inheritance. It will make available the modifier
752  * `onlyOwner`, which can be applied to your functions to restrict their use to
753  * the owner.
754  */
755 abstract contract Ownable is Context {
756     address private _owner;
757 
758     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
759 
760     /**
761      * @dev Initializes the contract setting the deployer as the initial owner.
762      */
763     constructor() {
764         _transferOwnership(_msgSender());
765     }
766 
767     /**
768      * @dev Throws if called by any account other than the owner.
769      */
770     modifier onlyOwner() {
771         _checkOwner();
772         _;
773     }
774 
775     /**
776      * @dev Returns the address of the current owner.
777      */
778     function owner() public view virtual returns (address) {
779         return _owner;
780     }
781 
782     /**
783      * @dev Throws if the sender is not the owner.
784      */
785     function _checkOwner() internal view virtual {
786         require(owner() == _msgSender(), "Ownable: caller is not the owner");
787     }
788 
789     /**
790      * @dev Leaves the contract without owner. It will not be possible to call
791      * `onlyOwner` functions anymore. Can only be called by the current owner.
792      *
793      * NOTE: Renouncing ownership will leave the contract without an owner,
794      * thereby removing any functionality that is only available to the owner.
795      */
796     function renounceOwnership() public virtual onlyOwner {
797         _transferOwnership(address(0));
798     }
799 
800     /**
801      * @dev Transfers ownership of the contract to a new account (`newOwner`).
802      * Can only be called by the current owner.
803      */
804     function transferOwnership(address newOwner) public virtual onlyOwner {
805         require(newOwner != address(0), "Ownable: new owner is the zero address");
806         _transferOwnership(newOwner);
807     }
808 
809     /**
810      * @dev Transfers ownership of the contract to a new account (`newOwner`).
811      * Internal function without access restriction.
812      */
813     function _transferOwnership(address newOwner) internal virtual {
814         address oldOwner = _owner;
815         _owner = newOwner;
816         emit OwnershipTransferred(oldOwner, newOwner);
817     }
818 }
819 
820 // File: contracts/doorAdd.sol
821 
822 
823 
824 pragma solidity >=0.8;
825 
826 interface IKeys {
827   function safeTransferFrom(
828     address from,
829     address to,
830     uint256 id,
831     uint256 amount,
832     bytes memory data
833   ) external;
834 }
835 
836 pragma solidity >=0.8;
837 
838 interface IERC20 {
839   function transfer(
840     address to,
841     uint256 tokens
842   ) external returns (bool success);
843 
844   function balanceOf(address account) external view returns (uint256);
845 }
846 
847 pragma solidity >=0.8;
848 
849 
850 
851 
852 contract DoorsAdditions is Ownable, ReentrancyGuard {
853   using ECDSA for bytes32;
854   IKeys keys;
855   IERC20 erc20Token;
856   address public keyReceiver;
857   address public signerAddress;
858   uint256 public amountOfDerToRewardPerKey;
859   mapping(address => uint256) public addressNonce;
860   event doorChosen(uint256 keyId, uint256 doorId);
861   event Received(address, uint256);
862 
863   constructor(
864     address _keysAddress,
865     address _signerAddress,
866     address _keyReceiver,
867     address _ERC20Token,
868     uint256 _amountOfDerToRewardPerKey
869   ) {
870     keys = IKeys(_keysAddress);
871     erc20Token = IERC20(_ERC20Token);
872     signerAddress = _signerAddress;
873     keyReceiver = _keyReceiver;
874     amountOfDerToRewardPerKey = _amountOfDerToRewardPerKey;
875   }
876 
877   function chooseDoor(uint256 keyId, uint256 doorId) public {
878     keys.safeTransferFrom(msg.sender, keyReceiver, keyId, 1, "");
879     emit doorChosen(keyId, doorId);
880   }
881 
882   function claimDerWithKey(uint256 keyId, uint256 doorId) public nonReentrant {
883    keys.safeTransferFrom(msg.sender, keyReceiver, keyId, 1, "");
884     validateContractBalance(amountOfDerToRewardPerKey); 
885     require(
886       erc20Token.transfer(
887         msg.sender,
888         amountOfDerToRewardPerKey
889       )
890     );
891     emit doorChosen(keyId, doorId);
892   }
893 
894   function claimDer(bytes calldata signature, uint256 amount) public nonReentrant {
895     addressNonce[msg.sender] += 1;
896     validateUsingECDASignature(signature, amount);
897     validateContractBalance(amount); 
898     require(
899       erc20Token.transfer(msg.sender, amount) , "transfer error"
900     );
901   }
902 
903   function airdrop(address[] calldata addresses, uint256[] calldata amounts) public onlyOwner nonReentrant
904   {
905     require(addresses.length == amounts.length, "array length mismatch");
906 
907     for (uint256 i = 0; i < addresses.length; i++) {
908      validateContractBalance(amounts[i]);
909       require(
910         erc20Token.transfer(addresses[i], amounts[i]), "transfer error"
911       );
912     }
913   }
914 
915   function setSignerAddress(address _signerAddress)
916     public
917     onlyOwner
918     nonReentrant
919   {
920     signerAddress = _signerAddress;
921   }
922 
923   function setKeyReceiver(address _newKeyReceiver)
924     public
925     onlyOwner
926     nonReentrant
927   {
928     keyReceiver = _newKeyReceiver;
929   }
930 
931   function setERC20Token(address _erc20Tokens) public onlyOwner nonReentrant {
932     erc20Token = IERC20(_erc20Tokens);
933   }
934 
935   function setDerReward(uint256 _amountOfDerToRewardPerKey)
936     public
937     onlyOwner
938     nonReentrant
939   {
940     amountOfDerToRewardPerKey = _amountOfDerToRewardPerKey;
941   }
942 
943   function validateContractBalance(uint256 amount) private view {
944     require(erc20Token.balanceOf(address(this)) >= amount, " not enough token supply in the smart contract");
945   }
946 
947   function validateUsingECDASignature(bytes calldata signature, uint256 amount) private view
948   {
949     bytes32 hash = keccak256(
950       abi.encodePacked(
951         bytes32(uint256(uint160(address(this)))),
952         bytes32(uint256(uint160(msg.sender))),
953         addressNonce[msg.sender],
954         amount
955       )
956     );
957     require(
958       signerAddress == hash.toEthSignedMessageHash().recover(signature),
959       "Signer address mismatch."
960     );
961   }
962 
963   function withdrawEth() external onlyOwner nonReentrant {
964     (bool success, ) = msg.sender.call{value: address(this).balance}("");
965     require(success, "Transfer failed.");
966   }
967 
968   receive() external payable {
969     emit Received(msg.sender, msg.value);
970   }
971 }