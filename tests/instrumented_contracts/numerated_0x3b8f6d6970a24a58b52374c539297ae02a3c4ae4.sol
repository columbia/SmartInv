1 // File @openzeppelin/contracts/utils/math/Math.sol@v4.8.2
2 
3 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Standard math utilities missing in the Solidity language.
9  */
10 library Math {
11     enum Rounding {
12         Down, // Toward negative infinity
13         Up, // Toward infinity
14         Zero // Toward zero
15     }
16 
17     /**
18      * @dev Returns the largest of two numbers.
19      */
20     function max(uint256 a, uint256 b) internal pure returns (uint256) {
21         return a > b ? a : b;
22     }
23 
24     /**
25      * @dev Returns the smallest of two numbers.
26      */
27     function min(uint256 a, uint256 b) internal pure returns (uint256) {
28         return a < b ? a : b;
29     }
30 
31     /**
32      * @dev Returns the average of two numbers. The result is rounded towards
33      * zero.
34      */
35     function average(uint256 a, uint256 b) internal pure returns (uint256) {
36         // (a + b) / 2 can overflow.
37         return (a & b) + (a ^ b) / 2;
38     }
39 
40     /**
41      * @dev Returns the ceiling of the division of two numbers.
42      *
43      * This differs from standard division with `/` in that it rounds up instead
44      * of rounding down.
45      */
46     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
47         // (a + b - 1) / b can overflow on addition, so we distribute.
48         return a == 0 ? 0 : (a - 1) / b + 1;
49     }
50 
51     /**
52      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
53      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
54      * with further edits by Uniswap Labs also under MIT license.
55      */
56     function mulDiv(
57         uint256 x,
58         uint256 y,
59         uint256 denominator
60     ) internal pure returns (uint256 result) {
61         unchecked {
62             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
63             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
64             // variables such that product = prod1 * 2^256 + prod0.
65             uint256 prod0; // Least significant 256 bits of the product
66             uint256 prod1; // Most significant 256 bits of the product
67             assembly {
68                 let mm := mulmod(x, y, not(0))
69                 prod0 := mul(x, y)
70                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
71             }
72 
73             // Handle non-overflow cases, 256 by 256 division.
74             if (prod1 == 0) {
75                 return prod0 / denominator;
76             }
77 
78             // Make sure the result is less than 2^256. Also prevents denominator == 0.
79             require(denominator > prod1);
80 
81             ///////////////////////////////////////////////
82             // 512 by 256 division.
83             ///////////////////////////////////////////////
84 
85             // Make division exact by subtracting the remainder from [prod1 prod0].
86             uint256 remainder;
87             assembly {
88                 // Compute remainder using mulmod.
89                 remainder := mulmod(x, y, denominator)
90 
91                 // Subtract 256 bit number from 512 bit number.
92                 prod1 := sub(prod1, gt(remainder, prod0))
93                 prod0 := sub(prod0, remainder)
94             }
95 
96             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
97             // See https://cs.stackexchange.com/q/138556/92363.
98 
99             // Does not overflow because the denominator cannot be zero at this stage in the function.
100             uint256 twos = denominator & (~denominator + 1);
101             assembly {
102                 // Divide denominator by twos.
103                 denominator := div(denominator, twos)
104 
105                 // Divide [prod1 prod0] by twos.
106                 prod0 := div(prod0, twos)
107 
108                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
109                 twos := add(div(sub(0, twos), twos), 1)
110             }
111 
112             // Shift in bits from prod1 into prod0.
113             prod0 |= prod1 * twos;
114 
115             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
116             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
117             // four bits. That is, denominator * inv = 1 mod 2^4.
118             uint256 inverse = (3 * denominator) ^ 2;
119 
120             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
121             // in modular arithmetic, doubling the correct bits in each step.
122             inverse *= 2 - denominator * inverse; // inverse mod 2^8
123             inverse *= 2 - denominator * inverse; // inverse mod 2^16
124             inverse *= 2 - denominator * inverse; // inverse mod 2^32
125             inverse *= 2 - denominator * inverse; // inverse mod 2^64
126             inverse *= 2 - denominator * inverse; // inverse mod 2^128
127             inverse *= 2 - denominator * inverse; // inverse mod 2^256
128 
129             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
130             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
131             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
132             // is no longer required.
133             result = prod0 * inverse;
134             return result;
135         }
136     }
137 
138     /**
139      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
140      */
141     function mulDiv(
142         uint256 x,
143         uint256 y,
144         uint256 denominator,
145         Rounding rounding
146     ) internal pure returns (uint256) {
147         uint256 result = mulDiv(x, y, denominator);
148         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
149             result += 1;
150         }
151         return result;
152     }
153 
154     /**
155      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
156      *
157      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
158      */
159     function sqrt(uint256 a) internal pure returns (uint256) {
160         if (a == 0) {
161             return 0;
162         }
163 
164         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
165         //
166         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
167         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
168         //
169         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
170         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
171         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
172         //
173         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
174         uint256 result = 1 << (log2(a) >> 1);
175 
176         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
177         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
178         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
179         // into the expected uint128 result.
180         unchecked {
181             result = (result + a / result) >> 1;
182             result = (result + a / result) >> 1;
183             result = (result + a / result) >> 1;
184             result = (result + a / result) >> 1;
185             result = (result + a / result) >> 1;
186             result = (result + a / result) >> 1;
187             result = (result + a / result) >> 1;
188             return min(result, a / result);
189         }
190     }
191 
192     /**
193      * @notice Calculates sqrt(a), following the selected rounding direction.
194      */
195     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
196         unchecked {
197             uint256 result = sqrt(a);
198             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
199         }
200     }
201 
202     /**
203      * @dev Return the log in base 2, rounded down, of a positive value.
204      * Returns 0 if given 0.
205      */
206     function log2(uint256 value) internal pure returns (uint256) {
207         uint256 result = 0;
208         unchecked {
209             if (value >> 128 > 0) {
210                 value >>= 128;
211                 result += 128;
212             }
213             if (value >> 64 > 0) {
214                 value >>= 64;
215                 result += 64;
216             }
217             if (value >> 32 > 0) {
218                 value >>= 32;
219                 result += 32;
220             }
221             if (value >> 16 > 0) {
222                 value >>= 16;
223                 result += 16;
224             }
225             if (value >> 8 > 0) {
226                 value >>= 8;
227                 result += 8;
228             }
229             if (value >> 4 > 0) {
230                 value >>= 4;
231                 result += 4;
232             }
233             if (value >> 2 > 0) {
234                 value >>= 2;
235                 result += 2;
236             }
237             if (value >> 1 > 0) {
238                 result += 1;
239             }
240         }
241         return result;
242     }
243 
244     /**
245      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
246      * Returns 0 if given 0.
247      */
248     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
249         unchecked {
250             uint256 result = log2(value);
251             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
252         }
253     }
254 
255     /**
256      * @dev Return the log in base 10, rounded down, of a positive value.
257      * Returns 0 if given 0.
258      */
259     function log10(uint256 value) internal pure returns (uint256) {
260         uint256 result = 0;
261         unchecked {
262             if (value >= 10**64) {
263                 value /= 10**64;
264                 result += 64;
265             }
266             if (value >= 10**32) {
267                 value /= 10**32;
268                 result += 32;
269             }
270             if (value >= 10**16) {
271                 value /= 10**16;
272                 result += 16;
273             }
274             if (value >= 10**8) {
275                 value /= 10**8;
276                 result += 8;
277             }
278             if (value >= 10**4) {
279                 value /= 10**4;
280                 result += 4;
281             }
282             if (value >= 10**2) {
283                 value /= 10**2;
284                 result += 2;
285             }
286             if (value >= 10**1) {
287                 result += 1;
288             }
289         }
290         return result;
291     }
292 
293     /**
294      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
298         unchecked {
299             uint256 result = log10(value);
300             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
301         }
302     }
303 
304     /**
305      * @dev Return the log in base 256, rounded down, of a positive value.
306      * Returns 0 if given 0.
307      *
308      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
309      */
310     function log256(uint256 value) internal pure returns (uint256) {
311         uint256 result = 0;
312         unchecked {
313             if (value >> 128 > 0) {
314                 value >>= 128;
315                 result += 16;
316             }
317             if (value >> 64 > 0) {
318                 value >>= 64;
319                 result += 8;
320             }
321             if (value >> 32 > 0) {
322                 value >>= 32;
323                 result += 4;
324             }
325             if (value >> 16 > 0) {
326                 value >>= 16;
327                 result += 2;
328             }
329             if (value >> 8 > 0) {
330                 result += 1;
331             }
332         }
333         return result;
334     }
335 
336     /**
337      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
338      * Returns 0 if given 0.
339      */
340     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
341         unchecked {
342             uint256 result = log256(value);
343             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
344         }
345     }
346 }
347 
348 
349 // File @openzeppelin/contracts/utils/Strings.sol@v4.8.2
350 
351 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
352 
353 pragma solidity ^0.8.0;
354 
355 /**
356  * @dev String operations.
357  */
358 library Strings {
359     bytes16 private constant _SYMBOLS = "0123456789abcdef";
360     uint8 private constant _ADDRESS_LENGTH = 20;
361 
362     /**
363      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
364      */
365     function toString(uint256 value) internal pure returns (string memory) {
366         unchecked {
367             uint256 length = Math.log10(value) + 1;
368             string memory buffer = new string(length);
369             uint256 ptr;
370             /// @solidity memory-safe-assembly
371             assembly {
372                 ptr := add(buffer, add(32, length))
373             }
374             while (true) {
375                 ptr--;
376                 /// @solidity memory-safe-assembly
377                 assembly {
378                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
379                 }
380                 value /= 10;
381                 if (value == 0) break;
382             }
383             return buffer;
384         }
385     }
386 
387     /**
388      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
389      */
390     function toHexString(uint256 value) internal pure returns (string memory) {
391         unchecked {
392             return toHexString(value, Math.log256(value) + 1);
393         }
394     }
395 
396     /**
397      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
398      */
399     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
400         bytes memory buffer = new bytes(2 * length + 2);
401         buffer[0] = "0";
402         buffer[1] = "x";
403         for (uint256 i = 2 * length + 1; i > 1; --i) {
404             buffer[i] = _SYMBOLS[value & 0xf];
405             value >>= 4;
406         }
407         require(value == 0, "Strings: hex length insufficient");
408         return string(buffer);
409     }
410 
411     /**
412      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
413      */
414     function toHexString(address addr) internal pure returns (string memory) {
415         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
416     }
417 }
418 
419 
420 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.8.2
421 
422 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
423 
424 pragma solidity ^0.8.0;
425 
426 /**
427  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
428  *
429  * These functions can be used to verify that a message was signed by the holder
430  * of the private keys of a given address.
431  */
432 library ECDSA {
433     enum RecoverError {
434         NoError,
435         InvalidSignature,
436         InvalidSignatureLength,
437         InvalidSignatureS,
438         InvalidSignatureV // Deprecated in v4.8
439     }
440 
441     function _throwError(RecoverError error) private pure {
442         if (error == RecoverError.NoError) {
443             return; // no error: do nothing
444         } else if (error == RecoverError.InvalidSignature) {
445             revert("ECDSA: invalid signature");
446         } else if (error == RecoverError.InvalidSignatureLength) {
447             revert("ECDSA: invalid signature length");
448         } else if (error == RecoverError.InvalidSignatureS) {
449             revert("ECDSA: invalid signature 's' value");
450         }
451     }
452 
453     /**
454      * @dev Returns the address that signed a hashed message (`hash`) with
455      * `signature` or error string. This address can then be used for verification purposes.
456      *
457      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
458      * this function rejects them by requiring the `s` value to be in the lower
459      * half order, and the `v` value to be either 27 or 28.
460      *
461      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
462      * verification to be secure: it is possible to craft signatures that
463      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
464      * this is by receiving a hash of the original message (which may otherwise
465      * be too long), and then calling {toEthSignedMessageHash} on it.
466      *
467      * Documentation for signature generation:
468      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
469      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
470      *
471      * _Available since v4.3._
472      */
473     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
474         if (signature.length == 65) {
475             bytes32 r;
476             bytes32 s;
477             uint8 v;
478             // ecrecover takes the signature parameters, and the only way to get them
479             // currently is to use assembly.
480             /// @solidity memory-safe-assembly
481             assembly {
482                 r := mload(add(signature, 0x20))
483                 s := mload(add(signature, 0x40))
484                 v := byte(0, mload(add(signature, 0x60)))
485             }
486             return tryRecover(hash, v, r, s);
487         } else {
488             return (address(0), RecoverError.InvalidSignatureLength);
489         }
490     }
491 
492     /**
493      * @dev Returns the address that signed a hashed message (`hash`) with
494      * `signature`. This address can then be used for verification purposes.
495      *
496      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
497      * this function rejects them by requiring the `s` value to be in the lower
498      * half order, and the `v` value to be either 27 or 28.
499      *
500      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
501      * verification to be secure: it is possible to craft signatures that
502      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
503      * this is by receiving a hash of the original message (which may otherwise
504      * be too long), and then calling {toEthSignedMessageHash} on it.
505      */
506     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
507         (address recovered, RecoverError error) = tryRecover(hash, signature);
508         _throwError(error);
509         return recovered;
510     }
511 
512     /**
513      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
514      *
515      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
516      *
517      * _Available since v4.3._
518      */
519     function tryRecover(
520         bytes32 hash,
521         bytes32 r,
522         bytes32 vs
523     ) internal pure returns (address, RecoverError) {
524         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
525         uint8 v = uint8((uint256(vs) >> 255) + 27);
526         return tryRecover(hash, v, r, s);
527     }
528 
529     /**
530      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
531      *
532      * _Available since v4.2._
533      */
534     function recover(
535         bytes32 hash,
536         bytes32 r,
537         bytes32 vs
538     ) internal pure returns (address) {
539         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
540         _throwError(error);
541         return recovered;
542     }
543 
544     /**
545      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
546      * `r` and `s` signature fields separately.
547      *
548      * _Available since v4.3._
549      */
550     function tryRecover(
551         bytes32 hash,
552         uint8 v,
553         bytes32 r,
554         bytes32 s
555     ) internal pure returns (address, RecoverError) {
556         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
557         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
558         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
559         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
560         //
561         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
562         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
563         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
564         // these malleable signatures as well.
565         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
566             return (address(0), RecoverError.InvalidSignatureS);
567         }
568 
569         // If the signature is valid (and not malleable), return the signer address
570         address signer = ecrecover(hash, v, r, s);
571         if (signer == address(0)) {
572             return (address(0), RecoverError.InvalidSignature);
573         }
574 
575         return (signer, RecoverError.NoError);
576     }
577 
578     /**
579      * @dev Overload of {ECDSA-recover} that receives the `v`,
580      * `r` and `s` signature fields separately.
581      */
582     function recover(
583         bytes32 hash,
584         uint8 v,
585         bytes32 r,
586         bytes32 s
587     ) internal pure returns (address) {
588         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
589         _throwError(error);
590         return recovered;
591     }
592 
593     /**
594      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
595      * produces hash corresponding to the one signed with the
596      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
597      * JSON-RPC method as part of EIP-191.
598      *
599      * See {recover}.
600      */
601     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
602         // 32 is the length in bytes of hash,
603         // enforced by the type signature above
604         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
605     }
606 
607     /**
608      * @dev Returns an Ethereum Signed Message, created from `s`. This
609      * produces hash corresponding to the one signed with the
610      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
611      * JSON-RPC method as part of EIP-191.
612      *
613      * See {recover}.
614      */
615     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
616         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
617     }
618 
619     /**
620      * @dev Returns an Ethereum Signed Typed Data, created from a
621      * `domainSeparator` and a `structHash`. This produces hash corresponding
622      * to the one signed with the
623      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
624      * JSON-RPC method as part of EIP-712.
625      *
626      * See {recover}.
627      */
628     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
629         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
630     }
631 }
632 
633 
634 // File @openzeppelin/contracts/utils/cryptography/EIP712.sol@v4.8.2
635 
636 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
637 
638 pragma solidity ^0.8.0;
639 
640 /**
641  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
642  *
643  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
644  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
645  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
646  *
647  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
648  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
649  * ({_hashTypedDataV4}).
650  *
651  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
652  * the chain id to protect against replay attacks on an eventual fork of the chain.
653  *
654  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
655  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
656  *
657  * _Available since v3.4._
658  */
659 abstract contract EIP712 {
660     /* solhint-disable var-name-mixedcase */
661     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
662     // invalidate the cached domain separator if the chain id changes.
663     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
664     uint256 private immutable _CACHED_CHAIN_ID;
665     address private immutable _CACHED_THIS;
666 
667     bytes32 private immutable _HASHED_NAME;
668     bytes32 private immutable _HASHED_VERSION;
669     bytes32 private immutable _TYPE_HASH;
670 
671     /* solhint-enable var-name-mixedcase */
672 
673     /**
674      * @dev Initializes the domain separator and parameter caches.
675      *
676      * The meaning of `name` and `version` is specified in
677      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
678      *
679      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
680      * - `version`: the current major version of the signing domain.
681      *
682      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
683      * contract upgrade].
684      */
685     constructor(string memory name, string memory version) {
686         bytes32 hashedName = keccak256(bytes(name));
687         bytes32 hashedVersion = keccak256(bytes(version));
688         bytes32 typeHash = keccak256(
689             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
690         );
691         _HASHED_NAME = hashedName;
692         _HASHED_VERSION = hashedVersion;
693         _CACHED_CHAIN_ID = block.chainid;
694         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
695         _CACHED_THIS = address(this);
696         _TYPE_HASH = typeHash;
697     }
698 
699     /**
700      * @dev Returns the domain separator for the current chain.
701      */
702     function _domainSeparatorV4() internal view returns (bytes32) {
703         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
704             return _CACHED_DOMAIN_SEPARATOR;
705         } else {
706             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
707         }
708     }
709 
710     function _buildDomainSeparator(
711         bytes32 typeHash,
712         bytes32 nameHash,
713         bytes32 versionHash
714     ) private view returns (bytes32) {
715         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
716     }
717 
718     /**
719      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
720      * function returns the hash of the fully encoded EIP712 message for this domain.
721      *
722      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
723      *
724      * ```solidity
725      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
726      *     keccak256("Mail(address to,string contents)"),
727      *     mailTo,
728      *     keccak256(bytes(mailContents))
729      * )));
730      * address signer = ECDSA.recover(digest, signature);
731      * ```
732      */
733     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
734         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
735     }
736 }
737 
738 
739 // File contracts/EIP712Verifier.sol
740 
741 pragma solidity ^0.8.17;
742 
743 
744 contract EIP712Verifier is EIP712 {
745     address public external_signer;
746 
747     constructor(string memory domainName, string memory version, address signer) EIP712(domainName, version) {
748         external_signer = signer;
749         require(signer != address(0), "ZERO_SIGNER");
750     }
751 
752     /* 
753         Standard EIP712 verifier but with different v combinations
754     */
755     function verify(bytes32 digest, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
756 
757         address recovered_signer = ecrecover(digest, v, r, s);
758         if (recovered_signer != external_signer) {
759             uint8 other_v = 27;
760             if (other_v == v) {
761                 other_v = 28;
762             }
763 
764             recovered_signer = ecrecover(digest, other_v, r, s);
765         }
766 
767         if (recovered_signer != external_signer) {
768             return false;
769         }
770 
771         return true;
772     }
773 }
774 
775 
776 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.8.2
777 
778 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
779 
780 pragma solidity ^0.8.0;
781 
782 /**
783  * @dev Interface of the ERC20 standard as defined in the EIP.
784  */
785 interface IERC20 {
786     /**
787      * @dev Emitted when `value` tokens are moved from one account (`from`) to
788      * another (`to`).
789      *
790      * Note that `value` may be zero.
791      */
792     event Transfer(address indexed from, address indexed to, uint256 value);
793 
794     /**
795      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
796      * a call to {approve}. `value` is the new allowance.
797      */
798     event Approval(address indexed owner, address indexed spender, uint256 value);
799 
800     /**
801      * @dev Returns the amount of tokens in existence.
802      */
803     function totalSupply() external view returns (uint256);
804 
805     /**
806      * @dev Returns the amount of tokens owned by `account`.
807      */
808     function balanceOf(address account) external view returns (uint256);
809 
810     /**
811      * @dev Moves `amount` tokens from the caller's account to `to`.
812      *
813      * Returns a boolean value indicating whether the operation succeeded.
814      *
815      * Emits a {Transfer} event.
816      */
817     function transfer(address to, uint256 amount) external returns (bool);
818 
819     /**
820      * @dev Returns the remaining number of tokens that `spender` will be
821      * allowed to spend on behalf of `owner` through {transferFrom}. This is
822      * zero by default.
823      *
824      * This value changes when {approve} or {transferFrom} are called.
825      */
826     function allowance(address owner, address spender) external view returns (uint256);
827 
828     /**
829      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
830      *
831      * Returns a boolean value indicating whether the operation succeeded.
832      *
833      * IMPORTANT: Beware that changing an allowance with this method brings the risk
834      * that someone may use both the old and the new allowance by unfortunate
835      * transaction ordering. One possible solution to mitigate this race
836      * condition is to first reduce the spender's allowance to 0 and set the
837      * desired value afterwards:
838      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
839      *
840      * Emits an {Approval} event.
841      */
842     function approve(address spender, uint256 amount) external returns (bool);
843 
844     /**
845      * @dev Moves `amount` tokens from `from` to `to` using the
846      * allowance mechanism. `amount` is then deducted from the caller's
847      * allowance.
848      *
849      * Returns a boolean value indicating whether the operation succeeded.
850      *
851      * Emits a {Transfer} event.
852      */
853     function transferFrom(
854         address from,
855         address to,
856         uint256 amount
857     ) external returns (bool);
858 }
859 
860 
861 // File contracts/Rabbit.sol
862 
863 // SPDX-License-Identifier: BUSL-1.1
864 pragma solidity ^0.8.19;
865 
866 
867 
868 
869 contract Rabbit is EIP712Verifier {
870 
871     uint256 constant UNLOCKED = 1;
872     uint256 constant LOCKED = 2;
873 
874     address public immutable owner;
875     IERC20 public paymentToken;
876 
877     // record of already processed withdrawals
878     mapping(uint256 => bool) public processedWithdrawals;
879 
880 
881     uint256 nextDepositId = 37000;
882     uint256 reentryLockStatus = UNLOCKED;
883 
884     event Deposit(uint256 indexed id, address indexed trader, uint256 amount);
885     event Withdraw(address indexed trader, uint256 amount);
886     event WithdrawTo(address indexed to, uint256 amount);
887     event WithdrawalReceipt(uint256 indexed id, address indexed trader, uint256 amount);
888     event UnknownReceipt(uint256 indexed messageType, uint[] payload);
889     event MsgNotFound(uint256 indexed fromAddress, uint[] payload);
890 
891     modifier onlyOwner() {
892         require(msg.sender == owner, "ONLY_OWNER");
893         _;
894     }
895 
896     modifier nonReentrant() {
897         require(reentryLockStatus == UNLOCKED, "NO_REENTRY");
898         reentryLockStatus = LOCKED;
899         _;
900         reentryLockStatus = UNLOCKED;
901     }
902 
903     constructor(address _owner, address _signer, address _paymentToken
904     	) EIP712Verifier("RabbitXWithdrawal", "1", _signer) {
905         owner = _owner;
906         paymentToken = IERC20(_paymentToken);
907     }
908     
909     function withdraw(
910         uint256 id, address trader, uint256 amount, uint8 v, bytes32 r, bytes32 s
911         ) external nonReentrant {
912         require(amount > 0, "WRONG_AMOUNT");
913         require(processedWithdrawals[id] == false, "ALREADY_PROCESSED");
914         processedWithdrawals[id] = true;
915         bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
916             keccak256("withdrawal(uint256 id,address trader,uint256 amount)"),
917             id,
918             trader,
919             amount
920         )));
921 
922         bool valid = verify(digest, v, r, s);
923         require(valid, "INVALID_SIGNATURE");
924 
925         emit WithdrawalReceipt(id, trader, amount);
926         bool success = makeTransfer(trader, amount);
927         require(success, "TRANSFER_FAILED");
928     }
929 
930     function setPaymentToken(address _paymentToken) external onlyOwner {
931         paymentToken = IERC20(_paymentToken);
932     }
933 
934     function allocateDepositId() private returns (uint256 depositId) {
935         depositId = nextDepositId;
936         nextDepositId++;
937         return depositId;
938     }
939 
940     function deposit(uint256 amount) external nonReentrant {
941         bool success = makeTransferFrom(msg.sender, address(this) , amount);
942         require(success, "TRANSFER_FAILED");
943         uint256 depositId = allocateDepositId();
944         emit Deposit(depositId, msg.sender, amount);
945     }
946 
947     function withdrawTokensTo(uint256 amount, address to) external onlyOwner {
948         require(amount > 0, "WRONG_AMOUNT");
949         require(to != address(0), "ZERO_ADDRESS");
950         bool success = makeTransfer(to, amount);
951         require(success, "TRANSFER_FAILED");
952         emit WithdrawTo(to, amount);
953     }
954     
955     function changeSigner(address new_signer) external onlyOwner {
956         require(new_signer != address(0), "ZERO_SIGNER");
957         external_signer = new_signer;
958     }
959 
960     function makeTransfer(address to, uint256 amount) private returns (bool success) {
961         return tokenCall(abi.encodeWithSelector(paymentToken.transfer.selector, to, amount));
962     }
963 
964     function makeTransferFrom(address from, address to, uint256 amount) private returns (bool success) {
965         return tokenCall(abi.encodeWithSelector(paymentToken.transferFrom.selector, from, to, amount));
966     }
967 
968     function tokenCall(bytes memory data) private returns (bool) {
969         (bool success, bytes memory returndata) = address(paymentToken).call(data);
970         if (success && returndata.length > 0) {
971             success = abi.decode(returndata, (bool));
972         }
973         return success;
974     }
975 }