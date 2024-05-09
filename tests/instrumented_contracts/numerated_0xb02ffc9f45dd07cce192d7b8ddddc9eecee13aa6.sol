1 // SPDX-License-Identifier: MIT
2 /*
3 888b     d888          888             888888b.                              888             
4 8888b   d8888          888             888  "88b                             888             
5 88888b.d88888          888             888  .88P                             888             
6 888Y88888P888  .d88b.  888888  8888b.  8888888K.   .d88b.   8888b.  .d8888b  888888 .d8888b  
7 888 Y888P 888 d8P  Y8b 888        "88b 888  "Y88b d8P  Y8b     "88b 88K      888    88K      
8 888  Y8P  888 88888888 888    .d888888 888    888 88888888 .d888888 "Y8888b. 888    "Y8888b. 
9 888   "   888 Y8b.     Y88b.  888  888 888   d88P Y8b.     888  888      X88 Y88b.       X88 
10 888       888  "Y8888   "Y888 "Y888888 8888888P"   "Y8888  "Y888888  88888P'  "Y888  88888P' 
11                                                                                              
12                              Coded by Devko.dev#7286
13 */
14 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
15 
16 
17 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
18 
19 pragma solidity ^0.8.0;
20 
21 /**
22  * @dev Interface of the ERC165 standard, as defined in the
23  * https://eips.ethereum.org/EIPS/eip-165[EIP].
24  *
25  * Implementers can declare support of contract interfaces, which can then be
26  * queried by others ({ERC165Checker}).
27  *
28  * For an implementation, see {ERC165}.
29  */
30 interface IERC165 {
31     /**
32      * @dev Returns true if this contract implements the interface defined by
33      * `interfaceId`. See the corresponding
34      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
35      * to learn more about how these ids are created.
36      *
37      * This function call must use less than 30 000 gas.
38      */
39     function supportsInterface(bytes4 interfaceId) external view returns (bool);
40 }
41 
42 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
43 
44 
45 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
46 
47 pragma solidity ^0.8.0;
48 
49 
50 /**
51  * @dev Implementation of the {IERC165} interface.
52  *
53  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
54  * for the additional interface id that will be supported. For example:
55  *
56  * ```solidity
57  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
58  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
59  * }
60  * ```
61  *
62  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
63  */
64 abstract contract ERC165 is IERC165 {
65     /**
66      * @dev See {IERC165-supportsInterface}.
67      */
68     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
69         return interfaceId == type(IERC165).interfaceId;
70     }
71 }
72 
73 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
74 
75 
76 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/IERC1155Receiver.sol)
77 
78 pragma solidity ^0.8.0;
79 
80 
81 /**
82  * @dev _Available since v3.1._
83  */
84 interface IERC1155Receiver is IERC165 {
85     /**
86      * @dev Handles the receipt of a single ERC1155 token type. This function is
87      * called at the end of a `safeTransferFrom` after the balance has been updated.
88      *
89      * NOTE: To accept the transfer, this must return
90      * `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
91      * (i.e. 0xf23a6e61, or its own function selector).
92      *
93      * @param operator The address which initiated the transfer (i.e. msg.sender)
94      * @param from The address which previously owned the token
95      * @param id The ID of the token being transferred
96      * @param value The amount of tokens being transferred
97      * @param data Additional data with no specified format
98      * @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
99      */
100     function onERC1155Received(
101         address operator,
102         address from,
103         uint256 id,
104         uint256 value,
105         bytes calldata data
106     ) external returns (bytes4);
107 
108     /**
109      * @dev Handles the receipt of a multiple ERC1155 token types. This function
110      * is called at the end of a `safeBatchTransferFrom` after the balances have
111      * been updated.
112      *
113      * NOTE: To accept the transfer(s), this must return
114      * `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
115      * (i.e. 0xbc197c81, or its own function selector).
116      *
117      * @param operator The address which initiated the batch transfer (i.e. msg.sender)
118      * @param from The address which previously owned the token
119      * @param ids An array containing ids of each token being transferred (order and length must match values array)
120      * @param values An array containing amounts of each token being transferred (order and length must match ids array)
121      * @param data Additional data with no specified format
122      * @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
123      */
124     function onERC1155BatchReceived(
125         address operator,
126         address from,
127         uint256[] calldata ids,
128         uint256[] calldata values,
129         bytes calldata data
130     ) external returns (bytes4);
131 }
132 
133 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol
134 
135 
136 // OpenZeppelin Contracts v4.4.1 (token/ERC1155/utils/ERC1155Receiver.sol)
137 
138 pragma solidity ^0.8.0;
139 
140 
141 
142 /**
143  * @dev _Available since v3.1._
144  */
145 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
146     /**
147      * @dev See {IERC165-supportsInterface}.
148      */
149     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
150         return interfaceId == type(IERC1155Receiver).interfaceId || super.supportsInterface(interfaceId);
151     }
152 }
153 
154 // File: @openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol
155 
156 
157 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC1155/utils/ERC1155Holder.sol)
158 
159 pragma solidity ^0.8.0;
160 
161 
162 /**
163  * Simple implementation of `ERC1155Receiver` that will allow a contract to hold ERC1155 tokens.
164  *
165  * IMPORTANT: When inheriting this contract, you must include a way to use the received tokens, otherwise they will be
166  * stuck.
167  *
168  * @dev _Available since v3.1._
169  */
170 contract ERC1155Holder is ERC1155Receiver {
171     function onERC1155Received(
172         address,
173         address,
174         uint256,
175         uint256,
176         bytes memory
177     ) public virtual override returns (bytes4) {
178         return this.onERC1155Received.selector;
179     }
180 
181     function onERC1155BatchReceived(
182         address,
183         address,
184         uint256[] memory,
185         uint256[] memory,
186         bytes memory
187     ) public virtual override returns (bytes4) {
188         return this.onERC1155BatchReceived.selector;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/utils/Strings.sol
193 
194 
195 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
196 
197 pragma solidity ^0.8.0;
198 
199 /**
200  * @dev String operations.
201  */
202 library Strings {
203     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
204     uint8 private constant _ADDRESS_LENGTH = 20;
205 
206     /**
207      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
208      */
209     function toString(uint256 value) internal pure returns (string memory) {
210         // Inspired by OraclizeAPI's implementation - MIT licence
211         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
212 
213         if (value == 0) {
214             return "0";
215         }
216         uint256 temp = value;
217         uint256 digits;
218         while (temp != 0) {
219             digits++;
220             temp /= 10;
221         }
222         bytes memory buffer = new bytes(digits);
223         while (value != 0) {
224             digits -= 1;
225             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
226             value /= 10;
227         }
228         return string(buffer);
229     }
230 
231     /**
232      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
233      */
234     function toHexString(uint256 value) internal pure returns (string memory) {
235         if (value == 0) {
236             return "0x00";
237         }
238         uint256 temp = value;
239         uint256 length = 0;
240         while (temp != 0) {
241             length++;
242             temp >>= 8;
243         }
244         return toHexString(value, length);
245     }
246 
247     /**
248      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
249      */
250     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
251         bytes memory buffer = new bytes(2 * length + 2);
252         buffer[0] = "0";
253         buffer[1] = "x";
254         for (uint256 i = 2 * length + 1; i > 1; --i) {
255             buffer[i] = _HEX_SYMBOLS[value & 0xf];
256             value >>= 4;
257         }
258         require(value == 0, "Strings: hex length insufficient");
259         return string(buffer);
260     }
261 
262     /**
263      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
264      */
265     function toHexString(address addr) internal pure returns (string memory) {
266         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
267     }
268 }
269 
270 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
271 
272 
273 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 
278 /**
279  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
280  *
281  * These functions can be used to verify that a message was signed by the holder
282  * of the private keys of a given address.
283  */
284 library ECDSA {
285     enum RecoverError {
286         NoError,
287         InvalidSignature,
288         InvalidSignatureLength,
289         InvalidSignatureS,
290         InvalidSignatureV
291     }
292 
293     function _throwError(RecoverError error) private pure {
294         if (error == RecoverError.NoError) {
295             return; // no error: do nothing
296         } else if (error == RecoverError.InvalidSignature) {
297             revert("ECDSA: invalid signature");
298         } else if (error == RecoverError.InvalidSignatureLength) {
299             revert("ECDSA: invalid signature length");
300         } else if (error == RecoverError.InvalidSignatureS) {
301             revert("ECDSA: invalid signature 's' value");
302         } else if (error == RecoverError.InvalidSignatureV) {
303             revert("ECDSA: invalid signature 'v' value");
304         }
305     }
306 
307     /**
308      * @dev Returns the address that signed a hashed message (`hash`) with
309      * `signature` or error string. This address can then be used for verification purposes.
310      *
311      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
312      * this function rejects them by requiring the `s` value to be in the lower
313      * half order, and the `v` value to be either 27 or 28.
314      *
315      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
316      * verification to be secure: it is possible to craft signatures that
317      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
318      * this is by receiving a hash of the original message (which may otherwise
319      * be too long), and then calling {toEthSignedMessageHash} on it.
320      *
321      * Documentation for signature generation:
322      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
323      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
324      *
325      * _Available since v4.3._
326      */
327     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
328         if (signature.length == 65) {
329             bytes32 r;
330             bytes32 s;
331             uint8 v;
332             // ecrecover takes the signature parameters, and the only way to get them
333             // currently is to use assembly.
334             /// @solidity memory-safe-assembly
335             assembly {
336                 r := mload(add(signature, 0x20))
337                 s := mload(add(signature, 0x40))
338                 v := byte(0, mload(add(signature, 0x60)))
339             }
340             return tryRecover(hash, v, r, s);
341         } else {
342             return (address(0), RecoverError.InvalidSignatureLength);
343         }
344     }
345 
346     /**
347      * @dev Returns the address that signed a hashed message (`hash`) with
348      * `signature`. This address can then be used for verification purposes.
349      *
350      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
351      * this function rejects them by requiring the `s` value to be in the lower
352      * half order, and the `v` value to be either 27 or 28.
353      *
354      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
355      * verification to be secure: it is possible to craft signatures that
356      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
357      * this is by receiving a hash of the original message (which may otherwise
358      * be too long), and then calling {toEthSignedMessageHash} on it.
359      */
360     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
361         (address recovered, RecoverError error) = tryRecover(hash, signature);
362         _throwError(error);
363         return recovered;
364     }
365 
366     /**
367      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
368      *
369      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
370      *
371      * _Available since v4.3._
372      */
373     function tryRecover(
374         bytes32 hash,
375         bytes32 r,
376         bytes32 vs
377     ) internal pure returns (address, RecoverError) {
378         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
379         uint8 v = uint8((uint256(vs) >> 255) + 27);
380         return tryRecover(hash, v, r, s);
381     }
382 
383     /**
384      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
385      *
386      * _Available since v4.2._
387      */
388     function recover(
389         bytes32 hash,
390         bytes32 r,
391         bytes32 vs
392     ) internal pure returns (address) {
393         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
394         _throwError(error);
395         return recovered;
396     }
397 
398     /**
399      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
400      * `r` and `s` signature fields separately.
401      *
402      * _Available since v4.3._
403      */
404     function tryRecover(
405         bytes32 hash,
406         uint8 v,
407         bytes32 r,
408         bytes32 s
409     ) internal pure returns (address, RecoverError) {
410         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
411         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
412         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
413         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
414         //
415         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
416         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
417         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
418         // these malleable signatures as well.
419         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
420             return (address(0), RecoverError.InvalidSignatureS);
421         }
422         if (v != 27 && v != 28) {
423             return (address(0), RecoverError.InvalidSignatureV);
424         }
425 
426         // If the signature is valid (and not malleable), return the signer address
427         address signer = ecrecover(hash, v, r, s);
428         if (signer == address(0)) {
429             return (address(0), RecoverError.InvalidSignature);
430         }
431 
432         return (signer, RecoverError.NoError);
433     }
434 
435     /**
436      * @dev Overload of {ECDSA-recover} that receives the `v`,
437      * `r` and `s` signature fields separately.
438      */
439     function recover(
440         bytes32 hash,
441         uint8 v,
442         bytes32 r,
443         bytes32 s
444     ) internal pure returns (address) {
445         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
446         _throwError(error);
447         return recovered;
448     }
449 
450     /**
451      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
452      * produces hash corresponding to the one signed with the
453      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
454      * JSON-RPC method as part of EIP-191.
455      *
456      * See {recover}.
457      */
458     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
459         // 32 is the length in bytes of hash,
460         // enforced by the type signature above
461         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
462     }
463 
464     /**
465      * @dev Returns an Ethereum Signed Message, created from `s`. This
466      * produces hash corresponding to the one signed with the
467      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
468      * JSON-RPC method as part of EIP-191.
469      *
470      * See {recover}.
471      */
472     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
473         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
474     }
475 
476     /**
477      * @dev Returns an Ethereum Signed Typed Data, created from a
478      * `domainSeparator` and a `structHash`. This produces hash corresponding
479      * to the one signed with the
480      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
481      * JSON-RPC method as part of EIP-712.
482      *
483      * See {recover}.
484      */
485     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
486         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
487     }
488 }
489 
490 // File: @openzeppelin/contracts/utils/Context.sol
491 
492 
493 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
494 
495 pragma solidity ^0.8.0;
496 
497 /**
498  * @dev Provides information about the current execution context, including the
499  * sender of the transaction and its data. While these are generally available
500  * via msg.sender and msg.data, they should not be accessed in such a direct
501  * manner, since when dealing with meta-transactions the account sending and
502  * paying for execution may not be the actual sender (as far as an application
503  * is concerned).
504  *
505  * This contract is only required for intermediate, library-like contracts.
506  */
507 abstract contract Context {
508     function _msgSender() internal view virtual returns (address) {
509         return msg.sender;
510     }
511 
512     function _msgData() internal view virtual returns (bytes calldata) {
513         return msg.data;
514     }
515 }
516 
517 // File: @openzeppelin/contracts/access/Ownable.sol
518 
519 
520 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 /**
526  * @dev Contract module which provides a basic access control mechanism, where
527  * there is an account (an owner) that can be granted exclusive access to
528  * specific functions.
529  *
530  * By default, the owner account will be the one that deploys the contract. This
531  * can later be changed with {transferOwnership}.
532  *
533  * This module is used through inheritance. It will make available the modifier
534  * `onlyOwner`, which can be applied to your functions to restrict their use to
535  * the owner.
536  */
537 abstract contract Ownable is Context {
538     address private _owner;
539 
540     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
541 
542     /**
543      * @dev Initializes the contract setting the deployer as the initial owner.
544      */
545     constructor() {
546         _transferOwnership(_msgSender());
547     }
548 
549     /**
550      * @dev Throws if called by any account other than the owner.
551      */
552     modifier onlyOwner() {
553         _checkOwner();
554         _;
555     }
556 
557     /**
558      * @dev Returns the address of the current owner.
559      */
560     function owner() public view virtual returns (address) {
561         return _owner;
562     }
563 
564     /**
565      * @dev Throws if the sender is not the owner.
566      */
567     function _checkOwner() internal view virtual {
568         require(owner() == _msgSender(), "Ownable: caller is not the owner");
569     }
570 
571     /**
572      * @dev Leaves the contract without owner. It will not be possible to call
573      * `onlyOwner` functions anymore. Can only be called by the current owner.
574      *
575      * NOTE: Renouncing ownership will leave the contract without an owner,
576      * thereby removing any functionality that is only available to the owner.
577      */
578     function renounceOwnership() public virtual onlyOwner {
579         _transferOwnership(address(0));
580     }
581 
582     /**
583      * @dev Transfers ownership of the contract to a new account (`newOwner`).
584      * Can only be called by the current owner.
585      */
586     function transferOwnership(address newOwner) public virtual onlyOwner {
587         require(newOwner != address(0), "Ownable: new owner is the zero address");
588         _transferOwnership(newOwner);
589     }
590 
591     /**
592      * @dev Transfers ownership of the contract to a new account (`newOwner`).
593      * Internal function without access restriction.
594      */
595     function _transferOwnership(address newOwner) internal virtual {
596         address oldOwner = _owner;
597         _owner = newOwner;
598         emit OwnershipTransferred(oldOwner, newOwner);
599     }
600 }
601 
602 // File: contract.sol
603 
604 
605 pragma solidity ^0.8.7;
606 
607 
608 
609 
610 interface IMetaBeasts {
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 id,
615         uint256 amount,
616         bytes memory data
617     ) external;
618 
619     function safeBatchTransferFrom(
620         address from,
621         address to,
622         uint256[] calldata ids,
623         uint256[] calldata amounts,
624         bytes calldata data
625     ) external;
626 
627     function balanceOf(address account, uint256 id)
628         external
629         view
630         returns (uint256);
631 }
632 
633 contract MetaBeasts is Ownable, ERC1155Holder {
634     using ECDSA for bytes32;
635     using Strings for uint256;
636 
637     uint256 public _Nonce;
638     uint256 public maxSaleTokens = 2901;
639     uint256 public tokenPrice = 0 ether;
640     uint256 public maxMints = 1;
641     uint256 public tokensMinted;
642     uint256[] private _IdsLeft;
643     mapping(uint256 => uint256) public _Limits;
644     mapping(uint256 => uint256) public _Mints;
645     mapping(address => uint256) private _minters;
646     address private privateSigner = 0x717aD60d9de30F63Bf75df899155C332e4552CF2;
647     string private constant MB_SIG_WORD = "MetaBeasts_ds6d4";
648     bytes32 private latestHashUsed = keccak256("MetaBeasts");
649     IMetaBeasts public metaBeastsContract = IMetaBeasts(0x62cf887b0084eA2AdBcE95f15Dd6E8547AB53f50);
650 
651     bool public publicLive;
652 
653     constructor() {
654         for (uint256 index = 1; index <= 65; index++) {
655             _IdsLeft.push(index);
656         }
657 
658         _Limits[1] = 43;
659         _Limits[2] = 46;
660         _Limits[3] = 54;
661         _Limits[4] = 37;
662         _Limits[5] = 46;
663         _Limits[6] = 53;
664         _Limits[7] = 45;
665         _Limits[8] = 47;
666         _Limits[9] = 40;
667         _Limits[10] = 40;
668         _Limits[11] = 38;
669         _Limits[12] = 37;
670         _Limits[13] = 42;
671         _Limits[14] = 40;
672         _Limits[15] = 40;
673         _Limits[16] = 43;
674         _Limits[17] = 45;
675         _Limits[18] = 50;
676         _Limits[19] = 42;
677         _Limits[20] = 49;
678         _Limits[21] = 40;
679         _Limits[22] = 37;
680         _Limits[23] = 42;
681         _Limits[24] = 48;
682         _Limits[25] = 41;
683         _Limits[26] = 53;
684         _Limits[27] = 46;
685         _Limits[28] = 49;
686         _Limits[29] = 44;
687         _Limits[30] = 35;
688         _Limits[31] = 57;
689         _Limits[32] = 49;
690         _Limits[33] = 49;
691         _Limits[34] = 45;
692         _Limits[35] = 57;
693         _Limits[36] = 49;
694         _Limits[37] = 56;
695         _Limits[38] = 44;
696         _Limits[39] = 47;
697         _Limits[40] = 45;
698         _Limits[41] = 42;
699         _Limits[42] = 40;
700         _Limits[43] = 45;
701         _Limits[44] = 46;
702         _Limits[45] = 51;
703         _Limits[46] = 44;
704         _Limits[47] = 50;
705         _Limits[48] = 43;
706         _Limits[49] = 40;
707         _Limits[50] = 43;
708         _Limits[51] = 45;
709         _Limits[52] = 45;
710         _Limits[53] = 48;
711         _Limits[54] = 40;
712         _Limits[55] = 37;
713         _Limits[56] = 43;
714         _Limits[57] = 47;
715         _Limits[58] = 49;
716         _Limits[59] = 51;
717         _Limits[60] = 36;
718         _Limits[61] = 42;
719         _Limits[62] = 44;
720         _Limits[63] = 36;
721         _Limits[64] = 35;
722         _Limits[65] = 49;
723     }
724 
725     modifier notContract() {
726         require(
727             (!_isContract(msg.sender)) && (msg.sender == tx.origin),
728             "contract not allowed"
729         );
730         _;
731     }
732 
733     function _isContract(address addr) internal view returns (bool) {
734         uint256 size;
735         assembly {
736             size := extcodesize(addr)
737         }
738         return size > 0;
739     }
740 
741     function matchAddresSigner(bytes memory signature)
742         private
743         view
744         returns (bool)
745     {
746         bytes32 hash = keccak256(
747             abi.encodePacked(
748                 "\x19Ethereum Signed Message:\n32",
749                 keccak256(abi.encodePacked(msg.sender, MB_SIG_WORD))
750             )
751         );
752         return privateSigner == hash.recover(signature);
753     }
754 
755     function founderTransferBatch(
756         address to,
757         uint256[] calldata ids,
758         uint256[] calldata amounts,
759         bytes calldata data
760     ) external onlyOwner {
761         metaBeastsContract.safeBatchTransferFrom(
762             address(this),
763             to,
764             ids,
765             amounts,
766             data
767         );
768     }
769 
770     function mint(uint256 quantity, bytes memory signature)
771         external
772         payable
773         notContract
774     {
775         require(publicLive, "MINT_CLOSED");
776         require(tokensMinted + quantity <= maxSaleTokens, "EXCEED_PUBLIC");
777         require(_minters[msg.sender] + quantity <= maxMints, "EXCEED_MINTS");
778         require(tokenPrice * quantity <= msg.value, "INSUFFICIENT_ETH");
779         require(matchAddresSigner(signature), "DIRECT_MINT_DISALLOWED");
780 
781         _minters[msg.sender] = _minters[msg.sender] + quantity;
782         tokensMinted = tokensMinted + quantity;
783         mintRandom(msg.sender, quantity);
784     }
785 
786     function mintRandom(address to, uint256 quantity) private {
787         require(_IdsLeft.length > 0, "NO_TOKEN_LEFT");
788         require(quantity > 0, "NOT_ALLOWED");
789         for (uint256 index = 0; index < quantity; index++) {
790             latestHashUsed = keccak256(
791                 abi.encodePacked(
792                     latestHashUsed,
793                     blockhash(block.number),
794                     blockhash(block.number - _IdsLeft.length),
795                     block.coinbase,
796                     block.timestamp,
797                     block.number,
798                     _Nonce,
799                     block.basefee
800                 )
801             );
802             uint256 randomIndex = uint256(latestHashUsed) % (_IdsLeft.length);
803             uint256 randomTokenId = _IdsLeft[randomIndex];
804             _Mints[randomTokenId]++;
805             _Nonce++;
806             if (_Mints[randomTokenId] == _Limits[randomTokenId]) {
807                 _IdsLeft[randomIndex] = _IdsLeft[_IdsLeft.length - 1];
808                 _IdsLeft.pop();
809             }
810 
811             metaBeastsContract.safeTransferFrom(
812                 address(this),
813                 to,
814                 randomTokenId,
815                 1,
816                 ""
817             );
818         }
819     }
820 
821     function togglePublicSale() external onlyOwner {
822         publicLive = !publicLive;
823     }
824 
825     function setPerWallet(uint256 newLimit) external onlyOwner {
826         maxMints = newLimit;
827     }
828 
829     function setSigner(address newSigner) external onlyOwner {
830         privateSigner = newSigner;
831     }
832 
833     function setPublicPrice(uint256 newPrice) external onlyOwner {
834         tokenPrice = newPrice;
835     }
836 
837     function setPublicReserve(uint256 newCount) external onlyOwner {
838         maxSaleTokens = newCount;
839     }
840 
841     function setMetaBeastsContract(address newAddress) external onlyOwner {
842         metaBeastsContract = IMetaBeasts(newAddress);
843     }
844 
845     function changeLimit(uint256 tokenId, uint256 newLimit) external onlyOwner {
846         _Limits[tokenId] = newLimit;
847     }
848 
849     function withdraw() external onlyOwner {
850         uint256 currentBalance = address(this).balance;
851         payable(0x00000040f69B8E3382734491cBAA241B6a863AB3).transfer(
852             (currentBalance * 525) / 10000
853         );
854         payable(0x2007261e1c354C71cC1FC9597871D5F898339126).transfer(
855             address(this).balance
856         );
857     }
858 
859     function isOk() external view returns (bool) {
860         bool isValid = true;
861         for (uint256 index = 0; index < _IdsLeft.length; index++) {
862             if (
863                 !(_Limits[_IdsLeft[index]] - _Mints[_IdsLeft[index]] <=
864                     metaBeastsContract.balanceOf(
865                         address(this),
866                         _IdsLeft[index]
867                     ))
868             ) {
869                 isValid = false;
870             }
871         }
872         return isValid;
873     }
874 }