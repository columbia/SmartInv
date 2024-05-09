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
1364 // File: contracts/ERC1155D10000.sol
1365 
1366 
1367 // Donkeverse Contracts v0.0.1
1368 // AE THER
1369 pragma solidity ^0.8.0;
1370 
1371 
1372 
1373 
1374 
1375 
1376 
1377 
1378 /**
1379  * @dev Implementation of the basic standard multi-token.
1380  * See https://eips.ethereum.org/EIPS/eip-1155
1381  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
1382  *
1383  * _Available since v3.1._
1384  */
1385  // AE THER
1386 contract ERC1155D is Context, ERC165, IERC1155, IERC1155MetadataURI {
1387     using Address for address;
1388 
1389     uint256 public constant MAX_SUPPLY = 10000;
1390 
1391     address[MAX_SUPPLY+1] internal _owners;
1392 
1393     // Mapping from account to operator approvals
1394     mapping(address => mapping(address => bool)) private _operatorApprovals;
1395 
1396     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
1397     string private _uri;
1398 
1399     /**
1400      * @dev See {_setURI}.
1401      */
1402     constructor(string memory uri_) {
1403         _setURI(uri_);
1404     }
1405 
1406     /**
1407      * @dev See {IERC165-supportsInterface}.
1408      */
1409     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1410         return
1411             interfaceId == type(IERC1155).interfaceId ||
1412             interfaceId == type(IERC1155MetadataURI).interfaceId ||
1413             super.supportsInterface(interfaceId);
1414     }
1415 
1416     /**
1417      * @dev See {IERC1155MetadataURI-uri}.
1418      *
1419      * This implementation returns the same URI for *all* token types. It relies
1420      * on the token type ID substitution mechanism
1421      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1422      *
1423      * Clients calling this function must replace the `\{id\}` substring with the
1424      * actual token type ID.
1425      */
1426     function uri(uint256) public view virtual override returns (string memory) {
1427         return _uri;
1428     }
1429 
1430     /**
1431      * @dev See {IERC1155-balanceOf}.
1432      *
1433      * Requirements:
1434      *
1435      * - `account` cannot be the zero address.
1436      */
1437     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
1438         require(account != address(0), "ERC1155: balance query for the zero address");
1439         require(id < MAX_SUPPLY, "ERC1155D: id exceeds maximum");
1440 
1441         return _owners[id] == account ? 1 : 0;
1442     }
1443 
1444     /**
1445      * @dev See {IERC1155-balanceOfBatch}.
1446      *
1447      * Requirements:
1448      *
1449      * - `accounts` and `ids` must have the same length.
1450      */
1451     function balanceOfBatch(address[] memory accounts, uint256[] memory ids)
1452         public
1453         view
1454         virtual
1455         override
1456         returns (uint256[] memory)
1457     {
1458         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
1459 
1460         uint256[] memory batchBalances = new uint256[](accounts.length);
1461 
1462         for (uint256 i = 0; i < accounts.length; ++i) {
1463             batchBalances[i] = balanceOf(accounts[i], ids[i]);
1464         }
1465 
1466         return batchBalances;
1467     }
1468 
1469     /**
1470      * @dev See {IERC1155-setApprovalForAll}.
1471      */
1472     function setApprovalForAll(address operator, bool approved) public virtual override {
1473         _setApprovalForAll(_msgSender(), operator, approved);
1474     }
1475 
1476     /**
1477      * @dev See {IERC1155-isApprovedForAll}.
1478      */
1479     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
1480         return _operatorApprovals[account][operator];
1481     }
1482 
1483     /**
1484      * @dev See {IERC1155-safeTransferFrom}.
1485      */
1486     function safeTransferFrom(
1487         address from,
1488         address to,
1489         uint256 id,
1490         uint256 amount,
1491         bytes memory data
1492     ) public virtual override {
1493         require(
1494             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1495             "ERC1155: caller is not owner nor approved"
1496         );
1497         _safeTransferFrom(from, to, id, amount, data);
1498     }
1499 
1500     /**
1501      * @dev See {IERC1155-safeBatchTransferFrom}.
1502      */
1503     function safeBatchTransferFrom(
1504         address from,
1505         address to,
1506         uint256[] memory ids,
1507         uint256[] memory amounts,
1508         bytes memory data
1509     ) public virtual override {
1510         require(
1511             from == _msgSender() || isApprovedForAll(from, _msgSender()),
1512             "ERC1155: transfer caller is not owner nor approved"
1513         );
1514         _safeBatchTransferFrom(from, to, ids, amounts, data);
1515     }
1516 
1517     /**
1518      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1519      *
1520      * Emits a {TransferSingle} event.
1521      *
1522      * Requirements:
1523      *
1524      * - `to` cannot be the zero address.
1525      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1526      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1527      * acceptance magic value.
1528      */
1529     function _safeTransferFrom(
1530         address from,
1531         address to,
1532         uint256 id,
1533         uint256 amount,
1534         bytes memory data
1535     ) internal virtual {
1536         require(to != address(0), "ERC1155: transfer to the zero address");
1537 
1538         address operator = _msgSender();
1539         uint256[] memory ids = _asSingletonArray(id);
1540         uint256[] memory amounts = _asSingletonArray(amount);
1541 
1542         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1543 
1544         require(_owners[id] == from && amount < 2, "ERC1155: insufficient balance for transfer");
1545 
1546         // The ERC1155 spec allows for transfering zero tokens, but we are still expected
1547         // to run the other checks and emit the event. But we don't want an ownership change
1548         // in that case
1549         if (amount == 1) {
1550             _owners[id] = to;
1551         }
1552 
1553         emit TransferSingle(operator, from, to, id, amount);
1554 
1555         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1556 
1557         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
1558     }
1559 
1560     /**
1561      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_safeTransferFrom}.
1562      *
1563      * Emits a {TransferBatch} event.
1564      *
1565      * Requirements:
1566      *
1567      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1568      * acceptance magic value.
1569      */
1570     function _safeBatchTransferFrom(
1571         address from,
1572         address to,
1573         uint256[] memory ids,
1574         uint256[] memory amounts,
1575         bytes memory data
1576     ) internal virtual {
1577         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1578         require(to != address(0), "ERC1155: transfer to the zero address");
1579 
1580         address operator = _msgSender();
1581 
1582         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
1583 
1584         for (uint256 i = 0; i < ids.length; ++i) {
1585             uint256 id = ids[i];
1586 
1587             require(_owners[id] == from && amounts[i] < 2, "ERC1155: insufficient balance for transfer");
1588 
1589             if (amounts[i] == 1) {
1590                 _owners[id] = to;
1591             }
1592         }
1593 
1594         emit TransferBatch(operator, from, to, ids, amounts);
1595 
1596         _afterTokenTransfer(operator, from, to, ids, amounts, data);
1597 
1598         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
1599     }
1600 
1601     /**
1602      * @dev Sets a new URI for all token types, by relying on the token type ID
1603      * substitution mechanism
1604      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
1605      *
1606      * By this mechanism, any occurrence of the `\{id\}` substring in either the
1607      * URI or any of the amounts in the JSON file at said URI will be replaced by
1608      * clients with the token type ID.
1609      *
1610      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
1611      * interpreted by clients as
1612      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
1613      * for token type ID 0x4cce0.
1614      *
1615      * See {uri}.
1616      *
1617      * Because these URIs cannot be meaningfully represented by the {URI} event,
1618      * this function emits no events.
1619      */
1620     function _setURI(string memory newuri) internal virtual {
1621         _uri = newuri;
1622     }
1623 
1624     /**
1625      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1626      *
1627      * Emits a {TransferSingle} event.
1628      *
1629      * Requirements:
1630      *
1631      * - `to` cannot be the zero address.
1632      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1633      * acceptance magic value.
1634      */
1635 
1636     function _mint(
1637         address to,
1638         uint256 id,
1639         uint256 amount,
1640         bytes memory data
1641     ) internal virtual {
1642         require(to != address(0), "ERC1155: mint to the zero address");
1643         require(amount < 2, "ERC1155D: exceeds supply");
1644         require(id < MAX_SUPPLY, "ERC1155D: invalid id");
1645 
1646         address operator = _msgSender();
1647         uint256[] memory ids = _asSingletonArray(id);
1648         uint256[] memory amounts = _asSingletonArray(amount);
1649 
1650         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1651 
1652         // The ERC1155 spec allows for transfering zero tokens, but we are still expected
1653         // to run the other checks and emit the event. But we don't want an ownership change
1654         // in that case
1655         if (amount == 1) {
1656             _owners[id] = to;
1657         }
1658 
1659         emit TransferSingle(operator, address(0), to, id, amount);
1660 
1661         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1662 
1663         _doSafeTransferAcceptanceCheck(operator, address(0), to, id, amount, data);
1664     }
1665 
1666     /**
1667      * @dev Creates `amount` tokens of token type `id`, and assigns them to `to`.
1668      *
1669      * Emits a {TransferSingle} event.
1670      *
1671      * Requirements:
1672      *
1673      * - `to` cannot be the zero address.
1674      * - `id` must be less than MAX_SUPPLY;
1675      * This does not implement smart contract checks according to ERC1155 so it exists as a separate function
1676      */
1677 
1678     function _mintSingle(address to, uint256 id) internal virtual {
1679         require(to != address(0), "ERC1155: mint to the zero address"); // you can remove this if only minting to msg.sender
1680         require(_owners[id] == address(0), "ERC1155D: supply exceeded");
1681         require(id > 0, "ERC1155D: invalid id 0"); 
1682         _owners[id] = to; // this can be made more efficient with assembly if you know what you are doing!
1683         emit TransferSingle(to, address(0), to, id, 1);
1684     }
1685 
1686     /**
1687      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
1688      *
1689      * Requirements:
1690      *
1691      * - `ids` and `amounts` must have the same length.
1692      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1693      * acceptance magic value.
1694      */
1695     function _mintBatch(
1696         address to,
1697         uint256[] memory ids,
1698         uint256[] memory amounts,
1699         bytes memory data
1700     ) internal virtual {
1701         require(to != address(0), "ERC1155: mint to the zero address");
1702         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1703 
1704         address operator = _msgSender();
1705 
1706         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
1707 
1708         for (uint256 i = 0; i < ids.length; i++) {
1709             require(amounts[i] < 2, "ERC1155D: exceeds supply");
1710             require(_owners[ids[i]] == address(0), "ERC1155D: supply exceeded");
1711 
1712             if (amounts[i] == 1) {
1713                 _owners[ids[i]] = to;
1714             }
1715         }
1716 
1717         emit TransferBatch(operator, address(0), to, ids, amounts);
1718 
1719         _afterTokenTransfer(operator, address(0), to, ids, amounts, data);
1720 
1721         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
1722     }
1723 
1724     /**
1725      * @dev Destroys `amount` tokens of token type `id` from `from`
1726      *
1727      * Requirements:
1728      *
1729      * - `from` cannot be the zero address.
1730      * - `from` must have at least `amount` tokens of token type `id`.
1731      */
1732     function _burn(
1733         address from,
1734         uint256 id,
1735         uint256 amount
1736     ) internal virtual {
1737         require(from != address(0), "ERC1155: burn from the zero address");
1738 
1739         address operator = _msgSender();
1740         uint256[] memory ids = _asSingletonArray(id);
1741         uint256[] memory amounts = _asSingletonArray(amount);
1742 
1743         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1744 
1745         require(_owners[id] == from && amount < 2, "ERC1155: burn amount exceeds balance");
1746         if (amount == 1) {
1747             _owners[id] = address(0);
1748         }
1749 
1750         emit TransferSingle(operator, from, address(0), id, amount);
1751 
1752         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1753     }
1754 
1755     /**
1756      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
1757      *
1758      * Requirements:
1759      *
1760      * - `ids` and `amounts` must have the same length.
1761      */
1762     function _burnBatch(
1763         address from,
1764         uint256[] memory ids,
1765         uint256[] memory amounts
1766     ) internal virtual {
1767         require(from != address(0), "ERC1155: burn from the zero address");
1768         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
1769 
1770         address operator = _msgSender();
1771 
1772         _beforeTokenTransfer(operator, from, address(0), ids, amounts, "");
1773 
1774         for (uint256 i = 0; i < ids.length; i++) {
1775             uint256 id = ids[i];
1776             require(_owners[id] == from && amounts[i] < 2, "ERC1155: burn amount exceeds balance");
1777             if (amounts[i] == 1) {
1778                 _owners[id] = address(0);
1779             }
1780         }
1781 
1782         emit TransferBatch(operator, from, address(0), ids, amounts);
1783 
1784         _afterTokenTransfer(operator, from, address(0), ids, amounts, "");
1785     }
1786 
1787     /**
1788      * @dev Approve `operator` to operate on all of `owner` tokens
1789      *
1790      * Emits a {ApprovalForAll} event.
1791      */
1792     function _setApprovalForAll(
1793         address owner,
1794         address operator,
1795         bool approved
1796     ) internal virtual {
1797         require(owner != operator, "ERC1155: setting approval status for self");
1798         _operatorApprovals[owner][operator] = approved;
1799         emit ApprovalForAll(owner, operator, approved);
1800     }
1801 
1802     /**
1803      * @dev Hook that is called before any token transfer. This includes minting
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
1822     function _beforeTokenTransfer(
1823         address operator,
1824         address from,
1825         address to,
1826         uint256[] memory ids,
1827         uint256[] memory amounts,
1828         bytes memory data
1829     ) internal virtual {}
1830 
1831     /**
1832      * @dev Hook that is called after any token transfer. This includes minting
1833      * and burning, as well as batched variants.
1834      *
1835      * The same hook is called on both single and batched variants. For single
1836      * transfers, the length of the `id` and `amount` arrays will be 1.
1837      *
1838      * Calling conditions (for each `id` and `amount` pair):
1839      *
1840      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1841      * of token type `id` will be  transferred to `to`.
1842      * - When `from` is zero, `amount` tokens of token type `id` will be minted
1843      * for `to`.
1844      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
1845      * will be burned.
1846      * - `from` and `to` are never both zero.
1847      * - `ids` and `amounts` have the same, non-zero length.
1848      *
1849      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1850      */
1851     function _afterTokenTransfer(
1852         address operator,
1853         address from,
1854         address to,
1855         uint256[] memory ids,
1856         uint256[] memory amounts,
1857         bytes memory data
1858     ) internal virtual {}
1859 
1860     function _doSafeTransferAcceptanceCheck(
1861         address operator,
1862         address from,
1863         address to,
1864         uint256 id,
1865         uint256 amount,
1866         bytes memory data
1867     ) private {
1868         if (to.isContract()) {
1869             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
1870                 if (response != IERC1155Receiver.onERC1155Received.selector) {
1871                     revert("ERC1155: ERC1155Receiver rejected tokens");
1872                 }
1873             } catch Error(string memory reason) {
1874                 revert(reason);
1875             } catch {
1876                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1877             }
1878         }
1879     }
1880 
1881     function _doSafeBatchTransferAcceptanceCheck(
1882         address operator,
1883         address from,
1884         address to,
1885         uint256[] memory ids,
1886         uint256[] memory amounts,
1887         bytes memory data
1888     ) private {
1889         if (to.isContract()) {
1890             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (
1891                 bytes4 response
1892             ) {
1893                 if (response != IERC1155Receiver.onERC1155BatchReceived.selector) {
1894                     revert("ERC1155: ERC1155Receiver rejected tokens");
1895                 }
1896             } catch Error(string memory reason) {
1897                 revert(reason);
1898             } catch {
1899                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
1900             }
1901         }
1902     }
1903 
1904     function _asSingletonArray(uint256 element) internal pure returns (uint256[] memory) {
1905         uint256[] memory array = new uint256[](1);
1906         array[0] = element;
1907 
1908         return array;
1909     }
1910 
1911     function _prepayGas(uint256 start, uint256 end) internal {
1912         require(end <= MAX_SUPPLY, "ERC1155D: end id exceeds maximum");
1913 
1914         for (uint256 i = start; i < end; i++) {
1915 
1916             bytes32 slotValue;
1917             assembly {
1918                 slotValue := sload(add(_owners.slot, i))
1919             }
1920 
1921             bytes32 leftmostBitSetToOne = slotValue | bytes32(uint256(1) << 255);
1922             assembly {
1923                 sstore(add(_owners.slot, i), leftmostBitSetToOne)
1924             }
1925         }
1926     }
1927 
1928     function getOwnershipRecordOffChain() external view returns(address[MAX_SUPPLY+1] memory) {
1929         return _owners;
1930     }
1931 
1932     function ownerOfERC721Like(uint256 id) external view returns(address) {
1933         require(id < _owners.length, "ERC1155D: id exceeds maximum");
1934         address owner = _owners[id];
1935         require(owner != address(0), "ERC1155D: owner query for nonexistent token");
1936         return owner;
1937     }
1938 
1939     function getERC721BalanceOffChain(address _address) external view returns(uint256) {
1940         uint256 counter = 0;
1941         for (uint256 i; i < _owners.length; i++) {
1942             if (_owners[i] == _address) {
1943                 counter++;
1944             }
1945         }
1946         return counter;
1947     }
1948 }
1949 // File: contracts/Outlanders.sol
1950 
1951   pragma solidity >=0.8;
1952 
1953   interface IKeys {
1954     function balanceOf(address account, uint256 id) external returns (uint256);
1955 
1956     function safeTransferFrom(
1957       address from,
1958       address to,
1959       uint256 id,
1960       uint256 amount,
1961       bytes memory data
1962     ) external;
1963   }
1964 
1965   //AE THER
1966   pragma solidity >=0.8;
1967 
1968 
1969 
1970 
1971 
1972   contract Outlanders is ERC1155D, Ownable, ReentrancyGuard {
1973     using ECDSA for bytes32;
1974     using Strings for uint256;
1975     event Received(address, uint256);
1976     event claimNftWithKey(uint256 tokenId, uint256 keyId);
1977     event claimNftWithIndex(uint256 tokenId, uint256 Index);
1978     // Contract name
1979     string public name;
1980     // Contract symbol
1981     string public symbol;
1982     uint256 public count;
1983     string public baseUri;
1984     string public contractURI;
1985     string public extension;
1986     address public keyReceiver;
1987     address private _recipient;
1988     address signerAddress;
1989     uint256 royaltyPercentage;
1990     IKeys public immutable keys;
1991 
1992     constructor(
1993       string memory _Name,
1994       string memory _Symbol,
1995       string memory _contractURI,
1996       string memory _baseUri,
1997       address _signerAddress,
1998       address _keyReceiver,
1999       address Keys,
2000       uint256 _royaltyPercentage,
2001       string memory _extension
2002     ) ERC1155D(_contractURI) {
2003       name = _Name;
2004       symbol = _Symbol;
2005       signerAddress = _signerAddress;
2006       contractURI = _contractURI;
2007       baseUri = _baseUri;
2008       keyReceiver = _keyReceiver;
2009       keys = IKeys(Keys);
2010       _recipient = owner();
2011       royaltyPercentage = _royaltyPercentage;
2012       extension = _extension;
2013     }
2014 
2015     function validateUsingECDASignature(
2016       bytes calldata signature,
2017       uint256 tokenId,
2018       uint256 id
2019     ) public view {
2020       bytes32 hash = keccak256(
2021         abi.encodePacked(bytes32(uint256(uint160(msg.sender))), tokenId, id)
2022       );
2023       require(
2024         signerAddress == hash.toEthSignedMessageHash().recover(signature),
2025         "Signer address mismatch."
2026       );
2027     }
2028 
2029     function validateKeyOwnership(address sender, uint256 keyId) public {
2030       require(keys.balanceOf(sender, keyId) == 1, "user is not owner of nft_id");
2031     }
2032 
2033     function mintWithKey(
2034       bytes calldata signature,
2035       uint256 tokenId,
2036       uint256 keyId
2037     ) public payable nonReentrant {
2038       //can mint
2039       validateUsingECDASignature(signature, tokenId, keyId);
2040       //verify that owner of Keys nfts
2041       validateKeyOwnership(msg.sender, keyId);
2042       //transfering keys nft
2043       keys.safeTransferFrom(msg.sender, keyReceiver, keyId, 1, "");
2044       //minting
2045       _mintSingle(msg.sender, tokenId);
2046       //loggin tokenID and KeyId
2047       emit claimNftWithKey(tokenId, keyId);
2048     }
2049 
2050       function mintWithIndex(
2051       bytes calldata signature,
2052       uint256 tokenId,
2053       uint256 index
2054     ) public payable nonReentrant {
2055       //can mint
2056       validateUsingECDASignature(signature, tokenId, index);
2057       //minting
2058       _mintSingle(msg.sender, tokenId);
2059       //loggin tokenID and KeyId
2060       emit claimNftWithIndex(tokenId, index);
2061     }
2062 
2063 
2064     function burn(
2065       address from,
2066       uint256 id,
2067       uint256 amount
2068     ) public {
2069       _burn(from, id, amount);
2070     }
2071 
2072     function burnBatch(
2073       address from,
2074       uint256[] memory ids,
2075       uint256[] memory amounts
2076     ) public {
2077       _burnBatch(from, ids, amounts);
2078     }
2079 
2080     //Normal minting allows minting on public sale satisfyign the necessary conditions
2081     function airdrop(address reciever, uint256[] memory tokenIds)
2082       external
2083       onlyOwner
2084     {
2085       uint256 amount = tokenIds.length;
2086       require(amount >= 1, "nonzero airdrop");
2087       if (amount == 1) {
2088         _mintSingle(reciever, tokenIds[0]);
2089       } else {
2090         uint256[] memory values = new uint256[](amount);
2091         for (uint256 i = 0; i < amount; i++) {
2092           values[i] = 1;
2093         }
2094         _mintBatch(reciever, tokenIds, values, "");
2095       }
2096     }
2097 
2098     function uri(uint256 _tokenId) public view override returns (string memory) {
2099       require(_owners[_tokenId] != address(0), "tokenId does not exist");
2100       return
2101         bytes(baseUri).length > 0
2102           ? string(abi.encodePacked(baseUri, _tokenId.toString(), extension))
2103           : "";
2104     }
2105 
2106     function setExtension(string memory _extension) public onlyOwner nonReentrant{
2107       extension = _extension;
2108     }
2109 
2110     function setContractURI(string memory newContractURI)
2111       public
2112       onlyOwner
2113       nonReentrant
2114     {
2115       contractURI = newContractURI;
2116     }
2117 
2118     function setUri(string memory _uri) public onlyOwner nonReentrant {
2119       baseUri = _uri;
2120     }
2121 
2122     function setSignerAddress(address _signerAddress)
2123       public
2124       onlyOwner
2125       nonReentrant
2126     {
2127       signerAddress = _signerAddress;
2128     }
2129 
2130     function setKeyReceiver(address _newKeyReceiver)
2131       public
2132       onlyOwner
2133       nonReentrant
2134     {
2135       keyReceiver = _newKeyReceiver;
2136     }
2137 
2138     function royaltyInfo(uint256 _tokenId, uint256 _salePrice)
2139       external
2140       view
2141       returns (address receiver, uint256 royaltyAmount)
2142     {
2143       return (_recipient, (_salePrice * royaltyPercentage) / 10000);
2144     }
2145 
2146     function setRoyalityPercentage(uint256 _royaltyPercentage) public onlyOwner nonReentrant{
2147       royaltyPercentage = _royaltyPercentage;
2148     }
2149 
2150     function supportsInterface(bytes4 interfaceId)
2151       public
2152       view
2153       virtual
2154       override(ERC1155D)
2155       returns (bool)
2156     {
2157       return (interfaceId == type(IERC2981).interfaceId ||
2158         super.supportsInterface(interfaceId));
2159     }
2160 
2161     function _setRoyalties(address newRecipient) internal {
2162       require(
2163         newRecipient != address(0),
2164         "Royalties: new recipient is the zero address"
2165       );
2166       _recipient = newRecipient;
2167     }
2168 
2169     function setRoyalties(address newRecipient) external onlyOwner nonReentrant {
2170       _setRoyalties(newRecipient);
2171     }
2172     // release address based on shares.
2173     function withdrawEth() external onlyOwner nonReentrant {
2174       (bool success, ) = msg.sender.call{value: address(this).balance}("");
2175       require(success, "Transfer failed.");
2176     }
2177     
2178     receive() external payable {
2179       emit Received(msg.sender, msg.value);
2180     }
2181   }