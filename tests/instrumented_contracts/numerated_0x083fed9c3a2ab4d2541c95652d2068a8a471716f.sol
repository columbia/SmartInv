1 /*** Part of the SimpDAO family ***/
2                   /** Simping as a Service **/
3 
4 /** Keep an eye out for SimpDAO.io for when SimpDAO goes live. **/
5 
6 /**
7     IMPORTANT NOTICE:
8     This smart contract was written and deployed by the software engineers at 
9     https://highstack.co in a contractor capacity.
10     
11     Highstack is not responsible for any malicious use or losses arising from using 
12     or interacting with this smart contract.
13 
14     THIS CONTRACT IS PROVIDED ON AN “AS IS” BASIS. USE THIS SOFTWARE AT YOUR OWN RISK.
15     THERE IS NO WARRANTY, EXPRESSED OR IMPLIED, THAT DESCRIBED FUNCTIONALITY WILL 
16     FUNCTION AS EXPECTED OR INTENDED. PRODUCT MAY CEASE TO EXIST. NOT AN INVESTMENT, 
17     SECURITY OR A SWAP. TOKENS HAVE NO RIGHTS, USES, PURPOSE, ATTRIBUTES, 
18     FUNCTIONALITIES OR FEATURES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY
19     USES, PURPOSE OR ATTRIBUTES. TOKENS MAY HAVE NO VALUE. PRODUCT MAY CONTAIN BUGS AND
20     SERIOUS BREACHES IN THE SECURITY THAT MAY RESULT IN LOSS OF YOUR ASSETS OR THEIR 
21     IMPLIED VALUE. ALL THE CRYPTOCURRENCY TRANSFERRED TO THIS SMART CONTRACT MAY BE LOST.
22     THE CONTRACT DEVLOPERS ARE NOT RESPONSIBLE FOR ANY MONETARY LOSS, PROFIT LOSS OR ANY
23     OTHER LOSSES DUE TO USE OF DESCRIBED PRODUCT. CHANGES COULD BE MADE BEFORE AND AFTER
24     THE RELEASE OF THE PRODUCT. NO PRIOR NOTICE MAY BE GIVEN. ALL TRANSACTION ON THE 
25     BLOCKCHAIN ARE FINAL, NO REFUND, COMPENSATION OR REIMBURSEMENT POSSIBLE. YOU MAY 
26     LOOSE ALL THE CRYPTOCURRENCY USED TO INTERACT WITH THIS CONTRACT. IT IS YOUR 
27     RESPONSIBILITY TO REVIEW THE PROJECT, TEAM, TERMS & CONDITIONS BEFORE USING THE 
28     PRODUCT.
29 **/
30 
31 // SPDX-License-Identifier: MIT
32 
33 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
34 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module that helps prevent reentrant calls to a function.
40  *
41  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
42  * available, which can be applied to functions to make sure there are no nested
43  * (reentrant) calls to them.
44  *
45  * Note that because there is a single `nonReentrant` guard, functions marked as
46  * `nonReentrant` may not call one another. This can be worked around by making
47  * those functions `private`, and then adding `external` `nonReentrant` entry
48  * points to them.
49  *
50  * TIP: If you would like to learn more about reentrancy and alternative ways
51  * to protect against it, check out our blog post
52  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
53  */
54 abstract contract ReentrancyGuard {
55     // Booleans are more expensive than uint256 or any type that takes up a full
56     // word because each write operation emits an extra SLOAD to first read the
57     // slot's contents, replace the bits taken up by the boolean, and then write
58     // back. This is the compiler's defense against contract upgrades and
59     // pointer aliasing, and it cannot be disabled.
60 
61     // The values being non-zero value makes deployment a bit more expensive,
62     // but in exchange the refund on every call to nonReentrant will be lower in
63     // amount. Since refunds are capped to a percentage of the total
64     // transaction's gas, it is best to keep them low in cases like this one, to
65     // increase the likelihood of the full refund coming into effect.
66     uint256 private constant _NOT_ENTERED = 1;
67     uint256 private constant _ENTERED = 2;
68 
69     uint256 private _status;
70 
71     constructor() {
72         _status = _NOT_ENTERED;
73     }
74 
75     /**
76      * @dev Prevents a contract from calling itself, directly or indirectly.
77      * Calling a `nonReentrant` function from another `nonReentrant`
78      * function is not supported. It is possible to prevent this from happening
79      * by making the `nonReentrant` function external, and making it call a
80      * `private` function that does the actual work.
81      */
82     modifier nonReentrant() {
83         // On the first call to nonReentrant, _notEntered will be true
84         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
85 
86         // Any calls to nonReentrant after this point will fail
87         _status = _ENTERED;
88 
89         _;
90 
91         // By storing the original value once again, a refund is triggered (see
92         // https://eips.ethereum.org/EIPS/eip-2200)
93         _status = _NOT_ENTERED;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/utils/Counters.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 /**
105  * @title Counters
106  * @author Matt Condon (@shrugs)
107  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
108  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
109  *
110  * Include with `using Counters for Counters.Counter;`
111  */
112 library Counters {
113     struct Counter {
114         // This variable should never be directly accessed by users of the library: interactions must be restricted to
115         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
116         // this feature: see https://github.com/ethereum/solidity/issues/4637
117         uint256 _value; // default: 0
118     }
119 
120     function current(Counter storage counter) internal view returns (uint256) {
121         return counter._value;
122     }
123 
124     function increment(Counter storage counter) internal {
125         unchecked {
126             counter._value += 1;
127         }
128     }
129 
130     function decrement(Counter storage counter) internal {
131         uint256 value = counter._value;
132         require(value > 0, "Counter: decrement overflow");
133         unchecked {
134             counter._value = value - 1;
135         }
136     }
137 
138     function reset(Counter storage counter) internal {
139         counter._value = 0;
140     }
141 }
142 
143 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
144 
145 
146 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 // CAUTION
151 // This version of SafeMath should only be used with Solidity 0.8 or later,
152 // because it relies on the compiler's built in overflow checks.
153 
154 /**
155  * @dev Wrappers over Solidity's arithmetic operations.
156  *
157  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
158  * now has built in overflow checking.
159  */
160 library SafeMath {
161     /**
162      * @dev Returns the addition of two unsigned integers, with an overflow flag.
163      *
164      * _Available since v3.4._
165      */
166     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
167         unchecked {
168             uint256 c = a + b;
169             if (c < a) return (false, 0);
170             return (true, c);
171         }
172     }
173 
174     /**
175      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
176      *
177      * _Available since v3.4._
178      */
179     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         unchecked {
181             if (b > a) return (false, 0);
182             return (true, a - b);
183         }
184     }
185 
186     /**
187      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
188      *
189      * _Available since v3.4._
190      */
191     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
192         unchecked {
193             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194             // benefit is lost if 'b' is also tested.
195             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
196             if (a == 0) return (true, 0);
197             uint256 c = a * b;
198             if (c / a != b) return (false, 0);
199             return (true, c);
200         }
201     }
202 
203     /**
204      * @dev Returns the division of two unsigned integers, with a division by zero flag.
205      *
206      * _Available since v3.4._
207      */
208     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
209         unchecked {
210             if (b == 0) return (false, 0);
211             return (true, a / b);
212         }
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
217      *
218      * _Available since v3.4._
219      */
220     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             if (b == 0) return (false, 0);
223             return (true, a % b);
224         }
225     }
226 
227     /**
228      * @dev Returns the addition of two unsigned integers, reverting on
229      * overflow.
230      *
231      * Counterpart to Solidity's `+` operator.
232      *
233      * Requirements:
234      *
235      * - Addition cannot overflow.
236      */
237     function add(uint256 a, uint256 b) internal pure returns (uint256) {
238         return a + b;
239     }
240 
241     /**
242      * @dev Returns the subtraction of two unsigned integers, reverting on
243      * overflow (when the result is negative).
244      *
245      * Counterpart to Solidity's `-` operator.
246      *
247      * Requirements:
248      *
249      * - Subtraction cannot overflow.
250      */
251     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
252         return a - b;
253     }
254 
255     /**
256      * @dev Returns the multiplication of two unsigned integers, reverting on
257      * overflow.
258      *
259      * Counterpart to Solidity's `*` operator.
260      *
261      * Requirements:
262      *
263      * - Multiplication cannot overflow.
264      */
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a * b;
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers, reverting on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator.
274      *
275      * Requirements:
276      *
277      * - The divisor cannot be zero.
278      */
279     function div(uint256 a, uint256 b) internal pure returns (uint256) {
280         return a / b;
281     }
282 
283     /**
284      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
285      * reverting when dividing by zero.
286      *
287      * Counterpart to Solidity's `%` operator. This function uses a `revert`
288      * opcode (which leaves remaining gas untouched) while Solidity uses an
289      * invalid opcode to revert (consuming all remaining gas).
290      *
291      * Requirements:
292      *
293      * - The divisor cannot be zero.
294      */
295     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
296         return a % b;
297     }
298 
299     /**
300      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
301      * overflow (when the result is negative).
302      *
303      * CAUTION: This function is deprecated because it requires allocating memory for the error
304      * message unnecessarily. For custom revert reasons use {trySub}.
305      *
306      * Counterpart to Solidity's `-` operator.
307      *
308      * Requirements:
309      *
310      * - Subtraction cannot overflow.
311      */
312     function sub(
313         uint256 a,
314         uint256 b,
315         string memory errorMessage
316     ) internal pure returns (uint256) {
317         unchecked {
318             require(b <= a, errorMessage);
319             return a - b;
320         }
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function div(
336         uint256 a,
337         uint256 b,
338         string memory errorMessage
339     ) internal pure returns (uint256) {
340         unchecked {
341             require(b > 0, errorMessage);
342             return a / b;
343         }
344     }
345 
346     /**
347      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
348      * reverting with custom message when dividing by zero.
349      *
350      * CAUTION: This function is deprecated because it requires allocating memory for the error
351      * message unnecessarily. For custom revert reasons use {tryMod}.
352      *
353      * Counterpart to Solidity's `%` operator. This function uses a `revert`
354      * opcode (which leaves remaining gas untouched) while Solidity uses an
355      * invalid opcode to revert (consuming all remaining gas).
356      *
357      * Requirements:
358      *
359      * - The divisor cannot be zero.
360      */
361     function mod(
362         uint256 a,
363         uint256 b,
364         string memory errorMessage
365     ) internal pure returns (uint256) {
366         unchecked {
367             require(b > 0, errorMessage);
368             return a % b;
369         }
370     }
371 }
372 
373 // File: @openzeppelin/contracts/utils/Strings.sol
374 
375 
376 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
377 
378 pragma solidity ^0.8.0;
379 
380 /**
381  * @dev String operations.
382  */
383 library Strings {
384     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
385 
386     /**
387      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
388      */
389     function toString(uint256 value) internal pure returns (string memory) {
390         // Inspired by OraclizeAPI's implementation - MIT licence
391         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
392 
393         if (value == 0) {
394             return "0";
395         }
396         uint256 temp = value;
397         uint256 digits;
398         while (temp != 0) {
399             digits++;
400             temp /= 10;
401         }
402         bytes memory buffer = new bytes(digits);
403         while (value != 0) {
404             digits -= 1;
405             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
406             value /= 10;
407         }
408         return string(buffer);
409     }
410 
411     /**
412      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
413      */
414     function toHexString(uint256 value) internal pure returns (string memory) {
415         if (value == 0) {
416             return "0x00";
417         }
418         uint256 temp = value;
419         uint256 length = 0;
420         while (temp != 0) {
421             length++;
422             temp >>= 8;
423         }
424         return toHexString(value, length);
425     }
426 
427     /**
428      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
429      */
430     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
431         bytes memory buffer = new bytes(2 * length + 2);
432         buffer[0] = "0";
433         buffer[1] = "x";
434         for (uint256 i = 2 * length + 1; i > 1; --i) {
435             buffer[i] = _HEX_SYMBOLS[value & 0xf];
436             value >>= 4;
437         }
438         require(value == 0, "Strings: hex length insufficient");
439         return string(buffer);
440     }
441 }
442 
443 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
444 
445 
446 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
447 
448 pragma solidity ^0.8.0;
449 
450 
451 /**
452  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
453  *
454  * These functions can be used to verify that a message was signed by the holder
455  * of the private keys of a given address.
456  */
457 library ECDSA {
458     enum RecoverError {
459         NoError,
460         InvalidSignature,
461         InvalidSignatureLength,
462         InvalidSignatureS,
463         InvalidSignatureV
464     }
465 
466     function _throwError(RecoverError error) private pure {
467         if (error == RecoverError.NoError) {
468             return; // no error: do nothing
469         } else if (error == RecoverError.InvalidSignature) {
470             revert("ECDSA: invalid signature");
471         } else if (error == RecoverError.InvalidSignatureLength) {
472             revert("ECDSA: invalid signature length");
473         } else if (error == RecoverError.InvalidSignatureS) {
474             revert("ECDSA: invalid signature 's' value");
475         } else if (error == RecoverError.InvalidSignatureV) {
476             revert("ECDSA: invalid signature 'v' value");
477         }
478     }
479 
480     /**
481      * @dev Returns the address that signed a hashed message (`hash`) with
482      * `signature` or error string. This address can then be used for verification purposes.
483      *
484      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
485      * this function rejects them by requiring the `s` value to be in the lower
486      * half order, and the `v` value to be either 27 or 28.
487      *
488      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
489      * verification to be secure: it is possible to craft signatures that
490      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
491      * this is by receiving a hash of the original message (which may otherwise
492      * be too long), and then calling {toEthSignedMessageHash} on it.
493      *
494      * Documentation for signature generation:
495      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
496      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
497      *
498      * _Available since v4.3._
499      */
500     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
501         // Check the signature length
502         // - case 65: r,s,v signature (standard)
503         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
504         if (signature.length == 65) {
505             bytes32 r;
506             bytes32 s;
507             uint8 v;
508             // ecrecover takes the signature parameters, and the only way to get them
509             // currently is to use assembly.
510             assembly {
511                 r := mload(add(signature, 0x20))
512                 s := mload(add(signature, 0x40))
513                 v := byte(0, mload(add(signature, 0x60)))
514             }
515             return tryRecover(hash, v, r, s);
516         } else if (signature.length == 64) {
517             bytes32 r;
518             bytes32 vs;
519             // ecrecover takes the signature parameters, and the only way to get them
520             // currently is to use assembly.
521             assembly {
522                 r := mload(add(signature, 0x20))
523                 vs := mload(add(signature, 0x40))
524             }
525             return tryRecover(hash, r, vs);
526         } else {
527             return (address(0), RecoverError.InvalidSignatureLength);
528         }
529     }
530 
531     /**
532      * @dev Returns the address that signed a hashed message (`hash`) with
533      * `signature`. This address can then be used for verification purposes.
534      *
535      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
536      * this function rejects them by requiring the `s` value to be in the lower
537      * half order, and the `v` value to be either 27 or 28.
538      *
539      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
540      * verification to be secure: it is possible to craft signatures that
541      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
542      * this is by receiving a hash of the original message (which may otherwise
543      * be too long), and then calling {toEthSignedMessageHash} on it.
544      */
545     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
546         (address recovered, RecoverError error) = tryRecover(hash, signature);
547         _throwError(error);
548         return recovered;
549     }
550 
551     /**
552      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
553      *
554      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
555      *
556      * _Available since v4.3._
557      */
558     function tryRecover(
559         bytes32 hash,
560         bytes32 r,
561         bytes32 vs
562     ) internal pure returns (address, RecoverError) {
563         bytes32 s;
564         uint8 v;
565         assembly {
566             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
567             v := add(shr(255, vs), 27)
568         }
569         return tryRecover(hash, v, r, s);
570     }
571 
572     /**
573      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
574      *
575      * _Available since v4.2._
576      */
577     function recover(
578         bytes32 hash,
579         bytes32 r,
580         bytes32 vs
581     ) internal pure returns (address) {
582         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
583         _throwError(error);
584         return recovered;
585     }
586 
587     /**
588      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
589      * `r` and `s` signature fields separately.
590      *
591      * _Available since v4.3._
592      */
593     function tryRecover(
594         bytes32 hash,
595         uint8 v,
596         bytes32 r,
597         bytes32 s
598     ) internal pure returns (address, RecoverError) {
599         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
600         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
601         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
602         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
603         //
604         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
605         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
606         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
607         // these malleable signatures as well.
608         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
609             return (address(0), RecoverError.InvalidSignatureS);
610         }
611         if (v != 27 && v != 28) {
612             return (address(0), RecoverError.InvalidSignatureV);
613         }
614 
615         // If the signature is valid (and not malleable), return the signer address
616         address signer = ecrecover(hash, v, r, s);
617         if (signer == address(0)) {
618             return (address(0), RecoverError.InvalidSignature);
619         }
620 
621         return (signer, RecoverError.NoError);
622     }
623 
624     /**
625      * @dev Overload of {ECDSA-recover} that receives the `v`,
626      * `r` and `s` signature fields separately.
627      */
628     function recover(
629         bytes32 hash,
630         uint8 v,
631         bytes32 r,
632         bytes32 s
633     ) internal pure returns (address) {
634         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
635         _throwError(error);
636         return recovered;
637     }
638 
639     /**
640      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
641      * produces hash corresponding to the one signed with the
642      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
643      * JSON-RPC method as part of EIP-191.
644      *
645      * See {recover}.
646      */
647     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
648         // 32 is the length in bytes of hash,
649         // enforced by the type signature above
650         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
651     }
652 
653     /**
654      * @dev Returns an Ethereum Signed Message, created from `s`. This
655      * produces hash corresponding to the one signed with the
656      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
657      * JSON-RPC method as part of EIP-191.
658      *
659      * See {recover}.
660      */
661     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
662         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
663     }
664 
665     /**
666      * @dev Returns an Ethereum Signed Typed Data, created from a
667      * `domainSeparator` and a `structHash`. This produces hash corresponding
668      * to the one signed with the
669      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
670      * JSON-RPC method as part of EIP-712.
671      *
672      * See {recover}.
673      */
674     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
675         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
676     }
677 }
678 
679 // File: @openzeppelin/contracts/utils/Address.sol
680 
681 
682 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
683 
684 pragma solidity ^0.8.0;
685 
686 /**
687  * @dev Collection of functions related to the address type
688  */
689 library Address {
690     /**
691      * @dev Returns true if `account` is a contract.
692      *
693      * [IMPORTANT]
694      * ====
695      * It is unsafe to assume that an address for which this function returns
696      * false is an externally-owned account (EOA) and not a contract.
697      *
698      * Among others, `isContract` will return false for the following
699      * types of addresses:
700      *
701      *  - an externally-owned account
702      *  - a contract in construction
703      *  - an address where a contract will be created
704      *  - an address where a contract lived, but was destroyed
705      * ====
706      */
707     function isContract(address account) internal view returns (bool) {
708         // This method relies on extcodesize, which returns 0 for contracts in
709         // construction, since the code is only stored at the end of the
710         // constructor execution.
711 
712         uint256 size;
713         assembly {
714             size := extcodesize(account)
715         }
716         return size > 0;
717     }
718 
719     /**
720      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
721      * `recipient`, forwarding all available gas and reverting on errors.
722      *
723      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
724      * of certain opcodes, possibly making contracts go over the 2300 gas limit
725      * imposed by `transfer`, making them unable to receive funds via
726      * `transfer`. {sendValue} removes this limitation.
727      *
728      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
729      *
730      * IMPORTANT: because control is transferred to `recipient`, care must be
731      * taken to not create reentrancy vulnerabilities. Consider using
732      * {ReentrancyGuard} or the
733      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
734      */
735     function sendValue(address payable recipient, uint256 amount) internal {
736         require(address(this).balance >= amount, "Address: insufficient balance");
737 
738         (bool success, ) = recipient.call{value: amount}("");
739         require(success, "Address: unable to send value, recipient may have reverted");
740     }
741 
742     /**
743      * @dev Performs a Solidity function call using a low level `call`. A
744      * plain `call` is an unsafe replacement for a function call: use this
745      * function instead.
746      *
747      * If `target` reverts with a revert reason, it is bubbled up by this
748      * function (like regular Solidity function calls).
749      *
750      * Returns the raw returned data. To convert to the expected return value,
751      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
752      *
753      * Requirements:
754      *
755      * - `target` must be a contract.
756      * - calling `target` with `data` must not revert.
757      *
758      * _Available since v3.1._
759      */
760     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
761         return functionCall(target, data, "Address: low-level call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
766      * `errorMessage` as a fallback revert reason when `target` reverts.
767      *
768      * _Available since v3.1._
769      */
770     function functionCall(
771         address target,
772         bytes memory data,
773         string memory errorMessage
774     ) internal returns (bytes memory) {
775         return functionCallWithValue(target, data, 0, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but also transferring `value` wei to `target`.
781      *
782      * Requirements:
783      *
784      * - the calling contract must have an ETH balance of at least `value`.
785      * - the called Solidity function must be `payable`.
786      *
787      * _Available since v3.1._
788      */
789     function functionCallWithValue(
790         address target,
791         bytes memory data,
792         uint256 value
793     ) internal returns (bytes memory) {
794         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
795     }
796 
797     /**
798      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
799      * with `errorMessage` as a fallback revert reason when `target` reverts.
800      *
801      * _Available since v3.1._
802      */
803     function functionCallWithValue(
804         address target,
805         bytes memory data,
806         uint256 value,
807         string memory errorMessage
808     ) internal returns (bytes memory) {
809         require(address(this).balance >= value, "Address: insufficient balance for call");
810         require(isContract(target), "Address: call to non-contract");
811 
812         (bool success, bytes memory returndata) = target.call{value: value}(data);
813         return verifyCallResult(success, returndata, errorMessage);
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
818      * but performing a static call.
819      *
820      * _Available since v3.3._
821      */
822     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
823         return functionStaticCall(target, data, "Address: low-level static call failed");
824     }
825 
826     /**
827      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
828      * but performing a static call.
829      *
830      * _Available since v3.3._
831      */
832     function functionStaticCall(
833         address target,
834         bytes memory data,
835         string memory errorMessage
836     ) internal view returns (bytes memory) {
837         require(isContract(target), "Address: static call to non-contract");
838 
839         (bool success, bytes memory returndata) = target.staticcall(data);
840         return verifyCallResult(success, returndata, errorMessage);
841     }
842 
843     /**
844      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
845      * but performing a delegate call.
846      *
847      * _Available since v3.4._
848      */
849     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
850         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
851     }
852 
853     /**
854      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
855      * but performing a delegate call.
856      *
857      * _Available since v3.4._
858      */
859     function functionDelegateCall(
860         address target,
861         bytes memory data,
862         string memory errorMessage
863     ) internal returns (bytes memory) {
864         require(isContract(target), "Address: delegate call to non-contract");
865 
866         (bool success, bytes memory returndata) = target.delegatecall(data);
867         return verifyCallResult(success, returndata, errorMessage);
868     }
869 
870     /**
871      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
872      * revert reason using the provided one.
873      *
874      * _Available since v4.3._
875      */
876     function verifyCallResult(
877         bool success,
878         bytes memory returndata,
879         string memory errorMessage
880     ) internal pure returns (bytes memory) {
881         if (success) {
882             return returndata;
883         } else {
884             // Look for revert reason and bubble it up if present
885             if (returndata.length > 0) {
886                 // The easiest way to bubble the revert reason is using memory via assembly
887 
888                 assembly {
889                     let returndata_size := mload(returndata)
890                     revert(add(32, returndata), returndata_size)
891                 }
892             } else {
893                 revert(errorMessage);
894             }
895         }
896     }
897 }
898 
899 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @title ERC721 token receiver interface
908  * @dev Interface for any contract that wants to support safeTransfers
909  * from ERC721 asset contracts.
910  */
911 interface IERC721Receiver {
912     /**
913      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
914      * by `operator` from `from`, this function is called.
915      *
916      * It must return its Solidity selector to confirm the token transfer.
917      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
918      *
919      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
920      */
921     function onERC721Received(
922         address operator,
923         address from,
924         uint256 tokenId,
925         bytes calldata data
926     ) external returns (bytes4);
927 }
928 
929 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
930 
931 
932 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
933 
934 pragma solidity ^0.8.0;
935 
936 /**
937  * @dev Interface of the ERC165 standard, as defined in the
938  * https://eips.ethereum.org/EIPS/eip-165[EIP].
939  *
940  * Implementers can declare support of contract interfaces, which can then be
941  * queried by others ({ERC165Checker}).
942  *
943  * For an implementation, see {ERC165}.
944  */
945 interface IERC165 {
946     /**
947      * @dev Returns true if this contract implements the interface defined by
948      * `interfaceId`. See the corresponding
949      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
950      * to learn more about how these ids are created.
951      *
952      * This function call must use less than 30 000 gas.
953      */
954     function supportsInterface(bytes4 interfaceId) external view returns (bool);
955 }
956 
957 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
958 
959 
960 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
961 
962 pragma solidity ^0.8.0;
963 
964 
965 /**
966  * @dev Implementation of the {IERC165} interface.
967  *
968  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
969  * for the additional interface id that will be supported. For example:
970  *
971  * ```solidity
972  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
973  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
974  * }
975  * ```
976  *
977  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
978  */
979 abstract contract ERC165 is IERC165 {
980     /**
981      * @dev See {IERC165-supportsInterface}.
982      */
983     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
984         return interfaceId == type(IERC165).interfaceId;
985     }
986 }
987 
988 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
989 
990 
991 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
992 
993 pragma solidity ^0.8.0;
994 
995 
996 /**
997  * @dev Required interface of an ERC721 compliant contract.
998  */
999 interface IERC721 is IERC165 {
1000     /**
1001      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1002      */
1003     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1004 
1005     /**
1006      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1007      */
1008     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1009 
1010     /**
1011      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1012      */
1013     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1014 
1015     /**
1016      * @dev Returns the number of tokens in ``owner``'s account.
1017      */
1018     function balanceOf(address owner) external view returns (uint256 balance);
1019 
1020     /**
1021      * @dev Returns the owner of the `tokenId` token.
1022      *
1023      * Requirements:
1024      *
1025      * - `tokenId` must exist.
1026      */
1027     function ownerOf(uint256 tokenId) external view returns (address owner);
1028 
1029     /**
1030      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1031      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1032      *
1033      * Requirements:
1034      *
1035      * - `from` cannot be the zero address.
1036      * - `to` cannot be the zero address.
1037      * - `tokenId` token must exist and be owned by `from`.
1038      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1039      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1040      *
1041      * Emits a {Transfer} event.
1042      */
1043     function safeTransferFrom(
1044         address from,
1045         address to,
1046         uint256 tokenId
1047     ) external;
1048 
1049     /**
1050      * @dev Transfers `tokenId` token from `from` to `to`.
1051      *
1052      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1053      *
1054      * Requirements:
1055      *
1056      * - `from` cannot be the zero address.
1057      * - `to` cannot be the zero address.
1058      * - `tokenId` token must be owned by `from`.
1059      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1060      *
1061      * Emits a {Transfer} event.
1062      */
1063     function transferFrom(
1064         address from,
1065         address to,
1066         uint256 tokenId
1067     ) external;
1068 
1069     /**
1070      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1071      * The approval is cleared when the token is transferred.
1072      *
1073      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1074      *
1075      * Requirements:
1076      *
1077      * - The caller must own the token or be an approved operator.
1078      * - `tokenId` must exist.
1079      *
1080      * Emits an {Approval} event.
1081      */
1082     function approve(address to, uint256 tokenId) external;
1083 
1084     /**
1085      * @dev Returns the account approved for `tokenId` token.
1086      *
1087      * Requirements:
1088      *
1089      * - `tokenId` must exist.
1090      */
1091     function getApproved(uint256 tokenId) external view returns (address operator);
1092 
1093     /**
1094      * @dev Approve or remove `operator` as an operator for the caller.
1095      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1096      *
1097      * Requirements:
1098      *
1099      * - The `operator` cannot be the caller.
1100      *
1101      * Emits an {ApprovalForAll} event.
1102      */
1103     function setApprovalForAll(address operator, bool _approved) external;
1104 
1105     /**
1106      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1107      *
1108      * See {setApprovalForAll}
1109      */
1110     function isApprovedForAll(address owner, address operator) external view returns (bool);
1111 
1112     /**
1113      * @dev Safely transfers `tokenId` token from `from` to `to`.
1114      *
1115      * Requirements:
1116      *
1117      * - `from` cannot be the zero address.
1118      * - `to` cannot be the zero address.
1119      * - `tokenId` token must exist and be owned by `from`.
1120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1121      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1122      *
1123      * Emits a {Transfer} event.
1124      */
1125     function safeTransferFrom(
1126         address from,
1127         address to,
1128         uint256 tokenId,
1129         bytes calldata data
1130     ) external;
1131 }
1132 
1133 // File: contracts/IERC721Enumerable.sol
1134 
1135 
1136 
1137 pragma solidity ^0.8.0;
1138 
1139 
1140 /**
1141  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1142  * @dev See https://eips.ethereum.org/EIPS/eip-721
1143  */
1144 interface IERC721Enumerable is IERC721 {
1145     /**
1146      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1147      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1148      */
1149     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1150 }
1151 
1152 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1153 
1154 
1155 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1156 
1157 pragma solidity ^0.8.0;
1158 
1159 
1160 /**
1161  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1162  * @dev See https://eips.ethereum.org/EIPS/eip-721
1163  */
1164 interface IERC721Metadata is IERC721 {
1165     /**
1166      * @dev Returns the token collection name.
1167      */
1168     function name() external view returns (string memory);
1169 
1170     /**
1171      * @dev Returns the token collection symbol.
1172      */
1173     function symbol() external view returns (string memory);
1174 
1175     /**
1176      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1177      */
1178     function tokenURI(uint256 tokenId) external view returns (string memory);
1179 }
1180 
1181 // File: @openzeppelin/contracts/utils/Context.sol
1182 
1183 
1184 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1185 
1186 pragma solidity ^0.8.0;
1187 
1188 /**
1189  * @dev Provides information about the current execution context, including the
1190  * sender of the transaction and its data. While these are generally available
1191  * via msg.sender and msg.data, they should not be accessed in such a direct
1192  * manner, since when dealing with meta-transactions the account sending and
1193  * paying for execution may not be the actual sender (as far as an application
1194  * is concerned).
1195  *
1196  * This contract is only required for intermediate, library-like contracts.
1197  */
1198 abstract contract Context {
1199     function _msgSender() internal view virtual returns (address) {
1200         return msg.sender;
1201     }
1202 
1203     function _msgData() internal view virtual returns (bytes calldata) {
1204         return msg.data;
1205     }
1206 }
1207 
1208 // File: contracts/ERC721.sol
1209 
1210 
1211 
1212 pragma solidity ^0.8.0;
1213 
1214 
1215 
1216 
1217 
1218 
1219 
1220 
1221 /**
1222  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1223  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1224  * {ERC721Enumerable}.
1225  */
1226 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1227     using Address for address;
1228     using Strings for uint256;
1229 
1230     // Token name
1231     string private _name;
1232 
1233     // Token symbol
1234     string private _symbol;
1235 
1236     // Mapping from token ID to owner address
1237     mapping(uint256 => address) private _owners;
1238 
1239     // Mapping owner address to token count
1240     mapping(address => uint256) private _balances;
1241 
1242     // Mapping from token ID to approved address
1243     mapping(uint256 => address) private _tokenApprovals;
1244 
1245     // Mapping from owner to operator approvals
1246     mapping(address => mapping(address => bool)) private _operatorApprovals;
1247 
1248     /**
1249      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1250      */
1251     constructor(string memory name_, string memory symbol_) {
1252         _name = name_;
1253         _symbol = symbol_;
1254     }
1255 
1256     /**
1257      * @dev See {IERC165-supportsInterface}.
1258      */
1259     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1260         return
1261         interfaceId == type(IERC721).interfaceId ||
1262         interfaceId == type(IERC721Metadata).interfaceId ||
1263         super.supportsInterface(interfaceId);
1264     }
1265 
1266     /**
1267      * @dev See {IERC721-balanceOf}.
1268      */
1269     function balanceOf(address owner) public view virtual override returns (uint256) {
1270         require(owner != address(0), "ERC721: balance query for the zero address");
1271         return _balances[owner];
1272     }
1273 
1274     /**
1275      * @dev See {IERC721-ownerOf}.
1276      */
1277     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1278         address owner = _owners[tokenId];
1279         require(owner != address(0), "ERC721: owner query for nonexistent token");
1280         return owner;
1281     }
1282 
1283     /**
1284      * @dev Edit for rawOwnerOf token
1285      */
1286     function rawOwnerOf(uint256 tokenId) public view returns (address) {
1287         return _owners[tokenId];
1288     }
1289 
1290     /**
1291      * @dev See {IERC721Metadata-name}.
1292      */
1293     function name() public view virtual override returns (string memory) {
1294         return _name;
1295     }
1296 
1297     /**
1298      * @dev See {IERC721Metadata-symbol}.
1299      */
1300     function symbol() public view virtual override returns (string memory) {
1301         return _symbol;
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Metadata-tokenURI}.
1306      */
1307     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1308         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1309 
1310         string memory baseURI = _baseURI();
1311         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1312     }
1313 
1314     /**
1315      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1316      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1317      * by default, can be overriden in child contracts.
1318      */
1319     function _baseURI() internal view virtual returns (string memory) {
1320         return "";
1321     }
1322 
1323     /**
1324      * @dev See {IERC721-approve}.
1325      */
1326     function approve(address to, uint256 tokenId) public virtual override {
1327         address owner = ERC721.ownerOf(tokenId);
1328         require(to != owner, "ERC721: approval to current owner");
1329 
1330         require(
1331             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1332             "ERC721: approve caller is not owner nor approved for all"
1333         );
1334 
1335         _approve(to, tokenId);
1336     }
1337 
1338     /**
1339      * @dev See {IERC721-getApproved}.
1340      */
1341     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1342         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1343 
1344         return _tokenApprovals[tokenId];
1345     }
1346 
1347     /**
1348      * @dev See {IERC721-setApprovalForAll}.
1349      */
1350     function setApprovalForAll(address operator, bool approved) public virtual override {
1351         require(operator != _msgSender(), "ERC721: approve to caller");
1352 
1353         _operatorApprovals[_msgSender()][operator] = approved;
1354         emit ApprovalForAll(_msgSender(), operator, approved);
1355     }
1356 
1357     /**
1358      * @dev See {IERC721-isApprovedForAll}.
1359      */
1360     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1361         return _operatorApprovals[owner][operator];
1362     }
1363 
1364     /**
1365      * @dev See {IERC721-transferFrom}.
1366      */
1367     function transferFrom(
1368         address from,
1369         address to,
1370         uint256 tokenId
1371     ) public virtual override {
1372         //solhint-disable-next-line max-line-length
1373         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1374 
1375         _transfer(from, to, tokenId);
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-safeTransferFrom}.
1380      */
1381     function safeTransferFrom(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) public virtual override {
1386         safeTransferFrom(from, to, tokenId, "");
1387     }
1388 
1389     /**
1390      * @dev See {IERC721-safeTransferFrom}.
1391      */
1392     function safeTransferFrom(
1393         address from,
1394         address to,
1395         uint256 tokenId,
1396         bytes memory _data
1397     ) public virtual override {
1398         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1399         _safeTransfer(from, to, tokenId, _data);
1400     }
1401 
1402     /**
1403      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1404      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1405      *
1406      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1407      *
1408      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1409      * implement alternative mechanisms to perform token transfer, such as signature-based.
1410      *
1411      * Requirements:
1412      *
1413      * - `from` cannot be the zero address.
1414      * - `to` cannot be the zero address.
1415      * - `tokenId` token must exist and be owned by `from`.
1416      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1417      *
1418      * Emits a {Transfer} event.
1419      */
1420     function _safeTransfer(
1421         address from,
1422         address to,
1423         uint256 tokenId,
1424         bytes memory _data
1425     ) internal virtual {
1426         _transfer(from, to, tokenId);
1427         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1428     }
1429 
1430     /**
1431      * @dev Returns whether `tokenId` exists.
1432      *
1433      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1434      *
1435      * Tokens start existing when they are minted (`_mint`),
1436      * and stop existing when they are burned (`_burn`).
1437      */
1438     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1439         return _owners[tokenId] != address(0);
1440     }
1441 
1442     /**
1443      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1444      *
1445      * Requirements:
1446      *
1447      * - `tokenId` must exist.
1448      */
1449     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1450         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1451         address owner = ERC721.ownerOf(tokenId);
1452         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1453     }
1454 
1455     /**
1456      * @dev Safely mints `tokenId` and transfers it to `to`.
1457      *
1458      * Requirements:
1459      *
1460      * - `tokenId` must not exist.
1461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1462      *
1463      * Emits a {Transfer} event.
1464      */
1465     function _safeMint(address to, uint256 tokenId) internal virtual {
1466         _safeMint(to, tokenId, "");
1467     }
1468 
1469     /**
1470      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1471      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1472      */
1473     function _safeMint(
1474         address to,
1475         uint256 tokenId,
1476         bytes memory _data
1477     ) internal virtual {
1478         _mint(to, tokenId);
1479         require(
1480             _checkOnERC721Received(address(0), to, tokenId, _data),
1481             "ERC721: transfer to non ERC721Receiver implementer"
1482         );
1483     }
1484 
1485     /**
1486      * @dev Mints `tokenId` and transfers it to `to`.
1487      *
1488      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1489      *
1490      * Requirements:
1491      *
1492      * - `tokenId` must not exist.
1493      * - `to` cannot be the zero address.
1494      *
1495      * Emits a {Transfer} event.
1496      */
1497     function _mint(address to, uint256 tokenId) internal virtual {
1498         require(to != address(0), "ERC721: mint to the zero address");
1499         require(!_exists(tokenId), "ERC721: token already minted");
1500 
1501         _beforeTokenTransfer(address(0), to, tokenId);
1502 
1503         _balances[to] += 1;
1504         _owners[tokenId] = to;
1505 
1506         emit Transfer(address(0), to, tokenId);
1507     }
1508 
1509     /**
1510      * @dev Destroys `tokenId`.
1511      * The approval is cleared when the token is burned.
1512      *
1513      * Requirements:
1514      *
1515      * - `tokenId` must exist.
1516      *
1517      * Emits a {Transfer} event.
1518      */
1519     function _burn(uint256 tokenId) internal virtual {
1520         address owner = ERC721.ownerOf(tokenId);
1521         address to = address(0);
1522 
1523         _beforeTokenTransfer(owner, to, tokenId);
1524 
1525         // Clear approvals
1526         _approve(address(0), tokenId);
1527 
1528         _balances[owner] -= 1;
1529         delete _owners[tokenId];
1530 
1531         emit Transfer(owner, to, tokenId);
1532     }
1533 
1534     /**
1535      * @dev Transfers `tokenId` from `from` to `to`.
1536      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1537      *
1538      * Requirements:
1539      *
1540      * - `to` cannot be the zero address.
1541      * - `tokenId` token must be owned by `from`.
1542      *
1543      * Emits a {Transfer} event.
1544      */
1545     function _transfer(
1546         address from,
1547         address to,
1548         uint256 tokenId
1549     ) internal virtual {
1550         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1551         require(to != address(0), "ERC721: transfer to the zero address");
1552 
1553         _beforeTokenTransfer(from, to, tokenId);
1554 
1555         // Clear approvals from the previous owner
1556         _approve(address(0), tokenId);
1557 
1558         _balances[from] -= 1;
1559         _balances[to] += 1;
1560         _owners[tokenId] = to;
1561 
1562         emit Transfer(from, to, tokenId);
1563     }
1564 
1565     /**
1566      * @dev Approve `to` to operate on `tokenId`
1567      *
1568      * Emits a {Approval} event.
1569      */
1570     function _approve(address to, uint256 tokenId) internal virtual {
1571         _tokenApprovals[tokenId] = to;
1572         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1573     }
1574 
1575     /**
1576      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1577      * The call is not executed if the target address is not a contract.
1578      *
1579      * @param from address representing the previous owner of the given token ID
1580      * @param to target address that will receive the tokens
1581      * @param tokenId uint256 ID of the token to be transferred
1582      * @param _data bytes optional data to send along with the call
1583      * @return bool whether the call correctly returned the expected magic value
1584      */
1585     function _checkOnERC721Received(
1586         address from,
1587         address to,
1588         uint256 tokenId,
1589         bytes memory _data
1590     ) private returns (bool) {
1591         if (to.isContract()) {
1592             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1593                 return retval == IERC721Receiver(to).onERC721Received.selector;
1594             } catch (bytes memory reason) {
1595                 if (reason.length == 0) {
1596                     revert("ERC721: transfer to non ERC721Receiver implementer");
1597                 } else {
1598                     assembly {
1599                         revert(add(32, reason), mload(reason))
1600                     }
1601                 }
1602             }
1603         } else {
1604             return true;
1605         }
1606     }
1607 
1608     /**
1609      * @dev Hook that is called before any token transfer. This includes minting
1610      * and burning.
1611      *
1612      * Calling conditions:
1613      *
1614      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1615      * transferred to `to`.
1616      * - When `from` is zero, `tokenId` will be minted for `to`.
1617      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1618      * - `from` and `to` are never both zero.
1619      *
1620      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1621      */
1622     function _beforeTokenTransfer(
1623         address from,
1624         address to,
1625         uint256 tokenId
1626     ) internal virtual {}
1627 }
1628 // File: contracts/ERC721Enumerable.sol
1629 
1630 
1631 
1632 pragma solidity ^0.8.4;
1633 
1634 
1635 /**
1636  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1637  * enumerability of all the token ids in the contract as well as all token ids owned by each
1638  * account.
1639  */
1640 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1641     // Mapping from owner to list of owned token IDs
1642     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1643 
1644     // Mapping from token ID to index of the owner tokens list
1645     mapping(uint256 => uint256) private _ownedTokensIndex;
1646 
1647     /**
1648      * @dev See {IERC165-supportsInterface}.
1649      */
1650     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1651         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1652     }
1653 
1654     /**
1655      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1656      */
1657     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1658         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1659         return _ownedTokens[owner][index];
1660     }
1661 
1662     /**
1663      * @dev Hook that is called before any token transfer. This includes minting
1664      * and burning.
1665      *
1666      * Calling conditions:
1667      *
1668      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1669      * transferred to `to`.
1670      * - When `from` is zero, `tokenId` will be minted for `to`.
1671      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1672      * - `from` cannot be the zero address.
1673      * - `to` cannot be the zero address.
1674      *
1675      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1676      */
1677     function _beforeTokenTransfer(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) internal virtual override {
1682         super._beforeTokenTransfer(from, to, tokenId);
1683         if (from != to && from != address(0)) {
1684             _removeTokenFromOwnerEnumeration(from, tokenId);
1685         }
1686         if (to != from && to != address(0)) {
1687             _addTokenToOwnerEnumeration(to, tokenId);
1688         }
1689     }
1690 
1691     /**
1692      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1693      * @param to address representing the new owner of the given token ID
1694      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1695      */
1696     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1697         uint256 length = ERC721.balanceOf(to);
1698         _ownedTokens[to][length] = tokenId;
1699         _ownedTokensIndex[tokenId] = length;
1700     }
1701 
1702     /**
1703      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1704      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1705      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1706      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1707      * @param from address representing the previous owner of the given token ID
1708      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1709      */
1710     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1711         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1712         // then delete the last slot (swap and pop).
1713 
1714         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1715         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1716 
1717         // When the token to delete is the last token, the swap operation is unnecessary
1718         if (tokenIndex != lastTokenIndex) {
1719             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1720 
1721             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1722             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1723         }
1724 
1725         // This also deletes the contents at the last position of the array
1726         delete _ownedTokensIndex[tokenId];
1727         delete _ownedTokens[from][lastTokenIndex];
1728     }
1729 
1730 }
1731 // File: @openzeppelin/contracts/access/Ownable.sol
1732 
1733 
1734 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1735 
1736 pragma solidity ^0.8.0;
1737 
1738 
1739 /**
1740  * @dev Contract module which provides a basic access control mechanism, where
1741  * there is an account (an owner) that can be granted exclusive access to
1742  * specific functions.
1743  *
1744  * By default, the owner account will be the one that deploys the contract. This
1745  * can later be changed with {transferOwnership}.
1746  *
1747  * This module is used through inheritance. It will make available the modifier
1748  * `onlyOwner`, which can be applied to your functions to restrict their use to
1749  * the owner.
1750  */
1751 abstract contract Ownable is Context {
1752     address private _owner;
1753 
1754     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1755 
1756     /**
1757      * @dev Initializes the contract setting the deployer as the initial owner.
1758      */
1759     constructor() {
1760         _transferOwnership(_msgSender());
1761     }
1762 
1763     /**
1764      * @dev Returns the address of the current owner.
1765      */
1766     function owner() public view virtual returns (address) {
1767         return _owner;
1768     }
1769 
1770     /**
1771      * @dev Throws if called by any account other than the owner.
1772      */
1773     modifier onlyOwner() {
1774         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1775         _;
1776     }
1777 
1778     /**
1779      * @dev Leaves the contract without owner. It will not be possible to call
1780      * `onlyOwner` functions anymore. Can only be called by the current owner.
1781      *
1782      * NOTE: Renouncing ownership will leave the contract without an owner,
1783      * thereby removing any functionality that is only available to the owner.
1784      */
1785     function renounceOwnership() public virtual onlyOwner {
1786         _transferOwnership(address(0));
1787     }
1788 
1789     /**
1790      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1791      * Can only be called by the current owner.
1792      */
1793     function transferOwnership(address newOwner) public virtual onlyOwner {
1794         require(newOwner != address(0), "Ownable: new owner is the zero address");
1795         _transferOwnership(newOwner);
1796     }
1797 
1798     /**
1799      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1800      * Internal function without access restriction.
1801      */
1802     function _transferOwnership(address newOwner) internal virtual {
1803         address oldOwner = _owner;
1804         _owner = newOwner;
1805         emit OwnershipTransferred(oldOwner, newOwner);
1806     }
1807 }
1808 
1809 // File: contracts/ControlledAccess.sol
1810 
1811 
1812 pragma solidity ^0.8.4;
1813 
1814 
1815 /* @title ControlledAccess
1816  * @dev The ControlledAccess contract allows function to be restricted to users
1817  * that possess a signed authorization from the owner of the contract. This signed
1818  * message includes the user to give permission to and the contract address to prevent
1819  * reusing the same authorization message on different contract with same owner.
1820  */
1821 
1822 contract ControlledAccess is Ownable {
1823     /*
1824      * @dev Requires msg.sender to have valid access message.
1825      * @param _v ECDSA signature parameter v.
1826      * @param _r ECDSA signature parameters r.
1827      * @param _s ECDSA signature parameters s.
1828      */
1829     modifier onlyValidAccess(
1830         uint8 _v,
1831         bytes32 _r,
1832         bytes32 _s
1833     ) {
1834         require(isValidAccessMessage(msg.sender, _v, _r, _s), "Access Denied");
1835         _;
1836     }
1837 
1838     /*
1839      * @dev Verifies if message was signed by owner to give access to _add for this contract.
1840      *      Assumes Geth signature prefix.
1841      * @param _add Address of agent with access
1842      * @param _v ECDSA signature parameter v.
1843      * @param _r ECDSA signature parameters r.
1844      * @param _s ECDSA signature parameters s.
1845      * @return Validity of access message for a given address.
1846      */
1847     function isValidAccessMessage(
1848         address _add,
1849         uint8 _v,
1850         bytes32 _r,
1851         bytes32 _s
1852     ) public view returns (bool) {
1853         bytes32 hash = keccak256(abi.encodePacked(_add));
1854         address sender = ecrecover(
1855             keccak256(
1856                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1857             ),
1858             _v,
1859             _r,
1860             _s
1861         );
1862         return (owner() == sender);
1863     }
1864 }
1865 
1866 // File: contracts/NFT.sol
1867 
1868 
1869 pragma solidity ^0.8.4;
1870 
1871 
1872 
1873 contract EuniceDAO is
1874     ERC721Enumerable,
1875     Ownable,
1876     ReentrancyGuard,
1877     ControlledAccess
1878 {
1879     using ECDSA for bytes32;
1880     using SafeMath for uint256;
1881     using Counters for Counters.Counter;
1882     using Strings for *;
1883 
1884     uint256 private publicStart = 1642822313;
1885 
1886     string private EMPTY_STRING = "";
1887 
1888     uint256 public MAX_ELEMENTS = 1000;
1889     uint256 public PRICE = 0 ether;
1890 
1891     uint256 public maxMint = 3;
1892 
1893     address payable devAddress;
1894     uint256 private devFee;
1895 
1896     bool private PAUSE = true;
1897 
1898     Counters.Counter private _tokenIdTracker;
1899 
1900     struct BaseTokenUriById {
1901         uint256 startId;
1902         uint256 endId;
1903         string baseURI;
1904     }
1905 
1906     BaseTokenUriById[] public baseTokenUris;
1907 
1908     event PauseEvent(bool pause);
1909     event welcomeSimp(uint256 indexed id);
1910 
1911     modifier saleIsOpen() {
1912         require(totalSupply() <= MAX_ELEMENTS, "Soldout!");
1913         require(!PAUSE, "Sales not open");
1914         _;
1915     }
1916 
1917     constructor(
1918         string memory name,
1919         string memory ticker,
1920         uint256 maxTokens
1921     ) ERC721(name, ticker) {
1922       MAX_ELEMENTS = maxTokens;
1923       _mintAmount(1, owner());
1924     }
1925 
1926     function setMaxElements(uint256 maxElements) public onlyOwner {
1927         require(MAX_ELEMENTS < maxElements, "Cannot decrease max elements");
1928         MAX_ELEMENTS = maxElements;
1929     }
1930 
1931     function setMintPrice(uint256 mintPriceWei) public onlyOwner {
1932         PRICE = mintPriceWei;
1933     }
1934 
1935     function setDevAddress(address _devAddress, uint256 _devFee)
1936         public
1937         onlyOwner
1938     {
1939         devAddress = payable(_devAddress);
1940         devFee = _devFee;
1941     }
1942 
1943     function clearBaseUris() public onlyOwner {
1944         delete baseTokenUris;
1945     }
1946 
1947     function setStartTimes(uint256 _publicStart)
1948         public
1949         onlyOwner
1950     {
1951         publicStart = _publicStart;
1952     }
1953 
1954     function setBaseURI(
1955         string memory baseURI,
1956         uint256 startId,
1957         uint256 endId
1958     ) public onlyOwner {
1959         require(
1960             keccak256(bytes(tokenURI(startId))) ==
1961                 keccak256(bytes(EMPTY_STRING)),
1962             "Start ID Overlap"
1963         );
1964         require(
1965             keccak256(bytes(tokenURI(endId))) == keccak256(bytes(EMPTY_STRING)),
1966             "End ID Overlap"
1967         );
1968 
1969         baseTokenUris.push(
1970             BaseTokenUriById({startId: startId, endId: endId, baseURI: baseURI})
1971         );
1972     }
1973 
1974     function setPause(bool _pause) public onlyOwner {
1975         PAUSE = _pause;
1976         emit PauseEvent(PAUSE);
1977     }
1978 
1979     function setMaxMint(uint256 limit) public onlyOwner {
1980         maxMint = limit;
1981     }
1982 
1983     function withdrawAll() public onlyOwner {
1984         uint256 balance = address(this).balance;
1985         require(balance > 0);
1986         _withdraw(devAddress, balance.mul(devFee).div(100));
1987         _withdraw(owner(), address(this).balance);
1988     }
1989 
1990     function mintUnsoldTokens(uint256 amount) public onlyOwner {
1991         require(PAUSE, "Pause is disable");
1992         _mintAmount(amount, owner());
1993     }
1994 
1995     /**
1996      * @notice Public Mint.
1997      */
1998     function mint(uint256 _amount) public payable saleIsOpen nonReentrant {
1999         require(block.timestamp > publicStart, "Public not open yet.");
2000         uint256 total = totalSupply();
2001         require(_amount <= maxMint, "Max limit");
2002         require(total + _amount <= MAX_ELEMENTS, "Max limit");
2003         require(msg.value >= price(_amount), "Value below price");
2004         address wallet = _msgSender();
2005         _mintAmount(_amount, wallet);
2006     }
2007 
2008     /**
2009      * @notice Admin Mint. Generally for collaborations etc.
2010      */
2011     function adminMint(uint256 _amount, address receiver) public payable onlyOwner nonReentrant {
2012         uint256 total = totalSupply();
2013         require(total + _amount <= MAX_ELEMENTS, "Max limit");
2014         _mintAmount(_amount, receiver);
2015     }
2016 
2017     function getUnsoldTokens(uint256 offset, uint256 limit)
2018         external
2019         view
2020         returns (uint256[] memory)
2021     {
2022         uint256[] memory tokens = new uint256[](limit);
2023         for (uint256 i = 0; i < limit; i++) {
2024             uint256 key = i + offset;
2025             if (rawOwnerOf(key) == address(0)) {
2026                 tokens[i] = key;
2027             }
2028         }
2029         return tokens;
2030     }
2031 
2032     function tokenURI(uint256 tokenId)
2033         public
2034         view
2035         virtual
2036         override
2037         returns (string memory)
2038     {
2039         uint256 length = baseTokenUris.length;
2040         for (uint256 interval = 0; interval < length; ++interval) {
2041             BaseTokenUriById storage baseTokenUri = baseTokenUris[interval];
2042             if (
2043                 baseTokenUri.startId <= tokenId && baseTokenUri.endId >= tokenId
2044             ) {
2045                 return
2046                     string(
2047                         abi.encodePacked(
2048                             baseTokenUri.baseURI,
2049                             tokenId.toString(),
2050                             ".json"
2051                         )
2052                     );
2053             }
2054         }
2055         return "";
2056     }
2057 
2058     function totalSupply() public view returns (uint256) {
2059         return _tokenIdTracker.current();
2060     }
2061 
2062     function price(uint256 _count) public view returns (uint256) {
2063         return PRICE.mul(_count);
2064     }
2065 
2066     function _mintAmount(uint256 amount, address wallet) private {
2067         for (uint8 i = 0; i < amount; i++) {
2068             while (
2069                 !(rawOwnerOf(_tokenIdTracker.current().add(1)) == address(0))
2070             ) {
2071                 _tokenIdTracker.increment();
2072             }
2073             _mintAnElement(wallet);
2074         }
2075     }
2076 
2077     function _mintAnElement(address _to) private {
2078         _tokenIdTracker.increment();
2079         _safeMint(_to, _tokenIdTracker.current());
2080         emit welcomeSimp(_tokenIdTracker.current());
2081     }
2082 
2083     function walletOfOwner(address _owner)
2084         external
2085         view
2086         returns (uint256[] memory)
2087     {
2088         uint256 tokenCount = balanceOf(_owner);
2089 
2090         uint256[] memory tokensId = new uint256[](tokenCount);
2091         for (uint256 i = 0; i < tokenCount; i++) {
2092             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2093         }
2094 
2095         return tokensId;
2096     }
2097 
2098     function _withdraw(address _address, uint256 _amount) private {
2099         (bool success, ) = _address.call{value: _amount}("");
2100         require(success, "Transfer failed.");
2101     }
2102 }