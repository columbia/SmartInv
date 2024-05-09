1 // File: @openzeppelin/contracts/access/IAccessControl.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev External interface of AccessControl declared to support ERC165 detection.
10  */
11 interface IAccessControl {
12     /**
13      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
14      *
15      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
16      * {RoleAdminChanged} not being emitted signaling this.
17      *
18      * _Available since v3.1._
19      */
20     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
21 
22     /**
23      * @dev Emitted when `account` is granted `role`.
24      *
25      * `sender` is the account that originated the contract call, an admin role
26      * bearer except when using {AccessControl-_setupRole}.
27      */
28     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
29 
30     /**
31      * @dev Emitted when `account` is revoked `role`.
32      *
33      * `sender` is the account that originated the contract call:
34      *   - if using `revokeRole`, it is the admin role bearer
35      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
36      */
37     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
38 
39     /**
40      * @dev Returns `true` if `account` has been granted `role`.
41      */
42     function hasRole(bytes32 role, address account) external view returns (bool);
43 
44     /**
45      * @dev Returns the admin role that controls `role`. See {grantRole} and
46      * {revokeRole}.
47      *
48      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
49      */
50     function getRoleAdmin(bytes32 role) external view returns (bytes32);
51 
52     /**
53      * @dev Grants `role` to `account`.
54      *
55      * If `account` had not been already granted `role`, emits a {RoleGranted}
56      * event.
57      *
58      * Requirements:
59      *
60      * - the caller must have ``role``'s admin role.
61      */
62     function grantRole(bytes32 role, address account) external;
63 
64     /**
65      * @dev Revokes `role` from `account`.
66      *
67      * If `account` had been granted `role`, emits a {RoleRevoked} event.
68      *
69      * Requirements:
70      *
71      * - the caller must have ``role``'s admin role.
72      */
73     function revokeRole(bytes32 role, address account) external;
74 
75     /**
76      * @dev Revokes `role` from the calling account.
77      *
78      * Roles are often managed via {grantRole} and {revokeRole}: this function's
79      * purpose is to provide a mechanism for accounts to lose their privileges
80      * if they are compromised (such as when a trusted device is misplaced).
81      *
82      * If the calling account had been granted `role`, emits a {RoleRevoked}
83      * event.
84      *
85      * Requirements:
86      *
87      * - the caller must be `account`.
88      */
89     function renounceRole(bytes32 role, address account) external;
90 }
91 
92 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
93 
94 
95 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Contract module that helps prevent reentrant calls to a function.
101  *
102  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
103  * available, which can be applied to functions to make sure there are no nested
104  * (reentrant) calls to them.
105  *
106  * Note that because there is a single `nonReentrant` guard, functions marked as
107  * `nonReentrant` may not call one another. This can be worked around by making
108  * those functions `private`, and then adding `external` `nonReentrant` entry
109  * points to them.
110  *
111  * TIP: If you would like to learn more about reentrancy and alternative ways
112  * to protect against it, check out our blog post
113  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
114  */
115 abstract contract ReentrancyGuard {
116     // Booleans are more expensive than uint256 or any type that takes up a full
117     // word because each write operation emits an extra SLOAD to first read the
118     // slot's contents, replace the bits taken up by the boolean, and then write
119     // back. This is the compiler's defense against contract upgrades and
120     // pointer aliasing, and it cannot be disabled.
121 
122     // The values being non-zero value makes deployment a bit more expensive,
123     // but in exchange the refund on every call to nonReentrant will be lower in
124     // amount. Since refunds are capped to a percentage of the total
125     // transaction's gas, it is best to keep them low in cases like this one, to
126     // increase the likelihood of the full refund coming into effect.
127     uint256 private constant _NOT_ENTERED = 1;
128     uint256 private constant _ENTERED = 2;
129 
130     uint256 private _status;
131 
132     constructor() {
133         _status = _NOT_ENTERED;
134     }
135 
136     /**
137      * @dev Prevents a contract from calling itself, directly or indirectly.
138      * Calling a `nonReentrant` function from another `nonReentrant`
139      * function is not supported. It is possible to prevent this from happening
140      * by making the `nonReentrant` function external, and making it call a
141      * `private` function that does the actual work.
142      */
143     modifier nonReentrant() {
144         // On the first call to nonReentrant, _notEntered will be true
145         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
146 
147         // Any calls to nonReentrant after this point will fail
148         _status = _ENTERED;
149 
150         _;
151 
152         // By storing the original value once again, a refund is triggered (see
153         // https://eips.ethereum.org/EIPS/eip-2200)
154         _status = _NOT_ENTERED;
155     }
156 }
157 
158 // File: @openzeppelin/contracts/utils/Strings.sol
159 
160 
161 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
162 
163 pragma solidity ^0.8.0;
164 
165 /**
166  * @dev String operations.
167  */
168 library Strings {
169     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
170 
171     /**
172      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
173      */
174     function toString(uint256 value) internal pure returns (string memory) {
175         // Inspired by OraclizeAPI's implementation - MIT licence
176         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
177 
178         if (value == 0) {
179             return "0";
180         }
181         uint256 temp = value;
182         uint256 digits;
183         while (temp != 0) {
184             digits++;
185             temp /= 10;
186         }
187         bytes memory buffer = new bytes(digits);
188         while (value != 0) {
189             digits -= 1;
190             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
191             value /= 10;
192         }
193         return string(buffer);
194     }
195 
196     /**
197      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
198      */
199     function toHexString(uint256 value) internal pure returns (string memory) {
200         if (value == 0) {
201             return "0x00";
202         }
203         uint256 temp = value;
204         uint256 length = 0;
205         while (temp != 0) {
206             length++;
207             temp >>= 8;
208         }
209         return toHexString(value, length);
210     }
211 
212     /**
213      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
214      */
215     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
216         bytes memory buffer = new bytes(2 * length + 2);
217         buffer[0] = "0";
218         buffer[1] = "x";
219         for (uint256 i = 2 * length + 1; i > 1; --i) {
220             buffer[i] = _HEX_SYMBOLS[value & 0xf];
221             value >>= 4;
222         }
223         require(value == 0, "Strings: hex length insufficient");
224         return string(buffer);
225     }
226 }
227 
228 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
229 
230 
231 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
232 
233 pragma solidity ^0.8.0;
234 
235 
236 /**
237  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
238  *
239  * These functions can be used to verify that a message was signed by the holder
240  * of the private keys of a given address.
241  */
242 library ECDSA {
243     enum RecoverError {
244         NoError,
245         InvalidSignature,
246         InvalidSignatureLength,
247         InvalidSignatureS,
248         InvalidSignatureV
249     }
250 
251     function _throwError(RecoverError error) private pure {
252         if (error == RecoverError.NoError) {
253             return; // no error: do nothing
254         } else if (error == RecoverError.InvalidSignature) {
255             revert("ECDSA: invalid signature");
256         } else if (error == RecoverError.InvalidSignatureLength) {
257             revert("ECDSA: invalid signature length");
258         } else if (error == RecoverError.InvalidSignatureS) {
259             revert("ECDSA: invalid signature 's' value");
260         } else if (error == RecoverError.InvalidSignatureV) {
261             revert("ECDSA: invalid signature 'v' value");
262         }
263     }
264 
265     /**
266      * @dev Returns the address that signed a hashed message (`hash`) with
267      * `signature` or error string. This address can then be used for verification purposes.
268      *
269      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
270      * this function rejects them by requiring the `s` value to be in the lower
271      * half order, and the `v` value to be either 27 or 28.
272      *
273      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
274      * verification to be secure: it is possible to craft signatures that
275      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
276      * this is by receiving a hash of the original message (which may otherwise
277      * be too long), and then calling {toEthSignedMessageHash} on it.
278      *
279      * Documentation for signature generation:
280      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
281      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
282      *
283      * _Available since v4.3._
284      */
285     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
286         // Check the signature length
287         // - case 65: r,s,v signature (standard)
288         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
289         if (signature.length == 65) {
290             bytes32 r;
291             bytes32 s;
292             uint8 v;
293             // ecrecover takes the signature parameters, and the only way to get them
294             // currently is to use assembly.
295             assembly {
296                 r := mload(add(signature, 0x20))
297                 s := mload(add(signature, 0x40))
298                 v := byte(0, mload(add(signature, 0x60)))
299             }
300             return tryRecover(hash, v, r, s);
301         } else if (signature.length == 64) {
302             bytes32 r;
303             bytes32 vs;
304             // ecrecover takes the signature parameters, and the only way to get them
305             // currently is to use assembly.
306             assembly {
307                 r := mload(add(signature, 0x20))
308                 vs := mload(add(signature, 0x40))
309             }
310             return tryRecover(hash, r, vs);
311         } else {
312             return (address(0), RecoverError.InvalidSignatureLength);
313         }
314     }
315 
316     /**
317      * @dev Returns the address that signed a hashed message (`hash`) with
318      * `signature`. This address can then be used for verification purposes.
319      *
320      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
321      * this function rejects them by requiring the `s` value to be in the lower
322      * half order, and the `v` value to be either 27 or 28.
323      *
324      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
325      * verification to be secure: it is possible to craft signatures that
326      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
327      * this is by receiving a hash of the original message (which may otherwise
328      * be too long), and then calling {toEthSignedMessageHash} on it.
329      */
330     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
331         (address recovered, RecoverError error) = tryRecover(hash, signature);
332         _throwError(error);
333         return recovered;
334     }
335 
336     /**
337      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
338      *
339      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
340      *
341      * _Available since v4.3._
342      */
343     function tryRecover(
344         bytes32 hash,
345         bytes32 r,
346         bytes32 vs
347     ) internal pure returns (address, RecoverError) {
348         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
349         uint8 v = uint8((uint256(vs) >> 255) + 27);
350         return tryRecover(hash, v, r, s);
351     }
352 
353     /**
354      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
355      *
356      * _Available since v4.2._
357      */
358     function recover(
359         bytes32 hash,
360         bytes32 r,
361         bytes32 vs
362     ) internal pure returns (address) {
363         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
364         _throwError(error);
365         return recovered;
366     }
367 
368     /**
369      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
370      * `r` and `s` signature fields separately.
371      *
372      * _Available since v4.3._
373      */
374     function tryRecover(
375         bytes32 hash,
376         uint8 v,
377         bytes32 r,
378         bytes32 s
379     ) internal pure returns (address, RecoverError) {
380         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
381         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
382         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
383         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
384         //
385         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
386         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
387         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
388         // these malleable signatures as well.
389         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
390             return (address(0), RecoverError.InvalidSignatureS);
391         }
392         if (v != 27 && v != 28) {
393             return (address(0), RecoverError.InvalidSignatureV);
394         }
395 
396         // If the signature is valid (and not malleable), return the signer address
397         address signer = ecrecover(hash, v, r, s);
398         if (signer == address(0)) {
399             return (address(0), RecoverError.InvalidSignature);
400         }
401 
402         return (signer, RecoverError.NoError);
403     }
404 
405     /**
406      * @dev Overload of {ECDSA-recover} that receives the `v`,
407      * `r` and `s` signature fields separately.
408      */
409     function recover(
410         bytes32 hash,
411         uint8 v,
412         bytes32 r,
413         bytes32 s
414     ) internal pure returns (address) {
415         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
416         _throwError(error);
417         return recovered;
418     }
419 
420     /**
421      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
422      * produces hash corresponding to the one signed with the
423      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
424      * JSON-RPC method as part of EIP-191.
425      *
426      * See {recover}.
427      */
428     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
429         // 32 is the length in bytes of hash,
430         // enforced by the type signature above
431         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
432     }
433 
434     /**
435      * @dev Returns an Ethereum Signed Message, created from `s`. This
436      * produces hash corresponding to the one signed with the
437      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
438      * JSON-RPC method as part of EIP-191.
439      *
440      * See {recover}.
441      */
442     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
443         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
444     }
445 
446     /**
447      * @dev Returns an Ethereum Signed Typed Data, created from a
448      * `domainSeparator` and a `structHash`. This produces hash corresponding
449      * to the one signed with the
450      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
451      * JSON-RPC method as part of EIP-712.
452      *
453      * See {recover}.
454      */
455     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
456         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
457     }
458 }
459 
460 // File: @openzeppelin/contracts/utils/Context.sol
461 
462 
463 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
464 
465 pragma solidity ^0.8.0;
466 
467 /**
468  * @dev Provides information about the current execution context, including the
469  * sender of the transaction and its data. While these are generally available
470  * via msg.sender and msg.data, they should not be accessed in such a direct
471  * manner, since when dealing with meta-transactions the account sending and
472  * paying for execution may not be the actual sender (as far as an application
473  * is concerned).
474  *
475  * This contract is only required for intermediate, library-like contracts.
476  */
477 abstract contract Context {
478     function _msgSender() internal view virtual returns (address) {
479         return msg.sender;
480     }
481 
482     function _msgData() internal view virtual returns (bytes calldata) {
483         return msg.data;
484     }
485 }
486 
487 // File: @openzeppelin/contracts/access/Ownable.sol
488 
489 
490 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
491 
492 pragma solidity ^0.8.0;
493 
494 
495 /**
496  * @dev Contract module which provides a basic access control mechanism, where
497  * there is an account (an owner) that can be granted exclusive access to
498  * specific functions.
499  *
500  * By default, the owner account will be the one that deploys the contract. This
501  * can later be changed with {transferOwnership}.
502  *
503  * This module is used through inheritance. It will make available the modifier
504  * `onlyOwner`, which can be applied to your functions to restrict their use to
505  * the owner.
506  */
507 abstract contract Ownable is Context {
508     address private _owner;
509 
510     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
511 
512     /**
513      * @dev Initializes the contract setting the deployer as the initial owner.
514      */
515     constructor() {
516         _transferOwnership(_msgSender());
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view virtual returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(owner() == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         _transferOwnership(address(0));
543     }
544 
545     /**
546      * @dev Transfers ownership of the contract to a new account (`newOwner`).
547      * Can only be called by the current owner.
548      */
549     function transferOwnership(address newOwner) public virtual onlyOwner {
550         require(newOwner != address(0), "Ownable: new owner is the zero address");
551         _transferOwnership(newOwner);
552     }
553 
554     /**
555      * @dev Transfers ownership of the contract to a new account (`newOwner`).
556      * Internal function without access restriction.
557      */
558     function _transferOwnership(address newOwner) internal virtual {
559         address oldOwner = _owner;
560         _owner = newOwner;
561         emit OwnershipTransferred(oldOwner, newOwner);
562     }
563 }
564 
565 // File: @openzeppelin/contracts/utils/Address.sol
566 
567 
568 // OpenZeppelin Contracts (last updated v4.5.0) (utils/Address.sol)
569 
570 pragma solidity ^0.8.1;
571 
572 /**
573  * @dev Collection of functions related to the address type
574  */
575 library Address {
576     /**
577      * @dev Returns true if `account` is a contract.
578      *
579      * [IMPORTANT]
580      * ====
581      * It is unsafe to assume that an address for which this function returns
582      * false is an externally-owned account (EOA) and not a contract.
583      *
584      * Among others, `isContract` will return false for the following
585      * types of addresses:
586      *
587      *  - an externally-owned account
588      *  - a contract in construction
589      *  - an address where a contract will be created
590      *  - an address where a contract lived, but was destroyed
591      * ====
592      *
593      * [IMPORTANT]
594      * ====
595      * You shouldn't rely on `isContract` to protect against flash loan attacks!
596      *
597      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
598      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
599      * constructor.
600      * ====
601      */
602     function isContract(address account) internal view returns (bool) {
603         // This method relies on extcodesize/address.code.length, which returns 0
604         // for contracts in construction, since the code is only stored at the end
605         // of the constructor execution.
606 
607         return account.code.length > 0;
608     }
609 
610     /**
611      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
612      * `recipient`, forwarding all available gas and reverting on errors.
613      *
614      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
615      * of certain opcodes, possibly making contracts go over the 2300 gas limit
616      * imposed by `transfer`, making them unable to receive funds via
617      * `transfer`. {sendValue} removes this limitation.
618      *
619      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
620      *
621      * IMPORTANT: because control is transferred to `recipient`, care must be
622      * taken to not create reentrancy vulnerabilities. Consider using
623      * {ReentrancyGuard} or the
624      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
625      */
626     function sendValue(address payable recipient, uint256 amount) internal {
627         require(address(this).balance >= amount, "Address: insufficient balance");
628 
629         (bool success, ) = recipient.call{value: amount}("");
630         require(success, "Address: unable to send value, recipient may have reverted");
631     }
632 
633     /**
634      * @dev Performs a Solidity function call using a low level `call`. A
635      * plain `call` is an unsafe replacement for a function call: use this
636      * function instead.
637      *
638      * If `target` reverts with a revert reason, it is bubbled up by this
639      * function (like regular Solidity function calls).
640      *
641      * Returns the raw returned data. To convert to the expected return value,
642      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
643      *
644      * Requirements:
645      *
646      * - `target` must be a contract.
647      * - calling `target` with `data` must not revert.
648      *
649      * _Available since v3.1._
650      */
651     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
652         return functionCall(target, data, "Address: low-level call failed");
653     }
654 
655     /**
656      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
657      * `errorMessage` as a fallback revert reason when `target` reverts.
658      *
659      * _Available since v3.1._
660      */
661     function functionCall(
662         address target,
663         bytes memory data,
664         string memory errorMessage
665     ) internal returns (bytes memory) {
666         return functionCallWithValue(target, data, 0, errorMessage);
667     }
668 
669     /**
670      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
671      * but also transferring `value` wei to `target`.
672      *
673      * Requirements:
674      *
675      * - the calling contract must have an ETH balance of at least `value`.
676      * - the called Solidity function must be `payable`.
677      *
678      * _Available since v3.1._
679      */
680     function functionCallWithValue(
681         address target,
682         bytes memory data,
683         uint256 value
684     ) internal returns (bytes memory) {
685         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
690      * with `errorMessage` as a fallback revert reason when `target` reverts.
691      *
692      * _Available since v3.1._
693      */
694     function functionCallWithValue(
695         address target,
696         bytes memory data,
697         uint256 value,
698         string memory errorMessage
699     ) internal returns (bytes memory) {
700         require(address(this).balance >= value, "Address: insufficient balance for call");
701         require(isContract(target), "Address: call to non-contract");
702 
703         (bool success, bytes memory returndata) = target.call{value: value}(data);
704         return verifyCallResult(success, returndata, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but performing a static call.
710      *
711      * _Available since v3.3._
712      */
713     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
714         return functionStaticCall(target, data, "Address: low-level static call failed");
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
719      * but performing a static call.
720      *
721      * _Available since v3.3._
722      */
723     function functionStaticCall(
724         address target,
725         bytes memory data,
726         string memory errorMessage
727     ) internal view returns (bytes memory) {
728         require(isContract(target), "Address: static call to non-contract");
729 
730         (bool success, bytes memory returndata) = target.staticcall(data);
731         return verifyCallResult(success, returndata, errorMessage);
732     }
733 
734     /**
735      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
736      * but performing a delegate call.
737      *
738      * _Available since v3.4._
739      */
740     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
741         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
746      * but performing a delegate call.
747      *
748      * _Available since v3.4._
749      */
750     function functionDelegateCall(
751         address target,
752         bytes memory data,
753         string memory errorMessage
754     ) internal returns (bytes memory) {
755         require(isContract(target), "Address: delegate call to non-contract");
756 
757         (bool success, bytes memory returndata) = target.delegatecall(data);
758         return verifyCallResult(success, returndata, errorMessage);
759     }
760 
761     /**
762      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
763      * revert reason using the provided one.
764      *
765      * _Available since v4.3._
766      */
767     function verifyCallResult(
768         bool success,
769         bytes memory returndata,
770         string memory errorMessage
771     ) internal pure returns (bytes memory) {
772         if (success) {
773             return returndata;
774         } else {
775             // Look for revert reason and bubble it up if present
776             if (returndata.length > 0) {
777                 // The easiest way to bubble the revert reason is using memory via assembly
778 
779                 assembly {
780                     let returndata_size := mload(returndata)
781                     revert(add(32, returndata), returndata_size)
782                 }
783             } else {
784                 revert(errorMessage);
785             }
786         }
787     }
788 }
789 
790 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
791 
792 
793 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)
794 
795 pragma solidity ^0.8.0;
796 
797 /**
798  * @title ERC721 token receiver interface
799  * @dev Interface for any contract that wants to support safeTransfers
800  * from ERC721 asset contracts.
801  */
802 interface IERC721Receiver {
803     /**
804      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
805      * by `operator` from `from`, this function is called.
806      *
807      * It must return its Solidity selector to confirm the token transfer.
808      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
809      *
810      * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
811      */
812     function onERC721Received(
813         address operator,
814         address from,
815         uint256 tokenId,
816         bytes calldata data
817     ) external returns (bytes4);
818 }
819 
820 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
821 
822 
823 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
824 
825 pragma solidity ^0.8.0;
826 
827 /**
828  * @dev Interface of the ERC165 standard, as defined in the
829  * https://eips.ethereum.org/EIPS/eip-165[EIP].
830  *
831  * Implementers can declare support of contract interfaces, which can then be
832  * queried by others ({ERC165Checker}).
833  *
834  * For an implementation, see {ERC165}.
835  */
836 interface IERC165 {
837     /**
838      * @dev Returns true if this contract implements the interface defined by
839      * `interfaceId`. See the corresponding
840      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
841      * to learn more about how these ids are created.
842      *
843      * This function call must use less than 30 000 gas.
844      */
845     function supportsInterface(bytes4 interfaceId) external view returns (bool);
846 }
847 
848 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
849 
850 
851 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
852 
853 pragma solidity ^0.8.0;
854 
855 
856 /**
857  * @dev Implementation of the {IERC165} interface.
858  *
859  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
860  * for the additional interface id that will be supported. For example:
861  *
862  * ```solidity
863  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
864  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
865  * }
866  * ```
867  *
868  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
869  */
870 abstract contract ERC165 is IERC165 {
871     /**
872      * @dev See {IERC165-supportsInterface}.
873      */
874     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
875         return interfaceId == type(IERC165).interfaceId;
876     }
877 }
878 
879 // File: @openzeppelin/contracts/access/AccessControl.sol
880 
881 
882 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
883 
884 pragma solidity ^0.8.0;
885 
886 
887 
888 
889 
890 /**
891  * @dev Contract module that allows children to implement role-based access
892  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
893  * members except through off-chain means by accessing the contract event logs. Some
894  * applications may benefit from on-chain enumerability, for those cases see
895  * {AccessControlEnumerable}.
896  *
897  * Roles are referred to by their `bytes32` identifier. These should be exposed
898  * in the external API and be unique. The best way to achieve this is by
899  * using `public constant` hash digests:
900  *
901  * ```
902  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
903  * ```
904  *
905  * Roles can be used to represent a set of permissions. To restrict access to a
906  * function call, use {hasRole}:
907  *
908  * ```
909  * function foo() public {
910  *     require(hasRole(MY_ROLE, msg.sender));
911  *     ...
912  * }
913  * ```
914  *
915  * Roles can be granted and revoked dynamically via the {grantRole} and
916  * {revokeRole} functions. Each role has an associated admin role, and only
917  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
918  *
919  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
920  * that only accounts with this role will be able to grant or revoke other
921  * roles. More complex role relationships can be created by using
922  * {_setRoleAdmin}.
923  *
924  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
925  * grant and revoke this role. Extra precautions should be taken to secure
926  * accounts that have been granted it.
927  */
928 abstract contract AccessControl is Context, IAccessControl, ERC165 {
929     struct RoleData {
930         mapping(address => bool) members;
931         bytes32 adminRole;
932     }
933 
934     mapping(bytes32 => RoleData) private _roles;
935 
936     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
937 
938     /**
939      * @dev Modifier that checks that an account has a specific role. Reverts
940      * with a standardized message including the required role.
941      *
942      * The format of the revert reason is given by the following regular expression:
943      *
944      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
945      *
946      * _Available since v4.1._
947      */
948     modifier onlyRole(bytes32 role) {
949         _checkRole(role);
950         _;
951     }
952 
953     /**
954      * @dev See {IERC165-supportsInterface}.
955      */
956     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
957         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
958     }
959 
960     /**
961      * @dev Returns `true` if `account` has been granted `role`.
962      */
963     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
964         return _roles[role].members[account];
965     }
966 
967     /**
968      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
969      * Overriding this function changes the behavior of the {onlyRole} modifier.
970      *
971      * Format of the revert message is described in {_checkRole}.
972      *
973      * _Available since v4.6._
974      */
975     function _checkRole(bytes32 role) internal view virtual {
976         _checkRole(role, _msgSender());
977     }
978 
979     /**
980      * @dev Revert with a standard message if `account` is missing `role`.
981      *
982      * The format of the revert reason is given by the following regular expression:
983      *
984      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
985      */
986     function _checkRole(bytes32 role, address account) internal view virtual {
987         if (!hasRole(role, account)) {
988             revert(
989                 string(
990                     abi.encodePacked(
991                         "AccessControl: account ",
992                         Strings.toHexString(uint160(account), 20),
993                         " is missing role ",
994                         Strings.toHexString(uint256(role), 32)
995                     )
996                 )
997             );
998         }
999     }
1000 
1001     /**
1002      * @dev Returns the admin role that controls `role`. See {grantRole} and
1003      * {revokeRole}.
1004      *
1005      * To change a role's admin, use {_setRoleAdmin}.
1006      */
1007     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
1008         return _roles[role].adminRole;
1009     }
1010 
1011     /**
1012      * @dev Grants `role` to `account`.
1013      *
1014      * If `account` had not been already granted `role`, emits a {RoleGranted}
1015      * event.
1016      *
1017      * Requirements:
1018      *
1019      * - the caller must have ``role``'s admin role.
1020      *
1021      * May emit a {RoleGranted} event.
1022      */
1023     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1024         _grantRole(role, account);
1025     }
1026 
1027     /**
1028      * @dev Revokes `role` from `account`.
1029      *
1030      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1031      *
1032      * Requirements:
1033      *
1034      * - the caller must have ``role``'s admin role.
1035      *
1036      * May emit a {RoleRevoked} event.
1037      */
1038     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
1039         _revokeRole(role, account);
1040     }
1041 
1042     /**
1043      * @dev Revokes `role` from the calling account.
1044      *
1045      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1046      * purpose is to provide a mechanism for accounts to lose their privileges
1047      * if they are compromised (such as when a trusted device is misplaced).
1048      *
1049      * If the calling account had been revoked `role`, emits a {RoleRevoked}
1050      * event.
1051      *
1052      * Requirements:
1053      *
1054      * - the caller must be `account`.
1055      *
1056      * May emit a {RoleRevoked} event.
1057      */
1058     function renounceRole(bytes32 role, address account) public virtual override {
1059         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1060 
1061         _revokeRole(role, account);
1062     }
1063 
1064     /**
1065      * @dev Grants `role` to `account`.
1066      *
1067      * If `account` had not been already granted `role`, emits a {RoleGranted}
1068      * event. Note that unlike {grantRole}, this function doesn't perform any
1069      * checks on the calling account.
1070      *
1071      * May emit a {RoleGranted} event.
1072      *
1073      * [WARNING]
1074      * ====
1075      * This function should only be called from the constructor when setting
1076      * up the initial roles for the system.
1077      *
1078      * Using this function in any other way is effectively circumventing the admin
1079      * system imposed by {AccessControl}.
1080      * ====
1081      *
1082      * NOTE: This function is deprecated in favor of {_grantRole}.
1083      */
1084     function _setupRole(bytes32 role, address account) internal virtual {
1085         _grantRole(role, account);
1086     }
1087 
1088     /**
1089      * @dev Sets `adminRole` as ``role``'s admin role.
1090      *
1091      * Emits a {RoleAdminChanged} event.
1092      */
1093     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1094         bytes32 previousAdminRole = getRoleAdmin(role);
1095         _roles[role].adminRole = adminRole;
1096         emit RoleAdminChanged(role, previousAdminRole, adminRole);
1097     }
1098 
1099     /**
1100      * @dev Grants `role` to `account`.
1101      *
1102      * Internal function without access restriction.
1103      *
1104      * May emit a {RoleGranted} event.
1105      */
1106     function _grantRole(bytes32 role, address account) internal virtual {
1107         if (!hasRole(role, account)) {
1108             _roles[role].members[account] = true;
1109             emit RoleGranted(role, account, _msgSender());
1110         }
1111     }
1112 
1113     /**
1114      * @dev Revokes `role` from `account`.
1115      *
1116      * Internal function without access restriction.
1117      *
1118      * May emit a {RoleRevoked} event.
1119      */
1120     function _revokeRole(bytes32 role, address account) internal virtual {
1121         if (hasRole(role, account)) {
1122             _roles[role].members[account] = false;
1123             emit RoleRevoked(role, account, _msgSender());
1124         }
1125     }
1126 }
1127 
1128 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
1129 
1130 
1131 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721.sol)
1132 
1133 pragma solidity ^0.8.0;
1134 
1135 
1136 /**
1137  * @dev Required interface of an ERC721 compliant contract.
1138  */
1139 interface IERC721 is IERC165 {
1140     /**
1141      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1142      */
1143     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1144 
1145     /**
1146      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1147      */
1148     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1149 
1150     /**
1151      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
1152      */
1153     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1154 
1155     /**
1156      * @dev Returns the number of tokens in ``owner``'s account.
1157      */
1158     function balanceOf(address owner) external view returns (uint256 balance);
1159 
1160     /**
1161      * @dev Returns the owner of the `tokenId` token.
1162      *
1163      * Requirements:
1164      *
1165      * - `tokenId` must exist.
1166      */
1167     function ownerOf(uint256 tokenId) external view returns (address owner);
1168 
1169     /**
1170      * @dev Safely transfers `tokenId` token from `from` to `to`.
1171      *
1172      * Requirements:
1173      *
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must exist and be owned by `from`.
1177      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1178      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1179      *
1180      * Emits a {Transfer} event.
1181      */
1182     function safeTransferFrom(
1183         address from,
1184         address to,
1185         uint256 tokenId,
1186         bytes calldata data
1187     ) external;
1188 
1189     /**
1190      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1191      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1192      *
1193      * Requirements:
1194      *
1195      * - `from` cannot be the zero address.
1196      * - `to` cannot be the zero address.
1197      * - `tokenId` token must exist and be owned by `from`.
1198      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
1199      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1200      *
1201      * Emits a {Transfer} event.
1202      */
1203     function safeTransferFrom(
1204         address from,
1205         address to,
1206         uint256 tokenId
1207     ) external;
1208 
1209     /**
1210      * @dev Transfers `tokenId` token from `from` to `to`.
1211      *
1212      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
1213      *
1214      * Requirements:
1215      *
1216      * - `from` cannot be the zero address.
1217      * - `to` cannot be the zero address.
1218      * - `tokenId` token must be owned by `from`.
1219      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1220      *
1221      * Emits a {Transfer} event.
1222      */
1223     function transferFrom(
1224         address from,
1225         address to,
1226         uint256 tokenId
1227     ) external;
1228 
1229     /**
1230      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1231      * The approval is cleared when the token is transferred.
1232      *
1233      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
1234      *
1235      * Requirements:
1236      *
1237      * - The caller must own the token or be an approved operator.
1238      * - `tokenId` must exist.
1239      *
1240      * Emits an {Approval} event.
1241      */
1242     function approve(address to, uint256 tokenId) external;
1243 
1244     /**
1245      * @dev Approve or remove `operator` as an operator for the caller.
1246      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1247      *
1248      * Requirements:
1249      *
1250      * - The `operator` cannot be the caller.
1251      *
1252      * Emits an {ApprovalForAll} event.
1253      */
1254     function setApprovalForAll(address operator, bool _approved) external;
1255 
1256     /**
1257      * @dev Returns the account approved for `tokenId` token.
1258      *
1259      * Requirements:
1260      *
1261      * - `tokenId` must exist.
1262      */
1263     function getApproved(uint256 tokenId) external view returns (address operator);
1264 
1265     /**
1266      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1267      *
1268      * See {setApprovalForAll}
1269      */
1270     function isApprovedForAll(address owner, address operator) external view returns (bool);
1271 }
1272 
1273 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
1274 
1275 
1276 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
1277 
1278 pragma solidity ^0.8.0;
1279 
1280 
1281 /**
1282  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1283  * @dev See https://eips.ethereum.org/EIPS/eip-721
1284  */
1285 interface IERC721Enumerable is IERC721 {
1286     /**
1287      * @dev Returns the total amount of tokens stored by the contract.
1288      */
1289     function totalSupply() external view returns (uint256);
1290 
1291     /**
1292      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1293      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1294      */
1295     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
1296 
1297     /**
1298      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1299      * Use along with {totalSupply} to enumerate all tokens.
1300      */
1301     function tokenByIndex(uint256 index) external view returns (uint256);
1302 }
1303 
1304 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
1305 
1306 
1307 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Metadata.sol)
1308 
1309 pragma solidity ^0.8.0;
1310 
1311 
1312 /**
1313  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
1314  * @dev See https://eips.ethereum.org/EIPS/eip-721
1315  */
1316 interface IERC721Metadata is IERC721 {
1317     /**
1318      * @dev Returns the token collection name.
1319      */
1320     function name() external view returns (string memory);
1321 
1322     /**
1323      * @dev Returns the token collection symbol.
1324      */
1325     function symbol() external view returns (string memory);
1326 
1327     /**
1328      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1329      */
1330     function tokenURI(uint256 tokenId) external view returns (string memory);
1331 }
1332 
1333 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1334 
1335 
1336 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/ERC721.sol)
1337 
1338 pragma solidity ^0.8.0;
1339 
1340 
1341 
1342 
1343 
1344 
1345 
1346 
1347 /**
1348  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1349  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1350  * {ERC721Enumerable}.
1351  */
1352 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1353     using Address for address;
1354     using Strings for uint256;
1355 
1356     // Token name
1357     string private _name;
1358 
1359     // Token symbol
1360     string private _symbol;
1361 
1362     // Mapping from token ID to owner address
1363     mapping(uint256 => address) private _owners;
1364 
1365     // Mapping owner address to token count
1366     mapping(address => uint256) private _balances;
1367 
1368     // Mapping from token ID to approved address
1369     mapping(uint256 => address) private _tokenApprovals;
1370 
1371     // Mapping from owner to operator approvals
1372     mapping(address => mapping(address => bool)) private _operatorApprovals;
1373 
1374     /**
1375      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1376      */
1377     constructor(string memory name_, string memory symbol_) {
1378         _name = name_;
1379         _symbol = symbol_;
1380     }
1381 
1382     /**
1383      * @dev See {IERC165-supportsInterface}.
1384      */
1385     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1386         return
1387             interfaceId == type(IERC721).interfaceId ||
1388             interfaceId == type(IERC721Metadata).interfaceId ||
1389             super.supportsInterface(interfaceId);
1390     }
1391 
1392     /**
1393      * @dev See {IERC721-balanceOf}.
1394      */
1395     function balanceOf(address owner) public view virtual override returns (uint256) {
1396         require(owner != address(0), "ERC721: balance query for the zero address");
1397         return _balances[owner];
1398     }
1399 
1400     /**
1401      * @dev See {IERC721-ownerOf}.
1402      */
1403     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1404         address owner = _owners[tokenId];
1405         require(owner != address(0), "ERC721: owner query for nonexistent token");
1406         return owner;
1407     }
1408 
1409     /**
1410      * @dev See {IERC721Metadata-name}.
1411      */
1412     function name() public view virtual override returns (string memory) {
1413         return _name;
1414     }
1415 
1416     /**
1417      * @dev See {IERC721Metadata-symbol}.
1418      */
1419     function symbol() public view virtual override returns (string memory) {
1420         return _symbol;
1421     }
1422 
1423     /**
1424      * @dev See {IERC721Metadata-tokenURI}.
1425      */
1426     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1427         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1428 
1429         string memory baseURI = _baseURI();
1430         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1431     }
1432 
1433     /**
1434      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1435      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1436      * by default, can be overridden in child contracts.
1437      */
1438     function _baseURI() internal view virtual returns (string memory) {
1439         return "";
1440     }
1441 
1442     /**
1443      * @dev See {IERC721-approve}.
1444      */
1445     function approve(address to, uint256 tokenId) public virtual override {
1446         address owner = ERC721.ownerOf(tokenId);
1447         require(to != owner, "ERC721: approval to current owner");
1448 
1449         require(
1450             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1451             "ERC721: approve caller is not owner nor approved for all"
1452         );
1453 
1454         _approve(to, tokenId);
1455     }
1456 
1457     /**
1458      * @dev See {IERC721-getApproved}.
1459      */
1460     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1461         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1462 
1463         return _tokenApprovals[tokenId];
1464     }
1465 
1466     /**
1467      * @dev See {IERC721-setApprovalForAll}.
1468      */
1469     function setApprovalForAll(address operator, bool approved) public virtual override {
1470         _setApprovalForAll(_msgSender(), operator, approved);
1471     }
1472 
1473     /**
1474      * @dev See {IERC721-isApprovedForAll}.
1475      */
1476     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1477         return _operatorApprovals[owner][operator];
1478     }
1479 
1480     /**
1481      * @dev See {IERC721-transferFrom}.
1482      */
1483     function transferFrom(
1484         address from,
1485         address to,
1486         uint256 tokenId
1487     ) public virtual override {
1488         //solhint-disable-next-line max-line-length
1489         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1490 
1491         _transfer(from, to, tokenId);
1492     }
1493 
1494     /**
1495      * @dev See {IERC721-safeTransferFrom}.
1496      */
1497     function safeTransferFrom(
1498         address from,
1499         address to,
1500         uint256 tokenId
1501     ) public virtual override {
1502         safeTransferFrom(from, to, tokenId, "");
1503     }
1504 
1505     /**
1506      * @dev See {IERC721-safeTransferFrom}.
1507      */
1508     function safeTransferFrom(
1509         address from,
1510         address to,
1511         uint256 tokenId,
1512         bytes memory _data
1513     ) public virtual override {
1514         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1515         _safeTransfer(from, to, tokenId, _data);
1516     }
1517 
1518     /**
1519      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1520      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1521      *
1522      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1523      *
1524      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1525      * implement alternative mechanisms to perform token transfer, such as signature-based.
1526      *
1527      * Requirements:
1528      *
1529      * - `from` cannot be the zero address.
1530      * - `to` cannot be the zero address.
1531      * - `tokenId` token must exist and be owned by `from`.
1532      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1533      *
1534      * Emits a {Transfer} event.
1535      */
1536     function _safeTransfer(
1537         address from,
1538         address to,
1539         uint256 tokenId,
1540         bytes memory _data
1541     ) internal virtual {
1542         _transfer(from, to, tokenId);
1543         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1544     }
1545 
1546     /**
1547      * @dev Returns whether `tokenId` exists.
1548      *
1549      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1550      *
1551      * Tokens start existing when they are minted (`_mint`),
1552      * and stop existing when they are burned (`_burn`).
1553      */
1554     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1555         return _owners[tokenId] != address(0);
1556     }
1557 
1558     /**
1559      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1560      *
1561      * Requirements:
1562      *
1563      * - `tokenId` must exist.
1564      */
1565     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1566         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1567         address owner = ERC721.ownerOf(tokenId);
1568         return (spender == owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
1569     }
1570 
1571     /**
1572      * @dev Safely mints `tokenId` and transfers it to `to`.
1573      *
1574      * Requirements:
1575      *
1576      * - `tokenId` must not exist.
1577      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1578      *
1579      * Emits a {Transfer} event.
1580      */
1581     function _safeMint(address to, uint256 tokenId) internal virtual {
1582         _safeMint(to, tokenId, "");
1583     }
1584 
1585     /**
1586      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1587      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1588      */
1589     function _safeMint(
1590         address to,
1591         uint256 tokenId,
1592         bytes memory _data
1593     ) internal virtual {
1594         _mint(to, tokenId);
1595         require(
1596             _checkOnERC721Received(address(0), to, tokenId, _data),
1597             "ERC721: transfer to non ERC721Receiver implementer"
1598         );
1599     }
1600 
1601     /**
1602      * @dev Mints `tokenId` and transfers it to `to`.
1603      *
1604      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1605      *
1606      * Requirements:
1607      *
1608      * - `tokenId` must not exist.
1609      * - `to` cannot be the zero address.
1610      *
1611      * Emits a {Transfer} event.
1612      */
1613     function _mint(address to, uint256 tokenId) internal virtual {
1614         require(to != address(0), "ERC721: mint to the zero address");
1615         require(!_exists(tokenId), "ERC721: token already minted");
1616 
1617         _beforeTokenTransfer(address(0), to, tokenId);
1618 
1619         _balances[to] += 1;
1620         _owners[tokenId] = to;
1621 
1622         emit Transfer(address(0), to, tokenId);
1623 
1624         _afterTokenTransfer(address(0), to, tokenId);
1625     }
1626 
1627     /**
1628      * @dev Destroys `tokenId`.
1629      * The approval is cleared when the token is burned.
1630      *
1631      * Requirements:
1632      *
1633      * - `tokenId` must exist.
1634      *
1635      * Emits a {Transfer} event.
1636      */
1637     function _burn(uint256 tokenId) internal virtual {
1638         address owner = ERC721.ownerOf(tokenId);
1639 
1640         _beforeTokenTransfer(owner, address(0), tokenId);
1641 
1642         // Clear approvals
1643         _approve(address(0), tokenId);
1644 
1645         _balances[owner] -= 1;
1646         delete _owners[tokenId];
1647 
1648         emit Transfer(owner, address(0), tokenId);
1649 
1650         _afterTokenTransfer(owner, address(0), tokenId);
1651     }
1652 
1653     /**
1654      * @dev Transfers `tokenId` from `from` to `to`.
1655      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1656      *
1657      * Requirements:
1658      *
1659      * - `to` cannot be the zero address.
1660      * - `tokenId` token must be owned by `from`.
1661      *
1662      * Emits a {Transfer} event.
1663      */
1664     function _transfer(
1665         address from,
1666         address to,
1667         uint256 tokenId
1668     ) internal virtual {
1669         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
1670         require(to != address(0), "ERC721: transfer to the zero address");
1671 
1672         _beforeTokenTransfer(from, to, tokenId);
1673 
1674         // Clear approvals from the previous owner
1675         _approve(address(0), tokenId);
1676 
1677         _balances[from] -= 1;
1678         _balances[to] += 1;
1679         _owners[tokenId] = to;
1680 
1681         emit Transfer(from, to, tokenId);
1682 
1683         _afterTokenTransfer(from, to, tokenId);
1684     }
1685 
1686     /**
1687      * @dev Approve `to` to operate on `tokenId`
1688      *
1689      * Emits a {Approval} event.
1690      */
1691     function _approve(address to, uint256 tokenId) internal virtual {
1692         _tokenApprovals[tokenId] = to;
1693         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1694     }
1695 
1696     /**
1697      * @dev Approve `operator` to operate on all of `owner` tokens
1698      *
1699      * Emits a {ApprovalForAll} event.
1700      */
1701     function _setApprovalForAll(
1702         address owner,
1703         address operator,
1704         bool approved
1705     ) internal virtual {
1706         require(owner != operator, "ERC721: approve to caller");
1707         _operatorApprovals[owner][operator] = approved;
1708         emit ApprovalForAll(owner, operator, approved);
1709     }
1710 
1711     /**
1712      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1713      * The call is not executed if the target address is not a contract.
1714      *
1715      * @param from address representing the previous owner of the given token ID
1716      * @param to target address that will receive the tokens
1717      * @param tokenId uint256 ID of the token to be transferred
1718      * @param _data bytes optional data to send along with the call
1719      * @return bool whether the call correctly returned the expected magic value
1720      */
1721     function _checkOnERC721Received(
1722         address from,
1723         address to,
1724         uint256 tokenId,
1725         bytes memory _data
1726     ) private returns (bool) {
1727         if (to.isContract()) {
1728             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1729                 return retval == IERC721Receiver.onERC721Received.selector;
1730             } catch (bytes memory reason) {
1731                 if (reason.length == 0) {
1732                     revert("ERC721: transfer to non ERC721Receiver implementer");
1733                 } else {
1734                     assembly {
1735                         revert(add(32, reason), mload(reason))
1736                     }
1737                 }
1738             }
1739         } else {
1740             return true;
1741         }
1742     }
1743 
1744     /**
1745      * @dev Hook that is called before any token transfer. This includes minting
1746      * and burning.
1747      *
1748      * Calling conditions:
1749      *
1750      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1751      * transferred to `to`.
1752      * - When `from` is zero, `tokenId` will be minted for `to`.
1753      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1754      * - `from` and `to` are never both zero.
1755      *
1756      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1757      */
1758     function _beforeTokenTransfer(
1759         address from,
1760         address to,
1761         uint256 tokenId
1762     ) internal virtual {}
1763 
1764     /**
1765      * @dev Hook that is called after any transfer of tokens. This includes
1766      * minting and burning.
1767      *
1768      * Calling conditions:
1769      *
1770      * - when `from` and `to` are both non-zero.
1771      * - `from` and `to` are never both zero.
1772      *
1773      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1774      */
1775     function _afterTokenTransfer(
1776         address from,
1777         address to,
1778         uint256 tokenId
1779     ) internal virtual {}
1780 }
1781 
1782 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1783 
1784 
1785 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/ERC721Enumerable.sol)
1786 
1787 pragma solidity ^0.8.0;
1788 
1789 
1790 
1791 /**
1792  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1793  * enumerability of all the token ids in the contract as well as all token ids owned by each
1794  * account.
1795  */
1796 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1797     // Mapping from owner to list of owned token IDs
1798     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1799 
1800     // Mapping from token ID to index of the owner tokens list
1801     mapping(uint256 => uint256) private _ownedTokensIndex;
1802 
1803     // Array with all token ids, used for enumeration
1804     uint256[] private _allTokens;
1805 
1806     // Mapping from token id to position in the allTokens array
1807     mapping(uint256 => uint256) private _allTokensIndex;
1808 
1809     /**
1810      * @dev See {IERC165-supportsInterface}.
1811      */
1812     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1813         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1814     }
1815 
1816     /**
1817      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1818      */
1819     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1820         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1821         return _ownedTokens[owner][index];
1822     }
1823 
1824     /**
1825      * @dev See {IERC721Enumerable-totalSupply}.
1826      */
1827     function totalSupply() public view virtual override returns (uint256) {
1828         return _allTokens.length;
1829     }
1830 
1831     /**
1832      * @dev See {IERC721Enumerable-tokenByIndex}.
1833      */
1834     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1835         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1836         return _allTokens[index];
1837     }
1838 
1839     /**
1840      * @dev Hook that is called before any token transfer. This includes minting
1841      * and burning.
1842      *
1843      * Calling conditions:
1844      *
1845      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1846      * transferred to `to`.
1847      * - When `from` is zero, `tokenId` will be minted for `to`.
1848      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1849      * - `from` cannot be the zero address.
1850      * - `to` cannot be the zero address.
1851      *
1852      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1853      */
1854     function _beforeTokenTransfer(
1855         address from,
1856         address to,
1857         uint256 tokenId
1858     ) internal virtual override {
1859         super._beforeTokenTransfer(from, to, tokenId);
1860 
1861         if (from == address(0)) {
1862             _addTokenToAllTokensEnumeration(tokenId);
1863         } else if (from != to) {
1864             _removeTokenFromOwnerEnumeration(from, tokenId);
1865         }
1866         if (to == address(0)) {
1867             _removeTokenFromAllTokensEnumeration(tokenId);
1868         } else if (to != from) {
1869             _addTokenToOwnerEnumeration(to, tokenId);
1870         }
1871     }
1872 
1873     /**
1874      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1875      * @param to address representing the new owner of the given token ID
1876      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1877      */
1878     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1879         uint256 length = ERC721.balanceOf(to);
1880         _ownedTokens[to][length] = tokenId;
1881         _ownedTokensIndex[tokenId] = length;
1882     }
1883 
1884     /**
1885      * @dev Private function to add a token to this extension's token tracking data structures.
1886      * @param tokenId uint256 ID of the token to be added to the tokens list
1887      */
1888     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1889         _allTokensIndex[tokenId] = _allTokens.length;
1890         _allTokens.push(tokenId);
1891     }
1892 
1893     /**
1894      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1895      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1896      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1897      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1898      * @param from address representing the previous owner of the given token ID
1899      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1900      */
1901     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1902         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1903         // then delete the last slot (swap and pop).
1904 
1905         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1906         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1907 
1908         // When the token to delete is the last token, the swap operation is unnecessary
1909         if (tokenIndex != lastTokenIndex) {
1910             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1911 
1912             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1913             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1914         }
1915 
1916         // This also deletes the contents at the last position of the array
1917         delete _ownedTokensIndex[tokenId];
1918         delete _ownedTokens[from][lastTokenIndex];
1919     }
1920 
1921     /**
1922      * @dev Private function to remove a token from this extension's token tracking data structures.
1923      * This has O(1) time complexity, but alters the order of the _allTokens array.
1924      * @param tokenId uint256 ID of the token to be removed from the tokens list
1925      */
1926     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1927         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1928         // then delete the last slot (swap and pop).
1929 
1930         uint256 lastTokenIndex = _allTokens.length - 1;
1931         uint256 tokenIndex = _allTokensIndex[tokenId];
1932 
1933         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1934         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1935         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1936         uint256 lastTokenId = _allTokens[lastTokenIndex];
1937 
1938         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1939         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1940 
1941         // This also deletes the contents at the last position of the array
1942         delete _allTokensIndex[tokenId];
1943         _allTokens.pop();
1944     }
1945 }
1946 
1947 // File: finncotton.sol
1948 
1949 
1950 pragma solidity ^0.8.0;  
1951 
1952 
1953 
1954 
1955 
1956 
1957 
1958 error InvalidCall();
1959 
1960 contract FinnCotton is ERC721Enumerable,ReentrancyGuard,AccessControl, Ownable{
1961     using Strings for uint256;
1962     
1963     struct GroupNFT{
1964         uint256 startTokenId;
1965         uint256 endTokenId;
1966         uint256 nextTokenId;
1967         bool isReveal;
1968         bool isPause;
1969         string baseURI;
1970     }
1971 
1972     bytes32 private constant _APPROVED_ROLE = keccak256("APPROVED_ROLE");
1973     
1974     uint256 public collectionSupplies = 10000; 
1975     uint256 public tokenIdPartner; 
1976     
1977     uint256 public cost = 0.06 ether; 
1978     uint256 public whiteListCost = 0.04 ether;  
1979 
1980     address public signer = 0x00A5bAc26C0BE6A598d0E524725C85ad8F188BaF;
1981     address public walletAddress = 0x0b33692475FeE247Aea054c4AB4FCE9BB6E70303;
1982      
1983     mapping(uint256 => string) public partnerNftURIs;   
1984  
1985     uint256 public maxMintPerWallet = 10;
1986     mapping(address => uint256) public walletMints;  
1987     mapping(address => uint256) public freeMints;  
1988     mapping(address => uint256) public whiteListMints;  
1989     bool public freeMintPause  = true;
1990     bool public whiteListPause  = true;
1991     bool public publicPause  = true;  
1992     string private _CONTRACT_URI = "ipfs://bafkreifuckldcrzl7ybek5adwnebufz4y2pn5z5y73v4faymmznyotmely";   
1993 
1994      // ----- Group Ethan -----
1995     // Group ID  : #1
1996     GroupNFT public groupEthan = GroupNFT(1,750,1,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/1.json");  
1997     // ----- Group Ethan -----
1998 
1999     // ----- Group Glide -----
2000     // Group ID  : #2
2001     GroupNFT public groupGlide = GroupNFT(751,2250,751,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/2.json");  
2002     // ----- Group Glide -----
2003     
2004     // ----- Group Raptor -----
2005     // Group ID  : #3
2006     GroupNFT public groupRaptor = GroupNFT(2251,4250,2251,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/3.json");  
2007     // ----- Group Raptor -----
2008 
2009     // ----- Group Strike -----
2010     // Group ID  : #4
2011     GroupNFT public groupStrike = GroupNFT(4251,5750,4251,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/4.json");  
2012     // ----- Group Strike ----- 
2013     
2014     // ----- Group PulseElite -----
2015     // Group ID  : #5
2016     GroupNFT public groupPulseElite = GroupNFT(5751,7750,5751,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/5.json");  
2017     // ----- Group PulseElite -----
2018 
2019     // ----- Group Ignite -----
2020     // Group ID  : #6
2021     GroupNFT public groupIgnite = GroupNFT(7751,9250,7751,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/6.json");  
2022     // ----- Group Ignite -----
2023     
2024     // ----- Group Noah -----
2025     // Group ID  : #7
2026     GroupNFT public groupNoah = GroupNFT(9251,10000,9251,false,true,"ipfs://bafybeibp4er6lk6cvm4jyvla4xicy6sabgthtmvsedtvpn234wobq3w6pa/7.json");  
2027     // ----- Group Noah -----
2028     
2029 
2030     constructor( )  ERC721("Finn Cotton", "FC")   {   
2031         _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
2032         unchecked { tokenIdPartner = collectionSupplies + 1; }    
2033     }
2034     
2035     function contractURI() external view returns(string memory) {
2036         return _CONTRACT_URI;
2037     }
2038 
2039     function isApprovedForAll(
2040         address owner,
2041         address operator
2042     ) public view override(IERC721,ERC721) returns(bool) {
2043         return hasRole(_APPROVED_ROLE, operator) 
2044         || super.isApprovedForAll(owner, operator);
2045     } 
2046     
2047     function mint(uint256 quantity_,uint256 groupId_)public payable nonReentrant{   
2048         require(!publicPause,"PUBLIC_MINT_PAUSED"); 
2049         require(quantity_ > 0,"INVALID_QUANTITY");  
2050         require(msg.value >= cost * quantity_, "INVALID_VALUE");
2051         require(walletMints[msg.sender] + quantity_ <= maxMintPerWallet, "EXCEED_MINT_PER_WALLET");
2052 
2053         _finalMint(quantity_,groupId_,msg.sender); 
2054         unchecked { walletMints[msg.sender] += quantity_; }
2055     }
2056 
2057   
2058     function specialMint(uint256 quantity_,uint256 groupId_,uint256 maxMint,uint256 mintStatus, bytes memory sig_)public payable nonReentrant {  
2059         
2060         bytes32 digest = keccak256(abi.encodePacked(mintStatus, msg.sender, maxMint));
2061         bytes32 message = ECDSA.toEthSignedMessageHash(digest); 
2062         require(ECDSA.recover(message, sig_) == signer, "CONTRACT_MINT_NOT_ALLOWED");     
2063  
2064         // mintStatus : freemint = 1; whitelist = 2  
2065         if(!whiteListPause && mintStatus == 2){
2066             // Whitelist mint
2067             require(msg.value >= whiteListCost * quantity_, "INVALID_VALUE");
2068             require(whiteListMints[msg.sender] + quantity_ <= maxMint, "EXCEED_WHITELIST_MINT"); 
2069         }else if (!freeMintPause && mintStatus == 1){
2070             // Freemint
2071             require(freeMints[msg.sender] + quantity_ <= maxMint, "EXCEED_FREE_MINT"); 
2072         }else{
2073             revert("INVALID_SPECIAL_MINT_1");
2074         }    
2075  
2076         require(quantity_ > 0,"INVALID_QUANTITY");   
2077 
2078         _finalMint(quantity_,groupId_,msg.sender); 
2079         unchecked { walletMints[msg.sender] += quantity_; }
2080         
2081         if(!whiteListPause && mintStatus == 2){
2082             // Whitelist mint
2083             unchecked { whiteListMints[msg.sender] += quantity_; }
2084         }else if (!freeMintPause && mintStatus == 1){
2085             // Freemint
2086             unchecked { freeMints[msg.sender] += quantity_; }
2087         }
2088     }  
2089 
2090     function isOwnsAll(
2091         address owner, 
2092         uint256[] memory tokenIds
2093     ) external view returns(bool) {
2094         for (uint256 i = 0; i < tokenIds.length; i++) {
2095             if (owner != ownerOf(tokenIds[i])) {
2096                 return false;
2097             }
2098         } 
2099         return true;
2100     }
2101 // =============================== START PRIVATE ===============================  
2102 
2103     function _mintGroup(uint256 quantity_,GroupNFT storage group_,address to_)private  { 
2104         GroupNFT storage group = group_;
2105         require(!group.isPause,"GROUP_PAUSE");
2106         
2107         unchecked{
2108             uint256 groupSupplies  = ((group.endTokenId - group.startTokenId) + 1) + (group.startTokenId-1); 
2109             require((group.nextTokenId - 1) + quantity_ <= groupSupplies,"NOT_ENOUGH_SUPPLIES");
2110  
2111             for (uint256 i = 0; i < quantity_; i++) {
2112                 _safeMint(to_, group.nextTokenId);
2113                 group.nextTokenId++;
2114             }  
2115         }
2116     }  
2117      
2118     function _finalMint(uint256 quantity_,uint256 groupId_,address to_)private { 
2119         if(groupId_ == 1){
2120             // Ethan Mint   
2121             _mintGroup(quantity_,groupEthan,to_);  
2122         }else if(groupId_ == 2){
2123             // Glide Mint
2124             _mintGroup(quantity_,groupGlide,to_);
2125         }else if(groupId_ == 3){
2126             // Raptor Mint
2127             _mintGroup(quantity_,groupRaptor,to_);
2128         }else if(groupId_ == 4){
2129             // Strike Mint
2130             _mintGroup(quantity_,groupStrike,to_);
2131         }else if(groupId_ == 5){
2132             // PulseElite Mint
2133             _mintGroup(quantity_,groupPulseElite,to_);
2134         }else if(groupId_ == 6){
2135             // Ignite Mint
2136             _mintGroup(quantity_,groupIgnite,to_);
2137         }else if(groupId_ == 7){
2138             // Noah Mint
2139             _mintGroup(quantity_,groupNoah,to_);
2140         }else{
2141             revert("INVALID_GROUP");
2142         }   
2143     }
2144     
2145 // =============================== END PRIVATE ===============================
2146  
2147 
2148 // =============================== START ONLY OWNER ===============================
2149 
2150     function modifyPartnerNftTokenUri(uint256 tokenId_,string calldata uri_ ) public onlyOwner{
2151         require(bytes(partnerNftURIs[tokenId_]).length > 0,"INVALID_PARTNER_TOKEN_ID"); 
2152         partnerNftURIs[tokenId_] = uri_;
2153     } 
2154 
2155     function partnerNftBatchMint(string[] memory partnerNFTs_) public onlyOwner  { 
2156         require(0 < partnerNFTs_.length, "INVALID_LENGTH");
2157         
2158         unchecked { 
2159             for(uint256 i = 0 ; i < partnerNFTs_.length ;i ++){    
2160                 require(bytes(partnerNFTs_[i]).length > 0,"REQUIRED_URI");   
2161 
2162                 partnerNftURIs[tokenIdPartner] = partnerNFTs_[i];
2163 
2164                 _safeMint(owner(),tokenIdPartner); 
2165                 tokenIdPartner++;  
2166             }
2167         } 
2168     }
2169     
2170     function setPauses(bool publicPause_, bool whiteListPause_,bool freeMintPause_) public onlyOwner{
2171         publicPause = publicPause_;
2172         whiteListPause = whiteListPause_;
2173         freeMintPause = freeMintPause_;
2174     }  
2175 
2176     function modifyGroupPause(uint256 groupId_ ,bool isPause_)public onlyOwner{ 
2177         if(groupId_ == 1){
2178             // Ethan 
2179             groupEthan.isPause = isPause_;
2180         }else if(groupId_ == 2 ){
2181             // Glide  
2182             groupGlide.isPause = isPause_;
2183         }else if(groupId_ == 3 ){
2184             // Raptor  
2185             groupRaptor.isPause = isPause_;
2186         }else if(groupId_ == 4 ){
2187             // Strike  
2188             groupStrike.isPause = isPause_;
2189         }else if(groupId_ == 5 ){
2190             // PulseElite  
2191             groupPulseElite.isPause = isPause_;
2192         }else if(groupId_ == 6 ){
2193             // Ignite  
2194             groupIgnite.isPause = isPause_;
2195         }else if(groupId_ == 7){
2196             // Noah  
2197             groupNoah.isPause = isPause_;
2198         } 
2199     } 
2200 
2201     function modifyGroupRevealBaseURI(uint256 groupId_ ,bool isReveal_,string calldata baseURI_)public onlyOwner{ 
2202         if(groupId_ == 1){
2203             // Ethan 
2204             groupEthan.isReveal = isReveal_;
2205             groupEthan.baseURI = baseURI_;
2206         }else if(groupId_ == 2 ){
2207             // Glide  
2208             groupGlide.isReveal = isReveal_;
2209             groupGlide.baseURI = baseURI_; 
2210         }else if(groupId_ == 3 ){
2211             // Raptor  
2212             groupRaptor.isReveal = isReveal_;
2213             groupRaptor.baseURI = baseURI_;
2214         }else if(groupId_ == 4 ){
2215             // Strike  
2216             groupStrike.isReveal = isReveal_;
2217             groupStrike.baseURI = baseURI_;
2218         }else if(groupId_ == 5 ){
2219             // PulseElite  
2220             groupPulseElite.isReveal = isReveal_;
2221             groupPulseElite.baseURI = baseURI_;
2222         }else if(groupId_ == 6 ){
2223             // Ignite  
2224             groupIgnite.isReveal = isReveal_;
2225             groupIgnite.baseURI = baseURI_;
2226         }else if(groupId_ == 7){
2227             // Noah  
2228             groupNoah.isReveal = isReveal_;
2229             groupNoah.baseURI = baseURI_;
2230         } 
2231     } 
2232 
2233     function modifyGroup(uint256 groupId_ ,uint256 startTokenId_,uint256 endTokenId_,uint256 nextTokenId_)public onlyOwner{ 
2234         if(groupId_ == 1){
2235             // Ethan 
2236             groupEthan.startTokenId = startTokenId_;
2237             groupEthan.endTokenId = endTokenId_;
2238             groupEthan.nextTokenId = nextTokenId_;
2239         }else if(groupId_ == 2 ){
2240             // Glide   
2241             groupGlide.startTokenId = startTokenId_;
2242             groupGlide.endTokenId = endTokenId_;
2243             groupGlide.nextTokenId = nextTokenId_;
2244         }else if(groupId_ == 3 ){
2245             // Raptor   
2246             groupRaptor.startTokenId = startTokenId_;
2247             groupRaptor.endTokenId = endTokenId_;
2248             groupRaptor.nextTokenId = nextTokenId_;
2249         }else if(groupId_ == 4 ){
2250             // Strike   
2251             groupStrike.startTokenId = startTokenId_;
2252             groupStrike.endTokenId = endTokenId_;
2253             groupStrike.nextTokenId = nextTokenId_;
2254         }else if(groupId_ == 5 ){
2255             // PulseElite   
2256             groupPulseElite.startTokenId = startTokenId_;
2257             groupPulseElite.endTokenId = endTokenId_;
2258             groupPulseElite.nextTokenId = nextTokenId_;
2259         }else if(groupId_ == 6 ){
2260             // Ignite   
2261             groupIgnite.startTokenId = startTokenId_;
2262             groupIgnite.endTokenId = endTokenId_;
2263             groupIgnite.nextTokenId = nextTokenId_;
2264         }else if(groupId_ == 7){
2265             // Noah   
2266             groupNoah.startTokenId = startTokenId_;
2267             groupNoah.endTokenId = endTokenId_;
2268             groupNoah.nextTokenId = nextTokenId_;
2269         } 
2270     }  
2271     
2272     function setMaxMintPerWallet(uint256 maxMintPerWallet_)public onlyOwner{
2273         maxMintPerWallet = maxMintPerWallet_;
2274     }
2275 
2276     function setWhiteListCost(uint256 whiteListCost_)public onlyOwner{
2277         whiteListCost = whiteListCost_;
2278     }
2279 
2280     function setCost(uint256 cost_)public onlyOwner{
2281         cost = cost_;
2282     }
2283 
2284     function setSigner(address signer_) public onlyOwner{
2285         signer = signer_;
2286     } 
2287 
2288     function mintOwner(address to_ ,uint256 quantity_,uint256 groupId_)public onlyOwner  nonReentrant{  
2289         require(quantity_ > 0,"INVALID_QUANTITY");    
2290         _finalMint(quantity_,groupId_,to_);
2291     }
2292 
2293     function setWalletAddress(address _walletAddress) external onlyOwner nonReentrant { 
2294         walletAddress = _walletAddress;
2295     }
2296 
2297     function withdraw() external onlyOwner nonReentrant { 
2298         payable(walletAddress).transfer(address(this).balance);
2299     } 
2300     
2301 // =============================== END ONLY OWNER ===============================
2302  
2303     function tokenURI(uint256 tokenId_)  public view override returns(string memory){  
2304         require(_exists(tokenId_), "TOKEN_IS_NOT_EXIST");
2305 
2306         if (bytes(partnerNftURIs[tokenId_]).length > 0) { 
2307             return partnerNftURIs[tokenId_];
2308         }
2309 
2310         bool isReveal = false; 
2311         string memory baseURI;
2312 
2313         if(groupEthan.startTokenId <= tokenId_  && groupEthan.endTokenId>= tokenId_ ){
2314             isReveal = groupEthan.isReveal;
2315             baseURI = groupEthan.baseURI;
2316         }else if(groupGlide.startTokenId <= tokenId_  && groupGlide.endTokenId>= tokenId_ ){
2317             isReveal = groupGlide.isReveal;
2318             baseURI = groupGlide.baseURI;
2319         }else if(groupRaptor.startTokenId <= tokenId_  && groupRaptor.endTokenId>= tokenId_ ){
2320             isReveal = groupRaptor.isReveal;
2321             baseURI = groupRaptor.baseURI;
2322         }else if(groupStrike.startTokenId <= tokenId_  && groupStrike.endTokenId>= tokenId_ ){
2323             isReveal = groupStrike.isReveal;
2324             baseURI = groupStrike.baseURI;
2325         }else if(groupPulseElite.startTokenId <= tokenId_  && groupPulseElite.endTokenId>= tokenId_){
2326             isReveal = groupPulseElite.isReveal;
2327             baseURI = groupPulseElite.baseURI;
2328         }else if(groupIgnite.startTokenId <= tokenId_  && groupIgnite.endTokenId>= tokenId_){
2329             isReveal = groupIgnite.isReveal;
2330             baseURI = groupIgnite.baseURI;
2331         }else if(groupNoah.startTokenId <= tokenId_  && groupNoah.endTokenId>= tokenId_){
2332             isReveal = groupNoah.isReveal;
2333             baseURI = groupNoah.baseURI;
2334         }
2335  
2336         if(isReveal){
2337             return string(
2338                 abi.encodePacked(baseURI, tokenId_.toString(), ".json")
2339             ); 
2340         }else{
2341             return string(
2342                 abi.encodePacked(baseURI)
2343             ); 
2344         } 
2345     }  
2346 
2347     function tokensOfOwner(address _owner) public view returns (uint256[] memory) {
2348         uint256 ownerTokenCount = balanceOf(_owner);
2349         uint256[] memory tokenIds = new uint256[](ownerTokenCount);
2350         for (uint256 i; i < ownerTokenCount; i++) {
2351             tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
2352         }
2353         return tokenIds;
2354     }   
2355     
2356     function setContractURI(string memory _uri) external onlyOwner {
2357         _CONTRACT_URI = _uri;
2358     }
2359     
2360     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl,ERC721Enumerable) returns (bool) { 
2361         return interfaceId == type(IERC721Metadata).interfaceId  
2362         || super.supportsInterface(interfaceId);
2363     }
2364 }