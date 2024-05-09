1 // SPDX-License-Identifier: MIT
2 
3 // War by ATS. Written by NiftyLabs (https://niftylabs.dev/).
4 
5 //,,,,,,******,*************////*********,,,,*************//**///////((((((((((((((((((((((((((((((((#
6 //***********,,,,,************///*************************//////((((((((((########################%#%#
7 //,,,,,,,,,,,,,,,,,,,,,,**************************,******///((((((((((((((####((((###############%%%%%
8 //,,,,,,,,,,,,,,,,,,,,,,,/*************,**********************//(((((((((((((((((((((############%%%%%
9 //,,,,,,,,,,,,,,,,,,,,(##.#**************,,,,,,,,,,,*,,,*********/////((((((((((((((############%%%%%%
10 //.,,,,,,,,,,,,,,,,,,,,,(#,#,#(/*********,,,,,#%%%%%%%%%(,,**********////(((((((((((##################
11 //..,,,,,,,,,,,,,,,,,,,,, */,.####********,,/%#%%%%%%%%%%%***********///((//(((((((###############%%%%
12 //.....,,,,,,,,,,,,,,,,,,,*/.#(*/#(##,******%%%%%%%%%%%%%%%%***/////(((/////////(((############%#%%%%%
13 //........,,,,,,,,,,,,,,,,,,,,,#(##(###******%%%%%%%%%%%%%%#*******//////////////((((##########%%%%%%%
14 //..........,,,,,,,,,,,,,,,,,,,,,,,  ######*#%%%%%%%%%%%%%%%%%%%%/*****////////////((((##########%%%%%
15 //............,,,,,,,,,,,,,,,,,,,,,,##########%%%%%%%%%%%%%%%%%%%%%%%(***/////(((((((((((##########%%%
16 //.............,,,,,,,,,,,,,,,,,###############%%%%%%%%%%%%%%%%%%%%%%%&%////////((((((((((((((#####%%%
17 //..............,,,,,,,,,,,,,,,,,,,*##########%#%%%%%%%%%%%%%%%%%%%%%%%&&*/////////////////((((#######
18 //................,,,,,,,,,,,,,,,,,#############%##%%%%%%%%%%%%%%%%%%%%&&&#*////////(((((((((((((((###
19 //.................,,,,,,,,,,,,,,,############%%%%%%%%%%%%%%%%%%%%%%%%%&&&&&(//////////(((((/((((###((
20 //....................,,,,,,,,,,*#############%%%%%%%%%%%%#%%%%%%%%%%%&&&&&&&&*////////(((((((((#####(
21 //.........................,,,,,(#############%%%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&*/////////(((((((((((((
22 //........................,,,,,(((##############%%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&%/(((((((((((#######(((
23 //........................,,,,(((#######,*#######%%%%%%%%%%%%%%%%%%%**%&&&&&&&&&&///(((((((((((######(
24 //..........................(((((#####(,,(#####%%%%%%%%%%%%%%%%%%%%%%***%&&&&&&&&&%///(((((((((((###(#
25 //........................,((((((#####*,,,########%%%%%%%%%%%%%%%%%(%%%**%&&&&&&&&&#///(((((((((((####
26 //........................*(((((((###/,,,,,#####%%%#%%%%%%%%%%%%%%%%%%&&%/&&&&&&&&&&%//(((((((((((((##
27 //........................((((((((##*,,,,,,,#######%%%%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&///((((((((((#(((
28 //.......................,/(((((((#,,,,,,,,,######%%%%%%%%%%%%%%%%%%#**(/**/&&&&&&&&&///((((//((((((((
29 //.......................///(((((*.,,,,,,,,,,####%%#%%%%%%%%%%%%%%%%%***/***/&&&&&&&&////((((((((((#((
30 //.......................///((((..,,,,,,,,,,*#####%%%%%%%%%%%%%%%%%&&**///////&&&&&&#//(((((((((((###(
31 //.......................///((/..,,,,,,,,,,,#####%%%%%%%%%%%%%%%%%%%&%*///////&&&&&&%(((((((((((((####
32 //.......................///((.,,,,,,,,,,,,####%%%%%%%%%%%%%%%%%%%%%&&#//////&&&&&&&&((((((((((((#####
33 //......................,///((.,,,,,,,,,,,#####%%%%%%%%%%%%%%%%%%%%&&&&/////&&/&&&&&&(((((((((((######
34 //......................////(*(/,,,,,,,,,/#####%%%%%%%%#***%%%%%%%%&&&&%///////&&&&&&((((((((#########
35 //.......................////((,,,,,,,,,,#######%%%%%%*****%%%%%%&%%&&&%/////((&&&&&&&(((##(##########
36 //.......................*,.,..,,,,,,,,,,######%%%%%%*******%%%%%%&&&&&///(((((&&&&&&%(###############
37 //.. .................././.*../,,,,,,,,,,###%%%%%%%%*********%&&&&&&&&&//((((((%(&&&&(################
38 //....................*/*,,/(((((((#,,,,,/##%%%%%%%%******////&&&&&&&&&/((((((((&#&###################
39 //....................,,,,,,,((((((#,,,,,*##%%%%%%%%%***//////%&&&&&&&&%(((((((######################%
40 //...................../**/*((((((####*****%%%%%%%%%%(////////%&&&&&&&&#(((((####################%%%%%
41 //..................,,,,,,,,,,,,,*#####*****%%%%%%%%%%////////&&&&&&&&&((((######################%%%%%
42 //................,,,,,,,,,,,,,*************/%%%%%%%%&/////((((&&&&&&&&#(######################%%%%%%%
43 //..........,.,,,,,,,,,,,,,******/*/**/*//**(#%%%%%&%&/%((((((#%&&&&&&&##%##(################%%%%%%%%%
44 //*//*////,*/((/#,(/**/(#**(##(%#%%%%%%%%%%&%&&&&&&&&&&&&&&%&&&&&@&&@@@&@&&&&@&@&@&&@@&&&&&&%&%%%%&%&%
45 //(##############%%%%%%%#%%%%%%%&%&&&&&&&&&&&&&&&&&@&&&@&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
46 //%%%%%%%%%%%%%%%%%%%&&&&&&&&&&&&&&&&&&&&&&&@&&&@@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
47 //%%%%%%%%%%%&&%&&&&&&&&&&&&&&&&&&&&&&&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
48 //&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&@&@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
49 
50 // File: @openzeppelin/contracts/utils/math/Math.sol
51 
52 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
53 
54 pragma solidity ^0.8.0;
55 
56 /**
57  * @dev Standard math utilities missing in the Solidity language.
58  */
59 library Math {
60     enum Rounding {
61         Down, // Toward negative infinity
62         Up, // Toward infinity
63         Zero // Toward zero
64     }
65 
66     /**
67      * @dev Returns the largest of two numbers.
68      */
69     function max(uint256 a, uint256 b) internal pure returns (uint256) {
70         return a > b ? a : b;
71     }
72 
73     /**
74      * @dev Returns the smallest of two numbers.
75      */
76     function min(uint256 a, uint256 b) internal pure returns (uint256) {
77         return a < b ? a : b;
78     }
79 
80     /**
81      * @dev Returns the average of two numbers. The result is rounded towards
82      * zero.
83      */
84     function average(uint256 a, uint256 b) internal pure returns (uint256) {
85         // (a + b) / 2 can overflow.
86         return (a & b) + (a ^ b) / 2;
87     }
88 
89     /**
90      * @dev Returns the ceiling of the division of two numbers.
91      *
92      * This differs from standard division with `/` in that it rounds up instead
93      * of rounding down.
94      */
95     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
96         // (a + b - 1) / b can overflow on addition, so we distribute.
97         return a == 0 ? 0 : (a - 1) / b + 1;
98     }
99 
100     /**
101      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
102      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
103      * with further edits by Uniswap Labs also under MIT license.
104      */
105     function mulDiv(
106         uint256 x,
107         uint256 y,
108         uint256 denominator
109     ) internal pure returns (uint256 result) {
110         unchecked {
111             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
112             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
113             // variables such that product = prod1 * 2^256 + prod0.
114             uint256 prod0; // Least significant 256 bits of the product
115             uint256 prod1; // Most significant 256 bits of the product
116             assembly {
117                 let mm := mulmod(x, y, not(0))
118                 prod0 := mul(x, y)
119                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
120             }
121 
122             // Handle non-overflow cases, 256 by 256 division.
123             if (prod1 == 0) {
124                 return prod0 / denominator;
125             }
126 
127             // Make sure the result is less than 2^256. Also prevents denominator == 0.
128             require(denominator > prod1);
129 
130             ///////////////////////////////////////////////
131             // 512 by 256 division.
132             ///////////////////////////////////////////////
133 
134             // Make division exact by subtracting the remainder from [prod1 prod0].
135             uint256 remainder;
136             assembly {
137                 // Compute remainder using mulmod.
138                 remainder := mulmod(x, y, denominator)
139 
140                 // Subtract 256 bit number from 512 bit number.
141                 prod1 := sub(prod1, gt(remainder, prod0))
142                 prod0 := sub(prod0, remainder)
143             }
144 
145             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
146             // See https://cs.stackexchange.com/q/138556/92363.
147 
148             // Does not overflow because the denominator cannot be zero at this stage in the function.
149             uint256 twos = denominator & (~denominator + 1);
150             assembly {
151                 // Divide denominator by twos.
152                 denominator := div(denominator, twos)
153 
154                 // Divide [prod1 prod0] by twos.
155                 prod0 := div(prod0, twos)
156 
157                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
158                 twos := add(div(sub(0, twos), twos), 1)
159             }
160 
161             // Shift in bits from prod1 into prod0.
162             prod0 |= prod1 * twos;
163 
164             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
165             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
166             // four bits. That is, denominator * inv = 1 mod 2^4.
167             uint256 inverse = (3 * denominator) ^ 2;
168 
169             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
170             // in modular arithmetic, doubling the correct bits in each step.
171             inverse *= 2 - denominator * inverse; // inverse mod 2^8
172             inverse *= 2 - denominator * inverse; // inverse mod 2^16
173             inverse *= 2 - denominator * inverse; // inverse mod 2^32
174             inverse *= 2 - denominator * inverse; // inverse mod 2^64
175             inverse *= 2 - denominator * inverse; // inverse mod 2^128
176             inverse *= 2 - denominator * inverse; // inverse mod 2^256
177 
178             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
179             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
180             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
181             // is no longer required.
182             result = prod0 * inverse;
183             return result;
184         }
185     }
186 
187     /**
188      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
189      */
190     function mulDiv(
191         uint256 x,
192         uint256 y,
193         uint256 denominator,
194         Rounding rounding
195     ) internal pure returns (uint256) {
196         uint256 result = mulDiv(x, y, denominator);
197         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
198             result += 1;
199         }
200         return result;
201     }
202 
203     /**
204      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
205      *
206      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
207      */
208     function sqrt(uint256 a) internal pure returns (uint256) {
209         if (a == 0) {
210             return 0;
211         }
212 
213         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
214         //
215         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
216         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
217         //
218         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
219         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
220         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
221         //
222         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
223         uint256 result = 1 << (log2(a) >> 1);
224 
225         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
226         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
227         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
228         // into the expected uint128 result.
229         unchecked {
230             result = (result + a / result) >> 1;
231             result = (result + a / result) >> 1;
232             result = (result + a / result) >> 1;
233             result = (result + a / result) >> 1;
234             result = (result + a / result) >> 1;
235             result = (result + a / result) >> 1;
236             result = (result + a / result) >> 1;
237             return min(result, a / result);
238         }
239     }
240 
241     /**
242      * @notice Calculates sqrt(a), following the selected rounding direction.
243      */
244     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
245         unchecked {
246             uint256 result = sqrt(a);
247             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
248         }
249     }
250 
251     /**
252      * @dev Return the log in base 2, rounded down, of a positive value.
253      * Returns 0 if given 0.
254      */
255     function log2(uint256 value) internal pure returns (uint256) {
256         uint256 result = 0;
257         unchecked {
258             if (value >> 128 > 0) {
259                 value >>= 128;
260                 result += 128;
261             }
262             if (value >> 64 > 0) {
263                 value >>= 64;
264                 result += 64;
265             }
266             if (value >> 32 > 0) {
267                 value >>= 32;
268                 result += 32;
269             }
270             if (value >> 16 > 0) {
271                 value >>= 16;
272                 result += 16;
273             }
274             if (value >> 8 > 0) {
275                 value >>= 8;
276                 result += 8;
277             }
278             if (value >> 4 > 0) {
279                 value >>= 4;
280                 result += 4;
281             }
282             if (value >> 2 > 0) {
283                 value >>= 2;
284                 result += 2;
285             }
286             if (value >> 1 > 0) {
287                 result += 1;
288             }
289         }
290         return result;
291     }
292 
293     /**
294      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
295      * Returns 0 if given 0.
296      */
297     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
298         unchecked {
299             uint256 result = log2(value);
300             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
301         }
302     }
303 
304     /**
305      * @dev Return the log in base 10, rounded down, of a positive value.
306      * Returns 0 if given 0.
307      */
308     function log10(uint256 value) internal pure returns (uint256) {
309         uint256 result = 0;
310         unchecked {
311             if (value >= 10**64) {
312                 value /= 10**64;
313                 result += 64;
314             }
315             if (value >= 10**32) {
316                 value /= 10**32;
317                 result += 32;
318             }
319             if (value >= 10**16) {
320                 value /= 10**16;
321                 result += 16;
322             }
323             if (value >= 10**8) {
324                 value /= 10**8;
325                 result += 8;
326             }
327             if (value >= 10**4) {
328                 value /= 10**4;
329                 result += 4;
330             }
331             if (value >= 10**2) {
332                 value /= 10**2;
333                 result += 2;
334             }
335             if (value >= 10**1) {
336                 result += 1;
337             }
338         }
339         return result;
340     }
341 
342     /**
343      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
344      * Returns 0 if given 0.
345      */
346     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
347         unchecked {
348             uint256 result = log10(value);
349             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
350         }
351     }
352 
353     /**
354      * @dev Return the log in base 256, rounded down, of a positive value.
355      * Returns 0 if given 0.
356      *
357      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
358      */
359     function log256(uint256 value) internal pure returns (uint256) {
360         uint256 result = 0;
361         unchecked {
362             if (value >> 128 > 0) {
363                 value >>= 128;
364                 result += 16;
365             }
366             if (value >> 64 > 0) {
367                 value >>= 64;
368                 result += 8;
369             }
370             if (value >> 32 > 0) {
371                 value >>= 32;
372                 result += 4;
373             }
374             if (value >> 16 > 0) {
375                 value >>= 16;
376                 result += 2;
377             }
378             if (value >> 8 > 0) {
379                 result += 1;
380             }
381         }
382         return result;
383     }
384 
385     /**
386      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
387      * Returns 0 if given 0.
388      */
389     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
390         unchecked {
391             uint256 result = log256(value);
392             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
393         }
394     }
395 }
396 
397 // File: @openzeppelin/contracts/utils/Strings.sol
398 
399 
400 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
401 
402 pragma solidity ^0.8.0;
403 
404 
405 /**
406  * @dev String operations.
407  */
408 library Strings {
409     bytes16 private constant _SYMBOLS = "0123456789abcdef";
410     uint8 private constant _ADDRESS_LENGTH = 20;
411 
412     /**
413      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
414      */
415     function toString(uint256 value) internal pure returns (string memory) {
416         unchecked {
417             uint256 length = Math.log10(value) + 1;
418             string memory buffer = new string(length);
419             uint256 ptr;
420             /// @solidity memory-safe-assembly
421             assembly {
422                 ptr := add(buffer, add(32, length))
423             }
424             while (true) {
425                 ptr--;
426                 /// @solidity memory-safe-assembly
427                 assembly {
428                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
429                 }
430                 value /= 10;
431                 if (value == 0) break;
432             }
433             return buffer;
434         }
435     }
436 
437     /**
438      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
439      */
440     function toHexString(uint256 value) internal pure returns (string memory) {
441         unchecked {
442             return toHexString(value, Math.log256(value) + 1);
443         }
444     }
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
448      */
449     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
450         bytes memory buffer = new bytes(2 * length + 2);
451         buffer[0] = "0";
452         buffer[1] = "x";
453         for (uint256 i = 2 * length + 1; i > 1; --i) {
454             buffer[i] = _SYMBOLS[value & 0xf];
455             value >>= 4;
456         }
457         require(value == 0, "Strings: hex length insufficient");
458         return string(buffer);
459     }
460 
461     /**
462      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
463      */
464     function toHexString(address addr) internal pure returns (string memory) {
465         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
466     }
467 }
468 
469 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
470 
471 
472 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
473 
474 pragma solidity ^0.8.0;
475 
476 
477 /**
478  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
479  *
480  * These functions can be used to verify that a message was signed by the holder
481  * of the private keys of a given address.
482  */
483 library ECDSA {
484     enum RecoverError {
485         NoError,
486         InvalidSignature,
487         InvalidSignatureLength,
488         InvalidSignatureS,
489         InvalidSignatureV // Deprecated in v4.8
490     }
491 
492     function _throwError(RecoverError error) private pure {
493         if (error == RecoverError.NoError) {
494             return; // no error: do nothing
495         } else if (error == RecoverError.InvalidSignature) {
496             revert("ECDSA: invalid signature");
497         } else if (error == RecoverError.InvalidSignatureLength) {
498             revert("ECDSA: invalid signature length");
499         } else if (error == RecoverError.InvalidSignatureS) {
500             revert("ECDSA: invalid signature 's' value");
501         }
502     }
503 
504     /**
505      * @dev Returns the address that signed a hashed message (`hash`) with
506      * `signature` or error string. This address can then be used for verification purposes.
507      *
508      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
509      * this function rejects them by requiring the `s` value to be in the lower
510      * half order, and the `v` value to be either 27 or 28.
511      *
512      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
513      * verification to be secure: it is possible to craft signatures that
514      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
515      * this is by receiving a hash of the original message (which may otherwise
516      * be too long), and then calling {toEthSignedMessageHash} on it.
517      *
518      * Documentation for signature generation:
519      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
520      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
521      *
522      * _Available since v4.3._
523      */
524     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
525         if (signature.length == 65) {
526             bytes32 r;
527             bytes32 s;
528             uint8 v;
529             // ecrecover takes the signature parameters, and the only way to get them
530             // currently is to use assembly.
531             /// @solidity memory-safe-assembly
532             assembly {
533                 r := mload(add(signature, 0x20))
534                 s := mload(add(signature, 0x40))
535                 v := byte(0, mload(add(signature, 0x60)))
536             }
537             return tryRecover(hash, v, r, s);
538         } else {
539             return (address(0), RecoverError.InvalidSignatureLength);
540         }
541     }
542 
543     /**
544      * @dev Returns the address that signed a hashed message (`hash`) with
545      * `signature`. This address can then be used for verification purposes.
546      *
547      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
548      * this function rejects them by requiring the `s` value to be in the lower
549      * half order, and the `v` value to be either 27 or 28.
550      *
551      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
552      * verification to be secure: it is possible to craft signatures that
553      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
554      * this is by receiving a hash of the original message (which may otherwise
555      * be too long), and then calling {toEthSignedMessageHash} on it.
556      */
557     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
558         (address recovered, RecoverError error) = tryRecover(hash, signature);
559         _throwError(error);
560         return recovered;
561     }
562 
563     /**
564      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
565      *
566      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
567      *
568      * _Available since v4.3._
569      */
570     function tryRecover(
571         bytes32 hash,
572         bytes32 r,
573         bytes32 vs
574     ) internal pure returns (address, RecoverError) {
575         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
576         uint8 v = uint8((uint256(vs) >> 255) + 27);
577         return tryRecover(hash, v, r, s);
578     }
579 
580     /**
581      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
582      *
583      * _Available since v4.2._
584      */
585     function recover(
586         bytes32 hash,
587         bytes32 r,
588         bytes32 vs
589     ) internal pure returns (address) {
590         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
591         _throwError(error);
592         return recovered;
593     }
594 
595     /**
596      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
597      * `r` and `s` signature fields separately.
598      *
599      * _Available since v4.3._
600      */
601     function tryRecover(
602         bytes32 hash,
603         uint8 v,
604         bytes32 r,
605         bytes32 s
606     ) internal pure returns (address, RecoverError) {
607         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
608         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
609         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
610         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
611         //
612         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
613         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
614         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
615         // these malleable signatures as well.
616         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
617             return (address(0), RecoverError.InvalidSignatureS);
618         }
619 
620         // If the signature is valid (and not malleable), return the signer address
621         address signer = ecrecover(hash, v, r, s);
622         if (signer == address(0)) {
623             return (address(0), RecoverError.InvalidSignature);
624         }
625 
626         return (signer, RecoverError.NoError);
627     }
628 
629     /**
630      * @dev Overload of {ECDSA-recover} that receives the `v`,
631      * `r` and `s` signature fields separately.
632      */
633     function recover(
634         bytes32 hash,
635         uint8 v,
636         bytes32 r,
637         bytes32 s
638     ) internal pure returns (address) {
639         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
640         _throwError(error);
641         return recovered;
642     }
643 
644     /**
645      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
646      * produces hash corresponding to the one signed with the
647      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
648      * JSON-RPC method as part of EIP-191.
649      *
650      * See {recover}.
651      */
652     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
653         // 32 is the length in bytes of hash,
654         // enforced by the type signature above
655         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
656     }
657 
658     /**
659      * @dev Returns an Ethereum Signed Message, created from `s`. This
660      * produces hash corresponding to the one signed with the
661      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
662      * JSON-RPC method as part of EIP-191.
663      *
664      * See {recover}.
665      */
666     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
667         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
668     }
669 
670     /**
671      * @dev Returns an Ethereum Signed Typed Data, created from a
672      * `domainSeparator` and a `structHash`. This produces hash corresponding
673      * to the one signed with the
674      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
675      * JSON-RPC method as part of EIP-712.
676      *
677      * See {recover}.
678      */
679     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
680         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
681     }
682 }
683 
684 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
685 
686 
687 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
688 
689 pragma solidity ^0.8.0;
690 
691 /**
692  * @title ERC721 token receiver interface
693  * @dev Interface for any contract that wants to support safeTransfers
694  * from ERC721 asset contracts.
695  */
696 interface IERC721Receiver {
697     /**
698      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
699      * by `operator` from `from`, this function is called.
700      *
701      * It must return its Solidity selector to confirm the token transfer.
702      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
703      *
704      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
705      */
706     function onERC721Received(
707         address operator,
708         address from,
709         uint256 tokenId,
710         bytes calldata data
711     ) external returns (bytes4);
712 }
713 
714 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
715 
716 
717 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
718 
719 pragma solidity ^0.8.0;
720 
721 /**
722  * @dev Contract module that helps prevent reentrant calls to a function.
723  *
724  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
725  * available, which can be applied to functions to make sure there are no nested
726  * (reentrant) calls to them.
727  *
728  * Note that because there is a single `nonReentrant` guard, functions marked as
729  * `nonReentrant` may not call one another. This can be worked around by making
730  * those functions `private`, and then adding `external` `nonReentrant` entry
731  * points to them.
732  *
733  * TIP: If you would like to learn more about reentrancy and alternative ways
734  * to protect against it, check out our blog post
735  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
736  */
737 abstract contract ReentrancyGuard {
738     // Booleans are more expensive than uint256 or any type that takes up a full
739     // word because each write operation emits an extra SLOAD to first read the
740     // slot's contents, replace the bits taken up by the boolean, and then write
741     // back. This is the compiler's defense against contract upgrades and
742     // pointer aliasing, and it cannot be disabled.
743 
744     // The values being non-zero value makes deployment a bit more expensive,
745     // but in exchange the refund on every call to nonReentrant will be lower in
746     // amount. Since refunds are capped to a percentage of the total
747     // transaction's gas, it is best to keep them low in cases like this one, to
748     // increase the likelihood of the full refund coming into effect.
749     uint256 private constant _NOT_ENTERED = 1;
750     uint256 private constant _ENTERED = 2;
751 
752     uint256 private _status;
753 
754     constructor() {
755         _status = _NOT_ENTERED;
756     }
757 
758     /**
759      * @dev Prevents a contract from calling itself, directly or indirectly.
760      * Calling a `nonReentrant` function from another `nonReentrant`
761      * function is not supported. It is possible to prevent this from happening
762      * by making the `nonReentrant` function external, and making it call a
763      * `private` function that does the actual work.
764      */
765     modifier nonReentrant() {
766         _nonReentrantBefore();
767         _;
768         _nonReentrantAfter();
769     }
770 
771     function _nonReentrantBefore() private {
772         // On the first call to nonReentrant, _status will be _NOT_ENTERED
773         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
774 
775         // Any calls to nonReentrant after this point will fail
776         _status = _ENTERED;
777     }
778 
779     function _nonReentrantAfter() private {
780         // By storing the original value once again, a refund is triggered (see
781         // https://eips.ethereum.org/EIPS/eip-2200)
782         _status = _NOT_ENTERED;
783     }
784 }
785 
786 // File: @openzeppelin/contracts/utils/Context.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 /**
794  * @dev Provides information about the current execution context, including the
795  * sender of the transaction and its data. While these are generally available
796  * via msg.sender and msg.data, they should not be accessed in such a direct
797  * manner, since when dealing with meta-transactions the account sending and
798  * paying for execution may not be the actual sender (as far as an application
799  * is concerned).
800  *
801  * This contract is only required for intermediate, library-like contracts.
802  */
803 abstract contract Context {
804     function _msgSender() internal view virtual returns (address) {
805         return msg.sender;
806     }
807 
808     function _msgData() internal view virtual returns (bytes calldata) {
809         return msg.data;
810     }
811 }
812 
813 // File: @openzeppelin/contracts/access/Ownable.sol
814 
815 
816 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
817 
818 pragma solidity ^0.8.0;
819 
820 
821 /**
822  * @dev Contract module which provides a basic access control mechanism, where
823  * there is an account (an owner) that can be granted exclusive access to
824  * specific functions.
825  *
826  * By default, the owner account will be the one that deploys the contract. This
827  * can later be changed with {transferOwnership}.
828  *
829  * This module is used through inheritance. It will make available the modifier
830  * `onlyOwner`, which can be applied to your functions to restrict their use to
831  * the owner.
832  */
833 abstract contract Ownable is Context {
834     address private _owner;
835 
836     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
837 
838     /**
839      * @dev Initializes the contract setting the deployer as the initial owner.
840      */
841     constructor() {
842         _transferOwnership(_msgSender());
843     }
844 
845     /**
846      * @dev Throws if called by any account other than the owner.
847      */
848     modifier onlyOwner() {
849         _checkOwner();
850         _;
851     }
852 
853     /**
854      * @dev Returns the address of the current owner.
855      */
856     function owner() public view virtual returns (address) {
857         return _owner;
858     }
859 
860     /**
861      * @dev Throws if the sender is not the owner.
862      */
863     function _checkOwner() internal view virtual {
864         require(owner() == _msgSender(), "Ownable: caller is not the owner");
865     }
866 
867     /**
868      * @dev Leaves the contract without owner. It will not be possible to call
869      * `onlyOwner` functions anymore. Can only be called by the current owner.
870      *
871      * NOTE: Renouncing ownership will leave the contract without an owner,
872      * thereby removing any functionality that is only available to the owner.
873      */
874     function renounceOwnership() public virtual onlyOwner {
875         _transferOwnership(address(0));
876     }
877 
878     /**
879      * @dev Transfers ownership of the contract to a new account (`newOwner`).
880      * Can only be called by the current owner.
881      */
882     function transferOwnership(address newOwner) public virtual onlyOwner {
883         require(newOwner != address(0), "Ownable: new owner is the zero address");
884         _transferOwnership(newOwner);
885     }
886 
887     /**
888      * @dev Transfers ownership of the contract to a new account (`newOwner`).
889      * Internal function without access restriction.
890      */
891     function _transferOwnership(address newOwner) internal virtual {
892         address oldOwner = _owner;
893         _owner = newOwner;
894         emit OwnershipTransferred(oldOwner, newOwner);
895     }
896 }
897 
898 // File: War.sol
899 
900 pragma solidity ^0.8.18;
901 
902 interface WarBonds {
903     function burnForAddress(uint256 _id, address _address) external;
904 }
905 
906 interface Rota {
907     function ownerOf(uint256 tokenId) external view returns (address);
908     function safeTransferFrom(address from,  address to, uint256 tokenId) external payable;
909     function transferFrom(address from,  address to, uint256 tokenId) external payable;
910     function burn(uint256[] memory tokenIds) external;
911     function setApprovalForAll(address operator, bool _approved) external;
912     function getApproved(uint256 tokenId) external view returns (address operator);
913     function isApprovedForAll(address owner, address operator) external view returns (bool);
914 }
915 
916 contract WarStaking is Ownable, IERC721Receiver, ReentrancyGuard {
917 
918     address public WARBONDS_CONTRACT = 0xcAcb0a5bb1f52F00a14bDA0dc85dE81392B2892B;
919     address public ROTA_CONTRACT = 0xDfB29501b42f63A947Ddc5249F185D6BcBE6986f;
920     uint256 public MAX_TYPE = 4;
921     address public SIGNER = 0x2f2A13462f6d4aF64954ee84641D265932849b64;
922 
923     uint256 public warTime = 48 hours;
924     uint256[] public burnRates = [15, 30, 45, 60, 60];
925 
926     struct TokenData {
927         uint40 time;
928         uint40 border;
929         uint8 battlesCompleted;
930         address owner;
931     }
932 
933     mapping(uint256 => TokenData) public tokenToData;
934 
935     event WarLost(uint256 tokenId, uint256 valueAtBurn);
936     event WarWon(uint256 tokenId, uint256 newValue);
937 
938     function goToWar(uint256[] calldata tokenIds, uint256[] calldata warBondIds) external nonReentrant {
939         require(tokenIds.length == warBondIds.length, "Arrays must be the same length");
940 
941         for(uint256 i = 0; i < tokenIds.length; i++)
942             _goToWar(tokenIds[i], warBondIds[i]);
943     }
944 
945     function _goToWar(uint256 tokenId, uint256 warBondId) internal {
946         TokenData storage data = tokenToData[tokenId];
947 
948         require(data.border < MAX_TYPE, "Token is already maxed out");
949 
950         Rota(ROTA_CONTRACT).safeTransferFrom(msg.sender, address(this), tokenId);
951 
952         WarBonds(WARBONDS_CONTRACT).burnForAddress(warBondId, msg.sender);
953 
954         data.time = uint40(block.timestamp);
955         data.owner = msg.sender;
956     }
957 
958     function leaveWar(uint256[] calldata tokenIds, uint256[] calldata randomNumbers, uint256[] calldata battleIndices, bytes calldata signature) external nonReentrant {
959 
960         require(tokenIds.length == randomNumbers.length, "Arrays must be the same length");
961 
962         bytes32 hash = keccak256(abi.encodePacked(msg.sender, tokenIds, randomNumbers, battleIndices));
963         require(_verifySignature(SIGNER, hash, signature), "Invalid signature");
964 
965         for(uint256 i = 0; i < tokenIds.length; i++)
966             _leaveWar(tokenIds[i], randomNumbers[i], battleIndices[i]);
967 
968     }
969 
970     function _leaveWar(uint256 tokenId, uint256 randomNumber, uint256 battleIndex) internal {
971 
972         TokenData storage data = tokenToData[tokenId];
973 
974         require(msg.sender == data.owner, "Not owner");
975         require(block.timestamp - data.time >= warTime, "Token can not leave war yet");
976         require(battleIndex == data.battlesCompleted, "Battle index does not match");
977 
978         data.time = 0;
979 
980         data.battlesCompleted += 1;
981 
982         if(diedAtWar(tokenId, randomNumber, burnRates[data.border])) {
983 
984             uint256[] memory tokenIds = new uint256[](1);
985             tokenIds[0] = tokenId;
986 
987             data.owner = address(0);
988 
989             Rota(ROTA_CONTRACT).burn(tokenIds);
990 
991             emit WarLost(tokenId, data.border);
992         
993         } else {
994 
995             Rota(ROTA_CONTRACT).transferFrom(address(this), msg.sender, tokenId); 
996 
997             data.border = data.border + 1;
998 
999             emit WarWon(tokenId, data.border);
1000         }
1001     }
1002 
1003     function _verifySignature(address _signer, bytes32 _hash, bytes calldata _signature) internal pure returns (bool) {
1004         return _signer == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
1005     }
1006 
1007     function diedAtWar(uint256 tokenId, uint256 random, uint256 burnRate) internal pure returns (bool) {
1008         uint256 randomNumber = uint256(keccak256(abi.encodePacked(tokenId, random))) % 100;
1009         return randomNumber < burnRate;
1010     }
1011 
1012     function getBorderNumber(uint256 tokenId) public view returns (uint256) {
1013         TokenData storage data = tokenToData[tokenId];
1014         return data.border;
1015     }
1016 
1017     function getNumberOfBattles(uint256 tokenId) public view returns (uint256) {
1018         TokenData storage data = tokenToData[tokenId];
1019         return data.battlesCompleted;
1020     }
1021 
1022     function getTokenDataFor(uint256[] calldata tokenIds) public view returns (uint40[] memory, uint40[] memory, uint8[] memory, address[] memory) {
1023         uint40[] memory times = new uint40[](tokenIds.length);
1024         uint40[] memory borders = new uint40[](tokenIds.length);
1025         uint8[] memory battlesCompleted = new uint8[](tokenIds.length);
1026         address[] memory owners = new address[](tokenIds.length);
1027 
1028         for(uint256 i = 0; i < tokenIds.length; i++) {
1029             TokenData memory data = tokenToData[tokenIds[i]];
1030             times[i] = data.time;
1031             borders[i] = data.border;
1032             battlesCompleted[i] = data.battlesCompleted;
1033             owners[i] = data.owner;
1034         }
1035 
1036         return (times, borders, battlesCompleted, owners);
1037     }
1038 
1039     function changeWarTime(uint256 _time) public onlyOwner {
1040         warTime = _time;
1041     }
1042 
1043     function overrideBorder(uint256[] memory tokenId, uint40 _border) public onlyOwner {
1044         require(_border <= MAX_TYPE, "Border does not exist");
1045 
1046          for(uint256 i = 0; i < tokenId.length; i++)
1047             tokenToData[tokenId[i]].border = _border;
1048          
1049     }
1050 
1051     function setBurnRates(uint256[] memory _rates) public onlyOwner {
1052         burnRates = _rates;
1053     }
1054 
1055     function setRotaContract(address _addr) public onlyOwner {
1056         ROTA_CONTRACT = _addr;
1057     }
1058 
1059     function setWarBondsContract(address _addr) public onlyOwner {
1060         WARBONDS_CONTRACT = _addr;
1061     }
1062 
1063     function setMaxWarType(uint256 _max) public onlyOwner {
1064         MAX_TYPE = _max;
1065     }
1066 
1067     function onERC721Received(
1068         address,
1069         address,
1070         uint256,
1071         bytes calldata
1072     ) external pure override returns (bytes4) {
1073         return IERC721Receiver.onERC721Received.selector;
1074     }
1075 
1076 }