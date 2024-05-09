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
636 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
637 
638 
639 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 
644 /**
645  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
646  *
647  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
648  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
649  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
650  *
651  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
652  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
653  * ({_hashTypedDataV4}).
654  *
655  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
656  * the chain id to protect against replay attacks on an eventual fork of the chain.
657  *
658  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
659  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
660  *
661  * _Available since v3.4._
662  */
663 abstract contract EIP712 {
664     /* solhint-disable var-name-mixedcase */
665     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
666     // invalidate the cached domain separator if the chain id changes.
667     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
668     uint256 private immutable _CACHED_CHAIN_ID;
669     address private immutable _CACHED_THIS;
670 
671     bytes32 private immutable _HASHED_NAME;
672     bytes32 private immutable _HASHED_VERSION;
673     bytes32 private immutable _TYPE_HASH;
674 
675     /* solhint-enable var-name-mixedcase */
676 
677     /**
678      * @dev Initializes the domain separator and parameter caches.
679      *
680      * The meaning of `name` and `version` is specified in
681      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
682      *
683      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
684      * - `version`: the current major version of the signing domain.
685      *
686      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
687      * contract upgrade].
688      */
689     constructor(string memory name, string memory version) {
690         bytes32 hashedName = keccak256(bytes(name));
691         bytes32 hashedVersion = keccak256(bytes(version));
692         bytes32 typeHash = keccak256(
693             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
694         );
695         _HASHED_NAME = hashedName;
696         _HASHED_VERSION = hashedVersion;
697         _CACHED_CHAIN_ID = block.chainid;
698         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
699         _CACHED_THIS = address(this);
700         _TYPE_HASH = typeHash;
701     }
702 
703     /**
704      * @dev Returns the domain separator for the current chain.
705      */
706     function _domainSeparatorV4() internal view returns (bytes32) {
707         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
708             return _CACHED_DOMAIN_SEPARATOR;
709         } else {
710             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
711         }
712     }
713 
714     function _buildDomainSeparator(
715         bytes32 typeHash,
716         bytes32 nameHash,
717         bytes32 versionHash
718     ) private view returns (bytes32) {
719         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
720     }
721 
722     /**
723      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
724      * function returns the hash of the fully encoded EIP712 message for this domain.
725      *
726      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
727      *
728      * ```solidity
729      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
730      *     keccak256("Mail(address to,string contents)"),
731      *     mailTo,
732      *     keccak256(bytes(mailContents))
733      * )));
734      * address signer = ECDSA.recover(digest, signature);
735      * ```
736      */
737     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
738         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
739     }
740 }
741 
742 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
743 
744 
745 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/draft-EIP712.sol)
746 
747 pragma solidity ^0.8.0;
748 
749 // EIP-712 is Final as of 2022-08-11. This file is deprecated.
750 
751 
752 // File: @openzeppelin/contracts/utils/Context.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @dev Provides information about the current execution context, including the
761  * sender of the transaction and its data. While these are generally available
762  * via msg.sender and msg.data, they should not be accessed in such a direct
763  * manner, since when dealing with meta-transactions the account sending and
764  * paying for execution may not be the actual sender (as far as an application
765  * is concerned).
766  *
767  * This contract is only required for intermediate, library-like contracts.
768  */
769 abstract contract Context {
770     function _msgSender() internal view virtual returns (address) {
771         return msg.sender;
772     }
773 
774     function _msgData() internal view virtual returns (bytes calldata) {
775         return msg.data;
776     }
777 }
778 
779 // File: @openzeppelin/contracts/access/Ownable.sol
780 
781 
782 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
783 
784 pragma solidity ^0.8.0;
785 
786 
787 /**
788  * @dev Contract module which provides a basic access control mechanism, where
789  * there is an account (an owner) that can be granted exclusive access to
790  * specific functions.
791  *
792  * By default, the owner account will be the one that deploys the contract. This
793  * can later be changed with {transferOwnership}.
794  *
795  * This module is used through inheritance. It will make available the modifier
796  * `onlyOwner`, which can be applied to your functions to restrict their use to
797  * the owner.
798  */
799 abstract contract Ownable is Context {
800     address private _owner;
801 
802     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
803 
804     /**
805      * @dev Initializes the contract setting the deployer as the initial owner.
806      */
807     constructor() {
808         _transferOwnership(_msgSender());
809     }
810 
811     /**
812      * @dev Throws if called by any account other than the owner.
813      */
814     modifier onlyOwner() {
815         _checkOwner();
816         _;
817     }
818 
819     /**
820      * @dev Returns the address of the current owner.
821      */
822     function owner() public view virtual returns (address) {
823         return _owner;
824     }
825 
826     /**
827      * @dev Throws if the sender is not the owner.
828      */
829     function _checkOwner() internal view virtual {
830         require(owner() == _msgSender(), "Ownable: caller is not the owner");
831     }
832 
833     /**
834      * @dev Leaves the contract without owner. It will not be possible to call
835      * `onlyOwner` functions anymore. Can only be called by the current owner.
836      *
837      * NOTE: Renouncing ownership will leave the contract without an owner,
838      * thereby removing any functionality that is only available to the owner.
839      */
840     function renounceOwnership() public virtual onlyOwner {
841         _transferOwnership(address(0));
842     }
843 
844     /**
845      * @dev Transfers ownership of the contract to a new account (`newOwner`).
846      * Can only be called by the current owner.
847      */
848     function transferOwnership(address newOwner) public virtual onlyOwner {
849         require(newOwner != address(0), "Ownable: new owner is the zero address");
850         _transferOwnership(newOwner);
851     }
852 
853     /**
854      * @dev Transfers ownership of the contract to a new account (`newOwner`).
855      * Internal function without access restriction.
856      */
857     function _transferOwnership(address newOwner) internal virtual {
858         address oldOwner = _owner;
859         _owner = newOwner;
860         emit OwnershipTransferred(oldOwner, newOwner);
861     }
862 }
863 
864 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
865 
866 
867 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
868 
869 pragma solidity ^0.8.0;
870 
871 /**
872  * @dev Contract module that helps prevent reentrant calls to a function.
873  *
874  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
875  * available, which can be applied to functions to make sure there are no nested
876  * (reentrant) calls to them.
877  *
878  * Note that because there is a single `nonReentrant` guard, functions marked as
879  * `nonReentrant` may not call one another. This can be worked around by making
880  * those functions `private`, and then adding `external` `nonReentrant` entry
881  * points to them.
882  *
883  * TIP: If you would like to learn more about reentrancy and alternative ways
884  * to protect against it, check out our blog post
885  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
886  */
887 abstract contract ReentrancyGuard {
888     // Booleans are more expensive than uint256 or any type that takes up a full
889     // word because each write operation emits an extra SLOAD to first read the
890     // slot's contents, replace the bits taken up by the boolean, and then write
891     // back. This is the compiler's defense against contract upgrades and
892     // pointer aliasing, and it cannot be disabled.
893 
894     // The values being non-zero value makes deployment a bit more expensive,
895     // but in exchange the refund on every call to nonReentrant will be lower in
896     // amount. Since refunds are capped to a percentage of the total
897     // transaction's gas, it is best to keep them low in cases like this one, to
898     // increase the likelihood of the full refund coming into effect.
899     uint256 private constant _NOT_ENTERED = 1;
900     uint256 private constant _ENTERED = 2;
901 
902     uint256 private _status;
903 
904     constructor() {
905         _status = _NOT_ENTERED;
906     }
907 
908     /**
909      * @dev Prevents a contract from calling itself, directly or indirectly.
910      * Calling a `nonReentrant` function from another `nonReentrant`
911      * function is not supported. It is possible to prevent this from happening
912      * by making the `nonReentrant` function external, and making it call a
913      * `private` function that does the actual work.
914      */
915     modifier nonReentrant() {
916         _nonReentrantBefore();
917         _;
918         _nonReentrantAfter();
919     }
920 
921     function _nonReentrantBefore() private {
922         // On the first call to nonReentrant, _status will be _NOT_ENTERED
923         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
924 
925         // Any calls to nonReentrant after this point will fail
926         _status = _ENTERED;
927     }
928 
929     function _nonReentrantAfter() private {
930         // By storing the original value once again, a refund is triggered (see
931         // https://eips.ethereum.org/EIPS/eip-2200)
932         _status = _NOT_ENTERED;
933     }
934 }
935 
936 // File: @openzeppelin/contracts/utils/Address.sol
937 
938 
939 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
940 
941 pragma solidity ^0.8.1;
942 
943 /**
944  * @dev Collection of functions related to the address type
945  */
946 library Address {
947     /**
948      * @dev Returns true if `account` is a contract.
949      *
950      * [IMPORTANT]
951      * ====
952      * It is unsafe to assume that an address for which this function returns
953      * false is an externally-owned account (EOA) and not a contract.
954      *
955      * Among others, `isContract` will return false for the following
956      * types of addresses:
957      *
958      *  - an externally-owned account
959      *  - a contract in construction
960      *  - an address where a contract will be created
961      *  - an address where a contract lived, but was destroyed
962      * ====
963      *
964      * [IMPORTANT]
965      * ====
966      * You shouldn't rely on `isContract` to protect against flash loan attacks!
967      *
968      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
969      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
970      * constructor.
971      * ====
972      */
973     function isContract(address account) internal view returns (bool) {
974         // This method relies on extcodesize/address.code.length, which returns 0
975         // for contracts in construction, since the code is only stored at the end
976         // of the constructor execution.
977 
978         return account.code.length > 0;
979     }
980 
981     /**
982      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
983      * `recipient`, forwarding all available gas and reverting on errors.
984      *
985      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
986      * of certain opcodes, possibly making contracts go over the 2300 gas limit
987      * imposed by `transfer`, making them unable to receive funds via
988      * `transfer`. {sendValue} removes this limitation.
989      *
990      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
991      *
992      * IMPORTANT: because control is transferred to `recipient`, care must be
993      * taken to not create reentrancy vulnerabilities. Consider using
994      * {ReentrancyGuard} or the
995      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
996      */
997     function sendValue(address payable recipient, uint256 amount) internal {
998         require(address(this).balance >= amount, "Address: insufficient balance");
999 
1000         (bool success, ) = recipient.call{value: amount}("");
1001         require(success, "Address: unable to send value, recipient may have reverted");
1002     }
1003 
1004     /**
1005      * @dev Performs a Solidity function call using a low level `call`. A
1006      * plain `call` is an unsafe replacement for a function call: use this
1007      * function instead.
1008      *
1009      * If `target` reverts with a revert reason, it is bubbled up by this
1010      * function (like regular Solidity function calls).
1011      *
1012      * Returns the raw returned data. To convert to the expected return value,
1013      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1014      *
1015      * Requirements:
1016      *
1017      * - `target` must be a contract.
1018      * - calling `target` with `data` must not revert.
1019      *
1020      * _Available since v3.1._
1021      */
1022     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1023         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1024     }
1025 
1026     /**
1027      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1028      * `errorMessage` as a fallback revert reason when `target` reverts.
1029      *
1030      * _Available since v3.1._
1031      */
1032     function functionCall(
1033         address target,
1034         bytes memory data,
1035         string memory errorMessage
1036     ) internal returns (bytes memory) {
1037         return functionCallWithValue(target, data, 0, errorMessage);
1038     }
1039 
1040     /**
1041      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1042      * but also transferring `value` wei to `target`.
1043      *
1044      * Requirements:
1045      *
1046      * - the calling contract must have an ETH balance of at least `value`.
1047      * - the called Solidity function must be `payable`.
1048      *
1049      * _Available since v3.1._
1050      */
1051     function functionCallWithValue(
1052         address target,
1053         bytes memory data,
1054         uint256 value
1055     ) internal returns (bytes memory) {
1056         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1057     }
1058 
1059     /**
1060      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1061      * with `errorMessage` as a fallback revert reason when `target` reverts.
1062      *
1063      * _Available since v3.1._
1064      */
1065     function functionCallWithValue(
1066         address target,
1067         bytes memory data,
1068         uint256 value,
1069         string memory errorMessage
1070     ) internal returns (bytes memory) {
1071         require(address(this).balance >= value, "Address: insufficient balance for call");
1072         (bool success, bytes memory returndata) = target.call{value: value}(data);
1073         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1074     }
1075 
1076     /**
1077      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1078      * but performing a static call.
1079      *
1080      * _Available since v3.3._
1081      */
1082     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1083         return functionStaticCall(target, data, "Address: low-level static call failed");
1084     }
1085 
1086     /**
1087      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1088      * but performing a static call.
1089      *
1090      * _Available since v3.3._
1091      */
1092     function functionStaticCall(
1093         address target,
1094         bytes memory data,
1095         string memory errorMessage
1096     ) internal view returns (bytes memory) {
1097         (bool success, bytes memory returndata) = target.staticcall(data);
1098         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1099     }
1100 
1101     /**
1102      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1103      * but performing a delegate call.
1104      *
1105      * _Available since v3.4._
1106      */
1107     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1108         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1109     }
1110 
1111     /**
1112      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1113      * but performing a delegate call.
1114      *
1115      * _Available since v3.4._
1116      */
1117     function functionDelegateCall(
1118         address target,
1119         bytes memory data,
1120         string memory errorMessage
1121     ) internal returns (bytes memory) {
1122         (bool success, bytes memory returndata) = target.delegatecall(data);
1123         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1124     }
1125 
1126     /**
1127      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1128      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1129      *
1130      * _Available since v4.8._
1131      */
1132     function verifyCallResultFromTarget(
1133         address target,
1134         bool success,
1135         bytes memory returndata,
1136         string memory errorMessage
1137     ) internal view returns (bytes memory) {
1138         if (success) {
1139             if (returndata.length == 0) {
1140                 // only check isContract if the call was successful and the return data is empty
1141                 // otherwise we already know that it was a contract
1142                 require(isContract(target), "Address: call to non-contract");
1143             }
1144             return returndata;
1145         } else {
1146             _revert(returndata, errorMessage);
1147         }
1148     }
1149 
1150     /**
1151      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1152      * revert reason or using the provided one.
1153      *
1154      * _Available since v4.3._
1155      */
1156     function verifyCallResult(
1157         bool success,
1158         bytes memory returndata,
1159         string memory errorMessage
1160     ) internal pure returns (bytes memory) {
1161         if (success) {
1162             return returndata;
1163         } else {
1164             _revert(returndata, errorMessage);
1165         }
1166     }
1167 
1168     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1169         // Look for revert reason and bubble it up if present
1170         if (returndata.length > 0) {
1171             // The easiest way to bubble the revert reason is using memory via assembly
1172             /// @solidity memory-safe-assembly
1173             assembly {
1174                 let returndata_size := mload(returndata)
1175                 revert(add(32, returndata), returndata_size)
1176             }
1177         } else {
1178             revert(errorMessage);
1179         }
1180     }
1181 }
1182 
1183 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1184 
1185 
1186 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1187 
1188 pragma solidity ^0.8.0;
1189 
1190 /**
1191  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1192  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1193  *
1194  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1195  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1196  * need to send a transaction, and thus is not required to hold Ether at all.
1197  */
1198 interface IERC20Permit {
1199     /**
1200      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1201      * given ``owner``'s signed approval.
1202      *
1203      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1204      * ordering also apply here.
1205      *
1206      * Emits an {Approval} event.
1207      *
1208      * Requirements:
1209      *
1210      * - `spender` cannot be the zero address.
1211      * - `deadline` must be a timestamp in the future.
1212      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1213      * over the EIP712-formatted function arguments.
1214      * - the signature must use ``owner``'s current nonce (see {nonces}).
1215      *
1216      * For more information on the signature format, see the
1217      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1218      * section].
1219      */
1220     function permit(
1221         address owner,
1222         address spender,
1223         uint256 value,
1224         uint256 deadline,
1225         uint8 v,
1226         bytes32 r,
1227         bytes32 s
1228     ) external;
1229 
1230     /**
1231      * @dev Returns the current nonce for `owner`. This value must be
1232      * included whenever a signature is generated for {permit}.
1233      *
1234      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1235      * prevents a signature from being used multiple times.
1236      */
1237     function nonces(address owner) external view returns (uint256);
1238 
1239     /**
1240      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1241      */
1242     // solhint-disable-next-line func-name-mixedcase
1243     function DOMAIN_SEPARATOR() external view returns (bytes32);
1244 }
1245 
1246 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1247 
1248 
1249 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1250 
1251 pragma solidity ^0.8.0;
1252 
1253 /**
1254  * @dev Interface of the ERC20 standard as defined in the EIP.
1255  */
1256 interface IERC20 {
1257     /**
1258      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1259      * another (`to`).
1260      *
1261      * Note that `value` may be zero.
1262      */
1263     event Transfer(address indexed from, address indexed to, uint256 value);
1264 
1265     /**
1266      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1267      * a call to {approve}. `value` is the new allowance.
1268      */
1269     event Approval(address indexed owner, address indexed spender, uint256 value);
1270 
1271     /**
1272      * @dev Returns the amount of tokens in existence.
1273      */
1274     function totalSupply() external view returns (uint256);
1275 
1276     /**
1277      * @dev Returns the amount of tokens owned by `account`.
1278      */
1279     function balanceOf(address account) external view returns (uint256);
1280 
1281     /**
1282      * @dev Moves `amount` tokens from the caller's account to `to`.
1283      *
1284      * Returns a boolean value indicating whether the operation succeeded.
1285      *
1286      * Emits a {Transfer} event.
1287      */
1288     function transfer(address to, uint256 amount) external returns (bool);
1289 
1290     /**
1291      * @dev Returns the remaining number of tokens that `spender` will be
1292      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1293      * zero by default.
1294      *
1295      * This value changes when {approve} or {transferFrom} are called.
1296      */
1297     function allowance(address owner, address spender) external view returns (uint256);
1298 
1299     /**
1300      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1301      *
1302      * Returns a boolean value indicating whether the operation succeeded.
1303      *
1304      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1305      * that someone may use both the old and the new allowance by unfortunate
1306      * transaction ordering. One possible solution to mitigate this race
1307      * condition is to first reduce the spender's allowance to 0 and set the
1308      * desired value afterwards:
1309      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1310      *
1311      * Emits an {Approval} event.
1312      */
1313     function approve(address spender, uint256 amount) external returns (bool);
1314 
1315     /**
1316      * @dev Moves `amount` tokens from `from` to `to` using the
1317      * allowance mechanism. `amount` is then deducted from the caller's
1318      * allowance.
1319      *
1320      * Returns a boolean value indicating whether the operation succeeded.
1321      *
1322      * Emits a {Transfer} event.
1323      */
1324     function transferFrom(
1325         address from,
1326         address to,
1327         uint256 amount
1328     ) external returns (bool);
1329 }
1330 
1331 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1332 
1333 
1334 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1335 
1336 pragma solidity ^0.8.0;
1337 
1338 
1339 
1340 
1341 /**
1342  * @title SafeERC20
1343  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1344  * contract returns false). Tokens that return no value (and instead revert or
1345  * throw on failure) are also supported, non-reverting calls are assumed to be
1346  * successful.
1347  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1348  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1349  */
1350 library SafeERC20 {
1351     using Address for address;
1352 
1353     function safeTransfer(
1354         IERC20 token,
1355         address to,
1356         uint256 value
1357     ) internal {
1358         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1359     }
1360 
1361     function safeTransferFrom(
1362         IERC20 token,
1363         address from,
1364         address to,
1365         uint256 value
1366     ) internal {
1367         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1368     }
1369 
1370     /**
1371      * @dev Deprecated. This function has issues similar to the ones found in
1372      * {IERC20-approve}, and its usage is discouraged.
1373      *
1374      * Whenever possible, use {safeIncreaseAllowance} and
1375      * {safeDecreaseAllowance} instead.
1376      */
1377     function safeApprove(
1378         IERC20 token,
1379         address spender,
1380         uint256 value
1381     ) internal {
1382         // safeApprove should only be called when setting an initial allowance,
1383         // or when resetting it to zero. To increase and decrease it, use
1384         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1385         require(
1386             (value == 0) || (token.allowance(address(this), spender) == 0),
1387             "SafeERC20: approve from non-zero to non-zero allowance"
1388         );
1389         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1390     }
1391 
1392     function safeIncreaseAllowance(
1393         IERC20 token,
1394         address spender,
1395         uint256 value
1396     ) internal {
1397         uint256 newAllowance = token.allowance(address(this), spender) + value;
1398         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1399     }
1400 
1401     function safeDecreaseAllowance(
1402         IERC20 token,
1403         address spender,
1404         uint256 value
1405     ) internal {
1406         unchecked {
1407             uint256 oldAllowance = token.allowance(address(this), spender);
1408             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1409             uint256 newAllowance = oldAllowance - value;
1410             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1411         }
1412     }
1413 
1414     function safePermit(
1415         IERC20Permit token,
1416         address owner,
1417         address spender,
1418         uint256 value,
1419         uint256 deadline,
1420         uint8 v,
1421         bytes32 r,
1422         bytes32 s
1423     ) internal {
1424         uint256 nonceBefore = token.nonces(owner);
1425         token.permit(owner, spender, value, deadline, v, r, s);
1426         uint256 nonceAfter = token.nonces(owner);
1427         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1428     }
1429 
1430     /**
1431      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1432      * on the return value: the return value is optional (but if data is returned, it must not be false).
1433      * @param token The token targeted by the call.
1434      * @param data The call data (encoded using abi.encode or one of its variants).
1435      */
1436     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1437         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1438         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1439         // the target address contains contract code and also asserts for success in the low-level call.
1440 
1441         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1442         if (returndata.length > 0) {
1443             // Return data is optional
1444             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1445         }
1446     }
1447 }
1448 
1449 // File: .deps/contracts/PresaleVestingRoundA.sol
1450 
1451 
1452 pragma solidity ^0.8.0;
1453 
1454 
1455 
1456 
1457 
1458 
1459 
1460 contract PresaleVestingRoundA is ReentrancyGuard, EIP712, Ownable {
1461     using SafeERC20 for IERC20;
1462 
1463     struct Stake {
1464         uint256 amount;
1465         uint256 startTime;
1466         uint256 endTime;
1467         uint256 bonus;
1468         bool claimed;
1469     }
1470 
1471     IERC20 public token;
1472     uint256 public presaleCloseTimestamp = 1682866800; // 30th april '23 15:00 utc
1473     uint256 public vestingStartTimestamp = 1684335600; // 17th may '23 15:00 utc
1474     uint256 public overallPurchaseLimit = 60000000000000000000;
1475 
1476     uint256 public constant MONTH_IN_SECONDS = 2592000;
1477 
1478     mapping(address => uint256) public purchasedTokens;
1479     mapping(address => uint256) public stakedTokens;
1480     mapping(address => uint256) public claimedTokens; //paid out tokens
1481     mapping(address => uint256) public claimedBonusTokens; //paid out bonus tokens (from staking)
1482     mapping(address => Stake[]) public stakingInfo;
1483 
1484     address public signer = 0x0076a35889Ac98C5055a5b4adba5480eaFb93Abc;
1485     uint256 public maxTokensToPurchase = 857142855000000000;
1486     uint256 public totalPurchased;
1487     uint256 public totalStaked;
1488     uint256 public totalClaimed;
1489     uint256 public totalBonusClaimed;
1490     uint256 public totalEth;
1491     bool public paused;
1492     bool public stakingEnabled = true;
1493 
1494     string private constant SIGNING_DOMAIN = "PresaleReserveA-Voucher";
1495     
1496     string private constant SIGNATURE_VERSION = "1";
1497 
1498     uint256[] public stakingPeriods = [3, 6, 12];
1499     uint256[] public stakingBonuses = [6, 8, 12];
1500 
1501     uint256[] public monthlyVestingPercentages = [375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375, 375];
1502     uint256[] public vestingDurations = [2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000, 2592000];
1503    
1504     uint256 public initialVestingPercentage = 10;
1505     uint256 public initialVestingOffsetDays = 10;
1506     uint256 public emergencyUnstakePenalty = 20;
1507 
1508     event TokensPurchased(address indexed user, uint256 amount);
1509     event TokensStaked(address indexed user, uint256 amount, uint256 startTime, uint256 endTime, uint256 bonus);
1510     event TokensClaimed(address indexed user, uint256 amount);
1511     event BonusTokensClaimed(address indexed user, uint256 amount);
1512     event EmergencyUnstake(address indexed user, uint256 index, uint256 amount);
1513     event ERC20Withdrawn(address indexed token, address indexed to, uint256 amount);
1514     event Withdrawn(address indexed wallet, uint256 amount);
1515 
1516     constructor(IERC20 _token) EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION) {
1517         token = _token;
1518     }
1519     
1520     struct PresaleReserveVoucher {
1521         uint256 amount;
1522         uint256 expires;
1523         uint256 value;
1524         address wallet;
1525         /// @notice the EIP-712 signature of all other fields in the struct. For a voucher to be valid, it must be signed by an account with the signer.
1526         bytes signature;
1527     }
1528 
1529     function _hash(PresaleReserveVoucher memory voucher) internal view returns (bytes32) {
1530         return _hashTypedDataV4(keccak256(abi.encode(
1531             keccak256("Struct(uint256 amount,uint256 expires,uint256 value,address wallet)"),
1532             voucher.amount,
1533             voucher.expires,
1534             voucher.value,
1535             voucher.wallet
1536         )));
1537     }
1538 
1539     function _verify(PresaleReserveVoucher memory voucher) internal view returns (address) {
1540         bytes32 digest = _hash(voucher);
1541         return ECDSA.recover(digest, voucher.signature);
1542     }
1543 
1544     function pause() public onlyOwner {
1545         paused = true;
1546     }
1547 
1548     function resume() public onlyOwner {
1549         paused = false;
1550     }
1551 
1552     function setStakingEnabled(bool _enabled) public onlyOwner {
1553         stakingEnabled = _enabled;
1554     }
1555     
1556     function setStakingPeriods(uint256[] memory _periods) public onlyOwner {
1557         stakingPeriods = _periods;
1558     }
1559 
1560     function setStakingBonuses(uint256[] memory _bonuses) public onlyOwner {
1561         stakingBonuses = _bonuses;
1562     }
1563 
1564     function setSigner(address _signer) public onlyOwner {
1565         signer = _signer;
1566     }
1567 
1568     function setMaxTokensToPurchase(uint256 maxValue) external onlyOwner {
1569         maxTokensToPurchase = maxValue;
1570     }
1571 
1572     function setPresaleCloseTimestamp(uint256 _timestamp) external onlyOwner {
1573         presaleCloseTimestamp = _timestamp;
1574     }
1575 
1576     function setVestingStartTimestamp(uint256 _timestamp) external onlyOwner {
1577         vestingStartTimestamp = _timestamp;
1578     }
1579 
1580     function setOverallPurchaseLimit(uint256 _limit) external onlyOwner {
1581         overallPurchaseLimit = _limit;
1582     }
1583 
1584     function setEmergencyUnstakePenalty(uint256 _penalty) external onlyOwner {
1585         emergencyUnstakePenalty = _penalty;
1586     }
1587 
1588     function getVestingDurations() external view returns (uint256[] memory) {
1589         return vestingDurations;
1590     }
1591 
1592     function purchaseTokens(uint256 amount, uint256 value, uint256 expires, address wallet, bytes memory signature) payable external nonReentrant {
1593         require(!paused, "Paused");
1594         require(block.timestamp < presaleCloseTimestamp, "Purchase stage is over");
1595         require(totalPurchased + amount <= overallPurchaseLimit, "Overall token purchase limit exceeding");
1596         require(purchasedTokens[wallet] + amount <= maxTokensToPurchase, "Cannot reserve more tokens");
1597         require(amount > 0, "Amount has to be greater than zero");
1598         require(msg.value >= value, "Eth amount not valid");
1599         require(block.number <= expires, "Voucher expired");
1600 
1601         PresaleReserveVoucher memory voucher = PresaleReserveVoucher({amount: amount, value: value, expires: expires, wallet: wallet, signature: signature});
1602         address _signer = _verify(voucher);
1603 
1604         require(_signer == signer, "Signature invalid");
1605 
1606         purchasedTokens[voucher.wallet] += amount;
1607         totalPurchased += amount;
1608         totalEth += value;
1609 
1610         emit TokensPurchased(voucher.wallet, amount);
1611     }
1612 
1613     function claimVestedTokens() external nonReentrant {
1614         uint256 vestedAmount = calculateVestedAmount(msg.sender);
1615         require(vestedAmount > 0, "No vested tokens available");
1616 
1617         claimedTokens[msg.sender] += vestedAmount;
1618         totalClaimed += vestedAmount;
1619 
1620         token.safeTransfer(msg.sender, vestedAmount);
1621         emit TokensClaimed(msg.sender, vestedAmount);
1622     }
1623 
1624     function stakeVestedTokens(uint256 stakingPeriodIndex) external nonReentrant {
1625         require(stakingPeriodIndex < stakingPeriods.length, "Invalid staking period index");
1626 
1627         uint256 stakingPeriod = stakingPeriods[stakingPeriodIndex];
1628         uint256 bonusPercentage = stakingBonuses[stakingPeriodIndex];
1629 
1630         uint256 vestedAmount = calculateVestedAmount(msg.sender);
1631         require(vestedAmount > 0, "No vested tokens available");
1632 
1633         uint256 bonusAmount = (vestedAmount * bonusPercentage) / 100;
1634 
1635         uint256 startTime = block.timestamp;
1636         uint256 endTime = startTime + (stakingPeriod * MONTH_IN_SECONDS);
1637 
1638         stakedTokens[msg.sender] += vestedAmount;
1639         totalStaked += vestedAmount;
1640 
1641         Stake memory newStake = Stake({
1642             amount: vestedAmount,
1643             startTime: startTime,
1644             endTime: endTime,
1645             bonus: bonusAmount,
1646             claimed: false
1647         });
1648 
1649         stakingInfo[msg.sender].push(newStake);
1650         emit TokensStaked(msg.sender, vestedAmount, startTime, endTime, bonusAmount);
1651     }
1652 
1653     function restakeStakedTokens(uint256 index, uint256 stakingPeriodIndex) external nonReentrant {
1654         require(stakingEnabled, "Staking is not enabled");
1655         Stake storage stake = stakingInfo[msg.sender][index];
1656         require(!stake.claimed, "Stake already claimed or re-staked");
1657         require(block.timestamp >= stake.endTime, "Staking period not ended yet");
1658         require(stakingPeriodIndex < stakingPeriods.length, "Invalid staking period index");
1659 
1660         uint256 stakingPeriod = stakingPeriods[stakingPeriodIndex];
1661         uint256 bonusPercentage = stakingBonuses[stakingPeriodIndex];
1662         
1663         claimedBonusTokens[msg.sender] += stake.bonus;
1664         totalBonusClaimed += stake.bonus;
1665 
1666         stakingInfo[msg.sender][index].claimed = true;
1667 
1668         token.safeTransfer(msg.sender, stake.bonus);
1669         emit BonusTokensClaimed(msg.sender, stake.bonus);
1670 
1671         uint256 bonusAmount = (stake.amount * bonusPercentage) / 100;
1672         uint256 startTime = block.timestamp;
1673         uint256 endTime = startTime + (stakingPeriod * MONTH_IN_SECONDS);
1674 
1675         Stake memory newStake = Stake({
1676             amount: stake.amount,
1677             startTime: startTime,
1678             endTime: endTime,
1679             bonus: bonusAmount,
1680             claimed: false
1681         });
1682 
1683         stakingInfo[msg.sender].push(newStake);
1684         emit TokensStaked(msg.sender, stake.amount, startTime, endTime, bonusAmount);
1685     }
1686 
1687     function claimStakedTokens(uint256 index) external nonReentrant {
1688         require(stakingEnabled, "Staking is not enabled");
1689         Stake storage stake = stakingInfo[msg.sender][index];
1690         require(!stake.claimed, "Stake already claimed");
1691         require(block.timestamp >= stake.endTime, "Staking period not ended yet");
1692 
1693         uint256 totalAmount = stake.amount + stake.bonus;
1694         stakingInfo[msg.sender][index].claimed = true;
1695 
1696         stakedTokens[msg.sender] -= stake.amount;
1697         claimedTokens[msg.sender] += stake.amount;
1698         claimedBonusTokens[msg.sender] += stake.bonus;
1699         totalStaked -= stake.amount;
1700         totalClaimed += stake.amount;
1701         totalBonusClaimed += stake.bonus;
1702 
1703         token.safeTransfer(msg.sender, totalAmount);
1704         emit TokensClaimed(msg.sender, stake.amount);
1705         emit BonusTokensClaimed(msg.sender, stake.bonus);
1706     }
1707 
1708     function claimAllStakedTokens() external nonReentrant {
1709         require(stakingEnabled, "Staking is not enabled");
1710 
1711         Stake[] storage stakes = stakingInfo[msg.sender];
1712 
1713         for (uint256 i = 0; i < stakes.length; i++) {
1714             if (!stakes[i].claimed && block.timestamp >= stakes[i].endTime) {
1715                 uint256 totalAmount = stakes[i].amount + stakes[i].bonus;
1716                 stakingInfo[msg.sender][i].claimed = true;
1717 
1718                 stakedTokens[msg.sender] -= stakes[i].amount;
1719                 claimedTokens[msg.sender] += stakes[i].amount;
1720                 totalStaked -= stakes[i].amount;
1721                 totalClaimed += stakes[i].amount;
1722 
1723                 token.safeTransfer(msg.sender, totalAmount);
1724                 emit TokensClaimed(msg.sender, totalAmount);
1725 
1726             }
1727         }
1728     }
1729 
1730     function restakeAllStakedTokens(uint256 stakingPeriodIndex) external nonReentrant {
1731         require(stakingEnabled, "Staking is not enabled");
1732         
1733         require(stakingPeriodIndex < stakingPeriods.length, "Invalid staking period index");
1734         
1735         uint256 stakingPeriod = stakingPeriods[stakingPeriodIndex];
1736         uint256 bonusPercentage = stakingBonuses[stakingPeriodIndex];
1737                 
1738         Stake[] storage stakes = stakingInfo[msg.sender];
1739 
1740         uint256 bonusAccumulated = 0;
1741 
1742         for (uint256 i = 0; i < stakes.length; i++) {
1743             if (!stakes[i].claimed && block.timestamp >= stakes[i].endTime) {
1744                 bonusAccumulated += stakes[i].bonus;
1745                 
1746                 uint256 bonusAmount = (stakes[i].amount * bonusPercentage) / 100;
1747                 uint256 startTime = block.timestamp;
1748                 uint256 endTime = startTime + (stakingPeriod * MONTH_IN_SECONDS);
1749 
1750                 stakingInfo[msg.sender][i].claimed = true;
1751 
1752                 Stake memory newStake = Stake({
1753                     amount: stakes[i].amount,
1754                     startTime: startTime,
1755                     endTime: endTime,
1756                     bonus: bonusAmount,
1757                     claimed: false
1758                 });
1759 
1760                 stakingInfo[msg.sender].push(newStake);
1761                 emit TokensStaked(msg.sender, stakes[i].amount, startTime, endTime, bonusAmount);
1762                 emit BonusTokensClaimed(msg.sender, stakes[i].bonus);
1763             }
1764         }
1765 
1766         claimedBonusTokens[msg.sender] += bonusAccumulated;
1767         totalBonusClaimed += bonusAccumulated;
1768 
1769         token.safeTransfer(msg.sender, bonusAccumulated);
1770     }
1771 
1772     function emergencyUnstake(uint256 index) external nonReentrant {
1773         require(stakingEnabled, "Staking is not enabled");
1774         
1775         Stake storage stake = stakingInfo[msg.sender][index];
1776         require(!stake.claimed, "Stake already claimed");
1777         
1778         stakedTokens[msg.sender] -= stake.amount;
1779         totalStaked -= stake.amount;
1780         claimedTokens[msg.sender] += stake.amount;
1781         totalClaimed += stake.amount;
1782 
1783         uint256 penalty = (stake.amount * emergencyUnstakePenalty) / 100; // Apply a 20% penalty fee
1784         uint256 unstakeAmount = stake.amount - penalty;
1785         stakingInfo[msg.sender][index].claimed = true;
1786 
1787         token.safeTransfer(msg.sender, unstakeAmount);
1788         emit EmergencyUnstake(msg.sender, index, unstakeAmount);
1789     }
1790 
1791     function getStakingInfo(address user) external view returns (Stake[] memory) {
1792         return stakingInfo[user];
1793     }
1794 
1795     function getStakeBonusProgress(address user, uint256 index) external view returns (uint256) {
1796         require(stakingEnabled, "Staking is not enabled");
1797 
1798         Stake storage stake = stakingInfo[user][index];
1799         if (block.timestamp >= stake.endTime) {
1800             return stake.bonus;
1801         }
1802 
1803         uint256 elapsedSeconds = block.timestamp - stake.startTime;
1804         uint256 stakingDuration = stake.endTime - stake.startTime;
1805         uint256 bonusPercentage = (elapsedSeconds * 100) / stakingDuration;
1806 
1807         return (stake.bonus * bonusPercentage) / 100;
1808     }
1809 
1810     function setMonthlyVestingPercentages(uint256[] memory newPercentages) external onlyOwner {
1811         monthlyVestingPercentages = newPercentages;
1812     }
1813 
1814     function setInitialVestingPercentage(uint256 newPercentage) external onlyOwner {
1815         initialVestingPercentage = newPercentage;
1816     }
1817 
1818     function setInitialVestingOffsetDays(uint256 newOffset) external onlyOwner {
1819         initialVestingOffsetDays = newOffset;
1820     }
1821 
1822     function setVestingDurations(uint256[] memory newDurations) external onlyOwner {
1823         vestingDurations = newDurations;
1824     }
1825 
1826     function calculateLockedTokens(address user) public view returns (uint256) {
1827         if (block.timestamp <= vestingStartTimestamp || vestingStartTimestamp == 0) return purchasedTokens[user];
1828         return purchasedTokens[user] - calculateUnlockedAmount(user);
1829     }
1830 
1831     function calculateUnlockedAmount(address user) public view returns (uint256) {
1832         if (block.timestamp <= vestingStartTimestamp || vestingStartTimestamp == 0) return 0;
1833 
1834         uint256 elapsedTime = block.timestamp - vestingStartTimestamp;
1835         uint256 vestedPercentage;
1836 
1837         if (elapsedTime >= initialVestingOffsetDays * (MONTH_IN_SECONDS / 30)) {
1838             vestedPercentage = initialVestingPercentage * 100;
1839         }
1840 
1841         if (elapsedTime >= MONTH_IN_SECONDS) {
1842             uint256 monthsPassed = elapsedTime / MONTH_IN_SECONDS;
1843 
1844             for (uint256 i = 0; i < monthlyVestingPercentages.length; i++) {
1845                 if (monthsPassed > i) {
1846                     vestedPercentage += monthlyVestingPercentages[i];
1847                 } else {
1848                     break;
1849                 }
1850             }
1851         }
1852 
1853         return (purchasedTokens[user] * vestedPercentage) / 10000;
1854     }
1855 
1856     function calculateVestedAmount(address user) public view returns (uint256) {
1857         if (block.timestamp <= vestingStartTimestamp || vestingStartTimestamp == 0) return 0;
1858 
1859         uint256 unlockedAmount = calculateUnlockedAmount(user);
1860 
1861         // staked and already claimed tokens have to be deducted from the vested token amount as the tokens are not available
1862         unlockedAmount -= stakedTokens[user] + claimedTokens[user];
1863 
1864         return unlockedAmount;
1865     }
1866 
1867     function withdrawERC20(IERC20 _token, address to, uint256 amount) public onlyOwner {
1868         uint256 erc20balance = _token.balanceOf(address(this));
1869         require(amount <= erc20balance, "Balance is too low");
1870     
1871         // If amount is set to zero, the entire token balance is withdrawn
1872         if (amount == 0) {
1873             amount = erc20balance;
1874         }
1875 
1876         _token.transfer(to, amount);
1877 
1878         emit ERC20Withdrawn(address(_token), to, amount);
1879     }
1880 
1881     function withdraw() public onlyOwner {
1882         address payable receiver = payable(msg.sender);
1883 
1884         uint256 _balance = address(this).balance;
1885         require(_balance > 0, "Balance must be higher than zero");
1886 
1887         receiver.transfer(_balance);
1888 
1889         emit Withdrawn(msg.sender, _balance);
1890     }
1891 }