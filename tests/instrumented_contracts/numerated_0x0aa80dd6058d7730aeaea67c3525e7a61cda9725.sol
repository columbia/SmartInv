1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
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
32 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Implementation of the {IERC165} interface.
39  *
40  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
41  * for the additional interface id that will be supported. For example:
42  *
43  * ```solidity
44  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
45  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
46  * }
47  * ```
48  *
49  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
50  */
51 abstract contract ERC165 is IERC165 {
52     /**
53      * @dev See {IERC165-supportsInterface}.
54      */
55     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
56         return interfaceId == type(IERC165).interfaceId;
57     }
58 }
59 
60 // File: @openzeppelin/contracts/utils/Strings.sol
61 
62 
63 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
64 
65 pragma solidity ^0.8.0;
66 
67 /**
68  * @dev String operations.
69  */
70 library Strings {
71     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
72 
73     /**
74      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
75      */
76     function toString(uint256 value) internal pure returns (string memory) {
77         // Inspired by OraclizeAPI's implementation - MIT licence
78         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
79 
80         if (value == 0) {
81             return "0";
82         }
83         uint256 temp = value;
84         uint256 digits;
85         while (temp != 0) {
86             digits++;
87             temp /= 10;
88         }
89         bytes memory buffer = new bytes(digits);
90         while (value != 0) {
91             digits -= 1;
92             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
93             value /= 10;
94         }
95         return string(buffer);
96     }
97 
98     /**
99      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
100      */
101     function toHexString(uint256 value) internal pure returns (string memory) {
102         if (value == 0) {
103             return "0x00";
104         }
105         uint256 temp = value;
106         uint256 length = 0;
107         while (temp != 0) {
108             length++;
109             temp >>= 8;
110         }
111         return toHexString(value, length);
112     }
113 
114     /**
115      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
116      */
117     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
118         bytes memory buffer = new bytes(2 * length + 2);
119         buffer[0] = "0";
120         buffer[1] = "x";
121         for (uint256 i = 2 * length + 1; i > 1; --i) {
122             buffer[i] = _HEX_SYMBOLS[value & 0xf];
123             value >>= 4;
124         }
125         require(value == 0, "Strings: hex length insufficient");
126         return string(buffer);
127     }
128 }
129 
130 // File: @openzeppelin/contracts/access/IAccessControl.sol
131 
132 
133 // OpenZeppelin Contracts v4.4.1 (access/IAccessControl.sol)
134 
135 pragma solidity ^0.8.0;
136 
137 /**
138  * @dev External interface of AccessControl declared to support ERC165 detection.
139  */
140 interface IAccessControl {
141     /**
142      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
143      *
144      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
145      * {RoleAdminChanged} not being emitted signaling this.
146      *
147      * _Available since v3.1._
148      */
149     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
150 
151     /**
152      * @dev Emitted when `account` is granted `role`.
153      *
154      * `sender` is the account that originated the contract call, an admin role
155      * bearer except when using {AccessControl-_setupRole}.
156      */
157     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
158 
159     /**
160      * @dev Emitted when `account` is revoked `role`.
161      *
162      * `sender` is the account that originated the contract call:
163      *   - if using `revokeRole`, it is the admin role bearer
164      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
165      */
166     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
167 
168     /**
169      * @dev Returns `true` if `account` has been granted `role`.
170      */
171     function hasRole(bytes32 role, address account) external view returns (bool);
172 
173     /**
174      * @dev Returns the admin role that controls `role`. See {grantRole} and
175      * {revokeRole}.
176      *
177      * To change a role's admin, use {AccessControl-_setRoleAdmin}.
178      */
179     function getRoleAdmin(bytes32 role) external view returns (bytes32);
180 
181     /**
182      * @dev Grants `role` to `account`.
183      *
184      * If `account` had not been already granted `role`, emits a {RoleGranted}
185      * event.
186      *
187      * Requirements:
188      *
189      * - the caller must have ``role``'s admin role.
190      */
191     function grantRole(bytes32 role, address account) external;
192 
193     /**
194      * @dev Revokes `role` from `account`.
195      *
196      * If `account` had been granted `role`, emits a {RoleRevoked} event.
197      *
198      * Requirements:
199      *
200      * - the caller must have ``role``'s admin role.
201      */
202     function revokeRole(bytes32 role, address account) external;
203 
204     /**
205      * @dev Revokes `role` from the calling account.
206      *
207      * Roles are often managed via {grantRole} and {revokeRole}: this function's
208      * purpose is to provide a mechanism for accounts to lose their privileges
209      * if they are compromised (such as when a trusted device is misplaced).
210      *
211      * If the calling account had been granted `role`, emits a {RoleRevoked}
212      * event.
213      *
214      * Requirements:
215      *
216      * - the caller must be `account`.
217      */
218     function renounceRole(bytes32 role, address account) external;
219 }
220 
221 // File: @openzeppelin/contracts/utils/Context.sol
222 
223 
224 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
225 
226 pragma solidity ^0.8.0;
227 
228 /**
229  * @dev Provides information about the current execution context, including the
230  * sender of the transaction and its data. While these are generally available
231  * via msg.sender and msg.data, they should not be accessed in such a direct
232  * manner, since when dealing with meta-transactions the account sending and
233  * paying for execution may not be the actual sender (as far as an application
234  * is concerned).
235  *
236  * This contract is only required for intermediate, library-like contracts.
237  */
238 abstract contract Context {
239     function _msgSender() internal view virtual returns (address) {
240         return msg.sender;
241     }
242 
243     function _msgData() internal view virtual returns (bytes calldata) {
244         return msg.data;
245     }
246 }
247 
248 // File: @openzeppelin/contracts/access/AccessControl.sol
249 
250 
251 // OpenZeppelin Contracts v4.4.1 (access/AccessControl.sol)
252 
253 pragma solidity ^0.8.0;
254 
255 
256 
257 
258 
259 /**
260  * @dev Contract module that allows children to implement role-based access
261  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
262  * members except through off-chain means by accessing the contract event logs. Some
263  * applications may benefit from on-chain enumerability, for those cases see
264  * {AccessControlEnumerable}.
265  *
266  * Roles are referred to by their `bytes32` identifier. These should be exposed
267  * in the external API and be unique. The best way to achieve this is by
268  * using `public constant` hash digests:
269  *
270  * ```
271  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
272  * ```
273  *
274  * Roles can be used to represent a set of permissions. To restrict access to a
275  * function call, use {hasRole}:
276  *
277  * ```
278  * function foo() public {
279  *     require(hasRole(MY_ROLE, msg.sender));
280  *     ...
281  * }
282  * ```
283  *
284  * Roles can be granted and revoked dynamically via the {grantRole} and
285  * {revokeRole} functions. Each role has an associated admin role, and only
286  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
287  *
288  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
289  * that only accounts with this role will be able to grant or revoke other
290  * roles. More complex role relationships can be created by using
291  * {_setRoleAdmin}.
292  *
293  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
294  * grant and revoke this role. Extra precautions should be taken to secure
295  * accounts that have been granted it.
296  */
297 abstract contract AccessControl is Context, IAccessControl, ERC165 {
298     struct RoleData {
299         mapping(address => bool) members;
300         bytes32 adminRole;
301     }
302 
303     mapping(bytes32 => RoleData) private _roles;
304 
305     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
306 
307     /**
308      * @dev Modifier that checks that an account has a specific role. Reverts
309      * with a standardized message including the required role.
310      *
311      * The format of the revert reason is given by the following regular expression:
312      *
313      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
314      *
315      * _Available since v4.1._
316      */
317     modifier onlyRole(bytes32 role) {
318         _checkRole(role, _msgSender());
319         _;
320     }
321 
322     /**
323      * @dev See {IERC165-supportsInterface}.
324      */
325     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
326         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
327     }
328 
329     /**
330      * @dev Returns `true` if `account` has been granted `role`.
331      */
332     function hasRole(bytes32 role, address account) public view override returns (bool) {
333         return _roles[role].members[account];
334     }
335 
336     /**
337      * @dev Revert with a standard message if `account` is missing `role`.
338      *
339      * The format of the revert reason is given by the following regular expression:
340      *
341      *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
342      */
343     function _checkRole(bytes32 role, address account) internal view {
344         if (!hasRole(role, account)) {
345             revert(
346                 string(
347                     abi.encodePacked(
348                         "AccessControl: account ",
349                         Strings.toHexString(uint160(account), 20),
350                         " is missing role ",
351                         Strings.toHexString(uint256(role), 32)
352                     )
353                 )
354             );
355         }
356     }
357 
358     /**
359      * @dev Returns the admin role that controls `role`. See {grantRole} and
360      * {revokeRole}.
361      *
362      * To change a role's admin, use {_setRoleAdmin}.
363      */
364     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
365         return _roles[role].adminRole;
366     }
367 
368     /**
369      * @dev Grants `role` to `account`.
370      *
371      * If `account` had not been already granted `role`, emits a {RoleGranted}
372      * event.
373      *
374      * Requirements:
375      *
376      * - the caller must have ``role``'s admin role.
377      */
378     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
379         _grantRole(role, account);
380     }
381 
382     /**
383      * @dev Revokes `role` from `account`.
384      *
385      * If `account` had been granted `role`, emits a {RoleRevoked} event.
386      *
387      * Requirements:
388      *
389      * - the caller must have ``role``'s admin role.
390      */
391     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
392         _revokeRole(role, account);
393     }
394 
395     /**
396      * @dev Revokes `role` from the calling account.
397      *
398      * Roles are often managed via {grantRole} and {revokeRole}: this function's
399      * purpose is to provide a mechanism for accounts to lose their privileges
400      * if they are compromised (such as when a trusted device is misplaced).
401      *
402      * If the calling account had been revoked `role`, emits a {RoleRevoked}
403      * event.
404      *
405      * Requirements:
406      *
407      * - the caller must be `account`.
408      */
409     function renounceRole(bytes32 role, address account) public virtual override {
410         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
411 
412         _revokeRole(role, account);
413     }
414 
415     /**
416      * @dev Grants `role` to `account`.
417      *
418      * If `account` had not been already granted `role`, emits a {RoleGranted}
419      * event. Note that unlike {grantRole}, this function doesn't perform any
420      * checks on the calling account.
421      *
422      * [WARNING]
423      * ====
424      * This function should only be called from the constructor when setting
425      * up the initial roles for the system.
426      *
427      * Using this function in any other way is effectively circumventing the admin
428      * system imposed by {AccessControl}.
429      * ====
430      *
431      * NOTE: This function is deprecated in favor of {_grantRole}.
432      */
433     function _setupRole(bytes32 role, address account) internal virtual {
434         _grantRole(role, account);
435     }
436 
437     /**
438      * @dev Sets `adminRole` as ``role``'s admin role.
439      *
440      * Emits a {RoleAdminChanged} event.
441      */
442     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
443         bytes32 previousAdminRole = getRoleAdmin(role);
444         _roles[role].adminRole = adminRole;
445         emit RoleAdminChanged(role, previousAdminRole, adminRole);
446     }
447 
448     /**
449      * @dev Grants `role` to `account`.
450      *
451      * Internal function without access restriction.
452      */
453     function _grantRole(bytes32 role, address account) internal virtual {
454         if (!hasRole(role, account)) {
455             _roles[role].members[account] = true;
456             emit RoleGranted(role, account, _msgSender());
457         }
458     }
459 
460     /**
461      * @dev Revokes `role` from `account`.
462      *
463      * Internal function without access restriction.
464      */
465     function _revokeRole(bytes32 role, address account) internal virtual {
466         if (hasRole(role, account)) {
467             _roles[role].members[account] = false;
468             emit RoleRevoked(role, account, _msgSender());
469         }
470     }
471 }
472 
473 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
474 
475 
476 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
477 
478 pragma solidity ^0.8.0;
479 
480 /**
481  * @dev Interface of the ERC20 standard as defined in the EIP.
482  */
483 interface IERC20 {
484     /**
485      * @dev Returns the amount of tokens in existence.
486      */
487     function totalSupply() external view returns (uint256);
488 
489     /**
490      * @dev Returns the amount of tokens owned by `account`.
491      */
492     function balanceOf(address account) external view returns (uint256);
493 
494     /**
495      * @dev Moves `amount` tokens from the caller's account to `recipient`.
496      *
497      * Returns a boolean value indicating whether the operation succeeded.
498      *
499      * Emits a {Transfer} event.
500      */
501     function transfer(address recipient, uint256 amount) external returns (bool);
502 
503     /**
504      * @dev Returns the remaining number of tokens that `spender` will be
505      * allowed to spend on behalf of `owner` through {transferFrom}. This is
506      * zero by default.
507      *
508      * This value changes when {approve} or {transferFrom} are called.
509      */
510     function allowance(address owner, address spender) external view returns (uint256);
511 
512     /**
513      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
514      *
515      * Returns a boolean value indicating whether the operation succeeded.
516      *
517      * IMPORTANT: Beware that changing an allowance with this method brings the risk
518      * that someone may use both the old and the new allowance by unfortunate
519      * transaction ordering. One possible solution to mitigate this race
520      * condition is to first reduce the spender's allowance to 0 and set the
521      * desired value afterwards:
522      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
523      *
524      * Emits an {Approval} event.
525      */
526     function approve(address spender, uint256 amount) external returns (bool);
527 
528     /**
529      * @dev Moves `amount` tokens from `sender` to `recipient` using the
530      * allowance mechanism. `amount` is then deducted from the caller's
531      * allowance.
532      *
533      * Returns a boolean value indicating whether the operation succeeded.
534      *
535      * Emits a {Transfer} event.
536      */
537     function transferFrom(
538         address sender,
539         address recipient,
540         uint256 amount
541     ) external returns (bool);
542 
543     /**
544      * @dev Emitted when `value` tokens are moved from one account (`from`) to
545      * another (`to`).
546      *
547      * Note that `value` may be zero.
548      */
549     event Transfer(address indexed from, address indexed to, uint256 value);
550 
551     /**
552      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
553      * a call to {approve}. `value` is the new allowance.
554      */
555     event Approval(address indexed owner, address indexed spender, uint256 value);
556 }
557 
558 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
559 
560 
561 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
562 
563 pragma solidity ^0.8.0;
564 
565 
566 /**
567  * @dev Interface for the optional metadata functions from the ERC20 standard.
568  *
569  * _Available since v4.1._
570  */
571 interface IERC20Metadata is IERC20 {
572     /**
573      * @dev Returns the name of the token.
574      */
575     function name() external view returns (string memory);
576 
577     /**
578      * @dev Returns the symbol of the token.
579      */
580     function symbol() external view returns (string memory);
581 
582     /**
583      * @dev Returns the decimals places of the token.
584      */
585     function decimals() external view returns (uint8);
586 }
587 
588 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
589 
590 
591 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
592 
593 pragma solidity ^0.8.0;
594 
595 
596 
597 
598 /**
599  * @dev Implementation of the {IERC20} interface.
600  *
601  * This implementation is agnostic to the way tokens are created. This means
602  * that a supply mechanism has to be added in a derived contract using {_mint}.
603  * For a generic mechanism see {ERC20PresetMinterPauser}.
604  *
605  * TIP: For a detailed writeup see our guide
606  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
607  * to implement supply mechanisms].
608  *
609  * We have followed general OpenZeppelin Contracts guidelines: functions revert
610  * instead returning `false` on failure. This behavior is nonetheless
611  * conventional and does not conflict with the expectations of ERC20
612  * applications.
613  *
614  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
615  * This allows applications to reconstruct the allowance for all accounts just
616  * by listening to said events. Other implementations of the EIP may not emit
617  * these events, as it isn't required by the specification.
618  *
619  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
620  * functions have been added to mitigate the well-known issues around setting
621  * allowances. See {IERC20-approve}.
622  */
623 contract ERC20 is Context, IERC20, IERC20Metadata {
624     mapping(address => uint256) private _balances;
625 
626     mapping(address => mapping(address => uint256)) private _allowances;
627 
628     uint256 private _totalSupply;
629 
630     string private _name;
631     string private _symbol;
632 
633     /**
634      * @dev Sets the values for {name} and {symbol}.
635      *
636      * The default value of {decimals} is 18. To select a different value for
637      * {decimals} you should overload it.
638      *
639      * All two of these values are immutable: they can only be set once during
640      * construction.
641      */
642     constructor(string memory name_, string memory symbol_) {
643         _name = name_;
644         _symbol = symbol_;
645     }
646 
647     /**
648      * @dev Returns the name of the token.
649      */
650     function name() public view virtual override returns (string memory) {
651         return _name;
652     }
653 
654     /**
655      * @dev Returns the symbol of the token, usually a shorter version of the
656      * name.
657      */
658     function symbol() public view virtual override returns (string memory) {
659         return _symbol;
660     }
661 
662     /**
663      * @dev Returns the number of decimals used to get its user representation.
664      * For example, if `decimals` equals `2`, a balance of `505` tokens should
665      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
666      *
667      * Tokens usually opt for a value of 18, imitating the relationship between
668      * Ether and Wei. This is the value {ERC20} uses, unless this function is
669      * overridden;
670      *
671      * NOTE: This information is only used for _display_ purposes: it in
672      * no way affects any of the arithmetic of the contract, including
673      * {IERC20-balanceOf} and {IERC20-transfer}.
674      */
675     function decimals() public view virtual override returns (uint8) {
676         return 18;
677     }
678 
679     /**
680      * @dev See {IERC20-totalSupply}.
681      */
682     function totalSupply() public view virtual override returns (uint256) {
683         return _totalSupply;
684     }
685 
686     /**
687      * @dev See {IERC20-balanceOf}.
688      */
689     function balanceOf(address account) public view virtual override returns (uint256) {
690         return _balances[account];
691     }
692 
693     /**
694      * @dev See {IERC20-transfer}.
695      *
696      * Requirements:
697      *
698      * - `recipient` cannot be the zero address.
699      * - the caller must have a balance of at least `amount`.
700      */
701     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
702         _transfer(_msgSender(), recipient, amount);
703         return true;
704     }
705 
706     /**
707      * @dev See {IERC20-allowance}.
708      */
709     function allowance(address owner, address spender) public view virtual override returns (uint256) {
710         return _allowances[owner][spender];
711     }
712 
713     /**
714      * @dev See {IERC20-approve}.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      */
720     function approve(address spender, uint256 amount) public virtual override returns (bool) {
721         _approve(_msgSender(), spender, amount);
722         return true;
723     }
724 
725     /**
726      * @dev See {IERC20-transferFrom}.
727      *
728      * Emits an {Approval} event indicating the updated allowance. This is not
729      * required by the EIP. See the note at the beginning of {ERC20}.
730      *
731      * Requirements:
732      *
733      * - `sender` and `recipient` cannot be the zero address.
734      * - `sender` must have a balance of at least `amount`.
735      * - the caller must have allowance for ``sender``'s tokens of at least
736      * `amount`.
737      */
738     function transferFrom(
739         address sender,
740         address recipient,
741         uint256 amount
742     ) public virtual override returns (bool) {
743         _transfer(sender, recipient, amount);
744 
745         uint256 currentAllowance = _allowances[sender][_msgSender()];
746         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
747         unchecked {
748             _approve(sender, _msgSender(), currentAllowance - amount);
749         }
750 
751         return true;
752     }
753 
754     /**
755      * @dev Atomically increases the allowance granted to `spender` by the caller.
756      *
757      * This is an alternative to {approve} that can be used as a mitigation for
758      * problems described in {IERC20-approve}.
759      *
760      * Emits an {Approval} event indicating the updated allowance.
761      *
762      * Requirements:
763      *
764      * - `spender` cannot be the zero address.
765      */
766     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
767         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
768         return true;
769     }
770 
771     /**
772      * @dev Atomically decreases the allowance granted to `spender` by the caller.
773      *
774      * This is an alternative to {approve} that can be used as a mitigation for
775      * problems described in {IERC20-approve}.
776      *
777      * Emits an {Approval} event indicating the updated allowance.
778      *
779      * Requirements:
780      *
781      * - `spender` cannot be the zero address.
782      * - `spender` must have allowance for the caller of at least
783      * `subtractedValue`.
784      */
785     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
786         uint256 currentAllowance = _allowances[_msgSender()][spender];
787         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
788         unchecked {
789             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
790         }
791 
792         return true;
793     }
794 
795     /**
796      * @dev Moves `amount` of tokens from `sender` to `recipient`.
797      *
798      * This internal function is equivalent to {transfer}, and can be used to
799      * e.g. implement automatic token fees, slashing mechanisms, etc.
800      *
801      * Emits a {Transfer} event.
802      *
803      * Requirements:
804      *
805      * - `sender` cannot be the zero address.
806      * - `recipient` cannot be the zero address.
807      * - `sender` must have a balance of at least `amount`.
808      */
809     function _transfer(
810         address sender,
811         address recipient,
812         uint256 amount
813     ) internal virtual {
814         require(sender != address(0), "ERC20: transfer from the zero address");
815         require(recipient != address(0), "ERC20: transfer to the zero address");
816 
817         _beforeTokenTransfer(sender, recipient, amount);
818 
819         uint256 senderBalance = _balances[sender];
820         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
821         unchecked {
822             _balances[sender] = senderBalance - amount;
823         }
824         _balances[recipient] += amount;
825 
826         emit Transfer(sender, recipient, amount);
827 
828         _afterTokenTransfer(sender, recipient, amount);
829     }
830 
831     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
832      * the total supply.
833      *
834      * Emits a {Transfer} event with `from` set to the zero address.
835      *
836      * Requirements:
837      *
838      * - `account` cannot be the zero address.
839      */
840     function _mint(address account, uint256 amount) internal virtual {
841         require(account != address(0), "ERC20: mint to the zero address");
842 
843         _beforeTokenTransfer(address(0), account, amount);
844 
845         _totalSupply += amount;
846         _balances[account] += amount;
847         emit Transfer(address(0), account, amount);
848 
849         _afterTokenTransfer(address(0), account, amount);
850     }
851 
852     /**
853      * @dev Destroys `amount` tokens from `account`, reducing the
854      * total supply.
855      *
856      * Emits a {Transfer} event with `to` set to the zero address.
857      *
858      * Requirements:
859      *
860      * - `account` cannot be the zero address.
861      * - `account` must have at least `amount` tokens.
862      */
863     function _burn(address account, uint256 amount) internal virtual {
864         require(account != address(0), "ERC20: burn from the zero address");
865 
866         _beforeTokenTransfer(account, address(0), amount);
867 
868         uint256 accountBalance = _balances[account];
869         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
870         unchecked {
871             _balances[account] = accountBalance - amount;
872         }
873         _totalSupply -= amount;
874 
875         emit Transfer(account, address(0), amount);
876 
877         _afterTokenTransfer(account, address(0), amount);
878     }
879 
880     /**
881      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
882      *
883      * This internal function is equivalent to `approve`, and can be used to
884      * e.g. set automatic allowances for certain subsystems, etc.
885      *
886      * Emits an {Approval} event.
887      *
888      * Requirements:
889      *
890      * - `owner` cannot be the zero address.
891      * - `spender` cannot be the zero address.
892      */
893     function _approve(
894         address owner,
895         address spender,
896         uint256 amount
897     ) internal virtual {
898         require(owner != address(0), "ERC20: approve from the zero address");
899         require(spender != address(0), "ERC20: approve to the zero address");
900 
901         _allowances[owner][spender] = amount;
902         emit Approval(owner, spender, amount);
903     }
904 
905     /**
906      * @dev Hook that is called before any transfer of tokens. This includes
907      * minting and burning.
908      *
909      * Calling conditions:
910      *
911      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
912      * will be transferred to `to`.
913      * - when `from` is zero, `amount` tokens will be minted for `to`.
914      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
915      * - `from` and `to` are never both zero.
916      *
917      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
918      */
919     function _beforeTokenTransfer(
920         address from,
921         address to,
922         uint256 amount
923     ) internal virtual {}
924 
925     /**
926      * @dev Hook that is called after any transfer of tokens. This includes
927      * minting and burning.
928      *
929      * Calling conditions:
930      *
931      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
932      * has been transferred to `to`.
933      * - when `from` is zero, `amount` tokens have been minted for `to`.
934      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
935      * - `from` and `to` are never both zero.
936      *
937      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
938      */
939     function _afterTokenTransfer(
940         address from,
941         address to,
942         uint256 amount
943     ) internal virtual {}
944 }
945 
946 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
947 
948 
949 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Burnable.sol)
950 
951 pragma solidity ^0.8.0;
952 
953 
954 
955 /**
956  * @dev Extension of {ERC20} that allows token holders to destroy both their own
957  * tokens and those that they have an allowance for, in a way that can be
958  * recognized off-chain (via event analysis).
959  */
960 abstract contract ERC20Burnable is Context, ERC20 {
961     /**
962      * @dev Destroys `amount` tokens from the caller.
963      *
964      * See {ERC20-_burn}.
965      */
966     function burn(uint256 amount) public virtual {
967         _burn(_msgSender(), amount);
968     }
969 
970     /**
971      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
972      * allowance.
973      *
974      * See {ERC20-_burn} and {ERC20-allowance}.
975      *
976      * Requirements:
977      *
978      * - the caller must have allowance for ``accounts``'s tokens of at least
979      * `amount`.
980      */
981     function burnFrom(address account, uint256 amount) public virtual {
982         uint256 currentAllowance = allowance(account, _msgSender());
983         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
984         unchecked {
985             _approve(account, _msgSender(), currentAllowance - amount);
986         }
987         _burn(account, amount);
988     }
989 }
990 
991 // File: contracts/DinoEggs.sol
992 
993 
994 pragma solidity ^0.8.0;
995 
996 
997 
998 
999 contract DinoEggs is ERC20, ERC20Burnable, AccessControl {
1000   bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
1001 
1002   constructor() ERC20("DinoEggs", "$DinoEggs") {
1003     _mint(address(this), 3000000 ether);
1004     _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
1005   }
1006 
1007   function withdraw(address _address, uint256 _amount)
1008     external
1009     onlyRole(MANAGER_ROLE)
1010   {
1011     require(_amount <= balanceOf(address(this)), "Not enough eggs left");
1012 
1013     _transfer(address(this), _address, _amount);
1014   }
1015 }