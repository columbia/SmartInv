1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Strings.sol
3 
4 
5 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev String operations.
11  */
12 library Strings {
13     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
14     uint8 private constant _ADDRESS_LENGTH = 20;
15 
16     /**
17      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
18      */
19     function toString(uint256 value) internal pure returns (string memory) {
20         // Inspired by OraclizeAPI's implementation - MIT licence
21         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
22 
23         if (value == 0) {
24             return "0";
25         }
26         uint256 temp = value;
27         uint256 digits;
28         while (temp != 0) {
29             digits++;
30             temp /= 10;
31         }
32         bytes memory buffer = new bytes(digits);
33         while (value != 0) {
34             digits -= 1;
35             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
36             value /= 10;
37         }
38         return string(buffer);
39     }
40 
41     /**
42      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
43      */
44     function toHexString(uint256 value) internal pure returns (string memory) {
45         if (value == 0) {
46             return "0x00";
47         }
48         uint256 temp = value;
49         uint256 length = 0;
50         while (temp != 0) {
51             length++;
52             temp >>= 8;
53         }
54         return toHexString(value, length);
55     }
56 
57     /**
58      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
59      */
60     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
61         bytes memory buffer = new bytes(2 * length + 2);
62         buffer[0] = "0";
63         buffer[1] = "x";
64         for (uint256 i = 2 * length + 1; i > 1; --i) {
65             buffer[i] = _HEX_SYMBOLS[value & 0xf];
66             value >>= 4;
67         }
68         require(value == 0, "Strings: hex length insufficient");
69         return string(buffer);
70     }
71 
72     /**
73      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
74      */
75     function toHexString(address addr) internal pure returns (string memory) {
76         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
77     }
78 }
79 
80 // File: @openzeppelin/contracts/utils/Context.sol
81 
82 
83 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
84 
85 pragma solidity ^0.8.0;
86 
87 /**
88  * @dev Provides information about the current execution context, including the
89  * sender of the transaction and its data. While these are generally available
90  * via msg.sender and msg.data, they should not be accessed in such a direct
91  * manner, since when dealing with meta-transactions the account sending and
92  * paying for execution may not be the actual sender (as far as an application
93  * is concerned).
94  *
95  * This contract is only required for intermediate, library-like contracts.
96  */
97 abstract contract Context {
98     function _msgSender() internal view virtual returns (address) {
99         return msg.sender;
100     }
101 
102     function _msgData() internal view virtual returns (bytes calldata) {
103         return msg.data;
104     }
105 }
106 
107 // File: @openzeppelin/contracts/access/IAccessControl.sol
108 
109 
110 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
111 
112 pragma solidity ^0.8.0;
113 
114 /**
115  * @dev External interface of AccessControl declared to support ERC165 detection.
116  */
117 interface IAccessControl {
118     /**
119      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
120      *
121      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
122      * {RoleAdminChanged} not being emitted signaling this.
123      *
124      * _Available since v3.1._
125      */
126     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
127 
128     /**
129      * @dev Emitted when `account` is granted `role`.
130      *
131      * `sender` is the account that originated the contract call, an admin role
132      * bearer except when using {AccessControl-_setupRole}.
133      */
134     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
135 
136     /**
137      * @dev Emitted when `account` is revoked `role`.
138      *
139      * `sender` is the account that originated the contract call:
140      *   - if using `revokeRole`, it is the admin role bearer
141      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
142      */
143     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
144 
145     /**
146      * @dev Returns `true` if `account` has been granted `role`.
147      */
148     function hasRole(bytes32 role, address account) external view returns (bool);
149 
150     /**
151      * @dev Returns the admin role that controls `role`. See {grantRole} and
152      * {revokeRole}.
153      *
154      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
155      */
156     function getRoleAdmin(bytes32 role) external view returns (bytes32);
157 
158     /**
159      * @dev Grants `role` to `account`.
160      *
161      * If `account` had not been already granted `role`, emits a {RoleGranted}
162      * event.
163      *
164      * Requirements:
165      *
166      * - the caller must have ``role``'s admin role.
167      */
168     function grantRole(bytes32 role, address account) external;
169 
170     /**
171      * @dev Revokes `role` from `account`.
172      *
173      * If `account` had been granted `role`, emits a {RoleRevoked} event.
174      *
175      * Requirements:
176      *
177      * - the caller must have ``role``'s admin role.
178      */
179     function revokeRole(bytes32 role, address account) external;
180 
181     /**
182      * @dev Revokes `role` from the calling account.
183      *
184      * Roles are often managed via {grantRole} and {revokeRole}: this function's
185      * purpose is to provide a mechanism for accounts to lose their privileges
186      * if they are compromised (such as when a trusted device is misplaced).
187      *
188      * If the calling account had been granted `role`, emits a {RoleRevoked}
189      * event.
190      *
191      * Requirements:
192      *
193      * - the caller must be `account`.
194      */
195     function renounceRole(bytes32 role, address account) external;
196 }
197 
198 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
199 
200 
201 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
202 
203 pragma solidity ^0.8.0;
204 
205 /**
206  * @dev Contract module that helps prevent reentrant calls to a function.
207  *
208  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
209  * available, which can be applied to functions to make sure there are no nested
210  * (reentrant) calls to them.
211  *
212  * Note that because there is a single `nonReentrant` guard, functions marked as
213  * `nonReentrant` may not call one another. This can be worked around by making
214  * those functions `private`, and then adding `external` `nonReentrant` entry
215  * points to them.
216  *
217  * TIP: If you would like to learn more about reentrancy and alternative ways
218  * to protect against it, check out our blog post
219  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
220  */
221 abstract contract ReentrancyGuard {
222     // Booleans are more expensive than uint256 or any type that takes up a full
223     // word because each write operation emits an extra SLOAD to first read the
224     // slot's contents, replace the bits taken up by the boolean, and then write
225     // back. This is the compiler's defense against contract upgrades and
226     // pointer aliasing, and it cannot be disabled.
227 
228     // The values being non-zero value makes deployment a bit more expensive,
229     // but in exchange the refund on every call to nonReentrant will be lower in
230     // amount. Since refunds are capped to a percentage of the total
231     // transaction's gas, it is best to keep them low in cases like this one, to
232     // increase the likelihood of the full refund coming into effect.
233     uint256 private constant _NOT_ENTERED = 1;
234     uint256 private constant _ENTERED = 2;
235 
236     uint256 private _status;
237 
238     constructor() {
239         _status = _NOT_ENTERED;
240     }
241 
242     /**
243      * @dev Prevents a contract from calling itself, directly or indirectly.
244      * Calling a `nonReentrant` function from another `nonReentrant`
245      * function is not supported. It is possible to prevent this from happening
246      * by making the `nonReentrant` function external, and making it call a
247      * `private` function that does the actual work.
248      */
249     modifier nonReentrant() {
250         // On the first call to nonReentrant, _notEntered will be true
251         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
252 
253         // Any calls to nonReentrant after this point will fail
254         _status = _ENTERED;
255 
256         _;
257 
258         // By storing the original value once again, a refund is triggered (see
259         // https://eips.ethereum.org/EIPS/eip-2200)
260         _status = _NOT_ENTERED;
261     }
262 }
263 
264 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
265 
266 
267 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
268 
269 pragma solidity ^0.8.0;
270 
271 /**
272  * @dev Interface of the ERC165 standard, as defined in the
273  * https://eips.ethereum.org/EIPS/eip-165[EIP].
274  *
275  * Implementers can declare support of contract interfaces, which can then be
276  * queried by others ({ERC165Checker}).
277  *
278  * For an implementation, see {ERC165}.
279  */
280 interface IERC165 {
281     /**
282      * @dev Returns true if this contract implements the interface defined by
283      * `interfaceId`. See the corresponding
284      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
285      * to learn more about how these ids are created.
286      *
287      * This function call must use less than 30 000 gas.
288      */
289     function supportsInterface(bytes4 interfaceId) external view returns (bool);
290 }
291 
292 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
293 
294 
295 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
296 
297 pragma solidity ^0.8.0;
298 
299 
300 /**
301  * @dev Implementation of the {IERC165} interface.
302  *
303  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
304  * for the additional interface id that will be supported. For example:
305  *
306  * ```solidity
307  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
308  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
309  * }
310  * ```
311  *
312  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
313  */
314 abstract contract ERC165 is IERC165 {
315     /**
316      * @dev See {IERC165-supportsInterface}.
317      */
318     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
319         return interfaceId == type(IERC165).interfaceId;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/access/AccessControl.sol
324 
325 
326 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
327 
328 pragma solidity ^0.8.0;
329 
330 
331 
332 
333 
334 /**
335  * @dev Contract module that allows children to implement role-based access
336  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
337  * members except through off-chain means by accessing the contract event logs. Some
338  * applications may benefit from on-chain enumerability, for those cases see
339  * {AccessControlEnumerable}.
340  *
341  * Roles are referred to by their `bytes32` identifier. These should be exposed
342  * in the external API and be unique. The best way to achieve this is by
343  * using `public constant` hash digests:
344  *
345  * ```
346  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
347  * ```
348  *
349  * Roles can be used to represent a set of permissions. To restrict access to a
350  * function call, use {hasRole}:
351  *
352  * ```
353  * function foo() public {
354  *     require(hasRole(MY_ROLE, msg.sender));
355  *     ...
356  * }
357  * ```
358  *
359  * Roles can be granted and revoked dynamically via the {grantRole} and
360  * {revokeRole} functions. Each role has an associated admin role, and only
361  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
362  *
363  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
364  * that only accounts with this role will be able to grant or revoke other
365  * roles. More complex role relationships can be created by using
366  * {_setRoleAdmin}.
367  *
368  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
369  * grant and revoke this role. Extra precautions should be taken to secure
370  * accounts that have been granted it.
371  */
372 abstract contract AccessControl is Context, IAccessControl, ERC165 {
373     struct RoleData {
374         mapping(address => bool) members;
375         bytes32 adminRole;
376     }
377 
378     mapping(bytes32 => RoleData) private _roles;
379 
380     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
381 
382     /**
383      * @dev Modifier that checks that an account has a specific role. Reverts
384      * with a standardized message including the required role.
385      *
386      * The format of the revert reason is given by the following regular expression:
387      *
388      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
389      *
390      * _Available since v4.1._
391      */
392     modifier onlyRole(bytes32 role) {
393         _checkRole(role);
394         _;
395     }
396 
397     /**
398      * @dev See {IERC165-supportsInterface}.
399      */
400     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
401         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
402     }
403 
404     /**
405      * @dev Returns `true` if `account` has been granted `role`.
406      */
407     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
408         return _roles[role].members[account];
409     }
410 
411     /**
412      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
413      * Overriding this function changes the behavior of the {onlyRole} modifier.
414      *
415      * Format of the revert message is described in {_checkRole}.
416      *
417      * _Available since v4.6._
418      */
419     function _checkRole(bytes32 role) internal view virtual {
420         _checkRole(role, _msgSender());
421     }
422 
423     /**
424      * @dev Revert with a standard message if `account` is missing `role`.
425      *
426      * The format of the revert reason is given by the following regular expression:
427      *
428      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
429      */
430     function _checkRole(bytes32 role, address account) internal view virtual {
431         if (!hasRole(role, account)) {
432             revert(
433                 string(
434                     abi.encodePacked(
435                         "AccessControl: account ",
436                         Strings.toHexString(uint160(account), 20),
437                         " is missing role ",
438                         Strings.toHexString(uint256(role), 32)
439                     )
440                 )
441             );
442         }
443     }
444 
445     /**
446      * @dev Returns the admin role that controls `role`. See {grantRole} and
447      * {revokeRole}.
448      *
449      * To change a role's admin, use {_setRoleAdmin}.
450      */
451     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
452         return _roles[role].adminRole;
453     }
454 
455     /**
456      * @dev Grants `role` to `account`.
457      *
458      * If `account` had not been already granted `role`, emits a {RoleGranted}
459      * event.
460      *
461      * Requirements:
462      *
463      * - the caller must have ``role``'s admin role.
464      *
465      * May emit a {RoleGranted} event.
466      */
467     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
468         _grantRole(role, account);
469     }
470 
471     /**
472      * @dev Revokes `role` from `account`.
473      *
474      * If `account` had been granted `role`, emits a {RoleRevoked} event.
475      *
476      * Requirements:
477      *
478      * - the caller must have ``role``'s admin role.
479      *
480      * May emit a {RoleRevoked} event.
481      */
482     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
483         _revokeRole(role, account);
484     }
485 
486     /**
487      * @dev Revokes `role` from the calling account.
488      *
489      * Roles are often managed via {grantRole} and {revokeRole}: this function's
490      * purpose is to provide a mechanism for accounts to lose their privileges
491      * if they are compromised (such as when a trusted device is misplaced).
492      *
493      * If the calling account had been revoked `role`, emits a {RoleRevoked}
494      * event.
495      *
496      * Requirements:
497      *
498      * - the caller must be `account`.
499      *
500      * May emit a {RoleRevoked} event.
501      */
502     function renounceRole(bytes32 role, address account) public virtual override {
503         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
504 
505         _revokeRole(role, account);
506     }
507 
508     /**
509      * @dev Grants `role` to `account`.
510      *
511      * If `account` had not been already granted `role`, emits a {RoleGranted}
512      * event. Note that unlike {grantRole}, this function doesn't perform any
513      * checks on the calling account.
514      *
515      * May emit a {RoleGranted} event.
516      *
517      * [WARNING]
518      * ====
519      * This function should only be called from the constructor when setting
520      * up the initial roles for the system.
521      *
522      * Using this function in any other way is effectively circumventing the admin
523      * system imposed by {AccessControl}.
524      * ====
525      *
526      * NOTE: This function is deprecated in favor of {_grantRole}.
527      */
528     function _setupRole(bytes32 role, address account) internal virtual {
529         _grantRole(role, account);
530     }
531 
532     /**
533      * @dev Sets `adminRole` as ``role``'s admin role.
534      *
535      * Emits a {RoleAdminChanged} event.
536      */
537     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
538         bytes32 previousAdminRole = getRoleAdmin(role);
539         _roles[role].adminRole = adminRole;
540         emit RoleAdminChanged(role, previousAdminRole, adminRole);
541     }
542 
543     /**
544      * @dev Grants `role` to `account`.
545      *
546      * Internal function without access restriction.
547      *
548      * May emit a {RoleGranted} event.
549      */
550     function _grantRole(bytes32 role, address account) internal virtual {
551         if (!hasRole(role, account)) {
552             _roles[role].members[account] = true;
553             emit RoleGranted(role, account, _msgSender());
554         }
555     }
556 
557     /**
558      * @dev Revokes `role` from `account`.
559      *
560      * Internal function without access restriction.
561      *
562      * May emit a {RoleRevoked} event.
563      */
564     function _revokeRole(bytes32 role, address account) internal virtual {
565         if (hasRole(role, account)) {
566             _roles[role].members[account] = false;
567             emit RoleRevoked(role, account, _msgSender());
568         }
569     }
570 }
571 
572 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
573 
574 
575 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
576 
577 pragma solidity ^0.8.0;
578 
579 
580 /**
581  * @dev Required interface of an ERC721 compliant contract.
582  */
583 interface IERC721 is IERC165 {
584     /**
585      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
586      */
587     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
588 
589     /**
590      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
591      */
592     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
593 
594     /**
595      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
596      */
597     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
598 
599     /**
600      * @dev Returns the number of tokens in ``owner``'s account.
601      */
602     function balanceOf(address owner) external view returns (uint256 balance);
603 
604     /**
605      * @dev Returns the owner of the `tokenId` token.
606      *
607      * Requirements:
608      *
609      * - `tokenId` must exist.
610      */
611     function ownerOf(uint256 tokenId) external view returns (address owner);
612 
613     /**
614      * @dev Safely transfers `tokenId` token from `from` to `to`.
615      *
616      * Requirements:
617      *
618      * - `from` cannot be the zero address.
619      * - `to` cannot be the zero address.
620      * - `tokenId` token must exist and be owned by `from`.
621      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
622      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
623      *
624      * Emits a {Transfer} event.
625      */
626     function safeTransferFrom(
627         address from,
628         address to,
629         uint256 tokenId,
630         bytes calldata data
631     ) external;
632 
633     /**
634      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
635      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
636      *
637      * Requirements:
638      *
639      * - `from` cannot be the zero address.
640      * - `to` cannot be the zero address.
641      * - `tokenId` token must exist and be owned by `from`.
642      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
643      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
644      *
645      * Emits a {Transfer} event.
646      */
647     function safeTransferFrom(
648         address from,
649         address to,
650         uint256 tokenId
651     ) external;
652 
653     /**
654      * @dev Transfers `tokenId` token from `from` to `to`.
655      *
656      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
657      *
658      * Requirements:
659      *
660      * - `from` cannot be the zero address.
661      * - `to` cannot be the zero address.
662      * - `tokenId` token must be owned by `from`.
663      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
664      *
665      * Emits a {Transfer} event.
666      */
667     function transferFrom(
668         address from,
669         address to,
670         uint256 tokenId
671     ) external;
672 
673     /**
674      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
675      * The approval is cleared when the token is transferred.
676      *
677      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
678      *
679      * Requirements:
680      *
681      * - The caller must own the token or be an approved operator.
682      * - `tokenId` must exist.
683      *
684      * Emits an {Approval} event.
685      */
686     function approve(address to, uint256 tokenId) external;
687 
688     /**
689      * @dev Approve or remove `operator` as an operator for the caller.
690      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
691      *
692      * Requirements:
693      *
694      * - The `operator` cannot be the caller.
695      *
696      * Emits an {ApprovalForAll} event.
697      */
698     function setApprovalForAll(address operator, bool _approved) external;
699 
700     /**
701      * @dev Returns the account approved for `tokenId` token.
702      *
703      * Requirements:
704      *
705      * - `tokenId` must exist.
706      */
707     function getApproved(uint256 tokenId) external view returns (address operator);
708 
709     /**
710      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
711      *
712      * See {setApprovalForAll}
713      */
714     function isApprovedForAll(address owner, address operator) external view returns (bool);
715 }
716 
717 // File: @openzeppelin/contracts/utils/Address.sol
718 
719 
720 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)
721 
722 pragma solidity ^0.8.1;
723 
724 /**
725  * @dev Collection of functions related to the address type
726  */
727 library Address {
728     /**
729      * @dev Returns true if `account` is a contract.
730      *
731      * [IMPORTANT]
732      * ====
733      * It is unsafe to assume that an address for which this function returns
734      * false is an externally-owned account (EOA) and not a contract.
735      *
736      * Among others, `isContract` will return false for the following
737      * types of addresses:
738      *
739      *  - an externally-owned account
740      *  - a contract in construction
741      *  - an address where a contract will be created
742      *  - an address where a contract lived, but was destroyed
743      * ====
744      *
745      * [IMPORTANT]
746      * ====
747      * You shouldn't rely on `isContract` to protect against flash loan attacks!
748      *
749      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
750      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
751      * constructor.
752      * ====
753      */
754     function isContract(address account) internal view returns (bool) {
755         // This method relies on extcodesize/address.code.length, which returns 0
756         // for contracts in construction, since the code is only stored at the end
757         // of the constructor execution.
758 
759         return account.code.length > 0;
760     }
761 
762     /**
763      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
764      * `recipient`, forwarding all available gas and reverting on errors.
765      *
766      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
767      * of certain opcodes, possibly making contracts go over the 2300 gas limit
768      * imposed by `transfer`, making them unable to receive funds via
769      * `transfer`. {sendValue} removes this limitation.
770      *
771      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
772      *
773      * IMPORTANT: because control is transferred to `recipient`, care must be
774      * taken to not create reentrancy vulnerabilities. Consider using
775      * {ReentrancyGuard} or the
776      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
777      */
778     function sendValue(address payable recipient, uint256 amount) internal {
779         require(address(this).balance >= amount, "Address: insufficient balance");
780 
781         (bool success, ) = recipient.call{value: amount}("");
782         require(success, "Address: unable to send value, recipient may have reverted");
783     }
784 
785     /**
786      * @dev Performs a Solidity function call using a low level `call`. A
787      * plain `call` is an unsafe replacement for a function call: use this
788      * function instead.
789      *
790      * If `target` reverts with a revert reason, it is bubbled up by this
791      * function (like regular Solidity function calls).
792      *
793      * Returns the raw returned data. To convert to the expected return value,
794      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
795      *
796      * Requirements:
797      *
798      * - `target` must be a contract.
799      * - calling `target` with `data` must not revert.
800      *
801      * _Available since v3.1._
802      */
803     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
804         return functionCall(target, data, "Address: low-level call failed");
805     }
806 
807     /**
808      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
809      * `errorMessage` as a fallback revert reason when `target` reverts.
810      *
811      * _Available since v3.1._
812      */
813     function functionCall(
814         address target,
815         bytes memory data,
816         string memory errorMessage
817     ) internal returns (bytes memory) {
818         return functionCallWithValue(target, data, 0, errorMessage);
819     }
820 
821     /**
822      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
823      * but also transferring `value` wei to `target`.
824      *
825      * Requirements:
826      *
827      * - the calling contract must have an ETH balance of at least `value`.
828      * - the called Solidity function must be `payable`.
829      *
830      * _Available since v3.1._
831      */
832     function functionCallWithValue(
833         address target,
834         bytes memory data,
835         uint256 value
836     ) internal returns (bytes memory) {
837         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
838     }
839 
840     /**
841      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
842      * with `errorMessage` as a fallback revert reason when `target` reverts.
843      *
844      * _Available since v3.1._
845      */
846     function functionCallWithValue(
847         address target,
848         bytes memory data,
849         uint256 value,
850         string memory errorMessage
851     ) internal returns (bytes memory) {
852         require(address(this).balance >= value, "Address: insufficient balance for call");
853         require(isContract(target), "Address: call to non-contract");
854 
855         (bool success, bytes memory returndata) = target.call{value: value}(data);
856         return verifyCallResult(success, returndata, errorMessage);
857     }
858 
859     /**
860      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
861      * but performing a static call.
862      *
863      * _Available since v3.3._
864      */
865     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
866         return functionStaticCall(target, data, "Address: low-level static call failed");
867     }
868 
869     /**
870      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
871      * but performing a static call.
872      *
873      * _Available since v3.3._
874      */
875     function functionStaticCall(
876         address target,
877         bytes memory data,
878         string memory errorMessage
879     ) internal view returns (bytes memory) {
880         require(isContract(target), "Address: static call to non-contract");
881 
882         (bool success, bytes memory returndata) = target.staticcall(data);
883         return verifyCallResult(success, returndata, errorMessage);
884     }
885 
886     /**
887      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
888      * but performing a delegate call.
889      *
890      * _Available since v3.4._
891      */
892     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
893         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
894     }
895 
896     /**
897      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
898      * but performing a delegate call.
899      *
900      * _Available since v3.4._
901      */
902     function functionDelegateCall(
903         address target,
904         bytes memory data,
905         string memory errorMessage
906     ) internal returns (bytes memory) {
907         require(isContract(target), "Address: delegate call to non-contract");
908 
909         (bool success, bytes memory returndata) = target.delegatecall(data);
910         return verifyCallResult(success, returndata, errorMessage);
911     }
912 
913     /**
914      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
915      * revert reason using the provided one.
916      *
917      * _Available since v4.3._
918      */
919     function verifyCallResult(
920         bool success,
921         bytes memory returndata,
922         string memory errorMessage
923     ) internal pure returns (bytes memory) {
924         if (success) {
925             return returndata;
926         } else {
927             // Look for revert reason and bubble it up if present
928             if (returndata.length > 0) {
929                 // The easiest way to bubble the revert reason is using memory via assembly
930                 /// @solidity memory-safe-assembly
931                 assembly {
932                     let returndata_size := mload(returndata)
933                     revert(add(32, returndata), returndata_size)
934                 }
935             } else {
936                 revert(errorMessage);
937             }
938         }
939     }
940 }
941 
942 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
943 
944 
945 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
946 
947 pragma solidity ^0.8.0;
948 
949 /**
950  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
951  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
952  *
953  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
954  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
955  * need to send a transaction, and thus is not required to hold Ether at all.
956  */
957 interface IERC20Permit {
958     /**
959      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
960      * given ``owner``'s signed approval.
961      *
962      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
963      * ordering also apply here.
964      *
965      * Emits an {Approval} event.
966      *
967      * Requirements:
968      *
969      * - `spender` cannot be the zero address.
970      * - `deadline` must be a timestamp in the future.
971      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
972      * over the EIP712-formatted function arguments.
973      * - the signature must use ``owner``'s current nonce (see {nonces}).
974      *
975      * For more information on the signature format, see the
976      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
977      * section].
978      */
979     function permit(
980         address owner,
981         address spender,
982         uint256 value,
983         uint256 deadline,
984         uint8 v,
985         bytes32 r,
986         bytes32 s
987     ) external;
988 
989     /**
990      * @dev Returns the current nonce for `owner`. This value must be
991      * included whenever a signature is generated for {permit}.
992      *
993      * Every successful call to {permit} increases ``owner``'s nonce by one. This
994      * prevents a signature from being used multiple times.
995      */
996     function nonces(address owner) external view returns (uint256);
997 
998     /**
999      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
1000      */
1001     // solhint-disable-next-line func-name-mixedcase
1002     function DOMAIN_SEPARATOR() external view returns (bytes32);
1003 }
1004 
1005 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
1006 
1007 
1008 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
1009 
1010 pragma solidity ^0.8.0;
1011 
1012 /**
1013  * @dev Interface of the ERC20 standard as defined in the EIP.
1014  */
1015 interface IERC20 {
1016     /**
1017      * @dev Emitted when `value` tokens are moved from one account (`from`) to
1018      * another (`to`).
1019      *
1020      * Note that `value` may be zero.
1021      */
1022     event Transfer(address indexed from, address indexed to, uint256 value);
1023 
1024     /**
1025      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
1026      * a call to {approve}. `value` is the new allowance.
1027      */
1028     event Approval(address indexed owner, address indexed spender, uint256 value);
1029 
1030     /**
1031      * @dev Returns the amount of tokens in existence.
1032      */
1033     function totalSupply() external view returns (uint256);
1034 
1035     /**
1036      * @dev Returns the amount of tokens owned by `account`.
1037      */
1038     function balanceOf(address account) external view returns (uint256);
1039 
1040     /**
1041      * @dev Moves `amount` tokens from the caller's account to `to`.
1042      *
1043      * Returns a boolean value indicating whether the operation succeeded.
1044      *
1045      * Emits a {Transfer} event.
1046      */
1047     function transfer(address to, uint256 amount) external returns (bool);
1048 
1049     /**
1050      * @dev Returns the remaining number of tokens that `spender` will be
1051      * allowed to spend on behalf of `owner` through {transferFrom}. This is
1052      * zero by default.
1053      *
1054      * This value changes when {approve} or {transferFrom} are called.
1055      */
1056     function allowance(address owner, address spender) external view returns (uint256);
1057 
1058     /**
1059      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
1060      *
1061      * Returns a boolean value indicating whether the operation succeeded.
1062      *
1063      * IMPORTANT: Beware that changing an allowance with this method brings the risk
1064      * that someone may use both the old and the new allowance by unfortunate
1065      * transaction ordering. One possible solution to mitigate this race
1066      * condition is to first reduce the spender's allowance to 0 and set the
1067      * desired value afterwards:
1068      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1069      *
1070      * Emits an {Approval} event.
1071      */
1072     function approve(address spender, uint256 amount) external returns (bool);
1073 
1074     /**
1075      * @dev Moves `amount` tokens from `from` to `to` using the
1076      * allowance mechanism. `amount` is then deducted from the caller's
1077      * allowance.
1078      *
1079      * Returns a boolean value indicating whether the operation succeeded.
1080      *
1081      * Emits a {Transfer} event.
1082      */
1083     function transferFrom(
1084         address from,
1085         address to,
1086         uint256 amount
1087     ) external returns (bool);
1088 }
1089 
1090 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
1091 
1092 
1093 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)
1094 
1095 pragma solidity ^0.8.0;
1096 
1097 
1098 
1099 
1100 /**
1101  * @title SafeERC20
1102  * @dev Wrappers around ERC20 operations that throw on failure (when the token
1103  * contract returns false). Tokens that return no value (and instead revert or
1104  * throw on failure) are also supported, non-reverting calls are assumed to be
1105  * successful.
1106  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
1107  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1108  */
1109 library SafeERC20 {
1110     using Address for address;
1111 
1112     function safeTransfer(
1113         IERC20 token,
1114         address to,
1115         uint256 value
1116     ) internal {
1117         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
1118     }
1119 
1120     function safeTransferFrom(
1121         IERC20 token,
1122         address from,
1123         address to,
1124         uint256 value
1125     ) internal {
1126         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
1127     }
1128 
1129     /**
1130      * @dev Deprecated. This function has issues similar to the ones found in
1131      * {IERC20-approve}, and its usage is discouraged.
1132      *
1133      * Whenever possible, use {safeIncreaseAllowance} and
1134      * {safeDecreaseAllowance} instead.
1135      */
1136     function safeApprove(
1137         IERC20 token,
1138         address spender,
1139         uint256 value
1140     ) internal {
1141         // safeApprove should only be called when setting an initial allowance,
1142         // or when resetting it to zero. To increase and decrease it, use
1143         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
1144         require(
1145             (value == 0) || (token.allowance(address(this), spender) == 0),
1146             "SafeERC20: approve from non-zero to non-zero allowance"
1147         );
1148         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
1149     }
1150 
1151     function safeIncreaseAllowance(
1152         IERC20 token,
1153         address spender,
1154         uint256 value
1155     ) internal {
1156         uint256 newAllowance = token.allowance(address(this), spender) + value;
1157         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1158     }
1159 
1160     function safeDecreaseAllowance(
1161         IERC20 token,
1162         address spender,
1163         uint256 value
1164     ) internal {
1165         unchecked {
1166             uint256 oldAllowance = token.allowance(address(this), spender);
1167             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
1168             uint256 newAllowance = oldAllowance - value;
1169             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
1170         }
1171     }
1172 
1173     function safePermit(
1174         IERC20Permit token,
1175         address owner,
1176         address spender,
1177         uint256 value,
1178         uint256 deadline,
1179         uint8 v,
1180         bytes32 r,
1181         bytes32 s
1182     ) internal {
1183         uint256 nonceBefore = token.nonces(owner);
1184         token.permit(owner, spender, value, deadline, v, r, s);
1185         uint256 nonceAfter = token.nonces(owner);
1186         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
1187     }
1188 
1189     /**
1190      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
1191      * on the return value: the return value is optional (but if data is returned, it must not be false).
1192      * @param token The token targeted by the call.
1193      * @param data The call data (encoded using abi.encode or one of its variants).
1194      */
1195     function _callOptionalReturn(IERC20 token, bytes memory data) private {
1196         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
1197         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
1198         // the target address contains contract code and also asserts for success in the low-level call.
1199 
1200         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
1201         if (returndata.length > 0) {
1202             // Return data is optional
1203             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
1204         }
1205     }
1206 }
1207 
1208 // File: contracts/WagmiStaking.sol
1209 
1210 
1211 pragma solidity ^0.8.4;
1212 
1213 
1214 
1215 
1216 
1217 
1218 contract WagmiStaking is ReentrancyGuard, AccessControl {
1219     using SafeERC20 for IERC20;
1220 
1221     // Interfaces for ERC20 and ERC721
1222     IERC20 public immutable rewardsToken;
1223     IERC721 public immutable nftCollection;
1224     uint256 public minimumStakingTime = 168;
1225 
1226     // Constructor function to set the rewards token and the NFT collection addresses
1227     constructor(IERC721 _nftCollection, IERC20 _rewardsToken) {
1228         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
1229         nftCollection = _nftCollection;
1230         rewardsToken = _rewardsToken;
1231     }
1232 
1233     struct StakedToken {
1234         address staker;
1235         uint256 tokenId;
1236         uint256 tokenStoreTime;
1237     }
1238     
1239     // Staker info
1240     struct Staker {
1241         // Amount of tokens staked by the staker
1242         uint256 amountStaked;
1243 
1244         // Staked token ids
1245         StakedToken[] stakedTokens;
1246 
1247         // Last time of the rewards were calculated for this user
1248         uint256 timeOfLastUpdate;
1249         uint256 timeOfStake;
1250 
1251         // Calculated, but unclaimed rewards for the User. The rewards are
1252         // calculated each time the user writes to the Smart Contract
1253         uint256 unclaimedRewards;
1254     }
1255 
1256     // Rewards per hour per token deposited in wei.
1257     uint256 private rewardsPerHour = 1000000000000000000;
1258 
1259     // Mapping of User Address to Staker info
1260     mapping(address => Staker) public stakers;
1261 
1262     // Mapping of Token Id to staker. Made for the SC to remeber
1263     // who to send back the ERC721 Token to.
1264     mapping(uint256 => address) public stakerAddress;
1265 
1266 
1267     function setMinimumStakingHours (uint _hours) public onlyRole(DEFAULT_ADMIN_ROLE) {
1268         minimumStakingTime = _hours;
1269     }
1270 
1271     function setRewardPerHour (uint _reward) public onlyRole(DEFAULT_ADMIN_ROLE) {
1272         rewardsPerHour = _reward;
1273     }
1274 
1275     // If address already has ERC721 Token/s staked, calculate the rewards.
1276     // Increment the amountStaked and map msg.sender to the Token Id of the staked
1277     // Token to later send back on withdrawal. Finally give timeOfLastUpdate the
1278     // value of now.
1279     function stake(uint256[] calldata _tokenIds) external nonReentrant {
1280         // If wallet has tokens staked, calculate the rewards before adding the new token
1281         if (stakers[msg.sender].amountStaked > 0) {
1282             uint256 rewards = calculateRewards(msg.sender);
1283             stakers[msg.sender].unclaimedRewards += rewards;
1284         }
1285  
1286         unchecked {
1287             for (uint256 i = 0; i < _tokenIds.length; i++) {
1288                 _stake(_tokenIds[i]);
1289             }
1290         }
1291 
1292         // Update the timeOfLastUpdate for the staker   
1293         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1294     }
1295 
1296     function _stake(uint _tokenId) internal {
1297         // Wallet must own the token they are trying to stake
1298         require(
1299             nftCollection.ownerOf(_tokenId) == msg.sender,
1300             "You don't own this token!"
1301         );
1302 
1303         unchecked {
1304                 // Transfer the token from the wallet to the Smart contract
1305             nftCollection.transferFrom(msg.sender, address(this), _tokenId);
1306 
1307             // Create StakedToken
1308             StakedToken memory stakedToken = StakedToken(msg.sender, _tokenId, block.timestamp);
1309 
1310             // Add the token to the stakedTokens array
1311             stakers[msg.sender].stakedTokens.push(stakedToken);
1312 
1313             // Increment the amount staked for this wallet
1314             stakers[msg.sender].amountStaked++;
1315 
1316             // Update the mapping of the tokenId to the staker's address
1317             stakerAddress[_tokenId] = msg.sender;
1318         }
1319     }
1320 
1321     function withdraw(uint256[] calldata _tokenIds) external nonReentrant {
1322          // Make sure the user has at least one token staked before withdrawing
1323         require(
1324             stakers[msg.sender].amountStaked > 0,
1325             "You have no tokens staked"
1326         );
1327         
1328         // Update the rewards for this user, as the amount of rewards decreases with less tokens.
1329         uint256 rewards = calculateRewards(msg.sender);
1330         stakers[msg.sender].unclaimedRewards += rewards;
1331 
1332         unchecked {
1333             for (uint256 i = 0; i < _tokenIds.length; i++) {
1334                 _withdraw(_tokenIds[i]);
1335             }
1336         }
1337 
1338         // Update the timeOfLastUpdate for the withdrawer   
1339         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1340     }
1341     
1342     // Check if user has any ERC721 Tokens Staked and if they tried to withdraw,
1343     // calculate the rewards and store them in the unclaimedRewards
1344     // decrement the amountStaked of the user and transfer the ERC721 token back to them
1345     function _withdraw(uint256 _tokenId) internal {
1346         // Wallet must own the token they are trying to withdraw
1347         require(stakerAddress[_tokenId] == msg.sender, "You don't own this token!");
1348         // Find the index of this token id in the stakedTokens array
1349         uint256 index = 0;
1350         unchecked {
1351             for (uint256 i = 0; i < stakers[msg.sender].stakedTokens.length; i++) {
1352                 if (stakers[msg.sender].stakedTokens[i].tokenId == _tokenId) {
1353                     index = i;
1354                     break;
1355                 }
1356             }
1357         }
1358 
1359         require(stakers[msg.sender].stakedTokens[index].tokenStoreTime + (minimumStakingTime * 1 hours) <= block.timestamp, "You cannot withdraw before minimum staking time is passed !");
1360         // Set this token's .staker to be address 0 to mark it as no longer staked
1361         stakers[msg.sender].stakedTokens[index].staker = address(0);
1362 
1363         // Decrement the amount staked for this wallet
1364         stakers[msg.sender].amountStaked--;
1365 
1366         // Update the mapping of the tokenId to the be address(0) to indicate that the token is no longer staked
1367         stakerAddress[_tokenId] = address(0);
1368 
1369         // Transfer the token back to the withdrawer
1370         nftCollection.transferFrom(address(this), msg.sender, _tokenId);
1371     }
1372 
1373     // Calculate rewards for the msg.sender, check if there are any rewards
1374     // claim, set unclaimedRewards to 0 and transfer the ERC20 Reward token
1375     // to the user.
1376     function claimRewards() external {
1377         uint256 rewards = calculateRewards(msg.sender) +
1378             stakers[msg.sender].unclaimedRewards;
1379         require(rewards > 0, "You have no rewards to claim");
1380         stakers[msg.sender].timeOfLastUpdate = block.timestamp;
1381         stakers[msg.sender].unclaimedRewards = 0;
1382         rewardsToken.safeTransfer(msg.sender, rewards);
1383     }
1384 
1385 
1386     //////////
1387     // View //
1388     //////////
1389 
1390     function availableRewards(address _staker) public view returns (uint256) {
1391         uint256 rewards = calculateRewards(_staker) +
1392             stakers[_staker].unclaimedRewards;
1393         return rewards;
1394     }
1395 
1396     function getStakedTokens(address _user) public view returns (StakedToken[] memory) {
1397         // Check if we know this user
1398         if (stakers[_user].amountStaked > 0) {
1399             unchecked {
1400                     // Return all the tokens in the stakedToken Array for this user that are not -1
1401                 StakedToken[] memory _stakedTokens = new StakedToken[](stakers[_user].amountStaked);
1402                 uint256 _index = 0;
1403 
1404                 for (uint256 j = 0; j < stakers[_user].stakedTokens.length; j++) {
1405                     if (stakers[_user].stakedTokens[j].staker != (address(0))) {
1406                         _stakedTokens[_index] = stakers[_user].stakedTokens[j];
1407                         _index++;
1408                     }
1409                 }
1410 
1411                 return _stakedTokens;
1412             }
1413         }
1414         
1415         // Otherwise, return empty array
1416         else {
1417             return new StakedToken[](0);
1418         }
1419     }
1420 
1421     /////////////
1422     // Internal//
1423     /////////////
1424 
1425     // Calculate rewards for param _staker by calculating the time passed
1426     // since last update in hours and mulitplying it to ERC721 Tokens Staked
1427     // and rewardsPerHour.
1428     function calculateRewards(address _staker)
1429         internal
1430         view
1431         returns (uint256 _rewards)
1432     {
1433         return (((
1434             ((block.timestamp - stakers[_staker].timeOfLastUpdate) *
1435                 stakers[_staker].amountStaked)
1436         ) * rewardsPerHour) / 3600);
1437     }
1438 }