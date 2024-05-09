1 // SPDX-License-Identifier: UNLICENSED
2 pragma solidity ^0.8.17;
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
5 
6 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
7 
8 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
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
351 /**
352  * @dev String operations.
353  */
354 library Strings {
355     bytes16 private constant _SYMBOLS = "0123456789abcdef";
356     uint8 private constant _ADDRESS_LENGTH = 20;
357 
358     /**
359      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
360      */
361     function toString(uint256 value) internal pure returns (string memory) {
362         unchecked {
363             uint256 length = Math.log10(value) + 1;
364             string memory buffer = new string(length);
365             uint256 ptr;
366             /// @solidity memory-safe-assembly
367             assembly {
368                 ptr := add(buffer, add(32, length))
369             }
370             while (true) {
371                 ptr--;
372                 /// @solidity memory-safe-assembly
373                 assembly {
374                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
375                 }
376                 value /= 10;
377                 if (value == 0) break;
378             }
379             return buffer;
380         }
381     }
382 
383     /**
384      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
385      */
386     function toHexString(uint256 value) internal pure returns (string memory) {
387         unchecked {
388             return toHexString(value, Math.log256(value) + 1);
389         }
390     }
391 
392     /**
393      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
394      */
395     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
396         bytes memory buffer = new bytes(2 * length + 2);
397         buffer[0] = "0";
398         buffer[1] = "x";
399         for (uint256 i = 2 * length + 1; i > 1; --i) {
400             buffer[i] = _SYMBOLS[value & 0xf];
401             value >>= 4;
402         }
403         require(value == 0, "Strings: hex length insufficient");
404         return string(buffer);
405     }
406 
407     /**
408      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
409      */
410     function toHexString(address addr) internal pure returns (string memory) {
411         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
412     }
413 }
414 
415 /**
416  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
417  *
418  * These functions can be used to verify that a message was signed by the holder
419  * of the private keys of a given address.
420  */
421 library ECDSA {
422     enum RecoverError {
423         NoError,
424         InvalidSignature,
425         InvalidSignatureLength,
426         InvalidSignatureS,
427         InvalidSignatureV // Deprecated in v4.8
428     }
429 
430     function _throwError(RecoverError error) private pure {
431         if (error == RecoverError.NoError) {
432             return; // no error: do nothing
433         } else if (error == RecoverError.InvalidSignature) {
434             revert("ECDSA: invalid signature");
435         } else if (error == RecoverError.InvalidSignatureLength) {
436             revert("ECDSA: invalid signature length");
437         } else if (error == RecoverError.InvalidSignatureS) {
438             revert("ECDSA: invalid signature 's' value");
439         }
440     }
441 
442     /**
443      * @dev Returns the address that signed a hashed message (`hash`) with
444      * `signature` or error string. This address can then be used for verification purposes.
445      *
446      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
447      * this function rejects them by requiring the `s` value to be in the lower
448      * half order, and the `v` value to be either 27 or 28.
449      *
450      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
451      * verification to be secure: it is possible to craft signatures that
452      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
453      * this is by receiving a hash of the original message (which may otherwise
454      * be too long), and then calling {toEthSignedMessageHash} on it.
455      *
456      * Documentation for signature generation:
457      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
458      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
459      *
460      * _Available since v4.3._
461      */
462     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
463         if (signature.length == 65) {
464             bytes32 r;
465             bytes32 s;
466             uint8 v;
467             // ecrecover takes the signature parameters, and the only way to get them
468             // currently is to use assembly.
469             /// @solidity memory-safe-assembly
470             assembly {
471                 r := mload(add(signature, 0x20))
472                 s := mload(add(signature, 0x40))
473                 v := byte(0, mload(add(signature, 0x60)))
474             }
475             return tryRecover(hash, v, r, s);
476         } else {
477             return (address(0), RecoverError.InvalidSignatureLength);
478         }
479     }
480 
481     /**
482      * @dev Returns the address that signed a hashed message (`hash`) with
483      * `signature`. This address can then be used for verification purposes.
484      *
485      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
486      * this function rejects them by requiring the `s` value to be in the lower
487      * half order, and the `v` value to be either 27 or 28.
488      *
489      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
490      * verification to be secure: it is possible to craft signatures that
491      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
492      * this is by receiving a hash of the original message (which may otherwise
493      * be too long), and then calling {toEthSignedMessageHash} on it.
494      */
495     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
496         (address recovered, RecoverError error) = tryRecover(hash, signature);
497         _throwError(error);
498         return recovered;
499     }
500 
501     /**
502      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
503      *
504      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
505      *
506      * _Available since v4.3._
507      */
508     function tryRecover(
509         bytes32 hash,
510         bytes32 r,
511         bytes32 vs
512     ) internal pure returns (address, RecoverError) {
513         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
514         uint8 v = uint8((uint256(vs) >> 255) + 27);
515         return tryRecover(hash, v, r, s);
516     }
517 
518     /**
519      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
520      *
521      * _Available since v4.2._
522      */
523     function recover(
524         bytes32 hash,
525         bytes32 r,
526         bytes32 vs
527     ) internal pure returns (address) {
528         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
529         _throwError(error);
530         return recovered;
531     }
532 
533     /**
534      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
535      * `r` and `s` signature fields separately.
536      *
537      * _Available since v4.3._
538      */
539     function tryRecover(
540         bytes32 hash,
541         uint8 v,
542         bytes32 r,
543         bytes32 s
544     ) internal pure returns (address, RecoverError) {
545         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
546         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
547         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
548         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
549         //
550         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
551         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
552         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
553         // these malleable signatures as well.
554         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
555             return (address(0), RecoverError.InvalidSignatureS);
556         }
557 
558         // If the signature is valid (and not malleable), return the signer address
559         address signer = ecrecover(hash, v, r, s);
560         if (signer == address(0)) {
561             return (address(0), RecoverError.InvalidSignature);
562         }
563 
564         return (signer, RecoverError.NoError);
565     }
566 
567     /**
568      * @dev Overload of {ECDSA-recover} that receives the `v`,
569      * `r` and `s` signature fields separately.
570      */
571     function recover(
572         bytes32 hash,
573         uint8 v,
574         bytes32 r,
575         bytes32 s
576     ) internal pure returns (address) {
577         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
578         _throwError(error);
579         return recovered;
580     }
581 
582     /**
583      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
584      * produces hash corresponding to the one signed with the
585      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
586      * JSON-RPC method as part of EIP-191.
587      *
588      * See {recover}.
589      */
590     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
591         // 32 is the length in bytes of hash,
592         // enforced by the type signature above
593         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
594     }
595 
596     /**
597      * @dev Returns an Ethereum Signed Message, created from `s`. This
598      * produces hash corresponding to the one signed with the
599      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
600      * JSON-RPC method as part of EIP-191.
601      *
602      * See {recover}.
603      */
604     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
605         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
606     }
607 
608     /**
609      * @dev Returns an Ethereum Signed Typed Data, created from a
610      * `domainSeparator` and a `structHash`. This produces hash corresponding
611      * to the one signed with the
612      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
613      * JSON-RPC method as part of EIP-712.
614      *
615      * See {recover}.
616      */
617     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
618         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
619     }
620 }
621 
622 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
623 
624 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
625 
626 /**
627  * @dev Provides information about the current execution context, including the
628  * sender of the transaction and its data. While these are generally available
629  * via msg.sender and msg.data, they should not be accessed in such a direct
630  * manner, since when dealing with meta-transactions the account sending and
631  * paying for execution may not be the actual sender (as far as an application
632  * is concerned).
633  *
634  * This contract is only required for intermediate, library-like contracts.
635  */
636 abstract contract Context {
637     function _msgSender() internal view virtual returns (address) {
638         return msg.sender;
639     }
640 
641     function _msgData() internal view virtual returns (bytes calldata) {
642         return msg.data;
643     }
644 }
645 
646 /**
647  * @dev Contract module which provides a basic access control mechanism, where
648  * there is an account (an owner) that can be granted exclusive access to
649  * specific functions.
650  *
651  * By default, the owner account will be the one that deploys the contract. This
652  * can later be changed with {transferOwnership}.
653  *
654  * This module is used through inheritance. It will make available the modifier
655  * `onlyOwner`, which can be applied to your functions to restrict their use to
656  * the owner.
657  */
658 abstract contract Ownable is Context {
659     address private _owner;
660 
661     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
662 
663     /**
664      * @dev Initializes the contract setting the deployer as the initial owner.
665      */
666     constructor() {
667         _transferOwnership(_msgSender());
668     }
669 
670     /**
671      * @dev Throws if called by any account other than the owner.
672      */
673     modifier onlyOwner() {
674         _checkOwner();
675         _;
676     }
677 
678     /**
679      * @dev Returns the address of the current owner.
680      */
681     function owner() public view virtual returns (address) {
682         return _owner;
683     }
684 
685     /**
686      * @dev Throws if the sender is not the owner.
687      */
688     function _checkOwner() internal view virtual {
689         require(owner() == _msgSender(), "Ownable: caller is not the owner");
690     }
691 
692     /**
693      * @dev Leaves the contract without owner. It will not be possible to call
694      * `onlyOwner` functions anymore. Can only be called by the current owner.
695      *
696      * NOTE: Renouncing ownership will leave the contract without an owner,
697      * thereby removing any functionality that is only available to the owner.
698      */
699     function renounceOwnership() public virtual onlyOwner {
700         _transferOwnership(address(0));
701     }
702 
703     /**
704      * @dev Transfers ownership of the contract to a new account (`newOwner`).
705      * Can only be called by the current owner.
706      */
707     function transferOwnership(address newOwner) public virtual onlyOwner {
708         require(newOwner != address(0), "Ownable: new owner is the zero address");
709         _transferOwnership(newOwner);
710     }
711 
712     /**
713      * @dev Transfers ownership of the contract to a new account (`newOwner`).
714      * Internal function without access restriction.
715      */
716     function _transferOwnership(address newOwner) internal virtual {
717         address oldOwner = _owner;
718         _owner = newOwner;
719         emit OwnershipTransferred(oldOwner, newOwner);
720     }
721 }
722 
723 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
724 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
725 abstract contract ERC721 {
726     /*//////////////////////////////////////////////////////////////
727                                  EVENTS
728     //////////////////////////////////////////////////////////////*/
729 
730     event Transfer(address indexed from, address indexed to, uint256 indexed id);
731 
732     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
733 
734     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
735 
736     /*//////////////////////////////////////////////////////////////
737                          METADATA STORAGE/LOGIC
738     //////////////////////////////////////////////////////////////*/
739 
740     string public name;
741 
742     string public symbol;
743 
744     function tokenURI(uint256 id) public view virtual returns (string memory);
745 
746     /*//////////////////////////////////////////////////////////////
747                       ERC721 BALANCE/OWNER STORAGE
748     //////////////////////////////////////////////////////////////*/
749 
750     mapping(uint256 => address) internal _ownerOf;
751 
752     mapping(address => uint256) internal _balanceOf;
753 
754     function ownerOf(uint256 id) public view virtual returns (address owner) {
755         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
756     }
757 
758     function balanceOf(address owner) public view virtual returns (uint256) {
759         require(owner != address(0), "ZERO_ADDRESS");
760 
761         return _balanceOf[owner];
762     }
763 
764     /*//////////////////////////////////////////////////////////////
765                          ERC721 APPROVAL STORAGE
766     //////////////////////////////////////////////////////////////*/
767 
768     mapping(uint256 => address) public getApproved;
769 
770     mapping(address => mapping(address => bool)) public isApprovedForAll;
771 
772     /*//////////////////////////////////////////////////////////////
773                                CONSTRUCTOR
774     //////////////////////////////////////////////////////////////*/
775 
776     constructor(string memory _name, string memory _symbol) {
777         name = _name;
778         symbol = _symbol;
779     }
780 
781     /*//////////////////////////////////////////////////////////////
782                               ERC721 LOGIC
783     //////////////////////////////////////////////////////////////*/
784 
785     function approve(address spender, uint256 id) public virtual {
786         address owner = _ownerOf[id];
787 
788         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
789 
790         getApproved[id] = spender;
791 
792         emit Approval(owner, spender, id);
793     }
794 
795     function setApprovalForAll(address operator, bool approved) public virtual {
796         isApprovedForAll[msg.sender][operator] = approved;
797 
798         emit ApprovalForAll(msg.sender, operator, approved);
799     }
800 
801     function transferFrom(
802         address from,
803         address to,
804         uint256 id
805     ) public virtual {
806         require(from == _ownerOf[id], "WRONG_FROM");
807 
808         require(to != address(0), "INVALID_RECIPIENT");
809 
810         require(
811             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
812             "NOT_AUTHORIZED"
813         );
814 
815         // Underflow of the sender's balance is impossible because we check for
816         // ownership above and the recipient's balance can't realistically overflow.
817         unchecked {
818             _balanceOf[from]--;
819 
820             _balanceOf[to]++;
821         }
822 
823         _ownerOf[id] = to;
824 
825         delete getApproved[id];
826 
827         emit Transfer(from, to, id);
828     }
829 
830     function safeTransferFrom(
831         address from,
832         address to,
833         uint256 id
834     ) public virtual {
835         transferFrom(from, to, id);
836 
837         require(
838             to.code.length == 0 ||
839                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
840                 ERC721TokenReceiver.onERC721Received.selector,
841             "UNSAFE_RECIPIENT"
842         );
843     }
844 
845     function safeTransferFrom(
846         address from,
847         address to,
848         uint256 id,
849         bytes calldata data
850     ) public virtual {
851         transferFrom(from, to, id);
852 
853         require(
854             to.code.length == 0 ||
855                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
856                 ERC721TokenReceiver.onERC721Received.selector,
857             "UNSAFE_RECIPIENT"
858         );
859     }
860 
861     /*//////////////////////////////////////////////////////////////
862                               ERC165 LOGIC
863     //////////////////////////////////////////////////////////////*/
864 
865     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
866         return
867             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
868             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
869             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
870     }
871 
872     /*//////////////////////////////////////////////////////////////
873                         INTERNAL MINT/BURN LOGIC
874     //////////////////////////////////////////////////////////////*/
875 
876     function _mint(address to, uint256 id) internal virtual {
877         require(to != address(0), "INVALID_RECIPIENT");
878 
879         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
880 
881         // Counter overflow is incredibly unrealistic.
882         unchecked {
883             _balanceOf[to]++;
884         }
885 
886         _ownerOf[id] = to;
887 
888         emit Transfer(address(0), to, id);
889     }
890 
891     function _burn(uint256 id) internal virtual {
892         address owner = _ownerOf[id];
893 
894         require(owner != address(0), "NOT_MINTED");
895 
896         // Ownership check above ensures no underflow.
897         unchecked {
898             _balanceOf[owner]--;
899         }
900 
901         delete _ownerOf[id];
902 
903         delete getApproved[id];
904 
905         emit Transfer(owner, address(0), id);
906     }
907 
908     /*//////////////////////////////////////////////////////////////
909                         INTERNAL SAFE MINT LOGIC
910     //////////////////////////////////////////////////////////////*/
911 
912     function _safeMint(address to, uint256 id) internal virtual {
913         _mint(to, id);
914 
915         require(
916             to.code.length == 0 ||
917                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
918                 ERC721TokenReceiver.onERC721Received.selector,
919             "UNSAFE_RECIPIENT"
920         );
921     }
922 
923     function _safeMint(
924         address to,
925         uint256 id,
926         bytes memory data
927     ) internal virtual {
928         _mint(to, id);
929 
930         require(
931             to.code.length == 0 ||
932                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
933                 ERC721TokenReceiver.onERC721Received.selector,
934             "UNSAFE_RECIPIENT"
935         );
936     }
937 }
938 
939 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
940 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
941 abstract contract ERC721TokenReceiver {
942     function onERC721Received(
943         address,
944         address,
945         uint256,
946         bytes calldata
947     ) external virtual returns (bytes4) {
948         return ERC721TokenReceiver.onERC721Received.selector;
949     }
950 }
951 
952 /// @notice Handle allowlists from https://wolla.io
953 abstract contract Wolla {
954     /// @dev 0x0af806e0
955     error InvalidHash();
956     /// @dev 0x8baa579f
957     error InvalidSignature();
958 
959     /// @dev https://wolla.io allowlist hash
960     bytes32 internal immutable _wollaHash;
961     /// @dev https://wolla.io signer
962     address internal immutable _wollaSigner;
963 
964     constructor(bytes32 wollaHash, address wollaSigner) {
965         _wollaHash = wollaHash;
966         _wollaSigner = wollaSigner;
967     }
968 
969     /// @notice Check if caller is in allowlist
970     function checkIfInAllowlist(bytes32 hash, bytes calldata signature)
971         internal
972         view
973     {
974         // Check if hash is valid
975         if (
976             hash != keccak256(abi.encode(_wollaHash, msg.sender, address(this)))
977         ) {
978             revert InvalidHash();
979         }
980 
981         // Check signer is valid
982         if (
983             _wollaSigner !=
984             ECDSA.recover(ECDSA.toEthSignedMessageHash(hash), signature)
985         ) {
986             revert InvalidSignature();
987         }
988     }
989 }
990 
991 /// @notice Gen C
992 /// @author Aleph Retamal (https://github.com/alephao)
993 contract Gencee is ERC721, Wolla, Ownable {
994     using Strings for uint256;
995 
996     /// @dev 0xddefae28
997     error AlreadyMinted();
998     /// @dev 0x9e87fac8
999     error Paused();
1000     /// @dev 0xb52aa4c0
1001     error QueryForNonExistentToken();
1002     /// @dev 0xf7760f25
1003     error WrongPrice();
1004     /// @dev 0x73c604b5
1005     error MoreThanMaxTokens();
1006     /// @dev 0x750b219c
1007     error WithdrawFailed();
1008     /// @dev 0xea8e4eb5
1009     error NotAuthorized();
1010 
1011     /// @dev Address of Oddworx Signer Authority
1012     address internal immutable _oddxSigner;
1013 
1014     address internal immutable _payoutAddress;
1015 
1016     uint256 internal immutable maxTokens;
1017 
1018     uint256 public unitPrice = 1 ether;
1019     uint256 public totalMinted = 0;
1020 
1021     /// @notice tokenURI concatenates this value with the tokenId
1022     string public baseURI;
1023 
1024     /// @notice a single variable that can pause any function in the contract
1025     ///         uint8 = 8 bits = 00000000
1026     ///         we'll use the 4 least significant bits to decide which functions are paused
1027     ///         0b1111
1028     ///           │││└── mintVIP - 0x1 == 0b1
1029     ///           ││└─── mintWithOddworxSignature - 0x2 == 0b10
1030     ///           │└──── mintAllowlist - 0x4 == 0b100
1031     ///           └───── mintWithEth - 0x8 == 0b1000
1032     ///         starts as 0xFF == 0b1111 == 15
1033     uint8 public paused = 0xF; // 0xF == 0b1111
1034 
1035     mapping(address => bool) public didMintVIP;
1036     mapping(address => uint8) public didMintAllowlist;
1037     mapping(uint256 => bool) public didMintODDX;
1038 
1039     mapping(address => bool) public controllers;
1040 
1041     constructor(
1042         address oddxSigner,
1043         bytes32 wollaHash,
1044         address wollaSigner,
1045         uint256 maxTokens_
1046     ) ERC721("Gen C", "GC") Wolla(wollaHash, wollaSigner) {
1047         _oddxSigner = oddxSigner;
1048 
1049         maxTokens = maxTokens_;
1050         _payoutAddress = 0x79A920F4F0d142264F147D5840248A8c0CA346D8;
1051     }
1052 
1053     modifier onlyControllers() {
1054         if (!controllers[msg.sender]) {
1055             revert NotAuthorized();
1056         }
1057         _;
1058     }
1059 
1060     // Owner Only
1061     function setController(address controller, bool canControl)
1062         external
1063         onlyOwner
1064     {
1065         controllers[controller] = canControl;
1066     }
1067 
1068     function setMintVIPPaused(bool pause) external onlyOwner {
1069         paused = pause
1070             ? paused | 0x1 // 0x1 == 0b0001
1071             : paused & 0xE; // 0xE == 0b1110
1072     }
1073 
1074     function setMintWithOddworxSignaturePaused(bool pause) external onlyOwner {
1075         paused = pause
1076             ? paused | 0x2 // 0x2 == 0b0010
1077             : paused & 0xD; // 0xD == 0b1101
1078     }
1079 
1080     function setMintAllowlistPaused(bool pause) external onlyOwner {
1081         paused = pause
1082             ? paused | 0x4 // 0x4 == 0b0100
1083             : paused & 0xB; // 0xB == 0b1011
1084     }
1085 
1086     function setMintWithEthPaused(bool pause) external onlyOwner {
1087         paused = pause
1088             ? paused | 0x8 // 0x8 == 0b1000
1089             : paused & 0x7; // 0x7 == 0b0111
1090     }
1091 
1092     function setBaseURI(string calldata newBaseURI) external onlyOwner {
1093         baseURI = newBaseURI;
1094     }
1095 
1096     function pauseAll() external onlyOwner {
1097         paused = 0xF;
1098     }
1099 
1100     function setUnitPrice(uint256 price) external onlyOwner {
1101         unitPrice = price;
1102     }
1103 
1104     function withdraw() external onlyOwner {
1105         uint256 contractBalance = address(this).balance;
1106         // slither-disable-next-line low-level-calls
1107         (bool payoutSent, ) = payable(_payoutAddress).call{ // solhint-disable-line avoid-low-level-calls
1108             value: contractBalance
1109         }("");
1110         if (!payoutSent) revert WithdrawFailed();
1111     }
1112 
1113     // Only Owner - Failsafes
1114     function ownerMint(address to, uint256 tokenId) external onlyOwner {
1115         _safeMint(to, tokenId);
1116         ++totalMinted;
1117     }
1118 
1119     function ownerBurn(uint256 tokenId) external onlyOwner {
1120         _burn(tokenId);
1121         --totalMinted;
1122     }
1123 
1124     // Only Controllers
1125     function controllerBurn(uint256 token) external onlyControllers {
1126         _burn(token);
1127         --totalMinted;
1128     }
1129 
1130     /// @notice Mint a token for free (one per address)
1131     ///         Using https://wolla.io for the allowlist system
1132     function mintVIP(bytes32 hash, bytes calldata signature) external {
1133         if (paused & 0x1 == 0x1) {
1134             revert Paused();
1135         }
1136 
1137         // Can only mint once per address
1138         if (didMintVIP[msg.sender]) {
1139             revert AlreadyMinted();
1140         }
1141 
1142         unchecked {
1143             // Check amount won't be more than max
1144             if (totalMinted + 1 > maxTokens) {
1145                 revert MoreThanMaxTokens();
1146             }
1147         }
1148 
1149         checkIfInAllowlist(hash, signature);
1150 
1151         didMintVIP[msg.sender] = true;
1152         unchecked {
1153             _safeMint(msg.sender, ++totalMinted);
1154         }
1155     }
1156 
1157     /// @notice Mint any amount of token defined off-chain by the Oddworx Signer Authority.
1158     ///         Can only mint once per nonce with the amount pre-defined by the authority
1159     ///
1160     /// @dev    This is used to mint with off-chain ODDX, and prize winners
1161     function mintWithOddworxSignature(
1162         uint256 nonce,
1163         uint256 amount,
1164         bytes32 hash,
1165         bytes calldata signature
1166     ) external {
1167         if (paused & 0x2 == 0x2) {
1168             revert Paused();
1169         }
1170 
1171         // Can only mint once per nonce
1172         if (didMintODDX[nonce]) {
1173             revert AlreadyMinted();
1174         }
1175 
1176         uint256 _totalMinted = totalMinted;
1177         unchecked {
1178             // Check amount won't be more than max
1179             if (_totalMinted + amount >= maxTokens) {
1180                 revert MoreThanMaxTokens();
1181             }
1182         }
1183 
1184         // Check if hash is valid
1185         if (
1186             hash !=
1187             keccak256(
1188                 abi.encode(msg.sender, address(this), nonce, amount)
1189             )
1190         ) {
1191             revert InvalidHash();
1192         }
1193 
1194         // Check signer is valid
1195         if (
1196             _oddxSigner !=
1197             ECDSA.recover(ECDSA.toEthSignedMessageHash(hash), signature)
1198         ) {
1199             revert InvalidSignature();
1200         }
1201 
1202         didMintODDX[nonce] = true;
1203         uint256 baseIndex;
1204         unchecked {
1205             baseIndex = _totalMinted + 1;
1206             totalMinted += amount;
1207         }
1208 
1209         for (uint256 i = 0; i < amount; ) {
1210             unchecked {
1211                 _safeMint(msg.sender, baseIndex + i);
1212                 i++;
1213             }
1214         }
1215     }
1216 
1217     /// @notice Mint a token paying ETH if the caller is in the allow-list.
1218     ///         Using https://wolla.io for the allowlist system.
1219     /// @dev    We won't be removing addresses from the list, otherwise we would need
1220     ///         a nonce as part of the hash.
1221     function mintAllowlist(
1222         bytes32 hash,
1223         bytes calldata signature,
1224         uint8 amount
1225     ) external payable {
1226         if (paused & 0x4 == 0x4) {
1227             revert Paused();
1228         }
1229 
1230         uint256 _totalMinted = totalMinted;
1231         unchecked {
1232             // Check amount won't be more than max
1233             if (_totalMinted + amount >= maxTokens) {
1234                 revert MoreThanMaxTokens();
1235             }
1236 
1237             // Check eth value is correct
1238             if (msg.value != unitPrice * amount) {
1239                 revert WrongPrice();
1240             }
1241 
1242             // Can only mint 3 per address
1243             if (didMintAllowlist[msg.sender] + amount > 3) {
1244                 revert AlreadyMinted();
1245             }
1246 
1247             didMintAllowlist[msg.sender] += amount;
1248         }
1249 
1250         checkIfInAllowlist(hash, signature);
1251 
1252         uint256 baseIndex;
1253         unchecked {
1254             baseIndex = _totalMinted + 1;
1255             totalMinted += amount;
1256         }
1257 
1258         for (uint256 i = 0; i < amount; ) {
1259             unchecked {
1260                 _safeMint(msg.sender, baseIndex + i);
1261                 i++;
1262             }
1263         }
1264     }
1265 
1266     /// @notice Mint a token paying ETH.
1267     function mintWithEth(uint256 amount) external payable {
1268         if (paused & 0x8 == 0x8) {
1269             revert Paused();
1270         }
1271 
1272         uint256 _totalMinted = totalMinted;
1273         unchecked {
1274             // Check amount won't be more than max
1275             if (_totalMinted + amount >= maxTokens) {
1276                 revert MoreThanMaxTokens();
1277             }
1278 
1279             // Check eth value is correct
1280             if (msg.value != unitPrice * amount) {
1281                 revert WrongPrice();
1282             }
1283         }
1284 
1285         uint256 baseIndex;
1286         unchecked {
1287             baseIndex = _totalMinted + 1;
1288             totalMinted += amount;
1289         }
1290 
1291         for (uint256 i = 0; i < amount; ) {
1292             unchecked {
1293                 _safeMint(msg.sender, baseIndex + i);
1294                 i++;
1295             }
1296         }
1297     }
1298 
1299     // ERC721 Overrides
1300     function tokenURI(uint256 id) public view override returns (string memory) {
1301         if (_ownerOf[id] == address(0)) revert QueryForNonExistentToken();
1302         return string(abi.encodePacked(baseURI, id.toString()));
1303     }
1304 }
