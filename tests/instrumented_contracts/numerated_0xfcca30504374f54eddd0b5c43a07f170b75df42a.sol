1 // File: @openzeppelin/contracts/utils/Strings.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev String operations.
10  */
11 library Strings {
12     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
13     uint8 private constant _ADDRESS_LENGTH = 20;
14 
15     /**
16      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
17      */
18     function toString(uint256 value) internal pure returns (string memory) {
19         // Inspired by OraclizeAPI's implementation - MIT licence
20         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
21 
22         if (value == 0) {
23             return "0";
24         }
25         uint256 temp = value;
26         uint256 digits;
27         while (temp != 0) {
28             digits++;
29             temp /= 10;
30         }
31         bytes memory buffer = new bytes(digits);
32         while (value != 0) {
33             digits -= 1;
34             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
35             value /= 10;
36         }
37         return string(buffer);
38     }
39 
40     /**
41      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
42      */
43     function toHexString(uint256 value) internal pure returns (string memory) {
44         if (value == 0) {
45             return "0x00";
46         }
47         uint256 temp = value;
48         uint256 length = 0;
49         while (temp != 0) {
50             length++;
51             temp >>= 8;
52         }
53         return toHexString(value, length);
54     }
55 
56     /**
57      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
58      */
59     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
60         bytes memory buffer = new bytes(2 * length + 2);
61         buffer[0] = "0";
62         buffer[1] = "x";
63         for (uint256 i = 2 * length + 1; i > 1; --i) {
64             buffer[i] = _HEX_SYMBOLS[value & 0xf];
65             value >>= 4;
66         }
67         require(value == 0, "Strings: hex length insufficient");
68         return string(buffer);
69     }
70 
71     /**
72      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
73      */
74     function toHexString(address addr) internal pure returns (string memory) {
75         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
76     }
77 }
78 
79 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
80 
81 
82 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
83 
84 pragma solidity ^0.8.0;
85 
86 
87 /**
88  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
89  *
90  * These functions can be used to verify that a message was signed by the holder
91  * of the private keys of a given address.
92  */
93 library ECDSA {
94     enum RecoverError {
95         NoError,
96         InvalidSignature,
97         InvalidSignatureLength,
98         InvalidSignatureS,
99         InvalidSignatureV // Deprecated in v4.8
100     }
101 
102     function _throwError(RecoverError error) private pure {
103         if (error == RecoverError.NoError) {
104             return; // no error: do nothing
105         } else if (error == RecoverError.InvalidSignature) {
106             revert("ECDSA: invalid signature");
107         } else if (error == RecoverError.InvalidSignatureLength) {
108             revert("ECDSA: invalid signature length");
109         } else if (error == RecoverError.InvalidSignatureS) {
110             revert("ECDSA: invalid signature 's' value");
111         }
112     }
113 
114     /**
115      * @dev Returns the address that signed a hashed message (`hash`) with
116      * `signature` or error string. This address can then be used for verification purposes.
117      *
118      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
119      * this function rejects them by requiring the `s` value to be in the lower
120      * half order, and the `v` value to be either 27 or 28.
121      *
122      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
123      * verification to be secure: it is possible to craft signatures that
124      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
125      * this is by receiving a hash of the original message (which may otherwise
126      * be too long), and then calling {toEthSignedMessageHash} on it.
127      *
128      * Documentation for signature generation:
129      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
130      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
131      *
132      * _Available since v4.3._
133      */
134     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
135         if (signature.length == 65) {
136             bytes32 r;
137             bytes32 s;
138             uint8 v;
139             // ecrecover takes the signature parameters, and the only way to get them
140             // currently is to use assembly.
141             /// @solidity memory-safe-assembly
142             assembly {
143                 r := mload(add(signature, 0x20))
144                 s := mload(add(signature, 0x40))
145                 v := byte(0, mload(add(signature, 0x60)))
146             }
147             return tryRecover(hash, v, r, s);
148         } else {
149             return (address(0), RecoverError.InvalidSignatureLength);
150         }
151     }
152 
153     /**
154      * @dev Returns the address that signed a hashed message (`hash`) with
155      * `signature`. This address can then be used for verification purposes.
156      *
157      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
158      * this function rejects them by requiring the `s` value to be in the lower
159      * half order, and the `v` value to be either 27 or 28.
160      *
161      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
162      * verification to be secure: it is possible to craft signatures that
163      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
164      * this is by receiving a hash of the original message (which may otherwise
165      * be too long), and then calling {toEthSignedMessageHash} on it.
166      */
167     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
168         (address recovered, RecoverError error) = tryRecover(hash, signature);
169         _throwError(error);
170         return recovered;
171     }
172 
173     /**
174      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
175      *
176      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
177      *
178      * _Available since v4.3._
179      */
180     function tryRecover(
181         bytes32 hash,
182         bytes32 r,
183         bytes32 vs
184     ) internal pure returns (address, RecoverError) {
185         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
186         uint8 v = uint8((uint256(vs) >> 255) + 27);
187         return tryRecover(hash, v, r, s);
188     }
189 
190     /**
191      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
192      *
193      * _Available since v4.2._
194      */
195     function recover(
196         bytes32 hash,
197         bytes32 r,
198         bytes32 vs
199     ) internal pure returns (address) {
200         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
201         _throwError(error);
202         return recovered;
203     }
204 
205     /**
206      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
207      * `r` and `s` signature fields separately.
208      *
209      * _Available since v4.3._
210      */
211     function tryRecover(
212         bytes32 hash,
213         uint8 v,
214         bytes32 r,
215         bytes32 s
216     ) internal pure returns (address, RecoverError) {
217         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
218         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
219         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
220         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
221         //
222         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
223         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
224         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
225         // these malleable signatures as well.
226         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
227             return (address(0), RecoverError.InvalidSignatureS);
228         }
229 
230         // If the signature is valid (and not malleable), return the signer address
231         address signer = ecrecover(hash, v, r, s);
232         if (signer == address(0)) {
233             return (address(0), RecoverError.InvalidSignature);
234         }
235 
236         return (signer, RecoverError.NoError);
237     }
238 
239     /**
240      * @dev Overload of {ECDSA-recover} that receives the `v`,
241      * `r` and `s` signature fields separately.
242      */
243     function recover(
244         bytes32 hash,
245         uint8 v,
246         bytes32 r,
247         bytes32 s
248     ) internal pure returns (address) {
249         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
250         _throwError(error);
251         return recovered;
252     }
253 
254     /**
255      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
256      * produces hash corresponding to the one signed with the
257      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
258      * JSON-RPC method as part of EIP-191.
259      *
260      * See {recover}.
261      */
262     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
263         // 32 is the length in bytes of hash,
264         // enforced by the type signature above
265         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
266     }
267 
268     /**
269      * @dev Returns an Ethereum Signed Message, created from `s`. This
270      * produces hash corresponding to the one signed with the
271      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
272      * JSON-RPC method as part of EIP-191.
273      *
274      * See {recover}.
275      */
276     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
277         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
278     }
279 
280     /**
281      * @dev Returns an Ethereum Signed Typed Data, created from a
282      * `domainSeparator` and a `structHash`. This produces hash corresponding
283      * to the one signed with the
284      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
285      * JSON-RPC method as part of EIP-712.
286      *
287      * See {recover}.
288      */
289     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
290         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
291     }
292 }
293 
294 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 /**
302  * @dev Interface of the ERC165 standard, as defined in the
303  * https://eips.ethereum.org/EIPS/eip-165[EIP].
304  *
305  * Implementers can declare support of contract interfaces, which can then be
306  * queried by others ({ERC165Checker}).
307  *
308  * For an implementation, see {ERC165}.
309  */
310 interface IERC165 {
311     /**
312      * @dev Returns true if this contract implements the interface defined by
313      * `interfaceId`. See the corresponding
314      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
315      * to learn more about how these ids are created.
316      *
317      * This function call must use less than 30 000 gas.
318      */
319     function supportsInterface(bytes4 interfaceId) external view returns (bool);
320 }
321 
322 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
323 
324 
325 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
326 
327 pragma solidity ^0.8.0;
328 
329 
330 /**
331  * @dev Implementation of the {IERC165} interface.
332  *
333  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
334  * for the additional interface id that will be supported. For example:
335  *
336  * ```solidity
337  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
338  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
339  * }
340  * ```
341  *
342  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
343  */
344 abstract contract ERC165 is IERC165 {
345     /**
346      * @dev See {IERC165-supportsInterface}.
347      */
348     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
349         return interfaceId == type(IERC165).interfaceId;
350     }
351 }
352 
353 // File: @openzeppelin/contracts/interfaces/IERC2981.sol
354 
355 
356 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
357 
358 pragma solidity ^0.8.0;
359 
360 
361 /**
362  * @dev Interface for the NFT Royalty Standard.
363  *
364  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
365  * support for royalty payments across all NFT marketplaces and ecosystem participants.
366  *
367  * _Available since v4.5._
368  */
369 interface IERC2981 is IERC165 {
370     /**
371      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
372      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
373      */
374     function royaltyInfo(uint256 tokenId, uint256 salePrice)
375         external
376         view
377         returns (address receiver, uint256 royaltyAmount);
378 }
379 
380 // File: @openzeppelin/contracts/token/common/ERC2981.sol
381 
382 
383 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
384 
385 pragma solidity ^0.8.0;
386 
387 
388 
389 /**
390  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
391  *
392  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
393  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
394  *
395  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
396  * fee is specified in basis points by default.
397  *
398  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
399  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
400  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
401  *
402  * _Available since v4.5._
403  */
404 abstract contract ERC2981 is IERC2981, ERC165 {
405     struct RoyaltyInfo {
406         address receiver;
407         uint96 royaltyFraction;
408     }
409 
410     RoyaltyInfo private _defaultRoyaltyInfo;
411     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
412 
413     /**
414      * @dev See {IERC165-supportsInterface}.
415      */
416     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
417         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
418     }
419 
420     /**
421      * @inheritdoc IERC2981
422      */
423     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
424         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
425 
426         if (royalty.receiver == address(0)) {
427             royalty = _defaultRoyaltyInfo;
428         }
429 
430         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
431 
432         return (royalty.receiver, royaltyAmount);
433     }
434 
435     /**
436      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
437      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
438      * override.
439      */
440     function _feeDenominator() internal pure virtual returns (uint96) {
441         return 10000;
442     }
443 
444     /**
445      * @dev Sets the royalty information that all ids in this contract will default to.
446      *
447      * Requirements:
448      *
449      * - `receiver` cannot be the zero address.
450      * - `feeNumerator` cannot be greater than the fee denominator.
451      */
452     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
453         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
454         require(receiver != address(0), "ERC2981: invalid receiver");
455 
456         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
457     }
458 
459     /**
460      * @dev Removes default royalty information.
461      */
462     function _deleteDefaultRoyalty() internal virtual {
463         delete _defaultRoyaltyInfo;
464     }
465 
466     /**
467      * @dev Sets the royalty information for a specific token id, overriding the global default.
468      *
469      * Requirements:
470      *
471      * - `receiver` cannot be the zero address.
472      * - `feeNumerator` cannot be greater than the fee denominator.
473      */
474     function _setTokenRoyalty(
475         uint256 tokenId,
476         address receiver,
477         uint96 feeNumerator
478     ) internal virtual {
479         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
480         require(receiver != address(0), "ERC2981: Invalid parameters");
481 
482         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
483     }
484 
485     /**
486      * @dev Resets royalty information for the token id back to the global default.
487      */
488     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
489         delete _tokenRoyaltyInfo[tokenId];
490     }
491 }
492 
493 // File: @openzeppelin/contracts/utils/Context.sol
494 
495 
496 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
497 
498 pragma solidity ^0.8.0;
499 
500 /**
501  * @dev Provides information about the current execution context, including the
502  * sender of the transaction and its data. While these are generally available
503  * via msg.sender and msg.data, they should not be accessed in such a direct
504  * manner, since when dealing with meta-transactions the account sending and
505  * paying for execution may not be the actual sender (as far as an application
506  * is concerned).
507  *
508  * This contract is only required for intermediate, library-like contracts.
509  */
510 abstract contract Context {
511     function _msgSender() internal view virtual returns (address) {
512         return msg.sender;
513     }
514 
515     function _msgData() internal view virtual returns (bytes calldata) {
516         return msg.data;
517     }
518 }
519 
520 // File: @openzeppelin/contracts/access/Ownable.sol
521 
522 
523 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
524 
525 pragma solidity ^0.8.0;
526 
527 
528 /**
529  * @dev Contract module which provides a basic access control mechanism, where
530  * there is an account (an owner) that can be granted exclusive access to
531  * specific functions.
532  *
533  * By default, the owner account will be the one that deploys the contract. This
534  * can later be changed with {transferOwnership}.
535  *
536  * This module is used through inheritance. It will make available the modifier
537  * `onlyOwner`, which can be applied to your functions to restrict their use to
538  * the owner.
539  */
540 abstract contract Ownable is Context {
541     address private _owner;
542 
543     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
544 
545     /**
546      * @dev Initializes the contract setting the deployer as the initial owner.
547      */
548     constructor() {
549         _transferOwnership(_msgSender());
550     }
551 
552     /**
553      * @dev Throws if called by any account other than the owner.
554      */
555     modifier onlyOwner() {
556         _checkOwner();
557         _;
558     }
559 
560     /**
561      * @dev Returns the address of the current owner.
562      */
563     function owner() public view virtual returns (address) {
564         return _owner;
565     }
566 
567     /**
568      * @dev Throws if the sender is not the owner.
569      */
570     function _checkOwner() internal view virtual {
571         require(owner() == _msgSender(), "Ownable: caller is not the owner");
572     }
573 
574     /**
575      * @dev Leaves the contract without owner. It will not be possible to call
576      * `onlyOwner` functions anymore. Can only be called by the current owner.
577      *
578      * NOTE: Renouncing ownership will leave the contract without an owner,
579      * thereby removing any functionality that is only available to the owner.
580      */
581     function renounceOwnership() public virtual onlyOwner {
582         _transferOwnership(address(0));
583     }
584 
585     /**
586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
587      * Can only be called by the current owner.
588      */
589     function transferOwnership(address newOwner) public virtual onlyOwner {
590         require(newOwner != address(0), "Ownable: new owner is the zero address");
591         _transferOwnership(newOwner);
592     }
593 
594     /**
595      * @dev Transfers ownership of the contract to a new account (`newOwner`).
596      * Internal function without access restriction.
597      */
598     function _transferOwnership(address newOwner) internal virtual {
599         address oldOwner = _owner;
600         _owner = newOwner;
601         emit OwnershipTransferred(oldOwner, newOwner);
602     }
603 }
604 
605 // File: MonaLisa330.sol
606 
607 
608 
609 pragma solidity ^0.8.0;
610 
611 
612 
613 
614 
615 
616 /**
617  * @dev Interface of ERC721A.
618  */
619 interface IERC721A {
620     /**
621      * The caller must own the token or be an approved operator.
622      */
623     error ApprovalCallerNotOwnerNorApproved();
624 
625     /**
626      * The token does not exist.
627      */
628     error ApprovalQueryForNonexistentToken();
629 
630     /**
631      * Cannot query the balance for the zero address.
632      */
633     error BalanceQueryForZeroAddress();
634 
635     /**
636      * Cannot mint to the zero address.
637      */
638     error MintToZeroAddress();
639 
640     /**
641      * The quantity of tokens minted must be more than zero.
642      */
643     error MintZeroQuantity();
644 
645     /**
646      * The token does not exist.
647      */
648     error OwnerQueryForNonexistentToken();
649 
650     /**
651      * The caller must own the token or be an approved operator.
652      */
653     error TransferCallerNotOwnerNorApproved();
654 
655     /**
656      * The token must be owned by `from`.
657      */
658     error TransferFromIncorrectOwner();
659 
660     /**
661      * Cannot safely transfer to a contract that does not implement the
662      * ERC721Receiver interface.
663      */
664     error TransferToNonERC721ReceiverImplementer();
665 
666     /**
667      * Cannot transfer to the zero address.
668      */
669     error TransferToZeroAddress();
670 
671     /**
672      * The token does not exist.
673      */
674     error URIQueryForNonexistentToken();
675 
676     /**
677      * The `quantity` minted with ERC2309 exceeds the safety limit.
678      */
679     error MintERC2309QuantityExceedsLimit();
680 
681     /**
682      * The `extraData` cannot be set on an unintialized ownership slot.
683      */
684     error OwnershipNotInitializedForExtraData();
685 
686     // =============================================================
687     //                            STRUCTS
688     // =============================================================
689 
690     struct TokenOwnership {
691         // The address of the owner.
692         address addr;
693         // Stores the start time of ownership with minimal overhead for tokenomics.
694         uint64 startTimestamp;
695         // Whether the token has been burned.
696         bool burned;
697         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
698         uint24 extraData;
699     }
700 
701     // =============================================================
702     //                         TOKEN COUNTERS
703     // =============================================================
704 
705     /**
706      * @dev Returns the total number of tokens in existence.
707      * Burned tokens will reduce the count.
708      * To get the total number of tokens minted, please see {_totalMinted}.
709      */
710     function totalSupply() external view returns (uint256);
711 
712     // =============================================================
713     //                            IERC165
714     // =============================================================
715 
716     /**
717      * @dev Returns true if this contract implements the interface defined by
718      * `interfaceId`. See the corresponding
719      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
720      * to learn more about how these ids are created.
721      *
722      * This function call must use less than 30000 gas.
723      */
724     function supportsInterface(bytes4 interfaceId) external view returns (bool);
725 
726     // =============================================================
727     //                            IERC721
728     // =============================================================
729 
730     /**
731      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
732      */
733     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
734 
735     /**
736      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
737      */
738     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
739 
740     /**
741      * @dev Emitted when `owner` enables or disables
742      * (`approved`) `operator` to manage all of its assets.
743      */
744     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
745 
746     /**
747      * @dev Returns the number of tokens in `owner`'s account.
748      */
749     function balanceOf(address owner) external view returns (uint256 balance);
750 
751     /**
752      * @dev Returns the owner of the `tokenId` token.
753      *
754      * Requirements:
755      *
756      * - `tokenId` must exist.
757      */
758     function ownerOf(uint256 tokenId) external view returns (address owner);
759 
760     /**
761      * @dev Safely transfers `tokenId` token from `from` to `to`,
762      * checking first that contract recipients are aware of the ERC721 protocol
763      * to prevent tokens from being forever locked.
764      *
765      * Requirements:
766      *
767      * - `from` cannot be the zero address.
768      * - `to` cannot be the zero address.
769      * - `tokenId` token must exist and be owned by `from`.
770      * - If the caller is not `from`, it must be have been allowed to move
771      * this token by either {approve} or {setApprovalForAll}.
772      * - If `to` refers to a smart contract, it must implement
773      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
774      *
775      * Emits a {Transfer} event.
776      */
777     function safeTransferFrom(
778         address from,
779         address to,
780         uint256 tokenId,
781         bytes calldata data
782     ) external payable;
783 
784     /**
785      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
786      */
787     function safeTransferFrom(
788         address from,
789         address to,
790         uint256 tokenId
791     ) external payable;
792 
793     /**
794      * @dev Transfers `tokenId` from `from` to `to`.
795      *
796      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
797      * whenever possible.
798      *
799      * Requirements:
800      *
801      * - `from` cannot be the zero address.
802      * - `to` cannot be the zero address.
803      * - `tokenId` token must be owned by `from`.
804      * - If the caller is not `from`, it must be approved to move this token
805      * by either {approve} or {setApprovalForAll}.
806      *
807      * Emits a {Transfer} event.
808      */
809     function transferFrom(
810         address from,
811         address to,
812         uint256 tokenId
813     ) external payable;
814 
815     /**
816      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
817      * The approval is cleared when the token is transferred.
818      *
819      * Only a single account can be approved at a time, so approving the
820      * zero address clears previous approvals.
821      *
822      * Requirements:
823      *
824      * - The caller must own the token or be an approved operator.
825      * - `tokenId` must exist.
826      *
827      * Emits an {Approval} event.
828      */
829     function approve(address to, uint256 tokenId) external payable;
830 
831     /**
832      * @dev Approve or remove `operator` as an operator for the caller.
833      * Operators can call {transferFrom} or {safeTransferFrom}
834      * for any token owned by the caller.
835      *
836      * Requirements:
837      *
838      * - The `operator` cannot be the caller.
839      *
840      * Emits an {ApprovalForAll} event.
841      */
842     function setApprovalForAll(address operator, bool _approved) external;
843 
844     /**
845      * @dev Returns the account approved for `tokenId` token.
846      *
847      * Requirements:
848      *
849      * - `tokenId` must exist.
850      */
851     function getApproved(uint256 tokenId) external view returns (address operator);
852 
853     /**
854      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
855      *
856      * See {setApprovalForAll}.
857      */
858     function isApprovedForAll(address owner, address operator) external view returns (bool);
859 
860     // =============================================================
861     //                        IERC721Metadata
862     // =============================================================
863 
864     /**
865      * @dev Returns the token collection name.
866      */
867     function name() external view returns (string memory);
868 
869     /**
870      * @dev Returns the token collection symbol.
871      */
872     function symbol() external view returns (string memory);
873 
874     /**
875      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
876      */
877     function tokenURI(uint256 tokenId) external view returns (string memory);
878 
879     // =============================================================
880     //                           IERC2309
881     // =============================================================
882 
883     /**
884      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
885      * (inclusive) is transferred from `from` to `to`, as defined in the
886      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
887      *
888      * See {_mintERC2309} for more details.
889      */
890     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
891 }
892 
893 /**
894  * @dev Interface of ERC721 token receiver.
895  */
896 interface ERC721A__IERC721Receiver {
897     function onERC721Received(
898         address operator,
899         address from,
900         uint256 tokenId,
901         bytes calldata data
902     ) external returns (bytes4);
903 }
904 
905 /**
906  * @title ERC721A
907  *
908  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
909  * Non-Fungible Token Standard, including the Metadata extension.
910  * Optimized for lower gas during batch mints.
911  *
912  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
913  * starting from `_startTokenId()`.
914  *
915  * Assumptions:
916  *
917  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
918  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
919  */
920 contract ERC721A is IERC721A {
921     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
922     struct TokenApprovalRef {
923         address value;
924     }
925 
926     // =============================================================
927     //                           CONSTANTS
928     // =============================================================
929 
930     // Mask of an entry in packed address data.
931     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
932 
933     // The bit position of `numberMinted` in packed address data.
934     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
935 
936     // The bit position of `numberBurned` in packed address data.
937     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
938 
939     // The bit position of `aux` in packed address data.
940     uint256 private constant _BITPOS_AUX = 192;
941 
942     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
943     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
944 
945     // The bit position of `startTimestamp` in packed ownership.
946     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
947 
948     // The bit mask of the `burned` bit in packed ownership.
949     uint256 private constant _BITMASK_BURNED = 1 << 224;
950 
951     // The bit position of the `nextInitialized` bit in packed ownership.
952     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
953 
954     // The bit mask of the `nextInitialized` bit in packed ownership.
955     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
956 
957     // The bit position of `extraData` in packed ownership.
958     uint256 private constant _BITPOS_EXTRA_DATA = 232;
959 
960     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
961     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
962 
963     // The mask of the lower 160 bits for addresses.
964     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
965 
966     // The maximum `quantity` that can be minted with {_mintERC2309}.
967     // This limit is to prevent overflows on the address data entries.
968     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
969     // is required to cause an overflow, which is unrealistic.
970     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
971 
972     // The `Transfer` event signature is given by:
973     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
974     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
975         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
976 
977     // =============================================================
978     //                            STORAGE
979     // =============================================================
980 
981     // The next token ID to be minted.
982     uint256 private _currentIndex;
983 
984     // The number of tokens burned.
985     uint256 private _burnCounter;
986 
987     // Token name
988     string private _name;
989 
990     // Token symbol
991     string private _symbol;
992 
993     // Mapping from token ID to ownership details
994     // An empty struct value does not necessarily mean the token is unowned.
995     // See {_packedOwnershipOf} implementation for details.
996     //
997     // Bits Layout:
998     // - [0..159]   `addr`
999     // - [160..223] `startTimestamp`
1000     // - [224]      `burned`
1001     // - [225]      `nextInitialized`
1002     // - [232..255] `extraData`
1003     mapping(uint256 => uint256) private _packedOwnerships;
1004 
1005     // Mapping owner address to address data.
1006     //
1007     // Bits Layout:
1008     // - [0..63]    `balance`
1009     // - [64..127]  `numberMinted`
1010     // - [128..191] `numberBurned`
1011     // - [192..255] `aux`
1012     mapping(address => uint256) private _packedAddressData;
1013 
1014     // Mapping from token ID to approved address.
1015     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1016 
1017     // Mapping from owner to operator approvals
1018     mapping(address => mapping(address => bool)) private _operatorApprovals;
1019 
1020     // =============================================================
1021     //                          CONSTRUCTOR
1022     // =============================================================
1023 
1024     constructor(string memory name_, string memory symbol_) {
1025         _name = name_;
1026         _symbol = symbol_;
1027         _currentIndex = _startTokenId();
1028     }
1029 
1030     // =============================================================
1031     //                   TOKEN COUNTING OPERATIONS
1032     // =============================================================
1033 
1034     /**
1035      * @dev Returns the starting token ID.
1036      * To change the starting token ID, please override this function.
1037      */
1038     function _startTokenId() internal view virtual returns (uint256) {
1039         return 1;
1040     }
1041 
1042     /**
1043      * @dev Returns the next token ID to be minted.
1044      */
1045     function _nextTokenId() internal view virtual returns (uint256) {
1046         return _currentIndex;
1047     }
1048 
1049     /**
1050      * @dev Returns the total number of tokens in existence.
1051      * Burned tokens will reduce the count.
1052      * To get the total number of tokens minted, please see {_totalMinted}.
1053      */
1054     function totalSupply() public view virtual override returns (uint256) {
1055         // Counter underflow is impossible as _burnCounter cannot be incremented
1056         // more than `_currentIndex - _startTokenId()` times.
1057         unchecked {
1058             return _currentIndex - _burnCounter - _startTokenId();
1059         }
1060     }
1061 
1062     /**
1063      * @dev Returns the total amount of tokens minted in the contract.
1064      */
1065     function _totalMinted() internal view virtual returns (uint256) {
1066         // Counter underflow is impossible as `_currentIndex` does not decrement,
1067         // and it is initialized to `_startTokenId()`.
1068         unchecked {
1069             return _currentIndex - _startTokenId();
1070         }
1071     }
1072 
1073     /**
1074      * @dev Returns the total number of tokens burned.
1075      */
1076     function _totalBurned() internal view virtual returns (uint256) {
1077         return _burnCounter;
1078     }
1079 
1080     // =============================================================
1081     //                    ADDRESS DATA OPERATIONS
1082     // =============================================================
1083 
1084     /**
1085      * @dev Returns the number of tokens in `owner`'s account.
1086      */
1087     function balanceOf(address owner) public view virtual override returns (uint256) {
1088         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1089         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1090     }
1091 
1092     /**
1093      * Returns the number of tokens minted by `owner`.
1094      */
1095     function _numberMinted(address owner) internal view returns (uint256) {
1096         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1097     }
1098 
1099     /**
1100      * Returns the number of tokens burned by or on behalf of `owner`.
1101      */
1102     function _numberBurned(address owner) internal view returns (uint256) {
1103         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1104     }
1105 
1106     /**
1107      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1108      */
1109     function _getAux(address owner) internal view returns (uint64) {
1110         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1111     }
1112 
1113     /**
1114      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1115      * If there are multiple variables, please pack them into a uint64.
1116      */
1117     function _setAux(address owner, uint64 aux) internal virtual {
1118         uint256 packed = _packedAddressData[owner];
1119         uint256 auxCasted;
1120         // Cast `aux` with assembly to avoid redundant masking.
1121         assembly {
1122             auxCasted := aux
1123         }
1124         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1125         _packedAddressData[owner] = packed;
1126     }
1127 
1128     // =============================================================
1129     //                            IERC165
1130     // =============================================================
1131 
1132     /**
1133      * @dev Returns true if this contract implements the interface defined by
1134      * `interfaceId`. See the corresponding
1135      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1136      * to learn more about how these ids are created.
1137      *
1138      * This function call must use less than 30000 gas.
1139      */
1140     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1141         // The interface IDs are constants representing the first 4 bytes
1142         // of the XOR of all function selectors in the interface.
1143         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1144         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1145         return
1146             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1147             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1148             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1149     }
1150 
1151     // =============================================================
1152     //                        IERC721Metadata
1153     // =============================================================
1154 
1155     /**
1156      * @dev Returns the token collection name.
1157      */
1158     function name() public view virtual override returns (string memory) {
1159         return _name;
1160     }
1161 
1162     /**
1163      * @dev Returns the token collection symbol.
1164      */
1165     function symbol() public view virtual override returns (string memory) {
1166         return _symbol;
1167     }
1168 
1169     /**
1170      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1171      */
1172     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1173         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1174 
1175         string memory baseURI = _baseURI();
1176         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1177     }
1178 
1179     /**
1180      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1181      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1182      * by default, it can be overridden in child contracts.
1183      */
1184     function _baseURI() internal view virtual returns (string memory) {
1185         return '';
1186     }
1187 
1188     // =============================================================
1189     //                     OWNERSHIPS OPERATIONS
1190     // =============================================================
1191 
1192     /**
1193      * @dev Returns the owner of the `tokenId` token.
1194      *
1195      * Requirements:
1196      *
1197      * - `tokenId` must exist.
1198      */
1199     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1200         return address(uint160(_packedOwnershipOf(tokenId)));
1201     }
1202 
1203     /**
1204      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1205      * It gradually moves to O(1) as tokens get transferred around over time.
1206      */
1207     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1208         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1209     }
1210 
1211     /**
1212      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1213      */
1214     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1215         return _unpackedOwnership(_packedOwnerships[index]);
1216     }
1217 
1218     /**
1219      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1220      */
1221     function _initializeOwnershipAt(uint256 index) internal virtual {
1222         if (_packedOwnerships[index] == 0) {
1223             _packedOwnerships[index] = _packedOwnershipOf(index);
1224         }
1225     }
1226 
1227     /**
1228      * Returns the packed ownership data of `tokenId`.
1229      */
1230     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1231         uint256 curr = tokenId;
1232 
1233         unchecked {
1234             if (_startTokenId() <= curr)
1235                 if (curr < _currentIndex) {
1236                     uint256 packed = _packedOwnerships[curr];
1237                     // If not burned.
1238                     if (packed & _BITMASK_BURNED == 0) {
1239                         // Invariant:
1240                         // There will always be an initialized ownership slot
1241                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1242                         // before an unintialized ownership slot
1243                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1244                         // Hence, `curr` will not underflow.
1245                         //
1246                         // We can directly compare the packed value.
1247                         // If the address is zero, packed will be zero.
1248                         while (packed == 0) {
1249                             packed = _packedOwnerships[--curr];
1250                         }
1251                         return packed;
1252                     }
1253                 }
1254         }
1255         revert OwnerQueryForNonexistentToken();
1256     }
1257 
1258     /**
1259      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1260      */
1261     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1262         ownership.addr = address(uint160(packed));
1263         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1264         ownership.burned = packed & _BITMASK_BURNED != 0;
1265         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1266     }
1267 
1268     /**
1269      * @dev Packs ownership data into a single uint256.
1270      */
1271     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1272         assembly {
1273             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1274             owner := and(owner, _BITMASK_ADDRESS)
1275             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1276             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1277         }
1278     }
1279 
1280     /**
1281      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1282      */
1283     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1284         // For branchless setting of the `nextInitialized` flag.
1285         assembly {
1286             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1287             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1288         }
1289     }
1290 
1291     // =============================================================
1292     //                      APPROVAL OPERATIONS
1293     // =============================================================
1294 
1295     /**
1296      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1297      * The approval is cleared when the token is transferred.
1298      *
1299      * Only a single account can be approved at a time, so approving the
1300      * zero address clears previous approvals.
1301      *
1302      * Requirements:
1303      *
1304      * - The caller must own the token or be an approved operator.
1305      * - `tokenId` must exist.
1306      *
1307      * Emits an {Approval} event.
1308      */
1309     function approve(address to, uint256 tokenId) public payable virtual override {
1310         address owner = ownerOf(tokenId);
1311 
1312         if (_msgSenderERC721A() != owner)
1313             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1314                 revert ApprovalCallerNotOwnerNorApproved();
1315             }
1316 
1317         _tokenApprovals[tokenId].value = to;
1318         emit Approval(owner, to, tokenId);
1319     }
1320 
1321     /**
1322      * @dev Returns the account approved for `tokenId` token.
1323      *
1324      * Requirements:
1325      *
1326      * - `tokenId` must exist.
1327      */
1328     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1329         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1330 
1331         return _tokenApprovals[tokenId].value;
1332     }
1333 
1334     /**
1335      * @dev Approve or remove `operator` as an operator for the caller.
1336      * Operators can call {transferFrom} or {safeTransferFrom}
1337      * for any token owned by the caller.
1338      *
1339      * Requirements:
1340      *
1341      * - The `operator` cannot be the caller.
1342      *
1343      * Emits an {ApprovalForAll} event.
1344      */
1345     function setApprovalForAll(address operator, bool approved) public virtual override {
1346         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1347         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1348     }
1349 
1350     /**
1351      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1352      *
1353      * See {setApprovalForAll}.
1354      */
1355     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1356         return _operatorApprovals[owner][operator];
1357     }
1358 
1359     /**
1360      * @dev Returns whether `tokenId` exists.
1361      *
1362      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1363      *
1364      * Tokens start existing when they are minted. See {_mint}.
1365      */
1366     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1367         return
1368             _startTokenId() <= tokenId &&
1369             tokenId < _currentIndex && // If within bounds,
1370             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1371     }
1372 
1373     /**
1374      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1375      */
1376     function _isSenderApprovedOrOwner(
1377         address approvedAddress,
1378         address owner,
1379         address msgSender
1380     ) private pure returns (bool result) {
1381         assembly {
1382             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1383             owner := and(owner, _BITMASK_ADDRESS)
1384             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1385             msgSender := and(msgSender, _BITMASK_ADDRESS)
1386             // `msgSender == owner || msgSender == approvedAddress`.
1387             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1388         }
1389     }
1390 
1391     /**
1392      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1393      */
1394     function _getApprovedSlotAndAddress(uint256 tokenId)
1395         private
1396         view
1397         returns (uint256 approvedAddressSlot, address approvedAddress)
1398     {
1399         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1400         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1401         assembly {
1402             approvedAddressSlot := tokenApproval.slot
1403             approvedAddress := sload(approvedAddressSlot)
1404         }
1405     }
1406 
1407     // =============================================================
1408     //                      TRANSFER OPERATIONS
1409     // =============================================================
1410 
1411     /**
1412      * @dev Transfers `tokenId` from `from` to `to`.
1413      *
1414      * Requirements:
1415      *
1416      * - `from` cannot be the zero address.
1417      * - `to` cannot be the zero address.
1418      * - `tokenId` token must be owned by `from`.
1419      * - If the caller is not `from`, it must be approved to move this token
1420      * by either {approve} or {setApprovalForAll}.
1421      *
1422      * Emits a {Transfer} event.
1423      */
1424     function transferFrom(
1425         address from,
1426         address to,
1427         uint256 tokenId
1428     ) public payable virtual override {
1429         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1430 
1431         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1432 
1433         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1434 
1435         // The nested ifs save around 20+ gas over a compound boolean condition.
1436         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1437             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1438 
1439         if (to == address(0)) revert TransferToZeroAddress();
1440 
1441         _beforeTokenTransfers(from, to, tokenId, 1);
1442 
1443         // Clear approvals from the previous owner.
1444         assembly {
1445             if approvedAddress {
1446                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1447                 sstore(approvedAddressSlot, 0)
1448             }
1449         }
1450 
1451         // Underflow of the sender's balance is impossible because we check for
1452         // ownership above and the recipient's balance can't realistically overflow.
1453         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1454         unchecked {
1455             // We can directly increment and decrement the balances.
1456             --_packedAddressData[from]; // Updates: `balance -= 1`.
1457             ++_packedAddressData[to]; // Updates: `balance += 1`.
1458 
1459             // Updates:
1460             // - `address` to the next owner.
1461             // - `startTimestamp` to the timestamp of transfering.
1462             // - `burned` to `false`.
1463             // - `nextInitialized` to `true`.
1464             _packedOwnerships[tokenId] = _packOwnershipData(
1465                 to,
1466                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1467             );
1468 
1469             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1470             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1471                 uint256 nextTokenId = tokenId + 1;
1472                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1473                 if (_packedOwnerships[nextTokenId] == 0) {
1474                     // If the next slot is within bounds.
1475                     if (nextTokenId != _currentIndex) {
1476                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1477                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1478                     }
1479                 }
1480             }
1481         }
1482 
1483         emit Transfer(from, to, tokenId);
1484         _afterTokenTransfers(from, to, tokenId, 1);
1485     }
1486 
1487     /**
1488      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1489      */
1490     function safeTransferFrom(
1491         address from,
1492         address to,
1493         uint256 tokenId
1494     ) public payable virtual override {
1495         safeTransferFrom(from, to, tokenId, '');
1496     }
1497 
1498     /**
1499      * @dev Safely transfers `tokenId` token from `from` to `to`.
1500      *
1501      * Requirements:
1502      *
1503      * - `from` cannot be the zero address.
1504      * - `to` cannot be the zero address.
1505      * - `tokenId` token must exist and be owned by `from`.
1506      * - If the caller is not `from`, it must be approved to move this token
1507      * by either {approve} or {setApprovalForAll}.
1508      * - If `to` refers to a smart contract, it must implement
1509      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1510      *
1511      * Emits a {Transfer} event.
1512      */
1513     function safeTransferFrom(
1514         address from,
1515         address to,
1516         uint256 tokenId,
1517         bytes memory _data
1518     ) public payable virtual override {
1519         transferFrom(from, to, tokenId);
1520         if (to.code.length != 0)
1521             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1522                 revert TransferToNonERC721ReceiverImplementer();
1523             }
1524     }
1525 
1526     /**
1527      * @dev Hook that is called before a set of serially-ordered token IDs
1528      * are about to be transferred. This includes minting.
1529      * And also called before burning one token.
1530      *
1531      * `startTokenId` - the first token ID to be transferred.
1532      * `quantity` - the amount to be transferred.
1533      *
1534      * Calling conditions:
1535      *
1536      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1537      * transferred to `to`.
1538      * - When `from` is zero, `tokenId` will be minted for `to`.
1539      * - When `to` is zero, `tokenId` will be burned by `from`.
1540      * - `from` and `to` are never both zero.
1541      */
1542     function _beforeTokenTransfers(
1543         address from,
1544         address to,
1545         uint256 startTokenId,
1546         uint256 quantity
1547     ) internal virtual {}
1548 
1549     /**
1550      * @dev Hook that is called after a set of serially-ordered token IDs
1551      * have been transferred. This includes minting.
1552      * And also called after one token has been burned.
1553      *
1554      * `startTokenId` - the first token ID to be transferred.
1555      * `quantity` - the amount to be transferred.
1556      *
1557      * Calling conditions:
1558      *
1559      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1560      * transferred to `to`.
1561      * - When `from` is zero, `tokenId` has been minted for `to`.
1562      * - When `to` is zero, `tokenId` has been burned by `from`.
1563      * - `from` and `to` are never both zero.
1564      */
1565     function _afterTokenTransfers(
1566         address from,
1567         address to,
1568         uint256 startTokenId,
1569         uint256 quantity
1570     ) internal virtual {}
1571 
1572     /**
1573      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1574      *
1575      * `from` - Previous owner of the given token ID.
1576      * `to` - Target address that will receive the token.
1577      * `tokenId` - Token ID to be transferred.
1578      * `_data` - Optional data to send along with the call.
1579      *
1580      * Returns whether the call correctly returned the expected magic value.
1581      */
1582     function _checkContractOnERC721Received(
1583         address from,
1584         address to,
1585         uint256 tokenId,
1586         bytes memory _data
1587     ) private returns (bool) {
1588         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1589             bytes4 retval
1590         ) {
1591             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1592         } catch (bytes memory reason) {
1593             if (reason.length == 0) {
1594                 revert TransferToNonERC721ReceiverImplementer();
1595             } else {
1596                 assembly {
1597                     revert(add(32, reason), mload(reason))
1598                 }
1599             }
1600         }
1601     }
1602 
1603     // =============================================================
1604     //                        MINT OPERATIONS
1605     // =============================================================
1606 
1607     /**
1608      * @dev Mints `quantity` tokens and transfers them to `to`.
1609      *
1610      * Requirements:
1611      *
1612      * - `to` cannot be the zero address.
1613      * - `quantity` must be greater than 0.
1614      *
1615      * Emits a {Transfer} event for each mint.
1616      */
1617     function _mint(address to, uint256 quantity) internal virtual {
1618         uint256 startTokenId = _currentIndex;
1619         if (quantity == 0) revert MintZeroQuantity();
1620 
1621         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1622 
1623         // Overflows are incredibly unrealistic.
1624         // `balance` and `numberMinted` have a maximum limit of 2**64.
1625         // `tokenId` has a maximum limit of 2**256.
1626         unchecked {
1627             // Updates:
1628             // - `balance += quantity`.
1629             // - `numberMinted += quantity`.
1630             //
1631             // We can directly add to the `balance` and `numberMinted`.
1632             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1633 
1634             // Updates:
1635             // - `address` to the owner.
1636             // - `startTimestamp` to the timestamp of minting.
1637             // - `burned` to `false`.
1638             // - `nextInitialized` to `quantity == 1`.
1639             _packedOwnerships[startTokenId] = _packOwnershipData(
1640                 to,
1641                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1642             );
1643 
1644             uint256 toMasked;
1645             uint256 end = startTokenId + quantity;
1646 
1647             // Use assembly to loop and emit the `Transfer` event for gas savings.
1648             // The duplicated `log4` removes an extra check and reduces stack juggling.
1649             // The assembly, together with the surrounding Solidity code, have been
1650             // delicately arranged to nudge the compiler into producing optimized opcodes.
1651             assembly {
1652                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1653                 toMasked := and(to, _BITMASK_ADDRESS)
1654                 // Emit the `Transfer` event.
1655                 log4(
1656                     0, // Start of data (0, since no data).
1657                     0, // End of data (0, since no data).
1658                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1659                     0, // `address(0)`.
1660                     toMasked, // `to`.
1661                     startTokenId // `tokenId`.
1662                 )
1663 
1664                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1665                 // that overflows uint256 will make the loop run out of gas.
1666                 // The compiler will optimize the `iszero` away for performance.
1667                 for {
1668                     let tokenId := add(startTokenId, 1)
1669                 } iszero(eq(tokenId, end)) {
1670                     tokenId := add(tokenId, 1)
1671                 } {
1672                     // Emit the `Transfer` event. Similar to above.
1673                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1674                 }
1675             }
1676             if (toMasked == 0) revert MintToZeroAddress();
1677 
1678             _currentIndex = end;
1679         }
1680         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1681     }
1682 
1683     /**
1684      * @dev Mints `quantity` tokens and transfers them to `to`.
1685      *
1686      * This function is intended for efficient minting only during contract creation.
1687      *
1688      * It emits only one {ConsecutiveTransfer} as defined in
1689      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1690      * instead of a sequence of {Transfer} event(s).
1691      *
1692      * Calling this function outside of contract creation WILL make your contract
1693      * non-compliant with the ERC721 standard.
1694      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1695      * {ConsecutiveTransfer} event is only permissible during contract creation.
1696      *
1697      * Requirements:
1698      *
1699      * - `to` cannot be the zero address.
1700      * - `quantity` must be greater than 0.
1701      *
1702      * Emits a {ConsecutiveTransfer} event.
1703      */
1704     function _mintERC2309(address to, uint256 quantity) internal virtual {
1705         uint256 startTokenId = _currentIndex;
1706         if (to == address(0)) revert MintToZeroAddress();
1707         if (quantity == 0) revert MintZeroQuantity();
1708         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1709 
1710         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1711 
1712         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1713         unchecked {
1714             // Updates:
1715             // - `balance += quantity`.
1716             // - `numberMinted += quantity`.
1717             //
1718             // We can directly add to the `balance` and `numberMinted`.
1719             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1720 
1721             // Updates:
1722             // - `address` to the owner.
1723             // - `startTimestamp` to the timestamp of minting.
1724             // - `burned` to `false`.
1725             // - `nextInitialized` to `quantity == 1`.
1726             _packedOwnerships[startTokenId] = _packOwnershipData(
1727                 to,
1728                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1729             );
1730 
1731             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1732 
1733             _currentIndex = startTokenId + quantity;
1734         }
1735         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1736     }
1737 
1738     /**
1739      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1740      *
1741      * Requirements:
1742      *
1743      * - If `to` refers to a smart contract, it must implement
1744      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1745      * - `quantity` must be greater than 0.
1746      *
1747      * See {_mint}.
1748      *
1749      * Emits a {Transfer} event for each mint.
1750      */
1751     function _safeMint(
1752         address to,
1753         uint256 quantity,
1754         bytes memory _data
1755     ) internal virtual {
1756         _mint(to, quantity);
1757 
1758         unchecked {
1759             if (to.code.length != 0) {
1760                 uint256 end = _currentIndex;
1761                 uint256 index = end - quantity;
1762                 do {
1763                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1764                         revert TransferToNonERC721ReceiverImplementer();
1765                     }
1766                 } while (index < end);
1767                 // Reentrancy protection.
1768                 if (_currentIndex != end) revert();
1769             }
1770         }
1771     }
1772 
1773     /**
1774      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1775      */
1776     function _safeMint(address to, uint256 quantity) internal virtual {
1777         _safeMint(to, quantity, '');
1778     }
1779 
1780     // =============================================================
1781     //                        BURN OPERATIONS
1782     // =============================================================
1783 
1784     /**
1785      * @dev Equivalent to `_burn(tokenId, false)`.
1786      */
1787     function _burn(uint256 tokenId) internal virtual {
1788         _burn(tokenId, false);
1789     }
1790 
1791     /**
1792      * @dev Destroys `tokenId`.
1793      * The approval is cleared when the token is burned.
1794      *
1795      * Requirements:
1796      *
1797      * - `tokenId` must exist.
1798      *
1799      * Emits a {Transfer} event.
1800      */
1801     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1802         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1803 
1804         address from = address(uint160(prevOwnershipPacked));
1805 
1806         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1807 
1808         if (approvalCheck) {
1809             // The nested ifs save around 20+ gas over a compound boolean condition.
1810             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1811                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1812         }
1813 
1814         _beforeTokenTransfers(from, address(0), tokenId, 1);
1815 
1816         // Clear approvals from the previous owner.
1817         assembly {
1818             if approvedAddress {
1819                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1820                 sstore(approvedAddressSlot, 0)
1821             }
1822         }
1823 
1824         // Underflow of the sender's balance is impossible because we check for
1825         // ownership above and the recipient's balance can't realistically overflow.
1826         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1827         unchecked {
1828             // Updates:
1829             // - `balance -= 1`.
1830             // - `numberBurned += 1`.
1831             //
1832             // We can directly decrement the balance, and increment the number burned.
1833             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1834             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1835 
1836             // Updates:
1837             // - `address` to the last owner.
1838             // - `startTimestamp` to the timestamp of burning.
1839             // - `burned` to `true`.
1840             // - `nextInitialized` to `true`.
1841             _packedOwnerships[tokenId] = _packOwnershipData(
1842                 from,
1843                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1844             );
1845 
1846             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1847             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1848                 uint256 nextTokenId = tokenId + 1;
1849                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1850                 if (_packedOwnerships[nextTokenId] == 0) {
1851                     // If the next slot is within bounds.
1852                     if (nextTokenId != _currentIndex) {
1853                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1854                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1855                     }
1856                 }
1857             }
1858         }
1859 
1860         emit Transfer(from, address(0), tokenId);
1861         _afterTokenTransfers(from, address(0), tokenId, 1);
1862 
1863         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1864         unchecked {
1865             _burnCounter++;
1866         }
1867     }
1868 
1869     // =============================================================
1870     //                     EXTRA DATA OPERATIONS
1871     // =============================================================
1872 
1873     /**
1874      * @dev Directly sets the extra data for the ownership data `index`.
1875      */
1876     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1877         uint256 packed = _packedOwnerships[index];
1878         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1879         uint256 extraDataCasted;
1880         // Cast `extraData` with assembly to avoid redundant masking.
1881         assembly {
1882             extraDataCasted := extraData
1883         }
1884         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1885         _packedOwnerships[index] = packed;
1886     }
1887 
1888     /**
1889      * @dev Called during each token transfer to set the 24bit `extraData` field.
1890      * Intended to be overridden by the cosumer contract.
1891      *
1892      * `previousExtraData` - the value of `extraData` before transfer.
1893      *
1894      * Calling conditions:
1895      *
1896      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1897      * transferred to `to`.
1898      * - When `from` is zero, `tokenId` will be minted for `to`.
1899      * - When `to` is zero, `tokenId` will be burned by `from`.
1900      * - `from` and `to` are never both zero.
1901      */
1902     function _extraData(
1903         address from,
1904         address to,
1905         uint24 previousExtraData
1906     ) internal view virtual returns (uint24) {}
1907 
1908     /**
1909      * @dev Returns the next extra data for the packed ownership data.
1910      * The returned result is shifted into position.
1911      */
1912     function _nextExtraData(
1913         address from,
1914         address to,
1915         uint256 prevOwnershipPacked
1916     ) private view returns (uint256) {
1917         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1918         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1919     }
1920 
1921     // =============================================================
1922     //                       OTHER OPERATIONS
1923     // =============================================================
1924 
1925     /**
1926      * @dev Returns the message sender (defaults to `msg.sender`).
1927      *
1928      * If you are writing GSN compatible contracts, you need to override this function.
1929      */
1930     function _msgSenderERC721A() internal view virtual returns (address) {
1931         return msg.sender;
1932     }
1933 
1934     /**
1935      * @dev Converts a uint256 to its ASCII string decimal representation.
1936      */
1937     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1938         assembly {
1939             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1940             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1941             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1942             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1943             let m := add(mload(0x40), 0xa0)
1944             // Update the free memory pointer to allocate.
1945             mstore(0x40, m)
1946             // Assign the `str` to the end.
1947             str := sub(m, 0x20)
1948             // Zeroize the slot after the string.
1949             mstore(str, 0)
1950 
1951             // Cache the end of the memory to calculate the length later.
1952             let end := str
1953 
1954             // We write the string from rightmost digit to leftmost digit.
1955             // The following is essentially a do-while loop that also handles the zero case.
1956             // prettier-ignore
1957             for { let temp := value } 1 {} {
1958                 str := sub(str, 1)
1959                 // Write the character to the pointer.
1960                 // The ASCII index of the '0' character is 48.
1961                 mstore8(str, add(48, mod(temp, 10)))
1962                 // Keep dividing `temp` until zero.
1963                 temp := div(temp, 10)
1964                 // prettier-ignore
1965                 if iszero(temp) { break }
1966             }
1967 
1968             let length := sub(end, str)
1969             // Move the pointer 32 bytes leftwards to make room for the length.
1970             str := sub(str, 0x20)
1971             // Store the length.
1972             mstore(str, length)
1973         }
1974     }
1975 }
1976 
1977 
1978 /// @notice Optimized and flexible operator filterer to abide to OpenSea's
1979 /// mandatory on-chain royalty enforcement in order for new collections to
1980 /// receive royalties.
1981 /// For more information, see:
1982 /// See: https://github.com/ProjectOpenSea/operator-filter-registry
1983 abstract contract OperatorFilterer {
1984     /// @dev The default OpenSea operator blocklist subscription.
1985     address internal constant _DEFAULT_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
1986 
1987     /// @dev The OpenSea operator filter registry.
1988     address internal constant _OPERATOR_FILTER_REGISTRY = 0x000000000000AAeB6D7670E522A718067333cd4E;
1989 
1990     /// @dev Registers the current contract to OpenSea's operator filter,
1991     /// and subscribe to the default OpenSea operator blocklist.
1992     /// Note: Will not revert nor update existing settings for repeated registration.
1993     function _registerForOperatorFiltering() internal virtual {
1994         _registerForOperatorFiltering(_DEFAULT_SUBSCRIPTION, true);
1995     }
1996 
1997     /// @dev Registers the current contract to OpenSea's operator filter.
1998     /// Note: Will not revert nor update existing settings for repeated registration.
1999     function _registerForOperatorFiltering(address subscriptionOrRegistrantToCopy, bool subscribe) internal virtual {
2000         /// @solidity memory-safe-assembly
2001         assembly {
2002             let functionSelector := 0x7d3e3dbe // `registerAndSubscribe(address,address)`.
2003 
2004             // Clean the upper 96 bits of `subscriptionOrRegistrantToCopy` in case they are dirty.
2005             subscriptionOrRegistrantToCopy := shr(96, shl(96, subscriptionOrRegistrantToCopy))
2006             // prettier-ignore
2007             for {} iszero(subscribe) {} {
2008                 if iszero(subscriptionOrRegistrantToCopy) {
2009                     functionSelector := 0x4420e486 // `register(address)`.
2010                     break
2011                 }
2012                 functionSelector := 0xa0af2903 // `registerAndCopyEntries(address,address)`.
2013                 break
2014             }
2015             // Store the function selector.
2016             mstore(0x00, shl(224, functionSelector))
2017             // Store the `address(this)`.
2018             mstore(0x04, address())
2019             // Store the `subscriptionOrRegistrantToCopy`.
2020             mstore(0x24, subscriptionOrRegistrantToCopy)
2021             // Register into the registry.
2022             pop(call(gas(), _OPERATOR_FILTER_REGISTRY, 0, 0x00, 0x44, 0x00, 0x00))
2023             // Restore the part of the free memory pointer that was overwritten,
2024             // which is guaranteed to be zero, because of Solidity's memory size limits.
2025             mstore(0x24, 0)
2026         }
2027     }
2028 
2029     /// @dev Modifier to guard a function and revert if `from` is a blocked operator.
2030     /// Can be turned on / off via `enabled`.
2031     /// For gas efficiency, you can use tight variable packing to efficiently read / write
2032     /// the boolean value for `enabled`.
2033     modifier onlyAllowedOperator(address from, bool enabled) virtual {
2034         /// @solidity memory-safe-assembly
2035         assembly {
2036             // This code prioritizes runtime gas costs on a chain with the registry.
2037             // As such, we will not use `extcodesize`, but rather abuse the behavior
2038             // of `staticcall` returning 1 when called on an empty / missing contract,
2039             // to avoid reverting when a chain does not have the registry.
2040 
2041             if enabled {
2042                 // Check if `from` is not equal to `msg.sender`,
2043                 // discarding the upper 96 bits of `from` in case they are dirty.
2044                 if iszero(eq(shr(96, shl(96, from)), caller())) {
2045                     // Store the function selector of `isOperatorAllowed(address,address)`,
2046                     // shifted left by 6 bytes, which is enough for 8tb of memory.
2047                     // We waste 6-3 = 3 bytes to save on 6 runtime gas (PUSH1 0x224 SHL).
2048                     mstore(0x00, 0xc6171134001122334455)
2049                     // Store the `address(this)`.
2050                     mstore(0x1a, address())
2051                     // Store the `msg.sender`.
2052                     mstore(0x3a, caller())
2053 
2054                     // `isOperatorAllowed` always returns true if it does not revert.
2055                     if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
2056                         // Bubble up the revert if the staticcall reverts.
2057                         returndatacopy(0x00, 0x00, returndatasize())
2058                         revert(0x00, returndatasize())
2059                     }
2060 
2061                     // We'll skip checking if `from` is inside the blacklist.
2062                     // Even though that can block transferring out of wrapper contracts,
2063                     // we don't want tokens to be stuck.
2064 
2065                     // Restore the part of the free memory pointer that was overwritten,
2066                     // which is guaranteed to be zero, if less than 8tb of memory is used.
2067                     mstore(0x3a, 0)
2068                 }
2069             }
2070         }
2071         _;
2072     }
2073 
2074     /// @dev Modifier to guard a function from approving a blocked operator.
2075     /// Can be turned on / off via `enabled`.
2076     /// For efficiency, you can use tight variable packing to efficiently read / write
2077     /// the boolean value for `enabled`.
2078     modifier onlyAllowedOperatorApproval(address operator, bool enabled) virtual {
2079         /// @solidity memory-safe-assembly
2080         assembly {
2081             // For more information on the optimization techniques used,
2082             // see the comments in `onlyAllowedOperator`.
2083 
2084             if enabled {
2085                 // Store the function selector of `isOperatorAllowed(address,address)`,
2086                 mstore(0x00, 0xc6171134001122334455)
2087                 // Store the `address(this)`.
2088                 mstore(0x1a, address())
2089                 // Store the `operator`, discarding the upper 96 bits in case they are dirty.
2090                 mstore(0x3a, shr(96, shl(96, operator)))
2091 
2092                 // `isOperatorAllowed` always returns true if it does not revert.
2093                 if iszero(staticcall(gas(), _OPERATOR_FILTER_REGISTRY, 0x16, 0x44, 0x00, 0x00)) {
2094                     // Bubble up the revert if the staticcall reverts.
2095                     returndatacopy(0x00, 0x00, returndatasize())
2096                     revert(0x00, returndatasize())
2097                 }
2098 
2099                 // Restore the part of the free memory pointer that was overwritten.
2100                 mstore(0x3a, 0)
2101             }
2102         }
2103         _;
2104     }
2105 }
2106 
2107 error AlreadyReservedTokens();
2108 error CallerNotOffsetter();
2109 error FunctionLocked();
2110 error InsufficientValue();
2111 error InsufficientMints();
2112 error InsufficientSupply();
2113 error InvalidSignature();
2114 error NoContractMinting();
2115 error ProvenanceHashAlreadySet();
2116 error ProvenanceHashNotSet();
2117 error TokenOffsetAlreadySet();
2118 error TokenOffsetNotSet();
2119 error WithdrawFailed();
2120 
2121 interface Offsetable { function setOffset(uint256 randomness) external; }
2122 
2123 
2124 contract Mona_Lisa_Original is ERC721A, ERC2981, OperatorFilterer, Ownable {
2125     using ECDSA for bytes32;
2126 
2127     string private _baseTokenURI;
2128     string public baseExtension = ".json";
2129     uint256 public constant RESERVED = 150;
2130     uint256 public SEC_RESERVED = 0;
2131     uint256 public constant MAX_SUPPLY = 330;    
2132     uint256 public MAX_MINT_PER_ACCOUNT = 5;
2133     uint256 public MINT_START_TIME = 1677387600; // Sun Feb 26 2023 05:00:00 GMT+0000
2134     uint256 public mintPrice = 0.11 ether;
2135     string public provenanceHash;
2136     bool public operatorFilteringEnabled;
2137     mapping(bytes4 => bool) public functionLocked;
2138     mapping(address => uint) public userNftCount;
2139 
2140     constructor(
2141         address _royaltyReceiver,
2142         uint96 _royaltyFraction
2143     )
2144         ERC721A("Mona Lisa Original", "Mona Lisa")
2145     {
2146 
2147         _registerForOperatorFiltering();
2148         operatorFilteringEnabled = true;
2149 
2150         _setDefaultRoyalty(_royaltyReceiver, _royaltyFraction);
2151     }
2152 
2153     /**
2154      * @notice Modifier applied to functions that will be disabled when they're no longer needed
2155      */
2156     modifier lockable() {
2157         if (functionLocked[msg.sig]) revert FunctionLocked();
2158         _;
2159     }
2160 
2161     /**
2162      * @inheritdoc ERC721A
2163      */
2164     function supportsInterface(bytes4 interfaceId)
2165         public
2166         view
2167         override(ERC721A, ERC2981)
2168         returns (bool)
2169     {
2170         return
2171             ERC721A.supportsInterface(interfaceId)
2172             || ERC2981.supportsInterface(interfaceId);
2173     }
2174 
2175     /**
2176      * @notice Override ERC721A _baseURI function to use base URI pattern
2177      */
2178     function _baseURI() internal view virtual override returns (string memory) {
2179         return _baseTokenURI;
2180     }
2181 
2182     function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
2183         baseExtension = _newBaseExtension;
2184     }
2185 
2186     function tokenURI(uint256 tokenId)
2187     public
2188     view
2189     virtual
2190     override
2191     returns (string memory)
2192     {
2193     require(
2194       _exists(tokenId),
2195       "ERC721Metadata: URI query for nonexistent token"
2196     );
2197     
2198     
2199 
2200     string memory currentBaseURI = _baseURI();
2201     return bytes(currentBaseURI).length > 0
2202         ? string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), baseExtension))
2203         : "";
2204     } 
2205 
2206 
2207     /**
2208      * @notice Return the number of tokens an address has minted
2209      * @param account Address to return the number of tokens minted for
2210      */
2211     function numberMinted(address account) external view returns (uint256) {
2212         return _numberMinted(account);
2213     }
2214 
2215     /**
2216      * @notice Lock a function so that it can no longer be called
2217      * @dev WARNING: THIS CANNOT BE UNDONE
2218      * @param id Function signature
2219      */
2220     function lockFunction(bytes4 id) external onlyOwner {
2221         functionLocked[id] = true;
2222     }
2223 
2224     /**
2225      * @notice Set the state of the OpenSea operator filter
2226      * @param value Flag indicating if the operator filter should be applied to transfers and approvals
2227      */
2228     function setOperatorFilteringEnabled(bool value) external lockable onlyOwner {
2229         operatorFilteringEnabled = value;
2230     }
2231 
2232     /**
2233      * @notice Set new royalties settings for the collection
2234      * @param receiver Address to receive royalties
2235      * @param royaltyFraction Royalty fee respective to fee denominator (10_000)
2236      */
2237     function setRoyalties(address receiver, uint96 royaltyFraction) external onlyOwner {
2238         _setDefaultRoyalty(receiver, royaltyFraction);
2239     }
2240 
2241 
2242     /**
2243      * @notice Set token metadata base URI
2244      * @param _newBaseURI New base URI
2245      */
2246     function setBaseURI(string calldata _newBaseURI) external lockable onlyOwner {
2247         _baseTokenURI = _newBaseURI;
2248     }
2249 
2250     /**
2251      * @notice Set provenance hash for the collection
2252      * @param _provenanceHash New hash of the metadata
2253      */
2254     function setProvenanceHash(string calldata _provenanceHash) external lockable onlyOwner {
2255         if (bytes(provenanceHash).length != 0) revert ProvenanceHashAlreadySet();
2256 
2257         provenanceHash = _provenanceHash;
2258     }
2259 
2260 
2261     /**
2262      * @notice Mint `RESERVED` amount of tokens to an address
2263      * @param to Address to send the reserved tokens
2264      */
2265     function reserve(address to) external lockable onlyOwner {
2266         if (_totalMinted() >= RESERVED) revert AlreadyReservedTokens();
2267         _mint(to, RESERVED);
2268     }
2269 
2270     function secondaryReserve(address to) external lockable onlyOwner {
2271         require(_totalMinted() + SEC_RESERVED <= MAX_SUPPLY , "Exceeds Maximum Supply" );
2272         _mint(to, SEC_RESERVED);
2273     }
2274 
2275     function mintForAll(uint256 amount, bool _isUK) external payable {
2276         require(block.timestamp >= MINT_START_TIME, "Minting is not yet open.");
2277         require(amount <= MAX_MINT_PER_ACCOUNT, "Amount Exceeds Maximum Mints Allowed Per Account.");
2278         require(userNftCount[msg.sender] + amount <= MAX_MINT_PER_ACCOUNT, "You can not mint more than Max Mint Limit.");
2279         require(_totalMinted() + amount <= MAX_SUPPLY , "Exceeds Maximum Supply" );
2280         uint totalCost = amount * mintPrice;
2281         if (_isUK == true) {
2282             totalCost = totalCost * 120 / 100; // add 20% VAT tax for UK
2283         }        
2284         require( msg.value >= totalCost, "Ether sent is not correct." );
2285         _mint(msg.sender, amount);
2286         userNftCount[msg.sender] += amount;
2287         if (msg.value > totalCost) {
2288             payable(msg.sender).transfer(msg.value - totalCost);
2289         }
2290     }
2291 
2292     function setMintPrice(uint256 _newPrice) external onlyOwner() {
2293         mintPrice = _newPrice;
2294     }
2295 
2296     function setSecondaryReserve(uint256 amount) external onlyOwner() {
2297         SEC_RESERVED = amount;
2298     }
2299     
2300     function setMintStartTime(uint256 unixtimestamp) external onlyOwner() {
2301         MINT_START_TIME = unixtimestamp;
2302     }
2303 
2304     function setMaxMintPerAccount(uint256 accounts) external onlyOwner() {
2305         MAX_MINT_PER_ACCOUNT = accounts;
2306     }
2307 
2308 
2309  
2310 
2311     /**
2312      * @notice Withdraw all ETH sent to the contract
2313      */
2314     function withdraw() external onlyOwner {
2315         (bool success, ) = payable(msg.sender).call{value: address(this).balance}("");
2316         if (!success) revert WithdrawFailed();
2317     }
2318 
2319     /**
2320      * @notice Override to enforce OpenSea's operator filter requirement to receive collection royalties
2321      * @inheritdoc ERC721A
2322      */
2323     function setApprovalForAll(address operator, bool approved)
2324         public
2325         override
2326         onlyAllowedOperatorApproval(operator, operatorFilteringEnabled)
2327     {
2328         super.setApprovalForAll(operator, approved);
2329     }
2330 
2331     /**
2332      * @notice Override to enforce OpenSea's operator filter requirement to receive collection royalties
2333      * @inheritdoc ERC721A
2334      */
2335     function approve(address operator, uint256 tokenId)
2336         public
2337         payable
2338         override
2339         onlyAllowedOperatorApproval(operator, operatorFilteringEnabled)
2340     {
2341         super.approve(operator, tokenId);
2342     }
2343 
2344     /**
2345      * @notice Override to enforce OpenSea's operator filter requirement to receive collection royalties
2346      * @inheritdoc ERC721A
2347      */
2348     function transferFrom(
2349         address from,
2350         address to,
2351         uint256 tokenId
2352     ) public payable override onlyAllowedOperator(from, operatorFilteringEnabled) {
2353         super.transferFrom(from, to, tokenId);
2354     }
2355 
2356     /**
2357      * @notice Override to enforce OpenSea's operator filter requirement to receive collection royalties
2358      * @inheritdoc ERC721A
2359      */
2360     function safeTransferFrom(
2361         address from,
2362         address to,
2363         uint256 tokenId
2364     ) public payable override onlyAllowedOperator(from, operatorFilteringEnabled) {
2365         super.safeTransferFrom(from, to, tokenId);
2366     }
2367 
2368     /**
2369      * @notice Override to enforce OpenSea's operator filter requirement to receive collection royalties
2370      * @inheritdoc ERC721A
2371      */
2372     function safeTransferFrom(
2373         address from,
2374         address to,
2375         uint256 tokenId,
2376         bytes memory data
2377     ) public payable override onlyAllowedOperator(from, operatorFilteringEnabled) {
2378         super.safeTransferFrom(from, to, tokenId, data);
2379     }
2380 }