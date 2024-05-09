1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.3.3
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev External interface of AccessControl declared to support ERC165 detection.
11  */
12 interface IAccessControl {
13     /**
14      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
15      *
16      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
17      * {RoleAdminChanged} not being emitted signaling this.
18      *
19      * _Available since v3.1._
20      */
21     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
22 
23     /**
24      * @dev Emitted when `account` is granted `role`.
25      *
26      * `sender` is the account that originated the contract call, an admin role
27      * bearer except when using {AccessControl-_setupRole}.
28      */
29     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
30 
31     /**
32      * @dev Emitted when `account` is revoked `role`.
33      *
34      * `sender` is the account that originated the contract call:
35      *   - if using `revokeRole`, it is the admin role bearer
36      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
37      */
38     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
39 
40     /**
41      * @dev Returns `true` if `account` has been granted `role`.
42      */
43     function hasRole(bytes32 role, address account) external view returns (bool);
44 
45     /**
46      * @dev Returns the admin role that controls `role`. See {grantRole} and
47      * {revokeRole}.
48      *
49      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
50      */
51     function getRoleAdmin(bytes32 role) external view returns (bytes32);
52 
53     /**
54      * @dev Grants `role` to `account`.
55      *
56      * If `account` had not been already granted `role`, emits a {RoleGranted}
57      * event.
58      *
59      * Requirements:
60      *
61      * - the caller must have ``role``'s admin role.
62      */
63     function grantRole(bytes32 role, address account) external;
64 
65     /**
66      * @dev Revokes `role` from `account`.
67      *
68      * If `account` had been granted `role`, emits a {RoleRevoked} event.
69      *
70      * Requirements:
71      *
72      * - the caller must have ``role``'s admin role.
73      */
74     function revokeRole(bytes32 role, address account) external;
75 
76     /**
77      * @dev Revokes `role` from the calling account.
78      *
79      * Roles are often managed via {grantRole} and {revokeRole}: this function's
80      * purpose is to provide a mechanism for accounts to lose their privileges
81      * if they are compromised (such as when a trusted device is misplaced).
82      *
83      * If the calling account had been granted `role`, emits a {RoleRevoked}
84      * event.
85      *
86      * Requirements:
87      *
88      * - the caller must be `account`.
89      */
90     function renounceRole(bytes32 role, address account) external;
91 }
92 
93 
94 // File @openzeppelin/contracts/utils/Context.sol@v4.3.3
95 
96 pragma solidity ^0.8.0;
97 
98 /**
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 abstract contract Context {
109     function _msgSender() internal view virtual returns (address) {
110         return msg.sender;
111     }
112 
113     function _msgData() internal view virtual returns (bytes calldata) {
114         return msg.data;
115     }
116 }
117 
118 
119 // File @openzeppelin/contracts/utils/Strings.sol@v4.3.3
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @dev String operations.
125  */
126 library Strings {
127     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
128 
129     /**
130      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
131      */
132     function toString(uint256 value) internal pure returns (string memory) {
133         // Inspired by OraclizeAPI's implementation - MIT licence
134         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
135 
136         if (value == 0) {
137             return "0";
138         }
139         uint256 temp = value;
140         uint256 digits;
141         while (temp != 0) {
142             digits++;
143             temp /= 10;
144         }
145         bytes memory buffer = new bytes(digits);
146         while (value != 0) {
147             digits -= 1;
148             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
149             value /= 10;
150         }
151         return string(buffer);
152     }
153 
154     /**
155      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
156      */
157     function toHexString(uint256 value) internal pure returns (string memory) {
158         if (value == 0) {
159             return "0x00";
160         }
161         uint256 temp = value;
162         uint256 length = 0;
163         while (temp != 0) {
164             length++;
165             temp >>= 8;
166         }
167         return toHexString(value, length);
168     }
169 
170     /**
171      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
172      */
173     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
174         bytes memory buffer = new bytes(2 * length + 2);
175         buffer[0] = "0";
176         buffer[1] = "x";
177         for (uint256 i = 2 * length + 1; i > 1; --i) {
178             buffer[i] = _HEX_SYMBOLS[value & 0xf];
179             value >>= 4;
180         }
181         require(value == 0, "Strings: hex length insufficient");
182         return string(buffer);
183     }
184 }
185 
186 
187 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.3.3
188 
189 pragma solidity ^0.8.0;
190 
191 /**
192  * @dev Interface of the ERC165 standard, as defined in the
193  * https://eips.ethereum.org/EIPS/eip-165[EIP].
194  *
195  * Implementers can declare support of contract interfaces, which can then be
196  * queried by others ({ERC165Checker}).
197  *
198  * For an implementation, see {ERC165}.
199  */
200 interface IERC165 {
201     /**
202      * @dev Returns true if this contract implements the interface defined by
203      * `interfaceId`. See the corresponding
204      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
205      * to learn more about how these ids are created.
206      *
207      * This function call must use less than 30 000 gas.
208      */
209     function supportsInterface(bytes4 interfaceId) external view returns (bool);
210 }
211 
212 
213 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.3.3
214 
215 pragma solidity ^0.8.0;
216 
217 /**
218  * @dev Implementation of the {IERC165} interface.
219  *
220  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
221  * for the additional interface id that will be supported. For example:
222  *
223  * ```solidity
224  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
225  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
226  * }
227  * ```
228  *
229  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
230  */
231 abstract contract ERC165 is IERC165 {
232     /**
233      * @dev See {IERC165-supportsInterface}.
234      */
235     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
236         return interfaceId == type(IERC165).interfaceId;
237     }
238 }
239 
240 
241 // File @openzeppelin/contracts/access/AccessControl.sol@v4.3.3
242 
243 pragma solidity ^0.8.0;
244 
245 
246 
247 
248 /**
249  * @dev Contract module that allows children to implement role-based access
250  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
251  * members except through off-chain means by accessing the contract event logs. Some
252  * applications may benefit from on-chain enumerability, for those cases see
253  * {AccessControlEnumerable}.
254  *
255  * Roles are referred to by their `bytes32` identifier. These should be exposed
256  * in the external API and be unique. The best way to achieve this is by
257  * using `public constant` hash digests:
258  *
259  * ```
260  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
261  * ```
262  *
263  * Roles can be used to represent a set of permissions. To restrict access to a
264  * function call, use {hasRole}:
265  *
266  * ```
267  * function foo() public {
268  *     require(hasRole(MY_ROLE, msg.sender));
269  *     ...
270  * }
271  * ```
272  *
273  * Roles can be granted and revoked dynamically via the {grantRole} and
274  * {revokeRole} functions. Each role has an associated admin role, and only
275  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
276  *
277  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
278  * that only accounts with this role will be able to grant or revoke other
279  * roles. More complex role relationships can be created by using
280  * {_setRoleAdmin}.
281  *
282  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
283  * grant and revoke this role. Extra precautions should be taken to secure
284  * accounts that have been granted it.
285  */
286 abstract contract AccessControl is Context, IAccessControl, ERC165 {
287     struct RoleData {
288         mapping(address => bool) members;
289         bytes32 adminRole;
290     }
291 
292     mapping(bytes32 => RoleData) private _roles;
293 
294     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
295 
296     /**
297      * @dev Modifier that checks that an account has a specific role. Reverts
298      * with a standardized message including the required role.
299      *
300      * The format of the revert reason is given by the following regular expression:
301      *
302      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
303      *
304      * _Available since v4.1._
305      */
306     modifier onlyRole(bytes32 role) {
307         _checkRole(role, _msgSender());
308         _;
309     }
310 
311     /**
312      * @dev See {IERC165-supportsInterface}.
313      */
314     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
315         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
316     }
317 
318     /**
319      * @dev Returns `true` if `account` has been granted `role`.
320      */
321     function hasRole(bytes32 role, address account) public view override returns (bool) {
322         return _roles[role].members[account];
323     }
324 
325     /**
326      * @dev Revert with a standard message if `account` is missing `role`.
327      *
328      * The format of the revert reason is given by the following regular expression:
329      *
330      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
331      */
332     function _checkRole(bytes32 role, address account) internal view {
333         if (!hasRole(role, account)) {
334             revert(
335                 string(
336                     abi.encodePacked(
337                         "AccessControl: account ",
338                         Strings.toHexString(uint160(account), 20),
339                         " is missing role ",
340                         Strings.toHexString(uint256(role), 32)
341                     )
342                 )
343             );
344         }
345     }
346 
347     /**
348      * @dev Returns the admin role that controls `role`. See {grantRole} and
349      * {revokeRole}.
350      *
351      * To change a role's admin, use {_setRoleAdmin}.
352      */
353     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
354         return _roles[role].adminRole;
355     }
356 
357     /**
358      * @dev Grants `role` to `account`.
359      *
360      * If `account` had not been already granted `role`, emits a {RoleGranted}
361      * event.
362      *
363      * Requirements:
364      *
365      * - the caller must have ``role``'s admin role.
366      */
367     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
368         _grantRole(role, account);
369     }
370 
371     /**
372      * @dev Revokes `role` from `account`.
373      *
374      * If `account` had been granted `role`, emits a {RoleRevoked} event.
375      *
376      * Requirements:
377      *
378      * - the caller must have ``role``'s admin role.
379      */
380     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
381         _revokeRole(role, account);
382     }
383 
384     /**
385      * @dev Revokes `role` from the calling account.
386      *
387      * Roles are often managed via {grantRole} and {revokeRole}: this function's
388      * purpose is to provide a mechanism for accounts to lose their privileges
389      * if they are compromised (such as when a trusted device is misplaced).
390      *
391      * If the calling account had been granted `role`, emits a {RoleRevoked}
392      * event.
393      *
394      * Requirements:
395      *
396      * - the caller must be `account`.
397      */
398     function renounceRole(bytes32 role, address account) public virtual override {
399         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
400 
401         _revokeRole(role, account);
402     }
403 
404     /**
405      * @dev Grants `role` to `account`.
406      *
407      * If `account` had not been already granted `role`, emits a {RoleGranted}
408      * event. Note that unlike {grantRole}, this function doesn't perform any
409      * checks on the calling account.
410      *
411      * [WARNING]
412      * ====
413      * This function should only be called from the constructor when setting
414      * up the initial roles for the system.
415      *
416      * Using this function in any other way is effectively circumventing the admin
417      * system imposed by {AccessControl}.
418      * ====
419      */
420     function _setupRole(bytes32 role, address account) internal virtual {
421         _grantRole(role, account);
422     }
423 
424     /**
425      * @dev Sets `adminRole` as ``role``'s admin role.
426      *
427      * Emits a {RoleAdminChanged} event.
428      */
429     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
430         bytes32 previousAdminRole = getRoleAdmin(role);
431         _roles[role].adminRole = adminRole;
432         emit RoleAdminChanged(role, previousAdminRole, adminRole);
433     }
434 
435     function _grantRole(bytes32 role, address account) private {
436         if (!hasRole(role, account)) {
437             _roles[role].members[account] = true;
438             emit RoleGranted(role, account, _msgSender());
439         }
440     }
441 
442     function _revokeRole(bytes32 role, address account) private {
443         if (hasRole(role, account)) {
444             _roles[role].members[account] = false;
445             emit RoleRevoked(role, account, _msgSender());
446         }
447     }
448 }
449 
450 
451 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.3.3
452 
453 pragma solidity ^0.8.0;
454 
455 /**
456  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
457  *
458  * These functions can be used to verify that a message was signed by the holder
459  * of the private keys of a given address.
460  */
461 library ECDSA {
462     enum RecoverError {
463         NoError,
464         InvalidSignature,
465         InvalidSignatureLength,
466         InvalidSignatureS,
467         InvalidSignatureV
468     }
469 
470     function _throwError(RecoverError error) private pure {
471         if (error == RecoverError.NoError) {
472             return; // no error: do nothing
473         } else if (error == RecoverError.InvalidSignature) {
474             revert("ECDSA: invalid signature");
475         } else if (error == RecoverError.InvalidSignatureLength) {
476             revert("ECDSA: invalid signature length");
477         } else if (error == RecoverError.InvalidSignatureS) {
478             revert("ECDSA: invalid signature 's' value");
479         } else if (error == RecoverError.InvalidSignatureV) {
480             revert("ECDSA: invalid signature 'v' value");
481         }
482     }
483 
484     /**
485      * @dev Returns the address that signed a hashed message (`hash`) with
486      * `signature` or error string. This address can then be used for verification purposes.
487      *
488      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
489      * this function rejects them by requiring the `s` value to be in the lower
490      * half order, and the `v` value to be either 27 or 28.
491      *
492      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
493      * verification to be secure: it is possible to craft signatures that
494      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
495      * this is by receiving a hash of the original message (which may otherwise
496      * be too long), and then calling {toEthSignedMessageHash} on it.
497      *
498      * Documentation for signature generation:
499      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
500      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
501      *
502      * _Available since v4.3._
503      */
504     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
505         // Check the signature length
506         // - case 65: r,s,v signature (standard)
507         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
508         if (signature.length == 65) {
509             bytes32 r;
510             bytes32 s;
511             uint8 v;
512             // ecrecover takes the signature parameters, and the only way to get them
513             // currently is to use assembly.
514             assembly {
515                 r := mload(add(signature, 0x20))
516                 s := mload(add(signature, 0x40))
517                 v := byte(0, mload(add(signature, 0x60)))
518             }
519             return tryRecover(hash, v, r, s);
520         } else if (signature.length == 64) {
521             bytes32 r;
522             bytes32 vs;
523             // ecrecover takes the signature parameters, and the only way to get them
524             // currently is to use assembly.
525             assembly {
526                 r := mload(add(signature, 0x20))
527                 vs := mload(add(signature, 0x40))
528             }
529             return tryRecover(hash, r, vs);
530         } else {
531             return (address(0), RecoverError.InvalidSignatureLength);
532         }
533     }
534 
535     /**
536      * @dev Returns the address that signed a hashed message (`hash`) with
537      * `signature`. This address can then be used for verification purposes.
538      *
539      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
540      * this function rejects them by requiring the `s` value to be in the lower
541      * half order, and the `v` value to be either 27 or 28.
542      *
543      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
544      * verification to be secure: it is possible to craft signatures that
545      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
546      * this is by receiving a hash of the original message (which may otherwise
547      * be too long), and then calling {toEthSignedMessageHash} on it.
548      */
549     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
550         (address recovered, RecoverError error) = tryRecover(hash, signature);
551         _throwError(error);
552         return recovered;
553     }
554 
555     /**
556      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
557      *
558      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
559      *
560      * _Available since v4.3._
561      */
562     function tryRecover(
563         bytes32 hash,
564         bytes32 r,
565         bytes32 vs
566     ) internal pure returns (address, RecoverError) {
567         bytes32 s;
568         uint8 v;
569         assembly {
570             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
571             v := add(shr(255, vs), 27)
572         }
573         return tryRecover(hash, v, r, s);
574     }
575 
576     /**
577      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
578      *
579      * _Available since v4.2._
580      */
581     function recover(
582         bytes32 hash,
583         bytes32 r,
584         bytes32 vs
585     ) internal pure returns (address) {
586         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
587         _throwError(error);
588         return recovered;
589     }
590 
591     /**
592      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
593      * `r` and `s` signature fields separately.
594      *
595      * _Available since v4.3._
596      */
597     function tryRecover(
598         bytes32 hash,
599         uint8 v,
600         bytes32 r,
601         bytes32 s
602     ) internal pure returns (address, RecoverError) {
603         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
604         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
605         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
606         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
607         //
608         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
609         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
610         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
611         // these malleable signatures as well.
612         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
613             return (address(0), RecoverError.InvalidSignatureS);
614         }
615         if (v != 27 && v != 28) {
616             return (address(0), RecoverError.InvalidSignatureV);
617         }
618 
619         // If the signature is valid (and not malleable), return the signer address
620         address signer = ecrecover(hash, v, r, s);
621         if (signer == address(0)) {
622             return (address(0), RecoverError.InvalidSignature);
623         }
624 
625         return (signer, RecoverError.NoError);
626     }
627 
628     /**
629      * @dev Overload of {ECDSA-recover} that receives the `v`,
630      * `r` and `s` signature fields separately.
631      */
632     function recover(
633         bytes32 hash,
634         uint8 v,
635         bytes32 r,
636         bytes32 s
637     ) internal pure returns (address) {
638         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
639         _throwError(error);
640         return recovered;
641     }
642 
643     /**
644      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
645      * produces hash corresponding to the one signed with the
646      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
647      * JSON-RPC method as part of EIP-191.
648      *
649      * See {recover}.
650      */
651     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
652         // 32 is the length in bytes of hash,
653         // enforced by the type signature above
654         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
655     }
656 
657     /**
658      * @dev Returns an Ethereum Signed Typed Data, created from a
659      * `domainSeparator` and a `structHash`. This produces hash corresponding
660      * to the one signed with the
661      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
662      * JSON-RPC method as part of EIP-712.
663      *
664      * See {recover}.
665      */
666     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
667         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
668     }
669 }
670 
671 
672 // File contracts/purchasing.sol
673 pragma solidity ^0.8.0;
674 
675 
676 contract Purchasing is AccessControl {
677   bytes32 public constant SIGNER_ROLE = keccak256("SIGNER_ROLE");
678   mapping (uint256 => address) packOwners;
679 
680   constructor() {
681     _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
682     _setupRole(SIGNER_ROLE, _msgSender());
683   }
684 
685   event PaymentSuccess(address account, uint256[] packIds, uint256 amountPaid);
686 
687   function purchasePacks(uint256[] calldata packIds, uint blockNum, uint256 amount, address account, bytes calldata signature) external payable {
688         require(block.number <= blockNum, "Signature expired");
689         require(_verify(_hash(packIds, blockNum, amount, account), signature), "Invalid signature");
690         require(msg.value == amount, "Incorrect ether sent");
691 
692         // Store addresses of pack purchaser to prevent re-purchase with same signature
693         for (uint i=0; i<packIds.length; i++){
694           require(packOwners[packIds[i]] == address(0x0) , "Pack has been purchased!");
695           packOwners[packIds[i]] = account;
696         }
697 
698         emit PaymentSuccess(account, packIds, msg.value);
699   }
700 
701   // Check/Withdraw contract balance functions
702   function getBalance() external view onlyRole(DEFAULT_ADMIN_ROLE) returns (uint256) {
703       return address(this).balance;
704   }
705 
706   function withdraw() external onlyRole(DEFAULT_ADMIN_ROLE) {
707     payable(msg.sender).transfer(address(this).balance);
708   }
709 
710   // Signature and reservation functions
711   function _hash(uint256[] calldata packIds, uint blockNum, uint256 amount, address account)
712     public pure returns (bytes32)
713     {
714         return ECDSA.toEthSignedMessageHash(keccak256(abi.encodePacked(packIds, blockNum, amount, account)));
715   }
716 
717   function _verify(bytes32 digest, bytes calldata signature)
718     internal view returns (bool)
719     {
720         // Ensures that the resulting address recovered has a SIGNER_ROLE function
721         return hasRole(SIGNER_ROLE, ECDSA.recover(digest, signature));
722   }
723 
724 }