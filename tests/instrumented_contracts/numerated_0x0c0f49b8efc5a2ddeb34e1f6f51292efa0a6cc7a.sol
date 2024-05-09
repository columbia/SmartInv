1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 // CAUTION
9 // This version of SafeMath should only be used with Solidity 0.8 or later,
10 // because it relies on the compiler's built in overflow checks.
11 
12 /**
13  * @dev Wrappers over Solidity's arithmetic operations.
14  *
15  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
16  * now has built in overflow checking.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         unchecked {
26             uint256 c = a + b;
27             if (c < a) return (false, 0);
28             return (true, c);
29         }
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         unchecked {
39             if (b > a) return (false, 0);
40             return (true, a - b);
41         }
42     }
43 
44     /**
45      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
46      *
47      * _Available since v3.4._
48      */
49     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
50         unchecked {
51             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
52             // benefit is lost if 'b' is also tested.
53             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
54             if (a == 0) return (true, 0);
55             uint256 c = a * b;
56             if (c / a != b) return (false, 0);
57             return (true, c);
58         }
59     }
60 
61     /**
62      * @dev Returns the division of two unsigned integers, with a division by zero flag.
63      *
64      * _Available since v3.4._
65      */
66     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
67         unchecked {
68             if (b == 0) return (false, 0);
69             return (true, a / b);
70         }
71     }
72 
73     /**
74      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
75      *
76      * _Available since v3.4._
77      */
78     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
79         unchecked {
80             if (b == 0) return (false, 0);
81             return (true, a % b);
82         }
83     }
84 
85     /**
86      * @dev Returns the addition of two unsigned integers, reverting on
87      * overflow.
88      *
89      * Counterpart to Solidity's `+` operator.
90      *
91      * Requirements:
92      *
93      * - Addition cannot overflow.
94      */
95     function add(uint256 a, uint256 b) internal pure returns (uint256) {
96         return a + b;
97     }
98 
99     /**
100      * @dev Returns the subtraction of two unsigned integers, reverting on
101      * overflow (when the result is negative).
102      *
103      * Counterpart to Solidity's `-` operator.
104      *
105      * Requirements:
106      *
107      * - Subtraction cannot overflow.
108      */
109     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
110         return a - b;
111     }
112 
113     /**
114      * @dev Returns the multiplication of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `*` operator.
118      *
119      * Requirements:
120      *
121      * - Multiplication cannot overflow.
122      */
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         return a * b;
125     }
126 
127     /**
128      * @dev Returns the integer division of two unsigned integers, reverting on
129      * division by zero. The result is rounded towards zero.
130      *
131      * Counterpart to Solidity's `/` operator.
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         return a / b;
139     }
140 
141     /**
142      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
143      * reverting when dividing by zero.
144      *
145      * Counterpart to Solidity's `%` operator. This function uses a `revert`
146      * opcode (which leaves remaining gas untouched) while Solidity uses an
147      * invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(
171         uint256 a,
172         uint256 b,
173         string memory errorMessage
174     ) internal pure returns (uint256) {
175         unchecked {
176             require(b <= a, errorMessage);
177             return a - b;
178         }
179     }
180 
181     /**
182      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
183      * division by zero. The result is rounded towards zero.
184      *
185      * Counterpart to Solidity's `/` operator. Note: this function uses a
186      * `revert` opcode (which leaves remaining gas untouched) while Solidity
187      * uses an invalid opcode to revert (consuming all remaining gas).
188      *
189      * Requirements:
190      *
191      * - The divisor cannot be zero.
192      */
193     function div(
194         uint256 a,
195         uint256 b,
196         string memory errorMessage
197     ) internal pure returns (uint256) {
198         unchecked {
199             require(b > 0, errorMessage);
200             return a / b;
201         }
202     }
203 
204     /**
205      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
206      * reverting with custom message when dividing by zero.
207      *
208      * CAUTION: This function is deprecated because it requires allocating memory for the error
209      * message unnecessarily. For custom revert reasons use {tryMod}.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(
220         uint256 a,
221         uint256 b,
222         string memory errorMessage
223     ) internal pure returns (uint256) {
224         unchecked {
225             require(b > 0, errorMessage);
226             return a % b;
227         }
228     }
229 }
230 
231 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol
232 
233 
234 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
235 
236 pragma solidity ^0.8.0;
237 
238 /**
239  * @title Counters
240  * @author Matt Condon (@shrugs)
241  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
242  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
243  *
244  * Include with `using Counters for Counters.Counter;`
245  */
246 library Counters {
247     struct Counter {
248         // This variable should never be directly accessed by users of the library: interactions must be restricted to
249         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
250         // this feature: see https://github.com/ethereum/solidity/issues/4637
251         uint256 _value; // default: 0
252     }
253 
254     function current(Counter storage counter) internal view returns (uint256) {
255         return counter._value;
256     }
257 
258     function increment(Counter storage counter) internal {
259         unchecked {
260             counter._value += 1;
261         }
262     }
263 
264     function decrement(Counter storage counter) internal {
265         uint256 value = counter._value;
266         require(value > 0, "Counter: decrement overflow");
267         unchecked {
268             counter._value = value - 1;
269         }
270     }
271 
272     function reset(Counter storage counter) internal {
273         counter._value = 0;
274     }
275 }
276 
277 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/security/ReentrancyGuard.sol
278 
279 
280 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
281 
282 pragma solidity ^0.8.0;
283 
284 /**
285  * @dev Contract module that helps prevent reentrant calls to a function.
286  *
287  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
288  * available, which can be applied to functions to make sure there are no nested
289  * (reentrant) calls to them.
290  *
291  * Note that because there is a single `nonReentrant` guard, functions marked as
292  * `nonReentrant` may not call one another. This can be worked around by making
293  * those functions `private`, and then adding `external` `nonReentrant` entry
294  * points to them.
295  *
296  * TIP: If you would like to learn more about reentrancy and alternative ways
297  * to protect against it, check out our blog post
298  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
299  */
300 abstract contract ReentrancyGuard {
301     // Booleans are more expensive than uint256 or any type that takes up a full
302     // word because each write operation emits an extra SLOAD to first read the
303     // slot's contents, replace the bits taken up by the boolean, and then write
304     // back. This is the compiler's defense against contract upgrades and
305     // pointer aliasing, and it cannot be disabled.
306 
307     // The values being non-zero value makes deployment a bit more expensive,
308     // but in exchange the refund on every call to nonReentrant will be lower in
309     // amount. Since refunds are capped to a percentage of the total
310     // transaction's gas, it is best to keep them low in cases like this one, to
311     // increase the likelihood of the full refund coming into effect.
312     uint256 private constant _NOT_ENTERED = 1;
313     uint256 private constant _ENTERED = 2;
314 
315     uint256 private _status;
316 
317     constructor() {
318         _status = _NOT_ENTERED;
319     }
320 
321     /**
322      * @dev Prevents a contract from calling itself, directly or indirectly.
323      * Calling a `nonReentrant` function from another `nonReentrant`
324      * function is not supported. It is possible to prevent this from happening
325      * by making the `nonReentrant` function external, and making it call a
326      * `private` function that does the actual work.
327      */
328     modifier nonReentrant() {
329         // On the first call to nonReentrant, _notEntered will be true
330         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
331 
332         // Any calls to nonReentrant after this point will fail
333         _status = _ENTERED;
334 
335         _;
336 
337         // By storing the original value once again, a refund is triggered (see
338         // https://eips.ethereum.org/EIPS/eip-2200)
339         _status = _NOT_ENTERED;
340     }
341 }
342 
343 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
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
413 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol
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
533         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
534         uint8 v = uint8((uint256(vs) >> 255) + 27);
535         return tryRecover(hash, v, r, s);
536     }
537 
538     /**
539      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
540      *
541      * _Available since v4.2._
542      */
543     function recover(
544         bytes32 hash,
545         bytes32 r,
546         bytes32 vs
547     ) internal pure returns (address) {
548         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
549         _throwError(error);
550         return recovered;
551     }
552 
553     /**
554      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
555      * `r` and `s` signature fields separately.
556      *
557      * _Available since v4.3._
558      */
559     function tryRecover(
560         bytes32 hash,
561         uint8 v,
562         bytes32 r,
563         bytes32 s
564     ) internal pure returns (address, RecoverError) {
565         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
566         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
567         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
568         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
569         //
570         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
571         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
572         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
573         // these malleable signatures as well.
574         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
575             return (address(0), RecoverError.InvalidSignatureS);
576         }
577         if (v != 27 && v != 28) {
578             return (address(0), RecoverError.InvalidSignatureV);
579         }
580 
581         // If the signature is valid (and not malleable), return the signer address
582         address signer = ecrecover(hash, v, r, s);
583         if (signer == address(0)) {
584             return (address(0), RecoverError.InvalidSignature);
585         }
586 
587         return (signer, RecoverError.NoError);
588     }
589 
590     /**
591      * @dev Overload of {ECDSA-recover} that receives the `v`,
592      * `r` and `s` signature fields separately.
593      */
594     function recover(
595         bytes32 hash,
596         uint8 v,
597         bytes32 r,
598         bytes32 s
599     ) internal pure returns (address) {
600         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
601         _throwError(error);
602         return recovered;
603     }
604 
605     /**
606      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
607      * produces hash corresponding to the one signed with the
608      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
609      * JSON-RPC method as part of EIP-191.
610      *
611      * See {recover}.
612      */
613     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
614         // 32 is the length in bytes of hash,
615         // enforced by the type signature above
616         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
617     }
618 
619     /**
620      * @dev Returns an Ethereum Signed Message, created from `s`. This
621      * produces hash corresponding to the one signed with the
622      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
623      * JSON-RPC method as part of EIP-191.
624      *
625      * See {recover}.
626      */
627     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
628         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
629     }
630 
631     /**
632      * @dev Returns an Ethereum Signed Typed Data, created from a
633      * `domainSeparator` and a `structHash`. This produces hash corresponding
634      * to the one signed with the
635      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
636      * JSON-RPC method as part of EIP-712.
637      *
638      * See {recover}.
639      */
640     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
641         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
642     }
643 }
644 
645 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
646 
647 
648 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
649 
650 pragma solidity ^0.8.0;
651 
652 /**
653  * @dev Provides information about the current execution context, including the
654  * sender of the transaction and its data. While these are generally available
655  * via msg.sender and msg.data, they should not be accessed in such a direct
656  * manner, since when dealing with meta-transactions the account sending and
657  * paying for execution may not be the actual sender (as far as an application
658  * is concerned).
659  *
660  * This contract is only required for intermediate, library-like contracts.
661  */
662 abstract contract Context {
663     function _msgSender() internal view virtual returns (address) {
664         return msg.sender;
665     }
666 
667     function _msgData() internal view virtual returns (bytes calldata) {
668         return msg.data;
669     }
670 }
671 
672 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
673 
674 
675 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
676 
677 pragma solidity ^0.8.0;
678 
679 
680 /**
681  * @dev Contract module which provides a basic access control mechanism, where
682  * there is an account (an owner) that can be granted exclusive access to
683  * specific functions.
684  *
685  * By default, the owner account will be the one that deploys the contract. This
686  * can later be changed with {transferOwnership}.
687  *
688  * This module is used through inheritance. It will make available the modifier
689  * `onlyOwner`, which can be applied to your functions to restrict their use to
690  * the owner.
691  */
692 abstract contract Ownable is Context {
693     address private _owner;
694 
695     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
696 
697     /**
698      * @dev Initializes the contract setting the deployer as the initial owner.
699      */
700     constructor() {
701         _transferOwnership(_msgSender());
702     }
703 
704     /**
705      * @dev Returns the address of the current owner.
706      */
707     function owner() public view virtual returns (address) {
708         return _owner;
709     }
710 
711     /**
712      * @dev Throws if called by any account other than the owner.
713      */
714     modifier onlyOwner() {
715         require(owner() == _msgSender(), "Ownable: caller is not the owner");
716         _;
717     }
718 
719     /**
720      * @dev Leaves the contract without owner. It will not be possible to call
721      * `onlyOwner` functions anymore. Can only be called by the current owner.
722      *
723      * NOTE: Renouncing ownership will leave the contract without an owner,
724      * thereby removing any functionality that is only available to the owner.
725      */
726     function renounceOwnership() public virtual onlyOwner {
727         _transferOwnership(address(0));
728     }
729 
730     /**
731      * @dev Transfers ownership of the contract to a new account (`newOwner`).
732      * Can only be called by the current owner.
733      */
734     function transferOwnership(address newOwner) public virtual onlyOwner {
735         require(newOwner != address(0), "Ownable: new owner is the zero address");
736         _transferOwnership(newOwner);
737     }
738 
739     /**
740      * @dev Transfers ownership of the contract to a new account (`newOwner`).
741      * Internal function without access restriction.
742      */
743     function _transferOwnership(address newOwner) internal virtual {
744         address oldOwner = _owner;
745         _owner = newOwner;
746         emit OwnershipTransferred(oldOwner, newOwner);
747     }
748 }
749 
750 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
751 
752 
753 // OpenZeppelin Contracts v4.4.1 (utils/Address.sol)
754 
755 pragma solidity ^0.8.1;
756 
757 /**
758  * @dev Collection of functions related to the address type
759  */
760 library Address {
761     /**
762      * @dev Returns true if `account` is a contract.
763      *
764      * [IMPORTANT]
765      * ====
766      * It is unsafe to assume that an address for which this function returns
767      * false is an externally-owned account (EOA) and not a contract.
768      *
769      * Among others, `isContract` will return false for the following
770      * types of addresses:
771      *
772      *  - an externally-owned account
773      *  - a contract in construction
774      *  - an address where a contract will be created
775      *  - an address where a contract lived, but was destroyed
776      * ====
777      *
778      * [IMPORTANT]
779      * ====
780      * You shouldn't rely on `isContract` to protect against flash loan attacks!
781      *
782      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
783      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
784      * constructor.
785      * ====
786      */
787     function isContract(address account) internal view returns (bool) {
788         // This method relies on extcodesize/address.code.length, which returns 0
789         // for contracts in construction, since the code is only stored at the end
790         // of the constructor execution.
791 
792         return account.code.length > 0;
793     }
794 
795     /**
796      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
797      * `recipient`, forwarding all available gas and reverting on errors.
798      *
799      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
800      * of certain opcodes, possibly making contracts go over the 2300 gas limit
801      * imposed by `transfer`, making them unable to receive funds via
802      * `transfer`. {sendValue} removes this limitation.
803      *
804      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
805      *
806      * IMPORTANT: because control is transferred to `recipient`, care must be
807      * taken to not create reentrancy vulnerabilities. Consider using
808      * {ReentrancyGuard} or the
809      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
810      */
811     function sendValue(address payable recipient, uint256 amount) internal {
812         require(address(this).balance >= amount, "Address: insufficient balance");
813 
814         (bool success, ) = recipient.call{value: amount}("");
815         require(success, "Address: unable to send value, recipient may have reverted");
816     }
817 
818     /**
819      * @dev Performs a Solidity function call using a low level `call`. A
820      * plain `call` is an unsafe replacement for a function call: use this
821      * function instead.
822      *
823      * If `target` reverts with a revert reason, it is bubbled up by this
824      * function (like regular Solidity function calls).
825      *
826      * Returns the raw returned data. To convert to the expected return value,
827      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
828      *
829      * Requirements:
830      *
831      * - `target` must be a contract.
832      * - calling `target` with `data` must not revert.
833      *
834      * _Available since v3.1._
835      */
836     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
837         return functionCall(target, data, "Address: low-level call failed");
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
842      * `errorMessage` as a fallback revert reason when `target` reverts.
843      *
844      * _Available since v3.1._
845      */
846     function functionCall(
847         address target,
848         bytes memory data,
849         string memory errorMessage
850     ) internal returns (bytes memory) {
851         return functionCallWithValue(target, data, 0, errorMessage);
852     }
853 
854     /**
855      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
856      * but also transferring `value` wei to `target`.
857      *
858      * Requirements:
859      *
860      * - the calling contract must have an ETH balance of at least `value`.
861      * - the called Solidity function must be `payable`.
862      *
863      * _Available since v3.1._
864      */
865     function functionCallWithValue(
866         address target,
867         bytes memory data,
868         uint256 value
869     ) internal returns (bytes memory) {
870         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
871     }
872 
873     /**
874      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
875      * with `errorMessage` as a fallback revert reason when `target` reverts.
876      *
877      * _Available since v3.1._
878      */
879     function functionCallWithValue(
880         address target,
881         bytes memory data,
882         uint256 value,
883         string memory errorMessage
884     ) internal returns (bytes memory) {
885         require(address(this).balance >= value, "Address: insufficient balance for call");
886         require(isContract(target), "Address: call to non-contract");
887 
888         (bool success, bytes memory returndata) = target.call{value: value}(data);
889         return verifyCallResult(success, returndata, errorMessage);
890     }
891 
892     /**
893      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
894      * but performing a static call.
895      *
896      * _Available since v3.3._
897      */
898     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
899         return functionStaticCall(target, data, "Address: low-level static call failed");
900     }
901 
902     /**
903      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
904      * but performing a static call.
905      *
906      * _Available since v3.3._
907      */
908     function functionStaticCall(
909         address target,
910         bytes memory data,
911         string memory errorMessage
912     ) internal view returns (bytes memory) {
913         require(isContract(target), "Address: static call to non-contract");
914 
915         (bool success, bytes memory returndata) = target.staticcall(data);
916         return verifyCallResult(success, returndata, errorMessage);
917     }
918 
919     /**
920      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
921      * but performing a delegate call.
922      *
923      * _Available since v3.4._
924      */
925     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
926         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
927     }
928 
929     /**
930      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
931      * but performing a delegate call.
932      *
933      * _Available since v3.4._
934      */
935     function functionDelegateCall(
936         address target,
937         bytes memory data,
938         string memory errorMessage
939     ) internal returns (bytes memory) {
940         require(isContract(target), "Address: delegate call to non-contract");
941 
942         (bool success, bytes memory returndata) = target.delegatecall(data);
943         return verifyCallResult(success, returndata, errorMessage);
944     }
945 
946     /**
947      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
948      * revert reason using the provided one.
949      *
950      * _Available since v4.3._
951      */
952     function verifyCallResult(
953         bool success,
954         bytes memory returndata,
955         string memory errorMessage
956     ) internal pure returns (bytes memory) {
957         if (success) {
958             return returndata;
959         } else {
960             // Look for revert reason and bubble it up if present
961             if (returndata.length > 0) {
962                 // The easiest way to bubble the revert reason is using memory via assembly
963 
964                 assembly {
965                     let returndata_size := mload(returndata)
966                     revert(add(32, returndata), returndata_size)
967                 }
968             } else {
969                 revert(errorMessage);
970             }
971         }
972     }
973 }
974 
975 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol
976 
977 
978 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
979 
980 pragma solidity ^0.8.0;
981 
982 /**
983  * @title ERC721 token receiver interface
984  * @dev Interface for any contract that wants to support safeTransfers
985  * from ERC721 asset contracts.
986  */
987 interface IERC721Receiver {
988     /**
989      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
990      * by `operator` from `from`, this function is called.
991      *
992      * It must return its Solidity selector to confirm the token transfer.
993      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
994      *
995      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
996      */
997     function onERC721Received(
998         address operator,
999         address from,
1000         uint256 tokenId,
1001         bytes calldata data
1002     ) external returns (bytes4);
1003 }
1004 
1005 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 /**
1013  * @dev Interface of the ERC165 standard, as defined in the
1014  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1015  *
1016  * Implementers can declare support of contract interfaces, which can then be
1017  * queried by others ({ERC165Checker}).
1018  *
1019  * For an implementation, see {ERC165}.
1020  */
1021 interface IERC165 {
1022     /**
1023      * @dev Returns true if this contract implements the interface defined by
1024      * `interfaceId`. See the corresponding
1025      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1026      * to learn more about how these ids are created.
1027      *
1028      * This function call must use less than 30 000 gas.
1029      */
1030     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1031 }
1032 
1033 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
1034 
1035 
1036 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 
1041 /**
1042  * @dev Implementation of the {IERC165} interface.
1043  *
1044  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1045  * for the additional interface id that will be supported. For example:
1046  *
1047  * ```solidity
1048  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1049  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1050  * }
1051  * ```
1052  *
1053  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1054  */
1055 abstract contract ERC165 is IERC165 {
1056     /**
1057      * @dev See {IERC165-supportsInterface}.
1058      */
1059     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1060         return interfaceId == type(IERC165).interfaceId;
1061     }
1062 }
1063 
1064 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721.sol
1065 
1066 
1067 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 
1072 /**
1073  * @dev Required interface of an ERC721 compliant contract.
1074  */
1075 interface IERC721 is IERC165 {
1076     /**
1077      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1078      */
1079     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1080 
1081     /**
1082      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1083      */
1084     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1085 
1086     /**
1087      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1088      */
1089     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1090 
1091     /**
1092      * @dev Returns the number of tokens in ``owner``'s account.
1093      */
1094     function balanceOf(address owner) external view returns (uint256 balance);
1095 
1096     /**
1097      * @dev Returns the owner of the `tokenId` token.
1098      *
1099      * Requirements:
1100      *
1101      * - `tokenId` must exist.
1102      */
1103     function ownerOf(uint256 tokenId) external view returns (address owner);
1104 
1105     /**
1106      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1107      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1108      *
1109      * Requirements:
1110      *
1111      * - `from` cannot be the zero address.
1112      * - `to` cannot be the zero address.
1113      * - `tokenId` token must exist and be owned by `from`.
1114      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1115      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1116      *
1117      * Emits a {Transfer} event.
1118      */
1119     function safeTransferFrom(
1120         address from,
1121         address to,
1122         uint256 tokenId
1123     ) external;
1124 
1125     /**
1126      * @dev Transfers `tokenId` token from `from` to `to`.
1127      *
1128      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1129      *
1130      * Requirements:
1131      *
1132      * - `from` cannot be the zero address.
1133      * - `to` cannot be the zero address.
1134      * - `tokenId` token must be owned by `from`.
1135      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1136      *
1137      * Emits a {Transfer} event.
1138      */
1139     function transferFrom(
1140         address from,
1141         address to,
1142         uint256 tokenId
1143     ) external;
1144 
1145     /**
1146      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1147      * The approval is cleared when the token is transferred.
1148      *
1149      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1150      *
1151      * Requirements:
1152      *
1153      * - The caller must own the token or be an approved operator.
1154      * - `tokenId` must exist.
1155      *
1156      * Emits an {Approval} event.
1157      */
1158     function approve(address to, uint256 tokenId) external;
1159 
1160     /**
1161      * @dev Returns the account approved for `tokenId` token.
1162      *
1163      * Requirements:
1164      *
1165      * - `tokenId` must exist.
1166      */
1167     function getApproved(uint256 tokenId) external view returns (address operator);
1168 
1169     /**
1170      * @dev Approve or remove `operator` as an operator for the caller.
1171      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1172      *
1173      * Requirements:
1174      *
1175      * - The `operator` cannot be the caller.
1176      *
1177      * Emits an {ApprovalForAll} event.
1178      */
1179     function setApprovalForAll(address operator, bool _approved) external;
1180 
1181     /**
1182      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1183      *
1184      * See {setApprovalForAll}
1185      */
1186     function isApprovedForAll(address owner, address operator) external view returns (bool);
1187 
1188     /**
1189      * @dev Safely transfers `tokenId` token from `from` to `to`.
1190      *
1191      * Requirements:
1192      *
1193      * - `from` cannot be the zero address.
1194      * - `to` cannot be the zero address.
1195      * - `tokenId` token must exist and be owned by `from`.
1196      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1197      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1198      *
1199      * Emits a {Transfer} event.
1200      */
1201     function safeTransferFrom(
1202         address from,
1203         address to,
1204         uint256 tokenId,
1205         bytes calldata data
1206     ) external;
1207 }
1208 
1209 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/IERC721Metadata.sol
1210 
1211 
1212 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1213 
1214 pragma solidity ^0.8.0;
1215 
1216 
1217 /**
1218  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1219  * @dev See https://eips.ethereum.org/EIPS/eip-721
1220  */
1221 interface IERC721Metadata is IERC721 {
1222     /**
1223      * @dev Returns the token collection name.
1224      */
1225     function name() external view returns (string memory);
1226 
1227     /**
1228      * @dev Returns the token collection symbol.
1229      */
1230     function symbol() external view returns (string memory);
1231 
1232     /**
1233      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1234      */
1235     function tokenURI(uint256 tokenId) external view returns (string memory);
1236 }
1237 
1238 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol
1239 
1240 
1241 // OpenZeppelin Contracts v4.4.1 (token/ERC721/ERC721.sol)
1242 
1243 pragma solidity ^0.8.0;
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 /**
1253  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1254  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1255  * {ERC721Enumerable}.
1256  */
1257 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1258     using Address for address;
1259     using Strings for uint256;
1260 
1261     // Token name
1262     string private _name;
1263 
1264     // Token symbol
1265     string private _symbol;
1266 
1267     // Mapping from token ID to owner address
1268     mapping(uint256 => address) private _owners;
1269 
1270     // Mapping owner address to token count
1271     mapping(address => uint256) private _balances;
1272 
1273     // Mapping from token ID to approved address
1274     mapping(uint256 => address) private _tokenApprovals;
1275 
1276     // Mapping from owner to operator approvals
1277     mapping(address => mapping(address => bool)) private _operatorApprovals;
1278 
1279     /**
1280      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1281      */
1282     constructor(string memory name_, string memory symbol_) {
1283         _name = name_;
1284         _symbol = symbol_;
1285     }
1286 
1287     /**
1288      * @dev See {IERC165-supportsInterface}.
1289      */
1290     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1291         return
1292             interfaceId == type(IERC721).interfaceId ||
1293             interfaceId == type(IERC721Metadata).interfaceId ||
1294             super.supportsInterface(interfaceId);
1295     }
1296 
1297     /**
1298      * @dev See {IERC721-balanceOf}.
1299      */
1300     function balanceOf(address owner) public view virtual override returns (uint256) {
1301         require(owner != address(0), "ERC721: balance query for the zero address");
1302         return _balances[owner];
1303     }
1304 
1305     /**
1306      * @dev See {IERC721-ownerOf}.
1307      */
1308     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1309         address owner = _owners[tokenId];
1310         require(owner != address(0), "ERC721: owner query for nonexistent token");
1311         return owner;
1312     }
1313 
1314     /**
1315      * @dev See {IERC721Metadata-name}.
1316      */
1317     function name() public view virtual override returns (string memory) {
1318         return _name;
1319     }
1320 
1321     /**
1322      * @dev See {IERC721Metadata-symbol}.
1323      */
1324     function symbol() public view virtual override returns (string memory) {
1325         return _symbol;
1326     }
1327 
1328     /**
1329      * @dev See {IERC721Metadata-tokenURI}.
1330      */
1331     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1332         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1333 
1334         string memory baseURI = _baseURI();
1335         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1336     }
1337 
1338     /**
1339      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1340      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1341      * by default, can be overriden in child contracts.
1342      */
1343     function _baseURI() internal view virtual returns (string memory) {
1344         return "";
1345     }
1346 
1347     /**
1348      * @dev See {IERC721-approve}.
1349      */
1350     function approve(address to, uint256 tokenId) public virtual override {
1351         address owner = ERC721.ownerOf(tokenId);
1352         require(to != owner, "ERC721: approval to current owner");
1353 
1354         require(
1355             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1356             "ERC721: approve caller is not owner nor approved for all"
1357         );
1358 
1359         _approve(to, tokenId);
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-getApproved}.
1364      */
1365     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1366         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1367 
1368         return _tokenApprovals[tokenId];
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-setApprovalForAll}.
1373      */
1374     function setApprovalForAll(address operator, bool approved) public virtual override {
1375         _setApprovalForAll(_msgSender(), operator, approved);
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-isApprovedForAll}.
1380      */
1381     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1382         return _operatorApprovals[owner][operator];
1383     }
1384 
1385     /**
1386      * @dev See {IERC721-transferFrom}.
1387      */
1388     function transferFrom(
1389         address from,
1390         address to,
1391         uint256 tokenId
1392     ) public virtual override {
1393         //solhint-disable-next-line max-line-length
1394         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1395 
1396         _transfer(from, to, tokenId);
1397     }
1398 
1399     /**
1400      * @dev See {IERC721-safeTransferFrom}.
1401      */
1402     function safeTransferFrom(
1403         address from,
1404         address to,
1405         uint256 tokenId
1406     ) public virtual override {
1407         safeTransferFrom(from, to, tokenId, "");
1408     }
1409 
1410     /**
1411      * @dev See {IERC721-safeTransferFrom}.
1412      */
1413     function safeTransferFrom(
1414         address from,
1415         address to,
1416         uint256 tokenId,
1417         bytes memory _data
1418     ) public virtual override {
1419         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1420         _safeTransfer(from, to, tokenId, _data);
1421     }
1422 
1423     /**
1424      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1425      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1426      *
1427      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1428      *
1429      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1430      * implement alternative mechanisms to perform token transfer, such as signature-based.
1431      *
1432      * Requirements:
1433      *
1434      * - `from` cannot be the zero address.
1435      * - `to` cannot be the zero address.
1436      * - `tokenId` token must exist and be owned by `from`.
1437      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1438      *
1439      * Emits a {Transfer} event.
1440      */
1441     function _safeTransfer(
1442         address from,
1443         address to,
1444         uint256 tokenId,
1445         bytes memory _data
1446     ) internal virtual {
1447         _transfer(from, to, tokenId);
1448         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1449     }
1450 
1451     /**
1452      * @dev Returns whether `tokenId` exists.
1453      *
1454      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1455      *
1456      * Tokens start existing when they are minted (`_mint`),
1457      * and stop existing when they are burned (`_burn`).
1458      */
1459     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1460         return _owners[tokenId] != address(0);
1461     }
1462 
1463     /**
1464      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1465      *
1466      * Requirements:
1467      *
1468      * - `tokenId` must exist.
1469      */
1470     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1471         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1472         address owner = ERC721.ownerOf(tokenId);
1473         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1474     }
1475 
1476     /**
1477      * @dev Safely mints `tokenId` and transfers it to `to`.
1478      *
1479      * Requirements:
1480      *
1481      * - `tokenId` must not exist.
1482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1483      *
1484      * Emits a {Transfer} event.
1485      */
1486     function _safeMint(address to, uint256 tokenId) internal virtual {
1487         _safeMint(to, tokenId, "");
1488     }
1489 
1490     /**
1491      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1492      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1493      */
1494     function _safeMint(
1495         address to,
1496         uint256 tokenId,
1497         bytes memory _data
1498     ) internal virtual {
1499         _mint(to, tokenId);
1500         require(
1501             _checkOnERC721Received(address(0), to, tokenId, _data),
1502             "ERC721: transfer to non ERC721Receiver implementer"
1503         );
1504     }
1505 
1506     /**
1507      * @dev Mints `tokenId` and transfers it to `to`.
1508      *
1509      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1510      *
1511      * Requirements:
1512      *
1513      * - `tokenId` must not exist.
1514      * - `to` cannot be the zero address.
1515      *
1516      * Emits a {Transfer} event.
1517      */
1518     function _mint(address to, uint256 tokenId) internal virtual {
1519         require(to != address(0), "ERC721: mint to the zero address");
1520         require(!_exists(tokenId), "ERC721: token already minted");
1521 
1522         _beforeTokenTransfer(address(0), to, tokenId);
1523 
1524         _balances[to] += 1;
1525         _owners[tokenId] = to;
1526 
1527         emit Transfer(address(0), to, tokenId);
1528 
1529         _afterTokenTransfer(address(0), to, tokenId);
1530     }
1531 
1532     /**
1533      * @dev Destroys `tokenId`.
1534      * The approval is cleared when the token is burned.
1535      *
1536      * Requirements:
1537      *
1538      * - `tokenId` must exist.
1539      *
1540      * Emits a {Transfer} event.
1541      */
1542     function _burn(uint256 tokenId) internal virtual {
1543         address owner = ERC721.ownerOf(tokenId);
1544 
1545         _beforeTokenTransfer(owner, address(0), tokenId);
1546 
1547         // Clear approvals
1548         _approve(address(0), tokenId);
1549 
1550         _balances[owner] -= 1;
1551         delete _owners[tokenId];
1552 
1553         emit Transfer(owner, address(0), tokenId);
1554 
1555         _afterTokenTransfer(owner, address(0), tokenId);
1556     }
1557 
1558     /**
1559      * @dev Transfers `tokenId` from `from` to `to`.
1560      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1561      *
1562      * Requirements:
1563      *
1564      * - `to` cannot be the zero address.
1565      * - `tokenId` token must be owned by `from`.
1566      *
1567      * Emits a {Transfer} event.
1568      */
1569     function _transfer(
1570         address from,
1571         address to,
1572         uint256 tokenId
1573     ) internal virtual {
1574         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1575         require(to != address(0), "ERC721: transfer to the zero address");
1576 
1577         _beforeTokenTransfer(from, to, tokenId);
1578 
1579         // Clear approvals from the previous owner
1580         _approve(address(0), tokenId);
1581 
1582         _balances[from] -= 1;
1583         _balances[to] += 1;
1584         _owners[tokenId] = to;
1585 
1586         emit Transfer(from, to, tokenId);
1587 
1588         _afterTokenTransfer(from, to, tokenId);
1589     }
1590 
1591     /**
1592      * @dev Approve `to` to operate on `tokenId`
1593      *
1594      * Emits a {Approval} event.
1595      */
1596     function _approve(address to, uint256 tokenId) internal virtual {
1597         _tokenApprovals[tokenId] = to;
1598         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1599     }
1600 
1601     /**
1602      * @dev Approve `operator` to operate on all of `owner` tokens
1603      *
1604      * Emits a {ApprovalForAll} event.
1605      */
1606     function _setApprovalForAll(
1607         address owner,
1608         address operator,
1609         bool approved
1610     ) internal virtual {
1611         require(owner != operator, "ERC721: approve to caller");
1612         _operatorApprovals[owner][operator] = approved;
1613         emit ApprovalForAll(owner, operator, approved);
1614     }
1615 
1616     /**
1617      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1618      * The call is not executed if the target address is not a contract.
1619      *
1620      * @param from address representing the previous owner of the given token ID
1621      * @param to target address that will receive the tokens
1622      * @param tokenId uint256 ID of the token to be transferred
1623      * @param _data bytes optional data to send along with the call
1624      * @return bool whether the call correctly returned the expected magic value
1625      */
1626     function _checkOnERC721Received(
1627         address from,
1628         address to,
1629         uint256 tokenId,
1630         bytes memory _data
1631     ) private returns (bool) {
1632         if (to.isContract()) {
1633             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1634                 return retval == IERC721Receiver.onERC721Received.selector;
1635             } catch (bytes memory reason) {
1636                 if (reason.length == 0) {
1637                     revert("ERC721: transfer to non ERC721Receiver implementer");
1638                 } else {
1639                     assembly {
1640                         revert(add(32, reason), mload(reason))
1641                     }
1642                 }
1643             }
1644         } else {
1645             return true;
1646         }
1647     }
1648 
1649     /**
1650      * @dev Hook that is called before any token transfer. This includes minting
1651      * and burning.
1652      *
1653      * Calling conditions:
1654      *
1655      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1656      * transferred to `to`.
1657      * - When `from` is zero, `tokenId` will be minted for `to`.
1658      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1659      * - `from` and `to` are never both zero.
1660      *
1661      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1662      */
1663     function _beforeTokenTransfer(
1664         address from,
1665         address to,
1666         uint256 tokenId
1667     ) internal virtual {}
1668 
1669     /**
1670      * @dev Hook that is called after any transfer of tokens. This includes
1671      * minting and burning.
1672      *
1673      * Calling conditions:
1674      *
1675      * - when `from` and `to` are both non-zero.
1676      * - `from` and `to` are never both zero.
1677      *
1678      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1679      */
1680     function _afterTokenTransfer(
1681         address from,
1682         address to,
1683         uint256 tokenId
1684     ) internal virtual {}
1685 }
1686 
1687 // File: Doodle Pengiuns.sol
1688 
1689 
1690 pragma solidity ^0.8.2;
1691 
1692 
1693 
1694 
1695 
1696 
1697 
1698 
1699 
1700 contract DoodlePenguins is ERC721, Ownable, ReentrancyGuard {
1701     using Counters for Counters.Counter;
1702     using SafeMath for uint256;
1703     using ECDSA for bytes32; 
1704     using Strings for uint256;
1705 
1706     Counters.Counter private tokenSupply;
1707     Counters.Counter private influncerGiveawaySupply;
1708 
1709     string public DOODLE_PENGUIN_PROVENANCE = "";
1710 
1711     uint256 public constant MAX_SUPPLY = 10000;
1712     uint256 public constant MAX_SUPPLY_WHITELIST = 1000;
1713     uint256 public constant MAX_GIVEAWAY_INFLUENCER = 100;
1714     uint256 public constant WHITELIST_MINT_CAP = 2;
1715     uint256 public constant MAX_DOODLE_PENGUIN_PER_PURCHASE = 20;
1716     uint256 public constant WALLET_CAP = 100;
1717     uint256 private DOODLE_PENGIUN_PRICE = 0 ether;
1718 
1719 
1720     string public tokenBaseURI;
1721     string public unrevealedURI;
1722     bool public presaleActive = false;
1723     bool public mintActive = false;
1724 
1725     mapping(address => uint256) private whitelistAddressMintCount;
1726     mapping(address => bool) private influncerGiveaways;
1727 
1728     constructor() ERC721("Doodles Penguin", "DOODLEPENGS") 
1729     {
1730         tokenSupply.increment();
1731     }
1732 
1733     /**************
1734      * Flip State *
1735      **************/
1736 
1737     function flipPresaleState() external onlyOwner
1738     {
1739         presaleActive = !presaleActive;
1740     }
1741 
1742     function enablePublicSale() external onlyOwner
1743     {
1744         mintActive = !mintActive;
1745     }
1746 
1747     /********************
1748      * Setter functions *
1749      ********************/
1750 
1751     function setProvenanceHash(string memory provenanceHash) external onlyOwner 
1752     {
1753         DOODLE_PENGUIN_PROVENANCE = provenanceHash;
1754     }
1755 
1756     function setTokenBaseURI(string memory _baseURI) external onlyOwner 
1757     {
1758         tokenBaseURI = _baseURI;
1759     }
1760 
1761     function setUnrevealedURI(string memory _unrevealedUri) external onlyOwner 
1762     {
1763         unrevealedURI = _unrevealedUri;
1764     }
1765     function tokenURI(uint256 _tokenId) override public view returns (string memory) 
1766     {
1767         bool revealed = bytes(tokenBaseURI).length > 0;
1768 
1769         if (!revealed) {
1770         return unrevealedURI;
1771         }
1772 
1773         require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1774 
1775         return string(abi.encodePacked(tokenBaseURI, _tokenId.toString()));
1776     }
1777 
1778     function addInfluencerGiveaway(address _address) external onlyOwner 
1779     {
1780         influncerGiveaways[_address] = true;
1781     }
1782 
1783     /*********************
1784      * Get current price *
1785      *********************/
1786     function getCurrentPrice(uint256 _quantity) public view returns (uint256)
1787     {
1788         uint256 returnPrice;
1789 
1790         if (tokenSupply.current().add(_quantity) > 1000)
1791         {
1792             returnPrice = 0.01 ether;
1793         }
1794 
1795         if (tokenSupply.current().add(_quantity) > 3000)
1796         {
1797             returnPrice = 0.02 ether;
1798         }
1799 
1800         if (tokenSupply.current().add(_quantity) > 5000)
1801         {
1802             returnPrice = 0.03 ether;
1803         }
1804 
1805         if (tokenSupply.current().add(_quantity) > 7000)
1806         {
1807             returnPrice = 0.04 ether;
1808         }
1809 
1810         return returnPrice;
1811     }
1812 
1813     function getTokenSupply() public view returns (uint256)
1814     {
1815         return tokenSupply.current();
1816     }
1817     /********
1818      * Mint *
1819      ********/
1820 
1821     /**********************
1822      * 0-1000      free   *
1823      * 1001-3000  .01 eth *
1824      * 3001-5000  .02 eth *
1825      * 5001-7000  .03 eth *
1826      * 7001-10000 .04 eth *
1827      **********************/
1828 
1829     // Whitelist mint function
1830     function presaleMint(uint256 _quantity, bytes calldata _whitelistSignature) external payable nonReentrant 
1831     {
1832         require(verifyOwnerSignature(keccak256(abi.encode(msg.sender)), _whitelistSignature), "Invalid whitelist signature");
1833         require(presaleActive, "Presale is not active");
1834         require(tokenSupply.current().add(_quantity) <= MAX_SUPPLY_WHITELIST, "Whitelist is sold out");
1835         require(_quantity <= WHITELIST_MINT_CAP, "Exceeds whitelist mint cap");
1836         require(whitelistAddressMintCount[msg.sender].add(_quantity) <= WHITELIST_MINT_CAP, "This purchase would exceed the maximum you are allowed to mint for presale");
1837 
1838         whitelistAddressMintCount[msg.sender] += _quantity;
1839         _safeMintDoodlePenguins(_quantity);
1840     }
1841 
1842     // Public mint function
1843     function publicMint(uint256 _quantity) external payable 
1844     {
1845         require(mintActive, "Sale is not active");
1846         require(_quantity <= MAX_DOODLE_PENGUIN_PER_PURCHASE, "Quantity is more than allowed per transaction");
1847 
1848         _safeMintDoodlePenguins(_quantity);
1849     }
1850 
1851 
1852     // Used for giveaway winners or influencer payment for marketing (mints 5 Doodle Penguins)
1853     function influncerGiveawayMint() external
1854     {
1855         require(influncerGiveaways[msg.sender] == true, "You are not allowed to use this function");
1856         require(tokenSupply.current().add(5) <= MAX_SUPPLY, "This purchase would exceed the max supply");
1857         require(influncerGiveawaySupply.current().add(5) <= MAX_GIVEAWAY_INFLUENCER);
1858         for (uint256 i = 0; i < 4; i++) 
1859         {
1860             uint256 mintIndex = tokenSupply.current();
1861 
1862             if (mintIndex < MAX_SUPPLY) 
1863             {
1864                 tokenSupply.increment();
1865                 influncerGiveawaySupply.increment();
1866                 _safeMint(msg.sender, mintIndex);
1867             }
1868         }
1869         influncerGiveaways[msg.sender] = false;
1870     }
1871 
1872     function _safeMintDoodlePenguins(uint256 _quantity) internal 
1873     {
1874         if (tokenSupply.current().add(_quantity) > 1000)
1875         {
1876             DOODLE_PENGIUN_PRICE = 0.01 ether;
1877         }
1878 
1879         if (tokenSupply.current().add(_quantity) > 3000)
1880         {
1881             DOODLE_PENGIUN_PRICE = 0.02 ether;
1882         }
1883 
1884         if (tokenSupply.current().add(_quantity) > 5000)
1885         {
1886             DOODLE_PENGIUN_PRICE = 0.03 ether;
1887         }
1888 
1889         if (tokenSupply.current().add(_quantity) > 7000)
1890         {
1891             DOODLE_PENGIUN_PRICE = 0.04 ether;
1892         }
1893 
1894 
1895         require(_quantity > 0, "Quantity must be at least 1");
1896         require(tokenSupply.current().add(_quantity) <= MAX_SUPPLY, "This purchase would exceed the max supply");
1897         require(msg.value >= DOODLE_PENGIUN_PRICE.mul(_quantity), "The ether value sent is not correct");
1898 
1899         for (uint256 i = 0; i < _quantity; i++) 
1900         {
1901             uint256 mintIndex = tokenSupply.current();
1902 
1903             if (mintIndex < MAX_SUPPLY) 
1904             {
1905                 tokenSupply.increment();
1906                 _safeMint(msg.sender, mintIndex);
1907             }
1908         }
1909     }
1910 
1911 
1912     /***************
1913      * Withdrawals *
1914      ***************/
1915 
1916     // Withdraws entire balance of contract (ETH) to owner account (owner-only)
1917     function withdraw() public onlyOwner 
1918     {
1919         uint256 balance = address(this).balance;
1920         payable(msg.sender).transfer(balance);
1921     }
1922 
1923     // Withdraws amount specified (ETH) from balance of contract to owner account (owner-only)
1924     function withdrawPartial(address payable _recipient, uint256 _amount)
1925     public
1926     onlyOwner
1927     {
1928         // Check that amount is not more than total contract balance
1929         require(
1930         _amount > 0 && _amount <= address(this).balance,
1931         "Withdraw amount must be positive and not exceed total contract balance"
1932         );
1933         _recipient.transfer(_amount);
1934     }
1935 
1936     /************
1937      * Security *
1938      ************/
1939     function verifyOwnerSignature(bytes32 hash, bytes memory signature) private view returns(bool) 
1940     {
1941         return hash.toEthSignedMessageHash().recover(signature) == owner();
1942     }
1943 
1944 }