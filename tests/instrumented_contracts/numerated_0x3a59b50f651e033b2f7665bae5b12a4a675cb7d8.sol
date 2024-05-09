1 // File: contracts/assets/IOperatorFilterRegistry.sol
2 
3 
4 pragma solidity ^0.8.2;
5 
6 interface IOperatorFilterRegistry {
7     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
8     function register(address registrant) external;
9     function registerAndSubscribe(address registrant, address subscription) external;
10     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
11     function unregister(address addr) external;
12     function updateOperator(address registrant, address operator, bool filtered) external;
13     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
14     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
15     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
16     function subscribe(address registrant, address registrantToSubscribe) external;
17     function unsubscribe(address registrant, bool copyExistingEntries) external;
18     function subscriptionOf(address addr) external returns (address registrant);
19     function subscribers(address registrant) external returns (address[] memory);
20     function subscriberAt(address registrant, uint256 index) external returns (address);
21     function copyEntriesOf(address registrant, address registrantToCopy) external;
22     function isOperatorFiltered(address registrant, address operator) external returns (bool);
23     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
24     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
25     function filteredOperators(address addr) external returns (address[] memory);
26     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
27     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
28     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
29     function isRegistered(address addr) external returns (bool);
30     function codeHashOf(address addr) external returns (bytes32);
31 }
32 // File: contracts/assets/OperatorFilterer.sol
33 
34 
35 pragma solidity ^0.8.2;
36 
37 
38 /**
39  * @title  OperatorFilterer
40  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
41  *         registrant's entries in the OperatorFilterRegistry.
42  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
43  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
44  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
45  */
46 abstract contract OperatorFilterer {
47     error OperatorNotAllowed(address operator);
48 
49     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
50         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
51 
52     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
53         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
54         // will not revert, but the contract will need to be registered with the registry once it is deployed in
55         // order for the modifier to filter addresses.
56         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
57             if (subscribe) {
58                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
59             } else {
60                 if (subscriptionOrRegistrantToCopy != address(0)) {
61                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
62                 } else {
63                     OPERATOR_FILTER_REGISTRY.register(address(this));
64                 }
65             }
66         }
67     }
68 
69     modifier onlyAllowedOperator(address from) virtual {
70         // Allow spending tokens from addresses with balance
71         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
72         // from an EOA.
73         if (from != msg.sender) {
74             _checkFilterOperator(msg.sender);
75         }
76         _;
77     }
78 
79     modifier onlyAllowedOperatorApproval(address operator) virtual {
80         _checkFilterOperator(operator);
81         _;
82     }
83 
84     function _checkFilterOperator(address operator) internal view virtual {
85         // Check registry code length to facilitate testing in environments without a deployed registry.
86         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
87             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
88                 revert OperatorNotAllowed(operator);
89             }
90         }
91     }
92 }
93 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/IERC165.sol
94 
95 
96 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Interface of the ERC165 standard, as defined in the
102  * https://eips.ethereum.org/EIPS/eip-165[EIP].
103  *
104  * Implementers can declare support of contract interfaces, which can then be
105  * queried by others ({ERC165Checker}).
106  *
107  * For an implementation, see {ERC165}.
108  */
109 interface IERC165 {
110     /**
111      * @dev Returns true if this contract implements the interface defined by
112      * `interfaceId`. See the corresponding
113      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
114      * to learn more about how these ids are created.
115      *
116      * This function call must use less than 30 000 gas.
117      */
118     function supportsInterface(bytes4 interfaceId) external view returns (bool);
119 }
120 
121 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/introspection/ERC165.sol
122 
123 
124 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 
129 /**
130  * @dev Implementation of the {IERC165} interface.
131  *
132  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
133  * for the additional interface id that will be supported. For example:
134  *
135  * ```solidity
136  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
137  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
138  * }
139  * ```
140  *
141  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
142  */
143 abstract contract ERC165 is IERC165 {
144     /**
145      * @dev See {IERC165-supportsInterface}.
146      */
147     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
148         return interfaceId == type(IERC165).interfaceId;
149     }
150 }
151 
152 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/interfaces/IERC2981.sol
153 
154 
155 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
156 
157 pragma solidity ^0.8.0;
158 
159 
160 /**
161  * @dev Interface for the NFT Royalty Standard.
162  *
163  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
164  * support for royalty payments across all NFT marketplaces and ecosystem participants.
165  *
166  * _Available since v4.5._
167  */
168 interface IERC2981 is IERC165 {
169     /**
170      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
171      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
172      */
173     function royaltyInfo(uint256 tokenId, uint256 salePrice)
174         external
175         view
176         returns (address receiver, uint256 royaltyAmount);
177 }
178 
179 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/common/ERC2981.sol
180 
181 
182 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
183 
184 pragma solidity ^0.8.0;
185 
186 
187 
188 /**
189  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
190  *
191  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
192  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
193  *
194  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
195  * fee is specified in basis points by default.
196  *
197  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
198  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
199  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
200  *
201  * _Available since v4.5._
202  */
203 abstract contract ERC2981 is IERC2981, ERC165 {
204     struct RoyaltyInfo {
205         address receiver;
206         uint96 royaltyFraction;
207     }
208 
209     RoyaltyInfo private _defaultRoyaltyInfo;
210     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
211 
212     /**
213      * @dev See {IERC165-supportsInterface}.
214      */
215     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
216         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
217     }
218 
219     /**
220      * @inheritdoc IERC2981
221      */
222     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
223         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
224 
225         if (royalty.receiver == address(0)) {
226             royalty = _defaultRoyaltyInfo;
227         }
228 
229         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
230 
231         return (royalty.receiver, royaltyAmount);
232     }
233 
234     /**
235      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
236      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
237      * override.
238      */
239     function _feeDenominator() internal pure virtual returns (uint96) {
240         return 10000;
241     }
242 
243     /**
244      * @dev Sets the royalty information that all ids in this contract will default to.
245      *
246      * Requirements:
247      *
248      * - `receiver` cannot be the zero address.
249      * - `feeNumerator` cannot be greater than the fee denominator.
250      */
251     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
252         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
253         require(receiver != address(0), "ERC2981: invalid receiver");
254 
255         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
256     }
257 
258     /**
259      * @dev Removes default royalty information.
260      */
261     function _deleteDefaultRoyalty() internal virtual {
262         delete _defaultRoyaltyInfo;
263     }
264 
265     /**
266      * @dev Sets the royalty information for a specific token id, overriding the global default.
267      *
268      * Requirements:
269      *
270      * - `receiver` cannot be the zero address.
271      * - `feeNumerator` cannot be greater than the fee denominator.
272      */
273     function _setTokenRoyalty(
274         uint256 tokenId,
275         address receiver,
276         uint96 feeNumerator
277     ) internal virtual {
278         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
279         require(receiver != address(0), "ERC2981: Invalid parameters");
280 
281         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
282     }
283 
284     /**
285      * @dev Resets royalty information for the token id back to the global default.
286      */
287     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
288         delete _tokenRoyaltyInfo[tokenId];
289     }
290 }
291 
292 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 /**
300  * @dev String operations.
301  */
302 library Strings {
303     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
304     uint8 private constant _ADDRESS_LENGTH = 20;
305 
306     /**
307      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
308      */
309     function toString(uint256 value) internal pure returns (string memory) {
310         // Inspired by OraclizeAPI's implementation - MIT licence
311         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
312 
313         if (value == 0) {
314             return "0";
315         }
316         uint256 temp = value;
317         uint256 digits;
318         while (temp != 0) {
319             digits++;
320             temp /= 10;
321         }
322         bytes memory buffer = new bytes(digits);
323         while (value != 0) {
324             digits -= 1;
325             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
326             value /= 10;
327         }
328         return string(buffer);
329     }
330 
331     /**
332      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
333      */
334     function toHexString(uint256 value) internal pure returns (string memory) {
335         if (value == 0) {
336             return "0x00";
337         }
338         uint256 temp = value;
339         uint256 length = 0;
340         while (temp != 0) {
341             length++;
342             temp >>= 8;
343         }
344         return toHexString(value, length);
345     }
346 
347     /**
348      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
349      */
350     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
351         bytes memory buffer = new bytes(2 * length + 2);
352         buffer[0] = "0";
353         buffer[1] = "x";
354         for (uint256 i = 2 * length + 1; i > 1; --i) {
355             buffer[i] = _HEX_SYMBOLS[value & 0xf];
356             value >>= 4;
357         }
358         require(value == 0, "Strings: hex length insufficient");
359         return string(buffer);
360     }
361 
362     /**
363      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
364      */
365     function toHexString(address addr) internal pure returns (string memory) {
366         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
367     }
368 }
369 
370 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol
371 
372 
373 // OpenZeppelin Contracts (last updated v4.8.0) (utils/cryptography/ECDSA.sol)
374 
375 pragma solidity ^0.8.0;
376 
377 
378 /**
379  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
380  *
381  * These functions can be used to verify that a message was signed by the holder
382  * of the private keys of a given address.
383  */
384 library ECDSA {
385     enum RecoverError {
386         NoError,
387         InvalidSignature,
388         InvalidSignatureLength,
389         InvalidSignatureS,
390         InvalidSignatureV // Deprecated in v4.8
391     }
392 
393     function _throwError(RecoverError error) private pure {
394         if (error == RecoverError.NoError) {
395             return; // no error: do nothing
396         } else if (error == RecoverError.InvalidSignature) {
397             revert("ECDSA: invalid signature");
398         } else if (error == RecoverError.InvalidSignatureLength) {
399             revert("ECDSA: invalid signature length");
400         } else if (error == RecoverError.InvalidSignatureS) {
401             revert("ECDSA: invalid signature 's' value");
402         }
403     }
404 
405     /**
406      * @dev Returns the address that signed a hashed message (`hash`) with
407      * `signature` or error string. This address can then be used for verification purposes.
408      *
409      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
410      * this function rejects them by requiring the `s` value to be in the lower
411      * half order, and the `v` value to be either 27 or 28.
412      *
413      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
414      * verification to be secure: it is possible to craft signatures that
415      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
416      * this is by receiving a hash of the original message (which may otherwise
417      * be too long), and then calling {toEthSignedMessageHash} on it.
418      *
419      * Documentation for signature generation:
420      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
421      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
422      *
423      * _Available since v4.3._
424      */
425     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
426         if (signature.length == 65) {
427             bytes32 r;
428             bytes32 s;
429             uint8 v;
430             // ecrecover takes the signature parameters, and the only way to get them
431             // currently is to use assembly.
432             /// @solidity memory-safe-assembly
433             assembly {
434                 r := mload(add(signature, 0x20))
435                 s := mload(add(signature, 0x40))
436                 v := byte(0, mload(add(signature, 0x60)))
437             }
438             return tryRecover(hash, v, r, s);
439         } else {
440             return (address(0), RecoverError.InvalidSignatureLength);
441         }
442     }
443 
444     /**
445      * @dev Returns the address that signed a hashed message (`hash`) with
446      * `signature`. This address can then be used for verification purposes.
447      *
448      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
449      * this function rejects them by requiring the `s` value to be in the lower
450      * half order, and the `v` value to be either 27 or 28.
451      *
452      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
453      * verification to be secure: it is possible to craft signatures that
454      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
455      * this is by receiving a hash of the original message (which may otherwise
456      * be too long), and then calling {toEthSignedMessageHash} on it.
457      */
458     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
459         (address recovered, RecoverError error) = tryRecover(hash, signature);
460         _throwError(error);
461         return recovered;
462     }
463 
464     /**
465      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
466      *
467      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
468      *
469      * _Available since v4.3._
470      */
471     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address, RecoverError) {
472         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
473         uint8 v = uint8((uint256(vs) >> 255) + 27);
474         return tryRecover(hash, v, r, s);
475     }
476 
477     /**
478      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
479      *
480      * _Available since v4.2._
481      */
482     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal pure returns (address) {
483         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
484         _throwError(error);
485         return recovered;
486     }
487 
488     /**
489      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
490      * `r` and `s` signature fields separately.
491      *
492      * _Available since v4.3._
493      */
494     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address, RecoverError) {
495         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
496         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
497         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
498         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
499         //
500         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
501         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
502         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
503         // these malleable signatures as well.
504         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
505             return (address(0), RecoverError.InvalidSignatureS);
506         }
507 
508         // If the signature is valid (and not malleable), return the signer address
509         address signer = ecrecover(hash, v, r, s);
510         if (signer == address(0)) {
511             return (address(0), RecoverError.InvalidSignature);
512         }
513 
514         return (signer, RecoverError.NoError);
515     }
516 
517     /**
518      * @dev Overload of {ECDSA-recover} that receives the `v`,
519      * `r` and `s` signature fields separately.
520      */
521     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal pure returns (address) {
522         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
523         _throwError(error);
524         return recovered;
525     }
526 
527     /**
528      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
529      * produces hash corresponding to the one signed with the
530      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
531      * JSON-RPC method as part of EIP-191.
532      *
533      * See {recover}.
534      */
535     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 message) {
536         // 32 is the length in bytes of hash,
537         // enforced by the type signature above
538         /// @solidity memory-safe-assembly
539         assembly {
540             mstore(0x00, "\x19Ethereum Signed Message:\n32")
541             mstore(0x1c, hash)
542             message := keccak256(0x00, 0x3c)
543         }
544     }
545 
546     /**
547      * @dev Returns an Ethereum Signed Message, created from `s`. This
548      * produces hash corresponding to the one signed with the
549      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
550      * JSON-RPC method as part of EIP-191.
551      *
552      * See {recover}.
553      */
554     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
555         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
556     }
557 
558     /**
559      * @dev Returns an Ethereum Signed Typed Data, created from a
560      * `domainSeparator` and a `structHash`. This produces hash corresponding
561      * to the one signed with the
562      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
563      * JSON-RPC method as part of EIP-712.
564      *
565      * See {recover}.
566      */
567     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32 data) {
568         /// @solidity memory-safe-assembly
569         assembly {
570             let ptr := mload(0x40)
571             mstore(ptr, "\x19\x01")
572             mstore(add(ptr, 0x02), domainSeparator)
573             mstore(add(ptr, 0x22), structHash)
574             data := keccak256(ptr, 0x42)
575         }
576     }
577 
578     /**
579      * @dev Returns an Ethereum Signed Data with intended validator, created from a
580      * `validator` and `data` according to the version 0 of EIP-191.
581      *
582      * See {recover}.
583      */
584     function toDataWithIntendedValidatorHash(address validator, bytes memory data) internal pure returns (bytes32) {
585         return keccak256(abi.encodePacked("\x19\x00", validator, data));
586     }
587 }
588 
589 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol
590 
591 
592 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
593 
594 pragma solidity ^0.8.0;
595 
596 /**
597  * @dev Provides information about the current execution context, including the
598  * sender of the transaction and its data. While these are generally available
599  * via msg.sender and msg.data, they should not be accessed in such a direct
600  * manner, since when dealing with meta-transactions the account sending and
601  * paying for execution may not be the actual sender (as far as an application
602  * is concerned).
603  *
604  * This contract is only required for intermediate, library-like contracts.
605  */
606 abstract contract Context {
607     function _msgSender() internal view virtual returns (address) {
608         return msg.sender;
609     }
610 
611     function _msgData() internal view virtual returns (bytes calldata) {
612         return msg.data;
613     }
614 }
615 
616 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
617 
618 
619 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
620 
621 pragma solidity ^0.8.0;
622 
623 
624 /**
625  * @dev Contract module which provides a basic access control mechanism, where
626  * there is an account (an owner) that can be granted exclusive access to
627  * specific functions.
628  *
629  * By default, the owner account will be the one that deploys the contract. This
630  * can later be changed with {transferOwnership}.
631  *
632  * This module is used through inheritance. It will make available the modifier
633  * `onlyOwner`, which can be applied to your functions to restrict their use to
634  * the owner.
635  */
636 abstract contract Ownable is Context {
637     address private _owner;
638 
639     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
640 
641     /**
642      * @dev Initializes the contract setting the deployer as the initial owner.
643      */
644     constructor() {
645         _transferOwnership(_msgSender());
646     }
647 
648     /**
649      * @dev Returns the address of the current owner.
650      */
651     function owner() public view virtual returns (address) {
652         return _owner;
653     }
654 
655     /**
656      * @dev Throws if called by any account other than the owner.
657      */
658     modifier onlyOwner() {
659         require(owner() == _msgSender(), "Ownable: caller is not the owner");
660         _;
661     }
662 
663     /**
664      * @dev Leaves the contract without owner. It will not be possible to call
665      * `onlyOwner` functions anymore. Can only be called by the current owner.
666      *
667      * NOTE: Renouncing ownership will leave the contract without an owner,
668      * thereby removing any functionality that is only available to the owner.
669      */
670     function renounceOwnership() public virtual onlyOwner {
671         _transferOwnership(address(0));
672     }
673 
674     /**
675      * @dev Transfers ownership of the contract to a new account (`newOwner`).
676      * Can only be called by the current owner.
677      */
678     function transferOwnership(address newOwner) public virtual onlyOwner {
679         require(newOwner != address(0), "Ownable: new owner is the zero address");
680         _transferOwnership(newOwner);
681     }
682 
683     /**
684      * @dev Transfers ownership of the contract to a new account (`newOwner`).
685      * Internal function without access restriction.
686      */
687     function _transferOwnership(address newOwner) internal virtual {
688         address oldOwner = _owner;
689         _owner = newOwner;
690         emit OwnershipTransferred(oldOwner, newOwner);
691     }
692 }
693 
694 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol
695 
696 
697 // OpenZeppelin Contracts (last updated v4.6.0) (utils/math/SafeMath.sol)
698 
699 pragma solidity ^0.8.0;
700 
701 // CAUTION
702 // This version of SafeMath should only be used with Solidity 0.8 or later,
703 // because it relies on the compiler's built in overflow checks.
704 
705 /**
706  * @dev Wrappers over Solidity's arithmetic operations.
707  *
708  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
709  * now has built in overflow checking.
710  */
711 library SafeMath {
712     /**
713      * @dev Returns the addition of two unsigned integers, with an overflow flag.
714      *
715      * _Available since v3.4._
716      */
717     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
718         unchecked {
719             uint256 c = a + b;
720             if (c < a) return (false, 0);
721             return (true, c);
722         }
723     }
724 
725     /**
726      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
727      *
728      * _Available since v3.4._
729      */
730     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
731         unchecked {
732             if (b > a) return (false, 0);
733             return (true, a - b);
734         }
735     }
736 
737     /**
738      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
739      *
740      * _Available since v3.4._
741      */
742     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
743         unchecked {
744             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
745             // benefit is lost if 'b' is also tested.
746             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
747             if (a == 0) return (true, 0);
748             uint256 c = a * b;
749             if (c / a != b) return (false, 0);
750             return (true, c);
751         }
752     }
753 
754     /**
755      * @dev Returns the division of two unsigned integers, with a division by zero flag.
756      *
757      * _Available since v3.4._
758      */
759     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
760         unchecked {
761             if (b == 0) return (false, 0);
762             return (true, a / b);
763         }
764     }
765 
766     /**
767      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
768      *
769      * _Available since v3.4._
770      */
771     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
772         unchecked {
773             if (b == 0) return (false, 0);
774             return (true, a % b);
775         }
776     }
777 
778     /**
779      * @dev Returns the addition of two unsigned integers, reverting on
780      * overflow.
781      *
782      * Counterpart to Solidity's `+` operator.
783      *
784      * Requirements:
785      *
786      * - Addition cannot overflow.
787      */
788     function add(uint256 a, uint256 b) internal pure returns (uint256) {
789         return a + b;
790     }
791 
792     /**
793      * @dev Returns the subtraction of two unsigned integers, reverting on
794      * overflow (when the result is negative).
795      *
796      * Counterpart to Solidity's `-` operator.
797      *
798      * Requirements:
799      *
800      * - Subtraction cannot overflow.
801      */
802     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
803         return a - b;
804     }
805 
806     /**
807      * @dev Returns the multiplication of two unsigned integers, reverting on
808      * overflow.
809      *
810      * Counterpart to Solidity's `*` operator.
811      *
812      * Requirements:
813      *
814      * - Multiplication cannot overflow.
815      */
816     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
817         return a * b;
818     }
819 
820     /**
821      * @dev Returns the integer division of two unsigned integers, reverting on
822      * division by zero. The result is rounded towards zero.
823      *
824      * Counterpart to Solidity's `/` operator.
825      *
826      * Requirements:
827      *
828      * - The divisor cannot be zero.
829      */
830     function div(uint256 a, uint256 b) internal pure returns (uint256) {
831         return a / b;
832     }
833 
834     /**
835      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
836      * reverting when dividing by zero.
837      *
838      * Counterpart to Solidity's `%` operator. This function uses a `revert`
839      * opcode (which leaves remaining gas untouched) while Solidity uses an
840      * invalid opcode to revert (consuming all remaining gas).
841      *
842      * Requirements:
843      *
844      * - The divisor cannot be zero.
845      */
846     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
847         return a % b;
848     }
849 
850     /**
851      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
852      * overflow (when the result is negative).
853      *
854      * CAUTION: This function is deprecated because it requires allocating memory for the error
855      * message unnecessarily. For custom revert reasons use {trySub}.
856      *
857      * Counterpart to Solidity's `-` operator.
858      *
859      * Requirements:
860      *
861      * - Subtraction cannot overflow.
862      */
863     function sub(
864         uint256 a,
865         uint256 b,
866         string memory errorMessage
867     ) internal pure returns (uint256) {
868         unchecked {
869             require(b <= a, errorMessage);
870             return a - b;
871         }
872     }
873 
874     /**
875      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
876      * division by zero. The result is rounded towards zero.
877      *
878      * Counterpart to Solidity's `/` operator. Note: this function uses a
879      * `revert` opcode (which leaves remaining gas untouched) while Solidity
880      * uses an invalid opcode to revert (consuming all remaining gas).
881      *
882      * Requirements:
883      *
884      * - The divisor cannot be zero.
885      */
886     function div(
887         uint256 a,
888         uint256 b,
889         string memory errorMessage
890     ) internal pure returns (uint256) {
891         unchecked {
892             require(b > 0, errorMessage);
893             return a / b;
894         }
895     }
896 
897     /**
898      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
899      * reverting with custom message when dividing by zero.
900      *
901      * CAUTION: This function is deprecated because it requires allocating memory for the error
902      * message unnecessarily. For custom revert reasons use {tryMod}.
903      *
904      * Counterpart to Solidity's `%` operator. This function uses a `revert`
905      * opcode (which leaves remaining gas untouched) while Solidity uses an
906      * invalid opcode to revert (consuming all remaining gas).
907      *
908      * Requirements:
909      *
910      * - The divisor cannot be zero.
911      */
912     function mod(
913         uint256 a,
914         uint256 b,
915         string memory errorMessage
916     ) internal pure returns (uint256) {
917         unchecked {
918             require(b > 0, errorMessage);
919             return a % b;
920         }
921     }
922 }
923 
924 // File: contracts/assets/IERC721A.sol
925 
926 
927 // ERC721A Contracts v4.2.0
928 // Creator: Chiru Labs
929 
930 pragma solidity ^0.8.4;
931 
932 /**
933  * @dev Interface of ERC721A.
934  */
935 interface IERC721A {
936     /**
937      * The caller must own the token or be an approved operator.
938      */
939     error ApprovalCallerNotOwnerNorApproved();
940 
941     /**
942      * The token does not exist.
943      */
944     error ApprovalQueryForNonexistentToken();
945 
946     /**
947      * The caller cannot approve to their own address.
948      */
949     error ApproveToCaller();
950 
951     /**
952      * Cannot query the balance for the zero address.
953      */
954     error BalanceQueryForZeroAddress();
955 
956     /**
957      * Cannot mint to the zero address.
958      */
959     error MintToZeroAddress();
960 
961     /**
962      * The quantity of tokens minted must be more than zero.
963      */
964     error MintZeroQuantity();
965 
966     /**
967      * The token does not exist.
968      */
969     error OwnerQueryForNonexistentToken();
970 
971     /**
972      * The caller must own the token or be an approved operator.
973      */
974     error TransferCallerNotOwnerNorApproved();
975 
976     /**
977      * The token must be owned by `from`.
978      */
979     error TransferFromIncorrectOwner();
980 
981     /**
982      * Cannot safely transfer to a contract that does not implement the
983      * ERC721Receiver interface.
984      */
985     error TransferToNonERC721ReceiverImplementer();
986 
987     /**
988      * Cannot transfer to the zero address.
989      */
990     error TransferToZeroAddress();
991 
992     /**
993      * The token does not exist.
994      */
995     error URIQueryForNonexistentToken();
996 
997     /**
998      * The `quantity` minted with ERC2309 exceeds the safety limit.
999      */
1000     error MintERC2309QuantityExceedsLimit();
1001 
1002     /**
1003      * The `extraData` cannot be set on an unintialized ownership slot.
1004      */
1005     error OwnershipNotInitializedForExtraData();
1006 
1007     // =============================================================
1008     //                            STRUCTS
1009     // =============================================================
1010 
1011     struct TokenOwnership {
1012         // The address of the owner.
1013         address addr;
1014         // Stores the start time of ownership with minimal overhead for tokenomics.
1015         uint64 startTimestamp;
1016         // Whether the token has been burned.
1017         bool burned;
1018         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1019         uint24 extraData;
1020     }
1021 
1022     // =============================================================
1023     //                         TOKEN COUNTERS
1024     // =============================================================
1025 
1026     /**
1027      * @dev Returns the total number of tokens in existence.
1028      * Burned tokens will reduce the count.
1029      * To get the total number of tokens minted, please see {_totalMinted}.
1030      */
1031     function totalSupply() external view returns (uint256);
1032 
1033     // =============================================================
1034     //                            IERC165
1035     // =============================================================
1036 
1037     /**
1038      * @dev Returns true if this contract implements the interface defined by
1039      * `interfaceId`. See the corresponding
1040      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1041      * to learn more about how these ids are created.
1042      *
1043      * This function call must use less than 30000 gas.
1044      */
1045     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1046 
1047     // =============================================================
1048     //                            IERC721
1049     // =============================================================
1050 
1051     /**
1052      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1053      */
1054     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1055 
1056     /**
1057      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1058      */
1059     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1060 
1061     /**
1062      * @dev Emitted when `owner` enables or disables
1063      * (`approved`) `operator` to manage all of its assets.
1064      */
1065     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1066 
1067     /**
1068      * @dev Returns the number of tokens in `owner`'s account.
1069      */
1070     function balanceOf(address owner) external view returns (uint256 balance);
1071 
1072     /**
1073      * @dev Returns the owner of the `tokenId` token.
1074      *
1075      * Requirements:
1076      *
1077      * - `tokenId` must exist.
1078      */
1079     function ownerOf(uint256 tokenId) external view returns (address owner);
1080 
1081     /**
1082      * @dev Safely transfers `tokenId` token from `from` to `to`,
1083      * checking first that contract recipients are aware of the ERC721 protocol
1084      * to prevent tokens from being forever locked.
1085      *
1086      * Requirements:
1087      *
1088      * - `from` cannot be the zero address.
1089      * - `to` cannot be the zero address.
1090      * - `tokenId` token must exist and be owned by `from`.
1091      * - If the caller is not `from`, it must be have been allowed to move
1092      * this token by either {approve} or {setApprovalForAll}.
1093      * - If `to` refers to a smart contract, it must implement
1094      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1095      *
1096      * Emits a {Transfer} event.
1097      */
1098     function safeTransferFrom(
1099         address from,
1100         address to,
1101         uint256 tokenId,
1102         bytes calldata data
1103     ) external;
1104 
1105     /**
1106      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1107      */
1108     function safeTransferFrom(
1109         address from,
1110         address to,
1111         uint256 tokenId
1112     ) external;
1113 
1114     /**
1115      * @dev Transfers `tokenId` from `from` to `to`.
1116      *
1117      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1118      * whenever possible.
1119      *
1120      * Requirements:
1121      *
1122      * - `from` cannot be the zero address.
1123      * - `to` cannot be the zero address.
1124      * - `tokenId` token must be owned by `from`.
1125      * - If the caller is not `from`, it must be approved to move this token
1126      * by either {approve} or {setApprovalForAll}.
1127      *
1128      * Emits a {Transfer} event.
1129      */
1130     function transferFrom(
1131         address from,
1132         address to,
1133         uint256 tokenId
1134     ) external;
1135 
1136     /**
1137      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1138      * The approval is cleared when the token is transferred.
1139      *
1140      * Only a single account can be approved at a time, so approving the
1141      * zero address clears previous approvals.
1142      *
1143      * Requirements:
1144      *
1145      * - The caller must own the token or be an approved operator.
1146      * - `tokenId` must exist.
1147      *
1148      * Emits an {Approval} event.
1149      */
1150     function approve(address to, uint256 tokenId) external;
1151 
1152     /**
1153      * @dev Approve or remove `operator` as an operator for the caller.
1154      * Operators can call {transferFrom} or {safeTransferFrom}
1155      * for any token owned by the caller.
1156      *
1157      * Requirements:
1158      *
1159      * - The `operator` cannot be the caller.
1160      *
1161      * Emits an {ApprovalForAll} event.
1162      */
1163     function setApprovalForAll(address operator, bool _approved) external;
1164 
1165     /**
1166      * @dev Returns the account approved for `tokenId` token.
1167      *
1168      * Requirements:
1169      *
1170      * - `tokenId` must exist.
1171      */
1172     function getApproved(uint256 tokenId) external view returns (address operator);
1173 
1174     /**
1175      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1176      *
1177      * See {setApprovalForAll}.
1178      */
1179     function isApprovedForAll(address owner, address operator) external view returns (bool);
1180 
1181     // =============================================================
1182     //                        IERC721Metadata
1183     // =============================================================
1184 
1185     /**
1186      * @dev Returns the token collection name.
1187      */
1188     function name() external view returns (string memory);
1189 
1190     /**
1191      * @dev Returns the token collection symbol.
1192      */
1193     function symbol() external view returns (string memory);
1194 
1195     /**
1196      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1197      */
1198     function tokenURI(uint256 tokenId) external view returns (string memory);
1199 
1200     // =============================================================
1201     //                           IERC2309
1202     // =============================================================
1203 
1204     /**
1205      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1206      * (inclusive) is transferred from `from` to `to`, as defined in the
1207      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1208      *
1209      * See {_mintERC2309} for more details.
1210      */
1211     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1212 }
1213 // File: contracts/assets/ERC721A.sol
1214 
1215 
1216 // ERC721A Contracts v4.2.0
1217 // Creator: Chiru Labs
1218 
1219 pragma solidity ^0.8.4;
1220 
1221 
1222 /**
1223  * @dev Interface of ERC721 token receiver.
1224  */
1225 interface ERC721A__IERC721Receiver {
1226     function onERC721Received(
1227         address operator,
1228         address from,
1229         uint256 tokenId,
1230         bytes calldata data
1231     ) external returns (bytes4);
1232 }
1233 
1234 /**
1235  * @title ERC721A
1236  *
1237  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1238  * Non-Fungible Token Standard, including the Metadata extension.
1239  * Optimized for lower gas during batch mints.
1240  *
1241  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1242  * starting from `_startTokenId()`.
1243  *
1244  * Assumptions:
1245  *
1246  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1247  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1248  */
1249 contract ERC721A is IERC721A {
1250     // Reference type for token approval.
1251     struct TokenApprovalRef {
1252         address value;
1253     }
1254 
1255     // =============================================================
1256     //                           CONSTANTS
1257     // =============================================================
1258 
1259     // Mask of an entry in packed address data.
1260     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1261 
1262     // The bit position of `numberMinted` in packed address data.
1263     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1264 
1265     // The bit position of `numberBurned` in packed address data.
1266     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1267 
1268     // The bit position of `aux` in packed address data.
1269     uint256 private constant _BITPOS_AUX = 192;
1270 
1271     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1272     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1273 
1274     // The bit position of `startTimestamp` in packed ownership.
1275     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1276 
1277     // The bit mask of the `burned` bit in packed ownership.
1278     uint256 private constant _BITMASK_BURNED = 1 << 224;
1279 
1280     // The bit position of the `nextInitialized` bit in packed ownership.
1281     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1282 
1283     // The bit mask of the `nextInitialized` bit in packed ownership.
1284     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1285 
1286     // The bit position of `extraData` in packed ownership.
1287     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1288 
1289     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1290     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1291 
1292     // The mask of the lower 160 bits for addresses.
1293     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1294 
1295     // The maximum `quantity` that can be minted with {_mintERC2309}.
1296     // This limit is to prevent overflows on the address data entries.
1297     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1298     // is required to cause an overflow, which is unrealistic.
1299     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1300 
1301     // The `Transfer` event signature is given by:
1302     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1303     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1304         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1305 
1306     // =============================================================
1307     //                            STORAGE
1308     // =============================================================
1309 
1310     // The next token ID to be minted.
1311     uint256 private _currentIndex;
1312 
1313     // The number of tokens burned.
1314     uint256 private _burnCounter;
1315 
1316     // Token name
1317     string private _name;
1318 
1319     // Token symbol
1320     string private _symbol;
1321 
1322     // Mapping from token ID to ownership details
1323     // An empty struct value does not necessarily mean the token is unowned.
1324     // See {_packedOwnershipOf} implementation for details.
1325     //
1326     // Bits Layout:
1327     // - [0..159]   `addr`
1328     // - [160..223] `startTimestamp`
1329     // - [224]      `burned`
1330     // - [225]      `nextInitialized`
1331     // - [232..255] `extraData`
1332     mapping(uint256 => uint256) private _packedOwnerships;
1333 
1334     // Mapping owner address to address data.
1335     //
1336     // Bits Layout:
1337     // - [0..63]    `balance`
1338     // - [64..127]  `numberMinted`
1339     // - [128..191] `numberBurned`
1340     // - [192..255] `aux`
1341     mapping(address => uint256) private _packedAddressData;
1342 
1343     // Mapping from token ID to approved address.
1344     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1345 
1346     // Mapping from owner to operator approvals
1347     mapping(address => mapping(address => bool)) private _operatorApprovals;
1348 
1349     // =============================================================
1350     //                          CONSTRUCTOR
1351     // =============================================================
1352 
1353     constructor(string memory name_, string memory symbol_) {
1354         _name = name_;
1355         _symbol = symbol_;
1356         _currentIndex = _startTokenId();
1357     }
1358 
1359     // =============================================================
1360     //                   TOKEN COUNTING OPERATIONS
1361     // =============================================================
1362 
1363     /**
1364      * @dev Returns the starting token ID.
1365      * To change the starting token ID, please override this function.
1366      */
1367     function _startTokenId() internal view virtual returns (uint256) {
1368         return 0;
1369     }
1370 
1371     /**
1372      * @dev Returns the next token ID to be minted.
1373      */
1374     function _nextTokenId() internal view virtual returns (uint256) {
1375         return _currentIndex;
1376     }
1377 
1378     /**
1379      * @dev Returns the total number of tokens in existence.
1380      * Burned tokens will reduce the count.
1381      * To get the total number of tokens minted, please see {_totalMinted}.
1382      */
1383     function totalSupply() public view virtual override returns (uint256) {
1384         // Counter underflow is impossible as _burnCounter cannot be incremented
1385         // more than `_currentIndex - _startTokenId()` times.
1386         unchecked {
1387             return _currentIndex - _burnCounter - _startTokenId();
1388         }
1389     }
1390 
1391     /**
1392      * @dev Returns the total amount of tokens minted in the contract.
1393      */
1394     function _totalMinted() internal view virtual returns (uint256) {
1395         // Counter underflow is impossible as `_currentIndex` does not decrement,
1396         // and it is initialized to `_startTokenId()`.
1397         unchecked {
1398             return _currentIndex - _startTokenId();
1399         }
1400     }
1401 
1402     /**
1403      * @dev Returns the total number of tokens burned.
1404      */
1405     function _totalBurned() internal view virtual returns (uint256) {
1406         return _burnCounter;
1407     }
1408 
1409     // =============================================================
1410     //                    ADDRESS DATA OPERATIONS
1411     // =============================================================
1412 
1413     /**
1414      * @dev Returns the number of tokens in `owner`'s account.
1415      */
1416     function balanceOf(address owner) public view virtual override returns (uint256) {
1417         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1418         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1419     }
1420 
1421     /**
1422      * Returns the number of tokens minted by `owner`.
1423      */
1424     function _numberMinted(address owner) internal view returns (uint256) {
1425         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1426     }
1427 
1428     /**
1429      * Returns the number of tokens burned by or on behalf of `owner`.
1430      */
1431     function _numberBurned(address owner) internal view returns (uint256) {
1432         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1433     }
1434 
1435     /**
1436      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1437      */
1438     function _getAux(address owner) internal view returns (uint64) {
1439         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1440     }
1441 
1442     /**
1443      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1444      * If there are multiple variables, please pack them into a uint64.
1445      */
1446     function _setAux(address owner, uint64 aux) internal virtual {
1447         uint256 packed = _packedAddressData[owner];
1448         uint256 auxCasted;
1449         // Cast `aux` with assembly to avoid redundant masking.
1450         assembly {
1451             auxCasted := aux
1452         }
1453         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1454         _packedAddressData[owner] = packed;
1455     }
1456 
1457     // =============================================================
1458     //                            IERC165
1459     // =============================================================
1460 
1461     /**
1462      * @dev Returns true if this contract implements the interface defined by
1463      * `interfaceId`. See the corresponding
1464      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1465      * to learn more about how these ids are created.
1466      *
1467      * This function call must use less than 30000 gas.
1468      */
1469     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1470         // The interface IDs are constants representing the first 4 bytes
1471         // of the XOR of all function selectors in the interface.
1472         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1473         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1474         return
1475             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1476             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1477             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1478     }
1479 
1480     // =============================================================
1481     //                        IERC721Metadata
1482     // =============================================================
1483 
1484     /**
1485      * @dev Returns the token collection name.
1486      */
1487     function name() public view virtual override returns (string memory) {
1488         return _name;
1489     }
1490 
1491     /**
1492      * @dev Returns the token collection symbol.
1493      */
1494     function symbol() public view virtual override returns (string memory) {
1495         return _symbol;
1496     }
1497 
1498     /**
1499      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1500      */
1501     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1502         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1503 
1504         string memory baseURI = _baseURI();
1505         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1506     }
1507 
1508     /**
1509      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1510      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1511      * by default, it can be overridden in child contracts.
1512      */
1513     function _baseURI() internal view virtual returns (string memory) {
1514         return '';
1515     }
1516 
1517     // =============================================================
1518     //                     OWNERSHIPS OPERATIONS
1519     // =============================================================
1520 
1521     /**
1522      * @dev Returns the owner of the `tokenId` token.
1523      *
1524      * Requirements:
1525      *
1526      * - `tokenId` must exist.
1527      */
1528     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1529         return address(uint160(_packedOwnershipOf(tokenId)));
1530     }
1531 
1532     /**
1533      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1534      * It gradually moves to O(1) as tokens get transferred around over time.
1535      */
1536     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1537         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1538     }
1539 
1540     /**
1541      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1542      */
1543     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1544         return _unpackedOwnership(_packedOwnerships[index]);
1545     }
1546 
1547     /**
1548      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1549      */
1550     function _initializeOwnershipAt(uint256 index) internal virtual {
1551         if (_packedOwnerships[index] == 0) {
1552             _packedOwnerships[index] = _packedOwnershipOf(index);
1553         }
1554     }
1555 
1556     /**
1557      * Returns the packed ownership data of `tokenId`.
1558      */
1559     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1560         uint256 curr = tokenId;
1561 
1562         unchecked {
1563             if (_startTokenId() <= curr)
1564                 if (curr < _currentIndex) {
1565                     uint256 packed = _packedOwnerships[curr];
1566                     // If not burned.
1567                     if (packed & _BITMASK_BURNED == 0) {
1568                         // Invariant:
1569                         // There will always be an initialized ownership slot
1570                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1571                         // before an unintialized ownership slot
1572                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1573                         // Hence, `curr` will not underflow.
1574                         //
1575                         // We can directly compare the packed value.
1576                         // If the address is zero, packed will be zero.
1577                         while (packed == 0) {
1578                             packed = _packedOwnerships[--curr];
1579                         }
1580                         return packed;
1581                     }
1582                 }
1583         }
1584         revert OwnerQueryForNonexistentToken();
1585     }
1586 
1587     /**
1588      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1589      */
1590     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1591         ownership.addr = address(uint160(packed));
1592         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1593         ownership.burned = packed & _BITMASK_BURNED != 0;
1594         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1595     }
1596 
1597     /**
1598      * @dev Packs ownership data into a single uint256.
1599      */
1600     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1601         assembly {
1602             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1603             owner := and(owner, _BITMASK_ADDRESS)
1604             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1605             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1606         }
1607     }
1608 
1609     /**
1610      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1611      */
1612     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1613         // For branchless setting of the `nextInitialized` flag.
1614         assembly {
1615             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1616             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1617         }
1618     }
1619 
1620     // =============================================================
1621     //                      APPROVAL OPERATIONS
1622     // =============================================================
1623 
1624     /**
1625      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1626      * The approval is cleared when the token is transferred.
1627      *
1628      * Only a single account can be approved at a time, so approving the
1629      * zero address clears previous approvals.
1630      *
1631      * Requirements:
1632      *
1633      * - The caller must own the token or be an approved operator.
1634      * - `tokenId` must exist.
1635      *
1636      * Emits an {Approval} event.
1637      */
1638     function approve(address to, uint256 tokenId) public virtual override {
1639         address owner = ownerOf(tokenId);
1640 
1641         if (_msgSenderERC721A() != owner)
1642             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1643                 revert ApprovalCallerNotOwnerNorApproved();
1644             }
1645 
1646         _tokenApprovals[tokenId].value = to;
1647         emit Approval(owner, to, tokenId);
1648     }
1649 
1650     /**
1651      * @dev Returns the account approved for `tokenId` token.
1652      *
1653      * Requirements:
1654      *
1655      * - `tokenId` must exist.
1656      */
1657     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1658         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1659 
1660         return _tokenApprovals[tokenId].value;
1661     }
1662 
1663     /**
1664      * @dev Approve or remove `operator` as an operator for the caller.
1665      * Operators can call {transferFrom} or {safeTransferFrom}
1666      * for any token owned by the caller.
1667      *
1668      * Requirements:
1669      *
1670      * - The `operator` cannot be the caller.
1671      *
1672      * Emits an {ApprovalForAll} event.
1673      */
1674     function setApprovalForAll(address operator, bool approved) public virtual override {
1675         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1676 
1677         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1678         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1679     }
1680 
1681     /**
1682      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1683      *
1684      * See {setApprovalForAll}.
1685      */
1686     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1687         return _operatorApprovals[owner][operator];
1688     }
1689 
1690     /**
1691      * @dev Returns whether `tokenId` exists.
1692      *
1693      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1694      *
1695      * Tokens start existing when they are minted. See {_mint}.
1696      */
1697     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1698         return
1699             _startTokenId() <= tokenId &&
1700             tokenId < _currentIndex && // If within bounds,
1701             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1702     }
1703 
1704     /**
1705      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1706      */
1707     function _isSenderApprovedOrOwner(
1708         address approvedAddress,
1709         address owner,
1710         address msgSender
1711     ) private pure returns (bool result) {
1712         assembly {
1713             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1714             owner := and(owner, _BITMASK_ADDRESS)
1715             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1716             msgSender := and(msgSender, _BITMASK_ADDRESS)
1717             // `msgSender == owner || msgSender == approvedAddress`.
1718             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1719         }
1720     }
1721 
1722     /**
1723      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1724      */
1725     function _getApprovedSlotAndAddress(uint256 tokenId)
1726         private
1727         view
1728         returns (uint256 approvedAddressSlot, address approvedAddress)
1729     {
1730         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1731         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1732         assembly {
1733             approvedAddressSlot := tokenApproval.slot
1734             approvedAddress := sload(approvedAddressSlot)
1735         }
1736     }
1737 
1738     // =============================================================
1739     //                      TRANSFER OPERATIONS
1740     // =============================================================
1741 
1742     /**
1743      * @dev Transfers `tokenId` from `from` to `to`.
1744      *
1745      * Requirements:
1746      *
1747      * - `from` cannot be the zero address.
1748      * - `to` cannot be the zero address.
1749      * - `tokenId` token must be owned by `from`.
1750      * - If the caller is not `from`, it must be approved to move this token
1751      * by either {approve} or {setApprovalForAll}.
1752      *
1753      * Emits a {Transfer} event.
1754      */
1755     function transferFrom(
1756         address from,
1757         address to,
1758         uint256 tokenId
1759     ) public virtual override {
1760         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1761 
1762         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1763 
1764         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1765 
1766         // The nested ifs save around 20+ gas over a compound boolean condition.
1767         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1768             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1769 
1770         if (to == address(0)) revert TransferToZeroAddress();
1771 
1772         _beforeTokenTransfers(from, to, tokenId, 1);
1773 
1774         // Clear approvals from the previous owner.
1775         assembly {
1776             if approvedAddress {
1777                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1778                 sstore(approvedAddressSlot, 0)
1779             }
1780         }
1781 
1782         // Underflow of the sender's balance is impossible because we check for
1783         // ownership above and the recipient's balance can't realistically overflow.
1784         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1785         unchecked {
1786             // We can directly increment and decrement the balances.
1787             --_packedAddressData[from]; // Updates: `balance -= 1`.
1788             ++_packedAddressData[to]; // Updates: `balance += 1`.
1789 
1790             // Updates:
1791             // - `address` to the next owner.
1792             // - `startTimestamp` to the timestamp of transfering.
1793             // - `burned` to `false`.
1794             // - `nextInitialized` to `true`.
1795             _packedOwnerships[tokenId] = _packOwnershipData(
1796                 to,
1797                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1798             );
1799 
1800             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1801             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1802                 uint256 nextTokenId = tokenId + 1;
1803                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1804                 if (_packedOwnerships[nextTokenId] == 0) {
1805                     // If the next slot is within bounds.
1806                     if (nextTokenId != _currentIndex) {
1807                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1808                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1809                     }
1810                 }
1811             }
1812         }
1813 
1814         emit Transfer(from, to, tokenId);
1815         _afterTokenTransfers(from, to, tokenId, 1);
1816     }
1817 
1818     /**
1819      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1820      */
1821     function safeTransferFrom(
1822         address from,
1823         address to,
1824         uint256 tokenId
1825     ) public virtual override {
1826         safeTransferFrom(from, to, tokenId, '');
1827     }
1828 
1829     /**
1830      * @dev Safely transfers `tokenId` token from `from` to `to`.
1831      *
1832      * Requirements:
1833      *
1834      * - `from` cannot be the zero address.
1835      * - `to` cannot be the zero address.
1836      * - `tokenId` token must exist and be owned by `from`.
1837      * - If the caller is not `from`, it must be approved to move this token
1838      * by either {approve} or {setApprovalForAll}.
1839      * - If `to` refers to a smart contract, it must implement
1840      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1841      *
1842      * Emits a {Transfer} event.
1843      */
1844     function safeTransferFrom(
1845         address from,
1846         address to,
1847         uint256 tokenId,
1848         bytes memory _data
1849     ) public virtual override {
1850         transferFrom(from, to, tokenId);
1851         if (to.code.length != 0)
1852             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1853                 revert TransferToNonERC721ReceiverImplementer();
1854             }
1855     }
1856 
1857     /**
1858      * @dev Hook that is called before a set of serially-ordered token IDs
1859      * are about to be transferred. This includes minting.
1860      * And also called before burning one token.
1861      *
1862      * `startTokenId` - the first token ID to be transferred.
1863      * `quantity` - the amount to be transferred.
1864      *
1865      * Calling conditions:
1866      *
1867      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1868      * transferred to `to`.
1869      * - When `from` is zero, `tokenId` will be minted for `to`.
1870      * - When `to` is zero, `tokenId` will be burned by `from`.
1871      * - `from` and `to` are never both zero.
1872      */
1873     function _beforeTokenTransfers(
1874         address from,
1875         address to,
1876         uint256 startTokenId,
1877         uint256 quantity
1878     ) internal virtual {}
1879 
1880     /**
1881      * @dev Hook that is called after a set of serially-ordered token IDs
1882      * have been transferred. This includes minting.
1883      * And also called after one token has been burned.
1884      *
1885      * `startTokenId` - the first token ID to be transferred.
1886      * `quantity` - the amount to be transferred.
1887      *
1888      * Calling conditions:
1889      *
1890      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1891      * transferred to `to`.
1892      * - When `from` is zero, `tokenId` has been minted for `to`.
1893      * - When `to` is zero, `tokenId` has been burned by `from`.
1894      * - `from` and `to` are never both zero.
1895      */
1896     function _afterTokenTransfers(
1897         address from,
1898         address to,
1899         uint256 startTokenId,
1900         uint256 quantity
1901     ) internal virtual {}
1902 
1903     /**
1904      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1905      *
1906      * `from` - Previous owner of the given token ID.
1907      * `to` - Target address that will receive the token.
1908      * `tokenId` - Token ID to be transferred.
1909      * `_data` - Optional data to send along with the call.
1910      *
1911      * Returns whether the call correctly returned the expected magic value.
1912      */
1913     function _checkContractOnERC721Received(
1914         address from,
1915         address to,
1916         uint256 tokenId,
1917         bytes memory _data
1918     ) private returns (bool) {
1919         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1920             bytes4 retval
1921         ) {
1922             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1923         } catch (bytes memory reason) {
1924             if (reason.length == 0) {
1925                 revert TransferToNonERC721ReceiverImplementer();
1926             } else {
1927                 assembly {
1928                     revert(add(32, reason), mload(reason))
1929                 }
1930             }
1931         }
1932     }
1933 
1934     // =============================================================
1935     //                        MINT OPERATIONS
1936     // =============================================================
1937 
1938     /**
1939      * @dev Mints `quantity` tokens and transfers them to `to`.
1940      *
1941      * Requirements:
1942      *
1943      * - `to` cannot be the zero address.
1944      * - `quantity` must be greater than 0.
1945      *
1946      * Emits a {Transfer} event for each mint.
1947      */
1948     function _mint(address to, uint256 quantity) internal virtual {
1949         uint256 startTokenId = _currentIndex;
1950         if (quantity == 0) revert MintZeroQuantity();
1951 
1952         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1953 
1954         // Overflows are incredibly unrealistic.
1955         // `balance` and `numberMinted` have a maximum limit of 2**64.
1956         // `tokenId` has a maximum limit of 2**256.
1957         unchecked {
1958             // Updates:
1959             // - `balance += quantity`.
1960             // - `numberMinted += quantity`.
1961             //
1962             // We can directly add to the `balance` and `numberMinted`.
1963             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1964 
1965             // Updates:
1966             // - `address` to the owner.
1967             // - `startTimestamp` to the timestamp of minting.
1968             // - `burned` to `false`.
1969             // - `nextInitialized` to `quantity == 1`.
1970             _packedOwnerships[startTokenId] = _packOwnershipData(
1971                 to,
1972                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1973             );
1974 
1975             uint256 toMasked;
1976             uint256 end = startTokenId + quantity;
1977 
1978             // Use assembly to loop and emit the `Transfer` event for gas savings.
1979             assembly {
1980                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1981                 toMasked := and(to, _BITMASK_ADDRESS)
1982                 // Emit the `Transfer` event.
1983                 log4(
1984                     0, // Start of data (0, since no data).
1985                     0, // End of data (0, since no data).
1986                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1987                     0, // `address(0)`.
1988                     toMasked, // `to`.
1989                     startTokenId // `tokenId`.
1990                 )
1991 
1992                 for {
1993                     let tokenId := add(startTokenId, 1)
1994                 } iszero(eq(tokenId, end)) {
1995                     tokenId := add(tokenId, 1)
1996                 } {
1997                     // Emit the `Transfer` event. Similar to above.
1998                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1999                 }
2000             }
2001             if (toMasked == 0) revert MintToZeroAddress();
2002 
2003             _currentIndex = end;
2004         }
2005         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2006     }
2007 
2008     /**
2009      * @dev Mints `quantity` tokens and transfers them to `to`.
2010      *
2011      * This function is intended for efficient minting only during contract creation.
2012      *
2013      * It emits only one {ConsecutiveTransfer} as defined in
2014      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2015      * instead of a sequence of {Transfer} event(s).
2016      *
2017      * Calling this function outside of contract creation WILL make your contract
2018      * non-compliant with the ERC721 standard.
2019      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2020      * {ConsecutiveTransfer} event is only permissible during contract creation.
2021      *
2022      * Requirements:
2023      *
2024      * - `to` cannot be the zero address.
2025      * - `quantity` must be greater than 0.
2026      *
2027      * Emits a {ConsecutiveTransfer} event.
2028      */
2029     function _mintERC2309(address to, uint256 quantity) internal virtual {
2030         uint256 startTokenId = _currentIndex;
2031         if (to == address(0)) revert MintToZeroAddress();
2032         if (quantity == 0) revert MintZeroQuantity();
2033         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2034 
2035         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2036 
2037         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2038         unchecked {
2039             // Updates:
2040             // - `balance += quantity`.
2041             // - `numberMinted += quantity`.
2042             //
2043             // We can directly add to the `balance` and `numberMinted`.
2044             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2045 
2046             // Updates:
2047             // - `address` to the owner.
2048             // - `startTimestamp` to the timestamp of minting.
2049             // - `burned` to `false`.
2050             // - `nextInitialized` to `quantity == 1`.
2051             _packedOwnerships[startTokenId] = _packOwnershipData(
2052                 to,
2053                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2054             );
2055 
2056             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2057 
2058             _currentIndex = startTokenId + quantity;
2059         }
2060         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2061     }
2062 
2063     /**
2064      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2065      *
2066      * Requirements:
2067      *
2068      * - If `to` refers to a smart contract, it must implement
2069      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2070      * - `quantity` must be greater than 0.
2071      *
2072      * See {_mint}.
2073      *
2074      * Emits a {Transfer} event for each mint.
2075      */
2076     function _safeMint(
2077         address to,
2078         uint256 quantity,
2079         bytes memory _data
2080     ) internal virtual {
2081         _mint(to, quantity);
2082 
2083         unchecked {
2084             if (to.code.length != 0) {
2085                 uint256 end = _currentIndex;
2086                 uint256 index = end - quantity;
2087                 do {
2088                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2089                         revert TransferToNonERC721ReceiverImplementer();
2090                     }
2091                 } while (index < end);
2092                 // Reentrancy protection.
2093                 if (_currentIndex != end) revert();
2094             }
2095         }
2096     }
2097 
2098     /**
2099      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2100      */
2101     function _safeMint(address to, uint256 quantity) internal virtual {
2102         _safeMint(to, quantity, '');
2103     }
2104 
2105     // =============================================================
2106     //                        BURN OPERATIONS
2107     // =============================================================
2108 
2109     /**
2110      * @dev Equivalent to `_burn(tokenId, false)`.
2111      */
2112     function _burn(uint256 tokenId) internal virtual {
2113         _burn(tokenId, false);
2114     }
2115 
2116     /**
2117      * @dev Destroys `tokenId`.
2118      * The approval is cleared when the token is burned.
2119      *
2120      * Requirements:
2121      *
2122      * - `tokenId` must exist.
2123      *
2124      * Emits a {Transfer} event.
2125      */
2126     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2127         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2128 
2129         address from = address(uint160(prevOwnershipPacked));
2130 
2131         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2132 
2133         if (approvalCheck) {
2134             // The nested ifs save around 20+ gas over a compound boolean condition.
2135             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2136                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2137         }
2138 
2139         _beforeTokenTransfers(from, address(0), tokenId, 1);
2140 
2141         // Clear approvals from the previous owner.
2142         assembly {
2143             if approvedAddress {
2144                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2145                 sstore(approvedAddressSlot, 0)
2146             }
2147         }
2148 
2149         // Underflow of the sender's balance is impossible because we check for
2150         // ownership above and the recipient's balance can't realistically overflow.
2151         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2152         unchecked {
2153             // Updates:
2154             // - `balance -= 1`.
2155             // - `numberBurned += 1`.
2156             //
2157             // We can directly decrement the balance, and increment the number burned.
2158             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2159             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2160 
2161             // Updates:
2162             // - `address` to the last owner.
2163             // - `startTimestamp` to the timestamp of burning.
2164             // - `burned` to `true`.
2165             // - `nextInitialized` to `true`.
2166             _packedOwnerships[tokenId] = _packOwnershipData(
2167                 from,
2168                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2169             );
2170 
2171             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2172             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2173                 uint256 nextTokenId = tokenId + 1;
2174                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2175                 if (_packedOwnerships[nextTokenId] == 0) {
2176                     // If the next slot is within bounds.
2177                     if (nextTokenId != _currentIndex) {
2178                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2179                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2180                     }
2181                 }
2182             }
2183         }
2184 
2185         emit Transfer(from, address(0), tokenId);
2186         _afterTokenTransfers(from, address(0), tokenId, 1);
2187 
2188         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2189         unchecked {
2190             _burnCounter++;
2191         }
2192     }
2193 
2194     // =============================================================
2195     //                     EXTRA DATA OPERATIONS
2196     // =============================================================
2197 
2198     /**
2199      * @dev Directly sets the extra data for the ownership data `index`.
2200      */
2201     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2202         uint256 packed = _packedOwnerships[index];
2203         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2204         uint256 extraDataCasted;
2205         // Cast `extraData` with assembly to avoid redundant masking.
2206         assembly {
2207             extraDataCasted := extraData
2208         }
2209         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2210         _packedOwnerships[index] = packed;
2211     }
2212 
2213     /**
2214      * @dev Called during each token transfer to set the 24bit `extraData` field.
2215      * Intended to be overridden by the cosumer contract.
2216      *
2217      * `previousExtraData` - the value of `extraData` before transfer.
2218      *
2219      * Calling conditions:
2220      *
2221      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2222      * transferred to `to`.
2223      * - When `from` is zero, `tokenId` will be minted for `to`.
2224      * - When `to` is zero, `tokenId` will be burned by `from`.
2225      * - `from` and `to` are never both zero.
2226      */
2227     function _extraData(
2228         address from,
2229         address to,
2230         uint24 previousExtraData
2231     ) internal view virtual returns (uint24) {}
2232 
2233     /**
2234      * @dev Returns the next extra data for the packed ownership data.
2235      * The returned result is shifted into position.
2236      */
2237     function _nextExtraData(
2238         address from,
2239         address to,
2240         uint256 prevOwnershipPacked
2241     ) private view returns (uint256) {
2242         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2243         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2244     }
2245 
2246     // =============================================================
2247     //                       OTHER OPERATIONS
2248     // =============================================================
2249 
2250     /**
2251      * @dev Returns the message sender (defaults to `msg.sender`).
2252      *
2253      * If you are writing GSN compatible contracts, you need to override this function.
2254      */
2255     function _msgSenderERC721A() internal view virtual returns (address) {
2256         return msg.sender;
2257     }
2258 
2259     /**
2260      * @dev Converts a uint256 to its ASCII string decimal representation.
2261      */
2262     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2263         assembly {
2264             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2265             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2266             // We will need 1 32-byte word to store the length,
2267             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2268             ptr := add(mload(0x40), 128)
2269             // Update the free memory pointer to allocate.
2270             mstore(0x40, ptr)
2271 
2272             // Cache the end of the memory to calculate the length later.
2273             let end := ptr
2274 
2275             // We write the string from the rightmost digit to the leftmost digit.
2276             // The following is essentially a do-while loop that also handles the zero case.
2277             // Costs a bit more than early returning for the zero case,
2278             // but cheaper in terms of deployment and overall runtime costs.
2279             for {
2280                 // Initialize and perform the first pass without check.
2281                 let temp := value
2282                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2283                 ptr := sub(ptr, 1)
2284                 // Write the character to the pointer.
2285                 // The ASCII index of the '0' character is 48.
2286                 mstore8(ptr, add(48, mod(temp, 10)))
2287                 temp := div(temp, 10)
2288             } temp {
2289                 // Keep dividing `temp` until zero.
2290                 temp := div(temp, 10)
2291             } {
2292                 // Body of the for loop.
2293                 ptr := sub(ptr, 1)
2294                 mstore8(ptr, add(48, mod(temp, 10)))
2295             }
2296 
2297             let length := sub(end, ptr)
2298             // Move the pointer 32 bytes leftwards to make room for the length.
2299             ptr := sub(ptr, 32)
2300             // Store the length.
2301             mstore(ptr, length)
2302         }
2303     }
2304 }
2305 // File: contracts/WolfPupsNFT.sol
2306 // SPDX-License-Identifier: MIT
2307 
2308 pragma solidity ^0.8.4;
2309 
2310 
2311 
2312 
2313 
2314 
2315 
2316 
2317 contract WolfPupsNFT is ERC721A, Ownable, ERC2981,OperatorFilterer{
2318     using SafeMath for uint256;
2319     using Strings for uint256;
2320     using ECDSA for bytes32;
2321   
2322     uint256 public constant maxSupply = 1000;
2323     uint256 public  maxMintAmount = 1;
2324     mapping(address => uint256) public tokensMintedPerAddress; 
2325     string private baseTokenUri;
2326     address private signerAddress = 0x733969d7Bcbb1D155e9204f9Fbd0cEc568EbC082;
2327     bool public paused = false;
2328     bool public checkWhitelist = true;
2329 
2330     constructor(
2331         string memory _name,
2332         string memory _symbol,
2333         string memory _initBaseURI
2334     )   ERC721A(_name, _symbol)
2335         OperatorFilterer(address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6), true)
2336     {
2337         setBaseURI(_initBaseURI);
2338     }
2339 
2340     function verifyAddressSigner(bytes memory signature,address _to) private view returns (bool) {
2341         bytes32 messageHash = keccak256(abi.encodePacked(_to));
2342         return signerAddress == messageHash.toEthSignedMessageHash().recover(signature);
2343     }
2344 
2345     function mint(address _to,uint256 _quantity,bytes memory _signature) public  {
2346         require(!checkWhitelist || verifyAddressSigner(_signature,_to), "SIGNATURE_VALIDATION_FAILED");
2347         require(!paused, "Not Yet Active.");
2348         require(tokensMintedPerAddress[_to] + _quantity <= maxMintAmount ,"Beyond Max Mint");
2349         require((totalSupply() + _quantity) <= maxSupply, "Beyond Max Supply");
2350         
2351         tokensMintedPerAddress[_to]  += _quantity;
2352 
2353         _safeMint(_to, _quantity);
2354     }
2355 
2356     function mMint(address _to,uint256 _quantity) public onlyOwner {
2357       require(totalSupply() + _quantity <= maxSupply, "Beyond Max Supply");
2358       _safeMint(_to, _quantity);
2359   }
2360 
2361 
2362     function _baseURI() internal view virtual override returns (string memory) {
2363         return baseTokenUri;
2364     }
2365 
2366     //return uri for certain token
2367     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2368         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
2369 
2370         //uint256 trueId = tokenId + 1;
2371 
2372         //string memory baseURI = _baseURI();
2373         return bytes(baseTokenUri).length > 0 ? string(abi.encodePacked(baseTokenUri, tokenId.toString(), ".json")) : "";
2374     }
2375 
2376     function setBaseURI(string memory _baseTokenUri) public onlyOwner{
2377         baseTokenUri = _baseTokenUri;
2378     }
2379 
2380     function togglePause() external onlyOwner{
2381         paused = !paused;
2382     }
2383 
2384     function toggleCheckWhitelist() external onlyOwner{
2385         checkWhitelist = !checkWhitelist;
2386     }
2387     
2388     function setMaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
2389         maxMintAmount = _newmaxMintAmount;
2390     }
2391 
2392     function setSignerAddresss(address _newSignerAddress) public onlyOwner {
2393         signerAddress = _newSignerAddress;
2394     }
2395 
2396     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, ERC2981) returns (bool) {
2397         return
2398             ERC721A.supportsInterface(interfaceId) ||
2399             ERC2981.supportsInterface(interfaceId);
2400     }
2401 
2402     function setDefaultRoyalty(address receiver,uint96 feeNumerator) external onlyOwner {
2403         _setDefaultRoyalty(receiver, feeNumerator);
2404     }
2405 
2406     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
2407         super.setApprovalForAll(operator, approved);
2408     }
2409 
2410     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
2411         super.approve(operator, tokenId);
2412     }
2413 
2414     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2415         super.transferFrom(from, to, tokenId);
2416     }
2417 
2418     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
2419         super.safeTransferFrom(from, to, tokenId);
2420     }
2421 
2422     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public override onlyAllowedOperator(from)
2423     {
2424         super.safeTransferFrom(from, to, tokenId, data);
2425     }
2426 
2427     function withdraw() public onlyOwner {
2428      require(payable(msg.sender).send(address(this).balance));
2429     }
2430 }