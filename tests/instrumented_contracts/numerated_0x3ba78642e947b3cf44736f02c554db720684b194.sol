1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Throws if called by any account other than the owner.
62      */
63     modifier onlyOwner() {
64         _checkOwner();
65         _;
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if the sender is not the owner.
77      */
78     function _checkOwner() internal view virtual {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/math/Math.sol
114 
115 
116 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 /**
121  * @dev Standard math utilities missing in the Solidity language.
122  */
123 library Math {
124     enum Rounding {
125         Down, // Toward negative infinity
126         Up, // Toward infinity
127         Zero // Toward zero
128     }
129 
130     /**
131      * @dev Returns the largest of two numbers.
132      */
133     function max(uint256 a, uint256 b) internal pure returns (uint256) {
134         return a > b ? a : b;
135     }
136 
137     /**
138      * @dev Returns the smallest of two numbers.
139      */
140     function min(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a < b ? a : b;
142     }
143 
144     /**
145      * @dev Returns the average of two numbers. The result is rounded towards
146      * zero.
147      */
148     function average(uint256 a, uint256 b) internal pure returns (uint256) {
149         // (a + b) / 2 can overflow.
150         return (a & b) + (a ^ b) / 2;
151     }
152 
153     /**
154      * @dev Returns the ceiling of the division of two numbers.
155      *
156      * This differs from standard division with `/` in that it rounds up instead
157      * of rounding down.
158      */
159     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
160         // (a + b - 1) / b can overflow on addition, so we distribute.
161         return a == 0 ? 0 : (a - 1) / b + 1;
162     }
163 
164     /**
165      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
166      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
167      * with further edits by Uniswap Labs also under MIT license.
168      */
169     function mulDiv(
170         uint256 x,
171         uint256 y,
172         uint256 denominator
173     ) internal pure returns (uint256 result) {
174         unchecked {
175             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
176             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
177             // variables such that product = prod1 * 2^256 + prod0.
178             uint256 prod0; // Least significant 256 bits of the product
179             uint256 prod1; // Most significant 256 bits of the product
180             assembly {
181                 let mm := mulmod(x, y, not(0))
182                 prod0 := mul(x, y)
183                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
184             }
185 
186             // Handle non-overflow cases, 256 by 256 division.
187             if (prod1 == 0) {
188                 return prod0 / denominator;
189             }
190 
191             // Make sure the result is less than 2^256. Also prevents denominator == 0.
192             require(denominator > prod1);
193 
194             ///////////////////////////////////////////////
195             // 512 by 256 division.
196             ///////////////////////////////////////////////
197 
198             // Make division exact by subtracting the remainder from [prod1 prod0].
199             uint256 remainder;
200             assembly {
201                 // Compute remainder using mulmod.
202                 remainder := mulmod(x, y, denominator)
203 
204                 // Subtract 256 bit number from 512 bit number.
205                 prod1 := sub(prod1, gt(remainder, prod0))
206                 prod0 := sub(prod0, remainder)
207             }
208 
209             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
210             // See https://cs.stackexchange.com/q/138556/92363.
211 
212             // Does not overflow because the denominator cannot be zero at this stage in the function.
213             uint256 twos = denominator & (~denominator + 1);
214             assembly {
215                 // Divide denominator by twos.
216                 denominator := div(denominator, twos)
217 
218                 // Divide [prod1 prod0] by twos.
219                 prod0 := div(prod0, twos)
220 
221                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
222                 twos := add(div(sub(0, twos), twos), 1)
223             }
224 
225             // Shift in bits from prod1 into prod0.
226             prod0 |= prod1 * twos;
227 
228             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
229             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
230             // four bits. That is, denominator * inv = 1 mod 2^4.
231             uint256 inverse = (3 * denominator) ^ 2;
232 
233             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
234             // in modular arithmetic, doubling the correct bits in each step.
235             inverse *= 2 - denominator * inverse; // inverse mod 2^8
236             inverse *= 2 - denominator * inverse; // inverse mod 2^16
237             inverse *= 2 - denominator * inverse; // inverse mod 2^32
238             inverse *= 2 - denominator * inverse; // inverse mod 2^64
239             inverse *= 2 - denominator * inverse; // inverse mod 2^128
240             inverse *= 2 - denominator * inverse; // inverse mod 2^256
241 
242             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
243             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
244             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
245             // is no longer required.
246             result = prod0 * inverse;
247             return result;
248         }
249     }
250 
251     /**
252      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
253      */
254     function mulDiv(
255         uint256 x,
256         uint256 y,
257         uint256 denominator,
258         Rounding rounding
259     ) internal pure returns (uint256) {
260         uint256 result = mulDiv(x, y, denominator);
261         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
262             result += 1;
263         }
264         return result;
265     }
266 
267     /**
268      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
269      *
270      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
271      */
272     function sqrt(uint256 a) internal pure returns (uint256) {
273         if (a == 0) {
274             return 0;
275         }
276 
277         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
278         //
279         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
280         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
281         //
282         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
283         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
284         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
285         //
286         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
287         uint256 result = 1 << (log2(a) >> 1);
288 
289         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
290         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
291         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
292         // into the expected uint128 result.
293         unchecked {
294             result = (result + a / result) >> 1;
295             result = (result + a / result) >> 1;
296             result = (result + a / result) >> 1;
297             result = (result + a / result) >> 1;
298             result = (result + a / result) >> 1;
299             result = (result + a / result) >> 1;
300             result = (result + a / result) >> 1;
301             return min(result, a / result);
302         }
303     }
304 
305     /**
306      * @notice Calculates sqrt(a), following the selected rounding direction.
307      */
308     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
309         unchecked {
310             uint256 result = sqrt(a);
311             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
312         }
313     }
314 
315     /**
316      * @dev Return the log in base 2, rounded down, of a positive value.
317      * Returns 0 if given 0.
318      */
319     function log2(uint256 value) internal pure returns (uint256) {
320         uint256 result = 0;
321         unchecked {
322             if (value >> 128 > 0) {
323                 value >>= 128;
324                 result += 128;
325             }
326             if (value >> 64 > 0) {
327                 value >>= 64;
328                 result += 64;
329             }
330             if (value >> 32 > 0) {
331                 value >>= 32;
332                 result += 32;
333             }
334             if (value >> 16 > 0) {
335                 value >>= 16;
336                 result += 16;
337             }
338             if (value >> 8 > 0) {
339                 value >>= 8;
340                 result += 8;
341             }
342             if (value >> 4 > 0) {
343                 value >>= 4;
344                 result += 4;
345             }
346             if (value >> 2 > 0) {
347                 value >>= 2;
348                 result += 2;
349             }
350             if (value >> 1 > 0) {
351                 result += 1;
352             }
353         }
354         return result;
355     }
356 
357     /**
358      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
359      * Returns 0 if given 0.
360      */
361     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
362         unchecked {
363             uint256 result = log2(value);
364             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
365         }
366     }
367 
368     /**
369      * @dev Return the log in base 10, rounded down, of a positive value.
370      * Returns 0 if given 0.
371      */
372     function log10(uint256 value) internal pure returns (uint256) {
373         uint256 result = 0;
374         unchecked {
375             if (value >= 10**64) {
376                 value /= 10**64;
377                 result += 64;
378             }
379             if (value >= 10**32) {
380                 value /= 10**32;
381                 result += 32;
382             }
383             if (value >= 10**16) {
384                 value /= 10**16;
385                 result += 16;
386             }
387             if (value >= 10**8) {
388                 value /= 10**8;
389                 result += 8;
390             }
391             if (value >= 10**4) {
392                 value /= 10**4;
393                 result += 4;
394             }
395             if (value >= 10**2) {
396                 value /= 10**2;
397                 result += 2;
398             }
399             if (value >= 10**1) {
400                 result += 1;
401             }
402         }
403         return result;
404     }
405 
406     /**
407      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
408      * Returns 0 if given 0.
409      */
410     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
411         unchecked {
412             uint256 result = log10(value);
413             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
414         }
415     }
416 
417     /**
418      * @dev Return the log in base 256, rounded down, of a positive value.
419      * Returns 0 if given 0.
420      *
421      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
422      */
423     function log256(uint256 value) internal pure returns (uint256) {
424         uint256 result = 0;
425         unchecked {
426             if (value >> 128 > 0) {
427                 value >>= 128;
428                 result += 16;
429             }
430             if (value >> 64 > 0) {
431                 value >>= 64;
432                 result += 8;
433             }
434             if (value >> 32 > 0) {
435                 value >>= 32;
436                 result += 4;
437             }
438             if (value >> 16 > 0) {
439                 value >>= 16;
440                 result += 2;
441             }
442             if (value >> 8 > 0) {
443                 result += 1;
444             }
445         }
446         return result;
447     }
448 
449     /**
450      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
451      * Returns 0 if given 0.
452      */
453     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
454         unchecked {
455             uint256 result = log256(value);
456             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
457         }
458     }
459 }
460 
461 // File: @openzeppelin/contracts/utils/Strings.sol
462 
463 
464 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
465 
466 pragma solidity ^0.8.0;
467 
468 
469 /**
470  * @dev String operations.
471  */
472 library Strings {
473     bytes16 private constant _SYMBOLS = "0123456789abcdef";
474     uint8 private constant _ADDRESS_LENGTH = 20;
475 
476     /**
477      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
478      */
479     function toString(uint256 value) internal pure returns (string memory) {
480         unchecked {
481             uint256 length = Math.log10(value) + 1;
482             string memory buffer = new string(length);
483             uint256 ptr;
484             /// @solidity memory-safe-assembly
485             assembly {
486                 ptr := add(buffer, add(32, length))
487             }
488             while (true) {
489                 ptr--;
490                 /// @solidity memory-safe-assembly
491                 assembly {
492                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
493                 }
494                 value /= 10;
495                 if (value == 0) break;
496             }
497             return buffer;
498         }
499     }
500 
501     /**
502      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
503      */
504     function toHexString(uint256 value) internal pure returns (string memory) {
505         unchecked {
506             return toHexString(value, Math.log256(value) + 1);
507         }
508     }
509 
510     /**
511      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
512      */
513     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
514         bytes memory buffer = new bytes(2 * length + 2);
515         buffer[0] = "0";
516         buffer[1] = "x";
517         for (uint256 i = 2 * length + 1; i > 1; --i) {
518             buffer[i] = _SYMBOLS[value & 0xf];
519             value >>= 4;
520         }
521         require(value == 0, "Strings: hex length insufficient");
522         return string(buffer);
523     }
524 
525     /**
526      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
527      */
528     function toHexString(address addr) internal pure returns (string memory) {
529         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
530     }
531 }
532 
533 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
534 
535 
536 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
537 
538 pragma solidity ^0.8.0;
539 
540 
541 /**
542  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
543  *
544  * These functions can be used to verify that a message was signed by the holder
545  * of the private keys of a given address.
546  */
547 library ECDSA {
548     enum RecoverError {
549         NoError,
550         InvalidSignature,
551         InvalidSignatureLength,
552         InvalidSignatureS,
553         InvalidSignatureV // Deprecated in v4.8
554     }
555 
556     function _throwError(RecoverError error) private pure {
557         if (error == RecoverError.NoError) {
558             return; // no error: do nothing
559         } else if (error == RecoverError.InvalidSignature) {
560             revert("ECDSA: invalid signature");
561         } else if (error == RecoverError.InvalidSignatureLength) {
562             revert("ECDSA: invalid signature length");
563         } else if (error == RecoverError.InvalidSignatureS) {
564             revert("ECDSA: invalid signature 's' value");
565         }
566     }
567 
568     /**
569      * @dev Returns the address that signed a hashed message (`hash`) with
570      * `signature` or error string. This address can then be used for verification purposes.
571      *
572      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
573      * this function rejects them by requiring the `s` value to be in the lower
574      * half order, and the `v` value to be either 27 or 28.
575      *
576      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
577      * verification to be secure: it is possible to craft signatures that
578      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
579      * this is by receiving a hash of the original message (which may otherwise
580      * be too long), and then calling {toEthSignedMessageHash} on it.
581      *
582      * Documentation for signature generation:
583      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
584      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
585      *
586      * _Available since v4.3._
587      */
588     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
589         if (signature.length == 65) {
590             bytes32 r;
591             bytes32 s;
592             uint8 v;
593             // ecrecover takes the signature parameters, and the only way to get them
594             // currently is to use assembly.
595             /// @solidity memory-safe-assembly
596             assembly {
597                 r := mload(add(signature, 0x20))
598                 s := mload(add(signature, 0x40))
599                 v := byte(0, mload(add(signature, 0x60)))
600             }
601             return tryRecover(hash, v, r, s);
602         } else {
603             return (address(0), RecoverError.InvalidSignatureLength);
604         }
605     }
606 
607     /**
608      * @dev Returns the address that signed a hashed message (`hash`) with
609      * `signature`. This address can then be used for verification purposes.
610      *
611      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
612      * this function rejects them by requiring the `s` value to be in the lower
613      * half order, and the `v` value to be either 27 or 28.
614      *
615      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
616      * verification to be secure: it is possible to craft signatures that
617      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
618      * this is by receiving a hash of the original message (which may otherwise
619      * be too long), and then calling {toEthSignedMessageHash} on it.
620      */
621     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
622         (address recovered, RecoverError error) = tryRecover(hash, signature);
623         _throwError(error);
624         return recovered;
625     }
626 
627     /**
628      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
629      *
630      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
631      *
632      * _Available since v4.3._
633      */
634     function tryRecover(
635         bytes32 hash,
636         bytes32 r,
637         bytes32 vs
638     ) internal pure returns (address, RecoverError) {
639         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
640         uint8 v = uint8((uint256(vs) >> 255) + 27);
641         return tryRecover(hash, v, r, s);
642     }
643 
644     /**
645      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
646      *
647      * _Available since v4.2._
648      */
649     function recover(
650         bytes32 hash,
651         bytes32 r,
652         bytes32 vs
653     ) internal pure returns (address) {
654         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
655         _throwError(error);
656         return recovered;
657     }
658 
659     /**
660      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
661      * `r` and `s` signature fields separately.
662      *
663      * _Available since v4.3._
664      */
665     function tryRecover(
666         bytes32 hash,
667         uint8 v,
668         bytes32 r,
669         bytes32 s
670     ) internal pure returns (address, RecoverError) {
671         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
672         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
673         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
674         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
675         //
676         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
677         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
678         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
679         // these malleable signatures as well.
680         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
681             return (address(0), RecoverError.InvalidSignatureS);
682         }
683 
684         // If the signature is valid (and not malleable), return the signer address
685         address signer = ecrecover(hash, v, r, s);
686         if (signer == address(0)) {
687             return (address(0), RecoverError.InvalidSignature);
688         }
689 
690         return (signer, RecoverError.NoError);
691     }
692 
693     /**
694      * @dev Overload of {ECDSA-recover} that receives the `v`,
695      * `r` and `s` signature fields separately.
696      */
697     function recover(
698         bytes32 hash,
699         uint8 v,
700         bytes32 r,
701         bytes32 s
702     ) internal pure returns (address) {
703         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
704         _throwError(error);
705         return recovered;
706     }
707 
708     /**
709      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
710      * produces hash corresponding to the one signed with the
711      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
712      * JSON-RPC method as part of EIP-191.
713      *
714      * See {recover}.
715      */
716     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
717         // 32 is the length in bytes of hash,
718         // enforced by the type signature above
719         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
720     }
721 
722     /**
723      * @dev Returns an Ethereum Signed Message, created from `s`. This
724      * produces hash corresponding to the one signed with the
725      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
726      * JSON-RPC method as part of EIP-191.
727      *
728      * See {recover}.
729      */
730     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
731         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
732     }
733 
734     /**
735      * @dev Returns an Ethereum Signed Typed Data, created from a
736      * `domainSeparator` and a `structHash`. This produces hash corresponding
737      * to the one signed with the
738      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
739      * JSON-RPC method as part of EIP-712.
740      *
741      * See {recover}.
742      */
743     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
744         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
745     }
746 }
747 
748 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
749 
750 
751 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
752 
753 pragma solidity ^0.8.0;
754 
755 /**
756  * @dev Contract module that helps prevent reentrant calls to a function.
757  *
758  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
759  * available, which can be applied to functions to make sure there are no nested
760  * (reentrant) calls to them.
761  *
762  * Note that because there is a single `nonReentrant` guard, functions marked as
763  * `nonReentrant` may not call one another. This can be worked around by making
764  * those functions `private`, and then adding `external` `nonReentrant` entry
765  * points to them.
766  *
767  * TIP: If you would like to learn more about reentrancy and alternative ways
768  * to protect against it, check out our blog post
769  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
770  */
771 abstract contract ReentrancyGuard {
772     // Booleans are more expensive than uint256 or any type that takes up a full
773     // word because each write operation emits an extra SLOAD to first read the
774     // slot's contents, replace the bits taken up by the boolean, and then write
775     // back. This is the compiler's defense against contract upgrades and
776     // pointer aliasing, and it cannot be disabled.
777 
778     // The values being non-zero value makes deployment a bit more expensive,
779     // but in exchange the refund on every call to nonReentrant will be lower in
780     // amount. Since refunds are capped to a percentage of the total
781     // transaction's gas, it is best to keep them low in cases like this one, to
782     // increase the likelihood of the full refund coming into effect.
783     uint256 private constant _NOT_ENTERED = 1;
784     uint256 private constant _ENTERED = 2;
785 
786     uint256 private _status;
787 
788     constructor() {
789         _status = _NOT_ENTERED;
790     }
791 
792     /**
793      * @dev Prevents a contract from calling itself, directly or indirectly.
794      * Calling a `nonReentrant` function from another `nonReentrant`
795      * function is not supported. It is possible to prevent this from happening
796      * by making the `nonReentrant` function external, and making it call a
797      * `private` function that does the actual work.
798      */
799     modifier nonReentrant() {
800         _nonReentrantBefore();
801         _;
802         _nonReentrantAfter();
803     }
804 
805     function _nonReentrantBefore() private {
806         // On the first call to nonReentrant, _status will be _NOT_ENTERED
807         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
808 
809         // Any calls to nonReentrant after this point will fail
810         _status = _ENTERED;
811     }
812 
813     function _nonReentrantAfter() private {
814         // By storing the original value once again, a refund is triggered (see
815         // https://eips.ethereum.org/EIPS/eip-2200)
816         _status = _NOT_ENTERED;
817     }
818 }
819 
820 // File: contracts/RiftersStaking.sol
821 
822 interface IERC1155 {
823   function balanceOf(address account, uint256 id) external returns (uint256);
824 
825   function safeTransferFrom(
826     address from,
827     address to,
828     uint256 id,
829     uint256 amount,
830     bytes memory data
831   ) external;
832 }
833 
834 //AETHER
835 pragma solidity >=0.8.0 <0.9.0;
836 
837 
838 
839 
840 contract RiftersStaking is ReentrancyGuard, Ownable {
841   using ECDSA for bytes32;
842   address public signerAddress;
843   address public nftContractAddress;
844 
845   struct stakingState {
846     address staker;
847     uint96 nonce;
848   }
849 
850   mapping(uint256 => stakingState) public nft;
851 
852   event nftStaked(address depositer, uint256 nftId, string indexed stakingType);
853   event nftWithdrawn(address depositer, uint256 nftId);
854 
855   constructor(address _signerAddress, address _nftContractAddress) {
856     signerAddress = _signerAddress;
857     nftContractAddress = _nftContractAddress;
858   }
859 
860   function Stake(uint256 nftIds, string calldata stakingType) external payable nonReentrant {
861     _depositERC1155(msg.sender, nftIds, stakingType);
862   }
863 
864 
865 
866   function _depositERC1155(address _from, uint256 id, string calldata stakingType) private {
867     IERC1155(nftContractAddress).safeTransferFrom(
868       _from,
869       address(this),
870       id,
871       1,
872       ""
873     );
874     setNftStaker(_from, id);
875     emit nftStaked(_from, id, stakingType);
876   }
877 
878   function unStake(uint256 nftId, bytes calldata signature)
879     external
880     payable
881     nonReentrant
882   {
883     _withdrawNFT(msg.sender, nftId, signature);
884   }
885 
886   function _withdrawNFT(
887     address to,
888     uint256 nftId,
889     bytes calldata signature
890   ) private {
891     validateStakerOfNft(nftId, to);
892     validateUsingECDASignature(signature, nftId, nft[nftId].nonce);
893     resetNftID(nftId);
894     IERC1155(nftContractAddress).safeTransferFrom(
895       address(this),
896       to,
897       nftId,
898       1,
899       ""
900     );
901     emit nftWithdrawn(to, nftId);
902   }
903 
904   function validateUsingECDASignature(
905     bytes calldata signature,
906     uint256 tokenId,
907     uint256 nonce
908   ) public view {
909     bytes32 hash = keccak256(
910       abi.encodePacked(bytes32(uint256(uint160(msg.sender))), bytes32(uint256(uint160(address(this)))), tokenId, nonce)
911     );
912     require(
913       signerAddress == hash.toEthSignedMessageHash().recover(signature),
914       "Signer address mismatch."
915     );
916   }
917 
918   function validateStakerOfNft(uint256 tokenId, address owner) private view {
919     require(
920       nft[tokenId].staker == owner,
921       "this is not the owner of the nft staked"
922     );
923   }
924 
925   function resetNftID(uint256 nftId) private {
926     nft[nftId].nonce += 1;
927     nft[nftId].staker = address(0);
928   }
929 
930   function setNftStaker(address owner, uint256 nftid) private {
931     nft[nftid].staker = owner;
932   }
933 
934   function setSignerAddress(address _signerAddress)
935     public
936     onlyOwner
937     nonReentrant
938   {
939     signerAddress = _signerAddress;
940   }
941 
942   function onERC1155Received(
943     address,
944     address,
945     uint256,
946     uint256,
947     bytes calldata
948   ) public pure returns (bytes4) {
949     return this.onERC1155Received.selector;
950   }
951 
952   // release address based on shares.
953   function withdrawEth() external onlyOwner nonReentrant {
954     (bool success, ) = msg.sender.call{value: address(this).balance}("");
955     require(success, "Transfer failed.");
956   }
957 
958   receive() external payable {}
959 }