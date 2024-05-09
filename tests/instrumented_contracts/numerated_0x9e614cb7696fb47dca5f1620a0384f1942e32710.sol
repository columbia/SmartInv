1 // SPDX-License-Identifier: UNLICENSED
2 // Sources flattened with hardhat v2.10.1 https://hardhat.org
3 
4 // File @openzeppelin/contracts/access/IAccessControl.sol@v4.7.0
5 
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
95 // File @openzeppelin/contracts/utils/Context.sol@v4.7.0
96 
97 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
98 
99 pragma solidity ^0.8.0;
100 
101 /**
102  * @dev Provides information about the current execution context, including the
103  * sender of the transaction and its data. While these are generally available
104  * via msg.sender and msg.data, they should not be accessed in such a direct
105  * manner, since when dealing with meta-transactions the account sending and
106  * paying for execution may not be the actual sender (as far as an application
107  * is concerned).
108  *
109  * This contract is only required for intermediate, library-like contracts.
110  */
111 abstract contract Context {
112     function _msgSender() internal view virtual returns (address) {
113         return msg.sender;
114     }
115 
116     function _msgData() internal view virtual returns (bytes calldata) {
117         return msg.data;
118     }
119 }
120 
121 
122 // File @openzeppelin/contracts/utils/Strings.sol@v4.7.0
123 
124 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
125 
126 pragma solidity ^0.8.0;
127 
128 /**
129  * @dev String operations.
130  */
131 library Strings {
132     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
133     uint8 private constant _ADDRESS_LENGTH = 20;
134 
135     /**
136      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
137      */
138     function toString(uint256 value) internal pure returns (string memory) {
139         // Inspired by OraclizeAPI's implementation - MIT licence
140         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
141 
142         if (value == 0) {
143             return "0";
144         }
145         uint256 temp = value;
146         uint256 digits;
147         while (temp != 0) {
148             digits++;
149             temp /= 10;
150         }
151         bytes memory buffer = new bytes(digits);
152         while (value != 0) {
153             digits -= 1;
154             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
155             value /= 10;
156         }
157         return string(buffer);
158     }
159 
160     /**
161      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
162      */
163     function toHexString(uint256 value) internal pure returns (string memory) {
164         if (value == 0) {
165             return "0x00";
166         }
167         uint256 temp = value;
168         uint256 length = 0;
169         while (temp != 0) {
170             length++;
171             temp >>= 8;
172         }
173         return toHexString(value, length);
174     }
175 
176     /**
177      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
178      */
179     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
180         bytes memory buffer = new bytes(2 * length + 2);
181         buffer[0] = "0";
182         buffer[1] = "x";
183         for (uint256 i = 2 * length + 1; i > 1; --i) {
184             buffer[i] = _HEX_SYMBOLS[value & 0xf];
185             value >>= 4;
186         }
187         require(value == 0, "Strings: hex length insufficient");
188         return string(buffer);
189     }
190 
191     /**
192      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
193      */
194     function toHexString(address addr) internal pure returns (string memory) {
195         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
196     }
197 }
198 
199 
200 // File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.0
201 
202 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
203 
204 pragma solidity ^0.8.0;
205 
206 /**
207  * @dev Interface of the ERC165 standard, as defined in the
208  * https://eips.ethereum.org/EIPS/eip-165[EIP].
209  *
210  * Implementers can declare support of contract interfaces, which can then be
211  * queried by others ({ERC165Checker}).
212  *
213  * For an implementation, see {ERC165}.
214  */
215 interface IERC165 {
216     /**
217      * @dev Returns true if this contract implements the interface defined by
218      * `interfaceId`. See the corresponding
219      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
220      * to learn more about how these ids are created.
221      *
222      * This function call must use less than 30 000 gas.
223      */
224     function supportsInterface(bytes4 interfaceId) external view returns (bool);
225 }
226 
227 
228 // File @openzeppelin/contracts/utils/introspection/ERC165.sol@v4.7.0
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
231 
232 pragma solidity ^0.8.0;
233 
234 /**
235  * @dev Implementation of the {IERC165} interface.
236  *
237  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
238  * for the additional interface id that will be supported. For example:
239  *
240  * ```solidity
241  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
242  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
243  * }
244  * ```
245  *
246  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
247  */
248 abstract contract ERC165 is IERC165 {
249     /**
250      * @dev See {IERC165-supportsInterface}.
251      */
252     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
253         return interfaceId == type(IERC165).interfaceId;
254     }
255 }
256 
257 
258 // File @openzeppelin/contracts/access/AccessControl.sol@v4.7.0
259 
260 // OpenZeppelin Contracts (last updated v4.7.0) (access/AccessControl.sol)
261 
262 pragma solidity ^0.8.0;
263 
264 
265 
266 
267 /**
268  * @dev Contract module that allows children to implement role-based access
269  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
270  * members except through off-chain means by accessing the contract event logs. Some
271  * applications may benefit from on-chain enumerability, for those cases see
272  * {AccessControlEnumerable}.
273  *
274  * Roles are referred to by their `bytes32` identifier. These should be exposed
275  * in the external API and be unique. The best way to achieve this is by
276  * using `public constant` hash digests:
277  *
278  * ```
279  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
280  * ```
281  *
282  * Roles can be used to represent a set of permissions. To restrict access to a
283  * function call, use {hasRole}:
284  *
285  * ```
286  * function foo() public {
287  *     require(hasRole(MY_ROLE, msg.sender));
288  *     ...
289  * }
290  * ```
291  *
292  * Roles can be granted and revoked dynamically via the {grantRole} and
293  * {revokeRole} functions. Each role has an associated admin role, and only
294  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
295  *
296  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
297  * that only accounts with this role will be able to grant or revoke other
298  * roles. More complex role relationships can be created by using
299  * {_setRoleAdmin}.
300  *
301  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
302  * grant and revoke this role. Extra precautions should be taken to secure
303  * accounts that have been granted it.
304  */
305 abstract contract AccessControl is Context, IAccessControl, ERC165 {
306     struct RoleData {
307         mapping(address => bool) members;
308         bytes32 adminRole;
309     }
310 
311     mapping(bytes32 => RoleData) private _roles;
312 
313     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
314 
315     /**
316      * @dev Modifier that checks that an account has a specific role. Reverts
317      * with a standardized message including the required role.
318      *
319      * The format of the revert reason is given by the following regular expression:
320      *
321      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
322      *
323      * _Available since v4.1._
324      */
325     modifier onlyRole(bytes32 role) {
326         _checkRole(role);
327         _;
328     }
329 
330     /**
331      * @dev See {IERC165-supportsInterface}.
332      */
333     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
334         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
335     }
336 
337     /**
338      * @dev Returns `true` if `account` has been granted `role`.
339      */
340     function hasRole(bytes32 role, address account) public view virtual override returns (bool) {
341         return _roles[role].members[account];
342     }
343 
344     /**
345      * @dev Revert with a standard message if `_msgSender()` is missing `role`.
346      * Overriding this function changes the behavior of the {onlyRole} modifier.
347      *
348      * Format of the revert message is described in {_checkRole}.
349      *
350      * _Available since v4.6._
351      */
352     function _checkRole(bytes32 role) internal view virtual {
353         _checkRole(role, _msgSender());
354     }
355 
356     /**
357      * @dev Revert with a standard message if `account` is missing `role`.
358      *
359      * The format of the revert reason is given by the following regular expression:
360      *
361      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
362      */
363     function _checkRole(bytes32 role, address account) internal view virtual {
364         if (!hasRole(role, account)) {
365             revert(
366                 string(
367                     abi.encodePacked(
368                         "AccessControl: account ",
369                         Strings.toHexString(uint160(account), 20),
370                         " is missing role ",
371                         Strings.toHexString(uint256(role), 32)
372                     )
373                 )
374             );
375         }
376     }
377 
378     /**
379      * @dev Returns the admin role that controls `role`. See {grantRole} and
380      * {revokeRole}.
381      *
382      * To change a role's admin, use {_setRoleAdmin}.
383      */
384     function getRoleAdmin(bytes32 role) public view virtual override returns (bytes32) {
385         return _roles[role].adminRole;
386     }
387 
388     /**
389      * @dev Grants `role` to `account`.
390      *
391      * If `account` had not been already granted `role`, emits a {RoleGranted}
392      * event.
393      *
394      * Requirements:
395      *
396      * - the caller must have ``role``'s admin role.
397      *
398      * May emit a {RoleGranted} event.
399      */
400     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
401         _grantRole(role, account);
402     }
403 
404     /**
405      * @dev Revokes `role` from `account`.
406      *
407      * If `account` had been granted `role`, emits a {RoleRevoked} event.
408      *
409      * Requirements:
410      *
411      * - the caller must have ``role``'s admin role.
412      *
413      * May emit a {RoleRevoked} event.
414      */
415     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
416         _revokeRole(role, account);
417     }
418 
419     /**
420      * @dev Revokes `role` from the calling account.
421      *
422      * Roles are often managed via {grantRole} and {revokeRole}: this function's
423      * purpose is to provide a mechanism for accounts to lose their privileges
424      * if they are compromised (such as when a trusted device is misplaced).
425      *
426      * If the calling account had been revoked `role`, emits a {RoleRevoked}
427      * event.
428      *
429      * Requirements:
430      *
431      * - the caller must be `account`.
432      *
433      * May emit a {RoleRevoked} event.
434      */
435     function renounceRole(bytes32 role, address account) public virtual override {
436         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
437 
438         _revokeRole(role, account);
439     }
440 
441     /**
442      * @dev Grants `role` to `account`.
443      *
444      * If `account` had not been already granted `role`, emits a {RoleGranted}
445      * event. Note that unlike {grantRole}, this function doesn't perform any
446      * checks on the calling account.
447      *
448      * May emit a {RoleGranted} event.
449      *
450      * [WARNING]
451      * ====
452      * This function should only be called from the constructor when setting
453      * up the initial roles for the system.
454      *
455      * Using this function in any other way is effectively circumventing the admin
456      * system imposed by {AccessControl}.
457      * ====
458      *
459      * NOTE: This function is deprecated in favor of {_grantRole}.
460      */
461     function _setupRole(bytes32 role, address account) internal virtual {
462         _grantRole(role, account);
463     }
464 
465     /**
466      * @dev Sets `adminRole` as ``role``'s admin role.
467      *
468      * Emits a {RoleAdminChanged} event.
469      */
470     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
471         bytes32 previousAdminRole = getRoleAdmin(role);
472         _roles[role].adminRole = adminRole;
473         emit RoleAdminChanged(role, previousAdminRole, adminRole);
474     }
475 
476     /**
477      * @dev Grants `role` to `account`.
478      *
479      * Internal function without access restriction.
480      *
481      * May emit a {RoleGranted} event.
482      */
483     function _grantRole(bytes32 role, address account) internal virtual {
484         if (!hasRole(role, account)) {
485             _roles[role].members[account] = true;
486             emit RoleGranted(role, account, _msgSender());
487         }
488     }
489 
490     /**
491      * @dev Revokes `role` from `account`.
492      *
493      * Internal function without access restriction.
494      *
495      * May emit a {RoleRevoked} event.
496      */
497     function _revokeRole(bytes32 role, address account) internal virtual {
498         if (hasRole(role, account)) {
499             _roles[role].members[account] = false;
500             emit RoleRevoked(role, account, _msgSender());
501         }
502     }
503 }
504 
505 
506 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.0
507 
508 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
509 
510 pragma solidity ^0.8.0;
511 
512 /**
513  * @dev Interface of the ERC20 standard as defined in the EIP.
514  */
515 interface IERC20 {
516     /**
517      * @dev Emitted when `value` tokens are moved from one account (`from`) to
518      * another (`to`).
519      *
520      * Note that `value` may be zero.
521      */
522     event Transfer(address indexed from, address indexed to, uint256 value);
523 
524     /**
525      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
526      * a call to {approve}. `value` is the new allowance.
527      */
528     event Approval(address indexed owner, address indexed spender, uint256 value);
529 
530     /**
531      * @dev Returns the amount of tokens in existence.
532      */
533     function totalSupply() external view returns (uint256);
534 
535     /**
536      * @dev Returns the amount of tokens owned by `account`.
537      */
538     function balanceOf(address account) external view returns (uint256);
539 
540     /**
541      * @dev Moves `amount` tokens from the caller's account to `to`.
542      *
543      * Returns a boolean value indicating whether the operation succeeded.
544      *
545      * Emits a {Transfer} event.
546      */
547     function transfer(address to, uint256 amount) external returns (bool);
548 
549     /**
550      * @dev Returns the remaining number of tokens that `spender` will be
551      * allowed to spend on behalf of `owner` through {transferFrom}. This is
552      * zero by default.
553      *
554      * This value changes when {approve} or {transferFrom} are called.
555      */
556     function allowance(address owner, address spender) external view returns (uint256);
557 
558     /**
559      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
560      *
561      * Returns a boolean value indicating whether the operation succeeded.
562      *
563      * IMPORTANT: Beware that changing an allowance with this method brings the risk
564      * that someone may use both the old and the new allowance by unfortunate
565      * transaction ordering. One possible solution to mitigate this race
566      * condition is to first reduce the spender's allowance to 0 and set the
567      * desired value afterwards:
568      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
569      *
570      * Emits an {Approval} event.
571      */
572     function approve(address spender, uint256 amount) external returns (bool);
573 
574     /**
575      * @dev Moves `amount` tokens from `from` to `to` using the
576      * allowance mechanism. `amount` is then deducted from the caller's
577      * allowance.
578      *
579      * Returns a boolean value indicating whether the operation succeeded.
580      *
581      * Emits a {Transfer} event.
582      */
583     function transferFrom(
584         address from,
585         address to,
586         uint256 amount
587     ) external returns (bool);
588 }
589 
590 
591 // File @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol@v4.7.0
592 
593 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
594 
595 pragma solidity ^0.8.0;
596 
597 /**
598  * @dev Interface for the optional metadata functions from the ERC20 standard.
599  *
600  * _Available since v4.1._
601  */
602 interface IERC20Metadata is IERC20 {
603     /**
604      * @dev Returns the name of the token.
605      */
606     function name() external view returns (string memory);
607 
608     /**
609      * @dev Returns the symbol of the token.
610      */
611     function symbol() external view returns (string memory);
612 
613     /**
614      * @dev Returns the decimals places of the token.
615      */
616     function decimals() external view returns (uint8);
617 }
618 
619 
620 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v4.7.0
621 
622 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
623 
624 pragma solidity ^0.8.0;
625 
626 
627 
628 /**
629  * @dev Implementation of the {IERC20} interface.
630  *
631  * This implementation is agnostic to the way tokens are created. This means
632  * that a supply mechanism has to be added in a derived contract using {_mint}.
633  * For a generic mechanism see {ERC20PresetMinterPauser}.
634  *
635  * TIP: For a detailed writeup see our guide
636  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
637  * to implement supply mechanisms].
638  *
639  * We have followed general OpenZeppelin Contracts guidelines: functions revert
640  * instead returning `false` on failure. This behavior is nonetheless
641  * conventional and does not conflict with the expectations of ERC20
642  * applications.
643  *
644  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
645  * This allows applications to reconstruct the allowance for all accounts just
646  * by listening to said events. Other implementations of the EIP may not emit
647  * these events, as it isn't required by the specification.
648  *
649  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
650  * functions have been added to mitigate the well-known issues around setting
651  * allowances. See {IERC20-approve}.
652  */
653 contract ERC20 is Context, IERC20, IERC20Metadata {
654     mapping(address => uint256) private _balances;
655 
656     mapping(address => mapping(address => uint256)) private _allowances;
657 
658     uint256 private _totalSupply;
659 
660     string private _name;
661     string private _symbol;
662 
663     /**
664      * @dev Sets the values for {name} and {symbol}.
665      *
666      * The default value of {decimals} is 18. To select a different value for
667      * {decimals} you should overload it.
668      *
669      * All two of these values are immutable: they can only be set once during
670      * construction.
671      */
672     constructor(string memory name_, string memory symbol_) {
673         _name = name_;
674         _symbol = symbol_;
675     }
676 
677     /**
678      * @dev Returns the name of the token.
679      */
680     function name() public view virtual override returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev Returns the symbol of the token, usually a shorter version of the
686      * name.
687      */
688     function symbol() public view virtual override returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev Returns the number of decimals used to get its user representation.
694      * For example, if `decimals` equals `2`, a balance of `505` tokens should
695      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
696      *
697      * Tokens usually opt for a value of 18, imitating the relationship between
698      * Ether and Wei. This is the value {ERC20} uses, unless this function is
699      * overridden;
700      *
701      * NOTE: This information is only used for _display_ purposes: it in
702      * no way affects any of the arithmetic of the contract, including
703      * {IERC20-balanceOf} and {IERC20-transfer}.
704      */
705     function decimals() public view virtual override returns (uint8) {
706         return 18;
707     }
708 
709     /**
710      * @dev See {IERC20-totalSupply}.
711      */
712     function totalSupply() public view virtual override returns (uint256) {
713         return _totalSupply;
714     }
715 
716     /**
717      * @dev See {IERC20-balanceOf}.
718      */
719     function balanceOf(address account) public view virtual override returns (uint256) {
720         return _balances[account];
721     }
722 
723     /**
724      * @dev See {IERC20-transfer}.
725      *
726      * Requirements:
727      *
728      * - `to` cannot be the zero address.
729      * - the caller must have a balance of at least `amount`.
730      */
731     function transfer(address to, uint256 amount) public virtual override returns (bool) {
732         address owner = _msgSender();
733         _transfer(owner, to, amount);
734         return true;
735     }
736 
737     /**
738      * @dev See {IERC20-allowance}.
739      */
740     function allowance(address owner, address spender) public view virtual override returns (uint256) {
741         return _allowances[owner][spender];
742     }
743 
744     /**
745      * @dev See {IERC20-approve}.
746      *
747      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
748      * `transferFrom`. This is semantically equivalent to an infinite approval.
749      *
750      * Requirements:
751      *
752      * - `spender` cannot be the zero address.
753      */
754     function approve(address spender, uint256 amount) public virtual override returns (bool) {
755         address owner = _msgSender();
756         _approve(owner, spender, amount);
757         return true;
758     }
759 
760     /**
761      * @dev See {IERC20-transferFrom}.
762      *
763      * Emits an {Approval} event indicating the updated allowance. This is not
764      * required by the EIP. See the note at the beginning of {ERC20}.
765      *
766      * NOTE: Does not update the allowance if the current allowance
767      * is the maximum `uint256`.
768      *
769      * Requirements:
770      *
771      * - `from` and `to` cannot be the zero address.
772      * - `from` must have a balance of at least `amount`.
773      * - the caller must have allowance for ``from``'s tokens of at least
774      * `amount`.
775      */
776     function transferFrom(
777         address from,
778         address to,
779         uint256 amount
780     ) public virtual override returns (bool) {
781         address spender = _msgSender();
782         _spendAllowance(from, spender, amount);
783         _transfer(from, to, amount);
784         return true;
785     }
786 
787     /**
788      * @dev Atomically increases the allowance granted to `spender` by the caller.
789      *
790      * This is an alternative to {approve} that can be used as a mitigation for
791      * problems described in {IERC20-approve}.
792      *
793      * Emits an {Approval} event indicating the updated allowance.
794      *
795      * Requirements:
796      *
797      * - `spender` cannot be the zero address.
798      */
799     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
800         address owner = _msgSender();
801         _approve(owner, spender, allowance(owner, spender) + addedValue);
802         return true;
803     }
804 
805     /**
806      * @dev Atomically decreases the allowance granted to `spender` by the caller.
807      *
808      * This is an alternative to {approve} that can be used as a mitigation for
809      * problems described in {IERC20-approve}.
810      *
811      * Emits an {Approval} event indicating the updated allowance.
812      *
813      * Requirements:
814      *
815      * - `spender` cannot be the zero address.
816      * - `spender` must have allowance for the caller of at least
817      * `subtractedValue`.
818      */
819     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
820         address owner = _msgSender();
821         uint256 currentAllowance = allowance(owner, spender);
822         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
823         unchecked {
824             _approve(owner, spender, currentAllowance - subtractedValue);
825         }
826 
827         return true;
828     }
829 
830     /**
831      * @dev Moves `amount` of tokens from `from` to `to`.
832      *
833      * This internal function is equivalent to {transfer}, and can be used to
834      * e.g. implement automatic token fees, slashing mechanisms, etc.
835      *
836      * Emits a {Transfer} event.
837      *
838      * Requirements:
839      *
840      * - `from` cannot be the zero address.
841      * - `to` cannot be the zero address.
842      * - `from` must have a balance of at least `amount`.
843      */
844     function _transfer(
845         address from,
846         address to,
847         uint256 amount
848     ) internal virtual {
849         require(from != address(0), "ERC20: transfer from the zero address");
850         require(to != address(0), "ERC20: transfer to the zero address");
851 
852         _beforeTokenTransfer(from, to, amount);
853 
854         uint256 fromBalance = _balances[from];
855         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
856         unchecked {
857             _balances[from] = fromBalance - amount;
858         }
859         _balances[to] += amount;
860 
861         emit Transfer(from, to, amount);
862 
863         _afterTokenTransfer(from, to, amount);
864     }
865 
866     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
867      * the total supply.
868      *
869      * Emits a {Transfer} event with `from` set to the zero address.
870      *
871      * Requirements:
872      *
873      * - `account` cannot be the zero address.
874      */
875     function _mint(address account, uint256 amount) internal virtual {
876         require(account != address(0), "ERC20: mint to the zero address");
877 
878         _beforeTokenTransfer(address(0), account, amount);
879 
880         _totalSupply += amount;
881         _balances[account] += amount;
882         emit Transfer(address(0), account, amount);
883 
884         _afterTokenTransfer(address(0), account, amount);
885     }
886 
887     /**
888      * @dev Destroys `amount` tokens from `account`, reducing the
889      * total supply.
890      *
891      * Emits a {Transfer} event with `to` set to the zero address.
892      *
893      * Requirements:
894      *
895      * - `account` cannot be the zero address.
896      * - `account` must have at least `amount` tokens.
897      */
898     function _burn(address account, uint256 amount) internal virtual {
899         require(account != address(0), "ERC20: burn from the zero address");
900 
901         _beforeTokenTransfer(account, address(0), amount);
902 
903         uint256 accountBalance = _balances[account];
904         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
905         unchecked {
906             _balances[account] = accountBalance - amount;
907         }
908         _totalSupply -= amount;
909 
910         emit Transfer(account, address(0), amount);
911 
912         _afterTokenTransfer(account, address(0), amount);
913     }
914 
915     /**
916      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
917      *
918      * This internal function is equivalent to `approve`, and can be used to
919      * e.g. set automatic allowances for certain subsystems, etc.
920      *
921      * Emits an {Approval} event.
922      *
923      * Requirements:
924      *
925      * - `owner` cannot be the zero address.
926      * - `spender` cannot be the zero address.
927      */
928     function _approve(
929         address owner,
930         address spender,
931         uint256 amount
932     ) internal virtual {
933         require(owner != address(0), "ERC20: approve from the zero address");
934         require(spender != address(0), "ERC20: approve to the zero address");
935 
936         _allowances[owner][spender] = amount;
937         emit Approval(owner, spender, amount);
938     }
939 
940     /**
941      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
942      *
943      * Does not update the allowance amount in case of infinite allowance.
944      * Revert if not enough allowance is available.
945      *
946      * Might emit an {Approval} event.
947      */
948     function _spendAllowance(
949         address owner,
950         address spender,
951         uint256 amount
952     ) internal virtual {
953         uint256 currentAllowance = allowance(owner, spender);
954         if (currentAllowance != type(uint256).max) {
955             require(currentAllowance >= amount, "ERC20: insufficient allowance");
956             unchecked {
957                 _approve(owner, spender, currentAllowance - amount);
958             }
959         }
960     }
961 
962     /**
963      * @dev Hook that is called before any transfer of tokens. This includes
964      * minting and burning.
965      *
966      * Calling conditions:
967      *
968      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
969      * will be transferred to `to`.
970      * - when `from` is zero, `amount` tokens will be minted for `to`.
971      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
972      * - `from` and `to` are never both zero.
973      *
974      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
975      */
976     function _beforeTokenTransfer(
977         address from,
978         address to,
979         uint256 amount
980     ) internal virtual {}
981 
982     /**
983      * @dev Hook that is called after any transfer of tokens. This includes
984      * minting and burning.
985      *
986      * Calling conditions:
987      *
988      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
989      * has been transferred to `to`.
990      * - when `from` is zero, `amount` tokens have been minted for `to`.
991      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
992      * - `from` and `to` are never both zero.
993      *
994      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
995      */
996     function _afterTokenTransfer(
997         address from,
998         address to,
999         uint256 amount
1000     ) internal virtual {}
1001 }
1002 
1003 
1004 // File @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol@v4.7.0
1005 
1006 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
1007 
1008 pragma solidity ^0.8.0;
1009 
1010 
1011 /**
1012  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1013  * tokens and those that they have an allowance for, in a way that can be
1014  * recognized off-chain (via event analysis).
1015  */
1016 abstract contract ERC20Burnable is Context, ERC20 {
1017     /**
1018      * @dev Destroys `amount` tokens from the caller.
1019      *
1020      * See {ERC20-_burn}.
1021      */
1022     function burn(uint256 amount) public virtual {
1023         _burn(_msgSender(), amount);
1024     }
1025 
1026     /**
1027      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
1028      * allowance.
1029      *
1030      * See {ERC20-_burn} and {ERC20-allowance}.
1031      *
1032      * Requirements:
1033      *
1034      * - the caller must have allowance for ``accounts``'s tokens of at least
1035      * `amount`.
1036      */
1037     function burnFrom(address account, uint256 amount) public virtual {
1038         _spendAllowance(account, _msgSender(), amount);
1039         _burn(account, amount);
1040     }
1041 }
1042 
1043 
1044 // File contracts/SaninFarmToken.sol
1045 
1046 pragma solidity ^0.8.0;
1047 
1048 
1049 contract SaninFarmToken is ERC20Burnable, AccessControl {
1050     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1051 
1052     constructor(
1053         string memory name,
1054         string memory symbol,
1055         address multiSign
1056     ) ERC20(name, symbol) {
1057         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1058         _setupRole(DEFAULT_ADMIN_ROLE, multiSign);
1059     }
1060 
1061     function mint(address to, uint256 amount) public {
1062         require(hasRole(MINTER_ROLE, _msgSender()), "Caller not a minter");
1063         _mint(to, amount);
1064     }
1065 }