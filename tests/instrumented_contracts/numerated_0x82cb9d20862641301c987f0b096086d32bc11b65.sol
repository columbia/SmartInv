1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.7.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.7;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Tree proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  *
17  * WARNING: You should avoid using leaf values that are 64 bytes long prior to
18  * hashing, or use a hash function other than keccak256 for hashing leaves.
19  * This is because the concatenation of a sorted pair of internal nodes in
20  * the merkle tree could be reinterpreted as a leaf value.
21  */
22 library MerkleProof {
23     /**
24      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
25      * defined by `root`. For this, a `proof` must be provided, containing
26      * sibling hashes on the branch from the leaf to the root of the tree. Each
27      * pair of leaves and each pair of pre-images are assumed to be sorted.
28      */
29     function verify(
30         bytes32[] memory proof,
31         bytes32 root,
32         bytes32 leaf
33     ) internal pure returns (bool) {
34         return processProof(proof, leaf) == root;
35     }
36 
37     /**
38      * @dev Calldata version of {verify}
39      *
40      * _Available since v4.7._
41      */
42     function verifyCalldata(
43         bytes32[] calldata proof,
44         bytes32 root,
45         bytes32 leaf
46     ) internal pure returns (bool) {
47         return processProofCalldata(proof, leaf) == root;
48     }
49 
50     /**
51      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
52      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
53      * hash matches the root of the tree. When processing the proof, the pairs
54      * of leafs & pre-images are assumed to be sorted.
55      *
56      * _Available since v4.4._
57      */
58     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
59         bytes32 computedHash = leaf;
60         for (uint256 i = 0; i < proof.length; i++) {
61             computedHash = _hashPair(computedHash, proof[i]);
62         }
63         return computedHash;
64     }
65 
66     /**
67      * @dev Calldata version of {processProof}
68      *
69      * _Available since v4.7._
70      */
71     function processProofCalldata(bytes32[] calldata proof, bytes32 leaf) internal pure returns (bytes32) {
72         bytes32 computedHash = leaf;
73         for (uint256 i = 0; i < proof.length; i++) {
74             computedHash = _hashPair(computedHash, proof[i]);
75         }
76         return computedHash;
77     }
78 
79     /**
80      * @dev Returns true if the `leaves` can be proved to be a part of a Merkle tree defined by
81      * `root`, according to `proof` and `proofFlags` as described in {processMultiProof}.
82      *
83      * _Available since v4.7._
84      */
85     function multiProofVerify(
86         bytes32[] memory proof,
87         bool[] memory proofFlags,
88         bytes32 root,
89         bytes32[] memory leaves
90     ) internal pure returns (bool) {
91         return processMultiProof(proof, proofFlags, leaves) == root;
92     }
93 
94     /**
95      * @dev Calldata version of {multiProofVerify}
96      *
97      * _Available since v4.7._
98      */
99     function multiProofVerifyCalldata(
100         bytes32[] calldata proof,
101         bool[] calldata proofFlags,
102         bytes32 root,
103         bytes32[] memory leaves
104     ) internal pure returns (bool) {
105         return processMultiProofCalldata(proof, proofFlags, leaves) == root;
106     }
107 
108     /**
109      * @dev Returns the root of a tree reconstructed from `leaves` and the sibling nodes in `proof`,
110      * consuming from one or the other at each step according to the instructions given by
111      * `proofFlags`.
112      *
113      * _Available since v4.7._
114      */
115     function processMultiProof(
116         bytes32[] memory proof,
117         bool[] memory proofFlags,
118         bytes32[] memory leaves
119     ) internal pure returns (bytes32 merkleRoot) {
120         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
121         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
122         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
123         // the merkle tree.
124         uint256 leavesLen = leaves.length;
125         uint256 totalHashes = proofFlags.length;
126 
127         // Check proof validity.
128         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
129 
130         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
131         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
132         bytes32[] memory hashes = new bytes32[](totalHashes);
133         uint256 leafPos = 0;
134         uint256 hashPos = 0;
135         uint256 proofPos = 0;
136         // At each step, we compute the next hash using two values:
137         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
138         //   get the next hash.
139         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
140         //   `proof` array.
141         for (uint256 i = 0; i < totalHashes; i++) {
142             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
143             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
144             hashes[i] = _hashPair(a, b);
145         }
146 
147         if (totalHashes > 0) {
148             return hashes[totalHashes - 1];
149         } else if (leavesLen > 0) {
150             return leaves[0];
151         } else {
152             return proof[0];
153         }
154     }
155 
156     /**
157      * @dev Calldata version of {processMultiProof}
158      *
159      * _Available since v4.7._
160      */
161     function processMultiProofCalldata(
162         bytes32[] calldata proof,
163         bool[] calldata proofFlags,
164         bytes32[] memory leaves
165     ) internal pure returns (bytes32 merkleRoot) {
166         // This function rebuild the root hash by traversing the tree up from the leaves. The root is rebuilt by
167         // consuming and producing values on a queue. The queue starts with the `leaves` array, then goes onto the
168         // `hashes` array. At the end of the process, the last hash in the `hashes` array should contain the root of
169         // the merkle tree.
170         uint256 leavesLen = leaves.length;
171         uint256 totalHashes = proofFlags.length;
172 
173         // Check proof validity.
174         require(leavesLen + proof.length - 1 == totalHashes, "MerkleProof: invalid multiproof");
175 
176         // The xxxPos values are "pointers" to the next value to consume in each array. All accesses are done using
177         // `xxx[xxxPos++]`, which return the current value and increment the pointer, thus mimicking a queue's "pop".
178         bytes32[] memory hashes = new bytes32[](totalHashes);
179         uint256 leafPos = 0;
180         uint256 hashPos = 0;
181         uint256 proofPos = 0;
182         // At each step, we compute the next hash using two values:
183         // - a value from the "main queue". If not all leaves have been consumed, we get the next leaf, otherwise we
184         //   get the next hash.
185         // - depending on the flag, either another value for the "main queue" (merging branches) or an element from the
186         //   `proof` array.
187         for (uint256 i = 0; i < totalHashes; i++) {
188             bytes32 a = leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++];
189             bytes32 b = proofFlags[i] ? leafPos < leavesLen ? leaves[leafPos++] : hashes[hashPos++] : proof[proofPos++];
190             hashes[i] = _hashPair(a, b);
191         }
192 
193         if (totalHashes > 0) {
194             return hashes[totalHashes - 1];
195         } else if (leavesLen > 0) {
196             return leaves[0];
197         } else {
198             return proof[0];
199         }
200     }
201 
202     function _hashPair(bytes32 a, bytes32 b) private pure returns (bytes32) {
203         return a < b ? _efficientHash(a, b) : _efficientHash(b, a);
204     }
205 
206     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
207         /// @solidity memory-safe-assembly
208         assembly {
209             mstore(0x00, a)
210             mstore(0x20, b)
211             value := keccak256(0x00, 0x40)
212         }
213     }
214 }
215 
216 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
217 
218 
219 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
220 
221 
222 /**
223  * @dev Interface of the ERC165 standard, as defined in the
224  * https://eips.ethereum.org/EIPS/eip-165[EIP].
225  *
226  * Implementers can declare support of contract interfaces, which can then be
227  * queried by others ({ERC165Checker}).
228  *
229  * For an implementation, see {ERC165}.
230  */
231 interface IERC165 {
232     /**
233      * @dev Returns true if this contract implements the interface defined by
234      * `interfaceId`. See the corresponding
235      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
236      * to learn more about how these ids are created.
237      *
238      * This function call must use less than 30 000 gas.
239      */
240     function supportsInterface(bytes4 interfaceId) external view returns (bool);
241 }
242 
243 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
244 
245 
246 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
247 
248 
249 
250 /**
251  * @dev Implementation of the {IERC165} interface.
252  *
253  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
254  * for the additional interface id that will be supported. For example:
255  *
256  * ```solidity
257  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
258  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
259  * }
260  * ```
261  *
262  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
263  */
264 abstract contract ERC165 is IERC165 {
265     /**
266      * @dev See {IERC165-supportsInterface}.
267      */
268     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
269         return interfaceId == type(IERC165).interfaceId;
270     }
271 }
272 
273 // File: @openzeppelin/contracts/utils/Strings.sol
274 
275 
276 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
277 
278 
279 /**
280  * @dev String operations.
281  */
282 library Strings {
283     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
284     uint8 private constant _ADDRESS_LENGTH = 20;
285 
286     /**
287      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
288      */
289     function toString(uint256 value) internal pure returns (string memory) {
290         // Inspired by OraclizeAPI's implementation - MIT licence
291         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
292 
293         if (value == 0) {
294             return "0";
295         }
296         uint256 temp = value;
297         uint256 digits;
298         while (temp != 0) {
299             digits++;
300             temp /= 10;
301         }
302         bytes memory buffer = new bytes(digits);
303         while (value != 0) {
304             digits -= 1;
305             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
306             value /= 10;
307         }
308         return string(buffer);
309     }
310 
311     /**
312      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
313      */
314     function toHexString(uint256 value) internal pure returns (string memory) {
315         if (value == 0) {
316             return "0x00";
317         }
318         uint256 temp = value;
319         uint256 length = 0;
320         while (temp != 0) {
321             length++;
322             temp >>= 8;
323         }
324         return toHexString(value, length);
325     }
326 
327     /**
328      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
329      */
330     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
331         bytes memory buffer = new bytes(2 * length + 2);
332         buffer[0] = "0";
333         buffer[1] = "x";
334         for (uint256 i = 2 * length + 1; i > 1; --i) {
335             buffer[i] = _HEX_SYMBOLS[value & 0xf];
336             value >>= 4;
337         }
338         require(value == 0, "Strings: hex length insufficient");
339         return string(buffer);
340     }
341 
342     /**
343      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
344      */
345     function toHexString(address addr) internal pure returns (string memory) {
346         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
347     }
348 }
349 
350 // File: @openzeppelin/contracts/utils/Context.sol
351 
352 
353 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
354 
355 
356 /**
357  * @dev Provides information about the current execution context, including the
358  * sender of the transaction and its data. While these are generally available
359  * via msg.sender and msg.data, they should not be accessed in such a direct
360  * manner, since when dealing with meta-transactions the account sending and
361  * paying for execution may not be the actual sender (as far as an application
362  * is concerned).
363  *
364  * This contract is only required for intermediate, library-like contracts.
365  */
366 abstract contract Context {
367     function _msgSender() internal view virtual returns (address) {
368         return msg.sender;
369     }
370 
371     function _msgData() internal view virtual returns (bytes calldata) {
372         return msg.data;
373     }
374 }
375 
376 // File: @openzeppelin/contracts/access/IAccessControl.sol
377 
378 
379 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
380 
381 
382 /**
383  * @dev External interface of AccessControl declared to support ERC165 detection.
384  */
385 interface IAccessControl {
386     /**
387      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
388      *
389      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
390      * {RoleAdminChanged} not being emitted signaling this.
391      *
392      * _Available since v3.1._
393      */
394     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
395 
396     /**
397      * @dev Emitted when `account` is granted `role`.
398      *
399      * `sender` is the account that originated the contract call, an admin role
400      * bearer except when using {AccessControl-_setupRole}.
401      */
402     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
403 
404     /**
405      * @dev Emitted when `account` is revoked `role`.
406      *
407      * `sender` is the account that originated the contract call:
408      *   - if using `revokeRole`, it is the admin role bearer
409      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
410      */
411     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
412 
413     /**
414      * @dev Returns `true` if `account` has been granted `role`.
415      */
416     function hasRole(bytes32 role, address account) external view returns (bool);
417 
418     /**
419      * @dev Returns the admin role that controls `role`. See {grantRole} and
420      * {revokeRole}.
421      *
422      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
423      */
424     function getRoleAdmin(bytes32 role) external view returns (bytes32);
425 
426     /**
427      * @dev Grants `role` to `account`.
428      *
429      * If `account` had not been already granted `role`, emits a {RoleGranted}
430      * event.
431      *
432      * Requirements:
433      *
434      * - the caller must have ``role``'s admin role.
435      */
436     function grantRole(bytes32 role, address account) external;
437 
438     /**
439      * @dev Revokes `role` from `account`.
440      *
441      * If `account` had been granted `role`, emits a {RoleRevoked} event.
442      *
443      * Requirements:
444      *
445      * - the caller must have ``role``'s admin role.
446      */
447     function revokeRole(bytes32 role, address account) external;
448 
449     /**
450      * @dev Revokes `role` from the calling account.
451      *
452      * Roles are often managed via {grantRole} and {revokeRole}: this function's
453      * purpose is to provide a mechanism for accounts to lose their privileges
454      * if they are compromised (such as when a trusted device is misplaced).
455      *
456      * If the calling account had been granted `role`, emits a {RoleRevoked}
457      * event.
458      *
459      * Requirements:
460      *
461      * - the caller must be `account`.
462      */
463     function renounceRole(bytes32 role, address account) external;
464 }
465 
466 // File: @openzeppelin/contracts/access/AccessControl.sol
467 
468 
469 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
470 
471 
472 
473 
474 
475 
476 /**
477  * @dev Contract module that allows children to implement role-based access
478  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
479  * members except through off-chain means by accessing the contract event logs. Some
480  * applications may benefit from on-chain enumerability, for those cases see
481  * {AccessControlEnumerable}.
482  *
483  * Roles are referred to by their `bytes32` identifier. These should be exposed
484  * in the external API and be unique. The best way to achieve this is by
485  * using `public constant` hash digests:
486  *
487  * ```
488  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
489  * ```
490  *
491  * Roles can be used to represent a set of permissions. To restrict access to a
492  * function call, use {hasRole}:
493  *
494  * ```
495  * function foo() public {
496  *     require(hasRole(MY_ROLE, msg.sender));
497  *     ...
498  * }
499  * ```
500  *
501  * Roles can be granted and revoked dynamically via the {grantRole} and
502  * {revokeRole} functions. Each role has an associated admin role, and only
503  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
504  *
505  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
506  * that only accounts with this role will be able to grant or revoke other
507  * roles. More complex role relationships can be created by using
508  * {_setRoleAdmin}.
509  *
510  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
511  * grant and revoke this role. Extra precautions should be taken to secure
512  * accounts that have been granted it.
513  */
514 abstract contract AccessControl is Context, IAccessControl, ERC165 {
515     struct RoleData {
516         mapping(address => bool) members;
517         bytes32 adminRole;
518     }
519 
520     mapping(bytes32 => RoleData) private _roles;
521 
522     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
523 
524     /**
525      * @dev Modifier that checks that an account has a specific role. Reverts
526      * with a standardized message including the required role.
527      *
528      * The format of the revert reason is given by the following regular expression:
529      *
530      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
531      *
532      * _Available since v4.1._
533      */
534     modifier onlyRole(bytes32 role) {
535         _checkRole(role);
536         _;
537     }
538 
539     /**
540      * @dev See {IERC165-supportsInterface}.
541      */
542     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
543         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
544     }
545 
546     /**
547      * @dev Returns `true` if `account` has been granted `role`.
548      */
549     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
550         return _roles[role].members[account];
551     }
552 
553     /**
554      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
555      * Overriding this function changes the behavior of the {onlyRole} modifier.
556      *
557      * Format of the revert message is described in {_checkRole}.
558      *
559      * _Available since v4.6._
560      */
561     function _checkRole(bytes32 role) internal view virtual {
562         _checkRole(role, _msgSender());
563     }
564 
565     /**
566      * @dev Revert with a standard message if `account` is missing `role`.
567      *
568      * The format of the revert reason is given by the following regular expression:
569      *
570      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
571      */
572     function _checkRole(bytes32 role, address account) internal view virtual {
573         if (!hasRole(role, account)) {
574             revert(
575                 string(
576                     abi.encodePacked(
577                         "AccessControl: account ",
578                         Strings.toHexString(uint160(account), 20),
579                         " is missing role ",
580                         Strings.toHexString(uint256(role), 32)
581                     )
582                 )
583             );
584         }
585     }
586 
587     /**
588      * @dev Returns the admin role that controls `role`. See {grantRole} and
589      * {revokeRole}.
590      *
591      * To change a role's admin, use {_setRoleAdmin}.
592      */
593     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
594         return _roles[role].adminRole;
595     }
596 
597     /**
598      * @dev Grants `role` to `account`.
599      *
600      * If `account` had not been already granted `role`, emits a {RoleGranted}
601      * event.
602      *
603      * Requirements:
604      *
605      * - the caller must have ``role``'s admin role.
606      *
607      * May emit a {RoleGranted} event.
608      */
609     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
610         _grantRole(role, account);
611     }
612 
613     /**
614      * @dev Revokes `role` from `account`.
615      *
616      * If `account` had been granted `role`, emits a {RoleRevoked} event.
617      *
618      * Requirements:
619      *
620      * - the caller must have ``role``'s admin role.
621      *
622      * May emit a {RoleRevoked} event.
623      */
624     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
625         _revokeRole(role, account);
626     }
627 
628     /**
629      * @dev Revokes `role` from the calling account.
630      *
631      * Roles are often managed via {grantRole} and {revokeRole}: this function's
632      * purpose is to provide a mechanism for accounts to lose their privileges
633      * if they are compromised (such as when a trusted device is misplaced).
634      *
635      * If the calling account had been revoked `role`, emits a {RoleRevoked}
636      * event.
637      *
638      * Requirements:
639      *
640      * - the caller must be `account`.
641      *
642      * May emit a {RoleRevoked} event.
643      */
644     function renounceRole(bytes32 role, address account) public virtual override {
645         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
646 
647         _revokeRole(role, account);
648     }
649 
650     /**
651      * @dev Grants `role` to `account`.
652      *
653      * If `account` had not been already granted `role`, emits a {RoleGranted}
654      * event. Note that unlike {grantRole}, this function doesn't perform any
655      * checks on the calling account.
656      *
657      * May emit a {RoleGranted} event.
658      *
659      * [WARNING]
660      * ====
661      * This function should only be called from the constructor when setting
662      * up the initial roles for the system.
663      *
664      * Using this function in any other way is effectively circumventing the admin
665      * system imposed by {AccessControl}.
666      * ====
667      *
668      * NOTE: This function is deprecated in favor of {_grantRole}.
669      */
670     function _setupRole(bytes32 role, address account) internal virtual {
671         _grantRole(role, account);
672     }
673 
674     /**
675      * @dev Sets `adminRole` as ``role``'s admin role.
676      *
677      * Emits a {RoleAdminChanged} event.
678      */
679     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
680         bytes32 previousAdminRole = getRoleAdmin(role);
681         _roles[role].adminRole = adminRole;
682         emit RoleAdminChanged(role, previousAdminRole, adminRole);
683     }
684 
685     /**
686      * @dev Grants `role` to `account`.
687      *
688      * Internal function without access restriction.
689      *
690      * May emit a {RoleGranted} event.
691      */
692     function _grantRole(bytes32 role, address account) internal virtual {
693         if (!hasRole(role, account)) {
694             _roles[role].members[account] = true;
695             emit RoleGranted(role, account, _msgSender());
696         }
697     }
698 
699     /**
700      * @dev Revokes `role` from `account`.
701      *
702      * Internal function without access restriction.
703      *
704      * May emit a {RoleRevoked} event.
705      */
706     function _revokeRole(bytes32 role, address account) internal virtual {
707         if (hasRole(role, account)) {
708             _roles[role].members[account] = false;
709             emit RoleRevoked(role, account, _msgSender());
710         }
711     }
712 }
713 
714 // File: erc721a/contracts/IERC721A.sol
715 
716 
717 // ERC721A Contracts v4.2.0
718 // Creator: Chiru Labs
719 
720 pragma solidity ^0.8.4;
721 
722 /**
723  * @dev Interface of ERC721A.
724  */
725 interface IERC721A {
726     /**
727      * The caller must own the token or be an approved operator.
728      */
729     error ApprovalCallerNotOwnerNorApproved();
730 
731     /**
732      * The token does not exist.
733      */
734     error ApprovalQueryForNonexistentToken();
735 
736     /**
737      * The caller cannot approve to their own address.
738      */
739     error ApproveToCaller();
740 
741     /**
742      * Cannot query the balance for the zero address.
743      */
744     error BalanceQueryForZeroAddress();
745 
746     /**
747      * Cannot mint to the zero address.
748      */
749     error MintToZeroAddress();
750 
751     /**
752      * The quantity of tokens minted must be more than zero.
753      */
754     error MintZeroQuantity();
755 
756     /**
757      * The token does not exist.
758      */
759     error OwnerQueryForNonexistentToken();
760 
761     /**
762      * The caller must own the token or be an approved operator.
763      */
764     error TransferCallerNotOwnerNorApproved();
765 
766     /**
767      * The token must be owned by `from`.
768      */
769     error TransferFromIncorrectOwner();
770 
771     /**
772      * Cannot safely transfer to a contract that does not implement the
773      * ERC721Receiver interface.
774      */
775     error TransferToNonERC721ReceiverImplementer();
776 
777     /**
778      * Cannot transfer to the zero address.
779      */
780     error TransferToZeroAddress();
781 
782     /**
783      * The token does not exist.
784      */
785     error URIQueryForNonexistentToken();
786 
787     /**
788      * The `quantity` minted with ERC2309 exceeds the safety limit.
789      */
790     error MintERC2309QuantityExceedsLimit();
791 
792     /**
793      * The `extraData` cannot be set on an unintialized ownership slot.
794      */
795     error OwnershipNotInitializedForExtraData();
796 
797     // =============================================================
798     //                            STRUCTS
799     // =============================================================
800 
801     struct TokenOwnership {
802         // The address of the owner.
803         address addr;
804         // Stores the start time of ownership with minimal overhead for tokenomics.
805         uint64 startTimestamp;
806         // Whether the token has been burned.
807         bool burned;
808         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
809         uint24 extraData;
810     }
811 
812     // =============================================================
813     //                         TOKEN COUNTERS
814     // =============================================================
815 
816     /**
817      * @dev Returns the total number of tokens in existence.
818      * Burned tokens will reduce the count.
819      * To get the total number of tokens minted, please see {_totalMinted}.
820      */
821     function totalSupply() external view returns (uint256);
822 
823     // =============================================================
824     //                            IERC165
825     // =============================================================
826 
827     /**
828      * @dev Returns true if this contract implements the interface defined by
829      * `interfaceId`. See the corresponding
830      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
831      * to learn more about how these ids are created.
832      *
833      * This function call must use less than 30000 gas.
834      */
835     function supportsInterface(bytes4 interfaceId) external view returns (bool);
836 
837     // =============================================================
838     //                            IERC721
839     // =============================================================
840 
841     /**
842      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
843      */
844     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
845 
846     /**
847      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
848      */
849     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
850 
851     /**
852      * @dev Emitted when `owner` enables or disables
853      * (`approved`) `operator` to manage all of its assets.
854      */
855     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
856 
857     /**
858      * @dev Returns the number of tokens in `owner`'s account.
859      */
860     function balanceOf(address owner) external view returns (uint256 balance);
861 
862     /**
863      * @dev Returns the owner of the `tokenId` token.
864      *
865      * Requirements:
866      *
867      * - `tokenId` must exist.
868      */
869     function ownerOf(uint256 tokenId) external view returns (address owner);
870 
871     /**
872      * @dev Safely transfers `tokenId` token from `from` to `to`,
873      * checking first that contract recipients are aware of the ERC721 protocol
874      * to prevent tokens from being forever locked.
875      *
876      * Requirements:
877      *
878      * - `from` cannot be the zero address.
879      * - `to` cannot be the zero address.
880      * - `tokenId` token must exist and be owned by `from`.
881      * - If the caller is not `from`, it must be have been allowed to move
882      * this token by either {approve} or {setApprovalForAll}.
883      * - If `to` refers to a smart contract, it must implement
884      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
885      *
886      * Emits a {Transfer} event.
887      */
888     function safeTransferFrom(
889         address from,
890         address to,
891         uint256 tokenId,
892         bytes calldata data
893     ) external;
894 
895     /**
896      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
897      */
898     function safeTransferFrom(
899         address from,
900         address to,
901         uint256 tokenId
902     ) external;
903 
904     /**
905      * @dev Transfers `tokenId` from `from` to `to`.
906      *
907      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
908      * whenever possible.
909      *
910      * Requirements:
911      *
912      * - `from` cannot be the zero address.
913      * - `to` cannot be the zero address.
914      * - `tokenId` token must be owned by `from`.
915      * - If the caller is not `from`, it must be approved to move this token
916      * by either {approve} or {setApprovalForAll}.
917      *
918      * Emits a {Transfer} event.
919      */
920     function transferFrom(
921         address from,
922         address to,
923         uint256 tokenId
924     ) external;
925 
926     /**
927      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
928      * The approval is cleared when the token is transferred.
929      *
930      * Only a single account can be approved at a time, so approving the
931      * zero address clears previous approvals.
932      *
933      * Requirements:
934      *
935      * - The caller must own the token or be an approved operator.
936      * - `tokenId` must exist.
937      *
938      * Emits an {Approval} event.
939      */
940     function approve(address to, uint256 tokenId) external;
941 
942     /**
943      * @dev Approve or remove `operator` as an operator for the caller.
944      * Operators can call {transferFrom} or {safeTransferFrom}
945      * for any token owned by the caller.
946      *
947      * Requirements:
948      *
949      * - The `operator` cannot be the caller.
950      *
951      * Emits an {ApprovalForAll} event.
952      */
953     function setApprovalForAll(address operator, bool _approved) external;
954 
955     /**
956      * @dev Returns the account approved for `tokenId` token.
957      *
958      * Requirements:
959      *
960      * - `tokenId` must exist.
961      */
962     function getApproved(uint256 tokenId) external view returns (address operator);
963 
964     /**
965      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
966      *
967      * See {setApprovalForAll}.
968      */
969     function isApprovedForAll(address owner, address operator) external view returns (bool);
970 
971     // =============================================================
972     //                        IERC721Metadata
973     // =============================================================
974 
975     /**
976      * @dev Returns the token collection name.
977      */
978     function name() external view returns (string memory);
979 
980     /**
981      * @dev Returns the token collection symbol.
982      */
983     function symbol() external view returns (string memory);
984 
985     /**
986      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
987      */
988     function tokenURI(uint256 tokenId) external view returns (string memory);
989 
990     // =============================================================
991     //                           IERC2309
992     // =============================================================
993 
994     /**
995      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
996      * (inclusive) is transferred from `from` to `to`, as defined in the
997      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
998      *
999      * See {_mintERC2309} for more details.
1000      */
1001     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1002 }
1003 
1004 // File: erc721a/contracts/ERC721A.sol
1005 
1006 
1007 // ERC721A Contracts v4.2.0
1008 // Creator: Chiru Labs
1009 
1010 pragma solidity ^0.8.4;
1011 
1012 
1013 /**
1014  * @dev Interface of ERC721 token receiver.
1015  */
1016 interface ERC721A__IERC721Receiver {
1017     function onERC721Received(
1018         address operator,
1019         address from,
1020         uint256 tokenId,
1021         bytes calldata data
1022     ) external returns (bytes4);
1023 }
1024 
1025 /**
1026  * @title ERC721A
1027  *
1028  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1029  * Non-Fungible Token Standard, including the Metadata extension.
1030  * Optimized for lower gas during batch mints.
1031  *
1032  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1033  * starting from `_startTokenId()`.
1034  *
1035  * Assumptions:
1036  *
1037  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1038  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1039  */
1040 contract ERC721A is IERC721A {
1041     // Reference type for token approval.
1042     struct TokenApprovalRef {
1043         address value;
1044     }
1045 
1046     // =============================================================
1047     //                           CONSTANTS
1048     // =============================================================
1049 
1050     // Mask of an entry in packed address data.
1051     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1052 
1053     // The bit position of `numberMinted` in packed address data.
1054     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1055 
1056     // The bit position of `numberBurned` in packed address data.
1057     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1058 
1059     // The bit position of `aux` in packed address data.
1060     uint256 private constant _BITPOS_AUX = 192;
1061 
1062     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1063     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1064 
1065     // The bit position of `startTimestamp` in packed ownership.
1066     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1067 
1068     // The bit mask of the `burned` bit in packed ownership.
1069     uint256 private constant _BITMASK_BURNED = 1 << 224;
1070 
1071     // The bit position of the `nextInitialized` bit in packed ownership.
1072     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1073 
1074     // The bit mask of the `nextInitialized` bit in packed ownership.
1075     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1076 
1077     // The bit position of `extraData` in packed ownership.
1078     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1079 
1080     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1081     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1082 
1083     // The mask of the lower 160 bits for addresses.
1084     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1085 
1086     // The maximum `quantity` that can be minted with {_mintERC2309}.
1087     // This limit is to prevent overflows on the address data entries.
1088     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1089     // is required to cause an overflow, which is unrealistic.
1090     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1091 
1092     // The `Transfer` event signature is given by:
1093     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1094     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1095         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1096 
1097     // =============================================================
1098     //                            STORAGE
1099     // =============================================================
1100 
1101     // The next token ID to be minted.
1102     uint256 private _currentIndex;
1103 
1104     // The number of tokens burned.
1105     uint256 private _burnCounter;
1106 
1107     // Token name
1108     string private _name;
1109 
1110     // Token symbol
1111     string private _symbol;
1112 
1113     // Mapping from token ID to ownership details
1114     // An empty struct value does not necessarily mean the token is unowned.
1115     // See {_packedOwnershipOf} implementation for details.
1116     //
1117     // Bits Layout:
1118     // - [0..159]   `addr`
1119     // - [160..223] `startTimestamp`
1120     // - [224]      `burned`
1121     // - [225]      `nextInitialized`
1122     // - [232..255] `extraData`
1123     mapping(uint256 => uint256) private _packedOwnerships;
1124 
1125     // Mapping owner address to address data.
1126     //
1127     // Bits Layout:
1128     // - [0..63]    `balance`
1129     // - [64..127]  `numberMinted`
1130     // - [128..191] `numberBurned`
1131     // - [192..255] `aux`
1132     mapping(address => uint256) private _packedAddressData;
1133 
1134     // Mapping from token ID to approved address.
1135     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1136 
1137     // Mapping from owner to operator approvals
1138     mapping(address => mapping(address => bool)) private _operatorApprovals;
1139 
1140     // =============================================================
1141     //                          CONSTRUCTOR
1142     // =============================================================
1143 
1144     constructor(string memory name_, string memory symbol_) {
1145         _name = name_;
1146         _symbol = symbol_;
1147         _currentIndex = _startTokenId();
1148     }
1149 
1150     // =============================================================
1151     //                   TOKEN COUNTING OPERATIONS
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns the starting token ID.
1156      * To change the starting token ID, please override this function.
1157      */
1158     function _startTokenId() internal view virtual returns (uint256) {
1159         return 0;
1160     }
1161 
1162     /**
1163      * @dev Returns the next token ID to be minted.
1164      */
1165     function _nextTokenId() internal view virtual returns (uint256) {
1166         return _currentIndex;
1167     }
1168 
1169     /**
1170      * @dev Returns the total number of tokens in existence.
1171      * Burned tokens will reduce the count.
1172      * To get the total number of tokens minted, please see {_totalMinted}.
1173      */
1174     function totalSupply() public view virtual override returns (uint256) {
1175         // Counter underflow is impossible as _burnCounter cannot be incremented
1176         // more than `_currentIndex - _startTokenId()` times.
1177         unchecked {
1178             return _currentIndex - _burnCounter - _startTokenId();
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns the total amount of tokens minted in the contract.
1184      */
1185     function _totalMinted() internal view virtual returns (uint256) {
1186         // Counter underflow is impossible as `_currentIndex` does not decrement,
1187         // and it is initialized to `_startTokenId()`.
1188         unchecked {
1189             return _currentIndex - _startTokenId();
1190         }
1191     }
1192 
1193     /**
1194      * @dev Returns the total number of tokens burned.
1195      */
1196     function _totalBurned() internal view virtual returns (uint256) {
1197         return _burnCounter;
1198     }
1199 
1200     // =============================================================
1201     //                    ADDRESS DATA OPERATIONS
1202     // =============================================================
1203 
1204     /**
1205      * @dev Returns the number of tokens in `owner`'s account.
1206      */
1207     function balanceOf(address owner) public view virtual override returns (uint256) {
1208         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1209         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1210     }
1211 
1212     /**
1213      * Returns the number of tokens minted by `owner`.
1214      */
1215     function _numberMinted(address owner) internal view returns (uint256) {
1216         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1217     }
1218 
1219     /**
1220      * Returns the number of tokens burned by or on behalf of `owner`.
1221      */
1222     function _numberBurned(address owner) internal view returns (uint256) {
1223         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1224     }
1225 
1226     /**
1227      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1228      */
1229     function _getAux(address owner) internal view returns (uint64) {
1230         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1231     }
1232 
1233     /**
1234      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1235      * If there are multiple variables, please pack them into a uint64.
1236      */
1237     function _setAux(address owner, uint64 aux) internal virtual {
1238         uint256 packed = _packedAddressData[owner];
1239         uint256 auxCasted;
1240         // Cast `aux` with assembly to avoid redundant masking.
1241         assembly {
1242             auxCasted := aux
1243         }
1244         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1245         _packedAddressData[owner] = packed;
1246     }
1247 
1248     // =============================================================
1249     //                            IERC165
1250     // =============================================================
1251 
1252     /**
1253      * @dev Returns true if this contract implements the interface defined by
1254      * `interfaceId`. See the corresponding
1255      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1256      * to learn more about how these ids are created.
1257      *
1258      * This function call must use less than 30000 gas.
1259      */
1260     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1261         // The interface IDs are constants representing the first 4 bytes
1262         // of the XOR of all function selectors in the interface.
1263         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1264         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1265         return
1266             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1267             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1268             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1269     }
1270 
1271     // =============================================================
1272     //                        IERC721Metadata
1273     // =============================================================
1274 
1275     /**
1276      * @dev Returns the token collection name.
1277      */
1278     function name() public view virtual override returns (string memory) {
1279         return _name;
1280     }
1281 
1282     /**
1283      * @dev Returns the token collection symbol.
1284      */
1285     function symbol() public view virtual override returns (string memory) {
1286         return _symbol;
1287     }
1288 
1289     /**
1290      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1291      */
1292     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1293         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1294 
1295         string memory baseURI = _baseURI();
1296         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1297     }
1298 
1299     /**
1300      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1301      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1302      * by default, it can be overridden in child contracts.
1303      */
1304     function _baseURI() internal view virtual returns (string memory) {
1305         return '';
1306     }
1307 
1308     // =============================================================
1309     //                     OWNERSHIPS OPERATIONS
1310     // =============================================================
1311 
1312     /**
1313      * @dev Returns the owner of the `tokenId` token.
1314      *
1315      * Requirements:
1316      *
1317      * - `tokenId` must exist.
1318      */
1319     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1320         return address(uint160(_packedOwnershipOf(tokenId)));
1321     }
1322 
1323     /**
1324      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1325      * It gradually moves to O(1) as tokens get transferred around over time.
1326      */
1327     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1328         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1329     }
1330 
1331     /**
1332      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1333      */
1334     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1335         return _unpackedOwnership(_packedOwnerships[index]);
1336     }
1337 
1338     /**
1339      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1340      */
1341     function _initializeOwnershipAt(uint256 index) internal virtual {
1342         if (_packedOwnerships[index] == 0) {
1343             _packedOwnerships[index] = _packedOwnershipOf(index);
1344         }
1345     }
1346 
1347     /**
1348      * Returns the packed ownership data of `tokenId`.
1349      */
1350     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1351         uint256 curr = tokenId;
1352 
1353         unchecked {
1354             if (_startTokenId() <= curr)
1355                 if (curr < _currentIndex) {
1356                     uint256 packed = _packedOwnerships[curr];
1357                     // If not burned.
1358                     if (packed & _BITMASK_BURNED == 0) {
1359                         // Invariant:
1360                         // There will always be an initialized ownership slot
1361                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1362                         // before an unintialized ownership slot
1363                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1364                         // Hence, `curr` will not underflow.
1365                         //
1366                         // We can directly compare the packed value.
1367                         // If the address is zero, packed will be zero.
1368                         while (packed == 0) {
1369                             packed = _packedOwnerships[--curr];
1370                         }
1371                         return packed;
1372                     }
1373                 }
1374         }
1375         revert OwnerQueryForNonexistentToken();
1376     }
1377 
1378     /**
1379      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1380      */
1381     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1382         ownership.addr = address(uint160(packed));
1383         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1384         ownership.burned = packed & _BITMASK_BURNED != 0;
1385         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1386     }
1387 
1388     /**
1389      * @dev Packs ownership data into a single uint256.
1390      */
1391     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1392         assembly {
1393             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1394             owner := and(owner, _BITMASK_ADDRESS)
1395             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1396             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1397         }
1398     }
1399 
1400     /**
1401      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1402      */
1403     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1404         // For branchless setting of the `nextInitialized` flag.
1405         assembly {
1406             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1407             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1408         }
1409     }
1410 
1411     // =============================================================
1412     //                      APPROVAL OPERATIONS
1413     // =============================================================
1414 
1415     /**
1416      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1417      * The approval is cleared when the token is transferred.
1418      *
1419      * Only a single account can be approved at a time, so approving the
1420      * zero address clears previous approvals.
1421      *
1422      * Requirements:
1423      *
1424      * - The caller must own the token or be an approved operator.
1425      * - `tokenId` must exist.
1426      *
1427      * Emits an {Approval} event.
1428      */
1429     function approve(address to, uint256 tokenId) public virtual override {
1430         address owner = ownerOf(tokenId);
1431 
1432         if (_msgSenderERC721A() != owner)
1433             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1434                 revert ApprovalCallerNotOwnerNorApproved();
1435             }
1436 
1437         _tokenApprovals[tokenId].value = to;
1438         emit Approval(owner, to, tokenId);
1439     }
1440 
1441     /**
1442      * @dev Returns the account approved for `tokenId` token.
1443      *
1444      * Requirements:
1445      *
1446      * - `tokenId` must exist.
1447      */
1448     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1449         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1450 
1451         return _tokenApprovals[tokenId].value;
1452     }
1453 
1454     /**
1455      * @dev Approve or remove `operator` as an operator for the caller.
1456      * Operators can call {transferFrom} or {safeTransferFrom}
1457      * for any token owned by the caller.
1458      *
1459      * Requirements:
1460      *
1461      * - The `operator` cannot be the caller.
1462      *
1463      * Emits an {ApprovalForAll} event.
1464      */
1465     function setApprovalForAll(address operator, bool approved) public virtual override {
1466         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1467 
1468         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1469         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1470     }
1471 
1472     /**
1473      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1474      *
1475      * See {setApprovalForAll}.
1476      */
1477     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1478         return _operatorApprovals[owner][operator];
1479     }
1480 
1481     /**
1482      * @dev Returns whether `tokenId` exists.
1483      *
1484      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1485      *
1486      * Tokens start existing when they are minted. See {_mint}.
1487      */
1488     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1489         return
1490             _startTokenId() <= tokenId &&
1491             tokenId < _currentIndex && // If within bounds,
1492             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1493     }
1494 
1495     /**
1496      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1497      */
1498     function _isSenderApprovedOrOwner(
1499         address approvedAddress,
1500         address owner,
1501         address msgSender
1502     ) private pure returns (bool result) {
1503         assembly {
1504             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1505             owner := and(owner, _BITMASK_ADDRESS)
1506             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1507             msgSender := and(msgSender, _BITMASK_ADDRESS)
1508             // `msgSender == owner || msgSender == approvedAddress`.
1509             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1510         }
1511     }
1512 
1513     /**
1514      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1515      */
1516     function _getApprovedSlotAndAddress(uint256 tokenId)
1517         private
1518         view
1519         returns (uint256 approvedAddressSlot, address approvedAddress)
1520     {
1521         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1522         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1523         assembly {
1524             approvedAddressSlot := tokenApproval.slot
1525             approvedAddress := sload(approvedAddressSlot)
1526         }
1527     }
1528 
1529     // =============================================================
1530     //                      TRANSFER OPERATIONS
1531     // =============================================================
1532 
1533     /**
1534      * @dev Transfers `tokenId` from `from` to `to`.
1535      *
1536      * Requirements:
1537      *
1538      * - `from` cannot be the zero address.
1539      * - `to` cannot be the zero address.
1540      * - `tokenId` token must be owned by `from`.
1541      * - If the caller is not `from`, it must be approved to move this token
1542      * by either {approve} or {setApprovalForAll}.
1543      *
1544      * Emits a {Transfer} event.
1545      */
1546     function transferFrom(
1547         address from,
1548         address to,
1549         uint256 tokenId
1550     ) public virtual override {
1551         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1552 
1553         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1554 
1555         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1556 
1557         // The nested ifs save around 20+ gas over a compound boolean condition.
1558         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1559             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1560 
1561         if (to == address(0)) revert TransferToZeroAddress();
1562 
1563         _beforeTokenTransfers(from, to, tokenId, 1);
1564 
1565         // Clear approvals from the previous owner.
1566         assembly {
1567             if approvedAddress {
1568                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1569                 sstore(approvedAddressSlot, 0)
1570             }
1571         }
1572 
1573         // Underflow of the sender's balance is impossible because we check for
1574         // ownership above and the recipient's balance can't realistically overflow.
1575         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1576         unchecked {
1577             // We can directly increment and decrement the balances.
1578             --_packedAddressData[from]; // Updates: `balance -= 1`.
1579             ++_packedAddressData[to]; // Updates: `balance += 1`.
1580 
1581             // Updates:
1582             // - `address` to the next owner.
1583             // - `startTimestamp` to the timestamp of transfering.
1584             // - `burned` to `false`.
1585             // - `nextInitialized` to `true`.
1586             _packedOwnerships[tokenId] = _packOwnershipData(
1587                 to,
1588                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1589             );
1590 
1591             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1592             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1593                 uint256 nextTokenId = tokenId + 1;
1594                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1595                 if (_packedOwnerships[nextTokenId] == 0) {
1596                     // If the next slot is within bounds.
1597                     if (nextTokenId != _currentIndex) {
1598                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1599                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1600                     }
1601                 }
1602             }
1603         }
1604 
1605         emit Transfer(from, to, tokenId);
1606         _afterTokenTransfers(from, to, tokenId, 1);
1607     }
1608 
1609     /**
1610      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1611      */
1612     function safeTransferFrom(
1613         address from,
1614         address to,
1615         uint256 tokenId
1616     ) public virtual override {
1617         safeTransferFrom(from, to, tokenId, '');
1618     }
1619 
1620     /**
1621      * @dev Safely transfers `tokenId` token from `from` to `to`.
1622      *
1623      * Requirements:
1624      *
1625      * - `from` cannot be the zero address.
1626      * - `to` cannot be the zero address.
1627      * - `tokenId` token must exist and be owned by `from`.
1628      * - If the caller is not `from`, it must be approved to move this token
1629      * by either {approve} or {setApprovalForAll}.
1630      * - If `to` refers to a smart contract, it must implement
1631      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1632      *
1633      * Emits a {Transfer} event.
1634      */
1635     function safeTransferFrom(
1636         address from,
1637         address to,
1638         uint256 tokenId,
1639         bytes memory _data
1640     ) public virtual override {
1641         transferFrom(from, to, tokenId);
1642         if (to.code.length != 0)
1643             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1644                 revert TransferToNonERC721ReceiverImplementer();
1645             }
1646     }
1647 
1648     /**
1649      * @dev Hook that is called before a set of serially-ordered token IDs
1650      * are about to be transferred. This includes minting.
1651      * And also called before burning one token.
1652      *
1653      * `startTokenId` - the first token ID to be transferred.
1654      * `quantity` - the amount to be transferred.
1655      *
1656      * Calling conditions:
1657      *
1658      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1659      * transferred to `to`.
1660      * - When `from` is zero, `tokenId` will be minted for `to`.
1661      * - When `to` is zero, `tokenId` will be burned by `from`.
1662      * - `from` and `to` are never both zero.
1663      */
1664     function _beforeTokenTransfers(
1665         address from,
1666         address to,
1667         uint256 startTokenId,
1668         uint256 quantity
1669     ) internal virtual {}
1670 
1671     /**
1672      * @dev Hook that is called after a set of serially-ordered token IDs
1673      * have been transferred. This includes minting.
1674      * And also called after one token has been burned.
1675      *
1676      * `startTokenId` - the first token ID to be transferred.
1677      * `quantity` - the amount to be transferred.
1678      *
1679      * Calling conditions:
1680      *
1681      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1682      * transferred to `to`.
1683      * - When `from` is zero, `tokenId` has been minted for `to`.
1684      * - When `to` is zero, `tokenId` has been burned by `from`.
1685      * - `from` and `to` are never both zero.
1686      */
1687     function _afterTokenTransfers(
1688         address from,
1689         address to,
1690         uint256 startTokenId,
1691         uint256 quantity
1692     ) internal virtual {}
1693 
1694     /**
1695      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1696      *
1697      * `from` - Previous owner of the given token ID.
1698      * `to` - Target address that will receive the token.
1699      * `tokenId` - Token ID to be transferred.
1700      * `_data` - Optional data to send along with the call.
1701      *
1702      * Returns whether the call correctly returned the expected magic value.
1703      */
1704     function _checkContractOnERC721Received(
1705         address from,
1706         address to,
1707         uint256 tokenId,
1708         bytes memory _data
1709     ) private returns (bool) {
1710         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1711             bytes4 retval
1712         ) {
1713             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1714         } catch (bytes memory reason) {
1715             if (reason.length == 0) {
1716                 revert TransferToNonERC721ReceiverImplementer();
1717             } else {
1718                 assembly {
1719                     revert(add(32, reason), mload(reason))
1720                 }
1721             }
1722         }
1723     }
1724 
1725     // =============================================================
1726     //                        MINT OPERATIONS
1727     // =============================================================
1728 
1729     /**
1730      * @dev Mints `quantity` tokens and transfers them to `to`.
1731      *
1732      * Requirements:
1733      *
1734      * - `to` cannot be the zero address.
1735      * - `quantity` must be greater than 0.
1736      *
1737      * Emits a {Transfer} event for each mint.
1738      */
1739     function _mint(address to, uint256 quantity) internal virtual {
1740         uint256 startTokenId = _currentIndex;
1741         if (quantity == 0) revert MintZeroQuantity();
1742 
1743         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1744 
1745         // Overflows are incredibly unrealistic.
1746         // `balance` and `numberMinted` have a maximum limit of 2**64.
1747         // `tokenId` has a maximum limit of 2**256.
1748         unchecked {
1749             // Updates:
1750             // - `balance += quantity`.
1751             // - `numberMinted += quantity`.
1752             //
1753             // We can directly add to the `balance` and `numberMinted`.
1754             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1755 
1756             // Updates:
1757             // - `address` to the owner.
1758             // - `startTimestamp` to the timestamp of minting.
1759             // - `burned` to `false`.
1760             // - `nextInitialized` to `quantity == 1`.
1761             _packedOwnerships[startTokenId] = _packOwnershipData(
1762                 to,
1763                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1764             );
1765 
1766             uint256 toMasked;
1767             uint256 end = startTokenId + quantity;
1768 
1769             // Use assembly to loop and emit the `Transfer` event for gas savings.
1770             assembly {
1771                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1772                 toMasked := and(to, _BITMASK_ADDRESS)
1773                 // Emit the `Transfer` event.
1774                 log4(
1775                     0, // Start of data (0, since no data).
1776                     0, // End of data (0, since no data).
1777                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1778                     0, // `address(0)`.
1779                     toMasked, // `to`.
1780                     startTokenId // `tokenId`.
1781                 )
1782 
1783                 for {
1784                     let tokenId := add(startTokenId, 1)
1785                 } iszero(eq(tokenId, end)) {
1786                     tokenId := add(tokenId, 1)
1787                 } {
1788                     // Emit the `Transfer` event. Similar to above.
1789                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1790                 }
1791             }
1792             if (toMasked == 0) revert MintToZeroAddress();
1793 
1794             _currentIndex = end;
1795         }
1796         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1797     }
1798 
1799     /**
1800      * @dev Mints `quantity` tokens and transfers them to `to`.
1801      *
1802      * This function is intended for efficient minting only during contract creation.
1803      *
1804      * It emits only one {ConsecutiveTransfer} as defined in
1805      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1806      * instead of a sequence of {Transfer} event(s).
1807      *
1808      * Calling this function outside of contract creation WILL make your contract
1809      * non-compliant with the ERC721 standard.
1810      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1811      * {ConsecutiveTransfer} event is only permissible during contract creation.
1812      *
1813      * Requirements:
1814      *
1815      * - `to` cannot be the zero address.
1816      * - `quantity` must be greater than 0.
1817      *
1818      * Emits a {ConsecutiveTransfer} event.
1819      */
1820     function _mintERC2309(address to, uint256 quantity) internal virtual {
1821         uint256 startTokenId = _currentIndex;
1822         if (to == address(0)) revert MintToZeroAddress();
1823         if (quantity == 0) revert MintZeroQuantity();
1824         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1825 
1826         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1827 
1828         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1829         unchecked {
1830             // Updates:
1831             // - `balance += quantity`.
1832             // - `numberMinted += quantity`.
1833             //
1834             // We can directly add to the `balance` and `numberMinted`.
1835             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1836 
1837             // Updates:
1838             // - `address` to the owner.
1839             // - `startTimestamp` to the timestamp of minting.
1840             // - `burned` to `false`.
1841             // - `nextInitialized` to `quantity == 1`.
1842             _packedOwnerships[startTokenId] = _packOwnershipData(
1843                 to,
1844                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1845             );
1846 
1847             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1848 
1849             _currentIndex = startTokenId + quantity;
1850         }
1851         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1852     }
1853 
1854     /**
1855      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1856      *
1857      * Requirements:
1858      *
1859      * - If `to` refers to a smart contract, it must implement
1860      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1861      * - `quantity` must be greater than 0.
1862      *
1863      * See {_mint}.
1864      *
1865      * Emits a {Transfer} event for each mint.
1866      */
1867     function _safeMint(
1868         address to,
1869         uint256 quantity,
1870         bytes memory _data
1871     ) internal virtual {
1872         _mint(to, quantity);
1873 
1874         unchecked {
1875             if (to.code.length != 0) {
1876                 uint256 end = _currentIndex;
1877                 uint256 index = end - quantity;
1878                 do {
1879                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1880                         revert TransferToNonERC721ReceiverImplementer();
1881                     }
1882                 } while (index < end);
1883                 // Reentrancy protection.
1884                 if (_currentIndex != end) revert();
1885             }
1886         }
1887     }
1888 
1889     /**
1890      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1891      */
1892     function _safeMint(address to, uint256 quantity) internal virtual {
1893         _safeMint(to, quantity, '');
1894     }
1895 
1896     // =============================================================
1897     //                        BURN OPERATIONS
1898     // =============================================================
1899 
1900     /**
1901      * @dev Equivalent to `_burn(tokenId, false)`.
1902      */
1903     function _burn(uint256 tokenId) internal virtual {
1904         _burn(tokenId, false);
1905     }
1906 
1907     /**
1908      * @dev Destroys `tokenId`.
1909      * The approval is cleared when the token is burned.
1910      *
1911      * Requirements:
1912      *
1913      * - `tokenId` must exist.
1914      *
1915      * Emits a {Transfer} event.
1916      */
1917     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1918         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1919 
1920         address from = address(uint160(prevOwnershipPacked));
1921 
1922         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1923 
1924         if (approvalCheck) {
1925             // The nested ifs save around 20+ gas over a compound boolean condition.
1926             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1927                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1928         }
1929 
1930         _beforeTokenTransfers(from, address(0), tokenId, 1);
1931 
1932         // Clear approvals from the previous owner.
1933         assembly {
1934             if approvedAddress {
1935                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1936                 sstore(approvedAddressSlot, 0)
1937             }
1938         }
1939 
1940         // Underflow of the sender's balance is impossible because we check for
1941         // ownership above and the recipient's balance can't realistically overflow.
1942         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1943         unchecked {
1944             // Updates:
1945             // - `balance -= 1`.
1946             // - `numberBurned += 1`.
1947             //
1948             // We can directly decrement the balance, and increment the number burned.
1949             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1950             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1951 
1952             // Updates:
1953             // - `address` to the last owner.
1954             // - `startTimestamp` to the timestamp of burning.
1955             // - `burned` to `true`.
1956             // - `nextInitialized` to `true`.
1957             _packedOwnerships[tokenId] = _packOwnershipData(
1958                 from,
1959                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1960             );
1961 
1962             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1963             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1964                 uint256 nextTokenId = tokenId + 1;
1965                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1966                 if (_packedOwnerships[nextTokenId] == 0) {
1967                     // If the next slot is within bounds.
1968                     if (nextTokenId != _currentIndex) {
1969                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1970                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1971                     }
1972                 }
1973             }
1974         }
1975 
1976         emit Transfer(from, address(0), tokenId);
1977         _afterTokenTransfers(from, address(0), tokenId, 1);
1978 
1979         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1980         unchecked {
1981             _burnCounter++;
1982         }
1983     }
1984 
1985     // =============================================================
1986     //                     EXTRA DATA OPERATIONS
1987     // =============================================================
1988 
1989     /**
1990      * @dev Directly sets the extra data for the ownership data `index`.
1991      */
1992     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1993         uint256 packed = _packedOwnerships[index];
1994         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1995         uint256 extraDataCasted;
1996         // Cast `extraData` with assembly to avoid redundant masking.
1997         assembly {
1998             extraDataCasted := extraData
1999         }
2000         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2001         _packedOwnerships[index] = packed;
2002     }
2003 
2004     /**
2005      * @dev Called during each token transfer to set the 24bit `extraData` field.
2006      * Intended to be overridden by the cosumer contract.
2007      *
2008      * `previousExtraData` - the value of `extraData` before transfer.
2009      *
2010      * Calling conditions:
2011      *
2012      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2013      * transferred to `to`.
2014      * - When `from` is zero, `tokenId` will be minted for `to`.
2015      * - When `to` is zero, `tokenId` will be burned by `from`.
2016      * - `from` and `to` are never both zero.
2017      */
2018     function _extraData(
2019         address from,
2020         address to,
2021         uint24 previousExtraData
2022     ) internal view virtual returns (uint24) {}
2023 
2024     /**
2025      * @dev Returns the next extra data for the packed ownership data.
2026      * The returned result is shifted into position.
2027      */
2028     function _nextExtraData(
2029         address from,
2030         address to,
2031         uint256 prevOwnershipPacked
2032     ) private view returns (uint256) {
2033         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2034         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2035     }
2036 
2037     // =============================================================
2038     //                       OTHER OPERATIONS
2039     // =============================================================
2040 
2041     /**
2042      * @dev Returns the message sender (defaults to `msg.sender`).
2043      *
2044      * If you are writing GSN compatible contracts, you need to override this function.
2045      */
2046     function _msgSenderERC721A() internal view virtual returns (address) {
2047         return msg.sender;
2048     }
2049 
2050     /**
2051      * @dev Converts a uint256 to its ASCII string decimal representation.
2052      */
2053     function _toString(uint256 value) internal pure virtual returns (string memory ptr) {
2054         assembly {
2055             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2056             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
2057             // We will need 1 32-byte word to store the length,
2058             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
2059             ptr := add(mload(0x40), 128)
2060             // Update the free memory pointer to allocate.
2061             mstore(0x40, ptr)
2062 
2063             // Cache the end of the memory to calculate the length later.
2064             let end := ptr
2065 
2066             // We write the string from the rightmost digit to the leftmost digit.
2067             // The following is essentially a do-while loop that also handles the zero case.
2068             // Costs a bit more than early returning for the zero case,
2069             // but cheaper in terms of deployment and overall runtime costs.
2070             for {
2071                 // Initialize and perform the first pass without check.
2072                 let temp := value
2073                 // Move the pointer 1 byte leftwards to point to an empty character slot.
2074                 ptr := sub(ptr, 1)
2075                 // Write the character to the pointer.
2076                 // The ASCII index of the '0' character is 48.
2077                 mstore8(ptr, add(48, mod(temp, 10)))
2078                 temp := div(temp, 10)
2079             } temp {
2080                 // Keep dividing `temp` until zero.
2081                 temp := div(temp, 10)
2082             } {
2083                 // Body of the for loop.
2084                 ptr := sub(ptr, 1)
2085                 mstore8(ptr, add(48, mod(temp, 10)))
2086             }
2087 
2088             let length := sub(end, ptr)
2089             // Move the pointer 32 bytes leftwards to make room for the length.
2090             ptr := sub(ptr, 32)
2091             // Store the length.
2092             mstore(ptr, length)
2093         }
2094     }
2095 }
2096 
2097 // File: contracts/AStrandOfHair.sol
2098 
2099 /**
2100                                                                                                
2101     @@@@@@       @@@@@@   @@@@@@@  @@@@@@@    @@@@@@   @@@  @@@  @@@@@@@       @@@@@@   @@@@@@@@      @@@  @@@   @@@@@@   @@@  @@@@@@@   
2102     @@@@@@@@     @@@@@@@   @@@@@@@  @@@@@@@@  @@@@@@@@  @@@@ @@@  @@@@@@@@     @@@@@@@@  @@@@@@@@     @@@  @@@  @@@@@@@@  @@@  @@@@@@@@  
2103     @@!  @@@     !@@         @@!    @@!  @@@  @@!  @@@  @@!@!@@@  @@!  @@@     @@!  @@@  @@!          @@!  @@@  @@!  @@@  @@!  @@!  @@@ 
2104     !@!  @!@     !@!         !@!    !@!  @!@  !@!  @!@  !@!!@!@!  !@!  @!@     !@!  @!@  !@!          !@!  @!@  !@!  @!@  !@!  !@!  @!@  
2105     @!@!@!@!     !!@@!!      @!!    @!@!!@!   @!@!@!@!  @!@ !!@!  @!@  !@!     @!@  !@!  @!!!:!       @!@!@!@!  @!@!@!@!  !!@  @!@!!@!  
2106     !!!@!!!!      !!@!!!     !!!    !!@!@!    !!!@!!!!  !@!  !!!  !@!  !!!     !@!  !!!  !!!!!:       !!!@!!!!  !!!@!!!!  !!!  !!@!@! 
2107     !!:  !!!          !:!    !!:    !!: :!!   !!:  !!!  !!:  !!!  !!:  !!!     !!:  !!!  !!:          !!:  !!!  !!:  !!!  !!:  !!: :!!
2108     :!:  !:!         !:!     :!:    :!:  !:!  :!:  !:!  :!:  !:!  :!:  !:!     :!:  !:!  :!:          :!:  !:!  :!:  !:!  :!:  :!:  !:!  
2109     ::   :::     :::: ::      ::    ::   :::  ::   :::   ::   ::   :::: ::     ::::: ::   ::          ::   :::  ::   :::   ::  ::   :::  
2110     :   : :     :: : :       :      :   : :   :   : :  ::    :   :: :  :       : :  :    :            :   : :   :   : :  :     :   : : 
2111                                                                                                                             
2112 */
2113 
2114 pragma solidity ^0.8.7;
2115 
2116 
2117 
2118 
2119 contract AStrandOfHair is ERC721A, AccessControl {
2120     event FreeMint(address indexed account, uint256 indexed amount);
2121     event Mint(address indexed account, uint256 indexed amount);
2122 
2123     bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
2124     uint256 public constant MAX_SUPPLY = 10000;
2125 
2126     string public baseURI;
2127     string public notRevealURI;
2128 
2129     bool public isReveal;
2130     bool public isFreeMint = true;
2131     bool public isPaused;
2132 
2133     bytes32 private _root;
2134     mapping(uint256 => bool) private _advanced;
2135     mapping(address => uint256) private _freeMintedPerWallet;
2136     mapping(address => uint256) private _publicMintedPerWallet;
2137 
2138     uint32 public maxAmountPerWalletInFree;
2139     uint32 public maxAmountPerWalletInPublic;
2140     uint32 private _freeMinted;
2141     uint32 private _freeLimit;
2142     uint32 private _publicLimit;
2143     uint32 private _totalFree;
2144     uint32 private _publicMinted;
2145     uint32 private _totalPublic;
2146 
2147     constructor(
2148         string memory _name,
2149         string memory _symbol,
2150         string memory _unrevealURI,
2151         uint32 totalFree_,
2152         uint32 freeLimit_,
2153         uint32 totalPublic_,
2154         uint32 publicLimit_,
2155         uint32 maxAmountPerWalletInFree_,
2156         uint32 maxAmountPerWalletInPublic_
2157     ) ERC721A(_name, _symbol) {
2158         _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
2159         _grantRole(MANAGER_ROLE, _msgSender());
2160 
2161         _totalFree = totalFree_;
2162         _freeLimit = freeLimit_;
2163         _publicLimit = publicLimit_;
2164         _totalPublic = totalPublic_;
2165         maxAmountPerWalletInFree = maxAmountPerWalletInFree_;
2166         maxAmountPerWalletInPublic = maxAmountPerWalletInPublic_;
2167         notRevealURI = _unrevealURI;
2168         isPaused = true;
2169 
2170         _mint(_msgSender(), 100);
2171         _freeMinted += 100;
2172     }
2173 
2174     modifier onlyEOA() {
2175         require(tx.origin == msg.sender, "Not EOA");
2176         _;
2177     }
2178 
2179     ///////////////////////////////////////////////////////////////////////////////////////
2180     ////////////////////////////////// PUBLIC FUNCTION ////////////////////////////////////
2181     ///////////////////////////////////////////////////////////////////////////////////////
2182 
2183     function mint(uint32 _amount) public onlyEOA {
2184         require(!isPaused, "Already paused");
2185         require(!isFreeMint, "Invalid mint");
2186         require(!isReveal, "Already reveal");
2187         address account = _msgSender();
2188         _publicMinted += _amount;
2189         _publicMintedPerWallet[account] += _amount;
2190         require(_publicMinted <= _publicLimit, "Exceed max public total");
2191         require(
2192             _publicMintedPerWallet[account] <= maxAmountPerWalletInPublic,
2193             "Exceed max amount per account"
2194         );
2195 
2196         _mint(account, _amount);
2197 
2198         emit Mint(account, _amount);
2199     }
2200 
2201     function freeMint(bytes32[] memory proof, uint32 _amount) public onlyEOA {
2202         require(!isPaused, "Already paused");
2203         require(isFreeMint, "Invalid mint");
2204         require(!isReveal, "Already reveal");
2205         address account = _msgSender();
2206         require(isWhiteList(proof, account), "Ineligible Wallet");
2207 
2208         _freeMinted += _amount;
2209         _freeMintedPerWallet[account] += _amount;
2210 
2211         require(_freeMinted <= _freeLimit, "Exceed max free total");
2212         require(
2213             _freeMintedPerWallet[account] <= maxAmountPerWalletInFree,
2214             "Exceed max amount"
2215         );
2216 
2217         _mint(account, _amount);
2218 
2219         emit FreeMint(account, _amount);
2220     }
2221 
2222     function mint(address[] memory accounts, uint32[] memory amounts)
2223         public
2224         onlyRole(MANAGER_ROLE)
2225     {
2226         uint32 _minted = 0;
2227 
2228         for (uint256 i = 0; i < accounts.length; i++) {
2229             address account = accounts[i];
2230             uint32 amount = amounts[i];
2231 
2232             _minted++;
2233             _mint(account, amount);
2234 
2235             emit FreeMint(account, amount);
2236         }
2237 
2238         if (isFreeMint) {
2239             _freeMinted += _minted;
2240             require(_freeMinted <= _totalFree, "Exceed free amount");
2241         } else {
2242             _publicMinted += _minted;
2243             require(_publicMinted <= _totalPublic, "Exceed public amount");
2244         }
2245     }
2246 
2247     function isWhiteList(bytes32[] memory _proof, address account)
2248         public
2249         view
2250         returns (bool)
2251     {
2252         bytes32 leaf = keccak256(abi.encodePacked(account));
2253         return MerkleProof.verify(_proof, _root, leaf);
2254     }
2255 
2256     ///////////////////////////////////////////////////////////////////////////////////////
2257     ////////////////////////////////// MANAGER ROLE FUNCTION //////////////////////////////
2258     ///////////////////////////////////////////////////////////////////////////////////////
2259 
2260     function endFreeMint() public onlyRole(MANAGER_ROLE) {
2261         isFreeMint = false;
2262     }
2263 
2264     function updateRoot(bytes32 root) public onlyRole(MANAGER_ROLE) {
2265         _root = root;
2266     }
2267 
2268     function setBaseURIAndReveal(string memory _baseURI)
2269         public
2270         onlyRole(MANAGER_ROLE)
2271     {
2272         baseURI = _baseURI;
2273         isReveal = true;
2274     }
2275 
2276     function setNotRevealURI(string memory _notRevealURI)
2277         public
2278         onlyRole(MANAGER_ROLE)
2279     {
2280         notRevealURI = _notRevealURI;
2281     }
2282 
2283     function toggleReveal() public onlyRole(MANAGER_ROLE) {
2284         isReveal = !isReveal;
2285     }
2286 
2287     function setAdvancedFur(uint256[] memory tokenIds)
2288         public
2289         onlyRole(MANAGER_ROLE)
2290     {
2291         for (uint256 i = 0; i < tokenIds.length; i++) {
2292             _advanced[tokenIds[i]] = true;
2293         }
2294     }
2295 
2296     function setPublicLimit(uint32 publicLimit_) public onlyRole(MANAGER_ROLE) {
2297         _publicLimit = publicLimit_;
2298     }
2299 
2300     function setFreeLimit(uint32 freeLimit_) public onlyRole(MANAGER_ROLE) {
2301         _freeLimit = freeLimit_;
2302     }
2303 
2304     function togglePause() public onlyRole(MANAGER_ROLE) {
2305         isPaused = !isPaused;
2306     }
2307 
2308     ///////////////////////////////////////////////////////////////////////////////////////
2309     //////////////////////////////////  VIEW FUNCTION /////////////////////////////////////
2310     ///////////////////////////////////////////////////////////////////////////////////////
2311 
2312     function isAdvanced(uint256 tokenId) public view returns (bool) {
2313         return _advanced[tokenId];
2314     }
2315 
2316     function tokenURI(uint256 tokenId)
2317         public
2318         view
2319         override
2320         returns (string memory)
2321     {
2322         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2323         return
2324             isReveal
2325                 ? string(abi.encodePacked(baseURI, _toString(tokenId), ".json"))
2326                 : notRevealURI;
2327     }
2328 
2329     function supportsInterface(bytes4 interfaceId)
2330         public
2331         pure
2332         override(ERC721A, AccessControl)
2333         returns (bool)
2334     {
2335         return
2336             interfaceId == 0x7965db0b || // ERC165 interface ID for AccessControl
2337             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2338             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2339             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2340     }
2341 
2342     function totalFree() public view returns (uint256) {
2343         return _totalFree;
2344     }
2345 
2346     function totalPublic() public view returns (uint256) {
2347         return _totalPublic;
2348     }
2349 
2350     function freeMinted() public view returns (uint256) {
2351         return _freeMinted;
2352     }
2353 
2354     function publicMinted() public view returns (uint256) {
2355         return _publicMinted;
2356     }
2357 }