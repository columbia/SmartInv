1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
4 
5 
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
11  *
12  * These functions can be used to verify that a message was signed by the holder
13  * of the private keys of a given address.
14  */
15 library ECDSA {
16     enum RecoverError {
17         NoError,
18         InvalidSignature,
19         InvalidSignatureLength,
20         InvalidSignatureS,
21         InvalidSignatureV
22     }
23 
24     function _throwError(RecoverError error) private pure {
25         if (error == RecoverError.NoError) {
26             return; // no error: do nothing
27         } else if (error == RecoverError.InvalidSignature) {
28             revert("ECDSA: invalid signature");
29         } else if (error == RecoverError.InvalidSignatureLength) {
30             revert("ECDSA: invalid signature length");
31         } else if (error == RecoverError.InvalidSignatureS) {
32             revert("ECDSA: invalid signature 's' value");
33         } else if (error == RecoverError.InvalidSignatureV) {
34             revert("ECDSA: invalid signature 'v' value");
35         }
36     }
37 
38     /**
39      * @dev Returns the address that signed a hashed message (`hash`) with
40      * `signature` or error string. This address can then be used for verification purposes.
41      *
42      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
43      * this function rejects them by requiring the `s` value to be in the lower
44      * half order, and the `v` value to be either 27 or 28.
45      *
46      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
47      * verification to be secure: it is possible to craft signatures that
48      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
49      * this is by receiving a hash of the original message (which may otherwise
50      * be too long), and then calling {toEthSignedMessageHash} on it.
51      *
52      * Documentation for signature generation:
53      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
54      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
55      *
56      * _Available since v4.3._
57      */
58     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
59         // Check the signature length
60         // - case 65: r,s,v signature (standard)
61         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
62         if (signature.length == 65) {
63             bytes32 r;
64             bytes32 s;
65             uint8 v;
66             // ecrecover takes the signature parameters, and the only way to get them
67             // currently is to use assembly.
68             assembly {
69                 r := mload(add(signature, 0x20))
70                 s := mload(add(signature, 0x40))
71                 v := byte(0, mload(add(signature, 0x60)))
72             }
73             return tryRecover(hash, v, r, s);
74         } else if (signature.length == 64) {
75             bytes32 r;
76             bytes32 vs;
77             // ecrecover takes the signature parameters, and the only way to get them
78             // currently is to use assembly.
79             assembly {
80                 r := mload(add(signature, 0x20))
81                 vs := mload(add(signature, 0x40))
82             }
83             return tryRecover(hash, r, vs);
84         } else {
85             return (address(0), RecoverError.InvalidSignatureLength);
86         }
87     }
88 
89     /**
90      * @dev Returns the address that signed a hashed message (`hash`) with
91      * `signature`. This address can then be used for verification purposes.
92      *
93      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
94      * this function rejects them by requiring the `s` value to be in the lower
95      * half order, and the `v` value to be either 27 or 28.
96      *
97      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
98      * verification to be secure: it is possible to craft signatures that
99      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
100      * this is by receiving a hash of the original message (which may otherwise
101      * be too long), and then calling {toEthSignedMessageHash} on it.
102      */
103     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
104         (address recovered, RecoverError error) = tryRecover(hash, signature);
105         _throwError(error);
106         return recovered;
107     }
108 
109     /**
110      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
111      *
112      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
113      *
114      * _Available since v4.3._
115      */
116     function tryRecover(
117         bytes32 hash,
118         bytes32 r,
119         bytes32 vs
120     ) internal pure returns (address, RecoverError) {
121         bytes32 s;
122         uint8 v;
123         assembly {
124             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
125             v := add(shr(255, vs), 27)
126         }
127         return tryRecover(hash, v, r, s);
128     }
129 
130     /**
131      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
132      *
133      * _Available since v4.2._
134      */
135     function recover(
136         bytes32 hash,
137         bytes32 r,
138         bytes32 vs
139     ) internal pure returns (address) {
140         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
141         _throwError(error);
142         return recovered;
143     }
144 
145     /**
146      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
147      * `r` and `s` signature fields separately.
148      *
149      * _Available since v4.3._
150      */
151     function tryRecover(
152         bytes32 hash,
153         uint8 v,
154         bytes32 r,
155         bytes32 s
156     ) internal pure returns (address, RecoverError) {
157         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
158         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
159         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
160         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
161         //
162         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
163         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
164         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
165         // these malleable signatures as well.
166         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
167             return (address(0), RecoverError.InvalidSignatureS);
168         }
169         if (v != 27 && v != 28) {
170             return (address(0), RecoverError.InvalidSignatureV);
171         }
172 
173         // If the signature is valid (and not malleable), return the signer address
174         address signer = ecrecover(hash, v, r, s);
175         if (signer == address(0)) {
176             return (address(0), RecoverError.InvalidSignature);
177         }
178 
179         return (signer, RecoverError.NoError);
180     }
181 
182     /**
183      * @dev Overload of {ECDSA-recover} that receives the `v`,
184      * `r` and `s` signature fields separately.
185      */
186     function recover(
187         bytes32 hash,
188         uint8 v,
189         bytes32 r,
190         bytes32 s
191     ) internal pure returns (address) {
192         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
193         _throwError(error);
194         return recovered;
195     }
196 
197     /**
198      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
199      * produces hash corresponding to the one signed with the
200      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
201      * JSON-RPC method as part of EIP-191.
202      *
203      * See {recover}.
204      */
205     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
206         // 32 is the length in bytes of hash,
207         // enforced by the type signature above
208         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
209     }
210 
211     /**
212      * @dev Returns an Ethereum Signed Typed Data, created from a
213      * `domainSeparator` and a `structHash`. This produces hash corresponding
214      * to the one signed with the
215      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
216      * JSON-RPC method as part of EIP-712.
217      *
218      * See {recover}.
219      */
220     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
221         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
222     }
223 }
224 
225 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
226 
227 
228 
229 pragma solidity ^0.8.0;
230 
231 // CAUTION
232 // This version of SafeMath should only be used with Solidity 0.8 or later,
233 // because it relies on the compiler's built in overflow checks.
234 
235 /**
236  * @dev Wrappers over Solidity's arithmetic operations.
237  *
238  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
239  * now has built in overflow checking.
240  */
241 library SafeMath {
242     /**
243      * @dev Returns the addition of two unsigned integers, with an overflow flag.
244      *
245      * _Available since v3.4._
246      */
247     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
248         unchecked {
249             uint256 c = a + b;
250             if (c < a) return (false, 0);
251             return (true, c);
252         }
253     }
254 
255     /**
256      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
257      *
258      * _Available since v3.4._
259      */
260     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
261         unchecked {
262             if (b > a) return (false, 0);
263             return (true, a - b);
264         }
265     }
266 
267     /**
268      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
269      *
270      * _Available since v3.4._
271      */
272     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
273         unchecked {
274             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
275             // benefit is lost if 'b' is also tested.
276             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
277             if (a == 0) return (true, 0);
278             uint256 c = a * b;
279             if (c / a != b) return (false, 0);
280             return (true, c);
281         }
282     }
283 
284     /**
285      * @dev Returns the division of two unsigned integers, with a division by zero flag.
286      *
287      * _Available since v3.4._
288      */
289     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
290         unchecked {
291             if (b == 0) return (false, 0);
292             return (true, a / b);
293         }
294     }
295 
296     /**
297      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
298      *
299      * _Available since v3.4._
300      */
301     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
302         unchecked {
303             if (b == 0) return (false, 0);
304             return (true, a % b);
305         }
306     }
307 
308     /**
309      * @dev Returns the addition of two unsigned integers, reverting on
310      * overflow.
311      *
312      * Counterpart to Solidity's `+` operator.
313      *
314      * Requirements:
315      *
316      * - Addition cannot overflow.
317      */
318     function add(uint256 a, uint256 b) internal pure returns (uint256) {
319         return a + b;
320     }
321 
322     /**
323      * @dev Returns the subtraction of two unsigned integers, reverting on
324      * overflow (when the result is negative).
325      *
326      * Counterpart to Solidity's `-` operator.
327      *
328      * Requirements:
329      *
330      * - Subtraction cannot overflow.
331      */
332     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
333         return a - b;
334     }
335 
336     /**
337      * @dev Returns the multiplication of two unsigned integers, reverting on
338      * overflow.
339      *
340      * Counterpart to Solidity's `*` operator.
341      *
342      * Requirements:
343      *
344      * - Multiplication cannot overflow.
345      */
346     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
347         return a * b;
348     }
349 
350     /**
351      * @dev Returns the integer division of two unsigned integers, reverting on
352      * division by zero. The result is rounded towards zero.
353      *
354      * Counterpart to Solidity's `/` operator.
355      *
356      * Requirements:
357      *
358      * - The divisor cannot be zero.
359      */
360     function div(uint256 a, uint256 b) internal pure returns (uint256) {
361         return a / b;
362     }
363 
364     /**
365      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
366      * reverting when dividing by zero.
367      *
368      * Counterpart to Solidity's `%` operator. This function uses a `revert`
369      * opcode (which leaves remaining gas untouched) while Solidity uses an
370      * invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
377         return a % b;
378     }
379 
380     /**
381      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
382      * overflow (when the result is negative).
383      *
384      * CAUTION: This function is deprecated because it requires allocating memory for the error
385      * message unnecessarily. For custom revert reasons use {trySub}.
386      *
387      * Counterpart to Solidity's `-` operator.
388      *
389      * Requirements:
390      *
391      * - Subtraction cannot overflow.
392      */
393     function sub(
394         uint256 a,
395         uint256 b,
396         string memory errorMessage
397     ) internal pure returns (uint256) {
398         unchecked {
399             require(b <= a, errorMessage);
400             return a - b;
401         }
402     }
403 
404     /**
405      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
406      * division by zero. The result is rounded towards zero.
407      *
408      * Counterpart to Solidity's `/` operator. Note: this function uses a
409      * `revert` opcode (which leaves remaining gas untouched) while Solidity
410      * uses an invalid opcode to revert (consuming all remaining gas).
411      *
412      * Requirements:
413      *
414      * - The divisor cannot be zero.
415      */
416     function div(
417         uint256 a,
418         uint256 b,
419         string memory errorMessage
420     ) internal pure returns (uint256) {
421         unchecked {
422             require(b > 0, errorMessage);
423             return a / b;
424         }
425     }
426 
427     /**
428      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
429      * reverting with custom message when dividing by zero.
430      *
431      * CAUTION: This function is deprecated because it requires allocating memory for the error
432      * message unnecessarily. For custom revert reasons use {tryMod}.
433      *
434      * Counterpart to Solidity's `%` operator. This function uses a `revert`
435      * opcode (which leaves remaining gas untouched) while Solidity uses an
436      * invalid opcode to revert (consuming all remaining gas).
437      *
438      * Requirements:
439      *
440      * - The divisor cannot be zero.
441      */
442     function mod(
443         uint256 a,
444         uint256 b,
445         string memory errorMessage
446     ) internal pure returns (uint256) {
447         unchecked {
448             require(b > 0, errorMessage);
449             return a % b;
450         }
451     }
452 }
453 
454 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
455 
456 
457 
458 pragma solidity ^0.8.0;
459 
460 /**
461  * @dev Contract module that helps prevent reentrant calls to a function.
462  *
463  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
464  * available, which can be applied to functions to make sure there are no nested
465  * (reentrant) calls to them.
466  *
467  * Note that because there is a single `nonReentrant` guard, functions marked as
468  * `nonReentrant` may not call one another. This can be worked around by making
469  * those functions `private`, and then adding `external` `nonReentrant` entry
470  * points to them.
471  *
472  * TIP: If you would like to learn more about reentrancy and alternative ways
473  * to protect against it, check out our blog post
474  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
475  */
476 abstract contract ReentrancyGuard {
477     // Booleans are more expensive than uint256 or any type that takes up a full
478     // word because each write operation emits an extra SLOAD to first read the
479     // slot's contents, replace the bits taken up by the boolean, and then write
480     // back. This is the compiler's defense against contract upgrades and
481     // pointer aliasing, and it cannot be disabled.
482 
483     // The values being non-zero value makes deployment a bit more expensive,
484     // but in exchange the refund on every call to nonReentrant will be lower in
485     // amount. Since refunds are capped to a percentage of the total
486     // transaction's gas, it is best to keep them low in cases like this one, to
487     // increase the likelihood of the full refund coming into effect.
488     uint256 private constant _NOT_ENTERED = 1;
489     uint256 private constant _ENTERED = 2;
490 
491     uint256 private _status;
492 
493     constructor() {
494         _status = _NOT_ENTERED;
495     }
496 
497     /**
498      * @dev Prevents a contract from calling itself, directly or indirectly.
499      * Calling a `nonReentrant` function from another `nonReentrant`
500      * function is not supported. It is possible to prevent this from happening
501      * by making the `nonReentrant` function external, and make it call a
502      * `private` function that does the actual work.
503      */
504     modifier nonReentrant() {
505         // On the first call to nonReentrant, _notEntered will be true
506         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
507 
508         // Any calls to nonReentrant after this point will fail
509         _status = _ENTERED;
510 
511         _;
512 
513         // By storing the original value once again, a refund is triggered (see
514         // https://eips.ethereum.org/EIPS/eip-2200)
515         _status = _NOT_ENTERED;
516     }
517 }
518 
519 // File: @openzeppelin/contracts/utils/Counters.sol
520 
521 
522 
523 pragma solidity ^0.8.0;
524 
525 /**
526  * @title Counters
527  * @author Matt Condon (@shrugs)
528  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
529  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
530  *
531  * Include with `using Counters for Counters.Counter;`
532  */
533 library Counters {
534     struct Counter {
535         // This variable should never be directly accessed by users of the library: interactions must be restricted to
536         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
537         // this feature: see https://github.com/ethereum/solidity/issues/4637
538         uint256 _value; // default: 0
539     }
540 
541     function current(Counter storage counter) internal view returns (uint256) {
542         return counter._value;
543     }
544 
545     function increment(Counter storage counter) internal {
546         unchecked {
547             counter._value += 1;
548         }
549     }
550 
551     function decrement(Counter storage counter) internal {
552         uint256 value = counter._value;
553         require(value > 0, "Counter: decrement overflow");
554         unchecked {
555             counter._value = value - 1;
556         }
557     }
558 
559     function reset(Counter storage counter) internal {
560         counter._value = 0;
561     }
562 }
563 
564 // File: @openzeppelin/contracts/utils/Strings.sol
565 
566 
567 
568 pragma solidity ^0.8.0;
569 
570 /**
571  * @dev String operations.
572  */
573 library Strings {
574     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
575 
576     /**
577      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
578      */
579     function toString(uint256 value) internal pure returns (string memory) {
580         // Inspired by OraclizeAPI's implementation - MIT licence
581         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
582 
583         if (value == 0) {
584             return "0";
585         }
586         uint256 temp = value;
587         uint256 digits;
588         while (temp != 0) {
589             digits++;
590             temp /= 10;
591         }
592         bytes memory buffer = new bytes(digits);
593         while (value != 0) {
594             digits -= 1;
595             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
596             value /= 10;
597         }
598         return string(buffer);
599     }
600 
601     /**
602      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
603      */
604     function toHexString(uint256 value) internal pure returns (string memory) {
605         if (value == 0) {
606             return "0x00";
607         }
608         uint256 temp = value;
609         uint256 length = 0;
610         while (temp != 0) {
611             length++;
612             temp >>= 8;
613         }
614         return toHexString(value, length);
615     }
616 
617     /**
618      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
619      */
620     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
621         bytes memory buffer = new bytes(2 * length + 2);
622         buffer[0] = "0";
623         buffer[1] = "x";
624         for (uint256 i = 2 * length + 1; i > 1; --i) {
625             buffer[i] = _HEX_SYMBOLS[value & 0xf];
626             value >>= 4;
627         }
628         require(value == 0, "Strings: hex length insufficient");
629         return string(buffer);
630     }
631 }
632 
633 // File: @openzeppelin/contracts/utils/Context.sol
634 
635 
636 
637 pragma solidity ^0.8.0;
638 
639 /**
640  * @dev Provides information about the current execution context, including the
641  * sender of the transaction and its data. While these are generally available
642  * via msg.sender and msg.data, they should not be accessed in such a direct
643  * manner, since when dealing with meta-transactions the account sending and
644  * paying for execution may not be the actual sender (as far as an application
645  * is concerned).
646  *
647  * This contract is only required for intermediate, library-like contracts.
648  */
649 abstract contract Context {
650     function _msgSender() internal view virtual returns (address) {
651         return msg.sender;
652     }
653 
654     function _msgData() internal view virtual returns (bytes calldata) {
655         return msg.data;
656     }
657 }
658 
659 // File: @openzeppelin/contracts/access/Ownable.sol
660 
661 
662 
663 pragma solidity ^0.8.0;
664 
665 
666 /**
667  * @dev Contract module which provides a basic access control mechanism, where
668  * there is an account (an owner) that can be granted exclusive access to
669  * specific functions.
670  *
671  * By default, the owner account will be the one that deploys the contract. This
672  * can later be changed with {transferOwnership}.
673  *
674  * This module is used through inheritance. It will make available the modifier
675  * `onlyOwner`, which can be applied to your functions to restrict their use to
676  * the owner.
677  */
678 abstract contract Ownable is Context {
679     address private _owner;
680 
681     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
682 
683     /**
684      * @dev Initializes the contract setting the deployer as the initial owner.
685      */
686     constructor() {
687         _setOwner(_msgSender());
688     }
689 
690     /**
691      * @dev Returns the address of the current owner.
692      */
693     function owner() public view virtual returns (address) {
694         return _owner;
695     }
696 
697     /**
698      * @dev Throws if called by any account other than the owner.
699      */
700     modifier onlyOwner() {
701         require(owner() == _msgSender(), "Ownable: caller is not the owner");
702         _;
703     }
704 
705     /**
706      * @dev Leaves the contract without owner. It will not be possible to call
707      * `onlyOwner` functions anymore. Can only be called by the current owner.
708      *
709      * NOTE: Renouncing ownership will leave the contract without an owner,
710      * thereby removing any functionality that is only available to the owner.
711      */
712     function renounceOwnership() public virtual onlyOwner {
713         _setOwner(address(0));
714     }
715 
716     /**
717      * @dev Transfers ownership of the contract to a new account (`newOwner`).
718      * Can only be called by the current owner.
719      */
720     function transferOwnership(address newOwner) public virtual onlyOwner {
721         require(newOwner != address(0), "Ownable: new owner is the zero address");
722         _setOwner(newOwner);
723     }
724 
725     function _setOwner(address newOwner) private {
726         address oldOwner = _owner;
727         _owner = newOwner;
728         emit OwnershipTransferred(oldOwner, newOwner);
729     }
730 }
731 
732 // File: @openzeppelin/contracts/utils/Address.sol
733 
734 
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @dev Collection of functions related to the address type
740  */
741 library Address {
742     /**
743      * @dev Returns true if `account` is a contract.
744      *
745      * [IMPORTANT]
746      * ====
747      * It is unsafe to assume that an address for which this function returns
748      * false is an externally-owned account (EOA) and not a contract.
749      *
750      * Among others, `isContract` will return false for the following
751      * types of addresses:
752      *
753      *  - an externally-owned account
754      *  - a contract in construction
755      *  - an address where a contract will be created
756      *  - an address where a contract lived, but was destroyed
757      * ====
758      */
759     function isContract(address account) internal view returns (bool) {
760         // This method relies on extcodesize, which returns 0 for contracts in
761         // construction, since the code is only stored at the end of the
762         // constructor execution.
763 
764         uint256 size;
765         assembly {
766             size := extcodesize(account)
767         }
768         return size > 0;
769     }
770 
771     /**
772      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
773      * `recipient`, forwarding all available gas and reverting on errors.
774      *
775      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
776      * of certain opcodes, possibly making contracts go over the 2300 gas limit
777      * imposed by `transfer`, making them unable to receive funds via
778      * `transfer`. {sendValue} removes this limitation.
779      *
780      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
781      *
782      * IMPORTANT: because control is transferred to `recipient`, care must be
783      * taken to not create reentrancy vulnerabilities. Consider using
784      * {ReentrancyGuard} or the
785      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
786      */
787     function sendValue(address payable recipient, uint256 amount) internal {
788         require(address(this).balance >= amount, "Address: insufficient balance");
789 
790         (bool success, ) = recipient.call{value: amount}("");
791         require(success, "Address: unable to send value, recipient may have reverted");
792     }
793 
794     /**
795      * @dev Performs a Solidity function call using a low level `call`. A
796      * plain `call` is an unsafe replacement for a function call: use this
797      * function instead.
798      *
799      * If `target` reverts with a revert reason, it is bubbled up by this
800      * function (like regular Solidity function calls).
801      *
802      * Returns the raw returned data. To convert to the expected return value,
803      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
804      *
805      * Requirements:
806      *
807      * - `target` must be a contract.
808      * - calling `target` with `data` must not revert.
809      *
810      * _Available since v3.1._
811      */
812     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
813         return functionCall(target, data, "Address: low-level call failed");
814     }
815 
816     /**
817      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
818      * `errorMessage` as a fallback revert reason when `target` reverts.
819      *
820      * _Available since v3.1._
821      */
822     function functionCall(
823         address target,
824         bytes memory data,
825         string memory errorMessage
826     ) internal returns (bytes memory) {
827         return functionCallWithValue(target, data, 0, errorMessage);
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
832      * but also transferring `value` wei to `target`.
833      *
834      * Requirements:
835      *
836      * - the calling contract must have an ETH balance of at least `value`.
837      * - the called Solidity function must be `payable`.
838      *
839      * _Available since v3.1._
840      */
841     function functionCallWithValue(
842         address target,
843         bytes memory data,
844         uint256 value
845     ) internal returns (bytes memory) {
846         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
847     }
848 
849     /**
850      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
851      * with `errorMessage` as a fallback revert reason when `target` reverts.
852      *
853      * _Available since v3.1._
854      */
855     function functionCallWithValue(
856         address target,
857         bytes memory data,
858         uint256 value,
859         string memory errorMessage
860     ) internal returns (bytes memory) {
861         require(address(this).balance >= value, "Address: insufficient balance for call");
862         require(isContract(target), "Address: call to non-contract");
863 
864         (bool success, bytes memory returndata) = target.call{value: value}(data);
865         return verifyCallResult(success, returndata, errorMessage);
866     }
867 
868     /**
869      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
870      * but performing a static call.
871      *
872      * _Available since v3.3._
873      */
874     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
875         return functionStaticCall(target, data, "Address: low-level static call failed");
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
880      * but performing a static call.
881      *
882      * _Available since v3.3._
883      */
884     function functionStaticCall(
885         address target,
886         bytes memory data,
887         string memory errorMessage
888     ) internal view returns (bytes memory) {
889         require(isContract(target), "Address: static call to non-contract");
890 
891         (bool success, bytes memory returndata) = target.staticcall(data);
892         return verifyCallResult(success, returndata, errorMessage);
893     }
894 
895     /**
896      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
897      * but performing a delegate call.
898      *
899      * _Available since v3.4._
900      */
901     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
902         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
903     }
904 
905     /**
906      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
907      * but performing a delegate call.
908      *
909      * _Available since v3.4._
910      */
911     function functionDelegateCall(
912         address target,
913         bytes memory data,
914         string memory errorMessage
915     ) internal returns (bytes memory) {
916         require(isContract(target), "Address: delegate call to non-contract");
917 
918         (bool success, bytes memory returndata) = target.delegatecall(data);
919         return verifyCallResult(success, returndata, errorMessage);
920     }
921 
922     /**
923      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
924      * revert reason using the provided one.
925      *
926      * _Available since v4.3._
927      */
928     function verifyCallResult(
929         bool success,
930         bytes memory returndata,
931         string memory errorMessage
932     ) internal pure returns (bytes memory) {
933         if (success) {
934             return returndata;
935         } else {
936             // Look for revert reason and bubble it up if present
937             if (returndata.length > 0) {
938                 // The easiest way to bubble the revert reason is using memory via assembly
939 
940                 assembly {
941                     let returndata_size := mload(returndata)
942                     revert(add(32, returndata), returndata_size)
943                 }
944             } else {
945                 revert(errorMessage);
946             }
947         }
948     }
949 }
950 
951 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
952 
953 
954 
955 pragma solidity ^0.8.0;
956 
957 
958 
959 
960 /**
961  * @title PaymentSplitter
962  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
963  * that the Ether will be split in this way, since it is handled transparently by the contract.
964  *
965  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
966  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
967  * an amount proportional to the percentage of total shares they were assigned.
968  *
969  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
970  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
971  * function.
972  */
973 contract PaymentSplitter is Context {
974     event PayeeAdded(address account, uint256 shares);
975     event PaymentReleased(address to, uint256 amount);
976     event PaymentReceived(address from, uint256 amount);
977 
978     uint256 private _totalShares;
979     uint256 private _totalReleased;
980 
981     mapping(address => uint256) private _shares;
982     mapping(address => uint256) private _released;
983     address[] private _payees;
984 
985     /**
986      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
987      * the matching position in the `shares` array.
988      *
989      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
990      * duplicates in `payees`.
991      */
992     constructor(address[] memory payees, uint256[] memory shares_) payable {
993         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
994         require(payees.length > 0, "PaymentSplitter: no payees");
995 
996         for (uint256 i = 0; i < payees.length; i++) {
997             _addPayee(payees[i], shares_[i]);
998         }
999     }
1000 
1001     /**
1002      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
1003      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
1004      * reliability of the events, and not the actual splitting of Ether.
1005      *
1006      * To learn more about this see the Solidity documentation for
1007      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
1008      * functions].
1009      */
1010     receive() external payable virtual {
1011         emit PaymentReceived(_msgSender(), msg.value);
1012     }
1013 
1014     /**
1015      * @dev Getter for the total shares held by payees.
1016      */
1017     function totalShares() public view returns (uint256) {
1018         return _totalShares;
1019     }
1020 
1021     /**
1022      * @dev Getter for the total amount of Ether already released.
1023      */
1024     function totalReleased() public view returns (uint256) {
1025         return _totalReleased;
1026     }
1027 
1028     /**
1029      * @dev Getter for the amount of shares held by an account.
1030      */
1031     function shares(address account) public view returns (uint256) {
1032         return _shares[account];
1033     }
1034 
1035     /**
1036      * @dev Getter for the amount of Ether already released to a payee.
1037      */
1038     function released(address account) public view returns (uint256) {
1039         return _released[account];
1040     }
1041 
1042     /**
1043      * @dev Getter for the address of the payee number `index`.
1044      */
1045     function payee(uint256 index) public view returns (address) {
1046         return _payees[index];
1047     }
1048 
1049     /**
1050      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
1051      * total shares and their previous withdrawals.
1052      */
1053     function release(address payable account) public virtual {
1054         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
1055 
1056         uint256 totalReceived = address(this).balance + _totalReleased;
1057         uint256 payment = (totalReceived * _shares[account]) / _totalShares - _released[account];
1058 
1059         require(payment != 0, "PaymentSplitter: account is not due payment");
1060 
1061         _released[account] = _released[account] + payment;
1062         _totalReleased = _totalReleased + payment;
1063 
1064         Address.sendValue(account, payment);
1065         emit PaymentReleased(account, payment);
1066     }
1067 
1068     /**
1069      * @dev Add a new payee to the contract.
1070      * @param account The address of the payee to add.
1071      * @param shares_ The number of shares owned by the payee.
1072      */
1073     function _addPayee(address account, uint256 shares_) private {
1074         require(account != address(0), "PaymentSplitter: account is the zero address");
1075         require(shares_ > 0, "PaymentSplitter: shares are 0");
1076         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
1077 
1078         _payees.push(account);
1079         _shares[account] = shares_;
1080         _totalShares = _totalShares + shares_;
1081         emit PayeeAdded(account, shares_);
1082     }
1083 }
1084 
1085 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1086 
1087 
1088 
1089 pragma solidity ^0.8.0;
1090 
1091 /**
1092  * @title ERC721 token receiver interface
1093  * @dev Interface for any contract that wants to support safeTransfers
1094  * from ERC721 asset contracts.
1095  */
1096 interface IERC721Receiver {
1097     /**
1098      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1099      * by `operator` from `from`, this function is called.
1100      *
1101      * It must return its Solidity selector to confirm the token transfer.
1102      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1103      *
1104      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1105      */
1106     function onERC721Received(
1107         address operator,
1108         address from,
1109         uint256 tokenId,
1110         bytes calldata data
1111     ) external returns (bytes4);
1112 }
1113 
1114 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1115 
1116 
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @dev Interface of the ERC165 standard, as defined in the
1122  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1123  *
1124  * Implementers can declare support of contract interfaces, which can then be
1125  * queried by others ({ERC165Checker}).
1126  *
1127  * For an implementation, see {ERC165}.
1128  */
1129 interface IERC165 {
1130     /**
1131      * @dev Returns true if this contract implements the interface defined by
1132      * `interfaceId`. See the corresponding
1133      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1134      * to learn more about how these ids are created.
1135      *
1136      * This function call must use less than 30 000 gas.
1137      */
1138     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1139 }
1140 
1141 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1142 
1143 
1144 
1145 pragma solidity ^0.8.0;
1146 
1147 
1148 /**
1149  * @dev Implementation of the {IERC165} interface.
1150  *
1151  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1152  * for the additional interface id that will be supported. For example:
1153  *
1154  * ```solidity
1155  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1156  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1157  * }
1158  * ```
1159  *
1160  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1161  */
1162 abstract contract ERC165 is IERC165 {
1163     /**
1164      * @dev See {IERC165-supportsInterface}.
1165      */
1166     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1167         return interfaceId == type(IERC165).interfaceId;
1168     }
1169 }
1170 
1171 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1172 
1173 
1174 
1175 pragma solidity ^0.8.0;
1176 
1177 
1178 /**
1179  * @dev Required interface of an ERC721 compliant contract.
1180  */
1181 interface IERC721 is IERC165 {
1182     /**
1183      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1184      */
1185     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1186 
1187     /**
1188      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1189      */
1190     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1191 
1192     /**
1193      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1194      */
1195     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1196 
1197     /**
1198      * @dev Returns the number of tokens in ``owner``'s account.
1199      */
1200     function balanceOf(address owner) external view returns (uint256 balance);
1201 
1202     /**
1203      * @dev Returns the owner of the `tokenId` token.
1204      *
1205      * Requirements:
1206      *
1207      * - `tokenId` must exist.
1208      */
1209     function ownerOf(uint256 tokenId) external view returns (address owner);
1210 
1211     /**
1212      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1213      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1214      *
1215      * Requirements:
1216      *
1217      * - `from` cannot be the zero address.
1218      * - `to` cannot be the zero address.
1219      * - `tokenId` token must exist and be owned by `from`.
1220      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1221      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1222      *
1223      * Emits a {Transfer} event.
1224      */
1225     function safeTransferFrom(
1226         address from,
1227         address to,
1228         uint256 tokenId
1229     ) external;
1230 
1231     /**
1232      * @dev Transfers `tokenId` token from `from` to `to`.
1233      *
1234      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1235      *
1236      * Requirements:
1237      *
1238      * - `from` cannot be the zero address.
1239      * - `to` cannot be the zero address.
1240      * - `tokenId` token must be owned by `from`.
1241      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1242      *
1243      * Emits a {Transfer} event.
1244      */
1245     function transferFrom(
1246         address from,
1247         address to,
1248         uint256 tokenId
1249     ) external;
1250 
1251     /**
1252      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1253      * The approval is cleared when the token is transferred.
1254      *
1255      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1256      *
1257      * Requirements:
1258      *
1259      * - The caller must own the token or be an approved operator.
1260      * - `tokenId` must exist.
1261      *
1262      * Emits an {Approval} event.
1263      */
1264     function approve(address to, uint256 tokenId) external;
1265 
1266     /**
1267      * @dev Returns the account approved for `tokenId` token.
1268      *
1269      * Requirements:
1270      *
1271      * - `tokenId` must exist.
1272      */
1273     function getApproved(uint256 tokenId) external view returns (address operator);
1274 
1275     /**
1276      * @dev Approve or remove `operator` as an operator for the caller.
1277      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1278      *
1279      * Requirements:
1280      *
1281      * - The `operator` cannot be the caller.
1282      *
1283      * Emits an {ApprovalForAll} event.
1284      */
1285     function setApprovalForAll(address operator, bool _approved) external;
1286 
1287     /**
1288      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1289      *
1290      * See {setApprovalForAll}
1291      */
1292     function isApprovedForAll(address owner, address operator) external view returns (bool);
1293 
1294     /**
1295      * @dev Safely transfers `tokenId` token from `from` to `to`.
1296      *
1297      * Requirements:
1298      *
1299      * - `from` cannot be the zero address.
1300      * - `to` cannot be the zero address.
1301      * - `tokenId` token must exist and be owned by `from`.
1302      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1303      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1304      *
1305      * Emits a {Transfer} event.
1306      */
1307     function safeTransferFrom(
1308         address from,
1309         address to,
1310         uint256 tokenId,
1311         bytes calldata data
1312     ) external;
1313 }
1314 
1315 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1316 
1317 
1318 
1319 pragma solidity ^0.8.0;
1320 
1321 
1322 /**
1323  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1324  * @dev See https://eips.ethereum.org/EIPS/eip-721
1325  */
1326 interface IERC721Enumerable is IERC721 {
1327     /**
1328      * @dev Returns the total amount of tokens stored by the contract.
1329      */
1330     function totalSupply() external view returns (uint256);
1331 
1332     /**
1333      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1334      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1335      */
1336     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1337 
1338     /**
1339      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1340      * Use along with {totalSupply} to enumerate all tokens.
1341      */
1342     function tokenByIndex(uint256 index) external view returns (uint256);
1343 }
1344 
1345 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1346 
1347 
1348 
1349 pragma solidity ^0.8.0;
1350 
1351 
1352 /**
1353  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1354  * @dev See https://eips.ethereum.org/EIPS/eip-721
1355  */
1356 interface IERC721Metadata is IERC721 {
1357     /**
1358      * @dev Returns the token collection name.
1359      */
1360     function name() external view returns (string memory);
1361 
1362     /**
1363      * @dev Returns the token collection symbol.
1364      */
1365     function symbol() external view returns (string memory);
1366 
1367     /**
1368      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1369      */
1370     function tokenURI(uint256 tokenId) external view returns (string memory);
1371 }
1372 
1373 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1374 
1375 
1376 
1377 pragma solidity ^0.8.0;
1378 
1379 
1380 
1381 
1382 
1383 
1384 
1385 
1386 /**
1387  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1388  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1389  * {ERC721Enumerable}.
1390  */
1391 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1392     using Address for address;
1393     using Strings for uint256;
1394 
1395     // Token name
1396     string private _name;
1397 
1398     // Token symbol
1399     string private _symbol;
1400 
1401     // Mapping from token ID to owner address
1402     mapping(uint256 => address) private _owners;
1403 
1404     // Mapping owner address to token count
1405     mapping(address => uint256) private _balances;
1406 
1407     // Mapping from token ID to approved address
1408     mapping(uint256 => address) private _tokenApprovals;
1409 
1410     // Mapping from owner to operator approvals
1411     mapping(address => mapping(address => bool)) private _operatorApprovals;
1412 
1413     /**
1414      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1415      */
1416     constructor(string memory name_, string memory symbol_) {
1417         _name = name_;
1418         _symbol = symbol_;
1419     }
1420 
1421     /**
1422      * @dev See {IERC165-supportsInterface}.
1423      */
1424     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1425         return
1426             interfaceId == type(IERC721).interfaceId ||
1427             interfaceId == type(IERC721Metadata).interfaceId ||
1428             super.supportsInterface(interfaceId);
1429     }
1430 
1431     /**
1432      * @dev See {IERC721-balanceOf}.
1433      */
1434     function balanceOf(address owner) public view virtual override returns (uint256) {
1435         require(owner != address(0), "ERC721: balance query for the zero address");
1436         return _balances[owner];
1437     }
1438 
1439     /**
1440      * @dev See {IERC721-ownerOf}.
1441      */
1442     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1443         address owner = _owners[tokenId];
1444         require(owner != address(0), "ERC721: owner query for nonexistent token");
1445         return owner;
1446     }
1447 
1448     /**
1449      * @dev See {IERC721Metadata-name}.
1450      */
1451     function name() public view virtual override returns (string memory) {
1452         return _name;
1453     }
1454 
1455     /**
1456      * @dev See {IERC721Metadata-symbol}.
1457      */
1458     function symbol() public view virtual override returns (string memory) {
1459         return _symbol;
1460     }
1461 
1462     /**
1463      * @dev See {IERC721Metadata-tokenURI}.
1464      */
1465     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1466         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1467 
1468         string memory baseURI = _baseURI();
1469         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1470     }
1471 
1472     /**
1473      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1474      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1475      * by default, can be overriden in child contracts.
1476      */
1477     function _baseURI() internal view virtual returns (string memory) {
1478         return "";
1479     }
1480 
1481     /**
1482      * @dev See {IERC721-approve}.
1483      */
1484     function approve(address to, uint256 tokenId) public virtual override {
1485         address owner = ERC721.ownerOf(tokenId);
1486         require(to != owner, "ERC721: approval to current owner");
1487 
1488         require(
1489             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1490             "ERC721: approve caller is not owner nor approved for all"
1491         );
1492 
1493         _approve(to, tokenId);
1494     }
1495 
1496     /**
1497      * @dev See {IERC721-getApproved}.
1498      */
1499     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1500         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1501 
1502         return _tokenApprovals[tokenId];
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-setApprovalForAll}.
1507      */
1508     function setApprovalForAll(address operator, bool approved) public virtual override {
1509         require(operator != _msgSender(), "ERC721: approve to caller");
1510 
1511         _operatorApprovals[_msgSender()][operator] = approved;
1512         emit ApprovalForAll(_msgSender(), operator, approved);
1513     }
1514 
1515     /**
1516      * @dev See {IERC721-isApprovedForAll}.
1517      */
1518     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1519         return _operatorApprovals[owner][operator];
1520     }
1521 
1522     /**
1523      * @dev See {IERC721-transferFrom}.
1524      */
1525     function transferFrom(
1526         address from,
1527         address to,
1528         uint256 tokenId
1529     ) public virtual override {
1530         //solhint-disable-next-line max-line-length
1531         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1532 
1533         _transfer(from, to, tokenId);
1534     }
1535 
1536     /**
1537      * @dev See {IERC721-safeTransferFrom}.
1538      */
1539     function safeTransferFrom(
1540         address from,
1541         address to,
1542         uint256 tokenId
1543     ) public virtual override {
1544         safeTransferFrom(from, to, tokenId, "");
1545     }
1546 
1547     /**
1548      * @dev See {IERC721-safeTransferFrom}.
1549      */
1550     function safeTransferFrom(
1551         address from,
1552         address to,
1553         uint256 tokenId,
1554         bytes memory _data
1555     ) public virtual override {
1556         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1557         _safeTransfer(from, to, tokenId, _data);
1558     }
1559 
1560     /**
1561      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1562      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1563      *
1564      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1565      *
1566      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1567      * implement alternative mechanisms to perform token transfer, such as signature-based.
1568      *
1569      * Requirements:
1570      *
1571      * - `from` cannot be the zero address.
1572      * - `to` cannot be the zero address.
1573      * - `tokenId` token must exist and be owned by `from`.
1574      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1575      *
1576      * Emits a {Transfer} event.
1577      */
1578     function _safeTransfer(
1579         address from,
1580         address to,
1581         uint256 tokenId,
1582         bytes memory _data
1583     ) internal virtual {
1584         _transfer(from, to, tokenId);
1585         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1586     }
1587 
1588     /**
1589      * @dev Returns whether `tokenId` exists.
1590      *
1591      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1592      *
1593      * Tokens start existing when they are minted (`_mint`),
1594      * and stop existing when they are burned (`_burn`).
1595      */
1596     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1597         return _owners[tokenId] != address(0);
1598     }
1599 
1600     /**
1601      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1602      *
1603      * Requirements:
1604      *
1605      * - `tokenId` must exist.
1606      */
1607     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1608         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1609         address owner = ERC721.ownerOf(tokenId);
1610         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1611     }
1612 
1613     /**
1614      * @dev Safely mints `tokenId` and transfers it to `to`.
1615      *
1616      * Requirements:
1617      *
1618      * - `tokenId` must not exist.
1619      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1620      *
1621      * Emits a {Transfer} event.
1622      */
1623     function _safeMint(address to, uint256 tokenId) internal virtual {
1624         _safeMint(to, tokenId, "");
1625     }
1626 
1627     /**
1628      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1629      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1630      */
1631     function _safeMint(
1632         address to,
1633         uint256 tokenId,
1634         bytes memory _data
1635     ) internal virtual {
1636         _mint(to, tokenId);
1637         require(
1638             _checkOnERC721Received(address(0), to, tokenId, _data),
1639             "ERC721: transfer to non ERC721Receiver implementer"
1640         );
1641     }
1642 
1643     /**
1644      * @dev Mints `tokenId` and transfers it to `to`.
1645      *
1646      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1647      *
1648      * Requirements:
1649      *
1650      * - `tokenId` must not exist.
1651      * - `to` cannot be the zero address.
1652      *
1653      * Emits a {Transfer} event.
1654      */
1655     function _mint(address to, uint256 tokenId) internal virtual {
1656         require(to != address(0), "ERC721: mint to the zero address");
1657         require(!_exists(tokenId), "ERC721: token already minted");
1658 
1659         _beforeTokenTransfer(address(0), to, tokenId);
1660 
1661         _balances[to] += 1;
1662         _owners[tokenId] = to;
1663 
1664         emit Transfer(address(0), to, tokenId);
1665     }
1666 
1667     /**
1668      * @dev Destroys `tokenId`.
1669      * The approval is cleared when the token is burned.
1670      *
1671      * Requirements:
1672      *
1673      * - `tokenId` must exist.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _burn(uint256 tokenId) internal virtual {
1678         address owner = ERC721.ownerOf(tokenId);
1679 
1680         _beforeTokenTransfer(owner, address(0), tokenId);
1681 
1682         // Clear approvals
1683         _approve(address(0), tokenId);
1684 
1685         _balances[owner] -= 1;
1686         delete _owners[tokenId];
1687 
1688         emit Transfer(owner, address(0), tokenId);
1689     }
1690 
1691     /**
1692      * @dev Transfers `tokenId` from `from` to `to`.
1693      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
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
1706     ) internal virtual {
1707         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1708         require(to != address(0), "ERC721: transfer to the zero address");
1709 
1710         _beforeTokenTransfer(from, to, tokenId);
1711 
1712         // Clear approvals from the previous owner
1713         _approve(address(0), tokenId);
1714 
1715         _balances[from] -= 1;
1716         _balances[to] += 1;
1717         _owners[tokenId] = to;
1718 
1719         emit Transfer(from, to, tokenId);
1720     }
1721 
1722     /**
1723      * @dev Approve `to` to operate on `tokenId`
1724      *
1725      * Emits a {Approval} event.
1726      */
1727     function _approve(address to, uint256 tokenId) internal virtual {
1728         _tokenApprovals[tokenId] = to;
1729         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1730     }
1731 
1732     /**
1733      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1734      * The call is not executed if the target address is not a contract.
1735      *
1736      * @param from address representing the previous owner of the given token ID
1737      * @param to target address that will receive the tokens
1738      * @param tokenId uint256 ID of the token to be transferred
1739      * @param _data bytes optional data to send along with the call
1740      * @return bool whether the call correctly returned the expected magic value
1741      */
1742     function _checkOnERC721Received(
1743         address from,
1744         address to,
1745         uint256 tokenId,
1746         bytes memory _data
1747     ) private returns (bool) {
1748         if (to.isContract()) {
1749             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1750                 return retval == IERC721Receiver.onERC721Received.selector;
1751             } catch (bytes memory reason) {
1752                 if (reason.length == 0) {
1753                     revert("ERC721: transfer to non ERC721Receiver implementer");
1754                 } else {
1755                     assembly {
1756                         revert(add(32, reason), mload(reason))
1757                     }
1758                 }
1759             }
1760         } else {
1761             return true;
1762         }
1763     }
1764 
1765     /**
1766      * @dev Hook that is called before any token transfer. This includes minting
1767      * and burning.
1768      *
1769      * Calling conditions:
1770      *
1771      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1772      * transferred to `to`.
1773      * - When `from` is zero, `tokenId` will be minted for `to`.
1774      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1775      * - `from` and `to` are never both zero.
1776      *
1777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1778      */
1779     function _beforeTokenTransfer(
1780         address from,
1781         address to,
1782         uint256 tokenId
1783     ) internal virtual {}
1784 }
1785 
1786 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1787 
1788 
1789 
1790 pragma solidity ^0.8.0;
1791 
1792 
1793 
1794 /**
1795  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1796  * enumerability of all the token ids in the contract as well as all token ids owned by each
1797  * account.
1798  */
1799 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1800     // Mapping from owner to list of owned token IDs
1801     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1802 
1803     // Mapping from token ID to index of the owner tokens list
1804     mapping(uint256 => uint256) private _ownedTokensIndex;
1805 
1806     // Array with all token ids, used for enumeration
1807     uint256[] private _allTokens;
1808 
1809     // Mapping from token id to position in the allTokens array
1810     mapping(uint256 => uint256) private _allTokensIndex;
1811 
1812     /**
1813      * @dev See {IERC165-supportsInterface}.
1814      */
1815     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1816         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1817     }
1818 
1819     /**
1820      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1821      */
1822     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1823         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1824         return _ownedTokens[owner][index];
1825     }
1826 
1827     /**
1828      * @dev See {IERC721Enumerable-totalSupply}.
1829      */
1830     function totalSupply() public view virtual override returns (uint256) {
1831         return _allTokens.length;
1832     }
1833 
1834     /**
1835      * @dev See {IERC721Enumerable-tokenByIndex}.
1836      */
1837     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1838         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1839         return _allTokens[index];
1840     }
1841 
1842     /**
1843      * @dev Hook that is called before any token transfer. This includes minting
1844      * and burning.
1845      *
1846      * Calling conditions:
1847      *
1848      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1849      * transferred to `to`.
1850      * - When `from` is zero, `tokenId` will be minted for `to`.
1851      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1852      * - `from` cannot be the zero address.
1853      * - `to` cannot be the zero address.
1854      *
1855      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1856      */
1857     function _beforeTokenTransfer(
1858         address from,
1859         address to,
1860         uint256 tokenId
1861     ) internal virtual override {
1862         super._beforeTokenTransfer(from, to, tokenId);
1863 
1864         if (from == address(0)) {
1865             _addTokenToAllTokensEnumeration(tokenId);
1866         } else if (from != to) {
1867             _removeTokenFromOwnerEnumeration(from, tokenId);
1868         }
1869         if (to == address(0)) {
1870             _removeTokenFromAllTokensEnumeration(tokenId);
1871         } else if (to != from) {
1872             _addTokenToOwnerEnumeration(to, tokenId);
1873         }
1874     }
1875 
1876     /**
1877      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1878      * @param to address representing the new owner of the given token ID
1879      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1880      */
1881     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1882         uint256 length = ERC721.balanceOf(to);
1883         _ownedTokens[to][length] = tokenId;
1884         _ownedTokensIndex[tokenId] = length;
1885     }
1886 
1887     /**
1888      * @dev Private function to add a token to this extension's token tracking data structures.
1889      * @param tokenId uint256 ID of the token to be added to the tokens list
1890      */
1891     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1892         _allTokensIndex[tokenId] = _allTokens.length;
1893         _allTokens.push(tokenId);
1894     }
1895 
1896     /**
1897      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1898      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1899      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1900      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1901      * @param from address representing the previous owner of the given token ID
1902      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1903      */
1904     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1905         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1906         // then delete the last slot (swap and pop).
1907 
1908         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1909         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1910 
1911         // When the token to delete is the last token, the swap operation is unnecessary
1912         if (tokenIndex != lastTokenIndex) {
1913             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1914 
1915             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1916             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1917         }
1918 
1919         // This also deletes the contents at the last position of the array
1920         delete _ownedTokensIndex[tokenId];
1921         delete _ownedTokens[from][lastTokenIndex];
1922     }
1923 
1924     /**
1925      * @dev Private function to remove a token from this extension's token tracking data structures.
1926      * This has O(1) time complexity, but alters the order of the _allTokens array.
1927      * @param tokenId uint256 ID of the token to be removed from the tokens list
1928      */
1929     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1930         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1931         // then delete the last slot (swap and pop).
1932 
1933         uint256 lastTokenIndex = _allTokens.length - 1;
1934         uint256 tokenIndex = _allTokensIndex[tokenId];
1935 
1936         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1937         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1938         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1939         uint256 lastTokenId = _allTokens[lastTokenIndex];
1940 
1941         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1942         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1943 
1944         // This also deletes the contents at the last position of the array
1945         delete _allTokensIndex[tokenId];
1946         _allTokens.pop();
1947     }
1948 }
1949 
1950 // File: contracts/CrazyCamels.sol
1951 
1952 
1953 pragma solidity ^0.8.4;
1954 
1955 
1956 
1957 
1958 
1959 
1960 
1961 
1962 contract CrazyCamels is
1963     ERC721Enumerable,
1964     Ownable,
1965     ReentrancyGuard,
1966     PaymentSplitter
1967 {
1968     using Strings for uint256;
1969     using Counters for Counters.Counter;
1970     using ECDSA for bytes32;
1971 
1972     struct PresaleConfig {
1973         uint256 startTime;
1974         uint256 duration;
1975         uint256 maxCount;
1976     }
1977     struct SaleConfig {
1978         uint256 startTime;
1979         uint256 maxCount;
1980     }
1981     uint256 public maxSupply = 10000;
1982     uint256 public maxGiftSupply = 200;
1983     uint256 public giftCount;
1984     uint256 public presaleCount;
1985     uint256 public totalNFT;
1986     string public baseURI;
1987     string public notRevealedUri;
1988     string public baseExtension = ".json";
1989     bool public paused = false;
1990     bool public revealed = false;
1991     PresaleConfig public presaleConfig;
1992     SaleConfig public saleConfig;
1993     Counters.Counter private _tokenIds;
1994 
1995     uint256[] private _teamShares = [47, 47, 5, 1];
1996     address[] private _team = [
1997         0x3796838b5Bc7F443c0ae63853b4fAF9aa95A51f7,
1998         0xFE5A39B2609b80D11b7109e34577E65af7D86c07,
1999         0xfC64Eef2aC96cb744699F6abaa56BCF05f31aC41,
2000         0x7A8CE9C44493D02966d413268279a6047F93f592
2001     ];
2002 
2003     mapping(address => uint256) public _presaleClaimed;
2004     mapping(address => uint256) public _giftClaimed;
2005     mapping(address => uint256) public _saleClaimed;
2006     mapping(address => uint256) public _totalClaimed;
2007 
2008     enum WorkflowStatus {
2009         CheckOnPresale,
2010         Presale,
2011         Sale,
2012         SoldOut
2013     }
2014     WorkflowStatus public workflow;
2015     
2016     address public signerAddress = 0x937c11a1E9210c95Ff56D34229213CE750aE800e;
2017 
2018     event ChangePresaleConfig(
2019         uint256 _startTime,
2020         uint256 _duration,
2021         uint256 _maxCount
2022     );
2023     event ChangeSaleConfig(uint256 _startTime, uint256 _maxCount);
2024     event ChangeBaseURI(string _baseURI);
2025     event GiftMint(address indexed _recipient, uint256 _amount);
2026     event PresaleMint(address indexed _minter, uint256 _amount, uint256 _price);
2027     event SaleMint(address indexed _minter, uint256 _amount, uint256 _price);
2028     event WorkflowStatusChange(
2029         WorkflowStatus previousStatus,
2030         WorkflowStatus newStatus
2031     );
2032 
2033     constructor()
2034         ERC721("Crazy Camels", "Camel")
2035         PaymentSplitter(_team, _teamShares)
2036         ReentrancyGuard()
2037     {}
2038 
2039     function changePauseState() public onlyOwner {
2040         paused = !paused;
2041     }
2042 
2043     function setBaseURI(string calldata _tokenBaseURI) external onlyOwner {
2044         baseURI = _tokenBaseURI;
2045         emit ChangeBaseURI(_tokenBaseURI);
2046     }
2047 
2048     function _baseURI() internal view override returns (string memory) {
2049         return baseURI;
2050     }
2051 
2052     function reveal() public onlyOwner {
2053         revealed = true;
2054     }
2055     
2056     function setSignerAddress(address _signerAddress) external onlyOwner {
2057         require(_signerAddress != address(0));
2058         signerAddress = _signerAddress;
2059     }
2060 
2061 
2062     function setUpPresale(uint256 _duration) external onlyOwner {
2063         require(
2064             workflow == WorkflowStatus.CheckOnPresale,
2065             "ERROR: Unauthorized Transaction"
2066         );
2067         uint256 _startTime = block.timestamp;
2068         uint256 _maxCount = 1;
2069         presaleConfig = PresaleConfig(_startTime, _duration, _maxCount);
2070         emit ChangePresaleConfig(_startTime, _duration, _maxCount);
2071         workflow = WorkflowStatus.Presale;
2072         emit WorkflowStatusChange(
2073             WorkflowStatus.CheckOnPresale,
2074             WorkflowStatus.Presale
2075         );
2076     }
2077 
2078     function setUpSale() external onlyOwner {
2079         require(
2080             workflow == WorkflowStatus.Presale,
2081             "ERROR: Unauthorized Transaction"
2082         );
2083         PresaleConfig memory _presaleConfig = presaleConfig;
2084         uint256 _presaleEndTime = _presaleConfig.startTime +
2085             _presaleConfig.duration;
2086         require(block.timestamp > _presaleEndTime, "ERROR: Sale not started");
2087         uint256 _startTime = block.timestamp;
2088         uint256 _maxCount = 10;
2089         saleConfig = SaleConfig(_startTime, _maxCount);
2090         emit ChangeSaleConfig(_startTime, _maxCount);
2091         workflow = WorkflowStatus.Sale;
2092         emit WorkflowStatusChange(WorkflowStatus.Presale, WorkflowStatus.Sale);
2093     }
2094 
2095     function getPrice() public view returns (uint256) {
2096         uint256 _price;
2097         PresaleConfig memory _presaleConfig = presaleConfig;
2098         SaleConfig memory _saleConfig = saleConfig;
2099         if (
2100             block.timestamp <=
2101             _presaleConfig.startTime + _presaleConfig.duration
2102         ) {
2103             _price = 100000000000000000; //0.1 ETH
2104         } else if (block.timestamp <= _saleConfig.startTime + 6 hours) {
2105             _price = 300000000000000000; //0.3 ETH
2106         } else if (
2107             (block.timestamp > _saleConfig.startTime + 6 hours) &&
2108             (block.timestamp <= _saleConfig.startTime + 12 hours)
2109         ) {
2110             _price = 250000000000000000; //0.25 ETH
2111         } else {
2112             _price = 200000000000000000; //0.2 ETH
2113         }
2114         return _price;
2115     }
2116 
2117     function giftMint(address[] calldata _addresses) external onlyOwner {
2118         require(
2119             totalNFT + _addresses.length <= maxSupply,
2120             "ERROR: max total supply exceeded"
2121         );
2122 
2123         require(
2124             giftCount + _addresses.length <= maxGiftSupply,
2125             "ERROR: max gift supply exceeded"
2126         );
2127 
2128         uint256 _newItemId;
2129         for (uint256 ind = 0; ind < _addresses.length; ind++) {
2130             require(
2131                 _addresses[ind] != address(0),
2132                 "ERROR: recepient is the null address"
2133             );
2134             _tokenIds.increment();
2135             _newItemId = _tokenIds.current();
2136             _safeMint(_addresses[ind], _newItemId);
2137             _giftClaimed[_addresses[ind]] = _giftClaimed[_addresses[ind]] + 1;
2138             _totalClaimed[_addresses[ind]] = _totalClaimed[_addresses[ind]] + 1;
2139             totalNFT = totalNFT + 1;
2140             giftCount = giftCount + 1;
2141         }
2142     }
2143     
2144     function verifyAddressSigner(bytes32 messageHash, bytes memory signature) private view returns (bool) {
2145         return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
2146     }
2147 
2148     function hashMessage(address sender) private pure returns (bytes32) {
2149         return keccak256(abi.encode(sender));
2150     }
2151 
2152 
2153     function presaleMint(
2154         uint256 _amount,
2155         bytes32 messageHash,
2156         bytes calldata signature
2157         ) external payable nonReentrant {
2158         PresaleConfig memory _presaleConfig = presaleConfig;
2159         require(hashMessage(msg.sender) == messageHash, "BAD_HASH");
2160         require(verifyAddressSigner(messageHash, signature), "BAD_SIGNATURE");
2161         require(_amount == 1, "ERROR: amount is not 1");
2162         require(
2163             _presaleConfig.startTime > 0,
2164             "ERROR: Presale must be active to mint Crazy Camels"
2165         );
2166         require(
2167             block.timestamp >= _presaleConfig.startTime,
2168             "ERROR: Presale not started"
2169         );
2170         require(
2171             block.timestamp <=
2172                 _presaleConfig.startTime + _presaleConfig.duration,
2173             "ERROR: Presale is ended"
2174         );
2175         require(
2176             _presaleClaimed[msg.sender] + _amount <= _presaleConfig.maxCount,
2177             "ERROR: Can only mint 1 tokens"
2178         );
2179         require(totalNFT + _amount <= maxSupply, "ERROR: max supply exceeded");
2180         uint256 _price = 100000000000000000;
2181         require(_price <= msg.value, "ERROR: Ether value sent is not correct");
2182         require(!paused, "ERROR: contract is paused");
2183         uint256 _newItemId;
2184         for (uint256 ind = 0; ind < _amount; ind++) {
2185             _tokenIds.increment();
2186             _newItemId = _tokenIds.current();
2187             _safeMint(msg.sender, _newItemId);
2188             _presaleClaimed[msg.sender] = _presaleClaimed[msg.sender] + 1;
2189             _totalClaimed[msg.sender] = _totalClaimed[msg.sender] + 1;
2190             totalNFT = totalNFT + 1;
2191             presaleCount = presaleCount + 1;
2192         }
2193         emit PresaleMint(msg.sender, _amount, _price);
2194         if (totalNFT + _amount == maxSupply) {
2195             workflow = WorkflowStatus.SoldOut;
2196             emit WorkflowStatusChange(
2197                 WorkflowStatus.Sale,
2198                 WorkflowStatus.SoldOut
2199             );
2200         }
2201     }
2202 
2203     function saleMint(uint256 _amount) external payable nonReentrant {
2204         uint256 _price;
2205         SaleConfig memory _saleConfig = saleConfig;
2206         if (block.timestamp <= _saleConfig.startTime + 6 hours) {
2207             _price = 300000000000000000; //0.3 ETH
2208         } else if (
2209             (block.timestamp > _saleConfig.startTime + 6 hours) &&
2210             (block.timestamp <= _saleConfig.startTime + 12 hours)
2211         ) {
2212             _price = 250000000000000000; //0.25 ETH
2213         } else {
2214             _price = 200000000000000000; //0.2 ETH
2215         }
2216         require(_amount > 0, "ERROR: zero amount");
2217         require(_saleConfig.startTime > 0, "ERROR: sale is not active");
2218         require(
2219             block.timestamp >= _saleConfig.startTime,
2220             "ERROR: sale not started"
2221         );
2222         require(
2223             _amount <= _saleConfig.maxCount,
2224             "ERROR:  Can only mint 10 tokens at a time"
2225         );
2226         require(totalNFT + _amount <= maxSupply, "ERROR: max supply exceeded");
2227         require(
2228             _price * _amount <= msg.value,
2229             "ERROR: Ether value sent is not correct"
2230         );
2231         require(!paused, "ERROR: contract is paused");
2232         uint256 _newItemId;
2233         for (uint256 ind = 0; ind < _amount; ind++) {
2234             _tokenIds.increment();
2235             _newItemId = _tokenIds.current();
2236             _safeMint(msg.sender, _newItemId);
2237             _saleClaimed[msg.sender] = _saleClaimed[msg.sender] + _amount;
2238             _totalClaimed[msg.sender] = _totalClaimed[msg.sender] + _amount;
2239             totalNFT = totalNFT + 1;
2240         }
2241         emit SaleMint(msg.sender, _amount, _price);
2242         if (totalNFT + _amount == maxSupply) {
2243             workflow = WorkflowStatus.SoldOut;
2244             emit WorkflowStatusChange(
2245                 WorkflowStatus.Sale,
2246                 WorkflowStatus.SoldOut
2247             );
2248         }
2249     }
2250 
2251     function getWorkflowStatus() public view returns (uint256) {
2252         uint256 _status;
2253         if (workflow == WorkflowStatus.CheckOnPresale) {
2254             _status = 1;
2255         }
2256         if (workflow == WorkflowStatus.Presale) {
2257             _status = 2;
2258         }
2259         if (workflow == WorkflowStatus.Sale) {
2260             _status = 3;
2261         }
2262         if (workflow == WorkflowStatus.SoldOut) {
2263             _status = 4;
2264         }
2265         return _status;
2266     }
2267 
2268     function tokenURI(uint256 tokenId)
2269         public
2270         view
2271         virtual
2272         override
2273         returns (string memory)
2274     {
2275         require(
2276             _exists(tokenId),
2277             "ERC721Metadata: URI query for nonexistent token"
2278         );
2279         if (revealed == false) {
2280             return notRevealedUri;
2281         }
2282 
2283         string memory currentBaseURI = _baseURI();
2284         return
2285             bytes(currentBaseURI).length > 0
2286                 ? string(
2287                     abi.encodePacked(
2288                         currentBaseURI,
2289                         tokenId.toString(),
2290                         baseExtension
2291                     )
2292                 )
2293                 : "";
2294     }
2295 
2296     function setBaseExtension(string memory _newBaseExtension)
2297         public
2298         onlyOwner
2299     {
2300         baseExtension = _newBaseExtension;
2301     }
2302 
2303     function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
2304         notRevealedUri = _notRevealedURI;
2305     }
2306 }