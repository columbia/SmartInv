1 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
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
413 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
414 
415 
416 
417 pragma solidity ^0.8.0;
418 
419 
420 
421 /**
422  * @dev Extension of {ERC20} that allows token holders to destroy both their own
423  * tokens and those that they have an allowance for, in a way that can be
424  * recognized off-chain (via event analysis).
425  */
426 abstract contract ERC20Burnable is Context, ERC20 {
427     /**
428      * @dev Destroys `amount` tokens from the caller.
429      *
430      * See {ERC20-_burn}.
431      */
432     function burn(uint256 amount) public virtual {
433         _burn(_msgSender(), amount);
434     }
435 
436     /**
437      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
438      * allowance.
439      *
440      * See {ERC20-_burn} and {ERC20-allowance}.
441      *
442      * Requirements:
443      *
444      * - the caller must have allowance for ``accounts``'s tokens of at least
445      * `amount`.
446      */
447     function burnFrom(address account, uint256 amount) public virtual {
448         uint256 currentAllowance = allowance(account, _msgSender());
449         require(currentAllowance >= amount, "ERC20: burn amount exceeds allowance");
450         _approve(account, _msgSender(), currentAllowance - amount);
451         _burn(account, amount);
452     }
453 }
454 
455 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
456 
457 
458 
459 pragma solidity ^0.8.0;
460 
461 /**
462  * @dev Interface of the ERC165 standard, as defined in the
463  * https://eips.ethereum.org/EIPS/eip-165[EIP].
464  *
465  * Implementers can declare support of contract interfaces, which can then be
466  * queried by others ({ERC165Checker}).
467  *
468  * For an implementation, see {ERC165}.
469  */
470 interface IERC165 {
471     /**
472      * @dev Returns true if this contract implements the interface defined by
473      * `interfaceId`. See the corresponding
474      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
475      * to learn more about how these ids are created.
476      *
477      * This function call must use less than 30 000 gas.
478      */
479     function supportsInterface(bytes4 interfaceId) external view returns (bool);
480 }
481 
482 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
483 
484 
485 
486 pragma solidity ^0.8.0;
487 
488 
489 /**
490  * @dev Implementation of the {IERC165} interface.
491  *
492  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
493  * for the additional interface id that will be supported. For example:
494  *
495  * ```solidity
496  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
497  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
498  * }
499  * ```
500  *
501  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
502  */
503 abstract contract ERC165 is IERC165 {
504     /**
505      * @dev See {IERC165-supportsInterface}.
506      */
507     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
508         return interfaceId == type(IERC165).interfaceId;
509     }
510 }
511 
512 // File: @openzeppelin/contracts/access/AccessControl.sol
513 
514 
515 
516 pragma solidity ^0.8.0;
517 
518 
519 
520 /**
521  * @dev External interface of AccessControl declared to support ERC165 detection.
522  */
523 interface IAccessControl {
524     function hasRole(bytes32 role, address account) external view returns (bool);
525     function getRoleAdmin(bytes32 role) external view returns (bytes32);
526     function grantRole(bytes32 role, address account) external;
527     function revokeRole(bytes32 role, address account) external;
528     function renounceRole(bytes32 role, address account) external;
529 }
530 
531 /**
532  * @dev Contract module that allows children to implement role-based access
533  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
534  * members except through off-chain means by accessing the contract event logs. Some
535  * applications may benefit from on-chain enumerability, for those cases see
536  * {AccessControlEnumerable}.
537  *
538  * Roles are referred to by their `bytes32` identifier. These should be exposed
539  * in the external API and be unique. The best way to achieve this is by
540  * using `public constant` hash digests:
541  *
542  * ```
543  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
544  * ```
545  *
546  * Roles can be used to represent a set of permissions. To restrict access to a
547  * function call, use {hasRole}:
548  *
549  * ```
550  * function foo() public {
551  *     require(hasRole(MY_ROLE, msg.sender));
552  *     ...
553  * }
554  * ```
555  *
556  * Roles can be granted and revoked dynamically via the {grantRole} and
557  * {revokeRole} functions. Each role has an associated admin role, and only
558  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
559  *
560  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
561  * that only accounts with this role will be able to grant or revoke other
562  * roles. More complex role relationships can be created by using
563  * {_setRoleAdmin}.
564  *
565  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
566  * grant and revoke this role. Extra precautions should be taken to secure
567  * accounts that have been granted it.
568  */
569 abstract contract AccessControl is Context, IAccessControl, ERC165 {
570     struct RoleData {
571         mapping (address => bool) members;
572         bytes32 adminRole;
573     }
574 
575     mapping (bytes32 => RoleData) private _roles;
576 
577     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
578 
579     /**
580      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
581      *
582      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
583      * {RoleAdminChanged} not being emitted signaling this.
584      *
585      * _Available since v3.1._
586      */
587     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
588 
589     /**
590      * @dev Emitted when `account` is granted `role`.
591      *
592      * `sender` is the account that originated the contract call, an admin role
593      * bearer except when using {_setupRole}.
594      */
595     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
596 
597     /**
598      * @dev Emitted when `account` is revoked `role`.
599      *
600      * `sender` is the account that originated the contract call:
601      *   - if using `revokeRole`, it is the admin role bearer
602      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
603      */
604     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
605 
606     /**
607      * @dev See {IERC165-supportsInterface}.
608      */
609     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
610         return interfaceId == type(IAccessControl).interfaceId
611             || super.supportsInterface(interfaceId);
612     }
613 
614     /**
615      * @dev Returns `true` if `account` has been granted `role`.
616      */
617     function hasRole(bytes32 role, address account) public view override returns (bool) {
618         return _roles[role].members[account];
619     }
620 
621     /**
622      * @dev Returns the admin role that controls `role`. See {grantRole} and
623      * {revokeRole}.
624      *
625      * To change a role's admin, use {_setRoleAdmin}.
626      */
627     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
628         return _roles[role].adminRole;
629     }
630 
631     /**
632      * @dev Grants `role` to `account`.
633      *
634      * If `account` had not been already granted `role`, emits a {RoleGranted}
635      * event.
636      *
637      * Requirements:
638      *
639      * - the caller must have ``role``'s admin role.
640      */
641     function grantRole(bytes32 role, address account) public virtual override {
642         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
643 
644         _grantRole(role, account);
645     }
646 
647     /**
648      * @dev Revokes `role` from `account`.
649      *
650      * If `account` had been granted `role`, emits a {RoleRevoked} event.
651      *
652      * Requirements:
653      *
654      * - the caller must have ``role``'s admin role.
655      */
656     function revokeRole(bytes32 role, address account) public virtual override {
657         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
658 
659         _revokeRole(role, account);
660     }
661 
662     /**
663      * @dev Revokes `role` from the calling account.
664      *
665      * Roles are often managed via {grantRole} and {revokeRole}: this function's
666      * purpose is to provide a mechanism for accounts to lose their privileges
667      * if they are compromised (such as when a trusted device is misplaced).
668      *
669      * If the calling account had been granted `role`, emits a {RoleRevoked}
670      * event.
671      *
672      * Requirements:
673      *
674      * - the caller must be `account`.
675      */
676     function renounceRole(bytes32 role, address account) public virtual override {
677         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
678 
679         _revokeRole(role, account);
680     }
681 
682     /**
683      * @dev Grants `role` to `account`.
684      *
685      * If `account` had not been already granted `role`, emits a {RoleGranted}
686      * event. Note that unlike {grantRole}, this function doesn't perform any
687      * checks on the calling account.
688      *
689      * [WARNING]
690      * ====
691      * This function should only be called from the constructor when setting
692      * up the initial roles for the system.
693      *
694      * Using this function in any other way is effectively circumventing the admin
695      * system imposed by {AccessControl}.
696      * ====
697      */
698     function _setupRole(bytes32 role, address account) internal virtual {
699         _grantRole(role, account);
700     }
701 
702     /**
703      * @dev Sets `adminRole` as ``role``'s admin role.
704      *
705      * Emits a {RoleAdminChanged} event.
706      */
707     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
708         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
709         _roles[role].adminRole = adminRole;
710     }
711 
712     function _grantRole(bytes32 role, address account) private {
713         if (!hasRole(role, account)) {
714             _roles[role].members[account] = true;
715             emit RoleGranted(role, account, _msgSender());
716         }
717     }
718 
719     function _revokeRole(bytes32 role, address account) private {
720         if (hasRole(role, account)) {
721             _roles[role].members[account] = false;
722             emit RoleRevoked(role, account, _msgSender());
723         }
724     }
725 }
726 
727 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
728 
729 
730 
731 pragma solidity ^0.8.0;
732 
733 /**
734  * @dev Library for managing
735  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
736  * types.
737  *
738  * Sets have the following properties:
739  *
740  * - Elements are added, removed, and checked for existence in constant time
741  * (O(1)).
742  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
743  *
744  * ```
745  * contract Example {
746  *     // Add the library methods
747  *     using EnumerableSet for EnumerableSet.AddressSet;
748  *
749  *     // Declare a set state variable
750  *     EnumerableSet.AddressSet private mySet;
751  * }
752  * ```
753  *
754  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
755  * and `uint256` (`UintSet`) are supported.
756  */
757 library EnumerableSet {
758     // To implement this library for multiple types with as little code
759     // repetition as possible, we write it in terms of a generic Set type with
760     // bytes32 values.
761     // The Set implementation uses private functions, and user-facing
762     // implementations (such as AddressSet) are just wrappers around the
763     // underlying Set.
764     // This means that we can only create new EnumerableSets for types that fit
765     // in bytes32.
766 
767     struct Set {
768         // Storage of set values
769         bytes32[] _values;
770 
771         // Position of the value in the `values` array, plus 1 because index 0
772         // means a value is not in the set.
773         mapping (bytes32 => uint256) _indexes;
774     }
775 
776     /**
777      * @dev Add a value to a set. O(1).
778      *
779      * Returns true if the value was added to the set, that is if it was not
780      * already present.
781      */
782     function _add(Set storage set, bytes32 value) private returns (bool) {
783         if (!_contains(set, value)) {
784             set._values.push(value);
785             // The value is stored at length-1, but we add 1 to all indexes
786             // and use 0 as a sentinel value
787             set._indexes[value] = set._values.length;
788             return true;
789         } else {
790             return false;
791         }
792     }
793 
794     /**
795      * @dev Removes a value from a set. O(1).
796      *
797      * Returns true if the value was removed from the set, that is if it was
798      * present.
799      */
800     function _remove(Set storage set, bytes32 value) private returns (bool) {
801         // We read and store the value's index to prevent multiple reads from the same storage slot
802         uint256 valueIndex = set._indexes[value];
803 
804         if (valueIndex != 0) { // Equivalent to contains(set, value)
805             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
806             // the array, and then remove the last element (sometimes called as 'swap and pop').
807             // This modifies the order of the array, as noted in {at}.
808 
809             uint256 toDeleteIndex = valueIndex - 1;
810             uint256 lastIndex = set._values.length - 1;
811 
812             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
813             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
814 
815             bytes32 lastvalue = set._values[lastIndex];
816 
817             // Move the last value to the index where the value to delete is
818             set._values[toDeleteIndex] = lastvalue;
819             // Update the index for the moved value
820             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
821 
822             // Delete the slot where the moved value was stored
823             set._values.pop();
824 
825             // Delete the index for the deleted slot
826             delete set._indexes[value];
827 
828             return true;
829         } else {
830             return false;
831         }
832     }
833 
834     /**
835      * @dev Returns true if the value is in the set. O(1).
836      */
837     function _contains(Set storage set, bytes32 value) private view returns (bool) {
838         return set._indexes[value] != 0;
839     }
840 
841     /**
842      * @dev Returns the number of values on the set. O(1).
843      */
844     function _length(Set storage set) private view returns (uint256) {
845         return set._values.length;
846     }
847 
848    /**
849     * @dev Returns the value stored at position `index` in the set. O(1).
850     *
851     * Note that there are no guarantees on the ordering of values inside the
852     * array, and it may change when more values are added or removed.
853     *
854     * Requirements:
855     *
856     * - `index` must be strictly less than {length}.
857     */
858     function _at(Set storage set, uint256 index) private view returns (bytes32) {
859         require(set._values.length > index, "EnumerableSet: index out of bounds");
860         return set._values[index];
861     }
862 
863     // Bytes32Set
864 
865     struct Bytes32Set {
866         Set _inner;
867     }
868 
869     /**
870      * @dev Add a value to a set. O(1).
871      *
872      * Returns true if the value was added to the set, that is if it was not
873      * already present.
874      */
875     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
876         return _add(set._inner, value);
877     }
878 
879     /**
880      * @dev Removes a value from a set. O(1).
881      *
882      * Returns true if the value was removed from the set, that is if it was
883      * present.
884      */
885     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
886         return _remove(set._inner, value);
887     }
888 
889     /**
890      * @dev Returns true if the value is in the set. O(1).
891      */
892     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
893         return _contains(set._inner, value);
894     }
895 
896     /**
897      * @dev Returns the number of values in the set. O(1).
898      */
899     function length(Bytes32Set storage set) internal view returns (uint256) {
900         return _length(set._inner);
901     }
902 
903    /**
904     * @dev Returns the value stored at position `index` in the set. O(1).
905     *
906     * Note that there are no guarantees on the ordering of values inside the
907     * array, and it may change when more values are added or removed.
908     *
909     * Requirements:
910     *
911     * - `index` must be strictly less than {length}.
912     */
913     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
914         return _at(set._inner, index);
915     }
916 
917     // AddressSet
918 
919     struct AddressSet {
920         Set _inner;
921     }
922 
923     /**
924      * @dev Add a value to a set. O(1).
925      *
926      * Returns true if the value was added to the set, that is if it was not
927      * already present.
928      */
929     function add(AddressSet storage set, address value) internal returns (bool) {
930         return _add(set._inner, bytes32(uint256(uint160(value))));
931     }
932 
933     /**
934      * @dev Removes a value from a set. O(1).
935      *
936      * Returns true if the value was removed from the set, that is if it was
937      * present.
938      */
939     function remove(AddressSet storage set, address value) internal returns (bool) {
940         return _remove(set._inner, bytes32(uint256(uint160(value))));
941     }
942 
943     /**
944      * @dev Returns true if the value is in the set. O(1).
945      */
946     function contains(AddressSet storage set, address value) internal view returns (bool) {
947         return _contains(set._inner, bytes32(uint256(uint160(value))));
948     }
949 
950     /**
951      * @dev Returns the number of values in the set. O(1).
952      */
953     function length(AddressSet storage set) internal view returns (uint256) {
954         return _length(set._inner);
955     }
956 
957    /**
958     * @dev Returns the value stored at position `index` in the set. O(1).
959     *
960     * Note that there are no guarantees on the ordering of values inside the
961     * array, and it may change when more values are added or removed.
962     *
963     * Requirements:
964     *
965     * - `index` must be strictly less than {length}.
966     */
967     function at(AddressSet storage set, uint256 index) internal view returns (address) {
968         return address(uint160(uint256(_at(set._inner, index))));
969     }
970 
971 
972     // UintSet
973 
974     struct UintSet {
975         Set _inner;
976     }
977 
978     /**
979      * @dev Add a value to a set. O(1).
980      *
981      * Returns true if the value was added to the set, that is if it was not
982      * already present.
983      */
984     function add(UintSet storage set, uint256 value) internal returns (bool) {
985         return _add(set._inner, bytes32(value));
986     }
987 
988     /**
989      * @dev Removes a value from a set. O(1).
990      *
991      * Returns true if the value was removed from the set, that is if it was
992      * present.
993      */
994     function remove(UintSet storage set, uint256 value) internal returns (bool) {
995         return _remove(set._inner, bytes32(value));
996     }
997 
998     /**
999      * @dev Returns true if the value is in the set. O(1).
1000      */
1001     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1002         return _contains(set._inner, bytes32(value));
1003     }
1004 
1005     /**
1006      * @dev Returns the number of values on the set. O(1).
1007      */
1008     function length(UintSet storage set) internal view returns (uint256) {
1009         return _length(set._inner);
1010     }
1011 
1012    /**
1013     * @dev Returns the value stored at position `index` in the set. O(1).
1014     *
1015     * Note that there are no guarantees on the ordering of values inside the
1016     * array, and it may change when more values are added or removed.
1017     *
1018     * Requirements:
1019     *
1020     * - `index` must be strictly less than {length}.
1021     */
1022     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1023         return uint256(_at(set._inner, index));
1024     }
1025 }
1026 
1027 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
1028 
1029 
1030 
1031 pragma solidity ^0.8.0;
1032 
1033 
1034 
1035 /**
1036  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
1037  */
1038 interface IAccessControlEnumerable {
1039     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
1040     function getRoleMemberCount(bytes32 role) external view returns (uint256);
1041 }
1042 
1043 /**
1044  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
1045  */
1046 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
1047     using EnumerableSet for EnumerableSet.AddressSet;
1048 
1049     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
1050 
1051     /**
1052      * @dev See {IERC165-supportsInterface}.
1053      */
1054     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1055         return interfaceId == type(IAccessControlEnumerable).interfaceId
1056             || super.supportsInterface(interfaceId);
1057     }
1058 
1059     /**
1060      * @dev Returns one of the accounts that have `role`. `index` must be a
1061      * value between 0 and {getRoleMemberCount}, non-inclusive.
1062      *
1063      * Role bearers are not sorted in any particular way, and their ordering may
1064      * change at any point.
1065      *
1066      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1067      * you perform all queries on the same block. See the following
1068      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1069      * for more information.
1070      */
1071     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
1072         return _roleMembers[role].at(index);
1073     }
1074 
1075     /**
1076      * @dev Returns the number of accounts that have `role`. Can be used
1077      * together with {getRoleMember} to enumerate all bearers of a role.
1078      */
1079     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
1080         return _roleMembers[role].length();
1081     }
1082 
1083     /**
1084      * @dev Overload {grantRole} to track enumerable memberships
1085      */
1086     function grantRole(bytes32 role, address account) public virtual override {
1087         super.grantRole(role, account);
1088         _roleMembers[role].add(account);
1089     }
1090 
1091     /**
1092      * @dev Overload {revokeRole} to track enumerable memberships
1093      */
1094     function revokeRole(bytes32 role, address account) public virtual override {
1095         super.revokeRole(role, account);
1096         _roleMembers[role].remove(account);
1097     }
1098 
1099     /**
1100      * @dev Overload {renounceRole} to track enumerable memberships
1101      */
1102     function renounceRole(bytes32 role, address account) public virtual override {
1103         super.renounceRole(role, account);
1104         _roleMembers[role].remove(account);
1105     }
1106 
1107     /**
1108      * @dev Overload {_setupRole} to track enumerable memberships
1109      */
1110     function _setupRole(bytes32 role, address account) internal virtual override {
1111         super._setupRole(role, account);
1112         _roleMembers[role].add(account);
1113     }
1114 }
1115 
1116 // File: contracts/RewardsToken.sol
1117 
1118 
1119 
1120 pragma solidity ^0.8.0;
1121 
1122 
1123 
1124 
1125 
1126 /**
1127  * @dev {ERC20} token, including:
1128  *
1129  *  - ability for holders to burn (destroy) their tokens
1130  *  - a minter role that allows for token minting (creation)
1131  *
1132  * This contract uses {AccessControl} to lock permissioned functions using the
1133  * different roles - head to its documentation for details.
1134  *
1135  * The account that deploys the contract will be granted the minter
1136  * role, as well as the default admin role, which will let it grant the minter
1137  * role to other accounts.
1138  */
1139 contract RewardsToken is Context, AccessControlEnumerable, ERC20Burnable {
1140     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1141 
1142     /**
1143      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE` to the
1144      * account that deploys the contract.
1145      *
1146      * See {ERC20-constructor}.
1147      */
1148     constructor(string memory name, string memory symbol) ERC20(name, symbol) {
1149         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1150 
1151         _setupRole(MINTER_ROLE, _msgSender());
1152     }
1153 
1154     /**
1155      * @dev Creates `amount` new tokens for `to`.
1156      *
1157      * See {ERC20-_mint}.
1158      *
1159      * Requirements:
1160      *
1161      * - the caller must have the `MINTER_ROLE`.
1162      */
1163     function mint(address to, uint256 amount) public virtual {
1164         require(hasRole(MINTER_ROLE, _msgSender()), "RewardsToken: must have minter role to mint");
1165         _mint(to, amount);
1166     }
1167 
1168     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20) {
1169         super._beforeTokenTransfer(from, to, amount);
1170     }
1171 }