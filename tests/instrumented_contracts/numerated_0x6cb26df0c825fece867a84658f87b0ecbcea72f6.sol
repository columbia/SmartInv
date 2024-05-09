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
67 // File: @openzeppelin/contracts/utils/Strings.sol
68 
69 
70 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev String operations.
76  */
77 library Strings {
78     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
79     uint8 private constant _ADDRESS_LENGTH = 20;
80 
81     /**
82      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
83      */
84     function toString(uint256 value) internal pure returns (string memory) {
85         // Inspired by OraclizeAPI's implementation - MIT licence
86         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
87 
88         if (value == 0) {
89             return "0";
90         }
91         uint256 temp = value;
92         uint256 digits;
93         while (temp != 0) {
94             digits++;
95             temp /= 10;
96         }
97         bytes memory buffer = new bytes(digits);
98         while (value != 0) {
99             digits -= 1;
100             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
101             value /= 10;
102         }
103         return string(buffer);
104     }
105 
106     /**
107      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
108      */
109     function toHexString(uint256 value) internal pure returns (string memory) {
110         if (value == 0) {
111             return "0x00";
112         }
113         uint256 temp = value;
114         uint256 length = 0;
115         while (temp != 0) {
116             length++;
117             temp >>= 8;
118         }
119         return toHexString(value, length);
120     }
121 
122     /**
123      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
124      */
125     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
126         bytes memory buffer = new bytes(2 * length + 2);
127         buffer[0] = "0";
128         buffer[1] = "x";
129         for (uint256 i = 2 * length + 1; i > 1; --i) {
130             buffer[i] = _HEX_SYMBOLS[value & 0xf];
131             value >>= 4;
132         }
133         require(value == 0, "Strings: hex length insufficient");
134         return string(buffer);
135     }
136 
137     /**
138      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
139      */
140     function toHexString(address addr) internal pure returns (string memory) {
141         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
142     }
143 }
144 
145 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
146 
147 
148 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/ECDSA.sol)
149 
150 pragma solidity ^0.8.0;
151 
152 
153 /**
154  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
155  *
156  * These functions can be used to verify that a message was signed by the holder
157  * of the private keys of a given address.
158  */
159 library ECDSA {
160     enum RecoverError {
161         NoError,
162         InvalidSignature,
163         InvalidSignatureLength,
164         InvalidSignatureS,
165         InvalidSignatureV
166     }
167 
168     function _throwError(RecoverError error) private pure {
169         if (error == RecoverError.NoError) {
170             return; // no error: do nothing
171         } else if (error == RecoverError.InvalidSignature) {
172             revert("ECDSA: invalid signature");
173         } else if (error == RecoverError.InvalidSignatureLength) {
174             revert("ECDSA: invalid signature length");
175         } else if (error == RecoverError.InvalidSignatureS) {
176             revert("ECDSA: invalid signature 's' value");
177         } else if (error == RecoverError.InvalidSignatureV) {
178             revert("ECDSA: invalid signature 'v' value");
179         }
180     }
181 
182     /**
183      * @dev Returns the address that signed a hashed message (`hash`) with
184      * `signature` or error string. This address can then be used for verification purposes.
185      *
186      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
187      * this function rejects them by requiring the `s` value to be in the lower
188      * half order, and the `v` value to be either 27 or 28.
189      *
190      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
191      * verification to be secure: it is possible to craft signatures that
192      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
193      * this is by receiving a hash of the original message (which may otherwise
194      * be too long), and then calling {toEthSignedMessageHash} on it.
195      *
196      * Documentation for signature generation:
197      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
198      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
199      *
200      * _Available since v4.3._
201      */
202     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
203         // Check the signature length
204         // - case 65: r,s,v signature (standard)
205         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
206         if (signature.length == 65) {
207             bytes32 r;
208             bytes32 s;
209             uint8 v;
210             // ecrecover takes the signature parameters, and the only way to get them
211             // currently is to use assembly.
212             /// @solidity memory-safe-assembly
213             assembly {
214                 r := mload(add(signature, 0x20))
215                 s := mload(add(signature, 0x40))
216                 v := byte(0, mload(add(signature, 0x60)))
217             }
218             return tryRecover(hash, v, r, s);
219         } else if (signature.length == 64) {
220             bytes32 r;
221             bytes32 vs;
222             // ecrecover takes the signature parameters, and the only way to get them
223             // currently is to use assembly.
224             /// @solidity memory-safe-assembly
225             assembly {
226                 r := mload(add(signature, 0x20))
227                 vs := mload(add(signature, 0x40))
228             }
229             return tryRecover(hash, r, vs);
230         } else {
231             return (address(0), RecoverError.InvalidSignatureLength);
232         }
233     }
234 
235     /**
236      * @dev Returns the address that signed a hashed message (`hash`) with
237      * `signature`. This address can then be used for verification purposes.
238      *
239      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
240      * this function rejects them by requiring the `s` value to be in the lower
241      * half order, and the `v` value to be either 27 or 28.
242      *
243      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
244      * verification to be secure: it is possible to craft signatures that
245      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
246      * this is by receiving a hash of the original message (which may otherwise
247      * be too long), and then calling {toEthSignedMessageHash} on it.
248      */
249     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
250         (address recovered, RecoverError error) = tryRecover(hash, signature);
251         _throwError(error);
252         return recovered;
253     }
254 
255     /**
256      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
257      *
258      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
259      *
260      * _Available since v4.3._
261      */
262     function tryRecover(
263         bytes32 hash,
264         bytes32 r,
265         bytes32 vs
266     ) internal pure returns (address, RecoverError) {
267         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
268         uint8 v = uint8((uint256(vs) >> 255) + 27);
269         return tryRecover(hash, v, r, s);
270     }
271 
272     /**
273      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
274      *
275      * _Available since v4.2._
276      */
277     function recover(
278         bytes32 hash,
279         bytes32 r,
280         bytes32 vs
281     ) internal pure returns (address) {
282         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
283         _throwError(error);
284         return recovered;
285     }
286 
287     /**
288      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
289      * `r` and `s` signature fields separately.
290      *
291      * _Available since v4.3._
292      */
293     function tryRecover(
294         bytes32 hash,
295         uint8 v,
296         bytes32 r,
297         bytes32 s
298     ) internal pure returns (address, RecoverError) {
299         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
300         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
301         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
302         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
303         //
304         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
305         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
306         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
307         // these malleable signatures as well.
308         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
309             return (address(0), RecoverError.InvalidSignatureS);
310         }
311         if (v != 27 && v != 28) {
312             return (address(0), RecoverError.InvalidSignatureV);
313         }
314 
315         // If the signature is valid (and not malleable), return the signer address
316         address signer = ecrecover(hash, v, r, s);
317         if (signer == address(0)) {
318             return (address(0), RecoverError.InvalidSignature);
319         }
320 
321         return (signer, RecoverError.NoError);
322     }
323 
324     /**
325      * @dev Overload of {ECDSA-recover} that receives the `v`,
326      * `r` and `s` signature fields separately.
327      */
328     function recover(
329         bytes32 hash,
330         uint8 v,
331         bytes32 r,
332         bytes32 s
333     ) internal pure returns (address) {
334         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
335         _throwError(error);
336         return recovered;
337     }
338 
339     /**
340      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
341      * produces hash corresponding to the one signed with the
342      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
343      * JSON-RPC method as part of EIP-191.
344      *
345      * See {recover}.
346      */
347     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
348         // 32 is the length in bytes of hash,
349         // enforced by the type signature above
350         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
351     }
352 
353     /**
354      * @dev Returns an Ethereum Signed Message, created from `s`. This
355      * produces hash corresponding to the one signed with the
356      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
357      * JSON-RPC method as part of EIP-191.
358      *
359      * See {recover}.
360      */
361     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
362         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
363     }
364 
365     /**
366      * @dev Returns an Ethereum Signed Typed Data, created from a
367      * `domainSeparator` and a `structHash`. This produces hash corresponding
368      * to the one signed with the
369      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
370      * JSON-RPC method as part of EIP-712.
371      *
372      * See {recover}.
373      */
374     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
375         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
376     }
377 }
378 
379 // File: @openzeppelin/contracts/access/IAccessControl.sol
380 
381 
382 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
383 
384 pragma solidity ^0.8.0;
385 
386 /**
387  * @dev External interface of AccessControl declared to support ERC165 detection.
388  */
389 interface IAccessControl {
390     /**
391      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
392      *
393      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
394      * {RoleAdminChanged} not being emitted signaling this.
395      *
396      * _Available since v3.1._
397      */
398     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
399 
400     /**
401      * @dev Emitted when `account` is granted `role`.
402      *
403      * `sender` is the account that originated the contract call, an admin role
404      * bearer except when using {AccessControl-_setupRole}.
405      */
406     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
407 
408     /**
409      * @dev Emitted when `account` is revoked `role`.
410      *
411      * `sender` is the account that originated the contract call:
412      *   - if using `revokeRole`, it is the admin role bearer
413      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
414      */
415     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
416 
417     /**
418      * @dev Returns `true` if `account` has been granted `role`.
419      */
420     function hasRole(bytes32 role, address account) external view returns (bool);
421 
422     /**
423      * @dev Returns the admin role that controls `role`. See {grantRole} and
424      * {revokeRole}.
425      *
426      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
427      */
428     function getRoleAdmin(bytes32 role) external view returns (bytes32);
429 
430     /**
431      * @dev Grants `role` to `account`.
432      *
433      * If `account` had not been already granted `role`, emits a {RoleGranted}
434      * event.
435      *
436      * Requirements:
437      *
438      * - the caller must have ``role``'s admin role.
439      */
440     function grantRole(bytes32 role, address account) external;
441 
442     /**
443      * @dev Revokes `role` from `account`.
444      *
445      * If `account` had been granted `role`, emits a {RoleRevoked} event.
446      *
447      * Requirements:
448      *
449      * - the caller must have ``role``'s admin role.
450      */
451     function revokeRole(bytes32 role, address account) external;
452 
453     /**
454      * @dev Revokes `role` from the calling account.
455      *
456      * Roles are often managed via {grantRole} and {revokeRole}: this function's
457      * purpose is to provide a mechanism for accounts to lose their privileges
458      * if they are compromised (such as when a trusted device is misplaced).
459      *
460      * If the calling account had been granted `role`, emits a {RoleRevoked}
461      * event.
462      *
463      * Requirements:
464      *
465      * - the caller must be `account`.
466      */
467     function renounceRole(bytes32 role, address account) external;
468 }
469 
470 // File: @openzeppelin/contracts/utils/Context.sol
471 
472 
473 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
474 
475 pragma solidity ^0.8.0;
476 
477 /**
478  * @dev Provides information about the current execution context, including the
479  * sender of the transaction and its data. While these are generally available
480  * via msg.sender and msg.data, they should not be accessed in such a direct
481  * manner, since when dealing with meta-transactions the account sending and
482  * paying for execution may not be the actual sender (as far as an application
483  * is concerned).
484  *
485  * This contract is only required for intermediate, library-like contracts.
486  */
487 abstract contract Context {
488     function _msgSender() internal view virtual returns (address) {
489         return msg.sender;
490     }
491 
492     function _msgData() internal view virtual returns (bytes calldata) {
493         return msg.data;
494     }
495 }
496 
497 // File: @openzeppelin/contracts/access/Ownable.sol
498 
499 
500 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
501 
502 pragma solidity ^0.8.0;
503 
504 
505 /**
506  * @dev Contract module which provides a basic access control mechanism, where
507  * there is an account (an owner) that can be granted exclusive access to
508  * specific functions.
509  *
510  * By default, the owner account will be the one that deploys the contract. This
511  * can later be changed with {transferOwnership}.
512  *
513  * This module is used through inheritance. It will make available the modifier
514  * `onlyOwner`, which can be applied to your functions to restrict their use to
515  * the owner.
516  */
517 abstract contract Ownable is Context {
518     address private _owner;
519 
520     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
521 
522     /**
523      * @dev Initializes the contract setting the deployer as the initial owner.
524      */
525     constructor() {
526         _transferOwnership(_msgSender());
527     }
528 
529     /**
530      * @dev Throws if called by any account other than the owner.
531      */
532     modifier onlyOwner() {
533         _checkOwner();
534         _;
535     }
536 
537     /**
538      * @dev Returns the address of the current owner.
539      */
540     function owner() public view virtual returns (address) {
541         return _owner;
542     }
543 
544     /**
545      * @dev Throws if the sender is not the owner.
546      */
547     function _checkOwner() internal view virtual {
548         require(owner() == _msgSender(), "Ownable: caller is not the owner");
549     }
550 
551     /**
552      * @dev Leaves the contract without owner. It will not be possible to call
553      * `onlyOwner` functions anymore. Can only be called by the current owner.
554      *
555      * NOTE: Renouncing ownership will leave the contract without an owner,
556      * thereby removing any functionality that is only available to the owner.
557      */
558     function renounceOwnership() public virtual onlyOwner {
559         _transferOwnership(address(0));
560     }
561 
562     /**
563      * @dev Transfers ownership of the contract to a new account (`newOwner`).
564      * Can only be called by the current owner.
565      */
566     function transferOwnership(address newOwner) public virtual onlyOwner {
567         require(newOwner != address(0), "Ownable: new owner is the zero address");
568         _transferOwnership(newOwner);
569     }
570 
571     /**
572      * @dev Transfers ownership of the contract to a new account (`newOwner`).
573      * Internal function without access restriction.
574      */
575     function _transferOwnership(address newOwner) internal virtual {
576         address oldOwner = _owner;
577         _owner = newOwner;
578         emit OwnershipTransferred(oldOwner, newOwner);
579     }
580 }
581 
582 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
583 
584 
585 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
586 
587 pragma solidity ^0.8.0;
588 
589 /**
590  * @title ERC721 token receiver interface
591  * @dev Interface for any contract that wants to support safeTransfers
592  * from ERC721 asset contracts.
593  */
594 interface IERC721Receiver {
595     /**
596      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
597      * by `operator` from `from`, this function is called.
598      *
599      * It must return its Solidity selector to confirm the token transfer.
600      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
601      *
602      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
603      */
604     function onERC721Received(
605         address operator,
606         address from,
607         uint256 tokenId,
608         bytes calldata data
609     ) external returns (bytes4);
610 }
611 
612 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
613 
614 
615 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
616 
617 pragma solidity ^0.8.0;
618 
619 /**
620  * @dev Interface of the ERC165 standard, as defined in the
621  * https://eips.ethereum.org/EIPS/eip-165[EIP].
622  *
623  * Implementers can declare support of contract interfaces, which can then be
624  * queried by others ({ERC165Checker}).
625  *
626  * For an implementation, see {ERC165}.
627  */
628 interface IERC165 {
629     /**
630      * @dev Returns true if this contract implements the interface defined by
631      * `interfaceId`. See the corresponding
632      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
633      * to learn more about how these ids are created.
634      *
635      * This function call must use less than 30 000 gas.
636      */
637     function supportsInterface(bytes4 interfaceId) external view returns (bool);
638 }
639 
640 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
641 
642 
643 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
644 
645 pragma solidity ^0.8.0;
646 
647 
648 /**
649  * @dev Implementation of the {IERC165} interface.
650  *
651  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
652  * for the additional interface id that will be supported. For example:
653  *
654  * ```solidity
655  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
656  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
657  * }
658  * ```
659  *
660  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
661  */
662 abstract contract ERC165 is IERC165 {
663     /**
664      * @dev See {IERC165-supportsInterface}.
665      */
666     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
667         return interfaceId == type(IERC165).interfaceId;
668     }
669 }
670 
671 // File: @openzeppelin/contracts/access/AccessControl.sol
672 
673 
674 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
675 
676 pragma solidity ^0.8.0;
677 
678 
679 
680 
681 
682 /**
683  * @dev Contract module that allows children to implement role-based access
684  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
685  * members except through off-chain means by accessing the contract event logs. Some
686  * applications may benefit from on-chain enumerability, for those cases see
687  * {AccessControlEnumerable}.
688  *
689  * Roles are referred to by their `bytes32` identifier. These should be exposed
690  * in the external API and be unique. The best way to achieve this is by
691  * using `public constant` hash digests:
692  *
693  * ```
694  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
695  * ```
696  *
697  * Roles can be used to represent a set of permissions. To restrict access to a
698  * function call, use {hasRole}:
699  *
700  * ```
701  * function foo() public {
702  *     require(hasRole(MY_ROLE, msg.sender));
703  *     ...
704  * }
705  * ```
706  *
707  * Roles can be granted and revoked dynamically via the {grantRole} and
708  * {revokeRole} functions. Each role has an associated admin role, and only
709  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
710  *
711  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
712  * that only accounts with this role will be able to grant or revoke other
713  * roles. More complex role relationships can be created by using
714  * {_setRoleAdmin}.
715  *
716  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
717  * grant and revoke this role. Extra precautions should be taken to secure
718  * accounts that have been granted it.
719  */
720 abstract contract AccessControl is Context, IAccessControl, ERC165 {
721     struct RoleData {
722         mapping(address => bool) members;
723         bytes32 adminRole;
724     }
725 
726     mapping(bytes32 => RoleData) private _roles;
727 
728     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
729 
730     /**
731      * @dev Modifier that checks that an account has a specific role. Reverts
732      * with a standardized message including the required role.
733      *
734      * The format of the revert reason is given by the following regular expression:
735      *
736      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
737      *
738      * _Available since v4.1._
739      */
740     modifier onlyRole(bytes32 role) {
741         _checkRole(role);
742         _;
743     }
744 
745     /**
746      * @dev See {IERC165-supportsInterface}.
747      */
748     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
749         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
750     }
751 
752     /**
753      * @dev Returns `true` if `account` has been granted `role`.
754      */
755     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
756         return _roles[role].members[account];
757     }
758 
759     /**
760      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
761      * Overriding this function changes the behavior of the {onlyRole} modifier.
762      *
763      * Format of the revert message is described in {_checkRole}.
764      *
765      * _Available since v4.6._
766      */
767     function _checkRole(bytes32 role) internal view virtual {
768         _checkRole(role, _msgSender());
769     }
770 
771     /**
772      * @dev Revert with a standard message if `account` is missing `role`.
773      *
774      * The format of the revert reason is given by the following regular expression:
775      *
776      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
777      */
778     function _checkRole(bytes32 role, address account) internal view virtual {
779         if (!hasRole(role, account)) {
780             revert(
781                 string(
782                     abi.encodePacked(
783                         "AccessControl: account ",
784                         Strings.toHexString(uint160(account), 20),
785                         " is missing role ",
786                         Strings.toHexString(uint256(role), 32)
787                     )
788                 )
789             );
790         }
791     }
792 
793     /**
794      * @dev Returns the admin role that controls `role`. See {grantRole} and
795      * {revokeRole}.
796      *
797      * To change a role's admin, use {_setRoleAdmin}.
798      */
799     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
800         return _roles[role].adminRole;
801     }
802 
803     /**
804      * @dev Grants `role` to `account`.
805      *
806      * If `account` had not been already granted `role`, emits a {RoleGranted}
807      * event.
808      *
809      * Requirements:
810      *
811      * - the caller must have ``role``'s admin role.
812      *
813      * May emit a {RoleGranted} event.
814      */
815     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
816         _grantRole(role, account);
817     }
818 
819     /**
820      * @dev Revokes `role` from `account`.
821      *
822      * If `account` had been granted `role`, emits a {RoleRevoked} event.
823      *
824      * Requirements:
825      *
826      * - the caller must have ``role``'s admin role.
827      *
828      * May emit a {RoleRevoked} event.
829      */
830     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
831         _revokeRole(role, account);
832     }
833 
834     /**
835      * @dev Revokes `role` from the calling account.
836      *
837      * Roles are often managed via {grantRole} and {revokeRole}: this function's
838      * purpose is to provide a mechanism for accounts to lose their privileges
839      * if they are compromised (such as when a trusted device is misplaced).
840      *
841      * If the calling account had been revoked `role`, emits a {RoleRevoked}
842      * event.
843      *
844      * Requirements:
845      *
846      * - the caller must be `account`.
847      *
848      * May emit a {RoleRevoked} event.
849      */
850     function renounceRole(bytes32 role, address account) public virtual override {
851         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
852 
853         _revokeRole(role, account);
854     }
855 
856     /**
857      * @dev Grants `role` to `account`.
858      *
859      * If `account` had not been already granted `role`, emits a {RoleGranted}
860      * event. Note that unlike {grantRole}, this function doesn't perform any
861      * checks on the calling account.
862      *
863      * May emit a {RoleGranted} event.
864      *
865      * [WARNING]
866      * ====
867      * This function should only be called from the constructor when setting
868      * up the initial roles for the system.
869      *
870      * Using this function in any other way is effectively circumventing the admin
871      * system imposed by {AccessControl}.
872      * ====
873      *
874      * NOTE: This function is deprecated in favor of {_grantRole}.
875      */
876     function _setupRole(bytes32 role, address account) internal virtual {
877         _grantRole(role, account);
878     }
879 
880     /**
881      * @dev Sets `adminRole` as ``role``'s admin role.
882      *
883      * Emits a {RoleAdminChanged} event.
884      */
885     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
886         bytes32 previousAdminRole = getRoleAdmin(role);
887         _roles[role].adminRole = adminRole;
888         emit RoleAdminChanged(role, previousAdminRole, adminRole);
889     }
890 
891     /**
892      * @dev Grants `role` to `account`.
893      *
894      * Internal function without access restriction.
895      *
896      * May emit a {RoleGranted} event.
897      */
898     function _grantRole(bytes32 role, address account) internal virtual {
899         if (!hasRole(role, account)) {
900             _roles[role].members[account] = true;
901             emit RoleGranted(role, account, _msgSender());
902         }
903     }
904 
905     /**
906      * @dev Revokes `role` from `account`.
907      *
908      * Internal function without access restriction.
909      *
910      * May emit a {RoleRevoked} event.
911      */
912     function _revokeRole(bytes32 role, address account) internal virtual {
913         if (hasRole(role, account)) {
914             _roles[role].members[account] = false;
915             emit RoleRevoked(role, account, _msgSender());
916         }
917     }
918 }
919 
920 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
921 
922 
923 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 
928 /**
929  * @dev Required interface of an ERC721 compliant contract.
930  */
931 interface IERC721 is IERC165 {
932     /**
933      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
934      */
935     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
936 
937     /**
938      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
939      */
940     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
941 
942     /**
943      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
944      */
945     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
946 
947     /**
948      * @dev Returns the number of tokens in ``owner``'s account.
949      */
950     function balanceOf(address owner) external view returns (uint256 balance);
951 
952     /**
953      * @dev Returns the owner of the `tokenId` token.
954      *
955      * Requirements:
956      *
957      * - `tokenId` must exist.
958      */
959     function ownerOf(uint256 tokenId) external view returns (address owner);
960 
961     /**
962      * @dev Safely transfers `tokenId` token from `from` to `to`.
963      *
964      * Requirements:
965      *
966      * - `from` cannot be the zero address.
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must exist and be owned by `from`.
969      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId,
978         bytes calldata data
979     ) external;
980 
981     /**
982      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
983      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must exist and be owned by `from`.
990      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
991      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
992      *
993      * Emits a {Transfer} event.
994      */
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 tokenId
999     ) external;
1000 
1001     /**
1002      * @dev Transfers `tokenId` token from `from` to `to`.
1003      *
1004      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1005      *
1006      * Requirements:
1007      *
1008      * - `from` cannot be the zero address.
1009      * - `to` cannot be the zero address.
1010      * - `tokenId` token must be owned by `from`.
1011      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1012      *
1013      * Emits a {Transfer} event.
1014      */
1015     function transferFrom(
1016         address from,
1017         address to,
1018         uint256 tokenId
1019     ) external;
1020 
1021     /**
1022      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1023      * The approval is cleared when the token is transferred.
1024      *
1025      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1026      *
1027      * Requirements:
1028      *
1029      * - The caller must own the token or be an approved operator.
1030      * - `tokenId` must exist.
1031      *
1032      * Emits an {Approval} event.
1033      */
1034     function approve(address to, uint256 tokenId) external;
1035 
1036     /**
1037      * @dev Approve or remove `operator` as an operator for the caller.
1038      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1039      *
1040      * Requirements:
1041      *
1042      * - The `operator` cannot be the caller.
1043      *
1044      * Emits an {ApprovalForAll} event.
1045      */
1046     function setApprovalForAll(address operator, bool _approved) external;
1047 
1048     /**
1049      * @dev Returns the account approved for `tokenId` token.
1050      *
1051      * Requirements:
1052      *
1053      * - `tokenId` must exist.
1054      */
1055     function getApproved(uint256 tokenId) external view returns (address operator);
1056 
1057     /**
1058      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1059      *
1060      * See {setApprovalForAll}
1061      */
1062     function isApprovedForAll(address owner, address operator) external view returns (bool);
1063 }
1064 
1065 // File: erc721b/contracts/ERC721B.sol
1066 
1067 
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 
1072 
1073 
1074 
1075 error InvalidCall();
1076 error BalanceQueryZeroAddress();
1077 error NonExistentToken();
1078 error ApprovalToCurrentOwner();
1079 error ApprovalOwnerIsOperator();
1080 error NotERC721Receiver();
1081 error ERC721ReceiverNotReceived();
1082 
1083 /**
1084  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] 
1085  * Non-Fungible Token Standard, including the Metadata extension and 
1086  * token Auto-ID generation.
1087  *
1088  * You must provide `name()` `symbol()` and `tokenURI(uint256 tokenId)`
1089  * to conform with IERC721Metadata
1090  */
1091 abstract contract ERC721B is Context, ERC165, IERC721 {
1092 
1093   // ============ Storage ============
1094 
1095   // The last token id minted
1096   uint256 private _lastTokenId;
1097   // Mapping from token ID to owner address
1098   mapping(uint256 => address) internal _owners;
1099   // Mapping owner address to token count
1100   mapping(address => uint256) internal _balances;
1101 
1102   // Mapping from token ID to approved address
1103   mapping(uint256 => address) private _tokenApprovals;
1104   // Mapping from owner to operator approvals
1105   mapping(address => mapping(address => bool)) private _operatorApprovals;
1106 
1107   // ============ Read Methods ============
1108 
1109   /**
1110    * @dev See {IERC721-balanceOf}.
1111    */
1112   function balanceOf(address owner) 
1113     public view virtual override returns(uint256) 
1114   {
1115     if (owner == address(0)) revert BalanceQueryZeroAddress();
1116     return _balances[owner];
1117   }
1118 
1119   /**
1120    * @dev Shows the overall amount of tokens generated in the contract
1121    */
1122   function totalSupply() public view virtual returns(uint256) {
1123     return _lastTokenId;
1124   }
1125 
1126   /**
1127    * @dev See {IERC721-ownerOf}.
1128    */
1129   function ownerOf(uint256 tokenId) 
1130     public view virtual override returns(address) 
1131   {
1132     unchecked {
1133       //this is the situation when _owners normalized
1134       uint256 id = tokenId;
1135       if (_owners[id] != address(0)) {
1136         return _owners[id];
1137       }
1138       //this is the situation when _owners is not normalized
1139       if (id > 0 && id <= _lastTokenId) {
1140         //there will never be a case where token 1 is address(0)
1141         while(true) {
1142           id--;
1143           if (id == 0) {
1144             break;
1145           } else if (_owners[id] != address(0)) {
1146             return _owners[id];
1147           }
1148         }
1149       }
1150     }
1151 
1152     revert NonExistentToken();
1153   }
1154 
1155   /**
1156    * @dev See {IERC165-supportsInterface}.
1157    */
1158   function supportsInterface(bytes4 interfaceId) 
1159     public view virtual override(ERC165, IERC165) returns(bool) 
1160   {
1161     return interfaceId == type(IERC721).interfaceId
1162       || super.supportsInterface(interfaceId);
1163   }
1164 
1165   // ============ Approval Methods ============
1166 
1167   /**
1168    * @dev See {IERC721-approve}.
1169    */
1170   function approve(address to, uint256 tokenId) public virtual override {
1171     address owner = ERC721B.ownerOf(tokenId);
1172     if (to == owner) revert ApprovalToCurrentOwner();
1173 
1174     address sender = _msgSender();
1175     if (sender != owner && !isApprovedForAll(owner, sender)) 
1176       revert ApprovalToCurrentOwner();
1177 
1178     _approve(to, tokenId, owner);
1179   }
1180 
1181   /**
1182    * @dev See {IERC721-getApproved}.
1183    */
1184   function getApproved(uint256 tokenId) 
1185     public view virtual override returns(address) 
1186   {
1187     if (!_exists(tokenId)) revert NonExistentToken();
1188     return _tokenApprovals[tokenId];
1189   }
1190 
1191   /**
1192    * @dev See {IERC721-isApprovedForAll}.
1193    */
1194   function isApprovedForAll(address owner, address operator) 
1195     public view virtual override returns (bool) 
1196   {
1197     return _operatorApprovals[owner][operator];
1198   }
1199 
1200   /**
1201    * @dev See {IERC721-setApprovalForAll}.
1202    */
1203   function setApprovalForAll(address operator, bool approved) 
1204     public virtual override 
1205   {
1206     _setApprovalForAll(_msgSender(), operator, approved);
1207   }
1208 
1209   /**
1210    * @dev Approve `to` to operate on `tokenId`
1211    *
1212    * Emits a {Approval} event.
1213    */
1214   function _approve(address to, uint256 tokenId, address owner) 
1215     internal virtual 
1216   {
1217     _tokenApprovals[tokenId] = to;
1218     emit Approval(owner, to, tokenId);
1219   }
1220 
1221   /**
1222    * @dev transfers token considering approvals
1223    */
1224   function _approveTransfer(
1225     address spender, 
1226     address from, 
1227     address to, 
1228     uint256 tokenId
1229   ) internal virtual {
1230     if (!_isApprovedOrOwner(spender, tokenId, from)) 
1231       revert InvalidCall();
1232 
1233     _transfer(from, to, tokenId);
1234   }
1235 
1236   /**
1237    * @dev Safely transfers token considering approvals
1238    */
1239   function _approveSafeTransfer(
1240     address from,
1241     address to,
1242     uint256 tokenId,
1243     bytes memory _data
1244   ) internal virtual {
1245     _approveTransfer(_msgSender(), from, to, tokenId);
1246     //see: @openzep/utils/Address.sol
1247     if (to.code.length > 0
1248       && !_checkOnERC721Received(from, to, tokenId, _data)
1249     ) revert ERC721ReceiverNotReceived();
1250   }
1251 
1252   /**
1253    * @dev Returns whether `spender` is allowed to manage `tokenId`.
1254    *
1255    * Requirements:
1256    *
1257    * - `tokenId` must exist.
1258    */
1259   function _isApprovedOrOwner(
1260     address spender, 
1261     uint256 tokenId, 
1262     address owner
1263   ) internal view virtual returns(bool) {
1264     return spender == owner 
1265       || getApproved(tokenId) == spender 
1266       || isApprovedForAll(owner, spender);
1267   }
1268 
1269   /**
1270    * @dev Approve `operator` to operate on all of `owner` tokens
1271    *
1272    * Emits a {ApprovalForAll} event.
1273    */
1274   function _setApprovalForAll(
1275     address owner,
1276     address operator,
1277     bool approved
1278   ) internal virtual {
1279     if (owner == operator) revert ApprovalOwnerIsOperator();
1280     _operatorApprovals[owner][operator] = approved;
1281     emit ApprovalForAll(owner, operator, approved);
1282   }
1283 
1284   // ============ Mint Methods ============
1285 
1286   /**
1287    * @dev Mints `tokenId` and transfers it to `to`.
1288    *
1289    * WARNING: Usage of this method is discouraged, use {_safeMint} 
1290    * whenever possible
1291    *
1292    * Requirements:
1293    *
1294    * - `tokenId` must not exist.
1295    * - `to` cannot be the zero address.
1296    *
1297    * Emits a {Transfer} event.
1298    */
1299   function _mint(
1300     address to,
1301     uint256 amount,
1302     bytes memory _data,
1303     bool safeCheck
1304   ) private {
1305     if(amount == 0 || to == address(0)) revert InvalidCall();
1306     uint256 startTokenId = _lastTokenId + 1;
1307     
1308     _beforeTokenTransfers(address(0), to, startTokenId, amount);
1309     
1310     unchecked {
1311       _lastTokenId += amount;
1312       _balances[to] += amount;
1313       _owners[startTokenId] = to;
1314 
1315       _afterTokenTransfers(address(0), to, startTokenId, amount);
1316 
1317       uint256 updatedIndex = startTokenId;
1318       uint256 endIndex = updatedIndex + amount;
1319       //if do safe check and,
1320       //check if contract one time (instead of loop)
1321       //see: @openzep/utils/Address.sol
1322       if (safeCheck && to.code.length > 0) {
1323         //loop emit transfer and received check
1324         do {
1325           emit Transfer(address(0), to, updatedIndex);
1326           if (!_checkOnERC721Received(address(0), to, updatedIndex++, _data))
1327             revert ERC721ReceiverNotReceived();
1328         } while (updatedIndex != endIndex);
1329         return;
1330       }
1331 
1332       do {
1333         emit Transfer(address(0), to, updatedIndex++);
1334       } while (updatedIndex != endIndex);
1335     }
1336   }
1337 
1338   /**
1339    * @dev Safely mints `tokenId` and transfers it to `to`.
1340    *
1341    * Requirements:
1342    *
1343    * - `tokenId` must not exist.
1344    * - If `to` refers to a smart contract, it must implement 
1345    *   {IERC721Receiver-onERC721Received}, which is called upon a 
1346    *   safe transfer.
1347    *
1348    * Emits a {Transfer} event.
1349    */
1350   function _safeMint(address to, uint256 amount) internal virtual {
1351     _safeMint(to, amount, "");
1352   }
1353 
1354   /**
1355    * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], 
1356    * with an additional `data` parameter which is forwarded in 
1357    * {IERC721Receiver-onERC721Received} to contract recipients.
1358    */
1359   function _safeMint(
1360     address to,
1361     uint256 amount,
1362     bytes memory _data
1363   ) internal virtual {
1364     _mint(to, amount, _data, true);
1365   }
1366 
1367   // ============ Transfer Methods ============
1368 
1369   /**
1370    * @dev See {IERC721-transferFrom}.
1371    */
1372   function transferFrom(
1373     address from,
1374     address to,
1375     uint256 tokenId
1376   ) public virtual override {
1377     _approveTransfer(_msgSender(), from, to, tokenId);
1378   }
1379 
1380   /**
1381    * @dev See {IERC721-safeTransferFrom}.
1382    */
1383   function safeTransferFrom(
1384     address from,
1385     address to,
1386     uint256 tokenId
1387   ) public virtual override {
1388     safeTransferFrom(from, to, tokenId, "");
1389   }
1390 
1391   /**
1392    * @dev See {IERC721-safeTransferFrom}.
1393    */
1394   function safeTransferFrom(
1395     address from,
1396     address to,
1397     uint256 tokenId,
1398     bytes memory _data
1399   ) public virtual override {
1400     _approveSafeTransfer(from, to, tokenId, _data);
1401   }
1402 
1403   /**
1404    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} 
1405    * on a target address. The call is not executed if the target address 
1406    * is not a contract.
1407    */
1408   function _checkOnERC721Received(
1409     address from,
1410     address to,
1411     uint256 tokenId,
1412     bytes memory _data
1413   ) private returns (bool) {
1414     try IERC721Receiver(to).onERC721Received(
1415       _msgSender(), from, tokenId, _data
1416     ) returns (bytes4 retval) {
1417       return retval == IERC721Receiver.onERC721Received.selector;
1418     } catch (bytes memory reason) {
1419       if (reason.length == 0) {
1420         revert NotERC721Receiver();
1421       } else {
1422         assembly {
1423           revert(add(32, reason), mload(reason))
1424         }
1425       }
1426     }
1427   }
1428 
1429   /**
1430    * @dev Returns whether `tokenId` exists.
1431    *
1432    * Tokens can be managed by their owner or approved accounts via 
1433    * {approve} or {setApprovalForAll}.
1434    *
1435    * Tokens start existing when they are minted (`_mint`),
1436    * and stop existing when they are burned (`_burn`).
1437    */
1438   function _exists(uint256 tokenId) internal view virtual returns (bool) {
1439     return tokenId > 0 && tokenId <= _lastTokenId;
1440   }
1441 
1442   /**
1443    * @dev Safely transfers `tokenId` token from `from` to `to`, checking 
1444    * first that contract recipients are aware of the ERC721 protocol to 
1445    * prevent tokens from being forever locked.
1446    *
1447    * `_data` is additional data, it has no specified format and it is 
1448    * sent in call to `to`.
1449    *
1450    * This internal function is equivalent to {safeTransferFrom}, and can 
1451    * be used to e.g.
1452    * implement alternative mechanisms to perform token transfer, such as 
1453    * signature-based.
1454    *
1455    * Requirements:
1456    *
1457    * - `from` cannot be the zero address.
1458    * - `to` cannot be the zero address.
1459    * - `tokenId` token must exist and be owned by `from`.
1460    * - If `to` refers to a smart contract, it must implement 
1461    *   {IERC721Receiver-onERC721Received}, which is called upon a 
1462    *   safe transfer.
1463    *
1464    * Emits a {Transfer} event.
1465    */
1466   function _safeTransfer(
1467     address from,
1468     address to,
1469     uint256 tokenId,
1470     bytes memory _data
1471   ) internal virtual {
1472     _transfer(from, to, tokenId);
1473     //see: @openzep/utils/Address.sol
1474     if (to.code.length > 0
1475       && !_checkOnERC721Received(from, to, tokenId, _data)
1476     ) revert ERC721ReceiverNotReceived();
1477   }
1478 
1479   /**
1480    * @dev Transfers `tokenId` from `from` to `to`. As opposed to 
1481    * {transferFrom}, this imposes no restrictions on msg.sender.
1482    *
1483    * Requirements:
1484    *
1485    * - `to` cannot be the zero address.
1486    * - `tokenId` token must be owned by `from`.
1487    *
1488    * Emits a {Transfer} event.
1489    */
1490   function _transfer(address from, address to, uint256 tokenId) private {
1491     //if transfer to null or not the owner
1492     if (to == address(0) || from != ERC721B.ownerOf(tokenId)) 
1493       revert InvalidCall();
1494 
1495     _beforeTokenTransfers(from, to, tokenId, 1);
1496     
1497     // Clear approvals from the previous owner
1498     _approve(address(0), tokenId, from);
1499 
1500     unchecked {
1501       //this is the situation when _owners are normalized
1502       _balances[to] += 1;
1503       _balances[from] -= 1;
1504       _owners[tokenId] = to;
1505       //this is the situation when _owners are not normalized
1506       uint256 nextTokenId = tokenId + 1;
1507       if (nextTokenId <= _lastTokenId && _owners[nextTokenId] == address(0)) {
1508         _owners[nextTokenId] = from;
1509       }
1510     }
1511 
1512     _afterTokenTransfers(from, to, tokenId, 1);
1513     emit Transfer(from, to, tokenId);
1514   }
1515 
1516   // ============ TODO Methods ============
1517 
1518   /**
1519    * @dev Hook that is called before a set of serially-ordered token ids 
1520    * are about to be transferred. This includes minting.
1521    *
1522    * startTokenId - the first token id to be transferred
1523    * amount - the amount to be transferred
1524    *
1525    * Calling conditions:
1526    *
1527    * - When `from` and `to` are both non-zero, ``from``'s `tokenId` 
1528    *   will be transferred to `to`.
1529    * - When `from` is zero, `tokenId` will be minted for `to`.
1530    */
1531   function _beforeTokenTransfers(
1532     address from,
1533     address to,
1534     uint256 startTokenId,
1535     uint256 amount
1536   ) internal virtual {}
1537 
1538   /**
1539    * @dev Hook that is called after a set of serially-ordered token ids 
1540    * have been transferred. This includes minting.
1541    *
1542    * startTokenId - the first token id to be transferred
1543    * amount - the amount to be transferred
1544    *
1545    * Calling conditions:
1546    *
1547    * - when `from` and `to` are both non-zero.
1548    * - `from` and `to` are never both zero.
1549    */
1550   function _afterTokenTransfers(
1551     address from,
1552     address to,
1553     uint256 startTokenId,
1554     uint256 amount
1555   ) internal virtual {}
1556 }
1557 
1558 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1559 
1560 
1561 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1562 
1563 pragma solidity ^0.8.0;
1564 
1565 
1566 /**
1567  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1568  * @dev See https://eips.ethereum.org/EIPS/eip-721
1569  */
1570 interface IERC721Metadata is IERC721 {
1571     /**
1572      * @dev Returns the token collection name.
1573      */
1574     function name() external view returns (string memory);
1575 
1576     /**
1577      * @dev Returns the token collection symbol.
1578      */
1579     function symbol() external view returns (string memory);
1580 
1581     /**
1582      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1583      */
1584     function tokenURI(uint256 tokenId) external view returns (string memory);
1585 }
1586 
1587 // File: lifesajoke.sol
1588 
1589 
1590 pragma solidity ^0.8.0;  
1591 
1592 
1593 
1594 
1595 
1596 
1597 
1598 contract LifesAJoke is Ownable,AccessControl,ReentrancyGuard,ERC721B,IERC721Metadata{ 
1599   using Strings for uint256;
1600     
1601   bytes32 private constant _MINTER_ROLE = keccak256("MINTER_ROLE"); 
1602   bytes32 private constant _APPROVED_ROLE = keccak256("APPROVED_ROLE");
1603   bytes4 private constant _INTERFACE_ID_ERC2981 = 0x2a55205a;
1604   uint16 public constant MAX_SUPPLY = 5555; 
1605   string private notRevealURI = "ipfs://bafkreiek6ux4f5rsgcomruroxlldosakkrvs74l74njui4m3bjka3fjyvy";  
1606  
1607   mapping(address => uint256) public minted; 
1608   bool public isStartPublicSale = false; 
1609   bool public isStartWhiteListSale = false; 
1610   string private _baseTokenURI; 
1611   string private _CONTRACT_URI = "ipfs://bafkreicih7gxqyngcsk7ip6wcoccfbz3wh6ecfabfgzmpybtkh7fiwg6vu";  
1612   uint256 public maxPerWallet = 1; 
1613   uint256 public mintPrice = 0 ether;   
1614   uint256 public creatorFees = 1000; 
1615   address public treasury = 0xfa83B36104cbB964a001B91bc4154C673408FeD2; 
1616   
1617   constructor() {
1618     _setupRole(DEFAULT_ADMIN_ROLE, 0xb98325778f105A6B57b9Ed79F563b26a88c5A0A3); 
1619   }
1620 
1621   function isApprovedForAll(
1622     address owner, 
1623     address operator
1624   ) public view override(ERC721B, IERC721) returns(bool) {
1625     return hasRole(_APPROVED_ROLE, operator) 
1626       || super.isApprovedForAll(owner, operator);
1627   } 
1628   
1629   function name() external pure override returns(string memory) {
1630     return "LifesAJokeNFT"; 
1631   }
1632   
1633   function symbol() external pure override returns(string memory) {
1634     return "LAJ";  
1635   }
1636 
1637   function contractURI() external view returns(string memory) {
1638     return _CONTRACT_URI;
1639   }
1640 
1641   function royaltyInfo(
1642     uint256 tokenId,
1643     uint256 salePrice
1644   ) external view returns (
1645     address receiver,
1646     uint256 royaltyAmount
1647   ) {
1648     if (treasury == address(0) || !_exists(tokenId)) 
1649       revert InvalidCall();
1650     
1651     return (
1652       payable(treasury), 
1653       (salePrice * creatorFees) / 10000
1654     );
1655   }
1656  
1657   function tokenURI(uint256 tokenId) external view override returns(string memory) {
1658     if(!_exists(tokenId)) revert InvalidCall();
1659     return bytes(_baseTokenURI).length > 0 ? string(
1660       abi.encodePacked(_baseTokenURI, tokenId.toString(), ".json")
1661     ) : notRevealURI;
1662   } 
1663 
1664   function mint(uint256 quantity) external payable nonReentrant {
1665     address recipient = _msgSender(); 
1666     if (recipient.code.length > 0 
1667       || !isStartPublicSale 
1668       || quantity == 0  
1669       || (quantity + minted[recipient]) > maxPerWallet 
1670       || (quantity * mintPrice) > msg.value 
1671       || (totalSupply() + quantity) > MAX_SUPPLY
1672     ) revert InvalidCall(); 
1673     minted[recipient] += quantity;
1674     _safeMint(recipient, quantity);
1675   } 
1676 
1677   function whiteListMint(
1678     uint256 quantity, 
1679     bytes memory proof
1680   ) external payable nonReentrant {
1681     address recipient = _msgSender(); 
1682     if (quantity == 0  
1683       || !isStartWhiteListSale 
1684       || (quantity + minted[recipient]) > maxPerWallet 
1685       || (quantity * mintPrice) > msg.value 
1686       || (totalSupply() + quantity) > MAX_SUPPLY 
1687       || !hasRole(_MINTER_ROLE, ECDSA.recover(
1688         ECDSA.toEthSignedMessageHash(
1689           keccak256(abi.encodePacked("whiteListMint", recipient))
1690         ),
1691         proof
1692       ))
1693     ) revert InvalidCall(); 
1694     minted[recipient] += quantity;
1695     _safeMint(recipient, quantity);
1696   }  
1697 
1698   function mintForAddress(
1699     address recipient,
1700     uint256 quantity
1701   ) external onlyOwner nonReentrant { 
1702     if (quantity == 0  
1703       || (totalSupply() + quantity) > MAX_SUPPLY
1704     ) revert InvalidCall();
1705 
1706     _safeMint(recipient, quantity);
1707   }
1708   
1709   function setBaseURI(string memory uri) external onlyOwner {
1710     _baseTokenURI = uri;
1711   }
1712   
1713   function setContractURI(string memory _uri) external onlyOwner {
1714     _CONTRACT_URI = _uri;
1715   }
1716   
1717   function setMaxPerWallet(uint256 max) external onlyOwner {
1718     maxPerWallet = max;
1719   } 
1720   
1721   function setNotRevealURI(string memory _notRevealURI) external onlyOwner {
1722     notRevealURI = _notRevealURI;
1723   } 
1724 
1725   function setMintPrice(uint256 price) external onlyOwner {
1726     mintPrice = price;
1727   } 
1728 
1729   function setPausesStates(bool _isStartPublicSale,bool _isStartWhiteListSale) external onlyOwner {
1730     isStartPublicSale = _isStartPublicSale;
1731     isStartWhiteListSale = _isStartWhiteListSale;
1732   }  
1733   
1734   function withdraw(address to) external onlyOwner nonReentrant {  
1735     payable(to).transfer(address(this).balance);
1736   } 
1737    
1738   function updateFees(uint256 percent) external onlyOwner {
1739     if (percent > 1000) revert InvalidCall();
1740     creatorFees = percent;
1741   }
1742  
1743   function supportsInterface(
1744     bytes4 interfaceId
1745   ) public view override(AccessControl, ERC721B, IERC165) returns(bool) { 
1746     return interfaceId == type(IERC721Metadata).interfaceId 
1747       || interfaceId == _INTERFACE_ID_ERC2981 
1748       || super.supportsInterface(interfaceId);
1749   }
1750 }