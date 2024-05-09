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
67 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
68 
69 
70 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
71 
72 pragma solidity ^0.8.0;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 
103 /**
104  * @dev Implementation of the {IERC165} interface.
105  *
106  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
107  * for the additional interface id that will be supported. For example:
108  *
109  * ```solidity
110  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
111  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
112  * }
113  * ```
114  *
115  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
116  */
117 abstract contract ERC165 is IERC165 {
118     /**
119      * @dev See {IERC165-supportsInterface}.
120      */
121     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
122         return interfaceId == type(IERC165).interfaceId;
123     }
124 }
125 
126 // File: @openzeppelin/contracts/utils/Context.sol
127 
128 
129 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
130 
131 pragma solidity ^0.8.0;
132 
133 /**
134  * @dev Provides information about the current execution context, including the
135  * sender of the transaction and its data. While these are generally available
136  * via msg.sender and msg.data, they should not be accessed in such a direct
137  * manner, since when dealing with meta-transactions the account sending and
138  * paying for execution may not be the actual sender (as far as an application
139  * is concerned).
140  *
141  * This contract is only required for intermediate, library-like contracts.
142  */
143 abstract contract Context {
144     function _msgSender() internal view virtual returns (address) {
145         return msg.sender;
146     }
147 
148     function _msgData() internal view virtual returns (bytes calldata) {
149         return msg.data;
150     }
151 }
152 
153 // File: @openzeppelin/contracts/access/Ownable.sol
154 
155 
156 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
157 
158 pragma solidity ^0.8.0;
159 
160 
161 /**
162  * @dev Contract module which provides a basic access control mechanism, where
163  * there is an account (an owner) that can be granted exclusive access to
164  * specific functions.
165  *
166  * By default, the owner account will be the one that deploys the contract. This
167  * can later be changed with {transferOwnership}.
168  *
169  * This module is used through inheritance. It will make available the modifier
170  * `onlyOwner`, which can be applied to your functions to restrict their use to
171  * the owner.
172  */
173 abstract contract Ownable is Context {
174     address private _owner;
175 
176     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
177 
178     /**
179      * @dev Initializes the contract setting the deployer as the initial owner.
180      */
181     constructor() {
182         _transferOwnership(_msgSender());
183     }
184 
185     /**
186      * @dev Throws if called by any account other than the owner.
187      */
188     modifier onlyOwner() {
189         _checkOwner();
190         _;
191     }
192 
193     /**
194      * @dev Returns the address of the current owner.
195      */
196     function owner() public view virtual returns (address) {
197         return _owner;
198     }
199 
200     /**
201      * @dev Throws if the sender is not the owner.
202      */
203     function _checkOwner() internal view virtual {
204         require(owner() == _msgSender(), "Ownable: caller is not the owner");
205     }
206 
207     /**
208      * @dev Leaves the contract without owner. It will not be possible to call
209      * `onlyOwner` functions anymore. Can only be called by the current owner.
210      *
211      * NOTE: Renouncing ownership will leave the contract without an owner,
212      * thereby removing any functionality that is only available to the owner.
213      */
214     function renounceOwnership() public virtual onlyOwner {
215         _transferOwnership(address(0));
216     }
217 
218     /**
219      * @dev Transfers ownership of the contract to a new account (`newOwner`).
220      * Can only be called by the current owner.
221      */
222     function transferOwnership(address newOwner) public virtual onlyOwner {
223         require(newOwner != address(0), "Ownable: new owner is the zero address");
224         _transferOwnership(newOwner);
225     }
226 
227     /**
228      * @dev Transfers ownership of the contract to a new account (`newOwner`).
229      * Internal function without access restriction.
230      */
231     function _transferOwnership(address newOwner) internal virtual {
232         address oldOwner = _owner;
233         _owner = newOwner;
234         emit OwnershipTransferred(oldOwner, newOwner);
235     }
236 }
237 
238 // File: @openzeppelin/contracts/access/IAccessControl.sol
239 
240 
241 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
242 
243 pragma solidity ^0.8.0;
244 
245 /**
246  * @dev External interface of AccessControl declared to support ERC165 detection.
247  */
248 interface IAccessControl {
249     /**
250      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
251      *
252      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
253      * {RoleAdminChanged} not being emitted signaling this.
254      *
255      * _Available since v3.1._
256      */
257     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
258 
259     /**
260      * @dev Emitted when `account` is granted `role`.
261      *
262      * `sender` is the account that originated the contract call, an admin role
263      * bearer except when using {AccessControl-_setupRole}.
264      */
265     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
266 
267     /**
268      * @dev Emitted when `account` is revoked `role`.
269      *
270      * `sender` is the account that originated the contract call:
271      *   - if using `revokeRole`, it is the admin role bearer
272      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
273      */
274     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
275 
276     /**
277      * @dev Returns `true` if `account` has been granted `role`.
278      */
279     function hasRole(bytes32 role, address account) external view returns (bool);
280 
281     /**
282      * @dev Returns the admin role that controls `role`. See {grantRole} and
283      * {revokeRole}.
284      *
285      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
286      */
287     function getRoleAdmin(bytes32 role) external view returns (bytes32);
288 
289     /**
290      * @dev Grants `role` to `account`.
291      *
292      * If `account` had not been already granted `role`, emits a {RoleGranted}
293      * event.
294      *
295      * Requirements:
296      *
297      * - the caller must have ``role``'s admin role.
298      */
299     function grantRole(bytes32 role, address account) external;
300 
301     /**
302      * @dev Revokes `role` from `account`.
303      *
304      * If `account` had been granted `role`, emits a {RoleRevoked} event.
305      *
306      * Requirements:
307      *
308      * - the caller must have ``role``'s admin role.
309      */
310     function revokeRole(bytes32 role, address account) external;
311 
312     /**
313      * @dev Revokes `role` from the calling account.
314      *
315      * Roles are often managed via {grantRole} and {revokeRole}: this function's
316      * purpose is to provide a mechanism for accounts to lose their privileges
317      * if they are compromised (such as when a trusted device is misplaced).
318      *
319      * If the calling account had been granted `role`, emits a {RoleRevoked}
320      * event.
321      *
322      * Requirements:
323      *
324      * - the caller must be `account`.
325      */
326     function renounceRole(bytes32 role, address account) external;
327 }
328 
329 // File: @openzeppelin/contracts/utils/Strings.sol
330 
331 
332 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
333 
334 pragma solidity ^0.8.0;
335 
336 /**
337  * @dev String operations.
338  */
339 library Strings {
340     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
341     uint8 private constant _ADDRESS_LENGTH = 20;
342 
343     /**
344      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
345      */
346     function toString(uint256 value) internal pure returns (string memory) {
347         // Inspired by OraclizeAPI's implementation - MIT licence
348         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
349 
350         if (value == 0) {
351             return "0";
352         }
353         uint256 temp = value;
354         uint256 digits;
355         while (temp != 0) {
356             digits++;
357             temp /= 10;
358         }
359         bytes memory buffer = new bytes(digits);
360         while (value != 0) {
361             digits -= 1;
362             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
363             value /= 10;
364         }
365         return string(buffer);
366     }
367 
368     /**
369      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
370      */
371     function toHexString(uint256 value) internal pure returns (string memory) {
372         if (value == 0) {
373             return "0x00";
374         }
375         uint256 temp = value;
376         uint256 length = 0;
377         while (temp != 0) {
378             length++;
379             temp >>= 8;
380         }
381         return toHexString(value, length);
382     }
383 
384     /**
385      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
386      */
387     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
388         bytes memory buffer = new bytes(2 * length + 2);
389         buffer[0] = "0";
390         buffer[1] = "x";
391         for (uint256 i = 2 * length + 1; i > 1; --i) {
392             buffer[i] = _HEX_SYMBOLS[value & 0xf];
393             value >>= 4;
394         }
395         require(value == 0, "Strings: hex length insufficient");
396         return string(buffer);
397     }
398 
399     /**
400      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
401      */
402     function toHexString(address addr) internal pure returns (string memory) {
403         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
404     }
405 }
406 
407 // File: @openzeppelin/contracts/access/AccessControl.sol
408 
409 
410 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
411 
412 pragma solidity ^0.8.0;
413 
414 
415 
416 
417 
418 /**
419  * @dev Contract module that allows children to implement role-based access
420  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
421  * members except through off-chain means by accessing the contract event logs. Some
422  * applications may benefit from on-chain enumerability, for those cases see
423  * {AccessControlEnumerable}.
424  *
425  * Roles are referred to by their `bytes32` identifier. These should be exposed
426  * in the external API and be unique. The best way to achieve this is by
427  * using `public constant` hash digests:
428  *
429  * ```
430  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
431  * ```
432  *
433  * Roles can be used to represent a set of permissions. To restrict access to a
434  * function call, use {hasRole}:
435  *
436  * ```
437  * function foo() public {
438  *     require(hasRole(MY_ROLE, msg.sender));
439  *     ...
440  * }
441  * ```
442  *
443  * Roles can be granted and revoked dynamically via the {grantRole} and
444  * {revokeRole} functions. Each role has an associated admin role, and only
445  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
446  *
447  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
448  * that only accounts with this role will be able to grant or revoke other
449  * roles. More complex role relationships can be created by using
450  * {_setRoleAdmin}.
451  *
452  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
453  * grant and revoke this role. Extra precautions should be taken to secure
454  * accounts that have been granted it.
455  */
456 abstract contract AccessControl is Context, IAccessControl, ERC165 {
457     struct RoleData {
458         mapping(address => bool) members;
459         bytes32 adminRole;
460     }
461 
462     mapping(bytes32 => RoleData) private _roles;
463 
464     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
465 
466     /**
467      * @dev Modifier that checks that an account has a specific role. Reverts
468      * with a standardized message including the required role.
469      *
470      * The format of the revert reason is given by the following regular expression:
471      *
472      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
473      *
474      * _Available since v4.1._
475      */
476     modifier onlyRole(bytes32 role) {
477         _checkRole(role);
478         _;
479     }
480 
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
486     }
487 
488     /**
489      * @dev Returns `true` if `account` has been granted `role`.
490      */
491     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
492         return _roles[role].members[account];
493     }
494 
495     /**
496      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
497      * Overriding this function changes the behavior of the {onlyRole} modifier.
498      *
499      * Format of the revert message is described in {_checkRole}.
500      *
501      * _Available since v4.6._
502      */
503     function _checkRole(bytes32 role) internal view virtual {
504         _checkRole(role, _msgSender());
505     }
506 
507     /**
508      * @dev Revert with a standard message if `account` is missing `role`.
509      *
510      * The format of the revert reason is given by the following regular expression:
511      *
512      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
513      */
514     function _checkRole(bytes32 role, address account) internal view virtual {
515         if (!hasRole(role, account)) {
516             revert(
517                 string(
518                     abi.encodePacked(
519                         "AccessControl: account ",
520                         Strings.toHexString(uint160(account), 20),
521                         " is missing role ",
522                         Strings.toHexString(uint256(role), 32)
523                     )
524                 )
525             );
526         }
527     }
528 
529     /**
530      * @dev Returns the admin role that controls `role`. See {grantRole} and
531      * {revokeRole}.
532      *
533      * To change a role's admin, use {_setRoleAdmin}.
534      */
535     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
536         return _roles[role].adminRole;
537     }
538 
539     /**
540      * @dev Grants `role` to `account`.
541      *
542      * If `account` had not been already granted `role`, emits a {RoleGranted}
543      * event.
544      *
545      * Requirements:
546      *
547      * - the caller must have ``role``'s admin role.
548      *
549      * May emit a {RoleGranted} event.
550      */
551     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
552         _grantRole(role, account);
553     }
554 
555     /**
556      * @dev Revokes `role` from `account`.
557      *
558      * If `account` had been granted `role`, emits a {RoleRevoked} event.
559      *
560      * Requirements:
561      *
562      * - the caller must have ``role``'s admin role.
563      *
564      * May emit a {RoleRevoked} event.
565      */
566     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
567         _revokeRole(role, account);
568     }
569 
570     /**
571      * @dev Revokes `role` from the calling account.
572      *
573      * Roles are often managed via {grantRole} and {revokeRole}: this function's
574      * purpose is to provide a mechanism for accounts to lose their privileges
575      * if they are compromised (such as when a trusted device is misplaced).
576      *
577      * If the calling account had been revoked `role`, emits a {RoleRevoked}
578      * event.
579      *
580      * Requirements:
581      *
582      * - the caller must be `account`.
583      *
584      * May emit a {RoleRevoked} event.
585      */
586     function renounceRole(bytes32 role, address account) public virtual override {
587         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
588 
589         _revokeRole(role, account);
590     }
591 
592     /**
593      * @dev Grants `role` to `account`.
594      *
595      * If `account` had not been already granted `role`, emits a {RoleGranted}
596      * event. Note that unlike {grantRole}, this function doesn't perform any
597      * checks on the calling account.
598      *
599      * May emit a {RoleGranted} event.
600      *
601      * [WARNING]
602      * ====
603      * This function should only be called from the constructor when setting
604      * up the initial roles for the system.
605      *
606      * Using this function in any other way is effectively circumventing the admin
607      * system imposed by {AccessControl}.
608      * ====
609      *
610      * NOTE: This function is deprecated in favor of {_grantRole}.
611      */
612     function _setupRole(bytes32 role, address account) internal virtual {
613         _grantRole(role, account);
614     }
615 
616     /**
617      * @dev Sets `adminRole` as ``role``'s admin role.
618      *
619      * Emits a {RoleAdminChanged} event.
620      */
621     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
622         bytes32 previousAdminRole = getRoleAdmin(role);
623         _roles[role].adminRole = adminRole;
624         emit RoleAdminChanged(role, previousAdminRole, adminRole);
625     }
626 
627     /**
628      * @dev Grants `role` to `account`.
629      *
630      * Internal function without access restriction.
631      *
632      * May emit a {RoleGranted} event.
633      */
634     function _grantRole(bytes32 role, address account) internal virtual {
635         if (!hasRole(role, account)) {
636             _roles[role].members[account] = true;
637             emit RoleGranted(role, account, _msgSender());
638         }
639     }
640 
641     /**
642      * @dev Revokes `role` from `account`.
643      *
644      * Internal function without access restriction.
645      *
646      * May emit a {RoleRevoked} event.
647      */
648     function _revokeRole(bytes32 role, address account) internal virtual {
649         if (hasRole(role, account)) {
650             _roles[role].members[account] = false;
651             emit RoleRevoked(role, account, _msgSender());
652         }
653     }
654 }
655 
656 // File: erc721a/contracts/IERC721A.sol
657 
658 
659 // ERC721A Contracts v4.2.3
660 // Creator: Chiru Labs
661 
662 pragma solidity ^0.8.4;
663 
664 /**
665  * @dev Interface of ERC721A.
666  */
667 interface IERC721A {
668     /**
669      * The caller must own the token or be an approved operator.
670      */
671     error ApprovalCallerNotOwnerNorApproved();
672 
673     /**
674      * The token does not exist.
675      */
676     error ApprovalQueryForNonexistentToken();
677 
678     /**
679      * Cannot query the balance for the zero address.
680      */
681     error BalanceQueryForZeroAddress();
682 
683     /**
684      * Cannot mint to the zero address.
685      */
686     error MintToZeroAddress();
687 
688     /**
689      * The quantity of tokens minted must be more than zero.
690      */
691     error MintZeroQuantity();
692 
693     /**
694      * The token does not exist.
695      */
696     error OwnerQueryForNonexistentToken();
697 
698     /**
699      * The caller must own the token or be an approved operator.
700      */
701     error TransferCallerNotOwnerNorApproved();
702 
703     /**
704      * The token must be owned by `from`.
705      */
706     error TransferFromIncorrectOwner();
707 
708     /**
709      * Cannot safely transfer to a contract that does not implement the
710      * ERC721Receiver interface.
711      */
712     error TransferToNonERC721ReceiverImplementer();
713 
714     /**
715      * Cannot transfer to the zero address.
716      */
717     error TransferToZeroAddress();
718 
719     /**
720      * The token does not exist.
721      */
722     error URIQueryForNonexistentToken();
723 
724     /**
725      * The `quantity` minted with ERC2309 exceeds the safety limit.
726      */
727     error MintERC2309QuantityExceedsLimit();
728 
729     /**
730      * The `extraData` cannot be set on an unintialized ownership slot.
731      */
732     error OwnershipNotInitializedForExtraData();
733 
734     // =============================================================
735     //                            STRUCTS
736     // =============================================================
737 
738     struct TokenOwnership {
739         // The address of the owner.
740         address addr;
741         // Stores the start time of ownership with minimal overhead for tokenomics.
742         uint64 startTimestamp;
743         // Whether the token has been burned.
744         bool burned;
745         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
746         uint24 extraData;
747     }
748 
749     // =============================================================
750     //                         TOKEN COUNTERS
751     // =============================================================
752 
753     /**
754      * @dev Returns the total number of tokens in existence.
755      * Burned tokens will reduce the count.
756      * To get the total number of tokens minted, please see {_totalMinted}.
757      */
758     function totalSupply() external view returns (uint256);
759 
760     // =============================================================
761     //                            IERC165
762     // =============================================================
763 
764     /**
765      * @dev Returns true if this contract implements the interface defined by
766      * `interfaceId`. See the corresponding
767      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
768      * to learn more about how these ids are created.
769      *
770      * This function call must use less than 30000 gas.
771      */
772     function supportsInterface(bytes4 interfaceId) external view returns (bool);
773 
774     // =============================================================
775     //                            IERC721
776     // =============================================================
777 
778     /**
779      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
780      */
781     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
782 
783     /**
784      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
785      */
786     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
787 
788     /**
789      * @dev Emitted when `owner` enables or disables
790      * (`approved`) `operator` to manage all of its assets.
791      */
792     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
793 
794     /**
795      * @dev Returns the number of tokens in `owner`'s account.
796      */
797     function balanceOf(address owner) external view returns (uint256 balance);
798 
799     /**
800      * @dev Returns the owner of the `tokenId` token.
801      *
802      * Requirements:
803      *
804      * - `tokenId` must exist.
805      */
806     function ownerOf(uint256 tokenId) external view returns (address owner);
807 
808     /**
809      * @dev Safely transfers `tokenId` token from `from` to `to`,
810      * checking first that contract recipients are aware of the ERC721 protocol
811      * to prevent tokens from being forever locked.
812      *
813      * Requirements:
814      *
815      * - `from` cannot be the zero address.
816      * - `to` cannot be the zero address.
817      * - `tokenId` token must exist and be owned by `from`.
818      * - If the caller is not `from`, it must be have been allowed to move
819      * this token by either {approve} or {setApprovalForAll}.
820      * - If `to` refers to a smart contract, it must implement
821      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
822      *
823      * Emits a {Transfer} event.
824      */
825     function safeTransferFrom(
826         address from,
827         address to,
828         uint256 tokenId,
829         bytes calldata data
830     ) external payable;
831 
832     /**
833      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
834      */
835     function safeTransferFrom(
836         address from,
837         address to,
838         uint256 tokenId
839     ) external payable;
840 
841     /**
842      * @dev Transfers `tokenId` from `from` to `to`.
843      *
844      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
845      * whenever possible.
846      *
847      * Requirements:
848      *
849      * - `from` cannot be the zero address.
850      * - `to` cannot be the zero address.
851      * - `tokenId` token must be owned by `from`.
852      * - If the caller is not `from`, it must be approved to move this token
853      * by either {approve} or {setApprovalForAll}.
854      *
855      * Emits a {Transfer} event.
856      */
857     function transferFrom(
858         address from,
859         address to,
860         uint256 tokenId
861     ) external payable;
862 
863     /**
864      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
865      * The approval is cleared when the token is transferred.
866      *
867      * Only a single account can be approved at a time, so approving the
868      * zero address clears previous approvals.
869      *
870      * Requirements:
871      *
872      * - The caller must own the token or be an approved operator.
873      * - `tokenId` must exist.
874      *
875      * Emits an {Approval} event.
876      */
877     function approve(address to, uint256 tokenId) external payable;
878 
879     /**
880      * @dev Approve or remove `operator` as an operator for the caller.
881      * Operators can call {transferFrom} or {safeTransferFrom}
882      * for any token owned by the caller.
883      *
884      * Requirements:
885      *
886      * - The `operator` cannot be the caller.
887      *
888      * Emits an {ApprovalForAll} event.
889      */
890     function setApprovalForAll(address operator, bool _approved) external;
891 
892     /**
893      * @dev Returns the account approved for `tokenId` token.
894      *
895      * Requirements:
896      *
897      * - `tokenId` must exist.
898      */
899     function getApproved(uint256 tokenId) external view returns (address operator);
900 
901     /**
902      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
903      *
904      * See {setApprovalForAll}.
905      */
906     function isApprovedForAll(address owner, address operator) external view returns (bool);
907 
908     // =============================================================
909     //                        IERC721Metadata
910     // =============================================================
911 
912     /**
913      * @dev Returns the token collection name.
914      */
915     function name() external view returns (string memory);
916 
917     /**
918      * @dev Returns the token collection symbol.
919      */
920     function symbol() external view returns (string memory);
921 
922     /**
923      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
924      */
925     function tokenURI(uint256 tokenId) external view returns (string memory);
926 
927     // =============================================================
928     //                           IERC2309
929     // =============================================================
930 
931     /**
932      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
933      * (inclusive) is transferred from `from` to `to`, as defined in the
934      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
935      *
936      * See {_mintERC2309} for more details.
937      */
938     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
939 }
940 
941 // File: erc721a/contracts/ERC721A.sol
942 
943 
944 // ERC721A Contracts v4.2.3
945 // Creator: Chiru Labs
946 
947 pragma solidity ^0.8.4;
948 
949 
950 /**
951  * @dev Interface of ERC721 token receiver.
952  */
953 interface ERC721A__IERC721Receiver {
954     function onERC721Received(
955         address operator,
956         address from,
957         uint256 tokenId,
958         bytes calldata data
959     ) external returns (bytes4);
960 }
961 
962 /**
963  * @title ERC721A
964  *
965  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
966  * Non-Fungible Token Standard, including the Metadata extension.
967  * Optimized for lower gas during batch mints.
968  *
969  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
970  * starting from `_startTokenId()`.
971  *
972  * Assumptions:
973  *
974  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
975  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
976  */
977 contract ERC721A is IERC721A {
978     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
979     struct TokenApprovalRef {
980         address value;
981     }
982 
983     // =============================================================
984     //                           CONSTANTS
985     // =============================================================
986 
987     // Mask of an entry in packed address data.
988     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
989 
990     // The bit position of `numberMinted` in packed address data.
991     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
992 
993     // The bit position of `numberBurned` in packed address data.
994     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
995 
996     // The bit position of `aux` in packed address data.
997     uint256 private constant _BITPOS_AUX = 192;
998 
999     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1000     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1001 
1002     // The bit position of `startTimestamp` in packed ownership.
1003     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1004 
1005     // The bit mask of the `burned` bit in packed ownership.
1006     uint256 private constant _BITMASK_BURNED = 1 << 224;
1007 
1008     // The bit position of the `nextInitialized` bit in packed ownership.
1009     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1010 
1011     // The bit mask of the `nextInitialized` bit in packed ownership.
1012     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1013 
1014     // The bit position of `extraData` in packed ownership.
1015     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1016 
1017     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1018     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1019 
1020     // The mask of the lower 160 bits for addresses.
1021     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1022 
1023     // The maximum `quantity` that can be minted with {_mintERC2309}.
1024     // This limit is to prevent overflows on the address data entries.
1025     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1026     // is required to cause an overflow, which is unrealistic.
1027     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1028 
1029     // The `Transfer` event signature is given by:
1030     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1031     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1032         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1033 
1034     // =============================================================
1035     //                            STORAGE
1036     // =============================================================
1037 
1038     // The next token ID to be minted.
1039     uint256 private _currentIndex;
1040 
1041     // The number of tokens burned.
1042     uint256 private _burnCounter;
1043 
1044     // Token name
1045     string private _name;
1046 
1047     // Token symbol
1048     string private _symbol;
1049 
1050     // Mapping from token ID to ownership details
1051     // An empty struct value does not necessarily mean the token is unowned.
1052     // See {_packedOwnershipOf} implementation for details.
1053     //
1054     // Bits Layout:
1055     // - [0..159]   `addr`
1056     // - [160..223] `startTimestamp`
1057     // - [224]      `burned`
1058     // - [225]      `nextInitialized`
1059     // - [232..255] `extraData`
1060     mapping(uint256 => uint256) private _packedOwnerships;
1061 
1062     // Mapping owner address to address data.
1063     //
1064     // Bits Layout:
1065     // - [0..63]    `balance`
1066     // - [64..127]  `numberMinted`
1067     // - [128..191] `numberBurned`
1068     // - [192..255] `aux`
1069     mapping(address => uint256) private _packedAddressData;
1070 
1071     // Mapping from token ID to approved address.
1072     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1073 
1074     // Mapping from owner to operator approvals
1075     mapping(address => mapping(address => bool)) private _operatorApprovals;
1076 
1077     // =============================================================
1078     //                          CONSTRUCTOR
1079     // =============================================================
1080 
1081     constructor(string memory name_, string memory symbol_) {
1082         _name = name_;
1083         _symbol = symbol_;
1084         _currentIndex = _startTokenId();
1085     }
1086 
1087     // =============================================================
1088     //                   TOKEN COUNTING OPERATIONS
1089     // =============================================================
1090 
1091     /**
1092      * @dev Returns the starting token ID.
1093      * To change the starting token ID, please override this function.
1094      */
1095     function _startTokenId() internal view virtual returns (uint256) {
1096         return 0;
1097     }
1098 
1099     /**
1100      * @dev Returns the next token ID to be minted.
1101      */
1102     function _nextTokenId() internal view virtual returns (uint256) {
1103         return _currentIndex;
1104     }
1105 
1106     /**
1107      * @dev Returns the total number of tokens in existence.
1108      * Burned tokens will reduce the count.
1109      * To get the total number of tokens minted, please see {_totalMinted}.
1110      */
1111     function totalSupply() public view virtual override returns (uint256) {
1112         // Counter underflow is impossible as _burnCounter cannot be incremented
1113         // more than `_currentIndex - _startTokenId()` times.
1114         unchecked {
1115             return _currentIndex - _burnCounter - _startTokenId();
1116         }
1117     }
1118 
1119     /**
1120      * @dev Returns the total amount of tokens minted in the contract.
1121      */
1122     function _totalMinted() internal view virtual returns (uint256) {
1123         // Counter underflow is impossible as `_currentIndex` does not decrement,
1124         // and it is initialized to `_startTokenId()`.
1125         unchecked {
1126             return _currentIndex - _startTokenId();
1127         }
1128     }
1129 
1130     /**
1131      * @dev Returns the total number of tokens burned.
1132      */
1133     function _totalBurned() internal view virtual returns (uint256) {
1134         return _burnCounter;
1135     }
1136 
1137     // =============================================================
1138     //                    ADDRESS DATA OPERATIONS
1139     // =============================================================
1140 
1141     /**
1142      * @dev Returns the number of tokens in `owner`'s account.
1143      */
1144     function balanceOf(address owner) public view virtual override returns (uint256) {
1145         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1146         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1147     }
1148 
1149     /**
1150      * Returns the number of tokens minted by `owner`.
1151      */
1152     function _numberMinted(address owner) internal view returns (uint256) {
1153         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1154     }
1155 
1156     /**
1157      * Returns the number of tokens burned by or on behalf of `owner`.
1158      */
1159     function _numberBurned(address owner) internal view returns (uint256) {
1160         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1161     }
1162 
1163     /**
1164      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1165      */
1166     function _getAux(address owner) internal view returns (uint64) {
1167         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1168     }
1169 
1170     /**
1171      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1172      * If there are multiple variables, please pack them into a uint64.
1173      */
1174     function _setAux(address owner, uint64 aux) internal virtual {
1175         uint256 packed = _packedAddressData[owner];
1176         uint256 auxCasted;
1177         // Cast `aux` with assembly to avoid redundant masking.
1178         assembly {
1179             auxCasted := aux
1180         }
1181         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1182         _packedAddressData[owner] = packed;
1183     }
1184 
1185     // =============================================================
1186     //                            IERC165
1187     // =============================================================
1188 
1189     /**
1190      * @dev Returns true if this contract implements the interface defined by
1191      * `interfaceId`. See the corresponding
1192      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1193      * to learn more about how these ids are created.
1194      *
1195      * This function call must use less than 30000 gas.
1196      */
1197     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1198         // The interface IDs are constants representing the first 4 bytes
1199         // of the XOR of all function selectors in the interface.
1200         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1201         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1202         return
1203             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1204             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1205             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1206     }
1207 
1208     // =============================================================
1209     //                        IERC721Metadata
1210     // =============================================================
1211 
1212     /**
1213      * @dev Returns the token collection name.
1214      */
1215     function name() public view virtual override returns (string memory) {
1216         return _name;
1217     }
1218 
1219     /**
1220      * @dev Returns the token collection symbol.
1221      */
1222     function symbol() public view virtual override returns (string memory) {
1223         return _symbol;
1224     }
1225 
1226     /**
1227      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1228      */
1229     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1230         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1231 
1232         string memory baseURI = _baseURI();
1233         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1234     }
1235 
1236     /**
1237      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1238      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1239      * by default, it can be overridden in child contracts.
1240      */
1241     function _baseURI() internal view virtual returns (string memory) {
1242         return '';
1243     }
1244 
1245     // =============================================================
1246     //                     OWNERSHIPS OPERATIONS
1247     // =============================================================
1248 
1249     /**
1250      * @dev Returns the owner of the `tokenId` token.
1251      *
1252      * Requirements:
1253      *
1254      * - `tokenId` must exist.
1255      */
1256     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1257         return address(uint160(_packedOwnershipOf(tokenId)));
1258     }
1259 
1260     /**
1261      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1262      * It gradually moves to O(1) as tokens get transferred around over time.
1263      */
1264     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1265         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1266     }
1267 
1268     /**
1269      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1270      */
1271     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1272         return _unpackedOwnership(_packedOwnerships[index]);
1273     }
1274 
1275     /**
1276      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1277      */
1278     function _initializeOwnershipAt(uint256 index) internal virtual {
1279         if (_packedOwnerships[index] == 0) {
1280             _packedOwnerships[index] = _packedOwnershipOf(index);
1281         }
1282     }
1283 
1284     /**
1285      * Returns the packed ownership data of `tokenId`.
1286      */
1287     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1288         uint256 curr = tokenId;
1289 
1290         unchecked {
1291             if (_startTokenId() <= curr)
1292                 if (curr < _currentIndex) {
1293                     uint256 packed = _packedOwnerships[curr];
1294                     // If not burned.
1295                     if (packed & _BITMASK_BURNED == 0) {
1296                         // Invariant:
1297                         // There will always be an initialized ownership slot
1298                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1299                         // before an unintialized ownership slot
1300                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1301                         // Hence, `curr` will not underflow.
1302                         //
1303                         // We can directly compare the packed value.
1304                         // If the address is zero, packed will be zero.
1305                         while (packed == 0) {
1306                             packed = _packedOwnerships[--curr];
1307                         }
1308                         return packed;
1309                     }
1310                 }
1311         }
1312         revert OwnerQueryForNonexistentToken();
1313     }
1314 
1315     /**
1316      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1317      */
1318     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1319         ownership.addr = address(uint160(packed));
1320         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1321         ownership.burned = packed & _BITMASK_BURNED != 0;
1322         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1323     }
1324 
1325     /**
1326      * @dev Packs ownership data into a single uint256.
1327      */
1328     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1329         assembly {
1330             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1331             owner := and(owner, _BITMASK_ADDRESS)
1332             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1333             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1334         }
1335     }
1336 
1337     /**
1338      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1339      */
1340     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1341         // For branchless setting of the `nextInitialized` flag.
1342         assembly {
1343             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1344             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1345         }
1346     }
1347 
1348     // =============================================================
1349     //                      APPROVAL OPERATIONS
1350     // =============================================================
1351 
1352     /**
1353      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1354      * The approval is cleared when the token is transferred.
1355      *
1356      * Only a single account can be approved at a time, so approving the
1357      * zero address clears previous approvals.
1358      *
1359      * Requirements:
1360      *
1361      * - The caller must own the token or be an approved operator.
1362      * - `tokenId` must exist.
1363      *
1364      * Emits an {Approval} event.
1365      */
1366     function approve(address to, uint256 tokenId) public payable virtual override {
1367         address owner = ownerOf(tokenId);
1368 
1369         if (_msgSenderERC721A() != owner)
1370             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1371                 revert ApprovalCallerNotOwnerNorApproved();
1372             }
1373 
1374         _tokenApprovals[tokenId].value = to;
1375         emit Approval(owner, to, tokenId);
1376     }
1377 
1378     /**
1379      * @dev Returns the account approved for `tokenId` token.
1380      *
1381      * Requirements:
1382      *
1383      * - `tokenId` must exist.
1384      */
1385     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1386         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1387 
1388         return _tokenApprovals[tokenId].value;
1389     }
1390 
1391     /**
1392      * @dev Approve or remove `operator` as an operator for the caller.
1393      * Operators can call {transferFrom} or {safeTransferFrom}
1394      * for any token owned by the caller.
1395      *
1396      * Requirements:
1397      *
1398      * - The `operator` cannot be the caller.
1399      *
1400      * Emits an {ApprovalForAll} event.
1401      */
1402     function setApprovalForAll(address operator, bool approved) public virtual override {
1403         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1404         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1405     }
1406 
1407     /**
1408      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1409      *
1410      * See {setApprovalForAll}.
1411      */
1412     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1413         return _operatorApprovals[owner][operator];
1414     }
1415 
1416     /**
1417      * @dev Returns whether `tokenId` exists.
1418      *
1419      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1420      *
1421      * Tokens start existing when they are minted. See {_mint}.
1422      */
1423     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1424         return
1425             _startTokenId() <= tokenId &&
1426             tokenId < _currentIndex && // If within bounds,
1427             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1428     }
1429 
1430     /**
1431      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1432      */
1433     function _isSenderApprovedOrOwner(
1434         address approvedAddress,
1435         address owner,
1436         address msgSender
1437     ) private pure returns (bool result) {
1438         assembly {
1439             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1440             owner := and(owner, _BITMASK_ADDRESS)
1441             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1442             msgSender := and(msgSender, _BITMASK_ADDRESS)
1443             // `msgSender == owner || msgSender == approvedAddress`.
1444             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1445         }
1446     }
1447 
1448     /**
1449      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1450      */
1451     function _getApprovedSlotAndAddress(uint256 tokenId)
1452         private
1453         view
1454         returns (uint256 approvedAddressSlot, address approvedAddress)
1455     {
1456         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1457         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1458         assembly {
1459             approvedAddressSlot := tokenApproval.slot
1460             approvedAddress := sload(approvedAddressSlot)
1461         }
1462     }
1463 
1464     // =============================================================
1465     //                      TRANSFER OPERATIONS
1466     // =============================================================
1467 
1468     /**
1469      * @dev Transfers `tokenId` from `from` to `to`.
1470      *
1471      * Requirements:
1472      *
1473      * - `from` cannot be the zero address.
1474      * - `to` cannot be the zero address.
1475      * - `tokenId` token must be owned by `from`.
1476      * - If the caller is not `from`, it must be approved to move this token
1477      * by either {approve} or {setApprovalForAll}.
1478      *
1479      * Emits a {Transfer} event.
1480      */
1481     function transferFrom(
1482         address from,
1483         address to,
1484         uint256 tokenId
1485     ) public payable virtual override {
1486         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1487 
1488         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1489 
1490         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1491 
1492         // The nested ifs save around 20+ gas over a compound boolean condition.
1493         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1494             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1495 
1496         if (to == address(0)) revert TransferToZeroAddress();
1497 
1498         _beforeTokenTransfers(from, to, tokenId, 1);
1499 
1500         // Clear approvals from the previous owner.
1501         assembly {
1502             if approvedAddress {
1503                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1504                 sstore(approvedAddressSlot, 0)
1505             }
1506         }
1507 
1508         // Underflow of the sender's balance is impossible because we check for
1509         // ownership above and the recipient's balance can't realistically overflow.
1510         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1511         unchecked {
1512             // We can directly increment and decrement the balances.
1513             --_packedAddressData[from]; // Updates: `balance -= 1`.
1514             ++_packedAddressData[to]; // Updates: `balance += 1`.
1515 
1516             // Updates:
1517             // - `address` to the next owner.
1518             // - `startTimestamp` to the timestamp of transfering.
1519             // - `burned` to `false`.
1520             // - `nextInitialized` to `true`.
1521             _packedOwnerships[tokenId] = _packOwnershipData(
1522                 to,
1523                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1524             );
1525 
1526             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1527             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1528                 uint256 nextTokenId = tokenId + 1;
1529                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1530                 if (_packedOwnerships[nextTokenId] == 0) {
1531                     // If the next slot is within bounds.
1532                     if (nextTokenId != _currentIndex) {
1533                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1534                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1535                     }
1536                 }
1537             }
1538         }
1539 
1540         emit Transfer(from, to, tokenId);
1541         _afterTokenTransfers(from, to, tokenId, 1);
1542     }
1543 
1544     /**
1545      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1546      */
1547     function safeTransferFrom(
1548         address from,
1549         address to,
1550         uint256 tokenId
1551     ) public payable virtual override {
1552         safeTransferFrom(from, to, tokenId, '');
1553     }
1554 
1555     /**
1556      * @dev Safely transfers `tokenId` token from `from` to `to`.
1557      *
1558      * Requirements:
1559      *
1560      * - `from` cannot be the zero address.
1561      * - `to` cannot be the zero address.
1562      * - `tokenId` token must exist and be owned by `from`.
1563      * - If the caller is not `from`, it must be approved to move this token
1564      * by either {approve} or {setApprovalForAll}.
1565      * - If `to` refers to a smart contract, it must implement
1566      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1567      *
1568      * Emits a {Transfer} event.
1569      */
1570     function safeTransferFrom(
1571         address from,
1572         address to,
1573         uint256 tokenId,
1574         bytes memory _data
1575     ) public payable virtual override {
1576         transferFrom(from, to, tokenId);
1577         if (to.code.length != 0)
1578             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1579                 revert TransferToNonERC721ReceiverImplementer();
1580             }
1581     }
1582 
1583     /**
1584      * @dev Hook that is called before a set of serially-ordered token IDs
1585      * are about to be transferred. This includes minting.
1586      * And also called before burning one token.
1587      *
1588      * `startTokenId` - the first token ID to be transferred.
1589      * `quantity` - the amount to be transferred.
1590      *
1591      * Calling conditions:
1592      *
1593      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1594      * transferred to `to`.
1595      * - When `from` is zero, `tokenId` will be minted for `to`.
1596      * - When `to` is zero, `tokenId` will be burned by `from`.
1597      * - `from` and `to` are never both zero.
1598      */
1599     function _beforeTokenTransfers(
1600         address from,
1601         address to,
1602         uint256 startTokenId,
1603         uint256 quantity
1604     ) internal virtual {}
1605 
1606     /**
1607      * @dev Hook that is called after a set of serially-ordered token IDs
1608      * have been transferred. This includes minting.
1609      * And also called after one token has been burned.
1610      *
1611      * `startTokenId` - the first token ID to be transferred.
1612      * `quantity` - the amount to be transferred.
1613      *
1614      * Calling conditions:
1615      *
1616      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1617      * transferred to `to`.
1618      * - When `from` is zero, `tokenId` has been minted for `to`.
1619      * - When `to` is zero, `tokenId` has been burned by `from`.
1620      * - `from` and `to` are never both zero.
1621      */
1622     function _afterTokenTransfers(
1623         address from,
1624         address to,
1625         uint256 startTokenId,
1626         uint256 quantity
1627     ) internal virtual {}
1628 
1629     /**
1630      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1631      *
1632      * `from` - Previous owner of the given token ID.
1633      * `to` - Target address that will receive the token.
1634      * `tokenId` - Token ID to be transferred.
1635      * `_data` - Optional data to send along with the call.
1636      *
1637      * Returns whether the call correctly returned the expected magic value.
1638      */
1639     function _checkContractOnERC721Received(
1640         address from,
1641         address to,
1642         uint256 tokenId,
1643         bytes memory _data
1644     ) private returns (bool) {
1645         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1646             bytes4 retval
1647         ) {
1648             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1649         } catch (bytes memory reason) {
1650             if (reason.length == 0) {
1651                 revert TransferToNonERC721ReceiverImplementer();
1652             } else {
1653                 assembly {
1654                     revert(add(32, reason), mload(reason))
1655                 }
1656             }
1657         }
1658     }
1659 
1660     // =============================================================
1661     //                        MINT OPERATIONS
1662     // =============================================================
1663 
1664     /**
1665      * @dev Mints `quantity` tokens and transfers them to `to`.
1666      *
1667      * Requirements:
1668      *
1669      * - `to` cannot be the zero address.
1670      * - `quantity` must be greater than 0.
1671      *
1672      * Emits a {Transfer} event for each mint.
1673      */
1674     function _mint(address to, uint256 quantity) internal virtual {
1675         uint256 startTokenId = _currentIndex;
1676         if (quantity == 0) revert MintZeroQuantity();
1677 
1678         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1679 
1680         // Overflows are incredibly unrealistic.
1681         // `balance` and `numberMinted` have a maximum limit of 2**64.
1682         // `tokenId` has a maximum limit of 2**256.
1683         unchecked {
1684             // Updates:
1685             // - `balance += quantity`.
1686             // - `numberMinted += quantity`.
1687             //
1688             // We can directly add to the `balance` and `numberMinted`.
1689             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1690 
1691             // Updates:
1692             // - `address` to the owner.
1693             // - `startTimestamp` to the timestamp of minting.
1694             // - `burned` to `false`.
1695             // - `nextInitialized` to `quantity == 1`.
1696             _packedOwnerships[startTokenId] = _packOwnershipData(
1697                 to,
1698                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1699             );
1700 
1701             uint256 toMasked;
1702             uint256 end = startTokenId + quantity;
1703 
1704             // Use assembly to loop and emit the `Transfer` event for gas savings.
1705             // The duplicated `log4` removes an extra check and reduces stack juggling.
1706             // The assembly, together with the surrounding Solidity code, have been
1707             // delicately arranged to nudge the compiler into producing optimized opcodes.
1708             assembly {
1709                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1710                 toMasked := and(to, _BITMASK_ADDRESS)
1711                 // Emit the `Transfer` event.
1712                 log4(
1713                     0, // Start of data (0, since no data).
1714                     0, // End of data (0, since no data).
1715                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1716                     0, // `address(0)`.
1717                     toMasked, // `to`.
1718                     startTokenId // `tokenId`.
1719                 )
1720 
1721                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1722                 // that overflows uint256 will make the loop run out of gas.
1723                 // The compiler will optimize the `iszero` away for performance.
1724                 for {
1725                     let tokenId := add(startTokenId, 1)
1726                 } iszero(eq(tokenId, end)) {
1727                     tokenId := add(tokenId, 1)
1728                 } {
1729                     // Emit the `Transfer` event. Similar to above.
1730                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1731                 }
1732             }
1733             if (toMasked == 0) revert MintToZeroAddress();
1734 
1735             _currentIndex = end;
1736         }
1737         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1738     }
1739 
1740     /**
1741      * @dev Mints `quantity` tokens and transfers them to `to`.
1742      *
1743      * This function is intended for efficient minting only during contract creation.
1744      *
1745      * It emits only one {ConsecutiveTransfer} as defined in
1746      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1747      * instead of a sequence of {Transfer} event(s).
1748      *
1749      * Calling this function outside of contract creation WILL make your contract
1750      * non-compliant with the ERC721 standard.
1751      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1752      * {ConsecutiveTransfer} event is only permissible during contract creation.
1753      *
1754      * Requirements:
1755      *
1756      * - `to` cannot be the zero address.
1757      * - `quantity` must be greater than 0.
1758      *
1759      * Emits a {ConsecutiveTransfer} event.
1760      */
1761     function _mintERC2309(address to, uint256 quantity) internal virtual {
1762         uint256 startTokenId = _currentIndex;
1763         if (to == address(0)) revert MintToZeroAddress();
1764         if (quantity == 0) revert MintZeroQuantity();
1765         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1766 
1767         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1768 
1769         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1770         unchecked {
1771             // Updates:
1772             // - `balance += quantity`.
1773             // - `numberMinted += quantity`.
1774             //
1775             // We can directly add to the `balance` and `numberMinted`.
1776             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1777 
1778             // Updates:
1779             // - `address` to the owner.
1780             // - `startTimestamp` to the timestamp of minting.
1781             // - `burned` to `false`.
1782             // - `nextInitialized` to `quantity == 1`.
1783             _packedOwnerships[startTokenId] = _packOwnershipData(
1784                 to,
1785                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1786             );
1787 
1788             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1789 
1790             _currentIndex = startTokenId + quantity;
1791         }
1792         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1793     }
1794 
1795     /**
1796      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1797      *
1798      * Requirements:
1799      *
1800      * - If `to` refers to a smart contract, it must implement
1801      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1802      * - `quantity` must be greater than 0.
1803      *
1804      * See {_mint}.
1805      *
1806      * Emits a {Transfer} event for each mint.
1807      */
1808     function _safeMint(
1809         address to,
1810         uint256 quantity,
1811         bytes memory _data
1812     ) internal virtual {
1813         _mint(to, quantity);
1814 
1815         unchecked {
1816             if (to.code.length != 0) {
1817                 uint256 end = _currentIndex;
1818                 uint256 index = end - quantity;
1819                 do {
1820                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1821                         revert TransferToNonERC721ReceiverImplementer();
1822                     }
1823                 } while (index < end);
1824                 // Reentrancy protection.
1825                 if (_currentIndex != end) revert();
1826             }
1827         }
1828     }
1829 
1830     /**
1831      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1832      */
1833     function _safeMint(address to, uint256 quantity) internal virtual {
1834         _safeMint(to, quantity, '');
1835     }
1836 
1837     // =============================================================
1838     //                        BURN OPERATIONS
1839     // =============================================================
1840 
1841     /**
1842      * @dev Equivalent to `_burn(tokenId, false)`.
1843      */
1844     function _burn(uint256 tokenId) internal virtual {
1845         _burn(tokenId, false);
1846     }
1847 
1848     /**
1849      * @dev Destroys `tokenId`.
1850      * The approval is cleared when the token is burned.
1851      *
1852      * Requirements:
1853      *
1854      * - `tokenId` must exist.
1855      *
1856      * Emits a {Transfer} event.
1857      */
1858     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1859         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1860 
1861         address from = address(uint160(prevOwnershipPacked));
1862 
1863         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1864 
1865         if (approvalCheck) {
1866             // The nested ifs save around 20+ gas over a compound boolean condition.
1867             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1868                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1869         }
1870 
1871         _beforeTokenTransfers(from, address(0), tokenId, 1);
1872 
1873         // Clear approvals from the previous owner.
1874         assembly {
1875             if approvedAddress {
1876                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1877                 sstore(approvedAddressSlot, 0)
1878             }
1879         }
1880 
1881         // Underflow of the sender's balance is impossible because we check for
1882         // ownership above and the recipient's balance can't realistically overflow.
1883         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1884         unchecked {
1885             // Updates:
1886             // - `balance -= 1`.
1887             // - `numberBurned += 1`.
1888             //
1889             // We can directly decrement the balance, and increment the number burned.
1890             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1891             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1892 
1893             // Updates:
1894             // - `address` to the last owner.
1895             // - `startTimestamp` to the timestamp of burning.
1896             // - `burned` to `true`.
1897             // - `nextInitialized` to `true`.
1898             _packedOwnerships[tokenId] = _packOwnershipData(
1899                 from,
1900                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1901             );
1902 
1903             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1904             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1905                 uint256 nextTokenId = tokenId + 1;
1906                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1907                 if (_packedOwnerships[nextTokenId] == 0) {
1908                     // If the next slot is within bounds.
1909                     if (nextTokenId != _currentIndex) {
1910                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1911                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1912                     }
1913                 }
1914             }
1915         }
1916 
1917         emit Transfer(from, address(0), tokenId);
1918         _afterTokenTransfers(from, address(0), tokenId, 1);
1919 
1920         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1921         unchecked {
1922             _burnCounter++;
1923         }
1924     }
1925 
1926     // =============================================================
1927     //                     EXTRA DATA OPERATIONS
1928     // =============================================================
1929 
1930     /**
1931      * @dev Directly sets the extra data for the ownership data `index`.
1932      */
1933     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1934         uint256 packed = _packedOwnerships[index];
1935         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1936         uint256 extraDataCasted;
1937         // Cast `extraData` with assembly to avoid redundant masking.
1938         assembly {
1939             extraDataCasted := extraData
1940         }
1941         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1942         _packedOwnerships[index] = packed;
1943     }
1944 
1945     /**
1946      * @dev Called during each token transfer to set the 24bit `extraData` field.
1947      * Intended to be overridden by the cosumer contract.
1948      *
1949      * `previousExtraData` - the value of `extraData` before transfer.
1950      *
1951      * Calling conditions:
1952      *
1953      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1954      * transferred to `to`.
1955      * - When `from` is zero, `tokenId` will be minted for `to`.
1956      * - When `to` is zero, `tokenId` will be burned by `from`.
1957      * - `from` and `to` are never both zero.
1958      */
1959     function _extraData(
1960         address from,
1961         address to,
1962         uint24 previousExtraData
1963     ) internal view virtual returns (uint24) {}
1964 
1965     /**
1966      * @dev Returns the next extra data for the packed ownership data.
1967      * The returned result is shifted into position.
1968      */
1969     function _nextExtraData(
1970         address from,
1971         address to,
1972         uint256 prevOwnershipPacked
1973     ) private view returns (uint256) {
1974         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1975         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1976     }
1977 
1978     // =============================================================
1979     //                       OTHER OPERATIONS
1980     // =============================================================
1981 
1982     /**
1983      * @dev Returns the message sender (defaults to `msg.sender`).
1984      *
1985      * If you are writing GSN compatible contracts, you need to override this function.
1986      */
1987     function _msgSenderERC721A() internal view virtual returns (address) {
1988         return msg.sender;
1989     }
1990 
1991     /**
1992      * @dev Converts a uint256 to its ASCII string decimal representation.
1993      */
1994     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1995         assembly {
1996             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1997             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1998             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1999             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2000             let m := add(mload(0x40), 0xa0)
2001             // Update the free memory pointer to allocate.
2002             mstore(0x40, m)
2003             // Assign the `str` to the end.
2004             str := sub(m, 0x20)
2005             // Zeroize the slot after the string.
2006             mstore(str, 0)
2007 
2008             // Cache the end of the memory to calculate the length later.
2009             let end := str
2010 
2011             // We write the string from rightmost digit to leftmost digit.
2012             // The following is essentially a do-while loop that also handles the zero case.
2013             // prettier-ignore
2014             for { let temp := value } 1 {} {
2015                 str := sub(str, 1)
2016                 // Write the character to the pointer.
2017                 // The ASCII index of the '0' character is 48.
2018                 mstore8(str, add(48, mod(temp, 10)))
2019                 // Keep dividing `temp` until zero.
2020                 temp := div(temp, 10)
2021                 // prettier-ignore
2022                 if iszero(temp) { break }
2023             }
2024 
2025             let length := sub(end, str)
2026             // Move the pointer 32 bytes leftwards to make room for the length.
2027             str := sub(str, 0x20)
2028             // Store the length.
2029             mstore(str, length)
2030         }
2031     }
2032 }
2033 
2034 // File: contracts/Misphits.sol
2035 
2036 //Author: Jordi Gago - acidcode.eth
2037 pragma solidity ^0.8.11;
2038 
2039 
2040 
2041 
2042 
2043 contract Misphits is ERC721A, AccessControl, ReentrancyGuard, Ownable {
2044     using Strings for uint256;
2045 
2046     string public baseURI_ = "https://meta-misphits.xyz/";
2047     string public extensionURI_ = "";
2048     bytes32 public constant MINTER_ROLE = keccak256("MISPHITSMINTER");
2049     uint256 public _supply = 2222;
2050     constructor() ERC721A("Misphits", "MSPHTS") {
2051         transferOwnership(tx.origin);
2052         _setupRole(DEFAULT_ADMIN_ROLE, tx.origin);
2053     }
2054 
2055     function mint(address to, uint256 quantity) external onlyRole(MINTER_ROLE) nonReentrant {
2056         require(totalSupply() + quantity <= _supply, "Misphits: Max supply exceded");
2057         _mint(to, quantity);
2058     }
2059     function transfer(address to, uint256 tokenId) external {
2060         transferFrom(msg.sender, to, tokenId);
2061     }
2062     function tokenURI(uint256 tokenId)
2063         public
2064         view
2065         virtual
2066         override
2067         returns (string memory)
2068     {
2069         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2070         string memory baseURI = _baseURI();
2071         return
2072             bytes(baseURI).length != 0
2073                 ? string(
2074                     abi.encodePacked(
2075                         baseURI,
2076                         tokenId.toString(),
2077                         _extensionURI()
2078                     )
2079                 )
2080                 : "";
2081     }
2082 
2083     function _baseURI() internal view virtual override returns (string memory) {
2084         return baseURI_;
2085     }
2086 
2087     function _extensionURI() internal view virtual returns (string memory) {
2088         return extensionURI_;
2089     }
2090 
2091     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721A, AccessControl) returns (bool) {
2092         return super.supportsInterface(interfaceId);
2093     }
2094     
2095     function changeBaseURI(string memory uri_) 
2096         external
2097         onlyRole(DEFAULT_ADMIN_ROLE)
2098     {
2099         baseURI_ = uri_;
2100     }
2101 
2102     function changeExtension(string memory extension_)
2103         external
2104         onlyRole(DEFAULT_ADMIN_ROLE)
2105     {
2106         extensionURI_ = extension_;
2107     }
2108 
2109     function changeSupply(uint256 supply_)
2110         external
2111         onlyRole(DEFAULT_ADMIN_ROLE)
2112     {
2113         _supply = supply_;
2114     }
2115 }