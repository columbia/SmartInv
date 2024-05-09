1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 pragma solidity ^0.8.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes calldata) {
22         return msg.data;
23     }
24 }
25 
26 // File: @openzeppelin/contracts/utils/Strings.sol
27 
28 
29 pragma solidity ^0.8.0;
30 
31 /**
32  * @dev String operations.
33  */
34 library Strings {
35     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
36 
37     /**
38      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
39      */
40     function toString(uint256 value) internal pure returns (string memory) {
41         // Inspired by OraclizeAPI's implementation - MIT licence
42         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
43 
44         if (value == 0) {
45             return "0";
46         }
47         uint256 temp = value;
48         uint256 digits;
49         while (temp != 0) {
50             digits++;
51             temp /= 10;
52         }
53         bytes memory buffer = new bytes(digits);
54         while (value != 0) {
55             digits -= 1;
56             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
57             value /= 10;
58         }
59         return string(buffer);
60     }
61 
62     /**
63      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
64      */
65     function toHexString(uint256 value) internal pure returns (string memory) {
66         if (value == 0) {
67             return "0x00";
68         }
69         uint256 temp = value;
70         uint256 length = 0;
71         while (temp != 0) {
72             length++;
73             temp >>= 8;
74         }
75         return toHexString(value, length);
76     }
77 
78     /**
79      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
80      */
81     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
82         bytes memory buffer = new bytes(2 * length + 2);
83         buffer[0] = "0";
84         buffer[1] = "x";
85         for (uint256 i = 2 * length + 1; i > 1; --i) {
86             buffer[i] = _HEX_SYMBOLS[value & 0xf];
87             value >>= 4;
88         }
89         require(value == 0, "Strings: hex length insufficient");
90         return string(buffer);
91     }
92 }
93 
94 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
95 
96 
97 pragma solidity ^0.8.0;
98 
99 /**
100  * @dev Interface of the ERC165 standard, as defined in the
101  * https://eips.ethereum.org/EIPS/eip-165[EIP].
102  *
103  * Implementers can declare support of contract interfaces, which can then be
104  * queried by others ({ERC165Checker}).
105  *
106  * For an implementation, see {ERC165}.
107  */
108 interface IERC165 {
109     /**
110      * @dev Returns true if this contract implements the interface defined by
111      * `interfaceId`. See the corresponding
112      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
113      * to learn more about how these ids are created.
114      *
115      * This function call must use less than 30 000 gas.
116      */
117     function supportsInterface(bytes4 interfaceId) external view returns (bool);
118 }
119 
120 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
121 
122 
123 pragma solidity ^0.8.0;
124 
125 
126 /**
127  * @dev Implementation of the {IERC165} interface.
128  *
129  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
130  * for the additional interface id that will be supported. For example:
131  *
132  * ```solidity
133  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
134  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
135  * }
136  * ```
137  *
138  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
139  */
140 abstract contract ERC165 is IERC165 {
141     /**
142      * @dev See {IERC165-supportsInterface}.
143      */
144     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
145         return interfaceId == type(IERC165).interfaceId;
146     }
147 }
148 
149 // File: @openzeppelin/contracts/access/AccessControl.sol
150 
151 
152 pragma solidity ^0.8.0;
153 
154 
155 
156 
157 /**
158  * @dev External interface of AccessControl declared to support ERC165 detection.
159  */
160 interface IAccessControl {
161     function hasRole(bytes32 role, address account) external view returns (bool);
162 
163     function getRoleAdmin(bytes32 role) external view returns (bytes32);
164 
165     function grantRole(bytes32 role, address account) external;
166 
167     function revokeRole(bytes32 role, address account) external;
168 
169     function renounceRole(bytes32 role, address account) external;
170 }
171 
172 /**
173  * @dev Contract module that allows children to implement role-based access
174  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
175  * members except through off-chain means by accessing the contract event logs. Some
176  * applications may benefit from on-chain enumerability, for those cases see
177  * {AccessControlEnumerable}.
178  *
179  * Roles are referred to by their `bytes32` identifier. These should be exposed
180  * in the external API and be unique. The best way to achieve this is by
181  * using `public constant` hash digests:
182  *
183  * ```
184  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
185  * ```
186  *
187  * Roles can be used to represent a set of permissions. To restrict access to a
188  * function call, use {hasRole}:
189  *
190  * ```
191  * function foo() public {
192  *     require(hasRole(MY_ROLE, msg.sender));
193  *     ...
194  * }
195  * ```
196  *
197  * Roles can be granted and revoked dynamically via the {grantRole} and
198  * {revokeRole} functions. Each role has an associated admin role, and only
199  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
200  *
201  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
202  * that only accounts with this role will be able to grant or revoke other
203  * roles. More complex role relationships can be created by using
204  * {_setRoleAdmin}.
205  *
206  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
207  * grant and revoke this role. Extra precautions should be taken to secure
208  * accounts that have been granted it.
209  */
210 abstract contract AccessControl is Context, IAccessControl, ERC165 {
211     struct RoleData {
212         mapping(address => bool) members;
213         bytes32 adminRole;
214     }
215 
216     mapping(bytes32 => RoleData) private _roles;
217 
218     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
219 
220     /**
221      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
222      *
223      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
224      * {RoleAdminChanged} not being emitted signaling this.
225      *
226      * _Available since v3.1._
227      */
228     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
229 
230     /**
231      * @dev Emitted when `account` is granted `role`.
232      *
233      * `sender` is the account that originated the contract call, an admin role
234      * bearer except when using {_setupRole}.
235      */
236     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
237 
238     /**
239      * @dev Emitted when `account` is revoked `role`.
240      *
241      * `sender` is the account that originated the contract call:
242      *   - if using `revokeRole`, it is the admin role bearer
243      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
244      */
245     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
246 
247     /**
248      * @dev Modifier that checks that an account has a specific role. Reverts
249      * with a standardized message including the required role.
250      *
251      * The format of the revert reason is given by the following regular expression:
252      *
253      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
254      *
255      * _Available since v4.1._
256      */
257     modifier onlyRole(bytes32 role) {
258         _checkRole(role, _msgSender());
259         _;
260     }
261 
262     /**
263      * @dev See {IERC165-supportsInterface}.
264      */
265     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
266         return interfaceId == type(IAccessControl).interfaceId || super.supportsInterface(interfaceId);
267     }
268 
269     /**
270      * @dev Returns `true` if `account` has been granted `role`.
271      */
272     function hasRole(bytes32 role, address account) public view override returns (bool) {
273         return _roles[role].members[account];
274     }
275 
276     /**
277      * @dev Revert with a standard message if `account` is missing `role`.
278      *
279      * The format of the revert reason is given by the following regular expression:
280      *
281      *  /^AccessControl: account (0x[0-9a-f]{20}) is missing role (0x[0-9a-f]{32})$/
282      */
283     function _checkRole(bytes32 role, address account) internal view {
284         if (!hasRole(role, account)) {
285             revert(
286                 string(
287                     abi.encodePacked(
288                         "AccessControl: account ",
289                         Strings.toHexString(uint160(account), 20),
290                         " is missing role ",
291                         Strings.toHexString(uint256(role), 32)
292                     )
293                 )
294             );
295         }
296     }
297 
298     /**
299      * @dev Returns the admin role that controls `role`. See {grantRole} and
300      * {revokeRole}.
301      *
302      * To change a role's admin, use {_setRoleAdmin}.
303      */
304     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
305         return _roles[role].adminRole;
306     }
307 
308     /**
309      * @dev Grants `role` to `account`.
310      *
311      * If `account` had not been already granted `role`, emits a {RoleGranted}
312      * event.
313      *
314      * Requirements:
315      *
316      * - the caller must have ``role``'s admin role.
317      */
318     function grantRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
319         _grantRole(role, account);
320     }
321 
322     /**
323      * @dev Revokes `role` from `account`.
324      *
325      * If `account` had been granted `role`, emits a {RoleRevoked} event.
326      *
327      * Requirements:
328      *
329      * - the caller must have ``role``'s admin role.
330      */
331     function revokeRole(bytes32 role, address account) public virtual override onlyRole(getRoleAdmin(role)) {
332         _revokeRole(role, account);
333     }
334 
335     /**
336      * @dev Revokes `role` from the calling account.
337      *
338      * Roles are often managed via {grantRole} and {revokeRole}: this function's
339      * purpose is to provide a mechanism for accounts to lose their privileges
340      * if they are compromised (such as when a trusted device is misplaced).
341      *
342      * If the calling account had been granted `role`, emits a {RoleRevoked}
343      * event.
344      *
345      * Requirements:
346      *
347      * - the caller must be `account`.
348      */
349     function renounceRole(bytes32 role, address account) public virtual override {
350         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
351 
352         _revokeRole(role, account);
353     }
354 
355     /**
356      * @dev Grants `role` to `account`.
357      *
358      * If `account` had not been already granted `role`, emits a {RoleGranted}
359      * event. Note that unlike {grantRole}, this function doesn't perform any
360      * checks on the calling account.
361      *
362      * [WARNING]
363      * ====
364      * This function should only be called from the constructor when setting
365      * up the initial roles for the system.
366      *
367      * Using this function in any other way is effectively circumventing the admin
368      * system imposed by {AccessControl}.
369      * ====
370      */
371     function _setupRole(bytes32 role, address account) internal virtual {
372         _grantRole(role, account);
373     }
374 
375     /**
376      * @dev Sets `adminRole` as ``role``'s admin role.
377      *
378      * Emits a {RoleAdminChanged} event.
379      */
380     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
381         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
382         _roles[role].adminRole = adminRole;
383     }
384 
385     function _grantRole(bytes32 role, address account) private {
386         if (!hasRole(role, account)) {
387             _roles[role].members[account] = true;
388             emit RoleGranted(role, account, _msgSender());
389         }
390     }
391 
392     function _revokeRole(bytes32 role, address account) private {
393         if (hasRole(role, account)) {
394             _roles[role].members[account] = false;
395             emit RoleRevoked(role, account, _msgSender());
396         }
397     }
398 }
399 
400 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
401 
402 
403 pragma solidity ^0.8.0;
404 
405 /**
406  * @dev Interface of the ERC20 standard as defined in the EIP.
407  */
408 interface IERC20 {
409     /**
410      * @dev Returns the amount of tokens in existence.
411      */
412     function totalSupply() external view returns (uint256);
413 
414     /**
415      * @dev Returns the amount of tokens owned by `account`.
416      */
417     function balanceOf(address account) external view returns (uint256);
418 
419     /**
420      * @dev Moves `amount` tokens from the caller's account to `recipient`.
421      *
422      * Returns a boolean value indicating whether the operation succeeded.
423      *
424      * Emits a {Transfer} event.
425      */
426     function transfer(address recipient, uint256 amount) external returns (bool);
427 
428     /**
429      * @dev Returns the remaining number of tokens that `spender` will be
430      * allowed to spend on behalf of `owner` through {transferFrom}. This is
431      * zero by default.
432      *
433      * This value changes when {approve} or {transferFrom} are called.
434      */
435     function allowance(address owner, address spender) external view returns (uint256);
436 
437     /**
438      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
439      *
440      * Returns a boolean value indicating whether the operation succeeded.
441      *
442      * IMPORTANT: Beware that changing an allowance with this method brings the risk
443      * that someone may use both the old and the new allowance by unfortunate
444      * transaction ordering. One possible solution to mitigate this race
445      * condition is to first reduce the spender's allowance to 0 and set the
446      * desired value afterwards:
447      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
448      *
449      * Emits an {Approval} event.
450      */
451     function approve(address spender, uint256 amount) external returns (bool);
452 
453     /**
454      * @dev Moves `amount` tokens from `sender` to `recipient` using the
455      * allowance mechanism. `amount` is then deducted from the caller's
456      * allowance.
457      *
458      * Returns a boolean value indicating whether the operation succeeded.
459      *
460      * Emits a {Transfer} event.
461      */
462     function transferFrom(
463         address sender,
464         address recipient,
465         uint256 amount
466     ) external returns (bool);
467 
468     /**
469      * @dev Emitted when `value` tokens are moved from one account (`from`) to
470      * another (`to`).
471      *
472      * Note that `value` may be zero.
473      */
474     event Transfer(address indexed from, address indexed to, uint256 value);
475 
476     /**
477      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
478      * a call to {approve}. `value` is the new allowance.
479      */
480     event Approval(address indexed owner, address indexed spender, uint256 value);
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
484 
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Interface for the optional metadata functions from the ERC20 standard.
491  *
492  * _Available since v4.1._
493  */
494 interface IERC20Metadata is IERC20 {
495     /**
496      * @dev Returns the name of the token.
497      */
498     function name() external view returns (string memory);
499 
500     /**
501      * @dev Returns the symbol of the token.
502      */
503     function symbol() external view returns (string memory);
504 
505     /**
506      * @dev Returns the decimals places of the token.
507      */
508     function decimals() external view returns (uint8);
509 }
510 
511 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
512 
513 
514 pragma solidity ^0.8.0;
515 
516 
517 
518 
519 /**
520  * @dev Implementation of the {IERC20} interface.
521  *
522  * This implementation is agnostic to the way tokens are created. This means
523  * that a supply mechanism has to be added in a derived contract using {_mint}.
524  * For a generic mechanism see {ERC20PresetMinterPauser}.
525  *
526  * TIP: For a detailed writeup see our guide
527  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
528  * to implement supply mechanisms].
529  *
530  * We have followed general OpenZeppelin guidelines: functions revert instead
531  * of returning `false` on failure. This behavior is nonetheless conventional
532  * and does not conflict with the expectations of ERC20 applications.
533  *
534  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
535  * This allows applications to reconstruct the allowance for all accounts just
536  * by listening to said events. Other implementations of the EIP may not emit
537  * these events, as it isn't required by the specification.
538  *
539  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
540  * functions have been added to mitigate the well-known issues around setting
541  * allowances. See {IERC20-approve}.
542  */
543 contract ERC20 is Context, IERC20, IERC20Metadata {
544     mapping(address => uint256) private _balances;
545 
546     mapping(address => mapping(address => uint256)) private _allowances;
547 
548     uint256 private _totalSupply;
549 
550     string private _name;
551     string private _symbol;
552 
553     /**
554      * @dev Sets the values for {name} and {symbol}.
555      *
556      * The default value of {decimals} is 18. To select a different value for
557      * {decimals} you should overload it.
558      *
559      * All two of these values are immutable: they can only be set once during
560      * construction.
561      */
562     constructor(string memory name_, string memory symbol_) {
563         _name = name_;
564         _symbol = symbol_;
565     }
566 
567     /**
568      * @dev Returns the name of the token.
569      */
570     function name() public view virtual override returns (string memory) {
571         return _name;
572     }
573 
574     /**
575      * @dev Returns the symbol of the token, usually a shorter version of the
576      * name.
577      */
578     function symbol() public view virtual override returns (string memory) {
579         return _symbol;
580     }
581 
582     /**
583      * @dev Returns the number of decimals used to get its user representation.
584      * For example, if `decimals` equals `2`, a balance of `505` tokens should
585      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
586      *
587      * Tokens usually opt for a value of 18, imitating the relationship between
588      * Ether and Wei. This is the value {ERC20} uses, unless this function is
589      * overridden;
590      *
591      * NOTE: This information is only used for _display_ purposes: it in
592      * no way affects any of the arithmetic of the contract, including
593      * {IERC20-balanceOf} and {IERC20-transfer}.
594      */
595     function decimals() public view virtual override returns (uint8) {
596         return 18;
597     }
598 
599     /**
600      * @dev See {IERC20-totalSupply}.
601      */
602     function totalSupply() public view virtual override returns (uint256) {
603         return _totalSupply;
604     }
605 
606     /**
607      * @dev See {IERC20-balanceOf}.
608      */
609     function balanceOf(address account) public view virtual override returns (uint256) {
610         return _balances[account];
611     }
612 
613     /**
614      * @dev See {IERC20-transfer}.
615      *
616      * Requirements:
617      *
618      * - `recipient` cannot be the zero address.
619      * - the caller must have a balance of at least `amount`.
620      */
621     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
622         _transfer(_msgSender(), recipient, amount);
623         return true;
624     }
625 
626     /**
627      * @dev See {IERC20-allowance}.
628      */
629     function allowance(address owner, address spender) public view virtual override returns (uint256) {
630         return _allowances[owner][spender];
631     }
632 
633     /**
634      * @dev See {IERC20-approve}.
635      *
636      * Requirements:
637      *
638      * - `spender` cannot be the zero address.
639      */
640     function approve(address spender, uint256 amount) public virtual override returns (bool) {
641         _approve(_msgSender(), spender, amount);
642         return true;
643     }
644 
645     /**
646      * @dev See {IERC20-transferFrom}.
647      *
648      * Emits an {Approval} event indicating the updated allowance. This is not
649      * required by the EIP. See the note at the beginning of {ERC20}.
650      *
651      * Requirements:
652      *
653      * - `sender` and `recipient` cannot be the zero address.
654      * - `sender` must have a balance of at least `amount`.
655      * - the caller must have allowance for ``sender``'s tokens of at least
656      * `amount`.
657      */
658     function transferFrom(
659         address sender,
660         address recipient,
661         uint256 amount
662     ) public virtual override returns (bool) {
663         _transfer(sender, recipient, amount);
664 
665         uint256 currentAllowance = _allowances[sender][_msgSender()];
666         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
667         unchecked {
668             _approve(sender, _msgSender(), currentAllowance - amount);
669         }
670 
671         return true;
672     }
673 
674     /**
675      * @dev Atomically increases the allowance granted to `spender` by the caller.
676      *
677      * This is an alternative to {approve} that can be used as a mitigation for
678      * problems described in {IERC20-approve}.
679      *
680      * Emits an {Approval} event indicating the updated allowance.
681      *
682      * Requirements:
683      *
684      * - `spender` cannot be the zero address.
685      */
686     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
687         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
688         return true;
689     }
690 
691     /**
692      * @dev Atomically decreases the allowance granted to `spender` by the caller.
693      *
694      * This is an alternative to {approve} that can be used as a mitigation for
695      * problems described in {IERC20-approve}.
696      *
697      * Emits an {Approval} event indicating the updated allowance.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      * - `spender` must have allowance for the caller of at least
703      * `subtractedValue`.
704      */
705     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
706         uint256 currentAllowance = _allowances[_msgSender()][spender];
707         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
708         unchecked {
709             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
710         }
711 
712         return true;
713     }
714 
715     /**
716      * @dev Moves `amount` of tokens from `sender` to `recipient`.
717      *
718      * This internal function is equivalent to {transfer}, and can be used to
719      * e.g. implement automatic token fees, slashing mechanisms, etc.
720      *
721      * Emits a {Transfer} event.
722      *
723      * Requirements:
724      *
725      * - `sender` cannot be the zero address.
726      * - `recipient` cannot be the zero address.
727      * - `sender` must have a balance of at least `amount`.
728      */
729     function _transfer(
730         address sender,
731         address recipient,
732         uint256 amount
733     ) internal virtual {
734         require(sender != address(0), "ERC20: transfer from the zero address");
735         require(recipient != address(0), "ERC20: transfer to the zero address");
736 
737         _beforeTokenTransfer(sender, recipient, amount);
738 
739         uint256 senderBalance = _balances[sender];
740         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
741         unchecked {
742             _balances[sender] = senderBalance - amount;
743         }
744         _balances[recipient] += amount;
745 
746         emit Transfer(sender, recipient, amount);
747 
748         _afterTokenTransfer(sender, recipient, amount);
749     }
750 
751     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
752      * the total supply.
753      *
754      * Emits a {Transfer} event with `from` set to the zero address.
755      *
756      * Requirements:
757      *
758      * - `account` cannot be the zero address.
759      */
760     function _mint(address account, uint256 amount) internal virtual {
761         require(account != address(0), "ERC20: mint to the zero address");
762 
763         _beforeTokenTransfer(address(0), account, amount);
764 
765         _totalSupply += amount;
766         _balances[account] += amount;
767         emit Transfer(address(0), account, amount);
768 
769         _afterTokenTransfer(address(0), account, amount);
770     }
771 
772     /**
773      * @dev Destroys `amount` tokens from `account`, reducing the
774      * total supply.
775      *
776      * Emits a {Transfer} event with `to` set to the zero address.
777      *
778      * Requirements:
779      *
780      * - `account` cannot be the zero address.
781      * - `account` must have at least `amount` tokens.
782      */
783     function _burn(address account, uint256 amount) internal virtual {
784         require(account != address(0), "ERC20: burn from the zero address");
785 
786         _beforeTokenTransfer(account, address(0), amount);
787 
788         uint256 accountBalance = _balances[account];
789         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
790         unchecked {
791             _balances[account] = accountBalance - amount;
792         }
793         _totalSupply -= amount;
794 
795         emit Transfer(account, address(0), amount);
796 
797         _afterTokenTransfer(account, address(0), amount);
798     }
799 
800     /**
801      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
802      *
803      * This internal function is equivalent to `approve`, and can be used to
804      * e.g. set automatic allowances for certain subsystems, etc.
805      *
806      * Emits an {Approval} event.
807      *
808      * Requirements:
809      *
810      * - `owner` cannot be the zero address.
811      * - `spender` cannot be the zero address.
812      */
813     function _approve(
814         address owner,
815         address spender,
816         uint256 amount
817     ) internal virtual {
818         require(owner != address(0), "ERC20: approve from the zero address");
819         require(spender != address(0), "ERC20: approve to the zero address");
820 
821         _allowances[owner][spender] = amount;
822         emit Approval(owner, spender, amount);
823     }
824 
825     /**
826      * @dev Hook that is called before any transfer of tokens. This includes
827      * minting and burning.
828      *
829      * Calling conditions:
830      *
831      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
832      * will be transferred to `to`.
833      * - when `from` is zero, `amount` tokens will be minted for `to`.
834      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
835      * - `from` and `to` are never both zero.
836      *
837      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
838      */
839     function _beforeTokenTransfer(
840         address from,
841         address to,
842         uint256 amount
843     ) internal virtual {}
844 
845     /**
846      * @dev Hook that is called after any transfer of tokens. This includes
847      * minting and burning.
848      *
849      * Calling conditions:
850      *
851      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
852      * has been transferred to `to`.
853      * - when `from` is zero, `amount` tokens have been minted for `to`.
854      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
855      * - `from` and `to` are never both zero.
856      *
857      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
858      */
859     function _afterTokenTransfer(
860         address from,
861         address to,
862         uint256 amount
863     ) internal virtual {}
864 }
865 
866 // File: ZENRA.sol
867 // SPDX-License-Identifier: MIT
868 
869 pragma solidity ^0.8.3;
870 
871 
872 
873 contract ZENRA is ERC20, AccessControl {
874     bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
875 
876     /**
877      * @dev Constructor that gives msg.sender all of existing tokens.
878      */
879     constructor() ERC20("ZENRA", "ZENR") {
880         // Grant the contract deployer the default admin role: it will be able
881         // to grant and revoke any roles
882         _setupRole(BURNER_ROLE, msg.sender);
883         _mint(msg.sender, 500000000000 ether);
884     }
885 
886     function burn(uint256 amount) public onlyRole(BURNER_ROLE) {
887         _burn(msg.sender, amount);
888     }
889 }