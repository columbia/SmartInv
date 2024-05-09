1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts (last updated v4.6.0) (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
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
38      * @dev Returns the rebuilt hash obtained by traversing a Merkle tree up
39      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
40      * hash matches the root of the tree. When processing the proof, the pairs
41      * of leafs & pre-images are assumed to be sorted.
42      *
43      * _Available since v4.4._
44      */
45     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
46         bytes32 computedHash = leaf;
47         for (uint256 i = 0; i < proof.length; i++) {
48             bytes32 proofElement = proof[i];
49             if (computedHash <= proofElement) {
50                 // Hash(current computed hash + current element of the proof)
51                 computedHash = _efficientHash(computedHash, proofElement);
52             } else {
53                 // Hash(current element of the proof + current computed hash)
54                 computedHash = _efficientHash(proofElement, computedHash);
55             }
56         }
57         return computedHash;
58     }
59 
60     function _efficientHash(bytes32 a, bytes32 b) private pure returns (bytes32 value) {
61         assembly {
62             mstore(0x00, a)
63             mstore(0x20, b)
64             value := keccak256(0x00, 0x40)
65         }
66     }
67 }
68 
69 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
70 
71 
72 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
73 
74 pragma solidity ^0.8.0;
75 
76 /**
77  * @dev Interface of the ERC165 standard, as defined in the
78  * https://eips.ethereum.org/EIPS/eip-165[EIP].
79  *
80  * Implementers can declare support of contract interfaces, which can then be
81  * queried by others ({ERC165Checker}).
82  *
83  * For an implementation, see {ERC165}.
84  */
85 interface IERC165 {
86     /**
87      * @dev Returns true if this contract implements the interface defined by
88      * `interfaceId`. See the corresponding
89      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
90      * to learn more about how these ids are created.
91      *
92      * This function call must use less than 30 000 gas.
93      */
94     function supportsInterface(bytes4 interfaceId) external view returns (bool);
95 }
96 
97 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
98 
99 
100 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
101 
102 pragma solidity ^0.8.0;
103 
104 
105 /**
106  * @dev Implementation of the {IERC165} interface.
107  *
108  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
109  * for the additional interface id that will be supported. For example:
110  *
111  * ```solidity
112  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
113  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
114  * }
115  * ```
116  *
117  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
118  */
119 abstract contract ERC165 is IERC165 {
120     /**
121      * @dev See {IERC165-supportsInterface}.
122      */
123     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
124         return interfaceId == type(IERC165).interfaceId;
125     }
126 }
127 
128 // File: @openzeppelin/contracts/utils/Strings.sol
129 
130 
131 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
132 
133 pragma solidity ^0.8.0;
134 
135 /**
136  * @dev String operations.
137  */
138 library Strings {
139     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
140 
141     /**
142      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
143      */
144     function toString(uint256 value) internal pure returns (string memory) {
145         // Inspired by OraclizeAPI's implementation - MIT licence
146         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
147 
148         if (value == 0) {
149             return "0";
150         }
151         uint256 temp = value;
152         uint256 digits;
153         while (temp != 0) {
154             digits++;
155             temp /= 10;
156         }
157         bytes memory buffer = new bytes(digits);
158         while (value != 0) {
159             digits -= 1;
160             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
161             value /= 10;
162         }
163         return string(buffer);
164     }
165 
166     /**
167      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
168      */
169     function toHexString(uint256 value) internal pure returns (string memory) {
170         if (value == 0) {
171             return "0x00";
172         }
173         uint256 temp = value;
174         uint256 length = 0;
175         while (temp != 0) {
176             length++;
177             temp >>= 8;
178         }
179         return toHexString(value, length);
180     }
181 
182     /**
183      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
184      */
185     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
186         bytes memory buffer = new bytes(2 * length + 2);
187         buffer[0] = "0";
188         buffer[1] = "x";
189         for (uint256 i = 2 * length + 1; i > 1; --i) {
190             buffer[i] = _HEX_SYMBOLS[value & 0xf];
191             value >>= 4;
192         }
193         require(value == 0, "Strings: hex length insufficient");
194         return string(buffer);
195     }
196 }
197 
198 // File: @openzeppelin/contracts/utils/Context.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Provides information about the current execution context, including the
207  * sender of the transaction and its data. While these are generally available
208  * via msg.sender and msg.data, they should not be accessed in such a direct
209  * manner, since when dealing with meta-transactions the account sending and
210  * paying for execution may not be the actual sender (as far as an application
211  * is concerned).
212  *
213  * This contract is only required for intermediate, library-like contracts.
214  */
215 abstract contract Context {
216     function _msgSender() internal view virtual returns (address) {
217         return msg.sender;
218     }
219 
220     function _msgData() internal view virtual returns (bytes calldata) {
221         return msg.data;
222     }
223 }
224 
225 // File: @openzeppelin/contracts/access/IAccessControl.sol
226 
227 
228 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
229 
230 pragma solidity ^0.8.0;
231 
232 /**
233  * @dev External interface of AccessControl declared to support ERC165 detection.
234  */
235 interface IAccessControl {
236     /**
237      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
238      *
239      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
240      * {RoleAdminChanged} not being emitted signaling this.
241      *
242      * _Available since v3.1._
243      */
244     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
245 
246     /**
247      * @dev Emitted when `account` is granted `role`.
248      *
249      * `sender` is the account that originated the contract call, an admin role
250      * bearer except when using {AccessControl-_setupRole}.
251      */
252     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
253 
254     /**
255      * @dev Emitted when `account` is revoked `role`.
256      *
257      * `sender` is the account that originated the contract call:
258      *   - if using `revokeRole`, it is the admin role bearer
259      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
260      */
261     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
262 
263     /**
264      * @dev Returns `true` if `account` has been granted `role`.
265      */
266     function hasRole(bytes32 role, address account) external view returns (bool);
267 
268     /**
269      * @dev Returns the admin role that controls `role`. See {grantRole} and
270      * {revokeRole}.
271      *
272      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
273      */
274     function getRoleAdmin(bytes32 role) external view returns (bytes32);
275 
276     /**
277      * @dev Grants `role` to `account`.
278      *
279      * If `account` had not been already granted `role`, emits a {RoleGranted}
280      * event.
281      *
282      * Requirements:
283      *
284      * - the caller must have ``role``'s admin role.
285      */
286     function grantRole(bytes32 role, address account) external;
287 
288     /**
289      * @dev Revokes `role` from `account`.
290      *
291      * If `account` had been granted `role`, emits a {RoleRevoked} event.
292      *
293      * Requirements:
294      *
295      * - the caller must have ``role``'s admin role.
296      */
297     function revokeRole(bytes32 role, address account) external;
298 
299     /**
300      * @dev Revokes `role` from the calling account.
301      *
302      * Roles are often managed via {grantRole} and {revokeRole}: this function's
303      * purpose is to provide a mechanism for accounts to lose their privileges
304      * if they are compromised (such as when a trusted device is misplaced).
305      *
306      * If the calling account had been granted `role`, emits a {RoleRevoked}
307      * event.
308      *
309      * Requirements:
310      *
311      * - the caller must be `account`.
312      */
313     function renounceRole(bytes32 role, address account) external;
314 }
315 
316 // File: @openzeppelin/contracts/access/AccessControl.sol
317 
318 
319 // OpenZeppelin Contracts (last updated v4.6.0) (access/AccessControl.sol)
320 
321 pragma solidity ^0.8.0;
322 
323 
324 
325 
326 
327 /**
328  * @dev Contract module that allows children to implement role-based access
329  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
330  * members except through off-chain means by accessing the contract event logs. Some
331  * applications may benefit from on-chain enumerability, for those cases see
332  * {AccessControlEnumerable}.
333  *
334  * Roles are referred to by their `bytes32` identifier. These should be exposed
335  * in the external API and be unique. The best way to achieve this is by
336  * using `public constant` hash digests:
337  *
338  * ```
339  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
340  * ```
341  *
342  * Roles can be used to represent a set of permissions. To restrict access to a
343  * function call, use {hasRole}:
344  *
345  * ```
346  * function foo() public {
347  *     require(hasRole(MY_ROLE, msg.sender));
348  *     ...
349  * }
350  * ```
351  *
352  * Roles can be granted and revoked dynamically via the {grantRole} and
353  * {revokeRole} functions. Each role has an associated admin role, and only
354  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
355  *
356  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
357  * that only accounts with this role will be able to grant or revoke other
358  * roles. More complex role relationships can be created by using
359  * {_setRoleAdmin}.
360  *
361  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
362  * grant and revoke this role. Extra precautions should be taken to secure
363  * accounts that have been granted it.
364  */
365 abstract contract AccessControl is Context, IAccessControl, ERC165 {
366     struct RoleData {
367         mapping(address => bool) members;
368         bytes32 adminRole;
369     }
370 
371     mapping(bytes32 => RoleData) private _roles;
372 
373     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
374 
375     /**
376      * @dev Modifier that checks that an account has a specific role. Reverts
377      * with a standardized message including the required role.
378      *
379      * The format of the revert reason is given by the following regular expression:
380      *
381      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
382      *
383      * _Available since v4.1._
384      */
385     modifier onlyRole(bytes32 role) {
386         _checkRole(role);
387         _;
388     }
389 
390     /**
391      * @dev See {IERC165-supportsInterface}.
392      */
393     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
394         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
395     }
396 
397     /**
398      * @dev Returns `true` if `account` has been granted `role`.
399      */
400     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
401         return _roles[role].members[account];
402     }
403 
404     /**
405      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
406      * Overriding this function changes the behavior of the {onlyRole} modifier.
407      *
408      * Format of the revert message is described in {_checkRole}.
409      *
410      * _Available since v4.6._
411      */
412     function _checkRole(bytes32 role) internal view virtual {
413         _checkRole(role, _msgSender());
414     }
415 
416     /**
417      * @dev Revert with a standard message if `account` is missing `role`.
418      *
419      * The format of the revert reason is given by the following regular expression:
420      *
421      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
422      */
423     function _checkRole(bytes32 role, address account) internal view virtual {
424         if (!hasRole(role, account)) {
425             revert(
426                 string(
427                     abi.encodePacked(
428                         "AccessControl: account ",
429                         Strings.toHexString(uint160(account), 20),
430                         " is missing role ",
431                         Strings.toHexString(uint256(role), 32)
432                     )
433                 )
434             );
435         }
436     }
437 
438     /**
439      * @dev Returns the admin role that controls `role`. See {grantRole} and
440      * {revokeRole}.
441      *
442      * To change a role's admin, use {_setRoleAdmin}.
443      */
444     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
445         return _roles[role].adminRole;
446     }
447 
448     /**
449      * @dev Grants `role` to `account`.
450      *
451      * If `account` had not been already granted `role`, emits a {RoleGranted}
452      * event.
453      *
454      * Requirements:
455      *
456      * - the caller must have ``role``'s admin role.
457      */
458     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
459         _grantRole(role, account);
460     }
461 
462     /**
463      * @dev Revokes `role` from `account`.
464      *
465      * If `account` had been granted `role`, emits a {RoleRevoked} event.
466      *
467      * Requirements:
468      *
469      * - the caller must have ``role``'s admin role.
470      */
471     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
472         _revokeRole(role, account);
473     }
474 
475     /**
476      * @dev Revokes `role` from the calling account.
477      *
478      * Roles are often managed via {grantRole} and {revokeRole}: this function's
479      * purpose is to provide a mechanism for accounts to lose their privileges
480      * if they are compromised (such as when a trusted device is misplaced).
481      *
482      * If the calling account had been revoked `role`, emits a {RoleRevoked}
483      * event.
484      *
485      * Requirements:
486      *
487      * - the caller must be `account`.
488      */
489     function renounceRole(bytes32 role, address account) public virtual override {
490         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
491 
492         _revokeRole(role, account);
493     }
494 
495     /**
496      * @dev Grants `role` to `account`.
497      *
498      * If `account` had not been already granted `role`, emits a {RoleGranted}
499      * event. Note that unlike {grantRole}, this function doesn't perform any
500      * checks on the calling account.
501      *
502      * [WARNING]
503      * ====
504      * This function should only be called from the constructor when setting
505      * up the initial roles for the system.
506      *
507      * Using this function in any other way is effectively circumventing the admin
508      * system imposed by {AccessControl}.
509      * ====
510      *
511      * NOTE: This function is deprecated in favor of {_grantRole}.
512      */
513     function _setupRole(bytes32 role, address account) internal virtual {
514         _grantRole(role, account);
515     }
516 
517     /**
518      * @dev Sets `adminRole` as ``role``'s admin role.
519      *
520      * Emits a {RoleAdminChanged} event.
521      */
522     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
523         bytes32 previousAdminRole = getRoleAdmin(role);
524         _roles[role].adminRole = adminRole;
525         emit RoleAdminChanged(role, previousAdminRole, adminRole);
526     }
527 
528     /**
529      * @dev Grants `role` to `account`.
530      *
531      * Internal function without access restriction.
532      */
533     function _grantRole(bytes32 role, address account) internal virtual {
534         if (!hasRole(role, account)) {
535             _roles[role].members[account] = true;
536             emit RoleGranted(role, account, _msgSender());
537         }
538     }
539 
540     /**
541      * @dev Revokes `role` from `account`.
542      *
543      * Internal function without access restriction.
544      */
545     function _revokeRole(bytes32 role, address account) internal virtual {
546         if (hasRole(role, account)) {
547             _roles[role].members[account] = false;
548             emit RoleRevoked(role, account, _msgSender());
549         }
550     }
551 }
552 
553 // File: contracts/MintingModule.sol
554 
555 
556 pragma solidity ^0.8.11;
557 
558 error AddressAlreadyMinted();
559 error ProofInvalidOrNotInAllowlist();
560 error PublicMintingDisabled();
561 error AllowlistMintingDisabled();
562 
563 
564 
565 interface IPassport {
566   function mintPassport(address to) external returns (uint256);
567 }
568 
569 interface HashingModule {
570   function storeTokenHash(uint256 tokenId) external;
571 }
572 
573 contract MintingModule is AccessControl {
574   IPassport public decagon;
575   HashingModule public hashingModule;
576   mapping(address => bool) public minted;
577   bytes32 public merkleRoot;
578 
579   bool public publicMintEnabled;
580   bool public allowlistMintEnabled;
581 
582   event PubilcMintToggled();
583   event AllowlistMintToggled();
584   event MerkleRootSet(bytes32 indexed newMerkleRoot);
585   event HashingModuleSet(address indexed newHashingModule);
586 
587   constructor(address decagonContractAddress, address HashingModuleContractAddress) {
588     _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
589     decagon = IPassport(decagonContractAddress);
590     hashingModule = HashingModule(HashingModuleContractAddress);
591     publicMintEnabled = false;
592     allowlistMintEnabled = false;
593   }
594 
595   function mintDecagon() external {
596     if (!publicMintEnabled) revert PublicMintingDisabled();
597     _mint();
598   }
599 
600   function mintAllowlistedDecagon(bytes32[] calldata _merkleProof) external {
601     if (!allowlistMintEnabled) revert AllowlistMintingDisabled();
602     bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
603     if (!MerkleProof.verify(_merkleProof, merkleRoot, leaf)) revert ProofInvalidOrNotInAllowlist();
604     _mint();
605   }
606 
607   function _mint() internal {
608     if (minted[msg.sender]) revert AddressAlreadyMinted();
609     minted[msg.sender] = true;
610     uint256 tokenId = decagon.mintPassport(msg.sender);
611     hashingModule.storeTokenHash(tokenId);
612   }
613 
614   function setMerkleRoot(bytes32 merkleRoot_) external onlyRole(DEFAULT_ADMIN_ROLE) {
615     merkleRoot = merkleRoot_;
616     emit MerkleRootSet(merkleRoot_);
617   }
618 
619   function setHashingModule(address newHashingModuleContractAddress) external onlyRole(DEFAULT_ADMIN_ROLE) {
620     hashingModule = HashingModule(newHashingModuleContractAddress);
621     emit HashingModuleSet(newHashingModuleContractAddress);
622   }
623 
624   function togglePublicMintEnabled() external onlyRole(DEFAULT_ADMIN_ROLE) {
625     publicMintEnabled = !publicMintEnabled;
626     emit PubilcMintToggled();
627   }
628 
629   function toggleAllowlistMintEnabled() external onlyRole(DEFAULT_ADMIN_ROLE) {
630     allowlistMintEnabled = !allowlistMintEnabled;
631     emit AllowlistMintToggled();
632   }
633 }