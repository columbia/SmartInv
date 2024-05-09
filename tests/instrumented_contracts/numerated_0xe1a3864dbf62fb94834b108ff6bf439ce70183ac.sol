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
788 // File: @openzeppelin/contracts/utils/Address.sol
789 
790 
791 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
792 
793 pragma solidity ^0.8.1;
794 
795 /**
796  * @dev Collection of functions related to the address type
797  */
798 library Address {
799     /**
800      * @dev Returns true if `account` is a contract.
801      *
802      * [IMPORTANT]
803      * ====
804      * It is unsafe to assume that an address for which this function returns
805      * false is an externally-owned account (EOA) and not a contract.
806      *
807      * Among others, `isContract` will return false for the following
808      * types of addresses:
809      *
810      *  - an externally-owned account
811      *  - a contract in construction
812      *  - an address where a contract will be created
813      *  - an address where a contract lived, but was destroyed
814      * ====
815      *
816      * [IMPORTANT]
817      * ====
818      * You shouldn't rely on `isContract` to protect against flash loan attacks!
819      *
820      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
821      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
822      * constructor.
823      * ====
824      */
825     function isContract(address account) internal view returns (bool) {
826         // This method relies on extcodesize/address.code.length, which returns 0
827         // for contracts in construction, since the code is only stored at the end
828         // of the constructor execution.
829 
830         return account.code.length > 0;
831     }
832 
833     /**
834      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
835      * `recipient`, forwarding all available gas and reverting on errors.
836      *
837      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
838      * of certain opcodes, possibly making contracts go over the 2300 gas limit
839      * imposed by `transfer`, making them unable to receive funds via
840      * `transfer`. {sendValue} removes this limitation.
841      *
842      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
843      *
844      * IMPORTANT: because control is transferred to `recipient`, care must be
845      * taken to not create reentrancy vulnerabilities. Consider using
846      * {ReentrancyGuard} or the
847      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
848      */
849     function sendValue(address payable recipient, uint256 amount) internal {
850         require(address(this).balance >= amount, "Address: insufficient balance");
851 
852         (bool success, ) = recipient.call{value: amount}("");
853         require(success, "Address: unable to send value, recipient may have reverted");
854     }
855 
856     /**
857      * @dev Performs a Solidity function call using a low level `call`. A
858      * plain `call` is an unsafe replacement for a function call: use this
859      * function instead.
860      *
861      * If `target` reverts with a revert reason, it is bubbled up by this
862      * function (like regular Solidity function calls).
863      *
864      * Returns the raw returned data. To convert to the expected return value,
865      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
866      *
867      * Requirements:
868      *
869      * - `target` must be a contract.
870      * - calling `target` with `data` must not revert.
871      *
872      * _Available since v3.1._
873      */
874     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
875         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
880      * `errorMessage` as a fallback revert reason when `target` reverts.
881      *
882      * _Available since v3.1._
883      */
884     function functionCall(
885         address target,
886         bytes memory data,
887         string memory errorMessage
888     ) internal returns (bytes memory) {
889         return functionCallWithValue(target, data, 0, errorMessage);
890     }
891 
892     /**
893      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
894      * but also transferring `value` wei to `target`.
895      *
896      * Requirements:
897      *
898      * - the calling contract must have an ETH balance of at least `value`.
899      * - the called Solidity function must be `payable`.
900      *
901      * _Available since v3.1._
902      */
903     function functionCallWithValue(
904         address target,
905         bytes memory data,
906         uint256 value
907     ) internal returns (bytes memory) {
908         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
909     }
910 
911     /**
912      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
913      * with `errorMessage` as a fallback revert reason when `target` reverts.
914      *
915      * _Available since v3.1._
916      */
917     function functionCallWithValue(
918         address target,
919         bytes memory data,
920         uint256 value,
921         string memory errorMessage
922     ) internal returns (bytes memory) {
923         require(address(this).balance >= value, "Address: insufficient balance for call");
924         (bool success, bytes memory returndata) = target.call{value: value}(data);
925         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
926     }
927 
928     /**
929      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
930      * but performing a static call.
931      *
932      * _Available since v3.3._
933      */
934     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
935         return functionStaticCall(target, data, "Address: low-level static call failed");
936     }
937 
938     /**
939      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
940      * but performing a static call.
941      *
942      * _Available since v3.3._
943      */
944     function functionStaticCall(
945         address target,
946         bytes memory data,
947         string memory errorMessage
948     ) internal view returns (bytes memory) {
949         (bool success, bytes memory returndata) = target.staticcall(data);
950         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
951     }
952 
953     /**
954      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
955      * but performing a delegate call.
956      *
957      * _Available since v3.4._
958      */
959     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
960         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
961     }
962 
963     /**
964      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
965      * but performing a delegate call.
966      *
967      * _Available since v3.4._
968      */
969     function functionDelegateCall(
970         address target,
971         bytes memory data,
972         string memory errorMessage
973     ) internal returns (bytes memory) {
974         (bool success, bytes memory returndata) = target.delegatecall(data);
975         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
976     }
977 
978     /**
979      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
980      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
981      *
982      * _Available since v4.8._
983      */
984     function verifyCallResultFromTarget(
985         address target,
986         bool success,
987         bytes memory returndata,
988         string memory errorMessage
989     ) internal view returns (bytes memory) {
990         if (success) {
991             if (returndata.length == 0) {
992                 // only check isContract if the call was successful and the return data is empty
993                 // otherwise we already know that it was a contract
994                 require(isContract(target), "Address: call to non-contract");
995             }
996             return returndata;
997         } else {
998             _revert(returndata, errorMessage);
999         }
1000     }
1001 
1002     /**
1003      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1004      * revert reason or using the provided one.
1005      *
1006      * _Available since v4.3._
1007      */
1008     function verifyCallResult(
1009         bool success,
1010         bytes memory returndata,
1011         string memory errorMessage
1012     ) internal pure returns (bytes memory) {
1013         if (success) {
1014             return returndata;
1015         } else {
1016             _revert(returndata, errorMessage);
1017         }
1018     }
1019 
1020     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1021         // Look for revert reason and bubble it up if present
1022         if (returndata.length > 0) {
1023             // The easiest way to bubble the revert reason is using memory via assembly
1024             /// @solidity memory-safe-assembly
1025             assembly {
1026                 let returndata_size := mload(returndata)
1027                 revert(add(32, returndata), returndata_size)
1028             }
1029         } else {
1030             revert(errorMessage);
1031         }
1032     }
1033 }
1034 
1035 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
1036 
1037 
1038 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
1039 
1040 pragma solidity ^0.8.0;
1041 
1042 /**
1043  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1044  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1045  *
1046  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1047  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
1048  * need to send a transaction, and thus is not required to hold Ether at all.
1049  */
1050 interface IERC20Permit {
1051     /**
1052      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
1053      * given ``owner``'s signed approval.
1054      *
1055      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
1056      * ordering also apply here.
1057      *
1058      * Emits an {Approval} event.
1059      *
1060      * Requirements:
1061      *
1062      * - `spender` cannot be the zero address.
1063      * - `deadline` must be a timestamp in the future.
1064      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
1065      * over the EIP712-formatted function arguments.
1066      * - the signature must use ``owner``'s current nonce (see {nonces}).
1067      *
1068      * For more information on the signature format, see the
1069      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
1070      * section].
1071      */
1072     function permit(
1073         address owner,
1074         address spender,
1075         uint256 value,
1076         uint256 deadline,
1077         uint8 v,
1078         bytes32 r,
1079         bytes32 s
1080     ) external;
1081 
1082     /**
1083      * @dev Returns the current nonce for `owner`. This value must be
1084      * included whenever a signature is generated for {permit}.
1085      *
1086      * Every successful call to {permit} increases ``owner``'s nonce by one. This
1087      * prevents a signature from being used multiple times.
1088      */
1089     function nonces(address owner) external view returns (uint256);
1090 
1091     /**
1092      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1093      */
1094     // solhint-disable-next-line func-name-mixedcase
1095     function DOMAIN_SEPARATOR() external view returns (bytes32);
1096 }
1097 
1098 // File: @openzeppelin/contracts/utils/Context.sol
1099 
1100 
1101 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1102 
1103 pragma solidity ^0.8.0;
1104 
1105 /**
1106  * @dev Provides information about the current execution context, including the
1107  * sender of the transaction and its data. While these are generally available
1108  * via msg.sender and msg.data, they should not be accessed in such a direct
1109  * manner, since when dealing with meta-transactions the account sending and
1110  * paying for execution may not be the actual sender (as far as an application
1111  * is concerned).
1112  *
1113  * This contract is only required for intermediate, library-like contracts.
1114  */
1115 abstract contract Context {
1116     function _msgSender() internal view virtual returns (address) {
1117         return msg.sender;
1118     }
1119 
1120     function _msgData() internal view virtual returns (bytes calldata) {
1121         return msg.data;
1122     }
1123 }
1124 
1125 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1126 
1127 
1128 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1129 
1130 pragma solidity ^0.8.0;
1131 
1132 /**
1133  * @dev Interface of the ERC20 standard as defined in the EIP.
1134  */
1135 interface IERC20 {
1136     /**
1137      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1138      * another (`to`).
1139      *
1140      * Note that `value` may be zero.
1141      */
1142     event Transfer(address indexed from, address indexed to, uint256 value);
1143 
1144     /**
1145      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1146      * a call to {approve}. `value` is the new allowance.
1147      */
1148     event Approval(address indexed owner, address indexed spender, uint256 value);
1149 
1150     /**
1151      * @dev Returns the amount of tokens in existence.
1152      */
1153     function totalSupply() external view returns (uint256);
1154 
1155     /**
1156      * @dev Returns the amount of tokens owned by `account`.
1157      */
1158     function balanceOf(address account) external view returns (uint256);
1159 
1160     /**
1161      * @dev Moves `amount` tokens from the caller's account to `to`.
1162      *
1163      * Returns a boolean value indicating whether the operation succeeded.
1164      *
1165      * Emits a {Transfer} event.
1166      */
1167     function transfer(address to, uint256 amount) external returns (bool);
1168 
1169     /**
1170      * @dev Returns the remaining number of tokens that `spender` will be
1171      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1172      * zero by default.
1173      *
1174      * This value changes when {approve} or {transferFrom} are called.
1175      */
1176     function allowance(address owner, address spender) external view returns (uint256);
1177 
1178     /**
1179      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1180      *
1181      * Returns a boolean value indicating whether the operation succeeded.
1182      *
1183      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1184      * that someone may use both the old and the new allowance by unfortunate
1185      * transaction ordering. One possible solution to mitigate this race
1186      * condition is to first reduce the spender's allowance to 0 and set the
1187      * desired value afterwards:
1188      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1189      *
1190      * Emits an {Approval} event.
1191      */
1192     function approve(address spender, uint256 amount) external returns (bool);
1193 
1194     /**
1195      * @dev Moves `amount` tokens from `from` to `to` using the
1196      * allowance mechanism. `amount` is then deducted from the caller's
1197      * allowance.
1198      *
1199      * Returns a boolean value indicating whether the operation succeeded.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function transferFrom(
1204         address from,
1205         address to,
1206         uint256 amount
1207     ) external returns (bool);
1208 }
1209 
1210 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1211 
1212 
1213 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
1214 
1215 pragma solidity ^0.8.0;
1216 
1217 
1218 
1219 
1220 /**
1221  * @title SafeERC20
1222  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1223  * contract returns false). Tokens that return no value (and instead revert or
1224  * throw on failure) are also supported, non-reverting calls are assumed to be
1225  * successful.
1226  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1227  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1228  */
1229 library SafeERC20 {
1230     using Address for address;
1231 
1232     function safeTransfer(
1233         IERC20 token,
1234         address to,
1235         uint256 value
1236     ) internal {
1237         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1238     }
1239 
1240     function safeTransferFrom(
1241         IERC20 token,
1242         address from,
1243         address to,
1244         uint256 value
1245     ) internal {
1246         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1247     }
1248 
1249     /**
1250      * @dev Deprecated. This function has issues similar to the ones found in
1251      * {IERC20-approve}, and its usage is discouraged.
1252      *
1253      * Whenever possible, use {safeIncreaseAllowance} and
1254      * {safeDecreaseAllowance} instead.
1255      */
1256     function safeApprove(
1257         IERC20 token,
1258         address spender,
1259         uint256 value
1260     ) internal {
1261         // safeApprove should only be called when setting an initial allowance,
1262         // or when resetting it to zero. To increase and decrease it, use
1263         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1264         require(
1265             (value == 0) || (token.allowance(address(this), spender) == 0),
1266             "SafeERC20: approve from non-zero to non-zero allowance"
1267         );
1268         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1269     }
1270 
1271     function safeIncreaseAllowance(
1272         IERC20 token,
1273         address spender,
1274         uint256 value
1275     ) internal {
1276         uint256 newAllowance = token.allowance(address(this), spender) + value;
1277         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1278     }
1279 
1280     function safeDecreaseAllowance(
1281         IERC20 token,
1282         address spender,
1283         uint256 value
1284     ) internal {
1285         unchecked {
1286             uint256 oldAllowance = token.allowance(address(this), spender);
1287             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1288             uint256 newAllowance = oldAllowance - value;
1289             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1290         }
1291     }
1292 
1293     function safePermit(
1294         IERC20Permit token,
1295         address owner,
1296         address spender,
1297         uint256 value,
1298         uint256 deadline,
1299         uint8 v,
1300         bytes32 r,
1301         bytes32 s
1302     ) internal {
1303         uint256 nonceBefore = token.nonces(owner);
1304         token.permit(owner, spender, value, deadline, v, r, s);
1305         uint256 nonceAfter = token.nonces(owner);
1306         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1307     }
1308 
1309     /**
1310      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1311      * on the return value: the return value is optional (but if data is returned, it must not be false).
1312      * @param token The token targeted by the call.
1313      * @param data The call data (encoded using abi.encode or one of its variants).
1314      */
1315     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1316         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1317         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
1318         // the target address contains contract code and also asserts for success in the low-level call.
1319 
1320         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1321         if (returndata.length > 0) {
1322             // Return data is optional
1323             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1324         }
1325     }
1326 }
1327 
1328 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
1329 
1330 
1331 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
1332 
1333 pragma solidity ^0.8.0;
1334 
1335 
1336 /**
1337  * @dev Interface for the optional metadata functions from the ERC20 standard.
1338  *
1339  * _Available since v4.1._
1340  */
1341 interface IERC20Metadata is IERC20 {
1342     /**
1343      * @dev Returns the name of the token.
1344      */
1345     function name() external view returns (string memory);
1346 
1347     /**
1348      * @dev Returns the symbol of the token.
1349      */
1350     function symbol() external view returns (string memory);
1351 
1352     /**
1353      * @dev Returns the decimals places of the token.
1354      */
1355     function decimals() external view returns (uint8);
1356 }
1357 
1358 // File: @openzeppelin/contracts/interfaces/IERC4626.sol
1359 
1360 
1361 // OpenZeppelin Contracts (last updated v4.8.0) (interfaces/IERC4626.sol)
1362 
1363 pragma solidity ^0.8.0;
1364 
1365 
1366 
1367 /**
1368  * @dev Interface of the ERC4626 "Tokenized Vault Standard", as defined in
1369  * https://eips.ethereum.org/EIPS/eip-4626[ERC-4626].
1370  *
1371  * _Available since v4.7._
1372  */
1373 interface IERC4626 is IERC20, IERC20Metadata {
1374     event Deposit(address indexed sender, address indexed owner, uint256 assets, uint256 shares);
1375 
1376     event Withdraw(
1377         address indexed sender,
1378         address indexed receiver,
1379         address indexed owner,
1380         uint256 assets,
1381         uint256 shares
1382     );
1383 
1384     /**
1385      * @dev Returns the address of the underlying token used for the Vault for accounting, depositing, and withdrawing.
1386      *
1387      * - MUST be an ERC-20 token contract.
1388      * - MUST NOT revert.
1389      */
1390     function asset() external view returns (address assetTokenAddress);
1391 
1392     /**
1393      * @dev Returns the total amount of the underlying asset that is “managed” by Vault.
1394      *
1395      * - SHOULD include any compounding that occurs from yield.
1396      * - MUST be inclusive of any fees that are charged against assets in the Vault.
1397      * - MUST NOT revert.
1398      */
1399     function totalAssets() external view returns (uint256 totalManagedAssets);
1400 
1401     /**
1402      * @dev Returns the amount of shares that the Vault would exchange for the amount of assets provided, in an ideal
1403      * scenario where all the conditions are met.
1404      *
1405      * - MUST NOT be inclusive of any fees that are charged against assets in the Vault.
1406      * - MUST NOT show any variations depending on the caller.
1407      * - MUST NOT reflect slippage or other on-chain conditions, when performing the actual exchange.
1408      * - MUST NOT revert.
1409      *
1410      * NOTE: This calculation MAY NOT reflect the “per-user” price-per-share, and instead should reflect the
1411      * “average-user’s” price-per-share, meaning what the average user should expect to see when exchanging to and
1412      * from.
1413      */
1414     function convertToShares(uint256 assets) external view returns (uint256 shares);
1415 
1416     /**
1417      * @dev Returns the amount of assets that the Vault would exchange for the amount of shares provided, in an ideal
1418      * scenario where all the conditions are met.
1419      *
1420      * - MUST NOT be inclusive of any fees that are charged against assets in the Vault.
1421      * - MUST NOT show any variations depending on the caller.
1422      * - MUST NOT reflect slippage or other on-chain conditions, when performing the actual exchange.
1423      * - MUST NOT revert.
1424      *
1425      * NOTE: This calculation MAY NOT reflect the “per-user” price-per-share, and instead should reflect the
1426      * “average-user’s” price-per-share, meaning what the average user should expect to see when exchanging to and
1427      * from.
1428      */
1429     function convertToAssets(uint256 shares) external view returns (uint256 assets);
1430 
1431     /**
1432      * @dev Returns the maximum amount of the underlying asset that can be deposited into the Vault for the receiver,
1433      * through a deposit call.
1434      *
1435      * - MUST return a limited value if receiver is subject to some deposit limit.
1436      * - MUST return 2 ** 256 - 1 if there is no limit on the maximum amount of assets that may be deposited.
1437      * - MUST NOT revert.
1438      */
1439     function maxDeposit(address receiver) external view returns (uint256 maxAssets);
1440 
1441     /**
1442      * @dev Allows an on-chain or off-chain user to simulate the effects of their deposit at the current block, given
1443      * current on-chain conditions.
1444      *
1445      * - MUST return as close to and no more than the exact amount of Vault shares that would be minted in a deposit
1446      *   call in the same transaction. I.e. deposit should return the same or more shares as previewDeposit if called
1447      *   in the same transaction.
1448      * - MUST NOT account for deposit limits like those returned from maxDeposit and should always act as though the
1449      *   deposit would be accepted, regardless if the user has enough tokens approved, etc.
1450      * - MUST be inclusive of deposit fees. Integrators should be aware of the existence of deposit fees.
1451      * - MUST NOT revert.
1452      *
1453      * NOTE: any unfavorable discrepancy between convertToShares and previewDeposit SHOULD be considered slippage in
1454      * share price or some other type of condition, meaning the depositor will lose assets by depositing.
1455      */
1456     function previewDeposit(uint256 assets) external view returns (uint256 shares);
1457 
1458     /**
1459      * @dev Mints shares Vault shares to receiver by depositing exactly amount of underlying tokens.
1460      *
1461      * - MUST emit the Deposit event.
1462      * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the
1463      *   deposit execution, and are accounted for during deposit.
1464      * - MUST revert if all of assets cannot be deposited (due to deposit limit being reached, slippage, the user not
1465      *   approving enough underlying tokens to the Vault contract, etc).
1466      *
1467      * NOTE: most implementations will require pre-approval of the Vault with the Vault’s underlying asset token.
1468      */
1469     function deposit(uint256 assets, address receiver) external returns (uint256 shares);
1470 
1471     /**
1472      * @dev Returns the maximum amount of the Vault shares that can be minted for the receiver, through a mint call.
1473      * - MUST return a limited value if receiver is subject to some mint limit.
1474      * - MUST return 2 ** 256 - 1 if there is no limit on the maximum amount of shares that may be minted.
1475      * - MUST NOT revert.
1476      */
1477     function maxMint(address receiver) external view returns (uint256 maxShares);
1478 
1479     /**
1480      * @dev Allows an on-chain or off-chain user to simulate the effects of their mint at the current block, given
1481      * current on-chain conditions.
1482      *
1483      * - MUST return as close to and no fewer than the exact amount of assets that would be deposited in a mint call
1484      *   in the same transaction. I.e. mint should return the same or fewer assets as previewMint if called in the
1485      *   same transaction.
1486      * - MUST NOT account for mint limits like those returned from maxMint and should always act as though the mint
1487      *   would be accepted, regardless if the user has enough tokens approved, etc.
1488      * - MUST be inclusive of deposit fees. Integrators should be aware of the existence of deposit fees.
1489      * - MUST NOT revert.
1490      *
1491      * NOTE: any unfavorable discrepancy between convertToAssets and previewMint SHOULD be considered slippage in
1492      * share price or some other type of condition, meaning the depositor will lose assets by minting.
1493      */
1494     function previewMint(uint256 shares) external view returns (uint256 assets);
1495 
1496     /**
1497      * @dev Mints exactly shares Vault shares to receiver by depositing amount of underlying tokens.
1498      *
1499      * - MUST emit the Deposit event.
1500      * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the mint
1501      *   execution, and are accounted for during mint.
1502      * - MUST revert if all of shares cannot be minted (due to deposit limit being reached, slippage, the user not
1503      *   approving enough underlying tokens to the Vault contract, etc).
1504      *
1505      * NOTE: most implementations will require pre-approval of the Vault with the Vault’s underlying asset token.
1506      */
1507     function mint(uint256 shares, address receiver) external returns (uint256 assets);
1508 
1509     /**
1510      * @dev Returns the maximum amount of the underlying asset that can be withdrawn from the owner balance in the
1511      * Vault, through a withdraw call.
1512      *
1513      * - MUST return a limited value if owner is subject to some withdrawal limit or timelock.
1514      * - MUST NOT revert.
1515      */
1516     function maxWithdraw(address owner) external view returns (uint256 maxAssets);
1517 
1518     /**
1519      * @dev Allows an on-chain or off-chain user to simulate the effects of their withdrawal at the current block,
1520      * given current on-chain conditions.
1521      *
1522      * - MUST return as close to and no fewer than the exact amount of Vault shares that would be burned in a withdraw
1523      *   call in the same transaction. I.e. withdraw should return the same or fewer shares as previewWithdraw if
1524      *   called
1525      *   in the same transaction.
1526      * - MUST NOT account for withdrawal limits like those returned from maxWithdraw and should always act as though
1527      *   the withdrawal would be accepted, regardless if the user has enough shares, etc.
1528      * - MUST be inclusive of withdrawal fees. Integrators should be aware of the existence of withdrawal fees.
1529      * - MUST NOT revert.
1530      *
1531      * NOTE: any unfavorable discrepancy between convertToShares and previewWithdraw SHOULD be considered slippage in
1532      * share price or some other type of condition, meaning the depositor will lose assets by depositing.
1533      */
1534     function previewWithdraw(uint256 assets) external view returns (uint256 shares);
1535 
1536     /**
1537      * @dev Burns shares from owner and sends exactly assets of underlying tokens to receiver.
1538      *
1539      * - MUST emit the Withdraw event.
1540      * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the
1541      *   withdraw execution, and are accounted for during withdraw.
1542      * - MUST revert if all of assets cannot be withdrawn (due to withdrawal limit being reached, slippage, the owner
1543      *   not having enough shares, etc).
1544      *
1545      * Note that some implementations will require pre-requesting to the Vault before a withdrawal may be performed.
1546      * Those methods should be performed separately.
1547      */
1548     function withdraw(
1549         uint256 assets,
1550         address receiver,
1551         address owner
1552     ) external returns (uint256 shares);
1553 
1554     /**
1555      * @dev Returns the maximum amount of Vault shares that can be redeemed from the owner balance in the Vault,
1556      * through a redeem call.
1557      *
1558      * - MUST return a limited value if owner is subject to some withdrawal limit or timelock.
1559      * - MUST return balanceOf(owner) if owner is not subject to any withdrawal limit or timelock.
1560      * - MUST NOT revert.
1561      */
1562     function maxRedeem(address owner) external view returns (uint256 maxShares);
1563 
1564     /**
1565      * @dev Allows an on-chain or off-chain user to simulate the effects of their redeemption at the current block,
1566      * given current on-chain conditions.
1567      *
1568      * - MUST return as close to and no more than the exact amount of assets that would be withdrawn in a redeem call
1569      *   in the same transaction. I.e. redeem should return the same or more assets as previewRedeem if called in the
1570      *   same transaction.
1571      * - MUST NOT account for redemption limits like those returned from maxRedeem and should always act as though the
1572      *   redemption would be accepted, regardless if the user has enough shares, etc.
1573      * - MUST be inclusive of withdrawal fees. Integrators should be aware of the existence of withdrawal fees.
1574      * - MUST NOT revert.
1575      *
1576      * NOTE: any unfavorable discrepancy between convertToAssets and previewRedeem SHOULD be considered slippage in
1577      * share price or some other type of condition, meaning the depositor will lose assets by redeeming.
1578      */
1579     function previewRedeem(uint256 shares) external view returns (uint256 assets);
1580 
1581     /**
1582      * @dev Burns exactly shares from owner and sends assets of underlying tokens to receiver.
1583      *
1584      * - MUST emit the Withdraw event.
1585      * - MAY support an additional flow in which the underlying tokens are owned by the Vault contract before the
1586      *   redeem execution, and are accounted for during redeem.
1587      * - MUST revert if all of shares cannot be redeemed (due to withdrawal limit being reached, slippage, the owner
1588      *   not having enough shares, etc).
1589      *
1590      * NOTE: some implementations will require pre-requesting to the Vault before a withdrawal may be performed.
1591      * Those methods should be performed separately.
1592      */
1593     function redeem(
1594         uint256 shares,
1595         address receiver,
1596         address owner
1597     ) external returns (uint256 assets);
1598 }
1599 
1600 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1601 
1602 
1603 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/ERC20.sol)
1604 
1605 pragma solidity ^0.8.0;
1606 
1607 
1608 
1609 
1610 /**
1611  * @dev Implementation of the {IERC20} interface.
1612  *
1613  * This implementation is agnostic to the way tokens are created. This means
1614  * that a supply mechanism has to be added in a derived contract using {_mint}.
1615  * For a generic mechanism see {ERC20PresetMinterPauser}.
1616  *
1617  * TIP: For a detailed writeup see our guide
1618  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
1619  * to implement supply mechanisms].
1620  *
1621  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1622  * instead returning `false` on failure. This behavior is nonetheless
1623  * conventional and does not conflict with the expectations of ERC20
1624  * applications.
1625  *
1626  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1627  * This allows applications to reconstruct the allowance for all accounts just
1628  * by listening to said events. Other implementations of the EIP may not emit
1629  * these events, as it isn't required by the specification.
1630  *
1631  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1632  * functions have been added to mitigate the well-known issues around setting
1633  * allowances. See {IERC20-approve}.
1634  */
1635 contract ERC20 is Context, IERC20, IERC20Metadata {
1636     mapping(address => uint256) private _balances;
1637 
1638     mapping(address => mapping(address => uint256)) private _allowances;
1639 
1640     uint256 private _totalSupply;
1641 
1642     string private _name;
1643     string private _symbol;
1644 
1645     /**
1646      * @dev Sets the values for {name} and {symbol}.
1647      *
1648      * The default value of {decimals} is 18. To select a different value for
1649      * {decimals} you should overload it.
1650      *
1651      * All two of these values are immutable: they can only be set once during
1652      * construction.
1653      */
1654     constructor(string memory name_, string memory symbol_) {
1655         _name = name_;
1656         _symbol = symbol_;
1657     }
1658 
1659     /**
1660      * @dev Returns the name of the token.
1661      */
1662     function name() public view virtual override returns (string memory) {
1663         return _name;
1664     }
1665 
1666     /**
1667      * @dev Returns the symbol of the token, usually a shorter version of the
1668      * name.
1669      */
1670     function symbol() public view virtual override returns (string memory) {
1671         return _symbol;
1672     }
1673 
1674     /**
1675      * @dev Returns the number of decimals used to get its user representation.
1676      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1677      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1678      *
1679      * Tokens usually opt for a value of 18, imitating the relationship between
1680      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1681      * overridden;
1682      *
1683      * NOTE: This information is only used for _display_ purposes: it in
1684      * no way affects any of the arithmetic of the contract, including
1685      * {IERC20-balanceOf} and {IERC20-transfer}.
1686      */
1687     function decimals() public view virtual override returns (uint8) {
1688         return 18;
1689     }
1690 
1691     /**
1692      * @dev See {IERC20-totalSupply}.
1693      */
1694     function totalSupply() public view virtual override returns (uint256) {
1695         return _totalSupply;
1696     }
1697 
1698     /**
1699      * @dev See {IERC20-balanceOf}.
1700      */
1701     function balanceOf(address account) public view virtual override returns (uint256) {
1702         return _balances[account];
1703     }
1704 
1705     /**
1706      * @dev See {IERC20-transfer}.
1707      *
1708      * Requirements:
1709      *
1710      * - `to` cannot be the zero address.
1711      * - the caller must have a balance of at least `amount`.
1712      */
1713     function transfer(address to, uint256 amount) public virtual override returns (bool) {
1714         address owner = _msgSender();
1715         _transfer(owner, to, amount);
1716         return true;
1717     }
1718 
1719     /**
1720      * @dev See {IERC20-allowance}.
1721      */
1722     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1723         return _allowances[owner][spender];
1724     }
1725 
1726     /**
1727      * @dev See {IERC20-approve}.
1728      *
1729      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
1730      * `transferFrom`. This is semantically equivalent to an infinite approval.
1731      *
1732      * Requirements:
1733      *
1734      * - `spender` cannot be the zero address.
1735      */
1736     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1737         address owner = _msgSender();
1738         _approve(owner, spender, amount);
1739         return true;
1740     }
1741 
1742     /**
1743      * @dev See {IERC20-transferFrom}.
1744      *
1745      * Emits an {Approval} event indicating the updated allowance. This is not
1746      * required by the EIP. See the note at the beginning of {ERC20}.
1747      *
1748      * NOTE: Does not update the allowance if the current allowance
1749      * is the maximum `uint256`.
1750      *
1751      * Requirements:
1752      *
1753      * - `from` and `to` cannot be the zero address.
1754      * - `from` must have a balance of at least `amount`.
1755      * - the caller must have allowance for ``from``'s tokens of at least
1756      * `amount`.
1757      */
1758     function transferFrom(
1759         address from,
1760         address to,
1761         uint256 amount
1762     ) public virtual override returns (bool) {
1763         address spender = _msgSender();
1764         _spendAllowance(from, spender, amount);
1765         _transfer(from, to, amount);
1766         return true;
1767     }
1768 
1769     /**
1770      * @dev Atomically increases the allowance granted to `spender` by the caller.
1771      *
1772      * This is an alternative to {approve} that can be used as a mitigation for
1773      * problems described in {IERC20-approve}.
1774      *
1775      * Emits an {Approval} event indicating the updated allowance.
1776      *
1777      * Requirements:
1778      *
1779      * - `spender` cannot be the zero address.
1780      */
1781     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1782         address owner = _msgSender();
1783         _approve(owner, spender, allowance(owner, spender) + addedValue);
1784         return true;
1785     }
1786 
1787     /**
1788      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1789      *
1790      * This is an alternative to {approve} that can be used as a mitigation for
1791      * problems described in {IERC20-approve}.
1792      *
1793      * Emits an {Approval} event indicating the updated allowance.
1794      *
1795      * Requirements:
1796      *
1797      * - `spender` cannot be the zero address.
1798      * - `spender` must have allowance for the caller of at least
1799      * `subtractedValue`.
1800      */
1801     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1802         address owner = _msgSender();
1803         uint256 currentAllowance = allowance(owner, spender);
1804         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1805         unchecked {
1806             _approve(owner, spender, currentAllowance - subtractedValue);
1807         }
1808 
1809         return true;
1810     }
1811 
1812     /**
1813      * @dev Moves `amount` of tokens from `from` to `to`.
1814      *
1815      * This internal function is equivalent to {transfer}, and can be used to
1816      * e.g. implement automatic token fees, slashing mechanisms, etc.
1817      *
1818      * Emits a {Transfer} event.
1819      *
1820      * Requirements:
1821      *
1822      * - `from` cannot be the zero address.
1823      * - `to` cannot be the zero address.
1824      * - `from` must have a balance of at least `amount`.
1825      */
1826     function _transfer(
1827         address from,
1828         address to,
1829         uint256 amount
1830     ) internal virtual {
1831         require(from != address(0), "ERC20: transfer from the zero address");
1832         require(to != address(0), "ERC20: transfer to the zero address");
1833 
1834         _beforeTokenTransfer(from, to, amount);
1835 
1836         uint256 fromBalance = _balances[from];
1837         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
1838         unchecked {
1839             _balances[from] = fromBalance - amount;
1840             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
1841             // decrementing then incrementing.
1842             _balances[to] += amount;
1843         }
1844 
1845         emit Transfer(from, to, amount);
1846 
1847         _afterTokenTransfer(from, to, amount);
1848     }
1849 
1850     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1851      * the total supply.
1852      *
1853      * Emits a {Transfer} event with `from` set to the zero address.
1854      *
1855      * Requirements:
1856      *
1857      * - `account` cannot be the zero address.
1858      */
1859     function _mint(address account, uint256 amount) internal virtual {
1860         require(account != address(0), "ERC20: mint to the zero address");
1861 
1862         _beforeTokenTransfer(address(0), account, amount);
1863 
1864         _totalSupply += amount;
1865         unchecked {
1866             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
1867             _balances[account] += amount;
1868         }
1869         emit Transfer(address(0), account, amount);
1870 
1871         _afterTokenTransfer(address(0), account, amount);
1872     }
1873 
1874     /**
1875      * @dev Destroys `amount` tokens from `account`, reducing the
1876      * total supply.
1877      *
1878      * Emits a {Transfer} event with `to` set to the zero address.
1879      *
1880      * Requirements:
1881      *
1882      * - `account` cannot be the zero address.
1883      * - `account` must have at least `amount` tokens.
1884      */
1885     function _burn(address account, uint256 amount) internal virtual {
1886         require(account != address(0), "ERC20: burn from the zero address");
1887 
1888         _beforeTokenTransfer(account, address(0), amount);
1889 
1890         uint256 accountBalance = _balances[account];
1891         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1892         unchecked {
1893             _balances[account] = accountBalance - amount;
1894             // Overflow not possible: amount <= accountBalance <= totalSupply.
1895             _totalSupply -= amount;
1896         }
1897 
1898         emit Transfer(account, address(0), amount);
1899 
1900         _afterTokenTransfer(account, address(0), amount);
1901     }
1902 
1903     /**
1904      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1905      *
1906      * This internal function is equivalent to `approve`, and can be used to
1907      * e.g. set automatic allowances for certain subsystems, etc.
1908      *
1909      * Emits an {Approval} event.
1910      *
1911      * Requirements:
1912      *
1913      * - `owner` cannot be the zero address.
1914      * - `spender` cannot be the zero address.
1915      */
1916     function _approve(
1917         address owner,
1918         address spender,
1919         uint256 amount
1920     ) internal virtual {
1921         require(owner != address(0), "ERC20: approve from the zero address");
1922         require(spender != address(0), "ERC20: approve to the zero address");
1923 
1924         _allowances[owner][spender] = amount;
1925         emit Approval(owner, spender, amount);
1926     }
1927 
1928     /**
1929      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
1930      *
1931      * Does not update the allowance amount in case of infinite allowance.
1932      * Revert if not enough allowance is available.
1933      *
1934      * Might emit an {Approval} event.
1935      */
1936     function _spendAllowance(
1937         address owner,
1938         address spender,
1939         uint256 amount
1940     ) internal virtual {
1941         uint256 currentAllowance = allowance(owner, spender);
1942         if (currentAllowance != type(uint256).max) {
1943             require(currentAllowance >= amount, "ERC20: insufficient allowance");
1944             unchecked {
1945                 _approve(owner, spender, currentAllowance - amount);
1946             }
1947         }
1948     }
1949 
1950     /**
1951      * @dev Hook that is called before any transfer of tokens. This includes
1952      * minting and burning.
1953      *
1954      * Calling conditions:
1955      *
1956      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1957      * will be transferred to `to`.
1958      * - when `from` is zero, `amount` tokens will be minted for `to`.
1959      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1960      * - `from` and `to` are never both zero.
1961      *
1962      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1963      */
1964     function _beforeTokenTransfer(
1965         address from,
1966         address to,
1967         uint256 amount
1968     ) internal virtual {}
1969 
1970     /**
1971      * @dev Hook that is called after any transfer of tokens. This includes
1972      * minting and burning.
1973      *
1974      * Calling conditions:
1975      *
1976      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1977      * has been transferred to `to`.
1978      * - when `from` is zero, `amount` tokens have been minted for `to`.
1979      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1980      * - `from` and `to` are never both zero.
1981      *
1982      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1983      */
1984     function _afterTokenTransfer(
1985         address from,
1986         address to,
1987         uint256 amount
1988     ) internal virtual {}
1989 }
1990 
1991 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1992 
1993 
1994 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/extensions/draft-ERC20Permit.sol)
1995 
1996 pragma solidity ^0.8.0;
1997 
1998 
1999 
2000 
2001 
2002 
2003 /**
2004  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
2005  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
2006  *
2007  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
2008  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
2009  * need to send a transaction, and thus is not required to hold Ether at all.
2010  *
2011  * _Available since v3.4._
2012  */
2013 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
2014     using Counters for Counters.Counter;
2015 
2016     mapping(address => Counters.Counter) private _nonces;
2017 
2018     // solhint-disable-next-line var-name-mixedcase
2019     bytes32 private constant _PERMIT_TYPEHASH =
2020         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
2021     /**
2022      * @dev In previous versions `_PERMIT_TYPEHASH` was declared as `immutable`.
2023      * However, to ensure consistency with the upgradeable transpiler, we will continue
2024      * to reserve a slot.
2025      * @custom:oz-renamed-from _PERMIT_TYPEHASH
2026      */
2027     // solhint-disable-next-line var-name-mixedcase
2028     bytes32 private _PERMIT_TYPEHASH_DEPRECATED_SLOT;
2029 
2030     /**
2031      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
2032      *
2033      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
2034      */
2035     constructor(string memory name) EIP712(name, "1") {}
2036 
2037     /**
2038      * @dev See {IERC20Permit-permit}.
2039      */
2040     function permit(
2041         address owner,
2042         address spender,
2043         uint256 value,
2044         uint256 deadline,
2045         uint8 v,
2046         bytes32 r,
2047         bytes32 s
2048     ) public virtual override {
2049         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
2050 
2051         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
2052 
2053         bytes32 hash = _hashTypedDataV4(structHash);
2054 
2055         address signer = ECDSA.recover(hash, v, r, s);
2056         require(signer == owner, "ERC20Permit: invalid signature");
2057 
2058         _approve(owner, spender, value);
2059     }
2060 
2061     /**
2062      * @dev See {IERC20Permit-nonces}.
2063      */
2064     function nonces(address owner) public view virtual override returns (uint256) {
2065         return _nonces[owner].current();
2066     }
2067 
2068     /**
2069      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
2070      */
2071     // solhint-disable-next-line func-name-mixedcase
2072     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
2073         return _domainSeparatorV4();
2074     }
2075 
2076     /**
2077      * @dev "Consume a nonce": return the current value and increment.
2078      *
2079      * _Available since v4.1._
2080      */
2081     function _useNonce(address owner) internal virtual returns (uint256 current) {
2082         Counters.Counter storage nonce = _nonces[owner];
2083         current = nonce.current();
2084         nonce.increment();
2085     }
2086 }
2087 
2088 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC4626.sol
2089 
2090 
2091 // OpenZeppelin Contracts (last updated v4.8.1) (token/ERC20/extensions/ERC4626.sol)
2092 
2093 pragma solidity ^0.8.0;
2094 
2095 
2096 
2097 
2098 
2099 /**
2100  * @dev Implementation of the ERC4626 "Tokenized Vault Standard" as defined in
2101  * https://eips.ethereum.org/EIPS/eip-4626[EIP-4626].
2102  *
2103  * This extension allows the minting and burning of "shares" (represented using the ERC20 inheritance) in exchange for
2104  * underlying "assets" through standardized {deposit}, {mint}, {redeem} and {burn} workflows. This contract extends
2105  * the ERC20 standard. Any additional extensions included along it would affect the "shares" token represented by this
2106  * contract and not the "assets" token which is an independent contract.
2107  *
2108  * CAUTION: When the vault is empty or nearly empty, deposits are at high risk of being stolen through frontrunning with
2109  * a "donation" to the vault that inflates the price of a share. This is variously known as a donation or inflation
2110  * attack and is essentially a problem of slippage. Vault deployers can protect against this attack by making an initial
2111  * deposit of a non-trivial amount of the asset, such that price manipulation becomes infeasible. Withdrawals may
2112  * similarly be affected by slippage. Users can protect against this attack as well unexpected slippage in general by
2113  * verifying the amount received is as expected, using a wrapper that performs these checks such as
2114  * https://github.com/fei-protocol/ERC4626#erc4626router-and-base[ERC4626Router].
2115  *
2116  * _Available since v4.7._
2117  */
2118 abstract contract ERC4626 is ERC20, IERC4626 {
2119     using Math for uint256;
2120 
2121     IERC20 private immutable _asset;
2122     uint8 private immutable _decimals;
2123 
2124     /**
2125      * @dev Set the underlying asset contract. This must be an ERC20-compatible contract (ERC20 or ERC777).
2126      */
2127     constructor(IERC20 asset_) {
2128         (bool success, uint8 assetDecimals) = _tryGetAssetDecimals(asset_);
2129         _decimals = success ? assetDecimals : super.decimals();
2130         _asset = asset_;
2131     }
2132 
2133     /**
2134      * @dev Attempts to fetch the asset decimals. A return value of false indicates that the attempt failed in some way.
2135      */
2136     function _tryGetAssetDecimals(IERC20 asset_) private view returns (bool, uint8) {
2137         (bool success, bytes memory encodedDecimals) = address(asset_).staticcall(
2138             abi.encodeWithSelector(IERC20Metadata.decimals.selector)
2139         );
2140         if (success && encodedDecimals.length >= 32) {
2141             uint256 returnedDecimals = abi.decode(encodedDecimals, (uint256));
2142             if (returnedDecimals <= type(uint8).max) {
2143                 return (true, uint8(returnedDecimals));
2144             }
2145         }
2146         return (false, 0);
2147     }
2148 
2149     /**
2150      * @dev Decimals are read from the underlying asset in the constructor and cached. If this fails (e.g., the asset
2151      * has not been created yet), the cached value is set to a default obtained by `super.decimals()` (which depends on
2152      * inheritance but is most likely 18). Override this function in order to set a guaranteed hardcoded value.
2153      * See {IERC20Metadata-decimals}.
2154      */
2155     function decimals() public view virtual override(IERC20Metadata, ERC20) returns (uint8) {
2156         return _decimals;
2157     }
2158 
2159     /** @dev See {IERC4626-asset}. */
2160     function asset() public view virtual override returns (address) {
2161         return address(_asset);
2162     }
2163 
2164     /** @dev See {IERC4626-totalAssets}. */
2165     function totalAssets() public view virtual override returns (uint256) {
2166         return _asset.balanceOf(address(this));
2167     }
2168 
2169     /** @dev See {IERC4626-convertToShares}. */
2170     function convertToShares(uint256 assets) public view virtual override returns (uint256 shares) {
2171         return _convertToShares(assets, Math.Rounding.Down);
2172     }
2173 
2174     /** @dev See {IERC4626-convertToAssets}. */
2175     function convertToAssets(uint256 shares) public view virtual override returns (uint256 assets) {
2176         return _convertToAssets(shares, Math.Rounding.Down);
2177     }
2178 
2179     /** @dev See {IERC4626-maxDeposit}. */
2180     function maxDeposit(address) public view virtual override returns (uint256) {
2181         return _isVaultCollateralized() ? type(uint256).max : 0;
2182     }
2183 
2184     /** @dev See {IERC4626-maxMint}. */
2185     function maxMint(address) public view virtual override returns (uint256) {
2186         return type(uint256).max;
2187     }
2188 
2189     /** @dev See {IERC4626-maxWithdraw}. */
2190     function maxWithdraw(address owner) public view virtual override returns (uint256) {
2191         return _convertToAssets(balanceOf(owner), Math.Rounding.Down);
2192     }
2193 
2194     /** @dev See {IERC4626-maxRedeem}. */
2195     function maxRedeem(address owner) public view virtual override returns (uint256) {
2196         return balanceOf(owner);
2197     }
2198 
2199     /** @dev See {IERC4626-previewDeposit}. */
2200     function previewDeposit(uint256 assets) public view virtual override returns (uint256) {
2201         return _convertToShares(assets, Math.Rounding.Down);
2202     }
2203 
2204     /** @dev See {IERC4626-previewMint}. */
2205     function previewMint(uint256 shares) public view virtual override returns (uint256) {
2206         return _convertToAssets(shares, Math.Rounding.Up);
2207     }
2208 
2209     /** @dev See {IERC4626-previewWithdraw}. */
2210     function previewWithdraw(uint256 assets) public view virtual override returns (uint256) {
2211         return _convertToShares(assets, Math.Rounding.Up);
2212     }
2213 
2214     /** @dev See {IERC4626-previewRedeem}. */
2215     function previewRedeem(uint256 shares) public view virtual override returns (uint256) {
2216         return _convertToAssets(shares, Math.Rounding.Down);
2217     }
2218 
2219     /** @dev See {IERC4626-deposit}. */
2220     function deposit(uint256 assets, address receiver) public virtual override returns (uint256) {
2221         require(assets <= maxDeposit(receiver), "ERC4626: deposit more than max");
2222 
2223         uint256 shares = previewDeposit(assets);
2224         _deposit(_msgSender(), receiver, assets, shares);
2225 
2226         return shares;
2227     }
2228 
2229     /** @dev See {IERC4626-mint}.
2230      *
2231      * As opposed to {deposit}, minting is allowed even if the vault is in a state where the price of a share is zero.
2232      * In this case, the shares will be minted without requiring any assets to be deposited.
2233      */
2234     function mint(uint256 shares, address receiver) public virtual override returns (uint256) {
2235         require(shares <= maxMint(receiver), "ERC4626: mint more than max");
2236 
2237         uint256 assets = previewMint(shares);
2238         _deposit(_msgSender(), receiver, assets, shares);
2239 
2240         return assets;
2241     }
2242 
2243     /** @dev See {IERC4626-withdraw}. */
2244     function withdraw(
2245         uint256 assets,
2246         address receiver,
2247         address owner
2248     ) public virtual override returns (uint256) {
2249         require(assets <= maxWithdraw(owner), "ERC4626: withdraw more than max");
2250 
2251         uint256 shares = previewWithdraw(assets);
2252         _withdraw(_msgSender(), receiver, owner, assets, shares);
2253 
2254         return shares;
2255     }
2256 
2257     /** @dev See {IERC4626-redeem}. */
2258     function redeem(
2259         uint256 shares,
2260         address receiver,
2261         address owner
2262     ) public virtual override returns (uint256) {
2263         require(shares <= maxRedeem(owner), "ERC4626: redeem more than max");
2264 
2265         uint256 assets = previewRedeem(shares);
2266         _withdraw(_msgSender(), receiver, owner, assets, shares);
2267 
2268         return assets;
2269     }
2270 
2271     /**
2272      * @dev Internal conversion function (from assets to shares) with support for rounding direction.
2273      *
2274      * Will revert if assets > 0, totalSupply > 0 and totalAssets = 0. That corresponds to a case where any asset
2275      * would represent an infinite amount of shares.
2276      */
2277     function _convertToShares(uint256 assets, Math.Rounding rounding) internal view virtual returns (uint256 shares) {
2278         uint256 supply = totalSupply();
2279         return
2280             (assets == 0 || supply == 0)
2281                 ? _initialConvertToShares(assets, rounding)
2282                 : assets.mulDiv(supply, totalAssets(), rounding);
2283     }
2284 
2285     /**
2286      * @dev Internal conversion function (from assets to shares) to apply when the vault is empty.
2287      *
2288      * NOTE: Make sure to keep this function consistent with {_initialConvertToAssets} when overriding it.
2289      */
2290     function _initialConvertToShares(
2291         uint256 assets,
2292         Math.Rounding /*rounding*/
2293     ) internal view virtual returns (uint256 shares) {
2294         return assets;
2295     }
2296 
2297     /**
2298      * @dev Internal conversion function (from shares to assets) with support for rounding direction.
2299      */
2300     function _convertToAssets(uint256 shares, Math.Rounding rounding) internal view virtual returns (uint256 assets) {
2301         uint256 supply = totalSupply();
2302         return
2303             (supply == 0) ? _initialConvertToAssets(shares, rounding) : shares.mulDiv(totalAssets(), supply, rounding);
2304     }
2305 
2306     /**
2307      * @dev Internal conversion function (from shares to assets) to apply when the vault is empty.
2308      *
2309      * NOTE: Make sure to keep this function consistent with {_initialConvertToShares} when overriding it.
2310      */
2311     function _initialConvertToAssets(
2312         uint256 shares,
2313         Math.Rounding /*rounding*/
2314     ) internal view virtual returns (uint256 assets) {
2315         return shares;
2316     }
2317 
2318     /**
2319      * @dev Deposit/mint common workflow.
2320      */
2321     function _deposit(
2322         address caller,
2323         address receiver,
2324         uint256 assets,
2325         uint256 shares
2326     ) internal virtual {
2327         // If _asset is ERC777, `transferFrom` can trigger a reenterancy BEFORE the transfer happens through the
2328         // `tokensToSend` hook. On the other hand, the `tokenReceived` hook, that is triggered after the transfer,
2329         // calls the vault, which is assumed not malicious.
2330         //
2331         // Conclusion: we need to do the transfer before we mint so that any reentrancy would happen before the
2332         // assets are transferred and before the shares are minted, which is a valid state.
2333         // slither-disable-next-line reentrancy-no-eth
2334         SafeERC20.safeTransferFrom(_asset, caller, address(this), assets);
2335         _mint(receiver, shares);
2336 
2337         emit Deposit(caller, receiver, assets, shares);
2338     }
2339 
2340     /**
2341      * @dev Withdraw/redeem common workflow.
2342      */
2343     function _withdraw(
2344         address caller,
2345         address receiver,
2346         address owner,
2347         uint256 assets,
2348         uint256 shares
2349     ) internal virtual {
2350         if (caller != owner) {
2351             _spendAllowance(owner, caller, shares);
2352         }
2353 
2354         // If _asset is ERC777, `transfer` can trigger a reentrancy AFTER the transfer happens through the
2355         // `tokensReceived` hook. On the other hand, the `tokensToSend` hook, that is triggered before the transfer,
2356         // calls the vault, which is assumed not malicious.
2357         //
2358         // Conclusion: we need to do the transfer after the burn so that any reentrancy would happen after the
2359         // shares are burned and after the assets are transferred, which is a valid state.
2360         _burn(owner, shares);
2361         SafeERC20.safeTransfer(_asset, receiver, assets);
2362 
2363         emit Withdraw(caller, receiver, owner, assets, shares);
2364     }
2365 
2366     /**
2367      * @dev Checks if vault is "healthy" in the sense of having assets backing the circulating shares.
2368      */
2369     function _isVaultCollateralized() private view returns (bool) {
2370         return totalAssets() > 0 || totalSupply() == 0;
2371     }
2372 }
2373 
2374 // File: contracts/vXDEFI.sol
2375 
2376 
2377 
2378 pragma solidity =0.8.18;
2379 
2380 
2381 
2382 /**
2383  * @title XDEFI Vault - for vXDEFI (vXDEFI)
2384  * @author David P. (dp@xdefi.io)
2385  */
2386 contract XDEFIVault is ERC4626, ERC20Permit {
2387     bytes32 private immutable _salt;
2388 
2389     constructor(address underlying) ERC20("vXDEFI", "vXDEFI") ERC4626(IERC20(underlying)) ERC20Permit("vXDEFI") {
2390         require(underlying != address(0), "Underlying token address cannot be 0x0");
2391         _salt = keccak256(abi.encodePacked(block.timestamp, msg.sender));
2392     }
2393 
2394     function decimals() public view virtual override(ERC20, ERC4626) returns (uint8) {
2395         return ERC4626.decimals();
2396     }
2397 
2398     /**
2399      * @dev See {EIP-5267}.
2400      */
2401     function eip712Domain() public view virtual returns (bytes1 fields, string memory name, string memory version, uint256 chainId, address verifyingContract, bytes32 salt, uint256[] memory extensions) {
2402         return (
2403             hex"0f", // 01111
2404             "vXDEFI",
2405             "1",
2406             block.chainid,
2407             address(this),
2408             _salt,
2409             new uint256[](0)
2410         );
2411     }
2412 }