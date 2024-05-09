1 /* SPDX-License-Identifier: MIT */
2 
3 // Sources flattened with hardhat v2.9.1 https://hardhat.org
4 
5 // File @openzeppelin/contracts/utils/Context.sol@v4.5.0
6 
7 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 
32 // File @openzeppelin/contracts/access/Ownable.sol@v4.5.0
33 
34 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
35 
36 pragma solidity ^0.8.0;
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 
109 // File @openzeppelin/contracts/security/Pausable.sol@v4.5.0
110 
111 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
112 
113 pragma solidity ^0.8.0;
114 
115 /**
116  * @dev Contract module which allows children to implement an emergency stop
117  * mechanism that can be triggered by an authorized account.
118  *
119  * This module is used through inheritance. It will make available the
120  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
121  * the functions of your contract. Note that they will not be pausable by
122  * simply including this module, only once the modifiers are put in place.
123  */
124 abstract contract Pausable is Context {
125     /**
126      * @dev Emitted when the pause is triggered by `account`.
127      */
128     event Paused(address account);
129 
130     /**
131      * @dev Emitted when the pause is lifted by `account`.
132      */
133     event Unpaused(address account);
134 
135     bool private _paused;
136 
137     /**
138      * @dev Initializes the contract in unpaused state.
139      */
140     constructor() {
141         _paused = false;
142     }
143 
144     /**
145      * @dev Returns true if the contract is paused, and false otherwise.
146      */
147     function paused() public view virtual returns (bool) {
148         return _paused;
149     }
150 
151     /**
152      * @dev Modifier to make a function callable only when the contract is not paused.
153      *
154      * Requirements:
155      *
156      * - The contract must not be paused.
157      */
158     modifier whenNotPaused() {
159         require(!paused(), "Pausable: paused");
160         _;
161     }
162 
163     /**
164      * @dev Modifier to make a function callable only when the contract is paused.
165      *
166      * Requirements:
167      *
168      * - The contract must be paused.
169      */
170     modifier whenPaused() {
171         require(paused(), "Pausable: not paused");
172         _;
173     }
174 
175     /**
176      * @dev Triggers stopped state.
177      *
178      * Requirements:
179      *
180      * - The contract must not be paused.
181      */
182     function _pause() internal virtual whenNotPaused {
183         _paused = true;
184         emit Paused(_msgSender());
185     }
186 
187     /**
188      * @dev Returns to normal state.
189      *
190      * Requirements:
191      *
192      * - The contract must be paused.
193      */
194     function _unpause() internal virtual whenPaused {
195         _paused = false;
196         emit Unpaused(_msgSender());
197     }
198 }
199 
200 
201 // File @openzeppelin/contracts/utils/Strings.sol@v4.5.0
202 
203 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev String operations.
209  */
210 library Strings {
211     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
212 
213     /**
214      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
215      */
216     function toString(uint256 value) internal pure returns (string memory) {
217         // Inspired by OraclizeAPI's implementation - MIT licence
218         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
219 
220         if (value == 0) {
221             return "0";
222         }
223         uint256 temp = value;
224         uint256 digits;
225         while (temp != 0) {
226             digits++;
227             temp /= 10;
228         }
229         bytes memory buffer = new bytes(digits);
230         while (value != 0) {
231             digits -= 1;
232             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
233             value /= 10;
234         }
235         return string(buffer);
236     }
237 
238     /**
239      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
240      */
241     function toHexString(uint256 value) internal pure returns (string memory) {
242         if (value == 0) {
243             return "0x00";
244         }
245         uint256 temp = value;
246         uint256 length = 0;
247         while (temp != 0) {
248             length++;
249             temp >>= 8;
250         }
251         return toHexString(value, length);
252     }
253 
254     /**
255      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
256      */
257     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
258         bytes memory buffer = new bytes(2 * length + 2);
259         buffer[0] = "0";
260         buffer[1] = "x";
261         for (uint256 i = 2 * length + 1; i > 1; --i) {
262             buffer[i] = _HEX_SYMBOLS[value & 0xf];
263             value >>= 4;
264         }
265         require(value == 0, "Strings: hex length insufficient");
266         return string(buffer);
267     }
268 }
269 
270 
271 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.5.0
272 
273 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
274 
275 pragma solidity ^0.8.0;
276 
277 /**
278  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
279  *
280  * These functions can be used to verify that a message was signed by the holder
281  * of the private keys of a given address.
282  */
283 library ECDSA {
284     enum RecoverError {
285         NoError,
286         InvalidSignature,
287         InvalidSignatureLength,
288         InvalidSignatureS,
289         InvalidSignatureV
290     }
291 
292     function _throwError(RecoverError error) private pure {
293         if (error == RecoverError.NoError) {
294             return; // no error: do nothing
295         } else if (error == RecoverError.InvalidSignature) {
296             revert("ECDSA: invalid signature");
297         } else if (error == RecoverError.InvalidSignatureLength) {
298             revert("ECDSA: invalid signature length");
299         } else if (error == RecoverError.InvalidSignatureS) {
300             revert("ECDSA: invalid signature 's' value");
301         } else if (error == RecoverError.InvalidSignatureV) {
302             revert("ECDSA: invalid signature 'v' value");
303         }
304     }
305 
306     /**
307      * @dev Returns the address that signed a hashed message (`hash`) with
308      * `signature` or error string. This address can then be used for verification purposes.
309      *
310      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
311      * this function rejects them by requiring the `s` value to be in the lower
312      * half order, and the `v` value to be either 27 or 28.
313      *
314      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
315      * verification to be secure: it is possible to craft signatures that
316      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
317      * this is by receiving a hash of the original message (which may otherwise
318      * be too long), and then calling {toEthSignedMessageHash} on it.
319      *
320      * Documentation for signature generation:
321      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
322      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
323      *
324      * _Available since v4.3._
325      */
326     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
327         // Check the signature length
328         // - case 65: r,s,v signature (standard)
329         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
330         if (signature.length == 65) {
331             bytes32 r;
332             bytes32 s;
333             uint8 v;
334             // ecrecover takes the signature parameters, and the only way to get them
335             // currently is to use assembly.
336             assembly {
337                 r := mload(add(signature, 0x20))
338                 s := mload(add(signature, 0x40))
339                 v := byte(0, mload(add(signature, 0x60)))
340             }
341             return tryRecover(hash, v, r, s);
342         } else if (signature.length == 64) {
343             bytes32 r;
344             bytes32 vs;
345             // ecrecover takes the signature parameters, and the only way to get them
346             // currently is to use assembly.
347             assembly {
348                 r := mload(add(signature, 0x20))
349                 vs := mload(add(signature, 0x40))
350             }
351             return tryRecover(hash, r, vs);
352         } else {
353             return (address(0), RecoverError.InvalidSignatureLength);
354         }
355     }
356 
357     /**
358      * @dev Returns the address that signed a hashed message (`hash`) with
359      * `signature`. This address can then be used for verification purposes.
360      *
361      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
362      * this function rejects them by requiring the `s` value to be in the lower
363      * half order, and the `v` value to be either 27 or 28.
364      *
365      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
366      * verification to be secure: it is possible to craft signatures that
367      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
368      * this is by receiving a hash of the original message (which may otherwise
369      * be too long), and then calling {toEthSignedMessageHash} on it.
370      */
371     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
372         (address recovered, RecoverError error) = tryRecover(hash, signature);
373         _throwError(error);
374         return recovered;
375     }
376 
377     /**
378      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
379      *
380      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
381      *
382      * _Available since v4.3._
383      */
384     function tryRecover(
385         bytes32 hash,
386         bytes32 r,
387         bytes32 vs
388     ) internal pure returns (address, RecoverError) {
389         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
390         uint8 v = uint8((uint256(vs) >> 255) + 27);
391         return tryRecover(hash, v, r, s);
392     }
393 
394     /**
395      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
396      *
397      * _Available since v4.2._
398      */
399     function recover(
400         bytes32 hash,
401         bytes32 r,
402         bytes32 vs
403     ) internal pure returns (address) {
404         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
405         _throwError(error);
406         return recovered;
407     }
408 
409     /**
410      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
411      * `r` and `s` signature fields separately.
412      *
413      * _Available since v4.3._
414      */
415     function tryRecover(
416         bytes32 hash,
417         uint8 v,
418         bytes32 r,
419         bytes32 s
420     ) internal pure returns (address, RecoverError) {
421         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
422         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
423         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
424         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
425         //
426         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
427         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
428         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
429         // these malleable signatures as well.
430         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
431             return (address(0), RecoverError.InvalidSignatureS);
432         }
433         if (v != 27 && v != 28) {
434             return (address(0), RecoverError.InvalidSignatureV);
435         }
436 
437         // If the signature is valid (and not malleable), return the signer address
438         address signer = ecrecover(hash, v, r, s);
439         if (signer == address(0)) {
440             return (address(0), RecoverError.InvalidSignature);
441         }
442 
443         return (signer, RecoverError.NoError);
444     }
445 
446     /**
447      * @dev Overload of {ECDSA-recover} that receives the `v`,
448      * `r` and `s` signature fields separately.
449      */
450     function recover(
451         bytes32 hash,
452         uint8 v,
453         bytes32 r,
454         bytes32 s
455     ) internal pure returns (address) {
456         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
457         _throwError(error);
458         return recovered;
459     }
460 
461     /**
462      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
463      * produces hash corresponding to the one signed with the
464      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
465      * JSON-RPC method as part of EIP-191.
466      *
467      * See {recover}.
468      */
469     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
470         // 32 is the length in bytes of hash,
471         // enforced by the type signature above
472         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
473     }
474 
475     /**
476      * @dev Returns an Ethereum Signed Message, created from `s`. This
477      * produces hash corresponding to the one signed with the
478      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
479      * JSON-RPC method as part of EIP-191.
480      *
481      * See {recover}.
482      */
483     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
484         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
485     }
486 
487     /**
488      * @dev Returns an Ethereum Signed Typed Data, created from a
489      * `domainSeparator` and a `structHash`. This produces hash corresponding
490      * to the one signed with the
491      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
492      * JSON-RPC method as part of EIP-712.
493      *
494      * See {recover}.
495      */
496     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
497         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
498     }
499 }
500 
501 
502 // File @openzeppelin/contracts/utils/Counters.sol@v4.5.0
503 
504 // OpenZeppelin Contracts v4.4.1 (utils/Counters.sol)
505 
506 pragma solidity ^0.8.0;
507 
508 /**
509  * @title Counters
510  * @author Matt Condon (@shrugs)
511  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
512  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
513  *
514  * Include with `using Counters for Counters.Counter;`
515  */
516 library Counters {
517     struct Counter {
518         // This variable should never be directly accessed by users of the library: interactions must be restricted to
519         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
520         // this feature: see https://github.com/ethereum/solidity/issues/4637
521         uint256 _value; // default: 0
522     }
523 
524     function current(Counter storage counter) internal view returns (uint256) {
525         return counter._value;
526     }
527 
528     function increment(Counter storage counter) internal {
529         unchecked {
530             counter._value += 1;
531         }
532     }
533 
534     function decrement(Counter storage counter) internal {
535         uint256 value = counter._value;
536         require(value > 0, "Counter: decrement overflow");
537         unchecked {
538             counter._value = value - 1;
539         }
540     }
541 
542     function reset(Counter storage counter) internal {
543         counter._value = 0;
544     }
545 }
546 
547 
548 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.5.0
549 
550 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
551 
552 pragma solidity ^0.8.0;
553 
554 /**
555  * @dev External interface of AccessControl declared to support ERC165 detection.
556  */
557 interface IAccessControl {
558     /**
559      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
560      *
561      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
562      * {RoleAdminChanged} not being emitted signaling this.
563      *
564      * _Available since v3.1._
565      */
566     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
567 
568     /**
569      * @dev Emitted when `account` is granted `role`.
570      *
571      * `sender` is the account that originated the contract call, an admin role
572      * bearer except when using {AccessControl-_setupRole}.
573      */
574     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
575 
576     /**
577      * @dev Emitted when `account` is revoked `role`.
578      *
579      * `sender` is the account that originated the contract call:
580      *   - if using `revokeRole`, it is the admin role bearer
581      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
582      */
583     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
584 
585     /**
586      * @dev Returns `true` if `account` has been granted `role`.
587      */
588     function hasRole(bytes32 role, address account) external view returns (bool);
589 
590     /**
591      * @dev Returns the admin role that controls `role`. See {grantRole} and
592      * {revokeRole}.
593      *
594      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
595      */
596     function getRoleAdmin(bytes32 role) external view returns (bytes32);
597 
598     /**
599      * @dev Grants `role` to `account`.
600      *
601      * If `account` had not been already granted `role`, emits a {RoleGranted}
602      * event.
603      *
604      * Requirements:
605      *
606      * - the caller must have ``role``'s admin role.
607      */
608     function grantRole(bytes32 role, address account) external;
609 
610     /**
611      * @dev Revokes `role` from `account`.
612      *
613      * If `account` had been granted `role`, emits a {RoleRevoked} event.
614      *
615      * Requirements:
616      *
617      * - the caller must have ``role``'s admin role.
618      */
619     function revokeRole(bytes32 role, address account) external;
620 
621     /**
622      * @dev Revokes `role` from the calling account.
623      *
624      * Roles are often managed via {grantRole} and {revokeRole}: this function's
625      * purpose is to provide a mechanism for accounts to lose their privileges
626      * if they are compromised (such as when a trusted device is misplaced).
627      *
628      * If the calling account had been granted `role`, emits a {RoleRevoked}
629      * event.
630      *
631      * Requirements:
632      *
633      * - the caller must be `account`.
634      */
635     function renounceRole(bytes32 role, address account) external;
636 }
637 
638 
639 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.5.0
640 
641 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
642 
643 pragma solidity ^0.8.0;
644 
645 /**
646  * @dev Interface of the ERC165 standard, as defined in the
647  * https://eips.ethereum.org/EIPS/eip-165[EIP].
648  *
649  * Implementers can declare support of contract interfaces, which can then be
650  * queried by others ({ERC165Checker}).
651  *
652  * For an implementation, see {ERC165}.
653  */
654 interface IERC165 {
655     /**
656      * @dev Returns true if this contract implements the interface defined by
657      * `interfaceId`. See the corresponding
658      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
659      * to learn more about how these ids are created.
660      *
661      * This function call must use less than 30 000 gas.
662      */
663     function supportsInterface(bytes4 interfaceId) external view returns (bool);
664 }
665 
666 
667 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.5.0
668 
669 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
670 
671 pragma solidity ^0.8.0;
672 
673 /**
674  * @dev Implementation of the {IERC165} interface.
675  *
676  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
677  * for the additional interface id that will be supported. For example:
678  *
679  * ```solidity
680  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
681  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
682  * }
683  * ```
684  *
685  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
686  */
687 abstract contract ERC165 is IERC165 {
688     /**
689      * @dev See {IERC165-supportsInterface}.
690      */
691     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
692         return interfaceId == type(IERC165).interfaceId;
693     }
694 }
695 
696 
697 // File @openzeppelin/contracts/access/AccessControl.sol@v4.5.0
698 
699 // OpenZeppelin Contracts (last updated v4.5.0) (access/AccessControl.sol)
700 
701 pragma solidity ^0.8.0;
702 
703 
704 
705 
706 /**
707  * @dev Contract module that allows children to implement role-based access
708  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
709  * members except through off-chain means by accessing the contract event logs. Some
710  * applications may benefit from on-chain enumerability, for those cases see
711  * {AccessControlEnumerable}.
712  *
713  * Roles are referred to by their `bytes32` identifier. These should be exposed
714  * in the external API and be unique. The best way to achieve this is by
715  * using `public constant` hash digests:
716  *
717  * ```
718  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
719  * ```
720  *
721  * Roles can be used to represent a set of permissions. To restrict access to a
722  * function call, use {hasRole}:
723  *
724  * ```
725  * function foo() public {
726  *     require(hasRole(MY_ROLE, msg.sender));
727  *     ...
728  * }
729  * ```
730  *
731  * Roles can be granted and revoked dynamically via the {grantRole} and
732  * {revokeRole} functions. Each role has an associated admin role, and only
733  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
734  *
735  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
736  * that only accounts with this role will be able to grant or revoke other
737  * roles. More complex role relationships can be created by using
738  * {_setRoleAdmin}.
739  *
740  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
741  * grant and revoke this role. Extra precautions should be taken to secure
742  * accounts that have been granted it.
743  */
744 abstract contract AccessControl is Context, IAccessControl, ERC165 {
745     struct RoleData {
746         mapping(address => bool) members;
747         bytes32 adminRole;
748     }
749 
750     mapping(bytes32 => RoleData) private _roles;
751 
752     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
753 
754     /**
755      * @dev Modifier that checks that an account has a specific role. Reverts
756      * with a standardized message including the required role.
757      *
758      * The format of the revert reason is given by the following regular expression:
759      *
760      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
761      *
762      * _Available since v4.1._
763      */
764     modifier onlyRole(bytes32 role) {
765         _checkRole(role, _msgSender());
766         _;
767     }
768 
769     /**
770      * @dev See {IERC165-supportsInterface}.
771      */
772     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
773         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
774     }
775 
776     /**
777      * @dev Returns `true` if `account` has been granted `role`.
778      */
779     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
780         return _roles[role].members[account];
781     }
782 
783     /**
784      * @dev Revert with a standard message if `account` is missing `role`.
785      *
786      * The format of the revert reason is given by the following regular expression:
787      *
788      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
789      */
790     function _checkRole(bytes32 role, address account) internal view virtual {
791         if (!hasRole(role, account)) {
792             revert(
793                 string(
794                     abi.encodePacked(
795                         "AccessControl: account ",
796                         Strings.toHexString(uint160(account), 20),
797                         " is missing role ",
798                         Strings.toHexString(uint256(role), 32)
799                     )
800                 )
801             );
802         }
803     }
804 
805     /**
806      * @dev Returns the admin role that controls `role`. See {grantRole} and
807      * {revokeRole}.
808      *
809      * To change a role's admin, use {_setRoleAdmin}.
810      */
811     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
812         return _roles[role].adminRole;
813     }
814 
815     /**
816      * @dev Grants `role` to `account`.
817      *
818      * If `account` had not been already granted `role`, emits a {RoleGranted}
819      * event.
820      *
821      * Requirements:
822      *
823      * - the caller must have ``role``'s admin role.
824      */
825     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
826         _grantRole(role, account);
827     }
828 
829     /**
830      * @dev Revokes `role` from `account`.
831      *
832      * If `account` had been granted `role`, emits a {RoleRevoked} event.
833      *
834      * Requirements:
835      *
836      * - the caller must have ``role``'s admin role.
837      */
838     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
839         _revokeRole(role, account);
840     }
841 
842     /**
843      * @dev Revokes `role` from the calling account.
844      *
845      * Roles are often managed via {grantRole} and {revokeRole}: this function's
846      * purpose is to provide a mechanism for accounts to lose their privileges
847      * if they are compromised (such as when a trusted device is misplaced).
848      *
849      * If the calling account had been revoked `role`, emits a {RoleRevoked}
850      * event.
851      *
852      * Requirements:
853      *
854      * - the caller must be `account`.
855      */
856     function renounceRole(bytes32 role, address account) public virtual override {
857         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
858 
859         _revokeRole(role, account);
860     }
861 
862     /**
863      * @dev Grants `role` to `account`.
864      *
865      * If `account` had not been already granted `role`, emits a {RoleGranted}
866      * event. Note that unlike {grantRole}, this function doesn't perform any
867      * checks on the calling account.
868      *
869      * [WARNING]
870      * ====
871      * This function should only be called from the constructor when setting
872      * up the initial roles for the system.
873      *
874      * Using this function in any other way is effectively circumventing the admin
875      * system imposed by {AccessControl}.
876      * ====
877      *
878      * NOTE: This function is deprecated in favor of {_grantRole}.
879      */
880     function _setupRole(bytes32 role, address account) internal virtual {
881         _grantRole(role, account);
882     }
883 
884     /**
885      * @dev Sets `adminRole` as ``role``'s admin role.
886      *
887      * Emits a {RoleAdminChanged} event.
888      */
889     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
890         bytes32 previousAdminRole = getRoleAdmin(role);
891         _roles[role].adminRole = adminRole;
892         emit RoleAdminChanged(role, previousAdminRole, adminRole);
893     }
894 
895     /**
896      * @dev Grants `role` to `account`.
897      *
898      * Internal function without access restriction.
899      */
900     function _grantRole(bytes32 role, address account) internal virtual {
901         if (!hasRole(role, account)) {
902             _roles[role].members[account] = true;
903             emit RoleGranted(role, account, _msgSender());
904         }
905     }
906 
907     /**
908      * @dev Revokes `role` from `account`.
909      *
910      * Internal function without access restriction.
911      */
912     function _revokeRole(bytes32 role, address account) internal virtual {
913         if (hasRole(role, account)) {
914             _roles[role].members[account] = false;
915             emit RoleRevoked(role, account, _msgSender());
916         }
917     }
918 }
919 
920 
921 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.5.0
922 
923 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
924 
925 pragma solidity ^0.8.0;
926 
927 /**
928  * @dev Required interface of an ERC721 compliant contract.
929  */
930 interface IERC721 is IERC165 {
931     /**
932      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
933      */
934     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
935 
936     /**
937      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
938      */
939     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
940 
941     /**
942      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
943      */
944     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
945 
946     /**
947      * @dev Returns the number of tokens in ``owner``'s account.
948      */
949     function balanceOf(address owner) external view returns (uint256 balance);
950 
951     /**
952      * @dev Returns the owner of the `tokenId` token.
953      *
954      * Requirements:
955      *
956      * - `tokenId` must exist.
957      */
958     function ownerOf(uint256 tokenId) external view returns (address owner);
959 
960     /**
961      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
962      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
963      *
964      * Requirements:
965      *
966      * - `from` cannot be the zero address.
967      * - `to` cannot be the zero address.
968      * - `tokenId` token must exist and be owned by `from`.
969      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
970      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
971      *
972      * Emits a {Transfer} event.
973      */
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 tokenId
978     ) external;
979 
980     /**
981      * @dev Transfers `tokenId` token from `from` to `to`.
982      *
983      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
984      *
985      * Requirements:
986      *
987      * - `from` cannot be the zero address.
988      * - `to` cannot be the zero address.
989      * - `tokenId` token must be owned by `from`.
990      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
991      *
992      * Emits a {Transfer} event.
993      */
994     function transferFrom(
995         address from,
996         address to,
997         uint256 tokenId
998     ) external;
999 
1000     /**
1001      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1002      * The approval is cleared when the token is transferred.
1003      *
1004      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1005      *
1006      * Requirements:
1007      *
1008      * - The caller must own the token or be an approved operator.
1009      * - `tokenId` must exist.
1010      *
1011      * Emits an {Approval} event.
1012      */
1013     function approve(address to, uint256 tokenId) external;
1014 
1015     /**
1016      * @dev Returns the account approved for `tokenId` token.
1017      *
1018      * Requirements:
1019      *
1020      * - `tokenId` must exist.
1021      */
1022     function getApproved(uint256 tokenId) external view returns (address operator);
1023 
1024     /**
1025      * @dev Approve or remove `operator` as an operator for the caller.
1026      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1027      *
1028      * Requirements:
1029      *
1030      * - The `operator` cannot be the caller.
1031      *
1032      * Emits an {ApprovalForAll} event.
1033      */
1034     function setApprovalForAll(address operator, bool _approved) external;
1035 
1036     /**
1037      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1038      *
1039      * See {setApprovalForAll}
1040      */
1041     function isApprovedForAll(address owner, address operator) external view returns (bool);
1042 
1043     /**
1044      * @dev Safely transfers `tokenId` token from `from` to `to`.
1045      *
1046      * Requirements:
1047      *
1048      * - `from` cannot be the zero address.
1049      * - `to` cannot be the zero address.
1050      * - `tokenId` token must exist and be owned by `from`.
1051      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1052      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1053      *
1054      * Emits a {Transfer} event.
1055      */
1056     function safeTransferFrom(
1057         address from,
1058         address to,
1059         uint256 tokenId,
1060         bytes calldata data
1061     ) external;
1062 }
1063 
1064 
1065 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.5.0
1066 
1067 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721Receiver.sol)
1068 
1069 pragma solidity ^0.8.0;
1070 
1071 /**
1072  * @title ERC721 token receiver interface
1073  * @dev Interface for any contract that wants to support safeTransfers
1074  * from ERC721 asset contracts.
1075  */
1076 interface IERC721Receiver {
1077     /**
1078      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
1079      * by `operator` from `from`, this function is called.
1080      *
1081      * It must return its Solidity selector to confirm the token transfer.
1082      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
1083      *
1084      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
1085      */
1086     function onERC721Received(
1087         address operator,
1088         address from,
1089         uint256 tokenId,
1090         bytes calldata data
1091     ) external returns (bytes4);
1092 }
1093 
1094 
1095 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.5.0
1096 
1097 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1098 
1099 pragma solidity ^0.8.0;
1100 
1101 /**
1102  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1103  * @dev See https://eips.ethereum.org/EIPS/eip-721
1104  */
1105 interface IERC721Metadata is IERC721 {
1106     /**
1107      * @dev Returns the token collection name.
1108      */
1109     function name() external view returns (string memory);
1110 
1111     /**
1112      * @dev Returns the token collection symbol.
1113      */
1114     function symbol() external view returns (string memory);
1115 
1116     /**
1117      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1118      */
1119     function tokenURI(uint256 tokenId) external view returns (string memory);
1120 }
1121 
1122 
1123 // File @openzeppelin/contracts/utils/Address.sol@v4.5.0
1124 
1125 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
1126 
1127 pragma solidity ^0.8.1;
1128 
1129 /**
1130  * @dev Collection of functions related to the address type
1131  */
1132 library Address {
1133     /**
1134      * @dev Returns true if `account` is a contract.
1135      *
1136      * [IMPORTANT]
1137      * ====
1138      * It is unsafe to assume that an address for which this function returns
1139      * false is an externally-owned account (EOA) and not a contract.
1140      *
1141      * Among others, `isContract` will return false for the following
1142      * types of addresses:
1143      *
1144      *  - an externally-owned account
1145      *  - a contract in construction
1146      *  - an address where a contract will be created
1147      *  - an address where a contract lived, but was destroyed
1148      * ====
1149      *
1150      * [IMPORTANT]
1151      * ====
1152      * You shouldn't rely on `isContract` to protect against flash loan attacks!
1153      *
1154      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
1155      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
1156      * constructor.
1157      * ====
1158      */
1159     function isContract(address account) internal view returns (bool) {
1160         // This method relies on extcodesize/address.code.length, which returns 0
1161         // for contracts in construction, since the code is only stored at the end
1162         // of the constructor execution.
1163 
1164         return account.code.length > 0;
1165     }
1166 
1167     /**
1168      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1169      * `recipient`, forwarding all available gas and reverting on errors.
1170      *
1171      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1172      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1173      * imposed by `transfer`, making them unable to receive funds via
1174      * `transfer`. {sendValue} removes this limitation.
1175      *
1176      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1177      *
1178      * IMPORTANT: because control is transferred to `recipient`, care must be
1179      * taken to not create reentrancy vulnerabilities. Consider using
1180      * {ReentrancyGuard} or the
1181      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1182      */
1183     function sendValue(address payable recipient, uint256 amount) internal {
1184         require(address(this).balance >= amount, "Address: insufficient balance");
1185 
1186         (bool success, ) = recipient.call{value: amount}("");
1187         require(success, "Address: unable to send value, recipient may have reverted");
1188     }
1189 
1190     /**
1191      * @dev Performs a Solidity function call using a low level `call`. A
1192      * plain `call` is an unsafe replacement for a function call: use this
1193      * function instead.
1194      *
1195      * If `target` reverts with a revert reason, it is bubbled up by this
1196      * function (like regular Solidity function calls).
1197      *
1198      * Returns the raw returned data. To convert to the expected return value,
1199      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1200      *
1201      * Requirements:
1202      *
1203      * - `target` must be a contract.
1204      * - calling `target` with `data` must not revert.
1205      *
1206      * _Available since v3.1._
1207      */
1208     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1209         return functionCall(target, data, "Address: low-level call failed");
1210     }
1211 
1212     /**
1213      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1214      * `errorMessage` as a fallback revert reason when `target` reverts.
1215      *
1216      * _Available since v3.1._
1217      */
1218     function functionCall(
1219         address target,
1220         bytes memory data,
1221         string memory errorMessage
1222     ) internal returns (bytes memory) {
1223         return functionCallWithValue(target, data, 0, errorMessage);
1224     }
1225 
1226     /**
1227      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1228      * but also transferring `value` wei to `target`.
1229      *
1230      * Requirements:
1231      *
1232      * - the calling contract must have an ETH balance of at least `value`.
1233      * - the called Solidity function must be `payable`.
1234      *
1235      * _Available since v3.1._
1236      */
1237     function functionCallWithValue(
1238         address target,
1239         bytes memory data,
1240         uint256 value
1241     ) internal returns (bytes memory) {
1242         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1243     }
1244 
1245     /**
1246      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1247      * with `errorMessage` as a fallback revert reason when `target` reverts.
1248      *
1249      * _Available since v3.1._
1250      */
1251     function functionCallWithValue(
1252         address target,
1253         bytes memory data,
1254         uint256 value,
1255         string memory errorMessage
1256     ) internal returns (bytes memory) {
1257         require(address(this).balance >= value, "Address: insufficient balance for call");
1258         require(isContract(target), "Address: call to non-contract");
1259 
1260         (bool success, bytes memory returndata) = target.call{value: value}(data);
1261         return verifyCallResult(success, returndata, errorMessage);
1262     }
1263 
1264     /**
1265      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1266      * but performing a static call.
1267      *
1268      * _Available since v3.3._
1269      */
1270     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1271         return functionStaticCall(target, data, "Address: low-level static call failed");
1272     }
1273 
1274     /**
1275      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1276      * but performing a static call.
1277      *
1278      * _Available since v3.3._
1279      */
1280     function functionStaticCall(
1281         address target,
1282         bytes memory data,
1283         string memory errorMessage
1284     ) internal view returns (bytes memory) {
1285         require(isContract(target), "Address: static call to non-contract");
1286 
1287         (bool success, bytes memory returndata) = target.staticcall(data);
1288         return verifyCallResult(success, returndata, errorMessage);
1289     }
1290 
1291     /**
1292      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1293      * but performing a delegate call.
1294      *
1295      * _Available since v3.4._
1296      */
1297     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1298         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1299     }
1300 
1301     /**
1302      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1303      * but performing a delegate call.
1304      *
1305      * _Available since v3.4._
1306      */
1307     function functionDelegateCall(
1308         address target,
1309         bytes memory data,
1310         string memory errorMessage
1311     ) internal returns (bytes memory) {
1312         require(isContract(target), "Address: delegate call to non-contract");
1313 
1314         (bool success, bytes memory returndata) = target.delegatecall(data);
1315         return verifyCallResult(success, returndata, errorMessage);
1316     }
1317 
1318     /**
1319      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1320      * revert reason using the provided one.
1321      *
1322      * _Available since v4.3._
1323      */
1324     function verifyCallResult(
1325         bool success,
1326         bytes memory returndata,
1327         string memory errorMessage
1328     ) internal pure returns (bytes memory) {
1329         if (success) {
1330             return returndata;
1331         } else {
1332             // Look for revert reason and bubble it up if present
1333             if (returndata.length > 0) {
1334                 // The easiest way to bubble the revert reason is using memory via assembly
1335 
1336                 assembly {
1337                     let returndata_size := mload(returndata)
1338                     revert(add(32, returndata), returndata_size)
1339                 }
1340             } else {
1341                 revert(errorMessage);
1342             }
1343         }
1344     }
1345 }
1346 
1347 
1348 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.5.0
1349 
1350 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/ERC721.sol)
1351 
1352 pragma solidity ^0.8.0;
1353 
1354 
1355 
1356 
1357 
1358 
1359 
1360 /**
1361  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1362  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1363  * {ERC721Enumerable}.
1364  */
1365 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1366     using Address for address;
1367     using Strings for uint256;
1368 
1369     // Token name
1370     string private _name;
1371 
1372     // Token symbol
1373     string private _symbol;
1374 
1375     // Mapping from token ID to owner address
1376     mapping(uint256 => address) private _owners;
1377 
1378     // Mapping owner address to token count
1379     mapping(address => uint256) private _balances;
1380 
1381     // Mapping from token ID to approved address
1382     mapping(uint256 => address) private _tokenApprovals;
1383 
1384     // Mapping from owner to operator approvals
1385     mapping(address => mapping(address => bool)) private _operatorApprovals;
1386 
1387     /**
1388      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1389      */
1390     constructor(string memory name_, string memory symbol_) {
1391         _name = name_;
1392         _symbol = symbol_;
1393     }
1394 
1395     /**
1396      * @dev See {IERC165-supportsInterface}.
1397      */
1398     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1399         return
1400             interfaceId == type(IERC721).interfaceId ||
1401             interfaceId == type(IERC721Metadata).interfaceId ||
1402             super.supportsInterface(interfaceId);
1403     }
1404 
1405     /**
1406      * @dev See {IERC721-balanceOf}.
1407      */
1408     function balanceOf(address owner) public view virtual override returns (uint256) {
1409         require(owner != address(0), "ERC721: balance query for the zero address");
1410         return _balances[owner];
1411     }
1412 
1413     /**
1414      * @dev See {IERC721-ownerOf}.
1415      */
1416     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1417         address owner = _owners[tokenId];
1418         require(owner != address(0), "ERC721: owner query for nonexistent token");
1419         return owner;
1420     }
1421 
1422     /**
1423      * @dev See {IERC721Metadata-name}.
1424      */
1425     function name() public view virtual override returns (string memory) {
1426         return _name;
1427     }
1428 
1429     /**
1430      * @dev See {IERC721Metadata-symbol}.
1431      */
1432     function symbol() public view virtual override returns (string memory) {
1433         return _symbol;
1434     }
1435 
1436     /**
1437      * @dev See {IERC721Metadata-tokenURI}.
1438      */
1439     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1440         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1441 
1442         string memory baseURI = _baseURI();
1443         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1444     }
1445 
1446     /**
1447      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1448      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1449      * by default, can be overriden in child contracts.
1450      */
1451     function _baseURI() internal view virtual returns (string memory) {
1452         return "";
1453     }
1454 
1455     /**
1456      * @dev See {IERC721-approve}.
1457      */
1458     function approve(address to, uint256 tokenId) public virtual override {
1459         address owner = ERC721.ownerOf(tokenId);
1460         require(to != owner, "ERC721: approval to current owner");
1461 
1462         require(
1463             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1464             "ERC721: approve caller is not owner nor approved for all"
1465         );
1466 
1467         _approve(to, tokenId);
1468     }
1469 
1470     /**
1471      * @dev See {IERC721-getApproved}.
1472      */
1473     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1474         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1475 
1476         return _tokenApprovals[tokenId];
1477     }
1478 
1479     /**
1480      * @dev See {IERC721-setApprovalForAll}.
1481      */
1482     function setApprovalForAll(address operator, bool approved) public virtual override {
1483         _setApprovalForAll(_msgSender(), operator, approved);
1484     }
1485 
1486     /**
1487      * @dev See {IERC721-isApprovedForAll}.
1488      */
1489     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1490         return _operatorApprovals[owner][operator];
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-transferFrom}.
1495      */
1496     function transferFrom(
1497         address from,
1498         address to,
1499         uint256 tokenId
1500     ) public virtual override {
1501         //solhint-disable-next-line max-line-length
1502         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1503 
1504         _transfer(from, to, tokenId);
1505     }
1506 
1507     /**
1508      * @dev See {IERC721-safeTransferFrom}.
1509      */
1510     function safeTransferFrom(
1511         address from,
1512         address to,
1513         uint256 tokenId
1514     ) public virtual override {
1515         safeTransferFrom(from, to, tokenId, "");
1516     }
1517 
1518     /**
1519      * @dev See {IERC721-safeTransferFrom}.
1520      */
1521     function safeTransferFrom(
1522         address from,
1523         address to,
1524         uint256 tokenId,
1525         bytes memory _data
1526     ) public virtual override {
1527         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1528         _safeTransfer(from, to, tokenId, _data);
1529     }
1530 
1531     /**
1532      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1533      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1534      *
1535      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1536      *
1537      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1538      * implement alternative mechanisms to perform token transfer, such as signature-based.
1539      *
1540      * Requirements:
1541      *
1542      * - `from` cannot be the zero address.
1543      * - `to` cannot be the zero address.
1544      * - `tokenId` token must exist and be owned by `from`.
1545      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1546      *
1547      * Emits a {Transfer} event.
1548      */
1549     function _safeTransfer(
1550         address from,
1551         address to,
1552         uint256 tokenId,
1553         bytes memory _data
1554     ) internal virtual {
1555         _transfer(from, to, tokenId);
1556         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1557     }
1558 
1559     /**
1560      * @dev Returns whether `tokenId` exists.
1561      *
1562      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1563      *
1564      * Tokens start existing when they are minted (`_mint`),
1565      * and stop existing when they are burned (`_burn`).
1566      */
1567     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1568         return _owners[tokenId] != address(0);
1569     }
1570 
1571     /**
1572      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1573      *
1574      * Requirements:
1575      *
1576      * - `tokenId` must exist.
1577      */
1578     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1579         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1580         address owner = ERC721.ownerOf(tokenId);
1581         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1582     }
1583 
1584     /**
1585      * @dev Safely mints `tokenId` and transfers it to `to`.
1586      *
1587      * Requirements:
1588      *
1589      * - `tokenId` must not exist.
1590      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1591      *
1592      * Emits a {Transfer} event.
1593      */
1594     function _safeMint(address to, uint256 tokenId) internal virtual {
1595         _safeMint(to, tokenId, "");
1596     }
1597 
1598     /**
1599      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1600      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1601      */
1602     function _safeMint(
1603         address to,
1604         uint256 tokenId,
1605         bytes memory _data
1606     ) internal virtual {
1607         _mint(to, tokenId);
1608         require(
1609             _checkOnERC721Received(address(0), to, tokenId, _data),
1610             "ERC721: transfer to non ERC721Receiver implementer"
1611         );
1612     }
1613 
1614     /**
1615      * @dev Mints `tokenId` and transfers it to `to`.
1616      *
1617      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1618      *
1619      * Requirements:
1620      *
1621      * - `tokenId` must not exist.
1622      * - `to` cannot be the zero address.
1623      *
1624      * Emits a {Transfer} event.
1625      */
1626     function _mint(address to, uint256 tokenId) internal virtual {
1627         require(to != address(0), "ERC721: mint to the zero address");
1628         require(!_exists(tokenId), "ERC721: token already minted");
1629 
1630         _beforeTokenTransfer(address(0), to, tokenId);
1631 
1632         _balances[to] += 1;
1633         _owners[tokenId] = to;
1634 
1635         emit Transfer(address(0), to, tokenId);
1636 
1637         _afterTokenTransfer(address(0), to, tokenId);
1638     }
1639 
1640     /**
1641      * @dev Destroys `tokenId`.
1642      * The approval is cleared when the token is burned.
1643      *
1644      * Requirements:
1645      *
1646      * - `tokenId` must exist.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function _burn(uint256 tokenId) internal virtual {
1651         address owner = ERC721.ownerOf(tokenId);
1652 
1653         _beforeTokenTransfer(owner, address(0), tokenId);
1654 
1655         // Clear approvals
1656         _approve(address(0), tokenId);
1657 
1658         _balances[owner] -= 1;
1659         delete _owners[tokenId];
1660 
1661         emit Transfer(owner, address(0), tokenId);
1662 
1663         _afterTokenTransfer(owner, address(0), tokenId);
1664     }
1665 
1666     /**
1667      * @dev Transfers `tokenId` from `from` to `to`.
1668      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1669      *
1670      * Requirements:
1671      *
1672      * - `to` cannot be the zero address.
1673      * - `tokenId` token must be owned by `from`.
1674      *
1675      * Emits a {Transfer} event.
1676      */
1677     function _transfer(
1678         address from,
1679         address to,
1680         uint256 tokenId
1681     ) internal virtual {
1682         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1683         require(to != address(0), "ERC721: transfer to the zero address");
1684 
1685         _beforeTokenTransfer(from, to, tokenId);
1686 
1687         // Clear approvals from the previous owner
1688         _approve(address(0), tokenId);
1689 
1690         _balances[from] -= 1;
1691         _balances[to] += 1;
1692         _owners[tokenId] = to;
1693 
1694         emit Transfer(from, to, tokenId);
1695 
1696         _afterTokenTransfer(from, to, tokenId);
1697     }
1698 
1699     /**
1700      * @dev Approve `to` to operate on `tokenId`
1701      *
1702      * Emits a {Approval} event.
1703      */
1704     function _approve(address to, uint256 tokenId) internal virtual {
1705         _tokenApprovals[tokenId] = to;
1706         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1707     }
1708 
1709     /**
1710      * @dev Approve `operator` to operate on all of `owner` tokens
1711      *
1712      * Emits a {ApprovalForAll} event.
1713      */
1714     function _setApprovalForAll(
1715         address owner,
1716         address operator,
1717         bool approved
1718     ) internal virtual {
1719         require(owner != operator, "ERC721: approve to caller");
1720         _operatorApprovals[owner][operator] = approved;
1721         emit ApprovalForAll(owner, operator, approved);
1722     }
1723 
1724     /**
1725      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1726      * The call is not executed if the target address is not a contract.
1727      *
1728      * @param from address representing the previous owner of the given token ID
1729      * @param to target address that will receive the tokens
1730      * @param tokenId uint256 ID of the token to be transferred
1731      * @param _data bytes optional data to send along with the call
1732      * @return bool whether the call correctly returned the expected magic value
1733      */
1734     function _checkOnERC721Received(
1735         address from,
1736         address to,
1737         uint256 tokenId,
1738         bytes memory _data
1739     ) private returns (bool) {
1740         if (to.isContract()) {
1741             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1742                 return retval == IERC721Receiver.onERC721Received.selector;
1743             } catch (bytes memory reason) {
1744                 if (reason.length == 0) {
1745                     revert("ERC721: transfer to non ERC721Receiver implementer");
1746                 } else {
1747                     assembly {
1748                         revert(add(32, reason), mload(reason))
1749                     }
1750                 }
1751             }
1752         } else {
1753             return true;
1754         }
1755     }
1756 
1757     /**
1758      * @dev Hook that is called before any token transfer. This includes minting
1759      * and burning.
1760      *
1761      * Calling conditions:
1762      *
1763      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1764      * transferred to `to`.
1765      * - When `from` is zero, `tokenId` will be minted for `to`.
1766      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1767      * - `from` and `to` are never both zero.
1768      *
1769      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1770      */
1771     function _beforeTokenTransfer(
1772         address from,
1773         address to,
1774         uint256 tokenId
1775     ) internal virtual {}
1776 
1777     /**
1778      * @dev Hook that is called after any transfer of tokens. This includes
1779      * minting and burning.
1780      *
1781      * Calling conditions:
1782      *
1783      * - when `from` and `to` are both non-zero.
1784      * - `from` and `to` are never both zero.
1785      *
1786      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1787      */
1788     function _afterTokenTransfer(
1789         address from,
1790         address to,
1791         uint256 tokenId
1792     ) internal virtual {}
1793 }
1794 
1795 
1796 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol@v4.5.0
1797 
1798 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Burnable.sol)
1799 
1800 pragma solidity ^0.8.0;
1801 
1802 
1803 /**
1804  * @title ERC721 Burnable Token
1805  * @dev ERC721 Token that can be irreversibly burned (destroyed).
1806  */
1807 abstract contract ERC721Burnable is Context, ERC721 {
1808     /**
1809      * @dev Burns `tokenId`. See {ERC721-_burn}.
1810      *
1811      * Requirements:
1812      *
1813      * - The caller must own `tokenId` or be an approved operator.
1814      */
1815     function burn(uint256 tokenId) public virtual {
1816         //solhint-disable-next-line max-line-length
1817         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721Burnable: caller is not owner nor approved");
1818         _burn(tokenId);
1819     }
1820 }
1821 
1822 
1823 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.5.0
1824 
1825 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1826 
1827 pragma solidity ^0.8.0;
1828 
1829 /**
1830  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1831  * @dev See https://eips.ethereum.org/EIPS/eip-721
1832  */
1833 interface IERC721Enumerable is IERC721 {
1834     /**
1835      * @dev Returns the total amount of tokens stored by the contract.
1836      */
1837     function totalSupply() external view returns (uint256);
1838 
1839     /**
1840      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1841      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1842      */
1843     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1844 
1845     /**
1846      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1847      * Use along with {totalSupply} to enumerate all tokens.
1848      */
1849     function tokenByIndex(uint256 index) external view returns (uint256);
1850 }
1851 
1852 
1853 // File @openzeppelin/contracts/utils/math/SafeMath.sol@v4.5.0
1854 
1855 // OpenZeppelin Contracts v4.4.1 (utils/math/SafeMath.sol)
1856 
1857 pragma solidity ^0.8.0;
1858 
1859 // CAUTION
1860 // This version of SafeMath should only be used with Solidity 0.8 or later,
1861 // because it relies on the compiler's built in overflow checks.
1862 
1863 /**
1864  * @dev Wrappers over Solidity's arithmetic operations.
1865  *
1866  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
1867  * now has built in overflow checking.
1868  */
1869 library SafeMath {
1870     /**
1871      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1872      *
1873      * _Available since v3.4._
1874      */
1875     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1876         unchecked {
1877             uint256 c = a + b;
1878             if (c < a) return (false, 0);
1879             return (true, c);
1880         }
1881     }
1882 
1883     /**
1884      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1885      *
1886      * _Available since v3.4._
1887      */
1888     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1889         unchecked {
1890             if (b > a) return (false, 0);
1891             return (true, a - b);
1892         }
1893     }
1894 
1895     /**
1896      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1897      *
1898      * _Available since v3.4._
1899      */
1900     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1901         unchecked {
1902             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1903             // benefit is lost if 'b' is also tested.
1904             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1905             if (a == 0) return (true, 0);
1906             uint256 c = a * b;
1907             if (c / a != b) return (false, 0);
1908             return (true, c);
1909         }
1910     }
1911 
1912     /**
1913      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1914      *
1915      * _Available since v3.4._
1916      */
1917     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1918         unchecked {
1919             if (b == 0) return (false, 0);
1920             return (true, a / b);
1921         }
1922     }
1923 
1924     /**
1925      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1926      *
1927      * _Available since v3.4._
1928      */
1929     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1930         unchecked {
1931             if (b == 0) return (false, 0);
1932             return (true, a % b);
1933         }
1934     }
1935 
1936     /**
1937      * @dev Returns the addition of two unsigned integers, reverting on
1938      * overflow.
1939      *
1940      * Counterpart to Solidity's `+` operator.
1941      *
1942      * Requirements:
1943      *
1944      * - Addition cannot overflow.
1945      */
1946     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1947         return a + b;
1948     }
1949 
1950     /**
1951      * @dev Returns the subtraction of two unsigned integers, reverting on
1952      * overflow (when the result is negative).
1953      *
1954      * Counterpart to Solidity's `-` operator.
1955      *
1956      * Requirements:
1957      *
1958      * - Subtraction cannot overflow.
1959      */
1960     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1961         return a - b;
1962     }
1963 
1964     /**
1965      * @dev Returns the multiplication of two unsigned integers, reverting on
1966      * overflow.
1967      *
1968      * Counterpart to Solidity's `*` operator.
1969      *
1970      * Requirements:
1971      *
1972      * - Multiplication cannot overflow.
1973      */
1974     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1975         return a * b;
1976     }
1977 
1978     /**
1979      * @dev Returns the integer division of two unsigned integers, reverting on
1980      * division by zero. The result is rounded towards zero.
1981      *
1982      * Counterpart to Solidity's `/` operator.
1983      *
1984      * Requirements:
1985      *
1986      * - The divisor cannot be zero.
1987      */
1988     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1989         return a / b;
1990     }
1991 
1992     /**
1993      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1994      * reverting when dividing by zero.
1995      *
1996      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1997      * opcode (which leaves remaining gas untouched) while Solidity uses an
1998      * invalid opcode to revert (consuming all remaining gas).
1999      *
2000      * Requirements:
2001      *
2002      * - The divisor cannot be zero.
2003      */
2004     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
2005         return a % b;
2006     }
2007 
2008     /**
2009      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
2010      * overflow (when the result is negative).
2011      *
2012      * CAUTION: This function is deprecated because it requires allocating memory for the error
2013      * message unnecessarily. For custom revert reasons use {trySub}.
2014      *
2015      * Counterpart to Solidity's `-` operator.
2016      *
2017      * Requirements:
2018      *
2019      * - Subtraction cannot overflow.
2020      */
2021     function sub(
2022         uint256 a,
2023         uint256 b,
2024         string memory errorMessage
2025     ) internal pure returns (uint256) {
2026         unchecked {
2027             require(b <= a, errorMessage);
2028             return a - b;
2029         }
2030     }
2031 
2032     /**
2033      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
2034      * division by zero. The result is rounded towards zero.
2035      *
2036      * Counterpart to Solidity's `/` operator. Note: this function uses a
2037      * `revert` opcode (which leaves remaining gas untouched) while Solidity
2038      * uses an invalid opcode to revert (consuming all remaining gas).
2039      *
2040      * Requirements:
2041      *
2042      * - The divisor cannot be zero.
2043      */
2044     function div(
2045         uint256 a,
2046         uint256 b,
2047         string memory errorMessage
2048     ) internal pure returns (uint256) {
2049         unchecked {
2050             require(b > 0, errorMessage);
2051             return a / b;
2052         }
2053     }
2054 
2055     /**
2056      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
2057      * reverting with custom message when dividing by zero.
2058      *
2059      * CAUTION: This function is deprecated because it requires allocating memory for the error
2060      * message unnecessarily. For custom revert reasons use {tryMod}.
2061      *
2062      * Counterpart to Solidity's `%` operator. This function uses a `revert`
2063      * opcode (which leaves remaining gas untouched) while Solidity uses an
2064      * invalid opcode to revert (consuming all remaining gas).
2065      *
2066      * Requirements:
2067      *
2068      * - The divisor cannot be zero.
2069      */
2070     function mod(
2071         uint256 a,
2072         uint256 b,
2073         string memory errorMessage
2074     ) internal pure returns (uint256) {
2075         unchecked {
2076             require(b > 0, errorMessage);
2077             return a % b;
2078         }
2079     }
2080 }
2081 
2082 
2083 // File contracts/common/meta-transactions/ContentMixin.sol
2084 
2085 
2086 pragma solidity ^0.8.15;
2087 
2088 abstract contract ContextMixin {
2089     function msgSender() internal view returns (address payable sender) {
2090         if (msg.sender == address(this)) {
2091             bytes memory array = msg.data;
2092             uint256 index = msg.data.length;
2093             assembly {
2094                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
2095                 sender := and(
2096                     mload(add(array, index)),
2097                     0xffffffffffffffffffffffffffffffffffffffff
2098                 )
2099             }
2100         } else {
2101             sender = payable(msg.sender);
2102         }
2103         return sender;
2104     }
2105 }
2106 
2107 
2108 // File contracts/common/meta-transactions/Initializable.sol
2109 
2110 
2111 pragma solidity ^0.8.15;
2112 
2113 contract Initializable {
2114     bool inited = false;
2115 
2116     modifier initializer() {
2117         require(!inited, "already inited");
2118         _;
2119         inited = true;
2120     }
2121 }
2122 
2123 
2124 // File contracts/common/meta-transactions/EIP712Base.sol
2125 
2126 
2127 pragma solidity ^0.8.15;
2128 
2129 contract EIP712Base is Initializable {
2130     struct EIP712Domain {
2131         string name;
2132         string version;
2133         address verifyingContract;
2134         bytes32 salt;
2135     }
2136 
2137     string public constant ERC712_VERSION = "1";
2138 
2139     bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
2140         keccak256(
2141             bytes(
2142                 "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
2143             )
2144         );
2145     bytes32 internal domainSeperator;
2146 
2147     // supposed to be called once while initializing.
2148     // one of the contracts that inherits this contract follows proxy pattern
2149     // so it is not possible to do this in a constructor
2150     function _initializeEIP712(string memory name) internal initializer {
2151         _setDomainSeperator(name);
2152     }
2153 
2154     function _setDomainSeperator(string memory name) internal {
2155         domainSeperator = keccak256(
2156             abi.encode(
2157                 EIP712_DOMAIN_TYPEHASH,
2158                 keccak256(bytes(name)),
2159                 keccak256(bytes(ERC712_VERSION)),
2160                 address(this),
2161                 bytes32(getChainId())
2162             )
2163         );
2164     }
2165 
2166     function getDomainSeperator() public view returns (bytes32) {
2167         return domainSeperator;
2168     }
2169 
2170     function getChainId() public view returns (uint256) {
2171         uint256 id;
2172         assembly {
2173             id := chainid()
2174         }
2175         return id;
2176     }
2177 
2178     /**
2179      * Accept message hash and returns hash message in EIP712 compatible form
2180      * So that it can be used to recover signer from signature signed using EIP712 formatted data
2181      * https://eips.ethereum.org/EIPS/eip-712
2182      * "\\x19" makes the encoding deterministic
2183      * "\\x01" is the version byte to make it compatible to EIP-191
2184      */
2185     function toTypedMessageHash(bytes32 messageHash)
2186         internal
2187         view
2188         returns (bytes32)
2189     {
2190         return
2191             keccak256(
2192                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
2193             );
2194     }
2195 }
2196 
2197 
2198 // File contracts/common/meta-transactions/NativeMetaTransaction.sol
2199 
2200 
2201 pragma solidity ^0.8.15;
2202 
2203 
2204 contract NativeMetaTransaction is EIP712Base {
2205     using SafeMath for uint256;
2206     bytes32 private constant META_TRANSACTION_TYPEHASH =
2207         keccak256(
2208             bytes(
2209                 "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
2210             )
2211         );
2212     event MetaTransactionExecuted(
2213         address userAddress,
2214         address payable relayerAddress,
2215         bytes functionSignature
2216     );
2217     mapping(address => uint256) nonces;
2218 
2219     /*
2220      * Meta transaction structure.
2221      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
2222      * He should call the desired function directly in that case.
2223      */
2224     struct MetaTransaction {
2225         uint256 nonce;
2226         address from;
2227         bytes functionSignature;
2228     }
2229 
2230     function executeMetaTransaction(
2231         address userAddress,
2232         bytes memory functionSignature,
2233         bytes32 sigR,
2234         bytes32 sigS,
2235         uint8 sigV
2236     ) public payable returns (bytes memory) {
2237         MetaTransaction memory metaTx = MetaTransaction({
2238             nonce: nonces[userAddress],
2239             from: userAddress,
2240             functionSignature: functionSignature
2241         });
2242 
2243         require(
2244             verify(userAddress, metaTx, sigR, sigS, sigV),
2245             "Signer and signature do not match"
2246         );
2247 
2248         // increase nonce for user (to avoid re-use)
2249         nonces[userAddress] = nonces[userAddress].add(1);
2250 
2251         emit MetaTransactionExecuted(
2252             userAddress,
2253             payable(msg.sender),
2254             functionSignature
2255         );
2256 
2257         // Append userAddress and relayer address at the end to extract it from calling context
2258         (bool success, bytes memory returnData) = address(this).call(
2259             abi.encodePacked(functionSignature, userAddress)
2260         );
2261         require(success, "Function call not successful");
2262 
2263         return returnData;
2264     }
2265 
2266     function hashMetaTransaction(MetaTransaction memory metaTx)
2267         internal
2268         pure
2269         returns (bytes32)
2270     {
2271         return
2272             keccak256(
2273                 abi.encode(
2274                     META_TRANSACTION_TYPEHASH,
2275                     metaTx.nonce,
2276                     metaTx.from,
2277                     keccak256(metaTx.functionSignature)
2278                 )
2279             );
2280     }
2281 
2282     function getNonce(address user) public view returns (uint256 nonce) {
2283         nonce = nonces[user];
2284     }
2285 
2286     function verify(
2287         address signer,
2288         MetaTransaction memory metaTx,
2289         bytes32 sigR,
2290         bytes32 sigS,
2291         uint8 sigV
2292     ) internal view returns (bool) {
2293         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
2294         return
2295             signer ==
2296             ecrecover(
2297                 toTypedMessageHash(hashMetaTransaction(metaTx)),
2298                 sigV,
2299                 sigR,
2300                 sigS
2301             );
2302     }
2303 }
2304 
2305 
2306 // File contracts/tokens/ERC721/ERC721Tradable.sol
2307 
2308 
2309 pragma solidity ^0.8.15;
2310 
2311 
2312 
2313 
2314 
2315 
2316 contract OwnableDelegateProxy {}
2317 
2318 /**
2319  * Used to delegate ownership of a contract to another address, to save on unneeded transactions to approve contract use for users
2320  */
2321 contract ProxyRegistry {
2322     mapping(address => OwnableDelegateProxy) public proxies;
2323 }
2324 
2325 /**
2326  * @title ERC721Tradable
2327  * ERC721Tradable - ERC721 contract that whitelists a trading address, and has minting functionality.
2328  */
2329 abstract contract ERC721Tradable is
2330     ERC721,
2331     ContextMixin,
2332     NativeMetaTransaction,
2333     Ownable
2334 {
2335     using SafeMath for uint256;
2336     using Counters for Counters.Counter;
2337 
2338     /**
2339      * We rely on the OZ Counter util to keep track of the next available ID.
2340      * We track the nextTokenId instead of the currentTokenId to save users on gas costs.
2341      * Read more about it here: https://shiny.mirror.xyz/OUampBbIz9ebEicfGnQf5At_ReMHlZy0tB4glb9xQ0E
2342      */
2343     Counters.Counter private _nextTokenId;
2344     address proxyRegistryAddress;
2345 
2346     constructor(
2347         string memory _name,
2348         string memory _symbol,
2349         address _proxyRegistryAddress
2350     ) ERC721(_name, _symbol) {
2351         proxyRegistryAddress = _proxyRegistryAddress;
2352         // nextTokenId is initialized to 1, since starting at 0 leads to higher gas cost for the first minter
2353         _nextTokenId.increment();
2354         _initializeEIP712(_name);
2355     }
2356 
2357     /**
2358      * @dev Mints a token to an address with a tokenURI.
2359      * @param _to address of the future owner of the token
2360      */
2361     function mintTo(address _to) public virtual onlyOwner {
2362         uint256 currentTokenId = _nextTokenId.current();
2363         _nextTokenId.increment();
2364         _safeMint(_to, currentTokenId);
2365     }
2366 
2367     /**
2368         @dev Returns the total tokens minted so far.
2369         1 is always subtracted from the Counter since it tracks the next available tokenId.
2370      */
2371     function totalSupply() public view virtual returns (uint256) {
2372         return _nextTokenId.current() - 1;
2373     }
2374 
2375     function baseTokenURI() public view virtual returns (string memory);
2376 
2377     function tokenURI(uint256 _tokenId)
2378         public
2379         view
2380         virtual
2381         override
2382         returns (string memory)
2383     {
2384         return
2385             string(
2386                 abi.encodePacked(baseTokenURI(), Strings.toString(_tokenId))
2387             );
2388     }
2389 
2390     /**
2391      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-less listings.
2392      */
2393     function isApprovedForAll(address owner, address operator)
2394         public
2395         view
2396         virtual
2397         override
2398         returns (bool)
2399     {
2400         // Whitelist OpenSea proxy contract for easy trading.
2401         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
2402         if (address(proxyRegistry.proxies(owner)) == operator) {
2403             return true;
2404         }
2405 
2406         return super.isApprovedForAll(owner, operator);
2407     }
2408 
2409     /**
2410      * This is used instead of msg.sender as transactions won't be sent by the original token owner, but by OpenSea.
2411      */
2412     function _msgSender()
2413         internal
2414         view
2415         virtual
2416         override
2417         returns (address sender)
2418     {
2419         return ContextMixin.msgSender();
2420     }
2421 }
2422 
2423 
2424 // File contracts/tokens/ERC721/WeAllSurvivedDeath.sol
2425 
2426 
2427 pragma solidity ^0.8.15;
2428 
2429 
2430 
2431 
2432 
2433 contract WeAllSurvivedDeath is
2434     AccessControl,
2435     ERC721Burnable,
2436     ERC721Tradable,
2437     IERC721Enumerable
2438 {
2439     using Strings for uint256;
2440     using Counters for Counters.Counter;
2441 
2442     struct TokenInfo {
2443         uint256 tokenId;
2444         string tokenURI;
2445     }
2446 
2447     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2448 
2449     Counters.Counter private _currentId;
2450     string private _baseTokenURI;
2451 
2452     // Array with all token ids, used for enumeration
2453     uint256[] private _allTokens;
2454 
2455     // Mapping from an owner address and the token index to the token ID
2456     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
2457 
2458     // Mapping from token ID to index of the owner tokens list
2459     mapping(uint256 => uint256) private _ownedTokensIndex;
2460 
2461     // Mapping from token ID to position in the allTokens array
2462     mapping(uint256 => uint256) private _allTokensIndex;
2463 
2464     constructor(
2465         string memory name_,
2466         string memory symbol_,
2467         string memory baseTokenURI_,
2468         address proxyRegistryAddress
2469     ) ERC721Tradable(name_, symbol_, proxyRegistryAddress) {
2470         _baseTokenURI = baseTokenURI_;
2471         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2472         _currentId.increment();
2473     }
2474 
2475     function isApprovedForAll(address owner, address operator)
2476         public
2477         view
2478         override(IERC721, ERC721, ERC721Tradable)
2479         returns (bool)
2480     {
2481         return ERC721Tradable.isApprovedForAll(owner, operator);
2482     }
2483 
2484     function baseTokenURI() public view override returns (string memory) {
2485         return _baseTokenURI;
2486     }
2487 
2488     function tokenURI(uint256 tokenId)
2489         public
2490         view
2491         override(ERC721, ERC721Tradable)
2492         returns (string memory)
2493     {
2494         require(_exists(tokenId), "WeAllSurvivedDeath: token does not exist");
2495         return
2496             string(
2497                 abi.encodePacked(
2498                     _baseTokenURI,
2499                     Strings.toString(tokenId),
2500                     ".json"
2501                 )
2502             );
2503     }
2504 
2505     function tokenOfOwnerByIndex(address owner, uint256 index)
2506         public
2507         view
2508         virtual
2509         returns (uint256)
2510     {
2511         require(
2512             index < ERC721.balanceOf(owner),
2513             "WeAllSurvivedDeath: owner index out of bounds"
2514         );
2515         return _ownedTokens[owner][index];
2516     }
2517 
2518     function totalSupply()
2519         public
2520         view
2521         virtual
2522         override(ERC721Tradable, IERC721Enumerable)
2523         returns (uint256)
2524     {
2525         return _allTokens.length;
2526     }
2527 
2528     function tokenByIndex(uint256 index) public view virtual returns (uint256) {
2529         require(
2530             index < totalSupply(),
2531             "WeAllSurvivedDeath: global index out of bounds"
2532         );
2533         return _allTokens[index];
2534     }
2535 
2536     function getOwnedTokens(
2537         address user,
2538         uint256 fromIndex,
2539         uint256 toIndex
2540     ) external view returns (TokenInfo[] memory) {
2541         if (balanceOf(user) == 0) return new TokenInfo[](0);
2542         uint256 lastIndex = toIndex;
2543         if (lastIndex >= balanceOf(user)) lastIndex = balanceOf(user) - 1;
2544         require(
2545             fromIndex <= lastIndex,
2546             "WeAllSurvivedDeath: invalid query range"
2547         );
2548         uint256 numNFTs = lastIndex - fromIndex + 1;
2549         TokenInfo[] memory ownedTokens = new TokenInfo[](numNFTs);
2550         for (uint256 i = fromIndex; i <= lastIndex; i++) {
2551             uint256 tokenId = tokenOfOwnerByIndex(user, i);
2552             ownedTokens[i - fromIndex] = TokenInfo(tokenId, tokenURI(tokenId));
2553         }
2554         return ownedTokens;
2555     }
2556 
2557     function setBaseTokenURI(string memory baseTokenURI_) external {
2558         require(
2559             hasRole(DEFAULT_ADMIN_ROLE, msg.sender),
2560             "WeAllSurvivedDeath: caller is not admin"
2561         );
2562         _baseTokenURI = baseTokenURI_;
2563     }
2564 
2565     function mintTo(address to) public override {
2566         require(
2567             hasRole(MINTER_ROLE, _msgSender()),
2568             "WeAllSurvivedDeath: must have minter role to mint"
2569         );
2570         uint256 currentTokenId = _currentId.current();
2571         _currentId.increment();
2572         _safeMint(to, currentTokenId);
2573     }
2574 
2575     function supportsInterface(bytes4 interfaceId)
2576         public
2577         view
2578         virtual
2579         override(AccessControl, ERC721, IERC165)
2580         returns (bool)
2581     {
2582         return
2583             interfaceId == type(IERC721Enumerable).interfaceId ||
2584             AccessControl.supportsInterface(interfaceId) ||
2585             ERC721.supportsInterface(interfaceId);
2586     }
2587 
2588     function _beforeTokenTransfer(
2589         address from,
2590         address to,
2591         uint256 tokenId
2592     ) internal virtual override(ERC721) {
2593         super._beforeTokenTransfer(from, to, tokenId);
2594         if (from == address(0)) _addTokenToAllTokensEnumeration(tokenId);
2595         else if (from != to) _removeTokenFromOwnerEnumeration(from, tokenId);
2596         if (to == address(0)) _removeTokenFromAllTokensEnumeration(tokenId);
2597         else if (to != from) _addTokenToOwnerEnumeration(to, tokenId);
2598     }
2599 
2600     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
2601         uint256 length = ERC721.balanceOf(to);
2602         _ownedTokens[to][length] = tokenId;
2603         _ownedTokensIndex[tokenId] = length;
2604     }
2605 
2606     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
2607         _allTokensIndex[tokenId] = _allTokens.length;
2608         _allTokens.push(tokenId);
2609     }
2610 
2611     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId)
2612         private
2613     {
2614         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
2615         // then delete the last slot (swap and pop).
2616 
2617         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
2618         uint256 tokenIndex = _ownedTokensIndex[tokenId];
2619 
2620         // When the token to delete is the last token, the swap operation is unnecessary
2621         if (tokenIndex != lastTokenIndex) {
2622             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
2623 
2624             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2625             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2626         }
2627 
2628         // This also deletes the contents at the last position of the array
2629         delete _ownedTokensIndex[tokenId];
2630         delete _ownedTokens[from][lastTokenIndex];
2631     }
2632 
2633     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
2634         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
2635         // then delete the last slot (swap and pop).
2636 
2637         uint256 lastTokenIndex = _allTokens.length - 1;
2638         uint256 tokenIndex = _allTokensIndex[tokenId];
2639 
2640         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
2641         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
2642         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
2643         uint256 lastTokenId = _allTokens[lastTokenIndex];
2644 
2645         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
2646         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
2647 
2648         // This also deletes the contents at the last position of the array
2649         delete _allTokensIndex[tokenId];
2650         _allTokens.pop();
2651     }
2652 
2653     function _msgSender()
2654         internal
2655         view
2656         override(Context, ERC721Tradable)
2657         returns (address)
2658     {
2659         return ERC721Tradable._msgSender();
2660     }
2661 }
2662 
2663 
2664 // File contracts/WASDMinting.sol
2665 
2666 
2667 pragma solidity ^0.8.15;
2668 
2669 
2670 
2671 
2672 contract WASDMinting is Ownable, Pausable {
2673     using ECDSA for bytes32;
2674 
2675     struct MintingRole {
2676         uint256 roleId;
2677         string roleName;
2678         uint256 mintLimit; // the maximum number of times each participant of this role can mint
2679     }
2680 
2681     struct PhaseInfo {
2682         string metadata; // the general information of this phase
2683         uint256 duration; // the duration of this phase in seconds
2684         uint256 mintLimit; // the maximum number of times each participant can mint at this phase
2685     }
2686 
2687     struct ParticipantInfo {
2688         uint256 roleId;
2689         uint256 mintCount;
2690     }
2691 
2692     WeAllSurvivedDeath public WASD;
2693     uint256 public wasdLimit;
2694     uint256 public totalMintCount;
2695     uint256 public startingTime;
2696     uint256 private _deployedTime;
2697     PhaseInfo[] private _phaseInfos;
2698     MintingRole[] private _mintingRoles;
2699     mapping(uint256 => mapping(uint256 => bool)) private _rolePermission; // (phase ID + role ID) => permission
2700     mapping(address => ParticipantInfo) private _participantInfos;
2701     mapping(uint256 => uint256[]) private _allowedInPhases; // role ID => [phase IDs]
2702     mapping(uint256 => uint256) private _availableSlotsForRole; // the maximum number of participants who can have this role
2703     mapping(address => bool) private _operators;
2704 
2705     event MintingRoleCreated(
2706         uint256 roleId,
2707         string roleName,
2708         uint256 mintLimit
2709     );
2710 
2711     constructor(
2712         address wasdNFT,
2713         uint256 wasdLimit_,
2714         uint256 startingTime_,
2715         string[] memory metadatas,
2716         uint256[] memory durations,
2717         uint256[] memory mintLimits
2718     ) Ownable() {
2719         _operators[msg.sender] = true;
2720         WASD = WeAllSurvivedDeath(wasdNFT);
2721         wasdLimit = wasdLimit_;
2722         startingTime = startingTime_;
2723         _deployedTime = block.timestamp;
2724         _availableSlotsForRole[0] = type(uint256).max;
2725         _mintingRoles.push(MintingRole(0, "Community", 1));
2726         require(
2727             metadatas.length == durations.length,
2728             "WASDMinting: lengths mismatch"
2729         );
2730         require(
2731             metadatas.length == mintLimits.length,
2732             "WASDMinting: lengths mismatch"
2733         );
2734         _phaseInfos.push(PhaseInfo("", startingTime_ - block.timestamp, 0));
2735         for (uint256 i = 0; i < metadatas.length; i++) {
2736             require(durations[i] >= 5 minutes, "WASDMinting: phase too short");
2737             require(
2738                 mintLimits[i] > 0,
2739                 "WASDMinting: mint limit must be greater than zero"
2740             );
2741             _phaseInfos.push(
2742                 PhaseInfo(metadatas[i], durations[i], mintLimits[i])
2743             );
2744         }
2745     }
2746 
2747     modifier onlyOperators() {
2748         require(_operators[msg.sender], "WASDMinting: caller is not operator");
2749         _;
2750     }
2751 
2752     function getPhaseInfo() external view returns (PhaseInfo[] memory) {
2753         uint256 numPhases = _phaseInfos.length - 1;
2754         PhaseInfo[] memory phases = new PhaseInfo[](numPhases);
2755         for (uint256 i = 0; i < numPhases; i++) phases[i] = _phaseInfos[i + 1];
2756         return phases;
2757     }
2758 
2759     function getCurrentPhase() public view returns (uint256) {
2760         uint256 elapsedTime = block.timestamp - _deployedTime;
2761         for (uint256 phase = 0; phase < _phaseInfos.length; phase++)
2762             if (elapsedTime >= _phaseInfos[phase].duration)
2763                 elapsedTime -= _phaseInfos[phase].duration;
2764             else return phase;
2765         return _phaseInfos.length;
2766     }
2767 
2768     function getRoles() external view returns (MintingRole[] memory) {
2769         return _mintingRoles;
2770     }
2771 
2772     function getParticipantInfo(address participant)
2773         public
2774         view
2775         returns (
2776             uint256 roleId,
2777             string memory roleName,
2778             uint256 mintLimit,
2779             uint256 mintCount,
2780             uint256 availableMintCount,
2781             uint256[] memory allowedInPhases
2782         )
2783     {
2784         require(
2785             getCurrentPhase() < _phaseInfos.length,
2786             "WASDMinting: minting time is over"
2787         );
2788         roleId = _participantInfos[participant].roleId;
2789         roleName = _mintingRoles[roleId].roleName;
2790         mintLimit = _mintingRoles[roleId].mintLimit;
2791         mintCount = _participantInfos[participant].mintCount;
2792         allowedInPhases = _allowedInPhases[roleId];
2793         if (!_rolePermission[getCurrentPhase()][roleId]) availableMintCount = 0;
2794         else {
2795             require(
2796                 _participantInfos[participant].mintCount <=
2797                     _mintingRoles[roleId].mintLimit,
2798                 "WASDMinting: mint count exceeds limit"
2799             );
2800             availableMintCount =
2801                 _mintingRoles[roleId].mintLimit -
2802                 _participantInfos[participant].mintCount;
2803             if (availableMintCount > _phaseInfos[getCurrentPhase()].mintLimit)
2804                 availableMintCount = _phaseInfos[getCurrentPhase()].mintLimit;
2805         }
2806     }
2807 
2808     function setOperators(address[] memory operators, bool[] memory isOperators)
2809         external
2810         onlyOwner
2811     {
2812         require(
2813             operators.length == isOperators.length,
2814             "WASDMinting: lengths mismatch"
2815         );
2816         for (uint256 i = 0; i < operators.length; i++)
2817             _operators[operators[i]] = isOperators[i];
2818     }
2819 
2820     function createMintingRoles(
2821         string[] memory roleNames,
2822         uint256[] memory mintLimits,
2823         uint256[] memory roleLimits
2824     ) external onlyOperators {
2825         require(
2826             roleNames.length == mintLimits.length,
2827             "WASDMinting: lengths mismatch"
2828         );
2829         require(
2830             roleNames.length == roleLimits.length,
2831             "WASDMinting: lengths mismatch"
2832         );
2833         for (uint256 i = 0; i < roleNames.length; i++) {
2834             require(
2835                 mintLimits[i] > 0,
2836                 "WASDMinting: mint limit must be greater than zero"
2837             );
2838             require(
2839                 roleLimits[i] > 0,
2840                 "WASDMinting: role limit must be greater than zero"
2841             );
2842             uint256 roleId = _mintingRoles.length;
2843             _availableSlotsForRole[roleId] = roleLimits[i];
2844             _mintingRoles.push(
2845                 MintingRole(roleId, roleNames[i], mintLimits[i])
2846             );
2847             emit MintingRoleCreated(roleId, roleNames[i], mintLimits[i]);
2848         }
2849     }
2850 
2851     function addRolesToPhases(
2852         uint256[] memory phaseIds,
2853         uint256[][] memory roleIds
2854     ) external onlyOperators {
2855         require(
2856             phaseIds.length == roleIds.length,
2857             "WASDMinting: lengths mismatch"
2858         );
2859         for (uint256 i = 0; i < phaseIds.length; i++) {
2860             require(
2861                 phaseIds[i] < _phaseInfos.length,
2862                 "WASDMinting: invalid phase ID"
2863             );
2864             for (uint256 j = 0; j < roleIds[i].length; j++) {
2865                 require(
2866                     roleIds[i][j] < _mintingRoles.length,
2867                     "WASDMinting: invalid role ID"
2868                 );
2869                 _rolePermission[phaseIds[i]][roleIds[i][j]] = true;
2870                 _allowedInPhases[roleIds[i][j]].push(phaseIds[i]);
2871             }
2872         }
2873     }
2874 
2875     function mintWASD(
2876         uint256 roleId,
2877         bytes calldata signature,
2878         uint256 quantity
2879     ) external whenNotPaused {
2880         // Validate basic information
2881         require(
2882             getCurrentPhase() < _phaseInfos.length,
2883             "WASDMinting: minting time is over"
2884         );
2885         require(
2886             _participantInfos[msg.sender].roleId == 0,
2887             "WASDMinting: participant already granted minting role"
2888         );
2889         require(
2890             _participantInfos[msg.sender].mintCount == 0,
2891             "WASDMinting: not the first mint"
2892         );
2893         require(roleId < _mintingRoles.length, "WASDMinting: invalid role ID");
2894         require(
2895             _availableSlotsForRole[roleId] > 0,
2896             "WASDMinting: role limit reached"
2897         );
2898 
2899         // Validate operator's signature
2900         bytes32 hash = keccak256(abi.encodePacked(msg.sender, roleId));
2901         bytes32 messageHash = hash.toEthSignedMessageHash();
2902         address signer = messageHash.recover(signature);
2903         require(_operators[signer], "WASDMinting: invalid signer");
2904 
2905         // Validate mint count
2906         require(
2907             totalMintCount + quantity <= wasdLimit,
2908             "WASDMinting: total mint limit reached"
2909         );
2910         uint256 availableMintCount = 0;
2911         if (_rolePermission[getCurrentPhase()][roleId]) {
2912             availableMintCount = _mintingRoles[roleId].mintLimit;
2913             if (availableMintCount > _phaseInfos[getCurrentPhase()].mintLimit)
2914                 availableMintCount = _phaseInfos[getCurrentPhase()].mintLimit;
2915         }
2916         require(
2917             quantity <= availableMintCount,
2918             "WASDMinting: personal mint limit at this phase reached"
2919         );
2920 
2921         // Grant role and mint WASDs
2922         _availableSlotsForRole[roleId]--;
2923         _participantInfos[msg.sender].roleId = roleId;
2924         _participantInfos[msg.sender].mintCount = quantity;
2925         totalMintCount += quantity;
2926         for (uint256 i = 0; i < quantity; i++) WASD.mintTo(msg.sender);
2927     }
2928 
2929     function mintWASD(uint256 quantity) external whenNotPaused {
2930         require(
2931             _participantInfos[msg.sender].mintCount > 0,
2932             "WASDMinting: first mint - undetected role"
2933         );
2934         (, , , , uint256 availableMintCount, ) = getParticipantInfo(msg.sender);
2935         require(
2936             quantity <= availableMintCount,
2937             "WASDMinting: personal mint limit at this phase reached"
2938         );
2939         require(
2940             totalMintCount + quantity <= wasdLimit,
2941             "WASDMinting: total mint limit reached"
2942         );
2943         _participantInfos[msg.sender].mintCount += quantity;
2944         totalMintCount += quantity;
2945         for (uint256 i = 0; i < quantity; i++) WASD.mintTo(msg.sender);
2946     }
2947 
2948     function pause() external onlyOwner {
2949         _pause();
2950     }
2951 
2952     function unpause() external onlyOwner {
2953         _unpause();
2954     }
2955 }