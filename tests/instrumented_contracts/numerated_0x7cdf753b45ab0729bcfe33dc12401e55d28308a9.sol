1 // Sources flattened with hardhat v2.8.3 https://hardhat.org
2 
3 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.4.2
4 
5 // SPDX-License-Identifier: MIT
6 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
7 
8 pragma solidity ^0.8.0;
9 
10 /**
11  * @dev External interface of AccessControl declared to support ERC165 detection.
12  */
13 interface IAccessControl {
14     /**
15      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
16      *
17      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
18      * {RoleAdminChanged} not being emitted signaling this.
19      *
20      * _Available since v3.1._
21      */
22     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
23 
24     /**
25      * @dev Emitted when `account` is granted `role`.
26      *
27      * `sender` is the account that originated the contract call, an admin role
28      * bearer except when using {AccessControl-_setupRole}.
29      */
30     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
31 
32     /**
33      * @dev Emitted when `account` is revoked `role`.
34      *
35      * `sender` is the account that originated the contract call:
36      *   - if using `revokeRole`, it is the admin role bearer
37      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
38      */
39     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
40 
41     /**
42      * @dev Returns `true` if `account` has been granted `role`.
43      */
44     function hasRole(bytes32 role, address account) external view returns (bool);
45 
46     /**
47      * @dev Returns the admin role that controls `role`. See {grantRole} and
48      * {revokeRole}.
49      *
50      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
51      */
52     function getRoleAdmin(bytes32 role) external view returns (bytes32);
53 
54     /**
55      * @dev Grants `role` to `account`.
56      *
57      * If `account` had not been already granted `role`, emits a {RoleGranted}
58      * event.
59      *
60      * Requirements:
61      *
62      * - the caller must have ``role``'s admin role.
63      */
64     function grantRole(bytes32 role, address account) external;
65 
66     /**
67      * @dev Revokes `role` from `account`.
68      *
69      * If `account` had been granted `role`, emits a {RoleRevoked} event.
70      *
71      * Requirements:
72      *
73      * - the caller must have ``role``'s admin role.
74      */
75     function revokeRole(bytes32 role, address account) external;
76 
77     /**
78      * @dev Revokes `role` from the calling account.
79      *
80      * Roles are often managed via {grantRole} and {revokeRole}: this function's
81      * purpose is to provide a mechanism for accounts to lose their privileges
82      * if they are compromised (such as when a trusted device is misplaced).
83      *
84      * If the calling account had been granted `role`, emits a {RoleRevoked}
85      * event.
86      *
87      * Requirements:
88      *
89      * - the caller must be `account`.
90      */
91     function renounceRole(bytes32 role, address account) external;
92 }
93 
94 
95 // File @openzeppelin/contracts/utils/Context.sol@v4.4.2
96 
97 
98 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
99 
100 pragma solidity ^0.8.0;
101 
102 /**
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 abstract contract Context {
113     function _msgSender() internal view virtual returns (address) {
114         return msg.sender;
115     }
116 
117     function _msgData() internal view virtual returns (bytes calldata) {
118         return msg.data;
119     }
120 }
121 
122 
123 // File @openzeppelin/contracts/utils/Strings.sol@v4.4.2
124 
125 
126 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
127 
128 pragma solidity ^0.8.0;
129 
130 /**
131  * @dev String operations.
132  */
133 library Strings {
134     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
135 
136     /**
137      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
138      */
139     function toString(uint256 value) internal pure returns (string memory) {
140         // Inspired by OraclizeAPI's implementation - MIT licence
141         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
142 
143         if (value == 0) {
144             return "0";
145         }
146         uint256 temp = value;
147         uint256 digits;
148         while (temp != 0) {
149             digits++;
150             temp /= 10;
151         }
152         bytes memory buffer = new bytes(digits);
153         while (value != 0) {
154             digits -= 1;
155             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
156             value /= 10;
157         }
158         return string(buffer);
159     }
160 
161     /**
162      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
163      */
164     function toHexString(uint256 value) internal pure returns (string memory) {
165         if (value == 0) {
166             return "0x00";
167         }
168         uint256 temp = value;
169         uint256 length = 0;
170         while (temp != 0) {
171             length++;
172             temp >>= 8;
173         }
174         return toHexString(value, length);
175     }
176 
177     /**
178      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
179      */
180     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
181         bytes memory buffer = new bytes(2 * length + 2);
182         buffer[0] = "0";
183         buffer[1] = "x";
184         for (uint256 i = 2 * length + 1; i > 1; --i) {
185             buffer[i] = _HEX_SYMBOLS[value & 0xf];
186             value >>= 4;
187         }
188         require(value == 0, "Strings: hex length insufficient");
189         return string(buffer);
190     }
191 }
192 
193 
194 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.4.2
195 
196 
197 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
198 
199 pragma solidity ^0.8.0;
200 
201 /**
202  * @dev Interface of the ERC165 standard, as defined in the
203  * https://eips.ethereum.org/EIPS/eip-165[EIP].
204  *
205  * Implementers can declare support of contract interfaces, which can then be
206  * queried by others ({ERC165Checker}).
207  *
208  * For an implementation, see {ERC165}.
209  */
210 interface IERC165 {
211     /**
212      * @dev Returns true if this contract implements the interface defined by
213      * `interfaceId`. See the corresponding
214      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
215      * to learn more about how these ids are created.
216      *
217      * This function call must use less than 30 000 gas.
218      */
219     function supportsInterface(bytes4 interfaceId) external view returns (bool);
220 }
221 
222 
223 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.4.2
224 
225 
226 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
227 
228 pragma solidity ^0.8.0;
229 
230 /**
231  * @dev Implementation of the {IERC165} interface.
232  *
233  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
234  * for the additional interface id that will be supported. For example:
235  *
236  * ```solidity
237  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
238  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
239  * }
240  * ```
241  *
242  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
243  */
244 abstract contract ERC165 is IERC165 {
245     /**
246      * @dev See {IERC165-supportsInterface}.
247      */
248     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
249         return interfaceId == type(IERC165).interfaceId;
250     }
251 }
252 
253 
254 // File @openzeppelin/contracts/access/AccessControl.sol@v4.4.2
255 
256 
257 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
258 
259 pragma solidity ^0.8.0;
260 
261 
262 
263 
264 /**
265  * @dev Contract module that allows children to implement role-based access
266  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
267  * members except through off-chain means by accessing the contract event logs. Some
268  * applications may benefit from on-chain enumerability, for those cases see
269  * {AccessControlEnumerable}.
270  *
271  * Roles are referred to by their `bytes32` identifier. These should be exposed
272  * in the external API and be unique. The best way to achieve this is by
273  * using `public constant` hash digests:
274  *
275  * ```
276  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
277  * ```
278  *
279  * Roles can be used to represent a set of permissions. To restrict access to a
280  * function call, use {hasRole}:
281  *
282  * ```
283  * function foo() public {
284  *     require(hasRole(MY_ROLE, msg.sender));
285  *     ...
286  * }
287  * ```
288  *
289  * Roles can be granted and revoked dynamically via the {grantRole} and
290  * {revokeRole} functions. Each role has an associated admin role, and only
291  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
292  *
293  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
294  * that only accounts with this role will be able to grant or revoke other
295  * roles. More complex role relationships can be created by using
296  * {_setRoleAdmin}.
297  *
298  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
299  * grant and revoke this role. Extra precautions should be taken to secure
300  * accounts that have been granted it.
301  */
302 abstract contract AccessControl is Context, IAccessControl, ERC165 {
303     struct RoleData {
304         mapping(address => bool) members;
305         bytes32 adminRole;
306     }
307 
308     mapping(bytes32 => RoleData) private _roles;
309 
310     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
311 
312     /**
313      * @dev Modifier that checks that an account has a specific role. Reverts
314      * with a standardized message including the required role.
315      *
316      * The format of the revert reason is given by the following regular expression:
317      *
318      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
319      *
320      * _Available since v4.1._
321      */
322     modifier onlyRole(bytes32 role) {
323         _checkRole(role, _msgSender());
324         _;
325     }
326 
327     /**
328      * @dev See {IERC165-supportsInterface}.
329      */
330     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
331         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
332     }
333 
334     /**
335      * @dev Returns `true` if `account` has been granted `role`.
336      */
337     function hasRole(bytes32 role, address account) public view override returns (bool) {
338         return _roles[role].members[account];
339     }
340 
341     /**
342      * @dev Revert with a standard message if `account` is missing `role`.
343      *
344      * The format of the revert reason is given by the following regular expression:
345      *
346      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
347      */
348     function _checkRole(bytes32 role, address account) internal view {
349         if (!hasRole(role, account)) {
350             revert(
351                 string(
352                     abi.encodePacked(
353                         "AccessControl: account ",
354                         Strings.toHexString(uint160(account), 20),
355                         " is missing role ",
356                         Strings.toHexString(uint256(role), 32)
357                     )
358                 )
359             );
360         }
361     }
362 
363     /**
364      * @dev Returns the admin role that controls `role`. See {grantRole} and
365      * {revokeRole}.
366      *
367      * To change a role's admin, use {_setRoleAdmin}.
368      */
369     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
370         return _roles[role].adminRole;
371     }
372 
373     /**
374      * @dev Grants `role` to `account`.
375      *
376      * If `account` had not been already granted `role`, emits a {RoleGranted}
377      * event.
378      *
379      * Requirements:
380      *
381      * - the caller must have ``role``'s admin role.
382      */
383     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
384         _grantRole(role, account);
385     }
386 
387     /**
388      * @dev Revokes `role` from `account`.
389      *
390      * If `account` had been granted `role`, emits a {RoleRevoked} event.
391      *
392      * Requirements:
393      *
394      * - the caller must have ``role``'s admin role.
395      */
396     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
397         _revokeRole(role, account);
398     }
399 
400     /**
401      * @dev Revokes `role` from the calling account.
402      *
403      * Roles are often managed via {grantRole} and {revokeRole}: this function's
404      * purpose is to provide a mechanism for accounts to lose their privileges
405      * if they are compromised (such as when a trusted device is misplaced).
406      *
407      * If the calling account had been revoked `role`, emits a {RoleRevoked}
408      * event.
409      *
410      * Requirements:
411      *
412      * - the caller must be `account`.
413      */
414     function renounceRole(bytes32 role, address account) public virtual override {
415         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
416 
417         _revokeRole(role, account);
418     }
419 
420     /**
421      * @dev Grants `role` to `account`.
422      *
423      * If `account` had not been already granted `role`, emits a {RoleGranted}
424      * event. Note that unlike {grantRole}, this function doesn't perform any
425      * checks on the calling account.
426      *
427      * [WARNING]
428      * ====
429      * This function should only be called from the constructor when setting
430      * up the initial roles for the system.
431      *
432      * Using this function in any other way is effectively circumventing the admin
433      * system imposed by {AccessControl}.
434      * ====
435      *
436      * NOTE: This function is deprecated in favor of {_grantRole}.
437      */
438     function _setupRole(bytes32 role, address account) internal virtual {
439         _grantRole(role, account);
440     }
441 
442     /**
443      * @dev Sets `adminRole` as ``role``'s admin role.
444      *
445      * Emits a {RoleAdminChanged} event.
446      */
447     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
448         bytes32 previousAdminRole = getRoleAdmin(role);
449         _roles[role].adminRole = adminRole;
450         emit RoleAdminChanged(role, previousAdminRole, adminRole);
451     }
452 
453     /**
454      * @dev Grants `role` to `account`.
455      *
456      * Internal function without access restriction.
457      */
458     function _grantRole(bytes32 role, address account) internal virtual {
459         if (!hasRole(role, account)) {
460             _roles[role].members[account] = true;
461             emit RoleGranted(role, account, _msgSender());
462         }
463     }
464 
465     /**
466      * @dev Revokes `role` from `account`.
467      *
468      * Internal function without access restriction.
469      */
470     function _revokeRole(bytes32 role, address account) internal virtual {
471         if (hasRole(role, account)) {
472             _roles[role].members[account] = false;
473             emit RoleRevoked(role, account, _msgSender());
474         }
475     }
476 }
477 
478 
479 // File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.4.2
480 
481 
482 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
483 
484 pragma solidity ^0.8.0;
485 
486 /**
487  * @dev Contract module that helps prevent reentrant calls to a function.
488  *
489  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
490  * available, which can be applied to functions to make sure there are no nested
491  * (reentrant) calls to them.
492  *
493  * Note that because there is a single `nonReentrant` guard, functions marked as
494  * `nonReentrant` may not call one another. This can be worked around by making
495  * those functions `private`, and then adding `external` `nonReentrant` entry
496  * points to them.
497  *
498  * TIP: If you would like to learn more about reentrancy and alternative ways
499  * to protect against it, check out our blog post
500  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
501  */
502 abstract contract ReentrancyGuard {
503     // Booleans are more expensive than uint256 or any type that takes up a full
504     // word because each write operation emits an extra SLOAD to first read the
505     // slot's contents, replace the bits taken up by the boolean, and then write
506     // back. This is the compiler's defense against contract upgrades and
507     // pointer aliasing, and it cannot be disabled.
508 
509     // The values being non-zero value makes deployment a bit more expensive,
510     // but in exchange the refund on every call to nonReentrant will be lower in
511     // amount. Since refunds are capped to a percentage of the total
512     // transaction's gas, it is best to keep them low in cases like this one, to
513     // increase the likelihood of the full refund coming into effect.
514     uint256 private constant _NOT_ENTERED = 1;
515     uint256 private constant _ENTERED = 2;
516 
517     uint256 private _status;
518 
519     constructor() {
520         _status = _NOT_ENTERED;
521     }
522 
523     /**
524      * @dev Prevents a contract from calling itself, directly or indirectly.
525      * Calling a `nonReentrant` function from another `nonReentrant`
526      * function is not supported. It is possible to prevent this from happening
527      * by making the `nonReentrant` function external, and making it call a
528      * `private` function that does the actual work.
529      */
530     modifier nonReentrant() {
531         // On the first call to nonReentrant, _notEntered will be true
532         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
533 
534         // Any calls to nonReentrant after this point will fail
535         _status = _ENTERED;
536 
537         _;
538 
539         // By storing the original value once again, a refund is triggered (see
540         // https://eips.ethereum.org/EIPS/eip-2200)
541         _status = _NOT_ENTERED;
542     }
543 }
544 
545 
546 // File contracts/interfaces/IBribeVault.sol
547 
548 
549 pragma solidity 0.8.12;
550 
551 interface IBribeVault {
552     function depositBribeERC20(
553         bytes32 bribeIdentifier,
554         bytes32 rewardIdentifier,
555         address token,
556         uint256 amount,
557         address briber
558     ) external;
559 
560     function getBribe(bytes32 bribeIdentifier)
561         external
562         view
563         returns (address token, uint256 amount);
564 
565     function depositBribe(
566         bytes32 bribeIdentifier,
567         bytes32 rewardIdentifier,
568         address briber
569     ) external payable;
570 }
571 
572 
573 // File contracts/BribeBase.sol
574 
575 
576 pragma solidity 0.8.12;
577 
578 
579 
580 contract BribeBase is AccessControl, ReentrancyGuard {
581     address public immutable BRIBE_VAULT;
582     bytes32 public constant TEAM_ROLE = keccak256("TEAM_ROLE");
583 
584     // Used for generating the bribe and reward identifiers
585     bytes32 public immutable PROTOCOL;
586 
587     // Arbitrary bytes mapped to deadlines
588     mapping(bytes32 => uint256) public proposalDeadlines;
589 
590     // Voter addresses mapped to addresses which will claim rewards on their behalf
591     mapping(address => address) public rewardForwarding;
592 
593     // Tracks whitelisted tokens
594     mapping(address => uint256) public indexOfWhitelistedToken;
595     address[] public allWhitelistedTokens;
596 
597     event GrantTeamRole(address teamMember);
598     event RevokeTeamRole(address teamMember);
599     event SetProposal(bytes32 indexed proposal, uint256 deadline);
600     event DepositBribe(
601         bytes32 indexed proposal,
602         address indexed token,
603         uint256 amount,
604         bytes32 bribeIdentifier,
605         bytes32 rewardIdentifier,
606         address indexed briber
607     );
608     event SetRewardForwarding(address from, address to);
609     event AddWhitelistTokens(address[] tokens);
610     event RemoveWhitelistTokens(address[] tokens);
611 
612     constructor(address _BRIBE_VAULT, string memory _PROTOCOL) {
613         require(_BRIBE_VAULT != address(0), "Invalid _BRIBE_VAULT");
614         BRIBE_VAULT = _BRIBE_VAULT;
615 
616         require(bytes(_PROTOCOL).length != 0, "Invalid _PROTOCOL");
617         PROTOCOL = keccak256(abi.encodePacked(_PROTOCOL));
618 
619         _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
620     }
621 
622     modifier onlyAuthorized() {
623         require(
624             hasRole(DEFAULT_ADMIN_ROLE, msg.sender) ||
625                 hasRole(TEAM_ROLE, msg.sender),
626             "Not authorized"
627         );
628         _;
629     }
630 
631     /**
632         @notice Grant the team role to an address
633         @param  teamMember  address  Address to grant the teamMember role
634      */
635     function grantTeamRole(address teamMember)
636         external
637         onlyRole(DEFAULT_ADMIN_ROLE)
638     {
639         require(teamMember != address(0), "Invalid teamMember");
640         _grantRole(TEAM_ROLE, teamMember);
641 
642         emit GrantTeamRole(teamMember);
643     }
644 
645     /**
646         @notice Revoke the team role from an address
647         @param  teamMember  address  Address to revoke the teamMember role
648      */
649     function revokeTeamRole(address teamMember)
650         external
651         onlyRole(DEFAULT_ADMIN_ROLE)
652     {
653         require(hasRole(TEAM_ROLE, teamMember), "Invalid teamMember");
654         _revokeRole(TEAM_ROLE, teamMember);
655 
656         emit RevokeTeamRole(teamMember);
657     }
658 
659     /**
660         @notice Return the list of currently whitelisted token addresses
661      */
662     function getWhitelistedTokens() external view returns (address[] memory) {
663         return allWhitelistedTokens;
664     }
665 
666     /**
667         @notice Return whether the specified token is whitelisted
668         @param  token  address Token address to be checked
669      */
670     function isWhitelistedToken(address token) public view returns (bool) {
671         if (allWhitelistedTokens.length == 0) {
672             return false;
673         }
674 
675         return
676             indexOfWhitelistedToken[token] != 0 ||
677             allWhitelistedTokens[0] == token;
678     }
679 
680     /**
681         @notice Add whitelist tokens
682         @param  tokens  address[]  Tokens to add to whitelist
683      */
684     function addWhitelistTokens(address[] calldata tokens)
685         external
686         onlyAuthorized
687     {
688         for (uint256 i; i < tokens.length; ++i) {
689             require(tokens[i] != address(0), "Invalid token");
690             require(tokens[i] != BRIBE_VAULT, "Cannot whitelist BRIBE_VAULT");
691             require(
692                 !isWhitelistedToken(tokens[i]),
693                 "Token already whitelisted"
694             );
695 
696             // Perform creation op for the unordered key set
697             allWhitelistedTokens.push(tokens[i]);
698             indexOfWhitelistedToken[tokens[i]] =
699                 allWhitelistedTokens.length -
700                 1;
701         }
702 
703         emit AddWhitelistTokens(tokens);
704     }
705 
706     /**
707         @notice Remove whitelist tokens
708         @param  tokens  address[]  Tokens to remove from whitelist
709      */
710     function removeWhitelistTokens(address[] calldata tokens)
711         external
712         onlyAuthorized
713     {
714         for (uint256 i; i < tokens.length; ++i) {
715             require(isWhitelistedToken(tokens[i]), "Token not whitelisted");
716 
717             // Perform deletion op for the unordered key set
718             // by swapping the affected row to the end/tail of the list
719             uint256 index = indexOfWhitelistedToken[tokens[i]];
720             address tail = allWhitelistedTokens[
721                 allWhitelistedTokens.length - 1
722             ];
723 
724             allWhitelistedTokens[index] = tail;
725             indexOfWhitelistedToken[tail] = index;
726 
727             delete indexOfWhitelistedToken[tokens[i]];
728             allWhitelistedTokens.pop();
729         }
730 
731         emit RemoveWhitelistTokens(tokens);
732     }
733 
734     /**
735         @notice Set a single proposal
736         @param  proposal  bytes32  Proposal
737         @param  deadline  uint256  Proposal deadline
738      */
739     function _setProposal(bytes32 proposal, uint256 deadline) internal {
740         require(proposal != bytes32(0), "Invalid proposal");
741         require(deadline > block.timestamp, "Deadline must be in the future");
742 
743         proposalDeadlines[proposal] = deadline;
744 
745         emit SetProposal(proposal, deadline);
746     }
747 
748     /**
749         @notice Generate the BribeVault identifier based on a scheme
750         @param  proposal          bytes32  Proposal
751         @param  proposalDeadline  uint256  Proposal deadline
752         @param  token             address  Token
753         @return identifier        bytes32  BribeVault identifier
754      */
755     function generateBribeVaultIdentifier(
756         bytes32 proposal,
757         uint256 proposalDeadline,
758         address token
759     ) public view returns (bytes32 identifier) {
760         return
761             keccak256(
762                 abi.encodePacked(PROTOCOL, proposal, proposalDeadline, token)
763             );
764     }
765 
766     /**
767         @notice Generate the reward identifier based on a scheme
768         @param  proposalDeadline  uint256  Proposal deadline
769         @param  token             address  Token
770         @return identifier        bytes32  Reward identifier
771      */
772     function generateRewardIdentifier(uint256 proposalDeadline, address token)
773         public
774         view
775         returns (bytes32 identifier)
776     {
777         return keccak256(abi.encodePacked(PROTOCOL, proposalDeadline, token));
778     }
779 
780     /**
781         @notice Get bribe from BribeVault
782         @param  proposal          bytes32  Proposal
783         @param  proposalDeadline  uint256  Proposal deadline
784         @param  token             address  Token
785         @return bribeToken        address  Token address
786         @return bribeAmount       address  Token amount
787      */
788     function getBribe(
789         bytes32 proposal,
790         uint256 proposalDeadline,
791         address token
792     ) external view returns (address bribeToken, uint256 bribeAmount) {
793         return
794             IBribeVault(BRIBE_VAULT).getBribe(
795                 generateBribeVaultIdentifier(proposal, proposalDeadline, token)
796             );
797     }
798 
799     /**
800         @notice Deposit bribe for a proposal (ERC20 tokens only)
801         @param  proposal  bytes32  Proposal
802         @param  token     address  Token
803         @param  amount    uint256  Token amount
804      */
805     function depositBribeERC20(
806         bytes32 proposal,
807         address token,
808         uint256 amount
809     ) external nonReentrant {
810         uint256 proposalDeadline = proposalDeadlines[proposal];
811         require(
812             proposalDeadlines[proposal] > block.timestamp,
813             "Proposal deadline has passed"
814         );
815         require(token != address(0), "Invalid token");
816         require(isWhitelistedToken(token), "Token is not whitelisted");
817         require(amount != 0, "Bribe amount must be greater than 0");
818 
819         bytes32 bribeIdentifier = generateBribeVaultIdentifier(
820             proposal,
821             proposalDeadline,
822             token
823         );
824         bytes32 rewardIdentifier = generateRewardIdentifier(
825             proposalDeadline,
826             token
827         );
828 
829         IBribeVault(BRIBE_VAULT).depositBribeERC20(
830             bribeIdentifier,
831             rewardIdentifier,
832             token,
833             amount,
834             msg.sender
835         );
836 
837         emit DepositBribe(
838             proposal,
839             token,
840             amount,
841             bribeIdentifier,
842             rewardIdentifier,
843             msg.sender
844         );
845     }
846 
847     /**
848         @notice Deposit bribe for a proposal (native token only)
849         @param  proposal  bytes32  Proposal
850      */
851     function depositBribe(bytes32 proposal) external payable nonReentrant {
852         uint256 proposalDeadline = proposalDeadlines[proposal];
853         require(
854             proposalDeadlines[proposal] > block.timestamp,
855             "Proposal deadline has passed"
856         );
857         require(msg.value != 0, "Bribe amount must be greater than 0");
858 
859         bytes32 bribeIdentifier = generateBribeVaultIdentifier(
860             proposal,
861             proposalDeadline,
862             BRIBE_VAULT
863         );
864         bytes32 rewardIdentifier = generateRewardIdentifier(
865             proposalDeadline,
866             BRIBE_VAULT
867         );
868 
869         // NOTE: Native token bribes have BRIBE_VAULT set as the address
870         IBribeVault(BRIBE_VAULT).depositBribe{value: msg.value}(
871             bribeIdentifier,
872             rewardIdentifier,
873             msg.sender
874         );
875 
876         emit DepositBribe(
877             proposal,
878             BRIBE_VAULT,
879             msg.value,
880             bribeIdentifier,
881             rewardIdentifier,
882             msg.sender
883         );
884     }
885 
886     /**
887         @notice Voters can opt in or out of reward-forwarding
888         @notice Opt-in: A voter sets another address to forward rewards to
889         @notice Opt-out: A voter sets their own address or the zero address
890         @param  to  address  Account that rewards will be sent to
891      */
892     function setRewardForwarding(address to) external {
893         rewardForwarding[msg.sender] = to;
894 
895         emit SetRewardForwarding(msg.sender, to);
896     }
897 }
898 
899 
900 // File contracts/BalancerBribe.sol
901 
902 pragma solidity 0.8.12;
903 
904 contract BalancerBribe is BribeBase {
905     address[] public gauges;
906     mapping(address => uint256) public indexOfGauge;
907 
908     constructor(address _BRIBE_VAULT)
909         BribeBase(_BRIBE_VAULT, "BALANCER")
910     {}
911 
912     /**
913         @notice Set a single proposal for a liquidity gauge
914         @param  gauge     address  Gauge address
915         @param  deadline  uint256  Proposal deadline
916      */
917     function setGaugeProposal(address gauge, uint256 deadline)
918         public
919         onlyAuthorized
920     {
921         require(gauge != address(0), "Invalid gauge");
922 
923         // Add new gauge to list and track index
924         if (
925             gauges.length == 0 ||
926             (indexOfGauge[gauge] == 0 && gauges[0] != gauge)
927         ) {
928             gauges.push(gauge);
929             indexOfGauge[gauge] = gauges.length - 1;
930         }
931 
932         _setProposal(keccak256(abi.encodePacked(gauge)), deadline);
933     }
934 
935     /**
936         @notice Set multiple proposals for many gauges
937         @param  gauges_    address[]  Gauge addresses
938         @param  deadlines  uint256[]  Proposal deadlines
939      */
940     function setGaugeProposals(
941         address[] calldata gauges_,
942         uint256[] calldata deadlines
943     ) external onlyAuthorized {
944         uint256 gaugeLen = gauges_.length;
945         require(gaugeLen != 0, "Invalid gauges_");
946         require(gaugeLen == deadlines.length, "Arrays length mismatch");
947 
948         for (uint256 i; i < gaugeLen; ++i) {
949             setGaugeProposal(gauges_[i], deadlines[i]);
950         }
951     }
952 
953     /**
954         @notice Get list of gauges
955      */
956     function getGauges() external view returns (address[] memory) {
957         return gauges;
958     }
959 }