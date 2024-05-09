1 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
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
53         // On the first call to nonReentrant, _notEntered will be true
54         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
55 
56         // Any calls to nonReentrant after this point will fail
57         _status = _ENTERED;
58 
59         _;
60 
61         // By storing the original value once again, a refund is triggered (see
62         // https://eips.ethereum.org/EIPS/eip-2200)
63         _status = _NOT_ENTERED;
64     }
65 }
66 
67 // File: @openzeppelin/contracts/utils/Counters.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @title Counters
76  * @author Matt Condon (@shrugs)
77  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
78  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
79  *
80  * Include with `using Counters for Counters.Counter;`
81  */
82 library Counters {
83     struct Counter {
84         // This variable should never be directly accessed by users of the library: interactions must be restricted to
85         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
86         // this feature: see https://github.com/ethereum/solidity/issues/4637
87         uint256 _value; // default: 0
88     }
89 
90     function current(Counter storage counter) internal view returns (uint256) {
91         return counter._value;
92     }
93 
94     function increment(Counter storage counter) internal {
95         unchecked {
96             counter._value += 1;
97         }
98     }
99 
100     function decrement(Counter storage counter) internal {
101         uint256 value = counter._value;
102         require(value > 0, "Counter: decrement overflow");
103         unchecked {
104             counter._value = value - 1;
105         }
106     }
107 
108     function reset(Counter storage counter) internal {
109         counter._value = 0;
110     }
111 }
112 
113 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
114 
115 
116 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
117 
118 pragma solidity ^0.8.0;
119 
120 // CAUTION
121 // This version of SafeMath should only be used with Solidity 0.8 or later,
122 // because it relies on the compiler's built in overflow checks.
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations.
126  *
127  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
128  * now has built in overflow checking.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, with an overflow flag.
133      *
134      * _Available since v3.4._
135      */
136     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
137         unchecked {
138             uint256 c = a + b;
139             if (c < a) return (false, 0);
140             return (true, c);
141         }
142     }
143 
144     /**
145      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
146      *
147      * _Available since v3.4._
148      */
149     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
150         unchecked {
151             if (b > a) return (false, 0);
152             return (true, a - b);
153         }
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         unchecked {
163             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164             // benefit is lost if 'b' is also tested.
165             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166             if (a == 0) return (true, 0);
167             uint256 c = a * b;
168             if (c / a != b) return (false, 0);
169             return (true, c);
170         }
171     }
172 
173     /**
174      * @dev Returns the division of two unsigned integers, with a division by zero flag.
175      *
176      * _Available since v3.4._
177      */
178     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
179         unchecked {
180             if (b == 0) return (false, 0);
181             return (true, a / b);
182         }
183     }
184 
185     /**
186      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
187      *
188      * _Available since v3.4._
189      */
190     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
191         unchecked {
192             if (b == 0) return (false, 0);
193             return (true, a % b);
194         }
195     }
196 
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      *
205      * - Addition cannot overflow.
206      */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         return a + b;
209     }
210 
211     /**
212      * @dev Returns the subtraction of two unsigned integers, reverting on
213      * overflow (when the result is negative).
214      *
215      * Counterpart to Solidity's `-` operator.
216      *
217      * Requirements:
218      *
219      * - Subtraction cannot overflow.
220      */
221     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
222         return a - b;
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `*` operator.
230      *
231      * Requirements:
232      *
233      * - Multiplication cannot overflow.
234      */
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         return a * b;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers, reverting on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator.
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b) internal pure returns (uint256) {
250         return a / b;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * reverting when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         return a % b;
267     }
268 
269     /**
270      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
271      * overflow (when the result is negative).
272      *
273      * CAUTION: This function is deprecated because it requires allocating memory for the error
274      * message unnecessarily. For custom revert reasons use {trySub}.
275      *
276      * Counterpart to Solidity's `-` operator.
277      *
278      * Requirements:
279      *
280      * - Subtraction cannot overflow.
281      */
282     function sub(
283         uint256 a,
284         uint256 b,
285         string memory errorMessage
286     ) internal pure returns (uint256) {
287         unchecked {
288             require(b <= a, errorMessage);
289             return a - b;
290         }
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(
306         uint256 a,
307         uint256 b,
308         string memory errorMessage
309     ) internal pure returns (uint256) {
310         unchecked {
311             require(b > 0, errorMessage);
312             return a / b;
313         }
314     }
315 
316     /**
317      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
318      * reverting with custom message when dividing by zero.
319      *
320      * CAUTION: This function is deprecated because it requires allocating memory for the error
321      * message unnecessarily. For custom revert reasons use {tryMod}.
322      *
323      * Counterpart to Solidity's `%` operator. This function uses a `revert`
324      * opcode (which leaves remaining gas untouched) while Solidity uses an
325      * invalid opcode to revert (consuming all remaining gas).
326      *
327      * Requirements:
328      *
329      * - The divisor cannot be zero.
330      */
331     function mod(
332         uint256 a,
333         uint256 b,
334         string memory errorMessage
335     ) internal pure returns (uint256) {
336         unchecked {
337             require(b > 0, errorMessage);
338             return a % b;
339         }
340     }
341 }
342 
343 // File: @openzeppelin/contracts/utils/Strings.sol
344 
345 
346 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
347 
348 pragma solidity ^0.8.0;
349 
350 /**
351  * @dev String operations.
352  */
353 library Strings {
354     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
355 
356     /**
357      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
358      */
359     function toString(uint256 value) internal pure returns (string memory) {
360         // Inspired by OraclizeAPI's implementation - MIT licence
361         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
362 
363         if (value == 0) {
364             return "0";
365         }
366         uint256 temp = value;
367         uint256 digits;
368         while (temp != 0) {
369             digits++;
370             temp /= 10;
371         }
372         bytes memory buffer = new bytes(digits);
373         while (value != 0) {
374             digits -= 1;
375             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
376             value /= 10;
377         }
378         return string(buffer);
379     }
380 
381     /**
382      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
383      */
384     function toHexString(uint256 value) internal pure returns (string memory) {
385         if (value == 0) {
386             return "0x00";
387         }
388         uint256 temp = value;
389         uint256 length = 0;
390         while (temp != 0) {
391             length++;
392             temp >>= 8;
393         }
394         return toHexString(value, length);
395     }
396 
397     /**
398      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
399      */
400     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
401         bytes memory buffer = new bytes(2 * length + 2);
402         buffer[0] = "0";
403         buffer[1] = "x";
404         for (uint256 i = 2 * length + 1; i > 1; --i) {
405             buffer[i] = _HEX_SYMBOLS[value & 0xf];
406             value >>= 4;
407         }
408         require(value == 0, "Strings: hex length insufficient");
409         return string(buffer);
410     }
411 }
412 
413 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
414 
415 
416 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/ECDSA.sol)
417 
418 pragma solidity ^0.8.0;
419 
420 
421 /**
422  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
423  *
424  * These functions can be used to verify that a message was signed by the holder
425  * of the private keys of a given address.
426  */
427 library ECDSA {
428     enum RecoverError {
429         NoError,
430         InvalidSignature,
431         InvalidSignatureLength,
432         InvalidSignatureS,
433         InvalidSignatureV
434     }
435 
436     function _throwError(RecoverError error) private pure {
437         if (error == RecoverError.NoError) {
438             return; // no error: do nothing
439         } else if (error == RecoverError.InvalidSignature) {
440             revert("ECDSA: invalid signature");
441         } else if (error == RecoverError.InvalidSignatureLength) {
442             revert("ECDSA: invalid signature length");
443         } else if (error == RecoverError.InvalidSignatureS) {
444             revert("ECDSA: invalid signature 's' value");
445         } else if (error == RecoverError.InvalidSignatureV) {
446             revert("ECDSA: invalid signature 'v' value");
447         }
448     }
449 
450     /**
451      * @dev Returns the address that signed a hashed message (`hash`) with
452      * `signature` or error string. This address can then be used for verification purposes.
453      *
454      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
455      * this function rejects them by requiring the `s` value to be in the lower
456      * half order, and the `v` value to be either 27 or 28.
457      *
458      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
459      * verification to be secure: it is possible to craft signatures that
460      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
461      * this is by receiving a hash of the original message (which may otherwise
462      * be too long), and then calling {toEthSignedMessageHash} on it.
463      *
464      * Documentation for signature generation:
465      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
466      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
467      *
468      * _Available since v4.3._
469      */
470     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
471         // Check the signature length
472         // - case 65: r,s,v signature (standard)
473         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
474         if (signature.length == 65) {
475             bytes32 r;
476             bytes32 s;
477             uint8 v;
478             // ecrecover takes the signature parameters, and the only way to get them
479             // currently is to use assembly.
480             assembly {
481                 r := mload(add(signature, 0x20))
482                 s := mload(add(signature, 0x40))
483                 v := byte(0, mload(add(signature, 0x60)))
484             }
485             return tryRecover(hash, v, r, s);
486         } else if (signature.length == 64) {
487             bytes32 r;
488             bytes32 vs;
489             // ecrecover takes the signature parameters, and the only way to get them
490             // currently is to use assembly.
491             assembly {
492                 r := mload(add(signature, 0x20))
493                 vs := mload(add(signature, 0x40))
494             }
495             return tryRecover(hash, r, vs);
496         } else {
497             return (address(0), RecoverError.InvalidSignatureLength);
498         }
499     }
500 
501     /**
502      * @dev Returns the address that signed a hashed message (`hash`) with
503      * `signature`. This address can then be used for verification purposes.
504      *
505      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
506      * this function rejects them by requiring the `s` value to be in the lower
507      * half order, and the `v` value to be either 27 or 28.
508      *
509      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
510      * verification to be secure: it is possible to craft signatures that
511      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
512      * this is by receiving a hash of the original message (which may otherwise
513      * be too long), and then calling {toEthSignedMessageHash} on it.
514      */
515     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
516         (address recovered, RecoverError error) = tryRecover(hash, signature);
517         _throwError(error);
518         return recovered;
519     }
520 
521     /**
522      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
523      *
524      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
525      *
526      * _Available since v4.3._
527      */
528     function tryRecover(
529         bytes32 hash,
530         bytes32 r,
531         bytes32 vs
532     ) internal pure returns (address, RecoverError) {
533         bytes32 s;
534         uint8 v;
535         assembly {
536             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
537             v := add(shr(255, vs), 27)
538         }
539         return tryRecover(hash, v, r, s);
540     }
541 
542     /**
543      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
544      *
545      * _Available since v4.2._
546      */
547     function recover(
548         bytes32 hash,
549         bytes32 r,
550         bytes32 vs
551     ) internal pure returns (address) {
552         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
553         _throwError(error);
554         return recovered;
555     }
556 
557     /**
558      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
559      * `r` and `s` signature fields separately.
560      *
561      * _Available since v4.3._
562      */
563     function tryRecover(
564         bytes32 hash,
565         uint8 v,
566         bytes32 r,
567         bytes32 s
568     ) internal pure returns (address, RecoverError) {
569         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
570         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
571         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
572         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
573         //
574         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
575         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
576         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
577         // these malleable signatures as well.
578         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
579             return (address(0), RecoverError.InvalidSignatureS);
580         }
581         if (v != 27 && v != 28) {
582             return (address(0), RecoverError.InvalidSignatureV);
583         }
584 
585         // If the signature is valid (and not malleable), return the signer address
586         address signer = ecrecover(hash, v, r, s);
587         if (signer == address(0)) {
588             return (address(0), RecoverError.InvalidSignature);
589         }
590 
591         return (signer, RecoverError.NoError);
592     }
593 
594     /**
595      * @dev Overload of {ECDSA-recover} that receives the `v`,
596      * `r` and `s` signature fields separately.
597      */
598     function recover(
599         bytes32 hash,
600         uint8 v,
601         bytes32 r,
602         bytes32 s
603     ) internal pure returns (address) {
604         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
605         _throwError(error);
606         return recovered;
607     }
608 
609     /**
610      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
611      * produces hash corresponding to the one signed with the
612      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
613      * JSON-RPC method as part of EIP-191.
614      *
615      * See {recover}.
616      */
617     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
618         // 32 is the length in bytes of hash,
619         // enforced by the type signature above
620         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
621     }
622 
623     /**
624      * @dev Returns an Ethereum Signed Message, created from `s`. This
625      * produces hash corresponding to the one signed with the
626      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
627      * JSON-RPC method as part of EIP-191.
628      *
629      * See {recover}.
630      */
631     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
632         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
633     }
634 
635     /**
636      * @dev Returns an Ethereum Signed Typed Data, created from a
637      * `domainSeparator` and a `structHash`. This produces hash corresponding
638      * to the one signed with the
639      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
640      * JSON-RPC method as part of EIP-712.
641      *
642      * See {recover}.
643      */
644     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
645         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
646     }
647 }
648 
649 // File: @openzeppelin/contracts/utils/Address.sol
650 
651 
652 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Collection of functions related to the address type
658  */
659 library Address {
660     /**
661      * @dev Returns true if `account` is a contract.
662      *
663      * [IMPORTANT]
664      * ====
665      * It is unsafe to assume that an address for which this function returns
666      * false is an externally-owned account (EOA) and not a contract.
667      *
668      * Among others, `isContract` will return false for the following
669      * types of addresses:
670      *
671      *  - an externally-owned account
672      *  - a contract in construction
673      *  - an address where a contract will be created
674      *  - an address where a contract lived, but was destroyed
675      * ====
676      */
677     function isContract(address account) internal view returns (bool) {
678         // This method relies on extcodesize, which returns 0 for contracts in
679         // construction, since the code is only stored at the end of the
680         // constructor execution.
681 
682         uint256 size;
683         assembly {
684             size := extcodesize(account)
685         }
686         return size > 0;
687     }
688 
689     /**
690      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
691      * `recipient`, forwarding all available gas and reverting on errors.
692      *
693      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
694      * of certain opcodes, possibly making contracts go over the 2300 gas limit
695      * imposed by `transfer`, making them unable to receive funds via
696      * `transfer`. {sendValue} removes this limitation.
697      *
698      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
699      *
700      * IMPORTANT: because control is transferred to `recipient`, care must be
701      * taken to not create reentrancy vulnerabilities. Consider using
702      * {ReentrancyGuard} or the
703      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
704      */
705     function sendValue(address payable recipient, uint256 amount) internal {
706         require(address(this).balance >= amount, "Address: insufficient balance");
707 
708         (bool success, ) = recipient.call{value: amount}("");
709         require(success, "Address: unable to send value, recipient may have reverted");
710     }
711 
712     /**
713      * @dev Performs a Solidity function call using a low level `call`. A
714      * plain `call` is an unsafe replacement for a function call: use this
715      * function instead.
716      *
717      * If `target` reverts with a revert reason, it is bubbled up by this
718      * function (like regular Solidity function calls).
719      *
720      * Returns the raw returned data. To convert to the expected return value,
721      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
722      *
723      * Requirements:
724      *
725      * - `target` must be a contract.
726      * - calling `target` with `data` must not revert.
727      *
728      * _Available since v3.1._
729      */
730     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
731         return functionCall(target, data, "Address: low-level call failed");
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
736      * `errorMessage` as a fallback revert reason when `target` reverts.
737      *
738      * _Available since v3.1._
739      */
740     function functionCall(
741         address target,
742         bytes memory data,
743         string memory errorMessage
744     ) internal returns (bytes memory) {
745         return functionCallWithValue(target, data, 0, errorMessage);
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
750      * but also transferring `value` wei to `target`.
751      *
752      * Requirements:
753      *
754      * - the calling contract must have an ETH balance of at least `value`.
755      * - the called Solidity function must be `payable`.
756      *
757      * _Available since v3.1._
758      */
759     function functionCallWithValue(
760         address target,
761         bytes memory data,
762         uint256 value
763     ) internal returns (bytes memory) {
764         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
769      * with `errorMessage` as a fallback revert reason when `target` reverts.
770      *
771      * _Available since v3.1._
772      */
773     function functionCallWithValue(
774         address target,
775         bytes memory data,
776         uint256 value,
777         string memory errorMessage
778     ) internal returns (bytes memory) {
779         require(address(this).balance >= value, "Address: insufficient balance for call");
780         require(isContract(target), "Address: call to non-contract");
781 
782         (bool success, bytes memory returndata) = target.call{value: value}(data);
783         return verifyCallResult(success, returndata, errorMessage);
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
788      * but performing a static call.
789      *
790      * _Available since v3.3._
791      */
792     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
793         return functionStaticCall(target, data, "Address: low-level static call failed");
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
798      * but performing a static call.
799      *
800      * _Available since v3.3._
801      */
802     function functionStaticCall(
803         address target,
804         bytes memory data,
805         string memory errorMessage
806     ) internal view returns (bytes memory) {
807         require(isContract(target), "Address: static call to non-contract");
808 
809         (bool success, bytes memory returndata) = target.staticcall(data);
810         return verifyCallResult(success, returndata, errorMessage);
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
815      * but performing a delegate call.
816      *
817      * _Available since v3.4._
818      */
819     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
820         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
825      * but performing a delegate call.
826      *
827      * _Available since v3.4._
828      */
829     function functionDelegateCall(
830         address target,
831         bytes memory data,
832         string memory errorMessage
833     ) internal returns (bytes memory) {
834         require(isContract(target), "Address: delegate call to non-contract");
835 
836         (bool success, bytes memory returndata) = target.delegatecall(data);
837         return verifyCallResult(success, returndata, errorMessage);
838     }
839 
840     /**
841      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
842      * revert reason using the provided one.
843      *
844      * _Available since v4.3._
845      */
846     function verifyCallResult(
847         bool success,
848         bytes memory returndata,
849         string memory errorMessage
850     ) internal pure returns (bytes memory) {
851         if (success) {
852             return returndata;
853         } else {
854             // Look for revert reason and bubble it up if present
855             if (returndata.length > 0) {
856                 // The easiest way to bubble the revert reason is using memory via assembly
857 
858                 assembly {
859                     let returndata_size := mload(returndata)
860                     revert(add(32, returndata), returndata_size)
861                 }
862             } else {
863                 revert(errorMessage);
864             }
865         }
866     }
867 }
868 
869 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
870 
871 
872 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
873 
874 pragma solidity ^0.8.0;
875 
876 /**
877  * @title ERC721 token receiver interface
878  * @dev Interface for any contract that wants to support safeTransfers
879  * from ERC721 asset contracts.
880  */
881 interface IERC721Receiver {
882     /**
883      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
884      * by `operator` from `from`, this function is called.
885      *
886      * It must return its Solidity selector to confirm the token transfer.
887      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
888      *
889      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
890      */
891     function onERC721Received(
892         address operator,
893         address from,
894         uint256 tokenId,
895         bytes calldata data
896     ) external returns (bytes4);
897 }
898 
899 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
900 
901 
902 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
903 
904 pragma solidity ^0.8.0;
905 
906 /**
907  * @dev Interface of the ERC165 standard, as defined in the
908  * https://eips.ethereum.org/EIPS/eip-165[EIP].
909  *
910  * Implementers can declare support of contract interfaces, which can then be
911  * queried by others ({ERC165Checker}).
912  *
913  * For an implementation, see {ERC165}.
914  */
915 interface IERC165 {
916     /**
917      * @dev Returns true if this contract implements the interface defined by
918      * `interfaceId`. See the corresponding
919      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
920      * to learn more about how these ids are created.
921      *
922      * This function call must use less than 30 000 gas.
923      */
924     function supportsInterface(bytes4 interfaceId) external view returns (bool);
925 }
926 
927 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
928 
929 
930 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
931 
932 pragma solidity ^0.8.0;
933 
934 
935 /**
936  * @dev Implementation of the {IERC165} interface.
937  *
938  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
939  * for the additional interface id that will be supported. For example:
940  *
941  * ```solidity
942  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
943  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
944  * }
945  * ```
946  *
947  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
948  */
949 abstract contract ERC165 is IERC165 {
950     /**
951      * @dev See {IERC165-supportsInterface}.
952      */
953     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
954         return interfaceId == type(IERC165).interfaceId;
955     }
956 }
957 
958 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
959 
960 
961 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
962 
963 pragma solidity ^0.8.0;
964 
965 
966 /**
967  * @dev Required interface of an ERC721 compliant contract.
968  */
969 interface IERC721 is IERC165 {
970     /**
971      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
972      */
973     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
974 
975     /**
976      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
977      */
978     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
979 
980     /**
981      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
982      */
983     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
984 
985     /**
986      * @dev Returns the number of tokens in ``owner``'s account.
987      */
988     function balanceOf(address owner) external view returns (uint256 balance);
989 
990     /**
991      * @dev Returns the owner of the `tokenId` token.
992      *
993      * Requirements:
994      *
995      * - `tokenId` must exist.
996      */
997     function ownerOf(uint256 tokenId) external view returns (address owner);
998 
999     /**
1000      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1001      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1002      *
1003      * Requirements:
1004      *
1005      * - `from` cannot be the zero address.
1006      * - `to` cannot be the zero address.
1007      * - `tokenId` token must exist and be owned by `from`.
1008      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1009      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1010      *
1011      * Emits a {Transfer} event.
1012      */
1013     function safeTransferFrom(
1014         address from,
1015         address to,
1016         uint256 tokenId
1017     ) external;
1018 
1019     /**
1020      * @dev Transfers `tokenId` token from `from` to `to`.
1021      *
1022      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1023      *
1024      * Requirements:
1025      *
1026      * - `from` cannot be the zero address.
1027      * - `to` cannot be the zero address.
1028      * - `tokenId` token must be owned by `from`.
1029      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1030      *
1031      * Emits a {Transfer} event.
1032      */
1033     function transferFrom(
1034         address from,
1035         address to,
1036         uint256 tokenId
1037     ) external;
1038 
1039     /**
1040      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1041      * The approval is cleared when the token is transferred.
1042      *
1043      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1044      *
1045      * Requirements:
1046      *
1047      * - The caller must own the token or be an approved operator.
1048      * - `tokenId` must exist.
1049      *
1050      * Emits an {Approval} event.
1051      */
1052     function approve(address to, uint256 tokenId) external;
1053 
1054     /**
1055      * @dev Returns the account approved for `tokenId` token.
1056      *
1057      * Requirements:
1058      *
1059      * - `tokenId` must exist.
1060      */
1061     function getApproved(uint256 tokenId) external view returns (address operator);
1062 
1063     /**
1064      * @dev Approve or remove `operator` as an operator for the caller.
1065      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1066      *
1067      * Requirements:
1068      *
1069      * - The `operator` cannot be the caller.
1070      *
1071      * Emits an {ApprovalForAll} event.
1072      */
1073     function setApprovalForAll(address operator, bool _approved) external;
1074 
1075     /**
1076      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1077      *
1078      * See {setApprovalForAll}
1079      */
1080     function isApprovedForAll(address owner, address operator) external view returns (bool);
1081 
1082     /**
1083      * @dev Safely transfers `tokenId` token from `from` to `to`.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must exist and be owned by `from`.
1090      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1091      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1092      *
1093      * Emits a {Transfer} event.
1094      */
1095     function safeTransferFrom(
1096         address from,
1097         address to,
1098         uint256 tokenId,
1099         bytes calldata data
1100     ) external;
1101 }
1102 
1103 // File: contracts/IERC721Enumerable.sol
1104 
1105 
1106 
1107 pragma solidity ^0.8.0;
1108 
1109 
1110 /**
1111  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1112  * @dev See https://eips.ethereum.org/EIPS/eip-721
1113  */
1114 interface IERC721Enumerable is IERC721 {
1115     /**
1116      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1117      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1118      */
1119     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1120 }
1121 
1122 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1123 
1124 
1125 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1126 
1127 pragma solidity ^0.8.0;
1128 
1129 
1130 /**
1131  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1132  * @dev See https://eips.ethereum.org/EIPS/eip-721
1133  */
1134 interface IERC721Metadata is IERC721 {
1135     /**
1136      * @dev Returns the token collection name.
1137      */
1138     function name() external view returns (string memory);
1139 
1140     /**
1141      * @dev Returns the token collection symbol.
1142      */
1143     function symbol() external view returns (string memory);
1144 
1145     /**
1146      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1147      */
1148     function tokenURI(uint256 tokenId) external view returns (string memory);
1149 }
1150 
1151 // File: @openzeppelin/contracts/utils/Context.sol
1152 
1153 
1154 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
1155 
1156 pragma solidity ^0.8.0;
1157 
1158 /**
1159  * @dev Provides information about the current execution context, including the
1160  * sender of the transaction and its data. While these are generally available
1161  * via msg.sender and msg.data, they should not be accessed in such a direct
1162  * manner, since when dealing with meta-transactions the account sending and
1163  * paying for execution may not be the actual sender (as far as an application
1164  * is concerned).
1165  *
1166  * This contract is only required for intermediate, library-like contracts.
1167  */
1168 abstract contract Context {
1169     function _msgSender() internal view virtual returns (address) {
1170         return msg.sender;
1171     }
1172 
1173     function _msgData() internal view virtual returns (bytes calldata) {
1174         return msg.data;
1175     }
1176 }
1177 
1178 // File: contracts/ERC721.sol
1179 
1180 
1181 
1182 pragma solidity ^0.8.0;
1183 
1184 
1185 
1186 
1187 
1188 
1189 
1190 
1191 /**
1192  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1193  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1194  * {ERC721Enumerable}.
1195  */
1196 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1197     using Address for address;
1198     using Strings for uint256;
1199 
1200     // Token name
1201     string private _name;
1202 
1203     // Token symbol
1204     string private _symbol;
1205 
1206     // Mapping from token ID to owner address
1207     mapping(uint256 => address) private _owners;
1208 
1209     // Mapping owner address to token count
1210     mapping(address => uint256) private _balances;
1211 
1212     // Mapping from token ID to approved address
1213     mapping(uint256 => address) private _tokenApprovals;
1214 
1215     // Mapping from owner to operator approvals
1216     mapping(address => mapping(address => bool)) private _operatorApprovals;
1217 
1218     /**
1219      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1220      */
1221     constructor(string memory name_, string memory symbol_) {
1222         _name = name_;
1223         _symbol = symbol_;
1224     }
1225 
1226     /**
1227      * @dev See {IERC165-supportsInterface}.
1228      */
1229     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1230         return
1231         interfaceId == type(IERC721).interfaceId ||
1232         interfaceId == type(IERC721Metadata).interfaceId ||
1233         super.supportsInterface(interfaceId);
1234     }
1235 
1236     /**
1237      * @dev See {IERC721-balanceOf}.
1238      */
1239     function balanceOf(address owner) public view virtual override returns (uint256) {
1240         require(owner != address(0), "ERC721: balance query for the zero address");
1241         return _balances[owner];
1242     }
1243 
1244     /**
1245      * @dev See {IERC721-ownerOf}.
1246      */
1247     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1248         address owner = _owners[tokenId];
1249         require(owner != address(0), "ERC721: owner query for nonexistent token");
1250         return owner;
1251     }
1252 
1253     /**
1254      * @dev Edit for rawOwnerOf token
1255      */
1256     function rawOwnerOf(uint256 tokenId) public view returns (address) {
1257         return _owners[tokenId];
1258     }
1259 
1260     /**
1261      * @dev See {IERC721Metadata-name}.
1262      */
1263     function name() public view virtual override returns (string memory) {
1264         return _name;
1265     }
1266 
1267     /**
1268      * @dev See {IERC721Metadata-symbol}.
1269      */
1270     function symbol() public view virtual override returns (string memory) {
1271         return _symbol;
1272     }
1273 
1274     /**
1275      * @dev See {IERC721Metadata-tokenURI}.
1276      */
1277     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1278         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1279 
1280         string memory baseURI = _baseURI();
1281         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1282     }
1283 
1284     /**
1285      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1286      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1287      * by default, can be overriden in child contracts.
1288      */
1289     function _baseURI() internal view virtual returns (string memory) {
1290         return "";
1291     }
1292 
1293     /**
1294      * @dev See {IERC721-approve}.
1295      */
1296     function approve(address to, uint256 tokenId) public virtual override {
1297         address owner = ERC721.ownerOf(tokenId);
1298         require(to != owner, "ERC721: approval to current owner");
1299 
1300         require(
1301             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1302             "ERC721: approve caller is not owner nor approved for all"
1303         );
1304 
1305         _approve(to, tokenId);
1306     }
1307 
1308     /**
1309      * @dev See {IERC721-getApproved}.
1310      */
1311     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1312         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1313 
1314         return _tokenApprovals[tokenId];
1315     }
1316 
1317     /**
1318      * @dev See {IERC721-setApprovalForAll}.
1319      */
1320     function setApprovalForAll(address operator, bool approved) public virtual override {
1321         require(operator != _msgSender(), "ERC721: approve to caller");
1322 
1323         _operatorApprovals[_msgSender()][operator] = approved;
1324         emit ApprovalForAll(_msgSender(), operator, approved);
1325     }
1326 
1327     /**
1328      * @dev See {IERC721-isApprovedForAll}.
1329      */
1330     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1331         return _operatorApprovals[owner][operator];
1332     }
1333 
1334     /**
1335      * @dev See {IERC721-transferFrom}.
1336      */
1337     function transferFrom(
1338         address from,
1339         address to,
1340         uint256 tokenId
1341     ) public virtual override {
1342         //solhint-disable-next-line max-line-length
1343         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1344 
1345         _transfer(from, to, tokenId);
1346     }
1347 
1348     /**
1349      * @dev See {IERC721-safeTransferFrom}.
1350      */
1351     function safeTransferFrom(
1352         address from,
1353         address to,
1354         uint256 tokenId
1355     ) public virtual override {
1356         safeTransferFrom(from, to, tokenId, "");
1357     }
1358 
1359     /**
1360      * @dev See {IERC721-safeTransferFrom}.
1361      */
1362     function safeTransferFrom(
1363         address from,
1364         address to,
1365         uint256 tokenId,
1366         bytes memory _data
1367     ) public virtual override {
1368         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1369         _safeTransfer(from, to, tokenId, _data);
1370     }
1371 
1372     /**
1373      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1374      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1375      *
1376      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1377      *
1378      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1379      * implement alternative mechanisms to perform token transfer, such as signature-based.
1380      *
1381      * Requirements:
1382      *
1383      * - `from` cannot be the zero address.
1384      * - `to` cannot be the zero address.
1385      * - `tokenId` token must exist and be owned by `from`.
1386      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1387      *
1388      * Emits a {Transfer} event.
1389      */
1390     function _safeTransfer(
1391         address from,
1392         address to,
1393         uint256 tokenId,
1394         bytes memory _data
1395     ) internal virtual {
1396         _transfer(from, to, tokenId);
1397         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1398     }
1399 
1400     /**
1401      * @dev Returns whether `tokenId` exists.
1402      *
1403      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1404      *
1405      * Tokens start existing when they are minted (`_mint`),
1406      * and stop existing when they are burned (`_burn`).
1407      */
1408     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1409         return _owners[tokenId] != address(0);
1410     }
1411 
1412     /**
1413      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1414      *
1415      * Requirements:
1416      *
1417      * - `tokenId` must exist.
1418      */
1419     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1420         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1421         address owner = ERC721.ownerOf(tokenId);
1422         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1423     }
1424 
1425     /**
1426      * @dev Safely mints `tokenId` and transfers it to `to`.
1427      *
1428      * Requirements:
1429      *
1430      * - `tokenId` must not exist.
1431      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1432      *
1433      * Emits a {Transfer} event.
1434      */
1435     function _safeMint(address to, uint256 tokenId) internal virtual {
1436         _safeMint(to, tokenId, "");
1437     }
1438 
1439     /**
1440      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1441      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1442      */
1443     function _safeMint(
1444         address to,
1445         uint256 tokenId,
1446         bytes memory _data
1447     ) internal virtual {
1448         _mint(to, tokenId);
1449         require(
1450             _checkOnERC721Received(address(0), to, tokenId, _data),
1451             "ERC721: transfer to non ERC721Receiver implementer"
1452         );
1453     }
1454 
1455     /**
1456      * @dev Mints `tokenId` and transfers it to `to`.
1457      *
1458      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1459      *
1460      * Requirements:
1461      *
1462      * - `tokenId` must not exist.
1463      * - `to` cannot be the zero address.
1464      *
1465      * Emits a {Transfer} event.
1466      */
1467     function _mint(address to, uint256 tokenId) internal virtual {
1468         require(to != address(0), "ERC721: mint to the zero address");
1469         require(!_exists(tokenId), "ERC721: token already minted");
1470 
1471         _beforeTokenTransfer(address(0), to, tokenId);
1472 
1473         _balances[to] += 1;
1474         _owners[tokenId] = to;
1475 
1476         emit Transfer(address(0), to, tokenId);
1477     }
1478 
1479     /**
1480      * @dev Destroys `tokenId`.
1481      * The approval is cleared when the token is burned.
1482      *
1483      * Requirements:
1484      *
1485      * - `tokenId` must exist.
1486      *
1487      * Emits a {Transfer} event.
1488      */
1489     function _burn(uint256 tokenId) internal virtual {
1490         address owner = ERC721.ownerOf(tokenId);
1491         address to = address(0);
1492 
1493         _beforeTokenTransfer(owner, to, tokenId);
1494 
1495         // Clear approvals
1496         _approve(address(0), tokenId);
1497 
1498         _balances[owner] -= 1;
1499         delete _owners[tokenId];
1500 
1501         emit Transfer(owner, to, tokenId);
1502     }
1503 
1504     /**
1505      * @dev Transfers `tokenId` from `from` to `to`.
1506      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1507      *
1508      * Requirements:
1509      *
1510      * - `to` cannot be the zero address.
1511      * - `tokenId` token must be owned by `from`.
1512      *
1513      * Emits a {Transfer} event.
1514      */
1515     function _transfer(
1516         address from,
1517         address to,
1518         uint256 tokenId
1519     ) internal virtual {
1520         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1521         require(to != address(0), "ERC721: transfer to the zero address");
1522 
1523         _beforeTokenTransfer(from, to, tokenId);
1524 
1525         // Clear approvals from the previous owner
1526         _approve(address(0), tokenId);
1527 
1528         _balances[from] -= 1;
1529         _balances[to] += 1;
1530         _owners[tokenId] = to;
1531 
1532         emit Transfer(from, to, tokenId);
1533     }
1534 
1535     /**
1536      * @dev Approve `to` to operate on `tokenId`
1537      *
1538      * Emits a {Approval} event.
1539      */
1540     function _approve(address to, uint256 tokenId) internal virtual {
1541         _tokenApprovals[tokenId] = to;
1542         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1543     }
1544 
1545     /**
1546      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1547      * The call is not executed if the target address is not a contract.
1548      *
1549      * @param from address representing the previous owner of the given token ID
1550      * @param to target address that will receive the tokens
1551      * @param tokenId uint256 ID of the token to be transferred
1552      * @param _data bytes optional data to send along with the call
1553      * @return bool whether the call correctly returned the expected magic value
1554      */
1555     function _checkOnERC721Received(
1556         address from,
1557         address to,
1558         uint256 tokenId,
1559         bytes memory _data
1560     ) private returns (bool) {
1561         if (to.isContract()) {
1562             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1563                 return retval == IERC721Receiver(to).onERC721Received.selector;
1564             } catch (bytes memory reason) {
1565                 if (reason.length == 0) {
1566                     revert("ERC721: transfer to non ERC721Receiver implementer");
1567                 } else {
1568                     assembly {
1569                         revert(add(32, reason), mload(reason))
1570                     }
1571                 }
1572             }
1573         } else {
1574             return true;
1575         }
1576     }
1577 
1578     /**
1579      * @dev Hook that is called before any token transfer. This includes minting
1580      * and burning.
1581      *
1582      * Calling conditions:
1583      *
1584      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1585      * transferred to `to`.
1586      * - When `from` is zero, `tokenId` will be minted for `to`.
1587      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1588      * - `from` and `to` are never both zero.
1589      *
1590      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1591      */
1592     function _beforeTokenTransfer(
1593         address from,
1594         address to,
1595         uint256 tokenId
1596     ) internal virtual {}
1597 }
1598 // File: contracts/ERC721Enumerable.sol
1599 
1600 
1601 
1602 pragma solidity ^0.8.4;
1603 
1604 
1605 /**
1606  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1607  * enumerability of all the token ids in the contract as well as all token ids owned by each
1608  * account.
1609  */
1610 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1611     // Mapping from owner to list of owned token IDs
1612     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1613 
1614     // Mapping from token ID to index of the owner tokens list
1615     mapping(uint256 => uint256) private _ownedTokensIndex;
1616 
1617     /**
1618      * @dev See {IERC165-supportsInterface}.
1619      */
1620     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1621         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1622     }
1623 
1624     /**
1625      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1626      */
1627     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1628         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1629         return _ownedTokens[owner][index];
1630     }
1631 
1632     /**
1633      * @dev Hook that is called before any token transfer. This includes minting
1634      * and burning.
1635      *
1636      * Calling conditions:
1637      *
1638      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1639      * transferred to `to`.
1640      * - When `from` is zero, `tokenId` will be minted for `to`.
1641      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1642      * - `from` cannot be the zero address.
1643      * - `to` cannot be the zero address.
1644      *
1645      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1646      */
1647     function _beforeTokenTransfer(
1648         address from,
1649         address to,
1650         uint256 tokenId
1651     ) internal virtual override {
1652         super._beforeTokenTransfer(from, to, tokenId);
1653         if (from != to && from != address(0)) {
1654             _removeTokenFromOwnerEnumeration(from, tokenId);
1655         }
1656         if (to != from && to != address(0)) {
1657             _addTokenToOwnerEnumeration(to, tokenId);
1658         }
1659     }
1660 
1661     /**
1662      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1663      * @param to address representing the new owner of the given token ID
1664      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1665      */
1666     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1667         uint256 length = ERC721.balanceOf(to);
1668         _ownedTokens[to][length] = tokenId;
1669         _ownedTokensIndex[tokenId] = length;
1670     }
1671 
1672     /**
1673      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1674      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1675      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1676      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1677      * @param from address representing the previous owner of the given token ID
1678      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1679      */
1680     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1681         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1682         // then delete the last slot (swap and pop).
1683 
1684         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1685         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1686 
1687         // When the token to delete is the last token, the swap operation is unnecessary
1688         if (tokenIndex != lastTokenIndex) {
1689             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1690 
1691             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1692             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1693         }
1694 
1695         // This also deletes the contents at the last position of the array
1696         delete _ownedTokensIndex[tokenId];
1697         delete _ownedTokens[from][lastTokenIndex];
1698     }
1699 
1700 }
1701 // File: @openzeppelin/contracts/access/Ownable.sol
1702 
1703 
1704 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
1705 
1706 pragma solidity ^0.8.0;
1707 
1708 
1709 /**
1710  * @dev Contract module which provides a basic access control mechanism, where
1711  * there is an account (an owner) that can be granted exclusive access to
1712  * specific functions.
1713  *
1714  * By default, the owner account will be the one that deploys the contract. This
1715  * can later be changed with {transferOwnership}.
1716  *
1717  * This module is used through inheritance. It will make available the modifier
1718  * `onlyOwner`, which can be applied to your functions to restrict their use to
1719  * the owner.
1720  */
1721 abstract contract Ownable is Context {
1722     address private _owner;
1723 
1724     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1725 
1726     /**
1727      * @dev Initializes the contract setting the deployer as the initial owner.
1728      */
1729     constructor() {
1730         _transferOwnership(_msgSender());
1731     }
1732 
1733     /**
1734      * @dev Returns the address of the current owner.
1735      */
1736     function owner() public view virtual returns (address) {
1737         return _owner;
1738     }
1739 
1740     /**
1741      * @dev Throws if called by any account other than the owner.
1742      */
1743     modifier onlyOwner() {
1744         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1745         _;
1746     }
1747 
1748     /**
1749      * @dev Leaves the contract without owner. It will not be possible to call
1750      * `onlyOwner` functions anymore. Can only be called by the current owner.
1751      *
1752      * NOTE: Renouncing ownership will leave the contract without an owner,
1753      * thereby removing any functionality that is only available to the owner.
1754      */
1755     function renounceOwnership() public virtual onlyOwner {
1756         _transferOwnership(address(0));
1757     }
1758 
1759     /**
1760      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1761      * Can only be called by the current owner.
1762      */
1763     function transferOwnership(address newOwner) public virtual onlyOwner {
1764         require(newOwner != address(0), "Ownable: new owner is the zero address");
1765         _transferOwnership(newOwner);
1766     }
1767 
1768     /**
1769      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1770      * Internal function without access restriction.
1771      */
1772     function _transferOwnership(address newOwner) internal virtual {
1773         address oldOwner = _owner;
1774         _owner = newOwner;
1775         emit OwnershipTransferred(oldOwner, newOwner);
1776     }
1777 }
1778 
1779 // File: contracts/ControlledAccess.sol
1780 
1781 
1782 pragma solidity ^0.8.4;
1783 
1784 
1785 /* @title ControlledAccess
1786  * @dev The ControlledAccess contract allows function to be restricted to users
1787  * that possess a signed authorization from the owner of the contract. This signed
1788  * message includes the user to give permission to and the contract address to prevent
1789  * reusing the same authorization message on different contract with same owner.
1790  */
1791 
1792 contract ControlledAccess is Ownable {
1793     /*
1794      * @dev Requires msg.sender to have valid access message.
1795      * @param _v ECDSA signature parameter v.
1796      * @param _r ECDSA signature parameters r.
1797      * @param _s ECDSA signature parameters s.
1798      */
1799     modifier onlyValidAccess(
1800         uint8 _v,
1801         bytes32 _r,
1802         bytes32 _s
1803     ) {
1804         require(isValidAccessMessage(msg.sender, _v, _r, _s), "Access Denied");
1805         _;
1806     }
1807 
1808     /*
1809      * @dev Verifies if message was signed by owner to give access to _add for this contract.
1810      *      Assumes Geth signature prefix.
1811      * @param _add Address of agent with access
1812      * @param _v ECDSA signature parameter v.
1813      * @param _r ECDSA signature parameters r.
1814      * @param _s ECDSA signature parameters s.
1815      * @return Validity of access message for a given address.
1816      */
1817     function isValidAccessMessage(
1818         address _add,
1819         uint8 _v,
1820         bytes32 _r,
1821         bytes32 _s
1822     ) public view returns (bool) {
1823         bytes32 hash = keccak256(abi.encodePacked(_add));
1824         address sender = ecrecover(
1825             keccak256(
1826                 abi.encodePacked("\x19Ethereum Signed Message:\n32", hash)
1827             ),
1828             _v,
1829             _r,
1830             _s
1831         );
1832         return (owner() == sender);
1833     }
1834 }
1835 
1836 // File: contracts/NFT.sol
1837 
1838 
1839 
1840 /**
1841     IMPORTANT NOTICE:
1842     This smart contract was written and deployed by the software engineers at 
1843     https://highstack.co in a contractor capacity.
1844     
1845     Highstack is not responsible for any malicious use or losses arising from using 
1846     or interacting with this smart contract.
1847 
1848     THIS CONTRACT IS PROVIDED ON AN “AS IS” BASIS. USE THIS SOFTWARE AT YOUR OWN RISK.
1849     THERE IS NO WARRANTY, EXPRESSED OR IMPLIED, THAT DESCRIBED FUNCTIONALITY WILL 
1850     FUNCTION AS EXPECTED OR INTENDED. PRODUCT MAY CEASE TO EXIST. NOT AN INVESTMENT, 
1851     SECURITY OR A SWAP. TOKENS HAVE NO RIGHTS, USES, PURPOSE, ATTRIBUTES, 
1852     FUNCTIONALITIES OR FEATURES, EXPRESS OR IMPLIED, INCLUDING, WITHOUT LIMITATION, ANY
1853     USES, PURPOSE OR ATTRIBUTES. TOKENS MAY HAVE NO VALUE. PRODUCT MAY CONTAIN BUGS AND
1854     SERIOUS BREACHES IN THE SECURITY THAT MAY RESULT IN LOSS OF YOUR ASSETS OR THEIR 
1855     IMPLIED VALUE. ALL THE CRYPTOCURRENCY TRANSFERRED TO THIS SMART CONTRACT MAY BE LOST.
1856     THE CONTRACT DEVLOPERS ARE NOT RESPONSIBLE FOR ANY MONETARY LOSS, PROFIT LOSS OR ANY
1857     OTHER LOSSES DUE TO USE OF DESCRIBED PRODUCT. CHANGES COULD BE MADE BEFORE AND AFTER
1858     THE RELEASE OF THE PRODUCT. NO PRIOR NOTICE MAY BE GIVEN. ALL TRANSACTION ON THE 
1859     BLOCKCHAIN ARE FINAL, NO REFUND, COMPENSATION OR REIMBURSEMENT POSSIBLE. YOU MAY 
1860     LOOSE ALL THE CRYPTOCURRENCY USED TO INTERACT WITH THIS CONTRACT. IT IS YOUR 
1861     RESPONSIBILITY TO REVIEW THE PROJECT, TEAM, TERMS & CONDITIONS BEFORE USING THE 
1862     PRODUCT.
1863 
1864 **/
1865 
1866 pragma solidity ^0.8.4;
1867 
1868 
1869 
1870 
1871 
1872 
1873 
1874 
1875 
1876 contract MarenDAO is
1877     ERC721Enumerable,
1878     Ownable,
1879     ReentrancyGuard,
1880     ControlledAccess
1881 {
1882     using ECDSA for bytes32;
1883     using SafeMath for uint256;
1884     using Counters for Counters.Counter;
1885     using Strings for *;
1886 
1887     uint256 public publicStart = 1642561200; // 7PM Pacific time.
1888 
1889     string private EMPTY_STRING = "";
1890 
1891     uint256 public MAX_ELEMENTS = 666;
1892     uint256 public PRICE = 0 ether;
1893 
1894     uint256 public maxMint = 3;
1895 
1896     address payable devAddress;
1897     uint256 private devFee;
1898 
1899     bool private PAUSE = true;
1900 
1901     Counters.Counter private _tokenIdTracker;
1902 
1903     struct BaseTokenUriById {
1904         uint256 startId;
1905         uint256 endId;
1906         string baseURI;
1907     }
1908 
1909     BaseTokenUriById[] public baseTokenUris;
1910 
1911     event PauseEvent(bool pause);
1912     event welcomeToKingShiba(uint256 indexed id);
1913 
1914     modifier saleIsOpen() {
1915         require(totalSupply() <= MAX_ELEMENTS, "Soldout!");
1916         require(!PAUSE, "Sales not open");
1917         _;
1918     }
1919 
1920     constructor(
1921         string memory name,
1922         string memory ticker
1923     ) ERC721(name, ticker) {
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
2008     function getUnsoldTokens(uint256 offset, uint256 limit)
2009         external
2010         view
2011         returns (uint256[] memory)
2012     {
2013         uint256[] memory tokens = new uint256[](limit);
2014         for (uint256 i = 0; i < limit; i++) {
2015             uint256 key = i + offset;
2016             if (rawOwnerOf(key) == address(0)) {
2017                 tokens[i] = key;
2018             }
2019         }
2020         return tokens;
2021     }
2022 
2023     function tokenURI(uint256 tokenId)
2024         public
2025         view
2026         virtual
2027         override
2028         returns (string memory)
2029     {
2030         uint256 length = baseTokenUris.length;
2031         for (uint256 interval = 0; interval < length; ++interval) {
2032             BaseTokenUriById storage baseTokenUri = baseTokenUris[interval];
2033             if (
2034                 baseTokenUri.startId <= tokenId && baseTokenUri.endId >= tokenId
2035             ) {
2036                 return
2037                     string(
2038                         abi.encodePacked(
2039                             baseTokenUri.baseURI,
2040                             tokenId.toString(),
2041                             ".json"
2042                         )
2043                     );
2044             }
2045         }
2046         return "";
2047     }
2048 
2049     function totalSupply() public view returns (uint256) {
2050         return _tokenIdTracker.current();
2051     }
2052 
2053     function price(uint256 _count) public view returns (uint256) {
2054         return PRICE.mul(_count);
2055     }
2056 
2057     function _mintAmount(uint256 amount, address wallet) private {
2058         for (uint8 i = 0; i < amount; i++) {
2059             while (
2060                 !(rawOwnerOf(_tokenIdTracker.current().add(1)) == address(0))
2061             ) {
2062                 _tokenIdTracker.increment();
2063             }
2064             _mintAnElement(wallet);
2065         }
2066     }
2067 
2068     function _mintAnElement(address _to) private {
2069         _tokenIdTracker.increment();
2070         _safeMint(_to, _tokenIdTracker.current());
2071         emit welcomeToKingShiba(_tokenIdTracker.current());
2072     }
2073 
2074     function walletOfOwner(address _owner)
2075         external
2076         view
2077         returns (uint256[] memory)
2078     {
2079         uint256 tokenCount = balanceOf(_owner);
2080 
2081         uint256[] memory tokensId = new uint256[](tokenCount);
2082         for (uint256 i = 0; i < tokenCount; i++) {
2083             tokensId[i] = tokenOfOwnerByIndex(_owner, i);
2084         }
2085 
2086         return tokensId;
2087     }
2088 
2089     function _withdraw(address _address, uint256 _amount) private {
2090         (bool success, ) = _address.call{value: _amount}("");
2091         require(success, "Transfer failed.");
2092     }
2093 }