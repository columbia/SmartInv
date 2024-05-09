1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
10  *
11  * These functions can be used to verify that a message was signed by the holder
12  * of the private keys of a given address.
13  */
14 library ECDSA {
15     enum RecoverError {
16         NoError,
17         InvalidSignature,
18         InvalidSignatureLength,
19         InvalidSignatureS,
20         InvalidSignatureV
21     }
22 
23     function _throwError(RecoverError error) private pure {
24         if (error == RecoverError.NoError) {
25             return; // no error: do nothing
26         } else if (error == RecoverError.InvalidSignature) {
27             revert("ECDSA: invalid signature");
28         } else if (error == RecoverError.InvalidSignatureLength) {
29             revert("ECDSA: invalid signature length");
30         } else if (error == RecoverError.InvalidSignatureS) {
31             revert("ECDSA: invalid signature 's' value");
32         } else if (error == RecoverError.InvalidSignatureV) {
33             revert("ECDSA: invalid signature 'v' value");
34         }
35     }
36 
37     /**
38      * @dev Returns the address that signed a hashed message (`hash`) with
39      * `signature` or error string. This address can then be used for verification purposes.
40      *
41      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
42      * this function rejects them by requiring the `s` value to be in the lower
43      * half order, and the `v` value to be either 27 or 28.
44      *
45      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
46      * verification to be secure: it is possible to craft signatures that
47      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
48      * this is by receiving a hash of the original message (which may otherwise
49      * be too long), and then calling {toEthSignedMessageHash} on it.
50      *
51      * Documentation for signature generation:
52      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
53      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
54      *
55      * _Available since v4.3._
56      */
57     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
58         // Check the signature length
59         // - case 65: r,s,v signature (standard)
60         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
61         if (signature.length == 65) {
62             bytes32 r;
63             bytes32 s;
64             uint8 v;
65             // ecrecover takes the signature parameters, and the only way to get them
66             // currently is to use assembly.
67             assembly {
68                 r := mload(add(signature, 0x20))
69                 s := mload(add(signature, 0x40))
70                 v := byte(0, mload(add(signature, 0x60)))
71             }
72             return tryRecover(hash, v, r, s);
73         } else if (signature.length == 64) {
74             bytes32 r;
75             bytes32 vs;
76             // ecrecover takes the signature parameters, and the only way to get them
77             // currently is to use assembly.
78             assembly {
79                 r := mload(add(signature, 0x20))
80                 vs := mload(add(signature, 0x40))
81             }
82             return tryRecover(hash, r, vs);
83         } else {
84             return (address(0), RecoverError.InvalidSignatureLength);
85         }
86     }
87 
88     /**
89      * @dev Returns the address that signed a hashed message (`hash`) with
90      * `signature`. This address can then be used for verification purposes.
91      *
92      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
93      * this function rejects them by requiring the `s` value to be in the lower
94      * half order, and the `v` value to be either 27 or 28.
95      *
96      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
97      * verification to be secure: it is possible to craft signatures that
98      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
99      * this is by receiving a hash of the original message (which may otherwise
100      * be too long), and then calling {toEthSignedMessageHash} on it.
101      */
102     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
103         (address recovered, RecoverError error) = tryRecover(hash, signature);
104         _throwError(error);
105         return recovered;
106     }
107 
108     /**
109      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
110      *
111      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
112      *
113      * _Available since v4.3._
114      */
115     function tryRecover(
116         bytes32 hash,
117         bytes32 r,
118         bytes32 vs
119     ) internal pure returns (address, RecoverError) {
120         bytes32 s;
121         uint8 v;
122         assembly {
123             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
124             v := add(shr(255, vs), 27)
125         }
126         return tryRecover(hash, v, r, s);
127     }
128 
129     /**
130      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
131      *
132      * _Available since v4.2._
133      */
134     function recover(
135         bytes32 hash,
136         bytes32 r,
137         bytes32 vs
138     ) internal pure returns (address) {
139         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
140         _throwError(error);
141         return recovered;
142     }
143 
144     /**
145      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
146      * `r` and `s` signature fields separately.
147      *
148      * _Available since v4.3._
149      */
150     function tryRecover(
151         bytes32 hash,
152         uint8 v,
153         bytes32 r,
154         bytes32 s
155     ) internal pure returns (address, RecoverError) {
156         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
157         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
158         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
159         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
160         //
161         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
162         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
163         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
164         // these malleable signatures as well.
165         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
166             return (address(0), RecoverError.InvalidSignatureS);
167         }
168         if (v != 27 && v != 28) {
169             return (address(0), RecoverError.InvalidSignatureV);
170         }
171 
172         // If the signature is valid (and not malleable), return the signer address
173         address signer = ecrecover(hash, v, r, s);
174         if (signer == address(0)) {
175             return (address(0), RecoverError.InvalidSignature);
176         }
177 
178         return (signer, RecoverError.NoError);
179     }
180 
181     /**
182      * @dev Overload of {ECDSA-recover} that receives the `v`,
183      * `r` and `s` signature fields separately.
184      */
185     function recover(
186         bytes32 hash,
187         uint8 v,
188         bytes32 r,
189         bytes32 s
190     ) internal pure returns (address) {
191         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
192         _throwError(error);
193         return recovered;
194     }
195 
196     /**
197      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
198      * produces hash corresponding to the one signed with the
199      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
200      * JSON-RPC method as part of EIP-191.
201      *
202      * See {recover}.
203      */
204     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
205         // 32 is the length in bytes of hash,
206         // enforced by the type signature above
207         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
208     }
209 
210     /**
211      * @dev Returns an Ethereum Signed Typed Data, created from a
212      * `domainSeparator` and a `structHash`. This produces hash corresponding
213      * to the one signed with the
214      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
215      * JSON-RPC method as part of EIP-712.
216      *
217      * See {recover}.
218      */
219     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
220         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
221     }
222 }
223 
224 // File: contracts/common/meta-transactions/Initializable.sol
225 
226 
227 
228 pragma solidity ^0.8.0;
229 
230 contract Initializable {
231     bool inited = false;
232 
233     modifier initializer() {
234         require(!inited, "already inited");
235         _;
236         inited = true;
237     }
238 }
239 // File: contracts/common/meta-transactions/EIP712Base.sol
240 
241 
242 
243 pragma solidity ^0.8.0;
244 
245 
246 contract EIP712Base is Initializable {
247     struct EIP712Domain {
248         string name;
249         string version;
250         address verifyingContract;
251         bytes32 salt;
252     }
253 
254     string constant public ERC712_VERSION = "1";
255 
256     // Lifestory : edit bytes32 salt to uint32 : for easly use
257     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
258         bytes(
259             "EIP712Domain(string name,string version,address verifyingContract,uint32 salt)"
260         )
261     );
262     bytes32 internal domainSeperator;
263 
264     // supposed to be called once while initializing.
265     // one of the contracts that inherits this contract follows proxy pattern
266     // so it is not possible to do this in a constructor
267     function _initializeEIP712(
268         string memory name
269     )
270         internal
271         initializer
272     {
273         _setDomainSeperator(name);
274     }
275 
276     function _setDomainSeperator(string memory name) internal {
277         domainSeperator = keccak256(
278             abi.encode(
279                 EIP712_DOMAIN_TYPEHASH,
280                 keccak256(bytes(name)),
281                 keccak256(bytes(ERC712_VERSION)),
282                 address(this),
283                 uint32(getChainId())
284             )
285         );
286     }
287 
288     function getDomainSeperator() public view returns (bytes32) {
289         return domainSeperator;
290     }
291 
292     function getChainId() public view returns (uint256) {
293         uint256 id;
294         assembly {
295             id := chainid()
296         }
297         return id;
298     }
299 
300     /**
301      * Accept message hash and returns hash message in EIP712 compatible form
302      * So that it can be used to recover signer from signature signed using EIP712 formatted data
303      * https://eips.ethereum.org/EIPS/eip-712
304      * "\\x19" makes the encoding deterministic
305      * "\\x01" is the version byte to make it compatible to EIP-191
306      */
307     function toTypedMessageHash(bytes32 messageHash)
308         internal
309         view
310         returns (bytes32)
311     {
312         return
313             keccak256(
314                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
315             );
316     }
317 }
318 // File: contracts/common/meta-transactions/ContentMixin.sol
319 
320 
321 
322 pragma solidity ^0.8.0;
323 
324 abstract contract ContextMixin {
325     function msgSender()
326         internal
327         view
328         returns (address payable sender)
329     {
330         if (msg.sender == address(this)) {
331             bytes memory array = msg.data;
332             uint256 index = msg.data.length;
333             assembly {
334                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
335                 sender := and(
336                     mload(add(array, index)),
337                     0xffffffffffffffffffffffffffffffffffffffff
338                 )
339             }
340         } else {
341             sender = payable(msg.sender);
342         }
343         return sender;
344     }
345 }
346 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
347 
348 
349 
350 pragma solidity ^0.8.0;
351 
352 // CAUTION
353 // This version of SafeMath should only be used with Solidity 0.8 or later,
354 // because it relies on the compiler's built in overflow checks.
355 
356 /**
357  * @dev Wrappers over Solidity's arithmetic operations.
358  *
359  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
360  * now has built in overflow checking.
361  */
362 library SafeMath {
363     /**
364      * @dev Returns the addition of two unsigned integers, with an overflow flag.
365      *
366      * _Available since v3.4._
367      */
368     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
369         unchecked {
370             uint256 c = a + b;
371             if (c < a) return (false, 0);
372             return (true, c);
373         }
374     }
375 
376     /**
377      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
378      *
379      * _Available since v3.4._
380      */
381     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
382         unchecked {
383             if (b > a) return (false, 0);
384             return (true, a - b);
385         }
386     }
387 
388     /**
389      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         unchecked {
395             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
396             // benefit is lost if 'b' is also tested.
397             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
398             if (a == 0) return (true, 0);
399             uint256 c = a * b;
400             if (c / a != b) return (false, 0);
401             return (true, c);
402         }
403     }
404 
405     /**
406      * @dev Returns the division of two unsigned integers, with a division by zero flag.
407      *
408      * _Available since v3.4._
409      */
410     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
411         unchecked {
412             if (b == 0) return (false, 0);
413             return (true, a / b);
414         }
415     }
416 
417     /**
418      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
419      *
420      * _Available since v3.4._
421      */
422     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
423         unchecked {
424             if (b == 0) return (false, 0);
425             return (true, a % b);
426         }
427     }
428 
429     /**
430      * @dev Returns the addition of two unsigned integers, reverting on
431      * overflow.
432      *
433      * Counterpart to Solidity's `+` operator.
434      *
435      * Requirements:
436      *
437      * - Addition cannot overflow.
438      */
439     function add(uint256 a, uint256 b) internal pure returns (uint256) {
440         return a + b;
441     }
442 
443     /**
444      * @dev Returns the subtraction of two unsigned integers, reverting on
445      * overflow (when the result is negative).
446      *
447      * Counterpart to Solidity's `-` operator.
448      *
449      * Requirements:
450      *
451      * - Subtraction cannot overflow.
452      */
453     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
454         return a - b;
455     }
456 
457     /**
458      * @dev Returns the multiplication of two unsigned integers, reverting on
459      * overflow.
460      *
461      * Counterpart to Solidity's `*` operator.
462      *
463      * Requirements:
464      *
465      * - Multiplication cannot overflow.
466      */
467     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
468         return a * b;
469     }
470 
471     /**
472      * @dev Returns the integer division of two unsigned integers, reverting on
473      * division by zero. The result is rounded towards zero.
474      *
475      * Counterpart to Solidity's `/` operator.
476      *
477      * Requirements:
478      *
479      * - The divisor cannot be zero.
480      */
481     function div(uint256 a, uint256 b) internal pure returns (uint256) {
482         return a / b;
483     }
484 
485     /**
486      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
487      * reverting when dividing by zero.
488      *
489      * Counterpart to Solidity's `%` operator. This function uses a `revert`
490      * opcode (which leaves remaining gas untouched) while Solidity uses an
491      * invalid opcode to revert (consuming all remaining gas).
492      *
493      * Requirements:
494      *
495      * - The divisor cannot be zero.
496      */
497     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
498         return a % b;
499     }
500 
501     /**
502      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
503      * overflow (when the result is negative).
504      *
505      * CAUTION: This function is deprecated because it requires allocating memory for the error
506      * message unnecessarily. For custom revert reasons use {trySub}.
507      *
508      * Counterpart to Solidity's `-` operator.
509      *
510      * Requirements:
511      *
512      * - Subtraction cannot overflow.
513      */
514     function sub(
515         uint256 a,
516         uint256 b,
517         string memory errorMessage
518     ) internal pure returns (uint256) {
519         unchecked {
520             require(b <= a, errorMessage);
521             return a - b;
522         }
523     }
524 
525     /**
526      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
527      * division by zero. The result is rounded towards zero.
528      *
529      * Counterpart to Solidity's `/` operator. Note: this function uses a
530      * `revert` opcode (which leaves remaining gas untouched) while Solidity
531      * uses an invalid opcode to revert (consuming all remaining gas).
532      *
533      * Requirements:
534      *
535      * - The divisor cannot be zero.
536      */
537     function div(
538         uint256 a,
539         uint256 b,
540         string memory errorMessage
541     ) internal pure returns (uint256) {
542         unchecked {
543             require(b > 0, errorMessage);
544             return a / b;
545         }
546     }
547 
548     /**
549      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
550      * reverting with custom message when dividing by zero.
551      *
552      * CAUTION: This function is deprecated because it requires allocating memory for the error
553      * message unnecessarily. For custom revert reasons use {tryMod}.
554      *
555      * Counterpart to Solidity's `%` operator. This function uses a `revert`
556      * opcode (which leaves remaining gas untouched) while Solidity uses an
557      * invalid opcode to revert (consuming all remaining gas).
558      *
559      * Requirements:
560      *
561      * - The divisor cannot be zero.
562      */
563     function mod(
564         uint256 a,
565         uint256 b,
566         string memory errorMessage
567     ) internal pure returns (uint256) {
568         unchecked {
569             require(b > 0, errorMessage);
570             return a % b;
571         }
572     }
573 }
574 
575 // File: contracts/common/meta-transactions/NativeMetaTransaction.sol
576 
577 
578 
579 pragma solidity ^0.8.0;
580 
581 
582 
583 contract NativeMetaTransaction is EIP712Base {
584     using SafeMath for uint256;
585     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
586         bytes(
587             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
588         )
589     );
590     event MetaTransactionExecuted(
591         address userAddress,
592         address payable relayerAddress,
593         bytes functionSignature
594     );
595     mapping(address => uint256) nonces;
596 
597     /*
598      * Meta transaction structure.
599      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
600      * He should call the desired function directly in that case.
601      */
602     struct MetaTransaction {
603         uint256 nonce;
604         address from;
605         bytes functionSignature;
606     }
607 
608     function executeMetaTransaction(
609         address userAddress,
610         bytes memory functionSignature,
611         bytes32 sigR,
612         bytes32 sigS,
613         uint8 sigV
614     ) public payable returns (bytes memory) {
615         MetaTransaction memory metaTx = MetaTransaction({
616             nonce: nonces[userAddress],
617             from: userAddress,
618             functionSignature: functionSignature
619         });
620 
621         require(
622             verify(userAddress, metaTx, sigR, sigS, sigV),
623             "Signer and signature do not match"
624         );
625 
626         // increase nonce for user (to avoid re-use)
627         nonces[userAddress] = nonces[userAddress].add(1);
628 
629         emit MetaTransactionExecuted(
630             userAddress,
631             payable(msg.sender),
632             functionSignature
633         );
634 
635         // Append userAddress and relayer address at the end to extract it from calling context
636         (bool success, bytes memory returnData) = address(this).call(
637             abi.encodePacked(functionSignature, userAddress)
638         );
639         require(success, "Function call not successful");
640 
641         return returnData;
642     }
643 
644     function hashMetaTransaction(MetaTransaction memory metaTx)
645         internal
646         pure
647         returns (bytes32)
648     {
649         return
650             keccak256(
651                 abi.encode(
652                     META_TRANSACTION_TYPEHASH,
653                     metaTx.nonce,
654                     metaTx.from,
655                     keccak256(metaTx.functionSignature)
656                 )
657             );
658     }
659 
660     function getNonce(address user) public view returns (uint256 nonce) {
661         nonce = nonces[user];
662     }
663 
664     function verify(
665         address signer,
666         MetaTransaction memory metaTx,
667         bytes32 sigR,
668         bytes32 sigS,
669         uint8 sigV
670     ) internal view returns (bool) {
671         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
672         return
673             signer ==
674             ecrecover(
675                 toTypedMessageHash(hashMetaTransaction(metaTx)),
676                 sigV,
677                 sigR,
678                 sigS
679             );
680     }
681 }
682 // File: @openzeppelin/contracts/utils/Counters.sol
683 
684 
685 
686 pragma solidity ^0.8.0;
687 
688 /**
689  * @title Counters
690  * @author Matt Condon (@shrugs)
691  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
692  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
693  *
694  * Include with `using Counters for Counters.Counter;`
695  */
696 library Counters {
697     struct Counter {
698         // This variable should never be directly accessed by users of the library: interactions must be restricted to
699         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
700         // this feature: see https://github.com/ethereum/solidity/issues/4637
701         uint256 _value; // default: 0
702     }
703 
704     function current(Counter storage counter) internal view returns (uint256) {
705         return counter._value;
706     }
707 
708     function increment(Counter storage counter) internal {
709         unchecked {
710             counter._value += 1;
711         }
712     }
713 
714     function decrement(Counter storage counter) internal {
715         uint256 value = counter._value;
716         require(value > 0, "Counter: decrement overflow");
717         unchecked {
718             counter._value = value - 1;
719         }
720     }
721 
722     function reset(Counter storage counter) internal {
723         counter._value = 0;
724     }
725 }
726 
727 // File: @openzeppelin/contracts/utils/Strings.sol
728 
729 
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev String operations.
735  */
736 library Strings {
737     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
738 
739     /**
740      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
741      */
742     function toString(uint256 value) internal pure returns (string memory) {
743         // Inspired by OraclizeAPI's implementation - MIT licence
744         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
745 
746         if (value == 0) {
747             return "0";
748         }
749         uint256 temp = value;
750         uint256 digits;
751         while (temp != 0) {
752             digits++;
753             temp /= 10;
754         }
755         bytes memory buffer = new bytes(digits);
756         while (value != 0) {
757             digits -= 1;
758             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
759             value /= 10;
760         }
761         return string(buffer);
762     }
763 
764     /**
765      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
766      */
767     function toHexString(uint256 value) internal pure returns (string memory) {
768         if (value == 0) {
769             return "0x00";
770         }
771         uint256 temp = value;
772         uint256 length = 0;
773         while (temp != 0) {
774             length++;
775             temp >>= 8;
776         }
777         return toHexString(value, length);
778     }
779 
780     /**
781      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
782      */
783     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
784         bytes memory buffer = new bytes(2 * length + 2);
785         buffer[0] = "0";
786         buffer[1] = "x";
787         for (uint256 i = 2 * length + 1; i > 1; --i) {
788             buffer[i] = _HEX_SYMBOLS[value & 0xf];
789             value >>= 4;
790         }
791         require(value == 0, "Strings: hex length insufficient");
792         return string(buffer);
793     }
794 }
795 
796 // File: @openzeppelin/contracts/utils/Context.sol
797 
798 
799 
800 pragma solidity ^0.8.0;
801 
802 /**
803  * @dev Provides information about the current execution context, including the
804  * sender of the transaction and its data. While these are generally available
805  * via msg.sender and msg.data, they should not be accessed in such a direct
806  * manner, since when dealing with meta-transactions the account sending and
807  * paying for execution may not be the actual sender (as far as an application
808  * is concerned).
809  *
810  * This contract is only required for intermediate, library-like contracts.
811  */
812 abstract contract Context {
813     function _msgSender() internal view virtual returns (address) {
814         return msg.sender;
815     }
816 
817     function _msgData() internal view virtual returns (bytes calldata) {
818         return msg.data;
819     }
820 }
821 
822 // File: @openzeppelin/contracts/access/Ownable.sol
823 
824 
825 
826 pragma solidity ^0.8.0;
827 
828 
829 /**
830  * @dev Contract module which provides a basic access control mechanism, where
831  * there is an account (an owner) that can be granted exclusive access to
832  * specific functions.
833  *
834  * By default, the owner account will be the one that deploys the contract. This
835  * can later be changed with {transferOwnership}.
836  *
837  * This module is used through inheritance. It will make available the modifier
838  * `onlyOwner`, which can be applied to your functions to restrict their use to
839  * the owner.
840  */
841 abstract contract Ownable is Context {
842     address private _owner;
843 
844     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
845 
846     /**
847      * @dev Initializes the contract setting the deployer as the initial owner.
848      */
849     constructor() {
850         _setOwner(_msgSender());
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
861      * @dev Throws if called by any account other than the owner.
862      */
863     modifier onlyOwner() {
864         require(owner() == _msgSender(), "Ownable: caller is not the owner");
865         _;
866     }
867 
868     /**
869      * @dev Leaves the contract without owner. It will not be possible to call
870      * `onlyOwner` functions anymore. Can only be called by the current owner.
871      *
872      * NOTE: Renouncing ownership will leave the contract without an owner,
873      * thereby removing any functionality that is only available to the owner.
874      */
875     function renounceOwnership() public virtual onlyOwner {
876         _setOwner(address(0));
877     }
878 
879     /**
880      * @dev Transfers ownership of the contract to a new account (`newOwner`).
881      * Can only be called by the current owner.
882      */
883     function transferOwnership(address newOwner) public virtual onlyOwner {
884         require(newOwner != address(0), "Ownable: new owner is the zero address");
885         _setOwner(newOwner);
886     }
887 
888     function _setOwner(address newOwner) private {
889         address oldOwner = _owner;
890         _owner = newOwner;
891         emit OwnershipTransferred(oldOwner, newOwner);
892     }
893 }
894 
895 // File: @openzeppelin/contracts/utils/Address.sol
896 
897 
898 
899 pragma solidity ^0.8.0;
900 
901 /**
902  * @dev Collection of functions related to the address type
903  */
904 library Address {
905     /**
906      * @dev Returns true if `account` is a contract.
907      *
908      * [IMPORTANT]
909      * ====
910      * It is unsafe to assume that an address for which this function returns
911      * false is an externally-owned account (EOA) and not a contract.
912      *
913      * Among others, `isContract` will return false for the following
914      * types of addresses:
915      *
916      *  - an externally-owned account
917      *  - a contract in construction
918      *  - an address where a contract will be created
919      *  - an address where a contract lived, but was destroyed
920      * ====
921      */
922     function isContract(address account) internal view returns (bool) {
923         // This method relies on extcodesize, which returns 0 for contracts in
924         // construction, since the code is only stored at the end of the
925         // constructor execution.
926 
927         uint256 size;
928         assembly {
929             size := extcodesize(account)
930         }
931         return size > 0;
932     }
933 
934     /**
935      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
936      * `recipient`, forwarding all available gas and reverting on errors.
937      *
938      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
939      * of certain opcodes, possibly making contracts go over the 2300 gas limit
940      * imposed by `transfer`, making them unable to receive funds via
941      * `transfer`. {sendValue} removes this limitation.
942      *
943      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
944      *
945      * IMPORTANT: because control is transferred to `recipient`, care must be
946      * taken to not create reentrancy vulnerabilities. Consider using
947      * {ReentrancyGuard} or the
948      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
949      */
950     function sendValue(address payable recipient, uint256 amount) internal {
951         require(address(this).balance >= amount, "Address: insufficient balance");
952 
953         (bool success, ) = recipient.call{value: amount}("");
954         require(success, "Address: unable to send value, recipient may have reverted");
955     }
956 
957     /**
958      * @dev Performs a Solidity function call using a low level `call`. A
959      * plain `call` is an unsafe replacement for a function call: use this
960      * function instead.
961      *
962      * If `target` reverts with a revert reason, it is bubbled up by this
963      * function (like regular Solidity function calls).
964      *
965      * Returns the raw returned data. To convert to the expected return value,
966      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
967      *
968      * Requirements:
969      *
970      * - `target` must be a contract.
971      * - calling `target` with `data` must not revert.
972      *
973      * _Available since v3.1._
974      */
975     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
976         return functionCall(target, data, "Address: low-level call failed");
977     }
978 
979     /**
980      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
981      * `errorMessage` as a fallback revert reason when `target` reverts.
982      *
983      * _Available since v3.1._
984      */
985     function functionCall(
986         address target,
987         bytes memory data,
988         string memory errorMessage
989     ) internal returns (bytes memory) {
990         return functionCallWithValue(target, data, 0, errorMessage);
991     }
992 
993     /**
994      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
995      * but also transferring `value` wei to `target`.
996      *
997      * Requirements:
998      *
999      * - the calling contract must have an ETH balance of at least `value`.
1000      * - the called Solidity function must be `payable`.
1001      *
1002      * _Available since v3.1._
1003      */
1004     function functionCallWithValue(
1005         address target,
1006         bytes memory data,
1007         uint256 value
1008     ) internal returns (bytes memory) {
1009         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1010     }
1011 
1012     /**
1013      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1014      * with `errorMessage` as a fallback revert reason when `target` reverts.
1015      *
1016      * _Available since v3.1._
1017      */
1018     function functionCallWithValue(
1019         address target,
1020         bytes memory data,
1021         uint256 value,
1022         string memory errorMessage
1023     ) internal returns (bytes memory) {
1024         require(address(this).balance >= value, "Address: insufficient balance for call");
1025         require(isContract(target), "Address: call to non-contract");
1026 
1027         (bool success, bytes memory returndata) = target.call{value: value}(data);
1028         return verifyCallResult(success, returndata, errorMessage);
1029     }
1030 
1031     /**
1032      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1033      * but performing a static call.
1034      *
1035      * _Available since v3.3._
1036      */
1037     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1038         return functionStaticCall(target, data, "Address: low-level static call failed");
1039     }
1040 
1041     /**
1042      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1043      * but performing a static call.
1044      *
1045      * _Available since v3.3._
1046      */
1047     function functionStaticCall(
1048         address target,
1049         bytes memory data,
1050         string memory errorMessage
1051     ) internal view returns (bytes memory) {
1052         require(isContract(target), "Address: static call to non-contract");
1053 
1054         (bool success, bytes memory returndata) = target.staticcall(data);
1055         return verifyCallResult(success, returndata, errorMessage);
1056     }
1057 
1058     /**
1059      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1060      * but performing a delegate call.
1061      *
1062      * _Available since v3.4._
1063      */
1064     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1065         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1066     }
1067 
1068     /**
1069      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1070      * but performing a delegate call.
1071      *
1072      * _Available since v3.4._
1073      */
1074     function functionDelegateCall(
1075         address target,
1076         bytes memory data,
1077         string memory errorMessage
1078     ) internal returns (bytes memory) {
1079         require(isContract(target), "Address: delegate call to non-contract");
1080 
1081         (bool success, bytes memory returndata) = target.delegatecall(data);
1082         return verifyCallResult(success, returndata, errorMessage);
1083     }
1084 
1085     /**
1086      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1087      * revert reason using the provided one.
1088      *
1089      * _Available since v4.3._
1090      */
1091     function verifyCallResult(
1092         bool success,
1093         bytes memory returndata,
1094         string memory errorMessage
1095     ) internal pure returns (bytes memory) {
1096         if (success) {
1097             return returndata;
1098         } else {
1099             // Look for revert reason and bubble it up if present
1100             if (returndata.length > 0) {
1101                 // The easiest way to bubble the revert reason is using memory via assembly
1102 
1103                 assembly {
1104                     let returndata_size := mload(returndata)
1105                     revert(add(32, returndata), returndata_size)
1106                 }
1107             } else {
1108                 revert(errorMessage);
1109             }
1110         }
1111     }
1112 }
1113 
1114 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
1115 
1116 
1117 
1118 pragma solidity ^0.8.0;
1119 
1120 /**
1121  * @title ERC721 token receiver interface
1122  * @dev Interface for any contract that wants to support safeTransfers
1123  * from ERC721 asset contracts.
1124  */
1125 interface IERC721Receiver {
1126     /**
1127      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1128      * by `operator` from `from`, this function is called.
1129      *
1130      * It must return its Solidity selector to confirm the token transfer.
1131      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1132      *
1133      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1134      */
1135     function onERC721Received(
1136         address operator,
1137         address from,
1138         uint256 tokenId,
1139         bytes calldata data
1140     ) external returns (bytes4);
1141 }
1142 
1143 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
1144 
1145 
1146 
1147 pragma solidity ^0.8.0;
1148 
1149 /**
1150  * @dev Interface of the ERC165 standard, as defined in the
1151  * https://eips.ethereum.org/EIPS/eip-165[EIP].
1152  *
1153  * Implementers can declare support of contract interfaces, which can then be
1154  * queried by others ({ERC165Checker}).
1155  *
1156  * For an implementation, see {ERC165}.
1157  */
1158 interface IERC165 {
1159     /**
1160      * @dev Returns true if this contract implements the interface defined by
1161      * `interfaceId`. See the corresponding
1162      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
1163      * to learn more about how these ids are created.
1164      *
1165      * This function call must use less than 30 000 gas.
1166      */
1167     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1168 }
1169 
1170 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
1171 
1172 
1173 
1174 pragma solidity ^0.8.0;
1175 
1176 
1177 /**
1178  * @dev Implementation of the {IERC165} interface.
1179  *
1180  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
1181  * for the additional interface id that will be supported. For example:
1182  *
1183  * ```solidity
1184  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1185  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
1186  * }
1187  * ```
1188  *
1189  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
1190  */
1191 abstract contract ERC165 is IERC165 {
1192     /**
1193      * @dev See {IERC165-supportsInterface}.
1194      */
1195     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1196         return interfaceId == type(IERC165).interfaceId;
1197     }
1198 }
1199 
1200 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1201 
1202 
1203 
1204 pragma solidity ^0.8.0;
1205 
1206 
1207 /**
1208  * @dev Required interface of an ERC721 compliant contract.
1209  */
1210 interface IERC721 is IERC165 {
1211     /**
1212      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1213      */
1214     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1215 
1216     /**
1217      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1218      */
1219     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1220 
1221     /**
1222      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1223      */
1224     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1225 
1226     /**
1227      * @dev Returns the number of tokens in ``owner``'s account.
1228      */
1229     function balanceOf(address owner) external view returns (uint256 balance);
1230 
1231     /**
1232      * @dev Returns the owner of the `tokenId` token.
1233      *
1234      * Requirements:
1235      *
1236      * - `tokenId` must exist.
1237      */
1238     function ownerOf(uint256 tokenId) external view returns (address owner);
1239 
1240     /**
1241      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1242      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1243      *
1244      * Requirements:
1245      *
1246      * - `from` cannot be the zero address.
1247      * - `to` cannot be the zero address.
1248      * - `tokenId` token must exist and be owned by `from`.
1249      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1250      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1251      *
1252      * Emits a {Transfer} event.
1253      */
1254     function safeTransferFrom(
1255         address from,
1256         address to,
1257         uint256 tokenId
1258     ) external;
1259 
1260     /**
1261      * @dev Transfers `tokenId` token from `from` to `to`.
1262      *
1263      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1264      *
1265      * Requirements:
1266      *
1267      * - `from` cannot be the zero address.
1268      * - `to` cannot be the zero address.
1269      * - `tokenId` token must be owned by `from`.
1270      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1271      *
1272      * Emits a {Transfer} event.
1273      */
1274     function transferFrom(
1275         address from,
1276         address to,
1277         uint256 tokenId
1278     ) external;
1279 
1280     /**
1281      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1282      * The approval is cleared when the token is transferred.
1283      *
1284      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1285      *
1286      * Requirements:
1287      *
1288      * - The caller must own the token or be an approved operator.
1289      * - `tokenId` must exist.
1290      *
1291      * Emits an {Approval} event.
1292      */
1293     function approve(address to, uint256 tokenId) external;
1294 
1295     /**
1296      * @dev Returns the account approved for `tokenId` token.
1297      *
1298      * Requirements:
1299      *
1300      * - `tokenId` must exist.
1301      */
1302     function getApproved(uint256 tokenId) external view returns (address operator);
1303 
1304     /**
1305      * @dev Approve or remove `operator` as an operator for the caller.
1306      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1307      *
1308      * Requirements:
1309      *
1310      * - The `operator` cannot be the caller.
1311      *
1312      * Emits an {ApprovalForAll} event.
1313      */
1314     function setApprovalForAll(address operator, bool _approved) external;
1315 
1316     /**
1317      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1318      *
1319      * See {setApprovalForAll}
1320      */
1321     function isApprovedForAll(address owner, address operator) external view returns (bool);
1322 
1323     /**
1324      * @dev Safely transfers `tokenId` token from `from` to `to`.
1325      *
1326      * Requirements:
1327      *
1328      * - `from` cannot be the zero address.
1329      * - `to` cannot be the zero address.
1330      * - `tokenId` token must exist and be owned by `from`.
1331      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1332      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1333      *
1334      * Emits a {Transfer} event.
1335      */
1336     function safeTransferFrom(
1337         address from,
1338         address to,
1339         uint256 tokenId,
1340         bytes calldata data
1341     ) external;
1342 }
1343 
1344 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1345 
1346 
1347 
1348 pragma solidity ^0.8.0;
1349 
1350 
1351 /**
1352  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1353  * @dev See https://eips.ethereum.org/EIPS/eip-721
1354  */
1355 interface IERC721Metadata is IERC721 {
1356     /**
1357      * @dev Returns the token collection name.
1358      */
1359     function name() external view returns (string memory);
1360 
1361     /**
1362      * @dev Returns the token collection symbol.
1363      */
1364     function symbol() external view returns (string memory);
1365 
1366     /**
1367      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1368      */
1369     function tokenURI(uint256 tokenId) external view returns (string memory);
1370 }
1371 
1372 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1373 
1374 
1375 
1376 pragma solidity ^0.8.0;
1377 
1378 
1379 
1380 
1381 
1382 
1383 
1384 
1385 /**
1386  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1387  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1388  * {ERC721Enumerable}.
1389  */
1390 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1391     using Address for address;
1392     using Strings for uint256;
1393 
1394     // Token name
1395     string private _name;
1396 
1397     // Token symbol
1398     string private _symbol;
1399 
1400     // Mapping from token ID to owner address
1401     mapping(uint256 => address) private _owners;
1402 
1403     // Mapping owner address to token count
1404     mapping(address => uint256) private _balances;
1405 
1406     // Mapping from token ID to approved address
1407     mapping(uint256 => address) private _tokenApprovals;
1408 
1409     // Mapping from owner to operator approvals
1410     mapping(address => mapping(address => bool)) private _operatorApprovals;
1411 
1412     /**
1413      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1414      */
1415     constructor(string memory name_, string memory symbol_) {
1416         _name = name_;
1417         _symbol = symbol_;
1418     }
1419 
1420     /**
1421      * @dev See {IERC165-supportsInterface}.
1422      */
1423     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1424         return
1425             interfaceId == type(IERC721).interfaceId ||
1426             interfaceId == type(IERC721Metadata).interfaceId ||
1427             super.supportsInterface(interfaceId);
1428     }
1429 
1430     /**
1431      * @dev See {IERC721-balanceOf}.
1432      */
1433     function balanceOf(address owner) public view virtual override returns (uint256) {
1434         require(owner != address(0), "ERC721: balance query for the zero address");
1435         return _balances[owner];
1436     }
1437 
1438     /**
1439      * @dev See {IERC721-ownerOf}.
1440      */
1441     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1442         address owner = _owners[tokenId];
1443         require(owner != address(0), "ERC721: owner query for nonexistent token");
1444         return owner;
1445     }
1446 
1447     /**
1448      * @dev See {IERC721Metadata-name}.
1449      */
1450     function name() public view virtual override returns (string memory) {
1451         return _name;
1452     }
1453 
1454     /**
1455      * @dev See {IERC721Metadata-symbol}.
1456      */
1457     function symbol() public view virtual override returns (string memory) {
1458         return _symbol;
1459     }
1460 
1461     /**
1462      * @dev See {IERC721Metadata-tokenURI}.
1463      */
1464     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1465         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1466 
1467         string memory baseURI = _baseURI();
1468         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1469     }
1470 
1471     /**
1472      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1473      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1474      * by default, can be overriden in child contracts.
1475      */
1476     function _baseURI() internal view virtual returns (string memory) {
1477         return "";
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-approve}.
1482      */
1483     function approve(address to, uint256 tokenId) public virtual override {
1484         address owner = ERC721.ownerOf(tokenId);
1485         require(to != owner, "ERC721: approval to current owner");
1486 
1487         require(
1488             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1489             "ERC721: approve caller is not owner nor approved for all"
1490         );
1491 
1492         _approve(to, tokenId);
1493     }
1494 
1495     /**
1496      * @dev See {IERC721-getApproved}.
1497      */
1498     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1499         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1500 
1501         return _tokenApprovals[tokenId];
1502     }
1503 
1504     /**
1505      * @dev See {IERC721-setApprovalForAll}.
1506      */
1507     function setApprovalForAll(address operator, bool approved) public virtual override {
1508         require(operator != _msgSender(), "ERC721: approve to caller");
1509 
1510         _operatorApprovals[_msgSender()][operator] = approved;
1511         emit ApprovalForAll(_msgSender(), operator, approved);
1512     }
1513 
1514     /**
1515      * @dev See {IERC721-isApprovedForAll}.
1516      */
1517     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1518         return _operatorApprovals[owner][operator];
1519     }
1520 
1521     /**
1522      * @dev See {IERC721-transferFrom}.
1523      */
1524     function transferFrom(
1525         address from,
1526         address to,
1527         uint256 tokenId
1528     ) public virtual override {
1529         //solhint-disable-next-line max-line-length
1530         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1531 
1532         _transfer(from, to, tokenId);
1533     }
1534 
1535     /**
1536      * @dev See {IERC721-safeTransferFrom}.
1537      */
1538     function safeTransferFrom(
1539         address from,
1540         address to,
1541         uint256 tokenId
1542     ) public virtual override {
1543         safeTransferFrom(from, to, tokenId, "");
1544     }
1545 
1546     /**
1547      * @dev See {IERC721-safeTransferFrom}.
1548      */
1549     function safeTransferFrom(
1550         address from,
1551         address to,
1552         uint256 tokenId,
1553         bytes memory _data
1554     ) public virtual override {
1555         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1556         _safeTransfer(from, to, tokenId, _data);
1557     }
1558 
1559     /**
1560      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1561      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1562      *
1563      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1564      *
1565      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1566      * implement alternative mechanisms to perform token transfer, such as signature-based.
1567      *
1568      * Requirements:
1569      *
1570      * - `from` cannot be the zero address.
1571      * - `to` cannot be the zero address.
1572      * - `tokenId` token must exist and be owned by `from`.
1573      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1574      *
1575      * Emits a {Transfer} event.
1576      */
1577     function _safeTransfer(
1578         address from,
1579         address to,
1580         uint256 tokenId,
1581         bytes memory _data
1582     ) internal virtual {
1583         _transfer(from, to, tokenId);
1584         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1585     }
1586 
1587     /**
1588      * @dev Returns whether `tokenId` exists.
1589      *
1590      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1591      *
1592      * Tokens start existing when they are minted (`_mint`),
1593      * and stop existing when they are burned (`_burn`).
1594      */
1595     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1596         return _owners[tokenId] != address(0);
1597     }
1598 
1599     /**
1600      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1601      *
1602      * Requirements:
1603      *
1604      * - `tokenId` must exist.
1605      */
1606     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1607         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1608         address owner = ERC721.ownerOf(tokenId);
1609         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1610     }
1611 
1612     /**
1613      * @dev Safely mints `tokenId` and transfers it to `to`.
1614      *
1615      * Requirements:
1616      *
1617      * - `tokenId` must not exist.
1618      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1619      *
1620      * Emits a {Transfer} event.
1621      */
1622     function _safeMint(address to, uint256 tokenId) internal virtual {
1623         _safeMint(to, tokenId, "");
1624     }
1625 
1626     /**
1627      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1628      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1629      */
1630     function _safeMint(
1631         address to,
1632         uint256 tokenId,
1633         bytes memory _data
1634     ) internal virtual {
1635         _mint(to, tokenId);
1636         require(
1637             _checkOnERC721Received(address(0), to, tokenId, _data),
1638             "ERC721: transfer to non ERC721Receiver implementer"
1639         );
1640     }
1641 
1642     /**
1643      * @dev Mints `tokenId` and transfers it to `to`.
1644      *
1645      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1646      *
1647      * Requirements:
1648      *
1649      * - `tokenId` must not exist.
1650      * - `to` cannot be the zero address.
1651      *
1652      * Emits a {Transfer} event.
1653      */
1654     function _mint(address to, uint256 tokenId) internal virtual {
1655         require(to != address(0), "ERC721: mint to the zero address");
1656         require(!_exists(tokenId), "ERC721: token already minted");
1657 
1658         _beforeTokenTransfer(address(0), to, tokenId);
1659 
1660         _balances[to] += 1;
1661         _owners[tokenId] = to;
1662 
1663         emit Transfer(address(0), to, tokenId);
1664     }
1665 
1666     /**
1667      * @dev Destroys `tokenId`.
1668      * The approval is cleared when the token is burned.
1669      *
1670      * Requirements:
1671      *
1672      * - `tokenId` must exist.
1673      *
1674      * Emits a {Transfer} event.
1675      */
1676     function _burn(uint256 tokenId) internal virtual {
1677         address owner = ERC721.ownerOf(tokenId);
1678 
1679         _beforeTokenTransfer(owner, address(0), tokenId);
1680 
1681         // Clear approvals
1682         _approve(address(0), tokenId);
1683 
1684         _balances[owner] -= 1;
1685         delete _owners[tokenId];
1686 
1687         emit Transfer(owner, address(0), tokenId);
1688     }
1689 
1690     /**
1691      * @dev Transfers `tokenId` from `from` to `to`.
1692      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1693      *
1694      * Requirements:
1695      *
1696      * - `to` cannot be the zero address.
1697      * - `tokenId` token must be owned by `from`.
1698      *
1699      * Emits a {Transfer} event.
1700      */
1701     function _transfer(
1702         address from,
1703         address to,
1704         uint256 tokenId
1705     ) internal virtual {
1706         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1707         require(to != address(0), "ERC721: transfer to the zero address");
1708 
1709         _beforeTokenTransfer(from, to, tokenId);
1710 
1711         // Clear approvals from the previous owner
1712         _approve(address(0), tokenId);
1713 
1714         _balances[from] -= 1;
1715         _balances[to] += 1;
1716         _owners[tokenId] = to;
1717 
1718         emit Transfer(from, to, tokenId);
1719     }
1720 
1721     /**
1722      * @dev Approve `to` to operate on `tokenId`
1723      *
1724      * Emits a {Approval} event.
1725      */
1726     function _approve(address to, uint256 tokenId) internal virtual {
1727         _tokenApprovals[tokenId] = to;
1728         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1729     }
1730 
1731     /**
1732      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1733      * The call is not executed if the target address is not a contract.
1734      *
1735      * @param from address representing the previous owner of the given token ID
1736      * @param to target address that will receive the tokens
1737      * @param tokenId uint256 ID of the token to be transferred
1738      * @param _data bytes optional data to send along with the call
1739      * @return bool whether the call correctly returned the expected magic value
1740      */
1741     function _checkOnERC721Received(
1742         address from,
1743         address to,
1744         uint256 tokenId,
1745         bytes memory _data
1746     ) private returns (bool) {
1747         if (to.isContract()) {
1748             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1749                 return retval == IERC721Receiver.onERC721Received.selector;
1750             } catch (bytes memory reason) {
1751                 if (reason.length == 0) {
1752                     revert("ERC721: transfer to non ERC721Receiver implementer");
1753                 } else {
1754                     assembly {
1755                         revert(add(32, reason), mload(reason))
1756                     }
1757                 }
1758             }
1759         } else {
1760             return true;
1761         }
1762     }
1763 
1764     /**
1765      * @dev Hook that is called before any token transfer. This includes minting
1766      * and burning.
1767      *
1768      * Calling conditions:
1769      *
1770      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1771      * transferred to `to`.
1772      * - When `from` is zero, `tokenId` will be minted for `to`.
1773      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1774      * - `from` and `to` are never both zero.
1775      *
1776      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1777      */
1778     function _beforeTokenTransfer(
1779         address from,
1780         address to,
1781         uint256 tokenId
1782     ) internal virtual {}
1783 }
1784 
1785 // File: contracts/ERC721Tradable.sol
1786 
1787 
1788 
1789 pragma solidity ^0.8.0;
1790 
1791 
1792 
1793 
1794 
1795 
1796 
1797 
1798 contract OwnableDelegateProxy {}
1799 
1800 /**
1801  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
1802  */
1803 contract ProxyRegistry {
1804     mapping(address => OwnableDelegateProxy) public proxies;
1805 }
1806 
1807 /**
1808  * @title ERC721Tradable
1809  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
1810  */
1811 abstract contract ERC721Tradable is ERC721, ContextMixin, NativeMetaTransaction, Ownable {
1812     using SafeMath for uint256;
1813     using Counters for Counters.Counter;
1814 
1815     //We rely on the OZ Counter util to keep track of the next available ID.
1816     //We track the nextTokenId instead of the currentTokenId to save users on gas costs. 
1817     //Read more about it here: https://shiny.mirror.xyz/OUampBbIz9ebEicfGnQf5At_ReMHlZy0tB4glb9xQ0E
1818     //Lifestory: internal variable to make visible in derived contracts. 
1819     Counters.Counter internal _nextTokenId;
1820     address proxyRegistryAddress;
1821 
1822     constructor(
1823         string memory _name,
1824         string memory _symbol,
1825         address _proxyRegistryAddress
1826     ) ERC721(_name, _symbol) {
1827         proxyRegistryAddress = _proxyRegistryAddress;
1828         // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
1829         _nextTokenId.increment();
1830         _initializeEIP712(_name);
1831     }
1832 
1833     /**
1834      * @dev Mints a token to an address with a tokenURI.
1835      * @dev Lifestory: virtual function to be able to override 
1836      * @param _to address of the future owner of the token
1837      */
1838     function mintTo(address _to) public virtual onlyOwner {
1839         uint256 currentTokenId = _nextTokenId.current();
1840         _nextTokenId.increment();
1841         _safeMint(_to, currentTokenId);
1842     }
1843 
1844     /**
1845         @dev Returns the total tokens minted so far.
1846         1 is always subtracted from the Counter since it tracks the next available tokenId.
1847      */
1848     function totalSupply() public view returns (uint256) {
1849         return _nextTokenId.current() - 1;
1850     }
1851 
1852     /**
1853      * @dev Lifestory: set this methode to view to edit this after deploy
1854      * @dev Lifestory: need for revealing the planets
1855      */
1856     function baseTokenURI() virtual public view returns (string memory);
1857 
1858     /**
1859      * @dev Lifestory: set this methode to view to edit this after deploy
1860      * @dev Lifestory: need for revealing the planets
1861      */
1862     function tokenURI(uint256 _tokenId) override public view returns (string memory) {
1863         return string(abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId)));
1864     }
1865 
1866     /**
1867      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
1868      */
1869     function isApprovedForAll(address owner, address operator)
1870         override
1871         public
1872         view
1873         returns (bool)
1874     {
1875         // Whitelist OpenSea proxy contract for easy trading.
1876         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1877         if (address(proxyRegistry.proxies(owner)) == operator) {
1878             return true;
1879         }
1880 
1881         return super.isApprovedForAll(owner, operator);
1882     }
1883 
1884     /**
1885      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
1886      */
1887     function _msgSender()
1888         internal
1889         override
1890         view
1891         returns (address sender)
1892     {
1893         return ContextMixin.msgSender();
1894     }
1895 }
1896 // File: contracts/common/EIP2981/specs/IEIP2981.sol
1897 
1898 
1899 
1900 pragma solidity ^0.8.0;
1901 
1902 /**
1903  * EIP-2981
1904  */
1905 interface IEIP2981 {
1906     /**
1907      * bytes4(keccak256("royaltyInfo(uint256,uint256)")) == 0x2a55205a
1908      *
1909      * => 0x2a55205a = 0x2a55205a
1910      */
1911     function royaltyInfo(uint256 tokenId, uint256 value) external view returns (address, uint256);
1912 }
1913 // File: contracts/common/EIP2981/IERC721TradableWithRoyalty.sol
1914 
1915 
1916 
1917 pragma solidity ^0.8.0;
1918 
1919 /// @author: lifetimeapp.io && manifold.xyz
1920 
1921 /**
1922  * Simple EIP2981 reference override implementation
1923  */
1924 interface IEIP2981RoyaltyOverride  {
1925 
1926     function setTokenRoyalty(uint256 tokenId, address recipient, uint16 bps) external;
1927 
1928     function setDefaultRoyalty(address recipient, uint16 bps) external;
1929 
1930 }
1931 // File: contracts/ERC721TradableWithRoyalty.sol
1932 
1933 
1934 
1935 pragma solidity ^0.8.0;
1936 
1937 /// @author: manifold.xyz
1938 /// @author: Abderrahmane Bouali
1939 
1940 
1941 
1942 
1943 /**
1944  * Simple EIP2981 reference override implementation
1945  */
1946 abstract contract ERC721TradableWithRoyalty is IEIP2981, IEIP2981RoyaltyOverride, ERC721Tradable {
1947 
1948     event TokenRoyaltySet(uint256 tokenId, address recipient, uint16 bps);
1949     event DefaultRoyaltySet(address recipient, uint16 bps);
1950 
1951     struct TokenRoyalty {
1952         address recipient;
1953         uint16 bps;
1954     }
1955 
1956     TokenRoyalty public defaultRoyalty;
1957     mapping(uint256 => TokenRoyalty) private _tokenRoyalties;
1958 
1959     constructor(
1960         string memory _name,
1961         string memory _symbol,
1962         address _royaltyRecipient,
1963         uint16 _royaltyBPS,
1964         address _proxyRegistryOpenseaAddress
1965     )
1966         ERC721Tradable(
1967             _name,
1968             _symbol,
1969             _proxyRegistryOpenseaAddress
1970         )
1971     {
1972       defaultRoyalty = TokenRoyalty(_royaltyRecipient, _royaltyBPS);
1973     }
1974 
1975     function setTokenRoyalty(uint256 tokenId, address recipient, uint16 bps) public override onlyOwner {
1976         _tokenRoyalties[tokenId] = TokenRoyalty(recipient, bps);
1977         emit TokenRoyaltySet(tokenId, recipient, bps);
1978     }
1979 
1980     function setDefaultRoyalty(address recipient, uint16 bps) public override onlyOwner {
1981         defaultRoyalty = TokenRoyalty(recipient, bps);
1982         emit DefaultRoyaltySet(recipient, bps);
1983     }
1984     
1985     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721) returns (bool) {
1986         return interfaceId == type(IEIP2981).interfaceId || interfaceId == type(IEIP2981RoyaltyOverride).interfaceId || super.supportsInterface(interfaceId);
1987     }
1988 
1989     function royaltyInfo(uint256 tokenId, uint256 value) public override view returns (address, uint256) {
1990         if (_tokenRoyalties[tokenId].recipient != address(0)) {
1991             return (_tokenRoyalties[tokenId].recipient, value*_tokenRoyalties[tokenId].bps/10000);
1992         }
1993         if (defaultRoyalty.recipient != address(0) && defaultRoyalty.bps != 0) {
1994             return (defaultRoyalty.recipient, value*defaultRoyalty.bps/10000);
1995         }
1996         return (address(0), 0);
1997     }
1998 }
1999 // File: contracts/LifePlanetNFT.sol
2000 
2001 
2002 
2003 pragma solidity ^0.8.0;
2004 
2005 
2006 
2007 // @author: Abderrahmane Bouali for Lifestory
2008 
2009 /**
2010  * @title LifePlanetNFT
2011  * LifePlanetNFT - a contract for Life nft.
2012  */
2013 contract LifePlanetNFT is ERC721TradableWithRoyalty {
2014     using Counters for Counters.Counter;
2015     using ECDSA for bytes32;
2016 
2017     uint256 public cost = 0.27 ether; 
2018     uint256 public maxSupply = 5555;
2019     uint256 public maxOwnWhitelist = 2;
2020     uint256 public maxSupplyWhitelist = 200;
2021     uint256 public whitelistNumber = 0;
2022     mapping(uint256 => mapping(address => uint256)) public balanceWhitelist;
2023     
2024     string URIToken = "https://gateway.pinata.cloud/ipfs/QmU7EX2UTrgN8ykZdsYfmEeyHePgUSJwHJnwtwgzrvncY9?";
2025     string URIContract = "https://gateway.pinata.cloud/ipfs/Qme7ZBXFpJcjMSDTcFFQpYF9Y9jT7cN1yfpRaYF2UsPi4q";
2026 
2027     address payable private payments;
2028 
2029 
2030     // The key used to sign whitelist signatures.
2031     // We will check to ensure that the key that signed the signature
2032     // is the one that we expect.
2033     address public whitelistSigningKey = address(0xf11Ef1920a393A6d9C437B85e1c797be7F50A883);
2034 
2035     // The typehash for the data type specified in the structured data
2036     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-712.md#rationale-for-typehash
2037     bytes32 public constant MINTER_TYPEHASH =
2038         keccak256("Minter(address wallet)");
2039     
2040     // Event called when the cost changes
2041     event ChangedCost(uint256 _cost);
2042 
2043     /**
2044      * @dev Modifier to check if the sender is in the whitelist 
2045      * @param signature signature make by whitelistSigningKey
2046      */
2047     modifier requiresWhitelist(bytes calldata signature) {
2048         require(whitelistSigningKey != address(0), "LIFV: Whitelist not enabled");
2049         // Verify EIP-712 signature by recreating the data structure
2050         // that we signed on the client side, and then using that to recover
2051         // the address that signed the signature for this data.
2052         bytes32 digest = keccak256(
2053             abi.encodePacked(
2054                 "\x19\x01",
2055                 EIP712Base.getDomainSeperator(),
2056                 keccak256(abi.encode(MINTER_TYPEHASH, msg.sender))
2057             )
2058         );
2059         // Use the recover method to see what address was used to create
2060         // the signature on this data.
2061         // Note that if the digest doesn't exactly match what was signed we'll
2062         // get a random recovered address.
2063         address recoveredAddress = digest.recover(signature);
2064         require(recoveredAddress == whitelistSigningKey, "Invalid Signature");
2065         _;
2066     }
2067 
2068     /**
2069      * @dev constructor of LifePlanetNFT 
2070      * @param _proxyRegistryOpenseaAddress address of the proxy contract of opensea
2071      * @param _royaltyBPS RoyaltyBPS
2072      * @param _payments Lifestory address 
2073      */
2074     constructor(address _proxyRegistryOpenseaAddress, address _payments, uint16 _royaltyBPS)
2075         ERC721TradableWithRoyalty(
2076             "Lifestory Planets",
2077             "LIFV",
2078             _payments,
2079             _royaltyBPS,
2080             _proxyRegistryOpenseaAddress
2081         )
2082     {
2083         payments = payable(_payments);
2084     }
2085     
2086     /**
2087      * @dev function to edit the address to verifiy signature for the whitelist 
2088      * @param newSigningKey public address on the new signer
2089      */
2090     function setWhitelistSigningAddress(address newSigningKey) public onlyOwner {
2091         whitelistSigningKey = newSigningKey;
2092     }
2093 
2094     /**
2095      * @dev Function mint for whitelisted
2096      * @dev Use the requiresWhitelist modifier to reject the call if a valid signature is not provided 
2097      * @param signature signature of whitelistSigningKey
2098      * @param _mintAmount mint amount 
2099      */
2100     function mintForWhitelisted(bytes calldata signature, uint256 _mintAmount) public payable requiresWhitelist(signature) {
2101         require(ERC721Tradable.totalSupply() + _mintAmount <= maxSupply, "LIFV: maximum supply of tokens has been exceeded");
2102         require(msg.value >= cost * _mintAmount,"LIFV: The amount sent is too low.");
2103 
2104         require(balanceWhitelist[whitelistNumber][msg.sender] + _mintAmount <= maxOwnWhitelist , "LIFV: You exceeded the maximum amount of tokens allowed for this whitelist.");
2105         require(ERC721Tradable.totalSupply() + _mintAmount <= maxSupplyWhitelist , "LIFV: maximum supply of tokens has been exceeded for this whitelist.");
2106 
2107         /// @notice Safely mint the NFTs
2108         for (uint256 i = 0; i < _mintAmount; i++) {
2109             uint256 currentTokenId = _nextTokenId.current();
2110             _nextTokenId.increment();
2111             _safeMint(msg.sender, currentTokenId);
2112             balanceWhitelist[whitelistNumber][msg.sender]++;
2113         }
2114     }
2115 
2116     /**
2117      * @dev Function mint
2118      * @param _mintAmount mint amount
2119      */
2120     function mint(uint256 _mintAmount) public payable {
2121         require(ERC721Tradable.totalSupply() + _mintAmount <= maxSupply, "LIFV: maximum supply of tokens has been exceeded");
2122         require(msg.value >= cost * _mintAmount,"LIFV: the amount sent is too low.");
2123         require(whitelistSigningKey == address(0), "LIFV: whitelist enabled");
2124 
2125         /// @notice Safely mint the NFTs
2126         for (uint256 i = 0; i < _mintAmount; i++) {
2127             uint256 currentTokenId = _nextTokenId.current();
2128             _nextTokenId.increment();
2129             _safeMint(msg.sender, currentTokenId);
2130         }
2131     }
2132 
2133     /**
2134      * @dev Lifestory : Override function mintTo from Opensea contract ERC721Tradable.sol to avoid overtaking .
2135      * @dev Mints a token to an address with a tokenURI.
2136      * @param _to address of the future owner of the token
2137      */
2138     function mintTo(address _to) override public onlyOwner {
2139         require(ERC721Tradable.totalSupply() <= maxSupply, "LIFV: maximum supply of tokens has been exceeded");
2140         return ERC721Tradable.mintTo(_to);
2141     }
2142 
2143     /**
2144      * @dev Mints multiple tokens to an address with a tokenURI.
2145      * @dev Only the owner can run this function
2146      * @param _to address of the future owner of the token
2147      */
2148     function mintTo(address _to, uint256 _mintAmount) public onlyOwner {
2149         require(ERC721Tradable.totalSupply() + _mintAmount <= maxSupply, "LIFV: maximum supply of tokens has been exceeded");
2150         
2151         for (uint256 i = 0; i < _mintAmount; i++) {
2152             uint256 currentTokenId = _nextTokenId.current();
2153             _nextTokenId.increment();
2154             _safeMint(_to, currentTokenId);
2155         }
2156     }
2157     
2158     /// @notice Withdraw proceeds from contract address to LIFESTORY address
2159     function withdraw() public payable onlyOwner {
2160         require(payable(payments).send(address(this).balance));
2161     }
2162     
2163     /** @notice Reset mint balance for whitelist
2164      */
2165     function changeWhitelist() public onlyOwner {
2166        whitelistNumber++;
2167     }
2168 
2169     /** @notice Overload function to change whitelist with new cost, new maxSupplyWhitelist and new maxOwnWhitelist
2170      *  @param _newCost New cost per NFT in Wei
2171      *  @param _newMaxSupplyWhitelist New maximum supply value for whitelist
2172      *  @param _newMaxOwnWhitelist New maximum value to own
2173      */
2174     function changeWhitelist(uint256 _newCost, uint256 _newMaxSupplyWhitelist, uint256 _newMaxOwnWhitelist) public onlyOwner {
2175         cost = _newCost;
2176         maxSupplyWhitelist = _newMaxSupplyWhitelist;
2177         maxOwnWhitelist = _newMaxOwnWhitelist;
2178         changeWhitelist();
2179         emit ChangedCost(cost);
2180     }
2181 
2182     /** @notice Update the maximum supply when enabling next whitelist
2183      *  @param _newMaxSupplyWhitelist New maximum supply value for whitelist
2184      */
2185     function setMaxSupplyWhitelist(uint256 _newMaxSupplyWhitelist) public onlyOwner {
2186         maxSupplyWhitelist = _newMaxSupplyWhitelist;
2187     }
2188     
2189     /** @notice Update the maximum you can own when whitelist is enabled
2190      *  @param _newMaxOwnWhitelist New maximum value to own
2191      */
2192     function setMaxOwnWhitelist(uint256 _newMaxOwnWhitelist) public onlyOwner {
2193         maxOwnWhitelist = _newMaxOwnWhitelist;
2194     }
2195 
2196     /** @notice Update COST
2197      *  @param _newCost New cost per NFT in Wei
2198      */
2199     function setCost(uint256 _newCost) public onlyOwner {
2200         cost = _newCost;
2201         emit ChangedCost(cost);
2202     }
2203 
2204     /** @notice Update URIToken
2205      *  @param _newURIToken New URI for the metadatas of NFTs
2206      */
2207     function setURIToken(string memory _newURIToken) public onlyOwner {
2208         URIToken = _newURIToken;
2209     }
2210 
2211     /** @notice Update URIContract
2212      *  @param _newURIContract New URI for the metadata of the contract
2213      */
2214     function setURIContract(string memory _newURIContract) public onlyOwner {
2215         URIContract = _newURIContract;
2216     }
2217 
2218     /** @notice Update payments address
2219      *  @param _newPayments New address to receive the recipe 
2220      */
2221     function setPayments(address _newPayments) public onlyOwner {
2222         payments = payable(_newPayments);
2223     }
2224 
2225     /** @notice Get base token uri for metadatas
2226      */
2227     function baseTokenURI() override public view returns (string memory) {
2228         return URIToken;
2229     }
2230 
2231     /** @notice Get contract metadatas uri 
2232      */
2233     function contractURI() public view returns (string memory) {
2234         return URIContract;
2235     }
2236 }