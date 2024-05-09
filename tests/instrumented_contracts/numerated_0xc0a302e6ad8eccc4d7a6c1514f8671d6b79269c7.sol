1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.4.0
4 
5 // OpenZeppelin Contracts v4.4.0 (access/IAccessControl.sol)
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
94 // File @openzeppelin/contracts/utils/Context.sol@v4.4.0
95 
96 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
97 
98 pragma solidity ^0.8.0;
99 
100 /**
101  * @dev Provides information about the current execution context, including the
102  * sender of the transaction and its data. While these are generally available
103  * via msg.sender and msg.data, they should not be accessed in such a direct
104  * manner, since when dealing with meta-transactions the account sending and
105  * paying for execution may not be the actual sender (as far as an application
106  * is concerned).
107  *
108  * This contract is only required for intermediate, library-like contracts.
109  */
110 abstract contract Context {
111     function _msgSender() internal view virtual returns (address) {
112         return msg.sender;
113     }
114 
115     function _msgData() internal view virtual returns (bytes calldata) {
116         return msg.data;
117     }
118 }
119 
120 
121 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.0
122 
123 // OpenZeppelin Contracts v4.4.0 (utils/Strings.sol)
124 
125 pragma solidity ^0.8.0;
126 
127 /**
128  * @dev String operations.
129  */
130 library Strings {
131     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
132 
133     /**
134      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
135      */
136     function toString(uint256 value) internal pure returns (string memory) {
137         // Inspired by OraclizeAPI's implementation - MIT licence
138         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
139 
140         if (value == 0) {
141             return "0";
142         }
143         uint256 temp = value;
144         uint256 digits;
145         while (temp != 0) {
146             digits++;
147             temp /= 10;
148         }
149         bytes memory buffer = new bytes(digits);
150         while (value != 0) {
151             digits -= 1;
152             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
153             value /= 10;
154         }
155         return string(buffer);
156     }
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
160      */
161     function toHexString(uint256 value) internal pure returns (string memory) {
162         if (value == 0) {
163             return "0x00";
164         }
165         uint256 temp = value;
166         uint256 length = 0;
167         while (temp != 0) {
168             length++;
169             temp >>= 8;
170         }
171         return toHexString(value, length);
172     }
173 
174     /**
175      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
176      */
177     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
178         bytes memory buffer = new bytes(2 * length + 2);
179         buffer[0] = "0";
180         buffer[1] = "x";
181         for (uint256 i = 2 * length + 1; i > 1; --i) {
182             buffer[i] = _HEX_SYMBOLS[value & 0xf];
183             value >>= 4;
184         }
185         require(value == 0, "Strings: hex length insufficient");
186         return string(buffer);
187     }
188 }
189 
190 
191 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.0
192 
193 // OpenZeppelin Contracts v4.4.0 (utils/introspection/IERC165.sol)
194 
195 pragma solidity ^0.8.0;
196 
197 /**
198  * @dev Interface of the ERC165 standard, as defined in the
199  * https://eips.ethereum.org/EIPS/eip-165[EIP].
200  *
201  * Implementers can declare support of contract interfaces, which can then be
202  * queried by others ({ERC165Checker}).
203  *
204  * For an implementation, see {ERC165}.
205  */
206 interface IERC165 {
207     /**
208      * @dev Returns true if this contract implements the interface defined by
209      * `interfaceId`. See the corresponding
210      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
211      * to learn more about how these ids are created.
212      *
213      * This function call must use less than 30 000 gas.
214      */
215     function supportsInterface(bytes4 interfaceId) external view returns (bool);
216 }
217 
218 
219 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.0
220 
221 // OpenZeppelin Contracts v4.4.0 (utils/introspection/ERC165.sol)
222 
223 pragma solidity ^0.8.0;
224 
225 /**
226  * @dev Implementation of the {IERC165} interface.
227  *
228  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
229  * for the additional interface id that will be supported. For example:
230  *
231  * ```solidity
232  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
233  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
234  * }
235  * ```
236  *
237  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
238  */
239 abstract contract ERC165 is IERC165 {
240     /**
241      * @dev See {IERC165-supportsInterface}.
242      */
243     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
244         return interfaceId == type(IERC165).interfaceId;
245     }
246 }
247 
248 
249 // File @openzeppelin/contracts/access/AccessControl.sol@v4.4.0
250 
251 // OpenZeppelin Contracts v4.4.0 (access/AccessControl.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 
256 
257 
258 /**
259  * @dev Contract module that allows children to implement role-based access
260  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
261  * members except through off-chain means by accessing the contract event logs. Some
262  * applications may benefit from on-chain enumerability, for those cases see
263  * {AccessControlEnumerable}.
264  *
265  * Roles are referred to by their `bytes32` identifier. These should be exposed
266  * in the external API and be unique. The best way to achieve this is by
267  * using `public constant` hash digests:
268  *
269  * ```
270  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
271  * ```
272  *
273  * Roles can be used to represent a set of permissions. To restrict access to a
274  * function call, use {hasRole}:
275  *
276  * ```
277  * function foo() public {
278  *     require(hasRole(MY_ROLE, msg.sender));
279  *     ...
280  * }
281  * ```
282  *
283  * Roles can be granted and revoked dynamically via the {grantRole} and
284  * {revokeRole} functions. Each role has an associated admin role, and only
285  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
286  *
287  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
288  * that only accounts with this role will be able to grant or revoke other
289  * roles. More complex role relationships can be created by using
290  * {_setRoleAdmin}.
291  *
292  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
293  * grant and revoke this role. Extra precautions should be taken to secure
294  * accounts that have been granted it.
295  */
296 abstract contract AccessControl is Context, IAccessControl, ERC165 {
297     struct RoleData {
298         mapping(address => bool) members;
299         bytes32 adminRole;
300     }
301 
302     mapping(bytes32 => RoleData) private _roles;
303 
304     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
305 
306     /**
307      * @dev Modifier that checks that an account has a specific role. Reverts
308      * with a standardized message including the required role.
309      *
310      * The format of the revert reason is given by the following regular expression:
311      *
312      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
313      *
314      * _Available since v4.1._
315      */
316     modifier onlyRole(bytes32 role) {
317         _checkRole(role, _msgSender());
318         _;
319     }
320 
321     /**
322      * @dev See {IERC165-supportsInterface}.
323      */
324     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
325         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
326     }
327 
328     /**
329      * @dev Returns `true` if `account` has been granted `role`.
330      */
331     function hasRole(bytes32 role, address account) public view override returns (bool) {
332         return _roles[role].members[account];
333     }
334 
335     /**
336      * @dev Revert with a standard message if `account` is missing `role`.
337      *
338      * The format of the revert reason is given by the following regular expression:
339      *
340      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
341      */
342     function _checkRole(bytes32 role, address account) internal view {
343         if (!hasRole(role, account)) {
344             revert(
345                 string(
346                     abi.encodePacked(
347                         "AccessControl: account ",
348                         Strings.toHexString(uint160(account), 20),
349                         " is missing role ",
350                         Strings.toHexString(uint256(role), 32)
351                     )
352                 )
353             );
354         }
355     }
356 
357     /**
358      * @dev Returns the admin role that controls `role`. See {grantRole} and
359      * {revokeRole}.
360      *
361      * To change a role's admin, use {_setRoleAdmin}.
362      */
363     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
364         return _roles[role].adminRole;
365     }
366 
367     /**
368      * @dev Grants `role` to `account`.
369      *
370      * If `account` had not been already granted `role`, emits a {RoleGranted}
371      * event.
372      *
373      * Requirements:
374      *
375      * - the caller must have ``role``'s admin role.
376      */
377     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
378         _grantRole(role, account);
379     }
380 
381     /**
382      * @dev Revokes `role` from `account`.
383      *
384      * If `account` had been granted `role`, emits a {RoleRevoked} event.
385      *
386      * Requirements:
387      *
388      * - the caller must have ``role``'s admin role.
389      */
390     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
391         _revokeRole(role, account);
392     }
393 
394     /**
395      * @dev Revokes `role` from the calling account.
396      *
397      * Roles are often managed via {grantRole} and {revokeRole}: this function's
398      * purpose is to provide a mechanism for accounts to lose their privileges
399      * if they are compromised (such as when a trusted device is misplaced).
400      *
401      * If the calling account had been revoked `role`, emits a {RoleRevoked}
402      * event.
403      *
404      * Requirements:
405      *
406      * - the caller must be `account`.
407      */
408     function renounceRole(bytes32 role, address account) public virtual override {
409         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
410 
411         _revokeRole(role, account);
412     }
413 
414     /**
415      * @dev Grants `role` to `account`.
416      *
417      * If `account` had not been already granted `role`, emits a {RoleGranted}
418      * event. Note that unlike {grantRole}, this function doesn't perform any
419      * checks on the calling account.
420      *
421      * [WARNING]
422      * ====
423      * This function should only be called from the constructor when setting
424      * up the initial roles for the system.
425      *
426      * Using this function in any other way is effectively circumventing the admin
427      * system imposed by {AccessControl}.
428      * ====
429      *
430      * NOTE: This function is deprecated in favor of {_grantRole}.
431      */
432     function _setupRole(bytes32 role, address account) internal virtual {
433         _grantRole(role, account);
434     }
435 
436     /**
437      * @dev Sets `adminRole` as ``role``'s admin role.
438      *
439      * Emits a {RoleAdminChanged} event.
440      */
441     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
442         bytes32 previousAdminRole = getRoleAdmin(role);
443         _roles[role].adminRole = adminRole;
444         emit RoleAdminChanged(role, previousAdminRole, adminRole);
445     }
446 
447     /**
448      * @dev Grants `role` to `account`.
449      *
450      * Internal function without access restriction.
451      */
452     function _grantRole(bytes32 role, address account) internal virtual {
453         if (!hasRole(role, account)) {
454             _roles[role].members[account] = true;
455             emit RoleGranted(role, account, _msgSender());
456         }
457     }
458 
459     /**
460      * @dev Revokes `role` from `account`.
461      *
462      * Internal function without access restriction.
463      */
464     function _revokeRole(bytes32 role, address account) internal virtual {
465         if (hasRole(role, account)) {
466             _roles[role].members[account] = false;
467             emit RoleRevoked(role, account, _msgSender());
468         }
469     }
470 }
471 
472 
473 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.4.0
474 
475 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
476 
477 pragma solidity ^0.8.0;
478 
479 /**
480  * @dev Interface of the ERC20 standard as defined in the EIP.
481  */
482 interface IERC20 {
483     /**
484      * @dev Returns the amount of tokens in existence.
485      */
486     function totalSupply() external view returns (uint256);
487 
488     /**
489      * @dev Returns the amount of tokens owned by `account`.
490      */
491     function balanceOf(address account) external view returns (uint256);
492 
493     /**
494      * @dev Moves `amount` tokens from the caller's account to `recipient`.
495      *
496      * Returns a boolean value indicating whether the operation succeeded.
497      *
498      * Emits a {Transfer} event.
499      */
500     function transfer(address recipient, uint256 amount) external returns (bool);
501 
502     /**
503      * @dev Returns the remaining number of tokens that `spender` will be
504      * allowed to spend on behalf of `owner` through {transferFrom}. This is
505      * zero by default.
506      *
507      * This value changes when {approve} or {transferFrom} are called.
508      */
509     function allowance(address owner, address spender) external view returns (uint256);
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
513      *
514      * Returns a boolean value indicating whether the operation succeeded.
515      *
516      * IMPORTANT: Beware that changing an allowance with this method brings the risk
517      * that someone may use both the old and the new allowance by unfortunate
518      * transaction ordering. One possible solution to mitigate this race
519      * condition is to first reduce the spender's allowance to 0 and set the
520      * desired value afterwards:
521      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
522      *
523      * Emits an {Approval} event.
524      */
525     function approve(address spender, uint256 amount) external returns (bool);
526 
527     /**
528      * @dev Moves `amount` tokens from `sender` to `recipient` using the
529      * allowance mechanism. `amount` is then deducted from the caller's
530      * allowance.
531      *
532      * Returns a boolean value indicating whether the operation succeeded.
533      *
534      * Emits a {Transfer} event.
535      */
536     function transferFrom(
537         address sender,
538         address recipient,
539         uint256 amount
540     ) external returns (bool);
541 
542     /**
543      * @dev Emitted when `value` tokens are moved from one account (`from`) to
544      * another (`to`).
545      *
546      * Note that `value` may be zero.
547      */
548     event Transfer(address indexed from, address indexed to, uint256 value);
549 
550     /**
551      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
552      * a call to {approve}. `value` is the new allowance.
553      */
554     event Approval(address indexed owner, address indexed spender, uint256 value);
555 }
556 
557 
558 // File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.4.0
559 
560 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721.sol)
561 
562 pragma solidity ^0.8.0;
563 
564 /**
565  * @dev Required interface of an ERC721 compliant contract.
566  */
567 interface IERC721 is IERC165 {
568     /**
569      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
570      */
571     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
572 
573     /**
574      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
575      */
576     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
577 
578     /**
579      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
580      */
581     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
582 
583     /**
584      * @dev Returns the number of tokens in ``owner``'s account.
585      */
586     function balanceOf(address owner) external view returns (uint256 balance);
587 
588     /**
589      * @dev Returns the owner of the `tokenId` token.
590      *
591      * Requirements:
592      *
593      * - `tokenId` must exist.
594      */
595     function ownerOf(uint256 tokenId) external view returns (address owner);
596 
597     /**
598      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
599      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
600      *
601      * Requirements:
602      *
603      * - `from` cannot be the zero address.
604      * - `to` cannot be the zero address.
605      * - `tokenId` token must exist and be owned by `from`.
606      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
607      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
608      *
609      * Emits a {Transfer} event.
610      */
611     function safeTransferFrom(
612         address from,
613         address to,
614         uint256 tokenId
615     ) external;
616 
617     /**
618      * @dev Transfers `tokenId` token from `from` to `to`.
619      *
620      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
621      *
622      * Requirements:
623      *
624      * - `from` cannot be the zero address.
625      * - `to` cannot be the zero address.
626      * - `tokenId` token must be owned by `from`.
627      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
628      *
629      * Emits a {Transfer} event.
630      */
631     function transferFrom(
632         address from,
633         address to,
634         uint256 tokenId
635     ) external;
636 
637     /**
638      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
639      * The approval is cleared when the token is transferred.
640      *
641      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
642      *
643      * Requirements:
644      *
645      * - The caller must own the token or be an approved operator.
646      * - `tokenId` must exist.
647      *
648      * Emits an {Approval} event.
649      */
650     function approve(address to, uint256 tokenId) external;
651 
652     /**
653      * @dev Returns the account approved for `tokenId` token.
654      *
655      * Requirements:
656      *
657      * - `tokenId` must exist.
658      */
659     function getApproved(uint256 tokenId) external view returns (address operator);
660 
661     /**
662      * @dev Approve or remove `operator` as an operator for the caller.
663      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
664      *
665      * Requirements:
666      *
667      * - The `operator` cannot be the caller.
668      *
669      * Emits an {ApprovalForAll} event.
670      */
671     function setApprovalForAll(address operator, bool _approved) external;
672 
673     /**
674      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
675      *
676      * See {setApprovalForAll}
677      */
678     function isApprovedForAll(address owner, address operator) external view returns (bool);
679 
680     /**
681      * @dev Safely transfers `tokenId` token from `from` to `to`.
682      *
683      * Requirements:
684      *
685      * - `from` cannot be the zero address.
686      * - `to` cannot be the zero address.
687      * - `tokenId` token must exist and be owned by `from`.
688      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
689      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
690      *
691      * Emits a {Transfer} event.
692      */
693     function safeTransferFrom(
694         address from,
695         address to,
696         uint256 tokenId,
697         bytes calldata data
698     ) external;
699 }
700 
701 
702 // File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.4.0
703 
704 // OpenZeppelin Contracts v4.4.0 (token/ERC721/IERC721Receiver.sol)
705 
706 pragma solidity ^0.8.0;
707 
708 /**
709  * @title ERC721 token receiver interface
710  * @dev Interface for any contract that wants to support safeTransfers
711  * from ERC721 asset contracts.
712  */
713 interface IERC721Receiver {
714     /**
715      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
716      * by `operator` from `from`, this function is called.
717      *
718      * It must return its Solidity selector to confirm the token transfer.
719      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
720      *
721      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
722      */
723     function onERC721Received(
724         address operator,
725         address from,
726         uint256 tokenId,
727         bytes calldata data
728     ) external returns (bytes4);
729 }
730 
731 
732 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol@v4.4.0
733 
734 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Metadata.sol)
735 
736 pragma solidity ^0.8.0;
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
740  * @dev See https://eips.ethereum.org/EIPS/eip-721
741  */
742 interface IERC721Metadata is IERC721 {
743     /**
744      * @dev Returns the token collection name.
745      */
746     function name() external view returns (string memory);
747 
748     /**
749      * @dev Returns the token collection symbol.
750      */
751     function symbol() external view returns (string memory);
752 
753     /**
754      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
755      */
756     function tokenURI(uint256 tokenId) external view returns (string memory);
757 }
758 
759 
760 // File @openzeppelin/contracts/utils/Address.sol@v4.4.0
761 
762 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
763 
764 pragma solidity ^0.8.0;
765 
766 /**
767  * @dev Collection of functions related to the address type
768  */
769 library Address {
770     /**
771      * @dev Returns true if `account` is a contract.
772      *
773      * [IMPORTANT]
774      * ====
775      * It is unsafe to assume that an address for which this function returns
776      * false is an externally-owned account (EOA) and not a contract.
777      *
778      * Among others, `isContract` will return false for the following
779      * types of addresses:
780      *
781      *  - an externally-owned account
782      *  - a contract in construction
783      *  - an address where a contract will be created
784      *  - an address where a contract lived, but was destroyed
785      * ====
786      */
787     function isContract(address account) internal view returns (bool) {
788         // This method relies on extcodesize, which returns 0 for contracts in
789         // construction, since the code is only stored at the end of the
790         // constructor execution.
791 
792         uint256 size;
793         assembly {
794             size := extcodesize(account)
795         }
796         return size > 0;
797     }
798 
799     /**
800      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
801      * `recipient`, forwarding all available gas and reverting on errors.
802      *
803      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
804      * of certain opcodes, possibly making contracts go over the 2300 gas limit
805      * imposed by `transfer`, making them unable to receive funds via
806      * `transfer`. {sendValue} removes this limitation.
807      *
808      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
809      *
810      * IMPORTANT: because control is transferred to `recipient`, care must be
811      * taken to not create reentrancy vulnerabilities. Consider using
812      * {ReentrancyGuard} or the
813      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
814      */
815     function sendValue(address payable recipient, uint256 amount) internal {
816         require(address(this).balance >= amount, "Address: insufficient balance");
817 
818         (bool success, ) = recipient.call{value: amount}("");
819         require(success, "Address: unable to send value, recipient may have reverted");
820     }
821 
822     /**
823      * @dev Performs a Solidity function call using a low level `call`. A
824      * plain `call` is an unsafe replacement for a function call: use this
825      * function instead.
826      *
827      * If `target` reverts with a revert reason, it is bubbled up by this
828      * function (like regular Solidity function calls).
829      *
830      * Returns the raw returned data. To convert to the expected return value,
831      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
832      *
833      * Requirements:
834      *
835      * - `target` must be a contract.
836      * - calling `target` with `data` must not revert.
837      *
838      * _Available since v3.1._
839      */
840     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
841         return functionCall(target, data, "Address: low-level call failed");
842     }
843 
844     /**
845      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
846      * `errorMessage` as a fallback revert reason when `target` reverts.
847      *
848      * _Available since v3.1._
849      */
850     function functionCall(
851         address target,
852         bytes memory data,
853         string memory errorMessage
854     ) internal returns (bytes memory) {
855         return functionCallWithValue(target, data, 0, errorMessage);
856     }
857 
858     /**
859      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
860      * but also transferring `value` wei to `target`.
861      *
862      * Requirements:
863      *
864      * - the calling contract must have an ETH balance of at least `value`.
865      * - the called Solidity function must be `payable`.
866      *
867      * _Available since v3.1._
868      */
869     function functionCallWithValue(
870         address target,
871         bytes memory data,
872         uint256 value
873     ) internal returns (bytes memory) {
874         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
875     }
876 
877     /**
878      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
879      * with `errorMessage` as a fallback revert reason when `target` reverts.
880      *
881      * _Available since v3.1._
882      */
883     function functionCallWithValue(
884         address target,
885         bytes memory data,
886         uint256 value,
887         string memory errorMessage
888     ) internal returns (bytes memory) {
889         require(address(this).balance >= value, "Address: insufficient balance for call");
890         require(isContract(target), "Address: call to non-contract");
891 
892         (bool success, bytes memory returndata) = target.call{value: value}(data);
893         return verifyCallResult(success, returndata, errorMessage);
894     }
895 
896     /**
897      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
898      * but performing a static call.
899      *
900      * _Available since v3.3._
901      */
902     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
903         return functionStaticCall(target, data, "Address: low-level static call failed");
904     }
905 
906     /**
907      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
908      * but performing a static call.
909      *
910      * _Available since v3.3._
911      */
912     function functionStaticCall(
913         address target,
914         bytes memory data,
915         string memory errorMessage
916     ) internal view returns (bytes memory) {
917         require(isContract(target), "Address: static call to non-contract");
918 
919         (bool success, bytes memory returndata) = target.staticcall(data);
920         return verifyCallResult(success, returndata, errorMessage);
921     }
922 
923     /**
924      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
925      * but performing a delegate call.
926      *
927      * _Available since v3.4._
928      */
929     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
930         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
931     }
932 
933     /**
934      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
935      * but performing a delegate call.
936      *
937      * _Available since v3.4._
938      */
939     function functionDelegateCall(
940         address target,
941         bytes memory data,
942         string memory errorMessage
943     ) internal returns (bytes memory) {
944         require(isContract(target), "Address: delegate call to non-contract");
945 
946         (bool success, bytes memory returndata) = target.delegatecall(data);
947         return verifyCallResult(success, returndata, errorMessage);
948     }
949 
950     /**
951      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
952      * revert reason using the provided one.
953      *
954      * _Available since v4.3._
955      */
956     function verifyCallResult(
957         bool success,
958         bytes memory returndata,
959         string memory errorMessage
960     ) internal pure returns (bytes memory) {
961         if (success) {
962             return returndata;
963         } else {
964             // Look for revert reason and bubble it up if present
965             if (returndata.length > 0) {
966                 // The easiest way to bubble the revert reason is using memory via assembly
967 
968                 assembly {
969                     let returndata_size := mload(returndata)
970                     revert(add(32, returndata), returndata_size)
971                 }
972             } else {
973                 revert(errorMessage);
974             }
975         }
976     }
977 }
978 
979 
980 // File @openzeppelin/contracts/token/ERC721/ERC721.sol@v4.4.0
981 
982 // OpenZeppelin Contracts v4.4.0 (token/ERC721/ERC721.sol)
983 
984 pragma solidity ^0.8.0;
985 
986 
987 
988 
989 
990 
991 
992 /**
993  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
994  * the Metadata extension, but not including the Enumerable extension, which is available separately as
995  * {ERC721Enumerable}.
996  */
997 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
998     using Address for address;
999     using Strings for uint256;
1000 
1001     // Token name
1002     string private _name;
1003 
1004     // Token symbol
1005     string private _symbol;
1006 
1007     // Mapping from token ID to owner address
1008     mapping(uint256 => address) private _owners;
1009 
1010     // Mapping owner address to token count
1011     mapping(address => uint256) private _balances;
1012 
1013     // Mapping from token ID to approved address
1014     mapping(uint256 => address) private _tokenApprovals;
1015 
1016     // Mapping from owner to operator approvals
1017     mapping(address => mapping(address => bool)) private _operatorApprovals;
1018 
1019     /**
1020      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1021      */
1022     constructor(string memory name_, string memory symbol_) {
1023         _name = name_;
1024         _symbol = symbol_;
1025     }
1026 
1027     /**
1028      * @dev See {IERC165-supportsInterface}.
1029      */
1030     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1031         return
1032             interfaceId == type(IERC721).interfaceId ||
1033             interfaceId == type(IERC721Metadata).interfaceId ||
1034             super.supportsInterface(interfaceId);
1035     }
1036 
1037     /**
1038      * @dev See {IERC721-balanceOf}.
1039      */
1040     function balanceOf(address owner) public view virtual override returns (uint256) {
1041         require(owner != address(0), "ERC721: balance query for the zero address");
1042         return _balances[owner];
1043     }
1044 
1045     /**
1046      * @dev See {IERC721-ownerOf}.
1047      */
1048     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1049         address owner = _owners[tokenId];
1050         require(owner != address(0), "ERC721: owner query for nonexistent token");
1051         return owner;
1052     }
1053 
1054     /**
1055      * @dev See {IERC721Metadata-name}.
1056      */
1057     function name() public view virtual override returns (string memory) {
1058         return _name;
1059     }
1060 
1061     /**
1062      * @dev See {IERC721Metadata-symbol}.
1063      */
1064     function symbol() public view virtual override returns (string memory) {
1065         return _symbol;
1066     }
1067 
1068     /**
1069      * @dev See {IERC721Metadata-tokenURI}.
1070      */
1071     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1072         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1073 
1074         string memory baseURI = _baseURI();
1075         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1076     }
1077 
1078     /**
1079      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1080      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1081      * by default, can be overriden in child contracts.
1082      */
1083     function _baseURI() internal view virtual returns (string memory) {
1084         return "";
1085     }
1086 
1087     /**
1088      * @dev See {IERC721-approve}.
1089      */
1090     function approve(address to, uint256 tokenId) public virtual override {
1091         address owner = ERC721.ownerOf(tokenId);
1092         require(to != owner, "ERC721: approval to current owner");
1093 
1094         require(
1095             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1096             "ERC721: approve caller is not owner nor approved for all"
1097         );
1098 
1099         _approve(to, tokenId);
1100     }
1101 
1102     /**
1103      * @dev See {IERC721-getApproved}.
1104      */
1105     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1106         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1107 
1108         return _tokenApprovals[tokenId];
1109     }
1110 
1111     /**
1112      * @dev See {IERC721-setApprovalForAll}.
1113      */
1114     function setApprovalForAll(address operator, bool approved) public virtual override {
1115         _setApprovalForAll(_msgSender(), operator, approved);
1116     }
1117 
1118     /**
1119      * @dev See {IERC721-isApprovedForAll}.
1120      */
1121     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1122         return _operatorApprovals[owner][operator];
1123     }
1124 
1125     /**
1126      * @dev See {IERC721-transferFrom}.
1127      */
1128     function transferFrom(
1129         address from,
1130         address to,
1131         uint256 tokenId
1132     ) public virtual override {
1133         //solhint-disable-next-line max-line-length
1134         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1135 
1136         _transfer(from, to, tokenId);
1137     }
1138 
1139     /**
1140      * @dev See {IERC721-safeTransferFrom}.
1141      */
1142     function safeTransferFrom(
1143         address from,
1144         address to,
1145         uint256 tokenId
1146     ) public virtual override {
1147         safeTransferFrom(from, to, tokenId, "");
1148     }
1149 
1150     /**
1151      * @dev See {IERC721-safeTransferFrom}.
1152      */
1153     function safeTransferFrom(
1154         address from,
1155         address to,
1156         uint256 tokenId,
1157         bytes memory _data
1158     ) public virtual override {
1159         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1160         _safeTransfer(from, to, tokenId, _data);
1161     }
1162 
1163     /**
1164      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1165      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1166      *
1167      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1168      *
1169      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1170      * implement alternative mechanisms to perform token transfer, such as signature-based.
1171      *
1172      * Requirements:
1173      *
1174      * - `from` cannot be the zero address.
1175      * - `to` cannot be the zero address.
1176      * - `tokenId` token must exist and be owned by `from`.
1177      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1178      *
1179      * Emits a {Transfer} event.
1180      */
1181     function _safeTransfer(
1182         address from,
1183         address to,
1184         uint256 tokenId,
1185         bytes memory _data
1186     ) internal virtual {
1187         _transfer(from, to, tokenId);
1188         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1189     }
1190 
1191     /**
1192      * @dev Returns whether `tokenId` exists.
1193      *
1194      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1195      *
1196      * Tokens start existing when they are minted (`_mint`),
1197      * and stop existing when they are burned (`_burn`).
1198      */
1199     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1200         return _owners[tokenId] != address(0);
1201     }
1202 
1203     /**
1204      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1205      *
1206      * Requirements:
1207      *
1208      * - `tokenId` must exist.
1209      */
1210     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1211         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1212         address owner = ERC721.ownerOf(tokenId);
1213         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1214     }
1215 
1216     /**
1217      * @dev Safely mints `tokenId` and transfers it to `to`.
1218      *
1219      * Requirements:
1220      *
1221      * - `tokenId` must not exist.
1222      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1223      *
1224      * Emits a {Transfer} event.
1225      */
1226     function _safeMint(address to, uint256 tokenId) internal virtual {
1227         _safeMint(to, tokenId, "");
1228     }
1229 
1230     /**
1231      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1232      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1233      */
1234     function _safeMint(
1235         address to,
1236         uint256 tokenId,
1237         bytes memory _data
1238     ) internal virtual {
1239         _mint(to, tokenId);
1240         require(
1241             _checkOnERC721Received(address(0), to, tokenId, _data),
1242             "ERC721: transfer to non ERC721Receiver implementer"
1243         );
1244     }
1245 
1246     /**
1247      * @dev Mints `tokenId` and transfers it to `to`.
1248      *
1249      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1250      *
1251      * Requirements:
1252      *
1253      * - `tokenId` must not exist.
1254      * - `to` cannot be the zero address.
1255      *
1256      * Emits a {Transfer} event.
1257      */
1258     function _mint(address to, uint256 tokenId) internal virtual {
1259         require(to != address(0), "ERC721: mint to the zero address");
1260         require(!_exists(tokenId), "ERC721: token already minted");
1261 
1262         _beforeTokenTransfer(address(0), to, tokenId);
1263 
1264         _balances[to] += 1;
1265         _owners[tokenId] = to;
1266 
1267         emit Transfer(address(0), to, tokenId);
1268     }
1269 
1270     /**
1271      * @dev Destroys `tokenId`.
1272      * The approval is cleared when the token is burned.
1273      *
1274      * Requirements:
1275      *
1276      * - `tokenId` must exist.
1277      *
1278      * Emits a {Transfer} event.
1279      */
1280     function _burn(uint256 tokenId) internal virtual {
1281         address owner = ERC721.ownerOf(tokenId);
1282 
1283         _beforeTokenTransfer(owner, address(0), tokenId);
1284 
1285         // Clear approvals
1286         _approve(address(0), tokenId);
1287 
1288         _balances[owner] -= 1;
1289         delete _owners[tokenId];
1290 
1291         emit Transfer(owner, address(0), tokenId);
1292     }
1293 
1294     /**
1295      * @dev Transfers `tokenId` from `from` to `to`.
1296      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1297      *
1298      * Requirements:
1299      *
1300      * - `to` cannot be the zero address.
1301      * - `tokenId` token must be owned by `from`.
1302      *
1303      * Emits a {Transfer} event.
1304      */
1305     function _transfer(
1306         address from,
1307         address to,
1308         uint256 tokenId
1309     ) internal virtual {
1310         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1311         require(to != address(0), "ERC721: transfer to the zero address");
1312 
1313         _beforeTokenTransfer(from, to, tokenId);
1314 
1315         // Clear approvals from the previous owner
1316         _approve(address(0), tokenId);
1317 
1318         _balances[from] -= 1;
1319         _balances[to] += 1;
1320         _owners[tokenId] = to;
1321 
1322         emit Transfer(from, to, tokenId);
1323     }
1324 
1325     /**
1326      * @dev Approve `to` to operate on `tokenId`
1327      *
1328      * Emits a {Approval} event.
1329      */
1330     function _approve(address to, uint256 tokenId) internal virtual {
1331         _tokenApprovals[tokenId] = to;
1332         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1333     }
1334 
1335     /**
1336      * @dev Approve `operator` to operate on all of `owner` tokens
1337      *
1338      * Emits a {ApprovalForAll} event.
1339      */
1340     function _setApprovalForAll(
1341         address owner,
1342         address operator,
1343         bool approved
1344     ) internal virtual {
1345         require(owner != operator, "ERC721: approve to caller");
1346         _operatorApprovals[owner][operator] = approved;
1347         emit ApprovalForAll(owner, operator, approved);
1348     }
1349 
1350     /**
1351      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1352      * The call is not executed if the target address is not a contract.
1353      *
1354      * @param from address representing the previous owner of the given token ID
1355      * @param to target address that will receive the tokens
1356      * @param tokenId uint256 ID of the token to be transferred
1357      * @param _data bytes optional data to send along with the call
1358      * @return bool whether the call correctly returned the expected magic value
1359      */
1360     function _checkOnERC721Received(
1361         address from,
1362         address to,
1363         uint256 tokenId,
1364         bytes memory _data
1365     ) private returns (bool) {
1366         if (to.isContract()) {
1367             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1368                 return retval == IERC721Receiver.onERC721Received.selector;
1369             } catch (bytes memory reason) {
1370                 if (reason.length == 0) {
1371                     revert("ERC721: transfer to non ERC721Receiver implementer");
1372                 } else {
1373                     assembly {
1374                         revert(add(32, reason), mload(reason))
1375                     }
1376                 }
1377             }
1378         } else {
1379             return true;
1380         }
1381     }
1382 
1383     /**
1384      * @dev Hook that is called before any token transfer. This includes minting
1385      * and burning.
1386      *
1387      * Calling conditions:
1388      *
1389      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1390      * transferred to `to`.
1391      * - When `from` is zero, `tokenId` will be minted for `to`.
1392      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1393      * - `from` and `to` are never both zero.
1394      *
1395      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1396      */
1397     function _beforeTokenTransfer(
1398         address from,
1399         address to,
1400         uint256 tokenId
1401     ) internal virtual {}
1402 }
1403 
1404 
1405 // File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.4.0
1406 
1407 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/IERC721Enumerable.sol)
1408 
1409 pragma solidity ^0.8.0;
1410 
1411 /**
1412  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
1413  * @dev See https://eips.ethereum.org/EIPS/eip-721
1414  */
1415 interface IERC721Enumerable is IERC721 {
1416     /**
1417      * @dev Returns the total amount of tokens stored by the contract.
1418      */
1419     function totalSupply() external view returns (uint256);
1420 
1421     /**
1422      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
1423      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
1424      */
1425     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
1426 
1427     /**
1428      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
1429      * Use along with {totalSupply} to enumerate all tokens.
1430      */
1431     function tokenByIndex(uint256 index) external view returns (uint256);
1432 }
1433 
1434 
1435 // File @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol@v4.4.0
1436 
1437 // OpenZeppelin Contracts v4.4.0 (token/ERC721/extensions/ERC721Enumerable.sol)
1438 
1439 pragma solidity ^0.8.0;
1440 
1441 
1442 /**
1443  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1444  * enumerability of all the token ids in the contract as well as all token ids owned by each
1445  * account.
1446  */
1447 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1448     // Mapping from owner to list of owned token IDs
1449     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1450 
1451     // Mapping from token ID to index of the owner tokens list
1452     mapping(uint256 => uint256) private _ownedTokensIndex;
1453 
1454     // Array with all token ids, used for enumeration
1455     uint256[] private _allTokens;
1456 
1457     // Mapping from token id to position in the allTokens array
1458     mapping(uint256 => uint256) private _allTokensIndex;
1459 
1460     /**
1461      * @dev See {IERC165-supportsInterface}.
1462      */
1463     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1464         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1465     }
1466 
1467     /**
1468      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1469      */
1470     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1471         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1472         return _ownedTokens[owner][index];
1473     }
1474 
1475     /**
1476      * @dev See {IERC721Enumerable-totalSupply}.
1477      */
1478     function totalSupply() public view virtual override returns (uint256) {
1479         return _allTokens.length;
1480     }
1481 
1482     /**
1483      * @dev See {IERC721Enumerable-tokenByIndex}.
1484      */
1485     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1486         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1487         return _allTokens[index];
1488     }
1489 
1490     /**
1491      * @dev Hook that is called before any token transfer. This includes minting
1492      * and burning.
1493      *
1494      * Calling conditions:
1495      *
1496      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1497      * transferred to `to`.
1498      * - When `from` is zero, `tokenId` will be minted for `to`.
1499      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1500      * - `from` cannot be the zero address.
1501      * - `to` cannot be the zero address.
1502      *
1503      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1504      */
1505     function _beforeTokenTransfer(
1506         address from,
1507         address to,
1508         uint256 tokenId
1509     ) internal virtual override {
1510         super._beforeTokenTransfer(from, to, tokenId);
1511 
1512         if (from == address(0)) {
1513             _addTokenToAllTokensEnumeration(tokenId);
1514         } else if (from != to) {
1515             _removeTokenFromOwnerEnumeration(from, tokenId);
1516         }
1517         if (to == address(0)) {
1518             _removeTokenFromAllTokensEnumeration(tokenId);
1519         } else if (to != from) {
1520             _addTokenToOwnerEnumeration(to, tokenId);
1521         }
1522     }
1523 
1524     /**
1525      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1526      * @param to address representing the new owner of the given token ID
1527      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1528      */
1529     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1530         uint256 length = ERC721.balanceOf(to);
1531         _ownedTokens[to][length] = tokenId;
1532         _ownedTokensIndex[tokenId] = length;
1533     }
1534 
1535     /**
1536      * @dev Private function to add a token to this extension's token tracking data structures.
1537      * @param tokenId uint256 ID of the token to be added to the tokens list
1538      */
1539     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1540         _allTokensIndex[tokenId] = _allTokens.length;
1541         _allTokens.push(tokenId);
1542     }
1543 
1544     /**
1545      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1546      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1547      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1548      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1549      * @param from address representing the previous owner of the given token ID
1550      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1551      */
1552     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1553         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1554         // then delete the last slot (swap and pop).
1555 
1556         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1557         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1558 
1559         // When the token to delete is the last token, the swap operation is unnecessary
1560         if (tokenIndex != lastTokenIndex) {
1561             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1562 
1563             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1564             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1565         }
1566 
1567         // This also deletes the contents at the last position of the array
1568         delete _ownedTokensIndex[tokenId];
1569         delete _ownedTokens[from][lastTokenIndex];
1570     }
1571 
1572     /**
1573      * @dev Private function to remove a token from this extension's token tracking data structures.
1574      * This has O(1) time complexity, but alters the order of the _allTokens array.
1575      * @param tokenId uint256 ID of the token to be removed from the tokens list
1576      */
1577     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1578         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1579         // then delete the last slot (swap and pop).
1580 
1581         uint256 lastTokenIndex = _allTokens.length - 1;
1582         uint256 tokenIndex = _allTokensIndex[tokenId];
1583 
1584         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1585         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1586         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1587         uint256 lastTokenId = _allTokens[lastTokenIndex];
1588 
1589         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1590         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1591 
1592         // This also deletes the contents at the last position of the array
1593         delete _allTokensIndex[tokenId];
1594         _allTokens.pop();
1595     }
1596 }
1597 
1598 
1599 // File @openzeppelin/contracts/utils/Counters.sol@v4.4.0
1600 
1601 // OpenZeppelin Contracts v4.4.0 (utils/Counters.sol)
1602 
1603 pragma solidity ^0.8.0;
1604 
1605 /**
1606  * @title Counters
1607  * @author Matt Condon (@shrugs)
1608  * @dev Provides counters that can only be incremented, decremented or reset. This can be used e.g. to track the number
1609  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1610  *
1611  * Include with `using Counters for Counters.Counter;`
1612  */
1613 library Counters {
1614     struct Counter {
1615         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1616         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1617         // this feature: see https://github.com/ethereum/solidity/issues/4637
1618         uint256 _value; // default: 0
1619     }
1620 
1621     function current(Counter storage counter) internal view returns (uint256) {
1622         return counter._value;
1623     }
1624 
1625     function increment(Counter storage counter) internal {
1626         unchecked {
1627             counter._value += 1;
1628         }
1629     }
1630 
1631     function decrement(Counter storage counter) internal {
1632         uint256 value = counter._value;
1633         require(value > 0, "Counter: decrement overflow");
1634         unchecked {
1635             counter._value = value - 1;
1636         }
1637     }
1638 
1639     function reset(Counter storage counter) internal {
1640         counter._value = 0;
1641     }
1642 }
1643 
1644 
1645 // File @openzeppelin/contracts/utils/cryptography/ECDSA.sol@v4.4.0
1646 
1647 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/ECDSA.sol)
1648 
1649 pragma solidity ^0.8.0;
1650 
1651 /**
1652  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1653  *
1654  * These functions can be used to verify that a message was signed by the holder
1655  * of the private keys of a given address.
1656  */
1657 library ECDSA {
1658     enum RecoverError {
1659         NoError,
1660         InvalidSignature,
1661         InvalidSignatureLength,
1662         InvalidSignatureS,
1663         InvalidSignatureV
1664     }
1665 
1666     function _throwError(RecoverError error) private pure {
1667         if (error == RecoverError.NoError) {
1668             return; // no error: do nothing
1669         } else if (error == RecoverError.InvalidSignature) {
1670             revert("ECDSA: invalid signature");
1671         } else if (error == RecoverError.InvalidSignatureLength) {
1672             revert("ECDSA: invalid signature length");
1673         } else if (error == RecoverError.InvalidSignatureS) {
1674             revert("ECDSA: invalid signature 's' value");
1675         } else if (error == RecoverError.InvalidSignatureV) {
1676             revert("ECDSA: invalid signature 'v' value");
1677         }
1678     }
1679 
1680     /**
1681      * @dev Returns the address that signed a hashed message (`hash`) with
1682      * `signature` or error string. This address can then be used for verification purposes.
1683      *
1684      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1685      * this function rejects them by requiring the `s` value to be in the lower
1686      * half order, and the `v` value to be either 27 or 28.
1687      *
1688      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1689      * verification to be secure: it is possible to craft signatures that
1690      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1691      * this is by receiving a hash of the original message (which may otherwise
1692      * be too long), and then calling {toEthSignedMessageHash} on it.
1693      *
1694      * Documentation for signature generation:
1695      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
1696      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
1697      *
1698      * _Available since v4.3._
1699      */
1700     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
1701         // Check the signature length
1702         // - case 65: r,s,v signature (standard)
1703         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
1704         if (signature.length == 65) {
1705             bytes32 r;
1706             bytes32 s;
1707             uint8 v;
1708             // ecrecover takes the signature parameters, and the only way to get them
1709             // currently is to use assembly.
1710             assembly {
1711                 r := mload(add(signature, 0x20))
1712                 s := mload(add(signature, 0x40))
1713                 v := byte(0, mload(add(signature, 0x60)))
1714             }
1715             return tryRecover(hash, v, r, s);
1716         } else if (signature.length == 64) {
1717             bytes32 r;
1718             bytes32 vs;
1719             // ecrecover takes the signature parameters, and the only way to get them
1720             // currently is to use assembly.
1721             assembly {
1722                 r := mload(add(signature, 0x20))
1723                 vs := mload(add(signature, 0x40))
1724             }
1725             return tryRecover(hash, r, vs);
1726         } else {
1727             return (address(0), RecoverError.InvalidSignatureLength);
1728         }
1729     }
1730 
1731     /**
1732      * @dev Returns the address that signed a hashed message (`hash`) with
1733      * `signature`. This address can then be used for verification purposes.
1734      *
1735      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1736      * this function rejects them by requiring the `s` value to be in the lower
1737      * half order, and the `v` value to be either 27 or 28.
1738      *
1739      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
1740      * verification to be secure: it is possible to craft signatures that
1741      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1742      * this is by receiving a hash of the original message (which may otherwise
1743      * be too long), and then calling {toEthSignedMessageHash} on it.
1744      */
1745     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1746         (address recovered, RecoverError error) = tryRecover(hash, signature);
1747         _throwError(error);
1748         return recovered;
1749     }
1750 
1751     /**
1752      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
1753      *
1754      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
1755      *
1756      * _Available since v4.3._
1757      */
1758     function tryRecover(
1759         bytes32 hash,
1760         bytes32 r,
1761         bytes32 vs
1762     ) internal pure returns (address, RecoverError) {
1763         bytes32 s;
1764         uint8 v;
1765         assembly {
1766             s := and(vs, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
1767             v := add(shr(255, vs), 27)
1768         }
1769         return tryRecover(hash, v, r, s);
1770     }
1771 
1772     /**
1773      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
1774      *
1775      * _Available since v4.2._
1776      */
1777     function recover(
1778         bytes32 hash,
1779         bytes32 r,
1780         bytes32 vs
1781     ) internal pure returns (address) {
1782         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
1783         _throwError(error);
1784         return recovered;
1785     }
1786 
1787     /**
1788      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
1789      * `r` and `s` signature fields separately.
1790      *
1791      * _Available since v4.3._
1792      */
1793     function tryRecover(
1794         bytes32 hash,
1795         uint8 v,
1796         bytes32 r,
1797         bytes32 s
1798     ) internal pure returns (address, RecoverError) {
1799         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1800         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1801         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
1802         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1803         //
1804         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1805         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1806         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1807         // these malleable signatures as well.
1808         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1809             return (address(0), RecoverError.InvalidSignatureS);
1810         }
1811         if (v != 27 && v != 28) {
1812             return (address(0), RecoverError.InvalidSignatureV);
1813         }
1814 
1815         // If the signature is valid (and not malleable), return the signer address
1816         address signer = ecrecover(hash, v, r, s);
1817         if (signer == address(0)) {
1818             return (address(0), RecoverError.InvalidSignature);
1819         }
1820 
1821         return (signer, RecoverError.NoError);
1822     }
1823 
1824     /**
1825      * @dev Overload of {ECDSA-recover} that receives the `v`,
1826      * `r` and `s` signature fields separately.
1827      */
1828     function recover(
1829         bytes32 hash,
1830         uint8 v,
1831         bytes32 r,
1832         bytes32 s
1833     ) internal pure returns (address) {
1834         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1835         _throwError(error);
1836         return recovered;
1837     }
1838 
1839     /**
1840      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1841      * produces hash corresponding to the one signed with the
1842      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1843      * JSON-RPC method as part of EIP-191.
1844      *
1845      * See {recover}.
1846      */
1847     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1848         // 32 is the length in bytes of hash,
1849         // enforced by the type signature above
1850         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1851     }
1852 
1853     /**
1854      * @dev Returns an Ethereum Signed Message, created from `s`. This
1855      * produces hash corresponding to the one signed with the
1856      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1857      * JSON-RPC method as part of EIP-191.
1858      *
1859      * See {recover}.
1860      */
1861     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1862         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1863     }
1864 
1865     /**
1866      * @dev Returns an Ethereum Signed Typed Data, created from a
1867      * `domainSeparator` and a `structHash`. This produces hash corresponding
1868      * to the one signed with the
1869      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1870      * JSON-RPC method as part of EIP-712.
1871      *
1872      * See {recover}.
1873      */
1874     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1875         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1876     }
1877 }
1878 
1879 
1880 // File @openzeppelin/contracts/utils/cryptography/draft-EIP712.sol@v4.4.0
1881 
1882 // OpenZeppelin Contracts v4.4.0 (utils/cryptography/draft-EIP712.sol)
1883 
1884 pragma solidity ^0.8.0;
1885 
1886 /**
1887  * @dev https://eips.ethereum.org/EIPS/eip-712[EIP 712] is a standard for hashing and signing of typed structured data.
1888  *
1889  * The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible,
1890  * thus this contract does not implement the encoding itself. Protocols need to implement the type-specific encoding
1891  * they need in their contracts using a combination of `abi.encode` and `keccak256`.
1892  *
1893  * This contract implements the EIP 712 domain separator ({_domainSeparatorV4}) that is used as part of the encoding
1894  * scheme, and the final step of the encoding to obtain the message digest that is then signed via ECDSA
1895  * ({_hashTypedDataV4}).
1896  *
1897  * The implementation of the domain separator was designed to be as efficient as possible while still properly updating
1898  * the chain id to protect against replay attacks on an eventual fork of the chain.
1899  *
1900  * NOTE: This contract implements the version of the encoding known as "v4", as implemented by the JSON RPC method
1901  * https://docs.metamask.io/guide/signing-data.html[`eth_signTypedDataV4` in MetaMask].
1902  *
1903  * _Available since v3.4._
1904  */
1905 abstract contract EIP712 {
1906     /* solhint-disable var-name-mixedcase */
1907     // Cache the domain separator as an immutable value, but also store the chain id that it corresponds to, in order to
1908     // invalidate the cached domain separator if the chain id changes.
1909     bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;
1910     uint256 private immutable _CACHED_CHAIN_ID;
1911     address private immutable _CACHED_THIS;
1912 
1913     bytes32 private immutable _HASHED_NAME;
1914     bytes32 private immutable _HASHED_VERSION;
1915     bytes32 private immutable _TYPE_HASH;
1916 
1917     /* solhint-enable var-name-mixedcase */
1918 
1919     /**
1920      * @dev Initializes the domain separator and parameter caches.
1921      *
1922      * The meaning of `name` and `version` is specified in
1923      * https://eips.ethereum.org/EIPS/eip-712#definition-of-domainseparator[EIP 712]:
1924      *
1925      * - `name`: the user readable name of the signing domain, i.e. the name of the DApp or the protocol.
1926      * - `version`: the current major version of the signing domain.
1927      *
1928      * NOTE: These parameters cannot be changed except through a xref:learn::upgrading-smart-contracts.adoc[smart
1929      * contract upgrade].
1930      */
1931     constructor(string memory name, string memory version) {
1932         bytes32 hashedName = keccak256(bytes(name));
1933         bytes32 hashedVersion = keccak256(bytes(version));
1934         bytes32 typeHash = keccak256(
1935             "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1936         );
1937         _HASHED_NAME = hashedName;
1938         _HASHED_VERSION = hashedVersion;
1939         _CACHED_CHAIN_ID = block.chainid;
1940         _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(typeHash, hashedName, hashedVersion);
1941         _CACHED_THIS = address(this);
1942         _TYPE_HASH = typeHash;
1943     }
1944 
1945     /**
1946      * @dev Returns the domain separator for the current chain.
1947      */
1948     function _domainSeparatorV4() internal view returns (bytes32) {
1949         if (address(this) == _CACHED_THIS && block.chainid == _CACHED_CHAIN_ID) {
1950             return _CACHED_DOMAIN_SEPARATOR;
1951         } else {
1952             return _buildDomainSeparator(_TYPE_HASH, _HASHED_NAME, _HASHED_VERSION);
1953         }
1954     }
1955 
1956     function _buildDomainSeparator(
1957         bytes32 typeHash,
1958         bytes32 nameHash,
1959         bytes32 versionHash
1960     ) private view returns (bytes32) {
1961         return keccak256(abi.encode(typeHash, nameHash, versionHash, block.chainid, address(this)));
1962     }
1963 
1964     /**
1965      * @dev Given an already https://eips.ethereum.org/EIPS/eip-712#definition-of-hashstruct[hashed struct], this
1966      * function returns the hash of the fully encoded EIP712 message for this domain.
1967      *
1968      * This hash can be used together with {ECDSA-recover} to obtain the signer of a message. For example:
1969      *
1970      * ```solidity
1971      * bytes32 digest = _hashTypedDataV4(keccak256(abi.encode(
1972      *     keccak256("Mail(address to,string contents)"),
1973      *     mailTo,
1974      *     keccak256(bytes(mailContents))
1975      * )));
1976      * address signer = ECDSA.recover(digest, signature);
1977      * ```
1978      */
1979     function _hashTypedDataV4(bytes32 structHash) internal view virtual returns (bytes32) {
1980         return ECDSA.toTypedDataHash(_domainSeparatorV4(), structHash);
1981     }
1982 }
1983 
1984 
1985 // File contracts/AgoraS01.sol
1986 
1987 // SPDX-License-Identifier: Unlicense
1988 
1989 pragma solidity ^0.8.0;
1990 
1991 
1992 
1993 
1994 
1995 
1996 
1997 contract AgoraS01 is AccessControl, EIP712, ERC721, ERC721Enumerable {  
1998 
1999     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
2000     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
2001     bytes32 private constant _INTERFACE = keccak256("AgoraS01(address claimer,bool allowed,uint256 amount)");
2002 
2003     using Counters for Counters.Counter;
2004     Counters.Counter public _tokenIds;
2005     string public _tokenURI;
2006 
2007     uint256 public _deadline;
2008     address public _treasury;
2009     IERC20 public _token;
2010 
2011     constructor(IERC20 token) EIP712("AgoraS01", "1") ERC721("Agora Citizenship S01", "AS01") {
2012 
2013         _grantRole(DEFAULT_ADMIN_ROLE, 0x5581853b68b9EeE4f91dbA5Ad1202D9375AA5997);
2014         _grantRole(MINTER_ROLE, 0x6f22E55508Bb7cAB9E0E080D997D682F024844A1);
2015         _grantRole(BURNER_ROLE, 0x5581853b68b9EeE4f91dbA5Ad1202D9375AA5997);
2016 
2017         _deadline = 1640995200;
2018         _treasury = 0x41886617412d65AAB0Fe58e71946892e56D00CDa;
2019         _token = token;
2020 
2021     }
2022 
2023     function claim(uint256 amount, bytes calldata signature) external {
2024 
2025         // Check signature.
2026         bytes32 structHash = keccak256(abi.encode(_INTERFACE, msg.sender, true, amount));
2027         bytes32 hash = _hashTypedDataV4(structHash);
2028 
2029         address signer = ECDSA.recover(hash, signature);
2030         require(hasRole(MINTER_ROLE, signer), "Invalid signature.");
2031         require(balanceOf(msg.sender) == 0, "Caller has already claimed.");
2032 
2033         // Mint the token.
2034         _tokenIds.increment();
2035         _safeMint(msg.sender, _tokenIds.current());
2036 
2037         // Transfer the tokens. (If it's before the deadline).
2038         if (block.timestamp < _deadline) {
2039             _token.transfer(msg.sender, amount);
2040         }
2041 
2042     }
2043 
2044     function claimRemainingTokens() external onlyTreasury {
2045 
2046         require(block.timestamp > _deadline);
2047 
2048         uint256 balance = _token.balanceOf(address(this));
2049         _token.transfer(_treasury, balance);
2050 
2051     }
2052 
2053     function burn(uint256 tokenId) external onlyRole(BURNER_ROLE) {
2054 
2055         require(block.timestamp > _deadline);
2056         _burn(tokenId);
2057 
2058     }
2059 
2060     function setDeadline(uint256 deadline) external onlyTreasury {
2061 
2062         require(block.timestamp < _deadline);
2063         _deadline = deadline;
2064 
2065     }
2066 
2067     function setTreasury(address treasury) external onlyTreasury {
2068 
2069         _treasury = treasury;
2070 
2071     }
2072 
2073     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2074 
2075         require(_exists(tokenId), "Token hasn't been minted yet.");
2076         return _tokenURI;
2077 
2078     }
2079 
2080     function setTokenURI(string memory newTokenURI) external onlyTreasury {
2081 
2082         _tokenURI = newTokenURI;
2083 
2084     }
2085 
2086     modifier onlyTreasury {
2087 
2088         require(msg.sender == _treasury, "Caller must be the treasury.");
2089         _;
2090 
2091     }
2092 
2093     // Overrides for transfer related functions.
2094 
2095     function approve(address, uint256) public virtual override {
2096 
2097         revert("Token is not transferrable.");
2098 
2099     }
2100 
2101     function setApprovalForAll(address, bool) public virtual override {
2102 
2103         revert("Token is not transferrable.");
2104 
2105     }
2106 
2107     function transferFrom(address, address, uint256) public virtual override {
2108 
2109         revert("Token is not transferrable.");
2110 
2111     }
2112 
2113     function safeTransferFrom(address, address, uint256) public virtual override {
2114 
2115         revert("Token is not transferrable.");
2116 
2117     }
2118 
2119     function safeTransferFrom(address, address, uint256, bytes memory) public virtual override {
2120 
2121         revert("Token is not transferrable.");
2122 
2123     }
2124 
2125     // Overrides for Solidity.
2126 
2127     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
2128 
2129         return super._beforeTokenTransfer(from, to, tokenId);
2130 
2131     }
2132 
2133     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControl, ERC721, ERC721Enumerable) returns (bool) {
2134 
2135         return super.supportsInterface(interfaceId);
2136 
2137     }
2138 
2139 }