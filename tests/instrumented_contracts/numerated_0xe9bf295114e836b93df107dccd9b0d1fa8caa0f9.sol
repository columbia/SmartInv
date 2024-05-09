1 // File: ArcanaERC721A.sol_flattened.sol
2 
3 
4 
5 
6 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 
11 library Counters {
12     struct Counter {
13         
14         uint256 _value; // default: 0
15     }
16 
17     function current(Counter storage counter) internal view returns (uint256) {
18         return counter._value;
19     }
20 
21     function increment(Counter storage counter) internal {
22         unchecked {
23             counter._value += 1;
24         }
25     }
26 
27     function decrement(Counter storage counter) internal {
28         uint256 value = counter._value;
29         require(value > 0, "Counter: decrement overflow");
30         unchecked {
31             counter._value = value - 1;
32         }
33     }
34 
35     function reset(Counter storage counter) internal {
36         counter._value = 0;
37     }
38 }
39 
40 // File: @openzeppelin/contracts/utils/math/Math.sol
41 
42 
43 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
44 
45 pragma solidity ^0.8.0;
46 
47 /**
48  * @dev Standard math utilities missing in the Solidity language.
49  */
50 library Math {
51     enum Rounding {
52         Down, // Toward negative infinity
53         Up, // Toward infinity
54         Zero // Toward zero
55     }
56 
57     /**
58      * @dev Returns the largest of two numbers.
59      */
60     function max(uint256 a, uint256 b) internal pure returns (uint256) {
61         return a > b ? a : b;
62     }
63 
64     /**
65      * @dev Returns the smallest of two numbers.
66      */
67     function min(uint256 a, uint256 b) internal pure returns (uint256) {
68         return a < b ? a : b;
69     }
70 
71     /**
72      * @dev Returns the average of two numbers. The result is rounded towards
73      * zero.
74      */
75     function average(uint256 a, uint256 b) internal pure returns (uint256) {
76         // (a + b) / 2 can overflow.
77         return (a & b) + (a ^ b) / 2;
78     }
79 
80     /**
81      * @dev Returns the ceiling of the division of two numbers.
82      *
83      * This differs from standard division with `/` in that it rounds up instead
84      * of rounding down.
85      */
86     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
87         // (a + b - 1) / b can overflow on addition, so we distribute.
88         return a == 0 ? 0 : (a - 1) / b + 1;
89     }
90 
91     /**
92      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
93      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
94      * with further edits by Uniswap Labs also under MIT license.
95      */
96     function mulDiv(
97         uint256 x,
98         uint256 y,
99         uint256 denominator
100     ) internal pure returns (uint256 result) {
101         unchecked {
102             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
103             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
104             // variables such that product = prod1 * 2^256 + prod0.
105             uint256 prod0; // Least significant 256 bits of the product
106             uint256 prod1; // Most significant 256 bits of the product
107             assembly {
108                 let mm := mulmod(x, y, not(0))
109                 prod0 := mul(x, y)
110                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
111             }
112 
113             // Handle non-overflow cases, 256 by 256 division.
114             if (prod1 == 0) {
115                 return prod0 / denominator;
116             }
117 
118             // Make sure the result is less than 2^256. Also prevents denominator == 0.
119             require(denominator > prod1);
120 
121             ///////////////////////////////////////////////
122             // 512 by 256 division.
123             ///////////////////////////////////////////////
124 
125             // Make division exact by subtracting the remainder from [prod1 prod0].
126             uint256 remainder;
127             assembly {
128                 // Compute remainder using mulmod.
129                 remainder := mulmod(x, y, denominator)
130 
131                 // Subtract 256 bit number from 512 bit number.
132                 prod1 := sub(prod1, gt(remainder, prod0))
133                 prod0 := sub(prod0, remainder)
134             }
135 
136             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
137             // See https://cs.stackexchange.com/q/138556/92363.
138 
139             // Does not overflow because the denominator cannot be zero at this stage in the function.
140             uint256 twos = denominator & (~denominator + 1);
141             assembly {
142                 // Divide denominator by twos.
143                 denominator := div(denominator, twos)
144 
145                 // Divide [prod1 prod0] by twos.
146                 prod0 := div(prod0, twos)
147 
148                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
149                 twos := add(div(sub(0, twos), twos), 1)
150             }
151 
152             // Shift in bits from prod1 into prod0.
153             prod0 |= prod1 * twos;
154 
155             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
156             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
157             // four bits. That is, denominator * inv = 1 mod 2^4.
158             uint256 inverse = (3 * denominator) ^ 2;
159 
160             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
161             // in modular arithmetic, doubling the correct bits in each step.
162             inverse *= 2 - denominator * inverse; // inverse mod 2^8
163             inverse *= 2 - denominator * inverse; // inverse mod 2^16
164             inverse *= 2 - denominator * inverse; // inverse mod 2^32
165             inverse *= 2 - denominator * inverse; // inverse mod 2^64
166             inverse *= 2 - denominator * inverse; // inverse mod 2^128
167             inverse *= 2 - denominator * inverse; // inverse mod 2^256
168 
169             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
170             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
171             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
172             // is no longer required.
173             result = prod0 * inverse;
174             return result;
175         }
176     }
177 
178     /**
179      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
180      */
181     function mulDiv(
182         uint256 x,
183         uint256 y,
184         uint256 denominator,
185         Rounding rounding
186     ) internal pure returns (uint256) {
187         uint256 result = mulDiv(x, y, denominator);
188         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
189             result += 1;
190         }
191         return result;
192     }
193 
194     
195     function sqrt(uint256 a) internal pure returns (uint256) {
196         if (a == 0) {
197             return 0;
198         }
199 
200         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
201         //
202         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
203         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
204         //
205         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
206         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
207         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
208         //
209         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
210         uint256 result = 1 << (log2(a) >> 1);
211 
212         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
213         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
214         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
215         // into the expected uint128 result.
216         unchecked {
217             result = (result + a / result) >> 1;
218             result = (result + a / result) >> 1;
219             result = (result + a / result) >> 1;
220             result = (result + a / result) >> 1;
221             result = (result + a / result) >> 1;
222             result = (result + a / result) >> 1;
223             result = (result + a / result) >> 1;
224             return min(result, a / result);
225         }
226     }
227 
228     /**
229      * @notice Calculates sqrt(a), following the selected rounding direction.
230      */
231     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
232         unchecked {
233             uint256 result = sqrt(a);
234             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
235         }
236     }
237 
238     /**
239      * @dev Return the log in base 2, rounded down, of a positive value.
240      * Returns 0 if given 0.
241      */
242     function log2(uint256 value) internal pure returns (uint256) {
243         uint256 result = 0;
244         unchecked {
245             if (value >> 128 > 0) {
246                 value >>= 128;
247                 result += 128;
248             }
249             if (value >> 64 > 0) {
250                 value >>= 64;
251                 result += 64;
252             }
253             if (value >> 32 > 0) {
254                 value >>= 32;
255                 result += 32;
256             }
257             if (value >> 16 > 0) {
258                 value >>= 16;
259                 result += 16;
260             }
261             if (value >> 8 > 0) {
262                 value >>= 8;
263                 result += 8;
264             }
265             if (value >> 4 > 0) {
266                 value >>= 4;
267                 result += 4;
268             }
269             if (value >> 2 > 0) {
270                 value >>= 2;
271                 result += 2;
272             }
273             if (value >> 1 > 0) {
274                 result += 1;
275             }
276         }
277         return result;
278     }
279 
280     /**
281      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
282      * Returns 0 if given 0.
283      */
284     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
285         unchecked {
286             uint256 result = log2(value);
287             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
288         }
289     }
290 
291     /**
292      * @dev Return the log in base 10, rounded down, of a positive value.
293      * Returns 0 if given 0.
294      */
295     function log10(uint256 value) internal pure returns (uint256) {
296         uint256 result = 0;
297         unchecked {
298             if (value >= 10**64) {
299                 value /= 10**64;
300                 result += 64;
301             }
302             if (value >= 10**32) {
303                 value /= 10**32;
304                 result += 32;
305             }
306             if (value >= 10**16) {
307                 value /= 10**16;
308                 result += 16;
309             }
310             if (value >= 10**8) {
311                 value /= 10**8;
312                 result += 8;
313             }
314             if (value >= 10**4) {
315                 value /= 10**4;
316                 result += 4;
317             }
318             if (value >= 10**2) {
319                 value /= 10**2;
320                 result += 2;
321             }
322             if (value >= 10**1) {
323                 result += 1;
324             }
325         }
326         return result;
327     }
328 
329     /**
330      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
331      * Returns 0 if given 0.
332      */
333     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
334         unchecked {
335             uint256 result = log10(value);
336             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
337         }
338     }
339 
340     /**
341      * @dev Return the log in base 256, rounded down, of a positive value.
342      * Returns 0 if given 0.
343      *
344      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
345      */
346     function log256(uint256 value) internal pure returns (uint256) {
347         uint256 result = 0;
348         unchecked {
349             if (value >> 128 > 0) {
350                 value >>= 128;
351                 result += 16;
352             }
353             if (value >> 64 > 0) {
354                 value >>= 64;
355                 result += 8;
356             }
357             if (value >> 32 > 0) {
358                 value >>= 32;
359                 result += 4;
360             }
361             if (value >> 16 > 0) {
362                 value >>= 16;
363                 result += 2;
364             }
365             if (value >> 8 > 0) {
366                 result += 1;
367             }
368         }
369         return result;
370     }
371 
372     /**
373      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
374      * Returns 0 if given 0.
375      */
376     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
377         unchecked {
378             uint256 result = log256(value);
379             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
380         }
381     }
382 }
383 
384 // File: @openzeppelin/contracts/utils/Strings.sol
385 
386 
387 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
388 
389 pragma solidity ^0.8.0;
390 
391 
392 /**
393  * @dev String operations.
394  */
395 library Strings {
396     bytes16 private constant _SYMBOLS = "0123456789abcdef";
397     uint8 private constant _ADDRESS_LENGTH = 20;
398 
399     /**
400      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
401      */
402     function toString(uint256 value) internal pure returns (string memory) {
403         unchecked {
404             uint256 length = Math.log10(value) + 1;
405             string memory buffer = new string(length);
406             uint256 ptr;
407             /// @solidity memory-safe-assembly
408             assembly {
409                 ptr := add(buffer, add(32, length))
410             }
411             while (true) {
412                 ptr--;
413                 /// @solidity memory-safe-assembly
414                 assembly {
415                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
416                 }
417                 value /= 10;
418                 if (value == 0) break;
419             }
420             return buffer;
421         }
422     }
423 
424     /**
425      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
426      */
427     function toHexString(uint256 value) internal pure returns (string memory) {
428         unchecked {
429             return toHexString(value, Math.log256(value) + 1);
430         }
431     }
432 
433     /**
434      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
435      */
436     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
437         bytes memory buffer = new bytes(2 * length + 2);
438         buffer[0] = "0";
439         buffer[1] = "x";
440         for (uint256 i = 2 * length + 1; i > 1; --i) {
441             buffer[i] = _SYMBOLS[value & 0xf];
442             value >>= 4;
443         }
444         require(value == 0, "Strings: hex length insufficient");
445         return string(buffer);
446     }
447 
448     /**
449      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
450      */
451     function toHexString(address addr) internal pure returns (string memory) {
452         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
453     }
454 }
455 
456 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
457 
458 
459 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
460 
461 pragma solidity ^0.8.0;
462 
463 
464 /**
465  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
466  *
467  * These functions can be used to verify that a message was signed by the holder
468  * of the private keys of a given address.
469  */
470 library ECDSA {
471     enum RecoverError {
472         NoError,
473         InvalidSignature,
474         InvalidSignatureLength,
475         InvalidSignatureS,
476         InvalidSignatureV // Deprecated in v4.8
477     }
478 
479     function _throwError(RecoverError error) private pure {
480         if (error == RecoverError.NoError) {
481             return; // no error: do nothing
482         } else if (error == RecoverError.InvalidSignature) {
483             revert("ECDSA: invalid signature");
484         } else if (error == RecoverError.InvalidSignatureLength) {
485             revert("ECDSA: invalid signature length");
486         } else if (error == RecoverError.InvalidSignatureS) {
487             revert("ECDSA: invalid signature 's' value");
488         }
489     }
490 
491     /**
492      * @dev Returns the address that signed a hashed message (`hash`) with
493      * `signature` or error string. This address can then be used for verification purposes.
494      *
495      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
496      * this function rejects them by requiring the `s` value to be in the lower
497      * half order, and the `v` value to be either 27 or 28.
498      *
499      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
500      * verification to be secure: it is possible to craft signatures that
501      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
502      * this is by receiving a hash of the original message (which may otherwise
503      * be too long), and then calling {toEthSignedMessageHash} on it.
504      *
505      * Documentation for signature generation:
506      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
507      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
508      *
509      * _Available since v4.3._
510      */
511     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
512         if (signature.length == 65) {
513             bytes32 r;
514             bytes32 s;
515             uint8 v;
516             // ecrecover takes the signature parameters, and the only way to get them
517             // currently is to use assembly.
518             /// @solidity memory-safe-assembly
519             assembly {
520                 r := mload(add(signature, 0x20))
521                 s := mload(add(signature, 0x40))
522                 v := byte(0, mload(add(signature, 0x60)))
523             }
524             return tryRecover(hash, v, r, s);
525         } else {
526             return (address(0), RecoverError.InvalidSignatureLength);
527         }
528     }
529 
530     /**
531      * @dev Returns the address that signed a hashed message (`hash`) with
532      * `signature`. This address can then be used for verification purposes.
533      *
534      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
535      * this function rejects them by requiring the `s` value to be in the lower
536      * half order, and the `v` value to be either 27 or 28.
537      *
538      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
539      * verification to be secure: it is possible to craft signatures that
540      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
541      * this is by receiving a hash of the original message (which may otherwise
542      * be too long), and then calling {toEthSignedMessageHash} on it.
543      */
544     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
545         (address recovered, RecoverError error) = tryRecover(hash, signature);
546         _throwError(error);
547         return recovered;
548     }
549 
550     /**
551      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
552      *
553      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
554      *
555      * _Available since v4.3._
556      */
557     function tryRecover(
558         bytes32 hash,
559         bytes32 r,
560         bytes32 vs
561     ) internal pure returns (address, RecoverError) {
562         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
563         uint8 v = uint8((uint256(vs) >> 255) + 27);
564         return tryRecover(hash, v, r, s);
565     }
566 
567     /**
568      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
569      *
570      * _Available since v4.2._
571      */
572     function recover(
573         bytes32 hash,
574         bytes32 r,
575         bytes32 vs
576     ) internal pure returns (address) {
577         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
578         _throwError(error);
579         return recovered;
580     }
581 
582     /**
583      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
584      * `r` and `s` signature fields separately.
585      *
586      * _Available since v4.3._
587      */
588     function tryRecover(
589         bytes32 hash,
590         uint8 v,
591         bytes32 r,
592         bytes32 s
593     ) internal pure returns (address, RecoverError) {
594         
595         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
596             return (address(0), RecoverError.InvalidSignatureS);
597         }
598 
599         // If the signature is valid (and not malleable), return the signer address
600         address signer = ecrecover(hash, v, r, s);
601         if (signer == address(0)) {
602             return (address(0), RecoverError.InvalidSignature);
603         }
604 
605         return (signer, RecoverError.NoError);
606     }
607 
608     /**
609      * @dev Overload of {ECDSA-recover} that receives the `v`,
610      * `r` and `s` signature fields separately.
611      */
612     function recover(
613         bytes32 hash,
614         uint8 v,
615         bytes32 r,
616         bytes32 s
617     ) internal pure returns (address) {
618         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
619         _throwError(error);
620         return recovered;
621     }
622 
623     /**
624      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
625      * produces hash corresponding to the one signed with the
626      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
627      * JSON-RPC method as part of EIP-191.
628      *
629      * See {recover}.
630      */
631     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
632         // 32 is the length in bytes of hash,
633         // enforced by the type signature above
634         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
635     }
636 
637     /**
638      * @dev Returns an Ethereum Signed Message, created from `s`. This
639      * produces hash corresponding to the one signed with the
640      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
641      * JSON-RPC method as part of EIP-191.
642      *
643      * See {recover}.
644      */
645     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
646         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
647     }
648 
649     /**
650      * @dev Returns an Ethereum Signed Typed Data, created from a
651      * `domainSeparator` and a `structHash`. This produces hash corresponding
652      * to the one signed with the
653      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
654      * JSON-RPC method as part of EIP-712.
655      *
656      * See {recover}.
657      */
658     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
659         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
660     }
661 }
662 
663 // File: @openzeppelin/contracts/utils/Context.sol
664 
665 
666 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
667 
668 pragma solidity ^0.8.0;
669 
670 /**
671  * @dev Provides information about the current execution context, including the
672  * sender of the transaction and its data. While these are generally available
673  * via msg.sender and msg.data, they should not be accessed in such a direct
674  * manner, since when dealing with meta-transactions the account sending and
675  * paying for execution may not be the actual sender (as far as an application
676  * is concerned).
677  *
678  * This contract is only required for intermediate, library-like contracts.
679  */
680 abstract contract Context {
681     function _msgSender() internal view virtual returns (address) {
682         return msg.sender;
683     }
684 
685     function _msgData() internal view virtual returns (bytes calldata) {
686         return msg.data;
687     }
688 }
689 
690 // File: @openzeppelin/contracts/access/Ownable.sol
691 
692 
693 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
694 
695 pragma solidity ^0.8.0;
696 
697 
698 /**
699  * @dev Contract module which provides a basic access control mechanism, where
700  * there is an account (an owner) that can be granted exclusive access to
701  * specific functions.
702  *
703  * By default, the owner account will be the one that deploys the contract. This
704  * can later be changed with {transferOwnership}.
705  *
706  * This module is used through inheritance. It will make available the modifier
707  * `onlyOwner`, which can be applied to your functions to restrict their use to
708  * the owner.
709  */
710 abstract contract Ownable is Context {
711     address private _owner;
712 
713     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
714 
715     /**
716      * @dev Initializes the contract setting the deployer as the initial owner.
717      */
718     constructor() {
719         _transferOwnership(_msgSender());
720     }
721 
722     /**
723      * @dev Throws if called by any account other than the owner.
724      */
725     modifier onlyOwner() {
726         _checkOwner();
727         _;
728     }
729 
730     /**
731      * @dev Returns the address of the current owner.
732      */
733     function owner() public view virtual returns (address) {
734         return _owner;
735     }
736 
737     /**
738      * @dev Throws if the sender is not the owner.
739      */
740     function _checkOwner() internal view virtual {
741         require(owner() == _msgSender(), "Ownable: caller is not the owner");
742     }
743 
744     /**
745      * @dev Leaves the contract without owner. It will not be possible to call
746      * `onlyOwner` functions anymore. Can only be called by the current owner.
747      *
748      * NOTE: Renouncing ownership will leave the contract without an owner,
749      * thereby removing any functionality that is only available to the owner.
750      */
751     function renounceOwnership() public virtual onlyOwner {
752         _transferOwnership(address(0));
753     }
754 
755     /**
756      * @dev Transfers ownership of the contract to a new account (`newOwner`).
757      * Can only be called by the current owner.
758      */
759     function transferOwnership(address newOwner) public virtual onlyOwner {
760         require(newOwner != address(0), "Ownable: new owner is the zero address");
761         _transferOwnership(newOwner);
762     }
763 
764     /**
765      * @dev Transfers ownership of the contract to a new account (`newOwner`).
766      * Internal function without access restriction.
767      */
768     function _transferOwnership(address newOwner) internal virtual {
769         address oldOwner = _owner;
770         _owner = newOwner;
771         emit OwnershipTransferred(oldOwner, newOwner);
772     }
773 }
774 
775 // File: @openzeppelin/contracts/utils/Address.sol
776 
777 
778 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
779 
780 pragma solidity ^0.8.1;
781 
782 /**
783  * @dev Collection of functions related to the address type
784  */
785 library Address {
786     /**
787      * @dev Returns true if `account` is a contract.
788      *
789      * [IMPORTANT]
790      * ====
791      * It is unsafe to assume that an address for which this function returns
792      * false is an externally-owned account (EOA) and not a contract.
793      *
794      * Among others, `isContract` will return false for the following
795      * types of addresses:
796      *
797      *  - an externally-owned account
798      *  - a contract in construction
799      *  - an address where a contract will be created
800      *  - an address where a contract lived, but was destroyed
801      * ====
802      *
803      * [IMPORTANT]
804      * ====
805      * You shouldn't rely on `isContract` to protect against flash loan attacks!
806      *
807      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
808      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
809      * constructor.
810      * ====
811      */
812     function isContract(address account) internal view returns (bool) {
813         // This method relies on extcodesize/address.code.length, which returns 0
814         // for contracts in construction, since the code is only stored at the end
815         // of the constructor execution.
816 
817         return account.code.length > 0;
818     }
819 
820     /**
821      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
822      * `recipient`, forwarding all available gas and reverting on errors.
823      *
824      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
825      * of certain opcodes, possibly making contracts go over the 2300 gas limit
826      * imposed by `transfer`, making them unable to receive funds via
827      * `transfer`. {sendValue} removes this limitation.
828      *
829      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
830      *
831      * IMPORTANT: because control is transferred to `recipient`, care must be
832      * taken to not create reentrancy vulnerabilities. Consider using
833      * {ReentrancyGuard} or the
834      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
835      */
836     function sendValue(address payable recipient, uint256 amount) internal {
837         require(address(this).balance >= amount, "Address: insufficient balance");
838 
839         (bool success, ) = recipient.call{value: amount}("");
840         require(success, "Address: unable to send value, recipient may have reverted");
841     }
842 
843     /**
844      * @dev Performs a Solidity function call using a low level `call`. A
845      * plain `call` is an unsafe replacement for a function call: use this
846      * function instead.
847      *
848      * If `target` reverts with a revert reason, it is bubbled up by this
849      * function (like regular Solidity function calls).
850      *
851      * Returns the raw returned data. To convert to the expected return value,
852      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
853      *
854      * Requirements:
855      *
856      * - `target` must be a contract.
857      * - calling `target` with `data` must not revert.
858      *
859      * _Available since v3.1._
860      */
861     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
862         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
863     }
864 
865     /**
866      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
867      * `errorMessage` as a fallback revert reason when `target` reverts.
868      *
869      * _Available since v3.1._
870      */
871     function functionCall(
872         address target,
873         bytes memory data,
874         string memory errorMessage
875     ) internal returns (bytes memory) {
876         return functionCallWithValue(target, data, 0, errorMessage);
877     }
878 
879     /**
880      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
881      * but also transferring `value` wei to `target`.
882      *
883      * Requirements:
884      *
885      * - the calling contract must have an ETH balance of at least `value`.
886      * - the called Solidity function must be `payable`.
887      *
888      * _Available since v3.1._
889      */
890     function functionCallWithValue(
891         address target,
892         bytes memory data,
893         uint256 value
894     ) internal returns (bytes memory) {
895         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
896     }
897 
898     /**
899      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
900      * with `errorMessage` as a fallback revert reason when `target` reverts.
901      *
902      * _Available since v3.1._
903      */
904     function functionCallWithValue(
905         address target,
906         bytes memory data,
907         uint256 value,
908         string memory errorMessage
909     ) internal returns (bytes memory) {
910         require(address(this).balance >= value, "Address: insufficient balance for call");
911         (bool success, bytes memory returndata) = target.call{value: value}(data);
912         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
913     }
914 
915     /**
916      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
917      * but performing a static call.
918      *
919      * _Available since v3.3._
920      */
921     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
922         return functionStaticCall(target, data, "Address: low-level static call failed");
923     }
924 
925     /**
926      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
927      * but performing a static call.
928      *
929      * _Available since v3.3._
930      */
931     function functionStaticCall(
932         address target,
933         bytes memory data,
934         string memory errorMessage
935     ) internal view returns (bytes memory) {
936         (bool success, bytes memory returndata) = target.staticcall(data);
937         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
938     }
939 
940     /**
941      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
942      * but performing a delegate call.
943      *
944      * _Available since v3.4._
945      */
946     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
947         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
948     }
949 
950     /**
951      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
952      * but performing a delegate call.
953      *
954      * _Available since v3.4._
955      */
956     function functionDelegateCall(
957         address target,
958         bytes memory data,
959         string memory errorMessage
960     ) internal returns (bytes memory) {
961         (bool success, bytes memory returndata) = target.delegatecall(data);
962         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
963     }
964 
965     /**
966      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
967      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
968      *
969      * _Available since v4.8._
970      */
971     function verifyCallResultFromTarget(
972         address target,
973         bool success,
974         bytes memory returndata,
975         string memory errorMessage
976     ) internal view returns (bytes memory) {
977         if (success) {
978             if (returndata.length == 0) {
979                 // only check isContract if the call was successful and the return data is empty
980                 // otherwise we already know that it was a contract
981                 require(isContract(target), "Address: call to non-contract");
982             }
983             return returndata;
984         } else {
985             _revert(returndata, errorMessage);
986         }
987     }
988 
989     /**
990      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
991      * revert reason or using the provided one.
992      *
993      * _Available since v4.3._
994      */
995     function verifyCallResult(
996         bool success,
997         bytes memory returndata,
998         string memory errorMessage
999     ) internal pure returns (bytes memory) {
1000         if (success) {
1001             return returndata;
1002         } else {
1003             _revert(returndata, errorMessage);
1004         }
1005     }
1006 
1007     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1008         // Look for revert reason and bubble it up if present
1009         if (returndata.length > 0) {
1010             // The easiest way to bubble the revert reason is using memory via assembly
1011             /// @solidity memory-safe-assembly
1012             assembly {
1013                 let returndata_size := mload(returndata)
1014                 revert(add(32, returndata), returndata_size)
1015             }
1016         } else {
1017             revert(errorMessage);
1018         }
1019     }
1020 }
1021 
1022 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1023 
1024 
1025 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1026 
1027 pragma solidity ^0.8.0;
1028 
1029 /**
1030  * @title ERC721 token receiver interface
1031  * @dev Interface for any contract that wants to support safeTransfers
1032  * from ERC721 asset contracts.
1033  */
1034 interface IERC721Receiver {
1035     /**
1036      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1037      * by `operator` from `from`, this function is called.
1038      *
1039      * It must return its Solidity selector to confirm the token transfer.
1040      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1041      *
1042      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1043      */
1044     function onERC721Received(
1045         address operator,
1046         address from,
1047         uint256 tokenId,
1048         bytes calldata data
1049     ) external returns (bytes4);
1050 }
1051 
1052 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1053 
1054 
1055 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1056 
1057 pragma solidity ^0.8.0;
1058 
1059 /**
1060  * @dev Interface of the ERC165 standard, as defined in the
1061  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1062  *
1063  * Implementers can declare support of contract interfaces, which can then be
1064  * queried by others ({ERC165Checker}).
1065  *
1066  * For an implementation, see {ERC165}.
1067  */
1068 interface IERC165 {
1069     /**
1070      * @dev Returns true if this contract implements the interface defined by
1071      * `interfaceId`. See the corresponding
1072      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1073      * to learn more about how these ids are created.
1074      *
1075      * This function call must use less than 30 000 gas.
1076      */
1077     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1078 }
1079 
1080 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1081 
1082 
1083 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1084 
1085 pragma solidity ^0.8.0;
1086 
1087 
1088 /**
1089  * @dev Implementation of the {IERC165} interface.
1090  *
1091  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1092  * for the additional interface id that will be supported. For example:
1093  *
1094  * ```solidity
1095  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1096  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1097  * }
1098  * ```
1099  *
1100  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1101  */
1102 abstract contract ERC165 is IERC165 {
1103     /**
1104      * @dev See {IERC165-supportsInterface}.
1105      */
1106     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1107         return interfaceId == type(IERC165).interfaceId;
1108     }
1109 }
1110 
1111 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1112 
1113 
1114 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 
1119 /**
1120  * @dev Required interface of an ERC721 compliant contract.
1121  */
1122 interface IERC721 is IERC165 {
1123     /**
1124      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1125      */
1126     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1127 
1128     /**
1129      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1130      */
1131     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1132 
1133     /**
1134      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1135      */
1136     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1137 
1138     /**
1139      * @dev Returns the number of tokens in ``owner``'s account.
1140      */
1141     function balanceOf(address owner) external view returns (uint256 balance);
1142 
1143     /**
1144      * @dev Returns the owner of the `tokenId` token.
1145      *
1146      * Requirements:
1147      *
1148      * - `tokenId` must exist.
1149      */
1150     function ownerOf(uint256 tokenId) external view returns (address owner);
1151 
1152     /**
1153      * @dev Safely transfers `tokenId` token from `from` to `to`.
1154      *
1155      * Requirements:
1156      *
1157      * - `from` cannot be the zero address.
1158      * - `to` cannot be the zero address.
1159      * - `tokenId` token must exist and be owned by `from`.
1160      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1161      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1162      *
1163      * Emits a {Transfer} event.
1164      */
1165     function safeTransferFrom(
1166         address from,
1167         address to,
1168         uint256 tokenId,
1169         bytes calldata data
1170     ) external;
1171 
1172     /**
1173      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1174      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1175      *
1176      * Requirements:
1177      *
1178      * - `from` cannot be the zero address.
1179      * - `to` cannot be the zero address.
1180      * - `tokenId` token must exist and be owned by `from`.
1181      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1182      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1183      *
1184      * Emits a {Transfer} event.
1185      */
1186     function safeTransferFrom(
1187         address from,
1188         address to,
1189         uint256 tokenId
1190     ) external;
1191 
1192     /**
1193      * @dev Transfers `tokenId` token from `from` to `to`.
1194      *
1195      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1196      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1197      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1198      *
1199      * Requirements:
1200      *
1201      * - `from` cannot be the zero address.
1202      * - `to` cannot be the zero address.
1203      * - `tokenId` token must be owned by `from`.
1204      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1205      *
1206      * Emits a {Transfer} event.
1207      */
1208     function transferFrom(
1209         address from,
1210         address to,
1211         uint256 tokenId
1212     ) external;
1213 
1214     /**
1215      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1216      * The approval is cleared when the token is transferred.
1217      *
1218      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1219      *
1220      * Requirements:
1221      *
1222      * - The caller must own the token or be an approved operator.
1223      * - `tokenId` must exist.
1224      *
1225      * Emits an {Approval} event.
1226      */
1227     function approve(address to, uint256 tokenId) external;
1228 
1229     /**
1230      * @dev Approve or remove `operator` as an operator for the caller.
1231      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1232      *
1233      * Requirements:
1234      *
1235      * - The `operator` cannot be the caller.
1236      *
1237      * Emits an {ApprovalForAll} event.
1238      */
1239     function setApprovalForAll(address operator, bool _approved) external;
1240 
1241     /**
1242      * @dev Returns the account approved for `tokenId` token.
1243      *
1244      * Requirements:
1245      *
1246      * - `tokenId` must exist.
1247      */
1248     function getApproved(uint256 tokenId) external view returns (address operator);
1249 
1250     /**
1251      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1252      *
1253      * See {setApprovalForAll}
1254      */
1255     function isApprovedForAll(address owner, address operator) external view returns (bool);
1256 }
1257 
1258 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1259 
1260 
1261 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1262 
1263 pragma solidity ^0.8.0;
1264 
1265 
1266 /**
1267  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1268  * @dev See https://eips.ethereum.org/EIPS/eip-721
1269  */
1270 interface IERC721Metadata is IERC721 {
1271     /**
1272      * @dev Returns the token collection name.
1273      */
1274     function name() external view returns (string memory);
1275 
1276     /**
1277      * @dev Returns the token collection symbol.
1278      */
1279     function symbol() external view returns (string memory);
1280 
1281     /**
1282      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1283      */
1284     function tokenURI(uint256 tokenId) external view returns (string memory);
1285 }
1286 
1287 
1288 pragma solidity ^0.8.4;
1289 
1290 
1291 
1292 
1293 
1294 
1295 
1296 
1297 error ApprovalCallerNotOwnerNorApproved();
1298 error ApprovalQueryForNonexistentToken();
1299 error ApproveToCaller();
1300 error ApprovalToCurrentOwner();
1301 error BalanceQueryForZeroAddress();
1302 error MintToZeroAddress();
1303 error MintZeroQuantity();
1304 error OwnerQueryForNonexistentToken();
1305 error TransferCallerNotOwnerNorApproved();
1306 error TransferFromIncorrectOwner();
1307 error TransferToNonERC721ReceiverImplementer();
1308 error TransferToZeroAddress();
1309 error URIQueryForNonexistentToken();
1310 
1311 /**
1312  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1313  * the Metadata extension. Built to optimize for lower gas during batch mints.
1314  *
1315  * Assumes serials are sequentially minted starting at _startTokenId() (defaults to 0, e.g. 0, 1, 2, 3..).
1316  *
1317  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1318  *
1319  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
1320  */
1321 contract ERC721A is Context, ERC165, IERC721, IERC721Metadata {
1322     using Address for address;
1323     using Strings for uint256;
1324 
1325     // Compiler will pack this into a single 256bit word.
1326     struct TokenOwnership {
1327         // The address of the owner.
1328         address addr;
1329         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
1330         uint64 startTimestamp;
1331         // Whether the token has been burned.
1332         bool burned;
1333     }
1334 
1335     // Compiler will pack this into a single 256bit word.
1336     struct AddressData {
1337         // Realistically, 2**64-1 is more than enough.
1338         uint64 balance;
1339         // Keeps track of mint count with minimal overhead for tokenomics.
1340         uint64 numberMinted;
1341         // Keeps track of burn count with minimal overhead for tokenomics.
1342         uint64 numberBurned;
1343         // For miscellaneous variable(s) pertaining to the address
1344         // (e.g. number of whitelist mint slots used).
1345         // If there are multiple variables, please pack them into a uint64.
1346         uint64 aux;
1347     }
1348 
1349     // The tokenId of the next token to be minted.
1350     uint256 internal _currentIndex;
1351 
1352     // The number of tokens burned.
1353     uint256 internal _burnCounter;
1354 
1355     // Token name
1356     string internal _name;
1357 
1358     // Token symbol
1359     string internal _symbol;
1360 
1361     // Mapping from token ID to ownership details
1362     // An empty struct value does not necessarily mean the token is unowned. See _ownershipOf implementation for details.
1363     mapping(uint256 => TokenOwnership) internal _ownerships;
1364 
1365     // Mapping owner address to address data
1366     mapping(address => AddressData) internal _addressData;
1367 
1368     // Mapping from token ID to approved address
1369     mapping(uint256 => address) internal _tokenApprovals;
1370 
1371     // Mapping from owner to operator approvals
1372     mapping(address => mapping(address => bool)) internal _operatorApprovals;
1373 
1374     constructor(string memory name_, string memory symbol_) {
1375         _name = name_;
1376         _symbol = symbol_;
1377         _currentIndex = _startTokenId();
1378     }
1379 
1380     /**
1381      * To change the starting tokenId, please override this function.
1382      */
1383     function _startTokenId() internal view virtual returns (uint256) {
1384         return 0;
1385     }
1386 
1387     /**
1388      * @dev Burned tokens are calculated here, use _totalMinted() if you want to count just minted tokens.
1389      */
1390     function totalSupply() public view returns (uint256) {
1391         // Counter underflow is impossible as _burnCounter cannot be incremented
1392         // more than _currentIndex - _startTokenId() times
1393         unchecked {
1394             return _currentIndex - _burnCounter - _startTokenId();
1395         }
1396     }
1397 
1398     /**
1399      * Returns the total amount of tokens minted in the contract.
1400      */
1401     function _totalMinted() internal view returns (uint256) {
1402         // Counter underflow is impossible as _currentIndex does not decrement,
1403         // and it is initialized to _startTokenId()
1404         unchecked {
1405             return _currentIndex - _startTokenId();
1406         }
1407     }
1408 
1409     /**
1410      * @dev See {IERC165-supportsInterface}.
1411      */
1412     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1413         return
1414             interfaceId == type(IERC721).interfaceId ||
1415             interfaceId == type(IERC721Metadata).interfaceId ||
1416             super.supportsInterface(interfaceId);
1417     }
1418 
1419     /**
1420      * @dev See {IERC721-balanceOf}.
1421      */
1422     function balanceOf(address owner) public view override returns (uint256) {
1423         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1424         return uint256(_addressData[owner].balance);
1425     }
1426 
1427     /**
1428      * Returns the number of tokens minted by `owner`.
1429      */
1430     function _numberMinted(address owner) internal view returns (uint256) {
1431         return uint256(_addressData[owner].numberMinted);
1432     }
1433 
1434     /**
1435      * Returns the number of tokens burned by or on behalf of `owner`.
1436      */
1437     function _numberBurned(address owner) internal view returns (uint256) {
1438         return uint256(_addressData[owner].numberBurned);
1439     }
1440 
1441     /**
1442      * Returns the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1443      */
1444     function _getAux(address owner) internal view returns (uint64) {
1445         return _addressData[owner].aux;
1446     }
1447 
1448     /**
1449      * Sets the auxillary data for `owner`. (e.g. number of whitelist mint slots used).
1450      * If there are multiple variables, please pack them into a uint64.
1451      */
1452     function _setAux(address owner, uint64 aux) internal {
1453         _addressData[owner].aux = aux;
1454     }
1455 
1456     /**
1457      * Gas spent here starts off proportional to the maximum mint batch size.
1458      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
1459      */
1460     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
1461         uint256 curr = tokenId;
1462 
1463         unchecked {
1464             if (_startTokenId() <= curr && curr < _currentIndex) {
1465                 TokenOwnership memory ownership = _ownerships[curr];
1466                 if (!ownership.burned) {
1467                     if (ownership.addr != address(0)) {
1468                         return ownership;
1469                     }
1470                     // Invariant:
1471                     // There will always be an ownership that has an address and is not burned
1472                     // before an ownership that does not have an address and is not burned.
1473                     // Hence, curr will not underflow.
1474                     while (true) {
1475                         curr--;
1476                         ownership = _ownerships[curr];
1477                         if (ownership.addr != address(0)) {
1478                             return ownership;
1479                         }
1480                     }
1481                 }
1482             }
1483         }
1484         revert OwnerQueryForNonexistentToken();
1485     }
1486 
1487     /**
1488      * @dev See {IERC721-ownerOf}.
1489      */
1490     function ownerOf(uint256 tokenId) public view override returns (address) {
1491         return _ownershipOf(tokenId).addr;
1492     }
1493 
1494     /**
1495      * @dev See {IERC721Metadata-name}.
1496      */
1497     function name() public view virtual override returns (string memory) {
1498         return _name;
1499     }
1500 
1501     /**
1502      * @dev See {IERC721Metadata-symbol}.
1503      */
1504     function symbol() public view virtual override returns (string memory) {
1505         return _symbol;
1506     }
1507 
1508     /**
1509      * @dev See {IERC721Metadata-tokenURI}.
1510      */
1511     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1512         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1513 
1514         string memory baseURI = _baseURI();
1515         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : '';
1516     }
1517 
1518     /**
1519      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1520      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1521      * by default, can be overriden in child contracts.
1522      */
1523     function _baseURI() internal view virtual returns (string memory) {
1524         return '';
1525     }
1526 
1527     /**
1528      * @dev See {IERC721-approve}.
1529      */
1530     function approve(address to, uint256 tokenId) public override {
1531         address owner = ERC721A.ownerOf(tokenId);
1532         if (to == owner) revert ApprovalToCurrentOwner();
1533 
1534         if (_msgSender() != owner && !isApprovedForAll(owner, _msgSender())) {
1535             revert ApprovalCallerNotOwnerNorApproved();
1536         }
1537 
1538         _approve(to, tokenId, owner);
1539     }
1540 
1541     /**
1542      * @dev See {IERC721-getApproved}.
1543      */
1544     function getApproved(uint256 tokenId) public view override returns (address) {
1545         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1546 
1547         return _tokenApprovals[tokenId];
1548     }
1549 
1550     /**
1551      * @dev See {IERC721-setApprovalForAll}.
1552      */
1553     function setApprovalForAll(address operator, bool approved) public virtual override {
1554         if (operator == _msgSender()) revert ApproveToCaller();
1555 
1556         _operatorApprovals[_msgSender()][operator] = approved;
1557         emit ApprovalForAll(_msgSender(), operator, approved);
1558     }
1559 
1560     /**
1561      * @dev See {IERC721-isApprovedForAll}.
1562      */
1563     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1564         return _operatorApprovals[owner][operator];
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-transferFrom}.
1569      */
1570     function transferFrom(
1571         address from,
1572         address to,
1573         uint256 tokenId
1574     ) public virtual override {
1575         _transfer(from, to, tokenId);
1576     }
1577 
1578     /**
1579      * @dev See {IERC721-safeTransferFrom}.
1580      */
1581     function safeTransferFrom(
1582         address from,
1583         address to,
1584         uint256 tokenId
1585     ) public virtual override {
1586         safeTransferFrom(from, to, tokenId, '');
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-safeTransferFrom}.
1591      */
1592     function safeTransferFrom(
1593         address from,
1594         address to,
1595         uint256 tokenId,
1596         bytes memory _data
1597     ) public virtual override {
1598         _transfer(from, to, tokenId);
1599         if (to.isContract() && !_checkContractOnERC721Received(from, to, tokenId, _data)) {
1600             revert TransferToNonERC721ReceiverImplementer();
1601         }
1602     }
1603 
1604     /**
1605      * @dev Returns whether `tokenId` exists.
1606      *
1607      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1608      *
1609      * Tokens start existing when they are minted (`_mint`),
1610      */
1611     function _exists(uint256 tokenId) internal view returns (bool) {
1612         return _startTokenId() <= tokenId && tokenId < _currentIndex &&
1613             !_ownerships[tokenId].burned;
1614     }
1615 
1616     function _safeMint(address to, uint256 quantity) internal {
1617         _safeMint(to, quantity, '');
1618     }
1619 
1620     /**
1621      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1622      *
1623      * Requirements:
1624      *
1625      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1626      * - `quantity` must be greater than 0.
1627      *
1628      * Emits a {Transfer} event.
1629      */
1630     function _safeMint(
1631         address to,
1632         uint256 quantity,
1633         bytes memory _data
1634     ) internal {
1635         _mint(to, quantity, _data, true);
1636     }
1637 
1638     /**
1639      * @dev Mints `quantity` tokens and transfers them to `to`.
1640      *
1641      * Requirements:
1642      *
1643      * - `to` cannot be the zero address.
1644      * - `quantity` must be greater than 0.
1645      *
1646      * Emits a {Transfer} event.
1647      */
1648     function _mint(
1649         address to,
1650         uint256 quantity,
1651         bytes memory _data,
1652         bool safe
1653     ) internal {
1654         uint256 startTokenId = _currentIndex;
1655         if (to == address(0)) revert MintToZeroAddress();
1656         if (quantity == 0) revert MintZeroQuantity();
1657 
1658         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1659 
1660         // Overflows are incredibly unrealistic.
1661         // balance or numberMinted overflow if current value of either + quantity > 1.8e19 (2**64) - 1
1662         // updatedIndex overflows if _currentIndex + quantity > 1.2e77 (2**256) - 1
1663         unchecked {
1664             _addressData[to].balance += uint64(quantity);
1665             _addressData[to].numberMinted += uint64(quantity);
1666 
1667             _ownerships[startTokenId].addr = to;
1668             _ownerships[startTokenId].startTimestamp = uint64(block.timestamp);
1669 
1670             uint256 updatedIndex = startTokenId;
1671             uint256 end = updatedIndex + quantity;
1672 
1673             if (safe && to.isContract()) {
1674                 do {
1675                     emit Transfer(address(0), to, updatedIndex);
1676                     if (!_checkContractOnERC721Received(address(0), to, updatedIndex++, _data)) {
1677                         revert TransferToNonERC721ReceiverImplementer();
1678                     }
1679                 } while (updatedIndex != end);
1680                 // Reentrancy protection
1681                 if (_currentIndex != startTokenId) revert();
1682             } else {
1683                 do {
1684                     emit Transfer(address(0), to, updatedIndex++);
1685                 } while (updatedIndex != end);
1686             }
1687             _currentIndex = updatedIndex;
1688         }
1689         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1690     }
1691 
1692     /**
1693      * @dev Transfers `tokenId` from `from` to `to`.
1694      *
1695      * Requirements:
1696      *
1697      * - `to` cannot be the zero address.
1698      * - `tokenId` token must be owned by `from`.
1699      *
1700      * Emits a {Transfer} event.
1701      */
1702     function _transfer(
1703         address from,
1704         address to,
1705         uint256 tokenId
1706     ) internal {
1707         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1708 
1709         if (prevOwnership.addr != from) revert TransferFromIncorrectOwner();
1710 
1711         bool isApprovedOrOwner = (_msgSender() == from ||
1712             isApprovedForAll(from, _msgSender()) ||
1713             getApproved(tokenId) == _msgSender());
1714 
1715         if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1716         if (to == address(0)) revert TransferToZeroAddress();
1717 
1718         _beforeTokenTransfers(from, to, tokenId, 1);
1719 
1720         // Clear approvals from the previous owner
1721         _approve(address(0), tokenId, from);
1722 
1723         // Underflow of the sender's balance is impossible because we check for
1724         // ownership above and the recipient's balance can't realistically overflow.
1725         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1726         unchecked {
1727             _addressData[from].balance -= 1;
1728             _addressData[to].balance += 1;
1729 
1730             TokenOwnership storage currSlot = _ownerships[tokenId];
1731             currSlot.addr = to;
1732             currSlot.startTimestamp = uint64(block.timestamp);
1733 
1734             // If the ownership slot of tokenId+1 is not explicitly set, that means the transfer initiator owns it.
1735             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1736             uint256 nextTokenId = tokenId + 1;
1737             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1738             if (nextSlot.addr == address(0)) {
1739                 // This will suffice for checking _exists(nextTokenId),
1740                 // as a burned slot cannot contain the zero address.
1741                 if (nextTokenId != _currentIndex) {
1742                     nextSlot.addr = from;
1743                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1744                 }
1745             }
1746         }
1747 
1748         emit Transfer(from, to, tokenId);
1749         _afterTokenTransfers(from, to, tokenId, 1);
1750     }
1751 
1752     /**
1753      * @dev This is equivalent to _burn(tokenId, false)
1754      */
1755     function _burn(uint256 tokenId) internal virtual {
1756         _burn(tokenId, false);
1757     }
1758 
1759     /**
1760      * @dev Destroys `tokenId`.
1761      * The approval is cleared when the token is burned.
1762      *
1763      * Requirements:
1764      *
1765      * - `tokenId` must exist.
1766      *
1767      * Emits a {Transfer} event.
1768      */
1769     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1770         TokenOwnership memory prevOwnership = _ownershipOf(tokenId);
1771 
1772         address from = prevOwnership.addr;
1773 
1774         if (approvalCheck) {
1775             bool isApprovedOrOwner = (_msgSender() == from ||
1776                 isApprovedForAll(from, _msgSender()) ||
1777                 getApproved(tokenId) == _msgSender());
1778 
1779             if (!isApprovedOrOwner) revert TransferCallerNotOwnerNorApproved();
1780         }
1781 
1782         _beforeTokenTransfers(from, address(0), tokenId, 1);
1783 
1784         // Clear approvals from the previous owner
1785         _approve(address(0), tokenId, from);
1786 
1787         // Underflow of the sender's balance is impossible because we check for
1788         // ownership above and the recipient's balance can't realistically overflow.
1789         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1790         unchecked {
1791             AddressData storage addressData = _addressData[from];
1792             addressData.balance -= 1;
1793             addressData.numberBurned += 1;
1794 
1795             // Keep track of who burned the token, and the timestamp of burning.
1796             TokenOwnership storage currSlot = _ownerships[tokenId];
1797             currSlot.addr = from;
1798             currSlot.startTimestamp = uint64(block.timestamp);
1799             currSlot.burned = true;
1800 
1801             // If the ownership slot of tokenId+1 is not explicitly set, that means the burn initiator owns it.
1802             // Set the slot of tokenId+1 explicitly in storage to maintain correctness for ownerOf(tokenId+1) calls.
1803             uint256 nextTokenId = tokenId + 1;
1804             TokenOwnership storage nextSlot = _ownerships[nextTokenId];
1805             if (nextSlot.addr == address(0)) {
1806                 // This will suffice for checking _exists(nextTokenId),
1807                 // as a burned slot cannot contain the zero address.
1808                 if (nextTokenId != _currentIndex) {
1809                     nextSlot.addr = from;
1810                     nextSlot.startTimestamp = prevOwnership.startTimestamp;
1811                 }
1812             }
1813         }
1814 
1815         emit Transfer(from, address(0), tokenId);
1816         _afterTokenTransfers(from, address(0), tokenId, 1);
1817 
1818         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1819         unchecked {
1820             _burnCounter++;
1821         }
1822     }
1823 
1824     /**
1825      * @dev Approve `to` to operate on `tokenId`
1826      *
1827      * Emits a {Approval} event.
1828      */
1829     function _approve(
1830         address to,
1831         uint256 tokenId,
1832         address owner
1833     ) internal {
1834         _tokenApprovals[tokenId] = to;
1835         emit Approval(owner, to, tokenId);
1836     }
1837 
1838     /**
1839      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1840      *
1841      * @param from address representing the previous owner of the given token ID
1842      * @param to target address that will receive the tokens
1843      * @param tokenId uint256 ID of the token to be transferred
1844      * @param _data bytes optional data to send along with the call
1845      * @return bool whether the call correctly returned the expected magic value
1846      */
1847     function _checkContractOnERC721Received(
1848         address from,
1849         address to,
1850         uint256 tokenId,
1851         bytes memory _data
1852     ) internal returns (bool) {
1853         try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1854             return retval == IERC721Receiver(to).onERC721Received.selector;
1855         } catch (bytes memory reason) {
1856             if (reason.length == 0) {
1857                 revert TransferToNonERC721ReceiverImplementer();
1858             } else {
1859                 assembly {
1860                     revert(add(32, reason), mload(reason))
1861                 }
1862             }
1863         }
1864     }
1865 
1866     /**
1867      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred. This includes minting.
1868      * And also called before burning one token.
1869      *
1870      * startTokenId - the first token id to be transferred
1871      * quantity - the amount to be transferred
1872      *
1873      * Calling conditions:
1874      *
1875      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1876      * transferred to `to`.
1877      * - When `from` is zero, `tokenId` will be minted for `to`.
1878      * - When `to` is zero, `tokenId` will be burned by `from`.
1879      * - `from` and `to` are never both zero.
1880      */
1881     function _beforeTokenTransfers(
1882         address from,
1883         address to,
1884         uint256 startTokenId,
1885         uint256 quantity
1886     ) internal virtual {}
1887 
1888     /**
1889      * @dev Hook that is called after a set of serially-ordered token ids have been transferred. This includes
1890      * minting.
1891      * And also called after one token has been burned.
1892      *
1893      * startTokenId - the first token id to be transferred
1894      * quantity - the amount to be transferred
1895      *
1896      * Calling conditions:
1897      *
1898      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1899      * transferred to `to`.
1900      * - When `from` is zero, `tokenId` has been minted for `to`.
1901      * - When `to` is zero, `tokenId` has been burned by `from`.
1902      * - `from` and `to` are never both zero.
1903      */
1904     function _afterTokenTransfers(
1905         address from,
1906         address to,
1907         uint256 startTokenId,
1908         uint256 quantity
1909     ) internal virtual {}
1910 }
1911 
1912 // File: ArcanaERC721A.sol
1913 
1914 
1915 pragma solidity ^0.8.9;
1916 
1917 
1918 
1919 
1920 
1921 contract ArcanaFlightPass is ERC721A, Ownable {
1922     using Counters for Counters.Counter;
1923     using ECDSA for bytes32;
1924     
1925     uint256 public constant mintPrice = 0.03 ether;
1926     uint256 public constant PublicmintPrice = 0.036 ether;
1927     uint256 public constant maxMintPerUser = 2;
1928     uint256 public constant maxMintSupply = 5555;
1929 
1930     
1931 
1932     address public refundAddress;
1933     bool public publicMintOpen = false;
1934     bool public allowListMintOpen = false;
1935     bool public allowburntoken = false;
1936 
1937     mapping(address => bool) public allowList;
1938 
1939    
1940     Counters.Counter private _tokenIdCounter;
1941     address private _signerAddress;
1942 
1943     constructor(address signerAddress_) ERC721A("Arcana - FlightPass", "Arcana") {
1944         _signerAddress = signerAddress_;
1945     }
1946 
1947     function _baseURI() internal pure override returns (string memory) {
1948         return "ipfs://QmWBwhwh8LMuhF1JmuhuxkpmRejsCXWN98S2BXPFAc6Nmz/";
1949     }
1950 
1951  
1952     function editMintWindows(
1953         bool _publicMintOpen,
1954         bool _allowListMintOpen
1955     ) external onlyOwner {
1956         publicMintOpen = _publicMintOpen;
1957         allowListMintOpen = _allowListMintOpen;
1958     }
1959 
1960     function safeMint(uint256 quantity, bytes calldata signature) public payable {
1961         require(allowListMintOpen, "Allowlist Mint Closed");
1962         require(msg.value >= quantity * mintPrice, "Not enough funds");
1963         require(_numberMinted(msg.sender) + quantity <= maxMintPerUser, "You reached your Mint limit");
1964         require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");
1965         require(_signerAddress == keccak256(
1966             abi.encodePacked(
1967                 "\x19Ethereum Signed Message:\n32",
1968                 bytes32(uint256(uint160(msg.sender)))
1969             )
1970         ).recover(signature), "You are not on the allow list.");
1971 
1972         _safeMint(msg.sender, quantity);
1973       
1974         for(uint256 i = _currentIndex - quantity; i < _currentIndex; i++){
1975          
1976         }
1977     }
1978 
1979 
1980     function publicMint(uint256 quantity) public payable {
1981         require(publicMintOpen, "Public Mint Closed");
1982         require(msg.value >= quantity * PublicmintPrice, "Not enough funds");
1983         require(_numberMinted(msg.sender) + quantity <= (maxMintPerUser + 3) , "You reached your Mint limit");
1984         require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");
1985 
1986         _safeMint(msg.sender, quantity);
1987       
1988         for(uint256 i = _currentIndex - quantity; i < _currentIndex; i++){
1989        
1990         }
1991     }
1992 
1993     function adminMint(uint256 quantity) external onlyOwner {
1994         
1995         require(_totalMinted() + quantity <= maxMintSupply, "SOLD OUT");
1996 
1997         _safeMint(msg.sender, quantity);
1998       
1999         for(uint256 i = _currentIndex - quantity; i < _currentIndex; i++){
2000        
2001         }
2002     }
2003     
2004  // Populate the Allow List
2005     function setAllowList(address[] calldata addresses) external onlyOwner {
2006         for(uint256 i = 0; i < addresses.length; i++){
2007             allowList[addresses[i]] = true;
2008         }
2009     }
2010 
2011     function removeFromAllowList(address[] calldata addresses)
2012     external onlyOwner
2013     {
2014         for (uint256 i = 0; i < addresses.length; i++) {
2015              allowList[addresses[i]]= false;
2016         }
2017     }
2018 
2019     function Burn(uint256 tokenId) external onlyOwner {
2020        super._burn(tokenId, false);
2021     }
2022     
2023     
2024     function withdraw() external onlyOwner {
2025       
2026         uint256 balance = address(this).balance;
2027         Address.sendValue(payable(msg.sender), balance);
2028     }
2029 
2030     function testBytesReturn() external view returns (bytes32) {
2031         return bytes32(uint256(uint160(msg.sender)));
2032     }
2033 
2034     function testSignerRecovery(bytes calldata signature) external view returns (address) {
2035         return keccak256(
2036             abi.encodePacked(
2037                 "\x19Ethereum Signed Message:\n32",
2038                 bytes32(uint256(uint160(msg.sender)))
2039             )
2040         ).recover(signature);
2041     }
2042 }