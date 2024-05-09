1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC165 standard, as defined in the
9  * https://eips.ethereum.org/EIPS/eip-165[EIP].
10  *
11  * Implementers can declare support of contract interfaces, which can then be
12  * queried by others ({ERC165Checker}).
13  *
14  * For an implementation, see {ERC165}.
15  */
16 interface IERC165 {
17   /**
18    * @dev Returns true if this contract implements the interface defined by
19    * `interfaceId`. See the corresponding
20    * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
21    * to learn more about how these ids are created.
22    *
23    * This function call must use less than 30 000 gas.
24    */
25   function supportsInterface(bytes4 interfaceId) external view returns (bool);
26 }
27 
28 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
29 
30 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Implementation of the {IERC165} interface.
36  *
37  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
38  * for the additional interface id that will be supported. For example:
39  *
40  * ```solidity
41  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
42  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
43  * }
44  * ```
45  *
46  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
47  */
48 abstract contract ERC165 is IERC165 {
49   /**
50    * @dev See {IERC165-supportsInterface}.
51    */
52   function supportsInterface(bytes4 interfaceId)
53     public
54     view
55     virtual
56     override
57     returns (bool)
58   {
59     return interfaceId == type(IERC165).interfaceId;
60   }
61 }
62 
63 // File: @openzeppelin/contracts/utils/Strings.sol
64 
65 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
66 
67 pragma solidity ^0.8.0;
68 
69 /**
70  * @dev String operations.
71  */
72 library Strings {
73   bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
74   uint8 private constant _ADDRESS_LENGTH = 20;
75 
76   /**
77    * @dev Converts a `uint256` to its ASCII `string` decimal representation.
78    */
79   function toString(uint256 value) internal pure returns (string memory) {
80     // Inspired by OraclizeAPI's implementation - MIT licence
81     // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
82 
83     if (value == 0) {
84       return "0";
85     }
86     uint256 temp = value;
87     uint256 digits;
88     while (temp != 0) {
89       digits++;
90       temp /= 10;
91     }
92     bytes memory buffer = new bytes(digits);
93     while (value != 0) {
94       digits -= 1;
95       buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
96       value /= 10;
97     }
98     return string(buffer);
99   }
100 
101   /**
102    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
103    */
104   function toHexString(uint256 value) internal pure returns (string memory) {
105     if (value == 0) {
106       return "0x00";
107     }
108     uint256 temp = value;
109     uint256 length = 0;
110     while (temp != 0) {
111       length++;
112       temp >>= 8;
113     }
114     return toHexString(value, length);
115   }
116 
117   /**
118    * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
119    */
120   function toHexString(uint256 value, uint256 length)
121     internal
122     pure
123     returns (string memory)
124   {
125     bytes memory buffer = new bytes(2 * length + 2);
126     buffer[0] = "0";
127     buffer[1] = "x";
128     for (uint256 i = 2 * length + 1; i > 1; --i) {
129       buffer[i] = _HEX_SYMBOLS[value & 0xf];
130       value >>= 4;
131     }
132     require(value == 0, "Strings: hex length insufficient");
133     return string(buffer);
134   }
135 
136   /**
137    * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
138    */
139   function toHexString(address addr) internal pure returns (string memory) {
140     return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
141   }
142 }
143 
144 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
145 
146 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
147 
148 pragma solidity ^0.8.0;
149 
150 /**
151  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
152  *
153  * These functions can be used to verify that a message was signed by the holder
154  * of the private keys of a given address.
155  */
156 library ECDSA {
157   enum RecoverError {
158     NoError,
159     InvalidSignature,
160     InvalidSignatureLength,
161     InvalidSignatureS,
162     InvalidSignatureV
163   }
164 
165   function _throwError(RecoverError error) private pure {
166     if (error == RecoverError.NoError) {
167       return; // no error: do nothing
168     } else if (error == RecoverError.InvalidSignature) {
169       revert("ECDSA: invalid signature");
170     } else if (error == RecoverError.InvalidSignatureLength) {
171       revert("ECDSA: invalid signature length");
172     } else if (error == RecoverError.InvalidSignatureS) {
173       revert("ECDSA: invalid signature 's' value");
174     } else if (error == RecoverError.InvalidSignatureV) {
175       revert("ECDSA: invalid signature 'v' value");
176     }
177   }
178 
179   /**
180    * @dev Returns the address that signed a hashed message (`hash`) with
181    * `signature` or error string. This address can then be used for verification purposes.
182    *
183    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
184    * this function rejects them by requiring the `s` value to be in the lower
185    * half order, and the `v` value to be either 27 or 28.
186    *
187    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
188    * verification to be secure: it is possible to craft signatures that
189    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
190    * this is by receiving a hash of the original message (which may otherwise
191    * be too long), and then calling {toEthSignedMessageHash} on it.
192    *
193    * Documentation for signature generation:
194    * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
195    * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
196    *
197    * _Available since v4.3._
198    */
199   function tryRecover(bytes32 hash, bytes memory signature)
200     internal
201     pure
202     returns (address, RecoverError)
203   {
204     if (signature.length == 65) {
205       bytes32 r;
206       bytes32 s;
207       uint8 v;
208       // ecrecover takes the signature parameters, and the only way to get them
209       // currently is to use assembly.
210       /// @solidity memory-safe-assembly
211       assembly {
212         r := mload(add(signature, 0x20))
213         s := mload(add(signature, 0x40))
214         v := byte(0, mload(add(signature, 0x60)))
215       }
216       return tryRecover(hash, v, r, s);
217     } else {
218       return (address(0), RecoverError.InvalidSignatureLength);
219     }
220   }
221 
222   /**
223    * @dev Returns the address that signed a hashed message (`hash`) with
224    * `signature`. This address can then be used for verification purposes.
225    *
226    * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
227    * this function rejects them by requiring the `s` value to be in the lower
228    * half order, and the `v` value to be either 27 or 28.
229    *
230    * IMPORTANT: `hash` _must_ be the result of a hash operation for the
231    * verification to be secure: it is possible to craft signatures that
232    * recover to arbitrary addresses for non-hashed data. A safe way to ensure
233    * this is by receiving a hash of the original message (which may otherwise
234    * be too long), and then calling {toEthSignedMessageHash} on it.
235    */
236   function recover(bytes32 hash, bytes memory signature)
237     internal
238     pure
239     returns (address)
240   {
241     (address recovered, RecoverError error) = tryRecover(hash, signature);
242     _throwError(error);
243     return recovered;
244   }
245 
246   /**
247    * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
248    *
249    * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
250    *
251    * _Available since v4.3._
252    */
253   function tryRecover(
254     bytes32 hash,
255     bytes32 r,
256     bytes32 vs
257   ) internal pure returns (address, RecoverError) {
258     bytes32 s = vs &
259       bytes32(
260         0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
261       );
262     uint8 v = uint8((uint256(vs) >> 255) + 27);
263     return tryRecover(hash, v, r, s);
264   }
265 
266   /**
267    * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
268    *
269    * _Available since v4.2._
270    */
271   function recover(
272     bytes32 hash,
273     bytes32 r,
274     bytes32 vs
275   ) internal pure returns (address) {
276     (address recovered, RecoverError error) = tryRecover(hash, r, vs);
277     _throwError(error);
278     return recovered;
279   }
280 
281   /**
282    * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
283    * `r` and `s` signature fields separately.
284    *
285    * _Available since v4.3._
286    */
287   function tryRecover(
288     bytes32 hash,
289     uint8 v,
290     bytes32 r,
291     bytes32 s
292   ) internal pure returns (address, RecoverError) {
293     // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
294     // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
295     // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
296     // signatures from current libraries generate a unique signature with an s-value in the lower half order.
297     //
298     // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
299     // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
300     // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
301     // these malleable signatures as well.
302     if (
303       uint256(s) >
304       0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0
305     ) {
306       return (address(0), RecoverError.InvalidSignatureS);
307     }
308     if (v != 27 && v != 28) {
309       return (address(0), RecoverError.InvalidSignatureV);
310     }
311 
312     // If the signature is valid (and not malleable), return the signer address
313     address signer = ecrecover(hash, v, r, s);
314     if (signer == address(0)) {
315       return (address(0), RecoverError.InvalidSignature);
316     }
317 
318     return (signer, RecoverError.NoError);
319   }
320 
321   /**
322    * @dev Overload of {ECDSA-recover} that receives the `v`,
323    * `r` and `s` signature fields separately.
324    */
325   function recover(
326     bytes32 hash,
327     uint8 v,
328     bytes32 r,
329     bytes32 s
330   ) internal pure returns (address) {
331     (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
332     _throwError(error);
333     return recovered;
334   }
335 
336   /**
337    * @dev Returns an Ethereum Signed Message, created from a `hash`. This
338    * produces hash corresponding to the one signed with the
339    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
340    * JSON-RPC method as part of EIP-191.
341    *
342    * See {recover}.
343    */
344   function toEthSignedMessageHash(bytes32 hash)
345     internal
346     pure
347     returns (bytes32)
348   {
349     // 32 is the length in bytes of hash,
350     // enforced by the type signature above
351     return
352       keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
353   }
354 
355   /**
356    * @dev Returns an Ethereum Signed Message, created from `s`. This
357    * produces hash corresponding to the one signed with the
358    * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
359    * JSON-RPC method as part of EIP-191.
360    *
361    * See {recover}.
362    */
363   function toEthSignedMessageHash(bytes memory s)
364     internal
365     pure
366     returns (bytes32)
367   {
368     return
369       keccak256(
370         abi.encodePacked(
371           "\x19Ethereum Signed Message:\n",
372           Strings.toString(s.length),
373           s
374         )
375       );
376   }
377 
378   /**
379    * @dev Returns an Ethereum Signed Typed Data, created from a
380    * `domainSeparator` and a `structHash`. This produces hash corresponding
381    * to the one signed with the
382    * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
383    * JSON-RPC method as part of EIP-712.
384    *
385    * See {recover}.
386    */
387   function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash)
388     internal
389     pure
390     returns (bytes32)
391   {
392     return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
393   }
394 }
395 
396 // File: @openzeppelin/contracts/utils/Context.sol
397 
398 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 /**
403  * @dev Provides information about the current execution context, including the
404  * sender of the transaction and its data. While these are generally available
405  * via msg.sender and msg.data, they should not be accessed in such a direct
406  * manner, since when dealing with meta-transactions the account sending and
407  * paying for execution may not be the actual sender (as far as an application
408  * is concerned).
409  *
410  * This contract is only required for intermediate, library-like contracts.
411  */
412 abstract contract Context {
413   function _msgSender() internal view virtual returns (address) {
414     return msg.sender;
415   }
416 
417   function _msgData() internal view virtual returns (bytes calldata) {
418     return msg.data;
419   }
420 }
421 
422 // File: @openzeppelin/contracts/access/IAccessControl.sol
423 
424 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
425 
426 pragma solidity ^0.8.0;
427 
428 /**
429  * @dev External interface of AccessControl declared to support ERC165 detection.
430  */
431 interface IAccessControl {
432   /**
433    * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
434    *
435    * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
436    * {RoleAdminChanged} not being emitted signaling this.
437    *
438    * _Available since v3.1._
439    */
440   event RoleAdminChanged(
441     bytes32 indexed role,
442     bytes32 indexed previousAdminRole,
443     bytes32 indexed newAdminRole
444   );
445 
446   /**
447    * @dev Emitted when `account` is granted `role`.
448    *
449    * `sender` is the account that originated the contract call, an admin role
450    * bearer except when using {AccessControl-_setupRole}.
451    */
452   event RoleGranted(
453     bytes32 indexed role,
454     address indexed account,
455     address indexed sender
456   );
457 
458   /**
459    * @dev Emitted when `account` is revoked `role`.
460    *
461    * `sender` is the account that originated the contract call:
462    *   - if using `revokeRole`, it is the admin role bearer
463    *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
464    */
465   event RoleRevoked(
466     bytes32 indexed role,
467     address indexed account,
468     address indexed sender
469   );
470 
471   /**
472    * @dev Returns `true` if `account` has been granted `role`.
473    */
474   function hasRole(bytes32 role, address account) external view returns (bool);
475 
476   /**
477    * @dev Returns the admin role that controls `role`. See {grantRole} and
478    * {revokeRole}.
479    *
480    * To change a role's admin, use {AccessControl-_setRoleAdmin}.
481    */
482   function getRoleAdmin(bytes32 role) external view returns (bytes32);
483 
484   /**
485    * @dev Grants `role` to `account`.
486    *
487    * If `account` had not been already granted `role`, emits a {RoleGranted}
488    * event.
489    *
490    * Requirements:
491    *
492    * - the caller must have ``role``'s admin role.
493    */
494   function grantRole(bytes32 role, address account) external;
495 
496   /**
497    * @dev Revokes `role` from `account`.
498    *
499    * If `account` had been granted `role`, emits a {RoleRevoked} event.
500    *
501    * Requirements:
502    *
503    * - the caller must have ``role``'s admin role.
504    */
505   function revokeRole(bytes32 role, address account) external;
506 
507   /**
508    * @dev Revokes `role` from the calling account.
509    *
510    * Roles are often managed via {grantRole} and {revokeRole}: this function's
511    * purpose is to provide a mechanism for accounts to lose their privileges
512    * if they are compromised (such as when a trusted device is misplaced).
513    *
514    * If the calling account had been granted `role`, emits a {RoleRevoked}
515    * event.
516    *
517    * Requirements:
518    *
519    * - the caller must be `account`.
520    */
521   function renounceRole(bytes32 role, address account) external;
522 }
523 
524 // File: @openzeppelin/contracts/access/AccessControl.sol
525 
526 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
527 
528 pragma solidity ^0.8.0;
529 
530 /**
531  * @dev Contract module that allows children to implement role-based access
532  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
533  * members except through off-chain means by accessing the contract event logs. Some
534  * applications may benefit from on-chain enumerability, for those cases see
535  * {AccessControlEnumerable}.
536  *
537  * Roles are referred to by their `bytes32` identifier. These should be exposed
538  * in the external API and be unique. The best way to achieve this is by
539  * using `public constant` hash digests:
540  *
541  * ```
542  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
543  * ```
544  *
545  * Roles can be used to represent a set of permissions. To restrict access to a
546  * function call, use {hasRole}:
547  *
548  * ```
549  * function foo() public {
550  *     require(hasRole(MY_ROLE, msg.sender));
551  *     ...
552  * }
553  * ```
554  *
555  * Roles can be granted and revoked dynamically via the {grantRole} and
556  * {revokeRole} functions. Each role has an associated admin role, and only
557  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
558  *
559  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
560  * that only accounts with this role will be able to grant or revoke other
561  * roles. More complex role relationships can be created by using
562  * {_setRoleAdmin}.
563  *
564  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
565  * grant and revoke this role. Extra precautions should be taken to secure
566  * accounts that have been granted it.
567  */
568 abstract contract AccessControl is Context, IAccessControl, ERC165 {
569   struct RoleData {
570     mapping(address => bool) members;
571     bytes32 adminRole;
572   }
573 
574   mapping(bytes32 => RoleData) private _roles;
575 
576   bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
577 
578   /**
579    * @dev Modifier that checks that an account has a specific role. Reverts
580    * with a standardized message including the required role.
581    *
582    * The format of the revert reason is given by the following regular expression:
583    *
584    *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
585    *
586    * _Available since v4.1._
587    */
588   modifier onlyRole(bytes32 role) {
589     _checkRole(role);
590     _;
591   }
592 
593   /**
594    * @dev See {IERC165-supportsInterface}.
595    */
596   function supportsInterface(bytes4 interfaceId)
597     public
598     view
599     virtual
600     override
601     returns (bool)
602   {
603     return
604       interfaceId == type(IAccessControl).interfaceId ||
605       super.supportsInterface(interfaceId);
606   }
607 
608   /**
609    * @dev Returns `true` if `account` has been granted `role`.
610    */
611   function hasRole(bytes32 role, address account)
612     public
613     view
614     virtual
615     override
616     returns (bool)
617   {
618     return _roles[role].members[account];
619   }
620 
621   /**
622    * @dev Revert with a standard message if `_msgSender()` is missing `role`.
623    * Overriding this function changes the behavior of the {onlyRole} modifier.
624    *
625    * Format of the revert message is described in {_checkRole}.
626    *
627    * _Available since v4.6._
628    */
629   function _checkRole(bytes32 role) internal view virtual {
630     _checkRole(role, _msgSender());
631   }
632 
633   /**
634    * @dev Revert with a standard message if `account` is missing `role`.
635    *
636    * The format of the revert reason is given by the following regular expression:
637    *
638    *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
639    */
640   function _checkRole(bytes32 role, address account) internal view virtual {
641     if (!hasRole(role, account)) {
642       revert(
643         string(
644           abi.encodePacked(
645             "AccessControl: account ",
646             Strings.toHexString(uint160(account), 20),
647             " is missing role ",
648             Strings.toHexString(uint256(role), 32)
649           )
650         )
651       );
652     }
653   }
654 
655   /**
656    * @dev Returns the admin role that controls `role`. See {grantRole} and
657    * {revokeRole}.
658    *
659    * To change a role's admin, use {_setRoleAdmin}.
660    */
661   function getRoleAdmin(bytes32 role)
662     public
663     view
664     virtual
665     override
666     returns (bytes32)
667   {
668     return _roles[role].adminRole;
669   }
670 
671   /**
672    * @dev Grants `role` to `account`.
673    *
674    * If `account` had not been already granted `role`, emits a {RoleGranted}
675    * event.
676    *
677    * Requirements:
678    *
679    * - the caller must have ``role``'s admin role.
680    *
681    * May emit a {RoleGranted} event.
682    */
683   function grantRole(bytes32 role, address account)
684     public
685     virtual
686     override
687     onlyRole(getRoleAdmin(role))
688   {
689     _grantRole(role, account);
690   }
691 
692   /**
693    * @dev Revokes `role` from `account`.
694    *
695    * If `account` had been granted `role`, emits a {RoleRevoked} event.
696    *
697    * Requirements:
698    *
699    * - the caller must have ``role``'s admin role.
700    *
701    * May emit a {RoleRevoked} event.
702    */
703   function revokeRole(bytes32 role, address account)
704     public
705     virtual
706     override
707     onlyRole(getRoleAdmin(role))
708   {
709     _revokeRole(role, account);
710   }
711 
712   /**
713    * @dev Revokes `role` from the calling account.
714    *
715    * Roles are often managed via {grantRole} and {revokeRole}: this function's
716    * purpose is to provide a mechanism for accounts to lose their privileges
717    * if they are compromised (such as when a trusted device is misplaced).
718    *
719    * If the calling account had been revoked `role`, emits a {RoleRevoked}
720    * event.
721    *
722    * Requirements:
723    *
724    * - the caller must be `account`.
725    *
726    * May emit a {RoleRevoked} event.
727    */
728   function renounceRole(bytes32 role, address account) public virtual override {
729     require(
730       account == _msgSender(),
731       "AccessControl: can only renounce roles for self"
732     );
733 
734     _revokeRole(role, account);
735   }
736 
737   /**
738    * @dev Grants `role` to `account`.
739    *
740    * If `account` had not been already granted `role`, emits a {RoleGranted}
741    * event. Note that unlike {grantRole}, this function doesn't perform any
742    * checks on the calling account.
743    *
744    * May emit a {RoleGranted} event.
745    *
746    * [WARNING]
747    * ====
748    * This function should only be called from the constructor when setting
749    * up the initial roles for the system.
750    *
751    * Using this function in any other way is effectively circumventing the admin
752    * system imposed by {AccessControl}.
753    * ====
754    *
755    * NOTE: This function is deprecated in favor of {_grantRole}.
756    */
757   function _setupRole(bytes32 role, address account) internal virtual {
758     _grantRole(role, account);
759   }
760 
761   /**
762    * @dev Sets `adminRole` as ``role``'s admin role.
763    *
764    * Emits a {RoleAdminChanged} event.
765    */
766   function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
767     bytes32 previousAdminRole = getRoleAdmin(role);
768     _roles[role].adminRole = adminRole;
769     emit RoleAdminChanged(role, previousAdminRole, adminRole);
770   }
771 
772   /**
773    * @dev Grants `role` to `account`.
774    *
775    * Internal function without access restriction.
776    *
777    * May emit a {RoleGranted} event.
778    */
779   function _grantRole(bytes32 role, address account) internal virtual {
780     if (!hasRole(role, account)) {
781       _roles[role].members[account] = true;
782       emit RoleGranted(role, account, _msgSender());
783     }
784   }
785 
786   /**
787    * @dev Revokes `role` from `account`.
788    *
789    * Internal function without access restriction.
790    *
791    * May emit a {RoleRevoked} event.
792    */
793   function _revokeRole(bytes32 role, address account) internal virtual {
794     if (hasRole(role, account)) {
795       _roles[role].members[account] = false;
796       emit RoleRevoked(role, account, _msgSender());
797     }
798   }
799 }
800 
801 // File: contracts/DecagonTimelock.sol
802 
803 pragma solidity ^0.8.4;
804 
805 error NotTokenOwner();
806 error InvalidSignature();
807 error NonceAlreadyUsed();
808 error ExpiredSignature();
809 
810 contract DecagonTimelock is AccessControl {
811   address private signer;
812   IERC721 public decagon;
813 
814   mapping(uint256 => uint256) private timelocks;
815   mapping(string => bool) public usedNonces;
816 
817   event TokenLocked(
818     uint256 indexed tokenId,
819     uint256 indexed numberOfWeeks,
820     string nonce
821   );
822   event SignerUpdated(address indexed newSigner);
823 
824   constructor(
825     address _signer,
826     address _decagon,
827     address[] memory admins_
828   ) {
829     decagon = IERC721(_decagon);
830     signer = _signer;
831 
832     for (uint256 i = 0; i < admins_.length; i++) {
833       _grantRole(DEFAULT_ADMIN_ROLE, admins_[i]);
834     }
835   }
836 
837   modifier onlyTokenOwner(uint256 tokenId) {
838     if (decagon.ownerOf(tokenId) != msg.sender) revert NotTokenOwner();
839     _;
840   }
841 
842   function updateSigner(address newSigner)
843     external
844     onlyRole(DEFAULT_ADMIN_ROLE)
845   {
846     signer = newSigner;
847     emit SignerUpdated(newSigner);
848   }
849 
850   function removeTimelock(uint256 tokenId)
851     external
852     onlyRole(DEFAULT_ADMIN_ROLE)
853   {
854     timelocks[tokenId] = 0;
855   }
856 
857   function beforeTransferLogic(
858     address from,
859     address to,
860     uint256 tokenId
861   ) external view {
862     require(!isTimelocked(tokenId), "Decagon: Timelocked token");
863   }
864 
865   function isTimelocked(uint256 tokenId) public view returns (bool) {
866     return block.timestamp < timelocks[tokenId];
867   }
868 
869   function timelockExpiresAt(uint256 tokenId) external view returns (uint256) {
870     return timelocks[tokenId];
871   }
872 
873   function lockToken(
874     uint256 tokenId,
875     uint256 numberOfWeeks,
876     string memory nonce,
877     uint256 expiryBlock,
878     bytes memory signature
879   ) external onlyTokenOwner(tokenId) {
880     if (usedNonces[nonce]) revert NonceAlreadyUsed();
881 
882     if (block.number > expiryBlock) revert ExpiredSignature();
883 
884     if (
885       !verify(
886         keccak256(
887           abi.encodePacked(
888             msg.sender,
889             tokenId,
890             numberOfWeeks,
891             nonce,
892             expiryBlock,
893             address(this)
894           )
895         ),
896         signature
897       )
898     ) revert InvalidSignature();
899 
900     usedNonces[nonce] = true;
901     uint256 expires = block.timestamp + (1 weeks * numberOfWeeks);
902     timelocks[tokenId] = expires;
903 
904     emit TokenLocked(tokenId, numberOfWeeks, nonce);
905   }
906 
907   function verify(bytes32 messageHash, bytes memory signature)
908     internal
909     view
910     returns (bool)
911   {
912     return
913       signer ==
914       ECDSA.recover(ECDSA.toEthSignedMessageHash(messageHash), signature);
915   }
916 }
917 
918 interface IERC721 {
919   function ownerOf(uint256 tokenId) external view returns (address);
920 }