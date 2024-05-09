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
735 // File: @openzeppelin/contracts/security/Pausable.sol
736 
737 
738 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
739 
740 pragma solidity ^0.8.0;
741 
742 
743 /**
744  * @dev Contract module which allows children to implement an emergency stop
745  * mechanism that can be triggered by an authorized account.
746  *
747  * This module is used through inheritance. It will make available the
748  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
749  * the functions of your contract. Note that they will not be pausable by
750  * simply including this module, only once the modifiers are put in place.
751  */
752 abstract contract Pausable is Context {
753     /**
754      * @dev Emitted when the pause is triggered by `account`.
755      */
756     event Paused(address account);
757 
758     /**
759      * @dev Emitted when the pause is lifted by `account`.
760      */
761     event Unpaused(address account);
762 
763     bool private _paused;
764 
765     /**
766      * @dev Initializes the contract in unpaused state.
767      */
768     constructor() {
769         _paused = false;
770     }
771 
772     /**
773      * @dev Modifier to make a function callable only when the contract is not paused.
774      *
775      * Requirements:
776      *
777      * - The contract must not be paused.
778      */
779     modifier whenNotPaused() {
780         _requireNotPaused();
781         _;
782     }
783 
784     /**
785      * @dev Modifier to make a function callable only when the contract is paused.
786      *
787      * Requirements:
788      *
789      * - The contract must be paused.
790      */
791     modifier whenPaused() {
792         _requirePaused();
793         _;
794     }
795 
796     /**
797      * @dev Returns true if the contract is paused, and false otherwise.
798      */
799     function paused() public view virtual returns (bool) {
800         return _paused;
801     }
802 
803     /**
804      * @dev Throws if the contract is paused.
805      */
806     function _requireNotPaused() internal view virtual {
807         require(!paused(), "Pausable: paused");
808     }
809 
810     /**
811      * @dev Throws if the contract is not paused.
812      */
813     function _requirePaused() internal view virtual {
814         require(paused(), "Pausable: not paused");
815     }
816 
817     /**
818      * @dev Triggers stopped state.
819      *
820      * Requirements:
821      *
822      * - The contract must not be paused.
823      */
824     function _pause() internal virtual whenNotPaused {
825         _paused = true;
826         emit Paused(_msgSender());
827     }
828 
829     /**
830      * @dev Returns to normal state.
831      *
832      * Requirements:
833      *
834      * - The contract must be paused.
835      */
836     function _unpause() internal virtual whenPaused {
837         _paused = false;
838         emit Unpaused(_msgSender());
839     }
840 }
841 
842 // File: @openzeppelin/contracts/access/Ownable.sol
843 
844 
845 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
846 
847 pragma solidity ^0.8.0;
848 
849 
850 /**
851  * @dev Contract module which provides a basic access control mechanism, where
852  * there is an account (an owner) that can be granted exclusive access to
853  * specific functions.
854  *
855  * By default, the owner account will be the one that deploys the contract. This
856  * can later be changed with {transferOwnership}.
857  *
858  * This module is used through inheritance. It will make available the modifier
859  * `onlyOwner`, which can be applied to your functions to restrict their use to
860  * the owner.
861  */
862 abstract contract Ownable is Context {
863     address private _owner;
864 
865     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
866 
867     /**
868      * @dev Initializes the contract setting the deployer as the initial owner.
869      */
870     constructor() {
871         _transferOwnership(_msgSender());
872     }
873 
874     /**
875      * @dev Throws if called by any account other than the owner.
876      */
877     modifier onlyOwner() {
878         _checkOwner();
879         _;
880     }
881 
882     /**
883      * @dev Returns the address of the current owner.
884      */
885     function owner() public view virtual returns (address) {
886         return _owner;
887     }
888 
889     /**
890      * @dev Throws if the sender is not the owner.
891      */
892     function _checkOwner() internal view virtual {
893         require(owner() == _msgSender(), "Ownable: caller is not the owner");
894     }
895 
896     /**
897      * @dev Leaves the contract without owner. It will not be possible to call
898      * `onlyOwner` functions anymore. Can only be called by the current owner.
899      *
900      * NOTE: Renouncing ownership will leave the contract without an owner,
901      * thereby removing any functionality that is only available to the owner.
902      */
903     function renounceOwnership() public virtual onlyOwner {
904         _transferOwnership(address(0));
905     }
906 
907     /**
908      * @dev Transfers ownership of the contract to a new account (`newOwner`).
909      * Can only be called by the current owner.
910      */
911     function transferOwnership(address newOwner) public virtual onlyOwner {
912         require(newOwner != address(0), "Ownable: new owner is the zero address");
913         _transferOwnership(newOwner);
914     }
915 
916     /**
917      * @dev Transfers ownership of the contract to a new account (`newOwner`).
918      * Internal function without access restriction.
919      */
920     function _transferOwnership(address newOwner) internal virtual {
921         address oldOwner = _owner;
922         _owner = newOwner;
923         emit OwnershipTransferred(oldOwner, newOwner);
924     }
925 }
926 
927 // File: contracts/lib/signed.sol
928 
929 
930 
931 pragma solidity ^0.8.0;
932 
933 
934 
935 
936 contract Signed is Ownable {
937     using Strings for uint256;
938     using ECDSA for bytes32;
939 
940     string private _secret;
941     address private _signer;
942 
943     function setSecret(string calldata secret) external onlyOwner {
944         _secret = secret;
945     }
946 
947     function setSigner(address signer) external onlyOwner {
948         _signer = signer;
949     }
950 
951     function createHash(uint256 nftId, uint256 serumId)
952         internal
953         view
954         returns (bytes32)
955     {
956         return
957             keccak256(
958                 abi.encode(address(this), msg.sender, nftId, serumId, _secret)
959             );
960     }
961 
962     function getSigner(bytes32 hash, bytes memory signature)
963         internal
964         pure
965         returns (address)
966     {
967         return hash.toEthSignedMessageHash().recover(signature);
968     }
969 
970     function isAuthorizedSigner(address extracted)
971         internal
972         view
973         virtual
974         returns (bool)
975     {
976         return extracted == _signer;
977     }
978 
979     function verifySignature(
980         bytes calldata signature,
981         uint256 nftId,
982         uint256 serumId
983     ) internal view {
984         address extracted = getSigner(createHash(nftId, serumId), signature);
985         require(isAuthorizedSigner(extracted), "Signature verification failed");
986     }
987 }
988 
989 // File: @openzeppelin/contracts/utils/Address.sol
990 
991 
992 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
993 
994 pragma solidity ^0.8.1;
995 
996 /**
997  * @dev Collection of functions related to the address type
998  */
999 library Address {
1000     /**
1001      * @dev Returns true if `account` is a contract.
1002      *
1003      * [IMPORTANT]
1004      * ====
1005      * It is unsafe to assume that an address for which this function returns
1006      * false is an externally-owned account (EOA) and not a contract.
1007      *
1008      * Among others, `isContract` will return false for the following
1009      * types of addresses:
1010      *
1011      *  - an externally-owned account
1012      *  - a contract in construction
1013      *  - an address where a contract will be created
1014      *  - an address where a contract lived, but was destroyed
1015      * ====
1016      *
1017      * [IMPORTANT]
1018      * ====
1019      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1020      *
1021      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1022      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1023      * constructor.
1024      * ====
1025      */
1026     function isContract(address account) internal view returns (bool) {
1027         // This method relies on extcodesize/address.code.length, which returns 0
1028         // for contracts in construction, since the code is only stored at the end
1029         // of the constructor execution.
1030 
1031         return account.code.length > 0;
1032     }
1033 
1034     /**
1035      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1036      * `recipient`, forwarding all available gas and reverting on errors.
1037      *
1038      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1039      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1040      * imposed by `transfer`, making them unable to receive funds via
1041      * `transfer`. {sendValue} removes this limitation.
1042      *
1043      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1044      *
1045      * IMPORTANT: because control is transferred to `recipient`, care must be
1046      * taken to not create reentrancy vulnerabilities. Consider using
1047      * {ReentrancyGuard} or the
1048      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1049      */
1050     function sendValue(address payable recipient, uint256 amount) internal {
1051         require(address(this).balance >= amount, "Address: insufficient balance");
1052 
1053         (bool success, ) = recipient.call{value: amount}("");
1054         require(success, "Address: unable to send value, recipient may have reverted");
1055     }
1056 
1057     /**
1058      * @dev Performs a Solidity function call using a low level `call`. A
1059      * plain `call` is an unsafe replacement for a function call: use this
1060      * function instead.
1061      *
1062      * If `target` reverts with a revert reason, it is bubbled up by this
1063      * function (like regular Solidity function calls).
1064      *
1065      * Returns the raw returned data. To convert to the expected return value,
1066      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1067      *
1068      * Requirements:
1069      *
1070      * - `target` must be a contract.
1071      * - calling `target` with `data` must not revert.
1072      *
1073      * _Available since v3.1._
1074      */
1075     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1076         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1077     }
1078 
1079     /**
1080      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1081      * `errorMessage` as a fallback revert reason when `target` reverts.
1082      *
1083      * _Available since v3.1._
1084      */
1085     function functionCall(
1086         address target,
1087         bytes memory data,
1088         string memory errorMessage
1089     ) internal returns (bytes memory) {
1090         return functionCallWithValue(target, data, 0, errorMessage);
1091     }
1092 
1093     /**
1094      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1095      * but also transferring `value` wei to `target`.
1096      *
1097      * Requirements:
1098      *
1099      * - the calling contract must have an ETH balance of at least `value`.
1100      * - the called Solidity function must be `payable`.
1101      *
1102      * _Available since v3.1._
1103      */
1104     function functionCallWithValue(
1105         address target,
1106         bytes memory data,
1107         uint256 value
1108     ) internal returns (bytes memory) {
1109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1110     }
1111 
1112     /**
1113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1114      * with `errorMessage` as a fallback revert reason when `target` reverts.
1115      *
1116      * _Available since v3.1._
1117      */
1118     function functionCallWithValue(
1119         address target,
1120         bytes memory data,
1121         uint256 value,
1122         string memory errorMessage
1123     ) internal returns (bytes memory) {
1124         require(address(this).balance >= value, "Address: insufficient balance for call");
1125         (bool success, bytes memory returndata) = target.call{value: value}(data);
1126         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1127     }
1128 
1129     /**
1130      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1131      * but performing a static call.
1132      *
1133      * _Available since v3.3._
1134      */
1135     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1136         return functionStaticCall(target, data, "Address: low-level static call failed");
1137     }
1138 
1139     /**
1140      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1141      * but performing a static call.
1142      *
1143      * _Available since v3.3._
1144      */
1145     function functionStaticCall(
1146         address target,
1147         bytes memory data,
1148         string memory errorMessage
1149     ) internal view returns (bytes memory) {
1150         (bool success, bytes memory returndata) = target.staticcall(data);
1151         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1152     }
1153 
1154     /**
1155      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1156      * but performing a delegate call.
1157      *
1158      * _Available since v3.4._
1159      */
1160     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1161         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1162     }
1163 
1164     /**
1165      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1166      * but performing a delegate call.
1167      *
1168      * _Available since v3.4._
1169      */
1170     function functionDelegateCall(
1171         address target,
1172         bytes memory data,
1173         string memory errorMessage
1174     ) internal returns (bytes memory) {
1175         (bool success, bytes memory returndata) = target.delegatecall(data);
1176         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1177     }
1178 
1179     /**
1180      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1181      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1182      *
1183      * _Available since v4.8._
1184      */
1185     function verifyCallResultFromTarget(
1186         address target,
1187         bool success,
1188         bytes memory returndata,
1189         string memory errorMessage
1190     ) internal view returns (bytes memory) {
1191         if (success) {
1192             if (returndata.length == 0) {
1193                 // only check isContract if the call was successful and the return data is empty
1194                 // otherwise we already know that it was a contract
1195                 require(isContract(target), "Address: call to non-contract");
1196             }
1197             return returndata;
1198         } else {
1199             _revert(returndata, errorMessage);
1200         }
1201     }
1202 
1203     /**
1204      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1205      * revert reason or using the provided one.
1206      *
1207      * _Available since v4.3._
1208      */
1209     function verifyCallResult(
1210         bool success,
1211         bytes memory returndata,
1212         string memory errorMessage
1213     ) internal pure returns (bytes memory) {
1214         if (success) {
1215             return returndata;
1216         } else {
1217             _revert(returndata, errorMessage);
1218         }
1219     }
1220 
1221     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1222         // Look for revert reason and bubble it up if present
1223         if (returndata.length > 0) {
1224             // The easiest way to bubble the revert reason is using memory via assembly
1225             /// @solidity memory-safe-assembly
1226             assembly {
1227                 let returndata_size := mload(returndata)
1228                 revert(add(32, returndata), returndata_size)
1229             }
1230         } else {
1231             revert(errorMessage);
1232         }
1233     }
1234 }
1235 
1236 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1237 
1238 
1239 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1240 
1241 pragma solidity ^0.8.0;
1242 
1243 /**
1244  * @dev Interface of the ERC165 standard, as defined in the
1245  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1246  *
1247  * Implementers can declare support of contract interfaces, which can then be
1248  * queried by others ({ERC165Checker}).
1249  *
1250  * For an implementation, see {ERC165}.
1251  */
1252 interface IERC165 {
1253     /**
1254      * @dev Returns true if this contract implements the interface defined by
1255      * `interfaceId`. See the corresponding
1256      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1257      * to learn more about how these ids are created.
1258      *
1259      * This function call must use less than 30 000 gas.
1260      */
1261     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1262 }
1263 
1264 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1265 
1266 
1267 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1268 
1269 pragma solidity ^0.8.0;
1270 
1271 
1272 /**
1273  * @dev Required interface of an ERC721 compliant contract.
1274  */
1275 interface IERC721 is IERC165 {
1276     /**
1277      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1278      */
1279     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1280 
1281     /**
1282      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1283      */
1284     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1285 
1286     /**
1287      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1288      */
1289     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1290 
1291     /**
1292      * @dev Returns the number of tokens in ``owner``'s account.
1293      */
1294     function balanceOf(address owner) external view returns (uint256 balance);
1295 
1296     /**
1297      * @dev Returns the owner of the `tokenId` token.
1298      *
1299      * Requirements:
1300      *
1301      * - `tokenId` must exist.
1302      */
1303     function ownerOf(uint256 tokenId) external view returns (address owner);
1304 
1305     /**
1306      * @dev Safely transfers `tokenId` token from `from` to `to`.
1307      *
1308      * Requirements:
1309      *
1310      * - `from` cannot be the zero address.
1311      * - `to` cannot be the zero address.
1312      * - `tokenId` token must exist and be owned by `from`.
1313      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1314      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1315      *
1316      * Emits a {Transfer} event.
1317      */
1318     function safeTransferFrom(
1319         address from,
1320         address to,
1321         uint256 tokenId,
1322         bytes calldata data
1323     ) external;
1324 
1325     /**
1326      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1327      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1328      *
1329      * Requirements:
1330      *
1331      * - `from` cannot be the zero address.
1332      * - `to` cannot be the zero address.
1333      * - `tokenId` token must exist and be owned by `from`.
1334      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1335      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1336      *
1337      * Emits a {Transfer} event.
1338      */
1339     function safeTransferFrom(
1340         address from,
1341         address to,
1342         uint256 tokenId
1343     ) external;
1344 
1345     /**
1346      * @dev Transfers `tokenId` token from `from` to `to`.
1347      *
1348      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1349      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1350      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1351      *
1352      * Requirements:
1353      *
1354      * - `from` cannot be the zero address.
1355      * - `to` cannot be the zero address.
1356      * - `tokenId` token must be owned by `from`.
1357      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1358      *
1359      * Emits a {Transfer} event.
1360      */
1361     function transferFrom(
1362         address from,
1363         address to,
1364         uint256 tokenId
1365     ) external;
1366 
1367     /**
1368      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1369      * The approval is cleared when the token is transferred.
1370      *
1371      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1372      *
1373      * Requirements:
1374      *
1375      * - The caller must own the token or be an approved operator.
1376      * - `tokenId` must exist.
1377      *
1378      * Emits an {Approval} event.
1379      */
1380     function approve(address to, uint256 tokenId) external;
1381 
1382     /**
1383      * @dev Approve or remove `operator` as an operator for the caller.
1384      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1385      *
1386      * Requirements:
1387      *
1388      * - The `operator` cannot be the caller.
1389      *
1390      * Emits an {ApprovalForAll} event.
1391      */
1392     function setApprovalForAll(address operator, bool _approved) external;
1393 
1394     /**
1395      * @dev Returns the account approved for `tokenId` token.
1396      *
1397      * Requirements:
1398      *
1399      * - `tokenId` must exist.
1400      */
1401     function getApproved(uint256 tokenId) external view returns (address operator);
1402 
1403     /**
1404      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1405      *
1406      * See {setApprovalForAll}
1407      */
1408     function isApprovedForAll(address owner, address operator) external view returns (bool);
1409 }
1410 
1411 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1412 
1413 
1414 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1415 
1416 pragma solidity ^0.8.0;
1417 
1418 
1419 /**
1420  * @dev Implementation of the {IERC165} interface.
1421  *
1422  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1423  * for the additional interface id that will be supported. For example:
1424  *
1425  * ```solidity
1426  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1427  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1428  * }
1429  * ```
1430  *
1431  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1432  */
1433 abstract contract ERC165 is IERC165 {
1434     /**
1435      * @dev See {IERC165-supportsInterface}.
1436      */
1437     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1438         return interfaceId == type(IERC165).interfaceId;
1439     }
1440 }
1441 
1442 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1443 
1444 
1445 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1446 
1447 pragma solidity ^0.8.0;
1448 
1449 
1450 /**
1451  * @dev _Available since v3.1._
1452  */
1453 interface IERC1155Receiver is IERC165 {
1454     /**
1455      * @dev Handles the receipt of a single ERC1155 token type. This function is
1456      * called at the end of a `safeTransferFrom` after the balance has been updated.
1457      *
1458      * NOTE: To accept the transfer, this must return
1459      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1460      * (i.e. 0xf23a6e61, or its own function selector).
1461      *
1462      * @param operator The address which initiated the transfer (i.e. msg.sender)
1463      * @param from The address which previously owned the token
1464      * @param id The ID of the token being transferred
1465      * @param value The amount of tokens being transferred
1466      * @param data Additional data with no specified format
1467      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1468      */
1469     function onERC1155Received(
1470         address operator,
1471         address from,
1472         uint256 id,
1473         uint256 value,
1474         bytes calldata data
1475     ) external returns (bytes4);
1476 
1477     /**
1478      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1479      * is called at the end of a `safeBatchTransferFrom` after the balances have
1480      * been updated.
1481      *
1482      * NOTE: To accept the transfer(s), this must return
1483      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1484      * (i.e. 0xbc197c81, or its own function selector).
1485      *
1486      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1487      * @param from The address which previously owned the token
1488      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1489      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1490      * @param data Additional data with no specified format
1491      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1492      */
1493     function onERC1155BatchReceived(
1494         address operator,
1495         address from,
1496         uint256[] calldata ids,
1497         uint256[] calldata values,
1498         bytes calldata data
1499     ) external returns (bytes4);
1500 }
1501 
1502 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1503 
1504 
1505 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1506 
1507 pragma solidity ^0.8.0;
1508 
1509 
1510 /**
1511  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1512  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1513  *
1514  * _Available since v3.1._
1515  */
1516 interface IERC1155 is IERC165 {
1517     /**
1518      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1519      */
1520     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1521 
1522     /**
1523      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1524      * transfers.
1525      */
1526     event TransferBatch(
1527         address indexed operator,
1528         address indexed from,
1529         address indexed to,
1530         uint256[] ids,
1531         uint256[] values
1532     );
1533 
1534     /**
1535      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1536      * `approved`.
1537      */
1538     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1539 
1540     /**
1541      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1542      *
1543      * If an {URI} event was emitted for `id`, the standard
1544      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1545      * returned by {IERC1155MetadataURI-uri}.
1546      */
1547     event URI(string value, uint256 indexed id);
1548 
1549     /**
1550      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1551      *
1552      * Requirements:
1553      *
1554      * - `account` cannot be the zero address.
1555      */
1556     function balanceOf(address account, uint256 id) external view returns (uint256);
1557 
1558     /**
1559      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1560      *
1561      * Requirements:
1562      *
1563      * - `accounts` and `ids` must have the same length.
1564      */
1565     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1566         external
1567         view
1568         returns (uint256[] memory);
1569 
1570     /**
1571      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1572      *
1573      * Emits an {ApprovalForAll} event.
1574      *
1575      * Requirements:
1576      *
1577      * - `operator` cannot be the caller.
1578      */
1579     function setApprovalForAll(address operator, bool approved) external;
1580 
1581     /**
1582      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1583      *
1584      * See {setApprovalForAll}.
1585      */
1586     function isApprovedForAll(address account, address operator) external view returns (bool);
1587 
1588     /**
1589      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1590      *
1591      * Emits a {TransferSingle} event.
1592      *
1593      * Requirements:
1594      *
1595      * - `to` cannot be the zero address.
1596      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1597      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1598      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1599      * acceptance magic value.
1600      */
1601     function safeTransferFrom(
1602         address from,
1603         address to,
1604         uint256 id,
1605         uint256 amount,
1606         bytes calldata data
1607     ) external;
1608 
1609     /**
1610      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1611      *
1612      * Emits a {TransferBatch} event.
1613      *
1614      * Requirements:
1615      *
1616      * - `ids` and `amounts` must have the same length.
1617      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1618      * acceptance magic value.
1619      */
1620     function safeBatchTransferFrom(
1621         address from,
1622         address to,
1623         uint256[] calldata ids,
1624         uint256[] calldata amounts,
1625         bytes calldata data
1626     ) external;
1627 }
1628 
1629 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1630 
1631 
1632 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1633 
1634 pragma solidity ^0.8.0;
1635 
1636 
1637 /**
1638  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1639  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1640  *
1641  * _Available since v3.1._
1642  */
1643 interface IERC1155MetadataURI is IERC1155 {
1644     /**
1645      * @dev Returns the URI for token type `id`.
1646      *
1647      * If the `\{id\}` substring is present in the URI, it must be replaced by
1648      * clients with the actual token type ID.
1649      */
1650     function uri(uint256 id) external view returns (string memory);
1651 }
1652 
1653 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1654 
1655 
1656 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
1657 
1658 pragma solidity ^0.8.0;
1659 
1660 
1661 
1662 
1663 
1664 
1665 
1666 /**
1667  * @dev Implementation of the basic standard multi-token.
1668  * See https://eips.ethereum.org/EIPS/eip-1155
1669  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1670  *
1671  * _Available since v3.1._
1672  */
1673 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1674     using Address for address;
1675 
1676     // Mapping from token ID to account balances
1677     mapping(uint256 => mapping(address => uint256)) private _balances;
1678 
1679     // Mapping from account to operator approvals
1680     mapping(address => mapping(address => bool)) private _operatorApprovals;
1681 
1682     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1683     string private _uri;
1684 
1685     /**
1686      * @dev See {_setURI}.
1687      */
1688     constructor(string memory uri_) {
1689         _setURI(uri_);
1690     }
1691 
1692     /**
1693      * @dev See {IERC165-supportsInterface}.
1694      */
1695     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1696         return
1697             interfaceId == type(IERC1155).interfaceId ||
1698             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1699             super.supportsInterface(interfaceId);
1700     }
1701 
1702     /**
1703      * @dev See {IERC1155MetadataURI-uri}.
1704      *
1705      * This implementation returns the same URI for *all* token types. It relies
1706      * on the token type ID substitution mechanism
1707      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1708      *
1709      * Clients calling this function must replace the `\{id\}` substring with the
1710      * actual token type ID.
1711      */
1712     function uri(uint256) public view virtual override returns (string memory) {
1713         return _uri;
1714     }
1715 
1716     /**
1717      * @dev See {IERC1155-balanceOf}.
1718      *
1719      * Requirements:
1720      *
1721      * - `account` cannot be the zero address.
1722      */
1723     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1724         require(account != address(0), "ERC1155: address zero is not a valid owner");
1725         return _balances[id][account];
1726     }
1727 
1728     /**
1729      * @dev See {IERC1155-balanceOfBatch}.
1730      *
1731      * Requirements:
1732      *
1733      * - `accounts` and `ids` must have the same length.
1734      */
1735     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1736         public
1737         view
1738         virtual
1739         override
1740         returns (uint256[] memory)
1741     {
1742         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1743 
1744         uint256[] memory batchBalances = new uint256[](accounts.length);
1745 
1746         for (uint256 i = 0; i < accounts.length; ++i) {
1747             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1748         }
1749 
1750         return batchBalances;
1751     }
1752 
1753     /**
1754      * @dev See {IERC1155-setApprovalForAll}.
1755      */
1756     function setApprovalForAll(address operator, bool approved) public virtual override {
1757         _setApprovalForAll(_msgSender(), operator, approved);
1758     }
1759 
1760     /**
1761      * @dev See {IERC1155-isApprovedForAll}.
1762      */
1763     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1764         return _operatorApprovals[account][operator];
1765     }
1766 
1767     /**
1768      * @dev See {IERC1155-safeTransferFrom}.
1769      */
1770     function safeTransferFrom(
1771         address from,
1772         address to,
1773         uint256 id,
1774         uint256 amount,
1775         bytes memory data
1776     ) public virtual override {
1777         require(
1778             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1779             "ERC1155: caller is not token owner or approved"
1780         );
1781         _safeTransferFrom(from, to, id, amount, data);
1782     }
1783 
1784     /**
1785      * @dev See {IERC1155-safeBatchTransferFrom}.
1786      */
1787     function safeBatchTransferFrom(
1788         address from,
1789         address to,
1790         uint256[] memory ids,
1791         uint256[] memory amounts,
1792         bytes memory data
1793     ) public virtual override {
1794         require(
1795             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1796             "ERC1155: caller is not token owner or approved"
1797         );
1798         _safeBatchTransferFrom(from, to, ids, amounts, data);
1799     }
1800 
1801     /**
1802      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1803      *
1804      * Emits a {TransferSingle} event.
1805      *
1806      * Requirements:
1807      *
1808      * - `to` cannot be the zero address.
1809      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1810      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1811      * acceptance magic value.
1812      */
1813     function _safeTransferFrom(
1814         address from,
1815         address to,
1816         uint256 id,
1817         uint256 amount,
1818         bytes memory data
1819     ) internal virtual {
1820         require(to != address(0), "ERC1155: transfer to the zero address");
1821 
1822         address operator = _msgSender();
1823         uint256[] memory ids = _asSingletonArray(id);
1824         uint256[] memory amounts = _asSingletonArray(amount);
1825 
1826         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1827 
1828         uint256 fromBalance = _balances[id][from];
1829         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1830         unchecked {
1831             _balances[id][from] = fromBalance - amount;
1832         }
1833         _balances[id][to] += amount;
1834 
1835         emit TransferSingle(operator, from, to, id, amount);
1836 
1837         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1838 
1839         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1840     }
1841 
1842     /**
1843      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1844      *
1845      * Emits a {TransferBatch} event.
1846      *
1847      * Requirements:
1848      *
1849      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1850      * acceptance magic value.
1851      */
1852     function _safeBatchTransferFrom(
1853         address from,
1854         address to,
1855         uint256[] memory ids,
1856         uint256[] memory amounts,
1857         bytes memory data
1858     ) internal virtual {
1859         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1860         require(to != address(0), "ERC1155: transfer to the zero address");
1861 
1862         address operator = _msgSender();
1863 
1864         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1865 
1866         for (uint256 i = 0; i < ids.length; ++i) {
1867             uint256 id = ids[i];
1868             uint256 amount = amounts[i];
1869 
1870             uint256 fromBalance = _balances[id][from];
1871             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1872             unchecked {
1873                 _balances[id][from] = fromBalance - amount;
1874             }
1875             _balances[id][to] += amount;
1876         }
1877 
1878         emit TransferBatch(operator, from, to, ids, amounts);
1879 
1880         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1881 
1882         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1883     }
1884 
1885     /**
1886      * @dev Sets a new URI for all token types, by relying on the token type ID
1887      * substitution mechanism
1888      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1889      *
1890      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1891      * URI or any of the amounts in the JSON file at said URI will be replaced by
1892      * clients with the token type ID.
1893      *
1894      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1895      * interpreted by clients as
1896      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1897      * for token type ID 0x4cce0.
1898      *
1899      * See {uri}.
1900      *
1901      * Because these URIs cannot be meaningfully represented by the {URI} event,
1902      * this function emits no events.
1903      */
1904     function _setURI(string memory newuri) internal virtual {
1905         _uri = newuri;
1906     }
1907 
1908     /**
1909      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1910      *
1911      * Emits a {TransferSingle} event.
1912      *
1913      * Requirements:
1914      *
1915      * - `to` cannot be the zero address.
1916      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1917      * acceptance magic value.
1918      */
1919     function _mint(
1920         address to,
1921         uint256 id,
1922         uint256 amount,
1923         bytes memory data
1924     ) internal virtual {
1925         require(to != address(0), "ERC1155: mint to the zero address");
1926 
1927         address operator = _msgSender();
1928         uint256[] memory ids = _asSingletonArray(id);
1929         uint256[] memory amounts = _asSingletonArray(amount);
1930 
1931         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1932 
1933         _balances[id][to] += amount;
1934         emit TransferSingle(operator, address(0), to, id, amount);
1935 
1936         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1937 
1938         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1939     }
1940 
1941     /**
1942      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1943      *
1944      * Emits a {TransferBatch} event.
1945      *
1946      * Requirements:
1947      *
1948      * - `ids` and `amounts` must have the same length.
1949      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1950      * acceptance magic value.
1951      */
1952     function _mintBatch(
1953         address to,
1954         uint256[] memory ids,
1955         uint256[] memory amounts,
1956         bytes memory data
1957     ) internal virtual {
1958         require(to != address(0), "ERC1155: mint to the zero address");
1959         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1960 
1961         address operator = _msgSender();
1962 
1963         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1964 
1965         for (uint256 i = 0; i < ids.length; i++) {
1966             _balances[ids[i]][to] += amounts[i];
1967         }
1968 
1969         emit TransferBatch(operator, address(0), to, ids, amounts);
1970 
1971         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1972 
1973         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1974     }
1975 
1976     /**
1977      * @dev Destroys `amount` tokens of token type `id` from `from`
1978      *
1979      * Emits a {TransferSingle} event.
1980      *
1981      * Requirements:
1982      *
1983      * - `from` cannot be the zero address.
1984      * - `from` must have at least `amount` tokens of token type `id`.
1985      */
1986     function _burn(
1987         address from,
1988         uint256 id,
1989         uint256 amount
1990     ) internal virtual {
1991         require(from != address(0), "ERC1155: burn from the zero address");
1992 
1993         address operator = _msgSender();
1994         uint256[] memory ids = _asSingletonArray(id);
1995         uint256[] memory amounts = _asSingletonArray(amount);
1996 
1997         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1998 
1999         uint256 fromBalance = _balances[id][from];
2000         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2001         unchecked {
2002             _balances[id][from] = fromBalance - amount;
2003         }
2004 
2005         emit TransferSingle(operator, from, address(0), id, amount);
2006 
2007         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2008     }
2009 
2010     /**
2011      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
2012      *
2013      * Emits a {TransferBatch} event.
2014      *
2015      * Requirements:
2016      *
2017      * - `ids` and `amounts` must have the same length.
2018      */
2019     function _burnBatch(
2020         address from,
2021         uint256[] memory ids,
2022         uint256[] memory amounts
2023     ) internal virtual {
2024         require(from != address(0), "ERC1155: burn from the zero address");
2025         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2026 
2027         address operator = _msgSender();
2028 
2029         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2030 
2031         for (uint256 i = 0; i < ids.length; i++) {
2032             uint256 id = ids[i];
2033             uint256 amount = amounts[i];
2034 
2035             uint256 fromBalance = _balances[id][from];
2036             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2037             unchecked {
2038                 _balances[id][from] = fromBalance - amount;
2039             }
2040         }
2041 
2042         emit TransferBatch(operator, from, address(0), ids, amounts);
2043 
2044         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2045     }
2046 
2047     /**
2048      * @dev Approve `operator` to operate on all of `owner` tokens
2049      *
2050      * Emits an {ApprovalForAll} event.
2051      */
2052     function _setApprovalForAll(
2053         address owner,
2054         address operator,
2055         bool approved
2056     ) internal virtual {
2057         require(owner != operator, "ERC1155: setting approval status for self");
2058         _operatorApprovals[owner][operator] = approved;
2059         emit ApprovalForAll(owner, operator, approved);
2060     }
2061 
2062     /**
2063      * @dev Hook that is called before any token transfer. This includes minting
2064      * and burning, as well as batched variants.
2065      *
2066      * The same hook is called on both single and batched variants. For single
2067      * transfers, the length of the `ids` and `amounts` arrays will be 1.
2068      *
2069      * Calling conditions (for each `id` and `amount` pair):
2070      *
2071      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2072      * of token type `id` will be  transferred to `to`.
2073      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2074      * for `to`.
2075      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2076      * will be burned.
2077      * - `from` and `to` are never both zero.
2078      * - `ids` and `amounts` have the same, non-zero length.
2079      *
2080      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2081      */
2082     function _beforeTokenTransfer(
2083         address operator,
2084         address from,
2085         address to,
2086         uint256[] memory ids,
2087         uint256[] memory amounts,
2088         bytes memory data
2089     ) internal virtual {}
2090 
2091     /**
2092      * @dev Hook that is called after any token transfer. This includes minting
2093      * and burning, as well as batched variants.
2094      *
2095      * The same hook is called on both single and batched variants. For single
2096      * transfers, the length of the `id` and `amount` arrays will be 1.
2097      *
2098      * Calling conditions (for each `id` and `amount` pair):
2099      *
2100      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2101      * of token type `id` will be  transferred to `to`.
2102      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2103      * for `to`.
2104      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2105      * will be burned.
2106      * - `from` and `to` are never both zero.
2107      * - `ids` and `amounts` have the same, non-zero length.
2108      *
2109      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2110      */
2111     function _afterTokenTransfer(
2112         address operator,
2113         address from,
2114         address to,
2115         uint256[] memory ids,
2116         uint256[] memory amounts,
2117         bytes memory data
2118     ) internal virtual {}
2119 
2120     function _doSafeTransferAcceptanceCheck(
2121         address operator,
2122         address from,
2123         address to,
2124         uint256 id,
2125         uint256 amount,
2126         bytes memory data
2127     ) private {
2128         if (to.isContract()) {
2129             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2130                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2131                     revert("ERC1155: ERC1155Receiver rejected tokens");
2132                 }
2133             } catch Error(string memory reason) {
2134                 revert(reason);
2135             } catch {
2136                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2137             }
2138         }
2139     }
2140 
2141     function _doSafeBatchTransferAcceptanceCheck(
2142         address operator,
2143         address from,
2144         address to,
2145         uint256[] memory ids,
2146         uint256[] memory amounts,
2147         bytes memory data
2148     ) private {
2149         if (to.isContract()) {
2150             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2151                 bytes4 response
2152             ) {
2153                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2154                     revert("ERC1155: ERC1155Receiver rejected tokens");
2155                 }
2156             } catch Error(string memory reason) {
2157                 revert(reason);
2158             } catch {
2159                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2160             }
2161         }
2162     }
2163 
2164     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2165         uint256[] memory array = new uint256[](1);
2166         array[0] = element;
2167 
2168         return array;
2169     }
2170 }
2171 
2172 // File: contracts/SkullSerum.sol
2173 
2174 
2175 pragma solidity ^0.8.4;
2176 
2177 
2178 
2179 
2180 
2181 
2182 
2183 
2184 contract SkulSerum is ERC1155, Ownable, Signed, Pausable, ReentrancyGuard {
2185     using Strings for uint256;
2186 
2187     IERC721 public skulNFT;
2188     string public baseURI;
2189 
2190     constructor(address _skulNFT) ERC1155("") {
2191         setSkulNFT(_skulNFT);
2192     }
2193 
2194     function pause() public onlyOwner {
2195         _pause();
2196     }
2197 
2198     function unpause() public onlyOwner {
2199         _unpause();
2200     }
2201 
2202     mapping(uint256 => bool) alreadyClaim;
2203     mapping(uint256 => bool) alreadyEvade;
2204     mapping(uint256 => address) stakerAddress;
2205 
2206     function setURI(string memory newuri) public onlyOwner {
2207         baseURI = newuri;
2208     }
2209 
2210     function setSkulNFT(address _skulNFT) public onlyOwner {
2211         skulNFT = IERC721(_skulNFT);
2212     }
2213 
2214     function stakeSkul(uint256[] calldata nftIds)
2215         public
2216         whenNotPaused
2217         nonReentrant
2218     {
2219         for (uint256 i; i < nftIds.length; i++) {
2220             require(
2221                 skulNFT.ownerOf(nftIds[i]) == msg.sender,
2222                 "Can't stake tokens you don't own!"
2223             );
2224             require(
2225                 alreadyEvade[nftIds[i]] == false,
2226                 "Skul NFT already evaded"
2227             );
2228             skulNFT.transferFrom(msg.sender, address(this), nftIds[i]);
2229             stakerAddress[nftIds[i]] = msg.sender;
2230             alreadyEvade[nftIds[i]] = true;
2231         }
2232     }
2233 
2234     function claim(
2235         uint256[] calldata nftIds,
2236         bytes[] calldata signatures,
2237         uint256[] calldata serumIds
2238     ) public nonReentrant whenNotPaused {
2239         require(
2240             nftIds.length <= 5 &&
2241                 signatures.length <= 5 &&
2242                 serumIds.length <= 5,
2243             "Can't claim more than 5"
2244         );
2245         require(
2246             nftIds.length == signatures.length &&
2247                 nftIds.length == serumIds.length,
2248             "Input array length must be same"
2249         );
2250         for (uint256 i; i < nftIds.length; i++) {
2251             require(
2252                 alreadyClaim[nftIds[i]] == false,
2253                 "Skul NFT Already used for claim"
2254             );
2255             require(
2256                 stakerAddress[nftIds[i]] == msg.sender,
2257                 "Skul NFT not staked / Not Staker"
2258             );
2259             verifySignature(signatures[i], nftIds[i], serumIds[i]);
2260             skulNFT.transferFrom(address(this), msg.sender, nftIds[i]);
2261             alreadyClaim[nftIds[i]] = true;
2262             _mint(msg.sender, serumIds[i], 1, "");
2263         }
2264     }
2265 
2266     function _beforeTokenTransfer(
2267         address operator,
2268         address from,
2269         address to,
2270         uint256[] memory ids,
2271         uint256[] memory amounts,
2272         bytes memory data
2273     ) internal override whenNotPaused {
2274         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2275     }
2276 
2277     function uri(uint256 tokenId)
2278         public
2279         view
2280         virtual
2281         override
2282         returns (string memory)
2283     {
2284         return string(abi.encodePacked(baseURI, tokenId.toString()));
2285     }
2286 
2287     function burnStakedSkul(uint256[] calldata nftIds) external onlyOwner {
2288         for (uint256 i; i < nftIds.length; i++) {
2289             skulNFT.transferFrom(
2290                 address(this),
2291                 address(0x00000dead),
2292                 nftIds[i]
2293             );
2294         }
2295     }
2296 }