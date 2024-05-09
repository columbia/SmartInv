1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Contract module that helps prevent reentrant calls to a function.
10  *
11  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
12  * available, which can be applied to functions to make sure there are no nested
13  * (reentrant) calls to them.
14  *
15  * Note that because there is a single `nonReentrant` guard, functions marked as
16  * `nonReentrant` may not call one another. This can be worked around by making
17  * those functions `private`, and then adding `external` `nonReentrant` entry
18  * points to them.
19  *
20  * TIP: If you would like to learn more about reentrancy and alternative ways
21  * to protect against it, check out our blog post
22  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
23  */
24 abstract contract ReentrancyGuard {
25     // Booleans are more expensive than uint256 or any type that takes up a full
26     // word because each write operation emits an extra SLOAD to first read the
27     // slot's contents, replace the bits taken up by the boolean, and then write
28     // back. This is the compiler's defense against contract upgrades and
29     // pointer aliasing, and it cannot be disabled.
30 
31     // The values being non-zero value makes deployment a bit more expensive,
32     // but in exchange the refund on every call to nonReentrant will be lower in
33     // amount. Since refunds are capped to a percentage of the total
34     // transaction's gas, it is best to keep them low in cases like this one, to
35     // increase the likelihood of the full refund coming into effect.
36     uint256 private constant _NOT_ENTERED = 1;
37     uint256 private constant _ENTERED = 2;
38 
39     uint256 private _status;
40 
41     constructor() {
42         _status = _NOT_ENTERED;
43     }
44 
45     /**
46      * @dev Prevents a contract from calling itself, directly or indirectly.
47      * Calling a `nonReentrant` function from another `nonReentrant`
48      * function is not supported. It is possible to prevent this from happening
49      * by making the `nonReentrant` function external, and making it call a
50      * `private` function that does the actual work.
51      */
52     modifier nonReentrant() {
53         _nonReentrantBefore();
54         _;
55         _nonReentrantAfter();
56     }
57 
58     function _nonReentrantBefore() private {
59         // On the first call to nonReentrant, _status will be _NOT_ENTERED
60         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
61 
62         // Any calls to nonReentrant after this point will fail
63         _status = _ENTERED;
64     }
65 
66     function _nonReentrantAfter() private {
67         // By storing the original value once again, a refund is triggered (see
68         // https://eips.ethereum.org/EIPS/eip-2200)
69         _status = _NOT_ENTERED;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/utils/math/Math.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 /**
81  * @dev Standard math utilities missing in the Solidity language.
82  */
83 library Math {
84     enum Rounding {
85         Down, // Toward negative infinity
86         Up, // Toward infinity
87         Zero // Toward zero
88     }
89 
90     /**
91      * @dev Returns the largest of two numbers.
92      */
93     function max(uint256 a, uint256 b) internal pure returns (uint256) {
94         return a > b ? a : b;
95     }
96 
97     /**
98      * @dev Returns the smallest of two numbers.
99      */
100     function min(uint256 a, uint256 b) internal pure returns (uint256) {
101         return a < b ? a : b;
102     }
103 
104     /**
105      * @dev Returns the average of two numbers. The result is rounded towards
106      * zero.
107      */
108     function average(uint256 a, uint256 b) internal pure returns (uint256) {
109         // (a + b) / 2 can overflow.
110         return (a & b) + (a ^ b) / 2;
111     }
112 
113     /**
114      * @dev Returns the ceiling of the division of two numbers.
115      *
116      * This differs from standard division with `/` in that it rounds up instead
117      * of rounding down.
118      */
119     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
120         // (a + b - 1) / b can overflow on addition, so we distribute.
121         return a == 0 ? 0 : (a - 1) / b + 1;
122     }
123 
124     /**
125      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
126      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
127      * with further edits by Uniswap Labs also under MIT license.
128      */
129     function mulDiv(
130         uint256 x,
131         uint256 y,
132         uint256 denominator
133     ) internal pure returns (uint256 result) {
134         unchecked {
135             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
136             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
137             // variables such that product = prod1 * 2^256 + prod0.
138             uint256 prod0; // Least significant 256 bits of the product
139             uint256 prod1; // Most significant 256 bits of the product
140             assembly {
141                 let mm := mulmod(x, y, not(0))
142                 prod0 := mul(x, y)
143                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
144             }
145 
146             // Handle non-overflow cases, 256 by 256 division.
147             if (prod1 == 0) {
148                 return prod0 / denominator;
149             }
150 
151             // Make sure the result is less than 2^256. Also prevents denominator == 0.
152             require(denominator > prod1);
153 
154             ///////////////////////////////////////////////
155             // 512 by 256 division.
156             ///////////////////////////////////////////////
157 
158             // Make division exact by subtracting the remainder from [prod1 prod0].
159             uint256 remainder;
160             assembly {
161                 // Compute remainder using mulmod.
162                 remainder := mulmod(x, y, denominator)
163 
164                 // Subtract 256 bit number from 512 bit number.
165                 prod1 := sub(prod1, gt(remainder, prod0))
166                 prod0 := sub(prod0, remainder)
167             }
168 
169             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
170             // See https://cs.stackexchange.com/q/138556/92363.
171 
172             // Does not overflow because the denominator cannot be zero at this stage in the function.
173             uint256 twos = denominator & (~denominator + 1);
174             assembly {
175                 // Divide denominator by twos.
176                 denominator := div(denominator, twos)
177 
178                 // Divide [prod1 prod0] by twos.
179                 prod0 := div(prod0, twos)
180 
181                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
182                 twos := add(div(sub(0, twos), twos), 1)
183             }
184 
185             // Shift in bits from prod1 into prod0.
186             prod0 |= prod1 * twos;
187 
188             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
189             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
190             // four bits. That is, denominator * inv = 1 mod 2^4.
191             uint256 inverse = (3 * denominator) ^ 2;
192 
193             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
194             // in modular arithmetic, doubling the correct bits in each step.
195             inverse *= 2 - denominator * inverse; // inverse mod 2^8
196             inverse *= 2 - denominator * inverse; // inverse mod 2^16
197             inverse *= 2 - denominator * inverse; // inverse mod 2^32
198             inverse *= 2 - denominator * inverse; // inverse mod 2^64
199             inverse *= 2 - denominator * inverse; // inverse mod 2^128
200             inverse *= 2 - denominator * inverse; // inverse mod 2^256
201 
202             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
203             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
204             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
205             // is no longer required.
206             result = prod0 * inverse;
207             return result;
208         }
209     }
210 
211     /**
212      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
213      */
214     function mulDiv(
215         uint256 x,
216         uint256 y,
217         uint256 denominator,
218         Rounding rounding
219     ) internal pure returns (uint256) {
220         uint256 result = mulDiv(x, y, denominator);
221         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
222             result += 1;
223         }
224         return result;
225     }
226 
227     /**
228      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
229      *
230      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
231      */
232     function sqrt(uint256 a) internal pure returns (uint256) {
233         if (a == 0) {
234             return 0;
235         }
236 
237         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
238         //
239         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
240         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
241         //
242         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
243         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
244         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
245         //
246         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
247         uint256 result = 1 << (log2(a) >> 1);
248 
249         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
250         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
251         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
252         // into the expected uint128 result.
253         unchecked {
254             result = (result + a / result) >> 1;
255             result = (result + a / result) >> 1;
256             result = (result + a / result) >> 1;
257             result = (result + a / result) >> 1;
258             result = (result + a / result) >> 1;
259             result = (result + a / result) >> 1;
260             result = (result + a / result) >> 1;
261             return min(result, a / result);
262         }
263     }
264 
265     /**
266      * @notice Calculates sqrt(a), following the selected rounding direction.
267      */
268     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
269         unchecked {
270             uint256 result = sqrt(a);
271             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
272         }
273     }
274 
275     /**
276      * @dev Return the log in base 2, rounded down, of a positive value.
277      * Returns 0 if given 0.
278      */
279     function log2(uint256 value) internal pure returns (uint256) {
280         uint256 result = 0;
281         unchecked {
282             if (value >> 128 > 0) {
283                 value >>= 128;
284                 result += 128;
285             }
286             if (value >> 64 > 0) {
287                 value >>= 64;
288                 result += 64;
289             }
290             if (value >> 32 > 0) {
291                 value >>= 32;
292                 result += 32;
293             }
294             if (value >> 16 > 0) {
295                 value >>= 16;
296                 result += 16;
297             }
298             if (value >> 8 > 0) {
299                 value >>= 8;
300                 result += 8;
301             }
302             if (value >> 4 > 0) {
303                 value >>= 4;
304                 result += 4;
305             }
306             if (value >> 2 > 0) {
307                 value >>= 2;
308                 result += 2;
309             }
310             if (value >> 1 > 0) {
311                 result += 1;
312             }
313         }
314         return result;
315     }
316 
317     /**
318      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
319      * Returns 0 if given 0.
320      */
321     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
322         unchecked {
323             uint256 result = log2(value);
324             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
325         }
326     }
327 
328     /**
329      * @dev Return the log in base 10, rounded down, of a positive value.
330      * Returns 0 if given 0.
331      */
332     function log10(uint256 value) internal pure returns (uint256) {
333         uint256 result = 0;
334         unchecked {
335             if (value >= 10**64) {
336                 value /= 10**64;
337                 result += 64;
338             }
339             if (value >= 10**32) {
340                 value /= 10**32;
341                 result += 32;
342             }
343             if (value >= 10**16) {
344                 value /= 10**16;
345                 result += 16;
346             }
347             if (value >= 10**8) {
348                 value /= 10**8;
349                 result += 8;
350             }
351             if (value >= 10**4) {
352                 value /= 10**4;
353                 result += 4;
354             }
355             if (value >= 10**2) {
356                 value /= 10**2;
357                 result += 2;
358             }
359             if (value >= 10**1) {
360                 result += 1;
361             }
362         }
363         return result;
364     }
365 
366     /**
367      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
368      * Returns 0 if given 0.
369      */
370     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
371         unchecked {
372             uint256 result = log10(value);
373             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
374         }
375     }
376 
377     /**
378      * @dev Return the log in base 256, rounded down, of a positive value.
379      * Returns 0 if given 0.
380      *
381      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
382      */
383     function log256(uint256 value) internal pure returns (uint256) {
384         uint256 result = 0;
385         unchecked {
386             if (value >> 128 > 0) {
387                 value >>= 128;
388                 result += 16;
389             }
390             if (value >> 64 > 0) {
391                 value >>= 64;
392                 result += 8;
393             }
394             if (value >> 32 > 0) {
395                 value >>= 32;
396                 result += 4;
397             }
398             if (value >> 16 > 0) {
399                 value >>= 16;
400                 result += 2;
401             }
402             if (value >> 8 > 0) {
403                 result += 1;
404             }
405         }
406         return result;
407     }
408 
409     /**
410      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
411      * Returns 0 if given 0.
412      */
413     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
414         unchecked {
415             uint256 result = log256(value);
416             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
417         }
418     }
419 }
420 
421 // File: @openzeppelin/contracts/utils/Strings.sol
422 
423 
424 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 
429 /**
430  * @dev String operations.
431  */
432 library Strings {
433     bytes16 private constant _SYMBOLS = "0123456789abcdef";
434     uint8 private constant _ADDRESS_LENGTH = 20;
435 
436     /**
437      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
438      */
439     function toString(uint256 value) internal pure returns (string memory) {
440         unchecked {
441             uint256 length = Math.log10(value) + 1;
442             string memory buffer = new string(length);
443             uint256 ptr;
444             /// @solidity memory-safe-assembly
445             assembly {
446                 ptr := add(buffer, add(32, length))
447             }
448             while (true) {
449                 ptr--;
450                 /// @solidity memory-safe-assembly
451                 assembly {
452                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
453                 }
454                 value /= 10;
455                 if (value == 0) break;
456             }
457             return buffer;
458         }
459     }
460 
461     /**
462      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
463      */
464     function toHexString(uint256 value) internal pure returns (string memory) {
465         unchecked {
466             return toHexString(value, Math.log256(value) + 1);
467         }
468     }
469 
470     /**
471      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
472      */
473     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
474         bytes memory buffer = new bytes(2 * length + 2);
475         buffer[0] = "0";
476         buffer[1] = "x";
477         for (uint256 i = 2 * length + 1; i > 1; --i) {
478             buffer[i] = _SYMBOLS[value & 0xf];
479             value >>= 4;
480         }
481         require(value == 0, "Strings: hex length insufficient");
482         return string(buffer);
483     }
484 
485     /**
486      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
487      */
488     function toHexString(address addr) internal pure returns (string memory) {
489         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
490     }
491 }
492 
493 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
494 
495 
496 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 
501 /**
502  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
503  *
504  * These functions can be used to verify that a message was signed by the holder
505  * of the private keys of a given address.
506  */
507 library ECDSA {
508     enum RecoverError {
509         NoError,
510         InvalidSignature,
511         InvalidSignatureLength,
512         InvalidSignatureS,
513         InvalidSignatureV // Deprecated in v4.8
514     }
515 
516     function _throwError(RecoverError error) private pure {
517         if (error == RecoverError.NoError) {
518             return; // no error: do nothing
519         } else if (error == RecoverError.InvalidSignature) {
520             revert("ECDSA: invalid signature");
521         } else if (error == RecoverError.InvalidSignatureLength) {
522             revert("ECDSA: invalid signature length");
523         } else if (error == RecoverError.InvalidSignatureS) {
524             revert("ECDSA: invalid signature 's' value");
525         }
526     }
527 
528     /**
529      * @dev Returns the address that signed a hashed message (`hash`) with
530      * `signature` or error string. This address can then be used for verification purposes.
531      *
532      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
533      * this function rejects them by requiring the `s` value to be in the lower
534      * half order, and the `v` value to be either 27 or 28.
535      *
536      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
537      * verification to be secure: it is possible to craft signatures that
538      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
539      * this is by receiving a hash of the original message (which may otherwise
540      * be too long), and then calling {toEthSignedMessageHash} on it.
541      *
542      * Documentation for signature generation:
543      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
544      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
545      *
546      * _Available since v4.3._
547      */
548     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
549         if (signature.length == 65) {
550             bytes32 r;
551             bytes32 s;
552             uint8 v;
553             // ecrecover takes the signature parameters, and the only way to get them
554             // currently is to use assembly.
555             /// @solidity memory-safe-assembly
556             assembly {
557                 r := mload(add(signature, 0x20))
558                 s := mload(add(signature, 0x40))
559                 v := byte(0, mload(add(signature, 0x60)))
560             }
561             return tryRecover(hash, v, r, s);
562         } else {
563             return (address(0), RecoverError.InvalidSignatureLength);
564         }
565     }
566 
567     /**
568      * @dev Returns the address that signed a hashed message (`hash`) with
569      * `signature`. This address can then be used for verification purposes.
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
580      */
581     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
582         (address recovered, RecoverError error) = tryRecover(hash, signature);
583         _throwError(error);
584         return recovered;
585     }
586 
587     /**
588      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
589      *
590      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
591      *
592      * _Available since v4.3._
593      */
594     function tryRecover(
595         bytes32 hash,
596         bytes32 r,
597         bytes32 vs
598     ) internal pure returns (address, RecoverError) {
599         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
600         uint8 v = uint8((uint256(vs) >> 255) + 27);
601         return tryRecover(hash, v, r, s);
602     }
603 
604     /**
605      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
606      *
607      * _Available since v4.2._
608      */
609     function recover(
610         bytes32 hash,
611         bytes32 r,
612         bytes32 vs
613     ) internal pure returns (address) {
614         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
615         _throwError(error);
616         return recovered;
617     }
618 
619     /**
620      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
621      * `r` and `s` signature fields separately.
622      *
623      * _Available since v4.3._
624      */
625     function tryRecover(
626         bytes32 hash,
627         uint8 v,
628         bytes32 r,
629         bytes32 s
630     ) internal pure returns (address, RecoverError) {
631         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
632         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
633         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
634         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
635         //
636         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
637         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
638         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
639         // these malleable signatures as well.
640         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
641             return (address(0), RecoverError.InvalidSignatureS);
642         }
643 
644         // If the signature is valid (and not malleable), return the signer address
645         address signer = ecrecover(hash, v, r, s);
646         if (signer == address(0)) {
647             return (address(0), RecoverError.InvalidSignature);
648         }
649 
650         return (signer, RecoverError.NoError);
651     }
652 
653     /**
654      * @dev Overload of {ECDSA-recover} that receives the `v`,
655      * `r` and `s` signature fields separately.
656      */
657     function recover(
658         bytes32 hash,
659         uint8 v,
660         bytes32 r,
661         bytes32 s
662     ) internal pure returns (address) {
663         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
664         _throwError(error);
665         return recovered;
666     }
667 
668     /**
669      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
670      * produces hash corresponding to the one signed with the
671      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
672      * JSON-RPC method as part of EIP-191.
673      *
674      * See {recover}.
675      */
676     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
677         // 32 is the length in bytes of hash,
678         // enforced by the type signature above
679         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
680     }
681 
682     /**
683      * @dev Returns an Ethereum Signed Message, created from `s`. This
684      * produces hash corresponding to the one signed with the
685      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
686      * JSON-RPC method as part of EIP-191.
687      *
688      * See {recover}.
689      */
690     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
691         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
692     }
693 
694     /**
695      * @dev Returns an Ethereum Signed Typed Data, created from a
696      * `domainSeparator` and a `structHash`. This produces hash corresponding
697      * to the one signed with the
698      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
699      * JSON-RPC method as part of EIP-712.
700      *
701      * See {recover}.
702      */
703     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
704         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
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
820 // File: @openzeppelin/contracts/utils/Address.sol
821 
822 
823 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
824 
825 pragma solidity ^0.8.1;
826 
827 /**
828  * @dev Collection of functions related to the address type
829  */
830 library Address {
831     /**
832      * @dev Returns true if `account` is a contract.
833      *
834      * [IMPORTANT]
835      * ====
836      * It is unsafe to assume that an address for which this function returns
837      * false is an externally-owned account (EOA) and not a contract.
838      *
839      * Among others, `isContract` will return false for the following
840      * types of addresses:
841      *
842      *  - an externally-owned account
843      *  - a contract in construction
844      *  - an address where a contract will be created
845      *  - an address where a contract lived, but was destroyed
846      * ====
847      *
848      * [IMPORTANT]
849      * ====
850      * You shouldn't rely on `isContract` to protect against flash loan attacks!
851      *
852      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
853      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
854      * constructor.
855      * ====
856      */
857     function isContract(address account) internal view returns (bool) {
858         // This method relies on extcodesize/address.code.length, which returns 0
859         // for contracts in construction, since the code is only stored at the end
860         // of the constructor execution.
861 
862         return account.code.length > 0;
863     }
864 
865     /**
866      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
867      * `recipient`, forwarding all available gas and reverting on errors.
868      *
869      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
870      * of certain opcodes, possibly making contracts go over the 2300 gas limit
871      * imposed by `transfer`, making them unable to receive funds via
872      * `transfer`. {sendValue} removes this limitation.
873      *
874      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
875      *
876      * IMPORTANT: because control is transferred to `recipient`, care must be
877      * taken to not create reentrancy vulnerabilities. Consider using
878      * {ReentrancyGuard} or the
879      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
880      */
881     function sendValue(address payable recipient, uint256 amount) internal {
882         require(address(this).balance >= amount, "Address: insufficient balance");
883 
884         (bool success, ) = recipient.call{value: amount}("");
885         require(success, "Address: unable to send value, recipient may have reverted");
886     }
887 
888     /**
889      * @dev Performs a Solidity function call using a low level `call`. A
890      * plain `call` is an unsafe replacement for a function call: use this
891      * function instead.
892      *
893      * If `target` reverts with a revert reason, it is bubbled up by this
894      * function (like regular Solidity function calls).
895      *
896      * Returns the raw returned data. To convert to the expected return value,
897      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
898      *
899      * Requirements:
900      *
901      * - `target` must be a contract.
902      * - calling `target` with `data` must not revert.
903      *
904      * _Available since v3.1._
905      */
906     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
907         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
908     }
909 
910     /**
911      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
912      * `errorMessage` as a fallback revert reason when `target` reverts.
913      *
914      * _Available since v3.1._
915      */
916     function functionCall(
917         address target,
918         bytes memory data,
919         string memory errorMessage
920     ) internal returns (bytes memory) {
921         return functionCallWithValue(target, data, 0, errorMessage);
922     }
923 
924     /**
925      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
926      * but also transferring `value` wei to `target`.
927      *
928      * Requirements:
929      *
930      * - the calling contract must have an ETH balance of at least `value`.
931      * - the called Solidity function must be `payable`.
932      *
933      * _Available since v3.1._
934      */
935     function functionCallWithValue(
936         address target,
937         bytes memory data,
938         uint256 value
939     ) internal returns (bytes memory) {
940         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
941     }
942 
943     /**
944      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
945      * with `errorMessage` as a fallback revert reason when `target` reverts.
946      *
947      * _Available since v3.1._
948      */
949     function functionCallWithValue(
950         address target,
951         bytes memory data,
952         uint256 value,
953         string memory errorMessage
954     ) internal returns (bytes memory) {
955         require(address(this).balance >= value, "Address: insufficient balance for call");
956         (bool success, bytes memory returndata) = target.call{value: value}(data);
957         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
958     }
959 
960     /**
961      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
962      * but performing a static call.
963      *
964      * _Available since v3.3._
965      */
966     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
967         return functionStaticCall(target, data, "Address: low-level static call failed");
968     }
969 
970     /**
971      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
972      * but performing a static call.
973      *
974      * _Available since v3.3._
975      */
976     function functionStaticCall(
977         address target,
978         bytes memory data,
979         string memory errorMessage
980     ) internal view returns (bytes memory) {
981         (bool success, bytes memory returndata) = target.staticcall(data);
982         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
983     }
984 
985     /**
986      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
987      * but performing a delegate call.
988      *
989      * _Available since v3.4._
990      */
991     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
992         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
993     }
994 
995     /**
996      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
997      * but performing a delegate call.
998      *
999      * _Available since v3.4._
1000      */
1001     function functionDelegateCall(
1002         address target,
1003         bytes memory data,
1004         string memory errorMessage
1005     ) internal returns (bytes memory) {
1006         (bool success, bytes memory returndata) = target.delegatecall(data);
1007         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
1008     }
1009 
1010     /**
1011      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
1012      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
1013      *
1014      * _Available since v4.8._
1015      */
1016     function verifyCallResultFromTarget(
1017         address target,
1018         bool success,
1019         bytes memory returndata,
1020         string memory errorMessage
1021     ) internal view returns (bytes memory) {
1022         if (success) {
1023             if (returndata.length == 0) {
1024                 // only check isContract if the call was successful and the return data is empty
1025                 // otherwise we already know that it was a contract
1026                 require(isContract(target), "Address: call to non-contract");
1027             }
1028             return returndata;
1029         } else {
1030             _revert(returndata, errorMessage);
1031         }
1032     }
1033 
1034     /**
1035      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1036      * revert reason or using the provided one.
1037      *
1038      * _Available since v4.3._
1039      */
1040     function verifyCallResult(
1041         bool success,
1042         bytes memory returndata,
1043         string memory errorMessage
1044     ) internal pure returns (bytes memory) {
1045         if (success) {
1046             return returndata;
1047         } else {
1048             _revert(returndata, errorMessage);
1049         }
1050     }
1051 
1052     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1053         // Look for revert reason and bubble it up if present
1054         if (returndata.length > 0) {
1055             // The easiest way to bubble the revert reason is using memory via assembly
1056             /// @solidity memory-safe-assembly
1057             assembly {
1058                 let returndata_size := mload(returndata)
1059                 revert(add(32, returndata), returndata_size)
1060             }
1061         } else {
1062             revert(errorMessage);
1063         }
1064     }
1065 }
1066 
1067 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1068 
1069 
1070 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1071 
1072 pragma solidity ^0.8.0;
1073 
1074 /**
1075  * @dev Interface of the ERC165 standard, as defined in the
1076  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1077  *
1078  * Implementers can declare support of contract interfaces, which can then be
1079  * queried by others ({ERC165Checker}).
1080  *
1081  * For an implementation, see {ERC165}.
1082  */
1083 interface IERC165 {
1084     /**
1085      * @dev Returns true if this contract implements the interface defined by
1086      * `interfaceId`. See the corresponding
1087      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1088      * to learn more about how these ids are created.
1089      *
1090      * This function call must use less than 30 000 gas.
1091      */
1092     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1093 }
1094 
1095 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
1096 
1097 
1098 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
1099 
1100 pragma solidity ^0.8.0;
1101 
1102 
1103 /**
1104  * @dev Interface for the NFT Royalty Standard.
1105  *
1106  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
1107  * support for royalty payments across all NFT marketplaces and ecosystem participants.
1108  *
1109  * _Available since v4.5._
1110  */
1111 interface IERC2981 is IERC165 {
1112     /**
1113      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
1114      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
1115      */
1116     function royaltyInfo(uint256 tokenId, uint256 salePrice)
1117         external
1118         view
1119         returns (address receiver, uint256 royaltyAmount);
1120 }
1121 
1122 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1123 
1124 
1125 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 /**
1131  * @dev Implementation of the {IERC165} interface.
1132  *
1133  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1134  * for the additional interface id that will be supported. For example:
1135  *
1136  * ```solidity
1137  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1138  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1139  * }
1140  * ```
1141  *
1142  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1143  */
1144 abstract contract ERC165 is IERC165 {
1145     /**
1146      * @dev See {IERC165-supportsInterface}.
1147      */
1148     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1149         return interfaceId == type(IERC165).interfaceId;
1150     }
1151 }
1152 
1153 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1154 
1155 
1156 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
1157 
1158 pragma solidity ^0.8.0;
1159 
1160 
1161 /**
1162  * @dev _Available since v3.1._
1163  */
1164 interface IERC1155Receiver is IERC165 {
1165     /**
1166      * @dev Handles the receipt of a single ERC1155 token type. This function is
1167      * called at the end of a `safeTransferFrom` after the balance has been updated.
1168      *
1169      * NOTE: To accept the transfer, this must return
1170      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1171      * (i.e. 0xf23a6e61, or its own function selector).
1172      *
1173      * @param operator The address which initiated the transfer (i.e. msg.sender)
1174      * @param from The address which previously owned the token
1175      * @param id The ID of the token being transferred
1176      * @param value The amount of tokens being transferred
1177      * @param data Additional data with no specified format
1178      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1179      */
1180     function onERC1155Received(
1181         address operator,
1182         address from,
1183         uint256 id,
1184         uint256 value,
1185         bytes calldata data
1186     ) external returns (bytes4);
1187 
1188     /**
1189      * @dev Handles the receipt of a multiple ERC1155 token types. This function
1190      * is called at the end of a `safeBatchTransferFrom` after the balances have
1191      * been updated.
1192      *
1193      * NOTE: To accept the transfer(s), this must return
1194      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1195      * (i.e. 0xbc197c81, or its own function selector).
1196      *
1197      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
1198      * @param from The address which previously owned the token
1199      * @param ids An array containing ids of each token being transferred (order and length must match values array)
1200      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
1201      * @param data Additional data with no specified format
1202      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1203      */
1204     function onERC1155BatchReceived(
1205         address operator,
1206         address from,
1207         uint256[] calldata ids,
1208         uint256[] calldata values,
1209         bytes calldata data
1210     ) external returns (bytes4);
1211 }
1212 
1213 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1214 
1215 
1216 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
1217 
1218 pragma solidity ^0.8.0;
1219 
1220 
1221 /**
1222  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1223  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1224  *
1225  * _Available since v3.1._
1226  */
1227 interface IERC1155 is IERC165 {
1228     /**
1229      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1230      */
1231     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1232 
1233     /**
1234      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1235      * transfers.
1236      */
1237     event TransferBatch(
1238         address indexed operator,
1239         address indexed from,
1240         address indexed to,
1241         uint256[] ids,
1242         uint256[] values
1243     );
1244 
1245     /**
1246      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1247      * `approved`.
1248      */
1249     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1250 
1251     /**
1252      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1253      *
1254      * If an {URI} event was emitted for `id`, the standard
1255      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1256      * returned by {IERC1155MetadataURI-uri}.
1257      */
1258     event URI(string value, uint256 indexed id);
1259 
1260     /**
1261      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1262      *
1263      * Requirements:
1264      *
1265      * - `account` cannot be the zero address.
1266      */
1267     function balanceOf(address account, uint256 id) external view returns (uint256);
1268 
1269     /**
1270      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1271      *
1272      * Requirements:
1273      *
1274      * - `accounts` and `ids` must have the same length.
1275      */
1276     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
1277         external
1278         view
1279         returns (uint256[] memory);
1280 
1281     /**
1282      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1283      *
1284      * Emits an {ApprovalForAll} event.
1285      *
1286      * Requirements:
1287      *
1288      * - `operator` cannot be the caller.
1289      */
1290     function setApprovalForAll(address operator, bool approved) external;
1291 
1292     /**
1293      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1294      *
1295      * See {setApprovalForAll}.
1296      */
1297     function isApprovedForAll(address account, address operator) external view returns (bool);
1298 
1299     /**
1300      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1301      *
1302      * Emits a {TransferSingle} event.
1303      *
1304      * Requirements:
1305      *
1306      * - `to` cannot be the zero address.
1307      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1308      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1309      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1310      * acceptance magic value.
1311      */
1312     function safeTransferFrom(
1313         address from,
1314         address to,
1315         uint256 id,
1316         uint256 amount,
1317         bytes calldata data
1318     ) external;
1319 
1320     /**
1321      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1322      *
1323      * Emits a {TransferBatch} event.
1324      *
1325      * Requirements:
1326      *
1327      * - `ids` and `amounts` must have the same length.
1328      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1329      * acceptance magic value.
1330      */
1331     function safeBatchTransferFrom(
1332         address from,
1333         address to,
1334         uint256[] calldata ids,
1335         uint256[] calldata amounts,
1336         bytes calldata data
1337     ) external;
1338 }
1339 
1340 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
1341 
1342 
1343 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/extensions/IERC1155MetadataURI.sol)
1344 
1345 pragma solidity ^0.8.0;
1346 
1347 
1348 /**
1349  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
1350  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
1351  *
1352  * _Available since v3.1._
1353  */
1354 interface IERC1155MetadataURI is IERC1155 {
1355     /**
1356      * @dev Returns the URI for token type `id`.
1357      *
1358      * If the `\{id\}` substring is present in the URI, it must be replaced by
1359      * clients with the actual token type ID.
1360      */
1361     function uri(uint256 id) external view returns (string memory);
1362 }
1363 
1364 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
1365 
1366 
1367 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC1155/ERC1155.sol)
1368 
1369 pragma solidity ^0.8.0;
1370 
1371 
1372 
1373 
1374 
1375 
1376 
1377 /**
1378  * @dev Implementation of the basic standard multi-token.
1379  * See https://eips.ethereum.org/EIPS/eip-1155
1380  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1381  *
1382  * _Available since v3.1._
1383  */
1384 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
1385     using Address for address;
1386 
1387     // Mapping from token ID to account balances
1388     mapping(uint256 => mapping(address => uint256)) private _balances;
1389 
1390     // Mapping from account to operator approvals
1391     mapping(address => mapping(address => bool)) private _operatorApprovals;
1392 
1393     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1394     string private _uri;
1395 
1396     /**
1397      * @dev See {_setURI}.
1398      */
1399     constructor(string memory uri_) {
1400         _setURI(uri_);
1401     }
1402 
1403     /**
1404      * @dev See {IERC165-supportsInterface}.
1405      */
1406     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1407         return
1408             interfaceId == type(IERC1155).interfaceId ||
1409             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1410             super.supportsInterface(interfaceId);
1411     }
1412 
1413     /**
1414      * @dev See {IERC1155MetadataURI-uri}.
1415      *
1416      * This implementation returns the same URI for *all* token types. It relies
1417      * on the token type ID substitution mechanism
1418      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1419      *
1420      * Clients calling this function must replace the `\{id\}` substring with the
1421      * actual token type ID.
1422      */
1423     function uri(uint256) public view virtual override returns (string memory) {
1424         return _uri;
1425     }
1426 
1427     /**
1428      * @dev See {IERC1155-balanceOf}.
1429      *
1430      * Requirements:
1431      *
1432      * - `account` cannot be the zero address.
1433      */
1434     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1435         require(account != address(0), "ERC1155: address zero is not a valid owner");
1436         return _balances[id][account];
1437     }
1438 
1439     /**
1440      * @dev See {IERC1155-balanceOfBatch}.
1441      *
1442      * Requirements:
1443      *
1444      * - `accounts` and `ids` must have the same length.
1445      */
1446     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1447         public
1448         view
1449         virtual
1450         override
1451         returns (uint256[] memory)
1452     {
1453         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1454 
1455         uint256[] memory batchBalances = new uint256[](accounts.length);
1456 
1457         for (uint256 i = 0; i < accounts.length; ++i) {
1458             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1459         }
1460 
1461         return batchBalances;
1462     }
1463 
1464     /**
1465      * @dev See {IERC1155-setApprovalForAll}.
1466      */
1467     function setApprovalForAll(address operator, bool approved) public virtual override {
1468         _setApprovalForAll(_msgSender(), operator, approved);
1469     }
1470 
1471     /**
1472      * @dev See {IERC1155-isApprovedForAll}.
1473      */
1474     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1475         return _operatorApprovals[account][operator];
1476     }
1477 
1478     /**
1479      * @dev See {IERC1155-safeTransferFrom}.
1480      */
1481     function safeTransferFrom(
1482         address from,
1483         address to,
1484         uint256 id,
1485         uint256 amount,
1486         bytes memory data
1487     ) public virtual override {
1488         require(
1489             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1490             "ERC1155: caller is not token owner or approved"
1491         );
1492         _safeTransferFrom(from, to, id, amount, data);
1493     }
1494 
1495     /**
1496      * @dev See {IERC1155-safeBatchTransferFrom}.
1497      */
1498     function safeBatchTransferFrom(
1499         address from,
1500         address to,
1501         uint256[] memory ids,
1502         uint256[] memory amounts,
1503         bytes memory data
1504     ) public virtual override {
1505         require(
1506             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1507             "ERC1155: caller is not token owner or approved"
1508         );
1509         _safeBatchTransferFrom(from, to, ids, amounts, data);
1510     }
1511 
1512     /**
1513      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1514      *
1515      * Emits a {TransferSingle} event.
1516      *
1517      * Requirements:
1518      *
1519      * - `to` cannot be the zero address.
1520      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1521      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1522      * acceptance magic value.
1523      */
1524     function _safeTransferFrom(
1525         address from,
1526         address to,
1527         uint256 id,
1528         uint256 amount,
1529         bytes memory data
1530     ) internal virtual {
1531         require(to != address(0), "ERC1155: transfer to the zero address");
1532 
1533         address operator = _msgSender();
1534         uint256[] memory ids = _asSingletonArray(id);
1535         uint256[] memory amounts = _asSingletonArray(amount);
1536 
1537         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1538 
1539         uint256 fromBalance = _balances[id][from];
1540         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1541         unchecked {
1542             _balances[id][from] = fromBalance - amount;
1543         }
1544         _balances[id][to] += amount;
1545 
1546         emit TransferSingle(operator, from, to, id, amount);
1547 
1548         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1549 
1550         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1551     }
1552 
1553     /**
1554      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1555      *
1556      * Emits a {TransferBatch} event.
1557      *
1558      * Requirements:
1559      *
1560      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1561      * acceptance magic value.
1562      */
1563     function _safeBatchTransferFrom(
1564         address from,
1565         address to,
1566         uint256[] memory ids,
1567         uint256[] memory amounts,
1568         bytes memory data
1569     ) internal virtual {
1570         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1571         require(to != address(0), "ERC1155: transfer to the zero address");
1572 
1573         address operator = _msgSender();
1574 
1575         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1576 
1577         for (uint256 i = 0; i < ids.length; ++i) {
1578             uint256 id = ids[i];
1579             uint256 amount = amounts[i];
1580 
1581             uint256 fromBalance = _balances[id][from];
1582             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
1583             unchecked {
1584                 _balances[id][from] = fromBalance - amount;
1585             }
1586             _balances[id][to] += amount;
1587         }
1588 
1589         emit TransferBatch(operator, from, to, ids, amounts);
1590 
1591         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1592 
1593         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1594     }
1595 
1596     /**
1597      * @dev Sets a new URI for all token types, by relying on the token type ID
1598      * substitution mechanism
1599      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1600      *
1601      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1602      * URI or any of the amounts in the JSON file at said URI will be replaced by
1603      * clients with the token type ID.
1604      *
1605      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1606      * interpreted by clients as
1607      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1608      * for token type ID 0x4cce0.
1609      *
1610      * See {uri}.
1611      *
1612      * Because these URIs cannot be meaningfully represented by the {URI} event,
1613      * this function emits no events.
1614      */
1615     function _setURI(string memory newuri) internal virtual {
1616         _uri = newuri;
1617     }
1618 
1619     /**
1620      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1621      *
1622      * Emits a {TransferSingle} event.
1623      *
1624      * Requirements:
1625      *
1626      * - `to` cannot be the zero address.
1627      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1628      * acceptance magic value.
1629      */
1630     function _mint(
1631         address to,
1632         uint256 id,
1633         uint256 amount,
1634         bytes memory data
1635     ) internal virtual {
1636         require(to != address(0), "ERC1155: mint to the zero address");
1637 
1638         address operator = _msgSender();
1639         uint256[] memory ids = _asSingletonArray(id);
1640         uint256[] memory amounts = _asSingletonArray(amount);
1641 
1642         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1643 
1644         _balances[id][to] += amount;
1645         emit TransferSingle(operator, address(0), to, id, amount);
1646 
1647         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1648 
1649         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1650     }
1651 
1652     /**
1653      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1654      *
1655      * Emits a {TransferBatch} event.
1656      *
1657      * Requirements:
1658      *
1659      * - `ids` and `amounts` must have the same length.
1660      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1661      * acceptance magic value.
1662      */
1663     function _mintBatch(
1664         address to,
1665         uint256[] memory ids,
1666         uint256[] memory amounts,
1667         bytes memory data
1668     ) internal virtual {
1669         require(to != address(0), "ERC1155: mint to the zero address");
1670         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1671 
1672         address operator = _msgSender();
1673 
1674         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1675 
1676         for (uint256 i = 0; i < ids.length; i++) {
1677             _balances[ids[i]][to] += amounts[i];
1678         }
1679 
1680         emit TransferBatch(operator, address(0), to, ids, amounts);
1681 
1682         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1683 
1684         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1685     }
1686 
1687     /**
1688      * @dev Destroys `amount` tokens of token type `id` from `from`
1689      *
1690      * Emits a {TransferSingle} event.
1691      *
1692      * Requirements:
1693      *
1694      * - `from` cannot be the zero address.
1695      * - `from` must have at least `amount` tokens of token type `id`.
1696      */
1697     function _burn(
1698         address from,
1699         uint256 id,
1700         uint256 amount
1701     ) internal virtual {
1702         require(from != address(0), "ERC1155: burn from the zero address");
1703 
1704         address operator = _msgSender();
1705         uint256[] memory ids = _asSingletonArray(id);
1706         uint256[] memory amounts = _asSingletonArray(amount);
1707 
1708         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1709 
1710         uint256 fromBalance = _balances[id][from];
1711         require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1712         unchecked {
1713             _balances[id][from] = fromBalance - amount;
1714         }
1715 
1716         emit TransferSingle(operator, from, address(0), id, amount);
1717 
1718         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1719     }
1720 
1721     /**
1722      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1723      *
1724      * Emits a {TransferBatch} event.
1725      *
1726      * Requirements:
1727      *
1728      * - `ids` and `amounts` must have the same length.
1729      */
1730     function _burnBatch(
1731         address from,
1732         uint256[] memory ids,
1733         uint256[] memory amounts
1734     ) internal virtual {
1735         require(from != address(0), "ERC1155: burn from the zero address");
1736         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1737 
1738         address operator = _msgSender();
1739 
1740         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1741 
1742         for (uint256 i = 0; i < ids.length; i++) {
1743             uint256 id = ids[i];
1744             uint256 amount = amounts[i];
1745 
1746             uint256 fromBalance = _balances[id][from];
1747             require(fromBalance >= amount, "ERC1155: burn amount exceeds balance");
1748             unchecked {
1749                 _balances[id][from] = fromBalance - amount;
1750             }
1751         }
1752 
1753         emit TransferBatch(operator, from, address(0), ids, amounts);
1754 
1755         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1756     }
1757 
1758     /**
1759      * @dev Approve `operator` to operate on all of `owner` tokens
1760      *
1761      * Emits an {ApprovalForAll} event.
1762      */
1763     function _setApprovalForAll(
1764         address owner,
1765         address operator,
1766         bool approved
1767     ) internal virtual {
1768         require(owner != operator, "ERC1155: setting approval status for self");
1769         _operatorApprovals[owner][operator] = approved;
1770         emit ApprovalForAll(owner, operator, approved);
1771     }
1772 
1773     /**
1774      * @dev Hook that is called before any token transfer. This includes minting
1775      * and burning, as well as batched variants.
1776      *
1777      * The same hook is called on both single and batched variants. For single
1778      * transfers, the length of the `ids` and `amounts` arrays will be 1.
1779      *
1780      * Calling conditions (for each `id` and `amount` pair):
1781      *
1782      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1783      * of token type `id` will be  transferred to `to`.
1784      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1785      * for `to`.
1786      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1787      * will be burned.
1788      * - `from` and `to` are never both zero.
1789      * - `ids` and `amounts` have the same, non-zero length.
1790      *
1791      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1792      */
1793     function _beforeTokenTransfer(
1794         address operator,
1795         address from,
1796         address to,
1797         uint256[] memory ids,
1798         uint256[] memory amounts,
1799         bytes memory data
1800     ) internal virtual {}
1801 
1802     /**
1803      * @dev Hook that is called after any token transfer. This includes minting
1804      * and burning, as well as batched variants.
1805      *
1806      * The same hook is called on both single and batched variants. For single
1807      * transfers, the length of the `id` and `amount` arrays will be 1.
1808      *
1809      * Calling conditions (for each `id` and `amount` pair):
1810      *
1811      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1812      * of token type `id` will be  transferred to `to`.
1813      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1814      * for `to`.
1815      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1816      * will be burned.
1817      * - `from` and `to` are never both zero.
1818      * - `ids` and `amounts` have the same, non-zero length.
1819      *
1820      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1821      */
1822     function _afterTokenTransfer(
1823         address operator,
1824         address from,
1825         address to,
1826         uint256[] memory ids,
1827         uint256[] memory amounts,
1828         bytes memory data
1829     ) internal virtual {}
1830 
1831     function _doSafeTransferAcceptanceCheck(
1832         address operator,
1833         address from,
1834         address to,
1835         uint256 id,
1836         uint256 amount,
1837         bytes memory data
1838     ) private {
1839         if (to.isContract()) {
1840             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1841                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1842                     revert("ERC1155: ERC1155Receiver rejected tokens");
1843                 }
1844             } catch Error(string memory reason) {
1845                 revert(reason);
1846             } catch {
1847                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1848             }
1849         }
1850     }
1851 
1852     function _doSafeBatchTransferAcceptanceCheck(
1853         address operator,
1854         address from,
1855         address to,
1856         uint256[] memory ids,
1857         uint256[] memory amounts,
1858         bytes memory data
1859     ) private {
1860         if (to.isContract()) {
1861             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1862                 bytes4 response
1863             ) {
1864                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1865                     revert("ERC1155: ERC1155Receiver rejected tokens");
1866                 }
1867             } catch Error(string memory reason) {
1868                 revert(reason);
1869             } catch {
1870                 revert("ERC1155: transfer to non-ERC1155Receiver implementer");
1871             }
1872         }
1873     }
1874 
1875     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
1876         uint256[] memory array = new uint256[](1);
1877         array[0] = element;
1878 
1879         return array;
1880     }
1881 }
1882 
1883 // File: contracts/rifters.sol
1884 
1885 
1886 // AE THER
1887 pragma solidity >=0.8;
1888 
1889 
1890 
1891 
1892 
1893 
1894 
1895 contract Keys is ERC1155, Ownable, ReentrancyGuard {
1896     using ECDSA for bytes32;
1897     using Strings for uint256;
1898     event Received(address, uint256);
1899     address private _recipient;
1900     // Contract name
1901     string public name;
1902     // Contract symbol
1903     string public symbol;
1904     uint256 public constant maxSupply = 10000;
1905     uint256 public Id;
1906     uint256 royaltyPercentage;
1907     string public baseUri;
1908     string public contractURI;
1909     string public extension;
1910     //mapping ID=>address => number of minted nfts
1911     mapping(address => uint8) public addresstxs;
1912     address signerAddress;
1913 
1914     constructor(
1915         string memory _Name,
1916         string memory _Symbol,
1917         string memory _contractURI,
1918         string memory _baseUri,
1919         address _signerAddress,
1920         string memory _extension,
1921         uint256 _royaltyPercentage
1922     ) ERC1155(_contractURI) {
1923         name = _Name;
1924         symbol = _Symbol;
1925         signerAddress = _signerAddress;
1926         contractURI = _contractURI;
1927         baseUri = _baseUri;
1928         extension = _extension;
1929         _recipient = owner();
1930         royaltyPercentage = _royaltyPercentage;
1931     }
1932 
1933     function validateAmount(uint256 _mintAmount) public view {
1934         require(Id + _mintAmount <= maxSupply, "Max supply exceeded");
1935     }
1936 
1937     function validateMintPerAddress(address sender) public view {
1938         require(addresstxs[sender] < 1, "max wallet supply");
1939     }
1940 
1941     function mint(bytes calldata signature) public payable nonReentrant {
1942         //Verify whitelist requirements dont allow mints when public sale starts
1943         //verify that the supply is not exceeded by address in specifc whitelist phase
1944         validateAmount(1);
1945         //can mint
1946         validateUsingECDASignature(signature);
1947         //change the phase
1948         validateMintPerAddress(msg.sender);
1949         //minting
1950         _mint(msg.sender, Id, 1, "");
1951         //updating balances
1952         Id += 1;
1953         addresstxs[msg.sender] += uint8(1);
1954     }
1955 
1956     function validateUsingECDASignature(bytes calldata signature) public view {
1957         bytes32 hash = keccak256(
1958             abi.encodePacked(bytes32(uint256(uint160(msg.sender))))
1959         );
1960         require(
1961             signerAddress == hash.toEthSignedMessageHash().recover(signature),
1962             "Signer address mismatch."
1963         );
1964     }
1965 
1966     function airdrop(address[] calldata recievers, uint256[] calldata amounts)
1967         external
1968         onlyOwner
1969     {
1970         require(recievers.length == amounts.length, "array length mismatch");
1971         for (uint256 i; i < recievers.length; i++) {
1972             airdropHelper(recievers[i], amounts[i]);
1973         }
1974     }
1975 
1976     //Normal minting allows minting on public sale satisfyign the necessary conditions
1977     function airdropHelper(address reciever, uint256 amount) private {
1978         require(amount >= 1, "nonzero airdrop");
1979         validateAmount(amount);
1980         if (amount == 1) {
1981             _mint(reciever, Id, 1, "");
1982             Id += 1;
1983         } else {
1984             uint256[] memory ids = new uint256[](amount);
1985             uint256[] memory values = new uint256[](amount);
1986             uint256 iterator = Id;
1987             for (uint256 i = 0; i < amount; i++) {
1988                 ids[i] = iterator; // line up Unique NFTs ID in  a array.
1989                 iterator = iterator + 1;
1990                 values[i] = 1; // for Unique Nfts  Supply of every ID MUST be one .1   to be injected in the _mintBatch function
1991             }
1992             Id += amount;
1993             _mintBatch(reciever, ids, values, "");
1994         }
1995     }
1996 
1997     function uri(uint256 _tokenId)
1998         public
1999         view
2000         override
2001         returns (string memory)
2002     {
2003         uint256 _tokenID = _tokenId + 1;
2004         require(_tokenId < Id, "Id deos not exist ");
2005         return
2006             bytes(baseUri).length > 0
2007                 ? string(
2008                     abi.encodePacked(baseUri, _tokenID.toString(), extension)
2009                 )
2010                 : "";
2011     }
2012 
2013     function setContractURI(string memory newContractURI)
2014         public
2015         onlyOwner
2016         nonReentrant
2017     {
2018         contractURI = newContractURI;
2019     }
2020 
2021     function setUri(string memory _uri) public onlyOwner nonReentrant {
2022         baseUri = _uri;
2023     }
2024 
2025     function setSignerAddress(address _signerAddress)
2026         public
2027         onlyOwner
2028         nonReentrant
2029     {
2030         signerAddress = _signerAddress;
2031     }
2032 
2033     function setExtension(string memory _extension)
2034         public
2035         onlyOwner
2036         nonReentrant
2037     {
2038         extension = _extension;
2039     }
2040 
2041     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
2042         external
2043         view
2044         returns (address receiver, uint256 royaltyAmount)
2045     {
2046         return (_recipient, (_salePrice * royaltyPercentage) / 10000);
2047     }
2048 
2049     function setRoyalityPercentage(uint256 _royaltyPercentage)
2050         public
2051         onlyOwner
2052         nonReentrant
2053     {
2054         royaltyPercentage = _royaltyPercentage;
2055     }
2056 
2057     // release address based on shares.
2058     function withdrawEth() external onlyOwner nonReentrant {
2059         (bool success, ) = msg.sender.call{value: address(this).balance}("");
2060         require(success, "Transfer failed.");
2061     }
2062 
2063     function supportsInterface(bytes4 interfaceId)
2064         public
2065         view
2066         virtual
2067         override(ERC1155)
2068         returns (bool)
2069     {
2070         return (interfaceId == type(IERC2981).interfaceId ||
2071             super.supportsInterface(interfaceId));
2072     }
2073 
2074     function _setRoyalties(address newRecipient) internal {
2075         require(
2076             newRecipient != address(0),
2077             "Royalties: new recipient is the zero address"
2078         );
2079         _recipient = newRecipient;
2080     }
2081 
2082     function setRoyalties(address newRecipient)
2083         external
2084         onlyOwner
2085         nonReentrant
2086     {
2087         _setRoyalties(newRecipient);
2088     }
2089 
2090     receive() external payable {
2091         emit Received(msg.sender, msg.value);
2092     }
2093 }