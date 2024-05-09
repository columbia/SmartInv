1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/Math.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev Standard math utilities missing in the Solidity language.
12  */
13 library Math {
14     enum Rounding {
15         Down, // Toward negative infinity
16         Up, // Toward infinity
17         Zero // Toward zero
18     }
19 
20     /**
21      * @dev Returns the largest of two numbers.
22      */
23     function max(uint256 a, uint256 b) internal pure returns (uint256) {
24         return a > b ? a : b;
25     }
26 
27     /**
28      * @dev Returns the smallest of two numbers.
29      */
30     function min(uint256 a, uint256 b) internal pure returns (uint256) {
31         return a < b ? a : b;
32     }
33 
34     /**
35      * @dev Returns the average of two numbers. The result is rounded towards
36      * zero.
37      */
38     function average(uint256 a, uint256 b) internal pure returns (uint256) {
39         // (a + b) / 2 can overflow.
40         return (a & b) + (a ^ b) / 2;
41     }
42 
43     /**
44      * @dev Returns the ceiling of the division of two numbers.
45      *
46      * This differs from standard division with `/` in that it rounds up instead
47      * of rounding down.
48      */
49     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
50         // (a + b - 1) / b can overflow on addition, so we distribute.
51         return a == 0 ? 0 : (a - 1) / b + 1;
52     }
53 
54     /**
55      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
56      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
57      * with further edits by Uniswap Labs also under MIT license.
58      */
59     function mulDiv(
60         uint256 x,
61         uint256 y,
62         uint256 denominator
63     ) internal pure returns (uint256 result) {
64         unchecked {
65             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
66             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
67             // variables such that product = prod1 * 2^256 + prod0.
68             uint256 prod0; // Least significant 256 bits of the product
69             uint256 prod1; // Most significant 256 bits of the product
70             assembly {
71                 let mm := mulmod(x, y, not(0))
72                 prod0 := mul(x, y)
73                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
74             }
75 
76             // Handle non-overflow cases, 256 by 256 division.
77             if (prod1 == 0) {
78                 return prod0 / denominator;
79             }
80 
81             // Make sure the result is less than 2^256. Also prevents denominator == 0.
82             require(denominator > prod1);
83 
84             ///////////////////////////////////////////////
85             // 512 by 256 division.
86             ///////////////////////////////////////////////
87 
88             // Make division exact by subtracting the remainder from [prod1 prod0].
89             uint256 remainder;
90             assembly {
91                 // Compute remainder using mulmod.
92                 remainder := mulmod(x, y, denominator)
93 
94                 // Subtract 256 bit number from 512 bit number.
95                 prod1 := sub(prod1, gt(remainder, prod0))
96                 prod0 := sub(prod0, remainder)
97             }
98 
99             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
100             // See https://cs.stackexchange.com/q/138556/92363.
101 
102             // Does not overflow because the denominator cannot be zero at this stage in the function.
103             uint256 twos = denominator & (~denominator + 1);
104             assembly {
105                 // Divide denominator by twos.
106                 denominator := div(denominator, twos)
107 
108                 // Divide [prod1 prod0] by twos.
109                 prod0 := div(prod0, twos)
110 
111                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
112                 twos := add(div(sub(0, twos), twos), 1)
113             }
114 
115             // Shift in bits from prod1 into prod0.
116             prod0 |= prod1 * twos;
117 
118             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
119             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
120             // four bits. That is, denominator * inv = 1 mod 2^4.
121             uint256 inverse = (3 * denominator) ^ 2;
122 
123             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
124             // in modular arithmetic, doubling the correct bits in each step.
125             inverse *= 2 - denominator * inverse; // inverse mod 2^8
126             inverse *= 2 - denominator * inverse; // inverse mod 2^16
127             inverse *= 2 - denominator * inverse; // inverse mod 2^32
128             inverse *= 2 - denominator * inverse; // inverse mod 2^64
129             inverse *= 2 - denominator * inverse; // inverse mod 2^128
130             inverse *= 2 - denominator * inverse; // inverse mod 2^256
131 
132             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
133             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
134             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
135             // is no longer required.
136             result = prod0 * inverse;
137             return result;
138         }
139     }
140 
141     /**
142      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
143      */
144     function mulDiv(
145         uint256 x,
146         uint256 y,
147         uint256 denominator,
148         Rounding rounding
149     ) internal pure returns (uint256) {
150         uint256 result = mulDiv(x, y, denominator);
151         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
152             result += 1;
153         }
154         return result;
155     }
156 
157     /**
158      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
159      *
160      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
161      */
162     function sqrt(uint256 a) internal pure returns (uint256) {
163         if (a == 0) {
164             return 0;
165         }
166 
167         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
168         //
169         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
170         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
171         //
172         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
173         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
174         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
175         //
176         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
177         uint256 result = 1 << (log2(a) >> 1);
178 
179         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
180         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
181         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
182         // into the expected uint128 result.
183         unchecked {
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             result = (result + a / result) >> 1;
189             result = (result + a / result) >> 1;
190             result = (result + a / result) >> 1;
191             return min(result, a / result);
192         }
193     }
194 
195     /**
196      * @notice Calculates sqrt(a), following the selected rounding direction.
197      */
198     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
199         unchecked {
200             uint256 result = sqrt(a);
201             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
202         }
203     }
204 
205     /**
206      * @dev Return the log in base 2, rounded down, of a positive value.
207      * Returns 0 if given 0.
208      */
209     function log2(uint256 value) internal pure returns (uint256) {
210         uint256 result = 0;
211         unchecked {
212             if (value >> 128 > 0) {
213                 value >>= 128;
214                 result += 128;
215             }
216             if (value >> 64 > 0) {
217                 value >>= 64;
218                 result += 64;
219             }
220             if (value >> 32 > 0) {
221                 value >>= 32;
222                 result += 32;
223             }
224             if (value >> 16 > 0) {
225                 value >>= 16;
226                 result += 16;
227             }
228             if (value >> 8 > 0) {
229                 value >>= 8;
230                 result += 8;
231             }
232             if (value >> 4 > 0) {
233                 value >>= 4;
234                 result += 4;
235             }
236             if (value >> 2 > 0) {
237                 value >>= 2;
238                 result += 2;
239             }
240             if (value >> 1 > 0) {
241                 result += 1;
242             }
243         }
244         return result;
245     }
246 
247     /**
248      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
249      * Returns 0 if given 0.
250      */
251     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
252         unchecked {
253             uint256 result = log2(value);
254             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
255         }
256     }
257 
258     /**
259      * @dev Return the log in base 10, rounded down, of a positive value.
260      * Returns 0 if given 0.
261      */
262     function log10(uint256 value) internal pure returns (uint256) {
263         uint256 result = 0;
264         unchecked {
265             if (value >= 10**64) {
266                 value /= 10**64;
267                 result += 64;
268             }
269             if (value >= 10**32) {
270                 value /= 10**32;
271                 result += 32;
272             }
273             if (value >= 10**16) {
274                 value /= 10**16;
275                 result += 16;
276             }
277             if (value >= 10**8) {
278                 value /= 10**8;
279                 result += 8;
280             }
281             if (value >= 10**4) {
282                 value /= 10**4;
283                 result += 4;
284             }
285             if (value >= 10**2) {
286                 value /= 10**2;
287                 result += 2;
288             }
289             if (value >= 10**1) {
290                 result += 1;
291             }
292         }
293         return result;
294     }
295 
296     /**
297      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
298      * Returns 0 if given 0.
299      */
300     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
301         unchecked {
302             uint256 result = log10(value);
303             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
304         }
305     }
306 
307     /**
308      * @dev Return the log in base 256, rounded down, of a positive value.
309      * Returns 0 if given 0.
310      *
311      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
312      */
313     function log256(uint256 value) internal pure returns (uint256) {
314         uint256 result = 0;
315         unchecked {
316             if (value >> 128 > 0) {
317                 value >>= 128;
318                 result += 16;
319             }
320             if (value >> 64 > 0) {
321                 value >>= 64;
322                 result += 8;
323             }
324             if (value >> 32 > 0) {
325                 value >>= 32;
326                 result += 4;
327             }
328             if (value >> 16 > 0) {
329                 value >>= 16;
330                 result += 2;
331             }
332             if (value >> 8 > 0) {
333                 result += 1;
334             }
335         }
336         return result;
337     }
338 
339     /**
340      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
341      * Returns 0 if given 0.
342      */
343     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
344         unchecked {
345             uint256 result = log256(value);
346             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
347         }
348     }
349 }
350 
351 // File: @openzeppelin/contracts/utils/Strings.sol
352 
353 
354 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
355 
356 pragma solidity ^0.8.0;
357 
358 
359 /**
360  * @dev String operations.
361  */
362 library Strings {
363     bytes16 private constant _SYMBOLS = "0123456789abcdef";
364     uint8 private constant _ADDRESS_LENGTH = 20;
365 
366     /**
367      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
368      */
369     function toString(uint256 value) internal pure returns (string memory) {
370         unchecked {
371             uint256 length = Math.log10(value) + 1;
372             string memory buffer = new string(length);
373             uint256 ptr;
374             /// @solidity memory-safe-assembly
375             assembly {
376                 ptr := add(buffer, add(32, length))
377             }
378             while (true) {
379                 ptr--;
380                 /// @solidity memory-safe-assembly
381                 assembly {
382                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
383                 }
384                 value /= 10;
385                 if (value == 0) break;
386             }
387             return buffer;
388         }
389     }
390 
391     /**
392      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
393      */
394     function toHexString(uint256 value) internal pure returns (string memory) {
395         unchecked {
396             return toHexString(value, Math.log256(value) + 1);
397         }
398     }
399 
400     /**
401      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
402      */
403     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
404         bytes memory buffer = new bytes(2 * length + 2);
405         buffer[0] = "0";
406         buffer[1] = "x";
407         for (uint256 i = 2 * length + 1; i > 1; --i) {
408             buffer[i] = _SYMBOLS[value & 0xf];
409             value >>= 4;
410         }
411         require(value == 0, "Strings: hex length insufficient");
412         return string(buffer);
413     }
414 
415     /**
416      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
417      */
418     function toHexString(address addr) internal pure returns (string memory) {
419         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
420     }
421 }
422 
423 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
424 
425 
426 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
427 
428 pragma solidity ^0.8.0;
429 
430 
431 /**
432  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
433  *
434  * These functions can be used to verify that a message was signed by the holder
435  * of the private keys of a given address.
436  */
437 library ECDSA {
438     enum RecoverError {
439         NoError,
440         InvalidSignature,
441         InvalidSignatureLength,
442         InvalidSignatureS,
443         InvalidSignatureV // Deprecated in v4.8
444     }
445 
446     function _throwError(RecoverError error) private pure {
447         if (error == RecoverError.NoError) {
448             return; // no error: do nothing
449         } else if (error == RecoverError.InvalidSignature) {
450             revert("ECDSA: invalid signature");
451         } else if (error == RecoverError.InvalidSignatureLength) {
452             revert("ECDSA: invalid signature length");
453         } else if (error == RecoverError.InvalidSignatureS) {
454             revert("ECDSA: invalid signature 's' value");
455         }
456     }
457 
458     /**
459      * @dev Returns the address that signed a hashed message (`hash`) with
460      * `signature` or error string. This address can then be used for verification purposes.
461      *
462      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
463      * this function rejects them by requiring the `s` value to be in the lower
464      * half order, and the `v` value to be either 27 or 28.
465      *
466      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
467      * verification to be secure: it is possible to craft signatures that
468      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
469      * this is by receiving a hash of the original message (which may otherwise
470      * be too long), and then calling {toEthSignedMessageHash} on it.
471      *
472      * Documentation for signature generation:
473      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
474      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
475      *
476      * _Available since v4.3._
477      */
478     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
479         if (signature.length == 65) {
480             bytes32 r;
481             bytes32 s;
482             uint8 v;
483             // ecrecover takes the signature parameters, and the only way to get them
484             // currently is to use assembly.
485             /// @solidity memory-safe-assembly
486             assembly {
487                 r := mload(add(signature, 0x20))
488                 s := mload(add(signature, 0x40))
489                 v := byte(0, mload(add(signature, 0x60)))
490             }
491             return tryRecover(hash, v, r, s);
492         } else {
493             return (address(0), RecoverError.InvalidSignatureLength);
494         }
495     }
496 
497     /**
498      * @dev Returns the address that signed a hashed message (`hash`) with
499      * `signature`. This address can then be used for verification purposes.
500      *
501      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
502      * this function rejects them by requiring the `s` value to be in the lower
503      * half order, and the `v` value to be either 27 or 28.
504      *
505      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
506      * verification to be secure: it is possible to craft signatures that
507      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
508      * this is by receiving a hash of the original message (which may otherwise
509      * be too long), and then calling {toEthSignedMessageHash} on it.
510      */
511     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
512         (address recovered, RecoverError error) = tryRecover(hash, signature);
513         _throwError(error);
514         return recovered;
515     }
516 
517     /**
518      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
519      *
520      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
521      *
522      * _Available since v4.3._
523      */
524     function tryRecover(
525         bytes32 hash,
526         bytes32 r,
527         bytes32 vs
528     ) internal pure returns (address, RecoverError) {
529         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
530         uint8 v = uint8((uint256(vs) >> 255) + 27);
531         return tryRecover(hash, v, r, s);
532     }
533 
534     /**
535      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
536      *
537      * _Available since v4.2._
538      */
539     function recover(
540         bytes32 hash,
541         bytes32 r,
542         bytes32 vs
543     ) internal pure returns (address) {
544         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
545         _throwError(error);
546         return recovered;
547     }
548 
549     /**
550      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
551      * `r` and `s` signature fields separately.
552      *
553      * _Available since v4.3._
554      */
555     function tryRecover(
556         bytes32 hash,
557         uint8 v,
558         bytes32 r,
559         bytes32 s
560     ) internal pure returns (address, RecoverError) {
561         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
562         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
563         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
564         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
565         //
566         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
567         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
568         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
569         // these malleable signatures as well.
570         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
571             return (address(0), RecoverError.InvalidSignatureS);
572         }
573 
574         // If the signature is valid (and not malleable), return the signer address
575         address signer = ecrecover(hash, v, r, s);
576         if (signer == address(0)) {
577             return (address(0), RecoverError.InvalidSignature);
578         }
579 
580         return (signer, RecoverError.NoError);
581     }
582 
583     /**
584      * @dev Overload of {ECDSA-recover} that receives the `v`,
585      * `r` and `s` signature fields separately.
586      */
587     function recover(
588         bytes32 hash,
589         uint8 v,
590         bytes32 r,
591         bytes32 s
592     ) internal pure returns (address) {
593         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
594         _throwError(error);
595         return recovered;
596     }
597 
598     /**
599      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
600      * produces hash corresponding to the one signed with the
601      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
602      * JSON-RPC method as part of EIP-191.
603      *
604      * See {recover}.
605      */
606     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
607         // 32 is the length in bytes of hash,
608         // enforced by the type signature above
609         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
610     }
611 
612     /**
613      * @dev Returns an Ethereum Signed Message, created from `s`. This
614      * produces hash corresponding to the one signed with the
615      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
616      * JSON-RPC method as part of EIP-191.
617      *
618      * See {recover}.
619      */
620     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
621         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
622     }
623 
624     /**
625      * @dev Returns an Ethereum Signed Typed Data, created from a
626      * `domainSeparator` and a `structHash`. This produces hash corresponding
627      * to the one signed with the
628      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
629      * JSON-RPC method as part of EIP-712.
630      *
631      * See {recover}.
632      */
633     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
634         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
635     }
636 }
637 
638 // File: @openzeppelin/contracts/utils/Context.sol
639 
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Provides information about the current execution context, including the
647  * sender of the transaction and its data. While these are generally available
648  * via msg.sender and msg.data, they should not be accessed in such a direct
649  * manner, since when dealing with meta-transactions the account sending and
650  * paying for execution may not be the actual sender (as far as an application
651  * is concerned).
652  *
653  * This contract is only required for intermediate, library-like contracts.
654  */
655 abstract contract Context {
656     function _msgSender() internal view virtual returns (address) {
657         return msg.sender;
658     }
659 
660     function _msgData() internal view virtual returns (bytes calldata) {
661         return msg.data;
662     }
663 }
664 
665 // File: @openzeppelin/contracts/access/Ownable.sol
666 
667 
668 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
669 
670 pragma solidity ^0.8.0;
671 
672 
673 /**
674  * @dev Contract module which provides a basic access control mechanism, where
675  * there is an account (an owner) that can be granted exclusive access to
676  * specific functions.
677  *
678  * By default, the owner account will be the one that deploys the contract. This
679  * can later be changed with {transferOwnership}.
680  *
681  * This module is used through inheritance. It will make available the modifier
682  * `onlyOwner`, which can be applied to your functions to restrict their use to
683  * the owner.
684  */
685 abstract contract Ownable is Context {
686     address private _owner;
687 
688     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
689 
690     /**
691      * @dev Initializes the contract setting the deployer as the initial owner.
692      */
693     constructor() {
694         _transferOwnership(_msgSender());
695     }
696 
697     /**
698      * @dev Throws if called by any account other than the owner.
699      */
700     modifier onlyOwner() {
701         _checkOwner();
702         _;
703     }
704 
705     /**
706      * @dev Returns the address of the current owner.
707      */
708     function owner() public view virtual returns (address) {
709         return _owner;
710     }
711 
712     /**
713      * @dev Throws if the sender is not the owner.
714      */
715     function _checkOwner() internal view virtual {
716         require(owner() == _msgSender(), "Ownable: caller is not the owner");
717     }
718 
719     /**
720      * @dev Leaves the contract without owner. It will not be possible to call
721      * `onlyOwner` functions anymore. Can only be called by the current owner.
722      *
723      * NOTE: Renouncing ownership will leave the contract without an owner,
724      * thereby removing any functionality that is only available to the owner.
725      */
726     function renounceOwnership() public virtual onlyOwner {
727         _transferOwnership(address(0));
728     }
729 
730     /**
731      * @dev Transfers ownership of the contract to a new account (`newOwner`).
732      * Can only be called by the current owner.
733      */
734     function transferOwnership(address newOwner) public virtual onlyOwner {
735         require(newOwner != address(0), "Ownable: new owner is the zero address");
736         _transferOwnership(newOwner);
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Internal function without access restriction.
742      */
743     function _transferOwnership(address newOwner) internal virtual {
744         address oldOwner = _owner;
745         _owner = newOwner;
746         emit OwnershipTransferred(oldOwner, newOwner);
747     }
748 }
749 
750 // File: @openzeppelin/contracts/security/Pausable.sol
751 
752 
753 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
754 
755 pragma solidity ^0.8.0;
756 
757 
758 /**
759  * @dev Contract module which allows children to implement an emergency stop
760  * mechanism that can be triggered by an authorized account.
761  *
762  * This module is used through inheritance. It will make available the
763  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
764  * the functions of your contract. Note that they will not be pausable by
765  * simply including this module, only once the modifiers are put in place.
766  */
767 abstract contract Pausable is Context {
768     /**
769      * @dev Emitted when the pause is triggered by `account`.
770      */
771     event Paused(address account);
772 
773     /**
774      * @dev Emitted when the pause is lifted by `account`.
775      */
776     event Unpaused(address account);
777 
778     bool private _paused;
779 
780     /**
781      * @dev Initializes the contract in unpaused state.
782      */
783     constructor() {
784         _paused = false;
785     }
786 
787     /**
788      * @dev Modifier to make a function callable only when the contract is not paused.
789      *
790      * Requirements:
791      *
792      * - The contract must not be paused.
793      */
794     modifier whenNotPaused() {
795         _requireNotPaused();
796         _;
797     }
798 
799     /**
800      * @dev Modifier to make a function callable only when the contract is paused.
801      *
802      * Requirements:
803      *
804      * - The contract must be paused.
805      */
806     modifier whenPaused() {
807         _requirePaused();
808         _;
809     }
810 
811     /**
812      * @dev Returns true if the contract is paused, and false otherwise.
813      */
814     function paused() public view virtual returns (bool) {
815         return _paused;
816     }
817 
818     /**
819      * @dev Throws if the contract is paused.
820      */
821     function _requireNotPaused() internal view virtual {
822         require(!paused(), "Pausable: paused");
823     }
824 
825     /**
826      * @dev Throws if the contract is not paused.
827      */
828     function _requirePaused() internal view virtual {
829         require(paused(), "Pausable: not paused");
830     }
831 
832     /**
833      * @dev Triggers stopped state.
834      *
835      * Requirements:
836      *
837      * - The contract must not be paused.
838      */
839     function _pause() internal virtual whenNotPaused {
840         _paused = true;
841         emit Paused(_msgSender());
842     }
843 
844     /**
845      * @dev Returns to normal state.
846      *
847      * Requirements:
848      *
849      * - The contract must be paused.
850      */
851     function _unpause() internal virtual whenPaused {
852         _paused = false;
853         emit Unpaused(_msgSender());
854     }
855 }
856 
857 // File: contracts/MMGAMERS.sol
858 
859 pragma solidity ^0.8.12;
860 
861 contract MMGAMERS is Ownable, Pausable {
862     address public signer;
863 
864     mapping(address => uint256) public deposits;
865     mapping(string => bool) public nonceUsed;
866 
867     event Deposit(uint256 value, address user);
868     event Withdraw(uint256 value, address user);
869 
870     constructor(address _signer) {
871         signer = _signer;
872     }
873 
874     receive() external payable {}
875 
876     function pause() public onlyOwner {
877         _pause();
878     }
879 
880     function unpause() public onlyOwner {
881         _unpause();
882     }
883 
884     function hashClaimTransaction(
885         uint256 amount,
886         address player,
887         string memory nonce
888     ) public pure returns (bytes32) {
889         bytes32 hash = keccak256(abi.encodePacked(amount, player, nonce));
890         return hash;
891     }
892 
893     function matchSigner(bytes32 hash, bytes memory signature)
894         public
895         view
896         returns (bool)
897     {
898         return signer == ECDSA.recover(hash, signature);
899     }
900 
901     function DepositFunds() public payable {
902         require(msg.value > 0, "Send valid eth amount!");
903         deposits[msg.sender] = msg.value;
904         emit Deposit(msg.value, msg.sender);
905     }
906 
907     function withdrawYourFund(
908         uint256 amount,
909         string memory nonce,
910         bytes calldata signature
911     ) public whenNotPaused {
912         require(
913             matchSigner(
914                 hashClaimTransaction(amount, msg.sender, nonce),
915                 signature
916             ),
917             "Not allowed to withdraw"
918         );
919 
920         require(deposits[msg.sender] > 0, "You did not deposit anthing");
921         payable(msg.sender).transfer(amount);
922         emit Withdraw(amount, msg.sender);
923     }
924 
925     function updateSigner(address _signer) external onlyOwner {
926         signer = _signer;
927     }
928 
929     function withdraw() external onlyOwner {
930         uint256 balance = address(this).balance;
931         payable(owner()).transfer(balance);
932     }
933 }