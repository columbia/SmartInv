1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 
4 
5 pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @openzeppelin/contracts/utils/Context.sol
82 
83 
84 
85 pragma solidity ^0.8.0;
86 
87 /*
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
103         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
104         return msg.data;
105     }
106 }
107 
108 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
109 
110 
111 
112 pragma solidity ^0.8.0;
113 
114 
115 
116 /**
117  * @dev Implementation of the {IERC20} interface.
118  *
119  * This implementation is agnostic to the way tokens are created. This means
120  * that a supply mechanism has to be added in a derived contract using {_mint}.
121  * For a generic mechanism see {ERC20PresetMinterPauser}.
122  *
123  * TIP: For a detailed writeup see our guide
124  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
125  * to implement supply mechanisms].
126  *
127  * We have followed general OpenZeppelin guidelines: functions revert instead
128  * of returning `false` on failure. This behavior is nonetheless conventional
129  * and does not conflict with the expectations of ERC20 applications.
130  *
131  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
132  * This allows applications to reconstruct the allowance for all accounts just
133  * by listening to said events. Other implementations of the EIP may not emit
134  * these events, as it isn't required by the specification.
135  *
136  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
137  * functions have been added to mitigate the well-known issues around setting
138  * allowances. See {IERC20-approve}.
139  */
140 contract ERC20 is Context, IERC20 {
141     mapping (address => uint256) private _balances;
142 
143     mapping (address => mapping (address => uint256)) private _allowances;
144 
145     uint256 private _totalSupply;
146 
147     string private _name;
148     string private _symbol;
149 
150     /**
151      * @dev Sets the values for {name} and {symbol}.
152      *
153      * The defaut value of {decimals} is 18. To select a different value for
154      * {decimals} you should overload it.
155      *
156      * All three of these values are immutable: they can only be set once during
157      * construction.
158      */
159     constructor (string memory name_, string memory symbol_) {
160         _name = name_;
161         _symbol = symbol_;
162     }
163 
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() public view virtual returns (string memory) {
168         return _name;
169     }
170 
171     /**
172      * @dev Returns the symbol of the token, usually a shorter version of the
173      * name.
174      */
175     function symbol() public view virtual returns (string memory) {
176         return _symbol;
177     }
178 
179     /**
180      * @dev Returns the number of decimals used to get its user representation.
181      * For example, if `decimals` equals `2`, a balance of `505` tokens should
182      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
183      *
184      * Tokens usually opt for a value of 18, imitating the relationship between
185      * Ether and Wei. This is the value {ERC20} uses, unless this function is
186      * overloaded;
187      *
188      * NOTE: This information is only used for _display_ purposes: it in
189      * no way affects any of the arithmetic of the contract, including
190      * {IERC20-balanceOf} and {IERC20-transfer}.
191      */
192     function decimals() public view virtual returns (uint8) {
193         return 18;
194     }
195 
196     /**
197      * @dev See {IERC20-totalSupply}.
198      */
199     function totalSupply() public view virtual override returns (uint256) {
200         return _totalSupply;
201     }
202 
203     /**
204      * @dev See {IERC20-balanceOf}.
205      */
206     function balanceOf(address account) public view virtual override returns (uint256) {
207         return _balances[account];
208     }
209 
210     /**
211      * @dev See {IERC20-transfer}.
212      *
213      * Requirements:
214      *
215      * - `recipient` cannot be the zero address.
216      * - the caller must have a balance of at least `amount`.
217      */
218     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
219         _transfer(_msgSender(), recipient, amount);
220         return true;
221     }
222 
223     /**
224      * @dev See {IERC20-allowance}.
225      */
226     function allowance(address owner, address spender) public view virtual override returns (uint256) {
227         return _allowances[owner][spender];
228     }
229 
230     /**
231      * @dev See {IERC20-approve}.
232      *
233      * Requirements:
234      *
235      * - `spender` cannot be the zero address.
236      */
237     function approve(address spender, uint256 amount) public virtual override returns (bool) {
238         _approve(_msgSender(), spender, amount);
239         return true;
240     }
241 
242     /**
243      * @dev See {IERC20-transferFrom}.
244      *
245      * Emits an {Approval} event indicating the updated allowance. This is not
246      * required by the EIP. See the note at the beginning of {ERC20}.
247      *
248      * Requirements:
249      *
250      * - `sender` and `recipient` cannot be the zero address.
251      * - `sender` must have a balance of at least `amount`.
252      * - the caller must have allowance for ``sender``'s tokens of at least
253      * `amount`.
254      */
255     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(sender, recipient, amount);
257 
258         uint256 currentAllowance = _allowances[sender][_msgSender()];
259         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
260         _approve(sender, _msgSender(), currentAllowance - amount);
261 
262         return true;
263     }
264 
265     /**
266      * @dev Atomically increases the allowance granted to `spender` by the caller.
267      *
268      * This is an alternative to {approve} that can be used as a mitigation for
269      * problems described in {IERC20-approve}.
270      *
271      * Emits an {Approval} event indicating the updated allowance.
272      *
273      * Requirements:
274      *
275      * - `spender` cannot be the zero address.
276      */
277     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
278         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
279         return true;
280     }
281 
282     /**
283      * @dev Atomically decreases the allowance granted to `spender` by the caller.
284      *
285      * This is an alternative to {approve} that can be used as a mitigation for
286      * problems described in {IERC20-approve}.
287      *
288      * Emits an {Approval} event indicating the updated allowance.
289      *
290      * Requirements:
291      *
292      * - `spender` cannot be the zero address.
293      * - `spender` must have allowance for the caller of at least
294      * `subtractedValue`.
295      */
296     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
297         uint256 currentAllowance = _allowances[_msgSender()][spender];
298         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
299         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
300 
301         return true;
302     }
303 
304     /**
305      * @dev Moves tokens `amount` from `sender` to `recipient`.
306      *
307      * This is internal function is equivalent to {transfer}, and can be used to
308      * e.g. implement automatic token fees, slashing mechanisms, etc.
309      *
310      * Emits a {Transfer} event.
311      *
312      * Requirements:
313      *
314      * - `sender` cannot be the zero address.
315      * - `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      */
318     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321 
322         _beforeTokenTransfer(sender, recipient, amount);
323 
324         uint256 senderBalance = _balances[sender];
325         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
326         _balances[sender] = senderBalance - amount;
327         _balances[recipient] += amount;
328 
329         emit Transfer(sender, recipient, amount);
330     }
331 
332     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
333      * the total supply.
334      *
335      * Emits a {Transfer} event with `from` set to the zero address.
336      *
337      * Requirements:
338      *
339      * - `to` cannot be the zero address.
340      */
341     function _mint(address account, uint256 amount) internal virtual {
342         require(account != address(0), "ERC20: mint to the zero address");
343 
344         _beforeTokenTransfer(address(0), account, amount);
345 
346         _totalSupply += amount;
347         _balances[account] += amount;
348         emit Transfer(address(0), account, amount);
349     }
350 
351     /**
352      * @dev Destroys `amount` tokens from `account`, reducing the
353      * total supply.
354      *
355      * Emits a {Transfer} event with `to` set to the zero address.
356      *
357      * Requirements:
358      *
359      * - `account` cannot be the zero address.
360      * - `account` must have at least `amount` tokens.
361      */
362     function _burn(address account, uint256 amount) internal virtual {
363         require(account != address(0), "ERC20: burn from the zero address");
364 
365         _beforeTokenTransfer(account, address(0), amount);
366 
367         uint256 accountBalance = _balances[account];
368         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
369         _balances[account] = accountBalance - amount;
370         _totalSupply -= amount;
371 
372         emit Transfer(account, address(0), amount);
373     }
374 
375     /**
376      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
377      *
378      * This internal function is equivalent to `approve`, and can be used to
379      * e.g. set automatic allowances for certain subsystems, etc.
380      *
381      * Emits an {Approval} event.
382      *
383      * Requirements:
384      *
385      * - `owner` cannot be the zero address.
386      * - `spender` cannot be the zero address.
387      */
388     function _approve(address owner, address spender, uint256 amount) internal virtual {
389         require(owner != address(0), "ERC20: approve from the zero address");
390         require(spender != address(0), "ERC20: approve to the zero address");
391 
392         _allowances[owner][spender] = amount;
393         emit Approval(owner, spender, amount);
394     }
395 
396     /**
397      * @dev Hook that is called before any transfer of tokens. This includes
398      * minting and burning.
399      *
400      * Calling conditions:
401      *
402      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
403      * will be to transferred to `to`.
404      * - when `from` is zero, `amount` tokens will be minted for `to`.
405      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
406      * - `from` and `to` are never both zero.
407      *
408      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
409      */
410     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
411 }
412 
413 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
414 
415 
416 
417 pragma solidity ^0.8.0;
418 
419 
420 /**
421  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
422  */
423 abstract contract ERC20Capped is ERC20 {
424     uint256 immutable private _cap;
425 
426     /**
427      * @dev Sets the value of the `cap`. This value is immutable, it can only be
428      * set once during construction.
429      */
430     constructor (uint256 cap_) {
431         require(cap_ > 0, "ERC20Capped: cap is 0");
432         _cap = cap_;
433     }
434 
435     /**
436      * @dev Returns the cap on the token's total supply.
437      */
438     function cap() public view virtual returns (uint256) {
439         return _cap;
440     }
441 
442     /**
443      * @dev See {ERC20-_mint}.
444      */
445     function _mint(address account, uint256 amount) internal virtual override {
446         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
447         super._mint(account, amount);
448     }
449 }
450 
451 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
452 
453 
454 
455 pragma solidity ^0.8.0;
456 
457 /**
458  * @dev Interface of the ERC165 standard, as defined in the
459  * https://eips.ethereum.org/EIPS/eip-165[EIP].
460  *
461  * Implementers can declare support of contract interfaces, which can then be
462  * queried by others ({ERC165Checker}).
463  *
464  * For an implementation, see {ERC165}.
465  */
466 interface IERC165 {
467     /**
468      * @dev Returns true if this contract implements the interface defined by
469      * `interfaceId`. See the corresponding
470      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
471      * to learn more about how these ids are created.
472      *
473      * This function call must use less than 30 000 gas.
474      */
475     function supportsInterface(bytes4 interfaceId) external view returns (bool);
476 }
477 
478 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
479 
480 
481 
482 pragma solidity ^0.8.0;
483 
484 
485 /**
486  * @dev Implementation of the {IERC165} interface.
487  *
488  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
489  * for the additional interface id that will be supported. For example:
490  *
491  * ```solidity
492  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
493  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
494  * }
495  * ```
496  *
497  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
498  */
499 abstract contract ERC165 is IERC165 {
500     /**
501      * @dev See {IERC165-supportsInterface}.
502      */
503     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
504         return interfaceId == type(IERC165).interfaceId;
505     }
506 }
507 
508 // File: @openzeppelin/contracts/access/AccessControl.sol
509 
510 
511 
512 pragma solidity ^0.8.0;
513 
514 
515 
516 /**
517  * @dev External interface of AccessControl declared to support ERC165 detection.
518  */
519 interface IAccessControl {
520     function hasRole(bytes32 role, address account) external view returns (bool);
521     function getRoleAdmin(bytes32 role) external view returns (bytes32);
522     function grantRole(bytes32 role, address account) external;
523     function revokeRole(bytes32 role, address account) external;
524     function renounceRole(bytes32 role, address account) external;
525 }
526 
527 /**
528  * @dev Contract module that allows children to implement role-based access
529  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
530  * members except through off-chain means by accessing the contract event logs. Some
531  * applications may benefit from on-chain enumerability, for those cases see
532  * {AccessControlEnumerable}.
533  *
534  * Roles are referred to by their `bytes32` identifier. These should be exposed
535  * in the external API and be unique. The best way to achieve this is by
536  * using `public constant` hash digests:
537  *
538  * ```
539  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
540  * ```
541  *
542  * Roles can be used to represent a set of permissions. To restrict access to a
543  * function call, use {hasRole}:
544  *
545  * ```
546  * function foo() public {
547  *     require(hasRole(MY_ROLE, msg.sender));
548  *     ...
549  * }
550  * ```
551  *
552  * Roles can be granted and revoked dynamically via the {grantRole} and
553  * {revokeRole} functions. Each role has an associated admin role, and only
554  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
555  *
556  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
557  * that only accounts with this role will be able to grant or revoke other
558  * roles. More complex role relationships can be created by using
559  * {_setRoleAdmin}.
560  *
561  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
562  * grant and revoke this role. Extra precautions should be taken to secure
563  * accounts that have been granted it.
564  */
565 abstract contract AccessControl is Context, IAccessControl, ERC165 {
566     struct RoleData {
567         mapping (address => bool) members;
568         bytes32 adminRole;
569     }
570 
571     mapping (bytes32 => RoleData) private _roles;
572 
573     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
574 
575     /**
576      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
577      *
578      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
579      * {RoleAdminChanged} not being emitted signaling this.
580      *
581      * _Available since v3.1._
582      */
583     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
584 
585     /**
586      * @dev Emitted when `account` is granted `role`.
587      *
588      * `sender` is the account that originated the contract call, an admin role
589      * bearer except when using {_setupRole}.
590      */
591     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
592 
593     /**
594      * @dev Emitted when `account` is revoked `role`.
595      *
596      * `sender` is the account that originated the contract call:
597      *   - if using `revokeRole`, it is the admin role bearer
598      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
599      */
600     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
601 
602     /**
603      * @dev See {IERC165-supportsInterface}.
604      */
605     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
606         return interfaceId == type(IAccessControl).interfaceId
607             || super.supportsInterface(interfaceId);
608     }
609 
610     /**
611      * @dev Returns `true` if `account` has been granted `role`.
612      */
613     function hasRole(bytes32 role, address account) public view override returns (bool) {
614         return _roles[role].members[account];
615     }
616 
617     /**
618      * @dev Returns the admin role that controls `role`. See {grantRole} and
619      * {revokeRole}.
620      *
621      * To change a role's admin, use {_setRoleAdmin}.
622      */
623     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
624         return _roles[role].adminRole;
625     }
626 
627     /**
628      * @dev Grants `role` to `account`.
629      *
630      * If `account` had not been already granted `role`, emits a {RoleGranted}
631      * event.
632      *
633      * Requirements:
634      *
635      * - the caller must have ``role``'s admin role.
636      */
637     function grantRole(bytes32 role, address account) public virtual override {
638         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
639 
640         _grantRole(role, account);
641     }
642 
643     /**
644      * @dev Revokes `role` from `account`.
645      *
646      * If `account` had been granted `role`, emits a {RoleRevoked} event.
647      *
648      * Requirements:
649      *
650      * - the caller must have ``role``'s admin role.
651      */
652     function revokeRole(bytes32 role, address account) public virtual override {
653         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
654 
655         _revokeRole(role, account);
656     }
657 
658     /**
659      * @dev Revokes `role` from the calling account.
660      *
661      * Roles are often managed via {grantRole} and {revokeRole}: this function's
662      * purpose is to provide a mechanism for accounts to lose their privileges
663      * if they are compromised (such as when a trusted device is misplaced).
664      *
665      * If the calling account had been granted `role`, emits a {RoleRevoked}
666      * event.
667      *
668      * Requirements:
669      *
670      * - the caller must be `account`.
671      */
672     function renounceRole(bytes32 role, address account) public virtual override {
673         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
674 
675         _revokeRole(role, account);
676     }
677 
678     /**
679      * @dev Grants `role` to `account`.
680      *
681      * If `account` had not been already granted `role`, emits a {RoleGranted}
682      * event. Note that unlike {grantRole}, this function doesn't perform any
683      * checks on the calling account.
684      *
685      * [WARNING]
686      * ====
687      * This function should only be called from the constructor when setting
688      * up the initial roles for the system.
689      *
690      * Using this function in any other way is effectively circumventing the admin
691      * system imposed by {AccessControl}.
692      * ====
693      */
694     function _setupRole(bytes32 role, address account) internal virtual {
695         _grantRole(role, account);
696     }
697 
698     /**
699      * @dev Sets `adminRole` as ``role``'s admin role.
700      *
701      * Emits a {RoleAdminChanged} event.
702      */
703     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
704         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
705         _roles[role].adminRole = adminRole;
706     }
707 
708     function _grantRole(bytes32 role, address account) private {
709         if (!hasRole(role, account)) {
710             _roles[role].members[account] = true;
711             emit RoleGranted(role, account, _msgSender());
712         }
713     }
714 
715     function _revokeRole(bytes32 role, address account) private {
716         if (hasRole(role, account)) {
717             _roles[role].members[account] = false;
718             emit RoleRevoked(role, account, _msgSender());
719         }
720     }
721 }
722 
723 // File: contracts/IMXToken.sol
724 
725 // SPDX-License-Identifier: UNLICENSED
726 pragma solidity ^0.8.0;
727 
728 
729 
730 
731 contract IMXToken is ERC20Capped, AccessControl {
732   bytes32 public constant MINTER_ROLE = keccak256('MINTER_ROLE');
733 
734   constructor(address minter) ERC20('Immutable X', 'IMX') ERC20Capped(2000000000000000000000000000) {
735     _setupRole(MINTER_ROLE, minter);
736   }
737 
738   modifier checkRole(
739     bytes32 role,
740     address account,
741     string memory message
742   ) {
743     require(hasRole(role, account), message);
744     _;
745   }
746 
747   function mint(address to, uint256 amount) external checkRole(MINTER_ROLE, msg.sender, 'Caller is not a minter') {
748     super._mint(to, amount);
749   }
750 }