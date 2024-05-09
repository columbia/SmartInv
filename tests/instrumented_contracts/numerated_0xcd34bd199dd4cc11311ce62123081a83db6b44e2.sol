1 // SPDX-License-Identifier: MIT
2 
3 
4 // File: @openzeppelin/contracts/utils/Strings.sol
5 
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
8 
9 pragma solidity ^0.8.0;
10 
11 /**
12  * @dev String operations.
13  */
14 library Strings {
15     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
16     uint8 private constant _ADDRESS_LENGTH = 20;
17 
18     /**
19      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
20      */
21     function toString(uint256 value) internal pure returns (string memory) {
22         // Inspired by OraclizeAPI's implementation - MIT licence
23         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
24 
25         if (value == 0) {
26             return "0";
27         }
28         uint256 temp = value;
29         uint256 digits;
30         while (temp != 0) {
31             digits++;
32             temp /= 10;
33         }
34         bytes memory buffer = new bytes(digits);
35         while (value != 0) {
36             digits -= 1;
37             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
38             value /= 10;
39         }
40         return string(buffer);
41     }
42 
43     /**
44      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
45      */
46     function toHexString(uint256 value) internal pure returns (string memory) {
47         if (value == 0) {
48             return "0x00";
49         }
50         uint256 temp = value;
51         uint256 length = 0;
52         while (temp != 0) {
53             length++;
54             temp >>= 8;
55         }
56         return toHexString(value, length);
57     }
58 
59     /**
60      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
61      */
62     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
63         bytes memory buffer = new bytes(2 * length + 2);
64         buffer[0] = "0";
65         buffer[1] = "x";
66         for (uint256 i = 2 * length + 1; i > 1; --i) {
67             buffer[i] = _HEX_SYMBOLS[value & 0xf];
68             value >>= 4;
69         }
70         require(value == 0, "Strings: hex length insufficient");
71         return string(buffer);
72     }
73 
74     /**
75      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
76      */
77     function toHexString(address addr) internal pure returns (string memory) {
78         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
79     }
80 }
81 
82 // File: @openzeppelin/contracts/utils/Context.sol
83 
84 
85 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
86 
87 pragma solidity ^0.8.0;
88 
89 /**
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 abstract contract Context {
100     function _msgSender() internal view virtual returns (address) {
101         return msg.sender;
102     }
103 
104     function _msgData() internal view virtual returns (bytes calldata) {
105         return msg.data;
106     }
107 }
108 
109 // File: @openzeppelin/contracts/access/IAccessControl.sol
110 
111 
112 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
113 
114 pragma solidity ^0.8.0;
115 
116 /**
117  * @dev External interface of AccessControl declared to support ERC165 detection.
118  */
119 interface IAccessControl {
120     /**
121      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
122      *
123      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
124      * {RoleAdminChanged} not being emitted signaling this.
125      *
126      * _Available since v3.1._
127      */
128     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
129 
130     /**
131      * @dev Emitted when `account` is granted `role`.
132      *
133      * `sender` is the account that originated the contract call, an admin role
134      * bearer except when using {AccessControl-_setupRole}.
135      */
136     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
137 
138     /**
139      * @dev Emitted when `account` is revoked `role`.
140      *
141      * `sender` is the account that originated the contract call:
142      *   - if using `revokeRole`, it is the admin role bearer
143      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
144      */
145     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
146 
147     /**
148      * @dev Returns `true` if `account` has been granted `role`.
149      */
150     function hasRole(bytes32 role, address account) external view returns (bool);
151 
152     /**
153      * @dev Returns the admin role that controls `role`. See {grantRole} and
154      * {revokeRole}.
155      *
156      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
157      */
158     function getRoleAdmin(bytes32 role) external view returns (bytes32);
159 
160     /**
161      * @dev Grants `role` to `account`.
162      *
163      * If `account` had not been already granted `role`, emits a {RoleGranted}
164      * event.
165      *
166      * Requirements:
167      *
168      * - the caller must have ``role``'s admin role.
169      */
170     function grantRole(bytes32 role, address account) external;
171 
172     /**
173      * @dev Revokes `role` from `account`.
174      *
175      * If `account` had been granted `role`, emits a {RoleRevoked} event.
176      *
177      * Requirements:
178      *
179      * - the caller must have ``role``'s admin role.
180      */
181     function revokeRole(bytes32 role, address account) external;
182 
183     /**
184      * @dev Revokes `role` from the calling account.
185      *
186      * Roles are often managed via {grantRole} and {revokeRole}: this function's
187      * purpose is to provide a mechanism for accounts to lose their privileges
188      * if they are compromised (such as when a trusted device is misplaced).
189      *
190      * If the calling account had been granted `role`, emits a {RoleRevoked}
191      * event.
192      *
193      * Requirements:
194      *
195      * - the caller must be `account`.
196      */
197     function renounceRole(bytes32 role, address account) external;
198 }
199 
200 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
201 
202 
203 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
204 
205 pragma solidity ^0.8.0;
206 
207 /**
208  * @dev Contract module that helps prevent reentrant calls to a function.
209  *
210  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
211  * available, which can be applied to functions to make sure there are no nested
212  * (reentrant) calls to them.
213  *
214  * Note that because there is a single `nonReentrant` guard, functions marked as
215  * `nonReentrant` may not call one another. This can be worked around by making
216  * those functions `private`, and then adding `external` `nonReentrant` entry
217  * points to them.
218  *
219  * TIP: If you would like to learn more about reentrancy and alternative ways
220  * to protect against it, check out our blog post
221  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
222  */
223 abstract contract ReentrancyGuard {
224     // Booleans are more expensive than uint256 or any type that takes up a full
225     // word because each write operation emits an extra SLOAD to first read the
226     // slot's contents, replace the bits taken up by the boolean, and then write
227     // back. This is the compiler's defense against contract upgrades and
228     // pointer aliasing, and it cannot be disabled.
229 
230     // The values being non-zero value makes deployment a bit more expensive,
231     // but in exchange the refund on every call to nonReentrant will be lower in
232     // amount. Since refunds are capped to a percentage of the total
233     // transaction's gas, it is best to keep them low in cases like this one, to
234     // increase the likelihood of the full refund coming into effect.
235     uint256 private constant _NOT_ENTERED = 1;
236     uint256 private constant _ENTERED = 2;
237 
238     uint256 private _status;
239 
240     constructor() {
241         _status = _NOT_ENTERED;
242     }
243 
244     /**
245      * @dev Prevents a contract from calling itself, directly or indirectly.
246      * Calling a `nonReentrant` function from another `nonReentrant`
247      * function is not supported. It is possible to prevent this from happening
248      * by making the `nonReentrant` function external, and making it call a
249      * `private` function that does the actual work.
250      */
251     modifier nonReentrant() {
252         // On the first call to nonReentrant, _notEntered will be true
253         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
254 
255         // Any calls to nonReentrant after this point will fail
256         _status = _ENTERED;
257 
258         _;
259 
260         // By storing the original value once again, a refund is triggered (see
261         // https://eips.ethereum.org/EIPS/eip-2200)
262         _status = _NOT_ENTERED;
263     }
264 }
265 
266 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
267 
268 
269 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
270 
271 pragma solidity ^0.8.0;
272 
273 /**
274  * @dev Interface of the ERC165 standard, as defined in the
275  * https://eips.ethereum.org/EIPS/eip-165[EIP].
276  *
277  * Implementers can declare support of contract interfaces, which can then be
278  * queried by others ({ERC165Checker}).
279  *
280  * For an implementation, see {ERC165}.
281  */
282 interface IERC165 {
283     /**
284      * @dev Returns true if this contract implements the interface defined by
285      * `interfaceId`. See the corresponding
286      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
287      * to learn more about how these ids are created.
288      *
289      * This function call must use less than 30 000 gas.
290      */
291     function supportsInterface(bytes4 interfaceId) external view returns (bool);
292 }
293 
294 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
295 
296 
297 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
298 
299 pragma solidity ^0.8.0;
300 
301 
302 /**
303  * @dev Implementation of the {IERC165} interface.
304  *
305  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
306  * for the additional interface id that will be supported. For example:
307  *
308  * ```solidity
309  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
310  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
311  * }
312  * ```
313  *
314  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
315  */
316 abstract contract ERC165 is IERC165 {
317     /**
318      * @dev See {IERC165-supportsInterface}.
319      */
320     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
321         return interfaceId == type(IERC165).interfaceId;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/access/AccessControl.sol
326 
327 
328 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
329 
330 pragma solidity ^0.8.0;
331 
332 
333 
334 
335 
336 /**
337  * @dev Contract module that allows children to implement role-based access
338  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
339  * members except through off-chain means by accessing the contract event logs. Some
340  * applications may benefit from on-chain enumerability, for those cases see
341  * {AccessControlEnumerable}.
342  *
343  * Roles are referred to by their `bytes32` identifier. These should be exposed
344  * in the external API and be unique. The best way to achieve this is by
345  * using `public constant` hash digests:
346  *
347  * ```
348  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
349  * ```
350  *
351  * Roles can be used to represent a set of permissions. To restrict access to a
352  * function call, use {hasRole}:
353  *
354  * ```
355  * function foo() public {
356  *     require(hasRole(MY_ROLE, msg.sender));
357  *     ...
358  * }
359  * ```
360  *
361  * Roles can be granted and revoked dynamically via the {grantRole} and
362  * {revokeRole} functions. Each role has an associated admin role, and only
363  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
364  *
365  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
366  * that only accounts with this role will be able to grant or revoke other
367  * roles. More complex role relationships can be created by using
368  * {_setRoleAdmin}.
369  *
370  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
371  * grant and revoke this role. Extra precautions should be taken to secure
372  * accounts that have been granted it.
373  */
374 abstract contract AccessControl is Context, IAccessControl, ERC165 {
375     struct RoleData {
376         mapping(address => bool) members;
377         bytes32 adminRole;
378     }
379 
380     mapping(bytes32 => RoleData) private _roles;
381 
382     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
383 
384     /**
385      * @dev Modifier that checks that an account has a specific role. Reverts
386      * with a standardized message including the required role.
387      *
388      * The format of the revert reason is given by the following regular expression:
389      *
390      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
391      *
392      * _Available since v4.1._
393      */
394     modifier onlyRole(bytes32 role) {
395         _checkRole(role);
396         _;
397     }
398 
399     /**
400      * @dev See {IERC165-supportsInterface}.
401      */
402     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
403         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
404     }
405 
406     /**
407      * @dev Returns `true` if `account` has been granted `role`.
408      */
409     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
410         return _roles[role].members[account];
411     }
412 
413     /**
414      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
415      * Overriding this function changes the behavior of the {onlyRole} modifier.
416      *
417      * Format of the revert message is described in {_checkRole}.
418      *
419      * _Available since v4.6._
420      */
421     function _checkRole(bytes32 role) internal view virtual {
422         _checkRole(role, _msgSender());
423     }
424 
425     /**
426      * @dev Revert with a standard message if `account` is missing `role`.
427      *
428      * The format of the revert reason is given by the following regular expression:
429      *
430      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
431      */
432     function _checkRole(bytes32 role, address account) internal view virtual {
433         if (!hasRole(role, account)) {
434             revert(
435                 string(
436                     abi.encodePacked(
437                         "AccessControl: account ",
438                         Strings.toHexString(uint160(account), 20),
439                         " is missing role ",
440                         Strings.toHexString(uint256(role), 32)
441                     )
442                 )
443             );
444         }
445     }
446 
447     /**
448      * @dev Returns the admin role that controls `role`. See {grantRole} and
449      * {revokeRole}.
450      *
451      * To change a role's admin, use {_setRoleAdmin}.
452      */
453     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
454         return _roles[role].adminRole;
455     }
456 
457     /**
458      * @dev Grants `role` to `account`.
459      *
460      * If `account` had not been already granted `role`, emits a {RoleGranted}
461      * event.
462      *
463      * Requirements:
464      *
465      * - the caller must have ``role``'s admin role.
466      *
467      * May emit a {RoleGranted} event.
468      */
469     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
470         _grantRole(role, account);
471     }
472 
473     /**
474      * @dev Revokes `role` from `account`.
475      *
476      * If `account` had been granted `role`, emits a {RoleRevoked} event.
477      *
478      * Requirements:
479      *
480      * - the caller must have ``role``'s admin role.
481      *
482      * May emit a {RoleRevoked} event.
483      */
484     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
485         _revokeRole(role, account);
486     }
487 
488     /**
489      * @dev Revokes `role` from the calling account.
490      *
491      * Roles are often managed via {grantRole} and {revokeRole}: this function's
492      * purpose is to provide a mechanism for accounts to lose their privileges
493      * if they are compromised (such as when a trusted device is misplaced).
494      *
495      * If the calling account had been revoked `role`, emits a {RoleRevoked}
496      * event.
497      *
498      * Requirements:
499      *
500      * - the caller must be `account`.
501      *
502      * May emit a {RoleRevoked} event.
503      */
504     function renounceRole(bytes32 role, address account) public virtual override {
505         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
506 
507         _revokeRole(role, account);
508     }
509 
510     /**
511      * @dev Grants `role` to `account`.
512      *
513      * If `account` had not been already granted `role`, emits a {RoleGranted}
514      * event. Note that unlike {grantRole}, this function doesn't perform any
515      * checks on the calling account.
516      *
517      * May emit a {RoleGranted} event.
518      *
519      * [WARNING]
520      * ====
521      * This function should only be called from the constructor when setting
522      * up the initial roles for the system.
523      *
524      * Using this function in any other way is effectively circumventing the admin
525      * system imposed by {AccessControl}.
526      * ====
527      *
528      * NOTE: This function is deprecated in favor of {_grantRole}.
529      */
530     function _setupRole(bytes32 role, address account) internal virtual {
531         _grantRole(role, account);
532     }
533 
534     /**
535      * @dev Sets `adminRole` as ``role``'s admin role.
536      *
537      * Emits a {RoleAdminChanged} event.
538      */
539     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
540         bytes32 previousAdminRole = getRoleAdmin(role);
541         _roles[role].adminRole = adminRole;
542         emit RoleAdminChanged(role, previousAdminRole, adminRole);
543     }
544 
545     /**
546      * @dev Grants `role` to `account`.
547      *
548      * Internal function without access restriction.
549      *
550      * May emit a {RoleGranted} event.
551      */
552     function _grantRole(bytes32 role, address account) internal virtual {
553         if (!hasRole(role, account)) {
554             _roles[role].members[account] = true;
555             emit RoleGranted(role, account, _msgSender());
556         }
557     }
558 
559     /**
560      * @dev Revokes `role` from `account`.
561      *
562      * Internal function without access restriction.
563      *
564      * May emit a {RoleRevoked} event.
565      */
566     function _revokeRole(bytes32 role, address account) internal virtual {
567         if (hasRole(role, account)) {
568             _roles[role].members[account] = false;
569             emit RoleRevoked(role, account, _msgSender());
570         }
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
575 
576 
577 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
578 
579 pragma solidity ^0.8.0;
580 
581 
582 /**
583  * @dev Required interface of an ERC721 compliant contract.
584  */
585 interface IERC721 is IERC165 {
586     /**
587      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
588      */
589     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
590 
591     /**
592      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
593      */
594     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
595 
596     /**
597      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
598      */
599     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
600 
601     /**
602      * @dev Returns the number of tokens in ``owner``'s account.
603      */
604     function balanceOf(address owner) external view returns (uint256 balance);
605 
606     /**
607      * @dev Returns the owner of the `tokenId` token.
608      *
609      * Requirements:
610      *
611      * - `tokenId` must exist.
612      */
613     function ownerOf(uint256 tokenId) external view returns (address owner);
614 
615     /**
616      * @dev Safely transfers `tokenId` token from `from` to `to`.
617      *
618      * Requirements:
619      *
620      * - `from` cannot be the zero address.
621      * - `to` cannot be the zero address.
622      * - `tokenId` token must exist and be owned by `from`.
623      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
624      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
625      *
626      * Emits a {Transfer} event.
627      */
628     function safeTransferFrom(
629         address from,
630         address to,
631         uint256 tokenId,
632         bytes calldata data
633     ) external;
634 
635     /**
636      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
637      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
638      *
639      * Requirements:
640      *
641      * - `from` cannot be the zero address.
642      * - `to` cannot be the zero address.
643      * - `tokenId` token must exist and be owned by `from`.
644      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
645      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
646      *
647      * Emits a {Transfer} event.
648      */
649     function safeTransferFrom(
650         address from,
651         address to,
652         uint256 tokenId
653     ) external;
654 
655     /**
656      * @dev Transfers `tokenId` token from `from` to `to`.
657      *
658      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
659      *
660      * Requirements:
661      *
662      * - `from` cannot be the zero address.
663      * - `to` cannot be the zero address.
664      * - `tokenId` token must be owned by `from`.
665      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
666      *
667      * Emits a {Transfer} event.
668      */
669     function transferFrom(
670         address from,
671         address to,
672         uint256 tokenId
673     ) external;
674 
675     /**
676      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
677      * The approval is cleared when the token is transferred.
678      *
679      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
680      *
681      * Requirements:
682      *
683      * - The caller must own the token or be an approved operator.
684      * - `tokenId` must exist.
685      *
686      * Emits an {Approval} event.
687      */
688     function approve(address to, uint256 tokenId) external;
689 
690     /**
691      * @dev Approve or remove `operator` as an operator for the caller.
692      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
693      *
694      * Requirements:
695      *
696      * - The `operator` cannot be the caller.
697      *
698      * Emits an {ApprovalForAll} event.
699      */
700     function setApprovalForAll(address operator, bool _approved) external;
701 
702     /**
703      * @dev Returns the account approved for `tokenId` token.
704      *
705      * Requirements:
706      *
707      * - `tokenId` must exist.
708      */
709     function getApproved(uint256 tokenId) external view returns (address operator);
710 
711     /**
712      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
713      *
714      * See {setApprovalForAll}
715      */
716     function isApprovedForAll(address owner, address operator) external view returns (bool);
717 }
718 
719 // File: @openzeppelin/contracts/utils/Address.sol
720 
721 
722 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
723 
724 pragma solidity ^0.8.1;
725 
726 /**
727  * @dev Collection of functions related to the address type
728  */
729 library Address {
730     /**
731      * @dev Returns true if `account` is a contract.
732      *
733      * [IMPORTANT]
734      * ====
735      * It is unsafe to assume that an address for which this function returns
736      * false is an externally-owned account (EOA) and not a contract.
737      *
738      * Among others, `isContract` will return false for the following
739      * types of addresses:
740      *
741      *  - an externally-owned account
742      *  - a contract in construction
743      *  - an address where a contract will be created
744      *  - an address where a contract lived, but was destroyed
745      * ====
746      *
747      * [IMPORTANT]
748      * ====
749      * You shouldn't rely on `isContract` to protect against flash loan attacks!
750      *
751      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
752      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
753      * constructor.
754      * ====
755      */
756     function isContract(address account) internal view returns (bool) {
757         // This method relies on extcodesize/address.code.length, which returns 0
758         // for contracts in construction, since the code is only stored at the end
759         // of the constructor execution.
760 
761         return account.code.length > 0;
762     }
763 
764     /**
765      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
766      * `recipient`, forwarding all available gas and reverting on errors.
767      *
768      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
769      * of certain opcodes, possibly making contracts go over the 2300 gas limit
770      * imposed by `transfer`, making them unable to receive funds via
771      * `transfer`. {sendValue} removes this limitation.
772      *
773      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
774      *
775      * IMPORTANT: because control is transferred to `recipient`, care must be
776      * taken to not create reentrancy vulnerabilities. Consider using
777      * {ReentrancyGuard} or the
778      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
779      */
780     function sendValue(address payable recipient, uint256 amount) internal {
781         require(address(this).balance >= amount, "Address: insufficient balance");
782 
783         (bool success, ) = recipient.call{value: amount}("");
784         require(success, "Address: unable to send value, recipient may have reverted");
785     }
786 
787     /**
788      * @dev Performs a Solidity function call using a low level `call`. A
789      * plain `call` is an unsafe replacement for a function call: use this
790      * function instead.
791      *
792      * If `target` reverts with a revert reason, it is bubbled up by this
793      * function (like regular Solidity function calls).
794      *
795      * Returns the raw returned data. To convert to the expected return value,
796      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
797      *
798      * Requirements:
799      *
800      * - `target` must be a contract.
801      * - calling `target` with `data` must not revert.
802      *
803      * _Available since v3.1._
804      */
805     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
806         return functionCall(target, data, "Address: low-level call failed");
807     }
808 
809     /**
810      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
811      * `errorMessage` as a fallback revert reason when `target` reverts.
812      *
813      * _Available since v3.1._
814      */
815     function functionCall(
816         address target,
817         bytes memory data,
818         string memory errorMessage
819     ) internal returns (bytes memory) {
820         return functionCallWithValue(target, data, 0, errorMessage);
821     }
822 
823     /**
824      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
825      * but also transferring `value` wei to `target`.
826      *
827      * Requirements:
828      *
829      * - the calling contract must have an ETH balance of at least `value`.
830      * - the called Solidity function must be `payable`.
831      *
832      * _Available since v3.1._
833      */
834     function functionCallWithValue(
835         address target,
836         bytes memory data,
837         uint256 value
838     ) internal returns (bytes memory) {
839         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
840     }
841 
842     /**
843      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
844      * with `errorMessage` as a fallback revert reason when `target` reverts.
845      *
846      * _Available since v3.1._
847      */
848     function functionCallWithValue(
849         address target,
850         bytes memory data,
851         uint256 value,
852         string memory errorMessage
853     ) internal returns (bytes memory) {
854         require(address(this).balance >= value, "Address: insufficient balance for call");
855         require(isContract(target), "Address: call to non-contract");
856 
857         (bool success, bytes memory returndata) = target.call{value: value}(data);
858         return verifyCallResult(success, returndata, errorMessage);
859     }
860 
861     /**
862      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
863      * but performing a static call.
864      *
865      * _Available since v3.3._
866      */
867     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
868         return functionStaticCall(target, data, "Address: low-level static call failed");
869     }
870 
871     /**
872      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
873      * but performing a static call.
874      *
875      * _Available since v3.3._
876      */
877     function functionStaticCall(
878         address target,
879         bytes memory data,
880         string memory errorMessage
881     ) internal view returns (bytes memory) {
882         require(isContract(target), "Address: static call to non-contract");
883 
884         (bool success, bytes memory returndata) = target.staticcall(data);
885         return verifyCallResult(success, returndata, errorMessage);
886     }
887 
888     /**
889      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
890      * but performing a delegate call.
891      *
892      * _Available since v3.4._
893      */
894     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
895         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
896     }
897 
898     /**
899      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
900      * but performing a delegate call.
901      *
902      * _Available since v3.4._
903      */
904     function functionDelegateCall(
905         address target,
906         bytes memory data,
907         string memory errorMessage
908     ) internal returns (bytes memory) {
909         require(isContract(target), "Address: delegate call to non-contract");
910 
911         (bool success, bytes memory returndata) = target.delegatecall(data);
912         return verifyCallResult(success, returndata, errorMessage);
913     }
914 
915     /**
916      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
917      * revert reason using the provided one.
918      *
919      * _Available since v4.3._
920      */
921     function verifyCallResult(
922         bool success,
923         bytes memory returndata,
924         string memory errorMessage
925     ) internal pure returns (bytes memory) {
926         if (success) {
927             return returndata;
928         } else {
929             // Look for revert reason and bubble it up if present
930             if (returndata.length > 0) {
931                 // The easiest way to bubble the revert reason is using memory via assembly
932                 /// @solidity memory-safe-assembly
933                 assembly {
934                     let returndata_size := mload(returndata)
935                     revert(add(32, returndata), returndata_size)
936                 }
937             } else {
938                 revert(errorMessage);
939             }
940         }
941     }
942 }
943 
944 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
945 
946 
947 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
948 
949 pragma solidity ^0.8.0;
950 
951 /**
952  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
953  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
954  *
955  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
956  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
957  * need to send a transaction, and thus is not required to hold Ether at all.
958  */
959 interface IERC20Permit {
960     /**
961      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
962      * given ``owner``'s signed approval.
963      *
964      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
965      * ordering also apply here.
966      *
967      * Emits an {Approval} event.
968      *
969      * Requirements:
970      *
971      * - `spender` cannot be the zero address.
972      * - `deadline` must be a timestamp in the future.
973      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
974      * over the EIP712-formatted function arguments.
975      * - the signature must use ``owner``'s current nonce (see {nonces}).
976      *
977      * For more information on the signature format, see the
978      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
979      * section].
980      */
981     function permit(
982         address owner,
983         address spender,
984         uint256 value,
985         uint256 deadline,
986         uint8 v,
987         bytes32 r,
988         bytes32 s
989     ) external;
990 
991     /**
992      * @dev Returns the current nonce for `owner`. This value must be
993      * included whenever a signature is generated for {permit}.
994      *
995      * Every successful call to {permit} increases ``owner``'s nonce by one. This
996      * prevents a signature from being used multiple times.
997      */
998     function nonces(address owner) external view returns (uint256);
999 
1000     /**
1001      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1002      */
1003     // solhint-disable-next-line func-name-mixedcase
1004     function DOMAIN_SEPARATOR() external view returns (bytes32);
1005 }
1006 
1007 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1008 
1009 
1010 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1011 
1012 pragma solidity ^0.8.0;
1013 
1014 /**
1015  * @dev Interface of the ERC20 standard as defined in the EIP.
1016  */
1017 interface IERC20 {
1018     /**
1019      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1020      * another (`to`).
1021      *
1022      * Note that `value` may be zero.
1023      */
1024     event Transfer(address indexed from, address indexed to, uint256 value);
1025 
1026     /**
1027      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1028      * a call to {approve}. `value` is the new allowance.
1029      */
1030     event Approval(address indexed owner, address indexed spender, uint256 value);
1031 
1032     /**
1033      * @dev Returns the amount of tokens in existence.
1034      */
1035     function totalSupply() external view returns (uint256);
1036 
1037     /**
1038      * @dev Returns the amount of tokens owned by `account`.
1039      */
1040     function balanceOf(address account) external view returns (uint256);
1041 
1042     /**
1043      * @dev Moves `amount` tokens from the caller's account to `to`.
1044      *
1045      * Returns a boolean value indicating whether the operation succeeded.
1046      *
1047      * Emits a {Transfer} event.
1048      */
1049     function transfer(address to, uint256 amount) external returns (bool);
1050 
1051     /**
1052      * @dev Returns the remaining number of tokens that `spender` will be
1053      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1054      * zero by default.
1055      *
1056      * This value changes when {approve} or {transferFrom} are called.
1057      */
1058     function allowance(address owner, address spender) external view returns (uint256);
1059 
1060     /**
1061      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1062      *
1063      * Returns a boolean value indicating whether the operation succeeded.
1064      *
1065      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1066      * that someone may use both the old and the new allowance by unfortunate
1067      * transaction ordering. One possible solution to mitigate this race
1068      * condition is to first reduce the spender's allowance to 0 and set the
1069      * desired value afterwards:
1070      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1071      *
1072      * Emits an {Approval} event.
1073      */
1074     function approve(address spender, uint256 amount) external returns (bool);
1075 
1076     /**
1077      * @dev Moves `amount` tokens from `from` to `to` using the
1078      * allowance mechanism. `amount` is then deducted from the caller's
1079      * allowance.
1080      *
1081      * Returns a boolean value indicating whether the operation succeeded.
1082      *
1083      * Emits a {Transfer} event.
1084      */
1085     function transferFrom(
1086         address from,
1087         address to,
1088         uint256 amount
1089     ) external returns (bool);
1090 }
1091 
1092 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1093 
1094 
1095 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1096 
1097 pragma solidity ^0.8.0;
1098 
1099 
1100 
1101 
1102 /**
1103  * @title SafeERC20
1104  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1105  * contract returns false). Tokens that return no value (and instead revert or
1106  * throw on failure) are also supported, non-reverting calls are assumed to be
1107  * successful.
1108  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1109  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1110  */
1111 library SafeERC20 {
1112     using Address for address;
1113 
1114     function safeTransfer(
1115         IERC20 token,
1116         address to,
1117         uint256 value
1118     ) internal {
1119         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1120     }
1121 
1122     function safeTransferFrom(
1123         IERC20 token,
1124         address from,
1125         address to,
1126         uint256 value
1127     ) internal {
1128         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1129     }
1130 
1131     /**
1132      * @dev Deprecated. This function has issues similar to the ones found in
1133      * {IERC20-approve}, and its usage is discouraged.
1134      *
1135      * Whenever possible, use {safeIncreaseAllowance} and
1136      * {safeDecreaseAllowance} instead.
1137      */
1138     function safeApprove(
1139         IERC20 token,
1140         address spender,
1141         uint256 value
1142     ) internal {
1143         // safeApprove should only be called when setting an initial allowance,
1144         // or when resetting it to zero. To increase and decrease it, use
1145         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1146         require(
1147             (value == 0) || (token.allowance(address(this), spender) == 0),
1148             "SafeERC20: approve from non-zero to non-zero allowance"
1149         );
1150         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1151     }
1152 
1153     function safeIncreaseAllowance(
1154         IERC20 token,
1155         address spender,
1156         uint256 value
1157     ) internal {
1158         uint256 newAllowance = token.allowance(address(this), spender) + value;
1159         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1160     }
1161 
1162     function safeDecreaseAllowance(
1163         IERC20 token,
1164         address spender,
1165         uint256 value
1166     ) internal {
1167         unchecked {
1168             uint256 oldAllowance = token.allowance(address(this), spender);
1169             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1170             uint256 newAllowance = oldAllowance - value;
1171             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1172         }
1173     }
1174 
1175     function safePermit(
1176         IERC20Permit token,
1177         address owner,
1178         address spender,
1179         uint256 value,
1180         uint256 deadline,
1181         uint8 v,
1182         bytes32 r,
1183         bytes32 s
1184     ) internal {
1185         uint256 nonceBefore = token.nonces(owner);
1186         token.permit(owner, spender, value, deadline, v, r, s);
1187         uint256 nonceAfter = token.nonces(owner);
1188         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1189     }
1190 
1191     /**
1192      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1193      * on the return value: the return value is optional (but if data is returned, it must not be false).
1194      * @param token The token targeted by the call.
1195      * @param data The call data (encoded using abi.encode or one of its variants).
1196      */
1197     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1198         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1199         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1200         // the target address contains contract code and also asserts for success in the low-level call.
1201 
1202         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1203         if (returndata.length > 0) {
1204             // Return data is optional
1205             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1206         }
1207     }
1208 }
1209 
1210 // File: contracts/WagmiStaking.sol
1211 
1212 
1213 pragma solidity ^0.8.4;
1214 
1215 
1216 
1217 
1218 
1219 
1220 contract WagmiStaking is ReentrancyGuard, AccessControl {
1221     using SafeERC20 for IERC20;
1222 
1223     // Interfaces for ERC20 and ERC721
1224     IERC20 public immutable rewardsToken;
1225     IERC721 public immutable nftCollection;
1226     uint256 public minimumStakingTime = 168;
1227 
1228     // Constructor function to set the rewards token and the NFT collection addresses
1229     constructor(IERC721 _nftCollection, IERC20 _rewardsToken) {
1230         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1231         nftCollection = _nftCollection;
1232         rewardsToken = _rewardsToken;
1233     }
1234 
1235     struct StakedToken {
1236         address staker;
1237         uint256 tokenId;
1238         uint256 tokenStoreTime;
1239     }
1240     
1241     // Staker info
1242     struct Staker {
1243         // Amount of tokens staked by the staker
1244         uint256 amountStaked;
1245 
1246         // Staked token ids
1247         StakedToken[] stakedTokens;
1248 
1249         // Last time of the rewards were calculated for this user
1250         uint256 timeOfLastUpdate;
1251 
1252         // Calculated, but unclaimed rewards for the User. The rewards are
1253         // calculated each time the user writes to the Smart Contract
1254         uint256 unclaimedRewards;
1255     }
1256 
1257     // Rewards per hour per token deposited in wei.
1258     uint256 private rewardsPerHour = 100000000000000;
1259 
1260     // Mapping of User Address to Staker info
1261     mapping(address => Staker) public stakers;
1262 
1263     // Mapping of Token Id to staker. Made for the SC to remeber
1264     // who to send back the ERC721 Token to.
1265     mapping(uint256 => address) public stakerAddress;
1266 
1267 
1268     function setMinimumStakingHours (uint _hours) public onlyRole(DEFAULT_ADMIN_ROLE) {
1269         minimumStakingTime = _hours;
1270     } 
1271 
1272     // If address already has ERC721 Token/s staked, calculate the rewards.
1273     // Increment the amountStaked and map msg.sender to the Token Id of the staked
1274     // Token to later send back on withdrawal. Finally give timeOfLastUpdate the
1275     // value of now.
1276     function stake(uint256 _tokenId) external nonReentrant {
1277         // If wallet has tokens staked, calculate the rewards before adding the new token
1278         if (stakers[msg.sender].amountStaked > 0) {
1279             uint256 rewards = calculateRewards(msg.sender);
1280             stakers[msg.sender].unclaimedRewards += rewards;
1281         }
1282 
1283         // Wallet must own the token they are trying to stake
1284         require(
1285             nftCollection.ownerOf(_tokenId) == msg.sender,
1286             "You don't own this token!"
1287         );
1288 
1289         unchecked {
1290                 // Transfer the token from the wallet to the Smart contract
1291             nftCollection.transferFrom(msg.sender, address(this), _tokenId);
1292 
1293             // Create StakedToken
1294             StakedToken memory stakedToken = StakedToken(msg.sender, _tokenId, block.timestamp);
1295 
1296             // Add the token to the stakedTokens array
1297             stakers[msg.sender].stakedTokens.push(stakedToken);
1298 
1299             // Increment the amount staked for this wallet
1300             stakers[msg.sender].amountStaked++;
1301 
1302             // Update the mapping of the tokenId to the staker's address
1303             stakerAddress[_tokenId] = msg.sender;
1304 
1305             // Update the timeOfLastUpdate for the staker   
1306             stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1307         }
1308     }
1309     
1310     // Check if user has any ERC721 Tokens Staked and if they tried to withdraw,
1311     // calculate the rewards and store them in the unclaimedRewards
1312     // decrement the amountStaked of the user and transfer the ERC721 token back to them
1313     function withdraw(uint256 _tokenId) external nonReentrant {
1314         // Make sure the user has at least one token staked before withdrawing
1315         require(
1316             stakers[msg.sender].amountStaked > 0,
1317             "You have no tokens staked"
1318         );
1319         
1320         // Wallet must own the token they are trying to withdraw
1321         require(stakerAddress[_tokenId] == msg.sender, "You don't own this token!");
1322         // Update the rewards for this user, as the amount of rewards decreases with less tokens.
1323         uint256 rewards = calculateRewards(msg.sender);
1324         stakers[msg.sender].unclaimedRewards += rewards;
1325 
1326         // Find the index of this token id in the stakedTokens array
1327         uint256 index = 0;
1328         unchecked {
1329             for (uint256 i = 0; i < stakers[msg.sender].stakedTokens.length; i++) {
1330                 if (stakers[msg.sender].stakedTokens[i].tokenId == _tokenId) {
1331                     index = i;
1332                     break;
1333                 }
1334             }
1335         }
1336 
1337         require(stakers[msg.sender].stakedTokens[index].tokenStoreTime + (minimumStakingTime * 1 hours) <= block.timestamp, "You cannot withdraw before minimum staking time is passed !");
1338         // Set this token's .staker to be address 0 to mark it as no longer staked
1339         stakers[msg.sender].stakedTokens[index].staker = address(0);
1340 
1341         // Decrement the amount staked for this wallet
1342         stakers[msg.sender].amountStaked--;
1343 
1344         // Update the mapping of the tokenId to the be address(0) to indicate that the token is no longer staked
1345         stakerAddress[_tokenId] = address(0);
1346 
1347         // Transfer the token back to the withdrawer
1348         nftCollection.transferFrom(address(this), msg.sender, _tokenId);
1349 
1350         // Update the timeOfLastUpdate for the withdrawer   
1351         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1352     }
1353 
1354     // Calculate rewards for the msg.sender, check if there are any rewards
1355     // claim, set unclaimedRewards to 0 and transfer the ERC20 Reward token
1356     // to the user.
1357     function claimRewards() external {
1358         uint256 rewards = calculateRewards(msg.sender) +
1359             stakers[msg.sender].unclaimedRewards;
1360         require(rewards > 0, "You have no rewards to claim");
1361         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1362         stakers[msg.sender].unclaimedRewards = 0;
1363         rewardsToken.safeTransfer(msg.sender, rewards);
1364     }
1365 
1366 
1367     //////////
1368     // View //
1369     //////////
1370 
1371     function availableRewards(address _staker) public view returns (uint256) {
1372         uint256 rewards = calculateRewards(_staker) +
1373             stakers[_staker].unclaimedRewards;
1374         return rewards;
1375     }
1376 
1377     function getStakedTokens(address _user) public view returns (StakedToken[] memory) {
1378         // Check if we know this user
1379         if (stakers[_user].amountStaked > 0) {
1380             unchecked {
1381                     // Return all the tokens in the stakedToken Array for this user that are not -1
1382                 StakedToken[] memory _stakedTokens = new StakedToken[](stakers[_user].amountStaked);
1383                 uint256 _index = 0;
1384 
1385                 for (uint256 j = 0; j < stakers[_user].stakedTokens.length; j++) {
1386                     if (stakers[_user].stakedTokens[j].staker != (address(0))) {
1387                         _stakedTokens[_index] = stakers[_user].stakedTokens[j];
1388                         _index++;
1389                     }
1390                 }
1391 
1392                 return _stakedTokens;
1393             }
1394         }
1395         
1396         // Otherwise, return empty array
1397         else {
1398             return new StakedToken[](0);
1399         }
1400     }
1401 
1402     /////////////
1403     // Internal//
1404     /////////////
1405 
1406     // Calculate rewards for param _staker by calculating the time passed
1407     // since last update in hours and mulitplying it to ERC721 Tokens Staked
1408     // and rewardsPerHour.
1409     function calculateRewards(address _staker)
1410         internal
1411         view
1412         returns (uint256 _rewards)
1413     {
1414         return (((
1415             ((block.timestamp - stakers[_staker].timeOfLastUpdate) *
1416                 stakers[_staker].amountStaked)
1417         ) * rewardsPerHour) / 3600);
1418     }
1419 }