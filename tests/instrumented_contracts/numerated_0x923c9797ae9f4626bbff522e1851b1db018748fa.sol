1 // SPDX-License-Identifier: MIT
2 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3 
4 pragma solidity ^0.8.0;
5 
6 /**
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.8.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 abstract contract Ownable is Context {
42     address private _owner;
43 
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor() {
50         _transferOwnership(_msgSender());
51     }
52 
53     /**
54      * @dev Throws if called by any account other than the owner.
55      */
56     modifier onlyOwner() {
57         _checkOwner();
58         _;
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if the sender is not the owner.
70      */
71     function _checkOwner() internal view virtual {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby disabling any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 
107 pragma solidity ^0.8.0;
108 
109 /**
110  * @dev Standard math utilities missing in the Solidity language.
111  */
112 library Math {
113     enum Rounding {
114         Down, // Toward negative infinity
115         Up, // Toward infinity
116         Zero // Toward zero
117     }
118 
119     /**
120      * @dev Returns the largest of two numbers.
121      */
122     function max(uint256 a, uint256 b) internal pure returns (uint256) {
123         return a > b ? a : b;
124     }
125 
126     /**
127      * @dev Returns the smallest of two numbers.
128      */
129     function min(uint256 a, uint256 b) internal pure returns (uint256) {
130         return a < b ? a : b;
131     }
132 
133     /**
134      * @dev Returns the average of two numbers. The result is rounded towards
135      * zero.
136      */
137     function average(uint256 a, uint256 b) internal pure returns (uint256) {
138         // (a + b) / 2 can overflow.
139         return (a & b) + (a ^ b) / 2;
140     }
141 
142     /**
143      * @dev Returns the ceiling of the division of two numbers.
144      *
145      * This differs from standard division with `/` in that it rounds up instead
146      * of rounding down.
147      */
148     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
149         // (a + b - 1) / b can overflow on addition, so we distribute.
150         return a == 0 ? 0 : (a - 1) / b + 1;
151     }
152 
153     function mulDiv(uint256 x, uint256 y, uint256 denominator) internal pure returns (uint256 result) {
154         unchecked {
155             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
156             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
157             // variables such that product = prod1 * 2^256 + prod0.
158             uint256 prod0; // Least significant 256 bits of the product
159             uint256 prod1; // Most significant 256 bits of the product
160             assembly {
161                 let mm := mulmod(x, y, not(0))
162                 prod0 := mul(x, y)
163                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
164             }
165 
166             // Handle non-overflow cases, 256 by 256 division.
167             if (prod1 == 0) {
168                 // Solidity will revert if denominator == 0, unlike the div opcode on its own.
169                 // The surrounding unchecked block does not change this fact.
170                 // See https://docs.soliditylang.org/en/latest/control-structures.html#checked-or-unchecked-arithmetic.
171                 return prod0 / denominator;
172             }
173 
174             // Make sure the result is less than 2^256. Also prevents denominator == 0.
175             require(denominator > prod1, "Math: mulDiv overflow");
176 
177             ///////////////////////////////////////////////
178             // 512 by 256 division.
179             ///////////////////////////////////////////////
180 
181             // Make division exact by subtracting the remainder from [prod1 prod0].
182             uint256 remainder;
183             assembly {
184                 // Compute remainder using mulmod.
185                 remainder := mulmod(x, y, denominator)
186 
187                 // Subtract 256 bit number from 512 bit number.
188                 prod1 := sub(prod1, gt(remainder, prod0))
189                 prod0 := sub(prod0, remainder)
190             }
191 
192             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
193             // See https://cs.stackexchange.com/q/138556/92363.
194 
195             // Does not overflow because the denominator cannot be zero at this stage in the function.
196             uint256 twos = denominator & (~denominator + 1);
197             assembly {
198                 // Divide denominator by twos.
199                 denominator := div(denominator, twos)
200 
201                 // Divide [prod1 prod0] by twos.
202                 prod0 := div(prod0, twos)
203 
204                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
205                 twos := add(div(sub(0, twos), twos), 1)
206             }
207 
208             // Shift in bits from prod1 into prod0.
209             prod0 |= prod1 * twos;
210 
211             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
212             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
213             // four bits. That is, denominator * inv = 1 mod 2^4.
214             uint256 inverse = (3 * denominator) ^ 2;
215 
216             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
217             // in modular arithmetic, doubling the correct bits in each step.
218             inverse *= 2 - denominator * inverse; // inverse mod 2^8
219             inverse *= 2 - denominator * inverse; // inverse mod 2^16
220             inverse *= 2 - denominator * inverse; // inverse mod 2^32
221             inverse *= 2 - denominator * inverse; // inverse mod 2^64
222             inverse *= 2 - denominator * inverse; // inverse mod 2^128
223             inverse *= 2 - denominator * inverse; // inverse mod 2^256
224 
225             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
226             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
227             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
228             // is no longer required.
229             result = prod0 * inverse;
230             return result;
231         }
232     }
233 
234     /**
235      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
236      */
237     function mulDiv(uint256 x, uint256 y, uint256 denominator, Rounding rounding) internal pure returns (uint256) {
238         uint256 result = mulDiv(x, y, denominator);
239         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
240             result += 1;
241         }
242         return result;
243     }
244 
245     /**
246      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
247      *
248      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
249      */
250     function sqrt(uint256 a) internal pure returns (uint256) {
251         if (a == 0) {
252             return 0;
253         }
254 
255         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
256         //
257         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
258         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
259         //
260         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
261         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
262         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
263         //
264         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
265         uint256 result = 1 << (log2(a) >> 1);
266 
267         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
268         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
269         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
270         // into the expected uint128 result.
271         unchecked {
272             result = (result + a / result) >> 1;
273             result = (result + a / result) >> 1;
274             result = (result + a / result) >> 1;
275             result = (result + a / result) >> 1;
276             result = (result + a / result) >> 1;
277             result = (result + a / result) >> 1;
278             result = (result + a / result) >> 1;
279             return min(result, a / result);
280         }
281     }
282 
283     /**
284      * @notice Calculates sqrt(a), following the selected rounding direction.
285      */
286     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
287         unchecked {
288             uint256 result = sqrt(a);
289             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
290         }
291     }
292 
293     /**
294      * @dev Return the log in base 2, rounded down, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log2(uint256 value) internal pure returns (uint256) {
298         uint256 result = 0;
299         unchecked {
300             if (value >> 128 > 0) {
301                 value >>= 128;
302                 result += 128;
303             }
304             if (value >> 64 > 0) {
305                 value >>= 64;
306                 result += 64;
307             }
308             if (value >> 32 > 0) {
309                 value >>= 32;
310                 result += 32;
311             }
312             if (value >> 16 > 0) {
313                 value >>= 16;
314                 result += 16;
315             }
316             if (value >> 8 > 0) {
317                 value >>= 8;
318                 result += 8;
319             }
320             if (value >> 4 > 0) {
321                 value >>= 4;
322                 result += 4;
323             }
324             if (value >> 2 > 0) {
325                 value >>= 2;
326                 result += 2;
327             }
328             if (value >> 1 > 0) {
329                 result += 1;
330             }
331         }
332         return result;
333     }
334 
335     /**
336      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
337      * Returns 0 if given 0.
338      */
339     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
340         unchecked {
341             uint256 result = log2(value);
342             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
343         }
344     }
345 
346     /**
347      * @dev Return the log in base 10, rounded down, of a positive value.
348      * Returns 0 if given 0.
349      */
350     function log10(uint256 value) internal pure returns (uint256) {
351         uint256 result = 0;
352         unchecked {
353             if (value >= 10 ** 64) {
354                 value /= 10 ** 64;
355                 result += 64;
356             }
357             if (value >= 10 ** 32) {
358                 value /= 10 ** 32;
359                 result += 32;
360             }
361             if (value >= 10 ** 16) {
362                 value /= 10 ** 16;
363                 result += 16;
364             }
365             if (value >= 10 ** 8) {
366                 value /= 10 ** 8;
367                 result += 8;
368             }
369             if (value >= 10 ** 4) {
370                 value /= 10 ** 4;
371                 result += 4;
372             }
373             if (value >= 10 ** 2) {
374                 value /= 10 ** 2;
375                 result += 2;
376             }
377             if (value >= 10 ** 1) {
378                 result += 1;
379             }
380         }
381         return result;
382     }
383 
384     /**
385      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
386      * Returns 0 if given 0.
387      */
388     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
389         unchecked {
390             uint256 result = log10(value);
391             return result + (rounding == Rounding.Up && 10 ** result < value ? 1 : 0);
392         }
393     }
394 
395     /**
396      * @dev Return the log in base 256, rounded down, of a positive value.
397      * Returns 0 if given 0.
398      *
399      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
400      */
401     function log256(uint256 value) internal pure returns (uint256) {
402         uint256 result = 0;
403         unchecked {
404             if (value >> 128 > 0) {
405                 value >>= 128;
406                 result += 16;
407             }
408             if (value >> 64 > 0) {
409                 value >>= 64;
410                 result += 8;
411             }
412             if (value >> 32 > 0) {
413                 value >>= 32;
414                 result += 4;
415             }
416             if (value >> 16 > 0) {
417                 value >>= 16;
418                 result += 2;
419             }
420             if (value >> 8 > 0) {
421                 result += 1;
422             }
423         }
424         return result;
425     }
426 
427     /**
428      * @dev Return the log in base 256, following the selected rounding direction, of a positive value.
429      * Returns 0 if given 0.
430      */
431     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
432         unchecked {
433             uint256 result = log256(value);
434             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
435         }
436     }
437 }
438 
439 
440 pragma solidity ^0.8.0;
441 
442 /**
443  * @dev Standard signed math utilities missing in the Solidity language.
444  */
445 library SignedMath {
446     /**
447      * @dev Returns the largest of two signed numbers.
448      */
449     function max(int256 a, int256 b) internal pure returns (int256) {
450         return a > b ? a : b;
451     }
452 
453     /**
454      * @dev Returns the smallest of two signed numbers.
455      */
456     function min(int256 a, int256 b) internal pure returns (int256) {
457         return a < b ? a : b;
458     }
459 
460     /**
461      * @dev Returns the average of two signed numbers without overflow.
462      * The result is rounded towards zero.
463      */
464     function average(int256 a, int256 b) internal pure returns (int256) {
465         // Formula from the book "Hacker's Delight"
466         int256 x = (a & b) + ((a ^ b) >> 1);
467         return x + (int256(uint256(x) >> 255) & (a ^ b));
468     }
469 
470     /**
471      * @dev Returns the absolute unsigned value of a signed value.
472      */
473     function abs(int256 n) internal pure returns (uint256) {
474         unchecked {
475             // must be unchecked in order to support `n = type(int256).min`
476             return uint256(n >= 0 ? n : -n);
477         }
478     }
479 }
480 
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev String operations.
487  */
488 library Strings {
489     bytes16 private constant _SYMBOLS = "0123456789abcdef";
490     uint8 private constant _ADDRESS_LENGTH = 20;
491 
492     /**
493      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
494      */
495     function toString(uint256 value) internal pure returns (string memory) {
496         unchecked {
497             uint256 length = Math.log10(value) + 1;
498             string memory buffer = new string(length);
499             uint256 ptr;
500             /// @solidity memory-safe-assembly
501             assembly {
502                 ptr := add(buffer, add(32, length))
503             }
504             while (true) {
505                 ptr--;
506                 /// @solidity memory-safe-assembly
507                 assembly {
508                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
509                 }
510                 value /= 10;
511                 if (value == 0) break;
512             }
513             return buffer;
514         }
515     }
516 
517     /**
518      * @dev Converts a `int256` to its ASCII `string` decimal representation.
519      */
520     function toString(int256 value) internal pure returns (string memory) {
521         return string(abi.encodePacked(value < 0 ? "-" : "", toString(SignedMath.abs(value))));
522     }
523 
524     /**
525      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
526      */
527     function toHexString(uint256 value) internal pure returns (string memory) {
528         unchecked {
529             return toHexString(value, Math.log256(value) + 1);
530         }
531     }
532 
533     /**
534      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
535      */
536     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
537         bytes memory buffer = new bytes(2 * length + 2);
538         buffer[0] = "0";
539         buffer[1] = "x";
540         for (uint256 i = 2 * length + 1; i > 1; --i) {
541             buffer[i] = _SYMBOLS[value & 0xf];
542             value >>= 4;
543         }
544         require(value == 0, "Strings: hex length insufficient");
545         return string(buffer);
546     }
547 
548     /**
549      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
550      */
551     function toHexString(address addr) internal pure returns (string memory) {
552         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
553     }
554 
555     /**
556      * @dev Returns true if the two strings are equal.
557      */
558     function equal(string memory a, string memory b) internal pure returns (bool) {
559         return keccak256(bytes(a)) == keccak256(bytes(b));
560     }
561 }
562 
563 
564 pragma solidity ^0.8.0;
565 
566 /**
567  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
568  *
569  * These functions can be used to verify that a message was signed by the holder
570  * of the private keys of a given address.
571  */
572 library ECDSA {
573     enum RecoverError {
574         NoError,
575         InvalidSignature,
576         InvalidSignatureLength,
577         InvalidSignatureS,
578         InvalidSignatureV // Deprecated in v4.8
579     }
580 
581     function _throwError(RecoverError error) private pure {
582         if (error == RecoverError.NoError) {
583             return; // no error: do nothing
584         } else if (error == RecoverError.InvalidSignature) {
585             revert("ECDSA: invalid signature");
586         } else if (error == RecoverError.InvalidSignatureLength) {
587             revert("ECDSA: invalid signature length");
588         } else if (error == RecoverError.InvalidSignatureS) {
589             revert("ECDSA: invalid signature 's' value");
590         }
591     }
592 
593     /**
594      * @dev Returns the address that signed a hashed message (`hash`) with
595      * `signature` or error string. This address can then be used for verification purposes.
596      *
597      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
598      * this function rejects them by requiring the `s` value to be in the lower
599      * half order, and the `v` value to be either 27 or 28.
600      *
601      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
602      * verification to be secure: it is possible to craft signatures that
603      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
604      * this is by receiving a hash of the original message (which may otherwise
605      * be too long), and then calling {toEthSignedMessageHash} on it.
606      *
607      * Documentation for signature generation:
608      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
609      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
610      *
611      * _Available since v4.3._
612      */
613     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
614         if (signature.length == 65) {
615             bytes32 r;
616             bytes32 s;
617             uint8 v;
618             // ecrecover takes the signature parameters, and the only way to get them
619             // currently is to use assembly.
620             /// @solidity memory-safe-assembly
621             assembly {
622                 r := mload(add(signature, 0x20))
623                 s := mload(add(signature, 0x40))
624                 v := byte(0, mload(add(signature, 0x60)))
625             }
626             return tryRecover(hash, v, r, s);
627         } else {
628             return (address(0), RecoverError.InvalidSignatureLength);
629         }
630     }
631 
632     /**
633      * @dev Returns the address that signed a hashed message (`hash`) with
634      * `signature`. This address can then be used for verification purposes.
635      *
636      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
637      * this function rejects them by requiring the `s` value to be in the lower
638      * half order, and the `v` value to be either 27 or 28.
639      *
640      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
641      * verification to be secure: it is possible to craft signatures that
642      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
643      * this is by receiving a hash of the original message (which may otherwise
644      * be too long), and then calling {toEthSignedMessageHash} on it.
645      */
646     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
647         (address recovered, RecoverError error) = tryRecover(hash, signature);
648         _throwError(error);
649         return recovered;
650     }
651 
652     /**
653      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
654      *
655      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
656      *
657      * _Available since v4.3._
658      */
659     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
660         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
661         uint8 v = uint8((uint256(vs) >> 255) + 27);
662         return tryRecover(hash, v, r, s);
663     }
664 
665     /**
666      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
667      *
668      * _Available since v4.2._
669      */
670     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
671         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
672         _throwError(error);
673         return recovered;
674     }
675 
676     /**
677      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
678      * `r` and `s` signature fields separately.
679      *
680      * _Available since v4.3._
681      */
682     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
683         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
684         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
685         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
686         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
687         //
688         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
689         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
690         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
691         // these malleable signatures as well.
692         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
693             return (address(0), RecoverError.InvalidSignatureS);
694         }
695 
696         // If the signature is valid (and not malleable), return the signer address
697         address signer = ecrecover(hash, v, r, s);
698         if (signer == address(0)) {
699             return (address(0), RecoverError.InvalidSignature);
700         }
701 
702         return (signer, RecoverError.NoError);
703     }
704 
705     /**
706      * @dev Overload of {ECDSA-recover} that receives the `v`,
707      * `r` and `s` signature fields separately.
708      */
709     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
710         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
711         _throwError(error);
712         return recovered;
713     }
714 
715     /**
716      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
717      * produces hash corresponding to the one signed with the
718      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
719      * JSON-RPC method as part of EIP-191.
720      *
721      * See {recover}.
722      */
723     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
724         // 32 is the length in bytes of hash,
725         // enforced by the type signature above
726         /// @solidity memory-safe-assembly
727         assembly {
728             mstore(0x00, "\x19Ethereum Signed Message:\n32")
729             mstore(0x1c, hash)
730             message := keccak256(0x00, 0x3c)
731         }
732     }
733 
734     /**
735      * @dev Returns an Ethereum Signed Message, created from `s`. This
736      * produces hash corresponding to the one signed with the
737      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
738      * JSON-RPC method as part of EIP-191.
739      *
740      * See {recover}.
741      */
742     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
743         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
744     }
745 
746     /**
747      * @dev Returns an Ethereum Signed Typed Data, created from a
748      * `domainSeparator` and a `structHash`. This produces hash corresponding
749      * to the one signed with the
750      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
751      * JSON-RPC method as part of EIP-712.
752      *
753      * See {recover}.
754      */
755     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
756         /// @solidity memory-safe-assembly
757         assembly {
758             let ptr := mload(0x40)
759             mstore(ptr, "\x19\x01")
760             mstore(add(ptr, 0x02), domainSeparator)
761             mstore(add(ptr, 0x22), structHash)
762             data := keccak256(ptr, 0x42)
763         }
764     }
765 
766     /**
767      * @dev Returns an Ethereum Signed Data with intended validator, created from a
768      * `validator` and `data` according to the version 0 of EIP-191.
769      *
770      * See {recover}.
771      */
772     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
773         return keccak256(abi.encodePacked("\x19\x00", validator, data));
774     }
775 }
776 
777 
778 pragma solidity ^0.8.0;
779 
780 /**
781  * @dev Interface of the ERC20 standard as defined in the EIP.
782  */
783 interface IERC20 {
784     /**
785      * @dev Emitted when `value` tokens are moved from one account (`from`) to
786      * another (`to`).
787      *
788      * Note that `value` may be zero.
789      */
790     event Transfer(address indexed from, address indexed to, uint256 value);
791 
792     /**
793      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
794      * a call to {approve}. `value` is the new allowance.
795      */
796     event Approval(address indexed owner, address indexed spender, uint256 value);
797 
798     /**
799      * @dev Returns the amount of tokens in existence.
800      */
801     function totalSupply() external view returns (uint256);
802 
803     /**
804      * @dev Returns the amount of tokens owned by `account`.
805      */
806     function balanceOf(address account) external view returns (uint256);
807 
808     /**
809      * @dev Moves `amount` tokens from the caller's account to `to`.
810      *
811      * Returns a boolean value indicating whether the operation succeeded.
812      *
813      * Emits a {Transfer} event.
814      */
815     function transfer(address to, uint256 amount) external returns (bool);
816 
817     /**
818      * @dev Returns the remaining number of tokens that `spender` will be
819      * allowed to spend on behalf of `owner` through {transferFrom}. This is
820      * zero by default.
821      *
822      * This value changes when {approve} or {transferFrom} are called.
823      */
824     function allowance(address owner, address spender) external view returns (uint256);
825 
826     /**
827      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
828      *
829      * Returns a boolean value indicating whether the operation succeeded.
830      *
831      * IMPORTANT: Beware that changing an allowance with this method brings the risk
832      * that someone may use both the old and the new allowance by unfortunate
833      * transaction ordering. One possible solution to mitigate this race
834      * condition is to first reduce the spender's allowance to 0 and set the
835      * desired value afterwards:
836      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
837      *
838      * Emits an {Approval} event.
839      */
840     function approve(address spender, uint256 amount) external returns (bool);
841 
842     /**
843      * @dev Moves `amount` tokens from `from` to `to` using the
844      * allowance mechanism. `amount` is then deducted from the caller's
845      * allowance.
846      *
847      * Returns a boolean value indicating whether the operation succeeded.
848      *
849      * Emits a {Transfer} event.
850      */
851     function transferFrom(address from, address to, uint256 amount) external returns (bool);
852 }
853 
854 
855 pragma solidity >=0.4.22 <0.9.0;
856 
857 interface IBurnableERC20 is IERC20 {
858     function burn(uint256 amount) external;
859 }
860 
861 
862 pragma solidity ^0.8.0;
863 
864 /**
865  * @dev Library for managing
866  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
867  * types.
868  *
869  * Sets have the following properties:
870  *
871  * - Elements are added, removed, and checked for existence in constant time
872  * (O(1)).
873  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
874  *
875  * ```solidity
876  * contract Example {
877  *     // Add the library methods
878  *     using EnumerableSet for EnumerableSet.AddressSet;
879  *
880  *     // Declare a set state variable
881  *     EnumerableSet.AddressSet private mySet;
882  * }
883  * ```
884  *
885  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
886  * and `uint256` (`UintSet`) are supported.
887  *
888  * [WARNING]
889  * ====
890  * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
891  * unusable.
892  * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
893  *
894  * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
895  * array of EnumerableSet.
896  * ====
897  */
898 library EnumerableSet {
899     // To implement this library for multiple types with as little code
900     // repetition as possible, we write it in terms of a generic Set type with
901     // bytes32 values.
902     // The Set implementation uses private functions, and user-facing
903     // implementations (such as AddressSet) are just wrappers around the
904     // underlying Set.
905     // This means that we can only create new EnumerableSets for types that fit
906     // in bytes32.
907 
908     struct Set {
909         // Storage of set values
910         bytes32[] _values;
911         // Position of the value in the `values` array, plus 1 because index 0
912         // means a value is not in the set.
913         mapping(bytes32 => uint256) _indexes;
914     }
915 
916     /**
917      * @dev Add a value to a set. O(1).
918      *
919      * Returns true if the value was added to the set, that is if it was not
920      * already present.
921      */
922     function _add(Set storage set, bytes32 value) private returns (bool) {
923         if (!_contains(set, value)) {
924             set._values.push(value);
925             // The value is stored at length-1, but we add 1 to all indexes
926             // and use 0 as a sentinel value
927             set._indexes[value] = set._values.length;
928             return true;
929         } else {
930             return false;
931         }
932     }
933 
934     /**
935      * @dev Removes a value from a set. O(1).
936      *
937      * Returns true if the value was removed from the set, that is if it was
938      * present.
939      */
940     function _remove(Set storage set, bytes32 value) private returns (bool) {
941         // We read and store the value's index to prevent multiple reads from the same storage slot
942         uint256 valueIndex = set._indexes[value];
943 
944         if (valueIndex != 0) {
945             // Equivalent to contains(set, value)
946             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
947             // the array, and then remove the last element (sometimes called as 'swap and pop').
948             // This modifies the order of the array, as noted in {at}.
949 
950             uint256 toDeleteIndex = valueIndex - 1;
951             uint256 lastIndex = set._values.length - 1;
952 
953             if (lastIndex != toDeleteIndex) {
954                 bytes32 lastValue = set._values[lastIndex];
955 
956                 // Move the last value to the index where the value to delete is
957                 set._values[toDeleteIndex] = lastValue;
958                 // Update the index for the moved value
959                 set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
960             }
961 
962             // Delete the slot where the moved value was stored
963             set._values.pop();
964 
965             // Delete the index for the deleted slot
966             delete set._indexes[value];
967 
968             return true;
969         } else {
970             return false;
971         }
972     }
973 
974     /**
975      * @dev Returns true if the value is in the set. O(1).
976      */
977     function _contains(Set storage set, bytes32 value) private view returns (bool) {
978         return set._indexes[value] != 0;
979     }
980 
981     /**
982      * @dev Returns the number of values on the set. O(1).
983      */
984     function _length(Set storage set) private view returns (uint256) {
985         return set._values.length;
986     }
987 
988     /**
989      * @dev Returns the value stored at position `index` in the set. O(1).
990      *
991      * Note that there are no guarantees on the ordering of values inside the
992      * array, and it may change when more values are added or removed.
993      *
994      * Requirements:
995      *
996      * - `index` must be strictly less than {length}.
997      */
998     function _at(Set storage set, uint256 index) private view returns (bytes32) {
999         return set._values[index];
1000     }
1001 
1002     /**
1003      * @dev Return the entire set in an array
1004      *
1005      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1006      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1007      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1008      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1009      */
1010     function _values(Set storage set) private view returns (bytes32[] memory) {
1011         return set._values;
1012     }
1013 
1014     // Bytes32Set
1015 
1016     struct Bytes32Set {
1017         Set _inner;
1018     }
1019 
1020     /**
1021      * @dev Add a value to a set. O(1).
1022      *
1023      * Returns true if the value was added to the set, that is if it was not
1024      * already present.
1025      */
1026     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1027         return _add(set._inner, value);
1028     }
1029 
1030     /**
1031      * @dev Removes a value from a set. O(1).
1032      *
1033      * Returns true if the value was removed from the set, that is if it was
1034      * present.
1035      */
1036     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1037         return _remove(set._inner, value);
1038     }
1039 
1040     /**
1041      * @dev Returns true if the value is in the set. O(1).
1042      */
1043     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1044         return _contains(set._inner, value);
1045     }
1046 
1047     /**
1048      * @dev Returns the number of values in the set. O(1).
1049      */
1050     function length(Bytes32Set storage set) internal view returns (uint256) {
1051         return _length(set._inner);
1052     }
1053 
1054     /**
1055      * @dev Returns the value stored at position `index` in the set. O(1).
1056      *
1057      * Note that there are no guarantees on the ordering of values inside the
1058      * array, and it may change when more values are added or removed.
1059      *
1060      * Requirements:
1061      *
1062      * - `index` must be strictly less than {length}.
1063      */
1064     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1065         return _at(set._inner, index);
1066     }
1067 
1068     /**
1069      * @dev Return the entire set in an array
1070      *
1071      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1072      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1073      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1074      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1075      */
1076     function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
1077         bytes32[] memory store = _values(set._inner);
1078         bytes32[] memory result;
1079 
1080         /// @solidity memory-safe-assembly
1081         assembly {
1082             result := store
1083         }
1084 
1085         return result;
1086     }
1087 
1088     // AddressSet
1089 
1090     struct AddressSet {
1091         Set _inner;
1092     }
1093 
1094     /**
1095      * @dev Add a value to a set. O(1).
1096      *
1097      * Returns true if the value was added to the set, that is if it was not
1098      * already present.
1099      */
1100     function add(AddressSet storage set, address value) internal returns (bool) {
1101         return _add(set._inner, bytes32(uint256(uint160(value))));
1102     }
1103 
1104     /**
1105      * @dev Removes a value from a set. O(1).
1106      *
1107      * Returns true if the value was removed from the set, that is if it was
1108      * present.
1109      */
1110     function remove(AddressSet storage set, address value) internal returns (bool) {
1111         return _remove(set._inner, bytes32(uint256(uint160(value))));
1112     }
1113 
1114     /**
1115      * @dev Returns true if the value is in the set. O(1).
1116      */
1117     function contains(AddressSet storage set, address value) internal view returns (bool) {
1118         return _contains(set._inner, bytes32(uint256(uint160(value))));
1119     }
1120 
1121     /**
1122      * @dev Returns the number of values in the set. O(1).
1123      */
1124     function length(AddressSet storage set) internal view returns (uint256) {
1125         return _length(set._inner);
1126     }
1127 
1128     /**
1129      * @dev Returns the value stored at position `index` in the set. O(1).
1130      *
1131      * Note that there are no guarantees on the ordering of values inside the
1132      * array, and it may change when more values are added or removed.
1133      *
1134      * Requirements:
1135      *
1136      * - `index` must be strictly less than {length}.
1137      */
1138     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1139         return address(uint160(uint256(_at(set._inner, index))));
1140     }
1141 
1142     /**
1143      * @dev Return the entire set in an array
1144      *
1145      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1146      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1147      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1148      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1149      */
1150     function values(AddressSet storage set) internal view returns (address[] memory) {
1151         bytes32[] memory store = _values(set._inner);
1152         address[] memory result;
1153 
1154         /// @solidity memory-safe-assembly
1155         assembly {
1156             result := store
1157         }
1158 
1159         return result;
1160     }
1161 
1162     // UintSet
1163 
1164     struct UintSet {
1165         Set _inner;
1166     }
1167 
1168     /**
1169      * @dev Add a value to a set. O(1).
1170      *
1171      * Returns true if the value was added to the set, that is if it was not
1172      * already present.
1173      */
1174     function add(UintSet storage set, uint256 value) internal returns (bool) {
1175         return _add(set._inner, bytes32(value));
1176     }
1177 
1178     /**
1179      * @dev Removes a value from a set. O(1).
1180      *
1181      * Returns true if the value was removed from the set, that is if it was
1182      * present.
1183      */
1184     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1185         return _remove(set._inner, bytes32(value));
1186     }
1187 
1188     /**
1189      * @dev Returns true if the value is in the set. O(1).
1190      */
1191     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1192         return _contains(set._inner, bytes32(value));
1193     }
1194 
1195     /**
1196      * @dev Returns the number of values in the set. O(1).
1197      */
1198     function length(UintSet storage set) internal view returns (uint256) {
1199         return _length(set._inner);
1200     }
1201 
1202     /**
1203      * @dev Returns the value stored at position `index` in the set. O(1).
1204      *
1205      * Note that there are no guarantees on the ordering of values inside the
1206      * array, and it may change when more values are added or removed.
1207      *
1208      * Requirements:
1209      *
1210      * - `index` must be strictly less than {length}.
1211      */
1212     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1213         return uint256(_at(set._inner, index));
1214     }
1215 
1216     /**
1217      * @dev Return the entire set in an array
1218      *
1219      * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
1220      * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
1221      * this function has an unbounded cost, and using it as part of a state-changing function may render the function
1222      * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
1223      */
1224     function values(UintSet storage set) internal view returns (uint256[] memory) {
1225         bytes32[] memory store = _values(set._inner);
1226         uint256[] memory result;
1227 
1228         /// @solidity memory-safe-assembly
1229         assembly {
1230             result := store
1231         }
1232 
1233         return result;
1234     }
1235 }
1236 
1237 
1238 pragma solidity >=0.8.0;
1239 
1240 interface IAIERC20Factory {
1241     event AIERC20Created(
1242         address indexed token, 
1243         TokenConfig tokenConfig, 
1244         TaxConfig taxConfig,
1245         MintConfig mintConfig, 
1246         MetaConfig metaConfig,
1247         PoolAddress poolAddress,
1248         address creator,
1249         uint256 tokensForMint,
1250         uint256 timestamp
1251     );
1252 
1253     struct PoolAddress {
1254         address bounsPool;
1255         address tradingPool;
1256         address reservedPool;
1257         address distributor;
1258         address stakingPool;
1259     }
1260 
1261     struct TaxConfig {
1262         uint8 taxType;
1263         uint256 burnRate;
1264         uint256 teamRate;
1265         uint256 bounsRate;
1266         address bounsToken;
1267         uint256 tradingBounsRate;
1268         uint256 tradingBounsRewardDays;
1269         address tradingBounsToken;
1270         uint256 liquidityRate;
1271     }
1272 
1273     struct TokenConfig {
1274         string name;
1275         string symbol;
1276         uint256 totalSupply;
1277         uint8 decimals;
1278     }
1279 
1280     struct MintConfig {
1281         uint256 startAt; // time to start minting
1282         uint256 endAt; // time to end minting
1283         uint256 totalMints; // Total mint times
1284         uint8 swapIndex; // The swap index that want to use
1285         uint256 reservedRate; // Team reserved share
1286         uint256 reservedUnlockDays; // Team reserved unlock days
1287         uint256 airdropRate; // Shares airdropped to AIDOGE stakers
1288         uint256 lpReservedRate; // Share of liquidity pool
1289         uint256 stakingReservedRate; // Share of staking pool
1290         uint256 stakingRewardDays; // Staking reserved reward days
1291         address payToken; // Tokens that need to be paid when minting
1292         uint256 payAmount; // Amount of tokens that need to be paid when minting
1293         address payTo; // For receiving payments
1294         address[] holdingTokens; // Tokens need to be held in order to claim
1295         uint256[] holdingTokensAmount;
1296     }
1297 
1298     struct MetaConfig {
1299         string logo;
1300         string website;
1301         string twitter;
1302         string discord;
1303         string otherLink;
1304     }
1305 }
1306 
1307 
1308 pragma solidity >=0.8.0;
1309 
1310 interface IEventHub {
1311     function addCaller(address val) external;
1312     function onDistributorClaim(address token, address user, uint256 amount, uint256 fee, address referrer) external;
1313 }
1314 
1315 
1316 pragma solidity >=0.6.12;
1317 
1318 
1319 library SignatureChecker {
1320     using EnumerableSet for EnumerableSet.AddressSet;
1321 
1322     /**
1323     @notice Common validator logic, checking if the recovered signer is
1324     contained in the signers AddressSet.
1325     */
1326     function validSignature(
1327         EnumerableSet.AddressSet storage signers,
1328         bytes32 message,
1329         bytes calldata signature
1330     ) internal view returns (bool) {
1331         return signers.contains(ECDSA.recover(message, signature));
1332     }
1333 
1334     /**
1335     @notice Requires that the recovered signer is contained in the signers
1336     AddressSet.
1337     @dev Convenience wrapper that reverts if the signature validation fails.
1338     */
1339     function requireValidSignature(
1340         EnumerableSet.AddressSet storage signers,
1341         bytes32 message,
1342         bytes calldata signature
1343     ) internal view {
1344         require(
1345             validSignature(signers, message, signature),
1346             "SignatureChecker: Invalid signature"
1347         );
1348     }
1349 
1350     
1351 }
1352 
1353 
1354 pragma solidity =0.8.19;
1355 
1356 
1357 
1358 
1359 
1360 
1361 contract AIERC20Distributor is Ownable {
1362     using SignatureChecker for EnumerableSet.AddressSet;
1363     using EnumerableSet for EnumerableSet.AddressSet;
1364 
1365     struct InfoView {
1366         uint256 limitFreezeCount;
1367         uint256 referralRate;
1368         uint256 totalDistributed;
1369         uint256[] feeAmounts;
1370         uint256 totalClaims;
1371         uint256 stageClaims;
1372         uint256 currentStage;
1373         uint256 stageStartTime;
1374         uint256 stageDuration;
1375         uint256 inviteRewards;
1376         uint256 inviteUsers;
1377     }
1378 
1379     address public constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1380     uint256 public constant LimitFreezeCount = 10;
1381     uint256 public constant ReferralRate = 50; // 5%
1382 
1383     bool public initialized;
1384     IBurnableERC20 public token;
1385     uint256 public tokensPerMint;
1386     uint256 public totalDistributed;
1387     uint256 public startAt;
1388     uint256 public endAt;
1389     address payable public feeTo;
1390     uint256[] public feeAmounts;
1391     address public payToken;
1392     uint256 public payAmount;
1393     address payable public payTo;
1394 
1395     EnumerableSet.AddressSet private _signers;
1396     mapping(uint256 => bool) public _usedNonce;
1397 
1398     uint256 public totalClaims; // 总领取次数
1399     uint256 public stageClaims; //当前阶段内的领取次数
1400     uint256 public currentStage = 0; //当前所处的阶段
1401     uint256 public stageStartTime; //当前阶段开始时间
1402     uint256 public stageDuration = 1 minutes; //一个阶段的持续时间
1403 
1404     mapping(address => uint256) public inviteRewards;
1405     mapping(address => uint256) public inviteUsers;
1406     IEventHub public eventHub;
1407 
1408     constructor() {}
1409 
1410     function initialize(
1411         address token_,
1412         address eventHub_,
1413         IAIERC20Factory.MintConfig memory config,
1414         uint256 freezeTime_,
1415         address _feeTo,
1416         uint256[] memory _feeAmounts
1417     ) external onlyOwner {
1418         require(!initialized, "AIERC20Distributor: already initialized");
1419         initialized = true;
1420 
1421         token = IBurnableERC20(token_);
1422         eventHub = IEventHub(eventHub_);
1423         tokensPerMint = IERC20(token).balanceOf(address(this)) / config.totalMints;
1424         startAt = config.startAt;
1425         endAt = config.endAt;
1426         feeTo = payable(_feeTo);
1427         feeAmounts = _feeAmounts;
1428         stageDuration = freezeTime_;
1429         payToken = config.payToken;
1430         payAmount = config.payAmount;
1431         payTo = payable(config.payTo);
1432     }
1433 
1434     function claim(uint128 nonce, bytes calldata signature, address payable referrer) public payable {
1435         require(tx.origin == msg.sender, "AIERC20Distributor: not allow contract");
1436         require(block.timestamp >= startAt, "AIERC20Distributor: not start");
1437         require(block.timestamp <= endAt, "AIERC20Distributor: already end");
1438         require(token.balanceOf(address(this)) >= tokensPerMint, "AIERC20Distributor: ended");
1439         require(_usedNonce[nonce] == false, "NftStakingPool: nonce already used");
1440         _usedNonce[nonce] = true;
1441 
1442         bytes32 message = keccak256(abi.encode(address(this), msg.sender, nonce));
1443         _signers.requireValidSignature(message, signature);
1444 
1445         uint256 fee = feeAmounts[currentStage];
1446         uint256 refund = msg.value - fee;
1447         if (payAmount > 0) {
1448             uint256 realPay = payAmount * 80 / 100;
1449             uint256 platformPay = payAmount - realPay;
1450             if (payToken == ETH_ADDRESS) {
1451                 require(msg.value >= payAmount + fee, "AIERC20Distributor: not enough pay");
1452                 refund -= payAmount;
1453                 (bool ok, ) = payTo.call{value: realPay}("");
1454                 require(ok, "AIERC20Distributor: pay failed");
1455                 (ok, ) = feeTo.call{value: platformPay}("");
1456                 require(ok, "AIERC20Distributor: pay plt failed");
1457             } else {
1458                 IERC20(payToken).transferFrom(msg.sender, payTo, realPay);
1459                 IERC20(payToken).transferFrom(msg.sender, feeTo, platformPay);
1460             }
1461         }
1462         if (fee > 0) {
1463             require(msg.value >= fee, "AIERC20Distributor: not enough fee");
1464             uint256 platformFee = fee;
1465             if (referrer != address(0)) {
1466                 uint256 reward = fee * ReferralRate / 10000;
1467                 platformFee -= reward;
1468                 inviteRewards[referrer] += reward;
1469                 inviteUsers[referrer]++;
1470                 (bool rok, ) = referrer.call{value: reward}("");
1471                 require(rok, "AIERC20Distributor: pay reward failed");
1472             }
1473             (bool ok, ) = feeTo.call{value: platformFee}("");
1474             require(ok, "AIERC20Distributor: pay fee failed");
1475         }
1476         if (refund > 0) {
1477             (bool rok, ) = msg.sender.call{value: refund}("");
1478             require(rok, "AIERC20Distributor: refund failed");
1479         }
1480 
1481         totalClaims++;
1482         stageClaims++;
1483 
1484         uint currentTime = block.timestamp;
1485         if (stageStartTime == 0) {
1486             stageStartTime = currentTime;
1487         } else {
1488             uint256 stageEndTime = stageStartTime + stageDuration;
1489             if (currentTime >= stageEndTime) {
1490                 if (currentStage > 0 && stageClaims < LimitFreezeCount) {
1491                     uint256 cut = (currentTime - stageStartTime) / stageDuration;
1492                     currentStage = currentStage > cut ? currentStage - cut : 0;
1493                 } 
1494                 stageClaims = 0;
1495                 stageStartTime = currentTime;
1496             }
1497 
1498             if (stageClaims >= LimitFreezeCount) {
1499                 if (currentTime < stageEndTime && currentStage < feeAmounts.length - 1) {
1500                     currentStage++;
1501                     stageStartTime = currentTime;
1502                 }
1503                 stageClaims = 0;
1504             }
1505         }
1506 
1507         token.transfer(msg.sender, tokensPerMint);
1508         totalDistributed += tokensPerMint;
1509 
1510         eventHub.onDistributorClaim(address(token), msg.sender, tokensPerMint, fee, referrer);
1511     }
1512 
1513     function burnUndistributed() public {
1514         require(block.timestamp > endAt, "AIERC20Distributor: not end");
1515         token.burn(token.balanceOf(address(this)));
1516     }
1517 
1518     function addSigner(address signer) public onlyOwner {
1519         _signers.add(signer);
1520     }
1521 
1522     function setStageDuration(uint256 duration) public onlyOwner {
1523         require(duration >= 60, "AIERC20Distributor: duration must > 60");
1524         stageDuration = duration;
1525     }
1526 
1527     function setFeeAmounts(uint256[] memory _feeAmounts) public onlyOwner {
1528         feeAmounts = _feeAmounts;
1529     }
1530 
1531     function getInvites(address user) public view returns(uint256 rewards, uint256 users) {
1532         return (inviteRewards[user], inviteUsers[user]);
1533     }
1534 
1535     function getInfoView(address user) public view returns (InfoView memory info) {
1536         return InfoView({
1537             limitFreezeCount: LimitFreezeCount,
1538             referralRate: ReferralRate,
1539             totalDistributed: totalDistributed,
1540             feeAmounts: feeAmounts,
1541             totalClaims: totalClaims,
1542             stageClaims: stageClaims,
1543             currentStage: currentStage,
1544             stageStartTime: stageStartTime,
1545             stageDuration: stageDuration,
1546             inviteRewards: inviteRewards[user],
1547             inviteUsers: inviteUsers[user]
1548         });
1549     }
1550 }