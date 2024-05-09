1 // File: @openzeppelin/contracts/utils/Counters.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @title Counters
10  * @author Matt Condon (@shrugs)
11  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
12  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
13  *
14  * Include with `using Counters for Counters.Counter;`
15  */
16 library Counters {
17     struct Counter {
18         // This variable should never be directly accessed by users of the library: interactions must be restricted to
19         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
20         // this feature: see https://github.com/ethereum/solidity/issues/4637
21         uint256 _value; // default: 0
22     }
23 
24     function current(Counter storage counter) internal view returns (uint256) {
25         return counter._value;
26     }
27 
28     function increment(Counter storage counter) internal {
29         unchecked {
30             counter._value += 1;
31         }
32     }
33 
34     function decrement(Counter storage counter) internal {
35         uint256 value = counter._value;
36         require(value > 0, "Counter: decrement overflow");
37         unchecked {
38             counter._value = value - 1;
39         }
40     }
41 
42     function reset(Counter storage counter) internal {
43         counter._value = 0;
44     }
45 }
46 
47 // File: @openzeppelin/contracts/utils/math/Math.sol
48 
49 
50 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
51 
52 pragma solidity ^0.8.0;
53 
54 /**
55  * @dev Standard math utilities missing in the Solidity language.
56  */
57 library Math {
58     enum Rounding {
59         Down, // Toward negative infinity
60         Up, // Toward infinity
61         Zero // Toward zero
62     }
63 
64     /**
65      * @dev Returns the largest of two numbers.
66      */
67     function max(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a > b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the smallest of two numbers.
73      */
74     function min(uint256 a, uint256 b) internal pure returns (uint256) {
75         return a < b ? a : b;
76     }
77 
78     /**
79      * @dev Returns the average of two numbers. The result is rounded towards
80      * zero.
81      */
82     function average(uint256 a, uint256 b) internal pure returns (uint256) {
83         // (a + b) / 2 can overflow.
84         return (a & b) + (a ^ b) / 2;
85     }
86 
87     /**
88      * @dev Returns the ceiling of the division of two numbers.
89      *
90      * This differs from standard division with `/` in that it rounds up instead
91      * of rounding down.
92      */
93     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
94         // (a + b - 1) / b can overflow on addition, so we distribute.
95         return a == 0 ? 0 : (a - 1) / b + 1;
96     }
97 
98     /**
99      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
100      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
101      * with further edits by Uniswap Labs also under MIT license.
102      */
103     function mulDiv(
104         uint256 x,
105         uint256 y,
106         uint256 denominator
107     ) internal pure returns (uint256 result) {
108         unchecked {
109             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
110             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
111             // variables such that product = prod1 * 2^256 + prod0.
112             uint256 prod0; // Least significant 256 bits of the product
113             uint256 prod1; // Most significant 256 bits of the product
114             assembly {
115                 let mm := mulmod(x, y, not(0))
116                 prod0 := mul(x, y)
117                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
118             }
119 
120             // Handle non-overflow cases, 256 by 256 division.
121             if (prod1 == 0) {
122                 return prod0 / denominator;
123             }
124 
125             // Make sure the result is less than 2^256. Also prevents denominator == 0.
126             require(denominator > prod1);
127 
128             ///////////////////////////////////////////////
129             // 512 by 256 division.
130             ///////////////////////////////////////////////
131 
132             // Make division exact by subtracting the remainder from [prod1 prod0].
133             uint256 remainder;
134             assembly {
135                 // Compute remainder using mulmod.
136                 remainder := mulmod(x, y, denominator)
137 
138                 // Subtract 256 bit number from 512 bit number.
139                 prod1 := sub(prod1, gt(remainder, prod0))
140                 prod0 := sub(prod0, remainder)
141             }
142 
143             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
144             // See https://cs.stackexchange.com/q/138556/92363.
145 
146             // Does not overflow because the denominator cannot be zero at this stage in the function.
147             uint256 twos = denominator & (~denominator + 1);
148             assembly {
149                 // Divide denominator by twos.
150                 denominator := div(denominator, twos)
151 
152                 // Divide [prod1 prod0] by twos.
153                 prod0 := div(prod0, twos)
154 
155                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
156                 twos := add(div(sub(0, twos), twos), 1)
157             }
158 
159             // Shift in bits from prod1 into prod0.
160             prod0 |= prod1 * twos;
161 
162             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
163             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
164             // four bits. That is, denominator * inv = 1 mod 2^4.
165             uint256 inverse = (3 * denominator) ^ 2;
166 
167             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
168             // in modular arithmetic, doubling the correct bits in each step.
169             inverse *= 2 - denominator * inverse; // inverse mod 2^8
170             inverse *= 2 - denominator * inverse; // inverse mod 2^16
171             inverse *= 2 - denominator * inverse; // inverse mod 2^32
172             inverse *= 2 - denominator * inverse; // inverse mod 2^64
173             inverse *= 2 - denominator * inverse; // inverse mod 2^128
174             inverse *= 2 - denominator * inverse; // inverse mod 2^256
175 
176             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
177             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
178             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
179             // is no longer required.
180             result = prod0 * inverse;
181             return result;
182         }
183     }
184 
185     /**
186      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
187      */
188     function mulDiv(
189         uint256 x,
190         uint256 y,
191         uint256 denominator,
192         Rounding rounding
193     ) internal pure returns (uint256) {
194         uint256 result = mulDiv(x, y, denominator);
195         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
196             result += 1;
197         }
198         return result;
199     }
200 
201     /**
202      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
203      *
204      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
205      */
206     function sqrt(uint256 a) internal pure returns (uint256) {
207         if (a == 0) {
208             return 0;
209         }
210 
211         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
212         //
213         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
214         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
215         //
216         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
217         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
218         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
219         //
220         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
221         uint256 result = 1 << (log2(a) >> 1);
222 
223         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
224         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
225         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
226         // into the expected uint128 result.
227         unchecked {
228             result = (result + a / result) >> 1;
229             result = (result + a / result) >> 1;
230             result = (result + a / result) >> 1;
231             result = (result + a / result) >> 1;
232             result = (result + a / result) >> 1;
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             return min(result, a / result);
236         }
237     }
238 
239     /**
240      * @notice Calculates sqrt(a), following the selected rounding direction.
241      */
242     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
243         unchecked {
244             uint256 result = sqrt(a);
245             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
246         }
247     }
248 
249     /**
250      * @dev Return the log in base 2, rounded down, of a positive value.
251      * Returns 0 if given 0.
252      */
253     function log2(uint256 value) internal pure returns (uint256) {
254         uint256 result = 0;
255         unchecked {
256             if (value >> 128 > 0) {
257                 value >>= 128;
258                 result += 128;
259             }
260             if (value >> 64 > 0) {
261                 value >>= 64;
262                 result += 64;
263             }
264             if (value >> 32 > 0) {
265                 value >>= 32;
266                 result += 32;
267             }
268             if (value >> 16 > 0) {
269                 value >>= 16;
270                 result += 16;
271             }
272             if (value >> 8 > 0) {
273                 value >>= 8;
274                 result += 8;
275             }
276             if (value >> 4 > 0) {
277                 value >>= 4;
278                 result += 4;
279             }
280             if (value >> 2 > 0) {
281                 value >>= 2;
282                 result += 2;
283             }
284             if (value >> 1 > 0) {
285                 result += 1;
286             }
287         }
288         return result;
289     }
290 
291     /**
292      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
293      * Returns 0 if given 0.
294      */
295     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
296         unchecked {
297             uint256 result = log2(value);
298             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
299         }
300     }
301 
302     /**
303      * @dev Return the log in base 10, rounded down, of a positive value.
304      * Returns 0 if given 0.
305      */
306     function log10(uint256 value) internal pure returns (uint256) {
307         uint256 result = 0;
308         unchecked {
309             if (value >= 10**64) {
310                 value /= 10**64;
311                 result += 64;
312             }
313             if (value >= 10**32) {
314                 value /= 10**32;
315                 result += 32;
316             }
317             if (value >= 10**16) {
318                 value /= 10**16;
319                 result += 16;
320             }
321             if (value >= 10**8) {
322                 value /= 10**8;
323                 result += 8;
324             }
325             if (value >= 10**4) {
326                 value /= 10**4;
327                 result += 4;
328             }
329             if (value >= 10**2) {
330                 value /= 10**2;
331                 result += 2;
332             }
333             if (value >= 10**1) {
334                 result += 1;
335             }
336         }
337         return result;
338     }
339 
340     /**
341      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
342      * Returns 0 if given 0.
343      */
344     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
345         unchecked {
346             uint256 result = log10(value);
347             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
348         }
349     }
350 
351     /**
352      * @dev Return the log in base 256, rounded down, of a positive value.
353      * Returns 0 if given 0.
354      *
355      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
356      */
357     function log256(uint256 value) internal pure returns (uint256) {
358         uint256 result = 0;
359         unchecked {
360             if (value >> 128 > 0) {
361                 value >>= 128;
362                 result += 16;
363             }
364             if (value >> 64 > 0) {
365                 value >>= 64;
366                 result += 8;
367             }
368             if (value >> 32 > 0) {
369                 value >>= 32;
370                 result += 4;
371             }
372             if (value >> 16 > 0) {
373                 value >>= 16;
374                 result += 2;
375             }
376             if (value >> 8 > 0) {
377                 result += 1;
378             }
379         }
380         return result;
381     }
382 
383     /**
384      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
385      * Returns 0 if given 0.
386      */
387     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
388         unchecked {
389             uint256 result = log256(value);
390             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
391         }
392     }
393 }
394 
395 // File: @openzeppelin/contracts/utils/Strings.sol
396 
397 
398 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev String operations.
405  */
406 library Strings {
407     bytes16 private constant _SYMBOLS = "0123456789abcdef";
408     uint8 private constant _ADDRESS_LENGTH = 20;
409 
410     /**
411      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
412      */
413     function toString(uint256 value) internal pure returns (string memory) {
414         unchecked {
415             uint256 length = Math.log10(value) + 1;
416             string memory buffer = new string(length);
417             uint256 ptr;
418             /// @solidity memory-safe-assembly
419             assembly {
420                 ptr := add(buffer, add(32, length))
421             }
422             while (true) {
423                 ptr--;
424                 /// @solidity memory-safe-assembly
425                 assembly {
426                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
427                 }
428                 value /= 10;
429                 if (value == 0) break;
430             }
431             return buffer;
432         }
433     }
434 
435     /**
436      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
437      */
438     function toHexString(uint256 value) internal pure returns (string memory) {
439         unchecked {
440             return toHexString(value, Math.log256(value) + 1);
441         }
442     }
443 
444     /**
445      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
446      */
447     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
448         bytes memory buffer = new bytes(2 * length + 2);
449         buffer[0] = "0";
450         buffer[1] = "x";
451         for (uint256 i = 2 * length + 1; i > 1; --i) {
452             buffer[i] = _SYMBOLS[value & 0xf];
453             value >>= 4;
454         }
455         require(value == 0, "Strings: hex length insufficient");
456         return string(buffer);
457     }
458 
459     /**
460      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
461      */
462     function toHexString(address addr) internal pure returns (string memory) {
463         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
464     }
465 }
466 
467 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
468 
469 
470 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
471 
472 pragma solidity ^0.8.0;
473 
474 
475 /**
476  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
477  *
478  * These functions can be used to verify that a message was signed by the holder
479  * of the private keys of a given address.
480  */
481 library ECDSA {
482     enum RecoverError {
483         NoError,
484         InvalidSignature,
485         InvalidSignatureLength,
486         InvalidSignatureS,
487         InvalidSignatureV // Deprecated in v4.8
488     }
489 
490     function _throwError(RecoverError error) private pure {
491         if (error == RecoverError.NoError) {
492             return; // no error: do nothing
493         } else if (error == RecoverError.InvalidSignature) {
494             revert("ECDSA: invalid signature");
495         } else if (error == RecoverError.InvalidSignatureLength) {
496             revert("ECDSA: invalid signature length");
497         } else if (error == RecoverError.InvalidSignatureS) {
498             revert("ECDSA: invalid signature 's' value");
499         }
500     }
501 
502     /**
503      * @dev Returns the address that signed a hashed message (`hash`) with
504      * `signature` or error string. This address can then be used for verification purposes.
505      *
506      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
507      * this function rejects them by requiring the `s` value to be in the lower
508      * half order, and the `v` value to be either 27 or 28.
509      *
510      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
511      * verification to be secure: it is possible to craft signatures that
512      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
513      * this is by receiving a hash of the original message (which may otherwise
514      * be too long), and then calling {toEthSignedMessageHash} on it.
515      *
516      * Documentation for signature generation:
517      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
518      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
519      *
520      * _Available since v4.3._
521      */
522     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
523         if (signature.length == 65) {
524             bytes32 r;
525             bytes32 s;
526             uint8 v;
527             // ecrecover takes the signature parameters, and the only way to get them
528             // currently is to use assembly.
529             /// @solidity memory-safe-assembly
530             assembly {
531                 r := mload(add(signature, 0x20))
532                 s := mload(add(signature, 0x40))
533                 v := byte(0, mload(add(signature, 0x60)))
534             }
535             return tryRecover(hash, v, r, s);
536         } else {
537             return (address(0), RecoverError.InvalidSignatureLength);
538         }
539     }
540 
541     /**
542      * @dev Returns the address that signed a hashed message (`hash`) with
543      * `signature`. This address can then be used for verification purposes.
544      *
545      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
546      * this function rejects them by requiring the `s` value to be in the lower
547      * half order, and the `v` value to be either 27 or 28.
548      *
549      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
550      * verification to be secure: it is possible to craft signatures that
551      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
552      * this is by receiving a hash of the original message (which may otherwise
553      * be too long), and then calling {toEthSignedMessageHash} on it.
554      */
555     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
556         (address recovered, RecoverError error) = tryRecover(hash, signature);
557         _throwError(error);
558         return recovered;
559     }
560 
561     /**
562      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
563      *
564      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
565      *
566      * _Available since v4.3._
567      */
568     function tryRecover(
569         bytes32 hash,
570         bytes32 r,
571         bytes32 vs
572     ) internal pure returns (address, RecoverError) {
573         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
574         uint8 v = uint8((uint256(vs) >> 255) + 27);
575         return tryRecover(hash, v, r, s);
576     }
577 
578     /**
579      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
580      *
581      * _Available since v4.2._
582      */
583     function recover(
584         bytes32 hash,
585         bytes32 r,
586         bytes32 vs
587     ) internal pure returns (address) {
588         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
589         _throwError(error);
590         return recovered;
591     }
592 
593     /**
594      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
595      * `r` and `s` signature fields separately.
596      *
597      * _Available since v4.3._
598      */
599     function tryRecover(
600         bytes32 hash,
601         uint8 v,
602         bytes32 r,
603         bytes32 s
604     ) internal pure returns (address, RecoverError) {
605         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
606         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
607         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
608         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
609         //
610         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
611         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
612         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
613         // these malleable signatures as well.
614         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
615             return (address(0), RecoverError.InvalidSignatureS);
616         }
617 
618         // If the signature is valid (and not malleable), return the signer address
619         address signer = ecrecover(hash, v, r, s);
620         if (signer == address(0)) {
621             return (address(0), RecoverError.InvalidSignature);
622         }
623 
624         return (signer, RecoverError.NoError);
625     }
626 
627     /**
628      * @dev Overload of {ECDSA-recover} that receives the `v`,
629      * `r` and `s` signature fields separately.
630      */
631     function recover(
632         bytes32 hash,
633         uint8 v,
634         bytes32 r,
635         bytes32 s
636     ) internal pure returns (address) {
637         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
638         _throwError(error);
639         return recovered;
640     }
641 
642     /**
643      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
644      * produces hash corresponding to the one signed with the
645      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
646      * JSON-RPC method as part of EIP-191.
647      *
648      * See {recover}.
649      */
650     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
651         // 32 is the length in bytes of hash,
652         // enforced by the type signature above
653         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
654     }
655 
656     /**
657      * @dev Returns an Ethereum Signed Message, created from `s`. This
658      * produces hash corresponding to the one signed with the
659      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
660      * JSON-RPC method as part of EIP-191.
661      *
662      * See {recover}.
663      */
664     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
665         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
666     }
667 
668     /**
669      * @dev Returns an Ethereum Signed Typed Data, created from a
670      * `domainSeparator` and a `structHash`. This produces hash corresponding
671      * to the one signed with the
672      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
673      * JSON-RPC method as part of EIP-712.
674      *
675      * See {recover}.
676      */
677     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
678         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
679     }
680 }
681 
682 // File: @openzeppelin/contracts/utils/cryptography/EIP712.sol
683 
684 
685 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/EIP712.sol)
686 
687 pragma solidity ^0.8.0;
688 
689 
690 /**
691  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
692  *
693  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
694  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
695  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
696  *
697  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
698  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
699  * ({_hashTypedDataV4}).
700  *
701  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
702  * the chain id to protect against replay attacks on an eventual fork of the chain.
703  *
704  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
705  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
706  *
707  * _Available since v3.4._
708  */
709 abstract contract EIP712 {
710     /* solhint-disable var-name-mixedcase */
711     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
712     // invalidate the cached domain separator if the chain id changes.
713     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
714     uint256 private immutable _CACHED_CHAIN_ID;
715     address private immutable _CACHED_THIS;
716 
717     bytes32 private immutable _HASHED_NAME;
718     bytes32 private immutable _HASHED_VERSION;
719     bytes32 private immutable _TYPE_HASH;
720 
721     /* solhint-enable var-name-mixedcase */
722 
723     /**
724      * @dev Initializes the domain separator and parameter caches.
725      *
726      * The meaning of `name` and `version` is specified in
727      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
728      *
729      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
730      * - `version`: the current major version of the signing domain.
731      *
732      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
733      * contract upgrade].
734      */
735     constructor(string memory name, string memory version) {
736         bytes32 hashedName = keccak256(bytes(name));
737         bytes32 hashedVersion = keccak256(bytes(version));
738         bytes32 typeHash = keccak256(
739             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
740         );
741         _HASHED_NAME = hashedName;
742         _HASHED_VERSION = hashedVersion;
743         _CACHED_CHAIN_ID = block.chainid;
744         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
745         _CACHED_THIS = address(this);
746         _TYPE_HASH = typeHash;
747     }
748 
749     /**
750      * @dev Returns the domain separator for the current chain.
751      */
752     function _domainSeparatorV4() internal view returns (bytes32) {
753         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
754             return _CACHED_DOMAIN_SEPARATOR;
755         } else {
756             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
757         }
758     }
759 
760     function _buildDomainSeparator(
761         bytes32 typeHash,
762         bytes32 nameHash,
763         bytes32 versionHash
764     ) private view returns (bytes32) {
765         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
766     }
767 
768     /**
769      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
770      * function returns the hash of the fully encoded EIP712 message for this domain.
771      *
772      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
773      *
774      * ```solidity
775      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
776      *     keccak256("Mail(address to,string contents)"),
777      *     mailTo,
778      *     keccak256(bytes(mailContents))
779      * )));
780      * address signer = ECDSA.recover(digest, signature);
781      * ```
782      */
783     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
784         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
785     }
786 }
787 
788 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
789 
790 
791 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
792 
793 pragma solidity ^0.8.0;
794 
795 /**
796  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
797  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
798  *
799  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
800  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
801  * need to send a transaction, and thus is not required to hold Ether at all.
802  */
803 interface IERC20Permit {
804     /**
805      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
806      * given ``owner``'s signed approval.
807      *
808      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
809      * ordering also apply here.
810      *
811      * Emits an {Approval} event.
812      *
813      * Requirements:
814      *
815      * - `spender` cannot be the zero address.
816      * - `deadline` must be a timestamp in the future.
817      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
818      * over the EIP712-formatted function arguments.
819      * - the signature must use ``owner``'s current nonce (see {nonces}).
820      *
821      * For more information on the signature format, see the
822      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
823      * section].
824      */
825     function permit(
826         address owner,
827         address spender,
828         uint256 value,
829         uint256 deadline,
830         uint8 v,
831         bytes32 r,
832         bytes32 s
833     ) external;
834 
835     /**
836      * @dev Returns the current nonce for `owner`. This value must be
837      * included whenever a signature is generated for {permit}.
838      *
839      * Every successful call to {permit} increases ``owner``'s nonce by one. This
840      * prevents a signature from being used multiple times.
841      */
842     function nonces(address owner) external view returns (uint256);
843 
844     /**
845      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
846      */
847     // solhint-disable-next-line func-name-mixedcase
848     function DOMAIN_SEPARATOR() external view returns (bytes32);
849 }
850 
851 // File: @openzeppelin/contracts/utils/Context.sol
852 
853 
854 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
855 
856 pragma solidity ^0.8.0;
857 
858 /**
859  * @dev Provides information about the current execution context, including the
860  * sender of the transaction and its data. While these are generally available
861  * via msg.sender and msg.data, they should not be accessed in such a direct
862  * manner, since when dealing with meta-transactions the account sending and
863  * paying for execution may not be the actual sender (as far as an application
864  * is concerned).
865  *
866  * This contract is only required for intermediate, library-like contracts.
867  */
868 abstract contract Context {
869     function _msgSender() internal view virtual returns (address) {
870         return msg.sender;
871     }
872 
873     function _msgData() internal view virtual returns (bytes calldata) {
874         return msg.data;
875     }
876 }
877 
878 // File: @openzeppelin/contracts/access/Ownable.sol
879 
880 
881 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
882 
883 pragma solidity ^0.8.0;
884 
885 
886 /**
887  * @dev Contract module which provides a basic access control mechanism, where
888  * there is an account (an owner) that can be granted exclusive access to
889  * specific functions.
890  *
891  * By default, the owner account will be the one that deploys the contract. This
892  * can later be changed with {transferOwnership}.
893  *
894  * This module is used through inheritance. It will make available the modifier
895  * `onlyOwner`, which can be applied to your functions to restrict their use to
896  * the owner.
897  */
898 abstract contract Ownable is Context {
899     address private _owner;
900 
901     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
902 
903     /**
904      * @dev Initializes the contract setting the deployer as the initial owner.
905      */
906     constructor() {
907         _transferOwnership(_msgSender());
908     }
909 
910     /**
911      * @dev Throws if called by any account other than the owner.
912      */
913     modifier onlyOwner() {
914         _checkOwner();
915         _;
916     }
917 
918     /**
919      * @dev Returns the address of the current owner.
920      */
921     function owner() public view virtual returns (address) {
922         return _owner;
923     }
924 
925     /**
926      * @dev Throws if the sender is not the owner.
927      */
928     function _checkOwner() internal view virtual {
929         require(owner() == _msgSender(), "Ownable: caller is not the owner");
930     }
931 
932     /**
933      * @dev Leaves the contract without owner. It will not be possible to call
934      * `onlyOwner` functions anymore. Can only be called by the current owner.
935      *
936      * NOTE: Renouncing ownership will leave the contract without an owner,
937      * thereby removing any functionality that is only available to the owner.
938      */
939     function renounceOwnership() public virtual onlyOwner {
940         _transferOwnership(address(0));
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Can only be called by the current owner.
946      */
947     function transferOwnership(address newOwner) public virtual onlyOwner {
948         require(newOwner != address(0), "Ownable: new owner is the zero address");
949         _transferOwnership(newOwner);
950     }
951 
952     /**
953      * @dev Transfers ownership of the contract to a new account (`newOwner`).
954      * Internal function without access restriction.
955      */
956     function _transferOwnership(address newOwner) internal virtual {
957         address oldOwner = _owner;
958         _owner = newOwner;
959         emit OwnershipTransferred(oldOwner, newOwner);
960     }
961 }
962 
963 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
964 
965 
966 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
967 
968 pragma solidity ^0.8.0;
969 
970 /**
971  * @dev Interface of the ERC20 standard as defined in the EIP.
972  */
973 interface IERC20 {
974     /**
975      * @dev Emitted when `value` tokens are moved from one account (`from`) to
976      * another (`to`).
977      *
978      * Note that `value` may be zero.
979      */
980     event Transfer(address indexed from, address indexed to, uint256 value);
981 
982     /**
983      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
984      * a call to {approve}. `value` is the new allowance.
985      */
986     event Approval(address indexed owner, address indexed spender, uint256 value);
987 
988     /**
989      * @dev Returns the amount of tokens in existence.
990      */
991     function totalSupply() external view returns (uint256);
992 
993     /**
994      * @dev Returns the amount of tokens owned by `account`.
995      */
996     function balanceOf(address account) external view returns (uint256);
997 
998     /**
999      * @dev Moves `amount` tokens from the caller's account to `to`.
1000      *
1001      * Returns a boolean value indicating whether the operation succeeded.
1002      *
1003      * Emits a {Transfer} event.
1004      */
1005     function transfer(address to, uint256 amount) external returns (bool);
1006 
1007     /**
1008      * @dev Returns the remaining number of tokens that `spender` will be
1009      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1010      * zero by default.
1011      *
1012      * This value changes when {approve} or {transferFrom} are called.
1013      */
1014     function allowance(address owner, address spender) external view returns (uint256);
1015 
1016     /**
1017      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1018      *
1019      * Returns a boolean value indicating whether the operation succeeded.
1020      *
1021      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1022      * that someone may use both the old and the new allowance by unfortunate
1023      * transaction ordering. One possible solution to mitigate this race
1024      * condition is to first reduce the spender's allowance to 0 and set the
1025      * desired value afterwards:
1026      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1027      *
1028      * Emits an {Approval} event.
1029      */
1030     function approve(address spender, uint256 amount) external returns (bool);
1031 
1032     /**
1033      * @dev Moves `amount` tokens from `from` to `to` using the
1034      * allowance mechanism. `amount` is then deducted from the caller's
1035      * allowance.
1036      *
1037      * Returns a boolean value indicating whether the operation succeeded.
1038      *
1039      * Emits a {Transfer} event.
1040      */
1041     function transferFrom(
1042         address from,
1043         address to,
1044         uint256 amount
1045     ) external returns (bool);
1046 }
1047 
1048 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1049 
1050 
1051 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1052 
1053 pragma solidity ^0.8.0;
1054 
1055 
1056 /**
1057  * @dev Interface for the optional metadata functions from the ERC20 standard.
1058  *
1059  * _Available since v4.1._
1060  */
1061 interface IERC20Metadata is IERC20 {
1062     /**
1063      * @dev Returns the name of the token.
1064      */
1065     function name() external view returns (string memory);
1066 
1067     /**
1068      * @dev Returns the symbol of the token.
1069      */
1070     function symbol() external view returns (string memory);
1071 
1072     /**
1073      * @dev Returns the decimals places of the token.
1074      */
1075     function decimals() external view returns (uint8);
1076 }
1077 
1078 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1079 
1080 
1081 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1082 
1083 pragma solidity ^0.8.0;
1084 
1085 
1086 
1087 
1088 /**
1089  * @dev Implementation of the {IERC20} interface.
1090  *
1091  * This implementation is agnostic to the way tokens are created. This means
1092  * that a supply mechanism has to be added in a derived contract using {_mint}.
1093  * For a generic mechanism see {ERC20PresetMinterPauser}.
1094  *
1095  * TIP: For a detailed writeup see our guide
1096  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1097  * to implement supply mechanisms].
1098  *
1099  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1100  * instead returning `false` on failure. This behavior is nonetheless
1101  * conventional and does not conflict with the expectations of ERC20
1102  * applications.
1103  *
1104  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1105  * This allows applications to reconstruct the allowance for all accounts just
1106  * by listening to said events. Other implementations of the EIP may not emit
1107  * these events, as it isn't required by the specification.
1108  *
1109  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1110  * functions have been added to mitigate the well-known issues around setting
1111  * allowances. See {IERC20-approve}.
1112  */
1113 contract ERC20 is Context, IERC20, IERC20Metadata {
1114     mapping(address => uint256) private _balances;
1115 
1116     mapping(address => mapping(address => uint256)) private _allowances;
1117 
1118     uint256 private _totalSupply;
1119 
1120     string private _name;
1121     string private _symbol;
1122 
1123     /**
1124      * @dev Sets the values for {name} and {symbol}.
1125      *
1126      * The default value of {decimals} is 18. To select a different value for
1127      * {decimals} you should overload it.
1128      *
1129      * All two of these values are immutable: they can only be set once during
1130      * construction.
1131      */
1132     constructor(string memory name_, string memory symbol_) {
1133         _name = name_;
1134         _symbol = symbol_;
1135     }
1136 
1137     /**
1138      * @dev Returns the name of the token.
1139      */
1140     function name() public view virtual override returns (string memory) {
1141         return _name;
1142     }
1143 
1144     /**
1145      * @dev Returns the symbol of the token, usually a shorter version of the
1146      * name.
1147      */
1148     function symbol() public view virtual override returns (string memory) {
1149         return _symbol;
1150     }
1151 
1152     /**
1153      * @dev Returns the number of decimals used to get its user representation.
1154      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1155      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1156      *
1157      * Tokens usually opt for a value of 18, imitating the relationship between
1158      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1159      * overridden;
1160      *
1161      * NOTE: This information is only used for _display_ purposes: it in
1162      * no way affects any of the arithmetic of the contract, including
1163      * {IERC20-balanceOf} and {IERC20-transfer}.
1164      */
1165     function decimals() public view virtual override returns (uint8) {
1166         return 18;
1167     }
1168 
1169     /**
1170      * @dev See {IERC20-totalSupply}.
1171      */
1172     function totalSupply() public view virtual override returns (uint256) {
1173         return _totalSupply;
1174     }
1175 
1176     /**
1177      * @dev See {IERC20-balanceOf}.
1178      */
1179     function balanceOf(address account) public view virtual override returns (uint256) {
1180         return _balances[account];
1181     }
1182 
1183     /**
1184      * @dev See {IERC20-transfer}.
1185      *
1186      * Requirements:
1187      *
1188      * - `to` cannot be the zero address.
1189      * - the caller must have a balance of at least `amount`.
1190      */
1191     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1192         address owner = _msgSender();
1193         _transfer(owner, to, amount);
1194         return true;
1195     }
1196 
1197     /**
1198      * @dev See {IERC20-allowance}.
1199      */
1200     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1201         return _allowances[owner][spender];
1202     }
1203 
1204     /**
1205      * @dev See {IERC20-approve}.
1206      *
1207      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1208      * `transferFrom`. This is semantically equivalent to an infinite approval.
1209      *
1210      * Requirements:
1211      *
1212      * - `spender` cannot be the zero address.
1213      */
1214     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1215         address owner = _msgSender();
1216         _approve(owner, spender, amount);
1217         return true;
1218     }
1219 
1220     /**
1221      * @dev See {IERC20-transferFrom}.
1222      *
1223      * Emits an {Approval} event indicating the updated allowance. This is not
1224      * required by the EIP. See the note at the beginning of {ERC20}.
1225      *
1226      * NOTE: Does not update the allowance if the current allowance
1227      * is the maximum `uint256`.
1228      *
1229      * Requirements:
1230      *
1231      * - `from` and `to` cannot be the zero address.
1232      * - `from` must have a balance of at least `amount`.
1233      * - the caller must have allowance for ``from``'s tokens of at least
1234      * `amount`.
1235      */
1236     function transferFrom(
1237         address from,
1238         address to,
1239         uint256 amount
1240     ) public virtual override returns (bool) {
1241         address spender = _msgSender();
1242         _spendAllowance(from, spender, amount);
1243         _transfer(from, to, amount);
1244         return true;
1245     }
1246 
1247     /**
1248      * @dev Atomically increases the allowance granted to `spender` by the caller.
1249      *
1250      * This is an alternative to {approve} that can be used as a mitigation for
1251      * problems described in {IERC20-approve}.
1252      *
1253      * Emits an {Approval} event indicating the updated allowance.
1254      *
1255      * Requirements:
1256      *
1257      * - `spender` cannot be the zero address.
1258      */
1259     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1260         address owner = _msgSender();
1261         _approve(owner, spender, allowance(owner, spender) + addedValue);
1262         return true;
1263     }
1264 
1265     /**
1266      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1267      *
1268      * This is an alternative to {approve} that can be used as a mitigation for
1269      * problems described in {IERC20-approve}.
1270      *
1271      * Emits an {Approval} event indicating the updated allowance.
1272      *
1273      * Requirements:
1274      *
1275      * - `spender` cannot be the zero address.
1276      * - `spender` must have allowance for the caller of at least
1277      * `subtractedValue`.
1278      */
1279     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1280         address owner = _msgSender();
1281         uint256 currentAllowance = allowance(owner, spender);
1282         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1283         unchecked {
1284             _approve(owner, spender, currentAllowance - subtractedValue);
1285         }
1286 
1287         return true;
1288     }
1289 
1290     /**
1291      * @dev Moves `amount` of tokens from `from` to `to`.
1292      *
1293      * This internal function is equivalent to {transfer}, and can be used to
1294      * e.g. implement automatic token fees, slashing mechanisms, etc.
1295      *
1296      * Emits a {Transfer} event.
1297      *
1298      * Requirements:
1299      *
1300      * - `from` cannot be the zero address.
1301      * - `to` cannot be the zero address.
1302      * - `from` must have a balance of at least `amount`.
1303      */
1304     function _transfer(
1305         address from,
1306         address to,
1307         uint256 amount
1308     ) internal virtual {
1309         require(from != address(0), "ERC20: transfer from the zero address");
1310         require(to != address(0), "ERC20: transfer to the zero address");
1311 
1312         _beforeTokenTransfer(from, to, amount);
1313 
1314         uint256 fromBalance = _balances[from];
1315         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1316         unchecked {
1317             _balances[from] = fromBalance - amount;
1318             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1319             // decrementing then incrementing.
1320             _balances[to] += amount;
1321         }
1322 
1323         emit Transfer(from, to, amount);
1324 
1325         _afterTokenTransfer(from, to, amount);
1326     }
1327 
1328     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1329      * the total supply.
1330      *
1331      * Emits a {Transfer} event with `from` set to the zero address.
1332      *
1333      * Requirements:
1334      *
1335      * - `account` cannot be the zero address.
1336      */
1337     function _mint(address account, uint256 amount) internal virtual {
1338         require(account != address(0), "ERC20: mint to the zero address");
1339 
1340         _beforeTokenTransfer(address(0), account, amount);
1341 
1342         _totalSupply += amount;
1343         unchecked {
1344             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1345             _balances[account] += amount;
1346         }
1347         emit Transfer(address(0), account, amount);
1348 
1349         _afterTokenTransfer(address(0), account, amount);
1350     }
1351 
1352     /**
1353      * @dev Destroys `amount` tokens from `account`, reducing the
1354      * total supply.
1355      *
1356      * Emits a {Transfer} event with `to` set to the zero address.
1357      *
1358      * Requirements:
1359      *
1360      * - `account` cannot be the zero address.
1361      * - `account` must have at least `amount` tokens.
1362      */
1363     function _burn(address account, uint256 amount) internal virtual {
1364         require(account != address(0), "ERC20: burn from the zero address");
1365 
1366         _beforeTokenTransfer(account, address(0), amount);
1367 
1368         uint256 accountBalance = _balances[account];
1369         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1370         unchecked {
1371             _balances[account] = accountBalance - amount;
1372             // Overflow not possible: amount <= accountBalance <= totalSupply.
1373             _totalSupply -= amount;
1374         }
1375 
1376         emit Transfer(account, address(0), amount);
1377 
1378         _afterTokenTransfer(account, address(0), amount);
1379     }
1380 
1381     /**
1382      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1383      *
1384      * This internal function is equivalent to `approve`, and can be used to
1385      * e.g. set automatic allowances for certain subsystems, etc.
1386      *
1387      * Emits an {Approval} event.
1388      *
1389      * Requirements:
1390      *
1391      * - `owner` cannot be the zero address.
1392      * - `spender` cannot be the zero address.
1393      */
1394     function _approve(
1395         address owner,
1396         address spender,
1397         uint256 amount
1398     ) internal virtual {
1399         require(owner != address(0), "ERC20: approve from the zero address");
1400         require(spender != address(0), "ERC20: approve to the zero address");
1401 
1402         _allowances[owner][spender] = amount;
1403         emit Approval(owner, spender, amount);
1404     }
1405 
1406     /**
1407      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1408      *
1409      * Does not update the allowance amount in case of infinite allowance.
1410      * Revert if not enough allowance is available.
1411      *
1412      * Might emit an {Approval} event.
1413      */
1414     function _spendAllowance(
1415         address owner,
1416         address spender,
1417         uint256 amount
1418     ) internal virtual {
1419         uint256 currentAllowance = allowance(owner, spender);
1420         if (currentAllowance != type(uint256).max) {
1421             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1422             unchecked {
1423                 _approve(owner, spender, currentAllowance - amount);
1424             }
1425         }
1426     }
1427 
1428     /**
1429      * @dev Hook that is called before any transfer of tokens. This includes
1430      * minting and burning.
1431      *
1432      * Calling conditions:
1433      *
1434      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1435      * will be transferred to `to`.
1436      * - when `from` is zero, `amount` tokens will be minted for `to`.
1437      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1438      * - `from` and `to` are never both zero.
1439      *
1440      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1441      */
1442     function _beforeTokenTransfer(
1443         address from,
1444         address to,
1445         uint256 amount
1446     ) internal virtual {}
1447 
1448     /**
1449      * @dev Hook that is called after any transfer of tokens. This includes
1450      * minting and burning.
1451      *
1452      * Calling conditions:
1453      *
1454      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1455      * has been transferred to `to`.
1456      * - when `from` is zero, `amount` tokens have been minted for `to`.
1457      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1458      * - `from` and `to` are never both zero.
1459      *
1460      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1461      */
1462     function _afterTokenTransfer(
1463         address from,
1464         address to,
1465         uint256 amount
1466     ) internal virtual {}
1467 }
1468 
1469 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1470 
1471 
1472 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
1473 
1474 pragma solidity ^0.8.0;
1475 
1476 
1477 
1478 
1479 
1480 
1481 /**
1482  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1483  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1484  *
1485  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1486  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1487  * need to send a transaction, and thus is not required to hold Ether at all.
1488  *
1489  * _Available since v3.4._
1490  */
1491 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1492     using Counters for Counters.Counter;
1493 
1494     mapping(address => Counters.Counter) private _nonces;
1495 
1496     // solhint-disable-next-line var-name-mixedcase
1497     bytes32 private constant _PERMIT_TYPEHASH =
1498         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1499     /**
1500      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
1501      * However, to ensure consistency with the upgradeable transpiler, we will continue
1502      * to reserve a slot.
1503      * @custom:oz-renamed-from _PERMIT_TYPEHASH
1504      */
1505     // solhint-disable-next-line var-name-mixedcase
1506     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
1507 
1508     /**
1509      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1510      *
1511      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1512      */
1513     constructor(string memory name) EIP712(name, "1") {}
1514 
1515     /**
1516      * @dev See {IERC20Permit-permit}.
1517      */
1518     function permit(
1519         address owner,
1520         address spender,
1521         uint256 value,
1522         uint256 deadline,
1523         uint8 v,
1524         bytes32 r,
1525         bytes32 s
1526     ) public virtual override {
1527         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1528 
1529         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1530 
1531         bytes32 hash = _hashTypedDataV4(structHash);
1532 
1533         address signer = ECDSA.recover(hash, v, r, s);
1534         require(signer == owner, "ERC20Permit: invalid signature");
1535 
1536         _approve(owner, spender, value);
1537     }
1538 
1539     /**
1540      * @dev See {IERC20Permit-nonces}.
1541      */
1542     function nonces(address owner) public view virtual override returns (uint256) {
1543         return _nonces[owner].current();
1544     }
1545 
1546     /**
1547      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1548      */
1549     // solhint-disable-next-line func-name-mixedcase
1550     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1551         return _domainSeparatorV4();
1552     }
1553 
1554     /**
1555      * @dev "Consume a nonce": return the current value and increment.
1556      *
1557      * _Available since v4.1._
1558      */
1559     function _useNonce(address owner) internal virtual returns (uint256 current) {
1560         Counters.Counter storage nonce = _nonces[owner];
1561         current = nonce.current();
1562         nonce.increment();
1563     }
1564 }
1565 
1566 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1567 
1568 
1569 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1570 
1571 pragma solidity ^0.8.0;
1572 
1573 
1574 
1575 /**
1576  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1577  * tokens and those that they have an allowance for, in a way that can be
1578  * recognized off-chain (via event analysis).
1579  */
1580 abstract contract ERC20Burnable is Context, ERC20 {
1581     /**
1582      * @dev Destroys `amount` tokens from the caller.
1583      *
1584      * See {ERC20-_burn}.
1585      */
1586     function burn(uint256 amount) public virtual {
1587         _burn(_msgSender(), amount);
1588     }
1589 
1590     /**
1591      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1592      * allowance.
1593      *
1594      * See {ERC20-_burn} and {ERC20-allowance}.
1595      *
1596      * Requirements:
1597      *
1598      * - the caller must have allowance for ``accounts``'s tokens of at least
1599      * `amount`.
1600      */
1601     function burnFrom(address account, uint256 amount) public virtual {
1602         _spendAllowance(account, _msgSender(), amount);
1603         _burn(account, amount);
1604     }
1605 }
1606 
1607 // File: contracts/proxima.sol
1608 
1609 
1610 pragma solidity ^0.8.9;
1611 
1612 
1613 
1614 
1615 
1616 
1617 contract ProximaToken is ERC20, ERC20Burnable, ERC20Permit ,Ownable  {
1618     constructor() ERC20("Proxima b", "PROXIMA") ERC20Permit("Proxima b") {
1619         _mint(msg.sender, 404000000000 * 10 ** 18);
1620     }
1621     
1622     mapping(address => bool) public blacklists;
1623     function blacklist(address _address, bool _isBlacklisting) external onlyOwner {
1624         blacklists[_address] = _isBlacklisting;
1625     }
1626 
1627     function _beforeTokenTransfer(
1628         address from,
1629         address to,
1630         uint256
1631     ) override internal virtual {
1632         require(!blacklists[to] && !blacklists[from], "Blacklisted");
1633     }
1634 
1635 }