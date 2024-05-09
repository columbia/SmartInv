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
636 // File: @openzeppelin/contracts/utils/Context.sol
637 
638 
639 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
640 
641 pragma solidity ^0.8.0;
642 
643 /**
644  * @dev Provides information about the current execution context, including the
645  * sender of the transaction and its data. While these are generally available
646  * via msg.sender and msg.data, they should not be accessed in such a direct
647  * manner, since when dealing with meta-transactions the account sending and
648  * paying for execution may not be the actual sender (as far as an application
649  * is concerned).
650  *
651  * This contract is only required for intermediate, library-like contracts.
652  */
653 abstract contract Context {
654     function _msgSender() internal view virtual returns (address) {
655         return msg.sender;
656     }
657 
658     function _msgData() internal view virtual returns (bytes calldata) {
659         return msg.data;
660     }
661 }
662 
663 // File: @openzeppelin/contracts/security/Pausable.sol
664 
665 
666 // OpenZeppelin Contracts (last updated v4.7.0) (security/Pausable.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 
671 /**
672  * @dev Contract module which allows children to implement an emergency stop
673  * mechanism that can be triggered by an authorized account.
674  *
675  * This module is used through inheritance. It will make available the
676  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
677  * the functions of your contract. Note that they will not be pausable by
678  * simply including this module, only once the modifiers are put in place.
679  */
680 abstract contract Pausable is Context {
681     /**
682      * @dev Emitted when the pause is triggered by `account`.
683      */
684     event Paused(address account);
685 
686     /**
687      * @dev Emitted when the pause is lifted by `account`.
688      */
689     event Unpaused(address account);
690 
691     bool private _paused;
692 
693     /**
694      * @dev Initializes the contract in unpaused state.
695      */
696     constructor() {
697         _paused = false;
698     }
699 
700     /**
701      * @dev Modifier to make a function callable only when the contract is not paused.
702      *
703      * Requirements:
704      *
705      * - The contract must not be paused.
706      */
707     modifier whenNotPaused() {
708         _requireNotPaused();
709         _;
710     }
711 
712     /**
713      * @dev Modifier to make a function callable only when the contract is paused.
714      *
715      * Requirements:
716      *
717      * - The contract must be paused.
718      */
719     modifier whenPaused() {
720         _requirePaused();
721         _;
722     }
723 
724     /**
725      * @dev Returns true if the contract is paused, and false otherwise.
726      */
727     function paused() public view virtual returns (bool) {
728         return _paused;
729     }
730 
731     /**
732      * @dev Throws if the contract is paused.
733      */
734     function _requireNotPaused() internal view virtual {
735         require(!paused(), "Pausable: paused");
736     }
737 
738     /**
739      * @dev Throws if the contract is not paused.
740      */
741     function _requirePaused() internal view virtual {
742         require(paused(), "Pausable: not paused");
743     }
744 
745     /**
746      * @dev Triggers stopped state.
747      *
748      * Requirements:
749      *
750      * - The contract must not be paused.
751      */
752     function _pause() internal virtual whenNotPaused {
753         _paused = true;
754         emit Paused(_msgSender());
755     }
756 
757     /**
758      * @dev Returns to normal state.
759      *
760      * Requirements:
761      *
762      * - The contract must be paused.
763      */
764     function _unpause() internal virtual whenPaused {
765         _paused = false;
766         emit Unpaused(_msgSender());
767     }
768 }
769 
770 // File: @openzeppelin/contracts/access/Ownable.sol
771 
772 
773 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
774 
775 pragma solidity ^0.8.0;
776 
777 
778 /**
779  * @dev Contract module which provides a basic access control mechanism, where
780  * there is an account (an owner) that can be granted exclusive access to
781  * specific functions.
782  *
783  * By default, the owner account will be the one that deploys the contract. This
784  * can later be changed with {transferOwnership}.
785  *
786  * This module is used through inheritance. It will make available the modifier
787  * `onlyOwner`, which can be applied to your functions to restrict their use to
788  * the owner.
789  */
790 abstract contract Ownable is Context {
791     address private _owner;
792 
793     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
794 
795     /**
796      * @dev Initializes the contract setting the deployer as the initial owner.
797      */
798     constructor() {
799         _transferOwnership(_msgSender());
800     }
801 
802     /**
803      * @dev Throws if called by any account other than the owner.
804      */
805     modifier onlyOwner() {
806         _checkOwner();
807         _;
808     }
809 
810     /**
811      * @dev Returns the address of the current owner.
812      */
813     function owner() public view virtual returns (address) {
814         return _owner;
815     }
816 
817     /**
818      * @dev Throws if the sender is not the owner.
819      */
820     function _checkOwner() internal view virtual {
821         require(owner() == _msgSender(), "Ownable: caller is not the owner");
822     }
823 
824     /**
825      * @dev Leaves the contract without owner. It will not be possible to call
826      * `onlyOwner` functions anymore. Can only be called by the current owner.
827      *
828      * NOTE: Renouncing ownership will leave the contract without an owner,
829      * thereby removing any functionality that is only available to the owner.
830      */
831     function renounceOwnership() public virtual onlyOwner {
832         _transferOwnership(address(0));
833     }
834 
835     /**
836      * @dev Transfers ownership of the contract to a new account (`newOwner`).
837      * Can only be called by the current owner.
838      */
839     function transferOwnership(address newOwner) public virtual onlyOwner {
840         require(newOwner != address(0), "Ownable: new owner is the zero address");
841         _transferOwnership(newOwner);
842     }
843 
844     /**
845      * @dev Transfers ownership of the contract to a new account (`newOwner`).
846      * Internal function without access restriction.
847      */
848     function _transferOwnership(address newOwner) internal virtual {
849         address oldOwner = _owner;
850         _owner = newOwner;
851         emit OwnershipTransferred(oldOwner, newOwner);
852     }
853 }
854 
855 // File: contracts/Variables.sol
856 
857 
858 pragma solidity ^0.8.9;
859 
860 
861 contract Variables is Ownable{
862 
863 //SET Variables
864     bool public customPrice = false;
865     uint256 public custom_price = 0.0011 ether;
866     bool public canRenounceOwnership = false;
867 
868 //mint variables
869     bool public soldOut = false;
870     bool public freeClaimOpen = false;
871 
872     bool public burnMomomCommomOpen = false;
873     bool public burnMomomUncommomOpen = false;
874     bool public burnMomomRareOpen = false;
875     bool public burnMomomEpicOpen = false;
876 
877     bool public mintOpen = false;
878     bool public rewardAllMomomsOpen = false;
879     uint256 public maxQtyRewardAllMomom = 2;
880     uint256 public qtyRewardedAllMomom = 0;
881     uint256 public qtyMinBonusMint1 = 5;
882     uint256 public qtyBonusMint1 = 1;
883     uint256 public qtyMinBonusMint2 = 10;
884     uint256 public qtyBonusMint2 = 2;
885     bool public enableTsukiPrice = false;
886     uint256 public custom_price_tsuki = 0.0009 ether;
887     string public baseTokenURI;
888 
889     //Set methods
890     function setCustomPriceTsuki(bool enable, uint256 value) public onlyOwner {
891         enableTsukiPrice = enable;
892         custom_price_tsuki = value;
893     }
894 
895     function setBonusMint1(uint256 qtyMinBonusMint, uint qtyBonusMint) public onlyOwner {
896         qtyMinBonusMint1 = qtyMinBonusMint;
897         qtyBonusMint1 = qtyBonusMint;
898     }
899 
900     function setBonusMint2(uint256 qtyMinBonusMint, uint qtyBonusMint) public onlyOwner {
901         qtyMinBonusMint2 = qtyMinBonusMint;
902         qtyBonusMint2 = qtyBonusMint;
903     }
904 
905     function setBurnMomomCommomOpen(bool _state) public onlyOwner {
906         burnMomomCommomOpen = _state;
907     }
908 
909     function setBurnMomomUncommomOpen(bool _state) public onlyOwner {
910         burnMomomUncommomOpen = _state;
911     }
912 
913     function setBurnMomomRareOpen(bool _state) public onlyOwner {
914         burnMomomRareOpen = _state;
915     }
916 
917     function setBurnMomomEpicOpen(bool _state) public onlyOwner {
918         burnMomomEpicOpen = _state;
919     }
920 
921     function setMintOpen(bool _state) public onlyOwner {
922         mintOpen = _state;
923     }
924 
925     function setRewardAllMomomsOpen(bool _state) public onlyOwner {
926         rewardAllMomomsOpen = _state;
927     }
928 
929     function setFreeClaimOpen(bool _state) public onlyOwner {
930         freeClaimOpen = _state;
931     }  
932 
933     function setSoldOut(bool _state) public onlyOwner {
934         soldOut = _state;
935     }
936 
937     function setMaxQtyRewardAllMomom(uint256 maxQtyReward) external onlyOwner {
938         maxQtyRewardAllMomom = maxQtyReward;
939     }
940 
941     function setCustomPrice(bool isCustomPrice, uint256 price) external onlyOwner {
942         customPrice = isCustomPrice;
943         custom_price = price;
944     }
945 
946     function setCanRenounceOwnership(bool _state) external  onlyOwner {
947         canRenounceOwnership = _state;
948     }
949 
950 }
951 // File: contracts/BurnTsuki.sol
952 
953 
954 pragma solidity ^0.8.7;
955 
956 
957 interface IERC721{
958     function ownerOf(uint256 _tokenId) external view returns (address);
959     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
960     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
961     function setApprovalForAll(address _from, bool state) external;
962     function burn(uint256) external payable;
963     function getApproved(uint256 tokenId) external view returns (address operator);
964     function isApprovedForAll(address owner, address operator) external view returns (bool);
965     function balanceOf(address owner) external view returns (uint256);
966 }
967 
968 
969 contract BurnTsuki is Ownable {
970 //for burn
971     address public tsukiNftAddress=0x0000000000000000000000000000000000000000;
972     address public tsukiBurnAddress=0x0000000000000000000000000000000000000001;
973 
974     bool public burnTsuki1Open = false;
975     bool public burnTsuki2Open = false;
976     bool public burnTsuki3Open = false;
977     bool public burnTsuki4Open = false;
978     bool public burnTsuki5Open = false;
979 
980 constructor() {}
981 
982     //Set methods
983     function setTsukiNftAddress(address _address) public onlyOwner {
984         tsukiNftAddress = _address;
985     }
986         
987     function setTsukiBurnAddress(address _address) public onlyOwner {
988         tsukiBurnAddress = _address;
989     }
990     
991     function setTsuki1Open(bool _state) public onlyOwner {
992         burnTsuki1Open = _state;
993     }
994 
995     function setTsuki2Open(bool _state) public onlyOwner {
996         burnTsuki2Open = _state;
997     }
998 
999     function setTsuki3Open(bool _state) public onlyOwner {
1000         burnTsuki3Open = _state;
1001     }
1002 
1003     function setTsuki4Open(bool _state) public onlyOwner {
1004         burnTsuki4Open = _state;
1005     }
1006 
1007     function setTsuki5Open(bool _state) public onlyOwner {
1008         burnTsuki5Open = _state;
1009     }
1010 
1011     modifier callerIsUser() {
1012         require(tx.origin == msg.sender, "Must from real wallet address");
1013         _;
1014     }
1015 
1016     function getOwner(uint256 tsukiTokenId) public view returns (address){
1017          return IERC721(tsukiNftAddress).ownerOf(tsukiTokenId);
1018     }
1019 
1020     function getBalaceOfTsuki() public view returns (uint256){
1021          return IERC721(tsukiNftAddress).balanceOf(msg.sender);
1022     }
1023 
1024     function bT(uint256[] memory tsukiTokenIds)
1025         public
1026         callerIsUser
1027     {
1028         if(tsukiTokenIds.length==1){
1029             require(burnTsuki1Open,"Burn 1 tsuki is not opened!");
1030         }else if(tsukiTokenIds.length==2){
1031             require(burnTsuki1Open,"Burn 2 tsuki is not opened!");
1032         }else if(tsukiTokenIds.length==3){
1033             require(burnTsuki1Open,"Burn 3 tsuki is not opened!");
1034         }else if(tsukiTokenIds.length==4){
1035             require(burnTsuki1Open,"Burn 4 tsuki is not opened!");
1036         }else if(tsukiTokenIds.length==5){
1037             require(burnTsuki1Open,"Burn 5 tsuki is not opened!");
1038         }else{
1039             require(false,"Burn Quant wrong!");
1040         }
1041         
1042         for (uint i = 0; i < tsukiTokenIds.length; i++) {
1043             address owner = IERC721(tsukiNftAddress).ownerOf(tsukiTokenIds[i]);
1044             require(msg.sender == owner, "Error: Not ERC721 owner");
1045             IERC721(tsukiNftAddress).transferFrom(msg.sender,tsukiBurnAddress,tsukiTokenIds[i]);
1046         }
1047     }
1048 
1049     function getBurnAddress() public view returns (address){
1050         return address(this);
1051     }
1052 
1053     function isApprovedForAllBurn(address owner, address operator) external view returns (bool){
1054         return IERC721(tsukiNftAddress).isApprovedForAll(owner, operator);
1055     }
1056 }
1057 // File: contracts/CommitReveal.sol
1058 
1059 
1060 pragma solidity ^0.8.9;
1061 
1062 
1063 contract CommitReveal is Ownable {
1064 
1065   uint public maxBlocksAhead = 250;
1066 
1067   //setter
1068     function setMaxBlocksAhead(uint qtd) public onlyOwner {
1069         maxBlocksAhead = qtd;
1070     }
1071 
1072   struct Commit {
1073     bytes32 commit;
1074     uint256 block;
1075     bool revealed;
1076   }
1077 
1078   mapping (address => Commit) public commits;
1079 
1080   function saveGeneratedHash(bytes32 dataHash) public {
1081     commits[msg.sender].commit = dataHash;
1082     commits[msg.sender].block = uint256(block.number);
1083     commits[msg.sender].revealed = false;
1084     emit CommitHash(msg.sender,commits[msg.sender].commit,commits[msg.sender].block);
1085   }
1086   event CommitHash(address sender, bytes32 dataHash, uint256 block);
1087 
1088   function generateRandom(bytes32 revealHash) public returns (uint){
1089     //make sure it hasn't been revealeld yet and set it to revealed
1090     require(commits[msg.sender].revealed==false,"Already revealed");
1091     commits[msg.sender].revealed=true;
1092     //require that they can produce the committed hash
1093     require(getHash(revealHash)==commits[msg.sender].commit,"Revealed hash does not match commit");
1094     //require that the block number is greater than the original block
1095     require(uint64(block.number)>commits[msg.sender].block,"Reveal and commit happened on the same block");
1096     //require that no more than 250 blocks have passed
1097     require(uint64(block.number)<=commits[msg.sender].block+maxBlocksAhead,"Revealed too late");
1098     //get the hash of the block that happened after they committed
1099     bytes32 blockHash = blockhash(commits[msg.sender].block);
1100     //hash that with their reveal that so miner shouldn't know and mod it with some max number you want
1101     uint random = uint(keccak256(abi.encodePacked(blockHash,revealHash)));
1102     /*emit RevealHash(msg.sender,revealHash,random);*/
1103     return random;
1104   }
1105 
1106   function blockNumber() public view returns (uint256){
1107     return uint256(block.number);
1108   }
1109 
1110   function getHash(bytes32 data) public view returns(bytes32){
1111     return keccak256(abi.encodePacked(address(this), data));
1112   }
1113 
1114 }
1115 // File: contracts/Random.sol
1116 
1117 
1118 pragma solidity ^0.8.9;
1119 
1120 
1121 
1122 contract Random is Ownable, CommitReveal {
1123 
1124         // Initializing the state variable
1125     uint randNonce = 0;
1126 
1127     //setvariables
1128     uint public lowerLegendary = 9900;
1129     uint public upperLegendary = 9910;
1130 
1131     uint public lowerEpic = 8000;
1132     uint public upperEpic = 8200;
1133 
1134     uint public lowerRare = 6000;
1135     uint public upperRare = 6800;
1136 
1137     uint public lowerUncommom = 3000;
1138     uint public upperUncommom = 5500;
1139 
1140     uint public qtdCommom = 60;
1141     uint public qtdUncommom = 30;
1142     uint public qtdRare = 15;
1143     uint public qtdEpic = 5;
1144     uint public qtdLegendary = 1;
1145 
1146 //setter
1147     function setQtdCommom(uint qtd) public onlyOwner {
1148         qtdCommom = qtd;
1149     }
1150     function setQtdUncommom(uint qtd) public onlyOwner {
1151         qtdUncommom = qtd;
1152     }
1153     function setQtdRare(uint qtd) public onlyOwner {
1154         qtdRare = qtd;
1155     }
1156     function setQtdEpic(uint qtd) public onlyOwner {
1157         qtdEpic = qtd;
1158     }
1159     function setQtdLegendary(uint qtd) public onlyOwner {
1160         qtdLegendary = qtd;
1161     }
1162 
1163     function setProbLegendary(uint lower, uint upper) public onlyOwner {
1164         upperLegendary = upper;
1165         lowerLegendary = lower;
1166     }
1167 
1168     function setProbEpic(uint lower, uint upper) public onlyOwner {
1169         upperEpic = upper;
1170         lowerEpic = lower;
1171     }
1172 
1173     function setProbRare(uint lower, uint upper) public onlyOwner {
1174         upperRare = upper;
1175         lowerRare = lower;
1176     }
1177 
1178     function setProbUncommom(uint lower, uint upper) public onlyOwner {
1179         upperUncommom = upper;
1180         lowerUncommom = lower;
1181     }
1182 
1183     function validateCommom(uint256[] memory tsukiTokenIds) public view returns (bool) {
1184         for (uint256 i = 0; i < tsukiTokenIds.length; i++) {
1185             if(100>tsukiTokenIds[i] || tsukiTokenIds[i]>=(100+qtdCommom)){
1186                 return false;
1187             }
1188         }
1189         return true;
1190     }
1191 
1192     function validateUncommom(uint256[] memory tsukiTokenIds) public view returns (bool) {
1193         for (uint256 i = 0; i < tsukiTokenIds.length; i++) {
1194             if(300>tsukiTokenIds[i] || tsukiTokenIds[i]>=(300+qtdUncommom)){
1195                 return false;
1196             }
1197         }
1198         return true;
1199     }
1200 
1201     function validateRare(uint256[] memory tsukiTokenIds) public view returns (bool) {
1202         for (uint256 i = 0; i < tsukiTokenIds.length; i++) {
1203             if(400>tsukiTokenIds[i] || tsukiTokenIds[i]>=(400+qtdRare)){
1204                 return false;
1205             }
1206         }
1207         return true;
1208     }
1209 
1210     function validateEpic(uint256[] memory tsukiTokenIds) public view returns (bool) {
1211         for (uint256 i = 0; i < tsukiTokenIds.length; i++) {
1212             if(500>tsukiTokenIds[i] || tsukiTokenIds[i]>=(500+qtdEpic)){
1213                 return false;
1214             }
1215         }
1216         return true;
1217     }
1218 
1219     function getAllMomoms() public view returns (uint[] memory) {
1220         uint[] memory momoms = new uint[](qtdCommom + qtdUncommom + qtdRare + qtdEpic + qtdLegendary);
1221         uint256 pos = 0;
1222         for (uint256 i = 0; i < qtdCommom; i++) {
1223             momoms[pos] = 100+i;
1224             pos++; 
1225         }
1226          for (uint256 i = 0; i < qtdUncommom; i++) {
1227             momoms[pos] = 300+i;
1228             pos++; 
1229         }
1230          for (uint256 i = 0; i < qtdRare; i++) {
1231             momoms[pos] = 400+i;
1232             pos++; 
1233         }
1234          for (uint256 i = 0; i < qtdEpic; i++) {
1235             momoms[pos] = 500+i;
1236             pos++; 
1237         }
1238          for (uint256 i = 0; i < qtdLegendary; i++) {
1239             momoms[pos] = 600+i;
1240             pos++; 
1241         }
1242         return momoms;
1243     }
1244 
1245     function probLegerndary() public view returns (uint) {
1246         return (upperLegendary - lowerLegendary);
1247     }
1248 
1249     function probEpic() public view returns (uint) {
1250         return (upperEpic - lowerEpic);
1251     }
1252 
1253     function probRare() public view returns (uint) {
1254         return (upperRare - lowerRare);
1255     }
1256 
1257     function probUncommom() public view returns (uint) {
1258         return (upperUncommom - lowerUncommom);
1259     }
1260 
1261     function probCommom() public view returns (uint) {
1262         return (10000 - probUncommom() - probRare() - probEpic() - probLegerndary());
1263     }
1264 
1265      // 1. Generate preimage off-chain and hash preimage
1266     function hashPreimage(bytes32 _preimage) public pure returns(bytes32) {
1267         return keccak256(abi.encodePacked(_preimage));
1268     }
1269 
1270     function random(bytes32 dataHash) public returns (uint) {
1271         return generateRandom(dataHash);
1272         /*randNonce++;
1273         return uint(keccak256(abi.encodePacked(block.timestamp,msg.sender,randNonce)));*/
1274     } 
1275 
1276     function randomPart(uint _random, uint _multiply) public pure returns (uint) {
1277         uint ret = _random/_multiply;
1278         return  ret % 10000;
1279     } 
1280 
1281     function getCard(uint number) public view returns (uint){
1282         uint rarity = number % 10000;
1283         if(lowerLegendary<rarity && rarity<=upperLegendary){
1284             //legendary 0,1%
1285             return (number%qtdLegendary)+600;
1286         }else
1287         if(lowerEpic<rarity && rarity<=upperEpic){
1288            //epic 2%
1289             return (number%qtdEpic)+500;
1290         }else
1291         if(lowerRare<rarity && rarity<=upperRare){
1292             //rare 8%
1293             return (number%qtdRare)+400;
1294         }else
1295         if(lowerUncommom<rarity && rarity<upperUncommom){
1296             //uncommom 25%
1297             return (number%qtdUncommom)+300;
1298         }else{
1299             //commom 64,5%
1300             return (number%qtdCommom)+100;
1301         }
1302     }
1303 
1304     function getCommom(uint number) public view returns (uint){
1305         return (number%qtdCommom)+100;
1306     }
1307 
1308     function getUncommom(uint number) public view returns (uint){
1309         return (number%qtdUncommom)+300;
1310     }
1311 
1312     function getRare(uint number) public view returns (uint){
1313         return (number%qtdRare)+400;
1314     }
1315 
1316     function getEpic(uint number) public view returns (uint){
1317         return (number%qtdEpic)+500;
1318     }
1319 
1320     function getLegendary(uint number) public view returns (uint){
1321         return (number%qtdLegendary)+600;
1322     }
1323 
1324 }
1325 // File: @openzeppelin/contracts/utils/Address.sol
1326 
1327 
1328 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
1329 
1330 pragma solidity ^0.8.1;
1331 
1332 /**
1333  * @dev Collection of functions related to the address type
1334  */
1335 library Address {
1336     /**
1337      * @dev Returns true if `account` is a contract.
1338      *
1339      * [IMPORTANT]
1340      * ====
1341      * It is unsafe to assume that an address for which this function returns
1342      * false is an externally-owned account (EOA) and not a contract.
1343      *
1344      * Among others, `isContract` will return false for the following
1345      * types of addresses:
1346      *
1347      *  - an externally-owned account
1348      *  - a contract in construction
1349      *  - an address where a contract will be created
1350      *  - an address where a contract lived, but was destroyed
1351      * ====
1352      *
1353      * [IMPORTANT]
1354      * ====
1355      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1356      *
1357      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1358      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1359      * constructor.
1360      * ====
1361      */
1362     function isContract(address account) internal view returns (bool) {
1363         // This method relies on extcodesize/address.code.length, which returns 0
1364         // for contracts in construction, since the code is only stored at the end
1365         // of the constructor execution.
1366 
1367         return account.code.length > 0;
1368     }
1369 
1370     /**
1371      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1372      * `recipient`, forwarding all available gas and reverting on errors.
1373      *
1374      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1375      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1376      * imposed by `transfer`, making them unable to receive funds via
1377      * `transfer`. {sendValue} removes this limitation.
1378      *
1379      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1380      *
1381      * IMPORTANT: because control is transferred to `recipient`, care must be
1382      * taken to not create reentrancy vulnerabilities. Consider using
1383      * {ReentrancyGuard} or the
1384      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1385      */
1386     function sendValue(address payable recipient, uint256 amount) internal {
1387         require(address(this).balance >= amount, "Address: insufficient balance");
1388 
1389         (bool success, ) = recipient.call{value: amount}("");
1390         require(success, "Address: unable to send value, recipient may have reverted");
1391     }
1392 
1393     /**
1394      * @dev Performs a Solidity function call using a low level `call`. A
1395      * plain `call` is an unsafe replacement for a function call: use this
1396      * function instead.
1397      *
1398      * If `target` reverts with a revert reason, it is bubbled up by this
1399      * function (like regular Solidity function calls).
1400      *
1401      * Returns the raw returned data. To convert to the expected return value,
1402      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1403      *
1404      * Requirements:
1405      *
1406      * - `target` must be a contract.
1407      * - calling `target` with `data` must not revert.
1408      *
1409      * _Available since v3.1._
1410      */
1411     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1412         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
1413     }
1414 
1415     /**
1416      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1417      * `errorMessage` as a fallback revert reason when `target` reverts.
1418      *
1419      * _Available since v3.1._
1420      */
1421     function functionCall(
1422         address target,
1423         bytes memory data,
1424         string memory errorMessage
1425     ) internal returns (bytes memory) {
1426         return functionCallWithValue(target, data, 0, errorMessage);
1427     }
1428 
1429     /**
1430      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1431      * but also transferring `value` wei to `target`.
1432      *
1433      * Requirements:
1434      *
1435      * - the calling contract must have an ETH balance of at least `value`.
1436      * - the called Solidity function must be `payable`.
1437      *
1438      * _Available since v3.1._
1439      */
1440     function functionCallWithValue(
1441         address target,
1442         bytes memory data,
1443         uint256 value
1444     ) internal returns (bytes memory) {
1445         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1446     }
1447 
1448     /**
1449      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1450      * with `errorMessage` as a fallback revert reason when `target` reverts.
1451      *
1452      * _Available since v3.1._
1453      */
1454     function functionCallWithValue(
1455         address target,
1456         bytes memory data,
1457         uint256 value,
1458         string memory errorMessage
1459     ) internal returns (bytes memory) {
1460         require(address(this).balance >= value, "Address: insufficient balance for call");
1461         (bool success, bytes memory returndata) = target.call{value: value}(data);
1462         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1463     }
1464 
1465     /**
1466      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1467      * but performing a static call.
1468      *
1469      * _Available since v3.3._
1470      */
1471     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1472         return functionStaticCall(target, data, "Address: low-level static call failed");
1473     }
1474 
1475     /**
1476      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1477      * but performing a static call.
1478      *
1479      * _Available since v3.3._
1480      */
1481     function functionStaticCall(
1482         address target,
1483         bytes memory data,
1484         string memory errorMessage
1485     ) internal view returns (bytes memory) {
1486         (bool success, bytes memory returndata) = target.staticcall(data);
1487         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1488     }
1489 
1490     /**
1491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1492      * but performing a delegate call.
1493      *
1494      * _Available since v3.4._
1495      */
1496     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1497         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1498     }
1499 
1500     /**
1501      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1502      * but performing a delegate call.
1503      *
1504      * _Available since v3.4._
1505      */
1506     function functionDelegateCall(
1507         address target,
1508         bytes memory data,
1509         string memory errorMessage
1510     ) internal returns (bytes memory) {
1511         (bool success, bytes memory returndata) = target.delegatecall(data);
1512         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1513     }
1514 
1515     /**
1516      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1517      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1518      *
1519      * _Available since v4.8._
1520      */
1521     function verifyCallResultFromTarget(
1522         address target,
1523         bool success,
1524         bytes memory returndata,
1525         string memory errorMessage
1526     ) internal view returns (bytes memory) {
1527         if (success) {
1528             if (returndata.length == 0) {
1529                 // only check isContract if the call was successful and the return data is empty
1530                 // otherwise we already know that it was a contract
1531                 require(isContract(target), "Address: call to non-contract");
1532             }
1533             return returndata;
1534         } else {
1535             _revert(returndata, errorMessage);
1536         }
1537     }
1538 
1539     /**
1540      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1541      * revert reason or using the provided one.
1542      *
1543      * _Available since v4.3._
1544      */
1545     function verifyCallResult(
1546         bool success,
1547         bytes memory returndata,
1548         string memory errorMessage
1549     ) internal pure returns (bytes memory) {
1550         if (success) {
1551             return returndata;
1552         } else {
1553             _revert(returndata, errorMessage);
1554         }
1555     }
1556 
1557     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1558         // Look for revert reason and bubble it up if present
1559         if (returndata.length > 0) {
1560             // The easiest way to bubble the revert reason is using memory via assembly
1561             /// @solidity memory-safe-assembly
1562             assembly {
1563                 let returndata_size := mload(returndata)
1564                 revert(add(32, returndata), returndata_size)
1565             }
1566         } else {
1567             revert(errorMessage);
1568         }
1569     }
1570 }
1571 
1572 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1573 
1574 
1575 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1576 
1577 pragma solidity ^0.8.0;
1578 
1579 /**
1580  * @dev Interface of the ERC165 standard, as defined in the
1581  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1582  *
1583  * Implementers can declare support of contract interfaces, which can then be
1584  * queried by others ({ERC165Checker}).
1585  *
1586  * For an implementation, see {ERC165}.
1587  */
1588 interface IERC165 {
1589     /**
1590      * @dev Returns true if this contract implements the interface defined by
1591      * `interfaceId`. See the corresponding
1592      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1593      * to learn more about how these ids are created.
1594      *
1595      * This function call must use less than 30 000 gas.
1596      */
1597     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1598 }
1599 
1600 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1601 
1602 
1603 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1604 
1605 pragma solidity ^0.8.0;
1606 
1607 
1608 /**
1609  * @dev Implementation of the {IERC165} interface.
1610  *
1611  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1612  * for the additional interface id that will be supported. For example:
1613  *
1614  * ```solidity
1615  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1616  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1617  * }
1618  * ```
1619  *
1620  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1621  */
1622 abstract contract ERC165 is IERC165 {
1623     /**
1624      * @dev See {IERC165-supportsInterface}.
1625      */
1626     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1627         return interfaceId == type(IERC165).interfaceId;
1628     }
1629 }
1630 
1631 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1632 
1633 
1634 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1635 
1636 pragma solidity ^0.8.0;
1637 
1638 
1639 /**
1640  * @dev _Available since v3.1._
1641  */
1642 interface IERC1155Receiver is IERC165 {
1643     /**
1644      * @dev Handles the receipt of a single ERC1155 token type. This function is
1645      * called at the end of a `safeTransferFrom` after the balance has been updated.
1646      *
1647      * NOTE: To accept the transfer, this must return
1648      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1649      * (i.e. 0xf23a6e61, or its own function selector).
1650      *
1651      * @param operator The address which initiated the transfer (i.e. msg.sender)
1652      * @param from The address which previously owned the token
1653      * @param id The ID of the token being transferred
1654      * @param value The amount of tokens being transferred
1655      * @param data Additional data with no specified format
1656      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1657      */
1658     function onERC1155Received(
1659         address operator,
1660         address from,
1661         uint256 id,
1662         uint256 value,
1663         bytes calldata data
1664     ) external returns (bytes4);
1665 
1666     /**
1667      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1668      * is called at the end of a `safeBatchTransferFrom` after the balances have
1669      * been updated.
1670      *
1671      * NOTE: To accept the transfer(s), this must return
1672      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1673      * (i.e. 0xbc197c81, or its own function selector).
1674      *
1675      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1676      * @param from The address which previously owned the token
1677      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1678      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1679      * @param data Additional data with no specified format
1680      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1681      */
1682     function onERC1155BatchReceived(
1683         address operator,
1684         address from,
1685         uint256[] calldata ids,
1686         uint256[] calldata values,
1687         bytes calldata data
1688     ) external returns (bytes4);
1689 }
1690 
1691 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1692 
1693 
1694 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1695 
1696 pragma solidity ^0.8.0;
1697 
1698 
1699 /**
1700  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1701  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1702  *
1703  * _Available since v3.1._
1704  */
1705 interface IERC1155 is IERC165 {
1706     /**
1707      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1708      */
1709     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1710 
1711     /**
1712      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1713      * transfers.
1714      */
1715     event TransferBatch(
1716         address indexed operator,
1717         address indexed from,
1718         address indexed to,
1719         uint256[] ids,
1720         uint256[] values
1721     );
1722 
1723     /**
1724      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1725      * `approved`.
1726      */
1727     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1728 
1729     /**
1730      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1731      *
1732      * If an {URI} event was emitted for `id`, the standard
1733      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1734      * returned by {IERC1155MetadataURI-uri}.
1735      */
1736     event URI(string value, uint256 indexed id);
1737 
1738     /**
1739      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1740      *
1741      * Requirements:
1742      *
1743      * - `account` cannot be the zero address.
1744      */
1745     function balanceOf(address account, uint256 id) external view returns (uint256);
1746 
1747     /**
1748      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1749      *
1750      * Requirements:
1751      *
1752      * - `accounts` and `ids` must have the same length.
1753      */
1754     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1755         external
1756         view
1757         returns (uint256[] memory);
1758 
1759     /**
1760      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1761      *
1762      * Emits an {ApprovalForAll} event.
1763      *
1764      * Requirements:
1765      *
1766      * - `operator` cannot be the caller.
1767      */
1768     function setApprovalForAll(address operator, bool approved) external;
1769 
1770     /**
1771      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1772      *
1773      * See {setApprovalForAll}.
1774      */
1775     function isApprovedForAll(address account, address operator) external view returns (bool);
1776 
1777     /**
1778      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1779      *
1780      * Emits a {TransferSingle} event.
1781      *
1782      * Requirements:
1783      *
1784      * - `to` cannot be the zero address.
1785      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1786      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1787      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1788      * acceptance magic value.
1789      */
1790     function safeTransferFrom(
1791         address from,
1792         address to,
1793         uint256 id,
1794         uint256 amount,
1795         bytes calldata data
1796     ) external;
1797 
1798     /**
1799      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1800      *
1801      * Emits a {TransferBatch} event.
1802      *
1803      * Requirements:
1804      *
1805      * - `ids` and `amounts` must have the same length.
1806      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1807      * acceptance magic value.
1808      */
1809     function safeBatchTransferFrom(
1810         address from,
1811         address to,
1812         uint256[] calldata ids,
1813         uint256[] calldata amounts,
1814         bytes calldata data
1815     ) external;
1816 }
1817 
1818 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1819 
1820 
1821 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1822 
1823 pragma solidity ^0.8.0;
1824 
1825 
1826 /**
1827  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1828  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1829  *
1830  * _Available since v3.1._
1831  */
1832 interface IERC1155MetadataURI is IERC1155 {
1833     /**
1834      * @dev Returns the URI for token type `id`.
1835      *
1836      * If the `\{id\}` substring is present in the URI, it must be replaced by
1837      * clients with the actual token type ID.
1838      */
1839     function uri(uint256 id) external view returns (string memory);
1840 }
1841 
1842 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1843 
1844 
1845 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
1846 
1847 pragma solidity ^0.8.0;
1848 
1849 
1850 
1851 
1852 
1853 
1854 
1855 /**
1856  * @dev Implementation of the basic standard multi-token.
1857  * See https://eips.ethereum.org/EIPS/eip-1155
1858  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1859  *
1860  * _Available since v3.1._
1861  */
1862 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1863     using Address for address;
1864 
1865     // Mapping from token ID to account balances
1866     mapping(uint256 => mapping(address => uint256)) private _balances;
1867 
1868     // Mapping from account to operator approvals
1869     mapping(address => mapping(address => bool)) private _operatorApprovals;
1870 
1871     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1872     string private _uri;
1873 
1874     /**
1875      * @dev See {_setURI}.
1876      */
1877     constructor(string memory uri_) {
1878         _setURI(uri_);
1879     }
1880 
1881     /**
1882      * @dev See {IERC165-supportsInterface}.
1883      */
1884     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1885         return
1886             interfaceId == type(IERC1155).interfaceId ||
1887             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1888             super.supportsInterface(interfaceId);
1889     }
1890 
1891     /**
1892      * @dev See {IERC1155MetadataURI-uri}.
1893      *
1894      * This implementation returns the same URI for *all* token types. It relies
1895      * on the token type ID substitution mechanism
1896      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1897      *
1898      * Clients calling this function must replace the `\{id\}` substring with the
1899      * actual token type ID.
1900      */
1901     function uri(uint256) public view virtual override returns (string memory) {
1902         return _uri;
1903     }
1904 
1905     /**
1906      * @dev See {IERC1155-balanceOf}.
1907      *
1908      * Requirements:
1909      *
1910      * - `account` cannot be the zero address.
1911      */
1912     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1913         require(account != address(0), "ERC1155: address zero is not a valid owner");
1914         return _balances[id][account];
1915     }
1916 
1917     /**
1918      * @dev See {IERC1155-balanceOfBatch}.
1919      *
1920      * Requirements:
1921      *
1922      * - `accounts` and `ids` must have the same length.
1923      */
1924     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1925         public
1926         view
1927         virtual
1928         override
1929         returns (uint256[] memory)
1930     {
1931         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1932 
1933         uint256[] memory batchBalances = new uint256[](accounts.length);
1934 
1935         for (uint256 i = 0; i < accounts.length; ++i) {
1936             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1937         }
1938 
1939         return batchBalances;
1940     }
1941 
1942     /**
1943      * @dev See {IERC1155-setApprovalForAll}.
1944      */
1945     function setApprovalForAll(address operator, bool approved) public virtual override {
1946         _setApprovalForAll(_msgSender(), operator, approved);
1947     }
1948 
1949     /**
1950      * @dev See {IERC1155-isApprovedForAll}.
1951      */
1952     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1953         return _operatorApprovals[account][operator];
1954     }
1955 
1956     /**
1957      * @dev See {IERC1155-safeTransferFrom}.
1958      */
1959     function safeTransferFrom(
1960         address from,
1961         address to,
1962         uint256 id,
1963         uint256 amount,
1964         bytes memory data
1965     ) public virtual override {
1966         require(
1967             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1968             "ERC1155: caller is not token owner or approved"
1969         );
1970         _safeTransferFrom(from, to, id, amount, data);
1971     }
1972 
1973     /**
1974      * @dev See {IERC1155-safeBatchTransferFrom}.
1975      */
1976     function safeBatchTransferFrom(
1977         address from,
1978         address to,
1979         uint256[] memory ids,
1980         uint256[] memory amounts,
1981         bytes memory data
1982     ) public virtual override {
1983         require(
1984             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1985             "ERC1155: caller is not token owner or approved"
1986         );
1987         _safeBatchTransferFrom(from, to, ids, amounts, data);
1988     }
1989 
1990     /**
1991      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1992      *
1993      * Emits a {TransferSingle} event.
1994      *
1995      * Requirements:
1996      *
1997      * - `to` cannot be the zero address.
1998      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1999      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2000      * acceptance magic value.
2001      */
2002     function _safeTransferFrom(
2003         address from,
2004         address to,
2005         uint256 id,
2006         uint256 amount,
2007         bytes memory data
2008     ) internal virtual {
2009         require(to != address(0), "ERC1155: transfer to the zero address");
2010 
2011         address operator = _msgSender();
2012         uint256[] memory ids = _asSingletonArray(id);
2013         uint256[] memory amounts = _asSingletonArray(amount);
2014 
2015         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2016 
2017         uint256 fromBalance = _balances[id][from];
2018         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
2019         unchecked {
2020             _balances[id][from] = fromBalance - amount;
2021         }
2022         _balances[id][to] += amount;
2023 
2024         emit TransferSingle(operator, from, to, id, amount);
2025 
2026         _afterTokenTransfer(operator, from, to, ids, amounts, data);
2027 
2028         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
2029     }
2030 
2031     /**
2032      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
2033      *
2034      * Emits a {TransferBatch} event.
2035      *
2036      * Requirements:
2037      *
2038      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2039      * acceptance magic value.
2040      */
2041     function _safeBatchTransferFrom(
2042         address from,
2043         address to,
2044         uint256[] memory ids,
2045         uint256[] memory amounts,
2046         bytes memory data
2047     ) internal virtual {
2048         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2049         require(to != address(0), "ERC1155: transfer to the zero address");
2050 
2051         address operator = _msgSender();
2052 
2053         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
2054 
2055         for (uint256 i = 0; i < ids.length; ++i) {
2056             uint256 id = ids[i];
2057             uint256 amount = amounts[i];
2058 
2059             uint256 fromBalance = _balances[id][from];
2060             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
2061             unchecked {
2062                 _balances[id][from] = fromBalance - amount;
2063             }
2064             _balances[id][to] += amount;
2065         }
2066 
2067         emit TransferBatch(operator, from, to, ids, amounts);
2068 
2069         _afterTokenTransfer(operator, from, to, ids, amounts, data);
2070 
2071         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
2072     }
2073 
2074     /**
2075      * @dev Sets a new URI for all token types, by relying on the token type ID
2076      * substitution mechanism
2077      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
2078      *
2079      * By this mechanism, any occurrence of the `\{id\}` substring in either the
2080      * URI or any of the amounts in the JSON file at said URI will be replaced by
2081      * clients with the token type ID.
2082      *
2083      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
2084      * interpreted by clients as
2085      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
2086      * for token type ID 0x4cce0.
2087      *
2088      * See {uri}.
2089      *
2090      * Because these URIs cannot be meaningfully represented by the {URI} event,
2091      * this function emits no events.
2092      */
2093     function _setURI(string memory newuri) internal virtual {
2094         _uri = newuri;
2095     }
2096 
2097     /**
2098      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
2099      *
2100      * Emits a {TransferSingle} event.
2101      *
2102      * Requirements:
2103      *
2104      * - `to` cannot be the zero address.
2105      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2106      * acceptance magic value.
2107      */
2108     function _mint(
2109         address to,
2110         uint256 id,
2111         uint256 amount,
2112         bytes memory data
2113     ) internal virtual {
2114         require(to != address(0), "ERC1155: mint to the zero address");
2115 
2116         address operator = _msgSender();
2117         uint256[] memory ids = _asSingletonArray(id);
2118         uint256[] memory amounts = _asSingletonArray(amount);
2119 
2120         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2121 
2122         _balances[id][to] += amount;
2123         emit TransferSingle(operator, address(0), to, id, amount);
2124 
2125         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2126 
2127         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
2128     }
2129 
2130     /**
2131      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
2132      *
2133      * Emits a {TransferBatch} event.
2134      *
2135      * Requirements:
2136      *
2137      * - `ids` and `amounts` must have the same length.
2138      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2139      * acceptance magic value.
2140      */
2141     function _mintBatch(
2142         address to,
2143         uint256[] memory ids,
2144         uint256[] memory amounts,
2145         bytes memory data
2146     ) internal virtual {
2147         require(to != address(0), "ERC1155: mint to the zero address");
2148         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2149 
2150         address operator = _msgSender();
2151 
2152         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
2153 
2154         for (uint256 i = 0; i < ids.length; i++) {
2155             _balances[ids[i]][to] += amounts[i];
2156         }
2157 
2158         emit TransferBatch(operator, address(0), to, ids, amounts);
2159 
2160         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
2161 
2162         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
2163     }
2164 
2165     /**
2166      * @dev Destroys `amount` tokens of token type `id` from `from`
2167      *
2168      * Emits a {TransferSingle} event.
2169      *
2170      * Requirements:
2171      *
2172      * - `from` cannot be the zero address.
2173      * - `from` must have at least `amount` tokens of token type `id`.
2174      */
2175     function _burn(
2176         address from,
2177         uint256 id,
2178         uint256 amount
2179     ) internal virtual {
2180         require(from != address(0), "ERC1155: burn from the zero address");
2181 
2182         address operator = _msgSender();
2183         uint256[] memory ids = _asSingletonArray(id);
2184         uint256[] memory amounts = _asSingletonArray(amount);
2185 
2186         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2187 
2188         uint256 fromBalance = _balances[id][from];
2189         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2190         unchecked {
2191             _balances[id][from] = fromBalance - amount;
2192         }
2193 
2194         emit TransferSingle(operator, from, address(0), id, amount);
2195 
2196         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2197     }
2198 
2199     /**
2200      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
2201      *
2202      * Emits a {TransferBatch} event.
2203      *
2204      * Requirements:
2205      *
2206      * - `ids` and `amounts` must have the same length.
2207      */
2208     function _burnBatch(
2209         address from,
2210         uint256[] memory ids,
2211         uint256[] memory amounts
2212     ) internal virtual {
2213         require(from != address(0), "ERC1155: burn from the zero address");
2214         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
2215 
2216         address operator = _msgSender();
2217 
2218         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
2219 
2220         for (uint256 i = 0; i < ids.length; i++) {
2221             uint256 id = ids[i];
2222             uint256 amount = amounts[i];
2223 
2224             uint256 fromBalance = _balances[id][from];
2225             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
2226             unchecked {
2227                 _balances[id][from] = fromBalance - amount;
2228             }
2229         }
2230 
2231         emit TransferBatch(operator, from, address(0), ids, amounts);
2232 
2233         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
2234     }
2235 
2236     /**
2237      * @dev Approve `operator` to operate on all of `owner` tokens
2238      *
2239      * Emits an {ApprovalForAll} event.
2240      */
2241     function _setApprovalForAll(
2242         address owner,
2243         address operator,
2244         bool approved
2245     ) internal virtual {
2246         require(owner != operator, "ERC1155: setting approval status for self");
2247         _operatorApprovals[owner][operator] = approved;
2248         emit ApprovalForAll(owner, operator, approved);
2249     }
2250 
2251     /**
2252      * @dev Hook that is called before any token transfer. This includes minting
2253      * and burning, as well as batched variants.
2254      *
2255      * The same hook is called on both single and batched variants. For single
2256      * transfers, the length of the `ids` and `amounts` arrays will be 1.
2257      *
2258      * Calling conditions (for each `id` and `amount` pair):
2259      *
2260      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2261      * of token type `id` will be  transferred to `to`.
2262      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2263      * for `to`.
2264      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2265      * will be burned.
2266      * - `from` and `to` are never both zero.
2267      * - `ids` and `amounts` have the same, non-zero length.
2268      *
2269      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2270      */
2271     function _beforeTokenTransfer(
2272         address operator,
2273         address from,
2274         address to,
2275         uint256[] memory ids,
2276         uint256[] memory amounts,
2277         bytes memory data
2278     ) internal virtual {}
2279 
2280     /**
2281      * @dev Hook that is called after any token transfer. This includes minting
2282      * and burning, as well as batched variants.
2283      *
2284      * The same hook is called on both single and batched variants. For single
2285      * transfers, the length of the `id` and `amount` arrays will be 1.
2286      *
2287      * Calling conditions (for each `id` and `amount` pair):
2288      *
2289      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
2290      * of token type `id` will be  transferred to `to`.
2291      * - When `from` is zero, `amount` tokens of token type `id` will be minted
2292      * for `to`.
2293      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
2294      * will be burned.
2295      * - `from` and `to` are never both zero.
2296      * - `ids` and `amounts` have the same, non-zero length.
2297      *
2298      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2299      */
2300     function _afterTokenTransfer(
2301         address operator,
2302         address from,
2303         address to,
2304         uint256[] memory ids,
2305         uint256[] memory amounts,
2306         bytes memory data
2307     ) internal virtual {}
2308 
2309     function _doSafeTransferAcceptanceCheck(
2310         address operator,
2311         address from,
2312         address to,
2313         uint256 id,
2314         uint256 amount,
2315         bytes memory data
2316     ) private {
2317         if (to.isContract()) {
2318             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
2319                 if (response != IERC1155Receiver.onERC1155Received.selector) {
2320                     revert("ERC1155: ERC1155Receiver rejected tokens");
2321                 }
2322             } catch Error(string memory reason) {
2323                 revert(reason);
2324             } catch {
2325                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2326             }
2327         }
2328     }
2329 
2330     function _doSafeBatchTransferAcceptanceCheck(
2331         address operator,
2332         address from,
2333         address to,
2334         uint256[] memory ids,
2335         uint256[] memory amounts,
2336         bytes memory data
2337     ) private {
2338         if (to.isContract()) {
2339             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
2340                 bytes4 response
2341             ) {
2342                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
2343                     revert("ERC1155: ERC1155Receiver rejected tokens");
2344                 }
2345             } catch Error(string memory reason) {
2346                 revert(reason);
2347             } catch {
2348                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
2349             }
2350         }
2351     }
2352 
2353     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
2354         uint256[] memory array = new uint256[](1);
2355         array[0] = element;
2356 
2357         return array;
2358     }
2359 }
2360 
2361 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol
2362 
2363 
2364 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC1155/extensions/ERC1155Supply.sol)
2365 
2366 pragma solidity ^0.8.0;
2367 
2368 
2369 /**
2370  * @dev Extension of ERC1155 that adds tracking of total supply per id.
2371  *
2372  * Useful for scenarios where Fungible and Non-fungible tokens have to be
2373  * clearly identified. Note: While a totalSupply of 1 might mean the
2374  * corresponding is an NFT, there is no guarantees that no other token with the
2375  * same id are not going to be minted.
2376  */
2377 abstract contract ERC1155Supply is ERC1155 {
2378     mapping(uint256 => uint256) private _totalSupply;
2379 
2380     /**
2381      * @dev Total amount of tokens in with a given id.
2382      */
2383     function totalSupply(uint256 id) public view virtual returns (uint256) {
2384         return _totalSupply[id];
2385     }
2386 
2387     /**
2388      * @dev Indicates whether any token exist with a given id, or not.
2389      */
2390     function exists(uint256 id) public view virtual returns (bool) {
2391         return ERC1155Supply.totalSupply(id) > 0;
2392     }
2393 
2394     /**
2395      * @dev See {ERC1155-_beforeTokenTransfer}.
2396      */
2397     function _beforeTokenTransfer(
2398         address operator,
2399         address from,
2400         address to,
2401         uint256[] memory ids,
2402         uint256[] memory amounts,
2403         bytes memory data
2404     ) internal virtual override {
2405         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2406 
2407         if (from == address(0)) {
2408             for (uint256 i = 0; i < ids.length; ++i) {
2409                 _totalSupply[ids[i]] += amounts[i];
2410             }
2411         }
2412 
2413         if (to == address(0)) {
2414             for (uint256 i = 0; i < ids.length; ++i) {
2415                 uint256 id = ids[i];
2416                 uint256 amount = amounts[i];
2417                 uint256 supply = _totalSupply[id];
2418                 require(supply >= amount, "ERC1155: burn amount exceeds totalSupply");
2419                 unchecked {
2420                     _totalSupply[id] = supply - amount;
2421                 }
2422             }
2423         }
2424     }
2425 }
2426 
2427 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
2428 
2429 
2430 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/extensions/ERC1155Burnable.sol)
2431 
2432 pragma solidity ^0.8.0;
2433 
2434 
2435 /**
2436  * @dev Extension of {ERC1155} that allows token holders to destroy both their
2437  * own tokens and those that they have been approved to use.
2438  *
2439  * _Available since v3.1._
2440  */
2441 abstract contract ERC1155Burnable is ERC1155 {
2442     function burn(
2443         address account,
2444         uint256 id,
2445         uint256 value
2446     ) public virtual {
2447         require(
2448             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2449             "ERC1155: caller is not token owner or approved"
2450         );
2451 
2452         _burn(account, id, value);
2453     }
2454 
2455     function burnBatch(
2456         address account,
2457         uint256[] memory ids,
2458         uint256[] memory values
2459     ) public virtual {
2460         require(
2461             account == _msgSender() || isApprovedForAll(account, _msgSender()),
2462             "ERC1155: caller is not token owner or approved"
2463         );
2464 
2465         _burnBatch(account, ids, values);
2466     }
2467 }
2468 
2469 // File: contracts/MOMOM.sol
2470 
2471 
2472 pragma solidity ^0.8.9;
2473 
2474 
2475 
2476 
2477 
2478 
2479 
2480 
2481 
2482 
2483 contract MOMOM is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply, Random, BurnTsuki, Variables {
2484 
2485     //FOR PRODUCTION
2486 
2487     uint256 public constant PUBLIC_SALES_PRICE = 0.003 ether;
2488     uint256 public constant MAX_QTY_PER_MINT = 12;
2489 
2490     mapping(uint256 => uint256) public tsukiClaimedMomom;
2491     mapping(address => uint256) public preSalesMinterToTokenQty;
2492 
2493     constructor() ERC1155("MOMOM") {}
2494 
2495     //Set methods
2496     function setPhaseTwoState(bool _state) public onlyOwner {
2497         burnMomomCommomOpen = _state;
2498         burnMomomUncommomOpen = _state;
2499         burnMomomRareOpen = _state;
2500         burnMomomEpicOpen = _state;
2501     }
2502 
2503     function setPhaseOneState(bool _state) public onlyOwner {
2504         freeClaimOpen = _state;
2505         burnTsuki1Open = _state;
2506         burnTsuki2Open = _state;
2507         burnTsuki3Open = _state;
2508         burnTsuki4Open = _state;
2509         burnTsuki5Open = _state;
2510     }
2511 
2512     function setURI(string memory newuri) public onlyOwner {
2513         baseTokenURI = newuri;
2514         _setURI(newuri);
2515     }
2516 
2517     function pause() public onlyOwner {
2518         _pause();
2519     }
2520 
2521     function unpause() public onlyOwner {
2522         _unpause();
2523     }
2524 
2525     //end of set methods
2526     function getTokensOwnedByAddress() public view returns (uint[] memory) {
2527         uint[] memory momoms = getAllMomoms();
2528         uint[] memory momomsOwned = new uint[](momoms.length);
2529         for (uint i = 0; i < momoms.length; i++) {
2530             momomsOwned[i] = balanceOf(msg.sender,momoms[i]);
2531         }
2532         return momomsOwned;
2533     }
2534 
2535     function testGetCards(uint256 _mintQty, bytes32 dataHash) external onlyOwner returns (uint[] memory) {
2536         uint[] memory cards = new uint[]((_mintQty)+1);
2537         uint randNumber = random(dataHash);
2538         for (uint i = 0; i < _mintQty; i++) {
2539             uint number = randomPart(randNumber, ((i==0)?1:(10000**i)));
2540             cards[i] = (number*100000)+getCard(number);
2541 
2542         }
2543         cards[_mintQty] = randNumber;
2544         return cards;
2545     }
2546 
2547     function mint(uint256 _mintQty, bytes32 dataHash)
2548         external
2549         payable
2550         returns (uint[] memory) 
2551     {
2552         require(mintOpen,"Mint is not opened!");
2553         require(tx.origin == msg.sender,"CONTRACTS_NOT_ALLOWED_TO_MINT");
2554         require(_mintQty<=MAX_QTY_PER_MINT,"Max mint per mint is 10.");
2555         require(msg.value >= _mintQty * getPrice(), "Incorrect ETH");
2556         uint randNumber = random(dataHash);
2557         uint bonusMintQty = bonusMint(_mintQty);
2558         uint[] memory cards = new uint[](_mintQty+bonusMintQty);
2559         for (uint i = 0; i < (_mintQty+ bonusMintQty); i++) {
2560             uint number = randomPart(randNumber, ((i==0)?1:(10000**i)));
2561             cards[i] = getCard(number);
2562            _mint(msg.sender, cards[i], 1, "");
2563         }
2564         return cards;
2565     }
2566 
2567     function bonusMint(uint256 _mintQty) public view returns (uint) {
2568         uint bonus = 0;
2569         if(_mintQty>=qtyMinBonusMint1){
2570             bonus = bonus+qtyBonusMint1;
2571         }
2572         if(_mintQty>=qtyMinBonusMint2){
2573             bonus = bonus+qtyBonusMint2;
2574         }
2575         return bonus;
2576     }
2577 
2578     function claimMomon(uint256 tsukiTokenId, bytes32 dataHash)
2579         external
2580         returns (uint) 
2581     {
2582         uint card;
2583         require(freeClaimOpen,"Free Claim is not opened!");
2584         require(tx.origin == msg.sender,"CONTRACTS_NOT_ALLOWED_TO_MINT");
2585         require(tsukiClaimedMomom[tsukiTokenId]==0,"Tsuki already claimed momom!");
2586         require(msg.sender == getOwner(tsukiTokenId), "Error: Not ERC721 owner");
2587 
2588         tsukiClaimedMomom[tsukiTokenId] += 1;
2589 
2590         uint randNumber = random(dataHash);
2591         card = getCommom(randNumber);
2592         _mint(msg.sender, card, 1, "");
2593         return card;
2594     }
2595 
2596    function burnTsukiGetMomom(uint256[] memory tsukiTokenIds, bytes32 dataHash)
2597         external
2598         returns (uint) 
2599     {
2600         uint card;
2601         uint randNumber = random(dataHash);
2602         bT(tsukiTokenIds);
2603         if(tsukiTokenIds.length == 1 ){
2604             card = getCommom(randNumber);
2605         }else if(tsukiTokenIds.length == 2 ){
2606             card = getUncommom(randNumber);
2607         }else if(tsukiTokenIds.length == 3 ){
2608             card = getRare(randNumber);
2609         }else if(tsukiTokenIds.length == 4 ){
2610             card =  getEpic(randNumber);
2611         }else if(tsukiTokenIds.length == 5 ){
2612             card = getLegendary(randNumber);
2613         }else{
2614             require(false, "Wrong tsuki qty burn!");
2615         }
2616          _mint(msg.sender, card, 1, "");
2617         return card;
2618     }
2619 
2620     function burn5MomomsTo1Better(uint256[] memory momomTokenIds, uint rarity, bytes32 dataHash) 
2621         external
2622         returns (uint[] memory)
2623     {
2624         uint qtdMint = 0;
2625         if(momomTokenIds.length == 5){
2626             qtdMint = 1;
2627         }else if(momomTokenIds.length == 10){
2628             qtdMint = 2;
2629         }else if(momomTokenIds.length == 15){
2630             qtdMint = 3;
2631         }else{
2632             require(false, "You need 5, 10 or 15 Momoms to get 1, 2 or 3 more rare.");
2633         }
2634         if(rarity==3){
2635             require(momomTokenIds.length == 5, "You can only burn 5 Epic Momoms to get 1 Legendary.");
2636         }
2637         uint[] memory cards = new uint[](qtdMint);
2638         if(rarity==0){
2639             require(burnMomomCommomOpen, "Burn Momom is not open!");
2640             require(validateCommom(momomTokenIds), "You need 5 Commons to receive a Uncommom.");
2641             for (uint256 i = 0; i < momomTokenIds.length; i++) {
2642                 _burn(msg.sender,momomTokenIds[i],1);
2643             }
2644             uint randNumber = random(dataHash);
2645             for (uint i = 0; i < qtdMint; i++) {
2646                 uint number = randomPart(randNumber, ((i==0)?1:(10000**i)));
2647                 cards[i] = getUncommom(number);
2648                 _mint(msg.sender, cards[i], 1, "");
2649             }
2650         }else if(rarity==1){
2651             require(burnMomomUncommomOpen, "Burn Momom is not open!");
2652             require(validateUncommom(momomTokenIds), "You need 5 Uncommom to receive a Rare.");
2653             for (uint256 i = 0; i < momomTokenIds.length; i++) {
2654                 _burn(msg.sender,momomTokenIds[i],1);
2655             }
2656             uint randNumber = random(dataHash);
2657             for (uint i = 0; i < qtdMint; i++) {
2658                 uint number = randomPart(randNumber, ((i==0)?1:(10000**i)));
2659                 cards[i] = getRare(number);
2660                 _mint(msg.sender, cards[i], 1, "");
2661             }
2662         }else if(rarity==2){
2663             require(burnMomomRareOpen, "Burn Momom is not open!");
2664             require(validateRare(momomTokenIds), "You need 5 Rare to receive a Epic.");
2665             for (uint256 i = 0; i < momomTokenIds.length; i++) {
2666                 _burn(msg.sender,momomTokenIds[i],1);
2667             }
2668              uint randNumber = random(dataHash);
2669              for (uint i = 0; i < qtdMint; i++) {
2670                 uint number = randomPart(randNumber, ((i==0)?1:(10000**i)));
2671                 cards[i] = getEpic(number);
2672                 _mint(msg.sender, cards[i], 1, "");
2673             }
2674         }else if(rarity==3){
2675             require(burnMomomEpicOpen, "Burn Momom is not open!");
2676             require(validateEpic(momomTokenIds), "You need 5 Epic to receive a Legendary.");
2677             for (uint256 i = 0; i < momomTokenIds.length; i++) {
2678                 _burn(msg.sender,momomTokenIds[i],1);
2679             }
2680              uint randNumber = random(dataHash);
2681              cards[0] = getLegendary(randNumber);
2682             _mint(msg.sender, cards[0], 1, "");
2683         }else {
2684             require(false, "Wrong rarity burn!");
2685         }
2686         return cards;
2687     }
2688 
2689     function rewardAllMomoms() external {
2690         require(rewardAllMomomsOpen, "Reward all Momom is not open!");
2691         require(qtyRewardedAllMomom < maxQtyRewardAllMomom, "Max reward reached! Wait for another reward!");
2692         uint[] memory momoms = getAllMomoms();
2693         for (uint256 i = 0; i < momoms.length; i++) {
2694             _burn(msg.sender,momoms[i],1);
2695         }
2696         //700 is the pin for those who complete de album
2697          _mint(msg.sender, 700, 1, "");
2698          qtyRewardedAllMomom++;
2699     }
2700 
2701     function gift(address[] calldata receivers, uint256[] memory momomTokenIds) external onlyOwner {
2702         for (uint256 i = 0; i < receivers.length; i++) {
2703             _mint(receivers[i], momomTokenIds[i], 1, "");
2704         }
2705     }
2706 
2707     function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
2708         internal
2709         whenNotPaused
2710         override(ERC1155, ERC1155Supply)
2711     {
2712         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
2713     }
2714 //implemetation
2715     function getPrice() public view returns (uint256) {
2716         if(enableTsukiPrice && getBalaceOfTsuki()>0){
2717             return custom_price_tsuki;
2718         }
2719         if(customPrice){
2720             return custom_price;
2721         }else{
2722             return PUBLIC_SALES_PRICE;
2723         }
2724     }
2725 
2726     function uri(uint256 id)
2727         public
2728         view
2729         virtual
2730         override
2731         returns (string memory)
2732     {
2733         require(exists(id),
2734         "URI query for nonexistent token"
2735         );
2736         
2737         return bytes(super.uri(id)).length > 0
2738             ? string(abi.encodePacked(super.uri(id), Strings.toString(id)))
2739             : "";
2740     }
2741 
2742     function withdraw() public payable onlyOwner {
2743         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2744         require(success);
2745 	}
2746 
2747     function renounceOwnership() override public onlyOwner{
2748         require(canRenounceOwnership,"Not the time to Renounce Ownership");
2749         _transferOwnership(address(0));
2750     }
2751 
2752 }