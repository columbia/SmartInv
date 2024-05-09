1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 
5 // OpenZeppelin Contracts v4.4.0 (security/ReentrancyGuard.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Contract module that helps prevent reentrant calls to a function.
11  *
12  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
13  * available, which can be applied to functions to make sure there are no nested
14  * (reentrant) calls to them.
15  *
16  * Note that because there is a single `nonReentrant` guard, functions marked as
17  * `nonReentrant` may not call one another. This can be worked around by making
18  * those functions `private`, and then adding `external` `nonReentrant` entry
19  * points to them.
20  *
21  * TIP: If you would like to learn more about reentrancy and alternative ways
22  * to protect against it, check out our blog post
23  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
24  */
25 abstract contract ReentrancyGuard {
26     // Booleans are more expensive than uint256 or any type that takes up a full
27     // word because each write operation emits an extra SLOAD to first read the
28     // slot's contents, replace the bits taken up by the boolean, and then write
29     // back. This is the compiler's defense against contract upgrades and
30     // pointer aliasing, and it cannot be disabled.
31 
32     // The values being non-zero value makes deployment a bit more expensive,
33     // but in exchange the refund on every call to nonReentrant will be lower in
34     // amount. Since refunds are capped to a percentage of the total
35     // transaction's gas, it is best to keep them low in cases like this one, to
36     // increase the likelihood of the full refund coming into effect.
37     uint256 private constant _NOT_ENTERED = 1;
38     uint256 private constant _ENTERED = 2;
39 
40     uint256 private _status;
41 
42     constructor() {
43         _status = _NOT_ENTERED;
44     }
45 
46     /**
47      * @dev Prevents a contract from calling itself, directly or indirectly.
48      * Calling a `nonReentrant` function from another `nonReentrant`
49      * function is not supported. It is possible to prevent this from happening
50      * by making the `nonReentrant` function external, and making it call a
51      * `private` function that does the actual work.
52      */
53     modifier nonReentrant() {
54         // On the first call to nonReentrant, _notEntered will be true
55         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
56 
57         // Any calls to nonReentrant after this point will fail
58         _status = _ENTERED;
59 
60         _;
61 
62         // By storing the original value once again, a refund is triggered (see
63         // https://eips.ethereum.org/EIPS/eip-2200)
64         _status = _NOT_ENTERED;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/utils/Counters.sol
69 
70 
71 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
72 
73 pragma solidity ^0.8.0;
74 
75 /**
76  * @title Counters
77  * @author Matt Condon (@shrugs)
78  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
79  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
80  *
81  * Include with `using Counters for Counters.Counter;`
82  */
83 library Counters {
84     struct Counter {
85         // This variable should never be directly accessed by users of the library: interactions must be restricted to
86         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
87         // this feature: see https://github.com/ethereum/solidity/issues/4637
88         uint256 _value; // default: 0
89     }
90 
91     function current(Counter storage counter) internal view returns (uint256) {
92         return counter._value;
93     }
94 
95     function increment(Counter storage counter) internal {
96         unchecked {
97             counter._value += 1;
98         }
99     }
100 
101     function decrement(Counter storage counter) internal {
102         uint256 value = counter._value;
103         require(value > 0, "Counter: decrement overflow");
104         unchecked {
105             counter._value = value - 1;
106         }
107     }
108 
109     function reset(Counter storage counter) internal {
110         counter._value = 0;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
115 
116 
117 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 // CAUTION
122 // This version of SafeMath should only be used with Solidity 0.8 or later,
123 // because it relies on the compiler's built in overflow checks.
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations.
127  *
128  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
129  * now has built in overflow checking.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         unchecked {
139             uint256 c = a + b;
140             if (c < a) return (false, 0);
141             return (true, c);
142         }
143     }
144 
145     /**
146      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b > a) return (false, 0);
153             return (true, a - b);
154         }
155     }
156 
157     /**
158      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
159      *
160      * _Available since v3.4._
161      */
162     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165             // benefit is lost if 'b' is also tested.
166             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167             if (a == 0) return (true, 0);
168             uint256 c = a * b;
169             if (c / a != b) return (false, 0);
170             return (true, c);
171         }
172     }
173 
174     /**
175      * @dev Returns the division of two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         unchecked {
181             if (b == 0) return (false, 0);
182             return (true, a / b);
183         }
184     }
185 
186     /**
187      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
188      *
189      * _Available since v3.4._
190      */
191     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
192         unchecked {
193             if (b == 0) return (false, 0);
194             return (true, a % b);
195         }
196     }
197 
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a + b;
210     }
211 
212     /**
213      * @dev Returns the subtraction of two unsigned integers, reverting on
214      * overflow (when the result is negative).
215      *
216      * Counterpart to Solidity's `-` operator.
217      *
218      * Requirements:
219      *
220      * - Subtraction cannot overflow.
221      */
222     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
223         return a - b;
224     }
225 
226     /**
227      * @dev Returns the multiplication of two unsigned integers, reverting on
228      * overflow.
229      *
230      * Counterpart to Solidity's `*` operator.
231      *
232      * Requirements:
233      *
234      * - Multiplication cannot overflow.
235      */
236     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
237         return a * b;
238     }
239 
240     /**
241      * @dev Returns the integer division of two unsigned integers, reverting on
242      * division by zero. The result is rounded towards zero.
243      *
244      * Counterpart to Solidity's `/` operator.
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function div(uint256 a, uint256 b) internal pure returns (uint256) {
251         return a / b;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * reverting when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
267         return a % b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {trySub}.
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(
284         uint256 a,
285         uint256 b,
286         string memory errorMessage
287     ) internal pure returns (uint256) {
288         unchecked {
289             require(b <= a, errorMessage);
290             return a - b;
291         }
292     }
293 
294     /**
295      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
296      * division by zero. The result is rounded towards zero.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(
307         uint256 a,
308         uint256 b,
309         string memory errorMessage
310     ) internal pure returns (uint256) {
311         unchecked {
312             require(b > 0, errorMessage);
313             return a / b;
314         }
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * reverting with custom message when dividing by zero.
320      *
321      * CAUTION: This function is deprecated because it requires allocating memory for the error
322      * message unnecessarily. For custom revert reasons use {tryMod}.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(
333         uint256 a,
334         uint256 b,
335         string memory errorMessage
336     ) internal pure returns (uint256) {
337         unchecked {
338             require(b > 0, errorMessage);
339             return a % b;
340         }
341     }
342 }
343 
344 // File: @openzeppelin/contracts/utils/Strings.sol
345 
346 
347 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
348 
349 pragma solidity ^0.8.0;
350 
351 /**
352  * @dev String operations.
353  */
354 library Strings {
355     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
356 
357     /**
358      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
359      */
360     function toString(uint256 value) internal pure returns (string memory) {
361         // Inspired by OraclizeAPI's implementation - MIT licence
362         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
363 
364         if (value == 0) {
365             return "0";
366         }
367         uint256 temp = value;
368         uint256 digits;
369         while (temp != 0) {
370             digits++;
371             temp /= 10;
372         }
373         bytes memory buffer = new bytes(digits);
374         while (value != 0) {
375             digits -= 1;
376             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
377             value /= 10;
378         }
379         return string(buffer);
380     }
381 
382     /**
383      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
384      */
385     function toHexString(uint256 value) internal pure returns (string memory) {
386         if (value == 0) {
387             return "0x00";
388         }
389         uint256 temp = value;
390         uint256 length = 0;
391         while (temp != 0) {
392             length++;
393             temp >>= 8;
394         }
395         return toHexString(value, length);
396     }
397 
398     /**
399      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
400      */
401     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
402         bytes memory buffer = new bytes(2 * length + 2);
403         buffer[0] = "0";
404         buffer[1] = "x";
405         for (uint256 i = 2 * length + 1; i > 1; --i) {
406             buffer[i] = _HEX_SYMBOLS[value & 0xf];
407             value >>= 4;
408         }
409         require(value == 0, "Strings: hex length insufficient");
410         return string(buffer);
411     }
412 }
413 
414 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
415 
416 
417 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
418 
419 pragma solidity ^0.8.0;
420 
421 
422 /**
423  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
424  *
425  * These functions can be used to verify that a message was signed by the holder
426  * of the private keys of a given address.
427  */
428 library ECDSA {
429     enum RecoverError {
430         NoError,
431         InvalidSignature,
432         InvalidSignatureLength,
433         InvalidSignatureS,
434         InvalidSignatureV
435     }
436 
437     function _throwError(RecoverError error) private pure {
438         if (error == RecoverError.NoError) {
439             return; // no error: do nothing
440         } else if (error == RecoverError.InvalidSignature) {
441             revert("ECDSA: invalid signature");
442         } else if (error == RecoverError.InvalidSignatureLength) {
443             revert("ECDSA: invalid signature length");
444         } else if (error == RecoverError.InvalidSignatureS) {
445             revert("ECDSA: invalid signature 's' value");
446         } else if (error == RecoverError.InvalidSignatureV) {
447             revert("ECDSA: invalid signature 'v' value");
448         }
449     }
450 
451     /**
452      * @dev Returns the address that signed a hashed message (`hash`) with
453      * `signature` or error string. This address can then be used for verification purposes.
454      *
455      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
456      * this function rejects them by requiring the `s` value to be in the lower
457      * half order, and the `v` value to be either 27 or 28.
458      *
459      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
460      * verification to be secure: it is possible to craft signatures that
461      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
462      * this is by receiving a hash of the original message (which may otherwise
463      * be too long), and then calling {toEthSignedMessageHash} on it.
464      *
465      * Documentation for signature generation:
466      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
467      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
468      *
469      * _Available since v4.3._
470      */
471     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
472         // Check the signature length
473         // - case 65: r,s,v signature (standard)
474         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
475         if (signature.length == 65) {
476             bytes32 r;
477             bytes32 s;
478             uint8 v;
479             // ecrecover takes the signature parameters, and the only way to get them
480             // currently is to use assembly.
481             assembly {
482                 r := mload(add(signature, 0x20))
483                 s := mload(add(signature, 0x40))
484                 v := byte(0, mload(add(signature, 0x60)))
485             }
486             return tryRecover(hash, v, r, s);
487         } else if (signature.length == 64) {
488             bytes32 r;
489             bytes32 vs;
490             // ecrecover takes the signature parameters, and the only way to get them
491             // currently is to use assembly.
492             assembly {
493                 r := mload(add(signature, 0x20))
494                 vs := mload(add(signature, 0x40))
495             }
496             return tryRecover(hash, r, vs);
497         } else {
498             return (address(0), RecoverError.InvalidSignatureLength);
499         }
500     }
501 
502     /**
503      * @dev Returns the address that signed a hashed message (`hash`) with
504      * `signature`. This address can then be used for verification purposes.
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
515      */
516     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
517         (address recovered, RecoverError error) = tryRecover(hash, signature);
518         _throwError(error);
519         return recovered;
520     }
521 
522     /**
523      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
524      *
525      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
526      *
527      * _Available since v4.3._
528      */
529     function tryRecover(
530         bytes32 hash,
531         bytes32 r,
532         bytes32 vs
533     ) internal pure returns (address, RecoverError) {
534         bytes32 s;
535         uint8 v;
536         assembly {
537             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
538             v := add(shr(255, vs), 27)
539         }
540         return tryRecover(hash, v, r, s);
541     }
542 
543     /**
544      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
545      *
546      * _Available since v4.2._
547      */
548     function recover(
549         bytes32 hash,
550         bytes32 r,
551         bytes32 vs
552     ) internal pure returns (address) {
553         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
554         _throwError(error);
555         return recovered;
556     }
557 
558     /**
559      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
560      * `r` and `s` signature fields separately.
561      *
562      * _Available since v4.3._
563      */
564     function tryRecover(
565         bytes32 hash,
566         uint8 v,
567         bytes32 r,
568         bytes32 s
569     ) internal pure returns (address, RecoverError) {
570         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
571         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
572         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
573         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
574         //
575         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
576         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
577         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
578         // these malleable signatures as well.
579         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
580             return (address(0), RecoverError.InvalidSignatureS);
581         }
582         if (v != 27 && v != 28) {
583             return (address(0), RecoverError.InvalidSignatureV);
584         }
585 
586         // If the signature is valid (and not malleable), return the signer address
587         address signer = ecrecover(hash, v, r, s);
588         if (signer == address(0)) {
589             return (address(0), RecoverError.InvalidSignature);
590         }
591 
592         return (signer, RecoverError.NoError);
593     }
594 
595     /**
596      * @dev Overload of {ECDSA-recover} that receives the `v`,
597      * `r` and `s` signature fields separately.
598      */
599     function recover(
600         bytes32 hash,
601         uint8 v,
602         bytes32 r,
603         bytes32 s
604     ) internal pure returns (address) {
605         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
606         _throwError(error);
607         return recovered;
608     }
609 
610     /**
611      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
612      * produces hash corresponding to the one signed with the
613      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
614      * JSON-RPC method as part of EIP-191.
615      *
616      * See {recover}.
617      */
618     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
619         // 32 is the length in bytes of hash,
620         // enforced by the type signature above
621         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
622     }
623 
624     /**
625      * @dev Returns an Ethereum Signed Message, created from `s`. This
626      * produces hash corresponding to the one signed with the
627      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
628      * JSON-RPC method as part of EIP-191.
629      *
630      * See {recover}.
631      */
632     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
633         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
634     }
635 
636     /**
637      * @dev Returns an Ethereum Signed Typed Data, created from a
638      * `domainSeparator` and a `structHash`. This produces hash corresponding
639      * to the one signed with the
640      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
641      * JSON-RPC method as part of EIP-712.
642      *
643      * See {recover}.
644      */
645     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
646         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
647     }
648 }
649 
650 // File: @openzeppelin/contracts/utils/Context.sol
651 
652 
653 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
654 
655 pragma solidity ^0.8.0;
656 
657 /**
658  * @dev Provides information about the current execution context, including the
659  * sender of the transaction and its data. While these are generally available
660  * via msg.sender and msg.data, they should not be accessed in such a direct
661  * manner, since when dealing with meta-transactions the account sending and
662  * paying for execution may not be the actual sender (as far as an application
663  * is concerned).
664  *
665  * This contract is only required for intermediate, library-like contracts.
666  */
667 abstract contract Context {
668     function _msgSender() internal view virtual returns (address) {
669         return msg.sender;
670     }
671 
672     function _msgData() internal view virtual returns (bytes calldata) {
673         return msg.data;
674     }
675 }
676 
677 // File: @openzeppelin/contracts/access/Ownable.sol
678 
679 
680 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
681 
682 pragma solidity ^0.8.0;
683 
684 
685 /**
686  * @dev Contract module which provides a basic access control mechanism, where
687  * there is an account (an owner) that can be granted exclusive access to
688  * specific functions.
689  *
690  * By default, the owner account will be the one that deploys the contract. This
691  * can later be changed with {transferOwnership}.
692  *
693  * This module is used through inheritance. It will make available the modifier
694  * `onlyOwner`, which can be applied to your functions to restrict their use to
695  * the owner.
696  */
697 abstract contract Ownable is Context {
698     address private _owner;
699 
700     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
701 
702     /**
703      * @dev Initializes the contract setting the deployer as the initial owner.
704      */
705     constructor() {
706         _transferOwnership(_msgSender());
707     }
708 
709     /**
710      * @dev Returns the address of the current owner.
711      */
712     function owner() public view virtual returns (address) {
713         return _owner;
714     }
715 
716     /**
717      * @dev Throws if called by any account other than the owner.
718      */
719     modifier onlyOwner() {
720         require(owner() == _msgSender(), "Ownable: caller is not the owner");
721         _;
722     }
723 
724     /**
725      * @dev Leaves the contract without owner. It will not be possible to call
726      * `onlyOwner` functions anymore. Can only be called by the current owner.
727      *
728      * NOTE: Renouncing ownership will leave the contract without an owner,
729      * thereby removing any functionality that is only available to the owner.
730      */
731     function renounceOwnership() public virtual onlyOwner {
732         _transferOwnership(address(0));
733     }
734 
735     /**
736      * @dev Transfers ownership of the contract to a new account (`newOwner`).
737      * Can only be called by the current owner.
738      */
739     function transferOwnership(address newOwner) public virtual onlyOwner {
740         require(newOwner != address(0), "Ownable: new owner is the zero address");
741         _transferOwnership(newOwner);
742     }
743 
744     /**
745      * @dev Transfers ownership of the contract to a new account (`newOwner`).
746      * Internal function without access restriction.
747      */
748     function _transferOwnership(address newOwner) internal virtual {
749         address oldOwner = _owner;
750         _owner = newOwner;
751         emit OwnershipTransferred(oldOwner, newOwner);
752     }
753 }
754 
755 // File: @openzeppelin/contracts/utils/Address.sol
756 
757 
758 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
759 
760 pragma solidity ^0.8.0;
761 
762 /**
763  * @dev Collection of functions related to the address type
764  */
765 library Address {
766     /**
767      * @dev Returns true if `account` is a contract.
768      *
769      * [IMPORTANT]
770      * ====
771      * It is unsafe to assume that an address for which this function returns
772      * false is an externally-owned account (EOA) and not a contract.
773      *
774      * Among others, `isContract` will return false for the following
775      * types of addresses:
776      *
777      *  - an externally-owned account
778      *  - a contract in construction
779      *  - an address where a contract will be created
780      *  - an address where a contract lived, but was destroyed
781      * ====
782      */
783     function isContract(address account) internal view returns (bool) {
784         // This method relies on extcodesize, which returns 0 for contracts in
785         // construction, since the code is only stored at the end of the
786         // constructor execution.
787 
788         uint256 size;
789         assembly {
790             size := extcodesize(account)
791         }
792         return size > 0;
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
975 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
976 
977 
978 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
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
1005 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1006 
1007 
1008 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
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
1033 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1034 
1035 
1036 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
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
1064 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1065 
1066 
1067 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
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
1209 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1210 
1211 
1212 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
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
1238 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1239 
1240 
1241 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
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
1528     }
1529 
1530     /**
1531      * @dev Destroys `tokenId`.
1532      * The approval is cleared when the token is burned.
1533      *
1534      * Requirements:
1535      *
1536      * - `tokenId` must exist.
1537      *
1538      * Emits a {Transfer} event.
1539      */
1540     function _burn(uint256 tokenId) internal virtual {
1541         address owner = ERC721.ownerOf(tokenId);
1542 
1543         _beforeTokenTransfer(owner, address(0), tokenId);
1544 
1545         // Clear approvals
1546         _approve(address(0), tokenId);
1547 
1548         _balances[owner] -= 1;
1549         delete _owners[tokenId];
1550 
1551         emit Transfer(owner, address(0), tokenId);
1552     }
1553 
1554     /**
1555      * @dev Transfers `tokenId` from `from` to `to`.
1556      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1557      *
1558      * Requirements:
1559      *
1560      * - `to` cannot be the zero address.
1561      * - `tokenId` token must be owned by `from`.
1562      *
1563      * Emits a {Transfer} event.
1564      */
1565     function _transfer(
1566         address from,
1567         address to,
1568         uint256 tokenId
1569     ) internal virtual {
1570         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1571         require(to != address(0), "ERC721: transfer to the zero address");
1572 
1573         _beforeTokenTransfer(from, to, tokenId);
1574 
1575         // Clear approvals from the previous owner
1576         _approve(address(0), tokenId);
1577 
1578         _balances[from] -= 1;
1579         _balances[to] += 1;
1580         _owners[tokenId] = to;
1581 
1582         emit Transfer(from, to, tokenId);
1583     }
1584 
1585     /**
1586      * @dev Approve `to` to operate on `tokenId`
1587      *
1588      * Emits a {Approval} event.
1589      */
1590     function _approve(address to, uint256 tokenId) internal virtual {
1591         _tokenApprovals[tokenId] = to;
1592         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1593     }
1594 
1595     /**
1596      * @dev Approve `operator` to operate on all of `owner` tokens
1597      *
1598      * Emits a {ApprovalForAll} event.
1599      */
1600     function _setApprovalForAll(
1601         address owner,
1602         address operator,
1603         bool approved
1604     ) internal virtual {
1605         require(owner != operator, "ERC721: approve to caller");
1606         _operatorApprovals[owner][operator] = approved;
1607         emit ApprovalForAll(owner, operator, approved);
1608     }
1609 
1610     /**
1611      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1612      * The call is not executed if the target address is not a contract.
1613      *
1614      * @param from address representing the previous owner of the given token ID
1615      * @param to target address that will receive the tokens
1616      * @param tokenId uint256 ID of the token to be transferred
1617      * @param _data bytes optional data to send along with the call
1618      * @return bool whether the call correctly returned the expected magic value
1619      */
1620     function _checkOnERC721Received(
1621         address from,
1622         address to,
1623         uint256 tokenId,
1624         bytes memory _data
1625     ) private returns (bool) {
1626         if (to.isContract()) {
1627             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1628                 return retval == IERC721Receiver.onERC721Received.selector;
1629             } catch (bytes memory reason) {
1630                 if (reason.length == 0) {
1631                     revert("ERC721: transfer to non ERC721Receiver implementer");
1632                 } else {
1633                     assembly {
1634                         revert(add(32, reason), mload(reason))
1635                     }
1636                 }
1637             }
1638         } else {
1639             return true;
1640         }
1641     }
1642 
1643     /**
1644      * @dev Hook that is called before any token transfer. This includes minting
1645      * and burning.
1646      *
1647      * Calling conditions:
1648      *
1649      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1650      * transferred to `to`.
1651      * - When `from` is zero, `tokenId` will be minted for `to`.
1652      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1653      * - `from` and `to` are never both zero.
1654      *
1655      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1656      */
1657     function _beforeTokenTransfer(
1658         address from,
1659         address to,
1660         uint256 tokenId
1661     ) internal virtual {}
1662 }
1663 
1664 // File: contracts/flat.sol
1665 
1666 
1667 pragma solidity ^0.8.0;
1668 
1669 
1670 
1671 
1672 
1673 
1674 
1675 
1676 contract BabyEthaliens is ERC721, Ownable, ReentrancyGuard {
1677   using SafeMath for uint256;
1678   using ECDSA for bytes32;
1679   using Counters for Counters.Counter;
1680   using Strings for uint256;
1681 
1682   /**
1683    * @dev Aliens Incoming
1684    * */
1685 
1686 
1687   uint256 public immutable MAX_BABY_ALIENS = 3750;
1688 
1689   string public tokenBaseURI;
1690   address public portalAddress;
1691 
1692   Counters.Counter public tokenSupply;
1693 
1694   /**
1695    * @dev Contract Methods
1696    */
1697 
1698   constructor(
1699 
1700   ) ERC721("Baby Ethalien", "BBYE") {
1701 
1702   }
1703 
1704 
1705 
1706   function setTokenBaseURI(string memory _baseURI) external onlyOwner {
1707     tokenBaseURI = _baseURI;
1708   }
1709 
1710   function setPortalAddress(address _portalAddress) external onlyOwner {
1711     portalAddress = _portalAddress;
1712   }
1713 
1714 
1715   function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1716 
1717     require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
1718 
1719     return string(abi.encodePacked(tokenBaseURI, _tokenId.toString()));
1720   }
1721 
1722   /********
1723    * Mint *
1724    ********/
1725 
1726   function publicMint(uint256 _quantity, address _breederAddress) external payable {
1727   
1728     _safeMintBabies(_quantity, _breederAddress);
1729   }
1730 
1731   function _safeMintBabies(uint256 _quantity, address _breederAddress) internal {
1732 
1733     uint256 currentToken = tokenSupply.current();
1734 
1735     require(_quantity > 0, "You must mint at least 1 Baby Alien");
1736     require(currentToken.add(_quantity) < MAX_BABY_ALIENS+1, "This purchase would exceed max supply of Baby Aliens");
1737     require(msg.sender == portalAddress, "Can only mint from breeding contract");
1738     for (uint256 i = 0; i < _quantity; i++) {
1739       uint256 mintIndex = currentToken;
1740 
1741       if (mintIndex < MAX_BABY_ALIENS) {
1742         tokenSupply.increment();
1743         _safeMint(_breederAddress, mintIndex);
1744       }
1745       currentToken += 1;
1746     }
1747   }
1748 
1749   function totalSupply() public view virtual returns (uint256) {
1750         return tokenSupply.current();
1751     }
1752 
1753 
1754 }