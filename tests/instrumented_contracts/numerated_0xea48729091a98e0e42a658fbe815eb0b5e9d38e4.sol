1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-13
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev These functions deal with verification of Merkle Trees proofs.
13  *
14  * The proofs can be generated using the JavaScript library
15  * https://github.com/miguelmota/merkletreejs[merkletreejs].
16  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
17  *
18  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
19  */
20 library MerkleProof {
21     /**
22      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
23      * defined by `root`. For this, a `proof` must be provided, containing
24      * sibling hashes on the branch from the leaf to the root of the tree. Each
25      * pair of leaves and each pair of pre-images are assumed to be sorted.
26      */
27     function verify(
28         bytes32[] memory proof,
29         bytes32 root,
30         bytes32 leaf
31     ) internal pure returns (bool) {
32         bytes32 computedHash = leaf;
33 
34         for (uint256 i = 0; i < proof.length; i++) {
35             bytes32 proofElement = proof[i];
36 
37             if (computedHash <= proofElement) {
38                 // Hash(current computed hash + current element of the proof)
39                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
40             } else {
41                 // Hash(current element of the proof + current computed hash)
42                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
43             }
44         }
45 
46         // Check if the computed hash (root) is equal to the provided root
47         return computedHash == root;
48     }
49 }
50 
51 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
52 
53 
54 
55 pragma solidity ^0.8.0;
56 
57 /**
58  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
59  *
60  * These functions can be used to verify that a message was signed by the holder
61  * of the private keys of a given address.
62  */
63 library ECDSA {
64     enum RecoverError {
65         NoError,
66         InvalidSignature,
67         InvalidSignatureLength,
68         InvalidSignatureS,
69         InvalidSignatureV
70     }
71 
72     function _throwError(RecoverError error) private pure {
73         if (error == RecoverError.NoError) {
74             return; // no error: do nothing
75         } else if (error == RecoverError.InvalidSignature) {
76             revert("ECDSA: invalid signature");
77         } else if (error == RecoverError.InvalidSignatureLength) {
78             revert("ECDSA: invalid signature length");
79         } else if (error == RecoverError.InvalidSignatureS) {
80             revert("ECDSA: invalid signature 's' value");
81         } else if (error == RecoverError.InvalidSignatureV) {
82             revert("ECDSA: invalid signature 'v' value");
83         }
84     }
85 
86     /**
87      * @dev Returns the address that signed a hashed message (`hash`) with
88      * `signature` or error string. This address can then be used for verification purposes.
89      *
90      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
91      * this function rejects them by requiring the `s` value to be in the lower
92      * half order, and the `v` value to be either 27 or 28.
93      *
94      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
95      * verification to be secure: it is possible to craft signatures that
96      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
97      * this is by receiving a hash of the original message (which may otherwise
98      * be too long), and then calling {toEthSignedMessageHash} on it.
99      *
100      * Documentation for signature generation:
101      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
102      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
103      *
104      * _Available since v4.3._
105      */
106     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
107         // Check the signature length
108         // - case 65: r,s,v signature (standard)
109         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
110         if (signature.length == 65) {
111             bytes32 r;
112             bytes32 s;
113             uint8 v;
114             // ecrecover takes the signature parameters, and the only way to get them
115             // currently is to use assembly.
116             assembly {
117                 r := mload(add(signature, 0x20))
118                 s := mload(add(signature, 0x40))
119                 v := byte(0, mload(add(signature, 0x60)))
120             }
121             return tryRecover(hash, v, r, s);
122         } else if (signature.length == 64) {
123             bytes32 r;
124             bytes32 vs;
125             // ecrecover takes the signature parameters, and the only way to get them
126             // currently is to use assembly.
127             assembly {
128                 r := mload(add(signature, 0x20))
129                 vs := mload(add(signature, 0x40))
130             }
131             return tryRecover(hash, r, vs);
132         } else {
133             return (address(0), RecoverError.InvalidSignatureLength);
134         }
135     }
136 
137     /**
138      * @dev Returns the address that signed a hashed message (`hash`) with
139      * `signature`. This address can then be used for verification purposes.
140      *
141      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
142      * this function rejects them by requiring the `s` value to be in the lower
143      * half order, and the `v` value to be either 27 or 28.
144      *
145      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
146      * verification to be secure: it is possible to craft signatures that
147      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
148      * this is by receiving a hash of the original message (which may otherwise
149      * be too long), and then calling {toEthSignedMessageHash} on it.
150      */
151     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
152         (address recovered, RecoverError error) = tryRecover(hash, signature);
153         _throwError(error);
154         return recovered;
155     }
156 
157     /**
158      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
159      *
160      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
161      *
162      * _Available since v4.3._
163      */
164     function tryRecover(
165         bytes32 hash,
166         bytes32 r,
167         bytes32 vs
168     ) internal pure returns (address, RecoverError) {
169         bytes32 s;
170         uint8 v;
171         assembly {
172             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
173             v := add(shr(255, vs), 27)
174         }
175         return tryRecover(hash, v, r, s);
176     }
177 
178     /**
179      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
180      *
181      * _Available since v4.2._
182      */
183     function recover(
184         bytes32 hash,
185         bytes32 r,
186         bytes32 vs
187     ) internal pure returns (address) {
188         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
189         _throwError(error);
190         return recovered;
191     }
192 
193     /**
194      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
195      * `r` and `s` signature fields separately.
196      *
197      * _Available since v4.3._
198      */
199     function tryRecover(
200         bytes32 hash,
201         uint8 v,
202         bytes32 r,
203         bytes32 s
204     ) internal pure returns (address, RecoverError) {
205         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
206         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
207         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
208         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
209         //
210         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
211         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
212         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
213         // these malleable signatures as well.
214         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
215             return (address(0), RecoverError.InvalidSignatureS);
216         }
217         if (v != 27 && v != 28) {
218             return (address(0), RecoverError.InvalidSignatureV);
219         }
220 
221         // If the signature is valid (and not malleable), return the signer address
222         address signer = ecrecover(hash, v, r, s);
223         if (signer == address(0)) {
224             return (address(0), RecoverError.InvalidSignature);
225         }
226 
227         return (signer, RecoverError.NoError);
228     }
229 
230     /**
231      * @dev Overload of {ECDSA-recover} that receives the `v`,
232      * `r` and `s` signature fields separately.
233      */
234     function recover(
235         bytes32 hash,
236         uint8 v,
237         bytes32 r,
238         bytes32 s
239     ) internal pure returns (address) {
240         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
241         _throwError(error);
242         return recovered;
243     }
244 
245     /**
246      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
247      * produces hash corresponding to the one signed with the
248      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
249      * JSON-RPC method as part of EIP-191.
250      *
251      * See {recover}.
252      */
253     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
254         // 32 is the length in bytes of hash,
255         // enforced by the type signature above
256         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
257     }
258 
259     /**
260      * @dev Returns an Ethereum Signed Typed Data, created from a
261      * `domainSeparator` and a `structHash`. This produces hash corresponding
262      * to the one signed with the
263      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
264      * JSON-RPC method as part of EIP-712.
265      *
266      * See {recover}.
267      */
268     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
269         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/Counters.sol
274 
275 
276 
277 pragma solidity ^0.8.0;
278 
279 /**
280  * @title Counters
281  * @author Matt Condon (@shrugs)
282  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
283  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
284  *
285  * Include with `using Counters for Counters.Counter;`
286  */
287 library Counters {
288     struct Counter {
289         // This variable should never be directly accessed by users of the library: interactions must be restricted to
290         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
291         // this feature: see https://github.com/ethereum/solidity/issues/4637
292         uint256 _value; // default: 0
293     }
294 
295     function current(Counter storage counter) internal view returns (uint256) {
296         return counter._value;
297     }
298 
299     function increment(Counter storage counter) internal {
300         unchecked {
301             counter._value += 1;
302         }
303     }
304 
305     function decrement(Counter storage counter) internal {
306         uint256 value = counter._value;
307         require(value > 0, "Counter: decrement overflow");
308         unchecked {
309             counter._value = value - 1;
310         }
311     }
312 
313     function reset(Counter storage counter) internal {
314         counter._value = 0;
315     }
316 }
317 
318 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 // CAUTION
325 // This version of SafeMath should only be used with Solidity 0.8 or later,
326 // because it relies on the compiler's built in overflow checks.
327 
328 /**
329  * @dev Wrappers over Solidity's arithmetic operations.
330  *
331  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
332  * now has built in overflow checking.
333  */
334 library SafeMath {
335     /**
336      * @dev Returns the addition of two unsigned integers, with an overflow flag.
337      *
338      * _Available since v3.4._
339      */
340     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
341         unchecked {
342             uint256 c = a + b;
343             if (c < a) return (false, 0);
344             return (true, c);
345         }
346     }
347 
348     /**
349      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
350      *
351      * _Available since v3.4._
352      */
353     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
354         unchecked {
355             if (b > a) return (false, 0);
356             return (true, a - b);
357         }
358     }
359 
360     /**
361      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
362      *
363      * _Available since v3.4._
364      */
365     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
366         unchecked {
367             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
368             // benefit is lost if 'b' is also tested.
369             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
370             if (a == 0) return (true, 0);
371             uint256 c = a * b;
372             if (c / a != b) return (false, 0);
373             return (true, c);
374         }
375     }
376 
377     /**
378      * @dev Returns the division of two unsigned integers, with a division by zero flag.
379      *
380      * _Available since v3.4._
381      */
382     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
383         unchecked {
384             if (b == 0) return (false, 0);
385             return (true, a / b);
386         }
387     }
388 
389     /**
390      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
395         unchecked {
396             if (b == 0) return (false, 0);
397             return (true, a % b);
398         }
399     }
400 
401     /**
402      * @dev Returns the addition of two unsigned integers, reverting on
403      * overflow.
404      *
405      * Counterpart to Solidity's `+` operator.
406      *
407      * Requirements:
408      *
409      * - Addition cannot overflow.
410      */
411     function add(uint256 a, uint256 b) internal pure returns (uint256) {
412         return a + b;
413     }
414 
415     /**
416      * @dev Returns the subtraction of two unsigned integers, reverting on
417      * overflow (when the result is negative).
418      *
419      * Counterpart to Solidity's `-` operator.
420      *
421      * Requirements:
422      *
423      * - Subtraction cannot overflow.
424      */
425     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
426         return a - b;
427     }
428 
429     /**
430      * @dev Returns the multiplication of two unsigned integers, reverting on
431      * overflow.
432      *
433      * Counterpart to Solidity's `*` operator.
434      *
435      * Requirements:
436      *
437      * - Multiplication cannot overflow.
438      */
439     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a * b;
441     }
442 
443     /**
444      * @dev Returns the integer division of two unsigned integers, reverting on
445      * division by zero. The result is rounded towards zero.
446      *
447      * Counterpart to Solidity's `/` operator.
448      *
449      * Requirements:
450      *
451      * - The divisor cannot be zero.
452      */
453     function div(uint256 a, uint256 b) internal pure returns (uint256) {
454         return a / b;
455     }
456 
457     /**
458      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
459      * reverting when dividing by zero.
460      *
461      * Counterpart to Solidity's `%` operator. This function uses a `revert`
462      * opcode (which leaves remaining gas untouched) while Solidity uses an
463      * invalid opcode to revert (consuming all remaining gas).
464      *
465      * Requirements:
466      *
467      * - The divisor cannot be zero.
468      */
469     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
470         return a % b;
471     }
472 
473     /**
474      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
475      * overflow (when the result is negative).
476      *
477      * CAUTION: This function is deprecated because it requires allocating memory for the error
478      * message unnecessarily. For custom revert reasons use {trySub}.
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(
487         uint256 a,
488         uint256 b,
489         string memory errorMessage
490     ) internal pure returns (uint256) {
491         unchecked {
492             require(b <= a, errorMessage);
493             return a - b;
494         }
495     }
496 
497     /**
498      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
499      * division by zero. The result is rounded towards zero.
500      *
501      * Counterpart to Solidity's `/` operator. Note: this function uses a
502      * `revert` opcode (which leaves remaining gas untouched) while Solidity
503      * uses an invalid opcode to revert (consuming all remaining gas).
504      *
505      * Requirements:
506      *
507      * - The divisor cannot be zero.
508      */
509     function div(
510         uint256 a,
511         uint256 b,
512         string memory errorMessage
513     ) internal pure returns (uint256) {
514         unchecked {
515             require(b > 0, errorMessage);
516             return a / b;
517         }
518     }
519 
520     /**
521      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
522      * reverting with custom message when dividing by zero.
523      *
524      * CAUTION: This function is deprecated because it requires allocating memory for the error
525      * message unnecessarily. For custom revert reasons use {tryMod}.
526      *
527      * Counterpart to Solidity's `%` operator. This function uses a `revert`
528      * opcode (which leaves remaining gas untouched) while Solidity uses an
529      * invalid opcode to revert (consuming all remaining gas).
530      *
531      * Requirements:
532      *
533      * - The divisor cannot be zero.
534      */
535     function mod(
536         uint256 a,
537         uint256 b,
538         string memory errorMessage
539     ) internal pure returns (uint256) {
540         unchecked {
541             require(b > 0, errorMessage);
542             return a % b;
543         }
544     }
545 }
546 
547 // File: @openzeppelin/contracts/utils/Strings.sol
548 
549 
550 
551 pragma solidity ^0.8.0;
552 
553 /**
554  * @dev String operations.
555  */
556 library Strings {
557     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
558 
559     /**
560      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
561      */
562     function toString(uint256 value) internal pure returns (string memory) {
563         // Inspired by OraclizeAPI's implementation - MIT licence
564         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
565 
566         if (value == 0) {
567             return "0";
568         }
569         uint256 temp = value;
570         uint256 digits;
571         while (temp != 0) {
572             digits++;
573             temp /= 10;
574         }
575         bytes memory buffer = new bytes(digits);
576         while (value != 0) {
577             digits -= 1;
578             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
579             value /= 10;
580         }
581         return string(buffer);
582     }
583 
584     /**
585      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
586      */
587     function toHexString(uint256 value) internal pure returns (string memory) {
588         if (value == 0) {
589             return "0x00";
590         }
591         uint256 temp = value;
592         uint256 length = 0;
593         while (temp != 0) {
594             length++;
595             temp >>= 8;
596         }
597         return toHexString(value, length);
598     }
599 
600     /**
601      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
602      */
603     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
604         bytes memory buffer = new bytes(2 * length + 2);
605         buffer[0] = "0";
606         buffer[1] = "x";
607         for (uint256 i = 2 * length + 1; i > 1; --i) {
608             buffer[i] = _HEX_SYMBOLS[value & 0xf];
609             value >>= 4;
610         }
611         require(value == 0, "Strings: hex length insufficient");
612         return string(buffer);
613     }
614 }
615 
616 // File: @openzeppelin/contracts/utils/Context.sol
617 
618 
619 
620 pragma solidity ^0.8.0;
621 
622 /**
623  * @dev Provides information about the current execution context, including the
624  * sender of the transaction and its data. While these are generally available
625  * via msg.sender and msg.data, they should not be accessed in such a direct
626  * manner, since when dealing with meta-transactions the account sending and
627  * paying for execution may not be the actual sender (as far as an application
628  * is concerned).
629  *
630  * This contract is only required for intermediate, library-like contracts.
631  */
632 abstract contract Context {
633     function _msgSender() internal view virtual returns (address) {
634         return msg.sender;
635     }
636 
637     function _msgData() internal view virtual returns (bytes calldata) {
638         return msg.data;
639     }
640 }
641 
642 // File: @openzeppelin/contracts/access/Ownable.sol
643 
644 
645 
646 pragma solidity ^0.8.0;
647 
648 
649 /**
650  * @dev Contract module which provides a basic access control mechanism, where
651  * there is an account (an owner) that can be granted exclusive access to
652  * specific functions.
653  *
654  * By default, the owner account will be the one that deploys the contract. This
655  * can later be changed with {transferOwnership}.
656  *
657  * This module is used through inheritance. It will make available the modifier
658  * `onlyOwner`, which can be applied to your functions to restrict their use to
659  * the owner.
660  */
661 abstract contract Ownable is Context {
662     address private _owner;
663 
664     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
665 
666     /**
667      * @dev Initializes the contract setting the deployer as the initial owner.
668      */
669     constructor() {
670         _setOwner(_msgSender());
671     }
672 
673     /**
674      * @dev Returns the address of the current owner.
675      */
676     function owner() public view virtual returns (address) {
677         return _owner;
678     }
679 
680     /**
681      * @dev Throws if called by any account other than the owner.
682      */
683     modifier onlyOwner() {
684         require(owner() == _msgSender(), "Ownable: caller is not the owner");
685         _;
686     }
687 
688     /**
689      * @dev Leaves the contract without owner. It will not be possible to call
690      * `onlyOwner` functions anymore. Can only be called by the current owner.
691      *
692      * NOTE: Renouncing ownership will leave the contract without an owner,
693      * thereby removing any functionality that is only available to the owner.
694      */
695     //function renounceOwnership() public virtual onlyOwner {
696     //    _setOwner(address(0));
697     //}
698 
699     /**
700      * @dev Transfers ownership of the contract to a new account (`newOwner`).
701      * Can only be called by the current owner.
702      */
703     function transferOwnership(address newOwner) public virtual onlyOwner {
704         require(newOwner != address(0), "Ownable: new owner is the zero address");
705         _setOwner(newOwner);
706     }
707 
708     function _setOwner(address newOwner) private {
709         address oldOwner = _owner;
710         _owner = newOwner;
711         emit OwnershipTransferred(oldOwner, newOwner);
712     }
713 }
714 
715 // File: @openzeppelin/contracts/utils/Address.sol
716 
717 
718 
719 pragma solidity ^0.8.0;
720 
721 /**
722  * @dev Collection of functions related to the address type
723  */
724 library Address {
725     /**
726      * @dev Returns true if `account` is a contract.
727      *
728      * [IMPORTANT]
729      * ====
730      * It is unsafe to assume that an address for which this function returns
731      * false is an externally-owned account (EOA) and not a contract.
732      *
733      * Among others, `isContract` will return false for the following
734      * types of addresses:
735      *
736      *  - an externally-owned account
737      *  - a contract in construction
738      *  - an address where a contract will be created
739      *  - an address where a contract lived, but was destroyed
740      * ====
741      */
742     function isContract(address account) internal view returns (bool) {
743         // This method relies on extcodesize, which returns 0 for contracts in
744         // construction, since the code is only stored at the end of the
745         // constructor execution.
746 
747         uint256 size;
748         assembly {
749             size := extcodesize(account)
750         }
751         return size > 0;
752     }
753 
754     /**
755      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
756      * `recipient`, forwarding all available gas and reverting on errors.
757      *
758      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
759      * of certain opcodes, possibly making contracts go over the 2300 gas limit
760      * imposed by `transfer`, making them unable to receive funds via
761      * `transfer`. {sendValue} removes this limitation.
762      *
763      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
764      *
765      * IMPORTANT: because control is transferred to `recipient`, care must be
766      * taken to not create reentrancy vulnerabilities. Consider using
767      * {ReentrancyGuard} or the
768      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
769      */
770     function sendValue(address payable recipient, uint256 amount) internal {
771         require(address(this).balance >= amount, "Address: insufficient balance");
772 
773         (bool success, ) = recipient.call{value: amount}("");
774         require(success, "Address: unable to send value, recipient may have reverted");
775     }
776 
777     /**
778      * @dev Performs a Solidity function call using a low level `call`. A
779      * plain `call` is an unsafe replacement for a function call: use this
780      * function instead.
781      *
782      * If `target` reverts with a revert reason, it is bubbled up by this
783      * function (like regular Solidity function calls).
784      *
785      * Returns the raw returned data. To convert to the expected return value,
786      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
787      *
788      * Requirements:
789      *
790      * - `target` must be a contract.
791      * - calling `target` with `data` must not revert.
792      *
793      * _Available since v3.1._
794      */
795     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
796         return functionCall(target, data, "Address: low-level call failed");
797     }
798 
799     /**
800      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
801      * `errorMessage` as a fallback revert reason when `target` reverts.
802      *
803      * _Available since v3.1._
804      */
805     function functionCall(
806         address target,
807         bytes memory data,
808         string memory errorMessage
809     ) internal returns (bytes memory) {
810         return functionCallWithValue(target, data, 0, errorMessage);
811     }
812 
813     /**
814      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
815      * but also transferring `value` wei to `target`.
816      *
817      * Requirements:
818      *
819      * - the calling contract must have an ETH balance of at least `value`.
820      * - the called Solidity function must be `payable`.
821      *
822      * _Available since v3.1._
823      */
824     function functionCallWithValue(
825         address target,
826         bytes memory data,
827         uint256 value
828     ) internal returns (bytes memory) {
829         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
830     }
831 
832     /**
833      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
834      * with `errorMessage` as a fallback revert reason when `target` reverts.
835      *
836      * _Available since v3.1._
837      */
838     function functionCallWithValue(
839         address target,
840         bytes memory data,
841         uint256 value,
842         string memory errorMessage
843     ) internal returns (bytes memory) {
844         require(address(this).balance >= value, "Address: insufficient balance for call");
845         require(isContract(target), "Address: call to non-contract");
846 
847         (bool success, bytes memory returndata) = target.call{value: value}(data);
848         return verifyCallResult(success, returndata, errorMessage);
849     }
850 
851     /**
852      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
853      * but performing a static call.
854      *
855      * _Available since v3.3._
856      */
857     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
858         return functionStaticCall(target, data, "Address: low-level static call failed");
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
863      * but performing a static call.
864      *
865      * _Available since v3.3._
866      */
867     function functionStaticCall(
868         address target,
869         bytes memory data,
870         string memory errorMessage
871     ) internal view returns (bytes memory) {
872         require(isContract(target), "Address: static call to non-contract");
873 
874         (bool success, bytes memory returndata) = target.staticcall(data);
875         return verifyCallResult(success, returndata, errorMessage);
876     }
877 
878     /**
879      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
880      * but performing a delegate call.
881      *
882      * _Available since v3.4._
883      */
884     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
885         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
890      * but performing a delegate call.
891      *
892      * _Available since v3.4._
893      */
894     function functionDelegateCall(
895         address target,
896         bytes memory data,
897         string memory errorMessage
898     ) internal returns (bytes memory) {
899         require(isContract(target), "Address: delegate call to non-contract");
900 
901         (bool success, bytes memory returndata) = target.delegatecall(data);
902         return verifyCallResult(success, returndata, errorMessage);
903     }
904 
905     /**
906      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
907      * revert reason using the provided one.
908      *
909      * _Available since v4.3._
910      */
911     function verifyCallResult(
912         bool success,
913         bytes memory returndata,
914         string memory errorMessage
915     ) internal pure returns (bytes memory) {
916         if (success) {
917             return returndata;
918         } else {
919             // Look for revert reason and bubble it up if present
920             if (returndata.length > 0) {
921                 // The easiest way to bubble the revert reason is using memory via assembly
922 
923                 assembly {
924                     let returndata_size := mload(returndata)
925                     revert(add(32, returndata), returndata_size)
926                 }
927             } else {
928                 revert(errorMessage);
929             }
930         }
931     }
932 }
933 
934 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
935 
936 
937 
938 pragma solidity ^0.8.0;
939 
940 /**
941  * @title ERC721 token receiver interface
942  * @dev Interface for any contract that wants to support safeTransfers
943  * from ERC721 asset contracts.
944  */
945 interface IERC721Receiver {
946     /**
947      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
948      * by `operator` from `from`, this function is called.
949      *
950      * It must return its Solidity selector to confirm the token transfer.
951      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
952      *
953      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
954      */
955     function onERC721Received(
956         address operator,
957         address from,
958         uint256 tokenId,
959         bytes calldata data
960     ) external returns (bytes4);
961 }
962 
963 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
964 
965 
966 
967 pragma solidity ^0.8.0;
968 
969 /**
970  * @dev Interface of the ERC165 standard, as defined in the
971  * https://eips.ethereum.org/EIPS/eip-165[EIP].
972  *
973  * Implementers can declare support of contract interfaces, which can then be
974  * queried by others ({ERC165Checker}).
975  *
976  * For an implementation, see {ERC165}.
977  */
978 interface IERC165 {
979     /**
980      * @dev Returns true if this contract implements the interface defined by
981      * `interfaceId`. See the corresponding
982      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
983      * to learn more about how these ids are created.
984      *
985      * This function call must use less than 30 000 gas.
986      */
987     function supportsInterface(bytes4 interfaceId) external view returns (bool);
988 }
989 
990 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
991 
992 
993 
994 pragma solidity ^0.8.0;
995 
996 
997 /**
998  * @dev Implementation of the {IERC165} interface.
999  *
1000  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1001  * for the additional interface id that will be supported. For example:
1002  *
1003  * ```solidity
1004  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1005  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1006  * }
1007  * ```
1008  *
1009  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1010  */
1011 abstract contract ERC165 is IERC165 {
1012     /**
1013      * @dev See {IERC165-supportsInterface}.
1014      */
1015     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1016         return interfaceId == type(IERC165).interfaceId;
1017     }
1018 }
1019 
1020 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1021 
1022 
1023 
1024 pragma solidity ^0.8.0;
1025 
1026 
1027 /**
1028  * @dev Required interface of an ERC721 compliant contract.
1029  */
1030 interface IERC721 is IERC165 {
1031     /**
1032      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1033      */
1034     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1035 
1036     /**
1037      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1038      */
1039     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1040 
1041     /**
1042      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1043      */
1044     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1045 
1046     /**
1047      * @dev Returns the number of tokens in ``owner``'s account.
1048      */
1049     function balanceOf(address owner) external view returns (uint256 balance);
1050 
1051     /**
1052      * @dev Returns the owner of the `tokenId` token.
1053      *
1054      * Requirements:
1055      *
1056      * - `tokenId` must exist.
1057      */
1058     function ownerOf(uint256 tokenId) external view returns (address owner);
1059 
1060     /**
1061      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1062      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1063      *
1064      * Requirements:
1065      *
1066      * - `from` cannot be the zero address.
1067      * - `to` cannot be the zero address.
1068      * - `tokenId` token must exist and be owned by `from`.
1069      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1070      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1071      *
1072      * Emits a {Transfer} event.
1073      */
1074     function safeTransferFrom(
1075         address from,
1076         address to,
1077         uint256 tokenId
1078     ) external;
1079 
1080     /**
1081      * @dev Transfers `tokenId` token from `from` to `to`.
1082      *
1083      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1084      *
1085      * Requirements:
1086      *
1087      * - `from` cannot be the zero address.
1088      * - `to` cannot be the zero address.
1089      * - `tokenId` token must be owned by `from`.
1090      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1091      *
1092      * Emits a {Transfer} event.
1093      */
1094     function transferFrom(
1095         address from,
1096         address to,
1097         uint256 tokenId
1098     ) external;
1099 
1100     /**
1101      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1102      * The approval is cleared when the token is transferred.
1103      *
1104      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1105      *
1106      * Requirements:
1107      *
1108      * - The caller must own the token or be an approved operator.
1109      * - `tokenId` must exist.
1110      *
1111      * Emits an {Approval} event.
1112      */
1113     function approve(address to, uint256 tokenId) external;
1114 
1115     /**
1116      * @dev Returns the account approved for `tokenId` token.
1117      *
1118      * Requirements:
1119      *
1120      * - `tokenId` must exist.
1121      */
1122     function getApproved(uint256 tokenId) external view returns (address operator);
1123 
1124     /**
1125      * @dev Approve or remove `operator` as an operator for the caller.
1126      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1127      *
1128      * Requirements:
1129      *
1130      * - The `operator` cannot be the caller.
1131      *
1132      * Emits an {ApprovalForAll} event.
1133      */
1134     function setApprovalForAll(address operator, bool _approved) external;
1135 
1136     /**
1137      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1138      *
1139      * See {setApprovalForAll}
1140      */
1141     function isApprovedForAll(address owner, address operator) external view returns (bool);
1142 
1143     /**
1144      * @dev Safely transfers `tokenId` token from `from` to `to`.
1145      *
1146      * Requirements:
1147      *
1148      * - `from` cannot be the zero address.
1149      * - `to` cannot be the zero address.
1150      * - `tokenId` token must exist and be owned by `from`.
1151      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1152      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1153      *
1154      * Emits a {Transfer} event.
1155      */
1156     function safeTransferFrom(
1157         address from,
1158         address to,
1159         uint256 tokenId,
1160         bytes calldata data
1161     ) external;
1162 }
1163 
1164 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1165 
1166 
1167 
1168 pragma solidity ^0.8.0;
1169 
1170 
1171 /**
1172  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1173  * @dev See https://eips.ethereum.org/EIPS/eip-721
1174  */
1175 interface IERC721Enumerable is IERC721 {
1176     /**
1177      * @dev Returns the total amount of tokens stored by the contract.
1178      */
1179     function totalSupply() external view returns (uint256);
1180 
1181     /**
1182      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1183      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1184      */
1185     //function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1186 
1187     /**
1188      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1189      * Use along with {totalSupply} to enumerate all tokens.
1190      */
1191     function tokenByIndex(uint256 index) external view returns (uint256);
1192 }
1193 
1194 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1195 
1196 
1197 
1198 pragma solidity ^0.8.0;
1199 
1200 
1201 /**
1202  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1203  * @dev See https://eips.ethereum.org/EIPS/eip-721
1204  */
1205 interface IERC721Metadata is IERC721 {
1206     /**
1207      * @dev Returns the token collection name.
1208      */
1209     function name() external view returns (string memory);
1210 
1211     /**
1212      * @dev Returns the token collection symbol.
1213      */
1214     function symbol() external view returns (string memory);
1215 
1216     /**
1217      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1218      */
1219     function tokenURI(uint256 tokenId) external view returns (string memory);
1220 }
1221 
1222 // File: ERC721.sol
1223 
1224 
1225 
1226 pragma solidity ^0.8.0;
1227 
1228 
1229 
1230 
1231 
1232 
1233 
1234 
1235 /**
1236  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1237  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1238  * {ERC721Enumerable}.
1239  */
1240 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1241     using Address for address;
1242     using Strings for uint256;
1243 
1244     // Token name
1245     string private _name;
1246 
1247     // Token symbol
1248     string private _symbol;
1249 
1250     // Mapping from token ID to owner address
1251     mapping(uint256 => address) private _owners;
1252 
1253     // Mapping owner address to token count
1254     mapping(address => uint256) private _balances;
1255 
1256     // Mapping from token ID to approved address
1257     mapping(uint256 => address) private _tokenApprovals;
1258 
1259     // Mapping from owner to operator approvals
1260     mapping(address => mapping(address => bool)) private _operatorApprovals;
1261 
1262     /**
1263      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1264      */
1265     constructor(string memory name_, string memory symbol_) {
1266         _name = name_;
1267         _symbol = symbol_;
1268     }
1269 
1270     /**
1271      * @dev See {IERC165-supportsInterface}.
1272      */
1273     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1274         return
1275         interfaceId == type(IERC721).interfaceId ||
1276         interfaceId == type(IERC721Metadata).interfaceId ||
1277         super.supportsInterface(interfaceId);
1278     }
1279 
1280     /**
1281      * @dev See {IERC721-balanceOf}.
1282      */
1283     function balanceOf(address owner) public view virtual override returns (uint256) {
1284         require(owner != address(0), "ERC721: balance query for the zero address");
1285         return _balances[owner];
1286     }
1287 
1288     /**
1289      * @dev See {IERC721-ownerOf}.
1290      */
1291     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1292         address owner = _owners[tokenId];
1293         require(owner != address(0), "ERC721: owner query for nonexistent token");
1294         return owner;
1295     }
1296 
1297     /**
1298      * @dev Edit for rawOwnerOf token
1299      */
1300     function rawOwnerOf(uint256 tokenId) public view returns (address) {
1301         return _owners[tokenId];
1302     }
1303 
1304     /**
1305      * @dev See {IERC721Metadata-name}.
1306      */
1307     function name() public view virtual override returns (string memory) {
1308         return _name;
1309     }
1310 
1311     /**
1312      * @dev See {IERC721Metadata-symbol}.
1313      */
1314     function symbol() public view virtual override returns (string memory) {
1315         return _symbol;
1316     }
1317 
1318     /**
1319      * @dev See {IERC721Metadata-tokenURI}.
1320      */
1321     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1322         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1323 
1324         string memory baseURI = _baseURI();
1325         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1326     }
1327 
1328     /**
1329      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1330      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1331      * by default, can be overriden in child contracts.
1332      */
1333     function _baseURI() internal view virtual returns (string memory) {
1334         return "";
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-approve}.
1339      */
1340     function approve(address to, uint256 tokenId) public virtual override {
1341         address owner = ERC721.ownerOf(tokenId);
1342         require(to != owner, "ERC721: approval to current owner");
1343 
1344         require(
1345             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1346             "ERC721: approve caller is not owner nor approved for all"
1347         );
1348 
1349         _approve(to, tokenId);
1350     }
1351 
1352     /**
1353      * @dev See {IERC721-getApproved}.
1354      */
1355     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1356         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1357 
1358         return _tokenApprovals[tokenId];
1359     }
1360 
1361     /**
1362      * @dev See {IERC721-setApprovalForAll}.
1363      */
1364     function setApprovalForAll(address operator, bool approved) public virtual override {
1365         require(operator != _msgSender(), "ERC721: approve to caller");
1366 
1367         _operatorApprovals[_msgSender()][operator] = approved;
1368         emit ApprovalForAll(_msgSender(), operator, approved);
1369     }
1370 
1371     /**
1372      * @dev See {IERC721-isApprovedForAll}.
1373      */
1374     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1375         return _operatorApprovals[owner][operator];
1376     }
1377 
1378     /**
1379      * @dev See {IERC721-transferFrom}.
1380      */
1381     function transferFrom(
1382         address from,
1383         address to,
1384         uint256 tokenId
1385     ) public virtual override {
1386         //solhint-disable-next-line max-line-length
1387         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1388 
1389         _transfer(from, to, tokenId);
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-safeTransferFrom}.
1394      */
1395     function safeTransferFrom(
1396         address from,
1397         address to,
1398         uint256 tokenId
1399     ) public virtual override {
1400         safeTransferFrom(from, to, tokenId, "");
1401     }
1402 
1403     /**
1404      * @dev See {IERC721-safeTransferFrom}.
1405      */
1406     function safeTransferFrom(
1407         address from,
1408         address to,
1409         uint256 tokenId,
1410         bytes memory _data
1411     ) public virtual override {
1412         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1413         _safeTransfer(from, to, tokenId, _data);
1414     }
1415 
1416     /**
1417      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1418      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1419      *
1420      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1421      *
1422      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1423      * implement alternative mechanisms to perform token transfer, such as signature-based.
1424      *
1425      * Requirements:
1426      *
1427      * - `from` cannot be the zero address.
1428      * - `to` cannot be the zero address.
1429      * - `tokenId` token must exist and be owned by `from`.
1430      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1431      *
1432      * Emits a {Transfer} event.
1433      */
1434     function _safeTransfer(
1435         address from,
1436         address to,
1437         uint256 tokenId,
1438         bytes memory _data
1439     ) internal virtual {
1440         _transfer(from, to, tokenId);
1441         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1442     }
1443 
1444     /**
1445      * @dev Returns whether `tokenId` exists.
1446      *
1447      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1448      *
1449      * Tokens start existing when they are minted (`_mint`),
1450      * and stop existing when they are burned (`_burn`).
1451      */
1452     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1453         return _owners[tokenId] != address(0);
1454     }
1455 
1456     /**
1457      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1458      *
1459      * Requirements:
1460      *
1461      * - `tokenId` must exist.
1462      */
1463     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1464         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1465         address owner = ERC721.ownerOf(tokenId);
1466         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1467     }
1468 
1469     /**
1470      * @dev Safely mints `tokenId` and transfers it to `to`.
1471      *
1472      * Requirements:
1473      *
1474      * - `tokenId` must not exist.
1475      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1476      *
1477      * Emits a {Transfer} event.
1478      */
1479     function _safeMint(address to, uint256 tokenId) internal virtual {
1480         _safeMint(to, tokenId, "");
1481     }
1482 
1483     /**
1484      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1485      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1486      */
1487     function _safeMint(
1488         address to,
1489         uint256 tokenId,
1490         bytes memory _data
1491     ) internal virtual {
1492         _mint(to, tokenId);
1493         require(
1494             _checkOnERC721Received(address(0), to, tokenId, _data),
1495             "ERC721: transfer to non ERC721Receiver implementer"
1496         );
1497     }
1498 
1499     /**
1500      * @dev Mints `tokenId` and transfers it to `to`.
1501      *
1502      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must not exist.
1507      * - `to` cannot be the zero address.
1508      *
1509      * Emits a {Transfer} event.
1510      */
1511     function _mint(address to, uint256 tokenId) internal virtual {
1512         require(to != address(0), "ERC721: mint to the zero address");
1513         require(!_exists(tokenId), "ERC721: token already minted");
1514 
1515         _beforeTokenTransfer(address(0), to, tokenId);
1516 
1517         _balances[to] += 1;
1518         _owners[tokenId] = to;
1519 
1520         emit Transfer(address(0), to, tokenId);
1521     }
1522 
1523     /**
1524      * @dev Destroys `tokenId`.
1525      * The approval is cleared when the token is burned.
1526      *
1527      * Requirements:
1528      *
1529      * - `tokenId` must exist.
1530      *
1531      * Emits a {Transfer} event.
1532      */
1533     function _burn(uint256 tokenId) internal virtual {
1534         address owner = ERC721.ownerOf(tokenId);
1535         address to = address(0);
1536 
1537         _beforeTokenTransfer(owner, to, tokenId);
1538 
1539         // Clear approvals
1540         _approve(address(0), tokenId);
1541 
1542         _balances[owner] -= 1;
1543         delete _owners[tokenId];
1544 
1545         emit Transfer(owner, to, tokenId);
1546     }
1547 
1548     /**
1549      * @dev Transfers `tokenId` from `from` to `to`.
1550      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1551      *
1552      * Requirements:
1553      *
1554      * - `to` cannot be the zero address.
1555      * - `tokenId` token must be owned by `from`.
1556      *
1557      * Emits a {Transfer} event.
1558      */
1559     function _transfer(
1560         address from,
1561         address to,
1562         uint256 tokenId
1563     ) internal virtual {
1564         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1565         require(to != address(0), "ERC721: transfer to the zero address");
1566 
1567         _beforeTokenTransfer(from, to, tokenId);
1568 
1569         // Clear approvals from the previous owner
1570         _approve(address(0), tokenId);
1571 
1572         _balances[from] -= 1;
1573         _balances[to] += 1;
1574         _owners[tokenId] = to;
1575 
1576         emit Transfer(from, to, tokenId);
1577     }
1578 
1579     /**
1580      * @dev Approve `to` to operate on `tokenId`
1581      *
1582      * Emits a {Approval} event.
1583      */
1584     function _approve(address to, uint256 tokenId) internal virtual {
1585         _tokenApprovals[tokenId] = to;
1586         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1587     }
1588 
1589     /**
1590      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1591      * The call is not executed if the target address is not a contract.
1592      *
1593      * @param from address representing the previous owner of the given token ID
1594      * @param to target address that will receive the tokens
1595      * @param tokenId uint256 ID of the token to be transferred
1596      * @param _data bytes optional data to send along with the call
1597      * @return bool whether the call correctly returned the expected magic value
1598      */
1599     function _checkOnERC721Received(
1600         address from,
1601         address to,
1602         uint256 tokenId,
1603         bytes memory _data
1604     ) private returns (bool) {
1605         if (to.isContract()) {
1606             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1607                 return retval == IERC721Receiver(to).onERC721Received.selector;
1608             } catch (bytes memory reason) {
1609                 if (reason.length == 0) {
1610                     revert("ERC721: transfer to non ERC721Receiver implementer");
1611                 } else {
1612                     assembly {
1613                         revert(add(32, reason), mload(reason))
1614                     }
1615                 }
1616             }
1617         } else {
1618             return true;
1619         }
1620     }
1621 
1622     /**
1623      * @dev Hook that is called before any token transfer. This includes minting
1624      * and burning.
1625      *
1626      * Calling conditions:
1627      *
1628      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1629      * transferred to `to`.
1630      * - When `from` is zero, `tokenId` will be minted for `to`.
1631      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1632      * - `from` and `to` are never both zero.
1633      *
1634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1635      */
1636     function _beforeTokenTransfer(
1637         address from,
1638         address to,
1639         uint256 tokenId
1640     ) internal virtual {}
1641 }
1642 // File: ERC721Enumerable.sol
1643 
1644 
1645 
1646 pragma solidity ^0.8.0;
1647 
1648 
1649 /**
1650  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1651  * enumerability of all the token ids in the contract as well as all token ids owned by each
1652  * account.
1653  */
1654 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1655     // Mapping from owner to list of owned token IDs
1656     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1657 
1658     // Mapping from token ID to index of the owner tokens list
1659     mapping(uint256 => uint256) private _ownedTokensIndex;
1660 
1661     // Array with all token ids, used for enumeration
1662     uint256[] private _allTokens;
1663 
1664     // Mapping from token id to position in the allTokens array
1665     mapping(uint256 => uint256) private _allTokensIndex;
1666 
1667     /**
1668      * @dev See {IERC165-supportsInterface}.
1669      */
1670     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1671         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1672     }
1673 
1674     /**
1675      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1676      */
1677     //function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1678     //    require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1679     //    return _ownedTokens[owner][index];
1680     //}
1681 
1682     /**
1683      * @dev See {IERC721Enumerable-totalSupply}.
1684      */
1685     function totalSupply() public view virtual override returns (uint256) {
1686         return _allTokens.length;
1687     }
1688 
1689     /**
1690      * @dev See {IERC721Enumerable-tokenByIndex}.
1691      */
1692     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1693         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1694         return _allTokens[index];
1695     }
1696 
1697     /**
1698      * @dev Hook that is called before any token transfer. This includes minting
1699      * and burning.
1700      *
1701      * Calling conditions:
1702      *
1703      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1704      * transferred to `to`.
1705      * - When `from` is zero, `tokenId` will be minted for `to`.
1706      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1707      * - `from` cannot be the zero address.
1708      * - `to` cannot be the zero address.
1709      *
1710      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1711      */
1712     function _beforeTokenTransfer(
1713         address from,
1714         address to,
1715         uint256 tokenId
1716     ) internal virtual override {
1717         super._beforeTokenTransfer(from, to, tokenId);
1718 
1719         if (from == address(0)) {
1720             _addTokenToAllTokensEnumeration(tokenId);
1721         } else if (from != to) {
1722             _removeTokenFromOwnerEnumeration(from, tokenId);
1723         }
1724         if (to == address(0)) {
1725             _removeTokenFromAllTokensEnumeration(tokenId);
1726         } else if (to != from) {
1727             _addTokenToOwnerEnumeration(to, tokenId);
1728         }
1729     }
1730 
1731     /**
1732      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1733      * @param to address representing the new owner of the given token ID
1734      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1735      */
1736     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1737         uint256 length = ERC721.balanceOf(to);
1738         _ownedTokens[to][length] = tokenId;
1739         _ownedTokensIndex[tokenId] = length;
1740     }
1741 
1742     /**
1743      * @dev Private function to add a token to this extension's token tracking data structures.
1744      * @param tokenId uint256 ID of the token to be added to the tokens list
1745      */
1746     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1747         _allTokensIndex[tokenId] = _allTokens.length;
1748         _allTokens.push(tokenId);
1749     }
1750 
1751     /**
1752      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1753      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1754      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1755      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1756      * @param from address representing the previous owner of the given token ID
1757      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1758      */
1759     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1760         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1761         // then delete the last slot (swap and pop).
1762 
1763         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1764         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1765 
1766         // When the token to delete is the last token, the swap operation is unnecessary
1767         if (tokenIndex != lastTokenIndex) {
1768             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1769 
1770             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1771             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1772         }
1773 
1774         // This also deletes the contents at the last position of the array
1775         delete _ownedTokensIndex[tokenId];
1776         delete _ownedTokens[from][lastTokenIndex];
1777     }
1778 
1779     /**
1780      * @dev Private function to remove a token from this extension's token tracking data structures.
1781      * This has O(1) time complexity, but alters the order of the _allTokens array.
1782      * @param tokenId uint256 ID of the token to be removed from the tokens list
1783      */
1784     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1785         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1786         // then delete the last slot (swap and pop).
1787 
1788         uint256 lastTokenIndex = _allTokens.length - 1;
1789         uint256 tokenIndex = _allTokensIndex[tokenId];
1790 
1791         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1792         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1793         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1794         uint256 lastTokenId = _allTokens[lastTokenIndex];
1795 
1796         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1797         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1798 
1799         // This also deletes the contents at the last position of the array
1800         delete _allTokensIndex[tokenId];
1801         _allTokens.pop();
1802     }
1803 }
1804 
1805 pragma solidity ^0.8.0;
1806 pragma abicoder v2;
1807 
1808 contract MetaLordz is ERC721Enumerable, Ownable {
1809     
1810     using SafeMath for uint256;
1811 
1812     address private owner_;
1813     bytes32 public merkleRoot;
1814 	bytes32 public claimsRoot;
1815 	address public wallet1 = 0x94C967079DFB253E4dE24c0a845ff2A13E279bbA;
1816     address public wallet2 = 0x82d7ed59eB4a573e7AaceFc6f84F579014f433BE;
1817     address public wallet3 = 0xcA0ff953D73c0c86C8aA9069A092de1010c5Ae99;
1818     address public wallet4 = 0x16A0A11E0dbff1Cc1e7144A9311D1D4EA9e0DEc3;
1819 
1820     uint256 public constant metalordzPrice = 90000000000000000;
1821     uint256 public constant metalordzWLPrice = 70000000000000000;
1822     uint public maxMetalordzPurchase = 3;
1823 	uint public maxMetalordzPerAddress = 6;
1824     uint256 public constant MAX_METALORDZ = 4444;
1825     uint public metalordzReserve = 200;
1826 
1827     bool public saleIsActive = false;
1828 	bool public ClaimIsActive = false;
1829 	bool public whitelistSaleIsActive = false;
1830 	
1831     mapping(address => bool) private whitelisted_minters;
1832     mapping(address => uint) private max_mints_per_address;
1833     
1834 	event WhitelistedMint(address minter);
1835     event MerkleRootUpdated(bytes32 new_merkle_root);
1836     event ReserveRootUpdated(bytes32 new_merkle_root);	
1837 	event wallet1AddressChanged(address _wallet1);
1838     event wallet2AddressChanged(address _wallet2);
1839     event wallet3AddressChanged(address _wallet3);
1840     event wallet4AddressChanged(address _wallet4);
1841     
1842     string public baseTokenURI;
1843     
1844     constructor() ERC721("MetaLordz", "MTL") { }
1845     
1846     function withdraw() public onlyOwner {
1847         uint balance = address(this).balance;
1848         payable(msg.sender).transfer(balance);
1849     }
1850 
1851 	function setPuchaseLimit(uint maxAllowed) external onlyOwner {
1852         maxMetalordzPurchase = maxAllowed;
1853     }
1854 	
1855 	function setAddressLimit(uint maxAllowed) external onlyOwner {
1856         maxMetalordzPerAddress = maxAllowed;
1857     }
1858 
1859     function updateReserveRoot(bytes32 newmerkleRoot) external onlyOwner {
1860         claimsRoot = newmerkleRoot;
1861         emit ReserveRootUpdated(claimsRoot);
1862     }
1863 
1864     function claimMetalordz(bytes32[] calldata merkleProof) public {        
1865         require(ClaimIsActive, "Giveaways must be active to claim MetaLordz");
1866         require(max_mints_per_address[msg.sender].add(1) <= 1,"Max 1 mints allowed per whitelisted wallet");
1867 
1868         // Verify the merkle proof
1869         require(MerkleProof.verify(merkleProof, claimsRoot,  keccak256(abi.encodePacked(msg.sender))  ), "Invalid proof");
1870 		
1871         _safeMint(msg.sender, totalSupply());
1872 		max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
1873         metalordzReserve = metalordzReserve.sub(1);
1874     }
1875 
1876 
1877     function _baseURI() internal view virtual override returns (string memory) {
1878         return baseTokenURI;
1879     }
1880 
1881     function setBaseURI(string memory baseURI) public onlyOwner {
1882         baseTokenURI = baseURI;
1883     }
1884 
1885 
1886     function flipSaleState() public onlyOwner {
1887         saleIsActive = !saleIsActive;
1888     }
1889 
1890     function flipWhitelistSaleState() public onlyOwner {
1891         whitelistSaleIsActive = !whitelistSaleIsActive;
1892     }    
1893 
1894     function flipClaimState() public onlyOwner {
1895         ClaimIsActive = !ClaimIsActive;
1896     }  
1897        
1898      function mintMetalordz(uint numberOfTokens) public payable {
1899         require(saleIsActive, "Sale must be active to mint MetaLordz");
1900         require(numberOfTokens > 0 && numberOfTokens <= maxMetalordzPurchase, "Per transaction limit exceeded");
1901         require(msg.value == metalordzPrice.mul(numberOfTokens), "Ether value sent is not correct");
1902         require(max_mints_per_address[msg.sender].add(numberOfTokens) <= maxMetalordzPerAddress,"Per waller limit exceeded");
1903         
1904         for(uint i = 0; i < numberOfTokens; i++) {
1905             if (totalSupply() < MAX_METALORDZ) {
1906                 _safeMint(msg.sender, totalSupply());
1907                 max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
1908             } else {
1909                saleIsActive = !saleIsActive;
1910                 payable(msg.sender).transfer(numberOfTokens.sub(i).mul(metalordzPrice));
1911                 break;
1912             }
1913         }
1914     }
1915 
1916    
1917    // to set the merkle proof
1918     function updateMerkleRoot(bytes32 newmerkleRoot) external onlyOwner {
1919         merkleRoot = newmerkleRoot;
1920         emit MerkleRootUpdated(merkleRoot);
1921     }
1922 
1923 
1924     function whitelistedMints(uint numberOfTokens, bytes32[] calldata merkleProof ) payable external  {
1925         address user_ = msg.sender;
1926         require(whitelistSaleIsActive, "Sale must be active to mint MetaLordz");
1927         require(numberOfTokens > 0 && numberOfTokens <= 2, "Can only mint 2 tokens at a time");
1928         require(msg.value == metalordzWLPrice.mul(numberOfTokens), "Ether value sent is not correct");
1929         require(max_mints_per_address[msg.sender].add(numberOfTokens) <= 2,"Max 2 mints allowed per whitelisted wallet");
1930 
1931         // Verify the merkle proof
1932         require(MerkleProof.verify(merkleProof, merkleRoot,  keccak256(abi.encodePacked(user_))  ), "Invalid proof");
1933 		
1934 		for(uint i = 0; i < numberOfTokens; i++) {
1935             if (totalSupply() < MAX_METALORDZ) {
1936                 _safeMint(msg.sender, totalSupply());
1937                 max_mints_per_address[msg.sender] = max_mints_per_address[msg.sender].add(1);
1938             } else {
1939 			    whitelistSaleIsActive = !whitelistSaleIsActive;
1940                 payable(msg.sender).transfer(numberOfTokens.sub(i).mul(metalordzWLPrice));
1941                 break;
1942             }
1943         }
1944 
1945         emit WhitelistedMint(user_);
1946     }
1947 	
1948     function setWallet_1(address _address) external onlyOwner {
1949         wallet1 = _address;
1950         emit wallet1AddressChanged(_address);
1951     }
1952     
1953     function setWallet_2(address _address) external onlyOwner {
1954         wallet2 = _address;
1955         emit wallet2AddressChanged(_address);
1956     }
1957 
1958     function setWallet_3(address _address) external onlyOwner {
1959         wallet3 = _address;
1960         emit wallet3AddressChanged(_address);
1961     }
1962     
1963     function setWallet_4(address _address) external onlyOwner {
1964         wallet4 = _address;
1965         emit wallet4AddressChanged(_address);
1966     }
1967 
1968     function withdrawAll() external onlyOwner {
1969         require(address(this).balance > 0, "No balance to withdraw.");
1970         uint256 _amount = address(this).balance;
1971         (bool wallet1Success, ) = wallet1.call{value: _amount.mul(63).div(100)}("");
1972         (bool wallet2Success, ) = wallet2.call{value: _amount.mul(33).div(100)}("");
1973         (bool wallet3Success, ) = wallet3.call{value: _amount.mul(3).div(100)}("");
1974         (bool wallet4Success, ) = wallet4.call{value: _amount.mul(1).div(100)}("");
1975 
1976         require(wallet1Success && wallet2Success && wallet3Success && wallet4Success, "Withdrawal failed.");
1977     }
1978 }