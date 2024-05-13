1 
2 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
3 
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
30 
31 
32 
33 pragma solidity ^0.8.0;
34 
35 
36 /**
37  * @dev Implementation of the {IERC165} interface.
38  *
39  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
40  * for the additional interface id that will be supported. For example:
41  *
42  * ```solidity
43  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
44  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
45  * }
46  * ```
47  *
48  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
49  */
50 abstract contract ERC165 is IERC165 {
51     /**
52      * @dev See {IERC165-supportsInterface}.
53      */
54     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
55         return interfaceId == type(IERC165).interfaceId;
56     }
57 }
58 
59 // File: @openzeppelin/contracts/utils/Strings.sol
60 
61 
62 
63 pragma solidity ^0.8.0;
64 
65 /**
66  * @dev String operations.
67  */
68 library Strings {
69     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
70 
71     /**
72      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
73      */
74     function toString(uint256 value) internal pure returns (string memory) {
75         // Inspired by OraclizeAPI's implementation - MIT licence
76         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
77 
78         if (value == 0) {
79             return "0";
80         }
81         uint256 temp = value;
82         uint256 digits;
83         while (temp != 0) {
84             digits++;
85             temp /= 10;
86         }
87         bytes memory buffer = new bytes(digits);
88         while (value != 0) {
89             digits -= 1;
90             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
91             value /= 10;
92         }
93         return string(buffer);
94     }
95 
96     /**
97      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
98      */
99     function toHexString(uint256 value) internal pure returns (string memory) {
100         if (value == 0) {
101             return "0x00";
102         }
103         uint256 temp = value;
104         uint256 length = 0;
105         while (temp != 0) {
106             length++;
107             temp >>= 8;
108         }
109         return toHexString(value, length);
110     }
111 
112     /**
113      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
114      */
115     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
116         bytes memory buffer = new bytes(2 * length + 2);
117         buffer[0] = "0";
118         buffer[1] = "x";
119         for (uint256 i = 2 * length + 1; i > 1; --i) {
120             buffer[i] = _HEX_SYMBOLS[value & 0xf];
121             value >>= 4;
122         }
123         require(value == 0, "Strings: hex length insufficient");
124         return string(buffer);
125     }
126 }
127 
128 // File: @openzeppelin/contracts/access/IAccessControl.sol
129 
130 
131 
132 pragma solidity ^0.8.0;
133 
134 /**
135  * @dev External interface of AccessControl declared to support ERC165 detection.
136  */
137 interface IAccessControl {
138     /**
139      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
140      *
141      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
142      * {RoleAdminChanged} not being emitted signaling this.
143      *
144      * _Available since v3.1._
145      */
146     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
147 
148     /**
149      * @dev Emitted when `account` is granted `role`.
150      *
151      * `sender` is the account that originated the contract call, an admin role
152      * bearer except when using {AccessControl-_setupRole}.
153      */
154     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
155 
156     /**
157      * @dev Emitted when `account` is revoked `role`.
158      *
159      * `sender` is the account that originated the contract call:
160      *   - if using `revokeRole`, it is the admin role bearer
161      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
162      */
163     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
164 
165     /**
166      * @dev Returns `true` if `account` has been granted `role`.
167      */
168     function hasRole(bytes32 role, address account) external view returns (bool);
169 
170     /**
171      * @dev Returns the admin role that controls `role`. See {grantRole} and
172      * {revokeRole}.
173      *
174      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
175      */
176     function getRoleAdmin(bytes32 role) external view returns (bytes32);
177 
178     /**
179      * @dev Grants `role` to `account`.
180      *
181      * If `account` had not been already granted `role`, emits a {RoleGranted}
182      * event.
183      *
184      * Requirements:
185      *
186      * - the caller must have ``role``'s admin role.
187      */
188     function grantRole(bytes32 role, address account) external;
189 
190     /**
191      * @dev Revokes `role` from `account`.
192      *
193      * If `account` had been granted `role`, emits a {RoleRevoked} event.
194      *
195      * Requirements:
196      *
197      * - the caller must have ``role``'s admin role.
198      */
199     function revokeRole(bytes32 role, address account) external;
200 
201     /**
202      * @dev Revokes `role` from the calling account.
203      *
204      * Roles are often managed via {grantRole} and {revokeRole}: this function's
205      * purpose is to provide a mechanism for accounts to lose their privileges
206      * if they are compromised (such as when a trusted device is misplaced).
207      *
208      * If the calling account had been granted `role`, emits a {RoleRevoked}
209      * event.
210      *
211      * Requirements:
212      *
213      * - the caller must be `account`.
214      */
215     function renounceRole(bytes32 role, address account) external;
216 }
217 
218 // File: @openzeppelin/contracts/utils/Counters.sol
219 
220 
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @title Counters
226  * @author Matt Condon (@shrugs)
227  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
228  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
229  *
230  * Include with `using Counters for Counters.Counter;`
231  */
232 library Counters {
233     struct Counter {
234         // This variable should never be directly accessed by users of the library: interactions must be restricted to
235         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
236         // this feature: see https://github.com/ethereum/solidity/issues/4637
237         uint256 _value; // default: 0
238     }
239 
240     function current(Counter storage counter) internal view returns (uint256) {
241         return counter._value;
242     }
243 
244     function increment(Counter storage counter) internal {
245         unchecked {
246             counter._value += 1;
247         }
248     }
249 
250     function decrement(Counter storage counter) internal {
251         uint256 value = counter._value;
252         require(value > 0, "Counter: decrement overflow");
253         unchecked {
254             counter._value = value - 1;
255         }
256     }
257 
258     function reset(Counter storage counter) internal {
259         counter._value = 0;
260     }
261 }
262 
263 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
264 
265 
266 
267 pragma solidity ^0.8.0;
268 
269 /**
270  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
271  *
272  * These functions can be used to verify that a message was signed by the holder
273  * of the private keys of a given address.
274  */
275 library ECDSA {
276     enum RecoverError {
277         NoError,
278         InvalidSignature,
279         InvalidSignatureLength,
280         InvalidSignatureS,
281         InvalidSignatureV
282     }
283 
284     function _throwError(RecoverError error) private pure {
285         if (error == RecoverError.NoError) {
286             return; // no error: do nothing
287         } else if (error == RecoverError.InvalidSignature) {
288             revert("ECDSA: invalid signature");
289         } else if (error == RecoverError.InvalidSignatureLength) {
290             revert("ECDSA: invalid signature length");
291         } else if (error == RecoverError.InvalidSignatureS) {
292             revert("ECDSA: invalid signature 's' value");
293         } else if (error == RecoverError.InvalidSignatureV) {
294             revert("ECDSA: invalid signature 'v' value");
295         }
296     }
297 
298     /**
299      * @dev Returns the address that signed a hashed message (`hash`) with
300      * `signature` or error string. This address can then be used for verification purposes.
301      *
302      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
303      * this function rejects them by requiring the `s` value to be in the lower
304      * half order, and the `v` value to be either 27 or 28.
305      *
306      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
307      * verification to be secure: it is possible to craft signatures that
308      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
309      * this is by receiving a hash of the original message (which may otherwise
310      * be too long), and then calling {toEthSignedMessageHash} on it.
311      *
312      * Documentation for signature generation:
313      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
314      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
315      *
316      * _Available since v4.3._
317      */
318     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
319         // Check the signature length
320         // - case 65: r,s,v signature (standard)
321         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
322         if (signature.length == 65) {
323             bytes32 r;
324             bytes32 s;
325             uint8 v;
326             // ecrecover takes the signature parameters, and the only way to get them
327             // currently is to use assembly.
328             assembly {
329                 r := mload(add(signature, 0x20))
330                 s := mload(add(signature, 0x40))
331                 v := byte(0, mload(add(signature, 0x60)))
332             }
333             return tryRecover(hash, v, r, s);
334         } else if (signature.length == 64) {
335             bytes32 r;
336             bytes32 vs;
337             // ecrecover takes the signature parameters, and the only way to get them
338             // currently is to use assembly.
339             assembly {
340                 r := mload(add(signature, 0x20))
341                 vs := mload(add(signature, 0x40))
342             }
343             return tryRecover(hash, r, vs);
344         } else {
345             return (address(0), RecoverError.InvalidSignatureLength);
346         }
347     }
348 
349     /**
350      * @dev Returns the address that signed a hashed message (`hash`) with
351      * `signature`. This address can then be used for verification purposes.
352      *
353      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
354      * this function rejects them by requiring the `s` value to be in the lower
355      * half order, and the `v` value to be either 27 or 28.
356      *
357      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
358      * verification to be secure: it is possible to craft signatures that
359      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
360      * this is by receiving a hash of the original message (which may otherwise
361      * be too long), and then calling {toEthSignedMessageHash} on it.
362      */
363     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
364         (address recovered, RecoverError error) = tryRecover(hash, signature);
365         _throwError(error);
366         return recovered;
367     }
368 
369     /**
370      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
371      *
372      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
373      *
374      * _Available since v4.3._
375      */
376     function tryRecover(
377         bytes32 hash,
378         bytes32 r,
379         bytes32 vs
380     ) internal pure returns (address, RecoverError) {
381         bytes32 s;
382         uint8 v;
383         assembly {
384             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
385             v := add(shr(255, vs), 27)
386         }
387         return tryRecover(hash, v, r, s);
388     }
389 
390     /**
391      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
392      *
393      * _Available since v4.2._
394      */
395     function recover(
396         bytes32 hash,
397         bytes32 r,
398         bytes32 vs
399     ) internal pure returns (address) {
400         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
401         _throwError(error);
402         return recovered;
403     }
404 
405     /**
406      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
407      * `r` and `s` signature fields separately.
408      *
409      * _Available since v4.3._
410      */
411     function tryRecover(
412         bytes32 hash,
413         uint8 v,
414         bytes32 r,
415         bytes32 s
416     ) internal pure returns (address, RecoverError) {
417         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
418         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
419         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
420         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
421         //
422         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
423         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
424         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
425         // these malleable signatures as well.
426         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
427             return (address(0), RecoverError.InvalidSignatureS);
428         }
429         if (v != 27 && v != 28) {
430             return (address(0), RecoverError.InvalidSignatureV);
431         }
432 
433         // If the signature is valid (and not malleable), return the signer address
434         address signer = ecrecover(hash, v, r, s);
435         if (signer == address(0)) {
436             return (address(0), RecoverError.InvalidSignature);
437         }
438 
439         return (signer, RecoverError.NoError);
440     }
441 
442     /**
443      * @dev Overload of {ECDSA-recover} that receives the `v`,
444      * `r` and `s` signature fields separately.
445      */
446     function recover(
447         bytes32 hash,
448         uint8 v,
449         bytes32 r,
450         bytes32 s
451     ) internal pure returns (address) {
452         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
453         _throwError(error);
454         return recovered;
455     }
456 
457     /**
458      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
459      * produces hash corresponding to the one signed with the
460      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
461      * JSON-RPC method as part of EIP-191.
462      *
463      * See {recover}.
464      */
465     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
466         // 32 is the length in bytes of hash,
467         // enforced by the type signature above
468         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
469     }
470 
471     /**
472      * @dev Returns an Ethereum Signed Typed Data, created from a
473      * `domainSeparator` and a `structHash`. This produces hash corresponding
474      * to the one signed with the
475      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
476      * JSON-RPC method as part of EIP-712.
477      *
478      * See {recover}.
479      */
480     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
481         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
482     }
483 }
484 
485 // File: @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol
486 
487 
488 
489 pragma solidity ^0.8.0;
490 
491 
492 /**
493  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
494  *
495  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
496  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
497  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
498  *
499  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
500  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
501  * ({_hashTypedDataV4}).
502  *
503  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
504  * the chain id to protect against replay attacks on an eventual fork of the chain.
505  *
506  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
507  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
508  *
509  * _Available since v3.4._
510  */
511 abstract contract EIP712 {
512     /* solhint-disable var-name-mixedcase */
513     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
514     // invalidate the cached domain separator if the chain id changes.
515     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
516     uint256 private immutable _CACHED_CHAIN_ID;
517 
518     bytes32 private immutable _HASHED_NAME;
519     bytes32 private immutable _HASHED_VERSION;
520     bytes32 private immutable _TYPE_HASH;
521 
522     /* solhint-enable var-name-mixedcase */
523 
524     /**
525      * @dev Initializes the domain separator and parameter caches.
526      *
527      * The meaning of `name` and `version` is specified in
528      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
529      *
530      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
531      * - `version`: the current major version of the signing domain.
532      *
533      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
534      * contract upgrade].
535      */
536     constructor(string memory name, string memory version) {
537         bytes32 hashedName = keccak256(bytes(name));
538         bytes32 hashedVersion = keccak256(bytes(version));
539         bytes32 typeHash = keccak256(
540             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
541         );
542         _HASHED_NAME = hashedName;
543         _HASHED_VERSION = hashedVersion;
544         _CACHED_CHAIN_ID = block.chainid;
545         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
546         _TYPE_HASH = typeHash;
547     }
548 
549     /**
550      * @dev Returns the domain separator for the current chain.
551      */
552     function _domainSeparatorV4() internal view returns (bytes32) {
553         if (block.chainid == _CACHED_CHAIN_ID) {
554             return _CACHED_DOMAIN_SEPARATOR;
555         } else {
556             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
557         }
558     }
559 
560     function _buildDomainSeparator(
561         bytes32 typeHash,
562         bytes32 nameHash,
563         bytes32 versionHash
564     ) private view returns (bytes32) {
565         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
566     }
567 
568     /**
569      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
570      * function returns the hash of the fully encoded EIP712 message for this domain.
571      *
572      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
573      *
574      * ```solidity
575      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
576      *     keccak256("Mail(address to,string contents)"),
577      *     mailTo,
578      *     keccak256(bytes(mailContents))
579      * )));
580      * address signer = ECDSA.recover(digest, signature);
581      * ```
582      */
583     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
584         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
585     }
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
589 
590 
591 
592 pragma solidity ^0.8.0;
593 
594 /**
595  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
596  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
597  *
598  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
599  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
600  * need to send a transaction, and thus is not required to hold Ether at all.
601  */
602 interface IERC20Permit {
603     /**
604      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
605      * given ``owner``'s signed approval.
606      *
607      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
608      * ordering also apply here.
609      *
610      * Emits an {Approval} event.
611      *
612      * Requirements:
613      *
614      * - `spender` cannot be the zero address.
615      * - `deadline` must be a timestamp in the future.
616      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
617      * over the EIP712-formatted function arguments.
618      * - the signature must use ``owner``'s current nonce (see {nonces}).
619      *
620      * For more information on the signature format, see the
621      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
622      * section].
623      */
624     function permit(
625         address owner,
626         address spender,
627         uint256 value,
628         uint256 deadline,
629         uint8 v,
630         bytes32 r,
631         bytes32 s
632     ) external;
633 
634     /**
635      * @dev Returns the current nonce for `owner`. This value must be
636      * included whenever a signature is generated for {permit}.
637      *
638      * Every successful call to {permit} increases ``owner``'s nonce by one. This
639      * prevents a signature from being used multiple times.
640      */
641     function nonces(address owner) external view returns (uint256);
642 
643     /**
644      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
645      */
646     // solhint-disable-next-line func-name-mixedcase
647     function DOMAIN_SEPARATOR() external view returns (bytes32);
648 }
649 
650 // File: @openzeppelin/contracts/utils/Context.sol
651 
652 
653 
654 pragma solidity ^0.8.0;
655 
656 /**
657  * @dev Provides information about the current execution context, including the
658  * sender of the transaction and its data. While these are generally available
659  * via msg.sender and msg.data, they should not be accessed in such a direct
660  * manner, since when dealing with meta-transactions the account sending and
661  * paying for execution may not be the actual sender (as far as an application
662  * is concerned).
663  *
664  * This contract is only required for intermediate, library-like contracts.
665  */
666 abstract contract Context {
667     function _msgSender() internal view virtual returns (address) {
668         return msg.sender;
669     }
670 
671     function _msgData() internal view virtual returns (bytes calldata) {
672         return msg.data;
673     }
674 }
675 
676 // File: @openzeppelin/contracts/access/AccessControl.sol
677 
678 
679 
680 pragma solidity ^0.8.0;
681 
682 
683 
684 
685 
686 /**
687  * @dev Contract module that allows children to implement role-based access
688  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
689  * members except through off-chain means by accessing the contract event logs. Some
690  * applications may benefit from on-chain enumerability, for those cases see
691  * {AccessControlEnumerable}.
692  *
693  * Roles are referred to by their `bytes32` identifier. These should be exposed
694  * in the external API and be unique. The best way to achieve this is by
695  * using `public constant` hash digests:
696  *
697  * ```
698  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
699  * ```
700  *
701  * Roles can be used to represent a set of permissions. To restrict access to a
702  * function call, use {hasRole}:
703  *
704  * ```
705  * function foo() public {
706  *     require(hasRole(MY_ROLE, msg.sender));
707  *     ...
708  * }
709  * ```
710  *
711  * Roles can be granted and revoked dynamically via the {grantRole} and
712  * {revokeRole} functions. Each role has an associated admin role, and only
713  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
714  *
715  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
716  * that only accounts with this role will be able to grant or revoke other
717  * roles. More complex role relationships can be created by using
718  * {_setRoleAdmin}.
719  *
720  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
721  * grant and revoke this role. Extra precautions should be taken to secure
722  * accounts that have been granted it.
723  */
724 abstract contract AccessControl is Context, IAccessControl, ERC165 {
725     struct RoleData {
726         mapping(address => bool) members;
727         bytes32 adminRole;
728     }
729 
730     mapping(bytes32 => RoleData) private _roles;
731 
732     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
733 
734     /**
735      * @dev Modifier that checks that an account has a specific role. Reverts
736      * with a standardized message including the required role.
737      *
738      * The format of the revert reason is given by the following regular expression:
739      *
740      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
741      *
742      * _Available since v4.1._
743      */
744     modifier onlyRole(bytes32 role) {
745         _checkRole(role, _msgSender());
746         _;
747     }
748 
749     /**
750      * @dev See {IERC165-supportsInterface}.
751      */
752     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
753         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
754     }
755 
756     /**
757      * @dev Returns `true` if `account` has been granted `role`.
758      */
759     function hasRole(bytes32 role, address account) public view override returns (bool) {
760         return _roles[role].members[account];
761     }
762 
763     /**
764      * @dev Revert with a standard message if `account` is missing `role`.
765      *
766      * The format of the revert reason is given by the following regular expression:
767      *
768      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
769      */
770     function _checkRole(bytes32 role, address account) internal view {
771         if (!hasRole(role, account)) {
772             revert(
773                 string(
774                     abi.encodePacked(
775                         "AccessControl: account ",
776                         Strings.toHexString(uint160(account), 20),
777                         " is missing role ",
778                         Strings.toHexString(uint256(role), 32)
779                     )
780                 )
781             );
782         }
783     }
784 
785     /**
786      * @dev Returns the admin role that controls `role`. See {grantRole} and
787      * {revokeRole}.
788      *
789      * To change a role's admin, use {_setRoleAdmin}.
790      */
791     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
792         return _roles[role].adminRole;
793     }
794 
795     /**
796      * @dev Grants `role` to `account`.
797      *
798      * If `account` had not been already granted `role`, emits a {RoleGranted}
799      * event.
800      *
801      * Requirements:
802      *
803      * - the caller must have ``role``'s admin role.
804      */
805     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
806         _grantRole(role, account);
807     }
808 
809     /**
810      * @dev Revokes `role` from `account`.
811      *
812      * If `account` had been granted `role`, emits a {RoleRevoked} event.
813      *
814      * Requirements:
815      *
816      * - the caller must have ``role``'s admin role.
817      */
818     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
819         _revokeRole(role, account);
820     }
821 
822     /**
823      * @dev Revokes `role` from the calling account.
824      *
825      * Roles are often managed via {grantRole} and {revokeRole}: this function's
826      * purpose is to provide a mechanism for accounts to lose their privileges
827      * if they are compromised (such as when a trusted device is misplaced).
828      *
829      * If the calling account had been granted `role`, emits a {RoleRevoked}
830      * event.
831      *
832      * Requirements:
833      *
834      * - the caller must be `account`.
835      */
836     function renounceRole(bytes32 role, address account) public virtual override {
837         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
838 
839         _revokeRole(role, account);
840     }
841 
842     /**
843      * @dev Grants `role` to `account`.
844      *
845      * If `account` had not been already granted `role`, emits a {RoleGranted}
846      * event. Note that unlike {grantRole}, this function doesn't perform any
847      * checks on the calling account.
848      *
849      * [WARNING]
850      * ====
851      * This function should only be called from the constructor when setting
852      * up the initial roles for the system.
853      *
854      * Using this function in any other way is effectively circumventing the admin
855      * system imposed by {AccessControl}.
856      * ====
857      */
858     function _setupRole(bytes32 role, address account) internal virtual {
859         _grantRole(role, account);
860     }
861 
862     /**
863      * @dev Sets `adminRole` as ``role``'s admin role.
864      *
865      * Emits a {RoleAdminChanged} event.
866      */
867     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
868         bytes32 previousAdminRole = getRoleAdmin(role);
869         _roles[role].adminRole = adminRole;
870         emit RoleAdminChanged(role, previousAdminRole, adminRole);
871     }
872 
873     function _grantRole(bytes32 role, address account) private {
874         if (!hasRole(role, account)) {
875             _roles[role].members[account] = true;
876             emit RoleGranted(role, account, _msgSender());
877         }
878     }
879 
880     function _revokeRole(bytes32 role, address account) private {
881         if (hasRole(role, account)) {
882             _roles[role].members[account] = false;
883             emit RoleRevoked(role, account, _msgSender());
884         }
885     }
886 }
887 
888 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
889 
890 
891 
892 pragma solidity ^0.8.0;
893 
894 /**
895  * @dev Interface of the ERC20 standard as defined in the EIP.
896  */
897 interface IERC20 {
898     /**
899      * @dev Returns the amount of tokens in existence.
900      */
901     function totalSupply() external view returns (uint256);
902 
903     /**
904      * @dev Returns the amount of tokens owned by `account`.
905      */
906     function balanceOf(address account) external view returns (uint256);
907 
908     /**
909      * @dev Moves `amount` tokens from the caller's account to `recipient`.
910      *
911      * Returns a boolean value indicating whether the operation succeeded.
912      *
913      * Emits a {Transfer} event.
914      */
915     function transfer(address recipient, uint256 amount) external returns (bool);
916 
917     /**
918      * @dev Returns the remaining number of tokens that `spender` will be
919      * allowed to spend on behalf of `owner` through {transferFrom}. This is
920      * zero by default.
921      *
922      * This value changes when {approve} or {transferFrom} are called.
923      */
924     function allowance(address owner, address spender) external view returns (uint256);
925 
926     /**
927      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
928      *
929      * Returns a boolean value indicating whether the operation succeeded.
930      *
931      * IMPORTANT: Beware that changing an allowance with this method brings the risk
932      * that someone may use both the old and the new allowance by unfortunate
933      * transaction ordering. One possible solution to mitigate this race
934      * condition is to first reduce the spender's allowance to 0 and set the
935      * desired value afterwards:
936      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address spender, uint256 amount) external returns (bool);
941 
942     /**
943      * @dev Moves `amount` tokens from `sender` to `recipient` using the
944      * allowance mechanism. `amount` is then deducted from the caller's
945      * allowance.
946      *
947      * Returns a boolean value indicating whether the operation succeeded.
948      *
949      * Emits a {Transfer} event.
950      */
951     function transferFrom(
952         address sender,
953         address recipient,
954         uint256 amount
955     ) external returns (bool);
956 
957     /**
958      * @dev Emitted when `value` tokens are moved from one account (`from`) to
959      * another (`to`).
960      *
961      * Note that `value` may be zero.
962      */
963     event Transfer(address indexed from, address indexed to, uint256 value);
964 
965     /**
966      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
967      * a call to {approve}. `value` is the new allowance.
968      */
969     event Approval(address indexed owner, address indexed spender, uint256 value);
970 }
971 
972 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
973 
974 
975 
976 pragma solidity ^0.8.0;
977 
978 
979 /**
980  * @dev Interface for the optional metadata functions from the ERC20 standard.
981  *
982  * _Available since v4.1._
983  */
984 interface IERC20Metadata is IERC20 {
985     /**
986      * @dev Returns the name of the token.
987      */
988     function name() external view returns (string memory);
989 
990     /**
991      * @dev Returns the symbol of the token.
992      */
993     function symbol() external view returns (string memory);
994 
995     /**
996      * @dev Returns the decimals places of the token.
997      */
998     function decimals() external view returns (uint8);
999 }
1000 
1001 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
1002 
1003 
1004 
1005 pragma solidity ^0.8.0;
1006 
1007 
1008 
1009 
1010 /**
1011  * @dev Implementation of the {IERC20} interface.
1012  *
1013  * This implementation is agnostic to the way tokens are created. This means
1014  * that a supply mechanism has to be added in a derived contract using {_mint}.
1015  * For a generic mechanism see {ERC20PresetMinterPauser}.
1016  *
1017  * TIP: For a detailed writeup see our guide
1018  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
1019  * to implement supply mechanisms].
1020  *
1021  * We have followed general OpenZeppelin Contracts guidelines: functions revert
1022  * instead returning `false` on failure. This behavior is nonetheless
1023  * conventional and does not conflict with the expectations of ERC20
1024  * applications.
1025  *
1026  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
1027  * This allows applications to reconstruct the allowance for all accounts just
1028  * by listening to said events. Other implementations of the EIP may not emit
1029  * these events, as it isn't required by the specification.
1030  *
1031  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
1032  * functions have been added to mitigate the well-known issues around setting
1033  * allowances. See {IERC20-approve}.
1034  */
1035 contract ERC20 is Context, IERC20, IERC20Metadata {
1036     mapping(address => uint256) private _balances;
1037 
1038     mapping(address => mapping(address => uint256)) private _allowances;
1039 
1040     uint256 private _totalSupply;
1041 
1042     string private _name;
1043     string private _symbol;
1044 
1045     /**
1046      * @dev Sets the values for {name} and {symbol}.
1047      *
1048      * The default value of {decimals} is 18. To select a different value for
1049      * {decimals} you should overload it.
1050      *
1051      * All two of these values are immutable: they can only be set once during
1052      * construction.
1053      */
1054     constructor(string memory name_, string memory symbol_) {
1055         _name = name_;
1056         _symbol = symbol_;
1057     }
1058 
1059     /**
1060      * @dev Returns the name of the token.
1061      */
1062     function name() public view virtual override returns (string memory) {
1063         return _name;
1064     }
1065 
1066     /**
1067      * @dev Returns the symbol of the token, usually a shorter version of the
1068      * name.
1069      */
1070     function symbol() public view virtual override returns (string memory) {
1071         return _symbol;
1072     }
1073 
1074     /**
1075      * @dev Returns the number of decimals used to get its user representation.
1076      * For example, if `decimals` equals `2`, a balance of `505` tokens should
1077      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
1078      *
1079      * Tokens usually opt for a value of 18, imitating the relationship between
1080      * Ether and Wei. This is the value {ERC20} uses, unless this function is
1081      * overridden;
1082      *
1083      * NOTE: This information is only used for _display_ purposes: it in
1084      * no way affects any of the arithmetic of the contract, including
1085      * {IERC20-balanceOf} and {IERC20-transfer}.
1086      */
1087     function decimals() public view virtual override returns (uint8) {
1088         return 18;
1089     }
1090 
1091     /**
1092      * @dev See {IERC20-totalSupply}.
1093      */
1094     function totalSupply() public view virtual override returns (uint256) {
1095         return _totalSupply;
1096     }
1097 
1098     /**
1099      * @dev See {IERC20-balanceOf}.
1100      */
1101     function balanceOf(address account) public view virtual override returns (uint256) {
1102         return _balances[account];
1103     }
1104 
1105     /**
1106      * @dev See {IERC20-transfer}.
1107      *
1108      * Requirements:
1109      *
1110      * - `recipient` cannot be the zero address.
1111      * - the caller must have a balance of at least `amount`.
1112      */
1113     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1114         _transfer(_msgSender(), recipient, amount);
1115         return true;
1116     }
1117 
1118     /**
1119      * @dev See {IERC20-allowance}.
1120      */
1121     function allowance(address owner, address spender) public view virtual override returns (uint256) {
1122         return _allowances[owner][spender];
1123     }
1124 
1125     /**
1126      * @dev See {IERC20-approve}.
1127      *
1128      * Requirements:
1129      *
1130      * - `spender` cannot be the zero address.
1131      */
1132     function approve(address spender, uint256 amount) public virtual override returns (bool) {
1133         _approve(_msgSender(), spender, amount);
1134         return true;
1135     }
1136 
1137     /**
1138      * @dev See {IERC20-transferFrom}.
1139      *
1140      * Emits an {Approval} event indicating the updated allowance. This is not
1141      * required by the EIP. See the note at the beginning of {ERC20}.
1142      *
1143      * Requirements:
1144      *
1145      * - `sender` and `recipient` cannot be the zero address.
1146      * - `sender` must have a balance of at least `amount`.
1147      * - the caller must have allowance for ``sender``'s tokens of at least
1148      * `amount`.
1149      */
1150     function transferFrom(
1151         address sender,
1152         address recipient,
1153         uint256 amount
1154     ) public virtual override returns (bool) {
1155         _transfer(sender, recipient, amount);
1156 
1157         uint256 currentAllowance = _allowances[sender][_msgSender()];
1158         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1159         unchecked {
1160             _approve(sender, _msgSender(), currentAllowance - amount);
1161         }
1162 
1163         return true;
1164     }
1165 
1166     /**
1167      * @dev Atomically increases the allowance granted to `spender` by the caller.
1168      *
1169      * This is an alternative to {approve} that can be used as a mitigation for
1170      * problems described in {IERC20-approve}.
1171      *
1172      * Emits an {Approval} event indicating the updated allowance.
1173      *
1174      * Requirements:
1175      *
1176      * - `spender` cannot be the zero address.
1177      */
1178     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
1179         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1180         return true;
1181     }
1182 
1183     /**
1184      * @dev Atomically decreases the allowance granted to `spender` by the caller.
1185      *
1186      * This is an alternative to {approve} that can be used as a mitigation for
1187      * problems described in {IERC20-approve}.
1188      *
1189      * Emits an {Approval} event indicating the updated allowance.
1190      *
1191      * Requirements:
1192      *
1193      * - `spender` cannot be the zero address.
1194      * - `spender` must have allowance for the caller of at least
1195      * `subtractedValue`.
1196      */
1197     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
1198         uint256 currentAllowance = _allowances[_msgSender()][spender];
1199         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1200         unchecked {
1201             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1202         }
1203 
1204         return true;
1205     }
1206 
1207     /**
1208      * @dev Moves `amount` of tokens from `sender` to `recipient`.
1209      *
1210      * This internal function is equivalent to {transfer}, and can be used to
1211      * e.g. implement automatic token fees, slashing mechanisms, etc.
1212      *
1213      * Emits a {Transfer} event.
1214      *
1215      * Requirements:
1216      *
1217      * - `sender` cannot be the zero address.
1218      * - `recipient` cannot be the zero address.
1219      * - `sender` must have a balance of at least `amount`.
1220      */
1221     function _transfer(
1222         address sender,
1223         address recipient,
1224         uint256 amount
1225     ) internal virtual {
1226         require(sender != address(0), "ERC20: transfer from the zero address");
1227         require(recipient != address(0), "ERC20: transfer to the zero address");
1228 
1229         _beforeTokenTransfer(sender, recipient, amount);
1230 
1231         uint256 senderBalance = _balances[sender];
1232         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1233         unchecked {
1234             _balances[sender] = senderBalance - amount;
1235         }
1236         _balances[recipient] += amount;
1237 
1238         emit Transfer(sender, recipient, amount);
1239 
1240         _afterTokenTransfer(sender, recipient, amount);
1241     }
1242 
1243     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
1244      * the total supply.
1245      *
1246      * Emits a {Transfer} event with `from` set to the zero address.
1247      *
1248      * Requirements:
1249      *
1250      * - `account` cannot be the zero address.
1251      */
1252     function _mint(address account, uint256 amount) internal virtual {
1253         require(account != address(0), "ERC20: mint to the zero address");
1254 
1255         _beforeTokenTransfer(address(0), account, amount);
1256 
1257         _totalSupply += amount;
1258         _balances[account] += amount;
1259         emit Transfer(address(0), account, amount);
1260 
1261         _afterTokenTransfer(address(0), account, amount);
1262     }
1263 
1264     /**
1265      * @dev Destroys `amount` tokens from `account`, reducing the
1266      * total supply.
1267      *
1268      * Emits a {Transfer} event with `to` set to the zero address.
1269      *
1270      * Requirements:
1271      *
1272      * - `account` cannot be the zero address.
1273      * - `account` must have at least `amount` tokens.
1274      */
1275     function _burn(address account, uint256 amount) internal virtual {
1276         require(account != address(0), "ERC20: burn from the zero address");
1277 
1278         _beforeTokenTransfer(account, address(0), amount);
1279 
1280         uint256 accountBalance = _balances[account];
1281         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1282         unchecked {
1283             _balances[account] = accountBalance - amount;
1284         }
1285         _totalSupply -= amount;
1286 
1287         emit Transfer(account, address(0), amount);
1288 
1289         _afterTokenTransfer(account, address(0), amount);
1290     }
1291 
1292     /**
1293      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
1294      *
1295      * This internal function is equivalent to `approve`, and can be used to
1296      * e.g. set automatic allowances for certain subsystems, etc.
1297      *
1298      * Emits an {Approval} event.
1299      *
1300      * Requirements:
1301      *
1302      * - `owner` cannot be the zero address.
1303      * - `spender` cannot be the zero address.
1304      */
1305     function _approve(
1306         address owner,
1307         address spender,
1308         uint256 amount
1309     ) internal virtual {
1310         require(owner != address(0), "ERC20: approve from the zero address");
1311         require(spender != address(0), "ERC20: approve to the zero address");
1312 
1313         _allowances[owner][spender] = amount;
1314         emit Approval(owner, spender, amount);
1315     }
1316 
1317     /**
1318      * @dev Hook that is called before any transfer of tokens. This includes
1319      * minting and burning.
1320      *
1321      * Calling conditions:
1322      *
1323      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1324      * will be transferred to `to`.
1325      * - when `from` is zero, `amount` tokens will be minted for `to`.
1326      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
1327      * - `from` and `to` are never both zero.
1328      *
1329      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1330      */
1331     function _beforeTokenTransfer(
1332         address from,
1333         address to,
1334         uint256 amount
1335     ) internal virtual {}
1336 
1337     /**
1338      * @dev Hook that is called after any transfer of tokens. This includes
1339      * minting and burning.
1340      *
1341      * Calling conditions:
1342      *
1343      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
1344      * has been transferred to `to`.
1345      * - when `from` is zero, `amount` tokens have been minted for `to`.
1346      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
1347      * - `from` and `to` are never both zero.
1348      *
1349      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1350      */
1351     function _afterTokenTransfer(
1352         address from,
1353         address to,
1354         uint256 amount
1355     ) internal virtual {}
1356 }
1357 
1358 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
1359 
1360 
1361 
1362 pragma solidity ^0.8.0;
1363 
1364 
1365 
1366 /**
1367  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1368  * tokens and those that they have an allowance for, in a way that can be
1369  * recognized off-chain (via event analysis).
1370  */
1371 abstract contract ERC20Burnable is Context, ERC20 {
1372     /**
1373      * @dev Destroys `amount` tokens from the caller.
1374      *
1375      * See {ERC20-_burn}.
1376      */
1377     function burn(uint256 amount) public virtual {
1378         _burn(_msgSender(), amount);
1379     }
1380 
1381     /**
1382      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1383      * allowance.
1384      *
1385      * See {ERC20-_burn} and {ERC20-allowance}.
1386      *
1387      * Requirements:
1388      *
1389      * - the caller must have allowance for ``accounts``'s tokens of at least
1390      * `amount`.
1391      */
1392     function burnFrom(address account, uint256 amount) public virtual {
1393         uint256 currentAllowance = allowance(account, _msgSender());
1394         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
1395         unchecked {
1396             _approve(account, _msgSender(), currentAllowance - amount);
1397         }
1398         _burn(account, amount);
1399     }
1400 }
1401 
1402 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
1403 
1404 
1405 
1406 pragma solidity ^0.8.0;
1407 
1408 
1409 /**
1410  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
1411  */
1412 abstract contract ERC20Capped is ERC20 {
1413     uint256 private immutable _cap;
1414 
1415     /**
1416      * @dev Sets the value of the `cap`. This value is immutable, it can only be
1417      * set once during construction.
1418      */
1419     constructor(uint256 cap_) {
1420         require(cap_ > 0, "ERC20Capped: cap is 0");
1421         _cap = cap_;
1422     }
1423 
1424     /**
1425      * @dev Returns the cap on the token's total supply.
1426      */
1427     function cap() public view virtual returns (uint256) {
1428         return _cap;
1429     }
1430 
1431     /**
1432      * @dev See {ERC20-_mint}.
1433      */
1434     function _mint(address account, uint256 amount) internal virtual override {
1435         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
1436         super._mint(account, amount);
1437     }
1438 }
1439 
1440 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol
1441 
1442 
1443 
1444 pragma solidity ^0.8.0;
1445 
1446 
1447 
1448 
1449 
1450 
1451 /**
1452  * @dev Implementation of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
1453  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
1454  *
1455  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
1456  * presenting a message signed by the account. By not relying on `{IERC20-approve}`, the token holder account doesn't
1457  * need to send a transaction, and thus is not required to hold Ether at all.
1458  *
1459  * _Available since v3.4._
1460  */
1461 abstract contract ERC20Permit is ERC20, IERC20Permit, EIP712 {
1462     using Counters for Counters.Counter;
1463 
1464     mapping(address => Counters.Counter) private _nonces;
1465 
1466     // solhint-disable-next-line var-name-mixedcase
1467     bytes32 private immutable _PERMIT_TYPEHASH =
1468         keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
1469 
1470     /**
1471      * @dev Initializes the {EIP712} domain separator using the `name` parameter, and setting `version` to `"1"`.
1472      *
1473      * It's a good idea to use the same `name` that is defined as the ERC20 token name.
1474      */
1475     constructor(string memory name) EIP712(name, "1") {}
1476 
1477     /**
1478      * @dev See {IERC20Permit-permit}.
1479      */
1480     function permit(
1481         address owner,
1482         address spender,
1483         uint256 value,
1484         uint256 deadline,
1485         uint8 v,
1486         bytes32 r,
1487         bytes32 s
1488     ) public virtual override {
1489         require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
1490 
1491         bytes32 structHash = keccak256(abi.encode(_PERMIT_TYPEHASH, owner, spender, value, _useNonce(owner), deadline));
1492 
1493         bytes32 hash = _hashTypedDataV4(structHash);
1494 
1495         address signer = ECDSA.recover(hash, v, r, s);
1496         require(signer == owner, "ERC20Permit: invalid signature");
1497 
1498         _approve(owner, spender, value);
1499     }
1500 
1501     /**
1502      * @dev See {IERC20Permit-nonces}.
1503      */
1504     function nonces(address owner) public view virtual override returns (uint256) {
1505         return _nonces[owner].current();
1506     }
1507 
1508     /**
1509      * @dev See {IERC20Permit-DOMAIN_SEPARATOR}.
1510      */
1511     // solhint-disable-next-line func-name-mixedcase
1512     function DOMAIN_SEPARATOR() external view override returns (bytes32) {
1513         return _domainSeparatorV4();
1514     }
1515 
1516     /**
1517      * @dev "Consume a nonce": return the current value and increment.
1518      *
1519      * _Available since v4.1._
1520      */
1521     function _useNonce(address owner) internal virtual returns (uint256 current) {
1522         Counters.Counter storage nonce = _nonces[owner];
1523         current = nonce.current();
1524         nonce.increment();
1525     }
1526 }
1527 
1528 // File: contracts/melodity-v2.sol
1529 
1530 
1531 pragma solidity ^0.8.2;
1532 
1533 contract Melodity is ERC20, ERC20Permit, ERC20Capped, AccessControl, ERC20Burnable {
1534     bytes32 public constant CROWDSALE_ROLE = 0x0000000000000000000000000000000000000000000000000000000000000001;
1535 
1536     event Bought(address account, uint256 amount);
1537     event Locked(address account, uint256 amount);
1538     event Released(address account, uint256 amount);
1539 
1540     struct Locks {
1541         uint256 locked;
1542         uint256 release_time;
1543         bool released;
1544     }
1545 
1546     uint256 public total_locked_amount = 0;
1547 
1548     mapping(address => Locks[]) private _locks;
1549 
1550 	uint256 ICO_START = 1642147200;
1551 	uint256 ICO_END = 1648771199;
1552 
1553     constructor() ERC20("Melodity", "MELD") ERC20Permit("Melodity") ERC20Capped(1000000000 * 10 ** decimals()) {
1554         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
1555         
1556 		uint256 pow = 10 ** decimals();
1557 		uint256 five_million = 5000000 * pow;
1558 		uint256 fifty_million = five_million * 10;
1559 		uint256 six_months = 60 * 60 * 24 * 180;
1560 		uint256 one_year = six_months * 2;
1561 		
1562 		// set default lock for devs
1563 		// devs funds are unlocked one time per year in a range of 4 years starting from the end of the ICO
1564 
1565 		// Ebalo
1566 		_mint(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), 4000000 * pow);
1567 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year);
1568 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 2);
1569 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 3);
1570 		insertLock(address(0xFC5dA6A95E0C2C2C23b8C0c387CDd3Af7E56FCC0), five_million, ICO_END - block.timestamp + one_year * 4);
1571 
1572 		// RG
1573 		_mint(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow);
1574 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year);
1575 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 2);
1576 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 3);
1577 		insertLock(address(0x618E9F7bbbeF323019eEf457f3b94E9E7943633A), 2800000 * pow, ICO_END - block.timestamp + one_year * 4);
1578 
1579 		// WG
1580 		_mint(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow);
1581 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year);
1582 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 2);
1583 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 3);
1584 		insertLock(address(0x3198c11724024C9cE7F81816E6E6B69580fe5585), 2400000 * pow, ICO_END - block.timestamp + one_year * 4);
1585 
1586 		// Do inc - Company wallet
1587 		_mint(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million);
1588 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year);
1589 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 2);
1590 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 3);
1591 		insertLock(address(0x01Af10f1343C05855955418bb99302A6CF71aCB8), fifty_million, ICO_END - block.timestamp + one_year * 4);
1592 
1593 		// store the bridge funds (all preminted)
1594 		_mint(address(0x7E097A68c0C4139f271912789d10062441017ee6), 125000000 * pow);
1595 
1596 
1597 		//////////////////////////////
1598 		//							//
1599 		// donations locked as devs //
1600 		//							//
1601 		//////////////////////////////
1602 		// donations from ebalo
1603 
1604 		_mint(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow);
1605 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year);
1606 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 2);
1607 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 3);
1608 		insertLock(address(0x1513A2c5ebb821080EF7F34DA0EeD06Efb3e5d77), 40000 * pow, ICO_END - block.timestamp + one_year * 4);
1609 
1610 		_mint(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow);
1611 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year);
1612 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 2);
1613 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 3);
1614 		insertLock(address(0xB591244190BF1bE60eA0787C3644cfE12FDc593E), 32000 * pow, ICO_END - block.timestamp + one_year * 4);
1615 
1616 		_mint(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow);
1617 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year);
1618 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 2);
1619 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 3);
1620 		insertLock(address(0xAC363fC2776368181C83ba48C1e839221D5a9b60), 32000 * pow, ICO_END - block.timestamp + one_year * 4);
1621 
1622 		_mint(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow);
1623 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year);
1624 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 2);
1625 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 3);
1626 		insertLock(address(0x2Be310D9bC184a65c9522E790E894A10eA347539), 24000 * pow, ICO_END - block.timestamp + one_year * 4);
1627 
1628 		_mint(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow);
1629 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year);
1630 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 2);
1631 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 3);
1632 		insertLock(address(0x4efA9e79880a604E44Fd90B8FE13aAAFD3fCDB77), 24000 * pow, ICO_END - block.timestamp + one_year * 4);
1633 
1634 		_mint(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow);
1635 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year);
1636 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
1637 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
1638 		insertLock(address(0x6dC6E1Db441c606Ad8557d113e8101fCe10fB44e), 20000 * pow, ICO_END - block.timestamp + one_year * 4);
1639 
1640 		_mint(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow);
1641 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year);
1642 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
1643 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
1644 		insertLock(address(0xCF29334DC2a09C42430b752978cCE7BD8cbC8112), 20000 * pow, ICO_END - block.timestamp + one_year * 4);
1645 
1646 		_mint(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow);
1647 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year);
1648 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 2);
1649 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 3);
1650 		insertLock(address(0xe64352760D6D80e0002f0c0FfE1353fb905bC99C), 8000 * pow, ICO_END - block.timestamp + one_year * 4);
1651 
1652 		// donations from rg
1653 
1654 		_mint(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow);
1655 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year);
1656 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 2);
1657 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 3);
1658 		insertLock(address(0x01ADD5D56e779183F3B52351E2145D1C4Ef4f896), 2000000 * pow, ICO_END - block.timestamp + one_year * 4);
1659 
1660 		_mint(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow);
1661 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year);
1662 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 2);
1663 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 3);
1664 		insertLock(address(0x6EF4651B5fCc6531C8f25eB1bd9af86923Cb86cb), 50000 * pow, ICO_END - block.timestamp + one_year * 4);
1665 
1666 		_mint(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow);
1667 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year);
1668 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
1669 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
1670 		insertLock(address(0x0C25906Ec039F2073E585D26991AE613544a26E0), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
1671 
1672 		_mint(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow);
1673 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year);
1674 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
1675 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
1676 		insertLock(address(0x15939079E39A960D8077d6fEbb92664252a2b7B8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
1677 
1678 		_mint(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow);
1679 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year);
1680 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
1681 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
1682 		insertLock(address(0x485732157D0aa400081251D53c390a5921bFF0A8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
1683 
1684 		_mint(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow);
1685 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year);
1686 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
1687 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
1688 		insertLock(address(0xD2fb1d3cc0bbE8A29bC391Ca435e544d781EA5a7), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
1689 
1690 		_mint(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow);
1691 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year);
1692 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 2);
1693 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 3);
1694 		insertLock(address(0x319B8D649890490Ab22C9cE8ae7ea2e0Cc61a3f8), 30000 * pow, ICO_END - block.timestamp + one_year * 4);
1695 
1696 		// donations from wg
1697 
1698 		_mint(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow);
1699 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year);
1700 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 2);
1701 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 3);
1702 		insertLock(address(0x1b314dcA8Cc5BcA109dFb80bd91f647A3cD62f28), 2400000 * pow, ICO_END - block.timestamp + one_year * 4);
1703 
1704 		_mint(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow);
1705 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year);
1706 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 2);
1707 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 3);
1708 		insertLock(address(0x435298a529750E8A65bF2589D3F41c59bCB3a274), 80000 * pow, ICO_END - block.timestamp + one_year * 4);
1709 
1710 		_mint(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow);
1711 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year);
1712 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 2);
1713 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 3);
1714 		insertLock(address(0xEe72d0857201bdc932B256A165b9c4e0C8ECF055), 80000 * pow, ICO_END - block.timestamp + one_year * 4);
1715 
1716 		_mint(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow);
1717 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year);
1718 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 2);
1719 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 3);
1720 		insertLock(address(0x891539D631d4ed5E401aFa54Cc4b3197BEd73Aae), 20000 * pow, ICO_END - block.timestamp + one_year * 4);
1721 
1722 		_mint(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow);
1723 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year);
1724 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 2);
1725 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 3);
1726 		insertLock(address(0x382be12c3632Fb45347f1126361Ab94dbd88C5E1), 10000 * pow, ICO_END - block.timestamp + one_year * 4);
1727 
1728 		_mint(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow);
1729 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year);
1730 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
1731 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
1732 		insertLock(address(0xB40D8A30E5215DA89490D0209FEc3e6C9008fd80), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
1733 
1734 		_mint(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow);
1735 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year);
1736 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
1737 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
1738 		insertLock(address(0x91A6FfB93Ae9b7F4009978c92259b51DB1814f75), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
1739 
1740 		_mint(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow);
1741 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year);
1742 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
1743 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
1744 		insertLock(address(0x30817A8e6Dc225B89c5670BCc5a9a66f987b7F04), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
1745 
1746 		_mint(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow);
1747 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year);
1748 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
1749 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
1750 		insertLock(address(0x70adD435e8c9f76a263B161863d4F1f6cc1F055a), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
1751 
1752 		_mint(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow);
1753 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year);
1754 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 2);
1755 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 3);
1756 		insertLock(address(0xF40Fccc4fefd2243Cf517ad428661963EA19866F), 2000 * pow, ICO_END - block.timestamp + one_year * 4);
1757     }
1758 
1759     /**
1760      * @dev See {ERC20-_mint}.
1761      */
1762     function _mint(address account, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
1763         ERC20Capped._mint(account, amount);
1764     }
1765 
1766     /**
1767      * Lock the bought amount:
1768      *  - 10% released immediately
1769      *  - 15% released after 3 months
1770      *  - 25% released after 9 month (every 6 months starting from the third)
1771      *  - 25% released after 15 month (every 6 months starting from the third)
1772      *  - 25% released after 21 month (every 6 months starting from the third)
1773      */
1774     function saleLock(address account, uint256 _amount) public onlyRole(CROWDSALE_ROLE) {
1775         emit Bought(account, _amount);
1776         
1777         // immediately release the 10% of the bought amount
1778         uint256 immediately_released = _amount / 10; // * 10 / 100 = / 10
1779 
1780         // 15% released after 3 months
1781         uint256 m3_release = _amount * 15 / 100; 
1782 
1783         // 25% released after 9 months
1784         uint256 m9_release = _amount * 25 / 100; 
1785         
1786         // 25% released after 15 months
1787         uint256 m15_release = _amount * 25 / 100; 
1788         
1789         // 25% released after 21 months
1790         uint256 m21_release = _amount - (immediately_released + m3_release + m9_release + m15_release); 
1791 
1792         uint256 locked_amount = m3_release + m9_release + m15_release + m21_release;
1793 
1794         // update the counter
1795         total_locked_amount += locked_amount;
1796 
1797         Locks memory lock_m = Locks({
1798             locked: m3_release,
1799             release_time: block.timestamp + 7776000,    // 60s * 60m * 24h * 90d
1800             released: false
1801         }); 
1802 		_locks[account].push(lock_m);
1803 
1804 		lock_m.release_time = block.timestamp + 23328000; // 60s * 60m * 24h * 270d
1805 		lock_m.locked = m9_release;
1806 		_locks[account].push(lock_m);
1807 
1808 		lock_m.release_time = block.timestamp + 38880000; // 60s * 60m * 24h * 450d
1809 		lock_m.locked = m15_release;
1810 		_locks[account].push(lock_m);
1811 
1812 		lock_m.release_time = block.timestamp + 54432000; // 60s * 60m * 24h * 630d
1813 		lock_m.locked = m21_release;
1814 		_locks[account].push(lock_m);
1815 
1816         emit Locked(account, locked_amount);
1817 
1818         _mint(account, immediately_released);
1819         emit Released(account, immediately_released);
1820     }
1821 
1822 	function burnUnsold(uint256 _amount) public onlyRole(CROWDSALE_ROLE) {
1823 		_mint(address(0), _amount);
1824 	}
1825 
1826 	/**
1827 	 * Lock the provided amount of MELD for "_relative_release_time" seconds starting from now
1828 	 * NOTE: This method is capped 
1829 	 * NOTE: time definition in the locks is relative!
1830 	 */
1831     function insertLock(address account, uint256 _amount, uint256 _relative_release_time) public onlyRole(DEFAULT_ADMIN_ROLE) {
1832 		require(totalSupply() + total_locked_amount + _amount <= cap(), "Unable to lock the defined amount, cap exceeded");
1833 		Locks memory lock_ = Locks({
1834             locked: _amount,
1835             release_time: block.timestamp + _relative_release_time,
1836             released: false
1837         }); 
1838 		_locks[account].push(lock_);
1839 
1840 		total_locked_amount += _amount;
1841 
1842 		emit Locked(account, _amount);
1843     }
1844 
1845 	/**
1846 	 * Insert an array of locks for the provided account
1847 	 * NOTE: time definition in the locks is relative!
1848 	 */
1849     function batchInsertLock(address account, uint256[] memory _amounts, uint256[] memory _relative_release_time) public onlyRole(DEFAULT_ADMIN_ROLE) {
1850         require(_amounts.length == _relative_release_time.length, "Array with different sizes provided");
1851 		for(uint256 i = 0; i < _amounts.length; i++) {
1852             insertLock(account, _amounts[i], _relative_release_time[i]);
1853         }
1854     }
1855 
1856 	/**
1857 	 * Retrieve the locks state for the account
1858 	 */
1859     function locksOf(address account) public view returns(Locks[] memory) {
1860         return _locks[account];
1861     }
1862 
1863 	/**
1864 	 * Get the number of locks for an account
1865 	 */
1866     function getLockNumber(address account) public view returns(uint256) {
1867         return _locks[account].length;
1868     }
1869 
1870 	/**
1871 	 * Release (mint) the amount of token locked
1872 	 */
1873     function release(uint256 lock_id) public {
1874         require(_locks[msg.sender].length > 0, "No locks found for your account");
1875         require(_locks[msg.sender].length -1 >= lock_id, "Lock index too high");
1876 		require(!_locks[msg.sender][lock_id].released, "Lock already released");
1877 		require(block.timestamp > _locks[msg.sender][lock_id].release_time, "Lock not yet ready to be released");
1878 
1879 		// refresh the amount of tokens locked
1880 		total_locked_amount -= _locks[msg.sender][lock_id].locked;
1881 
1882 		// mark the lock as realeased
1883 		_locks[msg.sender][lock_id].released = true;
1884 
1885 		// mint the tokens to the sender
1886 		_mint(msg.sender, _locks[msg.sender][lock_id].locked);
1887 		emit Released(msg.sender, _locks[msg.sender][lock_id].locked);
1888     }
1889 }