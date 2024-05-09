1 //SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
4 
5 
6 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 // CAUTION
11 // This version of SafeMath should only be used with Solidity 0.8 or later,
12 // because it relies on the compiler's built in overflow checks.
13 
14 /**
15  * @dev Wrappers over Solidity's arithmetic operations.
16  *
17  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
18  * now has built in overflow checking.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         unchecked {
28             uint256 c = a + b;
29             if (c < a) return (false, 0);
30             return (true, c);
31         }
32     }
33 
34     /**
35      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
36      *
37      * _Available since v3.4._
38      */
39     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
40         unchecked {
41             if (b > a) return (false, 0);
42             return (true, a - b);
43         }
44     }
45 
46     /**
47      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
48      *
49      * _Available since v3.4._
50      */
51     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
52         unchecked {
53             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
54             // benefit is lost if 'b' is also tested.
55             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
56             if (a == 0) return (true, 0);
57             uint256 c = a * b;
58             if (c / a != b) return (false, 0);
59             return (true, c);
60         }
61     }
62 
63     /**
64      * @dev Returns the division of two unsigned integers, with a division by zero flag.
65      *
66      * _Available since v3.4._
67      */
68     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
69         unchecked {
70             if (b == 0) return (false, 0);
71             return (true, a / b);
72         }
73     }
74 
75     /**
76      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
77      *
78      * _Available since v3.4._
79      */
80     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
81         unchecked {
82             if (b == 0) return (false, 0);
83             return (true, a % b);
84         }
85     }
86 
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         return a + b;
99     }
100 
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      *
109      * - Subtraction cannot overflow.
110      */
111     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
112         return a - b;
113     }
114 
115     /**
116      * @dev Returns the multiplication of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `*` operator.
120      *
121      * Requirements:
122      *
123      * - Multiplication cannot overflow.
124      */
125     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
126         return a * b;
127     }
128 
129     /**
130      * @dev Returns the integer division of two unsigned integers, reverting on
131      * division by zero. The result is rounded towards zero.
132      *
133      * Counterpart to Solidity's `/` operator.
134      *
135      * Requirements:
136      *
137      * - The divisor cannot be zero.
138      */
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return a / b;
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * reverting when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      *
153      * - The divisor cannot be zero.
154      */
155     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(
173         uint256 a,
174         uint256 b,
175         string memory errorMessage
176     ) internal pure returns (uint256) {
177         unchecked {
178             require(b <= a, errorMessage);
179             return a - b;
180         }
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(
196         uint256 a,
197         uint256 b,
198         string memory errorMessage
199     ) internal pure returns (uint256) {
200         unchecked {
201             require(b > 0, errorMessage);
202             return a / b;
203         }
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * reverting with custom message when dividing by zero.
209      *
210      * CAUTION: This function is deprecated because it requires allocating memory for the error
211      * message unnecessarily. For custom revert reasons use {tryMod}.
212      *
213      * Counterpart to Solidity's `%` operator. This function uses a `revert`
214      * opcode (which leaves remaining gas untouched) while Solidity uses an
215      * invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function mod(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         unchecked {
227             require(b > 0, errorMessage);
228             return a % b;
229         }
230     }
231 }
232 
233 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
234 
235 
236 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
237 
238 pragma solidity ^0.8.0;
239 
240 /**
241  * @dev Interface of the ERC165 standard, as defined in the
242  * https://eips.ethereum.org/EIPS/eip-165[EIP].
243  *
244  * Implementers can declare support of contract interfaces, which can then be
245  * queried by others ({ERC165Checker}).
246  *
247  * For an implementation, see {ERC165}.
248  */
249 interface IERC165 {
250     /**
251      * @dev Returns true if this contract implements the interface defined by
252      * `interfaceId`. See the corresponding
253      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
254      * to learn more about how these ids are created.
255      *
256      * This function call must use less than 30 000 gas.
257      */
258     function supportsInterface(bytes4 interfaceId) external view returns (bool);
259 }
260 
261 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
262 
263 
264 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
265 
266 pragma solidity ^0.8.0;
267 
268 
269 /**
270  * @dev Implementation of the {IERC165} interface.
271  *
272  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
273  * for the additional interface id that will be supported. For example:
274  *
275  * ```solidity
276  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
277  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
278  * }
279  * ```
280  *
281  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
282  */
283 abstract contract ERC165 is IERC165 {
284     /**
285      * @dev See {IERC165-supportsInterface}.
286      */
287     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
288         return interfaceId == type(IERC165).interfaceId;
289     }
290 }
291 
292 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
293 
294 
295 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 
300 /**
301  * @dev Interface for the NFT Royalty Standard.
302  *
303  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
304  * support for royalty payments across all NFT marketplaces and ecosystem participants.
305  *
306  * _Available since v4.5._
307  */
308 interface IERC2981 is IERC165 {
309     /**
310      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
311      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
312      */
313     function royaltyInfo(uint256 tokenId, uint256 salePrice)
314         external
315         view
316         returns (address receiver, uint256 royaltyAmount);
317 }
318 
319 // File: @openzeppelin/contracts/token/common/ERC2981.sol
320 
321 
322 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
323 
324 pragma solidity ^0.8.0;
325 
326 
327 
328 /**
329  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
330  *
331  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
332  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
333  *
334  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
335  * fee is specified in basis points by default.
336  *
337  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
338  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
339  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
340  *
341  * _Available since v4.5._
342  */
343 abstract contract ERC2981 is IERC2981, ERC165 {
344     struct RoyaltyInfo {
345         address receiver;
346         uint96 royaltyFraction;
347     }
348 
349     RoyaltyInfo private _defaultRoyaltyInfo;
350     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
351 
352     /**
353      * @dev See {IERC165-supportsInterface}.
354      */
355     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
356         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
357     }
358 
359     /**
360      * @inheritdoc IERC2981
361      */
362     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
363         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
364 
365         if (royalty.receiver == address(0)) {
366             royalty = _defaultRoyaltyInfo;
367         }
368 
369         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
370 
371         return (royalty.receiver, royaltyAmount);
372     }
373 
374     /**
375      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
376      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
377      * override.
378      */
379     function _feeDenominator() internal pure virtual returns (uint96) {
380         return 10000;
381     }
382 
383     /**
384      * @dev Sets the royalty information that all ids in this contract will default to.
385      *
386      * Requirements:
387      *
388      * - `receiver` cannot be the zero address.
389      * - `feeNumerator` cannot be greater than the fee denominator.
390      */
391     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
392         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
393         require(receiver != address(0), "ERC2981: invalid receiver");
394 
395         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
396     }
397 
398     /**
399      * @dev Removes default royalty information.
400      */
401     function _deleteDefaultRoyalty() internal virtual {
402         delete _defaultRoyaltyInfo;
403     }
404 
405     /**
406      * @dev Sets the royalty information for a specific token id, overriding the global default.
407      *
408      * Requirements:
409      *
410      * - `receiver` cannot be the zero address.
411      * - `feeNumerator` cannot be greater than the fee denominator.
412      */
413     function _setTokenRoyalty(
414         uint256 tokenId,
415         address receiver,
416         uint96 feeNumerator
417     ) internal virtual {
418         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
419         require(receiver != address(0), "ERC2981: Invalid parameters");
420 
421         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
422     }
423 
424     /**
425      * @dev Resets royalty information for the token id back to the global default.
426      */
427     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
428         delete _tokenRoyaltyInfo[tokenId];
429     }
430 }
431 
432 // File: @openzeppelin/contracts/utils/Strings.sol
433 
434 
435 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
436 
437 pragma solidity ^0.8.0;
438 
439 /**
440  * @dev String operations.
441  */
442 library Strings {
443     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
444     uint8 private constant _ADDRESS_LENGTH = 20;
445 
446     /**
447      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
448      */
449     function toString(uint256 value) internal pure returns (string memory) {
450         // Inspired by OraclizeAPI's implementation - MIT licence
451         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
452 
453         if (value == 0) {
454             return "0";
455         }
456         uint256 temp = value;
457         uint256 digits;
458         while (temp != 0) {
459             digits++;
460             temp /= 10;
461         }
462         bytes memory buffer = new bytes(digits);
463         while (value != 0) {
464             digits -= 1;
465             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
466             value /= 10;
467         }
468         return string(buffer);
469     }
470 
471     /**
472      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
473      */
474     function toHexString(uint256 value) internal pure returns (string memory) {
475         if (value == 0) {
476             return "0x00";
477         }
478         uint256 temp = value;
479         uint256 length = 0;
480         while (temp != 0) {
481             length++;
482             temp >>= 8;
483         }
484         return toHexString(value, length);
485     }
486 
487     /**
488      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
489      */
490     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
491         bytes memory buffer = new bytes(2 * length + 2);
492         buffer[0] = "0";
493         buffer[1] = "x";
494         for (uint256 i = 2 * length + 1; i > 1; --i) {
495             buffer[i] = _HEX_SYMBOLS[value & 0xf];
496             value >>= 4;
497         }
498         require(value == 0, "Strings: hex length insufficient");
499         return string(buffer);
500     }
501 
502     /**
503      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
504      */
505     function toHexString(address addr) internal pure returns (string memory) {
506         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
507     }
508 }
509 
510 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
511 
512 
513 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
514 
515 pragma solidity ^0.8.0;
516 
517 
518 /**
519  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
520  *
521  * These functions can be used to verify that a message was signed by the holder
522  * of the private keys of a given address.
523  */
524 library ECDSA {
525     enum RecoverError {
526         NoError,
527         InvalidSignature,
528         InvalidSignatureLength,
529         InvalidSignatureS,
530         InvalidSignatureV
531     }
532 
533     function _throwError(RecoverError error) private pure {
534         if (error == RecoverError.NoError) {
535             return; // no error: do nothing
536         } else if (error == RecoverError.InvalidSignature) {
537             revert("ECDSA: invalid signature");
538         } else if (error == RecoverError.InvalidSignatureLength) {
539             revert("ECDSA: invalid signature length");
540         } else if (error == RecoverError.InvalidSignatureS) {
541             revert("ECDSA: invalid signature 's' value");
542         } else if (error == RecoverError.InvalidSignatureV) {
543             revert("ECDSA: invalid signature 'v' value");
544         }
545     }
546 
547     /**
548      * @dev Returns the address that signed a hashed message (`hash`) with
549      * `signature` or error string. This address can then be used for verification purposes.
550      *
551      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
552      * this function rejects them by requiring the `s` value to be in the lower
553      * half order, and the `v` value to be either 27 or 28.
554      *
555      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
556      * verification to be secure: it is possible to craft signatures that
557      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
558      * this is by receiving a hash of the original message (which may otherwise
559      * be too long), and then calling {toEthSignedMessageHash} on it.
560      *
561      * Documentation for signature generation:
562      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
563      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
564      *
565      * _Available since v4.3._
566      */
567     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
568         if (signature.length == 65) {
569             bytes32 r;
570             bytes32 s;
571             uint8 v;
572             // ecrecover takes the signature parameters, and the only way to get them
573             // currently is to use assembly.
574             /// @solidity memory-safe-assembly
575             assembly {
576                 r := mload(add(signature, 0x20))
577                 s := mload(add(signature, 0x40))
578                 v := byte(0, mload(add(signature, 0x60)))
579             }
580             return tryRecover(hash, v, r, s);
581         } else {
582             return (address(0), RecoverError.InvalidSignatureLength);
583         }
584     }
585 
586     /**
587      * @dev Returns the address that signed a hashed message (`hash`) with
588      * `signature`. This address can then be used for verification purposes.
589      *
590      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
591      * this function rejects them by requiring the `s` value to be in the lower
592      * half order, and the `v` value to be either 27 or 28.
593      *
594      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
595      * verification to be secure: it is possible to craft signatures that
596      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
597      * this is by receiving a hash of the original message (which may otherwise
598      * be too long), and then calling {toEthSignedMessageHash} on it.
599      */
600     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
601         (address recovered, RecoverError error) = tryRecover(hash, signature);
602         _throwError(error);
603         return recovered;
604     }
605 
606     /**
607      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
608      *
609      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
610      *
611      * _Available since v4.3._
612      */
613     function tryRecover(
614         bytes32 hash,
615         bytes32 r,
616         bytes32 vs
617     ) internal pure returns (address, RecoverError) {
618         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
619         uint8 v = uint8((uint256(vs) >> 255) + 27);
620         return tryRecover(hash, v, r, s);
621     }
622 
623     /**
624      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
625      *
626      * _Available since v4.2._
627      */
628     function recover(
629         bytes32 hash,
630         bytes32 r,
631         bytes32 vs
632     ) internal pure returns (address) {
633         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
634         _throwError(error);
635         return recovered;
636     }
637 
638     /**
639      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
640      * `r` and `s` signature fields separately.
641      *
642      * _Available since v4.3._
643      */
644     function tryRecover(
645         bytes32 hash,
646         uint8 v,
647         bytes32 r,
648         bytes32 s
649     ) internal pure returns (address, RecoverError) {
650         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
651         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
652         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
653         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
654         //
655         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
656         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
657         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
658         // these malleable signatures as well.
659         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
660             return (address(0), RecoverError.InvalidSignatureS);
661         }
662         if (v != 27 && v != 28) {
663             return (address(0), RecoverError.InvalidSignatureV);
664         }
665 
666         // If the signature is valid (and not malleable), return the signer address
667         address signer = ecrecover(hash, v, r, s);
668         if (signer == address(0)) {
669             return (address(0), RecoverError.InvalidSignature);
670         }
671 
672         return (signer, RecoverError.NoError);
673     }
674 
675     /**
676      * @dev Overload of {ECDSA-recover} that receives the `v`,
677      * `r` and `s` signature fields separately.
678      */
679     function recover(
680         bytes32 hash,
681         uint8 v,
682         bytes32 r,
683         bytes32 s
684     ) internal pure returns (address) {
685         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
686         _throwError(error);
687         return recovered;
688     }
689 
690     /**
691      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
692      * produces hash corresponding to the one signed with the
693      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
694      * JSON-RPC method as part of EIP-191.
695      *
696      * See {recover}.
697      */
698     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
699         // 32 is the length in bytes of hash,
700         // enforced by the type signature above
701         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
702     }
703 
704     /**
705      * @dev Returns an Ethereum Signed Message, created from `s`. This
706      * produces hash corresponding to the one signed with the
707      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
708      * JSON-RPC method as part of EIP-191.
709      *
710      * See {recover}.
711      */
712     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
713         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
714     }
715 
716     /**
717      * @dev Returns an Ethereum Signed Typed Data, created from a
718      * `domainSeparator` and a `structHash`. This produces hash corresponding
719      * to the one signed with the
720      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
721      * JSON-RPC method as part of EIP-712.
722      *
723      * See {recover}.
724      */
725     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
726         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
727     }
728 }
729 
730 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
731 
732 
733 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
734 
735 pragma solidity ^0.8.0;
736 
737 /**
738  * @dev Contract module that helps prevent reentrant calls to a function.
739  *
740  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
741  * available, which can be applied to functions to make sure there are no nested
742  * (reentrant) calls to them.
743  *
744  * Note that because there is a single `nonReentrant` guard, functions marked as
745  * `nonReentrant` may not call one another. This can be worked around by making
746  * those functions `private`, and then adding `external` `nonReentrant` entry
747  * points to them.
748  *
749  * TIP: If you would like to learn more about reentrancy and alternative ways
750  * to protect against it, check out our blog post
751  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
752  */
753 abstract contract ReentrancyGuard {
754     // Booleans are more expensive than uint256 or any type that takes up a full
755     // word because each write operation emits an extra SLOAD to first read the
756     // slot's contents, replace the bits taken up by the boolean, and then write
757     // back. This is the compiler's defense against contract upgrades and
758     // pointer aliasing, and it cannot be disabled.
759 
760     // The values being non-zero value makes deployment a bit more expensive,
761     // but in exchange the refund on every call to nonReentrant will be lower in
762     // amount. Since refunds are capped to a percentage of the total
763     // transaction's gas, it is best to keep them low in cases like this one, to
764     // increase the likelihood of the full refund coming into effect.
765     uint256 private constant _NOT_ENTERED = 1;
766     uint256 private constant _ENTERED = 2;
767 
768     uint256 private _status;
769 
770     constructor() {
771         _status = _NOT_ENTERED;
772     }
773 
774     /**
775      * @dev Prevents a contract from calling itself, directly or indirectly.
776      * Calling a `nonReentrant` function from another `nonReentrant`
777      * function is not supported. It is possible to prevent this from happening
778      * by making the `nonReentrant` function external, and making it call a
779      * `private` function that does the actual work.
780      */
781     modifier nonReentrant() {
782         // On the first call to nonReentrant, _notEntered will be true
783         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
784 
785         // Any calls to nonReentrant after this point will fail
786         _status = _ENTERED;
787 
788         _;
789 
790         // By storing the original value once again, a refund is triggered (see
791         // https://eips.ethereum.org/EIPS/eip-2200)
792         _status = _NOT_ENTERED;
793     }
794 }
795 
796 // File: @openzeppelin/contracts/utils/Context.sol
797 
798 
799 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
800 
801 pragma solidity ^0.8.0;
802 
803 /**
804  * @dev Provides information about the current execution context, including the
805  * sender of the transaction and its data. While these are generally available
806  * via msg.sender and msg.data, they should not be accessed in such a direct
807  * manner, since when dealing with meta-transactions the account sending and
808  * paying for execution may not be the actual sender (as far as an application
809  * is concerned).
810  *
811  * This contract is only required for intermediate, library-like contracts.
812  */
813 abstract contract Context {
814     function _msgSender() internal view virtual returns (address) {
815         return msg.sender;
816     }
817 
818     function _msgData() internal view virtual returns (bytes calldata) {
819         return msg.data;
820     }
821 }
822 
823 // File: @openzeppelin/contracts/access/Ownable.sol
824 
825 
826 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
827 
828 pragma solidity ^0.8.0;
829 
830 
831 /**
832  * @dev Contract module which provides a basic access control mechanism, where
833  * there is an account (an owner) that can be granted exclusive access to
834  * specific functions.
835  *
836  * By default, the owner account will be the one that deploys the contract. This
837  * can later be changed with {transferOwnership}.
838  *
839  * This module is used through inheritance. It will make available the modifier
840  * `onlyOwner`, which can be applied to your functions to restrict their use to
841  * the owner.
842  */
843 abstract contract Ownable is Context {
844     address private _owner;
845 
846     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
847 
848     /**
849      * @dev Initializes the contract setting the deployer as the initial owner.
850      */
851     constructor() {
852         _transferOwnership(_msgSender());
853     }
854 
855     /**
856      * @dev Throws if called by any account other than the owner.
857      */
858     modifier onlyOwner() {
859         _checkOwner();
860         _;
861     }
862 
863     /**
864      * @dev Returns the address of the current owner.
865      */
866     function owner() public view virtual returns (address) {
867         return _owner;
868     }
869 
870     /**
871      * @dev Throws if the sender is not the owner.
872      */
873     function _checkOwner() internal view virtual {
874         require(owner() == _msgSender(), "Ownable: caller is not the owner");
875     }
876 
877     /**
878      * @dev Leaves the contract without owner. It will not be possible to call
879      * `onlyOwner` functions anymore. Can only be called by the current owner.
880      *
881      * NOTE: Renouncing ownership will leave the contract without an owner,
882      * thereby removing any functionality that is only available to the owner.
883      */
884     function renounceOwnership() public virtual onlyOwner {
885         _transferOwnership(address(0));
886     }
887 
888     /**
889      * @dev Transfers ownership of the contract to a new account (`newOwner`).
890      * Can only be called by the current owner.
891      */
892     function transferOwnership(address newOwner) public virtual onlyOwner {
893         require(newOwner != address(0), "Ownable: new owner is the zero address");
894         _transferOwnership(newOwner);
895     }
896 
897     /**
898      * @dev Transfers ownership of the contract to a new account (`newOwner`).
899      * Internal function without access restriction.
900      */
901     function _transferOwnership(address newOwner) internal virtual {
902         address oldOwner = _owner;
903         _owner = newOwner;
904         emit OwnershipTransferred(oldOwner, newOwner);
905     }
906 }
907 
908 // File: erc721a/contracts/IERC721A.sol
909 
910 
911 // ERC721A Contracts v4.2.3
912 // Creator: Chiru Labs
913 
914 pragma solidity ^0.8.4;
915 
916 /**
917  * @dev Interface of ERC721A.
918  */
919 interface IERC721A {
920     /**
921      * The caller must own the token or be an approved operator.
922      */
923     error ApprovalCallerNotOwnerNorApproved();
924 
925     /**
926      * The token does not exist.
927      */
928     error ApprovalQueryForNonexistentToken();
929 
930     /**
931      * Cannot query the balance for the zero address.
932      */
933     error BalanceQueryForZeroAddress();
934 
935     /**
936      * Cannot mint to the zero address.
937      */
938     error MintToZeroAddress();
939 
940     /**
941      * The quantity of tokens minted must be more than zero.
942      */
943     error MintZeroQuantity();
944 
945     /**
946      * The token does not exist.
947      */
948     error OwnerQueryForNonexistentToken();
949 
950     /**
951      * The caller must own the token or be an approved operator.
952      */
953     error TransferCallerNotOwnerNorApproved();
954 
955     /**
956      * The token must be owned by `from`.
957      */
958     error TransferFromIncorrectOwner();
959 
960     /**
961      * Cannot safely transfer to a contract that does not implement the
962      * ERC721Receiver interface.
963      */
964     error TransferToNonERC721ReceiverImplementer();
965 
966     /**
967      * Cannot transfer to the zero address.
968      */
969     error TransferToZeroAddress();
970 
971     /**
972      * The token does not exist.
973      */
974     error URIQueryForNonexistentToken();
975 
976     /**
977      * The `quantity` minted with ERC2309 exceeds the safety limit.
978      */
979     error MintERC2309QuantityExceedsLimit();
980 
981     /**
982      * The `extraData` cannot be set on an unintialized ownership slot.
983      */
984     error OwnershipNotInitializedForExtraData();
985 
986     // =============================================================
987     //                            STRUCTS
988     // =============================================================
989 
990     struct TokenOwnership {
991         // The address of the owner.
992         address addr;
993         // Stores the start time of ownership with minimal overhead for tokenomics.
994         uint64 startTimestamp;
995         // Whether the token has been burned.
996         bool burned;
997         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
998         uint24 extraData;
999     }
1000 
1001     // =============================================================
1002     //                         TOKEN COUNTERS
1003     // =============================================================
1004 
1005     /**
1006      * @dev Returns the total number of tokens in existence.
1007      * Burned tokens will reduce the count.
1008      * To get the total number of tokens minted, please see {_totalMinted}.
1009      */
1010     function totalSupply() external view returns (uint256);
1011 
1012     // =============================================================
1013     //                            IERC165
1014     // =============================================================
1015 
1016     /**
1017      * @dev Returns true if this contract implements the interface defined by
1018      * `interfaceId`. See the corresponding
1019      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1020      * to learn more about how these ids are created.
1021      *
1022      * This function call must use less than 30000 gas.
1023      */
1024     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1025 
1026     // =============================================================
1027     //                            IERC721
1028     // =============================================================
1029 
1030     /**
1031      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1032      */
1033     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1034 
1035     /**
1036      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1037      */
1038     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1039 
1040     /**
1041      * @dev Emitted when `owner` enables or disables
1042      * (`approved`) `operator` to manage all of its assets.
1043      */
1044     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1045 
1046     /**
1047      * @dev Returns the number of tokens in `owner`'s account.
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
1061      * @dev Safely transfers `tokenId` token from `from` to `to`,
1062      * checking first that contract recipients are aware of the ERC721 protocol
1063      * to prevent tokens from being forever locked.
1064      *
1065      * Requirements:
1066      *
1067      * - `from` cannot be the zero address.
1068      * - `to` cannot be the zero address.
1069      * - `tokenId` token must exist and be owned by `from`.
1070      * - If the caller is not `from`, it must be have been allowed to move
1071      * this token by either {approve} or {setApprovalForAll}.
1072      * - If `to` refers to a smart contract, it must implement
1073      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1074      *
1075      * Emits a {Transfer} event.
1076      */
1077     function safeTransferFrom(
1078         address from,
1079         address to,
1080         uint256 tokenId,
1081         bytes calldata data
1082     ) external payable;
1083 
1084     /**
1085      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1086      */
1087     function safeTransferFrom(
1088         address from,
1089         address to,
1090         uint256 tokenId
1091     ) external payable;
1092 
1093     /**
1094      * @dev Transfers `tokenId` from `from` to `to`.
1095      *
1096      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1097      * whenever possible.
1098      *
1099      * Requirements:
1100      *
1101      * - `from` cannot be the zero address.
1102      * - `to` cannot be the zero address.
1103      * - `tokenId` token must be owned by `from`.
1104      * - If the caller is not `from`, it must be approved to move this token
1105      * by either {approve} or {setApprovalForAll}.
1106      *
1107      * Emits a {Transfer} event.
1108      */
1109     function transferFrom(
1110         address from,
1111         address to,
1112         uint256 tokenId
1113     ) external payable;
1114 
1115     /**
1116      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1117      * The approval is cleared when the token is transferred.
1118      *
1119      * Only a single account can be approved at a time, so approving the
1120      * zero address clears previous approvals.
1121      *
1122      * Requirements:
1123      *
1124      * - The caller must own the token or be an approved operator.
1125      * - `tokenId` must exist.
1126      *
1127      * Emits an {Approval} event.
1128      */
1129     function approve(address to, uint256 tokenId) external payable;
1130 
1131     /**
1132      * @dev Approve or remove `operator` as an operator for the caller.
1133      * Operators can call {transferFrom} or {safeTransferFrom}
1134      * for any token owned by the caller.
1135      *
1136      * Requirements:
1137      *
1138      * - The `operator` cannot be the caller.
1139      *
1140      * Emits an {ApprovalForAll} event.
1141      */
1142     function setApprovalForAll(address operator, bool _approved) external;
1143 
1144     /**
1145      * @dev Returns the account approved for `tokenId` token.
1146      *
1147      * Requirements:
1148      *
1149      * - `tokenId` must exist.
1150      */
1151     function getApproved(uint256 tokenId) external view returns (address operator);
1152 
1153     /**
1154      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1155      *
1156      * See {setApprovalForAll}.
1157      */
1158     function isApprovedForAll(address owner, address operator) external view returns (bool);
1159 
1160     // =============================================================
1161     //                        IERC721Metadata
1162     // =============================================================
1163 
1164     /**
1165      * @dev Returns the token collection name.
1166      */
1167     function name() external view returns (string memory);
1168 
1169     /**
1170      * @dev Returns the token collection symbol.
1171      */
1172     function symbol() external view returns (string memory);
1173 
1174     /**
1175      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1176      */
1177     function tokenURI(uint256 tokenId) external view returns (string memory);
1178 
1179     // =============================================================
1180     //                           IERC2309
1181     // =============================================================
1182 
1183     /**
1184      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1185      * (inclusive) is transferred from `from` to `to`, as defined in the
1186      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1187      *
1188      * See {_mintERC2309} for more details.
1189      */
1190     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1191 }
1192 
1193 // File: erc721a/contracts/ERC721A.sol
1194 
1195 
1196 // ERC721A Contracts v4.2.3
1197 // Creator: Chiru Labs
1198 
1199 pragma solidity ^0.8.4;
1200 
1201 
1202 /**
1203  * @dev Interface of ERC721 token receiver.
1204  */
1205 interface ERC721A__IERC721Receiver {
1206     function onERC721Received(
1207         address operator,
1208         address from,
1209         uint256 tokenId,
1210         bytes calldata data
1211     ) external returns (bytes4);
1212 }
1213 
1214 /**
1215  * @title ERC721A
1216  *
1217  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1218  * Non-Fungible Token Standard, including the Metadata extension.
1219  * Optimized for lower gas during batch mints.
1220  *
1221  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1222  * starting from `_startTokenId()`.
1223  *
1224  * Assumptions:
1225  *
1226  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1227  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1228  */
1229 contract ERC721A is IERC721A {
1230     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1231     struct TokenApprovalRef {
1232         address value;
1233     }
1234 
1235     // =============================================================
1236     //                           CONSTANTS
1237     // =============================================================
1238 
1239     // Mask of an entry in packed address data.
1240     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1241 
1242     // The bit position of `numberMinted` in packed address data.
1243     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1244 
1245     // The bit position of `numberBurned` in packed address data.
1246     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1247 
1248     // The bit position of `aux` in packed address data.
1249     uint256 private constant _BITPOS_AUX = 192;
1250 
1251     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1252     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1253 
1254     // The bit position of `startTimestamp` in packed ownership.
1255     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1256 
1257     // The bit mask of the `burned` bit in packed ownership.
1258     uint256 private constant _BITMASK_BURNED = 1 << 224;
1259 
1260     // The bit position of the `nextInitialized` bit in packed ownership.
1261     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1262 
1263     // The bit mask of the `nextInitialized` bit in packed ownership.
1264     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1265 
1266     // The bit position of `extraData` in packed ownership.
1267     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1268 
1269     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1270     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1271 
1272     // The mask of the lower 160 bits for addresses.
1273     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1274 
1275     // The maximum `quantity` that can be minted with {_mintERC2309}.
1276     // This limit is to prevent overflows on the address data entries.
1277     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1278     // is required to cause an overflow, which is unrealistic.
1279     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1280 
1281     // The `Transfer` event signature is given by:
1282     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1283     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1284         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1285 
1286     // =============================================================
1287     //                            STORAGE
1288     // =============================================================
1289 
1290     // The next token ID to be minted.
1291     uint256 private _currentIndex;
1292 
1293     // The number of tokens burned.
1294     uint256 private _burnCounter;
1295 
1296     // Token name
1297     string private _name;
1298 
1299     // Token symbol
1300     string private _symbol;
1301 
1302     // Mapping from token ID to ownership details
1303     // An empty struct value does not necessarily mean the token is unowned.
1304     // See {_packedOwnershipOf} implementation for details.
1305     //
1306     // Bits Layout:
1307     // - [0..159]   `addr`
1308     // - [160..223] `startTimestamp`
1309     // - [224]      `burned`
1310     // - [225]      `nextInitialized`
1311     // - [232..255] `extraData`
1312     mapping(uint256 => uint256) private _packedOwnerships;
1313 
1314     // Mapping owner address to address data.
1315     //
1316     // Bits Layout:
1317     // - [0..63]    `balance`
1318     // - [64..127]  `numberMinted`
1319     // - [128..191] `numberBurned`
1320     // - [192..255] `aux`
1321     mapping(address => uint256) private _packedAddressData;
1322 
1323     // Mapping from token ID to approved address.
1324     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1325 
1326     // Mapping from owner to operator approvals
1327     mapping(address => mapping(address => bool)) private _operatorApprovals;
1328 
1329     // =============================================================
1330     //                          CONSTRUCTOR
1331     // =============================================================
1332 
1333     constructor(string memory name_, string memory symbol_) {
1334         _name = name_;
1335         _symbol = symbol_;
1336         _currentIndex = _startTokenId();
1337     }
1338 
1339     // =============================================================
1340     //                   TOKEN COUNTING OPERATIONS
1341     // =============================================================
1342 
1343     /**
1344      * @dev Returns the starting token ID.
1345      * To change the starting token ID, please override this function.
1346      */
1347     function _startTokenId() internal view virtual returns (uint256) {
1348         return 0;
1349     }
1350 
1351     /**
1352      * @dev Returns the next token ID to be minted.
1353      */
1354     function _nextTokenId() internal view virtual returns (uint256) {
1355         return _currentIndex;
1356     }
1357 
1358     /**
1359      * @dev Returns the total number of tokens in existence.
1360      * Burned tokens will reduce the count.
1361      * To get the total number of tokens minted, please see {_totalMinted}.
1362      */
1363     function totalSupply() public view virtual override returns (uint256) {
1364         // Counter underflow is impossible as _burnCounter cannot be incremented
1365         // more than `_currentIndex - _startTokenId()` times.
1366         unchecked {
1367             return _currentIndex - _burnCounter - _startTokenId();
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the total amount of tokens minted in the contract.
1373      */
1374     function _totalMinted() internal view virtual returns (uint256) {
1375         // Counter underflow is impossible as `_currentIndex` does not decrement,
1376         // and it is initialized to `_startTokenId()`.
1377         unchecked {
1378             return _currentIndex - _startTokenId();
1379         }
1380     }
1381 
1382     /**
1383      * @dev Returns the total number of tokens burned.
1384      */
1385     function _totalBurned() internal view virtual returns (uint256) {
1386         return _burnCounter;
1387     }
1388 
1389     // =============================================================
1390     //                    ADDRESS DATA OPERATIONS
1391     // =============================================================
1392 
1393     /**
1394      * @dev Returns the number of tokens in `owner`'s account.
1395      */
1396     function balanceOf(address owner) public view virtual override returns (uint256) {
1397         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1398         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1399     }
1400 
1401     /**
1402      * Returns the number of tokens minted by `owner`.
1403      */
1404     function _numberMinted(address owner) internal view returns (uint256) {
1405         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1406     }
1407 
1408     /**
1409      * Returns the number of tokens burned by or on behalf of `owner`.
1410      */
1411     function _numberBurned(address owner) internal view returns (uint256) {
1412         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1413     }
1414 
1415     /**
1416      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1417      */
1418     function _getAux(address owner) internal view returns (uint64) {
1419         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1420     }
1421 
1422     /**
1423      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1424      * If there are multiple variables, please pack them into a uint64.
1425      */
1426     function _setAux(address owner, uint64 aux) internal virtual {
1427         uint256 packed = _packedAddressData[owner];
1428         uint256 auxCasted;
1429         // Cast `aux` with assembly to avoid redundant masking.
1430         assembly {
1431             auxCasted := aux
1432         }
1433         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1434         _packedAddressData[owner] = packed;
1435     }
1436 
1437     // =============================================================
1438     //                            IERC165
1439     // =============================================================
1440 
1441     /**
1442      * @dev Returns true if this contract implements the interface defined by
1443      * `interfaceId`. See the corresponding
1444      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1445      * to learn more about how these ids are created.
1446      *
1447      * This function call must use less than 30000 gas.
1448      */
1449     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1450         // The interface IDs are constants representing the first 4 bytes
1451         // of the XOR of all function selectors in the interface.
1452         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1453         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1454         return
1455             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1456             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1457             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1458     }
1459 
1460     // =============================================================
1461     //                        IERC721Metadata
1462     // =============================================================
1463 
1464     /**
1465      * @dev Returns the token collection name.
1466      */
1467     function name() public view virtual override returns (string memory) {
1468         return _name;
1469     }
1470 
1471     /**
1472      * @dev Returns the token collection symbol.
1473      */
1474     function symbol() public view virtual override returns (string memory) {
1475         return _symbol;
1476     }
1477 
1478     /**
1479      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1480      */
1481     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1482         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1483 
1484         string memory baseURI = _baseURI();
1485         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1486     }
1487 
1488     /**
1489      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1490      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1491      * by default, it can be overridden in child contracts.
1492      */
1493     function _baseURI() internal view virtual returns (string memory) {
1494         return '';
1495     }
1496 
1497     // =============================================================
1498     //                     OWNERSHIPS OPERATIONS
1499     // =============================================================
1500 
1501     /**
1502      * @dev Returns the owner of the `tokenId` token.
1503      *
1504      * Requirements:
1505      *
1506      * - `tokenId` must exist.
1507      */
1508     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1509         return address(uint160(_packedOwnershipOf(tokenId)));
1510     }
1511 
1512     /**
1513      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1514      * It gradually moves to O(1) as tokens get transferred around over time.
1515      */
1516     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1517         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1518     }
1519 
1520     /**
1521      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1522      */
1523     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1524         return _unpackedOwnership(_packedOwnerships[index]);
1525     }
1526 
1527     /**
1528      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1529      */
1530     function _initializeOwnershipAt(uint256 index) internal virtual {
1531         if (_packedOwnerships[index] == 0) {
1532             _packedOwnerships[index] = _packedOwnershipOf(index);
1533         }
1534     }
1535 
1536     /**
1537      * Returns the packed ownership data of `tokenId`.
1538      */
1539     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1540         uint256 curr = tokenId;
1541 
1542         unchecked {
1543             if (_startTokenId() <= curr)
1544                 if (curr < _currentIndex) {
1545                     uint256 packed = _packedOwnerships[curr];
1546                     // If not burned.
1547                     if (packed & _BITMASK_BURNED == 0) {
1548                         // Invariant:
1549                         // There will always be an initialized ownership slot
1550                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1551                         // before an unintialized ownership slot
1552                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1553                         // Hence, `curr` will not underflow.
1554                         //
1555                         // We can directly compare the packed value.
1556                         // If the address is zero, packed will be zero.
1557                         while (packed == 0) {
1558                             packed = _packedOwnerships[--curr];
1559                         }
1560                         return packed;
1561                     }
1562                 }
1563         }
1564         revert OwnerQueryForNonexistentToken();
1565     }
1566 
1567     /**
1568      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1569      */
1570     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1571         ownership.addr = address(uint160(packed));
1572         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1573         ownership.burned = packed & _BITMASK_BURNED != 0;
1574         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1575     }
1576 
1577     /**
1578      * @dev Packs ownership data into a single uint256.
1579      */
1580     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1581         assembly {
1582             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1583             owner := and(owner, _BITMASK_ADDRESS)
1584             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1585             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1586         }
1587     }
1588 
1589     /**
1590      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1591      */
1592     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1593         // For branchless setting of the `nextInitialized` flag.
1594         assembly {
1595             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1596             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1597         }
1598     }
1599 
1600     // =============================================================
1601     //                      APPROVAL OPERATIONS
1602     // =============================================================
1603 
1604     /**
1605      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1606      * The approval is cleared when the token is transferred.
1607      *
1608      * Only a single account can be approved at a time, so approving the
1609      * zero address clears previous approvals.
1610      *
1611      * Requirements:
1612      *
1613      * - The caller must own the token or be an approved operator.
1614      * - `tokenId` must exist.
1615      *
1616      * Emits an {Approval} event.
1617      */
1618     function approve(address to, uint256 tokenId) public payable virtual override {
1619         address owner = ownerOf(tokenId);
1620 
1621         if (_msgSenderERC721A() != owner)
1622             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1623                 revert ApprovalCallerNotOwnerNorApproved();
1624             }
1625 
1626         _tokenApprovals[tokenId].value = to;
1627         emit Approval(owner, to, tokenId);
1628     }
1629 
1630     /**
1631      * @dev Returns the account approved for `tokenId` token.
1632      *
1633      * Requirements:
1634      *
1635      * - `tokenId` must exist.
1636      */
1637     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1638         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1639 
1640         return _tokenApprovals[tokenId].value;
1641     }
1642 
1643     /**
1644      * @dev Approve or remove `operator` as an operator for the caller.
1645      * Operators can call {transferFrom} or {safeTransferFrom}
1646      * for any token owned by the caller.
1647      *
1648      * Requirements:
1649      *
1650      * - The `operator` cannot be the caller.
1651      *
1652      * Emits an {ApprovalForAll} event.
1653      */
1654     function setApprovalForAll(address operator, bool approved) public virtual override {
1655         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1656         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1657     }
1658 
1659     /**
1660      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1661      *
1662      * See {setApprovalForAll}.
1663      */
1664     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1665         return _operatorApprovals[owner][operator];
1666     }
1667 
1668     /**
1669      * @dev Returns whether `tokenId` exists.
1670      *
1671      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1672      *
1673      * Tokens start existing when they are minted. See {_mint}.
1674      */
1675     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1676         return
1677             _startTokenId() <= tokenId &&
1678             tokenId < _currentIndex && // If within bounds,
1679             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1680     }
1681 
1682     /**
1683      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1684      */
1685     function _isSenderApprovedOrOwner(
1686         address approvedAddress,
1687         address owner,
1688         address msgSender
1689     ) private pure returns (bool result) {
1690         assembly {
1691             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1692             owner := and(owner, _BITMASK_ADDRESS)
1693             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1694             msgSender := and(msgSender, _BITMASK_ADDRESS)
1695             // `msgSender == owner || msgSender == approvedAddress`.
1696             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1697         }
1698     }
1699 
1700     /**
1701      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1702      */
1703     function _getApprovedSlotAndAddress(uint256 tokenId)
1704         private
1705         view
1706         returns (uint256 approvedAddressSlot, address approvedAddress)
1707     {
1708         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1709         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1710         assembly {
1711             approvedAddressSlot := tokenApproval.slot
1712             approvedAddress := sload(approvedAddressSlot)
1713         }
1714     }
1715 
1716     // =============================================================
1717     //                      TRANSFER OPERATIONS
1718     // =============================================================
1719 
1720     /**
1721      * @dev Transfers `tokenId` from `from` to `to`.
1722      *
1723      * Requirements:
1724      *
1725      * - `from` cannot be the zero address.
1726      * - `to` cannot be the zero address.
1727      * - `tokenId` token must be owned by `from`.
1728      * - If the caller is not `from`, it must be approved to move this token
1729      * by either {approve} or {setApprovalForAll}.
1730      *
1731      * Emits a {Transfer} event.
1732      */
1733     function transferFrom(
1734         address from,
1735         address to,
1736         uint256 tokenId
1737     ) public payable virtual override {
1738         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1739 
1740         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1741 
1742         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1743 
1744         // The nested ifs save around 20+ gas over a compound boolean condition.
1745         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1746             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1747 
1748         if (to == address(0)) revert TransferToZeroAddress();
1749 
1750         _beforeTokenTransfers(from, to, tokenId, 1);
1751 
1752         // Clear approvals from the previous owner.
1753         assembly {
1754             if approvedAddress {
1755                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1756                 sstore(approvedAddressSlot, 0)
1757             }
1758         }
1759 
1760         // Underflow of the sender's balance is impossible because we check for
1761         // ownership above and the recipient's balance can't realistically overflow.
1762         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1763         unchecked {
1764             // We can directly increment and decrement the balances.
1765             --_packedAddressData[from]; // Updates: `balance -= 1`.
1766             ++_packedAddressData[to]; // Updates: `balance += 1`.
1767 
1768             // Updates:
1769             // - `address` to the next owner.
1770             // - `startTimestamp` to the timestamp of transfering.
1771             // - `burned` to `false`.
1772             // - `nextInitialized` to `true`.
1773             _packedOwnerships[tokenId] = _packOwnershipData(
1774                 to,
1775                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1776             );
1777 
1778             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1779             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1780                 uint256 nextTokenId = tokenId + 1;
1781                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1782                 if (_packedOwnerships[nextTokenId] == 0) {
1783                     // If the next slot is within bounds.
1784                     if (nextTokenId != _currentIndex) {
1785                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1786                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1787                     }
1788                 }
1789             }
1790         }
1791 
1792         emit Transfer(from, to, tokenId);
1793         _afterTokenTransfers(from, to, tokenId, 1);
1794     }
1795 
1796     /**
1797      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1798      */
1799     function safeTransferFrom(
1800         address from,
1801         address to,
1802         uint256 tokenId
1803     ) public payable virtual override {
1804         safeTransferFrom(from, to, tokenId, '');
1805     }
1806 
1807     /**
1808      * @dev Safely transfers `tokenId` token from `from` to `to`.
1809      *
1810      * Requirements:
1811      *
1812      * - `from` cannot be the zero address.
1813      * - `to` cannot be the zero address.
1814      * - `tokenId` token must exist and be owned by `from`.
1815      * - If the caller is not `from`, it must be approved to move this token
1816      * by either {approve} or {setApprovalForAll}.
1817      * - If `to` refers to a smart contract, it must implement
1818      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1819      *
1820      * Emits a {Transfer} event.
1821      */
1822     function safeTransferFrom(
1823         address from,
1824         address to,
1825         uint256 tokenId,
1826         bytes memory _data
1827     ) public payable virtual override {
1828         transferFrom(from, to, tokenId);
1829         if (to.code.length != 0)
1830             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1831                 revert TransferToNonERC721ReceiverImplementer();
1832             }
1833     }
1834 
1835     /**
1836      * @dev Hook that is called before a set of serially-ordered token IDs
1837      * are about to be transferred. This includes minting.
1838      * And also called before burning one token.
1839      *
1840      * `startTokenId` - the first token ID to be transferred.
1841      * `quantity` - the amount to be transferred.
1842      *
1843      * Calling conditions:
1844      *
1845      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1846      * transferred to `to`.
1847      * - When `from` is zero, `tokenId` will be minted for `to`.
1848      * - When `to` is zero, `tokenId` will be burned by `from`.
1849      * - `from` and `to` are never both zero.
1850      */
1851     function _beforeTokenTransfers(
1852         address from,
1853         address to,
1854         uint256 startTokenId,
1855         uint256 quantity
1856     ) internal virtual {}
1857 
1858     /**
1859      * @dev Hook that is called after a set of serially-ordered token IDs
1860      * have been transferred. This includes minting.
1861      * And also called after one token has been burned.
1862      *
1863      * `startTokenId` - the first token ID to be transferred.
1864      * `quantity` - the amount to be transferred.
1865      *
1866      * Calling conditions:
1867      *
1868      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1869      * transferred to `to`.
1870      * - When `from` is zero, `tokenId` has been minted for `to`.
1871      * - When `to` is zero, `tokenId` has been burned by `from`.
1872      * - `from` and `to` are never both zero.
1873      */
1874     function _afterTokenTransfers(
1875         address from,
1876         address to,
1877         uint256 startTokenId,
1878         uint256 quantity
1879     ) internal virtual {}
1880 
1881     /**
1882      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1883      *
1884      * `from` - Previous owner of the given token ID.
1885      * `to` - Target address that will receive the token.
1886      * `tokenId` - Token ID to be transferred.
1887      * `_data` - Optional data to send along with the call.
1888      *
1889      * Returns whether the call correctly returned the expected magic value.
1890      */
1891     function _checkContractOnERC721Received(
1892         address from,
1893         address to,
1894         uint256 tokenId,
1895         bytes memory _data
1896     ) private returns (bool) {
1897         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1898             bytes4 retval
1899         ) {
1900             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1901         } catch (bytes memory reason) {
1902             if (reason.length == 0) {
1903                 revert TransferToNonERC721ReceiverImplementer();
1904             } else {
1905                 assembly {
1906                     revert(add(32, reason), mload(reason))
1907                 }
1908             }
1909         }
1910     }
1911 
1912     // =============================================================
1913     //                        MINT OPERATIONS
1914     // =============================================================
1915 
1916     /**
1917      * @dev Mints `quantity` tokens and transfers them to `to`.
1918      *
1919      * Requirements:
1920      *
1921      * - `to` cannot be the zero address.
1922      * - `quantity` must be greater than 0.
1923      *
1924      * Emits a {Transfer} event for each mint.
1925      */
1926     function _mint(address to, uint256 quantity) internal virtual {
1927         uint256 startTokenId = _currentIndex;
1928         if (quantity == 0) revert MintZeroQuantity();
1929 
1930         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1931 
1932         // Overflows are incredibly unrealistic.
1933         // `balance` and `numberMinted` have a maximum limit of 2**64.
1934         // `tokenId` has a maximum limit of 2**256.
1935         unchecked {
1936             // Updates:
1937             // - `balance += quantity`.
1938             // - `numberMinted += quantity`.
1939             //
1940             // We can directly add to the `balance` and `numberMinted`.
1941             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1942 
1943             // Updates:
1944             // - `address` to the owner.
1945             // - `startTimestamp` to the timestamp of minting.
1946             // - `burned` to `false`.
1947             // - `nextInitialized` to `quantity == 1`.
1948             _packedOwnerships[startTokenId] = _packOwnershipData(
1949                 to,
1950                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1951             );
1952 
1953             uint256 toMasked;
1954             uint256 end = startTokenId + quantity;
1955 
1956             // Use assembly to loop and emit the `Transfer` event for gas savings.
1957             // The duplicated `log4` removes an extra check and reduces stack juggling.
1958             // The assembly, together with the surrounding Solidity code, have been
1959             // delicately arranged to nudge the compiler into producing optimized opcodes.
1960             assembly {
1961                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1962                 toMasked := and(to, _BITMASK_ADDRESS)
1963                 // Emit the `Transfer` event.
1964                 log4(
1965                     0, // Start of data (0, since no data).
1966                     0, // End of data (0, since no data).
1967                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1968                     0, // `address(0)`.
1969                     toMasked, // `to`.
1970                     startTokenId // `tokenId`.
1971                 )
1972 
1973                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1974                 // that overflows uint256 will make the loop run out of gas.
1975                 // The compiler will optimize the `iszero` away for performance.
1976                 for {
1977                     let tokenId := add(startTokenId, 1)
1978                 } iszero(eq(tokenId, end)) {
1979                     tokenId := add(tokenId, 1)
1980                 } {
1981                     // Emit the `Transfer` event. Similar to above.
1982                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1983                 }
1984             }
1985             if (toMasked == 0) revert MintToZeroAddress();
1986 
1987             _currentIndex = end;
1988         }
1989         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1990     }
1991 
1992     /**
1993      * @dev Mints `quantity` tokens and transfers them to `to`.
1994      *
1995      * This function is intended for efficient minting only during contract creation.
1996      *
1997      * It emits only one {ConsecutiveTransfer} as defined in
1998      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1999      * instead of a sequence of {Transfer} event(s).
2000      *
2001      * Calling this function outside of contract creation WILL make your contract
2002      * non-compliant with the ERC721 standard.
2003      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2004      * {ConsecutiveTransfer} event is only permissible during contract creation.
2005      *
2006      * Requirements:
2007      *
2008      * - `to` cannot be the zero address.
2009      * - `quantity` must be greater than 0.
2010      *
2011      * Emits a {ConsecutiveTransfer} event.
2012      */
2013     function _mintERC2309(address to, uint256 quantity) internal virtual {
2014         uint256 startTokenId = _currentIndex;
2015         if (to == address(0)) revert MintToZeroAddress();
2016         if (quantity == 0) revert MintZeroQuantity();
2017         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2018 
2019         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2020 
2021         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2022         unchecked {
2023             // Updates:
2024             // - `balance += quantity`.
2025             // - `numberMinted += quantity`.
2026             //
2027             // We can directly add to the `balance` and `numberMinted`.
2028             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2029 
2030             // Updates:
2031             // - `address` to the owner.
2032             // - `startTimestamp` to the timestamp of minting.
2033             // - `burned` to `false`.
2034             // - `nextInitialized` to `quantity == 1`.
2035             _packedOwnerships[startTokenId] = _packOwnershipData(
2036                 to,
2037                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2038             );
2039 
2040             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2041 
2042             _currentIndex = startTokenId + quantity;
2043         }
2044         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2045     }
2046 
2047     /**
2048      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2049      *
2050      * Requirements:
2051      *
2052      * - If `to` refers to a smart contract, it must implement
2053      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2054      * - `quantity` must be greater than 0.
2055      *
2056      * See {_mint}.
2057      *
2058      * Emits a {Transfer} event for each mint.
2059      */
2060     function _safeMint(
2061         address to,
2062         uint256 quantity,
2063         bytes memory _data
2064     ) internal virtual {
2065         _mint(to, quantity);
2066 
2067         unchecked {
2068             if (to.code.length != 0) {
2069                 uint256 end = _currentIndex;
2070                 uint256 index = end - quantity;
2071                 do {
2072                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2073                         revert TransferToNonERC721ReceiverImplementer();
2074                     }
2075                 } while (index < end);
2076                 // Reentrancy protection.
2077                 if (_currentIndex != end) revert();
2078             }
2079         }
2080     }
2081 
2082     /**
2083      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2084      */
2085     function _safeMint(address to, uint256 quantity) internal virtual {
2086         _safeMint(to, quantity, '');
2087     }
2088 
2089     // =============================================================
2090     //                        BURN OPERATIONS
2091     // =============================================================
2092 
2093     /**
2094      * @dev Equivalent to `_burn(tokenId, false)`.
2095      */
2096     function _burn(uint256 tokenId) internal virtual {
2097         _burn(tokenId, false);
2098     }
2099 
2100     /**
2101      * @dev Destroys `tokenId`.
2102      * The approval is cleared when the token is burned.
2103      *
2104      * Requirements:
2105      *
2106      * - `tokenId` must exist.
2107      *
2108      * Emits a {Transfer} event.
2109      */
2110     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2111         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2112 
2113         address from = address(uint160(prevOwnershipPacked));
2114 
2115         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2116 
2117         if (approvalCheck) {
2118             // The nested ifs save around 20+ gas over a compound boolean condition.
2119             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2120                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2121         }
2122 
2123         _beforeTokenTransfers(from, address(0), tokenId, 1);
2124 
2125         // Clear approvals from the previous owner.
2126         assembly {
2127             if approvedAddress {
2128                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2129                 sstore(approvedAddressSlot, 0)
2130             }
2131         }
2132 
2133         // Underflow of the sender's balance is impossible because we check for
2134         // ownership above and the recipient's balance can't realistically overflow.
2135         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2136         unchecked {
2137             // Updates:
2138             // - `balance -= 1`.
2139             // - `numberBurned += 1`.
2140             //
2141             // We can directly decrement the balance, and increment the number burned.
2142             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2143             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2144 
2145             // Updates:
2146             // - `address` to the last owner.
2147             // - `startTimestamp` to the timestamp of burning.
2148             // - `burned` to `true`.
2149             // - `nextInitialized` to `true`.
2150             _packedOwnerships[tokenId] = _packOwnershipData(
2151                 from,
2152                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2153             );
2154 
2155             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2156             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2157                 uint256 nextTokenId = tokenId + 1;
2158                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2159                 if (_packedOwnerships[nextTokenId] == 0) {
2160                     // If the next slot is within bounds.
2161                     if (nextTokenId != _currentIndex) {
2162                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2163                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2164                     }
2165                 }
2166             }
2167         }
2168 
2169         emit Transfer(from, address(0), tokenId);
2170         _afterTokenTransfers(from, address(0), tokenId, 1);
2171 
2172         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2173         unchecked {
2174             _burnCounter++;
2175         }
2176     }
2177 
2178     // =============================================================
2179     //                     EXTRA DATA OPERATIONS
2180     // =============================================================
2181 
2182     /**
2183      * @dev Directly sets the extra data for the ownership data `index`.
2184      */
2185     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2186         uint256 packed = _packedOwnerships[index];
2187         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2188         uint256 extraDataCasted;
2189         // Cast `extraData` with assembly to avoid redundant masking.
2190         assembly {
2191             extraDataCasted := extraData
2192         }
2193         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2194         _packedOwnerships[index] = packed;
2195     }
2196 
2197     /**
2198      * @dev Called during each token transfer to set the 24bit `extraData` field.
2199      * Intended to be overridden by the cosumer contract.
2200      *
2201      * `previousExtraData` - the value of `extraData` before transfer.
2202      *
2203      * Calling conditions:
2204      *
2205      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2206      * transferred to `to`.
2207      * - When `from` is zero, `tokenId` will be minted for `to`.
2208      * - When `to` is zero, `tokenId` will be burned by `from`.
2209      * - `from` and `to` are never both zero.
2210      */
2211     function _extraData(
2212         address from,
2213         address to,
2214         uint24 previousExtraData
2215     ) internal view virtual returns (uint24) {}
2216 
2217     /**
2218      * @dev Returns the next extra data for the packed ownership data.
2219      * The returned result is shifted into position.
2220      */
2221     function _nextExtraData(
2222         address from,
2223         address to,
2224         uint256 prevOwnershipPacked
2225     ) private view returns (uint256) {
2226         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2227         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2228     }
2229 
2230     // =============================================================
2231     //                       OTHER OPERATIONS
2232     // =============================================================
2233 
2234     /**
2235      * @dev Returns the message sender (defaults to `msg.sender`).
2236      *
2237      * If you are writing GSN compatible contracts, you need to override this function.
2238      */
2239     function _msgSenderERC721A() internal view virtual returns (address) {
2240         return msg.sender;
2241     }
2242 
2243     /**
2244      * @dev Converts a uint256 to its ASCII string decimal representation.
2245      */
2246     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2247         assembly {
2248             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2249             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2250             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2251             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2252             let m := add(mload(0x40), 0xa0)
2253             // Update the free memory pointer to allocate.
2254             mstore(0x40, m)
2255             // Assign the `str` to the end.
2256             str := sub(m, 0x20)
2257             // Zeroize the slot after the string.
2258             mstore(str, 0)
2259 
2260             // Cache the end of the memory to calculate the length later.
2261             let end := str
2262 
2263             // We write the string from rightmost digit to leftmost digit.
2264             // The following is essentially a do-while loop that also handles the zero case.
2265             // prettier-ignore
2266             for { let temp := value } 1 {} {
2267                 str := sub(str, 1)
2268                 // Write the character to the pointer.
2269                 // The ASCII index of the '0' character is 48.
2270                 mstore8(str, add(48, mod(temp, 10)))
2271                 // Keep dividing `temp` until zero.
2272                 temp := div(temp, 10)
2273                 // prettier-ignore
2274                 if iszero(temp) { break }
2275             }
2276 
2277             let length := sub(end, str)
2278             // Move the pointer 32 bytes leftwards to make room for the length.
2279             str := sub(str, 0x20)
2280             // Store the length.
2281             mstore(str, length)
2282         }
2283     }
2284 }
2285 
2286 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
2287 
2288 
2289 // ERC721A Contracts v4.2.3
2290 // Creator: Chiru Labs
2291 
2292 pragma solidity ^0.8.4;
2293 
2294 
2295 /**
2296  * @dev Interface of ERC721AQueryable.
2297  */
2298 interface IERC721AQueryable is IERC721A {
2299     /**
2300      * Invalid query range (`start` >= `stop`).
2301      */
2302     error InvalidQueryRange();
2303 
2304     /**
2305      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2306      *
2307      * If the `tokenId` is out of bounds:
2308      *
2309      * - `addr = address(0)`
2310      * - `startTimestamp = 0`
2311      * - `burned = false`
2312      * - `extraData = 0`
2313      *
2314      * If the `tokenId` is burned:
2315      *
2316      * - `addr = <Address of owner before token was burned>`
2317      * - `startTimestamp = <Timestamp when token was burned>`
2318      * - `burned = true`
2319      * - `extraData = <Extra data when token was burned>`
2320      *
2321      * Otherwise:
2322      *
2323      * - `addr = <Address of owner>`
2324      * - `startTimestamp = <Timestamp of start of ownership>`
2325      * - `burned = false`
2326      * - `extraData = <Extra data at start of ownership>`
2327      */
2328     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
2329 
2330     /**
2331      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2332      * See {ERC721AQueryable-explicitOwnershipOf}
2333      */
2334     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
2335 
2336     /**
2337      * @dev Returns an array of token IDs owned by `owner`,
2338      * in the range [`start`, `stop`)
2339      * (i.e. `start <= tokenId < stop`).
2340      *
2341      * This function allows for tokens to be queried if the collection
2342      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2343      *
2344      * Requirements:
2345      *
2346      * - `start < stop`
2347      */
2348     function tokensOfOwnerIn(
2349         address owner,
2350         uint256 start,
2351         uint256 stop
2352     ) external view returns (uint256[] memory);
2353 
2354     /**
2355      * @dev Returns an array of token IDs owned by `owner`.
2356      *
2357      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2358      * It is meant to be called off-chain.
2359      *
2360      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2361      * multiple smaller scans if the collection is large enough to cause
2362      * an out-of-gas error (10K collections should be fine).
2363      */
2364     function tokensOfOwner(address owner) external view returns (uint256[] memory);
2365 }
2366 
2367 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2368 
2369 
2370 // ERC721A Contracts v4.2.3
2371 // Creator: Chiru Labs
2372 
2373 pragma solidity ^0.8.4;
2374 
2375 
2376 
2377 /**
2378  * @title ERC721AQueryable.
2379  *
2380  * @dev ERC721A subclass with convenience query functions.
2381  */
2382 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2383     /**
2384      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2385      *
2386      * If the `tokenId` is out of bounds:
2387      *
2388      * - `addr = address(0)`
2389      * - `startTimestamp = 0`
2390      * - `burned = false`
2391      * - `extraData = 0`
2392      *
2393      * If the `tokenId` is burned:
2394      *
2395      * - `addr = <Address of owner before token was burned>`
2396      * - `startTimestamp = <Timestamp when token was burned>`
2397      * - `burned = true`
2398      * - `extraData = <Extra data when token was burned>`
2399      *
2400      * Otherwise:
2401      *
2402      * - `addr = <Address of owner>`
2403      * - `startTimestamp = <Timestamp of start of ownership>`
2404      * - `burned = false`
2405      * - `extraData = <Extra data at start of ownership>`
2406      */
2407     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2408         TokenOwnership memory ownership;
2409         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2410             return ownership;
2411         }
2412         ownership = _ownershipAt(tokenId);
2413         if (ownership.burned) {
2414             return ownership;
2415         }
2416         return _ownershipOf(tokenId);
2417     }
2418 
2419     /**
2420      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2421      * See {ERC721AQueryable-explicitOwnershipOf}
2422      */
2423     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2424         external
2425         view
2426         virtual
2427         override
2428         returns (TokenOwnership[] memory)
2429     {
2430         unchecked {
2431             uint256 tokenIdsLength = tokenIds.length;
2432             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2433             for (uint256 i; i != tokenIdsLength; ++i) {
2434                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2435             }
2436             return ownerships;
2437         }
2438     }
2439 
2440     /**
2441      * @dev Returns an array of token IDs owned by `owner`,
2442      * in the range [`start`, `stop`)
2443      * (i.e. `start <= tokenId < stop`).
2444      *
2445      * This function allows for tokens to be queried if the collection
2446      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2447      *
2448      * Requirements:
2449      *
2450      * - `start < stop`
2451      */
2452     function tokensOfOwnerIn(
2453         address owner,
2454         uint256 start,
2455         uint256 stop
2456     ) external view virtual override returns (uint256[] memory) {
2457         unchecked {
2458             if (start >= stop) revert InvalidQueryRange();
2459             uint256 tokenIdsIdx;
2460             uint256 stopLimit = _nextTokenId();
2461             // Set `start = max(start, _startTokenId())`.
2462             if (start < _startTokenId()) {
2463                 start = _startTokenId();
2464             }
2465             // Set `stop = min(stop, stopLimit)`.
2466             if (stop > stopLimit) {
2467                 stop = stopLimit;
2468             }
2469             uint256 tokenIdsMaxLength = balanceOf(owner);
2470             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2471             // to cater for cases where `balanceOf(owner)` is too big.
2472             if (start < stop) {
2473                 uint256 rangeLength = stop - start;
2474                 if (rangeLength < tokenIdsMaxLength) {
2475                     tokenIdsMaxLength = rangeLength;
2476                 }
2477             } else {
2478                 tokenIdsMaxLength = 0;
2479             }
2480             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2481             if (tokenIdsMaxLength == 0) {
2482                 return tokenIds;
2483             }
2484             // We need to call `explicitOwnershipOf(start)`,
2485             // because the slot at `start` may not be initialized.
2486             TokenOwnership memory ownership = explicitOwnershipOf(start);
2487             address currOwnershipAddr;
2488             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2489             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2490             if (!ownership.burned) {
2491                 currOwnershipAddr = ownership.addr;
2492             }
2493             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2494                 ownership = _ownershipAt(i);
2495                 if (ownership.burned) {
2496                     continue;
2497                 }
2498                 if (ownership.addr != address(0)) {
2499                     currOwnershipAddr = ownership.addr;
2500                 }
2501                 if (currOwnershipAddr == owner) {
2502                     tokenIds[tokenIdsIdx++] = i;
2503                 }
2504             }
2505             // Downsize the array to fit.
2506             assembly {
2507                 mstore(tokenIds, tokenIdsIdx)
2508             }
2509             return tokenIds;
2510         }
2511     }
2512 
2513     /**
2514      * @dev Returns an array of token IDs owned by `owner`.
2515      *
2516      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2517      * It is meant to be called off-chain.
2518      *
2519      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2520      * multiple smaller scans if the collection is large enough to cause
2521      * an out-of-gas error (10K collections should be fine).
2522      */
2523     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2524         unchecked {
2525             uint256 tokenIdsIdx;
2526             address currOwnershipAddr;
2527             uint256 tokenIdsLength = balanceOf(owner);
2528             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2529             TokenOwnership memory ownership;
2530             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2531                 ownership = _ownershipAt(i);
2532                 if (ownership.burned) {
2533                     continue;
2534                 }
2535                 if (ownership.addr != address(0)) {
2536                     currOwnershipAddr = ownership.addr;
2537                 }
2538                 if (currOwnershipAddr == owner) {
2539                     tokenIds[tokenIdsIdx++] = i;
2540                 }
2541             }
2542             return tokenIds;
2543         }
2544     }
2545 }
2546 
2547 // File: contracts/thelittlefrensNFT.sol
2548 
2549 pragma solidity ^0.8.13;
2550 
2551 
2552 
2553 
2554 
2555 
2556 
2557 
2558 /// @title Interface for prize contract (for burning prizes)
2559 interface IPrizeContract {
2560     function burn(
2561         address address_,
2562         uint256[] memory ids_,
2563         uint256[] memory amounts_
2564     ) external;
2565 }
2566 
2567 /// ╔════╗╔╗╔╗╔═══╗───╔╗──╔══╗╔════╗╔════╗╔╗──╔═══╗╔══╗ ///
2568 /// ╚═╗╔═╝║║║║║╔══╝───║║──╚╗╔╝╚═╗╔═╝╚═╗╔═╝║║──║╔══╝║╔═╝ ///
2569 /// ──║║──║╚╝║║╚══╗───║║───║║───║║────║║──║║──║╚══╗║╚═╗ ///
2570 /// ──║║──║╔╗║║╔══╝───║║───║║───║║────║║──║║──║╔══╝╚═╗║ ///
2571 /// ──║║──║║║║║╚══╗───║╚═╗╔╝╚╗──║║────║║──║╚═╗║╚══╗╔═╝║ ///
2572 /// ──╚╝──╚╝╚╝╚═══╝───╚══╝╚══╝──╚╝────╚╝──╚══╝╚═══╝╚══╝ ///
2573 
2574 /**
2575  * @title The Littles Evolution Contract
2576  * @author Itzik Lerner, rminla.eth, Eugene Strelkov, Evgeniya Zaikina, benyu.eth AKA the NFTDevz
2577  * @notice This contract provides functionality for evolving Littles.
2578  */
2579 contract TheLittlesEvolutionContract is ERC721AQueryable, Ownable, ERC2981, ReentrancyGuard {
2580     using Strings for uint256;
2581     using ECDSA for bytes32;
2582     using SafeMath for uint256;
2583 
2584     //----------------- STATE -----------------//
2585     bool public paused = false;
2586     string public baseURI;
2587     string public contractURI;
2588 
2589     address public admin = 0x464b01D24E1542FAbF96c22fB6ea4bC84bea96d3;
2590     address public prizeContractAddress = 0xE948D9d3b97606304A8DB0538bDD0b6465c9DFcB;
2591     address public genesisSmartContractAddress = 0xc6ec80029CD2aa4B0021cEb11248C07b25D2DE34;
2592 
2593     address public partner1Address = 0x4475F712004D52964644cdF54280d1d9E58cE378;
2594     address public partner2Address = 0x747b5CC00104CdE2FfD450c46468Bc2b7e57Ad15;
2595 
2596     uint256 private _minNonce = 0;
2597 
2598     /// @dev genesisId => prizeId => isUsed
2599     mapping(uint256 => mapping(uint256 => bool)) public usedGenesisAndPrizes;
2600 
2601     mapping(address => uint256) public addressFreeMintCount;
2602 
2603     uint256 public maxSupply = 10000;
2604     uint256 public countFreeMintPerAddress = 2;
2605 
2606     //----------------- EVENTS -----------------//
2607     event AdminChanged(address admin_);
2608     event LittleFreeMint(address to_, uint256 mintedId_, uint256 amount, uint256 nonce_);
2609     event LittleEvolve(address to_, uint256 mintedId_, uint256[] prizeIdList_, uint256[] amountList_, uint256 nonce_);
2610 
2611     //----------------- CONSTRUCTOR -----------------//
2612     constructor(
2613         string memory name_,
2614         string memory symbol_,
2615         string memory baseURI_,
2616         address royaltyReciverAddress_,
2617         uint96 royaltyFee_
2618     ) ERC721A(name_, symbol_) {
2619         setBaseURI(baseURI_);
2620         setRoyalty(royaltyReciverAddress_, royaltyFee_);
2621     }
2622 
2623     //----------------- MODIFIERS -----------------//
2624     modifier notPaused() {
2625         require(!paused, "Paused");
2626         _;
2627     }
2628 
2629     /// @notice Prevent contract-to-contract calls
2630     modifier originalUser() {
2631         require(msg.sender == tx.origin && !_isContract(msg.sender), "Must invoke directly from your wallet");
2632         _;
2633     }
2634 
2635     modifier supplyNotExceeded(uint256 amount_) {
2636         require(totalSupply() + amount_ <= maxSupply, "Insufficient supply");
2637         _;
2638     }
2639 
2640     modifier userCanStillFreeMint(uint256 amount_) {
2641         require(addressFreeMintCount[msg.sender] + amount_ <= countFreeMintPerAddress, "Max mint per address");
2642         _;
2643     }
2644 
2645     //----------------- BASE -----------------//
2646     function supportsInterface(bytes4 interfaceId)
2647         public
2648         view
2649         virtual
2650         override(IERC721A, ERC721A, ERC2981)
2651         returns (bool)
2652     {
2653         return ERC721A.supportsInterface(interfaceId) || ERC2981.supportsInterface(interfaceId);
2654     }
2655 
2656     function _baseURI() internal view virtual override returns (string memory) {
2657         return baseURI;
2658     }
2659 
2660     function tokenURI(uint256 tokenId_) public view virtual override(IERC721A, ERC721A) returns (string memory) {
2661         require(_exists(tokenId_), "Nonexistent token");
2662 
2663         return string(abi.encodePacked(_baseURI(), tokenId_.toString(), ".json"));
2664     }
2665 
2666     /// @notice for getting eth in contract address
2667     receive() external payable {}
2668 
2669     //----------------- COMMON -----------------//
2670     function _isContract(address account_) internal view returns (bool) {
2671         uint256 size_;
2672         assembly {
2673             size_ := extcodesize(account_)
2674         }
2675         return size_ > 0;
2676     }
2677 
2678     function _isValidSignature(bytes32 msgHash_, bytes memory signature_) private view returns (bool) {
2679         bytes32 signedHash_ = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash_));
2680         return signedHash_.recover(signature_) == admin;
2681     }
2682 
2683     //----------------- ONLY OWNER -----------------//
2684     function togglePaused(bool paused_) external onlyOwner {
2685         paused = paused_;
2686     }
2687 
2688     function setAdmin(address admin_) public onlyOwner {
2689         require(admin_ != address(0), "Null address");
2690 
2691         admin = admin_;
2692         emit AdminChanged(admin_);
2693     }
2694 
2695     function setPrizeContractAddress(address prizeContractAddress_) public onlyOwner {
2696         require(prizeContractAddress_ != address(0), "Null address");
2697 
2698         prizeContractAddress = prizeContractAddress_;
2699     }
2700 
2701     function setGenesisSmartContractAddress(address genesisSmartContractAddress_) external onlyOwner {
2702         require(genesisSmartContractAddress_ != address(0), "Null address");
2703 
2704         genesisSmartContractAddress = genesisSmartContractAddress_;
2705     }
2706 
2707     /// @dev change this value when change phase
2708     function setMinNonce(uint256 minNonce_) external onlyOwner {
2709         _minNonce = minNonce_;
2710     }
2711 
2712     function setBaseURI(string memory baseURI_) public onlyOwner {
2713         baseURI = baseURI_;
2714     }
2715 
2716     function setRoyalty(address royaltyReceiverAddress_, uint96 royaltyFee_) public onlyOwner {
2717         _setDefaultRoyalty(royaltyReceiverAddress_, royaltyFee_);
2718     }
2719 
2720     /// @notice Update the contractURI for OpenSea, update for collection-specific metadata
2721     function setContractURI(string calldata contractURI_) external onlyOwner {
2722         contractURI = contractURI_;
2723     }
2724 
2725     function setMaxSupply(uint256 maxSupply_) external onlyOwner {
2726         maxSupply = maxSupply_;
2727     }
2728 
2729     function setCountFreeMintPerAddress(uint256 countFreeMintPerAddress_) external onlyOwner {
2730         countFreeMintPerAddress = countFreeMintPerAddress_;
2731     }
2732 
2733     function setPartnerAddresses(address partner1Address_, address partner2Address_) external onlyOwner {
2734         require(partner1Address_ != address(0), "Partner addresses must be valid");
2735         require(partner2Address_ != address(0), "Partner addresses must be valid");
2736         partner1Address = partner1Address_;
2737         partner2Address = partner2Address_;
2738     }
2739 
2740     function withdraw() public nonReentrant onlyOwner {
2741         uint256 balance_ = address(this).balance;
2742         require(balance_ > 0, "No ETH to withdraw");
2743         require(partner1Address != address(0), "Must have valid partner1 withdraw address");
2744 
2745         if (partner1Address == partner2Address) {
2746             require(payable(partner1Address).send(balance_));
2747         } else {
2748             require(partner2Address != address(0), "Must have valid partner2 withdraw address");
2749             uint256 split_ = balance_.mul(80).div(100);
2750 
2751             require(payable(partner1Address).send(split_));
2752             require(payable(partner2Address).send(balance_.sub(split_)));
2753         }
2754     }
2755 
2756     //----------------- FREE MINT -----------------//
2757     function freeMint(
2758         uint256 amount_,
2759         bytes memory signature_,
2760         uint256 nonce_
2761     ) external notPaused nonReentrant originalUser userCanStillFreeMint(amount_) supplyNotExceeded(amount_) {
2762         require(nonce_ >= _minNonce, "Invalid nonce");
2763 
2764         bytes32 msgHash_ = keccak256(abi.encodePacked(msg.sender, amount_, nonce_));
2765         require(_isValidSignature(msgHash_, signature_), "Invalid signature");
2766         addressFreeMintCount[msg.sender] += amount_;
2767         _safeMint(msg.sender, amount_);
2768         emit LittleFreeMint(msg.sender, _nextTokenId() - amount_, amount_, nonce_);
2769     }
2770 
2771     //----------------- EVOLVE -----------------//
2772     /// @notice evolve genesis to little
2773     /// @param genesisId_ an existing genesis owned by the caller
2774     /// @param l3PrizeId_ an existing l3 prize in prize list (prizeIdList_), check on the server side
2775     /// @param prizeIdList_ an existing prize list, contain l3 prize (l3PrizeId_), check on the server side
2776     /// @param amountList_ amount list, relative to prize list
2777     /// @param signature_ server signature, needs for confirm prizes
2778     /// @param nonce_ needs for server for checking uniqueness
2779     function evolveGenesis(
2780         uint256 genesisId_,
2781         uint256 l3PrizeId_,
2782         uint256[] memory prizeIdList_,
2783         uint256[] memory amountList_,
2784         bytes memory signature_,
2785         uint256 nonce_
2786     ) external notPaused nonReentrant originalUser supplyNotExceeded(1) {
2787         require(prizeIdList_.length == amountList_.length, "Wrong list length");
2788         require(IERC721A(genesisSmartContractAddress).ownerOf(genesisId_) == msg.sender, "Non a holder");
2789 
2790         bytes32 msgHash_ = keccak256(
2791             abi.encodePacked(msg.sender, genesisId_, l3PrizeId_, prizeIdList_, amountList_, nonce_)
2792         );
2793         require(_isValidSignature(msgHash_, signature_), "Invalid signature");
2794 
2795         require(!usedGenesisAndPrizes[genesisId_][l3PrizeId_], "Used genesis with prize");
2796         usedGenesisAndPrizes[genesisId_][l3PrizeId_] = true;
2797 
2798         IPrizeContract(prizeContractAddress).burn(msg.sender, prizeIdList_, amountList_);
2799 
2800         _safeMint(msg.sender, 1);
2801         emit LittleEvolve(msg.sender, _nextTokenId() - 1, prizeIdList_, amountList_, nonce_);
2802     }
2803 
2804     /// @notice evolve little
2805     /// @param id_ existing little owned by the caller
2806     /// @param isEvolve_ bool flag, check on the server side; true if l3 prize exist in prize list (l3PrizeId_)
2807     /// @param prizeIdList_ an existing prize list, contain l3 prize (l3PrizeId_), check on the server side
2808     /// @param amountList_ amount list, relative to prize list
2809     /// @param signature_ server signature, needs for confirm prizes
2810     /// @param nonce_ needs for server for checking uniqueness
2811     function evolveLittle(
2812         uint256 id_,
2813         bool isEvolve_,
2814         uint256[] memory prizeIdList_,
2815         uint256[] memory amountList_,
2816         bytes memory signature_,
2817         uint256 nonce_
2818     ) external notPaused nonReentrant originalUser {
2819         require(prizeIdList_.length == amountList_.length, "Wrong list length");
2820         require(ownerOf(id_) == msg.sender, "Non a holder");
2821 
2822         bytes32 msgHash_ = keccak256(abi.encodePacked(msg.sender, id_, isEvolve_, prizeIdList_, amountList_, nonce_));
2823         require(_isValidSignature(msgHash_, signature_), "Invalid signature");
2824 
2825         IPrizeContract(prizeContractAddress).burn(msg.sender, prizeIdList_, amountList_);
2826 
2827         uint256 updatedTokenId_ = id_;
2828 
2829         if (isEvolve_) {
2830             _burn(id_);
2831             _safeMint(msg.sender, 1);
2832             updatedTokenId_ = _nextTokenId() - 1; /// ???: can we get current token in better way?
2833         }
2834 
2835         emit LittleEvolve(msg.sender, updatedTokenId_, prizeIdList_, amountList_, nonce_);
2836     }
2837 }