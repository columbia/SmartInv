1 // File: Base64.sol
2 
3 
4 
5 pragma solidity >=0.6.0;
6 
7 /// @title Base64
8 /// @author Brecht Devos - <brecht@loopring.org>
9 /// @notice Provides functions for encoding/decoding base64
10 library Base64 {
11     string internal constant TABLE_ENCODE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
12     bytes  internal constant TABLE_DECODE = hex"0000000000000000000000000000000000000000000000000000000000000000"
13                                             hex"00000000000000000000003e0000003f3435363738393a3b3c3d000000000000"
14                                             hex"00000102030405060708090a0b0c0d0e0f101112131415161718190000000000"
15                                             hex"001a1b1c1d1e1f202122232425262728292a2b2c2d2e2f303132330000000000";
16 
17     function encode(bytes memory data) internal pure returns (string memory) {
18         if (data.length == 0) return '';
19 
20         // load the table into memory
21         string memory table = TABLE_ENCODE;
22 
23         // multiply by 4/3 rounded up
24         uint256 encodedLen = 4 * ((data.length + 2) / 3);
25 
26         // add some extra buffer at the end required for the writing
27         string memory result = new string(encodedLen + 32);
28 
29         assembly {
30             // set the actual output length
31             mstore(result, encodedLen)
32 
33             // prepare the lookup table
34             let tablePtr := add(table, 1)
35 
36             // input ptr
37             let dataPtr := data
38             let endPtr := add(dataPtr, mload(data))
39 
40             // result ptr, jump over length
41             let resultPtr := add(result, 32)
42 
43             // run over the input, 3 bytes at a time
44             for {} lt(dataPtr, endPtr) {}
45             {
46                 // read 3 bytes
47                 dataPtr := add(dataPtr, 3)
48                 let input := mload(dataPtr)
49 
50                 // write 4 characters
51                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
52                 resultPtr := add(resultPtr, 1)
53                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
54                 resultPtr := add(resultPtr, 1)
55                 mstore8(resultPtr, mload(add(tablePtr, and(shr( 6, input), 0x3F))))
56                 resultPtr := add(resultPtr, 1)
57                 mstore8(resultPtr, mload(add(tablePtr, and(        input,  0x3F))))
58                 resultPtr := add(resultPtr, 1)
59             }
60 
61             // padding with '='
62             switch mod(mload(data), 3)
63             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
64             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
65         }
66 
67         return result;
68     }
69 
70     function decode(string memory _data) internal pure returns (bytes memory) {
71         bytes memory data = bytes(_data);
72 
73         if (data.length == 0) return new bytes(0);
74         require(data.length % 4 == 0, "invalid base64 decoder input");
75 
76         // load the table into memory
77         bytes memory table = TABLE_DECODE;
78 
79         // every 4 characters represent 3 bytes
80         uint256 decodedLen = (data.length / 4) * 3;
81 
82         // add some extra buffer at the end required for the writing
83         bytes memory result = new bytes(decodedLen + 32);
84 
85         assembly {
86             // padding with '='
87             let lastBytes := mload(add(data, mload(data)))
88             if eq(and(lastBytes, 0xFF), 0x3d) {
89                 decodedLen := sub(decodedLen, 1)
90                 if eq(and(lastBytes, 0xFFFF), 0x3d3d) {
91                     decodedLen := sub(decodedLen, 1)
92                 }
93             }
94 
95             // set the actual output length
96             mstore(result, decodedLen)
97 
98             // prepare the lookup table
99             let tablePtr := add(table, 1)
100 
101             // input ptr
102             let dataPtr := data
103             let endPtr := add(dataPtr, mload(data))
104 
105             // result ptr, jump over length
106             let resultPtr := add(result, 32)
107 
108             // run over the input, 4 characters at a time
109             for {} lt(dataPtr, endPtr) {}
110             {
111                // read 4 characters
112                dataPtr := add(dataPtr, 4)
113                let input := mload(dataPtr)
114 
115                // write 3 bytes
116                let output := add(
117                    add(
118                        shl(18, and(mload(add(tablePtr, and(shr(24, input), 0xFF))), 0xFF)),
119                        shl(12, and(mload(add(tablePtr, and(shr(16, input), 0xFF))), 0xFF))),
120                    add(
121                        shl( 6, and(mload(add(tablePtr, and(shr( 8, input), 0xFF))), 0xFF)),
122                                and(mload(add(tablePtr, and(        input , 0xFF))), 0xFF)
123                     )
124                 )
125                 mstore(resultPtr, shl(232, output))
126                 resultPtr := add(resultPtr, 3)
127             }
128         }
129 
130         return result;
131     }
132 }
133 // File: @openzeppelin/contracts/utils/math/Math.sol
134 
135 
136 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 /**
141  * @dev Standard math utilities missing in the Solidity language.
142  */
143 library Math {
144     enum Rounding {
145         Down, // Toward negative infinity
146         Up, // Toward infinity
147         Zero // Toward zero
148     }
149 
150     /**
151      * @dev Returns the largest of two numbers.
152      */
153     function max(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a > b ? a : b;
155     }
156 
157     /**
158      * @dev Returns the smallest of two numbers.
159      */
160     function min(uint256 a, uint256 b) internal pure returns (uint256) {
161         return a < b ? a : b;
162     }
163 
164     /**
165      * @dev Returns the average of two numbers. The result is rounded towards
166      * zero.
167      */
168     function average(uint256 a, uint256 b) internal pure returns (uint256) {
169         // (a + b) / 2 can overflow.
170         return (a & b) + (a ^ b) / 2;
171     }
172 
173     /**
174      * @dev Returns the ceiling of the division of two numbers.
175      *
176      * This differs from standard division with `/` in that it rounds up instead
177      * of rounding down.
178      */
179     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
180         // (a + b - 1) / b can overflow on addition, so we distribute.
181         return a == 0 ? 0 : (a - 1) / b + 1;
182     }
183 
184     /**
185      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
186      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
187      * with further edits by Uniswap Labs also under MIT license.
188      */
189     function mulDiv(
190         uint256 x,
191         uint256 y,
192         uint256 denominator
193     ) internal pure returns (uint256 result) {
194         unchecked {
195             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
196             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
197             // variables such that product = prod1 * 2^256 + prod0.
198             uint256 prod0; // Least significant 256 bits of the product
199             uint256 prod1; // Most significant 256 bits of the product
200             assembly {
201                 let mm := mulmod(x, y, not(0))
202                 prod0 := mul(x, y)
203                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
204             }
205 
206             // Handle non-overflow cases, 256 by 256 division.
207             if (prod1 == 0) {
208                 return prod0 / denominator;
209             }
210 
211             // Make sure the result is less than 2^256. Also prevents denominator == 0.
212             require(denominator > prod1);
213 
214             ///////////////////////////////////////////////
215             // 512 by 256 division.
216             ///////////////////////////////////////////////
217 
218             // Make division exact by subtracting the remainder from [prod1 prod0].
219             uint256 remainder;
220             assembly {
221                 // Compute remainder using mulmod.
222                 remainder := mulmod(x, y, denominator)
223 
224                 // Subtract 256 bit number from 512 bit number.
225                 prod1 := sub(prod1, gt(remainder, prod0))
226                 prod0 := sub(prod0, remainder)
227             }
228 
229             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
230             // See https://cs.stackexchange.com/q/138556/92363.
231 
232             // Does not overflow because the denominator cannot be zero at this stage in the function.
233             uint256 twos = denominator & (~denominator + 1);
234             assembly {
235                 // Divide denominator by twos.
236                 denominator := div(denominator, twos)
237 
238                 // Divide [prod1 prod0] by twos.
239                 prod0 := div(prod0, twos)
240 
241                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
242                 twos := add(div(sub(0, twos), twos), 1)
243             }
244 
245             // Shift in bits from prod1 into prod0.
246             prod0 |= prod1 * twos;
247 
248             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
249             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
250             // four bits. That is, denominator * inv = 1 mod 2^4.
251             uint256 inverse = (3 * denominator) ^ 2;
252 
253             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
254             // in modular arithmetic, doubling the correct bits in each step.
255             inverse *= 2 - denominator * inverse; // inverse mod 2^8
256             inverse *= 2 - denominator * inverse; // inverse mod 2^16
257             inverse *= 2 - denominator * inverse; // inverse mod 2^32
258             inverse *= 2 - denominator * inverse; // inverse mod 2^64
259             inverse *= 2 - denominator * inverse; // inverse mod 2^128
260             inverse *= 2 - denominator * inverse; // inverse mod 2^256
261 
262             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
263             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
264             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
265             // is no longer required.
266             result = prod0 * inverse;
267             return result;
268         }
269     }
270 
271     /**
272      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
273      */
274     function mulDiv(
275         uint256 x,
276         uint256 y,
277         uint256 denominator,
278         Rounding rounding
279     ) internal pure returns (uint256) {
280         uint256 result = mulDiv(x, y, denominator);
281         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
282             result += 1;
283         }
284         return result;
285     }
286 
287     /**
288      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
289      *
290      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
291      */
292     function sqrt(uint256 a) internal pure returns (uint256) {
293         if (a == 0) {
294             return 0;
295         }
296 
297         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
298         //
299         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
300         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
301         //
302         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
303         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
304         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
305         //
306         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
307         uint256 result = 1 << (log2(a) >> 1);
308 
309         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
310         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
311         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
312         // into the expected uint128 result.
313         unchecked {
314             result = (result + a / result) >> 1;
315             result = (result + a / result) >> 1;
316             result = (result + a / result) >> 1;
317             result = (result + a / result) >> 1;
318             result = (result + a / result) >> 1;
319             result = (result + a / result) >> 1;
320             result = (result + a / result) >> 1;
321             return min(result, a / result);
322         }
323     }
324 
325     /**
326      * @notice Calculates sqrt(a), following the selected rounding direction.
327      */
328     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
329         unchecked {
330             uint256 result = sqrt(a);
331             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
332         }
333     }
334 
335     /**
336      * @dev Return the log in base 2, rounded down, of a positive value.
337      * Returns 0 if given 0.
338      */
339     function log2(uint256 value) internal pure returns (uint256) {
340         uint256 result = 0;
341         unchecked {
342             if (value >> 128 > 0) {
343                 value >>= 128;
344                 result += 128;
345             }
346             if (value >> 64 > 0) {
347                 value >>= 64;
348                 result += 64;
349             }
350             if (value >> 32 > 0) {
351                 value >>= 32;
352                 result += 32;
353             }
354             if (value >> 16 > 0) {
355                 value >>= 16;
356                 result += 16;
357             }
358             if (value >> 8 > 0) {
359                 value >>= 8;
360                 result += 8;
361             }
362             if (value >> 4 > 0) {
363                 value >>= 4;
364                 result += 4;
365             }
366             if (value >> 2 > 0) {
367                 value >>= 2;
368                 result += 2;
369             }
370             if (value >> 1 > 0) {
371                 result += 1;
372             }
373         }
374         return result;
375     }
376 
377     /**
378      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
379      * Returns 0 if given 0.
380      */
381     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
382         unchecked {
383             uint256 result = log2(value);
384             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
385         }
386     }
387 
388     /**
389      * @dev Return the log in base 10, rounded down, of a positive value.
390      * Returns 0 if given 0.
391      */
392     function log10(uint256 value) internal pure returns (uint256) {
393         uint256 result = 0;
394         unchecked {
395             if (value >= 10**64) {
396                 value /= 10**64;
397                 result += 64;
398             }
399             if (value >= 10**32) {
400                 value /= 10**32;
401                 result += 32;
402             }
403             if (value >= 10**16) {
404                 value /= 10**16;
405                 result += 16;
406             }
407             if (value >= 10**8) {
408                 value /= 10**8;
409                 result += 8;
410             }
411             if (value >= 10**4) {
412                 value /= 10**4;
413                 result += 4;
414             }
415             if (value >= 10**2) {
416                 value /= 10**2;
417                 result += 2;
418             }
419             if (value >= 10**1) {
420                 result += 1;
421             }
422         }
423         return result;
424     }
425 
426     /**
427      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
428      * Returns 0 if given 0.
429      */
430     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
431         unchecked {
432             uint256 result = log10(value);
433             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
434         }
435     }
436 
437     /**
438      * @dev Return the log in base 256, rounded down, of a positive value.
439      * Returns 0 if given 0.
440      *
441      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
442      */
443     function log256(uint256 value) internal pure returns (uint256) {
444         uint256 result = 0;
445         unchecked {
446             if (value >> 128 > 0) {
447                 value >>= 128;
448                 result += 16;
449             }
450             if (value >> 64 > 0) {
451                 value >>= 64;
452                 result += 8;
453             }
454             if (value >> 32 > 0) {
455                 value >>= 32;
456                 result += 4;
457             }
458             if (value >> 16 > 0) {
459                 value >>= 16;
460                 result += 2;
461             }
462             if (value >> 8 > 0) {
463                 result += 1;
464             }
465         }
466         return result;
467     }
468 
469     /**
470      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
471      * Returns 0 if given 0.
472      */
473     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
474         unchecked {
475             uint256 result = log256(value);
476             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/utils/Strings.sol
482 
483 
484 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev String operations.
491  */
492 library Strings {
493     bytes16 private constant _SYMBOLS = "0123456789abcdef";
494     uint8 private constant _ADDRESS_LENGTH = 20;
495 
496     /**
497      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
498      */
499     function toString(uint256 value) internal pure returns (string memory) {
500         unchecked {
501             uint256 length = Math.log10(value) + 1;
502             string memory buffer = new string(length);
503             uint256 ptr;
504             /// @solidity memory-safe-assembly
505             assembly {
506                 ptr := add(buffer, add(32, length))
507             }
508             while (true) {
509                 ptr--;
510                 /// @solidity memory-safe-assembly
511                 assembly {
512                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
513                 }
514                 value /= 10;
515                 if (value == 0) break;
516             }
517             return buffer;
518         }
519     }
520 
521     /**
522      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
523      */
524     function toHexString(uint256 value) internal pure returns (string memory) {
525         unchecked {
526             return toHexString(value, Math.log256(value) + 1);
527         }
528     }
529 
530     /**
531      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
532      */
533     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
534         bytes memory buffer = new bytes(2 * length + 2);
535         buffer[0] = "0";
536         buffer[1] = "x";
537         for (uint256 i = 2 * length + 1; i > 1; --i) {
538             buffer[i] = _SYMBOLS[value & 0xf];
539             value >>= 4;
540         }
541         require(value == 0, "Strings: hex length insufficient");
542         return string(buffer);
543     }
544 
545     /**
546      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
547      */
548     function toHexString(address addr) internal pure returns (string memory) {
549         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
550     }
551 }
552 
553 // File: VerifySignature.sol
554 
555 
556 pragma solidity ^0.8.13;
557 
558 
559 /* Signature Verification
560 
561 How to Sign and Verify
562 # Signing
563 1. Create message to sign
564 2. Hash the message
565 3. Sign the hash (off chain, keep your private key secret)
566 
567 # Verify
568 1. Recreate hash from the original message
569 2. Recover signer from signature and hash
570 3. Compare recovered signer to claimed signer
571 */
572 
573 contract VerifySignature {
574     /* 1. Unlock MetaMask account
575     ethereum.enable()
576     */
577 
578     /* 2. Get message hash to sign
579     getMessageHash(
580         0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C,
581         123,
582         "coffee and donuts",
583         1
584     )
585 
586     hash = "0xcf36ac4f97dc10d91fc2cbb20d718e94a8cbfe0f82eaedc6a4aa38946fb797cd"
587     */
588     function getMessageHash(
589         address _to,
590         uint _amount,
591         string memory _message,
592         uint _nonce
593     ) public pure returns (bytes32) {
594         return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
595     }
596 
597     /* 3. Sign message hash
598     # using browser
599     account = "copy paste account of signer here"
600     ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)
601 
602     # using web3
603     web3.personal.sign(hash, web3.eth.defaultAccount, console.log)
604 
605     Signature will be different for different accounts
606     0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
607     */
608     function getEthSignedMessageHash(bytes32 _messageHash)
609         public
610         pure
611         returns (bytes32)
612     {
613         /*
614         Signature is produced by signing a keccak256 hash with the following format:
615         "\x19Ethereum Signed Message\n" + len(msg) + msg
616         */
617         return
618             keccak256(
619                 abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
620             );
621     }
622 
623     /* 4. Verify signature
624     signer = 0xB273216C05A8c0D4F0a4Dd0d7Bae1D2EfFE636dd
625     to = 0x14723A09ACff6D2A60DcdF7aA4AFf308FDDC160C
626     amount = 123
627     message = "coffee and donuts"
628     nonce = 1
629     signature =
630         0x993dab3dd91f5c6dc28e17439be475478f5635c92a56e17e82349d3fb2f166196f466c0b4e0c146f285204f0dcb13e5ae67bc33f4b888ec32dfe0a063e8f3f781b
631     */
632     function verify(
633         address _signer,
634         address _to,
635         uint _amount,
636         string memory _message,
637         uint _nonce,
638         bytes memory signature
639     ) public pure returns (bool) {
640         bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
641         bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
642 
643         return recoverSigner(ethSignedMessageHash, signature) == _signer;
644     }
645 
646     function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
647         public
648         pure
649         returns (address)
650     {
651         (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
652 
653         return ecrecover(_ethSignedMessageHash, v, r, s);
654     }
655 
656     function splitSignature(bytes memory sig)
657         public
658         pure
659         returns (
660             bytes32 r,
661             bytes32 s,
662             uint8 v
663         )
664     {
665         require(sig.length == 65, "invalid signature length");
666 
667         assembly {
668             /*
669             First 32 bytes stores the length of the signature
670 
671             add(sig, 32) = pointer of sig + 32
672             effectively, skips first 32 bytes of signature
673 
674             mload(p) loads next 32 bytes starting at the memory address p into memory
675             */
676 
677             // first 32 bytes, after the length prefix
678             r := mload(add(sig, 32))
679             // second 32 bytes
680             s := mload(add(sig, 64))
681             // final byte (first byte of the next 32 bytes)
682             v := byte(0, mload(add(sig, 96)))
683         }
684 
685         // implicitly return (r, s, v)
686     }
687 
688     function stringToEthSignedMessageHash(string memory s) public pure returns (bytes32) {
689         bytes memory ss = bytes(s);
690         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(ss.length), ss));
691     }
692 }
693 
694 // File: @openzeppelin/contracts/utils/Context.sol
695 
696 
697 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 /**
702  * @dev Provides information about the current execution context, including the
703  * sender of the transaction and its data. While these are generally available
704  * via msg.sender and msg.data, they should not be accessed in such a direct
705  * manner, since when dealing with meta-transactions the account sending and
706  * paying for execution may not be the actual sender (as far as an application
707  * is concerned).
708  *
709  * This contract is only required for intermediate, library-like contracts.
710  */
711 abstract contract Context {
712     function _msgSender() internal view virtual returns (address) {
713         return msg.sender;
714     }
715 
716     function _msgData() internal view virtual returns (bytes calldata) {
717         return msg.data;
718     }
719 }
720 
721 // File: @openzeppelin/contracts/access/Ownable.sol
722 
723 
724 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
725 
726 pragma solidity ^0.8.0;
727 
728 
729 /**
730  * @dev Contract module which provides a basic access control mechanism, where
731  * there is an account (an owner) that can be granted exclusive access to
732  * specific functions.
733  *
734  * By default, the owner account will be the one that deploys the contract. This
735  * can later be changed with {transferOwnership}.
736  *
737  * This module is used through inheritance. It will make available the modifier
738  * `onlyOwner`, which can be applied to your functions to restrict their use to
739  * the owner.
740  */
741 abstract contract Ownable is Context {
742     address private _owner;
743 
744     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
745 
746     /**
747      * @dev Initializes the contract setting the deployer as the initial owner.
748      */
749     constructor() {
750         _transferOwnership(_msgSender());
751     }
752 
753     /**
754      * @dev Throws if called by any account other than the owner.
755      */
756     modifier onlyOwner() {
757         _checkOwner();
758         _;
759     }
760 
761     /**
762      * @dev Returns the address of the current owner.
763      */
764     function owner() public view virtual returns (address) {
765         return _owner;
766     }
767 
768     /**
769      * @dev Throws if the sender is not the owner.
770      */
771     function _checkOwner() internal view virtual {
772         require(owner() == _msgSender(), "Ownable: caller is not the owner");
773     }
774 
775     /**
776      * @dev Leaves the contract without owner. It will not be possible to call
777      * `onlyOwner` functions anymore. Can only be called by the current owner.
778      *
779      * NOTE: Renouncing ownership will leave the contract without an owner,
780      * thereby removing any functionality that is only available to the owner.
781      */
782     function renounceOwnership() public virtual onlyOwner {
783         _transferOwnership(address(0));
784     }
785 
786     /**
787      * @dev Transfers ownership of the contract to a new account (`newOwner`).
788      * Can only be called by the current owner.
789      */
790     function transferOwnership(address newOwner) public virtual onlyOwner {
791         require(newOwner != address(0), "Ownable: new owner is the zero address");
792         _transferOwnership(newOwner);
793     }
794 
795     /**
796      * @dev Transfers ownership of the contract to a new account (`newOwner`).
797      * Internal function without access restriction.
798      */
799     function _transferOwnership(address newOwner) internal virtual {
800         address oldOwner = _owner;
801         _owner = newOwner;
802         emit OwnershipTransferred(oldOwner, newOwner);
803     }
804 }
805 
806 // File: @openzeppelin/contracts/utils/Address.sol
807 
808 
809 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
810 
811 pragma solidity ^0.8.1;
812 
813 /**
814  * @dev Collection of functions related to the address type
815  */
816 library Address {
817     /**
818      * @dev Returns true if `account` is a contract.
819      *
820      * [IMPORTANT]
821      * ====
822      * It is unsafe to assume that an address for which this function returns
823      * false is an externally-owned account (EOA) and not a contract.
824      *
825      * Among others, `isContract` will return false for the following
826      * types of addresses:
827      *
828      *  - an externally-owned account
829      *  - a contract in construction
830      *  - an address where a contract will be created
831      *  - an address where a contract lived, but was destroyed
832      * ====
833      *
834      * [IMPORTANT]
835      * ====
836      * You shouldn't rely on `isContract` to protect against flash loan attacks!
837      *
838      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
839      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
840      * constructor.
841      * ====
842      */
843     function isContract(address account) internal view returns (bool) {
844         // This method relies on extcodesize/address.code.length, which returns 0
845         // for contracts in construction, since the code is only stored at the end
846         // of the constructor execution.
847 
848         return account.code.length > 0;
849     }
850 
851     /**
852      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
853      * `recipient`, forwarding all available gas and reverting on errors.
854      *
855      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
856      * of certain opcodes, possibly making contracts go over the 2300 gas limit
857      * imposed by `transfer`, making them unable to receive funds via
858      * `transfer`. {sendValue} removes this limitation.
859      *
860      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
861      *
862      * IMPORTANT: because control is transferred to `recipient`, care must be
863      * taken to not create reentrancy vulnerabilities. Consider using
864      * {ReentrancyGuard} or the
865      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
866      */
867     function sendValue(address payable recipient, uint256 amount) internal {
868         require(address(this).balance >= amount, "Address: insufficient balance");
869 
870         (bool success, ) = recipient.call{value: amount}("");
871         require(success, "Address: unable to send value, recipient may have reverted");
872     }
873 
874     /**
875      * @dev Performs a Solidity function call using a low level `call`. A
876      * plain `call` is an unsafe replacement for a function call: use this
877      * function instead.
878      *
879      * If `target` reverts with a revert reason, it is bubbled up by this
880      * function (like regular Solidity function calls).
881      *
882      * Returns the raw returned data. To convert to the expected return value,
883      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
884      *
885      * Requirements:
886      *
887      * - `target` must be a contract.
888      * - calling `target` with `data` must not revert.
889      *
890      * _Available since v3.1._
891      */
892     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
893         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
894     }
895 
896     /**
897      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
898      * `errorMessage` as a fallback revert reason when `target` reverts.
899      *
900      * _Available since v3.1._
901      */
902     function functionCall(
903         address target,
904         bytes memory data,
905         string memory errorMessage
906     ) internal returns (bytes memory) {
907         return functionCallWithValue(target, data, 0, errorMessage);
908     }
909 
910     /**
911      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
912      * but also transferring `value` wei to `target`.
913      *
914      * Requirements:
915      *
916      * - the calling contract must have an ETH balance of at least `value`.
917      * - the called Solidity function must be `payable`.
918      *
919      * _Available since v3.1._
920      */
921     function functionCallWithValue(
922         address target,
923         bytes memory data,
924         uint256 value
925     ) internal returns (bytes memory) {
926         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
931      * with `errorMessage` as a fallback revert reason when `target` reverts.
932      *
933      * _Available since v3.1._
934      */
935     function functionCallWithValue(
936         address target,
937         bytes memory data,
938         uint256 value,
939         string memory errorMessage
940     ) internal returns (bytes memory) {
941         require(address(this).balance >= value, "Address: insufficient balance for call");
942         (bool success, bytes memory returndata) = target.call{value: value}(data);
943         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
944     }
945 
946     /**
947      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
948      * but performing a static call.
949      *
950      * _Available since v3.3._
951      */
952     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
953         return functionStaticCall(target, data, "Address: low-level static call failed");
954     }
955 
956     /**
957      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
958      * but performing a static call.
959      *
960      * _Available since v3.3._
961      */
962     function functionStaticCall(
963         address target,
964         bytes memory data,
965         string memory errorMessage
966     ) internal view returns (bytes memory) {
967         (bool success, bytes memory returndata) = target.staticcall(data);
968         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
969     }
970 
971     /**
972      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
973      * but performing a delegate call.
974      *
975      * _Available since v3.4._
976      */
977     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
978         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
979     }
980 
981     /**
982      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
983      * but performing a delegate call.
984      *
985      * _Available since v3.4._
986      */
987     function functionDelegateCall(
988         address target,
989         bytes memory data,
990         string memory errorMessage
991     ) internal returns (bytes memory) {
992         (bool success, bytes memory returndata) = target.delegatecall(data);
993         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
994     }
995 
996     /**
997      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
998      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
999      *
1000      * _Available since v4.8._
1001      */
1002     function verifyCallResultFromTarget(
1003         address target,
1004         bool success,
1005         bytes memory returndata,
1006         string memory errorMessage
1007     ) internal view returns (bytes memory) {
1008         if (success) {
1009             if (returndata.length == 0) {
1010                 // only check isContract if the call was successful and the return data is empty
1011                 // otherwise we already know that it was a contract
1012                 require(isContract(target), "Address: call to non-contract");
1013             }
1014             return returndata;
1015         } else {
1016             _revert(returndata, errorMessage);
1017         }
1018     }
1019 
1020     /**
1021      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
1022      * revert reason or using the provided one.
1023      *
1024      * _Available since v4.3._
1025      */
1026     function verifyCallResult(
1027         bool success,
1028         bytes memory returndata,
1029         string memory errorMessage
1030     ) internal pure returns (bytes memory) {
1031         if (success) {
1032             return returndata;
1033         } else {
1034             _revert(returndata, errorMessage);
1035         }
1036     }
1037 
1038     function _revert(bytes memory returndata, string memory errorMessage) private pure {
1039         // Look for revert reason and bubble it up if present
1040         if (returndata.length > 0) {
1041             // The easiest way to bubble the revert reason is using memory via assembly
1042             /// @solidity memory-safe-assembly
1043             assembly {
1044                 let returndata_size := mload(returndata)
1045                 revert(add(32, returndata), returndata_size)
1046             }
1047         } else {
1048             revert(errorMessage);
1049         }
1050     }
1051 }
1052 
1053 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1054 
1055 
1056 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
1057 
1058 pragma solidity ^0.8.0;
1059 
1060 /**
1061  * @title ERC721 token receiver interface
1062  * @dev Interface for any contract that wants to support safeTransfers
1063  * from ERC721 asset contracts.
1064  */
1065 interface IERC721Receiver {
1066     /**
1067      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1068      * by `operator` from `from`, this function is called.
1069      *
1070      * It must return its Solidity selector to confirm the token transfer.
1071      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1072      *
1073      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
1074      */
1075     function onERC721Received(
1076         address operator,
1077         address from,
1078         uint256 tokenId,
1079         bytes calldata data
1080     ) external returns (bytes4);
1081 }
1082 
1083 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1084 
1085 
1086 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1087 
1088 pragma solidity ^0.8.0;
1089 
1090 /**
1091  * @dev Interface of the ERC165 standard, as defined in the
1092  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1093  *
1094  * Implementers can declare support of contract interfaces, which can then be
1095  * queried by others ({ERC165Checker}).
1096  *
1097  * For an implementation, see {ERC165}.
1098  */
1099 interface IERC165 {
1100     /**
1101      * @dev Returns true if this contract implements the interface defined by
1102      * `interfaceId`. See the corresponding
1103      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1104      * to learn more about how these ids are created.
1105      *
1106      * This function call must use less than 30 000 gas.
1107      */
1108     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1109 }
1110 
1111 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1112 
1113 
1114 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1115 
1116 pragma solidity ^0.8.0;
1117 
1118 
1119 /**
1120  * @dev Implementation of the {IERC165} interface.
1121  *
1122  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1123  * for the additional interface id that will be supported. For example:
1124  *
1125  * ```solidity
1126  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1127  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1128  * }
1129  * ```
1130  *
1131  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1132  */
1133 abstract contract ERC165 is IERC165 {
1134     /**
1135      * @dev See {IERC165-supportsInterface}.
1136      */
1137     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1138         return interfaceId == type(IERC165).interfaceId;
1139     }
1140 }
1141 
1142 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1143 
1144 
1145 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 
1150 /**
1151  * @dev Required interface of an ERC721 compliant contract.
1152  */
1153 interface IERC721 is IERC165 {
1154     /**
1155      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1156      */
1157     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1158 
1159     /**
1160      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1161      */
1162     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1163 
1164     /**
1165      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1166      */
1167     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1168 
1169     /**
1170      * @dev Returns the number of tokens in ``owner``'s account.
1171      */
1172     function balanceOf(address owner) external view returns (uint256 balance);
1173 
1174     /**
1175      * @dev Returns the owner of the `tokenId` token.
1176      *
1177      * Requirements:
1178      *
1179      * - `tokenId` must exist.
1180      */
1181     function ownerOf(uint256 tokenId) external view returns (address owner);
1182 
1183     /**
1184      * @dev Safely transfers `tokenId` token from `from` to `to`.
1185      *
1186      * Requirements:
1187      *
1188      * - `from` cannot be the zero address.
1189      * - `to` cannot be the zero address.
1190      * - `tokenId` token must exist and be owned by `from`.
1191      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1192      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1193      *
1194      * Emits a {Transfer} event.
1195      */
1196     function safeTransferFrom(
1197         address from,
1198         address to,
1199         uint256 tokenId,
1200         bytes calldata data
1201     ) external;
1202 
1203     /**
1204      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1205      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1206      *
1207      * Requirements:
1208      *
1209      * - `from` cannot be the zero address.
1210      * - `to` cannot be the zero address.
1211      * - `tokenId` token must exist and be owned by `from`.
1212      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
1213      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1214      *
1215      * Emits a {Transfer} event.
1216      */
1217     function safeTransferFrom(
1218         address from,
1219         address to,
1220         uint256 tokenId
1221     ) external;
1222 
1223     /**
1224      * @dev Transfers `tokenId` token from `from` to `to`.
1225      *
1226      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
1227      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
1228      * understand this adds an external call which potentially creates a reentrancy vulnerability.
1229      *
1230      * Requirements:
1231      *
1232      * - `from` cannot be the zero address.
1233      * - `to` cannot be the zero address.
1234      * - `tokenId` token must be owned by `from`.
1235      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1236      *
1237      * Emits a {Transfer} event.
1238      */
1239     function transferFrom(
1240         address from,
1241         address to,
1242         uint256 tokenId
1243     ) external;
1244 
1245     /**
1246      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1247      * The approval is cleared when the token is transferred.
1248      *
1249      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1250      *
1251      * Requirements:
1252      *
1253      * - The caller must own the token or be an approved operator.
1254      * - `tokenId` must exist.
1255      *
1256      * Emits an {Approval} event.
1257      */
1258     function approve(address to, uint256 tokenId) external;
1259 
1260     /**
1261      * @dev Approve or remove `operator` as an operator for the caller.
1262      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1263      *
1264      * Requirements:
1265      *
1266      * - The `operator` cannot be the caller.
1267      *
1268      * Emits an {ApprovalForAll} event.
1269      */
1270     function setApprovalForAll(address operator, bool _approved) external;
1271 
1272     /**
1273      * @dev Returns the account approved for `tokenId` token.
1274      *
1275      * Requirements:
1276      *
1277      * - `tokenId` must exist.
1278      */
1279     function getApproved(uint256 tokenId) external view returns (address operator);
1280 
1281     /**
1282      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1283      *
1284      * See {setApprovalForAll}
1285      */
1286     function isApprovedForAll(address owner, address operator) external view returns (bool);
1287 }
1288 
1289 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1290 
1291 
1292 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1293 
1294 pragma solidity ^0.8.0;
1295 
1296 
1297 /**
1298  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1299  * @dev See https://eips.ethereum.org/EIPS/eip-721
1300  */
1301 interface IERC721Metadata is IERC721 {
1302     /**
1303      * @dev Returns the token collection name.
1304      */
1305     function name() external view returns (string memory);
1306 
1307     /**
1308      * @dev Returns the token collection symbol.
1309      */
1310     function symbol() external view returns (string memory);
1311 
1312     /**
1313      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1314      */
1315     function tokenURI(uint256 tokenId) external view returns (string memory);
1316 }
1317 
1318 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1319 
1320 
1321 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/ERC721.sol)
1322 
1323 pragma solidity ^0.8.0;
1324 
1325 
1326 
1327 
1328 
1329 
1330 
1331 
1332 /**
1333  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1334  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1335  * {ERC721Enumerable}.
1336  */
1337 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1338     using Address for address;
1339     using Strings for uint256;
1340 
1341     // Token name
1342     string private _name;
1343 
1344     // Token symbol
1345     string private _symbol;
1346 
1347     // Mapping from token ID to owner address
1348     mapping(uint256 => address) private _owners;
1349 
1350     // Mapping owner address to token count
1351     mapping(address => uint256) private _balances;
1352 
1353     // Mapping from token ID to approved address
1354     mapping(uint256 => address) private _tokenApprovals;
1355 
1356     // Mapping from owner to operator approvals
1357     mapping(address => mapping(address => bool)) private _operatorApprovals;
1358 
1359     /**
1360      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1361      */
1362     constructor(string memory name_, string memory symbol_) {
1363         _name = name_;
1364         _symbol = symbol_;
1365     }
1366 
1367     /**
1368      * @dev See {IERC165-supportsInterface}.
1369      */
1370     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1371         return
1372             interfaceId == type(IERC721).interfaceId ||
1373             interfaceId == type(IERC721Metadata).interfaceId ||
1374             super.supportsInterface(interfaceId);
1375     }
1376 
1377     /**
1378      * @dev See {IERC721-balanceOf}.
1379      */
1380     function balanceOf(address owner) public view virtual override returns (uint256) {
1381         require(owner != address(0), "ERC721: address zero is not a valid owner");
1382         return _balances[owner];
1383     }
1384 
1385     /**
1386      * @dev See {IERC721-ownerOf}.
1387      */
1388     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1389         address owner = _ownerOf(tokenId);
1390         require(owner != address(0), "ERC721: invalid token ID");
1391         return owner;
1392     }
1393 
1394     /**
1395      * @dev See {IERC721Metadata-name}.
1396      */
1397     function name() public view virtual override returns (string memory) {
1398         return _name;
1399     }
1400 
1401     /**
1402      * @dev See {IERC721Metadata-symbol}.
1403      */
1404     function symbol() public view virtual override returns (string memory) {
1405         return _symbol;
1406     }
1407 
1408     /**
1409      * @dev See {IERC721Metadata-tokenURI}.
1410      */
1411     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1412         _requireMinted(tokenId);
1413 
1414         string memory baseURI = _baseURI();
1415         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1416     }
1417 
1418     /**
1419      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1420      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1421      * by default, can be overridden in child contracts.
1422      */
1423     function _baseURI() internal view virtual returns (string memory) {
1424         return "";
1425     }
1426 
1427     /**
1428      * @dev See {IERC721-approve}.
1429      */
1430     function approve(address to, uint256 tokenId) public virtual override {
1431         address owner = ERC721.ownerOf(tokenId);
1432         require(to != owner, "ERC721: approval to current owner");
1433 
1434         require(
1435             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1436             "ERC721: approve caller is not token owner or approved for all"
1437         );
1438 
1439         _approve(to, tokenId);
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-getApproved}.
1444      */
1445     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1446         _requireMinted(tokenId);
1447 
1448         return _tokenApprovals[tokenId];
1449     }
1450 
1451     /**
1452      * @dev See {IERC721-setApprovalForAll}.
1453      */
1454     function setApprovalForAll(address operator, bool approved) public virtual override {
1455         _setApprovalForAll(_msgSender(), operator, approved);
1456     }
1457 
1458     /**
1459      * @dev See {IERC721-isApprovedForAll}.
1460      */
1461     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1462         return _operatorApprovals[owner][operator];
1463     }
1464 
1465     /**
1466      * @dev See {IERC721-transferFrom}.
1467      */
1468     function transferFrom(
1469         address from,
1470         address to,
1471         uint256 tokenId
1472     ) public virtual override {
1473         //solhint-disable-next-line max-line-length
1474         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1475 
1476         _transfer(from, to, tokenId);
1477     }
1478 
1479     /**
1480      * @dev See {IERC721-safeTransferFrom}.
1481      */
1482     function safeTransferFrom(
1483         address from,
1484         address to,
1485         uint256 tokenId
1486     ) public virtual override {
1487         safeTransferFrom(from, to, tokenId, "");
1488     }
1489 
1490     /**
1491      * @dev See {IERC721-safeTransferFrom}.
1492      */
1493     function safeTransferFrom(
1494         address from,
1495         address to,
1496         uint256 tokenId,
1497         bytes memory data
1498     ) public virtual override {
1499         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: caller is not token owner or approved");
1500         _safeTransfer(from, to, tokenId, data);
1501     }
1502 
1503     /**
1504      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1505      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1506      *
1507      * `data` is additional data, it has no specified format and it is sent in call to `to`.
1508      *
1509      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1510      * implement alternative mechanisms to perform token transfer, such as signature-based.
1511      *
1512      * Requirements:
1513      *
1514      * - `from` cannot be the zero address.
1515      * - `to` cannot be the zero address.
1516      * - `tokenId` token must exist and be owned by `from`.
1517      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1518      *
1519      * Emits a {Transfer} event.
1520      */
1521     function _safeTransfer(
1522         address from,
1523         address to,
1524         uint256 tokenId,
1525         bytes memory data
1526     ) internal virtual {
1527         _transfer(from, to, tokenId);
1528         require(_checkOnERC721Received(from, to, tokenId, data), "ERC721: transfer to non ERC721Receiver implementer");
1529     }
1530 
1531     /**
1532      * @dev Returns the owner of the `tokenId`. Does NOT revert if token doesn't exist
1533      */
1534     function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
1535         return _owners[tokenId];
1536     }
1537 
1538     /**
1539      * @dev Returns whether `tokenId` exists.
1540      *
1541      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1542      *
1543      * Tokens start existing when they are minted (`_mint`),
1544      * and stop existing when they are burned (`_burn`).
1545      */
1546     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1547         return _ownerOf(tokenId) != address(0);
1548     }
1549 
1550     /**
1551      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1552      *
1553      * Requirements:
1554      *
1555      * - `tokenId` must exist.
1556      */
1557     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1558         address owner = ERC721.ownerOf(tokenId);
1559         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1560     }
1561 
1562     /**
1563      * @dev Safely mints `tokenId` and transfers it to `to`.
1564      *
1565      * Requirements:
1566      *
1567      * - `tokenId` must not exist.
1568      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1569      *
1570      * Emits a {Transfer} event.
1571      */
1572     function _safeMint(address to, uint256 tokenId) internal virtual {
1573         _safeMint(to, tokenId, "");
1574     }
1575 
1576     /**
1577      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1578      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1579      */
1580     function _safeMint(
1581         address to,
1582         uint256 tokenId,
1583         bytes memory data
1584     ) internal virtual {
1585         _mint(to, tokenId);
1586         require(
1587             _checkOnERC721Received(address(0), to, tokenId, data),
1588             "ERC721: transfer to non ERC721Receiver implementer"
1589         );
1590     }
1591 
1592     /**
1593      * @dev Mints `tokenId` and transfers it to `to`.
1594      *
1595      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1596      *
1597      * Requirements:
1598      *
1599      * - `tokenId` must not exist.
1600      * - `to` cannot be the zero address.
1601      *
1602      * Emits a {Transfer} event.
1603      */
1604     function _mint(address to, uint256 tokenId) internal virtual {
1605         require(to != address(0), "ERC721: mint to the zero address");
1606         require(!_exists(tokenId), "ERC721: token already minted");
1607 
1608         _beforeTokenTransfer(address(0), to, tokenId, 1);
1609 
1610         // Check that tokenId was not minted by `_beforeTokenTransfer` hook
1611         require(!_exists(tokenId), "ERC721: token already minted");
1612 
1613         unchecked {
1614             // Will not overflow unless all 2**256 token ids are minted to the same owner.
1615             // Given that tokens are minted one by one, it is impossible in practice that
1616             // this ever happens. Might change if we allow batch minting.
1617             // The ERC fails to describe this case.
1618             _balances[to] += 1;
1619         }
1620 
1621         _owners[tokenId] = to;
1622 
1623         emit Transfer(address(0), to, tokenId);
1624 
1625         _afterTokenTransfer(address(0), to, tokenId, 1);
1626     }
1627 
1628     /**
1629      * @dev Destroys `tokenId`.
1630      * The approval is cleared when the token is burned.
1631      * This is an internal function that does not check if the sender is authorized to operate on the token.
1632      *
1633      * Requirements:
1634      *
1635      * - `tokenId` must exist.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _burn(uint256 tokenId) internal virtual {
1640         address owner = ERC721.ownerOf(tokenId);
1641 
1642         _beforeTokenTransfer(owner, address(0), tokenId, 1);
1643 
1644         // Update ownership in case tokenId was transferred by `_beforeTokenTransfer` hook
1645         owner = ERC721.ownerOf(tokenId);
1646 
1647         // Clear approvals
1648         delete _tokenApprovals[tokenId];
1649 
1650         unchecked {
1651             // Cannot overflow, as that would require more tokens to be burned/transferred
1652             // out than the owner initially received through minting and transferring in.
1653             _balances[owner] -= 1;
1654         }
1655         delete _owners[tokenId];
1656 
1657         emit Transfer(owner, address(0), tokenId);
1658 
1659         _afterTokenTransfer(owner, address(0), tokenId, 1);
1660     }
1661 
1662     /**
1663      * @dev Transfers `tokenId` from `from` to `to`.
1664      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1665      *
1666      * Requirements:
1667      *
1668      * - `to` cannot be the zero address.
1669      * - `tokenId` token must be owned by `from`.
1670      *
1671      * Emits a {Transfer} event.
1672      */
1673     function _transfer(
1674         address from,
1675         address to,
1676         uint256 tokenId
1677     ) internal virtual {
1678         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1679         require(to != address(0), "ERC721: transfer to the zero address");
1680 
1681         _beforeTokenTransfer(from, to, tokenId, 1);
1682 
1683         // Check that tokenId was not transferred by `_beforeTokenTransfer` hook
1684         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1685 
1686         // Clear approvals from the previous owner
1687         delete _tokenApprovals[tokenId];
1688 
1689         unchecked {
1690             // `_balances[from]` cannot overflow for the same reason as described in `_burn`:
1691             // `from`'s balance is the number of token held, which is at least one before the current
1692             // transfer.
1693             // `_balances[to]` could overflow in the conditions described in `_mint`. That would require
1694             // all 2**256 token ids to be minted, which in practice is impossible.
1695             _balances[from] -= 1;
1696             _balances[to] += 1;
1697         }
1698         _owners[tokenId] = to;
1699 
1700         emit Transfer(from, to, tokenId);
1701 
1702         _afterTokenTransfer(from, to, tokenId, 1);
1703     }
1704 
1705     /**
1706      * @dev Approve `to` to operate on `tokenId`
1707      *
1708      * Emits an {Approval} event.
1709      */
1710     function _approve(address to, uint256 tokenId) internal virtual {
1711         _tokenApprovals[tokenId] = to;
1712         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1713     }
1714 
1715     /**
1716      * @dev Approve `operator` to operate on all of `owner` tokens
1717      *
1718      * Emits an {ApprovalForAll} event.
1719      */
1720     function _setApprovalForAll(
1721         address owner,
1722         address operator,
1723         bool approved
1724     ) internal virtual {
1725         require(owner != operator, "ERC721: approve to caller");
1726         _operatorApprovals[owner][operator] = approved;
1727         emit ApprovalForAll(owner, operator, approved);
1728     }
1729 
1730     /**
1731      * @dev Reverts if the `tokenId` has not been minted yet.
1732      */
1733     function _requireMinted(uint256 tokenId) internal view virtual {
1734         require(_exists(tokenId), "ERC721: invalid token ID");
1735     }
1736 
1737     /**
1738      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1739      * The call is not executed if the target address is not a contract.
1740      *
1741      * @param from address representing the previous owner of the given token ID
1742      * @param to target address that will receive the tokens
1743      * @param tokenId uint256 ID of the token to be transferred
1744      * @param data bytes optional data to send along with the call
1745      * @return bool whether the call correctly returned the expected magic value
1746      */
1747     function _checkOnERC721Received(
1748         address from,
1749         address to,
1750         uint256 tokenId,
1751         bytes memory data
1752     ) private returns (bool) {
1753         if (to.isContract()) {
1754             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, data) returns (bytes4 retval) {
1755                 return retval == IERC721Receiver.onERC721Received.selector;
1756             } catch (bytes memory reason) {
1757                 if (reason.length == 0) {
1758                     revert("ERC721: transfer to non ERC721Receiver implementer");
1759                 } else {
1760                     /// @solidity memory-safe-assembly
1761                     assembly {
1762                         revert(add(32, reason), mload(reason))
1763                     }
1764                 }
1765             }
1766         } else {
1767             return true;
1768         }
1769     }
1770 
1771     /**
1772      * @dev Hook that is called before any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1773      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1774      *
1775      * Calling conditions:
1776      *
1777      * - When `from` and `to` are both non-zero, ``from``'s tokens will be transferred to `to`.
1778      * - When `from` is zero, the tokens will be minted for `to`.
1779      * - When `to` is zero, ``from``'s tokens will be burned.
1780      * - `from` and `to` are never both zero.
1781      * - `batchSize` is non-zero.
1782      *
1783      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1784      */
1785     function _beforeTokenTransfer(
1786         address from,
1787         address to,
1788         uint256, /* firstTokenId */
1789         uint256 batchSize
1790     ) internal virtual {
1791         if (batchSize > 1) {
1792             if (from != address(0)) {
1793                 _balances[from] -= batchSize;
1794             }
1795             if (to != address(0)) {
1796                 _balances[to] += batchSize;
1797             }
1798         }
1799     }
1800 
1801     /**
1802      * @dev Hook that is called after any token transfer. This includes minting and burning. If {ERC721Consecutive} is
1803      * used, the hook may be called as part of a consecutive (batch) mint, as indicated by `batchSize` greater than 1.
1804      *
1805      * Calling conditions:
1806      *
1807      * - When `from` and `to` are both non-zero, ``from``'s tokens were transferred to `to`.
1808      * - When `from` is zero, the tokens were minted for `to`.
1809      * - When `to` is zero, ``from``'s tokens were burned.
1810      * - `from` and `to` are never both zero.
1811      * - `batchSize` is non-zero.
1812      *
1813      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1814      */
1815     function _afterTokenTransfer(
1816         address from,
1817         address to,
1818         uint256 firstTokenId,
1819         uint256 batchSize
1820     ) internal virtual {}
1821 }
1822 
1823 // File: PlzBro.sol
1824 
1825 
1826 pragma solidity ^0.8.13;
1827 
1828 
1829 
1830 
1831 
1832 
1833 interface HACKERHAIKU {
1834     function balanceOf(address owner) external view returns (uint256 balance);
1835 }
1836 
1837 contract PlzBro is ERC721, Ownable {
1838     using Strings for uint256;
1839 
1840     HACKERHAIKU hackerhaiku;
1841 
1842     // token metadata
1843     string public constant imagePartOne = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 200 200"><style>.h{font-family: Courier New;font-size:20px;fill:#05f228;}</style><rect x="0" y="0" width="200" height="200" fill="black"/><text x="10" y="25" class="h">';
1844     string public constant imagePartTwo = '</text><text x="10" y="45" class="h">';
1845     string public constant imagePartThree = '</text><text x="10" y="65" class="h">';
1846     string public constant imagePartFour = '</text><text x="10" y="85" class="h">';
1847     string public constant imagePartFive = '</text><text x="10" y="105" class="h">';
1848     string public constant imagePartSix = '</text><text x="10" y="125" class="h">';
1849     string public constant imagePartSeven = '</text><text x="10" y="145" class="h">';
1850     string public constant imagePartEight = '</text><text x="10" y="165" class="h">';
1851     string public constant imagePartNine = '</text><text x="10" y="185" class="h">';
1852     string public constant imagePartTen = '</text><rect x="3%" y="3%" width="94%" height="94%" fill="none" stroke="#05f228" stroke-width=".5%"/></svg>';
1853     string public constant description = 'Poems generated from SMS received during the minting of Hacker Haiku.';
1854     string public constant tokenName = 'Plz Bro';
1855     string public license = 'CC BY-NC 4.0';
1856     string public externalUrl = 'https://hackerhaiku.com/plzbro';
1857 
1858     VerifySignature public verifySignature = new VerifySignature();
1859 
1860     struct Poem {
1861         string line1;
1862         string line2;
1863         string line3;
1864         string line4;
1865         string line5;
1866         string line6;
1867         string line7;
1868         string line8;
1869         string line9;
1870     }
1871 
1872     uint public Counter;
1873     address signer;
1874 
1875     mapping(string => uint) public poems;
1876     mapping(uint => Poem) public tokens;
1877 
1878     constructor(address _signer, address hackerHaikuContract) ERC721("PlzBro", "PBR") {
1879         signer = _signer;
1880         hackerhaiku = HACKERHAIKU(hackerHaikuContract);
1881     }
1882 
1883     function mint(
1884         Poem memory _poem,
1885         bytes32 _ethSignedMessageHash, 
1886         bytes memory _signature,
1887         bytes32 magic
1888         ) public payable {
1889             string memory flatPoem = string(abi.encodePacked(
1890                 _poem.line1,
1891                 _poem.line2,
1892                 _poem.line3,
1893                 _poem.line4,
1894                 _poem.line5,
1895                 _poem.line6,
1896                 _poem.line7,
1897                 _poem.line8,
1898                 _poem.line9                
1899                 ));
1900             require(poems[flatPoem] == 0, "Poem already claimed.");
1901             require(Counter < 512, "All out.");
1902             require(verifySignature.recoverSigner(_ethSignedMessageHash, _signature) == signer, "Invalid signature.");
1903             require(verifySignature.stringToEthSignedMessageHash(flatPoem) == _ethSignedMessageHash, "Hash and poem don't match.");
1904             require(magic == keccak256(abi.encodePacked(msg.sender)), "Magic?");
1905             if (hackerhaiku.balanceOf(msg.sender) > 0) {
1906                 require(msg.value >= 0.0125 ether, "Not enough ETH.");
1907             } else {
1908                 require(msg.value >= 0.025 ether, "Not enough ETH.");
1909             }
1910 
1911             Poem memory poem = Poem(
1912                 _poem.line1,
1913                 _poem.line2,
1914                 _poem.line3,
1915                 _poem.line4,
1916                 _poem.line5,
1917                 _poem.line6,
1918                 _poem.line7,
1919                 _poem.line8,
1920                 _poem.line9  
1921                 );
1922 
1923             Counter++;
1924             poems[flatPoem] = Counter;
1925             tokens[Counter] = poem;
1926             payable(owner()).transfer(msg.value);
1927             _safeMint(msg.sender, Counter);  
1928     }
1929 
1930     function updateSigner(address _newSigner) external onlyOwner {
1931         signer = _newSigner;
1932     }
1933 
1934     function updateExternalUrl(string memory _newExternalUrl) external onlyOwner {
1935         externalUrl = _newExternalUrl;
1936     }
1937 
1938     function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1939         require(_exists(_tokenId), "Token doesn't exist.");
1940         
1941         bytes memory encodedImage = abi.encodePacked('"image": "data:image/svg+xml;base64,', Base64.encode(getSVG(_tokenId)), '",');
1942         bytes memory encodedHTML = abi.encodePacked('"animation_url": "data:text/html;base64,', Base64.encode(getHTML(_tokenId)), '",');
1943 
1944         string memory json = Base64.encode(
1945           abi.encodePacked(
1946             '{"name": "', tokenName, ' #', Strings.toString(_tokenId), '",',
1947             '"description": "', description, '",',
1948             encodedImage,
1949             encodedHTML,
1950             '"license": "', license, '",'
1951             '"external_url": "', externalUrl,
1952             '"}'
1953           )
1954         );
1955         return string(abi.encodePacked('data:application/json;base64,', json));
1956     }
1957 
1958     function getSVG(uint256 _tokenId) public view returns (bytes memory) {
1959         require(_exists(_tokenId), "Token doesn't exist.");
1960 
1961         Poem memory poem = tokens[_tokenId];
1962 
1963         bytes memory part1 = abi.encodePacked(
1964             imagePartOne, 
1965             poem.line1,
1966             imagePartTwo,
1967             poem.line2,
1968             imagePartThree,
1969             poem.line3
1970             );
1971 
1972         bytes memory part2 = abi.encodePacked(
1973             imagePartFour,
1974             poem.line4,
1975             imagePartFive,
1976             poem.line5,
1977             imagePartSix,
1978             poem.line6
1979             );
1980 
1981         bytes memory part3 = abi.encodePacked(
1982             imagePartSeven,
1983             poem.line7,
1984             imagePartEight,
1985             poem.line8,
1986             imagePartNine,
1987             poem.line9,
1988             imagePartTen
1989             );
1990         
1991         return abi.encodePacked(
1992             part1,
1993             part2,
1994             part3
1995             );
1996     }
1997 
1998     function getHTML(uint256 _tokenId) public view returns (bytes memory) {
1999         require(_exists(_tokenId), "Token doesn't exist.");
2000 
2001         return abi.encodePacked(
2002             '<!DOCTYPE html><html><head><style>*{margin:0;padding:0}</style></head><body>',
2003             string(getSVG(_tokenId)),
2004             '</body></html>'
2005         );
2006     }
2007 
2008     receive() external payable { }
2009 
2010     function withdraw() external onlyOwner {
2011         payable(msg.sender).transfer(address(this).balance);
2012     }
2013 }